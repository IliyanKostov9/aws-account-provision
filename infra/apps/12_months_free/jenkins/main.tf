module "ec2_jenkins" {
  source                   = "../../../modules/aws/ec2"
  env                      = var.env
  app_name                 = var.app_name
  ec2_name                 = var.ec2_name
  ec2_ami                  = var.ec2_ami
  ec2_instance_type        = var.ec2_instance_type
  ec2_tags                 = var.ec2_tags
  ec2_key_pair_name        = var.ec2_key_pair_name
  sg_ingress_port          = var.sg_ingress_port
  ec2_key_pair_public_key  = var.ec2_key_pair_public_key
  ec2_remote_exec_commands = var.ec2_remote_exec_commands
}

module "jenkins_lambda_cloud_iam_user" {
  source               = "../../../modules/aws/iam/user"
  iam_user             = var.iam_user
  iam_path             = var.iam_path
  tags                 = var.tags
  iam_policy_actions   = var.iam_policy_actions
  iam_policy_resources = var.iam_policy_resources
}
