---
title: review-types
date: 2022-03-07 21:00:18
tags: 温故而知新
---

# 数字的最大长度
>Javascript Number 类型为IEEE 754 64位双精度浮点格式（64位的二进度数）

>整数范围为： [-2^53 - 1, 2^53 -1]

>区分 +0 和 -0 的方式，正是检测 1/x 是 Infinity 还是 -Infinity

>大数相加
```javascript
/**
 * 大数相加
 * 数字范围为 [-2^53-1, 2^53-1]
 * 将数字转化为字符串相加，避免溢出
 */
export const bigNumberADD = (a: number, b: number) => {
    // 将数字转化为字符
    let max = a.toString();
    let min = b.toString();
    let f = 0;
    let sum = '';

    // 如果a < b ，交换

    if (max.length < min.length) {
        let temp = max;
        max = min;
        min = temp;
    }

    // 以最大长度的字符开始遍历
    while (max.length) {
        // 取出最后一位字符，并转化为数字
        let temp1 = +max.slice(-1);
        let temp2 = +min.slice(-1);

        // 尾数 ,新的数字应该放在最前面
        sum = (temp1 + temp2 + f) % 10 + sum;

        // 这里的取整可能会产生小数，要取整；
        f = Math.floor((temp1 + temp2) / 10);

        // 修改max，min
        max = max.slice(0, -1);
        min = min.slice(0, -1);
    }

    // 处理完时，f还存在，则在前面加一
    if (f) {
        sum = 1 + sum
    }
    return sum
}
```


# 基本类型的装箱
基本类型在使用时，. 运算符提供了装箱操作
```javascript
let a = '1';
a.toFixed(); // a在被调用前，进行了装箱操作
```