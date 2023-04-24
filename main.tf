provider "aws"{
        access_key = "AKIAYK4MRYILAJ5B6BAH"
        secret_key = "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"
        region = "us-east-1"
}
resource "aws_instance" "prod-server1"{
	ami = "ami-007855ac798b5175e"
	instance_type = "t2.micro"
	key_name = "aws"
	vpc_security_group_ids =["sg-0d665c5855066777e"]
	connection{
		type = "ssh"
		user = "ubuntu"
		private_key = file("./aws.pem")
		host = self.public_ip
	}
	tags = {
	  Name = "prod-server1"
	}
	provisioner "local-exec"{
		command = "echo ${aws_instance.prod-server1.public_ip} > inventory"
	}
	provisioner "local-exec"{
		command = "ansible-playbook /var/lib/jenkins/workspace/banking/deploy.yml"
	}
}
