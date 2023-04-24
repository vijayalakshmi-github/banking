provider "aws"{
        access_key = "AKIAYK4MRYILNHXV7AFJ"
        secret_key = "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"
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
                command = "echo server ansible_host= ${aws_instance.prod-server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=aws.pem > inventory"
	}
	provisioner "local-exec"{
		command = "ansible-playbook -i /var/lib/jenkins/workspace/banking/inventory /var/lib/jenkins/workspace/banking/deploy.yml"
	}
}
