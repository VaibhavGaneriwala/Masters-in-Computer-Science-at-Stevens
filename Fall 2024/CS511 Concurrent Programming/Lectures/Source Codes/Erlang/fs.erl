-module(fs).
-compile(export_all).
-compile(nowarn_export_all).

fact(0) ->
    1;
fact(N) when N>0 ->
    N*fact(N-1).

start() ->
    spawn(?MODULE,server_loop,[0,fun fact/1]).

server_loop(C,F) ->
    receive
	{req,X,PID,Ref} ->
	    try F(X) of
		Y ->
		    PID!{Y,Ref},
		    server_loop(C+1,F)
	    catch
		_:_ -> PID!{error,Ref},
		       server_loop(C,F)
	    end;
	{read,PID} ->
	    PID!C,
	    server_loop(C,F);
	{update,G,PID,Ref} ->
	    PID!{ok,Ref},
	    server_loop(0,G);
	{stop} ->
	    ok
    end.

my_sleep(N) ->
    receive
    after N ->
	    ok
    end.

my_flush() ->
    receive
	X -> [X | my_flush()]
    after 
	0 -> []
    end.
