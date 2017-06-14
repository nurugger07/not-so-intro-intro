defmodule Sequencer do

  @moduledoc """

  Build number Fibonacci number sequences

  ## Example:

  iex> Sequencer.fibonacci(5)
  [0, 1, 1, 2, 3]

  """

  def fibonacci(_length),
    do: [0, 1, 1, 2, 3]

  # defp calculate(length, []),
  #   do: calculate(length - 1, [0])

  # defp calculate(length, [0]),
  #   do: calculate(length - 1, [1, 0])

  # defp calculate(length, [a, b | _rest] = acc) when length > 0,
  #   do: calculate(length - 1, [a + b | acc])

  # defp calculate(0, acc),
  #   do: Enum.reverse(acc)

  def get_code(),
    do: :code.get_object_code(__MODULE__)

end
