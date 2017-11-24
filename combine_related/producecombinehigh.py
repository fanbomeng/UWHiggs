import subprocess
import optimizer_new
import optimizer_new450
import os
import shutil




for region in optimizer_new.regions["0"]:
   stringused="lfvauxiliaries/datacards/cardroot30fb_sys/HMuTau_subgg200"+region+"_1200_2016_bbb_m200_cardroot30fb_sys.txt"
   print "HMuTau_subgg200"+region+"_1200_2016_bbb_m200_cardroot30fb_sys.txt" 
   subprocess.call(["combine", "-M","Asymptotic","--run","expected","-C","0.95","-t","-1","--minimizerStrategy","0","-n","-exp","-m","200",stringused])
   shutil.move("higgsCombine-exp.Asymptotic.mH200.root", "combineoutput/"+"gg200"+region+".root")
    
for region in optimizer_new.regions["1"]:
   stringused="lfvauxiliaries/datacards/cardroot30fb_sys/HMuTau_subboost200"+region+"_2200_2016_bbb_m200_cardroot30fb_sys.txt"
   print "HMuTau_subboost200"+region+"_2200_2016_bbb_m200_cardroot30fb_sys.txt" 
   subprocess.call(["combine", "-M","Asymptotic","--run","expected","-C","0.95","-t","-1","--minimizerStrategy","0","-n","-exp","-m","200",stringused])
   shutil.move("higgsCombine-exp.Asymptotic.mH200.root", "combineoutput/"+"boost200"+region+".root")



for region in optimizer_new450.regions["0"]:
   stringused="lfvauxiliaries/datacards/cardroot30fb_sys/HMuTau_subgg450"+region+"_1450_2016_bbb_m450_cardroot30fb_sys.txt"
   stringuesd_1='-exp'
   print "HMuTau_subgg450"+region+"_1450_2016_bbb_m450_cardroot30fb_sys.txt" 
   subprocess.call(["combine", "-M","Asymptotic","--run","expected","-C","0.95","-t","-1","--minimizerStrategy","0","-n","-exp","-m","450",stringused])
   shutil.move("higgsCombine-exp.Asymptotic.mH450.root", "combineoutput/"+"gg450"+region+".root")
    
for region in optimizer_new450.regions["1"]:
   stringused="lfvauxiliaries/datacards/cardroot30fb_sys/HMuTau_subboost450"+region+"_2450_2016_bbb_m450_cardroot30fb_sys.txt"
   stringuesd_1='-exp'
   print "HMuTau_subboost450"+region+"_2450_2016_bbb_m450_cardroot30fb_sys.txt"
   subprocess.call(["combine", "-M","Asymptotic","--run","expected","-C","0.95","-t","-1","--minimizerStrategy","0","-n","-exp","-m","450",stringused])
   shutil.move("higgsCombine-exp.Asymptotic.mH450.root", "combineoutput/"+"boost450"+region+".root")

#for i in range(3):
#   stringused="lfvauxiliaries/datacards/cardroot30fb_sys/HMuTaudef_mutauhad_"+str(i)+"_2016_bbb_m125_cardroot30fb_sys.txt"
#   print "HMuTaudef_mutauhad_"+str(i)+"_2016_bbb_m125_cardroot30fb_sys.txt"
#   subprocess.call(["combine", "-M","Asymptotic","--run","expected","-C","0.95","-t","-1","--minimizerStrategy","0","-n","-exp","-m","125",stringused])
#   shutil.move("higgsCombine-exp.Asymptotic.mH125.root", "combineoutput/"+"HMuTaudef"+str(i)+".root")
#for region in optimizer_new.regions["1"]:
#   subprocess.call(["LFVSimple","8","--i","boost"+region,"--o","boost"+region,"--l","cardroot30fb_sys","--name","boost"+region])
#for region in optimizer_new.regions["2"]:
#   subprocess.call(["LFVSimple","8","--i","vbf"+region,"--o","vbf"+region,"--l","cardroot30fb_sys","--name","vbf"+region])
#HMuTau_vbf_vbfvbfDeta4.0_mutauhad_combined_2016_bbb_m125_cardroot30fb_sys.txt
#HMuTauvbf_vbfvbfMass700_mutauhad_3_2016_bbb_m125_cardroot30fb_sys.txt
