defmodule Day10 do
  def read_input() do
    File.read!('data/10.txt') |> String.split("\n", trim: true)
  end

  def match("("), do: ")"
  def match("["), do: "]"
  def match("{"), do: "}"
  def match("<"), do: ">"
  def match(_), do: nil

  def opening?(c) do
    c == "(" or c == "[" or c == "{" or c == "<"
  end

  def find_corrupted([], _), do: nil

  def find_corrupted([h | tail], [h_stack | t_stack]) do
    cond do
      opening?(h) -> find_corrupted(tail, [h, h_stack | t_stack])
      match(h_stack) == h -> find_corrupted(tail, t_stack)
      true -> h
    end
  end

  def find_corrupted([h | tail], stack), do: find_corrupted(tail, [h | stack])
  def find_corrupted([h | tail]), do: find_corrupted(tail, [h])

  def corrupt_to_points(")"), do: 3
  def corrupt_to_points("]"), do: 57
  def corrupt_to_points("}"), do: 1197
  def corrupt_to_points(">"), do: 25137

  def part1() do
    lines = read_input()

    lines
    |> Enum.map(fn l -> String.split(l, "", trim: true) end)
    |> Enum.map(&find_corrupted/1)
    |> Enum.filter(fn c -> c != nil end)
    |> Enum.map(&corrupt_to_points/1)
    |> Enum.sum()
  end

  def complete_line([], stack), do: stack

  def complete_line([h | tail], [h_stack | t_stack]) do
    cond do
      opening?(h) -> complete_line(tail, [h, h_stack | t_stack])
      match(h_stack) == h -> complete_line(tail, t_stack)
    end
  end

  def complete_line([h | tail], stack), do: complete_line(tail, [h | stack])
  def complete_line([h | tail]), do: complete_line(tail, [h])

  def score(")"), do: 1
  def score("]"), do: 2
  def score("}"), do: 3
  def score(">"), do: 4

  def score_line(line) do
    Enum.reduce(line, 0, fn c, acc -> acc * 5 + score(c) end)
  end

  def median(scores) do
    index = scores |> length() |> div(2)

    scores |> Enum.sort() |> List.pop_at(index) |> elem(0)
  end

  def part2() do
    read_input()
    |> Enum.map(fn l -> String.split(l, "", trim: true) end)
    |> Enum.filter(fn l -> find_corrupted(l) == nil end)
    |> Enum.map(&complete_line/1)
    |> Enum.map(fn l -> Enum.map(l, &match/1) end)
    |> Enum.map(&score_line/1)
    |> median()
  end
end
