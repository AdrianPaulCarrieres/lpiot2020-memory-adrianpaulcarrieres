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
          flipped_count: flipped_count
        }
      ) do
    turn_count = turn_count + 1
    [active_player, player_list] = players
    players = ([player_list] ++ [active_player]) |> List.flatten()

    flipped_count = update_flipped_count(flipped_count, cards, {first_index, second_index})

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

  def next_turn(
        game = %Game{
          turn_count: turn_count,
          players: players,
          last_flipped_indexes: {}
        }
      ) do
    turn_count = turn_count + 1
    [active_player, player_list] = players
    players = ([player_list] ++ [active_player]) |> List.flatten()

    flipped_index = {}

    %Game{
      game
      | turn_count: turn_count,
        players: players,
        last_flipped_indexes: flipped_index
    }
  end

  def compare_cards(cards = [], {first_index, second_index}) do
    cards[first_index]["id"] == cards[second_index]["id"]
  end

  def update_flipped_count(flipped_count, cards = [], {first_index, second_index}) do
    if(compare_cards(cards, {first_index, second_index})) do
      flipped_count + 1
    else
      flipped_count
    end
  end
end
