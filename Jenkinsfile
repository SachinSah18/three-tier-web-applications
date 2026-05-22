pipeline {
    agent any

    triggers {
        pollSCM('*/2 * * * *') 
    }

    environment {
        AWS_REGION         = 'ap-south-1'
        ECR_REPO_URL       = '081671069989.dkr.ecr.ap-south-1.amazonaws.com/employee-3-tier'
        SERVER_IP          = '13.206.247.148' // Aapki naye EC2 ki IP
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
                        echo 'Logging into AWS ECR...'
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
                    echo 'Building & Pushing Backend Image to ECR...'
                    sh "docker build -t ${ECR_REPO_URL}:backend -f backend/Dockerfile ."
                    sh "docker push ${ECR_REPO_URL}:backend"

                    echo 'Building & Pushing Frontend Image to ECR...'
                    sh "docker build -t ${ECR_REPO_URL}:frontend -f frontend/Dockerfile ."
                    sh "docker push ${ECR_REPO_URL}:frontend"
                }
            }
        }

        stage('Deploy to EC2 via Docker Compose') {
            steps {
                echo "Deploying applications directly to EC2 Server: ${SERVER_IP}..."
                // Local build temporary check karne ke liye hum containers ko local stack me run karke port check karenge
                script {
                    sh """
                    docker compose down || true
                    docker compose up -d --build
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Bhai! Deployment Successful on AWS EC2!'
            echo "Go to: http://${SERVER_IP}"
        }
        failure {
            echo 'Deployment Failed! Check logs.'
        }
    }
}
