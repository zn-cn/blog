> 由于笔者后台使用的是flask框架接收和前端使用的是原生的JavaScript和jQuery的ajax发送，能力有限，在此仅写下我开发项目过程中所得，欢迎指正交流。
## 一、flask中的json数据接收
### 1、利用flask的request.form.get()方法
Python后台部分代码
```python
from flask import Flask
from flask import jsonify
from flask import request
import json
...

# 登录
@app.route("/flask/login", methods=['POST'])
def login():
    data_ = request.form.get('data')
    data = json.loads(data)
    username = data['username']
    password = data['password']
    rem = False
    if data['remember']:
        rem = True
    return jsonify({"login": Login.login(username, password, rem)})  # 返回布尔值
```
### 2、 利用flask的request.get_data()方法
Python后台代码
```python
from flask import Flask
from flask import jsonify
from flask import request
import json
...

# 登录
@app.route("/flask/login", methods=['POST'])
def login():
    data = request.get_data()
    data = json.loads(data)
    username = data['username']
    password = data['password']
    rem = False
    if data['remember']:
        rem = True
    return jsonify({"login": Login.login(username, password, rem)})  # 返回布尔值
```
### 3、利用flask的request.get_json()方法
Python后台代码
```python
from flask import Flask
from flask import jsonify
from flask import request

...

# 登录
@app.route("/flask/login", methods=['POST'])
def login():
    data = request.get_json()
    username = data['username']
    password = data['password']
    rem = False
    if data['remember']:
        rem = True
    return jsonify({"login": Login.login(username, password, rem)})  # 返回布尔值
```
## 二、前端发送json数据
### 1、原生XMLHttp发送
``` JavaScript
function login() {
    var username =document.getElementById("username").value;
    var password = document.getElementById("password").value;
    var remember =document.getElementById("remember").checked;
    var xmlhttp;
    if (window.XMLHttpRequest)
    {
        //  IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
        xmlhttp=new XMLHttpRequest();
    }
    else
    {
        // IE6, IE5 浏览器执行代码
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState===4 && xmlhttp.status===200)
        {
           ...
        }
    };

    xmlhttp.open("POST","/flask/login",true);
    xmlhttp.setRequestHeader("Content-type","application/json");
    // 后面这两部很重要，我看网上很多都是使用xmlhttp.send("username="+username+"&password="+"),这样接收还要解析一番感觉还是直接发送以下格式的好些
    var data = {
        "username": username
        "password": password
        "remember": remember
    };
    var data_json = JSON.stringify(data);
    xmlhttp.send(data_json);
}
```
附：json数据解析
``` JavaScript
   var text = xmlhttp.responseText;
   //  通过eval() 方法将json格式的字符串转化为js对象，并进行解析获取内容
   var result = eval("("+text+")");
   if (result) {
                
     } else {
                alert("请输入正确的用户名和密码");
            }
```
### 2、ajax发送
``` ajax
 $(document).ready(function () {
    var data = {
    "username": "adamin",
    "password": "123456789",
    "remember": true
    }
    $.ajax({
        url: "/flask/login",
        type: "POST",
        data: data,
        success: function () {
            
        }
    })
    })
```
