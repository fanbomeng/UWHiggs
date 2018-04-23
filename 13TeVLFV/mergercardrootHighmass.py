import subprocess
import optimizer_new
import optimizer_new450 

outputdir="cardroot30fb_sys/"
#inputdir="LFV_MiniAODVtrial/"
inputdir=["LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/"]
#sysname=['','CMS_MET_JesDown_','CMS_MET_JesUp_','CMS_MET_TesDown_','CMS_MET_TesUp_','CMS_MET_UesDown_','CMS_MET_UesUp_']
#print optimizer_new.regions["0"]
#for directory in inputdir:
directory="LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/"

for region in optimizer_new.regions["0"]:
      subprocess.call(["hadd",outputdir+"subgg200"+region+".root",directory+"LFV_gg200"+region+"_collMass_type1__Blinded_PoissonErrors.root",directory+"LFV_boost200_collMass_type1__Blinded_PoissonErrors.root"])	
for region in optimizer_new.regions["1"]:
      subprocess.call(["hadd",outputdir+"subboost200"+region+".root",directory+"LFV_boost200"+region+"_collMass_type1__Blinded_PoissonErrors.root",directory+"LFV_gg200_collMass_type1__Blinded_PoissonErrors.root"])	
for region in optimizer_new450.regions["0"]:
      subprocess.call(["hadd",outputdir+"subgg450"+region+".root",directory+"LFV_gg450"+region+"_collMass_type1__Blinded_PoissonErrors.root",directory+"LFV_boost450_collMass_type1__Blinded_PoissonErrors.root"])	
for region in optimizer_new450.regions["1"]:
      subprocess.call(["hadd",outputdir+"subboost450"+region+".root",directory+"LFV_boost450"+region+"_collMass_type1__Blinded_PoissonErrors.root",directory+"LFV_gg450_collMass_type1__Blinded_PoissonErrors.root"])	
#   for region in optimizer_new.regions["1"]:
#      subprocess.call(["hadd",directory+"subboost"+region+".root",directory+"LFV_boost"+region+"_collMass_type1__"+sysname[i]+"Lumi30000.0_Blinded_PoissonErrors.root",directory+"LFV_vbf_vbf_collMass_type1__"+sysname[i]+"Lumi30000.0_Blinded_PoissonErrors.root",directory+"LFV_vbf_gg_collMass_type1__"+sysname[i]+"Lumi30000.0_Blinded_PoissonErrors.root",directory+"LFV_gg_collMass_type1__"+sysname[i]+"Lumi30000.0_Blinded_PoissonErrors.root"])	
#   
#   i=i+1
#
#for region in optimizer_new.regions["0"]:
#      subprocess.call(["hadd",outputdir+"gg"+region+".root",inputdir[0]+"subgg"+region+".root",inputdir[1]+"subgg"+region+".root",inputdir[2]+"subgg"+region+".root",inputdir[3]+"subgg"+region+".root",inputdir[4]+"subgg"+region+".root",inputdir[5]+"subgg"+region+".root",inputdir[6]+"subgg"+region+".root"])	
#for region in optimizer_new.regions["1"]:
#      subprocess.call(["hadd",outputdir+"boost"+region+".root",inputdir[0]+"subboost"+region+".root",inputdir[1]+"subboost"+region+".root",inputdir[2]+"subboost"+region+".root",inputdir[3]+"subboost"+region+".root",inputdir[4]+"subboost"+region+".root",inputdir[5]+"subboost"+region+".root",inputdir[6]+"subboost"+region+".root"])	
#for region in optimizer_new.regions["2loose"]:
#      subprocess.call(["hadd",outputdir+"vbf_gg"+region+".root",inputdir[0]+"subvbf_gg"+region+".root",inputdir[1]+"subvbf_gg"+region+".root",inputdir[2]+"subvbf_gg"+region+".root",inputdir[3]+"subvbf_gg"+region+".root",inputdir[4]+"subvbf_gg"+region+".root",inputdir[5]+"subvbf_gg"+region+".root",inputdir[6]+"subvbf_gg"+region+".root"])	
#      
#for region in optimizer_new.regions["2tight"]:
#      subprocess.call(["hadd",outputdir+"vbf_vbf"+region+".root",inputdir[0]+"subvbf_vbf"+region+".root",inputdir[1]+"subvbf_vbf"+region+".root",inputdir[2]+"subvbf_vbf"+region+".root",inputdir[3]+"subvbf_vbf"+region+".root",inputdir[4]+"subvbf_vbf"+region+".root",inputdir[5]+"subvbf_vbf"+region+".root",inputdir[6]+"subvbf_vbf"+region+".root"])	




#subprocess.call(["hadd",outputdir+"LFV_collMass_type1__Lumi30000.0_Blinded_PoissonErrors"+".root",inputdir[0]+"subLFV_collMass_type1__Lumi30000.0_Blinded_PoissonErrors"+".root",inputdir[1]+"subLFV_collMass_type1__Lumi30000.0_Blinded_PoissonErrors"+".root",inputdir[2]+"subLFV_collMass_type1__Lumi30000.0_Blinded_PoissonErrors"+".root",inputdir[3]+"subLFV_collMass_type1__Lumi30000.0_Blinded_PoissonErrors"+".root",inputdir[4]+"subLFV_collMass_type1__Lumi30000.0_Blinded_PoissonErrors"+".root",inputdir[5]+"subLFV_collMass_type1__Lumi30000.0_Blinded_PoissonErrors"+".root",inputdir[6]+"subLFV_collMass_type1__Lumi30000.0_Blinded_PoissonErrors"+".root"])	
