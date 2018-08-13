nginx的两个很重要的优势就是反向代理和负载均衡

### 前言：

本文nginx采用目录模板如下：

+ nginx 配置文件

  将你的服务的 Nginx 配置文件目录：*/etc/nginx/sites-available/*

  目录下，然后通过软连接链到 */etc/nginx/sites-enabled/* 

+ SSL 证书

  使用 letsencrypt 签发的证书，目录位置：*/etc/letsencrypt/* 

  ssl_dhparam 目录位置：*/etc/letsencrypt/* 

  若为其他机构签发的证书可在*/etc* 下新建一个文件夹存放

+ 静态文件部署

  ```
  /mnt/var/www/<your-name>/<your-project-name>/
  ```

+ 项目部署

  ```
  /var/www/<your-name>/<your-project-name>
  ```

+ Nginx日志

  ```
  /mnt/log/nginx/<your-project-name>/<env>/
  ```

#### 1. 基础知识

**反向代理**（Reverse Proxy）方式是指用代理服务器来接受 internet 上的连接请求，然后将请求转发给内部网络上的服务器，并将从服务器上得到的结果返回给 internet 上请求连接的客户端，此时代理服务器对外就表现为一个反向代理服务器。

举个例子，一个用户访问 <http://www.example.com/readme>，但是 www.example.com 上并不存在 readme 页面，它是偷偷从另外一台服务器上取回来，然后作为自己的内容返回给用户。但是用户并不知情这个过程。对用户来说，就像是直接从 www.example.com 获取 readme 页面一样。这里所提到的 www.example.com 这个域名对应的服务器就设置了反向代理功能。

反向代理服务器，对于客户端而言它就像是原始服务器，并且客户端不需要进行任何特别的设置。客户端向反向代理的命名空间(name-space)中的内容发送普通请求，接着反向代理将判断向何处(原始服务器)转交请求，并将获得的内容返回给客户端，就像这些内容原本就是它自己的一样。如下图所示：

![proxy](http://upload-images.jianshu.io/upload_images/7109326-12017b7845287f46?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 2. 实践

假如你有多台服务器（下文中分别用代号1， 2， 3， 4表示），那么你可以只暴露1号服务器，通过在1号服务器上架设反向代理，映射到2、3、4号服务器上，同时在2、3、4号服务器上设置防火墙让2、3、4号服务器只允许通过1号服务器访问

### 3. 配置

服务器的nginx.conf文件：

```nginx

#user  nobody;
worker_processes  2;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';
    #access_log  logs/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    #keepalive_timeout  0;
    keepalive_timeout  65;
    #gzip  on;

    include /etc/nginx/sites-enabled/*;
}
```



反向代理服务器的nginx配置文件模板：

```nginx
  upstream monitor_server {
      server <server1-host>:<port>; 
      server <server2-host>:<port>;   # 可通过nginx负载均衡 
      keepalive 2000;
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

      location ^~ /.well-known/acme-challenge/ {
          default_type "text/plain";
          root /mnt/var/www/<your-name>/hostname;
      }
    
      location / {
          proxy_redirect off;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_pass http://monitor_server;
          proxy_set_header X-Forwarded-Proto $scheme;
      }

      access_log /mnt/log/nginx/hostname/access.log;
      error_log /mnt/log/nginx/hostname/error.log;
  }
```

原始服务器配置模板：

```nginx
 server {
       listen <port>;
       server_name hostname;
       location / {
           root /var/www/<your-name>/<project name>;
           index index.html;
       }
   
       access_log /var/log/nginx/hostname/access.log;
       error_log /var/log/nginx/hostname/error.log;
   
  }
```

