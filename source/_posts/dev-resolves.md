---
title: 开发问题解决方法
date: 2024-07-18 10:00:41
---

# 1、docker拉取镜像超时
打开 /etc/docker/daemon.json 配置文件，没有则创建, 添加tx镜像源
```javascript
{
   "registry-mirrors": [
   "https://mirror.ccs.tencentyun.com"
  ]
}
```
重启docker，配置文件错误可能导致docker重启失败
sudo systemctl restart docker

配置成功后可通过docker info 查看

# 2、低版本safari报错
> SyntaxError: Invalid regular expression: invalid group specifier name
低版本 Safari doesn't support lookbehind yet 不支持正向肯定（否定），反向肯定（否定）预查
采用非捕获匹配去替换，要注意在对replace场景会有差别
/(?<=tab=)\w+/ 查找的话替换为 /(?:tab=)\w+/，replace的替换为 *.replace(/(?:tab=)\w+/,`tab=${CONST}`) 