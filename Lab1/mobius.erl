-module(mobius).
-export([is_prime/1, prime_factors/1, is_square_multiple/1, find_square_multiples/2]).


% Функция проверяет простое ли число.
is_prime(N) -> is_prime_helper(N, 2).

is_prime_helper(N, Divisor) when Divisor * Divisor > N -> true;
is_prime_helper(N, Divisor) when Divisor * Divisor =< N -> 
	if 
		N rem Divisor == 0 -> false;
		true -> is_prime_helper(N, Divisor + 1)
	end.


% Функция возвращает список простых сомножителей числа
prime_factors(N) -> prime_factors_helper(N, 2, [1]).

prime_factors_helper(1, 2, [1]) -> [1];
prime_factors_helper(N, Factor, List) when N == Factor -> [Factor | List];
prime_factors_helper(N, Factor, List) when N /= Factor ->
	if
		N rem Factor == 0 -> 
			prime_factors_helper(N div Factor, Factor, [Factor | List]);
		true -> prime_factors_helper(N, Factor + 1, List)
	end.


% Функция проверяет делимость на квадрат простого числа
is_square_multiple(N) -> 
	List1 = prime_factors(N), 
	List2 = lists:usort(prime_factors(N)),
	case lists:sum(List1) == lists:sum(List2) of
		true -> false;
		false -> true
	end.


% Итоговая функция	
find_square_multiples(Count, MaxN) -> find_square_multiples_helper(Count, MaxN, 2, sets:new()).

find_square_multiples_helper(Count, MaxN, N, Set) when N < MaxN + Count -> 
	Logic = is_square_multiple(N),
	if 
		Logic -> New_Set = sets:add_element(N, Set), 
		case sets:size(New_Set) of
			Count -> New_List = sets:to_list(New_Set), lists:min(New_List);
			_Else -> find_square_multiples_helper(Count, MaxN, N + 1, New_Set)
		end;
		true -> find_square_multiples_helper(Count, MaxN, N + 1, sets:new())
	end;
find_square_multiples_helper(Count, MaxN, N, _) when N >= MaxN + Count -> 
	fail.
