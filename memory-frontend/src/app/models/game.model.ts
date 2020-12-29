import { Deck } from './deck.model';
import { Player } from './player.model';
import { Card } from './card.model';

export class Game {

    id: String;
    deck: Deck;
    state: String;
    players: [String];
    cards_list: [Card];
    last_flipped_indexes: [Number];
    turn_count: Number;
    flipped_count: Number;

    constructor(id: String,
        deck: Deck,
        state: String,
        players: [String],
        cards_list: [Card],
        last_flipped_indexes: [Number],
        turn_count: Number,
        flipped_count: Number) {
        this.id = id;
        this.deck = deck;
        this.state = state;
        this.players = players;
        this.cards_list = cards_list;
        this.last_flipped_indexes = last_flipped_indexes;
        this.turn_count = turn_count;
        this.flipped_count = flipped_count;
    }

    public static parse_game(message){
        return new Game(message.id, Deck.parse_deck(message.deck), message.state, message.players, Card.parse_cards(message.cards_list), message.last_flipped_indexes, message.turn_count, message.flipped_count)
    }
}