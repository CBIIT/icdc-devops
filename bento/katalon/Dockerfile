#FROM jenkins/inbound-agent:latest-jdk8 as jnlp
FROM jenkins/inbound-agent:latest-jdk11 as jnlp

#FROM katalonstudio/katalon:8.5.5
#FROM katalonstudio/katalon:8.6.9
FROM katalonstudio/katalon:9.3.2

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

#RUN sed -i "s/https/http/g" /etc/apt/sources.list.d/google-chrome.list
RUN mv /etc/apt/sources.list.d/google-chrome.list /etc/apt/sources.list.d/google-chrome.list.bak
RUN apt-get update && apt-get install -y apt-transport-https zip

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]