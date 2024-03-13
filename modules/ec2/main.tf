provider "aws" {
  region = var.region
}

resource "aws_instance" "ec2_instance" {
    ami = var.ami_value
    instance_type = var.instance_type_value
    key_name = var.key_name_value
    vpc_security_group_ids = [var.sg_value]
    subnet_id = var.subnet_id_value
    tags = {
      Name = "Terraform instance"
    }
    connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate userName for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
    }
    # File provisioner to copy a file from local to the remote EC2 instance
    provisioner "file" {
      source      = "../../app.py"  # Replace with the path to your local file
      destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
    }
    provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py",
      ]
    }
}
