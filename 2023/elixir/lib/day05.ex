defmodule Day5 do
  def read_input() do
    File.read!(~c"data/05.txt") |> String.trim() |> String.split("\n\n")
  end

  def parse_map(s) do
    s
    |> String.split("\n")
    |> Enum.drop(1)
    |> Enum.map(fn n -> String.split(n, " ") |> Enum.map(&(Integer.parse(&1) |> elem(0))) end)
  end

  def parse_input() do
    [seeds | maps] = read_input()

    {seeds |> String.split(" ") |> Enum.drop(1) |> Enum.map(&(Integer.parse(&1) |> elem(0))),
     maps |> Enum.map(&parse_map/1)}
  end

  def create_range_map(map_row),
    do: map_row |> Enum.map(fn [d, s, l] -> %{start: s, end: s + l - 1, modifier: d - s} end)

  def create_map(map_input), do: map_input |> Enum.map(&create_range_map/1)

  def find_in_map(map, seed) do
    m = map |> Enum.find(%{modifier: 0}, fn map -> seed >= map.start && seed <= map.end end)
    seed + m.modifier
  end

  def find_location(seed, maps), do: maps |> Enum.reduce(seed, &find_in_map/2)

  def part1() do
    {seeds, maps_input} = parse_input()
    maps = create_map(maps_input)
    seeds |> Enum.map(&find_location(&1, maps)) |> Enum.min()
  end
end
