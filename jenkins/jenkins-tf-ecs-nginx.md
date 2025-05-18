
### Store Terraform State in S3 (Remote Backend)

**Reason
- Use an S3 bucket to store the terraform.tfstate.
- Use a DynamoDB table (optional but recommended) to enable state locking and prevent two people from applying changes at the same time.

**Add a backend.tf to the Terraform project

terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"        # Must already exist
    key            = "ecs/nginx/terraform.tfstate"         # Folder/key path
    region         = "eu-central-1"                        # Your AWS region
    dynamodb_table = "terraform-locks"                     # Must already exist
    encrypt        = true
  }
}


aws s3api create-bucket --bucket devops-learn-tf-state-971422682604 --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1

aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
  
  

### Deploy NGINX to AWS ECS using Terraform via Jenkins

**prerequisites
- Configure AWS credentials (either via environment variables, credentials binding, or IAM role).
- TF binary installed
- Install git & tf on Jenkins VM

**Steps:
- Download TF code from Git
- Terraform init
- Terraform validate
- Terraform plan
- Terraform apply
- Cleanup git files?
- echo deployment status
- Teraform destroy if deployment fails?

**Jenkins file

pipeline {
  agent any

  environment {
    AWS_REGION = 'eu-central-1'
    TF_VAR_vpc_id = 'vpc-0abc123def4567890'
    TF_VAR_subnet_ids = '["subnet-0aaa111", "subnet-0bbb222"]'
    TF_VAR_cluster_name = 'my-nginx-cluster'
    TF_VAR_service_name = 'nginx-service'
    TF_VAR_task_definition_name = 'nginx-task'
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/naspeps/devops-projects.git', branch: 'main'
      }
    }

    stage('Terraform Init') {
      steps {
	    dir('docker/ecs/nginx_ecs_terraform') {
          sh 'terraform init'
		}
      }
    }

    stage('Terraform Plan') {
      steps {
          sh 'terraform plan'
		}
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
  }

post {
  success {
    echo '✅ Terraform apply succeeded! ECS NGINX is deployed.'
  }
  failure {
    echo '❌ Terraform apply failed! Check logs for details.'
  }
}


**Installing prerequisites

Terraform

sudo apt-get update
sudo apt-get install -y gnupg software-properties-common curl

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update && sudo apt-get install terraform


Git

sudo apt install git -y


AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


**IAM Permissions for Terraform (Minimum)

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "iam:PassRole",
        "ec2:Describe*",
        "elasticloadbalancing:*",
        "logs:*"
      ],
      "Resource": "*"
    }
  ]
}

**IAM role for Jenkins on EC2
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ECSAndVPC",
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "ec2:Describe*",
        "ec2:CreateSecurityGroup",
		"ec2:RevokeSecurityGroupEgress",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:DeleteSecurityGroup",
        "ec2:CreateTags",
        "ec2:DeleteTags"
      ],
      "Resource": "*"
    },
    {
      "Sid": "IAMPassRole",
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "*"
    },
    {
      "Sid": "S3Backend",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": "*"
    },
    {
      "Sid": "DynamoDBStateLocking",
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:UpdateItem",
        "dynamodb:DescribeTable"
      ],
      "Resource": "*"
    }
  ]
}



**Extra step to cleanup workspace/tf-ecs-nginx-deploy
post {
  always {
    cleanWs() // This deletes the workspace after the build
  }
}

or

stage('Clean Workspace') {
  steps {
    deleteDir() // Groovy built-in to clear the current working directory
  }
}



**Manual TF cleanup

- SSH into the Jenkins EC2
- cd /var/lib/jenkins/workspace/tf-ecs-nginx-deploy
- terraform destroy -auto-approve
