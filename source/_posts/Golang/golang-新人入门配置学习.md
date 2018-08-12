---
title: golang 新人入门配置学习
date: 2017-12-21 09:27:25
tags: 
	- golang
	- config
	- introduction   #入门
	- 入门
categories: 
	- golang
---

1. windows下 golang 安装与配置

   请参照：http://www.jianshu.com/p/b6f34ae55c90

2. Ubuntu下 golang 安装与配置

   - 安装最新版本 golang 方法 （推荐）

     1. 下载： https://www.golangtc.com/download

     2. 解压安装包`tar -C /usr/local -xzf <安装包>` （其中 `/usr/local` 为 go 的解压目录即GOROOT，也可以安装到自己想要的位置，后面配置一下就行了）

     3. 环境配置

        - 在 ~/.bashrc 最后一行加上 `export PATH=$PATH:/usr/local/go/bin` 

          注：`:` 为分隔符，即配置多个路径时使用； `/usr/local/go/bin` 为 go 安装位置下的 bin 目录

          功效：用于 在bash 下使用命令 `go` 等命令（可看 bin 目录下有哪些可执行文件）

        - 之后 运行 `source .bashrc` 更新 PATH

          注：如果终端为 zsh, fish 命令  ` source ` 可能失效，这时需要输入 `bash` 进入 bash 执行，但是当返回zsh 或者 fish等其他终端时可能还是无法使用 命令 ` go ` ，这是因为你的 zsh 或者 fish 有自己单独的config 文件，你需要在那个文件最后一行加上相应代码（由于不同终端配置语法不同，此处不做扩展)

          > ` /etc/profile，/root/.bashrc ` 是系统全局环境变量设定
          > ` ~/.profile，~/.bashrc ` 用户家目录下的私有环境变量设定
          >
          > ​
          >
          > 当登入系统时候获得一个shell进程时，其读取环境设定档有三步
          >
          > 1. 首先读入的是全局环境变量设定档 `/etc/profile`，然后根据其内容读取额外的设定的文档
          > 2. 然后根据不同使用者帐号，去其家目录读取 ` ~/.profile`
          > 3. 然后在根据用户帐号读取 ` ~/.bashrc ` 
          >
          > ​
          >
          > ` ~/.profile ` 与 `~/.bashrc ` 的区别
          > ` ~/.profile ` 可以设定本用户专有的路径，环境变量，等，它只能登入的时候执行一次
          > ` ~/.bashrc ` 也是某用户专有设定文档，可以设定路径，命令别名，每次shell script的执行都会使用它一次

        - 配置 GOPATH （可选）

          1. 在 `~/.bashrc ` 或者  `~/.profile`最后一行加上 `export GOPATH=$HOME<你的工作目录>`
          2. 进入bash 执行 `source ~/.bashrc` 或者 ` ~/.profile` ，如果此时没有生效，可尝试重启或者注销重新登录

   - 直接一键安装，但是版本不一定是最新的

     安装命令： ` sudo apt install golang-go `

     > 也可以在安装之前通过 `apt-cache search golang-go` 搜索可见 golang-go 版本等

     - PATH 和 GOPATH 等见上文环境配置

3. golang 项目目录结构

   一个Go项目在GOPATH下，会有如下三个目录：

   - src存放源代码 ( .go )
   - pkg编译后生成的文件 
   - bin编译后生成的可执行文件 ( .a )

   ​

   ```
   <project>
         |--<bin>
         |--<pkg>
         |--<src>
            |--<a>
                |--<a1>
                    |--al.go
                |--<a2>
                    |--a2.go
            |--<b>
                |--b1.go
                |--b2.go
   ```

