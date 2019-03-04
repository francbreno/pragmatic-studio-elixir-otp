defmodule Servy.Plugins do
  require Logger

  def rewrite_path(%{ path: "/wildlife" } = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(conv), do: conv

  def prettify_url(%{ path: path } = conv) do
    regex = ~r{\/(?<resource>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path) 
    prettify_path_captures(conv, captures)
  end

  def prettify_url(conv), do: conv

  defp prettify_path_captures(conv, %{ "resource" => resource, "id" => id }) do
    %{ conv | path: "/#{resource}/#{id}" }
  end

  defp prettify_path_captures(conv, _), do: conv

  @doc "Logs 404 requests"
  def track(%{ status: 404, path: path } = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  def track(conv), do: conv

  def emojify(%{ status: 200, resp_body: resp_body } = conv) do
    emoji ="😜"
    
    emojified_body =
      resp_body
      |> String.replace_prefix("", emoji)
      |> String.replace_suffix("", emoji)

    %{ conv | resp_body: emojified_body }
  end

  def emojify(conv), do: conv

  def log(conv) do 
    conv |> inspect |> Logger.info
    conv
  end
end