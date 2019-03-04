defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Wildthings
  alias Servy.Bear

  defp bear_item(bear), do: "<li>#{bear.name} - #{bear.type}</li>"

  def index(%Conv{} = conv) do
    items = 
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(&bear_item/2)
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