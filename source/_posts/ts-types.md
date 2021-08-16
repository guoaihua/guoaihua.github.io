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


### 条件类型
为类型推断提供分支选项
```

type diff<T, U> =
    T extends U ? never : T


type test = diff<string | number | null, null> // string | number
```
ts 官方库
```
/**
 * Exclude from T those types that are assignable to U
 */
type Exclude<T, U> = T extends U ? never : T;

/**
 * Extract from T those types that are assignable to U
 */
type Extract<T, U> = T extends U ? T : never;
```

### 映射类型
映射类型建立在索引签名的语法之上，用于声明尚未提前声明的属性类型：

映射类型是一种泛型类型，它使用PropertyKeys的联合（通常通过 a keyof创建）来迭代键以创建类型：

type OptionsFlags<Type> = {
  [Property in keyof Type]: boolean;
};

映射修饰符
有两个额外的修饰符可以在映射期间应用：readonly和?分别影响可变性和可选性。

您可以通过添加-或前缀来删除或添加这些修饰符+。如果不添加前缀，则+为默认值

```
/**
 * Make all properties in T readonly
 */
type Readonly<T> = {
    readonly [P in keyof T]: T[P];
};

/**
 * Make all properties in T optional
 */
type Partial<T> = {
    [P in keyof T]?: T[P];
};


```

键重映射

在 TypeScript 4.1 及更高版本中，您可以使用映射类型中的as子句重新映射映射类型中的键：

```
type MappedTypeWithNewProperties<Type> = {
    [Properties in keyof Type as NewKeyType]: Type[Properties]
}

type RemoveKindField<Type> = {
    [Property in keyof Type as Exclude<Property, "kind">]: Type[Property]
};
```