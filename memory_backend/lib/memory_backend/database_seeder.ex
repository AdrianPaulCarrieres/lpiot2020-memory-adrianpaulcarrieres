defmodule MemoryBackend.DatabaseSeeder do
  alias MemoryBackend.Model

  def seed() do
    load_gems()
  end

  defp load_gems() do
    theme = "Gems"
    cards_names = ["A", "B", "C", "D", "E", "F", "G", "H"]

    card_back = read_card_back(theme)

    cards =
      Enum.map(cards_names, fn card_name ->
        image = read_card(theme, card_name)
        %{image: image}
      end)

    players = Enum.map(1..4, fn _x -> %{player_name: "Your name belongs here"} end)

    scores = Enum.map(1..10, fn _x -> %{score: 999, players: players} end)

    attrs = %{theme: theme, card_back: card_back, cards: cards, scores: scores}

    Model.create_deck(attrs)
  end

  defp read_card_back(theme) do
    File.read!("decks/#{theme}/card_back.PNG")
  end

  defp read_card(theme, card_name) do
    File.read!("decks/#{theme}/cards/#{card_name}.PNG")
  end
end
