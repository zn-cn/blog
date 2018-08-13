---
title:  HEXO 建站指南
date: 2018-1-30 12:48:25
tags: 
	- hexo
categories: 
	- 其他
---

系统配置：Ubuntu

## 一、配置ssh

- **本地生成密钥对**
  `ssh-keygen -t rsa -C "你的邮件地址"`，注意命令中的大小写不要搞混。按提示指定保存文件夹，不设置密码。
- **添加公钥到Github**

1. 根据上一步的提示，找到公钥文件（默认为id_rsa.pub），用编辑器打开，全选并复制。
2. 登录Github，右上角 头像 -> `Settings` —> `SSH keys` —> `Add SSH` key。把公钥粘贴到key中，填好title并点击 Add key。
3. git bash中输入命令`ssh -T git@github.com`，选yes，等待片刻可看到成功提示。

- **修改本地的ssh remote url，不用https协议，改用git协议**

1. Github仓库中获取ssh协议相应的url
2. 本地仓库执行命令`git remote set-url origin SSH对应的url`，配置完后可用`git remote -v`查看结果

这样`git push`或`hexo d`时不再需要输入账号密码。

## 二、环境准备

#### 1. 安装node.js

+ 下载源码，[官网下载地址](https://nodejs.org/en/download/) ，选择source code下载即可，但是下载速度感人，这里贡献一下我的 [百度网盘nodejs](https://pan.baidu.com/s/1kVVLSAb) 

+ 环境配置

  将源码解压之后 mv 到/usr/local/node (经过改名)，输入`gedit ~/.bashrc` ，在最后两行加上

  ```shell
  export NODE_HOME=/usr/local/node  # 你的node安装目录
  export PATH=$PATH:$NODE_HOME/bin  
  ```

+ 检测

  在bash下输入 `source ~/.bashrc` ，之后输入 `node -v` ，如果显示你的node 版本则表示安装成功

#### 2. 安装 HEXO

命令：

```shell
npm install hexo-cli -g
npm install hexo --save
```

## 三、开始搭建

#### 1. 建立 your_name.github.io 仓库 和 blog仓库

   将your_name改成你的github账号名字就行了

   注：blog 是为了方便放博客

#### 2. 博客初始化

+ 将 blog clone下来

  命令： `git clone git@github.com:your_name/blog.git` 

+ cd 进去之后，初始化

  ```shell
  hexo init
  npm install
  hexo g
  hexo s
  ```

  在浏览器中打开`http://localhost:4000/`，你将会看到：

  ![hexo初体验](http://upload-images.jianshu.io/upload_images/7109326-f5497ae992efe581?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 3. HEXO 详解

###### 1. 常用命令

+ hexo generate (hexo g) 生成静态文件，会在当前目录下生成一个新的叫做public的文件夹

+ hexo server (hexo s) 启动本地web服务，用于博客的预览

+ hexo deploy (hexo d) 部署播客到远端（比如github等平台）

+ hexo new (hexo n) 新建文章和页面

  ```shell
  hexo new "postName" #新建文章
  hexo new page "pageName" #新建页面
  ```

常用组合：

```shell
hexo d -g #生成部署
hexo s -g #生成预览
```

###### 2. 发文章

+ 直接创建

  在 **source/_posts/**下新建一个`.md`文件，头部加上类似以下内容（格式）

  ```md
  ---
  title: hexo 建站指南
  data: 2018-1-31 12:48:25
  tags: 
  	- hexo
  categories: 
  	- 其他
  ---
  ```

+ 命令方式

  命令： `hexo new hello` 

  之后编辑 hello.md 即可

###### 3.  新建标签页面

+  两个确认

  - 确认站点配置文件有

  ```
  tag_dir: tags

  ```

  - 确认主题配置文件有

  ```
  tags: tags

  ```

- 新建tags页面

  ```
  hexo new page tags
  ```

  此时会在`source/`下生成`tags/index.md`文件

+ 修改 source/tags/index.md

```
title: tags
date: 2018-1-31 16:49:50
type: "tags"        <!-- 必须 -->
comments: false     <!-- 必须 -->
```

> 这里 date 会自动生成

+ 在文章中添加tags

  在文章`xx.md`中添加：

  ```
  tags: 
  	- Tag1
  	- Tag2
  ```

  多个Tag可按上面的格式添加。

  其文件头部类似：

  ```
  title: 
  date: 2018-1-31 10:44:25
  tags: 
  	- Tag1
  	- Tag2
  ```

###### 4. 新建目录页面

+ 两个确认

  - 确认站点配置文件打开了

  ```
  category_dir: categories
  ```

  - 确认主题配置文件打开了

  ```
  categories: /categories
  ```

- 新建categories文件

  ```
  hexo new page categories
  ```

  此时会在`source`目录下生成`categories/index.md`文件

+ 修改categories/index.md

  ```
  title: categories
  date: 2018-1-31 16:49:50
  type: "categories"     <!-- 必须 -->
  comments: false        <!-- 必须 -->

  ```

  > 这里 date 会自动生成


+ 在文章中添加categories

  在文章xx.md中添加：

  ```
  categories: 
  	- cate
  ```

  其文件头部类似：

  ```
  title: TagEditText
  date: 2018-1-31 10:44:25
  categories: 
  	- cate
  ```

###### 5. 添加about页面

命令： ` hexo new page "about"` 

之后在\source\about\index.md目录下会生成一个index.md文件，打开输入个人信息即可

###### 6. 添加搜索页面

注明：此处以next主题为例

+ 命令：`npm install hexo-generator-search --save`

+ 在博客根目录下的 _config.yml 中添加如下配置：

  ```
  search:
    path: search.xml
    field: all
  ```

  > - **path** - file path. Default is `search.xml` .
  > - field \- the search scope you want to search, you can chose:
  >   - **post** (Default) - will only covers all the posts of your blog.
  >   - **page** - will only covers all the pages of your blog.
  >   - **all** - will covers all the posts and pages of your blog.

更多配置说明可到插件页面查看：[hexo-generator-search](https://github.com/PaicHyperionDev/hexo-generator-search) 

+ 在 themes/next/layout/_partials/search 目录下修改 localsearch.swig 文件

  原始文件内容如下：

  ```
   <script type="text/javascript">
       var search_path = "<%= config.search.path %>";
       if (search_path.length == 0) {
       	search_path = "search.xml";
       }
       var path = "<%= config.root %>" + search_path;
       searchFunc(path, 'local-search-input', 'local-search-result');
   </script>

  ```

  修改后的文件内容为:

  ```
  <div class="popup">
   <span class="search-icon fa fa-search"></span>
   <input type="text" id="local-search-input" placeholder="search my blog...">
   <div id="local-search-result"></div>
   <span class="popup-btn-close">close</span>
  </div>

  ```

  注：部分主题中此处已经配置好了，无需更改

+ 效果演示

  主题： next

  [站外图片上传中...(image-38e6a4-1525880166286)]

  ​                                     *hexo-theme-next 本地搜索效果演示* 

#### 4. 配置 

###### 1. 简单配置

网站的设置大部分都在 **_config.yml** 文件中，详细配置可以查看[官方文档](https://hexo.io/zh-cn/docs/configuration.html)  

下面只列出简单常用配置	

- **title** -> 网站标题
- **subtitle** -> 网站副标题
- **description** -> 网站描述
- **author** -> 您的名字
- **language** -> 网站使用的语言

注意：**进行配置时，需要在冒号:后加一个英文空格** 

###### 2. deploy

输入命令： `npm install hexo-deployer-git --save` 

在博客根目录下的`_config.yml`文件，末尾添加如下信息：

```
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repo: git@github.com:your_name/your_name.github.io.git
  branch: master
```

然后执行命令：

```
hexo g
hexo d
```

即可部署到github上

###### 3. 添加评论功能

+ 注册 [Disqus](https://link.jianshu.com/?t=https://disqus.com/) 账号

+ 配置 Disqus

  登录后，点击首页的 GET STARTED 按钮，之后选择 I want to install Disqus on my site 选项，完成相关配置

  > Websit Name 就是 short name 自己填写，但是要求全网唯一，设定后不可改变，比如我的是 wangkunlin，这个在配置 Hexo 的时候需要用到
  > Category 选择种类，可以随便选
  > Language 语言选 Chinese 或者 English
  > 然后点 Create Site 等待界面跳转
  > 接下来在页面的左侧点击 Configure Disqus
  >
  > ​
  >
  > 在 Website URL 那里填写自己的博客地址，Description 可以不写，然后点 Complete Setup，Disqus 基本的设置已经完成

+ 配置 HEXO

  在博客根目录下的_config.yml 中添加如下信息：

  ```
  Disqus
  disqus:
    enable: true
    shortname: your_count
    count: true
  ```

+ 修改相应文件

  进入 theme 你的主题目录，找到 comment.ejs，我的是在blog/themes/next/layout/_partials/comments.swig，不同主题请自行查找，替换为下面的内容

  注：部分主题无需修改，已修改好

  ```
  <% if (page.comments){ %>
  <section id="comment">
    <% if(config.disqus_shortname) { %>
    <div id="disqus_thread">
      <noscript>Please enable JavaScript to view the <a href="//disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
    </div>
    <% } %>
  </section>
  <% } %>
  ```

######　5. 使用图床

博客中的图片文件可以直接放在source文件夹下，但是访问速度较慢，把图片放在国内的图床上是个更好的选择。

这里选用: [七牛云存储](https://portal.qiniu.com/signup?code=3lgo2c4fgwv9u) 

免费用户实名审核之后，可以获取10GB永久免费存储空间、每月10GB下载流量、每月10万次Put请求、每月100万次Get请求，做图床绰绰有余。

注册账号，新建空间，我的新空间名是`blog`，专门用来放置博客上引用的资源。

进入空间后点击「内容管理」，再点击「上传」：
[[图片上传失败...(image-864536-1525880166286)]](http://7xo8t2.com1.z0.glb.clouddn.com/img/Hexo%203.1.1%20%E9%9D%99%E6%80%81%E5%8D%9A%E5%AE%A2%E6%90%AD%E5%BB%BA%E6%8C%87%E5%8D%97/%E4%B8%83%E7%89%9B%E4%B8%8A%E4%BC%A0%E5%9B%BE%E7%89%87%E6%A1%86.png)

七牛空间没有文件夹的概念，但是允许为文件添加带斜杠`/`的前缀，用来给资源分类。这里我设置前缀为`img/Hexo 3.1.1 静态博客搭建指南/`。上传了一张图片：
[[图片上传失败...(image-f2ba2c-1525880166286)]](http://7xo8t2.com1.z0.glb.clouddn.com/img/Hexo%203.1.1%20%E9%9D%99%E6%80%81%E5%8D%9A%E5%AE%A2%E6%90%AD%E5%BB%BA%E6%8C%87%E5%8D%97/%E4%B8%83%E7%89%9B%E4%B8%8A%E4%BC%A0%E5%9B%BE%E7%89%87%E5%90%8E.png)

在右侧可以找到外链，复制地址：
[[图片上传失败...(image-558e6-1525880166286)]](http://7xo8t2.com1.z0.glb.clouddn.com/img/Hexo%203.1.1%20%E9%9D%99%E6%80%81%E5%8D%9A%E5%AE%A2%E6%90%AD%E5%BB%BA%E6%8C%87%E5%8D%97/%E4%B8%83%E7%89%9B%E5%9B%BE%E7%89%87%E5%A4%96%E9%93%BE.png)

Markdown 插入图片的语法为：

```
![](图片网址)
```

上传图片 -> 获取外链 -> 写入Markdown，就这么简单！

由于七牛防盗链的白名单无法添加`localhost`，暂时不设置防盗链，否则`hexo s`调试的时候，看不到图片。

以上操作每插入一张图片就要做一次，相当繁琐，于是写了个脚本简化，详见这篇文章[《拖曳文件上传到七牛的Python脚本》](http://lovenight.github.io/2015/11/17/%E6%8B%96%E6%9B%B3%E6%96%87%E4%BB%B6%E4%B8%8A%E4%BC%A0%E5%88%B0%E4%B8%83%E7%89%9B%E7%9A%84%E8%84%9A%E6%9C%AC/) 

###### 6. 更换主题

这里我选用了[Next](https://github.com/iissnan/hexo-theme-next) 主题，更多主题请前往 [HEXO](https://hexo.io/themes/) 官网

+ 安装：在博客根目录下执行`git clone https://github.com/iissnan/hexo-theme-next.git themes/next`  ，或者自行前往 github 上下载，然后mv至博客相关位置

+ 启用：修改博客根目录下的`_config.yml`配置文件中的`theme`属性，将其设置为`next`

+ 修改 主题的_config.yml

  + 修改 scheme

    如：

    ```
    # Schemes
    # scheme: Muse
    scheme: Mist
    # scheme: Pisces
    # scheme: Gemini
    ```

###### 7. 绑定独立域名

+ [购买域名](https://wanwang.aliyun.com/)
+ 设置域名解析，添加一个 CNAME记录，指向你的github.io页面
+ 在source目录下，添加CNAME文件（没有后缀）,在文件里面写上你的域名（只能写一个）



###### 8. 设置阅读全文

效果请看 [tofar](http://tofar.github.io) 

+ 方法一：在文章中使用`< !--more-->` 手动进行截断

  这种方法可以根据文章的内容，自己在合适的位置添加 `< !--more-->` 标签，使用灵活，也是Hexo推荐的方法。

+ 方法二：在文章中的`front-matter`中添加description

  提供文章摘录这种方式只会在首页列表中显示文章的摘要内容，进入文章详情后不会再显示。

+ 自动形成摘要，在**主题配置文件**中添加

  1. 默认截取的长度为 150 字符，可以根据需要自行设定

  ```
  auto_excerpt:
    enable: true
    length: 150
  ```


###### 8. 字体配置

+ 修改字体大小

  文件位置：～blog/themes/next/source/css/_variables/base.styl

  `font-size-base           = 16px`

+ 配置文件位置：blog/themes/next/source/css/_variables/base.styl

  ```
  // Font families.
  $font-family-chinese      = -apple-system, BlinkMacSystemFont, "PingFang SC", "Hiragino Sans GB", "Heiti SC", "STHeiti", "Source Han Sans SC", "Noto Sans CJK SC", "WenQuanYi Micro Hei", "Droid Sans Fallback", "Microsoft YaHei", source-han-sans-simplified-c
  $font-family-base         = $font-family-chinese, sans-serif
  $font-family-base         = get_font_family('global'), $font-family-chinese, sans-serif if get_font_family('global')
  $font-family-logo         = $font-family-base
  $font-family-logo         = get_font_family('logo'), $font-family-base if get_font_family('logo')
  $font-family-headings     = $font-family-base
  $font-family-headings     = get_font_family('headings'), $font-family-base if get_font_family('headings')
  $font-family-posts        = $font-family-base
  $font-family-posts        = get_font_family('posts'), $font-family-base if get_font_family('posts')
  $font-family-monospace    = $font-family-chinese, monospace
  $font-family-monospace    = Menlo, Monaco, Consolas, get_font_family('codes'), $font-family-chinese, monospace if get_font_family('codes')
  ```

+ 主题配置文件：blog/themes/next/_config.yml

  ```
  font:
    enable: true
    # Uri of fonts host. E.g. //fonts.googleapis.com (Default)
    # 亲测这个可用，如果不可用，自己搜索 [Google 字体 国内镜像]，找个能用的就行
    host: https://fonts.cat.net
    # Global font settings used on <body> element.
    global:
      # external: true will load this font family from host.
      external: true
      family: Lato
    # Font settings for Headlines (h1, h2, h3, h4, h5, h6)
    # Fallback to `global` font settings.
    headings:
      external: true
      family: Roboto Slab
    # Font settings for posts
    # Fallback to `global` font settings.
    posts:
      external: true
      family:
    # Font settings for Logo
    # Fallback to `global` font settings.
    # The `size` option use `px` as unit
    logo:
      external: true
      family:
      size:
    # Font settings for <code> and code blocks.
    codes:
      external: true
      family: Roboto Mono
      size:
  ```

#### 5. 更多配置

###### 1. 更改上一篇，下一篇的顺序

进入一篇文章，在文章底部，有上下篇的链接（< >），但是点 > 发现进入的是页面中的的上面那篇文章，与操作习惯不符，别扭。

我猜这是从时间角度设计的，> 英语叫 next ，而 next 是更新的。不过别扭就改成习惯的好了，从空间位置角度设计。[1](https://reuixiy.github.io/technology/computer/computer-aided-art/2017/06/09/hexo-next-optimization.html#fn:1)

方法就是修改文件：

**注意下面文件中的加减**

```
文件位置：~/blog/themes/next/layout/_macro/post.swig

{% if not is_index and (post.prev or post.next) %}
  <div class="post-nav">
    <div class="post-nav-next post-nav-item">
-      {% if post.next %}
+      {% if post.prev %}
-        <a href="{{ url_for(post.next.path) }}" rel="next" title="{{ post.next.title }}">
+        <a href="{{ url_for(post.prev.path) }}" rel="prev" title="{{ post.prev.title }}">
-          <i class="fa fa-chevron-left"></i> {{ post.next.title }}
+          <i class="fa fa-chevron-left"></i> {{ post.prev.title }}
        </a>
      {% endif %}
    </div>

    <span class="post-nav-divider"></span>

    <div class="post-nav-prev post-nav-item">
-      {% if post.prev %}
+      {% if post.next %}
-        <a href="{{ url_for(post.prev.path) }}" rel="prev" title="{{ post.prev.title }}">
+        <a href="{{ url_for(post.next.path) }}" rel="next" title="{{ post.next.title }}">
-          {{ post.prev.title }} <i class="fa fa-chevron-right"></i>
+          {{ post.next.title }} <i class="fa fa-chevron-right"></i>
        </a>
      {% endif %}
    </div>
  </div>
{% endif %}
```

###### 2. 移动端显示 back-to-top 按钮和侧栏

前提: 主题的设计模版是 Muse 或 Mist

文件位置：主题_config.yml

```
# Enable sidebar on narrow view (only for Muse | Mist).
  onmobile: true
```

###### 3.  侧边栏社交链接

