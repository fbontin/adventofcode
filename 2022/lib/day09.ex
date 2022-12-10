defmodule Day09 do
  def read_input() do
    File.read!('data/09.txt') |> String.trim() |> String.split("\n")
  end

  def parse_line(str) do
    [d, l] = String.split(str, " ")
    {d, String.to_integer(l)}
  end

  def move_head("R", {x, y}), do: {x + 1, y}
  def move_head("D", {x, y}), do: {x, y - 1}
  def move_head("L", {x, y}), do: {x - 1, y}
  def move_head("U", {x, y}), do: {x, y + 1}

  def touches?({x1, y1}, {x2, y2}), do: abs(x1 - x2) <= 1 and abs(y1 - y2) <= 1

  def move_tail({h_x, h_y}, {x, y}) do
    cond do
      touches?({h_x, h_y}, {x, y}) -> {x, y}
      h_x == x and y < h_y -> {x, y + 1}
      h_x == x and y > h_y -> {x, y - 1}
      h_y == y and x < h_x -> {x + 1, y}
      h_y == y and x > h_x -> {x - 1, y}
      x > h_x and y > h_y -> {x - 1, y - 1}
      x < h_x and y > h_y -> {x + 1, y - 1}
      x < h_x and y < h_y -> {x + 1, y + 1}
      x > h_x and y < h_y -> {x - 1, y + 1}
    end
  end

  def move({_, 0}, result), do: result

  def move({d, l}, {h_pos, t_pos, set}) do
    new_h_pos = move_head(d, h_pos)
    new_t_pos = move_tail(new_h_pos, t_pos)
    move({d, l - 1}, {new_h_pos, new_t_pos, MapSet.put(set, new_t_pos)})
  end

  def part1() do
    read_input()
    |> Enum.map(&parse_line/1)
    |> Enum.reduce({{0, 0}, {0, 0}, MapSet.new()}, &move/2)
    |> elem(2)
    |> Enum.count()
  end

  def move_long_tail(t, new_tail_pos) do
    closest_tail_part = List.first(new_tail_pos)
    [move_tail(closest_tail_part, t) | new_tail_pos]
  end

  def move2({_, 0}, result), do: result

  def move2({d, l}, {h_pos, t_pos, set}) do
    new_h_pos = move_head(d, h_pos)

    new_t_pos =
      Enum.reduce(t_pos, [new_h_pos], &move_long_tail/2) |> Enum.reverse() |> Enum.drop(1)

    move2({d, l - 1}, {new_h_pos, new_t_pos, MapSet.put(set, List.last(new_t_pos))})
  end

  def part2() do
    read_input()
    |> Enum.map(&parse_line/1)
    |> Enum.reduce({{0, 0}, List.duplicate({0, 0}, 9), MapSet.new()}, &move2/2)
    |> elem(2)
    |> Enum.count()
  end
end
