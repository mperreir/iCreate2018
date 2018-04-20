'use strict'

let fs		= require('fs');

let formatted = require('./data/data_formate.json');

const TOKEN = '<|>';

function run () {
	let filtered =	formatted
						.map(filter)
						.filter(soldat => soldat);

	fs.writeFile('./data/data_filtered.json', JSON.stringify(filtered, null, "\t"), (err) => {
		if (err) throw err;
		console.log("Filtering ended : the file has been saved (contains", filtered.length, "lines)");
	});
}

function filter (soldat) {
	let show =	soldat.id
			&&	soldat.naissanceDate
			&&	soldat.naissanceLieu
			&&	soldat.decesLieu
			&&	soldat.decesAge
			&&	soldat.decesDepartement
			&&	soldat.matricule
			&&	false == isNaN(soldat.matricule);
	let sId				= ('' + soldat.id).trim();
	let sMatricule		= ('' + soldat.matricule).trim();
	let sNaissDate		= ('' + soldat.naissanceDate).trim();
	let sNaissLieu		= ('' + soldat.naissanceLieu).trim();
	let sDecesAge		= soldat.decesAge;
	let sDecesLieu		= ('' + soldat.decesLieu).trim();
	let sDecesDepart	= ('' + soldat.decesDepartement).trim();

	let splitedNaissDate = sNaissDate.split('/');
	if (splitedNaissDate.length != 3) show = false;
	let naissanceAnnee = parseInt(splitedNaissDate[2]);
	if (naissanceAnnee > 1913) {
		show = false;
	}
	sNaissDate		= splitedNaissDate[1] + '/' + naissanceAnnee;
	let decesAnnee	= parseInt(splitedNaissDate[2]) + sDecesAge;
	if (decesAnnee == 1913) {
		decesAnnee = 1914;
	} else if (decesAnnee < 1913 || decesAnnee > 1918) {
		show = false;
	}
	let sDecesDate	= splitedNaissDate[1] + '/' + decesAnnee;

	let cltNaissance	= cleanToken (sNaissLieu);
	let cltDeces		= cleanToken (sDecesLieu);
	let cltDecesDptmt	= cleanToken (sDecesDepart, false);
	sNaissLieu		= cltNaissance.cleanStr;
	sDecesLieu		= cltDeces.cleanStr;
	sDecesDepart	= cltDecesDptmt.cleanStr;

	let decesPays = getCountry(sDecesDepart);

	show =	show
		&&	cltNaissance.show
		&&	cltDeces.show
		&&	cltDecesDptmt.show
		&&	decesPays != null;

	let obj = {
		id: sId,
		matricule: sMatricule,
		naissanceDate: sNaissDate,
		naissanceLieu: sNaissLieu,
		decesDate: sDecesDate,
		decesLieu: sDecesLieu,
		decesDepartement: sDecesDepart,
		decesPays: decesPays,
		decesAge: sDecesAge
	}
	return	show ? obj : undefined;
};

function getCountry (department) {
	let country;
	let found = false;
	let departementsRetravailles = require('./data/departements_retravailles.json');
	departementsRetravailles.forEach(e => {
		if (department == e.departement) {
			found = true;
			country = e.country;
			return;
		}
	});
	return found ? country : department;
}

function cleanToken (str, rotate=true) {
	if ( ! rotate) return { show: true, cleanStr: str.replace('<|>', ',') }
	let show = true;
	let cleanStr = str;
	if (str.includes(TOKEN)) {
		let splitedDeathPlace = str.split(TOKEN);
		if (splitedDeathPlace.length > 1) {
			if (splitedDeathPlace.length == 2) {
				cleanStr = splitedDeathPlace[1].trim() + ' ' + splitedDeathPlace[0].trim();
			} else {
				show = false;
			}
		}
	}
	return {
		show: show,
		cleanStr: cleanStr
	};
}

run();
