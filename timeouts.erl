-module(timeouts).
-export([sleep/1, suspend/0, alarm/2, set_alarm/3, flush/0]).

% Process suspends for T ms.
sleep(T) ->
  receive
  after T -> true
  end.

% Process suspends indefinitely.
suspend() ->
  receive
  after infinity -> true
  end.

% The messahe What is sent to the current process in T ms from now.
alarm(T, What) -> spawn(timeouts, set_alarm, [self(), T, What]).

set_alarm(Pid, T, What) ->
  receive
  after T -> Pid ! What
  end.

% Flushes the message buffer.
flush() ->
  receive
    _ -> flush()
  after 0 -> true
  end.

