##Correction Factor still to add
from MMETree import MMETree
import os
import ROOT
import math
import optimizer
import glob
import array
import mcCorrections
import baseSelections as selections
import FinalStateAnalysis.PlotTools.pytree as pytree
from FinalStateAnalysis.PlotTools.decorators import  memo_last
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from math import sqrt, pi, sin, cos, acos, sinh
from cutflowtracker import cut_flow_tracker
#Makes the cut flow histogram
cut_flow_step = ['allEvents', 'e1sel', 'e1IDiso', 'e2sel', 'e2IDiso', 'ZMass', 'tsel', 'tAntiMuon', 'tAntiEle',  'MtToMet', 'tRawIso10','tRawIso5',  'tLooseIso', 'tTightIso' 
]

from inspect import currentframe

def get_linenumber():
    cf = currentframe()
    return cf.f_back.f_lineno

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
    

class EleFakeRateAnalyzerMVA(MegaBase):
    tree = 'emm/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        self.channel='MME'
        super(EleFakeRateAnalyzerMVA, self).__init__(tree, outfile, **kwargs)
        self.tree = MMETree(tree)
        self.out=outfile
        self.histograms = {}
        #self.pucorrector = mcCorrections.make_puCorrector('singlee')
        self.mye1 = 'e1'
        self.mye2 = 'e2'
        self.mye3 = 'e3'
        #optimizer_keys   = [ i for i in optimizer.grid_search.keys() if i.startswith(self.channel) ]
        self.grid_search = {}
        #if len(optimizer_keys) > 1:
        #    for key in optimizer_keys:
        #        self.grid_search[key] = optimizer.grid_search[key]
        #else:
        #    self.grid_search[''] = optimizer.grid_search[optimizer_keys[0]]


    def event_weight(self, row):
        if row.run > 2: #FIXME! add tight ID correction
            return 1.

 
        #if bool(row.e1MatchesEle27WP80) and  not bool(row.e2MatchesEle27WP80) : etrig = 'e1'
        #if not bool(row.e1MatchesEle27WP80) and  bool(row.e2MatchesEle27WP80) :  etrig = 'e2'
        ##return self.pucorrector(row.nTruePU) * \
        ##    mcCorrections.eid_correction( row, self.mye1, self.mye2, self.mye3) * \
        ##    mcCorrections.eiso_correction(row, self.mye1, self.mye2, self.mye3) * \
        ##    mcCorrections.trig_correction(row, self.mye3   )
        return 1.


    def ee3DR(self, row):
        mye1_mye3_dr = 100.
        mye2_mye3_dr = 100.
        try:        
            mye1_mye3_dr = getattr(row, self.mye1+'_'+self.mye3+'_DR')
        except AttributeError:
            mye1_mye3_dr =getattr(row, self.mye3+'_'+self.mye1+'_DR')
        try :
            mye2_mye3_dr = getattr(row, self.mye2+'_'+self.mye3+'_DR')
        except AttributeError:
            mye2_mye3_dr =getattr(row, self.mye3+'_'+self.mye2+'_DR')

        return mye1_mye3_dr  if mye1_mye3_dr  < mye2_mye3_dr else mye1_mye3_dr 

    def ee3DPhi(self, row):
        e1e3DPhi=deltaPhi(getattr(row, self.mye1+'Phi'), getattr(row, self.mye3+'Phi'))
        e2e3DPhi=deltaPhi(getattr(row, self.mye2+'Phi'), getattr(row, self.mye3+'Phi'))
        return e1e3DPhi if e1e3DPhi < e2e3DPhi else e2e3DPhi

    def Z(self, row):
        e1p=ROOT.TVector3(getattr(row, self.mye1+'Pt')*cos(getattr(row, self.mye1+'Phi')),getattr(row, self.mye1+'Pt')*sin(getattr(row, self.mye1+'Phi')),getattr(row, self.mye1+'Pt')*sin(getattr(row, self.mye1+'Eta')))
        e2p=ROOT.TVector3(getattr(row, self.mye2+'Pt')*cos(getattr(row, self.mye2+'Phi')),getattr(row, self.mye2+'Pt')*sin(getattr(row, self.mye2+'Phi')),getattr(row, self.mye2+'Pt')*sin(getattr(row, self.mye2+'Eta')))
        e1FourVector= ROOT.TLorentzVector(e1p, sqrt(e1p.Mag2()+pow(getattr(row, self.mye1+'Mass'),2)))
        e2FourVector= ROOT.TLorentzVector(e2p, sqrt(e2p.Mag2()+pow(getattr(row, self.mye2+'Mass'),2)))
        zFourVector = e1FourVector+e2FourVector
        return zFourVector




