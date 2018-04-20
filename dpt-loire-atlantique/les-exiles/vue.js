//Paramètres modifiables
var tabMatricule = ["00226", "03593", "01303", "01259", "02589", "00940", "00698", "00949", "00482", "01210", "03400", "00342", "02589", "03203"]; //Matricule où le compteur peut stopper
var sizeMatricule = 5; //Taille max de nos matricules
var dureeAnimation = 40; //rapidité défilement
var nbP = 5; //Nombre de repères au sol
//Double info age 00940 pas de son 3400

//////Noir personnalisé////////////
tracking.ColorTracker.registerColor('noirCreate', function(r, g, b) {
  if (r < 50 && g < 50 && b < 50) {
    return true;
  }
  return false;
});
//////////

var tabPlaying = [0,0,0,0,0]; //Tableau à 0 quand le son est stoppé
var myApp = angular.module('myApp', []);
var enCours = true; //Si les numéros sont entrain de tourner
var selectMatricule; //Matricule sélectionné
var ordre = 0; //Numéro du matricule dont on raconte l'histoire
var colors = new tracking.ColorTracker(['noirCreate']); //Couleur à tracker definie ci-dessus
var pointsFixes = []; //Tableau comportant les coordonées des pastilles
var tra; //Tracker une fois lancé
var seuil = 1; //Seuil pour la fusion de détections trop proches
var suppresion = 0; //Variable pour compter le nombre de détections fusionées
var nbMatricule = 14; //Nombre de matricule
var tabSon = {}; //Tableau comportant tous les sons pour tous les matricules
var numPrecedent = 10; //Retient le dernier nombre d'occurence
var tabNomsSons = ["naissance.mp3", "profession.mp3", "volontaire.mp3", "age.mp3", "mort-pour-la-france.mp3"]; //Noms des sons à charger
var initialiser = 1; //0 si initialisé
var fin = 0; //1 si fini
var debutCache = 1; //Pour cacher
var sonMatricule; //Son du matricule
var sonAmbiance; //Son d'ambiance

myApp.controller('MainCtrl', ['$scope', function ($scope) {
    $scope.text = '';
    for(var j = 0; j < sizeMatricule; j++) {
        $scope.text += '0'; //Initialisation du matricule à 0000000
    }
}]);

//Fin de l'atelier, puis redemarrage automatiqe 20 secondes après
function finFun() {
    tra.stop();
    fin = 1;
    this.sonAmbiance.fade(0, 8); //valeur,secondes
    //this.sonAmbiance.stop();
    console.log("Fin: redemarre dans 30sec");
    setTimeout(function () {
        window.location.reload(true);
    }, 20000);
}

//Fonction pour initialiser nos variables
function intialisation() {
    console.log("Reintialisation");
    initialiser = 1;
    fin = 0;
    tabPlaying = [0,0,0,0,0]; //Tableau à 0 quand le son est stoppé
    enCours = false; //Si les numéros sont entrain de tourner
    selectMatricule; //Matricule sélectionné
    pointsFixes = []; //Tableau comportant les coordonées des pastilles
    seuil = 1; //Seuil pour la fusion de détections trop proches
    suppresion = 0; //Variable pour compter le nombre de détections fusionées
    nbMatricule = 14; //Nombre de matricule
    numPrecedent = 10; //Retient le dernier nombre d'occurence
    //Scanne les tâches pour initialiser
    initialiserPointsFixes();
    if(debutCache) {
        debutCache = 0;
        setTimeout(function() {
            startNumber();
            cacheGomettes();
        }, 3000);
    }
}

//Sélectionne la balise vidéo dans le code HTML
var vid = document.querySelector('video');

//Permet de changer rapidement les nombres
function animateNumber() {
    var matriculeTotal = getNumberFiveNumber().toString(); //Recupere un nombre avec maximum cinq chiffres
    afficherMatricule(matriculeTotal);
}

//Donne un nombre aléatoire à cinq chiffres
function getNumberFiveNumber() {
    return (getRandomInt(10)*10000 + getRandomInt(10)*1000 + getRandomInt(10)*100 + getRandomInt(10)*10 + getRandomInt(10));
}
//
function getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max));
}

//Recupere aléatoirement un matricule du tableau tabMatricule
function recupererMatriculeAlea() { 
    return this.tabMatricule[getRandomInt((this.tabMatricule).length)];
}

//Permet d'arreter le defilement des nombres
function arretNumber() {
    if (this.enCours) {
        this.sonMatricule.stop();
        this.sonAmbiance.fade(0.8 , 1) //Volume son ambiance
        this.sonAmbiance.loop();
        numPrecedent = 10;
        this.enCours = false;
        clearInterval(this.changeNumber);
        // On se bloque sur un matricule connu
        selectMatricule = (this.recupererMatriculeAlea()).toString();
        ordre = (tabMatricule.indexOf(selectMatricule))+1;
        afficherMatricule(selectMatricule);
    }
}

//Remplie à 5 chiffres et affiche le matricule dans la vue.html
function afficherMatricule(m) {
    while (m.length < sizeMatricule) { //Permet de rajouter des zéros au début du nombre s'il fait moins de cinq chiffres
        m = '0' + m;
    }
    for(var i = 0; i < sizeMatricule; i++) {
        $("#" + i).text(m[i]); //Change le matricule
    }   
}

//Permet de relancer le defilement des nombres
function startNumber() {
    if(!this.enCours){
        this.sonAmbiance.stop();
        this.sonMatricule.stop();
        this.sonMatricule.loop();
        this.enCours = true;
        displayNumber(); //Remet tous les chiffres opaques
        this.changeNumber = setInterval(function () {
            animateNumber();
        }, dureeAnimation); //Vitesse du changement
    }
}

//Permet de supprimer les chiffres dans l'ordre de gauche à droite
function deleteNumber(indice) {
    if(!this.enCours) {
        for(var i = 0; i <= indice; i++) {
            $("#" + i).velocity({
                properties: { opacity: 0 },
                options: { duration: 1000 }
            });
        }
    }
    else {
        displayNumber(); 
    }
}

function addNumber(indice) {
    if(!this.enCours) {
        for(var i = 4; i >= (5-indice); i--) {
            $("#" + i).velocity({
                properties: { opacity: 1 },
                options: { duration: 1000 }
            });
        }
    }
    else {
        displayNumber(); 
    }
}

//Remet tous les chiffres opaques
function displayNumber() {
    for(var i = 0; i < sizeMatricule; i++) {
        $("#" + i).css('opacity', '1'); //Change le matricule
    }   
}

function plotRectangle(el, rect) {
    var div = document.createElement('div');
    div.setAttribute("class", "rectDraw");
    div.style.position = 'absolute';
    div.style.border = '5px solid ' + ('red');
    div.style.width = rect.width + 'px';
    div.style.height = rect.height + 'px';
    div.style.left = el.offsetLeft + rect.x + 'px';
    div.style.top = el.offsetTop + rect.y + 'px';
    document.body.appendChild(div);
    return div;
}

tra = tracking.track('#myVideo', colors, { camera: true });
intialisation();