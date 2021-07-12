---
title: react-hooks
date: 2021-07-08 23:39:39
tags: React
---

### 类组件
所谓类组件，就是基于 ES6 Class 这种写法，通过继承 React.Component 得来的 React 组件
```javascript
import React from 'react';

class Sub extends React.Component {
    constructor(props){
        super(props);
        this.state = {}
    }

    static getDerivedStateFromProps(props, state) {
        console.log('sub', props);
        return null
      }

    emit(){
        window.bus.emit('msg', 'dadada');
    }  

    render(){
        
        return (
            <div>
                <button onClick={this.emit}>子组件</button>
                {this.props.time}
            </div>
        )
    }
}
```

### 何谓函数组件/无状态组件（Function Component/Stateless Component）
函数组件顾名思义，就是以函数的形态存在的 React 组件.早期并没有 React-Hooks 的加持，函数组件内部无法定义和维护 state，因此它还有一个别名叫“无状态组件
```javascript
import React, {useState, useEffect} from 'react';

function Increase(){
    let [count, setCount] = useState(0);
    const change = ()=>{
        setCount(count++)
    }
    useEffect(()=>{
        console.log('effect');
    })
    return (
        <div onClick={change}>
            adad  test hooks
            {count}
        </div>
    )
}

export default Increase
```


### Why React-Hooks
1.告别难以理解的class
this的指向较复杂，经常不符合预期。生命周期需要学习成本

2.解决业务逻辑难以拆分的问题
业务逻辑通常被打散到各个生命周期，难以维护
而hooks可以帮助实现业务逻辑的聚合，避免复杂的组件和冗杂的代码

3.使状态逻辑复用更加简单
过去我们复用状态逻辑，靠的是 HOC（高阶组件）和 Render Props 这些组件设计模式

4.函数组件更加契合 React 框架的设计理念


### 差别
函数组件会捕获 render 内部的状态，这是两类组件最大的不同

### 工作原理
底层通过链表来更新内容
hooks 的渲染是通过“依次遍历”来定位每个 hooks 内容的。如果前后两次读到的链表在顺序上出现差异，那么渲染的结果自然是不可控的
原则：
只在 React 函数中调用 Hook；

不要在循环、条件或嵌套函数中调用 Hook

