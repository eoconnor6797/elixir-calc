defmodule Calc do 

  def parse(line) do
    line
    |> String.replace("(","( ") 
    |> String.replace(")"," )")
    |> String.split()
    |> sanitizer
  end

  @precedence %{"+" => 1, "-" => 1, "*" => 2, "/" => "2",}

  def build_q([], output, ops) do
    move_ops(output, ops)
  end

  def build_q(list, output, ops) when is_number(hd(list)) do
    build_q(tl(list), output ++ [hd(list)], ops)
  end

  def build_q(list, output, []) when is_binary(hd(list)) do
    build_q(tl(list), output, [hd(list)] ++ [])
  end

  def build_q(list, output, ops) when is_binary(hd(list))  do
    h = hd(ops)
    hl = hd(list)
    if hl == "(" do      
      build_q(tl(list), output, [hl] ++ ops)
    else if hl == ")" and h != "(" do
      build_q(list, output ++ [h], tl(ops))
    else if hl == ")" and h == "(" do
      build_q(tl(list), output, tl(ops))
    else if h != "(" and @precedence[h] > @precedence[hl] do
      build_q(list, output ++ [h], tl(ops))
    else
      #if @precedence[h] < @precedence[hl] do
      build_q(tl(list), output, [hl] ++ ops)
      # end
    end
    end
    end
    end
  end

  def eval(queue, stack) when is_number(hd(queue)) do
    eval(tl(queue), [hd(queue)] ++ stack)
  end

  def eval([], stack) do
    {x, _} = List.pop_at(stack, 0)
    x
  end

  def eval(queue, stack) when is_binary(hd(queue)) do
    op = hd(queue)
    {x1, y1} = List.pop_at(stack, 0)
    {x2, y2} = List.pop_at(y1, 0)
    case op do
      "*" -> eval(tl(queue), [x2 * x1] ++ y2)
      "+" -> eval(tl(queue), [x2 + x1] ++ y2)
      "/" -> eval(tl(queue), [div(x2, x1)] ++ y2)
      "-" -> eval(tl(queue), [x2 - x1] ++ y2)
        end
  end
    
  defp move_ops(output, []) do
    output
  end

  defp move_ops(output, ops) do
    move_ops(output ++ [hd(ops)], tl(ops))
  end

  defp sanitize(t) do
    case Integer.parse(t) do
      :error -> t
      {number, _} -> number
    end
  end

  def sanitizer(list) do
    Enum.map(list, &sanitize/1)
  end

  def main() do
    x = IO.gets("> ")
    x
    |> parse
    |> build_q([],[])
    |> eval([])
    |> IO.puts
    main()
  end

end
