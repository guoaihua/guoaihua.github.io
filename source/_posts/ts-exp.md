---
title: ts-例子
date: 2024-07-23 12:58:59
tag: ts
---

### 1.利用具体参数的值决定展示额外的参数b或者c

泛型：
```javascript
 // 利用泛型，推断type的值然后约束参数，注意T 要约束到具体的类型值，否则会为string
// 定义可能的 type 值作为联合类型
type Type = 'a' | 'b'
// 使用联合类型优化 Func 接口
interface Func {
  // 当 T 是 'a' 时，接受带有 b 属性的对象
  <T extends Type>(props: T extends 'a' ? {type: T, b: number}: {type:T, c: number}): void;
}

// 重载等价于上面的签名调用
interface Func {
  // 当 T 是 'a' 时，接受带有 b 属性的对象
  <T extends 'a'>({ type, b }: { type: T; b: number }): void;
  
  // 当 T 是 'b' 时，接受带有 c 属性的对象
  <T extends 'b'>({ type, c }: { type: T; c: number }): void;
}

// 定义一个符合 Func 接口的函数
const myFunc: Func = (props) => {
  // 在这里使用 props.type 和 props.b
  console.log(props.type);
}; 

myFunc({ type: 'b', c: 123});

```

联合类型：
```javascript
// 联合类型更简单
type aa = {type: 'a', b: number} | {type: 'b', c: number}

// 定义一个符合 Func 接口的函数
const myFunc1 = (props: aa) => {
  // 在这里使用 props.type 和 props.b
  console.log(props.type);
}; 1

myFunc1({ type: 'd', b: 123}); //error
```