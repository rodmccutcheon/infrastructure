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

echo "Configuring AWS CLI"
aws configure set aws_access_key_id $1
aws configure set aws_secret_access_key $2

echo "Starting nginx"
sudo docker run -d --restart=always --name nginx-proxy \
-p 80:80 \
-p 443:443 \
-v /var/run/docker.sock:/tmp/docker.sock:ro \
jwilder/nginx-proxy:latest

#-v /home/you/certs:/etc/nginx/certs \

echo "Starting Jenkins"
$(aws ecr get-login --region ap-southeast-2 --no-include-email)
#sudo docker login -u AWS -p eyJwYXlsb2FkIjoiTDh6cXZxRWlZWkNnMU0yVUVaMnlqRkhEaUUxWUNaOFJBVEltZUlsZm54TU5ra0hSRExtck9vTDM1VU01bDVLQUFvZ0QrbXBQa2IwcGhtOUdsdjlnK0xLTkJpTFE2OGlyeUVXMytSTXpGd1BMa2dRZGlBajFtR2VZOE5EaFROaHBFMllMdkJIWC9pSjRMU0gzNzd0M2g5Ym90S2kwNk5OTktGbVc5UEdwc2tHK3NnSFpia1BJT0NGRHhudFNjVkVnbVRUZDRqVHl0NUdCN2xaNUY0UzYwczFZRVM4RFlMS2VQeWl0L2swY21oSExIZmNONDFlaVk3cU5adHZYL0l2eDl3VWRGSk1RVEx4N3gxK1JGSXpNSHhqRlV6eUp4cjFUNXl1RGQzcG1KcUMrZmZoaGlKTHJKUDk2RlJaQ2lxT3hRU09tTVdhYkllOGQvblZOZE5XLzRNMWtQTVllc3dUU1hJd0pNOHViYnJ3YmZrcUJKUmJpTEpHRTVrSjBraDE2ZnhpTE9mN3VTY2R6ZnlDQ2NuMW04YzVGNExrYkxITTRvTEJaZFVSMHZEb0k2NTV2STJPek43SmczaHNpV1E2Vm5VUFVNbHlsc3phVHFNY055Qy80TUhYSHBzOUk4a1A5ZjFoR1RmV3pLMlBXbkhlMTBZdDJ1L0pnbVkwa1lCVVdmTmo2VEl6VWFKY3BRQlMrM2U2aGRnQ1RMV1c0eTcvTlpReDlwd2NiSWNJeDJDTFZKeXVOTll0ZFNoOVdmcUxZVno2Mlg0NnFFM2xlbVhQa2N6U1FTMWdZTVpKOEs4VWFwQVQ2cnByaXNrRElKSGh5T3VGdlF3Z2RieUZDeWw3QUtzWWhLSjdQR3RrNjhnWTk0Qy9hYW1sNjNlRlBEbzY2UFpsYVFVL0g5ZE40RGVtWTFvcXc4bmVYTDZZSU54WGR0OWZEc2dlbjhjM2hYMzhDbm9SZDJ4WTJ6aGdUOFlCL216enZ5NlI5cHE5d094d0NIQXo0UDJBZnU1VFkxejZBcm1saGNuL1JnMllJRExvQ3RsS1ZwRUcvWnd3Rjc3TGJDVFBkWmovRmRpZklhQkhQRU91SWh6MkJsbGthdGFiMENVVExiMGR0Y3dxYm04akJ6OEYxalZxWXdKZHIvZzg2bU5JWCtTNmt2VVh4Ymc1VDhFelZDakZVam1BeUtYYlpuWktXTjR5VWVxS2dqcXFjMlg4SCthQnZaR2tUTEgrMjkrTFFyOFR0MWFTRUV0bkRxNllrV056K01sM0pnS1haODM2M09jc052bVg0ZytOSXhjekQ0WHU2alhFQlhabnJMbHlhT3hiQVRhQTMyQUNqRGhrR2NweHFTRDZxNHdUOFRvRVEvSXhGYkF5NzA1Ymp1Nys2R2lIck9tdm1NVHZkMGxyT0xMaHdIVkRxQnVQanZ2eTFOcnF4NWlPb1F0RGRPdFY1ZFJpUFY5WDNRZmRzTzZxQ3IrVjJpU2pod0FMYzNjaWJ3b2VUelJIS0l5RzJ6RWx0UWtPWWFBPT0iLCJkYXRha2V5IjoiQVFFQkFIaEx5ano3UEpFUG1ZYnFINkE2Zi93V056eXo1QkthMzdCbkJQc0F5dUYxS1FBQUFINHdmQVlKS29aSWh2Y05BUWNHb0c4d2JRSUJBREJvQmdrcWhraUc5dzBCQndFd0hnWUpZSVpJQVdVREJBRXVNQkVFRE1mR2JrYWJibVJWMlhDOFlBSUJFSUE3ZTY1eWZubEpOREpFbGMyaWhmUlQ2ck5Daldva0NudHJLRWQzZzNjN2VNSGJnSXdxdkZNcXBwU2Z0ZDIrQ1FaK3Frd0tuVjJTRVk3MFJhWT0iLCJ2ZXJzaW9uIjoiMiIsInR5cGUiOiJEQVRBX0tFWSIsImV4cGlyYXRpb24iOjE1NTc0OTE5Nzd9 https://024387027097.dkr.ecr.ap-southeast-2.amazonaws.com
sudo docker run -d --restart=always --name ortjenkins \
-u root \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/bin/docker:/usr/bin/docker \
-e VIRTUAL_HOST=jenkins.rodmccutcheon.com \
-e VIRTUAL_PORT=8080 \
024387027097.dkr.ecr.ap-southeast-2.amazonaws.com/ortjenkins:0.1.3

# -p 8080:8080 \
# -p 50000:50000 \
#-v jenkins-data:/var/jenkins_home \
#-v "$HOME":/home \