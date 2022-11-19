defmodule Day15 do
  def read_input() do
    File.read!('data/15.txt') |> String.trim() |> String.split("\n")
  end

  def parse_part(str) do
    String.split(str, " ") |> List.last() |> String.to_integer()
  end

  def parse_row(str) do
    str |> String.split(",") |> Enum.map(&parse_part/1)
  end

  def get_all_recipes() do
    for x <- 1..100 do
      for y <- 1..(100 - x) do
        for z <- 1..(100 - x - y) do
          for w <- 1..(100 - x - y - z) do
            [{x, y, z, w}]
          end
        end
      end
    end
    |> List.flatten()
  end

  def calc({n1, n2, n3, n4}, [i1, i2, i3, i4]) do
    calc_ingr = fn i, n -> Enum.map(i, &(&1 * n)) end

    [_calories | rest] =
      [calc_ingr.(i1, n1), calc_ingr.(i2, n2), calc_ingr.(i3, n3), calc_ingr.(i4, n4)]
      |> List.zip()
      |> Enum.map(fn {x, y, z, w} -> max(x + y + z + w, 0) end)
      |> Enum.reverse()

    rest |> Enum.reduce(&*/2)
  end

  def part1() do
    ingredients = read_input() |> Enum.map(&parse_row/1)

    get_all_recipes() |> Enum.map(&calc(&1, ingredients)) |> Enum.max()
  end
end
