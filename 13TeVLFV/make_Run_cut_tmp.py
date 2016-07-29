import optimizer
import os
os.remove('Run_cutauto.txt')
fh = open("Run_cutauto.txt","a")
fh.write("python plot_13TeV_LFVwjetdybin10fb.py LFV_MiniAODVtrial/  collMass_type1  gg    0 none  tPt30 0\n")
fh.write("python plot_13TeV_LFVwjetdybin10fb.py LFV_MiniAODVtrial/  collMass_type1  boost    0 none  tPt30 0\n")
fh.write("python plot_13TeV_LFVwjetdybin10fb.py LFV_MiniAODVtrial/  collMass_type1  vbf    0 none  tPt30 0\n")
for region in optimizer.regions["0"]:
    fh.write("python plot_13TeV_LFVwjetdybin10fb.py LFV_MiniAODVtrial/    "+ "collMass_type1   "+"gg/"+ region +"   0 none  tPt30 1\n")
for region in optimizer.regions["1"]:
    fh.write("python plot_13TeV_LFVwjetdybin10fb.py LFV_MiniAODVtrial/    "+ "collMass_type1   "+"boost/"+ region +"   0 none  tPt30 1\n")
for region in optimizer.regions["2"]:
    fh.write("python plot_13TeV_LFVwjetdybin10fb.py LFV_MiniAODVtrial/    "+ "collMass_type1   "+"vbf/"+ region +"     0 none  tPt30 1\n")



fh.close()

