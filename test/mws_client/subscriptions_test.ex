defmodule MWSClient.SubscriptionsTest do
  alias MWSClient.Subscriptions
  use ExUnit.Case


  test "register_destination should return a struct" do
    res = Subscriptions.register_destination("http://foo.bar/baz")
    exp = %MWSClient.Operation{body: nil, headers: [], method: "POST",
                               params: %{"Action" => "RegisterDestination",
                                 "Destination.AttributeList.member.1.Key" => "sqsQueueUrl",
                                 "Destination.AttributeList.member.1.Value" => "http://foo.bar/baz",
                                 "Destination.DeliveryChannel" => "SQS",
                                 "MarketplaceId" => "ATVPDKIKX0DER", "Version" => "2013-07-01"},
                               path: "/Subscriptions/2013-07-01", timestamp: nil}

    assert res == exp
  end
end