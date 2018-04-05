const express = require('express');
var app = express();

var server = require('http').Server(app);
var io = require('socket.io')(server);

const PORT = process.env.PORT || 5000;
//const SocketManager = require('./SocketManager');

app.get('/', function(req, res) {
  res.sendFile(__dirname + '/index.html');
});

app.get('/api/hello', (req, res) => {
  res.send({express: 'Hello From Express'});
});

io.on('connection', socket => {
  console.log("Socket id:" + socket.id);
  socket.on('update', () => {
    console.log('emiting');
  });
  socket.on('connect-tablet', (msg) => {
    console.log('tablet connected! ' + msg);
  });
  socket.on('connect-sound-player', (msg) => {
    console.log('soundPlayer connected! ' + msg);
  });
  socket.on('play-intro', (id) => {
    console.log('play-intro ' + id);
    if(id === 2) {
      io.sockets.emit('play-sound');
    } else if(id === 3) {
      io.sockets.emit('pause-sound');
    }
    io.sockets.emit('play-intro', id);
  });

  socket.on('pause-sound', (id) => {
    console.log('pause-sound ' + id);
    io.sockets.emit('pause-sound', id);
  });

  socket.on('play-sound', (id) => {
    console.log('play-sound ' + id);
    io.sockets.emit('play-sound', id);
  });

  socket.on('control-co', () => {
    console.log('connexion du controleur event');
  });
});

server.listen(PORT, function() {
  console.log('listening on port:' + PORT);
});
