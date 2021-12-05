defmodule Day3 do
  def read_input() do
    File.read!('data/03.txt')
    |> String.split("")
    |> Enum.filter(fn c -> c != "" end)
  end

  def move("^", {x, y}), do: {x, y + 1}
  def move("v", {x, y}), do: {x, y - 1}
  def move(">", {x, y}), do: {x + 1, y}
  def move("<", {x, y}), do: {x - 1, y}

  def gift([d | ds], {set, pos}) do
    gift(ds, {MapSet.put(set, pos), move(d, pos)})
  end

  def gift([], {set, pos}), do: {MapSet.put(set, pos), pos}

  def part1() do
    start_set = MapSet.new() |> MapSet.put({0, 0})
    {set, pos} = read_input() |> gift({start_set, {0, 0}})
    {MapSet.size(set), pos}
  end

  def part2() do
    [h | tail] = read_input()
    s_list = [h | tail] |> Enum.take_every(2)
    rs_list = tail |> Enum.take_every(2)

    start_set = MapSet.new() |> MapSet.put({0, 0})
    {s_set, _} = gift(s_list, {start_set, {0, 0}})
    {rs_set, _} = gift(rs_list, {start_set, {0, 0}})

    MapSet.union(s_set, rs_set) |> MapSet.size()
  end
end
