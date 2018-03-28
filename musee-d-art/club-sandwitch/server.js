const express = require('express');
var app = express();

var server = require('http').Server(app);
var io = require('socket.io')(server);

const PORT = process.env.PORT || 5000;
const SocketManager = require('./SocketManager');

app.get('/', function(req, res) {
    res.sendFile(__dirname + '/index.html');
});

app.get('/api/hello', (req, res) => {
  res.send({ express: 'Hello From Express' });
});

io.on('connection', SocketManager);

server.listen(PORT, function() {
    console.log('listening on port:' + PORT);
});

