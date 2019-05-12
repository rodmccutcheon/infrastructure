resource "aws_key_pair" "jenkins_provisioner" {
    key_name = "jenkins_provisioner"
    public_key = "${file("keys/jenkins_provisioner.pub")}"
}

resource "aws_instance" "jenkins_master" {
    ami = "ami-04481c741a0311bbb"
    instance_type = "t2.medium"
    key_name = "${aws_key_pair.jenkins_provisioner.key_name}"
    vpc_security_group_ids = ["${aws_security_group.jenkins_sonarqube_vpc_sg.id}"]
    subnet_id = "${aws_subnet.jenkins_sonarqube_public-z1.id}"
    #associate_public_ip_address = true

    tags {
        Name = "jenkins_master"
        role = "jenkins_master"
    }

    provisioner "remote-exec" {
        script = "setup.sh ${var.access_key} ${var.secret_key}"
        connection {
            host = "${aws_instance.jenkins_master.public_ip}"
            user = "${var.instance_user}"
            private_key = "${file("keys/jenkins_provisioner")}"
        }
    }
}

resource "aws_eip" "jenkins_master" {
    instance = "${aws_instance.jenkins_master.id}"
    vpc = true

    tags {
        name = "jenkins"
    }
}