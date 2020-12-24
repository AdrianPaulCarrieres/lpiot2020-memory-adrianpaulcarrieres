defmodule MemoryBackend.Index.Server do
  @moduledoc """
  GenServer callbacks
  """
  use GenServer
  alias MemoryBackend.Index.Impl
  alias MemoryBackend.GameStore

  @impl true
  @doc """
  Initial state of our registry server.
  """
  def init([]) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:create_game, id, deck = %MemoryBackend.Model.Deck{}, player}, _from, games) do
    if Map.has_key?(games, id) do
      {:reply, "ID already in use.", games}
    else
      {:ok, game_agent} = MemoryBackend.GameStore.start_link([])
      game = Impl.create_game(id, deck, player)
      GameStore.set(game_agent, game)
      {:reply, game, Map.put(games, id, game_agent)}
    end
  end

  @impl true
  def handle_call({:find_game, id}, _from, games) do
    {:reply, Map.has_key?(games, id), games}
  end
end
