import React, {Component} from 'react';
import io from 'socket.io-client';
import P5Wrapper from 'react-p5-wrapper';
import audio from '../sketches/audio';

const socketUrl = "http://localhost:5000"

class SoundPlayerPage extends Component {

  constructor() {
    super();
    this.state = {
      nomFct: "",
      arg: "/Grenouille.mp3",
      socket: null
    }
    /*this.socket = io();
    this.socket.on('connect', () => {
      console.log(this.socket.id); // 'G5p5...'
      const idSocket = this.socket.id;
      this.socket.emit('connect-tablet', idSocket);
    });
    this.socket.on('update', () => this.setState({nomFct: "play"}));
    this.socket.on('stopSong', () => this.setState({nomFct: "stop"}));
    this.socket.on('pauseSong', () => this.setState({nomFct: "pause"}));*/
  }

  componentWillMount() {
    this.initSocket()
  }

  initSocket = () => {
    const socket = io(socketUrl)
    socket.on('connect', () =>[
      console.log("SoundPlayer connected")
    ])
    this.setState({socket})
  }
  render() {
    return (
      <P5Wrapper sketch={audio} nomFct={this.state.nomFct} arg={this.state.arg}/>
    );
  }
}

export default SoundPlayerPage;
