defmodule Day05 do
  def read_input(), do: File.read!('data/05.txt')

  def parse_crate_row(str), do: str |> String.graphemes() |> Enum.drop(1) |> Enum.take_every(4)

  def parse_crates(str) do
    str
    |> String.split("\n")
    |> Enum.map(&parse_crate_row/1)
    |> Enum.reverse()
    |> Enum.drop(1)
    |> Enum.flat_map(&Enum.with_index(&1, 1))
    |> Enum.filter(fn {c, _n} -> c != " " end)
    |> Enum.group_by(fn {_c, n} -> n end)
    |> Enum.map(fn {k, l} -> {k, Enum.map(l, fn {c, _n} -> c end) |> Enum.reverse()} end)
    |> Enum.into(%{})
  end

  def parse_instruction_row(str) do
    str
    |> String.split(" ")
    |> Enum.drop(1)
    |> Enum.take_every(2)
    |> Enum.map(&String.to_integer/1)
  end

  def parse_instructions(input) do
    input |> String.trim() |> String.split("\n") |> Enum.map(&parse_instruction_row/1)
  end

  def parse_input(input) do
    [crates, instructions] = String.split(input, "\n\n")
    {parse_crates(crates), parse_instructions(instructions)}
  end

  def run([amount, from, to], crates) do
    {moving, new_from} = Map.get(crates, from) |> Enum.split(amount)

    crates
    |> Map.update!(from, fn _ -> new_from end)
    |> Map.update!(to, fn c -> Enum.reverse(moving) ++ c end)
  end

  def part1() do
    {crates, instructions} = read_input() |> parse_input()

    Enum.reduce(instructions, crates, &run/2)
    |> Enum.map(fn {_k, v} -> List.first(v) end)
    |> Enum.join("")
  end

  def run2([amount, from, to], crates) do
    {moving, new_from} = Map.get(crates, from) |> Enum.split(amount)

    crates
    |> Map.update!(from, fn _ -> new_from end)
    |> Map.update!(to, fn c -> moving ++ c end)
  end

  def part2() do
    {crates, instructions} = read_input() |> parse_input()

    Enum.reduce(instructions, crates, &run2/2)
    |> Enum.map(fn {_k, v} -> List.first(v) end)
    |> Enum.join("")
  end
end
