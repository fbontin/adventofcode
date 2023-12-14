defmodule Day14 do
  def read_input() do
    File.read!(~c"data/14.txt") |> String.trim() |> String.split("\n", trim: true)
  end

  def split_list(l, c), do: Enum.join(l, "") |> String.split(c) |> Enum.map(&String.graphemes/1)
  def join_list(l, c), do: l |> Enum.map(&Enum.join(&1, "")) |> Enum.join(c) |> String.graphemes()

  # north turns into left 
  def get_pivoted_columns() do
    read_input() |> Enum.map(&String.graphemes/1) |> List.zip() |> Enum.map(&Tuple.to_list/1)
  end

  def lean_north(column) do
    column |> split_list("#") |> Enum.map(&Enum.sort(&1, :desc)) |> join_list("#")
  end

  def count_weight(column) do
    column
    |> Enum.zip(length(column)..1)
    |> Enum.filter(fn {c, _} -> c == "O" end)
    |> Enum.map(fn {_, w} -> w end)
    |> Enum.sum()
  end

  def part1() do
    get_pivoted_columns() |> Enum.map(&lean_north/1) |> Enum.map(&count_weight/1) |> Enum.sum()
  end
end
