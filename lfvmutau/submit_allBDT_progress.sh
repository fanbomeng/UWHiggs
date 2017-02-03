mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauPostBDT_progressN/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
(in /afs/hep.wisc.edu/cms/fmeng/Fanbo/CMSSW_8_0_24/src/UWHiggs/lfvmutau)
warning: Insecure world writable dir /afs/hep.wisc.edu/cms/fmeng in PATH, mode 040777
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauPostBDT_progressN/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauPostBDT_progressN.py inputs/SMHTT_oct25/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauPostBDT_progressN/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauPostBDT_progressN_DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
