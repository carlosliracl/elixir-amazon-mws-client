defmodule MWSClient.SubscriptionsTest do
  alias MWSClient.Subscriptions
  use ExUnit.Case

  test "register_destination should return a struct" do
    res =
      Subscriptions.register_destination("http://foo.bar/baz", marketplace_id: "ATVPDKIKX0DER")

    exp = %MWSClient.Operation{
      body: nil,
      headers: [],
      method: "POST",
      params: %{
        "Action" => "RegisterDestination",
        "Destination.AttributeList.member.1.Key" => "sqsQueueUrl",
        "Destination.AttributeList.member.1.Value" => "http://foo.bar/baz",
        "Destination.DeliveryChannel" => "SQS",
        "MarketplaceId" => "ATVPDKIKX0DER",
        "Version" => "2013-07-01"
      },
      path: "/Subscriptions/2013-07-01",
      timestamp: nil
    }

    assert res == exp
  end

  test "deregister_destination should return a struct" do
    res =
      Subscriptions.deregister_destination("http://foo.bar/baz", marketplace_id: "ATVPDKIKX0DER")

    exp = %MWSClient.Operation{
      body: nil,
      headers: [],
      method: "POST",
      path: "/Subscriptions/2013-07-01",
      timestamp: nil,
      params: %{
        "Destination.AttributeList.member.1.Key" => "sqsQueueUrl",
        "Destination.AttributeList.member.1.Value" => "http://foo.bar/baz",
        "Destination.DeliveryChannel" => "SQS",
        "MarketplaceId" => "ATVPDKIKX0DER",
        "Version" => "2013-07-01",
        "Action" => "DeregisterDestination"
      }
    }

    assert res == exp
  end

  test "list registred destinations" do
    res = Subscriptions.list_registered_destinations(marketplace_id: "ATVPDKIKX0DER")

    exp = %MWSClient.Operation{
      body: nil,
      headers: [],
      method: "POST",
      path: "/Subscriptions/2013-07-01",
      timestamp: nil,
      params: %{
        "Action" => "ListRegisteredDestinations",
        "MarketplaceId" => "ATVPDKIKX0DER",
        "Version" => "2013-07-01"
      }
    }

    assert res == exp
  end

  test "create subscription" do
    res =
      Subscriptions.create_subscription(
        "http://foo.bar/baz",
        "FeedType",
        marketplace_id: "ATVPDKIKX0DER"
      )

    exp = %MWSClient.Operation{
      body: nil,
      headers: [],
      method: "POST",
      path: "/Subscriptions/2013-07-01",
      timestamp: nil,
      params: %{
        "Action" => "CreateSubscription",
        "Subscription.Destination.AttributeList.member.1.Key" => "sqsQueueUrl",
        "Subscription.Destination.AttributeList.member.1.Value" => "http://foo.bar/baz",
        "Subscription.Destination.DeliveryChannel" => "SQS",
        "Subscription.IsEnabled" => true,
        "Subscription.NotificationType" => "FeedType",
        "MarketplaceId" => "ATVPDKIKX0DER",
        "Version" => "2013-07-01"
      }
    }

    assert res == exp
  end

  test "delete subscription" do
    res =
      Subscriptions.delete_subscription(
        "http://foo.bar/baz",
        "FeedType",
        marketplace_id: "ATVPDKIKX0DER"
      )

    exp = %MWSClient.Operation{
      body: nil,
      headers: [],
      method: "POST",
      path: "/Subscriptions/2013-07-01",
      timestamp: nil,
      params: %{
        "Action" => "DeleteSubscription",
        "Destination.AttributeList.member.1.Key" => "sqsQueueUrl",
        "Destination.AttributeList.member.1.Value" => "http://foo.bar/baz",
        "Destination.DeliveryChannel" => "SQS",
        "NotificationType" => "FeedType",
        "MarketplaceId" => "ATVPDKIKX0DER",
        "Version" => "2013-07-01"
      }
    }

    assert res == exp
  end

  test "list subscriptions" do
    res = Subscriptions.list_subscriptions(marketplace_id: "ATVPDKIKX0DER")

    exp = %MWSClient.Operation{
      body: nil,
      headers: [],
      method: "POST",
      path: "/Subscriptions/2013-07-01",
      timestamp: nil,
      params: %{
        "Action" => "ListSubscriptions",
        "MarketplaceId" => "ATVPDKIKX0DER",
        "Version" => "2013-07-01"
      }
    }

    assert res == exp
  end

  test "send test notification" do
    res =
      Subscriptions.send_test_notification("http://foo.bar/baz", marketplace_id: "ATVPDKIKX0DER")

    exp = %MWSClient.Operation{
      body: nil,
      headers: [],
      method: "POST",
      path: "/Subscriptions/2013-07-01",
      timestamp: nil,
      params: %{
        "Destination.AttributeList.member.1.Key" => "sqsQueueUrl",
        "Destination.AttributeList.member.1.Value" => "http://foo.bar/baz",
        "Destination.DeliveryChannel" => "SQS",
        "MarketplaceId" => "ATVPDKIKX0DER",
        "Version" => "2013-07-01",
        "Action" => "SendTestNotificationToDestination"
      }
    }

    assert res == exp
  end
end
