#!/bin/bash
export OVERRIDE_META_TREE_data_ET='et/metaInfo'

export IGNORE_LUMI_ERRORS=1

source jobid.sh
export jobid=$jobid13

echo $jobid
#export datasrc=/hdfs/store/user/$USER/  #$(ls -d /scratch/*/data/$jobid | awk -F$jobid '{print $1}')
export datasrc=/hdfs/store/user/cepeda/  #$(ls -d /scratch/*/data/$jobid | awk -F$jobid '{print $1}')
export MEGAPATH=/hdfs/store/user/cepeda/
#./make_proxies.sh
#rake "meta:getinputs[$jobid, $datasrc,emm/metaInfo, emm/summedWeights]"
#rake "meta:getmeta[inputs/$jobid, emm/metaInfo, 13, emm/summedWeights]"

#rake "meta:getinputs[$jobid, $datasrc,et/metaInfo,et/summedWeights]"
rake "meta:getmeta[inputs/$jobid,et/metaInfo, 13, et/summedWeights]"

#rake "meta:getinputs[$jobid, $datasrc,ee/metaInfo,ee/summedWeights]]"
#rake "meta:getmeta[inputs/$jobid, ee/metaInfo, 13,ee/summedWeights]]"

unset OVERRIDE_META_TREE_data_ET
unset IGNORE_LUMI_ERRORS
