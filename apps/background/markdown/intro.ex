defmodule Intro do
  @moduledoc """
  -\n
  -\n
  -\n
  -\n
  -\n
  -\n
  -\n
  -\n




  # Not so Intro, Intro to Elixir


         Johnny Winn



  ## Notes:

      Twitter: @johnny_rugger & @elixirfountain & @elixirdaze\n
      Podcast: http://soundcloud.com/elixirfountain
      Conference: http://elixirdaze.com

  """

end

defmodule Employment do
  @moduledoc """

      Enbala Power Networks\n
      http://www.enbala.com

  """

end

defmodule AboutElixir do
  @moduledoc """

  Elixir is a dynamic, functional language designed for building scalable and maintainable
  applications.

  Elixir leverages the Erlang VM, known for running low-latency, distributed and fault-tolerant
  systems, while also being successfully used in web development and the embedded software domain.

  To learn more about Elixir, check our getting started guide. Or keep reading to get an overview
  of the platform, language and tools.

  ## Key Features:

  Scalability, Fault-tolerance

  ## Examples:

      iex(1)> 40 + 2
      42
      iex(2)> "hello" <> " world"
      "hello world"\n

  # Links:
  http://www.elixir-lang.org


  \n

  """
end

defmodule BasicTypes do
  @moduledoc """

  Yes! Elixir has basic types but doesn't every language?

  ## Examples

      iex> 1          # integer
      iex> 0x1F       # integer
      iex> 1.0        # float
      iex> true       # boolean
      iex> :atom      # atom
      iex> "elixir"   # string
      iex> [1, 2, 3]  # list
      iex> {1, 2, 3}  # tuple

  But there are some things to note...

  * Everything has it's place...

      `number < atom < reference < function < port < pid < tuple < map < list < bitstring`

  * Although it's a dynamically typed language we can use typespecs to declare types & specifications

    1. They provide documentation (for example, tools such as ExDoc show type specifications in the documentation)
    2. They’re used by tools such as Dialyzer, that can analyze code with typespec to find type inconsistencies
      and possible bugs

  ## Examples

      defmodule Buffalo.Struct do

        defstruct [:id, :name]

        @type t :: %Buffalo.Struct{}

        @spec build(params :: Map) :: {:ok, Map.t} | {:error, reason :: Binary}
        def build(params) do
           # Do something that returns `{:ok, %Buffalo{}}` or `{:error, reason}`
        end

      end

  https://hexdocs.pm/elixir/typespecs.html

  """
end

defmodule BasicTypes.Atoms do
  @moduledoc """

  * Atoms are not garbage collected. 	By default, the maximum number of atoms
  is 1,048,576. Be very careful dynamically creating atoms.

  ## Examples

      iex> :atom
      :atom
      iex> String.to_existing_atom("atom")
      :atom
      iex> String.to_existing_atom("blah")
      ** (ArgumentError) argument error
        :erlang.binary_to_existing_atom("blah", :utf8)

  * One other note about atoms, the name of a module is just an atom

  ## Examples

      iex(16)> is_atom(String)
      true

  https://hexdocs.pm/elixir/Atom.html

  """
end


defmodule BasicTypes.Lists do
  @moduledoc """

  * Lists are stored in memory as linked lists, meaning that each element in a list holds its
  value and points to the following element until the end of the list is reached. We call each
  pair of value and pointer a cons cell:

  ## Examples

      iex> list = [1 | [2 | [3 | []]]]
      [1, 2, 3]
      iex> [first | rest] = list
      [1, 2, 3]
      iex> first
      1

  Separating the head from the rest of the list makes recurrsive calls. You can even grab multiple
  values from the list at a time

  ## Examples

      def fibonacci(length),
        do: calculate(length, [])

      defp calculate(length, []),
        do: calculate(length - 1, [0])

      defp calculate(length, [0]),
        do: calculate(length - 1, [1, 0])

      defp calculate(length, [a, b | _rest] = acc) when length > 0,
        do: calculate(length - 1, [a + b | acc])

      defp calculate(0, acc),
        do: Enum.reverse(acc)

  https://hexdocs.pm/elixir/List.html

  """
