'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW, Fanbo Meng,ND

'''
import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import weightNormal_MORE_S_WJ 
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import ROOT
import math
import optimizer_new 
import optimizer_new450 
from math import sqrt, pi
import itertools
import bTagSFrereco
from RecoilCorrector import RecoilCorrector
import Systematics
RUN_OPTIMIZATION_v2=False#True

btagSys=0
fakeset= True
MetCorrection=False
systematic = 'none'
wjets_fakes=False
tuning=True
def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
      return PHI
  else:
      return 2*pi-PHI
def deltaR(phi1, phi2, eta1, eta2):
    deta = eta1 - eta2
    dphi = abs(phi1-phi2)
    if (dphi>pi) : dphi = 2*pi-dphi
    return sqrt(deta*deta + dphi*dphi);

def fullMT(mupt,taupt , muphi, tauphi, row, sys='none'):
	mux=mupt*math.cos(muphi)
	muy=mupt*math.sin(muphi)
        met = row.type1_pfMetEt
        metphi = row.type1_pfMetPhi
        metx=met*math.cos(metphi)
        mety=met*math.sin(metphi)
        taux=taupt*math.cos(tauphi)
        tauy=taupt*math.sin(tauphi)
	full_et=met+mupt+taupt 
	full_x=metx+mux+taux
        full_y=mety+muy+tauy
	full_mt_2 = full_et*full_et-full_x*full_x-full_y*full_y
	full_mt=0
	if (full_mt_2>0):
		full_mt= math.sqrt(full_mt_2)
	return full_mt

def fullPT(mupt,taupt, muphi, tauphi, row, sys='none'):
        met = row.type1_pfMetEt
        metphi = row.type1_pfMetPhi
        mux=mupt*math.cos(muphi)
        muy=mupt*math.sin(muphi)
        metx=met*math.cos(metphi)
        mety=met*math.sin(metphi)
        taux=taupt*math.cos(tauphi)
        tauy=taupt*math.sin(tauphi)
        full_x=metx+mux+taux
        full_y=mety+muy+tauy
        full_pt_2 = full_x*full_x+full_y*full_y
        full_pt=0
        if (full_pt_2>0):
                full_pt= math.sqrt(full_pt_2)
        return full_pt
def transverseMass(p1,p2):    
    totalEt2 = (p1[0] + p2[0])*(p1[0] + p2[0])
    totalPt2 = (p1[1] + p2[1])**2+(p1[2]+p2[2])**2
    mt2 = totalEt2 - totalPt2
    return math.sqrt(abs(mt2))
  
def transverseMass_v2(p1,p2):    
    totalEt2 = p1.Et() + p2.Et()
    totalPt2 = (p1+ p2).Pt()
    mt2 = totalEt2*totalEt2 - totalPt2*totalPt2
    return math.sqrt(abs(mt2))
def getGenMfakeTSF(ABStEta):
    if (ABStEta>0 and ABStEta<0.4):
       return 1.263
    if (ABStEta>0.4 and ABStEta<0.8):
       return 1.364
    if (ABStEta>0.8 and ABStEta<1.2):
       return 0.854
    if (ABStEta>1.2 and ABStEta<1.7):
       return 1.712
    if (ABStEta>1.7 and ABStEta<2.3):
       return 2.324

################################################################################
#### MC-DATA and PU corrections ################################################
################################################################################
pu_distributions = glob.glob(os.path.join(
        'inputs', os.environ['jobid'], 'data_SingleMu*pu.root'))
pu_corrector = PileupWeight.PileupWeight('MC_Moriond17', *pu_distributions)

pu_distributionsup = glob.glob(os.path.join(
        'inputs', os.environ['jobid'], 'data_SingleMu*pu_up.root'))
pu_correctorup = PileupWeight.PileupWeight('MC_Moriond17', *pu_distributionsup)


pu_distributionsdown = glob.glob(os.path.join(
        'inputs', os.environ['jobid'], 'data_SingleMu*pu_down.root'))
pu_correctordown = PileupWeight.PileupWeight('MC_Moriond17', *pu_distributionsdown)

muon_pog_TriggerIso24_2016B= MuonPOGCorrections.make_muon_pog_IsoMu24oIsoTkMu24_2016ReRecoeffi()
muon_pog_PFTight1D_2016B = MuonPOGCorrections.make_muon_pog_PFMedium1D_2016ReReco()
muon_pog_PFTight_2016B = MuonPOGCorrections.make_muon_pog_PFMedium_2016ReReco()
muon_pog_TightIso_2016B = MuonPOGCorrections.make_muon_pog_TightIso_2016ReReco('Medium')
muon_pog_TightIso1D_2016B = MuonPOGCorrections.make_muon_pog_TightIso1D_2016ReReco('Medium')


class AnalyzeLFVMuTau_HighMassTriggerEffiPosttune(MegaBase):
    tree = 'mt/final/Ntuple'

    def __init__(self, tree, outfile, **kwargs):
        super(AnalyzeLFVMuTau_HighMassTriggerEffiPosttune, self).__init__(tree, outfile, **kwargs)
        target = os.path.basename(os.environ['megatarget'])
        self.target1 = os.path.basename(os.environ['megatarget'])
        self.ls_recoilC=((('HTo' in target) or ('Jets' in target)) and MetCorrection) 
        if self.ls_recoilC and MetCorrection:
           self.Metcorected=RecoilCorrector("TypeI-PFMet_Run2016BtoH.root")
        
        self.weighttarget=target.split(".",1)[0].replace("-","_")
        self.is_data = target.startswith('data_')
        self.is_dataG_H =(bool('Run2016H' in target) or bool('Run2016G' in target))
        self.ls_Jets=('Jets' in target)
        self.ls_Wjets=("JetsToLNu" in target)
        self.ls_ZTauTau=("ZTauTau" in target)
        self.ls_DY=("DY" in target)
        self.is_ZeroJet=(('WJetsToLNu' in target)or('DYJetsToLL' in target)or('ZTauTauJetsToLL' in target))
        self.is_OneJet=('W1JetsToLNu' in target or('DY1JetsToLL' in target)or('ZTauTau1JetsToLL' in target))
        self.is_TwoJet=('W2JetsToLNu' in target or('DY2JetsToLL' in target)or('ZTauTau2JetsToLL' in target))
        self.is_ThreeJet=('W3JetsToLNu' in target or('DY3JetsToLL' in target)or('ZTauTau3JetsToLL' in target))
        self.is_FourJet=('W4JetsToLNu' in target or('DY4JetsToLL' in target)or('ZTauTau4JetsToLL' in target))
        self.is_embedded = ('Embedded' in target)
        self.is_ZTauTau= ('ZTauTau' in target)
        self.is_ZMuMu= ('Zmumu' in target)
        self.is_HToTauTau= ('HToTauTau' in target)
        self.is_HToMuTau= ('HToMuTau' in target)
        self.is_TauTau= ('TauTau' in target)
        self.is_mc = not (self.is_data or self.is_embedded)
        self.tree = MuTauTree.MuTauTree(tree)
        self.out = outfile
        self.histograms = {}
        self.Sysin=1
        self.light=0
        self.light_v2=0
        self.DoPileup=0
        self.DoMES=0
        self.DoTES=0
        self.DoMFT=0
        self.DoUES=0
        self.DoUESsp=0
        self.DoJES=0
        self.DoFakeshapeDM=0
        self.tau_Pt_C=0.01
        self.tMtToPfMet_type1_new=1000
        self.MET_tPtC=0
        self.collMass_type1_new=-10
        self.m_t_Mass_new=-10
# Currently the DY weight for the consideration of different generator effect(if I remember correctly) is not used, but the root file is in the directory 
        #if self.ls_DY or self.ls_ZTauTau:
        #   self.Z_reweight = ROOT.TFile.Open('zpt_weights_2016_BtoH.root')
        #   self.Z_reweight_H=self.Z_reweight.Get('zptmass_histo')
    def begin(self):

        self.highMass=['200','300','450','600','750','900']
        if RUN_OPTIMIZATION_v2:
           self.highMass=['200','450']
        self.highMassbase=['gg','boost','ggNotIso','ggNotIsoM','ggNotIsoMT','boostNotIso','boostNotIsoM','boostNotIsoMT']
        if not self.light :
           names=["preselection","notIso","notIsoM","notIsoMT","preselectionSS","notIsoSS","notIsoSSM","notIsoSSMT","preslectionEnWjets","notIsoEnWjets","notIsoEnWjetsM","notIsoEnWjetsMT","preslectionEnWjets0Jet","notIsoEnWjets0Jet","notIsoEnWjets0JetM","notIsoEnWjets0JetMT","preslectionEnWjets1Jet","notIsoEnWjets1Jet","notIsoEnWjets1JetM","notIsoEnWjets1JetMT","IsoSS0Jet","IsoSS1Jet","notIsoSS0Jet","notIsoSS0JetM","notIsoSS0JetMT","notIsoSS1Jet","notIsoSS1JetM","notIsoSS1JetMT","preslectionEnZtt","notIsoEnZtt","notIsoEnZttM","notIsoEnZttMT","preslectionEnZtt0Jet","notIsoEnZtt0Jet","notIsoEnZtt0JetM","notIsoEnZtt0JetMT","preslectionEnZtt1Jet","notIsoEnZtt1Jet","notIsoEnZtt1JetM","notIsoEnZtt1JetMT","preslectionEnZmm","notIsoEnZmm","notIsoEnZmmM","notIsoEnZmmMT","preslectionEnZmm0Jet","notIsoEnZmm0Jet","notIsoEnZmm0JetM","notIsoEnZmm0JetMT","preslectionEnZmm1Jet","notIsoEnZmm1Jet","notIsoEnZmm1JetM","notIsoEnZmm1JetMT","preslectionEnTTbar","notIsoEnTTbar","notIsoEnTTbarM","notIsoEnTTbarMT","preslectionEnTTbar0Jet","notIsoEnTTbar0Jet","notIsoEnTTbar0JetM","notIsoEnTTbar0JetMT","preslectionEnTTbar1Jet","notIsoEnTTbar1Jet","notIsoEnTTbar1JetM","notIsoEnTTbar1JetMT","preselection0Jet", "preselection1Jet","notIso0Jet","notIso0JetM","notIso0JetMT","notIso1Jet","notIso1JetM","notIso1JetMT"]
           for i in self.highMassbase:
               for j in self.highMass:
                   names.append(i+j)
        else:
           names=["preselectionSS","notIsoSS","notIsoSSM","notIsoSSMT","preselection0Jet","notIso0Jet","notIsoM0Jet","notIsoMT0Jet","preselection1Jet","notIso1Jet","notIsoM1Jet","notIsoMT1Jet","boostIsoSS200","boostIsoSS450","ggIsoSS200","ggIsoSS450"]
           for i in self.highMassbase:
               for j in self.highMass:
                   names.append(i+j)
        if self.Sysin:
           sysneed_Fake=['TauFakeRate_p0_dm0_B_13TeVUp','TauFakeRate_p0_dm0_B_13TeVDown','TauFakeRate_p1_dm0_B_13TeVUp','TauFakeRate_p1_dm0_B_13TeVDown','TauFakeRate_p0_dm1_B_13TeVUp','TauFakeRate_p0_dm1_B_13TeVDown','TauFakeRate_p1_dm1_B_13TeVUp','TauFakeRate_p1_dm1_B_13TeVDown','TauFakeRate_p0_dm10_B_13TeVUp','TauFakeRate_p0_dm10_B_13TeVDown','TauFakeRate_p1_dm10_B_13TeVUp','TauFakeRate_p1_dm10_B_13TeVDown','TauFakeRate_p0_dm0_E_13TeVUp','TauFakeRate_p0_dm0_E_13TeVDown','TauFakeRate_p1_dm0_E_13TeVUp','TauFakeRate_p1_dm0_E_13TeVDown','TauFakeRate_p0_dm1_E_13TeVUp','TauFakeRate_p0_dm1_E_13TeVDown','TauFakeRate_p1_dm1_E_13TeVUp','TauFakeRate_p1_dm1_E_13TeVDown','TauFakeRate_p0_dm10_E_13TeVUp','TauFakeRate_p0_dm10_E_13TeVDown','TauFakeRate_p1_dm10_E_13TeVUp','TauFakeRate_p1_dm10_E_13TeVDown']
           basechannels_Fake=['ggNotIso','ggNotIsoM','ggNotIsoMT','boostNotIso','boostNotIsoM','boostNotIsoMT']
           for i in sysneed_Fake:
               for j in basechannels_Fake:
                   names.append(j+i)                    
        if self.Sysin and (not self.is_data):
           sysneed=['MES_13TeVUp','MES_13TeVDown','scale_t_1prong_13TeVUp','scale_t_1prong_13TeVDown','scale_t_1prong1pizero_13TeVUp','scale_t_1prong1pizero_13TeVDown','scale_t_3prong_13TeVUp','scale_t_3prong_13TeVDown','scale_mfaketau_1prong1pizero_13TeVUp','scale_mfaketau_1prong1pizero_13TeVDown','Pileup_13TeVUp','Pileup_13TeVDown']
           basechannels=['gg','boost']
           for i in sysneed:
               for j in basechannels:
                   names.append(j+i)                    
           JESsys=["Jes_JetAbsoluteFlavMap_13TeVDown","Jes_JetAbsoluteFlavMap_13TeVUp","Jes_JetAbsoluteMPFBias_13TeVDown","Jes_JetAbsoluteMPFBias_13TeVUp","Jes_JetAbsoluteScale_13TeVDown","Jes_JetAbsoluteScale_13TeVUp","Jes_JetAbsoluteStat_13TeVDown","Jes_JetAbsoluteStat_13TeVUp","Jes_JetFlavorQCD_13TeVDown","Jes_JetFlavorQCD_13TeVUp","Jes_JetFragmentation_13TeVDown","Jes_JetFragmentation_13TeVUp","Jes_JetPileUpDataMC_13TeVDown","Jes_JetPileUpDataMC_13TeVUp","Jes_JetPileUpPtBB_13TeVDown","Jes_JetPileUpPtBB_13TeVUp","Jes_JetPileUpPtEC1_13TeVDown","Jes_JetPileUpPtEC1_13TeVUp","Jes_JetPileUpPtEC2_13TeVDown","Jes_JetPileUpPtEC2_13TeVUp","Jes_JetPileUpPtHF_13TeVDown","Jes_JetPileUpPtHF_13TeVUp","Jes_JetPileUpPtRef_13TeVDown","Jes_JetPileUpPtRef_13TeVUp","Jes_JetRelativeBal_13TeVDown","Jes_JetRelativeBal_13TeVUp","Jes_JetRelativeFSR_13TeVDown","Jes_JetRelativeFSR_13TeVUp","Jes_JetRelativeJEREC1_13TeVDown","Jes_JetRelativeJEREC1_13TeVUp","Jes_JetRelativeJEREC2_13TeVDown","Jes_JetRelativeJEREC2_13TeVUp","Jes_JetRelativeJERHF_13TeVDown","Jes_JetRelativeJERHF_13TeVUp","Jes_JetRelativePtBB_13TeVDown","Jes_JetRelativePtBB_13TeVUp","Jes_JetRelativePtEC1_13TeVDown","Jes_JetRelativePtEC1_13TeVUp","Jes_JetRelativePtEC2_13TeVDown","Jes_JetRelativePtEC2_13TeVUp","Jes_JetRelativePtHF_13TeVDown","Jes_JetRelativePtHF_13TeVUp","Jes_JetRelativeStatEC_13TeVDown","Jes_JetRelativeStatEC_13TeVUp","Jes_JetRelativeStatFSR_13TeVDown","Jes_JetRelativeStatFSR_13TeVUp","Jes_JetRelativeStatHF_13TeVDown","Jes_JetRelativeStatHF_13TeVUp","Jes_JetSinglePionECAL_13TeVDown","Jes_JetSinglePionECAL_13TeVUp","Jes_JetSinglePionHCAL_13TeVDown","Jes_JetSinglePionHCAL_13TeVUp","Jes_JetTimePtEta_13TeVDown","Jes_JetTimePtEta_13TeVUp"]
           UESspsys=['MET_chargedUes_13TeVUp','MET_chargedUes_13TeVDown','MET_ecalUes_13TeVUp','MET_ecalUes_13TeVDown','MET_hfUes_13TeVUp','MET_hfUes_13TeVDown','MET_hcalUes_13TeVUp','MET_hcalUes_13TeVDown']
           for i in  JESsys:
               for j in basechannels:
                   names.append(j+i)
           for i in  UESspsys:
               for j in basechannels:
                   names.append(j+i)
        if RUN_OPTIMIZATION_v2:
		for region in optimizer_new.regions['0']:
			names.append(os.path.join("gg200",region))	
			names.append(os.path.join("ggIsoSS200",region))	
		for region in optimizer_new.regions['1']:
			names.append(os.path.join("boost200",region))	
			names.append(os.path.join("boostIsoSS200",region))	
		for region in optimizer_new450.regions['0']:
			names.append(os.path.join("gg450",region))	
			names.append(os.path.join("ggIsoSS450",region))	
		for region in optimizer_new450.regions['1']:
			names.append(os.path.join("boost450",region))	
			names.append(os.path.join("boostIsoSS450",region))	
        namesize = len(names)
	for x in range(0,namesize):
# some of the histogram is commented out but not removed, for the consideration of further use

            self.book(names[x], "mPt", "Muon  Pt", 1400,0,1400)
            self.book(names[x], "tPt", "Tau  Pt", 1400,0,1400)
            self.book(names[x], "tMtToPfMet_type1", "Tau MT (PF Ty1)", 1400, 0, 1400)
            self.book(names[x], "mMtToPfMet_type1", "mu MT (PF Ty1)", 1400, 0, 1400)
            #self.book(names[x], "mMtToPfMet_type1", "Muon MT (PF Ty1)", 200, 0, 200)
            #self.book(names[x], "type1_pfMetEtNormal", "Type1 MET", 200, 0, 200)
            #self.book(names[x],"collMass_type1","collMass_type1",300,0,300);
            self.book(names[x],"collMass_type1","collMass_type1",1400,0,1400);
            self.book(names[x], "m_t_Mass", "Muon + Tau Mass", 200, 0, 200)
#            self.book(names[x],"fullMT_type1","fullMT_type1",500,0,500);
#            self.book(names[x], "genHTT", "genHTT", 1000 ,0,1000)
#            self.book(names[x], "singleIsoMu22Pass", "singleIsoMu22Pass", 12 ,-0.1,1.1)
#            self.book(names[x], "singleIsoTkMu22Pass", "singleIsoTkMu22Pass", 12 ,-0.1,1.1)
            #self.book(names[x], "rho", "Fastjet #rho", 100, 0, 25)
           # self.book(names[x], "nvtx", "Number of vertices", 100, -0.5, 100.5)
            #self.book(names[x], "prescale", "HLT prescale", 21, -0.5, 20.5)
            #self.book(names[x], "tJetPartonFlavour", "tJetPartonFlavour", 30,-7, 23)
            #self.book(names[x], "mJetPartonFlavour", "mJetPartonFlavour", 30,-7, 23)

   
            if not self.light: 
                  self.book(names[x], "weight", "Event weight", 100, 0, 5)
                  self.book(names[x], "counts", "Event counts", 10, 0, 5)
                  self.book(names[x], "GenWeight", "Gen level weight", 200000 ,-1000000, 1000000)
                  self.book(names[x], "nTruePU", "Number of truePU", 20, -0.5, 100.5)
                  self.book(names[x], "numGenJets", "Number of GenJets", 20, -0.5, 100.5)
                  self.book(names[x], "mPhi", "mPhi", 100 ,-3.4,3.4)
                  self.book(names[x], "nvtx", "Number of vertices", 20, -0.5, 100.5)
                  self.book(names[x], "mEta", "Muon  eta", 100, -2.5, 2.5)
                  self.book(names[x], "tEta", "Tau  eta", 100, -2.5, 2.5)
                  self.book(names[x], "tPhi", "tPhi", 100 ,-3.4,3.4)
                  self.book(names[x], "tDPhiToPfMet_type1", "tDPhiToPfMet_type1", 100, 0, 4)
                  self.book(names[x], "type1_pfMetEt", "Type1 MET", 1400, 0, 1400)
            #      self.book(names[x], "m_t_Pt", "Muon + Tau Pt", 200, 0, 200)
                  self.book(names[x], "m_t_DR", "Muon + Tau DR", 100, 0, 10)
                  self.book(names[x], "m_t_DEta", "Muon + Tau DEta", 100, 0,4)
                  self.book(names[x], "m_t_DPhi", "Muon + Tau DPhi", 100, 0, 4)
                  self.book(names[x], "mDPhiToPfMet_type1", "mDPhiToPfMet_type1", 100, 0, 4)
                  self.book(names[x], "m_t_SS", "Muon + Tau SS", 5, -2, 2)
      	          self.book(names[x], "vbfMass", "", 1400,0,1400.0)
      	          self.book(names[x], "vbfDeta", "", 100, -0.5,10.0)
  	          self.book(names[x], 'mRelPFIsoDBDefaultR04' ,'Muon Isolation', 100, 0.0,1.0)
#            self.book(names[x], "mCharge", "Muon Charge", 5, -2, 2)

###            self.book(names[x], "tPtavColMass", "Tau  Pt av Mass", 150,0,1.5)
#            self.book(names[x], "tMtToPfMet_type1MetC", "Tau MT (PF Ty1 C)", 200, 0, 200)
#            self.book(names[x], "tCharge", "Tau  Charge", 5, -2, 2)
#	    self.book(names[x], "tJetPt", "Tau Jet Pt" , 500, 0 ,500)	    
#            self.book(names[x], "tMass", "Tau  Mass", 1000, 0, 10)
#            self.book(names[x], "tLeadTrackPt", "Tau  LeadTrackPt", 300,0,300)
##            self.book(names[x], "tDPhiToPfMet_type1MetC", "tDPhiToPfMet_type1MetC", 100, 0, 4)

		       
#            self.book(names[x], 'mPixHits', 'Mu 1 pix hits', 10, -0.5, 9.5)
#            self.book(names[x], 'mJetBtag', 'Mu 1 JetBtag', 100, -5.5, 9.5)
    	  
#            self.book(names[x],"collMass_type1_1","collMass_type1_1",500,0,500);
#            self.book(names[x],"collMass_type1_2","collMass_type1_2",500,0,500);

##            self.book(names[x],"collMass_type1MetC","collMass_type1MetC",500,0,500);
          #  self.book(names[x],"collMass_type1","collMass_type1",25,0,500);
     #       self.book(names[x],"fullPT_type1","fullPT_type1",500,0,500);	    
#    	    self.book(names[x], "LT", "ht", 400, 0, 400)
#            self.book2(names[x], "mDPhiToPfMet_tDPhiToPfMet", "mDPhiToPfMet_tDPhiToPfMet", 100, 0, 4, 100, 0, 4)
#            self.book2(names[x], "mDPhiToPfMet_ggdeltaphi", "mDPhiToPfMet_ggdeltaphi", 100, 0, 4, 100, 0, 4)
#            self.book2(names[x], "tDPhiToPfMet_ggdeltaphi", "tDPhiToPfMet_ggdeltaphi", 100, 0, 4, 100, 0, 4)
#            self.book2(names[x], "tDPhiToPfMet_tMtToPfMet_type1", "tDPhiToPfMet_tMtToPfMet_type1", 100, 0, 4, 200, 0,200)
#            self.book2(names[x], "vbfmass_vbfdeta", "vbfmass_vbfdeta",100, 0,1000,70, 0,7)
      #      self.book(names[x], "m_t_ToMETDPhi_Ty1", "Muon Tau DPhi to MET", 100, 0, 4)
    
            # Vetoes
#            self.book(names[x], 'muVetoPt5IsoIdVtx', 'Number of extra muons', 5, -0.5, 4.5)
#	    self.book(names[x], 'muVetoPt15IsoIdVtx', 'Number of extra muons', 5, -0.5, 4.5)
#            self.book(names[x], 'tauVetoPt20Loose3HitsVtx', 'Number of extra taus', 5, -0.5, 4.5)
#            self.book(names[x], 'eVetoMVAIso', 'Number of extra CiC tight electrons', 5, -0.5, 4.5)
   
            #self.book(names[x], 'jetVeto30PUCleanedTight', 'Number of extra jets', 5, -0.5, 4.5)
            #self.book(names[x], 'jetVeto30PUCleanedLoose', 'Number of extra jets', 5, -0.5, 4.5)
#            self.book(names[x], 'jetVeto30', 'Number of extra jets', 5, -0.5, 4.5)	
#            self.book(names[x], 'jetVeto30Eta3', 'Number of extra jets within |eta| < 3', 5, -0.5, 4.5)
	    #Isolation
   
 
       #     self.book(names[x], "mPhiMtPhi", "", 100, 0,4)
       #     self.book(names[x], "mPhiMETPhiType1", "", 100, 0,4)
       #     self.book(names[x], "tPhiMETPhiType1", "", 100, 0,4)
##            self.book(names[x], "tPhiMETPhiType1MetC", "", 100, 0,4)

### vbf ###
#            self.book(names[x], "vbfJetVeto30", "central jet veto for vbf", 5, -0.5, 4.5)
#	    self.book(names[x], "vbfJetVeto20", "", 5, -0.5, 4.5)
#	    self.book(names[x], "vbfMVA", "", 100, 0,0.5)
#            self.book(names[x], "vbfj1eta","",100,-2.5,2.5)
#	    self.book(names[x], "vbfj2eta","",100,-2.5,2.5)
#	    self.book(names[x], "vbfVispt","",100,0,200)
#	    self.book(names[x], "vbfHrap","",100,0,5.0)
#	    self.book(names[x], "vbfDijetrap","",100,0,5.0)
#	    self.book(names[x], "vbfDphihj","",100,0,4)
#            self.book(names[x], "vbfDphihjnomet","",100,0,4)
     #       self.book(names[x], "vbfNJets30", "g", 5, -0.5, 4.5)
            #self.book(names[x], "vbfNJets30PULoose", "g", 5, -0.5, 4.5)
            #self.book(names[x], "vbfNJets30PUTight", "g", 5, -0.5, 4.5)
    def mc_corrector_2016(self,row):
      if self.DoPileup==0:
         pu = pu_corrector(row.nTruePU)
      elif self.DoPileup==1:
         pu = pu_correctorup(row.nTruePU)
      elif self.DoPileup==2:
         pu = pu_correctordown(row.nTruePU)
      m1tracking =MuonPOGCorrections.mu_trackingEta_MORIOND2017(abs(row.mEta))[0]
      if (not self.Sysin) or (self.DoTES) or self.DoUES or self.DoJES or self.DoFakeshapeDM or self.DoMFT or self.DoUESsp:
         if row.mPt<=199:
            m1id =muon_pog_PFTight_2016B(row.mPt,abs(row.mEta))
            m1iso =muon_pog_TightIso_2016B(row.mPt,abs(row.mEta))
         else:
            m1id =muon_pog_PFTight1D_2016B(row.mPt)
            m1iso =muon_pog_TightIso1D_2016B(row.mPt)
         m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt,abs(row.mEta))
       
      elif self.Sysin and self.DoMES==1:
            m1id =muon_pog_PFTight_2016B(row.mPt*1.002,abs(row.mEta))
            m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt*1.002,abs(row.mEta))
            m1iso =muon_pog_TightIso_2016B(row.mPt*1.002,abs(row.mEta))
      elif self.Sysin and self.DoMES==2:
            m1id =muon_pog_PFTight_2016B(row.mPt*0.998,abs(row.mEta))
            m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt*0.998,abs(row.mEta))
            m1iso =muon_pog_TightIso_2016B(row.mPt*0.998,abs(row.mEta))
      else:
         m1id =muon_pog_PFTight_2016B(row.mPt,abs(row.mEta))
         m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt,abs(row.mEta))
         m1iso =muon_pog_TightIso_2016B(row.mPt,abs(row.mEta))
      return pu*m1id**m1tracking*m_trgiso22  
    def getFakeRateFactorFANBOPt(self,row, fakeset):
            if fakeset=="def":
               if row.tPt<=200:
                      fTauIso=0.215034-0.00047209*(self.tau_Pt_C-30)
               else:
                      fTauIso=0.1372


            if self.DoFakeshapeDM:
               if self.DoFakeshapeDM==20170000:
                  if abs(row.tEta)<1.479:
                     if  row.tDecayMode==0:
                         fTauIso=0.218512-0.000337089*(self.tau_Pt_C-30)
                     elif  row.tDecayMode==1:
                         fTauIso=0.230227-0.000786509*(self.tau_Pt_C-30)
                     elif  row.tDecayMode==10:
                         fTauIso=0.172631-0.0000840138*(self.tau_Pt_C-30)
                     else:
                         print "rare decay mode %f" %row.tDecayMode
                         fTauIso=0
                  else:
                     if  row.tDecayMode==0:
                         fTauIso=0.270796-0.000821388*(self.tau_Pt_C-30)
                     elif  row.tDecayMode==1:
                         fTauIso=0.244202-0.000882359*(self.tau_Pt_C-30)
                     elif  row.tDecayMode==10:
                         fTauIso=0.214062-0.000896065*(self.tau_Pt_C-30)
                     else:
                         print "rare decay mode %f" %row.tDecayMode
                         fTauIso=0
#this the how the fake shape used to applied in the analysis, each of the was give a number that stands for a meaning for later use
#The number, take 20170111 as an example,   2017 just the year to distiguish from other numbers, the first 0 stands for decay mode, 
#the first 1 stands for the first parameter(P0) in the fake rate ration which is the form as P0+P1(x-30), the second 1 stand for the 
#parameter is shifted up, and the last 1 stand for this is in the EB region 
               elif self.DoFakeshapeDM==20170111:  # 0(DM)   1(first parameter) 1(up)  1(EB)
                      fTauIso=(0.218512+0.0086708)-0.000337089*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==20170112:  # 0(DM)   1(first parameter) 1(up)  2(EE) 
                      fTauIso=(0.270796+0.0142570)-0.000821388*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==20170121:  # 0(DM)   1(first parameter) 2(down)
                      fTauIso=(0.218512-0.0086708)-0.000337089*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==20170122:  # 0(DM)   1(first parameter) 2(down)
                      fTauIso=(0.270796-0.0142570)-0.000821388*(self.tau_Pt_C-30)

               elif self.DoFakeshapeDM==20170211:  # 0(DM)   2(second parameter) 1(up)
                      fTauIso=(0.218512)-(0.000337089+0.000418367)*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==20170212:  # 0(DM)   2(second parameter) 1(up)
                      fTauIso=(0.270796)-(0.000821388+0.000836319)*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==20170221:  # 0(DM)   2(second parameter) 2(down)
                      fTauIso=(0.218512)-(0.000337089-0.000418367)*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==20170222:  # 0(DM)   2(second parameter) 2(down)
                      fTauIso=(0.270796)-(0.000821388-0.000836319)*(self.tau_Pt_C-30)

               elif self.DoFakeshapeDM==20171111:  # 1(DM)   1(first parameter) 1(up)
                      fTauIso=(0.230227+0.0047079)-0.000786509*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==20171112:  # 1(DM)   1(first parameter) 1(up)
                      fTauIso=(0.244202+0.00819069)-0.000882359*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==20171121:  # 1(DM)   1(first parameter) 2(down)
                      fTauIso=(0.230227-0.0047079)-0.000786509*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==20171122:  # 1(DM)   1(first parameter) 2(down)
                      fTauIso=(0.244202-0.00819069)-0.000882359*(self.tau_Pt_C-30)

               elif self.DoFakeshapeDM==20171211:  # 1(DM)   2(second parameter) 1(up)
                      fTauIso=0.230227-(0.000786509+0.00022109)*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==20171212:  # 1(DM)   2(second parameter) 1(up)
                      fTauIso=0.244202-(0.000882359+0.000390937)*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==20171221:  # 1(DM)   2(second parameter) 2(down)
                      fTauIso=0.230227-(0.000786509-0.00022109)*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==20171222:  # 1(DM)   2(second parameter) 2(down)
                      fTauIso=0.244202-(0.000882359-0.000390937)*(self.tau_Pt_C-30)

               elif self.DoFakeshapeDM==201710111:  # 10(DM)   1(first parameter) 1(up)
                      fTauIso=(0.172631+0.00472798)-0.0000840138*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==201710112:  # 10(DM)   1(first parameter) 1(up)
                      fTauIso=(0.214062+0.00800632)-0.000896065*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==201710121:  # 10(DM)   1(first parameter) 2(down)
                      fTauIso=(0.172631-0.00472798)-0.0000840138*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==201710122:  # 10(DM)   1(first parameter) 2(down)
                      fTauIso=(0.214062-0.00800632)-0.000896065*(self.tau_Pt_C-30)


               elif self.DoFakeshapeDM==201710211:  # 10(DM)   2(second parameter) 1(up)
                      fTauIso=0.172631-(0.0000840138+0.000251370)*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==201710212:  # 10(DM)   2(second parameter) 1(up)
                      fTauIso=0.214062-(0.000896065+0.000395512)*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==201710221:  # 10(DM)   2(second parameter) 2(down)
                      fTauIso=0.172631-(0.0000840138-0.000251370)*(self.tau_Pt_C-30)
               elif self.DoFakeshapeDM==201710222:  # 10(DM)   2(second parameter) 2(down)
                      fTauIso=0.214062-(0.000896065-0.000395512)*(self.tau_Pt_C-30)
               else:
                    print 'bug in the fake rate ratio!!!!!!!!!!!!!!!!!!!'
                    print 'the self.DoFakeshapeDM in this bug case is %f' %self.DoFakeshapeDM
            fakeRateFactor = fTauIso/(1.0-fTauIso)
            return fakeRateFactor
    def collMass_type1_v1(self,row,metpx,metpy):
            taupx=row.tPt*math.cos(row.tPhi)
            taupy=row.tPt*math.sin(row.tPhi)
            met = math.sqrt(metpx*metpx+metpy*metpy)
            METproj= abs(metpx*taupx+metpy*taupy)/row.tPt
            xth=row.tPt/(row.tPt+METproj)
            den=math.sqrt(xth)
            mass=row.m_t_Mass/den
            #print mass
            return mass
    def collMass_type1_v2(self,row,muonlorenz,taulorenz,metpx,metpy):
            taupx=taulorenz.Px()
            taupy=taulorenz.Py()
            taupt=taulorenz.Pt()
            METproj= abs(metpx*taupx+metpy*taupy)/taupt
            xth=taupt/(taupt+METproj)
            den=math.sqrt(xth)
            mass=(muonlorenz+taulorenz).M()
            return (mass/den,mass)
    def correction(self,row):
	return self.mc_corrector_2016(row)
	
    def getFakeRateFactormuon(self,row, fakeset):   
        if fakeset=="def":
          fTauIso=0.780172+0.072857*row.mEta-0.147437*row.mEta*row.mEta+0.0576102*row.mEta*row.mEta*row.mEta
        if self.DoMES==1:
           if row.mPt*1.002<=30:
              fTauIso=0.611
           elif row.mPt*1.002<=40:
              fTauIso=0.724
           elif row.mPt*1.002<=50:
              fTauIso=0.746
           elif row.mPt*1.002<=60:
              fTauIso=0.796
           elif row.mPt*1.002<=80:
              fTauIso=0.816
           else:
              fTauIso=0.950
        elif self.DoMES==2:
           if row.mPt*0.998<=30:
              fTauIso=0.611
           elif row.mPt*0.998<=40:
              fTauIso=0.724
           elif row.mPt*0.998<=50:
              fTauIso=0.746
           elif row.mPt*0.998<=60:
              fTauIso=0.796
           elif row.mPt*0.998<=80:
              fTauIso=0.816
           else:
              fTauIso=0.950
        fakeRateFactor = fTauIso/(1.0-fTauIso)
        return fakeRateFactor
    def fakeRateMethod(self,row,fakeset,faketype):
        if faketype=="taufake":
           return self.getFakeRateFactorFANBOPt(row,fakeset)
        if faketype=="muonfake":
           return self.getFakeRateFactormuon(row,fakeset)
        if faketype=="mtfake":
           return self.getFakeRateFactormuon(row,fakeset)*self.getFakeRateFactorFANBOPt(row,fakeset)
	     
    def fill_histosup(self, row,name='gg', fakeRate=False, fakeset="def"):
        histos = self.histograms
        histos['counts'].Fill(1,1)
#this used to put in the Met Recoil correction, the python file I used to use is also in the repository, also Recoil correction as checked does not 
#show an apparently effect
    def MetCorrectionSet(self,row):
           if self.ls_Wjets:
              self.tmpMet=self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi),row.type1_pfMetEt*math.sin(row.type1_pfMetPhi),row.genpX,row.genpY,row.vispX,row.vispY,int(round(row.jetVeto30))+1)
           else:
              self.tmpMet=self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi),row.type1_pfMetEt*math.sin(row.type1_pfMetPhi),row.genpX,row.genpY,row.vispX,row.vispY,int(round(row.jetVeto30)))
           MetRecoillorenz=ROOT.TLorentzVector()
           TauRecoillorenz=ROOT.TLorentzVector()
           MetPhi=math.atan2(self.tmpMet[1],self.tmpMet[0])
           MetRecoillorenz.SetPtEtaPhiM(math.sqrt(self.tmpMet[0]*self.tmpMet[0]+self.tmpMet[1]*self.tmpMet[1]),0,MetPhi,0)
           TauRecoillorenz.SetPtEtaPhiM(row.tPt,row.tEta,row.tPhi,row.tMass)
           self.collMass_type1MetC=self.collMass_type1_v1(row,self.tmpMet[0],self.tmpMet[1])
           self.tMtToPfMet_type1MetC=transverseMass_v2(TauRecoillorenz,MetRecoillorenz)
           self.type1_pfMetEtC=math.sqrt(self.tmpMet[0]*self.tmpMet[0]+self.tmpMet[1]*self.tmpMet[1])
    def fill_histos(self, row,name='gg',fakeRate=False,faketype="taufake",fakeset="def"):
        histos = self.histograms
        weight=1
        if (not(self.is_data)):
	   weight =row.GenWeight * self.correction(row)*bTagSFrereco.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)*self.WeightJetbin(row)
        if (fakeRate == True):
          weight=weight*self.fakeRateMethod(row,fakeset,faketype) 
        if (self.is_ZTauTau or self.is_HToTauTau or self.is_HToMuTau or self.is_TauTau):
          if not (('notIso' in name) or ('NotIso' in name)): 
             weight=weight*0.95
        if (self.ls_DY and row.isZmumu  and row.tZTTGenMatching<5):
          weight=weight*getGenMfakeTSF(abs(row.tEta))
#        if self.ls_DY or self.ls_ZTauTau:
#           wtzpt=self.Z_reweight_H.GetBinContent(self.Z_reweight_H.GetXaxis().FindBin(row.genM),self.Z_reweight_H.GetYaxis().FindBin(row.genpT))
        if (not self.Sysin) or self.DoFakeshapeDM or self.DoPileup:   
           histos[name+'/tPt'].Fill(self.tau_Pt_C, weight)
           histos[name+'/mPt'].Fill(row.mPt, weight)
           histos[name+'/m_t_Mass'].Fill(self.m_t_Mass_new,weight)
        #   histos[name+'/mRelPFIsoDBDefaultR04'].Fill(row.mRelPFIsoDBDefaultR04,weight)
#           print "fill histogram? %f" %row.mPt
        #   histos[name+'/type1_pfMetEtNormal'].Fill(row.type1_pfMetEt,weight)
           if self.ls_recoilC and MetCorrection:
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1MetC,weight)
              histos[name+'/type1_pfMetEt'].Fill(self.type1_pfMetEtC,weight)
           else:
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1_new,weight)
              histos[name+'/mMtToPfMet_type1'].Fill(self.mMtToPfMet_type1_new,weight)
        #      histos[name+'/type1_pfMetEt'].Fill(row.type1_pfMetEt,weight)
           if self.ls_recoilC and MetCorrection: 
              histos[name+'/collMass_type1'].Fill(self.collMass_type1MetC,weight)
           else:
              histos[name+'/collMass_type1'].Fill(self.collMass_type1_new,weight)
        else:
           if self.DoTES or self.DoMFT:
              histos[name+'/tPt'].Fill(self.MorTPtshifted, weight)
              histos[name+'/mPt'].Fill(row.mPt, weight)
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1_new,weight)
              histos[name+'/collMass_type1'].Fill(self.collMass_type1_new,weight)
              histos[name+'/m_t_Mass'].Fill(self.m_t_Mass_new,weight)
           if self.DoUES or self.DoJES or self.DoUESsp:
              histos[name+'/tPt'].Fill(self.tau_Pt_C, weight)
              histos[name+'/mPt'].Fill(row.mPt, weight)
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1_new,weight)
              histos[name+'/collMass_type1'].Fill(self.collMass_type1_new,weight)
              histos[name+'/m_t_Mass'].Fill(self.m_t_Mass_new,weight)
           if self.DoMES:
              histos[name+'/tPt'].Fill(self.tau_Pt_C, weight)
              histos[name+'/mPt'].Fill(self.MorTPtshifted, weight)
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1_new,weight)
              histos[name+'/collMass_type1'].Fill(self.collMass_type1_new,weight) 
              histos[name+'/m_t_Mass'].Fill(self.m_t_Mass_new,weight)
        if not self.light: 
           histos[name+'/nvtx'].Fill(row.nvtx, weight)
           histos[name+'/weight'].Fill(weight)
           histos[name+'/GenWeight'].Fill(row.GenWeight)
           histos[name+'/nTruePU'].Fill(row.nTruePU,weight)
           histos[name+'/numGenJets'].Fill(row.numGenJets,weight)
           histos[name+'/mPhi'].Fill(row.mPhi,weight)
           histos[name+'/mRelPFIsoDBDefaultR04'].Fill(row.mRelPFIsoDBDefaultR04,weight)
#           histos[name+'/mMtToPfMet_type1'].Fill(row.mMtToPfMet_type1,weight)
           histos[name+'/counts'].Fill(1)
           histos[name+'/mEta'].Fill(row.mEta, weight)
           histos[name+'/tEta'].Fill(row.tEta, weight)
           histos[name+'/tPhi'].Fill(row.tPhi, weight)
       	   histos[name+'/type1_pfMetEt'].Fill(self.MET_tPtC,weight)
           histos[name+'/m_t_DR'].Fill(row.m_t_DR,weight)
           histos[name+'/m_t_DPhi'].Fill(row.m_t_DPhi,weight)
           histos[name+'/m_t_DEta'].Fill(abs(row.mEta-row.tEta),weight)
           histos[name+'/m_t_SS'].Fill(row.m_t_SS,weight)
   	   histos[name+'/mDPhiToPfMet_type1'].Fill(abs(row.mDPhiToPfMet_type1),weight)
           histos[name+'/vbfMass'].Fill(row.vbfMass, weight)
           histos[name+'/vbfDeta'].Fill(row.vbfDeta, weight)
           if self.ls_recoilC and MetCorrection: 
   	      histos[name+'/tDPhiToPfMet_type1'].Fill(abs(self.TauDphiToMet),weight)
           else:
   	      histos[name+'/tDPhiToPfMet_type1'].Fill(abs(row.tDPhiToPfMet_type1),weight)
# This is the Tau energy scale correction reconmanded by the Tau POG, which based on decay mode
    def TauESC(self,row):
        if (not self.is_data) and (not self.ls_DY) and row.tZTTGenMatching==5:
           if  row.tDecayMode==0:
               tau_Pt_C=0.982*row.tPt
               MET_tPtC=row.type1_pfMetEt+0.018*row.tPt
           elif  row.tDecayMode==1:
               tau_Pt_C=1.01*row.tPt
               MET_tPtC=row.type1_pfMetEt-0.01*row.tPt
           elif  row.tDecayMode==10:
               tau_Pt_C=1.004*row.tPt
               MET_tPtC=row.type1_pfMetEt-0.004*row.tPt
           else:
               tau_Pt_C=1
               MET_tPtC=0
           return (tau_Pt_C,MET_tPtC)
        elif self.ls_DY and row.isZmumu  and row.tZTTGenMatching<5 and row.tDecayMode==1:
               tau_Pt_C=1.015*row.tPt
               MET_tPtC=row.type1_pfMetEt-0.015*row.tPt
               return (tau_Pt_C,MET_tPtC)
        else:
           return (row.tPt,row.type1_pfMetEt)
# This function is used to recalculate the useful variables, after the Tau energy scale correction  
    def VariableCalculateTaucorrection(self,row,tmp_tau_Pt_C,tmp_MET_tPtC):
           taulorenz=ROOT.TLorentzVector()
           muonlorenz=ROOT.TLorentzVector()             
           metlorenz=ROOT.TLorentzVector() 
           taulorenz.SetPtEtaPhiM(tmp_tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
           muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
           metlorenz.SetPtEtaPhiM(tmp_MET_tPtC,0,row.type1_pfMetPhi,0)
           collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,metlorenz.Px(),metlorenz.Py())
           tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
           mMtToPfMet_type1_new=transverseMass_v2(muonlorenz,metlorenz)
           return(collMass_type1_new,m_t_Mass_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new)
# This function  is to recalculate the varaiables in the shape systematics variation, take self.DoMES==1, which means we now running the muon energy scale
# which will change the muon Pt, so after this change, MET will also need to change, also the related variable, like TMttoPfMet, collinearmass also need to 
# be recalcualted
    def VariableCalculate(self,row,tau_Pt_C,MET_tPtC):
           taulorenz=ROOT.TLorentzVector()
           muonlorenz=ROOT.TLorentzVector()             
           metlorenz=ROOT.TLorentzVector() 
           if self.DoTES==1:
              tmpHulaTESUp=Systematics.TESup(tau_Pt_C,MET_tPtC,row.tPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(tmpHulaTESUp[0],row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaTESUp[3],0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaTESUp[4],tmpHulaTESUp[5])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              return(collMass_type1_new,m_t_Mass_new,tMtToPfMet_type1_new,tmpHulaTESUp[0])
           if self.DoTES==2:
              tmpHulaTESDown=Systematics.TESdown(tau_Pt_C,MET_tPtC,row.tPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(tmpHulaTESDown[0],row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaTESDown[3],0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaTESDown[4],tmpHulaTESDown[5])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              return(collMass_type1_new,m_t_Mass_new,tMtToPfMet_type1_new,tmpHulaTESDown[0])
           if self.DoTES==3: 
              taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(MET_tPtC,0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,MET_tPtC*math.cos(row.type1_pfMetPhi),MET_tPtC*math.sin(row.type1_pfMetPhi))
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              return(collMass_type1_new,m_t_Mass_new,tMtToPfMet_type1_new,tau_Pt_C)
           if self.DoMFT==1:
              tmpHulaMFTUp=Systematics.MFTup(tau_Pt_C,MET_tPtC,row.tPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(tmpHulaMFTUp[0],row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaMFTUp[3],0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaMFTUp[4],tmpHulaMFTUp[5])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              return(collMass_type1_new,m_t_Mass_new,tMtToPfMet_type1_new,tmpHulaMFTUp[0])
           if self.DoMFT==2:
              tmpHulaMFTDown=Systematics.MFTdown(tau_Pt_C,MET_tPtC,row.tPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(tmpHulaMFTDown[0],row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaMFTDown[3],0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaMFTDown[4],tmpHulaMFTDown[5])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              return(collMass_type1_new,m_t_Mass_new,tMtToPfMet_type1_new,tmpHulaMFTDown[0])
           if self.DoMFT==3: 
              taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(MET_tPtC,0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,MET_tPtC*math.cos(row.type1_pfMetPhi),MET_tPtC*math.sin(row.type1_pfMetPhi))
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              return(collMass_type1_new,m_t_Mass_new,tMtToPfMet_type1_new,tau_Pt_C)
           if self.DoMES==1:
              tmpHulaMESUp=Systematics.MESup(row.mPt,row.mEta,MET_tPtC,row.mPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(tmpHulaMESUp[0],row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaMESUp[3],0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaMESUp[4],tmpHulaMESUp[5])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              return(collMass_type1_new,m_t_Mass_new,tMtToPfMet_type1_new,tmpHulaMESUp[0])
           if self.DoMES==2:
              tmpHulaMESDown=Systematics.MESdown(row.mPt,row.mEta,MET_tPtC,row.mPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(tmpHulaMESDown[0],row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaMESDown[3],0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaMESDown[4],tmpHulaMESDown[5])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              return(collMass_type1_new,m_t_Mass_new,tMtToPfMet_type1_new,tmpHulaMESDown[0])
           if self.DoUES==1:
              if (not self.ls_DY) and row.tZTTGenMatching==5:
                 if  row.tDecayMode==0:
                     UES_shiftedMetup=row.type1_pfMet_shiftedPt_UnclusteredEnUp+0.018*row.tPt
                 if  row.tDecayMode==1:
                     UES_shiftedMetup=row.type1_pfMet_shiftedPt_UnclusteredEnUp-0.01*row.tPt
                 if  row.tDecayMode==10:
                     UES_shiftedMetup=row.type1_pfMet_shiftedPt_UnclusteredEnUp-0.004*row.tPt
              elif self.ls_DY and row.isZmumu  and row.tZTTGenMatching<5 and row.tDecayMode==1:
                    UES_shiftedMetup=row.type1_pfMet_shiftedPt_UnclusteredEnUp-0.015*row.tPt
              else: 
                    UES_shiftedMetup=row.type1_pfMet_shiftedPt_UnclusteredEnUp
              tmpHulaUESUp=Systematics.UESup(UES_shiftedMetup,row.type1_pfMet_shiftedPhi_UnclusteredEnUp)
              taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaUESUp[0],0,tmpHulaUESUp[3],0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaUESUp[1],tmpHulaUESUp[2])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              return(collMass_type1_new,m_t_Mass_new,tMtToPfMet_type1_new,tmpHulaUESUp[0])
           if self.DoUES==2 :
              if (not self.ls_DY) and row.tZTTGenMatching==5:
                 if  row.tDecayMode==0:
                     UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown+0.018*row.tPt
                 if  row.tDecayMode==1:
                     UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown-0.01*row.tPt
                 if  row.tDecayMode==10:
                     UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown-0.004*row.tPt
              elif self.ls_DY and  row.isZmumu  and row.tZTTGenMatching<5 and row.tDecayMode==1:
                    UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown-0.015*row.tPt
              else: 
                    UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown
              tmpHulaUESDown=Systematics.UESdown(UES_shiftedMetdown,row.type1_pfMet_shiftedPhi_UnclusteredEnDown)
              taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaUESDown[0],0,tmpHulaUESDown[3],0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaUESDown[1],tmpHulaUESDown[2])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              return(collMass_type1_new,m_t_Mass_new,tMtToPfMet_type1_new,tmpHulaUESDown[0])
# This function is also used in the JES shape systermatics variable calculation, the upward part of it is to recalculate the Jet energy scale systermatics after the Tau energy scale correction. We need to do it is because JES is calculated in the Ntuple steps, and TES correction required from Tau POG is a global correctoin which should be applied to all of the real Tau
    def VariableCalculateJES_UESsp(self,row,JESShiftedMet,JESShiftedPhi,tau_Pt_C):
           taulorenz=ROOT.TLorentzVector()
           muonlorenz=ROOT.TLorentzVector()             
           metlorenz=ROOT.TLorentzVector() 
           if not self.ls_DY and row.tZTTGenMatching==5:
              if  row.tDecayMode==0:
                  JESShiftedMet_new=JESShiftedMet+0.018*row.tPt
              if  row.tDecayMode==1:
                  JESShiftedMet_new=JESShiftedMet-0.01*row.tPt
              if  row.tDecayMode==10:
                  JESShiftedMet_new=JESShiftedMet-0.004*row.tPt

           elif self.ls_DY and row.isZmumu  and row.tZTTGenMatching<5 and row.tDecayMode==1:
                 JESShiftedMet_new=JESShiftedMet-0.015*row.tPt
           else: 
                 JESShiftedMet_new=JESShiftedMet
           tmpHulaJES=(JESShiftedMet_new,JESShiftedPhi)
           taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
           muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
           metlorenz.SetPtEtaPhiM(tmpHulaJES[0],0,tmpHulaJES[1],0)
           collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaJES[0]*math.cos(tmpHulaJES[1]),tmpHulaJES[0]*math.sin(tmpHulaJES[1]))
           tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
           return(collMass_type1_new,m_t_Mass_new,tMtToPfMet_type1_new) 
    def presel(self, row):
        if not (row.singleIsoMu24Pass or row.singleIsoTkMu24Pass):
            return   False
        return True 

    def selectZtt(self,row):
        if (self.is_ZTauTau and not row.isZtautau):
            return False
        if (not self.is_ZTauTau and row.isZtautau):
            return False
        return True
 
    def selectZmm(self,row):
        if (self.is_ZMuMu and not row.isZmumu):
            return False
        if (not self.is_ZMuMu and row.isZmumu):
            return False
        return True
# This function is to deal with the recombine with the number of Jets in the sample of W+jets and DY+jets
    def WeightJetbin(self,row):
        weighttargettmp=self.weighttarget
        if self.ls_Jets:
           if row.numGenJets>4:
              print "Error***********************Error***********"
           if self.ls_Wjets:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightNormal_MORE_S_WJ."+"WJetsToLNu_TuneCUETP8M1_13TeV_madgraphMLM_pythia8")) 
              else:
                 return 1.0/(eval("weightNormal_MORE_S_WJ."+"W"+str(int(row.numGenJets))+"JetsToLNu_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
           if self.ls_ZTauTau:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightNormal_MORE_S_WJ."+"ZTauTauJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8")) 
              else: 
                 return 1.0/(eval("weightNormal_MORE_S_WJ."+"ZTauTau"+str(int(row.numGenJets))+"JetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
           if self.ls_DY:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightNormal_MORE_S_WJ."+"DYJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8")) 
              else: 
                 return 1.0/(eval("weightNormal_MORE_S_WJ."+"DY"+str(int(row.numGenJets))+"JetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
        else:
              return 1.0/(eval("weightNormal_MORE_S_WJ."+self.weighttarget))
    def WjetsEnrich(self,row):
        if (self.tMtToPfMet_type1_new>60 and self.mMtToPfMet_type1_new>80):
            return True
        return False
    def ZttEnrich(self,row,m_t_Mass_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new):
        if ((m_t_Mass_new>40 and m_t_Mass_new<80) and mMtToPfMet_type1_new<60 and abs(row.mEta-row.tEta)<1.4) and tMtToPfMet_type1_new<90:
            return True
        return False
    def ZmmEnrich(self,row,m_t_Mass_new,mMtToPfMet_type1_new,type1_pfMetEt_new,tMtToPfMet_type1_new):
        if ((m_t_Mass_new>80 and m_t_Mass_new<100) and mMtToPfMet_type1_new<40 and type1_pfMetEt_new<60 and tMtToPfMet_type1_new<90 and abs(row.mEta-row.tEta)<1.4):
            return True
        return False
    def TTbarEnrich(self,row):
        if ((self.m_t_Mass_new>60)and row.m_t_PZetaLess0p85PZetaVis<-50):
            return True
        return False
    def kinematics(self, row):
        if self.DoMES==1  :
                 if row.mPt*1.002 < 26:
                    return False
        if self.DoMES==2  :
                 if row.mPt*0.998 < 26:
                    return False
        if not self.DoMES:
           if row.mPt< 26:
               return False
  
        if self.DoTES==1  :
           if self.tau_Pt_C*1.012 < 30:
               return False
        elif self.DoTES==2  :
           if self.tau_Pt_C*0.988 < 30:
               return False
        elif self.DoTES==3  :
           if self.tau_Pt_C < 30:
               return False
        if self.DoMFT==1  :
           if self.tau_Pt_C*1.015 < 30:
               return False
        elif self.DoMFT==2  :
           if self.tau_Pt_C*0.985 < 30:
               return False
        elif self.DoMFT==3  :
           if self.tau_Pt_C < 30:
               return False
        if (not self.DoTES) and (not self.DoMFT):
           if self.tau_Pt_C<30 :
               return False
        return True

    def kinematics_new(self, row):
        if abs(row.mEta) >= 2.4:
            return False
        if abs(row.tEta)>=2.3:
            return False
        return True
    def gg(self,row,MassPoint='def'):
        if not RUN_OPTIMIZATION_v2:
           if  MassPoint=='200' or  MassPoint=='300':
               if row.mPt < 60 or row.tPt<30 or row.tMtToPfMet_type1 >105:   #was45     #newcuts 25 
                return False 
           else  :
             if row.mPt < 165 or row.tPt<45  or row.tMtToPfMet_type1 >200:   #was45     #newcuts 25 
                return False 
   #     elif  MassPoint=='600':
   #       if row.mPt < 155 or row.tPt<65  or row.tMtToPfMet_type1 >100:   #was45     #newcuts 25 
   #          return False 
   #     elif  MassPoint=='750':
   #       if row.mPt < 190 or row.tPt<75 or row.tMtToPfMet_type1 >85:   #was45     #newcuts 25 
   #          return False 
   #     elif  MassPoint=='900':
   #       if row.mPt < 220 or row.tPt<90 or row.tMtToPfMet_type1 >85:   #was45     #newcuts 25 
   #          return False 
#           return False
        return True

    def boost(self,row,MassPoint='def'):
      #  if row.mPt < 26:   #was45     #newcuts 25 
      #       return False 
  #      if (MassPoint=='125') or (MassPoint=='def'):
  #        if row.mPt < 35 or row.tMtToPfMet_type1 >70 or row.tPt<35:   #was45     #newcuts 25 
  #           return False 
        if not RUN_OPTIMIZATION_v2:
           if  MassPoint=='200' or MassPoint=='300':
               if row.mPt < 60 or row.tPt<30 or row.tMtToPfMet_type1 >120:   #was45     #newcuts 25 
                   return False 
 #          elif  MassPoint=='300':
 #            if row.mPt < 75 or row.tPt<40  or row.tMtToPfMet_type1 >95:   #was45     #newcuts 25 
 #               return False 
           else :
             if row.mPt < 165 or row.tPt<45 or row.tMtToPfMet_type1 >230:   #was45     #newcuts 25 
                  return False 
 #       elif  MassPoint=='600':
 #         if row.mPt < 145 or row.tPt<65 or row.tMtToPfMet_type1 >130:   #was45     #newcuts 25 
 #            return False 
 #       elif  MassPoint=='750':
 #         if row.mPt < 180 or row.tPt<75 or row.tMtToPfMet_type1 >135:   #was45     #newcuts 25 
 #            return False 
 #       elif  MassPoint=='900':
 #         if row.mPt < 220 or row.tPt<85 or row.tMtToPfMet_type1 >150:   #was45     #newcuts 25 
 #            return False 
        return True

    def oppositesign(self,row):
	if row.mCharge*row.tCharge!=-1:
            return False
	return True
 
    def obj1_idICHEP(self,row):
   
        goodglob=row.mIsGlobal and row.mNormalizedChi2 < 3 and row.mChi2LocalPosition < 12 and row.mTrkKink < 20
        isICHEPMedium = row.mPFIDLoose and row.mValidFraction> 0.49 and row.mSegmentCompatibility >  (0.303 if goodglob else 0.451);
    	return isICHEPMedium
    def obj1_id(self,row):
        return row.mIsGlobal and row.mIsPFMuon and (row.mNormTrkChi2<10) and (row.mMuonHits > 0) and (row.mMatchedStations > 1) and (row.mPVDXY < 0.2) and (row.mPVDZ < 0.5) and (row.mPixHits > 0) and (row.mTkLayersWithMeasurement > 5)

    def obj1_idM(self,row):
   
        goodglob=row.mIsGlobal and row.mNormalizedChi2 < 3 and row.mChi2LocalPosition < 12 and row.mTrkKink < 20
        isICHEPMedium = row.mPFIDLoose and row.mValidFraction> 0.8 and row.mSegmentCompatibility >  (0.303 if goodglob else 0.451);
    	return isICHEPMedium
    def obj2_id(self, row):
	return  row.tAgainstElectronVLooseMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding

    def vetos(self,row):
		return  (bool (row.muVetoPt5IsoIdVtx<1) and bool (row.eVetoMVAIso<1) and bool (row.tauVetoPt20Loose3HitsVtx<1) )
    def obj1_iso(self,row):
         return bool(row.mRelPFIsoDBDefaultR04 <0.15)
    def obj1_isoloose(self,row):
         return bool(row.mRelPFIsoDBDefaultR04 <0.25)
    def SetsysZero(self,row):
        self.DoMES=0; self.DoTES=0; self.DoJES=0;self.DoUES=0;self.DoFakeshapeDM=0;self.DoMFT=0;self.DoUESsp=0;self.DoPileup=0
    def obj2_iso(self, row):
        return  row.tByTightIsolationMVArun2v1DBoldDMwLT
    def obj2_iso_NT_VLoose(self, row):
        return bool( (not row.tByTightIsolationMVArun2v1DBoldDMwLT) and  row.tByVLooseIsolationMVArun2v1DBoldDMwLT)
    def obj2_mediso(self, row):
	 return row.tByMediumIsolationMVArun2v1DBoldDMwLT

    def obj1_antiiso(self, row):
        return bool(row.mRelPFIsoDBDefaultR04 >0.2) 
    def obj2_Vlooseiso(self, row):
        return row.tByVLooseIsolationMVArun2v1DBoldDMwLT
    def obj2_newiso(self, row):
        return row.tByVVTightIsolationMVArun2v1DBoldDMwLT 



    def process(self):
        event =0
        sel=False
        for row in self.tree:
            if event!=row.evt:   # This is just to ensure we get the (Mu,Tau) with the highest Pt
                event=row.evt    # In principle the code saves all the MU+Tau posibilities, if an event has several combinations
                sel = False      # it will save them all.
            if sel==True:
                continue
            tmp_Sysin=self.Sysin
            self.Sysin=0
            if (not self.presel(row)) and self.is_data:
                  continue
            if not self.selectZtt(row):
                continue
            if not self.kinematics_new(row): 
                continue
            if not self.obj1_isoloose(row):
                continue
            if self.is_dataG_H or (not self.is_data):
               if not self.obj1_idM(row):
                   continue
            else:
               if not self.obj1_idICHEP(row):
                   continue
            if not self.vetos (row):
                continue
            if not self.obj2_Vlooseiso(row):
                continue
            if (self.is_data):
               if  row.bjetCISVVeto30Medium:
                   continue
            if not self.obj2_id (row):
                continue
            if self.ls_recoilC and MetCorrection: 
               self.MetCorrectionSet(row)
            normaldecayfanbo=0
            if ((int(round(row.tDecayMode)))==0) or ((int(round(row.tDecayMode)))==1) or ((int(round(row.tDecayMode)))==10):
               normaldecayfanbo=1
            if not normaldecayfanbo:
               continue
            self.SetsysZero(row)
            self.tau_Pt_C,self.MET_tPtC=self.TauESC(row)
            if self.kinematics(row):
               self.collMass_type1_new,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new=self.VariableCalculateTaucorrection(row,self.tau_Pt_C,self.MET_tPtC)
            self.Sysin=0
# The muon fake and muon-fake over lap fake part is not removed, for possible later checks
            if (fakeset or wjets_fakes or tuning) and self.kinematics(row):
             if self.obj1_iso(row):
               if self.obj2_iso(row) and not self.oppositesign(row):
                  if fakeset:
                     self.fill_histos(row,'preselectionSS')
                  if (not self.light_v2):
                     if row.jetVeto30==0:
                       if (not self.light):
                           self.fill_histos(row,'IsoSS0Jet')
                       if RUN_OPTIMIZATION_v2:
                          for  i in optimizer_new.compute_regions_0jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
                             tmp=os.path.join("ggIsoSS200",i)
                             self.fill_histos(row,tmp,False)
                          for  i in optimizer_new450.compute_regions_0jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
                             tmp=os.path.join("ggIsoSS450",i)
                             self.fill_histos(row,tmp,False)
                          for massname in self.highMass:
                              if self.gg(row,massname):
                                 self.fill_histos(row,'ggIsoSS'+massname,False)	
                     if row.jetVeto30==1:
                       if (not self.light):
                           self.fill_histos(row,'IsoSS1Jet')
                       if RUN_OPTIMIZATION_v2:
                          for  i in optimizer_new.compute_regions_1jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
                             tmp=os.path.join("boostIsoSS200",i)
                             self.fill_histos(row,tmp,False)
                          for  i in optimizer_new450.compute_regions_1jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
                             tmp=os.path.join("boostIsoSS450",i)
                             self.fill_histos(row,tmp,False)
                          for massname in self.highMass:
                              if self.gg(row,massname):
                                 self.fill_histos(row,'boostIsoSS'+massname,False)	
            if fakeset and self.kinematics(row):
             if self.obj1_iso(row):
               if not self.obj2_iso(row) and not self.oppositesign(row) :
                      self.fill_histos(row,'notIsoSS',True)
                      if (not self.light):
                         if row.jetVeto30==0:
                           self.fill_histos(row,'notIsoSS0Jet',True)
                         if row.jetVeto30==1:
                           self.fill_histos(row,'notIsoSS1Jet',True)
             if not self.obj1_iso(row):
               if  self.obj2_iso(row) and not self.oppositesign(row) :
                      self.fill_histos(row,'notIsoSSM',True,faketype="muonfake") 
                      if (not self.light):
                         if row.jetVeto30==0:
                           self.fill_histos(row,'notIsoSS0JetM',True,faketype="muonfake")
                         if row.jetVeto30==1:
                           self.fill_histos(row,'notIsoSS1JetM',True,faketype="muonfake")
             if not self.obj1_iso(row):
               if not self.obj2_iso(row) and not self.oppositesign(row) :
                      self.fill_histos(row,'notIsoSSMT',True,faketype="mtfake") 
                      if (not self.light):
                         if row.jetVeto30==0:
                           self.fill_histos(row,'notIsoSS0JetMT',True,faketype="mtfake")
                         if row.jetVeto30==1:
                           self.fill_histos(row,'notIsoSS1JetMT',True,faketype="mtfake")

            if self.obj2_iso(row) and self.oppositesign(row) and self.kinematics(row):  
             if self.obj1_iso(row):
                 if not self.light:
                    if  fakeset:
                       self.fill_histos(row,'preselection')
                       if self.WjetsEnrich(row):
                          self.fill_histos(row,'preslectionEnWjets')
                       if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                          self.fill_histos(row,'preslectionEnZtt')
                       if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                          self.fill_histos(row,'preslectionEnZmm')
                       if self.TTbarEnrich(row):
                          self.fill_histos(row,'preslectionEnTTbar')
                    if wjets_fakes:
                       self.fill_histos(row,'preselection')
                    if row.jetVeto30==0:
                      self.fill_histos(row,'preselection0Jet')
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'preslectionEnWjets0Jet')
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'preslectionEnZtt0Jet')
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'preslectionEnZmm0Jet')
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'preslectionEnTTbar0Jet')
         
                    if row.jetVeto30==1:
                      self.fill_histos(row,'preselection1Jet')
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'preslectionEnWjets1Jet')
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'preslectionEnZtt1Jet')
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'preslectionEnZmm1Jet')
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'preslectionEnTTbar1Jet')

                 if  row.jetVeto30==0:
                     if RUN_OPTIMIZATION_v2:
                        for  i in optimizer_new.compute_regions_0jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
   	                   tmp=os.path.join("gg200",i)
	                   self.fill_histos(row,tmp,False)
                        for  i in optimizer_new450.compute_regions_0jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
   	                   tmp=os.path.join("gg450",i)
	                   self.fill_histos(row,tmp,False)
                     for massname in self.highMass:
                         if self.gg(row,massname):
                            self.fill_histos(row,'gg'+massname,False)	
                 if row.jetVeto30==1:
                     if RUN_OPTIMIZATION_v2:
                        for  i in optimizer_new.compute_regions_1jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
	                   tmp=os.path.join("boost200",i)
	                   self.fill_histos(row,tmp,False)	
                        for  i in optimizer_new450.compute_regions_1jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
	                   tmp=os.path.join("boost450",i)
	                   self.fill_histos(row,tmp,False)	
                     for massname in self.highMass:
                         if self.boost(row,massname):
                            self.fill_histos(row,'boost'+massname,False)	
            if self.obj2_iso_NT_VLoose(row) and self.oppositesign(row) and self.kinematics(row):
              if self.obj1_iso(row):
                 if (not self.light):
                    if  fakeset:
                       self.fill_histos(row,'notIso',True)
                       if self.WjetsEnrich(row):
                          self.fill_histos(row,'notIsoEnWjets',True)
                       if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                          self.fill_histos(row,'notIsoEnZtt',True)
                       if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                          self.fill_histos(row,'notIsoEnZmm',True)
                       if self.TTbarEnrich(row):
                          self.fill_histos(row,'notIsoEnTTbar',True)

                    if row.jetVeto30==0:
                      self.fill_histos(row,'notIso0Jet',True)
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets0Jet',True)
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZtt0Jet',True)
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZmm0Jet',True)
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'notIsoEnTTbar0Jet',True)
                    if row.jetVeto30==1:
                      self.fill_histos(row,'notIso1Jet',True)
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets1Jet',True)
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZtt1Jet',True)
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZmm1Jet',True)
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'notIsoEnTTbar1Jet',True)
                 if  row.jetVeto30==0:
                     for massname in self.highMass:
                         if self.gg(row,massname):
                            self.fill_histos(row,'ggNotIso'+massname,True)
                 if row.jetVeto30==1:
                     for massname in self.highMass:
                         if self.boost(row,massname):
                           self.fill_histos(row,'boostNotIso'+massname,True)
            if self.obj2_iso_NT_VLoose(row) and self.oppositesign(row) and self.kinematics(row):
              if not self.obj1_iso(row):
                 if not self.light:
                    if fakeset:
                       self.fill_histos(row,'notIsoMT',True,faketype="mtfake")
                       if self.WjetsEnrich(row):
                          self.fill_histos(row,'notIsoEnWjetsMT',True,faketype="mtfake")
                       if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                          self.fill_histos(row,'notIsoEnZttMT',True,faketype="mtfake")
                       if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                          self.fill_histos(row,'notIsoEnZmmMT',True,faketype="mtfake")
                       if self.TTbarEnrich(row):
                          self.fill_histos(row,'notIsoEnTTbarMT',True,faketype="mtfake")

                    if row.jetVeto30==0:
                      self.fill_histos(row,'notIso0JetMT',True,faketype="mtfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets0JetMT',True,faketype="mtfake")
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZtt0JetMT',True,faketype="mtfake")
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZmm0JetMT',True,faketype="mtfake")
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'notIsoEnTTbar0JetMT',True,faketype="mtfake")
                    if row.jetVeto30==1:
                      self.fill_histos(row,'notIso1JetMT',True,faketype="mtfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets1JetMT',True,faketype="mtfake")
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZtt1JetMT',True,faketype="mtfake")
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZmm1JetMT',True,faketype="mtfake")
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'notIsoEnTTbar1JetMT',True,faketype="mtfake")
                 if  row.jetVeto30==0:
                     for massname in self.highMass:
                         if self.gg(row,massname):
                           self.fill_histos(row,'ggNotIsoMT'+massname,True,faketype="mtfake")
                 if row.jetVeto30==1:
                     for massname in self.highMass:
                         if self.boost(row,massname):
                           self.fill_histos(row,'boostNotIsoMT'+massname,True,faketype="mtfake")
            if self.obj2_iso(row) and self.oppositesign(row) and self.kinematics(row):
              if not self.obj1_iso(row):
                 if not self.light:
                    if fakeset:
                       self.fill_histos(row,'notIsoM',True,faketype="muonfake")
                       if self.WjetsEnrich(row):
                          self.fill_histos(row,'notIsoEnWjetsM',True,faketype="muonfake")
                       if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                          self.fill_histos(row,'notIsoEnZttM',True,faketype="muonfake")
                       if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                          self.fill_histos(row,'notIsoEnZmmM',True,faketype="muonfake")
                       if self.TTbarEnrich(row):
                          self.fill_histos(row,'notIsoEnTTbarM',True,faketype="muonfake")

                    if row.jetVeto30==0:
                      self.fill_histos(row,'notIso0JetM',True,faketype="muonfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets0JetM',True,faketype="muonfake")
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZtt0JetM',True,faketype="muonfake")
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZmm0JetM',True,faketype="muonfake")
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'notIsoEnTTbar0JetM',True,faketype="muonfake")
                    if row.jetVeto30==1:
                      self.fill_histos(row,'notIso1JetM',True,faketype="muonfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets1JetM',True,faketype="muonfake")
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZtt1JetM',True,faketype="muonfake")
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZmm1JetM',True,faketype="muonfake")
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'notIsoEnTTbar1JetM',True,faketype="muonfake")
                 if  row.jetVeto30==0:
                     for massname in self.highMass:
                         if self.gg(row,massname):
                           self.fill_histos(row,'ggNotIsoM'+massname,True,faketype="muonfake")
                 if row.jetVeto30==1:
                     for massname in self.highMass:
                         if self.boost(row,massname):
                           self.fill_histos(row,'boostNotIsoM'+massname,True,faketype="muonfake")
# starting from here, is to fill in the systermatic shape related histotrams
            self.Sysin=tmp_Sysin
            if self.Sysin:
                 sysneedI=['MES_13TeVUp','MES_13TeVDown']
                 sysneedTES=['scale_t_1prong_13TeVUp','scale_t_1prong_13TeVDown','scale_t_1prong1pizero_13TeVUp','scale_t_1prong1pizero_13TeVDown','scale_t_3prong_13TeVUp','scale_t_3prong_13TeVDown']
                 sysneedMFT=['scale_mfaketau_1prong1pizero_13TeVUp','scale_mfaketau_1prong1pizero_13TeVDown']
                 sysneedPileup=['Pileup_13TeVUp','Pileup_13TeVDown']
                 sysneedFAKES=['TauFakeRate_p0_dm0_B_13TeVUp','TauFakeRate_p0_dm0_B_13TeVDown','TauFakeRate_p1_dm0_B_13TeVUp','TauFakeRate_p1_dm0_B_13TeVDown','TauFakeRate_p0_dm1_B_13TeVUp','TauFakeRate_p0_dm1_B_13TeVDown','TauFakeRate_p1_dm1_B_13TeVUp','TauFakeRate_p1_dm1_B_13TeVDown','TauFakeRate_p0_dm10_B_13TeVUp','TauFakeRate_p0_dm10_B_13TeVDown','TauFakeRate_p1_dm10_B_13TeVUp','TauFakeRate_p1_dm10_B_13TeVDown','TauFakeRate_p0_dm0_E_13TeVUp','TauFakeRate_p0_dm0_E_13TeVDown','TauFakeRate_p1_dm0_E_13TeVUp','TauFakeRate_p1_dm0_E_13TeVDown','TauFakeRate_p0_dm1_E_13TeVUp','TauFakeRate_p0_dm1_E_13TeVDown','TauFakeRate_p1_dm1_E_13TeVUp','TauFakeRate_p1_dm1_E_13TeVDown','TauFakeRate_p0_dm10_E_13TeVUp','TauFakeRate_p0_dm10_E_13TeVDown','TauFakeRate_p1_dm10_E_13TeVUp','TauFakeRate_p1_dm10_E_13TeVDown']
                 basechannels_Fake=['ggNotIso','ggNotIsoM','ggNotIsoMT','boostNotIso','boostNotIsoM','boostNotIsoMT']
                 basechannelsI=[(0,'gg'),(1,'boost')]
                 basechannelsII=[(0,'ggNotIso'),(1,'boostNotIso')]
                 basechannelsIII=[(0,'ggNotIsoM'),(1,'boostNotIsoM')]
                 basechannelsIIII=[(0,'ggNotIsoMT'),(1,'boostNotIsoMT')]
                 baseJESsys=["Jes_JetAbsoluteFlavMap_13TeVDown","Jes_JetAbsoluteFlavMap_13TeVUp","Jes_JetAbsoluteMPFBias_13TeVDown","Jes_JetAbsoluteMPFBias_13TeVUp","Jes_JetAbsoluteScale_13TeVDown","Jes_JetAbsoluteScale_13TeVUp","Jes_JetAbsoluteStat_13TeVDown","Jes_JetAbsoluteStat_13TeVUp","Jes_JetFlavorQCD_13TeVDown","Jes_JetFlavorQCD_13TeVUp","Jes_JetFragmentation_13TeVDown","Jes_JetFragmentation_13TeVUp","Jes_JetPileUpDataMC_13TeVDown","Jes_JetPileUpDataMC_13TeVUp","Jes_JetPileUpPtBB_13TeVDown","Jes_JetPileUpPtBB_13TeVUp","Jes_JetPileUpPtEC1_13TeVDown","Jes_JetPileUpPtEC1_13TeVUp","Jes_JetPileUpPtEC2_13TeVDown","Jes_JetPileUpPtEC2_13TeVUp","Jes_JetPileUpPtHF_13TeVDown","Jes_JetPileUpPtHF_13TeVUp","Jes_JetPileUpPtRef_13TeVDown","Jes_JetPileUpPtRef_13TeVUp","Jes_JetRelativeBal_13TeVDown","Jes_JetRelativeBal_13TeVUp","Jes_JetRelativeFSR_13TeVDown","Jes_JetRelativeFSR_13TeVUp","Jes_JetRelativeJEREC1_13TeVDown","Jes_JetRelativeJEREC1_13TeVUp","Jes_JetRelativeJEREC2_13TeVDown","Jes_JetRelativeJEREC2_13TeVUp","Jes_JetRelativeJERHF_13TeVDown","Jes_JetRelativeJERHF_13TeVUp","Jes_JetRelativePtBB_13TeVDown","Jes_JetRelativePtBB_13TeVUp","Jes_JetRelativePtEC1_13TeVDown","Jes_JetRelativePtEC1_13TeVUp","Jes_JetRelativePtEC2_13TeVDown","Jes_JetRelativePtEC2_13TeVUp","Jes_JetRelativePtHF_13TeVDown","Jes_JetRelativePtHF_13TeVUp","Jes_JetRelativeStatEC_13TeVDown","Jes_JetRelativeStatEC_13TeVUp","Jes_JetRelativeStatFSR_13TeVDown","Jes_JetRelativeStatFSR_13TeVUp","Jes_JetRelativeStatHF_13TeVDown","Jes_JetRelativeStatHF_13TeVUp","Jes_JetSinglePionECAL_13TeVDown","Jes_JetSinglePionECAL_13TeVUp","Jes_JetSinglePionHCAL_13TeVDown","Jes_JetSinglePionHCAL_13TeVUp","Jes_JetTimePtEta_13TeVDown","Jes_JetTimePtEta_13TeVUp"]
                 baseUESsp=['MET_chargedUes_13TeVUp','MET_chargedUes_13TeVDown','MET_ecalUes_13TeVUp','MET_ecalUes_13TeVDown','MET_hfUes_13TeVUp','MET_hfUes_13TeVDown','MET_hcalUes_13TeVUp','MET_hcalUes_13TeVDown']


                 DMinstring=str(int(round(row.tDecayMode))) 
                 for M in sysneedFAKES:
                     self.SetsysZero(row)
                     tmpname='self.DoFakeshapeDM'
                     if 'p0' in M:
                        Para='1'
                     elif 'p1' in M:
                        Para='2'
                     if 'Up' in M and (M.split('dm',1)[1]).split('_',2)[0]==DMinstring:
                        if ('B' in M) and (abs(row.tEta)<1.479):
                           valuehere='2017'+DMinstring+Para+'1'+'1'
                           exec("%s = %d" % (tmpname,int(valuehere)))                   
                        elif 'E' in M and (abs(row.tEta)>1.479):
                           valuehere='2017'+DMinstring+Para+'1'+'2'
                           exec("%s = %d" % (tmpname,int(valuehere)))       
                        else:
                           exec("%s = %d" % (tmpname,20170000))            
                     elif 'Down' in M and (M.split('dm',1)[1]).split('_',2)[0]==DMinstring:
                        if 'B' in M and (abs(row.tEta)<1.479):
                           valuehere='2017'+DMinstring+Para+'2'+'1'
                           exec("%s = %d" % (tmpname,int(valuehere)))                   
                        elif 'E' in M and (abs(row.tEta)>1.479):
                           valuehere='2017'+DMinstring+Para+'2'+'2'
                           exec("%s = %d" % (tmpname,int(valuehere)))                  
                        else:
                           exec("%s = %d" % (tmpname,20170000))                   
                     else:
                        exec("%s = %d" % (tmpname,20170000))                   
                     if (not self.obj2_iso(row)) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                        for j in basechannelsII: 
                           if  row.jetVeto30==j[0]:
                               tmpname_2='self.'+j[1].split('Not',1)[0]+'(row)'
                               if eval(tmpname_2):
                                    self.fill_histos(row,j[1]+M,True)
                     if self.obj2_iso(row) and self.oppositesign(row) and (not self.obj1_iso(row)) and self.kinematics(row): 
                        for j in basechannelsIII: 
                           if  row.jetVeto30==j[0]:
                               tmpname_2='self.'+j[1].split('Not',1)[0]+'(row)'
                               if eval(tmpname_2):
                                    self.fill_histos(row,j[1]+M,True,faketype="muonfake")
                     if (not self.obj2_iso(row)) and self.oppositesign(row) and (not self.obj1_iso(row)) and self.kinematics(row): 
                        for j in basechannelsIIII: 
                           if  row.jetVeto30==j[0]:
                               tmpname_2='self.'+j[1].split('Not',1)[0]+'(row)'
                               if eval(tmpname_2):
                                    self.fill_histos(row,j[1]+M,True,faketype="mtfake")
     
            if self.Sysin and (not self.is_data):

                 for i in sysneedPileup:
                     self.SetsysZero(row)
                     tmpname='self.DoPileup'
                     if 'Up' in i:
                        exec("%s = %d" % (tmpname,1))
                     if 'Down' in i:
                        exec("%s = %d" % (tmpname,2))
                     if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row):
                        for j in basechannelsI: 
                           if  row.jetVeto30==j[0]:
                               tmpname_2='self.'+j[1]+'(row)'
                               if eval(tmpname_2):
                                    self.fill_histos(row,j[1]+i,False)
                 for i in sysneedI:
                     self.SetsysZero(row)
                     if 'Up' in i:
                        tmpname='self.Do'+i.split('_13TeV',1)[0]
                        exec("%s = %d" % (tmpname,1))                      
                     if 'Down' in i:
                        tmpname='self.Do'+i.split('_13TeV',1)[0]
                        exec("%s = %d" % (tmpname,2))                   
                     if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                        self.collMass_type1_new,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.MorTPtshifted=self.VariableCalculate(row,self.tau_Pt_C,self.MET_tPtC)
                        for j in basechannelsI: 
                           if  row.jetVeto30==j[0]:
                               tmpname_2='self.'+j[1]+'(row)'
                               if eval(tmpname_2):
                                    self.fill_histos(row,j[1]+i,False)
                 for k in baseJESsys:
                     self.SetsysZero(row)
                     if 'Up' in k:
                        tmpname='self.DoJES'
                        exec("%s = %d" % (tmpname,1))                      
                     elif 'Down' in k:
                        tmpname='self.DoJES'
                        exec("%s = %d" % (tmpname,2))                 
                     tmpJesvar=k.split('Jes_',1)[1].split('_13TeV',1)[0]
                     tmpJesvarUD=k.split('Jes_',1)[1].split('_13TeV',1)[1]
                     tmpname_3='row.jetVeto30_'+tmpJesvar+tmpJesvarUD
                     tmpname_5='row.type1_pfMet_shiftedPt_'+tmpJesvar+tmpJesvarUD
                     tmpname_6='row.type1_pfMet_shiftedPhi_'+tmpJesvar+tmpJesvarUD
                     if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                        self.collMass_type1_new,self.m_t_Mass_new,self.tMtToPfMet_type1_new=self.VariableCalculateJES_UESsp(row,eval(tmpname_5),eval(tmpname_6),self.tau_Pt_C)
                        for j in basechannelsI: 
                           if  eval(tmpname_3)==j[0]:
                               tmpname_2='self.'+j[1]+'(row)'
                               if  eval(tmpname_2):
                                       self.fill_histos(row,j[1]+k,False)
                 for k in baseUESsp:
                     self.SetsysZero(row)
                     if 'Up' in k:
                        tmpname='self.DoUESsp'
                        exec("%s = %d" % (tmpname,1))                      
                     if 'Down' in k:
                        tmpname='self.DoUESsp'
                        exec("%s = %d" % (tmpname,2))                   
                     if 'Up' in k:
                         tmpname_5='row.type1_pfMet_shiftedPt_'+k.split('_',2)[1].upper()+'Up' 
                         tmpname_6='row.type1_pfMet_shiftedPhi_'+k.split('_',2)[1].upper()+'Up' 
                     if 'Down' in k:
                         tmpname_5='row.type1_pfMet_shiftedPt_'+k.split('_',2)[1].upper()+'Down' 
                         tmpname_6='row.type1_pfMet_shiftedPhi_'+k.split('_',2)[1].upper()+'Down' 
                     if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                        self.collMass_type1_new,self.m_t_Mass_new,self.tMtToPfMet_type1_new=self.VariableCalculateJES_UESsp(row,eval(tmpname_5),eval(tmpname_6),self.tau_Pt_C)
                        for j in basechannelsI: 
                           if  row.jetVeto30==j[0]:
                               tmpname_2='self.'+j[1]+'(row)'
                               if  eval(tmpname_2):
                                   self.fill_histos(row,j[1]+k,False)
                 if not self.ls_DY:
                    for L in sysneedTES:
                        self.SetsysZero(row)
                        tmpname='self.DoTES'
                        if row.tZTTGenMatching==5:
                           if '1prong1pizero' in L:
                               DMinSys='1'
                           elif '3prong' in L:
                               DMinSys='10'
                           else:
                               DMinSys='0'
                           if 'Up' in L and DMinSys==DMinstring:
                              exec("%s = %d" % (tmpname,1))                   
                           elif 'Down' in L and DMinSys==DMinstring:
                              exec("%s = %d" % (tmpname,2))                   
                           else:
                              exec("%s = %d" % (tmpname,3))                  
                        else:
                              exec("%s = %d" % (tmpname,3)) 
                        if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                           self.collMass_type1_new,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.MorTPtshifted=self.VariableCalculate(row,self.tau_Pt_C,self.MET_tPtC)
                           for j in basechannelsI: 
                              if  row.jetVeto30==j[0]:
                                  tmpname_2='self.'+j[1]+'(row)'
                                  if eval(tmpname_2):
                                       self.fill_histos(row,j[1]+L,False)
                 if self.ls_DY:
                    for L in sysneedMFT:
                        self.SetsysZero(row)
                        tmpname='self.DoMFT'
                        if row.isZmumu  and row.tZTTGenMatching<5 and row.tDecayMode==1:
                           if 'Up' in L:
                              exec("%s = %d" % (tmpname,1))                   
                           elif 'Down' in L:
                              exec("%s = %d" % (tmpname,2))                   
                        else:
                           exec("%s = %d" % (tmpname,3))                   
                        if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                           self.collMass_type1_new,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.MorTPtshifted=self.VariableCalculate(row,self.tau_Pt_C,self.MET_tPtC)
                           for j in basechannelsI: 
                              if  row.jetVeto30==j[0]:
                                  tmpname_2='self.'+j[1]+'(row)'
                                  if eval(tmpname_2):
                                       self.fill_histos(row,j[1]+L,False)
            self.SetsysZero(row)
            sel=True

    def finish(self):
        self.write_histos()
