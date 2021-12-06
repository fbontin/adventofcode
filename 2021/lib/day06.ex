defmodule Day6 do
  def read_input() do
    File.read!('data/06.txt')
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def list_to_map(list) do
    Enum.reduce(list, %{}, fn n, acc -> Map.update(acc, n, 1, &(&1 + 1)) end)
  end

  def tick(map) do
    %{
      0 => Map.get(map, 1, 0),
      1 => Map.get(map, 2, 0),
      2 => Map.get(map, 3, 0),
      3 => Map.get(map, 4, 0),
      4 => Map.get(map, 5, 0),
      5 => Map.get(map, 6, 0),
      6 => Map.get(map, 7, 0) + Map.get(map, 0, 0),
      7 => Map.get(map, 8, 0),
      8 => Map.get(map, 0, 0)
    }
  end

  def tick_until(map, 1), do: tick(map)
  def tick_until(map, n), do: tick_until(tick(map), n - 1)

  def solve(days) do
    read_input()
    |> list_to_map()
    |> tick_until(days)
    |> Map.values()
    |> Enum.sum()
  end

  def part1() do
    solve(80)
  end

  def part2() do
    solve(256)
  end
end
