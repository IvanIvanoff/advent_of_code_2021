defmodule AOC.Task3 do
  @moduledoc "https://adventofcode.com/2021/day/2"

  @data_file Path.join(__DIR__, "data/task3_input.txt")

  _allowed_directions = [:up, :down, :forward]

  def run_a() do
    [first_row | rest] = data()

    # All zeroes are replaced by -1 so afer summing all vectors
    # the sign can be used to determine the most common value
    summed_vector =
      Enum.reduce(rest, first_row, fn row, acc ->
        Enum.zip_with([row, acc], &Enum.sum/1)
      end)

    gamma_rate = Enum.map(summed_vector, &if(&1 > 0, do: 1, else: 0)) |> binary_list_to_dec()
    epsilon_rate = Enum.map(summed_vector, &if(&1 <= 0, do: 1, else: 0)) |> binary_list_to_dec

    gamma_rate * epsilon_rate
  end

  def run_b() do
  end

  defp binary_list_to_dec(list), do: list |> Integer.undigits(2)

  defp data() do
    File.read!(@data_file)
    |> String.split("\n")
    |> Enum.map(fn row ->
      row
      |> String.graphemes()
      |> Enum.map(fn
        "1" -> 1
        "0" -> -1
      end)
    end)
  end
end
