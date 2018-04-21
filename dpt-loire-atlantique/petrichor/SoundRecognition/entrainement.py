# Entrainement du programme de reconnaissance sur une base de sons pre enregistres

# Methode KNN (k plus proches voisins)
at.featureAndTrain(["machineAEcrire/charriot", "machineAEcrire/clavier", "machineAEcrire/clavier_multi", "machineAEcrire/ding", "machineAEcrire/tab", "machineAEcrire/blanc"], 1.0, 1.0, at.shortTermWindow, at.shortTermStep, "knn", "knnTypeWriterSounds", False);

# Methode SVM (machine a vecteurs de support)
at.featureAndTrain(["machineAEcrire/charriot", "machineAEcrire/clavier", "machineAEcrire/clavier_multi", "machineAEcrire/ding", "machineAEcrire/tab", "machineAEcrire/blanc"], 1.0, 1.0, at.shortTermWindow, at.shortTermStep, "svm", "svmTypeWriterSounds", False);

# Methode extra trees
at.featureAndTrain(["machineAEcrire/charriot", "machineAEcrire/clavier", "machineAEcrire/clavier_multi", "machineAEcrire/ding", "machineAEcrire/tab", "machineAEcrire/blanc"], 1.0, 1.0, at.shortTermWindow, at.shortTermStep, "extratrees", "etTypeWriterSounds", False);

# Methode gradient boosting
at.featureAndTrain(["machineAEcrire/charriot", "machineAEcrire/clavier", "machineAEcrire/clavier_multi", "machineAEcrire/ding", "machineAEcrire/tab", "machineAEcrire/blanc"], 1.0, 1.0, at.shortTermWindow, at.shortTermStep, "gradientboosting", "gbTypeWriterSounds", False);

# Methode random forest (foret d'arbres decisionnels)
at.featureAndTrain(["machineAEcrire/charriot", "machineAEcrire/clavier", "machineAEcrire/clavier_multi", "machineAEcrire/ding", "machineAEcrire/tab", "machineAEcrire/blanc"], 1.0, 1.0, at.shortTermWindow, at.shortTermStep, "randomforest", "rfTypeWriterSounds", False);
