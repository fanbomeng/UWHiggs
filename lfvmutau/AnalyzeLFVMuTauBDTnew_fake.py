'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW, Fanbo Meng,ND

'''
from pdb import set_trace
import weightNormal
import warnings
import array
import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
from FinalStateAnalysis.PlotTools.pytree import PyTree
#import FinalStateAnalysis.TagAndProbe.H2TauCorrections as H2TauCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import ROOT
import math
import bTagSFrereco
#import optimizer_new 
#import optimizerdetastudy
from math import sqrt, pi
import itertools

#data=bool ('true' in os.environ['isRealData'])
#RUN_OPTIMIZATION=bool ('true' in os.environ['RUN_OPTIMIZATION'])
#RUN_OPTIMIZATION=True
RUN_OPTIMIZATION=False
btagSys=0
#ZTauTau = bool('true' in os.environ['isZTauTau'])
#ZeroJet = bool('true' in os.environ['isInclusive'])
#ZeroJet = False
#systematic = os.environ['systematic']
#fakeset= bool('true' in os.environ['fakeset'])
fakeset= False
#fakeset= True
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


def invert_case(letter):
    if letter.upper() == letter: #capital
        return letter.lower()
    else: #low case
        return letter.upper()

def getGenMfakeTSF(ABStEta):
    if (ABStEta>0 and ABStEta<0.4):
       return 1.425
    if (ABStEta>0.4 and ABStEta<0.8):
       return 1.72
    if (ABStEta>0.8 and ABStEta<1.2):
       return 1.26
    if (ABStEta>1.2 and ABStEta<1.7):
       return 2.59
    if (ABStEta>1.7 and ABStEta<2.3):
       return 2.29


def transverseMass_v2(p1,p2):    #one partical to Met possiblely
    # pvect[Et,px,py]
    totalEt2 = p1.Et() + p2.Et()
    totalPt2 = (p1+ p2).Pt()
    mt2 = totalEt2*totalEt2 - totalPt2*totalPt2
    return math.sqrt(abs(mt2))
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

def mc_corrector_2016(row):
  pu = pu_corrector(row.nTruePU)
  m1id =muon_pog_PFTight_2016B(row.mPt,abs(row.mEta))
 # m1tracking =muon_pog_Tracking_2016B(row.mPt,row.mEta)
  m1tracking =MuonPOGCorrections.mu_trackingEta_2016(abs(row.mEta))[0]
#  print m1tracking
  m_trgiso22=muon_pog_TriggerIso24_2016B(row.mPt,abs(row.mEta))
  m1iso =muon_pog_TightIso_2016B(row.mPt,abs(row.mEta))
  
#  print "in the analyzer muon trigger"
 # print "Pt value %f   eta value %f    efficiency %f" %(row.mPt,row.mEta,m_trgiso22)
  #print "pu"
  #print str(pu)
  #return pu*m1id*m1iso*m_trg
  #return pu*m1id*m1iso*m_trgiso22
  return pu*m1id**m1tracking*m_trgiso22
 # return pu*m1id*m1iso
 # return m1id*m1iso*m_trg

mc_corrector = mc_corrector_2016

class AnalyzeLFVMuTauBDTnew_fake(MegaBase):
    tree = 'mt/final/Ntuple'
    #tree = 'New_Tree'

    def __init__(self, tree, outfile, **kwargs):
        super(AnalyzeLFVMuTauBDTnew_fake, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        target = os.path.basename(os.environ['megatarget'])
      #  print "the target is ***********    %s"    %target
        self.weighttarget=target.split(".",1)[0].replace("-","_")
        self.is_data = target.startswith('data_')
        self.is_dataG_H =(bool('Run2016H' in target) or bool('Run2016G' in target))
     #   print "*************"
     #   print self.is_data
#        print "the target is *****************"
        self.filename=target.split('.')[0]
 #       print self.filename
        self.is_Wjets=("JetsToLNu" in target)
        self.is_Jets=('Jets' in target)
        self.is_ZeroJet=(('WJetsToLNu' in target)or('DYJetsToLL' in target)or('ZTauTauJetsToLL' in target))
        self.is_OneJet=('W1JetsToLNu' in target or('DY1JetsToLL' in target)or('ZTauTau1JetsToLL' in target))
        self.is_TwoJet=('W2JetsToLNu' in target or('DY2JetsToLL' in target)or('ZTauTau2JetsToLL' in target))
        self.is_ThreeJet=('W3JetsToLNu' in target or('DY3JetsToLL' in target)or('ZTauTau3JetsToLL' in target))
        self.is_FourJet=('W4JetsToLNu' in target or('DY4JetsToLL' in target)or('ZTauTau4JetsToLL' in target))
        self.is_embedded = ('Embedded' in target)
        self.is_ZTauTau= ('ZTauTau' in target)
        self.is_HToTauTau= ('HToTauTau' in target)
        self.is_HToMuTau= ('HToMuTau' in target)
        self.is_DY=("DY" in target)
        self.is_mc = not (self.is_data or self.is_embedded)
        self.tree = MuTauTree.MuTauTree(tree)
        self.out = outfile
    #    if self.is_DY or self.is_ZTauTau:
    #       self.Z_reweight = ROOT.TFile.Open('zpt_weights_2016.root')
    #       self.Z_reweight_H=self.Z_reweight.Get('zptmass_histo')
        self.histograms = {}
        self.branches="mPt_/F:tPt_/F:mEta_/F:tEta_/F:m_t_DPhi_/F:mMtToPfMet_type1_/F:tMtToPfMet_type1_/F:tDPhiToPfMet_type1_/F:mDPhiToPfMet_type1_/F:type1_pfMetEt_/F:jetVeto30_/F:vbfDeta_/F:vbfMass_/F:m_t_collinearmass_/F:weight_/F:deltaeta_m_t_/F:lepton_asymmetry_/F:m_t_PZeta_/F:m_t_PZetaVis_/F:m_t_Mass_/F"
        self.holders = []
        if ("LFV_HToMuTau" in target ):
           self.name="TreeS"
           self.title="TreeS"
        else:
           self.name="TreeB"
           self.title="TreeB"
    def begin(self):
        branch_names = self.branches.split(':')
        self.tree1 = ROOT.TTree(self.name, self.title)
        for name in branch_names:
            try:
                varname, vartype = tuple(name.split('/'))
            except:
                raise ValueError('Problem parsing %s' % name)
            inverted_type = invert_case(vartype.rsplit("_",1)[0])
            self.holders.append( (varname, array.array(inverted_type,[0]) ) )

        #just to make sure that python does not mess up with addresses while loading a list
        for name, varinfo in zip(branch_names, self.holders):
            varname, holder = varinfo
            self.tree1.Branch(varname, holder, name)
        self.book('treelev',"counts", "Event counts", 10, 0, 5)
#        self.book('',"jetPt", "Event counts", 10, 0, 5)
# decay mode       names=["preselection","preselectionSS", "notIso","notIsoNotWeightedSS","notIsoSS","gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","notIsoNotWeighted","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","ggTD0","ggTD1","ggTD10","boostTD0","boostTD1","boostTD10","vbfTD0","vbfTD1","vbfTD10"]
# moremal full      names=["preselection","preselectionSS", "notIso","notIsoNotWeightedSS","notIsoSS","gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","notIsoNotWeighted","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
#cancled channals "preselection","preselectionSS", "notIso","notIsoNotWeightedSS","notIsoSS","notIsoNotWeighted"
        if fakeset  :
           names=["preselection","notIso","preselectionSS","notIsoSS","gg","boost","vbf","ggNotIso","boostNotIso","ggNotIso1stUp","ggNotIso1stDown","boostNotIso1stUp","boostNotIso1stDown","ggNotIso2ndUp","ggNotIso2ndDown","boostNotIso2ndUp","boostNotIso2ndDown","vbfNotIso","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","vbf_ggNotIso1stUp","vbf_ggNotIso1stDown","vbf_vbfNotIso1stUp","vbf_vbfNotIso1stDown","vbf_ggNotIso2ndUp","vbf_ggNotIso2ndDown","vbf_vbfNotIso2ndUp","vbf_vbfNotIso2ndDown","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
        if (not fakeset) and (not wjets_fakes) :
           #names=["gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
           names=["preselection"]
           #names=["gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
        if wjets_fakes  :
           names=["preselection","notIso","preselectionSS","notIsoSS","gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","Wmunu_preselection0Jet","Wtaunu_preselection0Jet","W2jets_preselection0Jet","Wmunu_preselection1Jet","Wtaunu_preselection1Jet","W2jets_preselection1Jet","Wmunu_preselection2Jet","Wtaunu_preselection2Jet","W2jets_preselection2Jet","Wmunu_gg","Wtaunu_gg","W2jets_gg","Wmunu_boost","Wtaunu_boost","W2jets_boost","Wmunu_vbf_gg","Wtaunu_vbf_gg","W2jets_vbf_gg","Wmunu_vbf_vbf","Wtaunu_vbf_vbf","W2jets_vbf_vbf","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
           #names=["gg","boost","vbf","ggNotIso","boostNotIso","vbfNotIso","preselection0Jet", "preselection1Jet", "preselection2Jet","notIso0Jet", "notIso1Jet","notIso2Jet","vbf_gg","vbf_vbf","vbf_ggNotIso","vbf_vbfNotIso","IsoSS0Jet","IsoSS1Jet","IsoSS2Jet","ggIsoSS","boostIsoSS","vbfIsoSS","vbf_ggIsoSS","vbf_vbfIsoSS"]
        namesize = len(names)
	for x in range(0,namesize):


            self.book(names[x], "weight", "Event weight", 100, 0, 5)
            self.book(names[x], "counts", "Event counts", 10, 0, 5)

    def correction(self,row):
	return mc_corrector(row)

    def getFakeRateFactorFANBOPt(self,row, fakeset):
       #  if fakeset=="def":
       #     if  row.tDecayMode==0:
       #         fTauIso=0.23879-0.0007289*(self.tau_Pt_C-30)
       #     if  row.tDecayMode==1:
       #         fTauIso=0.235664-0.00076628*(self.tau_Pt_C-30)
       #     if  row.tDecayMode==10:
       #         fTauIso=0.188160-0.000534633*(self.tau_Pt_C-30)

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
         fakeRateFactor = fTauIso/(1.0-fTauIso)
         return fakeRateFactor
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
        fakeRateFactor = fTauIso/(1.0-fTauIso)
        return fakeRateFactor
    def TauESC(self,row):
        if (not self.is_data):
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
               tau_Pt_C=0
               MET_tPtC=0
        else:
               tau_Pt_C=row.tPt
               MET_tPtC=row.type1_pfMetEt
        return (tau_Pt_C,MET_tPtC)
    def collMass_type1_v2(self,row,muonlorenz,taulorenz,metpx,metpy):
            taupx=taulorenz.Px()
            taupy=taulorenz.Py()
            taupt=taulorenz.Pt()
    #        metE = row.type1_pfMetEt
    #   metPhi = row.type1_pfMetPhi
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

    def VariableCalculateTaucorrection(self,row):
           taulorenz=ROOT.TLorentzVector()
           muonlorenz=ROOT.TLorentzVector()
           metlorenz=ROOT.TLorentzVector()
           #print 'at line 871 the MES %f ' %self.DoMES
          # self.tmpHulaJES=(JESShiftedMet,JESShiftedPhi)
           taulorenz.SetPtEtaPhiM(self.tau_Pt_C,row.tEta,row.tPhi,row.tMass)
           muonlorenz.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass)
           metlorenz.SetPtEtaPhiM(self.MET_tPtC,0,row.type1_pfMetPhi,0)
           self.collMass_type1_new,self.m_t_Mass_new=self.collMass_type1_v2(row,muonlorenz,taulorenz,metlorenz.Px(),metlorenz.Py())
           self.tMtToPfMet_type1_new=transverseMass_v2(taulorenz,metlorenz)

#    def fakeRateMethod(self,row,fakeset='def'):
#        return self.getFakeRateFactorFANBOPt(row,fakeset)
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
    def filltree(self,row,to_fill,fakeRate=False,faketype="taufake",fakeset="def"):
        '''Fills the tree, accepts an iterable or an object 
        with attributes as the branch names'''
      #  self.filename
        weight =1.0# eval("weightNormal."+self.filename.replace("-","_"))
        if (not(self.is_data)):
           weight = row.GenWeight * self.correction(row)*bTagSFrereco.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1hadronflavor,row.jb2pt,row.jb2hadronflavor,1,btagSys,0)*self.WeightJetbin(row)
#           weight =weight*row.GenWeight * self.correction(row)*bTagSF.bTagEventWeight(row.bjetCISVVeto30Medium,row.jb1pt,row.jb1flavor,row.jb2pt,row.jb2flavor,1,btagSys,0) #apply gen and pu reweighting to MC
        if (fakeRate == True):
           weight=weight*self.fakeRateMethod(row,fakeset,faketype) #apply fakerate method for given isolation definition
        if (self.is_ZTauTau or self.is_HToTauTau or self.is_HToMuTau):
           weight=weight*0.95
        if (self.is_DY and row.isZmumu  and row.tZTTGenMatching<5):
          weight=weight*getGenMfakeTSF(abs(row.tEta))
        if weight<0:
           weight=0.0
#        if self.is_DY or self.is_ZTauTau:
#           wtzpt=self.Z_reweight_H.GetBinContent(self.Z_reweight_H.GetXaxis().FindBin(row.genM),self.Z_reweight_H.GetYaxis().FindBin(row.genpT))
#           weight=weight*wtzpt 
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
              if varname!="weight_" and varname!="deltaeta_m_t_" and varname!="lepton_asymmetry_" and varname!='tPt_' and varname!='tMtToPfMet_type1_' and varname!='type1_pfMetEt_' and varname!='m_t_collinearmass_' and varname!='m_t_Mass_':
                try:
                    holder[0] = abs(getattr(to_fill, varname.rsplit("_",1)[0]))
                except OverflowError as e:
                    print "OverflowError detected! %s. Variable %s was fed with %s. It will be set to 0" % (e, varname, getattr(to_fill, varname))
                    holder[0] = 0
              elif varname=="weight_": 
                 try:
                    holder[0] = weight
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
                    holder[0] = (row.mPt-self.tau_Pt_C)/(row.mPt+self.tau_Pt_C)
               #     print "comes here"
                 except OverflowError as e:
                    print "Problem of getting weights, the weight will be set to be 0"
                    holder[0] = 0 
              elif varname=="tPt_": 
                 try:
                    holder[0] =self.tau_Pt_C
               #     print "comes here"
                 except OverflowError as e:
                    print "Problem of getting weights, the weight will be set to be 0"
                    holder[0] = 0 
              elif varname=="tMtToPfMet_type1_": 
                 try:
                    holder[0] =self.tMtToPfMet_type1_new
                    #print "the tMtToPfMet before %f and after correction %f" %(row.tMtToPfMet_type1,self.tMtToPfMet_type1_new)
                   
                 except OverflowError as e:
                    print "Problem of getting weights, the weight will be set to be 0"
                    holder[0] = 0 
              elif varname=="type1_pfMetEt_": 
                 try:
                    holder[0] =self.MET_tPtC
               #     print "comes here"
                 except OverflowError as e:
                    print "Problem of getting weights, the weight will be set to be 0"
                    holder[0] = 0 
              elif varname=="m_t_collinearmass_": 
                 try:
                    holder[0] =self.collMass_type1_new
               #     print "comes here"
                 except OverflowError as e:
                    print "Problem of getting weights, the weight will be set to be 0"
                    holder[0] = 0 
              elif varname=="m_t_Mass_": 
                 try:
                    holder[0] =self.m_t_Mass_new
               #     print "comes here"
                 except OverflowError as e:
                    print "Problem of getting weights, the weight will be set to be 0"
                    holder[0] = 0 
       #       elif varname=="vbfDeta_":  
       #        if row.jetVeto30<2:
       #            holder[0] =-10
       #            print "comes here"
       #        else:
       #            holder[0] =row.vbfDeta 
       #       elif varname=="vbfMass_":
       #        if row.jetVeto30<2:
       #            holder[0] =-10
       #            print "comes here"
       #        else:
       #            holder[0] =row.vbfMass 
        self.tree1.Fill()
    def presel(self, row):
       # if not (row.singleIsoMu20Pass or row.singleIsoTkMu20Pass):
        if not (row.singleIsoMu24Pass or row.singleIsoTkMu24Pass):
            return   False
        return True 

    def selectZtt(self,row):
        if (self.is_ZTauTau and not row.isZtautau):
            return False
        if (not self.is_ZTauTau and row.isZtautau):
            return False
        return True
    def WeightJetbin(self,row):
        weighttargettmp=self.weighttarget
        if self.is_Jets:
           if row.numGenJets>4:
              print "Error***********************Error***********"
           if self.is_Wjets:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightNormal."+"WJetsToLNu_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
              else:
                 return 1.0/(eval("weightNormal."+"W"+str(int(row.numGenJets))+"JetsToLNu_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
           if self.is_ZTauTau:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightNormal."+"ZTauTauJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
              else:
                 return 1.0/(eval("weightNormal."+"ZTauTau"+str(int(row.numGenJets))+"JetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
           if self.is_DY:
              if row.numGenJets == 0:
                 return  1.0/(eval("weightNormal."+"DYJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
              else:
                 return 1.0/(eval("weightNormal."+"DY"+str(int(row.numGenJets))+"JetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8"))
        else:
              return 1.0/(eval("weightNormal."+self.weighttarget)) 
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
        if row.mPt < 26:
            return False
        if abs(row.mEta) >= 2.4:
            return False
        if self.tau_Pt_C<30 :
            return False
        if abs(row.tEta)>=2.3:
            return False
        return True

    def gg(self,row):
       if row.mPt < 25:   #was45     #newcuts 25 
           return False
       if deltaPhi(row.mPhi, row.tPhi) <2.7:  # was 2.7    #new cut 2.7
           return False
       if row.tPt < 30:  #was 35   #newcuts30
           return False
       if row.tMtToPfMet_type1 > 75:  #was 50   #newcuts65
           return False
       if abs(row.tDPhiToPfMet_type1)>3.0:
           return False
       if row.jetVeto30!=0:
           return False
     #  if row.bjetCISVVeto30Loose:
     #       return False
       return True

    def boost(self,row):
          if row.jetVeto30!=1:
            return False
          if row.mPt < 25:  #was 35    #newcuts 25
                return False
          if row.tPt < 30:  #was 40  #newcut 30
                return False
          if row.tMtToPfMet_type1 > 105: #was 35   #newcuts 75
                return False
          if abs(row.tDPhiToPfMet_type1)>3.0:
                return False
     #     if row.bjetCISVVeto30Loose:
     #           return False
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
	if(row.vbfNJets<2):
	    return False
	if(abs(row.vbfDeta)<0.3):   #was 2.5    #newcut 2.0
	    return False
     #   if row.vbfMass < 200:    #was 200   newcut 325
#	    return False
        if row.vbfJetVeto30 > 0:
            return False
     #   if row.bjetCISVVeto30Medium:
     #       return False
        return True

    def vbf_gg(self,row):
        if row.tPt < 30:   #was 40   #newcuts 30
                return False
        if row.mPt < 25:   #was 40    #newcut 25
                return False
        if row.tMtToPfMet_type1 > 105: #was 35   #newcuts 55
                return False
        if row.jetVeto30<2:
            return False
        if(row.vbfNJets30<2):
            return False
        if (abs(row.vbfDeta)>3.5 and row.vbfMass > 550):   #was 2.5    #newcut 2.0
            return False
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
        if row.tMtToPfMet_type1 > 75: #was 35   #newcuts 55
                return False
        if row.jetVeto30<2:  
            return False
	if(row.vbfNJets<2):
	    return False
	if(abs(row.vbfDeta)<3.2 or (row.vbfMass < 550)):   #was 2.5    #newcut 2.0
	    return False
#        if row.vbfMass > 240:    #was 200   newcut 325
#	    return False
        if row.vbfJetVeto30 > 0:
            return False
     #   if  row.bjetCISVVeto30Medium:
     #       return False
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
    def obj1_idM(self,row):

        goodglob=row.mIsGlobal and row.mNormalizedChi2 < 3 and row.mChi2LocalPosition < 12 and row.mTrkKink < 20
        isICHEPMedium = row.mPFIDLoose and row.mValidFraction> 0.8 and row.mSegmentCompatibility >  (0.303 if goodglob else 0.451);
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
         return bool(row.mRelPFIsoDBDefaultR04 <0.15)
    def obj1_isoloose(self,row):
         return bool(row.mRelPFIsoDBDefaultR04 <0.25)

  #  def obj2_iso(self, row):
  #      return  row.tByTightCombinedIsolationDeltaBetaCorr3Hits
  #  def obj2_iso(self, row):
  #      return  row.tByTightIsolationMVArun2v1DBoldDMwLT
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
         #   if self.is_data: 
            if not self.presel(row):
                continue
            if not self.selectZtt(row):
                continue
  #          if not self.obj2_Vlooseiso(row):
  #              continue 
            if not self.obj1_isoloose(row):
                continue
            #if not self.obj1_id(row):
            #    continue

            if self.is_dataG_H or (not self.is_data):
               if not self.obj1_idM(row):
                   continue
            else:
               if not self.obj1_idICHEP(row):
                   continue
            if not self.vetos (row):
                continue

            if not self.obj2_id (row):
                continue

            if not self.obj2_Vlooseiso(row):
                continue
            if self.is_data:
               if  row.bjetCISVVeto30Medium:
                   continue
            normaldecayfanbo=0
            if ((int(round(row.tDecayMode)))==0) or ((int(round(row.tDecayMode)))==1) or ((int(round(row.tDecayMode)))==10):
               normaldecayfanbo=1
            if not normaldecayfanbo:
               continue
            self.tau_Pt_C,self.MET_tPtC=self.TauESC(row)
            if not self.kinematics(row): 
                continue
            if row.vbfDeta<0 or row.vbfDeta>10 or row.vbfMass>7000 or row.vbfMass<0:
#                print "vbf variable ************** %f" %row.vbfDeta
                continue
           # if row.jetVeto30>=2 and   (abs(row.vbfDeta)>3.5 and row.vbfMass > 550):
           #     continue
            #if self.obj2_iso(row) and self.oppositesign(row):  
            self.VariableCalculateTaucorrection(row)
            if self.is_data:
               #if self.obj2_iso_NT_VLoose(row) and self.oppositesign(row):  
               if self.obj2_iso_NT_VLoose(row) and self.obj1_iso(row) and (not self.oppositesign(row)):  
                    #self.fill_histos(row,'preselection',False)
                    self.filltree(row,row,True)
          #     if (not self.obj1_iso(row)) and self.obj2_iso(row) and (not self.oppositesign(row)):  
          #        if (not (self.obj2_iso_NT_VLoose(row) and (not self.obj1_iso(row)))):  
                    #self.fill_histos(row,'preselection',False)
          #          print "anything in ????????????????????????????/"
          #          self.filltree(row,row,True,faketype="muonfake")
            if not self.is_data:
               if self.obj2_iso(row) and  self.obj1_iso(row)  and self.oppositesign(row):  
                    #self.fill_histos(row,'preselection',False)
                    self.filltree(row,row,False)
            sel=True

    def finish(self):
        self.tree1.Write()
      
        self.write_histos()