## Features

- Created terraform modules for extreme reusability, readability and simpler code ✨
- Decisions and References are commented everywhere 🔦
- Easy to spin off complete environment with few inputs and imports 🚀
- Remote Backends to store tf state at cloud storage for multi-user managemment 🪣

## Project Structure

```
.
├── root  // contains all cloud provider directories
|   ├── aws-mumbai-dev-alpha
|   ├── aws-mumbai-prod-alpha
|   ├── aws-mumbai-dev-beta
|   |
|   └── tf-modules              // contains all reusable custom aws modules across environments
|       ├── networking          // contains all networking resources
|       ├── default-iam         // contains iam roles, policies and service accounts needed for cluster and node groups
|       ├── oidc                // contains openId connect issuer resources
|       ├── alb-controller      // contains application load balancer controller resources and deployment using helm
|       ├── cluster-autoscaler  // contains cluster autoscaler resources and deployment using helm
|       ├── ebs-csi-driver      // contains EBS addon for EKS
|       ├── iam-sa              // contains implementation of iam-roles-for-service-accounts
|       ├── node-group          // contains implementation of EKS node group with configurables
|       └── s3-bucket           // contains components for s3 buckets and iam
.
```

## AWS

### Instructions:

1. For the AWS tf-modules, each module have set of varibles where some of them must be provided at time of import \
   and rest have default values. It's important to check the default values of varibales and override them if needed.
2. Version variables must be checked and adjusted during import according to the compatibility of deployments

### Requirements:

1. For creating AWS environment, an EC2 instance key pair needs to be created and provide in env inputs.
2. Setup aws-cli and SSO credentials with profile names as in provider.tf file of respective environment.

### Modules

- **Networking**

  1.  Used for creating networking componenets needed for the environment.
  2.  Creates the following components:
      - VPC
      - Subnets
      - NAT and Internet Gateways
      - Route Tables and Associations
      - Security Groups

- **Default IAM**

  1.  Used for creating basic IAM needed for environment ops.
  2.  Creates IAM roles, polices and attachments required for EKS clusters and node groups.

- **OIDC**

  1.  Used to create an IAM OIDC provider for EKS cluster

- **ALB Controller**

  1. Used to deploy AWS Load Balancer Controller
  2. Manages AWS Elastic Load Balancers for a Kubernetes cluster
  3. Contains IAM roles, policies and service sccounts needed for ALB deployment
  4. Used `HELM` to deploy [alb controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller)

- **Cluster Autoscaler**

  1. Used to deploy cluster autoscaler for EKS cluster
  2. Used `HELM` to deploy [AWS cluster autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md)
  3. Manages autoscaling of node groups
  4. Contains autoscaler deployment and IAM required for operations.

- **EBS CSI Driver**

  1.  Used to add EBS plugin for EKS cluster
  2.  Used to provisions blocks storages EKS workloads

- **IAM SA**

  1. Used to create Kubernetes Service Accounts with associated IAM roles.
  2. Pods configured to use the service account can access any AWS service that the role has permissions to access.
  3. Can associate S3 buckets and EMR IAM roles.

- **Node Group**

  1.  Used to create a EKS node group
  2.  Flexible configurations with predefined instance types, autoscaling options and taints etc..

- **S3 Bucket**
  1.  Used to create S3 buckets.
  2.  Configurable options to provide public/ private access, create IAM users for buckets etc..


### Steps to setup/moderate the Environment

1. Change to directory to current working environment

```bash
cd root/aws/aws-mumbai-dev-alpha
```

2. Provide necessary input environment variables in `variables.auto.tfvars` file.

3. Validate the terraform code

```bash
terraform init
terraform validate
```

5. Verify the Plan/Changes and Apply

```bash
terraform plan
terraform apply
```

### Setup the Remote Backed

- For maintaining the terraform state across users, A remote backend (GCS/S3) bucket can be used.
- Uncomment the `backend` section in `provider.tf` file and provide necessary inputs.
- Once done run the following command to setup the remote backend.

```bash
terraform init
```
