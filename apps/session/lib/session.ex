defmodule Session do

  alias Background.Messenger

  @node Application.get_env(:session, :background_node)
  @messenger {Messenger, @node}

  def start,
    do: GenServer.cast(@messenger, :start)

  def restart,
    do: GenServer.cast(@messenger, :restart)

  def pause,
    do: GenServer.cast(@messenger, :pause)

  def current_step,
    do: GenServer.cast(@messenger, :current_step)

  def calculate_sequence(length, count \\ 1) do
    code = Sequencer.get_code()
    Enum.map(1..count, fn(_n) ->
      Task.async(fn() ->
        GenServer.cast(@messenger, {:start_calculation, length, code})
      end)
    end)
  end

end
