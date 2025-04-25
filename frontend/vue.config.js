module.exports = {
    publicPath: './',
    configureWebpack: {
      performance: {
        hints: false
      }
    },
    css: {
      extract: {
        ignoreOrder: true
      }
    }
}