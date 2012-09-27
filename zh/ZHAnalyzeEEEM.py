'''

Analyze EEEM events for the ZH analysis

'''

#from FinalStateAnalysis.StatTools.RooFunctorFromWS import build_roofunctor
import glob
from EEEMuTree import EEEMuTree
import os
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import baseSelections as selections
import mcCorrectors
import ZHAnalyzerBase
import ROOT
import fake_rate_functions as fr_fcn

################################################################################
#### Analysis logic ############################################################
################################################################################

class ZHAnalyzeEEEM(ZHAnalyzerBase.ZHAnalyzerBase):
    tree = 'eeem/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        super(ZHAnalyzeEEEM, self).__init__(tree, outfile, EEEMuTree, 'EM', **kwargs)
        # Hack to use S6 weights for the one 7TeV sample we use in 8TeV
        target = os.environ['megatarget']
        if 'HWW3l' in target:
            print "HACK using S6 PU weights for HWW3l"
            mcCorrectors.force_pu_distribution('S6')

    def book_histos(self, folder):
        super(ZHAnalyzeEEEM, self).book_general_histos(folder)
        super(ZHAnalyzeEEEM, self).book_kin_histos(folder, 'e1')
        super(ZHAnalyzeEEEM, self).book_kin_histos(folder, 'e2')
        super(ZHAnalyzeEEEM, self).book_kin_histos(folder, 'm')
        super(ZHAnalyzeEEEM, self).book_kin_histos(folder, 'e3')
        super(ZHAnalyzeEEEM, self).book_mass_histos(folder, 'e1','e2','e3','m')

    def probe1_id(self, row):
        return bool(row.e3RelPFIsoDB < 0.25)

    def probe2_id(self, row):
        return bool(row.mRelPFIsoDB < 0.25)

    def preselection(self, row):
        ''' Preselection applied to events.

        Excludes FR object IDs and sign cut.
        '''
        if not selections.ZEESelection(row): return False
        if not selections.overlap(row, 'e1','e2','e3','m') : return False
        if not selections.signalMuonSelection(row,'m'): return False
        if not selections.signalElectronSelection(row,'e3'): return False
        if bool(row.e3_m_SS): return False
        return True

    def sign_cut(self, row):
        ''' Returns true if muons are SS '''
        return not bool(row.e3_m_SS)

    def event_weight(self, row):
        if row.run > 2:
            return 1.
        return meCorrectors.pu_corrector(row.nTruePU) * \
            meCorrectors.get_muon_corrections(row,'m') * \
            get_electron_corrections(row, 'e1','e2')

    def obj1_weight(self, row):
        return fr_fcn.e_fr(max(row.e3JetPt, row.e3Pt))
        #return highpt_mu_fr(row.m1Pt)

    def obj2_weight(self, row):
        return fr_fcn.mu_fr(max(row.mJetPt, row.mPt))
        #return lowpt_mu_fr(row.m2Pt)
