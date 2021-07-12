---
title: react-jsx
date: 2021-07-05 23:05:48
tags: React
---


### jsx的本质
| JSX 是 JavaScript 的一种语法扩展，它和模板语言很接近，但是它充分具备 JavaScript 的能力

### jsx 如何编译成js
```javascript
// jsx 语法文件
<div className='test'>
  <p>123</p>  
</div>

// babel 转义之后的js文件
React.createElement("div", {
  className: "test"
}, React.createElement("p", null, "123"));
```
JSX标签都被转化为了React.createElement的调用，JSX 的本质是React.createElement这个 JavaScript 调用的语法糖

### jsx的优点
jsx精简的语法糖，让我们使用类html标签语法来创建虚拟dom（使用js对象语法描述dom元素），降低了学习成本同时提高了工作效率

### createElement的作用
开发者通过入参type、config、children调用createElement,创建了一个ReactElement对象，这个对象就是虚拟dom
```javascript
//jsx

        const ele = (
            <div className="test">
                <p>test</p>    
            </div>
        )

// 转换过程

const ele = React.createElement("div", {
  className: "test"
}, React.createElement("p", null, "test"));


// 转换之后的ReactElement对象 ele
{
    "type": "div",
    "key": null,
    "ref": null,
    "props": {
        "className": "test",
        "children": {
            "type": "p",
            "key": null,
            "ref": null,
            "props": {
                "children": "test"
            },
            "_owner": null
        }
    },
    "_owner": null
}
```

### 问题
1.JSX 的本质是什么，它和 JS 之间到底是什么关系？

本质是js中 React.createElement的语法糖，是一种js语法的拓展。最后通过babel编译成真正的js语法。

2.为什么要用 JSX？不用会有什么后果？

jsx使用类html的方式构造虚拟dom，降低学习成本，提高效率

3.JSX 背后的功能模块是什么，这个功能模块都做了哪些事情？
React.createElement 、ReactElement
通过createElement 将用户参数传入的数据格式化，最后通过ReactElement创建虚拟dom
```javascript
const ReactElement = function(type, key, ref, self, source, owner, props) {
  const element = {
    // REACT_ELEMENT_TYPE是一个常量，用来标识该对象是一个ReactElement
    $$typeof: REACT_ELEMENT_TYPE,

    // 内置属性赋值
    type: type,
    key: key,
    ref: ref,
    props: props,

    // 记录创造该元素的组件
    _owner: owner,
  };

  // 
  if (__DEV__) {
    // 这里是一些针对 __DEV__ 环境下的处理，对于大家理解主要逻辑意义不大，此处我直接省略掉，以免混淆视听
  }

  return element;
};

```