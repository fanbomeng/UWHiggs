'''

Run LFV H->MuMuMu analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW, FANBO MENG, ND

'''

import MuMuMuTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
#import FinalStateAnalysis.TagAndProbe.H2TauCorrections as H2TauCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import ROOT
import math
import weightMuMuTauNew 
import bTagSFrereco
from math import sqrt, pi
fakeRate=False
btagSys=0
#data=bool ('true' in os.environ['isRealData'])
#ZTauTau = bool('true' in os.environ['isZTauTau'])
#ZeroJet = bool('true' in os.environ['isInclusive'])
#systematic = os.environ['systematic']

def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
      return PHI
  else:
      return 2*pi-PHI

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

def getFakeRateFactorFANBOPt(row, fakeset):
     if fakeset=="def":
        if  row.tDecayMode==0:
            fTauIso=0.22362
        if  row.tDecayMode==1:
            fTauIso=0.218989
        if  row.tDecayMode==10:
            fTauIso=0.186646
     if fakeset=="1stUp":
        if  row.tDecayMode==0:
            fTauIso=0.22362+0.00685
        if  row.tDecayMode==1:
            fTauIso=0.218989+0.00392
        if  row.tDecayMode==10:
            fTauIso=0.186646+0.00416
     if fakeset=="1stDown":
        if  row.tDecayMode==0:
            fTauIso=0.21753-0.00685
        if  row.tDecayMode==1:
            fTauIso=0.218989-0.00392
        if  row.tDecayMode==10:
            fTauIso=0.186646-0.00416
     fakeRateFactor = fTauIso/(1.0-fTauIso)
     return fakeRateFactor

def getFakeRateFactormuonabsEta(row, fakeset):   #old
     if fakeset=="def":
          fTauIso=0.825162
     if fakeset=="1stUp":
        fTauIso=0.825162+0.013674
     if fakeset=="1stDown":
        fTauIso=0.825162-0.013674
     fakeRateFactor = fTauIso/(1.0-fTauIso)
     return fakeRateFactor

def getFakeRateFactor(row, fakeset):
  if fakeset=="def":
     fTauIso= 0.2089 - 0.00113*(row.tPt-30)
  if fakeset=="1stUp":
     fTauIso= 0.212105 - 0.00111905*(row.tPt-30)
  if fakeset=="1stDown":
     fTauIso= 0.205715  - 0.00113831*(row.tPt-30)
  if fakeset=="2ndUp":
     fTauIso= 0.20891  - 0.00088892*(row.tPt-30)
  if fakeset=="2ndDown":
     fTauIso= 0.208909  - 0.00136844*(row.tPt-30)
  fakeRateFactor = fTauIso/(1.0-fTauIso)
  return fakeRateFactor
################################################################################
#### MC-DATA and PU corrections ################################################
################################################################################
pu_distributions = glob.glob(os.path.join(
#    'inputs', os.environ['jobid'], 'data_TauPlusX*pu.root'))
        'inputs', os.environ['jobid'], 'data_SingleMu*pu.root'))
#pu_corrector = PileupWeight.PileupWeight('MC_Spring16', *pu_distributions)
pu_corrector = PileupWeight.PileupWeight('MC_Moriond17', *pu_distributions)
#muon_pog_PFTight_2016 = MuonPOGCorrections.make_muon_pog_PFTight_2016BCD()
#muon_pog_PFTight_2016 = MuonPOGCorrections.make_muon_pog_PFMedium_2016BCD()
muon_pog_PFTight_2016 = MuonPOGCorrections.make_muon_pog_PFMedium_2016ReReco()
#muon_pog_TightIso_2016 = MuonPOGCorrections.make_muon_pog_TightIso_2016BCD()
muon_pog_TightIso_2016 = MuonPOGCorrections.make_muon_pog_TightIso_2016ReReco('Medium')
#muon_pog_IsoMu22oIsoTkMu22_2016 = MuonPOGCorrections.make_muon_pog_IsoMu22oIsoTkMu22_2016BCD()
muon_pog_IsoMu24oIsoTkMu24_2016 = MuonPOGCorrections.make_muon_pog_IsoMu24oIsoTkMu24_2016ReReco()
muon_pog_LooseIso_2016 = MuonPOGCorrections.make_muon_pog_LooseIso_2016ReReco('Medium')

def mc_corrector_2016TT(row):
  pu = pu_corrector(row.nTruePU)
  m1tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m1Eta))[0]
  m2tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m2Eta))[0]
  m3tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m3Eta))[0]
  m1id = muon_pog_PFTight_2016(row.m1Pt,abs(row.m1Eta))
  m1iso = muon_pog_TightIso_2016(row.m1Pt,abs(row.m1Eta))
  m1_trg = muon_pog_IsoMu24oIsoTkMu24_2016(row.m1Pt,abs(row.m1Eta))
#  m1tracking =MuonPOGCorrections.mu_trackingEta_2016(row.m1Eta)[0]
  m2id = muon_pog_PFTight_2016(row.m2Pt,abs(row.m2Eta))
  m2iso = muon_pog_TightIso_2016(row.m2Pt,abs(row.m2Eta))
#  m2tracking =MuonPOGCorrections.mu_trackingEta_2016(row.m2Eta)[0]
 # m2_trg = muon_pog_IsoMu22oIsoTkMu22_2016(row.m2Pt,abs(row.m2Eta))
  m3id = muon_pog_PFTight_2016(row.m3Pt,abs(row.m3Eta))
  m3iso = muon_pog_TightIso_2016(row.m3Pt,abs(row.m3Eta))
