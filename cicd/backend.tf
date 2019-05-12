// To store the terraform state in an AWS S3 Bucket
terraform {  
    backend "s3" {
        bucket         = "terraform-remote-store"
        encrypt        = true
        key            = "terraform.tfstate"    
        region         = "ap-southeast-2"
        dynamodb_table = "terraform-state-lock-dynamo"
    }
}

