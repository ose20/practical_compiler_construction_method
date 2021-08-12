type tag = unit ref
type t = INT 
        | STRING
        | ARRAY of int * t
        | NAME of string * t
        | UNIT
        | NIL