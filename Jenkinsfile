pipeline {
    agent any

    environment {
        // Define environment variables
        JAVA_HOME = '/usr/lib/jvm/java-11-amazon-corretto.x86_64'
        DOCKER_IMAGE = 'public.ecr.aws/n5h8y2y9/java-app'
        ECR_REGISTRY = 'public.ecr.aws/n5h8y2y9'
        ECR_CREDENTIALS_ID = 'aws'
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

        stage('Login to ECR Public') {
            steps {
                script {
                    sh "aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
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
