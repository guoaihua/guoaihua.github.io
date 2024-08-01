---
title: ts-高级类型
date: 2022-03-15 16:55:22
---

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

使用映射类型与交叉类型，
先取指定元素加上readonly
然后给非指定类型去除readonly
两者取交集
注意默认值：keyof T
```
  type MyReadonly2<T, K extends keyof T = keyof T> = {
    +readonly [P in keyof T as P extends K ? P : never]: T[P]
  } & {
    -readonly [P in keyof T as P extends K ? never : P]: T[P]
  }
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

// 数组转元组
const a = ['1', '2', '3'] as const 

// 获取a的类型
type Arr = typeof a

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

### PromiseAll

键入函数 PromiseAll，它接受 PromiseLike 对象数组，返回值应为 Promise<T>，其中 T 是解析的结果数组

```
const promise1 = Promise.resolve(3);
const promise2 = 42;
const promise3 = new Promise<string>((resolve, reject) => {
  setTimeout(resolve, 100, 'foo');
});

// expected to be `Promise<[number, number, string]>`

declare function PromiseAll<T extends any[]>(values: readonly [...T]): Promise<{
    [K in keyof T]: T[K] extends Promise<infer R> ? R : T[K]
}>
const p = PromiseAll([promise1, promise2, promise3] as const)
```

### Type Lookup

有时，您可能希望根据其属性在并集中查找类型。

在此挑战中，我们想通过在联合 Cat | Dog 中搜索公共 type 字段来获取相应的类型。换句话说，在以下示例中，我们期望 LookUp<Dog | Cat, 'dog'>获得 Dog，LookUp<Dog | Cat, 'cat'>获得 Cat

```
interface Cat {
    type: 'cat'
    breeds: 'Abyssinian' | 'Shorthair' | 'Curl' | 'Bengal'
  }

  interface Dog {
    type: 'dog'
    breeds: 'Hound' | 'Brittany' | 'Bulldog' | 'Boxer'
    color: 'brown' | 'white' | 'black'
  }

  // {type: k}表示更宽泛的父类型，而T 表示更具体的子类型
  type LookUp<T extends { type: any}, K extends T['type']> = T extends {type: K} ? T : never

  type MyDog = LookUp<Cat | Dog, 'dog'> // expected to be `Dog`
```

### Trim

Implement TrimLeft<T> which takes an exact string type and returns a new string with the whitespace beginning removed.

```

// 模板文字类型
type TrimLeft<T extends string> = T extends `${' ' | '\n' | '\t'}${infer SS}` ? TrimLeft<SS> : T

type trimed = TrimLeft<'  Hello World  '> // expected to be 'Hello World  '
```

trim

```
// type TrimLeft<S extends string> = S extends `${' ' | '\n' | '\t'}${infer SS}`?TrimLeft<SS>:S
// type TrimRight<S extends string> = S extends `${infer SS}${' ' | '\n' | '\t'}`?TrimRight<SS>:S
// type Trim<S extends string> = TrimLeft<TrimRight<S>>

type Trim<T extends string> = T extends `${infer SS}${' ' | '\n' | '\t'}` | `${' ' | '\n' | '\t'}${infer SS}` ? Trim<SS> : T

type trimed = Trim<'  Hello World  '> // expected to be 'Hello World'

```

### Capitalize

Implement Capitalize<T> which converts the first letter of a string to uppercase and leave the rest as-is.

```
// 还是利用模板文字类型, T的类型更具体，而`${infer R}${infer F}`是一个抽象类型作为父类型
type MyCapitalize<T extends string> = T extends `${infer R}${infer F}` ?  `${Uppercase<R>}${F}` :T

type capitalized = MyCapitalize<'hello world'> // expected to be 'Hello world'
```

### Replace

Implement Replace<S, From, To> which replace the string From with To once in the given string S

```

type Replace<T extends string, K extends string, P extends string> = K extends ''? T : T extends `${infer F}${K}${infer L}` ? `${F}${P}${L}` : K

type replaced = Replace<'types are fun!', 'fun', 'awesome'> // expected to be 'types are awesome!'

```

### ReplaceAll

Implement ReplaceAll<S, From, To> which replace the all the substring From with To in the given string S

```


//  对任意值，均可表示为`${infer F}${infer T}${infer L}`, 然后对推测值递归处理
type ReplaceAll<T extends string, K extends string, U extends string> = K extends '' ? T : T extends `${infer F}${infer K}${infer L}` ? `${F}${U}${ReplaceAll<L, K, U>}` : T

