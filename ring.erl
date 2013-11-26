-module(ring).
-export([start/2, process/0]).

% Start N processes in a ring, and send a message M times around all the processes in the ring.

% Starts N processes and sends a message to the first one.
start(N, M) ->
  AllProcs = [ spawn(ring, process, []) || _ <- lists:seq(0, N - 1) ],
  io:format("Created ~b processes~n", [length(AllProcs)]),
  [Pid1|Procs] = AllProcs,
  Pid1 ! {Procs, [Pid1], M}.

% Main process function. Sends message to the next process in the ring.
% The counter is updated when the recepients list is empty -> start from scratch.
% When the counter is zero -> send stop message.
process() ->
  receive
    stop -> io:format("~w stopped~n", [self()]);

    {Procs, _, 0} -> io:format("~w stopped~n", [self()]),
                     [ Proc ! stop || Proc <- Procs ];

    {[], [Proc1|ProcsReceived], M} ->
      io:format("~w received message~n", [self()]),
      Proc1 ! {ProcsReceived, [Proc1], M - 1},
      process();

    {[Proc1|Procs], ProcsReceived, M} ->
      io:format("~w received message~n", [self()]),
      Proc1 ! {Procs, ProcsReceived ++ [Proc1], M},
      process()
  end.

