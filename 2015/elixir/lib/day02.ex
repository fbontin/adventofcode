defmodule Day2 do
  def read_input() do
    File.read!('data/02.txt')
    |> String.split("\n")
    |> Enum.map(fn l ->
      String.split(l, "x")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def area([l | [w | [h]]], area_sum) do
    lw = l * w
    wh = w * h
    hl = h * l
    slack = Enum.min([lw, wh, hl])
    area_sum + 2 * lw + 2 * wh + 2 * hl + slack
  end

  def part1() do
    read_input() |> Enum.reduce(0, &area/2)
  end

  def ribbon([l | [w | [h]]], sum) do
    v = l * w * h

    Enum.sort([l, w, h])
    |> Enum.take(2)
    |> Enum.sum()
    |> (&(&1 * 2 + v + sum)).()
  end

  def part2() do
    read_input() |> Enum.reduce(0, &ribbon/2)
  end
end
