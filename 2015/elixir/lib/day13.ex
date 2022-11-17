defmodule Day13 do
  def read_input() do
    File.read!('data/13.txt') |> String.trim() |> String.split("\n")
  end

  def parse_line(str) do
    [[_, p1, change, n_string, p2]] =
      Regex.scan(~r/(\w+) would (\w+) (\d+) happiness units by sitting next to (\w+)/, str)

    n = if(change == "gain", do: 1, else: -1) * String.to_integer(n_string)

    %{{p1, p2} => n}
  end

  def get_names(map) do
    map |> Map.keys() |> Enum.flat_map(fn {n1, n2} -> [n1, n2] end) |> Enum.uniq()
  end

  def permutations([]), do: [[]]
  def permutations(list), do: for(h <- list, t <- permutations(list -- [h]), do: [h | t])

  def get_seating_from_permutation(p) do
    [[List.last(p), List.first(p)] | Enum.chunk_every(p, 2, 1, :discard)]
    |> (fn s -> Enum.map(s, fn [n1, n2] -> [{n1, n2}, {n2, n1}] end) end).()
  end

  def get_seatings(names) do
    names |> permutations() |> Enum.map(&get_seating_from_permutation/1)
  end

  def calc_seating(s, map) do
    s
    |> Enum.map(&Enum.map(&1, fn [p1, p2] -> [Map.get(map, p1), Map.get(map, p2)] end))
    |> Enum.map(&Enum.map(&1, fn points -> Enum.sum(points) end))
    |> Enum.map(&Enum.sum/1)
  end

  def part1() do
    map =
      read_input() |> Enum.map(&parse_line/1) |> Enum.reduce(fn m1, m2 -> Map.merge(m1, m2) end)

    map |> get_names() |> get_seatings() |> (fn s -> calc_seating(s, map) end).() |> Enum.max()
  end

  def calc_seating_2(s, map) do
    s
    |> Enum.map(&Enum.map(&1, fn [p1, p2] -> [Map.get(map, p1), Map.get(map, p2)] end))
    |> Enum.map(&Enum.map(&1, fn points -> Enum.sum(points) end))
    |> Enum.sort()
    |> Enum.map(fn sums -> sums |> Enum.drop(1) end)
    |> Enum.map(&Enum.sum/1)
  end

  def part2() do
    map =
      read_input() |> Enum.map(&parse_line/1) |> Enum.reduce(fn m1, m2 -> Map.merge(m1, m2) end)

    map |> get_names() |> get_seatings() |> (fn s -> calc_seating_2(s, map) end).() |> Enum.max()
  end
end
