---
title: effective python 学习笔记
date: 2018-4-31 14:59:45
tags: 
	- Python
	- effective
        - 学习笔记
categories: 
	- Python
---
*人生苦短我用 Python*

*注：最后附电子书地址*

## 一、Pythonic Thinking

### 第1条: 确认自己所用的Python版本

- 使用python -version查看当前Python版本
- Python的运行时版本：CPython，JyPython，IronPython和PyPy等
- 优先考虑使用 Python 3

### 第2条: 遵循PEP 8 风格指南 

PEP 8：http://www.python.org/dev/peps/pep-0008/

PEP 8：http://www.python.org/dev/peps/pep-0008/

#### 空白:

- 不要使用 tab 缩进，使用空格来缩进
- 使用四个空格缩进，使用四个空格对长表达式换行缩进
- 每行的字符数不应该超过 79
- class和funciton之间用两个空行，class的method之间用一个空行
- list索引和函数调用，关键字参数赋值不要在两旁加空格
- 变量赋值前后都用一个空格

#### 命名

- 函数，变量以及属性应该使用小写，如果有多个单词推荐使用下划线进行连接，如lowercase_underscore
-  **被保护** 的属性应该使用 **单个** 前导下划线来声明。
-  **私有** 的属性应该使用 **两个** 前导下划线来进行声明。
-  **类以及异常信息** 应该使用单词 **首字母大写** 形式，也就是我们经常使用的驼峰命名法，如CapitalizedWord。
-  **模块级** 别的常量应该使用 **全部大写** 的形式, 如ALL_CAPS。
- 类内部的实例方法的应该将`self`作为其第一个参数。且`self`也是对当前类对象的引用。
- 类方法应该使用`cls`来作为其第一个参数。且`self`引用自当前类。

#### 表达式和语句( **Python之禅： 每件事都应该有直白的做法，而且最好只有一种** )

- 使用内联否定（如 `if a is not b`） 而不是显示的表达式（如`if not a is b`）。
- 不要简单地通过变量的长度（`if len(somelist) == 0`）来判断空值。使用隐式的方式如来假设空值的情况（如`if not somelist` 与 `False`来进行比较）。
- 上面的第二条也适用于非空值（如`[1]`,或者'hi'）。对这些非空值而言 `if somelist`默认包含隐式的`True`。
- 避免将`if` , `for`, `while`, `except`等包含多个语块的表达式写在一行内，应该分割成多行。
- 总是把`import`语句写在`Python`文件的顶部。
- 当引用一个模块的时候使用绝对的模块名称，而不是与当前模块路径相关的名称。例如要想引入`bar`包下面的`foo`模块，应该使用`from bar import foo`而不是`import foo`。
- 如果非要相对的引用，应该使用明确的语法`from . import foo`。
- 按照以下规则引入模块：标准库，第三方库，你自己的库。每一个部分内部也应该按照字母顺序来引入。

### 第3条: 了解 bytes、str与 unicode 的区别

#### 备忘录：

- Python3 两种字符串类型：bytes和str，bytes表示8-bit的二进制值，str表示unicode字符
- Python2 两种字符串类型：str和unicode，str表示8-bit的二进制值，unicode表示unicode字符
- 从文件中读取或者写入二进制数据时，总应该使用 'rb' 或 'wb' 等二进制模式来开启文件

​      `Python3`中的`str`实例和`Python2`中的`unicode`实例并没有相关联的二进制编码。所以要想将`Unicode`字符转换成二进制数据，就必须使用`encode`方法，反过来，要想把二进制数据转换成`Unicode`字符，就必须使用`decode`方法。

​      当你开始写`Python`程序的时候，在接口的最开始位置声明对`Unicode`的编码解码的细节很重要。在你的代码中，最核心的部分应使用`Unicode`字符类型（`Python3`中使用`str`,`Python2`中使用`unicode`）并且不应该考虑关于字符编码的任何其他方式。本文允许你使用自己喜欢的可替代性的文本编码方式（如`Latin-1`,`Shift JIS`, `Big5`），但是应该对你的文本输出编码严格的限定一下（理想的方式是使用`UTF-8`编码）。

由于字符类型的不同，导致了Python代码中出现了两种常见的情形的发生。

- 你想操作`UTF-8`（或者其他的编码方式）编码的8比特值 序列。

- 你想操作没有特定编码的`Unicode`字符。 所以你通常会需要两个工具函数来对这两种情况的字符进行转换，以此来确保输入值符合代码所预期的字符类型。

- 二进制值和unicode字符需要经过encode和decode转换，Python2的unicode和Python3的str没有关联二进制编码，通常使用UTF-8

- Python2转换函数：

  - to_unicode

    ```python
    # Python 2
    def to_unicode(unicode_or_str):
        if isinstance(unicode_or_str, str):
            value = unicode_or_str.decode('utf-8')
        else:
            value = unicode_or_str
        return value # Instance of unicode
    ```

  - to_str

    ```python
    # Python 2
    def to_str(unicode_or_str):
        if isinstance(unicode_or_str, unicode):
            value = unicode_or_str.encode('utf-8')
        else:
            value = unicode_or_str
        return value # Instance of str
    ```

- Python2，如果str只包含7-bit的ascii字符，unicode和str是一样的类型，所以：

  - 使用+连接：str + unicode
  - 可以对str和unicode进行比较
  - unicode可以使用格式字符串，’%s’

  注：在Python2中，如果只处理7位ASCII的情形下，可以等价 str 和 unicode 上面的规则，在Python3中 bytes 和 str 实例绝不等价

- 使用open返回的文件操作，在Python3是默认进行UTF-8编码，但在Pyhton2是二进制编码

  ```python
  # python3
  with open(‘/tmp/random.bin’, ‘w’) as f:
      f.write(os.urandom(10))
  # >>>
  #TypeError: must be str, not bytes
  ```

  这时我们可以用二进制方式进行写入和读取：

  ```python
  # python3
  with open('/tmp/random.bin','wb) as f:
      f.write(os.urandom(10))
  ```


### 第4条：用辅助函数来取代复杂的表达式

+ 开发者很容易过度使用Python的语法特效，从而写出那种特别复杂并且难以理解的单行表达式
+ 请把复杂的表达式移入辅助函数中，如果要反复使用相同的逻辑，那就更应该这么做
+ 使用 if/else 表达式，要比使用 or 或者 and 这样的 Booolean 操作符更加清晰

### 第5条：了解切割序列的办法

- 分片机制自动处理越界问题，但是最好在表达边界大小范围是更加的清晰。（如`a[:20]` 或者`a[-20:]`）

- list，str，bytes和实现\_\_getitem\_\_和\_\_setitem\_\_ 这两个特殊方法的类都支持slice操作

- 基本形式是：somelist[start:end]，不包括end，可以使用负数，-1 表示最后一个，默认正向选取，下标0可以省略，最后一个下标也可以省略

  ```python
  a = ['a','b','c','d','e','f','g','h']
  print('Middle Two:',a[3:-3])
  >>>
  Middle Two: ['d','e'] 
  ```


- slice list是shadow copy，somelist[0:]会复制原list，切割之后对新得到的列表进行修改不会影响原来的列表

  ```python
  a = ['a','b','c','d','e','f','g','h']
  b = a[4:]
  print("Before:", b)
  b[1] = 99
  print("After:",b)
  print("Original:",a)
  >>>
  Before: ['e','f','g','h']
  After: ['e',99,'g','h']
  Original: ['a','b','c','d','e','f','g','h']
  ```

- slice赋值会修改slice list，即使长度不一致（增删改）

  ```
  print("Before:",a)
  a[2:7] = [99,22,14]
  print("After:",a)
  >>>
  Before: ['a','b','c','d','e','f','g','h']
  After: ['a','b',99,22,14,'h']
  ```

- 引用-变化-追随

  当为列表赋值的时候省去开头和结尾下标的时候，将会用 **这个引用** 来替换整个列表的内容，而不是创建一个新的列表。同时，引用了这个列表的列表的相关内容，也会跟着发生变化。

  ```python
  a = ['a','b','c','d','e','f','g','h']
  b = a
  print("Before:",b)
  a[:] = [101,102,103]
  print("After:",b)
  >>>
  Before: ['a','b','c','d','e','f','g','h']
  After: [101,102,103]

  # 解决方案：深拷贝
  import copy
  b = copy.copy(a)
  print("Before:",b)
  a[:] = [101,102,103]
  print("After:",b)
  >>>
  Before: ['a','b','c','d','e','f','g','h']
  After: ['a','b','c','d','e','f','g','h']
  ```

### 第6条: 避免在单次切片操作内同事指定 start、end和 stride（个人觉得还好）

#### 备忘录：

- 在分片中指定`start`，`end`,`stride`会让人感到困惑，难于阅读。
- 尽可能的避免在分片中使用负数值。
- 避免在分片中同时使用`start`，`end`，`stride`；如果非要使用，考虑两次赋值（一个分片，一个调幅），或者使用内置模块`itertoolsde` 的 `islice`方法来进行处理。

#### 步幅

`Python` 有针对步幅的特殊的语法，形如：`somelist[start:end:stride]`。

```python
a = ['red','orange','yellow','green','blue','purple']
odds = a[::2]
print(odds)
>>>
['red','yellow','blue']
```

#### 负数步幅

步幅为-1来实现字符串的逆序，反向选取

```python
# 当数据仅仅为ASCII码内数据时工作正常
x = b'mongoose'
y = x[::-1]
print(y)
>>>
b'esoognom'

# 出现Unicode字符的时候就会报错
w = '谢谢'
x = w.encode(utf-8')
y = a[::-1]
z = y.decode('utf-8')
>>>
UnicodeDecodeError: 'utf-8' codec can't decode byte 0x9d in position 0: invalid start byte.
        
a = ['a','b','c','d','e','f','g','h']
a[2::2]     # ['c','e','g']
a[-2::-2]    # ['g','e','c','a']
a[-2:2:-2]   # ['g','e'] 尤其注意这里，类似于坐标轴，分片范围是左闭右开，所以2的位置不可达
a[2:2:-2]    # []
```

### 第7条: 用列表推导来代替 map 和 filter

#### 备忘录

