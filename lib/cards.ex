defmodule Cards do
  def create_deck(ranks, suits) do
    for r <- ranks, s <- suits, do: {r, s}
  end
end

ranks =
  [ "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A" ]

suits =
  [ "♣", "♦", "♥", "♠" ]

deck = Cards.create_deck(ranks, suits)

IO.inspect deck

IO.inspect deck |> Enum.take_random(13)
# or
IO.inspect deck |> Enum.shuffle |> Enum.take(13)

IO.inspect deck |> Enum.shuffle |> Enum.chunk_every(13)