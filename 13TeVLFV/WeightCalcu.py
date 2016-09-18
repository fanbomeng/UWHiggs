import numpy as np
from array import array
import XSec
samplelist=['DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','GluGluHToTauTau_M125_13TeV_powheg_pythia8','GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8','ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1','ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1','TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen','VBFHToTauTau_M125_13TeV_powheg_pythia8','VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8','W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','WW_TuneCUETP8M1_13TeV-pythia8','WZ_TuneCUETP8M1_13TeV-pythia8','ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','ZZ_TuneCUETP8M1_13TeV-pythia8','data_SingleMuon_Run2016B_PromptReco-v2_25ns','data_SingleMuon_Run2016C_PromptReco-v2_25ns','data_SingleMuon_Run2016D_PromptReco-v2_25ns']        
lumi=12890.00
lumidir="LFV_MiniAODVtrial_sys/AnalyzeLFVMuTauwjets_tune/"+"weights/"
fh = open('weightBDT.py','a')
for sample in samplelist:
       if ('data' not in sample): #calculate effective luminosity
           metafile = lumidir + sample+"_weight.log"
           f = open(metafile).read().splitlines()
           nevents = float((f[0]).split(': ',1)[-1])
           xsec = eval("XSec."+sample.replace("-","_"))
           efflumi = nevents/xsec
           weight=lumi/efflumi
           linesave=np.array([sample.replace("-","_")+"="+'('+str(weight)+')'])
 #          linesave=sample
#           print linesave
           np.savetxt(fh,linesave,delimiter=" ", fmt="%s")
       else:
           weight=1.0
           linesave=np.array([sample.replace("-","_")+"="+'('+str(weight)+')'])
           np.savetxt(fh,linesave,delimiter=" ", fmt="%s")
          
fh.close()
