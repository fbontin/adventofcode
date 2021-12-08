defmodule Day8 do
  def read_input() do
    File.read!('data/08.txt')
    |> String.split("\n", trim: true)
    |> Enum.map(fn r -> String.split(r, " | ") end)
  end

  def pattern_to_number(p) do
    case String.length(p) do
      2 -> 1
      4 -> 4
      3 -> 7
      7 -> 8
      _ -> nil
    end
  end

  def count_1478_in_row([_, output]) do
    String.split(output)
    |> Enum.map(&pattern_to_number/1)
    |> Enum.filter(&Function.identity/1)
    |> Enum.count()
  end

  def part1() do
    read_input()
    |> Enum.map(&count_1478_in_row/1)
    |> Enum.sum()
  end

  def str_to_set(str) do
    str |> String.split("", trim: true) |> MapSet.new()
  end

  def set_to_str(set) do
    set |> MapSet.to_list() |> List.to_string()
  end

  def size_is_five?(set), do: MapSet.size(set) == 5
  def size_is_six?(set), do: MapSet.size(set) == 6

  def find_1(p, _), do: p |> Enum.find(&(MapSet.size(&1) == 2))
  def find_4(p, _), do: p |> Enum.find(&(MapSet.size(&1) == 4))
  def find_7(p, _), do: p |> Enum.find(&(MapSet.size(&1) == 3))
  def find_8(p, _), do: p |> Enum.find(&(MapSet.size(&1) == 7))

  def find_0(patterns, map) do
    patterns
    |> Enum.filter(&size_is_six?/1)
    |> Enum.find(fn p ->
      not MapSet.equal?(p, map[9]) && not MapSet.equal?(p, map[6])
    end)
  end

  def find_2(patterns, map) do
    patterns
    |> Enum.filter(&size_is_five?/1)
    |> Enum.find(fn p -> not MapSet.subset?(p, map[9]) end)
  end

  def find_3(patterns, map) do
    patterns
    |> Enum.filter(&size_is_five?/1)
    |> Enum.find(fn p -> MapSet.subset?(map[7], p) end)
  end

  def find_5(patterns, map) do
    patterns
    |> Enum.filter(&size_is_five?/1)
    |> Enum.find(fn p ->
      not MapSet.equal?(p, map[2]) && not MapSet.equal?(p, map[3])
    end)
  end

  def find_6(patterns, map) do
    patterns
    |> Enum.filter(&size_is_six?/1)
    |> Enum.find(fn p -> not MapSet.subset?(map[7], p) end)
  end

  def find_9(patterns, map) do
    patterns
    |> Enum.filter(&size_is_six?/1)
    |> Enum.find(fn p -> MapSet.subset?(map[4], p) end)
  end

  def find(map, n, func, patterns) do
    Map.put(map, n, func.(patterns, map))
  end

  def solve_row([pattern_string, output]) do
    patterns = String.split(pattern_string) |> Enum.map(&str_to_set/1)

    find = fn map, n, func -> find(map, n, func, patterns) end

    map =
      %{}
      |> find.(1, &find_1/2)
      |> find.(4, &find_4/2)
      |> find.(7, &find_7/2)
      |> find.(8, &find_8/2)
      |> find.(3, &find_3/2)
      |> find.(6, &find_6/2)
      |> find.(9, &find_9/2)
      |> find.(2, &find_2/2)
      |> find.(0, &find_0/2)
      |> find.(5, &find_5/2)

    inverse_map = Map.new(map, fn {k, v} -> {set_to_str(v), k} end)

    output
    |> String.split()
    |> Enum.map(fn s -> s |> str_to_set |> set_to_str end)
    |> Enum.map(fn s -> inverse_map[s] end)
    |> Enum.join()
    |> String.to_integer()
  end

  def part2() do
    read_input()
    |> Enum.map(&solve_row/1)
    |> Enum.sum()
  end
end
