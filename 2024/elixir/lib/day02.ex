defmodule Day2 do
  def read_input() do
    File.read!("data/02.txt") |> String.trim() |> String.split("\n")
  end

  def parse_line(line) do
    line |> String.split(" ") |> Enum.map(&String.to_integer/1)
  end

  def test_sliding_window(report, predicate) do
    report |> Enum.chunk_every(2, 1, :discard) |> Enum.all?(predicate)
  end

  def is_ascending(report), do: test_sliding_window(report, fn [a, b] -> a < b end)
  def is_descending(report), do: test_sliding_window(report, fn [a, b] -> a > b end)

  def has_low_difference(report),
    do: test_sliding_window(report, fn [a, b] -> abs(a - b) <= 3 end)

  def is_safe(report) do
    (is_ascending(report) or is_descending(report)) and has_low_difference(report)
  end

  def part1() do
    read_input() |> Enum.map(&parse_line/1) |> Enum.count(&is_safe/1)
  end

  def remove_from_list(index, list) do
    Enum.take(list, index - 1) ++ Enum.take(list, index - length(list))
  end

  def create_dampened_reports(report) do
    1..length(report) |> Enum.map(&remove_from_list(&1, report))
  end

  def is_safe_2(report) do
    create_dampened_reports(report) |> Enum.any?(&is_safe/1)
  end

  def part2() do
    read_input()
    |> Enum.map(&parse_line/1)
    |> Enum.count(&is_safe_2/1)
  end
end
