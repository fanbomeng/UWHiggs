#!/bin/bash

set -o nounset
set -o errexit

python MakeSysAnalyzers.py jesup
python MakeSysAnalyzers.py jesdown
python MakeSysAnalyzers.py uesup
python MakeSysAnalyzers.py uesdown
python MakeSysAnalyzers.py tesdown
python MakeSysAnalyzers.py tesup

export systematic=none
export jobid=LFV_76X_V2
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
#rake analyzeLFVMuTauData

export systematic=jesup
export jobid=LFV_76X_V2
export isRealData=false
export isZTauTau=false
export isInclusive=false
#rake analyzeSpring2015MiscJesUp
#rake analyzeSpring2015WJetsJesUp
#rake analyzeSpring2015ZJetsJesUp
#rake analyzeSpring2015TTBarJesUp
#rake analyzeSpring2015HiggsJesUp
export isZTauTau=true
#rake analyzeSpring2015ZTauTauJetsJesUp
export isInclusive=true
rake analyzeSpring2015ZTauTauZeroJetsJesUp
export isZTauTau=false
rake analyzeSpring2015DYZeroJetsJesUp
export isInclusive=false
export isRealData=true
#rake analyzeLFVMuTauData

export systematic=jesdown
export jobid=LFV_76X_V2
export isRealData=false
export isZTauTau=false
export isInclusive=false
#rake analyzeSpring2015MiscJesDown
#rake analyzeSpring2015WJetsJesDown
#rake analyzeSpring2015ZJetsJesDown
#rake analyzeSpring2015TTBarJesDown
#rake analyzeSpring2015HiggsJesDown
export isZTauTau=true
#rake analyzeSpring2015ZTauTauJetsJesDown
export isInclusive=true
rake analyzeSpring2015ZTauTauZeroJetsJesDown
export isZTauTau=false
rake analyzeSpring2015DYZeroJetsJesDown
export isInclusive=false
export isRealData=true
#rake analyzeLFVMuTauData

export systematic=uesup
export jobid=LFV_76X_V2
export isRealData=false
export isZTauTau=false
export isInclusive=false
#rake analyzeSpring2015MiscUesUp
#rake analyzeSpring2015WJetsUesUp
#rake analyzeSpring2015ZJetsUesUp
#rake analyzeSpring2015TTBarUesUp
#rake analyzeSpring2015HiggsUesUp
export isZTauTau=true
#rake analyzeSpring2015ZTauTauJetsUesUp
export isInclusive=true
rake analyzeSpring2015ZTauTauZeroJetsUesUp
export isZTauTau=false
rake analyzeSpring2015DYZeroJetsUesUp
export isInclusive=false
export isRealData=true
#rake analyzeLFVMuTauData

export systematic=uesdown
export jobid=LFV_76X_V2
export isRealData=false
export isZTauTau=false
export isInclusive=false
#rake analyzeSpring2015MiscUesDown
#rake analyzeSpring2015WJetsUesDown
#rake analyzeSpring2015ZJetsUesDown
#rake analyzeSpring2015TTBarUesDown
#rake analyzeSpring2015HiggsUesDown
export isZTauTau=true
#rake analyzeSpring2015ZTauTauJetsUesDown
export isInclusive=true
rake analyzeSpring2015ZTauTauZeroJetsUesDown
export isZTauTau=false
rake analyzeSpring2015DYZeroJetsUesDown
export isInclusive=false
export isRealData=true
#rake analyzeLFVMuTauData

export systematic=tesup
export jobid=LFV_76X_V2
export isRealData=false
export isZTauTau=false
export isInclusive=false
#rake analyzeSpring2015MiscTesUp
#rake analyzeSpring2015WJetsTesUp
#rake analyzeSpring2015ZJetsTesUp
#rake analyzeSpring2015TTBarTesUp
#rake analyzeSpring2015HiggsTesUp
export isZTauTau=true
#rake analyzeSpring2015ZTauTauJetsTesUp
export isInclusive=true
rake analyzeSpring2015ZTauTauZeroJetsTesUp
export isZTauTau=false
rake analyzeSpring2015DYZeroJetsTesUp
export isInclusive=false
export isRealData=true
#rake analyzeLFVMuTauData

export systematic=tesdown
export jobid=LFV_76X_V2
export isRealData=false
export isZTauTau=false
export isInclusive=false
#rake analyzeSpring2015MiscTesDown
#rake analyzeSpring2015WJetsTesDown
#rake analyzeSpring2015ZJetsTesDown
#rake analyzeSpring2015TTBarTesDown
#rake analyzeSpring2015HiggsTesDown
export isZTauTau=true
#rake analyzeSpring2015ZTauTauJetsTesDown
export isInclusive=true
rake analyzeSpring2015ZTauTauZeroJetsTesDown
export isZTauTau=false
rake analyzeSpring2015DYZeroJetsTesDown
export isInclusive=false
export isRealData=true
#rake analyzeLFVMuTauData
