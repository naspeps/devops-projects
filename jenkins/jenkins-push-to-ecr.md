
### Deploy NGINX to AWS ECS using Terraform via Jenkins

**prerequisites
- Install Docker & AWS CLI on Jenkins EC2
- Add Jenkins user to Docker group in EC2
- Already built Docker image
- ECR private repo
- AWS credentials / permisisons

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
        AWS_ACCOUNT_ID = '971422682604'
        ECR_REPO_URI = "971422682604.dkr.ecr.eu-central-1.amazonaws.com/devops-test"
        IMAGE_TAG = '1'
        LOCAL_IMAGE_NAME = 'nginx:latest'
    }

    stages {
        stage('Login to AWS ECR') {
            steps {
                sh """
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                """
            }
        }
        
        stage('Pull Image') {
            steps {
                sh "docker pull ${LOCAL_IMAGE_NAME}"
            }
        }


        stage('Tag Image') {
            steps {
                script {
                    env.ECR_IMAGE_URI = "${ECR_REPO_URI}:${env.IMAGE_TAG}"
                    sh "docker tag ${LOCAL_IMAGE_NAME} ${ECR_IMAGE_URI}"
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh "docker push ${ECR_IMAGE_URI}"
            }
        }
    }

    post {
        success {
            echo "✅ Docker image pushed to ECR: ${env.ECR_IMAGE_URI}"
        }
        failure {
            echo "❌ Failed to push Docker image to ECR"
        }
    }
}



**AWS IAM Policy

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": "*"
    }
  ]
}


**Add Jenkins user to Docker group in EC2
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
