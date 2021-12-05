defmodule AOC.Task3 do
  @moduledoc "https://adventofcode.com/2021/day/3"

  @data_file Path.join(__DIR__, "data/task3_input.txt")
  _allowed_directions = [:up, :down, :forward]

  def run_a() do
    [first_row | rest] = data()
    count = length(rest) + 1
    half_count = div(count, 2)

    summed_vector =
      Enum.reduce(rest, first_row, fn row, acc ->
        Enum.zip_with([row, acc], &Enum.sum/1)
      end)

    # If the value is is over half the total, then the 1s are seen more than the zeros
    gamma_rate_vector = Enum.map(summed_vector, &if(&1 >= half_count, do: 1, else: 0))
    epsilon_rate_vector = inverse_list(gamma_rate_vector)

    gamma_rate = gamma_rate_vector |> binary_list_to_dec()
    epsilon_rate = epsilon_rate_vector |> binary_list_to_dec()

    %{
      gamma_rate_vector: gamma_rate_vector,
      epsilon_rate_vector: epsilon_rate_vector,
      gamma_rate: gamma_rate,
      epsilon_rate: epsilon_rate,
      power_consumption: gamma_rate * epsilon_rate
    }
  end

  def run_b() do
    oxygen_generator_rating_vector = most_common()

    oxygen_generator_rating =
      longest_common_prefix(oxygen_generator_rating_vector) |> binary_list_to_dec()

    co2_scrubber_rating_vector = least_common()

    co2_scrubber_rating =
      longest_common_prefix(co2_scrubber_rating_vector) |> binary_list_to_dec()

    %{
      oxygen_generator_rating_vector: oxygen_generator_rating_vector,
      co2_scrubber_rating_vector: co2_scrubber_rating_vector,
      oxygen_generator_rating: oxygen_generator_rating,
      co2_scrubber_rating: co2_scrubber_rating,
      life_support_rating: oxygen_generator_rating * co2_scrubber_rating
    }
  end

  defp longest_common_prefix(list) do
    indexed_list = Enum.with_index(list)

    result =
      Enum.reduce_while(indexed_list, data(), fn {val, pos}, acc ->
        case acc do
          [elem] -> {:halt, elem}
          _ -> {:cont, Enum.filter(acc, &(Enum.at(&1, pos) == val))}
        end
      end)

    case result do
      [elem] when is_list(elem) -> elem
      elem -> elem
    end
  end

  defp most_common() do
    data = data()
    length = length(hd(data))

    Enum.reduce(0..(length - 1), {data, []}, fn pos, {data, acc} ->
      ones = Enum.count(data, &(Enum.at(&1, pos) == 1))
      zeros = length(data) - ones

      cond do
        ones >= zeros ->
          {Enum.filter(data, &(Enum.at(&1, pos) == 1)), acc ++ [1]}

        ones < zeros ->
          {Enum.filter(data, &(Enum.at(&1, pos) == 0)), acc ++ [0]}
      end
    end)
    |> elem(1)
  end

  defp least_common() do
    data = data()
    length = length(hd(data))

    Enum.reduce(0..(length - 1), {data, []}, fn pos, {data, acc} ->
      ones = Enum.count(data, &(Enum.at(&1, pos) == 1))
      zeros = length(data) - ones

      cond do
        ones >= zeros ->
          {Enum.filter(data, &(Enum.at(&1, pos) == 0)), acc ++ [0]}

        ones < zeros ->
          {Enum.filter(data, &(Enum.at(&1, pos) == 1)), acc ++ [1]}
      end
    end)
    |> elem(1)
  end

  defp binary_list_to_dec(list), do: list |> Integer.undigits(2)

  defp inverse_list(list), do: Enum.map(list, &(1 - &1))

  defp data() do
    File.read!(@data_file)
    |> String.split("\n")
    |> Enum.map(fn row ->
      row
      |> String.graphemes()
      |> Enum.map(fn
        "1" -> 1
        "0" -> 0
      end)
    end)
  end
end
