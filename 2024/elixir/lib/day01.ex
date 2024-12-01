defmodule Day1 do
  def read_input() do
    File.read!(~c"data/01.txt") |> String.trim() |> String.split("\n")
  end

  def split(line) do
    line
    |> String.split("   ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def parse_to_lists(input) do
    input |> Enum.map(&split/1) |> Enum.unzip()
  end

  def calc_distances({l1, l2}) do
    l1_sorted = Enum.sort(l1)
    l2_sorted = Enum.sort(l2)

    Enum.zip(l1_sorted, l2_sorted)
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part1() do
    read_input() |> parse_to_lists() |> calc_distances()
  end

  def calc_score({l1, l2}) do
    l1 |> Enum.map(fn n -> Enum.count(l2, &(&1 == n)) * n end) |> Enum.sum()
  end

  def part2() do
    read_input() |> parse_to_lists() |> calc_score()
  end
end
