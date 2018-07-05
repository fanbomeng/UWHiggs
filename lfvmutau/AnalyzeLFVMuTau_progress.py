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
MetCorrection=True
#MetCorrection=False
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
#def collMass_type1(row,sys='none'):
#        taupx=row.tPt*math.cos(row.tPhi)
#        taupy=row.tPt*math.sin(row.tPhi)
#	metE = row.type1_pfMetEt
#	metPhi = row.type1_pfMetPhi
#        metpx = metE*math.cos(metPhi)
#        metpy = metE*math.sin(metPhi)
#        met = sqrt(metpx*metpx+metpy*metpy)
#
#        METproj= abs(metpx*taupx+metpy*taupy)/row.tPt
#
#        xth=row.tPt/(row.tPt+METproj)
#        den=math.sqrt(xth)
#
#        mass=row.m_t_Mass/den
#
#        #print '%4.2f, %4.2f, %4.2f, %4.2f, %4.2f' %(scaleMass(row), den, xth, METproj,mass)


#        return mass



#def getGenMfakeTSF(ABStEta):
#    if (ABStEta>0 and ABStEta<0.4):
#       return 1.470
#    if (ABStEta>0.4 and ABStEta<0.8):
#       return 1.367
#    if (ABStEta>0.8 and ABStEta<1.2):
#       return 1.251
#    if (ABStEta>1.2 and ABStEta<1.7):
#       return 1.770
#    if (ABStEta>1.7 and ABStEta<2.3):
#       return 1.713
#
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
#def getFakeRateFactorFANBOPt(row, fakeset):
#     if fakeset=="def":
#        if  row.tDecayMode==0:
#            fTauIso=0.21753
#        if  row.tDecayMode==1:
#            fTauIso=0.21068
#        if  row.tDecayMode==10:
#            fTauIso=0.18071
#     if fakeset=="1stUp":
#        if  row.tDecayMode==0:
#            fTauIso=0.21753+0.00921
#        if  row.tDecayMode==1:
#            fTauIso=0.21068+0.00515
#        if  row.tDecayMode==10:
#            fTauIso=0.18071+0.00549
#     if fakeset=="1stDown":
#        if  row.tDecayMode==0:
#            fTauIso=0.21753-0.00921
#        if  row.tDecayMode==1:
#            fTauIso=0.21068-0.00515
#        if  row.tDecayMode==10:
#            fTauIso=0.18071-0.00549
#     fakeRateFactor = fTauIso/(1.0-fTauIso)
#     return fakeRateFactor
#

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
     fTauIso= 0.2089 - 0.00113*(self.tau_Pt_C-30)
  if fakeset=="1stUp":
     fTauIso= 0.212105 - 0.00111905*(self.tau_Pt_C-30)
  if fakeset=="1stDown":
     fTauIso= 0.205715  - 0.00113831*(self.tau_Pt_C-30)
  if fakeset=="2ndUp":
     fTauIso= 0.20891  - 0.00088892*(self.tau_Pt_C-30)
  if fakeset=="2ndDown":
     fTauIso= 0.208909  - 0.00136844*(self.tau_Pt_C-30)
  fakeRateFactor = fTauIso/(1.0-fTauIso)
  return fakeRateFactor
################################################################################
#### MC-DATA and PU corrections ################################################
################################################################################
pu_distributions = glob.glob(os.path.join(
        'inputs', os.environ['jobid'], 'data_SingleMu*pu.root'))
#pu_corrector = PileupWeight.PileupWeight('MC_Spring16', *pu_distributions)
pu_corrector = PileupWeight.PileupWeight('MC_Moriond17', *pu_distributions)

#muon_HTauTau_TriggerIso22_2016B= MuonPOGCorrections.make_muon_HTauTau_TriggerIso22_2016B()
muon_pog_TriggerIso24_2016B= MuonPOGCorrections.make_muon_pog_IsoMu24oIsoTkMu24_2016ReReco()
muon_pog_PFTight_2016B = MuonPOGCorrections.make_muon_pog_PFMedium_2016ReReco()
#muon_pog_PFTight_2016B = MuonPOGCorrections.make_muon_pog_PFMedium_2016BCD()
#muon_pog_Tracking_2016B = MuonPOGCorrections.make_muon_pog_Tracking_2016BCD()
#muon_pog_Tracking_2016B = MuonPOGCorrections.mu_trackingEta_2016()
muon_pog_TightIso_2016B = MuonPOGCorrections.make_muon_pog_TightIso_2016ReReco('Medium')


