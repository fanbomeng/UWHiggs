mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
