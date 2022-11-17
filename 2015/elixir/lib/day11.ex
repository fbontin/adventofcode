defmodule Day11 do
  def read_input() do
    File.read!('data/11.txt') |> String.trim()
  end

  def str_to_ascii(s), do: s |> String.to_charlist() |> List.first()

  def incr_backwards(["z" | tail]), do: ["a" | incr_backwards(tail)]
  def incr_backwards([s | tail]), do: [String.Chars.to_string([str_to_ascii(s) + 1]) | tail]

  def increment(chars), do: chars |> Enum.reverse() |> incr_backwards() |> Enum.reverse()

  def is_straight(str) do
    [a, b, c] = str |> Enum.map(&str_to_ascii/1)
    b - a == 1 && c - b == 1
  end

  def has_straight(chars) do
    chars |> Enum.chunk_every(3, 1, :discard) |> Enum.any?(&is_straight/1)
  end

  def has_iol(chars), do: Enum.any?(chars, fn c -> c in ["i", "o", "l"] end)

  def has_two_pairs(chars) do
    Regex.scan(~r/(.)\1/, Enum.into(chars, ""))
    |> Enum.map(&List.first/1)
    |> Enum.uniq()
    |> (fn n -> length(n) >= 2 end).()
  end

  def meets_requirements(chars) do
    has_straight(chars) && !has_iol(chars) && has_two_pairs(chars)
  end

  def run(chars) do
    case meets_requirements(chars) do
      true -> chars
      _ -> chars |> increment() |> run()
    end
  end

  def part1() do
    read_input() |> String.graphemes() |> run() |> Enum.into("")
  end

  def part2() do
    read_input() |> String.graphemes() |> run() |> increment() |> run() |> Enum.into("")
  end
end
