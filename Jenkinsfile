pipeline {
    agent any

    environment {
        AWS_REGION   = 'ap-south-1'
        CLUSTER_NAME = 'trend-devops-eks'
        IMAGE_REPO   = 'app19/trend-app'
        IMAGE_TAG    = "build-${BUILD_NUMBER}"
        DOCKER_BUILDKIT = '1'
    }

    options {
        disableConcurrentBuilds()
        timestamps()
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Akashpeter19/Trend.git'
            }
        }

        stage('Verify Tools') {
            steps {
                sh '''
                    set -eux
                    docker --version
                    aws --version
                    kubectl version --client
                '''
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        set -eux
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                    set -eux
                    docker build -f docker/Dockerfile -t ${IMAGE_REPO}:${IMAGE_TAG} -t ${IMAGE_REPO}:latest .
                '''
            }
        }

        stage('Push Image') {
            steps {
                sh '''
                    set -eux
                    docker push ${IMAGE_REPO}:${IMAGE_TAG}
                    docker push ${IMAGE_REPO}:latest
                '''
            }
        }

        stage('Update Kubeconfig') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    sh '''
                        set -eux
                        aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    set -eux
                    kubectl apply -f k8s/namespace.yaml
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    kubectl -n trend set image deployment/trend-app trend-app=${IMAGE_REPO}:${IMAGE_TAG} --record || true
                    kubectl -n trend rollout status deployment/trend-app --timeout=180s
                    kubectl -n trend get pods -o wide
                    kubectl -n trend get svc
                '''
            }
        }
    }

    post {
        always {
            sh '''
                docker logout || true
                docker image prune -af || true
            '''
        }
        success {
            echo 'Pipeline completed successfully: build, push, and deploy done.'
        }
        failure {
            echo 'Pipeline failed. Check stage logs.'
        }
    }
}
