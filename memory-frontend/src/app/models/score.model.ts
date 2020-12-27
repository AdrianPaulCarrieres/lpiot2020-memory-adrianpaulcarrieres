import { BaseModel } from './base.model';
import {Player} from './player.model';

export interface ScoreInterface {
    deck_id: string
    score: string
    players: [Player]
}

export class Score extends BaseModel implements ScoreInterface {

    deck_id: string
    score: string
    players: [Player]


    constructor(data?: any) {
        super(data);
    }
}