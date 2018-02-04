defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "parse" do
    assert Calc.parse("(2 + 3)") == ["(", 2, "+", 3, ")"]
  end

  test "sanitizer" do
    assert Calc.sanitizer(["(", "2", "+", "3", ")"]) == ["(", 2, "+", 3, ")"]
  end

  test "build_q" do
    assert Calc.build_q(["(", "(", 15, "/", "(", 7, "-", "(", 1,
                         "+", 1, ")" ,")", ")", "*", 3,")", "-", 
                         "(", 2, "+", "(", 1, "+", 1, ")", ")"], [], []) == [15, 7, 1, 1, "+", "-", "/", 3, "*", 2, 1, 1, "+", "+", "-"]
  end

  test "eval" do
    assert Calc.eval([15, 7, 1, 1, "+", "-", "/", 3, "*", 2, 1, 1, "+", "+", "-"], []) == 5
  end
end
