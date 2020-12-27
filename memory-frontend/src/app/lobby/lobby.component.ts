import { Component, OnInit } from '@angular/core';
import { ChannelService } from './../services/channel.service';

import { Score } from './../models/score.model';

@Component({
  selector: 'app-lobby',
  templateUrl: './lobby.component.html',
  styleUrls: ['./lobby.component.css']
})
export class LobbyComponent implements OnInit {

  scores: Score[]

  constructor(private channelService: ChannelService) { }

  ngOnInit(): void {
    this.joinLobby();
  }

  joinLobby(): void {
    this.channelService.join_lobby()
      .subscribe({
        next: function (data) {
          console.log("Score is " + data)
          this.scores = this.scores.append(data)
        }, error: function (errorMessage) {
          console.log("Recieved the error with following message: " + errorMessage);
        }, complete: function () {
          console.log("Observable has completed Execution");
        }
      })
  }
}
