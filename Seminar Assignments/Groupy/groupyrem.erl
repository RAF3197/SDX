-module(groupyrem).
-export([start/2, stop/0,stop/2]).

% We use the name of the module (i.e. gms3) as the parameter Module to the start procedure. Sleep stands for up to how many milliseconds the workers should wait until the next message is sent.

start(Module, Sleep) ->
    
    spawn('node5@127.0.0.1', fun() -> register(a, worker:start("P1", Module, Sleep)) end),
    
    spawn('node1@127.0.0.1', fun() -> register(b, worker:start("P2", Module, {a,'node5@127.0.0.1'} , Sleep)) end),
    
    spawn('node2@127.0.0.1', fun() -> register(c, worker:start("P3", Module, {a,'node5@127.0.0.1'}, Sleep)) end),

    spawn('node3@127.0.0.1', fun() -> register(d, worker:start("P4", Module, {a,'node5@127.0.0.1'}, Sleep)) end),
    
    spawn('node4@127.0.0.1', fun() -> register(e, worker:start("P5", Module, {a,'node5@127.0.0.1'}, Sleep)) end).                  

stop() ->
     {a,'node5@127.0.0.1'} ! stop,
     {b,'node1@127.0.0.1'} ! stop,
     {c,'node2@127.0.0.1'} ! stop,
     {d,'node3@127.0.0.1'} ! stop,
     {e,'node4@127.0.0.1'} ! stop.

stop(Name, Node) ->
    case whereis(Name) of
        undefined ->
            ok;
        Pid ->
            {Pid,Node} ! stop
    end.
