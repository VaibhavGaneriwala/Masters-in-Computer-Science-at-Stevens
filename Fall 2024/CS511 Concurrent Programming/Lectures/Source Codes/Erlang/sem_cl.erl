-module(sem_cl).
-compile(export_all).
-compile(nowarn_export_all).

start() ->
    S = sem:make(0),
    spawn(?MODULE,client1,[S]),
    spawn(?MODULE,client2,[S]),
    ok.

client1(S) ->
    sem:acquire(S),
    io:format("a\n").

client2(S) ->
    io:format("b\n"),
    sem:release(S).
