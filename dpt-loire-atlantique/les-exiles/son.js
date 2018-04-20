
function preload() {
    this.sonMatricule = loadSound('sons/defilement.mp3');
    this.sonAmbiance = loadSound('sons/ambiance.wav');
    this.sonMatricule.setVolume(0.1); //Amplitude du son7
    //this.sonAmbiance.setVolume(1);
    for (var i = 0; i < nbMatricule; i++) {
        tabSon["mat" + (i+1)] = [];
        for(var j = 4; j >=0; j--) {
            tabSon["mat" + (i+1)].push(loadSound('sons/' + (i+1) + '/' + (j+1) + '.wav'));
        }
    }
    for (var i = 0; i < nbMatricule; i++) {
        tabSon["mat" + (i+1)][0].setVolume(0.3); //REGLAGE DU VOLUME DU SON FINAL
    } 
}

function setup() {
}

function stopSons() {
    tabPlaying = [0,0,0,0,0];
    tabSon["mat" + (ordre)].map(x => {
        x.stop();
    });
}

function jouerSons(i) {
    if(i < 5 && !fin) {
        arretNumber();
        initialiser = 0;
        if(tabPlaying[i] == 0) {
            if(numPrecedent >= i) {
                deleteNumber(4-i);
            }
            else {
                addNumber(i);
            }
            numPrecedent = i;
            stopSons();
            tabPlaying[i] = 1;
            (tabSon["mat" + ordre])[i].play();
        }
        if(i == 0){
            finFun();
        }
    }
}