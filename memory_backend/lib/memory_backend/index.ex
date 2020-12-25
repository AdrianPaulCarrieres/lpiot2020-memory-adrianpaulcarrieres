defmodule MemoryBackend.Index do
  @moduledoc """
  API of our GenServer serving as a game registry.
  """
  @server MemoryBackend.Index.Server

  @doc """
  Start the GenServer
  """
  def start_link(opts) do
    GenServer.start_link(@server, opts, name: @server)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  @doc """
  Create a new game and register it in our GenServer registry.

  Takes a player "host" pseudo and a deck to init the game.
  """
  def create_game(id, deck = %MemoryBackend.Model.Deck{}, player) do
    GenServer.call(@server, {:create_game, id, deck, player})
  end

  def find_game(id) do
    GenServer.call(@server, {:find_game, id})
  end

  def join_game(id, player) do
    GenServer.call(@server, {:join_game, id, player})
  end

  def start_game(id) do
    GenServer.call(@server, {:start_game, id})
  end
end
