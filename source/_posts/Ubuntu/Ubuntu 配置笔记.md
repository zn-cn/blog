---
title: Ubuntu 配置指南
date: 2018-5-1 20:34:25
tags: 
	- Ubuntu
	- config
	- beautify
	- init
categories: 
	- Ubuntu
---

测试环境：Ubuntu16.04 LTS

## 安装篇

[16 Things To Do After Installing Ubuntu 16.04 LTS](http://www.omgubuntu.co.uk/2016/04/10-things-to-do-after-installing-ubuntu-16-04-lts)

1. 安装wps

   [wps下载](http://wps-community.org/downloads) 

   安装： `sudo dpkg -i wps-office_10.1.0.5707~a21_amd64.deb  `

   如果有依赖故障 修复依赖: `sudo apt-get install  -f`

   之后可以在 **模板** 文件夹中分别新建一个Excel，Word，PPT模板，这样可以在 右键菜单中直接新建文档。

   **WPS字体配置：**

   1. 下载缺失的字体文件，然后复制到Linux系统中的/usr/share/fonts文件夹中。

      国外下载地址：<https://www.dropbox.com/s/lfy4hvq95ilwyw5/wps_symbol_fonts.zip>

      国内下载地址：<https://pan.baidu.com/s/1eS6xIzo>

   2. 下载完成后，解压并进入目录中，继续执行：

      ```
      sudo cp * /usr/share/fonts
      ```

      1. 执行以下命令,生成字体的索引信息：

         ```
         sudo mkfontscale
         ```

         ```
         sudo mkfontdir
         ```

      2. 运行fc-cache命令更新字体缓存。

         ```
         sudo fc-cache
         ```

      3. 重启wps即可，字体缺失的提示不再出现。

2. Install Linux Graphics Drivers

   ![drivers](https://user-gold-cdn.xitu.io/2018/4/28/1630a36d7d2e4150?w=500&h=293&f=jpeg&s=35938)

3. Install Media Codecs

   ![rythmbox-in-ubuntu](https://user-gold-cdn.xitu.io/2018/4/28/1630a36d7d0e8d3c?w=350&h=200&f=jpeg&s=13841)

   Playing MP3s in Rhythmbox

   Legal issues stop Ubuntu from being able to play MP3, MP4 and other media files ‘out of the box’.

   Ubuntu can play your audio and video files, you just have to tell it to do so.

   The easiest way to do this is to check (tick) the ‘*Enable Restricted Formats*‘ box during installation. This will install all the required multimedia codecs automatically, along with the OS itself.

   If you forgot to do that (or upgrade from an earlier release) you can install the multimedia codecs manually via the Software app:

   [Install Ubuntu Restricted Extras](apt://ubuntu-restricted-extras)

4. 鼠标点击最小化

   对于 unity 桌面

   [![unity launcher](https://user-gold-cdn.xitu.io/2018/4/28/1630a36d7d4be846?w=350&h=223&f=gif&s=309176)](https://www.omgubuntu.co.uk/wp-content/uploads/2016/04/unity-launcher.gif)

   Click on an app launcher icon to open an app. Click on the same icon again to minimise the app. Intuitive, right?

   That may be, but it is not the default behaviour in Unity — which can be off-putting to new users. It’s also not obvious how to enable it.

   Run the following command (or install/use Unity Tweak Tool > Unity > Launcher > Minimise):

   ```
   gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true
   ```

5. Adobe Flash on Linux

   Flash sucks, but for some sites you may not have the option of not using it.

   [Adobe officially stopped supporting Flash on Linux](http://www.omgubuntu.co.uk/2012/02/adobe-adandons-flash-on-linux) in 2012 and many web browsers are in the process of dropping support for its NPAPI architecture.

   The overall best solution for using Flash on Linux is to download and use Google Chrome. Chrome comes with an**up-to-date version of the Flash plugin** built-in. In fact it’s the only way to get the latest Flash player updates on Linux — and it’s a PPAPI plugin, too.

   But I appreciate that not everyone wants to use Chrome. Some of you may be using a 32-bit version of Ubuntu, which Chrome no longer supports. Whatever the reason you need it, here’s how to get it:

   [Install Flash Player Plugin](apt://flashplugin-installer)

   If you want to watch Amazon Instant Video, Hulu or any other sites that uses DRM through HAL, [we’ve got a guide on that.](http://www.omgubuntu.co.uk/2015/09/how-to-watch-hulu-on-ubuntu-1404-up)

6. 垃圾清理软件

   [![bleachbit running on ubuntu 16.04](https://user-gold-cdn.xitu.io/2018/4/28/1630a36d7d54079e?w=750&h=392&f=jpeg&s=80231)](http://www.omgubuntu.co.uk/wp-content/uploads/2016/04/bleachbit-system-cleaner-app-on-ubuntu.jpg)

   [Install BleachBit on Ubuntu](apt://bleachbit)

7. sublime text

   https://www.sublimetext.com/docs/3/linux_repositories.html#apt

8. vscode

   https://code.visualstudio.com/download

9. 搜狗输入法

   [下载地址](https://pinyin.sogou.com/linux/?r=pinyin)

10. vim

  https://github.com/tofar/vim-zsh-tmux

11. redshift （护眼软件）

    ```
    sudo apt-get update
    sudo apt-get install redshift gtk-redshift
    ```

    ![img](https://user-gold-cdn.xitu.io/2018/4/28/1630a36d7d537462?w=750&h=418&f=png&s=338072)

    [redshift docs](http://jonls.dk/redshift/)

12. 网易云音乐

    https://music.163.com/#/download

13. postman

    https://blog.bluematador.com/posts/postman-how-to-install-on-ubuntu-1604/ 

14. git 、pip、pip3、docker、openresty 。。。

15. 安装shadowsocks-qt5

    ### 第一种安装方式

    shadowsocks-qt5 需要通过PPA源安装，仅支持Ubuntu 14.04或更高版本。
    1、设置 PPA 源并安装 shadowsocks-qt5

    ```
    sudo add-apt-repository ppa:hzwhuang/ss-qt5sudo apt-get updatesudo apt-get install shadowsocks-qt5
    ```

    2、安装过程遇到 libappindicator1 依赖问题（dependency problems），而 libappindicator1 又遇到 libindicator7 依赖的解决办法。一并安装 libappindicator1 libindicator7 依赖，再重新安装 shadowsocks-qt5。

    ```
    sudo apt-get -f install libappindicator1 libindicator7
    ```

    3、完成后就可以打开 shadowsocks-qt5 啦

    ### 第二种安装方式

    这上面的呢是使用apt-get直接安装，下面我们介绍第二种使用方式，安装的版本会比上面这样安装的版本高一点。

    由于个别的服务商更换了一些其他的加密方式比如CHACHA20-IETF-POLY1305，这种加密方式只有ShadowSocks-Qt5 V3.0.0才加入，由于apt-get上ss-qt5以及不再更新，我们只能去gayhub想办法咯

    我们去这里下载最新的版本是后缀为.AppImage的文件哦，同学们别下载错啦

    > <https://github.com/shadowsocks/shadowsocks-qt5/releases>

    下载好之后把IMG放到自己的文件夹里 然后给权限直接运行，代码如下 (我写这篇文章的时候是这个版本号，你们记得换成最新的哦)

    ```
    chmod a+x Shadowsocks-Qt5-3.0.0-x86_64.AppImage./Shadowsocks-Qt5-3.0.0-x86_64.AppImage
    ```

16. 下载 SwitchyOmega

    https://github.com/FelisCatus/SwitchyOmega/releases


修复篇
---

1. 修复 ubuntu 中检测到系统程序错误的问题

   ```
   sudo rm /var/crash/*
   sudo gedit /etc/default/apport

   修改为如下即可：
   # 设置0表示禁用Apportw，或者1开启它。
   # 你可以用下面的命令暂时关闭它：
   # sudo service apport start force_start=1
   enabled=1
   ```

2. 卸载libreOffice

   ibreoffice是ubuntu自带的开源office软件，体验效果不如windows上的office，于是选择用WPS来替代。（安装WPS见安装篇）

   ```shell
   sudo apt-get purge libreoffice?
   或
   sudo aptitude purge libreoffice?
   不要漏掉通配符“?”，否则无法清除/卸载全部 LibreOffice 软件包
   或
   sudo apt-get remove --purge libreoffice*
   ```


2. 删除不常用软件

   删除Amazon的链接

   `sudo apt-get remove unity-webapps-common `

   ```shell
   sudo apt-get remove thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot 
   sudo apt-get remove gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku  landscape-client-ui-install  
   sudo apt-get remove onboard deja-dup 
   ```

3. 删除Ubuntu Linux旧内核的方法

   用Ubuntu一段时间后，就会发觉由于自动升级，系统里安装了很多内核。像我，竟然安装了下面那么多，这个造成了漫长的启动列表。必须删掉一些不用的。

   首先就是使用如下命令，列出所有安装的内核，下表中，带有image的就是内核文件。从中选择要卸载的包，用apt-get来卸载

   **具体如下:**

   ```
   dpkg --get-selections|grep linux
   sudo apt-get remove linux-image-2.6.24-16-generic   
   sudo apt-get remove linux-headers-2.6.24-16-generic 
   ```

   查看当前系统使用的内核: `uname -a`

4. Windows 10和Ubuntu 16.04双系统时间错误的调整

   **原因：**

   ​       如果安装了 Windows 和 Linux（比如 Ubuntu）双系统，有时会出现两个系统的时间不一致的情况。这是因为，两个操作系统对电脑硬件时间的定义不一样，**Windows 认为电脑硬件时间是“本地时间”**，因此它启动后直接用该时间作为“系统时间”并显示在桌面右下角的系统托盘里；而**Ubuntu 等 Linux 发行版则认为电脑硬件时间是“全球统一时间”（即 UTC)**，它在启动后在该时间的基础上，再加上电脑设置的时区数（比如我们在中国，它就加上“8”）。根据获得的资料得知，两种模式各有利弊，但是后一种模式在遇到时区转换、夏令时等情况时，通用性更强。

   **解决方案：**

   ​       基于上述原因，协调 Win/Lin 双系统时间一致的方法，就是让 Windows 也和 Linux 一样，将电脑硬件时间看作“全球统一时间”。

   **具体：**

   1. 在win10中打开**regedit** （在小娜下搜索即可）

   2. 桌面上将出现“注册表编辑器”的窗口，在以下的操作中，将对窗口左侧列表中的 **HKEY_LOCAL_MACHINE** 这一分支进行操作。

      ![Windows 10和Ubuntu 16.04双系统时间错误的调整](https://user-gold-cdn.xitu.io/2018/4/28/1630a36d7df2659b?w=500&h=317&f=jpeg&s=16339)

   3. 点击展开 HKEY_LOCAL_MACHINE 分支，然后依次导航到以下位置：

      `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation`

      ![Windows 10和Ubuntu 16.04双系统时间错误的调整](https://user-gold-cdn.xitu.io/2018/4/28/1630a36d9d160e0f?w=500&h=311&f=jpeg&s=25363)

   4. 在右侧空白处单击鼠标右键，然后依次点击“新建”——“QWORD（64位）值”。

      如果安装的是 32 位系统，则需要新建“DWORD（32位）值”。

      ![Windows 10和Ubuntu 16.04双系统时间错误的调整](https://user-gold-cdn.xitu.io/2018/4/28/1630a36d9edaa00f?w=500&h=399&f=jpeg&s=36714)

   5. 当前位置将会出现一个新建的键值的条目，将其“名称”改为：

      **RealTimeIsUniversal**

      它的大体意思是，硬件时间被作为全球统一时间。

      ![Windows 10和Ubuntu 16.04双系统时间错误的调整](https://user-gold-cdn.xitu.io/2018/4/28/1630a36d9db7008a?w=497&h=400&f=jpeg&s=36100)

   6. 然后双击这一条目，弹出“编辑 QWORD（64位）值”的对话框，确保选中了“十六进制”，然后将“数值数据”改为“1”。最后点击“确定”。

      ![Windows 10和Ubuntu 16.04双系统时间错误的调整](https://user-gold-cdn.xitu.io/2018/4/28/1630a36da124a876?w=501&h=380&f=jpeg&s=26981)

5. Ubuntu截图快捷键

   无须安装如何软件，直接使用Ubuntu自带的快捷键即可满足基本需求

6. [Ubuntu 更新错误修复大全](https://linux.cn/article-5603-1.html)

7. [Ubuntu的一些命令及查看已安装软件包的命令](http://cheneyph.iteye.com/blog/824746)

8. [ubuntu服务器与本地文件传输](http://www.cnblogs.com/by-1075324834/p/5045096.html) 

9. sudo 命令学习

   执行sudo 的时候会去 `/etc/sudoers` 文件中的secure_path 中寻找，而不是在root的PATH中

   所以解决方案：

   1. 在secure_path的目录中建立软链接
   2. 添加你的文件的目录到secure_path中

10. sudo openresty -s reload报错

  报错输出：`nginx: [error] open() "/usr/local/openresty/nginx/logs/nginx.pid" failed (2: No such file or directory)`  或者　`nginx: [error] invalid PID number "" in "/usr/local/openresty/nginx/logs/nginx.pid"`

  原因：暂时没有启动任何server，所以要先用 *nginx -p `pwd`/ -c conf/nginx.conf* 手动启动一些server，再执行 `sudo openresty -s reload` 

11. Ubuntu 按 Alt + Tab 切换的时候双重切换问题

   解决：安装 ccsm

   ```
   sudo apt install compizconfig-settings-manager
   ```

   之后在设置中关闭 应用程序奇幻条以及static Application Switch

   ![Screenshot.png](https://user-gold-cdn.xitu.io/2018/4/29/1631010591a45936?w=400&h=235&f=png&s=50366)

美化篇
---

参考：

**flatabulous-theme风格** http://www.jianshu.com/p/4bd2d9b1af41

**Mac风格** https://imcn.me/html/y2016/26832.html

### 主题

美化效果如图：

![Imgur](https://user-gold-cdn.xitu.io/2018/4/28/1630a36da5285f0a?w=792&h=511&f=png&s=167812)

![macbuntu-4](https://user-gold-cdn.xitu.io/2018/4/28/1630a36dc567be04?w=570&h=321&f=jpeg&s=41341)

#### 安装tweak-tool

```
sudo apt-get install unity-tweak-tool
sudo apt-get install gnome-tweak-tool
```

#### 仿Mac 篇

1、下载 macbuntu 壁纸：

[Download MacBuntu OS Wallpapers](http://pan.baidu.com/s/1skQCq2T)

2、安装 MacBuntu OS Y Theme、Icons 和 cursors：

采用：Macbuntu-os-unity-classic以及相应的图标和指针

安装命令：

```
sudo add-apt-repository ppa:noobslab/macbuntu
sudo apt-get update
sudo apt-get install macbuntu-os-icons-lts-v7
sudo apt-get install macbuntu-os-ithemes-lts-v7
```

卸载命令：

```
cd /usr/share/icons/mac-cursors && sudo ./uninstall-mac-cursors.sh
sudo apt-get remove macbuntu-os-icons-lts-v7 macbuntu-os-ithemes-lts-v7
```

3、安装 Slingscold（替代Launchpad）

```
sudo add-apt-repository ppa:noobslab/macbuntu
sudo apt-get update
sudo apt-get install slingscold
```

![仿Mac OS X主题](https://user-gold-cdn.xitu.io/2018/4/28/1630c36b89f8e0b3?w=272&h=256&f=png&s=42139)

使用效果：

![仿Mac OS X主题](https://user-gold-cdn.xitu.io/2018/4/28/1630c36b8a142675?w=1306&h=694&f=png&s=903357)

4、安装Albert Spotlight (替代 Mac Spotlight)

一个快捷搜索功能：

```
sudo add-apt-repository ppa:noobslab/macbuntu
sudo apt-get update
sudo apt-get install albert
```

第一次启动需要设置快捷键；效果：

![仿Mac OS X主题](https://user-gold-cdn.xitu.io/2018/4/28/1630c36b8b22cb8a?w=1013&h=425&f=png&s=671504)

5、安装 一个 Dock

+ Cairo-dock (自行配置)

  ```
  sudo apt-get install cairo-dock
  ```

  ![img](https://user-gold-cdn.xitu.io/2018/4/28/1630a36dc25d26d9?w=960&h=536&f=gif&s=2403604)

  配置：（自选）

  + 去除桌面切换器插件
  + 停靠左边

  bug修复：

  + chrome 双图标问题

    如下配置chrome即可：捕捉哪里写：google-chrome 同时 最下面的修改为7.730 即可

    ![img](https://user-gold-cdn.xitu.io/2018/4/29/16310105352bebea?w=1202&h=729&f=png&s=110025)

+ docky

  **终端安装命令:**

  ```
  sudo apt-get install docky
  ```

  ![img](https://user-gold-cdn.xitu.io/2018/4/28/1630a36dcd9f3015?w=700&h=394&f=png&s=347898)

+ Plank Dock

  `sudo apt-get install plank`

  安装 Plank 主题：

  ```
  sudo add-apt-repository ppa:noobslab/macbuntu
  sudo apt-get update
  sudo apt-get install macbuntu-os-plank-theme-lts-v7
  ```

  安装 Ctrl + Right Click 选择主题。

  [![7-dock-2](https://user-gold-cdn.xitu.io/2018/4/28/1630a36df69a7264?w=570&h=377&f=jpeg&s=20518)](https://imcn.me/wp-content/uploads/2016/05/7-dock-2.jpg)

  卸载主题命令：

  `sudo apt-get autoremove plank macbuntu-os-plank-theme-lts-v7`

6、将面板上的 ‘Ubuntu Desktop’ 文字替换 ‘Mac’

```
cd && wget -O Mac.po http://drive.noobslab.com/data/Mac/change-name-on-panel/mac.po
cd /usr/share/locale/zh_CN/LC_MESSAGES; sudo msgfmt -o unity.mo ~/Mac.po;rm ~/Mac.po;cd
```

语言上如果是其他语言，将 /zh_CN做相应修改：

恢复原来的桌面文字命令：

```
cd && wget -O Ubuntu.po http://drive.noobslab.com/data/Mac/change-name-on-panel/ubuntu.po
cd /usr/share/locale/zh_CN/LC_MESSAGES; sudo msgfmt -o unity.mo ~/Ubuntu.po;rm ~/Ubuntu.po;cd
```

7、启动器上苹果Logo

[![macbuntu-apple-logo](https://user-gold-cdn.xitu.io/2018/4/28/1630a36df6a214f1?w=400&h=297&f=jpeg&s=16062)](https://user-gold-cdn.xitu.io/2018/4/28/1630a36df6a214f1?w=400&h=297&f=jpeg&s=16062)

命令：

```
wget -O launcher_bfb.png http://drive.noobslab.com/data/Mac/launcher-logo/apple/launcher_bfb.png
sudo mv launcher_bfb.png /usr/share/unity/icons/
```

恢复图标：

```
wget -O launcher_bfb.png http://drive.noobslab.com/data/Mac/launcher-logo/ubuntu/launcher_bfb.png
sudo mv launcher_bfb.png /usr/share/unity/icons/
```

10、字体

+ 文泉驿字体（推荐）

  ***

  ```
  sudo apt-get install fonts-wqy-microhei
  ```

+ Mac 字体

  配置 Mac 字体

  [![mac-fonts](https://user-gold-cdn.xitu.io/2018/4/28/1630a36e08f70165)](https://imcn.me/wp-content/uploads/2016/05/mac-fonts.jpg)

  安装字体命令：

  ```
  wget -O mac-fonts.zip http://drive.noobslab.com/data/Mac/macfonts.zip
  sudo unzip mac-fonts.zip -d /usr/share/fonts; rm mac-fonts.zip
  sudo fc-cache -f -v
  ```

11、修改启动界面：

[![1-bootscreen](https://user-gold-cdn.xitu.io/2018/4/28/1630a36e13523c58?w=570&h=321&f=jpeg&s=4166)](https://imcn.me/wp-content/uploads/2016/05/1-bootscreen.jpg)

```
sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install macbuntu-os-bscreen-lts-v7
```

修改 /usr/share/plymouth/themes/macbuntu/macbuntu.plymouth

原来是 /lib 修改为 /usr/share即可

```
ImageDir=/usr/share/plymouth/themes/macbuntu
ScriptFile=/usr/share/plymouth/themes/macbuntu/macbuntu.script
```

如果你喜欢 MBuntu 启动界面，你想恢复到 Ubuntu ，使用命令：
`sudo apt-get autoremove macbuntu-os-bscreen-lts-v7`

12、登陆迎宾界面：

[![macbuntu-10](https://user-gold-cdn.xitu.io/2018/4/28/1630a36e1bc759a7?w=570&h=321&f=jpeg&s=4657)](https://imcn.me/wp-content/uploads/2016/05/macbuntu-10.jpg)

注意安装这个东东有风险，如果你不是在意，建议不安装，安装这个仅仅适合于 Ubuntu Unity – Lightdm 和 Ubuntu Gnome – gdm，其他桌面环境有风险。

```
sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install macbuntu-os-lightdm-lts-v7
```

配置/etc/lightdm/lightdm.conf（如果没有就创建自己一个），内容为：

```
[SeatDefaults]
greeter-session=lightdm-webkit-greeter
```

配置/etc/lightdm/lightdm-webkit-greeter.conf，修改这两行为：

```
theme-name=macbuntu-lightdm
webkit-theme=macbuntu-lightdm
```

卸载恢复命令：

`sudo apt-get remove macbuntu-os-lightdm-lts-v7`

#### Flatabulous 主题篇

**一个久负盛名的扁平化主题**

1. Using the .deb file for Debian, Ubuntu and derivatives (Recommended)

Download the .deb file from [here](https://github.com/anmoljagetia/Flatabulous/releases/latest), double click to open with Ubuntu Software Center and click on install. Then, install the theme using ubuntu-tweak.

2. Using the noobslab PPA

   ```
   sudo add-apt-repository ppa:noobslab/themes
   sudo apt-get update
   sudo apt-get install flatabulous-theme
   ```


1. Flat Icons

   For icons, I use the ultra-flat-icons theme. It is available in blue (recommended), orange and mint green colors. To install this, you can run the following commands

   ```
   sudo add-apt-repository ppa:noobslab/icons
   sudo apt-get update
   sudo apt-get install ultra-flat-icons
   ```

   Alternatively, you could also run `sudo apt-get install ultra-flat-icons-orange` OR `sudo apt-get install ultra-flat-icons-green`.

   ​

   安装完成后，打开unity-tweak-tool软件，修改主题和图标：

   进入Theme，修改为Flatabulous

   ![主题](https://user-gold-cdn.xitu.io/2018/4/28/1630a36e3a5ea009?w=889&h=170&f=jpeg&s=13744)

   ​

   ![图标](https://user-gold-cdn.xitu.io/2018/4/28/1630a36e423d1f74?w=883&h=428&f=jpeg&s=20133)

2. 字体

   ubuntu自带的字体不太好看，所以采用文泉译微米黑字体替代，效果会比较好，毕竟是国产字体！

   ```
   sudo apt-get install fonts-wqy-microhei1
   ```

   然后通过unity-tweak-tool来替换字体：

   ![替换字体](https://user-gold-cdn.xitu.io/2018/4/28/1630a36e5ba78ef4?w=881&h=651&f=jpeg&s=28315)

3. cairo dock

   TODO

   ​

主题中搜狗 的图标问题：

参考：[Ubuntu技术贴 | Flatabulous主题中显示搜狗拼音托盘图标](https://www.jianshu.com/p/e87ea941e432)

制作svg格式的搜狗输入法图标（可在 /usr/share/icons/hicolor/128x128/apps找到png格式的图标），保存为fcitx-sogoupinyin.svg

不同主题请修改 Ultra-Flat

```
sudo cp fcitx-sogoupinyin.svg /usr/share/icons/Ultra-Flat/apps/scalable1
```



如果你安装了Dock栏想隐藏启动器的话：

在 Unity Tweak Tool 中将启动器 的调用灵敏度设置为 0 ，同时打开自动隐藏

安装完之后请自行使用tweak tool设置开机自启软件: 如 redshift、Albert、某dock 、shadowsocks

#### grub 美化

主题获取： https://www.gnome-look.org/browse/cat/109/ord/top/

**1.下载相应的主题文件到电脑中**

![img](https://user-gold-cdn.xitu.io/2018/4/28/1630a36e61223ce1?w=883&h=315&f=png&s=29692)
然后在`~/Downloads/`里面可以看到下载的主题
![img](https://user-gold-cdn.xitu.io/2018/4/28/1630a36e891e8269?w=173&h=120&f=png&s=3029)
然后执行下面的命令

> 1.现将该压缩包解压，”171217-Breeze-GRUB2.tar.gz”是你下载的压缩包名字
>
> ```
> sudo tar zxf 171217-Breeze-GRUB2.tar.gz
> ```

2.将解压后的文件移动到/boot/grub/themes/ 文件夹中”Breeze-GRUB2”是解压后得到的文件夹

```
sudo mv Breeze-GRUB2/ /boot/grub/themes/
```

**注意:**如果没有themes文件夹，就直接建一个文件夹

```
sudo mkdir /boot/grub/themes
```

如图:![img](https://user-gold-cdn.xitu.io/2018/4/28/1630a36ee1e11257?w=887&h=578&f=png&s=27301)

**2.修改GRUB配置文件并且更新**

打开/etc/grub.d/00_header文件

```
sudo gedit /etc/grub.d/00_header
或者
sudo vim /etc/grub.d/00.header
```

在文件中添加一下内容，如图
![img](https://user-gold-cdn.xitu.io/2018/4/28/1630a36ed07e8657?w=571&h=715&f=png&s=112339)

- 第一行是设置引导界面的字体(可以不设置)
- 第二行是你刚才下载的主题的文件路径
- 第三行是你屏幕分辨率的大小

```
GRUB_FONT="/boot/grub/fonts/unicode.pf2"
GRUB_THEME="/boot/grub/themes/poly/theme.txt"
GRUB_GFXMODE="1366x768*32"
```

**3.更新grub**

```
sudo update-grub
```

然后重启电脑即可看到更改成功。

## 终端篇（可直接复制[我的配置文件](https://github.com/tofar/vim-zsh-tmux)）

1. zsh

   终端采用zsh和oh-my-zsh，既美观又简单易用，主要是能提高你的逼格

   zsh: https://github.com/robbyrussell/oh-my-zsh

   效果：

   1. 安装zsh：

      ```
      sudo apt-get install zsh
      ```

   2. 下载 oh-my-zsh 项目来帮我们配置 zsh

      ```
      sudo wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
      ```

   3. 修改主题

      *Robby's theme is the default one. It's not the fanciest one. It's not the simplest one. It's just the right one (for him).*

      Once you find a theme that you'd like to use, you will need to edit the `~/.zshrc` file. You'll see an environment variable (all caps) in there that looks like:

      ```
      ZSH_THEME="robbyrussell"
      ```

      To use a different theme, simply change the value to match the name of your desired theme. For example:

      ```
      ZSH_THEME="agnoster" # (this is one of the fancy ones)
      # see https://github.com/robbyrussell/oh-my-zsh/wiki/Themes#agnoster

      ```

      *Note: many themes require installing the Powerline Fonts in order to render properly.*

      Open up a new terminal window and your prompt should look something like this:

      [![Agnoster theme](https://user-gold-cdn.xitu.io/2018/4/28/1630a36f313359b6?w=633&h=346&f=png&s=82148)](https://user-gold-cdn.xitu.io/2018/4/28/1630a36f313359b6?w=633&h=346&f=png&s=82148)

      1. ​

   4. 切换到 zsh 模式

      ```
      chsh -s /bin/zsh
      ```

   5. 修改配色

      ![img](https://user-gold-cdn.xitu.io/2018/4/28/1630a36f5cdb5875?w=600&h=413&f=png&s=41746)

      其中，文字和背景采用系统主题，透明度设为10%，下面的palette样式采用Tango

2. fish

   github: https://github.com/oh-my-fish/oh-my-fish

   1. 安装fish

      Ubuntu 安装fish 并且设为默认shell

      ```
      sudo apt install fish
      chsh -s $(which fish)

      ```

      **解释:**

      chsh -s 后面加路径 ： 设置当前用户默认shell
      which fish ：查看fish程序的路径
      chsh -s $(which fish) : 设置fish为当前用户默认shell

   2. 安装oh my fish

      ```
      curl -L https://github.com/bpinto/oh-my-fish/raw/master/tools/install.sh | sh
      ```

      theme: https://github.com/oh-my-fish/oh-my-fish/blob/master/docs/Themes.md
      个人使用： robbyrussell

## Vim篇

https://github.com/amix/vimrc
