defmodule Servy.HttpClient do

  def client() do
    someHostInNet = 'localhost' # to make it runnable on one machine
    {:ok, sock} = :gen_tcp.connect(
      someHostInNet,
      4000,
      [:binary, packet: :raw, active: false]
    )
    :ok = :gen_tcp.send(sock, create_fake_request)
    response = :gen_tcp.recv(sock, 0)
    :ok = :gen_tcp.close(sock)

    response
  end

  def create_fake_request() do
    """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
  end
end