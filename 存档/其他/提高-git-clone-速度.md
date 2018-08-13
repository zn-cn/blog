### 一、问题提出

git clone 速度感人，通常只有 10kib/s ~ 30kib/s之间

### 二、解决方案

1. 在git内部设置代理

   前提：装有 shadowsocks 

   方式：

   - 命令行

     ```
     git config --global http.proxy socks5://127.0.0.1:1080
     git config --global https.proxy socks5://127.0.0.1:1080
     ```

   - 直接编辑

     输入 `gedit ~/.gitconfig` 之后，在文件中加入以下两行

     ```
     [http]
             proxy = socks5://127.0.0.1:1080
     [https]
             proxy = socks5://127.0.0.1:1080
     ```

2. 修改 hosts 文件直接映射

   输入 `sudo gedit /etc/hosts` 之后，在hosts文件中加入以下两行

   ```
   151.101.72.249	global-ssl.fastly.net
   192.30.253.112  github.com
   ```

**亲测有效，瞬间暴涨一二十倍**

> 另附 ss 终端设置代理方法, 直接在~/.bashrc中添加 
`export ALL_PROXY=socks5://127.0.0.1:1080` ，不要分成 http_proxy和http_proxy，会有问题
