---
title: ts-utils
date: 2021-09-08 19:42:11
tags: typescript
---

## From type-challenges

题目基本来自
https://github.com/type-challenges/type-challenges/blob/master/README.zh-CN.md

### 实现 Exclude

从当前类型中排查掉提供的类型（提供的是类型而不是属性名，和 omit 区分开发）
这个提供的类型不一定约束为当前目前类型的子类型

```
 type MyExclude<T, U> = T extends U ? never : T

 type newType = MyExclude<string | number, string> // number
```

### 实现 Extract

与 Exclude 相反，提取一个类型

```
type MyExtract<T, U> = T extends U ? T : never;
```

### 实现 pick

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

### 实现 Omit

通过属性名 从一个接口中删除当前属性和它的类型, 该属性名一定是当前接口的属性之一

首先借用 Exclude 将不必要的属性名排除掉 ，返回新的属性名集合，再通过 Pick 用该属性名集合获取最新的接口类型

```

type MyOmit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>


interface testData {
    age: number
    name: string
    test: () => void
}

type a = MyOmit<testData, 'age' | 'name'> // {test:()=>void}

```

### 实现 ReadOnly

将属性全变为 readonly

```
type MyReadOnly<T> = {
    readonly [K in keyof T]: T[K]
}
```

### 实现 Partial

将属性全变为可选

```
type MyPartial<T> = {
    [K in keyof T]?: T[K]
}
```

### 实现 Required

将属性变为必选

```
type MyRequired<T> = {
    [K in keyof T]-?: T[K]
}
```

### 实现 Record

就是遍历第一个参数的每个子类型，然后将值设置为第二参数

```
type Record<K extends keyof any, T> = {
  [P in K]: T
}

type MyRecord<K extends keyof any, T> = {
    [P in K]: T
  }

interface a {
    age: number,
    name: string
}

interface b {
    k1: number,
    k2: string
}

type d = MyRecord<keyof a,b>


```

keyof any 得到的是 string | number | symbol

约束 key 的类型为 string | number | symbol 之一

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

创建一个通用的 Length，接受一个 readonly 的数组，返回这个数组的长度

```
type tesla = ['tesla', 'model 3', 'model X', 'model Y']
type spaceX = ['FALCON 9', 'FALCON HEAVY', 'DRAGON', 'STARSHIP', 'HUMAN SPACEFLIGHT']

type Length<T extends readonly any[]> = T extends { length: infer L } ? L : never
// type Length<T extends readonly any[]> = T['length']
type teslaLength = Length<tesla> // expected 4
type spaceXLength = Length<spaceX> // expected 5
```

### Awaited

假如我们有一个 Promise 对象，这个 Promise 对象会返回一个类型。在 TS 中，我们用 Promise 中的 T 来描述这个 Promise 返回的类型。请你实现一个类型，可以获取这个类型。
比如：Promise<ExampleType>，请你返回 ExampleType 类型

利用 infer 解包
约束 Promise 时使用 unknown 而非 any，因为它更安全

```
type UnPackPromise<T extends Promise<unknown>> = T extends Promise<infer R> ? R :never

type a = UnPackPromise<Promise<string>> // string
```

### If

Implement a utils If which accepts condition C, a truthy return type T, and a falsy return type F. C is expected to be either true or false while T and F can be any type.

```
type If<C extends boolean,T,F> = C extends true ? T : F

type A = If<true, 'a', 'b'>  // expected to be 'a'
type B = If<false, 'a', 'b'> // expected to be 'b'
```

### Concat

Implement the JavaScript Array.concat function in the type system. A type takes the two arguments. The output should be a new array that includes inputs in ltr order

...展开运算法也可以使用。。。

```
type Concat<T extends unknown[],K extends unknown[]> =  [ ...T, ...K]

type Result = Concat<[1], [2]> // expected to be [1, 2]
```

### Includes

Implement the JavaScript Array.includes function in the type system. A type takes the two arguments. The output should be a boolean true or false

keyof A： 取的是 A 中所有公共属性名的联合

A[keyof A]: A 所有值（key 的类型）组成的联合类型

```
type Includes<A extends any[], T> = T extends A[keyof A] ? true : false



//A[keyof A] => 'Kars'|'Esidisi'|'Wamuu'|'Santana']

// 判断T子类型是否可与继承 A[keyof A]

type isPillarMen = Includes<['Kars', 'Esidisi', 'Wamuu', 'Santana'], 'Kars'>
```

先将数组变为对象结构

```

type TupleToObj<T extends any[]> = {
    [K in T[number]]: K
}

type  dd = TupleToObj<['Kars', 'Esidisi', 'Wamuu', 'Santana']>

type dd = {
    Kars: "Kars";
    Esidisi: "Esidisi";
    Wamuu: "Wamuu";
    Santana: "Santana";
}

```

再通过属性调用，获取当前值与属性对比

```
type TupleToObj<T extends any[]> = {
    [K in T[number]]: K
}

type MyIncludes<T extends any[], K> = TupleToObj<T>[K] extends K ? true : false

type isPillarMen = MyIncludes<['Kars', 'Esidisi', 'Wamuu', 'Santana'], 'Kars'>

```

### Push & Unshift

Implement the generic version of Array.push & Array.unshift

