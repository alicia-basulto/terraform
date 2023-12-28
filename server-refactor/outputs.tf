output "dns_public_server" {
    value = [for server in aws_instance.server : "http://${server.public_dns}:${var.server_port}"]
    description = "Public DNS of the server"
}


output "dns_load_balancer" {
    value = "http://${aws_lb.alb.dns_name}:80"
    description = "Public DNS of the server"
}


output "ip_v4_server" {
    value = [for instance in aws_instance.server : instance.public_ip]
    description = "Public  IPV4 of the server"
}