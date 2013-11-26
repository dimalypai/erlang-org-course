-module(echo).
-export([go/0, loop/0]).

% Simple echo process

% Spawns a process with loop.
% Sends hello.
% Receives the message.
% Sends stop.
go() ->
  Pid2 = spawn(echo, loop, []),
  Pid2 ! {self(), hello},
  receive
    {Pid2, Msg} -> io:format("P1 ~w~n", [Msg])
  end,
  Pid2 ! stop.

% Sends the received message back.
% If the message is stop - terminates with true.
loop() ->
  receive
    {From, Msg} -> From ! {self(), Msg},
                   loop();
    stop -> true
  end.

