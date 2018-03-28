import React, { Component } from 'react';
import io from 'socket.io-client';

class ControlPage extends Component {

    constructor() {
        super();
        this.socket = io();//SocketIOClient('http://localhost:5000');
        this.socket.on('connect', () => {
            console.log(this.socket.id);
            const idSocket = this.socket.id;
            this.socket.emit('connect-tablet', idSocket);
        });

        this.socket.on('update', () => this.setState({playing: !this.state.playing}));
        this.socket.on('playVideo', () => this.setState({playing: true}));
        this.socket.on('pauseVideo', () => this.setState({playing: false}));

    }

    launchQuest() {
        console.log('Launch Quest');
        this.socket.emit('launch-quest');
    }

    render() {
        return (
            <div>
                <h1>Control Page</h1>
                <button onClick={this.launchQuest}>Launch quest</button>
            </div>
        );
    }
}

export default ControlPage;