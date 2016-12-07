mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/VBFHToTauTau_M125_13TeV_powheg_pythia8.root`
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/VBFHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/VBFHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/VBFHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_VBFHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/GluGluHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_GluGluHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016E.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016F.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016E.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/data_SingleMuon_Run2016E.txt results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016E.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_data_SingleMuon_Run2016E.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016F.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/data_SingleMuon_Run2016F.txt results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016F.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_data_SingleMuon_Run2016F.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTau/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTau/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016B.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016B.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/data_SingleMuon_Run2016B.txt results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016B.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_data_SingleMuon_Run2016B.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016C.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016D.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016C.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/data_SingleMuon_Run2016C.txt results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016C.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_data_SingleMuon_Run2016C.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016D.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/data_SingleMuon_Run2016D.txt results/SMHTT_oct25/AnalyzeLFVMuTau/data_SingleMuon_Run2016D.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_data_SingleMuon_Run2016D.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/TT_TuneCUETP8M1_13TeV-powheg-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_TT_TuneCUETP8M1_13TeV-powheg-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/WW_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/WZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/WW_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/WW_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/WW_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_WW_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTau/ZZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/WZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/WZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/WZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_WZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTau/ZZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_oct25/ZZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTau/ZZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTau_ZZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016E.root`
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016F.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016E.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016E.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016E.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_data_SingleMuon_Run2016E.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016F.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016F.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016F.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_data_SingleMuon_Run2016F.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016B.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016C.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016B.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016B.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016B.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_data_SingleMuon_Run2016B.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016D.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016C.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016C.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016C.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_data_SingleMuon_Run2016C.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016D.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016D.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/data_SingleMuon_Run2016D.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_data_SingleMuon_Run2016D.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/VBFHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/TT_TuneCUETP8M1_13TeV-powheg-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_TT_TuneCUETP8M1_13TeV-powheg-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/VBFHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/VBFHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/VBFHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_VBFHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/GluGluHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_GluGluHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/WW_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/WZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/WW_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/WW_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/WW_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_WW_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/WZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/WZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/WZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_WZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/ZZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ZZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_ZZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesdown.py inputs/SMHTT_oct25/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesdown/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesdown_ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016E.root`
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016F.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016E.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016E.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016E.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_data_SingleMuon_Run2016E.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016F.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016F.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016F.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_data_SingleMuon_Run2016F.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016B.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016C.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016B.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016B.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016B.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_data_SingleMuon_Run2016B.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016D.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016C.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016C.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016C.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_data_SingleMuon_Run2016C.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016D.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016D.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/data_SingleMuon_Run2016D.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_data_SingleMuon_Run2016D.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/VBFHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/TT_TuneCUETP8M1_13TeV-powheg-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_TT_TuneCUETP8M1_13TeV-powheg-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/VBFHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/VBFHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/VBFHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_VBFHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/GluGluHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_GluGluHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/WW_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/WZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/WW_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/WW_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/WW_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_WW_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/WZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/WZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/WZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_WZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/ZZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ZZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_ZZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTaujesup.py inputs/SMHTT_oct25/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTaujesup/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTaujesup_ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016E.root`
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016F.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016E.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016E.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016E.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_data_SingleMuon_Run2016E.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016F.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016F.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016F.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_data_SingleMuon_Run2016F.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016B.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016C.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016B.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016B.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016B.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_data_SingleMuon_Run2016B.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016D.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016C.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016C.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016C.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_data_SingleMuon_Run2016C.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016D.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016D.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/data_SingleMuon_Run2016D.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_data_SingleMuon_Run2016D.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/VBFHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/TT_TuneCUETP8M1_13TeV-powheg-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_TT_TuneCUETP8M1_13TeV-powheg-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/VBFHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/VBFHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/VBFHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_VBFHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/GluGluHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_GluGluHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/WW_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/WZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/WW_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/WW_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/WW_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_WW_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/WZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/WZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/WZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_WZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/ZZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ZZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_ZZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesdown.py inputs/SMHTT_oct25/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTautesdown/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesdown_ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016E.root`
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016F.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016E.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016E.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016E.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_data_SingleMuon_Run2016E.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016F.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016F.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016F.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_data_SingleMuon_Run2016F.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016B.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016C.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016B.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016B.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016B.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_data_SingleMuon_Run2016B.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016D.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016C.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016C.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016C.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_data_SingleMuon_Run2016C.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016D.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016D.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/data_SingleMuon_Run2016D.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_data_SingleMuon_Run2016D.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/VBFHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/TT_TuneCUETP8M1_13TeV-powheg-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_TT_TuneCUETP8M1_13TeV-powheg-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/VBFHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/VBFHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/VBFHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_VBFHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/GluGluHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_GluGluHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/WW_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/WZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/WW_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/WW_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/WW_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_WW_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/WZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/WZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/WZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_WZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/ZZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/ZZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_ZZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTautesup/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTautesup/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTautesup.py inputs/SMHTT_oct25/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTautesup/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTautesup_ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016E.root`
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016F.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016E.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016E.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016E.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_data_SingleMuon_Run2016E.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016F.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016F.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016F.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_data_SingleMuon_Run2016F.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016B.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016C.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016B.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016B.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016B.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_data_SingleMuon_Run2016B.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016D.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016C.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016C.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016C.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_data_SingleMuon_Run2016C.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016D.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/data_SingleMuon_Run2016D.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/data_SingleMuon_Run2016D.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_data_SingleMuon_Run2016D.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/VBFHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/TT_TuneCUETP8M1_13TeV-powheg-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_TT_TuneCUETP8M1_13TeV-powheg-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/VBFHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/VBFHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/VBFHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_VBFHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/GluGluHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_GluGluHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/WW_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/WZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/WW_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/WW_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/WW_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_WW_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/WZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/WZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/WZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_WZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/ZZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ZZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_ZZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesdown.py inputs/SMHTT_oct25/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesdown/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesdown_ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016E.root`
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016F.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016E.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016E.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016E.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_data_SingleMuon_Run2016E.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016F.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016F.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016F.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_data_SingleMuon_Run2016F.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016B.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016C.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016B.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016B.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016B.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_data_SingleMuon_Run2016B.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016D.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016C.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016C.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016C.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_data_SingleMuon_Run2016C.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016D.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/data_SingleMuon_Run2016D.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/data_SingleMuon_Run2016D.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_data_SingleMuon_Run2016D.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/VBFHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/TT_TuneCUETP8M1_13TeV-powheg-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/TT_TuneCUETP8M1_13TeV-powheg-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_TT_TuneCUETP8M1_13TeV-powheg-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/VBFHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/VBFHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/VBFHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_VBFHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/GluGluHToTauTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_GluGluHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/WW_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/WZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/WW_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/WW_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/WW_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_WW_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/WZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/WZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/WZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_WZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/ZZ_TuneCUETP8M1_13TeV-pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ZZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_ZZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauuesup.py inputs/SMHTT_oct25/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/SMHTT_oct25/AnalyzeLFVMuTauuesup/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauuesup_ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
