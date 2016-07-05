'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
#import FinalStateAnalysis.TagAndProbe.H2TauCorrections as H2TauCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import ROOT
import math
import optimizer
from math import sqrt, pi
import itertools

#data=bool ('true' in os.environ['isRealData'])
#RUN_OPTIMIZATION=bool ('true' in os.environ['RUN_OPTIMIZATION'])
#RUN_OPTIMIZATION=True
RUN_OPTIMIZATION=False
#RUN_OPTIMIZATION=False
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

def fullMT(mupt,taupt , muphi, tauphi, row, sys='none'):
	mux=mupt*math.cos(muphi)
	muy=mupt*math.sin(muphi)
        met = row.type1_pfMet_shiftedPt_JetEnUp
        metphi = row.type1_pfMet_shiftedPhi_JetEnUp
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
        met = row.type1_pfMet_shiftedPt_JetEnUp
        metphi = row.type1_pfMet_shiftedPhi_JetEnUp
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
	metE = row.type1_pfMet_shiftedPt_JetEnUp
	metPhi = row.type1_pfMet_shiftedPhi_JetEnUp
        metpx = metE*math.cos(metPhi)
        metpy = metE*math.sin(metPhi)
        met = sqrt(metpx*metpx+metpy*metpy)

        METproj= abs(metpx*taupx+metpy*taupy)/row.tPt

        xth=row.tPt/(row.tPt+METproj)
        den=math.sqrt(xth)

        mass=row.m_t_Mass/den

        #print '%4.2f, %4.2f, %4.2f, %4.2f, %4.2f' %(scaleMass(row), den, xth, METproj,mass)


        return mass

