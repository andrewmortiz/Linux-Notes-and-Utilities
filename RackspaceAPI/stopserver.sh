#!/bin/bash
auth() {
    read -p "Account Number: " ddi
    read -p "Username:" username
    read -p "APIkey:" APIkey
    read -p "Server's Datacenter: " dc
}

token() {
    token=`curl -s https://identity.api.rackspacecloud.com/v2.0/tokens -X POST \
    -d '{"auth":{"RAX-KSKEY:apiKeyCredentials":{"username":"'$username'", "apiKey":"'$APIkey'"}}}' \
    -H "Content-Type: application/json" | python -m json.tool  | sed -n '/expires/{n;p;}' |sed -e 's/^.*"id": "\(.*\)",/\1/'`
}

listservers() {
    output=$(curl -s -H "X-Auth-Token: $token" -H "Content-Type: application/json" -X GET "https://$dc.servers.api.rackspacecloud.com/v2/$ddi/servers/detail" | python -m json.tool | awk '/id|name/ $0 {print $0}')
servernames=$(awk '/name/ && !/key/ {print $0}' <(echo "$output") | awk '{print $2}' | tr -d \" | tr -d ,)
serverids=$(awk 'f{print;f=0} /host/{f=1}' <(echo "$output") |awk '{print $2}' | tr -d \" | tr -d ,)
paste -d " | " <(echo "$servernames") <(echo "$serverids")
    read -p "What server do you want to stop:" id
}

stopserver() {
    echo "Stopping Server"
   curl  "https://$dc.servers.api.rackspacecloud.com/v2/$ddi/servers/$id/action" -H "X-Auth-Token: $token" -H "Content-Type: application/json" -X POST -d '{ "os-stop": "null" }'

}
auth
token
listservers
stopserver
