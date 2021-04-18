---
title: understand  this & scope chain
date: 2020-07-22 22:17:03
tags:
---

### this
执行上下文中除了变量环境、词法环境、outer还有this，this是和执行上下文绑定的
在对象内部方法中使用对象内部的属性。作用域链与this是2个独立的不同的系统

### 判断要数
this 的绑定和函数声明的位置无关，只取决于函数的调用方式,看它真实的调用的对象.
```javascript
function foo(){
    var a = 1;
    bar(); // ReferenceError 这里是全局作用域 this指向window
}

function bar(){
    console.log(a);
}
foo();

```
变量的查找与this无关，这里bar函数中的a，查找过程是通过作用域链查找的，向上只能到全局作用域


### this的绑定
1.默认绑定
独立的函数调用，无法调用其他规则时的默认规则
```javascript
function foo(){
    console.log(this.a); // 2
}
var a = 2;
foo();

这里的foo没有任何修饰符，使用了默认绑定，this指向全局window
但是如果是严格模式，this并不指向window，而是undefined

function foo(){
    'use strict'
    console.log(this.a); // TypeError this is undefined
}
var a = 2;
foo();

```

注意第三方库的strict应用范围,foo在非严格模式 this会绑定到全局，调用foo不影响默认绑定

```javascript
function foo(){
    console.log(this.a); // 2
}
var a = 2;

(function(){
    'use strict'
    foo();
})();
```
2.隐式绑定
当函数引用有上下文对象时，隐式绑定规则会将this绑定到这个上下文对象上，对象属性引用链只有上一层或者说最后一层起作用
```javascript

function foo() {
  console.log(this.a);
}

var obj2 = {
    a: 42,
    foo: foo
}

var obj1 = {
    a:2,
    obj2:obj1
}

obj1.obj2.foo(); // 42

```

隐式丢失，传入回调函数时常发生

```javascript

function foo(){
    console.log(this.a);
}

var bar = {
    a : 1,
    foo: foo
}

var a = 2;


function doFoo(fn){
    fn();
}


doFoo(bar.foo); //2

```
bar.foo 实际上指向的是foo函数本身， 函数传参其实一种隐式赋值，这里doFoo使用了默认绑定规则，this指向了widow

3.显示绑定

使用call apply显示的将函数的this绑定到某一个对象
```javascript
function foo(){
    console.log(this.a);
}

var obj = {
    a: 2
}

foo.call(obj);//2

如果传入了一个原始值、字符创、布尔、数值 来作为this的绑定对象，会先进行装箱
```
硬绑定
```javascript
function foo(){
    console.log(this.a);
}


var bar = {
    a : 1,
    foo: foo
}


var a = 2;

//setTimeout(bar.foo);// 会产生绑定隐式丢失


//创建一个baz将foo的this强制绑定到bar
function baz(){
    foo.call(bar);
}

//同 Function.prototype.bind

setTimeout(baz);//1
```
4.new 绑定
  调用new 发生什么？
  
  1.创建一个新对象
  2.执行[[Prototype]]链接
  3.将新对象绑定到函数调用的this
  4.如果没有其它返回则返回这个新对象
  
  var obj = {};
  obj.__proto__ = foo.prototype;
  foo.call(obj);
  return obj;
  
  调用new 时， this绑定到新创建的对象上
```javascript
function foo(){
    this.a = 2;
}
var bar = new foo();// this->bar
bar.a;//2

```

优先级：

默认绑定优先级最低。

显示绑定与隐式绑定：显示绑定优于隐式绑定
```javascript
function foo(){
    console.log(this.a);
}

var bar = {
    a:1,
    foo:foo
}

var baz = {
    a:2,
    foo:foo
}

//隐式
bar.foo(); // 1
baz.foo(); // 2

// 显示

bar.foo.call(baz); // 2
baz.foo.call(bar); // 1
```

隐式与new 绑定
```javascript
function foo(s){
    this.a = s;
}

var bar = {
    foo:foo
}

bar.foo(2);
bar.a;//2

var baz = new bar.foo(4);
baz.a;//4
```

new --> 显示、硬绑定--> 隐式绑定-->默认绑定

绑定例外：

当不关注this指向的时候，可以传入null，此时会使用默认绑定规则
```javascript
foo.apply(null,[1,2,3])
```

安全的this
防止this指向全局，我们可以传入一个安全的对象
```javascript
var ø = Object(null);
foo.apply(ø,[1,2,3]);
```

箭头函数不受四种规则影响，它根据外层作用域的this决定

### 注意点
1.当函数作为对象的方法调用时，函数中的 this 就是该对象；
2.当函数被正常调用时，在严格模式下，this 值是 undefined，非严格模式下 this 指向的是全局对象 window；
3.嵌套函数中的 this 不会继承外层函数的 this 值
```javascript
var myObj = {
  name : " 11 ", 
  showThis: function(){
    console.log(this)
    function bar(){console.log(this)}
    bar(); 
  }
}
myObj.showThis()
```
bar函数中的this被默认绑定到了window上面，它的调用对象可以看做是window
解决方法self = this利用闭包构建作用域链；或者箭头函数
