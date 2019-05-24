FROM golang:alpine AS build
WORKDIR /go/src/github.com/yarsiemanym/wiki/

ADD ./*.go ./
ADD ./templates ./templates

# 0.    Set some shell flags like `-e` to abort the 
#       execution in case of any failure (useful if we 
#       have many ';' commands) and also `-x` to print to 
#       stderr each command already expanded.
# 1.    Get into the directory with the golang source code
# 2.    Perform the go build with some flags to make our
#       build produce a static binary (CGO_ENABLED=0 and 
#       the `netgo` tag).
# 3.    copy the final binary to a suitable location that
#       is easy to reference in the next stage
RUN set -ex && \     
  CGO_ENABLED=0 go build -tags netgo -v -a -ldflags '-extldflags "-static"'

FROM scratch
WORKDIR /
COPY --from=build /go/src/github.com/yarsiemanym/wiki/wiki .
COPY --from=build /go/src/github.com/yarsiemanym/wiki/templates ./templates

# Set the binary as the entrypoint of the container
ENTRYPOINT [ "./wiki" ]
EXPOSE 8080