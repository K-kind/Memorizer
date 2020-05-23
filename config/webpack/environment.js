const { environment } = require('@rails/webpacker')

// importをDir/**で指定できる
environment.loaders.get('sass').use.push('import-glob-loader')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        // $: 'jquery/src/jquery',
        $: 'jquery',
        jQuery: 'jquery/src/jquery',
        Rails: ['@rails/ujs']
    })
)
module.exports = environment
