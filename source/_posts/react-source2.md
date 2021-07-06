---
title: react-lifecyles
date: 2021-07-06 22:14:27
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