var net = require('net');
var server = net.createServer(function(socket) {
	socket.write('Echo server\r\n');
    socket.on('data', (data) => {
        // console.log('Received: ', data);
        socket.write(data);
    });
	// socket.pipe(socket);
});

server.listen(4999, '127.0.0.1');
