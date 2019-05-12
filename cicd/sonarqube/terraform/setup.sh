#!/bin/bash

# while [ `sudo lsblk -n | grep -c 'xvdh'` -ne 1 ]
# do
#     echo "Waiting for /dev/xvdh to become available"
#     sleep 10
# done

# if [ `sudo file -s /dev/xvdh | grep -c ext4` == 0 ]
# then
#     echo "New volume - formatting /dev/xvdh"
#     sudo mkfs.xfs /dev/xvdh
# fi

# echo "Mounting /dev/xvdh as /data"
# sudo mkdir /data
# sudo mount /dev/xvdh /data

echo "Updating system and installing Docker"
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

echo "Starting nginx"
sudo docker run -d --restart=always --name nginx-proxy \
-p 80:80 \
-p 443:443 \
-v /var/run/docker.sock:/tmp/docker.sock:ro \
jwilder/nginx-proxy:latest

echo "Starting SonarQube"
sudo docker run -d --restart=always --name ortsonarqube \
-v sonarqube_conf:/opt/sonarqube/conf \
-v sonarqube_data:/opt/sonarqube/data \
-v sonarqube_extensions:/opt/sonarqube/extensions \
-v sonarqube_bundled-plugins:/opt/sonarqube/lib/bundled-plugins \
-e sonar.jdbc.username=sonar \
-e sonar.jdbc.password=",;DRj,0BniBx1ILjD0Mf" \
-e sonar.jdbc.url=jdbc:postgresql://$1:5432/sonar \
-e VIRTUAL_HOST=sonarqube.rodmccutcheon.com \
-e VIRTUAL_PORT=9000 \
sonarqube:7.7-community