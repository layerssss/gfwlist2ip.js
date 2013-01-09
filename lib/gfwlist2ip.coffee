request = require 'request'
module.exports = 
  list: []
  gfwlist: null
  gfwlistSource: 'https://autoproxy-gfwlist.googlecode.com/svn/trunk/gfwlist.txt'
  initGfwlist: (callback)->
    _self=this
    request _self.gfwlistSource, (err, res, data)->

      _self.gfwlist = new Buffer data, 'base64'
      _self.gfwlist = _self.gfwlist.toString()

      for line in _self.gfwlist.match /([0-9a-z]+\.)+[0-9a-z]+/ig
        _self.list.push line
      
      callback null
