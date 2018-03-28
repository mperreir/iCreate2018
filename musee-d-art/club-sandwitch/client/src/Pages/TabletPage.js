import React, { Component } from 'react';
import io from 'socket.io-client';
import videos from '../sketches/videos';
import P5Wrapper from 'react-p5-wrapper';

class TabletPage extends Component {

    state = {
        name: 'Laouen',
        playing: true
    }
    constructor() {
        super();
        this.socket = io();//SocketIOClient('http://localhost:5000');
        this.socket.on('connect', () => {
            console.log(this.socket.id); // 'G5p5...'
            const idSocket = this.socket.id;
            this.socket.emit('connect-tablet', idSocket);
        });

        this.socket.on('update', () => this.setState({playing: true}));
        this.socket.on('playVideo', () => this.setState({playing: true}));
        this.socket.on('pauseVideo', () => this.setState({playing: false}));

    }
    render() {
        return (
            <P5Wrapper sketch={videos} video_name={"video1.mp4"} isplaying={this.state.playing}/>
        );
    }
}

export default TabletPage;
