# Nom de groupe

- Partenaire: Département de la Loire-Atlantique
- Etudiants: Matthieu Le Flohic, Mathieu Soyer, Mathis Guillet
- Technologie d'entrée: Capteurs mobiles
- Technologie de sortie: Rendu 2D

# Nom de l'installation

El-m

## Description

Application permettant de visualiser sur une carte les naissances et les morts
des personnes enrôlées en Loire-Atlantique durant la première guerre mondiale.

Le spectateur est ici acteur car c'est lui qui possède le contrôle du défilement
du temps en actionnant une manivelle dans laquelle est insérée un téléphone 
mobile possédant un gyroscope. Lorsque la manivelle est mise en mouvement, des villes apparaissent sur la carte qui est projetée face au spectateur.

Dans un premier temps, ces villes sont les lieux de naissance des soldats et sont représentées par un point bleu sur la carte. Ils apparaissent en fonction de la date de naissance du soldat, donc plus le spectateur avance dans le temps avec la manivelle et plus il y a de point sur la carte.

Lorsque l'utilisateur arrive au moment de la guerre, les points qui s'affichent sur la carte sont désormais rouges et correspondent aux villes de décès des soldats (en fonction de leur date de décès).


## Dépendances logicielles

Librairie oscP5 pour processing:
http://www.sojamo.de/libraries/oscp5/

## Instructions de génération de l'application

Compiler directement sous processing les fichiers source.

## Instructions d'exécution

Exécuter le main avec processing sur un ordinateur relié à un rétropojecteur.

Pour transmettre les données du gyroscope vers l'ordinateur:
- Utiliser une application de streaming des données du capteur gyroscope
sur le téléphone mobile (exemple: Sensors2OSC)
- Émettre vers l'adresse IP de l'ordinateur et sur le port 12000
