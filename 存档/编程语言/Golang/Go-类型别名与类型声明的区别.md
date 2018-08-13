### 语法
```go
type D = int   // 类型别名
type I int    // 类型声明
```
注：类型别名有一个等号，类型声明没有等号
### 区别

**类型别名和原类型完全一样，只不过是另一种叫法而已，而类型定义和原类型是不同的两个类型。**   
看如下例子:
```go
package main

type D = int
type I int

func main() {
	v := 100
	var d D = v    // 不报错
	var i I = v    // 报错
}

```
