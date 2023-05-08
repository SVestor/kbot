APP=$(shell basename $(shell git remote get-url origin))
REGYSTRY=svestor
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux 
TARGETARCH=arm64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v 	

goget:
	go get

build: format goget
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGYSTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGYSTRY}/${APP}:${VERSION}-${TARGETARCH} 	

clean:
	rm -rf kbot
