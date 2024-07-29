FROM golang as builder


WORKDIR /go

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o transmission-exporter -v ./cmd/transmission-exporter

FROM alpine:latest
RUN apk add --update ca-certificates

COPY --from=builder /go/transmission-exporter /usr/bin/transmission-exporter

# ADD ./transmission-exporter /usr/bin/transmission-exporter

EXPOSE 19091

ENTRYPOINT ["/usr/bin/transmission-exporter"]
