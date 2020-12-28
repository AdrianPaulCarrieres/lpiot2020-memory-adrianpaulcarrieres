import { Component, OnInit } from '@angular/core';
import { ChannelService } from './../services/channel.service';

import { Score } from './../models/score.model';
import { Deck } from '../models';

@Component({
  selector: 'app-lobby',
  templateUrl: './lobby.component.html',
  styleUrls: ['./lobby.component.css']
})
export class LobbyComponent implements OnInit {

  scores: Score[]

  constructor(private channelService: ChannelService) { }

  ngOnInit(): void {
    this.join_lobby();
    this.create_game("123", "1");
    
    //this.start_game();
    //this.join_game("123");




    //this.join_game("123");
  }

  join_lobby(): void {
    this.channelService.join_lobby()
      .subscribe({
        next: function (score) {
          console.log("Score is " + score)
          this.scores = this.scores.append(score)
        }, error: function (errorMessage) {
          console.log("Recieved the error with following message: " + errorMessage);
        }, complete: function () {
          console.log("Observable has completed Execution");
        }
      })
  }



  create_game(game_id: String, deck_id: String) {
    if (this.scores != []) {
      this.channelService.create_game(game_id, deck_id);
    }
  }

  join_game(game_id: String) {
    this.channelService.join_game(game_id);
    
    console.log("join game is fucked up")
  }

  start_game(){
    this.channelService.start_game();
  }
}
