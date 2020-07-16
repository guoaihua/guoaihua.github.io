---
title: javascript 执行上下文与调用栈
date: 2020-07-16 22:50:27
tags:
---

### 概念

执行上下文：js执行一段代码时的运行环境。

调用栈：是一种用来管理函数之间调用关系的数据结构。


### 执行上下文
代码先进行编译后执行，编译的时候就会产生可执行代码与执行上下文。
词法分析->语法分析->代码生成

创建执行上下文的三种情况：
1.执行全局代码时，会生成全局上下文，整个页面的生命周期内，全局上下文唯一
2.函数被调用时，函数体内的代码会被编译，创建函数执行上下文，无闭包的话使用完之后就被销毁
3.eval被执行时，eval内的代码被编译，创建执行上下文

### 调用栈

JavaScript引擎使用栈的结构来管理执行上下文
```javascript
var a = 2
function add(b,c){
  return b+c
}
function addAll(b,c){
var d = 10
result = add(b,c)
return  a+result+d
}
addAll(3,6)
```

第一步： 代码编译，创建全局上下文，并将其压入栈底
![](/images/stack_1.png)

第二步： 调用addAll函数，编译addAll函数并创建函数执行上下文，将它压入栈中

第三步： 执行addAll函数，到add函数时，编译add函数并创建执行上下文，压入栈中

第四部：执行add函数，返回结果，将add函数弹出栈

第五步：addAll函数中拿到result结果，返回结果，将addAll上下文也弹出

第六步： 返回结果，执行完毕


### 栈溢出

栈的最大容量和深度都是有限制的，超出限制，就会抛出错误
```javascript
Maximum call stack size exceeded
```
