defmodule AoC2019.Day1 do
  def part1() do
    stream_input()
    |> Stream.map(&fuel/1)
    |> Enum.sum()
    |> IO.inspect(label: "part1")
  end

  def part2() do
    stream_input()
    |> Stream.map(&total_fuel/1)
    |> Enum.sum()
    |> IO.inspect(label: "part2")
  end

  def fuel(weight) do
    div(weight, 3) - 2
  end

  def total_fuel(weight) do
    case max(0, fuel(weight)) do
      0 ->
        0

      needed ->
        needed + total_fuel(needed)
    end
  end

  defp to_integer(input) do
    input
    |> String.trim()
    |> String.to_integer()
  end

  defp stream_input() do
    File.stream!("input.txt", trim: true)
    |> Stream.map(&to_integer/1)
  end
end

# AoC2019.Day1.part1()
AoC2019.Day1.total_fuel(1969)
|> IO.inspect(label: "result")

AoC2019.Day1.part2()
|> IO.inspect(label: "result")
