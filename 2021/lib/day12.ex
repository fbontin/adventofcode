defmodule Day12 do
  def read_input() do
    File.read!('data/12.txt') |> String.split("\n", trim: true)
  end

  def str_to_graph(str) do
    [s, e] = String.split(str, "-")
    %{s => [e], e => [s]}
  end

  def to_graph(strings) do
    strings
    |> Enum.map(&str_to_graph/1)
    |> Enum.reduce(&Map.merge(&1, &2, fn _, v1, v2 -> Enum.concat(v1, v2) end))
  end

  def traversable?(node, path) do
    String.upcase(node) == node or not Enum.member?(path, node)
  end

  def traverse("end", path, _), do: %{:p => ["end" | path]}

  def traverse(curr, path, graph) do
    graph[curr]
    |> Enum.filter(fn n -> traversable?(n, path) end)
    |> Enum.flat_map(fn n -> traverse(n, [curr | path], graph) end)
  end

  def part1() do
    graph = read_input() |> to_graph()
    traverse("start", [], graph) |> length()
  end

  def big?(node), do: String.upcase(node) == node

  def has_small_duplicates?(path) do
    small = Enum.filter(path, &(not big?(&1)))
    length(Enum.uniq(small)) != length(small)
  end

  def can_add_duplicate?("start", _), do: false
  def can_add_duplicate?("end", _), do: false
  def can_add_duplicate?(_, path), do: not has_small_duplicates?(path)

  def traversable2?(node, path) do
    big?(node) or
      not Enum.member?(path, node) or
      can_add_duplicate?(node, path)
  end

  def traverse2("end", path, _), do: %{:p => ["end" | path]}

  def traverse2(curr, path, graph) do
    graph[curr]
    |> Enum.filter(fn n -> traversable2?(n, [curr | path]) end)
    |> Enum.flat_map(fn n -> traverse2(n, [curr | path], graph) end)
  end

  def part2() do
    graph = read_input() |> to_graph()
    traverse2("start", [], graph) |> length()
  end
end
