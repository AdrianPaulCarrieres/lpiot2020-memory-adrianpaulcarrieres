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
      });
  }
}