class AnalyzeLFVMuTau_progress(MegaBase):
    tree = 'mt/final/Ntuple'
    #tree = 'New_Tree'

    def __init__(self, tree, outfile, **kwargs):
        super(AnalyzeLFVMuTau_progress, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        target = os.path.basename(os.environ['megatarget'])
        self.target1 = os.path.basename(os.environ['megatarget'])
        self.ls_recoilC=((('HTo' in target) or ('Jets' in target)) and MetCorrection) 
        if self.ls_recoilC and MetCorrection:
           self.Metcorected=RecoilCorrector("TypeI-PFMet_Run2016BtoH.root")
        
#        print "the target is ***********    %s"    %target
#        WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
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
        self.light=1
        self.DoMES=0
        self.DoTES=0
        self.DoUES=0
        self.DoJES=0
        self.MVA0fill_new=-100
        self.MVA0fill=-100
        self.tau_Pt_C=0.01
        self.tMtToPfMet_type1_new=0
        self.MET_tPtC=0
        self.collMass_type1_new=-10
        self.tmpHula=(-10,-10,-10,-10,-10,-10)
        self.tmpHulaJES=(0,-10)
#        if self.ls_DY or self.ls_ZTauTau:
#           self.Z_reweight = ROOT.TFile.Open('zpt_weights_2016.root')
#           self.Z_reweight_H=self.Z_reweight.Get('zptmass_histo')
    def begin(self):

        if not self.light :
           
           names=["preselection","notIso","notIsoM","notIsoMT","preselectionSS","notIsoSS","notIsoSSM","notIsoSSMT","notIsoSS0Jet","notIsoSS0JetM","notIsoSS0JetMT","notIsoSS1Jet","notIsoSS1JetM","notIsoSS1JetMT","notIsoSS2Jet","notIsoSS2JetM","notIsoSS2JetMT","notIsoSS2Jet_gg","notIsoSS2Jet_ggM","notIsoSS2Jet_ggMT","notIsoSS2Jet_vbf","notIsoSS2Jet_vbfM","notIsoSS2Jet_vbfMT","preslectionEnWjets","notIsoEnWjets","notIsoEnWjetsM","notIsoEnWjetsMT","preslectionEnWjets0Jet","notIsoEnWjets0Jet","notIsoEnWjets0JetM","notIsoEnWjets0JetMT","preslectionEnWjets1Jet","notIsoEnWjets1Jet","notIsoEnWjets1JetM","notIsoEnWjets1JetMT","preslectionEnWjets2Jet","notIsoEnWjets2Jet","notIsoEnWjets2JetM","notIsoEnWjets2JetMT","preslectionEnWjets2Jet_gg","notIsoEnWjets2Jet_gg","notIsoEnWjets2Jet_ggM","notIsoEnWjets2Jet_ggMT","preslectionEnWjets2Jet_vbf","notIsoEnWjets2Jet_vbf","notIsoEnWjets2Jet_vbfM","notIsoEnWjets2Jet_vbfMT","preslectionSSEnWjets","notIsoEnWjetsSS","gg","boost","vbf","ggNotIso","ggNotIsoM","ggNotIsoMT","boostNotIso","boostNotIsoM","boostNotIsoMT","ggNotIso1stUp","ggNotIso1stDown","boostNotIso1stUp","boostNotIso1stDown","ggNotIsoM1stUp","ggNotIsoM1stDown","boostNotIsoM1stUp","boostNotIsoM1stDown","ggNotIsoMT1stUp","ggNotIsoMT1stDown","boostNotIsoMT1stUp","boostNotIsoMT1stDown","vbfNotIso","vbfNotIsoM","vbfNotIsoMT","preselection0Jet", "preselection1Jet", "preselection2Jet",'preselection2Jet_gg','preselection2Jet_vbf',"notIso0Jet","notIso0JetM","notIso0JetMT","notIso1Jet","notIso1JetM","notIso1JetMT","notIso2Jet","notIso2JetM","notIso2JetMT","notIso2Jet_gg","notIso2Jet_ggM","notIso2Jet_ggMT","notIso2Jet_vbf","notIso2Jet_vbfM","notIso2Jet_vbfMT","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_ggNotIsoM","vbf_ggNotIsoMT","vbf_vbfNotIso","vbf_vbfNotIsoM","vbf_vbfNotIsoMT","vbf_ggNotIso1stUp","vbf_ggNotIso1stDown","vbf_vbfNotIso1stUp","vbf_vbfNotIso1stDown","vbf_ggNotIsoM1stUp","vbf_ggNotIsoM1stDown","vbf_vbfNotIsoM1stUp","vbf_vbfNotIsoM1stDown","vbf_ggNotIsoMT1stUp","vbf_ggNotIsoMT1stDown","vbf_vbfNotIsoMT1stUp","vbf_vbfNotIsoMT1stDown","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet",'IsoSS2Jet_gg','IsoSS2Jet_vbf',"ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
        else:
           names=["preselectionSS","notIsoSS","notIsoSSM","notIsoSSMT","gg","boost","ggNotIso","ggNotIsoM","ggNotIsoMT","boostNotIso","boostNotIsoM","boostNotIsoMT","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_ggNotIsoM","vbf_ggNotIsoMT","vbf_vbfNotIso","vbf_vbfNotIsoM","vbf_vbfNotIsoMT"]
       # if (not fakeset) and (not wjets_fakes) :
       #    names=["gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
        if self.Sysin and (not self.is_data):
       #    name=[]
           sysneed=['MESUp','MESDown','TESUp','TESDown','UESUp','UESDown']
           basechannels=['gg','boost','vbf_gg','vbf_vbf','ggNotIso','ggNotIsoM','ggNotIsoMT','boostNotIso','boostNotIsoM','boostNotIsoMT','vbf_ggNotIso','vbf_ggNotIsoM','vbf_ggNotIsoMT','vbf_vbfNotIso','vbf_vbfNotIsoM','vbf_vbfNotIsoMT']
           for i in sysneed:
               for j in basechannels:
                   names.append(j+i)                    
           JESsys=["_CMS_JetEnUp","_CMS_JetEnDown","_CMS_JetAbsoluteFlavMapDown","_CMS_JetAbsoluteFlavMapUp","_CMS_JetAbsoluteMPFBiasDown","_CMS_JetAbsoluteMPFBiasUp","_CMS_JetAbsoluteScaleDown","_CMS_JetAbsoluteScaleUp","_CMS_JetAbsoluteStatDown","_CMS_JetAbsoluteStatUp","_CMS_JetFlavorQCDDown","_CMS_JetFlavorQCDUp","_CMS_JetFragmentationDown","_CMS_JetFragmentationUp","_CMS_JetPileUpDataMCDown","_CMS_JetPileUpDataMCUp","_CMS_JetPileUpPtBBDown","_CMS_JetPileUpPtBBUp","_CMS_JetPileUpPtEC1Down","_CMS_JetPileUpPtEC1Up","_CMS_JetPileUpPtEC2Down","_CMS_JetPileUpPtEC2Up","_CMS_JetPileUpPtHFDown","_CMS_JetPileUpPtHFUp","_CMS_JetPileUpPtRefDown","_CMS_JetPileUpPtRefUp","_CMS_JetRelativeBalDown","_CMS_JetRelativeBalUp","_CMS_JetRelativeFSRDown","_CMS_JetRelativeFSRUp","_CMS_JetRelativeJEREC1Down","_CMS_JetRelativeJEREC1Up","_CMS_JetRelativeJEREC2Down","_CMS_JetRelativeJEREC2Up","_CMS_JetRelativeJERHFDown","_CMS_JetRelativeJERHFUp","_CMS_JetRelativePtBBDown","_CMS_JetRelativePtBBUp","_CMS_JetRelativePtEC1Down","_CMS_JetRelativePtEC1Up","_CMS_JetRelativePtEC2Down","_CMS_JetRelativePtEC2Up","_CMS_JetRelativePtHFDown","_CMS_JetRelativePtHFUp","_CMS_JetRelativeStatECDown","_CMS_JetRelativeStatECUp","_CMS_JetRelativeStatFSRDown","_CMS_JetRelativeStatFSRUp","_CMS_JetRelativeStatHFDown","_CMS_JetRelativeStatHFUp","_CMS_JetSinglePionECALDown","_CMS_JetSinglePionECALUp","_CMS_JetSinglePionHCALDown","_CMS_JetSinglePionHCALUp","_CMS_JetTimePtEtaDown","_CMS_JetTimePtEtaUp"]
           for i in  JESsys:
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
            #self.book(names[x], "mMtToPfMet_type1", "Muon MT (PF Ty1)", 200, 0, 200)
            #self.book(names[x], "type1_pfMetEtNormal", "Type1 MET", 200, 0, 200)
            self.book(names[x],"collMass_type1","collMass_type1",300,0,300);
#            self.book(names[x],"fullMT_type1","fullMT_type1",500,0,500);
#            self.book(names[x], "genHTT", "genHTT", 1000 ,0,1000)
#            self.book(names[x], "singleIsoMu22Pass", "singleIsoMu22Pass", 12 ,-0.1,1.1)
#            self.book(names[x], "singleIsoTkMu22Pass", "singleIsoTkMu22Pass", 12 ,-0.1,1.1)
            #self.book(names[x], "rho", "Fastjet #rho", 100, 0, 25)
           # self.book(names[x], "nvtx", "Number of vertices", 100, -0.5, 100.5)
            #self.book(names[x], "prescale", "HLT prescale", 21, -0.5, 20.5)
            #self.book(names[x], "tJetPartonFlavour", "tJetPartonFlavour", 30,-7, 23)
            #self.book(names[x], "mJetPartonFlavour", "mJetPartonFlavour", 30,-7, 23)

   
#            self.book(names[x], "jet1Pt", "", 300,0,300)
#            self.book(names[x], "jet2Pt", "", 300,0,300)
#            self.book(names[x], "jet3Pt", "", 300,0,300)
#            self.book(names[x], "jet4Pt", "", 300,0,300)
#            self.book(names[x], "jet5Pt", "", 300,0,300)
#
#
#            self.book(names[x], "jet1Eta", "", 200,-5,5)
#            self.book(names[x], "jet2Eta", "", 200,-5,5)
#            self.book(names[x], "jet3Eta", "", 200,-5,5)
#            self.book(names[x], "jet4Eta", "", 200,-5,5)
#            self.book(names[x], "jet5Eta", "", 200,-5,5)
#
#            self.book(names[x], "jet1Phi", "", 280,-7,7)
#            self.book(names[x], "jet2Phi", "", 280,-7,7)
#            self.book(names[x], "jet3Phi", "", 280,-7,7)
#            self.book(names[x], "jet4Phi", "", 280,-7,7)
#            self.book(names[x], "jet5Phi", "", 280,-7,7)
# 
      #      self.book(names[x], "deltaR", "deltaR", 100,0,5)
#            self.book(names[x], "bjetCISVVeto30Loose", "bjetCISVVeto30Loose", 40,0,40)
#            self.book(names[x], "bjetCISVVeto30Medium", "bjetCISVVeto30Medium", 40,0,40)
#            self.book(names[x], "bjetCISVVeto30Tight", "bjetCISVVeto30Tight", 40,0,40)
#            self.book(names[x], "mPtavColMass", "Muon  Pt av Mass", 150,0,1.5)
            if not self.light: 
                  self.book(names[x], "weight", "Event weight", 100, 0, 5)
                  self.book(names[x], "counts", "Event counts", 10, 0, 5)
                  self.book(names[x], "GenWeight", "Gen level weight", 200000 ,-1000000, 1000000)
                  self.book(names[x], "nvtx", "Number of vertices", 20, -0.5, 100.5)
                  self.book(names[x], "mEta", "Muon  eta", 100, -2.5, 2.5)
                  self.book(names[x], "tEta", "Tau  eta", 100, -2.5, 2.5)
                  self.book(names[x], "tPhi", "tPhi", 100 ,-3.4,3.4)
                  self.book(names[x], "tDPhiToPfMet_type1", "tDPhiToPfMet_type1", 100, 0, 4)
                  self.book(names[x], "m_t_Mass", "Muon + Tau Mass", 200, 0, 200)
                  self.book(names[x], "type1_pfMetEt", "Type1 MET", 200, 0, 200)
            #      self.book(names[x], "m_t_Pt", "Muon + Tau Pt", 200, 0, 200)
                  self.book(names[x], "m_t_DR", "Muon + Tau DR", 100, 0, 10)
                  self.book(names[x], "m_t_DEta", "Muon + Tau DEta", 100, 0,4)
                  self.book(names[x], "m_t_DPhi", "Muon + Tau DPhi", 100, 0, 4)
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

		       
            #self.book(names[x], "tAgainstElectronLoose", "tAgainstElectronLoose", 2,-0.5,1.5)
##            self.book(names[x], "tAgainstElectronLooseMVA5", "tAgainstElectronLooseMVA5", 2,-0.5,1.5) #same for other tAgainstE
#            self.book(names[x], "tAgainstElectronLooseMVA6", "tAgainstElectronLooseMVA6", 2,-0.5,1.5)
#            #self.book(names[x], "tAgainstElectronMedium", "tAgainstElectronMedium", 2,-0.5,1.5)
#            self.book(names[x], "tAgainstElectronMediumMVA6", "tAgainstElectronMediumMVA6", 2,-0.5,1.5)
#            #self.book(names[x], "tAgainstElectronTight", "tAgainstElectronTight", 2,-0.5,1.5)
#            self.book(names[x], "tAgainstElectronTightMVA6", "tAgainstElectronTightMVA6", 2,-0.5,1.5)
#            self.book(names[x], "tAgainstElectronVTightMVA6", "tAgainstElectronVTightMVA6", 2,-0.5,1.5)
#
#
#            #self.book(names[x], "tAgainstMuonLoose", "tAgainstMuonLoose", 2,-0.5,1.5)
#            self.book(names[x], "tAgainstMuonLoose3", "tAgainstMuonLoose3", 2,-0.5,1.5)
#            #self.book(names[x], "tAgainstMuonMedium", "tAgainstMuonMedium", 2,-0.5,1.5)
#            #self.book(names[x], "tAgainstMuonTight", "tAgainstMuonTight", 2,-0.5,1.5)
#            self.book(names[x], "tAgainstMuonTight3", "tAgainstMuonTight3", 2,-0.5,1.5)

            #self.book(names[x], "tAgainstMuonLooseMVA", "tAgainstMuonLooseMVA", 2,-0.5,1.5)
            #self.book(names[x], "tAgainstMuonMediumMVA", "tAgainstMuonMediumMVA", 2,-0.5,1.5)
            #self.book(names[x], "tAgainstMuonTightMVA", "tAgainstMuonTightMVA", 2,-0.5,1.5)

        #    self.book(names[x], "tDecayModeFinding", "tDecayModeFinding", 2,-0.5,1.5)
        #    self.book(names[x], "tDecayModeFindingNewDMs", "tDecayModeFindingNewDMs", 2,-0.5,1.5)
        #    self.book(names[x], "tDecayMode", "tDecayMode", 21,-0.5,20.5)


#            self.book(names[x], "tByLooseCombinedIsolationDeltaBetaCorr3Hits", "tByLooseCombinedIsolationDeltaBetaCorr3Hits", 2,-0.5,1.5)
#            self.book(names[x], "tByMediumCombinedIsolationDeltaBetaCorr3Hits", "tByMediumCombinedIsolationDeltaBetaCorr3Hits", 2,-0.5,1.5)
#            self.book(names[x], "tByTightCombinedIsolationDeltaBetaCorr3Hits", "tByTightCombinedIsolationDeltaBetaCorr3Hits", 2,-0.5,1.5)
#
#            self.book(names[x], "tByLooseIsolationMVArun2v1DBnewDMwLT", "tByLooseIsolationMVArun2v1DBnewDMwLT", 2,-0.5,1.5)
#            self.book(names[x], "tByMediumIsolationMVArun2v1DBnewDMwLT", "tByMediumIsolationMVArun2v1DBnewDMwLT", 2,-0.5,1.5)
#            self.book(names[x], "tByTightIsolationMVArun2v1DBnewDMwLT", "tByTightIsolationMVArun2v1DBnewDMwLT", 2,-0.5,1.5)
#            self.book(names[x], "tByVTightIsolationMVArun2v1DBnewDMwLT", "tByVTightIsolationMVArun2v1DBnewDMwLT", 2,-0.5,1.5)
#            self.book(names[x], "tByVVTightIsolationMVArun2v1DBnewDMwLT", "tByVVTightIsolationMVArun2v1DBnewDMwLT", 2,-0.5,1.5)
#
#            self.book(names[x], "tByLooseIsolationMVArun2v1DBoldDMwLT", "tByLooseIsolationMVArun2v1DBoldDMwLT", 2,-0.5,1.5)
#            self.book(names[x], "tByMediumIsolationMVArun2v1DBoldDMwLT", "tByMediumIsolationMVArun2v1DBoldDMwLT", 2,-0.5,1.5)
#            self.book(names[x], "tByTightIsolationMVArun2v1DBoldDMwLT", "tByTightIsolationMVArun2v1DBoldDMwLT", 2,-0.5,1.5)
#            self.book(names[x], "tByVTightIsolationMVArun2v1DBoldDMwLT", "tByVTightIsolationMVArun2v1DBoldDMwLT", 2,-0.5,1.5)
#            self.book(names[x], "tByVVTightIsolationMVArun2v1DBoldDMwLT", "tByVVTightIsolationMVArun2v1DBoldDMwLT", 2,-0.5,1.5)

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
#    def TauESC(self,row):
#        if  row.tDecayMode==0:
#            self.tau_Pt_C=0.982*row.tPt
#            self.MET_tPtC=row.type1_pfMetEt+0.018*row.tPt
#        if  row.tDecayMode==1:
#            self.tau_Pt_C=1.01*row.tPt
#            self.MET_tPtC=row.type1_pfMetEt-0.01*row.tPt
#        if  row.tDecayMode==10:
#            self.tau_Pt_C=1.004*row.tPt
#            self.MET_tPtC=row.type1_pfMetEt-0.004*row.tPt
    def mc_corrector_2016(self,row):
      pu = pu_corrector(row.nTruePU)
      m1tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.mEta))[0]
      #print "the m1tracking %f"   %m1tracking
