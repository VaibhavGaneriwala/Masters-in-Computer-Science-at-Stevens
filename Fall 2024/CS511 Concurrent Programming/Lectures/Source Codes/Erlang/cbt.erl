
-module(cbt).
-compile(nowarn_export_all).
-compile(export_all).

-type btree() :: {empty}
	       |  {node,number(),btree(),btree()}.

%% Example of a complete bt
-spec t1() -> btree().
t1() ->
    {node,1,{node,2,{empty},{empty}},{node,3,{empty},{empty}}}.

%% Example of a non-complete bt
-spec t2() -> btree().
t2() ->
    {node,1,
     {node,2,{empty},{empty}},
     {node,3,{empty},
      {node,4,{empty},{empty}}}}.

%% Checks that all the trees in the queue are empty trees.
-spec all_empty(queue:queue()) -> boolean().
all_empty(Q) ->
    case queue:out(Q) of
	{empty,_} ->
	    true;
	{{value,{empty}},QTail} ->
	    all_empty(QTail);
	{{value,{node,_D,_LT,_RT}},_QTail} ->
	    false
    end.

%% helper function for ic
-spec ich(queue:queue()) -> boolean().
ich(Q) ->
    case queue:out(Q) of
	{{value,{empty}},QTail} ->
	    all_empty(QTail);
	{{value,{node,_D,LT,RT}},QTail} ->
	    ich(queue:in(RT,queue:in(LT,QTail)));
	{empty,_} ->  %% never happens
	    true
    end.

-spec ic(btree()) -> boolean().
ic(T) ->
    ich(queue:in(T,queue:new())).
