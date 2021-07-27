---
title: react-fiber
date: 2021-07-13 22:38:24
tags: React
---


### Stack Reconciler面临的问题
开始渲染时，Stack Reconciler 是一个同步的递归过程。该架构下的diff算法是一个树的深度优先遍历，树复杂的情况下会占用过多的主线程时间

### fiber架构
增量渲染，将渲染任务分片，使任务可中断、可回复与优先级
16之前，react更新流程：
Reconciler -> render

16之后
Scheduler -> Reconciler -> render


### fiber架构下的render
render调用栈的三个阶段：
1.初始化
2.render阶段
3.commit阶段

### 三个启动模式
legacy模式：原本的同步渲染机制
blocking模式：目前正在实验中，作为迁移到 concurrent 模式的第一个步骤
concurrent模式：异步渲染模式

fiber架构同时兼容了异步渲染和同步渲染


文档资料参考：https://zh-hans.reactjs.org/docs/concurrent-mode-adoption.html#why-so-many-modes

