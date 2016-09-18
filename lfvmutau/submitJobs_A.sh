mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/LFV_8013v1/AnalyzeLFVMuTau/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/LFV_8013v1/AnalyzeLFVMuTau/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/data_SingleMuon_Run2016B_PromptReco-v2_25ns.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/data_SingleMuon_Run2016B_PromptReco-v2_25ns.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/data_SingleMuon_Run2016B_PromptReco-v2_25ns.txt results/LFV_8013v1/AnalyzeLFVMuTau/data_SingleMuon_Run2016B_PromptReco-v2_25ns.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_data_SingleMuon_Run2016B_PromptReco-v2_25ns.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/data_SingleMuon_Run2016C_PromptReco-v2_25ns.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/data_SingleMuon_Run2016D_PromptReco-v2_25ns.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/data_SingleMuon_Run2016C_PromptReco-v2_25ns.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/data_SingleMuon_Run2016C_PromptReco-v2_25ns.txt results/LFV_8013v1/AnalyzeLFVMuTau/data_SingleMuon_Run2016C_PromptReco-v2_25ns.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_data_SingleMuon_Run2016C_PromptReco-v2_25ns.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/data_SingleMuon_Run2016D_PromptReco-v2_25ns.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/data_SingleMuon_Run2016D_PromptReco-v2_25ns.txt results/LFV_8013v1/AnalyzeLFVMuTau/data_SingleMuon_Run2016D_PromptReco-v2_25ns.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_data_SingleMuon_Run2016D_PromptReco-v2_25ns.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/VBFHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen.txt results/LFV_8013v1/AnalyzeLFVMuTau/TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/VBFHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/VBFHToTauTau_M125_13TeV_powheg_pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/VBFHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_VBFHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/WW_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/WZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/WW_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/WW_TuneCUETP8M1_13TeV-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/WW_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_WW_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/ZZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/WZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/WZ_TuneCUETP8M1_13TeV-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/WZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_WZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/ZZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/ZZ_TuneCUETP8M1_13TeV-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/ZZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_ZZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTau/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/GluGluHToTauTau_M125_13TeV_powheg_pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_GluGluHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTau/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/LFV_8013v1/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTau/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTau_GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s