---
title: nginx配置简介
date: 2018-5-5 14:59:25
tags: 
	- config
	- nginx
	- openresty
categories: 
	- 其他
---

## location 匹配规则

#### 语法规则

> location [=|~|~*|^~] /uri/ { … }

| 模式                                    | 含义                                                         |
| --------------------------------------- | ------------------------------------------------------------ |
| location = /uri                         | = 表示精确匹配，只有完全匹配上才能生效                       |
| location ^~ /uri                        | ^~ 开头对URL路径进行前缀匹配，并且在正则之前。               |
| location ~ \\.(gif\|jpg\|png\|js\|css)$ | 对URL路径进行后缀匹配，并且在正则之前。                      |
| location ~ pattern                      | 开头表示区分大小写的正则匹配                                 |
| location ~* pattern                     | 开头表示不区分大小写的正则匹配                               |
| location /uri                           | 不带任何修饰符，也表示前缀匹配，但是在正则匹配之后           |
| location /                              | 通用匹配，任何未匹配到其它location的请求都会匹配到，相当于switch中的default |

前缀匹配时，Nginx 不对 url 做编码，因此请求为 `/static/20%/aa`，可以被规则 `^~ /static/ /aa` 匹配到（注意是空格）

多个 location 配置的情况下匹配顺序为（参考资料而来，还未实际验证，试试就知道了，不必拘泥，仅供参考）:

- 首先精确匹配 `=`
- 其次前缀匹配 `^~`
- 其次是按文件中顺序的正则匹配
- 然后匹配不带任何修饰的前缀匹配。
- 最后是交给 `/` 通用匹配
- 当有匹配成功时候，停止匹配，按当前匹配规则处理请求

*注意：前缀匹配，如果有包含关系时，按最大匹配原则进行匹配。比如在前缀匹配：location /dir01 与 location /dir01/dir02，如有请求 http://localhost/dir01/dir02/file 将最终匹配到 location /dir01/dir02*

例子，有如下匹配规则：

```
location = / {
   echo "规则A";
}
location = /login {
   echo "规则B";
}
location ^~ /static/ {
   echo "规则C";
}
location ^~ /static/files {
    echo "规则X";
}
location ~ \.(gif|jpg|png|js|css)$ {
   echo "规则D";
}
location ~* \.png$ {
   echo "规则E";
}
location /img {
    echo "规则Y";
}
location / {
   echo "规则F";
}

```

那么产生的效果如下：

- 访问根目录 `/`，比如 `http://localhost/` 将匹配 `规则A`
- 访问 `http://localhost/login` 将匹配 `规则B`，`http://localhost/register` 则匹配 `规则F`
- 访问 `http://localhost/static/a.html` 将匹配 `规则C`
- 访问 `http://localhost/static/files/a.exe` 将匹配 `规则X`，虽然 `规则C`也能匹配到，但因为最大匹配原则，最终选中了 `规则X`。你可以测试下，去掉规则 X ，则当前 URL 会匹配上 `规则C`。
- 访问 `http://localhost/a.gif`, `http://localhost/b.jpg` 将匹配 `规则D`和 `规则 E` ，但是 `规则 D` 顺序优先，`规则 E` 不起作用，而 `http://localhost/static/c.png` 则优先匹配到 `规则 C`
- 访问 `http://localhost/a.PNG` 则匹配 `规则 E` ，而不会匹配 `规则 D` ，因为 `规则 E` 不区分大小写。
- 访问 `http://localhost/img/a.gif` 会匹配上 `规则D`,虽然 `规则Y` 也可以匹配上，但是因为正则匹配优先，而忽略了 `规则Y`。
- 访问 `http://localhost/img/a.tiff` 会匹配上 `规则Y`。

访问 `http://localhost/category/id/1111` 则最终匹配到规则 F ，因为以上规则都不匹配，这个时候应该是 Nginx 转发请求给后端应用服务器，比如 FastCGI（php），tomcat（jsp），Nginx 作为反向代理服务器存在。

所以实际使用中，笔者觉得至少有三个匹配规则定义，如下：

```
# 直接匹配网站根，通过域名访问网站首页比较频繁，使用这个会加速处理，官网如是说。
# 这里是直接转发给后端应用服务器了，也可以是一个静态首页
# 第一个必选规则
location = / {
    proxy_pass http://tomcat:8080/index
}

# 第二个必选规则是处理静态文件请求，这是 nginx 作为 http 服务器的强项
# 有两种配置模式，目录匹配或后缀匹配，任选其一或搭配使用
location ^~ /static/ {
    root /webroot/static/;
}
location ~* \.(gif|jpg|jpeg|png|css|js|ico)$ {
    root /webroot/res/;
}

# 第三个规则就是通用规则，用来转发动态请求到后端应用服务器
# 非静态文件请求就默认是动态请求，自己根据实际把握
# 毕竟目前的一些框架的流行，带.php、.jsp后缀的情况很少了
location / {
    proxy_pass http://tomcat:8080/
}

```

