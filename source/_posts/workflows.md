---
title: workflows
date: 2021-07-27 12:54:14
tags: tools
---

### 工具的用法随着版本会发生变化

安装最新版本时，实际用法请参考官方文档

### prettier-格式化代码

1.安装 [prettier](https://prettier.io/docs/en/install.html)

```javascript
yarn add --dev --exact prettier
```

2.vscode 安装插件 Prettier - Code formatter

3.打开 vscode 选择默认格式化工具,同时配置 format on save

4.通过 [lint-staged](https://github.com/okonet/lint-staged#configuration) 添加 pre-commit Hooks

需要提前安装依赖
This command will install and configure husky and lint-staged depending on the code quality tools from your project's package.json dependencies, so please make sure you install (npm install --save-dev) and configure all code quality tools like Prettier and ESLint prior to that

然后直接运行

```javacript
npx mrm@2 lint-staged
```

### eslint

安装 [eslint](https://eslint.org/docs/user-guide/getting-started)

```javascript
yarn add eslint
npx eslint --init
```

eslint-config-prettier 解决冲突

```javascript
  extends: [
    'plugin:react/recommended',
    'airbnb',
    'prettier',
  ],
```

### commitizen

[commit](https://github.com/commitizen/cz-cli) 生成管理工具

安装

```javascript
npm install -g commitizen
```

使用不同的适配器

```
commitizen init cz-conventional-changelog --yarn --dev --exact
```

使用 git-cz/cz/npx cz 完成 commit 提交

### commit-lint

约束 commit 生成格式
安装 [commit-lint](https://github.com/conventional-changelog/commitlint/#what-is-commitlint)

同时配置 commit-style 为 [config-angular](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-angular)

### changelog

安装 [conventional-changelog-cli](https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-cli#readme)

运行命令生成 changlog

```javascript
conventional-changelog -p angular -i CHANGELOG.md -s
```

### Standard Version

发布版本时，
自动生成 changlog
提升 verion
生成新的 tag

安装 [Standard Version](https://github.com/conventional-changelog/standard-version)

```
npm i --save-dev standard-version

{
  "scripts": {
    "release": "standard-version"
  }
}

```
