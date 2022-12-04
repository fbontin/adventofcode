defmodule Day04 do
  def read_input() do
    File.read!('data/04.txt') |> String.trim() |> String.split("\n")
  end

  def parse_row(row) do
    [[_ | numbers]] = Regex.scan(~r/(\d+)-(\d+),(\d+)-(\d+)/, row)
    numbers |> Enum.map(&String.to_integer/1)
  end

  def contains?([a1, a2, b1, b2]) do
    a = MapSet.new(a1..a2)
    b = MapSet.new(b1..b2)
    MapSet.subset?(a, b) || MapSet.subset?(b, a)
  end

  def part1() do
    read_input() |> Enum.map(&parse_row/1) |> Enum.filter(&contains?/1) |> length()
  end

  def overlaps?([a1, a2, b1, b2]) do
    !MapSet.disjoint?(MapSet.new(a1..a2), MapSet.new(b1..b2))
  end

  def part2() do
    read_input() |> Enum.map(&parse_row/1) |> Enum.filter(&overlaps?/1) |> length()
  end
end
