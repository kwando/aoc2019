defmodule AoC2019.Day2 do
  def new_memory(), do: %{}

  def write(mem, pos, value) do
    Map.put(mem, pos, value)
  end

  def read(mem, pos) do
    Map.fetch!(mem, pos)
  end

  def load_ref(mem, pos) do
    read(mem, read(mem, pos))
  end

  def run_program(compiled_program, noun, verb) do
    memory =
      compiled_program
      |> write(1, noun)
      |> write(2, verb)

    execute(memory, 0)
    |> Map.get(0)
  end

  def compile_program(instructions) do
    instructions
    |> Enum.with_index()
    |> Enum.reduce(new_memory(), fn {op, addr}, mem -> mem |> write(addr, op) end)
  end

  def execute(memory, pc) do
    op = memory[pc]

    case op do
      1 ->
        v1 = load_ref(memory, pc + 1)
        v2 = load_ref(memory, pc + 2)
        p3 = read(memory, pc + 3)

        memory
        |> write(p3, v1 + v2)
        |> execute(pc + 4)

      2 ->
        v1 = load_ref(memory, pc + 1)
        v2 = load_ref(memory, pc + 2)
        p3 = read(memory, pc + 3)

        memory
        |> write(p3, v1 * v2)
        |> execute(pc + 4)

      99 ->
        memory
    end
  end
end

example1 = []

input = [
  1,
  0,
  0,
  3,
  1,
  1,
  2,
  3,
  1,
  3,
  4,
  3,
  1,
  5,
  0,
  3,
  2,
  1,
  10,
  19,
  1,
  19,
  5,
  23,
  2,
  23,
  6,
  27,
  1,
  27,
  5,
  31,
  2,
  6,
  31,
  35,
  1,
  5,
  35,
  39,
  2,
  39,
  9,
  43,
  1,
  43,
  5,
  47,
  1,
  10,
  47,
  51,
  1,
  51,
  6,
  55,
  1,
  55,
  10,
  59,
  1,
  59,
  6,
  63,
  2,
  13,
  63,
  67,
  1,
  9,
  67,
  71,
  2,
  6,
  71,
  75,
  1,
  5,
  75,
  79,
  1,
  9,
  79,
  83,
  2,
  6,
  83,
  87,
  1,
  5,
  87,
  91,
  2,
  6,
  91,
  95,
  2,
  95,
  9,
  99,
  1,
  99,
  6,
  103,
  1,
  103,
  13,
  107,
  2,
  13,
  107,
  111,
  2,
  111,
  10,
  115,
  1,
  115,
  6,
  119,
  1,
  6,
  119,
  123,
  2,
  6,
  123,
  127,
  1,
  127,
  5,
  131,
  2,
  131,
  6,
  135,
  1,
  135,
  2,
  139,
  1,
  139,
  9,
  0,
  99,
  2,
  14,
  0,
  0
]

defmodule Searcher do
  def search(input, target, noun, verb) do
    space = for i <- 0..99, j <- 0..99, do: {i, j}
    program = AoC2019.Day2.compile_program(input)

    {duration, {noun, verb}} =
      :timer.tc(fn ->
        Enum.find(space, fn {n, v} ->
          try do
            19_690_720 === AoC2019.Day2.run_program(program, n, v)
          rescue
            _ -> false
          end
        end)
      end)

    {duration / 1000, noun * 100 + verb}
  end
end

Searcher.search(input, 19_690_720, 0, 0)
|> IO.inspect(label: "part2")
