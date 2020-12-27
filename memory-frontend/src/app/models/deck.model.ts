import { BaseModel } from './base.model';
import {Score} from './score.model';
import {Card} from './card.model';

export interface DeckInterface {
    card_back: string
    scores: [Score]
    cards: [Card]
}

export class Deck extends BaseModel implements DeckInterface {

    card_back: string
    scores: [Score]
    cards: [Card]


    constructor(data?: any) {
        super(data);
    }
}