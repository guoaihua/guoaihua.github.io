---
title: ts-alias
date: 2021-07-27 14:22:16
tags: typescript
---

### 使用create-react-app 创建带有ts的模板
yarn create react-app my-app --template typescript

### 覆盖ts配置并配置别名
cra创建的模板每次启动时会自动覆盖一部分配置，所以需要自己通过extends将需要的部分重写
```javascript
// tsconfig.json
  "extends": "./tsconfig.base.json",

// tsconfig.base.json
{
    "compilerOptions": {
        "baseUrl": "src",
        "paths": {
          "@/*": ["*"]
        }
      }
}
```

### 覆盖cra配置
此时，ts编译时的别名已经生效，但是打包阶段webpack的路径依然会报错。
1.通过安装 customize-cra 
This project relies on react-app-rewired. You'll need to install that in order for customize-cra to work.


[customize-cra](https://github.com/arackaf/customize-cra)
[react-app-rewired](https://github.com/timarney/react-app-rewired/blob/master/README_zh.md)

```javascript
yarn add customize-cra react-app-rewired --dev
```

2.替换脚本
```javascript
-   "start": "react-scripts start",
+   "start": "react-app-rewired start",
-   "build": "react-scripts build",
+   "build": "react-app-rewired build",
-   "test": "react-scripts test --env=jsdom",
+   "test": "react-app-rewired test --env=jsdom",
```


3.添加需要覆盖的配置，重写webpack打包时的别名
```javascript
const { override, addWebpackAlias, addDecoratorsLegacy } = require('customize-cra');
const path = require('path')

module.exports = override(
  addWebpackAlias({
    "@": path.resolve(__dirname, 'src')
  }),
  addDecoratorsLegacy(), 
);
```