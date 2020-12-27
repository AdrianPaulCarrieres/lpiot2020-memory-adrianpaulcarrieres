import { BaseModel } from './base.model';

export interface CardInterface {
    image: string
}

export class Card extends BaseModel implements CardInterface {

    image: string


    constructor(data?: any) {
        super(data);
        if (data.image) {
            this.image = data.image;
        }
    }

    public static parse_image(array_to_parse: [string]): [Card] {
        var cards: [Card] = [null]
        for (var i = 0; i < array_to_parse.length; i++) {
            cards.push(new Card(array_to_parse[i]));
        }
        cards.splice(0, 1)
        return cards;
    }
}