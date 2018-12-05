defmodule MWSClient do

  use HTTPoison.Base

  alias MWSClient.{
    Config,
    Operation,
    Request,
    Products,
    Feed,
    Subscriptions,
    Orders,
    Reports
  }

  ### FEEDS
  def submit_product_feed(xml, config = %Config{}, opts \\ [purge_and_replace: false]) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Feed.submit_product_feed(xml, opts)
    |> request(config)
  end

  def submit_variation_feed(xml, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Feed.submit_variation_feed(xml, opts)
    |> request(config)
  end

  def submit_product_by_asin(xml, config = %Config{}, opts \\ [purge_and_replace: false]) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Feed.submit_product_feed(xml, opts)
    |> request(config)
  end

  def submit_price_feed(xml, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Feed.submit_price_feed(xml, opts)
    |> request(config)
  end

  def submit_inventory_feed(xml, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Feed.submit_inventory_feed(xml, opts) |> request(config)
  end

  def submit_images_feed(xml, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Feed.submit_images_feed(xml, opts)
    |> request(config)
  end

  def get_feed_submission_result(feed_id, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Feed.get_feed_submission_result(feed_id, opts)
    |> request(config)
  end
  ### FEEDS

  ### PRODUCTS
  def list_matching_products(query, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Products.list_matching_products(query, opts)
    |> request(config)
  end

  def get_matching_product(asin_list, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Products.get_matching_product(asin_list, opts)
    |> request(config)
  end

  def get_matching_product_for_id(id, id_list, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Products.get_matching_product_for_id(id, id_list, opts)
    |> request(config)
  end

  def get_lowest_offer_listings_for_asin(asin_list, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Products.get_lowest_offer_listings_for_asin(asin_list, opts)
    |> request(config)
  end

  def get_competitive_pricing_for_asin(asin_list, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Products.get_competitive_pricing_for_asin(asin_list, opts)
    |> request(config)
  end

  @conditions ["New", "Used", "Collectible", "Refurbished", "Club"]
  def get_lowest_priced_offers_for_asin(asin, item_condition, config = %Config{}, opts \\ []) when is_binary(asin) and item_condition in @conditions do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Products.get_lowest_priced_offers_for_asin(asin, item_condition, opts)
    |> request(config, true)
  end

  def get_product_categories_for_asin(asin, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Products.get_product_categories_for_asin(asin, opts)
    |> request(config)
  end

  ### PRODUCTS

  ### SUBSCRIPTIONS
  def subscribe_to_sqs(url, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Subscriptions.register_destination(url, opts)
    |> request(config)
  end

  def unsubscribe_from_sqs(url, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Subscriptions.deregister_destination(url, opts)
    |> request(config)
  end
  ### SUBSCRIPTIONS

  ### ORDERS
  def list_orders(params, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: [config.site_id])

    Orders.list_orders(params, opts)
    |> request(config)
  end

  def list_order_items(order_id, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Orders.list_order_items(order_id, opts)
    |> request(config)
  end

  def get_order(order_id, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id: config.site_id)

    Orders.get_order(order_id, opts)
    |> request(config)
  end
  ### ORDERS

  ### REPORTS
  def request_report(report_type, config = %Config{}, opts \\ []) do
    opts = Keyword.merge(opts, marketplace_id_list: [config.site_id])

    Reports.request_report(report_type, opts)
    |> request(config)
  end

  def get_report_request_list(config = %Config{}, opts \\ []) do
    Reports.get_report_request_list(opts)
    |> request(config)
  end

  def get_report_list(config = %Config{}, opts \\ []) do
    Reports.get_report_list(opts)
    |> request(config)
  end

  def get_report(report_id, config = %Config{}) do
    Reports.get_report(report_id)
    |> request(config)
  end
  ### REPORTS

  def request(operation = %Operation{}, config = %Config{}, query_in_body \\ false) do
    uri = Request.to_uri(operation, config)

    {status, response} =
      case query_in_body do
        true ->
          post(%{uri | query: nil}, uri.query, [
            {"Content-Type", "application/x-www-form-urlencoded; charset=UTF-8"} | operation.headers
          ])

        false ->
          if operation.body do
            post(uri, operation.body, operation.headers)
          else
            post(uri, uri.query, operation.headers)
          end
      end

    parse_response({status, response})
  end

  defp parse_response({:ok, response}) do
    {:ok, %{response | body: MWSClient.Parser.parse(response)}}
  end

  defp parse_response({:error, error}) do
    {:error, error}
  end

end
