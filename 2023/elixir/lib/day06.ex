defmodule Day6 do
  @input [{62, 644}, {73, 1023}, {75, 1240}, {65, 1023}]

  def get_nbr_of_record_beatings({time, distance}) do
    0..time
    |> Enum.map(&(&1 * (time - &1)))
    |> Enum.filter(&(&1 > distance))
    |> Enum.count()
  end

  def part1() do
    @input
    |> Enum.map(&get_nbr_of_record_beatings/1)
    |> Enum.product()
  end

  @input2 {62_737_565, 644_102_312_401_023}

  def part2(), do: @input2 |> get_nbr_of_record_beatings()
end
