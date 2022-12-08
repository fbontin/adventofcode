defmodule Day07 do
  def read_input() do
    File.read!('data/07.txt')
    |> String.trim()
    |> String.split("$ ")
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(fn l -> Enum.reject(l, &(&1 == "")) end)
  end

  def parse_ls_line("dir " <> _), do: 0

  def parse_ls_line(s) do
    s |> String.split(" ") |> List.first() |> String.to_integer()
  end

  def add_to_map(sum, pos, map) do
    Map.put(map, pos |> Enum.reverse() |> Enum.join("/"), sum)
  end

  def run(["cd .."], {[_ | pos], map}), do: {pos, map}
  def run(["cd " <> d], {pos, map}), do: {[d | pos], map}

  def run(["ls" | output], {pos, map}) do
    {pos, output |> Enum.map(&parse_ls_line/1) |> Enum.sum() |> add_to_map(pos, map)}
  end

  def add_sub_dirs(dir, map) do
    {dir,
     map
     |> Enum.filter(fn {k, _v} -> String.starts_with?(k, dir) end)
     |> Enum.map(fn {_k, v} -> v end)
     |> Enum.sum()}
  end

  def add_sub_dirs(map), do: Map.keys(map) |> Enum.map(&add_sub_dirs(&1, map))

  def part1() do
    {_, map} = read_input() |> Enum.reduce({[], %{}}, &run/2)

    add_sub_dirs(map)
    |> Enum.map(fn {_dir, size} -> size end)
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  def part2() do
    {_, map} = read_input() |> Enum.reduce({[], %{}}, &run/2)
    dirs = add_sub_dirs(map)
    used_space = Enum.find(dirs, fn {dir, _size} -> dir == "/" end) |> elem(1)
    space_needed = used_space - 40_000_000

    dirs
    |> Enum.map(fn {_dir, size} -> size end)
    |> Enum.filter(&(&1 >= space_needed))
    |> Enum.min()
  end
end
