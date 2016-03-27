-module(bench@).

-export([go/1]).
-export([bench/1]).

-define(SERVER, <<"127.0.0.1">>).
-define(PORT, 4999).

go(Messages) ->
    application:start(teacup),
    {ok, Conn} = teacup:new(echo@teacup, #{messages => Messages}),
    {MSec, ok} = timer:tc(?MODULE, bench, [Conn]),
    application:stop(teacup),
    {bench@, [{usec, MSec},
              {messages, Messages},
              {ops, ops(MSec, Messages)}]}.

ops(MSec, Messages) ->
    Messages / (MSec / 1000000).

bench(Conn) ->
    teacup:connect(Conn, ?SERVER, ?PORT),
    receive
        {Conn, done} ->
            ok
    end.

