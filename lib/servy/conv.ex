defmodule Servy.Conv do
  defstruct [
    method: "",
    path: "",
    params: %{},
    headers: %{},
    resp_headers: %{ "Content-Type" => "text/html" },
    resp_body: "",
    status: nil,
  ]

  def full_status(%__MODULE__{} = conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  def put_content_length(%__MODULE__{ resp_body: resp_body } = conv) do
    headers = Map.put(conv.resp_headers, "Content-Length", byte_size(resp_body))
    %{ conv | resp_headers: headers }
  end

  def put_resp_content_type(%__MODULE__{} = conv, content_type) do
    headers = Map.put(conv.resp_headers, "Content-Type", content_type)
    %{ conv | resp_headers: headers }
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      204 => "No Content",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error",
    }[code]
  end
end