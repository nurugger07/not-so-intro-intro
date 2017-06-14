defmodule Background.Messenger do
  use GenServer

  alias Background.Message

  @node Application.get_env(:background, :session_node)
  @session {Session.MailBox, @node}

  def start_link,
    do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_args) do
    send(self(), :starting_presentation)
    {:ok, %{current_step: :intro, next_step: :first_example, paused: true}}
  end

  def handle_info(:starting_presentation, state) do
    watch_node()
    {:noreply, state}
  end

  def handle_info(:intro, %{paused: false} = state) do
    case Code.ensure_loaded(Intro) do
      {:module, _} ->
        {_, binary} = Code.get_docs(Intro, :moduledoc)
        session_example("What is Elixir?", binary)
      {:error, reason} ->
        session_example("What is Elixir?", "#{inspect reason}")
    end

    Process.send_after(self(), :first_example, 5000)
    {:noreply, state}
  end

  def handle_info(:first_example, %{paused: false} = state) do
    session_message("First Example: Immutable Values")

    Process.send_after(self(), :second_example, 5000)
    {:noreply, %{state|current_step: :first_example, next_step: :second_example}}
  end

  def handle_info(:second_example, %{paused: false} = state) do
    session_message("Second Example: Named & Anonymous Functions")

    Process.send_after(self(), :third_example, 5000)

    {:noreply, %{state|current_step: :second_example, next_step: :third_example}}
  end

  def handle_info(:third_example, %{paused: false} = state) do
    session_message("Third Example: Grouping Code in Modules")

    Process.send_after(self(), :forth_example, 5000)

    {:noreply, %{state|current_step: :third_example, next_step: :fourth_example}}
  end

  def handle_info(:forth_example, %{paused: false} = state) do
    session_message("Forth Example: Graduating to Processes")

    Process.send_after(self(), :fifth_example, 5000)

    {:noreply, %{state|current_step: :forth_example, next_step: :fifth_example}}
  end

  def handle_info(:fifth_example, %{paused: false} = state) do
    session_message("Fifth Example: Message Passing & State")

    Process.send_after(self(), :sixth_example, 5000)

    {:noreply, %{state|current_step: :fifth_example, next_step: :sixth_example}}
  end

  def handle_info(:sixth_example, %{paused: false} = state) do
    session_message("Sixth Example: Hot Swapping Code")

    Process.send_after(self(), :seventh_example, 5000)

    {:noreply, %{state|current_step: :sixth_example, next_step: :seventh_example}}
  end

  def handle_info(:seventh_example, %{paused: false} = state) do
    session_message("Seventh Example: Code Loading on a remote node")

    Process.send_after(self(), :done, 5000)

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
    results = Background.Calculator.calculate(pid, length)

    session_example(heading, "#{inspect results}")

    {:noreply, state}
  end

  defp session_message(message),
    do: Message.deliver(@session, message)

  defp session_example(heading, message),
    do: Message.deliver(@session, heading, message)

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
