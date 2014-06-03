send     = require 'send'
path     = require 'path'
parseurl = require 'parseurl'
url      = require 'url'

module.exports = (root, opts = {}) ->
  if not root then throw new TypeError('root path required')
  opts.root = path.resolve(root)

  return (req, res, next) ->
    if req.method not in ['GET', 'HEAD'] then return next()

    _url = url.parse(req.originalUrl or req.url)
    _path = parseurl(req).pathname

    send(req, _path, opts)
      .on('error', next)
      .on('directory', dir.bind(null, _url, res))
      .pipe(res)

dir = (_url, res) ->
  _url.pathname += '/'
  target = url.format(_url)
  res.statusCode = 303
  res.setHeader('Location', target)
  res.end("Redirecting to #{target}")
