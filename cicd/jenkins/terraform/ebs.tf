# resource "aws_ebs_volume" "jenkins_master_ebs_volume" {
#   availability_zone = "ap-southeast-2a"
#   size              = 5

#   tags = {
#     Name = "Jenkins Master EBS Volume"
#   }
# }

# resource "aws_volume_attachment" "jenkins_master_ebs_att" {
#     device_name = "/dev/sdh"
#     volume_id   = "${aws_ebs_volume.jenkins_master_ebs_volume.id}"
#     instance_id = "${aws_instance.jenkins_master.id}"

#     provisioner "remote-exec" {
#         script = "setup.sh"
#         connection {
#             host = "${aws_instance.jenkins_master.public_ip}"
#             user = "ec2-user"
#             private_key = "${file("keys/jenkins_provisioner")}"
#         }
#     }

#     provisioner "remote-exec" {
#         when   = "destroy"
#         script = "destroy.sh"
#         connection {
#             host = "${aws_instance.jenkins_master.public_ip}"
#             user = "ec2-user"
#             private_key = "${file("keys/jenkins_provisioner")}"
#         }
#     }
# }