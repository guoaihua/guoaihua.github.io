---
title: react-render
date: 2024-04-12 20:52:01
---

react-reconciler 的部分在react中指的是render过程

协调的过程其实就是深度优先遍历当前需要渲染Fiber树的过程，通常当前需要构建的fiber树称为work in progress(wipRootFiber)

## hostRootFiber 
fiber其实就是当前dom根元素在内存中的一种结构
hostRootFiber => domContainer

## beginWork 递
1、通过不同的wip tag 做出不同的处理
2、创建子fiber
递归wipRooFiber的过程, 首先是beginWork,在首次创建时，通过父元素，不断创建子fiber，子fiber没有的情况下创建兄弟fiber，兄弟也没有的话，返回上级创建叔叔fiber，直至root
3、创建不同类型操作的flags

## complete 归
1、创建或者标记元素更新
2、flags冒泡到最上级