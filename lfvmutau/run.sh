#!/bin/bash

set -o nounset
set -o errexit

#python MakeSysAnalyzers.py jesup
#python MakeSysAnalyzers.py jesdown
#python MakeSysAnalyzers.py uesup
#python MakeSysAnalyzers.py uesdown

export systematic=none
export jobid=LFV_76X_V1
export isRealData=false
export isZTauTau=false
export isInclusive=false
#rake analyzeSpring2015Misc
#rake analyzeSpring2015WJets
#rake analyzeSpring2015ZJets
#rake analyzeSpring2015TTBar
#rake analyzeSpring2015Higgs
export isZTauTau=true
#rake analyzeSpring2015ZTauTauJets
export isInclusive=true
#rake analyzeSpring2015ZTauTauZeroJets
export isZTauTau=false
#rake analyzeSpring2015DYZeroJets
export isInclusive=false
export isRealData=true
rake analyzeLFVMuTauData


export systematic=jesup
export jobid=LFV_76X_V1
export isRealData=false
export isZTauTau=false
#rake analyzeSpring2015MiscJesUp
#rake analyzeSpring2015WJetsJesUp
#rake analyzeSpring2015ZJetsJesUp
#rake analyzeSpring2015TTBarJesUp
#rake analyzeSpring2015HiggsJesUp
export isZTauTau=true
#rake analyzeSpring2015ZTauTauJetsJesUp
export isZTauTau=false
export isRealData=true
#rake analyzeLFVMuTauDataJesUp

export systematic=jesdown
export jobid=LFV_76X_V1
export isRealData=false
export isZTauTau=false
#rake analyzeSpring2015MiscJesDown
#rake analyzeSpring2015WJetsJesDown
#rake analyzeSpring2015ZJetsJesDown
#rake analyzeSpring2015TTBarJesDown
#rake analyzeSpring2015HiggsJesDown
export isZTauTau=true
#rake analyzeSpring2015ZTauTauJetsJesDown
export isZTauTau=false
export isRealData=true
#rake analyzeLFVMuTauDataJesDown

export systematic=uesup
export jobid=LFV_76X_V1
export isRealData=false
export isZTauTau=false
#rake analyzeSpring2015MiscUesUp
#rake analyzeSpring2015WJetsUesUp
#rake analyzeSpring2015ZJetsUesUp
#rake analyzeSpring2015TTBarUesUp
#rake analyzeSpring2015HiggsUesUp
export isZTauTau=true
#rake analyzeSpring2015ZTauTauJetsUesUp
export isZTauTau=false
export isRealData=true
#rake analyzeLFVMuTauDataUesUp

export systematic=uesdown
export jobid=LFV_76X_V1
export isRealData=false
export isZTauTau=false
#rake analyzeSpring2015MiscUesDown
#rake analyzeSpring2015WJetsUesDown
#rake analyzeSpring2015ZJetsUesDown
#rake analyzeSpring2015TTBarUesDown
#rake analyzeSpring2015HiggsUesDown
export isZTauTau=true
#rake analyzeSpring2015ZTauTauJetsUesDown
export isZTauTau=false
export isRealData=true
#rake analyzeLFVMuTauDataUesDown
