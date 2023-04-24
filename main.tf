provider "aws"{
	region = "us-east-1"
}
resource "aws_instance" "prod-server"{
	ami = "ami-007855ac798b5175e"
	instance_type = "t2.micro"
	availability_zone = "us-east-1a"
	key_name = "aws"
	vpc_security_group_ids =["sg-0d665c5855066777e"]
	tags = {
	  Name = "prod-server"
	}
	provisioner "local-exec"{
		command = "echo ${aws_instance.prod-server.public_ip} > inventory"
	}
	provisioner "local-exec"{
		command = "ansible-playbook /var/lib/jenkins/workspace/banking/deploy.yml"
	}
}
