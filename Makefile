APP=$(shell basename $(shell git remote get-url origin))
REGYSTRY=svestor
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=arm64 #amd64 arm64
CGO_ENABLED=0

linux:
	${MAKE} build TARGETOS=linux TARGETARCH=${TARGETARCH}

macos:
	${MAKE} build TARGETOS=darwin TARGETARCH=${TARGETARCH}

windows:
	${MAKE} build TARGETOS=windows TARGETARCH=${TARGETARCH} CGO_ENABLED=1

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v 	

goget:
	go get

build: format goget
	CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/den-vasyliev/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGYSTRY}/${APP}:${VERSION}-${TARGETARCH} --build-arg CGO_ENABLED=${CGO_ENABLED} --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS} 

push:
	docker push ${REGYSTRY}/${APP}:${VERSION}-${TARGETARCH} 	

clean:
	rm -rf kbot
