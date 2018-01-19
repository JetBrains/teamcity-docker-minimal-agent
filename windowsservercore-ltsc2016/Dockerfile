FROM teamcity-base:latest-windowsservercore-ltsc2016 AS build-agent

# Prepare build agent distribution
COPY buildAgent.zip /
RUN powershell -Command \
    $ErrorActionPreference = 'Stop' ; \
    Expand-Archive buildAgent.zip -DestinationPath C:/BuildAgent ; \
    Move-Item -Path C:/BuildAgent/conf -Destination C:/BuildAgent/conf_dist
COPY run-agent.ps1 /BuildAgent/run-agent.ps1

FROM microsoft/dotnet-framework-build:4.7.1-windowsservercore-ltsc2016

ENV CONFIG_FILE="C:/BuildAgent/conf/buildAgent.properties" \
    JRE_HOME="C:\Program Files\Java\Oracle\jre"

EXPOSE 9090

VOLUME C:/BuildAgent/conf

COPY --from=build-agent /BuildAgent /BuildAgent
COPY --from=build-agent ["C:/Program Files/Java/Oracle", "C:/Program Files/Java/Oracle"]

RUN setx /M PATH ('{0};{1}\bin' -f $env:PATH, $env:JRE_HOME)

CMD ./BuildAgent/run-agent.ps1