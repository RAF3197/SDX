module(server2).
%% Exported Functions
-export([start/0, start/1]).

start() ->
    ServerPid = spawn(fun() -> init_server() end),
    register(myserver, ServerPid).

start(BootServer) ->
    ServerPid = spawn(fun() -> init_server(BootServer) end),
    register(myserver, ServerPid).

init_server() ->
    process_requests([], [self()]).

init_server(BootServer) ->
    BootServer ! {server_join_req, self()},
    process_requests([], []).

process_requests(Clients, Servers) ->
    receive
        %% Messages between client and server
        {client_join_req, Name, From} ->
            NewClients = [Name|Clients],  %% TODO: COMPLETE
            broadcast(NewClients, {join, Name}),  %% TODO: COMPLETE
            process_requests(NewClients,Servers);  %% TODO: COMPLETE
       
            
        %% Messages between servers
        disconnect ->
            NewServers = lists:add(self(),Servers),  %% TODO: COMPLETE
            broadcast(NewServers, {update_servers,NewServers}),  %% TODO: COMPLETE
            unregister(myserver);
        {server_join_req, From} ->
            NewServers = [From|Servers],  %% TODO: COMPLETE
            broadcast(NewServers, {update_servers, NewServers}),  %% TODO: COMPLETE
            process_requests(Clients, NewServers);  %% TODO: COMPLETE
        {update_servers, NewServers} ->
            io:format("[SERVER UPDATE] ~w~n", [NewServers]),
            process_requests(Clients, NewServers);  %% TODO: COMPLETE
            
        RelayMessage -> %% Whatever other message is relayed to its clients
            broadcast(Clients, RelayMessage),
            process_requests(Clients, Servers)
    end.

broadcast(PeerList, Message) ->
    Fun = fun(Peer) -> Peer ! Message end,
    lists:map(Fun, PeerList).
