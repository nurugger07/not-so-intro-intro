defmodule Modules do
  @moduledoc """

  Elixir uses modules to group functions with similar functionality or purpose together. They can be defined in memory or compiled from files.

  ## Example

      iex> defmodule Math do
      ...>   def sum(a, b) do
      ...>     a + b
      ...>   end
      ...> end

      iex> Math.sum(1, 2)
      3

  * Named functions must be defined in modules using either `def/2` or `defp/2`. These are public and private respectively.

  * Functions also support guards and multiple clauses.

  ## Examples

      defmodule Math do
        def zero?(0), do: true
        def zero?(x) when is_integer(x), do: false
      end

      IO.puts Math.zero?(0)         #=> true
      IO.puts Math.zero?(1)         #=> false
      IO.puts Math.zero?([1, 2, 3]) #=> ** (FunctionClauseError)
      IO.puts Math.zero?(0.0)       #=> ** (FunctionClauseError)

  """
end
