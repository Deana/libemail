(function() {
  var client, redis;
  redis = require('redis');
  client = redis.createClient();
  this.fn = [];
  this.matchid = 3;
  client.on('ready', function() {
    return client.select(5, function(err, res) {
      return client.emit('getallfilenames');
    });
  });
  client.on('compare', function(fileid, mid) {
    if (fileid == null) {
      return;
    }
    if (mid == null) {
      return;
    }
    return client.sinter('file:words:' + fileid, 'file:words:' + mid, function(err, val) {
      if (/^\s*$/.exec(val) == null) {
        return console.log(fileid + ":" + mid + " => " + val);
      }
    });
  });
  client.on('alldone', function() {
    return client.quit();
  });
  client.on('getallfilenames', function() {
    if (this.fn == null) {
      this.fn = [];
    }
    return client.keys('orig:idx:*', function(err, res) {
      if (res != null) {
        return (function(res) {
          var fileids, val, _fn, _i, _len;
          fileids = [];
          _fn = function(val) {
            var ret;
            ret = /.*:.*:(\d+)$/.exec(val);
            if (ret != null) {
              return fileids.push(ret[1]);
            }
          };
          for (_i = 0, _len = res.length; _i < _len; _i++) {
            val = res[_i];
            _fn(val);
          }
          return client.emit('matchall', fileids);
        })(res);
      }
    });
  });
  client.on('matchall', function(fileids) {
    return (function(fileids) {
      var inputid, j, _i, _j, _len, _len2, _ref;
      _ref = process.argv;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        inputid = _ref[_i];
        if (/^\d+$/.exec(inputid) != null) {
          this.matchid = inputid;
        }
        if (fileids == null) {
          console.log("Cannot matchall, since fileids is undefined");
        }
        for (_j = 0, _len2 = fileids.length; _j < _len2; _j++) {
          j = fileids[_j];
          if (this.matchid !== j) {
            client.emit('compare', this.matchid, j);
          }
        }
      }
      return client.emit('alldone');
    })(fileids);
  });
  client.on('getwords', function(index, filename) {
    this.index = index;
    this.filename = filename;
    console.log(this.filename);
    console.log(this.index);
    if (this.index != null) {
      console.log('getting smembers for file:words:' + this.index);
    }
    return client.smembers('file:words:' + this.index, function(err, res) {
      if (res != null) {
        console.log(this.index + res);
        return res.forEach(function(resval, resindex, resarray) {
          this.resval = resval;
          this.resindex = resindex;
          this.resarray = resarray;
          if (this.resval != null) {
            return console.log(this.resval);
          }
        });
      }
    });
  });
}).call(this);
