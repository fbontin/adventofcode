defmodule Day7 do
  def read_input(), do: File.read!("data/07.txt") |> String.trim()
  def parse_row(row), do: String.split(row, ~r":? ") |> Enum.map(&String.to_integer/1)
  def parse_input(input), do: input |> String.split("\n") |> Enum.map(&parse_row/1)

  def is_possibly_true([result | values], ops) do
    case values do
      [value] ->
        result == value

      [first, second | rest] ->
        ops
        |> Enum.map(&apply(&1, [first, second]))
        |> Enum.any?(&is_possibly_true([result, &1 | rest], ops))
    end
  end

  def concatenate(v1, v2) do
    (Integer.to_string(v1) <> Integer.to_string(v2)) |> String.to_integer()
  end

  def sum_possibly_true_results(ops) do
    read_input()
    |> parse_input()
    |> Enum.filter(&is_possibly_true(&1, ops))
    |> Enum.map(&List.first/1)
    |> Enum.sum()
  end

  def part1(), do: sum_possibly_true_results([&Kernel.+/2, &Kernel.*/2])
  def part2(), do: sum_possibly_true_results([&Kernel.+/2, &Kernel.*/2, &concatenate/2])
end