#### rewrite 语法

- last – 基本上都用这个 Flag
- break – 中止 Rewirte，不再继续匹配
- redirect – 返回临时重定向的 HTTP 状态 302
- permanent – 返回永久重定向的 HTTP 状态 301

1、下面是可以用来判断的表达式：

```
-f 和 !-f 用来判断是否存在文件
-d 和 !-d 用来判断是否存在目录
-e 和 !-e 用来判断是否存在文件或目录
-x 和 !-x 用来判断文件是否可执行

```

2、下面是可以用作判断的全局变量

```
例：http://localhost:88/test1/test2/test.php?k=v
$host：localhost
$server_port：88
$request_uri：/test1/test2/test.php?k=v
$document_uri：/test1/test2/test.php
$document_root：D:\nginx/html
$request_filename：D:\nginx/html/test1/test2/test.php

```

#### redirect 语法

```
server {
    listen 80;
    server_name start.igrow.cn;
    index index.html index.php;
    root html;
    if ($http_host !~ "^star\.igrow\.cn$") {
        rewrite ^(.*) http://star.igrow.cn$1 redirect;
    }
}

```

#### 防盗链

```
location ~* \.(gif|jpg|swf)$ {
    valid_referers none blocked start.igrow.cn sta.igrow.cn;
    if ($invalid_referer) {
       rewrite ^/ http://$host/logo.png;
    }
}

```

#### 根据文件类型设置过期时间

```
location ~* \.(js|css|jpg|jpeg|gif|png|swf)$ {
    if (-f $request_filename) {
        expires 1h;
        break;
    }
}

```

#### 禁止访问某个目录

```
location ~* \.(txt|doc)${
    root /data/www/wwwroot/linuxtone/test;
    deny all;
}

```

