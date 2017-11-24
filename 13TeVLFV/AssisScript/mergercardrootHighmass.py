import subprocess
import optimizer_new
import optimizer_new450 

outputdir="cardroot30fb_sys/"
inputdir=["LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/"]
directory="LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/"

for region in optimizer_new.regions["0"]:
      subprocess.call(["hadd",outputdir+"subgg200"+region+".root",directory+"LFV_gg200"+region+"_collMass_type1__Blinded_PoissonErrors.root",directory+"LFV_boost200_collMass_type1__Blinded_PoissonErrors.root"])	
for region in optimizer_new.regions["1"]:
      subprocess.call(["hadd",outputdir+"subboost200"+region+".root",directory+"LFV_boost200"+region+"_collMass_type1__Blinded_PoissonErrors.root",directory+"LFV_gg200_collMass_type1__Blinded_PoissonErrors.root"])	
for region in optimizer_new450.regions["0"]:
      subprocess.call(["hadd",outputdir+"subgg450"+region+".root",directory+"LFV_gg450"+region+"_collMass_type1__Blinded_PoissonErrors.root",directory+"LFV_boost450_collMass_type1__Blinded_PoissonErrors.root"])	
for region in optimizer_new450.regions["1"]:
      subprocess.call(["hadd",outputdir+"subboost450"+region+".root",directory+"LFV_boost450"+region+"_collMass_type1__Blinded_PoissonErrors.root",directory+"LFV_gg450_collMass_type1__Blinded_PoissonErrors.root"])	
