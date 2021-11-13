variable "format" {
  type    = string
  default = "qcow2"
}

variable "disk_size" {
  type    = string
  default = "4096"
}

variable "domain" {
  type    = string
  default = ""
}

variable "password" {
  type    = string
  default = "packer"
}

variable "user" {
  type    = string
  default = "packer"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "qemu" "bullseye" {
  accelerator       = "kvm"
  qemu_binary       = "qemu-system-x86_64"
  #machine_type      = "pc"
  boot_command      = ["<esc><wait><wait>", "install auto <wait>", "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>", "debian-installer=en_US locale=en_US.UTF-8 keymap=us <wait>", "netcfg/get_hostname={{ .Name }} <wait>", "netcfg/get_domain=${var.domain} <wait>", "fb=false debconf/frontend=noninteractive <wait>", "passwd/user-fullname=${var.user} <wait>", "passwd/user-password=${var.password} <wait>", "passwd/user-password-again=${var.password} <wait>", "passwd/username=${var.user} <wait>", "<enter><wait>"]
  boot_wait         = "5s"
  disk_cache        = "none"
  disk_interface    = "virtio"
  disk_size         = "${var.disk_size}"
  format            = "qcow2"
  headless          = "true"
  http_directory    = "../http"
  iso_checksum      = "8488abc1361590ee7a3c9b00ec059b29dfb1da40f8ba4adf293c7a30fa943eb2"
  #iso_checksum_type = "md5"
  iso_url           = "http://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.1.0-amd64-netinst.iso"
  net_device        = "virtio-net"
  qemuargs          = [["-m", "2048M"], ["-smp", "4"]]
  shutdown_command  = "echo '${var.password}'|sudo -S shutdown -h now"
  ssh_password      = "${var.password}"
  ssh_username      = "${var.user}"
  ssh_wait_timeout  = "60m"
  vnc_bind_address  = "0.0.0.0"
  vnc_use_password  = true
  output_directory  = "build"
  vm_name           = "debian11-amd64-${local.timestamp}.${var.format}"
}

build {
  sources = ["source.qemu.bullseye"]

  #provisioner "shell" {
  #  execute_command = "echo '${var.password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
  #  scripts         = ["scripts/packages.sh", "scripts/cleanup.sh", "scripts/tuning.sh"]
  #}

}
