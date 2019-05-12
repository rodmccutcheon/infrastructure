# resource "aws_ebs_volume" "sonarqube_ebs_volume" {
#   availability_zone = "ap-southeast-2a"
#   size              = 5

#   tags = {
#     Name = "SonarQube EBS Volume"
#   }
# }

# resource "aws_volume_attachment" "sonarqube_ebs_att" {
#     device_name = "/dev/sdh"
#     volume_id   = "${aws_ebs_volume.sonarqube_ebs_volume.id}"
#     instance_id = "${aws_instance.sonarqube.id}"

#     provisioner "remote-exec" {
#         script = "setup.sh"
#         connection {
#             host = "${aws_instance.sonarqube.public_ip}"
#             user = "ec2-user"
#             private_key = "${file("keys/sonarqube_provisioner")}"
#         }
#     }

#     provisioner "remote-exec" {
#         when   = "destroy"
#         script = "destroy.sh"
#         connection {
#             host = "${aws_instance.sonarqube.public_ip}"
#             user = "ec2-user"
#             private_key = "${file("keys/sonarqube_provisioner")}"
#         }
#     }
# }