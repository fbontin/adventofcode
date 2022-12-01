defmodule Day01 do
  def read_input() do
    File.read!('data/01.txt')
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
  end

  def sum_elf(l), do: l |> Enum.map(&String.to_integer/1) |> Enum.sum()

  def part1() do
    read_input() |> Enum.map(&sum_elf/1) |> Enum.max()
  end

  def part2() do
    read_input() |> Enum.map(&sum_elf/1) |> Enum.sort(:desc) |> Enum.take(3) |> Enum.sum()
  end
end
