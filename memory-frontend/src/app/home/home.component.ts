import { Component, OnInit } from '@angular/core';

import { ChannelService } from './../services/channel.service';

import { Player } from './../models/index';
import { Router } from '@angular/router';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  player: Player

  constructor(private channelService: ChannelService, private router: Router) {
    this.player = new Player("0", "");
  }

  ngOnInit(): void {
  }

  startGame(playerName: String) {
    if (playerName != "") {
      this.channelService.player_name = playerName;
      this.router.navigate(["/lobby"]);
    }
  }

}
