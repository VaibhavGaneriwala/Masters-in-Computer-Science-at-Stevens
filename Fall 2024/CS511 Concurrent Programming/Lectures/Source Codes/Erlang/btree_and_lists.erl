-module(btree_and_lists).
-compile(export_all).
-compile(nowarn_export_all).
% The next line avoids a clash between our own length function defined below and  the BIF length function which is automatically loaded from https://github.com/erlang/otp/blob/master/erts/preloaded/src/erlang.erl
-compile({no_auto_import,[length/1]}).

%% 23 Oct - Encoding binary trees
%% 30 Oct - Added examples on lists

  %%   33
  %%  /  \
  %% 11  55
  %%    /
  %%   44

%% {empty} Empty binary tree
%% {node,D,LT,RT} non-empty binary tree
-type btree(E) :: {empty} | {node,any(),btree(E),btree(E)}.

-spec t() -> btree(number()).
t() ->
   {node,33,
	{node,11,{empty},{empty}},
	{node,55,
	 {node,44,{empty},{empty}},
	 {empty}}}.

sizet({empty}) ->
    0;
sizet({node,_D,LT,RT}) ->
    1+ sizet(LT) + sizet(RT).

bump({empty}) ->
    {empty};
bump({node,D,LT,RT}) ->
    {node,D+1,bump(LT),bump(RT)}.

pre({empty}) ->
    [];
pre({node,D,LT,RT}) ->
   [D] ++ pre(LT) ++ pre(RT).

ino({empty}) ->
    [];
ino({node,D,LT,RT}) ->
    ino(LT) ++ [D] ++ ino(RT).

%%% CPS
ino2({empty},K) ->
    K([]);
ino2({node,D,LT,RT},K) ->
    ino2(RT,fun (L2) -> ino2(LT,fun (L1) -> K(L1++[D]++L2) end) end).
	   
pos({empty}) ->
    [];
pos({node,D,LT,RT}) ->
   pos(LT) ++ pos(RT) ++ [D].

mirror({empty}) ->
    {empty};
mirror({node,D,LT,RT}) ->
    {node,D,mirror(RT),mirror(LT)}.

map(_F,{empty}) ->
    {empty};
map(F,{node,D,LT,RT}) ->
    {node,F(D),map(F,LT),map(F,RT)}.

fold(_F,A,{empty}) ->
    A;
fold(F,A,{node,D,LT,RT}) ->
    F(D,fold(F,A,LT),fold(F,A,RT)).

length([]) ->
    0;
length([_H|T]) ->
    1+length(T).

mapl(_F,[]) ->
    [];
mapl(F,[H|T]) ->
    [F(H)|mapl(F,T)].

mapl2(F,L) ->
    case L of
	[] -> [];
	[H|T] -> [F(H)|mapl2(F,T)]
    end.

foldr(_F,A,[]) ->
    A;
foldr(F,A,[H|T]) ->
    F(H,foldr(F,A,T)).

foldl(_F,A,[]) ->
    A;
foldl(F,A,[H|T]) ->
    foldl(F,F(A,H),T).

stutter([]) ->
    [];
stutter([H|T]) ->
    [H|[H|stutter(T)]].

%% mem(E,L)  determines whether E is in L
mem(_E,[]) ->
    false;
mem(E,[H|T]) ->
    (E==H) or mem(E,T).

mem2(_E,[]) ->
    false;
mem2(E,[H|_T]) when E==H -> true;
mem2(E,[_H|T]) -> mem2(E,T).

%% has_dupl(L) determines whether L has duplicates
has_dupl([]) ->
    false;
has_dupl([H|T]) ->
    mem(H,T) or has_dupl(T).

%% append(L1,L2) appends L1 with L2 (i.e. L1 ++ L2)

%% take(N,L) takes the first N elements of L
 
take(0,_L) ->
    [];
take(_N,[]) ->
    [];
take(N,[H|T]) ->
    [H | take(N-1,T)].


