chai = require 'chai'  
chai.should()
gfwlist2ip = require '../lib/gfwlist2ip'


describe 'gfwlist2ip',->
  before (done)->
    gfwlist2ip.initGfwlist done

  describe 'list',->
    it 'should be an Array',->
      gfwlist2ip.list.should.be.a 'array'

  describe 'resolve',->
    it 'should complete',(done)->
      gfwlist2ip.resolve done

