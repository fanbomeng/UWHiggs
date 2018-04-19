mkdir -p `dirname results/LFV_reminiaod_feb21_data/AnalyzeLFVEEE/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/LFV_reminiaod_feb21_data/AnalyzeLFVEEE/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVEEE.py inputs/LFV_reminiaod_feb21_data/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.txt results/LFV_reminiaod_feb21_data/AnalyzeLFVEEE/DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root --verbose >& batch_logs/results_LFV_reminiaod_feb21_data_AnalyzeLFVEEE_DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.log &
sleep 10s
