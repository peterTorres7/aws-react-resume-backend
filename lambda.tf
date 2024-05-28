data "aws_iam_policy_document" "assume_role" {
    statement {
      effect = "Allow"

      principals {
        type = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }

      actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

data "archive_file" "lambda" {
    type = "zip"
    source_file = "lambdafunction.py"
    output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda_visits_count_function" {
  filename = data.archive_file.lambda.output_path
  function_name = "lambda_visits_count_function"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "lambdafunction.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime = "python3.9"

  environment {
    variables = {
        DYNAMODB_TABLE_NAME = aws_dynamodb_table.visits_table.name
    }
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_visits_count_function.function_name
  principal = "events.amazonaws.com"
}
