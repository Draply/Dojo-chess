use chess::models::player::Color;
use starknet::ContractAddress;

#[derive(Model, Drop, Serde)]
struct Game {
    #[key]
    game_id: u32,
    winner: Color,
    white: ContractAddress,
    black: ContractAddress
}

#[derive(Model, Drop, Serde, Copy)]
struct GameTurn {
    #[key]
    game_id: u32,
    player_color: Color,
    game_win: bool
}


trait GameTurnTrait {
    fn next_turn(self: @GameTurn) -> Color;
}
impl GameTurnImpl of GameTurnTrait {
    fn next_turn(self: @GameTurn) -> Color {
        match self.player_color {
            Color::White => Color::Black,
            Color::Black => Color::White,
            Color::None => panic(array!['Illegal turn'])
        }
    }
}