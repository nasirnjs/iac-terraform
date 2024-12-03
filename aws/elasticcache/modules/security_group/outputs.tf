output "redis_sg_ids" {
  value = aws_security_group.redis_sg.id
}

output "redis_sg_name" {
    value = aws_security_group.redis_sg.name
}

# output "aurora_mysql_sg_id" {
#   value = aws_security_group.aurora_mysql.id
# }