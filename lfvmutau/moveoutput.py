import ROOT
from os import listdir
from os.path import isfile, join
from shutil import copy
mypath = '/hdfs/store/user/fmeng/'

for folder1 in listdir(mypath):
   if folder1.startswith("MegaJob_"):
        filename=folder1.split("AnalyzeLFVMuTau-",1)[1]+".root"
	folder2=join(mypath, folder1)
	for folder3 in listdir(folder2):
           if folder3.startswith("mergeFilesJob-mergeFilesJob-mega-batch"):
  		 copy(folder2+"/"+folder3,"/afs/hep.wisc.edu/cms/fmeng/Fanbo/CMSSW_8_0_8/src/UWHiggs/lfvmutau/me_et_mt/"+filename)
                 print folder2+"/"+folder3
                 print filename
           elif folder3.startswith("mergeFilesJob-mega"):
  		 copy(folder2+"/"+folder3,"/afs/hep.wisc.edu/cms/fmeng/Fanbo/CMSSW_8_0_8/src/UWHiggs/lfvmutau/me_et_mt/"+filename)
                 print folder2+"/"+folder3
                 print filename
