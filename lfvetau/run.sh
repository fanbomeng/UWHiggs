#!/bin/bash
# Run all of the analysis

set -o nounset
set -o errexit

export MEGAPATH=/hdfs/store/user/taroni/
source jobid.sh
export jobid=$jobid8
#jobid8='newNtuple_10Oct'
#export jobid8='newNtuple_16Oct'
#export jobid='newNtuple_10Oct'
#export jobid='newNtuple_11June'
#export jobid='newNtuple_3JuneOldWXJetsXsec'
#rake genkin
#rake recoplots
rake recoplotsMVA
#rake recoplotsMVAeMtcut
#rake controlplots
#rake controlplotsMVA
#rake fakeeet
#rake fakeeetMVA
#rake fakeeeeMVA
#rake fits
#rake drawTauFakeRate
#export jobid=$jobidmt
#rake recoplotsMuTau
#rake drawplots
#rake genkinEMu
#rake genkinMuTau
