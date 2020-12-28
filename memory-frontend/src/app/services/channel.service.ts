import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable, Observer, of } from 'rxjs';

import * as Phoenix from 'phoenix';


import { Score } from '../models/score.model';
import { Deck } from '../models/deck.model';

@Injectable({
  providedIn: 'root'
})
export class ChannelService {

  public socket: any;
  public channel: any;
  public decks: [Deck];

  private topic: String = "";
  public player_name: String = "Your name here"
  public game;

  constructor() {
    this.connect();
  }

  connect(): void {
    this.socket = new Phoenix.Socket(environment.socket_endpoint + '/socket', { params: { player: this.player_name } });

    this.socket.connect();
  }

  join_lobby(): Observable<Score> {
    return new Observable((observer: Observer<Score>) => {
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
      if (this.socket.isConnected()) {
        this.channel.on("new_highscore", msg => {
          let score = Score.parse_score(msg);
          return observer.next(score);
        });
      }
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
        this.start_game();
      })
      .receive("error", err => alert(err))
      .receive("timeout", () => alert("timed out pushing"))

  }

  join_game(game_id: String){
    console.log("join game in service")
    this.channel = this.socket.channel("game:" + game_id);
    this.channel.join()
    .receive("ok", resp => {
      console.log("Joined game successfully");
      this.game = resp.game;
    })
  }




  start_game() {
    this.channel.push("start_game", {})
      .receive("ok", payload => console.log("phoenix replied:", payload))
      .receive("error", err => alert("Start game errored " + err))
      .receive("timeout", () => alert("timed out pushing"))
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
