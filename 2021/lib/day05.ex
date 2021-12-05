defmodule Day5 do
  def read_input() do
    File.read!('data/05.txt') |> String.split("\n", trim: true)
  end

  def line_to_ints([p1, p2]) do
    [x1, y1] = String.split(p1, ",") |> Enum.map(&String.to_integer/1)
    [x2, y2] = String.split(p2, ",") |> Enum.map(&String.to_integer/1)
    %{x1: x1, x2: x2, y1: y1, y2: y2}
  end

  def parse_input() do
    read_input()
    |> Enum.map(fn l -> String.split(l, " -> ") end)
    |> Enum.map(&line_to_ints/1)
  end

  def line_to_points(%{x1: x1, x2: x2, y1: y1, y2: y2}) when x1 == x2,
    do: Enum.to_list(y1..y2) |> Enum.map(fn y -> "#{x1},#{y}" end)

  def line_to_points(%{x1: x1, x2: x2, y1: y1, y2: y2}) when y1 == y2,
    do: Enum.to_list(x1..x2) |> Enum.map(fn x -> "#{x},#{y1}" end)

  def line_to_points(_), do: []

  def point_to_map(p, map) do
    if map[p], do: Map.put(map, p, map[p] + 1), else: Map.put(map, p, 1)
  end

  def find_nbr_duplicates(points) do
    points
    |> Enum.reduce(%{}, &point_to_map/2)
    |> Map.values()
    |> Enum.filter(fn n -> n > 1 end)
    |> length()
  end

  def part1() do
    points = Enum.flat_map(parse_input(), &line_to_points/1)
    find_nbr_duplicates(points)
  end

  def line_to_points2(%{x1: x1, x2: x2, y1: y1, y2: y2}) when x1 == x2,
    do: Enum.to_list(y1..y2) |> Enum.map(fn y -> "#{x1},#{y}" end)

  def line_to_points2(%{x1: x1, x2: x2, y1: y1, y2: y2}) when y1 == y2,
    do: Enum.to_list(x1..x2) |> Enum.map(fn x -> "#{x},#{y1}" end)

  def line_to_points2(%{x1: x1, x2: x2, y1: y1, y2: y2}) do
    # diagonal
    x = Enum.to_list(x1..x2)
    y = Enum.to_list(y1..y2)
    Enum.zip(x, y) |> Enum.map(fn {x, y} -> "#{x},#{y}" end)
  end

  def part2() do
    points = Enum.flat_map(parse_input(), &line_to_points2/1)
    find_nbr_duplicates(points)
  end
end
