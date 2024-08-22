resource "aws_efs_file_system" "tf_efs" {
  encrypted = false
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "${var.project_name}-efs"
  }
}

# Tạo Mount Target cho Subnet 1
resource "aws_efs_mount_target" "mount_target_1" {
  file_system_id = aws_efs_file_system.tf_efs.id
  subnet_id      = var.private_subnet_1a_data
  security_groups = [ var.tf_sg_efs ]  
}

# Tạo Mount Target cho Subnet 2
resource "aws_efs_mount_target" "mount_target_2" {
  file_system_id = aws_efs_file_system.tf_efs.id
  subnet_id      = var.private_subnet_1b_data
  security_groups = [ var.tf_sg_efs ]  
}