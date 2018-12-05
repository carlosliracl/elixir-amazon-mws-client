defmodule MWSClient.Parser do

  @moduledoc """
  Parse the response body based on the headers.
  """

  def parse(%{body: body, headers: headers}) do
    case get_content_type(headers) do
      "text/xml" <> _charset ->
        XmlToMap.naive_map(body)

      "application/xml" <> _charset ->
        XmlToMap.naive_map(body)

      "text/plain;charset=" <> _charset ->
        body
        |> String.split("\r\n")
        |> CSV.decode!(separator: ?\t, headers: true)
        |> Enum.to_list()
      "text/html" ->
        body
    end
  end

  defp get_content_type(headers) do
    Enum.find_value headers, fn
      {"Content-Type", value} -> value
      _                       -> false
    end
  end

end
