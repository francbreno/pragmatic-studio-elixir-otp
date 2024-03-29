defmodule Servy.Api.BearController do
  alias Servy.Conv
  import Servy.Conv, only: [put_resp_content_type: 2]

  def index(%Conv{} = conv) do
    json =
      Servy.Wildthings.list_bears()
      |> Poison.encode!

    conv = put_resp_content_type(conv, "application/json")

    %{ conv | status: 200, resp_body: json }
  end

  def create(%Conv{} = conv, %{ "name" => name, "type" => type }) do
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end
end