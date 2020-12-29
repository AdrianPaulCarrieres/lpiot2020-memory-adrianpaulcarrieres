import { Component, OnInit } from '@angular/core';
import { Game } from '../models';
import { ApiService } from '../services/api-service/api.service';
import { ChannelService } from '../services/channel.service';
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';

@Component({
  selector: 'app-game',
  templateUrl: './game.component.html',
  styleUrls: ['./game.component.css']
})
export class GameComponent implements OnInit {

  game: Game;

  constructor(private channelService: ChannelService, private apiService: ApiService, private route: ActivatedRoute,
    private location: Location) { }

  ngOnInit(): void {
    this.join_game();
  }


  join_game() {
    const game_id = this.route.snapshot.paramMap.get('game_id');
    this.channelService.join_game(game_id)
      .subscribe(game => {
        this.game = game;
        //this.get_images();
      });
  }

  get_images() {
    if ((!this.game.deck.card_back) || this.game.deck.card_back == "") {
      var deck = this.game.deck;
      this.apiService.get_deck_image(deck.id).subscribe(resp => {
        deck.card_back = resp.card_back;
        this.game.deck = deck;
      });

      var cards = this.game.cards_list;
      for (var i = 0; i < cards.length; i++) {
        var card = cards[i]
        this.apiService.get_card_image(deck.id, card.id).subscribe(resp => {
          card.image = resp.image;
          cards[i] = card;
        });
      }
    }
  }

  start_game() {
    if (this.game.state == "stand_by") {
      this.channelService.start_game();
    }
  }

  cardClicked(index) {
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
