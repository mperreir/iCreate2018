# Nom de groupe

- Partenaire: Département de la Loire-Atlantique
- Etudiants: Matthieu Le Flohic, Mathieu Soyer, Mathis Guillet
- Technologie d'entrée: Capteurs mobiles
- Technologie de sortie: Rendu 2D

# Nom de l'installation

El-m

## Description

Application permettant de visualiser sur une carte les naissances et les morts
des personnes enrôlées en Loire-Atlantique durant de la première guerre mondiale.

Le spectateur est ici acteur car c'est lui qui possède le contrôle du défilement
du temps en actionnant une manivelle dans laquelle est insérée un téléphone 
mobile possédant un gyroscope.

## Dépendances logicielles

Librairie oscP5 pour processing:
http://www.sojamo.de/libraries/oscp5/

## Instructions de génération d' l'application

Compiler directement sous processing les fichiers source.

## Instructions d'exécution

Exécuter le main avec processing sur un ordinateur relié à un rétropojecteur.

Pour transmettre les données du gyroscope vers l'ordinateur:
- Utiliser une application de streaming des données du capteur gyroscope
sur le téléphone mobile (exemple: Sensors2OSC)
- Émettre vers l'adresse IP de l'ordinateur et sur le port 12000
