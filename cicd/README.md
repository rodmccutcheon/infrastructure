To provision on AWS:
$ make cicd-aws

To provision locally (using Docker):
$ make cicd-local







https://technologyconversations.com/2017/06/16/automating-jenkins-docker-setup/

Simply run: docker-compose up

docker build -t ortjenkins .
docker run --rm -p 8082:8080 \
 --name ortjenkins \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v /usr/local/bin/docker:/usr/bin/docker
 --group-add=staff \
 ortjenkins


https://getstart.blog/terraform-infrastructure-as-code/amazon-ecr-with-terraform/

ECR URL:
024387027097.dkr.ecr.ap-southeast-2.amazonaws.com/iac

$ docker tag mywebsite:latest 464890032310.dkr.ecr.us-east-1.amazonaws.com/mywebsite:1.0

$ docker push 464890032310.dkr.ecr.us-east-1.amazonaws.com/mywebsite:1.0

$ $(aws ecr get-login --region ap-southeast-2 --no-include-email)



https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html


docker build -t ortjenkins:0.1.3 -t ortjenkins:latest .
docker tag ortjenkins:0.1.3 024387027097.dkr.ecr.ap-southeast-2.amazonaws.com/ortjenkins:latest
docker tag ortjenkins:0.1.3 024387027097.dkr.ecr.ap-southeast-2.amazonaws.com/ortjenkins:0.1.3
docker push 024387027097.dkr.ecr.ap-southeast-2.amazonaws.com/ortjenkins:latest
docker push 024387027097.dkr.ecr.ap-southeast-2.amazonaws.com/ortjenkins:0.1.3



# Upgrading plugins, removing/installing plugins
Plugins configuration managed through the master/plugins.txt. To update its content first go to Manage Jenkins -> Manage Plugins and install necessary updates uninstall plugins and etc. When ready run the following in Manage Jenkins -> Script console and then copy output to plugins.txt

plugins = [:]
jenkins.model.Jenkins.instance.getPluginManager().getPlugins().each {plugins << ["${it.getShortName()}":"${it.getVersion()}"]}
plugins.sort().each() { println "${it.key}:${it.value}"}

# Backing up jobs
* docker ps
* docker container exec -it <container id> /bin/bash
* cd var/jenkins_home/jobs
* cat <job name>/config.xml