defmodule Day12 do
  def read_input() do
    File.read!('data/12.json')
  end

  def part1() do
    input = read_input()
    Regex.scan(~r/-?\d+/, input) |> List.flatten() |> Enum.map(&String.to_integer/1) |> Enum.sum()
  end

  def has_red(obj) do
    (Map.keys(obj) ++ Map.values(obj)) |> Enum.any?(fn x -> x == "red" end)
  end

  def count(v) do
    cond do
      is_integer(v) -> v
      is_list(v) -> v |> Enum.map(&count/1) |> Enum.sum()
      is_bitstring(v) -> 0
      has_red(v) -> 0
      true -> Map.values(v) |> Enum.map(&count/1) |> Enum.sum()
    end
  end

  def part2() do
    read_input()
    |> Jason.decode!()
    |> Enum.map(&count/1)
    |> Enum.sum()
  end
end
