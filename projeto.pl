:- initialization(main).

menu:-
	writeln("Menu:"),
    writeln("1. Iniciar Jogo"),
    writeln("2. Ranking"),
    writeln("3. Sair"),
    read(resposta),
    controller(resposta).
    
controller(1):- 
	shell("clear"),
	writeln("Escolha um dos niveis:"}),
	writeln("1. Iniciante"),
	writeln("2. Intermediario"),
	writeln("3. Avancado"),
	read(nivel),
	acao(nivel).

acao(1):- criaMatriz(4, 4, M), writeln(M).

acao(2):- criaMatriz(6, 6, M), writeln(M).

acao(3):- criaMatriz(8, 8, M), writeln(M).

acao(_) :- controller.

main:-
	menu,
	halt(0).


leitura(X) :-
	read_line_to_codes(user_input, Z),
	string_to_atom(Z, A),
	atom_number(A, X).

opcao(1) :- jogar.
opcao(2) :- ranking.
opcao(3) :- halt(0).
opcao(_) :- menu.

jogar :-
	menuNivel.

ranking :-
	writeln("Nadinha").

criaMatriz(0, _, []).
criaMatriz(TMatriz, TLinha, Matriz):- T is TMatriz-1, criaLista(TLinha, M), criaMatriz(T, TLinha, Retorno), addElemento(Retorno, M, Matriz).

addElemento(Matriz, Elemento, [Elemento|Matriz]).

criaLista(0, []).
criaLista(Tamanho, Matriz) :- T  is Tamanho-1, criaLista(T, M), preencheArray(M, Matriz). 

preencheArray(M, ["X"|M]).

caracteres([ "◒", "◕", "◔", "◐", "☎", "☂", "☀", "☢", "☣", "☹", "☯", "☩", "☠", "☸", "♛", "♚", "♜", "♝", "♞", "♡", "✿", "✻", "⊳", "⊖", "➸", "➱", "❤" , "✸", "✖", "✔", "♫", "♬", "∞", "✂", "✈"]).
	
getElement(0, [H|_], H):- !.
getElement(INDICE, [_|T], E):- 
	I is INDICE-1,
	getElement(I, T, E).

getElementMatrix(LINHA, COLUNA, [H|T], E):-
	getElement(LINHA, [H|T], LISTA),
	getElement(COLUNA, LISTA, AUX),
	E is AUX.
	
compara(LINHA1, COLUNA1, LINHA2, COLUNA2, [H|T]):-
	getElementMatrix(LINHA1, COLUNA1, [H|T], E1),
	getElementMatrix(LINHA2, COLUNA2, [H|T], E2),
	E1 == E2.
