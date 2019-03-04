defmodule Servy.Plugins do
  require Logger
  alias Servy.Conv

  def rewrite_path(%Conv{ path: "/wildlife" } = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def prettify_url(%Conv{ path: path } = conv) do
    regex = ~r{\/(?<resource>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path) 
    prettify_path_captures(conv, captures)
  end

  def prettify_url(%Conv{} = conv), do: conv

  defp prettify_path_captures(%Conv{} = conv, %{ "resource" => resource, "id" => id }) do
    %{ conv | path: "/#{resource}/#{id}" }
  end

  defp prettify_path_captures(%Conv{} = conv, _), do: conv

  @doc "Logs 404 requests"
  def track(%Conv{ status: 404, path: path } = conv) do
    if Mix.env != :test do
      IO.puts("Warning: #{path} is on the loose!")
    end
    conv
  end

  def track(%Conv{} = conv), do: conv

  def emojify(%Conv{ status: 200, resp_body: resp_body } = conv) do
    emoji ="😜"
    
    emojified_body =
      resp_body
      |> String.replace_prefix("", emoji)
      |> String.replace_suffix("", emoji)

    %{ conv | resp_body: emojified_body }
  end

  def emojify(%Conv{} = conv), do: conv

  def log(%Conv{} = conv, :dev) do 
    conv |> inspect |> Logger.info
    conv
  end

  def log(%Conv{} = conv, _), do: conv 
end