[超赞的Linux软件](https://alim0x.gitbooks.io/awesome-linux-software-zh_cn/content/)

[16 Things To Do After Installing Ubuntu 16.04 LTS](http://www.omgubuntu.co.uk/2016/04/10-things-to-do-after-installing-ubuntu-16-04-lts)

## 系统清理篇

1. 系统更新

   `sudo apt-get update `
   `sudo apt-get upgrade`

2. 卸载libreOffice

   ibreoffice是ubuntu自带的开源office软件，体验效果不如windows上的office，于是选择用WPS来替代。（安装WPS见安装篇）

   ```
   sudo apt-get purge libreoffice?
   或
   sudo aptitude purge libreoffice?
   不要漏掉通配符“?”，否则无法清除/卸载全部 LibreOffice 软件包
   或
   sudo apt-get remove --purge libreoffice*
   ```


3. 删除不常用软件

   删除Amazon的链接

   `sudo apt-get remove unity-webapps-common `

   ```
   sudo apt-get remove thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot 
   sudo apt-get remove gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku  landscape-client-ui-install  
   sudo apt-get remove onboard deja-dup 
   ```

## 安装篇

1. 安装wps

   [wps下载](http://community.wps.cn/download/) 

   安装： `sudo dpkg -i  kingsoft-office_9.1.0.4280~a12p4_i386.deb`

   如果有依赖故障 修复依赖: `sudo apt-get   install  -f`

   之后可以在**模板**文件夹中分别新建一个Excel，Word，PPT模板，这样可以在 右键菜单中直接新建文档。

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

   ![drivers](http://upload-images.jianshu.io/upload_images/7109326-bb3a0003012aee21.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   Install GPU drivers

   Ubuntu supports most Nvidia and Intel graphics hardware out of the box, giving you a choice of free, open-source drivers or proprietary, closed-source drivers.

   But to **get the best performance from your Ubuntu PC**you will want to use the latest *proprietary* graphics drivers available for your hardware.

   Ubuntu makes it easy to do this, and you benefit from a smoother Unity desktop experience as a result.  You’ll squeeze higher frame rates out of your favourite games, too. ;)

   If you plan to **play the latest Steam games on Ubuntu **or use GPU heavy apps like Blender you should install the latest proprietary Linux graphics drivers available for your hardware.

   To do this:

   1. **Open up the ‘Software & Updates’ tool from the Unity Dash**
   2. **Click the ‘Additional Drivers’ tab**
   3. **Follow any on-screen prompts to check for, install and apply any changes **

   Gamers using Nvidia hardware who are willing to trade a bit of stability for a whole lot of newness can use the [Nvidia Graphics PPA](http://www.omgubuntu.co.uk/2015/08/ubuntu-nvidia-graphics-drivers-ppa-is-ready-for-action) to install newer Nvidia Linux graphics drivers.

3. Install Media Codecs

   ![rythmbox-in-ubuntu](http://upload-images.jianshu.io/upload_images/7109326-2b547e55dc399967.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   Playing MP3s in Rhythmbox

   Legal issues stop Ubuntu from being able to play MP3, MP4 and other media files ‘out of the box’.

   Ubuntu can play your audio and video files, you just have to tell it to do so.

   The easiest way to do this is to check (tick) the ‘*Enable Restricted Formats*‘ box during installation. This will install all the required multimedia codecs automatically, along with the OS itself.

   If you forgot to do that (or upgrade from an earlier release) you can install the multimedia codecs manually via the Software app:

   [Install Ubuntu Restricted Extras](apt://ubuntu-restricted-extras)

4. 鼠标点击最小化

   [![unity launcher](http://upload-images.jianshu.io/upload_images/7109326-24c1c335e9de19d3.gif?imageMogr2/auto-orient/strip)](http://www.omgubuntu.co.uk/wp-content/uploads/2016/04/unity-launcher.gif)

   Click on an app launcher icon to open an app. Click on the same icon again to minimise the app. Intuitive, right?

   That may be, but it is not the default behaviour in Unity — which can be off-putting to new users. It’s also not obvious how to enable it.

   Run the following command (or install/use Unity Tweak Tool > Unity > Launcher > Minimise):

   ```
   gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true
   ```

5. 移动Unitty启动器位置

   [![2016-04-06 20_25_32](http://upload-images.jianshu.io/upload_images/7109326-70de6b4ddccabb37.gif?imageMogr2/auto-orient/strip)](http://www.omgubuntu.co.uk/wp-content/uploads/2016/04/2016-04-06-20_25_32.gif)

   Ubuntu positions its app launcher on the left-hand side of the desktop by default.

   Ubuntu 16.04 finally lets you **choose where the Unity launcher is positioned.**

   If you want to move the Unity launcher to the bottom of the screen run the following command in a new Terminal (or install/use Unity Tweak Tool > Unity > Launcher > Position):

   ```
   gsettings set com.canonical.Unity.Launcher launcher-position Bottom
   ```

6. Adobe Flash on Linux

   Flash sucks, but for some sites you may not have the option of not using it.

   [Adobe officially stopped supporting Flash on Linux](http://www.omgubuntu.co.uk/2012/02/adobe-adandons-flash-on-linux) in 2012 and many web browsers are in the process of dropping support for its NPAPI architecture.

   The overall best solution for using Flash on Linux is to download and use Google Chrome. Chrome comes with an**up-to-date version of the Flash plugin** built-in. In fact it’s the only way to get the latest Flash player updates on Linux — and it’s a PPAPI plugin, too.

   But I appreciate that not everyone wants to use Chrome. Some of you may be using a 32-bit version of Ubuntu, which Chrome no longer supports. Whatever the reason you need it, here’s how to get it:

   [Install Flash Player Plugin](apt://flashplugin-installer)

   If you want to watch Amazon Instant Video, Hulu or any other sites that uses DRM through HAL, [we’ve got a guide on that.](http://www.omgubuntu.co.uk/2015/09/how-to-watch-hulu-on-ubuntu-1404-up)

7. 垃圾清理软件

   Caches and cruft accumulate as you use Ubuntu. To **keep your fresh install feeling, well, fresh** you should do a bit of basic housekeeping from time to time.

   [![bleachbit running on ubuntu 16.04](http://upload-images.jianshu.io/upload_images/7109326-6ede88fd49aac048.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)](http://www.omgubuntu.co.uk/wp-content/uploads/2016/04/bleachbit-system-cleaner-app-on-ubuntu.jpg)

   One of my favourite system cleaning apps is **BleachBit** (free, open source). BleachBit can tackle menial tasks, from clearing your browser’s cache to deleting packages left over from installation, all at the push of a button.

   If you upgrade from an earlier version of Ubuntu using a system cleaning tool (or command) is a foolproof way to claw back some precious space. You’ll also keep your system running lean ‘n mean — which is always bonus!

   Just be careful about what you clean: **don’t remove anything you’re unsure of**.

   [Install BleachBit on Ubuntu](apt://bleachbit)

8. sublime text

   https://github.com/Tofar/sublime-plugs

9. 搜狗输入法

10. vim

  https://github.com/Tofar/vimrc

11. redshift （护眼软件）

    ```
    sudo apt-get update
    sudo apt-get install redshift gtk-redshift
    ```

    ![img](http://upload-images.jianshu.io/upload_images/7109326-f70eb641fb0510fe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    [redshift docs](http://jonls.dk/redshift/)

    ​

    其他：**flux**

    f.lux是一款优秀的应用，支持win/Mac OS/Linux，在linux下安装：

    ```
    sudo add-apt-repository ppa:kilian/f.lux
    sudo apt-get update
    sudo apt-get install fluxgui

    ```

    在搜索框搜索`flux`会看到下面这样的图标：

    ![img](http://upload-images.jianshu.io/upload_images/7109326-496ca2a993e3b674.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    第一次打开会弹出来设置窗口：

    ![img](http://upload-images.jianshu.io/upload_images/7109326-f0b4e448210a401a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    这里只需要输入经纬度就行，如果不了解自己的经纬度，[点击这里查看自己城市的经纬度](http://www.latlong.net/)

    但是这里遇到一个问题，flux在ubuntu14.04和12.04下无法`重新设置配置`或者`经常不起作用`，详情见[ask ubuntu](http://askubuntu.com/questions/151901/how-can-i-get-f-lux-working)

    所以个人推荐`redshift`

12. 网易云音乐

13. postman
