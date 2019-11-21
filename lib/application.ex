defmodule ExAwsExample.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      ExAwsExample.SQSConsumer
    ]

    opts = [strategy: :one_for_one, name: ExAwsExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
