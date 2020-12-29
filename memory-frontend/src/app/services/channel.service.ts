import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable, Observer } from 'rxjs';

import * as Phoenix from 'phoenix';

import { Deck } from '../models/deck.model';
import { Game } from '../models/game.model';

@Injectable({
  providedIn: 'root'
})
export class ChannelService {

  public socket: any;
  public channel: any;
  public decks: [Deck];

  private topic: String = "";
  public player_name: String = "Adrian"
  public game: Game;

  constructor() {
    this.connect();
  }

  connect(): void {
    this.socket = new Phoenix.Socket(environment.socket_endpoint + '/socket', { params: { player: this.player_name } });
    this.socket.connect();
  }

  join_lobby(): Observable<Deck> {
    return new Observable((observer: Observer<Deck>) => {
      this.channel = this.socket.channel('game:general');
      this.channel.join()
        .receive("ok", resp => {
          console.log("Joined successfully");
          this.topic = "game:general";
          this.decks = Deck.parse_decks(resp.decks);
          this.decks.forEach(element => {
            return observer.next(element);
          });
        })
        .receive("error", resp => {
          console.log("Unable to join", resp);
          return observer.error("unable to join");
        })
        .receive('timeout', () => {
          console.log("timeout")
          return observer.error("unable to join");
        });

      this.channel.on("new_highscore", resp => {
        let deck = Deck.parse_deck(resp.deck);
        return observer.next(deck);
      });
    });
  }

  create_game(game_id: String, deck_id: String): boolean {
    if (this.topic != "game:general") {
      this.join_lobby();
    }
    return this.channel.push("create_game", { game_id: game_id, deck_id: deck_id })
      .receive("ok", payload => {
        console.log("phoenix replied:", payload);
        return true;
      })
      .receive("error", err => {
        alert("Create game errored : " + err)
        return false;
      })

      .receive("timeout", () => {
        alert("Create game errored : timed out pushing")
        return false;
      })

  }

  join_game(game_id: String): Observable<Game> {
    return new Observable((observer: Observer<Game>) => {
      this.channel = this.socket.channel("game:" + game_id);
      this.channel.join()
        .receive("ok", resp => {
          console.log("Joined game successfully");
          this.topic = "game:" + game_id;
          this.game = Game.parse_game(resp.game);
          return observer.next(this.game);
        })
        .receive("error", resp => {
          console.log("Unable to join", resp);
          return observer.error("unable to join");
        })
        .receive('timeout', () => {
          console.log("timeout")
          return observer.error("unable to join");
        });

      this.channel.on("start_game", msg => {
        var game = Game.parse_game(msg.game);
        console.log("Game has been started : " + game.state);
        return observer.next(game);
      })

      this.channel.on("turn_played", msg => {
        var game = Game.parse_game(msg.game);

        console.log("turn has been played : " + game);
        return observer.next(game);
      })
      this.channel.onClose(() => {
        console.log("the channel has gone away gracefully")
        return observer.complete()
      })
      this.channel.on("disconnect", msg => {
        console.log("Game has been stopped. : " + msg)
        return observer.complete();
      });
    });
  }

  start_game() {
    this.channel.push("start_game", {})
      .receive("error", err => alert("Start Game : errored " + err))
  }

  get_game() {
    if (this.topic != "game:general") {
      this.channel.push("get_game", {})
        .receive("error", err => alert(err))
    } else {
      alert("Not in game");
    }
  }

  flip_card(card_index: Number, turn: Number) {
    if (this.topic != "game:general") {
      this.channel.push("flip_card", { card_index: card_index, turn: turn })
        .receive("error", err => alert(err))
    } else {
      alert("Not in game");
    }
  }

}
