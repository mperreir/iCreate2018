import React, { Component } from 'react'
import P5Wrapper from 'react-p5-wrapper'

//import fftAnalysis from '../sketches/fftAnalysis'
import ampAnalysis from '../sketches/ampAnalysis'
//import loaderSketch from '../sketches/loaderSketch'
const socketUrl = "https://serversocket2018v2.herokuapp.com"
//const socketUrl = "http://localhost:5000"


class SoundPlayerPage extends Component {

    render() {
        return (
            <div>
                <P5Wrapper sketch={ampAnalysis}/>
                <p>Sound Player Page</p>
            </div>
        )
    }
}

export default SoundPlayerPage
