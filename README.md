
[![official JetBrains project](http://jb.gg/badges/official-plastic.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)
[![jetbrains/teamcity-minimal-agent](https://img.shields.io/docker/pulls/jetbrains/teamcity-minimal-agent.svg)](https://hub.docker.com/r/jetbrains/teamcity-minimal-agent/)

## TeamCity Minimal Agent Image Dockerfile

This project contains the Dockerfiles and all necessary scripts to build the Linux and Windows Docker images and run a TeamCity Build Agent inside the container.

You can pull the ready-to-use image from the Docker Hub repository
                                     
`docker pull jetbrains/teamcity-minimal-agent`

If you need to build your own image, you need to perform the following:

1) On Unix extract `buildAgent.zip` of any version you'd like to use into  the `dist/buildagent` folder and prepare agent config directory. In the same directory where the Dockerfile is placed, run
```
mkdir dist
unzip buildAgent.zip -d dist/buildagent
mv dist/buildagent/conf dist/buildagent/conf_dist
mv run-agent.sh ubuntu/
mv run-services.sh ubuntu/
```

On Windows just put `buildAgent.zip` into the repository root.

2) Run the `docker build` command:
```
docker build -t teamcity-minimal-agent
```

On Windows just execute `build.ps1` powershell script.

See our [detailed instructions](https://hub.docker.com/r/jetbrains/teamcity-minimal-agent/) on how to use the image in the Docker Hub repository .
