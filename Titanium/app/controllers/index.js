var run = require('run');

function run1000() {
  $.label1000.text = run(1000).toString();
}

function run10000() {
  $.label10000.text = run(10000).toString();
}

$.index.open();