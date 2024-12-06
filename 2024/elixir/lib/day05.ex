defmodule Day5 do
  def read_input() do
    File.read!("data/05.txt") |> String.trim()
  end

  def parse(str, char), do: str |> String.split("\n") |> Enum.map(&String.split(&1, char))
  def parse_rules(str), do: parse(str, "|")
  def parse_updates(str), do: parse(str, ",")

  def parse_input(input) do
    [rules_string, updates_string] = input |> String.split("\n\n")
    [parse_rules(rules_string), parse_updates(updates_string)]
  end

  def get_relevant_rules(c, rules, update) do
    rules |> Enum.filter(fn [p, n] -> p == c and Enum.member?(update, n) end)
  end

  def remove_non_rule_numbers(update, rule) do
    update |> Enum.filter(&Enum.member?(rule, &1))
  end

  def is_in_right_place(c, update, rules) do
    get_relevant_rules(c, rules, update)
    |> Enum.all?(&(&1 == remove_non_rule_numbers(update, &1)))
  end

  def is_ordered_correctly(update, rules) do
    update |> Enum.all?(&is_in_right_place(&1, update, rules))
  end

  def get_middle_element(list), do: Enum.fetch!(list, length(list) |> Integer.floor_div(2))

  def sum(updates) do
    updates |> Enum.map(&get_middle_element/1) |> Enum.map(&String.to_integer/1) |> Enum.sum()
  end

  def part1() do
    [rules, updates] = read_input() |> parse_input()

    updates
    |> Enum.filter(&is_ordered_correctly(&1, rules))
    |> sum()
  end

  def rules_to_rule_map(rules) do
    rules
    |> Enum.reduce(%{}, fn [p, n], map -> Map.update(map, p, [n], &[n | &1]) end)
  end

  def part2() do
    [rules, updates] = read_input() |> parse_input()
    rule_map = rules_to_rule_map(rules)

    updates
    |> Enum.reject(&is_ordered_correctly(&1, rules))
    |> Enum.map(&Enum.sort(&1, fn a, b -> b in (rule_map |> Map.get(a, [])) end))
    |> sum()
  end
end
