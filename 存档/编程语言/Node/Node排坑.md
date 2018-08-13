# Node 排坑

**1. callback**

事件回调是nodejs非常常见的一个应用场景，那大家先来看看以下这段代码是否存在什么问题？

```
get(params, function(err, data) {
  if (err) {
   callback(err);
 }
 //对data进行操作
 var row = data[0];
});
```

看出来了吧。对，就是err存在时，callback之后，接下来的代码还是要执行的。而这时，data值是什么，我们往往是没办法控制的。如果data这时返回的是undefined，那么就悲剧了，程序肯定报错。当然解决方法很简单，就是在callback之前加个return即可：

```
get(params, function(err, data) {
  if (err) {
    return callback(err);
  }
 //对data进行操作
 var row = data[0];
});
```

这个知识点并不是很难，但往往是初学者特别容易犯的错，甚至已经写了很久代码的同学也会偶尔犯这种低级错误。

再来一个更隐蔽的：

```
db.get(key, function(err, data) {
  if (err) {
    return callback(err);
  }
  try {
    callback(null, JSON.parse(data.toString()))
  } catch(e) {
    callback(e);
  }
});
```

看似没有任何问题吧。嘿嘿，揭晓答案， 对，被回调两次。callback(null, Error)一次，callback(e)，具体比如：

```
function asyncfun(data, callback) {
  try {
    callback(null, JSON.parse(data.toString()));
  } catch (e) {
    callback(e);
  }
}
var json = {'a': 'b'};
var jsonstr = JSON.stringify(json);
var d = new Buffer(jsonstr);

asyncfun(d, function(err, data) {
  console.log(err);
  throw new Error('new Error');
});
```

运行结果：

```
null
[Error: new Error]
```

这在一个大项目绝对是坑爹了，排错都需要很久。

ps:之前的描述存在问题，谢谢[苏千](http://cnodejs.org/user/suqian)的指正。

**2. buffer**

还是老规矩，先看代码：

```
var data = "";  
res.on('data', function (chunk) {  
  data += chunk;  
})  
.on("end", function () {  
});
```

这段代码在chunk都是ascii码数据或者数据量比较少时是没有问题，但如果你的数据是大量中文的话，恭喜你，中枪了，会出现乱码。其原因是两个chunk（Buffer对象）的拼接并不正常，相当于进行了buffer.toString() + buffer.toString()。如果buffer不是完整的，则toString出来后的string是存在问题的（比如一个中文字被截断）。具体可以参见[朴灵](http://cnodejs.org/user/Jackson)写得这篇文章：<http://cnodejs.org/topic/4faf65852e8fb5bc65113403>

**3. 深度嵌套**

很多刚开始写nodejs代码的人，由于思路还停留在同步的思维，所以或多或少写过这样的代码：

```
func1(err, function(err1, data1) {
  func2(err1, function(err2, data2) {
    func3(err3, function(err3, data3) {
      func4(err4, function(err4, data4) {
        .......
      })
    })
  })
})
```