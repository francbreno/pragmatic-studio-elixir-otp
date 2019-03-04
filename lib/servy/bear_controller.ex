defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.BearView

  @templates_path Path.expand("../../templates", __DIR__)

  def index(%Conv{} = conv) do
    bears = 
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    %{ conv | status: 200, resp_body: BearView.index(bears) }
  end

  def show(%Conv{} = conv, %{ "id" => id }) do
    bear = Wildthings.get_bear(id)

    %{ conv | status: 200, resp_body: BearView.show(bear) }
  end

  def create(%Conv{} = conv, %{ "type" => type, "name" => name }) do
    %{ conv | status: 201,
              resp_body: "Created a #{type} bear named #{name}!" }
  end

  def remove(%{} = conv, %{ "id" => id }) do
    %{ conv | status: 204, resp_body: "" }
  end
end