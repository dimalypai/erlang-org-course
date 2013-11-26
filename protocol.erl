-module(protocol).
-export([start/1, process/0]).

% Start 2 processes and send a message M times forewards and backwards between them.

% Starts 2 processes and originates the communication.
start(M) ->
  Pid1 = spawn(protocol, process, []),
  io:format("Created ~w~n", [Pid1]),
  Pid2 = spawn(protocol, process, []),
  io:format("Created ~w~n", [Pid2]),
  Pid1 ! {Pid2, Pid1, 2 * M}. % forewards and backwards

% Main process function, sending message back and updating the counter.
% When it is 0 -> sends stop message.
process() ->
  receive
    stop -> io:format("~w stopped~n", [self()]);
    {From, _, 0} -> io:format("~w stopped~n", [self()]),
                    From ! stop;
    {From, To, M} -> io:format("~w received message~n", [self()]),
                     From ! {To, From, M - 1},
                     process()
  end.

