-module(time).
-export([swedish_date/0]).

% Returns a string containing the date in Swedish YYMMDD format.
swedish_date() ->
  {Y, M, D} = date(),
  [_,_|Y2] = integer_to_list(Y),
  lists:flatten(io_lib:format('~s~2..0b~2..0b', [Y2, M, D])).

