FROM golang:1.10.3-alpine as builder
ARG GOPROXY_VERSION=master
RUN apk update && apk upgrade && \
    apk add --no-cache git && cd /go/src/ && git clone https://github.com/snail007/goproxy && \
	cd goproxy && git checkout ${GOPROXY_VERSION} && \
    go get && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o proxy
FROM alpine:5.2
COPY --from=builder /go/src/goproxy/proxy /
RUN mkdir /data
VOLUME ["/data"]
EXPOSE 33080
CMD /proxy ${OPTS}
