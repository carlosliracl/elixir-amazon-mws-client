defmodule MWSClient.Shipments do
  @version "2018-09-01"
  @path "/ShipmentInvoicing/#{@version}"

  @moduledoc """
  Shipments API section of Amazon MWS
  """

  import MWSClient.Utils

  def get_fba_outbound_shipment_detail(params, opts) do
    %{"Action" => "GetFBAOutboundShipmentDetail"}
    |> add(params, [:amazon_shipment_id])
    |> add(opts, [:marketplace_id])
    |> to_operation(@version, @path)
  end

  def submit_fba_outbound_shipment_invoice(params, opts) do
    data = Keyword.get(params, :data)

    %{"Action" => "SubmitFBAOutboundShipmentInvoice", "ContentMD5Value" => content_md5(data)}
    |> add(params, [:amazon_shipment_id, :content_md5_value])
    |> add(opts, [:marketplace_id])
    |> to_operation(@version, @path, data)
  end

  def get_fba_outbound_shipment_invoice_status(params, opts) do
    %{"Action" => "GetFBAOutboundShipmentInvoiceStatus"}
    |> add(params, [:amazon_shipment_id])
    |> add(opts, [:marketplace_id])
    |> to_operation(@version, @path)
  end
end
