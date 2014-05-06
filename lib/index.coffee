st       = require 'st'
defaults = require 'lodash.defaults'

module.exports = (root, opts = {}) ->
  options = defaults(opts, { index: 'index.html' })
  options.path = root
  options.passthrough = true

  middleware = st(options)

  return (req, res, next) ->
    middleware(req, res, next.bind(null, "file not found"))