'''
def gettPt(row,sys='none'):
	if (sys=='none' or 'jes' in sys or 'ues' in sys):
		return row.tPt
	if (sys=='tesup'):
		return row.tPt_TauEnUp
	if (sys=='tesdown'):
		return row.tPt_TauEnDown

def getmtMass(row,sys='none'):
	if(sys=='none' or 'jes' in sys or 'ues' in sys):
		return row.m_t_Mass
	if(sys=='tesup'):
		return row.m_t_Mass_TauEnUp
	if(sys=='tesdown'):
		return row.m_t_Mass_TauEnDown

def gettMass(row,sys='none'):
        if(sys=='none' or 'jes' in sys or 'ues' in sys):
                return row.tMass
        if(sys=='tesup'):
                return row.tMass_TauEnUp
        if(sys=='tesdown'):
                return row.tMass_TauEnDown

def getmMtToPfMet(row,sys='none'):
	if (sys=='none'):
		return row.mMtToPfMet_JetEnUp
        elif (sys=='jesdown'):
		return row.mMtToPfMet_JetEnDown
	elif (sys=='jesup'):
		return row.mMtToPfMet_JetEnUp
	elif (sys=='uesdown'):
		return row.mMtToPfMet_UnclusteredEnDown
	elif (sys=='uesup'):
		return row.mMtToPfMet_UnclusteredEnUp
        elif (sys=='tesdown'):
                return row.mMtToPfMet_TauEnDown
        elif (sys=='tesup'):
                return row.mMtToPfMet_TauEnUp

def gettMtToPfMet(row,sys='none'):
        if (sys=='none'):
                return row.tMtToPfMet_JetEnUp
        elif (sys=='jesdown'):
                return row.tMtToPfMet_JetEnDown
        elif (sys=='jesup'):
                return row.tMtToPfMet_JetEnUp
        elif (sys=='uesdown'):
                return row.tMtToPfMet_UnclusteredEnDown
        elif (sys=='uesup'):
                return row.tMtToPfMet_UnclusteredEnUp
        elif (sys=='tesdown'):
                return row.tMtToPfMet_TauEnDown
        elif (sys=='tesup'):
                return row.tMtToPfMet_TauEnUp

def getmtcollMass(row,sys='none'):
        if (sys=='none'):
                return row.m_t_collinearmass_JetEnUp
        elif (sys=='jesdown'):
                return row.m_t_collinearmass_JetEnUp_JetEnDown
        elif (sys=='jesup'):
                return row.m_t_collinearmass_JetEnUp_JetEnUp
        elif (sys=='uesdown'):
                return row.m_t_collinearmass_JetEnUp_UnclusteredEnDown
        elif (sys=='uesup'):
                return row.m_t_collinearmass_JetEnUp_UnclusteredEnUp
        elif (sys=='tesup'):
		return row.m_t_collinearmass_JetEnUp_TauEnUp
	elif (sys=='tesdown'):
		return row.m_t_collinearmass_JetEnUp_TauEnDown

def getpfMetEt(row,sys='none'):
        if (sys=='none'):
                return row.type1_pfMet_shiftedPt_JetEnUp
        elif (sys=='jesdown'):
                return row.type1_pfMet_shiftedPt_JetEnDown
        elif (sys=='jesup'):
                return row.type1_pfMet_shiftedPt_JetEnUp
        elif (sys=='uesdown'):
                return row.type1_pfMet_shiftedPt_UnclusteredEnDown
        elif (sys=='uesup'):
                return row.type1_pfMet_shiftedPt_UnclusteredEnUp
        elif (sys=='tesdown'):
                return row.type1_pfMet_shiftedPt_TauEnDown
        elif (sys=='tesup'):
                return row.type1_pfMet_shiftedPt_TauEnUp

def getpfMetPhi(row,sys='none'):
        if (sys=='none'):
                return row.type1_pfMet_shiftedPhi_JetEnUp
        elif (sys=='jesdown'):
                return row.type1_pfMet_shiftedPhi_JetEnDown
        elif (sys=='jesup'):
                return row.type1_pfMet_shiftedPhi_JetEnUp
        elif (sys=='uesdown'):
                return row.type1_pfMet_shiftedPhi_UnclusteredEnDown
        elif (sys=='uesup'):
                return row.type1_pfMet_shiftedPhi_UnclusteredEnUp
        elif (sys=='tesdown'):
                return row.type1_pfMet_shiftedPhi_TauEnDown
        elif (sys=='tesup'):
                return row.type1_pfMet_shiftedPhi_TauEnUp


def getjetVeto30(row,sys='none'):
	if (sys=='none' or 'ues' in sys or 'tes' in sys):
		return row.jetVeto30_JetEnUp
	elif (sys=='jesdown'):
		return row.jetVeto30_JetEnUp_JetEnDown
	elif (sys=='jesup'):
		return row.jetVeto30_JetEnUp_JetEnUp

def getjetVeto30Eta3(row,sys='none'):
        if (sys=='none' or 'ues' in sys or 'tes' in sys):
                return row.jetVeto30Eta3_JetEnUp
        elif (sys=='jesdown'):
                return row.jetVeto30Eta3_JetEnUp_JetEnDown
        elif (sys=='jesup'):
                return row.jetVeto30Eta3_JetEnUp_JetEnUp

def getvbfNJets(row,sys='none'):
	if (sys=='none' or 'ues' in sys or 'tes' in sys):
		return row.vbfNJets_JetEnUp
        elif (sys=='jesdown'):
                return row.vbfNJets_JetEnUp_JetEnDown
        elif (sys=='jesup'):
                return row.vbfNJets_JetEnUp_JetEnUp

def getvbfDeta(row,sys='none'):
        if (sys=='none' or 'ues' in sys or 'tes' in sys):
                return row.vbfDeta_JetEnUp
        elif (sys=='jesdown'):
                return row.vbfDeta_JetEnUp_JetEnDown
        elif (sys=='jesup'):
                return row.vbfDeta_JetEnUp_JetEnUp

def getvbfMass(row,sys='none'):
        if (sys=='none' or 'ues' in sys or 'tes' in sys):
                return row.vbfMass_JetEnUp
        elif (sys=='jesdown'):
                return row.vbfMass_JetEnUp_JetEnDown
        elif (sys=='jesup'):
                return row.vbfMass_JetEnUp_JetEnUp

def getvbfJetVeto30(row,sys='none'):
        if (sys=='none' or 'ues' in sys or 'tes' in sys):
                return row.vbfJetVeto30_JetEnUp
        elif (sys=='jesdown'):
                return row.vbfJetVeto30_JetEnUp_JetEnDown
        elif (sys=='jesup'):
                return row.vbfJetVeto30_JetEnUp_JetEnUp
'''

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

muon_pog_PFTight_2015 = MuonPOGCorrections.make_muon_pog_PFTight_2015CD()
muon_pog_TightIso_2015 = MuonPOGCorrections.make_muon_pog_TightIso_2015CD()
muon_pog_IsoMu20oIsoTkMu20_2015 = MuonPOGCorrections.make_muon_pog_IsoMu20oIsoTkMu20_2015()

