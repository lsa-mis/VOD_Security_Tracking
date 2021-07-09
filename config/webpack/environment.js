const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')
const jquery = require('./plugins/jquery')

environment.plugins.prepend('jquery', jquery)
environment.loaders.prepend('erb', erb)
module.exports = environment
