defmodule MemoryBackend.Index do
  @moduledoc """
  API of our GenServer serving as a game registry.
  """
  @server Index.Server

  @doc """
  Start the GenServer
  """
  def start_link(opts) do
    GenServer.start_link(@server, opts, name: @server)
  end

  @doc """
  Create a new game and register it in our GenServer registry.

  Takes a player "host" pseudo and a deck to init the game.
  """
  def create_game(deck = %MemoryBackend.Model.Deck{}, player) do
    GenServer.call(@server, {:create_game, deck, player})
  end
end
