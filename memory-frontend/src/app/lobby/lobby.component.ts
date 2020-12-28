import { Component, OnInit } from '@angular/core';
import { ChannelService } from './../services/channel.service';

import { Card, Deck } from '../models';
import { ApiService } from '../services/api-service/api.service';

@Component({
  selector: 'app-lobby',
  templateUrl: './lobby.component.html',
  styleUrls: ['./lobby.component.css'],
})
export class LobbyComponent implements OnInit {

  decks: [Deck]
  false_images: [Card]
  game_id: String

  constructor(private channelService: ChannelService, private apiService: ApiService) { }

  ngOnInit(): void {
    this.join_lobby();
  }

  private populate_false_images() {
    for (var i = 0; i < this.decks.length; i++) {
      var deck = this.decks[i];
      var card = new Card(deck.id, false);
      card.image = deck.card_back;
      if (!this.false_images) {
        this.false_images = [card]
      } else {

        this.false_images.push(card);
      }
    }
  }

  join_lobby(): void {
    this.channelService.join_lobby()
      .subscribe(deck => {
        console.log(deck);
        this.updateDecks(deck);
      });
  }

  updateDecks(deck: Deck) {
    if (this.decks) {
      var flag = false;
      for(var i = 0; i < this.decks.length; i++){
        if (this.decks[i].id == deck.id) {
          this.decks[i] = deck;
          flag = true;
          break;
        }
      }
      if(!flag){
        this.apiService.get_deck_image(deck.id).subscribe(resp => {
          deck.card_back = resp.card_back;
          this.decks.push(deck);
        });
      }
    }
    else {
      this.apiService.get_deck_image(deck.id).subscribe(resp => {
        console.log(resp);
        deck.card_back = resp.card_back;
      });
      this.decks = [deck];
      this.populate_false_images();
    }
  }

  create_game(game_id: String, deck_id: String) {
    this.channelService.create_game(game_id, deck_id);
  }

  join_game(game_id: String) {
    this.channelService.join_game(game_id);
  }

  start_game() {
    this.channelService.start_game();
  }

  deckClicked(index: Number) {
    this.channelService.create_game(this.game_id, index.toString());
  }
}
