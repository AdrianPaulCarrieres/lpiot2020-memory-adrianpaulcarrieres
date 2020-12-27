import { BaseModel } from './base.model';

export interface CardInterface {
    deck_id: string
    image: string
}

export class Card extends BaseModel implements CardInterface {

    deck_id: string
    image: string
    

    constructor(data?: any) {
        super(data);
    }
}