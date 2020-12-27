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
  private player_name: String = "Your name here"

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

  create_game(game_id: String, deck: Deck) {
    this.channel.push("create_game", { game_id: game_id, deck_id: deck.id })
      .receive("ok", payload => console.log("phoenix replied:", payload))
      .receive("error", err => alert(err))
      .receive("timeout", () => alert("timed out pushing"))
  }

  start_game() {
    this.channel.push("start_game", {})
      .receive("ok", payload => console.log("phoenix replied:", payload))
      .receive("error", err => alert(err))
      .receive("timeout", () => alert("timed out pushing"))
  }

}
