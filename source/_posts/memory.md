---
title: store of data
date: 2020-07-23 21:47:49
tags:
---

### 栈内存与堆内存如何存储数据

值类型的数据通常保存在栈中，栈空间用来保存执行上下文
引用类型的数据通常保存在堆中，并且在栈中留下引用

栈空间需要用来维护程序执行期间执行上下文的状态，为了提高执行上下文的切换效率，栈的空间一定要相对来说较小

### 闭包的内存模型
```javascript
function foo() {
    var myName = " 极客时间 "
    let test1 = 1
    const test2 = 2
    var innerBar = { 
        setName:function(newName){
            myName = newName
        },
        getName:function(){
            console.log(test1)
            return myName
        }
    }
    return innerBar
}
var bar = foo()
bar.setName(" 极客邦 ")
bar.getName()
console.log(bar.getName())
```


1.首先会创建一个全局执行上下文
2.执行到foo函数时，会先进行编译，创建foo函数的执行上下文
3.遇到内部函数时，还要对内部函数做一个快速的词法扫描，内部函数引用了外部变量，在堆内存中创建一个closure闭包对象，这个对象会同时包含值与引用2种数据
4.这个closure对象保存在变量环境中，由于闭包的特殊性，即使函数执行完毕了，但是返回的对象中的函数依然保留了它的引用

产生闭包的核心：
第一步是需要预扫描内部函数；
第二步是把内部函数引用的外部变量保存到堆中


执行上下文的销毁过程：
关于foo函数执行上下文销毁过程：foo函数执行结束之后，当前执行状态的指针下移到栈中的全局执行上下文的位置，foo函数的执行上下文的那块数据就挪出来，这也就是foo函数执行上下文的销毁过程，这个文中有提到，你可以参考“调用栈中切换执行上下文状态“图。

第二个问题：innerBar返回后，含有setName和getName对象，这两个对象里面包含了堆中的closure(foo)的引用。虽然foo执行上下文销毁了，foo函数中的对closure(foo)的引用也断开了，但是setName和getName里面又重新建立起来了对closure(foo)引用

### 执行上下文如何切换
只需要将指针下移到上个执行上下文的地址就可以了，当前执行上下文栈区空间全部回收，堆中的数据依然保留
