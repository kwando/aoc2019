defmodule AoC2019.Day3 do
  def part1() do
    [path] = System.argv()

    [line1, line2 | _] =
      File.read!(path)
      |> String.split("\n")
      |> Enum.map(&parse_lines/1)

    intersections(line1, line2)
    |> Enum.map(&distance/1)
    |> Enum.min()
    |> IO.inspect(label: "part1")
  end

  def part2() do
    [path] = System.argv()

    [line1, line2 | _] =
      File.read!(path)
      |> String.split("\n")
      |> Enum.map(&parse_instructions/1)

    calc(line1, line2)
    |> MapSet.new()
    |> MapSet.intersection(calc(line2, line1) |> MapSet.new())
    |> Enum.sort()
    |> IO.inspect()
  end

  defp calc(line1, line2) do
    %{}
    |> paint_map({0, 0}, 0, line2, fn cost, new_cost -> min(cost, new_cost) end)
    |> paint_map({0, 0}, 0, line1, fn cost, new_cost -> {:intersect, cost + new_cost} end)
    |> Map.delete({0, 0})
    |> Enum.filter(&match?({_, {:intersect, n}}, &1))
    |> Enum.map(fn {key, value} -> {value, key} end)
    |> Enum.sort()
    |> IO.inspect(label: "part2")
  end

  defp paint_map(map, _, _, [], fun), do: map

  defp paint_map(map, pos, cost, [{_, 0} | rest], fun), do: paint_map(map, pos, cost, rest, fun)

  defp paint_map(map, pos, cost, [{dir, n} | rest], fun) do
    map
    |> Map.update(pos, cost, fn old_cost -> fun.(old_cost, cost) end)
    |> paint_map(translate(pos, dir), cost + 1, [{dir, n - 1} | rest], fun)
  end

  defp translate({x, y}, {dx, dy}) do
    {x + dx, y + dy}
  end

  def parse_instructions(line) do
    line
    |> String.split(",")
    |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction(input) do
    {dir, amount} = String.split_at(input, 1)
    amount = String.to_integer(amount)

    case dir do
      "D" -> {{0, -1}, amount}
      "U" -> {{0, 1}, amount}
      "L" -> {{-1, 0}, amount}
      "R" -> {{1, 0}, amount}
    end
  end

  defp parse_lines(input) do
    input
    |> String.split(",")
    |> parse_offsets()
    |> line_segments({0, 0})
  end

  defp line_segments([], _pos), do: []

  defp line_segments([p | rest], pos) do
    new_pos = move(pos, p)
    [line_segment(pos, new_pos) | line_segments(rest, new_pos)]
  end

  defp move({x, y}, {"R", dx}), do: {x + dx, y}
  defp move({x, y}, {"L", dx}), do: {x - dx, y}
  defp move({x, y}, {"U", dy}), do: {x, y + dy}
  defp move({x, y}, {"D", dy}), do: {x, y - dy}

  defp line_segment({x, y}, {u, y}) when x > u, do: {{u, y}, {x, y}}
  defp line_segment({x, y}, {x, v}) when y > v, do: {{x, v}, {x, y}}
  defp line_segment(p1, p2), do: {p1, p2}

  defp parse_offsets([]), do: []

  defp parse_offsets([p | rest]) do
    {direction, offset} = String.split_at(p, 1)
    [{direction, String.to_integer(offset)} | parse_offsets(rest)]
  end

  defp intersections(line1, line2) do
    for(l1 <- line1, l2 <- line2, do: {l1, l2})
    |> Enum.map(fn {l1, l2} -> intersection(l1, l2) end)
    |> Enum.reject(fn
      {0, 0} -> true
      :no_intersection -> true
      _ -> false
    end)
  end

  defp distance({x, y}), do: abs(x) + abs(y)

  defp intersection({{x1, y1}, {x2, y1}}, {{x3, y3}, {x3, y4}})
       when x3 >= x1 and x3 <= x2 and y1 >= y3 and y1 <= y4 do
    {x3, y1}
  end

  defp intersection({{x1, y1}, {x1, y2}}, {{x3, y3}, {x4, y3}})
       when y3 >= y1 and y3 <= y2 and x1 >= x3 and x1 <= x4 do
    {x1, y3}
  end

  defp intersection(_, _), do: :no_intersection
end

AoC2019.Day3.part1()
AoC2019.Day3.part2()
