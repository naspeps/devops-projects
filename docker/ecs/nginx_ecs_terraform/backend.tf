terraform {
  backend "s3" {
    bucket         = "devops-learn-tf-state-971422682604"      
    key            = "ecs/nginx/terraform.tfstate"      
    region         = "eu-central-1"                       
    dynamodb_table = "terraform-locks"                  
    encrypt        = true
  }
}
