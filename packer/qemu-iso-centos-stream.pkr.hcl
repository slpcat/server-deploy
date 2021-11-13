
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
  default = "packer"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "qemu" "autogenerated_1" {
  #accelerator       = "kvm"
  boot_command      = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos-8-stream.ks<enter><wait>"]
  boot_wait         = "10s"
  disk_interface    = "virtio"
  disk_size         = 3072
  format            = "${var.format}"
  headless          = true
  http_directory    = "../http"
  iso_checksum      = "f7196a289f9200574bf97b3360c29e01b093fa0bd4b65309fac10bf8b419ac28"
  iso_url           = "https://mirrors.aliyun.com/centos/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-20210916-boot.iso"
  net_device        = "virtio-net"
  output_directory  = "build"
  qemuargs          = [["-m", "1024M"], ["-smp", "2"]]
  shutdown_command  = "echo '${var.password}'|sudo -S shutdown -h now"
  ssh_password      = "${var.password}"
  ssh_username      = "${var.user}"
  ssh_wait_timeout  = "60m"
  vnc_bind_address  = "0.0.0.0"
  vnc_use_password  = true
  vm_name           = "centos-8-stream-amd64-${local.timestamp}.${var.format}"
}

build {
  sources = ["source.qemu.autogenerated_1"]

}
