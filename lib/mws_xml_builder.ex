defmodule MWSXmlBuilder do
  import XmlBuilder

  def build(config, message_type, messages, purge_replace_opt \\ false)

  def build(%MWSClient.Config{} = config, message_type, messages, purge_replace_opt) do
    []
    |> add_header(config)
    |> add_message_type(message_type)
    |> add_purge_replace_opt(purge_replace_opt)
    |> add_messages(messages)
    |> do_build()
  end

  def build(_, _, _, _), do: {:error, "Invalid args"}

  defp do_build({:ok, content}) do
    xml =
      :AmazonEnvelope
      |> document(amazon_envelope_params(), content)
      |> generate()

    {:ok, xml}
  end

  defp do_build({:error, message}), do: {:error, message}

  defp amazon_envelope_params() do
    %{
      "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
      "xsi:noNamespaceSchemaLocation" => "amzn-envelope.xsd"
    }
  end

  defp add_header(_content, %{seller_id: nil}), do: {:error, "seller_id is required"}

  defp add_header(content, %{seller_id: seller_id}) do
    header =
      element(
        Header: [
          {:DocumentVersion, "1.01"},
          {:MerchantIdentifier, seller_id}
        ]
      )

    {:ok, content ++ [header]}
  end

  defp add_message_type({:error, message}, _), do: {:error, message}

  defp add_message_type(_, nil), do: {:error, "message_type is required"}

  defp add_message_type({:ok, content}, message_type) do
    {:ok, content ++ [element(MessageType: message_type)]}
  end

  defp add_purge_replace_opt({:error, message}, _), do: {:error, message}

  defp add_purge_replace_opt({:ok, content}, purge_replace_opt) do
    {:ok, content ++ [element(PurgeAndReplace: purge_replace_opt)]}
  end

  defp add_messages({:error, message}, _), do: {:error, message}

  defp add_messages(_, messages) when messages in [nil, []], do: {:error, "messages is required"}

  defp add_messages({:ok, content}, messages) do
    {:ok, content ++ Enum.map(messages, &element(Message: &1))}
  end
end
