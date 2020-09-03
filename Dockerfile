FROM golang:1.10 AS build_probe

COPY ./rethinkdb-probe/ /go/src/rethinkdb-probe
WORKDIR /go/src/rethinkdb-probe

RUN go get ./... \
    && GOROOT=/usr/local/go CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-w -s' -o /rethinkdb-probe


FROM debian:buster-slim as build_rethink


ENV RETHINKDB_VERSION 2.4.0

RUN apt-get -qqy update \
    && apt-get install -y --no-install-recommends build-essential ca-certificates protobuf-compiler python \
       libprotobuf-dev libcurl4-openssl-dev libboost-all-dev libncurses5-dev wget m4 clang \
       openssl libssl-dev \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir /src && mkdir /compiled && cd /src && wget https://github.com/rethinkdb/rethinkdb/archive/v${RETHINKDB_VERSION}.tar.gz  && \
    tar xf *.tar.gz && rm -f *.tar.gz

COPY ./files/fix.patch /src/rethinkdb-$RETHINKDB_VERSION

WORKDIR /src/rethinkdb-$RETHINKDB_VERSION
RUN patch -p1  -i fix.patch && \
    ./configure --prefix=/compiled --allow-fetch  CXX=clang++ && \
    make -j7 && make install

FROM debian:buster-slim
LABEL maintainer="of.hagara@gmail.com"

COPY --from=build_probe /rethinkdb-probe  /rethinkdb-probe
COPY --from=build_rethink /compiled/bin/rethinkdb /usr/bin/rethinkdb
COPY --from=build_rethink /compiled/etc/init.d/rethinkdb /etc/init.d/rethinkdb
COPY --from=build_rethink /compiled/etc/rethinkdb /etc/rethinkdb
COPY --from=build_rethink /compiled/share/doc/rethinkdb/copyright /usr/share/doc/rethinkdb/copyright
RUN  mkdir -p /var/lib/rethinkdb/instances.d


RUN apt-get update && \
    apt-get install --no-install-recommends -yq krb5-locales libcurl4 \
    libgpm2 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 \
    libncurses6 libnghttp2-14 libprocps7 libprotobuf17 libpsl5 librtmp1 \
    libssh2-1 procps psmisc publicsuffix dumb-init jq curl openssl bash \
    && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

COPY ./files/run.sh /
RUN chmod u+x /run.sh /rethinkdb-probe

ENTRYPOINT ["/usr/bin/dumb-init", "/run.sh"]
