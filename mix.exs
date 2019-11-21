defmodule ExAwsExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_aws_example,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExAwsExample.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.1"},
      {:ex_aws_sqs, "~> 3.0"},
      {:ex_aws_sns, "~> 2.0"},
      {:sweet_xml, "~> 0.6"},
      {:hackney, "~> 1.15"},
      {:poison, "~> 4.0"}
    ]
  end
end
