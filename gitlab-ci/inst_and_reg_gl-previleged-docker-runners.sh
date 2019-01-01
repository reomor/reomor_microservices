#!/bin/bash

# my_script -p '/some/path' -a5
EXTERNAL_URL=
TOKEN=
COUNT=1
while getopts ":u:t:c:" opt; do
  case $opt in
    u) EXTERNAL_URL="$OPTARG"
    ;;
    t) TOKEN="$OPTARG"
    ;;
    c) COUNT="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

printf "External Gitlab url is %s\n" "$EXTERNAL_URL"
printf "TOKEN is %s\n" "$TOKEN"
printf "COUNT is %s\n" "$COUNT"

for i in `seq 1 $COUNT`; do
            #echo gitlab-runner-$i
            docker run -d --name gitlab-runner-$i --restart always \
            -v /srv/gitlab-runner/config:/etc/gitlab-runner \
            -v /var/run/docker.sock:/var/run/docker.sock \
            gitlab/gitlab-runner:latest

            docker exec -it gitlab-runner gitlab-runner register \
	    --non-interactive \
            --url "$EXTERNAL_URL" \
            --registration-token "$TOKEN" \
            --executor "docker" \
            --docker-image docker:latest \
            --docker-privileged \
            --description "docker-runner"
        done
