#!/bin/bash

#**********************************#
#        autoRequirements.sh       #
#                                  #
#       author: rick@gnous.eu      #     
#           licence: MIT           #
#**********************************#

path=${1:-.}

INDEX=0
echo 'Récupération des packets installés sur la machine...'
installedPackage=($(pip3 freeze))
echo 'Fait.'
packagePutInReq=()

# ========================================================================= # 
# contains()                                                                #
# Vérifie si le packet est dans la liste des packets installés              #
#                                                                           #
# Utilise la variable globale installedPackage.                             #
#                                                                           #
# Paramètres : $1 le packet à vérifier                                      #
#                                                                           #
# Retourne : - 0 si le packet est dans la liste des packets installés       #
#              Mets à jour la variable globale INDEX avec l'index du packet #
#              dans la tableau installedPackagei                            #
#            - 1 sinon                                                      #
# ========================================================================= # 
contains() {
    value=$1
    i=0
    for element in "${installedPackage[@]}"; do
        element=$(cut -d= -f1 <<< $element)
        if [[ "$element" == "$value" ]]; then
            INDEX=$i
            return 0
            break
        fi
        i=$((i+1))
    done
    return 1
}

# ====================================================================== # 
# checkContains()                                                        #
# Vérifie si le packet n'est pas déjà présent dans la liste des packets  #
# qui seront dans le requirements.txt                                    #
#                                                                        #
# Utilise la variable globale packagePutInReq.                           #
#                                                                        #
# Paramètres : $1 le packet à vérifier                                   #
#                                                                        #
# Retourne : - 0 si le packet est déjà présent dans la liste des packets #
#            - 1 sinon                                                   #
# ====================================================================== # 
checkContains() {
    value=$1
    for element in "${packagePutInReq[@]}"; do
        if [[ "$value" == "$element" ]]; then
            return 0
        fi
    done
    return 1
}

echo 'Récupération des packets à installer...'
for file in $(find $path -iname "*.py"); do
    # boucle sur les lines qui commencent par import ou from. Vous pouvez voir la commande utilisée
    # à la fin de la boucle
    while read -r line; do
        package=$(cut -d' ' -f2 <<< $line)
        contains $package 
        if [ $? -eq 0 ]; then
            newPackage=${installedPackage[$INDEX]}
            checkContains $newPackage
            if [ $? -eq 1 ]; then
                packagePutInReq+=($newPackage)
            fi
        fi
    done < <(grep '\(^[[:blank:]]*import\)\|\(^[[:blank:]]*from\)' $file)
done
echo 'Fait.'

echo 'Création et insertion des packets dans requirements.txt...'
pathRequirement=$path'/requirements.txt'
touch pathRequirement
for package in "${packagePutInReq[@]}"; do
    echo $package >> $pathRequirement
done
echo 'Fait.'
