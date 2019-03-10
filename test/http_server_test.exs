defmodule HttpServerTest do
  use ExUnit.Case
  alias Servy.HttpServer
  alias Servy.HttpClient

  @wildthings_endpoint "http://localhost:4000/wildthings"

  test "Sending a simple request" do
    # starts the server
    start_server()

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

  test "Sending a simple request using HTTPoison" do
    start_server()
    
    {:ok, response} = HTTPoison.get(@wildthings_endpoint)

    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers"
  end

  test "concurrent requests" do
    start_server()
    parent = self()
    max_concurrent_requests = 5

    for _ <- 1..max_concurrent_requests do
      spawn(fn ->
        case HTTPoison.get(@wildthings_endpoint) do
          {:ok, %HTTPoison.Response{status_code: 200} = response} ->
            send(parent, {:ok, response})
            
          {:ok, %HTTPoison.Response{body: body} = response} ->
            send(parent, {:error, "something went wrong"})

          {:error, %{reason: reason}} -> 
            send(parent, {:error, reason})
        end
      end)
    end

    for _ <- 1..max_concurrent_requests do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert response.body == "Bears, Lions, Tigers"
        _ ->
          assert false
      end
    end

  end

  defp start_server(), do: spawn(HttpServer, :start, [4000])
end