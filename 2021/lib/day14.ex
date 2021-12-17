defmodule Day14 do
  def read_input() do
    File.read!('data/14.txt') |> String.split("\n\n", trim: true)
  end

  def parse_input([template, rules]) do
    {template,
     rules
     |> String.split("\n", trim: true)
     |> Enum.map(fn row -> String.split(row, " -> ") end)
     |> Enum.map(fn [pair, el] -> %{pair => el} end)
     |> Enum.reduce(fn acc, map -> Map.merge(map, acc) end)}
  end

  def to_pairs(str) do
    chars = String.split(str, "", trim: true)
    Enum.zip([nil | chars], chars) |> tl()
  end

  def insert_elem({c1, c2}, rules) do
    [c1, rules[c1 <> c2], c2]
  end

  def merge([h | tail]) do
    [h | Enum.flat_map(tail, &tl/1)] |> List.flatten() |> Enum.join()
  end

  def step(str, _, 0), do: str

  def step(str, rules, n) do
    res = str |> to_pairs() |> Enum.map(&insert_elem(&1, rules)) |> merge()
    step(res, rules, n - 1)
  end

  def str_freq(str), do: String.split(str, "", trim: true) |> Enum.frequencies()

  def most_common(str) do
    str |> str_freq() |> Enum.max_by(fn {_, v} -> v end) |> elem(1)
  end

  def least_common(str) do
    str |> str_freq() |> Enum.min_by(fn {_, v} -> v end) |> elem(1)
  end

  def part1() do
    {template, rules} = read_input() |> parse_input()
    res = step(template, rules, 10)
    most = most_common(res)
    least = least_common(res)
    {most, least, most - least}
  end

  def part2() do
    read_input() |> parse_input()
  end
end
