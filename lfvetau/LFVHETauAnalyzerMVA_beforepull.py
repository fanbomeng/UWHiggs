from ETauTree import ETauTree
import os
import ROOT
import math
import glob
import array
import mcCorrections
import baseSelections as selections
import FinalStateAnalysis.PlotTools.pytree as pytree
from FinalStateAnalysis.PlotTools.decorators import  memo_last
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from math import sqrt, pi, cos
from fakerate_functions import fakerate_central_histogram, fakerate_p1s_histogram, fakerate_m1s_histogram




def collmass(row, met, metPhi):
    ptnu =abs(met*cos(deltaPhi(metPhi, row.tPhi)))
    visfrac = row.tPt/(row.tPt+ptnu)
    #print met, cos(deltaPhi(metPhi, row.tPhi)), ptnu, visfrac
    return (row.e_t_Mass / sqrt(visfrac))

def deltaPhi(phi1, phi2):
    PHI = abs(phi1-phi2)
    if PHI<=pi:
        return PHI
    else:
        return 2*pi-PHI
def deltaR(phi1, ph2, eta1, eta2):
    deta = eta1 - eta2
    dphi = abs(phi1-phi2)
    if (dphi>pi) : dphi = 2*pi-dphi
    return sqrt(deta*deta + dphi*dphi);

class LFVHETauAnalyzerMVA(MegaBase):
    tree = 'et/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        self.channel='ET'
        super(LFVHETauAnalyzerMVA, self).__init__(tree, outfile, **kwargs)
        self.tree = ETauTree(tree)
        self.out=outfile
        self.histograms = {}
        self.pucorrector = mcCorrections.make_puCorrector('singlee')
        #self.pucorrectorUp = mcCorrections.make_puCorrectorUp('singlee')
       # self.pucorrectorDown = mcCorrections.make_puCorrectorDown('singlee')
        target = os.path.basename(os.environ['megatarget'])
        self.is_data = target.startswith('data_')
        self.is_embedded = ('Embedded' in target)
        self.is_mc = not (self.is_data or self.is_embedded)
    @staticmethod 
    def tau_veto(row):
        if not row.tAntiMuonLoose2 or not row.tAntiElectronMVA5Tight or not row.tDecayFinding :
            return False

    @staticmethod
    def obj1_matches_gen(row):
        return row.eGenPdgId == -1*row.eCharge*11
    @staticmethod 
    def obj3_matches_gen(row):
        return t.genDecayMode != -2 

    
    def event_weight(self, row):
        if self.is_data: #FIXME! add tight ID correction
            return [1.]

        allmcCorrections=    mcCorrections.get_electronId_corrections13_MVA(row, 'e') * \
                                 mcCorrections.get_electronIso_corrections13_MVA(row, 'e')
   #     trUp_mcCorrections = 1.
   #     trDown_mcCorrections = 1.
   #     eidUp_mcCorrections=  mcCorrections.get_electronId_corrections13_p1s_MVA(row, 'e') *\
   #                           mcCorrections.get_electronIso_corrections13_MVA(row, 'e') 
   #     eidDown_mcCorrections= mcCorrections.get_electronId_corrections13_m1s_MVA(row, 'e') * \
   #                            mcCorrections.get_electronIso_corrections13_MVA(row, 'e')
   #     eisoUp_mcCorrections=    mcCorrections.get_electronId_corrections13_MVA(row, 'e') * \
   #                              mcCorrections.get_electronIso_corrections13_p1s_MVA(row, 'e') 
   #     eisoDown_mcCorrections= mcCorrections.get_electronId_corrections13_m1s_MVA(row, 'e') * \
   #                             mcCorrections.get_electronIso_corrections13_p1s_MVA(row, 'e') 
  

        if self.is_embedded:
            allmcCorrections= allmcCorrections*mcCorrections.get_trigger_efficiency_MVA(row,'e') 
   #         trUp_mcCorrections =    allmcCorrections*mcCorrections.get_trigger_efficiency_p1s_MVA(row,'e') 
   #         trDown_mcCorrections  = allmcCorrections*mcCorrections.get_trigger_efficiency_m1s_MVA(row,'e') 
   #         eidUp_mcCorrections=  eidUp_mcCorrections*  mcCorrections.get_trigger_efficiency_MVA(row,'e') 
   #         eidDown_mcCorrections= eidDown_mcCorrections*  mcCorrections.get_trigger_efficiency_MVA(row,'e') 
   #         eisoUp_mcCorrections=   eisoUp_mcCorrections * mcCorrections.get_trigger_efficiency_MVA(row,'e') 
   #         eisoDown_mcCorrections= eisoDown_mcCorrections* mcCorrections.get_trigger_efficiency_MVA(row,'e') 
            
         #   return [allmcCorrections, allmcCorrections, allmcCorrections, trUp_mcCorrections, trDown_mcCorrections ,eidUp_mcCorrections, eidDown_mcCorrections, eisoUp_mcCorrections,eisoDown_mcCorrections]
            return [allmcCorrections, allmcCorrections, allmcCorrections,0,0 ,0,0,0,0]


            

                       
        else:
            allmcCorrections=    allmcCorrections * mcCorrections.get_trigger_corrections_MVA(row,'e') 
            
            
       #     trUp_mcCorrections =    allmcCorrections*  mcCorrections.get_trigger_corrections_p1s_MVA(row,'e') 
       #     trDown_mcCorrections =  allmcCorrections*  mcCorrections.get_trigger_corrections_m1s_MVA(row,'e') 
            
       #     eidUp_mcCorrections=  eidUp_mcCorrections*  mcCorrections.get_trigger_corrections_MVA(row,'e') 
       #     eidDown_mcCorrections= eidDown_mcCorrections*  mcCorrections.get_trigger_corrections_MVA(row,'e') 
       #     eisoUp_mcCorrections=   eisoUp_mcCorrections * mcCorrections.get_trigger_corrections_MVA(row,'e') 
       #     eisoDown_mcCorrections= eisoDown_mcCorrections* mcCorrections.get_trigger_corrections_MVA(row,'e') 
            
            #pucorrlist = self.pucorrector(row.nTruePU)
            
            weight =  self.pucorrector(row.nTruePU) *\
                      allmcCorrections
#----------------------------------------------------
        #    weight_up =  self.pucorrectorUp(row.nTruePU) *\
         #                allmcCorrections
         #   weight_down =  self.pucorrectorDown(row.nTruePU) *\
         #                  allmcCorrections
#-----------------------------------------------------------            
         #   weight_tr_up = self.pucorrector(row.nTruePU) *\
         #                  trUp_mcCorrections
         #   weight_tr_down = self.pucorrector(row.nTruePU) *\
         #                    trDown_mcCorrections
            
            
         #   weight_eid_up =  self.pucorrector(row.nTruePU) *\
         #                    eidUp_mcCorrections
         #   weight_eid_down =  self.pucorrector(row.nTruePU) *\
         #                      eidDown_mcCorrections
         #   weight_eiso_up =  self.pucorrector(row.nTruePU) *\
         #                   eisoUp_mcCorrections
         #   weight_eiso_down =  self.pucorrector(row.nTruePU) *\
         #                       eisoDown_mcCorrections
        
                    
           # return [weight, weight_up, weight_down, weight_tr_up,  weight_tr_down, weight_eid_up, weight_eid_down, weight_eiso_up,  weight_eiso_down]
           # return [weight, 0, 0, weight_tr_up,  weight_tr_down, weight_eid_up, weight_eid_down, weight_eiso_up,  weight_eiso_down]
            return [weight, 0, 0,0,0,0,0,0,0]


