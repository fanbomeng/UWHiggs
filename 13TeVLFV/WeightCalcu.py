import numpy as np
from array import array
import XSec
samplelist=['DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','GluGluHToTauTau_M125_13TeV_powheg_pythia8','GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8','ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1','ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1','TT_TuneCUETP8M1_13TeV-powheg-pythia8','VBFHToTauTau_M125_13TeV_powheg_pythia8','VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8','W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','WW_TuneCUETP8M1_13TeV-pythia8','WZ_TuneCUETP8M1_13TeV-pythia8','ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8','ZZ_TuneCUETP8M1_13TeV-pythia8','ST_t-channel_antitop_4f_leptonDecays_13TeV-powheg-pythia8_TuneCUETP8M1','ST_t-channel_top_4f_leptonDecays_13TeV-powheg-pythia8_TuneCUETP8M1']        
#lumi=12890.00
#lumi=20076.26
lumi=1
lumidir="LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/"+"weights/"
fh = open('weightBDT.py','a')
for sample in samplelist:
       if ('data' not in sample): #calculate effective luminosity
           metafile = lumidir + sample+"_weight.log"
           f = open(metafile).read().splitlines()
           nevents = float((f[0]).split(': ',1)[-1])
           xsec = eval("XSec."+sample.replace("-","_"))
           efflumi = nevents/xsec
        #   weight=lumi/efflumi
           if ("1Jets" in sample ):
              print "1Jets lumi befor adding %f " %efflumi
              Inclusivefilenambe=sample.split("1Jets",1)[0]+sample.split("1",1)[1]
              metafile1 = lumidir + Inclusivefilenambe+"_weight.log"
              f1 = open(metafile1).read().splitlines()
              nevents1 = float((f1[0]).split(': ',1)[-1])
              xsec1 = eval("XSec."+Inclusivefilenambe.replace("-","_"))
              efflumi1 = nevents1/xsec1
              print "lumi  adding %f " %efflumi1
              efflumi=efflumi+efflumi1
              print "lumi after adding %f " %efflumi
           if ("2Jets" in sample ):
              print "2Jets lumi befor adding %f " %efflumi
              Inclusivefilenambe=sample.split("2Jets",1)[0]+sample.split("2",1)[1]
              metafile1 = lumidir + Inclusivefilenambe+"_weight.log"
              f1 = open(metafile1).read().splitlines()
              nevents1 = float((f1[0]).split(': ',1)[-1])
              xsec1 = eval("XSec."+Inclusivefilenambe.replace("-","_"))
              efflumi1 = nevents1/xsec1
              print "lumi  adding %f " %efflumi1
              efflumi=efflumi+efflumi1
              print "lumi after adding %f " %efflumi
           if ("3Jets" in sample ):
              print "3Jets lumi befor adding %f " %efflumi
              Inclusivefilenambe=sample.split("3Jets",1)[0]+sample.split("3",1)[1]
              metafile1 = lumidir + Inclusivefilenambe+"_weight.log"
              f1 = open(metafile1).read().splitlines()
              nevents1 = float((f1[0]).split(': ',1)[-1])
              xsec1 = eval("XSec."+Inclusivefilenambe.replace("-","_"))
              efflumi1 = nevents1/xsec1
              print "lumi  adding %f " %efflumi1
              efflumi=efflumi+efflumi1
              print "lumi after adding %f " %efflumi
           if ("4Jets" in sample ):
              print "4Jets lumi befor adding %f " %efflumi
              Inclusivefilenambe=sample.split("4Jets",1)[0]+sample.split("4",1)[1]
              metafile1 = lumidir + Inclusivefilenambe+"_weight.log"
              f1 = open(metafile1).read().splitlines()
              nevents1 = float((f1[0]).split(': ',1)[-1])
              xsec1 = eval("XSec."+Inclusivefilenambe.replace("-","_"))
              efflumi1 = nevents1/xsec1
              print "lumi  adding %f " %efflumi1
              efflumi=efflumi+efflumi1
              print "lumi after adding %f " %efflumi
           linesave=np.array([sample.replace("-","_")+"="+'('+str(efflumi)+')'])
 #          linesave=sample
#           print linesave
           np.savetxt(fh,linesave,delimiter=" ", fmt="%s")
       else:
           weight=1.0
           linesave=np.array([sample.replace("-","_")+"="+'('+str(weight)+')'])
           np.savetxt(fh,linesave,delimiter=" ", fmt="%s")
          
fh.close()
