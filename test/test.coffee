connect = require 'connect'

describe 'basic', ->

  before ->
    @app = connect().use(alchemist(path.join(base_path, 'basic')))

  it 'serve a file', (done) ->
    chai.request(@app).get('/index.html').res (res) ->
      res.text.should.equal('<p>hello world!</p>\n')
      res.should.have.status(200)
      done()

  it 'serve a directory index', (done) ->
    chai.request(@app).get('/').res (res) ->
      res.text.should.equal('<p>hello world!</p>\n')
      res.should.have.status(200)
      done()

  it 'should error if file doesnt exist', (done) ->
    chai.request(@app).get('/foo.html').res (res) ->
      res.should.have.status(500)
      done()

describe 'options', ->

  before -> @base = path.join(base_path, 'basic')

  it 'modifies the base url', (done) ->
    @app = connect().use(alchemist(@base, { url: '/static' }))

    chai.request(@app).get('/static').res (res) ->
      res.should.have.status(200)
      done()

  it 'uses gzip by default', (done) ->
    @app = connect().use(alchemist(@base))

    chai.request(@app).get('/').res (res) ->
      should.not.exist(res.headers['content-encoding'])
      done()

  it 'uses doesnt use gzip if turned off', (done) ->
    @app = connect().use(alchemist(@base, { gzip: false }))

    chai.request(@app).get('/').res (res) ->
      should.not.exist(res.headers['content-encoding'])
      done()

  it 'does not serve dotfiles', (done) ->
    @app = connect().use(alchemist(@base))

    chai.request(@app).get('/.secret').res (res) ->
      res.should.have.status(403)
      done()

  it 'served dotfiles if allowed', (done) ->
    @app = connect().use(alchemist(@base, { dot: true }))

    chai.request(@app).get('/.secret').res (res) ->
      res.should.have.status(200)
      done()
