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
#export jobid=LFVZTauTauEm
export jobid=SMHTT_oct25
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
#rake AnalyzeLFVMuTau_progressbeforMtcorrection
rake  analyzeSpring2016WjetsandDataprogress 
#export fakeset=false   #ZeroJet
#rake analyzeSpring2016Wjetfake  
#rake analyzeSpring2016WjetsandDatafakesup  
#rake analyzeSpring2016WjetsandDatajesdown  
#rake analyzeSpring2016WjetsandDatajesup  
#rake analyzeSpring2016WjetsandDatatesdown 
#rake analyzeSpring2016WjetsandDatatesup 
#rake analyzeSpring2016WjetsandDatauesdown 
#rake analyzeSpring2016WjetsandDatauesup
#rake analyzeSpring2016WjetsandDatatrial
#rake analyzeSpring2016WjetsandData
#rake analyzeSpring2016WjetsandDataBDT
export isRealData=false
export isZTauTau=true
#rake analyzeSpring2016MC
export isZTauTau=false
#rake analyzeSpring2016MC_2
###rake analyzeSpring2015DYZeroJets
##export isInclusive=false
##export isRealData=true
###rake analyzeLFVMuTauData
##
##export systematic=jesup
##export jobid=LFV_76X_V2
##export isRealData=false
##export isZTauTau=false
##export isInclusive=false
###rake analyzeSpring2015MiscJesUp
###rake analyzeSpring2015WJetsJesUp
###rake analyzeSpring2015ZJetsJesUp
###rake analyzeSpring2015DYAmcJetsJesUp
###rake analyzeSpring2015TTBarJesUp
###rake analyzeSpring2015HiggsJesUp
##export isZTauTau=true
###rake analyzeSpring2015ZTauTauJetsJesUp
##export isIncluse=false
##rake analyzeSpring2015ZTauTauAmcJetsJesUp
##export isZTauTau=false
###rake analyzeSpring2015DYZeroJetsJesUp
##export isInclusive=false
##export isRealData=true
###rake analyzeLFVMuTauData
##
##export systematic=jesdown
##export jobid=LFV_76X_V2
##export isRealData=false
##export isZTauTau=false
##export isInclusive=false
###rake analyzeSpring2015MiscJesDown
###rake analyzeSpring2015WJetsJesDown
###rake analyzeSpring2015ZJetsJesDown
###rake analyzeSpring2015DYAmcJetsJesDown
###rake analyzeSpring2015TTBarJesDown
###rake analyzeSpring2015HiggsJesDown
##export isZTauTau=true
###rake analyzeSpring2015ZTauTauJetsJesDown
##export isIncluse=false
##rake analyzeSpring2015ZTauTauAmcJetsJesDown
##export isZTauTau=false
###rake analyzeSpring2015DYZeroJetsJesDown
##export isInclusive=false
##export isRealData=true
###rake analyzeLFVMuTauData
##
##export systematic=uesup
##export jobid=LFV_76X_V2
##export isRealData=false
##export isZTauTau=false
##export isInclusive=false
###rake analyzeSpring2015MiscUesUp
###rake analyzeSpring2015WJetsUesUp
###rake analyzeSpring2015ZJetsUesUp
###rake analyzeSpring2015DYAmcJetsUesUp
###rake analyzeSpring2015TTBarUesUp
###rake analyzeSpring2015HiggsUesUp
##export isZTauTau=true
###rake analyzeSpring2015ZTauTauJetsUesUp
##export isIncluse=false
##rake analyzeSpring2015ZTauTauAmcJetsUesUp
##export isZTauTau=false
###rake analyzeSpring2015DYZeroJetsUesUp
##export isInclusive=false
##export isRealData=true
###rake analyzeLFVMuTauData
##
##export systematic=uesdown
##export jobid=LFV_76X_V2
##export isRealData=false
##export isZTauTau=false
##export isInclusive=false
###rake analyzeSpring2015MiscUesDown
###rake analyzeSpring2015WJetsUesDown
###rake analyzeSpring2015ZJetsUesDown
###rake analyzeSpring2015DYAmcJetsUesDown
###rake analyzeSpring2015TTBarUesDown
###rake analyzeSpring2015HiggsUesDown
##export isZTauTau=true
###rake analyzeSpring2015ZTauTauJetsUesDown
##export isIncluse=false
##rake analyzeSpring2015ZTauTauAmcJetsUesDown
##export isZTauTau=false
###rake analyzeSpring2015DYZeroJetsUesDown
##export isInclusive=false
##export isRealData=true
###rake analyzeLFVMuTauData
##
##export systematic=tesup
##export jobid=LFV_76X_V2
##export isRealData=false
##export isZTauTau=false
##export isInclusive=false
###rake analyzeSpring2015MiscTesUp
###rake analyzeSpring2015WJetsTesUp
###rake analyzeSpring2015ZJetsTesUp
###rake analyzeSpring2015DYAmcJetsTesUp
###rake analyzeSpring2015TTBarTesUp
###rake analyzeSpring2015HiggsTesUp
##export isZTauTau=true
###rake analyzeSpring2015ZTauTauJetsTesUp
##export isIncluse=false
##rake analyzeSpring2015ZTauTauAmcJetsTesUp
##export isZTauTau=false
###rake analyzeSpring2015DYZeroJetsTesUp
##export isInclusive=false
##export isRealData=true
###rake analyzeLFVMuTauData
##
##export systematic=tesdown
##export jobid=LFV_76X_V2
##export isRealData=false
##export isZTauTau=false
##export isInclusive=false
###rake analyzeSpring2015MiscTesDown
###rake analyzeSpring2015WJetsTesDown
###rake analyzeSpring2015ZJetsTesDown
###rake analyzeSpring2015DYAmcJetsTesDown
###rake analyzeSpring2015TTBarTesDown
###rake analyzeSpring2015HiggsTesDown
##export isZTauTau=true
###rake analyzeSpring2015ZTauTauJetsTesDown
##export isIncluse=false
##rake analyzeSpring2015ZTauTauAmcJetsTesDown
##export isZTauTau=false
###rake analyzeSpring2015DYZeroJetsTesDown
##export isInclusive=false
##export isRealData=true
###rake analyzeLFVMuTauData
##
##export systematic=none
##export jobid=LFV_76X_V2
##export isRealData=false
##export isZTauTau=false
##export isInclusive=false
###rake analyzeSpring2015MiscFakesUp
###rake analyzeSpring2015WJetsFakesUp
###rake analyzeSpring2015ZJetsFakesUp
###rake analyzeSpring2015DYAmcJetsFakesUp
###rake analyzeSpring2015TTBarFakesUp
###rake analyzeSpring2015HiggsFakesUp
##export isZTauTau=true
###rake analyzeSpring2015ZTauTauJetsFakesUp
##export isIncluse=false
##rake analyzeSpring2015ZTauTauAmcJetsFakesUp
##export isZTauTau=false
###rake analyzeSpring2015DYZeroJetsFakesUp
##export isInclusive=false
##export isRealData=true
###rake analyzeLFVMuTauDataFakesUp
##
##export systematic=none
##export jobid=LFV_76X_V2
##export isRealData=false
##export isZTauTau=false
##export isInclusive=false
###rake analyzeSpring2015MiscFakesDown
###rake analyzeSpring2015WJetsFakesDown
###rake analyzeSpring2015ZJetsFakesDown
###rake analyzeSpring2015DYAmcJetsFakesDown
###rake analyzeSpring2015TTBarFakesDown
###rake analyzeSpring2015HiggsFakesDown
##export isZTauTau=true
###rake analyzeSpring2015ZTauTauJetsFakesDown
##export isIncluse=false
##rake analyzeSpring2015ZTauTauAmcJetsFakesDown
##export isZTauTau=false
###rake analyzeSpring2015DYZeroJetsFakesDown
##export isInclusive=false
##export isRealData=true
###rake analyzeLFVMuTauDataFakesDown
##
