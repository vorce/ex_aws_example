# ExAwsExample

Example project that shows you how to set up some AWS SQS and SNS resources in Elixir with [ex_aws](https://github.com/ex-aws/ex_aws), and a SQS consumer to get messages.

Blog post: <TBD>

There are no tests for the functionality, and error handling is minimal.

## Usage

- Get dependencies: `mix deps.get`
- Start app with your AWS credentials: `AWS_ACCESS_KEY_ID=... AWS_SECRET_ACCESS_KEY=... iex -S mix`
