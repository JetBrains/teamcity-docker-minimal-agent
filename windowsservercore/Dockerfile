FROM teamcity-base:latest-windowsservercore AS build-agent

# Prepare build agent distribution
COPY buildAgent.zip /
RUN powershell -Command \
    $ErrorActionPreference = 'Stop' ; \
    Expand-Archive buildAgent.zip -DestinationPath C:/BuildAgent ; \
    Move-Item -Path C:/BuildAgent/conf -Destination C:/BuildAgent/conf_dist
COPY run-agent.ps1 /BuildAgent/run-agent.ps1

FROM teamcity-base:latest-windowsservercore

ENV CONFIG_FILE C:/BuildAgent/conf/buildAgent.properties

EXPOSE 9090

VOLUME C:/BuildAgent/conf

COPY --from=build-agent /BuildAgent /BuildAgent

CMD powershell ./BuildAgent/run-agent.ps1