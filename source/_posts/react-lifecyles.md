---
title: react-lifecyles
date: 2021-07-06 22:14:27
tags: React
---

### 组件的生命周期
mount:
consructor
static getDerivedStateFromProps()
render
componentDidMount

update:
static getDerivedStateFromProps()
shouldComponentUpdate()
render()
getSnapshotBeforeUpdate()
componentDidUpdate()



### render是react组件生命周期的核心
虚拟 DOM 自然不必多说，它的生成都要仰仗 render；而组件化概念中所提及的“渲染工作流”，这里指的是从组件数据改变到组件实际更新发生的过程，这个过程的实现同样离不开 render

规则：
render() 方法是 class 组件中唯一必须实现的方法
当 render 被调用时，它会检查 this.props 和 this.state 的变化并返回以下类型之一：React元素、数组或者fragment、Portals、字符串或者数值类型、布尔类型或 null

### 新的生命周期
16.3版本及以后增加了 getDerivedStateFromProps生命周期，废弃了componentWillMount
1.该生命周期主要用来从props派生state，是一个静态方法，不能调用this，使用生命周期时要保证它的纯洁性
2.接收2个参数，props和state，它应返回一个对象来更新 state，如果返回 null 则不更新任何内容，可以对state进行增量更新
3.任何因素触发的组件更新流程（包括由 this.setState 和 forceUpdate 触发的更新流程）都会触发 getDerivedStateFromProps；而在 v 16.3 版本时，只有父组件的更新会触发该生命周期

### 生命周期废旧立新的原因
为fiber的异步渲染做准备
在 Fiber 机制下，render 阶段是允许暂停、终止和重启的。当一个任务执行到一半被打断后，下一次渲染线程抢回主动权时，这个任务被重启的形式是“重复执行一遍整个任务”而非“接着上次执行到的那行代码往下走”
