---
title: go 项目管理记录
date: 2018-07-07 12:15:00
tags:
  - golang
categories:
  - golang
---

**使用工具：** star 最多的 [官方的 dep](https://github.com/golang/dep)

### 翻墙问题：

+ shadowsocks-qt5

  ```
  sudo add-apt-repository ppa:hzwhuang/ss-qt5
  sudo apt-get update
  sudo apt-get install shadowsocks-qt5
  ```

+ polipo

  ```
  sudo apt-get install polipo
  ```

+ sudo vim /etc/polipo/config

  ```
  socksParentProxy = "localhost:1080"
  socksProxyType = socks5
  logLevel=4
  ```

+ 重启polipo

  ```
  sudo service polipo stop
  sudo service polipo start
  ```

+ 设置别名

  ```
  alias hp="http_proxy=http://localhost:8123"
  aliax hps="https_proxy=http://localhost:8123"
  ```

+ 使用示例

  ```
  hps go get -u -v github.com/labstack/echo/...
  ```

### 项目结构：

$GOPATH

+ bin

  dep gocode goimports golint go-outline gopkgs gorename impl godef goreturns godoc gurn等工具

+ src

  + github.com
      + my-github

  + myproject1

      + vendor

        项目依赖包

      + main.go

      + package1

        自己写的包

  + myproject2

### Go vendor

要求 go 版本 大于 1.6

注意事项：

+ vendor 只能在 package 中存在，不能超越这个范围。也就意味着 vendor 不能是 $GOPATH/src 一级目录，否则报错。
+ vendor 可以嵌套使用，就是 vendor 里面可以还有 vendor

好处：

+ 多项目管理，有自己的包依赖，工程隔离
+ 可以平滑从非 vendor 项目转换为 vendor 项目
+ vendor 可以记录项目依赖包及其版本信息，任意升级换代，也任意维护

### 一个流程

+ cd /path/to/your/project
+ 写好之后 dep init -v
+ 运行：go run main.go
+ 编译：go build -o www

常用命令：

```
dep init -v  # 初始化项目依赖
dep ensure -v  # 安装项目依赖
dep ensure -update  # 更新依赖版本
```

### vscode 库

```
hp go get -u -v github.com/bytbox/golint
hp go get -u -v github.com/golang/tools
hp go get -u -v github.com/lukehoban/go-outline
hp go get -u -v github.com/newhook/go-symbols
hp go get -u -v github.com/josharian/impl
hp go get -u -v github.com/sqs/goreturns
hp go get -u -v github.com/cweill/gotests
hp go get -u -v github.com/nsf/gocode
hp go get -u -v github.com/rogpeppe/godef
hp go get -u -v golang.org/x/tools/cmd/gorename
hp go get -u -v github.com/tpng/gopkgs
hp go get -u -v golang.org/x/tools/cmd/guru
```

注：

```
alias hp="http_proxy=http://localhost:8123" # 8123 会转到shadowsocks
```



### 常用库记录

[Go Popular Packages](https://godoc.org/)

[awesome-go](https://github.com/avelino/awesome-go)

+ [jsonparser](https://github.com/buger/jsonparser#benchmarks)

  Alternative JSON parser for Go that does not require schema (so far fastest)

+ [go-simplejson](https://github.com/bitly/go-simplejson)

  a Go package to interact with arbitrary JSON

+ [mgo](https://godoc.org/gopkg.in/mgo.v2)

  MongoDB driver for the Go language that implements a rich and well tested selection of features under a very simple API following standard Go idioms

+ [redisgo](https://godoc.org/github.com/gomodule/redigo/redis)

  Redigo is a [Go](http://golang.org/) client for the [Redis](http://redis.io/) database.

+ [mysql](https://godoc.org/github.com/go-sql-driver/mysql)

  Package mysql provides a MySQL driver for Go's database/sql package

+ [echo](https://echo.labstack.com/guide)

  High performance, minimalist Go web framework

+ [gin](https://gin-gonic.github.io/gin/)

+ [protobuf](https://godoc.org/github.com/golang/protobuf/proto)

+ [logrus](https://godoc.org/github.com/sirupsen/logrus)

+ [zap](https://godoc.org/go.uber.org/zap)

  Package zap provides fast, structured, leveled logging.

+ [grpc](https://godoc.org/google.golang.org/grpc)

+ [assert](https://godoc.org/github.com/stretchr/testify/assert)

+ [cron](https://godoc.org/github.com/robfig/cron)

  Package cron implements a cron spec parser and job runner

+ [validator](https://godoc.org/gopkg.in/go-playground/validator.v9)

  Package validator implements value validations for structs and individual fields based on tags.

+ [session](https://github.com/gorilla/sessions)

  provides cookie and filesystem sessions and infrastructure for custom session backends.

+ [req](https://github.com/imroc/req)

  A golang http request library for humans

+ [uuid](https://godoc.org/github.com/satori/go.uuid)

+ [now](https://github.com/jinzhu/now)

+ [leaf](https://godoc.org/github.com/name5566/leaf)

+ [resize](https://github.com/nfnt/resize)

