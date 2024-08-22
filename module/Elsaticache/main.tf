resource "aws_elasticache_subnet_group" "tf_memcached_subnet_group" {
  name       = "memcached-subnet-group"
  subnet_ids = [var.private_subnet_1a_data, var.private_subnet_1b_data]

  tags = {
    Name = "${var.project_name}-memcached-subnet-group"
  }
}

resource "aws_elasticache_cluster" "tf_memcached_cluster" {
  cluster_id           = "memcached-cluster"
  engine               = "memcached"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 2  
  parameter_group_name = "default.memcached1.6"

  subnet_group_name    = aws_elasticache_subnet_group.tf_memcached_subnet_group.name
  security_group_ids   = [var.tf_sg_elasticache]

  tags = {
    Name = "${var.project_name}-memcached-cluster"
  }
}
