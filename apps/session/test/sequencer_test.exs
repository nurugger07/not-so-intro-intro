defmodule SequencerTest do
  use ExUnit.Case
  doctest Sequencer

  alias Sequencer, as: Seq

  test "calculate with length of 5" do
    assert [0, 1, 1, 2, 3] = Seq.fibonacci(5)
  end

  # test "calculate with length of 6" do
  #   assert [0, 1, 1, 2, 3, 5] = Seq.fibonacci(6)
  # end

  # test "calculate with length of 7" do
  #   assert [0, 1, 1, 2, 3, 5, 8] = Seq.fibonacci(7)
  # end

  # test "calculate with length of 8" do
  #   assert [0, 1, 1, 2, 3, 5, 8, 13] = Seq.fibonacci(8)
  # end

  # test "calculate with length of 9" do
  #   assert [0, 1, 1, 2, 3, 5, 8, 13, 21] = Seq.fibonacci(9)
  # end

  # test "calculate with length of 10" do
  #   assert [0, 1, 1, 2, 3, 5, 8, 13, 21, 34] = Seq.fibonacci(10)
  # end

  # test "Only even numbers from list" do
  #   assert [] == Seq.even_numbers_from_list([1, 3, 5])
  #   assert [0, 2] == Seq.even_numbers_from_list([0, 1, 1, 2])
  # end

  # test "Only odd numbers from list" do
  #   assert [] == Seq.odd_numbers_from_list([2, 4, 6])
  #   assert [1, 1] == Seq.odd_numbers_from_list([0, 1, 1, 2])
  # end
end
