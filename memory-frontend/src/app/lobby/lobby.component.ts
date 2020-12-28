import { Component, OnInit } from '@angular/core';
import { ChannelService } from './../services/channel.service';

import { Card, Deck } from '../models';

@Component({
  selector: 'app-lobby',
  templateUrl: './lobby.component.html',
  styleUrls: ['./lobby.component.css']
})
export class LobbyComponent implements OnInit {

  decks: [Deck]
  false_images: [Card]
  game_id: String

  constructor(private channelService: ChannelService) { }

  ngOnInit(): void {
    this.join_lobby();
    this.decks = this.channelService.decks;
    this.populate_false_images();
  }

  private populate_false_images(){
    for(var i = 0; i < this.decks.length; i++){
      var deck = this.decks[i];
      var card = new Card(deck.id, false);
      card.image = deck.card_back;
      this.false_images.push(card);
    }
  }

  join_lobby(): void {
    this.channelService.join_lobby()
      .subscribe({
        next: function (deck: Deck) {
          this.updateDecks(deck);
        }, error: function (errorMessage) {
          console.log("Recieved the error with following message: " + errorMessage);
        }, complete: function () {
          console.log("Observable has completed Execution");
        }
      })
  }

  updateDecks(deck: Deck) {
    this.decks.forEach(element => {
      if(element.id == deck.id){
        element = deck;
      }
    });
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

  deckClicked(index: Number){
    this.channelService.create_game(this.game_id, index.toString());
  }
}
