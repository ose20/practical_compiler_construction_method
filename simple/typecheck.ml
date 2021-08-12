open Ast
open Types
open Table

exception TypeErr of string
exception SemErr of string

let venv0 = fun _ -> raise (TypeErr "unbound variable while refering value environment")
let tenv0 = fun _ -> raise (TypeErr "unbound variable while refering type environment")

let update key value env =
    fun x -> if x = key then value else env x

let normalize_type typ tenv = tenv typ

let rec type_of_stmt stmt tenv venv =
    match stmt with
    | Assign (v, e) ->
        let vt = type_of_var v tenv venv in
        let ev = type_of_exp e tenv venv in
        if vt != ev
        then raise (TypeErr "both sides of \"Assign\" should have the same type")
        else UNIT
    | CallProc ("return", [arg]) ->
        type_of_exp arg tenv venv
    | CallProc ("sprint", [arg]) ->
        if check_string arg tenv venv then UNIT
        else raise (TypeErr "arg of \"sprint\" should be string literal")
    | CallProc ("iprint", [arg]) ->
        if check_int arg tenv venv then UNIT
        else raise (TypeErr "arg of \"iprint\" should have int type")
    | CallProc ("scan", [arg]) ->
        if check_int arg tenv venv then UNIT
        else raise (TypeErr "arg of \"scan\" should have int type")
    | CallProc (s, e_l) ->
        let fentry = venv s in
        (match fentry with
        | FunEntry {args_t = argst_l; res_t = restype} ->
            let actual_t_l = List.map (fun e -> type_of_exp e tenv venv) e_l in
            if List.length argst_l = List.length actual_t_l
            then
                if List.for_all2 (fun t1 t2 -> t1 = t2) argst_l actual_t_l
                then restype
                else raise (TypeErr (Printf.sprintf "the type of some args is wrong in function %s" s))
            else raise (TypeErr (Printf.sprintf "the num of args is wrong in function %s" s))
        | _ -> raise (TypeErr "found variable in environment where function is needed"))
    | Block (d_l, stmt_l) ->
        let (tenv', venv') = rgst_decs d_l tenv venv in
        type_of_stmts stmt_l tenv' venv'
    | If (e, s1, o) ->
        if check_cond e tenv venv
        then
            (match o with
            | Some s2 ->
                let t1 = type_of_stmt s1 tenv venv in
                let t2 = type_of_stmt s2 tenv venv in
                if t1 = t2 then t1
                else raise (TypeErr "both sides of if-stmt should have the same type")
            | None ->
                type_of_stmt s1 tenv venv)
        else raise (TypeErr "guard clase of if-stmt should be appropriate \"cond\"")
    | While (e, s) ->
        (match (check_cond e tenv venv, type_of_stmt s tenv venv = UNIT) with
        | (true, true) -> UNIT
        | (true, false) ->
            raise (TypeErr "block in while-stmt should have UNIT type")
        | (false, _) ->
            raise (TypeErr "guard clase of while-stmt should be appropriate \"cond\""))
    | NilStmt -> UNIT
and type_of_stmts stmts tenv venv =
    match stmts with
    | [] -> UNIT
    | [stmt] -> type_of_stmt stmt tenv venv
    | stmt :: rest ->
        let tmp_t = type_of_stmt stmt tenv venv in
        if tmp_t = UNIT then type_of_stmts rest tenv venv
        else raise (TypeErr "the type of all but the last of succesive stmt should be UNIT")
and type_of_exp exp tenv venv =
    match exp with
    | VarExp v -> type_of_var v tenv venv
    | StrExp s -> STRING
    | IntExp i ->INT
    | CallFunc (s, e_l) ->
        (match venv s with
        | FunEntry {args_t = args_t; res_t = res_t} -> 
            let actual_args_t_l = List.map (fun e -> type_of_exp e tenv venv) e_l in
            if List.for_all2 (fun t1 t2 -> t1 = t2) args_t actual_args_t_l then res_t
            else raise (TypeErr (Printf.sprintf "type of some args of %s is wrong" s))
        | _ -> raise (TypeErr "found variable when searching function"))
