defmodule Day02 do
  def read_input() do
    File.read!('data/02.txt')
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
  end

  # A for Rock, B for Paper, and C for Scissors
  # X for Rock, Y for Paper, and Z for Scissors
  def fight("A", "X"), do: 3
  def fight("A", "Y"), do: 6
  def fight("A", "Z"), do: 0
  def fight("B", "X"), do: 0
  def fight("B", "Y"), do: 3
  def fight("B", "Z"), do: 6
  def fight("C", "X"), do: 6
  def fight("C", "Y"), do: 0
  def fight("C", "Z"), do: 3

  def score([opp, "X"]), do: fight(opp, "X") + 1
  def score([opp, "Y"]), do: fight(opp, "Y") + 2
  def score([opp, "Z"]), do: fight(opp, "Z") + 3

  def part1(), do: read_input() |> Enum.map(&score/1) |> Enum.sum()

  # A for Rock, B for Paper, and C for Scissors
  # X means lose, Y means draw, and Z means win.
  def score2(["A", "X"]), do: 0 + 3
  def score2(["A", "Y"]), do: 3 + 1
  def score2(["A", "Z"]), do: 6 + 2
  def score2(["B", "X"]), do: 0 + 1
  def score2(["B", "Y"]), do: 3 + 2
  def score2(["B", "Z"]), do: 6 + 3
  def score2(["C", "X"]), do: 0 + 2
  def score2(["C", "Y"]), do: 3 + 3
  def score2(["C", "Z"]), do: 6 + 1

  def part2(), do: read_input() |> Enum.map(&score2/1) |> Enum.sum()
end
