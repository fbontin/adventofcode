defmodule Day7 do
  def read_input() do
    File.read!('data/07.txt') |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  def get_positions_between(ps) do
    {min, max} = Enum.min_max(ps)
    Enum.to_list(min..max)
  end

  def calc_fuel_for_pos(pos, ps) do
    ps |> Enum.map(fn p -> abs(p - pos) end) |> Enum.sum()
  end

  def part1() do
    ps = read_input()

    get_positions_between(ps)
    |> Enum.map(fn pos -> calc_fuel_for_pos(pos, ps) end)
    |> Enum.min()
  end

  def move(n), do: Enum.sum(0..n)

  def calc_fuel_for_pos2(pos, ps) do
    ps |> Enum.map(fn p -> move(abs(p - pos)) end) |> Enum.sum()
  end

  def part2() do
    ps = read_input()

    get_positions_between(ps)
    |> Enum.map(fn pos -> calc_fuel_for_pos2(pos, ps) end)
    |> Enum.min()
  end
end
