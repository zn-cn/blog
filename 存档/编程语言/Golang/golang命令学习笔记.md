主要来源：[《Go Web编程》](https://astaxie.gitbooks.io/build-web-application-with-golang/zh/01.3.html)

### 1、go build

作用：compile packages and dependencies

注：在包的编译过程中，若有必要，会同时编译与之相关联的包。

示例：

+ 编译多个Go源码文件

  ```
  go build logging/base.go logging/console_logger.go
  ```

+ 编译包

  默认为当前文件夹的包

  ```
  go build logging        // 从GOPAT开始寻找
  ```


| 标记名称  | 标记描述                                     |
| ----- | ---------------------------------------- |
| -a    | 强行对所有涉及到的代码包（包含标准库中的代码包）进行重新构建，即使它们已经是最新的了。 |
| -n    | 打印编译期间所用到的其它命令，但是并不真正执行它们。               |
| -p n  | 指定编译过程中执行各任务的并行数量（确切地说应该是并发数量）。在默认情况下，该数量等于CPU的逻辑核数。但是在`darwin/arm`平台（即iPhone和iPad所用的平台）下，该数量默认是`1`。 |
| -race | 开启竞态条件的检测。不过此标记目前仅在`linux/amd64`、`freebsd/amd64`、`darwin/amd64`和`windows/amd64`平台下受到支持。 |
| -v    | 打印出那些被编译的代码包的名字。                         |
| -work | 打印出编译时生成的临时工作目录的路径，并在编译结束时保留它。在默认情况下，编译结束时会删除该目录。 |
| -x    | 打印编译期间所用到的其它命令。注意它与`-n`标记的区别。            |

参数的介绍

- `-o` 指定输出的文件名，可以带上路径，例如 `go build -o a/b/c`
- `-i` 安装相应的包，编译 +`go install`
- `-a` 更新全部已经是最新的包的，但是对标准包不适用
- `-n` 把需要执行的编译命令打印出来，但是不执行，这样就可以很容易的知道底层是如何运行的
- `-p n` 指定可以并行可运行的编译数目，默认是CPU数目
- `-race` 开启编译的时候自动检测数据竞争的情况，目前只支持64位的机器
- `-v` 打印出来我们正在编译的包名
- `-work` 打印出来编译时候的临时文件夹名称，并且如果已经存在的话就不要删除
- `-x` 打印出来执行的命令，其实就是和`-n`的结果类似，只是这个会执行
- -----------------------------------------------分割线---------------------------------------------------------
- `-ccflags 'arg list'` 传递参数给5c, 6c, 8c 调用
- `-compiler name` 指定相应的编译器，gccgo还是gc
- `-gccgoflags 'arg list'` 传递参数给gccgo编译连接调用
- `-gcflags 'arg list'` 传递参数给5g, 6g, 8g 调用
- `-installsuffix suffix` 为了和默认的安装包区别开来，采用这个前缀来重新安装那些依赖的包，`-race`的时候默认已经是`-installsuffix race`,大家可以通过`-n`命令来验证
- `-ldflags 'flag list'` 传递参数给5l, 6l, 8l 调用
- `-tags 'tag list'` 设置在编译的时候可以适配的那些tag，详细的tag限制参考里面的 [Build Constraints](http://golang.org/pkg/go/build/)

### 2、go clean

这个命令是用来移除当前源码包和关联源码包里面编译生成的文件。这些文件包括

```
_obj/            旧的object目录，由Makefiles遗留
_test/           旧的test目录，由Makefiles遗留
_testmain.go     旧的gotest文件，由Makefiles遗留
test.out         旧的test记录，由Makefiles遗留
build.out        旧的test记录，由Makefiles遗留
*.[568ao]        object文件，由Makefiles遗留

DIR(.exe)        由go build产生
DIR.test(.exe)   由go test -c产生
MAINFILE(.exe)   由go build MAINFILE.go产生
*.so             由 SWIG 产生

```

我一般都是利用这个命令清除编译文件，然后github递交源码，在本机测试的时候这些编译文件都是和系统相关的，但是对于源码管理来说没必要。

```
$ go clean -i -n
cd /Users/astaxie/develop/gopath/src/mathapp
rm -f mathapp mathapp.exe mathapp.test mathapp.test.exe app app.exe
rm -f /Users/astaxie/develop/gopath/bin/mathapp

```

参数介绍

- `-i` 清除关联的安装的包和可运行文件，也就是通过go install安装的文件
- `-n` 把需要执行的清除命令打印出来，但是不执行，这样就可以很容易的知道底层是如何运行的
- `-r` 循环的清除在import中引入的包
- `-x` 打印出来执行的详细命令，其实就是`-n`打印的执行版本

### 3、gofmt

gofmt -w -l src，可以格式化整个项目。

gofmt的参数介绍

- `-l` 显示那些需要格式化的文件
- `-w` 把改写后的内容直接写入到文件中，而不是作为结果打印到标准输出。
- `-r` 添加形如“a[b:len(a)] -> a[b:]”的重写规则，方便我们做批量替换
- `-s` 简化文件中的代码
- `-d` 显示格式化前后的diff而不是写入文件，默认是false
- `-e` 打印所有的语法错误到标准输出。如果不使用此标记，则只会打印不同行的前10个错误。
- `-cpuprofile` 支持调试模式，写入相应的cpufile到指定的文件

### 4、go get

这个命令是用来动态获取远程代码包的，目前支持的有BitBucket、GitHub、Google Code和Launchpad。这个命令在内部实际上分成了两步操作：第一步是下载源码包，第二步是执行`go install`。下载源码包的go工具会自动根据不同的域名调用不同的源码工具，对应关系如下：

```
BitBucket (Mercurial Git)
GitHub (Git)
Google Code Project Hosting (Git, Mercurial, Subversion)
Launchpad (Bazaar)

```

所以为了`go get` 能正常工作，你必须确保安装了合适的源码管理工具，并同时把这些命令加入你的PATH中。其实`go get`支持自定义域名的功能，具体参见`go help remote`。

参数介绍：

- `-d` 只下载不安装
- `-f` 只有在你包含了`-u`参数的时候才有效，不让`-u`去验证import中的每一个都已经获取了，这对于本地fork的包特别有用
- `-fix` 在获取源码之后先运行fix，然后再去做其他的事情
- `-t` 同时也下载需要为运行测试所需要的包
- `-u` 强制使用网络去更新包和它的依赖包
- `-v` 显示执行的命令

### 5、go install

这个命令在内部实际上分成了两步操作：第一步是生成结果文件(可执行文件或者.a包)，第二步会把编译好的结果移到`$GOPATH/pkg`或者`$GOPATH/bin`。

参数支持`go build`的编译参数。大家只要记住一个参数`-v`就好了，这个随时随地的可以查看底层的执行信息。

### 6、go test

遵循原则：

- 文件名必须以`_test.go`结尾
- 文件必须`import "testing"`这个 **testing** 包
- 所有的测试用例函数名必须以`Test`开头
- 测试函数格式：`func TestXxx (t *testing.T)`,`Xxx`部分可以为任意的字母数字的组合，但是首字母必须是大写字母[A-Z]，例如`Testintdiv`是错误的函数名。
- 函数中通过调用`testing.T`的`Error`, `Errorf`, `FailNow`, `Fatal`, `FatalIf`方法来表明测试未通过，调用`Log`方法用来记录测试的信息。

默认的情况下，不需要任何的参数，它会自动把你源码包下面所有test文件测试完毕，当然你也可以带上参数，详情请参考`go help testflag`

#### 常用参数：

- `-bench regexp` 执行相应的压力测试

  - 压力测试用例必须遵循如下格式，其中XXX可以是任意字母数字的组合，但是首字母不能是小写字母

    ```
      func BenchmarkXXX(b *testing.B) { ... }

    ```

  - `go test`不会默认执行压力测试的函数，如果要执行压力测试需要带上参数 `-bench`

  执行所有测试, 使用 `-bench .` or `-bench=.`

- `-cover` 开启测试覆盖率 

  如：

  ```go
  func Abs(a int) int {
      if a > 0 {
          return a
      } else {
          return a * (-1)
      }
  }
  ```

  ```go
  func TestAbs(t *testing.T) {
      if Abs(5) != 5 {
          t.Fatal("abs error, except:5, result:", Abs(5))
      }
  }
  ```

  这时go test -cover 会显示 `coverage: 50.0% of statements`

  从覆盖率来看，单元测试没有覆盖全部的代码，我们可以通过如下命令将cover的详细信息保存到cover.out中。

  ```
  go test -cover -coverprofile=cover.out -covermode=count
  注：
  -cover 允许代码分析
  -covermode 代码分析模式（set：是否执行；count：执行次数；atomic：次数，并发执行）
  -coverprofile 输出结果文件

  ```

  之后通过

  ```
  go tool cover -func=cover.out

  ```

  查看每个方法的覆盖率。
  运行结果：

  ```
  util/compute.go:7:      Sum            100.0%
  util/compute.go:15:     Abs            66.7%
  total:                  (statements)   85.7%

  ```

  这里发现是Abs方法没有覆盖完全，因为我们的用例只用到了正数的那个分支。
  还可以使用html的方式查看具体的覆盖情况。

  ```
  go tool cover -html=cover.out

  ```

  会默认打开浏览器，将覆盖情况显示到页面中：

  ![img](http://upload-images.jianshu.io/upload_images/7109326-c2ab593addee8746?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- `-run regexp` 只运行regexp匹配的函数，例如 `-run=Array` 那么就执行包含有Array开头的函数

- `-v` 显示测试的详细命令

#### Tips

1. 测试单个文件

   ` go test -v hello_test.go hello.go` 

   注意此处，如果要测试某一个文件，需要把测试文件与原文件都列出来

2. 测试一个函数

   `go test -run TestSum `

   此处可以使用正则匹配，例如 Sum 会匹配到所有包含Sum的函数

### 7、go tool

`go tool`下面下载聚集了很多命令，这里我们只介绍两个，fix和vet

- `go tool fix .` 用来修复以前老版本的代码到新版本，例如go1之前老版本的代码转化到go1,例如API的变化
- `go tool vet directory|files` 用来分析当前目录的代码是否都是正确的代码,例如是不是调用fmt.Printf里面的参数不正确，例如函数里面提前return了然后出现了无用代码之类的。

### 8、go generate

这个命令是从Go1.4开始才设计的，用于在编译前自动化生成某类代码。`go generate`和`go build`是完全不一样的命令，通过分析源码中特殊的注释，然后执行相应的命令。这些命令都是很明确的，没有任何的依赖在里面。而且大家在用这个之前心里面一定要有一个理念，这个`go generate`是给你用的，不是给使用你这个包的人用的，是方便你来生成一些代码的。

这里我们来举一个简单的例子，例如我们经常会使用`yacc`来生成代码，那么我们常用这样的命令：

```
go tool yacc -o gopher.go -p parser gopher.y

```

-o 指定了输出的文件名， -p指定了package的名称，这是一个单独的命令，如果我们想让`go generate`来触发这个命令，那么就可以在当然目录的任意一个`xxx.go`文件里面的任意位置增加一行如下的注释：

```
//go:generate go tool yacc -o gopher.go -p parser gopher.y

```

这里我们注意了，`//go:generate`是没有任何空格的，这其实就是一个固定的格式，在扫描源码文件的时候就是根据这个来判断的。

所以我们可以通过如下的命令来生成，编译，测试。如果`gopher.y`文件有修改，那么就重新执行`go generate`重新生成文件就好。

```
$ go generate
$ go build
$ go test

```

### 9、godoc

在Go1.2版本之前还支持`go doc`命令，但是之后全部移到了godoc这个命令下，需要这样安装`go get golang.org/x/tools/cmd/godoc`

很多人说go不需要任何的第三方文档，例如chm手册之类的（其实我已经做了一个了，[chm手册](https://github.com/astaxie/godoc)），因为它内部就有一个很强大的文档工具。

如何查看相应package的文档呢？ 例如builtin包，那么执行`godoc builtin` 如果是http包，那么执行`godoc net/http` 查看某一个包里面的函数，那么执行`godoc fmt Printf` 也可以查看相应的代码，执行`godoc -src fmt Printf`

通过命令在命令行执行 godoc -http=:端口号 比如`godoc -http=:8080`。然后在浏览器中打开`127.0.0.1:8080`，你将会看到一个golang.org的本地copy版本，通过它你可以查询pkg文档等其它内容。如果你设置了GOPATH，在pkg分类下，不但会列出标准包的文档，还会列出你本地`GOPATH`中所有项目的相关文档，这对于经常被墙的用户来说是一个不错的选择。

### 10、其它命令

go还提供了其它很多的工具，例如下面的这些工具

```
go version 查看go当前的版本
go env 查看当前go的环境变量
go list 列出当前全部安装的package
go run 编译并运行Go程序

```

以上这些工具还有很多参数没有一一介绍，用户可以使用`go help 命令`获取更详细的帮助信息。
