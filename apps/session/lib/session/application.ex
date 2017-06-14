defmodule Session.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Session.MailBox, []),
    ]

    opts = [strategy: :one_for_one, name: Session.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def begin_presentation do
    GenServer.cast({Background.Messenger, :"background@brooke-air"}, :restart)
  end
end
