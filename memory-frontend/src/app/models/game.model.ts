import { Deck } from './deck.model';
import { Player } from './player.model';
import { Card } from './card.model';

export class Game {



    id: String;
    deck: Deck;
    state: String;
    players: [Player];
    cards_list: [Card];
    last_flipped_indexes: [Number];
    turn_count: Number;
    flipped_count: Number;

    constructor(id: String,
        deck: Deck,
        state: String,
        players: [Player],
        cards_list: [Card],
        last_flipped_indexes: [Number],
        turn_count: Number,
        flipped_count: Number) {
            this.id = id;
            this.deck = deck;
            state: String;
            players: [Player];
            cards_list: [Card];
            last_flipped_indexes: [Number];
            turn_count: Number;
            flipped_count: Number;
    }

    public static parse_players(data: [string]): [Player] {
        var players: [Player] = [null];
        for (var i = 0; i < data.length; i++) {
            players.push(new Player(data[i]))
        }
        players.splice(0, 1);
        return players;
    }

    public static parse_player(data: String): Player {
        return new Player(data);
    }
}