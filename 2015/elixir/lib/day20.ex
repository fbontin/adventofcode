defmodule Day20 do
  def read_input(), do: 29_000_000

  def get_divisors(n) do
    sqrt = :math.sqrt(n) |> :math.ceil() |> trunc()

    for(i when rem(n, i) == 0 <- 1..sqrt, do: i)
    |> Enum.flat_map(fn d -> [d, div(n, d)] end)
    |> Enum.uniq()
  end

  def get_presents(n), do: (n |> get_divisors() |> Enum.sum()) * 10
  def run(n), do: if(get_presents(n) >= read_input(), do: n, else: run(n + 1))
  def part1(), do: run(1)

  def get_presents2(n),
    do: (for(d when div(n, d) <= 50 <- get_divisors(n), do: d) |> Enum.sum()) * 11

  def run2(n), do: if(get_presents2(n) >= read_input(), do: n, else: run2(n + 1))
  def part2(), do: run2(1)
end
