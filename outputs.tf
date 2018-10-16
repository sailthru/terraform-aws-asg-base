# Autoscaling
output "this_launch_configuration_id" {
  description = "The ID of the launch configuration"
  value       = "${module.asg.this_launch_configuration_id}"
}

output "this_launch_configuration_name" {
  description = "The name of the launch configuration"
  value       = "${module.asg.this_launch_configuration_name}"
}

output "this_autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = "${module.asg.this_autoscaling_group_id}"
}

output "this_autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = "${module.asg.this_autoscaling_group_name}"
}

output "this_autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = "${module.asg.this_autoscaling_group_arn}"
}

output "this_autoscaling_group_min_size" {
  description = "The minimum size of the autoscale group"
  value       = "${module.asg.this_autoscaling_group_min_size}"
}

output "this_autoscaling_group_max_size" {
  description = "The maximum size of the autoscale group"
  value       = "${module.asg.this_autoscaling_group_max_size}"
}

output "this_autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = "${module.asg.this_autoscaling_group_desired_capacity}"
}

output "this_autoscaling_group_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = "${module.asg.this_autoscaling_group_default_cooldown}"
}

output "this_autoscaling_group_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = "${module.asg.this_autoscaling_group_health_check_grace_period}"
}

output "this_autoscaling_group_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  value       = "${module.asg.this_autoscaling_group_health_check_type}"
}

# IAM
output "this_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the role"
  value = "${ element(concat(aws_iam_role.this_instance_role.*.arn, list("")), 0) }"
}

output "this_iam_role_create_date" {
  description = "The creation date of the IAM role"
  value = "${ element(concat(aws_iam_role.this_instance_role.*.create_date, list("")), 0) }"
}

output "this_iam_role_unique_id" {
  description = "The stable and unique string identifying the role"
  value = "${ element(concat(aws_iam_role.this_instance_role.*.unique_id, list("")), 0) }"
}

output "this_iam_role_name" {
  description = "The name of the role"
  value = "${ element(concat(aws_iam_role.this_instance_role.*.name, list("")), 0) }"
}

output "this_instance_profile_id" {
  description = "The instance profile's ID"
  value = "${ element(concat(aws_iam_instance_profile.this_instance_profile.*.id, list("")), 0) }"
}

output "this_instance_profile_arn" {
  description = "The ARN assigned by AWS to the instance profile"
  value = "${ element(concat(aws_iam_instance_profile.this_instance_profile.*.arn, list("")), 0) }"
}

output "this_instance_profile_create_date" {
  description = "The creation timestamp of the instance profile"
  value = "${ element(concat(aws_iam_instance_profile.this_instance_profile.*.create_date, list("")), 0) }"
}

output "this_instance_profile_name" {
  description = "The instance profile's name"
  value = "${ element(concat(aws_iam_instance_profile.this_instance_profile.*.name, list("")), 0) }"
}

output "this_instance_profile_path" {
  description = "The path of the instance profile in IAM"
  value = "${ element(concat(aws_iam_instance_profile.this_instance_profile.*.path, list("")), 0) }"
}

output "this_instance_profile_role" {
  description = "The role assigned to the instance profile"
  value = "${ element(concat(aws_iam_instance_profile.this_instance_profile.*.role, list("")), 0) }"
}

output "this_instance_profile_unique_id" {
  description = "The unique ID assigned by AWS"
  value = "${ element(concat(aws_iam_instance_profile.this_instance_profile.*.unique_id, list("")), 0) }"
}

# Security Group
output "this_security_group_id" {
  description = "The ID of the security group"
  value       = "${module.instance_default_sg.this_security_group_id}"
}

output "this_security_group_vpc_id" {
  description = "The VPC ID"
  value       = "${module.instance_default_sg.this_security_group_vpc_id}"
}

output "this_security_group_owner_id" {
  description = "The owner ID"
  value       = "${module.instance_default_sg.this_security_group_owner_id}"
}

output "this_security_group_name" {
  description = "The name of the security group"
  value       = "${module.instance_default_sg.this_security_group_name}"
}

output "this_security_group_description" {
  description = "The description of the security group"
  value       = "${module.instance_default_sg.this_security_group_description}"
}
