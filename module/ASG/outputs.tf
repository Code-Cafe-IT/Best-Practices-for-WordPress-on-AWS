output "target-groups-arn" {
  value = aws_lb_target_group.tf-tgroups.arn
}
output "target-groups" {
  value = aws_lb_target_group.tf-tgroups
}