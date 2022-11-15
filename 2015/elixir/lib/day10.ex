defmodule Day10 do
  def read_input() do
    File.read!('data/10.txt') |> String.trim()
  end

  def run([]), do: []

  def run(chars) do
    first = List.first(chars)
    count = chars |> Enum.take_while(fn c -> c == first end) |> length()
    tail = chars |> Enum.drop_while(fn c -> c == first end) |> run()
    [count | [first | tail]]
  end

  def run_countdown(chars, 0), do: chars
  def run_countdown(chars, n), do: chars |> run() |> run_countdown(n - 1)

  def part1() do
    read_input()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> run_countdown(40)
    |> length()
  end

  def part2() do
    read_input()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> run_countdown(50)
    |> length()
  end
end
