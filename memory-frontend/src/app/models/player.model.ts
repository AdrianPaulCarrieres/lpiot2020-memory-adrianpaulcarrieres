import { BaseModel } from './base.model';

export interface PlayerInterface {
    score_id: string
    player_name: string
}

export class Player extends BaseModel implements PlayerInterface {

    score_id: string
    player_name: string
    

    constructor(data?: any) {
        super(data);
    }
}