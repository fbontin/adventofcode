defmodule Day3 do
  def read_input() do
    File.read!('data/03.txt') |> String.split("\n", trim: true)
  end

  def str_to_int_list(str) do
    String.graphemes(str) |> Enum.map(&String.to_integer/1)
  end

  def parse_input() do
    Day3.read_input() |> Enum.map(&Day3.str_to_int_list/1)
  end

  def add_binary(b1, b2) do
    Enum.zip(b1, b2) |> Enum.map(fn {x, y} -> x + y end)
  end

  def reverse_binary(binary) do
    binary
    |> String.graphemes()
    |> Enum.map(fn b -> if b == "1", do: "0", else: "1" end)
    |> Enum.join("")
  end

  def most_common_bits(numbers) do
    numbers
    |> Enum.reduce(&Day3.add_binary/2)
    |> Enum.map(fn n -> if n >= length(numbers) / 2, do: 1, else: 0 end)
    |> Enum.join("")
  end

  def part1() do
    parsed = Day3.parse_input()
    most_common = most_common_bits(parsed)

    {gamma, _} = Integer.parse(most_common, 2)
    {epsilon, _} = reverse_binary(most_common) |> Integer.parse(2)
    {gamma, epsilon, gamma * epsilon}
  end

  def calc(numbers, pos, mode) do
    bits =
      most_common_bits(numbers)
      |> (fn b -> if mode === :sc, do: reverse_binary(b), else: b end).()
      |> String.at(pos)
      |> String.to_integer()

    new_numbers = numbers |> Enum.filter(fn l -> Enum.at(l, pos) == bits end)

    if length(new_numbers) > 1 do
      calc(new_numbers, pos + 1, mode)
    else
      List.first(new_numbers)
    end
  end

  def part2() do
    parsed = Day3.parse_input()
    {ox, _} = calc(parsed, 0, :ox) |> Enum.join("") |> Integer.parse(2)
    {sc, _} = calc(parsed, 0, :sc) |> Enum.join("") |> Integer.parse(2)
    {ox, sc, ox * sc}
  end
end
