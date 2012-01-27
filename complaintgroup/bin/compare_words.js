(function() {
  var NGram, client, redis;
  redis = require('redis');
  client = redis.createClient();
  this.fn = [];
  this.matchid = 3;
  this.done = {};
  NGram = (function() {
    function NGram(redis) {
      this.redis = redis;
    }
    NGram.prototype.compare = function(fileid1, fileid2) {
      this.fileid1 = fileid1;
      this.fileid2 = fileid2;
      this.redis.sinter('file:words:' + this.fileid1, 'file:words:' + this.fileid2, function(err, val) {});
      return console.log("Results: " + val);
    };
    return NGram;
  })();
  client.on('ready', function() {
    return client.select(5, function(err, res) {
      return client.emit('processargs');
    });
  });
  client.on('processargs', function() {
    var inputid, _fn, _i, _len, _ref;
    _ref = process.argv;
    _fn = function(inputid) {
      var val;
      val = /^\d+$/.exec(inputid);
      if (val != null) {
        console.log('processing ' + inputid);
        return client.smembers('file:words:' + inputid, function(err, val) {
          var i, _j, _len2, _results;
          console.log(inputid + " => " + val);
          _results = [];
          for (_j = 0, _len2 = val.length; _j < _len2; _j++) {
            i = val[_j];
            _results.push(client.smembers("set:ngram:" + i, function(err, v2) {
              if (inputid !== (v2 != null)) {
                return console.log("Comparing " + inputid + " and " + v2);
              }
            }));
          }
          return _results;
        });
      }
    };
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      inputid = _ref[_i];
      _fn(inputid);
    }
    return client.emit('alldone');
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
}).call(this);