type replaced = ReplaceAll<'t y p e s', ' ', ''> // expected to be 'types'
```

### 追加参数

>实现一个范型 AppendArgument<Fn, A>，对于给定的函数类型 Fn，以及一个任意类型 A，返回一个新的函数 G。G 拥有 Fn 的所有参数并在末尾追加类型为 A 的参数

```typescript
type Fn = (a: number, b: string) => number

// 对参数的参数和返回值都可以使用 infer 推断
type AppendArgument<T extends (...args: any) => any, K> = T extends (...args: infer P) => infer R ? (x:K, ...args: P) => R : never

type Result = AppendArgument<Fn, boolean>
// 期望是 (a: number, b: string, x: boolean) => number

```

### Length of String

Compute the length of a string literal, which behaves like String#length.

```

// 字符串先转数组，再取数组的length
// 字符转数组，使用infer 分割， 递归
type StringToArray<T extends string> = T extends `${infer F}${infer R}` ? [F, ...StringToArray<R>] : []

type StringLength<S extends string> = StringToArray<S>['length']

type a = StringLength<'12313 qawqe'>  // 11

```

### Flatten 

In this challenge, you would need to write a type that takes an array and emitted the flatten array type.

```

type Flatten<T> = T extends [] ? [] : T extends [infer F, ...(infer R)] ? [...Flatten<F>, ...Flatten<R>] : [T]

type flatten = Flatten<[1, 2, [3, 4], [[[5]]]]> // [1, 2, 3, 4, 5]

```


### NativeFlat

>使用映射类型的索引获取值
>定义一个 NativeFlat 工具类型，支持把数组类型拍平（扁平化）

```typescript
type NativeFlat<T extends any[]> = {
    [K in keyof T]: T[K] extends any[] ? T[K][number] : T[K]
}[number]

type NaiveResult = NaiveFlat<[['a'], ['b', 'c'], ['d']]>
// NaiveResult的结果： "a" | "b" | "c" | "d"

type DeepNativeFlat<T extends any[]> = {
    [K in keyof T]: T[K] extends any[] ? DeepNativeFlat<T[K]> : T[K]
}[number]

type DeepTestResult = DeepFlat<Deep>
// DeepTestResult: "a" | "b" | "c" | "d" | "e"npx
```


### AppendObject

```

type Test = { id: '1' }

// 合并交叉类型的对象
type CombineObject<T extends Object> = {
    [K in keyof T]: T[K]
}
type AppendToObject<T extends object, K extends string, P> = CombineObject<T & { [U in K]: P }>

type Result = AppendToObject<Test, 'value', 4> // expected to be { id: '1', value: 4 }

```

### Absolute

```

type Test = -100;

// 最后都是string
type Absolute<T extends string | number | bigint> = `${T}` extends `${'-'}${infer R}` ? R : `${T}`

type Result = Absolute<Test>; // expected to be "100"

```

### String to union

```
type Test = '123';
//  拆分字符串并递归，终止条件为""
type StringToUnion<T extends string> = T extends "" ? never : T extends `${infer F}${infer L}` ? (F | StringToUnion<L>) : T

type Result = StringToUnion<Test>; // expected to be "1" | "2" | "3"

```

### Merge

```
type Foo = {
    a: number;
    b: string;
};

type Bar = {
    b: number;
    c: boolean;
};
// 交叉类型，如果是对象的话，key取的是并集，value取的才是交集
type Merge<T extends object, K extends object> = {
    [P in keyof (T & K)]: P extends keyof K ? K[P] : P extends keyof T ? T[P] : never
}


type a = Merge<Foo, Bar>

```

### CamelCase

```

//  Capitalize<Right> extends Right 判断是否为-

type CamelCase<T extends string> = T extends `${infer Left}-${infer Right}` ? Capitalize<Right> extends Right ? `${Left}-${CamelCase<Capitalize<Right>>}` : `${Left}${CamelCase<Capitalize<Right>>}` : T

type a = CamelCase<'foo-bar-baz-a'>
```

### Diff

Get an Object that is the difference between O & O1

```
type Foo = {
    name: string
    age: string
  }
  type Bar = {
    name: string
    age: string
    gender: number
  }

  //  使用交叉类型获得交叉集合
  type Diff<T, K> = Pick<T & K, Exclude<keyof T, keyof K> | Exclude<keyof K, keyof T>>

  type a = Diff<Foo, Bar>
```

### AnyOf

Implement Python liked any function in the type system. A type takes the Array and returns true if any element of the Array is true. If the Array is empty, return false.

```

