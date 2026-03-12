pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "app19/trend-app:v3"
        AWS_REGION = "ap-south-1"
        EKS_CLUSTER = "trend-devops-eks"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Akashpeter19/Trend.git'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                sh 'docker buildx build --platform linux/amd64 -t $DOCKER_IMAGE -f docker/Dockerfile . --push'
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh 'aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER'
                sh 'kubectl apply -f k8s/namespace.yaml || true'
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
                sh 'kubectl rollout restart deployment trend-app -n trend'
                sh 'kubectl get all -n trend'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