#      print "Sysin value in the correction %f" %self.Sysin
      if (not self.Sysin) or (self.DoTES) or self.DoUES or self.DoJES:
         m1id =muon_pog_PFTight_2016B(row.mPt,abs(row.mEta))
         m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt,abs(row.mEta))
       
         m1iso =muon_pog_TightIso_2016B(row.mPt,abs(row.mEta))
      if self.Sysin and self.DoMES==1:
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
      if self.Sysin and self.DoMES==2:
        # print "at the same time what is the MES=2 enters?"
            m1id =muon_pog_PFTight_2016B(row.mPt*0.998,abs(row.mEta))
            m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt*0.998,abs(row.mEta))
            m1iso =muon_pog_TightIso_2016B(row.mPt*0.998,abs(row.mEta))
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
         #if fakeset=="def":
         #   if  row.tDecayMode==0:
         #       fTauIso=0.22362
         #   if  row.tDecayMode==1:
         #       fTauIso=0.218989
         #   if  row.tDecayMode==10:
         #       fTauIso=0.186646
         if fakeset=="def":
            if  row.tDecayMode==0:
                fTauIso=0.240806-0.000836112*(self.tau_Pt_C-30)
            elif  row.tDecayMode==1:
                fTauIso=0.235014-0.000837926*(self.tau_Pt_C-30)
            elif  row.tDecayMode==10:
                fTauIso=0.185752-0.000457377*(self.tau_Pt_C-30)
            else:
                print "rare decay mode %f" %row.tDecayMode
                fTauIso=0
         if self.DoTES==1:
            if  row.tDecayMode==0:
                fTauIso=0.240806-0.000836112*(self.tau_Pt_C*1.006-30)
            elif  row.tDecayMode==1:
                fTauIso=0.235014-0.000837926*(self.tau_Pt_C*1.006-30)
            elif  row.tDecayMode==10:
                fTauIso=0.185752-0.000457377*(self.tau_Pt_C*1.006-30)
            else:
                print "rare decay mode %f" %row.tDecayMode
                fTauIso=0
         if self.DoTES==2:
            if  row.tDecayMode==0:
                fTauIso=0.240806-0.000836112*(self.tau_Pt_C*0.994-30)
            elif  row.tDecayMode==1:
                fTauIso=0.235014-0.000837926*(self.tau_Pt_C*0.994-30)
            elif  row.tDecayMode==10:
                fTauIso=0.185752-0.000457377*(self.tau_Pt_C*0.994-30)
            else:
                print "rare decay mode %f" %row.tDecayMode
                fTauIso=0
         #if fakeset=="def":
         #   if  row.tDecayMode==0:
         #       fTauIso=0.229836
         #   if  row.tDecayMode==1:
         #       fTauIso=0.226219
         #   if  row.tDecayMode==10:
         #       fTauIso=0.182765
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
            return mass/den
    def correction(self,row):
	return self.mc_corrector_2016(row)
	
    def getFakeRateFactormuon(self,row, fakeset):   #Ptbined
        #if fakeset=="def":
        #   if row.mPt<75:
        #      fTauIso=0.80905
        #   if row.mPt>=75:
        #      fTauIso=0.942667
        if fakeset=="def":
           if row.mPt<=30:
              fTauIso=0.624
           elif row.mPt<=40:
              fTauIso=0.725
           elif row.mPt<=50:
              fTauIso=0.754
           elif row.mPt<=80:
              fTauIso=0.808
           else:
              fTauIso=0.958
        #print 'the MES at line 575 %f' %self.DoMES
        if self.DoMES==1:
           if row.mPt*1.002<=30:
              fTauIso=0.624
           elif row.mPt*1.002<=40:
              fTauIso=0.725
           elif row.mPt*1.002<=50:
              fTauIso=0.754
           elif row.mPt*1.002<=80:
              fTauIso=0.808
           else:
              fTauIso=0.958
        if self.DoMES==2:
           if row.mPt*0.998<=30:
              fTauIso=0.624
           elif row.mPt*0.998<=40:
              fTauIso=0.725
           elif row.mPt*0.998<=50:
              fTauIso=0.754
           elif row.mPt*0.998<=80:
              fTauIso=0.808
           else:
              fTauIso=0.958
        if fakeset=="1stUp":
           if row.mPt<55:
              fTauIso=0.792721+0.0305471
           if row.mPt>=55:
              fTauIso=0.905855+0.0339542
        if fakeset=="1stDown":
           if row.mPt<55:
              fTauIso=0.792721-0.0305471
           if row.mPt>=55:
              fTauIso=0.905855-0.0339542
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
           #MetPt4=[math.sqrt(self.tmpMet[0]*self.tmpMet[0]+self.tmpMet[1]*self.tmpMet[1]),self.tmpMet[0],self.tmpMet[1],0]
           print 'Met Before %f and after %f' %(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi),self.tmpMet[0])
           MetRecoillorenz=ROOT.TLorentzVector()
           TauRecoillorenz=ROOT.TLorentzVector()
           MetPhi=math.atan2(self.tmpMet[1],self.tmpMet[0])
           MetRecoillorenz.SetPtEtaPhiM(math.sqrt(self.tmpMet[0]*self.tmpMet[0]+self.tmpMet[1]*self.tmpMet[1]),0,MetPhi,0)
#           MetPt=[math.sqrt(self.tmpMet[0]*self.tmpMet[0]+self.tmpMet[1]*self.tmpMet[1]),self.tmpMet[0],self.tmpMet[1],0]
           TauRecoillorenz.SetPtEtaPhiM(row.tPt,row.tEta,row.tPhi,row.tMass)
           #MetPhi=math.atan2(self.tmpMet[1],self.tmpMet[0])
           #self.TauDphiToMet=abs(row.tPhi-MetPhi)
           self.collMass_type1MetC=self.collMass_type1_v1(row,self.tmpMet[0],self.tmpMet[1])
           self.tMtToPfMet_type1MetC=transverseMass_v2(TauRecoillorenz,MetRecoillorenz)
           self.type1_pfMetEtC=math.sqrt(self.tmpMet[0]*self.tmpMet[0]+self.tmpMet[1]*self.tmpMet[1])
           #print "Met from Tuple %f and from Cal %f" %(row.type1_pfMetEt,math.sqrt(self.tmpMet[0]*self.tmpMet[0]+self.tmpMet[1]*self.tmpMet[1])) 
           #print "CollMass from Tuple %f and from Cal %f" %(row.m_t_collinearmass,self.collMass_type1MetC) 

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
	   #weight = row.GenWeight * self.correction(row)*bTagSF.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)*self.WeightJetbin(row)
           #print "most of the weights %f"  %(weight) 
#	   weight = row.GenWeight * self.correction(row)*self.WeightJetbin(row)
	   #weight = row.GenWeight * self.correction(row)*self.WeightJetbin(row)
#	   weight = row.GenWeight * self.correction(row)*self.WeightJetbin(row)

           #print bTagSF.bTagEventWeight(row.bjetCISVVeto20MediumZTT,row.jb1pt,row.jb1flavor,row.jb2pt,row.jb2flavor,1,btagSys,0)
        if (fakeRate == True):
#          print self.fakeRateMethod(row,fakeset)
          weight=weight*self.fakeRateMethod(row,fakeset,faketype) #apply fakerate method for given isolation definition
        if (self.is_ZTauTau or self.is_HToTauTau or self.is_HToMuTau or self.is_TauTau):
          #weight=weight*0.83
          weight=weight*0.95
        if (self.ls_DY and row.isZmumu  and row.tZTTGenMatching<5):
          weight=weight*getGenMfakeTSF(abs(row.tEta))
     #   if self.ls_DY or self.ls_ZTauTau:
     #      wtzpt=self.Z_reweight_H.GetBinContent(self.Z_reweight_H.GetXaxis().FindBin(row.genM),self.Z_reweight_H.GetYaxis().FindBin(row.genpT))
     #      weight=weight*wtzpt
#        self.pfmetcorr_ex=0.000001
#        self.pfmetcorr_ey=0.000001
#          print "Genmother of Tau ID %d and the additional weight passed %f"  %(row.tGenMotherPdgId,getGenMfakeTSF(abs(row.tEta)))
        #  print weight
#        if self.ls_recoilC and MetCo:
#           print "hahahahahahahahhahahahahahhahah"
#           tmpMet=self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi),row.type1_pfMetEt*math.sin(row.type1_pfMetPhi),row.genpX,row.genpY,row.vispX,row.vispY,int(round(row.jetVeto30)))#,self.pfmetcorr_ex,self.pfmetcorr_ey)
#           MetPt4=[math.sqrt(tmpMet[0]*tmpMet[0]+tmpMet[1]*tmpMet[1]),tmpMet[0],tmpMet[1],0]
#           TauPt4=[row.tPt,row.tPt*math.cos(row.tPhi),row.tPt*math.sin(row.tPhi),0]
#           MetPhi=math.atan2(tmpMet[1],tmpMet[0])
#           self.TauDphiToMet=abs(row.tPhi-MetPhi)
#           self.tMtToPfMet_type1MetC=transverseMass(MetPt4,TauPt4)
#        print tmpMet
#        print "works?   pfmetcorr_ex =%f and pfmetcorr_ey=%f" %(self.pfmetcorr_ex,self.pfmetcorr_ey)
#        histos[name+'/genHTT'].Fill(row.genHTT)
    #    histos[name+'/rho'].Fill(row.rho, weight)
     #   histos[name+'/prescale'].Fill(row.doubleMuPrescale, weight)
#        histos[name+'/singleIsoMu22Pass'].Fill(row.singleIsoMu22Pass,weight)
#        histos[name+'/singleIsoTkMu22Pass'].Fill(row.singleIsoTkMu22Pass,weight)
       # histos[name+'/fullMT_type1'].Fill(fullMT(row.mPt,row.tPt, row.mPhi, row.tPhi, row, systematic),weight)
        #print "MES at line 677 %f" %self.DoMES
        if (not self.Sysin):   
           histos[name+'/tPt'].Fill(self.tau_Pt_C, weight)
           histos[name+'/mPt'].Fill(row.mPt, weight)
#           print "fill histogram? %f" %row.mPt
        #   histos[name+'/type1_pfMetEtNormal'].Fill(row.type1_pfMetEt,weight)
           if self.ls_recoilC and MetCorrection:
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1MetC,weight)
              #histos[name+'/type1_pfMetEt'].Fill(self.type1_pfMetEtC,weight)
           else:
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1_new,weight)
        #      histos[name+'/type1_pfMetEt'].Fill(row.type1_pfMetEt,weight)
           if self.ls_recoilC and MetCorrection: 
              histos[name+'/collMass_type1'].Fill(self.collMass_type1MetC,weight)
           else:
              histos[name+'/collMass_type1'].Fill(self.collMass_type1_new,weight)
        else:
           if self.DoTES:
              #tmpHula=TESup(row.tPt,row.type1_pfMetEt,row.tPhi,row.type1_pfMetPhi)
              #taulorenz=ROOT.SetPtEtaPhiM(tmpHula[0],row.tEta,row.tPhi,row.tMass) 
              #muonlorenz=ROOT.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              #metlorenz=ROOT.SetPtEtaPhiM(tmpHula[3],0,row.type1_pfMetPhi,0)
              histos[name+'/tPt'].Fill(self.tmpHula[0], weight)
              histos[name+'/mPt'].Fill(row.mPt, weight)
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1_new,weight)
              histos[name+'/collMass_type1'].Fill(self.collMass_type1_new,weight)
           if self.DoUES or self.DoJES:
              histos[name+'/tPt'].Fill(self.tau_Pt_C, weight)
              histos[name+'/mPt'].Fill(row.mPt, weight)
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1_new,weight)
              histos[name+'/collMass_type1'].Fill(self.collMass_type1_new,weight)
           if self.DoMES:
              #tmpHula=MESup(row.mPt,row.type1_pfMetEt,row.mPhi,row.type1_pfMetPhi)
              #taulorenz=ROOT.SetPtEtaPhiM(row.tPt,row.tEta,row.tPhi,row.tMass) 
              #muonlorenz=ROOT.SetPtEtaPhiM(tmpHula[0],row.mEta,row.mPhi,row.mMass) 
              #metlorenz=ROOT.SetPtEtaPhiM(tmpHula[3],0,row.type1_pfMetPhi,0)
              #collMass_type1_new=collMass_type1_v2(muonlorenz,taulorenz,tmpHula[4],tmpHula[5])
              #self.tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
              histos[name+'/tPt'].Fill(self.tau_Pt_C, weight)
              histos[name+'/mPt'].Fill(self.tmpHula[0], weight)
              histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1_new,weight)
              histos[name+'/collMass_type1'].Fill(self.collMass_type1_new,weight) 
        if not self.light: 
           histos[name+'/nvtx'].Fill(row.nvtx, weight)
           histos[name+'/weight'].Fill(weight)
           histos[name+'/GenWeight'].Fill(row.GenWeight)
