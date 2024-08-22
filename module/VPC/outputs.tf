output "tf_vpc" {
  value = aws_vpc.tf_vpc.id
}
#OutputPublic
output "tf_public_subnet_us_east_1a" {
  value = aws_subnet.tf_public_subnet_us_east_1a.id
}
output "tf_public_subnet_us_east_1b" {
  value = aws_subnet.tf_public_subnet_us_east_1b.id
}

#OutputsPrivate

output "tf_private_subnet_us_east_1a_app" {
  value = aws_subnet.tf_private_subnet_us_east_1a_app.id
}
output "tf_private_subnet_us_east_1b_app" {
  value = aws_subnet.tf_private_subnet_us_east_1b_app.id
}
output "tf_private_subnet_us_east_1a_data" {
  value = aws_subnet.tf_private_subnet_us_east_1a_data.id
}

output "tf_private_subnet_us_east_1b_data" {
  value = aws_subnet.tf_private_subnet_us_east_1b_data.id
}
output "tf_sg_asg" {
  value = aws_security_group.tf_sg_asg.id
}

output "tf_sg_alb" {
  value = aws_security_group.tf_sg_asg.id
}

output "tf_sg_rds" {
  value = aws_security_group.tf_sg_rds.id
}
output "tf_sg_efs" {
  value = aws_security_group.tf_sg_efs.id
}

output "tf_sg_basionhost" {
  value = aws_security_group.tf_basion_host.id
}

output "tf_sg_elasticache" {
  value = aws_security_group.tf_sg_elasticache.id
}