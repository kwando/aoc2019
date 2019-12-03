defmodule AoC2019.Day3 do
  def part1() do
    line1 =
      parse_offsets(~w[R8 U5 L5 D3])
      |> line_segments({0, 0})
      |> IO.inspect(label: "segments")

    line2 =
      parse_offsets(~w[U7 R6 D4 L4])
      |> line_segments({0, 0})
      |> IO.inspect(label: "segments")

    intersections(line1, line2)
    |> IO.inspect(label: "result")
  end

  defp line_segments([], _pos), do: []

  defp line_segments([p | rest], pos) do
    new_pos = move(pos, p)
    [{pos, new_pos} | line_segments(rest, new_pos)]
  end

  defp move({x, y}, {"R", dx}), do: {x + dx, y}
  defp move({x, y}, {"L", dx}), do: {x - dx, y}
  defp move({x, y}, {"U", dy}), do: {x, y + dy}
  defp move({x, y}, {"D", dy}), do: {x, y - dy}

  defp parse_offsets([]), do: []

  defp parse_offsets([p | rest]) do
    {direction, offset} = String.split_at(p, 1)
    [{direction, String.to_integer(offset)} | parse_offsets(rest)]
  end

  defp intersections(line1, line2) do
    for l1 <- line1, l2 <- line2 do
      intersects?(l1, l2)
    end
  end

  defp vertical?({{x, _}, {x, _}}), do: true
  defp vertical?(_), do: false
  defp horizontal?({{_, y}, {_, y}}), do: true
  defp horizontal?(_), do: false

  defp intersects?(line1, line2) do
    can_cross = horizontal?(line1) |> xor(horizontal?(line2))

    if can_cross do
      {:maybe, line1, line2}
    else
      false
    end
  end

  defp xor(p1, p2) do
    (p1 && p2) || (!p1 && !p2)
  end

  defp s({start_point, _end_point}), do: start_point
  defp e({_start_point, end_point}), do: end_point
  defp x({x, _}), do: x
  defp y({_, y}), do: y
end

AoC2019.Day3.part1()
