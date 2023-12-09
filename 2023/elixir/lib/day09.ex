defmodule Day9 do
  def read_input() do
    File.read!(~c"data/09.txt") |> String.trim() |> String.split("\n")
  end

  def parse_row(str) do
    str |> String.split(" ") |> Enum.map(&String.to_integer/1)
  end

  def get_differences(history) do
    history |> Enum.chunk_every(2, 1, :discard) |> Enum.map(fn [a, b] -> b - a end)
  end

  def get_extrapolation(history) do
    if Enum.sum(history) == 0,
      do: 0,
      else: List.last(history) + (history |> get_differences() |> get_extrapolation())
  end

  def part1() do
    read_input()
    |> Enum.map(&parse_row/1)
    |> Enum.map(&get_extrapolation/1)
    |> Enum.sum()
  end

  def get_extrapolation_backwards(history) do
    if Enum.sum(history) == 0,
      do: 0,
      else: List.first(history) - (history |> get_differences() |> get_extrapolation_backwards())
  end

  def part2() do
    read_input()
    |> Enum.map(&parse_row/1)
    |> Enum.map(&get_extrapolation_backwards/1)
    |> Enum.sum()
  end
end
