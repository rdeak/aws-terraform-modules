resource "aws_security_group" "docker_swarm_ssh" {
  name        = "docker_swarm_ssh"
  description = "Allow SSH access to nodes"

  tags = {
    Name = "docker_swarm_ssh"
  }
}

resource "aws_security_group" "docker_swarm_node" {
  name        = "docker_swarm_node"
  description = "Allow ports used by Docker Swarm"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "docker_swarm_node"
  }
}

resource "aws_security_group_rule" "docker_swarm_allow_manager_nodes" {
  type                     = "ingress"
  from_port                = 2377
  to_port                  = 2377
  protocol                 = "tcp"
  security_group_id        = aws_security_group.docker_swarm_node.id
  source_security_group_id = aws_security_group.docker_swarm_node.id
}

resource "aws_security_group_rule" "docker_swarm_allow_overlay_network_tcp" {
  type                     = "ingress"
  from_port                = 7946
  to_port                  = 7946
  protocol                 = "tcp"
  security_group_id        = aws_security_group.docker_swarm_node.id
  source_security_group_id = aws_security_group.docker_swarm_node.id
}

resource "aws_security_group_rule" "docker_swarm_allow_overlay_network_udp" {
  type                     = "ingress"
  from_port                = 7946
  to_port                  = 7946
  protocol                 = "udp"
  security_group_id        = aws_security_group.docker_swarm_node.id
  source_security_group_id = aws_security_group.docker_swarm_node.id
}

resource "aws_security_group_rule" "docker_swarm_allow_overlay_network_vxlan" {
  type                     = "ingress"
  from_port                = 4789
  to_port                  = 4789
  protocol                 = "udp"
  security_group_id        = aws_security_group.docker_swarm_node.id
  source_security_group_id = aws_security_group.docker_swarm_node.id
}


resource "aws_security_group_rule" "docker_swarm_allow_overlay_network_enc" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = 50
  security_group_id        = aws_security_group.docker_swarm_node.id
  source_security_group_id = aws_security_group.docker_swarm_node.id
}

# TODO replace with ELB?
resource "aws_security_group" "docker_swarm_apps" {
  name        = "docker_swarm_apps"
  description = "Allow ports used by containers by apps in Docker Swarm"

  tags = {
    Name = "docker_swarm_apps"
  }
}
