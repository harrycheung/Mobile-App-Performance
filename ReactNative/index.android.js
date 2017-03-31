/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Button
} from 'react-native';
import Point from './common/point';
import Track from './common/track';
import SessionManager from './common/session_manager';
import multi_data from './common/multi';

const track = new Track({
  'track': {
    'id': '1000',
    'name': 'Test Raceway',
    'gates': [{
      'gate_type': 'SPLIT',
      'split_number': '1',
      'latitude': '37.451775',
      'longitude': '-122.203657',
      'bearing': '136'
    }, {
      'gate_type': 'SPLIT',
      'split_number': '2',
      'latitude': '37.450127',
      'longitude': '-122.205499',
      'bearing': '326'
    }, {
      'gate_type': 'START_FINISH',
      'split_number': '3',
      'latitude': '37.452602',
      'longitude': '-122.207069',
      'bearing': '32'
    }]
  }
});

const points = [];
const lines = multi_data.split('\n');
const length = lines.length;

for (let i = 0; i < length; i++) {
  const line = lines[i];
  const parts = line.split(',');

  points.push(new Point(
    parseFloat(parts[0]),
    parseFloat(parts[1]),
    false,
    parseFloat(parts[2]),
    parseFloat(parts[3]),
    5.0,
    15.0,
    0));
}

const runBenchmarks = (count) => {
  const start = (new Date()).getTime() / 1000.0;
  let timestamp = start;

  while (count--) {
    SessionManager.instance().startSession(track);

    const pointsLength = points.length;

    for (let i = 0; i < pointsLength; i++) {
      const point = points[i];
      SessionManager.instance().gps(point.latitudeDegrees(), point.longitudeDegrees(),
        point.speed, point.bearing, point.hAccuracy, point.vAccuracy, timestamp++);
    }
    SessionManager.instance().endSession();
  }
  return (new Date()).getTime() / 1000.0 - start;
}

export default class ReactNativeBenchmark extends Component {
  constructor(props) {
    super(props);
    this.state = { results1000: 'None', results10000: 'None' };

    this.runBenchmarks1000 = () => {
      const results = runBenchmarks(1000);
      this.setState({ results1000: results });
    }

    this.runBenchmarks10000 = () => {
      const results = runBenchmarks(10000);
      this.setState({ results10000: results });
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.android.js
        </Text>
        <Text style={styles.instructions}>
          Double tap R on your keyboard to reload,{'\n'}
          Shake or press menu button for dev menu
        </Text>

        <Button
          onPress={this.runBenchmarks1000}
          title="Run Benchmarks (1,000)"
          color="#841584"
          />
        <Text style={styles.instructions}>
          Results (1,000): {this.state.results1000}
        </Text>

        <Button
          onPress={this.runBenchmarks10000}
          title="Run Benchmarks (10,000)"
          color="#FF1584"
          />
        <Text style={styles.instructions}>
          Results (10,000): {this.state.results10000}
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('ReactNativeBenchmark', () => ReactNativeBenchmark);