##add the trigger correction 

    def begin(self):
        
        eiso = ['eLoose', 'eTigh']
        folder = []
        sign = ['ss','os']
        for iso in eiso:
            for s in sign:
                folder.append(s+'/'+iso)
                j=0
                while j < 4 :
                    folder.append(s+'/'+iso+'/'+str(j))
                    j+=1
                    
        for f in folder: 
            
            ##self.book(f,"e1Pt", "e1 p_{T}", 200, 0, 200)
            ##self.book(f,"e1Phi", "e1 phi",  100, -3.2, 3.2)
            ##self.book(f,"e1Eta", "e1 eta", 46, -2.3, 2.3)
            ##
            ##self.book(f,"e2Pt", "e2 p_{T}", 200, 0, 200)
            ##self.book(f,"e2Phi", "e2 phi",  100, -3.2, 3.2)
            ##self.book(f,"e2Eta", "e2 eta", 46, -2.3, 2.3)

            self.book(f,"ePt", "e p_{T}", 200, 0, 200)
            ##self.book(f,"e3Phi", "e3 phi",  100, -3.2, 3.2)
            self.book(f,"eEta", "e eta", 46, -2.3, 2.3)
            self.book(f,"eAbsEta", "e abs eta", 23, 0, 2.3)
            self.book(f,"ePt_vs_eAbsEta", "e pt vs e abs eta", 23, 0, 2.3,  20, 0, 200.,  type=ROOT.TH2F)

            self.book(f, "m1m2Mass",  "m1m2 Inv Mass",  32, 0, 320)
            ##
            ##self.book(f, "e3MtToPFMET", "e3 Met MT", 100, 0, 100)
            ##
            ##
            ##self.book(f,"ee3DR", "e e3 DR", 50, 0, 10)
            ##self.book(f,"ee3DPhi", "e e3 DPhi", 32, 0, 3.2)
            ##
            ##self.book(f,"ze3DR", "Z e3 DR", 50, 0, 10)
            ##self.book(f,"ze3DPhi", "Z e3 DPhi", 32, 0, 3.2)
            ##self.book(f,"Zpt", "Z p_{T}", 200, 0, 200)
            ##
            ##
            ##
            ##self.book(f, "type1_pfMetEt", "type1_pfMetEt",200, 0, 200) 
            ##self.book(f, "jetN_30", "Number of jets, p_{T}>30", 10, -0.5, 9.5)
            ##self.book(f, "bjetCSVVeto30", "number of bjets", 10, -0.5, 9.5)

        for s in sign:
            self.book(s+'/tNoCuts', "CUT_FLOW", "Cut Flow", len(cut_flow_step), 0, len(cut_flow_step))
            
            xaxis = self.histograms[s+'/tNoCuts/CUT_FLOW'].GetXaxis()
            self.cut_flow_histo = self.histograms[s+'/tNoCuts/CUT_FLOW']
            self.cut_flow_map   = {}
            for i, name in enumerate(cut_flow_step):
                xaxis.SetBinLabel(i+1, name)
                self.cut_flow_map[name] = i+0.5
                    
    def fill_histos(self, row, folder='os/tSuperLoose', fakeRate = False):
        weight = self.event_weight(row)
        histos = self.histograms
 

        

        ##histos[folder+'/e1Pt'].Fill( getattr(row, self.mye1+'Pt'), weight)
        ##histos[folder+'/e1Eta'].Fill(getattr(row, self.mye1+'Eta'), weight)
        ##histos[folder+'/e1Phi'].Fill(getattr(row, self.mye1+'Phi'), weight) 
        ##
        ##histos[folder+'/e2Pt'].Fill( getattr(row, self.mye2+'Pt' ), weight)
        ##histos[folder+'/e2Eta'].Fill(getattr(row, self.mye2+'Eta'), weight)
        ##histos[folder+'/e2Phi'].Fill(getattr(row, self.mye2+'Phi'), weight)

        histos[folder+'/ePt'].Fill( row.ePt , weight)
        histos[folder+'/eEta'].Fill(row.eEta, weight)
        ##histos[folder+'/e3Phi'].Fill(getattr(row, self.mye3+'Phi'), weight)
        histos[folder+'/eAbsEta'].Fill(abs(row.eEta), weight)
        histos[folder+'/ePt_vs_eAbsEta'].Fill(abs(row.eEta), row.ePt, weight)

        histos[folder+'/m1m2Mass'].Fill(row.m1_m2_Mass, weight)
        ###histos[folder+'/tMtToPFMET'].Fill(row.tMtToPFMET,weight)
        ##
        ## 
        ##histos[folder+'/type1_pfMetEt'].Fill(row.type1_pfMet_Et)
        ##histos[folder+'/ee3DR'].Fill(self.ee3DR(row)) 
        ##histos[folder+'/ee3DPhi'].Fill(self.ee3DPhi(row)) 
        ##histos[folder+'/jetN_30'].Fill(row.jetVeto30, weight) 
        ##histos[folder+'/bjetCSVVeto30'].Fill(row.bjetCSVVeto30, weight) 
        ##
        ##histos[folder+'/ze3DR'].Fill(deltaR(self.Z(row).Phi(), getattr(row, self.mye3+'Phi'), self.Z(row).Eta(), getattr(row, self.mye3+'Eta')))
        ##histos[folder+'/ze3DPhi'].Fill(deltaPhi(self.Z(row).Phi(), getattr(row, self.mye3+'Phi')))
        ##histos[folder+'/Zpt'].Fill(self.Z(row).Pt())
            

    def process(self):
        
        cut_flow_histo = self.cut_flow_histo
        cut_flow_trk   = cut_flow_tracker(cut_flow_histo)
        myevent =()
        #print self.tree.inputfilename
        for row in self.tree:
            jn = row.jetVeto30
            if jn > 3 : jn = 3
            
            #if row.run > 2: 
            if not bool(row.doubleMuPass) : continue
            
            if row.bjetCISVVeto30Medium!=0 : continue 
            if row.m1Pt < 10 : continue
            if row.m2Pt < 10 : continue
            if row.ePt < 10 : continue
                       
