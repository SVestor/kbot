# kbot
dev app from scratch <br>
an app for sending messages to via CLI or by a telegram UI 

## Telegram bot's URL
URL: [t.me/SV_bot](https://t.me/AndSVestor_bot) 

## Getting started
```zsh
- CLI
$ git@github.com:SVestor/kbot.git
$ cd kbot

$ read -s TELE_TOKEN
# type a telegram API token here

$ export TELE_TOKEN
$ gofmt -s -w ./
$ go get
$ go build -v -o kbot -ldflags "-X="github.com/SVestor/kbot/cmd.appVersion=v1.0.7

$ ./kbot help
$ ./kbot version
$ ./kbot start

- UI
Use the URL above to access the telegram UI to communicate with an app
- "/start hello"
```



