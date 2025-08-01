FROM golang:1.24-alpine AS build
WORKDIR /src
COPY go.* ./
RUN go mod download
COPY . .
ENV CGO_ENABLED=0
RUN apk --no-cache add git
RUN go mod tidy -v
#RUN go test ./...
RUN go build -o /kube-summary-exporter .

FROM alpine:3.22
COPY --from=build /kube-summary-exporter /kube-summary-exporter

ENTRYPOINT [ "/kube-summary-exporter"]
