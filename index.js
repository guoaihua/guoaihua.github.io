const koa = require('koa')
const app = new  koa()
const static = require('koa-static')
const path = require('path')

app.use(static(
    path.join( __dirname,  './docs')
))

  app.listen(4000, () => {
    console.log('[demo] static-use-middleware is starting at port 4000')
  })