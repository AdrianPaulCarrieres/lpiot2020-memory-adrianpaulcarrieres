defmodule MemoryBackend.Game do
    defstruct identifiant: "000000", set: "", etat: "en_attente", joueurs: [], liste_carte: [], nombre_retournement: 0, nombre_tours: 0

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