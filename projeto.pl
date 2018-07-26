:- initialization(main).

menu:-
	shell("clear"),
	writeln(" Escolha uma opção:\n 1. Iniciar Jogo\n 2. Ranking\n 3. Sair"),
	leitura(X),
	opcao(X).

opcao(1) :- jogar.
opcao(2) :- ranking.
opcao(3) :- halt(0).
opcao(_) :- menu.

menuNivel:-
	shell("clear"),
	writeln("Escolha um dos niveis:\n 1. Iniciante\n 2. Intermediario\n 3. Avancado\n"),
	leitura(X),
	nivel(X).

nivel(1):- criaMatriz(4, 4, M), imprime(M).
nivel(2):- criaMatriz(6, 6, M), imprime(M).
nivel(3):- criaMatriz(8, 8, M), imprime(M).
nivel(_) :- menuNivel.

imprime([]):- writeln("").
imprime([H|T]):-
	imprimeLinha(H),
	imprime(T).

imprimeLinha([]) :- writeln("").
imprimeLinha([H|T]) :-
	write(H),
	write(" "),
	imprimeLinha(T).
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

removerElemento(X, [X|T], T).
removerElemento(X, [H|T], [H|R]):- removerElemento(X, T, R).

inserirElemPorIndArray(Elemento, 0, [H|T], [Elemento|T]).
inserirElemPorIndArray(Elemento, Posicao, [H|T], Retorno) :- 
	Ind is Posicao-1, 
	inserirElemPorIndArray(Elemento, Ind, T, R), 
	Retorno = [H|R].

inserirElemMatriz(Linha, Coluna, Elemento, Matriz, Retorno) :- 
	pegarElemPorIndice(Linha, Matriz, LinhaX),
	inserirElemPorIndArray(Elemento, Coluna, LinhaX, NovoArray),
	inserirElemPorIndArray(NovoArray, Linha, Matriz, Retorno).

gerarPosicoes(0,0, _, [(0,0)]).
gerarPosicoes(Linha, -1, Tamanho, N):- 
	L is Linha - 1, 
	gerarPosicoes(L, Tamanho, Tamanho, N).
gerarPosicoes(Linha, Coluna, Tamanho, N) :- 
	C is Coluna -1, 
	gerarPosicoes(Linha, C, Tamanho, R), 
	N =  [(Linha, Coluna)|R].

gerarMatrizJogo(Tamanho, MatrizJogo):-
	caracteres(ListaCaracteres),
	criarMatriz(Tamanho, Tamanho, Matriz),
	QntCaracteres is (Tamanho*Tamanho)/2,
	gerarCaracteres(QntCaracteres, ListaCaracteres, 34, Caracteres),
	Indice is Tamanho-1,
	gerarPosicoes(Indice, Indice, Indice, ListaPosicoes),
	preencherMatrizJogo(Caracteres, ListaPosicoes, Matriz, MatrizJogo).

preencherMatrizJogo(_, [], Matriz, Matriz).
preencherMatrizJogo([Caracter|Caracteres], ListaPosicoes, Matriz, MatrizJogoFinal):-
	inserirParCaracteres(Caracter, ListaPosicoes, Matriz, NovasListaPosicoes, MatrizJogo),
	inserirParCaracteres(Caracter, NovasListaPosicoes, MatrizJogo, NovasListaPosicoesDois, MatrizJogoDois),
	preencherMatrizJogo(Caracteres, NovasListaPosicoesDois, MatrizJogoDois, MatrizJogoFinal).

inserirParCaracteres(Caracter, ListaPosicoes, Matriz, NovasListaPosicoes, MatrizJogo):-
	length(ListaPosicoes, Tamanho),
	numRandom(Tamanho, Num),
	pegarElementoPorIndice(Num, ListaPosicoes, (Linha, Coluna)),
	inserirElementoMatriz(Linha, Coluna, Caracter, Matriz, MatrizJogo),
	removerElemento((Linha, Coluna), ListaPosicoes, NovasListaPosicoes).
	
posicaoValida(LINHA, COLUNA, [H|T]):-
	getElementMatrix(LINHA, COLUNA, [H|T], E),
	E == 88.

modificaMatriz(LINHA, COLUNA, [H|T], MatrizJogo, EN):-
	getElementMatrix(LINHA, COLUNA, MatrizJogo, ECod),
	string_to_list(E, [ECod]),
	getElement(LINHA, [H|T], LISTA),
	modifica(E, COLUNA, LISTA, EN1),
	modifica(EN1, LINHA, [H|T], EN).
	
modifica(X,0,[_|L],[X|L]).
modifica(X,N,[C|L],[C|R]) :- 
	N1 is N-1, 
	modifica(X,N1,L,R).
