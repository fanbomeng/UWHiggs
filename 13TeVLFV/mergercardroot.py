import subprocess
import optimizer

outputdir="cardroot_2point3/"
inputdir="LFV_MiniAODVtrial/"
#for region in optimizer.regions["0"]:
#   subprocess.call(["hadd",outputdir+"gg"+region+".root",inputdir+"LFV_boost_collMass_type1__Blinded_PoissonErrors.root",inputdir+"LFV_vbf_collMass_type1__Blinded_PoissonErrors.root",inputdir+"LFV_gg"+region+"_collMass_type1__Blinded_PoissonErrors.root",inputdir+"LFV_preselection_collMass_type1__Blinded_PoissonErrors.root"])	
#for region in optimizer.regions["1"]:
#   subprocess.call(["hadd",outputdir+"boost"+region+".root",inputdir+"LFV_boost"+region+"_collMass_type1__Blinded_PoissonErrors.root",inputdir+"LFV_vbf_collMass_type1__Blinded_PoissonErrors.root",inputdir+"LFV_gg_collMass_type1__Blinded_PoissonErrors.root",inputdir+"LFV_preselection_collMass_type1__Blinded_PoissonErrors.root"])	
#for region in optimizer.regions["2"]:
#   subprocess.call(["hadd",outputdir+"vbf"+region+".root",inputdir+"LFV_boost_collMass_type1__Blinded_PoissonErrors.root",inputdir+"LFV_vbf"+region+"_collMass_type1__Blinded_PoissonErrors.root",inputdir+"LFV_gg_collMass_type1__Blinded_PoissonErrors.root",inputdir+"LFV_preselection_collMass_type1__Blinded_PoissonErrors.root"])	
#
subprocess.call(["hadd",outputdir+"LFV_collMass_type1__Blinded_PoissonErrors"+".root",inputdir+"LFV_boost_collMass_type1__Blinded_PoissonErrors.root",inputdir+"LFV_vbf_collMass_type1__Blinded_PoissonErrors.root",inputdir+"LFV_gg_collMass_type1__Blinded_PoissonErrors.root",inputdir+"LFV_preselection_collMass_type1__Blinded_PoissonErrors.root"])	
