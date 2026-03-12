pipeline {
    agent any

    environment {
        AWS_REGION   = 'ap-south-1'
        CLUSTER_NAME = 'trend-devops-eks'
        IMAGE_REPO   = 'app19/trend-app'
        IMAGE_TAG    = "build-${BUILD_NUMBER}"
        DOCKER_BUILDKIT = '1'
        HOME         = '/var/lib/jenkins'
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
                withCredentials([usernamePassword(
                    credentialsId: 'aws-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                        set -eux
                        export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
                        export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"
                        export AWS_DEFAULT_REGION="${AWS_REGION}"
                        export HOME=/var/lib/jenkins

                        aws sts get-caller-identity
                        aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}
                        kubectl get nodes
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                        set -eux
                        export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
                        export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"
                        export AWS_DEFAULT_REGION="${AWS_REGION}"
                        export HOME=/var/lib/jenkins

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
