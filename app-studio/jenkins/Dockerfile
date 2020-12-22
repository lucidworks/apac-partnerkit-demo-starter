FROM openjdk:8u171-jdk-alpine3.8

# Jenkins user details
ENV JENKINS_USER=jenkins
ENV JENKINS_UID=7000

# Versions
ENV MAVEN_VERSION=3.5.4-r1

RUN apk update

# Grab bag of basic unix commands, such as user commands
RUN apk add shadow && \
  apk add bash && \
  apk add git && \
  apk add zip

# Configure Jenkins user
RUN adduser -g "" -D --uid ${JENKINS_UID} ${JENKINS_USER} ${JENKINS_USER}
RUN mkdir -p /home/${JENKINS_USER}/.ssh
RUN chown -R ${JENKINS_USER}:${JENKINS_USER} /home/${JENKINS_USER}/.ssh

# Debugging to check uid and gid are both 7000
#RUN id -u ${JENKINS_USER}
#RUN id -g ${JENKINS_USER}

# Install Apache Maven
RUN apk add maven=${MAVEN_VERSION}

# Install Node.js
RUN apk add nodejs

# Install NPM
RUN apk add npm

# Update NPM
RUN npm i npm -g

ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
