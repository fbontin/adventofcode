defmodule Day7 do
  def read_input(), do: File.read!("data/07.txt") |> String.trim()
  def parse_row(row), do: String.split(row, ~r":? ") |> Enum.map(&String.to_integer/1)
  def parse_input(input), do: input |> String.split("\n") |> Enum.map(&parse_row/1)

  def is_possibly_true([result | values]) do
    case values do
      [value] ->
        result == value

      [first, second | rest] ->
        [first * second, first + second] |> Enum.any?(&is_possibly_true([result, &1 | rest]))
    end
  end

  def part1() do
    read_input()
    |> parse_input()
    |> Enum.filter(&is_possibly_true/1)
    |> Enum.map(&List.first/1)
    |> Enum.sum()
  end

  def concatenate(v1, v2) do
    (Integer.to_string(v1) <> Integer.to_string(v2)) |> String.to_integer()
  end

  def is_possibly_true2([result | values]) do
    case values do
      [value] ->
        result == value

      [first, second | rest] ->
        [first * second, first + second, concatenate(first, second)]
        |> Enum.any?(&is_possibly_true2([result, &1 | rest]))
    end
  end

  def part2() do
    read_input()
    |> parse_input()
    |> Enum.filter(&is_possibly_true2/1)
    |> Enum.map(&List.first/1)
    |> Enum.sum()
  end
end