#        for i, row in enumerate(self.tree):
#            if  i >= 100:
#                return
           # print bool(cut_flow_trk.disabled)
            cut_flow_trk.new_row(row.run,row.lumi,row.evt)
            #print row.run,row.lumi,row.evt
            cut_flow_trk.Fill('allEvents')
            if not selections.muSelection(row, 'm1'): continue
            cut_flow_trk.Fill('esel')
            if not selections.lepton_id_iso(row, 'm1', 'muId_idiso05'): continue
            
           
            
            cut_flow_trk.Fill('e1IDiso')
            if not selections.muSelection(row, 'm2'): continue
            cut_flow_trk.Fill('e2sel')
            if not selections.lepton_id_iso(row, 'm2', 'muId_idiso05'): continue
            if abs(row.m1_m2_Mass-91.2) > 20 : continue
       
                       
            if not selections.eSelection(row, 'e'): continue
            if not selections.lepton_id_iso(row, 'e', 'eid13Loose_idiso05'): continue 
            if abs(row.eEta) > 1.4442 and abs(row.eEta) < 1.566 : continue
          


            if row.tauVetoPt20Loose3HitsNewDMVtx : continue 
            if row.muVetoPt5IsoIdVtx : continue
            if row.eVetoMVAIso: continue
            #print row.m1Pt, row.m2Pt, row.ePt

            #if not row.e3MtToMET < 50:  continue
            cut_flow_trk.Fill('MtToMet')
            
            
            #if (row.run, row.lumi, row.evt, row.e1Pt, row.e2Pt)==myevent: continue
            #myevent=(row.run, row.lumi, row.evt, row.e1Pt, row.e2Pt)

            eleiso = 'eLoose'
            sign = 'ss' if row.m1_m2_SS else 'os'
            folder = sign+'/'+eleiso
          
            self.fill_histos(row, folder)
            folder=folder+'/'+str(int(jn))
            self.fill_histos(row, folder)
            
            if selections.lepton_id_iso(row, 'e', 'eid13Loose_etauiso01'):
                eleiso = 'eTigh' 
                folder = sign+'/'+eleiso
                self.fill_histos(row,  folder)
                cut_flow_trk.Fill('tTightIso')
                folder=folder+'/'+str(int(jn))
                self.fill_histos(row, folder)
                
                    
 
             
        cut_flow_trk.flush()
                                
             
            
    def finish(self):
        self.write_histos()