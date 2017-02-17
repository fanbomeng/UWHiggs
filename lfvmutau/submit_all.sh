mkdir -p `dirname results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016G.root`
mkdir -p `dirname results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016H.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016G.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_jan31/data_SingleMuon_Run2016G.txt results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016G.root --verbose >& batch_logs/results_SMHTT_jan31_AnalyzeLFVMuTau_data_SingleMuon_Run2016G.log &
sleep 10s
mkdir -p `dirname results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016E.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016H.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_jan31/data_SingleMuon_Run2016H.txt results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016H.root --verbose >& batch_logs/results_SMHTT_jan31_AnalyzeLFVMuTau_data_SingleMuon_Run2016H.log &
sleep 10s
mkdir -p `dirname results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016F.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016E.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_jan31/data_SingleMuon_Run2016E.txt results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016E.root --verbose >& batch_logs/results_SMHTT_jan31_AnalyzeLFVMuTau_data_SingleMuon_Run2016E.log &
sleep 10s
mkdir -p `dirname results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016B.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016F.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_jan31/data_SingleMuon_Run2016F.txt results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016F.root --verbose >& batch_logs/results_SMHTT_jan31_AnalyzeLFVMuTau_data_SingleMuon_Run2016F.log &
sleep 10s
mkdir -p `dirname results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016C.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016B.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_jan31/data_SingleMuon_Run2016B.txt results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016B.root --verbose >& batch_logs/results_SMHTT_jan31_AnalyzeLFVMuTau_data_SingleMuon_Run2016B.log &
sleep 10s
mkdir -p `dirname results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016D.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016C.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_jan31/data_SingleMuon_Run2016C.txt results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016C.root --verbose >& batch_logs/results_SMHTT_jan31_AnalyzeLFVMuTau_data_SingleMuon_Run2016C.log &
sleep 10s
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016D.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTau.py inputs/SMHTT_jan31/data_SingleMuon_Run2016D.txt results/SMHTT_jan31/AnalyzeLFVMuTau/data_SingleMuon_Run2016D.root --verbose >& batch_logs/results_SMHTT_jan31_AnalyzeLFVMuTau_data_SingleMuon_Run2016D.log &
sleep 10s
