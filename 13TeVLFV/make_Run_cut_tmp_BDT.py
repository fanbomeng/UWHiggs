import optimizer_new
import os
os.remove('Run_cutauto.txt')
fh = open("Run_cutauto.txt","a")
fh.write("python plot_13TeV_vbfbined_QCD_wjets.py LFV_MiniAODVtrial/  collMass_type1  gg    30 none  tPt30 0\n")
fh.write("python plot_13TeV_vbfbined_QCD_wjets.py LFV_MiniAODVtrial/  collMass_type1  boost    30 none  tPt30 0\n")
fh.write("python plot_13TeV_vbfbined_QCD_wjets.py LFV_MiniAODVtrial/  collMass_type1  vbf_gg    30 none  tPt30 0\n")
fh.write("python plot_13TeV_vbfbined_QCD_wjets.py LFV_MiniAODVtrial/  collMass_type1  vbf_vbf    30 none  tPt30 0\n")
for region in optimizer_new.regions["0"]:
    fh.write("python plot_13TeV_vbfbined_QCD_wjets.py LFV_MiniAODVtrial/    "+ "collMass_type1   "+"gg/"+ region +"   30 none  tPt30 1\n")
for region in optimizer_new.regions["1"]:
    fh.write("python plot_13TeV_vbfbined_QCD_wjets.py LFV_MiniAODVtrial/    "+ "collMass_type1   "+"boost/"+ region +"   30 none  tPt30 1\n")
for region in optimizer_new.regions["2loose"]:
    fh.write("python plot_13TeV_vbfbined_QCD_wjets.py LFV_MiniAODVtrial/    "+ "collMass_type1   "+"vbf_gg/"+ region +"     30 none  tPt30 1\n")
for region in optimizer_new.regions["2tight"]:
    fh.write("python plot_13TeV_vbfbined_QCD_wjets.py LFV_MiniAODVtrial/    "+ "collMass_type1   "+"vbf_vbf/"+ region +"     30 none  tPt30 1\n")



fh.close()

