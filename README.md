# rethinkdb-docker-cpu-fix

This repository contains Dockerfile to build docker image compatible with projects listed below. It is based on original work of people mentioned on the sites below - with my modifications and aditions. It can be easily modified for standalone rethinkdb setup without K8S.

https://github.com/helm/charts/tree/master/stable/rethinkdb

https://hub.helm.sh/charts/stable/rethinkdb

**This image runs on up to 256 CPUs instead of official image, which crashes on 127+ CPU.**

See my issue on gitlab for more info:

https://github.com/rethinkdb/rethinkdb/issues/6895
