测试环境：Ubuntu 16.04 LTS    Linux 4.16.0-999-generic 

shell版本: bash

### 一、docker 排坑

##### 1. network问题

docker-compose 会默认在docker-compose up执行的时候为compose文件里面的所有容器创建bridge network链接，所以如果在单机上操作docker无需自定义网络或者使用links

- 使用links 来连接容器的话，举例如下：

  ```
  links:
  	- mongo:mongo    # 后一个mongo是别名或者理解为hostname
  ```

  然后在代码中连接mongo的话将localhost修改为mongo即可

- 使用默认的桥接网络

  例如：docker-compose.yml如下

  ```
  version: '3'

  services:
      learn_docker:
      	...
          container_name: learn_docker_app
          ...
      mongo:
          ...
          container_name: learn_docker_mongo
          ...
  ```

  则直接使用mongo代替localhost即可

```shell
docker network ls    # list network
docker inspect [NETWORK ID]  # 查看network情况
docker network rm [NETWORK ID]  # 删除
docker network create -d bridge my-bridge-network
docker network connect [NETWORK ID | NETWORK NAME] [CONTAINER NAME | CONTAINER ID] # 将容器加入network中
docker network disconnect 。。。。。
```

更多请查看 官方文档 https://docs.docker.com/engine/reference/commandline/network_create/#extended-description 

##### 2. alpine

python的alpine版本中不包含C Compile，而安装uwsgi的时候需要用到gcc，所以需要手动安装gcc，然而安装网上流行的教程发现，gcc每次都安装出错

解决方案：使用Python:3.6而不是Python3.6-alpine版本（精简版），Python:3.6中自带了C Compile

##### 3. WORKDIR

官方说WORKDIR适用于 CMD、RUN、COPY、ADD、ENTRYPOINT等命令，但是发现其实有时候还是不行的，所以尽量用绝对路径，CMD、ENTRYPOINT可以用相对路径


### 二、Docker CE安装

+ 卸载旧版本

  ```shell
  $ sudo apt-get remove docker docker-engine docker.io
  ```

+ 添加使用 HTTPS 传输的软件包以及 CA 证书

  ```shell
  $ sudo apt-get update

  $ sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
  ```

+ 添加软件源的 `GPG` 密钥

  ```shell
  # 国内源
  $ curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

  # 官方源
  # $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  ```

+ 向 `source.list` 中添加 Docker 软件源

  ```shell
  # 国内源
  $ sudo add-apt-repository \
      "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
      
  # 官方源
  # $ sudo add-apt-repository \
  # "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  # $(lsb_release -cs) \
  # stable"
  ```


+ 安装 Docker CE

  ```shell
  $ sudo apt-get update

  $ sudo apt-get install docker-ce
  ```

+ 安装docker-compose

  pip安装:  `sudo pip install -U docker-compose` 
### 三、准备工作

##### 1. 建立用户组

```shell
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
```

##### 2. 测试

```shell
$ docker run hello-world

Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
ca4f61b1923c: Pull complete
Digest: sha256:be0cd392e45be79ffeffa6b05338b98ebb16c87b255f48e297ec7f98e123905c
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
```

正常输出以上信息，安装成功

##### 3. 镜像加速

