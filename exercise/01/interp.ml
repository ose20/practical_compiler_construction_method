(*
  「文」を「式」に埋め込む値構成子「StmtExp (文，式)」（「式」の値 を返す）を付加し，「文」の中で代入した変数を「式」で利用できる ようにしなさい．
  「StmtExp (文, 式)」を，四則演算言語で「(文，式)」と記述することにす ると，例えば，「y = (x = 1 + 2, x); print (y)」に相当する構文木は，次のようにする．

  # let prog1 = Stmts (Assign ("y",
      StmtExp (Assign ("x", Plus (Num 1, Num 2)), Id "x")), Print (Id "y")) ;;
  # interp prog1 ;;
  3
*)
type id = string
type stmt = Seq of stmt * stmt
          | Assign of id * exp
          | Print of exp
and exp = Id of id
        | Num of int
        | Plus of exp * exp
        | Minus of exp * exp
        | Times of exp * exp
        | Div of exp * exp
        | StmtExp of stmt * exp

exception No_such_symbol

let env0 = fun _ -> raise No_such_symbol
let update var vl env = fun v -> if v = var then vl else env v
let rec eval_stmt ast env =
  match ast with
  | Seq (s1, s2) ->
      let env' = eval_stmt s1 env in
      eval_stmt s2 env'
  | Assign (var, e) ->
      let vl = eval_exp e env in
      update var vl env
  | Print e ->
      let vl = eval_exp e env in
      Printf.printf "%d\n" vl; env
and eval_exp ast env =
  match ast with
  | Id var -> env var
  | Num n -> n
  | Plus (e1, e2) ->
      let v1 = eval_exp e1 env in
      let v2 = eval_exp e2 env in
      v1 + v2
  | Minus (e1, e2) ->
      let v1 = eval_exp e1 env in
      let v2 = eval_exp e2 env in
      v1 - v2      
  | Times (e1, e2) ->
      let v1 = eval_exp e1 env in
      let v2 = eval_exp e2 env in
      v1 * v2
  | Div (e1, e2) ->
      let v1 = eval_exp e1 env in
      let v2 = eval_exp e2 env in
      v1 / v2
  | StmtExp (s, e) ->
      let env' = eval_stmt s env in
      eval_exp e env'

let prog1 = 
  Seq (Assign ("y",
        StmtExp (Assign ("x", Plus (Num 1, Num 2)), Id "x")),
      Print (Id "y"))

let prog2 =
  Seq (Assign ("y", StmtExp (Assign ("x", Plus (Num 1, Num 2)), Id "x")),
  Print (Id "x"))

let interp stmt = eval_stmt stmt env0

(*
    「StmtExp (文、式）」の文で更新された環境が、この外にも
    影響するようにプログラムを書き換えよ
*)

let rec eval2_stmt ast env =
  match ast with
  | Seq (s1, s2) ->
      let env' = eval2_stmt s1 env in
      eval2_stmt s2 env'
  | Assign (var, e) ->
      let (vl, env') = eval2_exp e env in
      update var vl env'
  | Print e ->
      let (vl, env') = eval2_exp e env in
      Printf.printf "%d\n" vl; env'
and eval2_exp ast env =
  match ast with
  | Id var -> (env var, env)
  | Num n -> (n, env)
  | Plus (e1, e2) ->
      let (v1, _) = eval2_exp e1 env in
      let (v2, _) = eval2_exp e2 env in
      (v1 + v2, env)
  | Minus (e1, e2) ->
      let (v1, _) = eval2_exp e1 env in
      let (v2, _) = eval2_exp e2 env in
      (v1 - v2, env)
  | Times (e1, e2) ->
      let (v1, _) = eval2_exp e1 env in
      let (v2, _) = eval2_exp e2 env in
      (v1 * v2, env)
  | Div (e1, e2) ->
      let (v1, _) = eval2_exp e1 env in
      let (v2, _) = eval2_exp e2 env in
      (v1 / v2, env)
  | StmtExp (s, e) ->
      let env' = eval2_stmt s env in
      eval2_exp e env'

let interp2 stmt = eval2_stmt stmt env0