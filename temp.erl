-module(temp).
-export([f2c/1, c2f/1, convert/1]).

% Converts Fahrenheit to Celsius.
f2c(F) -> (F - 32) * (5 / 9).

% Converts Celsius to Fahrenheit.
c2f(C) -> C * (9 / 5) + 32.

% Converts Fahrenheit to Celsius given {f, F},
% Converts Celsius to Fahrenheit given {c, C}.
convert({f, F}) -> {c, f2c(F)};
convert({c, C}) -> {f, c2f(C)}.