#           histos[name+'/mMtToPfMet_type1'].Fill(row.mMtToPfMet_type1,weight)
           histos[name+'/counts'].Fill(1)
           histos[name+'/mEta'].Fill(row.mEta, weight)
           histos[name+'/tEta'].Fill(row.tEta, weight)
           histos[name+'/tPhi'].Fill(row.tPhi, weight)
       	  # histos[name+'/type1_pfMetEt'].Fill(self.MET_tPtC,weight)
           histos[name+'/m_t_Mass'].Fill(row.m_t_Mass,weight)
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
##        histos[name+'/jet1Pt'].Fill(row.jet1Pt, weight)
##        histos[name+'/jet2Pt'].Fill(row.jet2Pt, weight)
##        histos[name+'/jet3Pt'].Fill(row.jet3Pt, weight)
##        histos[name+'/jet4Pt'].Fill(row.jet4Pt, weight)
##        histos[name+'/jet5Pt'].Fill(row.jet5Pt, weight)
##        histos[name+'/jet1Eta'].Fill(row.jet1Eta, weight)
##        histos[name+'/jet2Eta'].Fill(row.jet2Eta, weight)
##        histos[name+'/jet3Eta'].Fill(row.jet3Eta, weight)
##        histos[name+'/jet4Eta'].Fill(row.jet4Eta, weight)
##        histos[name+'/jet5Eta'].Fill(row.jet5Eta, weight)
##        histos[name+'/jet1Phi'].Fill(row.jet1Phi, weight)
##        histos[name+'/jet2Phi'].Fill(row.jet2Phi, weight)
##        histos[name+'/jet3Phi'].Fill(row.jet3Phi, weight)
##        histos[name+'/jet4Phi'].Fill(row.jet4Phi, weight)
##        histos[name+'/jet5Phi'].Fill(row.jet5Phi, weight)
        
#        histos[name+'/deltaR'].Fill(deltaR(row.tPhi,row.mPhi,row.tEta,row.mEta), weight)
#        histos[name+'/bjetCISVVeto30Loose'].Fill(row.bjetCISVVeto30Loose, weight)
#        histos[name+'/bjetCISVVeto30Medium'].Fill(row.bjetCISVVeto30Medium, weight)
#        histos[name+'/bjetCISVVeto30Tight'].Fill(row.bjetCISVVeto30Tight, weight)
#        histos[name+'/mPtavColMass'].Fill(row.mPt/row.m_t_collinearmass, weight)
#        histos[name+'/mCharge'].Fill(row.mCharge, weight)
     #   histos[name+'/mJetPartonFlavour'].Fill(row.mJetPartonFlavour, weight)
#        histos[name+'/tPtavColMass'].Fill(row.tPt/row.m_t_collinearmass, weight)
#        histos[name+'/tMtToPfMet_type1MetC'].Fill(self.tMtToPfMet_type1MetC,weight)
#        histos[name+'/tCharge'].Fill(row.tCharge, weight)
#	histos[name+'/tJetPt'].Fill(row.tJetPt, weight)

#        histos[name+'/tMass'].Fill(row.tMass,weight)
#        histos[name+'/tLeadTrackPt'].Fill(row.tLeadTrackPt,weight)
#        histos[name+'/tJetPartonFlavour'].Fill(row.tJetPartonFlavour, weight)
#	histos[name+'/tDPhiToPfMet_type1MetC'].Fill(self.TauDphiToMet,weight)
#	histos[name+'/mDPhiToPfMet_tDPhiToPfMet'].Fill(abs(row.mDPhiToPfMet_type1),abs(row.tDPhiToPfMet_type1),weight)
#	histos[name+'/mDPhiToPfMet_ggdeltaphi'].Fill(abs(row.mDPhiToPfMet_type1),deltaPhi(row.mPhi, row.tPhi),weight)
#	histos[name+'/tDPhiToPfMet_ggdeltaphi'].Fill(abs(row.tDPhiToPfMet_type1),deltaPhi(row.mPhi, row.tPhi),weight)
#	histos[name+'/tDPhiToPfMet_tMtToPfMet_type1'].Fill(abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1,weight)
#	histos[name+'/vbfmass_vbfdeta'].Fill(row.vbfMass,abs(row.vbfDeta),weight)

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
     #   if name=="preselection" and (self.ls_recoilC and MetCorrection): 
     #      print "Mass from Tuple %f and from Cal %f" %(row.m_t_collinearmass,self.collMass_type1MetC) 
           #print "Mass from Tuple %f and from Cal %f" %(row.tMtToPfMet_type1,self.tMtToPfMet_type1MetC) 
#        histos[name+'/collMass_type1MetC'].Fill(self.collMass_type1(row,tmpMet[0],tmpMet[1]),weight)
    #    print row.m_t_collinearmass
        #histos[name+'/collMass_type1'].Fill(collMass_type1(row, systematic),weight)
 #       histos[name+'/fullPT_type1'].Fill(fullPT(row.mPt,row.tPt, row.mPhi, row.tPhi, row, systematic),weight) 

 #       histos[name+'/m_t_Pt'].Fill(row.m_t_Pt,weight)
	#histos[name+'/m_t_ToMETDPhi_Ty1'].Fill(row.m_t_ToMETDPhi_Ty1,weight)

##        histos[name+'/mPixHits'].Fill(row.mPixHits, weight)
##        histos[name+'/mJetBtag'].Fill(row.mJetBtag, weight)

##        histos[name+'/muVetoPt5IsoIdVtx'].Fill(row.muVetoPt5IsoIdVtx, weight)
##        histos[name+'/muVetoPt15IsoIdVtx'].Fill(row.muVetoPt15IsoIdVtx, weight)
##        histos[name+'/tauVetoPt20Loose3HitsVtx'].Fill(row.tauVetoPt20Loose3HitsVtx, weight)
##        histos[name+'/eVetoMVAIso'].Fill(row.eVetoMVAIso, weight)
##        histos[name+'/jetVeto30'].Fill(row.jetVeto30, weight)
##        histos[name+'/jetVeto30Eta3'].Fill(row.jetVeto30Eta3,weight)
        #histos[name+'/jetVeto30PUCleanedLoose'].Fill(row.jetVeto30PUCleanedLoose, weight)
        #histos[name+'/jetVeto30PUCleanedTight'].Fill(row.jetVeto30PUCleanedTight, weight)

#	histos[name+'/mRelPFIsoDBDefault'].Fill(row.mRelPFIsoDBDefault, weight)
        
