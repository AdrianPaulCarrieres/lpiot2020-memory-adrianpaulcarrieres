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
      for (var i = 0; i < this.decks.length; i++) {
        if (this.decks[i].id == deck.id) {
          this.decks[i] = deck;
          flag = true;
          break;
        }
      }
      if (!flag) {
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
    }
  }

  join_game() {
    if (this.game_id && this.game_id != "") {
      
    }
  }

  deckClicked(index: any) {
    if (this.game_id && this.game_id != "") {
      var deck = this.decks[index];

      this.channelService.create_game(this.game_id, deck.id);
    }
  }
}
