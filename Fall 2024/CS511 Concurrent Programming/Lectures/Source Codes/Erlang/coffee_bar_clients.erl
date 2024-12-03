-module(coffee_bar_clients).
-compile(export_all).
-compile(nowarn_export_all).

start(NC,SIZE) ->
    CB = coffee_bar_stub:make(SIZE),
    [ spawn(?MODULE,client,[CB]) || _ <- lists:seq(1,NC)],
    ok.

client(CB) ->
    coffee_bar_stub:enter(CB),
    io:format("~p went in~n",[self()]),
    timer:sleep(rand:uniform(100)),
    coffee_bar_stub:leave(CB),
    io:format("~p went out~n",[self()]).


