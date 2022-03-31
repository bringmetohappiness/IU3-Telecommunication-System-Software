-module(fib).
-export([fib_p/1, fib_g/1, tail_fib/1, start/0]).

% Функция со сравнением аргумента с образцом
fib_p(0) -> 0;
fib_p(1) -> 1;
fib_p(N) -> fib_p(N-1) + fib_p(N-2).

% Функция со сторожевыми последовательностями
fib_g(N) when N == 0 -> 0;
fib_g(N) when N == 1 -> 1;
fib_g(N) when N > 1 -> fib_p(N-1) + fib_p(N-2).

% Функция с хвостовой рекурсией
tail_fib(N) when N >= 1 -> tail_fib_helper(N, 1, 0, 1);
tail_fib(N) when N < 1 -> 0.
tail_fib_helper(N, NumCur, _, Cur) when N == NumCur -> Cur;
tail_fib_helper(N, NumCur, Prev, Cur) -> tail_fib_helper(N, NumCur + 1, Cur, Prev + Cur).


start() ->
  X = tail_fib(3),
  io:format("fib = ~w ",[X]).
