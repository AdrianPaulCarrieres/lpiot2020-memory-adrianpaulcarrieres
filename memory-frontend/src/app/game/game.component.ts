import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-game',
  templateUrl: './game.component.html',
  styleUrls: ['./game.component.css']
})
export class GameComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }


  join_game() {
    if (this.game_id && this.game_id != "") {
      console.log(this.game_id);
      this.channelService.join_game(this.game_id);
    }
  }

}
