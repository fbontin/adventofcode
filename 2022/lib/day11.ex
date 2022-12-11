# To print number lists as number lists
# IEx.configure(inspect: [charlists: :as_lists])

defmodule Day11.MonkeyParser do
  alias Day11.Monkey
  defp parse_items(str), do: str |> String.split(", ") |> Enum.map(&String.to_integer/1)

  defp parse_operation(str) do
    str
    |> String.split(" ")
    |> Enum.map(fn s ->
      case s do
        "old" -> :old
        "+" -> :add
        "*" -> :multiply
        s -> String.to_integer(s)
      end
    end)
  end

  def parse(str) do
    r =
      ~r/.+(?<id>\d+):\s+.*: (?<items>.+)\s+.*= (?<operation>.+)\s+.*by (?<test>.+)\s+.*monkey (?<if_true>.+)\s+.*monkey (?<if_false>.+)/

    Regex.named_captures(r, str)
    |> Map.new(fn {k, v} -> {String.to_existing_atom(k), v} end)
    |> Map.update!(:items, &parse_items/1)
    |> Map.update!(:operation, &parse_operation/1)
    |> Map.update!(:test, &String.to_integer/1)
    |> Map.put(:n, 0)
  end
end

defmodule Day11.Monkey do
  defp get_operand(:old, item), do: item
  defp get_operand(n, _), do: n

  defp perform_operation(monkey, item) do
    [a_, op_, b_] = monkey[:operation]
    a = get_operand(a_, item)
    b = get_operand(b_, item)

    case op_ do
      :add -> a + b
      :multiply -> a * b
    end
  end

  defp take_turn(monkey, item) do
    # Uncomment this to runt part1 properly
    # |> div(3)
    worry_level = monkey |> perform_operation(item)

    case rem(worry_level, monkey[:test]) do
      0 -> {worry_level, monkey[:if_true]}
      _ -> {worry_level, monkey[:if_false]}
    end
  end

  def take_turn(monkey) do
    monkey[:items] |> Enum.map(&take_turn(monkey, &1))
  end

  def add_items(monkey, items), do: Map.update!(monkey, :items, fn i -> i ++ items end)

  def remove_items(monkey), do: Map.put(monkey, :items, [])

  def add_inspects(monkey, n), do: Map.update!(monkey, :n, &(&1 + n))

  def normalise_worry(monkey, d) do
    Map.update!(monkey, :items, fn items -> Enum.map(items, &rem(&1, d)) end)
  end
end

defmodule Day11.MonkeyMath do
  def gcd(a, 0), do: abs(a)
  def gcd(a, b), do: gcd(b, rem(a, b))
  def lcm(a, b), do: div(abs(a * b), gcd(a, b))
end

defmodule Day11 do
  alias Day11.MonkeyMath
  alias Day11.Monkey
  alias Day11.MonkeyParser

  def read_input() do
    File.read!('data/11.txt') |> String.trim()
  end

  def parse_input(str) do
    String.split(str, "\n\n")
    |> Enum.map(&MonkeyParser.parse/1)
    |> Enum.into(%{}, fn m -> {m[:id], m} end)
  end

  def take_turn(id, monkeys) do
    items =
      monkeys[id]
      |> Monkey.take_turn()
      |> Enum.group_by(fn {_i, r} -> r end, fn {i, _r} -> i end)

    nbr_inspects = items |> Map.values() |> List.flatten() |> length()

    items
    |> Enum.map(fn {r, i} -> Monkey.add_items(monkeys[r], i) end)
    |> Enum.reduce(monkeys, fn m, acc -> Map.put(acc, m[:id], m) end)
    |> Map.update!(id, &Monkey.remove_items/1)
    |> Map.update!(id, fn m -> Monkey.add_inspects(m, nbr_inspects) end)
  end

  def take_round(start_monkeys) do
    Map.keys(start_monkeys) |> Enum.reduce(start_monkeys, &take_turn/2)
  end

  def run(monkeys, 0), do: monkeys
  def run(monkeys, n), do: monkeys |> take_round() |> run(n - 1)

  def get_monkey_business(monkeys) do
    monkeys
    |> Enum.map(fn {_, m} -> m[:n] end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  def part1() do
    read_input() |> parse_input() |> run(20) |> get_monkey_business()
  end

  def normalise_worry(monkeys) do
    d = monkeys |> Enum.map(fn {_, m} -> m[:test] end) |> Enum.reduce(&MonkeyMath.lcm/2)

    monkeys
    |> Enum.map(fn {id, m} -> {id, Monkey.normalise_worry(m, d)} end)
    |> Enum.into(%{})
  end

  def run2(monkeys, 0), do: monkeys
  def run2(monkeys, n), do: monkeys |> take_round() |> normalise_worry() |> run2(n - 1)

  def part2() do
    read_input() |> parse_input() |> run2(10_000) |> get_monkey_business()
  end
end
