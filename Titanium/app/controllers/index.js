var Point = require('Point');

var file = Titanium.Filesystem.getFile(Ti.Filesystem.resourcesDirectory, 'multi_lap_session.csv');
var contents = file.read().text;
var points = [];
var lines = contents.split('\n');
var linesLength = lines.length;
for (var i = 0; i < linesLength; i++) {
  var line = lines[i];
  var parts = line.split(',');
  points.push(new Point(parseFloat(parts[0]), parseFloat(parts[1]), false, 
    parseFloat(parts[2]), parseFloat(parts[3]), 5.0, 5.0, 0));
}

function run1000(e) {
    alert("hello");
}

function run10000(e) {
	alert("$.button10000.text");
}

$.index.open();
