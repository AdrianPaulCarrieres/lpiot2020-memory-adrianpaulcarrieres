import { Component, OnInit } from '@angular/core';
import { Card, Deck, Game } from '../models';
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
  cards: [Card];
  deck: Deck;

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
        this.get_images();
      });
  }

  get_images() {
    if(!this.deck){
      console.log(this.game.deck.id);
      this.apiService.get_cards_image(this.game.deck.id).subscribe(resp =>{
        console.log("resp", resp);
        this.deck = this.game.deck;
        this.deck.card_back = resp.card_back;


        var first_card_id = resp.cards[0].id;
        this.cards = this.game.cards_list;
        for(var i = 0; i < this.cards.length; i++){
          var card = this.cards[i];
          //console.log("card.image", card);
          //card.image = resp.cards[+card.id + +first_card_id].image;
          var image = resp.cards[+card.id - +first_card_id].image
          console.log("image at", card.id);
          card.set_image(image);
          this.cards[i] = card;
        }
      })
    }
    for(var i = 0; i < this.game.cards_list.length; i++){
      this.game.cards_list[i].image = this.cards[i].image;
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
