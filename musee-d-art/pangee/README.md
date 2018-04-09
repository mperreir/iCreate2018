# Pangée

- Partenaire: Musée d'Art de Nantes
- Etudiants:
  - Nassim CHIHAOUI
  - Zheng DAI
  - Nathan MOUCHIROUD
- Technologie d'entrée: Gestuel Leap Motion
- Technologie de sortie: Rendu 2D

# Plongeon de saison (Les Nymphéas)

## Description

Le tableau _Les Nymphéas_ de Claude Monet est projeté sur une toile tendue horizontalement au-dessus du sol. Le capteur Leap Motion est placé sur un socle à côté. On déclenche différents effets sur l'image en fonction des gestes captés par le Leap Motion (e.g. une effet de gouttes d'eau en agitant la main verticalement, un effet de vagues pour imiter l'effet du vent à la surface de l'eau en faisant un balaiement vers la droite ou vers la gauche, un effet de givre en fermant le poing...).

## Dépendances logicielles

Projet élaboré avec Unity version 2017.4.0f1 Personal.
Nécessite le [SDK Leap Motion (Orion)](https://developer.leapmotion.com/get-started/) ainsi qu'un capteur Leap Motion pour fonctionner.

Assets Unity utilisés :
- [LeapMotion](https://developer.leapmotion.com/unity/#116) v4.3.4 (gratuit)
- [LeapMotionSimpleControl](https://assetstore.unity.com/packages/tools/leap-motion-simple-control-69361) v2.1 (payant, 5$)
- [RainDropEffect2](https://assetstore.unity.com/packages/vfx/shaders/fullscreen-camera-effects/rain-drop-effect-2-59986) v1.6.1 (gratuit)
- StandardAssets (inclus dans Unity)

L'ensemble de ces assets est inclus (entièrement ou partiellement) dans le code mis à disposition dans ce répertoire et ne nécessite pas d'installation particulière. La liste ci-dessus peut être utile en cas de problème, pour re-télécharger l'un des assets nécessaires à l'application pas exemple.

## Instructions de génération de l'application

Dans Unity : _File > Build & Run_ pour générer le .exe associé au projet.

## Instructions d'exécution

Lancer le fichier .exe créé.
