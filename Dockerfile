FROM golang AS builder
WORKDIR /k8s-example
COPY go.mod .
COPY go.sum .
ENV GOPROXY=https://goproxy.cn,direct
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /k8s-example/k8s-example .

FROM alpine:latest
#RUN apk --no-cache add ca-certificates
#RUN addgroup -S k8s-example && adduser -S k8s-example -G k8s-example
#USER k8s-example
WORKDIR /k8s-example
COPY --from=builder /k8s-example ./
EXPOSE 8090
ENTRYPOINT ["./k8s-example"]