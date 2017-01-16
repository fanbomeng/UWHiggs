mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauBDTnew_fake.py inputs/SMHTT_oct25/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauBDTnew_fake_ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauBDTnew_fake.py inputs/SMHTT_oct25/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauBDTnew_fake_ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauBDTnew_fake.py inputs/SMHTT_oct25/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauBDTnew_fake_ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauBDTnew_fake.py inputs/SMHTT_oct25/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauBDTnew_fake_ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauBDTnew_fake.py inputs/SMHTT_oct25/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauBDTnew_fake/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauBDTnew_fake_ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
