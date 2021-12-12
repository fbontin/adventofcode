defmodule Day11 do
  def read_input() do
    File.read!('data/11.txt')
    |> String.split("\n", trim: true)
    |> Enum.map(fn s -> String.split(s, "", trim: true) end)
  end

  def create_pos_map(rows) do
    matrix = for y <- 0..9, do: for(x <- 0..9, do: {x, y})

    matrix
    |> Enum.flat_map(fn p -> p end)
    |> Enum.map(fn {x, y} -> {{x, y}, Enum.at(rows, y) |> Enum.at(x)} end)
    |> Enum.map(fn {xy, v} -> {xy, {String.to_integer(v), false}} end)
    |> Enum.into(%{})
  end

  def get_adjs({x, y}, size) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
    |> Enum.filter(fn {x_, y_} -> x_ >= 0 and x_ < size and y_ >= 0 and y_ < size end)
  end

  def flash_all(pos_map) do
    size = map_size(pos_map) |> :math.sqrt()

    flash_map =
      pos_map
      |> Enum.filter(fn {_, {n, _}} -> n > 9 end)
      |> Enum.filter(fn {_, {_, f}} -> not f end)
      |> Enum.into(%{})

    adjs =
      flash_map
      |> Enum.flat_map(fn {pos, _} -> get_adjs(pos, size) end)
      |> Enum.frequencies()

    flashed_map =
      flash_map
      |> Enum.map(fn {k, {n, _}} -> {k, {n, true}} end)
      |> Enum.into(%{})

    case map_size(flash_map) do
      0 ->
        pos_map

      _ ->
        pos_map
        |> Map.merge(flashed_map, fn _, {n, _}, {_, f} -> {n, f} end)
        |> Map.merge(adjs, fn _, {n1, f}, n2 -> {n1 + n2, f} end)
        |> flash_all()
    end
  end

  def reset_flashed({pos, {_, true}}), do: {pos, {0, false}}
  def reset_flashed({pos, {n, false}}), do: {pos, {n, false}}

  def print(pos_map) do
    matrix = for y <- 0..9, do: for(x <- 0..9, do: pos_map[{x, y}] |> elem(0))

    Enum.map(matrix, fn row ->
      row |> Enum.map(fn n -> Integer.to_string(n) end) |> Enum.join() |> IO.inspect()
    end)
  end

  def increase({pos, {n, f}}), do: {pos, {n + 1, f}}

  def step(pos_map, n) do
    flashed = pos_map |> Enum.map(&increase/1) |> Enum.into(%{}) |> flash_all()
    flashes = flashed |> Enum.filter(fn {_, {_, f}} -> f end) |> Enum.count()
    reset = Enum.map(flashed, &reset_flashed/1) |> Enum.into(%{})

    case n do
      100 -> flashes
      _ -> flashes + step(reset, n + 1)
    end
  end

  def part1() do
    read_input() |> create_pos_map() |> step(1)
  end

  def step2(pos_map, n) do
    flashed = pos_map |> Enum.map(&increase/1) |> Enum.into(%{}) |> flash_all()
    flashes = flashed |> Enum.filter(fn {_, {_, f}} -> f end) |> Enum.count()
    reset = Enum.map(flashed, &reset_flashed/1) |> Enum.into(%{})

    cond do
      flashes == map_size(pos_map) -> n
      true -> step2(reset, n + 1)
    end
  end

  def part2() do
    read_input() |> create_pos_map() |> step2(1)
  end
end
