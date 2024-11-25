variable "alb_sg_name" {
    type = string
    description = "Allow TLS inbound traffic and all outbound traffic"
}
# variable "aurora_mysql_sg_id" {
#     type = string
#     description = "Allow TLS inbound traffic and all outbound traffic"
# }
variable "ym_vpc_id" {
    type = string
}
variable "environment" {
    type = string
    description = "value"
}

