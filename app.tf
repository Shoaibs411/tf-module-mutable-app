resource "null_resource" "app_deploy" {
    count      = local.INSTANCE_COUNT
  
  triggers = {
    always_run = timestamp()                                # This ensures your provisioner will be executing all the time
  }
    
    provisioner "remote-exec" {

    # connection block establishes connection to this
    connection {
      type     = "ssh"
      user     = local.SSH_USERNAME
      password = local.SSH_PASSWORD
      host     = element(local.INSTANCE_IPS, count.index)            # aws_instance.sample.private_ip : Use this only if your provisioner is outside the resource.
    }

    inline = [
        "curl https://gitlab.com/thecloudcareers/opensource/-/raw/master/lab-tools/ansible/install.sh | sudo bash",
        "ansible-pull -U https://github.com/Shoaibs411/ansible.git -e APP_VERSION=${var.APP_VERSION} -e ENV=${var.ENV} -e COMPONENT=${var.COMPONENT}  roboshop-pull.yml"
        ]
    }
}