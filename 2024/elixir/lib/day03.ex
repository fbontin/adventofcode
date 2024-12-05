defmodule Day3 do
  def read_input() do
    File.read!("data/03.txt") |> String.trim()
  end

  def product([_, s1, s2]), do: String.to_integer(s1) * String.to_integer(s2)

  def part1() do
    Regex.scan(~r"mul\((\d+),(\d+)\)", read_input())
    |> Enum.map(&product/1)
    |> Enum.sum()
  end

  def parse(["do()"]), do: :do
  def parse(["don't()"]), do: :dont
  def parse(match), do: product(match)

  def calculate(el, {n, state}) do
    if is_integer(el) do
      case state do
        :do -> {el + n, state}
        :dont -> {n, state}
      end
    else
      {n, el}
    end
  end

  def part2() do
    Regex.scan(~r"mul\((\d+),(\d+)\)|do\(\)|don't\(\)", read_input())
    |> Enum.map(&parse/1)
    |> Enum.reduce({0, :do}, &calculate/2)
  end
end