#  m3tracking =MuonPOGCorrections.mu_trackingEta_2016(row.m3Eta)[0]
 # m3_trg = muon_pog_IsoMu22oIsoTkMu22_2016(row.m3Pt,abs(row.m3Eta))

  #print "pu"
  #print str(pu)
  return pu*m1id*m1iso*m1_trg*m2id*m2iso*m3id*m3iso*m1tracking*m2tracking*m3tracking



def mc_corrector_2016LT(row):
  pu = pu_corrector(row.nTruePU)
  m1tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m1Eta))[0]
  m2tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m2Eta))[0]
  m3tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m3Eta))[0]
  m1id = muon_pog_PFTight_2016(row.m1Pt,abs(row.m1Eta))
  m1iso = muon_pog_LooseIso_2016(row.m1Pt,abs(row.m1Eta))
  m1_trg = muon_pog_IsoMu24oIsoTkMu24_2016(row.m1Pt,abs(row.m1Eta))
#  m1tracking =MuonPOGCorrections.mu_trackingEta_2016(row.m1Eta)[0]
  m2id = muon_pog_PFTight_2016(row.m2Pt,abs(row.m2Eta))
  m2iso = muon_pog_LooseIso_2016(row.m2Pt,abs(row.m2Eta))
#  m2tracking =MuonPOGCorrections.mu_trackingEta_2016(row.m2Eta)[0]
 # m2_trg = muon_pog_IsoMu22oIsoTkMu22_2016(row.m2Pt,abs(row.m2Eta))
  m3id = muon_pog_PFTight_2016(row.m3Pt,abs(row.m3Eta))
  m3iso = muon_pog_TightIso_2016(row.m3Pt,abs(row.m3Eta))
#  m3tracking =MuonPOGCorrections.mu_trackingEta_2016(row.m3Eta)[0]
 # m3_trg = muon_pog_IsoMu22oIsoTkMu22_2016(row.m3Pt,abs(row.m3Eta))

  #print "pu"
  #print str(pu)
  return pu*m1id*m1iso*m1_trg*m2id*m2iso*m3id*m3iso*m1tracking*m2tracking*m3tracking



def mc_corrector_2016TL(row):
  pu = pu_corrector(row.nTruePU)

  m1tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m1Eta))[0]
  m2tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m2Eta))[0]
  m3tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m3Eta))[0]
  m1id = muon_pog_PFTight_2016(row.m1Pt,abs(row.m1Eta))
#  m1iso = muon_pog_TightIso_2016(row.m1Pt,abs(row.m1Eta))
  m1iso = muon_pog_TightIso_2016(row.m1Pt,abs(row.m1Eta))
  m1_trg = muon_pog_IsoMu24oIsoTkMu24_2016(row.m1Pt,abs(row.m1Eta))
  #m1tracking =MuonPOGCorrections.mu_trackingEta_2016(row.m1Eta)[0]
  m2id = muon_pog_PFTight_2016(row.m2Pt,abs(row.m2Eta))
  #m2iso = muon_pog_TightIso_2016(row.m2Pt,abs(row.m2Eta))
#  m2iso = muon_pog_TightIso_2016(row.m2Pt,abs(row.m2Eta))
  m2iso = muon_pog_TightIso_2016(row.m2Pt,abs(row.m2Eta))
  #m2tracking =MuonPOGCorrections.mu_trackingEta_2016(row.m2Eta)[0]
 # m2_trg = muon_pog_IsoMu22oIsoTkMu22_2016(row.m2Pt,abs(row.m2Eta))
  m3id = muon_pog_PFTight_2016(row.m3Pt,abs(row.m3Eta))
  m3iso = muon_pog_LooseIso_2016(row.m3Pt,abs(row.m3Eta))
  #m3tracking =MuonPOGCorrections.mu_trackingEta_2016(row.m3Eta)[0]
 # m3_trg = muon_pog_IsoMu22oIsoTkMu22_2016(row.m3Pt,abs(row.m3Eta))

  #print "pu"
  #print str(pu)
  return pu*m1id*m1iso*m1_trg*m2id*m2iso*m3id*m3iso*m1tracking*m2tracking*m3tracking


def mc_corrector_2016LL(row):
  pu = pu_corrector(row.nTruePU)

  m1tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m1Eta))[0]
  m2tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m2Eta))[0]
  m3tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m3Eta))[0]
  m1id = muon_pog_PFTight_2016(row.m1Pt,abs(row.m1Eta))
  m1iso = muon_pog_LooseIso_2016(row.m1Pt,abs(row.m1Eta))
  m1_trg = muon_pog_IsoMu24oIsoTkMu24_2016(row.m1Pt,abs(row.m1Eta))
  #m1tracking =MuonPOGCorrections.mu_trackingEta_2016(row.m1Eta)[0]
  m2id = muon_pog_PFTight_2016(row.m2Pt,abs(row.m2Eta))
  m2iso = muon_pog_LooseIso_2016(row.m2Pt,abs(row.m2Eta))
  #m2tracking =MuonPOGCorrections.mu_trackingEta_2016(row.m2Eta)[0]
 # m2_trg = muon_pog_IsoMu22oIsoTkMu22_2016(row.m2Pt,abs(row.m2Eta))
  m3id = muon_pog_PFTight_2016(row.m3Pt,abs(row.m3Eta))
  m3iso = muon_pog_LooseIso_2016(row.m3Pt,abs(row.m3Eta))
  #m3tracking =MuonPOGCorrections.mu_trackingEta_2016(row.m3Eta)[0]
 # m3_trg = muon_pog_IsoMu22oIsoTkMu22_2016(row.m3Pt,abs(row.m3Eta))

  #print "pu"
  #print str(pu)
  return pu*m1id*m1iso*m1_trg*m2id*m2iso*m3id*m3iso*m1tracking*m2tracking*m3tracking
