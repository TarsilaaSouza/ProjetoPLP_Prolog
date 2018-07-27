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

% Imprime a matriz do Usuario.
imprime(_, [], M, MatrizString):- MatrizString = M, !.
imprime(Indice,[H|T], M, MatrizString):-
    number_string(Indice, NS),
    imprimeLinha(H, "", LinhaFinal),
    string_concat(NS, LinhaFinal, Linha1),
    Indice2 is Indice + 1,
    string_concat(Linha1, "\n", Linha2),
    string_concat(M, Linha2, M2),
    imprime(Indice2, T, M2, MatrizString).

% Imprime uma linha da matriz.
imprimeLinha([], Mlinha, LinhaFinal) :- LinhaFinal = Mlinha, !.
imprimeLinha([H|T], Mlinha, LinhaFinal) :-
    string_concat(Mlinha, " ", MlinhaN),
    string_concat(MlinhaN, H, MlinhaN2),
    imprimeLinha(T, MlinhaN2, LinhaFinal).

% Representa a matriz em um String.
matrizRepresentacao(Matriz, Tamanho):-
    primeiraLinha(Tamanho, PrimeiraLinha),
    imprime(1, Matriz, "", MatrizString),
    string_concat(PrimeiraLinha, MatrizString, MatrizPrint),
    write(MatrizPrint).

% Retorna a primeira linha da representação da matriz.
primeiraLinha(4, "  1 2 3 4\n").
primeiraLinha(6, "  1 2 3 4 5 6\n").
primeiraLinha(8, "  1 2 3 4 5 6 7 8\n").

main:-
	iniciarJogo,
	halt(0).

% Ler um número do teclado.
leitura(X) :-
	read_line_to_codes(user_input, Z),
	string_to_atom(Z, A),
	atom_number(A, X).

jogar :-
	menuNivel.

ranking :-
	writeln("Nadinha").

% Retorna uma Matriz preenchida com X.
criaMatriz(0, TLinha, []):-!.
criaMatriz(TMatriz, TLinha, Matriz):- 
    T is TMatriz-1, 
    criaLista(TLinha, M), 
    criaMatriz(T, TLinha, Retorno),
    addElemento(Retorno, M, Matriz).

% Adiciona um elemento na lista.
addElemento(Matriz, Elemento, [Elemento|Matriz]).

% Retorna uma lista preenchida de X.
criaLista(0, []):-!.
criaLista(Tamanho, Matriz) :- 
    T  is Tamanho-1, 
    criaLista(T, M), 
    preencheArray(M, Matriz). 

% Adiciona "X" a uma lista.
preencheArray(M, ["X"|M]).

% Lista de caracteres.
caracteres([ "◒", "◕", "◔", "◐", "☎", "☂", "☀", "☢", "☣", "☹", "☯", "☩", "☠", "☸", "♛", "♚", "♜", "♝", "♞", "♡", "✿", "✻", "⊳", "⊖", "➸", "➱", "❤" , "✸", "✖", "✔", "♫", "♬", "∞", "✂", "✈"]).
	
% Retorna o elemento de determinada posição na Lista.
getElement(0, [H|_], H):- !.
getElement(INDICE, [_|T], E):- 
    I is INDICE-1,
    getElement(I, T, E).

% Retorna o elemento de determinada posição na matriz
getElementMatrix(LINHA, COLUNA, [H|T], E):-
    getElement(LINHA, [H|T], LISTA),
    getElement(COLUNA, LISTA, AUX),
    E = AUX.

 % Retorna o elemento de determinada posição na Lista. 
pegarElemPorIndice(0, [H|T], H) :- !.
pegarElemPorIndice(Ind, [H|T], C) :- Z is Ind - 1, pegarElemPorIndice(Z, T, C). 

% Compara se dois elementos são iguais.
compara(LINHA1, COLUNA1, LINHA2, COLUNA2, [H|T]):-
	getElementMatrix(LINHA1, COLUNA1, [H|T], E1),
	getElementMatrix(LINHA2, COLUNA2, [H|T], E2),
	E1 == E2.

% Retorna  um número aleatorio entre 0 e F.
numRandom(F, X):- random(0, F, X).

