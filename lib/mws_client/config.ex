defmodule MWSClient.Config do

  @hosts %{
    # North America
    "A2EUQ1WTGCTBG2" => "mws.amazonservices.com",     # Canada
    "ATVPDKIKX0DER"  => "mws.amazonservices.com",     # US
    "A1AM78C64UM0Y8" => "mws.amazonservices.com",     # Mexico

    # Europe
    "A1RKKUPIHCS9HS" => "mws-eu.amazonservices.com",  # Spain
    "A1F83G8C2ARO7P" => "mws-eu.amazonservices.com",  # UK
    "A13V1IB3VIYZZH" => "mws-eu.amazonservices.com",  # France
    "A1PA6795UKMFR9" => "mws-eu.amazonservices.com",  # Germany
    "APJ6JRA9NG5V4"  => "mws-eu.amazonservices.com",  # Italy

    # Other
    "A2Q3Y263D00KWC" => "mws.amazonservices.com",     # Brazil
    "A21TJRUUN4KGV"  => "mws.amazonservices.in",      # India
    "AAHKV2X7AFYLW"  => "mws.amazonservices.com.cn",  # China
    "A1VC38T7YXB528" => "mws.amazonservices.jp",      # Japan
    "A39IBJ37TRP1C6" => "mws.amazonservices.com.au",  # Australia
  }


  @moduledoc """
  Provides a structure for holding required params
  for the api call
  """

  defstruct [
    :aws_access_key_id,
    :seller_id,
    :aws_secret_access_key,
    :mws_auth_token,
    :host_override,
    port: 443,
    scheme: "https",
    site_id: "ATVPDKIKX0DER",
    signature_method: "HmacSHA256",
    signature_version: "2",
  ]

  def to_params(struct) do
    %{"AWSAccessKeyId"   => struct.aws_access_key_id,
      "SellerId"         => struct.seller_id,
      "MWSAuthToken"     => struct.mws_auth_token,
      "SignatureMethod"  => struct.signature_method,
      "SignatureVersion" => struct.signature_version,
    }
    |> Enum.reject(fn({_k, v}) -> v == nil end)
    |> Enum.into(%{})
  end

  def host(config) do
    case config.host_override do
      nil -> Map.fetch!(@hosts, config.site_id)
      host -> host
    end
  end
end
