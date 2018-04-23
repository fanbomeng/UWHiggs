import subprocess
#import optimizer
#for region in optimizer.regions["0"]:
#   subprocess.call(["LFVSimple","8","--i","gg"+region,"--o","gg"+region,"--l","2point3fb","--name","gg"+region])
#for region in optimizer.regions["1"]:
#   subprocess.call(["LFVSimple","8","--i","boost"+region,"--o","boost"+region,"--l","2point3fb","--name","boost"+region])
#for region in optimizer.regions["2"]:
#   subprocess.call(["LFVSimple","8","--i","vbf"+region,"--o","vbf"+region,"--l","2point3fb","--name","vbf"+region])
#subprocess.call(["LFV","10","--i","LFV_2p3fb_mutauhad_1Dic_Fanbo","--o","LFV_2p3fb_mutauhad_1Dic_Fanbo","--l","2point3fb","--d","2point3sys","--b"])
#subprocess.call(["LFVVBFwjet","10","--i","LFV_30fb_mutauhad_1Dicnewchecksfakesnewcut550MC_v3","--o","LFV_30fb_mutauhad_1Dicnewchecksfakesnewcut550MC_v3","--l","Sig_Limit","--d","Sig_Limit","--b"])
#subprocess.call(["LFVVBFold","10","--i","LFV_30fb_mutauhad_1DicBDTtest","--o","LFV_30fb_mutauhad_1DicBDTtest","--l","30fb","--d","30fb","--b"])
#subprocess.call(["LFVVBFFinal","10","--i","LFV_36fb_mutauhad_cutbasedRenamedsys","--o","LFV_36fb_mutauhad_cutbasedRenamedsys","--l","Sig_Limit","--d","Sig_Limit","--b"])
subprocess.call(["LFVVBFHighMass450new","10","--i","LFV_36fb_mutauhad_cutbasedHighMass_sysLowRange","--o","LFV_36fb_mutauhad_cutbasedHighMass_sys450special","--l","Sig_Limitspecial","--d","Sig_Limitspecial","--b"])
subprocess.call(["LFVVBFHighMass200new","10","--i","LFV_36fb_mutauhad_cutbasedHighMass_sysLowRange","--o","LFV_36fb_mutauhad_cutbasedHighMass_sys200","--l","Sig_Limit","--d","Sig_Limit","--b"])
subprocess.call(["LFVVBFHighMass300new","10","--i","LFV_36fb_mutauhad_cutbasedHighMass_sysLowRange","--o","LFV_36fb_mutauhad_cutbasedHighMass_sys300","--l","Sig_Limit","--d","Sig_Limit","--b"])
subprocess.call(["LFVVBFHighMass450new","10","--i","LFV_36fb_mutauhad_cutbasedHighMass_sysHighRange","--o","LFV_36fb_mutauhad_cutbasedHighMass_sys450","--l","Sig_Limit","--d","Sig_Limit","--b"])
subprocess.call(["LFVVBFHighMass600new","10","--i","LFV_36fb_mutauhad_cutbasedHighMass_sysHighRange","--o","LFV_36fb_mutauhad_cutbasedHighMass_sys600","--l","Sig_Limit","--d","Sig_Limit","--b"])
subprocess.call(["LFVVBFHighMass750new","10","--i","LFV_36fb_mutauhad_cutbasedHighMass_sysHighRange","--o","LFV_36fb_mutauhad_cutbasedHighMass_sys750","--l","Sig_Limit","--d","Sig_Limit","--b"])
subprocess.call(["LFVVBFHighMass900new","10","--i","LFV_36fb_mutauhad_cutbasedHighMass_sysHighRange","--o","LFV_36fb_mutauhad_cutbasedHighMass_sys900","--l","Sig_Limit","--d","Sig_Limit","--b"])

#subprocess.call(["LFVVBFHighMass300","10","--i","LFV_36fb_mutauhad_cutbasedHighMass_sys.root","--o","LFV_36fb_mutauhad_cutbasedHighMass_sys.root","--l","Sig_Limit","--d","Sig_Limit","--b"])
#subprocess.call(["LFVVBFHighMass300","10","--i","LFV_36fb_mutauhad_cutbasedHighMass_sys.root","--o","LFV_36fb_mutauhad_cutbasedHighMass_sys.root","--l","Sig_Limit","--d","Sig_Limit","--b"])
#subprocess.call(["LFVVBFFinalNOSM","10","--i","LFV_36fb_mutauhad_BDTSysrenamed","--o","LFV_36fb_mutauhad_BDTSysrenamed","--l","Sig_Limit","--d","Sig_Limit","--b"])
#subprocess.call(["LFVVBFSN","10","--i","LFV_36fb_mutauhad_cutbasedRenamedsys","--o","LFV_36fb_mutauhad_cutbasedRenamedsys","--l","Sig_Limit","--d","Sig_Limit"])
#subprocess.call(["LFVVBFold","10","--i","LFV_30fb_mutauhad_1DicBDTfullbackwithPtnewcut","--o","LFV_30fb_mutauhad_1DicBDTfullbackwithPtnewcut","--l","Sig_Limit","--d","Sig_Limit","--b"])

