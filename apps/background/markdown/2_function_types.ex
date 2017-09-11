defmodule FunctionTypes do
  @moduledoc """

  Functions in Elixir are identified by both their name and their arity. The arity of a function describes the number of arguments which the function takes. 

  Anonymous functions can be created inline and are delimited by the keywords `fn`
  and `end`:

      iex> add = fn a, b -> a + b end
      #Function<12.71889879/2 in :erl_eval.expr/5>
      iex> add.(1, 2)
      3
      iex> is_function(add)
      true
      iex> is_function(add, 2) # check if add is a function that expects exactly 2 arguments
      true
      iex> is_function(add, 1) # check if add is a function that expects exactly 1 argument
      false


  Functions can be passed as arguments to other functions in the same way as integers and strings. There's also a short hand syntax for anonymous functions that is commonly used 

      iex> func = &(&1 - 2)
      #Function<6.118419387/1 in :erl_eval.expr/5>
      iex> func.(4)
      2

  """
end
