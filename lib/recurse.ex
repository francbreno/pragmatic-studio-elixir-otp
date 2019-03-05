defmodule Recurse do

  def map([h | t], f) do
    [f.(h) | map(t, f)]
  end

  def map([], _f), do: []
end

IO.inspect Recurse.map([1,2,3,4,5], &(&1*10))