import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class Champion extends Api
{
    /**
     * Function called at the start of the game
     */
    public void init_game()
    {
    }

    /**
     * Called when this is your turn to play
     */
    public void play_turn()
    {
        List<Integer> gameBoard = Arrays.stream(board()).boxed().collect(Collectors.toList());

        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (gameBoard.get(3 * j + i) == -1) {
                    Position pos = new Position();
                    pos.x = i;
                    pos.y = j;
                    play(pos);
                    return;
                }
            }
        }
    }

    /**
     * Function called at the end of the game
     */
    public void end_game()
    {
    }
}
