defmodule Day8 do
  def read_input(), do: File.read!("data/08.txt") |> String.trim()

  def to_map(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {list, y} -> Enum.map(list, fn {char, x} -> {char, [{x, y}]} end) end)
    |> Enum.reduce(Map.new(), fn {char, ps}, map -> Map.update(map, char, ps, &(&1 ++ ps)) end)
  end

  def find_antennas(map), do: map |> Map.keys() |> Enum.uniq() |> Enum.reject(&(&1 == "."))

  def find_antinodes({x1, y1}, {x2, y2}), do: {x1 + x1 - x2, y1 + y1 - y2}
  def find_antinodes(ps), do: for(p1 <- ps, p2 <- ps, p1 != p2, do: find_antinodes(p1, p2))

  def part1() do
    map = read_input() |> to_map()
    positions_in_map = Map.values(map) |> List.flatten()

    find_antennas(map)
    |> Enum.flat_map(&find_antinodes(Map.get(map, &1)))
    |> Enum.uniq()
    |> Enum.filter(&Enum.member?(positions_in_map, &1))
    |> Enum.count()
  end

  def find_antinodes2({x1, y1}, {x2, y2}) do
    dx = x1 - x2
    dy = y1 - y2

    # Creating 100 steps in each direction, hoping it's enough to cover the whole map
    for n <- 0..100, do: {x1 + dx * n, y1 + dy * n}
  end

  def find_antinodes2(ps), do: for(p1 <- ps, p2 <- ps, p1 != p2, do: find_antinodes2(p1, p2))

  def part2() do
    map = read_input() |> to_map()
    positions_in_map = Map.values(map) |> List.flatten()

    find_antennas(map)
    |> Enum.flat_map(&find_antinodes2(Map.get(map, &1)))
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.filter(&Enum.member?(positions_in_map, &1))
    |> Enum.count()
  end
end