- 列表表达式比内置的`map`,`filter`更加清晰，因为`map`,`filter`需要额外的`lambda`表达式的支持。
- 列表表达式允许你很容易的跳过某些输入值，而一个`map`没有`filter`帮助的话就不能完成这一个功能。
- 字典和集合也都支持列表表达式。

第一个例子：

```python
a = [1,2,3,4,5,6,7,8,9,10]
squares = [x*x for x in a]
print(squares)
>>>
[1,4,9,16,25,36,49,64,81,100]
```

map和filter需要lambda函数，使得代码更不可读

```python
squares = map(lambda x: x **2 ,a)
```

第二个例子：

```python
even_squares = [x**2 for x in a if x%2==0]
print(even_squares)
>>>
[4,16,36,64,100]
```

map：

```python
alt = map(lambda x: x**2, filter(lambda x: x%2==0,a))
assert even_squares== list(alt)
```

**字典和集合** 有他们自己的一套列表表达式。这使得书写算法的时候导出数据结构更加的简单。

```python
chile_rank = {'ghost':1,'habanero':2,'cayenne':3}
rank_dict = {rank:name for name,rank in child_rank.items()}
chile_len_set = {len(name) for name in rank_dict.values()}
print(rand_dict)
print(chile_len_set)
>>>
{1: 'ghost',2: 'habanero',3: 'cayenne'}
{8, 5, 7}
```

### 第8条: 在列表表达式中避免使用超过两个的表达式

#### 备忘录：

- 列表表达式支持多层的循环和条件语句，以及每层循环内部的条件语句。
- 当列表表达式内部多余两个表达式的时候就会变得难于阅读，这种写法应该避免使用。

#### 第一个例子：

not:

  ```python
squared = [[ x**2 for x in row] for row in matrix]
print(squared)
>>>
[[1, 4, 9],[16, 25, 36],[49, 64, 81]]
  ```

prefer:

  ```python
matrix = [[1, 2, 3],[4, 5, 6],[7, 8, 9]]
flat = [x for row in matrix for x in row]
print(flat)
>>>
[ 1, 2, 3, 4, 5, 6, 7, 8, 9]
  ```

#### 第二个例子：

not:

```python
my_lists = [
    [[1, 2, 3],[4, 5, 6]],
    # ...
]
flat = [ x for sublist in my_lists
          for sublist2 in sublist
          for x in sublist2]

print(flat)
```

prefer:

```python
flat = []
for sublist in my_lists:
    for sublist2 in sublist:
        flat.append(sublist2)
```

从这点来看，多行的列表表达式并不比原方案少多少代码。这里，作者更加的建议使用正常的循环体语句。因为其比列表表达式更简洁好看一点,也更加易读，易懂。

#### 第三个例子：

列表表达式同样支持if条件语句。多个条件语句出现在相同的循环水平中也是一个隐式`&`的表达,即同时成立才成立。例如：你只想获得列表中大于4且是偶数的值。那么下面的两个列表表达式是等价的。

```python
a = [1,2,3,4,5,6,7,8,9,10]
b = [x for x in a if x> 4 if x%2 ==0]
c = [x for x in a if x > 4 and if x%2 ==0]
```

条件语句可以被很明确的添加在每一层循环的`for`表达式的后面，起到过滤的作用。例如：你想过滤出每行总和大于10且能被3正处的元素。虽然用列表表达式表示出这段代码很短，但是其可读性确实很糟糕。

```python
matrix = [[ 1, 2, 3],[ 4, 5, 6],[ 7, 8, 9]]
filtered = [[x for x in row if x%3==0]
            for row in matrix if sum(row) >= 10 ]
print(filtered)
>>>
[[6],[9]]
```

### 第9条: 数据量较大的地方考虑使用生成器表达式

#### 备忘录

- 当遇到大输入事件的时候，使用列表表达式可能导致一些问题。
- 生成器表达式通过迭代的方式来处理每一个列表项，可以防止出现内存危机。
- 当生成器表达式 处于链式状态时，会执行的很迅速。

#### 列表生成式的缺点

列表生成式会给输入列表中的每一个只创建一个新的只包含一个元素的列表。这对于小的输入序列可能是很好用的，但是大的输入序列而言就很有可能导致你的程序崩溃。

#### 生成器表达式的好处

`Python`提供了一个`generator expression`（生成器表达式），在程序运行的过程中，生成其表达式不实现整个输出序列，相反,生成其表达式仅仅是对从表达式中产生一个项目的迭代器进行计算，说白了就是每次仅仅处理一个迭代项，而不是整个序列。

生成器表达式通过使用类似于列表表达式的语法（在`()`之间而不是`[]`之间，仅此区别）来创建。

举例：

```python
it = ( len(x) for x in open('/tmp/my_file.txt'))
print(it)
>>>
<generator object <genexpr> at 0x101b81480>

print(next(it))
print(next(it))
>>>
100
57
```

链式操作：

```python
roots = ((x,x**0.5) for x in it)
print(next(roots))
>>>
(15,3.872983346207417)
```

### 第10条：enumerate 比range更好用

#### 备忘录：

- `enumerate`提供了简洁的语法，再循环迭代一个迭代器的同时既能获取下标，也能获取当前值。
- 可以添加第二个参数来指定 索引开始的序号，默认为`0`

Prefer

```python
for i, flavor in enumerate(flavor_list):
    print(‘%d: %s’ % (i + 1, flavor))
```

not

```python
for i in range(len(flavor_list)):
    flavor = flavor_list[i]
        print(‘%d: %s’ % (i + 1, flavor))
        
# 也可以通过指定 索引开始的下标序号来简化代码
for i, flavor in enumerate(flavor_list,1):
    print("%d: %s"%(i,flavor))
```
### 第11条：用 zip 函数来同时遍历两个迭代器

#### 备忘录

- 内置的`zip`函数可以并行的对多个迭代器进行处理。
- 在`Python3`中，`zip` 采用懒模式生成器获得的是元组；而在`Python2`中，`zip`返回的是一个包含了其处理好的所有元祖的一个集合。
- 如果所处理的迭代器的长度不一致时，`zip`会默认截断输出，使得长度为最先到达尾部的那个长度。
- 内置模块`itertools`中的`zip_longest`函数可以并行地处理多个迭代器，而可以无视长度不一致的问题。

Prefer:

  ```python
  # 求最长字符串
  names = [‘Cecilia’, ‘Lise’, ‘Marie’]
  max_letters = 0
  letters = [len(n) for n in names]
  for name, count in zip(names, letters):
      if count > max_letters:
          longest_name = name
          max_letters = count
          
  print(longest_name)
  >>>
  Cecilia
  ```

not:

  ```python
  for i, name in enumerate(names):
  	count = letters[i]
      if count > max_letters:
          longest_name = name
          max_letters = count
  ```

### 第12条: 在for 和while 循环体后避免使用else语句块

#### 备忘录

- `Python`有用特殊的语法能够让`else`语块在循环体结束的时候立刻得到执行。
- 循环体后的`else`语块只有在循环体没有触发`break`语句的时候才会执行。
- 避免在循环体的后面使用`else`语块，因为这样的表达不直观，而且容易误导读者。



```python
for i in range(3):
    print('Loop %d' % i)
else:
    print('Else block')
>>>
Loop 0
Loop 1
Loop 2
Else block
```

### 第13条: 合理利用 try/except/else/finally

#### 备忘录

- `try/finally`组合语句可以使得你的代码变得很整洁而无视`try`块中是否发生异常。
- `else`块可以最大限度的减少`try`块中的代码的长度，并且可以可视化地辨别`try/except`成功运行的部分。
- `else`块经常会被用于在`try`块成功运行后添加额外的行为，但是要确保代码会在`finally`块之前得到运行。\



1. finally 块

   总是会执行，可以用来关闭文件句柄之类的

2. else 块

   try 块没有发生异常则执行 else 块，有了 else 块，我们可以尽量减少 try 块的代码量

示例：

```python
UNDEFINED = object()
def divide_json(path):
    handle = open(path, 'r+') # May raise IOError
    try:
        data = handle.read() # May raise UnicodeDecodeError
        op = json.loads(data) # May raise ValueError
        value = (op['numerator'] / op['denominator']) # May raise ZeroDivisionError
    except ZeroDivisionError as e:
        return UNDEFINED
    else:
        op[‘result’] = value
        result = json.dumps(op)
        handle.seek(0)
        handle.write(result) # May raise IOError
        return value
    finally:
        handle.close() # Always runs
```

## 二、函数

### 第14条: 返回 exceptions 而不是 None 

#### 备忘录

- 返回`None`的函数来作为特殊的含义是容易出错的，因为`None`和其他的变量（例如 `zero`，空字符串）在条件表达式的判断情景下是等价的。
- 通过触发一个异常而不是直接的返回`None`是比较常用的一个方法。这样调用方就能够合理地按照函数中的说明文档来处理由此而引发的异常了。

示例：

```python
def divide(a, b):
    try:
        return a / b
    except ZeroDivisionError:
        return None
```

返回 None 容易造成误用，下面的程式分不出 0 和 None

```python
x, y = 0, 5
result = divide(x, y)
if not result:
    print('Invalid inputs')  # This is wrong!
else:
    assert False
```

raise exception:

```python
def divide(a, b):
    try:
        return a / b
    except ZeroDivisionError as e:
        raise ValueError('Invalid inputs') from e
```

调用者看到该函数的文档中描述的异常之后，应该就会编写相应的代码来处理它们了。

```python
x, y = 5, 2
try:
    result = divide(x, y)
except ValueError:
    print("Invalid inputs")
else:
    print("Result is %.1f"% result)
 >>>
 Result is 2.5
```

### 第15条: 了解闭包中是怎样使用外围作用域变量

#### 备忘录

- 闭包函数可以从变量被定义的作用域内引用变量。
- 默认地，闭包不能通过赋值来影响其检索域。
- 在`Python3`中，可以使用`nonlocal`关键字来突破闭包的限制，进而在其检索域内改变其值。(`global` 关键字用于使用全局变量，`nonlocal` 关键字用于使用局部变量(函数内))
- `Python2`中没有`nonlocal`关键字，替代方案就是使用一个单元素（如列表，字典，集合等等）来实现与`nonlocal`一致的功能。
- 除了简单的函数，在其他任何地方都应该尽力的避免使用`nonlocal`关键字。

