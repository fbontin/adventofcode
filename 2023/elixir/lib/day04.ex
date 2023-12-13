defmodule Day4 do
  def read_input() do
    File.read!(~c"data/04.txt") |> String.trim() |> String.split("\n")
  end

  def parse_numbers(str) do
    str |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
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
    |> Enum.sum()
  end

  def parse_row_with_card_number(str) do
    [card_name | [numbers | _]] = str |> String.split(": ")

    card_number =
      card_name |> String.split(~r{\s}, trim: true) |> List.last() |> String.to_integer()

    [win_numbers | [your_numbers | _]] = numbers |> String.split("|")
    {card_number, %{n: 1, w: parse_numbers(win_numbers), y: parse_numbers(your_numbers)}}
  end

  def get_new_tickets(map, i) do
    curr = map |> Map.get(i)
    size = MapSet.intersection(MapSet.new(curr.w), MapSet.new(curr.y)) |> MapSet.size()

    if size == 0 do
      map
    else
      (i + 1)..(i + size)
      |> Enum.reduce(map, fn j, m ->
        m |> Map.update!(j, &%{w: &1.w, y: &1.y, n: &1.n + curr.n})
      end)
    end
  end

  def calc(map, i, max) when i >= max, do: map
  def calc(map, i, max), do: calc(get_new_tickets(map, i), i + 1, max)

  def part2() do
    input = read_input()

    input
    |> Enum.map(&parse_row_with_card_number/1)
    |> Map.new()
    |> calc(1, length(input))
    |> Enum.map(fn {_, v} -> v.n end)
    |> Enum.sum()
  end
end
