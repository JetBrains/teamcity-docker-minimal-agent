$tags = @("1803", "1809", "1903")

foreach ($tag in $tags) {
 docker build `
 -t "teamcity-minimal-agent:latest-nanoserver-$tag" `
 -f "nanoserver/$tag/Dockerfile" .
}