connect = require 'connect'

describe 'basic', ->

  it 'should be registered as middleware', ->
    (-> connect().use(alchemist_middleware())).should.not.throw()

  it 'should modify a request body', (done) ->
    app = connect().use(alchemist_middleware("middleware'd!"))

    chai.request(app).get('/').res (res) ->
      res.should.have.status(500)
      res.text.should.equal("middleware'd!")
      done()
