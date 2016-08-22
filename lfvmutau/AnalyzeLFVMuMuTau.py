'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import MuMuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
#import FinalStateAnalysis.TagAndProbe.H2TauCorrections as H2TauCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import ROOT
import math
#import optimizer
#import optimizerdetastudy
from math import sqrt, pi
import itertools

#data=bool ('true' in os.environ['isRealData'])
#RUN_OPTIMIZATION=bool ('true' in os.environ['RUN_OPTIMIZATION'])
#RUN_OPTIMIZATION=True
#RUN_OPTIMIZATION=True
RUN_OPTIMIZATION=False
#ZTauTau = bool('true' in os.environ['isZTauTau'])
#ZeroJet = bool('true' in os.environ['isInclusive'])
#ZeroJet = False
#systematic = os.environ['systematic']
systematic = 'none'

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
	full_et=met+mupt+taupt # for muon and tau I am approximating pt~et (M<<P)
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

def collMass_type1(row,sys='none'):
        taupx=row.tPt*math.cos(row.tPhi)
        taupy=row.tPt*math.sin(row.tPhi)
	metE = row.type1_pfMetEt
	metPhi = row.type1_pfMetPhi
        metpx = metE*math.cos(metPhi)
        metpy = metE*math.sin(metPhi)
        met = sqrt(metpx*metpx+metpy*metpy)

        METproj= abs(metpx*taupx+metpy*taupy)/row.tPt

        xth=row.tPt/(row.tPt+METproj)
        den=math.sqrt(xth)

        mass=row.m_t_Mass/den

        #print '%4.2f, %4.2f, %4.2f, %4.2f, %4.2f' %(scaleMass(row), den, xth, METproj,mass)


        return mass


def getFakeRateFactor(row, isoName):
  if (isoName == "old"):
    if (row.tEta < 1.5):
      if (row.tDecayMode==0):
        fTauIso = 0.390
      elif (row.tDecayMode==1):
        fTauIso = 0.433
      elif (row.tDecayMode==10):
        fTauIso = 0.357
    if (row.tEta >= 1.5):
      if (row.tDecayMode==0):
        fTauIso = 0.409
      elif (row.tDecayMode==1):
        fTauIso = 0.447
      elif (row.tDecayMode==10):
        fTauIso = 0.352
  
  #if (row.tDecayMode==0):
  #  fTauIso = 0.389
  #elif (row.tDecayMode==1):
  #  fTauIso = 0.447
  #elif (row.tDecayMode==10):
  #  fTauIso = 0.353
  fakeRateFactor = fTauIso/(1.0-fTauIso)
  return fakeRateFactor
################################################################################
#### MC-DATA and PU corrections ################################################
################################################################################
pu_distributions = glob.glob(os.path.join(
#    'inputs', os.environ['jobid'], 'data_TauPlusX*pu.root'))
        'inputs', os.environ['jobid'], 'data_SingleMu*pu.root'))
#pu_corrector = PileupWeight.PileupWeight('25ns_matchData', *pu_distributions)
pu_corrector = PileupWeight.PileupWeight('MC_Spring16', *pu_distributions)

muon_HTauTau_TriggerIso22_2016B= MuonPOGCorrections.make_muon_HTauTau_TriggerIso22_2016B()
muon_pog_TriggerIso22_2016B= MuonPOGCorrections.make_muon_pog_TriggerEfficency_2016B()
muon_pog_PFTight_2016B = MuonPOGCorrections.make_muon_pog_PFTight_2016B()
muon_pog_Tracking_2016B = MuonPOGCorrections.make_muon_pog_Tracking_2016B()
#muon_pog_TightIso_2016B = MuonPOGCorrections.make_muon_pog_TightIso_2016B()
muon_pog_TightIso_2016B = MuonPOGCorrections.make_muon_pog_TightIso_DEN_ID_2016B()
muon_pog_IsoMu20oIsoTkMu20_2015 = MuonPOGCorrections.make_muon_pog_IsoMu20oIsoTkMu20_2015()

def mc_corrector_2016(row):
  pu = pu_corrector(row.nTruePU)

  m1id =muon_pog_PFTight_2016B(row.m1Pt,abs(row.m1Eta))
  m1tracking =muon_pog_Tracking_2016B(row.m1Eta)
  m_trgiso22=muon_pog_TriggerIso22_2016B(row.m1Pt,abs(row.m1Eta))
#  m1iso =muon_pog_TightIso_2016B(row.mPt,abs(row.mEta))
  m1iso =muon_pog_TightIso_2016B(row.m1Pt,abs(row.m1Eta))
  return pu*m1id*m1iso*m1tracking*m_trgiso22
#  return pu*m1id**m1tracking*m_trgiso22
 # return pu*m1id*m1iso
 # return m1id*m1iso*m_trg

mc_corrector = mc_corrector_2016

