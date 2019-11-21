defmodule ExAwsExample do
  @moduledoc "Collection of functions demonstrating how to use ExAws.SQS and ExAws.SNS"

  alias ExAws.SQS
  alias ExAws.SNS

  def create_queue(queue_name, opts \\ []) do
    queue_name
    |> SQS.create_queue(opts)
    |> ExAws.request()
  end

  def create_sqs_subscription(topic_arn, queue_url) do
    queue_arn = queue_url_to_arn(queue_url)

    topic_arn
    |> SNS.subscribe("sqs", queue_arn)
    |> ExAws.request()
  end

  defp queue_url_to_arn(queue_url) do
    [_protocol, "", host, account_id, queue_name] = String.split(queue_url, "/")
    [service, region, _, _] = String.split(host, ".")

    "arn:aws:#{service}:#{region}:#{account_id}:#{queue_name}"
  end

  def queue_policy(region, account_id, queue_name, topic_arn) do
    ~s"""
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": [
            "sqs:SendMessage"
          ],
          "Resource": "arn:aws:sqs:#{region}:#{account_id}:#{queue_name}",
          "Condition": {
            "ArnEquals": {
              "aws:SourceArn": "#{topic_arn}"
            }
          }
        }
      ]
    }
    """
  end

  def set_subscription_attributes(subscription_arn, opts \\ []) do
    # default to an empy filter json document
    filter = Keyword.get(opts, :filter, "{}")
    raw_message_delivery = Keyword.get(opts, :raw_message_delivery, "true")

    "FilterPolicy"
    |> SNS.set_subscription_attributes(filter, subscription_arn)
    |> ExAws.request()

    "RawMessageDelivery"
    |> SNS.set_subscription_attributes(raw_message_delivery, subscription_arn)
    |> ExAws.request()
  end

  def delete_message(queue_url, receipt) do
    queue_url
    |> SQS.delete_message(receipt)
    |> ExAws.request()
  end
end
