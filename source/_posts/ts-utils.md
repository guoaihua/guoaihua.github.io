---
title: ts-utils
date: 2021-09-08 19:42:11
tags: typescript
---

## From type-challenges
https://github.com/type-challenges/type-challenges/blob/master/README.zh-CN.md


### 实现Exclude

从当前类型中排查掉提供的类型（提供的是类型而不是属性名，和omit区分开发）
这个提供的类型不一定约束为当前目前类型的子类型

```
 type MyExclude<T, U> = T extends U ? never : T

 type newType = MyExclude<string | number, string> // number
```


### 实现Exclude
与Exclude相反，提取一个类型
```
type MyExtract<T, U> = T extends U ? T : never;
```


### 实现pick
通过属性名 从一个接口中提取当前属性和它的类型, 该属性名一定是当前接口的属性之一

属性名可以是一个联合属性

```

type MyPick<T, K extends keyof T> = {
    [P in K]: T[P]
}

interface testData {
    age: number
    name: string
    test: () => void
}

type a = Pick<testData, 'age' | 'name'> // {age: number, name: string}

```

### 实现Omit
通过属性名 从一个接口中删除当前属性和它的类型, 该属性名一定是当前接口的属性之一

首先借用Exclude 将不必要的属性名排除掉 ，返回新的属性名集合，再通过Pick用该属性名集合获取最新的接口类型
```

type MyOmit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>


interface testData {
    age: number
    name: string
    test: () => void
}

type a = MyOmit<testData, 'age' | 'name'> // {test:()=>void}

```

### 实现ReadOnly
将属性全变为readonly
```
type MyReadOnly<T> = {
    readonly [K in keyof T]: T[K]
}
```

### 实现Partial
将属性全变为可选
```
type MyPartial<T> = {
    [K in keyof T]?: T[K]
}
```

### 实现Required
将属性变为必选
```
type MyRequired<T> = {
    [K in keyof T]-?: T[K]
}
```

### 元祖转对象
传入一个元组类型，将这个元组类型转换为对象类型，这个对象类型的键/值都是从元组中遍历出来

```
type TupleToObject<T extends readonly any[]> = {
    [K in T[number]]: K
}

const tuple = ['tesla', 'model 3', 'model X', 'model Y'] as const

type a = TupleToObject<typeof tuple> // expected { tesla: 'tesla', 'model 3': 'model 3', 'model X': 'model X', 'model Y': 'model Y'}


```

### 获取第一个元素

```
type arr1 = ['a', 'b', 'c']
type arr2 = [3, 2, 1]


type First<T extends any[]> = T[0]
type head1 = First<arr1> // expected to be 'a'
type head2 = First<arr2> // expected to be 3
```

### 获取元组长度
创建一个通用的Length，接受一个readonly的数组，返回这个数组的长度
```
type tesla = ['tesla', 'model 3', 'model X', 'model Y']
type spaceX = ['FALCON 9', 'FALCON HEAVY', 'DRAGON', 'STARSHIP', 'HUMAN SPACEFLIGHT']

type Length<T extends readonly any[]> = T extends { length: infer L } ? L : never
// type Length<T extends readonly any[]> = T['length']
type teslaLength = Length<tesla> // expected 4
type spaceXLength = Length<spaceX> // expected 5
```
