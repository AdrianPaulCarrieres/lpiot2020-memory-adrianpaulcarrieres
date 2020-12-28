import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable, Observer } from 'rxjs';

import * as Phoenix from 'phoenix';


import { Score } from '../models/score.model';
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
  public player_name: String = "Your name here"
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
          this.decks = Deck.parse_decks(resp.decks);
          this.topic = "game:general";
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

  create_game(game_id: String, deck_id: String) {
    if (this.topic != "game:general") {
      this.join_lobby();
    }
    this.channel.push("create_game", { game_id: game_id, deck_id: deck_id })
      .receive("ok", payload => {
        console.log("phoenix replied:", payload);
        this.join_game(game_id);
      })
      .receive("error", err => alert(err))
      .receive("timeout", () => alert("timed out pushing"))

  }

  join_game(game_id: String): Observable<Game>{
    return new Observable((observer: Observer<Game>) => {
      this.channel = this.socket.channel("game:" + game_id);
      this.channel.join()
        .receive("ok", resp => {
          console.log("Joined game successfully");
          this.topic = "game:general";
          this.game = resp.game;
        })
        .receive("error", resp => {
          console.log("Unable to join", resp);
          return observer.error("unable to join");
        })
        .receive('timeout', () => {
          console.log("timeout")
          return observer.error("unable to join");
        });

      this.channel.on("disconnect", msg => {
        console.log("Game has been stopped. : " + msg)
        return observer.complete();
      });
    });
  }

  start_game() {
    this.channel.push("start_game", {})
      .receive("ok", payload => console.log("Start Game : phoenix replied: ", payload))
      .receive("error", err => alert("Start Game : errored " + err))
      .receive("timeout", () => alert("Start Game : timed out pushing"))
  }

  get_game() {
    if (this.topic != "game:general") {
      this.channel.push("get_game", {})
        .receive("ok", payload => console.log("phoenix replied:", payload))
        .receive("error", err => alert(err))
        .receive("timeout", () => alert("timed out pushing"))
    } else {
      alert("Not in game");
    }
  }

  flip_card(card_index: Number, turn: Number) {
    if (this.topic != "game:general") {
      this.channel.push("flip_card", { card_index: card_index, turn: turn })
        .receive("ok", payload => console.log("phoenix replied:", payload))
        .receive("error", err => alert(err))
        .receive("timeout", () => alert("timed out pushing"))
    } else {
      alert("Not in game");
    }
  }

}
