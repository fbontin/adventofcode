defmodule Day6 do
  def read_input() do
    File.read!("data/06.txt") |> String.trim()
  end

  def to_map(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {list, y} -> Enum.map(list, fn {char, x} -> {{x, y}, char} end) end)
    |> Map.new()
  end

  def find_start(map) do
    map |> Map.to_list() |> Enum.find(fn {_, v} -> v != "#" and v != "." end)
  end

  def next({x, y}, "^"), do: {x, y - 1}
  def next({x, y}, "v"), do: {x, y + 1}
  def next({x, y}, "<"), do: {x - 1, y}
  def next({x, y}, ">"), do: {x + 1, y}

  def turn("^"), do: ">"
  def turn("v"), do: "<"
  def turn("<"), do: "^"
  def turn(">"), do: "v"

  def walk(old_map, {pos, dir}) do
    map = Map.put(old_map, pos, "X")

    case Map.get(map, next(pos, dir)) do
      "#" -> walk(map, {pos, turn(dir)})
      nil -> map
      _ -> walk(map, {next(pos, dir), dir})
    end
  end

  def part1() do
    map = read_input() |> to_map()

    walk(map, find_start(map)) |> Map.values() |> Enum.count(fn char -> char == "X" end)
  end

  def walk2(map, {pos, dir}, old_set) do
    if MapSet.member?(old_set, {pos, dir}) do
      true
    else
      set = MapSet.put(old_set, {pos, dir})

      case Map.get(map, next(pos, dir)) do
        "#" -> walk2(map, {pos, turn(dir)}, set)
        nil -> false
        _ -> walk2(map, {next(pos, dir), dir}, set)
      end
    end
  end

  def makes_loop(pos, map, start, set) do
    Map.put(map, pos, "#") |> walk2(start, set)
  end

  def part2() do
    map = read_input() |> to_map()
    start = find_start(map)

    walk(map, start)
    |> Map.to_list()
    |> Enum.filter(fn {_, v} -> v == "X" end)
    |> Enum.count(fn {pos, _} -> makes_loop(pos, map, start, MapSet.new()) end)
  end
end
