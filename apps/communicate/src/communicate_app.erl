-module(communicate_app).
-export([start/2, fake_sup/0]).

start(_, _) ->
  proc_lib:start_link(?MODULE, fake_sup, []).

fake_sup() ->
  case application:get_env(toplevel, comm_conf) of
    {ok, #{}} -> proc_lib:init_ack({ok, self()}), loop();
    _ -> error(env_not_ready)
  end.

loop() ->
  application:set_env(communicate, status, running),
  receive
    stop -> ok;
    _ -> loop()
  end.
