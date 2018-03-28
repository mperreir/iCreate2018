const io = require('./server.js').io;

module.exports = function(socket) {
    console.log("Socket id:" + socket.id);
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
};