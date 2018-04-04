import React, { Component } from 'react';
import { Switch, Route } from 'react-router-dom';

import SoundPlayerPage from './Pages/SoundPlayerPage';
import TabletPage from './Pages/TabletPage';
import LandingPage from './Pages/LandingPage';
import SketchPage from './Pages/SketchPage';
import controlPage from './Pages/ControlPage';

import 'whatwg-fetch';
import './App.css';

/*



*/

class App extends Component {

  render() {

    return (
      <Switch>
        <Route exact path='/' component={LandingPage}/>
        <Route path='/tablet' component={TabletPage}/>
        <Route path='/soundplayer/:id' component={SoundPlayerPage}/>
        <Route path='/sketch' component={SketchPage}/>
        <Route path='/control' component={controlPage}/>
      </Switch>
    )
  }
}

export default App;