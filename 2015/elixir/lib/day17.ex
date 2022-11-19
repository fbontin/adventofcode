defmodule Day17 do
  def read_input() do
    File.read!('data/17.txt') |> String.trim() |> String.split("\n")
  end

  def volume, do: 150

  def comb(0, _), do: [[]]
  def comb(_, []), do: []
  def comb(m, [h | t]), do: for(l <- comb(m - 1, t), do: [h | l]) ++ comb(m, t)

  def get_combinations(containers) do
    1..length(containers) |> Enum.flat_map(&comb(&1, containers))
  end

  def part1() do
    read_input()
    |> Enum.map(&String.to_integer/1)
    |> get_combinations()
    |> Enum.filter(fn c -> Enum.sum(c) == volume() end)
    |> length()
  end

  def part2() do
    combinations =
      read_input()
      |> Enum.map(&String.to_integer/1)
      |> get_combinations()
      |> Enum.filter(fn c -> Enum.sum(c) == volume() end)

    min_containers = combinations |> Enum.map(&length/1) |> Enum.min()

    combinations |> Enum.filter(&(length(&1) == min_containers)) |> length()
  end
end
