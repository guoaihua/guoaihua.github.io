---
title: review-types
date: 2022-03-11 10:49:51
---


# 常见类型
```typescript
interface TEST {
    a?: string // 字符
    b?: number // 数字
    c?: boolean // 布尔
    d?: any // 任意
    e?: (string | number)[] // 数组
    f?: () => void // 函数签名
    g?: {} // 对象
    h?: 'typescript' // 字符串字面量类型
}

```

# 类型断言
>类型只能被断言为一个更为具体或者更抽象的类型，而不是平级
```typescript
const x = "hello" as number;

Conversion of type 'string' to type 'number' may be a mistake because neither type sufficiently overlaps with the other. If this was intentional, convert the expression to 'unknown' first.

// good
const x = "hello" as {} // as any 
```

>as const 后缀通常用来讲一个通用属性的类型转换为文字类型
```typescript
const req = {url: 'https://www.aad.com', method: 'Get' }
// req: { url: string, method: string}

const req = {url: 'https://www.aad.com', method: 'Get' } as const

// req: { url: 'https://www.aad.com', method: 'Get'} 使用了具体的字面量类型


```

# 非空断言
通常当一个值为 undefined | null 时，可能需要去显示排除一下，使用非空断言可以明确排除空值
```typescript
function doSomething(x?: string | null) {
    console.log("Hello, " + x.toUpperCase()); // x 可能为 string | null | undefined
}

// use !
function doSomething(x?: string | null) {
    console.log("Hello, " + x!.toUpperCase()); // 手动排除null和undefined， 但是通常规避空值
}

// use ?
function doSomething(x?: string | null) {
    console.log("Hello, " + x?.toUpperCase()); // 兼容null和undefined
}
```

# 类型缩小
通常当一个类型非常宽泛时，实际去使用时却要去具体到某一个类型，这时就要缩小类型，防止报错

> typeof 类型守卫
```typescript
function doSomething(x?: string | number | number[]) {
    if(typeof x === 'object'){
        console.log(x.push(1)) // 利用typeof将 x 收窄
    }
}
```
> 真实性 收窄

```typescript
function doSomething(x?: string) {
    if(x){
        console.log(x)
    }
}
```
> 相等性收窄

```typescript
function doSomething(x: string | number, y: string | boolean) {
    if(x === y){
        console.log(x.up)
    }
}
```
> in 运算符收窄

> instanceof