import React, { Component } from 'react';
import io from 'socket.io-client';
import videos from '../sketches/videos';
import P5Wrapper from 'react-p5-wrapper';
import Fullscreen from 'react-fullscreen-crossbrowser';

class TabletPage extends Component {

    state = {
        name: 'Laouen',
        playing: true
    }
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
    render() {
        return (
            <div>
                <button onClick={() => this.setState({isFullscreenEnabled: true})}>
                    Go Fullscreen
                </button>

                <Fullscreen
                    enabled={this.state.isFullscreenEnabled}
                    onChange={isFullscreenEnabled => this.setState({isFullscreenEnabled})}>
                        <div className='full-screenable-node'>
                            <P5Wrapper sketch={videos} video_name={"3-stop-motion.mp4"} isplaying={this.state.playing}/>
                        </div>
                </Fullscreen>
            </div>
        );
    }
}

export default TabletPage;
