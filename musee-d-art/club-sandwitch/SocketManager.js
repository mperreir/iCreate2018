const io = require('./server.js').io;

module.exports = function(socket) {
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
    socket.on('play', () => {
        console.log('launch-quest');
        socket.emit('play');
    });

    socket.on('control-co', () => {
        console.log('connexion du controleur event');
    });
};