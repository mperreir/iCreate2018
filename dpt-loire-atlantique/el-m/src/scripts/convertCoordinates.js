'use strict'

let fs = require('fs');

function run () {
	let result 			= require('./data/result/final_result.json');
	let convertedResult	= result.map(r => {
		let convertedNaissance	= convertCoordinates(r.xNaissance, r.yNaissance);
		let convertedDeces		= convertCoordinates(r.xDeces, r.yDeces);
		r.xNaissance	= (convertedNaissance.x).toString();
		r.yNaissance	= (convertedNaissance.y).toString();
		r.xDeces		= (convertedDeces.x).toString();
		r.yDeces		= (convertedDeces.y).toString();
		return r;
	});

	fs.writeFile('./data/converted_result.json', JSON.stringify(convertedResult, null, "\t"), (err) => {
		if (err) throw err;
		console.log("The file has been saved (contains", convertedResult.length, "lines)");
	});
}

function convertCoordinates (latitude, longitude) {
	return {
		x: ((((longitude - 14.15) * Math.cos(42.7)) / 13.20)) + 0.5,
		y: ((- (latitude - 42.7) / 26.7) + 0.5)
	}
}

run();
