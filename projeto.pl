:- initialization(main).

menu:-
	shell("clear"),
	writeln(" Escolha uma opção:\n 1. Iniciar Jogo\n 2. Ranking\n 3. Sair"),
	leitura(X),
	opcao(M).

opcao(1) :- jogar.
opcao(2) :- ranking.
opcao(3) :- halt(0).
opcao(_) :- menu.

menuNivel:-
	shell("clear"),
	writeln("Escolha um dos niveis:\n 1. Iniciante\n 2. Intermediario\n 3. Avancado\n"),
	leitura(X),
	nivel(X).

nivel(1):- criaMatriz(4, 4, M), writeln(M).
nivel(2):- criaMatriz(6, 6, M), writeln(M).
nivel(3):- criaMatriz(8, 8, M), writeln(M).
nivel(_) :- menuNivel.

imprime([]):- !S.
imprime([H|T]):-
	writeln(H),
	imprime(T).

main:-
	menu,
	halt(0).

leitura(X) :-
	read_line_to_codes(user_input, Z),
	string_to_atom(Z, A),
	atom_number(A, X).

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

numRandom(F, X):- random(0, F, X).

sortearCaracteres(0, _, _, []) :- !.
sortearCaracteres(Quantidade, Caracteres, Tamanho, Array) :- 
	Q is Quantidade-1, 
	Z is Tamanho-1,
	numRandom(Tamanho, N),  
	pegarElemPorIndice(N, Caracteres, C), 
	adicionarElementoArray(Retorno, C, Array),
	removerElemento(C, Caracteres, Novo), 
	sortearCaracteres(Q, Novo, Z, Retorno).

