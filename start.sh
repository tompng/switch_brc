#! /bin/sh

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
a='local-zone: "'
b='." redirect\nlocal-data: "'
c=" A $ip\""
echo "$domains" | sed -r "s/ *([^ ]+)/$a\1$b\1$c/g" > a-records.conf

minecraft_port=${1:-19133}
printf '[{"name":"%s:%d","iconUrl":"","address":"%s","port":%d}]' "$ip" "$minecraft_port" "$ip" "$minecraft_port" > custom_servers.json

docker-compose up
