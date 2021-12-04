defmodule Day4 do
  def read_input() do
    File.read!('data/04.txt') |> String.split("\n", trim: true)
  end

  def parse_input() do
    [numbers_input | board_input] = read_input()

    numbers =
      numbers_input
      |> String.split(",")
      |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end)

    boards =
      board_input
      |> Enum.map(fn row ->
        row
        |> String.trim()
        |> String.split(~r/\s+/)
        |> Enum.map(fn n -> {Integer.parse(n) |> elem(0), false} end)
      end)
      |> Enum.chunk_every(5)

    {numbers, boards}
  end

  def mark_element({num, _}, n) when n == num, do: {num, true}
  def mark_element(el, _), do: el

  def mark_board(board, n) do
    board |> Enum.map(fn row -> Enum.map(row, &mark_element(&1, n)) end)
  end

  def row_checked?(row) do
    row |> Enum.map(fn {_, checked} -> checked end) |> Enum.all?()
  end

  def row_win?(board) do
    row_win = board |> Enum.filter(&row_checked?/1) |> Enum.any?()

    if row_win, do: board, else: nil
  end

  def dirty_transpose([r1 | [r2 | [r3 | [r4 | [r5 | []]]]]]) do
    [
      [Enum.at(r1, 0), Enum.at(r2, 0), Enum.at(r3, 0), Enum.at(r4, 0), Enum.at(r5, 0)],
      [Enum.at(r1, 1), Enum.at(r2, 1), Enum.at(r3, 1), Enum.at(r4, 1), Enum.at(r5, 1)],
      [Enum.at(r1, 2), Enum.at(r2, 2), Enum.at(r3, 2), Enum.at(r4, 2), Enum.at(r5, 2)],
      [Enum.at(r1, 3), Enum.at(r2, 3), Enum.at(r3, 3), Enum.at(r4, 3), Enum.at(r5, 3)],
      [Enum.at(r1, 4), Enum.at(r2, 4), Enum.at(r3, 4), Enum.at(r4, 4), Enum.at(r5, 4)]
    ]
  end

  def col_win?(board), do: board |> dirty_transpose() |> row_win?()

  def check_win(boards) do
    row_win = boards |> Enum.map(&row_win?/1) |> Enum.find(fn b -> b end)
    col_win = boards |> Enum.map(&col_win?/1) |> Enum.find(fn b -> b end)

    cond do
      row_win -> row_win
      col_win -> col_win
      true -> nil
    end
  end

  def draw([n | numbers], boards) do
    new_boards = Enum.map(boards, &mark_board(&1, n))
    winning_board = check_win(new_boards)

    cond do
      winning_board -> {winning_board, n}
      true -> draw(numbers, new_boards)
    end
  end

  def board_sum(board) do
    board
    |> List.flatten()
    |> Enum.filter(fn {_, checked} -> not checked end)
    |> Enum.map(fn {n, _} -> n end)
    |> Enum.sum()
  end

  def part1() do
    {numbers, boards} = parse_input()
    {wb, n} = draw(numbers, boards)
    sum = board_sum(wb)
    {wb, sum, n, n * sum}
  end

  def winner?(board) do
    cond do
      row_win?(board) -> true
      col_win?(board) -> true
      true -> false
    end
  end

  def remove_winners(boards) do
    boards |> Enum.filter(fn b -> not winner?(b) end)
  end

  def draw2([n | numbers], boards) do
    new_boards = Enum.map(boards, &mark_board(&1, n))
    boards_without_winners = remove_winners(new_boards)

    cond do
      length(boards_without_winners) == 1 -> draw(numbers, boards_without_winners)
      true -> draw2(numbers, new_boards)
    end
  end

  def part2() do
    {numbers, boards} = parse_input()
    {wb, n} = draw2(numbers, boards)
    sum = board_sum(wb)
    {wb, sum, n, n * sum}
  end
end
