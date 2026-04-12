// Include standard library in documentation: `cargo doc --open`
#[doc(inline)]
pub use std;

mod ffi;
pub mod api;

use api::*;


/// Function called at the start of the game
pub fn init_game()
{
    // TODO
}

/// Called when this is your turn to play
fn play_turn() {
    let game_board = board();

    for i in 0..3 {
        for j in 0..3 {
            if game_board[3 * j + i] == -1 {
                let pos = (i as i32, j as i32);
                play(pos);
                return;
            }
        }
    }
}

/// Function called at the end of the game
pub fn end_game()
{
    // TODO
}
