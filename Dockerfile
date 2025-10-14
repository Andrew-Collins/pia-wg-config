FROM golang:alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY main.go ./
COPY pia/ ./pia/
COPY vendor/ ./vendor/

RUN CGO_ENABLED=0 GOOS=linux go build

FROM alpine:latest
RUN apk --no-cache add ca-certificates wireguard-tools
COPY --from=builder /app/pia-wg-config /usr/local/bin/
ENTRYPOINT ["pia-wg-config"]