#	histos[name+'/mPhiMtPhi'].Fill(deltaPhi(row.mPhi,row.tPhi),weight)
#        histos[name+'/mPhiMETPhiType1'].Fill(deltaPhi(row.mPhi,row.type1_pfMetPhi),weight)
#        histos[name+'/tPhiMETPhiType1'].Fill(deltaPhi(row.tPhi,row.type1_pfMetPhi),weight)
#	histos[name+'/tDecayMode'].Fill(row.tDecayMode, weight)
#	histos[name+'/vbfJetVeto30'].Fill(row.vbfJetVeto30, weight)
     	#histos[name+'/vbfJetVeto20'].Fill(row.vbfJetVeto20, weight)
        #histos[name+'/vbfMVA'].Fill(row.vbfMVA, weight)
        #histos[name+'/vbfj1eta'].Fill(row.vbfj1eta, weight)
        #histos[name+'/vbfj2eta'].Fill(row.vbfj2eta, weight)
        #histos[name+'/vbfVispt'].Fill(row.vbfVispt, weight)
        #histos[name+'/vbfHrap'].Fill(row.vbfHrap, weight)
        #histos[name+'/vbfDijetrap'].Fill(row.vbfDijetrap, weight)
        #histos[name+'/vbfDphihj'].Fill(row.vbfDphihj, weight)
        #histos[name+'/vbfDphihjnomet'].Fill(row.vbfDphihjnomet, weight)
 #       histos[name+'/vbfNJets30'].Fill(row.vbfNJets30, weight)
        #histos[name+'/vbfNJets30PULoose'].Fill(row.vbfNJets30PULoose, weight)
        #histos[name+'/vbfNJets30PUTight'].Fill(row.vbfNJets30PUTight, weight)
    def TauESC(self,row):
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
       # print "inside TauESC and then?"
        return (tau_Pt_C,MET_tPtC)
    def VariableCalculateTaucorrection(self,row,tmp_tau_Pt_C,tmp_MET_tPtC):
          # print "inside VariableCalculateTaucorrection00000"
           taulorenz=ROOT.TLorentzVector()
           muonlorenz=ROOT.TLorentzVector()             
           metlorenz=ROOT.TLorentzVector() 
           #print 'at line 871 the MES %f ' %self.DoMES
          # self.tmpHulaJES=(JESShiftedMet,JESShiftedPhi)
           taulorenz.SetPtEtaPhiM(tmp_tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
#           print "taulorenz %f %f %f" %(taulorenz.Pt(),taulorenz.Px(),taulorenz.Py())
           muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
#           print "muonlorenz %f %f %f" %(muonlorenz.Pt(),muonlorenz.Px(),muonlorenz.Py())
           metlorenz.SetPtEtaPhiM(tmp_MET_tPtC,0,row.type1_pfMetPhi,0)
#           print "metlorenz %f %f %f" %(metlorenz.Pt(),metlorenz.Px(),metlorenz.Py())
           collMass_type1_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,metlorenz.Px(),metlorenz.Py())
           tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
           #print "the mass and tauMetmass %f     %f"   %(collMass_type1_new,tMtToPfMet_type1_new)
           return(collMass_type1_new,tMtToPfMet_type1_new)
    def VariableCalculate(self,row):
           taulorenz=ROOT.TLorentzVector()
           muonlorenz=ROOT.TLorentzVector()             
           metlorenz=ROOT.TLorentzVector() 
           #print 'at line 871 the MES %f ' %self.DoMES
           if self.DoTES==1:
              self.tmpHula=Systematics.TESup(self.tau_Pt_C,self.MET_tPtC,row.tPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(self.tmpHula[0],row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(self.tmpHula[3],0,row.type1_pfMetPhi,0)
              self.collMass_type1_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,self.tmpHula[4],self.tmpHula[5])
              self.tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
           if self.DoTES==2:
              self.tmpHula=Systematics.TESdown(self.tau_Pt_C,self.MET_tPtC,row.tPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(self.tmpHula[0],row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(self.tmpHula[3],0,row.type1_pfMetPhi,0)
              self.collMass_type1_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,self.tmpHula[4],self.tmpHula[5])
              self.tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
           if self.DoMES==1:
              self.tmpHula=Systematics.MESup(row.mPt,row.mEta,self.MET_tPtC,row.mPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(self.tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(self.tmpHula[0],row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(self.tmpHula[3],0,row.type1_pfMetPhi,0)
              self.collMass_type1_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,self.tmpHula[4],self.tmpHula[5])
              self.tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
           if self.DoMES==2:
              self.tmpHula=Systematics.MESdown(row.mPt,row.mEta,self.MET_tPtC,row.mPhi,row.type1_pfMetPhi)
              taulorenz.SetPtEtaPhiM(self.tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(self.tmpHula[0],row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(self.tmpHula[3],0,row.type1_pfMetPhi,0)
              self.collMass_type1_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,self.tmpHula[4],self.tmpHula[5])
              self.tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
           if self.DoUES==1:
              if  row.tDecayMode==0:
                  UES_shiftedMetup=row.type1_pfMet_shiftedPt_UnclusteredEnUp+0.018*row.tPt
              if  row.tDecayMode==1:
                  UES_shiftedMetup=row.type1_pfMet_shiftedPt_UnclusteredEnUp-0.01*row.tPt
              if  row.tDecayMode==10:
                  UES_shiftedMetup=row.type1_pfMet_shiftedPt_UnclusteredEnUp-0.004*row.tPt
              self.tmpHula=Systematics.UESup(UES_shiftedMetup,row.type1_pfMet_shiftedPhi_UnclusteredEnUp)
              taulorenz.SetPtEtaPhiM(self.tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(self.tmpHula[0],0,self.tmpHula[3],0)
              self.collMass_type1_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,self.tmpHula[1],self.tmpHula[2])
              self.tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
           if self.DoUES==2:
              if  row.tDecayMode==0:
                  UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown+0.018*row.tPt
              if  row.tDecayMode==1:
                  UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown-0.01*row.tPt
              if  row.tDecayMode==10:
                  UES_shiftedMetdown=row.type1_pfMet_shiftedPt_UnclusteredEnDown-0.004*row.tPt
              self.tmpHula=Systematics.UESdown(UES_shiftedMetdown,row.type1_pfMet_shiftedPhi_UnclusteredEnDown)
              taulorenz.SetPtEtaPhiM(self.tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
              muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
              metlorenz.SetPtEtaPhiM(self.tmpHula[0],0,self.tmpHula[3],0)
              self.collMass_type1_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,self.tmpHula[1],self.tmpHula[2])
              self.tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)
    def VariableCalculateJES(self,row,JESShiftedMet,JESShiftedPhi):
           taulorenz=ROOT.TLorentzVector()
           muonlorenz=ROOT.TLorentzVector()             
           metlorenz=ROOT.TLorentzVector() 

           if  row.tDecayMode==0:
               JESShiftedMet_new=JESShiftedMet+0.018*row.tPt
           if  row.tDecayMode==1:
               JESShiftedMet_new=JESShiftedMet-0.01*row.tPt
           if  row.tDecayMode==10:
               JESShiftedMet_new=JESShiftedMet-0.004*row.tPt

           #print 'at line 871 the MES %f ' %self.DoMES
           self.tmpHulaJES=(JESShiftedMet_new,JESShiftedPhi)
           taulorenz.SetPtEtaPhiM(self.tau_Pt_C,row.tEta,row.tPhi,row.tMass) 
           muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass) 
           metlorenz.SetPtEtaPhiM(self.tmpHulaJES[0],0,self.tmpHulaJES[1],0)
           self.collMass_type1_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,self.tmpHulaJES[0]*math.cos(self.tmpHulaJES[1]),self.tmpHulaJES[0]*math.sin(self.tmpHulaJES[1]))
           self.tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)

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
#    def selectZeroJet(self,row):
#	if (self.is_ZeroJet and row.numGenJets != 0):
#            return False
#	return True
#    def selectOneJet(self,row):
#	if (self.is_OneJet and row.numGenJets != 1):
#            return False
#	return True
#    def selectTwoJet(self,row):
#	if (self.is_TwoJet and row.numGenJets != 2):
#            return False
#	return True
#
#    def selectThreeJet(self,row):
#	if (self.is_ThreeJet and row.numGenJets != 3):
#            return False
#	return True
#    def selectFourJet(self,row):
#	if (self.is_FourJet and row.numGenJets !=4 ):
#            return False
#	return True
    def WjetsEnrich(self,row):
        if (row.tMtToPfMet_type1>60 and row.mMtToPfMet_type1>80):
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
        #   if abs(row.mEta)>1.2 and abs(row.mEta)<=2.1 :
        #         if row.mPt*1.009 < 26:
        #            return False
        #   if row.mEta<-2.1 and row.mEta>=-2.4 :
        #         if row.mPt*1.027 < 26:
        #            return False
        #   if row.mEta>2.1 and row.mEta<=2.4 :
        #         if row.mPt*1.017 < 26:
        #            return False
        if self.DoMES==2  :
        #   if abs(row.mEta)<=1.2:
                 if row.mPt*0.998 < 26:
                    return False
        #   if abs(row.mEta)>1.2 and abs(row.mEta)<=2.1 :
        #         if row.mPt*0.991 < 26:
        #            return False
        #   if row.mEta<-2.1 and row.mEta>=-2.4 :
        #         if row.mPt*0.973 < 26:
        #            return False
        #   if row.mEta>2.1 and row.mEta<=2.4 :
        #         if row.mPt*0.983 < 26:
        #            return False
        if not self.DoMES:
           if row.mPt< 26:
               return False
    #    if abs(row.mEta) >= 2.4:
    #        return False
  
        if self.DoTES==1  :
           if self.tau_Pt_C*1.006 < 30:
               return False
        if self.DoTES==2  :
           if self.tau_Pt_C*0.994 < 30:
               return False
        if not self.DoTES:
           if self.tau_Pt_C<30 :
               return False
    #    if abs(row.tEta)>=2.3:
    #        return False
        return True

    def kinematics_new(self, row):
    #    if DoMES==1  :
    #       if row.mPt*1.01 < 25:
    #           return False
    #    if DoMES==2  :
    #       if row.mPt*0.99 < 25:
    #           return False
    #    if not DoMES:
    #       if row.mPt< 25:
    #           return False
        if abs(row.mEta) >= 2.4:
            return False
  
    #    if row.tPt<30 :
    #        return False
        if abs(row.tEta)>=2.3:
            return False
        return True
    def gg(self,row):
#       if row.mPt < 25:   #was45     #newcuts 25 
#           return False
#       if deltaPhi(row.mPhi, row.tPhi) <2.7:  # was 2.7    #new cut 2.7
#           return False
#       if row.tPt < 30:  #was 35   #newcuts30
#           return False
#       if row.tMtToPfMet_type1 > 105:  #was 50   #newcuts65
#           return False
       if self.ls_recoilC and MetCorrection:
          if self.tMtToPfMet_type1MetC > 105:  #was 50   #newcuts65
             return False
#       else:
#          if  row.tMtToPfMet_type1 > 105:  #was 50   #newcuts65
#             return False
       #print 'line 1035 the Sysin %f'  %self.Sysin
     #  if  self.Sysin:
       if self.tMtToPfMet_type1_new > 105:  #was 50   #newcuts65
             return False
       #else:
       #   if row.tMtToPfMet_type1> 105:  #was 50   #newcuts65
       #      return False
          
#####       if abs(row.tDPhiToPfMet_type1)>3.0:
####           return False
#       if self.ls_recoilC and MetCorrection:
#          if abs(self.TauDphiToMet)>3.0:
#             return False
#       else:
#          if abs(row.tDPhiToPfMet_type1)>3.0:
#             return False
#          
#       if row.jetVeto30!=0:
#           return False
#       if row.bjetCISVVeto30Loose:
#            return False
       return True

    def boost(self,row):
#          if row.jetVeto30!=1:
#            return False
#          if row.mPt < 25:  #was 35    #newcuts 25
#                return False
#          if row.tPt < 30:  #was 40  #newcut 30
#                return False
#          if row.tMtToPfMet_type1 > 105: #was 35   #newcuts 75
#                return False
          if self.ls_recoilC and MetCorrection:
             if self.tMtToPfMet_type1MetC > 105:  #was 50   #newcuts65
                return False
#          else:
#             if row.tMtToPfMet_type1 > 105:  #was 50   #newcuts65
#                return False  
#####          if abs(row.tDPhiToPfMet_type1)>3.0:
####              return False
        #  if  self.Sysin:
          if self.tMtToPfMet_type1_new > 105:  #was 50   #newcuts65
                return False
          #else:
          #   if row.tMtToPfMet_type1> 105:  #was 50   #newcuts65
          #      return False
#          if self.ls_recoilC and MetCorrection:
#             if abs(self.TauDphiToMet)>3.0:
#                return False
#          else:
#             if abs(row.tDPhiToPfMet_type1)>3.0:
#                return False
 #         if row.bjetCISVVeto30Loose:
 #               return False
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
      #  if row.tMtToPfMet_type1 > 85: #was 35   #newcuts 55
        #if  self.Sysin:
        if self.tMtToPfMet_type1_new > 85:  #was 50   #newcuts65
              return False
        #else:
        #   if row.tMtToPfMet_type1> 85:  #was 50   #newcuts65
        #      return False
                 #return False
#        if row.jetVeto30<2:  
#            return False
#	if(row.vbfNJets30<2):
#	    return False
	if(abs(row.vbfDeta)<3.5):   #was 2.5    #newcut 2.0
	    return False
        if row.vbfMass < 550:    #was 200   newcut 325
	    return False
        #if row.vbfJetVeto30 > 0:
        #    return False
  #      if row.bjetCISVVeto30Medium:
  #          return False
        return True

    def vbf_gg(self,row):
#        if row.tPt < 30:   #was 40   #newcuts 30
#                return False
#        if row.mPt < 25:   #was 40    #newcut 25
#       		return False
   #     if row.tMtToPfMet_type1 > 105: #was 35   #newcuts 55
   #             return False
        if self.ls_recoilC and MetCorrection:
            if self.tMtToPfMet_type1MetC > 105:  #was 50   #newcuts65
               return False
#        else:
#            if row.tMtToPfMet_type1 > 105:  #was 50   #newcuts65
#               return False
        #if  self.Sysin:
        if self.tMtToPfMet_type1_new > 105:  #was 50   #newcuts65
              return False
        #else:
        #   if row.tMtToPfMet_type1> 105:  #was 50   #newcuts65
        #      return False
#        if row.jetVeto30<2:  
#            return False
#	if(row.vbfNJets30<2):
#	    return False
	#if (abs(row.vbfDeta)>3.5 and row.vbfMass > 550):   #was 2.5    #newcut 2.0
        if not self.DoJES:
	   if (row.vbfMass >= 550):   #was 2.5    #newcut 2.0
	      return False
#        if row.vbfMass > 550:    #was 20   newcut 240
#	    return False
#        if row.vbfMass < 100:    #was 20   newcut 240
#	    return False
  #      if row.vbfJetVeto30 > 0:
  #          return False
#        if row.bjetCISVVeto30Medium:
#            return False
        return True
    def vbf_vbf(self,row):
#        if row.tPt < 30:   #was 40   #newcuts 30
#                return False
#        if row.mPt < 25:   #was 40    #newcut 25
#       		return False
  #      if row.tMtToPfMet_type1 > 85: #was 35   #newcuts 55
  #              return False
#        if self.tMtToPfMet_type1MetC > 85: #was 35   #newcuts 55
#                return False
        if self.ls_recoilC and MetCorrection:
            if self.tMtToPfMet_type1MetC > 105:  #was 50   #newcuts65
               return False
#        else:
#            if row.tMtToPfMet_type1 > 105:  #was 50   #newcuts65
#               return False
        #if  self.Sysin:
           #if self.tMtToPfMet_type1_new > 85:  #was 50   #newcuts65
        if self.tMtToPfMet_type1_new > 85:  #was 50   #newcuts65
              return False
        #else:
           #if row.tMtToPfMet_type1> 85:  #was 50   #newcuts65
        #   if row.tMtToPfMet_type1> 105:  #was 50   #newcuts65
        #      return False
#        if row.jetVeto30<2:  
#            return False
#	if(row.vbfNJets30<2):
#	    return False
	#if(abs(row.vbfDeta)<3.5 or (row.vbfMass < 550)):   #was 2.5    #newcut 2.0
        if not self.DoJES:
   	   if((row.vbfMass < 550)):   #was 2.5    #newcut 2.0
	      return False
#        if row.vbfMass > 240:    #was 200   newcut 325
#	    return False
    #    if row.vbfJetVeto30 > 0:
    #        return False
#        if  row.bjetCISVVeto30Medium:
#            return False
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
        self.DoMES=0; self.DoTES=0; self.DoJES=0;self.DoUES=0
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
#            if pu_corrector(row.nTruePU)>10:
#               print "hight pileupC %f" %(pu_corrector(row.nTruePU))
#            if not self.selectZeroJet(row):
#		continue
#            if not self.selectOneJet(row):
#		continue
#            if not self.selectTwoJet(row):
#		continue
#            if not self.selectThreeJet(row):
#		continue
#            if not self.selectFourJet(row):
#		continue
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
#            if abs(row.tGenPdgId)!=15 and abs(row.tGenPdgId)!=999:
#               print row.tGenPdgId
#            else: 
#               continue
            #print "comes here???00000"
#            global Sysin
            normaldecayfanbo=0
            if ((int(round(row.tDecayMode)))==0) or ((int(round(row.tDecayMode)))==1) or ((int(round(row.tDecayMode)))==10):
               normaldecayfanbo=1
            if not normaldecayfanbo:
               continue
            self.SetsysZero(row)
            #print "one new event*****************************"
            self.tau_Pt_C,self.MET_tPtC=self.TauESC(row)
            #print "one new event*****************************1"
            self.collMass_type1_new,self.tMtToPfMet_type1_new=self.VariableCalculateTaucorrection(row,self.tau_Pt_C,self.MET_tPtC)
            #print "one new event*****************************2"
            self.Sysin=0
            #if (not row.tDecayMode==0) or (not row.tDecayMode==1) or (not row.tDecayMode==10):
            #   continue 
            #print "comes here)))))"
            #print "mass collin def  %f" %(self.collMass_type1_new)
#            print "Sysin value at line 13022 %f" %self.Sysin
            if (fakeset or wjets_fakes or tuning) and self.kinematics(row):
             if self.obj1_iso(row):
               if self.obj2_iso(row) and not self.oppositesign(row):
                  if fakeset:
                     if (not self.light) and self.WjetsEnrich(row):
                        self.fill_histos(row,'preslectionSSEnWjets')
                     self.fill_histos(row,'preselectionSS')
                  if (not self.light):
                     if row.jetVeto30==0:
                       self.fill_histos(row,'IsoSS0Jet')
                       if self.gg(row):
                          self.fill_histos(row,'ggIsoSS')
                       if RUN_OPTIMIZATION:
                          for  i in optimizer_new.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
                             tmp=os.path.join("ggIsoSS",i)
                             self.fill_histos(row,tmp,False)
                     if row.jetVeto30==1:
                       self.fill_histos(row,'IsoSS1Jet')
                       if self.boost(row):
                          self.fill_histos(row,'boostIsoSS')
                       if RUN_OPTIMIZATION:
                          for  i in optimizer_new.compute_regions_1jet(row.tPt, row.mPt,deltaPhi(row.mPhi,row.tPhi),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
                             tmp=os.path.join("boostIsoSS",i)
                             self.fill_histos(row,tmp,False)
                     if row.jetVeto30==2:
                       self.fill_histos(row,'IsoSS2Jet')
                       if self.vbf(row):
                          self.fill_histos(row,'vbfIsoSS')
                       if((row.vbfMass < 550)):
                          self.fill_histos(row,'IsoSS2Jet_gg')
                       if((row.vbfMass >= 550)):
                          self.fill_histos(row,'IsoSS2Jet_vbf')
                       if self.vbf_vbf(row):
                          self.fill_histos(row,'vbf_vbfIsoSS')
                       if RUN_OPTIMIZATION:
                          for  i in optimizer_new.compute_regions_2jettight(row.tPt, row.mPt,row.tMtToPfMet_type1,row.vbfMass,row.vbfDeta):
                             tmp=os.path.join("vbf_vbfIsoSS",i)
                             self.fill_histos(row,tmp,False)
                       if self.vbf_gg(row):
                       #   if row.vbfMass>100:
                             self.fill_histos(row,'vbf_ggIsoSS')
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
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjetsSS',True)
                         if row.jetVeto30==0:
                           self.fill_histos(row,'notIsoSS0Jet',True)
#                           if self.gg(row):
#                              self.fill_histos(row,'ggIsoSS')
                         if row.jetVeto30==1:
                           self.fill_histos(row,'notIsoSS1Jet',True)
#                           if self.boost(row):
#                              self.fill_histos(row,'boostIsoSS')
                         if row.jetVeto30==2:
                           self.fill_histos(row,'notIsoSS2Jet',True)
#                           if self.vbf(row):
 #                             self.fill_histos(row,'vbfIsoSS')
                           if((row.vbfMass < 550)):
                              self.fill_histos(row,'notIsoSS2Jet_gg',True)
                           if((row.vbfMass >= 550)):
                              self.fill_histos(row,'notIsoSS2Jet_vbf',True)
#                           if self.vbf_vbf(row):
#           here                   self.fill_histos(row,'vbf_vbfIsoSS')
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
#                           if self.gg(row):
#                              self.fill_histos(row,'ggIsoSS')
                         if row.jetVeto30==1:
                           self.fill_histos(row,'notIsoSS1JetM',True,faketype="muonfake")
#                           if self.boost(row):
#                              self.fill_histos(row,'boostIsoSS')
                         if row.jetVeto30==2:
                           self.fill_histos(row,'notIsoSS2JetM',True,faketype="muonfake")
#                           if self.vbf(row):
 #                             self.fill_histos(row,'vbfIsoSS')
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
#                           if self.gg(row):
#                              self.fill_histos(row,'ggIsoSS')
                         if row.jetVeto30==1:
                           self.fill_histos(row,'notIsoSS1JetMT',True,faketype="mtfake")
#                           if self.boost(row):
#                              self.fill_histos(row,'boostIsoSS')
                         if row.jetVeto30==2:
                           self.fill_histos(row,'notIsoSS2JetMT',True,faketype="mtfake")
#                           if self.vbf(row):
 #                             self.fill_histos(row,'vbfIsoSS')
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


                    if wjets_fakes:
                       self.fill_histos(row,'preselection')
                    if row.jetVeto30==0:
                      self.fill_histos(row,'preselection0Jet')
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'preslectionEnWjets0Jet')
                      if wjets_fakes and row.isWmunu==1:
                         self.fill_histos(row,'Wmunu_preselection0Jet')
                      if wjets_fakes and row.isWtaunu==1:
                         self.fill_histos(row,'Wtaunu_preselection0Jet')
                      if wjets_fakes and (row.isWtaunu==0 and row.isWmunu==0):
                         self.fill_histos(row,'W2jets_preselection0Jet')
         
                    if row.jetVeto30==1:
                      self.fill_histos(row,'preselection1Jet')
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'preslectionEnWjets1Jet')
                      if wjets_fakes and row.isWmunu==1:
                         self.fill_histos(row,'Wmunu_preselection1Jet')
                      if wjets_fakes and row.isWtaunu==1:
                         self.fill_histos(row,'Wtaunu_preselection1Jet')
                      if wjets_fakes and (row.isWtaunu==0 and row.isWmunu==0):
                         self.fill_histos(row,'W2jets_preselection1Jet')
                    if row.jetVeto30==2:
                      self.fill_histos(row,'preselection2Jet')
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'preslectionEnWjets2Jet')
                      if wjets_fakes and row.isWmunu==1:
                         self.fill_histos(row,'Wmunu_preselection2Jet')
                      if wjets_fakes and row.isWtaunu==1:
                         self.fill_histos(row,'Wtaunu_preselection2Jet')
                      if wjets_fakes and (row.isWtaunu==0 and row.isWmunu==0):
                         self.fill_histos(row,'W2jets_preselection2Jet')
                      if((row.vbfMass < 550)):
                        self.fill_histos(row,'preselection2Jet_gg')
                        if self.WjetsEnrich(row):
                           self.fill_histos(row,'preslectionEnWjets2Jet_gg')
                      if((row.vbfMass >= 550)):
                        self.fill_histos(row,'preselection2Jet_vbf')
                        if self.WjetsEnrich(row):
                           self.fill_histos(row,'preslectionEnWjets2Jet_vbf')

             #    if self.gg(row):
             #        self.fill_histos(row,'gg',False)

                 if  row.jetVeto30==0:
                     if RUN_OPTIMIZATION:
                        for  i in optimizer_new.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
   	                   tmp=os.path.join("gg",i)
	                   self.fill_histos(row,tmp,False)	
                     if self.gg(row):
                        #   print "the preselection SF Correction %f" %(self.correction(row))
                           #print 'fill normal gg line 1505' 
