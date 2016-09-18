mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/data_SingleMuon_Run2016B_PromptReco-v2_25ns.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/data_SingleMuon_Run2016B_PromptReco-v2_25ns.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/data_SingleMuon_Run2016B_PromptReco-v2_25ns.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/data_SingleMuon_Run2016B_PromptReco-v2_25ns.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_data_SingleMuon_Run2016B_PromptReco-v2_25ns.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/data_SingleMuon_Run2016C_PromptReco-v2_25ns.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/data_SingleMuon_Run2016D_PromptReco-v2_25ns.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/data_SingleMuon_Run2016C_PromptReco-v2_25ns.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/data_SingleMuon_Run2016C_PromptReco-v2_25ns.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/data_SingleMuon_Run2016C_PromptReco-v2_25ns.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_data_SingleMuon_Run2016C_PromptReco-v2_25ns.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/data_SingleMuon_Run2016D_PromptReco-v2_25ns.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/data_SingleMuon_Run2016D_PromptReco-v2_25ns.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/data_SingleMuon_Run2016D_PromptReco-v2_25ns.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_data_SingleMuon_Run2016D_PromptReco-v2_25ns.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/VBFHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/VBFHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/VBFHToTauTau_M125_13TeV_powheg_pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/VBFHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_VBFHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/WW_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/WZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/WW_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/WW_TuneCUETP8M1_13TeV-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/WW_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_WW_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZZ_TuneCUETP8M1_13TeV-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/WZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/WZ_TuneCUETP8M1_13TeV-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/WZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_WZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZZ_TuneCUETP8M1_13TeV-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/ZZ_TuneCUETP8M1_13TeV-pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/ZZ_TuneCUETP8M1_13TeV-pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_ZZ_TuneCUETP8M1_13TeV-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/GluGluHToTauTau_M125_13TeV_powheg_pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/GluGluHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_GluGluHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauwjets_tune.py inputs/LFV_8013v1/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/LFV_8013v1/AnalyzeLFVMuTauwjets_tune/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_8013v1_AnalyzeLFVMuTauwjets_tune_GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
