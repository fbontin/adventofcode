defmodule Day21 do
  def boss(), do: {103, 9, 2}

  def weapons(),
    do: [{8, 4, 0}, {10, 5, 0}, {25, 6, 0}, {40, 7, 0}, {74, 8, 0}]

  def armor(),
    do: [{13, 0, 1}, {31, 0, 2}, {53, 0, 3}, {75, 0, 4}, {102, 0, 5}]

  def rings(),
    do: [{25, 1, 0}, {50, 2, 0}, {100, 3, 0}, {20, 0, 1}, {40, 0, 2}, {80, 0, 3}]

  def equipment_combinations() do
    wa_combs = for(w <- weapons(), a <- armor(), do: [w, a]) ++ weapons()

    ring_combs =
      for(r1 <- rings(), r2 <- rings(), do: [r1, r2])
      |> Enum.reject(fn [r1, r2] -> r1 == r2 end)
      |> Enum.concat(rings())

    for(wa <- wa_combs, rs <- ring_combs, do: List.wrap(wa) ++ List.wrap(rs)) ++
      wa_combs ++ ring_combs
  end

  def sum_combination(comb) do
    comb
    |> List.wrap()
    |> Enum.reduce(fn {c1, d1, a1}, {c2, d2, a2} -> {c1 + c2, d1 + d2, a1 + a2} end)
  end

  def hit({_, d1, _}, {hp, d2, a}), do: {hp - max(d1 - a, 1), d2, a}

  def play(comb), do: play(comb, boss(), :player)

  def play(player, boss, current_turn) do
    {p_hp, _, _} = player
    {b_hp, _, _} = boss

    cond do
      p_hp <= 0 -> false
      b_hp <= 0 -> true
      current_turn == :player -> play(player, hit(player, boss), :boss)
      current_turn == :boss -> play(hit(boss, player), boss, :player)
    end
  end

  def part1() do
    equipment_combinations()
    |> Enum.map(&sum_combination/1)
    |> Enum.filter(fn {_, d, a} -> play({100, d, a}) end)
    |> Enum.map(fn {g, _, _} -> g end)
    |> Enum.min()
  end

  def part2() do
    equipment_combinations()
    |> Enum.map(&sum_combination/1)
    |> Enum.reject(fn {_, d, a} -> play({100, d, a}) end)
    |> Enum.map(fn {g, _, _} -> g end)
    |> Enum.max()
  end
end
