use starknet::ContractAddress;
use chess::models::piece::Vec2;

#[dojo::interface]
trait IActions {
    fn move(curr_position: Vec2, next_position: Vec2, caller: ContractAddress, game_id: u32);
    fn spawn(white_address: ContractAddress, black_address: ContractAddress) -> u32;
    
    
}

#[dojo::contract] 
mod actions {
    use chess::models::player::{Player,Color,PlayerTrait};
    use chess::models::piece::{Piece,PieceType,PieceTrait};
    use chess::models::game::{Game,GameTurn,GameTurnTrait};
    use super::{ContractAddress,IActions,Vec2};

    #[abi(embed_v0)]
    impl IActionImpl of IActions<ContractState> {
       
        fn move(
            world: IWorldDispatcher,
            curr_position: Vec2,
            next_position: Vec2,
            caller: ContractAddress,
            game_id: u32
        ){  
            let mut game_turn = get!(world, game_id,(GameTurn));
            assert!(!game_turn.game_win,"Game ended");

            let mut current_piece = get!(world,(game_id,curr_position),(Piece));
            assert!(!PieceTrait::is_out_of_board(next_position), "Should be inside board");
            assert!(current_piece.is_right_piece_move(next_position), "Illegal move for type of piece");

            let mut next_position_piece = get!(world, (game_id, next_position), (Piece));

            let player = get!(world, (game_id, caller), (Player));

            assert!(
                next_position_piece.piece_type == PieceType::None
                    || player.is_not_my_piece(next_position_piece.color),
                "Already same color piece exist"
            );


            let mut result: bool = true;
            // Check the part is not occupied by another piece
            if current_piece.piece_type == PieceType::Queen || current_piece.piece_type == PieceType::Bishop || current_piece.piece_type == PieceType::Rook {
                let mut d = PieceTrait::get_distance(curr_position, next_position);
                let (top, right, down, left) = PieceTrait::get_direction(curr_position, next_position);
                let mut i =1;
                result = loop {
                    let mut x = 0;
                    let mut y=0;
                    if i > d-1 { break true; }    

                    if top > 0 {
                        y  = curr_position.y + i*top;
                    } 
                    if down > 0 {
                        y = curr_position.y - i*down;
                    }
                    if left > 0 {
                        x = curr_position.x - i*left;
                    }
                    if right > 0 {
                        x = curr_position.x + i*right;
                    }

                    let mut pos = Vec2{ x: x, y: y};
                  
                    let mut piece = get!(world, (game_id, pos), (Piece));
                            if piece.piece_type != PieceType::None {
                                break false;
                    }
                    i= i+1;
                }
            }
                
            assert!(result,"Cant move");

            if next_position_piece.piece_type == PieceType::King {
                game_turn.game_win =  true;
                set!(world,(game_turn));
            }
            //move
            next_position_piece.piece_type = current_piece.piece_type;
            next_position_piece.color = player.color;
            //make current position empty of piece
            current_piece.piece_type = PieceType::None;
            current_piece.color = Color::None;
            set!(world, (next_position_piece));
            set!(world, (current_piece));
            // change turn
            
            game_turn.player_color = game_turn.next_turn();
            set!(world,(game_turn));
        }
        

        // init board 

         fn spawn(
            world: IWorldDispatcher,
            white_address: ContractAddress,
            black_address: ContractAddress
        ) -> u32 {
            let game_id: u32 = world.uuid();
            let game_win = false;
            // set Players
            set!(
                world,
                (
                    Player { game_id, address: black_address, color: Color::Black },
                    Player { game_id, address: white_address, color: Color::White },
                )
            );

            // set Game and GameTurn
            set!(
                world,
                (
                    Game {
                        game_id, winner: Color::None, white: white_address, black: black_address
                    },
                    GameTurn { game_id, player_color: Color::White, game_win },
                )
            );

            // set white Pieces
            // set white Rook
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 0, y: 0 },
                    piece_type: PieceType::Rook
                })
            );
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 7, y: 0 },
                    piece_type: PieceType::Rook
                })
            );

            //set white pawn
            let mut i: u32 = 0;
            while i <= 7 {
                set!(
                     world,
                     (Piece {
                         game_id,
                         color: Color::White,
                         position: Vec2 { x: i, y: 1 },
                         piece_type: PieceType::Pawn
                    })
                );
                i += 1;
            };
 
            // set white Knight
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 1, y: 0 },
                    piece_type: PieceType::Knight
                })
            );
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 6, y: 0 },
                    piece_type: PieceType::Knight
                })
            );

            //set white Bishop
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 2, y: 0 },
                    piece_type: PieceType::Bishop,
                })
            );
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 5, y: 0 },
                    piece_type: PieceType::Bishop,
                })
            );

            //set white Queen
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 3, y: 0 },
                    piece_type: PieceType::Queen
                })
            );

            // set white King
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 4, y: 0 },
                    piece_type: PieceType::King
                })
            );

            // set black pieces
            // set black Rook
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 0, y: 7 },
                    piece_type: PieceType::Rook
                })
            );
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 7, y: 7 },
                    piece_type: PieceType::Rook
                })
            );

            //set black pawn
            let mut i: u32 = 0;
            while i <= 7 {
                set!(
                     world,
                     (Piece {
                         game_id,
                         color: Color::Black,
                         position: Vec2 { x: i, y: 6 },
                         piece_type: PieceType::Pawn
                    })
                );
                i += 1;
            };
 
            // set black Knight
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 1, y: 7 },
                    piece_type: PieceType::Knight
                })
            );
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 6, y: 7 },
                    piece_type: PieceType::Knight
                })
            );

            //set black Bishop
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 2, y: 7 },
                    piece_type: PieceType::Bishop,
                })
            );
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 5, y: 7 },
                    piece_type: PieceType::Bishop,
                })
            );

            //set black Queen
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 3, y: 7 },
                    piece_type: PieceType::Queen
                })
            );

            // set black King
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 4, y: 7 },
                    piece_type: PieceType::King
                })
            );

            //return game id
            game_id
        }


    }
}



