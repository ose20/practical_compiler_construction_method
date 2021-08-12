open Types
type varInfo = {t: Types.t}
type funInfo = {args_t: Types.t list; res_t: Types.t}
type enventry = VarEntry of varInfo | FunEntry of funInfo