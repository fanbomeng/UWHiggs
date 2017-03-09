mkdir -p `dirname results/LFV_reminiaod_feb18/AnalyzeLFVMuTau_progresstrail2/TT_TuneCUETP8M2T4_13TeV-powheg-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb18/AnalyzeLFVMuTau_progresstrail2/TT_TuneCUETP8M2T4_13TeV-powheg-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau_progresstrail2.py inputs/LFV_reminiaod_feb18/TT_TuneCUETP8M2T4_13TeV-powheg-pythia8.txt results/LFV_reminiaod_feb18/AnalyzeLFVMuTau_progresstrail2/TT_TuneCUETP8M2T4_13TeV-powheg-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb18_AnalyzeLFVMuTau_progresstrail2_TT_TuneCUETP8M2T4_13TeV-powheg-pythia8.log &
sleep 10s
