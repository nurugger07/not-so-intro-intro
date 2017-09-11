defmodule Session.MailBox do
  use GenServer

  def start_link,
    do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def handle_info({:message, message}, state) do
    System.cmd("say", [message])
    {:noreply, state}
  end

  def handle_info({:example, "", markdown}, state) do
    IO.ANSI.Docs.print markdown
    {:noreply, state}
  end

  def handle_info({:example, heading, markdown}, state) do
    IEx.Helpers.clear
    IO.ANSI.Docs.print_heading heading
    IO.ANSI.Docs.print markdown
    {:noreply, state}
  end

  def handle_info(message, state) do
    IO.inspect "Unknown message: #{inspect message}"
    {:noreply, state}
  end

end
