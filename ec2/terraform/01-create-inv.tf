resource "null_resource" "ansible-provision" {
  depends_on = ["aws_instance.MLLSGD-workers"]

  provisioner "local-exec" {
    command = "echo \"[MLLSGD-workers]\" >> ansible-inventory"
  }

  provisioner "local-exec" {
    command = "echo \"${join("\n",formatlist("%s ansible_ssh_user=%s", aws_instance.MLLSGD-workers.*.public_ip, var.ssh_user))}\" >> ansible-inventory"
  }

  # provisioner "local-exec" {
  #   command = "echo \"ansible_ssh_private_key_file=terraform-keys.pem\" >> ansible-inventory"
  # }

}
