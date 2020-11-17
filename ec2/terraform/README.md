### Deployment on AWS systems
To deploy the client nodes on AWS EC2 instances, we need 3 things: 
1. Terraform scripts: These will allow us to provision the EC2 instance, select the types, as well as create the security groups with necessary outbound and inbound ports. This is the `00-aws-infra.tf` for AWS.
2. Terraform variable script: This is where we mention the specific default values of the variables. This is the `variables.tf` script. We don't use a `tfvars` as the deployment is quite simple.
3. We need `ansible` scripts which will allow us to install docker, docker-compose on our EC2 nodes, `scp` our project folder and then install miniconda and other friends including PyTorch, Numpy etc.

On successful application of the terraform scripts, we instruct terraform to create an `inventory` file containing the node names and public ip addresses via `01-create-inv.tf`. This will be the input to the `ansible` commands. For e.g.:
```
[swarm-master]
100.25.111.33 ansible_ssh_user=ubuntu
[swarm-nodes]
54.173.88.147 ansible_ssh_user=ubuntu
184.72.150.247 ansible_ssh_user=ubuntu
```
#### Deploy on AWS
```bash
    >> terraform plan
    >> terraform apply 
```
#### Orchestrate stuff using Ansible Playbook
```bash
    >> ./deploy-ansible.sh # orchestrates using ansible
```
