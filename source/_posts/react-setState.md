---
title: react-setState
date: 2021-07-12 22:28:52
tags: React
---

### setState 调用之后触发的生命周期

setState -> shouldComponentUpdate -> componentWillUpdate -> render -> componentDidUpdate

### 异步更新的动机
批量更新
```javascript
import React from "react";

import "./styles.css";

export default class App extends React.Component{

  state = {

    count: 0

  }

  increment = () => {

    console.log('increment setState前的count', this.state.count)

    this.setState({

      count: this.state.count + 1

    });

    console.log('increment setState后的count', this.state.count)

  }

  triple = () => {

    console.log('triple setState前的count', this.state.count)

    this.setState({

      count: this.state.count + 1

    });

    this.setState({

      count: this.state.count + 1

    });

    this.setState({

      count: this.state.count + 1

    });

    console.log('triple setState后的count', this.state.count)

  }

  reduce = () => {

    setTimeout(() => {

      console.log('reduce setState前的count', this.state.count)

      this.setState({

        count: this.state.count - 1

      });

      console.log('reduce setState后的count', this.state.count)

    },0);

  }

  render(){

    return <div>

      <button onClick={this.increment}>点我增加</button>

      <button onClick={this.triple}>点我增加三倍</button>

      <button onClick={this.reduce}>点我减少</button>

    </div>

  }

}
```

如果每一次调用setState都直接触发完整生命周期，re-render将会带来性能问题.那么此时就需要异步更新，利用Event-Loop,等时机成熟，再把“攒起来”的 state 结果做合并，最后只针对最新的 state 值走一次更新流程。同步任务不结束就一直放入，最后只针对最新的 state 值走一次更新流程
，这就是批量更新。

### 同步现象

本质上是由 React 事务机制和批量更新机制的工作方式来决定
setState调用时会判断内部 batchingStrategy.isBatchingUpdates标识状态来决定是立即更新，还是先放入更新队列，等待批量更新

在生命周期等位置需要开启批量更新，但是setTimeout是异步的，它执行时这个isBatchingUpdates标记已经放开了

```javascript

increment = () => {

  // 进来先锁上

  isBatchingUpdates = true

  console.log('increment setState前的count', this.state.count)

  this.setState({

    count: this.state.count + 1

  });

  console.log('increment setState后的count', this.state.count)

  // 执行完函数再放开

  isBatchingUpdates = false

}

```