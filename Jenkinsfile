pipeline {
    agent any

    environment {
        AWS_REGION         = 'ap-south-1'
        ECR_REPO_URL       = '081671069989.dkr.ecr.ap-south-1.amazonaws.com/employee-3-tier'
        ECS_CLUSTER        = 'employee-3-tier-cluster'
        ECS_SERVICE        = 'employee-3-tier-service'
        AWS_CREDENTIALS_ID = 'aws-credentials' // Jenkins Credentials ID
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Pulling code from repository...'
            }
        }

        stage('Security Scan') {
            steps {
                echo 'Running Security Scan...'
                sh 'chmod +x scripts/security-scan.sh'
                sh './scripts/security-scan.sh'
            }
        }

        stage('AWS ECR Login') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO_URL}"
                }
            }
        }

        stage('Build & Push Images') {
            steps {
                script {
                    echo 'Building Backend Image...'
                    sh "docker build -t ${ECR_REPO_URL}:backend -f backend/Dockerfile ."
                    sh "docker push ${ECR_REPO_URL}:backend"

                    echo 'Building Frontend Image...'
                    sh "docker build -t ${ECR_REPO_URL}:frontend -f frontend/Dockerfile ."
                    sh "docker push ${ECR_REPO_URL}:frontend"
                }
            }
        }

        stage('Deploy to AWS ECS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    echo 'Updating ECS Service to deploy new containers...'
                    sh "aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --force-new-deployment --region ${AWS_REGION}"
                }
            }
        }
    }

    post {
        success {
            echo 'Bhai! Deployment Successful on AWS!'
        }
        failure {
            echo 'Deployment Failed! Check logs.'
        }
    }
}
