defmodule Day9 do
  def read_input() do
    File.read!('data/09.txt')
    |> String.split("\n", trim: true)
    |> Enum.map(fn s -> String.split(s, "", trim: true) end)
  end

  def row_to_pos_map({row, y}) do
    row
    |> Enum.map(fn {v, x} -> {String.to_integer(v), {x, y}} end)
    |> Enum.reduce(%{}, fn {v, xy}, map -> Map.put(map, xy, v) end)
  end

  def create_pos_map(rows) do
    rows
    |> Enum.map(fn row -> Enum.with_index(row) end)
    |> Enum.with_index()
    |> Enum.map(&row_to_pos_map/1)
    |> Enum.reduce(%{}, fn row, map -> Map.merge(row, map) end)
  end

  def low_point?({x, y}, pos_map) do
    curr = pos_map[{x, y}]

    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.map(fn pos -> pos_map[pos] end)
    |> Enum.all?(fn v -> curr < v end)
  end

  def find_low_points(pos_map) do
    pos_map
    |> Map.keys()
    |> Enum.map(fn xy -> {xy, low_point?(xy, pos_map)} end)
    |> Enum.filter(fn {_, low} -> low end)
  end

  def part1() do
    parsed = read_input()
    pos_map = create_pos_map(parsed)

    pos_map
    |> find_low_points()
    |> Enum.map(fn {xy, _} -> pos_map[xy] + 1 end)
    |> Enum.sum()
  end

  def valid_adj(new_xy, xy) do
    new_xy != nil and new_xy > xy and new_xy < 9
  end

  def adjs({x, y}, basin, pos_map) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.filter(fn xy -> not MapSet.member?(basin, xy) end)
    |> Enum.filter(fn xy -> valid_adj(pos_map[xy], pos_map[{x, y}]) end)
  end

  def find_basin({x, y}, pos_map, basin) do
    adjacents = adjs({x, y}, basin, pos_map)
    new_basin = MapSet.union(basin, MapSet.new(adjacents))

    adjacents
    |> Enum.map(fn xy -> find_basin(xy, pos_map, new_basin) end)
    |> Enum.reduce(new_basin, fn acc, v -> MapSet.union(acc, v) end)
  end

  def find_basin(xy, pos_map) do
    find_basin(xy, pos_map, MapSet.new([xy]))
  end

  def part2() do
    parsed = read_input()
    pos_map = create_pos_map(parsed)

    find_low_points(pos_map)
    |> Enum.map(fn {xy, _} -> find_basin(xy, pos_map) end)
    |> Enum.map(fn basin -> MapSet.size(basin) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end
end
