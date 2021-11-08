output "created" {
  value = [for s in aws_subnet.multi_az : s]
}

output "subnet_ids" {
  value = aws_subnet.multi_az.*.id
}