4. ` PATH GOPATH ` 等简介

   - GOROOT

     GO 语言安装的路径，如我的 Ubuntu 下的是` /usr/local/go`，类似于JAVA中的JAVA_HOME

   - GOPATH

     GOPATH 表示代码包或项目所在的地址，可以设置多个，不同地址之间使用 `:` 分隔

     > 假设：` GOPATH=~/project1:~/project2，GOROOT=/usr/local/go`，在代码中引用了包：` github.com/bitly/nsq/util `
     >
     > GO程序在编译时会按先后次序到以下目录中寻找源码：
     >
     > ` ~/project1/github.com/bitly/nsq/util `
     >
     > `~/project2/github.com/bitly/nsq/util `
     >
     > ` /usr/local/go/github.com/bitly/nsq/util` 

   - PATH

      **可执行程序的路径**，在命令行执行命令时，系统默认会在PATH中指定路径里寻找。比如linux下我们用最常用的` cd `命令，执行时我们并未指定 `cd ` 命令的路径，也没有切换到 ` cd ` 所在的目录下去执行该命令。这就是因为 ` cd ` 命令的可执行文件所在的目录在PATH中录入了。

     `go` 安装后，在GOROOT/bin目录，如 Ubuntu 的 ` /usr/local/go/bin` 目录下会有 go 、godoc、gofmt 三个可执行命令。为了方便在编译go项目时方便的使用` go build、go install ` 等命令，需要将GOROOT/bin目录加入到系统的PATH路径下。

   - GOARCH

     CPU 架构，如： amd64, 386

   - GOOS

     操作系统，如：linux

   - GOBIN

     工作目录下的bin文件夹

   - GOEXE

     生成的可执行文件后缀

   - GOHOSTARCH

     想要交叉编译的CPU架构

   - GOHOSTOS

     想要交叉编译的操作系统

5. go 基本命令介绍

   Go命令一般**格式**：

   ```
   go command [arg]
   ```

   其中，command是操作命令，arg是该命令的参数

   #### 常用命令介绍：

   - go get

     用于动态获取远程代码包，如果是从GitHub上获取，则需要现安装git，如果是从Google Code上获取，则需要安装hg。go get 获取的远程代码包将被下载到 `GOPATH` 目录下的` src `文件夹中

     ` eg: go get -u github.com/nsf/gocode `

   - go install

     1. 编译导入的包文件，所有导入的包文件编译完才会编译主程序
     2. 将编译后生成的可执行文件放到bin目录下（GOPATH/bin），编译后的包文件放到pkg目录下（GOPATH/pkg）

   - go run

     用于编译并直接运行程序，它会生成一个临时文件（但不是一个标准的可执行文件），直接在命令行打印输出程序执行结果，方便用户调试。

     ` eg: go run main.go`

   - go build

     用于测试编译包，可检查是否存在编译错误，如果被编译的是main包，会生成可执行文件。

     ```
     #编译
     go build main.go
     #运行
     ./main
     ```

   - go fmt

     用于格式化源码，有的IDE保存源码时自动执行该命令，比如subl，也可手动执行它。

     ` eg: go fmt main.go`

   - go test

     用于运行测试文件，该命令会自动读取源码目录下的名为：*_test.go的文件，生成并运行测试用的可执行文件，测试成功会显示“PASS”、“OK”等信息。

   - 其他

     1. go clean：用来移除当前源码包里面编译生成的文件 
     2. go env: 查看当前用户的go环境变量 
     3. go fix: 用来修复以前老版本的代码到新版本 
     4. go list: 列出当前全部安装的packge 
     5. go version: 查看当前go版本

   **hello world：**

   main.go 代码：

   ```
   package main

   import (
       "fmt"
   )

   func main() {
       fmt.Println("Hello World!")
   }
   ```

   进入该文件所在目录，尝试编译运行：

   ```
   go run main.go
   ```

   终端会输出 Hello World! ，则运行成功

