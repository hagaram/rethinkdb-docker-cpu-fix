# rethinkdb-docker-cpu-fix


**This repo is archived as the official release already fixed the issue.**

This repository contains Dockerfile to build docker image compatible with projects listed below. It is based on original work of people mentioned on the sites below - with my modifications and aditions. It can be easily modified for standalone rethinkdb setup without K8S.

https://github.com/helm/charts/tree/master/stable/rethinkdb

https://hub.helm.sh/charts/stable/rethinkdb

**This image is capable of running rethinkdb on up to 256 CPUs, official rethinkdb binary crashes on 127+ CPU.**

See my issue on gitlab for more info:

https://github.com/rethinkdb/rethinkdb/issues/6895
