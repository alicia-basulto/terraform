# Terraform Cheat Sheet & CLI commands 

**Terraform** is a **Infrastructure-as-code (IaC) tool**, is open-source, cloud-agnostic provisioning tool developed by HashiCorp and written in GO language.. This provides a command-line interface called **Terraform CLI**.


#Configuration Files

- **main.tf**: file with the code
- **terraform.tfstate**: File (JSON) with the real-world resource database. Maps the configuration written in main.tf to the one deployed in the real world.
- **terraform.lock.hcl**: (similar to package-lock.json) when we run `terraform init` it will download the providers it needs and write a .lock file with the versions we have used. To update these versions we run `terraform init -upgrade`
- **.terraform**: (contains the providers we are using) It downloads the binary of the provider plugins. If we have the file downloaded the next time we will run `terraform plan` it won't download the provider. It downloads the file running `terraform init`.
- **terraform.tfstate.backup**: When we run`terraform apply` and we have changes to apply the terraform.tfstate file is updated but inmediatly before to rewrite that file it makes a backup in this file.
- **outputs.tf**: To print result information from created resources.
  	> `output "name" {value = aws_instance.name_instance.parameter}` We can find the possible parameters in the documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance 
  
  
# Commands
- `terraform init`: To initialize the project. It will download the providers and the plugins.
- `terraform plan`: To check the changes that will be made to the infrastructure.
- `terraform apply`: To apply the changes.
- `terraform destroy`: To destroy the infrastructure.
- `terraform validate`: To validate the configuration and programming errors.

# Project architecture
 - **main.tf**: The main file of the project. It contains the code to create the infrastructure.
This Terraform code is provisioning infrastructure on AWS.

The key components:

- Provider block to configure the AWS provider with the eu-west-1 region

- Data sources to lookup the default VPC and subnets in eu-west-1a and eu-west-1b availability zones

- Two EC2 instances (my_server_1 and my_server_2) launched in the different subnets, with user data to run a simple web server

- Application load balancer (ALB) spanning the two subnets

- Security group for the ALB allowing inbound traffic on port 80 and outbound to the instances on 8080

- Target group for the ALB to forward requests to the instances

- Security group for the instances allowing ingress from the ALB on 8080

Target group attachments to register the instances with the ALB target group

Listener on the ALB to forward incoming requests on port 80 to the target group

In short, it is about deploying a simple web server farm behind a load balancer, demonstrating the basic concepts of Terraform and AWS such as resources, data sources, security groups, load balancing and showing a possible infrastructure covering high availability.

<image src="firstServer.png" alt="Application schema" >
