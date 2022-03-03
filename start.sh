#! /bin/sh

usage_message="usage:\n$0 client [server_name]\n$0 server [server_name] [minecraft_port]"
if ! (echo "$1 $2 $3" | grep -E '^(server [a-zA-Z0-9_\.-]+ \d+|client [a-zA-Z0-9_\.-]+ )$' > /dev/null); then
  echo "$usage_message"
  exit
elif [ "$1" = server ] && { test "$3" -eq 19131 || test "$3" -eq 19132; }; then
  echo "port reserved"
  echo "$usage_message"
  exit
fi

tunnel_mode="$1"
server_name="$2"
minecraft_port="${3:-19131}"

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
docker compose start unbound bedrock-connect wrtc_tunnel

if [ "$tunnel_mode" = server ]; then
  docker compose exec wrtc_tunnel node wrtc_tunnel/dist/main.js server "$server_name" gateway.docker.internal "$minecraft_port"
else
  docker compose exec wrtc_tunnel node wrtc_tunnel/dist/main.js client "$server_name" "$minecraft_port"
fi
