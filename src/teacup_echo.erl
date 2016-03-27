-module(teacup_echo).

-export([connect/0,
         connect/1]).

connect() ->
    connect(#{messages => 10, reconnect => true}).

connect(Opts) ->
    {ok, C} = teacup:new(echo@teacup, Opts),
    teacup:connect(C, <<"127.0.0.1">>, 4999),
    {ok, C}.