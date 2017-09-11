defmodule Processes.GenServers do
  @moduledoc """

  A GenServer is an Elixir process used to manage state, execute code asynchronously, etc. These processes can be added into a supervision tree and include functionality for tracing and error reporting.

  ## Example

      defmodule Session.MailBox do
        use GenServer

        def start_link,
          do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

      end


  * Both `start_link/3` and `start/3` support the GenServer to register a name on start via the `:name` option. If the `:name` option is not provided then the pid is used to communicate with the GenServer. Names can be the following:

      1. an atom - registered locally with the given name. Module names are atoms
      2. `{:global, term}` - registered globally with the given term
      3. `{:via, module, term}` - registered with the given mechanism and name.

  Once the server is started the registered name or pid can be used to communicate with the GenServer.

  """
end

defmodule Processes.GenServers.Callbacks do
  @moduledoc """

  There are 6 callbacks required to be implemented in a GenServer. By adding use GenServer to your module, Elixir will automatically define all 6 callbacks for you, leaving it up to you to implement the ones you want to customize.

  There are three common callbacks that should be understood:

  1. `handle_call/3` - used for synchronous requests
  2. `handle_cast/2` - used for asynchronous requests
  3. `handle_info/2` - all other messages a server may receive.

  """
end

defmodule Processes.Supervisors do
  @moduledoc """

  A supervisor is a process which supervises other processes, which we refer to as child processes. Supervisors are used to build a hierarchical process structure called a supervision tree. Supervision trees are a nice way to structure fault-tolerant applications.


  * Module-based supervisors


      defmodule Background.Calculator.Supervisor do
        use Supervisor

        def start_link,
          do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

        def init([]) do
          children = [
            worker(Background.Calculator, [], restart: :transient)
          ]

          supervise(children, strategy: :simple_one_for_one)
        end

        def start_calculator(code),
          do: Supervisor.start_child(__MODULE__, [code])

      end


  """
end