end

defmodule AnonymousFunctions do
  @moduledoc """

  Functions in Elixir are identified by both their name and their arity. The arity of a
  function describes the number of arguments which the function takes.

  Anonymous functions can be created inline and are delimited by the keywords `fn` and `end`:

  ## Examples

      iex> add = fn a, b -> a + b end
      #Function<12.71889879/2 in :erl_eval.expr/5>
      iex> add.(1, 2)
      3
      iex> is_function(add)
      true
      iex> is_function(add, 2) # check if add is a function that expects exactly 2 arguments
      true
      iex> is_function(add, 1) # check if add is a function that expects exactly 1 argument
      false


  Functions can be passed as arguments to other functions in the same way as integers and
  strings. There's also a short hand syntax for anonymous functions that is commonly used

  ## Examples

      iex> func = &(&1 - 2)
      #Function<6.118419387/1 in :erl_eval.expr/5>
      iex> func.(4)
      2

  ## Examples

  You can pipe directly to anonymous too!

  ## Examples

      iex> %{first: "Bob", last: "Dobbs"} |> (fn(user) -> "\#{user.first} \#{user.last}" end).()
      "Bob Dobbs"

      # Or the short hand:
      iex> %{first: "Bob", last: "Dobbs"} |> (&("\#{&1.first} \#{&1.last}")).()

  """
end

defmodule Modules do
  @moduledoc """

  Elixir uses modules to group functions with similar functionality or purpose together.
  They can be defined in memory or compiled from files.

  ## Example

      iex> defmodule Math do
      ...>   def sum(a, b) do
      ...>     a + b
      ...>   end
      ...> end

      iex> Math.sum(1, 2)
      3

  * Named functions must be defined in modules using either `def/2` or `defp/2`. These are
  public and private respectively.

  * Functions also support guards and multiple clauses.

  ## Examples

      defmodule Math do
        def zero?(0), do: true
        def zero?(x) when is_integer(x), do: false
      end

      IO.puts Math.zero?(0)         #=> true
      IO.puts Math.zero?(1)         #=> false
      IO.puts Math.zero?([1, 2, 3]) #=> ** (FunctionClauseError)
      IO.puts Math.zero?(0.0)       #=> ** (FunctionClauseError)


  Functions can also be passed as arguments. Let's take our Math module we can iterate over a
  list of numbers and check for zero or with an anonymous function.

  ## Examples

     iex> Enum.map([0,1,2,3,4], &Math.zero?/1)
     [true, false, false, false, false]

     iex> rfn = fn(n) -> is_integer(n) end)
     iex> Enum.map([1,2,"T"], rfn)
     [true, true, false]

  https://hexdocs.pm/elixir/Module.html

  """
end

defmodule Workflows do
  @moduledoc """

  Building workflows and recovering from errors using the `with/1`

  The `with/1` statement matches the value produced on the right with the pattern on the left.
  If there is a match then the next function is called. If the value on the right does not
  match the pattern then the non-matching value is returned. You can add additional patterns
  following an else to handle non-matching values.

  ## Examples

      def retrieve_data(%Sheet{} = sheet) do
        with {:ok, pid} <- client().get_spreadsheet(sheet),
             {:ok, sheet} <- merge_pid(sheet, pid),
             {:ok, sheet} <- update_refresh_rate(sheet),
             {:ok, data} <- client().fetch_data(sheet),
             {:ok, data} <- convert_to_map(data),
             {:ok, _sheet} = result <- merge_data(sheet, data) do
          result
        else
          error ->
            # Do something to deal with the error
            {:error, error}
        end
      end


  * Phoenix 1.3 leverages `with/1` to render error messages.

  ## Examples: From 1.3 Docs

      defmodule ApiWeb.Api.V1.ResourceController do
        use ApiWeb, :controller

        action_fallback ApiWeb.Api.V1.FallbackController

        def action(%{params: %{"type" => type}} = conn, _opts) do
          params = conn.params["data"] || conn.params

          with {:ok, handler} <- handler_for(type),
               {:ok, view_module} <- view_for(type) do

            conn = put_view(conn, view_module)
            apply(__MODULE__, action_name(conn), [conn, params, handler])
          end
        end
      end

  https://hexdocs.pm/elixir/Kernel.SpecialForms.html#with/1

  * Saga Pattern for distributed workflows
  https://soundcloud.com/elixirfountain/episode-069-the-saga-of-distributed-systems-and-bbq-with-mark-allen

  """
