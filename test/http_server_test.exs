defmodule HttpServerTest do
  use ExUnit.Case
  alias Servy.HttpServer
  alias Servy.HttpClient

  test "Sending a simple request" do
    # starts the server
    spawn(HttpServer, :start, [4000])

    # the request to send
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    # send a request with the HTTP client
    response = HttpClient.send(request, 4000)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 20\r
    \r
    Bears, Lions, Tigers
    """
  end
end