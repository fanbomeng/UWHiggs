#!/bin/bash

$DIR="MyDir/"
$CARD="mycard.txt"

combineCards.py -S $DIR$CARD > card.txt

text2workspace.py  card.txt -m 125

combineTool.py -M Impacts -d card.root -m 125 --doInitialFit --robustFit 1 --rMax 5 --rMin -5 -t -1
combineTool.py -M Impacts -d card.root -m 125 --robustFit 1 --doFits   --rMax 5 --rMin -5  -t -1 --parallel 30

combineTool.py -M Impacts -d card.root -m 125 -o "myimpacts.json"
plotImpacts.py -i "myimpacts.json" -o myimpacts

