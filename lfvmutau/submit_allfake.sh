mkdir -p `dirname results/Trilepton_D_LFV_reminiaod_feb21_data_MC_LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016E.root`
#using farmout:1
#dry run:1
export megatarget=results/Trilepton_D_LFV_reminiaod_feb21_data_MC_LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016E.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuMuTau.py inputs/Trilepton_D_LFV_reminiaod_feb21_data_MC_LFV_reminiaod_feb21_mc/data_SingleMuon_Run2016E.txt results/Trilepton_D_LFV_reminiaod_feb21_data_MC_LFV_reminiaod_feb21_mc/AnalyzeLFVMuMuTau/data_SingleMuon_Run2016E.root --verbose >& batch_logs/results_Trilepton_D_LFV_reminiaod_feb21_data_MC_LFV_reminiaod_feb21_mc_AnalyzeLFVMuMuTau_data_SingleMuon_Run2016E.log &
sleep 10s