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
