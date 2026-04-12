<?php

require('api.php');


// Function called at the start of the game
function init_game()
{
    // TODO
}

// Called when this is your turn to play
function play_turn()
{
    // TODO
   $game_board = board();

    for ($i = 0; $i < 3; $i++) {
        for ($j = 0; $j < 3; $j++) {
            if ($game_board[3 * $j + $i] == -1) {
                $pos = ['x' => $i, 'y' => $j];
                play($pos);
                return;
            }
        }
    }
}

// Function called at the end of the game
function end_game()
{
    // TODO
}
