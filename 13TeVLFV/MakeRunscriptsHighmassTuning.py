import optimizer_new
import optimizer_new450
import os
#variableslowrange0={'tPt':[30,35,40,45],'mPt':[55,60,65,70,75,80,85,90,95],'tMtToPfMet_type1':[60,70,80,90,100,110]}
#variableslowrange1={'tPt':[30,35,40,45],'mPt':[55,60,65,70,75,80,85,90,95],'tMtToPfMet_type1':[60,70,80,90,100]}
#variableshighrange0={'tPt':[45,50,55,60,65],'mPt':[120,125,130,135,140,145,150,155,160,165,170,180,185],'tMtToPfMet_type1':[70,80,90,100,110]}
#variableshighrange1={'tPt':[45,50,55,60,65],'mPt':[120,125,130,135,140,145,150,155,160,165,170,180,185],'tMtToPfMet_type1':[60,70,80,90,100,110]}
varused=['tPt','mPt','tMtToPfMet_type1']



os.remove("Run_Hightmasstuning.sh")
f = open('Run_Hightmasstuning.sh', 'w')
f.write('python plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1     gg450   0 none    tPt30   0  450' '\n')
f.write('python plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1  boost450   0 none    tPt30   0  450' '\n')
f.write('python plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1     gg200   0 none    tPt30   0  200' '\n')
f.write('python plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1  boost200   0 none    tPt30   0  200' '\n')
for j in varused:
    for k in  optimizer_new._0jets[j]:
        tmpcutvalue=j+str(k)
        f.write('python   plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1 '+'gg200'+'/'+tmpcutvalue  + '    0  '+'none'+'    tPt0   1 200'  '\n')
    for k in  optimizer_new._1jets[j]:
        tmpcutvalue=j+str(k)
        f.write('python  plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1 '+'boost200'+'/'+tmpcutvalue  + '    0  '+'none'+'    tPt0   1 200'  '\n')
    for k in  optimizer_new450._0jets[j]:
        tmpcutvalue=j+str(k)
        f.write('python  plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1 '+'gg450'+'/'+tmpcutvalue  + '    0  '+'none'+'    tPt0   1 450'  '\n')
    for k in  optimizer_new450._1jets[j]:
        tmpcutvalue=j+str(k)
        f.write('python  plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1 '+'boost450'+'/'+tmpcutvalue  + '    0  '+'none'+'    tPt0   1 450'  '\n')
f.close()
