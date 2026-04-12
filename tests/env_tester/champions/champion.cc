#include "api.hh"

void init_game() {}

void play_turn()
{
  const std::vector<int> &game_board = board();

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (game_board[3 * j + i] == -1) {
        position pos = {i, j};
        play(pos);
        return;
      }
    }
  }
}

void end_game() {}
