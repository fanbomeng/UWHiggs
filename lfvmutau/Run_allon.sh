#!/bin/bash

set -o nounset
set -o errexit

#python MakeSysAnalyzers.py jesup
#python MakeSysAnalyzers.py jesdown
#python MakeSysAnalyzers.py uesup
#python MakeSysAnalyzers.py uesdown
#python MakeSysAnalyzers.py tesdown
#python MakeSysAnalyzers.py tesup
#export RUN_OPTIMIZATION=true
export systematic=none
#export jobid=LFV_8013v1
#export jobid=SMHTT_oct25
#export jobid=SMHTT_jan11_v2
#export jobid=SMHTT_reminiaod_feb14
export jobid=LFV_HighMass
#export jobid=LFV_Mar15_mc
#export jobid=LFVdata_ExtraG_Hnew
#export isRealData=true
export isZTauTau=false
export isInclusive=false   #ZeroJet
#rake analyzeSpring2015Misc
#rake analyzeSpring2015WJets
#rake analyzeSpring2015ZJets
#rake analyzeSpring2015DYAmcJets
#rake analyzeSpring2015TTBar
#rake analyzeSpring2015Higgs
#export isZTauTau=true
#rake analyzeSpring2015ZTauTauJets
#export isIncluse=false
#export fakeset=true   #ZeroJet
export isRealData=true
#rake analyzeSpring2016WjetsandDataprogress
#rake  analyzeSpring2016WjetsandDataprogressVIrake analyzeSpring2016WjetsandDataprogressVIS_TT 
#rake   AnalyzeLFVMuTau_progress_TES3_Fakshape_v3
#rake AnalyzeLFVMuTau_progress_TES3_Fakshape_HighMassEffiSig 
#rake AnalyzeLFVMuTau_progress_TES3_Fakshape_HighMassEffiSig_unicut 
#rake  AnalyzeLFVMuTau_HighMassTriggerEffi_200Tune  #AnalyzeLFVMuTau_progress_TES3_Fakshape_HighMassEffiSig_unicut 
#rake  AnalyzeLFVMuTau_HighMassTriggerEffi_200SigTune 
rake AnalyzeLFVMuTau_HighMassnewsignal 
