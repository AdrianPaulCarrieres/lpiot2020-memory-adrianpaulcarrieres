defmodule MemoryBackend.GameStoreTest do
  use ExUnit.Case, async: true

  test "add player to the game" do
    {:ok, game_store} = MemoryBackend.GameStore.start_link([])

    game = MemoryBackend.GameStore.get(game_store)
    assert game == %MemoryBackend.Game{}

    {:ok, game} = MemoryBackend.Game.join(game, "Adrian")

    MemoryBackend.GameStore.set(game_store, game)

    assert MemoryBackend.GameStore.get(game_store) == %MemoryBackend.Game{players: ["Adrian"]}
  end
end
