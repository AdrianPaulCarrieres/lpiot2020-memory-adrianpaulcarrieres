export class Card {

    id: String
    image: String
    flipped: boolean


    constructor(id: String, flipped: boolean) {
        this.id = id;
        this.flipped = flipped;
    }

    public static parse_cards(array_to_parse: [any]): [Card] {
        var cards: [Card] = [null]
        for (var i = 0; i < array_to_parse.length; i++) {
            var data = array_to_parse[i];
            cards.push(new Card(data.id, data.flipped));
        }
        cards.splice(0, 1)
        return cards;
    }

    public static parse_card(data: any): Card {
        return new Card(data.id, data.flipped);
    }
}