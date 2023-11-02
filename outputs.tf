output "sg" {
  value = aws_security_group.sg.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}