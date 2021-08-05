open Types
type varInfo = {ty: ty; offset: int; level: int}
type funInfo = {formals: ty list; result: ty; level: int}
type enventry = VarEntry of varInfo | FunEntry of funInfo