def mc_corrector_2015(row):
  pu = pu_corrector(row.nTruePU)

  m1id = muon_pog_PFTight_2015(row.mPt,abs(row.mEta))
  m1iso = muon_pog_TightIso_2015('Tight',row.mPt,abs(row.mEta))
  m_trg = muon_pog_IsoMu20oIsoTkMu20_2015(row.mPt,abs(row.mEta))

  #print "pu"
  #print str(pu)
  #return pu*m1id*m1iso*m_trg
  return pu*m1id*m1iso
 # return pu*m1id*m1iso
 # return m1id*m1iso*m_trg

mc_corrector = mc_corrector_2015

class AnalyzeLFVMuTaujesup(MegaBase):
    tree = 'mt/final/Ntuple'
    #tree = 'New_Tree'

    def __init__(self, tree, outfile, **kwargs):
        super(AnalyzeLFVMuTaujesup, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        target = os.path.basename(os.environ['megatarget'])
      #  print "the target is ***********    %s"    %target
        self.is_data = target.startswith('data_')
     #   print "*************"
     #   print self.is_data
        self.is_ZeroJet=('WJetsToLNu' in target)
        self.is_OneJet=('W1JetsToLNu' in target)
        self.is_TwoJet=('W2JetsToLNu' in target)
        self.is_ThreeJet=('W3JetsToLNu' in target)
        self.is_FourJet=('W4JetsToLNu' in target)
        self.is_embedded = ('Embedded' in target)
        self.is_ZTauTau= ('ZTauTau' in target)
        self.is_mc = not (self.is_data or self.is_embedded)
        self.tree = MuTauTree.MuTauTree(tree)
        self.out = outfile
        self.histograms = {}

    def begin(self):

        self.book('treelev',"counts", "Event counts", 10, 0, 5)
#        self.book('',"jetPt", "Event counts", 10, 0, 5)
        names=["preselection","preselectionSS", "notIso","notIsoNotWeightedSS","notIsoSS","gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","notIsoNotWeighted",
               "preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet"]
        if RUN_OPTIMIZATION:
		for region in optimizer.regions['0']:
			names.append(os.path.join("gg",region))	
			names.append(os.path.join("ggNotIso",region))	
		for region in optimizer.regions['1']:
			names.append(os.path.join("boost",region))	
			names.append(os.path.join("boostNotIso",region))	
		for region in optimizer.regions['2']:
			names.append(os.path.join("vbf",region))	
			names.append(os.path.join("vbfNotIso",region))	
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

   
            self.book(names[x], "jet1Pt", "", 300,0,300)
            self.book(names[x], "jet2Pt", "", 300,0,300)
            self.book(names[x], "jet3Pt", "", 300,0,300)
            self.book(names[x], "jet4Pt", "", 300,0,300)
            self.book(names[x], "jet5Pt", "", 300,0,300)


            self.book(names[x], "jet1Eta", "", 200,-5,5)
            self.book(names[x], "jet2Eta", "", 200,-5,5)
            self.book(names[x], "jet3Eta", "", 200,-5,5)
            self.book(names[x], "jet4Eta", "", 200,-5,5)
            self.book(names[x], "jet5Eta", "", 200,-5,5)

            self.book(names[x], "jet1Phi", "", 280,-7,7)
            self.book(names[x], "jet2Phi", "", 280,-7,7)
            self.book(names[x], "jet3Phi", "", 280,-7,7)
            self.book(names[x], "jet4Phi", "", 280,-7,7)
            self.book(names[x], "jet5Phi", "", 280,-7,7)
 
            self.book(names[x], "mPt", "Muon  Pt", 300,0,300)
            self.book(names[x], "mEta", "Muon  eta", 100, -2.5, 2.5)
            self.book(names[x], "mMtToPfMet_type1", "Muon MT (PF Ty1)", 200, 0, 200)
            self.book(names[x], "mCharge", "Muon Charge", 5, -2, 2)

            self.book(names[x], "tPt", "Tau  Pt", 300,0,300)
            self.book(names[x], "tEta", "Tau  eta", 100, -2.5, 2.5)
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

            self.book(names[x], 'mPixHits', 'Mu 1 pix hits', 10, -0.5, 9.5)
            self.book(names[x], 'mJetBtag', 'Mu 1 JetBtag', 100, -5.5, 9.5)
    	  
#            self.book(names[x],"collMass_type1_1","collMass_type1_1",500,0,500);
#            self.book(names[x],"collMass_type1_2","collMass_type1_2",500,0,500);

            self.book(names[x],"collMass_type1","collMass_type1",500,0,500);
          #  self.book(names[x],"collMass_type1","collMass_type1",25,0,500);
            self.book(names[x],"fullMT_type1","fullMT_type1",500,0,500);
            self.book(names[x],"fullPT_type1","fullPT_type1",500,0,500);	    
    	    self.book(names[x], "LT", "ht", 400, 0, 400)
            self.book(names[x], "type1_pfMetEt", "Type1 MET", 200, 0, 200)
    
            self.book(names[x], "m_t_Mass", "Muon + Tau Mass", 200, 0, 200)
            self.book(names[x], "m_t_Pt", "Muon + Tau Pt", 200, 0, 200)
            self.book(names[x], "m_t_DR", "Muon + Tau DR", 100, 0, 10)
            self.book(names[x], "m_t_DPhi", "Muon + Tau DPhi", 100, 0, 4)
            self.book(names[x], "mDPhiToPfMet_type1", "mDPhiToPfMet_type1", 100, 0, 4)
            self.book(names[x], "m_t_SS", "Muon + Tau SS", 5, -2, 2)
            self.book(names[x], "m_t_ToMETDPhi_Ty1", "Muon Tau DPhi to MET", 100, 0, 4)
    
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
	    self.book(names[x], 'mRelPFIsoDBDefault' ,'Muon Isolation', 100, 0.0,1.0)
   
 
            self.book(names[x], "mPhiMtPhi", "", 100, 0,4)
            self.book(names[x], "mPhiMETPhiType1", "", 100, 0,4)
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
        histos[name+'/singleIsoMu22Pass'].Fill(row.singleIsoMu22Pass,weight)
        histos[name+'/singleIsoTkMu22Pass'].Fill(row.singleIsoTkMu22Pass,weight)

        
        histos[name+'/counts'].Fill(1)
        histos[name+'/jet1Pt'].Fill(row.jet1Pt, weight)
        histos[name+'/jet2Pt'].Fill(row.jet2Pt, weight)
        histos[name+'/jet3Pt'].Fill(row.jet3Pt, weight)
        histos[name+'/jet4Pt'].Fill(row.jet4Pt, weight)
        histos[name+'/jet5Pt'].Fill(row.jet5Pt, weight)
        histos[name+'/jet1Eta'].Fill(row.jet1Eta, weight)
        histos[name+'/jet2Eta'].Fill(row.jet2Eta, weight)
        histos[name+'/jet3Eta'].Fill(row.jet3Eta, weight)
        histos[name+'/jet4Eta'].Fill(row.jet4Eta, weight)
        histos[name+'/jet5Eta'].Fill(row.jet5Eta, weight)
        histos[name+'/jet1Phi'].Fill(row.jet1Phi, weight)
        histos[name+'/jet2Phi'].Fill(row.jet2Phi, weight)
        histos[name+'/jet3Phi'].Fill(row.jet3Phi, weight)
        histos[name+'/jet4Phi'].Fill(row.jet4Phi, weight)
        histos[name+'/jet5Phi'].Fill(row.jet5Phi, weight)
        
        histos[name+'/mPt'].Fill(row.mPt, weight)
        histos[name+'/mEta'].Fill(row.mEta, weight)
        histos[name+'/mMtToPfMet_type1'].Fill(row.mMtToPfMet_JetEnUp,weight)
        histos[name+'/mCharge'].Fill(row.mCharge, weight)
        histos[name+'/tPt'].Fill(row.tPt, weight)
        histos[name+'/tEta'].Fill(row.tEta, weight)
        histos[name+'/tMtToPfMet_type1'].Fill(row.tMtToPfMet_JetEnUp,weight)
        histos[name+'/tCharge'].Fill(row.tCharge, weight)
	histos[name+'/tJetPt'].Fill(row.tJetPt, weight)

        histos[name+'/tMass'].Fill(row.tMass,weight)
        histos[name+'/tLeadTrackPt'].Fill(row.tLeadTrackPt,weight)
	histos[name+'/tDPhiToPfMet_type1'].Fill(abs(row.tDPhiToPfMet_JetEnUp),weight)
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

        histos[name+'/collMass_type1'].Fill(row.m_t_collinearmass_JetEnUp,weight)

        #histos[name+'/collMass_type1'].Fill(collMass_type1(row, systematic),weight)
        histos[name+'/fullMT_type1'].Fill(fullMT(row.mPt,row.tPt, row.mPhi, row.tPhi, row, systematic),weight)
        histos[name+'/fullPT_type1'].Fill(fullPT(row.mPt,row.tPt, row.mPhi, row.tPhi, row, systematic),weight) 

	histos[name+'/type1_pfMetEt'].Fill(row.type1_pfMet_shiftedPt_JetEnUp,weight)

        histos[name+'/m_t_Mass'].Fill(row.m_t_Mass,weight)
        histos[name+'/m_t_Pt'].Fill(row.m_t_Pt,weight)
        histos[name+'/m_t_DR'].Fill(row.m_t_DR,weight)
        histos[name+'/m_t_DPhi'].Fill(row.m_t_DPhi,weight)
        histos[name+'/m_t_SS'].Fill(row.m_t_SS,weight)
	#histos[name+'/m_t_ToMETDPhi_Ty1'].Fill(row.m_t_ToMETDPhi_Ty1,weight)

        histos[name+'/mPixHits'].Fill(row.mPixHits, weight)
        histos[name+'/mJetBtag'].Fill(row.mJetBtag, weight)

##        histos[name+'/muVetoPt5IsoIdVtx'].Fill(row.muVetoPt5IsoIdVtx, weight)
##        histos[name+'/muVetoPt15IsoIdVtx'].Fill(row.muVetoPt15IsoIdVtx, weight)
##        histos[name+'/tauVetoPt20Loose3HitsVtx'].Fill(row.tauVetoPt20Loose3HitsVtx, weight)
##        histos[name+'/eVetoMVAIso'].Fill(row.eVetoMVAIso, weight)
        histos[name+'/jetVeto30'].Fill(row.jetVeto30_JetEnUp, weight)
        histos[name+'/jetVeto30Eta3'].Fill(row.jetVeto30Eta3_JetEnUp,weight)
        #histos[name+'/jetVeto30PUCleanedLoose'].Fill(row.jetVeto30_JetEnUpPUCleanedLoose, weight)
        #histos[name+'/jetVeto30PUCleanedTight'].Fill(row.jetVeto30_JetEnUpPUCleanedTight, weight)

	histos[name+'/mRelPFIsoDBDefault'].Fill(row.mRelPFIsoDBDefault, weight)
        
	histos[name+'/mDPhiToPfMet_type1'].Fill(abs(row.mDPhiToPfMet_JetEnUp),weight)
	histos[name+'/mPhiMtPhi'].Fill(deltaPhi(row.mPhi,row.tPhi),weight)
        histos[name+'/mPhiMETPhiType1'].Fill(deltaPhi(row.mPhi,row.type1_pfMet_shiftedPhi_JetEnUp),weight)
        histos[name+'/tPhiMETPhiType1'].Fill(deltaPhi(row.tPhi,row.type1_pfMet_shiftedPhi_JetEnUp),weight)
	histos[name+'/tDecayMode'].Fill(row.tDecayMode, weight)
	histos[name+'/vbfJetVeto30'].Fill(row.vbfJetVeto30_JetEnUp, weight)
     	#histos[name+'/vbfJetVeto20'].Fill(row.vbfJetVeto20, weight)
        #histos[name+'/vbfMVA'].Fill(row.vbfMVA, weight)
        histos[name+'/vbfMass'].Fill(row.vbfMass_JetEnUp, weight)
        histos[name+'/vbfDeta'].Fill(row.vbfDeta_JetEnUp, weight)
        #histos[name+'/vbfj1eta'].Fill(row.vbfj1eta, weight)
        #histos[name+'/vbfj2eta'].Fill(row.vbfj2eta, weight)
        #histos[name+'/vbfVispt'].Fill(row.vbfVispt, weight)
        #histos[name+'/vbfHrap'].Fill(row.vbfHrap, weight)
        #histos[name+'/vbfDijetrap'].Fill(row.vbfDijetrap, weight)
        #histos[name+'/vbfDphihj'].Fill(row.vbfDphihj, weight)
        #histos[name+'/vbfDphihjnomet'].Fill(row.vbfDphihjnomet, weight)
        histos[name+'/vbfNJets'].Fill(row.vbfNJets_JetEnUp, weight)
        #histos[name+'/vbfNJetsPULoose'].Fill(row.vbfNJets_JetEnUpPULoose, weight)
        #histos[name+'/vbfNJetsPUTight'].Fill(row.vbfNJets_JetEnUpPUTight, weight)




    def presel(self, row):
       # if not (row.singleIsoMu20Pass or row.singleIsoTkMu20Pass):
        if not (row.singleIsoMu22Pass or row.singleIsoTkMu22Pass):
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
    def kinematicst20(self, row):
        if row.mPt < 25:
            return False
        if abs(row.mEta) >= 2.1:
            return False
        if row.tPt<20 :
            return False
        if abs(row.tEta)>=2.3:
            return False
        return True
    def kinematics(self, row):
        if row.mPt < 25:
            return False
        if abs(row.mEta) >= 2.1:
            return False
        if row.tPt<30 :
            return False
        if abs(row.tEta)>=2.3:
            return False
        return True

    def gg(self,row):
       if row.mPt < 45:    
           return False
       if deltaPhi(row.mPhi, row.tPhi) <2.7:
           return False
       if row.tPt < 35:
           return False
       if row.tMtToPfMet_JetEnUp > 50:
           return False
       if row.jetVeto30_JetEnUp!=0:
           return False
       return True

    def boost(self,row):
          if row.jetVeto30_JetEnUp!=1:
            return False
          if row.mPt < 35:
                return False
          if row.tPt < 40:
                return False
          if row.tMtToPfMet_JetEnUp > 35:
                return False
          return True

    def vbf(self,row):
        if row.tPt < 40:
                return False
        if row.mPt < 40:
       		return False
       # if row.tPt < 30:
       #         return False
       # if row.mPt < 30:
       # 	return False
        if row.tMtToPfMet_JetEnUp > 35:
                return False
        if row.jetVeto30_JetEnUp<2:
            return False
	if(row.vbfNJets_JetEnUp<2):
	    return False
	if(abs(row.vbfDeta_JetEnUp)<2.5):
	    return False
        if row.vbfMass_JetEnUp < 200:
	    return False
        if row.vbfJetVeto30_JetEnUp > 0:
            return False
        return True

    def oppositesign(self,row):
	if row.mCharge*row.tCharge!=-1:
            return False
	return True

    #def obj1_id(self, row):
    #    return bool(row.mPFIDTight)  
 
    def obj1_id(self,row):
    	 return row.mIsGlobal and row.mIsPFMuon and (row.mNormTrkChi2<10) and (row.mMuonHits > 0) and (row.mMatchedStations > 1) and (row.mPVDXY < 0.02) and (row.mPVDZ < 0.5) and (row.mPixHits > 0) and (row.mTkLayersWithMeasurement > 5)

    def obj2_id(self, row):
	return  row.tAgainstElectronMediumMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding

    def vetos(self,row):
		return  (bool (row.muVetoPt5IsoIdVtx<1) and bool (row.eVetoMVAIso<1) and bool (row.tauVetoPt20Loose3HitsVtx<1) )

    #def obj1_iso(self, row):
    #    return bool(row.mRelPFIsoDBDefault <0.12)
   
    def obj1_iso(self,row):
         return bool(row.mRelPFIsoDBDefault <0.15)

    def obj2_iso(self, row):
        return  row.tByTightCombinedIsolationDeltaBetaCorr3Hits

    def obj2_mediso(self, row):
	 return row.tByMediumCombinedIsolationDeltaBetaCorr3Hits

    def obj1_antiiso(self, row):
        return bool(row.mRelPFIsoDBDefault >0.2) 

    def obj2_looseiso(self, row):
        return row.tByLooseCombinedIsolationDeltaBetaCorr3Hits


    def obj2_newiso(self, row):
        return row.tByVVTightIsolationMVArun2v1DBoldDMwLT 

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
         #   if not self.presel(row):
         #       continue
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
 
            if not self.obj1_iso(row):
                continue
            if not self.obj1_id(row):
                continue

            if not self.vetos (row):
                continue

            if not self.obj2_id (row):
                continue

            if not self.obj2_looseiso(row):
                continue
            if self.obj2_iso(row) and not self.oppositesign(row):
              self.fill_histos(row,'preselectionSS',False)

            if not self.obj2_iso(row) and not self.oppositesign(row):
              self.fill_histos(row,'notIsoSS',True)
              self.fill_histos(row,'notIsoNotWeightedSS',False)

            if self.obj2_iso(row) and self.oppositesign(row):  
#              print row.m_t_collinearmass_JetEnUp
              self.fill_histos(row,'preselection',False)
              if row.jetVeto30_JetEnUp==0:
                self.fill_histos(row,'preselection0Jet',False)
              if row.jetVeto30_JetEnUp==1:
                self.fill_histos(row,'preselection1Jet',False)
              if row.jetVeto30_JetEnUp==2:
                self.fill_histos(row,'preselection2Jet',False)

             # if self.gg(row):
             #     self.fill_histos(row,'gg',False)

              if  row.jetVeto30_JetEnUp==0:
                  if RUN_OPTIMIZATION:
                     for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),row.tMtToPfMet_JetEnUp):
   		        tmp=os.path.join("gg",i)
		        self.fill_histos(row,tmp,False)	
                  if self.gg(row):
                        self.fill_histos(row,'gg',False)

             # if self.boost(row):
             #     self.fill_histos(row,'boost',False)
              if row.jetVeto30_JetEnUp==1:
                  if RUN_OPTIMIZATION:
                     for  i in optimizer.compute_regions_1jet(row.tPt, row.mPt,row.tMtToPfMet_JetEnUp):
		        tmp=os.path.join("boost",i)
		        self.fill_histos(row,tmp,False)	
                  if self.boost(row):
                        self.fill_histos(row,'boost',False)

              if (row.jetVeto30_JetEnUp>=2 and row.vbfJetVeto30_JetEnUp <= 0) :
                  if RUN_OPTIMIZATION:
                     for  i in optimizer.compute_regions_2jet(row.tPt, row.mPt,row.tMtToPfMet_JetEnUp,row.vbfMass_JetEnUp,row.vbfDeta_JetEnUp):
		        tmp=os.path.join("vbf",i)
		        self.fill_histos(row,tmp,False)	
                  if self.vbf(row):
                        self.fill_histos(row,'vbf',False)

             # if self.vbf(row):
             #     self.fill_histos(row,'vbf',False)
            if not self.obj2_iso(row) and self.oppositesign(row):
              self.fill_histos(row,'notIso',True)
              self.fill_histos(row,'notIsoNotWeighted',False)

              if row.jetVeto30_JetEnUp==0:
                self.fill_histos(row,'notIso0Jet',True)
              if row.jetVeto30_JetEnUp==1:
                self.fill_histos(row,'notIso1Jet',True)
              if row.jetVeto30_JetEnUp==2:
                self.fill_histos(row,'notIso2Jet',True)
              if  row.jetVeto30_JetEnUp==0:
                  if RUN_OPTIMIZATION:
                     for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),row.tMtToPfMet_JetEnUp):
                        tmp=os.path.join("ggNotIso",i)
                        self.fill_histos(row,tmp,True)
                  if self.gg(row):
                        self.fill_histos(row,'ggNotIso',True)
           #   if self.gg(row):
           #       self.fill_histos(row,'ggNotIso',True)
              if row.jetVeto30_JetEnUp==1:
                  if RUN_OPTIMIZATION:
                     for  i in optimizer.compute_regions_1jet(row.tPt, row.mPt,row.tMtToPfMet_JetEnUp):
                        tmp=os.path.join("boostNotIso",i)
                        self.fill_histos(row,tmp,True)
                  if self.boost(row):
                        self.fill_histos(row,'boostNotIso',True)
         #     if self.boost(row):
         #         self.fill_histos(row,'boostNotIso',True)
              if (row.jetVeto30_JetEnUp>=2 and row.vbfJetVeto30_JetEnUp <= 0) :
                  if RUN_OPTIMIZATION:
                     for  i in optimizer.compute_regions_2jet(row.tPt, row.mPt,row.tMtToPfMet_JetEnUp,row.vbfMass_JetEnUp,row.vbfDeta_JetEnUp):
                        tmp=os.path.join("vbfNotIso",i)
                        self.fill_histos(row,tmp,True)
                  if self.vbf(row):
                        self.fill_histos(row,'vbfNotIso',True)
#              if self.vbf(row):
#                  self.fill_histos(row,'vbfNotIso',True)


            sel=True

    def finish(self):
        self.write_histos()
