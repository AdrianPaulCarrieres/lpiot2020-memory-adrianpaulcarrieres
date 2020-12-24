defmodule MemoryBackend.GameStore do
  use Agent

  @doc """
  Starts a new game store.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %MemoryBackend.Game{} end)
  end

  @doc """
  Get a game from the game store agent.
  """
  def get(pid) do
    Agent.get(
      pid,
      fn x -> x end
    )
  end

  @doc """
  Set game in game store agent
  """
  def set(pid, game = %MemoryBackend.Game{}) do
    Agent.update(pid, fn _old_game -> game end)
  end
end
