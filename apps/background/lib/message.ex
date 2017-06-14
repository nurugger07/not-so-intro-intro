defmodule Background.Message do

  def deliver(process, message),
    do: send(process, {:message, message})

  def deliver(process, heading, message),
    do: send(process, {:example, heading, message})

end
