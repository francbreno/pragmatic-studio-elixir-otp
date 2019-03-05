defmodule Servy.Wildthings do
  alias Servy.Bear

  def list_bears do
    Path.expand("../../db", __DIR__)
      |> Path.join("bears.json")
      |> File.read
      |> handle_file
      |> Poison.decode!(as: %{ "bears" => [%Bear{}]})
      |> Map.get("bears")
  end

  defp handle_file({:ok, content}), do: content
  defp handle_file({:error, _}), do: "[]"

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears, fn(b) -> b.id == id end)
  end
  
  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end
end