## 
    def begin(self):

        processtype=['gg']
        threshold=['ept30']
        sign=['os', 'ss']
        #jetN = ['0','0_jes_plus','0_jes_minus', '1','1_jes_plus','1_jes_minus', '2','2_jes_plus','2_jes_minus', '3','3_jes_plus','3_jes_minus']
        jetN = ['0','1','2','3']
        folder=[]
        pudir = ['','tLoose/', 'tLooseUnweight/']

        for d  in pudir :
            for i in sign:
                for j in processtype:
                    for k in threshold:
                        #folder.append(d+i+'/'+j+'/'+k)
                        for jn in jetN: 

                            folder.append(d+i+'/'+j+'/'+k +'/'+jn)
                            #folder.append(d+i+'/'+j+'/'+k +'/'+jn+'/selected')

          #  self.book(d+'os/gg/ept30/', "h_collmass_pfmet" , "h_collmass_pfmet",  32, 0, 320)
          #  self.book(d+'os/gg/ept30/', "h_vismass",  "h_vismass",  32, 0, 320)
            

                        
        for f in folder: 
            self.book(f,"tPtcut", "tPtcut", 100, 0, 100)
            self.book(f,"ePtcut", "ePtcut", 100, 0, 100)
            self.book(f,"deltaPhicut", "deltaPhicut", 35, 0,3.5)
            self.book(f,"tMtToPFMETcut", "tMtToPFMETcut", 200, 0, 200)
            self.book(f,"vbfMasscut", "vbfMasscut", 200, 0, 800)
            self.book(f,"vbfDetacut", "vbfDetacut",71 ,0.95,8.05)
    #        self.book(f,"tPt", "tau p_{T}", 200, 0, 200)
            #self.book(f,"tPhi", "tau phi", 100, -3.2, 3.2)
            #self.book(f,"tEta", "tau eta",  50, -2.5, 2.5)
            
    #        self.book(f,"ePt", "e p_{T}", 200, 0, 200)
    #        self.book(f,"tMtToPFMET", "tMtToPFMET", 100, 0, 500)
    #        self.book(f,"vbfMass", "vbfMass", 100, 0, 1000)
    #        self.book(f,"vbfDeta", "vbfDeta", 50, 0, 10)
            #self.book(f,"ePhi", "e phi",  100, -3.2, 3.2)
            #self.book(f,"eEta", "e eta", 50, -2.5, 2.5)
            
    #        self.book(f, "et_DeltaPhi", "e-tau DeltaPhi" , 50, 0, 3.2)
            #self.book(f, "et_DeltaR", "e-tau DeltaR" , 50, 0, 3.2)
            
    #        self.book(f, "h_collmass_pfmet",  "h_collmass_pfmet",  32, 0, 320)
    #        self.book(f, "h_collmass_mvamet",  "h_collmass_mvamet",  32, 0, 320)
    #        self.book(f, "h_collmass_pfmet_Ty1",  "h_collmass_pfmet_Ty1",  32, 0, 320)

         #   self.book(f, "h_collmass_pfmet_jes_plus", "h_collmass_pfmet_jes_plus", 50, 0, 100)
         #   self.book(f, "h_collmass_pfmet_mes_plus", "h_collmass_pfmet_mes_plus", 50, 0, 100 )
         #   self.book(f, "h_collmass_pfmet_tes_plus", "h_collmass_pfmet_tes_plus", 50, 0, 100)
         #   self.book(f, "h_collmass_pfmet_ees_plus", "h_collmass_pfmet_ees_plus", 50, 0, 100)
         #   self.book(f, "h_collmass_pfmet_ues_plus", "h_collmass_pfmet_ues_plus", 50, 0, 100)

         #   self.book(f, "h_collmass_pfmet_jes_minus", "h_collmass_pfmet_jes_minus", 50, 0, 100)
         #   self.book(f, "h_collmass_pfmet_mes_minus", "h_collmass_pfmet_mes_minus", 50, 0, 100 )
         #   self.book(f, "h_collmass_pfmet_tes_minus", "h_collmass_pfmet_tes_minus", 50, 0, 100)
         #   self.book(f, "h_collmass_pfmet_ees_minus", "h_collmass_pfmet_ees_minus", 50, 0, 100)
         #   self.book(f, "h_collmass_pfmet_ues_minus", "h_collmass_pfmet_ues_minus", 50, 0, 100)

         #   self.book(f, "h_collmassSpread_pfmet",  "h_collmassSpread_pfmet",  40, -100, 100)
         #   self.book(f, "h_collmassSpread_mvamet",  "h_collmassSpread_mvamet",  40, -100, 100)
         #   self.book(f, "h_collmassSpread_lowPhi_pfmet",  "h_collmassSpread_lowPhi_pfmet",  40, -100, 100)
         #   self.book(f, "h_collmassSpread_lowPhi_mvamet",  "h_collmassSpread_lowPhi_mvamet", 40, -100, 100)
         #   self.book(f, "h_collmassSpread_highPhi_pfmet",  "h_collmassSpread_highPhi_pfmet", 40, -100, 100)
         #   self.book(f, "h_collmassSpread_highPhi_mvamet",  "h_collmassSpread_highPhi_mvamet", 40, -100, 100)
         #   self.book(f, "h_collmass_lowPhi_pfmet",  "h_collmass_lowPhi_pfmet",  32, 0, 320)
         #   self.book(f, "h_collmass_lowPhi_mvamet",  "h_collmass_lowPhi_mvamet",  32, 0, 320)
         #   self.book(f, "h_collmass_highPhi_pfmet",  "h_collmass_highPhi_pfmet",  32, 0, 320)
         #   self.book(f, "h_collmass_highPhi_mvamet", "h_collmass_highPhi_mvamet",  32, 0, 320)
         #   self.book(f, "h_collmass_vs_dPhi_pfmet",  "h_collmass_vs_dPhi_pfmet", 50, 0, 3.2, 32, 0, 320, type=ROOT.TH2F)
         #   self.book(f, "h_collmass_vs_dPhi_mvamet",  "h_collmass_vs_dPhi_mvamet", 50, 0, 3.2, 32, 0, 320, type=ROOT.TH2F)
         #   self.book(f, "h_collmassSpread_vs_dPhi_pfmet",  "h_collmassSpread_vs_dPhi_pfmet", 50, 0, 3.2, 20, -100, 100, type=ROOT.TH2F)
         #   self.book(f, "h_collmassSpread_vs_dPhi_mvamet",  "h_collmassSpread_vs_dPhi_mvamet", 50, 0, 3.2, 20, -100, 100, type=ROOT.TH2F)
            
     #       self.book(f, "h_vismass",  "h_vismass",  32, 0, 320)
            
         #   self.book(f, "type1_pfMetEt_vs_dPhi", "PFMet vs #Delta#phi(#tau,PFMet)", 50, 0, 3.2, 64, 0, 320, type=ROOT.TH2F)
        #    self.book(f, "mvaMetEt_vs_dPhi", "MVAMet vs #Delta#phi(#tau,MVAMet)", 50, 0, 3.2, 64, 0, 320, type=ROOT.TH2F)

         #   self.book(f, "tPFMET_DeltaPhi", "tau-PFMET DeltaPhi" , 50, 0, 3.2)
         #   self.book(f, "tPFMET_Mt", "tau-PFMET M_{T}" , 200, 0, 200)
         #   self.book(f, "tPFMET_DeltaPhi_Ty1", "tau-type1PFMET DeltaPhi" , 50, 0, 3.2)
         #   self.book(f, "tPFMET_Mt_Ty1", "tau-type1PFMET M_{T}" , 200, 0, 200)
         #   self.book(f, 'tPFMET_Mt_jes_plus', "tau-MVAMET M_{T} JES_plus" , 200, 0, 200)
         #   self.book(f, 'tPFMET_Mt_mes_plus', "tau-MVAMET M_{T} JES_plus" , 200, 0, 200)
         #   self.book(f, 'tPFMET_Mt_ees_plus', "tau-MVAMET M_{T} JES_plus" , 200, 0, 200)
         #   self.book(f, 'tPFMET_Mt_tes_plus', "tau-MVAMET M_{T} JES_plus" , 200, 0, 200)
         #   self.book(f, 'tPFMET_Mt_ues_plus', "tau-MVAMET M_{T} JES_plus" , 200, 0, 200)

         #   self.book(f, 'tPFMET_Mt_jes_minus', "tau-MVAMET M_{T} JES_minus" , 200, 0, 200)
         #   self.book(f, 'tPFMET_Mt_mes_minus', "tau-MVAMET M_{T} JES_minus" , 200, 0, 200)
         #   self.book(f, 'tPFMET_Mt_ees_minus', "tau-MVAMET M_{T} JES_minus" , 200, 0, 200)
         #   self.book(f, 'tPFMET_Mt_tes_minus', "tau-MVAMET M_{T} JES_minus" , 200, 0, 200)
         #   self.book(f, 'tPFMET_Mt_ues_minus', "tau-MVAMET M_{T} JES_minus" , 200, 0, 200)
            
         #   self.book(f, "tMVAMET_DeltaPhi", "tau-MVAMET DeltaPhi" , 50, 0, 3.2)
         #   self.book(f, "tMVAMET_Mt", "tau-MVAMET M_{T}" , 200, 0, 200)
               
         #   self.book(f, "ePFMET_DeltaPhi_Ty1", "e-type1PFMET DeltaPhi" , 50, 0, 3.2)
         #   self.book(f, "ePFMET_Mt_Ty1", "e-type1PFMET M_{T}" , 200, 0, 200)
         #   self.book(f, "ePFMET_DeltaPhi", "e-PFMET DeltaPhi" , 50, 0, 3.2)
         #   self.book(f, "ePFMET_Mt", "e-PFMET M_{T}" , 200, 0, 200)
            #self.book(f, 'ePFMET_Mt_jes', "e-MVAMET M_{T} JES" , 200, 0, 200)
            #self.book(f, 'ePFMET_Mt_mes', "e-MVAMET M_{T} JES" , 200, 0, 200)
            #self.book(f, 'ePFMET_Mt_ees', "e-MVAMET M_{T} JES" , 200, 0, 200)
            #self.book(f, 'ePFMET_Mt_tes', "e-MVAMET M_{T} JES" , 200, 0, 200)
            #self.book(f, 'ePFMET_Mt_ues', "e-MVAMET M_{T} JES" , 200, 0, 200)
            #self.book(f, "ePFMET_Mt_Ty1_ues_minus", "e-type1PFMET M_{T} ues_minus" , 200, 0, 200)
            #self.book(f, "ePFMET_Mt_Ty1_ues_plus", "e-type1PFMET M_{T} ues_plus" , 200, 0, 200)
         #   self.book(f, 'ePFMET_Mt_jes_minus', "e-MVAMET M_{T} JES_minus" , 200, 0, 200)
         #   self.book(f, 'ePFMET_Mt_mes_minus', "e-MVAMET M_{T} JES_minus" , 200, 0, 200)
         #   self.book(f, 'ePFMET_Mt_ees_minus', "e-MVAMET M_{T} JES_minus" , 200, 0, 200)
         #   self.book(f, 'ePFMET_Mt_tes_minus', "e-MVAMET M_{T} JES_minus" , 200, 0, 200)
         #   self.book(f, 'ePFMET_Mt_ues_minus', "e-MVAMET M_{T} JES_minus" , 200, 0, 200)
         #   self.book(f, 'ePFMET_Mt_jes_plus', "e-MVAMET M_{T} JES_plus" , 200, 0, 200)
         #   self.book(f, 'ePFMET_Mt_mes_plus', "e-MVAMET M_{T} JES_plus" , 200, 0, 200)
         #   self.book(f, 'ePFMET_Mt_ees_plus', "e-MVAMET M_{T} JES_plus" , 200, 0, 200)
         #   self.book(f, 'ePFMET_Mt_tes_plus', "e-MVAMET M_{T} JES_plus" , 200, 0, 200)
         #   self.book(f, 'ePFMET_Mt_ues_plus', "e-MVAMET M_{T} JES_plus" , 200, 0, 200)

         #   self.book(f, "eMVAMET_DeltaPhi", "e-MVAMET DeltaPhi" , 50, 0, 3.2)
         #   self.book(f, "eMVAMET_Mt", "e-MVAMET M_{T}" , 200, 0, 200)
            
         #   self.book(f, "jetN_20", "Number of jets, p_{T}>20", 10, -0.5, 9.5) 
         #   self.book(f, "jetN_30", "Number of jets, p_{T}>30", 10, -0.5, 9.5) 

    def fakerate_weights(self, tEta, central_weights, p1s_weights, m1s_weights):
        frweight=[1.,1.,1.]

        #central_weights = fakerate_central_histogram(25,0, 2.5)
        #p1s_weights = fakerate_central_histogram(25,0, 2.5)
        #m1s_weights = fakerate_central_histogram(25,0, 2.5)

        for n,w in enumerate( central_weights ):
            if abs(tEta) < w[1]:
                break
            frweight[0] = w[0]
           # frweight[1] = p1s_weights[n][0]
           # frweight[2] = m1s_weights[n][0]
            frweight[1] =w[0]
            frweight[2] =w[0]
 
        
        return  frweight;

    
                    
    def fill_histos(self, row, f='os/gg/ept0/0',  isTauTight=False, frw=[1.,1.,1.]):
        weight = self.event_weight(row)
        histos = self.histograms
        pudir =['']
      #  if row.run < 2: pudir.extend( ['p1s/', 'm1s/', 'trp1s/', 'trm1s/', 'eidp1s/','eidm1s/',  'eisop1s/','eisom1s/'])
        looseList = ['tLoose/', 'tLooseUnweight/']
        
        
        if bool(isTauTight) == False:               
            if f.startswith('os') or  f.startswith('ss')  :
                frweight_bv = frw[0]/(1.-frw[0])
                err = 0.3/pow(1-frw[0], 2) #tau pog told to mu-tau group to use 30% uncertainty on tau fake rate.
           #     frweight_p1s = frweight_bv*(1+err)
           #     frweight_m1s = frweight_bv*(1-err)
                fr_weights = [frweight_bv, frweight_bv,frweight_bv]
            
                for n, l in enumerate(looseList) :
                    frweight = weight[0]*fr_weights[n] if n < len(looseList)-1  else weight[0]
                    folder = l+f

                    if f=='os/gg/ept30' :
                        histos[folder+'/h_collmass_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), row.EmbPtWeight*frweight)
                        histos[folder+'/h_vismass'].Fill(row.e_t_Mass, row.EmbPtWeight*frweight)
                        continue

                      #  self.book(f,"tMtToPFMET", "tMtToPFMET", 100, 0, 500)
                      #  self.book(f,"vbfMass", "vbfMass", 100, 0, 1000)
                      #  self.book(f,"vbfDeta", "vbfDeta", 50, 0, 10)
                    histos[folder+'/tMtToPFMET'].Fill(row.tMtToPFMET, frweight)
                    histos[folder+'/vbfMass'].Fill(row.vbfMass, frweight)
                    histos[folder+'/vbfDeta'].Fill(row.vbfDeta, frweight)
                    histos[folder+'/tPt'].Fill(row.tPt, frweight)
          #          histos[folder+'/tEta'].Fill(row.tEta, frweight)
          #          histos[folder+'/tPhi'].Fill(row.tPhi, frweight) 
                    histos[folder+'/ePt'].Fill(row.ePt, frweight)
          #          histos[folder+'/eEta'].Fill(row.eEta, frweight)
          #          histos[folder+'/ePhi'].Fill(row.ePhi, frweight)
                    histos[folder+'/et_DeltaPhi'].Fill(deltaPhi(row.ePhi, row.tPhi), frweight)
          #          histos[folder+'/et_DeltaR'].Fill(row.e_t_DR, frweight)
          #          histos[folder+'/h_collmass_vs_dPhi_pfmet'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), frweight)
          #          histos[folder+'/h_collmass_vs_dPhi_mvamet'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), collmass(row, row.mva_metEt, row.mva_metPhi), frweight)
          #          histos[folder+'/h_collmassSpread_vs_dPhi_pfmet'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, frweight)
          #          histos[folder+'/h_collmassSpread_vs_dPhi_mvamet'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, frweight)
          #          if deltaPhi(row.tPhi, row.pfMetPhi) > 1.57 :  
          #              histos[folder+'/h_collmass_highPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), frweight)
          #              histos[folder+'/h_collmassSpread_highPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, frweight)
          #          if deltaPhi(row.tPhi, row.pfMetPhi) < 1.57 :  
          #              histos[folder+'/h_collmass_lowPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), frweight)
          #              histos[folder+'/h_collmassSpread_lowPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, frweight)
          #          if deltaPhi(row.tPhi, row.mva_metPhi) > 1.57 :  
          #              histos[folder+'/h_collmass_highPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi), frweight)
          #              histos[folder+'/h_collmassSpread_highPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, frweight)
          #          if deltaPhi(row.tPhi, row.mva_metPhi) < 1.57 :  
          #              histos[folder+'/h_collmass_lowPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi), frweight)
          #              histos[folder+'/h_collmassSpread_lowPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, frweight)

          #          histos[folder+'/h_collmassSpread_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, frweight)
          #          histos[folder+'/h_collmassSpread_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, frweight)
                    histos[folder+'/h_collmass_pfmet'].Fill(collmass(row, row.pfMetEt, row.pfMetPhi), frweight)
                    histos[folder+'/h_collmass_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi), frweight)
                    histos[folder+'/h_collmass_pfmet_Ty1'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), frweight)

                    #histos[folder+'/h_collmass_pfmet_jes'].Fill(collmass(row, row.pfMet_jes_Et, row.pfMet_jes_Phi), frweight)
                    #histos[folder+'/h_collmass_pfmet_mes'].Fill(collmass(row, row.pfMet_mes_Et, row.pfMet_mes_Phi), frweight)
                    #histos[folder+'/h_collmass_pfmet_tes'].Fill(collmass(row, row.pfMet_tes_Et, row.pfMet_tes_Phi), frweight)
                    #histos[folder+'/h_collmass_pfmet_ees'].Fill(collmass(row, row.pfMet_ees_Et, row.pfMet_ees_Phi), frweight)
                    #histos[folder+'/h_collmass_pfmet_ues'].Fill(collmass(row, row.pfMet_ues_Et, row.pfMet_ues_Phi), frweight)
                    
                    
                    histos[folder+'/h_vismass'].Fill(row.e_t_Mass, frweight)
           #         histos[folder+'/type1_pfMetEt_vs_dPhi'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), row.type1_pfMetEt, frweight)
           #         histos[folder+'/mvaMetEt_vs_dPhi'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), row.mva_metEt, frweight)
                        
           #         histos[folder+'/ePFMET_DeltaPhi'].Fill(deltaPhi(row.ePhi, row.pfMetPhi), frweight)
           #         histos[folder+'/ePFMET_DeltaPhi_Ty1'].Fill(deltaPhi(row.ePhi, row.type1_pfMetPhi), frweight)
           #         histos[folder+'/eMVAMET_DeltaPhi'].Fill(deltaPhi(row.ePhi, row.mva_metPhi), frweight)
           #         histos[folder+'/ePFMET_Mt'].Fill(row.eMtToPFMET, frweight)
           #         histos[folder+'/ePFMET_Mt_Ty1'].Fill(row.eMtToPfMet_Ty1, frweight)
           #         histos[folder+'/eMVAMET_Mt'].Fill(row.eMtToMVAMET, frweight)
                    ##histos[folder+'/ePFMET_Mt_Ty1_ues_minus'].Fill(row.eMtToPfMet_Ty1_ues_minus, frweight)
                    ##histos[folder+'/ePFMET_Mt_Ty1_ues_plus'].Fill(row.eMtToPfMet_Ty1_ues_plus, frweight)
                    #histos[folder+'/ePFMET_Mt_jes_minus'].Fill(row.eMtToPfMet_jes_minus, frweight)
                    #histos[folder+'/ePFMET_Mt_jes_plus'].Fill(row.eMtToPfMet_jes_plus, frweight)
                    #histos[folder+'/ePFMET_Mt_jes'].Fill(row.eMtToPfMet_jes, frweight)
                    #histos[folder+'/ePFMET_Mt_mes_minus'].Fill(row.eMtToPfMet_mes_minus, frweight)
                    #histos[folder+'/ePFMET_Mt_mes_plus'].Fill(row.eMtToPfMet_mes_plus, frweight)
                    #histos[folder+'/ePFMET_Mt_mes'].Fill(row.eMtToPfMet_mes, frweight)
                    #histos[folder+'/ePFMET_Mt_ees_minus'].Fill(row.eMtToPfMet_ees_minus, frweight)
                    #histos[folder+'/ePFMET_Mt_ees_plus'].Fill(row.eMtToPfMet_ees_plus, frweight)
                    #histos[folder+'/ePFMET_Mt_ees'].Fill(row.eMtToPfMet_ees, frweight)
                    #histos[folder+'/ePFMET_Mt_tes_minus'].Fill(row.eMtToPfMet_tes_minus, frweight)
                    #histos[folder+'/ePFMET_Mt_tes_plus'].Fill(row.eMtToPfMet_tes_plus, frweight)
                    #histos[folder+'/ePFMET_Mt_tes'].Fill(row.eMtToPfMet_tes, frweight)
                    #histos[folder+'/ePFMET_Mt_ues_minus'].Fill(row.eMtToPfMet_ues_minus, frweight)
                    #histos[folder+'/ePFMET_Mt_ues_plus'].Fill(row.eMtToPfMet_ues_plus, frweight)
                    #histos[folder+'/ePFMET_Mt_ues'].Fill(row.eMtToPfMet_ues, frweight)

                    
                        
           #         histos[folder+'/tPFMET_DeltaPhi'].Fill(deltaPhi(row.tPhi, row.pfMetPhi), frweight)
           #         histos[folder+'/tPFMET_DeltaPhi_Ty1'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), frweight)
           #         histos[folder+'/tMVAMET_DeltaPhi'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), frweight)
           #         histos[folder+'/tPFMET_Mt'].Fill(row.tMtToPFMET, frweight)
           #         histos[folder+'/tMVAMET_Mt'].Fill(row.tMtToMVAMET, frweight)
                    #histos[folder+'/tPFMET_Mt_jes'].Fill(row.tMtToPfMet_jes, frweight)
                    #histos[folder+'/tPFMET_Mt_mes'].Fill(row.tMtToPfMet_mes, frweight)
                    #histos[folder+'/tPFMET_Mt_ees'].Fill(row.tMtToPfMet_ees, frweight)
                    #histos[folder+'/tPFMET_Mt_tes'].Fill(row.tMtToPfMet_tes, frweight)
                    #histos[folder+'/tPFMET_Mt_ues'].Fill(row.tMtToPfMet_ues, frweight)
                    
           #         histos[folder+'/jetN_20'].Fill(row.jetVeto20, frweight) 
           #         histos[folder+'/jetN_30'].Fill(row.jetVeto30, frweight) 
                    
        else: # if it is TauTight
            if not f.startswith('os') and not  f.startswith('ss') : # if the dir name start with mVeto, eVeto or tVeto I don't want the different weight of MC corrections
                pudir = ['']
                    
            for n,d  in enumerate(pudir) :
                if 'minus' in f  or 'plus' in f :
                    if n >0 : break
                    
                folder = d+f
                #print folder
                if f=='os/gg/ept30' :
                    histos[folder+'/h_collmass_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), row.EmbPtWeight*weight[n])
                    histos[folder+'/h_vismass'].Fill(row.e_t_Mass, row.EmbPtWeight*weight[n])
                    continue
                

                histos[folder+'/tMtToPFMET'].Fill(row.tMtToPFMET, weight[n])
                histos[folder+'/vbfMass'].Fill(row.vbfMass,  weight[n])
                histos[folder+'/vbfDeta'].Fill(row.vbfDeta,  weight[n])

                histos[folder+'/tPt'].Fill(row.tPt, weight[n])
            #    histos[folder+'/tEta'].Fill(row.tEta, weight[n])
            #    histos[folder+'/tPhi'].Fill(row.tPhi, weight[n]) 
                histos[folder+'/ePt'].Fill(row.ePt, weight[n])
            #    histos[folder+'/eEta'].Fill(row.eEta, weight[n])
            #    histos[folder+'/ePhi'].Fill(row.ePhi, weight[n])
                histos[folder+'/et_DeltaPhi'].Fill(deltaPhi(row.ePhi, row.tPhi), weight[n])
            #    histos[folder+'/et_DeltaR'].Fill(row.e_t_DR, weight[n])
                    
          #      histos[folder+'/h_collmass_vs_dPhi_pfmet'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), weight[n])
          #      histos[folder+'/h_collmass_vs_dPhi_mvamet'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), collmass(row, row.mva_metEt, row.mva_metPhi), weight[n])
          #      histos[folder+'/h_collmassSpread_vs_dPhi_pfmet'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, weight[n])
          #      histos[folder+'/h_collmassSpread_vs_dPhi_mvamet'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, weight[n])
          #      if deltaPhi(row.tPhi, row.pfMetPhi) > 1.57 :  
          #          histos[folder+'/h_collmass_highPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), weight[n])
          #          histos[folder+'/h_collmassSpread_highPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, weight[n])
          #      if deltaPhi(row.tPhi, row.pfMetPhi) < 1.57 :  
          #          histos[folder+'/h_collmass_lowPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), weight[n])
          #          histos[folder+'/h_collmassSpread_lowPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, weight[n])
          #      if deltaPhi(row.tPhi, row.mva_metPhi) > 1.57 :  
          #          histos[folder+'/h_collmass_highPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi), weight[n])
          #          histos[folder+'/h_collmassSpread_highPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, weight[n])
          #      if deltaPhi(row.tPhi, row.mva_metPhi) < 1.57 :  
          #          histos[folder+'/h_collmass_lowPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi), weight[n])
          #          histos[folder+'/h_collmassSpread_lowPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, weight[n])
          #      histos[folder+'/h_collmassSpread_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, weight[n])
          #      histos[folder+'/h_collmassSpread_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, weight[n])


                histos[folder+'/h_collmass_pfmet'].Fill(collmass(row, row.pfMetEt, row.pfMetPhi), weight[n])
                histos[folder+'/h_collmass_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi), weight[n])
                histos[folder+'/h_collmass_pfmet_Ty1'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), weight[n])
                
                    
                    
                histos[folder+'/h_vismass'].Fill(row.e_t_Mass, weight[n])
                
          #      histos[folder+'/type1_pfMetEt_vs_dPhi'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), row.type1_pfMetEt, weight[n])
          #      histos[folder+'/mvaMetEt_vs_dPhi'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), row.mva_metEt, weight[n])
                
          #      histos[folder+'/ePFMET_DeltaPhi'].Fill(deltaPhi(row.ePhi, row.type1_pfMetPhi), weight[n])
          #      histos[folder+'/ePFMET_DeltaPhi_Ty1'].Fill(deltaPhi(row.ePhi, row.type1_pfMetPhi), weight[n])
          #      histos[folder+'/eMVAMET_DeltaPhi'].Fill(deltaPhi(row.ePhi, row.mva_metPhi), weight[n])
                
          #      histos[folder+'/ePFMET_Mt'].Fill(row.eMtToPFMET, weight[n])
          #      histos[folder+'/ePFMET_Mt_Ty1'].Fill(row.eMtToPfMet_Ty1, weight[n])
          #      histos[folder+'/eMVAMET_Mt'].Fill(row.eMtToMVAMET, weight[n])
                
          #      histos[folder+'/tPFMET_DeltaPhi'].Fill(deltaPhi(row.tPhi, row.pfMetPhi), weight[n])
          #      histos[folder+'/tPFMET_DeltaPhi_Ty1'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), weight[n])
          #      histos[folder+'/tMVAMET_DeltaPhi'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), weight[n])
                
          #      histos[folder+'/tPFMET_Mt'].Fill(row.tMtToPFMET, weight[n])
          #      histos[folder+'/tPFMET_Mt_Ty1'].Fill(row.tMtToPfMet_Ty1, weight[n])
          #      histos[folder+'/tMVAMET_Mt'].Fill(row.tMtToMVAMET, weight[n])
                    
          #      histos[folder+'/jetN_20'].Fill(row.jetVeto20, weight[n]) 
          #      histos[folder+'/jetN_30'].Fill(row.jetVeto30, weight[n]) 
                

          #      if n == 0: # if I'm in the dir starting with os or ss I want also the energy scale uncertainties
          #          histos[folder+'/h_collmass_pfmet_jes_plus'].Fill(collmass(row, row.pfMet_jes_Et, row.pfMet_jes_plus_Phi), weight[n])
          #          histos[folder+'/h_collmass_pfmet_jes_minus'].Fill(collmass(row, row.pfMet_jes_Et, row.pfMet_jes_minus_Phi), weight[n])
                    ### add the minus in the ntuple.
                    #histos[folder+'/h_collmass_pfmet_mes_plus'].Fill(collmass(row, row.pfMet_mes_Et, row.pfMet_mes_Phi), weight[n])
                    #histos[folder+'/h_collmass_pfmet_tes_plus'].Fill(collmass(row, row.pfMet_tes_Et, row.pfMet_tes_Phi), weight[n])
                    #histos[folder+'/h_collmass_pfmet_ees_plus'].Fill(collmass(row, row.pfMet_ees_Et, row.pfMet_ees_Phi), weight[n])
                    #histos[folder+'/h_collmass_pfmet_ues_plus'].Fill(collmass(row, row.pfMet_ues_Et, row.pfMet_ues_Phi), weight[n])
                    
                    
          #          histos[folder+'/ePFMET_Mt_jes_minus'].Fill(row.eMtToPfMet_jes_minus, weight[n])
          #          histos[folder+'/ePFMET_Mt_jes_plus'].Fill(row.eMtToPfMet_jes_plus,   weight[n])
                    
          #          histos[folder+'/ePFMET_Mt_mes_minus'].Fill(row.eMtToPfMet_mes_minus,weight[n]) 
          #          histos[folder+'/ePFMET_Mt_mes_plus'].Fill(row.eMtToPfMet_mes_plus,  weight[n]) 
                    
          #          histos[folder+'/ePFMET_Mt_ees_minus'].Fill(row.eMtToPfMet_ees_minus,weight[n]) 
          #          histos[folder+'/ePFMET_Mt_ees_plus'].Fill(row.eMtToPfMet_ees_plus,  weight[n]) 
                    
          #          histos[folder+'/ePFMET_Mt_tes_minus'].Fill(row.eMtToPfMet_tes_minus,weight[n]) 
          #          histos[folder+'/ePFMET_Mt_tes_plus'].Fill(row.eMtToPfMet_tes_plus,  weight[n]) 
                    
          #          histos[folder+'/ePFMET_Mt_ues_minus'].Fill(row.eMtToPfMet_ues_minus,weight[n]) 
          #          histos[folder+'/ePFMET_Mt_ues_plus'].Fill(row.eMtToPfMet_ues_plus,  weight[n]) 
                        
          #          histos[folder+'/tPFMET_Mt_jes_plus'].Fill(row.tMtToPfMet_jes_plus,weight[n])
          #          histos[folder+'/tPFMET_Mt_mes_plus'].Fill(row.tMtToPfMet_mes_plus,weight[n])
          #          histos[folder+'/tPFMET_Mt_ees_plus'].Fill(row.tMtToPfMet_ees_plus,weight[n])
          #          histos[folder+'/tPFMET_Mt_tes_plus'].Fill(row.tMtToPfMet_tes_plus,weight[n])
          #          histos[folder+'/tPFMET_Mt_ues_plus'].Fill(row.tMtToPfMet_ues_plus,weight[n])
          #          histos[folder+'/tPFMET_Mt_jes_minus'].Fill(row.tMtToPfMet_jes_minus,weight[n])
          #          histos[folder+'/tPFMET_Mt_mes_minus'].Fill(row.tMtToPfMet_mes_minus,weight[n])
          #          histos[folder+'/tPFMET_Mt_ees_minus'].Fill(row.tMtToPfMet_ees_minus,weight[n])
          #          histos[folder+'/tPFMET_Mt_tes_minus'].Fill(row.tMtToPfMet_tes_minus,weight[n])
          #          histos[folder+'/tPFMET_Mt_ues_minus'].Fill(row.tMtToPfMet_ues_minus,weight[n])


    def fill_histos2(self, row,cutvalue,histoname,f='os/gg/ept0/0',  isTauTight=False, frw=[1.,1.,1.]):
        weight = self.event_weight(row)
        histos = self.histograms
        pudir =['']
      #  if row.run < 2: pudir.extend( ['p1s/', 'm1s/', 'trp1s/', 'trm1s/', 'eidp1s/','eidm1s/',  'eisop1s/','eisom1s/'])
        looseList = ['tLoose/', 'tLooseUnweight/']
        
        
        if bool(isTauTight) == False:               
            if f.startswith('os') or  f.startswith('ss')  :
                frweight_bv = frw[0]/(1.-frw[0])
                err = 0.3/pow(1-frw[0], 2) #tau pog told to mu-tau group to use 30% uncertainty on tau fake rate.
           #     frweight_p1s = frweight_bv*(1+err)
           #     frweight_m1s = frweight_bv*(1-err)
                fr_weights = [frweight_bv, frweight_bv,frweight_bv]
            
                for n, l in enumerate(looseList) :
                    frweight = weight[0]*fr_weights[n] if n < len(looseList)-1  else weight[0]
                    folder = l+f

                    if f=='os/gg/ept30' :
              #          histos[folder+'/h_collmass_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), row.EmbPtWeight*frweight)
              #          histos[folder+'/h_vismass'].Fill(row.e_t_Mass, row.EmbPtWeight*frweight)
                        continue

                      #  self.book(f,"tMtToPFMET", "tMtToPFMET", 100, 0, 500)
                      #  self.book(f,"vbfMass", "vbfMass", 100, 0, 1000)
                      #  self.book(f,"vbfDeta", "vbfDeta", 50, 0, 10)
                   # self.book(f,"tPtcut", "taupt_cut}", 100, 0, 100)
                  
         #           if(histoname=='tPtcut'):  histos[folder+'/tPtcut'].Fill(cutvalue,frweight)
         #           if(histoname=='ePtcut'): histos[folder+'/ePtcut'].Fill(cutvalue,frweight)
         #           if(histoname=='deltaPhicut'): histos[folder+'/deltaPhicut'].Fill(cutvalue,frweight)
         #           if(histoname=='tMtToPFMETcut'): histos[folder+'/tMtToPFMETcut'].Fill(cutvalue,frweight)
         #           if(histoname=='vbfMasscut'): histos[folder+'/vbfMasscut'].Fill(cutvalue,frweight)
         #           if(histoname=='vbfDetacut'): histos[folder+'/vbfDetacut'].Fill(cutvalue,frweight)
              #      histos[folder+'/tMtToPFMET'].Fill(row.tMtToPFMET, frweight)
              #      histos[folder+'/vbfMass'].Fill(row.vbfMass, frweight)
              #      histos[folder+'/vbfDeta'].Fill(row.vbfDeta, frweight)
              #      histos[folder+'/tPt'].Fill(row.tPt, frweight)
          #          histos[folder+'/tEta'].Fill(row.tEta, frweight)
          #          histos[folder+'/tPhi'].Fill(row.tPhi, frweight) 
              #      histos[folder+'/ePt'].Fill(row.ePt, frweight)
          #          histos[folder+'/eEta'].Fill(row.eEta, frweight)
          #          histos[folder+'/ePhi'].Fill(row.ePhi, frweight)
              #      histos[folder+'/et_DeltaPhi'].Fill(deltaPhi(row.ePhi, row.tPhi), frweight)
          #          histos[folder+'/et_DeltaR'].Fill(row.e_t_DR, frweight)
          #          histos[folder+'/h_collmass_vs_dPhi_pfmet'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), frweight)
          #          histos[folder+'/h_collmass_vs_dPhi_mvamet'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), collmass(row, row.mva_metEt, row.mva_metPhi), frweight)
          #          histos[folder+'/h_collmassSpread_vs_dPhi_pfmet'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, frweight)
          #          histos[folder+'/h_collmassSpread_vs_dPhi_mvamet'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, frweight)
          #          if deltaPhi(row.tPhi, row.pfMetPhi) > 1.57 :  
          #              histos[folder+'/h_collmass_highPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), frweight)
          #              histos[folder+'/h_collmassSpread_highPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, frweight)
          #          if deltaPhi(row.tPhi, row.pfMetPhi) < 1.57 :  
          #              histos[folder+'/h_collmass_lowPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), frweight)
          #              histos[folder+'/h_collmassSpread_lowPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, frweight)
          #          if deltaPhi(row.tPhi, row.mva_metPhi) > 1.57 :  
          #              histos[folder+'/h_collmass_highPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi), frweight)
          #              histos[folder+'/h_collmassSpread_highPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, frweight)
          #          if deltaPhi(row.tPhi, row.mva_metPhi) < 1.57 :  
          #              histos[folder+'/h_collmass_lowPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi), frweight)
          #              histos[folder+'/h_collmassSpread_lowPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, frweight)

          #          histos[folder+'/h_collmassSpread_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, frweight)
          #          histos[folder+'/h_collmassSpread_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, frweight)
               #     histos[folder+'/h_collmass_pfmet'].Fill(collmass(row, row.pfMetEt, row.pfMetPhi), frweight)
               #     histos[folder+'/h_collmass_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi), frweight)
               #     histos[folder+'/h_collmass_pfmet_Ty1'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), frweight)

                    #histos[folder+'/h_collmass_pfmet_jes'].Fill(collmass(row, row.pfMet_jes_Et, row.pfMet_jes_Phi), frweight)
                    #histos[folder+'/h_collmass_pfmet_mes'].Fill(collmass(row, row.pfMet_mes_Et, row.pfMet_mes_Phi), frweight)
                    #histos[folder+'/h_collmass_pfmet_tes'].Fill(collmass(row, row.pfMet_tes_Et, row.pfMet_tes_Phi), frweight)
                    #histos[folder+'/h_collmass_pfmet_ees'].Fill(collmass(row, row.pfMet_ees_Et, row.pfMet_ees_Phi), frweight)
                    #histos[folder+'/h_collmass_pfmet_ues'].Fill(collmass(row, row.pfMet_ues_Et, row.pfMet_ues_Phi), frweight)
                    
                    
               #     histos[folder+'/h_vismass'].Fill(row.e_t_Mass, frweight)
           #         histos[folder+'/type1_pfMetEt_vs_dPhi'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), row.type1_pfMetEt, frweight)
           #         histos[folder+'/mvaMetEt_vs_dPhi'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), row.mva_metEt, frweight)
                        
           #         histos[folder+'/ePFMET_DeltaPhi'].Fill(deltaPhi(row.ePhi, row.pfMetPhi), frweight)
           #         histos[folder+'/ePFMET_DeltaPhi_Ty1'].Fill(deltaPhi(row.ePhi, row.type1_pfMetPhi), frweight)
           #         histos[folder+'/eMVAMET_DeltaPhi'].Fill(deltaPhi(row.ePhi, row.mva_metPhi), frweight)
           #         histos[folder+'/ePFMET_Mt'].Fill(row.eMtToPFMET, frweight)
           #         histos[folder+'/ePFMET_Mt_Ty1'].Fill(row.eMtToPfMet_Ty1, frweight)
           #         histos[folder+'/eMVAMET_Mt'].Fill(row.eMtToMVAMET, frweight)
                    ##histos[folder+'/ePFMET_Mt_Ty1_ues_minus'].Fill(row.eMtToPfMet_Ty1_ues_minus, frweight)
                    ##histos[folder+'/ePFMET_Mt_Ty1_ues_plus'].Fill(row.eMtToPfMet_Ty1_ues_plus, frweight)
                    #histos[folder+'/ePFMET_Mt_jes_minus'].Fill(row.eMtToPfMet_jes_minus, frweight)
                    #histos[folder+'/ePFMET_Mt_jes_plus'].Fill(row.eMtToPfMet_jes_plus, frweight)
                    #histos[folder+'/ePFMET_Mt_jes'].Fill(row.eMtToPfMet_jes, frweight)
                    #histos[folder+'/ePFMET_Mt_mes_minus'].Fill(row.eMtToPfMet_mes_minus, frweight)
                    #histos[folder+'/ePFMET_Mt_mes_plus'].Fill(row.eMtToPfMet_mes_plus, frweight)
                    #histos[folder+'/ePFMET_Mt_mes'].Fill(row.eMtToPfMet_mes, frweight)
                    #histos[folder+'/ePFMET_Mt_ees_minus'].Fill(row.eMtToPfMet_ees_minus, frweight)
                    #histos[folder+'/ePFMET_Mt_ees_plus'].Fill(row.eMtToPfMet_ees_plus, frweight)
                    #histos[folder+'/ePFMET_Mt_ees'].Fill(row.eMtToPfMet_ees, frweight)
                    #histos[folder+'/ePFMET_Mt_tes_minus'].Fill(row.eMtToPfMet_tes_minus, frweight)
                    #histos[folder+'/ePFMET_Mt_tes_plus'].Fill(row.eMtToPfMet_tes_plus, frweight)
                    #histos[folder+'/ePFMET_Mt_tes'].Fill(row.eMtToPfMet_tes, frweight)
                    #histos[folder+'/ePFMET_Mt_ues_minus'].Fill(row.eMtToPfMet_ues_minus, frweight)
                    #histos[folder+'/ePFMET_Mt_ues_plus'].Fill(row.eMtToPfMet_ues_plus, frweight)
                    #histos[folder+'/ePFMET_Mt_ues'].Fill(row.eMtToPfMet_ues, frweight)

                    
                        
           #         histos[folder+'/tPFMET_DeltaPhi'].Fill(deltaPhi(row.tPhi, row.pfMetPhi), frweight)
           #         histos[folder+'/tPFMET_DeltaPhi_Ty1'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), frweight)
           #         histos[folder+'/tMVAMET_DeltaPhi'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), frweight)
           #         histos[folder+'/tPFMET_Mt'].Fill(row.tMtToPFMET, frweight)
           #         histos[folder+'/tMVAMET_Mt'].Fill(row.tMtToMVAMET, frweight)
                    #histos[folder+'/tPFMET_Mt_jes'].Fill(row.tMtToPfMet_jes, frweight)
                    #histos[folder+'/tPFMET_Mt_mes'].Fill(row.tMtToPfMet_mes, frweight)
                    #histos[folder+'/tPFMET_Mt_ees'].Fill(row.tMtToPfMet_ees, frweight)
                    #histos[folder+'/tPFMET_Mt_tes'].Fill(row.tMtToPfMet_tes, frweight)
                    #histos[folder+'/tPFMET_Mt_ues'].Fill(row.tMtToPfMet_ues, frweight)
                    
           #         histos[folder+'/jetN_20'].Fill(row.jetVeto20, frweight) 
           #         histos[folder+'/jetN_30'].Fill(row.jetVeto30, frweight) 
                    
        else: # if it is TauTight
            if not f.startswith('os') and not  f.startswith('ss') : # if the dir name start with mVeto, eVeto or tVeto I don't want the different weight of MC corrections
                pudir = ['']
                    
            for n,d  in enumerate(pudir) :
                if 'minus' in f  or 'plus' in f :
                    if n >0 : break
                    
                folder = d+f
                #print folder
                if f=='os/gg/ept30' :
       #             histos[folder+'/h_collmass_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), row.EmbPtWeight*weight[n])
       #             histos[folder+'/h_vismass'].Fill(row.e_t_Mass, row.EmbPtWeight*weight[n])
                    continue
                if(histoname=='tPtcut'): histos[folder+'/tPtcut'].Fill(cutvalue,weight[n])
                if(histoname=='ePtcut'): histos[folder+'/ePtcut'].Fill(cutvalue,weight[n])
                if(histoname=='deltaPhicut'): histos[folder+'/deltaPhicut'].Fill(cutvalue,weight[n])
                if(histoname=='tMtToPFMETcut'): histos[folder+'/tMtToPFMETcut'].Fill(cutvalue,weight[n])
                if(histoname=='vbfMasscut'): histos[folder+'/vbfMasscut'].Fill(cutvalue,weight[n])
                if(histoname=='vbfDetacut'): histos[folder+'/vbfDetacut'].Fill(cutvalue,weight[n])
       #         histos[folder+'/tMtToPFMET'].Fill(row.tMtToPFMET, weight[n])
       #         histos[folder+'/vbfMass'].Fill(row.vbfMass,  weight[n])
       #         histos[folder+'/vbfDeta'].Fill(row.vbfDeta,  weight[n])

       #         histos[folder+'/tPt'].Fill(row.tPt, weight[n])
            #    histos[folder+'/tEta'].Fill(row.tEta, weight[n])
            #    histos[folder+'/tPhi'].Fill(row.tPhi, weight[n]) 
       #         histos[folder+'/ePt'].Fill(row.ePt, weight[n])
            #    histos[folder+'/eEta'].Fill(row.eEta, weight[n])
            #    histos[folder+'/ePhi'].Fill(row.ePhi, weight[n])
       #         histos[folder+'/et_DeltaPhi'].Fill(deltaPhi(row.ePhi, row.tPhi), weight[n])
            #    histos[folder+'/et_DeltaR'].Fill(row.e_t_DR, weight[n])
                    
          #      histos[folder+'/h_collmass_vs_dPhi_pfmet'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), weight[n])
          #      histos[folder+'/h_collmass_vs_dPhi_mvamet'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), collmass(row, row.mva_metEt, row.mva_metPhi), weight[n])
          #      histos[folder+'/h_collmassSpread_vs_dPhi_pfmet'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, weight[n])
          #      histos[folder+'/h_collmassSpread_vs_dPhi_mvamet'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, weight[n])
          #      if deltaPhi(row.tPhi, row.pfMetPhi) > 1.57 :  
          #          histos[folder+'/h_collmass_highPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), weight[n])
          #          histos[folder+'/h_collmassSpread_highPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, weight[n])
          #      if deltaPhi(row.tPhi, row.pfMetPhi) < 1.57 :  
          #          histos[folder+'/h_collmass_lowPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), weight[n])
          #          histos[folder+'/h_collmassSpread_lowPhi_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, weight[n])
          #      if deltaPhi(row.tPhi, row.mva_metPhi) > 1.57 :  
          #          histos[folder+'/h_collmass_highPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi), weight[n])
          #          histos[folder+'/h_collmassSpread_highPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, weight[n])
          #      if deltaPhi(row.tPhi, row.mva_metPhi) < 1.57 :  
          #          histos[folder+'/h_collmass_lowPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi), weight[n])
          #          histos[folder+'/h_collmassSpread_lowPhi_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, weight[n])
          #      histos[folder+'/h_collmassSpread_pfmet'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi)-125.0, weight[n])
          #      histos[folder+'/h_collmassSpread_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi)-125.0, weight[n])


      #          histos[folder+'/h_collmass_pfmet'].Fill(collmass(row, row.pfMetEt, row.pfMetPhi), weight[n])
      #          histos[folder+'/h_collmass_mvamet'].Fill(collmass(row, row.mva_metEt, row.mva_metPhi), weight[n])
      #          histos[folder+'/h_collmass_pfmet_Ty1'].Fill(collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi), weight[n])
                
                    
                    
      #          histos[folder+'/h_vismass'].Fill(row.e_t_Mass, weight[n])
                
          #      histos[folder+'/type1_pfMetEt_vs_dPhi'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), row.type1_pfMetEt, weight[n])
          #      histos[folder+'/mvaMetEt_vs_dPhi'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), row.mva_metEt, weight[n])
                
          #      histos[folder+'/ePFMET_DeltaPhi'].Fill(deltaPhi(row.ePhi, row.type1_pfMetPhi), weight[n])
          #      histos[folder+'/ePFMET_DeltaPhi_Ty1'].Fill(deltaPhi(row.ePhi, row.type1_pfMetPhi), weight[n])
          #      histos[folder+'/eMVAMET_DeltaPhi'].Fill(deltaPhi(row.ePhi, row.mva_metPhi), weight[n])
                
          #      histos[folder+'/ePFMET_Mt'].Fill(row.eMtToPFMET, weight[n])
          #      histos[folder+'/ePFMET_Mt_Ty1'].Fill(row.eMtToPfMet_Ty1, weight[n])
          #      histos[folder+'/eMVAMET_Mt'].Fill(row.eMtToMVAMET, weight[n])
                
          #      histos[folder+'/tPFMET_DeltaPhi'].Fill(deltaPhi(row.tPhi, row.pfMetPhi), weight[n])
          #      histos[folder+'/tPFMET_DeltaPhi_Ty1'].Fill(deltaPhi(row.tPhi, row.type1_pfMetPhi), weight[n])
          #      histos[folder+'/tMVAMET_DeltaPhi'].Fill(deltaPhi(row.tPhi, row.mva_metPhi), weight[n])
                
          #      histos[folder+'/tPFMET_Mt'].Fill(row.tMtToPFMET, weight[n])
          #      histos[folder+'/tPFMET_Mt_Ty1'].Fill(row.tMtToPfMet_Ty1, weight[n])
          #      histos[folder+'/tMVAMET_Mt'].Fill(row.tMtToMVAMET, weight[n])
                    
          #      histos[folder+'/jetN_20'].Fill(row.jetVeto20, weight[n]) 
          #      histos[folder+'/jetN_30'].Fill(row.jetVeto30, weight[n]) 
                

          #      if n == 0: # if I'm in the dir starting with os or ss I want also the energy scale uncertainties
          #          histos[folder+'/h_collmass_pfmet_jes_plus'].Fill(collmass(row, row.pfMet_jes_Et, row.pfMet_jes_plus_Phi), weight[n])
          #          histos[folder+'/h_collmass_pfmet_jes_minus'].Fill(collmass(row, row.pfMet_jes_Et, row.pfMet_jes_minus_Phi), weight[n])
                    ### add the minus in the ntuple.
                    #histos[folder+'/h_collmass_pfmet_mes_plus'].Fill(collmass(row, row.pfMet_mes_Et, row.pfMet_mes_Phi), weight[n])
                    #histos[folder+'/h_collmass_pfmet_tes_plus'].Fill(collmass(row, row.pfMet_tes_Et, row.pfMet_tes_Phi), weight[n])
                    #histos[folder+'/h_collmass_pfmet_ees_plus'].Fill(collmass(row, row.pfMet_ees_Et, row.pfMet_ees_Phi), weight[n])
                    #histos[folder+'/h_collmass_pfmet_ues_plus'].Fill(collmass(row, row.pfMet_ues_Et, row.pfMet_ues_Phi), weight[n])
                    
                    
          #          histos[folder+'/ePFMET_Mt_jes_minus'].Fill(row.eMtToPfMet_jes_minus, weight[n])
          #          histos[folder+'/ePFMET_Mt_jes_plus'].Fill(row.eMtToPfMet_jes_plus,   weight[n])
                    
          #          histos[folder+'/ePFMET_Mt_mes_minus'].Fill(row.eMtToPfMet_mes_minus,weight[n]) 
          #          histos[folder+'/ePFMET_Mt_mes_plus'].Fill(row.eMtToPfMet_mes_plus,  weight[n]) 
                    
          #          histos[folder+'/ePFMET_Mt_ees_minus'].Fill(row.eMtToPfMet_ees_minus,weight[n]) 
          #          histos[folder+'/ePFMET_Mt_ees_plus'].Fill(row.eMtToPfMet_ees_plus,  weight[n]) 
                    
          #          histos[folder+'/ePFMET_Mt_tes_minus'].Fill(row.eMtToPfMet_tes_minus,weight[n]) 
          #          histos[folder+'/ePFMET_Mt_tes_plus'].Fill(row.eMtToPfMet_tes_plus,  weight[n]) 
                    
          #          histos[folder+'/ePFMET_Mt_ues_minus'].Fill(row.eMtToPfMet_ues_minus,weight[n]) 
          #          histos[folder+'/ePFMET_Mt_ues_plus'].Fill(row.eMtToPfMet_ues_plus,  weight[n]) 
                        
          #          histos[folder+'/tPFMET_Mt_jes_plus'].Fill(row.tMtToPfMet_jes_plus,weight[n])
          #          histos[folder+'/tPFMET_Mt_mes_plus'].Fill(row.tMtToPfMet_mes_plus,weight[n])
          #          histos[folder+'/tPFMET_Mt_ees_plus'].Fill(row.tMtToPfMet_ees_plus,weight[n])
          #          histos[folder+'/tPFMET_Mt_tes_plus'].Fill(row.tMtToPfMet_tes_plus,weight[n])
          #          histos[folder+'/tPFMET_Mt_ues_plus'].Fill(row.tMtToPfMet_ues_plus,weight[n])
          #          histos[folder+'/tPFMET_Mt_jes_minus'].Fill(row.tMtToPfMet_jes_minus,weight[n])
          #          histos[folder+'/tPFMET_Mt_mes_minus'].Fill(row.tMtToPfMet_mes_minus,weight[n])
          #          histos[folder+'/tPFMET_Mt_ees_minus'].Fill(row.tMtToPfMet_ees_minus,weight[n])
          #          histos[folder+'/tPFMET_Mt_tes_minus'].Fill(row.tMtToPfMet_tes_minus,weight[n])
          #          histos[folder+'/tPFMET_Mt_ues_minus'].Fill(row.tMtToPfMet_ues_minus,weight[n])



 
            


    def process(self):
        
        

        central_weights = fakerate_central_histogram(25,0, 2.5)
        
        #p1s_weights = fakerate_p1s_histogram(25,0, 2.5)#fakerate_p1s_histogram(25,0, 2.5)
        
       # m1s_weights = fakerate_m1s_histogram(25,0, 2.5)#fakerate_m1s_histogram(25,0, 2.5)
        
                
        
        frw = []
        myevent =()
        for row in self.tree:
        #for n, row in enumerate(self.tree):
            
            sign = 'ss' if row.e_t_SS else 'os'
            processtype = '' ## use a line as for sign when the vbf when selections are defined            
            ptthreshold = [30]
            processtype ='gg'##changed from 20
            jn = row.jetVeto30
            if jn > 3 : jn = 3
        #    jn_jes_plus = row.jetVeto30jes_plus
        #    jn_jes_minus = row.jetVeto30jes_minus

        #    if jn_jes_plus >3 :  jn_jes_plus=3
        #    if jn_jes_minus >3 : jn_jes_minus=3

            #if row.run > 2 : #apply the trigger to data only (MC triggers enter in the scale factors)
            
            if self.is_embedded :

                if not bool(row.doubleMuPass) : continue
            else: 
                if not bool(row.singleE27WP80Pass) : continue
                if  not  bool(row.eMatchesSingleE27WP80): continue
                        
            if not selections.eSelection(row, 'e'): continue
               
            if not selections.lepton_id_iso(row, 'e', 'eid13Tight_etauiso01'): continue
                        
            if abs(row.eEta) > 1.4442 and abs(row.eEta) < 1.566 : continue
            if not selections.tauSelection(row, 't'): continue
                        
            if row.ePt < 30 : continue
            #if row.eMtToPFMET <40 : continue
            
            if not row.tAntiElectronMVA5Tight : continue
            if not row.tAntiMuon2Loose : continue
            if not row.tLooseIso3Hits : continue
            
            #isTauTight = False
            frw=self.fakerate_weights(row.tEta, central_weights, central_weights,central_weights)

            #if row.tauVetoPt20EleTight3MuLoose : continue 
            #if row.muVetoPt5IsoIdVtx : continue
            #if row.eVetoCicLooseIso : continue # change it with Loose

            if row.tauVetoPt20EleTight3MuLoose  and row.tauVetoPt20EleTight3MuLoose_tes_minus and row.tauVetoPt20EleTight3MuLoose_tes_plus: continue 
            if row.muVetoPt5IsoIdVtx and row.muVetoPt5IsoIdVtx_mes_minus and row.muVetoPt5IsoIdVtx_mes_plus : continue
            if row.eVetoCicLooseIso and row.eVetoCicLooseIso_ees_minus and row.eVetoCicLooseIso_ees_plus : continue
            
            standardSelection=True
         #   tesminus =True
         #   tesplus  =True
         #   mesminus =True
         #   mesplus  =True
         #   eesminus =True
         #   eesplus  =True        
            
            if  row.tauVetoPt20EleTight3MuLoose or row.muVetoPt5IsoIdVtx or  row.eVetoCicLooseIso : standardSelection =  False             

         #   if  row.tauVetoPt20EleTight3MuLoose_tes_minus or row.muVetoPt5IsoIdVtx or  row.eVetoCicLooseIso : tesminus =  False 
         #   if  row.tauVetoPt20EleTight3MuLoose_tes_plus or row.muVetoPt5IsoIdVtx or  row.eVetoCicLooseIso  : tesplus  =  False 
         #   if  row.tauVetoPt20EleTight3MuLoose or row.muVetoPt5IsoIdVtx_mes_minus or  row.eVetoCicLooseIso : mesminus =  False 
         #   if  row.tauVetoPt20EleTight3MuLoose or row.muVetoPt5IsoIdVtx_mes_plus or  row.eVetoCicLooseIso  : mesplus  =  False 
         #   if  row.tauVetoPt20EleTight3MuLoose or row.muVetoPt5IsoIdVtx or  row.eVetoCicLooseIso_ees_minus : eesminus =  False 
         #   if  row.tauVetoPt20EleTight3MuLoose or row.muVetoPt5IsoIdVtx or  row.eVetoCicLooseIso_ees_plus  : eesplus  =  False 
            
            dirpaths = [(standardSelection, sign+'/'+processtype)]

            
            
            if (row.run, row.lumi, row.evt)==myevent: continue
            if myevent!=() and (row.run, row.lumi, row.evt)==(myevent[0], myevent[1], myevent[2]): print row.ePt, row.tPt
            
            myevent=(row.run, row.lumi, row.evt)

            isTauTight = bool(row.tTightIso3Hits)
            folder = dirpaths[0][1]+'/ept30'
            if sign !='os': continue
            if bool(isTauTight) == False:continue
      #      if dirpaths[0][0] == True and sign=='os':
      #          self.fill_histos(row, folder,isTauTight, frw)
                   
            
            if row.bjetCSVVeto30!=0 : continue # it is better vetoing on b-jets  after the histo for the DY embedded
            # reference  (histogram name,tune or not, step length ,down range,uprange,selected value)
            jet0panel=[('tPtcut',0,1,30,80),('ePtcut',0,1,30,80),('deltaPhicut',0,1,10,35),('tMtToPFMETcut',0,1,0,160)]
            jet1panel=[('tPtcut',0,1,30,80),('ePtcut',0,1,30,80),('tMtToPFMETcut',0,1,0,160)]
            jet2panel=[('tPtcut',1,1,30,80),('ePtcut',0,1,30,80),('tMtToPFMETcut',0,1,0,160),('vbfMasscut',0,4,0,800),('vbfDetacut',0,1,10,80)]
            jet0refer=(30,46,2,77)
            jet1refer=(31,42,70)
            jet2refer=(30,40,60,400,3.2)
            for n,dirpath in enumerate(dirpaths):
                jetlist = [(int(jn), str(int(jn)))]
                if  dirpath[0]==False : continue 
              #  if n==0:
              #      jetlist.extend([(int(jn_jes_plus), str(int(jn_jes_plus))+'_jes_plus'), (int(jn_jes_minus), str(int(jn_jes_plus))+'_jes_minus')])
                for jet in jetlist:
                    #for j in ptthreshold:
                    folder = dirpath[1]+'/ept30/'+jet[1]
                                        
                        #print row.tLooseIso3Hits, row.tTightIso3Hits, isTauTight
                                                
                   # self.fill_histos(row, folder,isTauTight, frw)
                
                    if jet[0] == 0 :
                      for nbjet0,jetwhole0 in enumerate(jet0panel): 
                          if nbjet0==0 and jetwhole0[1]==1 :
                              for j in range(jetwhole0[3],jetwhole0[4],jetwhole0[2]): 
                                 if row.tPt < j: continue 
                                 if row.ePt < jet0refer[1] : continue
                                 if deltaPhi(row.ePhi, row.tPhi) < jet0refer[2] : continue
                                 if row.tMtToPFMET  > jet0refer[3] : continue
                                 self.fill_histos2(row,j,jetwhole0[0], folder, isTauTight,frw)
                               #  print j
                          if nbjet0==1 and  jetwhole0[1]==1:
                              for j in range(jetwhole0[3],jetwhole0[4],jetwhole0[2]): 
                                 if row.tPt < jet0refer[0]: continue 
                                 if row.ePt < j : continue
                                 if deltaPhi(row.ePhi, row.tPhi) < jet0refer[2] : continue
                                 if row.tMtToPFMET  > jet0refer[3] : continue
                                 self.fill_histos2(row,j,jetwhole0[0], folder, isTauTight,frw)
                               #  print  jetwhole0[0] 
                          if nbjet0==2 and jetwhole0[1]==1 :
                              for j in range(jetwhole0[3],jetwhole0[4],jetwhole0[2]): 
                                 if row.tPt < jet0refer[0]: continue 
                                 if row.ePt < jet0refer[1] : continue
                                 if deltaPhi(row.ePhi, row.tPhi) < j/10.0 : continue
                                 if row.tMtToPFMET > jet0refer[3] : continue
                                 self.fill_histos2(row,j/10.0,jetwhole0[0], folder, isTauTight,frw) 
                          if nbjet0==3 and jetwhole0[1]==1 :
                              for j in range(jetwhole0[3],jetwhole0[4],jetwhole0[2]): 
                                 if row.tPt < jet0refer[0]: continue 
                                 if row.ePt < jet0refer[1] : continue
                                 if deltaPhi(row.ePhi, row.tPhi) < jet0refer[2] : continue
                                 if row.tMtToPFMET > j : continue
                                 self.fill_histos2(row,j,jetwhole0[0], folder, isTauTight,frw) 


#                                 if row.tPt < 35: continue 
#                                 if row.ePt < 40 : continue
#                                 if deltaPhi(row.ePhi, row.tPhi) < 2.7 : continue
#                                 if row.tMtToPFMET > 50 : continue
                    if jet[0] == 1 :
                      for nbjet1,jetwhole1 in enumerate(jet1panel): 
                          if nbjet1==0 and jetwhole1[1]==1 :
                              for j in range(jetwhole1[3],jetwhole1[4],jetwhole1[2]): 
                                 if row.tPt < j: continue 
                                 if row.ePt < jet1refer[1] : continue
                                 if row.tMtToPFMET > jet1refer[2] : continue
                                 self.fill_histos2(row,j,jetwhole1[0], folder, isTauTight,frw)
                               #  print j
                          if nbjet1==1 and  jetwhole1[1]==1:
                              for j in range(jetwhole1[3],jetwhole1[4],jetwhole1[2]): 
                                 if row.tPt < jet1refer[0]: continue 
                                 if row.ePt < j : continue
                                 if row.tMtToPFMET > jet1refer[2] : continue
                                 self.fill_histos2(row,j,jetwhole1[0], folder, isTauTight,frw)
                          if nbjet1==2 and jetwhole1[1]==1 :
                              for j in range(jetwhole1[3],jetwhole1[4],jetwhole1[2]): 
                                 if row.tPt < jet1refer[0]: continue 
                                 if row.ePt < jet1refer[1] : continue
                                 if row.tMtToPFMET > j : continue
                                 self.fill_histos2(row,j,jetwhole1[0], folder, isTauTight,frw) 
                    if jet[0] == 2 :
                      for nbjet2,jetwhole2 in enumerate(jet2panel): 
                          if nbjet2==0 and jetwhole2[1]==1 :
                              for j in range(jetwhole2[3],jetwhole2[4],jetwhole2[2]): 
                                 if row.tPt < j: continue 
                                 if row.ePt < jet2refer[1] : continue
                                 if row.tMtToPFMET > jet2refer[2] : continue
                                 if row.vbfMass < jet2refer[3] : continue
                                 if row.vbfDeta < jet2refer[4] : continue
                                 self.fill_histos2(row,j,jetwhole2[0], folder, isTauTight,frw)
                               #  print j
                          if nbjet2==1 and  jetwhole2[1]==1:
                              for j in range(jetwhole2[3],jetwhole2[4],jetwhole2[2]): 
                                 if row.tPt < jet2refer[0]: continue 
                                 if row.ePt < j : continue
                                 if row.tMtToPFMET > jet2refer[2] : continue
                                 if row.vbfMass < jet2refer[3] : continue
                                 if row.vbfDeta < jet2refer[4] : continue
                                 self.fill_histos2(row,j,jetwhole2[0], folder, isTauTight,frw)
                          if nbjet2==2 and jetwhole2[1]==1 :
                              for j in range(jetwhole2[3],jetwhole2[4],jetwhole2[2]): 
                                 if row.tPt < jet2refer[0]: continue 
                                 if row.ePt < jet2refer[1] : continue
                                 if row.tMtToPFMET > j : continue
                                 if row.vbfMass < jet2refer[3] : continue
                                 if row.vbfDeta < jet2refer[4] : continue
                                 self.fill_histos2(row,j,jetwhole2[0], folder, isTauTight,frw) 
                          if nbjet2==3 and jetwhole2[1]==1 :
                              for j in range(jetwhole2[3],jetwhole2[4],jetwhole2[2]): 
                                 if row.tPt < jet2refer[0]: continue 
                                 if row.ePt < jet2refer[1] : continue
                                 if row.tMtToPFMET >jet2refer[2] : continue
                                 if row.vbfMass < j : continue
                                 if row.vbfDeta < jet2refer[4] : continue
                                 self.fill_histos2(row,j,jetwhole2[0], folder, isTauTight,frw) 
                          if nbjet2==4 and jetwhole2[1]==1 :
                              for j in range(jetwhole2[3],jetwhole2[4],jetwhole2[2]): 
                                 if row.tPt < jet2refer[0]: continue 
                                 if row.ePt < jet2refer[1] : continue
                                 if row.tMtToPFMET >jet2refer[2] : continue
                                 if row.vbfMass < jet2refer[3] : continue
                                 if row.vbfDeta < j/10.0: continue
                                 self.fill_histos2(row,j/10.0,jetwhole2[0], folder, isTauTight,frw) 
        #            folder = dirpath[1]+'/ept30/'+jet[1]+'/selected'
        #            self.fill_histos2(row,2,'tPtcut', folder, isTauTight,frw)
                
                 
                    
             
            
    def finish(self):
        self.write_histos()


