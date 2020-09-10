---
title: inherit
date: 2020-09-10 22:36:43
tags:
---


### 经典继承
借用构造函数
```javascript
    // 经典继承
    function Super(name){
        this.name = name;
        this.colors = ['red', 'green', 'white'];
    }

    Super.prototype.say= function () {
        console.log(this.name);
    }


    function Sub(name) {
        Super.call(this,name);
    }

    var a = new Sub("a");
    a.colors.push("yellow");
    var b = new Sub("b");

    console.log(a);//  colors: (4) ["red", "green", "white", "yellow"]  name: "a"
                    
                     
    console.log(b);//  colors: (4) ["red", "green", "white""]  name: "b"
    
    a.say(); //  Uncaught TypeError: a.say is not a function
```

优点： 隔离了超类的共享属性
缺点： 无法复用父类原型方法

### 原型链继承
原型链

```javascript

    // 原型链继承
    function Super(name){
        this.name = name;
        this.colors = ['red', 'green', 'white'];
    }

    Super.prototype.say= function () {
        console.log(this.name);
    }


    function Sub(name) {
       this.name = name
    }
    
    Sub.prototype = new Super();


    var a = new Sub();
    a.colors.push("yellow");
    var b = new Sub();
    
    
    console.log(a.__proto__); //  colors: (4) ["red", "green", "white", "yellow"] 
    console.log(b.__proto__);//  colors: (4) ["red", "green", "white", "yellow"] 
    a.say(); // 'a'
```

优点：继承了超类原型方法
缺点：超类中的引用属性做不到隔离

### 组合试继承
结合经典继承与原型链继承

```javascript
    // 组合式继承
    function Super(name){
        this.name = name;
        this.colors = ['red', 'green', 'white'];
    }

    Super.prototype.say= function () {
        console.log(this.name);
    }


    function Sub(name,age) {
        Super.call(this,name);
        this.age = age;
    }

    Sub.prototype = new Super();


    var a = new Sub("a",21);
    a.colors.push("yellow");
    var b = new Sub("b",22);


    console.log(a); // age: 21
                     //  colors: (4) ["red", "green", "white", "yellow"]
                      // name: "a"
    console.log(b); //age: 22
                     // colors: (3) ["red", "green", "white"]
                    //  name: "b"
    a.say(); // ‘a’
```
优点：隔离超类引用类型属性，复用原型方法
缺点：超类构造函数被调用2次


### 寄生式

```javascript
    // 原型链继承

    var Super = {
        name: '12',
        colors:['red', 'green', 'white']
    }

    function Sub(obj) {
    
    	// 等价于 var f = function(){}; f.prototype = obj; var o = new f();
        var a = Object.create(obj); 
        // 增强对象，增加属性方法
        
        // new 对象的本质
        
       // 1.new 一个新对象
       // 2.obj.__proto__ = 构造函数.原型 
       // 3.执行构造函数，call(this,arguments);
       // 4.返回这个对象
        
        
        // 通过new 方法，默认返回this 指向Sub的原型，这里强制覆盖
        return a
    }



    var a = new Sub(Super);
    a.colors.push("yellow");
    var b = new Sub(Super);

    console.log(a.__proto__); //  colors: (4) ["red", "green", "white", "yellow"] 
    console.log(b.__proto__);//  colors: (4) ["red", "green", "white", "yellow"] 
```

### 寄生组合式

```javascript
    // 寄生组合式继承
    function Super(name){
        this.name = name;
        this.colors = ['red', 'green', 'white'];
    }

    Super.prototype.say= function () {
        console.log(this.name);
    }


    function Sub(name,age) {
        Super.call(this,name);
        this.age = age;
    }

    function inheritPrototype(Sub, Super) {
        var proto = Object.create(Super.prototype); // Super 的一个实例
        proto.constructor = Sub; // 增强对象，复写子类原型会导致constructor 指向丢失
        Sub.prototype = proto; // 原型链继承
    }

    inheritPrototype(Sub, Super);

    var a = new Sub("a",21);
    a.colors.push("yellow");
    var b = new Sub("b",22);


    console.log(a);
    console.log(b);
    a.say();
```

