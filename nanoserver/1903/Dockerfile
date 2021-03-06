FROM mcr.microsoft.com/powershell:nanoserver-1903 AS base

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install JRE
RUN [Net.ServicePointManager]::SecurityProtocol = 'tls12, tls11, tls' ; \
    Invoke-WebRequest https://corretto.aws/downloads/resources/8.272.10.3/amazon-corretto-8.272.10.3-windows-x64-jre.zip -OutFile jre.zip; \
    Expand-Archive jre.zip -DestinationPath $Env:ProgramFiles\Java ; \
    Get-ChildItem $Env:ProgramFiles\Java | Rename-Item -NewName "OpenJDK" ; \
    Remove-Item -Force jre.zip

# Install tools from JDK
RUN [Net.ServicePointManager]::SecurityProtocol = 'tls12, tls11, tls' ; \
    Invoke-WebRequest https://corretto.aws/downloads/resources/8.272.10.3/amazon-corretto-8.272.10.3-windows-x64-jdk.zip -OutFile jdk.zip; \
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

# Workaround for https://github.com/PowerShell/PowerShell-Docker/issues/164
FROM mcr.microsoft.com/windows/nanoserver:1903

ENV ProgramFiles="C:\Program Files" \
    # set a fixed location for the Module analysis cache
    PSModuleAnalysisCachePath="C:\Users\ContainerUser\AppData\Local\Microsoft\Windows\PowerShell\docker\ModuleAnalysisCache" \
    # Persist %PSCORE% ENV variable for user convenience
    PSCORE="$ProgramFiles\PowerShell\pwsh.exe"

COPY --from=base ["C:/Program Files/PowerShell", "C:/Program Files/PowerShell"]

# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN setx /M PATH "%PATH%;%ProgramFiles%\PowerShell"
USER ContainerUser

# intialize powershell module cache
RUN pwsh -NoLogo -NoProfile -Command " \
    $stopTime = (get-date).AddMinutes(15); \
    $ErrorActionPreference = 'Stop' ; \
    $ProgressPreference = 'SilentlyContinue' ; \
    while(!(Test-Path -Path $env:PSModuleAnalysisCachePath)) {  \
        Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ; \
        if((get-date) -gt $stopTime) { throw 'timout expired'} \
        Start-Sleep -Seconds 6 ; \
    }"

COPY --from=base ["C:/Program Files/Java/OpenJDK", "C:/Program Files/Java/OpenJDK"]

ENV JRE_HOME="C:\Program Files\Java\OpenJDK" \
    CONFIG_FILE="C:\BuildAgent\conf\buildAgent.properties"

COPY --from=base /BuildAgent /BuildAgent

VOLUME C:/BuildAgent/conf
VOLUME C:/BuildAgent/plugins
VOLUME C:/BuildAgent/work
VOLUME C:/BuildAgent/temp
VOLUME C:/BuildAgent/tools
VOLUME C:/BuildAgent/logs

CMD pwsh ./BuildAgent/run-agent.ps1