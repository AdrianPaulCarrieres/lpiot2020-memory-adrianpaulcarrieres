defmodule MemoryBackend.Game do
    @moduledoc """
    Defining game.
    """

    defstruct id: "000000", deck: %MemoryBackend.Model.Deck{}, players: [], cards_list: [], flipped_count: 0, turn_count: 0
    
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
                game = %MemoryBackend.Game{game | players: players_list ++ [player] }
                {:ok, game}
        end   
    end

    @doc """
    Création de la liste de carte
    """
    def populate_cards_list(game = %MemoryBackend.Game{deck: deck}) do
        MemoryBackend.Model.Deck.get_associated_cards(deck)
        IO.puts "facile"
    end
end