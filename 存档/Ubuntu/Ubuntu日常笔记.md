1. 删除Ubuntu Linux旧内核的方法

   用Ubuntu一段时间后，就会发觉由于自动升级，系统里安装了很多内核。像我，竟然安装了下面那么多，这个造成了漫长的启动列表。必须删掉一些不用的。

   首先就是使用如下命令，列出所有安装的内核，下表中，带有image的就是内核文件。从中选择要卸载的包，用apt-get来卸载

   **具体如下:**

   ```
   dpkg --get-selections|grep linux
   sudo apt-get remove linux-image-2.6.24-16-generic   
   sudo apt-get remove linux-headers-2.6.24-16-generic 
   ```

   查看当前系统使用的内核: `uname -a`

2. Windows 10和Ubuntu 16.04双系统时间错误的调整

   **原因：**

   ​       如果安装了 Windows 和 Linux（比如 Ubuntu）双系统，有时会出现两个系统的时间不一致的情况。这是因为，两个操作系统对电脑硬件时间的定义不一样，**Windows 认为电脑硬件时间是“本地时间”**，因此它启动后直接用该时间作为“系统时间”并显示在桌面右下角的系统托盘里；而**Ubuntu 等 Linux 发行版则认为电脑硬件时间是“全球统一时间”（即 UTC)**，它在启动后在该时间的基础上，再加上电脑设置的时区数（比如我们在中国，它就加上“8”）。根据获得的资料得知，两种模式各有利弊，但是后一种模式在遇到时区转换、夏令时等情况时，通用性更强。

   **解决方案：**

   ​       基于上述原因，协调 Win/Lin 双系统时间一致的方法，就是让 Windows 也和 Linux 一样，将电脑硬件时间看作“全球统一时间”。

   **具体：**

   1. 在win10中打开**regedit** （在小娜下搜索即可）

   2. 桌面上将出现“注册表编辑器”的窗口，在以下的操作中，将对窗口左侧列表中的 **HKEY_LOCAL_MACHINE** 这一分支进行操作。

      ![Windows 10和Ubuntu 16.04双系统时间错误的调整](http://upload-images.jianshu.io/upload_images/7109326-88169d13dc26e4e4.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   3. 点击展开 HKEY_LOCAL_MACHINE 分支，然后依次导航到以下位置：

      `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation`

      ![Windows 10和Ubuntu 16.04双系统时间错误的调整](http://upload-images.jianshu.io/upload_images/7109326-d2f54cd798f01115.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   4. 在右侧空白处单击鼠标右键，然后依次点击“新建”——“QWORD（64位）值”。

      如果安装的是 32 位系统，则需要新建“DWORD（32位）值”。

      ![Windows 10和Ubuntu 16.04双系统时间错误的调整](http://upload-images.jianshu.io/upload_images/7109326-647b4a79e89f0d4f.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   5. 当前位置将会出现一个新建的键值的条目，将其“名称”改为：

      **RealTimeIsUniversal**

      它的大体意思是，硬件时间被作为全球统一时间。

      ![Windows 10和Ubuntu 16.04双系统时间错误的调整](http://upload-images.jianshu.io/upload_images/7109326-2b6fd89a4536d2e0.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   6. 然后双击这一条目，弹出“编辑 QWORD（64位）值”的对话框，确保选中了“十六进制”，然后将“数值数据”改为“1”。最后点击“确定”。

      ![Windows 10和Ubuntu 16.04双系统时间错误的调整](http://upload-images.jianshu.io/upload_images/7109326-5b52a3899cdd1c11.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3. Ubuntu截图快捷键

   无须安装如何软件，直接使用Ubuntu自带的快捷键即可满足基本需求

   [图片上传失败...(image-e8273-1513497539752)]

4. [Ubuntu 更新错误修复大全](https://linux.cn/article-5603-1.html)

5. [的一些命令及查看已安装软件包的命令](http://cheneyph.iteye.com/blog/824746)

6. [ubuntu服务器与本地文件传输](http://www.cnblogs.com/by-1075324834/p/5045096.html)
