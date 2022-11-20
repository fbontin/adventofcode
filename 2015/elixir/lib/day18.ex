defmodule Day18 do
  def read_input() do
    File.read!('data/18.txt') |> String.trim() |> String.split("\n")
    # [".#.#.#", "...##.", "#....#", "..#...", "#.#..#", "####.."]
  end

  def parse_row({row, y}) do
    row |> String.graphemes() |> Enum.with_index() |> Enum.map(fn {c, x} -> {x, y, c} end)
  end

  def parse_input(strs) do
    strs
    |> Enum.with_index()
    |> Enum.flat_map(&parse_row/1)
    |> Enum.reduce(%{}, fn {x, y, c}, m -> Map.put(m, {x, y}, c) end)
  end

  def get_neighbors({x, y}, lights) do
    [
      [{x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1}],
      [{x - 1, y}, {x, y + 1}],
      [{x - 1, y + 1}, {x + 1, y}, {x + 1, y + 1}]
    ]
    |> List.flatten()
    |> Enum.filter(fn pos -> Map.has_key?(lights, pos) end)
    |> Enum.map(fn pos -> Map.get(lights, pos) end)
  end

  def update_light(pos, lights) do
    nbr_neighbors_on = get_neighbors(pos, lights) |> Enum.count(fn l -> l == "#" end)
    l = Map.get(lights, pos)

    case l do
      "#" -> if nbr_neighbors_on == 2 || nbr_neighbors_on == 3, do: "#", else: "."
      _ -> if nbr_neighbors_on == 3, do: "#", else: "."
    end
  end

  def run(lights, 0), do: lights

  def run(lights, n) do
    lights
    |> Map.keys()
    |> Enum.map(fn pos -> {pos, update_light(pos, lights)} end)
    |> Enum.reduce(%{}, fn {pos, l}, m -> Map.put(m, pos, l) end)
    |> print()
    |> run(n - 1)
  end

  def part1() do
    read_input() |> parse_input() |> run(100) |> Map.values() |> Enum.count(&(&1 == "#"))
  end

  def print(lights) do
    size = lights |> Map.keys() |> Enum.map(fn {k, _} -> k end) |> Enum.max()

    for(y <- 0..size, do: for(x <- 0..size, do: Map.get(lights, {x, y})))
    |> Enum.map(fn strs -> Enum.into(strs, "") end)
    |> Enum.each(&IO.inspect/1)

    IO.puts("")

    lights
  end
end
