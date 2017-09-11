defmodule ProcessState do
  @moduledoc """

  State is managed withing the scope of a process. Only that process can directly change its state.


  ## Example

      def start_link,
        do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

      def init(_args),
        do: {:ok, %{current_step: :intro, next_step: :first_example, paused: true}}

      def handle_info(:intro, %{paused: false} = state) do
        send_doc("NDC Oslo", Intro)

        {:noreply, %{state|current_step: :intro, next_step: :what_is_elixir}}
      end

  """
end

defmodule MessagePassing do
  @moduledoc """

  There are a number of ways to send messages to processes but the following will be used most in the upcoming examples.

      1. `send/2` - sends a message to a process
      2. `Process.send_after/3` - sends a message to a process after a set time
      3. Using `call/3`, `cast/2` on GenServer

  Moving to more code!!!

  """
end
