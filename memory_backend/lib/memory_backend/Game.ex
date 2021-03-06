defmodule MemoryBackend.Game do
  @moduledoc """
  Defining game.
  """

  @derive {Jason.Encoder,
           only: [
             :id,
             :deck,
             :state,
             :players,
             :cards_list,
             :last_flipped_indexes,
             :turn_count,
             :flipped_count
           ]}

  defstruct id: "000000",
            deck: %MemoryBackend.Model.Deck{},
            state: :stand_by,
            players: [],
            cards_list: [],
            last_flipped_indexes: {},
            turn_count: 0,
            flipped_count: 0,
            consecutive_afk_players: 0

  @doc """
  Add player to a game.
  Player pseudo should be unique.

  ## Examples

      iex> {:ok, game} = MemoryBackend.Game.join(%MemoryBackend.Game{}, 'Adrian')
      iex> MemoryBackend.Game.join(game, 'Adrian')
      {:error, "Player Adrian already present in this game."}

  """
  def join(game = %MemoryBackend.Game{}, player) do
    players_list = game.players

    case Enum.any?(players_list, &(&1 == player)) do
      true ->
        {:error, "Player #{player} already present in this game."}

      false ->
        game = %MemoryBackend.Game{game | players: players_list ++ [player]}
        {:ok, game}
    end
  end

  @doc """
  Populate the given game's cards list with the deck.

  It takes them from the associated deck in the database, duplicate and create a map for each card, with the image and the flipped state.
  """
  def populate_cards_list(game = %MemoryBackend.Game{deck: deck}) do
    deck = MemoryBackend.Model.get_deck!(deck.id)

    cards = deck.cards

    cards_list =
      Enum.map(cards, fn x ->
        [%{"id" => x.id, "flipped" => 0}, %{"id" => x.id, "flipped" => 0}]
      end)
      |> List.flatten()
      |> Enum.shuffle()

    # Strip deck from cards and scores to minimize the size of our struct in memory and over the network

    deck = %MemoryBackend.Model.Deck{deck | cards: [], card_back: "", scores: []}

    %MemoryBackend.Game{game | deck: deck, cards_list: cards_list}
  end

  def start_game(game = %MemoryBackend.Game{}) do
    %MemoryBackend.Game{game | state: :ongoing}
  end
end
