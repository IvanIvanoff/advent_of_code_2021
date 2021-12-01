defmodule AOC.Task1 do
  @data_file Path.join(__DIR__, "data/task1_input.txt")
  @data File.read!(@data_file)
        |> String.split("\n")
        |> Enum.map(&String.to_integer/1)

  def run_a do
    Stream.chunk_every(@data, 2, 1, :discard)
    |> Enum.count(fn [prev, next] -> next > prev end)
  end

  def run_b do
    Stream.chunk_every(@data, 3, 1, :discard)
    |> Stream.map(&Enum.sum/1)
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.count(fn [prev, next] -> next > prev end)
  end
end