Python编译器变量查找域的顺序：
- 当前函数的作用域
- 任何其他的封闭域（比如其他的包含着的函数）。
- 包含该段代码的模块域（也称之为全局域）
- 内置域（包含了像`len`,`str`等函数的域）

考虑如下示例：

```python
# 优先排序
def sort_priority2(values, group):
    found = False    # 作用域：sort_priority2
    def helper(x):
        if x in group:
            found = True      # 作用域： helper
            return (0, x)
        return (1, x)   # found在helper的作用域就会由helper转至sort_priority2函数
    
    values.sort(key=helper)
    return found

values = [1,5,3,9,7,4,2,8,6]
group = [7,9]
# begin to call
found = sort_priority2(values, group)
print("Found:",found)
print(values)
>>>
Found: False
[7, 9, 1, 2, 3, 4, 5, 6, 8]
```

排序的结果是正确的，但是很明显分组的那个标志是不正确的了。`group`中的元素无疑可以在`values`里面找到，但是函数却返回了`False`，为什么会发生这样的状况呢？（提示：Python 编译器变量查找域的顺序）

#### 把数据放到外边

在`Python3`中，对于闭包而言有一个把数据放到外边的特殊的语法。`nonlocal`语句习惯于用来表示一个特定变量名称的域的遍历发生在赋值之前。 唯一的限制就是`nonlocal`不会向上遍历到模块域级别（这也是为了防止污染全局变量空间）。这里，我定义了一个使用了`nonlocal`关键字的函数。

```python
def srt_priority3(numbers, group):
    found = False
    def helper(x):
        nonlocal found 
        if x in group:
            found = True
            return (0, x)
        return (1, x)
    numbers.sort(key=helper)
    return found
```

当数据在闭包外将被赋值到另一个域时，`nonlocal` 语句使得这个过程变得很清晰。它也是对`global`语句的一个补充，可以明确的表明变量的赋值应该被直接放置到模块域中。

然而，像这样的反模式，对使用在那些简单函数之外的其他的任何地方。`nonlocal`引起的副作用是难以追踪的，而在那些包含着`nonlocal`语句和赋值语句交叉联系的大段代码的函数的内部则尤为明显。

当你感觉自己的`nonlocal`语句开始变的复杂的时候，我非常建议你重构一下代码，写成一个工具类。这里，我定义了一个实现了与上面的那个函数功能相一致的工具类。虽然有点长，但是代码却变得更加的清晰了（详见第23项：对于简单接口使用函数而不是类里面的`__call__`方法）。

```python
class Sorter(object):
    def __init__(self, group):
        self.group = group
        self.found = False

    def __call__(self, x):
        if x in self.group:
            self.found = True
            return (0, x)
        return (1, x)

sorter = Sorter(group)
numbers.sort(key=sorter)
assert sorter is True

```

#### Python2中的作用域

不幸的是，`Python2`是不支持`nonlocal`关键字的。为了实现相似的功能，你需要广泛的借助于`Python`的作用与域规则。虽然这个方法并不是完美的，但是这是`Python`中比较常用的一种做法。

```python
# Python2
def sort_priority(numbers, group):
    found = [False]
    def helper(x):
        if x in group:
            found[0] = True
            return (0, x)
        return (1, x)
    numbers.sort(sort=helper)
    return found[0]

```

就像上面解释的那样，`Python` 将会横向查找该变量所在的域来分析其当前值。技巧就是发现的值是一个易变的列表。这意味着一旦检索，闭包就可以修改`found`的状态值，并且把内部数据的改变发送到外部，这也就打破了闭包引发的局部变量作用域无法被改变的难题。其根本还是在于列表本身元素值可以被改变，这才是此函数可以正常工作的关键。

当`found`为一个`dictionary`类型的时候，也是可以正常工作的，原理与上文所言一致。此外，`found`还可以是一个集合，一个你自定义的类等等。

### 第16条: 考虑使用生成器而不是返回列表

#### 备忘录

- 相较于返回一个列表的情况，替代方案中使用生成器可以使得代码变得更加的清晰。
- 生成器返回的迭代器，是在其生成器内部一个把值传递给了`yield`变量的集合。
- 生成器可以处理很大的输出序列就是因为它在处理的时候不会完全的包含所有的数据。

考虑以下两种版本代码，一个用 **list **，另一个用 **generator**

```python
def index_words(text):
    result = []
    if text:
        result.append(0)
    for index, letter in enumerate(text):
        if letter == ' ':
            result.append(index + 1)
    return result

address = 'Four score and seven years ago...'
result = index_words(address)
print(result[:3]) # [0, 5, 11]
```

generator

```python
def index_words_iter(text):
    if text:
        yield 0
    for index, letter in enumerate(text):
        if letter == ' ':
            yield index + 1

result = list(index_words_iter(address))
```

使用 **generator ** 比较简单，减少了 list 操作

另一个 **generator **的好处是更有效率地使用记忆值，generator不需要有存全部的资料

```python
import itertools

def index_file(handle):
    offset = 0
    for line in handle:
        if line:
            yield offset
        for letter in line:
            offset += 1
            if letter == ' ':
                yield offset

with open('/tmp/address.txt', 'r') as f:
    it = index_file(f)
    results = itertools.islice(it, 0, 3)
    print(list(results))
    
>>>
[0, 5, 11]
```

不管address.txt 多大都能处理

### 第17条: 遍历参数的时候小心一点

#### 备忘录

- 多次遍历输入参数的时候应该多加小心。如果参数是迭代器的话你可能看到奇怪的现象或者缺少值现象的发生。
- `Python`的`iterator`协议定义了容器和迭代器在`iter`和`next`下对于循环和相关表达式的关系。
- 只要实现了`__iter__`方法，你就可以很容易的定义一个可迭代的容器类。
- 通过连续调用两次`iter`方法，你就可以预先检测一个值是不是迭代器而不是容器。两次结果一致那就是迭代器，否则就是容器了。

generator不能重用：

```python
def read_visits(data_path):
    with open(data_path,'r') as f:
        for line in f:
            yield int(line)

it = read_visits('tmp/my_numbers.txt')
print(list(it))
print(list(it)) # 这里其实已经执行到头了
>>>
[15, 35, 80]
[]
```
造成上述结果的原因是 一个迭代器每次只处理它本身的数据。如果你遍历一个迭代器或者生成器本身已经引发了一个`StopIteration`的异常，你就不可能获得任何数据了。

#### 解决方案：

每次调用都创建iterator避免上面list分配内存

```python
def normalize_func(get_iter):  # get_iter 是函数
    total = sum(get_iter())    # New iterator
    result = []
    for value in get_iter():   # New iterator
       percent = 100 * value / total
       result.append(percent)
        
    return result

percentages = normalize_func(lambda: read_visits(path))
```
for循环会调用内置iter函数，进而调用对象的\_\_iter\_\_方法，\_\_iter\_\_会返回iterator对象（实现\_\_next\_\_方法）

用iter函数检测iterator：

```python
def normalize_defensive(numbers):
    if iter(numbers) is iter(numbers): # 是个迭代器，这样不好
        raise TypeError('Must supply a container')
    total = sum(numbers)
    result = []
    for value in numbers:
        percent = 100 * value / total
        result.append(percent)
    return result

visits = [15, 35, 80]
normalize_defensive(visits)
visits = ReadVIsitors(path)
normalize_defensive(visits)

# 但是如果输入值不是一个容器类的话，就会引发异常了
it = iter(visits)
normalize_defensive(it)
>>>
TypeError: Must supply a container
```
### 第18条: 减少位置参数上的干扰

#### 备忘录

- 通过使用`*args`定义语句，函数可以接收可变数量的位置参数。
- 你可以通过`*`操作符来将序列中的元素作为位置变量。
- 带有`*`操作符的生成器变量可能会引起程序的内存溢出，或者机器宕机。
- 为可以接受`*args`的函数添加新的位置参数可以产生难于发现的问题，应该谨慎使用。

举例：

```python
def log(message, values):
    if not values:
        print(message)
    else:
        values_str = ', '.join(str(x) for x in values)
        print('%s: %s' % (message, values_str))

log('My numbers are', [1, 2])
log('Hi there', [])
```

```python
def log(message, *values):
    if not values:
        print(message)
    else:
        values_str = ', '.join(str(x) for x in values)
        print('%s: %s' % (message, values_str))

log('My numbers are', 1, 2)
log('Hi there')
```

第二个就比第一个要更有弹性

不过传入生成器的时候，因为变长参数在传给函数的时候，总要先转换为元组，所以如果生成器迭代的数据很大的话，可能会导致程序崩溃

### 第19条: 使用关键字参数来提供可选行为

#### 备忘录

- 函数的参数值即可以通过位置被指定，也可以通过关键字来指定。
- 相较于使用位置参数赋值，使用关键字来赋值会让你的赋值语句逻辑变得更加的清晰。
- 带有默认参数的关键字参数函数可以很容易的添加新的行为，尤其适合向后兼容。
- 可选的关键字参数应该优于位置参数被考虑使用。



关键字参数的好处:

1. 代码可读性的提高
2. 以在定义的时候初始化一个默认值
3. 在前面的调用方式不变的情况下可以很好的拓展函数的参数，不用修改太多的代码

如果本來的函数如下

```python
def flow_rate(weight_diff, time_diff, period=1):
    return (weight_diff / time_diff) * period
```

如果后来函数修改了

```python
def flow_rate(weight_diff, time_diff,
              period=1, units_per_kg=1):
    return ((weight_diff / units_per_kg) / time_diff) * period
```

那么可以如下使用

```python
flow_per_second = flow_rate(weight_diff, time_diff)
flow_per_hour = flow_rate(weight_diff, time_diff, period=3600)
pounds_per_hour = flow_rate(weight_diff, time_diff, period=3600, units_per_kg=2.2)
pounds_per_hour = flow_rate(weight_diff, time_diff, 3600, 2.2) # 不推荐
```

### 第20条: 使用None和文档说明动态的指定默认参数

