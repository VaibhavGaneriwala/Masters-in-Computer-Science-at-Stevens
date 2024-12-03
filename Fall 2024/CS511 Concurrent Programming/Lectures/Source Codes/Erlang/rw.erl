-module(rw).
-compile(export_all).
-compile(nowarn_export_all).

make() ->
    spawn(?MODULE,server_loop,[0,0]).

server_loop(R,W) ->
    receive
	{start_read,PID} when W==0 ->
	    PID!{ok},
	    server_loop(R+1,W);
	{stop_read} ->
	    server_loop(R-1,W);
	{start_write,PID} when (W==0) and (R==0) ->
	    PID!{ok},
	    server_loop(R,W+1);
	{stop_write} ->
	    server_loop(R,W-1)
    end.

start_read(S) ->
    S!{start_read,self()},
    receive
       {ok} ->
	ok
    end.

start_write(S) ->
    S!{start_write,self()},
    receive
       {ok} ->
	ok
    end.

stop_read(S) ->
    S!{stop_read}.

stop_write(S) ->
    S!{stop_write}.

%%% Client code

start(NC) ->
    S = rw:start(),
    [ spawn(?MODULE,client,[S, rand:uniform(2)]) || _ <- lists:seq(1,NC)],
    ok.

client(S,1) -> %% reader
    rw:start_read(S),
    rw:stop_read(S);
client(S,2) ->  %% writer 
    rw:start_write(S),
    rw:stop_write(S).
