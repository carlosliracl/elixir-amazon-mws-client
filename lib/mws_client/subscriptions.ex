defmodule MWSClient.Subscriptions do
  @version "2013-07-01"
  @path "/Subscriptions/#{@version}"

  import MWSClient.Utils

  def register_destination(url, opts) do
    %{
      "Action" => "RegisterDestination",
      "Destination.AttributeList.member.1.Key" => "sqsQueueUrl",
      "Destination.AttributeList.member.1.Value" => url,
      "Destination.DeliveryChannel" => "SQS"
    }
    |> add(opts, [:marketplace_id])
    |> to_operation(@version, @path)
  end

  def deregister_destination(url, opts) do
    %{
      "Action" => "DeregisterDestination",
      "Destination.AttributeList.member.1.Key" => "sqsQueueUrl",
      "Destination.AttributeList.member.1.Value" => url,
      "Destination.DeliveryChannel" => "SQS"
    }
    |> add(opts, [:marketplace_id])
    |> to_operation(@version, @path)
  end

  def list_registered_destinations(opts) do
    %{"Action" => "ListRegisteredDestinations"}
    |> add(opts, [:marketplace_id])
    |> to_operation(@version, @path)
  end

  def send_test_notification(url, opts) do
    %{
      "Action" => "SendTestNotificationToDestination",
      "Destination.AttributeList.member.1.Key" => "sqsQueueUrl",
      "Destination.AttributeList.member.1.Value" => url,
      "Destination.DeliveryChannel" => "SQS"
    }
    |> add(opts, [:marketplace_id])
    |> to_operation(@version, @path)
  end
end
