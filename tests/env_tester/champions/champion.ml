open Api


let init_game () : unit =
(** Function called at the start of the game *)
    (* TODO *)

    (* Pour s'assurer que les sorties s'affichent *)
    flush stderr;
    flush stdout

let play_turn () =
  let game_board = board () in  (* Get the board *)
  let rec find_move i j =
    if i < 3 then
      if j < 3 then
        if game_board.(3 * j + i) = -1 then begin
          let pos = (i, j) in
          ignore (play pos); (* Ignore the result of play *)
        end else find_move i (j + 1)
      else find_move (i + 1) 0
  in
  find_move 0 0

let end_game () : unit =
(** Function called at the end of the game *)
    (* TODO *)

    (* Pour s'assurer que les sorties s'affichent *)
    flush stderr;
    flush stdout

(* /!\ Ne modifie pas les lignes suivantes, elles sont importantes pour
** l'utilisation du moteur de jeu /!\ *)
let _ =
    Callback.register "ml_init_game" init_game;
    Callback.register "ml_play_turn" play_turn;
    Callback.register "ml_end_game" end_game
