# Find Amazon Linux AMI
data "aws_ami" "this_ami" {
  most_recent = true # Find and return the most recent match. \m/

  filter {
    name = "name"
    values = "${var.ami_filter_name}"
  }
  filter {
    name = "virtualization-type"
    values = "${var.ami_filter_virtualization_type}"
  }
  filter {
    name = "owner-alias"
    values = "${var.ami_filter_owner-alias}"
  }
}

# IAM roles for the instances
data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this_instance_role" {
  name_prefix        = "${var.name}-instance-role-"
  path               = "/system/"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

resource "aws_iam_instance_profile" "this_instance_profile" {
  name_prefix = "${var.name}-instance-profile-"
  role        = "${aws_iam_role.this_instance_role.name}"
}

resource "aws_iam_role_policy_attachment" "attach_iam_policies" {
  count      = "${length(local.iam_policies)}"
  role       = "${aws_iam_role.this_instance_role.name}"
  policy_arn = "${local.iam_policies[count.index]}"
}

# Default security group
module "instance_default_sg" {
  source = "terraform-aws-modules/security-group/aws"
  name                     = "${var.name}-default"
  description              = "Default instance security group"
  vpc_id                   = "${var.vpc_id}"
  ingress_cidr_blocks      = "${var.ingress_cidr_blocks}"
  ingress_rules            = "${var.ingress_rules}"
  ingress_with_self        = "${var.ingress_with_self}"
  egress_cidr_blocks       = "${var.egress_cidr_blocks}"
  egress_rules             = "${var.egress_rules}"
  ingress_with_cidr_blocks = "${var.ingress_with_cidr_blocks}"
  egress_with_cidr_blocks  = "${var.egress_with_cidr_blocks}"
}

# Generate the cloud init
data "template_cloudinit_config" "cloud-init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content     = "${var.cloud_config_users}"
  }

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content     = "${var.cloud_config}"
  }
}

module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"
  name = "${var.name}"

  # Launch config

  lc_name              = "${var.name}-lc"
  image_id             = "${ var.ami_id == "" ? data.aws_ami.this_ami.id : var.ami_id}"
  
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.this_instance_profile.id}"
  key_name             = "${var.default_keypair}"
  recreate_asg_when_lc_changes = "${var.recreate_asg_when_lc_changes}"

  security_groups = ["${
    sort(
      distinct(
        concat(
          var.vpc_security_group_ids,
          list(module.instance_default_sg.this_security_group_id)
        )
      )
    )
  }"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data         = "${data.template_cloudinit_config.cloud-init.rendered}"
  enable_monitoring = "${var.enable_monitoring}"
  ebs_optimized     = "${var.ebs_optimized}"
  root_block_device = "${var.root_block_device}"
  ebs_block_device  = "${var.ebs_block_device}"
  ephemeral_block_device  = "${var.ephemeral_block_device}"
  spot_price              = "${var.spot_price}"

  # Auto scaling group
  asg_name                  = "${var.name}-asg"
  vpc_zone_identifier       = "${var.vpc_zone_identifier}"
  health_check_type         = "${var.health_check_type}"
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  desired_capacity          = "${var.desired_capacity}"
  default_cooldown          = "${var.default_cooldown}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"
  force_delete              = "${var.force_delete}"
  load_balancers            = "${var.load_balancers}"
  target_group_arns         = "${var.target_group_arns}"
  termination_policies      = "${var.termination_policies}"
  suspended_processes       = "${var.suspended_processes}"
  tags_as_map               = "${ merge(local.default_tags, var.tags) }"
  placement_group           = "${var.placement_group}"
  metrics_granularity       = "${var.metrics_granularity}"
  enabled_metrics           = "${var.enabled_metrics}"
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"
  min_elb_capacity          = "${var.min_elb_capacity}"
  wait_for_elb_capacity     = "${var.wait_for_elb_capacity}"
  protect_from_scale_in     = "${var.protect_from_scale_in}"
}
