defmodule AoC2019.Day3 do
  def part1() do
    [path] = System.argv()

    [line1, line2 | _] =
      File.read!(path)
      |> String.split("\n")
      |> Enum.map(&parse_lines/1)
      |> IO.inspect(label: "input")

    intersections(line1, line2)
    |> IO.inspect(label: "intersections")
    |> Enum.map(&distance/1)
    |> Enum.min()
    |> IO.inspect(label: "part1")
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