一些可用的全局变量，可以参考[获取 Nginx 内置绑定变量](https://moonbingbing.gitbooks.io/openresty-best-practices/content/openresty/inline_var.html)章节。

## nginx 内置绑定变量

部分常用变量如下：

| 名称                  | 说明                                                         |
| --------------------- | ------------------------------------------------------------ |
| $arg_name             | 请求中的name参数                                             |
| $args                 | 请求中的参数                                                 |
| $binary_remote_addr   | 远程地址的二进制表示                                         |
| $body_bytes_sent      | 已发送的消息体字节数                                         |
| $content_length       | HTTP请求信息里的"Content-Length"                             |
| $content_type         | 请求信息里的"Content-Type"                                   |
| $document_root        | 针对当前请求的根路径设置值                                   |
| $document_uri         | 与$uri相同; 比如 /test2/test.php                             |
| $host                 | 请求信息中的"Host"，如果请求中没有Host行，则等于设置的服务器名 |
| $hostname             | 机器名使用 gethostname系统调用的值                           |
| $http_cookie          | cookie 信息                                                  |
| $http_referer         | 引用地址                                                     |
| $http_user_agent      | 客户端代理信息                                               |
| $http_via             | 最后一个访问服务器的Ip地址。                                 |
| $http_x_forwarded_for | 相当于网络访问路径                                           |
| $is_args              | 如果请求行带有参数，返回“?”，否则返回空字符串                |
| $limit_rate           | 对连接速率的限制                                             |
| $nginx_version        | 当前运行的nginx版本号                                        |
| $pid                  | worker进程的PID                                              |
| $query_string         | 与$args相同                                                  |
| $realpath_root        | 按root指令或alias指令算出的当前请求的绝对路径。其中的符号链接都会解析成真是文件路径 |
| $remote_addr          | 客户端IP地址                                                 |
| $remote_port          | 客户端端口号                                                 |
| $remote_user          | 客户端用户名，认证用                                         |
| $request              | 用户请求                                                     |
| $request_body         | 这个变量（0.7.58+）包含请求的主要信息。在使用proxy_pass或fastcgi_pass指令的location中比较有意义 |
| $request_body_file    | 客户端请求主体信息的临时文件名                               |
| $request_completion   | 如果请求成功，设为"OK"；如果请求未完成或者不是一系列请求中最后一部分则设为空 |
| $request_filename     | 当前请求的文件路径名，比如/opt/nginx/www/test.php            |
| $request_method       | 请求的方法，比如"GET"、"POST"等                              |
| $request_uri          | 请求的URI，带参数                                            |
| $scheme               | 所用的协议，比如http或者是https                              |
| $server_addr          | 服务器地址，如果没有用listen指明服务器地址，使用这个变量将发起一次系统调用以取得地址(造成资源浪费) |
| $server_name          | 请求到达的服务器名                                           |
| $server_port          | 请求到达的服务器端口号                                       |
| $server_protocol      | 请求的协议版本，"HTTP/1.0"或"HTTP/1.1"                       |
| $uri                  | 请求的URI，可能和最初的值有不同，比如经过重定向之类的        |

## nginx.conf 配置详解

```nginx
#定义Nginx运行的用户和用户组
user www www;

#nginx进程数，建议设置为等于CPU总核心数。
worker_processes 8;

#全局错误日志定义类型，[ debug | info | notice | warn | error | crit ]
error_log /var/log/nginx/error.log info;

#进程文件
pid /var/run/nginx.pid;

#一个nginx进程打开的最多文件描述符数目，理论值应该是最多打开文件数（系统的值ulimit -n）与nginx进程数相除，但是nginx分配请求并不均匀，所以建议与ulimit -n的值保持一致。
worker_rlimit_nofile 65535;

#工作模式与连接数上限
events {
    #参考事件模型，use [ kqueue | rtsig | epoll | /dev/poll | select | poll ]; epoll模型是Linux 2.6以上版本内核中的高性能网络I/O模型，如果跑在FreeBSD上面，就用kqueue模型。
    use epoll;
    #单个进程最大连接数（最大连接数=连接数*进程数）
    worker_connections 65535;
}

#设定http服务器
http {
    include mime.types; #文件扩展名与文件类型映射表
    include /etc/nginx/sites-enabled/*; # 增加server配置文件夹
    default_type application/octet-stream; #默认文件类型
    #charset utf-8; #默认编码
    server_names_hash_bucket_size 128; #服务器名字的hash表大小
    client_header_buffer_size 32k; #上传文件大小限制
    large_client_header_buffers 4 64k; #设定请求缓
    client_max_body_size 8m; #设定请求缓
    #开启高效文件传输模式，sendfile指令指定nginx是否调用sendfile函数来输出文件，对于普通应用设为 on，
    #如果用来进行下载等应用磁盘IO重负载应用，可设置为off，以平衡磁盘与网络I/O处理速度，降低系统的负载。注意：如果图片显示不正常把这个改成off。
    sendfile on; 
    #开启目录列表访问，合适下载服务器，默认关闭。
    autoindex on; 
    tcp_nopush on; #防止网络阻塞
    tcp_nodelay on; #防止网络阻塞
    keepalive_timeout 120; #长连接超时时间，单位是秒

    #FastCGI相关参数是为了改善网站的性能：减少资源占用，提高访问速度。下面参数看字面意思都能理解。
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;

    #gzip模块设置
    gzip on; #开启gzip压缩输出
    gzip_min_length 1k; #最小压缩文件大小
    gzip_buffers 4 16k; #压缩缓冲区
    gzip_http_version 1.0; #压缩版本（默认1.1，前端如果是squid2.5请使用1.0）
    gzip_comp_level 2; #压缩等级
    gzip_types text/plain application/x-javascript text/css application/xml;    
    #压缩类型，默认就已经包含text/html，所以下面就不用再写了，写上去也不会有问题，但是会有一个warn。
    gzip_vary on;
    #limit_zone crawler $binary_remote_addr 10m; #开启限制IP连接数的时候需要使用

    upstream blog.ha97.com {
        #upstream的负载均衡，weight是权重，可以根据机器配置定义权重。weigth参数表示权值，权值越高被分配到的几率越大。
        server 192.168.80.121:80 weight=3;  
        server 192.168.80.122:80 weight=2;
        server 192.168.80.123:80 weight=3;
    }

    #虚拟主机的配置
    server {
        #监听端口
        listen 80;  
        #域名可以有多个，用空格隔开
        server_name www.ha97.com ha97.com;
        index index.html index.htm index.php;
        root /data/www/ha97;
        location ~ .*\.(php|php5)?$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi.conf;   
        }
        #图片缓存时间设置
        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$ {
            expires 10d;
        }
        #JS和CSS缓存时间设置        
        location ~ .*\.(js|css)?$ {
            expires 1h;
        }
        #日志格式设定
        log_format access '$remote_addr - $remote_user [$time_local] "$request" ' '$status $body_bytes_sent "$http_referer" ' '"$http_user_agent" $http_x_forwarded_for';
        #定义本虚拟主机的访问日志
        access_log /var/log/nginx/ha97access.log access;

        #对 "/" 启用反向代理
        location / {
            proxy_pass http://127.0.0.1:88;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            #后端的Web服务器可以通过X-Forwarded-For获取用户真实IP
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            #以下是一些反向代理的配置，可选。
            proxy_set_header Host $host;
            client_max_body_size 10m; #允许客户端请求的最大单文件字节数
            client_body_buffer_size 128k; #缓冲区代理缓冲用户端请求的最大字节数，
            proxy_connect_timeout 90; #nginx跟后端服务器连接超时时间(代理连接超时)
            proxy_send_timeout 90; #后端服务器数据回传时间(代理发送超时)
            proxy_read_timeout 90; #连接成功后，后端服务器响应时间(代理接收超时)
            proxy_buffer_size 4k; #设置代理服务器（nginx）保存用户头信息的缓冲区大小
            proxy_buffers 4 32k; #proxy_buffers缓冲区，网页平均在32k以下的设置
            proxy_busy_buffers_size 64k; #高负荷下缓冲大小（proxy_buffers*2）
            proxy_temp_file_write_size 64k;
            #设定缓存文件夹大小，大于这个值，将从upstream服务器传
        }

        #设定查看Nginx状态的地址
        location /NginxStatus {
            stub_status on;
            access_log on;
            auth_basic "NginxStatus";
            auth_basic_user_file conf/htpasswd;
            #htpasswd文件的内容可以用apache提供的htpasswd工具来产生。
        }

        #本地动静分离反向代理配置
        #所有jsp的页面均交由tomcat或resin处理
        location ~ .(jsp|jspx|do)?$ {
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://127.0.0.1:8080;
        }
        #所有静态文件由nginx直接读取不经过tomcat或resin
        location ~ .*.(htm|html|gif|jpg|jpeg|png|bmp|swf|ioc|rar|zip|txt|flv|mid|doc|ppt|pdf|xls|mp3|wma)$ { 
            expires 15d; 
        }
        location ~ .*.(js|css)?$ { 
            expires 1h; 
        } 
    }
}
```

## 示例

nginx.conf

```
worker_processes  2;
events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    include /etc/nginx/sites-enabled/*;
}
```

/etc/nginx/sites-available/hostname

```nginx
# 负载均衡
upstream balance {
    ip_hash;
    server <server1>:<port>;
    server <server2>:<port>  down;
    server <server3>:<port>  max_fails=3  fail_timeout=20s;
    server <server4>:<port>;
}

server {
    listen 80;
    server_name hostname;

    # redirect all http to https
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name hostname;

    ssl_certificate /etc/letsencrypt/live/hostname/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/hostname/privkey.pem;
    # disable SSLv2
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

    # ciphers' order matters
    ssl_ciphers "ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!aNULL";

    # the Elliptic curve key used for the ECDHE cipher.
    ssl_ecdh_curve secp384r1;

    # use command line
    # openssl dhparam -out dhparam.pem 2048
    # to generate Diffie Hellman Ephemeral Parameters
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
    # let the server choose the cipher
    ssl_prefer_server_ciphers on;

    # turn on the OCSP Stapling and verify
    ssl_stapling on;
    ssl_stapling_verify on;

    # http compression method is not secure in https
    # opens you up to vulnerabilities like BREACH, CRIME
    gzip off;
    
    location /<request_uri> {
        proxy_pass  http://balance;
    }

	# letencrypt http
    location ^~ /.well-known/acme-challenge/ {
        default_type "text/plain";
        root /mnt/var/www/<your name>/hostname;
    }

    # ip访问限制
    location ~ /service/resources/JsApiTicket|AccessToken {
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://127.0.0.1:<port>;
        proxy_set_header X-Forwarded-Proto $scheme;
        allow <ip1>;
        allow <ip2>;
        allow <ip3>;
        allow <ip4>;
        allow <ip5>;                
        deny all;

    }

    location ~ /<request_uri> {
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://127.0.0.1:<port>;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location ~ /<request_uri> {
       include uwsgi_params;
       # 二者选其一即可 
       # uwsgi_pass unix://var/www/whb/webhook/uwsgi/uwsgi.sock;
       uwsgi_pass http:127.0.0.1:<port>
   }

    location ~ /url1/(.*)? {
        proxy_set_header Host <another hostname>;
        proxy_pass http://<remote_addr>:<port>/$1$is_args$args;
        proxy_set_header X-Real-IP $remote_addr;
    }
    location ~ /url2/(.*)? {
        proxy_set_header Host <another hostname>;
        proxy_pass https://<remote_addr>/$1$is_args$args; # 默认443端口
        proxy_set_header X-Real-IP $remote_addr;
    }
    location ~ /url2/(.*)? {
        proxy_set_header Host <another hostname>;
        proxy_pass http://<remote_addr>/$1$is_args$args;  # 默认80端口
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    #处理静态文件请求
	location ^~ /static/ {
    	root /webroot/static/;
	}
	location ~* \.(gif|jpg|jpeg|png|css|js|ico)$ {
    	root /webroot/res/;
	}


    access_log /mnt/log/nginx/hostname/access.log;
    error_log /mnt/log/nginx/hostname/error.log;
}
```


