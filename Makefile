APP=$(shell basename $(shell git remote get-url origin))
REGYSTRY=svestor
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
OS=linux  
OS1=windows
OS2=darwin #MacOS
OS3=android
AMDARCH=amd64

format:
	@gofmt -s -w ./

lint:
	golint

test:
	@go test -v 	

goget:
	@go get

linux: format goget
	@case "$(shell read -p "Enter the desired architecture to make it for Linux: |amd64|386|arm64|arm| : " ARCH && echo $$ARCH )" in \
        (amd64) \
             CGO_ENABLED=0 GOOS=${OS} GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
			echo " !!! Your Linux package for amd64 was built and is ready to use !!!"; \
			;; \
        (arm64) \
            CGO_ENABLED=0 GOOS=${OS} GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
			echo " !!! Your Linux package for arm64 was built and is ready to use !!!"; \
			;; \
	(arm) \
            CGO_ENABLED=0 GOOS=${OS} GOARCH=arm go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
	    		echo " !!! Your Linux package for arm was built and is ready to use !!!"; \
            ;; \
	(386) \
            CGO_ENABLED=0 GOOS=${OS} GOARCH=386 go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
	    		echo " !!! Your Linux package for 386 was built and is ready to use !!!"; \
            ;; \
        esac
windows: format goget
	@case "$(shell read -p "Enter the desired architecture to make it for Windows: |amd64|386|arm64|arm| : " ARCH && echo $$ARCH )" in \
        (amd64) \
             CGO_ENABLED=0 GOOS=${OS1} GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Windows package for amd64 was built and is ready to use !!!"; \
                        ;; \
        (arm64) \
            CGO_ENABLED=0 GOOS=${OS1} GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Windows package for arm64 was built and is ready to use !!!"; \
                        ;; \
        (arm) \
            CGO_ENABLED=0 GOOS=${OS1} GOARCH=arm go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Windows package for arm was built and is ready to use !!!"; \
            ;; \
        (386) \
            CGO_ENABLED=0 GOOS=${OS1} GOARCH=386 go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Windows package for 386 was built and is ready to use !!!"; \
            ;; \
        esac

macos: format goget
	@case "$(shell read -p "Enter the desired architecture to make it for MacOS: |amd64|arm64| : " ARCH && echo $$ARCH )" in \
        (amd64) \
             CGO_ENABLED=0 GOOS=${OS2} GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your MacOS package for amd64 was built and is ready to use !!!"; \
                        ;; \
        (arm64) \
            CGO_ENABLED=0 GOOS=${OS2} GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your MacOS package for arm64 was built and is ready to use !!!"; \
                        ;; \
        esac

android: format goget
	@case "$(shell read -p "Enter the desired architecture to make it for Android: |amd64|386|arm64|arm| : " ARCH && echo $$ARCH )" in \
        (amd64) \
             CGO_ENABLED=0 GOOS=${OS3} GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Android package for amd64 was built and is ready to use !!!"; \
                        ;; \
        (arm64) \
            CGO_ENABLED=0 GOOS=${OS3} GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Android package for arm64 was built and is ready to use !!!"; \
                        ;; \
        (arm) \
            CGO_ENABLED=0 GOOS=${OS3} GOARCH=arm go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Android package for arm was built and is ready to use !!!"; \
            ;; \
        (386) \
            CGO_ENABLED=0 GOOS=${OS3} GOARCH=386 go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Android package for 386 was built and is ready to use !!!"; \
            ;; \
        esac

image: linux
	docker build . -t ${REGYSTRY}/${APP}:${VERSION}-${AMDARCH}

push:
	docker push ${REGYSTRY}/${APP}:${VERSION}-${TARGETARCH} 	

clean:
	rm -rf kbot




    



