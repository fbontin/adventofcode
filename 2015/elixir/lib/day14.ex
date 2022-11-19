defmodule Day14 do
  def read_input() do
    File.read!('data/14.txt') |> String.trim() |> String.split("\n")
  end

  def parse_row(str) do
    [[_, speed, fly_time, rest_time]] =
      Regex.scan(~r/fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds/, str)

    {String.to_integer(speed), String.to_integer(fly_time), String.to_integer(rest_time)}
  end

  def run({speed, f, r}, {f_left, r_left}, time_left) do
    cond do
      time_left == 0 -> 0
      f_left == 1 -> speed + run({speed, f, r}, {0, r}, time_left - 1)
      r_left == 1 -> run({speed, f, r}, {f, 0}, time_left - 1)
      f_left > 0 -> speed + run({speed, f, r}, {f_left - 1, r}, time_left - 1)
      r_left > 0 -> run({speed, f, r}, {f_left, r_left - 1}, time_left - 1)
    end
  end

  def run({speed, f, r}, time_left), do: run({speed, f, r}, {f, 0}, time_left)

  def part1() do
    read_input() |> Enum.map(&parse_row/1) |> Enum.map(fn r -> run(r, 2503) end) |> Enum.max()
  end

  def award_point(distances) do
    highest = distances |> Enum.max()
    distances |> Enum.map(fn d -> if d == highest, do: 1, else: 0 end)
  end

  def add_lists(l1, l2) do
    Enum.zip(l1, l2) |> Enum.map(fn {n1, n2} -> n1 + n2 end)
  end

  def part2() do
    reindeers = read_input() |> Enum.map(&parse_row/1)

    1..2503
    |> Enum.map(fn n -> Enum.map(reindeers, fn r -> run(r, n) end) end)
    |> Enum.map(&award_point/1)
    |> Enum.reduce(List.duplicate(0, length(reindeers)), &add_lists/2)
    |> Enum.max()
  end
end
