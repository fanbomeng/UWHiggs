mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WGToLNuG_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8.root`
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WGstarToLNuEE_13TeV-madgraph.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WGToLNuG_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/WGToLNuG_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WGToLNuG_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_WGToLNuG_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WGstarToLNuMuMu_13TeV-madgraph.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WGstarToLNuEE_13TeV-madgraph.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/WGstarToLNuEE_13TeV-madgraph.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WGstarToLNuEE_13TeV-madgraph.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_WGstarToLNuEE_13TeV-madgraph.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/VBFHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WGstarToLNuMuMu_13TeV-madgraph.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/WGstarToLNuMuMu_13TeV-madgraph.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WGstarToLNuMuMu_13TeV-madgraph.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_WGstarToLNuMuMu_13TeV-madgraph.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/VBFHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/VBFHToTauTau_M125_13TeV_powheg_pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/VBFHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_VBFHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016H.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WminusHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016H.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/data_SingleMuon_Run2016H.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016H.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_data_SingleMuon_Run2016H.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WplusHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WminusHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/WminusHToTauTau_M125_13TeV_powheg_pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WminusHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_WminusHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ZHToTauTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WplusHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/WplusHToTauTau_M125_13TeV_powheg_pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WplusHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_WplusHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ZHToTauTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/ZHToTauTau_M125_13TeV_powheg_pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ZHToTauTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_ZHToTauTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016G.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016F.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016G.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/data_SingleMuon_Run2016G.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016G.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_data_SingleMuon_Run2016G.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016F.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/data_SingleMuon_Run2016F.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016F.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_data_SingleMuon_Run2016F.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/TT_TuneCUETP8M2T4_13TeV-powheg-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016E.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/TT_TuneCUETP8M2T4_13TeV-powheg-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/TT_TuneCUETP8M2T4_13TeV-powheg-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/TT_TuneCUETP8M2T4_13TeV-powheg-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_TT_TuneCUETP8M2T4_13TeV-powheg-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016E.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/data_SingleMuon_Run2016E.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016E.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_data_SingleMuon_Run2016E.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016B.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016C.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016B.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/data_SingleMuon_Run2016B.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016B.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_data_SingleMuon_Run2016B.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016D.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016C.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/data_SingleMuon_Run2016C.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016C.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_data_SingleMuon_Run2016C.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016D.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/data_SingleMuon_Run2016D.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016D.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_data_SingleMuon_Run2016D.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8.log &
sleep 10s
mkdir -p `dirname results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ZZTo4L_13TeV-amcatnloFXFX-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ZZTo4L_13TeV-amcatnloFXFX-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/LFV_reminiaod_feb21_mc/ZZTo4L_13TeV-amcatnloFXFX-pythia8.txt results/LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/ZZTo4L_13TeV-amcatnloFXFX-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_ZZTo4L_13TeV-amcatnloFXFX-pythia8.log &
sleep 10s
