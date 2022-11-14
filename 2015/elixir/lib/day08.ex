defmodule Day8 do
  def read_input() do
    File.read!('data/08.txt') |> String.trim() |> String.split("\n")
  end

  def count_in_memory_length([]), do: 0
  def count_in_memory_length([_]), do: 1

  def count_in_memory_length(chars) do
    case Enum.take(chars, 2) do
      ["\\", "x"] -> 1 + count_in_memory_length(Enum.drop(chars, 4))
      ["\\", _] -> 1 + count_in_memory_length(Enum.drop(chars, 2))
      _ -> 1 + count_in_memory_length(Enum.drop(chars, 1))
    end
  end

  def part1() do
    input = read_input()
    n1 = input |> Enum.map(&String.length/1) |> Enum.sum()

    n2 =
      input
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&count_in_memory_length/1)
      # uncount all quotes
      |> Enum.map(&(&1 - 2))
      |> Enum.sum()

    {n1, n2, n1 - n2}
  end

  def escape([]), do: 0

  def escape(str) do
    case List.first(str) do
      "\"" -> 2 + escape(Enum.drop(str, 1))
      "\\" -> 2 + escape(Enum.drop(str, 1))
      _ -> 1 + escape(Enum.drop(str, 1))
    end
  end

  def part2() do
    input = read_input()
    prev = input |> Enum.map(&String.length/1) |> Enum.sum()

    processed =
      input
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&escape/1)
      # add all quotes
      |> Enum.map(&(&1 + 2))
      |> Enum.sum()

    {processed, prev, processed - prev}
  end
end