mc_correctorTT = mc_corrector_2016TT
mc_correctorLT = mc_corrector_2016LT
mc_correctorTL = mc_corrector_2016TL
mc_correctorLL = mc_corrector_2016LL

class AnalyzeLFVMuMuMu(MegaBase):
    tree = 'mmm/final/Ntuple'
    #tree = 'New_Tree'

    def __init__(self, tree, outfile, **kwargs):
        super(AnalyzeLFVMuMuMu, self).__init__(tree, outfile, **kwargs)
        target = os.path.basename(os.environ['megatarget'])
        self.weighttarget=target.split(".",1)[0].replace("-","_")
        self.ls_Jets=('Jets' in target)
        self.ls_Wjets=("JetsToLNu" in target)
        self.ls_ZTauTau=("ZTauTau" in target)
        self.ls_DY=("DY" in target)
        self.is_dataG_H =(bool('Run2016H' in target) or bool('Run2016G' in target))
        self.is_data = target.startswith('data_')
        self.is_ZeroJet=(('WJetsToLNu' in target)or('DYJetsToLL' in target)or('ZTauTauJetsToLL' in target))
        self.is_OneJet=('W1JetsToLNu' in target or('DY1JetsToLL' in target)or('ZTauTau1JetsToLL' in target))
        self.is_TwoJet=('W2JetsToLNu' in target or('DY2JetsToLL' in target)or('ZTauTau2JetsToLL' in target))
        self.is_ThreeJet=('W3JetsToLNu' in target or('DY3JetsToLL' in target)or('ZTauTau3JetsToLL' in target))
        self.is_FourJet=('W4JetsToLNu' in target or('DY4JetsToLL' in target)or('ZTauTau4JetsToLL' in target))
        self.is_embedded = ('Embedded' in target)
        self.is_ZTauTau= ('ZTauTau' in target)
        self.is_ZMuMu= ('Zmumu' in target)
        self.is_DY= ('DY' in target)
        self.is_HToTauTau= ('HToTauTau' in target)
        self.is_HToMuTau= ('HToMuTau' in target)
        self.is_mc = not (self.is_data or self.is_embedded)
        # Use the cython wrapper
        self.tree = MuMuMuTree.MuMuMuTree(tree)
        self.out = outfile
        self.histograms = {}
       # if self.ls_DY or self.ls_ZTauTau:
       #    self.Z_reweight = ROOT.TFile.Open('zpt_weights_2016.root')
       #    self.Z_reweight_H=self.Z_reweight.Get('zptmass_histo')

    def begin(self):

        names=["preselectionNextraIso","preselection","preselectionLooseIso","preselectionSS","preselectionLooseIsoSS","preselectionVLooseIso","preselectionlargerange","preselectionLooseIsolargerange","preselectionVLooseIsolargerange","preselectionlargerange0p3iso","preselectionLooseIsolargerange0p3iso","preselectionVLooseIsolargerange0p3iso","preselection0p3iso","preselectionLooseIso0p3iso","preselectionVLooseIso0p3iso"]
        namesize = len(names)
	for x in range(0,namesize):


#            self.book(names[x], "weight", "Event weight", 100, 0, 5)
#            self.book(names[x], "GenWeight", "Gen level weight", 200000 ,-1000000, 1000000)
#            self.book(names[x], "genHTT", "genHTT", 1000 ,0,1000)
# 
#            self.book(names[x], "rho", "Fastjet #rho", 100, 0, 25)
#            self.book(names[x], "nvtx", "Number of vertices", 100, -0.5, 100.5)
#            self.book(names[x], "prescale", "HLT prescale", 21, -0.5, 20.5)
#
#            self.book(names[x], "m1Pt", "Muon  Pt", 300,0,300)
#            self.book(names[x], "m1Eta", "Muon  eta", 100, -2.5, 2.5)
#            self.book(names[x], "m1Charge", "Muon Charge", 5, -2, 2)
#            self.book(names[x], "m2Pt", "Muon  Pt", 300,0,300)
#            self.book(names[x], "m2Eta", "Muon  eta", 100, -2.5, 2.5)
#            self.book(names[x], "m2Charge", "Muon Charge", 5, -2, 2)
            self.book(names[x], "m3Pt", "Muon  Pt", 1000,0,1000)
            self.book(names[x], "m3Eta", "Muon  eta", 100, -2.5, 2.5)
            self.book(names[x], "m3Etaabs", "Muon  eta", 50,0, 2.5)
            self.book(names[x], "m1RelPFIsoDBDefaultR04", "Muon1  Iso", 5000,0,50)
            self.book(names[x], "m2RelPFIsoDBDefaultR04", "Muon2  Iso", 5000,0,50)
            self.book(names[x], "m3RelPFIsoDBDefaultR04", "Muon3  Iso", 5000,0,50)
