ort_jenkins_version = 0.1.3

backend:
	terraform apply -target  -auto-approve

keys:
	mkdir keys
	ssh-keygen -t rsa \
		-b 4096 \
		-C jenkins_provisioner \
		-f keys/jenkins_provisioner \
		-P ''
	ssh-keygen -t rsa \
		-b 4096 \
		-C sonarqube_provisioner \
		-f keys/sonarqube_provisioner \
		-P ''

clean:
	rm -rf keys
	terraform destroy

ecr: terraform apply -auto-approve

jenkins:
	docker build -t ortjenkins:$(ort_jenkins_version) -t ortjenkins:latest .
	docker tag ortjenkins:$(ort_jenkins_version) 024387027097.dkr.ecr.ap-southeast-2.amazonaws.com/ortjenkins:latest
	docker tag ortjenkins:$(ort_jenkins_version) 024387027097.dkr.ecr.ap-southeast-2.amazonaws.com/ortjenkins:$(ort_jenkins_version)
	docker push 024387027097.dkr.ecr.ap-southeast-2.amazonaws.com/ortjenkins:latest
	docker push 024387027097.dkr.ecr.ap-southeast-2.amazonaws.com/ortjenkins:$(ort_jenkins_version)
	terraform apply -auto-approve

sonarqube: terraform apply -auto-approve

# Provision and configure on AWS
cicd-aws:
	terraform init
	backend
	ecr
	keys
	jenkins
	sonarqube

# Provision and configure locally using Docker Compose
cicd-local:
	docker-compose -f jenkins/docker/docker-compose.yml up -d 
	docker-compose -f sonarqube/docker/docker-compose.yml up -d

cicd-local-clean:
	docker-compose -f jenkins/docker/docker-compose.yml down
	docker-compose -f sonarqube/docker/docker-compose.yml down