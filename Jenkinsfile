pipeline {
    agent any

    environment {
        // Define environment variables
        DOCKER_IMAGE = 'java-app/sample-java-app'
        ECR_REGISTRY = '237814008471.dkr.ecr.us-east-1.amazonaws.com'
        ECR_CREDENTIALS_ID = 'your-ecr-credentials-id'
    }

    stages {
        stage('Build Application') {
            steps {
                // Use Maven wrapper script to build your Java application
                sh './mvnw clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Assuming Dockerfile is at the root of the project
                    docker.build("${ECR_REGISTRY}/${DOCKER_IMAGE}")
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    docker.withRegistry("https://${ECR_REGISTRY}", ECR_CREDENTIALS_ID) {
                        docker.image("${ECR_REGISTRY}/${DOCKER_IMAGE}").push("${env.BUILD_ID}")
                        docker.image("${ECR_REGISTRY}/${DOCKER_IMAGE}").push("latest")
                    }
                }
            }
        }

        stage('Update ECS Service') {
            steps {
                script {
                    // Replace <cluster-name> and <service-name> with your ECS cluster and service names
                    // Ensure the Jenkins agent has AWS CLI and proper IAM permissions
                    sh "aws ecs update-service --cluster <cluster-name> --service <service-name> --force-new-deployment"
                }
            }
        }
    }
}
