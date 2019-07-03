FROM golang:1.12-alpine AS build
RUN set -x \
 && apk --no-cache add git openssh-client
COPY . /usr/local/src/influxdb-relay/
WORKDIR /usr/local/src/influxdb-relay
ENV CGO_ENABLED=0
RUN set -x \
 && go build -v -ldflags '-extldflags "-static"' -o /opt/local/bin/influxdb-relay .
COPY sample.toml /opt/local/etc/influxdb-relay/config.toml
COPY README.md *.toml /opt/local/share/doc/influxdb-relay/

FROM scratch AS static
COPY --from=build /opt/local/ /opt/local/
ENV PATH /opt/local/bin
ENTRYPOINT ["influxdb-relay"]
CMD ["-config", "/opt/local/etc/influxdb-relay/config.toml"]
