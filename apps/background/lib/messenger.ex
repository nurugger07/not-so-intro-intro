defmodule Background.Messenger do
  use GenServer

  import Utility

  alias Background.Message

  @event_name "Denver Erlang & Elixir"
  @node Application.get_env(:background, :session_node)
  @session {Session.MailBox, @node}

  def start_link,
    do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_args) do
    send(self(), :starting_presentation)
    {:ok, %{current_step: :intro, next_step: :what_is_elixir, paused: false}}
  end

  def handle_info(:starting_presentation, state) do
    watch_node()
    {:noreply, state}
  end

  def handle_info(:intro, %{paused: false} = state) do
    send_doc(@event_name, Intro)
    :timer.sleep 5000
    send_doc("", Employment)

    {:noreply, %{state|current_step: :intro, next_step: :what_is_elixir}}
  end

  def handle_info(:what_is_elixir, %{paused: false} = state) do
    send_doc("What is Elixir?", WhatElixir)

    {:noreply, %{state|current_step: :what_is_elixir, next_step: :first_example}}
  end

  def handle_info(:first_example, %{paused: false} = state) do
    session_message("Basic Types & curiosities")

    send_doc("Basic Types", BasicTypes)
    :timer.sleep(20000)
    send_doc("", BasicTypes.Atoms)
    :timer.sleep(20000)
    send_doc("", BasicTypes.Lists)

    {:noreply, %{state|current_step: :first_example, next_step: :second_example}}
  end

  def handle_info(:second_example, %{paused: false} = state) do
    session_message("Anonymous Functions")

    send_doc("Anonymous Functions", FunctionTypes)

    {:noreply, %{state|current_step: :second_example, next_step: :third_example}}
  end

  def handle_info(:third_example, %{paused: false} = state) do
    session_message("Grouping Code in Modules")

    send_doc("Grouping Code in Modules", Modules)

    {:noreply, %{state|current_step: :third_example, next_step: :fourth_example, paused: false}}
  end

  def handle_info(:fourth_example, %{paused: false} = state) do
    session_message("Graduating to Processes")

    send_doc("Graduating to Processes", Processes.GenServers)
    :timer.sleep 30000
    send_doc("GenServer Callbacks", Processes.GenServers.Callbacks)
    :timer.sleep 20000
    send_doc("Supervisors", Processes.Supervisors)

    {:noreply, %{state|current_step: :fourth_example, next_step: :fifth_example}}
  end

  def handle_info(:fifth_example, %{paused: false} = state) do
    session_message("Message Passing & State")

    send_doc("Message Passing & State", ProcessState)
    :timer.sleep 30000
    send_doc("Message Passing & State", MessagePassing)

    {:noreply, %{state|current_step: :fifth_example, next_step: :sixth_example}}
  end

  def handle_info(:sixth_example, %{paused: false} = state) do
    session_message("Hot Swapping Code")

    send_doc("Hot Swapping Code", HotSwap)

    {:noreply, %{state|current_step: :sixth_example, next_step: :seventh_example}}
  end

  def handle_info(:seventh_example, %{paused: false} = state) do
    session_message("Code Loading on a remote node")

    send_doc("Code Loading @ Runtime", CodeLoading)

    {:noreply, %{state|current_step: :seventh_example, next_step: :done}}
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
