defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Wildthings
  alias Servy.Bear

  defp bear_item(bear), do: "<li>#{bear.name} - #{bear.type}</li>"

  def index(%Conv{} = conv) do
    items = 
      Wildthings.list_bears()
      |> Enum.sort(fn(b1, b2) -> Bear.order_asc_by_name(b1, b2) end)
      |> Enum.map(fn(b) -> bear_item(b) end)
      |> Enum.join

    %{ conv | status: 200, resp_body: "<il>#{items}<li>" }
  end

  def show(%Conv{} = conv, %{ "id" => id }) do
    bear = Wildthings.get_bear(id)

    %{ conv | status: 200,
              resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>" }
  end

  def create(%Conv{} = conv, %{ "type" => type, "name" => name }) do
    %{ conv | status: 201,
              resp_body: "Created a #{type} bear named #{name}!" }
  end
end