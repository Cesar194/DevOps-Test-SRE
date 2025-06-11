# DevOpsTest
Repository to provide the solution of the DevOps technical test
# SRE / DevOps Technical Challenge - Banco Cuscatlan

This repository contains the complete solution for the SRE/DevOps technical challenge. [cite_start]The project provisions two Kubernetes clusters on AWS using Terraform and sets up a full CI/CD pipeline with Jenkins and SonarQube to build and deploy a Java 17 "Hello World" application. 

## Architecture Diagram

[cite_start](Here you can embed the diagram provided in the challenge description or, even better, create your own to reflect your implementation) 

https://drive.google.com/file/d/1LV0NmSey8lRKoiWfxzHNIea1lf6V1vji/view?usp=sharing

## Project Structure

A brief explanation of the project's directory structure:
- [cite_start]**/terraform**: Contains all Terraform code for provisioning the AWS infrastructure.  It's split into `development` and `deployment` environments.
- **/kubernetes**: Contains the Kubernetes manifest files (`deployment.yaml`, `service.yaml`) for the application.
- **/jenkins**: Contains the `Jenkinsfile` which defines the CI/CD pipeline.
- **Dockerfile**: Used to containerize the Java application.

## Prerequisites

To run this project, you will need the following tools installed:
- AWS CLI
- Terraform
- kubectl
- Helm
- A registered domain (for the application)

## Setup and Deployment Instructions

Follow these steps to deploy the entire solution from scratch:

1.  **Clone Repository**: `git clone <your-repo-url>`
2.  **Configure AWS Credentials**: Run `aws configure` and provide valid IAM credentials.
3.  **Provision Development Cluster**:
    ```bash
    cd terraform/development
    terraform init
    terraform apply
    ```
4.  **Provision Deployment Cluster**:
    ```bash
    cd ../deployment
    terraform init
    terraform apply
    ```
5.  **Configure `kubectl`**: Run `aws eks update-kubeconfig` for both clusters as detailed in the setup guide.
6.  **Install Jenkins & SonarQube**: Follow the Helm installation steps previously outlined.
7.  **Create and Run Jenkins Pipeline**: Set up the pipeline job in Jenkins pointing to this repository's `jenkins/Jenkinsfile`.

## How to Access the Services

-   **Hello World Application**: The application URL can be found by running `kubectl get service hello-world-service -n <namespace>` on the **development** cluster.
-   **Jenkins**: Accessible at `http://<JENKINS_LOAD_BALANCER_IP>:8080`.
-   **SonarQube**: Accessible at `http://<SONARQUBE_LOAD_BALANCER_IP>:9000`. The default credentials are `admin`/`admin`.

## Security Considerations

[cite_start]Security was a key consideration in this project:
- **IAM Roles for EKS**: Dedicated IAM roles are used for the EKS clusters and their node groups to grant specific, limited permissions.
- **Secrets Management**: Sensitive data like the SonarQube token and kubeconfig files are managed as Jenkins credentials, not stored in the repository.
- **Network Isolation**: Each cluster operates in its own dedicated VPC to prevent unauthorized cross-environment traffic.

---
