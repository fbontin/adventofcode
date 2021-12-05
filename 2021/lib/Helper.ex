defmodule Helper do
  @moduledoc """
  Helper functions like for parsing and stuff
  """
  def to_rows(input) do
    input |> String.split("\n", trim: true)
  end

  def read_input(field_name) do
    IO.getn(field_name, 1_000_000)
    |> to_rows()
  end
end