#            self.book(names[x], "m3Charge", "Muon Charge", 5, -2, 2)
#
#
#            self.book(names[x], 'm1PixHits', 'Mu 1 pix hits', 10, -0.5, 9.5)
#            self.book(names[x], 'm1JetBtag', 'Mu 1 JetBtag', 100, -5.5, 9.5)
#            self.book(names[x], 'm2PixHits', 'Mu 2 pix hits', 10, -0.5, 9.5)
#            self.book(names[x], 'm2JetBtag', 'Mu 2 JetBtag', 100, -5.5, 9.5)
#            self.book(names[x], 'm3PixHits', 'Mu 3 pix hits', 10, -0.5, 9.5)
#            self.book(names[x], 'm3JetBtag', 'Mu 3 JetBtag', 100, -5.5, 9.5)
#
#    	  
#    	    self.book(names[x], "LT", "ht", 400, 0, 400)
#            self.book(names[x], "type1_pfMetEt", "Type1 MET", 200, 0, 200)
#    
#            self.book(names[x], "m1_m3_Mass", "Muon + Muon3 Mass", 200, 0, 200)
#            self.book(names[x], "m1_m3_Pt", "Muon + Muon3 Pt", 200, 0, 200)
#            self.book(names[x], "m1_m3_DR", "Muon + Muon3 DR", 100, 0, 10)
#            self.book(names[x], "m1_m3_DPhi", "Muon + Muon3 DPhi", 100, 0, 4)
#            self.book(names[x], "m1_m3_SS", "Muon + Muon3 SS", 5, -2, 2)
#            self.book(names[x], "m1_m3_ToMETDPhi_Ty1", "Muon Tau DPhi to MET", 100, 0, 4)
#            self.book(names[x], "m2_m3_Mass", "Muon + Muon3 Mass", 200, 0, 200)
#            self.book(names[x], "m2_m3_Pt", "Muon + Muon3 Pt", 200, 0, 200)
#            self.book(names[x], "m2_m3_DR", "Muon + Muon3 DR", 100, 0, 10)
#            self.book(names[x], "m2_m3_DPhi", "Muon + Muon3 DPhi", 100, 0, 4)
#            self.book(names[x], "m2_m3_SS", "Muon + Muon3 SS", 5, -2, 2)
#            self.book(names[x], "m2_m3_ToMETDPhi_Ty1", "Muon Tau DPhi to MET", 100, 0, 4)
            self.book(names[x], "m1_m2_Mass", "Dimuon Mass", 200, 0, 200)
#    
#            # Vetoes
#            self.book(names[x], 'muVetoPt5IsoIdVtx', 'Number of extra muons', 5, -0.5, 4.5)
#	    self.book(names[x], 'muVetoPt15IsoIdVtx', 'Number of extra muons', 5, -0.5, 4.5)
#            self.book(names[x], 'tauVetoPt20Loose3HitsVtx', 'Number of extra taus', 5, -0.5, 4.5)
#            self.book(names[x], 'eVetoMVAIso', 'Number of extra CiC tight electrons', 5, -0.5, 4.5)
#   
#            self.book(names[x], 'jetVeto30', 'Number of extra jets', 5, -0.5, 4.5)	
##            self.book(names[x], 'jetVeto30ZTT', 'Number of extra jets', 5, -0.5, 4.5)
##            self.book(names[x], 'jetVeto30Eta3', 'Number of extra jets within |eta| < 3', 5, -0.5, 4.5)
#	    #Isolation
#	    self.book(names[x], 'm1RelPFIsoDBDefault' ,'Muon Isolation', 100, 0.0,1.0)
#            self.book(names[x], 'm2RelPFIsoDBDefault' ,'Muon Isolation', 100, 0.0,1.0)
#            self.book(names[x], 'm3RelPFIsoDBDefault' ,'Muon Isolation', 100, 0.0,1.0)
#   
# 
#            self.book(names[x], "m1Phim3Phi", "", 100, 0,4)
#            self.book(names[x], "m2Phim3Phi", "", 100, 0,4)
#            self.book(names[x], "m1PhiMETPhiType1", "", 100, 0,4)
#            self.book(names[x], "m2PhiMETPhiType1", "", 100, 0,4)
#            self.book(names[x], "m3PhiMETPhiType1", "", 100, 0,4)
#
#### vbf ###
#            self.book(names[x], "vbfJetVeto30", "central jet veto for vbf", 5, -0.5, 4.5)
#	    self.book(names[x], "vbfJetVeto20", "", 5, -0.5, 4.5)
#	    self.book(names[x], "vbfMVA", "", 100, 0,0.5)
#	    self.book(names[x], "vbfMass", "", 500,0,5000.0)
#	    self.book(names[x], "vbfDeta", "", 100, -0.5,10.0)
##            self.book(names[x], "vbfMassZTT", "", 500,0,5000.0)
##            self.book(names[x], "vbfDetaZTT", "", 100, -0.5,10.0)
#            self.book(names[x], "vbfj1eta","",100,-2.5,2.5)
#	    self.book(names[x], "vbfj2eta","",100,-2.5,2.5)
#	    self.book(names[x], "vbfVispt","",100,0,200)
#	    self.book(names[x], "vbfHrap","",100,0,5.0)
#	    self.book(names[x], "vbfDijetrap","",100,0,5.0)
#	    self.book(names[x], "vbfDphihj","",100,0,4)
##            self.book(names[x], "vbfDphihjnomet","",100,0,4)
#            self.book(names[x], "vbfNJets", "g", 5, -0.5, 4.5)
            #self.book(names[x], "vbfNJetsPULoose", "g", 5, -0.5, 4.5)
            #self.book(names[x], "vbfNJetsPUTight", "g", 5, -0.5, 4.5)

    def correctionT(self,row):
	return mc_correctorTT(row)
    def correctionL(self,row):
	return mc_correctorTL(row)
	
    def fakeRateMethod(self,row,isoName):
        return getFakeRateFactor(row,isoName)
    def fill_histos(self, row,name='gg', fakeRate=False, isoName="old"):
        histos = self.histograms
        weight=1
        if (not(self.is_data)):
           #weight = row.GenWeight * self.correction(row)*bTagSF.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)*self.WeightJetbin(row)
           #weight = row.GenWeight * self.correction(row)*self.WeightJetbin(row)*bTagSF.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)#*self.WeightJetbin(row)
           #weight = row.GenWeight * self.correction(row)*self.WeightJetbin(row)*bTagSF.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)#*self.WeightJetbin(row)
           if "Loose" in name:
               weight = row.GenWeight * self.correctionL(row)*self.WeightJetbin(row)*bTagSFrereco.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)
           else:
               weight = row.GenWeight * self.correctionT(row)*self.WeightJetbin(row)*bTagSFrereco.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)
       # if (not(data)):
	#   weight = row.GenWeight * self.correction(row) #apply gen and pu reweighting to MC
      #  if (self.is_DY and row.isZmumu  and row.tZTTGenMatching<5):
      #    weight=weight*getGenMfakeTSF(abs(row.tEta))
        if (fakeRate == True):
          weight=weight*self.fakeRateMethod(row,isoName) #apply fakerate method for given isolation definition
