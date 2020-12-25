defmodule MemoryBackend.Index.Impl do
  alias MemoryBackend.Game

  @moduledoc """
  Implements the logic needed to manage our games.
  """

  @doc """
  Create the game with the given parameters.
  Because the player creating it is the first one to join it we can avoid using the join function.
  """
  def create_game(id, deck = %MemoryBackend.Model.Deck{}, player) do
    %Game{id: id, deck: deck, players: [player]}
    |> Game.populate_cards_list()
  end

  def start_game(game = %Game{}) do
    Game.start_game(game)
  end

  def next_turn(
        game = %Game{
          turn_count: turn_count,
          players: players,
          last_flipped_indexes: {first_index, second_index},
          cards_list: cards,
          flipped_count: flipped_count,
          state: state
        }
      ) do
    turn_count = turn_count + 1
    players = change_active_player(players)

    flipped_count = update_flipped_count(flipped_count, cards, {first_index, second_index})

    flipped_index = {}

    game = %Game{
      game
      | turn_count: turn_count,
        players: players,
        last_flipped_indexes: flipped_index,
        cards_list: cards,
        flipped_count: flipped_count
    }

    if flipped_count == length(cards) / 2 do
      state = :won
      game = %Game{game | state: state}
      {state, game}
    else
      {state, game}
    end
  end

  def next_turn(game = %Game{state: state}) do
    {state, game}
  end

  def skip_turn(
        game = %Game{
          turn_count: turn_count,
          players: players,
          cards_list: cards,
          flipped_count: flipped_count
        }
      ) do
    turn_count = turn_count + 1
    players = change_active_player(players)
    flipped_index = {}

    %Game{
      game
      | turn_count: turn_count,
        players: players,
        last_flipped_indexes: flipped_index,
        cards_list: cards,
        flipped_count: flipped_count
    }
  end

  def play_turn(
        game = %Game{
          players: players,
          cards_list: cards,
          last_flipped_indexes: last_flipped_indexes,
          turn_count: turn_count
        },
        active_player,
        card_index,
        turn
      ) do
    if turn_count == turn do
      case players do
        [^active_player | _] ->
          with {:ok, cards} <- flip_card(cards, card_index),
               last_flipped_indexes = Tuple.append(last_flipped_indexes, card_index),
               game = %Game{game | cards_list: cards, last_flipped_indexes: last_flipped_indexes},
               {status, game} = next_turn(game) do
            {:ok, {status, game}}
          else
            _error ->
              {:error, {:wrong_card, "This card is already flipped"}}
          end

        [_] ->
          {:error, {:wrong_player}}
      end
    else
      {:error, {:turn_passed, "Turn already passed"}}
    end
  end

  def flip_card(cards, card_index) do
    card = Enum.at(cards, card_index)

    if card["flipped"] == 0 do
      {:ok, List.replace_at(cards, card_index, %{card | "flipped" => 1})}
    else
      {:error, {:wrong_card, "This card is already flipped"}}
    end
  end

  def change_active_player(players) do
    [active_player | player_list] = players
    player_list ++ [active_player]
  end

  def compare_cards(cards, {first_index, second_index}) do
    Enum.at(cards, first_index)["id"] == Enum.at(cards, second_index)["id"]
  end

  def update_flipped_count(flipped_count, cards, {first_index, second_index}) do
    if(compare_cards(cards, {first_index, second_index})) do
      flipped_count + 1
    else
      flipped_count
    end
  end

  def end_game(%Game{state: :won, turn_count: score, deck: deck}) do
    score = %MemoryBackend.Model.Score{score: score, deck_id: deck.id}
    MemoryBackend.Repo.insert!(score)
  end
end