6. sublime 配置 golang 环境

   + 安装 GoSublime 

     运行：Ctrl + B 

     个人 GoSublime 配置：

     ```
     {
         "env": {
             "PATH": "$PATH",
             // "GOPATH": "$HOME/Projects/Go/test",
             // "GOPATH": "$GOPATH:$GS_GOPATH",
             "GOPATH": "$GS_GOPATH"
         },
         "comp_lint_enabled":true,
         "lint_enabled": true,
         "autocomplete_builtins": true,
         "fmt_cmd" :[ "goimports"],
         "snippets": [
             {
                 "match": {"global": true, "pkgname": "."},
                 "snippets": [
                     {
                         "text":"type",
                         "title":"type struct {}",
                         "value":"type ${1:name} struct {\n\t$0\n}"
                     },{
                         "text":"type",
                         "title":"type interface {}",
                         "value":"type ${1:name} interface {\n\t$0\n}"
                     },{
                         "text":"var",
                         "title":"var struct {}",
                         "value":"var ${1:name} struct {\n\t$0\n}"
                     },{
                         "text":"map",
                         "title":"map[...]...",
                         "value":"map[${1:string}]${2:interface{}}"
                     },{
                         "text":"interface",
                         "title":"interface{}",
                         "value":"interface{}"
                     },{
                         "text":"if",
                         "title":"if err != nil {...}",
                         "value":"if ${1:err} ${2:!=} ${3:nil} {\n\t$0\n}"
                     },{
                         "text":"if",
                         "title":"if ret,ok := func(); ok {...}",
                         "value":"if ${1:ret,} ${2:ok} ${3::=} ${4:func()}; ${5:!ok} {\n\t$0\n}"
                     },{
                         "text":"break",
                         "title":"break",
                         "value":"break"
                     },{
                         "text":"continue",
                         "title":"continue",
                         "value":"continue"
                     },{
                         "text":"defer",
                         "title":"defer func()",
                         "value":"defer ${0:func()}"
                     },{
                         "text":"for",
                         "title":"for k,v := range func() {...}",
                         "value":"for ${1:k,}${2:v} := range ${3:func()} {\n\t$0\n}"
                     },{
                         "text":"switch",
                         "title":"switch ... {...}",
                         "value":"switch ${1:name} {\ncase ${2:v}:\n\t$3\ndefault:\n\t$0\n}"
                     }
                 ]
             }
         ],
     }

     ```

     注：

     `GS_GOPATH` is a pseudo-environment-variable. It's changed to match a possible GOPATH based on:

     - the current working directory, e.g. `~/go/src/pkg` then `$GS_GOPATH` will be `~/go/`
     - or the path the current `.go` file (or last activated `.go` file if the current file is not `.go`) e.g. if your file path is `/tmp/go/src/hello/main.go` then it will be `/tmp/go`

     简单说就是 GS_GOPATH 是用来自动根据当前目录设置 GOPATH 的

   + 安装 gocode

     ```
     go get -u github.com/nsf/gocode
     go install github.com/nsf/gocode
     ```

     安装完成后，我们可以在 $GOPATH/bin 目录下，发现多出了个 gocode 文件

7. 常用 tools

   - gocode 提供代码补全

     `go get -u github.com/nsf/gocode`

   - godef 代码跳转

     ```
     go get -v code.google.com/p/rog-go/exp/cmd/godef
     go install -v code.google.com/p/rog-go/exp/cmd/godef
     ```

   - gofmt 自动代码整理

   - golint 代码语法检查

     ```
     go get github.com/golang/lint
     go install github.com/golang/lint
     ```

   - goimports 自动整理imports

     `go get golang.org/x/tools/cmd/goimports`

8. 安装 `echo` 

   [官方教程](https://echo.labstack.com/guide)

   安装：` go get -u github.com/labstack/echo/...`

   注：如果无法翻墙可能会报错 `package golang.org/x/crypto/acme/autocert: unrecognized import path "golang.org/x/crypto/acme/autocert"`

   **解决方案:** 

   >分析错误，我们缺少crypto组件，需要下载，使用` go get golang.org/x/crypto/acme/autocert`来下载，但是 crypto 官方地址在外网
   >
   >好在 golang.org 在 github.com 上有备份仓库，所以缺少的组件可以在 github 上下载
   >
   >eg: 安装 crypto 组件
   >
   >github 地址： https://github.com/golang/crypto
   >
   >过程：
   >
   >```
   >mkdir -p /usr/local/go/src/golang.org/x/
   >git clone git@github.com:golang/crypto.git
   >mv crypto /usr/local/go/golang.org/x/
   >```

   **测试示例: **

   **main.go** 

   ``` go
   package main

   import (
   	"net/http"
   	
   	"github.com/labstack/echo"
   )

   func main() {
   	e := echo.New()
   	e.GET("/", func(c echo.Context) error {
   		return c.String(http.StatusOK, "Hello, World!")
   	})
   	e.Logger.Fatal(e.Start(":1323"))
   }

   ```

   启动： `go run server.go`

   Browse to [http://localhost:1323](http://localhost:1323/) and you should see Hello, World! on the page.

   更多echo 请参照学习官方教程：https://echo.labstack.com/guide
