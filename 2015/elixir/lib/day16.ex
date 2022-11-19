defmodule Day16 do
  def read_input() do
    File.read!('data/16.txt') |> String.trim() |> String.split("\n")
  end

  def correct_sue,
    do: %{
      children: 3,
      cats: 7,
      samoyeds: 2,
      pomeranians: 3,
      akitas: 0,
      vizslas: 0,
      goldfish: 5,
      trees: 3,
      cars: 2,
      perfumes: 1
    }

  def parse_facts(str) do
    str
    |> String.split(", ")
    |> Enum.map(fn s -> String.split(s, ": ") end)
    |> Enum.reduce(%{}, fn [k, v], m2 -> Map.put(m2, String.to_atom(k), String.to_integer(v)) end)
  end

  def parse_row(str) do
    [[_, n, facts]] = Regex.scan(~r/Sue (\d+): (.+)/, str)
    {n, parse_facts(facts)}
  end

  def is_correct_sue({_n, facts}) do
    facts |> Enum.all?(fn {k, v} -> Map.get(correct_sue(), k) == v end)
  end

  def part1() do
    read_input() |> Enum.map(&parse_row/1) |> Enum.filter(&is_correct_sue/1)
  end

  def is_correct_sue2({_n, facts}) do
    {gt, gt_rest} = Map.split(facts, [:cats, :trees])
    {lt, rest} = Map.split(gt_rest, [:pomeranians, :goldfish])

    Enum.all?(gt, fn {k, v} -> Map.get(correct_sue(), k) < v end) &&
      Enum.all?(lt, fn {k, v} -> Map.get(correct_sue(), k) > v end) &&
      Enum.all?(rest, fn {k, v} -> Map.get(correct_sue(), k) == v end)
  end

  def part2() do
    read_input() |> Enum.map(&parse_row/1) |> Enum.filter(&is_correct_sue2/1)
  end
end
