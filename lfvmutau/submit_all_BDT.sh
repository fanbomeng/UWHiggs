mkdir -p `dirname results/SMHTT_oct25/AnalyzeLFVMuTauPostBDTjesup/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root`
#using farmout:1
#dry run:1
export megatarget=results/SMHTT_oct25/AnalyzeLFVMuTauPostBDTjesup/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root
mkdir -p batch_logs
mega-farmout AnalyzeLFVMuTauPostBDTjesup.py inputs/SMHTT_oct25/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.txt results/SMHTT_oct25/AnalyzeLFVMuTauPostBDTjesup/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.root --verbose >& batch_logs/results_SMHTT_oct25_AnalyzeLFVMuTauPostBDTjesup_GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8.log &
sleep 10s
(in /afs/hep.wisc.edu/cms/fmeng/Fanbo/CMSSW_8_0_24/src/UWHiggs/lfvmutau)
(in /afs/hep.wisc.edu/cms/fmeng/Fanbo/CMSSW_8_0_24/src/UWHiggs/lfvmutau)
(in /afs/hep.wisc.edu/cms/fmeng/Fanbo/CMSSW_8_0_24/src/UWHiggs/lfvmutau)
