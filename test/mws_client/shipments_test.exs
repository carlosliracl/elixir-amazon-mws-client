defmodule MWSClient.ShipmentsTest do
  use ExUnit.Case

  alias MWSClient.Shipments
  alias MWSClient.Operation

  test "get_fba_outbound_shipment_detail" do
    result =
      Shipments.get_fba_outbound_shipment_detail(
        [amazon_shipment_id: "shipment_id"],
        marketplace_id: "ATVPDKIKX0DER"
      )

    expectation = %Operation{
      params: %{
        "AmazonShipmentId" => "shipment_id",
        "Action" => "GetFBAOutboundShipmentDetail",
        "MarketplaceId" => "ATVPDKIKX0DER",
        "Version" => "2018-09-01"
      },
      path: "/ShipmentInvoicing/2018-09-01"
    }

    assert result == expectation
  end

  test "submit_fba_outbound_shipment_invoice" do
    result =
      Shipments.submit_fba_outbound_shipment_invoice(
        [data: "xml content file", amazon_shipment_id: "shipment_id"],
        marketplace_id: "ATVPDKIKX0DER"
      )

    expectation = %Operation{
      body: "xml content file",
      params: %{
        "AmazonShipmentId" => "shipment_id",
        "Action" => "SubmitFBAOutboundShipmentInvoice",
        "MarketplaceId" => "ATVPDKIKX0DER",
        "Version" => "2018-09-01",
        "ContentMD5Value" => "KoXUCoEHwYTCPipqsKslTw=="
      },
      path: "/ShipmentInvoicing/2018-09-01"
    }

    assert result == expectation
  end

  test "get_fba_outbound_shipment_invoice_status" do
    result =
      Shipments.get_fba_outbound_shipment_invoice_status(
        "shipment_id",
        marketplace_id: "ATVPDKIKX0DER"
      )

    expectation = %Operation{
      params: %{
        "AmazonShipmentId.Id.1" => "shipment_id",
        "Action" => "GetFBAOutboundShipmentInvoiceStatus",
        "MarketplaceId" => "ATVPDKIKX0DER",
        "Version" => "2018-09-01"
      },
      path: "/ShipmentInvoicing/2018-09-01"
    }

    assert result == expectation
  end
end
