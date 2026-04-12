using System;
using System.Collections.Generic;

namespace Champion {
    class Champion {
        // Function called at the start of the game
        void InitGame()
        {
            // TODO
        }

        // Called when this is your turn to play
        void PlayTurn()
        {
            int[] gameBoard = Api.Board();  // Appel à Api.Board()

            for (int i = 0; i < 3; i++)
            {
                for (int j = 0; j < 3; j++)
                {
                    if (gameBoard[3 * j + i] == -1)
                    {
                        Position pos = new Position(); // Création de Position avec le constructeur par défaut
                        pos.X = i;  // Accès aux attributs publics
                        pos.Y = j;
                        Api.Play(pos);  // Appel de la méthode play de Api
                        return;
                    }
                }
            }
        }

        // Function called at the end of the game
        void EndGame()
        {
            // TODO
        }
    }
}
