defmodule HotSwap do
  @moduledoc """

  Code can be changed while the system stays up.

  ## Example

      iex> :sys.suspend(Background.Messenger)
      :ok
      iex> c("lib/messenger.ex")
      warning: redefining module Background.Messenger (current version loaded from /Users/Brooke/Dropbox/src/ndc/_build/dev/lib/background/ebin/Elixir.Background.Messenger.beam)
      lib/messenger.ex:1

      [Background.Messenger]
      iex> :sys.resume(Background.Messenger)

  """
end
