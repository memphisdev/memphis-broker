# FROM golang:rc-alpine3.15

# # Set the Current Working Directory inside the container
# WORKDIR $GOPATH/src/memphis-broker

# # Copy everything from the current directory to the PWD (Present Working Directory) inside the container
# COPY . .

# # Install GIT
# RUN apk add git

# # Download all the dependencies
# RUN go get -d -v .

# # Install the package
# RUN go install -v .

# # This container exposes port 5555 to the outside world
# EXPOSE 5555

# # Run the executable
# CMD ["memphis-broker"]



FROM golang:1.18-alpine3.15 as build

WORKDIR $GOPATH/src/memphis-broker
COPY . .
RUN go build -ldflags="-w" -o /memphis-broker-build

FROM alpine:3.15
WORKDIR $GOPATH/src/memphis-broker
COPY . .
# COPY --from=build $GOPATH/src/memphis-broker/config/* .
# COPY --from=build $GOPATH/src/memphis-broker/version.conf .
COPY --from=build /memphis-broker-build /memphis-broker-build

EXPOSE 5555

CMD [ "/memphis-broker-build" ]