
variable "ami_description" {
  type    = string
  default = "AMI with amazonlinux2 arm64 image by slpcat"
}

variable "ami_name" {
  type = string
  default = "amazonlinux2-basic-arm64-{{timestamp}}"
}

variable "ami_users" {
  type    = string
  default = "${env("AMI_USERS")}"
}

variable "arch" {
  type = string
  default = "arm64"
}

variable "associate_public_ip_address" {
  type    = string
  default = "true"
}

variable "vpc" {
  type    = string
  default = "${env("BUILD_VPC_ID")}"
}

variable "subnet_id" {
  type    = string
  default = "${env("BUILD_SUBNET_ID")}"
}

variable "aws_access_key_id" {
  type    = string
  default = "${env("AWS_ACCESS_KEY_ID")}"
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "aws_secret_access_key" {
  type    = string
  default = "${env("AWS_SECRET_ACCESS_KEY")}"
}

variable "aws_session_token" {
  type    = string
  default = "${env("AWS_SESSION_TOKEN")}"
}

variable "cleanup_image" {
  type    = string
  default = "true"
}

variable "creator" {
  type    = string
  default = "${env("USER")}"
}

variable "encrypted" {
  type    = string
  default = "false"
}

variable "instance_type" {
  type = string
  default = "t4g.micro"
}

variable "kms_key_id" {
  type    = string
  default = ""
}

variable "launch_block_device_mappings_volume_size" {
  type    = string
  default = "8"
}

variable "remote_folder" {
  type    = string
  default = ""
}

variable "security_group_id" {
  type    = string
  default = ""
}

variable "sonobuoy_e2e_registry" {
  type    = string
  default = ""
}

variable "source_ami_filter_name" {
  type    = string
  default = "amzn2-ami-hvm-2.0.2021*-arm64-gp2"
}

variable "source_ami_id" {
  type    = string
  default = ""
}

variable "source_ami_owners" {
  type    = string
  default = "137112412989"
}

variable "ssh_interface" {
  type    = string
  default = "public_ip"
}

variable "ssh_username" {
  type    = string
  default = "ec2-user"
}

variable "temporary_security_group_source_cidrs" {
  type    = string
  default = "0.0.0.0/0"
}

data "amazon-ami" "autogenerated_1" {
  filters = {
    architecture        = "${var.arch}"
    name                = "${var.source_ami_filter_name}"
    root-device-type    = "ebs"
    state               = "available"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["${var.source_ami_owners}"]
  region      = "${var.aws_region}"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "autogenerated_1" {
  ami_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/xvda"
    volume_size           = 8
    volume_type           = "gp2"
  }
  ami_description             = "${var.ami_description})"
  ami_name                    = "${var.ami_name}"
  #ami_users                   = "${var.ami_users}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  encrypt_boot                = "${var.encrypted}"
  instance_type               = "${var.instance_type}"
  kms_key_id                  = "${var.kms_key_id}"
  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/xvda"
    volume_size           = "${var.launch_block_device_mappings_volume_size}"
    volume_type           = "gp2"
  }
  region = "${var.aws_region}"
  vpc_id = "${var.vpc}"
  run_tags = {
    creator = "${var.creator}"
  }
  security_group_id = "${var.security_group_id}"
  #snapshot_users    = "${var.ami_users}"
  source_ami        = "${data.amazon-ami.autogenerated_1.id}"
  #ssh_interface     = "${var.ssh_interface}"
  ssh_pty           = true
  ssh_username      = "${var.ssh_username}"
  subnet_id         = "${var.subnet_id}"
  tags = {
    Name          = "${var.ami_name}"
    created       = "${local.timestamp}"
    source_ami_id = "${var.source_ami_id}"
  }
  #temporary_security_group_source_cidrs = "${var.temporary_security_group_source_cidrs}"
}

build {
  sources = ["source.amazon-ebs.autogenerated_1"]

  provisioner "shell" {
    expect_disconnect = false
    pause_before      = "20s"
    inline = [
      "sudo yum install -y python3 python3-pip",
      "sudo pip3 install -U pip",
      "sudo pip3 install netaddr pbr hvac jmespath ruamel.yaml",
      "sudo pip3 install ansible"
    ]
  }

  provisioner "ansible-local" {
    role_paths    = [
      "../roles/init-node-amazonlinux2"
     # "../roles/install-zabbix"
    ]
    group_vars    = "../group_vars"
    playbook_dir  = "../playbooks"
    playbook_file = "../playbooks/init-node-amazonlinux2.yml"
    #inventory_groups =
    #command =
    extra_arguments = [
      "-b -v"
      #"--vault-password-file=/bin/cat",
      #"user `ansible_extra_arguments`}}",
    #  "--extra-vars deploy_env=groupclass"
    ]
  }

  provisioner "shell" {
    expect_disconnect = false
    inline = [
      "echo === System Cleanup ===",
      "sudo rm -f /root/.bash_history",
      "sudo rm -f /home/${var.ssh_username}/.bash_history",
      "sudo rm -f /var/log/wtmp",
      "sudo rm -f /var/log/btmp",
      "sudo rm -rf /var/log/installer",
      "sudo rm -rf /var/lib/cloud/instances",
      "sudo rm -rf /tmp/* /var/tmp/* /tmp/.*-unix",
      "sudo find /var/cache -type f -delete",
      "sudo find /var/log -type f | while read f; do echo -n '' | sudo tee $f > /dev/null; done;",
      "sudo rm -rf /var/lib/cloud/*",
      "sudo sync"
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
  post-processor "manifest" {
    output     = "${var.ami_name}-manifest.json"
    strip_path = true
  }
}
