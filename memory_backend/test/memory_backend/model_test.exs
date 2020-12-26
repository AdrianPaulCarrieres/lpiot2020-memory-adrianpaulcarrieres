defmodule MemoryBackend.ModelTest do
  use MemoryBackend.DataCase

  alias MemoryBackend.Model

  describe "decks" do
    alias MemoryBackend.Model.Deck

    @valid_attrs %{card_back: "some card_back", theme: "some theme"}
    @update_attrs %{card_back: "some updated card_back", theme: "some updated theme"}
    @invalid_attrs %{card_back: nil, theme: nil}

    def deck_fixture(attrs \\ %{}) do
      {:ok, deck} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Model.create_deck()

      deck
    end

    test "list_decks/0 returns all decks" do
      deck = deck_fixture()
      assert Model.list_decks() == [deck]
    end

    test "get_deck!/1 returns the deck with given id" do
      deck = deck_fixture()
      assert Model.get_deck!(deck.id) == deck
    end

    test "create_deck/1 with valid data creates a deck" do
      assert {:ok, %Deck{} = deck} = Model.create_deck(@valid_attrs)
      assert deck.card_back == "some card_back"
      assert deck.theme == "some theme"
    end

    test "create_deck/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_deck(@invalid_attrs)
    end

    test "update_deck/2 with valid data updates the deck" do
      deck = deck_fixture()
      assert {:ok, %Deck{} = deck} = Model.update_deck(deck, @update_attrs)
      assert deck.card_back == "some updated card_back"
      assert deck.theme == "some updated theme"
    end

    test "update_deck/2 with invalid data returns error changeset" do
      deck = deck_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_deck(deck, @invalid_attrs)
      assert deck == Model.get_deck!(deck.id)
    end

    test "delete_deck/1 deletes the deck" do
      deck = deck_fixture()
      assert {:ok, %Deck{}} = Model.delete_deck(deck)
      assert_raise Ecto.NoResultsError, fn -> Model.get_deck!(deck.id) end
    end

    test "change_deck/1 returns a deck changeset" do
      deck = deck_fixture()
      assert %Ecto.Changeset{} = Model.change_deck(deck)
    end
  end

  describe "cards" do
    alias MemoryBackend.Model.Card

    @valid_attrs %{image: "some image"}
    @update_attrs %{image: "some updated image"}
    @invalid_attrs %{image: nil}

    def card_fixture(attrs \\ %{}) do
      {:ok, card} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Model.create_card()

      card
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Model.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Model.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{} = card} = Model.create_card(@valid_attrs)
      assert card.image == "some image"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, %Card{} = card} = Model.update_card(card, @update_attrs)
      assert card.image == "some updated image"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_card(card, @invalid_attrs)
      assert card == Model.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Model.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Model.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Model.change_card(card)
    end
  end

  describe "scores" do
    alias MemoryBackend.Model.Score

    @valid_attrs %{score: 42}
    @update_attrs %{score: 43}
    @invalid_attrs %{score: nil}

    def score_fixture(attrs \\ %{}) do
      {:ok, score} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Model.create_score()

      score
    end

    test "list_scores/0 returns all scores" do
      score = score_fixture()
      assert Model.list_scores() == [score]
    end

    test "get_score!/1 returns the score with given id" do
      score = score_fixture()
      assert Model.get_score!(score.id) == score
    end

    test "create_score/1 with valid data creates a score" do
      assert {:ok, %Score{} = score} = Model.create_score(@valid_attrs)
      assert score.score == 42
    end

    test "create_score/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_score(@invalid_attrs)
    end

    test "update_score/2 with valid data updates the score" do
      score = score_fixture()
      assert {:ok, %Score{} = score} = Model.update_score(score, @update_attrs)
      assert score.score == 43
    end

    test "update_score/2 with invalid data returns error changeset" do
      score = score_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_score(score, @invalid_attrs)
      assert score == Model.get_score!(score.id)
    end

    test "delete_score/1 deletes the score" do
      score = score_fixture()
      assert {:ok, %Score{}} = Model.delete_score(score)
      assert_raise Ecto.NoResultsError, fn -> Model.get_score!(score.id) end
    end

    test "change_score/1 returns a score changeset" do
      score = score_fixture()
      assert %Ecto.Changeset{} = Model.change_score(score)
    end
  end

  describe "players" do
    alias MemoryBackend.Model.Player

    @valid_attrs %{player_name: "some player_name"}
    @update_attrs %{player_name: "some updated player_name"}
    @invalid_attrs %{player_name: nil}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Model.create_player()

      player
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Model.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Model.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Model.create_player(@valid_attrs)
      assert player.player_name == "some player_name"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, %Player{} = player} = Model.update_player(player, @update_attrs)
      assert player.player_name == "some updated player_name"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_player(player, @invalid_attrs)
      assert player == Model.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Model.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Model.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Model.change_player(player)
    end
  end
end
