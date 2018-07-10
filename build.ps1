# Build semi annual images
$tags = @("1803")
foreach ($tag in $tags) {
 docker build `
 --build-arg TAG=$tag `
 -t "teamcity-minimal-agent:latest-nanoserver-$tag" `
 -f nanoserver/Dockerfile .
}

# Build images with long term support
docker build --isolation=hyperv `
 -t teamcity-minimal-agent:latest-nanoserver `
 -t teamcity-minimal-agent:latest-nanoserver-sac2016 `
 -f nanoserver-sac2016/Dockerfile .