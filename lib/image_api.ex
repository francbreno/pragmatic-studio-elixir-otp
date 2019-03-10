defmodule ImageApi do
  @api_endpoint "https://api.myjson.com/bins/"

  def query(image_id) do
    "#{@api_endpoint}#{URI.encode(image_id)}" 
      |> HTTPoison.get
      |> handle
  end

  def handle({:ok, %HTTPoison.Response{ status_code: 200, body: body}}) do
    image_url = body |> parse_json |> get_image_from_body
    {:ok, image_url}
  end

  def handle({:ok, %{ status_code: status, body: body}}) do
    parsed_body = parse_json(body)
    {:error, parsed_body["message"]}
  end

  def handle({:error, %HTTPoison.Error{ reason: reason }}) do
    {:error, reason}
  end

  defp parse_json(json), do: Poison.Parser.parse!(json, %{})

  defp get_image_from_body(body), do: get_in(body, ["image", "image_url"]) 
end