#                           print "comes here???2222222222222"
                           self.fill_histos(row,'gg',False)
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
                     if self.boost(row):
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
#	                   tmp=os.path.join("vbf",i)
#	                   self.fill_histos(row,tmp,False)
                     if not self.light:	
                        if self.vbf(row):
                           self.fill_histos(row,'vbf')
                     if self.vbf_gg(row):
                      #  if row.vbfMass>100:
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
                     if self.vbf_vbf(row):
                           #print 'fill normal vbf_vbf line 1573' 
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
#                    self.fill_histos(row,'notIsoNotWeighted',False)

                    if row.jetVeto30==0:
                      self.fill_histos(row,'notIso0Jet',True)
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets0Jet',True)
                    if row.jetVeto30==1:
                      self.fill_histos(row,'notIso1Jet',True)
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets1Jet',True)
                    if row.jetVeto30==2:
                      self.fill_histos(row,'notIso2Jet',True)
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets2Jet',True)
                      if((row.vbfMass < 550)):
                         self.fill_histos(row,'notIso2Jet_gg',True)
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjets2Jet_gg',True)
                      if((row.vbfMass >= 550)):
                         self.fill_histos(row,'notIso2Jet_vbf',True)
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjets2Jet_vbf',True)
                 if  row.jetVeto30==0:
                    # #if RUN_OPTIMIZATION:
                       # for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),row.tMtToPfMet_type1):
                    # #   for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),abs(row.mDPhiToPfMet_type1),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
                    # #      tmp=os.path.join("ggNotIso",i)
                    # #      self.fill_histos(row,tmp,True)
                     if self.gg(row):
                           self.fill_histos(row,'ggNotIso',True)
                           if (not self.light) and  fakeset:
                              self.fill_histos(row,'ggNotIso1stUp',True,'taufake',"1stUp")
                              self.fill_histos(row,'ggNotIso1stDown',True,'taufake',"1stDown")
                    #          self.fill_histos(row,'ggNotIso2ndUp',True,'taufake',"2ndUp")
                    #          self.fill_histos(row,'ggNotIso2ndDown',True,'taufake',"2ndDown")
           #      if self.gg(row):
           #          self.fill_histos(row,'ggNotIso',True)
                 if row.jetVeto30==1:
                  #  # if RUN_OPTIMIZATION:
                  #  #    for  i in optimizer.compute_regions_1jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
                  #  #      tmp=os.path.join("boostNotIso",i)
                  #  #       self.fill_histos(row,tmp,True)
                     if self.boost(row):
                           self.fill_histos(row,'boostNotIso',True)
                           if (not self.light) and fakeset:
                              self.fill_histos(row,'boostNotIso1stUp',True,'taufake',"1stUp")
                              self.fill_histos(row,'boostNotIso1stDown',True,'taufake',"1stDown")
                   #           self.fill_histos(row,'boostNotIso2ndUp',True,'taufake',"2ndUp")
                   #           self.fill_histos(row,'boostNotIso2ndDown',True,'taufake',"2ndDown")
         #        if self.boost(row):
         #            self.fill_histos(row,'boostNotIso',True)
                 #if (row.jetVeto30>=2 and row.vbfJetVeto30 <= 0) :
                 if (row.jetVeto30==2) :
            #     #    if RUN_OPTIMIZATION:
            #     #       for  i in optimizer.compute_regions_2jet(row.tPt, row.mPt,row.tMtToPfMet_type1,row.vbfMass,row.vbfDeta):
            #     #          tmp=os.path.join("vbfNotIso",i)
            #     #          self.fill_histos(row,tmp,True)
                     if not self.light:
                        if self.vbf(row):
                           self.fill_histos(row,'vbfNotIso',True)
                     if self.vbf_gg(row):
                   #     if row.vbfMass>100: 
                           self.fill_histos(row,'vbf_ggNotIso',True)
                           if (not self.light) and fakeset:
                              self.fill_histos(row,'vbf_ggNotIso1stUp',True,'taufake',"1stUp")
                              self.fill_histos(row,'vbf_ggNotIso1stDown',True,'taufake',"1stDown")
                    #          self.fill_histos(row,'vbf_ggNotIso2ndUp',True,'taufake',"2ndUp")
                    #          self.fill_histos(row,'vbf_ggNotIso2ndDown',True,'taufake',"2ndDown")
                    #    else:
                    #       self.fill_histos(row,'boostNotIso',True)
                    #       if fakeset:
                    #          self.fill_histos(row,'boostNotIso1stUp',True,'taufake',"1stUp")
                    #          self.fill_histos(row,'boostNotIso1stDown',True,'taufake',"1stDown")
                    #          self.fill_histos(row,'boostNotIso2ndUp',True,'taufake',"2ndUp")
                    #          self.fill_histos(row,'boostNotIso2ndDown',True,'taufake',"2ndDown")

                     if self.vbf_vbf(row):
                           self.fill_histos(row,'vbf_vbfNotIso',True)
                           if (not self.light) and fakeset:
                              self.fill_histos(row,'vbf_vbfNotIso1stUp',True,'taufake',"1stUp")
                              self.fill_histos(row,'vbf_vbfNotIso1stDown',True,'taufake',"1stDown")
                    #          self.fill_histos(row,'vbf_vbfNotIso2ndUp',True,'taufake',"2ndUp")
                    #          self.fill_histos(row,'vbf_vbfNotIso2ndDown',True,'taufake',"2ndDown")
            if self.obj2_iso_NT_VLoose(row) and self.oppositesign(row) and self.kinematics(row):
              if not self.obj1_iso(row):
                 if not self.light:
                    if fakeset:
                       self.fill_histos(row,'notIsoMT',True,faketype="mtfake")
                       if self.WjetsEnrich(row):
                          self.fill_histos(row,'notIsoEnWjetsMT',True,faketype="mtfake")
