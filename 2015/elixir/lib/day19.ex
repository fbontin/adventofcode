defmodule Day19 do
  def read_input() do
    File.read!('data/19.txt') |> String.trim() |> String.split("\n")
  end

  def parse_machine(strs) do
    strs
    |> Enum.map(fn s -> String.split(s, " => ") end)
    |> Enum.reduce(%{}, fn [k, v], m ->
      Map.update(m, k, [v], fn old_v -> [v | old_v] end)
    end)
  end

  def replace(start, {i, r}) do
    start |> List.replace_at(i, r) |> Enum.join("")
  end

  def split_str(start_str) do
    Regex.scan(~r/.[a-z]?/, start_str) |> List.flatten()
  end

  def part1() do
    [start_str | [_ | machine_strs]] = read_input() |> Enum.reverse()
    machine = parse_machine(machine_strs)
    start = split_str(start_str)

    start
    |> Enum.with_index()
    |> Enum.filter(fn {c, _} -> Map.has_key?(machine, c) end)
    |> Enum.map(fn {c, i} -> {i, c, Map.get(machine, c)} end)
    |> Enum.flat_map(fn {i, c, r} -> r |> Enum.map(&{i, c, &1}) end)
    |> Enum.map(fn {i, _c, r} -> replace(start, {i, r}) end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2() do
    # Help for part 2
    # https://www.reddit.com/r/adventofcode/comments/3xflz8/comment/cy4etju/

    [medicine_str | _rest] = read_input() |> Enum.reverse()

    med =
      medicine_str
      |> String.replace("Rn", "(")
      |> String.replace("Ar", ")")
      |> String.replace("Y", ",")
      |> split_str()

    total_length = length(med)
    parens_length = Enum.filter(med, fn c -> c == "(" || c == ")" end) |> length()
    comma_length = Enum.filter(med, fn c -> c == "," end) |> length()

    {total_length, parens_length, comma_length,
     total_length - parens_length - comma_length * 2 - 1}
  end
end
