#! /bin/sh

# https://qiita.com/manontroppo1974/items/78f4b1b8d81694f9fd4a
domains="
  geo.hivebedrock.network
  play.galaxite.net
  mco.mineplex.com
  mco.cubecraft.net
  play.pixelparadise.gg
  mco.lbsg.net
  play.inpvp.net
"

ip=$(ifconfig | grep "inet " | tail -n1 | cut -d" " -f2)
a='local-zone: "'
b='." redirect\nlocal-data: "'
c=" A $ip\""
echo "$domains" | sed -r "s/ *([^ ]+)/$a\1$b\1$c/g" > a-records.conf

docker-compose up
