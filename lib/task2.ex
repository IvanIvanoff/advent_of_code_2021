defmodule AOC.Task2 do
  @moduledoc "https://adventofcode.com/2021/day/2"

  @data_file Path.join(__DIR__, "data/task2_input.txt")

  _allowed_directions = [:up, :down, :forward]

  def run_a() do
    {x, y} =
      Enum.reduce(data(), {0, 0}, fn
        {:forward, step}, {x, y} -> {x + step, y}
        {:up, step}, {x, y} -> {x, y - step}
        {:down, step}, {x, y} -> {x, y + step}
      end)

    %{pos: x, depth: y, x_times_y: x * y}
  end

  def run_b() do
    {x, y, _aim} =
      Enum.reduce(data(), {0, 0, 0}, fn
        {:forward, step}, {x, y, aim} -> {x + step, y + step * aim, aim}
        {:up, step}, {x, y, aim} -> {x, y, aim - step}
        {:down, step}, {x, y, aim} -> {x, y, aim + step}
      end)

    %{pos: x, depth: y, x_times_y: x * y}
  end

  defp data() do
    File.read!(@data_file)
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [direction, number] ->
      {String.to_existing_atom(direction), String.to_integer(number)}
    end)
  end
end