#                    self.fill_histos(row,'notIsoNotWeighted',False)

                    if row.jetVeto30==0:
                      self.fill_histos(row,'notIso0JetMT',True,faketype="mtfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets0JetMT',True,faketype="mtfake")
                    if row.jetVeto30==1:
                      self.fill_histos(row,'notIso1JetMT',True,faketype="mtfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets1JetMT',True,faketype="mtfake")
                    if row.jetVeto30==2:
                      self.fill_histos(row,'notIso2JetMT',True,faketype="mtfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets2JetMT',True,faketype="mtfake")
                      if((row.vbfMass < 550)):
                         self.fill_histos(row,'notIso2Jet_ggMT',True,faketype="mtfake")
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjets2Jet_ggMT',True,faketype="mtfake")
                      if((row.vbfMass >= 550)):
                         self.fill_histos(row,'notIso2Jet_vbfMT',True,faketype="mtfake")
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjets2Jet_vbfMT',True,faketype="mtfake")
                 if  row.jetVeto30==0:
                    # #if RUN_OPTIMIZATION:
                       # for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),row.tMtToPfMet_type1):
                    # #   for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),abs(row.mDPhiToPfMet_type1),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
                    # #      tmp=os.path.join("ggNotIso",i)
                    # #      self.fill_histos(row,tmp,True)
                     if self.gg(row):
                           self.fill_histos(row,'ggNotIsoMT',True,faketype="mtfake")
                           if (not self.light) and fakeset:
                              self.fill_histos(row,'ggNotIsoMT1stUp',True,'mtfake',"1stUp")
                              self.fill_histos(row,'ggNotIsoMT1stDown',True,'mtfake',"1stDown")
#                              self.fill_histos(row,'ggNotIsoMT1stUp',True,"1stUp",faketype="mtfake")
#                              self.fill_histos(row,'ggNotIsoMT1stDown',True,"1stDown",faketype="mtfake")
#                              self.fill_histos(row,'ggNotIsoMT2ndUp',True,"2ndUp",faketype="mtfake")
#                              self.fill_histos(row,'ggNotIsoMT2ndDown',True,"2ndDown",faketype="mtfake")
           #      if self.gg(row):
           #          self.fill_histos(row,'ggNotIso',True)
                 if row.jetVeto30==1:
                  #  # if RUN_OPTIMIZATION:
                  #  #    for  i in optimizer.compute_regions_1jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
                  #  #      tmp=os.path.join("boostNotIso",i)
                  #  #       self.fill_histos(row,tmp,True)
                     if self.boost(row):
                           self.fill_histos(row,'boostNotIsoMT',True,faketype="mtfake")
                           if (not self.light) and fakeset:
                              self.fill_histos(row,'boostNotIsoMT1stUp',True,'mtfake',"1stUp")
                              self.fill_histos(row,'boostNotIsoMT1stDown',True,'mtfake',"1stDown")
#                              self.fill_histos(row,'boostNotIsoMT1stUp',True,"1stUp",faketype="mtfake")
#                              self.fill_histos(row,'boostNotIsoMT1stDown',True,"1stDown",faketype="mtfake")
#                              self.fill_histos(row,'boostNotIsoMT2ndUp',True,"2ndUp",faketype="mtfake")
#                              self.fill_histos(row,'boostNotIsoMT2ndDown',True,"2ndDown",faketype="mtfake")
         #        if self.boost(row):
         #            self.fill_histos(row,'boostNotIso',True)
                 #if (row.jetVeto30>=2 and row.vbfJetVeto30 <= 0) :
                 if (row.jetVeto30==2) :
            #     #    if RUN_OPTIMIZATION:
            #     #       for  i in optimizer.compute_regions_2jet(row.tPt, row.mPt,row.tMtToPfMet_type1,row.vbfMass,row.vbfDeta):
            #     #          tmp=os.path.join("vbfNotIso",i)
            #     #          self.fill_histos(row,tmp,True)
                     if not self.light:
                        if self.vbf(row):
                           self.fill_histos(row,'vbfNotIsoMT',True,faketype="mtfake")
                     if self.vbf_gg(row):
                    #    if row.vbfMass>100: 
                           self.fill_histos(row,'vbf_ggNotIsoMT',True,faketype="mtfake")
                           if (not self.light) and fakeset:
                              self.fill_histos(row,'vbf_ggNotIsoMT1stUp',True,'mtfake',"1stUp")
                              self.fill_histos(row,'vbf_ggNotIsoMT1stDown',True,'mtfake',"1stDown")
#                              self.fill_histos(row,'vbf_ggNotIsoMT1stUp',True,"1stUp",faketype="mtfake")
#                              self.fill_histos(row,'vbf_ggNotIsoMT1stDown',True,"1stDown",faketype="mtfake")
#                              self.fill_histos(row,'vbf_ggNotIsoMT2ndUp',True,"2ndUp",faketype="mtfake")
#                              self.fill_histos(row,'vbf_ggNotIsoMT2ndDown',True,"2ndDown",faketype="mtfake")
                    #    else:
                    #       self.fill_histos(row,'boostNotIsoMT',True,faketype="mtfake")
#                           if fakeset:
#                              self.fill_histos(row,'boostNotIsoMT1stUp',True,"1stUp",faketype="mtfake")
#                              self.fill_histos(row,'boostNotIsoMT1stDown',True,"1stDown",faketype="mtfake")
#                              self.fill_histos(row,'boostNotIsoMT2ndUp',True,"2ndUp",faketype="mtfake")
#                              self.fill_histos(row,'boostNotIsoMT2ndDown',True,"2ndDown",faketype="mtfake")

                     if self.vbf_vbf(row):
                           self.fill_histos(row,'vbf_vbfNotIsoMT',True,faketype="mtfake")
                           if (not self.light) and fakeset:
                              self.fill_histos(row,'vbf_vbfNotIsoMT1stUp',True,'mtfake',"1stUp")
                              self.fill_histos(row,'vbf_vbfNotIsoMT1stDown',True,'mtfake',"1stDown")
#                              self.fill_histos(row,'vbf_vbfNotIsoMT1stUp',True,"1stUp",faketype="mtfake")
#                              self.fill_histos(row,'vbf_vbfNotIsoMT1stDown',True,"1stDown",faketype="mtfake")
#                              self.fill_histos(row,'vbf_vbfNotIsoMT2ndUp',True,"2ndUp",faketype="mtfake")

#                              self.fill_histos(row,'vbf_vbfNotIsoMT2ndDown',True,"2ndDown",faketype="mtfake")
            if self.obj2_iso(row) and self.oppositesign(row) and self.kinematics(row):
              if not self.obj1_iso(row):
                 if not self.light:
                    if fakeset:
                       self.fill_histos(row,'notIsoM',True,faketype="muonfake")
                       if self.WjetsEnrich(row):
                          self.fill_histos(row,'notIsoEnWjetsM',True,faketype="muonfake")
#                    self.fill_histos(row,'notIsoNotWeighted',False)

                    if row.jetVeto30==0:
                      self.fill_histos(row,'notIso0JetM',True,faketype="muonfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets0JetM',True,faketype="muonfake")
                    if row.jetVeto30==1:
                      self.fill_histos(row,'notIso1JetM',True,faketype="muonfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets1JetM',True,faketype="muonfake")
                    if row.jetVeto30==2:
                      self.fill_histos(row,'notIso2JetM',True,faketype="muonfake")
                      if self.WjetsEnrich(row):
                         self.fill_histos(row,'notIsoEnWjets2JetM',True,faketype="muonfake")
                      if((row.vbfMass < 550)):
                         self.fill_histos(row,'notIso2Jet_ggM',True,faketype="muonfake")
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjets2Jet_ggM',True,faketype="muonfake")
                      if((row.vbfMass >= 550)):
                         self.fill_histos(row,'notIso2Jet_vbfM',True,faketype="muonfake")
                         if self.WjetsEnrich(row):
                            self.fill_histos(row,'notIsoEnWjets2Jet_vbfM',True,faketype="muonfake")
                 if  row.jetVeto30==0:
                    # #if RUN_OPTIMIZATION:
                       # for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),row.tMtToPfMet_type1):
                    # #   for  i in optimizer.compute_regions_0jet(row.tPt, row.mPt, deltaPhi(row.mPhi,row.tPhi),abs(row.mDPhiToPfMet_type1),abs(row.tDPhiToPfMet_type1),row.tMtToPfMet_type1):
                    # #      tmp=os.path.join("ggNotIso",i)
                    # #      self.fill_histos(row,tmp,True)
                     if self.gg(row):
                           self.fill_histos(row,'ggNotIsoM',True,faketype="muonfake")
                           if (not self.light) and fakeset:
                              self.fill_histos(row,'ggNotIsoM1stUp',True,'muonfake',"1stUp")
                              self.fill_histos(row,'ggNotIsoM1stDown',True,'muonfake',"1stDown")
#                              self.fill_histos(row,'ggNotIsoM1stUp',True,"1stUp",faketype="muonfake")
#                              self.fill_histos(row,'ggNotIsoM1stDown',True,"1stDown",faketype="muonfake")
#                              self.fill_histos(row,'ggNotIsoM2ndUp',True,"2ndUp",faketype="muonfake")
#                              self.fill_histos(row,'ggNotIsoM2ndDown',True,"2ndDown",faketype="muonfake")
           #      if self.gg(row):
           #          self.fill_histos(row,'ggNotIso',True)
                 if row.jetVeto30==1:
                  #  # if RUN_OPTIMIZATION:
                  #  #    for  i in optimizer.compute_regions_1jet(row.tPt, row.mPt,row.tMtToPfMet_type1):
                  #  #      tmp=os.path.join("boostNotIso",i)
                  #  #       self.fill_histos(row,tmp,True)
                     if self.boost(row):
                           self.fill_histos(row,'boostNotIsoM',True,faketype="muonfake")
                           if (not self.light) and fakeset:
                              self.fill_histos(row,'boostNotIsoM1stUp',True,'muonfake',"1stUp")
                              self.fill_histos(row,'boostNotIsoM1stDown',True,'muonfake',"1stDown")
#                              self.fill_histos(row,'boostNotIsoM1stUp',True,"1stUp",faketype="muonfake")
#                              self.fill_histos(row,'boostNotIsoM1stDown',True,"1stDown",faketype="muonfake")
#                              self.fill_histos(row,'boostNotIsoM2ndUp',True,"2ndUp",faketype="muonfake")
#                              self.fill_histos(row,'boostNotIsoM2ndDown',True,"2ndDown",faketype="muonfake")
         #        if self.boost(row):
         #            self.fill_histos(row,'boostNotIso',True)
                 #if (row.jetVeto30>=2 and row.vbfJetVeto30 <= 0) :
                 if (row.jetVeto30==2) :
            #     #    if RUN_OPTIMIZATION:
            #     #       for  i in optimizer.compute_regions_2jet(row.tPt, row.mPt,row.tMtToPfMet_type1,row.vbfMass,row.vbfDeta):
            #     #          tmp=os.path.join("vbfNotIso",i)
            #     #          self.fill_histos(row,tmp,True)
                     if not self.light:
                        if self.vbf(row):
                           self.fill_histos(row,'vbfNotIsoM',True,faketype="muonfake")
                     if self.vbf_gg(row):
                    #    if row.vbfMass>100: 
                           self.fill_histos(row,'vbf_ggNotIsoM',True,faketype="muonfake")
                           if (not self.light) and fakeset:
                              self.fill_histos(row,'vbf_ggNotIsoM1stUp',True,'muonfake',"1stUp")
                              self.fill_histos(row,'vbf_ggNotIsoM1stDown',True,'muonfake',"1stDown")
#                              self.fill_histos(row,'vbf_ggNotIsoM1stUp',True,"1stUp",faketype="muonfake")
#                              self.fill_histos(row,'vbf_ggNotIsoM1stDown',True,"1stDown",faketype="muonfake")
#                              self.fill_histos(row,'vbf_ggNotIsoM2ndUp',True,"2ndUp",faketype="muonfake")
#                              self.fill_histos(row,'vbf_ggNotIsoM2ndDown',True,"2ndDown",faketype="muonfake")
                    #    else:
                    #       self.fill_histos(row,'boostNotIsoM',True,faketype="muonfake")
#                           if fakeset:
#                              self.fill_histos(row,'boostNotIsoM1stUp',True,"1stUp",faketype="muonfake")
#                              self.fill_histos(row,'boostNotIsoM1stDown',True,"1stDown",faketype="muonfake")
#                              self.fill_histos(row,'boostNotIsoM2ndUp',True,"2ndUp",faketype="muonfake")
#                              self.fill_histos(row,'boostNotIsoM2ndDown',True,"2ndDown",faketype="muonfake")

                     if self.vbf_vbf(row):
                           self.fill_histos(row,'vbf_vbfNotIsoM',True,faketype="muonfake")
                           if (not self.light) and fakeset:
                              self.fill_histos(row,'vbf_vbfNotIsoM1stUp',True,'muonfake',"1stUp")
                              self.fill_histos(row,'vbf_vbfNotIsoM1stDown',True,'muonfake',"1stDown")
#                              self.fill_histos(row,'vbf_vbfNotIsoM1stUp',True,"1stUp",faketype="muonfake")
#                              self.fill_histos(row,'vbf_vbfNotIsoM1stDown',True,"1stDown",faketype="muonfake")
#                              self.fill_histos(row,'vbf_vbfNotIsoM2ndUp',True,"2ndUp",faketype="muonfake")
#                              self.fill_histos(row,'vbf_vbfNotIsoM2ndDown',True,"2ndDown",faketype="muonfake")
    #        global Sysin
            self.Sysin=1
            if self.Sysin and (not self.is_data) :
                 sysneedI=['MESUp','MESDown','TESUp','TESDown','UESUp','UESDown']
                 basechannelsI=[(0,'gg'),(1,'boost'),(2,'vbf_gg'),(2,'vbf_vbf')]
                 basechannelsII=[(0,'ggNotIso'),(1,'boostNotIso'),(2,'vbf_ggNotIso'),(2,'vbf_vbfNotIso')]
                 basechannelsIII=[(0,'ggNotIsoM'),(1,'boostNotIsoM'),(2,'vbf_ggNotIsoM'),(2,'vbf_vbfNotIsoM')]
                 basechannelsIIII=[(0,'ggNotIsoMT'),(1,'boostNotIsoMT'),(2,'vbf_ggNotIsoMT'),(2,'vbf_vbfNotIsoMT')]
                 baseJESsys=["_CMS_JetEnUp","_CMS_JetEnDown","_CMS_JetAbsoluteFlavMapDown","_CMS_JetAbsoluteFlavMapUp","_CMS_JetAbsoluteMPFBiasDown","_CMS_JetAbsoluteMPFBiasUp","_CMS_JetAbsoluteScaleDown","_CMS_JetAbsoluteScaleUp","_CMS_JetAbsoluteStatDown","_CMS_JetAbsoluteStatUp","_CMS_JetFlavorQCDDown","_CMS_JetFlavorQCDUp","_CMS_JetFragmentationDown","_CMS_JetFragmentationUp","_CMS_JetPileUpDataMCDown","_CMS_JetPileUpDataMCUp","_CMS_JetPileUpPtBBDown","_CMS_JetPileUpPtBBUp","_CMS_JetPileUpPtEC1Down","_CMS_JetPileUpPtEC1Up","_CMS_JetPileUpPtEC2Down","_CMS_JetPileUpPtEC2Up","_CMS_JetPileUpPtHFDown","_CMS_JetPileUpPtHFUp","_CMS_JetPileUpPtRefDown","_CMS_JetPileUpPtRefUp","_CMS_JetRelativeBalDown","_CMS_JetRelativeBalUp","_CMS_JetRelativeFSRDown","_CMS_JetRelativeFSRUp","_CMS_JetRelativeJEREC1Down","_CMS_JetRelativeJEREC1Up","_CMS_JetRelativeJEREC2Down","_CMS_JetRelativeJEREC2Up","_CMS_JetRelativeJERHFDown","_CMS_JetRelativeJERHFUp","_CMS_JetRelativePtBBDown","_CMS_JetRelativePtBBUp","_CMS_JetRelativePtEC1Down","_CMS_JetRelativePtEC1Up","_CMS_JetRelativePtEC2Down","_CMS_JetRelativePtEC2Up","_CMS_JetRelativePtHFDown","_CMS_JetRelativePtHFUp","_CMS_JetRelativeStatECDown","_CMS_JetRelativeStatECUp","_CMS_JetRelativeStatFSRDown","_CMS_JetRelativeStatFSRUp","_CMS_JetRelativeStatHFDown","_CMS_JetRelativeStatHFUp","_CMS_JetSinglePionECALDown","_CMS_JetSinglePionECALUp","_CMS_JetSinglePionHCALDown","_CMS_JetSinglePionHCALUp","_CMS_JetTimePtEtaDown","_CMS_JetTimePtEtaUp"]
                 for i in sysneedI:
                     self.SetsysZero(row)
                     if 'Up' in i:
                        tmpname='self.Do'+i.split('Up',1)[0]
                        exec("%s = %d" % (tmpname,1))                      
                     if 'Down' in i:
                        tmpname='self.Do'+i.split('Down',1)[0]
                        exec("%s = %d" % (tmpname,2))                   
                     self.VariableCalculate(row) 
                  #   if self.DoMES==1:
                  #       print " %s   %f" %(i,self.collMass_type1_new)
                     if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                        for j in basechannelsI: 
                           if  row.jetVeto30==j[0]:
                               tmpname_2='self.'+j[1]+'(row)'
                               if eval(tmpname_2):
                                    self.fill_histos(row,j[1]+i,False)
                       #             print 'at line 1892 the name of the folder %s' %tmpname_2
                     if (not self.obj2_iso(row)) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                        for j in basechannelsII: 
                           if  row.jetVeto30==j[0]:
                               tmpname_2='self.'+j[1].split('Not',1)[0]+'(row)'
                               if eval(tmpname_2):
                                    self.fill_histos(row,j[1]+i,True)
                       #             print 'at line 1892 the name of the folder %s' %tmpname_2
                     if self.obj2_iso(row) and self.oppositesign(row) and (not self.obj1_iso(row)) and self.kinematics(row): 
                        for j in basechannelsIII: 
                           if  row.jetVeto30==j[0]:
                               tmpname_2='self.'+j[1].split('Not',1)[0]+'(row)'
                               if eval(tmpname_2):
                                    self.fill_histos(row,j[1]+i,True,faketype="muonfake")
                       #             print 'at line 1892 the name of the folder %s' %tmpname_2
                     if (not self.obj2_iso(row)) and self.oppositesign(row) and (not self.obj1_iso(row)) and self.kinematics(row): 
                        for j in basechannelsIIII: 
                           if  row.jetVeto30==j[0]:
                               tmpname_2='self.'+j[1].split('Not',1)[0]+'(row)'
                               if eval(tmpname_2):
                                    self.fill_histos(row,j[1]+i,True,faketype="mtfake")
                     #self.SetsysZero(row)
                     
                 for k in baseJESsys:
                     self.SetsysZero(row)
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
                     self.VariableCalculateJES(row,eval(tmpname_5),eval(tmpname_6))
#                     if k=='_CMS_JetPileUpPtEC1Down':
#                        print "mass collin %s  %f" %(k,self.collMass_type1_new)
                     if self.obj2_iso(row) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                        for j in basechannelsI: 
                           if  eval(tmpname_3)==j[0]:
                               tmpname_2='self.'+j[1]+'(row)'
                               if ('vbf_gg' in j[1]):
                                   tmpname_4='row.vbfMass_'+k.split('_CMS_',1)[1]
                                   if eval(tmpname_2) and eval(tmpname_4)<550:
                                      self.fill_histos(row,j[1]+k,False)
                               elif ('vbf_vbf' in j[1]):
                                   tmpname_4='row.vbfMass_'+k.split('_CMS_',1)[1]
                                   if eval(tmpname_2) and eval(tmpname_4)>=550:
                                      self.fill_histos(row,j[1]+k,False)
                               else:
                                   if  eval(tmpname_2):
                                       self.fill_histos(row,j[1]+k,False)
                     if (not self.obj2_iso(row)) and self.oppositesign(row) and self.obj1_iso(row) and self.kinematics(row): 
                        for j in basechannelsII: 
                           if  eval(tmpname_3)==j[0]:
                               tmpname_2='self.'+j[1].split('Not',1)[0]+'(row)'
                               if ('vbf_gg' in j[1]):
                                   tmpname_4='row.vbfMass_'+k.split('_CMS_',1)[1]
                                   if eval(tmpname_2) and eval(tmpname_4)<550:
                                      self.fill_histos(row,j[1]+k,True)
                               elif ('vbf_vbf' in j[1]):
                                   tmpname_4='row.vbfMass_'+k.split('_CMS_',1)[1]
                                   if eval(tmpname_2) and eval(tmpname_4)>=550:
                                      self.fill_histos(row,j[1]+k,True)
                               else:
                                   if  eval(tmpname_2):
                                       self.fill_histos(row,j[1]+k,True)
                     if self.obj2_iso(row) and self.oppositesign(row) and (not self.obj1_iso(row)) and self.kinematics(row): 
                        for j in basechannelsIII: 
                           if  eval(tmpname_3)==j[0]:
                               tmpname_2='self.'+j[1].split('Not',1)[0]+'(row)'
                               if ('vbf_gg' in j[1]):
                                   tmpname_4='row.vbfMass_'+k.split('_CMS_',1)[1]
                                   if eval(tmpname_2) and eval(tmpname_4)<550:
                                      self.fill_histos(row,j[1]+k,True,faketype="muonfake")
                               elif ('vbf_vbf' in j[1]):
                                   tmpname_4='row.vbfMass_'+k.split('_CMS_',1)[1]
                                   if eval(tmpname_2) and eval(tmpname_4)>=550:
                                      self.fill_histos(row,j[1]+k,True,faketype="muonfake")
                               else:
                                   if  eval(tmpname_2):
                                       self.fill_histos(row,j[1]+k,True,faketype="muonfake")
                     if (not self.obj2_iso(row)) and self.oppositesign(row) and (not self.obj1_iso(row)) and self.kinematics(row): 
                        for j in basechannelsIIII: 
                           if  eval(tmpname_3)==j[0]:
                               tmpname_2='self.'+j[1].split('Not',1)[0]+'(row)'
                               if ('vbf_gg' in j[1]):
                                   tmpname_4='row.vbfMass_'+k.split('_CMS_',1)[1]
                                   if eval(tmpname_2) and eval(tmpname_4)<550:
                                      self.fill_histos(row,j[1]+k,True,faketype="mtfake")
                               elif ('vbf_vbf' in j[1]):
                                   tmpname_4='row.vbfMass_'+k.split('_CMS_',1)[1]
                                   if eval(tmpname_2) and eval(tmpname_4)>=550:
                                      self.fill_histos(row,j[1]+k,True,faketype="mtfake")
                               else:
                                   if  eval(tmpname_2):
                                       self.fill_histos(row,j[1]+k,True,faketype="mtfake")

            self.SetsysZero(row)
            sel=True

    def finish(self):
        self.write_histos()