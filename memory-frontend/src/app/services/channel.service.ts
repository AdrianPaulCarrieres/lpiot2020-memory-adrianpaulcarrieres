import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable, Observer, of } from 'rxjs';

import * as Phoenix from 'phoenix';


import { Score } from '../models/score.model';
import { Deck} from '../models/deck.model';

@Injectable({
  providedIn: 'root'
})
export class ChannelService {

  public socket: any;
  public channel: any;

  constructor() {
    this.connect();
   }

  connect(): void{
    this.socket = new Phoenix.Socket(environment.socket_endpoint + '/socket', {params: {player: "123"}});

    this.socket.connect();
    console.log(this.socket.isConnected())
    this.join_lobby();
  }

  join_lobby(): Observable<Score>{
    return new Observable((observer: Observer<Score>) => {
      if (!this.socket.isConnected()) {
        this.channel = this.socket.channel('game:general');
        this.channel.join()
          .receive("ok", resp => {
            console.log("Joined successfully", resp);
          })
          .receive("error", resp => {
            console.log("Unable to join", resp);
            return observer.error("unable to join");
          })
          .receive('timeout', () => {
            console.log("timeout")
            return observer.error("unable to join"); 
          });

        this.channel.on("new_highscore", msg =>{
          let score = new Score(msg);
          return observer.next(score);
        });
      }
    });
  }

}