% Seleciona os caracteres para o jogo.
sortearCaracteres(0, _, _, []) :- !.
sortearCaracteres(Quantidade, Caracteres, Tamanho, Array) :- 
    Q is Quantidade-1, 
    Z is Tamanho-1,
    numRandom(Tamanho, N),  
    pegarElemPorIndice(N, Caracteres, C), 
    addElemento(Retorno, C, Array),
    removerElemento(C, Caracteres, Novo), 
    sortearCaracteres(Q, Novo, Z, Retorno).

% Remove um elemento da lista.
removerElemento(X, [X|T], T):-!.
removerElemento(X, [H|T], [H|R]):- removerElemento(X, T, R).

% Insere um elemento em uma posição.
inserirElemPorIndArray(Elemento, 0, [H|T], [Elemento|T]):-!.
inserirElemPorIndArray(Elemento, Posicao, [H|T], Retorno) :- 
	Ind is Posicao-1, 
	inserirElemPorIndArray(Elemento, Ind, T, R), 
	Retorno = [H|R].

% Insere um elemento na Matriz.
inserirElemMatriz(Linha, Coluna, Elemento, Matriz, Retorno) :- 
	pegarElemPorIndice(Linha, Matriz, LinhaX),
	inserirElemPorIndArray(Elemento, Coluna, LinhaX, NovoArray),
	inserirElemPorIndArray(NovoArray, Linha, Matriz, Retorno).

% Retorna uma Lista de tuplas com todas as posições possiveis.
gerarPosicoes(0,0, _, [(0,0)]):-!.
gerarPosicoes(Linha, -1, Tamanho, N):- 
    L is Linha - 1, 
    gerarPosicoes(L, Tamanho, Tamanho, N), !.
gerarPosicoes(Linha, Coluna, Tamanho, N) :- 
    C is Coluna -1, 
    gerarPosicoes(Linha, C, Tamanho, R), 
    N =  [(Linha, Coluna)|R].

% Retorna a Matriz do jogo.
gerarMatrizJogo(Tamanho, MatrizJogo):-
    caracteres(ListaCaracteres),
    criaMatriz(Tamanho, Tamanho, Matriz),
    QntCaracteres is (Tamanho*Tamanho)/2,
    sortearCaracteres(QntCaracteres, ListaCaracteres, 34, Caracteres),
    Indice is Tamanho-1,
    gerarPosicoes(Indice, Indice, Indice, ListaPosicoes),
    preencherMatrizJogo(Caracteres, ListaPosicoes, Matriz, MatrizJogo).

% Preenche a Matriz do jogo.
preencherMatrizJogo(_, [], Matriz, Matriz):-!.
preencherMatrizJogo([Caracter|Caracteres], ListaPosicoes, Matriz, MatrizJogoFinal):-
    inserirParCaracteres(Caracter, ListaPosicoes, Matriz, NovasListaPosicoes, MatrizJogo),
    inserirParCaracteres(Caracter, NovasListaPosicoes, MatrizJogo, NovasListaPosicoesDois, MatrizJogoDois),
    preencherMatrizJogo(Caracteres, NovasListaPosicoesDois, MatrizJogoDois, MatrizJogoFinal).

% Insere um par de caracteres na Matriz.
inserirParCaracteres(Caracter, ListaPosicoes, Matriz, NovasListaPosicoes, MatrizJogo):-
    length(ListaPosicoes, Tamanho),
    numRandom(Tamanho, Num),
    pegarElemPorIndice(Num, ListaPosicoes, (Linha, Coluna)),
    inserirElemMatriz(Linha, Coluna, Caracter, Matriz, MatrizJogo),
    removerElemento((Linha, Coluna), ListaPosicoes, NovasListaPosicoes).

% Verifica se o elemento escolhido é igual a X.
posicaoValida(LINHA, COLUNA, [H|T]):-
	getElementMatrix(LINHA, COLUNA, [H|T], E),
	E =:= "X".

% Substitui um elemento na matriz.
modificaMatriz(LINHA, COLUNA, [H|T], EN):-
    getElemento(LINHA, [H|T], LISTA),
    modifica(LISTA, COLUNA, EN).
	
