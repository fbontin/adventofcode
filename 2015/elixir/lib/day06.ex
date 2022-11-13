defmodule Day6 do
  def read_input() do
    File.read!('data/06.txt') |> String.split("\n")
  end

  def parse_point({x, y}) do
    {String.to_integer(x), String.to_integer(y)}
  end

  def parse_row(str) do
    ~r/(on|off|toggle)\s(\d+),(\d+)\D+(\d+),(\d+)/
    |> Regex.scan(str)
    |> Enum.map(fn [_, i, x1, y1, x2, y2] -> [i, {x1, y1}, {x2, y2}] end)
    |> Enum.map(fn [i, p1, p2] -> [i, parse_point(p1), parse_point(p2)] end)
  end

  def get_points({x1, y1}, {x2, y2}) do
    for x <- x1..x2, y <- y1..y2, do: {x, y}
  end

  def toggle_light(on?) do
    case on? do
      1 -> 0
      0 -> 1
    end
  end

  def run(["on", p1, p2], lights) do
    get_points(p1, p2) |> Enum.into(lights, fn p -> {p, 1} end)
  end

  def run(["off", p1, p2], lights) do
    get_points(p1, p2) |> Enum.into(lights, fn p -> {p, 0} end)
  end

  def run(["toggle", p1, p2], lights) do
    get_points(p1, p2)
    |> Enum.into(%{}, fn p -> {p, 1} end)
    |> Map.merge(lights, fn _k, _l1, l2 -> toggle_light(l2) end)
  end

  def part1() do
    read_input()
    |> Enum.map(&parse_row/1)
    |> Enum.map(&List.flatten/1)
    |> Enum.filter(&(!Enum.empty?(&1)))
    |> Enum.reduce(%{}, &run/2)
    |> Map.values()
    |> Enum.sum()
  end

  def get_change_from_instr(instr) do
    case instr do
      "on" -> 1
      "off" -> -1
      "toggle" -> 2
    end
  end

  def run2([instr, p1, p2], lights) do
    change = get_change_from_instr(instr)

    get_points(p1, p2)
    |> Enum.into(%{}, fn p -> {p, change} end)
    |> Map.merge(lights, fn _k, l1, l2 -> l1 + l2 end)
    |> Map.new(fn {k, v} -> {k, max(v, 0)} end)
  end

  def part2() do
    read_input()
    |> Enum.map(&parse_row/1)
    |> Enum.map(&List.flatten/1)
    |> Enum.filter(&(!Enum.empty?(&1)))
    |> Enum.reduce(%{}, &run2/2)
    |> Map.values()
    |> Enum.sum()
  end
end
