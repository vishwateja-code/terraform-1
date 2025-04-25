output "ec2_instance_id" {
  value = module.web_server.instance_id
}

output "ec2_public_ip" {
  value = module.web_server.public_ip
}
output "my_bucket_id" {
  value = module.simple_s3.bucket_id
}
output "rds_instance_id" {
  value = module.my_rds.rds_instance_id
}

