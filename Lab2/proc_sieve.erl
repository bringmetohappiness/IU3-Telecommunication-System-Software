-module(proc_sieve).
-export([generate/1, sieve/0, gen_print/1]).


generate(MaxN) ->
	PID = spawn(proc_sieve, sieve, []), generate_helper(2, MaxN, PID),
	receive
		Primes -> Primes
	end.

generate_helper(N, MaxN, PID) when N =< MaxN -> 
	PID ! {send, N}, generate_helper(N + 1, MaxN, PID);
generate_helper(N, MaxN, PID) when N > MaxN ->
	PID ! {done, self()}.


sieve() ->
	receive
		{send, First} -> sieve_helper(First)
	end.

sieve_helper(Divisor) ->
	receive
		{send, Number} ->
			if
				Number rem Divisor == 0 ->
					sieve_helper(Divisor);
				true ->
					New_PID = spawn(proc_sieve, sieve, []),
					New_PID ! {send, Number},
					sieve_helper_helper(Divisor, New_PID)
			end;
		{done, ReqPID} ->
			ReqPID ! [Divisor]
	end.

sieve_helper_helper(Divisor, New_PID) ->
	receive
		{send, Number} ->
			if
				Number rem Divisor == 0 -> ok;
				true -> New_PID ! {send, Number}
			end,
			sieve_helper_helper(Divisor, New_PID);
		{done, ReqPID} ->
			New_PID ! {done, self()},
			receive
				Primes ->
					ReqPID ! [Divisor | Primes]
			end
	end.


gen_print(MaxN) -> 
	Primes = generate(MaxN),
	lists:foreach(fun(E) -> io:format("~w~n", [E]) end, Primes).