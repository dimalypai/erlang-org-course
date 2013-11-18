-module(lists1).
-export([min1/1, max1/1, min_max/1, min_max1/1]).

% Returns the minimum element of the non-empty list.
min1([H|T]) -> min1(T, H).

% Helper function that has an accumulator to carry the current minimum value.
min1([], Min) -> Min;
min1([H|T], Min) -> min1(T, min(Min, H)).

% Returns the maximum element of the non-empty list.
max1([H|T]) -> max1(T, H).

% Helper function that has an accumulator to carry the current maximum value.
max1([], Max) -> Max;
max1([H|T], Max) -> max1(T, max(Max, H)).

% Returns a tuple with the minimum and the maximum elements of the non-empty list.
min_max(L) -> {min1(L), max1(L)}.

% Alternative version of min_max that traverses the list only once.
min_max1([H|T]) -> min_max1(T, H, H).

% Helper function with two accumulators.
min_max1([], Min, Max) -> {Min, Max};
min_max1([H|T], Min, Max) -> min_max1(T, min(Min, H), max(Max, H)).

