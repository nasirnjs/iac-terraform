output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_sg_name" {
    value = aws_security_group.alb_sg.name
}
output "aurora_mysql_sg_id" {
  value = aws_security_group.aurora_mysql.id
}