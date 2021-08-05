{
open Parser
exception Lexing of string
}

let digit = ['0'-'9']
let id =  ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9']*
let space = [' ' '\t' '\n' '\r']

rule lexer = parse
    | digit+ as num 
        { NUM (int_of_string num) }
    | "if" 
        { IF }
    | "else"
        { ELSE }
    | "while"
        { WHILE }
    | "scan"
        { SCAN }
    | "sprint"
        { SPRINT }
    | "iprint"
        { IPRINT }
    | "int"
        { INT }
    | "return"
        { RETURN }
    | "type"
        { TYPE }
    | "void"
        { VOID }
    | id as text 
        { ID text }
    | '\"'[^'\"']*'\"' as str 
        { STR str }
    | '='
        { ASSIGN }
    | "=="
        { EQ }
    | "!="
        { NEQ }
    | ">"
        { GT }
    | "<"
        { LT }
    | ">="
        { GE }
    | "<="
        { LE }
    | '+'
        { PLUS }
    | '-'
        { MINUS }
    | '*'
        { TIMES }
    | '/'
        { DIV }
    | '{'
        { LB }
    | '}'
        { RB }
    | '['
        { LS }
    | ']'
        { RS }
    | '('
        { LP }
    | ')'
        { RP }
    | ','
        { COMMA }
    | ';'
        { SEMI }
    | space
        { lexer lexbuf}
    | _ 
        { raise (Lexing (Lexing.lexeme lexbuf)) }