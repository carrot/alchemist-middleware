var chai = require('chai'),
    http = require('chai-http'),
    path = require('path'),
    alchemist = require('../..');

var should = chai.should();

chai.use(http);

global.alchemist = alchemist;
global.chai = chai;
global.should = should;
global.path = path;
global.base_path = path.join(__dirname, '../fixtures');
