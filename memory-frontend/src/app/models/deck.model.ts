import { BaseModel } from './base.model';
import {Score} from './score.model';
import {Card} from './card.model';

export interface DeckInterface {
    card_back: string
    scores: [Score]
}

export class Deck extends BaseModel implements DeckInterface {

    card_back: string
    scores: [Score]


    constructor(data?: any) {
        super(data);
        if(data.card_back){
            this.card_back = data.card_back;
        }
        if(data.scores){
            this.scores = Score.parse_scores(data.scores);
        }
    }

    public static parse_decks(array_to_parse: [string]): [Deck] {
        var decks: [Deck] = [null]
        for (var i = 0; i < array_to_parse.length; i++) {
          decks.push(new Deck(array_to_parse[i]));
        }
        decks.splice(0, 1)
        return decks;
      }

    
}