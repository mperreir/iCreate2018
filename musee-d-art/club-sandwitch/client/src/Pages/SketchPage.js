import React, { Component } from 'react';
import ReactAudioPlayer from 'react-audio-player';
import P5Wrapper from 'react-p5-wrapper';

import fftAnalysis from '../sketches/fftAnalysis';

class SoundPlayerPage extends Component {

    render() {
        return (
            <div>
                <P5Wrapper sketch={fftAnalysis} />
                <p>Sound Player Page</p>
            </div>
        );
    }
}

export default SoundPlayerPage;