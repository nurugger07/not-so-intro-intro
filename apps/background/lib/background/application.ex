defmodule Background.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Background.Messenger, []),
      supervisor(Background.Calculator.Supervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Background.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
