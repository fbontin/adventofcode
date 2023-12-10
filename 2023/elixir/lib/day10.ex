defmodule Day10 do
  def read_input() do
    File.read!(~c"data/10.txt") |> String.split("\n")
  end

  def parse_row({row, y}) do
    row |> String.graphemes() |> Enum.with_index() |> Enum.map(fn {c, x} -> {{x, y}, c} end)
  end

  def parse_input(rows) do
    rows |> Enum.with_index() |> Enum.flat_map(&parse_row/1) |> Map.new()
  end

  def is_path_tile(p, tile_map) do
    tile = tile_map |> Map.get(p)
    if tile != "." && tile != nil, do: p
  end

  def get_neighbors("|", {x, y}), do: [{x, y - 1}, {x, y + 1}]
  def get_neighbors("-", {x, y}), do: [{x - 1, y}, {x + 1, y}]
  def get_neighbors("F", {x, y}), do: [{x + 1, y}, {x, y + 1}]
  def get_neighbors("7", {x, y}), do: [{x - 1, y}, {x, y + 1}]
  def get_neighbors("J", {x, y}), do: [{x - 1, y}, {x, y - 1}]
  def get_neighbors("L", {x, y}), do: [{x + 1, y}, {x, y - 1}]
  def get_neighbors("S", p), do: get_neighbors("|", p) ++ get_neighbors("-", p)

  def get_starting_positions(tile_map) do
    start = tile_map |> Map.to_list() |> Enum.find_value(fn {k, v} -> if v == "S", do: k end)
    tiles_nearby_start = get_neighbors("S", start)

    nearby = tiles_nearby_start |> Enum.find_value(&is_path_tile(&1, tile_map))
    {start, nearby}
  end

  def find_loop_length(curr, prev, tile_map) do
    tile = tile_map |> Map.get(curr)

    if tile == "S" do
      1
    else
      next = get_neighbors(tile, curr) |> Enum.find(fn p -> p != prev end)
      1 + find_loop_length(next, curr, tile_map)
    end
  end

  def part1() do
    tile_map = read_input() |> parse_input()
    {start, nearby} = get_starting_positions(tile_map)
    find_loop_length(nearby, start, tile_map) / 2
  end
end
