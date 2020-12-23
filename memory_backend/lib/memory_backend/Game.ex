defmodule MemoryBackend.Game do
    @moduledoc """
    Définition d'une partie.
    """

    defstruct identifiant: "000000", set: "", joueurs: [], liste_carte: [], nombre_retournement: 0, nombre_tours: 0
    
    @doc """
    Ajouter un joueur à une partie.

    Le pseudo du joueur doit y être unique.

    ## Examples

        {:ok, partie} = MemoryBackend.Game.join(%MemoryBackend.Game{}, 'Adrian')
        MemoryBackend.Game.join(partie, 'Adrian')                                
        {:error, "Joueur Adrian deja present"}

    """
    def join(partie = %MemoryBackend.Game{}, joueur) do
        liste_joueurs = partie.joueurs
        case Enum.any?(liste_joueurs, &(&1 == joueur)) do
            true -> 
                {:error, "Joueur #{joueur} deja present"}
            false -> 
                partie = %MemoryBackend.Game{partie | joueurs: liste_joueurs ++ [joueur] }
                {:ok, partie}
        end   
    end
end