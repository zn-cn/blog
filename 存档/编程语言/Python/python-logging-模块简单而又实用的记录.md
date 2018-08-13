**转自** [关于 logging 的一些琐事](http://www.keakon.net/2013/02/21/%E5%85%B3%E4%BA%8Elogging%E7%9A%84%E4%B8%80%E4%BA%9B%E7%90%90%E4%BA%8B)

### 1. 为什么logging.info()默认不输出

因为默认生成的 root logger 的 level 是 logging.WARNING，低于该级别的就不输出了。可以进行如下设置来输出：

```
>>> import logging
>>> logging.info('test')
>>> root_logger = logging.getLogger()  # 或使用未公开的 logging.root
>>> root_logger.level
30
>>> logging.getLevelName(30)
'WARNING'
>>> root_logger.level = logging.NOTSET
>>> logging.info('test')
INFO:root:test
```

如果还没配置 handler 的话，可以用 logging.basicConfig() 来配置：

```
>>> root_logger.handlers
[]
>>> logging.basicConfig(level=logging.NOTSET)
>>> root_logger.handlers
[<logging.StreamHandler object at 0x108becd10>]
>>> logging.info('test')
INFO:root:test
```

### 2. 如何指定输出格式

给 logger 的 handler 设置一个 logging.Formatter 对象：

```
>>> root_logger.handlers[0].formatter.format
<bound method Formatter.format of <logging.Formatter object at 0x10c062d90>>
>>> root_logger.handlers[0].formatter.datefmt
>>> root_logger.handlers[0].formatter._fmt
'%(levelname)s:%(name)s:%(message)s'
>>> LOGGING_FORMAT = '[%(levelname)1.1s %(asctime)s %(module)s:%(lineno)d] %(message)s'
>>> DATE_FORMAT = '%y%m%d %H:%M:%S'
>>> formatter = logging.Formatter(LOGGING_FORMAT, DATE_FORMAT)
>>> root_logger.handlers[0].formatter = formatter
>>> logging.info('test')
[I 130221 01:58:28 <stdin>:1] test
```

如果还没配置 handler 的话，可以用 logging.basicConfig() 来配置：

```
logging.basicConfig(
    level=logging.NOTSET,
    format=LOGGING_FORMAT,
    datefmt=DATE_FORMAT
)
```

详细的格式介绍就查看[文档](http://docs.python.org/2/library/logging.html#logrecord-attributes)吧。

### 3. 为什么我重定向了stdout却看不到输出

因为默认生成的 root logger 的 handler 的 stream 是 stderr，不是 stdout：

```
>>> root_logger.handlers[0].stream
<open file '<stderr>', mode 'w' at 0x1089cb270>
```

可以如下分别配置：

```
stdout_handler = logging.StreamHandler(sys.__stdout__)
stdout_handler.level = logging.DEBUG
stdout_handler.formatter = formatter
root_logger.addHandler(stdout_handler)

stderr_handler = logging.StreamHandler(sys.__stderr__)
stderr_handler.level = logging.WARNING
stderr_handler.formatter = formatter
root_logger.addHandler(stderr_handler)
```

### 4. 如何将日志输出到文件

使用 logging.FileHandler()：

```
handler = logging.FileHandler('log/test.log')
root_logger.addHandler(handler)
```

其中文件名可以使用相对路径，但要保证文件夹存在。默认的文件打开方式是 append。 如果还没配置 handler 的话，可以用 logging.basicConfig() 来配置：

```
logging.basicConfig(
    level=logging.NOTSET,
    format=LOGGING_FORMAT,
    datefmt=DATE_FORMAT,
    filename='log/test.log',
    filemode='a'
)
```

### 5. 捕捉了一个异常，如何输出执行堆栈？

使用 logging.exception()，或在调用 logging.debug() 等方法时加上 exc_info=True 参数。

```
>>> try:
...     0 / 0
... except:
...     logging.exception('Catch an exception.')
...     print '-' * 10
...     logging.warning('Catch an exception.', exc_info=True)
... 
ERROR:root:Catch an exception.
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
ZeroDivisionError: integer division or modulo by zero
----------
WARNING:root:Catch an exception.
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
ZeroDivisionError: integer division or modulo by zero
```

### 6. 如何针对不同的模块，输出到不同的日志

可以创建多个 logger：

```
console_handler = logging.StreamHandler(sys. __stdout__)
console_handler.level = logging.DEBUG
console_logger = logging.getLogger('test')
console_logger.addHandler(console_handler)

file_handler = logging.FileHandler('log/test.log')
file_handler.level = logging.WARNING
file_logger = logging.getLogger('test.file')
file_logger.addHandler(file_handler)

console_logger.error('test')
file_logger.error('test')

console_logger.parent is root_logger
file_logger.parent is console_logger
console_logger.getChild('file') is file_logger
```

每个 logger 都有个名字，以 ‘.’ 来划分继承关系。名字为空的就是 root_logger，console_logger 的名字是 ‘test’，因此 root_logger 是 console_logger 的 parent；而 file_logger 的名字是 ‘test.file’，因此 console_logger 是 file_logger 的 parent。 如果 logger 的 propagate 属性为 True（默认值），则它的记录也会传到父 logger。因此，file_logger 在记录到文件的同时，也会在 stdout 输出日志。 建议每个模块都用自己的 logger。

### 7. 如何指定某些日志不输出

使用 logging.Filter 来过滤记录：

```
mport logging
import random


class OddFilter(logging.Filter):
    def __init__(self):
        self.count = 0

    def filter(self, record):
        self.count += 1
        if record.args[0] & 1:
            record.count = self.count  # 给 record 增加了 count 属性
            return True  # 为 True 的记录才输出
        return False


root_logger = logging.getLogger()
logging.basicConfig(level=logging.NOTSET, format='%(message)s (total: %(count)d)')  # 可以使用 record.count 来格式化
root_logger.level = logging.NOTSET
root_logger.addFilter(OddFilter())

for i in xrange(100):
    logging.error('number: %d', random.randint(0, 1000))
```

### 8. 大文件分割

可以使用 logging.handlers.RotatingFileHandler 和 logging.handlers.TimedRotatingFileHandler。前者按文件大小来分割，后者按时间来分割。 它们会在达到分割条件时（文件达到指定大小或达到指定时间），把当前的日志重命名为备份文件，然后再打开新文件来记录。 值得一提的是，如果备份文件名已存在，就会被删除。所以在多进程时不建议使用。我是将日志输出到 stdout 和 stderr，再用 supervisor 来分割日志。 此外还有一些没考虑到的特殊情况，建议使用前读读源码，然后自行实现。
