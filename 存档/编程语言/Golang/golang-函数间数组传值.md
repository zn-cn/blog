### 问题：

eg: 

```go
func sliceModify(slice []int) {
    // slice[0] = 88
    slice = append(slice, 6)
}
func main() {
    slice := []int{1, 2, 3, 4, 5}
    sliceModify(slice)
    fmt.Println(slice)
}
```

out: `[1` `2` `3` `4` `5]`

虽然说数组切片在函数传递时是按照引用的语义传递的，比如说在 sliceModify 函数里面 slice[0] = 88，在方法调用的上下文中，调用函数对slice引用的改表是看得见的。

*但是在对slice进行append操作的时候，返回的是新的引用，并非原始引用。*

### 解决：

**传递指针的指针**

eg: 

```go

func sliceModify(slice *[]int) {
    *slice = append(*slice, 6)
}
func main() {
    slice := []int{1, 2, 3, 4, 5}
    sliceModify(&slice)
    fmt.Println(slice)
}
```

 out: `[1` `2` `3` `4` `5` `6]`