and type_of_var var tenv venv =
    match var with
    | Var s ->
        (match venv s with
        | VarEntry {t = t} -> t
        | _ -> raise (TypeErr "found function while searching variable"))
    | IndexedVar (v, e) ->
        if check_int e tenv venv
        then
            ARRAY (0 (* fake*), type_of_exp e tenv venv)
        else
            raise (TypeErr "index of IndexedVar should have int type")
and type_of_ast_t ast_t tenv env =  
    match ast_t with
    | NameTyp s -> tenv s
    | ArrayTyp (i, typ) ->
        ARRAY (i, type_of_ast_t typ tenv env)
    | IntTyp -> INT
    | VoidTyp -> UNIT
and rgst_dec dec tenv venv =
    match dec with
    | FuncDec (f, ts_l, res_typ, stmt) ->
        (* ここは stmt_l の扱いに注意が必要　*)
        (* stmt_l で宣言されたものを環境に加えるのはまずそう．スコープ出ちゃうので *)
        (* stmt_l の型チェックのみその環境は使うことにすると良さそう *)
        
        (* 仮引数に重複がないかチェックする *)
        let rec dup_check tys_l s_l =
            match tys_l with
            | [] -> false
            | (ty, s) :: rest ->
                if List.mem s s_l then true else dup_check rest (s :: s_l)
        in
        if dup_check ts_l []
        then raise (TypeErr (Printf.sprintf "same id is used in args of decraration of %s" f))
        else (* 仮引数とその型の組を環境に追加して，stmt_l の型を検査する *)
            let venv' =
                List.fold_left (fun venv (typ, s) ->
                    update s (VarEntry {t = type_of_ast_t typ tenv venv}) venv)
                    venv ts_l 
            in
            let actual_res_t = type_of_stmt stmt tenv venv' in
            if actual_res_t != type_of_ast_t res_typ tenv venv
            then raise (TypeErr (Printf.sprintf "actual_type is different from defined type in %s" f))
            else (* 関数を環境に登録して新しい環境を返す *)
                let entry = FunEntry {
                    args_t = List.map (fun (typ, s) ->
                        type_of_ast_t typ tenv venv) ts_l;
                    res_t = actual_res_t}
                in
                let venv'' = update f entry venv in
                (tenv, venv'')  
    | TypeDec (s, ast_t) ->
        let tenv' = update s (type_of_ast_t ast_t tenv venv) tenv in
        (tenv', venv)
    | VarDec (typ, s) ->
        let entry = VarEntry {t = type_of_ast_t typ tenv venv} in
        let venv' = update s entry venv in
        (tenv, venv')
and rgst_decs decs tenv venv =
    match decs with
    | [] -> (tenv, venv)
    | dec :: rest ->
        let (tenv', venv') = rgst_dec dec tenv venv in
        rgst_decs rest tenv' venv'
and check_cond e tenv venv =
    match e with
    | CallFunc ("==", [left; right]) ->
        (check_int left tenv venv) && (check_int right tenv venv)
    | CallFunc ("!=", [left; right]) ->
        (check_int left tenv venv) && (check_int right tenv venv)
    | CallFunc (">", [left; right]) ->
        (check_int left tenv venv) && (check_int right tenv venv)
    | CallFunc ("<", [left; right]) ->
        (check_int left tenv venv) && (check_int right tenv venv)
    | CallFunc (">=", [left; right]) ->
        (check_int left tenv venv) && (check_int right tenv venv)
    | CallFunc ("<=", [left; right]) ->
        (check_int left tenv venv) && (check_int right tenv venv)
    | _ -> raise (SemErr "err in \"check_cond\"")
and check_int e tenv venv =
    type_of_exp e tenv venv = INT
and check_string e tenv venv =
    type_of_exp e tenv venv = STRING


let init_venv env =
    let binop = FunEntry {args_t = [INT; INT]; res_t = INT} in
    let unop = FunEntry {args_t = [INT]; res_t = INT} in
    let env = update "+" binop env in
    let env = update "-" binop env in
    let env = update "*" binop env in
    let env = update "/" binop env in
    update "!" unop env

let check stmt =
    let tenv = tenv0 in
    let venv = init_venv venv0 in
    let _ = type_of_stmt stmt tenv venv in ()