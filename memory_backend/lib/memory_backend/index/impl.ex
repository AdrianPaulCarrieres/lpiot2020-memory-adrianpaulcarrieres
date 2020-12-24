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
end
