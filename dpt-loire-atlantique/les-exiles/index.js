//console.log(dataFile);	

/*console.log("ICI");


function getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max));
}*/

// Initialisation serveur ////////////////////
// Imports
var express = require('express')
var path    = require("path");

// Paramètres du serveur
var port = process.env.PORT || 8080; //Récupère le port dans la variable environnement si indiqué dans le système
var hostname = process.env.HOST || '0.0.0.0';

// Instanciation du serveur
var app = express();

app.use(express.static(__dirname + '/'));

// Résout le problème des requètes CORS-ENABLE
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname+'/vue.html'));
})

// Lancement du serveur
app.listen(port, hostname, function(){
    console.log('Le serveur écoute sur le port ' + port);
});
/////////////////////////////////////////////////////////