% Substitui um elemento na lista.
modifica([H|_], 0, EN):- H is EN.
modifica([_|T], INDICE, EN):-
    I is INDICE-1,
    modifica(T, I, EN).

% Retorna a posição escolhida pelo usuário.
lerPosicao(Posicao):-
    writeln("Escolha a linha e a coluna, respectivamente, do elemento:"),
    leitura(Linha),
    leitura(Coluna),
    L is (Linha - 1),
    C is (Coluna - 1),
    Posicao = (L, C), !.

% Retorna a posição do elemento fornecida pelo usuário.
validaPosicao(Tamanho, MatrizUsuario, Posicao):-
    lerPosicao((L, C)),
    (validaCoors(Tamanho, (L, C)), posicaoValida(L, C, MatrizUsuario)) ->  Posicao = (L, C);
    writeln("Posição Invalida!"),
    validaPosicao(Tamanho, MatrizUsuario, Posicao).

% Verifica de a linha e coluna escolhida é válida.
validaCoors(Tamanho, (Linha, Coluna)):-
    Linha < Tamanho,
    Coluna < Tamanho, 
    Linha >= 0,
    Coluna >= 0.

% Recebe o tamanho da matriz e Retorna a quantidade de pares possiveis.
pares(Tamanho, Pares):-
    Pares is (Tamanho * Tamanho) / 2.

% Lógica do jogo.
jogo(Pares, Tamanho, Nivel, ParesEcontrados, MatrizUsuario, MatrizSistema, Tempo):-
    contarSegundos(Tempo, Agora),
    Agora > 1000, !.
jogo(Pares, Tamanho, Nivel, ParesEcontrados, MatrizUsuario, MatrizSistema, Tempo):-
    ParesEcontrados =:= Pares.
jogo(Pares, Tamanho, Nivel, ParesEcontrados, MatrizUsuario, MatrizSistema, Tempo):-
    matrizRepresentacao(MatrizUsuario, Tamanho),
    getPares(Tamanho, MatrizUsuario, MatrizSistema, (Linha1, Coluna1), MatrizModificada),
    shell("clear"),
    matrizRepresentacao(MatrizModificada, Tamanho),
    getPares(Tamanho, MatrizModificada, MatrizSistema, (Linha2, Coluna2), MatrizModificada2),
    shell("clear"),
    matrizRepresentacao(MatrizModificada2, Tamanho),
    compara(Linha1, Coluna1, Linha2, Coluna2, MatrizSistema) ->  
    shell("clear"),  
    ParesEcontradosAgora is (ParesEcontrados + 1),
    writeln(ParesEcontradosAgora),
    jogo(Pares, Tamanho, Nivel, ParesEcontradosAgora, MatrizModificada2, MatrizSistema, Tempo);
    shell("clear"),
    writeln("Par escolhido diferente!!!"),
    jogo(Pares, Tamanho, Nivel, ParesEcontrados, MatrizUsuario, MatrizSistema, Tempo).
     

% Retorna uma posição escohida pelo usuário.
getPares(Tamanho, MatrizUsuario, MatrizSistema,(Linha, Coluna), MatrizModificada):-
    validaPosicao(Tamanho, MatrizUsuario, (Linha, Coluna)),
    getElementMatrix(Linha, Coluna, MatrizSistema, Elem),
    inserirElemMatriz(Linha, Coluna, Elem, MatrizUsuario, MatrizModificada).

% Retorna os segundos da hora atual.
segundos(Segundos):-
    get_time(TimeStamp),
    stamp_date_time(TimeStamp, date(_, _, _, _, Min, Seg, _, _, _), 0),
    Segundos is (Min * 60) + Seg.

% Retorna a diferença entre segundos.
contarSegundos(Segundos, Total):-
    segundos(SegundosAgora),
    K is SegundosAgora,
    Total is (K - Segundos).

iniciarJogo():-
	criaMatriz(4, 4, MatrizUsuario),
    gerarMatrizJogo(4, MatrizJogo),
    pares(4, P),
    segundos(T),
    jogo(P, 4, 1, 0, MatrizUsuario, MatrizJogo, T) -> writeln("perdeu..."); writeln("ganhou."),
    halt(0).