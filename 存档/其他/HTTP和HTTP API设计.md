# HTTP 和 HTTP API 设计

## HTTP 基本知识

### URI

URL(统一资源定位符)，我们比较熟悉，URI是3个单词的缩写，Uniform Resource Identifier

URI用字符串表示某一互联网资源，而URL表示资源的地点，可见URL是URI的子集；采用HTTP协议时，协议方案就是http，除此之外，还有ftp、file等，标准的URI协议有30种方案左右。

```
                    hierarchical part
        ┌───────────────────┴──────────────────┐
                    authority               path
        ┌───────────────┴────────────┐┌───┴────┐
  abc://username:password@example.com:123/path/data?key=value&key2=value2#fragid1
  └┬┘  └───────┬───────┘└────┬────┘└┬┘           └─────────┬───────┘ └──┬──┘
scheme  user information     host     port                  query         fragment
```

eg:

![img](https://upload-images.jianshu.io/upload_images/2146831-499cae9ab386abe0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/681)

登录信息：指定用户名和密码作为从服务器端获取资源时必要的登录信息（身份认证），可选项。

查询字符串：针对已指定的文件路径内的资源，可以使用查询字符串传入任意参数，可选项。

片段标识符：使用片段标识符通常可标识出已获取资源中的子资源，可选项。

> URI 和 URL 的区别：
>
> URI 用字符串标识某一互联网资源，而 URL 标识资源的地址
>
> URL 是 URI 的子集

### 基本规定

+ 发送规则

  HTTP协议规定，请求从客户端发出，最后服务器端响应该请求并返回

+ HTTP无状态

  HTTP是一种不保存状态，即无状态协议，不会对之前发送过的请求进行信息的保存

### 常用HTTP方法

- GET（SELECT）：从服务器取出资源（一项或多项）
- POST（CREATE）：在服务器新建一个资源
- PUT（UPDATE）：在服务器更新资源（客户端提供改变后的完整资源）
- PATCH（UPDATE）：在服务器更新资源（客户端提供改变的属性）(一般使用PUT)
- DELETE（DELETE）：从服务器删除资源

### Cookie 状态管理

cookie会根据服务端发送的一个叫做Set-Cookie的首部字段信息，通知客服端保存Cookie，当下次客服端在往服务端发送请求的时候，客服端会自动在请求报文中加入Cookie然后发送过去，服务端接收到Cookie之后，对Cookie进行解析，然后找出是哪个用户。

**eg:**

一、请求报文（没有Cookie信息的状态）

```
GET /reader/HTTP/1.1
Host:host
// 首部字段没有cookie的相关信息
```

二、响应报文（服务器端生成Cookie信息）

```
HTTP/1.1 200 OK
Date:Thu ,12 JUl 2012 07:12:20 GMT
Server: Apache
<Set-Cookie:sid=1342077140;path=/;expires=wed>
Content-Type:text/plain;charset=UTF-8
```

三、请求报文（自动发送保存的Cookie信息）

```
GET /image/ HTTP/1.1
Host host
Cookie:sid=1342077140
```

### HTTP报文

结构：首部 + 主体

![img](https://upload-images.jianshu.io/upload_images/1724103-c43900117e983241.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/698)

![img](https://upload-images.jianshu.io/upload_images/1724103-e8ebcab6c80b9044.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/573)

![img](https://upload-images.jianshu.io/upload_images/1724103-ea242640383ed739.png?imageMogr2/auto-orient/)

### 首部

分类：通用首部、请求首部、响应首部、实体首部、拓展首部

- 通用首部：客户端和服务端都可以用，描述一些通用信息
- 请求首部：请求报文特有，为服务器提供额外信息
- 响应首部：响应报文特有，为客户端提供信息
- 实体首部：描述实体主体部分的首部
- 拓展首部：非标准首部，由应用开发者创建，未添加到HTTP规范中

#### 通用首部

- Date：报文创建时间
- Connection：客户端和服务器连接的有关选项
- Via：报文经过的中间节点（代理、网关）
- Cache-control：缓存

#### 请求首部

- Host：接受请求的服务器的主机名和端口
- Referer：当前请求的URL
- UA-OS：客户端操作系统及版本
- Accept：告诉服务器能够发送的媒体类型
- Accept-Charset：告诉服务器能够发送的字符集
- Accept-Encoding：告诉服务器能够发送的编码方式
- Accept-Language：告诉服务器能够发送的语言
- Authorization：包含客户端提供给服务端，以便进行安全认证的数据
- Cookie：客户端需要发送的cookie
- Cache-Control: 取值为一般为`no-cache`或`max-age=XX`，XX为个整数，表示该资源缓存有效期(秒)

#### 实体首部

- Allow：对该实体可执行的请求方法
- Location：资源的新地址，重定向中常用到
- Content-Language：理解主体应该使用的语言
- Content-Length：主体的长度
- Content-Encoding：对主体实行的编码方式
- Content-Type：主体的类型
- Expires：实体不再有效，需要再次获取该实体的时间
- Last-Modified：实体最后一次被修改的时间

#### 响应首部

- Server：服务器应用软件名称及版本
- Set-Cookie：设置cookie

### HTTP 状态码

[MDN http status code](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)

[MDN http status code -zh-CN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status) 

+ 1xx 信息响应
+ 2xx 成功相应
+ 3xx 重定向
+ 4xx 客户端响应
+ 5xx 服务端响应

## HTTP API 设计指南

### 使用 HTTPS

### 版本化

+ 在 URL 中标明版本

  eg:

  ```
  http://shonzilla/api/v2.2/customers/1234
  http://shonzilla/api/v2.0/customers/1234
  http://shonzilla/api/v2/customers/1234
  http://shonzilla/api/v1.1/customers/1234
  http://shonzilla/api/v1/customers/1234
  ```

+ 在 Header 中标明版本

  + 自定义 header

    ```
    HTTP GET:
    https://haveibeenpwned.com/api/breachedaccount/foo
    api-version: 2
    ```

  + 利用 content type

    ```
    HTTP GET:
    https://haveibeenpwned.com/api/breachedaccount/foo
    Accept: application/vnd.haveibeenpwned.v2+json
    ```

    ```
    HTTP GET:
    https://haveibeenpwned.com/api/breachedaccount/foo
    Accept: application/vnd.haveibeenpwned+json; version=2.0
    ```

### 返回合适的状态码

为每一次的响应返回合适的HTTP状态码. 成功的HTTP响应应该使用如下的状态码:

- `200`: `GET`请求成功, 以及`DELETE`或 `PATCH` 同步请求完成
- `201`: `POST` 同步请求完成
- `202`: `POST`, `DELETE`, 或 `PATCH` 异步请求将要完成
- 。。。

对于用户请求的错误情况，及服务器的异常错误情况，请查阅完整的HTTP状态码 [HTTP response code spec](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)

### 在请求的body体使用JSON数据

在 `PUT`/`PATCH`/`POST` 请求的body体使用JSON格式数据, 而不是使用 form 表单形式的数据. 这里我们使用JSON格式的body请求创建对称的格式数据, 例如.:

```
$ curl -X POST https://service.com/apps \
    -H "Content-Type: application/json" \
    -d '{"name": "demoapp"}'

{
  "id": "01234567-89ab-cdef-0123-456789abcdef",
  "name": "demoapp",
  "owner": {
    "email": "username@example.com",
    "id": "01234567-89ab-cdef-0123-456789abcdef"
  },
  ...
}
```

### 提供资源的唯一标识

在默认情况给每一个资源一个`id`属性. 用此作为唯一标识除非你有更好的理由不用.不要使用那种在服务器上或是资源中不是全局唯一的标识，比如自动增长的id标识。

返回的唯一标识要用小写字母并加个分割线格式 `8-4-4-4-12`, 例如.:

```
"id": "01234567-89ab-cdef-0123-456789abcdef"
```

### 提供标准的时间戳

提供默认的资源创建时间，更新时间 `created_at` and `updated_at` , 例如:

```
{
  ...
  "created_at": "2012-01-01T12:00:00Z",
  "updated_at": "2012-01-01T13:00:00Z",
  ...
}
```

这些时间戳可能不适用于某些资源，这种情况下可以忽略省去。

### 使用ISO8601的国际化时间格式

在接收的返回时间数据时只使用UTC格式. 查阅ISO8601时间格式, 例如:

```
"finished_at": "2012-01-01T12:00:00Z"
```

### 使用统一的资源路径

#### 资源命名

使用复数形式为资源命名

#### 形为

好的末尾展现形式不许要指定特殊的资源形为，在某些情况下，指定特殊的资源的形为是必须的,用一个标准的`actions`前缀去替代他, 清楚的描述他:

```
/resources/:resource/actions/:action
```

例如.

```
/runs/{run_id}/actions/stop
```

### 路径和属性要用小写字母

使用小写字母并用`-`短线分割路径名字,并且紧跟着主机域名 e.g:

```
service-api.com/users
service-api.com/app-setups
```

同样属性也要用小写字母, 但是属性名字要用下划线`_`分割。例如.:

```
"service_class": "first"
```

### 嵌套外键关系

序列化的外键关系通常建立在一个有嵌套关系的对象之上, 例如.:

```
{
  "name": "service-production",
  "owner": {
    "id": "5d8201b0..."
  },
  ...
}
```

而不是这样 例如:

```
{
  "name": "service-production",
  "owner_id": "5d8201b0...",
  ...
}
```

这种方式尽可能的把相关联的资源信息内联在一起，而不用改变响应资源的结构,或者展示更高一级的响应区域, 例如:

```
{
  "name": "service-production",
  "owner": {
    "id": "5d8201b0...",
    "name": "Alice",
    "email": "alice@heroku.com"
  },
  ...
}
```

### 支持方便的无id间接引用

在某些情况下，为了方便用户使用接口，在末尾提供用id标识资源,例如，一个用户想到了他在heroku平台app的名字，但是这个app的唯一标识是id,这种情况下，你想让接口通过名字和id都能访问，例如:

```
$ curl https://service.com/apps/{app_id_or_name}
$ curl https://service.com/apps/97addcf0-c182
$ curl https://service.com/apps/www-prod
```

不要只接受使用名字而剔除了使用id。

### 构建错误信息

在网络请求响应错误的时候，返回统一的，结构化的错误信息。要包含一个机器可读的错误 `id`,一个人类能识别的错误信息 `message`, 根据情况可以添加一个`url` ，告诉客户端关于这个错误的更多信息以及如何去解决它。 例如:

```
HTTP/1.1 429 Too Many Requests
```

```
{
  "id":      "rate_limit",
  "message": "Account reached its API rate limit.",
  "url":     "https://docs.service.com/rate-limits"
}
```

把你的错误信息格式文档化，以及这些可能的错误信息`id`s 让客户端能获取到.

### 用id来跟踪每次的请求

在每一个API响应中要包含一个`Request-Id`头信息, 通常用唯一标识UUID. 如果服务器和客户端都打印出他们的`Request-Id`, 这对我们的网络请求调试和跟踪非常有帮助.

### 按范围分页

对于服务器响应的大量数据我们应该为此分页。 使用`Content-Range` 头传递分页请求的数据.这里有个例子详细的说明了请求和响应头、状态码，限制条件、排序以及分页处理：[Heroku Platform API on Ranges](https://devcenter.heroku.com/articles/platform-api-reference#ranges).

注：服务器会在响应头中添加 `Accept-Ranges: bytes` 来表示支持 Range 的请求，之后客户端才可能发起带 Range 的请求

eg:

```
# first
Content-Length：1200
Content-Range：bytes 0-1199/5000

# second
Content-Length：1200
Content-Range：bytes 1200-2399/5000

# third
Content-Length：1200
Content-Range：bytes 2400-3599/5000

# fourth
Content-Length：1400
Content-Range：bytes 3600-5000/5000
```

### 显示速度限制状态

客户端的访问速度限制可以维护服务器的良好状态，进而为其他客户端请求提供高性的服务

为每一个带有 `RateLimit-Remaining` 响应头的请求，返回预留的请求tokens。

### 指定可接受头信息的版本

在开始的时候指定API版本，使用`Accepts`头传递版本信息,也可以是一个自定义的内容, 例如:

```
Accept: application/vnd.heroku+json; version=3
```

最好不要给出一个默认的版本, 而是要求客户端明确指明他们要使用特定的版本.

### 提供人类可读的文档

提供人类可读的文档让客户端开发人员可以理解你的API。

除此之在详细信息的结尾，提供一个关于如下信息的API摘要:

- 验证授权,包含获取及使用验证tokens.
- API 稳定性及版本控制, 包含如何选择所需要的版本.
- 一般的请求和响应头信息.
- 错误信息序列格式.
- 不同语言客户端使用API的例子.

### 提供可执行的示例

提供可执行的示例让用户可以直接在终端里面看到API的调用情况,最大程度的让这些示例可以逐字的使用，以减少用户尝试使用API的工作量。例如:

```
$ export TOKEN=... # acquire from dashboard
$ curl -is https://$TOKEN@service.com/users 
```