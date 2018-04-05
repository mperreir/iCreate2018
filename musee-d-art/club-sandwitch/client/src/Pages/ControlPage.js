import React, { Component } from 'react'
import socketIOClient from 'socket.io-client'

const socketUrl = "https://serversocket2018v2.herokuapp.com"
//const socketUrl = "http://localhost:5000"

class ControlPage extends Component {

  constructor(props) {
    super(props)
    this.state = {
      name: 'control-on',
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
    socket.on('connect-tablet', () => {
      console.log("Tablet connectée")
    })
    this.setState({socket})
  }

  play1() {
    console.log('playIntro 1')
    this.state.socket.emit('play-intro', 1)
  }

  play2() {
    console.log('playIntro 2')
    this.state.socket.emit('play-intro', 2)
  }

  play3() {
    console.log('playIntro 3')
    this.state.socket.emit('play-intro', 3)
  }

  pauseMobile() {
    console.log('pause-sound')
    this.state.socket.emit('pause-sound', 8)
  }

  playMobile() {
    console.log('play-sound')
    this.state.socket.emit('play-sound', 8)
  }

  render() {

    return (
      <div>
        <h1>Control Page : {this.state.name}</h1>
        <button onClick={this.play1.bind(this)}>Play 1</button>
        <button onClick={this.play2.bind(this)}>Play 2</button>
        <button onClick={this.play3.bind(this)}>Play 3</button>
        <button onClick={this.playMobile.bind(this)}>Play sound mobile</button>
        <button onClick={this.pauseMobile.bind(this)}>Pause sound mobile</button>
      </div>
    )
  }
}

export default ControlPage
