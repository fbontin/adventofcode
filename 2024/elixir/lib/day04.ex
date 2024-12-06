defmodule Day4 do
  @directions [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 0}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
  @x_directions [{-1, -1}, {-1, 1}, {0, 0}, {1, -1}, {1, 1}]

  def read_input() do
    File.read!("data/04.txt") |> String.trim()
  end

  def to_map(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {list, y} -> Enum.map(list, fn {letter, x} -> {{x, y}, letter} end) end)
    |> Map.new()
  end

  def add_pos({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}
  def surrounding(pos), do: @directions |> Enum.map(fn d -> {add_pos(d, pos), d} end)

  def is_xmas(m_pos, d, map) do
    a_pos = m_pos |> add_pos(d)
    s_pos = a_pos |> add_pos(d)

    Map.get(map, m_pos) == "M" and
      Map.get(map, a_pos) == "A" and
      Map.get(map, s_pos) == "S"
  end

  def part1() do
    map = read_input() |> to_map()

    map
    |> Map.filter(fn {_, l} -> l == "X" end)
    |> Map.to_list()
    |> Enum.flat_map(fn {p, _l} -> surrounding(p) end)
    |> Enum.count(fn {p, d} -> is_xmas(p, d, map) end)
  end

  def x_surrounding(pos), do: @x_directions |> Enum.map(&add_pos(&1, pos))

  def is_letter(pos, letter, map), do: Map.get(map, pos) == letter

  def is_x_mas([ul, dl, _c, ur, dr], map) do
    ((is_letter(ul, "M", map) and is_letter(dr, "S", map)) or
       (is_letter(ul, "S", map) and is_letter(dr, "M", map))) and
      ((is_letter(dl, "M", map) and is_letter(ur, "S", map)) or
         (is_letter(dl, "S", map) and is_letter(ur, "M", map)))
  end

  def part2() do
    map = read_input() |> to_map()

    map
    |> Map.filter(fn {_, l} -> l == "A" end)
    |> Map.to_list()
    |> Enum.map(fn {p, _l} -> x_surrounding(p) end)
    |> Enum.count(fn ps -> is_x_mas(ps, map) end)
  end
end
