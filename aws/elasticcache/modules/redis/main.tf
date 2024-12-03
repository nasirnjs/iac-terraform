# # If you only need a single Redis instance (no clustering or replication):

# resource "aws_elasticache_cluster" "quick_ops" {
#   tags = {
#     Name            = format("%s_quickops_redish", var.environment)
#     Environment     = var.environment
#   }
#   cluster_id        = "quickops-redish"
#   engine            = "redis"
#   node_type         = "cache.t3.micro"
#   num_cache_nodes   = 1
#   port              = 6379
#   apply_immediately = true
#   security_group_ids    = [var.redis_sg_ids]
#   subnet_group_name     = aws_elasticache_subnet_group.quick_ops_subnet_group.id
# }
# resource "aws_elasticache_subnet_group" "quick_ops_subnet_group" {
#   name       = "we-redis-subnet-group"
#   subnet_ids = [var.private_subnet_az1, var.private_subnet_az2]

#   tags = {
#     Name        = "quick_ops_subnet_group"
#     Environment = var.environment
#   }
# }
resource "aws_elasticache_replication_group" "quick_ops_redis" {
  replication_group_id          = "quickops-replication"
  description                   = "QuickOps Redis Replication Group"
  engine                        = "redis"
  engine_version                = "5.0.6"
  node_type                     = "cache.t3.micro"
  num_cache_clusters            = 1
  port                          = 6379
  automatic_failover_enabled    = false
  apply_immediately             = true
  transit_encryption_enabled = true
  auth_token                 = "abcdefgh1234567890"
  auth_token_update_strategy = "ROTATE"
  security_group_ids            = [var.redis_sg_ids]
  subnet_group_name             = aws_elasticache_subnet_group.quick_ops_subnet_group.id

  tags = {
    Name        = format("%s_quickops_redis", var.environment)
    Environment = var.environment
  }
}

resource "aws_elasticache_subnet_group" "quick_ops_subnet_group" {
  name       = "quickops-redis-subnet-group"
  subnet_ids = [var.private_subnet_az1, var.private_subnet_az2]

  tags = {
    Name        = "quick_ops_subnet_group"
    Environment = var.environment
  }
}
