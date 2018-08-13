> 更多方式请查看: [letsencrypt/client-options](https://letsencrypt.org/docs/client-options/)
>
> [acme.sh 官方 wiki 说明](https://github.com/Neilpang/acme.sh/wiki/%E8%AF%B4%E6%98%8E)

# 1. 安装 **acme.sh**

安装：

```
curl  https://get.acme.sh | sh
```

注：将会安装到 **~/.acme.sh/** 目录下，以后所有的配置默认也在这个目录下

设置 alias:

```
alias acme.sh=~/.acme.sh/acme.sh  # .bashrc or .zshrc or .config/fish/fish.
```

2). 自动为你创建 cronjob, 每天 0:00 点自动检测所有的证书, 如果快过期了, 需要更新, 则会自动更新证书.

更高级的安装选项请参考: https://github.com/Neilpang/acme.sh/wiki/How-to-install

# 2. 生成证书

**acme.sh** 实现了 **acme** 协议支持的所有验证协议. 一般有两种方式验证: http 和 dns 验证，这里仅介绍 DNS 方式

### 1. 方式一：使用 token

`acme.sh` 支持直接使用主流 DNS 提供商的 API 接口来完成域名验证以及一些相关操作

具体 [dnsapi 链接](https://github.com/Neilpang/acme.sh/tree/master/dnsapi)

这里以 阿里云 为例：

首先获取你的阿里云API Key: <https://ak-console.aliyun.com/#/accesskey>

之后在你的终端配置文件中设置：

```
export Ali_Key="sdfsdfsdfljlbjkljlkjsdfoiwje"
export Ali_Secret="jlsdflanljkljlfdsaklkjflsa"
```

之后直接使用如下命令发起申请：

```
acme.sh --issue --dns dns_ali -d example.com -d *.example.com 
```

 `Ali_Key` 和 `Ali_Secret` 将被保存在 `~/.acme.sh/account.conf` , 命令中 **dns_ali** 指明使用 阿里的dns

来生成证书，注意这里第一个域名为顶级域名，后面个为泛域名。

> 这种方式将自动为你的域名添加一条 `txt` 解析，验证成功后，这条解析记录会被删除，所以对你来说是无感的，就是要等 `120秒`。

证书生成成功后，默认保存在 `.acme.sh/hostname` 中。

> 若想自定义证书目录，可加上 -w 参数
>
> ```
> acme.sh --issue --dns dns_ali -d *.example.com -w /etc/letsencrypt/*.example.com
> ```

### 2. 方式二：添加一条 txt 解析记录

命令：

```
acme.sh  --issue  --dns -d example.com -d *.example.com
```

> 需要同时添加裸域名及泛域名。注意要将非泛域名的域名放在前面，否则可能会遇到一些问题。

然后, **acme.sh** 会生成相应的解析记录显示出来, 示例如下:

```
Multi domain='DNS:bitcat.cc,DNS:*.example.com'
Getting domain auth token for each domain
Getting webroot for domain='example.com'
Getting webroot for domain='*.example.com'
Add the following TXT record:
Domain: '_acme-challenge.example.com'
TXT value: '<ACME_CHALLENGE_STRING>'
Please be aware that you prepend _acme-challenge. before your domain
so the resulting subdomain will be: _acme-challenge.example.com
Please add the TXT records to the domains, and retry again.
Please add '--debug' or '--log' to check more details.
See: https://github.com/Neilpang/acme.sh/wiki/How-to-debug-acme.sh
```

记录下其中的 `<ACME_CHALLENGE_STRING>` 并前往你的 DNS 服务提供商，为主机名 `_acme-challenge` 添加一条 TXT 记录，内容即为上述的 `<ACME_CHALLENGE_STRING>`。提交后可以等待一小段时间以便让 DNS 生效。

重新申请签发证书:

```
acme.sh --renew --dns -d example.com -d *.example.comacme.sh
```

注意第二次这里用的是 `--renew`

# 3. 证书使用

这里仅用 nginx 服务器配置做示例：

nginx 配置文件重点介绍：

+ Nginx 的配置 `ssl_certificate`  和 `ssl_trusted_certificate` 使用 `fullchain.cer` ，而非 `<domain>.cer` ，否则 [SSL Labs](https://www.ssllabs.com/ssltest/) 的测试会报 `Chain issues Incomplete` 错误

+ `ssl_dhparam` 通过下面命令生成：

  ```
  sudo mkdir /etc/nginx/ssl
  sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
  ```

nginx.conf 配置示例：

```
server {
    listen 80;
    server_name mark.example.com;

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name mark.example.com;

    ssl_certificate /etc/letsencrypt/live/*.example.com/fullchain.cer;
    ssl_certificate_key /etc/letsencrypt/live/*.example.com/*.example.com.key;

    # disable SSLv2
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

    # ciphers' order matters
    ssl_ciphers "ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!aNULL";

    # the Elliptic curve key used for the ECDHE cipher.
    ssl_ecdh_curve secp384r1;

    # use command line
    # openssl dhparam -out dhparam.pem 2048
    # to generate Diffie Hellman Ephemeral Parameters
    ssl_dhparam /etc/nginx/ssl/dhparam.pem;

    # let the server choose the cipher
    ssl_prefer_server_ciphers on;

    # turn on the OCSP Stapling and verify
    ssl_stapling on;
    ssl_stapling_verify on;
    ssl_trusted_certificate /etc/letsencrypt/live/*.example.com/fullchain.cer;

    # http compression method is not secure in https
    # opens you up to vulnerabilities like BREACH, CRIME
    gzip off;

    location / {
        root /mnt/var/www/tofar/mark.example.com;
        index index.html;
    }

    error_log  /mnt/log/nginx/mark.example.com/error.log;
    access_log /mnt/log/nginx/mark.example.com/access.log;
}
```

之后重启 nginx 即可：

```
sudo nginx -s reload
or sudo openresty -s reload # 若安装的是openresty
```

# 4. 更新证书

目前证书在 60 天以后会自动更新, 你无需任何操作，不过都是自动的, 你不用关心.

# 5. 更新 acme.sh

目前由于 acme 协议和 letsencrypt CA 都在频繁的更新, 因此 acme.sh 也经常更新以保持同步.

升级 acme.sh 到最新版 :

```
acme.sh --upgrade
```

如果你不想手动升级, 可以开启自动升级:

```
acme.sh  --upgrade  --auto-upgrade
```

之后, acme.sh 就会自动保持更新了.

你也可以随时关闭自动更新:

```
acme.sh --upgrade  --auto-upgrade  0
```

更高级的用法请参看 [wiki 页面](https://github.com/Neilpang/acme.sh/wiki)
