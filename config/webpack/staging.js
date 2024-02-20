process.env.NODE_ENV = process.env.NODE_ENV || 'staging'

const environment = require('./environment')

// environment.config.merge({
//     mode: 'staging',
//     performance: {
//         maxEntrypointSize: 900000,
//         maxAssetSize: 900000
//     }
// });

module.exports = environment.toWebpackConfig()