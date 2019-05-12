resource "aws_vpc" "jenkins_sonarqube_vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = false

    tags {
        name = "Jenkins/SonarQube VPC"
    }
}

resource "aws_subnet" "jenkins_sonarqube_public-z1" {
    vpc_id = "${aws_vpc.jenkins_sonarqube_vpc.id}"
    cidr_block = "10.0.6.0/24"
    availability_zone = "ap-southeast-2a"
    map_public_ip_on_launch = true

    tags {
        name = "jenkins-sonarqube-public-z1"
    }
}

resource "aws_subnet" "jenkins_sonarqube_private-z1" {
    vpc_id = "${aws_vpc.jenkins_sonarqube_vpc.id}"
    cidr_block = "10.0.5.0/24"
    availability_zone = "ap-southeast-2a"

    tags {
        name = "jenkins-sonarqube-private-z1"
    }
}

resource "aws_subnet" "jenkins_sonarqube_private-z2" {
    vpc_id = "${aws_vpc.jenkins_sonarqube_vpc.id}"
    cidr_block = "10.0.7.0/24"
    availability_zone = "ap-southeast-2b"

    tags {
        name = "jenkins-sonarqube-private-z2"
    }
}

resource "aws_internet_gateway" "jenkins_sonarqube_default" {
    vpc_id = "${aws_vpc.jenkins_sonarqube_vpc.id}"

    tags {
        name = "jenkins-sonarqube-internet-gateway"
    }
}

resource "aws_route_table" "jenkins_sonarqube_public" {
    vpc_id = "${aws_vpc.jenkins_sonarqube_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.jenkins_sonarqube_default.id}"
    }

    tags {
        name = "jenkins-sonarqube-public"
    }
}

resource "aws_route_table_association" "public-z1" {
    subnet_id = "${aws_subnet.jenkins_sonarqube_public-z1.id}"
    route_table_id = "${aws_route_table.jenkins_sonarqube_public.id}"
}

resource "aws_security_group" "jenkins_sonarqube_vpc_sg" {
  name        = "jenkins_sonarqube_vpc_sg"
#   description = "Allow TLS inbound traffic"
  vpc_id = "${aws_vpc.jenkins_sonarqube_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    # prefix_list_ids = ["pl-12c4e678"]
  }
}

output "vpc-id" {
  value = "${aws_vpc.jenkins_sonarqube_vpc.id}"
}