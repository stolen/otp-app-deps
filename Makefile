all:
	./rebar3 compile

clean:
	rm -rf _build

boot:
	# storage atom is created before calling the boot function
	ERL_LIBS=_build/default/lib erl -eval 'storage, toplevel_app:boot(), timer:sleep(200), io:format("~n~120p~n", [application:which_applications()]).'

util:
	ERL_LIBS=_build/default/lib erl -eval 'application:ensure_all_started(storage), timer:sleep(200), io:format("~n~120p~n", [application:which_applications()]).'
