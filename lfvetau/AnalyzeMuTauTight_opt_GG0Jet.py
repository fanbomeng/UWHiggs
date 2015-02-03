'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''
from ETauTree import ETauTree
#import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from FinalStateAnalysis.MetaData.data_styles import data_styles
from FinalStateAnalysis.PlotTools.BlindView import BlindView,  blind_in_range
import glob
import os
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.H2TauCorrections as H2TauCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import ROOT
import numpy as np

isZeroJets = bool ('true' in os.environ['zeroJet']) #is NUP==5
print "isZeroJets:", isZeroJets

###### Because I need to add a bunch more branches to the ntuple...
from math import sqrt, pi

def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
      return PHI
  else:
      return 2*pi-PHI

################################################################################
#### MC-DATA and PU corrections ################################################
################################################################################

# Determine MC-DATA corrections
is7TeV = bool('7TeV' in os.environ['jobid'])
print "Is 7TeV:", is7TeV

# Make PU corrector from expected data PU distribution
# PU corrections .root files from pileupCalc.py
pu_distributions = glob.glob(os.path.join(
#    'inputs', os.environ['jobid'], 'data_TauPlusX*pu.root'))
	'inputs', os.environ['jobid'], 'data_SingleMu*pu.root'))
pu_corrector = PileupWeight.PileupWeight(
    'S6' if is7TeV else 'S10', *pu_distributions)

muon_pog_PFTight_2012 = MuonPOGCorrections.make_muon_pog_PFTight_2012()
muon_pog_PFRelIsoDB02_2012 = MuonPOGCorrections.make_muon_pog_PFRelIsoDB012_2012()
muon_pog_IsoMu24eta2p1_2012 = MuonPOGCorrections.make_muon_pog_IsoMu24eta2p1_2012()


# Get object ID and trigger corrector functions
def mc_corrector_2012(row):
    if row.run > 2:
        return 1
    pu = pu_corrector(row.nTruePU)
    m1id = muon_pog_PFTight_2012(row.mPt, row.mEta)
    m1iso = muon_pog_PFRelIsoDB02_2012(row.mPt, row.mEta)
#    m_trg = H2TauCorrections.correct_mueg_mu_2012(row.mPt, row.mAbsEta)
    m_trg = muon_pog_IsoMu24eta2p1_2012(row.mPt, row.mAbsEta)
    return pu*m1id*m1iso*m_trg

# Determine which set of corrections to use
mc_corrector = mc_corrector_2012

