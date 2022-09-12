output "ecs_security_group_id" {
  value       = aws_security_group.app_sg.id
  description = "ECS Security Group ID"
}