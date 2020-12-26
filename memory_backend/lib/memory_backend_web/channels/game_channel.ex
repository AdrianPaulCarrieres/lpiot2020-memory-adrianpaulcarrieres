defmodule MemoryBackendWeb.GameChannel do
  use MemoryBackendWeb, :channel
  alias MemoryBackend.Index
  alias MemoryBackend.Model.Deck

  def join("game:general", _payload, socket) do
    decks = MemoryBackend.Model.list_decks_with_scores()

    topics = for deck_theme <- decks.theme, do: "game:#{deck_theme}"

    {:ok, %{decks: decks},
     socket
     |> assign(:topics, [])
     |> subscribe_to_high_scores_topics(topics)}
  end

  def join("game:" <> game_id, _params, socket) do
    player = socket.assigns.player

    case Index.join_game(game_id, player) do
      {:ok, game} ->
        broadcast!(socket, "new_player", %{game: game, player: socket.assigns.player})

        {:ok,
         socket
         |> unsubscribe_to_other_high_scores_topics(game.deck)}

      {:reconnect, game} ->
        socket = assign(socket, :game_id, game_id)

        {:ok, %{game: game},
         socket
         |> unsubscribe_to_other_high_scores_topics(game.deck)}

      {:error, :no_game} ->
        {:error, %{reason: "Game doesn't exists"}}
    end
  end

  def handle_in(
        "create_game",
        %{game_id: game_id, deck: deck = %Deck{}},
        socket = %Phoenix.Socket{topic: "game:general"}
      ) do
    case Index.create_game(game_id, deck, socket.assigns.player) do
      {:ok, game} ->
        {:reply, {:ok, game}, socket}

      {:error, msg} ->
        {:reply, {:error, msg}, socket}
    end
  end

  def handle_in("start_game", _payload, socket = %Phoenix.Socket{topic: "game:" <> game_id}) do
    case Index.start_game(game_id) do
      {:ok, game} ->
        broadcast!(socket, "start_game", %{game: game})
        {:noreply, socket}

      {:error, msg} ->
        {:reply, {:error, msg}, socket}
    end
  end

  def handle_in("find_game", _payload, socket = %Phoenix.Socket{topic: "game:" <> game_id}) do
    case Index.find_game(game_id) do
      {:ok, game} -> {:reply, {:ok, game}, socket}
      error_tuple -> {:reply, error_tuple, socket}
    end
  end

  def handle_in(
        "flip_card",
        {card_index, turn},
        socket = %Phoenix.Socket{topic: "game:" <> game_id}
      ) do
    active_player = socket.assigns.player

    case Index.flip_card(game_id, active_player, card_index, turn) do
      {:ok, {:ongoing, game}} ->
        broadcast!(socket, "turn_played", %{game: game})
        {:no_reply, socket}

      {:ok, {:won, score}} ->
        broadcast!(socket, "game_won", %{score: score})
        {:no_reply, socket}

      {:error, msg} ->
        {:reply, {:error, msg}, socket}
    end
  end

  defp subscribe_to_high_scores_topics(socket, topics) do
    Enum.reduce(topics, socket, fn topic, acc ->
      topics = acc.assigns.topics

      if topic in topics do
        acc
      else
        :ok = MemoryBackendWeb.Endpoint.subscribe(topic)
        assign(acc, :topics, [topic | topics])
      end
    end)
  end

  defp unsubscribe_to_other_high_scores_topics(socket, %Deck{theme: theme}) do
    Enum.reduce(
      socket.assign.topics,
      socket,
      fn topic_to_unsubscribe, acc ->
        topics = acc.assigns.topics

        if(topic_to_unsubscribe != "game:#{theme}") do
          topics = List.delete(topics, topic_to_unsubscribe)

          MemoryBackendWeb.Endpoint.unsubscribe(topic_to_unsubscribe)
          assign(acc, :topics, topics)
        else
          acc
        end
      end
    )
  end
end
