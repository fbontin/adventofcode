defmodule Day4 do
  def read_input() do
    File.read!('data/04.txt') |> String.trim()
  end

  def hash(input) do
    :crypto.hash(:md5, input) |> Base.encode16()
  end

  def starts_with_five_zeroes("00000" <> _), do: true
  def starts_with_five_zeroes(_), do: false

  def is_lowest_number_part1(n, secret) do
    (secret <> to_string(n)) |> hash() |> starts_with_five_zeroes()
  end

  def part1() do
    secret = read_input()

    Enum.to_list(1..1_000_000)
    |> Enum.find("nope", fn n -> is_lowest_number_part1(n, secret) end)
  end

  def starts_with_six_zeroes("000000" <> _), do: true
  def starts_with_six_zeroes(_), do: false

  def is_lowest_number_part2(n, secret) do
    (secret <> to_string(n)) |> hash() |> starts_with_six_zeroes()
  end

  def part2() do
    secret = read_input()

    Enum.to_list(1..10_000_000)
    |> Enum.find("nope", fn n -> is_lowest_number_part2(n, secret) end)
  end
end
