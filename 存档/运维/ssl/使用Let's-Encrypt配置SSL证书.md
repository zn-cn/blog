##### 1. 安装 Certbot

*Let's Encrypt* 证书生成不需要手动进行，官方推荐 [certbot](https://certbot.eff.org/) 这套自动化工具来实现。

- Nginx on CentOS/RHEL 7

  Certbot is packaged in EPEL (Extra Packages for Enterprise Linux). To use Certbot, you must first [enable the EPEL repository](https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F). On RHEL or Oracle Linux, you must also enable the optional channel.

  > Note:
  >
  > If you are using RHEL on EC2, you can enable the optional channel by running: 
  >
  > ```shell
  > $ yum -y install yum-utils
  > $ yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
  > ```

  After doing this, you can install Certbot by running:

  ```shell
  $ sudo yum install certbot-nginx
  ```

- Nginx on Ubuntu 16.04 (xenial)

  On Ubuntu systems, the Certbot team maintains a PPA. Once you add it to your list of repositories all you'll need to do is apt-get the following packages.

  ```shell
  $ sudo apt-get update

  $ sudo apt-get install software-properties-common

  $ sudo add-apt-repository ppa:certbot/certbot

  $ sudo apt-get update

  $ sudo apt-get install python-certbot-nginx 
  ```

  Certbot's DNS plugins which can be used to automate obtaining a wildcard certificate from Let's Encrypt's ACMEv2 server are not available for your OS yet. This should change soon but if you don't want to wait, you can use these plugins now by running Certbot in Docker instead of using the instructions on this page. 

##### 2. 生成SSL证书

- 编辑配置文件：

  ```shell
  $ sudo vim /etc/letsencrypt/configs/hostname
  ```

  ```
  # 写你的域名和邮箱
  domains = hostname
  rsa-key-size = 2048
  email = your-email
  text = True

  # 把下面的路径修改为 hostname 的目录位置
  authenticator = webroot
  webroot-path = /mnt/var/www/<your-name>/<hostname>
  ```

  只需将 hostname 修改为你的域名即可，certbot 会自动在 `/mnt/var/www/<your-name>/<hostname>` 下面创建一个隐藏文件 `.well-known/acme-challenge` ，通过请求这个文件来验证 `hostname` 确实属于你。外网服务器访问 `http://hostname/.well-known/acme-challenge` ，如果访问成功则验证OK。

- 配置Nginx 进行 webroot 验证

  eg: 在`/etc/nginx/sites-available` 目录下 编辑 temp 文件

  ```nginx
  server {
     listen 80;
     server_name hostname;
   
     location ~ /.well-known {
         root /mnt/var/www/<your-name>/<hostname>;
         default_type "text/plain";
     }
  }
  ```

  设置软连接：

  ```shell
  $ cd /etc/nginx/sites-enabled     # 必须!!!
  $ sudo ln -s ../sites-available/temp temp
  $ sudo openresty -s reload        
  ```

- 生成SSL证书

  ```shell
  $ sudo certbot -c /etc/letsencrypt/configs/hostname certonly

  ## 片刻之后，看到下面内容就是成功了
  IMPORTANT NOTES:
   - Congratulations! Your certificate and chain have been saved at /etc/letsencrypt/live/hostname/fullchain.pem.
  ```

  *之后删除 之前的 temp 软连接* 

##### 3. 部署 https 反向代理

- nginx 配置文件

  在`/etc/nginx/sites-available` 目录下 编辑 hostname 文件

    模板如下：

  ```nginx
    upstream monitor_server {
        server <server-host>:<port>; 
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
          ...
        }

        access_log /mnt/log/nginx/hostname/access.log;
        error_log /mnt/log/nginx/hostname/error.log;
    }
  ```

  > 注:
  >
  > ​      如需支持HTTP2，可将http server第一行修改为 listen 443 ssl http2; 作用是启用 Nginx 的 ngx_http_v2_module 模块支持 HTTP2，Nginx 版本需要高于 1.9.5，且编译时需要设置 --with-http_v2_module。
  >
  > ssl_certificate 和 ssl_certificate_key ，分别对应 fullchain.pem 和 privkey.pem，这2个文件是之前就生成好的证书和密钥。
  >
  > ssl_dhparam 通过下面命令生成：
  >
  > ```shell
  > $ sudo openssl dhparam -out /etc/letsencrypt/ssl-dhparams.pem 2048
  > ```
  >
  > 之后
  >
  > ```shell
  > $ cd /etc/nginx/sites-enabled     # 必须!!!
  > $ sudo ln -s ../sites-available/hostname hostname 
  > $ sudo openresty -s reload
  > ```

##### 4. 设置SSL证书自动更新 

```shell
$ sudo vim /etc/systemd/system/letsencrypt.service
```

```
[Unit]
Description=Let's Encrypt renewal

[Service]
Type=oneshot
ExecStart=/usr/bin/certbot renew --quiet --agree-tos
ExecStartPost=/bin/systemctl reload nginx.service
```

然后增加一个 systemd timer 来触发这个服务：

```shell
$ sudo vim /etc/systemd/system/letsencrypt.timer
```

```
[Unit]
Description=Monthly renewal of Let's Encrypt's certificates

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

启用服务，开启 timer：

```
$ sudo systemctl enable letsencrypt.timer
$ sudo systemctl start letsencrypt.timer
```

上面两条命令执行完毕后，你可以通过 `systemctl list-timers` 列出所有 systemd 定时服务。当中可以找到 `letsencrypt.timer` 并看到运行时间是明天的凌晨12点。

##### 5. 在线工具测试SSL 安全性

[Qualys SSL Labs](https://www.ssllabs.com/ssltest/index.html) 提供了全面的 SSL 安全性测试，填写你的网站域名，给自己的 HTTPS 配置打个分。

