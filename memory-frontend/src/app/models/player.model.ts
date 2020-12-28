export class Player {

    id: String
    player_name: String


    constructor(id: String, player_name: String) {
        this.id = id;
        this.player_name = player_name;
    }

    public static parse_players(array_to_parse: [any]): [Player] {
        var players: [Player] = [null];
        for (var i = 0; i < array_to_parse.length; i++) {
            var data = array_to_parse[i];
            players.push(new Player(data.id, data.player_name));
        }
        players.splice(0, 1);
        return players;
    }

    public static parse_player(data: any): Player {
        return new Player(data.id, data.player_name);
    }
}