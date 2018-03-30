import React, { Component } from 'react';
import io from 'socket.io-client';
import ReactAudioPlayer from 'react-audio-player';
import P5Wrapper from 'react-p5-wrapper';

//import fftAnalysis from '../sketches/fftAnalysis';
import ampAnalysis from '../sketches/ampAnalysis';
//import loaderSketch from '../sketches/loaderSketch';
const socketUrl = "https://serversocket2018v2.herokuapp.com";

class SoundPlayerPage extends Component {

    constructor() {
        super();
        this.socket = io(socketUrl);//SocketIOClient('http://localhost:5000');
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
                <ReactAudioPlayer
                    src="CORNE .wav"
                    autoPlay
                    loop
                />
                <P5Wrapper sketch={ampAnalysis} />
                <p>Sound Player Page</p>
            </div>
        );
    }
}

export default SoundPlayerPage;
