process.env.NODE_ENV = process.env.NODE_ENV || 'staging'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()

const merge = require('webpack-merge');

module.exports = merge(environment, {
    mode: 'staging',
    performance: {
        devtool: false,
        hints: false,
        maxEntrypointSize: 512000,
        maxAssetSize: 512000
    }
});