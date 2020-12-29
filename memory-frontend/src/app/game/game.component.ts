import { Component, OnInit } from '@angular/core';
import { Card, Deck, Game } from '../models';
import { ApiService } from '../services/api-service/api.service';
import { ChannelService } from '../services/channel.service';
import { ActivatedRoute } from '@angular/router';
import { ThrowStmt } from '@angular/compiler';

@Component({
  selector: 'app-game',
  templateUrl: './game.component.html',
  styleUrls: ['./game.component.css'],
})
export class GameComponent implements OnInit {

  game: Game;
  cards: [Card];
  deck: Deck;

  turn: String = "0";
  number_of_flipped_cards: Number;

  abonnement;

  constructor(private channelService: ChannelService, private apiService: ApiService, private route: ActivatedRoute) { }

  ngOnInit(): void {
    this.join_game();
  }


  join_game() {
    const game_id = this.route.snapshot.paramMap.get('game_id');


    /*this.abonnement = {
      next: x => {
        console.log(x)
        this.game = x;
        this.get_images();
      },
      error: err => console.error('Observer got an error: ' + err),
      complete: () => console.log('Observer got a complete notification'),
    };

    this.channelService.join_game(game_id).subscribe(this.abonnement);
    */


    this.channelService.join_game(game_id)
      .subscribe(game => {
        console.log("ingame, state game", game);
        this.game = game;
        this.turn = game.turn_count;
        this.get_images();
        return game;
      });
  }

  get_images() {
    console.log(this.game.deck.id);
    this.apiService.get_cards_image(this.game.deck.id).subscribe(resp => {
      this.deck = this.game.deck;
      this.deck.card_back = resp.card_back;


      var first_card_id = resp.cards[0].id;
      this.cards = this.game.cards_list;
      for (var i = 0; i < this.cards.length; i++) {
        var card = this.cards[i];
        var image = resp.cards[+card.id - +first_card_id].image
        card.set_image(image);
        this.cards[i] = card;

      }
    })
  }

  start_game() {
    if (this.game.state == "stand_by") {
      this.channelService.start_game();
    }
  }

  cardClicked(index) {
    console.log(this.game.state);
    if (this.game.state == "ongoing") {
      var active_player = this.game.players[0];
      console.log("card", this.game.cards_list[index]);
      console.log("front player", this.channelService.player_name);
      console.log("back player", active_player);
      if (this.channelService.player_name != active_player) {
        alert("Chacun son tour :p");
      } else if (!this.game.cards_list[index].flipped) {
        this.channelService.flip_card(index, this.game.turn_count);
      }
    }
  }
}
