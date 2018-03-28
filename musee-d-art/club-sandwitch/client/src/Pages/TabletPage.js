import React, { Component } from 'react';
import io from 'socket.io-client';

class TabletPage extends Component {
    
    state = {
        name: 'Laouen'
    }
    constructor() {
        super();
        this.socket = io();//SocketIOClient('http://localhost:5000');
        this.socket.on('connect', () => {
            console.log(this.socket.id); // 'G5p5...'
            const idSocket = this.socket.id;
            this.socket.emit('connect-tablet', idSocket);
        });
        
        this.socket.on('update', () => this.setState({name: 'Felix'}));
      
    }
    render() {
        return (
            <div>
                <p>Tablet Page</p>
                <p>{this.state.name}</p>
            </div>
        );
    }
}

export default TabletPage;