end


defmodule AgentsTasks do
  @moduledoc """

  There are 2 types of abstractions around GenServers: Agents & Tasks

  Agents are designed for storing state and Tasks are for short lived processes meant to
  execute one action. Both can be added to supervision trees.

  Agents:

  ## Examples

      iex> {:ok, pid} = Agent.start_link(fn -> %{} end)
      iex> {:ok, pid} = Agent.start_link(fn -> %{} end)
      {:ok, #PID<0.141.0>}
      iex> Agent.update(pid, &(Map.put(&1, 1, %{name: "Bob Dobbs"})))
      :ok
      iex> Agent.get(pid, &(Map.get(&1, 1)))
      %{name: "Bob Dobbs"}


  Tasks:

  ## Examples

      iex> task = Task.async(fn -> 1..10 |> Enum.sum  end)
      %Task{owner: #PID<0.121.0>, pid: #PID<0.148.0>, ref: #Reference<0.0.3.1155>}
      iex> Task.await(task)
      55

  https://hexdocs.pm/elixir/Task.html

  """
end

defmodule Agents do
  @moduledoc """

  Agents are great when you don't know enough about the persistence layer and/or don't
  care.

  ## Examples

      defmodule MyAgent do

        def start_link(bucket \\ __MODULE__) do
          Agent.start_link(fn -> %{} end, name: bucket)
        end

        def get(bucket \\ __MODULE__, id) do
          {:ok, Agent.get(bucket, &(Map.get(&1, id)))}
        end

        def update(bucket \\ __MODULE__, %{"id" => id} = item) do
          Agent.update(pid, &(Map.put(&1, 1, item)))
        end
      end

  * When to use Agents??? Prototyping, smaller caches, etc

  https://hexdocs.pm/elixir/Agent.html

  """
end

defmodule GenServers do
  @moduledoc """

  A GenServer is an Elixir process used to manage state, execute code asynchronously, etc.
  These processes can be added into a supervision tree and include functionality for
  tracing and error reporting.

  ## Examples

      defmodule Session.MailBox do
        use GenServer

        def start_link,
          do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

      end


  * Both `start_link/3` and `start/3` support the GenServer to register a name on start via
  the `:name` option. If the `:name` option is not provided then the pid is used to
  communicate with the GenServer. Names can be the following:

      1. an atom - registered locally with the given name. Module names are atoms
      2. `{:global, term}` - registered globally with the given term
      3. `{:via, module, term}` - registered with the given mechanism and name.

  Once the server is started the registered name or pid can be used to communicate with
  the GenServer.

  * :gproc & Registry both allow you to track pids and call by an identifier

  """
end

defmodule GenServers.Callbacks do
  @moduledoc """

  There are 6 callbacks required to be implemented in a GenServer. By adding use GenServer
  to your module, Elixir will automatically define all 6 callbacks for you, leaving it up
  to you to implement the ones you want to customize.

  There are three common callbacks that should be understood:

  1. `handle_call/3` - used for synchronous requests
  2. `handle_cast/2` - used for asynchronous requests
  3. `handle_info/2` - all other messages a server may receive.

  https://hexdocs.pm/elixir/GenServer.html

  """
end

