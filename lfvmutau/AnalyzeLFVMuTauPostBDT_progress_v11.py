'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW, Fanbo Meng,ND

'''

import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import weightNormal
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
#import FinalStateAnalysis.TagAndProbe.H2TauCorrections as H2TauCorrections
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import ROOT
import math
import optimizer_new 
#import optimizerdetastudy
from math import sqrt, pi
import itertools
#import bTagSF
import bTagSFrereco
from RecoilCorrector import RecoilCorrector
import Systematics
#data=bool ('true' in os.environ['isRealData'])
#RUN_OPTIMIZATION=bool ('true' in os.environ['RUN_OPTIMIZATION'])
#RUN_OPTIMIZATION=True
RUN_OPTIMIZATION=False
#ZTauTau = bool('true' in os.environ['isZTauTau'])
#ZeroJet = bool('true' in os.environ['isInclusive'])
#ZeroJet = False
#systematic = os.environ['systematic']
#fakeset= bool('true' in os.environ['fakeset'])
#fakeset= False
btagSys=0
fakeset= True
#MetCorrection=True
MetCorrection=False
systematic = 'none'
#wjets_fakes=True
wjets_fakes=False
tuning=True
#value =0(no) 1(up) 2(down)
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
def transverseMass(p1,p2):    #one partical to Met possiblely
    # pvect[Et,px,py]
    totalEt2 = (p1[0] + p2[0])*(p1[0] + p2[0])
    totalPt2 = (p1[1] + p2[1])**2+(p1[2]+p2[2])**2
    mt2 = totalEt2 - totalPt2
    return math.sqrt(abs(mt2))
  
def transverseMass_v2(p1,p2):    #one partical to Met possiblely
    # pvect[Et,px,py]
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
#muon_HTauTau_TriggerIso22_2016B= MuonPOGCorrections.make_muon_HTauTau_TriggerIso22_2016B()
muon_pog_TriggerIso24_2016B= MuonPOGCorrections.make_muon_pog_IsoMu24oIsoTkMu24_2016ReReco()
muon_pog_PFTight_2016B = MuonPOGCorrections.make_muon_pog_PFMedium_2016ReReco()
#muon_pog_PFTight_2016B = MuonPOGCorrections.make_muon_pog_PFMedium_2016BCD()
#muon_pog_Tracking_2016B = MuonPOGCorrections.make_muon_pog_Tracking_2016BCD()
#muon_pog_Tracking_2016B = MuonPOGCorrections.mu_trackingEta_2016()
muon_pog_TightIso_2016B = MuonPOGCorrections.make_muon_pog_TightIso_2016ReReco('Medium')


class AnalyzeLFVMuTauPostBDT_progress_v11(MegaBase):
    tree = 'mt/final/Ntuple'
    #tree = 'New_Tree'

    def __init__(self, tree, outfile, **kwargs):
        super(AnalyzeLFVMuTauPostBDT_progress_v11, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        target = os.path.basename(os.environ['megatarget'])
        self.target1 = os.path.basename(os.environ['megatarget'])
        self.ls_recoilC=((('HTo' in target) or ('Jets' in target)) and MetCorrection) 
        if self.ls_recoilC and MetCorrection:
           self.Metcorected=RecoilCorrector("TypeIPFMET_2016BCD.root")
        
#        print "the target is ***********    %s"    %target
#        WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
        self.weighttarget=target.split(".",1)[0].replace("-","_")
        self.is_data = target.startswith('data_')
        self.is_dataG_H =(bool('Run2016H' in target) or bool('Run2016G' in target))
        self.var_d_star =["mPt_", "tPt_", "tMtToPfMet_type1_", "m_t_DPhi_", "tDPhiToPfMet_type1_", "type1_pfMetEt_", "deltaeta_m_t_", "m_t_collinearmass_"]
        self.xml_name = os.path.join(os.getcwd(),"weightsCollmassworks_newfakes/TMVAClassification_BDT.weights.xml")
        self.functor = FunctorFromMVA('BDT method',self.xml_name, *self.var_d_star)
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
        self.Sysin=0
        self.light=0
        self.DoPileup=0
        self.DoMES=0
        self.DoTES=0
        self.DoMFT=0
        self.DoUES=0
        self.DoUESsp=0
        self.DoJES=0
        self.DoFakeshapeDM=0
        self.MVA0fill_new=-100
        self.MVA0fill=-100
        self.tau_Pt_C=0.01
        self.tMtToPfMet_type1_new=0
        self.MET_tPtC=0
        self.collMass_type1_new=-10
        self.m_t_Mass_new=-10
        self.tmpHula=(-10,-10,-10,-10,-10,-10)
        self.tmpHulaJES=(0,-10)
        if self.ls_DY or self.ls_ZTauTau:
           self.Z_reweight = ROOT.TFile.Open('zpt_weights_2016_BtoH.root')
           self.Z_reweight_H=self.Z_reweight.Get('zptmass_histo')
    def begin(self):

        if not self.light :
          names=["preselection","notIso","notIsoM","notIsoMT","preselectionSS","notIsoSS","notIsoSSM","notIsoSSMT","preslectionEnWjets","notIsoEnWjets","notIsoEnWjetsM","notIsoEnWjetsMT","preslectionEnWjets0Jet","notIsoEnWjets0Jet","notIsoEnWjets0JetM","notIsoEnWjets0JetMT","preslectionEnWjets1Jet","notIsoEnWjets1Jet","notIsoEnWjets1JetM","notIsoEnWjets1JetMT","preslectionEnWjets2Jet_gg","notIsoEnWjets2Jet_gg","notIsoEnWjets2Jet_ggM","notIsoEnWjets2Jet_ggMT","preslectionEnWjets2Jet_vbf","notIsoEnWjets2Jet_vbf","notIsoEnWjets2Jet_vbfM","notIsoEnWjets2Jet_vbfMT","gg","boost","ggNotIso","ggNotIsoM","ggNotIsoMT","boostNotIso","boostNotIsoM","boostNotIsoMT","ggNotIso1stUp","ggNotIso1stDown","boostNotIso1stUp","boostNotIso1stDown","ggNotIsoM1stUp","ggNotIsoM1stDown","boostNotIsoM1stUp","boostNotIsoM1stDown","ggNotIsoMT1stUp","ggNotIsoMT1stDown","boostNotIsoMT1stUp","boostNotIsoMT1stDown","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_ggNotIsoM","vbf_ggNotIsoMT","vbf_vbfNotIso","vbf_vbfNotIsoM","vbf_vbfNotIsoMT","vbf_ggNotIso1stUp","vbf_ggNotIso1stDown","vbf_vbfNotIso1stUp","vbf_vbfNotIso1stDown","vbf_ggNotIsoM1stUp","vbf_ggNotIsoM1stDown","vbf_vbfNotIsoM1stUp","vbf_vbfNotIsoM1stDown","vbf_ggNotIsoMT1stUp","vbf_ggNotIsoMT1stDown","vbf_vbfNotIsoMT1stUp","vbf_vbfNotIsoMT1stDown","IsoSS0Jet","IsoSS1Jet",'IsoSS2Jet_gg','IsoSS2Jet_vbf',"notIsoSS0Jet","notIsoSS0JetM","notIsoSS0JetMT","notIsoSS1Jet","notIsoSS1JetM","notIsoSS1JetMT","notIsoSS2Jet_gg","notIsoSS2Jet_ggM","notIsoSS2Jet_ggMT","notIsoSS2Jet_vbf","notIsoSS2Jet_vbfM","notIsoSS2Jet_vbfMT","preslectionEnZtt","notIsoEnZtt","notIsoEnZttM","notIsoEnZttMT","preslectionEnZtt0Jet","notIsoEnZtt0Jet","notIsoEnZtt0JetM","notIsoEnZtt0JetMT","preslectionEnZtt1Jet","notIsoEnZtt1Jet","notIsoEnZtt1JetM","notIsoEnZtt1JetMT","preslectionEnZtt2Jet_gg","notIsoEnZtt2Jet_gg","notIsoEnZtt2Jet_ggM","notIsoEnZtt2Jet_ggMT","preslectionEnZtt2Jet_vbf","notIsoEnZtt2Jet_vbf","notIsoEnZtt2Jet_vbfM","notIsoEnZtt2Jet_vbfMT","preslectionEnZmm","notIsoEnZmm","notIsoEnZmmM","notIsoEnZmmMT","preslectionEnZmm0Jet","notIsoEnZmm0Jet","notIsoEnZmm0JetM","notIsoEnZmm0JetMT","preslectionEnZmm1Jet","notIsoEnZmm1Jet","notIsoEnZmm1JetM","notIsoEnZmm1JetMT","preslectionEnZmm2Jet_gg","notIsoEnZmm2Jet_gg","notIsoEnZmm2Jet_ggM","notIsoEnZmm2Jet_ggMT","preslectionEnZmm2Jet_vbf","notIsoEnZmm2Jet_vbf","notIsoEnZmm2Jet_vbfM","notIsoEnZmm2Jet_vbfMT","preslectionEnTTbar","notIsoEnTTbar","notIsoEnTTbarM","notIsoEnTTbarMT","preslectionEnTTbar0Jet","notIsoEnTTbar0Jet","notIsoEnTTbar0JetM","notIsoEnTTbar0JetMT","preslectionEnTTbar1Jet","notIsoEnTTbar1Jet","notIsoEnTTbar1JetM","notIsoEnTTbar1JetMT","preslectionEnTTbar2Jet_gg","notIsoEnTTbar2Jet_gg","notIsoEnTTbar2Jet_ggM","notIsoEnTTbar2Jet_ggMT","preslectionEnTTbar2Jet_vbf","notIsoEnTTbar2Jet_vbf","notIsoEnTTbar2Jet_vbfM","notIsoEnTTbar2Jet_vbfMT"]   
        else:
           names=["preselectionSS","notIsoSS","notIsoSSM","notIsoSSMT","gg","boost","ggNotIso","ggNotIsoM","ggNotIsoMT","boostNotIso","boostNotIsoM","boostNotIsoMT","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_ggNotIsoM","vbf_ggNotIsoMT","vbf_vbfNotIso","vbf_vbfNotIsoM","vbf_vbfNotIsoMT"]
       # if (not fakeset) and (not wjets_fakes) :
       #    names=["gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
        if self.Sysin:
           sysneed_Fake=['FakeshapeDM0_1_EBUp','FakeshapeDM0_1_EBDown','FakeshapeDM0_2_EBUp','FakeshapeDM0_2_EBDown','FakeshapeDM1_1_EBUp','FakeshapeDM1_1_EBDown','FakeshapeDM1_2_EBUp','FakeshapeDM1_2_EBDown','FakeshapeDM10_1_EBUp','FakeshapeDM10_1_EBDown','FakeshapeDM10_2_EBUp','FakeshapeDM10_2_EBDown','FakeshapeDM0_1_EEUp','FakeshapeDM0_1_EEDown','FakeshapeDM0_2_EEUp','FakeshapeDM0_2_EEDown','FakeshapeDM1_1_EEUp','FakeshapeDM1_1_EEDown','FakeshapeDM1_2_EEUp','FakeshapeDM1_2_EEDown','FakeshapeDM10_1_EEUp','FakeshapeDM10_1_EEDown','FakeshapeDM10_2_EEUp','FakeshapeDM10_2_EEDown']
           basechannels_Fake=['ggNotIso','ggNotIsoM','ggNotIsoMT','boostNotIso','boostNotIsoM','boostNotIsoMT','vbf_ggNotIso','vbf_ggNotIsoM','vbf_ggNotIsoMT','vbf_vbfNotIso','vbf_vbfNotIsoM','vbf_vbfNotIsoMT']
           for i in sysneed_Fake:
               for j in basechannels_Fake:
                   names.append(j+i)                    
        if self.Sysin and (not self.is_data):
       #    name=[]
           sysneed=['MESUp','MESDown','TES0Up','TES0Down','TES1Up','TES1Down','TES10Up','TES10Down','UESUp','UESDown','MFTUp','MFTDown','PileupUp','PileupDown']
           basechannels=['gg','boost','vbf_gg','vbf_vbf']
           for i in sysneed:
               for j in basechannels:
                   names.append(j+i)                    
           JESsys=["_CMS_JetEnUp","_CMS_JetEnDown","_CMS_JetAbsoluteFlavMapDown","_CMS_JetAbsoluteFlavMapUp","_CMS_JetAbsoluteMPFBiasDown","_CMS_JetAbsoluteMPFBiasUp","_CMS_JetAbsoluteScaleDown","_CMS_JetAbsoluteScaleUp","_CMS_JetAbsoluteStatDown","_CMS_JetAbsoluteStatUp","_CMS_JetFlavorQCDDown","_CMS_JetFlavorQCDUp","_CMS_JetFragmentationDown","_CMS_JetFragmentationUp","_CMS_JetPileUpDataMCDown","_CMS_JetPileUpDataMCUp","_CMS_JetPileUpPtBBDown","_CMS_JetPileUpPtBBUp","_CMS_JetPileUpPtEC1Down","_CMS_JetPileUpPtEC1Up","_CMS_JetPileUpPtEC2Down","_CMS_JetPileUpPtEC2Up","_CMS_JetPileUpPtHFDown","_CMS_JetPileUpPtHFUp","_CMS_JetPileUpPtRefDown","_CMS_JetPileUpPtRefUp","_CMS_JetRelativeBalDown","_CMS_JetRelativeBalUp","_CMS_JetRelativeFSRDown","_CMS_JetRelativeFSRUp","_CMS_JetRelativeJEREC1Down","_CMS_JetRelativeJEREC1Up","_CMS_JetRelativeJEREC2Down","_CMS_JetRelativeJEREC2Up","_CMS_JetRelativeJERHFDown","_CMS_JetRelativeJERHFUp","_CMS_JetRelativePtBBDown","_CMS_JetRelativePtBBUp","_CMS_JetRelativePtEC1Down","_CMS_JetRelativePtEC1Up","_CMS_JetRelativePtEC2Down","_CMS_JetRelativePtEC2Up","_CMS_JetRelativePtHFDown","_CMS_JetRelativePtHFUp","_CMS_JetRelativeStatECDown","_CMS_JetRelativeStatECUp","_CMS_JetRelativeStatFSRDown","_CMS_JetRelativeStatFSRUp","_CMS_JetRelativeStatHFDown","_CMS_JetRelativeStatHFUp","_CMS_JetSinglePionECALDown","_CMS_JetSinglePionECALUp","_CMS_JetSinglePionHCALDown","_CMS_JetSinglePionHCALUp","_CMS_JetTimePtEtaDown","_CMS_JetTimePtEtaUp"]
           UESspsys=['_CMS_CHARGEDUESUp','_CMS_CHARGEDUESDown','_CMS_ECALUESUp','_CMS_ECALUESDown','_CMS_HCALUESUp','_CMS_HCALUESDown','_CMS_HFUESUp','_CMS_HFUESDown']
           for i in  JESsys:
               for j in basechannels:
                   names.append(j+i)
           for i in  UESspsys:
               for j in basechannels:
                   names.append(j+i)
#           sysnames=["ggMES","boostMES","vbf_ggMES","vbf_vbfMES","ggNotIsoMES","ggNotIsoMMES","ggNotIsoMTMES","boostNotIsoMES","boostNotIsoMMES","boostNotIsoMTMES","vbf_ggNotIsoMES","vbf_ggNotIsoMMES","vbf_ggNotIsoMTMES","vbf_vbfNotIsoMES","vbf_vbfNotIsoMMES","vbf_vbfNotIsoMTMES","ggMES","boostMES","vbf_ggMES","vbf_vbfMES","ggNotIsoMES","ggNotIsoMMES","ggNotIsoMTMES","boostNotIsoMES","boostNotIsoMMES","boostNotIsoMTMES","vbf_ggNotIsoMES","vbf_ggNotIsoMMES","vbf_ggNotIsoMTMESdown","vbf_vbfNotIsoMESdown","vbf_vbfNotIsoMMESdown","vbf_vbfNotIsoMTMESdown"]
#           names=names+sysname
        if wjets_fakes  :
           names=["preselection","notIso","preselectionSS","notIsoSS","gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","Wmunu_preselection0Jet","Wtaunu_preselection0Jet","W2jets_preselection0Jet","Wmunu_preselection1Jet","Wtaunu_preselection1Jet","W2jets_preselection1Jet","Wmunu_preselection2Jet","Wtaunu_preselection2Jet","W2jets_preselection2Jet","Wmunu_gg","Wtaunu_gg","W2jets_gg","Wmunu_boost","Wtaunu_boost","W2jets_boost","Wmunu_vbf_gg","Wtaunu_vbf_gg","W2jets_vbf_gg","Wmunu_vbf_vbf","Wtaunu_vbf_vbf","W2jets_vbf_vbf","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
           #names=["gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
        if RUN_OPTIMIZATION:
		for region in optimizer_new.regions['0']:
			names.append(os.path.join("gg",region))	
			names.append(os.path.join("ggIsoSS",region))	
		for region in optimizer_new.regions['1']:
			names.append(os.path.join("boost",region))	
			names.append(os.path.join("boostIsoSS",region))	
		for region in optimizer_new.regions['2loose']:
			names.append(os.path.join("vbf_gg",region))	
			names.append(os.path.join("vbf_ggIsoSS",region))	
		for region in optimizer_new.regions['2tight']:
			names.append(os.path.join("vbf_vbf",region))	
			names.append(os.path.join("vbf_vbfIsoSS",region))	
        namesize = len(names)
	for x in range(0,namesize):


            self.book(names[x], "mPt", "Muon  Pt", 300,0,300)
            self.book(names[x], "tPt", "Tau  Pt", 300,0,300)
            self.book(names[x], "tMtToPfMet_type1", "Tau MT (PF Ty1)", 200, 0, 200)
            self.book(names[x], "mMtToPfMet_type1", "Muon MT (PF Ty1)", 200, 0, 200)
            self.book(names[x],"collMass_type1","collMass_type1",300,0,300)
            self.book(names[x], "BDTcuts", "BDTcuts", 80, -0.5,0.3)
            self.book(names[x], "tDPhiToPfMet_type1", "tDPhiToPfMet_type1", 100, 0, 4)
            self.book(names[x], "type1_pfMetEt", "Type1 MET", 200, 0, 200)
            self.book(names[x], "m_t_DEta", "Muon + Tau DEta", 100, 0,4)
            self.book(names[x], "m_t_DPhi", "Muon + Tau DPhi", 100, 0, 4)
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
                  self.book(names[x], "nvtx", "Number of vertices", 20, -0.5, 100.5)
                  self.book(names[x], "mEta", "Muon  eta", 100, -2.5, 2.5)
                  self.book(names[x], "tEta", "Tau  eta", 100, -2.5, 2.5)
                  self.book(names[x], "tPhi", "tPhi", 100 ,-3.4,3.4)
                  self.book(names[x], "m_t_Mass", "Muon + Tau Mass", 200, 0, 200)
            #      self.book(names[x], "m_t_Pt", "Muon + Tau Pt", 200, 0, 200)
                  self.book(names[x], "m_t_DR", "Muon + Tau DR", 100, 0, 10)
                  self.book(names[x], "mDPhiToPfMet_type1", "mDPhiToPfMet_type1", 100, 0, 4)
                  self.book(names[x], "m_t_SS", "Muon + Tau SS", 5, -2, 2)
      	          self.book(names[x], "vbfMass", "", 500,0,5000.0)
      	          self.book(names[x], "vbfDeta", "", 100, -0.5,10.0)
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
#	    self.book(names[x], 'mRelPFIsoDBDefault' ,'Muon Isolation', 100, 0.0,1.0)
   
 
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
      m1tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.mEta))[0]
      #print "the m1tracking %f"   %m1tracking
#      print "Sysin value in the correction %f" %self.Sysin
      if (not self.Sysin) or (self.DoTES) or self.DoUES or self.DoJES or self.DoFakeshapeDM or self.DoMFT or self.DoUESsp:
         m1id =muon_pog_PFTight_2016B(row.mPt,abs(row.mEta))
         m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt,abs(row.mEta))
       
         m1iso =muon_pog_TightIso_2016B(row.mPt,abs(row.mEta))
      elif self.Sysin and self.DoMES==1:
        # print 'at line 513 the MES comes in as 1'
            m1id =muon_pog_PFTight_2016B(row.mPt*1.002,abs(row.mEta))
            m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt*1.002,abs(row.mEta))
            m1iso =muon_pog_TightIso_2016B(row.mPt*1.002,abs(row.mEta))
        # if abs(row.mEta)>1.2 and abs(row.mEta)<=2.1 :
        #    m1id =muon_pog_PFTight_2016B(row.mPt*1.009,abs(row.mEta))
        #    m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt*1.009,abs(row.mEta))
        #    m1iso =muon_pog_TightIso_2016B(row.mPt*1.009,abs(row.mEta))
        # if row.mEta<-2.1 and row.mEta>=-2.4 :
        #    m1id =muon_pog_PFTight_2016B(row.mPt*1.027,abs(row.mEta))
        #    m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt*1.027,abs(row.mEta))
        #    m1iso =muon_pog_TightIso_2016B(row.mPt*1.027,abs(row.mEta))
        # if row.mEta>2.1 and row.mEta<=2.4 :
        #    m1id =muon_pog_PFTight_2016B(row.mPt*1.017,abs(row.mEta))
        #    m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt*1.017,abs(row.mEta))
        #    m1iso =muon_pog_TightIso_2016B(row.mPt*1.017,abs(row.mEta))
      elif self.Sysin and self.DoMES==2:
        # print "at the same time what is the MES=2 enters?"
            m1id =muon_pog_PFTight_2016B(row.mPt*0.998,abs(row.mEta))
            m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt*0.998,abs(row.mEta))
            m1iso =muon_pog_TightIso_2016B(row.mPt*0.998,abs(row.mEta))
      else:
         m1id =muon_pog_PFTight_2016B(row.mPt,abs(row.mEta))
         m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt,abs(row.mEta))
         m1iso =muon_pog_TightIso_2016B(row.mPt,abs(row.mEta))
        # if abs(row.mEta)>1.2 and abs(row.mEta)<=2.1 :
        #    m1id =muon_pog_PFTight_2016B(row.mPt*0.991,abs(row.mEta))
        #    m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt*0.991,abs(row.mEta))
        #    m1iso =muon_pog_TightIso_2016B(row.mPt*0.991,abs(row.mEta))
        # if row.mEta<-2.1 and row.mEta>=-2.4 :
        #    m1id =muon_pog_PFTight_2016B(row.mPt*0.973,abs(row.mEta))
        #    m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt*0.973,abs(row.mEta))
        #    m1iso =muon_pog_TightIso_2016B(row.mPt*0.973,abs(row.mEta))
        # if row.mEta>2.1 and row.mEta<=2.4 :
        #    m1id =muon_pog_PFTight_2016B(row.mPt*0.983,abs(row.mEta))
        #    m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt*0.983,abs(row.mEta))
        #    m1iso =muon_pog_TightIso_2016B(row.mPt*0.983,abs(row.mEta))
    #  m1iso =muon_pog_TightIso_2016B('Medium',row.mPt,abs(row.mEta))
      return pu*m1id**m1tracking*m_trgiso22  
    #  print "in the analyzer muon trigger"
     # print "Pt value %f   eta value %f    efficiency %f" %(row.mPt,row.mEta,m_trgiso22)
      #print "pu"
      #print str(pu)
    def getFakeRateFactorFANBOPt(self,row, fakeset):
    #        if fakeset=="def":
    #           if  row.tDecayMode==0:
    #               fTauIso=0.240806-0.000836112*(self.tau_Pt_C-30)
    #           elif  row.tDecayMode==1:
    #               fTauIso=0.235014-0.000837926*(self.tau_Pt_C-30)
    #           elif  row.tDecayMode==10:
    #               fTauIso=0.185752-0.000457377*(self.tau_Pt_C-30)
    #           else:
    #               print "rare decay mode %f" %row.tDecayMode
    #               fTauIso=0
#            print 'tau fake rate def ones %f'  %(fTauIso)

            if fakeset=="def":
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


            if self.DoFakeshapeDM:
               if self.DoFakeshapeDM==20170000:
               #   if  row.tDecayMode==0:
               #       fTauIso=0.240806-0.000836112*(self.tau_Pt_C-30)
               #   elif  row.tDecayMode==1:
               #       fTauIso=0.235014-0.000837926*(self.tau_Pt_C-30)
               #   elif  row.tDecayMode==10:
               #       fTauIso=0.185752-0.000457377*(self.tau_Pt_C-30)
               #   else:
               #       print "rare decay mode %f" %row.tDecayMode
               #       fTauIso=0
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
        #    if self.DoFakeshapeDM:
#               print 'the tau fake shape value %f and the ratio value %f' %(self.DoFakeshapeDM,fTauIso)
            fakeRateFactor = fTauIso/(1.0-fTauIso)
            return fakeRateFactor
    def collMass_type1_v1(self,row,metpx,metpy):
            taupx=row.tPt*math.cos(row.tPhi)
            taupy=row.tPt*math.sin(row.tPhi)
    #        metE = row.type1_pfMetEt
    #	metPhi = row.type1_pfMetPhi
    #        metpx = metE*math.cos(metPhi)
    #        metpy = metE*math.sin(metPhi)
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
    #        metE = row.type1_pfMetEt
    #	metPhi = row.type1_pfMetPhi
    #        metpx = metE*math.cos(metPhi)
    #        metpy = metE*math.sin(metPhi)
#            met = math.sqrt(metpx*metpx+metpy*metpy)
            METproj= abs(metpx*taupx+metpy*taupy)/taupt
            xth=taupt/(taupt+METproj)
            den=math.sqrt(xth)
            mass=(muonlorenz+taulorenz).M()
            #mass=row.m_t_Mass/den
            #print mass
            return (mass/den,mass)
    def correction(self,row):
	return self.mc_corrector_2016(row)
	
#    def getFakeRateFactormuon(self,row, fakeset):   #Ptbined
#        if fakeset=="def":
#           if row.mPt<=30:
#              fTauIso=0.624
#           elif row.mPt<=40:
#              fTauIso=0.725
#           elif row.mPt<=50:
#              fTauIso=0.754
#           elif row.mPt<=80:
#              fTauIso=0.808
#           else:
#              fTauIso=0.958
#        if self.DoMES==1:
#           if row.mPt*1.002<=30:
#              fTauIso=0.624
#           elif row.mPt*1.002<=40:
#              fTauIso=0.725
#           elif row.mPt*1.002<=50:
#              fTauIso=0.754
#           elif row.mPt*1.002<=80:
#              fTauIso=0.808
#           else:
#              fTauIso=0.958
#        elif self.DoMES==2:
#           if row.mPt*0.998<=30:
#              fTauIso=0.624
#           elif row.mPt*0.998<=40:
#              fTauIso=0.725
#           elif row.mPt*0.998<=50:
#              fTauIso=0.754
#           elif row.mPt*0.998<=80:
#              fTauIso=0.808
#           else:
#              fTauIso=0.958
#        fakeRateFactor = fTauIso/(1.0-fTauIso)
#        return fakeRateFactor
    def getFakeRateFactormuon(self,row, fakeset):   #Ptbined
        if fakeset=="def":
           if row.mPt<=30:
              fTauIso=0.611
           elif row.mPt<=40:
              fTauIso=0.724
           elif row.mPt<=50:
              fTauIso=0.746
           elif row.mPt<=60:
              fTauIso=0.796
           elif row.mPt<=80:
              fTauIso=0.816
           else:
              fTauIso=0.950
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
           #return getFakeRateFactorAaron(row,fakeset)
           return self.getFakeRateFactorFANBOPt(row,fakeset)
          # return getFakeRateFactor(row,fakeset)
        if faketype=="muonfake":
           #return getFakeRateFactormuonEta(row,fakeset)
           return self.getFakeRateFactormuon(row,fakeset)
           #return getFakeRateFactormuonabsEta(row,fakeset)
        if faketype=="mtfake":
           #return getFakeRateFactormuonEta(row,fakeset)*getFakeRateFactorFANBO(row,fakeset)
           return self.getFakeRateFactormuon(row,fakeset)*self.getFakeRateFactorFANBOPt(row,fakeset)
           #return getFakeRateFactormuonabsEta(row,fakeset)*getFakeRateFactorFANBOPt(row,fakeset)
           #return getFakeRateFactormuonEta(row,fakeset)*getFakeRateFactor(row,fakeset)
       # return getFakeRateFactorAaron(row,fakeset)
	     
    def fill_histosup(self, row,name='gg', fakeRate=False, fakeset="def"):
        histos = self.histograms
        histos['counts'].Fill(1,1)
    def MetCorrectionSet(self,row):
           if self.ls_Wjets:
              self.tmpMet=self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi),row.type1_pfMetEt*math.sin(row.type1_pfMetPhi),row.genpX,row.genpY,row.vispX,row.vispY,int(round(row.jetVeto30))+1)#,self.pfmetcorr_ex,self.pfmetcorr_ey)
           else:
              self.tmpMet=self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi),row.type1_pfMetEt*math.sin(row.type1_pfMetPhi),row.genpX,row.genpY,row.vispX,row.vispY,int(round(row.jetVeto30)))#,self.pfmetcorr_ex,self.pfmetcorr_ey)
           MetPt4=[math.sqrt(self.tmpMet[0]*self.tmpMet[0]+self.tmpMet[1]*self.tmpMet[1]),self.tmpMet[0],self.tmpMet[1],0]
           TauPt4=[row.tPt,row.tPt*math.cos(row.tPhi),row.tPt*math.sin(row.tPhi),0]
           MetPhi=math.atan2(self.tmpMet[1],self.tmpMet[0])
           self.TauDphiToMet=abs(row.tPhi-MetPhi)
           self.tMtToPfMet_type1MetC=transverseMass(MetPt4,TauPt4)
           self.collMass_type1MetC=self.collMass_type1(row,self.tmpMet[0],self.tmpMet[1])
           print "Mass from Tuple %f and from Cal %f" %(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi),self.tmpMet[0]) 
#        if 
#          histos['jetPt'].Fill(1,1)
    def fill_histos(self, row,name='gg',fakeRate=False,faketype="taufake",fakeset="def"):
        histos = self.histograms
        #weight=bTagSF.bTagEventWeight(row.bjetCISVVeto20MediumZTT,row.jb1pt,row.jb1flavor,row.jb2pt,row.jb2flavor,1,btagSys,0)
        weight=1#bTagSF.bTagEventWeight(row.bjetCISVVeto20MediumZTT,row.jb1pt,row.jb1flavor,row.jb2pt,row.jb2flavor,1,btagSys,0)
        #print "Sysin value in the fill function line 635 %f" %self.Sysin
        if (not(self.is_data)):
        #some difference from the btag stuff
	   weight = row.GenWeight * self.correction(row)*bTagSFrereco.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)*self.WeightJetbin(row)
        if (fakeRate == True):
          weight=weight*self.fakeRateMethod(row,fakeset,faketype) #apply fakerate method for given isolation definition
        if (self.is_ZTauTau or self.is_HToTauTau or self.is_HToMuTau or self.is_TauTau):
          #weight=weight*0.83
          weight=weight*0.95
        if (self.ls_DY and row.isZmumu  and row.tZTTGenMatching<5):
          weight=weight*getGenMfakeTSF(abs(row.tEta))
#        if self.ls_DY or self.ls_ZTauTau:
#           wtzpt=self.Z_reweight_H.GetBinContent(self.Z_reweight_H.GetXaxis().FindBin(row.genM),self.Z_reweight_H.GetYaxis().FindBin(row.genpT))
#           weight=weight*wtzpt
        if (not self.Sysin) or self.DoFakeshapeDM or self.DoPileup:   
           histos[name+'/tPt'].Fill(self.tau_Pt_C, weight)
           histos[name+'/mPt'].Fill(row.mPt, weight)
         #  if self.ls_recoilC and MetCorrection:
         #     histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1MetC,weight)
         #  else:
           histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1_new,weight)
           histos[name+'/mMtToPfMet_type1'].Fill(self.mMtToPfMet_type1_new,weight)
         #  if self.ls_recoilC and MetCorrection: 
             # histos[name+'/collMass_type1'].Fill(self.collMass_type1MetC,weight)
          # else:
           histos[name+'/BDTcuts'].Fill(self.MVA0fill, weight)
       	   histos[name+'/type1_pfMetEt'].Fill(self.MET_tPtC,weight)
           histos[name+'/m_t_DPhi'].Fill(row.m_t_DPhi,weight)
           histos[name+'/m_t_DEta'].Fill(abs(row.mEta-row.tEta),weight)
           histos[name+'/collMass_type1'].Fill(self.collMass_type1_new,weight)
           if self.ls_recoilC and MetCorrection: 
   	      histos[name+'/tDPhiToPfMet_type1'].Fill(abs(self.TauDphiToMet),weight)
           else:
   	      histos[name+'/tDPhiToPfMet_type1'].Fill(abs(row.tDPhiToPfMet_type1),weight)
        else:
           if self.DoTES or self.DoMFT:
              histos[name+'/tPt'].Fill(self.MorTPtshifted, weight)
              histos[name+'/mPt'].Fill(row.mPt, weight)
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1_new,weight)
#  #            histos[name+'/type1_pfMetEt'].Fill(self.MET_tPtCsys,weight)
#  #            histos[name+'/type1_pfMetPhi'].Fill(self.MetPhisys,weight)
              histos[name+'/collMass_type1'].Fill(self.collMass_type1_new,weight)
             # histos[name+'/m_t_Mass'].Fill(self.m_t_Mass_new,weight)
              histos[name+'/BDTcuts'].Fill(self.MVA0fill_new, weight)
           if self.DoUES or self.DoJES or self.DoUESsp:
              histos[name+'/tPt'].Fill(self.tau_Pt_C, weight)
              histos[name+'/mPt'].Fill(row.mPt, weight)
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1_new,weight)
              histos[name+'/mMtToPfMet_type1'].Fill(self.mMtToPfMet_type1_new,weight)
              histos[name+'/collMass_type1'].Fill(self.collMass_type1_new,weight)
              histos[name+'/BDTcuts'].Fill(self.MVA0fill_new, weight)
           if self.DoMES:
              histos[name+'/tPt'].Fill(self.tau_Pt_C, weight)
              histos[name+'/mPt'].Fill(self.MorTPtshifted, weight)
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1_new,weight)
              histos[name+'/mMtToPfMet_type1'].Fill(self.mMtToPfMet_type1_new,weight)
              histos[name+'/collMass_type1'].Fill(self.collMass_type1_new,weight) 
              #histos[name+'/m_t_Mass'].Fill(self.m_t_Mass_new,weight)
              histos[name+'/BDTcuts'].Fill(self.MVA0fill_new, weight)
        if not self.light: 
           histos[name+'/nvtx'].Fill(row.nvtx, weight)
           histos[name+'/weight'].Fill(weight)
           histos[name+'/GenWeight'].Fill(row.GenWeight)
           histos[name+'/counts'].Fill(1)
           histos[name+'/mEta'].Fill(row.mEta, weight)
           histos[name+'/tEta'].Fill(row.tEta, weight)
           histos[name+'/tPhi'].Fill(row.tPhi, weight)
           histos[name+'/m_t_Mass'].Fill(row.m_t_Mass,weight)
           histos[name+'/m_t_DR'].Fill(row.m_t_DR,weight)
           histos[name+'/m_t_SS'].Fill(row.m_t_SS,weight)
   	   histos[name+'/mDPhiToPfMet_type1'].Fill(abs(row.mDPhiToPfMet_type1),weight)
           histos[name+'/vbfMass'].Fill(row.vbfMass, weight)
           histos[name+'/vbfDeta'].Fill(row.vbfDeta, weight)
        
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
    def VariableCalculateTaucorrection(self,row,tmp_tau_Pt_C,tmp_MET_tPtC):
          # print "inside VariableCalculateTaucorrection00000"
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
    def VariableCalculate(self,row,tau_Pt_C,MET_tPtC):
           taulorenz=ROOT.TLorentzVector()
           muonlorenz=ROOT.TLorentzVector()             
           metlorenz=ROOT.TLorentzVector() 
           #print 'at line 871 the MES %f ' %self.DoMES
           if self.DoTES==1:
              tmpHulaTESUp=Systematics.TESup(tau_Pt_C,MET_tPtC,row.tPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(tmpHulaTESUp[0],row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaTESUp[3],0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaTESUp[4],tmpHulaTESUp[5])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              mMtToPfMet_type1_new=transverseMass_v2(muonlorenz,metlorenz)
              var_d_0  ={'mPt_':row.mPt,'tPt_':tmpHulaTESUp[0],'tMtToPfMet_type1_':tMtToPfMet_type1_new,'m_t_DPhi_':abs(row.m_t_DPhi),'tDPhiToPfMet_type1_':abs(row.tDPhiToPfMet_type1),'type1_pfMetEt_':tmpHulaTESUp[3],'deltaeta_m_t_':abs(row.mEta-row.tEta),'m_t_collinearmass_':collMass_type1_new}
              MVA0fill_new=self.functor(**var_d_0)
              return(MVA0fill_new,collMass_type1_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new,tmpHulaTESUp[0]) 
           if self.DoTES==2:
              tmpHulaTESDown=Systematics.TESdown(tau_Pt_C,MET_tPtC,row.tPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(tmpHulaTESDown[0],row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaTESDown[3],0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaTESDown[4],tmpHulaTESDown[5])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              mMtToPfMet_type1_new=transverseMass_v2(muonlorenz,metlorenz)
              var_d_0  ={'mPt_':row.mPt,'tPt_':tmpHulaTESDown[0],'tMtToPfMet_type1_':tMtToPfMet_type1_new,'m_t_DPhi_':abs(row.m_t_DPhi),'tDPhiToPfMet_type1_':abs(row.tDPhiToPfMet_type1),'type1_pfMetEt_':tmpHulaTESDown[3],'deltaeta_m_t_':abs(row.mEta-row.tEta),'m_t_collinearmass_':collMass_type1_new}
              MVA0fill_new=self.functor(**var_d_0)
              return(MVA0fill_new,collMass_type1_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new,tmpHulaTESDown[0]) 
           if self.DoTES==3:
              taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass)
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass)
              metlorenz.SetPtEtaPhiM(MET_tPtC,0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,MET_tPtC*math.cos(row.type1_pfMetPhi),MET_tPtC*math.sin(row.type1_pfMetPhi))
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              mMtToPfMet_type1_new=transverseMass_v2(muonlorenz,metlorenz)
              var_d_0  ={'mPt_':row.mPt,'tPt_':tau_Pt_C,'tMtToPfMet_type1_':tMtToPfMet_type1_new,'m_t_DPhi_':abs(row.m_t_DPhi),'tDPhiToPfMet_type1_':abs(row.tDPhiToPfMet_type1),'type1_pfMetEt_':MET_tPtC,'deltaeta_m_t_':abs(row.mEta-row.tEta),'m_t_collinearmass_':collMass_type1_new}
              MVA0fill_new=self.functor(**var_d_0)
              return(MVA0fill_new,collMass_type1_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new,tau_Pt_C)
           if self.DoMFT==1:
              tmpHulaMFTUp=Systematics.MFTup(tau_Pt_C,MET_tPtC,row.tPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(tmpHulaMFTUp[0],row.tEta,row.tPhi,row.tMass)
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass)
              metlorenz.SetPtEtaPhiM(tmpHulaMFTUp[3],0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaMFTUp[4],tmpHulaMFTUp[5])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              mMtToPfMet_type1_new=transverseMass_v2(muonlorenz,metlorenz)
              var_d_0  ={'mPt_':row.mPt,'tPt_':tmpHulaMFTUp[0],'tMtToPfMet_type1_':tMtToPfMet_type1_new,'m_t_DPhi_':abs(row.m_t_DPhi),'tDPhiToPfMet_type1_':abs(row.tDPhiToPfMet_type1),'type1_pfMetEt_':tmpHulaMFTUp[3],'deltaeta_m_t_':abs(row.mEta-row.tEta),'m_t_collinearmass_':collMass_type1_new}
              MVA0fill_new=self.functor(**var_d_0)
              return(MVA0fill_new,collMass_type1_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new,tmpHulaMFTUp[0])
           if self.DoMFT==2:
              tmpHulaMFTDown=Systematics.MFTdown(tau_Pt_C,MET_tPtC,row.tPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(tmpHulaMFTDown[0],row.tEta,row.tPhi,row.tMass)
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass)
              metlorenz.SetPtEtaPhiM(tmpHulaMFTDown[3],0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaMFTDown[4],tmpHulaMFTDown[5])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              mMtToPfMet_type1_new=transverseMass_v2(muonlorenz,metlorenz)
              var_d_0  ={'mPt_':row.mPt,'tPt_':tmpHulaMFTDown[0],'tMtToPfMet_type1_':tMtToPfMet_type1_new,'m_t_DPhi_':abs(row.m_t_DPhi),'tDPhiToPfMet_type1_':abs(row.tDPhiToPfMet_type1),'type1_pfMetEt_':tmpHulaMFTDown[3],'deltaeta_m_t_':abs(row.mEta-row.tEta),'m_t_collinearmass_':collMass_type1_new}
              MVA0fill_new=self.functor(**var_d_0)
              return(MVA0fill_new,collMass_type1_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new,tmpHulaMFTDown[0])
           if self.DoMFT==3:
              taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass)
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass)
              metlorenz.SetPtEtaPhiM(MET_tPtC,0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,MET_tPtC*math.cos(row.type1_pfMetPhi),MET_tPtC*math.sin(row.type1_pfMetPhi))
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              mMtToPfMet_type1_new=transverseMass_v2(muonlorenz,metlorenz)
              var_d_0  ={'mPt_':row.mPt,'tPt_':tau_Pt_C,'tMtToPfMet_type1_':tMtToPfMet_type1_new,'m_t_DPhi_':abs(row.m_t_DPhi),'tDPhiToPfMet_type1_':abs(row.tDPhiToPfMet_type1),'type1_pfMetEt_':MET_tPtC,'deltaeta_m_t_':abs(row.mEta-row.tEta),'m_t_collinearmass_':collMass_type1_new}
              MVA0fill_new=self.functor(**var_d_0)
              return(MVA0fill_new,collMass_type1_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new,tau_Pt_C)
           if self.DoMES==1:
              tmpHulaMESUp=Systematics.MESup(row.mPt,row.mEta,MET_tPtC,row.mPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(tmpHulaMESUp[0],row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaMESUp[3],0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaMESUp[4],tmpHulaMESUp[5])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              mMtToPfMet_type1_new=transverseMass_v2(muonlorenz,metlorenz)
              var_d_0  ={'mPt_':tmpHulaMESUp[0],'tPt_':tau_Pt_C,'tMtToPfMet_type1_':tMtToPfMet_type1_new,'m_t_DPhi_':abs(row.m_t_DPhi),'tDPhiToPfMet_type1_':abs(row.tDPhiToPfMet_type1),'type1_pfMetEt_':tmpHulaMESUp[3],'deltaeta_m_t_':abs(row.mEta-row.tEta),'m_t_collinearmass_':collMass_type1_new}
              MVA0fill_new=self.functor(**var_d_0)
              return(MVA0fill_new,collMass_type1_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new,tmpHulaMESUp[0])
           if self.DoMES==2:
              tmpHulaMESDown=Systematics.MESdown(row.mPt,row.mEta,MET_tPtC,row.mPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(tmpHulaMESDown[0],row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaMESDown[3],0,row.type1_pfMetPhi,0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaMESDown[4],tmpHulaMESDown[5])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              mMtToPfMet_type1_new=transverseMass_v2(muonlorenz,metlorenz)
              var_d_0  ={'mPt_':tmpHulaMESDown[0],'tPt_':tau_Pt_C,'tMtToPfMet_type1_':tMtToPfMet_type1_new,'m_t_DPhi_':abs(row.m_t_DPhi),'tDPhiToPfMet_type1_':abs(row.tDPhiToPfMet_type1),'type1_pfMetEt_':tmpHulaMESDown[3],'deltaeta_m_t_':abs(row.mEta-row.tEta),'m_t_collinearmass_':collMass_type1_new}
              MVA0fill_new=self.functor(**var_d_0)
              return(MVA0fill_new,collMass_type1_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new,tmpHulaMESDown[0])
           #   print "the no shift BDT %f and the MESdown %f" %(self.MVA0fill,self.MVA0fill_new)
           if self.DoUES==1:
              if (not self.ls_DY) and row.tZTTGenMatching==5:
#                 print "comes in as USE111111111111111111"
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
              mMtToPfMet_type1_new=transverseMass_v2(muonlorenz,metlorenz)
              tmptDPhiToPfMet_type1=abs(row.tPhi-row.type1_pfMet_shiftedPhi_UnclusteredEnUp)
              if tmptDPhiToPfMet_type1>math.pi:
                 tmptDPhiToPfMet_type1=2*math.pi-tmptDPhiToPfMet_type1
              var_d_0  ={'mPt_':row.mPt,'tPt_':tau_Pt_C,'tMtToPfMet_type1_':tMtToPfMet_type1_new,'m_t_DPhi_':abs(row.m_t_DPhi),'tDPhiToPfMet_type1_':tmptDPhiToPfMet_type1,'type1_pfMetEt_':tmpHulaUESUp[0],'deltaeta_m_t_':abs(row.mEta-row.tEta),'m_t_collinearmass_':collMass_type1_new}
                 #print 'the new tDPhi %f and the original one %f' %(abs(row.tPhi-row.type1_pfMet_shiftedPhi_UnclusteredEnUp),row.tDPhiToPfMet_type1)
              MVA0fill_new=self.functor(**var_d_0)
              return(MVA0fill_new,collMass_type1_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new,tmpHulaUESUp[0])
           if self.DoUES==2:
              if (not self.ls_DY) and row.tZTTGenMatching==5:
                 if  row.tDecayMode==0:
                     UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown+0.018*row.tPt
                 if  row.tDecayMode==1:
                     UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown-0.01*row.tPt
                 if  row.tDecayMode==10:
                     UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown-0.004*row.tPt
              elif self.ls_DY and row.isZmumu  and row.tZTTGenMatching<5 and row.tDecayMode==1:
                    UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown-0.015*row.tPt
              else:
                    UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown
              tmpHulaUESDown=Systematics.UESdown(UES_shiftedMetdown,row.type1_pfMet_shiftedPhi_UnclusteredEnDown)
              taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(tmpHulaUESDown[0],0,tmpHulaUESDown[3],0)
              collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaUESDown[1],tmpHulaUESDown[2])
              tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              mMtToPfMet_type1_new=transverseMass_v2(muonlorenz,metlorenz)
              tmptDPhiToPfMet_type1=abs(row.tPhi-row.type1_pfMet_shiftedPhi_UnclusteredEnDown)
              if tmptDPhiToPfMet_type1>math.pi:
                 tmptDPhiToPfMet_type1=2*math.pi-tmptDPhiToPfMet_type1
              var_d_0  ={'mPt_':row.mPt,'tPt_':tau_Pt_C,'tMtToPfMet_type1_':tMtToPfMet_type1_new,'m_t_DPhi_':abs(row.m_t_DPhi),'tDPhiToPfMet_type1_':tmptDPhiToPfMet_type1,'type1_pfMetEt_':tmpHulaUESDown[0],'deltaeta_m_t_':abs(row.mEta-row.tEta),'m_t_collinearmass_':collMass_type1_new}
              MVA0fill_new=self.functor(**var_d_0)
              return(MVA0fill_new,collMass_type1_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new,tmpHulaUESDown[0])
    def VariableCalculateJES_UESsp(self,row,JESShiftedMet,JESShiftedPhi,tau_Pt_C): 
           taulorenz=ROOT.TLorentzVector()
           muonlorenz=ROOT.TLorentzVector()             
           metlorenz=ROOT.TLorentzVector() 
           if (not self.ls_DY) and row.tZTTGenMatching==5:
              if  row.tDecayMode==0:
                  JESShiftedMet_new=JESShiftedMet+0.018*row.tPt
              if  row.tDecayMode==1:
                  JESShiftedMet_new=JESShiftedMet-0.01*row.tPt
              if  row.tDecayMode==10:
                  JESShiftedMet_new=JESShiftedMet-0.004*row.tPt

           elif  self.ls_DY and  row.isZmumu  and row.tZTTGenMatching<5 and row.tDecayMode==1:
                 JESShiftedMet_new=JESShiftedMet-0.015*row.tPt
           else:
                 JESShiftedMet_new=JESShiftedMet
              #print 'at line 871 the MES %f ' %self.DoMES
           tmpHulaJES=(JESShiftedMet_new,JESShiftedPhi)
           taulorenz.SetPtEtaPhiM(tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
           muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
           metlorenz.SetPtEtaPhiM(tmpHulaJES[0],0,tmpHulaJES[1],0)
           collMass_type1_new,m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,tmpHulaJES[0]*math.cos(tmpHulaJES[1]),tmpHulaJES[0]*math.sin(tmpHulaJES[1]))
           tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
           mMtToPfMet_type1_new=transverseMass_v2(muonlorenz,metlorenz)
           tmptDPhiToPfMet_type1=abs(row.tPhi-JESShiftedPhi)
           if tmptDPhiToPfMet_type1>math.pi:
              tmptDPhiToPfMet_type1=2*math.pi-tmptDPhiToPfMet_type1
           #print 'old tDPhiMt %f new %f' %(row.tDPhiToPfMet_type1,tmptDPhiToPfMet_type1)
           var_d_0  ={'mPt_':row.mPt,'tPt_':tau_Pt_C,'tMtToPfMet_type1_':tMtToPfMet_type1_new,'m_t_DPhi_':abs(row.m_t_DPhi),'tDPhiToPfMet_type1_':tmptDPhiToPfMet_type1,'type1_pfMetEt_':metlorenz.Pt(),'deltaeta_m_t_':abs(row.mEta-row.tEta),'m_t_collinearmass_':collMass_type1_new}

           MVA0fill_new=self.functor(**var_d_0)
           return(MVA0fill_new,collMass_type1_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new) 

    def presel(self, row):
       # if not (row.singleIsoMu20Pass or row.singleIsoTkMu20Pass):
        #if not (row.singleIsoMu22Pass or row.singleIsoTkMu22Pass):
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
    def WeightJetbin(self,row):
        weighttargettmp=self.weighttarget
        if self.ls_Jets:
           if row.numGenJets>4:
              print "Error***********************Error***********"
           if self.ls_Wjets:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightNormal."+"WJetsToLNu_TuneCUETP8M1_13TeV_madgraphMLM_pythia8")) 
              else:
                 return 1.0/(eval("weightNormal."+"W"+str(int(row.numGenJets))+"JetsToLNu_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
           if self.ls_ZTauTau:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightNormal."+"ZTauTauJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8")) 
              else: 
                 return 1.0/(eval("weightNormal."+"ZTauTau"+str(int(row.numGenJets))+"JetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
           if self.ls_DY:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightNormal."+"DYJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8")) 
              else: 
                 return 1.0/(eval("weightNormal."+"DY"+str(int(row.numGenJets))+"JetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
        else:
              return 1.0/(eval("weightNormal."+self.weighttarget))
    def WjetsEnrich(self,row):
        if (self.tMtToPfMet_type1_new>60 and self.mMtToPfMet_type1_new>80):
            return True
        return False
    #def ZttEnrich(self,row):
    #    if ((row.m_t_Mass>40 and row.m_t_Mass<80) and row.mMtToPfMet_type1<40 and row.m_t_PZetaLess0p85PZetaVis>-25):
    #        return True
    #    return False
    #def ZmmEnrich(self,row):
    #    if ((row.m_t_Mass>86 and row.m_t_Mass<96) and row.mMtToPfMet_type1<40 and row.type1_pfMetEt<25):
    #        return True
    #    return False
    def ZttEnrich(self,row,m_t_Mass_new,tMtToPfMet_type1_new,mMtToPfMet_type1_new):
        if ((m_t_Mass_new>40 and m_t_Mass_new<80) and mMtToPfMet_type1_new<60 and abs(row.mEta-row.tEta)<1.4) and tMtToPfMet_type1_new<90:
            return True
        return False
    def ZmmEnrich(self,row,m_t_Mass_new,mMtToPfMet_type1_new,type1_pfMetEt_new,tMtToPfMet_type1_new):
        if ((m_t_Mass_new>80 and m_t_Mass_new<100) and mMtToPfMet_type1_new<80 and type1_pfMetEt_new<60 and tMtToPfMet_type1_new<90 and abs(row.mEta-row.tEta)<1.4):
            return True
        return False
    def TTbarEnrich(self,row):
        if ((self.m_t_Mass_new>60)and row.m_t_PZetaLess0p85PZetaVis<-50):
            return True
        return False
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
        if self.DoMES==1  :
        #   if abs(row.mEta)<=1.2:
                 if row.mPt*1.002 < 26:
                    return False
        if self.DoMES==2  :
        #   if abs(row.mEta)<=1.2:
                 if row.mPt*0.998 < 26:
                    return False
        if not self.DoMES:
           if row.mPt< 26:
               return False
    #    if abs(row.mEta) >= 2.4:
    #        return False
  
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
  
    #    if row.tPt<30 :
    #        return False
        if abs(row.tEta)>=2.3:
            return False
        return True
    def gg(self,row):
       if self.tMtToPfMet_type1_new > 105:  #was 50   #newcuts65
             return False
       return True

    def boost(self,row):
          if self.tMtToPfMet_type1_new > 105:  #was 50   #newcuts65
                return False
          return True

    def vbf(self,row):
        if self.tMtToPfMet_type1_new > 85:  #was 50   #newcuts65
              return False
	if(abs(row.vbfDeta)<3.5):   #was 2.5    #newcut 2.0
	    return False
        if row.vbfMass < 550:    #was 200   newcut 325
	    return False
        return True

    def vbf_gg(self,row):
        if self.tMtToPfMet_type1_new > 105:  #was 50   #newcuts65
              return False
        if not self.DoJES:
	   if (row.vbfMass >= 550):   #was 2.5    #newcut 2.0
	      return False
        return True
    def vbf_vbf(self,row):
        if self.tMtToPfMet_type1_new > 85:  #was 50   #newcuts65
              return False
        if not self.DoJES:
   	   if((row.vbfMass < 550)):   #was 2.5    #newcut 2.0
	      return False
        return True
    def oppositesign(self,row):
	if row.mCharge*row.tCharge!=-1:
            return False
	return True

    #def obj1_id(self, row):
    #    return bool(row.mPFIDTight)  
 
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
	#return  row.tAgainstElectronMediumMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding
	return  row.tAgainstElectronVLooseMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding

    def vetos(self,row):
		return  (bool (row.muVetoPt5IsoIdVtx<1) and bool (row.eVetoMVAIso<1) and bool (row.tauVetoPt20Loose3HitsVtx<1) )

    #def obj1_iso(self, row):
    #    return bool(row.mRelPFIsoDBDefault <0.12)
   
    def obj1_iso(self,row):
         return bool(row.mRelPFIsoDBDefaultR04 <0.15)
    def obj1_isoloose(self,row):
         return bool(row.mRelPFIsoDBDefaultR04 <0.25)
  #  def obj2_iso(self, row):
  #      return  row.tByTightCombinedIsolationDeltaBetaCorr3Hits
  #  def obj2_iso(self, row):
  #      return  row.tByTightIsolationMVArun2v1DBoldDMwLT
    def SetsysZero(self,row):
        self.DoMES=0; self.DoTES=0; self.DoJES=0;self.DoUES=0;self.DoFakeshapeDM=0;self.DoMFT=0;self.DoUESsp=0;self.DoPileup=0
    def obj2_iso(self, row):
        return  row.tByTightIsolationMVArun2v1DBoldDMwLT
    def obj2_iso_NT_VLoose(self, row):
        return bool( (not row.tByTightIsolationMVArun2v1DBoldDMwLT) and  row.tByVLooseIsolationMVArun2v1DBoldDMwLT)

#    def obj2_mediso(self, row):
#	 return row.tByMediumCombinedIsolationDeltaBetaCorr3Hits
    def obj2_mediso(self, row):
	 return row.tByMediumIsolationMVArun2v1DBoldDMwLT

    def obj1_antiiso(self, row):
        return bool(row.mRelPFIsoDBDefaultR04 >0.2) 

#    def obj2_looseiso(self, row):
#        return row.tByLooseCombinedIsolationDeltaBetaCorr3Hits
    def obj2_Vlooseiso(self, row):
        return row.tByVLooseIsolationMVArun2v1DBoldDMwLT

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
#            if self.is_data: 
            self.Sysin=0
            if not self.presel(row):
                  continue
#            if not self.selectZmm(row):
#                continue
            if not self.selectZtt(row):
                continue
            if not self.kinematics_new(row): 
                continue
  #          if not self.obj2_Vlooseiso(row):
  #              continue 
            if not self.obj1_isoloose(row):
                continue
#            if not self.obj1_id(row):  
#                continue
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

#            if  row.bjetCISVVeto30Medium:
#                   continue
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
            #print "one new event*****************************"
            self.tau_Pt_C,self.MET_tPtC=self.TauESC(row)
            self.Sysin=0
            #print "one new event*****************************1"
            if self.kinematics(row):
               self.collMass_type1_new,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new=self.VariableCalculateTaucorrection(row,self.tau_Pt_C,self.MET_tPtC)
               #print "one new event*****************************2"
               self.var_d_0  ={'mPt_':row.mPt,'tPt_':self.tau_Pt_C,'tMtToPfMet_type1_':self.tMtToPfMet_type1_new,'m_t_DPhi_':abs(row.m_t_DPhi),'tDPhiToPfMet_type1_':abs(row.tDPhiToPfMet_type1),'type1_pfMetEt_':self.MET_tPtC,'deltaeta_m_t_':abs(row.mEta-row.tEta),'m_t_collinearmass_':self.collMass_type1_new}
               #print "one new event*****************************3"
               MVA0=self.functor(**self.var_d_0)
               #print "one new event*****************************4"
               self.MVA0fill=MVA0
               #print 'the BDT output at the most beginning %f and after assginment %f'  %(MVA0,self.MVA0fill)
            if (fakeset or wjets_fakes or tuning) and self.kinematics(row):
             if self.obj1_iso(row):
               if self.obj2_iso(row) and not self.oppositesign(row):
                  if fakeset:
               #      if (not self.light) and self.WjetsEnrich(row):
               #         self.fill_histos(row,'preselectionSSEnWjets')
                     self.fill_histos(row,'preselectionSS')
                  if (not self.light):
                     if row.jetVeto30==0:
                       self.fill_histos(row,'IsoSS0Jet')
                       #if self.gg(row):
                       #self.fill_histos(row,'ggIsoSS')
                       if RUN_OPTIMIZATION:
                          for  i in optimizer_new.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
                             tmp=os.path.join("ggIsoSS",i)
                             self.fill_histos(row,tmp,False)
                     if row.jetVeto30==1:
                       self.fill_histos(row,'IsoSS1Jet')
                       #if self.boost(row):
                       #self.fill_histos(row,'boostIsoSS')
                       if RUN_OPTIMIZATION:
                          for  i in optimizer_new.compute_regions_1jet(row.tPt, row.mPt,deltaPhi(row.mPhi,row.tPhi),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
                             tmp=os.path.join("boostIsoSS",i)
                             self.fill_histos(row,tmp,False)
                     if row.jetVeto30==2:
                   #    self.fill_histos(row,'IsoSS2Jet')
                       #if self.vbf(row):
                   #    self.fill_histos(row,'vbfIsoSS')
                       if((row.vbfMass < 550)):
                          self.fill_histos(row,'IsoSS2Jet_gg')
                        #  self.fill_histos(row,'vbf_ggIsoSS')
                       if((row.vbfMass >= 550)):
                          self.fill_histos(row,'IsoSS2Jet_vbf')
                        #  self.fill_histos(row,'vbf_vbfIsoSS')
                       if RUN_OPTIMIZATION:
                          for  i in optimizer_new.compute_regions_2jettight(row.tPt, row.mPt,row.tMtToPfMet_type1,row.vbfMass,row.vbfDeta):
                             tmp=os.path.join("vbf_vbfIsoSS",i)
                             self.fill_histos(row,tmp,False)
                       #if self.vbf_gg(row):
                       #   if row.vbfMass>100:
                       #   else:
                       #      self.fill_histos(row,'boostIsoSS') 
                       if RUN_OPTIMIZATION:
                          for  i in optimizer_new.compute_regions_2jetloose(row.tPt, row.mPt,row.tMtToPfMet_type1,row.vbfMass,row.vbfDeta):
                             tmp=os.path.join("vbf_ggIsoSS",i)
                             self.fill_histos(row,tmp,False)
#"IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"
            if fakeset and self.kinematics(row):
             if self.obj1_iso(row):
               if not self.obj2_iso(row) and not self.oppositesign(row) :#and self.obj2_iso_NT_VLoose(row):
                      self.fill_histos(row,'notIsoSS',True)
                      if (not self.light):
                      #   if self.WjetsEnrich(row):
                      #      self.fill_histos(row,'notIsoEnWjetsSS',True)
                         if row.jetVeto30==0:
                           self.fill_histos(row,'notIsoSS0Jet',True)
#                          if self.gg(row):
#                             self.fill_histos(row,'ggIsoSS')
                         if row.jetVeto30==1:
                           self.fill_histos(row,'notIsoSS1Jet',True)
#                          if self.boost(row):
#                             self.fill_histos(row,'boostIsoSS')
                         if row.jetVeto30==2:
                    #       self.fill_histos(row,'notIsoSS2Jet',True)
#                          if self.vbf(row):
 #                            self.fill_histos(row,'vbfIsoSS')
                           if((row.vbfMass < 550)):
                              self.fill_histos(row,'notIsoSS2Jet_gg',True)
                           if((row.vbfMass >= 550)):
                              self.fill_histos(row,'notIsoSS2Jet_vbf',True)
#                           if self.vbf_vbf(row):
#                              self.fill_histos(row,'vbf_vbfIsoSS')
#                           if self.vbf_gg(row):
                           #   if row.vbfMass>100:
#                                 self.fill_histos(row,'vbf_ggIsoSS')
                           #   else:
                           #      self.fill_histos(row,'boostIsoSS') 
#              self.fill_histos(row,'notIsoNotWeightedSS',False)
             if not self.obj1_iso(row):
               if  self.obj2_iso(row) and not self.oppositesign(row) :
                      self.fill_histos(row,'notIsoSSM',True,faketype="muonfake") 
                      if (not self.light):
                         if row.jetVeto30==0:
                           self.fill_histos(row,'notIsoSS0JetM',True,faketype="muonfake")
#                          if self.gg(row):
#                             self.fill_histos(row,'ggIsoSS')
                         if row.jetVeto30==1:
                           self.fill_histos(row,'notIsoSS1JetM',True,faketype="muonfake")
#                          if self.boost(row):
#                             self.fill_histos(row,'boostIsoSS')
                         if row.jetVeto30==2:
                    #       self.fill_histos(row,'notIsoSS2JetM',True,faketype="muonfake")
#                          if self.vbf(row):
 #                            self.fill_histos(row,'vbfIsoSS')
                           if((row.vbfMass < 550)):
                              self.fill_histos(row,'notIsoSS2Jet_ggM',True,faketype="muonfake")
                           if((row.vbfMass >= 550)):
                              self.fill_histos(row,'notIsoSS2Jet_vbfM',True,faketype="muonfake")
             if not self.obj1_iso(row):
               if not self.obj2_iso(row) and not self.oppositesign(row) :
                      self.fill_histos(row,'notIsoSSMT',True,faketype="mtfake") 
                      if (not self.light):
                         if row.jetVeto30==0:
                           self.fill_histos(row,'notIsoSS0JetMT',True,faketype="mtfake")
#                          if self.gg(row):
#                             self.fill_histos(row,'ggIsoSS')
                         if row.jetVeto30==1:
                           self.fill_histos(row,'notIsoSS1JetMT',True,faketype="mtfake")
#                          if self.boost(row):
#                             self.fill_histos(row,'boostIsoSS')
                         if row.jetVeto30==2:
                 #          self.fill_histos(row,'notIsoSS2JetMT',True,faketype="mtfake")
#                          if self.vbf(row):
 #                            self.fill_histos(row,'vbfIsoSS')
                           if((row.vbfMass < 550)):
                              self.fill_histos(row,'notIsoSS2Jet_ggMT',True,faketype="mtfake")
                           if((row.vbfMass >= 550)):
                              self.fill_histos(row,'notIsoSS2Jet_vbfMT',True,faketype="mtfake")

            if self.obj2_iso(row) and self.oppositesign(row) and self.kinematics(row):  
#              print row.m_t_collinearmass
             if self.obj1_iso(row):
                 if not self.light:
                    if  fakeset:
                       #print "Sysin value at line 1423 %f" %self.Sysin
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
                    #  self.fill_histos(row,'preselection0Jet')
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'preslectionEnWjets0Jet')
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'preslectionEnZtt0Jet')
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'preslectionEnZmm0Jet')
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'preslectionEnTTbar0Jet')
                      if wjets_fakes and row.isWmunu==1:
                         self.fill_histos(row,'Wmunu_preselection0Jet')
                      if wjets_fakes and row.isWtaunu==1:
                         self.fill_histos(row,'Wtaunu_preselection0Jet')
                      if wjets_fakes and (row.isWtaunu==0 and row.isWmunu==0):
                         self.fill_histos(row,'W2jets_preselection0Jet')
         
                    if row.jetVeto30==1:
                    #  self.fill_histos(row,'preselection1Jet')
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'preslectionEnWjets1Jet')
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'preslectionEnZtt1Jet')
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'preslectionEnZmm1Jet')
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'preslectionEnTTbar1Jet')
                      if wjets_fakes and row.isWmunu==1:
                         self.fill_histos(row,'Wmunu_preselection1Jet')
                      if wjets_fakes and row.isWtaunu==1:
                         self.fill_histos(row,'Wtaunu_preselection1Jet')
                      if wjets_fakes and (row.isWtaunu==0 and row.isWmunu==0):
                         self.fill_histos(row,'W2jets_preselection1Jet')
                    if row.jetVeto30==2:
                 #     self.fill_histos(row,'preselection2Jet')
                 #     if self.WjetsEnrich(row):
                 #        self.fill_histos(row,'preslectionEnWjets2Jet')
                 #     if wjets_fakes and row.isWmunu==1:
                 #        self.fill_histos(row,'Wmunu_preselection2Jet')
                 #     if wjets_fakes and row.isWtaunu==1:
                 #        self.fill_histos(row,'Wtaunu_preselection2Jet')
                 #     if wjets_fakes and (row.isWtaunu==0 and row.isWmunu==0):
                 #        self.fill_histos(row,'W2jets_preselection2Jet')
                      if((row.vbfMass < 550)):
                   #     self.fill_histos(row,'preselection2Jet_gg')
                        if self.WjetsEnrich(row):
                           self.fill_histos(row,'preslectionEnWjets2Jet_gg')
                        if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                           self.fill_histos(row,'preslectionEnZtt2Jet_gg')
                        if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                           self.fill_histos(row,'preslectionEnZmm2Jet_gg')
                        if self.TTbarEnrich(row):
                           self.fill_histos(row,'preslectionEnTTbar2Jet_gg')
                      if((row.vbfMass >= 550)):
                   #     self.fill_histos(row,'preselection2Jet_vbf')
                        if self.WjetsEnrich(row):
                           self.fill_histos(row,'preslectionEnWjets2Jet_vbf')
                        if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                           self.fill_histos(row,'preslectionEnZtt2Jet_vbf')
                        if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                           self.fill_histos(row,'preslectionEnZmm2Jet_vbf')
                        if self.TTbarEnrich(row):
                           self.fill_histos(row,'preslectionEnTTbar2Jet_vbf')

             #    if self.gg(row):
             #        self.fill_histos(row,'gg',False)

                 if  row.jetVeto30==0:
                     if RUN_OPTIMIZATION:
                        for  i in optimizer_new.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
                           tmp=os.path.join("gg",i)
                           self.fill_histos(row,tmp,False)	
                     #if self.gg(row):
                        #   print "the preselection SF Correction %f" %(self.correction(row))
                           #print 'fill normal gg line 1505' 
                     self.fill_histos(row,'gg',False)
#                     print "NOS HIF OUT PUT THOUGHT %f" %(self.MVA0fill)
                     if not self.light:
                        if wjets_fakes and row.isWmunu==1:
                           self.fill_histos(row,'Wmunu_gg',False)
                        if wjets_fakes and row.isWtaunu==1:
                           self.fill_histos(row,'Wtaunu_gg',False)
                        if wjets_fakes and (row.isWtaunu==0 and row.isWmunu==0):
                           self.fill_histos(row,'W2jets_gg',False)
 #                          if row.tDecayMode==0:
 #                                 self.fill_histos(row,'ggTD0',False)
 #                          if row.tDecayMode==1:
 #                                 self.fill_histos(row,'ggTD1',False)
 #                          if row.tDecayMode==10:
 #                                 self.fill_histos(row,'ggTD10',False)

             #    if self.boost(row):
             #        self.fill_histos(row,'boost',False)
                 if row.jetVeto30==1:
                     if RUN_OPTIMIZATION:
                        for  i in optimizer_new.compute_regions_1jet(row.tPt, row.mPt,deltaPhi(row.mPhi,row.tPhi),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
                           tmp=os.path.join("boost",i)
                           self.fill_histos(row,tmp,False)	
                     #if self.boost(row):
                           #print 'fill normal boost line 1528' 
                     self.fill_histos(row,'boost')
                     if not self.light:
                        if wjets_fakes and row.isWmunu==1:
                           self.fill_histos(row,'Wmunu_boost')
                        if wjets_fakes and row.isWtaunu==1:
                           self.fill_histos(row,'Wtaunu_boost')
                        if wjets_fakes and (row.isWtaunu==0 and row.isWmunu==0):
                           self.fill_histos(row,'W2jets_boost')
#                           if row.tDecayMode==0:
#                                  self.fill_histos(row,'boostTD0',False)
#                           if row.tDecayMode==1:
#                                  self.fill_histos(row,'boostTD1',False)
#                           if row.tDecayMode==10:
#                                  self.fill_histos(row,'boostTD10',False)
                 #if (row.jetVeto30>=2 and row.vbfJetVeto30 <= 0) :
                 if (row.jetVeto30==2) :
#                     if RUN_OPTIMIZATION:
#                        for  i in optimizer.compute_regions_2jet(row.tPt, row.mPt,row.tMtToPfMet_type1,row.vbfMass,row.vbfDeta):
#                          tmp=os.path.join("vbf",i)
#                          self.fill_histos(row,tmp,False)
                #     if not self.light:	
                     #   if self.vbf(row):
                #           self.fill_histos(row,'vbf')
                     #if self.vbf_gg(row):
                     if row.vbfMass<550:
                           #print 'fill normal vbf_gg line 1552' 
                        self.fill_histos(row,'vbf_gg')
                     if not self.light:
                        if wjets_fakes and row.isWmunu==1:
                           self.fill_histos(row,'Wmunu_vbf_gg')
                        if wjets_fakes and row.isWtaunu==1:
                           self.fill_histos(row,'Wtaunu_vbf_gg')
                        if wjets_fakes and (row.isWtaunu==0 and row.isWmunu==0):
                           self.fill_histos(row,'W2jets_vbf_gg')
                      #  else:
                      #     self.fill_histos(row,'boost')
                      #     if wjets_fakes and row.isWmunu==1:
                      #        self.fill_histos(row,'Wmunu_boost')
                      #     if wjets_fakes and row.isWtaunu==1:
                      #        self.fill_histos(row,'Wtaunu_boost')
                      #     if wjets_fakes and (row.isWtaunu==0 and row.isWmunu==0):
                      #        self.fill_histos(row,'W2jets_boost')
                     if RUN_OPTIMIZATION:
                           for  i in optimizer_new.compute_regions_2jetloose(row.tPt, row.mPt,row.tMtToPfMet_type1,row.vbfMass,row.vbfDeta):
                              tmp=os.path.join("vbf_gg",i)
                              self.fill_histos(row,tmp,False)
                     #if self.vbf_vbf(row):
                           #print 'fill normal vbf_vbf line 1573' 
                     if row.vbfMass>=550:
                        self.fill_histos(row,'vbf_vbf')
                     if not self.light:
                        if wjets_fakes and row.isWmunu==1:
                           self.fill_histos(row,'Wmunu_vbf_vbf')
                        if wjets_fakes and row.isWtaunu==1:
                           self.fill_histos(row,'Wtaunu_vbf_vbf')
                        if wjets_fakes and (row.isWtaunu==0 and row.isWmunu==0):
                           self.fill_histos(row,'W2jets_vbf_vbf')
                     if RUN_OPTIMIZATION:
                           for  i in optimizer_new.compute_regions_2jettight(row.tPt, row.mPt,row.tMtToPfMet_type1,row.vbfMass,row.vbfDeta):
                              tmp=os.path.join("vbf_vbf",i)
                              self.fill_histos(row,tmp,False)
#                           if row.tDecayMode==0:
#                                  self.fill_histos(row,'vbfTD0',False)
#                           if row.tDecayMode==1:
#                                  self.fill_histos(row,'vbfTD1',False)
#                           if row.tDecayMode==10:
#                                  self.fill_histos(row,'vbfTD10',False)
             # if self.vbf(row):
             #     self.fill_histos(row,'vbf',False)
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
#                    self.fill_histos(row,'notIsoNotWeighted',False)

                    if row.jetVeto30==0:
                   #   self.fill_histos(row,'notIso0Jet',True)
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets0Jet',True)
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZtt0Jet',True)
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZmm0Jet',True)
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'notIsoEnTTbar0Jet',True)
                    if row.jetVeto30==1:
                   #   self.fill_histos(row,'notIso1Jet',True)
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets1Jet',True)
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZtt1Jet',True)
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZmm1Jet',True)
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'notIsoEnTTbar1Jet',True)
                    if row.jetVeto30==2:
                   #   self.fill_histos(row,'notIso2Jet',True)
                   #   if self.WjetsEnrich(row):
                   #      self.fill_histos(row,'notIsoEnWjets2Jet',True)
                      if((row.vbfMass < 550)):
                   #      self.fill_histos(row,'notIso2Jet_gg',True)
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjets2Jet_gg',True)
                         if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                            self.fill_histos(row,'notIsoEnZtt2Jet_gg',True)
                         if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                            self.fill_histos(row,'notIsoEnZmm2Jet_gg',True)
                         if self.TTbarEnrich(row):
                            self.fill_histos(row,'notIsoEnTTbar2Jet_gg',True)
                      if((row.vbfMass >= 550)):
                   #      self.fill_histos(row,'notIso2Jet_vbf',True)
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjets2Jet_vbf',True)
                         if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                            self.fill_histos(row,'notIsoEnZtt2Jet_vbf',True)
                         if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                            self.fill_histos(row,'notIsoEnZmm2Jet_vbf',True)
                         if self.TTbarEnrich(row):
                            self.fill_histos(row,'notIsoEnTTbar2Jet_vbf',True)
                 if  row.jetVeto30==0:
                    # #if RUN_OPTIMIZATION:
                       # for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),row.tMtToPfMet_type1):
                    # #   for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),abs(row.mDPhiToPfMet_type1),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
                    # #      tmp=os.path.join("ggNotIso",i)
                    # #      self.fill_histos(row,tmp,True)
                     #if self.gg(row):
                     self.fill_histos(row,'ggNotIso',True)
                    #          self.fill_histos(row,'ggNotIso2ndUp',True,'taufake',"2ndUp")
                    #          self.fill_histos(row,'ggNotIso2ndDown',True,'taufake',"2ndDown")
           #      if self.gg(row):
           #          self.fill_histos(row,'ggNotIso',True)
                 if row.jetVeto30==1:
                  #  # if RUN_OPTIMIZATION:
                  #  #    for  i in optimizer.compute_regions_1jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
                  #  #      tmp=os.path.join("boostNotIso",i)
                  #  #       self.fill_histos(row,tmp,True)
                     #if self.boost(row):
                     self.fill_histos(row,'boostNotIso',True)
         #        if self.boost(row):
         #            self.fill_histos(row,'boostNotIso',True)
                 #if (row.jetVeto30>=2 and row.vbfJetVeto30 <= 0) :
                 if (row.jetVeto30==2) :
            #     #    if RUN_OPTIMIZATION:
            #     #       for  i in optimizer.compute_regions_2jet(row.tPt, row.mPt,row.tMtToPfMet_type1,row.vbfMass,row.vbfDeta):
            #     #          tmp=os.path.join("vbfNotIso",i)
            #     #          self.fill_histos(row,tmp,True)
                    # if not self.light:
                     #   if self.vbf(row):
                    #       self.fill_histos(row,'vbfNotIso',True)
                     #if self.vbf_gg(row):
                   #     if row.vbfMass>100: 
                     if((row.vbfMass < 550)):
                       self.fill_histos(row,'vbf_ggNotIso',True)
                    #    else:
                    #       self.fill_histos(row,'boostNotIso',True)
                    #       if fakeset:
                    #          self.fill_histos(row,'boostNotIso1stUp',True,'taufake',"1stUp")
                    #          self.fill_histos(row,'boostNotIso1stDown',True,'taufake',"1stDown")
                    #          self.fill_histos(row,'boostNotIso2ndUp',True,'taufake',"2ndUp")
                    #          self.fill_histos(row,'boostNotIso2ndDown',True,'taufake',"2ndDown")

                     #if self.vbf_vbf(row):
                     if((row.vbfMass >= 550)):
                       self.fill_histos(row,'vbf_vbfNotIso',True)
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
#                    self.fill_histos(row,'notIsoNotWeighted',False)

                    if row.jetVeto30==0:
                    #  self.fill_histos(row,'notIso0JetMT',True,faketype="mtfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets0JetMT',True,faketype="mtfake")
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZtt0JetMT',True,faketype="mtfake")
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZmm0JetMT',True,faketype="mtfake")
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'notIsoEnTTbar0JetMT',True,faketype="mtfake")
                    if row.jetVeto30==1:
                    #  self.fill_histos(row,'notIso1JetMT',True,faketype="mtfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets1JetMT',True,faketype="mtfake")
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZtt1JetMT',True,faketype="mtfake")
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZmm1JetMT',True,faketype="mtfake")
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'notIsoEnTTbar1JetMT',True,faketype="mtfake")
                    if row.jetVeto30==2:
                     # self.fill_histos(row,'notIso2JetMT',True,faketype="mtfake")
                      #if self.WjetsEnrich(row):
                      #   self.fill_histos(row,'notIsoEnWjets2JetMT',True,faketype="mtfake")
                      if((row.vbfMass < 550)):
                       #  self.fill_histos(row,'notIso2Jet_ggMT',True,faketype="mtfake")
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjets2Jet_ggMT',True,faketype="mtfake")
                         if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                            self.fill_histos(row,'notIsoEnZtt2Jet_ggMT',True,faketype="mtfake")
                         if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                            self.fill_histos(row,'notIsoEnZmm2Jet_ggMT',True,faketype="mtfake")
                         if self.TTbarEnrich(row):
                            self.fill_histos(row,'notIsoEnTTbar2Jet_ggMT',True,faketype="mtfake")
                      if((row.vbfMass >= 550)):
                        # self.fill_histos(row,'notIso2Jet_vbfMT',True,faketype="mtfake")
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjets2Jet_vbfMT',True,faketype="mtfake")
                         if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                            self.fill_histos(row,'notIsoEnZtt2Jet_vbfMT',True,faketype="mtfake")
                         if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                            self.fill_histos(row,'notIsoEnZmm2Jet_vbfMT',True,faketype="mtfake")
                         if self.TTbarEnrich(row):
                            self.fill_histos(row,'notIsoEnTTbar2Jet_vbfMT',True,faketype="mtfake")
                 if  row.jetVeto30==0:
                    # #if RUN_OPTIMIZATION:
                       # for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),row.tMtToPfMet_type1):
                    # #   for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),abs(row.mDPhiToPfMet_type1),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
                    # #      tmp=os.path.join("ggNotIso",i)
                    # #      self.fill_histos(row,tmp,True)
                     #if self.gg(row):
                     self.fill_histos(row,'ggNotIsoMT',True,faketype="mtfake")
           #      if self.gg(row):
           #          self.fill_histos(row,'ggNotIso',True)
                 if row.jetVeto30==1:
                  #  # if RUN_OPTIMIZATION:
                  #  #    for  i in optimizer.compute_regions_1jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
                  #  #      tmp=os.path.join("boostNotIso",i)
                  #  #       self.fill_histos(row,tmp,True)
                     #if self.boost(row):
                     self.fill_histos(row,'boostNotIsoMT',True,faketype="mtfake")
                 if (row.jetVeto30==2) :
            #     #    if RUN_OPTIMIZATION:
            #     #       for  i in optimizer.compute_regions_2jet(row.tPt, row.mPt,row.tMtToPfMet_type1,row.vbfMass,row.vbfDeta):
            #     #          tmp=os.path.join("vbfNotIso",i)
            #     #          self.fill_histos(row,tmp,True)
                   #  if not self.light:
                     #   if self.vbf(row):
                   #        self.fill_histos(row,'vbfNotIsoMT',True,faketype="mtfake")
                     #if self.vbf_gg(row):
                    #    if row.vbfMass>100: 
                     if((row.vbfMass < 550)):
                        self.fill_histos(row,'vbf_ggNotIsoMT',True,faketype="mtfake")

                     #if self.vbf_vbf(row):
                     if((row.vbfMass >= 550)):
                       self.fill_histos(row,'vbf_vbfNotIsoMT',True,faketype="mtfake")
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
#                    self.fill_histos(row,'notIsoNotWeighted',False)

                    if row.jetVeto30==0:
                    #  self.fill_histos(row,'notIso0JetM',True,faketype="muonfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets0JetM',True,faketype="muonfake")
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZtt0JetM',True,faketype="muonfake")
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZmm0JetM',True,faketype="muonfake")
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'notIsoEnTTbar0JetM',True,faketype="muonfake")
                    if row.jetVeto30==1:
                     # self.fill_histos(row,'notIso1JetM',True,faketype="muonfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets1JetM',True,faketype="muonfake")
                      if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZtt1JetM',True,faketype="muonfake")
                      if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                         self.fill_histos(row,'notIsoEnZmm1JetM',True,faketype="muonfake")
                      if self.TTbarEnrich(row):
                         self.fill_histos(row,'notIsoEnTTbar1JetM',True,faketype="muonfake")
                    if row.jetVeto30==2:
                     # self.fill_histos(row,'notIso2JetM',True,faketype="muonfake")
                     # if self.WjetsEnrich(row):
                     #    self.fill_histos(row,'notIsoEnWjets2JetM',True,faketype="muonfake")
                      if((row.vbfMass < 550)):
                     #    self.fill_histos(row,'notIso2Jet_ggM',True,faketype="muonfake")
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjets2Jet_ggM',True,faketype="muonfake")
                         if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                            self.fill_histos(row,'notIsoEnZtt2Jet_ggM',True,faketype="muonfake")
                         if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                            self.fill_histos(row,'notIsoEnZmm2Jet_ggM',True,faketype="muonfake")
                         if self.TTbarEnrich(row):
                            self.fill_histos(row,'notIsoEnTTbar2Jet_ggM',True,faketype="muonfake")

                      if((row.vbfMass >= 550)):
                      #   self.fill_histos(row,'notIso2Jet_vbfM',True,faketype="muonfake")
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjets2Jet_vbfM',True,faketype="muonfake")
                         if self.ZttEnrich(row,self.m_t_Mass_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new):
                            self.fill_histos(row,'notIsoEnZtt2Jet_vbfM',True,faketype="muonfake")
                         if self.ZmmEnrich(row,self.m_t_Mass_new,self.mMtToPfMet_type1_new,self.MET_tPtC,self.tMtToPfMet_type1_new):
                            self.fill_histos(row,'notIsoEnZmm2Jet_vbfM',True,faketype="muonfake")
                         if self.TTbarEnrich(row):
                            self.fill_histos(row,'notIsoEnTTbar2Jet_vbfM',True,faketype="muonfake")
                 if  row.jetVeto30==0:
                    # #if RUN_OPTIMIZATION:
                       # for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),row.tMtToPfMet_type1):
                    # #   for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),abs(row.mDPhiToPfMet_type1),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
                    # #      tmp=os.path.join("ggNotIso",i)
                    # #      self.fill_histos(row,tmp,True)
                     #if self.gg(row):
                     self.fill_histos(row,'ggNotIsoM',True,faketype="muonfake")
           #      if self.gg(row):
           #          self.fill_histos(row,'ggNotIso',True)
                 if row.jetVeto30==1:
                  #  # if RUN_OPTIMIZATION:
                  #  #    for  i in optimizer.compute_regions_1jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
                  #  #      tmp=os.path.join("boostNotIso",i)
                  #  #       self.fill_histos(row,tmp,True)
                     #if self.boost(row):
                     self.fill_histos(row,'boostNotIsoM',True,faketype="muonfake")
         #        if self.boost(row):
         #            self.fill_histos(row,'boostNotIso',True)
                 #if (row.jetVeto30>=2 and row.vbfJetVeto30 <= 0) :
                 if (row.jetVeto30==2) :
            #     #    if RUN_OPTIMIZATION:
            #     #       for  i in optimizer.compute_regions_2jet(row.tPt, row.mPt,row.tMtToPfMet_type1,row.vbfMass,row.vbfDeta):
            #     #          tmp=os.path.join("vbfNotIso",i)
            #     #          self.fill_histos(row,tmp,True)
                  #   if not self.light:
                     #   if self.vbf(row):
                  #         self.fill_histos(row,'vbfNotIsoM',True,faketype="muonfake")
                     #if self.vbf_gg(row):
                    #    if row.vbfMass>100: 
                     if((row.vbfMass < 550)):
                        self.fill_histos(row,'vbf_ggNotIsoM',True,faketype="muonfake")

                     #if self.vbf_vbf(row):
                     if((row.vbfMass >= 550)):
                        self.fill_histos(row,'vbf_vbfNotIsoM',True,faketype="muonfake")
    #        global Sysin
#            print 'the def tPt %f  and M_coll value %f'  %(self.tau_Pt_C,self.collMass_type1_new)   
            self.Sysin=0
            if self.Sysin:
                 sysneedI=['MESUp','MESDown','UESUp','UESDown']
                 sysneedTES=['TES0Up','TES0Down','TES1Up','TES1Down','TES10Up','TES10Down']
                 sysneedMFT=['MFTUp','MFTDown']
                 sysneedPileup=['PileupUp','PileupDown']
                 sysneedFAKES=['FakeshapeDM0_1_EBUp','FakeshapeDM0_1_EBDown','FakeshapeDM0_2_EBUp','FakeshapeDM0_2_EBDown','FakeshapeDM1_1_EBUp','FakeshapeDM1_1_EBDown','FakeshapeDM1_2_EBUp','FakeshapeDM1_2_EBDown','FakeshapeDM10_1_EBUp','FakeshapeDM10_1_EBDown','FakeshapeDM10_2_EBUp','FakeshapeDM10_2_EBDown','FakeshapeDM0_1_EEUp','FakeshapeDM0_1_EEDown','FakeshapeDM0_2_EEUp','FakeshapeDM0_2_EEDown','FakeshapeDM1_1_EEUp','FakeshapeDM1_1_EEDown','FakeshapeDM1_2_EEUp','FakeshapeDM1_2_EEDown','FakeshapeDM10_1_EEUp','FakeshapeDM10_1_EEDown','FakeshapeDM10_2_EEUp','FakeshapeDM10_2_EEDown']
                 basechannels_Fake=['ggNotIso','ggNotIsoM','ggNotIsoMT','boostNotIso','boostNotIsoM','boostNotIsoMT','vbf_ggNotIso','vbf_ggNotIsoM','vbf_ggNotIsoMT','vbf_vbfNotIso','vbf_vbfNotIsoM','vbf_vbfNotIsoMT']
                 basechannelsI=[(0,'gg'),(1,'boost'),(2,'vbf_gg'),(2,'vbf_vbf')]
                 basechannelsII=[(0,'ggNotIso'),(1,'boostNotIso'),(2,'vbf_ggNotIso'),(2,'vbf_vbfNotIso')]
                 basechannelsIII=[(0,'ggNotIsoM'),(1,'boostNotIsoM'),(2,'vbf_ggNotIsoM'),(2,'vbf_vbfNotIsoM')]
                 basechannelsIIII=[(0,'ggNotIsoMT'),(1,'boostNotIsoMT'),(2,'vbf_ggNotIsoMT'),(2,'vbf_vbfNotIsoMT')]
                 baseJESsys=["_CMS_JetEnUp","_CMS_JetEnDown","_CMS_JetAbsoluteFlavMapDown","_CMS_JetAbsoluteFlavMapUp","_CMS_JetAbsoluteMPFBiasDown","_CMS_JetAbsoluteMPFBiasUp","_CMS_JetAbsoluteScaleDown","_CMS_JetAbsoluteScaleUp","_CMS_JetAbsoluteStatDown","_CMS_JetAbsoluteStatUp","_CMS_JetFlavorQCDDown","_CMS_JetFlavorQCDUp","_CMS_JetFragmentationDown","_CMS_JetFragmentationUp","_CMS_JetPileUpDataMCDown","_CMS_JetPileUpDataMCUp","_CMS_JetPileUpPtBBDown","_CMS_JetPileUpPtBBUp","_CMS_JetPileUpPtEC1Down","_CMS_JetPileUpPtEC1Up","_CMS_JetPileUpPtEC2Down","_CMS_JetPileUpPtEC2Up","_CMS_JetPileUpPtHFDown","_CMS_JetPileUpPtHFUp","_CMS_JetPileUpPtRefDown","_CMS_JetPileUpPtRefUp","_CMS_JetRelativeBalDown","_CMS_JetRelativeBalUp","_CMS_JetRelativeFSRDown","_CMS_JetRelativeFSRUp","_CMS_JetRelativeJEREC1Down","_CMS_JetRelativeJEREC1Up","_CMS_JetRelativeJEREC2Down","_CMS_JetRelativeJEREC2Up","_CMS_JetRelativeJERHFDown","_CMS_JetRelativeJERHFUp","_CMS_JetRelativePtBBDown","_CMS_JetRelativePtBBUp","_CMS_JetRelativePtEC1Down","_CMS_JetRelativePtEC1Up","_CMS_JetRelativePtEC2Down","_CMS_JetRelativePtEC2Up","_CMS_JetRelativePtHFDown","_CMS_JetRelativePtHFUp","_CMS_JetRelativeStatECDown","_CMS_JetRelativeStatECUp","_CMS_JetRelativeStatFSRDown","_CMS_JetRelativeStatFSRUp","_CMS_JetRelativeStatHFDown","_CMS_JetRelativeStatHFUp","_CMS_JetSinglePionECALDown","_CMS_JetSinglePionECALUp","_CMS_JetSinglePionHCALDown","_CMS_JetSinglePionHCALUp","_CMS_JetTimePtEtaDown","_CMS_JetTimePtEtaUp"]
                 baseUESsp=['_CMS_CHARGEDUESUp','_CMS_CHARGEDUESDown','_CMS_ECALUESUp','_CMS_ECALUESDown','_CMS_HCALUESUp','_CMS_HCALUESDown','_CMS_HFUESUp','_CMS_HFUESDown']


                 DMinstring=str(int(round(row.tDecayMode))) 
                 for M in sysneedFAKES:
                     self.SetsysZero(row)
                     tmpname='self.DoFakeshapeDM'
                     if 'Up' in M and (M.split('FakeshapeDM',1)[1]).split('_',1)[0]==DMinstring:
                        if ('EB' in M) and (abs(row.tEta)<1.479):
                           valuehere='2017'+DMinstring+(M.split('FakeshapeDM',1)[1]).split('_',2)[1]+'1'+'1'
                           exec("%s = %d" % (tmpname,int(valuehere)))                   
                        elif 'EE' in M and (abs(row.tEta)>1.479):
                           valuehere='2017'+DMinstring+(M.split('FakeshapeDM',1)[1]).split('_',2)[1]+'1'+'2'
                           exec("%s = %d" % (tmpname,int(valuehere)))       
                        else:
                           exec("%s = %d" % (tmpname,20170000))            
                        #exec("%s = %d" % ((tmpname,(M.split('Up',1)[0]).split('TES',1)[1]))                   
                     elif 'Down' in M and (M.split('FakeshapeDM',1)[1]).split('_',1)[0]==DMinstring:
                        if 'EB' in M and (abs(row.tEta)<1.479):
                           valuehere='2017'+DMinstring+(M.split('FakeshapeDM',1)[1]).split('_',2)[1]+'2'+'1'
                           exec("%s = %d" % (tmpname,int(valuehere)))                   
                        elif 'EE' in M and (abs(row.tEta)>1.479):
                           valuehere='2017'+DMinstring+(M.split('FakeshapeDM',1)[1]).split('_',2)[1]+'2'+'2'
                           exec("%s = %d" % (tmpname,int(valuehere)))                  
                        else:
                           exec("%s = %d" % (tmpname,20170000)) 
                     else:
                        exec("%s = %d" % (tmpname,20170000))                   
                     if (not self.obj2_iso(row)) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                        for j in basechannelsII: 
                           if row.jetVeto30==j[0]:
                               if j[0]==2:
                                  tmpname_2=j[1].split('Not',1)[0]
                                  if tmpname_2=='vbf_gg':
                                     if row.vbfMass < 550:
                                       self.fill_histos(row,j[1]+M,True)
                                  elif tmpname_2=='vbf_vbf':
                                     if row.vbfMass >= 550:
                                       self.fill_histos(row,j[1]+M,True)
                                  else:
                                       print 'dbug wrong!!!!!!!!!!!!!!!!!!!!!!!'
                               else:
                                    self.fill_histos(row,j[1]+M,True)
                       #             print 'at line 1892 the name of the folder %s' %tmpname_2
                     if self.obj2_iso(row) and self.oppositesign(row) and (not self.obj1_iso(row)) and self.kinematics(row): 
                        for j in basechannelsIII: 
                           if row.jetVeto30==j[0]:
                               if j[0]==2:
                                  tmpname_2=j[1].split('Not',1)[0]
                                  if tmpname_2=='vbf_gg':
                                     if row.vbfMass < 550:
                                        self.fill_histos(row,j[1]+M,True,faketype="muonfake")
                                  elif tmpname_2=='vbf_vbf':
                                     if row.vbfMass >= 550:
                                        self.fill_histos(row,j[1]+M,True,faketype="muonfake")
                                  else:
                                       print 'dbug wrong!!!!!!!!!!!!!!!!!!!!!!!'
                               else:
                                        self.fill_histos(row,j[1]+M,True,faketype="muonfake")
                     if (not self.obj2_iso(row)) and self.oppositesign(row) and (not self.obj1_iso(row)) and self.kinematics(row): 
                        for j in basechannelsIIII: 
                           if row.jetVeto30==j[0]:
                               if j[0]==2:
                                  tmpname_2=j[1].split('Not',1)[0]
                                  if tmpname_2=='vbf_gg':
                                     if row.vbfMass < 550:
                                        self.fill_histos(row,j[1]+M,True,faketype="mtfake")
                                  elif tmpname_2=='vbf_vbf':
                                     if row.vbfMass >= 550:
                                        self.fill_histos(row,j[1]+M,True,faketype="mtfake")
                                  else:
                                       print 'dbug wrong!!!!!!!!!!!!!!!!!!!!!!!'
                               else:
                                        self.fill_histos(row,j[1]+M,True,faketype="mtfake")
            if self.Sysin and not self.is_data:


                 for i in sysneedPileup:
                     self.SetsysZero(row)
                     tmpname='self.DoPileup'
                     if 'Up' in i:
                        exec("%s = %d" % (tmpname,1))                      
                     if 'Down' in i:
                        exec("%s = %d" % (tmpname,2))                  
                     if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                        for j in basechannelsI: 
                           if row.jetVeto30==j[0]:
                               if j[0]==2:
                                  tmpname_2=j[1].split('Not',1)[0]
                                  if tmpname_2=='vbf_gg':
                                     if row.vbfMass < 550:
                                        self.fill_histos(row,j[1]+i,False)
                                  elif tmpname_2=='vbf_vbf':
                                     if row.vbfMass >= 550:
                                        self.fill_histos(row,j[1]+i,False)
                                  else:
                                       print 'dbug wrong!!!!!!!!!!!!!!!!!!!!!!!'
                               else:
                                        self.fill_histos(row,j[1]+i,False)
                                        #print "the name %s"  %j[1]+i

                 for i in sysneedI:
                     self.SetsysZero(row)
                     if 'Up' in i:
                        tmpname='self.Do'+i.split('Up',1)[0]
                      #  print "the current tmpname %s" %tmpname
                        exec("%s = %d" % (tmpname,1))                      
                     if 'Down' in i:
                        tmpname='self.Do'+i.split('Down',1)[0]
                      #  print "the current tmpname %s" %tmpname
                        exec("%s = %d" % (tmpname,2))                  
                  #   print "the tmpname value %f and the frist one is actually MESup self.DoMES" %(tmpname,self.DoMES) 
                     #self.TauESC(row)
#                     if self.DoMES==1:
#                         print "the no shift BDT %f and the %s   %f" %(self.MVA0fill,i,self.MVA0fill_new)
                     if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                        self.MVA0fill_new,self.collMass_type1_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new,self.MorTPtshifted=self.VariableCalculate(row,self.tau_Pt_C,self.MET_tPtC) 
                        for j in basechannelsI: 
                           if row.jetVeto30==j[0]:
                               if j[0]==2:
                                  tmpname_2=j[1].split('Not',1)[0]
                                  if tmpname_2=='vbf_gg':
                                     if row.vbfMass < 550:
                                        self.fill_histos(row,j[1]+i,False)
                                  elif tmpname_2=='vbf_vbf':
                                     if row.vbfMass >= 550:
                                        self.fill_histos(row,j[1]+i,False)
                                  else:
                                       print 'dbug wrong!!!!!!!!!!!!!!!!!!!!!!!'
                               else:
                                        self.fill_histos(row,j[1]+i,False)
#                 print "start to enter JES******"    
                 for k in baseJESsys:
                     self.SetsysZero(row)
                     #self.VariableCalculateJES(row)
                     if 'Up' in k:
                        tmpname='self.DoJES'
                        exec("%s = %d" % (tmpname,1))                      
                     if 'Down' in k:
                        tmpname='self.DoJES'
                        exec("%s = %d" % (tmpname,2))                   
                     tmpname_3='row.jetVeto30_'+k.split('_CMS_',1)[1]
                     tmpname_5='row.type1_pfMet_shiftedPt_'+k.split('_CMS_',1)[1] 
                     tmpname_6='row.type1_pfMet_shiftedPhi_'+k.split('_CMS_',1)[1] 
                     #print eval(tmpname_6)
                     #print row.type1_pfMet_shiftedPhi_JetEnUp
                    # if k=='_CMS_JetPileUpPtEC1Down':
                    #    print "the no shift BDT %f and the %s   %f" %(self.MVA0fill,k,self.MVA0fill_new)
                     if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                        self.MVA0fill_new,self.collMass_type1_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new=self.VariableCalculateJES_UESsp(row,eval(tmpname_5),eval(tmpname_6),self.tau_Pt_C)
                        for j in basechannelsI: 
                           if  eval(tmpname_3)==j[0]:
                           #    tmpname_2='self.'+j[1]+'(row)'
                               if ('vbf_gg' in j[1]):
                                   tmpname_4='row.vbfMass_'+k.split('_CMS_',1)[1]
                                   #if eval(tmpname_2) and eval(tmpname_4)<550:
                                   if eval(tmpname_4)<550:
                                      self.fill_histos(row,j[1]+k,False)
                               elif ('vbf_vbf' in j[1]):
                                   tmpname_4='row.vbfMass_'+k.split('_CMS_',1)[1]
                                   #if eval(tmpname_2) and eval(tmpname_4)>=550:
                                   if eval(tmpname_4)>=550:
                                      self.fill_histos(row,j[1]+k,False)
                               else:
                                  # if  eval(tmpname_2):
                                       self.fill_histos(row,j[1]+k,False)
                 for k in baseUESsp:
                     self.SetsysZero(row)
                     if 'Up' in k:
                        tmpname='self.DoUESsp'
                        exec("%s = %d" % (tmpname,1))
                     if 'Down' in k:
                        tmpname='self.DoUESsp'
                        exec("%s = %d" % (tmpname,2))
#                     tmpname_3='row.jetVeto30_'+k.split('_CMS_',1)[1]
                     tmpname_5='row.type1_pfMet_shiftedPt_'+k.split('_CMS_',1)[1]
                     tmpname_6='row.type1_pfMet_shiftedPhi_'+k.split('_CMS_',1)[1]
                     #print eval(tmpname_6)
                     #print row.type1_pfMet_shiftedPhi_JetEnUp
#                     if k=='_CMS_JetPileUpPtEC1Down':
#                        print "mass collin %s  %f" %(k,self.collMass_type1_new)
                     if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row):
                        self.MVA0fill_new,self.collMass_type1_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new=self.VariableCalculateJES_UESsp(row,eval(tmpname_5),eval(tmpname_6),self.tau_Pt_C)
                        for j in basechannelsI: 
                           if row.jetVeto30==j[0]:
                               if j[0]==2:
                                  tmpname_2=j[1].split('Not',1)[0]
                                  if tmpname_2=='vbf_gg':
                                     if row.vbfMass < 550:
                                        self.fill_histos(row,j[1]+k,False)
                                  elif tmpname_2=='vbf_vbf':
                                     if row.vbfMass >= 550:
                                        self.fill_histos(row,j[1]+k,False)
                                  else:
                                       print 'dbug wrong!!!!!!!!!!!!!!!!!!!!!!!'
                               else:
                                        self.fill_histos(row,j[1]+k,False)

                 if not self.ls_DY:
                    for L in sysneedTES:
                        self.SetsysZero(row)
                        tmpname='self.DoTES'
                        if row.tZTTGenMatching==5:
                           if 'Up' in L and (L.split('Up',1)[0]).split('TES',1)[1]==DMinstring:
                              exec("%s = %d" % (tmpname,1))                   
                            #  cheksiski=True
                              #exec("%s = %d" % ((tmpname,(M.split('Up',1)[0]).split('TES',1)[1]))                   
                           elif 'Down' in L and (L.split('Down',1)[0]).split('TES',1)[1]==DMinstring:
                              exec("%s = %d" % (tmpname,2))                  
                           else:
                              exec("%s = %d" % (tmpname,3)) 
                            #  cheksiski=True
                        else:
                         #  cheksiski=False
                           exec("%s = %d" % (tmpname,3))                   
                        if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
#                           print 'comes here'
#                           print "the problem TES %f"  %self.DoTES
                           self.MVA0fill_new,self.collMass_type1_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new,self.MorTPtshifted=self.VariableCalculate(row,self.tau_Pt_C,self.MET_tPtC)
#                           print 'comes here222'
                           for j in basechannelsI: 
                              if row.jetVeto30==j[0]:
                                  if j[0]==2:
                                     tmpname_2=j[1].split('Not',1)[0]
                                     if tmpname_2=='vbf_gg':
                                        if row.vbfMass < 550:
                                           self.fill_histos(row,j[1]+L,False)
                                     elif tmpname_2=='vbf_vbf':
                                        if row.vbfMass >= 550:
                                           self.fill_histos(row,j[1]+L,False)
                                     else:
                                          print 'dbug wrong!!!!!!!!!!!!!!!!!!!!!!!'
                                  else:
                                           self.fill_histos(row,j[1]+L,False)
                 if self.ls_DY:
                    for L in sysneedMFT:
                        self.SetsysZero(row)
                        tmpname='self.DoMFT'
                        if row.isZmumu  and row.tZTTGenMatching<5 and row.tDecayMode==1:
                           if 'Up' in L:
                              exec("%s = %d" % (tmpname,1))
                            #  cheksiski=True
                              #exec("%s = %d" % ((tmpname,(M.split('Up',1)[0]).split('TES',1)[1]))                   
                           elif 'Down' in L:
                              exec("%s = %d" % (tmpname,2))
                            #  cheksiski=True
                        else:
                         #  cheksiski=False
                           exec("%s = %d" % (tmpname,3))
                        if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row):
                           self.MVA0fill_new,self.collMass_type1_new,self.tMtToPfMet_type1_new,self.mMtToPfMet_type1_new,self.MorTPtshifted=self.VariableCalculate(row,self.tau_Pt_C,self.MET_tPtC)
                           for j in basechannelsI: 
                              if row.jetVeto30==j[0]:
                                  if j[0]==2:
                                     tmpname_2=j[1].split('Not',1)[0]
                                     if tmpname_2=='vbf_gg':
                                        if row.vbfMass < 550:
                                           self.fill_histos(row,j[1]+L,False)
                                     elif tmpname_2=='vbf_vbf':
                                        if row.vbfMass >= 550:
                                           self.fill_histos(row,j[1]+L,False)
                                     else:
                                          print 'dbug wrong!!!!!!!!!!!!!!!!!!!!!!!'
                                  else:
                                           self.fill_histos(row,j[1]+L,False)
            self.SetsysZero(row)
            sel=True

    def finish(self):
        self.write_histos()
