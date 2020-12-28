import { Player } from './player.model';
export class Score{

    id: String;
    score: String;
    players: [Player];


    constructor(id: String, score: String, players: [Player]) {
        this.id = id;
        this.score = score;
        this.players = players;
    }

    public static parse_scores(array_to_parse: [any]): [Score] {
        var scores: [Score] = [null];
        for (var i = 0; i < data.length; i++) {
            var data = array_to_parse[i];
            scores.push(new Score(data.id, data.score, Player.parse_players(data.players)))
        }
        scores.splice(0, 1);
        return scores;
    }

    public static parse_score(data: any): Score{
        return new Score(data.id, data.score, Player.parse_players(data.players));
    }


}