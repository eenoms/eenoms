### Generate 1000 files in s3Contents folder:
```
for i in {1..1000}; do touch s3Contents/file${i}; done
```

### Set AWS Credentials in Linux Shell:
```
export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="yyyyyyyyyyyyyyyyyyyyyyyyyyyy"
```

### Terraform Commands:
```
terraform init
terraform plan
terraform apply
terraform destroy
