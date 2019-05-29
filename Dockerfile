FROM golang:alpine AS build
WORKDIR /go/src/github.com/yarsiemanym/wiki/

ADD ./*.go ./
ADD ./lib ./lib
ADD ./templates ./templates
ADD ./content ./content
ADD ./scripts ./scripts

# 1.    Set some shell flags like `-e` to abort the 
#       execution in case of any failure (useful if we 
#       have many ';' commands) and also `-x` to print to 
#       stderr each command already expanded.
# 2.    Perform the go build with some flags to make our
#       build produce a static binary (CGO_ENABLED=0 and 
#       the `netgo` tag).
RUN set -ex && CGO_ENABLED=0 go build -tags netgo -v -a -ldflags '-extldflags "-static"'

FROM alpine
WORKDIR /
COPY --from=build /go/src/github.com/yarsiemanym/wiki/wiki .
COPY --from=build /go/src/github.com/yarsiemanym/wiki/templates ./templates
COPY --from=build /go/src/github.com/yarsiemanym/wiki/content ./content
COPY --from=build /go/src/github.com/yarsiemanym/wiki/scripts ./scripts
RUN mkdir data

# Set the binary as the entrypoint of the container
ENTRYPOINT [ "./wiki" ]
EXPOSE 8080