# Nom de groupe : 生(Sheng)

- Partenaire: Justori
- Etudiants: Hugo Michel, Thomas Creissel, Yao Zhou, Sloane Petit, Julien Abt
- Technologie d'entrée: Traitement d'image
- Technologie de sortie: Son spatialisé


# Nom de l'installation : De Bouches à Oreilles

## Description

Travaille sur l'attention. 
L'utilisateur est invité à entrer seul et s'assoir au centre d'une espèce de yourte. Provenant de tout autour de lui des histoires mélées et trop basses pour être distinguées provoquent une brouhaha constant. Une lumière projetée tourne autour de lui contre les murs circulaires, créant un jeu d'ombres, sensation augmentée par la diffusion de bruit de feu de camp autour de lui. Cependant l'utilisateur, à l'aide de sa chaine capable de pivoter, peut se consentrer sur l'un des quatres points d'intérêts représentés par les quatres caméras encastrées dans le mur. Dès que son attention est captée par celle-ci, une histoire (différente pour chaque point d'intérêt) va se dégager du fond sonore et lui être racontée, de plus, la lumière va se fixer sur ce point d'intérêt pour faire comprendre que c'est bien de cette zone qu'il faut se préoccuper. 
Cependant, nous travaillons sur l'attention. Aisni si l'attention de l'utilisateur est perdue (il tourne la tête ou regarde ailleurs et n'est donc plus reconnu par la caméra), il sera sanctionné par l'arrêt brutal de son histoire et donc n'aura pas eu son attention récompensée par la fin de l'histoire. Pour augemnter la difficulté à rester attentif et montrer ainsi la frustration de ne pouvoir entendre toutes les hisoire du fond sonore, quelqu'un crie 'Hé, tu m'écoutes ??' à un intervalle de temps aléatoire et depuis une position aléatoire autour de l'utilisateur.
Dès que plus aucun point d'intérêt n'est sollicité, la lumière recommence à tourner.


## Dépendances logicielles

Processing
+ openCV for Processing
+ Java awt
+ oscP5

PureData - Extended

Arduino
+ Adafruit Motor Shield


## Instructions de génération de l'application

De part un travail avec beaucoup de périphériques usb, nous avons des soucis pour choisir quel port doit être sélectionné parmis les nombreux accessibles, et nous avons été obligé de tricher. Ainsi, la première chose que fait notre code Processing BaO.pde, c'est de générer la liste des ports disponibles pour l'arduino ainsi que la liste des caméras accessibles. Ainsi les valeurs des ports sélectionnés sont à modifier directement dans le code, et ce à chaque fois que l'on va débrancher/brancher un périphérique USB ou que l'on a éteint l'ordinateur. Ainsi il nous est impossible d'utiliser de version compilée et nous utilisons donc directement l'application Processing pour lancer notre application, en modifiant ces valeurs au besoin. Ainsi il n'y a rien à générer depuis le code.


## Instructions d'exécution

- Téléverser le code MobileLamp.ino dans un arduino UNO équipé d'un Motor Shield Adafruit ainsi que d'un stepper de 400 pas/tour sur lequel est monté la lampe, orienté vers le bas. (Penser avant à placer la lampe face au point d'origine, la porte, car toutes les positions sont relatives à ce point)
- Ouvrir Bao.pd dans l'application PureData - Extended. Régler au besoin la sortie sonore de l'application sur un canal à 6 sorties, et activer la sortie sonore. Le fond sonore devrai se lancer à ce moment.
- Ouvrir Bao.pde dans l'application processing et lancer le code. En testant la reconnaissance de cahque caméra et en se fiant à la position que prend la lampe, si elle ne se pose pas devant les bonnes caméras, il faut changer les ports d'entrée des caméras (cf. commentaires du code). Si des changements ont du être faits, penser à reset l'arduino (bouton directement sur le Shield) en plaçcant la lampe face à l'origine. Tout devrait à présent marcher.

