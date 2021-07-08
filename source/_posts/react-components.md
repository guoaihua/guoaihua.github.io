---
title: React-components
date: 2021-07-07 23:06:38
tags: React
---

### 组件渲染核心
数据驱动视图 react的视图是由数据驱动的

### 基于 props 的单向数据流
指的就是当前组件的 state 以 props 的形式流动时，只能流向组件树中比自己层级更低的组件。 比如在父-子组件这种嵌套关系中，只能由父组件传 props 给子组件，而不能反过来。

### 组建通信

使用基于 Props 的单向数据流串联父子、兄弟组件；
利用“发布-订阅”模式驱动 React 数据在任意组件间流动。

父子： 通过props，将父组件的state流向子组件
子父： 父组件通过props，将一个绑定了自身上下文的函数传递到子组件，那么子组件在调用该函数时，就可以将想要交给父组件的数据以函数入参的形式给出去，间接改变父组件数据
兄弟： 同一个父组件，将兄弟1->兄弟2的通信转换为 兄弟1->父组件 父组件->兄弟2，兄弟1借用父元素函数改变父元素state，然后父元素通过props将state流向兄弟2
复杂组件间：通过发布订阅模式，解耦合

```javascript
function EventEmitter(){
    this.callback = {};
}

EventEmitter.prototype = {
    on(type, callback){
        if(typeof callback !== 'function'){
            return;
        }
        if(!this.callback[type]){
            this.callback[type] = [];
        }
        this.callback[type].push(callback);
    },
    emit(type, data){
        if(this.callback[type]){
            this.callback[type].forEach(element => {
                element.call(this, data)
            });
        }
    },
    off(type, cb){
        if(this.callback[type]){
            const len = this.callback[type].length - 1;
            for(var i = len; i >=0; i--){
                if(this.callback[type][i] === cb){
                    this.callback[type].splice(i,1);
                }
            }
        }
    }
}

export default EventEmitter
```

### redux
严格遵循单一数据流
在 Redux 的整个工作过程中，数据流是严格单向的
![](/images/reducer.png)