#        if self.ls_DY or self.ls_ZTauTau:
#           wtzpt=self.Z_reweight_H.GetBinContent(self.Z_reweight_H.GetXaxis().FindBin(row.genM),self.Z_reweight_H.GetYaxis().FindBin(row.genpT))
#           weight=weight*wtzpt

  #      histos[name+'/weight'].Fill(weight)
  #      histos[name+'/GenWeight'].Fill(row.GenWeight)
  #      histos[name+'/genHTT'].Fill(row.genHTT)
  #      histos[name+'/rho'].Fill(row.rho, weight)
  #      histos[name+'/nvtx'].Fill(row.nvtx, weight)
  #      histos[name+'/prescale'].Fill(row.doubleMuPrescale, weight)

  #      
  #      histos[name+'/m1Pt'].Fill(row.m1Pt, weight)
  #      histos[name+'/m1Eta'].Fill(row.m1Eta, weight)
  #      histos[name+'/m1Charge'].Fill(row.m1Charge, weight)
  #      histos[name+'/m2Pt'].Fill(row.m2Pt, weight)
  #      histos[name+'/m2Eta'].Fill(row.m2Eta, weight)
  #      histos[name+'/m2Charge'].Fill(row.m2Charge, weight)
        histos[name+'/m1RelPFIsoDBDefaultR04'].Fill(row.m1RelPFIsoDBDefaultR04, weight)
        histos[name+'/m2RelPFIsoDBDefaultR04'].Fill(row.m2RelPFIsoDBDefaultR04, weight)
        histos[name+'/m3RelPFIsoDBDefaultR04'].Fill(row.m3RelPFIsoDBDefaultR04, weight)
        histos[name+'/m3Pt'].Fill(row.m3Pt, weight)
        histos[name+'/m3Eta'].Fill(row.m3Eta, weight)
        histos[name+'/m3Etaabs'].Fill(abs(row.m3Eta), weight)
        histos[name+'/m1_m2_Mass'].Fill(row.m1_m2_Mass,weight)
  #      histos[name+'/m3Charge'].Fill(row.m3Charge, weight)


  #      histos[name+'/LT'].Fill(row.LT,weight)


  #      histos[name+'/type1_pfMetEt'].Fill(row.type1_pfMetEt,weight)

  #      histos[name+'/m1_m3_Mass'].Fill(row.m1_m3_Mass,weight)
  #      histos[name+'/m1_m3_Pt'].Fill(row.m1_m3_Pt,weight)
  #      histos[name+'/m1_m3_DR'].Fill(row.m1_m3_DR,weight)
  #      histos[name+'/m1_m3_DPhi'].Fill(row.m1_m3_DPhi,weight)
  #      histos[name+'/m1_m3_SS'].Fill(row.m1_m3_SS,weight)
  #      histos[name+'/m2_m3_Mass'].Fill(row.m2_m3_Mass,weight)
  #      histos[name+'/m2_m3_Pt'].Fill(row.m2_m3_Pt,weight)
  #      histos[name+'/m2_m3_DR'].Fill(row.m2_m3_DR,weight)
  #      histos[name+'/m2_m3_DPhi'].Fill(row.m2_m3_DPhi,weight)
  #      histos[name+'/m2_m3_SS'].Fill(row.m2_m3_SS,weight)
  #      #histos[name+'/m_t_ToMETDPhi_Ty1'].Fill(row.m_t_ToMETDPhi_Ty1,weight)

  #      histos[name+'/m1PixHits'].Fill(row.m1PixHits, weight)
  #      histos[name+'/m1JetBtag'].Fill(row.m1JetBtag, weight)
  #      histos[name+'/m2PixHits'].Fill(row.m2PixHits, weight)
  #      histos[name+'/m2JetBtag'].Fill(row.m2JetBtag, weight)
  #      histos[name+'/m3PixHits'].Fill(row.m3PixHits, weight)
  #      histos[name+'/m3JetBtag'].Fill(row.m3JetBtag, weight)

  #      histos[name+'/muVetoPt5IsoIdVtx'].Fill(row.muVetoPt5IsoIdVtx, weight)
  #      histos[name+'/muVetoPt15IsoIdVtx'].Fill(row.muVetoPt15IsoIdVtx, weight)
  #      histos[name+'/tauVetoPt20Loose3HitsVtx'].Fill(row.tauVetoPt20Loose3HitsVtx, weight)
  #      histos[name+'/eVetoMVAIso'].Fill(row.eVetoMVAIso, weight)
  #      histos[name+'/jetVeto30'].Fill(row.jetVeto30, weight)
