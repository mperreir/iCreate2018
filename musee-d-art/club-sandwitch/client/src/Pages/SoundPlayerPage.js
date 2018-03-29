import React, {Component} from 'react';
import io from 'socket.io-client';
import P5Wrapper from 'react-p5-wrapper';
import audio from '../sketches/audio';

const socketUrl = "https://serversocket2018v2.herokuapp.com"

const listeSound = ['CHIEN.mp3','COQ-POULE.mp3','GRENOUILLE.mp3','VACHE.mp3']

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
    let name_file = listeSound[this.props.match.params.id]
    return (
      <div>
        <p>{this.props.match.params.id}</p>
        <P5Wrapper sketch={audio} nomFct={this.state.nomFct} arg={'/sonQueteChien/'+name_file}/>
      </div>
    );
  }
}

export default SoundPlayerPage;
