
%token <int> NUM
%token PLUS MINUS TIMES DIV LP RP QUIT EOI

%left PLUS MINUS
%left TIMES DIV
%nonassoc UMINUS

%start prog
%type <Toplevel.t> prog

%%
prog: 
  | expr EOI
      { Toplevel.Exp ($1) }
  | QUIT EOI
      { Toplevel.Quit }

expr:
  | NUM
      { $1 }
  | LP expr RP
      { $2 }
  | expr PLUS expr
      { $1 + $3 }
  | expr MINUS expr
      { $1 - $3 }
  | expr TIMES expr
      { $1 * $3 }
  | expr DIV expr
      { $1 / $3 }
  | MINUS expr 
      { - $2 }
