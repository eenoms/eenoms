output "s3_bucket_arn" {
  value = aws_s3_bucket.mybucket.arn
}

output "iam_policy_name" {
  value = aws_iam_role.my_role.name
}

output "iam_policy_arn" {
  value = aws_iam_role.my_role.arn
}

output "igw_id" {
  value = aws_internet_gateway.main-igw.id
}
