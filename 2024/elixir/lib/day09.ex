defmodule Day9 do
  def read_input(), do: File.read!("data/09.txt") |> String.trim()
  def parse_input(input), do: input |> String.graphemes() |> Enum.map(&String.to_integer/1)

  def part_to_string({[file_space, empty_space], id}),
    do: List.duplicate(id, file_space) ++ List.duplicate(".", empty_space)

  def to_array(numbers) do
    numbers
    |> Enum.chunk_every(2, 2, [0])
    |> Enum.with_index()
    |> Enum.flat_map(&part_to_string/1)
  end

  def visualise(list) do
    list |> Enum.join() |> IO.inspect(label: "visualised")
    list
  end

  def swap(l, i1, i2) do
    e1 = Enum.at(l, i1)
    e2 = Enum.at(l, i2)
    l |> List.replace_at(i1, e2) |> List.replace_at(i2, e1)
  end

  def last_file_space(l) do
    i = l |> Enum.reverse() |> Enum.find_index(&(&1 != "."))
    length(l) - 1 - i
  end

  def first_empty_space(l), do: l |> Enum.find_index(&(&1 == "."))

  def defrag(l) do
    last = last_file_space(l)
    first = first_empty_space(l)

    if last < first, do: l, else: swap(l, last, first) |> defrag()
  end

  def checksum(l) do
    Enum.with_index(l)
    |> Enum.filter(fn {c, _} -> c != "." end)
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end

  def part1(), do: read_input() |> parse_input() |> to_array() |> defrag() |> checksum()
end
