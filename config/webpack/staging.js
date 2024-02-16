process.env.NODE_ENV = process.env.NODE_ENV || 'staging'

const environment = require('./environment')

// const merge = require('webpack-merge');

// environment.config.merge({
//     mode: 'staging',
//     performance: {
//         hints: false,
//         maxEntrypointSize: 512000,
//         maxAssetSize: 512000
//     }
// });

module.exports = environment.toWebpackConfig()