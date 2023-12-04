defmodule Day4 do
  def read_input() do
    File.read!(~c"data/04.txt") |> String.trim() |> String.split("\n")
  end

  def parse_numbers(str) do
    str |> String.split(" ", trim: true) |> Enum.map(&(&1 |> Integer.parse() |> elem(0)))
  end

  def parse_row(str) do
    [_card_name | [numbers | _]] = str |> String.split(": ")
    [win_numbers | [your_numbers | _]] = numbers |> String.split("|")
    {parse_numbers(win_numbers), parse_numbers(your_numbers)}
  end

  def get_points({win_numbers, your_numbers}) do
    win_set = MapSet.new(win_numbers)
    your_set = MapSet.new(your_numbers)

    size = MapSet.intersection(win_set, your_set) |> MapSet.size()

    if size == 0, do: 0, else: 2 ** (size - 1)
  end

  def part1() do
    read_input()
    |> Enum.map(&parse_row/1)
    |> Enum.map(&get_points/1)
    |> IO.inspect(charlists: :as_lists)
    |> Enum.sum()
  end
end
