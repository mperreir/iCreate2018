const express = require('express');
var app = express();

var server = require('http').Server(app);
var io = require('socket.io')(server);

app.get('/', function(req, res) {
    res.sendFile(__dirname + '/index.html');
});

app.get('/api/hello', (req, res) => {
  res.send({ express: 'Hello From Express' });
});

io.on('connection', function(socket) {
    console.log(socket.id);
    socket.on('update', () => {
        console.log('emiting');
        io.emit('update');
    });
    socket.on('connect-tablet', (msg) => {
      console.log('tablet connected! ' + msg);
    });
    socket.on('connect-sound-player', (msg) => {
        console.log('soundPlayer connected! ' + msg);
    });
    socket.on('lauch-quest', () => {
        console.log('lauch-quest');
        io.emit('update');
    });
});

server.listen(process.env.PORT || 5000, function() {
    console.log('listening on port');
});

