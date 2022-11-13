defmodule Day5 do
  def read_input() do
    File.read!("data/05.txt") |> String.split()
  end

  def has_three_vowels(str) do
    ~r/[aeiou]/
    |> Regex.scan(str)
    |> Enum.count()
    |> (fn n -> n >= 3 end).()
  end

  def has_double_letter(str) do
    str
    |> String.graphemes()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.any?(fn [c1, c2] -> c1 == c2 end)
  end

  def has_forbidden_str(str) do
    ~r/ab|cd|pq|xy/ |> Regex.match?(str)
  end

  def is_nice(str) do
    has_three_vowels(str) && has_double_letter(str) && !has_forbidden_str(str)
  end

  def part1() do
    read_input() |> Enum.map(&is_nice/1) |> Enum.count(& &1)
  end

  def has_reoccuring_part(str) do
    str
    |> String.graphemes()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [c1, c2] -> c1 <> c2 end)
    |> Enum.map(&Regex.scan(~r/#{&1}/, str))
    |> Enum.any?(&(Enum.count(&1) >= 2))
  end

  def has_repeat_letter(str) do
    Regex.match?(~r/(\w)\w\1/, str)
  end

  def is_nice_2(str) do
    has_reoccuring_part(str) && has_repeat_letter(str)
  end

  def part2() do
    read_input() |> Enum.map(&is_nice_2/1) |> Enum.count(& &1)
  end
end
