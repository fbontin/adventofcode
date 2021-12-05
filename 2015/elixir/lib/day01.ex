defmodule Day1 do
  def read_input() do
    File.read!('data/01.txt') |> String.split("")
  end

  def move("(", sum), do: sum + 1
  def move(")", sum), do: sum - 1

  def part1() do
    read_input()
    |> Enum.filter(fn c -> c == "(" || c == ")" end)
    |> Enum.reduce(0, &move/2)
  end

  def move2(_, -1), do: 0
  def move2([c | cs], sum), do: 1 + move2(cs, move(c, sum))

  def part2() do
    input = read_input() |> Enum.filter(fn c -> c == "(" || c == ")" end)
    move2(input, 0)
  end
end
