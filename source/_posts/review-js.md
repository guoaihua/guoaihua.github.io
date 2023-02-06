---
title: 温故而知新
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

改良版：
```javascript
/**
 * 
 * @param a string
 * @param b string
 */
export const bigNumberADD = (a: string, b: string) => {
    const maxLength = Math.max(a.length, b.length);
    let temp1 = a.padStart(maxLength, '0');
    let temp2 = b.padStart(maxLength, '0');
    let sum = '';
    let f = 0;

    for (let i = maxLength - 1; i >= 0; i--) {
        sum = (parseInt(temp1[i]) + parseInt(temp2[i]) + f) % 10 + sum;
        f = Math.floor((parseInt(temp1[i]) + parseInt(temp2[i]) + f) / 10)
    }

    if (f) {
        sum = "1" + sum;
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

# Javascript
>Javascript 是一门面向对象的语言, 它不仅实现了面向对象的基本特征，而且具有高度的动态性（可以在运行时修改对象的属性)  

>对象的特征：

    具有唯一标识，即使完全相同的两个对象，也并非同一个对象
    具有状态，同一个对象可以处于不同的状态
    具有行为，行为可以改变状态

# 事件循环
>宏任务是一个一个从队列中取出执行，微任务是一整个队列执行完，才开始下一个宏任务
微任务总是在当前队列的尾部添加,宏任务则添加下一个循环
```javascript
  setTimeout(()=>console.log("d"), 0)
    var r = new Promise(function(resolve, reject){
        resolve()
    });
    r.then(() => { 
        var begin = Date.now();
        while(Date.now() - begin < 1000);
        console.log("c1") 
        setTimeout(()=>console.log("e"), 0)
        new Promise(function(resolve, reject){
            resolve()
        }).then(() => console.log("c2"))
    });
    // c1 -> c2 -> d -> e
```

实现一个红绿灯
```javascript
       var light_ele = document.querySelector('.light');

        const setLight = (color) => light_ele.style.backgroundColor = color

        function Light() {
            this.green = 3;
            this.yellow = 1;
            this.red = 2;
        }

        Light.prototype.run = function () {
            new Promise((resolve) => {
                setLight('green');
                setTimeout(() => {
                    console.log('green end')
                    resolve()
                }
                    , this.green * 1000)
            }).then((value) => {
                return new Promise((resolve) => {
                    setLight('yellow');
                    setTimeout(() => {
                        console.log('yellow end')
                        resolve()
                    }, this.yellow * 1000)
                })
            }).then(() => {
                return new Promise((resolve) => {
                    setLight('red');
                    setTimeout(() => {
                        console.log('red end')
                        resolve()
                    }, this.red * 2000)
                })
            }).then(() => {
                console.log('green start')
                this.run()
            })
        }

        let a = new Light()
        a.run();
```

改良版
```javascript

    // html

    <div class='light'></div>
    <style>
        .light {
            width: 100px;
            height: 100px;
            border-radius: 50px;
            background-color: green;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
        }
    </style>

    var light_ele = document.querySelector('.light');

    const setLight = (color) => light_ele.style.backgroundColor = color
    const setInnerText = text => light_ele.innerText = text

    function run(color, delay) {
        setLight(color);
        setInnerText(delay)
        let timeout = setInterval(() => {
            setInnerText(--delay)
        }, 1000)
        return new Promise(resolve => setTimeout(() => {
            clearInterval(timeout)
            resolve()
        }, delay * 1000))
    }

    async function runLight() {
        while (true) {
            await run('green', 3);
            await run('yellow', 1);
            await run('red', 2)
        }
    }

    runLight();
```

# js的词法
>NumericLiteral
    十进制数、二进制整数、八进制整数和十六进制整数

>十进制的 Number 可以带小数，小数点前后部分都可以省略，但是不能同时省略
    **12.** 
    **.12**

>调用 12.toString()的时候报错 （Uncaught SyntaxError: Invalid or unexpected token）

>js词法解释器无法区分 . 是小数的词法还是 .运算符，正确的使用方法：12 .toString(); (12).toString()