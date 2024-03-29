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
        "ansible-pull -U https://github.com/Shoaibs411/ansible.git -e REDIS_ENDPOINT=${data.terraform_remote_state.db.outputs.REDIS_ENDPOINT} -e MYSQL_ENDPOINT=${data.terraform_remote_state.db.outputs.MYSQL_ENDPOINT} -e DOCDB_ENDPOINT=${data.terraform_remote_state.db.outputs.DOCDB_ENDPOINT} -e APP_VERSION=${var.APP_VERSION} -e ENV=${var.ENV} -e COMPONENT=${var.COMPONENT}  roboshop-pull.yml"
        ]
    }
}