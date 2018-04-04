import React, { Component } from 'react'
import socketIOClient from 'socket.io-client'
import videos from '../sketches/videos'
import P5Wrapper from 'react-p5-wrapper'
import Fullscreen from 'react-fullscreen-crossbrowser'

const socketUrl = "https://serversocket2018v2.herokuapp.com"

class TabletPage extends Component {

    constructor(props) {
        super(props)
        this.state = {
            name: 'Laouen',
            playing: false,
            socket: null,
            playIntro: false,
            isFullscreenEnabled: false,
            video_name: "./video/1.mp4",
            id_current_video: 1
        }
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
            let vname;
            if(id === this.state.id_current_video){
                this.setState({playing: !this.state.playing})
            } else {
                switch(id){
                    case 1:
                        vname = "1.mp4";
                        break;
                    case 2:
                        vname = "2.mp4";
                        break;
                    case 3:
                        vname = "3.mp4";
                        break;
                    default:
                        vname = "1.mp4";
                }
                this.setState({video_name: './video/'+vname})
                this.setState({playing: true})
                this.setState({id_current_video: id})
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
                            <P5Wrapper socket={this.state.socket} sketch={videos} video_name={this.state.video_name} isplaying={this.state.playing}/>
                        </div>
                </Fullscreen>
            </div>
        )
    }
}

export default TabletPage
