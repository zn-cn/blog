# Nginx 设置用户认证

> 需求出发点：
>
> 写后台的时候生成了一个可视化API文档，但是没有权限，什么人都能看，然后就想给这个可视化的API文档加个用户认证，但是前端能力不够，不知道咋把一个成型的网页之前嵌入一个登录。

### 步骤：

使用模块: **ngx_http_auth_basic_module**

+ 生成密码文件

  文件格式如下：

  ```
  username1:password1
  username2:password2:comment
  ```

  password 生成：

  使用 openssl 进行 crypt 加密

  ```
  openssl passwd -crypt 123456
  ```

  文件示例如下:

  ```
  mu-mo:xyJkVhXGAZ8tM
  ```

+ 配置nginx

  配置示例如下：

  ```nginx
      auth_basic "Login";
      auth_basic_user_file /etc/nginx/htpasswd; 

      location / {
          root /mnt/var/www/tofar/api.bingyan.net;
          index index.html;
      }

  ```

  若只需对某些路由设置登录，只需在相应的 location 下设置即可

+ 效果如下：
  ![image](http://upload-images.jianshu.io/upload_images/7109326-1074fe7c73dda865.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