class AnalyzeMuTauTight_opt_GG0Jet(MegaBase):
    tree = 'New_Tree'

    def __init__(self, tree, outfile, **kwargs):
        super(AnalyzeMuTauTight_opt_GG0Jet, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        self.tree = ETauTree(tree)
     #   self.tree = MuTauTree.MuTauTree(tree)
        self.out = outfile
        # Histograms for each category
        self.histograms = {}
        self.is7TeV = '7TeV' in os.environ['jobid']

    def begin(self):
      #  self.book("Yield", "Yield_mPt", "by Mu Pt", 100, 0, 100)
        self.book("Yield", "Yield_ePt", "by e Pt", 100, 0, 100)
      #  self.book("Yield", "Yield_tPt", "by Tau Pt", 100, 0, 100)
      #  self.book("Yield", "Yield_tMetMT", "by Tau MET MT", 100, 0, 100)
      #  self.book("Yield", "Yield_mMetMT", "by Mu MET MT", 100, 0, 100)
      #  self.book("Yield", "Yield_tMetPhi", "by Tau MET dPHI", 35, 0, 3.5)
      #  self.book("Yield", "Yield_mMetPhi", "by Mu MET dPHI", 35, 0, 3.5)
      #  self.book("Yield", "Yield_mtPhi", "by Tau Mu dPHI", 35, 0, 3.5)
    
    def correction(self, row):
        return mc_corrector(row)

    def fill_yield(self, row, histo, value):
        histos = self.histograms
       # weight = self.correction(row)
        histos['Yield/Yield_'+histo].Fill(value,0)

    def presel(self, row):
	if not row.isoMu24eta2p1Pass:
            return False
        if row.jetVeto30 != 0:
            return False

        if isZeroJets:
            if row.NUP != 5:
                return False

        return True

    def kinematics(self, row):
#        if row.mPt < 30:
#            return False
        if abs(row.mEta) >= 2.1:
            return False
        if row.tPt<20 :
            return False
        if abs(row.tEta)>=2.3 :
            return False
        return True

    def kin_mPt(self, row):
      if row.mPt < 45:
        return False
      return True

#    def ggtight(self,row):
#       if row.tPt < 40:
#          return False
#
#       if row.tMtToPfMet_Ty1>20:
#          return False
#       if row.mMtToPfMet_Ty1<30:
#          return False        
#
#       if (deltaPhi(row.tPhi,row.pfMetPhi)>0.3):
#          return False
#       if (deltaPhi(row.mPhi,row.pfMetPhi)<2.5):
#          return False        
#       if (deltaPhi(row.mPhi,row.tPhi)<2.5):    
#          return False
#       return True	

## break up gg cuts to preserve order

    def ggtPt(self, row):
       if row.tPt < 35:
          return False
       return True
       
    def ggtMtToPfMet(self, row):
      if row.tMtToPfMet_Ty1>80:
        return False
      return True
     
    def ggmMtToPfMet(self, row):
      if row.mMtToPfMet_Ty1<0:
        return False
      return True
    
    def ggtMetPhi(self, row):
      if (deltaPhi(row.tPhi,row.pfMetPhi)>3.3):
        return False
      return True
    
    def ggmMetPhi(self, row):
      if (deltaPhi(row.mPhi,row.pfMetPhi)<0):
        return False
      return True

    def ggmtPhi(self, row):
      if (deltaPhi(row.mPhi,row.tPhi)<2.7):
        return False
      return True

    def ggWindow(self, row):
      if row.m_t_Mass > 140 or row.m_t_Mass < 70:
        return False
      return True

## make optimization func for each cut
    def opt_mPt(self, row, value):
      if row.ePt < value:
        return False
      return True

    def opt_tPt(self, row, value):
      if row.tPt < value:
        return False
      return True

    def opt_tMtToPfMet(self, row, value):
      if row.tMtToPfMet_Ty1>value:
        return False
      return True

    def opt_mMtToPfMet(self, row, value):
      if row.mMtToPfMet_Ty1<value:
        return False
      return True

    def opt_tMetPhi(self, row, value):
      if (deltaPhi(row.tPhi,row.pfMetPhi)>value):
        return False
      return True
    
    def opt_mMetPhi(self, row, value):
      if (deltaPhi(row.mPhi,row.pfMetPhi)<value):
        return False
      return True
    
    def opt_mtPhi(self, row, value):
      if (deltaPhi(row.mPhi,row.tPhi)<value):
        return False
      return True

    def oppositesign(self,row):
	if row.mCharge*row.tCharge!=-1:
            return False
	return True

    def obj1_id(self, row):
        return bool(row.mPFIDTight)  and bool(abs(row.mDZ) < 0.2) 

    def obj2_id(self, row):
	return  row.tAntiElectronLoose and row.tAntiMuonTight2 and row.tDecayFinding

    def vetos(self,row):
	return bool (row.muVetoPt5IsoIdVtx<1) and bool (row.eVetoCicTightIso<1) 

    def obj1_iso(self, row):
        return bool(row.mRelPFIsoDB <0.12)

    def obj2_iso(self, row):
        return  row.tTightIso3Hits

    def obj1_antiiso(self, row):
        return bool(row.mRelPFIsoDB >0.2) 

    def obj2_antiiso(self, row):
        return  not row.tLooseIso

    def process(self):
      event =0
      sel=False
      for row in self.tree:

        if event!=row.evt:   # This is just to ensure we get the (Mu,Tau) with the highest Pt
          event=row.evt    # In principle the code saves all the MU+Tau posibilities, if an event has several combinations
          sel = False      # it will save them all.
          if sel==True:
            continue 
          
          if not self.presel(row):
            continue

          for cutValue in range(1, 81, 1):
            if self.opt_mPt(row, cutValue):
            #  if self.kinematics(row) and self.obj1_id(row) and self.obj2_id(row) and self.vetos(row):
            #    if self.ggtPt(row) and self.ggtMtToPfMet(row) and self.ggmMtToPfMet(row) and self.ggtMetPhi(row) and self.ggmMetPhi(row) and self.ggmtPhi(row):
             #     if self.obj1_iso(row) and self.obj2_iso(row) and self.oppositesign(row) and self.ggWindow(row):
                    self.fill_yield(row, 'mPt', cutValue)  

       #   if not self.kin_mPt(row):
       #     continue
       #   if not self.kinematics(row):
       #     continue
       #   if not self.obj1_id(row): 
       #     continue
       #   if not self.obj2_id(row):
       #     continue
       #   if not self.vetos(row):
       #     continue

          sel = True


    #      for cutValue in range(1, 81, 1):
    #        if self.opt_tPt(row, cutValue):
    #          if self.ggtMtToPfMet(row) and self.ggmMtToPfMet(row) and self.ggtMetPhi(row) and self.ggmMetPhi(row) and self.ggmtPhi(row):
    #            if self.obj1_iso(row) and self.obj2_iso(row) and self.oppositesign(row) and self.ggWindow(row):
    #              self.fill_yield(row, 'tPt', cutValue)
                
    #      for cutValue in range(1, 100, 1):
    #        if self.ggtPt(row):
    #          if self.opt_tMtToPfMet(row, cutValue):
    #            if self.ggmMtToPfMet(row) and self.ggtMetPhi(row) and self.ggmMetPhi(row) and self.ggmtPhi(row):
    #              if self.obj1_iso(row) and self.obj2_iso(row) and self.oppositesign(row) and self.ggWindow(row):
    #                self.fill_yield(row, 'tMetMT', cutValue)
    #        
    #      for cutValue in range(1, 81, 1):
    #        if self.ggtPt(row) and self.ggtMtToPfMet(row):
    #          if self.opt_mMtToPfMet(row, cutValue):
    #            if self.ggtMetPhi(row) and self.ggmMetPhi(row) and self.ggmtPhi(row):
    #              if self.obj1_iso(row) and self.obj2_iso(row) and self.oppositesign(row) and self.ggWindow(row):
    #                self.fill_yield(row, 'mMetMT', cutValue)

     #     for cutValue in range(1, 35, 1):
     #       if self.ggtPt(row) and self.ggtMtToPfMet(row) and self.ggmMtToPfMet(row):
     #         if self.opt_tMetPhi(row, cutValue/10.0):
     #           if self.ggmMetPhi(row) and self.ggmtPhi(row):
     #             if self.obj1_iso(row) and self.obj2_iso(row) and self.oppositesign(row) and self.ggWindow(row):
     #               self.fill_yield(row, 'tMetPhi', cutValue/10.0-0.001)

     #     for cutValue in range(1, 35, 1):
     #       if self.ggtPt(row) and self.ggtMtToPfMet(row) and self.ggmMtToPfMet(row) and self.ggtMetPhi(row):
     #         if self.opt_mMetPhi(row, cutValue/10.0):
     #           if self.ggmtPhi(row):
     #             if self.obj1_iso(row) and self.obj2_iso(row) and self.oppositesign(row) and self.ggWindow(row):
     #               self.fill_yield(row, 'mMetPhi', cutValue/10.0-0.001)

     #     for cutValue in range(1, 35, 1):
     #       if self.ggtPt(row) and self.ggtMtToPfMet(row) and self.ggmMtToPfMet(row) and self.ggtMetPhi(row) and self.ggmMetPhi(row):
     #         if self.opt_mtPhi(row, cutValue/10.0):
     #           if self.obj1_iso(row) and self.obj2_iso(row) and self.oppositesign(row) and self.ggWindow(row):
     #             self.fill_yield(row, 'mtPhi', cutValue/10.0-0.001)

            
    def finish(self):
        self.write_histos()

