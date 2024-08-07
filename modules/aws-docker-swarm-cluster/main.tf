locals {
  manager_nodes = var.total_managers - 1
}

resource "aws_instance" "docker_swarm_leader" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile = aws_iam_instance_profile.docker_swarm_node.id

  vpc_security_group_ids = [
    aws_security_group.docker_swarm_node.id,
    aws_security_group.docker_swarm_ssh.id,
    aws_security_group.docker_swarm_apps.id
  ]

  user_data = <<EOF
#!/bin/bash

dnf update -y

dnf install -y docker
usermod -a -G docker ec2-user
newgrp docker
systemctl start docker
systemctl enable docker

TOKEN=`curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 300"`
aws ssm put-parameter --name "/docker-swarm/private-ip" --value "$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)" --type "String"  --overwrite
aws ssm put-parameter --name "/docker-swarm/public-ip" --value "$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)" --type "String"  --overwrite

docker swarm init --advertise-addr "$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)"
docker network create -d overlay --opt encrypted --attachable swarm_network

aws ssm put-parameter --name "/docker-swarm/manger-token" --value "$(docker swarm join-token -q manager)" --type "SecureString"  --overwrite
aws ssm put-parameter --name "/docker-swarm/worker-token" --value "$(docker swarm join-token -q worker)" --type "SecureString"  --overwrite
  EOF

  tags = {
    Name = "docker_swarm_leader"
  }
}

resource "aws_instance" "docker_swarm_manager" {
  count         = local.manager_nodes
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile = aws_iam_instance_profile.docker_swarm_node.id

  vpc_security_group_ids = [
    aws_security_group.docker_swarm_node.id,
    aws_security_group.docker_swarm_ssh.id,
    aws_security_group.docker_swarm_apps.id
  ]

  user_data = <<EOF
#!/bin/bash

dnf update -y

dnf install -y docker
usermod -a -G docker ec2-user
newgrp docker
systemctl start docker
systemctl enable docker

docker swarm join \
  --token "$(aws ssm get-parameter --name "/docker-swarm/manger-token"  --query "Parameter.Value" --output text --with-decryption)" \
  "$(aws ssm get-parameter --name "/docker-swarm/private-ip" --query "Parameter.Value" --output text):2377"
  EOF

  depends_on = [
    aws_instance.docker_swarm_leader
  ]

  tags = {
    Name = "docker_swarm_instance_manager-${count.index}"
  }
}

