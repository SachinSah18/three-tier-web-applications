pipeline {
    agent any

    triggers {
        pollSCM('*/2 * * * *') 
    }

    environment {
        AWS_REGION         = 'ap-south-1'
        ECR_REPO_URL       = '081671069989.dkr.ecr.ap-south-1.amazonaws.com/employee-3-tier'
        ECS_CLUSTER        = 'employee-3-tier-cluster'
        ECS_SERVICE        = 'employee-3-tier-service'
        AWS_CREDENTIALS_ID = 'aws-credentials'
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
                withCredentials([usernamePassword(credentialsId: "${AWS_CREDENTIALS_ID}", usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        echo 'Logging into AWS ECR using Dockerized AWS CLI...'
                        // Docker container ka use karke AWS token nikalenge aur login karenge
                        sh """
                        docker run --rm \
                          -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
                          -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
                          amazon/aws-cli ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO_URL}
                        """
                    }
                }
            }
        }

        stage('Build & Push Images') {
            steps {
                script {
                    echo 'Building & Pushing Backend Image...'
                    sh "docker build -t ${ECR_REPO_URL}:backend -f backend/Dockerfile ."
                    sh "docker push ${ECR_REPO_URL}:backend"

                    echo 'Building & Pushing Frontend Image...'
                    sh "docker build -t ${ECR_REPO_URL}:frontend -f frontend/Dockerfile ."
                    sh "docker push ${ECR_REPO_URL}:frontend"
                }
            }
        }

        stage('Deploy to AWS ECS') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${AWS_CREDENTIALS_ID}", usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    echo 'Updating ECS Service using Dockerized AWS CLI...'
                    sh """
                    docker run --rm \
                      -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
                      -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
                      amazon/aws-cli ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --force-new-deployment --region ${AWS_REGION}
                    """
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
