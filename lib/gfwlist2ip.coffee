request = require 'request'
dns     = require 'dns'

module.exports = 
  list: []
  _gfwlistArray: []
  gfwlistSource: 'https://autoproxy-gfwlist.googlecode.com/svn/trunk/gfwlist.txt'
  initGfwlist: (callback)->
    _self = this
    request _self.gfwlistSource, (err, res, data)->
      return callback err if err
      gfwlist = new Buffer data, 'base64'
      gfwlist = gfwlist.toString()

      gfwdomains = []
      for line in gfwlist.match /([0-9a-z]+\.)+[0-9a-z]+\*?/ig
        _self._gfwlistArray.push line
        gfwdomains.push line.replace /\*$/,''

      iteration = (cb)->
        if gfwdomains.length
          _self.resolve gfwdomains.pop(), ()->
            iteration cb
        else
          cb()
      iteration ()->
        callback null

  onResolved: (address)->
    @list.push address
    console.log "#{address} is in gfwlist"

  resolve: (domain,callback)->
    _self = this

    matched = false
    for line in _self._gfwlistArray
      # endswith 
      i = line.lastIndexOf(domain)
      if i==-1 then continue
      if i+domain.length == line.length
        matched = true
        break
      if i+domain.length+1 == line.length
        matched = true
        break
    if matched
      dns.resolve4 domain, 4, (err, addresses)->
        return callback err if err
        for address in addresses
          _self.onResolved address
        callback null
    else
      callback null
