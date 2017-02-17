#!/bin/bash

# Get the data
#export datasrc=/hdfs/store/user/fmeng/
#export hdfs=/hdfs/store/user/caillol/
#export datasrc=/hdfs/store/user/ndev/
#export datasrc=/hdfs/store/user/cepeda/
#export datasrc=/hdfs/store/user/taroni/
#export jobid=MiniAODSIM-Spring15-25ns_LFV_V1_October10
#export jobid=MiniAODSIM-Spring15-25ns_LFV_MiniAODV2_Nov3
#export jobid=MiniAODSIMv2-Spring15-25ns_LFV_October13
#export jobid=MiniAODv2_2fb_v3
#export jobid=MiniAODSIM-Spring15-25ns_LFV_MiniAODV2_Dec2_LFV_NoHF_JetEta25
#export jobid=MiniAODSIM-Spring15-25ns_LFV_MiniAODV2_Dec2_Data_NoHF_JetEta
#export jobid=MiniAODSIM-Spring15-25ns_LFV_MiniAODV2_Dec2_LFV_NoHF_JetEta25_MissingHiggs
#export jobid=MiniAodV2For25ns_ExtraJets_LFV_Data
#export jobid=MiniAodV2For25ns_ExtraJets_JesUes_JetEtaFix_LFV
export datasrc=/hdfs/store/user/caillol/
#export datasrc=/hdfs/store/user/truggles/
#export datasrc=/hdfs/store/user/taroni/
#export datasrc=/hdfs/store/user/taroni/
#export datasrc=/hdfs/store/user/truggles/
#export jobid=LFVdata_oct28/
#export jobid=SMHTT_oct25/
#export jobid=LFVtrileptons_Dec7/
#export jobid=LFVH_Dec21/
#export jobid=SMHTT_data_jan17
export jobid=SMHTT_reminiaod_feb14/
#export jobid=SMHTT_mc_jan17/
#export jobid=LFVtrilepton_oct31/
#export jobid=LFVZTauTauEm/
#export jobid=LFVdata_ExtraG_Hnew/
#export jobid=LFVdata_ExtraG_HTrilep/
#export jobid=SMH_sep16_newTriggers
#export jobid=MiniAodV2For25ns_ExtraJets_JesUes_JetFix_LFVData
#export jobid=MiniAODv2_2fb_v2
#export jobid=MiniAODSIM-Spring15-25ns_LFV_MiniAODV2_Data
#export jobid=MiniAODSIM-Spring15-25ns_LFV_Nov9_ZTTFakeStudy
#export jobid=MiniAODSIM-Spring15-25ns_LFV_Oct27
export afile=`find $datasrc/$jobid | grep root | head -n 1`
echo "come here 1111111111111111"
echo $afile
## Build the cython wrappers
#rake "make_wrapper[$afile, mmm/final/Ntuple, MuMuMuTree]"
#rake "make_wrapper[$afile, mmt/final/Ntuple, MuMuTauTree]"
#rake "make_wrapper[$afile, mt/final/Ntuple, MuTauTree]"
#rake "make_wrapper[$afile, em/final/Ntuple, MuMuTauTree]"
echo "come here 1111111111111111"
ls *pyx | sed "s|pyx|so|" | xargs rake 
#echo "finishing compilation" 
#bash compileTree.txt

#rake "meta:getinputs[$jobid, $datasrc,mt/metaInfo]"
#rake "meta:getinputs[$jobid, $datasrc,mmm/metaInfo, mmm/summedWeights]"
rake "meta:getinputs[$jobid, $datasrc,mt/metaInfo, mt/summedWeights]"
#rake "meta:getinputs[$jobid, $datasrc,et/metaInfo, et/summedWeights]"
#rake "meta:getinputs[$jobid, $datasrc,em/metaInfo, em/summedWeights]"
########rake "meta:getinputs[$jobid, $datasrc,mmt/metaInfo, mmt/summedWeights]"
echo "come here 22222222222222"
#rake "meta:getmeta[inputs/$jobid, mmm/metaInfo, 13,mmm/summedWeights]"
#rake "meta:getmeta[inputs/$jobid, mt/metaInfo, 13,mt/summedWeights]"
#########rake "meta:getmeta[inputs/$jobid, mmt/metaInfo, 13,mmt/summedWeights]"
#rake "meta:getmeta[inputs/$jobid, mt/metaInfo, 13,mt/summedWeights]"echo "come here 33333333333333"
