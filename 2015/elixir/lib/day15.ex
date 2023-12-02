defmodule Day15 do
  def read_input() do
    # Manually parsed :-)
    [
      %{name: :spr, capacity: 2, durability: 0, flavor: -2, texture: 0, calories: 3},
      %{name: :but, capacity: 0, durability: 5, flavor: -3, texture: 0, calories: 3},
      %{name: :cho, capacity: 0, durability: 0, flavor: 5, texture: -1, calories: 8},
      %{name: :can, capacity: 0, durability: -1, flavor: 0, texture: 5, calories: 8}
    ]
  end

  def get_quadruples do
    for a <- 0..100,
        b <- 0..(100 - a),
        c <- 0..(100 - a - b),
        d <- 0..(100 - a - b - c),
        a + b + c + d == 100 do
      {a, b, c, d}
    end
  end

  def quadruple_to_recipe({spr, but, cho, can}), do: %{spr: spr, but: but, cho: cho, can: can}

  def sum(a, i) do
    %{
      name: i.name,
      capacity: a * i.capacity,
      durability: a * i.durability,
      flavor: a * i.flavor,
      texture: a * i.texture,
      calories: a * i.calories
    }
  end

  def sum_ingrs(ingrs, property) do
    ingrs |> Enum.map(fn i -> i[property] end) |> Enum.sum() |> max(0)
  end

  def calc(recipe, ingredients) do
    all =
      [:spr, :but, :cho, :can]
      |> Enum.map(fn name ->
        sum(recipe[name], ingredients |> Enum.find(&(&1.name == name)))
      end)

    res = %{
      recipe: recipe,
      capacity: all |> sum_ingrs(:capacity),
      durability: all |> sum_ingrs(:durability),
      flavor: all |> sum_ingrs(:flavor),
      texture: all |> sum_ingrs(:texture),
      calories: all |> sum_ingrs(:calories)
    }

    {res, [res.capacity, res.durability, res.flavor, res.texture] |> Enum.product()}
  end

  def part1() do
    ingredients = read_input()

    get_quadruples()
    |> Enum.map(&quadruple_to_recipe/1)
    |> Enum.map(&calc(&1, ingredients))
    |> Enum.max_by(fn {_, p} -> p end)
  end

  def part2() do
    ingredients = read_input()

    get_quadruples()
    |> Enum.map(&quadruple_to_recipe/1)
    |> Enum.map(&calc(&1, ingredients))
    |> Enum.filter(fn {r, _} -> r.calories <= 500 end)
    |> Enum.max_by(fn {_, p} -> p end)
  end
end
