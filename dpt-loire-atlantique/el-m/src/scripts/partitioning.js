'use strict'

let fs		= require('fs');

const PARTION_SIZE = 250;

function run () {
	let allCities		= getAllCities();
	let partitions		= getPartitions(allCities);
	let partitionsCpt	= 0;
	partitions.forEach(partition => {
		fs.writeFile('./data/partitions/partition_' + partitionsCpt + '.json', unescape(encodeURIComponent(JSON.stringify(partition, null, "\t"))), (err) => {
			if (err) throw err;
			console.log("Partitioning ended : the file has been saved (contains", partition.length, "lines)");
		});
		partitionsCpt++;
	});
}

function getPartitions (allCities) {
	let partitions = [];
	let citiesCpt = 0;
	allCities.forEach(city => {
		let index = parseInt(citiesCpt / PARTION_SIZE);
		if (undefined == partitions[index]) {
			partitions[index] = [];
		}
		partitions[index].push(city);
		citiesCpt++;
	});
	return partitions;
}

function getAllCities () {
	let filtered	= require('./data/data_filtered.json');
	let cities		= [];
	let data		= [];
	filtered.forEach(soldat => {
		if (false == cities.includes(soldat.naissanceLieu)) {
			cities.push(soldat.naissanceLieu);
			data.push({
				city: soldat.naissanceLieu,
			});
		}
		if (false == cities.includes(soldat.decesLieu)) {
			cities.push(soldat.decesLieu);
			data.push({
				city: soldat.decesLieu,
				departement: soldat.decesDepartement,
				country: soldat.decesPays
			});
		}
	});
	return data.sort((a, b) => {
		return a.city.localeCompare(b.city);
	});
}

run();
