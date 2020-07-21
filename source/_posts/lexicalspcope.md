---
title: lexicalspcope & 闭包
date: 2020-07-21 22:01:59
tags:
---

### 作用域链

每个执行上下文中的变量环境中都包含了一个外部应用，用来指向外部引用，我们称之为outer
```javascript
function bar() {
    console.log(myName)
}
function foo() {
    var myName = " 111 "
    bar()
}
var myName = " 22 "
foo()
```
执行到bar的console时，先从bar执行环境中的词法环境中查找变量，没有则从变量环境中查找，仍然没有，
通过外部引用查找，这个outer指向了全局执行上下文，获取到myName 22

词法环境->变量环境->外部引用->全局环境的查找链，就叫做作用域链

### 词法作用域
词法作用域又称静态作用域，因为它是由代码中函数生成的位置决定的，与其它无关，可以预测代码执行过程中如何查找标识符

词法作用域定义了变量环境中outer 的指向

bar中外部引用根据词法作用域指向了全局执行上下文而不是foo的执行上下文

### 块级作用域中的变量查找

```javascript
function bar() {
    var myName = " 极客世界 "
    let test1 = 100
    if (1) {
        let myName = "Chrome 浏览器 "
        console.log(test)
    }
}
function foo() {
    var myName = " 极客邦 "
    let test = 2
    {
        let test = 3
        bar()
    }
}
var myName = " 极客时间 "
let myAge = 10
let test = 1
foo()
```

![](/images/lexicalscope.png)


### 闭包
词法作用域规定，内部函数总是可以访问外部函数中声明的变量。
当调用一个外部函数返回内部函数，即使外部函数已经执行完了，但是内部函数引用外部函数的变量依然
保存在内存中，这些变量的集合称为闭包，
```javascript
function foo() {
    var myName = " 极客时间 "
    let test1 = 1
    const test2 = 2
    var innerBar = {
        getName:function(){
            console.log(test1)
            return myName
        },
        setName:function(newName){
            myName = newName
        }
    }
    return innerBar
}
var bar = foo()
bar.setName(" 极客邦 ")
bar.getName()
console.log(bar.getName())
```

即使foo执行完毕，但是它返回的innerbar 对象包含了foo内部的引用，test1、myName
当执行到 bar.setName 方法中的myName = "极客邦"这句代码时，JavaScript 引擎会沿着“当前执行上下文–>foo 函数闭包–> 全局执行上下文”的顺序来查找 myName 变量，你可以参考下面的调用栈状态图

首先是setName的执行上下文中查找myName,然后在它的变量环境中通过外部引用找到foo的闭包
![](/images/lexicalscope_2.png)

### 思考

1.变量的查找流程？
2.理解词法作用域、作用域链、闭包
3.
```javascript
var bar = {
    myName:"time.geekbang.com",
    printName: function () {
        console.log(myName)
    }    
}
function foo() {
    let myName = " 极客时间 "
    return bar.printName
}
let myName = " 极客邦 "
let _printName = foo()
_printName()
bar.printName()
```
