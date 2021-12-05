defmodule Day2 do
  def read_input() do
    File.read!('data/02.txt')
    |> String.split("\n", trim: true)
  end

  def parse_input() do
    Day2.read_input()
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [op, n] -> [op, String.to_integer(n)] end)
  end

  def go(["forward", n], {h, d}), do: {h + n, d}
  def go(["up", n], {h, d}), do: {h, d - n}
  def go(["down", n], {h, d}), do: {h, d + n}

  def part1() do
    Day2.parse_input()
    |> Enum.reduce({0, 0}, &Day2.go/2)
    |> (fn {h, d} -> h * d end).()
  end

  def go2(["forward", n], {h, d, a}), do: {h + n, d + a * n, a}
  def go2(["up", n], {h, d, a}), do: {h, d, a - n}
  def go2(["down", n], {h, d, a}), do: {h, d, a + n}

  def part2() do
    Day2.parse_input()
    |> Enum.reduce({0, 0, 0}, &Day2.go2/2)
    |> (fn {h, d, _} -> h * d end).()
  end
end
