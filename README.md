# Trend Application Deployment

Production-ready deployment of the provided **Trend** application using **Docker**, **Terraform**, **Jenkins**, **Docker Hub**, **Amazon EKS**, **Kubernetes**, **GitHub webhook integration**, and **open-source monitoring**.

## Original Repository
- Provided repo: `https://github.com/Vennilavanguvi/Trend.git`
- Submission repo: `https://github.com/Akashpeter19/Trend`

## AWS Details
- Region: `ap-south-1`
- EKS Cluster: `trend-devops-eks`
- Docker Image: `app19/trend-app`

## Project Objective
The objective of this project was to clone the provided application, containerize it, provision AWS infrastructure, deploy it to Amazon EKS, automate deployment using Jenkins CI/CD, and monitor the running application and cluster using open-source monitoring tools.

## Project Structure
```text
Trend/
├── app/
│   └── dist/
├── docker/
│   ├── Dockerfile
│   └── nginx.conf
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── outputs.tf
├── k8s/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── Jenkinsfile
├── .gitignore
├── .dockerignore
└── screenshots/
```

## 1. Application Setup
The provided repository was cloned and reorganized into a cleaner deployment-oriented structure. The application was prepared to run through a static Nginx container on **port 3000**.

## 2. Dockerization
The application was Dockerized using an Nginx-based image.

### Dockerfile Summary
- Uses `nginx:alpine`
- Copies the built application into the Nginx web root
- Exposes **port 3000**
- Serves the application in a production-ready static hosting setup

### Docker Validation
- Docker image built successfully
- Container tested locally
- Application confirmed in browser on `http://localhost:3000`

## 3. Terraform Infrastructure
Terraform was used to provision the AWS infrastructure required for deployment.

### Provisioned Components
- VPC
- Public subnets
- Internet gateway
- Route tables
- IAM roles and policy attachments
- EC2 instance for Jenkins
- Amazon EKS cluster
- EKS node group

### Terraform Commands Used
```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## 4. Docker Hub
A Docker Hub repository was created and the container image was pushed successfully.

### Example Commands
```bash
docker build -t trend-app:v1 -f docker/Dockerfile .
docker tag trend-app:v1 app19/trend-app:v1
docker push app19/trend-app:v1
```

## 5. Kubernetes Deployment on EKS
Kubernetes manifests were created and applied to the EKS cluster.

### Kubernetes Files
- `namespace.yaml`
- `deployment.yaml`
- `service.yaml`

### Deployment Result
- EKS nodes verified as **Ready**
- Application pods deployed successfully
- Service exposed via **LoadBalancer**
- Application accessed successfully using the external LoadBalancer URL

## 6. Version Control
The codebase was pushed to GitHub and proper ignore files were added.

### Version Control Notes
- `.gitignore` added to exclude Terraform state, local binaries, temporary files, and other generated content
- `.dockerignore` added to optimize Docker builds
- Project pushed through Git CLI commands to GitHub

## 7. Jenkins CI/CD
Jenkins was installed on the EC2 instance and configured for CI/CD deployment.

### Jenkins Setup Included
- Jenkins installation on EC2
- Docker installation and Jenkins-Docker permission setup
- Required plugins installed:
  - Docker
  - Git
  - Kubernetes
  - Pipeline
  - GitHub integration
- Credentials added for:
  - Docker Hub
  - AWS
- GitHub webhook configured for automatic trigger on push

### Pipeline
A declarative `Jenkinsfile` was created for automated deployment. The pipeline was used to connect GitHub commits to EKS deployment through Jenkins.

## 8. Monitoring
Open-source monitoring was implemented and validated.

### Monitoring Stack
- Prometheus
- Grafana

### Validation
- Monitoring stack deployed successfully
- Grafana dashboard accessed successfully
- Cluster/application monitoring output verified

## 9. Evidence / Screenshots
The repository contains screenshots showing:
- repository cloning
- Docker build and local run
- Docker Hub push
- Terraform validation and apply
- Jenkins installation and unlock
- EKS node readiness
- Kubernetes deployment and LoadBalancer
- GitHub webhook configuration
- Jenkins pipeline configuration and success
- monitoring stack and Grafana dashboard
- live application on the AWS LoadBalancer

## 10. Submission Details
- GitHub Link: `https://github.com/Akashpeter19/Trend`
- LoadBalancer URL: `[Add final DNS / URL here]`
- LoadBalancer ARN: `[Add ARN from AWS console / CLI here]`

## Conclusion
This project successfully deployed the provided Trend application into a production-ready AWS Kubernetes environment. The final solution includes Dockerization, Terraform-based infrastructure provisioning, Jenkins CI/CD automation, deployment to Amazon EKS, GitHub webhook integration, Docker Hub image hosting, and open-source monitoring using Prometheus and Grafana.

