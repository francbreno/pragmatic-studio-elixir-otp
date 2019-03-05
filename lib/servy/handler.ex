defmodule Servy.Handler do
  @moduledoc "Handle HTTP requests."

  alias Servy.Conv
  alias Servy.BearController

  import Servy.Plugins, only: [
    rewrite_path: 1, 
    prettify_url: 1, 
    track: 1, 
    emojify: 1, 
    log: 2
  ]

  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2] 
  import Servy.Conv, only: [put_content_length: 1]

  @pages_path Path.expand("../../pages", __DIR__)

  @doc "Transforms the request into a response"
  def handle(request) do
    request
      |> parse
      |> log(Mix.env)
      |> rewrite_path
      |> prettify_url
      |> route
      |> track
      # |> emojify
      |> put_content_length
      |> format_response
  end

  def route(%Conv{ method: "GET", path: "/bears" } = conv) do 
    BearController.index(conv)
  end

  def route(%Conv{ method: "GET", path: "/api/bears" } = conv) do 
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{ method: "POST", path: "/api/bears", params: params } = conv) do 
    Servy.Api.BearController.create(conv, params)
  end

  def route(%Conv{ method: "GET", path: "/bears/new" } = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{ method: "POST", path: "/bears", params: params } = conv) do
    BearController.create(conv, params)
  end

  def route(%Conv{ method: "GET", path: "/bears/" <> id } = conv) do 
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{ method: "DELETE", path: "/bears/" <> id } = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.remove(conv, params)
  end

  def route(%Conv{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{ method: "GET", path: "/about" } = conv) do
    Path.expand("../../pages", __DIR__)
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/faq"} = conv) do
    @pages_path
    |> Path.join("faq.md")
    |> File.read
    |> handle_file(conv)
    |> markdown_to_html
  end
  
  def markdown_to_html(%Conv{ status: 200 } = conv) do
    %{ conv | resp_body: Earmark.as_html!(conv.resp_body) }
  end
  
  def markdown_to_html(%Conv{} = conv), do: conv

  def route(%Conv{ method: "GET", path: "/pages/" <> file_name } = conv) do
    @pages_path
    |> Path.join("#{file_name}.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def format_response(%Conv{ resp_body: resp_body, resp_headers: resp_headers } = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{resp_headers["Content-Type"]}\r
    Content-Length: #{resp_headers["Content-Length"]}\r
    \r
    #{resp_body}
    """
  end

end
