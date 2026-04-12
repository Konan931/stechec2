from api import *


# Function called at the start of the game
def init_game():
    # TODO
    pass


# Called when this is your turn to play
def play_turn():
    game_board = board()

    for i in range(3):
        for j in range(3):
            if game_board[3 * j + i] == -1:
                pos = (i, j)
                play(pos)
                return


# Function called at the end of the game
def end_game():
    # TODO
    pass
