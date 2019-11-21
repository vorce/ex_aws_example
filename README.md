# ExAwsExample

Example project that shows you how to set up some AWS SQS and SNS resources in Elixir with [ex_aws](https://github.com/ex-aws/ex_aws), and a SQS consumer to get messages.

Blog post: https://forvillelser.vorce.se/posts/2019-11-21-using-exaws-to-setup-sqs-sns-and-consume-messages.html

There are no tests for the functionality, and error handling is minimal.

## Usage

- Get dependencies: `mix deps.get`
- Start app with your AWS credentials: `AWS_ACCESS_KEY_ID=... AWS_SECRET_ACCESS_KEY=... iex -S mix`
