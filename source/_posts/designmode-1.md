---
title: designmode
date: 2020-09-23 23:13:12
tags:
---

### 简单工厂模式
```javascript
// 简单工厂模式 不同类型

// 将创建对象的过程封装

var Dog = function () {

};

Dog.prototype = {

}

var Cat = function () {

};

Cat.prototype = {

}

var FactoryEasy = function (name) {
    switch(name){
        case 'dog':
           return new Dog();
        case 'cat':
            return new Cat();
    }
}


// 同类型



var Factory = function (name) {
    var o = new Object();

    switch(name){
        case 'dog':
            o.name = 'dog'
        case 'cat':
            o.name= 'cat'
    }
    return 0
}

// 同类型，避免重复写构造函数

var Animal = function (name) {
    this.name = name;
}


var Factory = function (name) {
    let work = '';

    switch(name){
        case 'dog':
            work = 'dog'
        case 'cat':
            work = 'cat'
    }
    return new Animal(work)
}
```

### 工厂模式

适用于创建多类对象，使使用者与类解耦，增加或者减少类不会影响工厂函数
```javascript
// 

var Factory = function (name,options) {
    if(this instanceof Factory){
        return new this[name](options)
    }else {
        return new Factory(name,options)
    }
}

Factory.prototype = {
    dog:function (options) {

    },
    cat: function (opstions) {

    }
}
```

### 单例模式
一个类只允许实例化一次, 利用闭包保证一个类只被实例化一次
```javascript

var singleObj = (function () {
    var single = null;


    // 保证func只创建一次
    function func() {
        var a = "aa";
    }


    return function(){
        if(!single){
            single = new func()
            return single;
        }
        return single;
    }

})();

```

### 装饰者模式
装饰模式 只添加不修改，不改变原有方法功能的情况，增强功能
```javascript
// 


function a() {
    var a = 111;
}


// 为oldobj增加新功能

function b() {
    var b = 222;
}

var newa = function () {
    a();
    // 新增逻辑
    b();
}



// 事件装饰器

var decorator = function (selector, fn) {
    var ele = document.querySelector(selector);

    if(typeof ele.onclick === 'function'){
        var oldfn = ele.onclick;

        ele.onclick = function () {
            // 执行旧代码
            oldfn();
            // 执行新增代码
            fn();
        }
    }else {
        ele.onclick = fn()
    }
}
```

### 适配器模式
```javascript
// 适配器 磨平兼容差异，把变化内部磨平，变化暴露给外部

// 默认参数适配器

function f(options) {

    var _adapter = {
        a: '12',
        b: 12
    }

    // 插件参数配置

    for (var i in _adapter){
        options[i] = options[i] || _adapter[i]
    }
}

// 处理服务端数据

$.ajax({
    success:function (data) {
        handle(_adapter(data))
    }
})

function _adapter(data) {
    // 处理好格式再传递，以后格式变化，改这里就行
    return JSON.stringify(data)
}

```


