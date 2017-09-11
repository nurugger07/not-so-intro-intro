defmodule BasicTypes do
  @moduledoc """

  Yes! Elixir has basic types but doesn't every language?

  ## Examples

      iex> 1          # integer
      iex> 0x1F       # integer
      iex> 1.0        # float
      iex> true       # boolean
      iex> :atom      # atom
      iex> "elixir"   # string
      iex> [1, 2, 3]  # list
      iex> {1, 2, 3}  # tuple

  But there are some things to note...

  * Everything has it's place...

      `number < atom < reference < function < port < pid < tuple < map < list < bitstring`

  """
end

defmodule BasicTypes.Atoms do
  @moduledoc """

  * Atoms are not garbage collected. 	By default, the maximum number of atoms
  is 1,048,576. Be very careful dynamically creating atoms.

  ## Examples

      iex> :atom
      :atom
      iex> String.to_existing_atom("atom")
      :atom
      iex> String.to_existing_atom("blah")
      ** (ArgumentError) argument error
        :erlang.binary_to_existing_atom("blah", :utf8)

  """
end


defmodule BasicTypes.Lists do
  @moduledoc """

  * Lists are stored in memory as linked lists, meaning that each element in a list holds its value and points to the following element until the end of the list is reached. We call each pair of value and pointer a cons cell:

  ## Examples

      iex> list = [1 | [2 | [3 | []]]]
      [1, 2, 3]
      iex> [first | rest] = list
      [1, 2, 3]
      iex> first
      1

  """
end
