import { Score } from './score.model';

export class Deck {

    id: String
    card_back: String
    scores: [Score]


    constructor(id: String, scores: [Score]) {
        this.id = id;
        this.scores = scores;
    }

    public static parse_decks(array_to_parse: [any]): [Deck] {
        var decks: [Deck] = [null]
        for (var i = 0; i < array_to_parse.length; i++) {
            var data = array_to_parse[i];
            decks.push(new Deck(data.id, Score.parse_scores(data.scores)));
        }
        decks.splice(0, 1)
        return decks;
    }

    public static parse_deck(data: any): Deck {
        return new Deck(data.id, Score.parse_scores(data.scores));
    }


}