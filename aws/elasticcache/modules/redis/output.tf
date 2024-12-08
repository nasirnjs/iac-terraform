output "redis_endpoint" {
  value = aws_elasticache_replication_group.quick_ops_redis.primary_endpoint_address
  description = "The primary endpoint address of the Redis replication group"
}
