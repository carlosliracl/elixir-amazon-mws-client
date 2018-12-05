defmodule MWSClient.Operation do
  defstruct [
    params: %{},
    path: "/",
    timestamp: nil,
    method: "POST",
    body: nil,
    headers: []
  ]
end