#	histos[name+'/jetVeto30ZTT'].Fill(row.jetVeto30ZTT,weight)
        #histos[name+'/jetVeto30Eta3'].Fill(row.jetVeto30Eta3,weight)
        #histos[name+'/jetVeto30PUCleanedLoose'].Fill(row.jetVeto30PUCleanedLoose, weight)
        #histos[name+'/jetVeto30PUCleanedTight'].Fill(row.jetVeto30PUCleanedTight, weight)

#	histos[name+'/m1RelPFIsoDBDefault'].Fill(row.m1RelPFIsoDBDefault, weight)
#        histos[name+'/m2RelPFIsoDBDefault'].Fill(row.m2RelPFIsoDBDefault, weight)
#        histos[name+'/m3RelPFIsoDBDefault'].Fill(row.m3RelPFIsoDBDefault, weight)
#        
#	histos[name+'/m1Phim3Phi'].Fill(deltaPhi(row.m1Phi,row.m3Phi),weight)
#        histos[name+'/m1PhiMETPhiType1'].Fill(deltaPhi(row.m1Phi,row.type1_pfMetPhi),weight)
#        histos[name+'/m2Phim3Phi'].Fill(deltaPhi(row.m2Phi,row.m3Phi),weight)
#        histos[name+'/m2PhiMETPhiType1'].Fill(deltaPhi(row.m2Phi,row.type1_pfMetPhi),weight)
#        histos[name+'/m3PhiMETPhiType1'].Fill(deltaPhi(row.m3Phi,row.type1_pfMetPhi),weight)
#	histos[name+'/vbfJetVeto30'].Fill(row.vbfJetVeto30, weight)
#     	#histos[name+'/vbfJetVeto20'].Fill(row.vbfJetVeto20, weight)
#        #histos[name+'/vbfMVA'].Fill(row.vbfMVA, weight)
#        histos[name+'/vbfMass'].Fill(row.vbfMass, weight)
#        histos[name+'/vbfDeta'].Fill(row.vbfDeta, weight)
#        histos[name+'/vbfMassZTT'].Fill(row.vbfMassZTT, weight)
#        histos[name+'/vbfDetaZTT'].Fill(row.vbfDetaZTT, weight)
        #histos[name+'/vbfj1eta'].Fill(row.vbfj1eta, weight)
        #histos[name+'/vbfj2eta'].Fill(row.vbfj2eta, weight)
        #histos[name+'/vbfVispt'].Fill(row.vbfVispt, weight)
        #histos[name+'/vbfHrap'].Fill(row.vbfHrap, weight)
        #histos[name+'/vbfDijetrap'].Fill(row.vbfDijetrap, weight)
        #histos[name+'/vbfDphihj'].Fill(row.vbfDphihj, weight)
        #histos[name+'/vbfDphihjnomet'].Fill(row.vbfDphihjnomet, weight)
#        histos[name+'/vbfNJets'].Fill(row.vbfNJets, weight)
        #histos[name+'/vbfNJetsPULoose'].Fill(row.vbfNJetsPULoose, weight)
        #histos[name+'/vbfNJetsPUTight'].Fill(row.vbfNJetsPUTight, weight)




    def presel(self, row):
        if not (row.singleIsoMu24Pass or row.singleIsoTkMu24Pass):
            return False
        return True

    def selectZtt(self,row):
        if (ZTauTau and not row.isZtautau):
            return False
        if (not ZTauTau and row.isZtautau):
            return False
        return True
 
