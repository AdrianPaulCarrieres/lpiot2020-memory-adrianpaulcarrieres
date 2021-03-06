import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable, Observer } from 'rxjs';

import * as Phoenix from 'phoenix';

import { Deck } from '../models/deck.model';
import { Game } from '../models/game.model';
import { ThrowStmt } from '@angular/compiler';
import { delay } from 'rxjs/operators';

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

  public turn;

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
        var deck_id = resp.deck_id
        var score = resp.score

        console.log("New score for deck " + deck_id + " : " + score);
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
        this.game = game;
        return observer.next(this.game);
      })

      this.channel.on("turn_played", msg => {
        var game = Game.parse_game(msg.game);

        console.log("turn has been played : " + game);
        this.turn = game.turn_count;

        return observer.next(game);
      })
      this.channel.on("game_won", msg => {
        var score = msg.score;
        var high_score = msg.high_score

        var alert = "Vous avez gagné avec un score de " + score;
        alert += high_score ? ", et vous avez battu un score !" : ".";

        return observer.complete()
      })
      this.channel.onClose(() => {
        console.log("the channel has gone away gracefully")
        return observer.error("the channel has gone away gracefully")
      })
      this.channel.on("disconnect", msg => {
        console.log("Game has been stopped. : " + msg)
        return observer.complete()
      });
    });
  }

  start_game(){
    this.channel.push("start_game", {})
      .receive("error", err => alert("Start Game : errored " + err))
      .receive("ok", resp =>{
        console.log(resp);
      })
  }

  get_game() {
    if (this.topic != "game:general") {
      this.channel.push("get_game", {})
        .receive("error", err => alert(err))
    } else {
      alert("Not in game");
    }
  }

  flip_card(card_index: String, turn: String) {
    if (this.topic != "game:general") {
      this.channel.push("flip_card", { card_index: card_index, turn: turn })
        .receive("error", err => alert(err))
    } else {
      alert("Not in game");
    }
  }

}
