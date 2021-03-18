#---------------------------------------------------------------------

data "aws_availability_zones" "available" {}

#---------------------------------------------------------------------

resource "aws_s3_bucket" "mybucket" {
  bucket = "my-pivate-bucket2217"
  acl    = "private"

  tags = {
    Name = "My bucket"
    Environment = var.env
  }
}


resource "aws_s3_bucket_object" "object1" {
  for_each = fileset("s3Contents/", "*")
  bucket = aws_s3_bucket.mybucket.id
  key = each.value
  source = "s3Contents/${each.value}"
  etag = filemd5("s3Contents/${each.value}")
}

#---------------------------------------------------------------------

resource "aws_iam_role" "my_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "s3.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}


resource "aws_iam_policy_attachment" "s3_full_access" {
    name = "s3_full_access"
    roles = [aws_iam_role.my_role.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "cloud_watch_logs_full_access" {
    name = "cloud_watch_logs_full_access"
    roles = [aws_iam_role.my_role.name]
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}



#---------------------------------------------------------------------


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-igw"
  }
}


resource "aws_subnet" "first" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "First"
  }
}


resource "aws_subnet" "second" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Second"
  }
}

resource "aws_subnet" "third" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Third"
  }
}


#---------------------------------------------------------------------

/*
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}



resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "exports.test"

  source_code_hash = filebase64sha256("lambda_function.zip")

  runtime = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}


*/