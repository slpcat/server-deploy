
variable "format" {
  type    = string
  default = "qcow2"
}

variable "password" {
  type    = string
  default = "packer"
}

variable "user" {
  type    = string
  default = "debian"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "qemu" "autogenerated_1" {
  accelerator       = "tcg"
  qemu_binary       = "qemu-system-x86_64"
  machine_type      = "pc"
  #boot_command      = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos7.ks<enter><wait>"]
  boot_wait         = "10s"
  disk_image        = true
  #use_backing_file  = true
  qemu_img_args {
    create = ["-F", "qcow2"]
  }

  cpus              = 2
  memory            = 1024
  #firmware           = "QEMU_EFI.fd"
  disk_interface    = "virtio"
  disk_size         = 8192
  format            = "${var.format}"
  headless          = true
  #http_directory    = "../http"
  iso_checksum      = "cf93045a4abae87ed3512cbefb293457b11db2c88975ba7852e5a2fb2e06b403b1a1838736bc3bb55958f7226228f5e763da4544b1a8d1d4d7b1063ce5b08d59"
  iso_url           = "https://cloud.debian.org/images/cloud/bullseye/20211011-792/debian-11-genericcloud-amd64-20211011-792.qcow2"
  net_device        = "virtio-net"
  output_directory  = "build"
  qemuargs          = [["-serial", "mon:stdio"], ["-cdrom", "cloud-init-imgs/debian-seed.img"]]
  shutdown_command  = "echo '${var.password}'|sudo -S shutdown -h now"
  ssh_password      = "${var.password}"
  ssh_username      = "${var.user}"
  ssh_wait_timeout  = "60m"
  vm_name           = "debian11-${local.timestamp}.${var.format}"
}

build {
  sources = ["source.qemu.autogenerated_1"]

  provisioner "shell" {
    expect_disconnect = false
    pause_before      = "20s"
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3 python3-pip",
      "sudo pip3 install -U pip",
      "sudo pip3 install netaddr pbr hvac jmespath ruamel.yaml",
      "sudo pip3 install ansible"
    ]
  }

  provisioner "ansible-local" {
    role_paths    = [
      "../roles/init-node-debian11",
      #"../roles/install-zabbix",
      "../roles/init-ali-k8s-centos7"
    ]
    group_vars    = "../group_vars"
    playbook_dir  = "../playbooks"
    playbook_file = "../playbooks/init-node-debian11-alicloud.yml"
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
      "sudo rm -f /home/${var.user}/.bash_history",
      "sudo rm -f /var/log/wtmp",
      "sudo rm -f /var/log/btmp",
      "sudo rm -rf /var/log/installer",
      "sudo rm -rf /var/lib/cloud/instances",
      "sudo rm -rf /tmp/* /var/tmp/* /tmp/.*-unix",
      "sudo find /var/cache -type f -delete",
      "sudo find /var/log -type f | while read f; do echo -n '' | sudo tee $f > /dev/null; done;",
      "sudo find /var/lib/apt/lists -not -name lock -type f -delete",
      "sudo rm -rf /var/lib/cloud/*"
    ]
  }


}