```
type Push<T extends unknown[],K> = [...T,K]
type Unshift<T extends unknown[],K> = [K,...T]

type Result = Push<[1, 2], '3'> // [1, 2, '3']
type Result = Unshift<[1, 2], 0> // [0, 1, 2,]
```

## 高级类型

### ReturnType 获取函数返回类型

不使用 ReturnType 实现 TypeScript 的 ReturnType<T> 范型。
infer 推断返回类型

```
type MyReturnType<T extends (...args: any)=>any > = T extends (...args: any)=> infer R ? R : never


const fn = (v: boolean) => {
    if (v)
      return 1
    else
      return 2
  }

  type a = MyReturnType<typeof fn> // 应推导出 "1 | 2"
```

### ReadyOnly2

实现一个通用 MyReadonly2<T, K>，它带有两种类型的参数 T 和 K。

K 指定应设置为 Readonly 的 T 的属性集。如果未提供 K，则应使所有属性都变为只读，就像普通的 Readonly<T>一样。

例如

```
interface Todo {
  title: string
  description: string
  completed: boolean
}

type MyReadonly2<T,K extends keyof T = keyof T> = {
    readonly [P in K]: T[P]
} & T  // 默认值使用es6的默认值， 使用新的类型和原有类型交叉，key相同时，readonly会增加

const todo: MyReadonly2<Todo, 'title' | 'description'> = {
  title: "Hey",
  description: "foobar",
  completed: false,
}

todo.title = "Hello" // Error: cannot reassign a readonly property
todo.description = "barFoo" // Error: cannot reassign a readonly property
todo.completed = true // OK

```

### 深度 Readonly

实现一个通用的 DeepReadonly<T>，它将对象的每个参数及其子对象递归地设为只读

```
type X = {
  x: {
    a: 1
    b: 'hi'
  }
  y: 'hey'
}

type Expected = {
  readonly x: {
    readonly a: 1
    readonly b: 'hi'
  }
  readonly y: 'hey'
}

type DeepReadonly<T> = {
  readonly [K in keyof T]: T[K] extends object ?  DeepReadonly<T[K]> : T[K]
} // 对象才能继续深度遍历

type todo = DeepReadonly<X> // should be same as `Expected`
```

### 元组转集合

实现泛型 TupleToUnion<T>，它覆盖元组的值与其值联合

```
type Arr = ['1', '2', '3']

type TupleToUnion<T extends unknown[]> = T[number]

type a = TupleToUnion<Arr> // expected to be '1' | '2' | '3'


```

### 可串联构造器

在 JavaScript 中我们很常会使用可串联（Chainable/Pipeline）的函数构造一个对象，但在 TypeScript 中，你能合理的给他附上类型吗？

在这个挑战中，你可以使用任意你喜欢的方式实现这个类型 - Interface, Type 或 Class 都行。你需要提供两个函数 option(key, value) 和 get()。在 option 中你需要使用提供的 key 和 value 扩展当前的对象类型，通过 get 获取最终结果。

```
// Record 使用key和value构建一个新的类型，最后返回一个全新的函数支持递归

interface Chainable<Tdict={}> {
  option: <Tkey extends string, Tvalue>(key: Tkey, value: Tvalue) => Chainable< Tdict &  Record<Tkey, Tvalue>>,
  get: ()=> Tdict
}

declare const config: Chainable

const result = config
  .option('foo', 123)
  .option('name', 'type-challenges')
  .option('bar', { value: 'Hello World' })
  .get()

// 期望 result 的类型是：
interface Result {
  foo: number
  name: string
  bar: {
    value: string
  }
}

```

### 最后一个元素

实现一个通用 Last<T>，它接受一个数组 T 并返回其最后一个元素的类型

```
type arr1 = ['a', 'b', 'c']
type arr2 = [3, 2, 1]

// 每次把数组分为当前元素和剩余元素，判断剩余元素个数，即可知道当前元素
type Last<T extends unknown[]> = T extends [infer first, ...(infer Reset)] ? Reset['length'] extends 0 ? first : Last<Reset> : never

type tail1 = Last<arr1> // expected to be 'c'
type tail2 = Last<arr2> // expected to be 1

```

### 堆栈操作

实现一个通用 Pop<T>，它接受一个数组 T 并返回一个没有最后一个元素的数组

```
type arr1 = ['a', 'b', 'c', 'd']
type arr2 = [3, 2, 1]


type Pop<T extends unknown[]> =  T extends [...(infer Reset), infer Last] ? Reset :never
type Shift<T extends unknown[]> =  T extends [infer First, ...(infer Reset)] ? Reset:never
type Push<T extends unknown[], K> =  T extends unknown[] ? [...T, K] :never
type Unshift<T extends unknown[], K> =  T extends unknown[] ? [K, ...T] :never

type re1 = Pop<arr1> // expected to be ['a', 'b', 'c']
type re2 = Pop<arr2> // expected to be [3, 2]

type re3 = Shift<arr1> // expected to be [ 'b', 'c', 'd']
type re4 = Shift<arr2> // expected to be [ 2,1]

type re5 = Push<arr1, ['d','1231']> // expected to be ['a', 'b', 'c', 'd', ['d','1231']
type re6 = Push<arr2, 4> // expected to be [3,2,1,4]


type re7 = Unshift<arr1, ['d','1231']> // expected to be [['d','1231'], 'a', 'b', 'c', 'd']
type re8 = Unshift<arr2, 4> // expected to be [4,3,2,1]


```
