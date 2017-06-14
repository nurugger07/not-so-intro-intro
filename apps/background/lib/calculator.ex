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
