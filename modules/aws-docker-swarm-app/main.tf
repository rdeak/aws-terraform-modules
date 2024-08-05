data "aws_security_group" "apps" {
  filter {
    name   = "group-name"
    values = [var.app_sg_name]
  }
}

resource "aws_security_group_rule" "app_rules" {
  for_each          = { for idx, rule in var.ports : idx => rule }
  type              = "ingress"
  from_port         = each.value[1]
  to_port           = each.value[1]
  protocol          = each.value[0]
  security_group_id = data.aws_security_group.apps.id
  # TODO allow only ALB
  cidr_blocks       = ["0.0.0.0/0"]
}