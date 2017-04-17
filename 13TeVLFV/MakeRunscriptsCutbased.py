
base=['gg','boost','vbf_gg','vbf_vbf']

sysneed=['none','TauFakeRate_p0_dm0_B_13TeVUp','TauFakeRate_p0_dm0_B_13TeVDown','TauFakeRate_p1_dm0_B_13TeVUp','TauFakeRate_p1_dm0_B_13TeVDown','TauFakeRate_p0_dm1_B_13TeVUp','TauFakeRate_p0_dm1_B_13TeVDown','TauFakeRate_p1_dm1_B_13TeVUp','TauFakeRate_p1_dm1_B_13TeVDown','TauFakeRate_p0_dm10_B_13TeVUp','TauFakeRate_p0_dm10_B_13TeVDown','TauFakeRate_p1_dm10_B_13TeVUp','TauFakeRate_p1_dm10_B_13TeVDown','TauFakeRate_p0_dm0_E_13TeVUp','TauFakeRate_p0_dm0_E_13TeVDown','TauFakeRate_p1_dm0_E_13TeVUp','TauFakeRate_p1_dm0_E_13TeVDown','TauFakeRate_p0_dm1_E_13TeVUp','TauFakeRate_p0_dm1_E_13TeVDown','TauFakeRate_p1_dm1_E_13TeVUp','TauFakeRate_p1_dm1_E_13TeVDown','TauFakeRate_p0_dm10_E_13TeVUp','TauFakeRate_p0_dm10_E_13TeVDown','TauFakeRate_p1_dm10_E_13TeVUp','TauFakeRate_p1_dm10_E_13TeVDown']

sysneed_I=['MES_13TeVUp','MES_13TeVDown','scale_t_1prong_13TeVUp','scale_t_1prong_13TeVDown','scale_t_1prong1pizero_13TeVUp','scale_t_1prong1pizero_13TeVDown','scale_t_3prong_13TeVUp','scale_t_3prong_13TeVDown','scale_mfaketau_1prong1pizero_13TeVUp','scale_mfaketau_1prong1pizero_13TeVDown','Pileup_13TeVUp','Pileup_13TeVDown']

sysneed_II=["Jes_JetAbsoluteFlavMap_13TeVDown","Jes_JetAbsoluteFlavMap_13TeVUp","Jes_JetAbsoluteMPFBias_13TeVDown","Jes_JetAbsoluteMPFBias_13TeVUp","Jes_JetAbsoluteScale_13TeVDown","Jes_JetAbsoluteScale_13TeVUp","Jes_JetAbsoluteStat_13TeVDown","Jes_JetAbsoluteStat_13TeVUp","Jes_JetFlavorQCD_13TeVDown","Jes_JetFlavorQCD_13TeVUp","Jes_JetFragmentation_13TeVDown","Jes_JetFragmentation_13TeVUp","Jes_JetPileUpDataMC_13TeVDown","Jes_JetPileUpDataMC_13TeVUp","Jes_JetPileUpPtBB_13TeVDown","Jes_JetPileUpPtBB_13TeVUp","Jes_JetPileUpPtEC1_13TeVDown","Jes_JetPileUpPtEC1_13TeVUp","Jes_JetPileUpPtEC2_13TeVDown","Jes_JetPileUpPtEC2_13TeVUp","Jes_JetPileUpPtHF_13TeVDown","Jes_JetPileUpPtHF_13TeVUp","Jes_JetPileUpPtRef_13TeVDown","Jes_JetPileUpPtRef_13TeVUp","Jes_JetRelativeBal_13TeVDown","Jes_JetRelativeBal_13TeVUp","Jes_JetRelativeFSR_13TeVDown","Jes_JetRelativeFSR_13TeVUp","Jes_JetRelativeJEREC1_13TeVDown","Jes_JetRelativeJEREC1_13TeVUp","Jes_JetRelativeJEREC2_13TeVDown","Jes_JetRelativeJEREC2_13TeVUp","Jes_JetRelativeJERHF_13TeVDown","Jes_JetRelativeJERHF_13TeVUp","Jes_JetRelativePtBB_13TeVDown","Jes_JetRelativePtBB_13TeVUp","Jes_JetRelativePtEC1_13TeVDown","Jes_JetRelativePtEC1_13TeVUp","Jes_JetRelativePtEC2_13TeVDown","Jes_JetRelativePtEC2_13TeVUp","Jes_JetRelativePtHF_13TeVDown","Jes_JetRelativePtHF_13TeVUp","Jes_JetRelativeStatEC_13TeVDown","Jes_JetRelativeStatEC_13TeVUp","Jes_JetRelativeStatFSR_13TeVDown","Jes_JetRelativeStatFSR_13TeVUp","Jes_JetRelativeStatHF_13TeVDown","Jes_JetRelativeStatHF_13TeVUp","Jes_JetSinglePionECAL_13TeVDown","Jes_JetSinglePionECAL_13TeVUp","Jes_JetSinglePionHCAL_13TeVDown","Jes_JetSinglePionHCAL_13TeVUp","Jes_JetTimePtEta_13TeVDown","Jes_JetTimePtEta_13TeVUp"]

sysneed_III=['MET_chargedUes_13TeVUp','MET_chargedUes_13TeVDown','MET_ecalUes_13TeVUp','MET_ecalUes_13TeVDown','MET_hfUes_13TeVUp','MET_hfUes_13TeVDown','MET_hcalUes_13TeVUp','MET_hcalUes_13TeVDown']

tmptotal_1=sysneed+sysneed_I+sysneed_III

f = open('Run_Cutbased_rename.sh', 'w')
for i in tmptotal_1:
    for j in base:
        f.write('python plot_13TeV_vbfbined_QCD_36_v3.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1 '+j+ '    0  '+i+'    tPt0   0'  '\n')

f.close()

g = open('Run_Cutbased_rename_2.sh', 'w')
tmptotal_2=sysneed_II
for i in tmptotal_2:
    for j in base:
        g.write('python plot_13TeV_vbfbined_QCD_36_v3.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1 '+j+ '    0  '+i+'    tPt0   0'  '\n')

g.close()
