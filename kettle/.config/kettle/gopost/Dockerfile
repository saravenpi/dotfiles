FROM golang:1.23-alpine

RUN apk add --no-cache git ca-certificates tzdata

RUN adduser -D appuser

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download
RUN go mod tidy

COPY . .

RUN go build -o webserver main.go

USER appuser

EXPOSE 8080

CMD ["./webserver"]
