%%%-------------------------------------------------------------------
%% @doc teacup-bench public API
%% @end
%%%-------------------------------------------------------------------

-module('teacup-bench_app').

-behaviour(application).

%% Application callbacks
-export([start/2
        ,stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    'teacup-bench_sup':start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================