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
import Benchmark from './common/benchmark'

export default class ReactNativeBenchmark extends Component {
  constructor(props) {
    super(props);
    this.state = { results1000: 'None', results10000: 'None' };

    this.runBenchmarks1000 = () => {
      const results = Benchmark.run(1000);
      this.setState({ results1000: results });
    }

    this.runBenchmarks10000 = () => {
      const results = Benchmark.run(10000);
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
