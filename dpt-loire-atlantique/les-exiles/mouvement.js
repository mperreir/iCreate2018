function cacheGomettes() {
    var detection = 20;
    var occu = 10;
    var tabOccu = [0,0,0,0,0];
    var tabMoyenne = [0,0,10];
    var ite = 0;
    var nbPastille = 0;
    var compt = 0;
    var compteurFin = 0;
    colors.on('track', function(event) {
        if (event.data.length === 0) {
            compt++;
            if(compt >= 10) {
                jouerSons(0);
                //suppressionRectangle();
            }
        } 
        else {
            compt = 0;
            occu = 10;
            tabOccu = [0,0,0,0,0];
            nbPastille = 0;
            event.data.forEach(function(rect) {
                //plotRectangle(vid, rect);
                for(var j = 0; j < pointsFixes.length; j++) {
                    if(rect.y >= pointsFixes[j].y - detection && rect.y <= pointsFixes[j].y + detection && rect.width >= pointsFixes[j].w - detection && rect.width <= pointsFixes[j].w + detection && rect.height <= pointsFixes[j].h + detection && rect.height >= pointsFixes[j].h - detection) {
                        if(tabOccu[j] == 0) {
                            tabOccu[j] = 1;
                            nbPastille++;
                        }
                    }
                }
            });
            if(!fin) { //Si nous n'avons pas terminé
                tabOccu = tabOccu.reverse();
                for(var i = 0; i < tabOccu.length; i++) {
                    if(tabOccu[i] == 0) occu = 4-i;
                }

                if(ite != 3) {
                    tabMoyenne[ite++] = occu;
                    occu = 50;
                }
                else {
                    ite = 0;
                    for(var p = 0; p < 3; p++) {
                        if(tabMoyenne[p] != occu) occu = 45;
                    }
                    tabMoyenne = [0,0,10];
                }

                if (nbPastille >= 5) {
                    compteurFin++;
                    if(!initialiser && compteurFin >= 100) {
                        compteurFin = 0;
                        //sonAmbiance.fade(0,5);
                        //sonAmbiance.stop();
                        console.log("Reinstialisation dans 30 SECONDES");
                        setTimeout(function () {
                            window.location.reload();
                        },30000);
                    }

                    else if (compteurFin >= 150) compteurFin = 0;
                }
                else {
                    compteurFin = 0;
                    jouerSons(occu);
                    //suppressionRectangle();
                }
            }
        }
    });
    //tra = tracking.track('#myVideo', colors, { camera: true });
    tra.run();
}

function clearTabPointsFixes() {
    seuil = 1;
    while (pointsFixes.length > nbP) {
        suppresion = 0;
        pointsFixes = pointsFixes.filter(seuilY);
        seuil++;
    }
}

//ATTENTE
function suppressionRectangle() {
    setTimeout(function() {
        $(".rectDraw").remove();
    }, 1000);
}

//ATTENTE
function initialiserPointsFixes() {
    pointsFixes = [];
    setTimeout(function() {
        tra.stop();
        clearTabPointsFixes(pointsFixes);
        pointsFixes.sort(compare);
        console.log("Initialisation terminée ");
        for(var i = 0; i < pointsFixes.length; i++) {
            plotRectangle(vid, pointsFixes[i].re);
        }
    }, 2000);

    colors.on('track', function(event) {
        if (event.data.length === 0) {
            console.log("AUCUNE MARQUE TROUVEES LORS DE LINITILISATION");
        } 
        else {
            event.data.forEach(function(rect) {
                pointsFixes.push({
                    y: rect.y,
                    h: rect.height,
                    w: rect.width,
                    re: rect,
                });
            });
        }
    });
    tra.run();
    //tra = tracking.track('#myVideo', colors, { camera: true });
}


//Initialisation des pastilles
function compare(x, x2) {
    return x2.y - x.y;
}

function seuilY(value) {
  var compteur = 0;
  for (var p = 0; p < pointsFixes.length; p++) {
    if (pointsFixes[p].y >= value.y - seuil && pointsFixes[p].y <= value.y + seuil) {
        compteur++;
    }
  }
  if(compteur > 1 && (pointsFixes.length - suppresion) > nbP) {
    suppresion++; //A laisser surtout
    return false;
  }
  return true;
}