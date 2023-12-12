defmodule Day11 do
  def read_input() do
    File.read!(~c"data/11.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def is_empty_row(r), do: Enum.all?(r, &(&1 == "."))

  def expand_empty_rows(rows) do
    rows |> Enum.flat_map(fn r -> if is_empty_row(r), do: [r, r], else: [r] end)
  end

  def pivot(rows), do: rows |> List.zip() |> Enum.map(&Tuple.to_list/1)

  def expand_empty_columns(rows), do: rows |> pivot() |> expand_empty_rows() |> pivot()

  def find_galaxies(rows) do
    rows
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row |> Enum.with_index() |> Enum.map(fn {c, x} -> {x, y, c} end)
    end)
    |> Enum.filter(fn {_, _, c} -> c == "#" end)
    |> Enum.map(fn {x, y, _} -> {x, y} end)
  end

  def add_pair_if_not_in({p1, p2}, set) do
    if Enum.any?(set, fn {q1, q2} -> p1 == q2 && p2 == q1 end),
      do: set,
      else: MapSet.put(set, {p1, p2})
  end

  def create_pairs(galaxies) do
    pairs = for g1 <- galaxies, g2 <- galaxies, g1 != g2, do: [g1, g2]
    pairs |> Enum.map(fn p -> Enum.sort(p) end) |> MapSet.new()
  end

  def get_distance([{x1, y1}, {x2, y2}]), do: abs(x1 - x2) + abs(y1 - y2)

  def part1() do
    read_input()
    |> expand_empty_rows()
    |> expand_empty_columns()
    |> find_galaxies()
    |> create_pairs()
    |> Enum.map(&get_distance/1)
    |> Enum.sum()
  end

  def find_empty_rows(rows) do
    rows
    |> Enum.with_index()
    |> Enum.filter(fn {r, _} -> is_empty_row(r) end)
    |> Enum.map(fn {_, x} -> x end)
  end

  @multiplier 1_000_000
  def get_distance_for(x1, x2, empty_rows) do
    nbr_empty_rows =
      x1..x2
      |> Enum.filter(fn n -> Enum.any?(empty_rows, &(&1 == n)) end)
      |> Enum.count()

    abs(x1 - x2) + nbr_empty_rows * (@multiplier - 1)
  end

  def get_expanded_distance([{x1, y1}, {x2, y2}], empty_rows, empty_cols) do
    get_distance_for(x1, x2, empty_rows) + get_distance_for(y1, y2, empty_cols)
  end

  def part2() do
    rows = read_input()
    empty_cols = rows |> find_empty_rows()
    empty_rows = rows |> pivot() |> find_empty_rows()

    rows
    |> find_galaxies()
    |> create_pairs()
    |> Enum.map(&get_expanded_distance(&1, empty_rows, empty_cols))
    |> Enum.sum()
  end
end
