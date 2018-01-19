# 1709 images
docker build `
 -t teamcity-minimal-agent:latest-windowsservercore-1709 `
 -f windowsservercore-1709/Dockerfile .

docker build `
 -t teamcity-minimal-agent:latest-nanoserver-1709 `
 -f nanoserver-1709/Dockerfile .

# old images
docker build --isolation=hyperv `
 -t teamcity-minimal-agent:latest-windowsservercore `
 -t teamcity-minimal-agent:latest-windowsservercore-ltsc2016 `
 -f windowsservercore-ltsc2016/Dockerfile .

docker build --isolation=hyperv `
 -t teamcity-minimal-agent:latest-nanoserver `
 -t teamcity-minimal-agent:latest-nanoserver-sac2016 `
 -f nanoserver-sac2016/Dockerfile .