-module(ms).
-export([start/1, to_slave/2, master/0, slave/1]).

% Starts the master and tells it to create N processes.
% Master is registered as master.
start(N) ->
  register(master, spawn(ms, master, [])),
  master ! {create, N}.

% Master process.
% Traps exit messages.
% Creates N processes and continues as master/1.
master() ->
  process_flag(trap_exit, true),
  receive
    {create, N} -> master([ {spawn_link(ms, slave, [I]), I} || I <- lists:seq(1, N) ])
  end.

% Maintains a list of slaves.
% Relays messages to the slaves.
% Restarts slaves on exit.
master(Slaves) ->
  receive
    {relay, Message, N} ->
      {SlavePid, _} = lists:nth(N, Slaves),
      SlavePid ! Message,
      master(Slaves);
    {'EXIT', Pid, _} ->
      {_, I} = lists:keyfind(Pid, 1, Slaves),
      io:format("Restarting slave ~b~n", [I]),
      master(lists:keyreplace(I, 2, Slaves, {spawn_link(ms, slave, [I]), I}))
  end.

% Relay message to the slave N.
to_slave(Message, N) ->
  master ! {relay, Message, N}.

% Slave process function.
% Gets and prints messages.
% Exits on message die.
slave(I) ->
  receive
    die -> exit(die);
    Message -> io:format("Slave ~b got message ~w~n", [I, Message]), slave(I)
  end.

