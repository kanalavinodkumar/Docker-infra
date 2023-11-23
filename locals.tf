locals {
  az = ["us-east-1a", "us-east-1b"]
  public_subnet_ids = aws_subnet.public[*].id
}