#### 备忘录

- 默认参数只会被赋值一次：在其所在模块被加载的过程中,这有可能导致一些奇怪的现象。
- 使用`None`作为关键字参数的默认值会有一个动态值。要在该函数的说明文档中详细的记录一下。

#### 第一个例子：

not:

```python
def log(message, when=datetime.now()):
    print(‘%s: %s’ % (when, message))
    
log(‘Hi there!’)
sleep(0.1)
log(‘Hi again!’)
>>>
2014-11-15 21:10:10.371432: Hi there!
2014-11-15 21:10:10.371432: Hi again!
```
prefer:

```python
def log(message, when=None):
    """Log a message with a timestamp.

    Args:
        message: Message to print
        when: datetime of when the message occurred.
            Default to the present time.
    """
    when = datetime.now() if when is None else when
    print("%s: %s" %(when, message))

# 测试

log('Hi there!')
sleep(0.1)
log('Hi again!')
>>>
2014-11-15 21:10:10.472303: Hi there!
2014-11-15 21:10:10.473395: Hi again!
```
上述方法造成 when 第一次被赋值之后便不会再重新赋值

#### 第二个例子：

not:

```python
def decode(data, default={}):
    try:
        return json.loads(data)
    except ValueError:
        return default

foo = decode('bad data')
foo['stuff'] = 5
bar = decode('also bad')
bar['meep'] = 1
print('Foo:', foo)
print('Bar:', bar)
>>>
Foo: {'stuff': 5, 'meep': 1}
Bar: {'stuff': 5, 'meep': 1}
```

prefer:

```python
def decode(data, default=None):
    """Load JSON data from string.

    Args:
        data: JSON data to be decoded.
        default: Value to return if decoding fails.
            Defaults to an empty dictionary.
    """

    if default is None:
        default = {}
    try:
        return json.loads(data)
    except ValueError:
        return default

# 现在测试一下
foo = decode('bad data')
foo['stuff'] = 5
bar = decode('also bad')
bar['meep'] = 1
print('Foo:', foo)
print('Bar:', bar)
>>>
Foo: {'stuff': 5}
Bar: {'meep': 1}
```

### 第21条: 仅强调关键字参数

#### 备忘录

- 关键字参数使得函数调用的意图更加的清晰，明显。
- 使用`keyword-only`参数可以强迫函数调用者提供关键字来赋值，这样对于容易使人疑惑的函数参数很有效，尤其适用于接收多个布尔变量的情况。
- `Python3`中有明确的`keyword-only`函数语法。
- `Python2`中可以通过`**kwargs`模拟实现`keyword-only`函数语法,并且人工的触发`TypeError`异常。
- `keyword-only`在函数参数列表中的位置很重要，这点大家尤其应该明白！

下面的程式使用上不方便，因为容易忘记 ignore_overflow 和 ignore_zero_division 的顺序

```python
def safe_division(number, divisor, ignore_overflow,
                  ignore_zero_division):
    try:
        return number / divisor
    except OverflowError:
        if ignore_overflow:
            return 0
        else:
            raise
    except ZeroDivisionError:
        if ignore_zero_division:
            return float('inf')
        else:
            raise

result = safe_division(1, 10**500, True, False)
result = safe_division(1, 0, False, True)
```

用 keyword 引数可解決此问题，在 Python 3 可以宣告强制接收 keyword-only 参数。

下面定义的这个 safe_division_c 函数，带有两个只能以关键字形式来指定的参数。参数列表里面的 * 号，标志着位置参数就此终结，之后的那些参数，都只能以关键字的形式来指定

```python
def safe_division_c(number, divisor, *,
                    ignore_overflow=False,
                    ignore_zero_division=False):
    try:
        return number / divisor
    except OverflowError:
        if ignore_overflow:
            return 0
        else:
            raise
    except ZeroDivisionError:
        if ignore_zero_division:
            return float('inf')
        else:
            raise

safe_division_c(1, 10**500, True, False)
>>> 
TypeError: safe_division_c() takes 2 positional arguments but 4 were given

safe_division(1, 0, ignore_zero_division=True)  # OK
...
```

Python 2 虽然没有这种语法，但可以用 `** ` 操作符模拟

注：`*` 操作符接收可变数量的位置参数，`**` 接受任意数量的关键字参数

```python
# Python 2
def safe_division(number, divisor, **kwargs):
    ignore_overflow = kwargs.pop('ignore_overflow', False)
    ignore_zero_division = kwargs.pop('ignore_zero_division', False)
    if kwargs:
        raise TypeError("Unexpected **kwargs: %r"%kwargs)
    # ···

# 测试
safe_division(1, 10)
safe_division(1, 0, ignore_zero_division=True)
safe_division(1, 10**500, ignore_overflow=True)
# 而想通过位置参数赋值，就不会正常的运行了
safe_division(1, 0, False, True)
>>>
TypeError：safe_division() takes 2 positional arguments but 4 were given.
```

## 三、类和继承

### 第22条: 尽量使用辅助类来维护程序的状态，避免dict嵌套dict或大tuple

#### 备忘录

- 避免字典中嵌套字典，或者长度较大的元组。
- 在一个整类（类似于前面第一个复杂类那样）之前考虑使用 `namedtuple` 制作轻量，不易发生变化的容器。
- 当内部的字典关系变得复杂的时候将代码重构到多个工具类中。

dictionaries 以及 tuples 拿來存简单的资料很方便，但是当资料越来越复杂时，例如多层 dictionaries 或是 n-tuples，程式的可读性就下降了。例如下面的程式：

```python
class SimpleGradebook(object):
    def __init__(self):
        self._grades = {}

    def add_student(self, name):
        self._grades[name] = []

    def report_grade(self, name, score):
        self._grades[name].append(score)

    def average_grade(self, name):
        grades = self._grades[name]
        return sum(grades) / len(grades)

```

正是由于字典很容易被使用，以至于对字典过度的拓展会导致代码越来越脆弱。例如：你想拓展一下`SimpleGradebook`类来根据科目保存成绩的学生的集合,而不再是整体性的存储。你就可以通过修改`_grade`字典来匹配学生姓名，使用另一个字典来包含成绩。而最里面的这个字典将匹配科目（`keys`)和成绩(`values`)。你还想根据班级内总体的成绩来追踪每个门类分数所占的比重，所以期中，期末考试相比于平时的测验而言更为重要。实现这个功能的一个方式是改变最内部的那个字典，而不是让其关联着科目（`key`)和成绩（`values`)。我们可以使用元组（`tuple`)来作为成绩（`values`)。

```python
class WeightedGradebook(object):
    def __init__(self):
        self._grades = {}

    def add_student(self, name):
        self._grades[name] = {}

    def report_grade(self, name, subject, score, weight):
        by_subject = self._grades[name]
        grade_list = by_subject.setdefault(subject, [])
        grade_list.append((score, weight))

    def average_grade(self, name):
        by_subject = self._grades[name]
        score_sum, score_count = 0, 0
        for subject, scores in by_subject.items():
            subject_avg, total_weight = 0, 0
            for score, weight in scores:
                subject_avg += score * weight
                total_weight += weight
            score_sum += subject_avg / total_weight
            score_count += 1
        return score_sum / score_count
```

这个类使用起来貌似也变的超级复杂了，并且每个位置参数代表了什么意思也不明不白的。

#### 重构成多个类

你可以从依赖树的底端开始，将其划分成多个类：一个单独的成绩类好像对于如此一个简单的信息权重太大了。一个元组，使用元组似乎很合适，因为成绩是不会改变的了，这刚好符合元组的特性。这里，我使用一个元组（`score`, `weight`)来追踪列表中的成绩信息。

```python
import collections

Grade = collections.namedtuple('Grade', ('score', 'weight'))


class Subject(object):
    def __init__(self):
        self._grades = []

    def report_grade(self, score, weight):
        self._grades.append(Grade(score, weight))

    def average_grade(self):
        total, total_weight = 0, 0
        for grade in self._grades:
            total += grade.score * grade.weight
            total_weight += grade.weight
        return total / total_weight


class Student(object):
    def __init__(self):
        self._subjects = {}

    def subject(self, name):
        if name not in self._subjects:
            self._subjects[name] = Subject()
        return self._subjects[name]

    def average_grade(self):
        total, count = 0, 0
        for subject in self._subjects.values():
            total += subject.average_grade()
            count += 1
        return total / count


class Gradebook(object):
    def __init__(self):
        self._students = {}

    def student(self, name):
        if name not in self._students:
            self._students[name] = Student()
        return self._students[name]
```

### 第23条: 对于简单接口使用函数而不是类的实例

#### 备忘录

- 在`Python`中，不需要定义或实现什么类，对于简单接口组件而言，函数就足够了。
- `Python`中引用函数和方法的原因就在于它们是`first-class`，可以直接的被运用在表达式中。
- 特殊方法`__call__`允许你像调用函数一样调用一个对象实例。
- 当你需要一个函数来维护状态信息的时候，考虑一个定义了`__call__`方法的状态闭包类哦（详见第`15`项：了解闭包是怎样与变量作用域的联系）。

`Python`中的许多内置的`API`都允许你通过向函数传递参数来自定义行为。这些被`API`使用的`hooks`将会在它们运行的时候回调给你的代码。例如：`list`类型的排序方法中有一个可选的`key` 参数来决定排序过程中每个下标的值。这里，我使用一个`lambda`表达式作为这个键钩子，根据名字中字符的长度来为这个集合排序。

```python
names = ['Socrates', 'Archimedes', 'Plato', 'Aristotle']
names.sort(key=lambda x: len(x))
print(names)
>>>
['Plato', Socrates', 'Aristotle', 'Archimedes']

```

在其他的编程语言中，你可能期望一个抽象类作为这个`hooks`。但是在`Python`中，许多的`hooks`都是些无状态的有良好定义参数和返回值的函数。而对于`hooks`而言，使用函数是很理想的。因为更容易藐视，相对于类而言定义起来也更加的简单。函数可以作为钩子来工作是因为`Python`有`first-class`函数：在编程的时候函数，方法可以像其他的变量值一样被引用，或者被传递给其他的函数。



