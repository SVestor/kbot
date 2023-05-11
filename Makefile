.EXPORT_ALL_VARIABLES:

APP=$(shell basename $(shell git remote get-url origin))
REGYSTRY=svestor
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
OS=linux  
OS1=windows
OS2=darwin #MacOS
OS3=android

format:
	@gofmt -s -w ./

lint:
	golint

test:
	@go test -v 	

goget:
	@go get

linux: format goget
	@read -p "Enter the desired architecture to make a binary for Linux: |amd64|386|arm64|arm| : " ARCH && \
		export ARCH=$$ARCH && \
	case $$ARCH in \
        (amd64) \
             CGO_ENABLED=0 GOOS=${OS} GOARCH=$$ARCH go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
			echo " !!! Your Linux binary for $$ARCH was built and is ready to use !!!"; \
                       	;; \
        (arm64) \
            CGO_ENABLED=0 GOOS=${OS} GOARCH=$$ARCH go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
			echo " !!! Your Linux binary for $$ARCH was built and is ready to use !!!"; \
			;; \
	(arm) \
            CGO_ENABLED=0 GOOS=${OS} GOARCH=$$ARCH go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
	    		echo " !!! Your Linux binary for $$ARCH was built and is ready to use !!!"; \
            ;; \
	(386) \
            CGO_ENABLED=0 GOOS=${OS} GOARCH=$$ARCH go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
	    		echo " !!! Your Linux binary for 386 was built and is ready to use !!!"; \
            ;; \
        esac ; \
	if [ "$(shell read -p "Wish to make an image with a binary type |y| , if need binary only type |n| ? : " YESS && echo $$YESS)" = "y" ]; then \
	$(call build_image, $(ARCH)); \
        fi 	
	
windows: format goget
	 @read -p "Enter the desired architecture to make a binary for Windows: |amd64|386|arm64|arm| : " ARCH && \
                export ARCH=$$ARCH && \
        case $$ARCH in \
        (amd64) \
             CGO_ENABLED=0 GOOS=${OS1} GOARCH=$$ARCH go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Windows binary for $$ARCH was built and is ready to use !!!"; \
                        ;; \
        (arm64) \
            CGO_ENABLED=0 GOOS=${OS1} GOARCH=$$ARCH go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Windows binary for $$ARCH was built and is ready to use !!!"; \
                        ;; \
        (arm) \
            CGO_ENABLED=0 GOOS=${OS1} GOARCH=$$ARCH go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Windows binary for $$ARCH was built and is ready to use !!!"; \
            ;; \
        (386) \
            CGO_ENABLED=0 GOOS=${OS1} GOARCH=$$ARCH go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Windows binary for 386 was built and is ready to use !!!"; \
            ;; \
        esac ; \
        if [ "$(shell read -p "Wish to make an image with a binary type |y| , if need binary only type |n| ? : " YESS && echo $$YESS)" = "y" ]; then \
        $(call build_image, $(ARCH)); \
        fi

macos: format goget
	 @read -p "Enter the desired architecture to make a binary for MacOS: |amd64|arm64| : " ARCH && \
                export ARCH=$$ARCH && \
        case $$ARCH in \
        (amd64) \
             CGO_ENABLED=0 GOOS=${OS2} GOARCH=$$ARCH go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your MacOs binary for $$ARCH was built and is ready to use !!!"; \
                        ;; \
        (arm64) \
            CGO_ENABLED=0 GOOS=${OS2} GOARCH=$$ARCH go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your MacOs binary for $$ARCH was built and is ready to use !!!"; \
            ;; \
        esac ; \
        if [ "$(shell read -p "Wish to make an image with a binary type |y| , if need binary only type |n| ? : " YESS && echo $$YESS)" = "y" ]; then \
        $(call build_image, $(ARCH)); \
        fi

android: format goget
	 @read -p "Enter the desired architecture to make a binary for Android: |amd64|arm64| : " ARCH && \
                export ARCH=$$ARCH && \
        case $$ARCH in \
        (amd64) \
             CGO_ENABLED=0 GOOS=${OS3} GOARCH=$$ARCH go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Android binary for $$ARCH was built and is ready to use !!!"; \
                        ;; \
        (arm64) \
            CGO_ENABLED=0 GOOS=${OS3} GOARCH=$$ARCH go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}; \
                        echo " !!! Your Android binary for $$ARCH was built and is ready to use !!!"; \
            ;; \
        esac ; \
        if [ "$(shell read -p "Wish to make an image with a binary type |y| , if need binary only type |n| ? : " YESS && echo $$YESS)" = "y" ]; then \
        $(call build_image, $(ARCH)); \
        fi
build_image = docker build --build-arg ARCH="$(1)" -t ${REGYSTRY}/${APP}:${VERSION}-$$ARCH .

push:
	docker push ${REGYSTRY}/${APP}:${VERSION}-${TARGETARCH} 	

clean:
	rm -rf kbot
