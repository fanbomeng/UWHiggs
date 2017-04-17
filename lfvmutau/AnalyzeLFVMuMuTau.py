'''

Run LFV H->MuMuTau analysis in the mu+tau channel.

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
import weightMuMuTau
from math import sqrt, pi
import bTagSFrereco 
btagSys=0
#bTagSF=0
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

################################################################################
#### MC-DATA and PU corrections ################################################
################################################################################
pu_distributions = glob.glob(os.path.join(
#    'inputs', os.environ['jobid'], 'data_TauPlusX*pu.root'))
        'inputs', os.environ['jobid'], 'data_SingleMu*pu.root'))
#pu_corrector = PileupWeight.PileupWeight('MC_Spring16', *pu_distributions)
pu_corrector = PileupWeight.PileupWeight('MC_Moriond17', *pu_distributions)
#print "the path *************"
#print pu_distributions
#muon_pog_PFTight_2016 = MuonPOGCorrections.make_muon_pog_PFTight_2016BCD()
muon_pog_PFTight_2016 = MuonPOGCorrections.make_muon_pog_PFMedium_2016ReReco()
#muon_pog_TightIso_2016 = MuonPOGCorrections.make_muon_pog_TightIso_2016BCD()
muon_pog_TightIso_2016 = MuonPOGCorrections.make_muon_pog_TightIso_2016ReReco('Medium')
#muon_pog_IsoMu22oIsoTkMu22_2016 = MuonPOGCorrections.make_muon_pog_IsoMu22oIsoTkMu22_2016BCD()
muon_pog_IsoMu24oIsoTkMu24_2016 = MuonPOGCorrections.make_muon_pog_IsoMu24oIsoTkMu24_2016ReReco()

def mc_corrector_2016(row):
  pu = pu_corrector(row.nTruePU)
  m1tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m1Eta))[0]
  m2tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.m2Eta))[0]
  m1id = muon_pog_PFTight_2016(row.m1Pt,abs(row.m1Eta))
  m1iso = muon_pog_TightIso_2016(row.m1Pt,abs(row.m1Eta))
  m1_trg = muon_pog_IsoMu24oIsoTkMu24_2016(row.m1Pt,abs(row.m1Eta))
  m2id = muon_pog_PFTight_2016(row.m2Pt,abs(row.m2Eta))
  m2iso = muon_pog_TightIso_2016(row.m2Pt,abs(row.m2Eta))
#  m2_trg = muon_pog_IsoMu22oIsoTkMu22_2016(row.m2Pt,abs(row.m2Eta))

  #print "pu"
  #print str(pu)
  return pu*m1id*m1iso*m1_trg*m2id*m2iso*m1tracking*m2tracking#*m2_trg

mc_corrector = mc_corrector_2016

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

class AnalyzeLFVMuMuTau(MegaBase):
    tree = 'mmt/final/Ntuple'
    #tree = 'New_Tree'

    def __init__(self, tree, outfile, **kwargs):
        super(AnalyzeLFVMuMuTau, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        self.tree = MuMuTauTree.MuMuTauTree(tree)
        self.out = outfile
        self.histograms = {}


        # Use the cython wrapper
        target = os.path.basename(os.environ['megatarget'])
        #self.Metcorected=RecoilCorrector("TypeIPFMET_2016BCD.root")

        self.weighttarget=target.split(".",1)[0].replace("-","_")
        self.is_data = target.startswith('data_')
        self.is_dataG_H =(bool('Run2016H' in target) or bool('Run2016G' in target))
     #   print "*************"
     #   print self.is_data
        self.ls_Jets=('Jets' in target)
        self.ls_Wjets=("JetsToLNu" in target)
        self.ls_ZTauTau=("ZTauTau" in target)
        self.ls_DY=("DY" in target)
        self.is_ZeroJet=(('WJetsToLNu' in target)or('DYJetsToLL' in target)or('ZTauTauJetsToLL' in target))
        self.is_OneJet=('W1JetsToLNu' in target or('DY1JetsToLL' in target)or('ZTauTau1JetsToLL' in target))
        self.is_TwoJet=('W2JetsToLNu' in target or('DY2JetsToLL' in target)or('ZTauTau2JetsToLL' in target))
        self.is_ThreeJet=('W3JetsToLNu' in target or('DY3JetsToLL' in target)or('ZTauTau3JetsToLL' in target))
        self.is_FourJet=('W4JetsToLNu' in target or('DY4JetsToLL' in target)or('ZTauTau4JetsToLL' in target))
        self.is_embedded = ('Embed' in target)
        self.is_ZTauTau= ('ZTauTau' in target)
        self.is_ZMuMu= ('Zmumu' in target)
        self.is_DY= ('DY' in target)
        self.is_HToTauTau= ('HToTauTau' in target)
        self.is_HToMuTau= ('HToMuTau' in target)
        self.is_mc = not (self.is_data or self.is_embedded)
  #      if self.ls_DY or self.ls_ZTauTau:
  #         self.Z_reweight = ROOT.TFile.Open('zpt_weights_2016.root')
  #         self.Z_reweight_H=self.Z_reweight.Get('zptmass_histo')


    def begin(self):
        #names=["preselectionSS", "preselectionDecay0","preselectionLooseIsoDecay0", "preselectionVLooseIsoDecay0","preselectionVTightIsoDecay0","preselectionMediumIsoDecay0", "preselection0JetDecay0", "preselection1JetDecay0", "preselection2JetDecay0","preselectionDecay1","preselectionLooseIsoDecay1", "preselectionVLooseIsoDecay1","preselectionVTightIsoDecay1","preselectionMediumIsoDecay1", "preselection0JetDecay1", "preselection1JetDecay1", "preselection2JetDecay1","preselectionDecay10","preselectionLooseIsoDecay10", "preselectionVLooseIsoDecay10","preselectionVTightIsoDecay10","preselectionMediumIsoDecay10", "preselection0JetDecay10", "preselection1JetDecay10", "preselection2JetDecay10"]
        names=['preselection','preselectionEB','preselectionEE','preselectionVLooseIso','preselectionVLooseIsoEB','preselectionVLooseIsoEE',"preselectionDecay0","preselectionVLooseIsoDecay0","preselectionDecay1","preselectionVLooseIsoDecay1","preselectionDecay10","preselectionVLooseIsoDecay10","preselectionDecay0EB","preselectionVLooseIsoDecay0EB","preselectionDecay1EB","preselectionVLooseIsoDecay1EB","preselectionDecay10EB","preselectionVLooseIsoDecay10EB","preselectionDecay0EE","preselectionVLooseIsoDecay0EE","preselectionDecay1EE","preselectionVLooseIsoDecay1EE","preselectionDecay10EE","preselectionVLooseIsoDecay10EE",'preselection2_jetVBF0p2','preselectionVLooseIso2_jetVBF0p2','preselection2_jetEB','preselection2_jetEE','preselectionVLooseIso2_jetEB','preselectionVLooseIso2_jetEE','preselection2_jetVBF','preselectionVLooseIso2_jetVBF','preselection0JetEB','preselection0JetEE','preselection0JetVLooseIsoEB','preselection0JetVLooseIsoEE','preselection1JetEB','preselection1JetEE','preselection1JetVLooseIsoEB','preselection1JetVLooseIsoEE','preselection2Jet_ggEB','preselection2Jet_ggEE','preselection2Jet_ggVLooseIsoEB','preselection2Jet_ggVLooseIsoEE','preselection2Jet_VBFEB','preselection2Jet_VBFEE','preselection2Jet_VBFVLooseIsoEB','preselection2Jet_VBFVLooseIsoEE']
        namesize = len(names)
	for x in range(0,namesize):


      #      self.book(names[x], "weight", "Event weight", 100, 0, 5)
      #      self.book(names[x], "GenWeight", "Gen level weight", 200000 ,-1000000, 1000000)
      #      self.book(names[x], "genHTT", "genHTT", 1000 ,0,1000)
 
      #      self.book(names[x], "rho", "Fastjet #rho", 100, 0, 25)
      #      self.book(names[x], "nvtx", "Number of vertices", 100, -0.5, 100.5)
      #      self.book(names[x], "prescale", "HLT prescale", 21, -0.5, 20.5)

      #      self.book(names[x], "m1Pt", "Muon  Pt", 300,0,300)
      #      self.book(names[x], "m1Eta", "Muon  eta", 100, -2.5, 2.5)
      #      self.book(names[x], "m1Charge", "Muon Charge", 5, -2, 2)
      #      self.book(names[x], "m2Pt", "Muon  Pt", 300,0,300)
      #      self.book(names[x], "m2Eta", "Muon  eta", 100, -2.5, 2.5)
      #      self.book(names[x], "m2Charge", "Muon Charge", 5, -2, 2)


            self.book(names[x], "tPt", "Tau  Pt", 300,0,300)
            self.book(names[x], "tEta", "Tau  eta", 100, -2.5, 2.5)
            self.book(names[x], "abstEta", "abs Tau  eta", 100, 0, 2.5)
            self.book2(names[x], "tEta_tPt", "tEta_tPt", 100,-2.5,2.5,300, 0,300)
            self.book(names[x], "tDecayMode", "tDecayMode", 12,0,12)
      #      self.book(names[x], "tMtToPfMet_type1", "Tau MT (PF Ty1)", 200, 0, 200)
      #      self.book(names[x], "tCharge", "Tau  Charge", 5, -2, 2)
      #      self.book(names[x], "tJetPt", "Tau Jet Pt" , 500, 0 ,500)	    
      #      self.book(names[x], "tMass", "Tau  Mass", 1000, 0, 10)
      #      self.book(names[x], "tLeadTrackPt", "Tau  LeadTrackPt", 300,0,300)

      #  	       


    def correction(self,row):
	return mc_corrector(row)
	
    def fakeRateMethod(self,row,isoName):
        return getFakeRateFactor(row,isoName)

    def TauESC(self,row):
        if (not self.is_data) and (not self.ls_DY) and row.tZTTGenMatching==5:
#           print 'enter Tau ESC when require the ZTTGenMatching!!!!!!!!!!!!!!!!!!!!!'
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
       #    print "inside TauESC and then?"
           return (tau_Pt_C,MET_tPtC)
        elif self.ls_DY and row.isZmumu  and row.tZTTGenMatching<5 and row.tDecayMode==1:
               tau_Pt_C=1.015*row.tPt
               MET_tPtC=row.type1_pfMetEt-0.015*row.tPt
               return (tau_Pt_C,MET_tPtC)
        else:
           return (row.tPt,row.type1_pfMetEt)

    def fill_histos(self, row,name='gg', fakeRate=False, isoName="old"):
        histos = self.histograms
        weight=1.0
        if (not(self.is_data)):
#	   weight = row.GenWeight * self.correction(row) #apply gen and pu reweighting to MC
           btagweights=1
           if row.bjetCISVVeto30Medium==1:
              btagweights=bTagSFrereco.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0) if (row.jb1pt>-990 and row.jb1hadronflavor>-990) else 0
           if row.bjetCISVVeto30Medium==2:
              btagweights=bTagSFrereco.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0) if (row.jb1pt>-990 and row.jb1hadronflavor>-990 and row.jb2pt>-990 and row.jb2hadronflavor>-990) else 0
           if row.bjetCISVVeto30Medium>2:
              btagweights=0
           weight = row.GenWeight*self.WeightJetbin(row)* self.correction(row)*btagweights#*bTagSFrereco.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)#*self.WeightJetbin(row)
     #   if (fakeRate == True):
     #     weight=weight*self.fakeRateMethod(row,isoName) #apply fakerate method for given isolation definition
        if ((self.ls_DY and row.isZtautau) or self.is_HToTauTau or self.is_HToMuTau):
           if 'Loose' in name:
              weight=weight*0.99
           else:
              weight=weight*0.95
        if (self.is_DY and row.isZmumu  and row.tZTTGenMatching<5):
           weight=weight*getGenMfakeTSF(abs(row.tEta))
      #  if self.ls_DY or self.ls_ZTauTau:
      #     wtzpt=self.Z_reweight_H.GetBinContent(self.Z_reweight_H.GetXaxis().FindBin(row.genM),self.Z_reweight_H.GetYaxis().FindBin(row.genpT))
      #     weight=weight*wtzpt


      #  histos[name+'/weight'].Fill(weight)
      #  histos[name+'/GenWeight'].Fill(row.GenWeight)
      #  histos[name+'/genHTT'].Fill(row.genHTT)
      #  histos[name+'/rho'].Fill(row.rho, weight)
      #  histos[name+'/nvtx'].Fill(row.nvtx, weight)
      #  histos[name+'/prescale'].Fill(row.doubleMuPrescale, weight)

      #  
      #  histos[name+'/m1Pt'].Fill(row.m1Pt, weight)
      #  histos[name+'/m1Eta'].Fill(row.m1Eta, weight)
      #  histos[name+'/m1Charge'].Fill(row.m1Charge, weight)
      #  histos[name+'/m2Pt'].Fill(row.m2Pt, weight)
      #  histos[name+'/m2Eta'].Fill(row.m2Eta, weight)
      #  histos[name+'/m2Charge'].Fill(row.m2Charge, weight)
        #histos[name+'/tPt'].Fill(row.tPt, weight)
        histos[name+'/tPt'].Fill(self.tau_Pt_C, weight)
        histos[name+'/tEta'].Fill(row.tEta, weight)
        histos[name+'/abstEta'].Fill(abs(row.tEta), weight)
        histos[name+'/tEta_tPt'].Fill(abs(row.tEta),self.tau_Pt_C, weight)
        histos[name+'/tDecayMode'].Fill(row.tDecayMode,weight)
      #  histos[name+'/tMtToPfMet_type1'].Fill(row.tMtToPfMet_type1,weight)
      #  histos[name+'/tCharge'].Fill(row.tCharge, weight)
      #  histos[name+'/tJetPt'].Fill(row.tJetPt, weight)

      #  histos[name+'/tMass'].Fill(row.tMass,weight)
      #  histos[name+'/tLeadTrackPt'].Fill(row.tLeadTrackPt,weight)
		       

        #histos[name+'/tAgainstMuonLoose'].Fill(row.tAgainstMuonLoose,weight)
      #  histos[name+'/tAgainstMuonLoose3'].Fill(row.tAgainstMuonLoose3,weight)
      #  #histos[name+'/tAgainstMuonMedium'].Fill(row.tAgainstMuonMedium,weight)
      #  #histos[name+'/tAgainstMuonTight'].Fill(row.tAgainstMuonTight,weight)
      #  histos[name+'/tAgainstMuonTight3'].Fill(row.tAgainstMuonTight3,weight)

      #  #histos[name+'/tAgainstMuonLooseMVA'].Fill(row.tAgainstMuonLooseMVA,weight)
      #  #histos[name+'/tAgainstMuonMediumMVA'].Fill(row.tAgainstMuonMediumMVA,weight)
      #  #histos[name+'/tAgainstMuonTightMVA'].Fill(row.tAgainstMuonTightMVA,weight)

      #  histos[name+'/tDecayModeFinding'].Fill(row.tDecayModeFinding,weight)
      #  histos[name+'/tDecayModeFindingNewDMs'].Fill(row.tDecayModeFindingNewDMs,weight)

      #  histos[name+'/tByLooseCombinedIsolationDeltaBetaCorr3Hits'].Fill(row.tByLooseCombinedIsolationDeltaBetaCorr3Hits,weight)
      #  histos[name+'/tByMediumCombinedIsolationDeltaBetaCorr3Hits'].Fill(row.tByMediumCombinedIsolationDeltaBetaCorr3Hits,weight)
      #  histos[name+'/tByTightCombinedIsolationDeltaBetaCorr3Hits'].Fill(row.tByTightCombinedIsolationDeltaBetaCorr3Hits,weight)


      #  histos[name+'/LT'].Fill(row.LT,weight)


      #  histos[name+'/type1_pfMetEt'].Fill(row.type1_pfMetEt,weight)

      #  histos[name+'/m1_t_Mass'].Fill(row.m1_t_Mass,weight)
      #  histos[name+'/m1_t_Pt'].Fill(row.m1_t_Pt,weight)
      #  histos[name+'/m1_t_DR'].Fill(row.m1_t_DR,weight)
      #  histos[name+'/m1_t_DPhi'].Fill(row.m1_t_DPhi,weight)
      #  histos[name+'/m1_t_SS'].Fill(row.m1_t_SS,weight)
      #  histos[name+'/m2_t_Mass'].Fill(row.m2_t_Mass,weight)
      #  histos[name+'/m2_t_Pt'].Fill(row.m2_t_Pt,weight)
      #  histos[name+'/m2_t_DR'].Fill(row.m2_t_DR,weight)
      #  histos[name+'/m2_t_DPhi'].Fill(row.m2_t_DPhi,weight)
      #  histos[name+'/m2_t_SS'].Fill(row.m2_t_SS,weight)
      #  histos[name+'/m1_m2_Mass'].Fill(row.m1_m2_Mass,weight)
      #  #histos[name+'/m_t_ToMETDPhi_Ty1'].Fill(row.m_t_ToMETDPhi_Ty1,weight)

      #  histos[name+'/m1PixHits'].Fill(row.m1PixHits, weight)
      #  histos[name+'/m1JetBtag'].Fill(row.m1JetBtag, weight)
      #  histos[name+'/m2PixHits'].Fill(row.m2PixHits, weight)
      #  histos[name+'/m2JetBtag'].Fill(row.m2JetBtag, weight)

      #  histos[name+'/muVetoPt5IsoIdVtx'].Fill(row.muVetoPt5IsoIdVtx, weight)
      #  histos[name+'/muVetoPt15IsoIdVtx'].Fill(row.muVetoPt15IsoIdVtx, weight)
      #  histos[name+'/tauVetoPt20Loose3HitsVtx'].Fill(row.tauVetoPt20Loose3HitsVtx, weight)
      #  histos[name+'/eVetoMVAIso'].Fill(row.eVetoMVAIso, weight)
#        histos[name+'/jetVeto30'].Fill(row.jetVeto30, weight)
#	histos[name+'/jetVeto30'].Fill(row.jetVeto30,weight)
#        histos[name+'/jetVeto30Eta3'].Fill(row.jetVeto30Eta3,weight)
        #histos[name+'/jetVeto30PUCleanedLoose'].Fill(row.jetVeto30PUCleanedLoose, weight)
        #histos[name+'/jetVeto30PUCleanedTight'].Fill(row.jetVeto30PUCleanedTight, weight)

  #	histos[name+'/m1RelPFIsoDBDefault'].Fill(row.m1RelPFIsoDBDefault, weight)
  #        histos[name+'/m2RelPFIsoDBDefault'].Fill(row.m2RelPFIsoDBDefault, weight)
  #        
  #	histos[name+'/m1PhiMtPhi'].Fill(deltaPhi(row.m1Phi,row.tPhi),weight)
  #        histos[name+'/m1PhiMETPhiType1'].Fill(deltaPhi(row.m1Phi,row.type1_pfMetPhi),weight)
  #        histos[name+'/m2PhiMtPhi'].Fill(deltaPhi(row.m2Phi,row.tPhi),weight)
  #        histos[name+'/m2PhiMETPhiType1'].Fill(deltaPhi(row.m2Phi,row.type1_pfMetPhi),weight)
  #        histos[name+'/tPhiMETPhiType1'].Fill(deltaPhi(row.tPhi,row.type1_pfMetPhi),weight)
  #	histos[name+'/tDecayMode'].Fill(row.tDecayMode, weight)
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
        if (self.is_ZTauTau and not row.isZtautau):
            return False
        if (not self.is_ZTauTau and row.isZtautau):
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
        #if row.tPt<30 :
        #    return False
        if self.tau_Pt_C<30 :
            return False
        if abs(row.tEta)>=2.3:
            return False
        return True

    def gg(self,row):
       if row.mPt < 25:    
           return False
       if deltaPhi(row.mPhi, row.tPhi) <2.7:
           return False
       if deltaPhi(row.tPhi,row.type1_pfMetPhi) > 3.0:
	   return False
       if row.tPt < 30:
           return False
       if row.tMtToPfMet_type1 > 75:
           return False
       if row.jetVeto30!=0:
           return False
       return True

    def boost(self,row):
          if row.jetVeto30!=1:
            return False
          if row.mPt < 25:
                return False
          if row.tPt < 30:
                return False
          if row.tMtToPfMet_type1 > 105:
                return False
          if deltaPhi(row.tPhi,row.type1_pfMetPhi) > 3.0:
                return False

          return True

    def vbfAntiTight(self,row):
        if row.tPt < 30:
                return False
        if row.mPt < 25:
		return False
        if row.tMtToPfMet_type1 > 75:
                return False
        if row.jetVeto30 < 2:
            return False
	if(row.vbfNJets<2):
	    return False
	if(abs(row.vbfDetaZTT)>3.5):
	    return False
        if row.vbfMassZTT > 500:
	    return False
        if row.vbfJetVeto30 > 0:
            return False
        return True

    def vbf(self,row):
        if row.tPt < 30:
                return False
        if row.mPt < 25:
                return False
        if row.tMtToPfMet_type1 > 75:
                return False
        if row.jetVeto30 < 2:
            return False
        if(row.vbfNJets<2):
            return False
        if(abs(row.vbfDetaZTT)<3.2):
            return False
        if row.vbfMassZTT < 500:
            return False
        if row.vbfJetVeto30 > 0:
            return False
        return True


    def oppositesign(self,row):
	if row.m1Charge*row.m2Charge!=-1:
            return False
	return True

    #def obj1_id(self, row):
    #    return bool(row.mPFIDTight)  

    def obj1_idICHEP(self,row):
         if (row.m1IsGlobal and (row.m1NormalizedChi2 < 3) and (row.m1Chi2LocalPosition < 12) and (row.m1TrkKink < 20)):
                goodGlobal1=True
         else:
                goodGlobal1=False
         if (row.m2IsGlobal and (row.m2NormalizedChi2 < 3) and (row.m2Chi2LocalPosition < 12) and (row.m2TrkKink < 20)):
                goodGlobal2=True
         else:
                goodGlobal2=False
         return ((row.m1PFIDLoose and row.m1ValidFraction > 0.49 and ((goodGlobal1 and row.m1SegmentCompatibility > 0.303) or row.m1SegmentCompatibility > 0.451)) and (row.m2PFIDLoose and row.m2ValidFraction > 0.49 and ((goodGlobal2 and row.m2SegmentCompatibility > 0.303) or row.m2SegmentCompatibility > 0.451)))

    def obj1_idM(self,row):

        goodglob1=row.m1IsGlobal and row.m1NormalizedChi2 < 3 and row.m1Chi2LocalPosition < 12 and row.m1TrkKink < 20
        isICHEPMedium1 = row.m1PFIDLoose and row.m1ValidFraction> 0.8 and row.m1SegmentCompatibility >  (0.303 if goodglob1 else 0.451);
        goodglob2=row.m2IsGlobal and row.m2NormalizedChi2 < 3 and row.m2Chi2LocalPosition < 12 and row.m2TrkKink < 20
        isICHEPMedium2 = row.m2PFIDLoose and row.m2ValidFraction> 0.8 and row.m2SegmentCompatibility >  (0.303 if goodglob2 else 0.451);
        return isICHEPMedium1 and isICHEPMedium2 
#    def obj1_idICHEP(self,row):
#	 if (row.m1IsGlobal and (row.m1NormalizedChi2 < 3) and (row.m1Chi2LocalPosition < 12) and (row.m1TrkKink < 20)):
#		goodGlobal1=True
#	 else:
#		goodGlobal1=False
#         if (row.m2IsGlobal and (row.m2NormalizedChi2 < 3) and (row.m2Chi2LocalPosition < 12) and (row.m2TrkKink < 20)):
#                goodGlobal2=True
#         else:
#                goodGlobal2=False
#    	 return ((row.m1PFIDLoose and row.m1ValidFraction > 0.49 and ((goodGlobal1 and row.m1SegmentCompatibility > 0.303) or row.m1SegmentCompatibility > 0.451)) and (row.m2PFIDLoose and row.m2ValidFraction > 0.49 and ((goodGlobal2 and row.m2SegmentCompatibility > 0.303) or row.m2SegmentCompatibility > 0.451)))

    def obj1_id(self,row):
         return (row.m1PixHits>0 and row.m2PixHits>0 and row.m1JetPFCISVBtag < 0.8 and row.m2JetPFCISVBtag < 0.8 and row.m1PVDZ < 0.2 and row.m2PVDZ < 0.2 and row.m1PFIDTight and row.m2PFIDTight)

    #def m1m2Mass(self,row):
    #    if row.m1_m2_Mass < 76:
    #       return False
    #    if row.m1_m2_Mass > 106:
    #       return False
    #    return True
    def m1m2Mass(self,row):
        if row.m1_m2_Mass < 76:
           return False
        if row.m1_m2_Mass > 106:
           return False
        return True
    def WeightJetbin(self,row):
        weighttargettmp=self.weighttarget
        if self.ls_Jets:
           if row.numGenJets>4:
              print "Error***********************Error***********"
           if self.ls_Wjets:    
              if row.numGenJets == 0:
                 return  1.0/(eval("weightMuMuTau."+"WJetsToLNu_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))    
              else:
                 return 1.0/(eval("weightMuMuTau."+"W"+str(int(row.numGenJets))+"JetsToLNu_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
           if self.ls_ZTauTau:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightMuMuTau."+"ZTauTauJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
              else:
                 return 1.0/(eval("weightMuMuTau."+"ZTauTau"+str(int(row.numGenJets))+"JetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
           if self.ls_DY:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightMuMuTau."+"DYJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
              else:
                 return 1.0/(eval("weightMuMuTau."+"DY"+str(int(row.numGenJets))+"JetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
        else:
              return 1.0/(eval("weightMuMuTau."+self.weighttarget))
#    def obj2_id(self, row):
#	return  row.tAgainstElectronLooseMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding and row.tPVDZ < 0.2 and row.tMuonIdIsoVtxOverlap == 0 and row.tElecOverlap == 0
    def obj2_id(self, row):
        #return  row.tAgainstElectronMediumMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding
        return  row.tAgainstElectronVLooseMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding

#    def vetos(self,row):
#		return  ((row.eVetoZTTp001dxyzR0 == 0) and (row.dimuonVeto==1) and (row.muVetoZTTp001dxyzR0 < 3) and (row.tauVetoPt20Loose3HitsVtx<1) )
    def vetos(self,row):
                return  (bool (row.muVetoPt5IsoIdVtx<1) and bool (row.eVetoMVAIso<1) and bool (row.tauVetoPt20Loose3HitsVtx<1) )
    #def obj1_iso(self, row):
    #    return bool(row.mRelPFIsoDBDefault <0.12)
    def tauinEB(self,row):
        return bool(abs(row.tEta)<1.479)   
    def obj1_iso(self,row):
         return bool(row.m1RelPFIsoDBDefaultR04 <0.15 and row.m2RelPFIsoDBDefaultR04 <0.15)

    def obj2_iso(self,row):
         return bool(row.tByTightIsolationMVArun2v1DBoldDMwLT)

    #def obj2_iso(self, row):
    #    return  row.tByTightCombinedIsolationDeltaBetaCorr3Hits

    def obj2_mediso(self, row):
	 return bool(row.tByMediumIsolationMVArun2v1DBoldDMwLT)

    def obj2_vtightiso(self,row):
         return bool(row.tByVTightIsolationMVArun2v1DBoldDMwLT)

    def obj2_looseiso(self,row):
         return bool(row.tByLooseIsolationMVArun2v1DBoldDMwLT)

    def obj2_vlooseiso(self,row):
         return bool(row.tByVLooseIsolationMVArun2v1DBoldDMwLT)

    def obj1_antiiso(self, row):
        return bool(row.m1RelPFIsoDBDefault >0.2 and row.m2RelPFIsoDBDefault >0.2) 

        return row.tByLooseCombinedIsolationDeltaBetaCorr3Hits

    def DecayMode0(self,row):
      return bool(row.tDecayMode==0)

    def DecayMode1(self,row):
      return bool(row.tDecayMode==1)

    def DecayMode10(self,row):
      return bool(row.tDecayMode==10)


    def process(self):
        event =0
        sel=False
        for row in self.tree:
            if event!=row.evt:   # This is just to ensure we get the (Mu,Tau) with the highest Pt
                event=row.evt    # In principle the code saves all the MU+Tau posibilities, if an event has several combinations
                sel = False      # it will save them all.
            if sel==True:
                continue

            #if self.is_data and not self.presel(row): #only apply trigger selections for data   
            #    continue
            if not self.presel(row): #only apply trigger selections for data   
                continue
       #     if not self.selectZtt(row):
       #         continue
            if not self.obj2_id (row):
                continue
            self.tau_Pt_C,self.Met_C_new=self.TauESC(row)
            if not self.kinematics(row): 
                continue
#            print "the new TauPt values*****************%f" %self.tau_Pt_C
#            if  row.bjetCISVVeto30Medium:
#                   continue 
            if not self.obj1_iso(row):
                continue
    #        if not self.obj1_idICHEP(row):
    #            continue
            if self.is_dataG_H or (not self.is_data):
#               print self.target1 
#               print "the bool valueGH %d" %(self.is_dataG_H or (not self.is_data))
               if not self.obj1_idM(row):
                   continue
            else:
#               print self.target1 
#               print "the bool value %d" %(self.is_dataG_H or (not self.is_data))
               if not self.obj1_idICHEP(row):
                   continue
            if not self.vetos (row):
                continue
            if not self.m1m2Mass (row):
                continue

            if (self.is_data):
               if  row.bjetCISVVeto30Medium:
                   continue
            if self.obj2_iso(row) and self.oppositesign(row):
                self.fill_histos(row,'preselection',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionEB',False)
                else:
                    self.fill_histos(row,'preselectionEE',False)
                if row.jetVeto30==0:
                   if self.tauinEB(row): 
                      self.fill_histos(row,'preselection0JetEB',False)
                   else:
                      self.fill_histos(row,'preselection0JetEE',False)
                if row.jetVeto30==1:
                   if self.tauinEB(row): 
                      self.fill_histos(row,'preselection1JetEB',False)
                   else:
                      self.fill_histos(row,'preselection1JetEE',False)
                if row.jetVeto30==2:
                   if self.tauinEB(row):
                      self.fill_histos(row,'preselection2_jetEB',False)
                   else:
                      self.fill_histos(row,'preselection2_jetEE',False)
                   if row.vbfMass <550:
                      if self.tauinEB(row): 
                         self.fill_histos(row,'preselection2Jet_ggEB',False)
                      else:
                         self.fill_histos(row,'preselection2Jet_ggEE',False)
                   else:
                      if self.tauinEB(row): 
                         self.fill_histos(row,'preselection2Jet_VBFEB',False)
                      else:
                         self.fill_histos(row,'preselection2Jet_VBFEE',False)
                    

            if self.obj2_vlooseiso(row) and self.oppositesign(row):
                self.fill_histos(row,'preselectionVLooseIso',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionVLooseIsoEB',False)
                else:
                    self.fill_histos(row,'preselectionVLooseIsoEE',False)
                if row.jetVeto30==0:
                   if self.tauinEB(row): 
                      self.fill_histos(row,'preselection0JetVLooseIsoEB',False)
                   else:
                      self.fill_histos(row,'preselection0JetVLooseIsoEE',False)
                if row.jetVeto30==1:
                   if self.tauinEB(row): 
                      self.fill_histos(row,'preselection1JetVLooseIsoEB',False)
                   else:
                      self.fill_histos(row,'preselection1JetVLooseIsoEE',False)
                if row.jetVeto30==2:
                   if self.tauinEB(row): 
                         self.fill_histos(row,'preselectionVLooseIso2_jetEB',False)
                   else:
                         self.fill_histos(row,'preselectionVLooseIso2_jetEE',False)
                   if row.vbfMass <550:
                      if self.tauinEB(row): 
                         self.fill_histos(row,'preselection2Jet_ggVLooseIsoEB',False)
                      else:
                         self.fill_histos(row,'preselection2Jet_ggVLooseIsoEE',False)
                   else:
                      if self.tauinEB(row): 
                         self.fill_histos(row,'preselection2Jet_VBFVLooseIsoEB',False)
                      else:
                         self.fill_histos(row,'preselection2Jet_VBFVLooseIsoEE',False)


            if self.DecayMode0(row):           
              if self.obj2_iso(row) and self.oppositesign(row):  
 
                self.fill_histos(row,'preselectionDecay0',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionDecay0EB',False)
                else:
                    self.fill_histos(row,'preselectionDecay0EE',False)
              #  if row.jetVeto30==0:
              #    self.fill_histos(row,'preselection0JetDecay0',False)
              #  if row.jetVeto30==1:
              #    self.fill_histos(row,'preselection1JetDecay0',False)
              #  if row.jetVeto30==2:
              #    self.fill_histos(row,'preselection2JetDecay0',False)
 
            #  if self.obj2_looseiso(row) and self.oppositesign(row):
            #    self.fill_histos(row,'preselectionLooseIsoDecay0',False)
        
            #  if self.obj2_mediso(row) and self.oppositesign(row):
            #    self.fill_histos(row,'preselectionMediumIsoDecay0',False)
 
              if self.obj2_vlooseiso(row) and self.oppositesign(row):
                self.fill_histos(row,'preselectionVLooseIsoDecay0',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionVLooseIsoDecay0EB',False)
                else:
                    self.fill_histos(row,'preselectionVLooseIsoDecay0EE',False)
 
            #  if self.obj2_vtightiso(row) and self.oppositesign(row):
            #    self.fill_histos(row,'preselectionVTightIsoDecay0',False)

            if self.DecayMode1(row):
              if self.obj2_iso(row) and self.oppositesign(row):

                self.fill_histos(row,'preselectionDecay1',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionDecay1EB',False)
                else:
                    self.fill_histos(row,'preselectionDecay1EE',False)
             #   if row.jetVeto30==0:
             #     self.fill_histos(row,'preselection0JetDecay1',False)
             #   if row.jetVeto30==1:
             #     self.fill_histos(row,'preselection1JetDecay1',False)
             #   if row.jetVeto30==2:
             #     self.fill_histos(row,'preselection2JetDecay1',False)

           #   if self.obj2_looseiso(row) and self.oppositesign(row):
           #     self.fill_histos(row,'preselectionLooseIsoDecay1',False)
  
           #   if self.obj2_mediso(row) and self.oppositesign(row):
           #     self.fill_histos(row,'preselectionMediumIsoDecay1',False)

              if self.obj2_vlooseiso(row) and self.oppositesign(row):
                self.fill_histos(row,'preselectionVLooseIsoDecay1',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionVLooseIsoDecay1EB',False)
                else:
                    self.fill_histos(row,'preselectionVLooseIsoDecay1EE',False)

           #   if self.obj2_vtightiso(row) and self.oppositesign(row):
           #     self.fill_histos(row,'preselectionVTightIsoDecay1',False)

            if self.DecayMode10(row):
              if self.obj2_iso(row) and self.oppositesign(row):

                self.fill_histos(row,'preselectionDecay10',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionDecay10EB',False)
                else:
                    self.fill_histos(row,'preselectionDecay10EE',False)
            #    if row.jetVeto30==0:
            #      self.fill_histos(row,'preselection0JetDecay10',False)
            #    if row.jetVeto30==1:
            #      self.fill_histos(row,'preselection1JetDecay10',False)
            #    if row.jetVeto30==2:
            #      self.fill_histos(row,'preselection2JetDecay10',False)

           #   if self.obj2_looseiso(row) and self.oppositesign(row):
           #     self.fill_histos(row,'preselectionLooseIsoDecay10',False)
  
           #   if self.obj2_mediso(row) and self.oppositesign(row):
           #     self.fill_histos(row,'preselectionMediumIsoDecay10',False)

              if self.obj2_vlooseiso(row) and self.oppositesign(row):
                self.fill_histos(row,'preselectionVLooseIsoDecay10',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionVLooseIsoDecay10EB',False)
                else:
                    self.fill_histos(row,'preselectionVLooseIsoDecay10EE',False)

           #   if self.obj2_vtightiso(row) and self.oppositesign(row):
           #     self.fill_histos(row,'preselectionVTightIsoDecay10',False)



            sel=True

    def finish(self):
        self.write_histos()
