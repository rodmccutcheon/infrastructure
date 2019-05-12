resource "aws_key_pair" "sonarqube_provisioner" {
  key_name = "sonarqube_provisioner"
  public_key = "${file("keys/sonarqube_provisioner.pub")}"
}

resource "aws_instance" "sonarqube" {
    ami = "ami-04481c741a0311bbb"
    instance_type = "t2.medium"
    key_name = "${aws_key_pair.sonarqube_provisioner.key_name}"
    vpc_security_group_ids = ["sg-012911a9f86211e5d"]
    subnet_id = "subnet-02aa858f756b861d5"

    tags {
        Name = "sonarqube"
        role = "sonarqube"
    }

    provisioner "remote-exec" {
        script = "setup.sh ${aws_db_instance.sonarqube-rds.host}"
        connection {
            host = "${aws_instance.sonarqube.public_ip}"
            user = "${var.instance_user}"
            private_key = "${file("keys/sonarqube_provisioner")}"
        }
    }
}

resource "aws_eip" "sonarqube" {
    instance = "${aws_instance.sonarqube.id}"
    vpc = true

    tags {
        Name = "sonarqube"
    }
}