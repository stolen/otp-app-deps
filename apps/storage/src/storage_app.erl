-module(storage_app).
-export([start/2, fake_sup/0]).

start(_, _) ->
  proc_lib:start_link(?MODULE, fake_sup, []).

fake_sup() ->
  case application:get_env(toplevel, storage_conf) of
    {ok, #{do_communicate := true}} ->
      {ok, running} = application:get_env(communicate, status);
    _ ->
      ok
  end,
  proc_lib:init_ack({ok, self()}),
  loop().

loop() ->
  receive
    stop -> ok;
    _ -> loop()
  end.
