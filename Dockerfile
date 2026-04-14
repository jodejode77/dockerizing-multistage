FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod ./

RUN go mod download

COPY helloworld.go ./
RUN go build -o hello-app helloworld.go

FROM alpine:3.20

WORKDIR /app

RUN apk add --no-cache ca-certificates tzdata && \
    addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/hello-app ./hello-app

USER appuser

EXPOSE 8080

CMD ["./hello-app"]
