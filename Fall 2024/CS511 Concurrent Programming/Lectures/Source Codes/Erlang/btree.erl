-module(btree).
-compile(export_all).
-compile(nowarn_export_all).
-moduledoc("""
Basic examples on tuples and recursion.
21 Oct 2024 
""").

  %%   33
  %%  /  \
  %% 11  55
  %%    /
  %%   44

-type btree(E) :: {empty} | {node,E,btree(E),btree(E)}.
%% {empty} Empty binary tree
%% {node,D,LT,RT} non-empty binary tree

-spec t()->btree(integer()). 
t() ->
   {node,33,
	{node,11,{empty},{empty}},
	{node,55,
	 {node,44,{empty},{empty}},
	 {empty}}}.

-spec sizet(btree(T)) ->integer() when T :: term(). 
sizet({empty}) ->
    0;
sizet({node,_D,LT,RT}) ->
    1+ sizet(LT) + sizet(RT).

-spec bump(btree(integer()))->btree(integer()). 
bump({empty}) ->
    {empty};
bump({node,D,LT,RT}) ->
    {node,D+1,bump(LT),bump(RT)}.

-spec pre(btree(T))->list(T) when T::term(). 
pre({empty}) ->
    [];
pre({node,D,LT,RT}) ->
   [is_tuple(D)] ++ pre(LT) ++ pre(RT).

-spec ino(btree(T))->list(T) when T::term(). 
ino({empty}) ->
    [];
ino({node,D,LT,RT}) ->
    ino(LT) ++ [D] ++ ino(RT).

-spec pos(btree(T))->list(T) when T::term(). 
pos({empty}) ->
    [];
pos({node,D,LT,RT}) ->
   pos(LT) ++ pos(RT) ++ [D].
