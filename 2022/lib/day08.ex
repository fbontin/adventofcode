defmodule Day08 do
  def read_input() do
    File.read!('data/08.txt') |> String.trim()
  end

  def parse_input(str) do
    str
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {s, y} ->
      String.graphemes(s) |> Enum.with_index() |> Enum.map(fn {s, x} -> {s, x, y} end)
    end)
    |> Enum.reduce(%{}, fn {s, x, y}, m -> Map.put(m, {x, y}, String.to_integer(s)) end)
  end

  def is_hidden?({x, y}, trees) do
    n = trees |> Enum.filter(fn {{x_, y_}, _} -> x_ == x and y_ > y end)
    s = trees |> Enum.filter(fn {{x_, y_}, _} -> x_ == x and y_ < y end)
    w = trees |> Enum.filter(fn {{x_, y_}, _} -> y_ == y and x_ < x end)
    e = trees |> Enum.filter(fn {{x_, y_}, _} -> y_ == y and x_ > x end)
    h = trees[{x, y}]

    [n, s, w, e]
    |> Enum.map(&Enum.map(&1, fn {_p, h} -> h end))
    |> Enum.all?(&Enum.any?(&1, fn h_ -> h_ >= h end))
  end

  def is_visible?(pos, trees), do: !is_hidden?(pos, trees)

  def part1() do
    trees = read_input() |> parse_input
    Enum.count(trees, fn {pos, _} -> is_visible?(pos, trees) end)
  end

  def add_pos({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  def find_scenic_score(dir, pos, h, trees) do
    next_pos = add_pos(dir, pos)

    cond do
      trees[next_pos] == nil -> 0
      h > trees[next_pos] -> 1 + find_scenic_score(dir, next_pos, h, trees)
      true -> 1
    end
  end

  def find_scenic_score(pos, trees) do
    [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
    |> Enum.map(&find_scenic_score(&1, pos, trees[pos], trees))
    |> Enum.product()
  end

  def part2() do
    trees = read_input() |> parse_input
    trees |> Enum.map(fn {pos, _} -> find_scenic_score(pos, trees) end) |> Enum.max()
  end
end
