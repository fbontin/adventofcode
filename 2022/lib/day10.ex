defmodule Day10 do
  def read_input() do
    File.read!('data/10.txt') |> String.trim() |> String.split("\n")
  end

  def parse_row("noop"), do: [:noop]
  def parse_row("addx " <> v), do: [:noop, {:addx, String.to_integer(v)}]

  def save_result(x, t, result) when t in [20, 60, 100, 140, 180, 220], do: [x * t | result]
  def save_result(_, _, result), do: result

  def run(:noop, {x, t, result}), do: {x, t + 1, save_result(x, t + 1, result)}
  def run({:addx, a}, {x, t, result}), do: {x + a, t + 1, save_result(x, t + 1, result)}

  def part1() do
    read_input()
    |> Enum.flat_map(&parse_row/1)
    |> Enum.reduce({1, 0, []}, &run/2)
    |> elem(2)
    |> Enum.sum()
  end

  def paint(x, t) when t in [x - 1, x, x + 1], do: "#"
  def paint(_, _), do: "."

  def draw(instr, {x, t, screen}) do
    new_screen = [paint(x, t) | screen]
    new_t = rem(t + 1, 40)

    case instr do
      :noop -> {x, new_t, new_screen}
      {:addx, a} -> {x + a, new_t, new_screen}
    end
  end

  def part2() do
    read_input()
    |> Enum.flat_map(&parse_row/1)
    |> Enum.reduce({1, 0, []}, &draw/2)
    |> elem(2)
    |> Enum.reverse()
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.join/1)
  end
end
