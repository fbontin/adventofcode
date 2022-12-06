defmodule Day06 do
  def read_input(), do: File.read!('data/06.txt')

  def n_uniq?(n, chars), do: chars |> Enum.uniq() |> Enum.count() |> (fn c -> c == n end).()

  def find_marker(n) do
    read_input()
    |> String.graphemes()
    |> Enum.chunk_every(n, 1)
    |> Enum.with_index(n)
    |> Enum.find(fn {chars, _i} -> n_uniq?(n, chars) end)
  end

  def part1(), do: find_marker(4)
  def part2(), do: find_marker(14)
end
