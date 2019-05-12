FROM jenkins/jenkins:2.175-jdk11

USER root

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y sudo libltdl-dev \
    && rm -rf /var/lib/apt/lists/*

USER jenkins

# Create 'docker' group with provided group ID 
# and add 'jenkins' user to it
# RUN groupadd docker -g 20 && \
#     usermod -a -G docker jenkins

# To allow us to access /var/run/docker.sock on the Mac
#RUN gpasswd -a jenkins staff

# ENV JENKINS_HOME /var/lib/jenkins
ENV JENKINS_CONFIG_PATH /var/jenkins_home/init.groovy.d

# ARG user=jenkins
# ARG group=docker
# ARG uid=1000
# ARG gid=1000

# RUN groupadd -g ${gid} ${group} \
#     && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# Disable the setup wizard - we're going to configure Jenkins programmatically
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Install plugins
COPY config/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Copy configuration scripts that will be executed by groovy
COPY config/*.yml /usr/share/jenkins/ref/init.groovy.d/
COPY config/*.groovy /usr/share/jenkins/ref/init.groovy.d/

# Copy admin scripts
# COPY scripts/*.groovy ${JENKINS_HOME}/



# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

#COPY .env /var/jenkins_home/
#COPY jobs/ /var/jenkins_home/jobs/