defmodule Day9 do
  def read_input() do
    File.read!('data/09.txt') |> String.trim() |> String.split("\n")
  end

  def parse_row(str) do
    [n1, _, n2, _, d] = String.split(str, " ")
    dist = String.to_integer(d)
    %{{n1, n2} => dist, {n2, n1} => dist}
  end

  def get_nodes(distances) do
    Map.keys(distances) |> Enum.flat_map(fn {n1, n2} -> [n1, n2] end) |> Enum.uniq()
  end

  def traverse([_], _distances), do: 0

  def traverse([curr | [next | nodes]], distances) do
    next_d = Map.get(distances, {next, curr})
    next_d + traverse([next | nodes], distances)
  end

  def permutations([]), do: [[]]

  def permutations(list) do
    for h <- list, t <- permutations(list -- [h]), do: [h | t]
  end

  def part1() do
    distances =
      read_input()
      |> Enum.map(&parse_row/1)
      |> Enum.reduce(%{}, fn m1, m2 -> Enum.into(m1, m2) end)

    distances
    |> get_nodes()
    |> permutations()
    |> Enum.map(fn n -> traverse(n, distances) end)
    |> Enum.min()
  end

  def part2() do
    distances =
      read_input()
      |> Enum.map(&parse_row/1)
      |> Enum.reduce(%{}, fn m1, m2 -> Enum.into(m1, m2) end)

    distances
    |> get_nodes()
    |> permutations()
    |> Enum.map(fn n -> traverse(n, distances) end)
    |> Enum.max()
  end
end
