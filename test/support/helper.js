var chai = require('chai'),
    http = require('chai-http'),
    path = require('path'),
    alchemist_middleware = require('../..');

var should = chai.should();

chai.use(http);

global.alchemist_middleware = alchemist_middleware;
global.chai = chai;
global.should = should;
global.path = path;
global.base_path = path.join(__dirname, '../fixtures');
