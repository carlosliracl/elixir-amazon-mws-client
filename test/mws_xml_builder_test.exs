defmodule MWSXmlBuilderTest do
  use ExUnit.Case

  setup do
    messages = [
      [
        {:MessageID, "1"},
        {:OperationType, "Update"},
        {:Inventory,
         [
           {:SKU, "REMOTE_SKU_1"},
           {:FulfillmentCenterID, "AMAZON_NA"},
           {:Lookup, "FulfillmentNetwork"},
           {:SwitchFulfillmentTo, "AFN"}
         ]}
      ],
      [
        {:MessageID, "2"},
        {:OperationType, "Update"},
        {:Inventory,
         [
           {:SKU, "REMOTE_SKU_2"},
           {:FulfillmentCenterID, "AMAZON_NA"},
           {:Lookup, "FulfillmentNetwork"},
           {:SwitchFulfillmentTo, "AFN"}
         ]}
      ]
    ]

    [messages: messages]
  end

  describe "build/4" do
    test "should build xml successfully", %{messages: messages} do
      config = %MWSClient.Config{seller_id: "seller_id"}

      {:ok, result} = MWSXmlBuilder.build(config, "Inventory", messages)

      assert result ==
               ~s|<?xml version="1.0" encoding="UTF-8"?>\n<AmazonEnvelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="amzn-envelope.xsd">\n  <Header>\n    <DocumentVersion>1.01</DocumentVersion>\n    <MerchantIdentifier>seller_id</MerchantIdentifier>\n  </Header>\n  <MessageType>Inventory</MessageType>\n  <PurgeAndReplace>false</PurgeAndReplace>\n  <Message>\n    <MessageID>1</MessageID>\n    <OperationType>Update</OperationType>\n    <Inventory>\n      <SKU>REMOTE_SKU_1</SKU>\n      <FulfillmentCenterID>AMAZON_NA</FulfillmentCenterID>\n      <Lookup>FulfillmentNetwork</Lookup>\n      <SwitchFulfillmentTo>AFN</SwitchFulfillmentTo>\n    </Inventory>\n  </Message>\n  <Message>\n    <MessageID>2</MessageID>\n    <OperationType>Update</OperationType>\n    <Inventory>\n      <SKU>REMOTE_SKU_2</SKU>\n      <FulfillmentCenterID>AMAZON_NA</FulfillmentCenterID>\n      <Lookup>FulfillmentNetwork</Lookup>\n      <SwitchFulfillmentTo>AFN</SwitchFulfillmentTo>\n    </Inventory>\n  </Message>\n</AmazonEnvelope>|
    end

    test "should build xml successfully when purge_replace_opt is true", %{messages: messages} do
      config = %MWSClient.Config{seller_id: "seller_id"}

      {:ok, result} = MWSXmlBuilder.build(config, "Inventory", messages, true)

      assert result ==
               ~s|<?xml version="1.0" encoding="UTF-8"?>\n<AmazonEnvelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="amzn-envelope.xsd">\n  <Header>\n    <DocumentVersion>1.01</DocumentVersion>\n    <MerchantIdentifier>seller_id</MerchantIdentifier>\n  </Header>\n  <MessageType>Inventory</MessageType>\n  <PurgeAndReplace>true</PurgeAndReplace>\n  <Message>\n    <MessageID>1</MessageID>\n    <OperationType>Update</OperationType>\n    <Inventory>\n      <SKU>REMOTE_SKU_1</SKU>\n      <FulfillmentCenterID>AMAZON_NA</FulfillmentCenterID>\n      <Lookup>FulfillmentNetwork</Lookup>\n      <SwitchFulfillmentTo>AFN</SwitchFulfillmentTo>\n    </Inventory>\n  </Message>\n  <Message>\n    <MessageID>2</MessageID>\n    <OperationType>Update</OperationType>\n    <Inventory>\n      <SKU>REMOTE_SKU_2</SKU>\n      <FulfillmentCenterID>AMAZON_NA</FulfillmentCenterID>\n      <Lookup>FulfillmentNetwork</Lookup>\n      <SwitchFulfillmentTo>AFN</SwitchFulfillmentTo>\n    </Inventory>\n  </Message>\n</AmazonEnvelope>|
    end

    test "should return error when config is nil" do
      {:error, message} = MWSXmlBuilder.build(nil, "Inventory", [])
      assert message == "Invalid args"
    end

    test "should return error when seller_id is nil" do
      config = %MWSClient.Config{seller_id: nil}

      {:error, message} = MWSXmlBuilder.build(config, "Inventory", [])
      assert message == "seller_id is required"
    end

    test "should return error when message_type is nil" do
      config = %MWSClient.Config{seller_id: "seller_id"}

      {:error, message} = MWSXmlBuilder.build(config, nil, [])
      assert message == "message_type is required"
    end

    test "should return error when messages is empty" do
      config = %MWSClient.Config{seller_id: "seller_id"}

      {:error, message} = MWSXmlBuilder.build(config, "Inventory", [], false)
      assert message == "messages is required"
    end
  end
end
