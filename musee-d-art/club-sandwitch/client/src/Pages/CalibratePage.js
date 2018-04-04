import React, {Component} from 'react'
import P5Wrapper from 'react-p5-wrapper'
import audio from '../sketches/audio'

const listeSound = ['CHIEN.mp3', 'COQ-POULE.mp3', 'GRENOUILLE.mp3', 'VACHE.mp3']

class CalibratePage extends Component {

  constructor() {
    super()
    this.state = {
      sound: "/None.mp3"
    }
  }

  render() {
    let name_file = listeSound[this.props.match.params.id]
    this.setState({sound : name_file})

    return (
        <div>
            <p>djdjfjdfj</p>
            <p>{name_file}</p>
            <P5Wrapper sketch={audio} arg={'/sonQueteChien/' + name_file}/>
        </div>
    )
  }
}

export default CalibratePage;