class AnalyzeLFVMuMuTau(MegaBase):
    tree = 'mmt/final/Ntuple'
    #tree = 'New_Tree'

    def __init__(self, tree, outfile, **kwargs):
        super(AnalyzeLFVMuMuTau, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        target = os.path.basename(os.environ['megatarget'])
      #  print "the target is ***********    %s"    %target
        self.is_data = target.startswith('data_')
     #   print "*************"
     #   print self.is_data
        self.is_ZeroJet=(('WJetsToLNu' in target)or('DYJetsToLL' in target)or('ZTauTauJetsToLL' in target))
        self.is_OneJet=('W1JetsToLNu' in target or('DY1JetsToLL' in target)or('ZTauTau1JetsToLL' in target))
        self.is_TwoJet=('W2JetsToLNu' in target or('DY2JetsToLL' in target)or('ZTauTau2JetsToLL' in target))
        self.is_ThreeJet=('W3JetsToLNu' in target or('DY3JetsToLL' in target)or('ZTauTau3JetsToLL' in target))
        self.is_FourJet=('W4JetsToLNu' in target or('DY4JetsToLL' in target)or('ZTauTau4JetsToLL' in target))
        self.is_embedded = ('Embedded' in target)
        self.is_ZTauTau= ('ZTauTau' in target)
        self.is_mc = not (self.is_data or self.is_embedded)
        self.tree = MuMuTauTree.MuMuTauTree(tree)
      #  self.tree = MuTauTree.MuTauTree(tree)
        self.out = outfile
        self.histograms = {}

    def begin(self):

        #names=["oldisotight","oldisoloose","oldisogg","oldisoboost","oldisovbf", "oldisoloosegg","oldisolooseboost","oldisoloosevbf",
         #     "newisotight","newisoloose","newisogg","newisoboost","newisovbf",  "newisoloosegg","newisolooseboost","newisoloosevbf",
          #    "noisogg","noisoboost","noisovbf",
          #    "noTauID","noiso"]
        names=["looseOldIso","medOldIso","tightOldIso","VlooseNewIso","looseNewIso","VVtightNewIso","VtightNewIso","tightNewIso","looseNewIsoNewDMs","tightNewIsoNewDMs", "looseOldIsoEndcap","medOldIsoEndcap","tightOldIsoEndcap","VlooseNewIsoEndcap","looseNewIsoEndcap","VVtightNewIsoEndcap","VtightNewIsoEndcap","tightNewIsoEndcap","looseNewIsoNewDMsEndcap","tightNewIsoNewDMsEndcap", "looseOldIsoBarrel","medOldIsoBarrel","tightOldIsoBarrel","VlooseNewIsoBarrel","looseNewIsoBarrel","VVtightNewIsoBarrel","VtightNewIsoBarrel","tightNewIsoBarrel","looseNewIsoNewDMsBarrel","tightNewIsoNewDMsBarrel"]
        namesize = len(names)
	for x in range(0,namesize):


            self.book(names[x], "weight", "Event weight", 100, 0, 5)
            self.book(names[x], "counts", "Event counts", 10, 0, 5)
            self.book(names[x], "GenWeight", "Gen level weight", 200000 ,-1000000, 1000000)
            self.book(names[x], "genHTT", "genHTT", 1000 ,0,1000)
            self.book(names[x], "singleIsoMu22Pass", "singleIsoMu22Pass", 12 ,-0.1,1.1)
            self.book(names[x], "singleIsoTkMu22Pass", "singleIsoTkMu22Pass", 12 ,-0.1,1.1)
            self.book(names[x], "rho", "Fastjet #rho", 100, 0, 25)
           # self.book(names[x], "nvtx", "Number of vertices", 100, -0.5, 100.5)
            self.book(names[x], "nvtx", "Number of vertices", 20, -0.5, 100.5)
            self.book(names[x], "prescale", "HLT prescale", 21, -0.5, 20.5)

   
  #          self.book(names[x], "jet1Pt", "", 300,0,300)
  #          self.book(names[x], "jet2Pt", "", 300,0,300)
  #          self.book(names[x], "jet3Pt", "", 300,0,300)
  #          self.book(names[x], "jet4Pt", "", 300,0,300)
  #          self.book(names[x], "jet5Pt", "", 300,0,300)


  #          self.book(names[x], "jet1Eta", "", 200,-5,5)
  #          self.book(names[x], "jet2Eta", "", 200,-5,5)
  #          self.book(names[x], "jet3Eta", "", 200,-5,5)
  #          self.book(names[x], "jet4Eta", "", 200,-5,5)
  #          self.book(names[x], "jet5Eta", "", 200,-5,5)

  #          self.book(names[x], "jet1Phi", "", 280,-7,7)
  #          self.book(names[x], "jet2Phi", "", 280,-7,7)
  #          self.book(names[x], "jet3Phi", "", 280,-7,7)
  #          self.book(names[x], "jet4Phi", "", 280,-7,7)
  #          self.book(names[x], "jet5Phi", "", 280,-7,7)
 
            #self.book(names[x], "mPt", "Muon  Pt", 300,0,300)
            #self.book(names[x], "mEta", "Muon  eta", 100, -2.5, 2.5)
            self.book(names[x], "m1Pt", "Muon  Pt", 300,0,300)
            self.book(names[x], "m1Eta", "Muon  eta", 100, -2.5, 2.5)
            self.book(names[x], "m2Pt", "Muon  Pt", 300,0,300)
            self.book(names[x], "m2Eta", "Muon  eta", 100, -2.5, 2.5)
            #self.book(names[x], "mMtToPfMet_Ty1", "Muon MT (PF Ty1)", 200, 0, 200)
            #self.book(names[x], "mCharge", "Muon Charge", 5, -2, 2)
            self.book(names[x], "m2Charge", "Muon Charge", 5, -2, 2)
            self.book(names[x], "m1Charge", "Muon Charge", 5, -2, 2)

            self.book(names[x], "tPt", "Tau  Pt", 300,0,300)
            self.book(names[x], "tEta", "Tau  eta", 100, -2.5, 2.5)
            self.book(names[x], "tPhi", "tPhi", 100 ,-3.4,3.4)
            self.book(names[x], "tMtToPfMet_type1", "Tau MT (PF Ty1)", 200, 0, 200)
            self.book(names[x], "tCharge", "Tau  Charge", 5, -2, 2)
	    self.book(names[x], "tJetPt", "Tau Jet Pt" , 500, 0 ,500)	    
            self.book(names[x], "tMass", "Tau  Mass", 1000, 0, 10)
            self.book(names[x], "tLeadTrackPt", "Tau  LeadTrackPt", 300,0,300)
            self.book(names[x], "tDPhiToPfMet_type1", "tDPhiToPfMet_type1", 100, 0, 4)

		       
            #self.book(names[x], "tAgainstElectronLoose", "tAgainstElectronLoose", 2,-0.5,1.5)
##            self.book(names[x], "tAgainstElectronLooseMVA5", "tAgainstElectronLooseMVA5", 2,-0.5,1.5) #same for other tAgainstE
            self.book(names[x], "tAgainstElectronLooseMVA6", "tAgainstElectronLooseMVA6", 2,-0.5,1.5)
            #self.book(names[x], "tAgainstElectronMedium", "tAgainstElectronMedium", 2,-0.5,1.5)
            self.book(names[x], "tAgainstElectronMediumMVA6", "tAgainstElectronMediumMVA6", 2,-0.5,1.5)
            #self.book(names[x], "tAgainstElectronTight", "tAgainstElectronTight", 2,-0.5,1.5)
            self.book(names[x], "tAgainstElectronTightMVA6", "tAgainstElectronTightMVA6", 2,-0.5,1.5)
            self.book(names[x], "tAgainstElectronVTightMVA6", "tAgainstElectronVTightMVA6", 2,-0.5,1.5)


            #self.book(names[x], "tAgainstMuonLoose", "tAgainstMuonLoose", 2,-0.5,1.5)
            self.book(names[x], "tAgainstMuonLoose3", "tAgainstMuonLoose3", 2,-0.5,1.5)
            #self.book(names[x], "tAgainstMuonMedium", "tAgainstMuonMedium", 2,-0.5,1.5)
            #self.book(names[x], "tAgainstMuonTight", "tAgainstMuonTight", 2,-0.5,1.5)
            self.book(names[x], "tAgainstMuonTight3", "tAgainstMuonTight3", 2,-0.5,1.5)

            #self.book(names[x], "tAgainstMuonLooseMVA", "tAgainstMuonLooseMVA", 2,-0.5,1.5)
            #self.book(names[x], "tAgainstMuonMediumMVA", "tAgainstMuonMediumMVA", 2,-0.5,1.5)
            #self.book(names[x], "tAgainstMuonTightMVA", "tAgainstMuonTightMVA", 2,-0.5,1.5)

            self.book(names[x], "tDecayModeFinding", "tDecayModeFinding", 2,-0.5,1.5)
            self.book(names[x], "tDecayModeFindingNewDMs", "tDecayModeFindingNewDMs", 2,-0.5,1.5)
            self.book(names[x], "tDecayMode", "tDecayMode", 21,-0.5,20.5)


            self.book(names[x], "tByLooseCombinedIsolationDeltaBetaCorr3Hits", "tByLooseCombinedIsolationDeltaBetaCorr3Hits", 2,-0.5,1.5)
            self.book(names[x], "tByMediumCombinedIsolationDeltaBetaCorr3Hits", "tByMediumCombinedIsolationDeltaBetaCorr3Hits", 2,-0.5,1.5)
            self.book(names[x], "tByTightCombinedIsolationDeltaBetaCorr3Hits", "tByTightCombinedIsolationDeltaBetaCorr3Hits", 2,-0.5,1.5)

            self.book(names[x], "tByLooseIsolationMVArun2v1DBnewDMwLT", "tByLooseIsolationMVArun2v1DBnewDMwLT", 2,-0.5,1.5)
            self.book(names[x], "tByMediumIsolationMVArun2v1DBnewDMwLT", "tByMediumIsolationMVArun2v1DBnewDMwLT", 2,-0.5,1.5)
            self.book(names[x], "tByTightIsolationMVArun2v1DBnewDMwLT", "tByTightIsolationMVArun2v1DBnewDMwLT", 2,-0.5,1.5)
            self.book(names[x], "tByVTightIsolationMVArun2v1DBnewDMwLT", "tByVTightIsolationMVArun2v1DBnewDMwLT", 2,-0.5,1.5)
            self.book(names[x], "tByVVTightIsolationMVArun2v1DBnewDMwLT", "tByVVTightIsolationMVArun2v1DBnewDMwLT", 2,-0.5,1.5)

            self.book(names[x], "tByLooseIsolationMVArun2v1DBoldDMwLT", "tByLooseIsolationMVArun2v1DBoldDMwLT", 2,-0.5,1.5)
            self.book(names[x], "tByMediumIsolationMVArun2v1DBoldDMwLT", "tByMediumIsolationMVArun2v1DBoldDMwLT", 2,-0.5,1.5)
            self.book(names[x], "tByTightIsolationMVArun2v1DBoldDMwLT", "tByTightIsolationMVArun2v1DBoldDMwLT", 2,-0.5,1.5)
            self.book(names[x], "tByVTightIsolationMVArun2v1DBoldDMwLT", "tByVTightIsolationMVArun2v1DBoldDMwLT", 2,-0.5,1.5)
            self.book(names[x], "tByVVTightIsolationMVArun2v1DBoldDMwLT", "tByVVTightIsolationMVArun2v1DBoldDMwLT", 2,-0.5,1.5)

            #self.book(names[x], "tByLooseIsolationMVA3newDMwoLT", "tByLooseIsolationMVA3newDMwoLT", 2,-0.5,1.5)
            #self.book(names[x], "tByMediumIsolationMVA3newDMwoLT", "tByMediumIsolationMVA3newDMwoLT", 2,-0.5,1.5)
            #self.book(names[x], "tByTightIsolationMVA3newDMwoLT", "tByTightIsolationMVA3newDMwoLT", 2,-0.5,1.5)
            #self.book(names[x], "tByVTightIsolationMVA3newDMwoLT", "tByVTightIsolationMVA3newDMwoLT", 2,-0.5,1.5)
            #self.book(names[x], "tByVVTightIsolationMVA3newDMwoLT", "tByVVTightIsolationMVA3newDMwoLT", 2,-0.5,1.5)
   
            #self.book(names[x], "tByLooseIsolationMVA3oldDMwoLT", "tByLooseIsolationMVA3oldDMwoLT", 2,-0.5,1.5)
            #self.book(names[x], "tByMediumIsolationMVA3oldDMwoLT", "tByMediumIsolationMVA3oldDMwoLT", 2,-0.5,1.5)
            #self.book(names[x], "tByTightIsolationMVA3oldDMwoLT", "tByTightIsolationMVA3oldDMwoLT", 2,-0.5,1.5)
            #self.book(names[x], "tByVTightIsolationMVA3oldDMwoLT", "tByVTightIsolationMVA3oldDMwoLT", 2,-0.5,1.5)
            #self.book(names[x], "tByVVTightIsolationMVA3oldDMwoLT", "tByVVTightIsolationMVA3oldDMwoLT", 2,-0.5,1.5)

            self.book(names[x], 'm1PixHits', 'Mu 1 pix hits', 10, -0.5, 9.5)
            self.book(names[x], 'm1JetBtag', 'Mu 1 JetBtag', 100, -5.5, 9.5)
            self.book(names[x], 'm2PixHits', 'Mu 2 pix hits', 10, -0.5, 9.5)
            self.book(names[x], 'm2JetBtag', 'Mu 2 JetBtag', 100, -5.5, 9.5)
    	   
#            self.book(names[x],"collMass_type1","collMass_type1",500,0,500);
          #  self.book(names[x],"collMass_type1","collMass_type1",25,0,500);
            self.book(names[x],"fullMT_type1","fullMT_type1",500,0,500);
            self.book(names[x],"fullPT_type1","fullPT_type1",500,0,500);	    
    	    self.book(names[x], "LT", "ht", 400, 0, 400)
            self.book(names[x], "type1_pfMetEt", "Type1 MET", 200, 0, 200)
    
            self.book(names[x], "m1_t_Mass", "Muon1 + Tau Mass", 200, 0, 200)
            self.book(names[x], "m2_t_Mass", "Muon2 + Tau Mass", 200, 0, 200)
            self.book(names[x], "m1_m2_Mass", "DiMuon Mass", 200, 0, 200)
            #self.book(names[x], "m_t_Pt", "Muon + Tau Pt", 200, 0, 200)
            #self.book(names[x], "m_t_DR", "Muon + Tau DR", 100, 0, 10)
            #self.book(names[x], "m_t_DPhi", "Muon + Tau DPhi", 100, 0, 4)
            #self.book(names[x], "m_t_SS", "Muon + Tau SS", 5, -2, 2)
            #self.book(names[x], "m_t_ToMETDPhi_Ty1", "Muon Tau DPhi to MET", 100, 0, 4)
    
            # Vetoes
            self.book(names[x], 'muVetoPt5IsoIdVtx', 'Number of extra muons', 5, -0.5, 4.5)
	    self.book(names[x], 'muVetoPt15IsoIdVtx', 'Number of extra muons', 5, -0.5, 4.5)
            self.book(names[x], 'tauVetoPt20Loose3HitsVtx', 'Number of extra taus', 5, -0.5, 4.5)
            self.book(names[x], 'eVetoMVAIso', 'Number of extra CiC tight electrons', 5, -0.5, 4.5)
   
            #self.book(names[x], 'jetVeto30PUCleanedTight', 'Number of extra jets', 5, -0.5, 4.5)
            #self.book(names[x], 'jetVeto30PUCleanedLoose', 'Number of extra jets', 5, -0.5, 4.5)
            self.book(names[x], 'jetVeto30', 'Number of extra jets', 5, -0.5, 4.5)	
            self.book(names[x], 'jetVeto30Eta3', 'Number of extra jets within |eta| < 3', 5, -0.5, 4.5)
	    #Isolation
	    self.book(names[x], 'm1RelPFIsoDBDefault' ,'Muon Isolation', 100, 0.0,1.0)
            self.book(names[x], 'm2RelPFIsoDBDefault' ,'Muon Isolation', 100, 0.0,1.0)
   
 
       #     self.book(names[x], "mPhiMtPhi", "", 100, 0,4)
       #     self.book(names[x], "mPhiMETPhiType1", "", 100, 0,4)
            self.book(names[x], "tPhiMETPhiType1", "", 100, 0,4)

### vbf ###
            self.book(names[x], "vbfJetVeto30", "central jet veto for vbf", 5, -0.5, 4.5)
	    self.book(names[x], "vbfJetVeto20", "", 5, -0.5, 4.5)
	    self.book(names[x], "vbfMVA", "", 100, 0,0.5)
	    self.book(names[x], "vbfMass", "", 500,0,5000.0)
	    self.book(names[x], "vbfDeta", "", 100, -0.5,10.0)
            self.book(names[x], "vbfj1eta","",100,-2.5,2.5)
	    self.book(names[x], "vbfj2eta","",100,-2.5,2.5)
	    self.book(names[x], "vbfVispt","",100,0,200)
	    self.book(names[x], "vbfHrap","",100,0,5.0)
	    self.book(names[x], "vbfDijetrap","",100,0,5.0)
	    self.book(names[x], "vbfDphihj","",100,0,4)
            self.book(names[x], "vbfDphihjnomet","",100,0,4)
            self.book(names[x], "vbfNJets", "g", 5, -0.5, 4.5)
            #self.book(names[x], "vbfNJetsPULoose", "g", 5, -0.5, 4.5)
            #self.book(names[x], "vbfNJetsPUTight", "g", 5, -0.5, 4.5)

    def correction(self,row):
	return mc_corrector(row)
	
    def fakeRateMethod(self,row,isoName):
        return getFakeRateFactor(row,isoName)
	     
    def fill_histosup(self, row,name='gg', fakeRate=False, isoName="old"):
        histos = self.histograms
        histos['counts'].Fill(1,1)
#        if 
#          histos['jetPt'].Fill(1,1)
    def fill_histos(self, row,name='gg', fakeRate=False, isoName="old"):
        histos = self.histograms
        weight=1
        if (not(self.is_data)):
	   weight = row.GenWeight * self.correction(row) #apply gen and pu reweighting to MC
        if (fakeRate == True):
          weight=weight*self.fakeRateMethod(row,isoName) #apply fakerate method for given isolation definition


        histos[name+'/weight'].Fill(weight)
        histos[name+'/GenWeight'].Fill(row.GenWeight)
        histos[name+'/genHTT'].Fill(row.genHTT)
        histos[name+'/rho'].Fill(row.rho, weight)
        histos[name+'/nvtx'].Fill(row.nvtx, weight)
        histos[name+'/prescale'].Fill(row.doubleMuPrescale, weight)
        #histos[name+'/jet1Pt'].Fill(row.jet1Pt, weight)
        #histos[name+'/jet2Pt'].Fill(row.jet2Pt, weight)
        #histos[name+'/jet2Eta'].Fill(row.jet2Eta, weight)
        #histos[name+'/jet1Eta'].Fill(row.jet1Eta, weight)
        #histos[name+'/jet1PULoose '].Fill(row.jet1PULoose , weight)
        #histos[name+'/jet2PULoose '].Fill(row.jet2PULoose , weight)
        #histos[name+'/jet1PUTight '].Fill(row.jet1PUTight , weight)
        #histos[name+'/jet2PUTight '].Fill(row.jet2PUTight , weight)
        #histos[name+'/jet1PUMVA '].Fill(row.jet1PUMVA , weight)
        #histos[name+'/jet2PUMVA '].Fill(row.jet2PUMVA , weight)

        histos[name+'/m1Pt'].Fill(row.m1Pt, weight)
        histos[name+'/m1Eta'].Fill(row.m1Eta, weight)
        histos[name+'/m2Pt'].Fill(row.m2Pt, weight)
        histos[name+'/m2Eta'].Fill(row.m2Eta, weight)
        #histos[name+'/mMtToPfMet_Ty1'].Fill(row.mMtToPfMet_type1,weight)
        histos[name+'/m1Charge'].Fill(row.m1Charge, weight)
        histos[name+'/m2Charge'].Fill(row.m2Charge, weight)
        histos[name+'/tPt'].Fill(row.tPt, weight)
        histos[name+'/tEta'].Fill(row.tEta, weight)
        histos[name+'/tPhi'].Fill(row.tPhi, weight)
        histos[name+'/tMtToPfMet_type1'].Fill(row.tMtToPfMet_type1,weight)
        histos[name+'/tCharge'].Fill(row.tCharge, weight)
	histos[name+'/tJetPt'].Fill(row.tJetPt, weight)

        histos[name+'/tMass'].Fill(row.tMass,weight)
        histos[name+'/tLeadTrackPt'].Fill(row.tLeadTrackPt,weight)
#	histos[name+'/tDPhiToPfMet_type1'].Fill(abs(row.tDPhiToPfMet_type1),weight)
#	histos[name+'/mDPhiToPfMet_tDPhiToPfMet'].Fill(abs(row.mDPhiToPfMet_type1),abs(row.tDPhiToPfMet_type1),weight)
#	histos[name+'/mDPhiToPfMet_ggdeltaphi'].Fill(abs(row.mDPhiToPfMet_type1),deltaPhi(row.mPhi, row.tPhi),weight)
#	histos[name+'/tDPhiToPfMet_ggdeltaphi'].Fill(abs(row.tDPhiToPfMet_type1),deltaPhi(row.mPhi, row.tPhi),weight)
#	histos[name+'/tDPhiToPfMet_tMtToPfMet_type1'].Fill(abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1,weight)

#tDPhiToPfMet_tMtToPfMet_type1
		      ####herer 
        #histos[name+'/tAgainstElectronLoose'].Fill(row.tAgainstElectronLoose,weight)
##        histos[name+'/tAgainstElectronLooseMVA6'].Fill(row.tAgainstElectronLooseMVA6,weight)  
        #histos[name+'/tAgainstElectronMedium'].Fill(row.tAgainstElectronMedium,weight)     
##        histos[name+'/tAgainstElectronMediumMVA6'].Fill(row.tAgainstElectronMediumMVA6,weight) 
        #histos[name+'/tAgainstElectronTight'].Fill(row.tAgainstElectronTight,weight)      
##        histos[name+'/tAgainstElectronTightMVA6'].Fill(row.tAgainstElectronTightMVA6,weight)  
##        histos[name+'/tAgainstElectronVTightMVA6'].Fill(row.tAgainstElectronVTightMVA6,weight) 


        #histos[name+'/tAgainstMuonLoose'].Fill(row.tAgainstMuonLoose,weight)
##        histos[name+'/tAgainstMuonLoose3'].Fill(row.tAgainstMuonLoose3,weight)
        #histos[name+'/tAgainstMuonMedium'].Fill(row.tAgainstMuonMedium,weight)
        #histos[name+'/tAgainstMuonTight'].Fill(row.tAgainstMuonTight,weight)
##        histos[name+'/tAgainstMuonTight3'].Fill(row.tAgainstMuonTight3,weight)

        #histos[name+'/tAgainstMuonLooseMVA'].Fill(row.tAgainstMuonLooseMVA,weight)
        #histos[name+'/tAgainstMuonMediumMVA'].Fill(row.tAgainstMuonMediumMVA,weight)
        #histos[name+'/tAgainstMuonTightMVA'].Fill(row.tAgainstMuonTightMVA,weight)

##        histos[name+'/tDecayModeFinding'].Fill(row.tDecayModeFinding,weight)
##        histos[name+'/tDecayModeFindingNewDMs'].Fill(row.tDecayModeFindingNewDMs,weight)
##        histos[name+'/tDecayMode'].Fill(row.tDecayMode,weight)
##
##        histos[name+'/tByLooseCombinedIsolationDeltaBetaCorr3Hits'].Fill(row.tByLooseCombinedIsolationDeltaBetaCorr3Hits,weight)
##        histos[name+'/tByMediumCombinedIsolationDeltaBetaCorr3Hits'].Fill(row.tByMediumCombinedIsolationDeltaBetaCorr3Hits,weight)
##        histos[name+'/tByTightCombinedIsolationDeltaBetaCorr3Hits'].Fill(row.tByTightCombinedIsolationDeltaBetaCorr3Hits,weight)
##
##        histos[name+'/tByLooseIsolationMVArun2v1DBnewDMwLT'].Fill(row.tByLooseIsolationMVArun2v1DBnewDMwLT,weight)
##        histos[name+'/tByMediumIsolationMVArun2v1DBnewDMwLT'].Fill(row.tByMediumIsolationMVArun2v1DBnewDMwLT,weight)
##        histos[name+'/tByTightIsolationMVArun2v1DBnewDMwLT'].Fill(row.tByTightIsolationMVArun2v1DBnewDMwLT,weight)
##        histos[name+'/tByVTightIsolationMVArun2v1DBnewDMwLT'].Fill(row.tByVTightIsolationMVArun2v1DBnewDMwLT,weight)
##        histos[name+'/tByVVTightIsolationMVArun2v1DBnewDMwLT'].Fill(row.tByVVTightIsolationMVArun2v1DBnewDMwLT,weight)
##
##        histos[name+'/tByLooseIsolationMVArun2v1DBoldDMwLT'].Fill(row.tByLooseIsolationMVArun2v1DBoldDMwLT,weight)
##        histos[name+'/tByMediumIsolationMVArun2v1DBoldDMwLT'].Fill(row.tByMediumIsolationMVArun2v1DBoldDMwLT,weight)
##        histos[name+'/tByTightIsolationMVArun2v1DBoldDMwLT'].Fill(row.tByTightIsolationMVArun2v1DBoldDMwLT,weight)
##        histos[name+'/tByVTightIsolationMVArun2v1DBoldDMwLT'].Fill(row.tByVTightIsolationMVArun2v1DBoldDMwLT,weight)
##        histos[name+'/tByVVTightIsolationMVArun2v1DBoldDMwLT'].Fill(row.tByVVTightIsolationMVArun2v1DBoldDMwLT,weight)

        #histos[name+'/tByLooseIsolationMVA3newDMwoLT'].Fill(row.tByLooseIsolationMVA3newDMwoLT,weight)
        #histos[name+'/tByMediumIsolationMVA3newDMwoLT'].Fill(row.tByMediumIsolationMVA3newDMwoLT,weight)
        #histos[name+'/tByTightIsolationMVA3newDMwoLT'].Fill(row.tByTightIsolationMVA3newDMwoLT,weight)
        #histos[name+'/tByVTightIsolationMVA3newDMwoLT'].Fill(row.tByVTightIsolationMVA3newDMwoLT,weight)
        #histos[name+'/tByVVTightIsolationMVA3newDMwoLT'].Fill(row.tByVVTightIsolationMVA3newDMwoLT,weight)
   
        #histos[name+'/tByLooseIsolationMVA3oldDMwoLT'].Fill(row.tByLooseIsolationMVA3oldDMwoLT,weight)
        #histos[name+'/tByMediumIsolationMVA3oldDMwoLT'].Fill(row.tByMediumIsolationMVA3oldDMwoLT,weight)
        #histos[name+'/tByTightIsolationMVA3oldDMwoLT'].Fill(row.tByTightIsolationMVA3oldDMwoLT,weight)
        #histos[name+'/tByVTightIsolationMVA3oldDMwoLT'].Fill(row.tByVTightIsolationMVA3oldDMwoLT,weight)
        #histos[name+'/tByVVTightIsolationMVA3oldDMwoLT'].Fill(row.tByVVTightIsolationMVA3oldDMwoLT,weight)

##	histos[name+'/LT'].Fill(row.LT,weight)

#        histos[name+'/collMass_type1'].Fill(row.m_t_collinearmass,weight)

        #histos[name+'/collMass_type1'].Fill(collMass_type1(row, systematic),weight)
#        histos[name+'/fullMT_type1'].Fill(fullMT(row.mPt,row.tPt, row.mPhi, row.tPhi, row, systematic),weight)
#        histos[name+'/fullPT_type1'].Fill(fullPT(row.mPt,row.tPt, row.mPhi, row.tPhi, row, systematic),weight) 

	histos[name+'/type1_pfMetEt'].Fill(row.type1_pfMetEt,weight)

        histos[name+'/m1_t_Mass'].Fill(row.m1_t_Mass,weight)
        histos[name+'/m2_t_Mass'].Fill(row.m2_t_Mass,weight)
        histos[name+'/m1_m2_Mass'].Fill(row.m1_m2_Mass,weight)
        #histos[name+'/m_t_Pt'].Fill(row.m_t_Pt,weight)
        #histos[name+'/m_t_DR'].Fill(row.m_t_DR,weight)
        #histos[name+'/m_t_DPhi'].Fill(row.m_t_DPhi,weight)
        #histos[name+'/m_t_SS'].Fill(row.m_t_SS,weight)
	#histos[name+'/m_t_ToMETDPhi_Ty1'].Fill(row.m_t_ToMETDPhi_type1,weight)

        #histos[name+'/mPixHits'].Fill(row.mPixHits, weight)
        #histos[name+'/mJetBtag'].Fill(row.mJetBtag, weight)

        histos[name+'/muVetoPt5IsoIdVtx'].Fill(row.muVetoPt5IsoIdVtx, weight)
        histos[name+'/muVetoPt15IsoIdVtx'].Fill(row.muVetoPt15IsoIdVtx, weight)
        histos[name+'/tauVetoPt20Loose3HitsVtx'].Fill(row.tauVetoPt20Loose3HitsVtx, weight)
        histos[name+'/eVetoMVAIso'].Fill(row.eVetoMVAIso, weight)
        histos[name+'/jetVeto30'].Fill(row.jetVeto30, weight)
        histos[name+'/jetVeto30Eta3'].Fill(row.jetVeto30Eta3,weight)
        #histos[name+'/jetVeto30PUCleanedLoose'].Fill(row.jetVeto30PUCleanedLoose, weight)
        #histos[name+'/jetVeto30PUCleanedTight'].Fill(row.jetVeto30PUCleanedTight, weight)

	histos[name+'/m1RelPFIsoDBDefault'].Fill(row.m1RelPFIsoDBDefault, weight)
        histos[name+'/m2RelPFIsoDBDefault'].Fill(row.m2RelPFIsoDBDefault, weight)
        
#	histos[name+'/mDPhiToPfMet_type1'].Fill(abs(row.mDPhiToPfMet_type1),weight)
#	histos[name+'/mPhiMtPhi'].Fill(deltaPhi(row.mPhi,row.tPhi),weight)
#        histos[name+'/mPhiMETPhiType1'].Fill(deltaPhi(row.mPhi,row.type1_pfMetPhi),weight)
        histos[name+'/tPhiMETPhiType1'].Fill(deltaPhi(row.tPhi,row.type1_pfMetPhi),weight)
	histos[name+'/tDecayMode'].Fill(row.tDecayMode, weight)
	histos[name+'/vbfJetVeto30'].Fill(row.vbfJetVeto30, weight)
     	#histos[name+'/vbfJetVeto20'].Fill(row.vbfJetVeto20, weight)
        #histos[name+'/vbfMVA'].Fill(row.vbfMVA, weight)
        histos[name+'/vbfMass'].Fill(row.vbfMass, weight)
        histos[name+'/vbfDeta'].Fill(row.vbfDeta, weight)
        histos[name+'/vbfj1eta'].Fill(row.vbfj1eta, weight)
        histos[name+'/vbfj2eta'].Fill(row.vbfj2eta, weight)
        histos[name+'/vbfVispt'].Fill(row.vbfVispt, weight)
        histos[name+'/vbfHrap'].Fill(row.vbfHrap, weight)
        histos[name+'/vbfDijetrap'].Fill(row.vbfDijetrap, weight)
        histos[name+'/vbfDphihj'].Fill(row.vbfDphihj, weight)
        histos[name+'/vbfDphihjnomet'].Fill(row.vbfDphihjnomet, weight)
        histos[name+'/vbfNJets'].Fill(row.vbfNJets, weight)
        #histos[name+'/vbfNJetsPULoose'].Fill(row.vbfNJetsPULoose, weight)
        #histos[name+'/vbfNJetsPUTight'].Fill(row.vbfNJetsPUTight, weight)




    def presel(self, row):
       # if not (row.singleIsoMu20Pass or row.singleIsoTkMu20Pass):
        if not (row.singleIsoMu22Pass or row.singleIsoTkMu22Pass):
            return   False
        return True
    def kinematics(self, row):
          #if row.mPt < 30:
          #    return False
          if row.m1Pt < 25:
               return False
          if abs(row.m1Eta) >= 2.1:
              return False
          if row.m2Pt < 25:
               return False
          if abs(row.m2Eta) >= 2.1:
              return False
          if row.tPt<30 :
              return False
          if abs(row.tEta)>=2.3 :
              return False
          return True 

    def selectZtt(self,row):
        if (self.is_ZTauTau and not row.isZtautau):
            return False
        if (not self.is_ZTauTau and row.isZtautau):
            return False
        return True
 
    def selectZeroJet(self,row):
	if (self.is_ZeroJet and row.NUP != 5):
            return False
	return True
    def selectOneJet(self,row):
	if (self.is_OneJet and row.NUP != 6):
            return False
	return True
    def selectTwoJet(self,row):
	if (self.is_TwoJet and row.NUP != 7):
            return False
	return True
    def selectThreeJet(self,row):
        if (self.is_ThreeJet and row.NUP != 8):
            return False
        return True
    def selectFourJet(self,row):
        if (self.is_FourJet and row.NUP != 9):
            return False
        return True

    def diMuMass(self,row): 
        if row.m1_m2_Mass < 75:
	    return False
        if row.m1_m2_Mass > 105:
            return False
        return True
   
    def isTauEndcap(self,row):
        if abs(row.tEta)<= 1.479 :
            return False
        return True

    def gg(self,row):
#       if row.mPt < 25:   #was45     #newcuts 25 
#           return False
#       if deltaPhi(row.mPhi, row.tPhi) <2.7:  # was 2.7    #new cut 2.7
#           return False
#       if row.tPt < 30:  #was 35   #newcuts30
#           return False
#       if row.tMtToPfMet_type1 > 75:  #was 50   #newcuts65
#           return False
#       if abs(row.tDPhiToPfMet_type1)>3.0:
#           return False
       if row.jetVeto30!=0:
           return False
       return True

    def boost(self,row):
          if row.jetVeto30!=1:
            return False
#          if row.mPt < 25:  #was 35    #newcuts 25
#                return False
#          if row.tPt < 30:  #was 40  #newcut 30
#                return False
#          if row.tMtToPfMet_type1 > 105: #was 35   #newcuts 75
#                return False
#          if abs(row.tDPhiToPfMet_type1)>3.0:
#                return False
          return True

    def vbf(self,row):
#        if row.tPt < 30:   #was 40   #newcuts 30
#                return False
#        if row.mPt < 25:   #was 40    #newcut 25
#       		return False
       # if row.tPt < 30:
       #         return False
       # if row.mPt < 30:
       # 	return False
#        if row.tMtToPfMet_type1 > 75: #was 35   #newcuts 55
#                return False
        if row.jetVeto30<2:  
            return False
	if(row.vbfNJets<2):
	    return False
#	if(abs(row.vbfDeta)<0.3):   #was 2.5    #newcut 2.0
#	    return False
     #   if row.vbfMass < 200:    #was 200   newcut 325
#	    return False
        if row.vbfJetVeto30 > 0:
            return False
        return True

    def oppositesign(self,row):
        if row.m1Charge*row.m2Charge!=-1:
            return False
	return True

    #def obj1_id(self, row):
    #    return bool(row.mPFIDTight)  
 
    def obj1_id(self,row):
    	 return row.m1IsGlobal and row.m1IsPFMuon and (row.m1NormTrkChi2<10) and (row.m1MuonHits > 0) and (row.m1MatchedStations > 1) and (row.m1PVDXY < 0.02) and (row.m1PVDZ < 0.5) and (row.m1PixHits > 0) and (row.m1TkLayersWithMeasurement > 5) and row.m2IsGlobal and row.m2IsPFMuon and (row.m2NormTrkChi2<10) and (row.m2MuonHits > 0) and (row.m2MatchedStations > 1) and (row.m2PVDXY < 0.02) and (row.m2PVDZ < 0.5) and (row.m2PixHits > 0) and (row.m2TkLayersWithMeasurement > 5)

    def obj2_id(self, row):
	#return  row.tAgainstElectronMediumMVA5 and row.tAgainstMuonTight3 and row.tDecayModeFinding
	return  row.tAgainstElectronMediumMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding

    def vetos(self,row):
		return  (bool (row.muVetoPt5IsoIdVtx<1) and bool (row.eVetoMVAIso<1) and bool (row.tauVetoPt20Loose3HitsVtx<1) )

    #def obj1_iso(self, row):
    #    return bool(row.mRelPFIsoDBDefault <0.12)
   
    def obj1_iso(self,row):
         return bool(row.m1RelPFIsoDBDefault <0.15) and bool(row.m2RelPFIsoDBDefault <0.15)

    def obj2_iso(self, row):
        return  row.tByTightCombinedIsolationDeltaBetaCorr3Hits

    def obj2_mediso(self, row):
	 return row.tByMediumCombinedIsolationDeltaBetaCorr3Hits

    def obj1_antiiso(self, row):
        return bool(row.mRelPFIsoDBDefault >0.2) 

    def obj2_looseiso(self, row):
        return row.tByLooseCombinedIsolationDeltaBetaCorr3Hits


    def obj2_newvvtightiso(self, row):
        return row.tByVVTightIsolationMVArun2v1DBoldDMwLT 
       # return row.tByVVTightIsolationMVA3oldDMwLT 
    def obj2_newvtightiso(self, row):
        #return row.tByVTightIsolationMVA3oldDMwLT
        return row.tByVTightIsolationMVArun2v1DBoldDMwLT
    def obj2_newtightiso(self, row):
        return row.tByTightIsolationMVArun2v1DBoldDMwLT
#    def obj2_newvlooseiso(self,row):
#        return row.tByVLooseIsolationMVA3oldDMwLT
    def obj2_newlooseiso(self,row):
       # return row.tByLooseIsolationMVA3oldDMwLT
        return row.tByLooseIsolationMVArun2v1DBoldDMwLT
    def obj2_newisonewdms(self, row):
       # return row.tByVVTightIsolationMVA3newDMwLT 
        return row.tByVVTightIsolationMVArun2v1DBnewDMwLT 
    def obj2_newlooseisonewdms(self,row):
        return row.tByLooseIsolationMVArun2v1DBnewDMwLT

    #def obj2_newlooseiso(self, row):
    #    return  row.tByLooseIsolationMVA3oldDMwoLT


    def process(self):
        event =0
        sel=False
        for row in self.tree:
#            self.fill_histosup(row,'treelev',False)
            if event!=row.evt:   # This is just to ensure we get the (Mu,Tau) with the highest Pt
                event=row.evt    # In principle the code saves all the MU+Tau posibilities, if an event has several combinations
                sel = False      # it will save them all.
            if sel==True:
                continue
            if not self.oppositesign(row):                                                                       
                  continue    
            if self.is_data: 
               if not self.presel(row):
                  continue
            if not self.selectZtt(row):
                continue
            if not self.selectZeroJet(row):
		continue
            if not self.selectOneJet(row):
		continue
            if not self.selectTwoJet(row):
		continue
            if not self.selectThreeJet(row):
		continue
            if not self.selectFourJet(row):
		continue
            if not self.kinematics(row): 
                continue
            if not self.diMuMass(row):
                continue
            if not self.obj1_iso(row):
                continue
            if not self.obj1_id(row):
                continue

            if not self.vetos (row):
                continue

            if not self.obj2_id (row):
                continue
            if self.obj2_looseiso(row):
                self.fill_histos(row,'looseOldIso')
            if self.obj2_mediso(row):
                self.fill_histos(row,'medOldIso')
            if self.obj2_iso(row):
                self.fill_histos(row,'tightOldIso')
      #      if self.obj2_newvlooseiso(row):
      #          self.fill_histos(row,'VlooseNewIso')
            if self.obj2_newlooseiso(row):
                self.fill_histos(row,'looseNewIso')
            if self.obj2_newvvtightiso(row):
                self.fill_histos(row,'VVtightNewIso')
            if self.obj2_newvtightiso(row):
                self.fill_histos(row,'VtightNewIso')
            if self.obj2_newtightiso(row):
                self.fill_histos(row,'tightNewIso')
            if self.obj2_newlooseisonewdms(row):
                self.fill_histos(row,'looseNewIsoNewDMs')
            if self.obj2_newisonewdms(row):
                self.fill_histos(row,'tightNewIsoNewDMs')
            if self.isTauEndcap(row):
              if self.obj2_looseiso(row):
                  self.fill_histos(row,'looseOldIsoEndcap')
              if self.obj2_mediso(row):
                  self.fill_histos(row,'medOldIsoEndcap')
              if self.obj2_iso(row):
                  self.fill_histos(row,'tightOldIsoEndcap')
         #     if self.obj2_newvlooseiso(row):
         #         self.fill_histos(row,'VlooseNewIsoEndcap')
              if self.obj2_newlooseiso(row):
                  self.fill_histos(row,'looseNewIsoEndcap')
              if self.obj2_newvvtightiso(row):
                  self.fill_histos(row,'VVtightNewIsoEndcap')
              if self.obj2_newvtightiso(row):
                  self.fill_histos(row,'VtightNewIsoEndcap')
              if self.obj2_newtightiso(row):
                  self.fill_histos(row,'tightNewIsoEndcap')
              if self.obj2_newlooseisonewdms(row):
                  self.fill_histos(row,'looseNewIsoNewDMsEndcap')
              if self.obj2_newisonewdms(row):
                  self.fill_histos(row,'tightNewIsoNewDMsEndcap')
            if not self.isTauEndcap(row):
              if self.obj2_looseiso(row):
                  self.fill_histos(row,'looseOldIsoBarrel')
              if self.obj2_mediso(row):
                  self.fill_histos(row,'medOldIsoBarrel')
              if self.obj2_iso(row):
                  self.fill_histos(row,'tightOldIsoBarrel')
         #     if self.obj2_newvlooseiso(row):
         #         self.fill_histos(row,'VlooseNewIsoBarrel')
              if self.obj2_newlooseiso(row):
                  self.fill_histos(row,'looseNewIsoBarrel')
              if self.obj2_newvvtightiso(row):
                  self.fill_histos(row,'VVtightNewIsoBarrel')
              if self.obj2_newvtightiso(row):
                  self.fill_histos(row,'VtightNewIsoBarrel')
              if self.obj2_newtightiso(row):
                  self.fill_histos(row,'tightNewIsoBarrel')
              if self.obj2_newlooseisonewdms(row):
                  self.fill_histos(row,'looseNewIsoNewDMsBarrel')
              if self.obj2_newisonewdms(row):
                  self.fill_histos(row,'tightNewIsoNewDMsBarrel')

#              self.fill_histos(row,'oldisotight')
#
#            if self.gg(row):
#                self.fill_histos(row,'gg')
#
#            elif self.boost(row):
#                self.fill_histos(row,'boost')
#
#            elif self.vbf(row):
#                self.fill_histos(row,'vbf')
# 
#            elif self.obj2_looseiso(row):
#
#              self.fill_histos(row,'oldisoloose')
#
#              if self.gg(row):
#                  self.fill_histos(row,'oldisoloosegg')
#
#              if self.boost(row):
#                  self.fill_histos(row,'oldisolooseboost')
#
#              if self.vbf(row):
#                  self.fill_histos(row,'oldisoloosevbf')
#
#
#            if self.obj2_newiso(row):
#
#              self.fill_histos(row,'newisotight')
#
#              if self.gg(row):
#                  self.fill_histos(row,'newisogg')
#
#              if self.boost(row):
#                  self.fill_histos(row,'newisoboost')
#
#              if self.vbf(row):
#                  self.fill_histos(row,'newisovbf')
#
#            elif self.obj2_newlooseiso(row):
#              
#              self.fill_histos(row,'newisoloose')
#
#              if self.gg(row):
#                  self.fill_histos(row,'newisoloosegg')
#
#              if self.boost(row):
#                  self.fill_histos(row,'newisolooseboost')
#
#              if self.vbf(row):
#                  self.fill_histos(row,'newisoloosevbf')
#
#
#            if self.gg(row):
#                self.fill_histos(row,'noisogg')
#
#            if self.boost(row):
#                self.fill_histos(row,'noisoboost')
#
#            if self.vbf(row):
#                self.fill_histos(row,'noisovbf')
#
            

            sel=True

    def finish(self):
        self.write_histos()
