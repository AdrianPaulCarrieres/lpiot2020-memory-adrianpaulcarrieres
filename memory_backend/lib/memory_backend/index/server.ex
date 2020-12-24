defmodule MemoryBackend.Index.Server do
  @moduledoc """
  GenServer callbacks
  """
  use GenServer

  @impl true
  @doc """
  Initial state of our registry server.
  """
  def init(:ok) do
    {:ok, %{}}
  end
end
