'''

Run LFV H->MuMuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import EETauTree

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import FinalStateAnalysis.TagAndProbe.EGammaPOGCorrections as EGammaPOGCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import ROOT
import math
import weightMuMuTauNew
import ETAUMCcorrection
#import weightEETau
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
        'inputs', os.environ['jobid'], 'data_SingleElectron*pu.root'))
#pu_corrector = PileupWeight.PileupWeight('MC_Spring16', *pu_distributions)
pu_corrector = PileupWeight.PileupWeight('MC_Moriond17', *pu_distributions)
#eId_corrector = EGammaPOGCorrections.make_egamma_pog_electronID_MORIOND2017( 'nontrigWP80')
#erecon_corrector=EGammaPOGCorrections.make_egamma_pog_recon_MORIOND17()
eleIso_weight = ETAUMCcorrection.electronIso_0p10_2016 
triggerEff  = ETAUMCcorrection.efficiency_trigger_2016
def mc_corrector_2016(row):
  pu = pu_corrector(row.nTruePU)
 # e1idcorr = eId_corrector(row.e1Eta,row.e1Pt)
 # e2idcorr = eId_corrector(row.e2Eta,row.e2Pt)
#  e1reconcorr=erecon_corrector(row.e1Eta,row.e1Pt)
#  e2reconcorr=erecon_corrector(row.e2Eta,row.e2Pt)
  e1iso=eleIso_weight(row,'e1')
  #print 'e1iso  %f   pt %f' %(e1iso,row.e1Pt)
  e2iso=eleIso_weight(row,'e2')
  #print 'e2iso  %f  Pt   %f' %(e2iso,row.e2Pt)
  if row.e1MatchesEle25eta2p1TightPath:
     TriggerEfficency=triggerEff( row, 'e1')
  elif row.e2MatchesEle25eta2p1TightPath: 
     TriggerEfficency=triggerEff( row, 'e2')
  else:
     TriggerEfficency=1 
     print "00000000000000000000000000000000000000"
     print "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  #print 'TriggerEffi  %f' %TriggerEfficency
  #print "pu"
  #print str(pu)
  #return pu*e1idcorr*e2idcorr*e1reconcorr*e2reconcorr*e1iso*e2iso*TriggerEfficency
  return pu*e1iso*e2iso*TriggerEfficency

mc_corrector = mc_corrector_2016

def getGenEfakeTSF(ABStEta):
    if (ABStEta>=0 and ABStEta<1.46):
       return 1.40
    elif (ABStEta>1.558):
       return 1.9
    else:
      return 0

class AnalyzeLFVEETau(MegaBase):
    tree = 'eet/final/Ntuple'
    #tree = 'New_Tree'

    def __init__(self, tree, outfile, **kwargs):
        super(AnalyzeLFVEETau, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        self.tree = EETauTree.EETauTree(tree)
        self.out = outfile
        self.histograms = {}


        # Use the cython wrapper
        target = os.path.basename(os.environ['megatarget'])
        #self.Metcorected=RecoilCorrector("TypeIPFMET_2016BCD.root")

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
        self.is_embedded = ('Embed' in target)
        self.is_ZTauTau= ('ZTauTau' in target)
        self.is_ZMuMu= ('Zmumu' in target)
        self.is_DY= ('DY' in target)
        self.is_HToTauTau= ('HToTauTau' in target)
        self.is_HToMuTau= ('HToMuTau' in target)
        self.is_mc = not (self.is_data or self.is_embedded)
        if self.ls_DY or self.ls_ZTauTau:
           self.Z_reweight = ROOT.TFile.Open('zpt_weights_2016_BtoH.root')
           self.Z_reweight_H=self.Z_reweight.Get('zptmass_histo')


    def begin(self):
        #names=["preselectionSS", "preselectionDecay0","preselectionLooseIsoDecay0", "preselectionVLooseIsoDecay0","preselectionVTightIsoDecay0","preselectionMediumIsoDecay0", "preselection0JetDecay0", "preselection1JetDecay0", "preselection2JetDecay0","preselectionDecay1","preselectionLooseIsoDecay1", "preselectionVLooseIsoDecay1","preselectionVTightIsoDecay1","preselectionMediumIsoDecay1", "preselection0JetDecay1", "preselection1JetDecay1", "preselection2JetDecay1","preselectionDecay10","preselectionLooseIsoDecay10", "preselectionVLooseIsoDecay10","preselectionVTightIsoDecay10","preselectionMediumIsoDecay10", "preselection0JetDecay10", "preselection1JetDecay10", "preselection2JetDecay10"]
        names=['preselection','preselectionEB','preselectionEE','preselectionSS','preselectionEBSS','preselectionEESS','preselectionVLooseIsoSS','preselection0jet','preselection0jetVLooseIso','preselection1jet','preselection1jetVLooseIso','preselectionVLooseIsoEBSS','preselectionVLooseIsoEESS','preselectionVLooseIso','preselectionVLooseIsoEB','preselectionVLooseIsoEE',"preselectionDecay0","preselectionVLooseIsoDecay0","preselectionDecay1","preselectionVLooseIsoDecay1","preselectionDecay10","preselectionVLooseIsoDecay10","preselectionDecay0EB","preselectionVLooseIsoDecay0EB","preselectionDecay1EB","preselectionVLooseIsoDecay1EB","preselectionDecay10EB","preselectionVLooseIsoDecay10EB","preselectionDecay0EE","preselectionVLooseIsoDecay0EE","preselectionDecay1EE","preselectionVLooseIsoDecay1EE","preselectionDecay10EE","preselectionVLooseIsoDecay10EE",'preselection2_jetVBF0p2','preselectionVLooseIso2_jetVBF0p2','preselection2_jetEB','preselection2_jetEE','preselectionVLooseIso2_jetEB','preselectionVLooseIso2_jetEE','preselection2_jetVBF','preselectionVLooseIso2_jetVBF','preselection0JetEB','preselection0JetEE','preselection0JetVLooseIsoEB','preselection0JetVLooseIsoEE','preselection1JetEB','preselection1JetEE','preselection1JetVLooseIsoEB','preselection1JetVLooseIsoEE','preselection2Jet_ggEB','preselection2Jet_ggEE','preselection2Jet_ggVLooseIsoEB','preselection2Jet_ggVLooseIsoEE','preselection2Jet_VBFEB','preselection2Jet_VBFEE','preselection2Jet_VBFVLooseIsoEB','preselection2Jet_VBFVLooseIsoEE']
        namesize = len(names)
	for x in range(0,namesize):



            self.book(names[x], "e1Pt", "Electron  Pt", 1000,0,1000)
            self.book(names[x], "e1Eta", "Electron  eta", 100, -2.5, 2.5)
            self.book(names[x], "e1Charge", "Electron Charge", 5, -2, 2)
            self.book(names[x], "e2Pt", "Electron  Pt", 1000,0,1000)
            self.book(names[x], "e2Eta", "Electron  eta", 100, -2.5, 2.5)
            self.book(names[x], "e2Charge", "Electron Charge", 5, -2, 2)
            self.book(names[x], "e1_e2_Mass", "e1_e2_Mass",1000,0,1000)
            self.book(names[x], "type1_pfMetEt", "type1_pfMetEt",1000,0,1000)


            self.book(names[x], "tPt", "Tau  Pt", 1000,0,1000)
            self.book(names[x], "tEta", "Tau  eta", 100, -2.5, 2.5)
            self.book(names[x], "abstEta", "abs Tau  eta", 100, 0, 2.5)
            self.book(names[x], "tDecayMode", "tDecayMode", 12,0,12)


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
              #weight=weight*0.95
              weight=weight*0.95
        if self.ls_DY or self.ls_ZTauTau:
           wtzpt=self.Z_reweight_H.GetBinContent(self.Z_reweight_H.GetXaxis().FindBin(row.genM),self.Z_reweight_H.GetYaxis().FindBin(row.genpT))
           weight=weight*wtzpt
#        if (self.ls_DY and row.isZee  and row.tZTTGenMatching<5):
#          weight=weight*getGenEfakeTSF(abs(row.tEta))
        histos[name+'/e1Pt'].Fill(row.e1Pt, weight)
        histos[name+'/e1Eta'].Fill(row.e1Eta, weight)
        histos[name+'/e1Charge'].Fill(row.e1Charge, weight)
        histos[name+'/e2Pt'].Fill(row.e2Pt, weight)
        histos[name+'/e2Eta'].Fill(row.e2Eta, weight)
        histos[name+'/e2Charge'].Fill(row.e2Charge, weight)
        histos[name+'/tPt'].Fill(self.tau_Pt_C, weight)
        histos[name+'/tEta'].Fill(row.tEta, weight)
        histos[name+'/abstEta'].Fill(abs(row.tEta), weight)
        histos[name+'/tDecayMode'].Fill(row.tDecayMode,weight)
        histos[name+'/e1_e2_Mass'].Fill(row.e1_e2_Mass,weight)
        histos[name+'/type1_pfMetEt'].Fill(row.type1_pfMetEt,weight)


    def presel(self, row):
        #if not (row.singleIsoMu24Pass or row.singleIsoTkMu24Pass):
        if self.is_data:
           if not (row.singleE25eta2p1TightPass):
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
        if row.e1Pt < 26:
            return False
        if abs(row.e1Eta) >= 2.1:
            return False
        if row.e2Pt < 26:
            return False
        if abs(row.e2Eta) >= 2.1:
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
	if row.e1Charge*row.e2Charge!=-1:
            return False
	return True

    #def obj1_id(self, row):
    #    return bool(row.mPFIDTight)  
    def obj_obj_ID(self,row):
        if not(row.e1MVANonTrigWP80 and row.e2MVANonTrigWP80):
            return False  
        return True

    def e1e2Mass(self,row):
        if row.e1_e2_Mass < 76:
           return False
        if row.e1_e2_Mass > 106:
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
    def obj2_id(self, row):
        return  row.tAgainstElectronVLooseMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding

    def vetos(self,row):
                return  (bool (row.muVetoPt5IsoIdVtx<1) and bool (row.eVetoMVAIso<1) and bool (row.tauVetoPt20Loose3HitsVtx<1) )
    def tauinEB(self,row):
        return bool(abs(row.tEta)<1.479)   
    def obj1_iso(self,row):
         return bool(row.e1IsoDB03 <0.1 and row.e2IsoDB03 <0.1)

    def obj2_iso(self,row):
         return bool(row.tByTightIsolationMVArun2v1DBoldDMwLT)
       #  return bool(row.tByVTightIsolationMVArun2v1DBoldDMwLT)


    def obj2_mediso(self, row):
	 return bool(row.tByMediumIsolationMVArun2v1DBoldDMwLT)

    def obj2_vtightiso(self,row):
         return bool(row.tByVTightIsolationMVArun2v1DBoldDMwLT)

    def obj2_looseiso(self,row):
         return bool(row.tByLooseIsolationMVArun2v1DBoldDMwLT)

    def obj2_vlooseiso(self,row):
         #return bool(row.tByVLooseIsolationMVArun2v1DBoldDMwLT)
         return bool(row.tByLooseIsolationMVArun2v1DBoldDMwLT)

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

            if not self.presel(row): #only apply trigger selections for data   
                continue
            if not self.obj2_id (row):
                continue
            if not self.selectZtt(row):
                continue
            self.tau_Pt_C,self.Met_C_new=self.TauESC(row)
            if not self.kinematics(row): 
                continue
            if not self.obj1_iso(row):
                continue
            if not self.obj_obj_ID(row):
                continue
            if not self.vetos (row):
                continue
            if not self.e1e2Mass (row):
                continue

            if (self.is_data):
               if  row.bjetCISVVeto30Medium:
                   continue
            if self.obj2_iso(row) and (not self.oppositesign(row)):
                self.fill_histos(row,'preselectionSS',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionEBSS',False)
                else:
                    self.fill_histos(row,'preselectionEESS',False)
            if self.obj2_iso(row) and self.oppositesign(row):
                self.fill_histos(row,'preselection',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionEB',False)
                else:
                    self.fill_histos(row,'preselectionEE',False)
                if row.jetVeto30==0:
                   self.fill_histos(row,'preselection0jet',False)
                   if self.tauinEB(row): 
                      self.fill_histos(row,'preselection0JetEB',False)
                   else:
                      self.fill_histos(row,'preselection0JetEE',False)
                if row.jetVeto30==1:
                   self.fill_histos(row,'preselection1jet',False)
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
            if self.obj2_vlooseiso(row) and (not self.oppositesign(row)):
                self.fill_histos(row,'preselectionVLooseIsoSS',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionVLooseIsoEBSS',False)
                else:
                    self.fill_histos(row,'preselectionVLooseIsoEESS',False)
                    

            if self.obj2_vlooseiso(row) and self.oppositesign(row):
                self.fill_histos(row,'preselectionVLooseIso',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionVLooseIsoEB',False)
                else:
                    self.fill_histos(row,'preselectionVLooseIsoEE',False)
                if row.jetVeto30==0:
                   self.fill_histos(row,'preselection0jetVLooseIso',False)
                   if self.tauinEB(row): 
                      self.fill_histos(row,'preselection0JetVLooseIsoEB',False)
                   else:
                      self.fill_histos(row,'preselection0JetVLooseIsoEE',False)
                if row.jetVeto30==1:
                   self.fill_histos(row,'preselection1jetVLooseIso',False)
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
 
              if self.obj2_vlooseiso(row) and self.oppositesign(row):
                self.fill_histos(row,'preselectionVLooseIsoDecay0',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionVLooseIsoDecay0EB',False)
                else:
                    self.fill_histos(row,'preselectionVLooseIsoDecay0EE',False)
 

            if self.DecayMode1(row):
              if self.obj2_iso(row) and self.oppositesign(row):

                self.fill_histos(row,'preselectionDecay1',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionDecay1EB',False)
                else:
                    self.fill_histos(row,'preselectionDecay1EE',False)

              if self.obj2_vlooseiso(row) and self.oppositesign(row):
                self.fill_histos(row,'preselectionVLooseIsoDecay1',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionVLooseIsoDecay1EB',False)
                else:
                    self.fill_histos(row,'preselectionVLooseIsoDecay1EE',False)


            if self.DecayMode10(row):
              if self.obj2_iso(row) and self.oppositesign(row):

                self.fill_histos(row,'preselectionDecay10',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionDecay10EB',False)
                else:
                    self.fill_histos(row,'preselectionDecay10EE',False)

              if self.obj2_vlooseiso(row) and self.oppositesign(row):
                self.fill_histos(row,'preselectionVLooseIsoDecay10',False)
                if  self.tauinEB(row):
                    self.fill_histos(row,'preselectionVLooseIsoDecay10EB',False)
                else:
                    self.fill_histos(row,'preselectionVLooseIsoDecay10EE',False)




            sel=True

    def finish(self):
        self.write_histos()
