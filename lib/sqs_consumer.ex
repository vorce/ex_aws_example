defmodule ExAwsExample.SQSConsumer do
  @moduledoc """
  Consumes messages from a SQS queue
  """
  alias ExAws.SQS

  require Logger

  use GenServer

  @account_id "041669274849"
  @queue_name "my-great-queue2"
  @queue_url "https://sqs.eu-west-1.amazonaws.com/#{@account_id}/#{@queue_name}"
  @topic_arn "arn:aws:sns:eu-west-1:#{@account_id}:test"
  @subscription_filter_policy "{}"

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    Logger.debug("Setting up queue #{@queue_name} and subscription to topic #{@topic_arn}")

    policy = ExAwsExample.queue_policy("eu-west-1", @account_id, @queue_name, @topic_arn)

    {:ok, %{body: %{queue_url: queue_url}}} =
      ExAwsExample.create_queue(@queue_name, policy: policy)

    {:ok, %{body: %{subscription_arn: sub_arn}}} =
      ExAwsExample.create_sqs_subscription(@topic_arn, queue_url)

    subscription_opts = [filter: @subscription_filter_policy, raw_message_delivery: "true"]
    ExAwsExample.set_subscription_attributes(sub_arn, subscription_opts)

    schedule_check()

    {:ok, %{queue_name: @queue_name, last_message_time: nil}}
  end

  def schedule_check(check_interval \\ 1_000) do
    Process.send_after(self(), :get_messages, check_interval)
  end

  def handle_messages() do
    case get_messages(@queue_url, wait_time_seconds: 5, max_number_of_messages: 10) do
      {:ok, []} ->
        :ok

      {:ok, messages} ->
        Logger.info(
          "Received #{length(messages)} messages from queue #{@queue_name}, processing them..."
        )

        process_messages(messages)

        messages
        |> Enum.each(fn %{receipt_handle: receipt_handle} ->
          Logger.debug("Deleting message with receipt: #{receipt_handle}")
          ExAwsExample.delete_message(@queue_url, receipt_handle)
        end)

      {:error, _} = unexpected ->
        Logger.error(
          "Could not get messages from queue #{@queue_name}, reason: #{inspect(unexpected)}"
        )
    end
  end

  defp get_messages(queue_url, opts) do
    result =
      queue_url
      |> SQS.receive_message(opts)
      |> ExAws.request()

    with {:ok, %{body: %{messages: messages}}} <- result, do: {:ok, messages}
  end

  def process_messages(messages) do
    Enum.each(messages, fn message ->
      Logger.info("Handling message: #{inspect(message)}")
      # do interesting stuff here
    end)

    messages
  end

  @impl GenServer
  def handle_info(:get_messages, state) do
    handle_messages()
    schedule_check()

    {:noreply, state}
  end
end
