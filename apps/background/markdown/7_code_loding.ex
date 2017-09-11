defmodule CodeLoading do
  @moduledoc """

  We can use the Erlang code library to get the modules code and read it into binary format. Then the code can be sent to another process/node and recompiled into memory. The code will live compiled in memory until the application stops

  ## Example - Convert module to binary

      iex> {mod, binary, file} = :code.get_object_code(__MODULE__)
      iex> {:module, mod} =  :code.load_binary(mod, file, binary)

  """

end
