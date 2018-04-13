'use strict'

let fs = require('fs');

function run () {
	let filtered	= require('./data/data_filtered.json');
	let cities		= getAllCities();
	let result		= associateCoordinatesToCities(filtered, cities);
	fs.writeFile('./data/final_result.json', JSON.stringify(result, null, "\t"), (err) => {
		if (err) throw err;
		console.log("The file has been saved (contains", result.length, "lines)");
	});
}

function associateCoordinatesToCities (filtered, cities) {
	return filtered.map(soldat => {
		let finalObj = {
			id:				parseInt(soldat.id),
			matricule:		parseInt(soldat.matricule),
			dateNaissance:	soldat.naissanceDate,
			dateDeces:		soldat.decesDate
		};
		let foundNaissance	= false;
		let foundDeces		= false;
		cities.forEach(city => {
			if (city.ville == unescape(encodeURIComponent(soldat.naissanceLieu))) {
				foundNaissance		= true;
				finalObj.xNaissance	= (city.x).toString();
				finalObj.yNaissance	= (city.y).toString();
				return;
			}
			if (city.ville == unescape(encodeURIComponent(soldat.decesLieu))) {
				foundDeces		= true;
				finalObj.xDeces	= (city.x).toString();
				finalObj.yDeces	= (city.y).toString();
				return;
			}
		});
		return (foundNaissance && foundDeces) ? finalObj : undefined;
	}).filter(soldat => soldat);
}

function getAllCities () {
	let cities = [];
	let files = fs.readdirSync('./data/coordinates');
	files.forEach(filename => {
		if (filename.startsWith('coordinates_')) {
			cities = cities.concat(require('./data/coordinates/' + filename));
		}
	});
	return cities;
}

run();
