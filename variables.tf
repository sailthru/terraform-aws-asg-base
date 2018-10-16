variable "name" {
  description = "Resource name. This will be used as a tag prefix"
}

variable "ami_filter_name" {
  description = "AMI Filter name tag value"
  default = ["amzn2-ami-*-x86_64-gp2"]
}

variable "ami_filter_virtualization_type" {
  description = "AMI Filter virtualization-type tag value"
  default = ["hvm"]
}

variable "ami_filter_owner-alias" {
  description = "AMI Filter owner-alias tag value"
  default = ["amazon"]
}

variable "iam_policies" {
  description = "List of policy ARN's to attatch to instance role"
  default = []
}

variable  "default_policies" {
  description = "List of default policy ARN's. Pass an empty list to disable"
  default = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"]
}

variable "vpc_id" {
  description = "AWS VPC ID"
  type = "string"
}

# Launch configuration

variable "ami_id" {
  description = "AMI ID, setting this will disable the ami filter"
  default = ""
}

variable "create_lc" {
  description = "Whether to create launch configuration"
  default     = true
}

variable "create_asg" {
  description = "Whether to create autoscaling group"
  default     = true
}

variable "recreate_asg_when_lc_changes" {
  description = "Whether to recreate an autoscaling group when launch configuration changes"
  default     = false
}

variable "instance_type" {
  description = "The size of instance to launch"
  default     = "t3.micro"
}

variable "default_keypair" {
  description = "The key name to use for the instance"
  default     = ""
}

variable "associate_public_ip_address" {
  description = "If true, the EC2 instances will have associated public IP address"
  default     = false
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring. This is enabled by default."
  default     = true
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = false
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  default     = []
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  default     = []
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  default     = []
}

variable "spot_price" {
  description = "The price to use for reserving spot instances"
  default     = ""
}

variable "placement_tenancy" {
  description = "The tenancy of the instance. Valid values are 'default' or 'dedicated'"
  default     = "default"
}

# Autoscaling group
variable "vpc_zone_identifier" {
  description = "List of private subnets to launch instnaces in"
  default = []
}

variable "max_size" {
  description = "The maximum size of the auto scale group"
}

variable "min_size" {
  description = "The minimum size of the auto scale group"
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  default     = 300
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  default     = 300
}

variable "health_check_type" {
  description = "Controls how health checking is done. Values are - EC2 and ELB"
}

variable "force_delete" {
  description = "Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
  default     = false
}

variable "load_balancers" {
  description = "A list of elastic load balancer names to add to the autoscaling group names"
  default     = []
}

variable "target_group_arns" {
  description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing"
  default     = []
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default"
  type        = "list"
  default     = ["Default"]
}

variable "suspended_processes" {
  description = "A list of processes to suspend for the AutoScaling Group. The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer. Note that if you suspend either the Launch or Terminate process types, it can prevent your autoscaling group from functioning properly."
  default     = []
}

variable "tags" {
  description = "Additional instance tags"
  default = {}
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  default     = ""
}

variable "metrics_granularity" {
  description = "The granularity to associate with the metrics to collect. The only valid value is 1Minute"
  default     = "1Minute"
}

variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances"
  type        = "list"

  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  default     = "10m"
}

variable "min_elb_capacity" {
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
  default     = 0
}

variable "wait_for_elb_capacity" {
  description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over min_elb_capacity behavior."
  default     = false
}

variable "protect_from_scale_in" {
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events."
  default     = false
}

# Security groups
variable "vpc_security_group_ids" {
  description = "List of VPC security group ID's to attach to the instance"
  default = []
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  default = []
}
variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  default = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  default = []
}

variable "ingress_with_self" {
  default = []
  description = "List of ingress rules to create where 'self' is defined"
}

variable "ingress_with_source_security_group_id" {
  description = "List of ingress rules to create where 'self' is defined"
  default = []
}

variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  default = []
}

variable "egress_rules" {
  description = "List of egress rules to create by name"
  default = []
}

variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  default = []
}

variable "egress_with_self" {
  description = "List of egress rules to create where 'self' is defined"
  default = []
}

variable "egress_with_source_security_group_id" {
  description = "List of egress rules to create where 'source_security_group_id' is used"
  default = []
}

# Cloud init
variable "cloud_config_users" {
  description = "Cloud config groups and users: this can contain any valid cloud config configuration syntax"
  default = ""
}

variable "cloud_config" {
  description = "Cloud config body: this can contain any valid cloud config configuration syntax"
  default = ""
}

# Defaults
locals {
  default_tags = { 
    "Name"      = "${var.name}"
    "Terraform" = true
  }
  
  iam_policies = "${
    sort(distinct(concat(var.iam_policies,var.default_policies)))
  }"
}
