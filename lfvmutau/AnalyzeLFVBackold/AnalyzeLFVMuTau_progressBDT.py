'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW, Fanbo Meng,ND

'''
import array
import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import weightBDT
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
#import FinalStateAnalysis.TagAndProbe.H2TauCorrections as H2TauCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import ROOT
import math
import optimizer_new 
#import optimizerdetastudy
from math import sqrt, pi
import itertools
import bTagSF
from RecoilCorrector import RecoilCorrector
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
MetCorrection=False#True
systematic = 'none'
#wjets_fakes=True
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
def invert_case(letter):
    if letter.upper() == letter: #capital
        return letter.lower()
    else: #low case
        return letter.upper()
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



def getGenMfakeTSF(ABStEta):
    if (ABStEta>0 and ABStEta<0.4):
       return 1.470
    if (ABStEta>0.4 and ABStEta<0.8):
       return 1.367
    if (ABStEta>0.8 and ABStEta<1.2):
       return 1.251
    if (ABStEta>1.2 and ABStEta<1.7):
       return 1.770
    if (ABStEta>1.7 and ABStEta<2.3):
       return 1.713


def getFakeRateFactorAaron(row, fakeset):
     if fakeset=="def":
        if  row.tDecayMode==0:
            fTauIso=0.234031-0.00630148*row.tEta+0.0248232*row.tEta*row.tEta+0.00433983*row.tEta*row.tEta*row.tEta-0.00130667*row.tEta*row.tEta*row.tEta*row.tEta
        if  row.tDecayMode==1:
            fTauIso=0.219639+0.00385837*row.tEta+0.0395008*row.tEta*row.tEta-0.0000849526*row.tEta*row.tEta*row.tEta-0.00655422*row.tEta*row.tEta*row.tEta*row.tEta
        if  row.tDecayMode==10:
            fTauIso=0.164348-0.00489196*row.tEta-0.0166164*row.tEta*row.tEta+0.00293241*row.tEta*row.tEta*row.tEta+0.00587287*row.tEta*row.tEta*row.tEta*row.tEta
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


def getFakeRateFactormuon(row, fakeset):   #Ptbined
    if fakeset=="def":
       if row.mPt>=35 and row.mPt<45:
          fTauIso=0.87037
       if row.mPt>=45 and row.mPt<55:
          fTauIso=0.91954
       if row.mPt>=55 and row.mPt<75:
          fTauIso=0.925926
       if row.mPt>=75 and row.mPt<100:
          fTauIso=0.959459
       if row.mPt>=100 :#and row.mPt<200:
          fTauIso=0.97561
    fakeRateFactor = fTauIso/(1.0-fTauIso)
    return fakeRateFactor
def getFakeRateFactormuonEta(row, fakeset):   #old
     if fakeset=="def":
            #fTauIso=0.78183+0.000617981*row.tEta+0.00568672*row.tEta*row.tEta
            fTauIso=0.870968+0.0268453*row.tEta+0.0101171*row.tEta*row.tEta-0.00704735*row.tEta*row.tEta*row.tEta+0.000158901*row.tEta*row.tEta*row.tEta*row.tEta
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
        'inputs', os.environ['jobid'], 'data_SingleMu*pu.root'))
pu_corrector = PileupWeight.PileupWeight('MC_Spring16', *pu_distributions)

#muon_HTauTau_TriggerIso22_2016B= MuonPOGCorrections.make_muon_HTauTau_TriggerIso22_2016B()
muon_pog_TriggerIso22_2016B= MuonPOGCorrections.make_muon_pog_IsoMu22oIsoTkMu22_2016BCD()
muon_pog_PFTight_2016B = MuonPOGCorrections.make_muon_pog_PFTight_2016BCD()
#muon_pog_PFTight_2016B = MuonPOGCorrections.make_muon_pog_PFMedium_2016BCD()
#muon_pog_Tracking_2016B = MuonPOGCorrections.make_muon_pog_Tracking_2016BCD()
#muon_pog_Tracking_2016B = MuonPOGCorrections.mu_trackingEta_2016()
muon_pog_TightIso_2016B = MuonPOGCorrections.make_muon_pog_TightIso_2016BCD()

def mc_corrector_2016(row):
  pu = pu_corrector(row.nTruePU)
  m1id =muon_pog_PFTight_2016B(row.mPt,abs(row.mEta))
 # m1tracking =muon_pog_Tracking_2016B(row.mPt,row.mEta)
  m1tracking =MuonPOGCorrections.mu_trackingEta_2016(row.mEta)[0]
#  print m1tracking
  m_trgiso22=muon_pog_TriggerIso22_2016B(row.mPt,abs(row.mEta))
  m1iso =muon_pog_TightIso_2016B('Tight',row.mPt,abs(row.mEta))
#  m1iso =muon_pog_TightIso_2016B('Medium',row.mPt,abs(row.mEta))
  
#  print "in the analyzer muon trigger"
 # print "Pt value %f   eta value %f    efficiency %f" %(row.mPt,row.mEta,m_trgiso22)
  #print "pu"
  #print str(pu)
  #return pu*m1id*m1iso*m_trg
  return pu*m1id*m1iso*m1tracking*m_trgiso22
#  return pu*m1id**m1tracking*m_trgiso22
 # return pu*m1id*m1iso
 # return m1id*m1iso*m_trg

mc_corrector = mc_corrector_2016

class AnalyzeLFVMuTau_progressBDT(MegaBase):
    tree = 'mt/final/Ntuple'
    #tree = 'New_Tree'

    def __init__(self, tree, outfile, **kwargs):
        super(AnalyzeLFVMuTau_progressBDT, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        target = os.path.basename(os.environ['megatarget'])
        self.ls_recoilC=((('HTo' in target) or ('Jets' in target)) and MetCorrection) 
        if self.ls_recoilC and MetCorrection:
           self.Metcorected=RecoilCorrector("TypeIPFMET_2016BCD.root")
        
#        print "the target is ***********    %s"    %target
#        WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8.root
        self.weighttarget=target.split(".",1)[0].replace("-","_")
        self.is_data = target.startswith('data_')
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
        self.is_DY= ('DY' in target)
        self.is_HToTauTau= ('HToTauTau' in target)
        self.is_HToMuTau= ('HToMuTau' in target)
        self.is_mc = not (self.is_data or self.is_embedded)
        self.tree = MuTauTree.MuTauTree(tree)
        self.out = outfile
        self.branches="mPt_/F:tPt_/F:mEta_/F:tEta_/F:mMtToPfMet_type1_/F:tMtToPfMet_type1_/F:tDPhiToPfMet_type1_/F:mDPhiToPfMet_type1_/F:type1_pfMetEt_/F:jetVeto30_/F:vbfDeta_/F:vbfMass_/F:m_t_collinearmass_/F:weight_/F:deltaeta_m_t_/F:m_t_DPhi_/F:lepton_asymmetry_/F:DZeta_/F"
        self.histograms = {}
        self.holders = []
        if ("LFV_HToMuTau" in target ):
           self.name="TreeS"
           self.title="TreeS"
        else:
           self.name="TreeB"
           self.title="TreeB"
        
#        if self.ls_DY or self.ls_ZTauTau:
#           self.Z_weigthcorrection()
#           self.Z_reweight = ROOT.TFile.Open('zpt_weights_2016.root')
#           self.Z_reweight_H=self.Z_reweight.Get('zptmass_histo')
       # self.newfile = ROOT.TFile.Open(target,'recreate')
        #print "the new output file is %s" %(target)
        self.branch_names = self.branches.split(':')
        self.tree1 = ROOT.TTree(self.name, self.title)

    def begin(self):
        for name in self.branch_names:
            try:
                varname, vartype = tuple(name.split('/'))
            except:
                raise ValueError('Problem parsing %s' % name)
            inverted_type = invert_case(vartype.rsplit("_",1)[0])
            self.holders.append( (varname, array.array(inverted_type,[0]) ) )

        #just to make sure that python does not mess up with addresses while loading a list
        for name, varinfo in zip(self.branch_names, self.holders):
            varname, holder = varinfo
            self.tree1.Branch(varname, holder, name)
#            print "Book trees?"
       # self.book('treelev',"counts", "Event counts", 10, 0, 5)
#        self.book('',"jetPt", "Event counts", 10, 0, 5)
# decay mode       names=["preselection","preselectionSS", "notIso","notIsoNotWeightedSS","notIsoSS","gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","notIsoNotWeighted","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","ggTD0","ggTD1","ggTD10","boostTD0","boostTD1","boostTD10","vbfTD0","vbfTD1","vbfTD10"]
# moremal full      names=["preselection","preselectionSS", "notIso","notIsoNotWeightedSS","notIsoSS","gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","notIsoNotWeighted","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
#cancled channals "preselection","preselectionSS", "notIso","notIsoNotWeightedSS","notIsoSS","notIsoNotWeighted"
        if fakeset  :
           names=["preselection"]
        if (not fakeset) and (not wjets_fakes) :
           #names=["gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
           names=["gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
        if wjets_fakes  :
           names=["preselection","notIso","preselectionSS","notIsoSS","gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","Wmunu_preselection0Jet","Wtaunu_preselection0Jet","W2jets_preselection0Jet","Wmunu_preselection1Jet","Wtaunu_preselection1Jet","W2jets_preselection1Jet","Wmunu_preselection2Jet","Wtaunu_preselection2Jet","W2jets_preselection2Jet","Wmunu_gg","Wtaunu_gg","W2jets_gg","Wmunu_boost","Wtaunu_boost","W2jets_boost","Wmunu_vbf_gg","Wtaunu_vbf_gg","W2jets_vbf_gg","Wmunu_vbf_vbf","Wtaunu_vbf_vbf","W2jets_vbf_vbf","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
        #namesize = len(names)
        #for x in range(0,namesize):


         #   self.book(names[x], "weight", "Event weight", 100, 0, 5)
         #   self.book(names[x], "counts", "Event counts", 10, 0, 5)
    def Z_weigthcorrection(self):
           Z_reweight = ROOT.TFile.Open('zpt_weights_2016.root')
           self.Z_reweight_H=Z_reweight.Get('zptmass_histo')
    def collMass_type1(self,row,metpx,metpy):
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
    def correction(self,row):
	return mc_corrector(row)
	
    def fakeRateMethod(self,row,fakeset,faketype):
        if faketype=="taufake":
           #return getFakeRateFactorAaron(row,fakeset)
           return getFakeRateFactor(row,fakeset)
        if faketype=="muonfake":
           return getFakeRateFactormuonEta(row,fakeset)
        if faketype=="mtfake":
           return getFakeRateFactormuonEta(row,fakeset)*getFakeRateFactor(row,fakeset)
       # return getFakeRateFactorAaron(row,fakeset)
	     
    def fill_histosup(self, row,name='gg', fakeRate=False, fakeset="def"):
        histos = self.histograms
        histos['counts'].Fill(1,1)
    def MetCorrectionSet(self,row):
           if not self.ls_Wjets:
              self.tmpMet=self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi),row.type1_pfMetEt*math.sin(row.type1_pfMetPhi),row.genpX,row.genpY,row.vispX,row.vispY,int(round(row.jetVeto30))+1)#,self.pfmetcorr_ex,self.pfmetcorr_ey)
           else:
              self.tmpMet=self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi),row.type1_pfMetEt*math.sin(row.type1_pfMetPhi),row.genpX,row.genpY,row.vispX,row.vispY,int(round(row.jetVeto30)))#,self.pfmetcorr_ex,self.pfmetcorr_ey)
           MetPt4=[math.sqrt(self.tmpMet[0]*self.tmpMet[0]+self.tmpMet[1]*self.tmpMet[1]),self.tmpMet[0],self.tmpMet[1],0]
           TauPt4=[row.tPt,row.tPt*math.cos(row.tPhi),row.tPt*math.sin(row.tPhi),0]
           MetPhi=math.atan2(self.tmpMet[1],self.tmpMet[0])
           self.TauDphiToMet=abs(row.tPhi-MetPhi)
           self.tMtToPfMet_type1MetC=transverseMass(MetPt4,TauPt4)
           self.collMass_type1MetC=self.collMass_type1(row,self.tmpMet[0],self.tmpMet[1])
#        if 
#          histos['jetPt'].Fill(1,1)
    def fill_histos(self, row,name='gg',fakeRate=False,faketype="taufake",fakeset="def"):
        histos = self.histograms
        #weight=bTagSF.bTagEventWeight(row.bjetCISVVeto20MediumZTT,row.jb1pt,row.jb1flavor,row.jb2pt,row.jb2flavor,1,btagSys,0)
        weight=1#bTagSF.bTagEventWeight(row.bjetCISVVeto20MediumZTT,row.jb1pt,row.jb1flavor,row.jb2pt,row.jb2flavor,1,btagSys,0)
        if (not(self.is_data)):
        #some difference from the btag stuff
	   #weight = row.GenWeight * self.correction(row)*bTagSF.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)*self.WeightJetbin(row)
	   weight =self.correction(row)*bTagSF.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)*self.WeightJetbin(row)

           #print bTagSF.bTagEventWeight(row.bjetCISVVeto20MediumZTT,row.jb1pt,row.jb1flavor,row.jb2pt,row.jb2flavor,1,btagSys,0)
#        if (fakeRate == True):
#          print self.fakeRateMethod(row,fakeset)
#          weight=weight*self.fakeRateMethod(row,fakeset,faketype) #apply fakerate method for given isolation definition
        if (self.is_ZTauTau or self.is_HToTauTau or self.is_HToMuTau):
          #weight=weight*0.83
          weight=weight*0.90
        if (self.is_DY and row.isZmumu  and row.tZTTGenMatching<5):
          weight=weight*getGenMfakeTSF(abs(row.tEta))
        if self.ls_DY or self.ls_ZTauTau:
           wtzpt=self.Z_reweight_H.GetBinContent(self.Z_reweight_H.GetXaxis().FindBin(row.genM),self.Z_reweight_H.GetYaxis().FindBin(row.genpT))
           weight=weight*wtzpt
           #print wtzpt
        if self.ls_recoilC and MetCorrection:
           histos[name+'/tMtToPfMet_type1'].Fill(self.tMtToPfMet_type1MetC,weight)
        else:
           histos[name+'/tMtToPfMet_type1'].Fill(row.tMtToPfMet_type1,weight)
        if self.ls_recoilC and MetCorrection: 
	   histos[name+'/tDPhiToPfMet_type1'].Fill(abs(self.TauDphiToMet),weight)
        else:
	   histos[name+'/tDPhiToPfMet_type1'].Fill(abs(row.tDPhiToPfMet_type1),weight)
        if self.ls_recoilC and MetCorrection: 
           histos[name+'/collMass_type1'].Fill(self.collMass_type1MetC,weight)
        else:
           histos[name+'/collMass_type1'].Fill(row.m_t_collinearmass,weight)
        


    def filltree(self,row,to_fill,fakeRate=False):
        '''Fills the tree, accepts an iterable or an object 
        with attributes as the branch names'''
        weight=1.0#bTagSF.bTagEventWeight(row.bjetCISVVeto20MediumZTT,row.jb1pt,row.jb1flavor,row.jb2pt,row.jb2flavor,1,btagSys,0)
        if (not(self.is_data)):
        #some difference from the btag stuff
	   weight = row.GenWeight * self.correction(row)*bTagSF.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)*self.WeightJetbin(row)
	#   weight =self.correction(row)*bTagSF.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)*self.WeightJetbin(row)

           #print bTagSF.bTagEventWeight(row.bjetCISVVeto20MediumZTT,row.jb1pt,row.jb1flavor,row.jb2pt,row.jb2flavor,1,btagSys,0)
        if (self.is_ZTauTau or self.is_HToTauTau or self.is_HToMuTau):
          #weight=weight*0.83
          weight=weight*0.90
#        if self.ls_DY or self.ls_ZTauTau:
#           wtzpt=self.Z_reweight_H.GetBinContent(self.Z_reweight_H.GetXaxis().FindBin(row.genM),self.Z_reweight_H.GetYaxis().FindBin(row.genpT))
#           weight=weight*wtzpt
        if (self.is_DY and row.isZmumu  and row.tZTTGenMatching<5):
          weight=weight*getGenMfakeTSF(abs(row.tEta))
        if weight<0:
           weight=0.0 
        #set_trace()
        if isinstance(to_fill, (tuple, list)):
            if len(to_fill) <> len(self.holders):
                raise ValueError('Not enough/ Too many values to fill!')
            for val_to_fill, holder_tuple in zip(to_fill, self.holders):
                try:
                    holder_tuple[1][0] = val_to_fill
                except OverflowError as e:
                    print "OverflowError detected! %s. Variable %s was fed with %s. It will be set to 0" % (e, holder_tuple[0], val_to_fill)
                    holder_tuple[1][0] = 0
        else:
            for varname, holder in self.holders:
              if varname!="weight_" and varname!="deltaeta_m_t_" and varname!="lepton_asymmetry_" and varname!="DZeta_":
                try:
                    holder[0] = abs(getattr(to_fill, varname.rsplit("_",1)[0]))
                except OverflowError as e:
                    print "OverflowError detected! %s. Variable %s was fed with %s. It will be set to 0" % (e, varname, getattr(to_fill, varname))
                    holder[0] = 0
              elif varname=="weight_": 
                 try:
                    holder[0] = weight
            #        print "the weight %f"   %(weight)
                 except OverflowError as e:
                    print "Problem of getting weights, the weight will be set to be 0"
                    holder[0] = 0 
              elif varname=="deltaeta_m_t_": 
                 try:
                    holder[0] = abs(row.mEta-row.tEta)
                 except OverflowError as e:
                    print "Problem of getting weights, the weight will be set to be 0"
                    holder[0] = 0 
              elif varname=="lepton_asymmetry_": 
                 try:
                    holder[0] = (row.mPt-row.tPt)/(row.mPt+row.tPt)
                 except OverflowError as e:
                    print "Problem of getting weights, the weight will be set to be 0"
                    holder[0] = 0 
              elif varname=="DZeta_": 
                 try:
                    holder[0] = (row.m_t_PZeta-1.85*row.m_t_PZetaLess0p85PZetaVis)
                 except OverflowError as e:
                    print "Problem of getting weights, the weight will be set to be 0"
                    holder[0] = 0 
             
        self.tree1.Fill()


    def presel(self, row):
       # if not (row.singleIsoMu20Pass or row.singleIsoTkMu20Pass):
        if not (row.singleIsoMu22Pass or row.singleIsoTkMu22Pass):
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
                 return  1.0/(eval("weightBDT."+"WJetsToLNu_TuneCUETP8M1_13TeV_madgraphMLM_pythia8")) 
              else:
                 return 1.0/(eval("weightBDT."+"W"+str(int(row.numGenJets))+"JetsToLNu_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
           if self.ls_ZTauTau:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightBDT."+"ZTauTauJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8")) 
              else: 
                 return 1.0/(eval("weightBDT."+"ZTauTau"+str(int(row.numGenJets))+"JetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
           if self.ls_DY:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightBDT."+"DYJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8")) 
              else: 
                 return 1.0/(eval("weightBDT."+"DY"+str(int(row.numGenJets))+"JetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
        else:
              return 1.0/(eval("weightBDT."+self.weighttarget))
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
        if row.mPt < 25:
            return False
        if abs(row.mEta) >= 2.3:
            return False
        if row.tPt<30 :
            return False
        if abs(row.tEta)>=2.3:
            return False
        return True

    def gg(self,row):
       if row.mPt < 25:   #was45     #newcuts 25 
           return False
#       if deltaPhi(row.mPhi, row.tPhi) <2.7:  # was 2.7    #new cut 2.7
#           return False
       if row.tPt < 30:  #was 35   #newcuts30
           return False
#       if row.tMtToPfMet_type1 > 105:  #was 50   #newcuts65
#           return False
       if self.ls_recoilC and MetCorrection:
          if self.tMtToPfMet_type1MetC > 105:  #was 50   #newcuts65
             return False
       else:
          if row.tMtToPfMet_type1 > 105:  #was 50   #newcuts65
             return False
#####       if abs(row.tDPhiToPfMet_type1)>3.0:
####           return False
       if self.ls_recoilC and MetCorrection:
          if abs(self.TauDphiToMet)>3.0:
             return False
       else:
          if abs(row.tDPhiToPfMet_type1)>3.0:
             return False
          
       if row.jetVeto30!=0:
           return False
#       if row.bjetCISVVeto30Loose:
#            return False
       return True

    def boost(self,row):
          if row.jetVeto30!=1:
            return False
          if row.mPt < 25:  #was 35    #newcuts 25
                return False
          if row.tPt < 30:  #was 40  #newcut 30
                return False
#          if row.tMtToPfMet_type1 > 105: #was 35   #newcuts 75
#                return False
          if self.ls_recoilC and MetCorrection:
             if self.tMtToPfMet_type1MetC > 105:  #was 50   #newcuts65
                return False
          else:
             if row.tMtToPfMet_type1 > 105:  #was 50   #newcuts65
                return False
#####          if abs(row.tDPhiToPfMet_type1)>3.0:
####              return False
          if self.ls_recoilC and MetCorrection:
             if abs(self.TauDphiToMet)>3.0:
                return False
          else:
             if abs(row.tDPhiToPfMet_type1)>3.0:
                return False
 #         if row.bjetCISVVeto30Loose:
 #               return False
          return True

    def vbf(self,row):
        if row.tPt < 30:   #was 40   #newcuts 30
                return False
        if row.mPt < 25:   #was 40    #newcut 25
       		return False
       # if row.tPt < 30:
       #         return False
       # if row.mPt < 30:
       # 	return False
        if row.tMtToPfMet_type1 > 75: #was 35   #newcuts 55
                return False
        if row.jetVeto30<2:  
            return False
	if(row.vbfNJets30<2):
	    return False
	if(abs(row.vbfDeta)<0.3):   #was 2.5    #newcut 2.0
	    return False
     #   if row.vbfMass < 200:    #was 200   newcut 325
#	    return False
        if row.vbfJetVeto30 > 0:
            return False
  #      if row.bjetCISVVeto30Medium:
  #          return False
        return True

    def vbf_gg(self,row):
        if row.tPt < 30:   #was 40   #newcuts 30
                return False
        if row.mPt < 25:   #was 40    #newcut 25
       		return False
   #     if row.tMtToPfMet_type1 > 105: #was 35   #newcuts 55
   #             return False
        if self.ls_recoilC and MetCorrection:
            if self.tMtToPfMet_type1MetC > 105:  #was 50   #newcuts65
               return False
        else:
            if row.tMtToPfMet_type1 > 105:  #was 50   #newcuts65
               return False
        if row.jetVeto30<2:  
            return False
	if(row.vbfNJets30<2):
	    return False
	if (abs(row.vbfDeta)>3.5 and row.vbfMass > 550):   #was 2.5    #newcut 2.0
	    return False
#        if row.vbfMass > 550:    #was 20   newcut 240
#	    return False
#        if row.vbfMass < 100:    #was 20   newcut 240
#	    return False
        if row.vbfJetVeto30 > 0:
            return False
#        if row.bjetCISVVeto30Medium:
#            return False
        return True
    def vbf_vbf(self,row):
        if row.tPt < 30:   #was 40   #newcuts 30
                return False
        if row.mPt < 25:   #was 40    #newcut 25
       		return False
  #      if row.tMtToPfMet_type1 > 85: #was 35   #newcuts 55
  #              return False
#        if self.tMtToPfMet_type1MetC > 85: #was 35   #newcuts 55
#                return False
        if self.ls_recoilC and MetCorrection:
            if self.tMtToPfMet_type1MetC > 85:  #was 50   #newcuts65
               return False
        else:
            if row.tMtToPfMet_type1 > 85:  #was 50   #newcuts65
               return False
        if row.jetVeto30<2:  
            return False
	if(row.vbfNJets30<2):
	    return False
	if(abs(row.vbfDeta)<3.5 or (row.vbfMass < 550)):   #was 2.5    #newcut 2.0
	    return False
#        if row.vbfMass > 240:    #was 200   newcut 325
#	    return False
        if row.vbfJetVeto30 > 0:
            return False
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
        return row.mIsGlobal and row.mIsPFMuon and (row.mNormTrkChi2<10) and (row.mMuonHits > 0) and (row.mMatchedStations > 1) and (row.mPVDXY < 0.02) and (row.mPVDZ < 0.5) and (row.mPixHits > 0) and (row.mTkLayersWithMeasurement > 5)

    def obj2_id(self, row):
	#return  row.tAgainstElectronMediumMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding
	return  row.tAgainstElectronVLooseMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding

    def vetos(self,row):
		return  (bool (row.muVetoPt5IsoIdVtx<1) and bool (row.eVetoMVAIso<1) and bool (row.tauVetoPt20Loose3HitsVtx<1) )

    #def obj1_iso(self, row):
    #    return bool(row.mRelPFIsoDBDefault <0.12)
   
    def obj1_iso(self,row):
         return bool(row.mRelPFIsoDBDefault <0.15)
    def obj1_isoloose(self,row):
         return bool(row.mRelPFIsoDBDefault <0.25)

  #  def obj2_iso(self, row):
  #      return  row.tByTightCombinedIsolationDeltaBetaCorr3Hits
  #  def obj2_iso(self, row):
  #      return  row.tByTightIsolationMVArun2v1DBoldDMwLT
    def obj2_iso(self, row):
        return  row.tByTightIsolationMVArun2v1DBoldDMwLT
    def obj2_iso_NT_VLoose(self, row):
        return  (not row.tByTightIsolationMVArun2v1DBoldDMwLT) and  row.tByVLooseIsolationMVArun2v1DBoldDMwLT

#    def obj2_mediso(self, row):
#	 return row.tByMediumCombinedIsolationDeltaBetaCorr3Hits
    def obj2_mediso(self, row):
	 return row.tByMediumIsolationMVArun2v1DBoldDMwLT

    def obj1_antiiso(self, row):
        return bool(row.mRelPFIsoDBDefault >0.2) 

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
            if self.is_data: 
               if not self.presel(row):
                  continue
#            if not self.selectZmm(row):
#                continue
            if not self.selectZtt(row):
                continue
         #   print "here  1111"
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
            if not self.kinematics(row): 
                continue
  #          if not self.obj2_Vlooseiso(row):
  #              continue 
            #if not self.obj1_isoloose(row):
            #    continue
            if not self.obj1_iso(row):
                continue
#            if not self.obj1_id(row):
#                continue
            if not self.obj1_idICHEP(row):
                continue
            if not self.vetos (row):
                continue
            if not self.obj2_iso(row):
                continue

            #if not self.obj2_Vlooseiso(row):
            #    continue
            #print "here  22222"
            if (self.is_data):
               if  row.bjetCISVVeto30Medium:
                   continue
            if not self.obj2_id (row):
                continue
#            if self.ls_recoilC and MetCorrection: 
#                self.MetCorrectionSet(row)
#            if abs(row.tGenPdgId)!=15 and abs(row.tGenPdgId)!=999:
#               print row.tGenPdgId
#            else: 
#               continue
            if row.jetVeto30>=2 and   (abs(row.vbfDeta)>3.5 and row.vbfMass > 550):
                continue
            if self.obj2_iso(row) and self.oppositesign(row):
                # print "here  33333"
                 #self.fill_histos(row,'preselection',False)
                 self.filltree(row,row)
            sel=True

    def finish(self):
        self.tree1.Write()
        self.write_histos()
