# autoRequirements

Script bash qui génère le fichier requirements.txt d'un projet en Python.

## Utilisation

    ./autoRequirements.sh [CHEMIN DU PROJET]

Si aucun chemin n'est renseigné, le script utilisera alors `.` par défaut. Le fichier `requirements.txt` sera généré à l'emplacement du chemin renseigné.
Si le fichier existe déjà, le programme demandera alors s'il doit faire un backup du fichier, le supprimer ou annuler l'opération. Le fichier de backup se nomme `requirements.txt.backup`. **Attention, s'il existe déjà un fichier backup du même nom, il sera supprimé.**

Le processus peut prendre plus ou moins de temps selon le nombre de packets pip installés et la taille du projet.
