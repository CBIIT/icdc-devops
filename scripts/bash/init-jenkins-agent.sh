#!/usr/bin/env bash
export JAVA_HOME=/usr/lib/jvm/jre-11-openjdk
export MAVEN_HOME=/usr/local/maven
export PATH=$MAVEN_HOME/bin:$JAVA_HOME/bin:$PATH
export NODE_VERSION=15.13.0
export MAVEN_VERSION=3.6.3

yum  -y install epel-release \
  && yum -y install java-11-openjdk-devel wget which yum-utils device-mapper-persistent-data lvm2 redis\
  && wget https://www-us.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -P /tmp \
  && tar xf /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /usr/local \
  && ln -s /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
  && curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo \
  && curl -sL https://rpm.nodesource.com/setup_15.x | bash - \
  &&  yum install -y nodejs \
  && npm install -g npm n\
  && npm install -g yarn\
  && n $NODE_VERSION 


yum -y install jq python3 python3-pip \
  && /usr/bin/pip3 install pip -U \
  && /usr/bin/pip3 install ansible==4.0.0 awscli jmespath docker boto botocore boto3