// 所有假值得联合类型

type FalseUnion = false | '' | 0 | Record<string| number, never> |[]
type AnyOf<T extends any[]> = T extends [infer F, ...(infer Reset)] ? F extends FalseUnion? AnyOf<Reset>: true : false

type Sample1 = AnyOf<[1, "", false, [], {}]>; // expected to be true.
type Sample2 = AnyOf<[]>; // expected to be false.
```

### 键重映射的应用

>映射类型中使用 as 将key重新映射，中间可以使用各种运算符，返回never表示去除改属性

```typescript
interface Example {
    a: string;
    b: string | number;
    c: () => void;
    d: {};
}



// 键重映射
type ConditionalPick<T, U> = {
    [K in keyof T as T[K] extends U ? K : never]: T[K]
}



// 测试用例：
type StringKeysOnly = ConditionalPick<Example, string>;
//=> {a: string}



// 去除类型中某个属性
type ConditionalDelete<T, U> = {
    [K in keyof T as Exclude<K, U>]: T[K]
}
type test = ConditionalDelete<Example, 'a'>;
//
// type test = {
//     b: string | number;
//     c: () => void;
//     d: {};
// }


// 将某个属性变为大写
type ConditionalCapitalize<T, U> = {
    [K in keyof T as K extends U ? `test${Capitalize<string & K>}` : K]: T[K]
}

type test1 = ConditionalCapitalize<Example, 'a'>;

// type test1 = {
//     testA: string;
//     b: string | number;
//     c: () => void;
//     d: {};
// }
```

### 实现一个 Split 工具类型
根据给定的分隔符（Delimiter）对包含分隔符的字符串进行切割。可用于定义 String.prototype.split 方法的返回值类型
```
type Item = 'semlinker,lolo,kakuqo';

type Split<
	T extends string, 
	Delimiter extends string,
> = T extends `${infer F}${Delimiter}${infer K}` ? [F, ...Split<K, Delimiter>] : [T]  

type ElementType = Split<Item, ','>; // ["semlinker", "lolo", "kakuqo"]
```

### 实现一个 ToPath 工具类型
用于把属性访问（. 或 []）路径转换为元组的形式
```

type ToPath2<S extends string> = S extends `${infer F}[${infer B}]` ? [F, B] : [S]

type ToPath<S extends string> = S extends `${infer F}.${infer R}` ? [...ToPath2<F>, ...ToPath<R>] : [S] 


type c = flatten<[[1,2],3]>

type a = ToPath<'foo.bar.baz'> //=> ['foo', 'bar', 'baz']
type b = ToPath<'foo[0].bar[0].baz'> //=> ['foo', '0', 'bar', 'baz']

```

## 特殊技巧汇总
1、映射类型的键值重新映射
as never 过滤掉不需要的键， 可以很方便的去掉或者指定处理对象中的某些键；修改key为特殊的类型

参考
基础类型中的
  readonly 指定类型readonly
高级类型中的
  键重映射的应用 去掉某个属性、将某个属性变为大小写或者修改key

2、keyof类型运算符
keyof any 获取 string | number | symbol 用于约束key
参考
基础类型中的
实现 Record 约束必须是一个正常的对象属性

3、条件类型
1、在条件类型内推断，使用infer推断一个不确定的类型
参考
基础类型中的
  获取元组长度 条件类型的约束与infer推断length
  Awaited
高级类型中的
  ReturnType 获取函数返回类型
  最后一个元素
  堆栈操作
  PromiseAll
  Trim
  Capitalize
  Replace
  追加参数
  Length of String
  Flatten
  String to union
2、条件类型的推断约束
  推断一个确定的类型，然后可以使用该类型的一些属性
  
  获取元组长度 条件类型的约束与infer推断length

3、索引访问
数组类型通过number获取数组元素的联合类型
基础类型中的
    元祖转对象
    元组转集合

4、数组的一些方法使用
T[0] T['length'] 拓展运算符
基础类型中的
  获取第一个元素
  获取元组长度
  Concat
  Push & Unshif
高级类型中的
  Length of String 利用...解除嵌套数组
  Flatten 

5、模板字面量类型
使用模板字面量进行推断，字符串操作几乎都会使用，Typescript尝试根据结构匹配给定的字符
高级类型中的
  Trim
  Capitalize
  Length of String
  String to union

>部分题目参考来自
https://github.com/type-challenges/type-challenges/blob/master/README.zh-CN.md
https://juejin.cn/post/7009046640308781063