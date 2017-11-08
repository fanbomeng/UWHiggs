#!/bin/bash

set -o nounset
set -o errexit

export systematic=none
export jobid=LFV_Mar15_mc
export isZTauTau=false
export isInclusive=false   #ZeroJet
#rake AnalyzeLFVMuTau_progress_TES3_Fakshape_HighMassEffi 
#rake AnalyzeLFVMuTau_progress_TES3_Fakshape_HighMassEffi_unicut
#rake AnalyzeLFVMuTau_HighMassTriggerEffi_200Tune 
rake AnalyzeLFVMuTau_HighMassTriggerEffiPostTune 
