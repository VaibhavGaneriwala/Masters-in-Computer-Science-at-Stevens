-module(calc).
-compile(nowarn_export_all).
-compile(export_all).

%% Name 1:
%% Name 2:

%% Example of evaluation:
%%
%% > calc:eval(calc:e1(),calc:env()).
%% {val,7}
%%%%
%% Example of evaluation:
%%
%% > eval:eval(eval:e2(),#{"x"=>8, "y"=>2}).
%% ** exception throw: division_by_zero_error


env() -> #{"x"=>3, "y"=>7}.

e1() -> %% Sample calculator expression
    {add, 
     [{const,3},
      {const,4},
      {divi,
       {var,"x"},
       {const,4}}
     ]}.

e2() -> %% Sample calculator expression
    {add, 
     [{const,3},
      {divi,
       {var,"x"},
       {const,0}}
     ]}.

e3() -> %% Sample calculator expression
    {add, 
     [{const,3},
      {divi,
       {var,"r"},
       {const,4}}
     ]}.


eval_list([],_Env,_F) ->
    throw(eval_list_empty);   %% List of expressions must be nonempty
eval_list([E],Env,_F) ->
    eval(E,Env);
eval_list([E|T],Env,F) ->
    {val,N1} = eval(E,Env),
    {val,N2} = eval_list(T,Env,F),
    {val,F(N1,N2)}.

eval({const,N},_Env) ->
    {val,N};
eval({var,Id},Env) ->
    case maps:find(Id,Env) of
	{ok,N} -> {val,N};
	error -> throw(unbound_identifier_error)
    end;
eval({add,L},Env) ->
    eval_list(L,Env,fun (X,Y) -> X+Y end);
eval({sub,E1,E2},Env) ->
    {val,N1} = eval(E1,Env),
    {val,N2} = eval(E2,Env),
    {val,N1-N2};
eval({mult,L},Env) ->
    eval_list(L,Env,fun (X,Y) -> X*Y end);
eval({divi,E1,E2},Env) ->
    {val,N1} = eval(E1,Env),
    case eval(E2,Env) of
	{val,0} ->
	    throw(division_by_zero_error);
	{val,N2} ->
	    {val,N1 div N2}
    end.
