-module(star).
-export([start/2, process/0]).

% Start N processes in a star, and send a message to each of them M times.

% Starts N processes and originates the communication by calling send.
start(N, M) ->
  Procs = [ spawn(star, process, []) || _ <- lists:seq(0, N - 1) ],
  io:format("Created ~b processes~n", [length(Procs)]),
  send(Procs, M).

% Sends messages from center and originates the receiving phase by calling receiveCenter.
% When the counter is 0 -> send stop message.
send(Procs, 0) ->
  io:format("Center stopped~n", []),
  [ Proc ! stop || Proc <- Procs ];
send(Procs, M) ->
  [ Proc ! {from_center, self()} || Proc <- Procs ],
  receiveCenter(Procs, length(Procs), M - 1).

% Receives messages from all processes to the center.
% When the counter is 0 -> switch to the sending phase.
receiveCenter(Procs, 0, M) -> send(Procs, M);
receiveCenter(Procs, N, M) ->
  receive
    {to_center, From} ->
      io:format("Center received message from ~w~n", [From]),
      receiveCenter(Procs, N - 1, M)
  end.

% Function for non-center processes.
% Receives message from center and sends the message back.
% Terminates on stop message.
process() ->
  receive
    stop -> io:format("~w stopped~n", [self()]);
    {from_center, Center} ->
      io:format("~w received message~n", [self()]),
      Center ! {to_center, self()},
      process()
  end.

