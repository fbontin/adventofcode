defmodule Day15 do
  def read_input() do
    File.read!('data/15.txt')
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> String.split(l, "", trim: true) end)
  end

  def get_goal(rows), do: {length(rows) - 1, length(List.first(rows)) - 1}

  def create_pos_map(rows) do
    y_len = length(rows)
    x_len = length(List.first(rows))

    matrix = for y <- 0..(y_len - 1), do: for(x <- 0..(x_len - 1), do: {x, y})

    matrix
    |> Enum.flat_map(fn p -> p end)
    |> Enum.map(fn {x, y} -> {{x, y}, Enum.at(rows, y) |> Enum.at(x) |> String.to_integer()} end)
    |> Enum.into(%{})
  end

  def get_neighbors({x, y}, pos_map),
    do:
      [{x - 1, y}, {x, y - 1}, {x + 1, y}, {x, y + 1}]
      |> Enum.filter(fn nb -> pos_map[nb] != nil end)

  def merge_maps(maps), do: Enum.reduce(maps, fn acc, map -> Map.merge(map, acc) end)

  def get_graph_for_pos(pos, pos_map) do
    get_neighbors(pos, pos_map)
    |> Enum.map(fn nb -> %{{pos, nb} => pos_map[nb]} end)
    |> merge_maps()
  end

  def pos_map_to_starter_nodes(pos_map) do
    pos_map
    |> Enum.map(fn {pos, _} -> %{pos => :infinity} end)
    |> Enum.concat([%{{0, 0} => 0}])
    |> merge_maps()
  end

  def pos_map_to_graph(pos_map) do
    pos_map
    |> Enum.map(fn {pos, _} -> get_graph_for_pos(pos, pos_map) end)
    |> merge_maps()
  end

  def visit(pos, unvisited, nodes, vertices, pos_map) do
    updated_nodes =
      get_neighbors(pos, pos_map)
      |> Enum.map(fn nb -> {nb, nodes[pos] + vertices[{pos, nb}]} end)
      |> Enum.reduce(nodes, fn {nb, w}, acc ->
        Map.update(acc, nb, w, fn old_w -> min(old_w, w) end)
      end)

    {MapSet.delete(unvisited, pos), updated_nodes}
  end

  def find_smallest_distance(unvisited, nodes) do
    unvisited
    |> Enum.sort(fn p1, p2 -> nodes[p1] < nodes[p2] end)
    |> List.first()
  end

  def traversal_finished?(goal, unvisited, nodes) do
    not MapSet.member?(unvisited, goal) or
      find_smallest_distance(unvisited, nodes) == :infinity
  end

  def traverse(pos, unvisited, nodes, vertices, pos_map, goal) do
    {updated_unvisited, updated_nodes} = visit(pos, unvisited, nodes, vertices, pos_map)

    if traversal_finished?(goal, updated_unvisited, updated_nodes) do
      updated_nodes
    else
      new_pos = find_smallest_distance(updated_unvisited, updated_nodes)
      traverse(new_pos, updated_unvisited, updated_nodes, vertices, pos_map, goal)
    end
  end

  def part1() do
    rows = read_input()
    goal = get_goal(rows)
    pos_map = rows |> create_pos_map()
    unvisited = pos_map |> Enum.map(fn {pos, _} -> pos end) |> MapSet.new()
    nodes = pos_map_to_starter_nodes(pos_map)
    vertices = pos_map |> pos_map_to_graph()

    final_nodes = traverse({0, 0}, unvisited, nodes, vertices, pos_map, goal)
    final_nodes[goal]
  end

  def part2() do
    read_input()
  end
end
