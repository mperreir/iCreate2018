import React, { Component } from 'react';
import io from 'socket.io-client';

const socketUrl = "http://localhost:5000"

class ControlPage extends Component {

    constructor() {
        super();
        this.state = {
            socket: null
        }
        /*this.socket = io();//SocketIOClient('http://localhost:5000');
        this.socket.on('connect', () => {
            console.log(this.socket.id);
            const idSocket = this.socket.id;
            this.socket.emit('connect-tablet', idSocket);
        });

        this.socket.on('update', () => this.setState({playing: !this.state.playing}));
        this.socket.on('playVideo', () => this.setState({playing: true}));
        this.socket.on('pauseVideo', () => this.setState({playing: false}));
        */
    }

    componentWillMount() {
        this.initSocket()
    }

    initSocket = () => {
        const socket = io(socketUrl)
        socket.on('connect', () => {
            console.log("Control connected")
        })
        this.setState({socket})
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