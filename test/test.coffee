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
