FROM microsoft/nanoserver:sac2016 AS base

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install JRE
RUN Invoke-WebRequest https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u192-b12/OpenJDK8U-jre_x64_windows_hotspot_8u192b12.zip -OutFile jre.zip; \
    Expand-Archive jre.zip -DestinationPath $Env:ProgramFiles\Java ; \
    Get-ChildItem $Env:ProgramFiles\Java | Rename-Item -NewName "OpenJDK" ; \
    Remove-Item -Force jre.zip

# Install tools from JDK
RUN [Net.ServicePointManager]::SecurityProtocol = 'tls12, tls11, tls' ; \
    Invoke-WebRequest https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u192-b12/OpenJDK8U-jdk_x64_windows_hotspot_8u192b12.zip -OutFile jdk.zip; \
    Expand-Archive jdk.zip -DestinationPath $Env:Temp\JDK ; \
    Get-ChildItem $Env:Temp\JDK | Rename-Item -NewName "OpenJDK" ; \
    ('jar.exe', 'jcmd.exe', 'jconsole.exe', 'jmap.exe', 'jstack.exe', 'jps.exe') | foreach { \
         Copy-Item $Env:Temp\JDK\OpenJDK\bin\$_ $Env:ProgramFiles\Java\OpenJDK\bin\ \
    } ; \
    Remove-Item -Force -Recurse $Env:Temp\JDK ; \
    Remove-Item -Force jdk.zip

# Prepare build agent distribution
COPY buildAgent.zip /
RUN Expand-Archive buildAgent.zip -DestinationPath C:/BuildAgent ; \
    Move-Item -Path C:/BuildAgent/conf -Destination C:/BuildAgent/conf_dist
COPY run-agent.ps1 /BuildAgent/run-agent.ps1

FROM microsoft/nanoserver:sac2016

COPY --from=base ["C:/Program Files/Java/OpenJDK", "C:/Program Files/Java/OpenJDK"]

ENV JRE_HOME="C:\Program Files\Java\OpenJDK" \
    CONFIG_FILE="C:\BuildAgent\conf\buildAgent.properties"

EXPOSE 9090

VOLUME C:/BuildAgent/conf

COPY --from=base /BuildAgent /BuildAgent

CMD powershell ./BuildAgent/run-agent.ps1

RUN setx /M PATH "%PATH%;%JRE_HOME%\bin"