output "instance_id" {
  description = "Instance id of the deployed instance"
  value       = aws_instance.web.id
}
