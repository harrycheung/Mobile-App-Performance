'use strict';

var run = require('run');

var win = Ti.UI.createWindow({
	backgroundColor: 'white',
	layout: 'vertical'
});

var btn1000 = Ti.UI.createButton({
	top: 30,
	height: 40,
	color: '#FFF',
	backgroundColor: '#000',
	title: 'Run 1000'
});
btn1000.addEventListener('click', function () {
	label1000.text = 'Running...';
	setTimeout(function () {
		label1000.text = run(1000).toString();
	}, 0);
});
win.add(btn1000);

var label1000 = Ti.UI.createLabel({
	top: 30,
	height: 40,
	color: '#000'
});
win.add(label1000);

var btn10000 = Ti.UI.createButton({
	top: 30,
	height: 40,
	color: '#FFF',
	backgroundColor: '#000',
	title: 'Run 10000'
});
btn10000.addEventListener('click', function () {
	label10000.text = 'Running...';
	setTimeout(function () {
		label10000.text = run(10000).toString();
	}, 0);
});
win.add(btn10000);

var label10000 = Ti.UI.createLabel({
	top: 30,
	height: 40,
	color: '#000'
});
win.add(label10000);

win.open();
