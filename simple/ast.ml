type var = Var of string | IndexedVar of var * exp (* IndexedVar は配列の要素 *)
and stmt = Assign of var * exp
        | CallProc of string * (exp list)
        | Block of (dec list) * (stmt list)
        | If of exp * stmt * (stmt option)
        | While of exp * stmt
        | NilStmt
and exp = VarExp of var | StrExp of string | IntExp of int
        | CallFunc of string * (exp list)
and dec = FuncDec of string * ((typ * string) list) * typ * stmt
        | TypeDec of string * typ
        | VarDec of typ * string
and typ = NameTyp of string
        | ArrayTyp of int * typ
        | IntTyp
        | VoidTyp