defmodule Supervisors do
  @moduledoc """

  A supervisor is a process which supervises other processes, which we refer to as child
  processes. Supervisors are used to build a hierarchical process structure called a
  supervision tree. Supervision trees are a nice way to structure fault-tolerant applications.

  * Module-based supervisors

  ## Examples

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

  * Restart values

  1. `:permanent` - the child process is always restarted (default)
  2. `:temporary` - the child process is never restarted
  3. `:transient` - the child process is restarted only if it terminates abnormally


  https://hexdocs.pm/elixir/Supervisor.Spec.html

  """
end

defmodule ProcessState do
  @moduledoc """

  State is managed withing the scope of a process. Only that process can directly change
  its state.


  ## Examples

      def start_link,
        do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

      def init(_args),
        do: {:ok, %{current_step: :intro, next_step: :first_example, paused: true}}

      def handle_info(:intro, %{paused: false} = state) do
        send_doc("Buffalo Elixir/Phoenix Meetup", Intro)

        {:noreply, %{state|current_step: :intro, next_step: :what_is_elixir}}
      end

  """
end

defmodule MessagePassing do
  @moduledoc """

  # How can we send messages?

  There are a number of ways to send messages to processes but the following will be used
  most in the upcoming examples.

  1. `send/2` - sends a message to a process
  2. `Process.send_after/3` - sends a message to a process after a set time
  3. Using `call/3`, `cast/2` on GenServer

  Moving to more code!!!

  """
end

defmodule HotSwap do
  @moduledoc """

  Code can be changed while the system stays up.

  ## Examples

      iex> :sys.suspend(Background.Messenger)
      :ok
      iex> c("lib/messenger.ex")
      warning: redefining module Background.Messenger (current version loaded from /Users/Brooke/Dropbox/src/ndc/_build/dev/lib/background/ebin/Elixir.Background.Messenger.beam)
      lib/messenger.ex:1

      [Background.Messenger]
      iex> :sys.resume(Background.Messenger)

  """
end

defmodule CodeLoading do
  @moduledoc """

  We can use the Erlang code library to get the modules code and read it into binary format.
  Then the code can be sent to another process/node and recompiled into memory. The code
  will live compiled in memory until the application stops

  ## Examples

      iex> {mod, binary, file} = :code.get_object_code(__MODULE__)
      iex> {:module, mod} =  :code.load_binary(mod, file, binary)

  """

end

defmodule ReadingCodeExample do
  @moduledoc """

  Let's take the following code and package it up to run on our background server.

  ## Examples

      defmodule Sequencer do

        def fibonacci(length),
          do: calculate(length, [])

        defp calculate(length, []),
          do: calculate(length - 1, [0])

        defp calculate(length, [0]),
          do: calculate(length - 1, [1, 0])

        defp calculate(length, [a, b | _rest] = acc) when length > 0,
          do: calculate(length - 1, [a + b | acc])

        defp calculate(0, acc),
          do: Enum.reverse(acc)

        def get_code(),
          do: :code.get_object_code(__MODULE__)

      end

  ## Examples

      defmodule Session do

        def calculate_sequence(length, count \\ 1) do
          code = Sequencer.get_code()
          Enum.map(1..count, fn(_n) ->
            Task.async(fn() ->
              GenServer.cast(@messenger, {:start_calculation, length, code})
            end)
          end)

          :ok
        end

      end

  """
end

defmodule LoadingCodeExample do
  @moduledoc """

  On our backend server we recieve the message with a `handle_cast/2` and call our calculator
  supervisor. Then we can execute the calulator.

  ## Examples

      def handle_cast({:start_calculation, length, code}, state) do
        {:ok, pid} = Background.Calculator.Supervisor.start_calculator(code)

        heading = "Fibonacci Results for \#{length}"

        time = timed_task do
          results = Background.Calculator.calculate(pid, length)
        end

        session_example(heading, "\#{inspect results}")
        session_message(time)

        {:noreply, state}
      end

  Starting the calculator:

  ## Examples

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


    The Background Calculator loads the code and let's use run the `fibonacci/2` function on
    our loaded code.

  ## Examples

      defmodule Background.Calculator do
        use GenServer

        def start_link({_mod, _binary, _file} = code),
          do: GenServer.start_link(__MODULE__, code)

        def init(code) do
          send(self(), :load)
          {:ok, code}
        end

        def calculate(pid, length),
          do: GenServer.call(pid, {:calculate, length})

        def handle_info(:load, {mod, binary, file}) do
          {:module, mod} = :code.load_binary(mod, file, binary)
          {:noreply, mod}
        end

        def handle_info(:exit, _state) do
          Process.exit(self(), :normal)
          {:noreply, nil}
        end

        def handle_call({:calculate, length}, _from, mod) do
          result = mod.fibonacci(length)
          Process.send_after(self(), :exit, 200)
          {:reply, result, mod}
        end

      end

  """
