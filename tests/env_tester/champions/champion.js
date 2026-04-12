/**
 * Function called at the start of the game
 */
function initGame() {}

/**
 * Called when this is your turn to play
 */
function playTurn() {
  const gameBoard = board();  // Get the board
  for (let i = 0; i < 3; i++) {
    for (let j = 0; j < 3; j++) {
      if (gameBoard[3 * j + i] === -1) {
        const pos = [i, j]; // Use an array to represent Position
        play(pos);  // Pass the position array to play
        return;
      }
    }
  }
}

/**
 * Function called at the end of the game
 */
function endGame() {}

