FROM teamcity-base:latest

MAINTAINER Kateryna Shlyakhovetska <shkate@jetbrains.com>

VOLUME /data/teamcity_agent/conf
ENV CONFIG_FILE /data/teamcity_agent/conf/buildAgent.properties
LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

COPY run-agent.sh /run-agent.sh
COPY run-services.sh /run-services.sh
COPY dist/buildagent /opt/buildagent

RUN useradd -m buildagent && \
    chmod +x /run-agent.sh /run-services.sh && sync

CMD ["/run-services.sh"]

EXPOSE 9090