`Python`允许类来定义`__call__`这个特殊的方法。它允许一个对象像被函数一样来被调用。这样的一个实例也引起了`callable`这个内`True`的事实。

```python
current = {'green': 12, 'blue': 3}
incremetns = [
    ('red', 5),
    ('blue', 17),
    ('orange', 9)
]

class BetterCountMissing(object):

    def __init__(self):
        self.added = 0

    def __call__(self):
        self.added += 1
        return 0

counter = BetterCountMissing()
counter()
assert callable(counter)
# 这里我使用一个BetterCountMissing实例作为defaultdict函数的默认的hook值来追踪缺省值被添加的次数。
counter = BetterCountMissing()
result = defaultdict(counter, current)
for key, amount in increments:
    result[key] += amount
assert counter.added == 2
```

### 第24条: 使用@classmethod多态性构造对象

#### 备忘录

- `Python`的每个类只支持单个的构造方法，`__init__`。
- 使用`@classmethod`可以为你的类定义可替代构造方法的方法。
- 类的多态为具体子类的组合提供了一种更加通用的方式。

使用 `@classmethod `起到多态的效果：一个对于分层良好的类树中，不同类之间相同名称的方法却实现了不同的功能的体现。

下面的函数 generate_inputs() 不够一般化，只能使用 PathInputData ，如果想使用其它 InputData 的子类，必须改变函数。

```python
class InputData(object):
    def read(self):
        raise NotImplementedError

class PathInputData(InputData):
    def __init__(self, path):
        super().__init__()
        self.path = path

    def read(self):
        return open(self.path).read()

def generate_inputs(data_dir):
    for name in os.listdir(data_dir):
        yield PathInputData(os.path.join(data_dir, name))
```

问题在于建立 `InputData` 子类的物件不够一般化，如果你想要编写另一个 `InputData` 的子类就必须重写 `read` 方法幸好有 `@classmethod `，可以达到一样的效果。

```python
class GenericInputData(object):
    def read(self):
        raise NotImplementedError

    @classmethod
    def generate_inputs(cls, config):
        raise NotImplementedError

class PathInputData(GenericInputData):
    def __init__(self, path):
        super().__init__()
        self.path = path

    def read(self):
        return open(self.path).read()

    @classmethod
    def generate_inputs(cls, config):
        data_dir = config['data_dir']
        for name in os.listdir(data_dir):
            yield cls(os.path.join(data_dir, name))
```

### 第25条: 使用super关键字初始化父类

#### 备忘录

- `Python`的解决实例化次序问题的方法`MRO`解决了菱形继承中超类多次被初始化的问题。
- 总是应该使用`super`来初始化父类。

先看一个还行的例子：

```python
class MyBaseClass(object):
    def __init__(self, value):
        self.value = value
        
class TimesTwo(object):
    def __init__(self):
        self.value *= 2


class PlusFive(object):
    def __init__(self):
        self.value += 5


# 多继承实例,注意继承的次序哦
class OneWay(MyBaseClass, TimesTwo, PlusFive):
    def __init__(self, value):
        MyBaseClass.__init__(self, value)
        TimesTwo.__init__(self)
        PlusFive.__init__(self)

foo = OneWay(5)
print("First ordering is ( 5 * 2 ) + 5 = ", foo.value)
>>>
First ordering is (5 * 2 ) + 2 = 15
```

不使用 **super() **在多重继承时可能会造成意想不到的问题，下面的程式造成所谓的 **diamond inheritance **。

```python
class MyBaseClass(object):
    def __init__(self, value):
        self.value = value

class TimesFive(MyBaseClass):
    def __init__(self, value):
        MyBaseClass.__init__(self, value)
        self.value *= 5

class PlusTwo(MyBaseClass):
    def __init__(self, value):
        MyBaseClass.__init__(self, value)
        self.value += 2

class ThisWay(TimesFive, PlusTwo):
    def __init__(self, value):
        TimesFive.__init__(self, value)
        PlusTwo.__init__(self, value)

# 测试
foo = ThisWay(5)
print('Should be (5 * 5) + 2 = 27 but is', foo.value)
>>>
Should be (5 * 5) + 2 = 27 but is 7
```

注：foo.value 的值是 7 ，而不是 27。因为 `PlusTwo.__init__(self, value) ` 将值重设为 5 了。

使用 `super() `可以正确得到 27

```python
# 现在，菱形继承的超类，也就是最顶上的那个`MyBaseClass`只会被初始化一次，而其他的两个父类会按照被声明的顺序来初始化了。
class GoodWay(TimesFiveCorrect, PlusTwoCorrect):# Python 2
class MyBaseClass(object):
    def __init__(self, value):
        self.value = value

class TimesFiveCorrect(MyBaseClass):
    def __init__(self, value):
        super(TimesFiveCorrect, self).__init__(value)
        self.value *= 5

class PlusTwoCorrect(MyBaseClass):
    def __init__(self, value):
        super(PlusTwoCorrect, self).__init__(value)
        self.value += 2

class GoodWay(PlusTwoCorrect, TimesFiveCorrect):
    def __init__(self, value):
        super(GoodWay, self).__init__(value)

foo = GoodWay(5)
print("Should be 5 * (5 + 2) = 35 and is " , foo.value)
>>>
Should be 5 * (5 + 2) = 35 and is 35
```

python中父类实例化的规则是按照`MRO`标准来进行的，MRO 的执行顺序是 DFS 

```python
# Python 2
from pprint import pprint
pprint(GoodWay.mro())
>>>
[<class '__main__.GoodWay'>,
<class '__main__.TimesFiveCorrect'>,
<class '__main__.PlusTwoCorrect'>,
<class '__main__.MyBaseClass'>,
<class 'object'>]
```

最开始初始化`GoodWay`的时候，程序并没有真正的执行，而是走到这条继承树的树根，从树根往下才会进行初始化。于是我们会先初始化`MyBaseClass`的`value`为`5`，然后是`PlusTwoCorrect`的`value`会变成`7`，接着`TimesFiveCorrect`的`value`就自然的变成`35`了。

Python 3 简化了 **super() **的使用方式

```python
class Implicit(MyBaseClass):
    def __init__(self, value):
        super().__init__(value * 2)
```

### 第26条: 只在用编写Max-in组件的工具类的时候使用多继承

#### 备忘录

- 如果可以使用`mix-in`实现相同的结果输出的话，就不要使用多继承了。
- 当`mix-in `类需要的时候，在实例级别上使用可插拔的行为可以为每一个自定义的类工作的更好。
- 从简单的行为出发，创建功能更为灵活的`mix-in`。

如果你发现自己渴望随继承的便利和封装,那么考虑`mix-in`吧。它是一个只定义了几个类必备功能方法的很小的类。`Mix-in`类不定义以自己的实例属性，也不需要它们的初始化方法`__init__`被调用。`Mix-in`可以被分层和组织成最小化的代码块，方便代码的重用。

mix-in 是可以替换的 class ，通常只定义 methods ，虽然本质上上还是通过继承的方式，但因为 mix-in 沒有自己的 state ，也就是说沒有定义 attributes ，使用上更有弹性。

范例1:

注：hasattr 函数动态访问属性，isinstance 函数动态检测对象类型

```python
import json

class ToDictMixin(object):
    def to_dict(self):
        return self._traverse_dict(self.__dict__)

    def _traverse_dict(self, instance_dict):
        output = {}
        for key, value in instance_dict.items():
            output[key] = self._traverse(key, value)
        return output

    def _traverse(self, key, value):
        if isinstance(value, ToDictMixin):
            return value.to_dict()
        elif isinstance(value, dict):
            return self._traverse_dict(value)
        elif isinstance(value, list):
            return [self._traverse(key, i) for i in value]
        elif hasattr(value, '__dict__'):
            return self._traverse_dict(value.__dict__)
        else:
            return value
```
使用示例:

```python
class BinaryTree(ToDIctMixin):
    def __init__(self, value, left=None, right=None):
        self.value = value
        self.left = left
        self.right = right


# 这下把大量的Python对象转换到一个字典中变得容易多了。
tree = BinaryTree(10, left=BinaryTree(7, right=BinaryTree(9)),
    right=BinaryTree(13, left=BinaryTree(11)))
print(tree.to_dict())
>>>
{'left': {'left': None,
         'right': {'left': None, 'right': None, 'value': 9},
         'value': 7},
 'right': {'left': {'left': None, 'right': None, 'value': 11},
         'right': None,
         'value': 13},
  'value': 10
}
```

范例2：

```python
# 在这个例子中，唯一的必须条件就是类中必须有一个to_dict方法和接收关键字参数的__init__构造方法
class JsonMixin(object):
    @classmethod
    def from_json(cls, data):
        kwargs = json.loads(data)
        return cls(**kwargs)

    def to_json(self):
        return json.dumps(self.to_dict())
    
class DatacenterRack(ToDictMixin, JsonMixin):
    def __init__(self, switch=None, machines=None):
        self.switch = Switch(**switch)
        self.machines = [Machine(**kwargs) for kwargs in machines]

class Switch(ToDictMixin, JsonMixin):
    def __init__(self, ports=None, speed=None):
        self.ports = ports
        self.speed = speed

class Machine(ToDictMixin, JsonMixin):
    def __init__(self, cores=None, ram=None, disk=None):
        self.cores = cores
        self.ram = ram
        self.disk = disk

# 将这些类从JSON传中序列化也是简单的。这里我校验了一下，保证数据可以在序列化和反序列化正常的转换。
serialized = """{
    "switch": {"ports": 5, "speed": 1e9},
    "machines": [
        {"cores": 8, "ram": 32e9, "disk": 5e12},
        {"cores": 4, "ram": 16e9, "disk": 1e12},
        {"cores": 2, "ram": 4e9, "disk": 500e9}
    ]
}"""

deserialized = DatacenterRack.from_json(serialized)
roundtrip = deserialized.to_json()
assert json.loads(serialized) == json.loads(roundtrip)
```

### 第27条: 多使用公共属性，而不是私有属性

#### 备忘录

