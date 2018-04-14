'use strict'

let fs = require('fs');

let formatted = require('./data/data_filtered.json');

let departements = [];
formatted.forEach(soldat => {
	if (false == departements.includes(soldat.decesDepartement)) {
		departements.push(soldat.decesDepartement);
	}
});

fs.writeFile('./data/departements.json', JSON.stringify(departements, null, "\t"), (err) => {
	if (err) throw err;
	console.log("The file has been saved (contains", departements.length, "lines)");
});
