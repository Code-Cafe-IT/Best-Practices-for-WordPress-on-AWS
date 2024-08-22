output "tf_alb_arn" {
  value = aws_alb.tf_alb.arn
}
output "tf_alb" {
  value = aws_alb.tf_alb
}

output "tf_alb_dns" {
  value = aws_alb.tf_alb.dns_name
}