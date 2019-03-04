defmodule ParseTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser

  test "parses a list of headers fields into a map" do
    # Given 
    header_lines = ["A: 1", "B: 2"]

    # When
    headers = Parser.parse_headers(header_lines)

    # Then
    assert headers == %{ "A" => "1", "B" => "2" }
  end
end
