mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauPostBDT/data_SingleMuon_Run2016E.root`
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauPostBDT/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauPostBDT/data_SingleMuon_Run2016E.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauPostBDT.py inputs/SMHTT_oct25/data_SingleMuon_Run2016E.txt results/SMHTT_oct25/AnalyzeLFVMuTauPostBDT/data_SingleMuon_Run2016E.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauPostBDT_data_SingleMuon_Run2016E.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauPostBDT/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauPostBDT.py inputs/SMHTT_oct25/TT_TuneCUETP8M1_13TeV-powheg-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauPostBDT/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauPostBDT_TT_TuneCUETP8M1_13TeV-powheg-pythia8.log &
sleep 10s
