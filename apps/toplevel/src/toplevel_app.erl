-module(toplevel_app).
-export([boot/0]).
-export([start/2, fake_sup/0]).


boot() ->
  application:set_env(toplevel, storage_conf, #{do_communicate => true}),
  application:set_env(toplevel, comm_conf, #{}),
  application:ensure_all_started(toplevel).

start(_, _) ->
  proc_lib:start_link(?MODULE, fake_sup, []).

fake_sup() ->
  proc_lib:init_ack({ok, self()}),
  loop().

loop() ->
  receive
    stop -> ok;
    _ -> loop()
  end.
