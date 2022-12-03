defmodule Day03 do
  def read_input() do
    File.read!('data/03.txt') |> String.trim() |> String.split("\n")
  end

  def split(str), do: String.split_at(str, div(String.length(str), 2))

  def find_char({s1, s2}) do
    [c] = for <<c1 <- s1>>, <<c2 <- s2>>, c1 == c2, uniq: true, do: c1
    c
  end

  def get_priority(c) when c <= 90, do: c - 38
  def get_priority(c), do: c - 96

  def part1() do
    read_input()
    |> Enum.map(&split/1)
    |> Enum.map(&find_char/1)
    |> Enum.map(&get_priority/1)
    |> Enum.sum()
  end

  def find_badge([s1, s2, s3]) do
    [c] = for <<c1 <- s1>>, <<c2 <- s2>>, <<c3 <- s3>>, c1 == c2 && c1 == c3, uniq: true, do: c1
    c
  end

  def part2() do
    read_input()
    |> Enum.chunk_every(3)
    |> Enum.map(&find_badge/1)
    |> Enum.map(&get_priority/1)
    |> Enum.sum()
  end
end
