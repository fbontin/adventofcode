defmodule Day1 do
  def read_input() do
    File.read!(~c"data/01.txt") |> String.trim() |> String.split("\n")
  end

  def part1() do
    read_input()
  end
end