end

defmodule Behaviors do
  @moduledoc """

  Bonus Material!!

  Behaviours help to maintain contracts with functions. Using callbacks to define a set up
  behaviours you can leverage dialyzer to warn when those contracts are broken.

  ## Examples

      defmodule Spreadsheets.Sheet do

        @callback retrieve_data(sheet :: %Sheet{}) :: {:ok, sheet :: %Sheet{}} :: {:error, reason :: Binary}
        @callback cell(sheet :: %Sheet{}, row :: Integer, col :: Integer) :: cell :: Binary
        @callback all(sheet :: %Sheet{}) :: all :: Map

        @default_refresh_rate 30_000

        @spec retrieve_data(sheet :: %Sheet{}) :: {:ok, sheet :: %Sheet{}} :: {:error, reason :: Binary}
        def retrieve_data(%Sheet{} = sheet) do
          with {:ok, pid} <- client().get_spreadsheet(sheet),
              {:ok, sheet} <- merge_pid(sheet, pid),
              {:ok, sheet} <- update_refresh_rate(sheet),
              {:ok, data} <- client().fetch_data(sheet),
              {:ok, data} <- convert_to_map(data),
              {:ok, _sheet} = result <- merge_data(sheet, data) do
            result
          else
            error ->
              {:error, error}
          end
        end

        @spec cell(sheet :: %Sheet{}, row :: Integer, col :: Integer) :: cell :: Binary
        def cell(%Sheet{} = sheet, row, col),
          do: sheet.sheet[row][col]

        @spec all(sheet :: %Sheet{}) :: all :: Map
        def all(%Sheet{} = sheet),
          do: sheet.sheet

      end

  If a module implements the `Spreadsheet.Sheet` behaviour then dialyzer will pick up on changes that
  cause it to go out of sync with the contract definitions.

  """
end

defmodule DependencyInjection do
  @moduledoc """

  * When is this helpful?


  ## Examples

      defmodule Spreadsheets.Data.SheetTest do
        use ExUnit.Case

        setup do
          Application.put_env(:spreadsheets, :sheet_logic, FakeSheetLogic)
          {:ok, _pid} = Sheet.start_link(%Sheet{name: "test", refresh_rate: 5_000})

          on_exit fn() ->
            Application.delete_env(:spreadsheets, :sheet_logic)
          end
        end

        test "return value from a cell" do
          # Test against the Fake
        end

        test "return all values from sheet" do
          # Test against the Fake
        end

        test "check for errors on populate" do
          # Test against the Fake
        end
      end

      defmodule FakeSheetLogic do
        @behaviour Spreadsheets.Data.Logic.Sheet

        alias Spreadsheets.Data.Sheet

        @valid_map %{
          0 => %{0 => "00", 1 => "11", 2 => "22"},
          1 => %{0 => "01", 1 => "12", 2 => "23"}
        }

        def retrieve_data(%Sheet{name: "test"} = sheet) do
          {:ok, Map.merge(sheet, %{sheet: @valid_map})}
        end

        def retrieve_data(%Sheet{name: "error_test"}) do
          {:error, "ugh"}
        end

        def cell(%Sheet{} = sheet, row, col),
          do: sheet.sheet[row][col]

        def all(%Sheet{} = sheet),
          do: sheet.sheet
      end

  """
end
