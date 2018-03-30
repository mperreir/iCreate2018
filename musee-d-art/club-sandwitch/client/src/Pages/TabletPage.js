import React, { Component } from 'react';
import socketIOClient from 'socket.io-client';
import videos from '../sketches/videos';
import P5Wrapper from 'react-p5-wrapper';
import Fullscreen from 'react-fullscreen-crossbrowser';

const socketUrl = "http://serversocket2018v2.herokuapp.com"

class TabletPage extends Component {

    constructor() {
        super();
        this.state = {
            name: 'Laouen',
            playing: false,
            socket: null,
            playIntro: false,
            isFullscreenEnabled: false,
            video_name: "video/1TABLEAUPSSTEHTOI!.mp4"
        }

        /*this.socket.on('connect', () => {
            console.log(this.socket.id);
            const idSocket = this.socket.id;
            this.socket.emit('connect-tablet', idSocket);
        });

        this.socket.on('update', () => this.setState({playing: !this.state.playing}));
        this.socket.on('playVideo', () => this.setState({playing: true}));*/

    }

    componentWillMount() {
        this.initSocket()
    }

    initSocket() {
        const socket = socketIOClient(socketUrl)
        socket.on('connect', () => {
            console.log("Tablet connected")
            socket.emit('connect-tablet', socket.id)
        })
        socket.on('play-intro', (id) => {
            console.log('start playing intro ' + id)
            if(id === 1) {
                this.setState({playing: !this.state.playing})
            } else {
                this.setState({video_name: './video/2APPARITIONFORMULEMAGIQUE.mp4'})
            }

        })

        this.setState({socket})

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
                            <P5Wrapper sketch={videos} video_name={this.state.video_name} isplaying={this.state.playing}/>
                        </div>
                </Fullscreen>
            </div>
        )
    }
}

export default TabletPage;
