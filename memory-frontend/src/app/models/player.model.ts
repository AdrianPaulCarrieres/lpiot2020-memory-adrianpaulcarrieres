import { BaseModel } from './base.model';

export interface PlayerInterface {
    player_name: string
}

export class Player extends BaseModel implements PlayerInterface {

    player_name: string
    

    constructor(data?: any) {
        super(data);
        if(data.player_name){
            this.player_name = data.player_name;
        }
    }

    public static parse_players(data: [string]): [Player]{
        var players: [Player] = [null];
        for(var i = 0; i < data.length; i++){
            players.push(new Player(data[i]))
        }
        players.splice(0, 1);
        return players;
    }
}