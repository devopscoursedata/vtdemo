provider "aws" {
  region     = "ap-northeast-3"
  
}

resource "aws_instance" "awsinsta" {
  ami             = "ami-096d800410995ae84"
  instance_type   = "t2.micro"
  security_groups = ["launch-wizard-1"]
  key_name        = "new-jenkins"
  tags = {
    Name = "terraform"
  }

provisioner "local-exec" {
    when    = destroy
    command = "echo 'Destroy-time provisioner'"
  }
  
  provisioner "file" {
    source      = "target/vtdemo.war"
    destination = "~/vtdemo.war"
  }
  
   connection {
    type     = "ssh"
    user     = "ubuntu"
    #password = var.root_password
    private_key = file("new-jenkins.pem")
    host     = self.public_ip
  }
  
  provisioner "remote-exec" {
    script="downloadtomcat&java.sh"
  }
  
  provisioner "remote-exec" {
    script="start tomcat.sh"
  }
}

output "my_publi_ip" {
  value = aws_instance.awsinsta.public_ip
}
