import { BaseModel } from './base.model';
import {Player} from './player.model';

export interface ScoreInterface {
    score: string
    players: [Player]
}

export class Score extends BaseModel implements ScoreInterface {

    score: string
    players: [Player]


    constructor(data?: any) {
        super(data);
        if(data.score){
            this.score = data.score;
        }
        if(data.players){
            this.players = Player.parse_players(data.players);
        }
    }

    public static parse_scores(data: [string]): [Score]{
        var scores: [Score] = [null];
        for(var i = 0; i < data.length; i++){
            scores.push(new Score(data[i]))
        }
        scores.splice(0, 1);
        return scores;
    }

    
}