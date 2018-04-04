import React, {Component} from 'react';
import io from 'socket.io-client';
import P5Wrapper from 'react-p5-wrapper';
import audio from '../sketches/audio';

const socketUrl = "https://serversocket2018v2.herokuapp.com"
//const socketUrl = "http://localhost:5000/"

const listeSound = ['CHIEN.mp3', 'COQ-POULE.mp3', 'GRENOUILLE.mp3', 'VACHE.mp3']

class SoundPlayerPage extends Component {

  constructor() {
    super();
    this.state = {
      nomFct: "",
      arg: "/Grenouille.mp3",
      socket: null
    }
  }

  componentWillMount() {
    this.initSocket()
  }

  initSocket = () => {
    const socket = io(socketUrl)
    socket.on('control-co', () => [console.log("SoundPlayer connected")])
    socket.emit('connect-tablet', listeSound[this.props.match.params.id]);
    this.setState({socket})
    socket.on('playMobile', () => this.setState({nomFct: "play"}));
    socket.on('pauseMobile', () => this.setState({nomFct: "pause"}));
  }
  render() {
    let name_file = listeSound[this.props.match.params.id]
    return (<div>
      <p>{this.props.match.params.id}</p>
      <P5Wrapper sketch={audio} nomFct={this.state.nomFct} arg={'/sonQueteChien/' + name_file}/>
    </div>);
  }
}

export default SoundPlayerPage;
