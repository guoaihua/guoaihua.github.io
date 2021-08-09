---
title: ts-types
date: 2021-08-09 22:35:38
tags: typescript
---


### 索引类型 index types

索引类型查询: keyof T

keyof T 的结果为T上已知的公共属性名的联合

下面 keyof T 的结果为 'name' | 'age'

索引访问操作符: T[K]

先决条件 K extends keyof T


```
function pluck<T, K extends keyof T>(o: T, names: K[]): T[K][] {
    return names.map(n => o[n])
}
interface Person {
    name: string;
    age: number;
}
let person: Person = {
    name: 'Jarid',
    age: 3
};


let strings: string[] = pluck(person, ['name'])
```
