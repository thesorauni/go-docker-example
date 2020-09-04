FROM golang:alpine AS builder

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /build

COPY go.mod go.sum main.go ./
COPY database ./database

RUN go mod download

RUN go build -o main .

WORKDIR /dist

RUN cp /build/main . && mkdir database && cp /build/database/data.json ./database

FROM scratch

COPY --from=builder /dist .

ENTRYPOINT ["/main"]