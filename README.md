# AWS EC2 Instance Base Terrafrom Module

Terraform module which is used as a base to manage autoscaled instances on AWS
The module performs the following functionality:

- Looks-up AMI ID
- Creates default security group
- Creates instance IAM Role with policy ARN attachments
- Generates cloud-init userdata
- Default tags
- Creates Launch Config
- Creates Autosclae Group(s)

## Usage

```yaml
#templates/cloud_config.tpl

repo_update: true
repo_upgrade: all

packages:
  - dnsmasq

write_files:
  - path: /etc/dnsmasq.d/forward.conf
    encoding:
    content: |
      server=10.54.5.2
runcmd:
  - systemctl daemon-reload
  - systemctl enable dnsmasq
  - systemctl restart dnsmasq
```

```hcl
data "template_file" "cloud_config" {
  template = "${file("${path.module}/templates/cloud_config.tpl")}"
}
```

```yaml
#templates/cloud_config_users.tpl
users:
  - default
  - name: ansible
    gecos: Ansible User
    groups: wheel
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ssh-rsa AAAAB.................
```

```hcl
data "template_file" "cloud_config_users" {
  template = "${file("${path.module}/templates/cloud_config_users.tpl")}"
}
```

```hcl
module "instance" {
  name   = "dev01"
  source  = "sailthru/asg-base/aws"
  version = "0.0.1"
  default_keypair             = "default"
  vpc_id                      = "vpc-123456788654434335465"
  vpc_zone_identifier         = ["subnet-01224455654534345546545"]
  associate_public_ip_address = true
  max_size               = 1
  min_size               = 1
  desired_capacity       = 1
  health_check_type      = "EC2"
  cloud_config           = "${var.cloud_config}"
  cloud_config_users     = "${var.cloud_config_users}"
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "dns-udp"
      cidr_blocks = "10.54.0.0/20"
    }
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ami_filter_name | AMI Filter name tag value | list | `<list>` | no |
| ami_filter_owner-alias | AMI Filter owner-alias tag value | list | `<list>` | no |
| ami_filter_virtualization_type | AMI Filter virtualization-type tag value | list | `<list>` | no |
| ami_id | AMI ID, setting this will disable the ami filter | string | `` | no |
| associate_public_ip_address | If true, the EC2 instances will have associated public IP address | string | `false` | no |
| cloud_config | Cloud config body: this can contain any valid cloud config configuration syntax | string | `` | no |
| cloud_config_users | Cloud config groups and users: this can contain any valid cloud config configuration syntax | string | `` | no |
| create_asg | Whether to create autoscaling group | string | `true` | no |
| create_lc | Whether to create launch configuration | string | `true` | no |
| default_cooldown | The amount of time, in seconds, after a scaling activity completes before another scaling activity can start | string | `300` | no |
| default_keypair | The key name to use for the instance | string | `` | no |
| default_policies | List of default policy ARN's. Pass an empty list to disable | list | `<list>` | no |
| desired_capacity | The number of Amazon EC2 instances that should be running in the group | string | - | yes |
| ebs_block_device | Additional EBS block devices to attach to the instance | list | `<list>` | no |
| ebs_optimized | If true, the launched EC2 instance will be EBS-optimized | string | `false` | no |
| egress_cidr_blocks | List of IPv4 CIDR ranges to use on all egress rules | list | `<list>` | no |
| egress_rules | List of egress rules to create by name | list | `<list>` | no |
| egress_with_cidr_blocks | List of egress rules to create where 'cidr_blocks' is used | list | `<list>` | no |
| egress_with_self | List of egress rules to create where 'self' is defined | list | `<list>` | no |
| egress_with_source_security_group_id | List of egress rules to create where 'source_security_group_id' is used | list | `<list>` | no |
| enable_monitoring | Enables/disables detailed monitoring. This is enabled by default. | string | `true` | no |
| enabled_metrics | A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances | list | `<list>` | no |
| ephemeral_block_device | Customize Ephemeral (also known as Instance Store) volumes on the instance | list | `<list>` | no |
| force_delete | Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling | string | `false` | no |
| health_check_grace_period | Time (in seconds) after instance comes into service before checking health | string | `300` | no |
| health_check_type | Controls how health checking is done. Values are - EC2 and ELB | string | - | yes |
| iam_policies | List of policy ARN's to attatch to instance role | list | `<list>` | no |
| ingress_cidr_blocks | List of IPv4 CIDR ranges to use on all ingress rules | list | `<list>` | no |
| ingress_rules | List of ingress rules to create by name | list | `<list>` | no |
| ingress_with_cidr_blocks | List of ingress rules to create where 'cidr_blocks' is used | list | `<list>` | no |
| ingress_with_self | List of ingress rules to create where 'self' is defined | list | `<list>` | no |
| ingress_with_source_security_group_id | List of ingress rules to create where 'self' is defined | list | `<list>` | no |
| instance_type | The size of instance to launch | string | `t3.micro` | no |
| load_balancers | A list of elastic load balancer names to add to the autoscaling group names | list | `<list>` | no |
| max_size | The maximum size of the auto scale group | string | - | yes |
| metrics_granularity | The granularity to associate with the metrics to collect. The only valid value is 1Minute | string | `1Minute` | no |
| min_elb_capacity | Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes | string | `0` | no |
| min_size | The minimum size of the auto scale group | string | - | yes |
| name | Resource name. This will be used as a tag prefix | string | - | yes |
| placement_group | The Placement Group to start the instance in | string | `` | no |
| placement_tenancy | The tenancy of the instance. Valid values are 'default' or 'dedicated' | string | `default` | no |
| protect_from_scale_in | Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events. | string | `false` | no |
| recreate_asg_when_lc_changes | Whether to recreate an autoscaling group when launch configuration changes | string | `false` | no |
| root_block_device | Customize details about the root block device of the instance. See Block Devices below for details | list | `<list>` | no |
| spot_price | The price to use for reserving spot instances | string | `` | no |
| suspended_processes | A list of processes to suspend for the AutoScaling Group. The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer. Note that if you suspend either the Launch or Terminate process types, it can prevent your autoscaling group from functioning properly. | list | `<list>` | no |
| tags | Additional instance tags | map | `<map>` | no |
| target_group_arns | A list of aws_alb_target_group ARNs, for use with Application Load Balancing | list | `<list>` | no |
| termination_policies | A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default | list | `<list>` | no |
| vpc_id | AWS VPC ID | string | - | yes |
| vpc_security_group_ids | List of VPC security group ID's to attach to the instance | list | `<list>` | no |
| vpc_zone_identifier | List of private subnets to launch instnaces in | list | `<list>` | no |
| wait_for_capacity_timeout | A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior. | string | `10m` | no |
| wait_for_elb_capacity | Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over min_elb_capacity behavior. | string | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| this_autoscaling_group_arn | The ARN for this AutoScaling Group |
| this_autoscaling_group_default_cooldown | Time between a scaling activity and the succeeding scaling activity |
| this_autoscaling_group_desired_capacity | The number of Amazon EC2 instances that should be running in the group |
| this_autoscaling_group_health_check_grace_period | Time after instance comes into service before checking health |
| this_autoscaling_group_health_check_type | EC2 or ELB. Controls how health checking is done |
| this_autoscaling_group_id | The autoscaling group id |
| this_autoscaling_group_max_size | The maximum size of the autoscale group |
| this_autoscaling_group_min_size | The minimum size of the autoscale group |
| this_autoscaling_group_name | The autoscaling group name |
| this_iam_role_arn | The Amazon Resource Name (ARN) specifying the role |
| this_iam_role_create_date | The creation date of the IAM role |
| this_iam_role_name | The name of the role |
| this_iam_role_unique_id | The stable and unique string identifying the role |
| this_instance_profile_arn | The ARN assigned by AWS to the instance profile |
| this_instance_profile_create_date | The creation timestamp of the instance profile |
| this_instance_profile_id | The instance profile's ID |
| this_instance_profile_name | The instance profile's name |
| this_instance_profile_path | The path of the instance profile in IAM |
| this_instance_profile_role | The role assigned to the instance profile |
| this_instance_profile_unique_id | The unique ID assigned by AWS |
| this_launch_configuration_id | The ID of the launch configuration |
| this_launch_configuration_name | The name of the launch configuration |
| this_security_group_description | The description of the security group |
| this_security_group_id | The ID of the security group |
| this_security_group_name | The name of the security group |
| this_security_group_owner_id | The owner ID |
| this_security_group_vpc_id | The VPC ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sailthru](https://github.com/sailthru).

## License

Apache 2 Licensed. See LICENSE for full details.
