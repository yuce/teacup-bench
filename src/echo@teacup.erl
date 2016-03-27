-module(echo@teacup).
-behaviour(teacup_server).

-export([teacup@init/1,
         teacup@data/2,
         teacup@error/2,
         teacup@status/2,
         teacup@info/2]).

teacup@init(Opts) ->
    MaxMessages = maps:get(messages, Opts, 1),
    {ok, Opts#{messages => MaxMessages}}.

teacup@data(_Data, #{parent@ := Parent,
                     ref@ := Ref,
                     messages := 0} = State) ->
    Parent ! {Ref, done},
    {stop, normal, State};

teacup@data(Data, #{messages := Messages} = State) ->
    % erlang:send_after(1000, self(), {send_for_real, Data}),
    teacup_server:send(self(), Data),
    {noreply, State#{messages => Messages - 1}}.

teacup@error(Reason, State) ->
    case Reason of
        econnrefused ->
            io:format("Could not connect, retrying to connect...~n"),
            erlang:send_after(1000, self(), reconnect),
            {noreply, State};
        no_socket ->
            % Ignorin no socket error in this xase,
            % since we will receive {disconnect, false} status
            {noreply, State};
        _ ->
            io:format("GOT ERROR: ~p~n", [Reason]),
            {error, Reason, State}
    end.

teacup@status({disconnect, false}, #{reconnect := true} = State) ->
    io:format("Disconnected, will reconnect...~n"),
    teacup_server:connect(self()),
    {noreply, State};

teacup@status(Status, State) ->
    io:format("New status: ~p~n", [Status]),
    {noreply, State}.

teacup@info({send_for_real, Data}, #{messages := Messages} = State) ->
    teacup_server:send(self(), Data),
    {noreply, State#{messages => Messages - 1}};

teacup@info(reconnect, State) ->
    teacup_server:connect(self()),
    {noreply, State}.