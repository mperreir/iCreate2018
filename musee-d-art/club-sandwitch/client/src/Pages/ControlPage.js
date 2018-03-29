import React, { Component } from 'react';
import socketIOClient from 'socket.io-client';

const socketUrl = "http://serversocket2018v2.herokuapp.com"

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

class ControlPage extends Component {

    constructor(props) {
        super(props);
        this.state = {
            name: 'df',
            socket: null
        }
    }

    componentWillMount() {
        this.initSocket()
    }

    initSocket = () => {
        const socket = socketIOClient(socketUrl)
        socket.on('connect', () => {
            console.log("Control connected")
            socket.emit('control-co');
        })
        this.setState({socket})
    }

    play1() {
        console.log('playIntro');
        this.state.socket.emit('play-intro',1);
    }
    play2() {
        console.log('playIntro');
        this.state.socket.emit('play-intro',2);
    }
    play3() {
        console.log('playIntro');
        this.state.socket.emit('play-intro',3);
    }
    play4() {
        console.log('playIntro');
        this.state.socket.emit('play-intro',4);
    }
    play5() {
        console.log('playIntro');
        this.state.socket.emit('play-intro',5);
    }
    play6() {
        console.log('playIntro');
        this.state.socket.emit('play-intro',6);
    }
    play7() {
        console.log('playIntro');
        this.state.socket.emit('play-intro',7);
    }
    play8() {
        console.log('playIntro');
        this.state.socket.emit('play-intro',8);
    }

    render() {
        return (
            <div>
                <h1>Control Page : {this.state.name}</h1>
                <button onClick={this.play1.bind(this)}>Play 1</button>
                <button onClick={this.play2.bind(this)}>Play 2</button>
                <button onClick={this.play3.bind(this)}>Play 3</button>
                <button onClick={this.play4.bind(this)}>Play 4</button>
                <button onClick={this.play5.bind(this)}>Play 5</button>
                <button onClick={this.play6.bind(this)}>Play 6</button>
                <button onClick={this.play7.bind(this)}>Play 7</button>
                <button onClick={this.play8.bind(this)}>Play 8</button>
            </div>
        );
    }
}

export default ControlPage;