+ Python 编译器无法严格保证 private 字段的私密性
+ 不要盲目将属性设置为 private，而是应该从一开始就做好规划，并允子类更多地访问超类的内部的API
+ 应该多用 protected 属性，并且在文档中把这些字段的合理用法告诉子类的开发者，而不要试图用 private 属性来限制子类的访问
+ 只有当子类不受自己控制的收，才可以考虑使用 private 属性来避免名称冲突

Python 里面沒有真正的 "private variable"，想存取都可以存取得到。

下面的程式看起來我们没办法得到 `__private_field`

```python
class MyObject(object):
    def __init__(self):
        self.public_field = 5
        self.__private_field = 10

    def get_private_field(self):
        return self.__private_field

foo = MyObject()
print(foo.__private_field) # AttributeError
```

但其实只是名称被改掉而已

```
print(foo.__dict__)
# {'_MyObject__private_field': 10, 'public_field': 5}

print(foo._MyObject__private_field)
```

一般来说 Python 惯例是在变数前加一个底线代表 **protected variable **，作用在于提醒开发者使用上要注意。

```python
class MyClass(object):
    def __init__(self, value):
        # This stores the user-supplied value for the object.
        # It should be coercible to a string. Once assigned for
        # the object it should be treated as immutable.
        self._value = value

    def get_value(self):
        return str(self._value)

class MyIntegerSubclass(MyClass):
    def get_value(self):
        return self._value

foo = MyIntegerSubclass(5)
assert foo.get_value() == 5

```

双底线的命名方式是为了避免父类和子类间的命名冲突，除此之外尽量避免使用这种命名。

### 第28条:自定义容器类型要从collections.abc来继承

#### 备忘录

+ 如果要定制的子类比较简单，那就可以直接从Python的容器类型（如list或dict）中继承
+ 想正确实现自定义的容器类型，可能需要编写大量的特殊方法
+ 编写自制的容器类型时，可以从collection.abc 模块的抽象类基类中继承，那些基类能确保我们的子类具备适当的接口及行为

`collections.abc ` 里面的 abstract classes 的作用是让开发者方便地开发自己的 container ，例如 list。一般情況下继承list 就ok了，但是当结构比较复杂的时候就需要自己自定义，例如 list 有许多 方法，要一一实现有点麻烦。

下面程式中 SequenceNode 是想要拥有 list 功能的 binary tree。

```python
class BinaryNode(object):
    def __init__(self, value, left=None, right=None):
        self.value = value
        self.left = left
        self.right = right

class IndexableNode(BinaryNode):
    def _search(self, count, index):
        found = None
        if self.left:
            found, count = self.left._search(count, index)
        if not found and count == index:
            found = self
        else:
            count += 1
        if not found and self.right:
            found, count = self.right._search(count, index)
        return found, count

    def __getitem__(self, index):
        found, _ = self._search(0, index)
        if not found:
            raise IndexError('Index out of range')
        return found.value

class SequenceNode(IndexableNode):
    def __len__(self):
        _, count = self._search(0, None)
        return count
```

以下是 SequenceNode的一些 list 常用的操作

```python
tree = SequenceNode(
	10,
    left=SequenceNode(
    	5,
        left=SequenceNode(2),
        right=SequenceNode(
        	6, 
        	right=SequenceNode(7))),
    right=SequenceNode(
		15, 
		left=SequenceNode(11)))

print('Index 0 =', tree[0]) 
print('11 in the tree?', 11 in tree)
print('Tree has %d nodes' % len(tree))
>>>
Index 0 = 2
11 in the tree? True
Tree has 7 nodes
```

但是使用者可能想使用像 `count() `以及 `index() `等 list 的 方法 ，这时候可以使用 `collections.abc `的 **Sequence **。子类只要实现 `__getitem__ `以及 `__len__ `， **Sequence **以及提供`count() `以及 `index() `了，而且如果子类没有实现类似 **Sequence** 的抽象基类所要求的每个方法，`collections.abc` 模块就会指出这个错误。

```python
from collections.abc import Sequence

class BetterNode(SequenceNode, Sequence):
    pass

tree = BetterNode(
   # ...
)

print('Index of 7 is', tree.index(7))
print('Count of 10 is', tree.count(10))
>>>
Index of 7 is 3
Count of 10 is 1
```

## 四、元类和属性

### 第29条: 用纯属性取代 get 和 set 方法

#### 备忘录

- 使用public属性避免set和get方法，@property定义一些特别的行为
- 如果访问对象的某个属性的时候，需要表现出特殊的行为，那就用@property来定义这种行为
- @property 方法应该遵循最小惊讶原则，而不应该产生奇怪的副作用
- 确保@property方法是快速的，如果是慢或者复杂的工作应该放在正常的方法里面

示例1：

不要把 java 的那一套 getter 和 setter 带进来

not:

```python
class OldResistor(object):
    def __init__(self, ohms):
        self._ohms = ohms
    
    def get_ohms(self):
        return self._ohms
    
    def set_ohms(self, ohms):
        self._ohms = ohms
```

prefer:

```python
class Resistor(object):
    def __init__(self, ohms):
        self.ohms = ohms
        self.voltage = 0
        self.current = 0
```

示例2：

使用@property，来绑定一些特殊操作，但是不要产生奇怪的副作用，比如在getter里面做一些赋值的操作

```python
class VoltageResistance(Resistor):
    def __init__(self, ohms):
        super().__init__(ohms)
        self._voltage = 0
    
    # 相当于 getter
    @property
    def voltage(self):
        return self._voltage
	
    # 相当于 setter
    @voltage.setter
    def voltage(self, voltage):
        self._voltage = voltage
        self.current = self._voltage / self.ohms

r2 = VoltageResistance(1e3)
print('Before: %5r amps' % r2.current)
# 会执行 setter 方法
r2.voltage = 10
print('After:  %5r amps' % r2.current)
```

### 第30条: 考虑@property来替代属性重构

#### 备忘录

- 使用@property给已有属性扩展新需求
- 可以用 @property 来逐步完善数据模型
- 当@property太复杂了才考虑重构

@property可以把简单的数值属性迁移为实时计算，只定义 getter 不定义 setter 那么就是一个只读属性

```python
class Bucket(object):
    def __init__(self, period):
        self.period_delta = timedelta(seconds=period)
        self.reset_time = datetime.now()
        self.max_quota = 0
        self.quota_consumed = 0

    def __repr__(self):
        return ('Bucket(max_quota=%d, quota_consumed=%d)' %
                (self.max_quota, self.quota_consumed))


    @property
    def quota(self):
        return self.max_quota - self.quota_consumed
    
    @quota.setter
    def quota(self, amount):
        delta = self.max_quota - amount
        if amount == 0:
            # Quota being reset for a new period
            self.quota_consumed = 0
            self.max_quota = 0
        elif delta < 0:
            # Quota being filled for the new period
            assert self.quota_consumed = 0
            self.max_quota = amount
        else:
            # Quota being consumed during the period
            assert self.max_quota >= self,quota_consumed
            self.quota_consumed += delta
```

这种写法的好处就在于：从前使用的Bucket.quota 的那些旧代码，既不需要做出修改，也不需要担心现在的Bucket类是如何实现的，可以轻松无痛扩展新功能。但是@property也不能滥用，而且@property的一个缺点就是无法被复用，同一套逻辑不能在不同的属性之间重复使用如果不停的编写@property方法，那就意味着当前这个类的代码写的确实很糟糕，此时应该重构了。

TODO

### 第31条: 用描述符来改写需要复用的 @property 方法

#### 备忘录

+ 如果想复用 @property 方法及其验证机制，那么可以自定义描述符类

+ WeakKeyDictionary 可以保证描述符类不会泄露内存

+ 通过描述符协议来实现属性的获取和设置操作时，不要纠结于`__getatttttribute__` 的方法的具体运作细节


`property `最大的问题是可能造成 duplicated code 这种 code smell。

下面的程式 `math_grade `以及 `math_grade `就有这样的问题。

```python
class Exam(object):
    def __init__(self):
        self._writing_grade = 0
        self._math_grade = 0

    @staticmethod
    def _check_grade(value):
        if not (0 <= value <= 100):
            raise ValueError('Grade must be between 0 and 100')

    @property
    def writing_grade(self):
        return self._writing_grade

    @writing_grade.setter
    def writing_grade(self, value):
        self._check_grade(value)
        self._writing_grade = value

    @property
    def math_grade(self):
        return self._math_grade

    @math_grade.setter
    def math_grade(self, value):
        self._check_grade(value)
        self._math_grade = value
```

可以使用 **descriptor **解決，下面的程式将重复的逻辑封装在 Grade 里面。但是這个程式根本 **不能用 **，因为存取到的是 class attributes，例如 `exam.writing_grade = 40 `其实是`Exam.__dict__['writing_grade'].__set__(exam, 40) `，这样所有 Exam 的 instances 都是存取到一样的东西 ( `Grade() `)。

```python
class Grade(object):
    def __init__(self):
        self._value = 0

    def __get__(self, instance, instance_type):
        return self._value

    def __set__(self, instance, value):
        if not (0 <= value <= 100):
            raise ValueError('Grade must be between 0 and 100')
        self._value = value

class Exam(object):
    math_grade = Grade()
    writing_grade = Grade()
    science_grade = Grade()

exam = Exam()
exam.writing_grade = 40
```

解決方式是用个 dictionary 存起來，这里使用 `WeakKeyDictionary `避免 memory leak。

```
from weakref import WeakKeyDictionary

class Grade(object):
    def __init__(self):
        self._values = WeakKeyDictionary()
    def __get__(self, instance, instance_type):
        if instance is None: return self
        return self._values.get(instance, 0)

    def __set__(self, instance, value):
        if not (0 <= value <= 100):
            raise ValueError('Grade must be between 0 and 100')
        self._values[instance] = value
```

### 第32条: 用 `__getattr__`, `__getattribute__`,  和`__setattr__` 实现按需生产的属性

#### 备忘录

+ 通过`__getttattr__` 和 `__setattr__`，我们可以用惰性的方式来加载并保存对象的属性
+ 要理解 `__getattr__` 和 `__getattribute__` 的区别：前者只会在待访问的属性缺失时触发，而后者则会在每次访问属性的时候触发
+ 如果要在`__getattributte__` 和 `__setattr__` 方法中访问实例属性，那么应该直接通过 super() 来做，以避免无限递归



