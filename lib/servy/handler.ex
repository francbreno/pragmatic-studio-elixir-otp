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
      |> format_response
  end

  def route(%Conv{ method: "GET", path: "/bears" } = conv) do 
    BearController.index(conv)
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

  def route(%Conv{ method: "GET", path: "/pages/" <> file_name } = conv) do
    @pages_path
    |> Path.join("#{file_name}.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: text/html\r
    Content-Length: #{byte_size(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end
