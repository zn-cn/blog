---
title: Sublime 配置
date: 2017-12-31 14:59:25
tags: 
	- 工具
	- sublime
	- config
categories: 
	- 工具
---

- Sublime Text：学习资源篇](https://www.jianshu.com/p/d1b9a64e2e37)
- [Sublime插件：增强篇](https://www.jianshu.com/p/5905f927d01b)
- [Sublime插件：Markdown篇](https://www.jianshu.com/p/aa30cc25c91b)
- [Sublime插件：C语言篇](https://www.jianshu.com/p/595975a2a5f3)
- [Sublime插件：主题篇](https://www.jianshu.com/p/13fedee165f1)
- [Sublime插件：Git篇](https://www.jianshu.com/p/3a8555c273d8)
- [Sublime 小技巧：文本自动换行显示？](https://www.jianshu.com/p/c75d21d2e967)

sublime-settings - User 基本配置: 

```
{
    "font_size": 12,
    "ignored_packages":
    [
        "Vintage"
    ],
    "font_face": "Consolas",
    // 设置tab的大小为4
    "tab_size": 4,
    // 使用空格代替tab
    "translate_tabs_to_spaces": true,
    "font_face": "YaHei Consolas Hybrid", //需要先安装字体，解决中文，英文不在一行问题
    "save_on_focus_lost": true,     // 失去光标自动保存
    // 添加行宽标尺
    "rulers": [80, 100],
    // 显示空白字符
    "draw_white_space": "all",
    // 保存时自动去除行末空白
    "trim_trailing_white_space_on_save": true,
    // 保存时自动增加文件末尾换行
    "ensure_newline_at_eof_on_save": true,
    // 默认编码格式
    "default_encoding": "UTF-8",
    "update_check": false,   // 不检查更新
// 这个会把光标的样式从闪烁变成淡入淡出，其余的选项还有“smooth”, “phase”, “blink”, “wide”， “solid”.
	"caret_style": "phase",
	// 高亮当前行
	"highlight_line": true,
	// 增加行间距
    "line_padding_bottom": 1,
    "line_padding_top": 1,
    // 一直现在代码折叠箭头
    "fade_fold_buttons": false,
    "word_wrap": true,
}
```

sublime 自带格式化：

```
[
	{"keys": ["ctrl+alt+l"], "command": "reindent" , "args":
    {"single_line": false}},
]
```



#### sublime 中文解决方案

+ 下载需要的文件

  ```
  git clone https://github.com/lyfeyaj/sublime-text-imfix.git
  ```

+ 2.将subl移动到/usr/bin/，并且将sublime-imfix.so移动到/opt/sublime_text/（sublime的安装目录）

  ```
  cd ~/sublime-text-imfix
  sudo cp ./lib/libsublime-imfix.so /opt/sublime_text/
  sudo cp ./src/subl /usr/bin/
  ```

+ 用subl命令试试能不能启动sublime，如果成功启动的话，应该就可以输入中文了。

  终端输入：

  ```
  LD_PRELOAD=./libsublime-imfix.so subl
  ```

注：`如果不在终端中输入**subl**则无法输入中文，即要想输入中文则必须使用subl命令在终端中打开sublime`

> 如果想点击sublime图标启动也能输入中文的话，则只需将 sublime 相应的 .desktop文件 中的 Exec那一行修改为
> `Exec=subl` 即可 （.desktop文件一般位置 `/usr/share/applications/` 和 `~/.local/share/applications/`）

###　主题篇

Sublime Text 是一个轻量、简洁、高效、跨平台的编辑器。有些人会认为变更Sublime Text的皮肤是一件浪费时间的事情，但也许你没想过，一个漂亮的主题会提高你的工作效率。下面这9款主题都能让你的编辑器里的代码具有不同的配色效果。

1. Spacegray

![Best sublime text 2 and 3 theme for 2014 1](http://upload-images.jianshu.io/upload_images/7109326-3279b3bb9aeb1c35.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   一个最小化的设计可以帮你把注意力放在编写代码上，该主题在 UI 上没什么吸引人之处，但很适合编码。

2. [Solarized](http://ethanschoonover.com/solarized)

![Best sublime text 2 and 3 theme for 2014 2](http://upload-images.jianshu.io/upload_images/7109326-bbe350b21860e1f3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   非常精确的颜色设置，这些颜色在不同的设备和不同的亮度环境下测试过。

3. [Glacier](http://glaciertheme.com/)

![Best sublime text 2 and 3 theme for 2014 3](http://upload-images.jianshu.io/upload_images/7109326-6dcc6a40546e3d58.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   颜色很丰富，使用流行的扁平设计风格。

4. [Predawn](http://jamiewilson.io/predawn/)

![Best sublime text 2 and 3 theme for 2014 4](http://upload-images.jianshu.io/upload_images/7109326-fdd642f475d6a20d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   Predawn 非常漂亮，特别适合编写代码。

5. [Flatland](https://github.com/thinkpixellab/flatland)

![Best sublime text 2 and 3 theme for 2014 5](http://upload-images.jianshu.io/upload_images/7109326-6c910a237073ec0e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   Flatland 是一个基于 Soda 构建的 Sublime Text 主题，看起来不错。

6. [Tron Legacy](https://github.com/daylerees/colour-schemes/blob/master/sublime/legacy.tmTheme)

![Best sublime text 2 and 3 theme for 2014 6](http://upload-images.jianshu.io/upload_images/7109326-ce43d30147ab3bba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   Tron 电影迷们可能会喜欢这一款主题，因为颜色相似。

7. [ITG:Flat](http://itsthatguy.com/post/70191573560/sublime-text-theme-itg-flat)

![Best sublime text 2 and 3 theme for 2014 7](http://upload-images.jianshu.io/upload_images/7109326-b6af410635f6c029.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   另外一个扁平化设计风格主题。

8. [Tomorrow Theme](https://github.com/chriskempson/tomorrow-theme)

![Best sublime text 2 and 3 theme for 2014 8](http://upload-images.jianshu.io/upload_images/7109326-b79089b6f9273cea.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   Tomorrow 主题颜色丰富，有着强烈的对比。

9. [Brogrammar](https://github.com/kenwheeler/brogrammer-theme)

   自带多种主题风格，可以融合[ihodev/sublime-file-icons](https://link.zhihu.com/?target=https%3A//github.com/ihodev/sublime-file-icons)；

![Best sublime text 2 and 3 theme for 2014 9](http://upload-images.jianshu.io/upload_images/7109326-32fc41650a833d50.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   扁平而且性感的设计。

10. Boxy

  ![img](http://upload-images.jianshu.io/upload_images/7109326-8269fd72b9b7fc6e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 插件篇

1. Sublime Package Control

   - 打开 Sublime Text 3，按下`Control + '`调出 Console。

   - 将以下代码粘贴进命令行中并回车:

     ```
     import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())

     ```

   - Sublime Text 2 请使用以下代码：

     ```
     import urllib2,os; pf='Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler( ))); open( os.path.join( ipp, pf), 'wb' ).write( urllib2.urlopen( 'http://sublime.wbond.net/' +pf.replace( ' ','%20' )).read()); print( 'Please restart Sublime Text to finish installation')

     ```

   - 重启 Sublime Text 3，如果在 `Preferences -> Package Settings`中见到`Package Control`这一项，就说明安装成功了。

     通过Package Control 来安装插件：

   - 按下`Shift + Command + P`调出命令面板。
   - 输入install调出`Package Control: Install Package`选项，按下回车。
   - 输入插件名称并回车，稍等几秒就安装好了，有的插件可能需要重启Sublime Text才能激活。


2. [DocBlockr](https://link.jianshu.com/?t=https://github.com/spadgos/sublime-jsdocs)：自动`生成大块的注释，并且可以用**tab**在不同内容之间切换，很爽的`

   ![img](http://upload-images.jianshu.io/upload_images/26219-318ce98c56fdfe18.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/521)

   ​                                  `用**tab**在参数之间平滑切换`

   ![img](http://upload-images.jianshu.io/upload_images/26219-9a58baaa98020b35.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/521)

   **注**：安装完重启一下，否则可能效果不理想，比如`tab`跳到别的地方去了

3. [SublimeAStyleFormatter](https://link.jianshu.com/?t=http://theo.im/SublimeAStyleFormatter/)：国人做的Astyle Sublime版，蛮不错的。

   安装完成之后，下面这个配置一定要打开，即保存自动格式化，这个相比于CoolFormat要简单很多。

   settings - user（default也行）：

   ```
   // Auto format on file save
       "autoformat_on_save": true,
   ```

4. SideBarEnhancements

   SideBarEnhancements 是一款很实用的右键菜单增强插件，有以 diff 形式式显示未保存的修改、在文件管理器中显示该文件、复制文件路径、在侧边栏中定位该文件等功能，也有基础的诸如新建文件/目录，编辑，打开/运行，显示，在选择中/上级目录/项目中查找，剪切，复制，粘贴，重命名，删除，刷新等常见功能。

   ![img](http://upload-images.jianshu.io/upload_images/7109326-55c16b382dfc0437.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

5. [ConvertToUTF8](https://link.jianshu.com/?t=https://github.com/seanliang/ConvertToUTF8)

   通过本插件，您可以编辑并保存目前编码不被 Sublime Text 支持的文件，特别是中日韩用户使用的 GB2312，GBK，BIG5，EUC-KR，EUC-JP 等。ConvertToUTF8 同时支持 Sublime Text 2 和 3。

6. [Terminal](https://link.jianshu.com/?t=https://github.com/wbond/sublime_terminal)

   这个插件可以让你在Sublime中直接使用终端打开你的项目文件夹，并支持使用快捷键`Ctrl + Shift + T`（不是 Ctrl  + Alt + T）。

7. [Git](https://link.jianshu.com/?t=https://sublime.wbond.net/packages/Git)

   将Git整合进你的SublimeText，使的你可以在SublimeText中运行Git命令，包括添加，提交文件，查看日志，文件注解以及其它Git功能。

8. [BracketHighlighter](https://link.jianshu.com/?t=https://sublime.wbond.net/packages/BracketHighlighter)

   可以使括号**高亮匹配**，这个需要自己来配置配色方案。我的配置方案见最后（Bracket settings-User和主题文件Monokai Extended.sublime-package添加的代码）。

   Bracket settings-User

   ```
   {
           "bracket_styles": {
               // This particular style is used to highlight
               // unmatched bracket pairs. It is a special
               // style.
               "unmatched": {
                   "icon": "question",
                   "color": "brackethighlighter.unmatched",
                   "style": "highlight"
               },
               // User defined region styles
               "curly": {
                   "icon": "curly_bracket",
                   "color": "brackethighlighter.curly",
                   "style": "highlight"
               },
               "round": {
                   "icon": "round_bracket",
                   "color": "brackethighlighter.round",
                   "style": "outline"
               },
               "square": {
                   "icon": "square_bracket",
                   "color": "brackethighlighter.square",
                   "style": "outline"
               },
               "angle": {
                   "icon": "angle_bracket",
                   "color": "brackethighlighter.angle",
                   "style": "outline"
               },
               "tag": {
                   "icon": "tag",
                   "color": "brackethighlighter.tag",
                   "style": "outline"
               },
               "single_quote": {
                   "icon": "single_quote",
                   "color": "brackethighlighter.quote",
                   "style": "outline"
               },
               "double_quote": {
                   "icon": "double_quote",
                   "color": "brackethighlighter.quote",
                   "style": "outline"
               },
               "regex": {
                   "icon": "regex",
                   "color": "brackethighlighter.quote",
                   "style": "outline"
               }
         }
   }
   ```

9. [Monokai Extended](https://link.jianshu.com/?t=https://github.com/jonschlinkert/sublime-monokai-extended)

   比较喜欢Soda Dark和Monokai，这里有Monokai Extended。这个 color scheme 是 Monokai Soda 的增强。如果再配合 Markdown Extended，将大大改善 Markdown 的语法高亮。

   Monokai Extended.sublime-package添加的代码

   ```
   <!-- BEGIN Bracket Highlighter plugin color modifications -->
   <dict>
       <key>name</key>
       <string>Bracket Default</string>
       <key>scope</key>
       <string>brackethighlighter.default</string>
       <key>settings</key>
       <dict>
           <key>foreground</key>
           <string>#FFFFFF</string>
           <key>background</key>
           <string>#A6E22E</string>
       </dict>
   </dict>

   <dict>
       <key>name</key>
       <string>Bracket Unmatched</string>
       <key>scope</key>
       <string>brackethighlighter.unmatched</string>
       <key>settings</key>
       <dict>
           <key>foreground</key>
           <string>#FFFFFF</string>
           <key>background</key>
           <string>#FF0000</string>
       </dict>
   </dict>

   <dict>
       <key>name</key>
       <string>Bracket Curly</string>
       <key>scope</key>
       <string>brackethighlighter.curly</string>
       <key>settings</key>
       <dict>
           <key>foreground</key>
           <string>#FF00FF</string>
       </dict>
   </dict>

   <dict>
       <key>name</key>
       <string>Bracket Round</string>
       <key>scope</key>
       <string>brackethighlighter.round</string>
       <key>settings</key>
       <dict>
           <key>foreground</key>
           <string>#E7FF04</string>
       </dict>
   </dict>

   <dict>
       <key>name</key>
       <string>Bracket Square</string>
       <key>scope</key>
       <string>brackethighlighter.square</string>
       <key>settings</key>
       <dict>
           <key>foreground</key>
           <string>#FE4800</string>
       </dict>
   </dict>

   <dict>
       <key>name</key>
       <string>Bracket Angle</string>
       <key>scope</key>
       <string>brackethighlighter.angle</string>
       <key>settings</key>
       <dict>
           <key>foreground</key>
           <string>#02F78E</string>
       </dict>
   </dict>

   <dict>
       <key>name</key>
       <string>Bracket Tag</string>
       <key>scope</key>
       <string>brackethighlighter.tag</string>
       <key>settings</key>
       <dict>
           <key>foreground</key>
           <string>#FFFFFF</string>
           <key>background</key>
           <string>#0080FF</string>
       </dict>
   </dict>

   <dict>
       <key>name</key>
       <string>Bracket Quote</string>
       <key>scope</key>
       <string>brackethighlighter.quote</string>
       <key>settings</key>
       <dict>
           <key>foreground</key>
           <string>#56FF00</string>
       </dict>
   </dict>
   <!-- END Bracket Highlighter plugin color modifications -->
   ```

10. [Anaconda](http://damnwidget.github.io/anaconda/)

  settings: 

  ```
  {
      "pep8_ignore": ["E501", "W292", "E303", "W391", "E225", "E302", "W293", "E402"],
      "pyflakes_explicit_ignore":
      [
          "UnusedImport"
      ],
      "auto_formatting": true,
      "enable_signatures_tooltip": true,
      "merge_signatures_and_doc":true,
      "anaconda_linting": false,
  }
  ```