- obj.name，getattr和hasattr都会调用__getattribute__方法，如果name不在obj.__dict__里面，还会调用__getattr__方法，如果没有自定义__getattr__方法会AttributeError异常
- 只要有赋值操作（=，setattr）都会调用__setattr__方法（包括a = A()）

`__getattr__ `和 `__getattribute__ `都可以动态地存取 attributes ，不同点在于如果 `__dict__ `找不到才会呼叫 `__getattr__ `，而 `__getattribute__ `每次都会被呼叫到。

```python
class LazyDB(object):
    def __init__(self):
        self.exists = 5

    def __getattr__(self, name):
        value = 'Value for %s' % name
        setattr(self, name, value)
        return value

class LoggingLazyDB(LazyDB):
    def __getattr__(self, name):
        print('Called __getattr__(%s)' % name)
        return super().__getattr__(name)

data = LoggingLazyDB()
print('exists:', data.exists)
print('foo:   ', data.foo)
print('foo:   ', data.foo)
```

```python
class ValidatingDB(object):
    def __init__(self):
        self.exists = 5

    def __getattribute__(self, name):
        print('Called __getattribute__(%s)' % name)
        try:
            return super().__getattribute__(name)
        except AttributeError:
            value = 'Value for %s' % name
            setattr(self, name, value)
            return value

data = ValidatingDB()
print('exists:', data.exists)
print('foo:   ', data.foo)
print('foo:   ', data.foo)
```

可以控制什么 attributes 不应该被使用到，记得要丟 **AttributeError **。

```python
try:
    class MissingPropertyDB(object):
        def __getattr__(self, name):
            if name == 'bad_name':
                raise AttributeError('%s is missing' % name)
            value = 'Value for %s' % name
            setattr(self, name, value)
            return value

    data = MissingPropertyDB()
    data.foo  # Test this works
    data.bad_name
except:
    logging.exception('Expected')
else:
    assert False
```

`__setattr__ `每次都会被呼叫到。

```python
class SavingDB(object):
    def __setattr__(self, name, value):
        # Save some data to the DB log
        pass
        super().__setattr__(name, value)

class LoggingSavingDB(SavingDB):
    def __setattr__(self, name, value):
        print('Called __setattr__(%s, %r)' % (name, value))
        super().__setattr__(name, value)
```



很重要的一点是 `__setattr__ `以及 `__getattribute__ `一定要呼叫父类的 `__getattribute__ `，避免无限循环下去。

这个会爆掉，因为存取 `self._data `又会呼叫 `__getattribute__ `。

```
class BrokenDictionaryDB(object):
    def __init__(self, data):
        self._data = {}

    def __getattribute__(self, name):
        print('Called __getattribute__(%s)' % name)
        return self._data[name]
```

呼叫 `super().__getattribute__('_data')`

```
class DictionaryDB(object):
    def __init__(self, data):
        self._data = data

    def __getattribute__(self, name):
        data_dict = super().__getattribute__('_data')
        return data_dict[name]
```

### 第33条: 用元类来验证子类

#### 备忘录

+ 通过元类，我们可以在生成子类对象之前，先验证子类的定义是否合乎规范
+ Python2 和 Python3 指定元类的语法略有不同

- 使用元类对类型对象进行验证
- Python 系统把子类的整个 class 语句体处理完毕之后，就会调用其元类的`__new__` 方法

### 第34条: 用元类来注册子类

#### 备忘录

+ 在构建模块化的 Python 程序时候，类的注册是一种很有用的模式

- 开发者每次从基类中继承子类的时，基类的元类都可以自动运行注册代码
- 通过元类来实现类的注册，可以确保所有子类都不会泄露，从而避免后续的错误

首先，定义元类，我们要继承 type, python 默认会把那些类的 class 语句体中所含的相关内容，发送给元类的 new 方法。

```python
class Meta(type):
    def __new__(meta, name, bases, class_dict):
        print(meta, name, bases, class_dict)
        return type.__new__(meta, name, bases, class_dict)

# 这是 python2 写法
class MyClassInPython2(object):
    __metaclass__ = Meta
    stuff = 123

    def foo(self):
        pass

# python 3
class MyClassInPython3(object, metaclass=Meta):
    stuff = 123

    def foo(self):
        pass


class ValidatePolygon(type):
    def __new__(meta, name, bases, class_dict):
        # Don't validate the abstract Polygon class
        if bases != (object,):
            if class_dict['sides'] < 3:
                raise ValueError('Polygons need 3+ sides')
        return type.__new__(meta, name, bases, class_dict)

class Polygon(object, metaclass=ValidatePolygon):
    sides = None  # Specified by subclasses

    @classmethod
    def interior_angles(cls):
        return (cls.sides - 2) * 180

class Triangle(Polygon):
    sides = 3

print(Triangle.interior_angles())
```

### 第35: 用元类来注解类的属性

#### 备忘录

+ 借助元类，我们可以在某个类完全定义好之前，率先修改该类的属性
+ 描述符与元类能够有效的组合起来，以便对某种行为做出修饰，或者在程序运行时探查相关信息

- 如果把元类与描述符相结合，那就可以在不使用 weakerf 模块的前提下避免内存泄露

## 五、并行与并发

### 第36条: 用 subprocess 模块来管理子进程

#### 备忘录

- 使用 subprocess 模块运行子进程管理自己的输入和输出流
- subprocess 可以并行执行最大化CPU的使用
- communicate 的 timeout 参数避免死锁和被挂起的子进程

最基本的

```python
import subprocess

proc = subprocess.Popen(
    ['echo', 'Hello from the child!'],
    stdout=subprocess.PIPE)
out, err = proc.communicate()
print(out.decode('utf-8'))
```

传入资料

```python
import os

def run_openssl(data):
    env = os.environ.copy()
    env['password'] = b'\xe24U\n\xd0Ql3S\x11'
    proc = subprocess.Popen(
        ['openssl', 'enc', '-des3', '-pass', 'env:password'],
        env=env,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE)
    proc.stdin.write(data)
    proc.stdin.flush()  # Ensure the child gets input
    return proc


def run_md5(input_stdin):
    proc = subprocess.Popen(
        ['md5'],
        stdin=input_stdin,
        stdout=subprocess.PIPE)
    return proc
```

模擬 **pipes**

```python
input_procs = []
hash_procs = []
for _ in range(3):
    data = os.urandom(10)
    proc = run_openssl(data)
    input_procs.append(proc)
    hash_proc = run_md5(proc.stdout)
    hash_procs.append(hash_proc)

for proc in input_procs:
    proc.communicate()
for proc in hash_procs:
    out, err = proc.communicate()
    print(out.strip())
```

### 第37条: 可以用线程来执行阻塞时I/O，但不要用它做平行计算

#### 备忘录

- 因为GIL，Python thread并不能并行运行多段代码
- Python保留thread的两个原因：1.可以模拟多线程，2.多线程可以处理I/O阻塞的情况
- Python thread可以并行执行多个系统调用，这使得程序能够在执行阻塞式I/O操作的同时，执行一些并行计算

### 第38条: 在线程中使用Lock来防止数据竞争

#### 备忘录

- 虽然Python thread不能同时执行，但是Python解释器还是会打断操作数据的两个字节码指令，所以还是需要锁
- thread模块的Lock类是Python的互斥锁实现

比较有趣的是 **Barrier **這个 Python 3.2 才加进来的东西，以前要用 **Semaphore **來做。

```python
from threading import Barrier
from threading import Thread
from threading import Lock

class LockingCounter(object):
    def __init__(self):
        self.lock = Lock()
        self.count = 0

    def increment(self, offset):
        with self.lock:
            self.count += offset

class LockingCounter(object):
    def __init__(self):
        self.lock = Lock()
        self.count = 0

    def increment(self, offset):
        with self.lock:
            self.count += offset

def worker(sensor_index, how_many, counter):
    # I have a barrier in here so the workers synchronize
    # when they start counting, otherwise it's hard to get a race
    # because the overhead of starting a thread is high.
    BARRIER.wait()
    for _ in range(how_many):
        # Read from the sensor
        counter.increment(1)

def run_threads(func, how_many, counter):
    threads = []
    for i in range(5):
        args = (i, how_many, counter)
        thread = Thread(target=func, args=args)
        threads.append(thread)
        thread.start()
    for thread in threads:
        thread.join()

BARRIER = Barrier(5)
counter = LockingCounter()
run_threads(worker, how_many, counter)
print('Counter should be %d, found %d' %
      (5 * how_many, counter.count))
```

### 第39条: 用 Queue 来协调各线程之间的工作

#### 备忘录

- 管线是一种优秀的任务处理方式，它可以把处理流程划分为若干阶段，并使用多条Python线程同时执行这些任务
- 构建并发式的管线时，要注意许多问题，包括：如何防止某个阶段陷入持续等待的状态之中、如何停止工作线程，以及如何防止内存膨胀等
- Queue类具备构建健壮并发管道的特性：阻塞操作，缓存大小和连接（join）

```python
from queue import Queue
from threading import Thread

class ClosableQueue(Queue):
    SENTINEL = object()

    def close(self):
        self.put(self.SENTINEL)

    def __iter__(self):
        while True:
            item = self.get()
            try:
                if item is self.SENTINEL:
                    return  # Cause the thread to exit
                yield item
            finally:
                self.task_done()


class StoppableWorker(Thread):
    def __init__(self, func, in_queue, out_queue):
        super().__init__()
        self.func = func
        self.in_queue = in_queue
        self.out_queue = out_queue

    def run(self):
        for item in self.in_queue:
            result = self.func(item)
            self.out_queue.put(result)
def download(item):
    return item

def resize(item):
    return item

def upload(item):
    return item

download_queue = ClosableQueue()
resize_queue = ClosableQueue()
upload_queue = ClosableQueue()
done_queue = ClosableQueue()
threads = [
    StoppableWorker(download, download_queue, resize_queue),
    StoppableWorker(resize, resize_queue, upload_queue),
    StoppableWorker(upload, upload_queue, done_queue),
]


for thread in threads:
    thread.start()
for _ in range(1000):
    download_queue.put(object())
download_queue.close()


download_queue.join()
resize_queue.close()
resize_queue.join()
upload_queue.close()
upload_queue.join()
print(done_queue.qsize(), 'items finished')
```

