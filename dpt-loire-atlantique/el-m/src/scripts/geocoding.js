'use strict'

let fs		= require('fs');
let https	= require('https');

const KEY		= 'AIzaSyA1jHSq6UtePZ3DxuEdLUUuhJsK1xob7I8';
const BASE_URL	= 'https://maps.googleapis.com/maps/api/geocode/json?address=';
const END_URL	= '&key=' + KEY;

function run (partitionIndex) {
	let cities = require('./data/partitions/partition_' + partitionIndex + '.json');
	let debugMessage = 'Geocoding partition ' + partitionIndex + ' (' + cities.length + ' elements)';
	console.log(debugMessage);
	fs.appendFile('./data/coordinates/logs.txt', debugMessage + '\n', err => {
		if (err) throw err;
	});
	geocoding(cities, partitionIndex, printCoordinates);
}

function getToday() {
	let today = new Date();
	let day		= today.getDate();
	let month	= today.getMonth() + 1;
	let year	= today.getFullYear();
	let hours	= today.getHours();
	let minutes	= today.getMinutes();
	let seconds = today.getSeconds();
	day = (day < 10) ? '0' + day : day;
	month = (month < 10) ? '0' + month : month;
	hours = (hours < 10) ? '0' + hours : hours;
	minutes = (minutes < 10) ? '0' + minutes : minutes;
	seconds = (seconds < 10) ? '0' + seconds : seconds;
	let todayStr = year + '_' + month + '_' + day + '_' + hours + '_' + minutes + '_' + seconds;
	return todayStr;
}

function geocoding (cities, partIndex, callback, coordinates=[]) {
	if (0 == cities.length) {
		callback(coordinates, partIndex);
		return;
	} else {
		let todayStr	= getToday();
		let cityObj		= cities[0];
		let city		= cityObj.city;
		let country		= cityObj.country;
		let countryStr	= country == undefined ? "" : "&components=country:" + country;
		cities.splice(0, 1);	// remove the first city (index 0) of the cities
		var req = https.get(BASE_URL + city + countryStr + END_URL, res => {
			var data = "";
			res.on('data', d => {
				data += d
			})
			res.on('end', () => {
				data = JSON.parse(data);
				let obj = {};
				if (data.status == "OK" && data.results.length > 0) {
					obj.ville		= city;
					obj.latitude	= data.results[0].geometry.location.lat;
					obj.longitude	= data.results[0].geometry.location.lng;
					let converted = convertCoordinates(obj.latitude, obj.longitude);
					obj.x	= converted.x;
					obj.y	= converted.y;
					if (obj.x >= 0 && obj.x <= 1 && obj.y >= 0 && obj.y <= 1) {
						coordinates.push(obj);
					}
				} else {
					fs.appendFile('./data/coordinates/logs.txt', todayStr + ' (' + JSON.stringify(city) + ') : ' + data.status + '\n', err => {
						if (err) throw err;
					});
				}
				geocoding(cities, partIndex, callback, coordinates);
			});
		});
		req.on('error', e => {
			console.log(city + countryStr)
			console.error(e);
		});
		req.end();
	}
}

function convertCoordinates (latitude, longitude) {
	return {
		x: ((((longitude - 14.15) * Math.cos(42.7)) / 13.20)) + 0.5,
		y: ((- (latitude - 42.7) / 26.7) + 0.5)
	}
}

function printCoordinates (coordinates, partIndex) {
	coordinates.filter(coordinate => coordinate != null);
	let todayStr = getToday();
	fs.writeFile('./data/coordinates/' + 'coordinates_' + partIndex + '.json', JSON.stringify(coordinates, null, "\t"), (err) => {
		if (err) throw err;
		let debugMessage = 'Partition ' + partIndex + ' has been geolocalized and the file has been saved (contains ' + coordinates.length + ' lines)';
		console.log(debugMessage);
		fs.appendFile('./data/coordinates/logs.txt', debugMessage + '\n', err => {
			if (err) throw err;
		});
	});
}

run(process.argv[2] ? process.argv[2] : 21);