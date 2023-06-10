.EXPORT_ALL_VARIABLES:

#APP=$(shell basename $(shell git remote get-url origin))
#REGISTRY=svestor
CREG=docker.io
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
OS=linux
ARCH=amd64
OS1=windows
OS2=darwin #MacOS
OS3=android
CGO_ENABLED=0
TAG=$(shell docker images --format "{{.Repository}}:{{.Tag}}")

format:
	@gofmt -s -w ./

lint:
	golint

test:
	@go test -v 	

goget:
	@go get

linux: 
	@read -p "Enter the desired architecture to make a binary for Linux: |amd64|386|arm64|arm| : " ARCH && \
		export ARCH=$$ARCH && \
	case $$ARCH in \
        (amd64) \
             ${MAKE} build OS=${OS}  ARCH=$$ARCH ; \
			echo " !!! Your Linux binary for $$ARCH was built and is ready to use !!!"; \
                       	;; \
        (arm64) \
            ${MAKE} build OS=${OS}  ARCH=$$ARCH ; \
			echo " !!! Your Linux binary for $$ARCH was built and is ready to use !!!"; \
			;; \
	(arm) \
            ${MAKE} build OS=${OS}  ARCH=$$ARCH ; \
	    		echo " !!! Your Linux binary for $$ARCH was built and is ready to use !!!"; \
            ;; \
	(386) \
            ${MAKE} build OS=${OS}  ARCH=$$ARCH ; \
	    		echo " !!! Your Linux binary for 386 was built and is ready to use !!!"; \
            ;; \
        esac ; \
	if [ "$(shell read -p "Wish to make an image with a binary type |y| , if need binary only type |n| ? : " YESS && echo $$YESS)" = "y" ]; then \
	${MAKE} image OS=${OS} CGO_ENABLED=${CGO_ENABLED} ARCH=$$ARCH; \
        fi 	
	
windows: 
	 @read -p "Enter the desired architecture to make a binary for Windows: |amd64|386|arm64|arm| : " ARCH && \
                export ARCH=$$ARCH && \
        case $$ARCH in \
        (amd64) \
             ${MAKE} build OS=${OS1}  ARCH=$$ARCH CGO_ENABLED=1 ; \
                        echo " !!! Your Windows binary for $$ARCH was built and is ready to use !!!"; \
                        ;; \
        (arm64) \
            ${MAKE} build OS=${OS1}  ARCH=$$ARCH CGO_ENABLED=1 ; \
                        echo " !!! Your Windows binary for $$ARCH was built and is ready to use !!!"; \
                        ;; \
        (arm) \
            ${MAKE} build OS=${OS1}  ARCH=$$ARCH CGO_ENABLED=1 ; \
                        echo " !!! Your Windows binary for $$ARCH was built and is ready to use !!!"; \
            ;; \
        (386) \
            ${MAKE} build OS=${OS1}  ARCH=$$ARCH CGO_ENABLED=1 ; \
                        echo " !!! Your Windows binary for 386 was built and is ready to use !!!"; \
            ;; \
        esac ; \
        if [ "$(shell read -p "Wish to make an image with a binary type |y| , if need binary only type |n| ? : " YESS && echo $$YESS)" = "y" ]; then \
        ${MAKE} image OS=${OS1} CGO_ENABLED=1 ARCH=$$ARCH; \
        fi

macos: 
	 @read -p "Enter the desired architecture to make a binary for MacOS: |amd64|arm64| : " ARCH && \
                export ARCH=$$ARCH && \
        case $$ARCH in \
        (amd64) \
             ${MAKE} build OS=${OS2}  ARCH=$$ARCH ; \
                        echo " !!! Your MacOs binary for $$ARCH was built and is ready to use !!!"; \
                        ;; \
        (arm64) \
            ${MAKE} build OS=${OS2}  ARCH=$$ARCH ; \
                        echo " !!! Your MacOs binary for $$ARCH was built and is ready to use !!!"; \
            ;; \
        esac ; \
        if [ "$(shell read -p "Wish to make an image with a binary type |y| , if need binary only type |n| ? : " YESS && echo $$YESS)" = "y" ]; then \
        ${MAKE} image OS=${OS2} CGO_ENABLED=${CGO_ENABLED} ARCH=$$ARCH; \
        fi

android: 
	 @read -p "Enter the desired architecture to make a binary for Android: |amd64|arm64| : " ARCH && \
                export ARCH=$$ARCH && \
        case $$ARCH in \
        (amd64) \
             ${MAKE} build OS=${OS3}  ARCH=$$ARCH ; \
                        echo " !!! Your Android binary for $$ARCH was built and is ready to use !!!"; \
                        ;; \
        (arm64) \
            ${MAKE} build OS=${OS3}  ARCH=$$ARCH ; \
                        echo " !!! Your Android binary for $$ARCH was built and is ready to use !!!"; \
            ;; \
        esac ; \
        if [ "$(shell read -p "Wish to make an image with a binary type |y| , if need binary only type |n| ? : " YESS && echo $$YESS)" = "y" ]; then \
        ${MAKE} image OS=${OS3} CGO_ENABLED=${CGO_ENABLED} ARCH=$$ARCH; \
        fi

build: format goget
	CGO_ENABLED=${CGO_ENABLED} GOOS=${OS} GOARCH=${ARCH} go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=${VERSION}

image: cleankb
	docker build . -t ${CREG}/${REGISTRY}/${APP}:${VERSION}-${OS}-${ARCH} \
	--build-arg ARCH=${ARCH} --build-arg OS=${OS} --build-arg CGO_ENABLED=${CGO_ENABLED}

push:
	docker push ${CREG}/${REGISTRY}/${APP}:${VERSION}-${OS}-${ARCH}	

cleanall:
	rm -rf kbot 
	docker rmi -f ${shell docker images -q}
	docker rm -f $(shell docker ps -a -q)

clean:
	docker rmi -f ${TAG}

cleankb:
	rm -rf kbot

