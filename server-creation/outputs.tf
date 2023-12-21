output "dns_publica_server_1" {
    value = "http://${aws_instance.my_server_1.public_dns}:8080"
    description = "Public DNS of the server"
}
output "dns_publica_server_2" {
    value = "http://${aws_instance.my_server_2.public_dns}:8080"
    description = "Public DNS of the server"
}

output "dns_load_balancer" {
    value = "http://${aws_lb.alb.dns_name}:80"
    description = "Public DNS of the server"
}

output "ip_v4_server_1" {
    value = aws_instance.my_server_1.public_ip
    description = "Public  IPV4 of the server"
}
output "ip_v4_server_2" {
    value = aws_instance.my_server_1.public_ip
    description = "Public  IPV4 of the server"
}