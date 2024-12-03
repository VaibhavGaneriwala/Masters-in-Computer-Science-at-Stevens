-module(sem).
-compile(export_all).
-compile(nowarn_export_all).

%% Semaphores with positive permits
make(P) ->
    spawn(?MODULE,sem_loop,[P]).

sem_loop(0) ->
    receive
	{release} ->
	    sem_loop(1)
    end;
sem_loop(N) when N>0 ->
    receive
	{release} ->
	    sem_loop(N+1);
	{acquire,PID,Ref} ->
	    PID!{ok,Ref},
	    sem_loop(N-1)
    end.

%% Alternative solution to the server loop
sem_loop2(N) ->
    receive
	{release} ->
	    sem_loop(N+1);
	{releaseN,P} ->
	    sem_loop(N+P);
	{acquire,PID,Ref} when N>0 ->
	    PID!{ok,Ref},
	    sem_loop(N-1);
	{acquireN,P,PID,Ref} when N>=P ->
	    PID!{ok,Ref},
	    sem_loop(N-P)
    end.

release(S) ->
    S!{release}.

acquire(S) ->
    R = make_ref(),
    S!{acquire,self(),R},
    receive
	{ok,R} ->
	    ok
    end.