### 第40条: 考虑用协程来并发地运行多个函数

#### 备忘录

- 线程有三个大问题：

  - 需要特定工具去确定安全性
  - 单个线程需要8M的内存
  - 线程启动消耗

- coroutine只有1kb的内存消耗

- generator可以通过send方法把值传递给yield

  ```python
  def my_coroutine():
      while True:
          received = yield
          print("Received:", received)
  it = my_coroutine()
  next(it)
  it.send("First")
  ('Received:', 'First')

  ```

- Python2不支持直接yield generator，可以使用for循环yield

### 第41条: 考虑用 concurrent.futures 来实现真正的并行计算

#### 备忘录

- CPU瓶颈模块使用C扩展
- concurrent.futures的multiprocessing可以并行处理一些任务，Python2没有这个模块
- multiprocessing 模块所提供的那些高级功能，都特别复杂，开发者尽量不要直接使用它们

使用 `concurrent.futures ` 里面的 **ProcessPoolExecutor **可以很简单地平行处理 CPU-bound 的程式，省得用 `multiprocessing ` 自定义。

```python
from concurrent.futures import ProcessPoolExecutor

start = time()
pool = ProcessPoolExecutor(max_workers=2)  # The one change
results = list(pool.map(gcd, numbers))
end = time()
print('Took %.3f seconds' % (end - start))
```

## 六、内置模块

### 第42条: 用 functools.wraps 定义函数修饰器

#### 备忘录

- 装饰器可以对函数进行封装，但是会改变函数信息

- 使用 functools 的 warps 可以解决这个问题

  ```python
  def trace(func):
      @wraps(func)
      def wrapper(*args, **kwargs):
          # …
      return wrapper
  @trace
  def fibonacci(n):
      # …

  ```

### 第43条: 考虑用 contextlib 和with 语句来改写可复用的 try/finally 代码

#### 备忘录

- 使用with语句代替try/finally，增加代码可读性
- 使用 contextlib 提供的 contextmanager 装饰函数就可以被 with 使用
- with 和 yield 返回值使用

 `contextlib.contextmanager `，方便我们在做 **context managers **。

```python
from contextlib import contextmanager

@contextmanager
def log_level(level, name):
    logger = logging.getLogger(name)
    old_level = logger.getEffectiveLevel()
    logger.setLevel(level)
    try:
        yield logger
    finally:
        logger.setLevel(old_level)

with log_level(logging.DEBUG, 'my-log') as logger:
    logger.debug('This is my message!')
    logging.debug('This will not print')

logger = logging.getLogger('my-log')
logger.debug('Debug will not print')
logger.error('Error will print')
```

### 第44条: 用 copyreg 实现可靠的 pickle 操作

#### 备忘录

- pickle 模块只能序列化和反序列化确认没有问题的对象
- copyreg的 pickle 支持属性丢失，版本和导入类表信息

使用 `copyreg `這个内建的 module ，搭配 `pickle `使用。

`pickle `使用上很简单，假设我们有个 class:

```python
class GameState(object):
    def __init__(self):
        self.level = 0
        self.lives = 4

state = GameState()
state.level += 1  # Player beat a level
state.lives -= 1  # Player had to try again
```

可以用 `pickle `保存 object

```python
import pickle
state_path = '/tmp/game_state.bin'
with open(state_path, 'wb') as f:
    pickle.dump(state, f)

with open(state_path, 'rb') as f:
    state_after = pickle.load(f)
# {'lives': 3, 'level': 1}
print(state_after.__dict__)
```

但是如果增加了新的 field， `game_state.bin `load 回來的 object 当然不会有新的 field (points)，可是它仍然是 GameState 的 instance，这会造成混乱。

```python
class GameState(object):
    def __init__(self):
        self.level = 0
        self.lives = 4
        self.points = 0

with open(state_path, 'rb') as :
    state_after = pickle.load(f)
# {'lives': 3, 'level': 1}
print(state_after.__dict__)
assert isinstance(state_after, GameState)
```

使用 `copyreg `可以解決这个问题，它可以注册用來 serialize Python 物件的函式。

##### Default Attribute Values

`pickle_game_state() ` 返回一个 tuple ，包含了拿來 unpickle 的函式以及传入函式的引数。

```python
import copyreg

class GameState(object):
    def __init__(self, level=0, lives=4, points=0):
        self.level = level
        self.lives = lives
        self.points = points

def pickle_game_state(game_state):
    kwargs = game_state.__dict__
    return unpickle_game_state, (kwargs,)

def unpickle_game_state(kwargs):
    return GameState(**kwargs)

copyreg.pickle(GameState, pickle_game_state)
```

##### Versioning Classes

`copyreg `也可以拿來记录版本，达到向后相容的目的。

如果原先的 class 如下

```python
class GameState(object):
    def __init__(self, level=0, lives=4, points=0, magic=5):
        self.level = level
        self.lives = lives
        self.points = points
        self.magic = magic

state = GameState()
state.points += 1000
serialized = pickle.dumps(state)
```

后来修改了，拿掉 lives ，这时原先使用预设参数的做法不能用了。

```python
class GameState(object):
    def __init__(self, level=0, points=0, magic=5):
        self.level = level
        self.points = points
        self.magic = magic

# TypeError: __init__() got an unexpected keyword argument 'lives'
pickle.loads(serialized)
```

在 serialize 时多加上版本号， deserialize 时加以判断

```python
def pickle_game_state(game_state):
    kwargs = game_state.__dict__
    kwargs['version'] = 2
    return unpickle_game_state, (kwargs,)

def unpickle_game_state(kwargs):
    version = kwargs.pop('version', 1)
    if version == 1:
        kwargs.pop('lives')
    return GameState(**kwargs)

copyreg.pickle(GameState, pickle_game_state)
```

##### Stable Import Paths

重写程式时，如果 class 改名了，想要 load  的 serialized 物件当然不能用，但还是可以使用 `copyreg `解決。

```python
class BetterGameState(object):
    def __init__(self, level=0, points=0, magic=5):
        self.level = level
        self.points = points
        self.magic = magic

copyreg.pickle(BetterGameState, pickle_game_state)
```

可以发现 `unpickle_game_state() `的 path 进入 dump 出來的资料中，当然这样做的缺点就是 `unpickle_game_state() `所在的 module 不能改 path 了。

```python
state = BetterGameState()
serialized = pickle.dumps(state)
print(serialized[:35])
>>>
b'\x80\x03c__main__\nunpickle_game_state\nq\x00}'
```

### 第45条: 用 datetime 替代 time 来处理本地时间

#### 备忘录

- 不要使用time模块在转换不同时区的时间
- 而用datetime配合 pytz 转换
- 总数保持UTC时间，最后面再输出本地时间

### 第46条: 使用内置算法与数据结构

#### 备忘录

+ 使用 Python 内置的模块来描述各种算法和数据结构
+ 开发者不应该自己去重新实现他们，因为我们很难把它写好

内置算法和数据结构

- collections.deque

- collections.OrderedDict

- collection.defaultdict

- heapq模块操作list（优先队列）：heappush，heappop和nsmallest

  ```python
  a = []
  heappush(a, 5)
  heappush(a, 3)
  heappush(a, 7)
  heappush(a, 4)
  print(heappop(a), heappop(a), heappop(a), heappop(a))
  # >>>
  # 3 4 5 7

  ```

- bisect模块：bisect_left可以对有序列表进行高效二分查找

- itertools模块（Python2不一定支持）：

  - 连接迭代器：chain，cycle，tee和zip_longest
  - 过滤：islice，takewhile，dropwhile，filterfalse
  - 组合不同迭代器：product，permutations和combination

### 第47 条: 在重视 精确度的场合，应该使用 decimal

#### 备忘录

- 高精度要求的使用 Decimal 处理，如对舍入行为要求很严的场合，eg: 涉及货币计算的场合

### 第48条: 学会安装由 Python 开发者社区所构建的模块

- 在 https://pypi.python.org 查找通用模块，并且用pip安装

## 七、协作开发

### 第49条: 为每个函数、类和模块编写文档字符串

### 第50条: 用包来安排模块，并提供稳固的 API

### 第51条: 为自编的模块定义根异常，以便将调用者与 API 相隔离

### 第52条: 用适当的方式打破循环依赖问题

### 第53条: 用虚拟环境隔离项目，并重建其依赖关系

## 八、部署

### 第54条: 考虑用模块级别的代码来配置不同的部署环境

### 第55条: 通过 repr 字符串来输出调试信息

#### 备忘录

- repr作用于内置类型会产生可打印的字符串，eval可以获得这个字符串的原始值
- __repr__自定义上面输出的字符串

### 第56条: 用 unittest 来测试全部代码

#### 备忘录

- 使用unittest编写测试用例，不光是单元测试，集成测试也很重要
- 继承TestCase，并且每个方法名都以test开始

### 第57条: 考虑用 pdb 实现交互调试

#### 备忘录

- 启用pdb，然后在配合shell命令调试 import pdb; pdb.set_trace();

### 第58条: 先分析性能再优化

- cProfile 比 profile更精准
  - ncalls:调用次数
  - tottime:函数自身耗时，不包括调用函数的耗时
  - cumtime:包括调用的函数耗时

### 第59条: 用 tracemaloc 来掌握内存的使用及泄露情况

#### 备忘录

- gc模块可以知道有哪些对象存在，但是不知道怎么分配的
- tracemalloc可以得到内存的使用情况，但是只在Python3.4及其以上版本提供

### 参考书籍

[代码](https://github.com/ihongChen/Effective-python-ex)

[Effective Python(英文版) PDF](https://pan.baidu.com/s/19nMcvcWgPMe8Ayo1hqCj9w)  密码: 7v9r

[Effecttive Python(中文不完整非扫描版) PDF](https://pan.baidu.com/s/1tgvmcKLSIHuG37jLpbyQMg)  密码: 86bm

[Effective Python(中文扫描版) PDF](https://pan.baidu.com/s/1_1oXO_Dd2Kvl7qPYdPeJ6g)   密码: dg7w