#    def selectZeroJet(self,row):
#	if (ZeroJet and row.NUP != 5):
#            return False
#	return True

    def kinematics(self, row):
        if row.m1Pt < 26:
            return False
        if abs(row.m1Eta) >= 2.4:
            return False
        if row.m2Pt < 26:
            return False
        if abs(row.m2Eta) >= 2.4:
            return False
        if row.m3Pt<26:
            return False
        if abs(row.m3Eta)>=2.4:
            return False
        return True


    def oppositesign(self,row):
	if row.m1Charge*row.m2Charge!=-1:
            return False
	return True
    def WeightJetbin(self,row):
        weighttargettmp=self.weighttarget
        if self.ls_Jets:
           if row.numGenJets>4:
              print "Error***********************Error***********"
           if self.ls_Wjets:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightMuMuTauNew."+"WJetsToLNu_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
              else:
                 return 1.0/(eval("weightMuMuTauNew."+"W"+str(int(row.numGenJets))+"JetsToLNu_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
           if self.ls_ZTauTau:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightMuMuTauNew."+"ZTauTauJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
              else:
                 return 1.0/(eval("weightMuMuTauNew."+"ZTauTau"+str(int(row.numGenJets))+"JetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
           if self.ls_DY:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightMuMuTauNew."+"DYJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
              else:
                 return 1.0/(eval("weightMuMuTauNew."+"DY"+str(int(row.numGenJets))+"JetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
        else:
              return 1.0/(eval("weightMuMuTauNew."+self.weighttarget))
    #def obj1_id(self, row):
    #    return bool(row.mPFIDTight)  
#    def obj1_id(self,row):
#        return row.m1IsGlobal and row.m1IsPFMuon and (row.m1NormTrkChi2<10) and (row.m1MuonHits > 0) and (row.m1MatchedStations > 1) and (row.m1PVDXY < 0.02) and (row.m1PVDZ < 0.5) and (row.m1PixHits > 0) and (row.m1TkLayersWithMeasurement > 5) and row.m2IsGlobal and row.m2IsPFMuon and (row.m2NormTrkChi2<10) and (row.m2MuonHits > 0) and (row.m2MatchedStations > 1) and (row.m2PVDXY < 0.02) and (row.m2PVDZ < 0.5) and (row.m2PixHits > 0) and (row.m2TkLayersWithMeasurement > 5)
    def obj1_idICHEP(self,row):
	 if (row.m1IsGlobal and (row.m1NormalizedChi2 < 3) and (row.m1Chi2LocalPosition < 12) and (row.m1TrkKink < 20)):
		goodGlobal1=True
	 else:
		goodGlobal1=False
         if (row.m2IsGlobal and (row.m2NormalizedChi2 < 3) and (row.m2Chi2LocalPosition < 12) and (row.m2TrkKink < 20)):
                goodGlobal2=True
         else:
                goodGlobal2=False
         if (row.m3IsGlobal and (row.m3NormalizedChi2 < 3) and (row.m3Chi2LocalPosition < 12) and (row.m3TrkKink < 20)):
                goodGlobal3=True
         else:
                goodGlobal3=False
    	 return ((row.m1PFIDLoose and row.m1ValidFraction > 0.49 and ((goodGlobal1 and row.m1SegmentCompatibility > 0.303) or row.m1SegmentCompatibility > 0.451)) and (row.m2PFIDLoose and row.m2ValidFraction > 0.49 and ((goodGlobal2 and row.m2SegmentCompatibility > 0.303) or row.m2SegmentCompatibility > 0.451)) and(row.m3PFIDLoose and row.m3ValidFraction > 0.49 and ((goodGlobal3 and row.m3SegmentCompatibility > 0.303) or row.m3SegmentCompatibility > 0.451)))

    def obj1_idM(self,row):
	 if (row.m1IsGlobal and (row.m1NormalizedChi2 < 3) and (row.m1Chi2LocalPosition < 12) and (row.m1TrkKink < 20)):
		goodGlobal1=True
	 else:
		goodGlobal1=False
         if (row.m2IsGlobal and (row.m2NormalizedChi2 < 3) and (row.m2Chi2LocalPosition < 12) and (row.m2TrkKink < 20)):
                goodGlobal2=True
         else:
                goodGlobal2=False
         if (row.m3IsGlobal and (row.m3NormalizedChi2 < 3) and (row.m3Chi2LocalPosition < 12) and (row.m3TrkKink < 20)):
                goodGlobal3=True
         else:
                goodGlobal3=False
    	 return ((row.m1PFIDLoose and row.m1ValidFraction > 0.8 and ((goodGlobal1 and row.m1SegmentCompatibility > 0.303) or row.m1SegmentCompatibility > 0.451)) and (row.m2PFIDLoose and row.m2ValidFraction > 0.8 and ((goodGlobal2 and row.m2SegmentCompatibility > 0.303) or row.m2SegmentCompatibility > 0.451)) and(row.m3PFIDLoose and row.m3ValidFraction > 0.8 and ((goodGlobal3 and row.m3SegmentCompatibility > 0.303) or row.m3SegmentCompatibility > 0.451)))

    def m1m2Mass(self,row):
        if row.m1_m2_Mass < 76:
           return False
        if row.m1_m2_Mass > 106:
           return False
        return True
    def m1m2Masslarge(self,row):
        if row.m1_m2_Mass < 71:
           return False
        if row.m1_m2_Mass > 111:
           return False
        return True
#    def obj2_id(self,row):
#        return row.m3IsGlobal and row.m3IsPFMuon and (row.m3NormTrkChi2<10) and (row.m3MuonHits > 0) and (row.m3MatchedStations > 1) and (row.m3PVDXY < 0.02) and (row.m3PVDZ < 0.5) and (row.m3PixHits > 0) and (row.m3TkLayersWithMeasurement > 5)
#    def obj2_id_ICHEP(self, row):
#         if (row.m3IsGlobal and (row.m3NormalizedChi2 < 3) and (row.m3Chi2LocalPosition < 12) and (row.m3TrkKink < 20)):
#                goodGlobal3=True
#         else:
#                goodGlobal3=False
#         return row.m3PFIDLoose and row.m3ValidFraction > 0.49 and ((goodGlobal3 and row.m3SegmentCompatibility > 0.303) or row.m3SegmentCompatibility > 0.451)
    def vetos(self,row):
                return  (bool (row.muVetoPt5IsoIdVtx<1) and bool (row.eVetoMVAIso<1) and bool (row.tauVetoPt20Loose3HitsVtx<1) )
#                if row.muVetoPt5IsoIdVtx: return False
#		if row.eVetoMVAIso : return False
#		if row.tauVetoPt20Loose3HitsVtx: return False
#		return True
                #return  (bool (row.muVetoPt5IsoIdVtx<1) and bool (row.eVetoMVAIso<1) and bool (row.tauVetoPt20Loose3HitsVtx<1) )
#    def vetos(self,row):
#		return  ((row.eVetoZTTp001dxyzR0 == 0) and (row.muVetoZTTp001dxyzR0 < 4) and (row.tauVetoPt20Loose3HitsVtx<1) and (row.dimuonVeto==1))

    #def obj1_iso(self, row):
    #    return bool(row.mRelPFIsoDBDefault <0.12)
   
    def obj1_iso(self,row):
         return bool(row.m1RelPFIsoDBDefaultR04 <0.15 and row.m2RelPFIsoDBDefaultR04 <0.15)

    def obj1_isolarge(self,row):
         return bool(row.m1RelPFIsoDBDefaultR04 <0.30 and row.m2RelPFIsoDBDefaultR04 <0.30)
    def obj2_iso(self,row):
         return bool(row.m3RelPFIsoDBDefaultR04 < 0.15)


    def obj2_looseiso(self,row):
         return bool(row.m3RelPFIsoDBDefaultR04 < 0.25)
    def obj2_vlooseiso(self,row):
         return bool(row.m3RelPFIsoDBDefaultR04 < 1.0)



    def process(self):
        event =0
        sel=False
        for row in self.tree:
            if event!=row.evt:   # This is just to ensure we get the (Mu,Tau) with the highest Pt
                event=row.evt    # In principle the code saves all the MU+Tau posibilities, if an event has several combinations
                sel = False      # it will save them all.
            if sel==True:
                continue

            if not self.presel(row): #only apply trigger selections for data
                continue
            self.fill_histos(row,'preselectionNextraIso',False)
#            if not self.selectZtt(row):
#                continue

            if not self.kinematics(row): 
                continue
 
            #if not self.obj1_iso(row):
            #    continue
            if not self.obj1_isolarge(row):
                continue
#            if not self.obj1_idICHEP(row):
#                continue
            if self.is_dataG_H or (not self.is_data):
#              print self.target1 
#              print "the bool valueGH %d" %(self.is_dataG_H or (not self.is_data))
               if not self.obj1_idM(row):
                   continue
            else:
#               print self.target1 
#               print "the bool value %d" %(self.is_dataG_H or (not self.is_data))
               if not self.obj1_idICHEP(row):
                   continue
            #if not self.obj1_id(row):
            #    continue
            if not self.vetos(row):
                continue
            #if not self.m1m2Mass (row):
            #    continue
            if not self.m1m2Masslarge(row):
                continue

            #if not self.obj2_id (row):
            #    continue
#            if not self.obj2_id_ICHEP (row):
#                continue
            if (self.is_data):
               if  row.bjetCISVVeto30Medium:
                   continue

            if self.obj2_iso(row) and self.oppositesign(row):  
 
              self.fill_histos(row,'preselectionlargerange0p3iso',False)
 
            if self.obj2_looseiso(row) and self.oppositesign(row):
              self.fill_histos(row,'preselectionLooseIsolargerange0p3iso',False)

            if self.obj2_vlooseiso(row) and self.oppositesign(row):
              self.fill_histos(row,'preselectionVLooseIsolargerange0p3iso',False)
            
           

            if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row):  
 
              self.fill_histos(row,'preselectionlargerange',False)
 
            if self.obj2_looseiso(row) and self.oppositesign(row) and self.obj1_iso(row):
              self.fill_histos(row,'preselectionLooseIsolargerange',False)

            if self.obj2_vlooseiso(row) and self.oppositesign(row) and self.obj1_iso(row):
              self.fill_histos(row,'preselectionVLooseIsolargerange',False)


            if not self.m1m2Mass(row):
               continue 

            if self.obj2_iso(row) and self.oppositesign(row):  
 
              self.fill_histos(row,'preselection0p3iso',False)
 
            if self.obj2_looseiso(row) and self.oppositesign(row):
              self.fill_histos(row,'preselectionLooseIso0p3iso',False)

            if self.obj2_vlooseiso(row) and self.oppositesign(row):
              self.fill_histos(row,'preselectionVLooseIso0p3iso',False)
            
            if not self.obj1_iso(row):
               continue 

            if self.obj2_iso(row) and self.oppositesign(row):  
 
              self.fill_histos(row,'preselection',False)
 
            if self.obj2_looseiso(row) and self.oppositesign(row):
              self.fill_histos(row,'preselectionLooseIso',False)
            
            if self.obj2_iso(row) and (not self.oppositesign(row)):  
 
              self.fill_histos(row,'preselectionSS',False)
 
            if self.obj2_looseiso(row) and (not self.oppositesign(row)):
              self.fill_histos(row,'preselectionLooseIsoSS',False)

            if self.obj2_vlooseiso(row) and self.oppositesign(row):
              self.fill_histos(row,'preselectionVLooseIso',False)


            sel=True

    def finish(self):
        self.write_histos()
