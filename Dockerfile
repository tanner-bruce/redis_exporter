FROM golang:1.10 AS bldr

WORKDIR "/go/src/github.com/oliver006/redis_exporter"

COPY exporter exporter/
COPY vendor vendor/
COPY main.go .

RUN env CGO_ENABLED=0 GOOS=linux GO15VENDOREXPERIMENT=1 GOARCH=amd64 \
    go build -o redis_exporter main.go && \
    mv redis_exporter /redis_exporter

FROM scratch
COPY --from=bldr /redis_exporter /redis_exporter
EXPOSE     9121
ENTRYPOINT [ "/redis_exporter" ]
