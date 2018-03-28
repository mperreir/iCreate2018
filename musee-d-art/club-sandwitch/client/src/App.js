import React, { Component } from 'react';
import { Switch, Route } from 'react-router-dom';

import SoundPlayerPage from './Pages/SoundPlayerPage';
import TabletPage from './Pages/TabletPage';
import LandingPage from './Pages/LandingPage';
import SketchPage from './Pages/SketchPage';
import controlPage from './Pages/controlPage';

import 'whatwg-fetch';
import './App.css';

class App extends Component {

  state = {
    response: ''
  };

  componentDidMount() {
    this.callApi()
      .then(res => this.setState({ response: res.express }))
      .catch(err => console.log(err));
  }

  callApi = async () => {
    const response = await fetch('/api/hello');
    const body = await response.json();
    if (response.status !== 200) throw Error(body.message);
    return body;
  };

  render() {
    return (
      <Switch>
        <Route exact path='/' component={LandingPage}/>
        <Route path='/tablet' component={TabletPage}/>
        <Route path='/soundplayer' component={SoundPlayerPage}/>
        <Route path='/sketch' component={SketchPage}/>
        <Route path='/control' component={controlPage}/>
      </Switch>
    );
  }
}

export default App;