对于使用 [systemd](https://www.freedesktop.org/wiki/Software/systemd/) 的系统，请在 `/etc/docker/daemon.json` 中写入如下内容（如果文件不存在请新建该文件）

```json
{
  "registry-mirrors": [
    "https://registry.docker-cn.com"
  ]
}
```

之后重新启动服务。

##### 4. 注册 Docker Hub

+ 注册

  你可以在 [https://cloud.docker.com](https://cloud.docker.com/) 免费注册一个 Docker 账号。

+ 登录、退出

  ```shell
  $ docker login
  $ docker logout
  ```

+ 拉取、推送

  ```shell
  $ docker pull [OPTIONS] HOSTNAME:PORT/USERNAME/IMAGE_NAME[:TAG|@DIGEST]
  $ docker push [OPTIONS] HOSTNAME:PORT/USERNAME/IMAGE_NAME[:TAG|@DIGEST]
  ```

  *默认HOSTNAME为Docker Hub, USERNME默认为library, TAG默认为latest*

  eg:

  ```shell
  $ docker pull python:3.6
  $ docker pull openresty/openresty
  $ docker pull docker.hostname.com/username/hello:v1
  ```

### 四、Dockerfile

常用镜像制作：

build 命令：`docker build -t python3.6_uwsgi_flask:v1 .`

进入容器：`docker exec -it [container id] bash` （这样就能进入 进入之后使用bash操作）

##### python3.6_uwsgi_flask

```dockerfile
FROM python:3.6
MAINTAINER Zhao Nan <yun_tofar@qq.com>

COPY requirements.txt /app/requirements.txt
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt
```

requirements.txt

```
pymongo==3.6.1
PyMySQL==0.8.0
Flask==0.12.2
PyJWT==1.3.0
requests==2.9.1
bcrypt==3.1.4
redis==2.10.6
Werkzeug==0.14.1
uWSGI==2.0.15
Flask-Mail
```

**!!!: 千万别用 python:3.6-alpine版本，虽然这个版本精简，但是没有C compile，导致安装uwsgi不成功，后来在python:3.6-alpine基础上安装gcc，也不一定能成功，但是官方是推荐alpine版本的**

### 五、docker-compose

启动命令：`docker-compose up`

```yaml
version: '3'

services:
    learn_docker:
        build: .
        volumes:
            - ./logs:/app/logs
            - /etc/localtime:/etc/localtime:ro
        ports:
            - "3031:3031"
        environment:
            - TZ=Asia/Shanghai
        container_name: learn_docker_app
        depends_on: 
            - mongo
        command: uwsgi --ini uwsgi/uwsgi.ini
    mongo:
        image: mongo:3.6.3
        expose:
            - "27017"
        environment:
            - TZ=Asia/Shanghai
        container_name: learn_docker_mongo
        volumes:
            - ./db:/data/db
            - /etc/localtime:/etc/localtime:ro
```

注：无需使用links 来在容器之间建立通道，docker-compose会自动创建一个bridge network包含docker-compose中创建的容器

**！！！：代码中直接使用mongo代替localhost即可** , expose: 27017使mongo只对docker内暴露

> 桥接网络自主创建连接方式：
>
> ```shell
> $ docker network create learn_docker-net
>
> $ docker-compose up
>
> $ docker network connect learn_docker-net learn_docker_app
>
> $ docker network connect learn_docker-net learn_docker_mongo
>
> ```

### 六、docker最佳实践

主要来源：https://github.com/kxxoling/blog/blob/master/sa/docker-best-practice.md

##### RUN

处于易读性的考虑，过长或者复杂的命令应该使用 `\` 分割成多行，一个Dockerfile中的RUN应该尽量少，减少层数

##### CMD

CMD 命令只应该运行镜像所对应的命令。虽然允许 `CMD executable param1 param2` 的写法， 但是 `CMD ["executable", "param1", "param2"…]` 更不容易出错。

示例：

```
CMD ["apache2","-DFOREGROUND"]
CMD ["perl", "-de0"]
```

如果你熟悉 ENTRYPOINT 的话，推荐组合使用。

##### EXPOSE

端口映射应该尽可能地使用默认端口。

##### ADD COPY

ADD 和 COPY 的功能类似，不过 COPY 命令的功能更加直观一些，因此推荐使用。

相比之下，ADD 支持添加远程资源，并且会自动 tar 打包或者解包。不过下载远程文件更推荐使用 `RUN wget` 或者 `curl`。

##### ENTRYPOINT

ENTRYPOINT 应该用于 镜像的主命令，并使用 CMD 作为默认设置，以 s3cmd 为例：

```
ENTRYPOINT ["s3cmd"]
CMD ["--help"]
```

获取帮助：`docker run s3cmd`

执行命令：`docker run s3cmd ls s3://mybucket`

这在镜像名与程序重名时非常有用。

ENTRYPOINT 也可以用于启动脚本：

```
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
```

这段脚本为用户提供了多种和 Postgres 交互的途径：

你可以简单地启动 Postgres： `docker run postgres`。

或者运行 `postgres` 并传入参数：`docker run postgres postgres --help`。

你甚至可以从镜像中启动一个完全不同的程序，比如 Bash：`docker run --rm -it postgres bash`

##### VOLUME

VOLUME 通常用作数据卷，对于任何可变的文件，包括数据库文件、代码库、配置文件……都应该使用 VOLUME 挂载。

### 七、docker 常用命令列表

批量删除:

使用 Docker 会遗留一大堆镜像，删除镜像又需要先把已经停止的容器删除，下面我们想办法批量干掉他们

```
# 删除已经Exited的容器
$ docker ps -a | grep 'Exited' | awk '{print $1}' | xargs docker stop | xargs docker rm
# 删除none的镜像
$ docker images | grep '<none>' | awk '{print $3}' | xargs docker rmi
```



`docker pull [name]`获取镜像

`docker images` 显示Docker镜像列表

`docker inspect [镜像ID]`获取镜像的详细信息

`docker search [关键词]`查找关键词镜像列表

`docker ps -a` 查看Docker后台进程

`docker rmi [镜像标签/镜像ID]`删除镜像

`docker cp [file] [容器ID]:/etc/`复制文件到容器指定位置

`docker rm [容器ID]`删除容器

`docker commit -m "description..." -a "author" [容器ID] [New id]`基于已有容器创建新的镜像

`docker run -it ubuntu /bin/bash`使用镜像创建一个容器，并在其中运行bash应用（-t 分配一个伪终端，-i 让容器标准输入保持打开）

`docker create -it [镜像]`新建一个容器

`docker start [容器ID]`运行处于终止状态的容器

`docker run -d ubuntu [命令]`后台运行容器

`docker logs [容器ID]`查看容器输出信息

`docker stop [-t|--time[=10]] [容器ID]`终止容器，默认等待10s

`docker kill [容器ID]`直接强制终止容器

`docker ps -a -q`查看处于终止状态的容器

`docker restart [容器ID]`重启一个容器

`docker exec -ti [容器ID] /bin/bash`进入到创建容器中运行交互命令

`docker save -o name.tar ubuntu:14.04`存出镜像到本地为name.tar

`docker load --input name.tar`导入镜像存储文件到本地镜像库

`docker export [容器ID] > name.tar`导出停止或运行中的容器到文件中去

`cat name.tar | sudo docker import - test/ubuntu:v1.0`导入容器导出的文件成为镜像

