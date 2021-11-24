#!/bin/bash

#bridge1
docker network create -d bridge --subnet 10.0.10.0/24 bridge1

#bridge2
docker network create -d bridge bridge2

#T1
docker run -itd --name T1 alpine

#T2
docker run -itd --name T2 -p 8000:80 -p 80:80 nginx
docker network connect bridge1 T2

#D1 - dodany alias host1
docker run -itd --name D1 --net bridge1 --network-alias host1 --ip 10.0.10.254 alpine

#D2 - dodany alias apa1 i apa2
docker run -itd --name D2 --net bridge1 --network-alias apa1 -p 8080:80 -p 8081:80 httpd
docker network connect --alias apa2 bridge2 D2

#S1 - dodany alias host2
docker run -itd --name S1 --net bridge2 --network-alias host2 ubuntu

#late
docker create -it --name late ubuntu
docker network connect bridge1 late
docker network connect bridge2 late
docker start late
