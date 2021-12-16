defmodule Day13 do
  def read_input() do
    File.read!('data/13.txt')
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn s -> String.split(s, "\n", trim: true) end)
  end

  def str_to_point(s) do
    [x, y] = String.split(s, ",", trim: true)
    {String.to_integer(x), String.to_integer(y)}
  end

  def str_to_fold("fold along " <> s) do
    [dir, n] = String.split(s, "=", trim: true)
    d = if dir == "x", do: :x, else: :y
    {d, String.to_integer(n)}
  end

  def parse_input([points, folds]) do
    {points |> Enum.map(&str_to_point/1), folds |> Enum.map(&str_to_fold/1)}
  end

  def get_size(points) do
    {x, y} = Enum.unzip(points)
    {Enum.max(x), Enum.max(y)}
  end

  def point_to_char(p, points) do
    if(Enum.member?(points, p), do: "#", else: ".")
  end

  def print(points) do
    {x_max, y_max} = get_size(points)

    for y <- 0..y_max,
        do:
          for(x <- 0..x_max, do: point_to_char({x, y}, points))
          |> Enum.join()
  end

  def fold_point(:x, {x, y}, n) do
    if x > n, do: {n * 2 - x, y}, else: {x, y}
  end

  def fold_point(:y, {x, y}, n) do
    if y > n, do: {x, n * 2 - y}, else: {x, y}
  end

  def fold({dir, n}, points) do
    points |> Enum.map(fn p -> fold_point(dir, p, n) end) |> Enum.uniq()
  end

  def part1() do
    {points, [f | _]} = read_input() |> parse_input()
    fold(f, points) |> length()
  end

  def part2() do
    {points, folds} = read_input() |> parse_input()
    folds |> Enum.reduce(points, fn f, p -> fold(f, p) end) |> print()
  end
end
