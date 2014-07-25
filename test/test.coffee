http    = require 'http'
connect = require 'connect'

describe 'basic', ->

  before ->
    @app = connect().use(alchemist(path.join(base_path, 'basic')))

  it 'should error if a root path is not passed', ->
    (-> alchemist()).should.throw()

  it 'should pass through if not a GET request', (done) ->
    chai.request(@app).post('/').res (res) ->
      res.should.have.status(404)
      done()

  it 'should serve a file', (done) ->
    chai.request(@app).get('/index.html').res (res) ->
      res.text.should.equal('<p>hello world!</p>\n')
      res.should.have.status(200)
      done()

  it 'should serve the index', (done) ->
    chai.request(@app).get('/').res (res) ->
      res.text.should.equal('<p>hello world!</p>\n')
      res.should.have.status(200)
      done()

  it 'should serve a directory index', (done) ->
    chai.request(@app).get('/foo').res (res) ->
      res.text.should.equal('<p>this is the foo folder</p>\n')
      res.should.have.status(200)
      done()

  it 'should serve a directory index with a trailing slash', (done) ->
    chai.request(@app).get('/foo/').res (res) ->
      res.text.should.equal('<p>this is the foo folder</p>\n')
      res.should.have.status(200)
      done()

  it 'should serve a nested file', (done) ->
    chai.request(@app).get('/foo/index.html').res (res) ->
      res.text.should.equal('<p>this is the foo folder</p>\n')
      res.should.have.status(200)
      done()

  it 'should error if file doesnt exist', (done) ->
    sentinel = false

    app = connect()
      .use(alchemist(path.join(base_path, 'basic')))
      .use (err, req, res, next) ->
        sentinel = true
        next()

    chai.request(app).get('/foo.html').res (res) ->
      res.should.have.status(404)
      sentinel.should.be.true
      done()

  it 'should work with a raw node http server', (done) ->
    server = http.createServer (req, res) ->
      alchemist(path.join(base_path, 'basic')) req, res, ->
        res.end()

    server.listen(1234)
    chai.request(server).get('/').res (res) ->
      res.should.have.status(200)
      res.text.should.equal('<p>hello world!</p>\n')
      server.close(done)


describe 'options', ->

  before -> @base = path.join(base_path, 'basic')

  it 'sets etags by default', (done) ->
    @app = connect().use(alchemist(@base))

    chai.request(@app).get('/').res (res) ->
      res.headers.etag.should.exist
      done()

  it 'does not set etags if "etags" option is false', (done) ->
    @app = connect().use(alchemist(@base, { etag: false }))

    chai.request(@app).get('/').res (res) ->
      should.not.exist(res.headers.etag)
      done()

  it 'does not serve dotfiles by default', (done) ->
    sentinel = false

    @app = connect()
      .use(alchemist(@base))
      .use (err, req, res, next) ->
        sentinel = true
        next()

    chai.request(@app).get('/.secret').res (res) ->
      res.should.have.status(404)
      sentinel.should.be.true
      done()

  it 'serves dotfiles if "hidden" option is true', (done) ->
    @app = connect().use(alchemist(@base, { hidden: true }))

    chai.request(@app).get('/.secret').res (res) ->
      res.should.have.status(200)
      done()

  it 'serves a different directory index if "index" option present', (done) ->
    @app = connect().use(alchemist(@base, { index: 'wow.html' }))

    chai.request(@app).get('/').res (res) ->
      res.text.should.equal("<p>alternate index</p>\n")
      done()

  it 'sets cache control headers if "maxage" option is present', (done) ->
    @app = connect().use(alchemist(@base, { maxage: 2000 }))

    chai.request(@app).get('/').res (res) ->
      res.headers['cache-control'].should.equal('public, max-age=2')
      done()

  it 'does not clobber previously set cache control headers', (done) ->
    @app = connect()
      .use((req, res, next) -> res.setHeader('cache-control', 'wow'); next() )
      .use(alchemist(@base, { maxage: 1337 }))

    chai.request(@app).get('/').res (res) ->
      res.headers['cache-control'].should.equal('wow')
      done()
