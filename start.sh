#! /bin/sh

usage_message="usage:\n$0 [server_name]"
if ! (echo "$1" | grep -E '^[a-zA-Z0-9_\.-]+$' > /dev/null); then
  echo "$usage_message"
  exit
fi

server_name="$1"
minecraft_port=19133

# https://github.com/Pugmatt/BedrockConnect
domains="
  geo.hivebedrock.network
  hivebedrock.network
  mco.mineplex.com
  play.inpvp.net
  mco.lbsg.net
  mco.cubecraft.net
  play.galaxite.net
  play.pixelparadise.gg
"

ip=$(ifconfig | grep "inet " | tail -n1 | cut -d" " -f2)
echo "Your IP: $ip"

a='local-zone: "'
b='." redirect\nlocal-data: "'
c=" A $ip\""
echo "$domains" | sed -r "s/ *([^ ]+)/$a\1$b\1$c/g" > a-records.conf

printf '[{"name":"%s:%d","iconUrl":"","address":"%s","port":%d}]' "$ip" "$minecraft_port" "$ip" "$minecraft_port" > custom_servers.json

docker compose stop
docker compose up -d
docker compose start unbound bedrock-connect wrtc_tunnel bedrock-server
docker compose exec wrtc_tunnel node wrtc_tunnel/dist/main.js server "$server_name" gateway.docker.internal "$minecraft_port"
