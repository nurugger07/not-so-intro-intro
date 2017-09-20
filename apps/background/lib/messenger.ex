defmodule Background.Messenger do
  use GenServer

  import Utility

  alias Background.Message

  @steps %{
    1 => %{name: "What Is Elixir?", doc: AboutElixir, sub_pages: []},
    2 => %{name: "Basic Types & Curiosities", doc: BasicTypes, sub_pages: [
              %{name: "", doc: BasicTypes.Atoms, timer: 10000},
              %{name: "", doc: BasicTypes.Lists, timer: 10000}
            ]},
    3 => %{name: "Anonymous Functions", doc: AnonymousFunctions, sub_pages: []},
    4 => %{name: "Grouping Code In Modules", doc: Modules, sub_pages: []},
    5 => %{name: "Working with Workflows", doc: Workflows, sub_pages: []},
    6 => %{name: "Agents & Tasks", doc: AgentsTasks, sub_pages: [
              %{name: "Agents", doc: Agents, timer: 20000},
            ]},
    7 => %{name: "Graduating to Processes", doc: GenServers, sub_pages: [
              %{name: "GenServer Callbacks", doc: GenServers.Callbacks, timer: 20000},
              %{name: "Supervisors", doc: Supervisors, timer: 20000}
            ]},
    8 => %{name: "Message Passing & State", doc: ProcessState, sub_pages: [
              %{name: "Needs More State", doc: MessagePassing, timer: 20000},
            ]},
    9 => %{name: "Hot Swapping Code", doc: HotSwap, sub_pages: []},
    10 => %{name: "Code Loading @ Runtime", doc: CodeLoading, sub_pages: [
               %{name: "Reading the Code", doc: ReadingCodeExample, timer: 20000},
               %{name: "Loading the Code", doc: LoadingCodeExample, timer: 20000},
             ]},
    11 => %{name: "Bonus: Behaviors", doc: Behaviors, sub_pages: [
               %{name: "Dependency Injection", doc: DependencyInjection, timer: 20000}
             ]}
  }

  @event_name "Buffalo Elixir/Phoenix Meetup"
  @node Application.get_env(:background, :session_node)
  @session {Session.MailBox, @node}

  def start_link,
    do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_args) do
    send(self(), :starting_presentation)
    {:ok, %{current_step: :intro, next_step: 1, paused: false}}
  end

  def handle_info(:starting_presentation, state) do
    watch_node()
    {:noreply, state}
  end

  def handle_info(:intro, %{paused: false} = state) do
    send_doc(@event_name, Intro)
    :timer.sleep 5000
    send_doc("", Employment)

    {:noreply, %{state|current_step: :intro, next_step: 1}}
  end

  @doc """
  This is only here for the "HotSwap" slide. If not showing that slide then this can be removed.
  """
  def handle_info(9, state) do
    send(self(), :bad_message)
    {:noreply, state}
  end

  def handle_info(step, %{paused: false} = state) when is_integer(step) do
    @steps[step]
    session_message(@steps[step].name)
    send_doc(@steps[step].name, @steps[step].doc)

    for page <- @steps[step].sub_pages do
      :timer.sleep(page.timer)
      send_doc(page.name, page.doc)
    end

    case @steps[step + 1] do
      nil ->
        {:noreply, %{state|current_step: step, next_step: :done}}
      _ ->
        {:noreply, %{state|current_step: step, next_step: step + 1}}
    end
  end

  def handle_info(:done, %{paused: false} = state) do
    session_message("That's all I got so you are on your own now")

    {:noreply, %{state|current_step: :done}}
  end

  def handle_info({:DOWN, _ref, :process, _process, _reason}, state) do

    GenServer.cast(self(), :pause)

    watch_node()

    {:noreply, state}
  end

  def handle_info(_any, %{paused: true} = state),
    do: {:noreply, state}

  def handle_info(_any, %{paused: false} = state) do
    session_message("I have no idea what to do with this")
    {:noreply, state}
  end

  def handle_cast(:pause, state),
    do: {:noreply, %{state|paused: true}}

  def handle_cast(:start, state) do
    Process.send_after(self(), state.next_step, 100)
    {:noreply, %{state|paused: false}}
  end

  def handle_cast(:restart, state) do
    :timer.sleep(2000)
    session_message("Ok, are we ready to do this?")

    Process.send_after(self(), state.current_step, 4000)

    {:noreply, %{state|paused: false}}
  end

  def handle_cast(:current_step, state) do
    session_message("The current step is #{state.current_step}")

    {:noreply, state}
  end

  def handle_cast({:start_calculation, length, _code}, state) when length >= 1000000 do
    session_message("Now you are pushing it. If you want to continue better increase my timeout. But really? Is that necessary to prove a point?")

    {:noreply, state}
  end

  def handle_cast({:start_calculation, length, code}, state) do
    {:ok, pid} = Background.Calculator.Supervisor.start_calculator(code)

    heading = "Fibonacci Results for #{length}"

    time = timed_task do
      results = Background.Calculator.calculate(pid, length)
    end

    session_example(heading, "#{inspect results}")
    session_message(time)

    {:noreply, state}
  end

  defp session_message(message),
    do: Message.deliver(@session, message)

  defp session_example(heading, message),
    do: Message.deliver(@session, heading, message)

  defp send_doc(heading, module) do
    case Code.ensure_loaded(module) do
      {:module, _} ->
        {_, binary} = Code.get_docs(module, :moduledoc)
        session_example(heading, binary)
      {:error, reason} ->
        session_example(heading, "#{inspect reason}")
    end
  end

  defp watch_node do
    case Node.ping(@node) do
      :pong ->
        Process.monitor({Session.MailBox, @node})
        session_message("Testing, Testing, is this thing on?")
        :timer.sleep(1000)

        GenServer.cast(self(), :restart)
      :pang ->
        :timer.sleep(5000)
        watch_node()
    end
  end
end
