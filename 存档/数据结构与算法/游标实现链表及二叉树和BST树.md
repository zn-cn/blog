代码地址：https://github.com/tofar/data-structure/tree/master/code/cursor
### 1. 链表的游标实现

诸如BASIC和FORTRAN等许多语言都不支持指针。如果需要链表而又不能使用指针，这时我们可以使用游标（cursor）实现法来实现链表。

在链表的实现中有两个重要的特点：

1. 数据存储在一组结构体中。每一个结构体包含有数据以及指向下一个结构体的指针。
2. 一个新的结构体可以通过调用malloc而从系统全局内存（global memory）得到，并可以通过free而被释放。

游标法必须能够模仿实现这两条特性:

**满足条件1的逻辑方法是要有一个全局的结构体数组（模拟系统全局内存）。对于数组中的任何单元，其数组下标可以用来代表一个地址。**

```
typedef int PtrToNode;
typedef PtrToNode List;
typedef PtrToNode Position;

struct Node {
    ElementType Element;
    Position Next;
};
struct Node cursor_space[ SPACE_SIZE ];
```

作为备用单链表，用来malloc或free游标可用空间，该表用0作为表头。刚开始时，freelist就是整个结构体数组。**0指向的为空余空间的下标，若0指向0则表示没有空余空间。**

需要理解的是：所有的链表，包括备用表和已用表，全部都在我们定义的全局结构体数组中，只是它们的表头不同，从不同的表头出发形成了不同的单链表。

假设我们定义了一个大小为11的游标空间，其初始化状态如下：

| Slot | Element | Next |
| ---- | ------- | ---- |
| 0    |         | 1    |
| 1    |         | 2    |
| 2    |         | 3    |
| 3    |         | 4    |
| 4    |         | 5    |
| 5    |         | 6    |
| 6    |         | 7    |
| 7    |         | 8    |
| 8    |         | 9    |
| 9    |         | 10   |
| 10   |         | 0    |

**注：对于Next， 0的值等价于NULL指针。**

上面的状态用链表形式表示为：cursor_space[0]—>cursor_space[1]—>cursor_space[2]—>cursor_space[3]—>cursor_space[4]—>cursor_space[5]—>cursor_space[6]—>cursor_space[7]—>cursor_space[8]—>cursor_space[9]—>cursor_space[10]—>NULL.

为执行malloc功能，将（在表头后面的）第一个元素从freelist中删除。为了执行free功能，我们将该单元放在freelist的前端。

malloc和free的游标实现如下：

```
/*cursor_alloc*/
Position cursor_alloc( void )
{
    Position p;
    p = cursor_space[0].Next;
    cursor_space[0].Next = cursor_space[p].Next;
    return p;  // 返回开辟空间，0永远指向空余空间
}
/*cursor_free*/
void cursor_free( Position p )
{
    cursor_space[p].Next = cursor_space[0].Next;
    cursor_space[0].Next = p;
}
```

为加深理解，请参考如下实例: 

| Slot | Element | Next |
| ---- | ------- | ---- |
| 0    | -       | 6    |
| 1    | b       | 9    |
| 2    | f       | 0    |
| 3    | header  | 7    |
| 4    | -       | 0    |
| 5    | header  | 10   |
| 6    | -       | 4    |
| 7    | c       | 8    |
| 8    | d       | 2    |
| 9    | e       | 0    |
| 10   | a       | 1    |

如果单链表L的值是5，M的值是3，我们又规定了freelist表头为0，因此，从上表中我们可以得到三个链表：

freelist：cursor_space[0]—>cursor_space[6]—>cursor_space[4]—>NULL 

L：header—>a—>b—>e—>NULL

M：header—>c—>d—>f—>NULL

freelist是分配L、M链表后还剩余的可分配空间。

游标实现

```
/* return ture if L is empty */
int isempty(list L)
{
    return cursor_space[L].next = 0;
}
```

```
/* return true if P is the last position in list L */

int islast(position p, list L)
{
    return cursor_space[P].next == 0;
}
```

```
/* return position of X in L; 0 if not found */
/* uses a header node */

position find(element_type X, list L)
{
    position p;
    
    p = cursor_space[L].next;
    while(p && cursor_space[p].element != X)
        p = cursor_space[p].next;
    
    return p;
}
```

```
/* delete first occurence of X from a list */
/* assume use of a header node */

void delete(element_type X, list L)
{
    position p, tmpcell;
    
    p = find_previous(X, L);
    
    if(!islast(p, L))
    {
        tmpcell = cursor_space[p].next;
        cursor_space[p].next = cursor_space[tmpcell].next;
        cursor_free(tmpcell);
    }
}
```

```
/* insert (after legal position P) */

void insert(element_type X, list L, position P)
{
    position tmpcell;
    
    tmpcell = cursor_alloc();
    if(tmpcell == 0)
        fatal_error("out of sapce!!!");

    cursor_space[tmpcell].element = X;
    cursor_space[tmpcell].next = cursor_space[P].next;
    cursor_space[P].next = tmpcell;
}
```

### 2. 二叉树

```
typedef struct tREE
{
  int data;
  int left;
  int right;
} TREE;
```

和链表实现类似，再定义一个全局数组 tr[ ] 即可。

### 3. BST树

**BST：**即二叉搜索树：

1. 所有非叶子结点至多拥有两个儿子（Left和Right）；

2. 所有结点存储一个关键字；

3. 非叶子结点的左指针指向小于其关键字的子树，右指针指向大于其关键字的子树；

   ![img](http://upload-images.jianshu.io/upload_images/7109326-628b6a7b9aaf4b91.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   **二叉树定义：**

   ```
   //define a tree using cursors
   typedef struct tREE
   {
     int data;
     int left;
     int right;
   } TREE;
   ```

   **寻找最小节点：**

   ```
   //找到最小的节点
   static int find_min (int root)
   {
     if (tr[root].left < 0)
       return (root);

     return (find_min (tr[root].left));
   }
   ```

   ​

   **插入:**

   ```
   //插入
   static int insert (int root, int i)
   {
     if (root < 0)
     {
       return (i);
     }

     if (tr[i].data < tr[root].data)
       tr[root].left =  insert (tr[root].left, i) ;
     else if (tr[i].data > tr[root].data)
       tr[root].right = insert (tr[root].right, i) ;

     return (root);
   }
   ```

   **删除:**

   ```
   //删除节点i
   static int delete (int root, int i)
   {
     int tmp;

     if (root < 0)
       return (-1);

     if (tr[i].data < tr[root].data)
       tr[root].left = delete (tr[root].left, i);
     else if (tr[i].data > tr[root].data)
       tr[root].right = delete (tr[root].right, i);
     else if (tr[root].left > 0 && tr[root].right > 0)
     {
       tmp = find_min (tr[root].right);
       tr[root].data = tr[tmp].data;
       tr[root].right = delete (tr[root].right, tmp);
     }
     else if (tr[root].left > 0)
       return (tr[root].left);
     else
       return (tr[root].right);

     return (root);
   }
   ```

