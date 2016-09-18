

# Load relevant ROOT C++ headers
cdef extern from "TObject.h":
    cdef cppclass TObject:
        pass

cdef extern from "TBranch.h":
    cdef cppclass TBranch:
        int GetEntry(long, int)
        void SetAddress(void*)

cdef extern from "TTree.h":
    cdef cppclass TTree:
        TTree()
        int GetEntry(long, int)
        long LoadTree(long)
        long GetEntries()
        TTree* GetTree()
        int GetTreeNumber()
        TBranch* GetBranch(char*)

cdef extern from "TFile.h":
    cdef cppclass TFile:
        TFile(char*, char*, char*, int)
        TObject* Get(char*)

# Used for filtering with a string
cdef extern from "TTreeFormula.h":
    cdef cppclass TTreeFormula:
        TTreeFormula(char*, char*, TTree*)
        double EvalInstance(int, char**)
        void UpdateFormulaLeaves()
        void SetTree(TTree*)

from cpython cimport PyCObject_AsVoidPtr
import warnings
def my_warning_format(message, category, filename, lineno, line=""):
    return "%s:%s\n" % (category.__name__, message)
warnings.formatwarning = my_warning_format

cdef class MuTauTree:
    # Pointers to tree (may be a chain), current active tree, and current entry
    # localentry is the entry in the current tree of the chain
    cdef TTree* tree
    cdef TTree* currentTree
    cdef int currentTreeNumber
    cdef long ientry
    cdef long localentry
    # Keep track of missing branches we have complained about.
    cdef public set complained

    # Branches and address for all

    cdef TBranch* EmbPtWeight_branch
    cdef float EmbPtWeight_value

    cdef TBranch* Eta_branch
    cdef float Eta_value

    cdef TBranch* GenWeight_branch
    cdef float GenWeight_value

    cdef TBranch* Ht_branch
    cdef float Ht_value

    cdef TBranch* LT_branch
    cdef float LT_value

    cdef TBranch* Mass_branch
    cdef float Mass_value

    cdef TBranch* MassError_branch
    cdef float MassError_value

    cdef TBranch* MassErrord1_branch
    cdef float MassErrord1_value

    cdef TBranch* MassErrord2_branch
    cdef float MassErrord2_value

    cdef TBranch* MassErrord3_branch
    cdef float MassErrord3_value

    cdef TBranch* MassErrord4_branch
    cdef float MassErrord4_value

    cdef TBranch* Mt_branch
    cdef float Mt_value

    cdef TBranch* NUP_branch
    cdef float NUP_value

    cdef TBranch* Phi_branch
    cdef float Phi_value

    cdef TBranch* Pt_branch
    cdef float Pt_value

    cdef TBranch* bjetCISVVeto20Loose_branch
    cdef float bjetCISVVeto20Loose_value

    cdef TBranch* bjetCISVVeto20Medium_branch
    cdef float bjetCISVVeto20Medium_value

    cdef TBranch* bjetCISVVeto20Tight_branch
    cdef float bjetCISVVeto20Tight_value

    cdef TBranch* bjetCISVVeto30Loose_branch
    cdef float bjetCISVVeto30Loose_value

    cdef TBranch* bjetCISVVeto30Medium_branch
    cdef float bjetCISVVeto30Medium_value

    cdef TBranch* bjetCISVVeto30Tight_branch
    cdef float bjetCISVVeto30Tight_value

    cdef TBranch* charge_branch
    cdef float charge_value

    cdef TBranch* doubleEGroup_branch
    cdef float doubleEGroup_value

    cdef TBranch* doubleEPass_branch
    cdef float doubleEPass_value

    cdef TBranch* doubleEPrescale_branch
    cdef float doubleEPrescale_value

    cdef TBranch* doubleESingleMuGroup_branch
    cdef float doubleESingleMuGroup_value

    cdef TBranch* doubleESingleMuPass_branch
    cdef float doubleESingleMuPass_value

    cdef TBranch* doubleESingleMuPrescale_branch
    cdef float doubleESingleMuPrescale_value

    cdef TBranch* doubleE_23_12Group_branch
    cdef float doubleE_23_12Group_value

    cdef TBranch* doubleE_23_12Pass_branch
    cdef float doubleE_23_12Pass_value

    cdef TBranch* doubleE_23_12Prescale_branch
    cdef float doubleE_23_12Prescale_value

    cdef TBranch* doubleMuGroup_branch
    cdef float doubleMuGroup_value

    cdef TBranch* doubleMuPass_branch
    cdef float doubleMuPass_value

    cdef TBranch* doubleMuPrescale_branch
    cdef float doubleMuPrescale_value

    cdef TBranch* doubleMuSingleEGroup_branch
    cdef float doubleMuSingleEGroup_value

    cdef TBranch* doubleMuSingleEPass_branch
    cdef float doubleMuSingleEPass_value

    cdef TBranch* doubleMuSingleEPrescale_branch
    cdef float doubleMuSingleEPrescale_value

    cdef TBranch* doubleTau32Group_branch
    cdef float doubleTau32Group_value

    cdef TBranch* doubleTau32Pass_branch
    cdef float doubleTau32Pass_value

    cdef TBranch* doubleTau32Prescale_branch
    cdef float doubleTau32Prescale_value

    cdef TBranch* doubleTau35Group_branch
    cdef float doubleTau35Group_value

    cdef TBranch* doubleTau35Pass_branch
    cdef float doubleTau35Pass_value

    cdef TBranch* doubleTau35Prescale_branch
    cdef float doubleTau35Prescale_value

    cdef TBranch* doubleTau40Group_branch
    cdef float doubleTau40Group_value

    cdef TBranch* doubleTau40Pass_branch
    cdef float doubleTau40Pass_value

    cdef TBranch* doubleTau40Prescale_branch
    cdef float doubleTau40Prescale_value

    cdef TBranch* eVetoMVAIso_branch
    cdef float eVetoMVAIso_value

    cdef TBranch* eVetoMVAIsoVtx_branch
    cdef float eVetoMVAIsoVtx_value

    cdef TBranch* evt_branch
    cdef unsigned long evt_value

    cdef TBranch* genHTT_branch
    cdef float genHTT_value

    cdef TBranch* isGtautau_branch
    cdef float isGtautau_value

    cdef TBranch* isWmunu_branch
    cdef float isWmunu_value

    cdef TBranch* isWtaunu_branch
    cdef float isWtaunu_value

    cdef TBranch* isZee_branch
    cdef float isZee_value

    cdef TBranch* isZmumu_branch
    cdef float isZmumu_value

    cdef TBranch* isZtautau_branch
    cdef float isZtautau_value

    cdef TBranch* isdata_branch
    cdef int isdata_value

    cdef TBranch* jet1BJetCISV_branch
    cdef float jet1BJetCISV_value

    cdef TBranch* jet1Eta_branch
    cdef float jet1Eta_value

    cdef TBranch* jet1IDLoose_branch
    cdef float jet1IDLoose_value

    cdef TBranch* jet1IDTight_branch
    cdef float jet1IDTight_value

    cdef TBranch* jet1IDTightLepVeto_branch
    cdef float jet1IDTightLepVeto_value

    cdef TBranch* jet1PUMVA_branch
    cdef float jet1PUMVA_value

    cdef TBranch* jet1Phi_branch
    cdef float jet1Phi_value

    cdef TBranch* jet1Pt_branch
    cdef float jet1Pt_value

    cdef TBranch* jet2BJetCISV_branch
    cdef float jet2BJetCISV_value

    cdef TBranch* jet2Eta_branch
    cdef float jet2Eta_value

    cdef TBranch* jet2IDLoose_branch
    cdef float jet2IDLoose_value

    cdef TBranch* jet2IDTight_branch
    cdef float jet2IDTight_value

    cdef TBranch* jet2IDTightLepVeto_branch
    cdef float jet2IDTightLepVeto_value

    cdef TBranch* jet2PUMVA_branch
    cdef float jet2PUMVA_value

    cdef TBranch* jet2Phi_branch
    cdef float jet2Phi_value

    cdef TBranch* jet2Pt_branch
    cdef float jet2Pt_value

    cdef TBranch* jet3BJetCISV_branch
    cdef float jet3BJetCISV_value

    cdef TBranch* jet3Eta_branch
    cdef float jet3Eta_value

    cdef TBranch* jet3IDLoose_branch
    cdef float jet3IDLoose_value

    cdef TBranch* jet3IDTight_branch
    cdef float jet3IDTight_value

    cdef TBranch* jet3IDTightLepVeto_branch
    cdef float jet3IDTightLepVeto_value

    cdef TBranch* jet3PUMVA_branch
    cdef float jet3PUMVA_value

    cdef TBranch* jet3Phi_branch
    cdef float jet3Phi_value

    cdef TBranch* jet3Pt_branch
    cdef float jet3Pt_value

    cdef TBranch* jet4BJetCISV_branch
    cdef float jet4BJetCISV_value

    cdef TBranch* jet4Eta_branch
    cdef float jet4Eta_value

    cdef TBranch* jet4IDLoose_branch
    cdef float jet4IDLoose_value

    cdef TBranch* jet4IDTight_branch
    cdef float jet4IDTight_value

    cdef TBranch* jet4IDTightLepVeto_branch
    cdef float jet4IDTightLepVeto_value

    cdef TBranch* jet4PUMVA_branch
    cdef float jet4PUMVA_value

    cdef TBranch* jet4Phi_branch
    cdef float jet4Phi_value

    cdef TBranch* jet4Pt_branch
    cdef float jet4Pt_value

    cdef TBranch* jet5BJetCISV_branch
    cdef float jet5BJetCISV_value

    cdef TBranch* jet5Eta_branch
    cdef float jet5Eta_value

    cdef TBranch* jet5IDLoose_branch
    cdef float jet5IDLoose_value

    cdef TBranch* jet5IDTight_branch
    cdef float jet5IDTight_value

    cdef TBranch* jet5IDTightLepVeto_branch
    cdef float jet5IDTightLepVeto_value

    cdef TBranch* jet5PUMVA_branch
    cdef float jet5PUMVA_value

    cdef TBranch* jet5Phi_branch
    cdef float jet5Phi_value

    cdef TBranch* jet5Pt_branch
    cdef float jet5Pt_value

    cdef TBranch* jet6BJetCISV_branch
    cdef float jet6BJetCISV_value

    cdef TBranch* jet6Eta_branch
    cdef float jet6Eta_value

    cdef TBranch* jet6IDLoose_branch
    cdef float jet6IDLoose_value

    cdef TBranch* jet6IDTight_branch
    cdef float jet6IDTight_value

    cdef TBranch* jet6IDTightLepVeto_branch
    cdef float jet6IDTightLepVeto_value

    cdef TBranch* jet6PUMVA_branch
    cdef float jet6PUMVA_value

    cdef TBranch* jet6Phi_branch
    cdef float jet6Phi_value

    cdef TBranch* jet6Pt_branch
    cdef float jet6Pt_value

    cdef TBranch* jetVeto20_branch
    cdef float jetVeto20_value

    cdef TBranch* jetVeto20_DR05_branch
    cdef float jetVeto20_DR05_value

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

    cdef TBranch* jetVeto30Eta3_branch
    cdef float jetVeto30Eta3_value

    cdef TBranch* jetVeto30Eta3_JetEnDown_branch
    cdef float jetVeto30Eta3_JetEnDown_value

    cdef TBranch* jetVeto30Eta3_JetEnUp_branch
    cdef float jetVeto30Eta3_JetEnUp_value

    cdef TBranch* jetVeto30_DR05_branch
    cdef float jetVeto30_DR05_value

    cdef TBranch* jetVeto30_JetEnDown_branch
    cdef float jetVeto30_JetEnDown_value

    cdef TBranch* jetVeto30_JetEnUp_branch
    cdef float jetVeto30_JetEnUp_value

    cdef TBranch* jetVeto40_branch
    cdef float jetVeto40_value

    cdef TBranch* jetVeto40_DR05_branch
    cdef float jetVeto40_DR05_value

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* mAbsEta_branch
    cdef float mAbsEta_value

    cdef TBranch* mBestTrackType_branch
    cdef float mBestTrackType_value

    cdef TBranch* mCharge_branch
    cdef float mCharge_value

    cdef TBranch* mComesFromHiggs_branch
    cdef float mComesFromHiggs_value

    cdef TBranch* mDPhiToPfMet_ElectronEnDown_branch
    cdef float mDPhiToPfMet_ElectronEnDown_value

    cdef TBranch* mDPhiToPfMet_ElectronEnUp_branch
    cdef float mDPhiToPfMet_ElectronEnUp_value

    cdef TBranch* mDPhiToPfMet_JetEnDown_branch
    cdef float mDPhiToPfMet_JetEnDown_value

    cdef TBranch* mDPhiToPfMet_JetEnUp_branch
    cdef float mDPhiToPfMet_JetEnUp_value

    cdef TBranch* mDPhiToPfMet_JetResDown_branch
    cdef float mDPhiToPfMet_JetResDown_value

    cdef TBranch* mDPhiToPfMet_JetResUp_branch
    cdef float mDPhiToPfMet_JetResUp_value

    cdef TBranch* mDPhiToPfMet_MuonEnDown_branch
    cdef float mDPhiToPfMet_MuonEnDown_value

    cdef TBranch* mDPhiToPfMet_MuonEnUp_branch
    cdef float mDPhiToPfMet_MuonEnUp_value

    cdef TBranch* mDPhiToPfMet_PhotonEnDown_branch
    cdef float mDPhiToPfMet_PhotonEnDown_value

    cdef TBranch* mDPhiToPfMet_PhotonEnUp_branch
    cdef float mDPhiToPfMet_PhotonEnUp_value

    cdef TBranch* mDPhiToPfMet_TauEnDown_branch
    cdef float mDPhiToPfMet_TauEnDown_value

    cdef TBranch* mDPhiToPfMet_TauEnUp_branch
    cdef float mDPhiToPfMet_TauEnUp_value

    cdef TBranch* mDPhiToPfMet_UnclusteredEnDown_branch
    cdef float mDPhiToPfMet_UnclusteredEnDown_value

    cdef TBranch* mDPhiToPfMet_UnclusteredEnUp_branch
    cdef float mDPhiToPfMet_UnclusteredEnUp_value

    cdef TBranch* mDPhiToPfMet_type1_branch
    cdef float mDPhiToPfMet_type1_value

    cdef TBranch* mEcalIsoDR03_branch
    cdef float mEcalIsoDR03_value

    cdef TBranch* mEffectiveArea2011_branch
    cdef float mEffectiveArea2011_value

    cdef TBranch* mEffectiveArea2012_branch
    cdef float mEffectiveArea2012_value

    cdef TBranch* mEta_branch
    cdef float mEta_value

    cdef TBranch* mEta_MuonEnDown_branch
    cdef float mEta_MuonEnDown_value

    cdef TBranch* mEta_MuonEnUp_branch
    cdef float mEta_MuonEnUp_value

    cdef TBranch* mGenCharge_branch
    cdef float mGenCharge_value

    cdef TBranch* mGenEnergy_branch
    cdef float mGenEnergy_value

    cdef TBranch* mGenEta_branch
    cdef float mGenEta_value

    cdef TBranch* mGenMotherPdgId_branch
    cdef float mGenMotherPdgId_value

    cdef TBranch* mGenParticle_branch
    cdef float mGenParticle_value

    cdef TBranch* mGenPdgId_branch
    cdef float mGenPdgId_value

    cdef TBranch* mGenPhi_branch
    cdef float mGenPhi_value

    cdef TBranch* mGenPrompt_branch
    cdef float mGenPrompt_value

    cdef TBranch* mGenPromptTauDecay_branch
    cdef float mGenPromptTauDecay_value

    cdef TBranch* mGenPt_branch
    cdef float mGenPt_value

    cdef TBranch* mGenTauDecay_branch
    cdef float mGenTauDecay_value

    cdef TBranch* mGenVZ_branch
    cdef float mGenVZ_value

    cdef TBranch* mGenVtxPVMatch_branch
    cdef float mGenVtxPVMatch_value

    cdef TBranch* mHcalIsoDR03_branch
    cdef float mHcalIsoDR03_value

    cdef TBranch* mIP3D_branch
    cdef float mIP3D_value

    cdef TBranch* mIP3DErr_branch
    cdef float mIP3DErr_value

    cdef TBranch* mIsGlobal_branch
    cdef float mIsGlobal_value

    cdef TBranch* mIsPFMuon_branch
    cdef float mIsPFMuon_value

    cdef TBranch* mIsTracker_branch
    cdef float mIsTracker_value

    cdef TBranch* mJetArea_branch
    cdef float mJetArea_value

    cdef TBranch* mJetBtag_branch
    cdef float mJetBtag_value

    cdef TBranch* mJetEtaEtaMoment_branch
    cdef float mJetEtaEtaMoment_value

    cdef TBranch* mJetEtaPhiMoment_branch
    cdef float mJetEtaPhiMoment_value

    cdef TBranch* mJetEtaPhiSpread_branch
    cdef float mJetEtaPhiSpread_value

    cdef TBranch* mJetPFCISVBtag_branch
    cdef float mJetPFCISVBtag_value

    cdef TBranch* mJetPartonFlavour_branch
    cdef float mJetPartonFlavour_value

    cdef TBranch* mJetPhiPhiMoment_branch
    cdef float mJetPhiPhiMoment_value

    cdef TBranch* mJetPt_branch
    cdef float mJetPt_value

    cdef TBranch* mLowestMll_branch
    cdef float mLowestMll_value

    cdef TBranch* mMass_branch
    cdef float mMass_value

    cdef TBranch* mMatchedStations_branch
    cdef float mMatchedStations_value

    cdef TBranch* mMatchesDoubleESingleMu_branch
    cdef float mMatchesDoubleESingleMu_value

    cdef TBranch* mMatchesDoubleMu_branch
    cdef float mMatchesDoubleMu_value

    cdef TBranch* mMatchesDoubleMuSingleE_branch
    cdef float mMatchesDoubleMuSingleE_value

    cdef TBranch* mMatchesSingleESingleMu_branch
    cdef float mMatchesSingleESingleMu_value

    cdef TBranch* mMatchesSingleMu_branch
    cdef float mMatchesSingleMu_value

    cdef TBranch* mMatchesSingleMuIso20_branch
    cdef float mMatchesSingleMuIso20_value

    cdef TBranch* mMatchesSingleMuIsoTk20_branch
    cdef float mMatchesSingleMuIsoTk20_value

    cdef TBranch* mMatchesSingleMuSingleE_branch
    cdef float mMatchesSingleMuSingleE_value

    cdef TBranch* mMatchesSingleMu_leg1_branch
    cdef float mMatchesSingleMu_leg1_value

    cdef TBranch* mMatchesSingleMu_leg1_noiso_branch
    cdef float mMatchesSingleMu_leg1_noiso_value

    cdef TBranch* mMatchesSingleMu_leg2_branch
    cdef float mMatchesSingleMu_leg2_value

    cdef TBranch* mMatchesSingleMu_leg2_noiso_branch
    cdef float mMatchesSingleMu_leg2_noiso_value

    cdef TBranch* mMatchesTripleMu_branch
    cdef float mMatchesTripleMu_value

    cdef TBranch* mMtToPfMet_ElectronEnDown_branch
    cdef float mMtToPfMet_ElectronEnDown_value

    cdef TBranch* mMtToPfMet_ElectronEnUp_branch
    cdef float mMtToPfMet_ElectronEnUp_value

    cdef TBranch* mMtToPfMet_JetEnDown_branch
    cdef float mMtToPfMet_JetEnDown_value

    cdef TBranch* mMtToPfMet_JetEnUp_branch
    cdef float mMtToPfMet_JetEnUp_value

    cdef TBranch* mMtToPfMet_JetResDown_branch
    cdef float mMtToPfMet_JetResDown_value

    cdef TBranch* mMtToPfMet_JetResUp_branch
    cdef float mMtToPfMet_JetResUp_value

    cdef TBranch* mMtToPfMet_MuonEnDown_branch
    cdef float mMtToPfMet_MuonEnDown_value

    cdef TBranch* mMtToPfMet_MuonEnUp_branch
    cdef float mMtToPfMet_MuonEnUp_value

    cdef TBranch* mMtToPfMet_PhotonEnDown_branch
    cdef float mMtToPfMet_PhotonEnDown_value

    cdef TBranch* mMtToPfMet_PhotonEnUp_branch
    cdef float mMtToPfMet_PhotonEnUp_value

    cdef TBranch* mMtToPfMet_Raw_branch
    cdef float mMtToPfMet_Raw_value

    cdef TBranch* mMtToPfMet_TauEnDown_branch
    cdef float mMtToPfMet_TauEnDown_value

    cdef TBranch* mMtToPfMet_TauEnUp_branch
    cdef float mMtToPfMet_TauEnUp_value

    cdef TBranch* mMtToPfMet_UnclusteredEnDown_branch
    cdef float mMtToPfMet_UnclusteredEnDown_value

    cdef TBranch* mMtToPfMet_UnclusteredEnUp_branch
    cdef float mMtToPfMet_UnclusteredEnUp_value

    cdef TBranch* mMtToPfMet_type1_branch
    cdef float mMtToPfMet_type1_value

    cdef TBranch* mMuonHits_branch
    cdef float mMuonHits_value

    cdef TBranch* mNearestZMass_branch
    cdef float mNearestZMass_value

    cdef TBranch* mNormTrkChi2_branch
    cdef float mNormTrkChi2_value

    cdef TBranch* mPFChargedHadronIsoR04_branch
    cdef float mPFChargedHadronIsoR04_value

    cdef TBranch* mPFChargedIso_branch
    cdef float mPFChargedIso_value

    cdef TBranch* mPFIDLoose_branch
    cdef float mPFIDLoose_value

    cdef TBranch* mPFIDMedium_branch
    cdef float mPFIDMedium_value

    cdef TBranch* mPFIDTight_branch
    cdef float mPFIDTight_value

    cdef TBranch* mPFNeutralHadronIsoR04_branch
    cdef float mPFNeutralHadronIsoR04_value

    cdef TBranch* mPFNeutralIso_branch
    cdef float mPFNeutralIso_value

    cdef TBranch* mPFPUChargedIso_branch
    cdef float mPFPUChargedIso_value

    cdef TBranch* mPFPhotonIso_branch
    cdef float mPFPhotonIso_value

    cdef TBranch* mPFPhotonIsoR04_branch
    cdef float mPFPhotonIsoR04_value

    cdef TBranch* mPFPileupIsoR04_branch
    cdef float mPFPileupIsoR04_value

    cdef TBranch* mPVDXY_branch
    cdef float mPVDXY_value

    cdef TBranch* mPVDZ_branch
    cdef float mPVDZ_value

    cdef TBranch* mPhi_branch
    cdef float mPhi_value

    cdef TBranch* mPhi_MuonEnDown_branch
    cdef float mPhi_MuonEnDown_value

    cdef TBranch* mPhi_MuonEnUp_branch
    cdef float mPhi_MuonEnUp_value

    cdef TBranch* mPixHits_branch
    cdef float mPixHits_value

    cdef TBranch* mPt_branch
    cdef float mPt_value

    cdef TBranch* mPt_MuonEnDown_branch
    cdef float mPt_MuonEnDown_value

    cdef TBranch* mPt_MuonEnUp_branch
    cdef float mPt_MuonEnUp_value

    cdef TBranch* mRank_branch
    cdef float mRank_value

    cdef TBranch* mRelPFIsoDBDefault_branch
    cdef float mRelPFIsoDBDefault_value

    cdef TBranch* mRelPFIsoDBDefaultR04_branch
    cdef float mRelPFIsoDBDefaultR04_value

    cdef TBranch* mRelPFIsoRho_branch
    cdef float mRelPFIsoRho_value

    cdef TBranch* mRho_branch
    cdef float mRho_value

    cdef TBranch* mSIP2D_branch
    cdef float mSIP2D_value

    cdef TBranch* mSIP3D_branch
    cdef float mSIP3D_value

    cdef TBranch* mTkLayersWithMeasurement_branch
    cdef float mTkLayersWithMeasurement_value

    cdef TBranch* mTrkIsoDR03_branch
    cdef float mTrkIsoDR03_value

    cdef TBranch* mTypeCode_branch
    cdef int mTypeCode_value

    cdef TBranch* mVZ_branch
    cdef float mVZ_value

    cdef TBranch* m_t_CosThetaStar_branch
    cdef float m_t_CosThetaStar_value

    cdef TBranch* m_t_DPhi_branch
    cdef float m_t_DPhi_value

    cdef TBranch* m_t_DR_branch
    cdef float m_t_DR_value

    cdef TBranch* m_t_Eta_branch
    cdef float m_t_Eta_value

    cdef TBranch* m_t_Mass_branch
    cdef float m_t_Mass_value

    cdef TBranch* m_t_Mass_TauEnDown_branch
    cdef float m_t_Mass_TauEnDown_value

    cdef TBranch* m_t_Mass_TauEnUp_branch
    cdef float m_t_Mass_TauEnUp_value

    cdef TBranch* m_t_Mt_branch
    cdef float m_t_Mt_value

    cdef TBranch* m_t_Mt_TauEnDown_branch
    cdef float m_t_Mt_TauEnDown_value

    cdef TBranch* m_t_Mt_TauEnUp_branch
    cdef float m_t_Mt_TauEnUp_value

    cdef TBranch* m_t_PZeta_branch
    cdef float m_t_PZeta_value

    cdef TBranch* m_t_PZetaVis_branch
    cdef float m_t_PZetaVis_value

    cdef TBranch* m_t_Phi_branch
    cdef float m_t_Phi_value

    cdef TBranch* m_t_Pt_branch
    cdef float m_t_Pt_value

    cdef TBranch* m_t_SS_branch
    cdef float m_t_SS_value

    cdef TBranch* m_t_ToMETDPhi_Ty1_branch
    cdef float m_t_ToMETDPhi_Ty1_value

    cdef TBranch* m_t_collinearmass_branch
    cdef float m_t_collinearmass_value

    cdef TBranch* m_t_collinearmass_JetEnDown_branch
    cdef float m_t_collinearmass_JetEnDown_value

    cdef TBranch* m_t_collinearmass_JetEnUp_branch
    cdef float m_t_collinearmass_JetEnUp_value

    cdef TBranch* m_t_collinearmass_TauEnDown_branch
    cdef float m_t_collinearmass_TauEnDown_value

    cdef TBranch* m_t_collinearmass_TauEnUp_branch
    cdef float m_t_collinearmass_TauEnUp_value

    cdef TBranch* m_t_collinearmass_UnclusteredEnDown_branch
    cdef float m_t_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m_t_collinearmass_UnclusteredEnUp_branch
    cdef float m_t_collinearmass_UnclusteredEnUp_value

    cdef TBranch* muGlbIsoVetoPt10_branch
    cdef float muGlbIsoVetoPt10_value

    cdef TBranch* muVetoPt15IsoIdVtx_branch
    cdef float muVetoPt15IsoIdVtx_value

    cdef TBranch* muVetoPt5_branch
    cdef float muVetoPt5_value

    cdef TBranch* muVetoPt5IsoIdVtx_branch
    cdef float muVetoPt5IsoIdVtx_value

    cdef TBranch* nTruePU_branch
    cdef float nTruePU_value

    cdef TBranch* nvtx_branch
    cdef float nvtx_value

    cdef TBranch* processID_branch
    cdef float processID_value

    cdef TBranch* pvChi2_branch
    cdef float pvChi2_value

    cdef TBranch* pvDX_branch
    cdef float pvDX_value

    cdef TBranch* pvDY_branch
    cdef float pvDY_value

    cdef TBranch* pvDZ_branch
    cdef float pvDZ_value

    cdef TBranch* pvIsFake_branch
    cdef int pvIsFake_value

    cdef TBranch* pvIsValid_branch
    cdef int pvIsValid_value

    cdef TBranch* pvNormChi2_branch
    cdef float pvNormChi2_value

    cdef TBranch* pvRho_branch
    cdef float pvRho_value

    cdef TBranch* pvX_branch
    cdef float pvX_value

    cdef TBranch* pvY_branch
    cdef float pvY_value

    cdef TBranch* pvZ_branch
    cdef float pvZ_value

    cdef TBranch* pvndof_branch
    cdef float pvndof_value

    cdef TBranch* raw_pfMetEt_branch
    cdef float raw_pfMetEt_value

    cdef TBranch* raw_pfMetPhi_branch
    cdef float raw_pfMetPhi_value

    cdef TBranch* recoilDaught_branch
    cdef float recoilDaught_value

    cdef TBranch* recoilWithMet_branch
    cdef float recoilWithMet_value

    cdef TBranch* rho_branch
    cdef float rho_value

    cdef TBranch* run_branch
    cdef int run_value

    cdef TBranch* singleE17SingleMu8Group_branch
    cdef float singleE17SingleMu8Group_value

    cdef TBranch* singleE17SingleMu8Pass_branch
    cdef float singleE17SingleMu8Pass_value

    cdef TBranch* singleE17SingleMu8Prescale_branch
    cdef float singleE17SingleMu8Prescale_value

    cdef TBranch* singleE22eta2p1LooseGroup_branch
    cdef float singleE22eta2p1LooseGroup_value

    cdef TBranch* singleE22eta2p1LoosePass_branch
    cdef float singleE22eta2p1LoosePass_value

    cdef TBranch* singleE22eta2p1LoosePrescale_branch
    cdef float singleE22eta2p1LoosePrescale_value

    cdef TBranch* singleE22eta2p1LooseTau20Group_branch
    cdef float singleE22eta2p1LooseTau20Group_value

    cdef TBranch* singleE22eta2p1LooseTau20Pass_branch
    cdef float singleE22eta2p1LooseTau20Pass_value

    cdef TBranch* singleE22eta2p1LooseTau20Prescale_branch
    cdef float singleE22eta2p1LooseTau20Prescale_value

    cdef TBranch* singleE23SingleMu8Group_branch
    cdef float singleE23SingleMu8Group_value

    cdef TBranch* singleE23SingleMu8Pass_branch
    cdef float singleE23SingleMu8Pass_value

    cdef TBranch* singleE23SingleMu8Prescale_branch
    cdef float singleE23SingleMu8Prescale_value

    cdef TBranch* singleE23WPLooseGroup_branch
    cdef float singleE23WPLooseGroup_value

    cdef TBranch* singleE23WPLoosePass_branch
    cdef float singleE23WPLoosePass_value

    cdef TBranch* singleE23WPLoosePrescale_branch
    cdef float singleE23WPLoosePrescale_value

    cdef TBranch* singleE25eta2p1TightGroup_branch
    cdef float singleE25eta2p1TightGroup_value

    cdef TBranch* singleE25eta2p1TightPass_branch
    cdef float singleE25eta2p1TightPass_value

    cdef TBranch* singleE25eta2p1TightPrescale_branch
    cdef float singleE25eta2p1TightPrescale_value

    cdef TBranch* singleEGroup_branch
    cdef float singleEGroup_value

    cdef TBranch* singleEPass_branch
    cdef float singleEPass_value

    cdef TBranch* singleEPrescale_branch
    cdef float singleEPrescale_value

    cdef TBranch* singleESingleMuGroup_branch
    cdef float singleESingleMuGroup_value

    cdef TBranch* singleESingleMuPass_branch
    cdef float singleESingleMuPass_value

    cdef TBranch* singleESingleMuPrescale_branch
    cdef float singleESingleMuPrescale_value

    cdef TBranch* singleE_leg1Group_branch
    cdef float singleE_leg1Group_value

    cdef TBranch* singleE_leg1Pass_branch
    cdef float singleE_leg1Pass_value

    cdef TBranch* singleE_leg1Prescale_branch
    cdef float singleE_leg1Prescale_value

    cdef TBranch* singleE_leg2Group_branch
    cdef float singleE_leg2Group_value

    cdef TBranch* singleE_leg2Pass_branch
    cdef float singleE_leg2Pass_value

    cdef TBranch* singleE_leg2Prescale_branch
    cdef float singleE_leg2Prescale_value

    cdef TBranch* singleIsoMu18Group_branch
    cdef float singleIsoMu18Group_value

    cdef TBranch* singleIsoMu18Pass_branch
    cdef float singleIsoMu18Pass_value

    cdef TBranch* singleIsoMu18Prescale_branch
    cdef float singleIsoMu18Prescale_value

    cdef TBranch* singleIsoMu20Group_branch
    cdef float singleIsoMu20Group_value

    cdef TBranch* singleIsoMu20Pass_branch
    cdef float singleIsoMu20Pass_value

    cdef TBranch* singleIsoMu20Prescale_branch
    cdef float singleIsoMu20Prescale_value

    cdef TBranch* singleIsoMu22Group_branch
    cdef float singleIsoMu22Group_value

    cdef TBranch* singleIsoMu22Pass_branch
    cdef float singleIsoMu22Pass_value

    cdef TBranch* singleIsoMu22Prescale_branch
    cdef float singleIsoMu22Prescale_value

    cdef TBranch* singleIsoMu22eta2p1Group_branch
    cdef float singleIsoMu22eta2p1Group_value

    cdef TBranch* singleIsoMu22eta2p1Pass_branch
    cdef float singleIsoMu22eta2p1Pass_value

    cdef TBranch* singleIsoMu22eta2p1Prescale_branch
    cdef float singleIsoMu22eta2p1Prescale_value

    cdef TBranch* singleIsoMu27Group_branch
    cdef float singleIsoMu27Group_value

    cdef TBranch* singleIsoMu27Pass_branch
    cdef float singleIsoMu27Pass_value

    cdef TBranch* singleIsoMu27Prescale_branch
    cdef float singleIsoMu27Prescale_value

    cdef TBranch* singleIsoTkMu20Group_branch
    cdef float singleIsoTkMu20Group_value

    cdef TBranch* singleIsoTkMu20Pass_branch
    cdef float singleIsoTkMu20Pass_value

    cdef TBranch* singleIsoTkMu20Prescale_branch
    cdef float singleIsoTkMu20Prescale_value

    cdef TBranch* singleIsoTkMu22Group_branch
    cdef float singleIsoTkMu22Group_value

    cdef TBranch* singleIsoTkMu22Pass_branch
    cdef float singleIsoTkMu22Pass_value

    cdef TBranch* singleIsoTkMu22Prescale_branch
    cdef float singleIsoTkMu22Prescale_value

    cdef TBranch* singleMu17SingleE12Group_branch
    cdef float singleMu17SingleE12Group_value

    cdef TBranch* singleMu17SingleE12Pass_branch
    cdef float singleMu17SingleE12Pass_value

    cdef TBranch* singleMu17SingleE12Prescale_branch
    cdef float singleMu17SingleE12Prescale_value

    cdef TBranch* singleMu23SingleE12Group_branch
    cdef float singleMu23SingleE12Group_value

    cdef TBranch* singleMu23SingleE12Pass_branch
    cdef float singleMu23SingleE12Pass_value

    cdef TBranch* singleMu23SingleE12Prescale_branch
    cdef float singleMu23SingleE12Prescale_value

    cdef TBranch* singleMuGroup_branch
    cdef float singleMuGroup_value

    cdef TBranch* singleMuPass_branch
    cdef float singleMuPass_value

    cdef TBranch* singleMuPrescale_branch
    cdef float singleMuPrescale_value

    cdef TBranch* singleMuSingleEGroup_branch
    cdef float singleMuSingleEGroup_value

    cdef TBranch* singleMuSingleEPass_branch
    cdef float singleMuSingleEPass_value

    cdef TBranch* singleMuSingleEPrescale_branch
    cdef float singleMuSingleEPrescale_value

    cdef TBranch* singleMu_leg1Group_branch
    cdef float singleMu_leg1Group_value

    cdef TBranch* singleMu_leg1Pass_branch
    cdef float singleMu_leg1Pass_value

    cdef TBranch* singleMu_leg1Prescale_branch
    cdef float singleMu_leg1Prescale_value

    cdef TBranch* singleMu_leg1_noisoGroup_branch
    cdef float singleMu_leg1_noisoGroup_value

    cdef TBranch* singleMu_leg1_noisoPass_branch
    cdef float singleMu_leg1_noisoPass_value

    cdef TBranch* singleMu_leg1_noisoPrescale_branch
    cdef float singleMu_leg1_noisoPrescale_value

    cdef TBranch* singleMu_leg2Group_branch
    cdef float singleMu_leg2Group_value

    cdef TBranch* singleMu_leg2Pass_branch
    cdef float singleMu_leg2Pass_value

    cdef TBranch* singleMu_leg2Prescale_branch
    cdef float singleMu_leg2Prescale_value

    cdef TBranch* singleMu_leg2_noisoGroup_branch
    cdef float singleMu_leg2_noisoGroup_value

    cdef TBranch* singleMu_leg2_noisoPass_branch
    cdef float singleMu_leg2_noisoPass_value

    cdef TBranch* singleMu_leg2_noisoPrescale_branch
    cdef float singleMu_leg2_noisoPrescale_value

    cdef TBranch* tAbsEta_branch
    cdef float tAbsEta_value

    cdef TBranch* tAgainstElectronLooseMVA6_branch
    cdef float tAgainstElectronLooseMVA6_value

    cdef TBranch* tAgainstElectronMVA6Raw_branch
    cdef float tAgainstElectronMVA6Raw_value

    cdef TBranch* tAgainstElectronMVA6category_branch
    cdef float tAgainstElectronMVA6category_value

    cdef TBranch* tAgainstElectronMediumMVA6_branch
    cdef float tAgainstElectronMediumMVA6_value

    cdef TBranch* tAgainstElectronTightMVA6_branch
    cdef float tAgainstElectronTightMVA6_value

    cdef TBranch* tAgainstElectronVLooseMVA6_branch
    cdef float tAgainstElectronVLooseMVA6_value

    cdef TBranch* tAgainstElectronVTightMVA6_branch
    cdef float tAgainstElectronVTightMVA6_value

    cdef TBranch* tAgainstMuonLoose3_branch
    cdef float tAgainstMuonLoose3_value

    cdef TBranch* tAgainstMuonTight3_branch
    cdef float tAgainstMuonTight3_value

    cdef TBranch* tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch
    cdef float tByCombinedIsolationDeltaBetaCorrRaw3Hits_value

    cdef TBranch* tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch
    cdef float tByIsolationMVArun2v1DBdR03oldDMwLTraw_value

    cdef TBranch* tByIsolationMVArun2v1DBnewDMwLTraw_branch
    cdef float tByIsolationMVArun2v1DBnewDMwLTraw_value

    cdef TBranch* tByIsolationMVArun2v1DBoldDMwLTraw_branch
    cdef float tByIsolationMVArun2v1DBoldDMwLTraw_value

    cdef TBranch* tByIsolationMVArun2v1PWdR03oldDMwLTraw_branch
    cdef float tByIsolationMVArun2v1PWdR03oldDMwLTraw_value

    cdef TBranch* tByIsolationMVArun2v1PWnewDMwLTraw_branch
    cdef float tByIsolationMVArun2v1PWnewDMwLTraw_value

    cdef TBranch* tByIsolationMVArun2v1PWoldDMwLTraw_branch
    cdef float tByIsolationMVArun2v1PWoldDMwLTraw_value

    cdef TBranch* tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch
    cdef float tByLooseCombinedIsolationDeltaBetaCorr3Hits_value

    cdef TBranch* tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByLooseIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByLooseIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByLooseIsolationMVArun2v1PWdR03oldDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1PWdR03oldDMwLT_value

    cdef TBranch* tByLooseIsolationMVArun2v1PWnewDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1PWnewDMwLT_value

    cdef TBranch* tByLooseIsolationMVArun2v1PWoldDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1PWoldDMwLT_value

    cdef TBranch* tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch
    cdef float tByMediumCombinedIsolationDeltaBetaCorr3Hits_value

    cdef TBranch* tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByMediumIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByMediumIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByMediumIsolationMVArun2v1PWdR03oldDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1PWdR03oldDMwLT_value

    cdef TBranch* tByMediumIsolationMVArun2v1PWnewDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1PWnewDMwLT_value

    cdef TBranch* tByMediumIsolationMVArun2v1PWoldDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1PWoldDMwLT_value

    cdef TBranch* tByPhotonPtSumOutsideSignalCone_branch
    cdef float tByPhotonPtSumOutsideSignalCone_value

    cdef TBranch* tByTightCombinedIsolationDeltaBetaCorr3Hits_branch
    cdef float tByTightCombinedIsolationDeltaBetaCorr3Hits_value

    cdef TBranch* tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByTightIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByTightIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByTightIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByTightIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByTightIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByTightIsolationMVArun2v1PWdR03oldDMwLT_branch
    cdef float tByTightIsolationMVArun2v1PWdR03oldDMwLT_value

    cdef TBranch* tByTightIsolationMVArun2v1PWnewDMwLT_branch
    cdef float tByTightIsolationMVArun2v1PWnewDMwLT_value

    cdef TBranch* tByTightIsolationMVArun2v1PWoldDMwLT_branch
    cdef float tByTightIsolationMVArun2v1PWoldDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1PWnewDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1PWnewDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1PWoldDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1PWoldDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1PWdR03oldDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1PWdR03oldDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1PWnewDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1PWnewDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1PWoldDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1PWoldDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1PWnewDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1PWnewDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1PWoldDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1PWoldDMwLT_value

    cdef TBranch* tCharge_branch
    cdef float tCharge_value

    cdef TBranch* tChargedIsoPtSum_branch
    cdef float tChargedIsoPtSum_value

    cdef TBranch* tChargedIsoPtSumdR03_branch
    cdef float tChargedIsoPtSumdR03_value

    cdef TBranch* tComesFromHiggs_branch
    cdef float tComesFromHiggs_value

    cdef TBranch* tDPhiToPfMet_ElectronEnDown_branch
    cdef float tDPhiToPfMet_ElectronEnDown_value

    cdef TBranch* tDPhiToPfMet_ElectronEnUp_branch
    cdef float tDPhiToPfMet_ElectronEnUp_value

    cdef TBranch* tDPhiToPfMet_JetEnDown_branch
    cdef float tDPhiToPfMet_JetEnDown_value

    cdef TBranch* tDPhiToPfMet_JetEnUp_branch
    cdef float tDPhiToPfMet_JetEnUp_value

    cdef TBranch* tDPhiToPfMet_JetResDown_branch
    cdef float tDPhiToPfMet_JetResDown_value

    cdef TBranch* tDPhiToPfMet_JetResUp_branch
    cdef float tDPhiToPfMet_JetResUp_value

    cdef TBranch* tDPhiToPfMet_MuonEnDown_branch
    cdef float tDPhiToPfMet_MuonEnDown_value

    cdef TBranch* tDPhiToPfMet_MuonEnUp_branch
    cdef float tDPhiToPfMet_MuonEnUp_value

    cdef TBranch* tDPhiToPfMet_PhotonEnDown_branch
    cdef float tDPhiToPfMet_PhotonEnDown_value

    cdef TBranch* tDPhiToPfMet_PhotonEnUp_branch
    cdef float tDPhiToPfMet_PhotonEnUp_value

    cdef TBranch* tDPhiToPfMet_TauEnDown_branch
    cdef float tDPhiToPfMet_TauEnDown_value

    cdef TBranch* tDPhiToPfMet_TauEnUp_branch
    cdef float tDPhiToPfMet_TauEnUp_value

    cdef TBranch* tDPhiToPfMet_UnclusteredEnDown_branch
    cdef float tDPhiToPfMet_UnclusteredEnDown_value

    cdef TBranch* tDPhiToPfMet_UnclusteredEnUp_branch
    cdef float tDPhiToPfMet_UnclusteredEnUp_value

    cdef TBranch* tDPhiToPfMet_type1_branch
    cdef float tDPhiToPfMet_type1_value

    cdef TBranch* tDecayMode_branch
    cdef float tDecayMode_value

    cdef TBranch* tDecayModeFinding_branch
    cdef float tDecayModeFinding_value

    cdef TBranch* tDecayModeFindingNewDMs_branch
    cdef float tDecayModeFindingNewDMs_value

    cdef TBranch* tElecOverlap_branch
    cdef float tElecOverlap_value

    cdef TBranch* tEta_branch
    cdef float tEta_value

    cdef TBranch* tEta_TauEnDown_branch
    cdef float tEta_TauEnDown_value

    cdef TBranch* tEta_TauEnUp_branch
    cdef float tEta_TauEnUp_value

    cdef TBranch* tFootprintCorrection_branch
    cdef float tFootprintCorrection_value

    cdef TBranch* tFootprintCorrectiondR03_branch
    cdef float tFootprintCorrectiondR03_value

    cdef TBranch* tGenCharge_branch
    cdef float tGenCharge_value

    cdef TBranch* tGenDecayMode_branch
    cdef float tGenDecayMode_value

    cdef TBranch* tGenEnergy_branch
    cdef float tGenEnergy_value

    cdef TBranch* tGenEta_branch
    cdef float tGenEta_value

    cdef TBranch* tGenJetEta_branch
    cdef float tGenJetEta_value

    cdef TBranch* tGenJetPt_branch
    cdef float tGenJetPt_value

    cdef TBranch* tGenMotherEnergy_branch
    cdef float tGenMotherEnergy_value

    cdef TBranch* tGenMotherEta_branch
    cdef float tGenMotherEta_value

    cdef TBranch* tGenMotherPdgId_branch
    cdef float tGenMotherPdgId_value

    cdef TBranch* tGenMotherPhi_branch
    cdef float tGenMotherPhi_value

    cdef TBranch* tGenMotherPt_branch
    cdef float tGenMotherPt_value

    cdef TBranch* tGenPdgId_branch
    cdef float tGenPdgId_value

    cdef TBranch* tGenPhi_branch
    cdef float tGenPhi_value

    cdef TBranch* tGenPt_branch
    cdef float tGenPt_value

    cdef TBranch* tGenStatus_branch
    cdef float tGenStatus_value

    cdef TBranch* tGlobalMuonVtxOverlap_branch
    cdef float tGlobalMuonVtxOverlap_value

    cdef TBranch* tJetArea_branch
    cdef float tJetArea_value

    cdef TBranch* tJetBtag_branch
    cdef float tJetBtag_value

    cdef TBranch* tJetEtaEtaMoment_branch
    cdef float tJetEtaEtaMoment_value

    cdef TBranch* tJetEtaPhiMoment_branch
    cdef float tJetEtaPhiMoment_value

    cdef TBranch* tJetEtaPhiSpread_branch
    cdef float tJetEtaPhiSpread_value

    cdef TBranch* tJetPFCISVBtag_branch
    cdef float tJetPFCISVBtag_value

    cdef TBranch* tJetPartonFlavour_branch
    cdef float tJetPartonFlavour_value

    cdef TBranch* tJetPhiPhiMoment_branch
    cdef float tJetPhiPhiMoment_value

    cdef TBranch* tJetPt_branch
    cdef float tJetPt_value

    cdef TBranch* tLeadTrackPt_branch
    cdef float tLeadTrackPt_value

    cdef TBranch* tLowestMll_branch
    cdef float tLowestMll_value

    cdef TBranch* tMass_branch
    cdef float tMass_value

    cdef TBranch* tMass_TauEnDown_branch
    cdef float tMass_TauEnDown_value

    cdef TBranch* tMass_TauEnUp_branch
    cdef float tMass_TauEnUp_value

    cdef TBranch* tMtToPfMet_ElectronEnDown_branch
    cdef float tMtToPfMet_ElectronEnDown_value

    cdef TBranch* tMtToPfMet_ElectronEnUp_branch
    cdef float tMtToPfMet_ElectronEnUp_value

    cdef TBranch* tMtToPfMet_JetEnDown_branch
    cdef float tMtToPfMet_JetEnDown_value

    cdef TBranch* tMtToPfMet_JetEnUp_branch
    cdef float tMtToPfMet_JetEnUp_value

    cdef TBranch* tMtToPfMet_JetResDown_branch
    cdef float tMtToPfMet_JetResDown_value

    cdef TBranch* tMtToPfMet_JetResUp_branch
    cdef float tMtToPfMet_JetResUp_value

    cdef TBranch* tMtToPfMet_MuonEnDown_branch
    cdef float tMtToPfMet_MuonEnDown_value

    cdef TBranch* tMtToPfMet_MuonEnUp_branch
    cdef float tMtToPfMet_MuonEnUp_value

    cdef TBranch* tMtToPfMet_PhotonEnDown_branch
    cdef float tMtToPfMet_PhotonEnDown_value

    cdef TBranch* tMtToPfMet_PhotonEnUp_branch
    cdef float tMtToPfMet_PhotonEnUp_value

    cdef TBranch* tMtToPfMet_Raw_branch
    cdef float tMtToPfMet_Raw_value

    cdef TBranch* tMtToPfMet_TauEnDown_branch
    cdef float tMtToPfMet_TauEnDown_value

    cdef TBranch* tMtToPfMet_TauEnUp_branch
    cdef float tMtToPfMet_TauEnUp_value

    cdef TBranch* tMtToPfMet_UnclusteredEnDown_branch
    cdef float tMtToPfMet_UnclusteredEnDown_value

    cdef TBranch* tMtToPfMet_UnclusteredEnUp_branch
    cdef float tMtToPfMet_UnclusteredEnUp_value

    cdef TBranch* tMtToPfMet_type1_branch
    cdef float tMtToPfMet_type1_value

    cdef TBranch* tMuOverlap_branch
    cdef float tMuOverlap_value

    cdef TBranch* tMuonIdIsoStdVtxOverlap_branch
    cdef float tMuonIdIsoStdVtxOverlap_value

    cdef TBranch* tMuonIdIsoVtxOverlap_branch
    cdef float tMuonIdIsoVtxOverlap_value

    cdef TBranch* tMuonIdVtxOverlap_branch
    cdef float tMuonIdVtxOverlap_value

    cdef TBranch* tNChrgHadrSignalCands_branch
    cdef float tNChrgHadrSignalCands_value

    cdef TBranch* tNGammaSignalCands_branch
    cdef float tNGammaSignalCands_value

    cdef TBranch* tNNeutralHadrSignalCands_branch
    cdef float tNNeutralHadrSignalCands_value

    cdef TBranch* tNSignalCands_branch
    cdef float tNSignalCands_value

    cdef TBranch* tNearestZMass_branch
    cdef float tNearestZMass_value

    cdef TBranch* tNeutralIsoPtSum_branch
    cdef float tNeutralIsoPtSum_value

    cdef TBranch* tNeutralIsoPtSumWeight_branch
    cdef float tNeutralIsoPtSumWeight_value

    cdef TBranch* tNeutralIsoPtSumWeightdR03_branch
    cdef float tNeutralIsoPtSumWeightdR03_value

    cdef TBranch* tNeutralIsoPtSumdR03_branch
    cdef float tNeutralIsoPtSumdR03_value

    cdef TBranch* tPVDXY_branch
    cdef float tPVDXY_value

    cdef TBranch* tPVDZ_branch
    cdef float tPVDZ_value

    cdef TBranch* tPhi_branch
    cdef float tPhi_value

    cdef TBranch* tPhi_TauEnDown_branch
    cdef float tPhi_TauEnDown_value

    cdef TBranch* tPhi_TauEnUp_branch
    cdef float tPhi_TauEnUp_value

    cdef TBranch* tPhotonPtSumOutsideSignalCone_branch
    cdef float tPhotonPtSumOutsideSignalCone_value

    cdef TBranch* tPhotonPtSumOutsideSignalConedR03_branch
    cdef float tPhotonPtSumOutsideSignalConedR03_value

    cdef TBranch* tPt_branch
    cdef float tPt_value

    cdef TBranch* tPt_TauEnDown_branch
    cdef float tPt_TauEnDown_value

    cdef TBranch* tPt_TauEnUp_branch
    cdef float tPt_TauEnUp_value

    cdef TBranch* tPuCorrPtSum_branch
    cdef float tPuCorrPtSum_value

    cdef TBranch* tRank_branch
    cdef float tRank_value

    cdef TBranch* tVZ_branch
    cdef float tVZ_value

    cdef TBranch* t_m_collinearmass_branch
    cdef float t_m_collinearmass_value

    cdef TBranch* tauVetoPt20Loose3HitsNewDMVtx_branch
    cdef float tauVetoPt20Loose3HitsNewDMVtx_value

    cdef TBranch* tauVetoPt20Loose3HitsVtx_branch
    cdef float tauVetoPt20Loose3HitsVtx_value

    cdef TBranch* tauVetoPt20TightMVALTNewDMVtx_branch
    cdef float tauVetoPt20TightMVALTNewDMVtx_value

    cdef TBranch* tauVetoPt20TightMVALTVtx_branch
    cdef float tauVetoPt20TightMVALTVtx_value

    cdef TBranch* tripleEGroup_branch
    cdef float tripleEGroup_value

    cdef TBranch* tripleEPass_branch
    cdef float tripleEPass_value

    cdef TBranch* tripleEPrescale_branch
    cdef float tripleEPrescale_value

    cdef TBranch* tripleMuGroup_branch
    cdef float tripleMuGroup_value

    cdef TBranch* tripleMuPass_branch
    cdef float tripleMuPass_value

    cdef TBranch* tripleMuPrescale_branch
    cdef float tripleMuPrescale_value

    cdef TBranch* type1_pfMetEt_branch
    cdef float type1_pfMetEt_value

    cdef TBranch* type1_pfMetPhi_branch
    cdef float type1_pfMetPhi_value

    cdef TBranch* type1_pfMet_shiftedPhi_ElectronEnDown_branch
    cdef float type1_pfMet_shiftedPhi_ElectronEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_ElectronEnUp_branch
    cdef float type1_pfMet_shiftedPhi_ElectronEnUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEnDown_branch
    cdef float type1_pfMet_shiftedPhi_JetEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEnUp_branch
    cdef float type1_pfMet_shiftedPhi_JetEnUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetResDown_branch
    cdef float type1_pfMet_shiftedPhi_JetResDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetResUp_branch
    cdef float type1_pfMet_shiftedPhi_JetResUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_MuonEnDown_branch
    cdef float type1_pfMet_shiftedPhi_MuonEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_MuonEnUp_branch
    cdef float type1_pfMet_shiftedPhi_MuonEnUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_PhotonEnDown_branch
    cdef float type1_pfMet_shiftedPhi_PhotonEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_PhotonEnUp_branch
    cdef float type1_pfMet_shiftedPhi_PhotonEnUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_TauEnDown_branch
    cdef float type1_pfMet_shiftedPhi_TauEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_TauEnUp_branch
    cdef float type1_pfMet_shiftedPhi_TauEnUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_UnclusteredEnDown_branch
    cdef float type1_pfMet_shiftedPhi_UnclusteredEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UnclusteredEnUp_branch
    cdef float type1_pfMet_shiftedPhi_UnclusteredEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_ElectronEnDown_branch
    cdef float type1_pfMet_shiftedPt_ElectronEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_ElectronEnUp_branch
    cdef float type1_pfMet_shiftedPt_ElectronEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEnDown_branch
    cdef float type1_pfMet_shiftedPt_JetEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEnUp_branch
    cdef float type1_pfMet_shiftedPt_JetEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetResDown_branch
    cdef float type1_pfMet_shiftedPt_JetResDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetResUp_branch
    cdef float type1_pfMet_shiftedPt_JetResUp_value

    cdef TBranch* type1_pfMet_shiftedPt_MuonEnDown_branch
    cdef float type1_pfMet_shiftedPt_MuonEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_MuonEnUp_branch
    cdef float type1_pfMet_shiftedPt_MuonEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_PhotonEnDown_branch
    cdef float type1_pfMet_shiftedPt_PhotonEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_PhotonEnUp_branch
    cdef float type1_pfMet_shiftedPt_PhotonEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_TauEnDown_branch
    cdef float type1_pfMet_shiftedPt_TauEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_TauEnUp_branch
    cdef float type1_pfMet_shiftedPt_TauEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_UnclusteredEnDown_branch
    cdef float type1_pfMet_shiftedPt_UnclusteredEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_UnclusteredEnUp_branch
    cdef float type1_pfMet_shiftedPt_UnclusteredEnUp_value

    cdef TBranch* vbfDeta_branch
    cdef float vbfDeta_value

    cdef TBranch* vbfDeta_JetEnDown_branch
    cdef float vbfDeta_JetEnDown_value

    cdef TBranch* vbfDeta_JetEnUp_branch
    cdef float vbfDeta_JetEnUp_value

    cdef TBranch* vbfDijetrap_branch
    cdef float vbfDijetrap_value

    cdef TBranch* vbfDijetrap_JetEnDown_branch
    cdef float vbfDijetrap_JetEnDown_value

    cdef TBranch* vbfDijetrap_JetEnUp_branch
    cdef float vbfDijetrap_JetEnUp_value

    cdef TBranch* vbfDphi_branch
    cdef float vbfDphi_value

    cdef TBranch* vbfDphi_JetEnDown_branch
    cdef float vbfDphi_JetEnDown_value

    cdef TBranch* vbfDphi_JetEnUp_branch
    cdef float vbfDphi_JetEnUp_value

    cdef TBranch* vbfDphihj_branch
    cdef float vbfDphihj_value

    cdef TBranch* vbfDphihj_JetEnDown_branch
    cdef float vbfDphihj_JetEnDown_value

    cdef TBranch* vbfDphihj_JetEnUp_branch
    cdef float vbfDphihj_JetEnUp_value

    cdef TBranch* vbfDphihjnomet_branch
    cdef float vbfDphihjnomet_value

    cdef TBranch* vbfDphihjnomet_JetEnDown_branch
    cdef float vbfDphihjnomet_JetEnDown_value

    cdef TBranch* vbfDphihjnomet_JetEnUp_branch
    cdef float vbfDphihjnomet_JetEnUp_value

    cdef TBranch* vbfHrap_branch
    cdef float vbfHrap_value

    cdef TBranch* vbfHrap_JetEnDown_branch
    cdef float vbfHrap_JetEnDown_value

    cdef TBranch* vbfHrap_JetEnUp_branch
    cdef float vbfHrap_JetEnUp_value

    cdef TBranch* vbfJetVeto20_branch
    cdef float vbfJetVeto20_value

    cdef TBranch* vbfJetVeto20_JetEnDown_branch
    cdef float vbfJetVeto20_JetEnDown_value

    cdef TBranch* vbfJetVeto20_JetEnUp_branch
    cdef float vbfJetVeto20_JetEnUp_value

    cdef TBranch* vbfJetVeto30_branch
    cdef float vbfJetVeto30_value

    cdef TBranch* vbfJetVeto30_JetEnDown_branch
    cdef float vbfJetVeto30_JetEnDown_value

    cdef TBranch* vbfJetVeto30_JetEnUp_branch
    cdef float vbfJetVeto30_JetEnUp_value

    cdef TBranch* vbfJetVetoTight20_branch
    cdef float vbfJetVetoTight20_value

    cdef TBranch* vbfJetVetoTight20_JetEnDown_branch
    cdef float vbfJetVetoTight20_JetEnDown_value

    cdef TBranch* vbfJetVetoTight20_JetEnUp_branch
    cdef float vbfJetVetoTight20_JetEnUp_value

    cdef TBranch* vbfJetVetoTight30_branch
    cdef float vbfJetVetoTight30_value

    cdef TBranch* vbfJetVetoTight30_JetEnDown_branch
    cdef float vbfJetVetoTight30_JetEnDown_value

    cdef TBranch* vbfJetVetoTight30_JetEnUp_branch
    cdef float vbfJetVetoTight30_JetEnUp_value

    cdef TBranch* vbfMVA_branch
    cdef float vbfMVA_value

    cdef TBranch* vbfMVA_JetEnDown_branch
    cdef float vbfMVA_JetEnDown_value

    cdef TBranch* vbfMVA_JetEnUp_branch
    cdef float vbfMVA_JetEnUp_value

    cdef TBranch* vbfMass_branch
    cdef float vbfMass_value

    cdef TBranch* vbfMass_JetEnDown_branch
    cdef float vbfMass_JetEnDown_value

    cdef TBranch* vbfMass_JetEnUp_branch
    cdef float vbfMass_JetEnUp_value

    cdef TBranch* vbfNJets_branch
    cdef float vbfNJets_value

    cdef TBranch* vbfNJets_JetEnDown_branch
    cdef float vbfNJets_JetEnDown_value

    cdef TBranch* vbfNJets_JetEnUp_branch
    cdef float vbfNJets_JetEnUp_value

    cdef TBranch* vbfVispt_branch
    cdef float vbfVispt_value

    cdef TBranch* vbfVispt_JetEnDown_branch
    cdef float vbfVispt_JetEnDown_value

    cdef TBranch* vbfVispt_JetEnUp_branch
    cdef float vbfVispt_JetEnUp_value

    cdef TBranch* vbfdijetpt_branch
    cdef float vbfdijetpt_value

    cdef TBranch* vbfdijetpt_JetEnDown_branch
    cdef float vbfdijetpt_JetEnDown_value

    cdef TBranch* vbfdijetpt_JetEnUp_branch
    cdef float vbfdijetpt_JetEnUp_value

    cdef TBranch* vbfditaupt_branch
    cdef float vbfditaupt_value

    cdef TBranch* vbfditaupt_JetEnDown_branch
    cdef float vbfditaupt_JetEnDown_value

    cdef TBranch* vbfditaupt_JetEnUp_branch
    cdef float vbfditaupt_JetEnUp_value

    cdef TBranch* vbfj1eta_branch
    cdef float vbfj1eta_value

    cdef TBranch* vbfj1eta_JetEnDown_branch
    cdef float vbfj1eta_JetEnDown_value

    cdef TBranch* vbfj1eta_JetEnUp_branch
    cdef float vbfj1eta_JetEnUp_value

    cdef TBranch* vbfj1pt_branch
    cdef float vbfj1pt_value

    cdef TBranch* vbfj1pt_JetEnDown_branch
    cdef float vbfj1pt_JetEnDown_value

    cdef TBranch* vbfj1pt_JetEnUp_branch
    cdef float vbfj1pt_JetEnUp_value

    cdef TBranch* vbfj2eta_branch
    cdef float vbfj2eta_value

    cdef TBranch* vbfj2eta_JetEnDown_branch
    cdef float vbfj2eta_JetEnDown_value

    cdef TBranch* vbfj2eta_JetEnUp_branch
    cdef float vbfj2eta_JetEnUp_value

    cdef TBranch* vbfj2pt_branch
    cdef float vbfj2pt_value

    cdef TBranch* vbfj2pt_JetEnDown_branch
    cdef float vbfj2pt_JetEnDown_value

    cdef TBranch* vbfj2pt_JetEnUp_branch
    cdef float vbfj2pt_JetEnUp_value

    cdef TBranch* idx_branch
    cdef int idx_value


    def __cinit__(self, ttree):
        #print "cinit"
        # Constructor from a ROOT.TTree
        from ROOT import AsCObject
        self.tree = <TTree*>PyCObject_AsVoidPtr(AsCObject(ttree))
        self.ientry = 0
        self.currentTreeNumber = -1
        #print self.tree.GetEntries()
        #self.load_entry(0)
        self.complained = set([])

    cdef load_entry(self, long i):
        #print "load", i
        # Load the correct tree and setup the branches
        self.localentry = self.tree.LoadTree(i)
        #print "local", self.localentry
        new_tree = self.tree.GetTree()
        #print "tree", <long>(new_tree)
        treenum = self.tree.GetTreeNumber()
        #print "num", treenum
        if treenum != self.currentTreeNumber or new_tree != self.currentTree:
            #print "New tree!"
            self.currentTree = new_tree
            self.currentTreeNumber = treenum
            self.setup_branches(new_tree)

    cdef setup_branches(self, TTree* the_tree):
        #print "setup"

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "MuTauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "MuTauTree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "MuTauTree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "MuTauTree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "MuTauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "MuTauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "MuTauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "MuTauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "MuTauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "MuTauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "MuTauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "MuTauTree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "MuTauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "MuTauTree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "MuTauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCISVVeto20Loose"
        self.bjetCISVVeto20Loose_branch = the_tree.GetBranch("bjetCISVVeto20Loose")
        #if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose" not in self.complained:
        if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose":
            warnings.warn( "MuTauTree: Expected branch bjetCISVVeto20Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Loose")
        else:
            self.bjetCISVVeto20Loose_branch.SetAddress(<void*>&self.bjetCISVVeto20Loose_value)

        #print "making bjetCISVVeto20Medium"
        self.bjetCISVVeto20Medium_branch = the_tree.GetBranch("bjetCISVVeto20Medium")
        #if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium" not in self.complained:
        if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium":
            warnings.warn( "MuTauTree: Expected branch bjetCISVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Medium")
        else:
            self.bjetCISVVeto20Medium_branch.SetAddress(<void*>&self.bjetCISVVeto20Medium_value)

        #print "making bjetCISVVeto20Tight"
        self.bjetCISVVeto20Tight_branch = the_tree.GetBranch("bjetCISVVeto20Tight")
        #if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight" not in self.complained:
        if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight":
            warnings.warn( "MuTauTree: Expected branch bjetCISVVeto20Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Tight")
        else:
            self.bjetCISVVeto20Tight_branch.SetAddress(<void*>&self.bjetCISVVeto20Tight_value)

        #print "making bjetCISVVeto30Loose"
        self.bjetCISVVeto30Loose_branch = the_tree.GetBranch("bjetCISVVeto30Loose")
        #if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose" not in self.complained:
        if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose":
            warnings.warn( "MuTauTree: Expected branch bjetCISVVeto30Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Loose")
        else:
            self.bjetCISVVeto30Loose_branch.SetAddress(<void*>&self.bjetCISVVeto30Loose_value)

        #print "making bjetCISVVeto30Medium"
        self.bjetCISVVeto30Medium_branch = the_tree.GetBranch("bjetCISVVeto30Medium")
        #if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium" not in self.complained:
        if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium":
            warnings.warn( "MuTauTree: Expected branch bjetCISVVeto30Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Medium")
        else:
            self.bjetCISVVeto30Medium_branch.SetAddress(<void*>&self.bjetCISVVeto30Medium_value)

        #print "making bjetCISVVeto30Tight"
        self.bjetCISVVeto30Tight_branch = the_tree.GetBranch("bjetCISVVeto30Tight")
        #if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight" not in self.complained:
        if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight":
            warnings.warn( "MuTauTree: Expected branch bjetCISVVeto30Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Tight")
        else:
            self.bjetCISVVeto30Tight_branch.SetAddress(<void*>&self.bjetCISVVeto30Tight_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "MuTauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making doubleEGroup"
        self.doubleEGroup_branch = the_tree.GetBranch("doubleEGroup")
        #if not self.doubleEGroup_branch and "doubleEGroup" not in self.complained:
        if not self.doubleEGroup_branch and "doubleEGroup":
            warnings.warn( "MuTauTree: Expected branch doubleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEGroup")
        else:
            self.doubleEGroup_branch.SetAddress(<void*>&self.doubleEGroup_value)

        #print "making doubleEPass"
        self.doubleEPass_branch = the_tree.GetBranch("doubleEPass")
        #if not self.doubleEPass_branch and "doubleEPass" not in self.complained:
        if not self.doubleEPass_branch and "doubleEPass":
            warnings.warn( "MuTauTree: Expected branch doubleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPass")
        else:
            self.doubleEPass_branch.SetAddress(<void*>&self.doubleEPass_value)

        #print "making doubleEPrescale"
        self.doubleEPrescale_branch = the_tree.GetBranch("doubleEPrescale")
        #if not self.doubleEPrescale_branch and "doubleEPrescale" not in self.complained:
        if not self.doubleEPrescale_branch and "doubleEPrescale":
            warnings.warn( "MuTauTree: Expected branch doubleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPrescale")
        else:
            self.doubleEPrescale_branch.SetAddress(<void*>&self.doubleEPrescale_value)

        #print "making doubleESingleMuGroup"
        self.doubleESingleMuGroup_branch = the_tree.GetBranch("doubleESingleMuGroup")
        #if not self.doubleESingleMuGroup_branch and "doubleESingleMuGroup" not in self.complained:
        if not self.doubleESingleMuGroup_branch and "doubleESingleMuGroup":
            warnings.warn( "MuTauTree: Expected branch doubleESingleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuGroup")
        else:
            self.doubleESingleMuGroup_branch.SetAddress(<void*>&self.doubleESingleMuGroup_value)

        #print "making doubleESingleMuPass"
        self.doubleESingleMuPass_branch = the_tree.GetBranch("doubleESingleMuPass")
        #if not self.doubleESingleMuPass_branch and "doubleESingleMuPass" not in self.complained:
        if not self.doubleESingleMuPass_branch and "doubleESingleMuPass":
            warnings.warn( "MuTauTree: Expected branch doubleESingleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuPass")
        else:
            self.doubleESingleMuPass_branch.SetAddress(<void*>&self.doubleESingleMuPass_value)

        #print "making doubleESingleMuPrescale"
        self.doubleESingleMuPrescale_branch = the_tree.GetBranch("doubleESingleMuPrescale")
        #if not self.doubleESingleMuPrescale_branch and "doubleESingleMuPrescale" not in self.complained:
        if not self.doubleESingleMuPrescale_branch and "doubleESingleMuPrescale":
            warnings.warn( "MuTauTree: Expected branch doubleESingleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuPrescale")
        else:
            self.doubleESingleMuPrescale_branch.SetAddress(<void*>&self.doubleESingleMuPrescale_value)

        #print "making doubleE_23_12Group"
        self.doubleE_23_12Group_branch = the_tree.GetBranch("doubleE_23_12Group")
        #if not self.doubleE_23_12Group_branch and "doubleE_23_12Group" not in self.complained:
        if not self.doubleE_23_12Group_branch and "doubleE_23_12Group":
            warnings.warn( "MuTauTree: Expected branch doubleE_23_12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Group")
        else:
            self.doubleE_23_12Group_branch.SetAddress(<void*>&self.doubleE_23_12Group_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "MuTauTree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleE_23_12Prescale"
        self.doubleE_23_12Prescale_branch = the_tree.GetBranch("doubleE_23_12Prescale")
        #if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale" not in self.complained:
        if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale":
            warnings.warn( "MuTauTree: Expected branch doubleE_23_12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Prescale")
        else:
            self.doubleE_23_12Prescale_branch.SetAddress(<void*>&self.doubleE_23_12Prescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "MuTauTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "MuTauTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "MuTauTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuSingleEGroup"
        self.doubleMuSingleEGroup_branch = the_tree.GetBranch("doubleMuSingleEGroup")
        #if not self.doubleMuSingleEGroup_branch and "doubleMuSingleEGroup" not in self.complained:
        if not self.doubleMuSingleEGroup_branch and "doubleMuSingleEGroup":
            warnings.warn( "MuTauTree: Expected branch doubleMuSingleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEGroup")
        else:
            self.doubleMuSingleEGroup_branch.SetAddress(<void*>&self.doubleMuSingleEGroup_value)

        #print "making doubleMuSingleEPass"
        self.doubleMuSingleEPass_branch = the_tree.GetBranch("doubleMuSingleEPass")
        #if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass" not in self.complained:
        if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass":
            warnings.warn( "MuTauTree: Expected branch doubleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPass")
        else:
            self.doubleMuSingleEPass_branch.SetAddress(<void*>&self.doubleMuSingleEPass_value)

        #print "making doubleMuSingleEPrescale"
        self.doubleMuSingleEPrescale_branch = the_tree.GetBranch("doubleMuSingleEPrescale")
        #if not self.doubleMuSingleEPrescale_branch and "doubleMuSingleEPrescale" not in self.complained:
        if not self.doubleMuSingleEPrescale_branch and "doubleMuSingleEPrescale":
            warnings.warn( "MuTauTree: Expected branch doubleMuSingleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPrescale")
        else:
            self.doubleMuSingleEPrescale_branch.SetAddress(<void*>&self.doubleMuSingleEPrescale_value)

        #print "making doubleTau32Group"
        self.doubleTau32Group_branch = the_tree.GetBranch("doubleTau32Group")
        #if not self.doubleTau32Group_branch and "doubleTau32Group" not in self.complained:
        if not self.doubleTau32Group_branch and "doubleTau32Group":
            warnings.warn( "MuTauTree: Expected branch doubleTau32Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau32Group")
        else:
            self.doubleTau32Group_branch.SetAddress(<void*>&self.doubleTau32Group_value)

        #print "making doubleTau32Pass"
        self.doubleTau32Pass_branch = the_tree.GetBranch("doubleTau32Pass")
        #if not self.doubleTau32Pass_branch and "doubleTau32Pass" not in self.complained:
        if not self.doubleTau32Pass_branch and "doubleTau32Pass":
            warnings.warn( "MuTauTree: Expected branch doubleTau32Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau32Pass")
        else:
            self.doubleTau32Pass_branch.SetAddress(<void*>&self.doubleTau32Pass_value)

        #print "making doubleTau32Prescale"
        self.doubleTau32Prescale_branch = the_tree.GetBranch("doubleTau32Prescale")
        #if not self.doubleTau32Prescale_branch and "doubleTau32Prescale" not in self.complained:
        if not self.doubleTau32Prescale_branch and "doubleTau32Prescale":
            warnings.warn( "MuTauTree: Expected branch doubleTau32Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau32Prescale")
        else:
            self.doubleTau32Prescale_branch.SetAddress(<void*>&self.doubleTau32Prescale_value)

        #print "making doubleTau35Group"
        self.doubleTau35Group_branch = the_tree.GetBranch("doubleTau35Group")
        #if not self.doubleTau35Group_branch and "doubleTau35Group" not in self.complained:
        if not self.doubleTau35Group_branch and "doubleTau35Group":
            warnings.warn( "MuTauTree: Expected branch doubleTau35Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Group")
        else:
            self.doubleTau35Group_branch.SetAddress(<void*>&self.doubleTau35Group_value)

        #print "making doubleTau35Pass"
        self.doubleTau35Pass_branch = the_tree.GetBranch("doubleTau35Pass")
        #if not self.doubleTau35Pass_branch and "doubleTau35Pass" not in self.complained:
        if not self.doubleTau35Pass_branch and "doubleTau35Pass":
            warnings.warn( "MuTauTree: Expected branch doubleTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Pass")
        else:
            self.doubleTau35Pass_branch.SetAddress(<void*>&self.doubleTau35Pass_value)

        #print "making doubleTau35Prescale"
        self.doubleTau35Prescale_branch = the_tree.GetBranch("doubleTau35Prescale")
        #if not self.doubleTau35Prescale_branch and "doubleTau35Prescale" not in self.complained:
        if not self.doubleTau35Prescale_branch and "doubleTau35Prescale":
            warnings.warn( "MuTauTree: Expected branch doubleTau35Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Prescale")
        else:
            self.doubleTau35Prescale_branch.SetAddress(<void*>&self.doubleTau35Prescale_value)

        #print "making doubleTau40Group"
        self.doubleTau40Group_branch = the_tree.GetBranch("doubleTau40Group")
        #if not self.doubleTau40Group_branch and "doubleTau40Group" not in self.complained:
        if not self.doubleTau40Group_branch and "doubleTau40Group":
            warnings.warn( "MuTauTree: Expected branch doubleTau40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau40Group")
        else:
            self.doubleTau40Group_branch.SetAddress(<void*>&self.doubleTau40Group_value)

        #print "making doubleTau40Pass"
        self.doubleTau40Pass_branch = the_tree.GetBranch("doubleTau40Pass")
        #if not self.doubleTau40Pass_branch and "doubleTau40Pass" not in self.complained:
        if not self.doubleTau40Pass_branch and "doubleTau40Pass":
            warnings.warn( "MuTauTree: Expected branch doubleTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau40Pass")
        else:
            self.doubleTau40Pass_branch.SetAddress(<void*>&self.doubleTau40Pass_value)

        #print "making doubleTau40Prescale"
        self.doubleTau40Prescale_branch = the_tree.GetBranch("doubleTau40Prescale")
        #if not self.doubleTau40Prescale_branch and "doubleTau40Prescale" not in self.complained:
        if not self.doubleTau40Prescale_branch and "doubleTau40Prescale":
            warnings.warn( "MuTauTree: Expected branch doubleTau40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau40Prescale")
        else:
            self.doubleTau40Prescale_branch.SetAddress(<void*>&self.doubleTau40Prescale_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "MuTauTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "MuTauTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "MuTauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "MuTauTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "MuTauTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "MuTauTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "MuTauTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "MuTauTree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "MuTauTree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "MuTauTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "MuTauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making jet1BJetCISV"
        self.jet1BJetCISV_branch = the_tree.GetBranch("jet1BJetCISV")
        #if not self.jet1BJetCISV_branch and "jet1BJetCISV" not in self.complained:
        if not self.jet1BJetCISV_branch and "jet1BJetCISV":
            warnings.warn( "MuTauTree: Expected branch jet1BJetCISV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet1BJetCISV")
        else:
            self.jet1BJetCISV_branch.SetAddress(<void*>&self.jet1BJetCISV_value)

        #print "making jet1Eta"
        self.jet1Eta_branch = the_tree.GetBranch("jet1Eta")
        #if not self.jet1Eta_branch and "jet1Eta" not in self.complained:
        if not self.jet1Eta_branch and "jet1Eta":
            warnings.warn( "MuTauTree: Expected branch jet1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet1Eta")
        else:
            self.jet1Eta_branch.SetAddress(<void*>&self.jet1Eta_value)

        #print "making jet1IDLoose"
        self.jet1IDLoose_branch = the_tree.GetBranch("jet1IDLoose")
        #if not self.jet1IDLoose_branch and "jet1IDLoose" not in self.complained:
        if not self.jet1IDLoose_branch and "jet1IDLoose":
            warnings.warn( "MuTauTree: Expected branch jet1IDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet1IDLoose")
        else:
            self.jet1IDLoose_branch.SetAddress(<void*>&self.jet1IDLoose_value)

        #print "making jet1IDTight"
        self.jet1IDTight_branch = the_tree.GetBranch("jet1IDTight")
        #if not self.jet1IDTight_branch and "jet1IDTight" not in self.complained:
        if not self.jet1IDTight_branch and "jet1IDTight":
            warnings.warn( "MuTauTree: Expected branch jet1IDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet1IDTight")
        else:
            self.jet1IDTight_branch.SetAddress(<void*>&self.jet1IDTight_value)

        #print "making jet1IDTightLepVeto"
        self.jet1IDTightLepVeto_branch = the_tree.GetBranch("jet1IDTightLepVeto")
        #if not self.jet1IDTightLepVeto_branch and "jet1IDTightLepVeto" not in self.complained:
        if not self.jet1IDTightLepVeto_branch and "jet1IDTightLepVeto":
            warnings.warn( "MuTauTree: Expected branch jet1IDTightLepVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet1IDTightLepVeto")
        else:
            self.jet1IDTightLepVeto_branch.SetAddress(<void*>&self.jet1IDTightLepVeto_value)

        #print "making jet1PUMVA"
        self.jet1PUMVA_branch = the_tree.GetBranch("jet1PUMVA")
        #if not self.jet1PUMVA_branch and "jet1PUMVA" not in self.complained:
        if not self.jet1PUMVA_branch and "jet1PUMVA":
            warnings.warn( "MuTauTree: Expected branch jet1PUMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet1PUMVA")
        else:
            self.jet1PUMVA_branch.SetAddress(<void*>&self.jet1PUMVA_value)

        #print "making jet1Phi"
        self.jet1Phi_branch = the_tree.GetBranch("jet1Phi")
        #if not self.jet1Phi_branch and "jet1Phi" not in self.complained:
        if not self.jet1Phi_branch and "jet1Phi":
            warnings.warn( "MuTauTree: Expected branch jet1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet1Phi")
        else:
            self.jet1Phi_branch.SetAddress(<void*>&self.jet1Phi_value)

        #print "making jet1Pt"
        self.jet1Pt_branch = the_tree.GetBranch("jet1Pt")
        #if not self.jet1Pt_branch and "jet1Pt" not in self.complained:
        if not self.jet1Pt_branch and "jet1Pt":
            warnings.warn( "MuTauTree: Expected branch jet1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet1Pt")
        else:
            self.jet1Pt_branch.SetAddress(<void*>&self.jet1Pt_value)

        #print "making jet2BJetCISV"
        self.jet2BJetCISV_branch = the_tree.GetBranch("jet2BJetCISV")
        #if not self.jet2BJetCISV_branch and "jet2BJetCISV" not in self.complained:
        if not self.jet2BJetCISV_branch and "jet2BJetCISV":
            warnings.warn( "MuTauTree: Expected branch jet2BJetCISV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet2BJetCISV")
        else:
            self.jet2BJetCISV_branch.SetAddress(<void*>&self.jet2BJetCISV_value)

        #print "making jet2Eta"
        self.jet2Eta_branch = the_tree.GetBranch("jet2Eta")
        #if not self.jet2Eta_branch and "jet2Eta" not in self.complained:
        if not self.jet2Eta_branch and "jet2Eta":
            warnings.warn( "MuTauTree: Expected branch jet2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet2Eta")
        else:
            self.jet2Eta_branch.SetAddress(<void*>&self.jet2Eta_value)

        #print "making jet2IDLoose"
        self.jet2IDLoose_branch = the_tree.GetBranch("jet2IDLoose")
        #if not self.jet2IDLoose_branch and "jet2IDLoose" not in self.complained:
        if not self.jet2IDLoose_branch and "jet2IDLoose":
            warnings.warn( "MuTauTree: Expected branch jet2IDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet2IDLoose")
        else:
            self.jet2IDLoose_branch.SetAddress(<void*>&self.jet2IDLoose_value)

        #print "making jet2IDTight"
        self.jet2IDTight_branch = the_tree.GetBranch("jet2IDTight")
        #if not self.jet2IDTight_branch and "jet2IDTight" not in self.complained:
        if not self.jet2IDTight_branch and "jet2IDTight":
            warnings.warn( "MuTauTree: Expected branch jet2IDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet2IDTight")
        else:
            self.jet2IDTight_branch.SetAddress(<void*>&self.jet2IDTight_value)

        #print "making jet2IDTightLepVeto"
        self.jet2IDTightLepVeto_branch = the_tree.GetBranch("jet2IDTightLepVeto")
        #if not self.jet2IDTightLepVeto_branch and "jet2IDTightLepVeto" not in self.complained:
        if not self.jet2IDTightLepVeto_branch and "jet2IDTightLepVeto":
            warnings.warn( "MuTauTree: Expected branch jet2IDTightLepVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet2IDTightLepVeto")
        else:
            self.jet2IDTightLepVeto_branch.SetAddress(<void*>&self.jet2IDTightLepVeto_value)

        #print "making jet2PUMVA"
        self.jet2PUMVA_branch = the_tree.GetBranch("jet2PUMVA")
        #if not self.jet2PUMVA_branch and "jet2PUMVA" not in self.complained:
        if not self.jet2PUMVA_branch and "jet2PUMVA":
            warnings.warn( "MuTauTree: Expected branch jet2PUMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet2PUMVA")
        else:
            self.jet2PUMVA_branch.SetAddress(<void*>&self.jet2PUMVA_value)

        #print "making jet2Phi"
        self.jet2Phi_branch = the_tree.GetBranch("jet2Phi")
        #if not self.jet2Phi_branch and "jet2Phi" not in self.complained:
        if not self.jet2Phi_branch and "jet2Phi":
            warnings.warn( "MuTauTree: Expected branch jet2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet2Phi")
        else:
            self.jet2Phi_branch.SetAddress(<void*>&self.jet2Phi_value)

        #print "making jet2Pt"
        self.jet2Pt_branch = the_tree.GetBranch("jet2Pt")
        #if not self.jet2Pt_branch and "jet2Pt" not in self.complained:
        if not self.jet2Pt_branch and "jet2Pt":
            warnings.warn( "MuTauTree: Expected branch jet2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet2Pt")
        else:
            self.jet2Pt_branch.SetAddress(<void*>&self.jet2Pt_value)

        #print "making jet3BJetCISV"
        self.jet3BJetCISV_branch = the_tree.GetBranch("jet3BJetCISV")
        #if not self.jet3BJetCISV_branch and "jet3BJetCISV" not in self.complained:
        if not self.jet3BJetCISV_branch and "jet3BJetCISV":
            warnings.warn( "MuTauTree: Expected branch jet3BJetCISV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet3BJetCISV")
        else:
            self.jet3BJetCISV_branch.SetAddress(<void*>&self.jet3BJetCISV_value)

        #print "making jet3Eta"
        self.jet3Eta_branch = the_tree.GetBranch("jet3Eta")
        #if not self.jet3Eta_branch and "jet3Eta" not in self.complained:
        if not self.jet3Eta_branch and "jet3Eta":
            warnings.warn( "MuTauTree: Expected branch jet3Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet3Eta")
        else:
            self.jet3Eta_branch.SetAddress(<void*>&self.jet3Eta_value)

        #print "making jet3IDLoose"
        self.jet3IDLoose_branch = the_tree.GetBranch("jet3IDLoose")
        #if not self.jet3IDLoose_branch and "jet3IDLoose" not in self.complained:
        if not self.jet3IDLoose_branch and "jet3IDLoose":
            warnings.warn( "MuTauTree: Expected branch jet3IDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet3IDLoose")
        else:
            self.jet3IDLoose_branch.SetAddress(<void*>&self.jet3IDLoose_value)

        #print "making jet3IDTight"
        self.jet3IDTight_branch = the_tree.GetBranch("jet3IDTight")
        #if not self.jet3IDTight_branch and "jet3IDTight" not in self.complained:
        if not self.jet3IDTight_branch and "jet3IDTight":
            warnings.warn( "MuTauTree: Expected branch jet3IDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet3IDTight")
        else:
            self.jet3IDTight_branch.SetAddress(<void*>&self.jet3IDTight_value)

        #print "making jet3IDTightLepVeto"
        self.jet3IDTightLepVeto_branch = the_tree.GetBranch("jet3IDTightLepVeto")
        #if not self.jet3IDTightLepVeto_branch and "jet3IDTightLepVeto" not in self.complained:
        if not self.jet3IDTightLepVeto_branch and "jet3IDTightLepVeto":
            warnings.warn( "MuTauTree: Expected branch jet3IDTightLepVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet3IDTightLepVeto")
        else:
            self.jet3IDTightLepVeto_branch.SetAddress(<void*>&self.jet3IDTightLepVeto_value)

        #print "making jet3PUMVA"
        self.jet3PUMVA_branch = the_tree.GetBranch("jet3PUMVA")
        #if not self.jet3PUMVA_branch and "jet3PUMVA" not in self.complained:
        if not self.jet3PUMVA_branch and "jet3PUMVA":
            warnings.warn( "MuTauTree: Expected branch jet3PUMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet3PUMVA")
        else:
            self.jet3PUMVA_branch.SetAddress(<void*>&self.jet3PUMVA_value)

        #print "making jet3Phi"
        self.jet3Phi_branch = the_tree.GetBranch("jet3Phi")
        #if not self.jet3Phi_branch and "jet3Phi" not in self.complained:
        if not self.jet3Phi_branch and "jet3Phi":
            warnings.warn( "MuTauTree: Expected branch jet3Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet3Phi")
        else:
            self.jet3Phi_branch.SetAddress(<void*>&self.jet3Phi_value)

        #print "making jet3Pt"
        self.jet3Pt_branch = the_tree.GetBranch("jet3Pt")
        #if not self.jet3Pt_branch and "jet3Pt" not in self.complained:
        if not self.jet3Pt_branch and "jet3Pt":
            warnings.warn( "MuTauTree: Expected branch jet3Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet3Pt")
        else:
            self.jet3Pt_branch.SetAddress(<void*>&self.jet3Pt_value)

        #print "making jet4BJetCISV"
        self.jet4BJetCISV_branch = the_tree.GetBranch("jet4BJetCISV")
        #if not self.jet4BJetCISV_branch and "jet4BJetCISV" not in self.complained:
        if not self.jet4BJetCISV_branch and "jet4BJetCISV":
            warnings.warn( "MuTauTree: Expected branch jet4BJetCISV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet4BJetCISV")
        else:
            self.jet4BJetCISV_branch.SetAddress(<void*>&self.jet4BJetCISV_value)

        #print "making jet4Eta"
        self.jet4Eta_branch = the_tree.GetBranch("jet4Eta")
        #if not self.jet4Eta_branch and "jet4Eta" not in self.complained:
        if not self.jet4Eta_branch and "jet4Eta":
            warnings.warn( "MuTauTree: Expected branch jet4Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet4Eta")
        else:
            self.jet4Eta_branch.SetAddress(<void*>&self.jet4Eta_value)

        #print "making jet4IDLoose"
        self.jet4IDLoose_branch = the_tree.GetBranch("jet4IDLoose")
        #if not self.jet4IDLoose_branch and "jet4IDLoose" not in self.complained:
        if not self.jet4IDLoose_branch and "jet4IDLoose":
            warnings.warn( "MuTauTree: Expected branch jet4IDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet4IDLoose")
        else:
            self.jet4IDLoose_branch.SetAddress(<void*>&self.jet4IDLoose_value)

        #print "making jet4IDTight"
        self.jet4IDTight_branch = the_tree.GetBranch("jet4IDTight")
        #if not self.jet4IDTight_branch and "jet4IDTight" not in self.complained:
        if not self.jet4IDTight_branch and "jet4IDTight":
            warnings.warn( "MuTauTree: Expected branch jet4IDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet4IDTight")
        else:
            self.jet4IDTight_branch.SetAddress(<void*>&self.jet4IDTight_value)

        #print "making jet4IDTightLepVeto"
        self.jet4IDTightLepVeto_branch = the_tree.GetBranch("jet4IDTightLepVeto")
        #if not self.jet4IDTightLepVeto_branch and "jet4IDTightLepVeto" not in self.complained:
        if not self.jet4IDTightLepVeto_branch and "jet4IDTightLepVeto":
            warnings.warn( "MuTauTree: Expected branch jet4IDTightLepVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet4IDTightLepVeto")
        else:
            self.jet4IDTightLepVeto_branch.SetAddress(<void*>&self.jet4IDTightLepVeto_value)

        #print "making jet4PUMVA"
        self.jet4PUMVA_branch = the_tree.GetBranch("jet4PUMVA")
        #if not self.jet4PUMVA_branch and "jet4PUMVA" not in self.complained:
        if not self.jet4PUMVA_branch and "jet4PUMVA":
            warnings.warn( "MuTauTree: Expected branch jet4PUMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet4PUMVA")
        else:
            self.jet4PUMVA_branch.SetAddress(<void*>&self.jet4PUMVA_value)

        #print "making jet4Phi"
        self.jet4Phi_branch = the_tree.GetBranch("jet4Phi")
        #if not self.jet4Phi_branch and "jet4Phi" not in self.complained:
        if not self.jet4Phi_branch and "jet4Phi":
            warnings.warn( "MuTauTree: Expected branch jet4Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet4Phi")
        else:
            self.jet4Phi_branch.SetAddress(<void*>&self.jet4Phi_value)

        #print "making jet4Pt"
        self.jet4Pt_branch = the_tree.GetBranch("jet4Pt")
        #if not self.jet4Pt_branch and "jet4Pt" not in self.complained:
        if not self.jet4Pt_branch and "jet4Pt":
            warnings.warn( "MuTauTree: Expected branch jet4Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet4Pt")
        else:
            self.jet4Pt_branch.SetAddress(<void*>&self.jet4Pt_value)

        #print "making jet5BJetCISV"
        self.jet5BJetCISV_branch = the_tree.GetBranch("jet5BJetCISV")
        #if not self.jet5BJetCISV_branch and "jet5BJetCISV" not in self.complained:
        if not self.jet5BJetCISV_branch and "jet5BJetCISV":
            warnings.warn( "MuTauTree: Expected branch jet5BJetCISV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet5BJetCISV")
        else:
            self.jet5BJetCISV_branch.SetAddress(<void*>&self.jet5BJetCISV_value)

        #print "making jet5Eta"
        self.jet5Eta_branch = the_tree.GetBranch("jet5Eta")
        #if not self.jet5Eta_branch and "jet5Eta" not in self.complained:
        if not self.jet5Eta_branch and "jet5Eta":
            warnings.warn( "MuTauTree: Expected branch jet5Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet5Eta")
        else:
            self.jet5Eta_branch.SetAddress(<void*>&self.jet5Eta_value)

        #print "making jet5IDLoose"
        self.jet5IDLoose_branch = the_tree.GetBranch("jet5IDLoose")
        #if not self.jet5IDLoose_branch and "jet5IDLoose" not in self.complained:
        if not self.jet5IDLoose_branch and "jet5IDLoose":
            warnings.warn( "MuTauTree: Expected branch jet5IDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet5IDLoose")
        else:
            self.jet5IDLoose_branch.SetAddress(<void*>&self.jet5IDLoose_value)

        #print "making jet5IDTight"
        self.jet5IDTight_branch = the_tree.GetBranch("jet5IDTight")
        #if not self.jet5IDTight_branch and "jet5IDTight" not in self.complained:
        if not self.jet5IDTight_branch and "jet5IDTight":
            warnings.warn( "MuTauTree: Expected branch jet5IDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet5IDTight")
        else:
            self.jet5IDTight_branch.SetAddress(<void*>&self.jet5IDTight_value)

        #print "making jet5IDTightLepVeto"
        self.jet5IDTightLepVeto_branch = the_tree.GetBranch("jet5IDTightLepVeto")
        #if not self.jet5IDTightLepVeto_branch and "jet5IDTightLepVeto" not in self.complained:
        if not self.jet5IDTightLepVeto_branch and "jet5IDTightLepVeto":
            warnings.warn( "MuTauTree: Expected branch jet5IDTightLepVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet5IDTightLepVeto")
        else:
            self.jet5IDTightLepVeto_branch.SetAddress(<void*>&self.jet5IDTightLepVeto_value)

        #print "making jet5PUMVA"
        self.jet5PUMVA_branch = the_tree.GetBranch("jet5PUMVA")
        #if not self.jet5PUMVA_branch and "jet5PUMVA" not in self.complained:
        if not self.jet5PUMVA_branch and "jet5PUMVA":
            warnings.warn( "MuTauTree: Expected branch jet5PUMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet5PUMVA")
        else:
            self.jet5PUMVA_branch.SetAddress(<void*>&self.jet5PUMVA_value)

        #print "making jet5Phi"
        self.jet5Phi_branch = the_tree.GetBranch("jet5Phi")
        #if not self.jet5Phi_branch and "jet5Phi" not in self.complained:
        if not self.jet5Phi_branch and "jet5Phi":
            warnings.warn( "MuTauTree: Expected branch jet5Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet5Phi")
        else:
            self.jet5Phi_branch.SetAddress(<void*>&self.jet5Phi_value)

        #print "making jet5Pt"
        self.jet5Pt_branch = the_tree.GetBranch("jet5Pt")
        #if not self.jet5Pt_branch and "jet5Pt" not in self.complained:
        if not self.jet5Pt_branch and "jet5Pt":
            warnings.warn( "MuTauTree: Expected branch jet5Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet5Pt")
        else:
            self.jet5Pt_branch.SetAddress(<void*>&self.jet5Pt_value)

        #print "making jet6BJetCISV"
        self.jet6BJetCISV_branch = the_tree.GetBranch("jet6BJetCISV")
        #if not self.jet6BJetCISV_branch and "jet6BJetCISV" not in self.complained:
        if not self.jet6BJetCISV_branch and "jet6BJetCISV":
            warnings.warn( "MuTauTree: Expected branch jet6BJetCISV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet6BJetCISV")
        else:
            self.jet6BJetCISV_branch.SetAddress(<void*>&self.jet6BJetCISV_value)

        #print "making jet6Eta"
        self.jet6Eta_branch = the_tree.GetBranch("jet6Eta")
        #if not self.jet6Eta_branch and "jet6Eta" not in self.complained:
        if not self.jet6Eta_branch and "jet6Eta":
            warnings.warn( "MuTauTree: Expected branch jet6Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet6Eta")
        else:
            self.jet6Eta_branch.SetAddress(<void*>&self.jet6Eta_value)

        #print "making jet6IDLoose"
        self.jet6IDLoose_branch = the_tree.GetBranch("jet6IDLoose")
        #if not self.jet6IDLoose_branch and "jet6IDLoose" not in self.complained:
        if not self.jet6IDLoose_branch and "jet6IDLoose":
            warnings.warn( "MuTauTree: Expected branch jet6IDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet6IDLoose")
        else:
            self.jet6IDLoose_branch.SetAddress(<void*>&self.jet6IDLoose_value)

        #print "making jet6IDTight"
        self.jet6IDTight_branch = the_tree.GetBranch("jet6IDTight")
        #if not self.jet6IDTight_branch and "jet6IDTight" not in self.complained:
        if not self.jet6IDTight_branch and "jet6IDTight":
            warnings.warn( "MuTauTree: Expected branch jet6IDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet6IDTight")
        else:
            self.jet6IDTight_branch.SetAddress(<void*>&self.jet6IDTight_value)

        #print "making jet6IDTightLepVeto"
        self.jet6IDTightLepVeto_branch = the_tree.GetBranch("jet6IDTightLepVeto")
        #if not self.jet6IDTightLepVeto_branch and "jet6IDTightLepVeto" not in self.complained:
        if not self.jet6IDTightLepVeto_branch and "jet6IDTightLepVeto":
            warnings.warn( "MuTauTree: Expected branch jet6IDTightLepVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet6IDTightLepVeto")
        else:
            self.jet6IDTightLepVeto_branch.SetAddress(<void*>&self.jet6IDTightLepVeto_value)

        #print "making jet6PUMVA"
        self.jet6PUMVA_branch = the_tree.GetBranch("jet6PUMVA")
        #if not self.jet6PUMVA_branch and "jet6PUMVA" not in self.complained:
        if not self.jet6PUMVA_branch and "jet6PUMVA":
            warnings.warn( "MuTauTree: Expected branch jet6PUMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet6PUMVA")
        else:
            self.jet6PUMVA_branch.SetAddress(<void*>&self.jet6PUMVA_value)

        #print "making jet6Phi"
        self.jet6Phi_branch = the_tree.GetBranch("jet6Phi")
        #if not self.jet6Phi_branch and "jet6Phi" not in self.complained:
        if not self.jet6Phi_branch and "jet6Phi":
            warnings.warn( "MuTauTree: Expected branch jet6Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet6Phi")
        else:
            self.jet6Phi_branch.SetAddress(<void*>&self.jet6Phi_value)

        #print "making jet6Pt"
        self.jet6Pt_branch = the_tree.GetBranch("jet6Pt")
        #if not self.jet6Pt_branch and "jet6Pt" not in self.complained:
        if not self.jet6Pt_branch and "jet6Pt":
            warnings.warn( "MuTauTree: Expected branch jet6Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet6Pt")
        else:
            self.jet6Pt_branch.SetAddress(<void*>&self.jet6Pt_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "MuTauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_DR05"
        self.jetVeto20_DR05_branch = the_tree.GetBranch("jetVeto20_DR05")
        #if not self.jetVeto20_DR05_branch and "jetVeto20_DR05" not in self.complained:
        if not self.jetVeto20_DR05_branch and "jetVeto20_DR05":
            warnings.warn( "MuTauTree: Expected branch jetVeto20_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_DR05")
        else:
            self.jetVeto20_DR05_branch.SetAddress(<void*>&self.jetVeto20_DR05_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "MuTauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30Eta3"
        self.jetVeto30Eta3_branch = the_tree.GetBranch("jetVeto30Eta3")
        #if not self.jetVeto30Eta3_branch and "jetVeto30Eta3" not in self.complained:
        if not self.jetVeto30Eta3_branch and "jetVeto30Eta3":
            warnings.warn( "MuTauTree: Expected branch jetVeto30Eta3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30Eta3")
        else:
            self.jetVeto30Eta3_branch.SetAddress(<void*>&self.jetVeto30Eta3_value)

        #print "making jetVeto30Eta3_JetEnDown"
        self.jetVeto30Eta3_JetEnDown_branch = the_tree.GetBranch("jetVeto30Eta3_JetEnDown")
        #if not self.jetVeto30Eta3_JetEnDown_branch and "jetVeto30Eta3_JetEnDown" not in self.complained:
        if not self.jetVeto30Eta3_JetEnDown_branch and "jetVeto30Eta3_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30Eta3_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30Eta3_JetEnDown")
        else:
            self.jetVeto30Eta3_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30Eta3_JetEnDown_value)

        #print "making jetVeto30Eta3_JetEnUp"
        self.jetVeto30Eta3_JetEnUp_branch = the_tree.GetBranch("jetVeto30Eta3_JetEnUp")
        #if not self.jetVeto30Eta3_JetEnUp_branch and "jetVeto30Eta3_JetEnUp" not in self.complained:
        if not self.jetVeto30Eta3_JetEnUp_branch and "jetVeto30Eta3_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30Eta3_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30Eta3_JetEnUp")
        else:
            self.jetVeto30Eta3_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30Eta3_JetEnUp_value)

        #print "making jetVeto30_DR05"
        self.jetVeto30_DR05_branch = the_tree.GetBranch("jetVeto30_DR05")
        #if not self.jetVeto30_DR05_branch and "jetVeto30_DR05" not in self.complained:
        if not self.jetVeto30_DR05_branch and "jetVeto30_DR05":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_DR05")
        else:
            self.jetVeto30_DR05_branch.SetAddress(<void*>&self.jetVeto30_DR05_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making jetVeto40"
        self.jetVeto40_branch = the_tree.GetBranch("jetVeto40")
        #if not self.jetVeto40_branch and "jetVeto40" not in self.complained:
        if not self.jetVeto40_branch and "jetVeto40":
            warnings.warn( "MuTauTree: Expected branch jetVeto40 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40")
        else:
            self.jetVeto40_branch.SetAddress(<void*>&self.jetVeto40_value)

        #print "making jetVeto40_DR05"
        self.jetVeto40_DR05_branch = the_tree.GetBranch("jetVeto40_DR05")
        #if not self.jetVeto40_DR05_branch and "jetVeto40_DR05" not in self.complained:
        if not self.jetVeto40_DR05_branch and "jetVeto40_DR05":
            warnings.warn( "MuTauTree: Expected branch jetVeto40_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40_DR05")
        else:
            self.jetVeto40_DR05_branch.SetAddress(<void*>&self.jetVeto40_DR05_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "MuTauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making mAbsEta"
        self.mAbsEta_branch = the_tree.GetBranch("mAbsEta")
        #if not self.mAbsEta_branch and "mAbsEta" not in self.complained:
        if not self.mAbsEta_branch and "mAbsEta":
            warnings.warn( "MuTauTree: Expected branch mAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mAbsEta")
        else:
            self.mAbsEta_branch.SetAddress(<void*>&self.mAbsEta_value)

        #print "making mBestTrackType"
        self.mBestTrackType_branch = the_tree.GetBranch("mBestTrackType")
        #if not self.mBestTrackType_branch and "mBestTrackType" not in self.complained:
        if not self.mBestTrackType_branch and "mBestTrackType":
            warnings.warn( "MuTauTree: Expected branch mBestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mBestTrackType")
        else:
            self.mBestTrackType_branch.SetAddress(<void*>&self.mBestTrackType_value)

        #print "making mCharge"
        self.mCharge_branch = the_tree.GetBranch("mCharge")
        #if not self.mCharge_branch and "mCharge" not in self.complained:
        if not self.mCharge_branch and "mCharge":
            warnings.warn( "MuTauTree: Expected branch mCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mCharge")
        else:
            self.mCharge_branch.SetAddress(<void*>&self.mCharge_value)

        #print "making mComesFromHiggs"
        self.mComesFromHiggs_branch = the_tree.GetBranch("mComesFromHiggs")
        #if not self.mComesFromHiggs_branch and "mComesFromHiggs" not in self.complained:
        if not self.mComesFromHiggs_branch and "mComesFromHiggs":
            warnings.warn( "MuTauTree: Expected branch mComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mComesFromHiggs")
        else:
            self.mComesFromHiggs_branch.SetAddress(<void*>&self.mComesFromHiggs_value)

        #print "making mDPhiToPfMet_ElectronEnDown"
        self.mDPhiToPfMet_ElectronEnDown_branch = the_tree.GetBranch("mDPhiToPfMet_ElectronEnDown")
        #if not self.mDPhiToPfMet_ElectronEnDown_branch and "mDPhiToPfMet_ElectronEnDown" not in self.complained:
        if not self.mDPhiToPfMet_ElectronEnDown_branch and "mDPhiToPfMet_ElectronEnDown":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_ElectronEnDown")
        else:
            self.mDPhiToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.mDPhiToPfMet_ElectronEnDown_value)

        #print "making mDPhiToPfMet_ElectronEnUp"
        self.mDPhiToPfMet_ElectronEnUp_branch = the_tree.GetBranch("mDPhiToPfMet_ElectronEnUp")
        #if not self.mDPhiToPfMet_ElectronEnUp_branch and "mDPhiToPfMet_ElectronEnUp" not in self.complained:
        if not self.mDPhiToPfMet_ElectronEnUp_branch and "mDPhiToPfMet_ElectronEnUp":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_ElectronEnUp")
        else:
            self.mDPhiToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.mDPhiToPfMet_ElectronEnUp_value)

        #print "making mDPhiToPfMet_JetEnDown"
        self.mDPhiToPfMet_JetEnDown_branch = the_tree.GetBranch("mDPhiToPfMet_JetEnDown")
        #if not self.mDPhiToPfMet_JetEnDown_branch and "mDPhiToPfMet_JetEnDown" not in self.complained:
        if not self.mDPhiToPfMet_JetEnDown_branch and "mDPhiToPfMet_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_JetEnDown")
        else:
            self.mDPhiToPfMet_JetEnDown_branch.SetAddress(<void*>&self.mDPhiToPfMet_JetEnDown_value)

        #print "making mDPhiToPfMet_JetEnUp"
        self.mDPhiToPfMet_JetEnUp_branch = the_tree.GetBranch("mDPhiToPfMet_JetEnUp")
        #if not self.mDPhiToPfMet_JetEnUp_branch and "mDPhiToPfMet_JetEnUp" not in self.complained:
        if not self.mDPhiToPfMet_JetEnUp_branch and "mDPhiToPfMet_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_JetEnUp")
        else:
            self.mDPhiToPfMet_JetEnUp_branch.SetAddress(<void*>&self.mDPhiToPfMet_JetEnUp_value)

        #print "making mDPhiToPfMet_JetResDown"
        self.mDPhiToPfMet_JetResDown_branch = the_tree.GetBranch("mDPhiToPfMet_JetResDown")
        #if not self.mDPhiToPfMet_JetResDown_branch and "mDPhiToPfMet_JetResDown" not in self.complained:
        if not self.mDPhiToPfMet_JetResDown_branch and "mDPhiToPfMet_JetResDown":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_JetResDown")
        else:
            self.mDPhiToPfMet_JetResDown_branch.SetAddress(<void*>&self.mDPhiToPfMet_JetResDown_value)

        #print "making mDPhiToPfMet_JetResUp"
        self.mDPhiToPfMet_JetResUp_branch = the_tree.GetBranch("mDPhiToPfMet_JetResUp")
        #if not self.mDPhiToPfMet_JetResUp_branch and "mDPhiToPfMet_JetResUp" not in self.complained:
        if not self.mDPhiToPfMet_JetResUp_branch and "mDPhiToPfMet_JetResUp":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_JetResUp")
        else:
            self.mDPhiToPfMet_JetResUp_branch.SetAddress(<void*>&self.mDPhiToPfMet_JetResUp_value)

        #print "making mDPhiToPfMet_MuonEnDown"
        self.mDPhiToPfMet_MuonEnDown_branch = the_tree.GetBranch("mDPhiToPfMet_MuonEnDown")
        #if not self.mDPhiToPfMet_MuonEnDown_branch and "mDPhiToPfMet_MuonEnDown" not in self.complained:
        if not self.mDPhiToPfMet_MuonEnDown_branch and "mDPhiToPfMet_MuonEnDown":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_MuonEnDown")
        else:
            self.mDPhiToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.mDPhiToPfMet_MuonEnDown_value)

        #print "making mDPhiToPfMet_MuonEnUp"
        self.mDPhiToPfMet_MuonEnUp_branch = the_tree.GetBranch("mDPhiToPfMet_MuonEnUp")
        #if not self.mDPhiToPfMet_MuonEnUp_branch and "mDPhiToPfMet_MuonEnUp" not in self.complained:
        if not self.mDPhiToPfMet_MuonEnUp_branch and "mDPhiToPfMet_MuonEnUp":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_MuonEnUp")
        else:
            self.mDPhiToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.mDPhiToPfMet_MuonEnUp_value)

        #print "making mDPhiToPfMet_PhotonEnDown"
        self.mDPhiToPfMet_PhotonEnDown_branch = the_tree.GetBranch("mDPhiToPfMet_PhotonEnDown")
        #if not self.mDPhiToPfMet_PhotonEnDown_branch and "mDPhiToPfMet_PhotonEnDown" not in self.complained:
        if not self.mDPhiToPfMet_PhotonEnDown_branch and "mDPhiToPfMet_PhotonEnDown":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_PhotonEnDown")
        else:
            self.mDPhiToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.mDPhiToPfMet_PhotonEnDown_value)

        #print "making mDPhiToPfMet_PhotonEnUp"
        self.mDPhiToPfMet_PhotonEnUp_branch = the_tree.GetBranch("mDPhiToPfMet_PhotonEnUp")
        #if not self.mDPhiToPfMet_PhotonEnUp_branch and "mDPhiToPfMet_PhotonEnUp" not in self.complained:
        if not self.mDPhiToPfMet_PhotonEnUp_branch and "mDPhiToPfMet_PhotonEnUp":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_PhotonEnUp")
        else:
            self.mDPhiToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.mDPhiToPfMet_PhotonEnUp_value)

        #print "making mDPhiToPfMet_TauEnDown"
        self.mDPhiToPfMet_TauEnDown_branch = the_tree.GetBranch("mDPhiToPfMet_TauEnDown")
        #if not self.mDPhiToPfMet_TauEnDown_branch and "mDPhiToPfMet_TauEnDown" not in self.complained:
        if not self.mDPhiToPfMet_TauEnDown_branch and "mDPhiToPfMet_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_TauEnDown")
        else:
            self.mDPhiToPfMet_TauEnDown_branch.SetAddress(<void*>&self.mDPhiToPfMet_TauEnDown_value)

        #print "making mDPhiToPfMet_TauEnUp"
        self.mDPhiToPfMet_TauEnUp_branch = the_tree.GetBranch("mDPhiToPfMet_TauEnUp")
        #if not self.mDPhiToPfMet_TauEnUp_branch and "mDPhiToPfMet_TauEnUp" not in self.complained:
        if not self.mDPhiToPfMet_TauEnUp_branch and "mDPhiToPfMet_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_TauEnUp")
        else:
            self.mDPhiToPfMet_TauEnUp_branch.SetAddress(<void*>&self.mDPhiToPfMet_TauEnUp_value)

        #print "making mDPhiToPfMet_UnclusteredEnDown"
        self.mDPhiToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("mDPhiToPfMet_UnclusteredEnDown")
        #if not self.mDPhiToPfMet_UnclusteredEnDown_branch and "mDPhiToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.mDPhiToPfMet_UnclusteredEnDown_branch and "mDPhiToPfMet_UnclusteredEnDown":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_UnclusteredEnDown")
        else:
            self.mDPhiToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.mDPhiToPfMet_UnclusteredEnDown_value)

        #print "making mDPhiToPfMet_UnclusteredEnUp"
        self.mDPhiToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("mDPhiToPfMet_UnclusteredEnUp")
        #if not self.mDPhiToPfMet_UnclusteredEnUp_branch and "mDPhiToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.mDPhiToPfMet_UnclusteredEnUp_branch and "mDPhiToPfMet_UnclusteredEnUp":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_UnclusteredEnUp")
        else:
            self.mDPhiToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.mDPhiToPfMet_UnclusteredEnUp_value)

        #print "making mDPhiToPfMet_type1"
        self.mDPhiToPfMet_type1_branch = the_tree.GetBranch("mDPhiToPfMet_type1")
        #if not self.mDPhiToPfMet_type1_branch and "mDPhiToPfMet_type1" not in self.complained:
        if not self.mDPhiToPfMet_type1_branch and "mDPhiToPfMet_type1":
            warnings.warn( "MuTauTree: Expected branch mDPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mDPhiToPfMet_type1")
        else:
            self.mDPhiToPfMet_type1_branch.SetAddress(<void*>&self.mDPhiToPfMet_type1_value)

        #print "making mEcalIsoDR03"
        self.mEcalIsoDR03_branch = the_tree.GetBranch("mEcalIsoDR03")
        #if not self.mEcalIsoDR03_branch and "mEcalIsoDR03" not in self.complained:
        if not self.mEcalIsoDR03_branch and "mEcalIsoDR03":
            warnings.warn( "MuTauTree: Expected branch mEcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEcalIsoDR03")
        else:
            self.mEcalIsoDR03_branch.SetAddress(<void*>&self.mEcalIsoDR03_value)

        #print "making mEffectiveArea2011"
        self.mEffectiveArea2011_branch = the_tree.GetBranch("mEffectiveArea2011")
        #if not self.mEffectiveArea2011_branch and "mEffectiveArea2011" not in self.complained:
        if not self.mEffectiveArea2011_branch and "mEffectiveArea2011":
            warnings.warn( "MuTauTree: Expected branch mEffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEffectiveArea2011")
        else:
            self.mEffectiveArea2011_branch.SetAddress(<void*>&self.mEffectiveArea2011_value)

        #print "making mEffectiveArea2012"
        self.mEffectiveArea2012_branch = the_tree.GetBranch("mEffectiveArea2012")
        #if not self.mEffectiveArea2012_branch and "mEffectiveArea2012" not in self.complained:
        if not self.mEffectiveArea2012_branch and "mEffectiveArea2012":
            warnings.warn( "MuTauTree: Expected branch mEffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEffectiveArea2012")
        else:
            self.mEffectiveArea2012_branch.SetAddress(<void*>&self.mEffectiveArea2012_value)

        #print "making mEta"
        self.mEta_branch = the_tree.GetBranch("mEta")
        #if not self.mEta_branch and "mEta" not in self.complained:
        if not self.mEta_branch and "mEta":
            warnings.warn( "MuTauTree: Expected branch mEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEta")
        else:
            self.mEta_branch.SetAddress(<void*>&self.mEta_value)

        #print "making mEta_MuonEnDown"
        self.mEta_MuonEnDown_branch = the_tree.GetBranch("mEta_MuonEnDown")
        #if not self.mEta_MuonEnDown_branch and "mEta_MuonEnDown" not in self.complained:
        if not self.mEta_MuonEnDown_branch and "mEta_MuonEnDown":
            warnings.warn( "MuTauTree: Expected branch mEta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEta_MuonEnDown")
        else:
            self.mEta_MuonEnDown_branch.SetAddress(<void*>&self.mEta_MuonEnDown_value)

        #print "making mEta_MuonEnUp"
        self.mEta_MuonEnUp_branch = the_tree.GetBranch("mEta_MuonEnUp")
        #if not self.mEta_MuonEnUp_branch and "mEta_MuonEnUp" not in self.complained:
        if not self.mEta_MuonEnUp_branch and "mEta_MuonEnUp":
            warnings.warn( "MuTauTree: Expected branch mEta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEta_MuonEnUp")
        else:
            self.mEta_MuonEnUp_branch.SetAddress(<void*>&self.mEta_MuonEnUp_value)

        #print "making mGenCharge"
        self.mGenCharge_branch = the_tree.GetBranch("mGenCharge")
        #if not self.mGenCharge_branch and "mGenCharge" not in self.complained:
        if not self.mGenCharge_branch and "mGenCharge":
            warnings.warn( "MuTauTree: Expected branch mGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenCharge")
        else:
            self.mGenCharge_branch.SetAddress(<void*>&self.mGenCharge_value)

        #print "making mGenEnergy"
        self.mGenEnergy_branch = the_tree.GetBranch("mGenEnergy")
        #if not self.mGenEnergy_branch and "mGenEnergy" not in self.complained:
        if not self.mGenEnergy_branch and "mGenEnergy":
            warnings.warn( "MuTauTree: Expected branch mGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenEnergy")
        else:
            self.mGenEnergy_branch.SetAddress(<void*>&self.mGenEnergy_value)

        #print "making mGenEta"
        self.mGenEta_branch = the_tree.GetBranch("mGenEta")
        #if not self.mGenEta_branch and "mGenEta" not in self.complained:
        if not self.mGenEta_branch and "mGenEta":
            warnings.warn( "MuTauTree: Expected branch mGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenEta")
        else:
            self.mGenEta_branch.SetAddress(<void*>&self.mGenEta_value)

        #print "making mGenMotherPdgId"
        self.mGenMotherPdgId_branch = the_tree.GetBranch("mGenMotherPdgId")
        #if not self.mGenMotherPdgId_branch and "mGenMotherPdgId" not in self.complained:
        if not self.mGenMotherPdgId_branch and "mGenMotherPdgId":
            warnings.warn( "MuTauTree: Expected branch mGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenMotherPdgId")
        else:
            self.mGenMotherPdgId_branch.SetAddress(<void*>&self.mGenMotherPdgId_value)

        #print "making mGenParticle"
        self.mGenParticle_branch = the_tree.GetBranch("mGenParticle")
        #if not self.mGenParticle_branch and "mGenParticle" not in self.complained:
        if not self.mGenParticle_branch and "mGenParticle":
            warnings.warn( "MuTauTree: Expected branch mGenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenParticle")
        else:
            self.mGenParticle_branch.SetAddress(<void*>&self.mGenParticle_value)

        #print "making mGenPdgId"
        self.mGenPdgId_branch = the_tree.GetBranch("mGenPdgId")
        #if not self.mGenPdgId_branch and "mGenPdgId" not in self.complained:
        if not self.mGenPdgId_branch and "mGenPdgId":
            warnings.warn( "MuTauTree: Expected branch mGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPdgId")
        else:
            self.mGenPdgId_branch.SetAddress(<void*>&self.mGenPdgId_value)

        #print "making mGenPhi"
        self.mGenPhi_branch = the_tree.GetBranch("mGenPhi")
        #if not self.mGenPhi_branch and "mGenPhi" not in self.complained:
        if not self.mGenPhi_branch and "mGenPhi":
            warnings.warn( "MuTauTree: Expected branch mGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPhi")
        else:
            self.mGenPhi_branch.SetAddress(<void*>&self.mGenPhi_value)

        #print "making mGenPrompt"
        self.mGenPrompt_branch = the_tree.GetBranch("mGenPrompt")
        #if not self.mGenPrompt_branch and "mGenPrompt" not in self.complained:
        if not self.mGenPrompt_branch and "mGenPrompt":
            warnings.warn( "MuTauTree: Expected branch mGenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPrompt")
        else:
            self.mGenPrompt_branch.SetAddress(<void*>&self.mGenPrompt_value)

        #print "making mGenPromptTauDecay"
        self.mGenPromptTauDecay_branch = the_tree.GetBranch("mGenPromptTauDecay")
        #if not self.mGenPromptTauDecay_branch and "mGenPromptTauDecay" not in self.complained:
        if not self.mGenPromptTauDecay_branch and "mGenPromptTauDecay":
            warnings.warn( "MuTauTree: Expected branch mGenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPromptTauDecay")
        else:
            self.mGenPromptTauDecay_branch.SetAddress(<void*>&self.mGenPromptTauDecay_value)

        #print "making mGenPt"
        self.mGenPt_branch = the_tree.GetBranch("mGenPt")
        #if not self.mGenPt_branch and "mGenPt" not in self.complained:
        if not self.mGenPt_branch and "mGenPt":
            warnings.warn( "MuTauTree: Expected branch mGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPt")
        else:
            self.mGenPt_branch.SetAddress(<void*>&self.mGenPt_value)

        #print "making mGenTauDecay"
        self.mGenTauDecay_branch = the_tree.GetBranch("mGenTauDecay")
        #if not self.mGenTauDecay_branch and "mGenTauDecay" not in self.complained:
        if not self.mGenTauDecay_branch and "mGenTauDecay":
            warnings.warn( "MuTauTree: Expected branch mGenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenTauDecay")
        else:
            self.mGenTauDecay_branch.SetAddress(<void*>&self.mGenTauDecay_value)

        #print "making mGenVZ"
        self.mGenVZ_branch = the_tree.GetBranch("mGenVZ")
        #if not self.mGenVZ_branch and "mGenVZ" not in self.complained:
        if not self.mGenVZ_branch and "mGenVZ":
            warnings.warn( "MuTauTree: Expected branch mGenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenVZ")
        else:
            self.mGenVZ_branch.SetAddress(<void*>&self.mGenVZ_value)

        #print "making mGenVtxPVMatch"
        self.mGenVtxPVMatch_branch = the_tree.GetBranch("mGenVtxPVMatch")
        #if not self.mGenVtxPVMatch_branch and "mGenVtxPVMatch" not in self.complained:
        if not self.mGenVtxPVMatch_branch and "mGenVtxPVMatch":
            warnings.warn( "MuTauTree: Expected branch mGenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenVtxPVMatch")
        else:
            self.mGenVtxPVMatch_branch.SetAddress(<void*>&self.mGenVtxPVMatch_value)

        #print "making mHcalIsoDR03"
        self.mHcalIsoDR03_branch = the_tree.GetBranch("mHcalIsoDR03")
        #if not self.mHcalIsoDR03_branch and "mHcalIsoDR03" not in self.complained:
        if not self.mHcalIsoDR03_branch and "mHcalIsoDR03":
            warnings.warn( "MuTauTree: Expected branch mHcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mHcalIsoDR03")
        else:
            self.mHcalIsoDR03_branch.SetAddress(<void*>&self.mHcalIsoDR03_value)

        #print "making mIP3D"
        self.mIP3D_branch = the_tree.GetBranch("mIP3D")
        #if not self.mIP3D_branch and "mIP3D" not in self.complained:
        if not self.mIP3D_branch and "mIP3D":
            warnings.warn( "MuTauTree: Expected branch mIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIP3D")
        else:
            self.mIP3D_branch.SetAddress(<void*>&self.mIP3D_value)

        #print "making mIP3DErr"
        self.mIP3DErr_branch = the_tree.GetBranch("mIP3DErr")
        #if not self.mIP3DErr_branch and "mIP3DErr" not in self.complained:
        if not self.mIP3DErr_branch and "mIP3DErr":
            warnings.warn( "MuTauTree: Expected branch mIP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIP3DErr")
        else:
            self.mIP3DErr_branch.SetAddress(<void*>&self.mIP3DErr_value)

        #print "making mIsGlobal"
        self.mIsGlobal_branch = the_tree.GetBranch("mIsGlobal")
        #if not self.mIsGlobal_branch and "mIsGlobal" not in self.complained:
        if not self.mIsGlobal_branch and "mIsGlobal":
            warnings.warn( "MuTauTree: Expected branch mIsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsGlobal")
        else:
            self.mIsGlobal_branch.SetAddress(<void*>&self.mIsGlobal_value)

        #print "making mIsPFMuon"
        self.mIsPFMuon_branch = the_tree.GetBranch("mIsPFMuon")
        #if not self.mIsPFMuon_branch and "mIsPFMuon" not in self.complained:
        if not self.mIsPFMuon_branch and "mIsPFMuon":
            warnings.warn( "MuTauTree: Expected branch mIsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsPFMuon")
        else:
            self.mIsPFMuon_branch.SetAddress(<void*>&self.mIsPFMuon_value)

        #print "making mIsTracker"
        self.mIsTracker_branch = the_tree.GetBranch("mIsTracker")
        #if not self.mIsTracker_branch and "mIsTracker" not in self.complained:
        if not self.mIsTracker_branch and "mIsTracker":
            warnings.warn( "MuTauTree: Expected branch mIsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsTracker")
        else:
            self.mIsTracker_branch.SetAddress(<void*>&self.mIsTracker_value)

        #print "making mJetArea"
        self.mJetArea_branch = the_tree.GetBranch("mJetArea")
        #if not self.mJetArea_branch and "mJetArea" not in self.complained:
        if not self.mJetArea_branch and "mJetArea":
            warnings.warn( "MuTauTree: Expected branch mJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetArea")
        else:
            self.mJetArea_branch.SetAddress(<void*>&self.mJetArea_value)

        #print "making mJetBtag"
        self.mJetBtag_branch = the_tree.GetBranch("mJetBtag")
        #if not self.mJetBtag_branch and "mJetBtag" not in self.complained:
        if not self.mJetBtag_branch and "mJetBtag":
            warnings.warn( "MuTauTree: Expected branch mJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetBtag")
        else:
            self.mJetBtag_branch.SetAddress(<void*>&self.mJetBtag_value)

        #print "making mJetEtaEtaMoment"
        self.mJetEtaEtaMoment_branch = the_tree.GetBranch("mJetEtaEtaMoment")
        #if not self.mJetEtaEtaMoment_branch and "mJetEtaEtaMoment" not in self.complained:
        if not self.mJetEtaEtaMoment_branch and "mJetEtaEtaMoment":
            warnings.warn( "MuTauTree: Expected branch mJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetEtaEtaMoment")
        else:
            self.mJetEtaEtaMoment_branch.SetAddress(<void*>&self.mJetEtaEtaMoment_value)

        #print "making mJetEtaPhiMoment"
        self.mJetEtaPhiMoment_branch = the_tree.GetBranch("mJetEtaPhiMoment")
        #if not self.mJetEtaPhiMoment_branch and "mJetEtaPhiMoment" not in self.complained:
        if not self.mJetEtaPhiMoment_branch and "mJetEtaPhiMoment":
            warnings.warn( "MuTauTree: Expected branch mJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetEtaPhiMoment")
        else:
            self.mJetEtaPhiMoment_branch.SetAddress(<void*>&self.mJetEtaPhiMoment_value)

        #print "making mJetEtaPhiSpread"
        self.mJetEtaPhiSpread_branch = the_tree.GetBranch("mJetEtaPhiSpread")
        #if not self.mJetEtaPhiSpread_branch and "mJetEtaPhiSpread" not in self.complained:
        if not self.mJetEtaPhiSpread_branch and "mJetEtaPhiSpread":
            warnings.warn( "MuTauTree: Expected branch mJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetEtaPhiSpread")
        else:
            self.mJetEtaPhiSpread_branch.SetAddress(<void*>&self.mJetEtaPhiSpread_value)

        #print "making mJetPFCISVBtag"
        self.mJetPFCISVBtag_branch = the_tree.GetBranch("mJetPFCISVBtag")
        #if not self.mJetPFCISVBtag_branch and "mJetPFCISVBtag" not in self.complained:
        if not self.mJetPFCISVBtag_branch and "mJetPFCISVBtag":
            warnings.warn( "MuTauTree: Expected branch mJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetPFCISVBtag")
        else:
            self.mJetPFCISVBtag_branch.SetAddress(<void*>&self.mJetPFCISVBtag_value)

        #print "making mJetPartonFlavour"
        self.mJetPartonFlavour_branch = the_tree.GetBranch("mJetPartonFlavour")
        #if not self.mJetPartonFlavour_branch and "mJetPartonFlavour" not in self.complained:
        if not self.mJetPartonFlavour_branch and "mJetPartonFlavour":
            warnings.warn( "MuTauTree: Expected branch mJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetPartonFlavour")
        else:
            self.mJetPartonFlavour_branch.SetAddress(<void*>&self.mJetPartonFlavour_value)

        #print "making mJetPhiPhiMoment"
        self.mJetPhiPhiMoment_branch = the_tree.GetBranch("mJetPhiPhiMoment")
        #if not self.mJetPhiPhiMoment_branch and "mJetPhiPhiMoment" not in self.complained:
        if not self.mJetPhiPhiMoment_branch and "mJetPhiPhiMoment":
            warnings.warn( "MuTauTree: Expected branch mJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetPhiPhiMoment")
        else:
            self.mJetPhiPhiMoment_branch.SetAddress(<void*>&self.mJetPhiPhiMoment_value)

        #print "making mJetPt"
        self.mJetPt_branch = the_tree.GetBranch("mJetPt")
        #if not self.mJetPt_branch and "mJetPt" not in self.complained:
        if not self.mJetPt_branch and "mJetPt":
            warnings.warn( "MuTauTree: Expected branch mJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetPt")
        else:
            self.mJetPt_branch.SetAddress(<void*>&self.mJetPt_value)

        #print "making mLowestMll"
        self.mLowestMll_branch = the_tree.GetBranch("mLowestMll")
        #if not self.mLowestMll_branch and "mLowestMll" not in self.complained:
        if not self.mLowestMll_branch and "mLowestMll":
            warnings.warn( "MuTauTree: Expected branch mLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mLowestMll")
        else:
            self.mLowestMll_branch.SetAddress(<void*>&self.mLowestMll_value)

        #print "making mMass"
        self.mMass_branch = the_tree.GetBranch("mMass")
        #if not self.mMass_branch and "mMass" not in self.complained:
        if not self.mMass_branch and "mMass":
            warnings.warn( "MuTauTree: Expected branch mMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMass")
        else:
            self.mMass_branch.SetAddress(<void*>&self.mMass_value)

        #print "making mMatchedStations"
        self.mMatchedStations_branch = the_tree.GetBranch("mMatchedStations")
        #if not self.mMatchedStations_branch and "mMatchedStations" not in self.complained:
        if not self.mMatchedStations_branch and "mMatchedStations":
            warnings.warn( "MuTauTree: Expected branch mMatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchedStations")
        else:
            self.mMatchedStations_branch.SetAddress(<void*>&self.mMatchedStations_value)

        #print "making mMatchesDoubleESingleMu"
        self.mMatchesDoubleESingleMu_branch = the_tree.GetBranch("mMatchesDoubleESingleMu")
        #if not self.mMatchesDoubleESingleMu_branch and "mMatchesDoubleESingleMu" not in self.complained:
        if not self.mMatchesDoubleESingleMu_branch and "mMatchesDoubleESingleMu":
            warnings.warn( "MuTauTree: Expected branch mMatchesDoubleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesDoubleESingleMu")
        else:
            self.mMatchesDoubleESingleMu_branch.SetAddress(<void*>&self.mMatchesDoubleESingleMu_value)

        #print "making mMatchesDoubleMu"
        self.mMatchesDoubleMu_branch = the_tree.GetBranch("mMatchesDoubleMu")
        #if not self.mMatchesDoubleMu_branch and "mMatchesDoubleMu" not in self.complained:
        if not self.mMatchesDoubleMu_branch and "mMatchesDoubleMu":
            warnings.warn( "MuTauTree: Expected branch mMatchesDoubleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesDoubleMu")
        else:
            self.mMatchesDoubleMu_branch.SetAddress(<void*>&self.mMatchesDoubleMu_value)

        #print "making mMatchesDoubleMuSingleE"
        self.mMatchesDoubleMuSingleE_branch = the_tree.GetBranch("mMatchesDoubleMuSingleE")
        #if not self.mMatchesDoubleMuSingleE_branch and "mMatchesDoubleMuSingleE" not in self.complained:
        if not self.mMatchesDoubleMuSingleE_branch and "mMatchesDoubleMuSingleE":
            warnings.warn( "MuTauTree: Expected branch mMatchesDoubleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesDoubleMuSingleE")
        else:
            self.mMatchesDoubleMuSingleE_branch.SetAddress(<void*>&self.mMatchesDoubleMuSingleE_value)

        #print "making mMatchesSingleESingleMu"
        self.mMatchesSingleESingleMu_branch = the_tree.GetBranch("mMatchesSingleESingleMu")
        #if not self.mMatchesSingleESingleMu_branch and "mMatchesSingleESingleMu" not in self.complained:
        if not self.mMatchesSingleESingleMu_branch and "mMatchesSingleESingleMu":
            warnings.warn( "MuTauTree: Expected branch mMatchesSingleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesSingleESingleMu")
        else:
            self.mMatchesSingleESingleMu_branch.SetAddress(<void*>&self.mMatchesSingleESingleMu_value)

        #print "making mMatchesSingleMu"
        self.mMatchesSingleMu_branch = the_tree.GetBranch("mMatchesSingleMu")
        #if not self.mMatchesSingleMu_branch and "mMatchesSingleMu" not in self.complained:
        if not self.mMatchesSingleMu_branch and "mMatchesSingleMu":
            warnings.warn( "MuTauTree: Expected branch mMatchesSingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesSingleMu")
        else:
            self.mMatchesSingleMu_branch.SetAddress(<void*>&self.mMatchesSingleMu_value)

        #print "making mMatchesSingleMuIso20"
        self.mMatchesSingleMuIso20_branch = the_tree.GetBranch("mMatchesSingleMuIso20")
        #if not self.mMatchesSingleMuIso20_branch and "mMatchesSingleMuIso20" not in self.complained:
        if not self.mMatchesSingleMuIso20_branch and "mMatchesSingleMuIso20":
            warnings.warn( "MuTauTree: Expected branch mMatchesSingleMuIso20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesSingleMuIso20")
        else:
            self.mMatchesSingleMuIso20_branch.SetAddress(<void*>&self.mMatchesSingleMuIso20_value)

        #print "making mMatchesSingleMuIsoTk20"
        self.mMatchesSingleMuIsoTk20_branch = the_tree.GetBranch("mMatchesSingleMuIsoTk20")
        #if not self.mMatchesSingleMuIsoTk20_branch and "mMatchesSingleMuIsoTk20" not in self.complained:
        if not self.mMatchesSingleMuIsoTk20_branch and "mMatchesSingleMuIsoTk20":
            warnings.warn( "MuTauTree: Expected branch mMatchesSingleMuIsoTk20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesSingleMuIsoTk20")
        else:
            self.mMatchesSingleMuIsoTk20_branch.SetAddress(<void*>&self.mMatchesSingleMuIsoTk20_value)

        #print "making mMatchesSingleMuSingleE"
        self.mMatchesSingleMuSingleE_branch = the_tree.GetBranch("mMatchesSingleMuSingleE")
        #if not self.mMatchesSingleMuSingleE_branch and "mMatchesSingleMuSingleE" not in self.complained:
        if not self.mMatchesSingleMuSingleE_branch and "mMatchesSingleMuSingleE":
            warnings.warn( "MuTauTree: Expected branch mMatchesSingleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesSingleMuSingleE")
        else:
            self.mMatchesSingleMuSingleE_branch.SetAddress(<void*>&self.mMatchesSingleMuSingleE_value)

        #print "making mMatchesSingleMu_leg1"
        self.mMatchesSingleMu_leg1_branch = the_tree.GetBranch("mMatchesSingleMu_leg1")
        #if not self.mMatchesSingleMu_leg1_branch and "mMatchesSingleMu_leg1" not in self.complained:
        if not self.mMatchesSingleMu_leg1_branch and "mMatchesSingleMu_leg1":
            warnings.warn( "MuTauTree: Expected branch mMatchesSingleMu_leg1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesSingleMu_leg1")
        else:
            self.mMatchesSingleMu_leg1_branch.SetAddress(<void*>&self.mMatchesSingleMu_leg1_value)

        #print "making mMatchesSingleMu_leg1_noiso"
        self.mMatchesSingleMu_leg1_noiso_branch = the_tree.GetBranch("mMatchesSingleMu_leg1_noiso")
        #if not self.mMatchesSingleMu_leg1_noiso_branch and "mMatchesSingleMu_leg1_noiso" not in self.complained:
        if not self.mMatchesSingleMu_leg1_noiso_branch and "mMatchesSingleMu_leg1_noiso":
            warnings.warn( "MuTauTree: Expected branch mMatchesSingleMu_leg1_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesSingleMu_leg1_noiso")
        else:
            self.mMatchesSingleMu_leg1_noiso_branch.SetAddress(<void*>&self.mMatchesSingleMu_leg1_noiso_value)

        #print "making mMatchesSingleMu_leg2"
        self.mMatchesSingleMu_leg2_branch = the_tree.GetBranch("mMatchesSingleMu_leg2")
        #if not self.mMatchesSingleMu_leg2_branch and "mMatchesSingleMu_leg2" not in self.complained:
        if not self.mMatchesSingleMu_leg2_branch and "mMatchesSingleMu_leg2":
            warnings.warn( "MuTauTree: Expected branch mMatchesSingleMu_leg2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesSingleMu_leg2")
        else:
            self.mMatchesSingleMu_leg2_branch.SetAddress(<void*>&self.mMatchesSingleMu_leg2_value)

        #print "making mMatchesSingleMu_leg2_noiso"
        self.mMatchesSingleMu_leg2_noiso_branch = the_tree.GetBranch("mMatchesSingleMu_leg2_noiso")
        #if not self.mMatchesSingleMu_leg2_noiso_branch and "mMatchesSingleMu_leg2_noiso" not in self.complained:
        if not self.mMatchesSingleMu_leg2_noiso_branch and "mMatchesSingleMu_leg2_noiso":
            warnings.warn( "MuTauTree: Expected branch mMatchesSingleMu_leg2_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesSingleMu_leg2_noiso")
        else:
            self.mMatchesSingleMu_leg2_noiso_branch.SetAddress(<void*>&self.mMatchesSingleMu_leg2_noiso_value)

        #print "making mMatchesTripleMu"
        self.mMatchesTripleMu_branch = the_tree.GetBranch("mMatchesTripleMu")
        #if not self.mMatchesTripleMu_branch and "mMatchesTripleMu" not in self.complained:
        if not self.mMatchesTripleMu_branch and "mMatchesTripleMu":
            warnings.warn( "MuTauTree: Expected branch mMatchesTripleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesTripleMu")
        else:
            self.mMatchesTripleMu_branch.SetAddress(<void*>&self.mMatchesTripleMu_value)

        #print "making mMtToPfMet_ElectronEnDown"
        self.mMtToPfMet_ElectronEnDown_branch = the_tree.GetBranch("mMtToPfMet_ElectronEnDown")
        #if not self.mMtToPfMet_ElectronEnDown_branch and "mMtToPfMet_ElectronEnDown" not in self.complained:
        if not self.mMtToPfMet_ElectronEnDown_branch and "mMtToPfMet_ElectronEnDown":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_ElectronEnDown")
        else:
            self.mMtToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.mMtToPfMet_ElectronEnDown_value)

        #print "making mMtToPfMet_ElectronEnUp"
        self.mMtToPfMet_ElectronEnUp_branch = the_tree.GetBranch("mMtToPfMet_ElectronEnUp")
        #if not self.mMtToPfMet_ElectronEnUp_branch and "mMtToPfMet_ElectronEnUp" not in self.complained:
        if not self.mMtToPfMet_ElectronEnUp_branch and "mMtToPfMet_ElectronEnUp":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_ElectronEnUp")
        else:
            self.mMtToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.mMtToPfMet_ElectronEnUp_value)

        #print "making mMtToPfMet_JetEnDown"
        self.mMtToPfMet_JetEnDown_branch = the_tree.GetBranch("mMtToPfMet_JetEnDown")
        #if not self.mMtToPfMet_JetEnDown_branch and "mMtToPfMet_JetEnDown" not in self.complained:
        if not self.mMtToPfMet_JetEnDown_branch and "mMtToPfMet_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_JetEnDown")
        else:
            self.mMtToPfMet_JetEnDown_branch.SetAddress(<void*>&self.mMtToPfMet_JetEnDown_value)

        #print "making mMtToPfMet_JetEnUp"
        self.mMtToPfMet_JetEnUp_branch = the_tree.GetBranch("mMtToPfMet_JetEnUp")
        #if not self.mMtToPfMet_JetEnUp_branch and "mMtToPfMet_JetEnUp" not in self.complained:
        if not self.mMtToPfMet_JetEnUp_branch and "mMtToPfMet_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_JetEnUp")
        else:
            self.mMtToPfMet_JetEnUp_branch.SetAddress(<void*>&self.mMtToPfMet_JetEnUp_value)

        #print "making mMtToPfMet_JetResDown"
        self.mMtToPfMet_JetResDown_branch = the_tree.GetBranch("mMtToPfMet_JetResDown")
        #if not self.mMtToPfMet_JetResDown_branch and "mMtToPfMet_JetResDown" not in self.complained:
        if not self.mMtToPfMet_JetResDown_branch and "mMtToPfMet_JetResDown":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_JetResDown")
        else:
            self.mMtToPfMet_JetResDown_branch.SetAddress(<void*>&self.mMtToPfMet_JetResDown_value)

        #print "making mMtToPfMet_JetResUp"
        self.mMtToPfMet_JetResUp_branch = the_tree.GetBranch("mMtToPfMet_JetResUp")
        #if not self.mMtToPfMet_JetResUp_branch and "mMtToPfMet_JetResUp" not in self.complained:
        if not self.mMtToPfMet_JetResUp_branch and "mMtToPfMet_JetResUp":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_JetResUp")
        else:
            self.mMtToPfMet_JetResUp_branch.SetAddress(<void*>&self.mMtToPfMet_JetResUp_value)

        #print "making mMtToPfMet_MuonEnDown"
        self.mMtToPfMet_MuonEnDown_branch = the_tree.GetBranch("mMtToPfMet_MuonEnDown")
        #if not self.mMtToPfMet_MuonEnDown_branch and "mMtToPfMet_MuonEnDown" not in self.complained:
        if not self.mMtToPfMet_MuonEnDown_branch and "mMtToPfMet_MuonEnDown":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_MuonEnDown")
        else:
            self.mMtToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.mMtToPfMet_MuonEnDown_value)

        #print "making mMtToPfMet_MuonEnUp"
        self.mMtToPfMet_MuonEnUp_branch = the_tree.GetBranch("mMtToPfMet_MuonEnUp")
        #if not self.mMtToPfMet_MuonEnUp_branch and "mMtToPfMet_MuonEnUp" not in self.complained:
        if not self.mMtToPfMet_MuonEnUp_branch and "mMtToPfMet_MuonEnUp":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_MuonEnUp")
        else:
            self.mMtToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.mMtToPfMet_MuonEnUp_value)

        #print "making mMtToPfMet_PhotonEnDown"
        self.mMtToPfMet_PhotonEnDown_branch = the_tree.GetBranch("mMtToPfMet_PhotonEnDown")
        #if not self.mMtToPfMet_PhotonEnDown_branch and "mMtToPfMet_PhotonEnDown" not in self.complained:
        if not self.mMtToPfMet_PhotonEnDown_branch and "mMtToPfMet_PhotonEnDown":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_PhotonEnDown")
        else:
            self.mMtToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.mMtToPfMet_PhotonEnDown_value)

        #print "making mMtToPfMet_PhotonEnUp"
        self.mMtToPfMet_PhotonEnUp_branch = the_tree.GetBranch("mMtToPfMet_PhotonEnUp")
        #if not self.mMtToPfMet_PhotonEnUp_branch and "mMtToPfMet_PhotonEnUp" not in self.complained:
        if not self.mMtToPfMet_PhotonEnUp_branch and "mMtToPfMet_PhotonEnUp":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_PhotonEnUp")
        else:
            self.mMtToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.mMtToPfMet_PhotonEnUp_value)

        #print "making mMtToPfMet_Raw"
        self.mMtToPfMet_Raw_branch = the_tree.GetBranch("mMtToPfMet_Raw")
        #if not self.mMtToPfMet_Raw_branch and "mMtToPfMet_Raw" not in self.complained:
        if not self.mMtToPfMet_Raw_branch and "mMtToPfMet_Raw":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_Raw")
        else:
            self.mMtToPfMet_Raw_branch.SetAddress(<void*>&self.mMtToPfMet_Raw_value)

        #print "making mMtToPfMet_TauEnDown"
        self.mMtToPfMet_TauEnDown_branch = the_tree.GetBranch("mMtToPfMet_TauEnDown")
        #if not self.mMtToPfMet_TauEnDown_branch and "mMtToPfMet_TauEnDown" not in self.complained:
        if not self.mMtToPfMet_TauEnDown_branch and "mMtToPfMet_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_TauEnDown")
        else:
            self.mMtToPfMet_TauEnDown_branch.SetAddress(<void*>&self.mMtToPfMet_TauEnDown_value)

        #print "making mMtToPfMet_TauEnUp"
        self.mMtToPfMet_TauEnUp_branch = the_tree.GetBranch("mMtToPfMet_TauEnUp")
        #if not self.mMtToPfMet_TauEnUp_branch and "mMtToPfMet_TauEnUp" not in self.complained:
        if not self.mMtToPfMet_TauEnUp_branch and "mMtToPfMet_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_TauEnUp")
        else:
            self.mMtToPfMet_TauEnUp_branch.SetAddress(<void*>&self.mMtToPfMet_TauEnUp_value)

        #print "making mMtToPfMet_UnclusteredEnDown"
        self.mMtToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("mMtToPfMet_UnclusteredEnDown")
        #if not self.mMtToPfMet_UnclusteredEnDown_branch and "mMtToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.mMtToPfMet_UnclusteredEnDown_branch and "mMtToPfMet_UnclusteredEnDown":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_UnclusteredEnDown")
        else:
            self.mMtToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.mMtToPfMet_UnclusteredEnDown_value)

        #print "making mMtToPfMet_UnclusteredEnUp"
        self.mMtToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("mMtToPfMet_UnclusteredEnUp")
        #if not self.mMtToPfMet_UnclusteredEnUp_branch and "mMtToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.mMtToPfMet_UnclusteredEnUp_branch and "mMtToPfMet_UnclusteredEnUp":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_UnclusteredEnUp")
        else:
            self.mMtToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.mMtToPfMet_UnclusteredEnUp_value)

        #print "making mMtToPfMet_type1"
        self.mMtToPfMet_type1_branch = the_tree.GetBranch("mMtToPfMet_type1")
        #if not self.mMtToPfMet_type1_branch and "mMtToPfMet_type1" not in self.complained:
        if not self.mMtToPfMet_type1_branch and "mMtToPfMet_type1":
            warnings.warn( "MuTauTree: Expected branch mMtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMtToPfMet_type1")
        else:
            self.mMtToPfMet_type1_branch.SetAddress(<void*>&self.mMtToPfMet_type1_value)

        #print "making mMuonHits"
        self.mMuonHits_branch = the_tree.GetBranch("mMuonHits")
        #if not self.mMuonHits_branch and "mMuonHits" not in self.complained:
        if not self.mMuonHits_branch and "mMuonHits":
            warnings.warn( "MuTauTree: Expected branch mMuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMuonHits")
        else:
            self.mMuonHits_branch.SetAddress(<void*>&self.mMuonHits_value)

        #print "making mNearestZMass"
        self.mNearestZMass_branch = the_tree.GetBranch("mNearestZMass")
        #if not self.mNearestZMass_branch and "mNearestZMass" not in self.complained:
        if not self.mNearestZMass_branch and "mNearestZMass":
            warnings.warn( "MuTauTree: Expected branch mNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mNearestZMass")
        else:
            self.mNearestZMass_branch.SetAddress(<void*>&self.mNearestZMass_value)

        #print "making mNormTrkChi2"
        self.mNormTrkChi2_branch = the_tree.GetBranch("mNormTrkChi2")
        #if not self.mNormTrkChi2_branch and "mNormTrkChi2" not in self.complained:
        if not self.mNormTrkChi2_branch and "mNormTrkChi2":
            warnings.warn( "MuTauTree: Expected branch mNormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mNormTrkChi2")
        else:
            self.mNormTrkChi2_branch.SetAddress(<void*>&self.mNormTrkChi2_value)

        #print "making mPFChargedHadronIsoR04"
        self.mPFChargedHadronIsoR04_branch = the_tree.GetBranch("mPFChargedHadronIsoR04")
        #if not self.mPFChargedHadronIsoR04_branch and "mPFChargedHadronIsoR04" not in self.complained:
        if not self.mPFChargedHadronIsoR04_branch and "mPFChargedHadronIsoR04":
            warnings.warn( "MuTauTree: Expected branch mPFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFChargedHadronIsoR04")
        else:
            self.mPFChargedHadronIsoR04_branch.SetAddress(<void*>&self.mPFChargedHadronIsoR04_value)

        #print "making mPFChargedIso"
        self.mPFChargedIso_branch = the_tree.GetBranch("mPFChargedIso")
        #if not self.mPFChargedIso_branch and "mPFChargedIso" not in self.complained:
        if not self.mPFChargedIso_branch and "mPFChargedIso":
            warnings.warn( "MuTauTree: Expected branch mPFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFChargedIso")
        else:
            self.mPFChargedIso_branch.SetAddress(<void*>&self.mPFChargedIso_value)

        #print "making mPFIDLoose"
        self.mPFIDLoose_branch = the_tree.GetBranch("mPFIDLoose")
        #if not self.mPFIDLoose_branch and "mPFIDLoose" not in self.complained:
        if not self.mPFIDLoose_branch and "mPFIDLoose":
            warnings.warn( "MuTauTree: Expected branch mPFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIDLoose")
        else:
            self.mPFIDLoose_branch.SetAddress(<void*>&self.mPFIDLoose_value)

        #print "making mPFIDMedium"
        self.mPFIDMedium_branch = the_tree.GetBranch("mPFIDMedium")
        #if not self.mPFIDMedium_branch and "mPFIDMedium" not in self.complained:
        if not self.mPFIDMedium_branch and "mPFIDMedium":
            warnings.warn( "MuTauTree: Expected branch mPFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIDMedium")
        else:
            self.mPFIDMedium_branch.SetAddress(<void*>&self.mPFIDMedium_value)

        #print "making mPFIDTight"
        self.mPFIDTight_branch = the_tree.GetBranch("mPFIDTight")
        #if not self.mPFIDTight_branch and "mPFIDTight" not in self.complained:
        if not self.mPFIDTight_branch and "mPFIDTight":
            warnings.warn( "MuTauTree: Expected branch mPFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIDTight")
        else:
            self.mPFIDTight_branch.SetAddress(<void*>&self.mPFIDTight_value)

        #print "making mPFNeutralHadronIsoR04"
        self.mPFNeutralHadronIsoR04_branch = the_tree.GetBranch("mPFNeutralHadronIsoR04")
        #if not self.mPFNeutralHadronIsoR04_branch and "mPFNeutralHadronIsoR04" not in self.complained:
        if not self.mPFNeutralHadronIsoR04_branch and "mPFNeutralHadronIsoR04":
            warnings.warn( "MuTauTree: Expected branch mPFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFNeutralHadronIsoR04")
        else:
            self.mPFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.mPFNeutralHadronIsoR04_value)

        #print "making mPFNeutralIso"
        self.mPFNeutralIso_branch = the_tree.GetBranch("mPFNeutralIso")
        #if not self.mPFNeutralIso_branch and "mPFNeutralIso" not in self.complained:
        if not self.mPFNeutralIso_branch and "mPFNeutralIso":
            warnings.warn( "MuTauTree: Expected branch mPFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFNeutralIso")
        else:
            self.mPFNeutralIso_branch.SetAddress(<void*>&self.mPFNeutralIso_value)

        #print "making mPFPUChargedIso"
        self.mPFPUChargedIso_branch = the_tree.GetBranch("mPFPUChargedIso")
        #if not self.mPFPUChargedIso_branch and "mPFPUChargedIso" not in self.complained:
        if not self.mPFPUChargedIso_branch and "mPFPUChargedIso":
            warnings.warn( "MuTauTree: Expected branch mPFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFPUChargedIso")
        else:
            self.mPFPUChargedIso_branch.SetAddress(<void*>&self.mPFPUChargedIso_value)

        #print "making mPFPhotonIso"
        self.mPFPhotonIso_branch = the_tree.GetBranch("mPFPhotonIso")
        #if not self.mPFPhotonIso_branch and "mPFPhotonIso" not in self.complained:
        if not self.mPFPhotonIso_branch and "mPFPhotonIso":
            warnings.warn( "MuTauTree: Expected branch mPFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFPhotonIso")
        else:
            self.mPFPhotonIso_branch.SetAddress(<void*>&self.mPFPhotonIso_value)

        #print "making mPFPhotonIsoR04"
        self.mPFPhotonIsoR04_branch = the_tree.GetBranch("mPFPhotonIsoR04")
        #if not self.mPFPhotonIsoR04_branch and "mPFPhotonIsoR04" not in self.complained:
        if not self.mPFPhotonIsoR04_branch and "mPFPhotonIsoR04":
            warnings.warn( "MuTauTree: Expected branch mPFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFPhotonIsoR04")
        else:
            self.mPFPhotonIsoR04_branch.SetAddress(<void*>&self.mPFPhotonIsoR04_value)

        #print "making mPFPileupIsoR04"
        self.mPFPileupIsoR04_branch = the_tree.GetBranch("mPFPileupIsoR04")
        #if not self.mPFPileupIsoR04_branch and "mPFPileupIsoR04" not in self.complained:
        if not self.mPFPileupIsoR04_branch and "mPFPileupIsoR04":
            warnings.warn( "MuTauTree: Expected branch mPFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFPileupIsoR04")
        else:
            self.mPFPileupIsoR04_branch.SetAddress(<void*>&self.mPFPileupIsoR04_value)

        #print "making mPVDXY"
        self.mPVDXY_branch = the_tree.GetBranch("mPVDXY")
        #if not self.mPVDXY_branch and "mPVDXY" not in self.complained:
        if not self.mPVDXY_branch and "mPVDXY":
            warnings.warn( "MuTauTree: Expected branch mPVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPVDXY")
        else:
            self.mPVDXY_branch.SetAddress(<void*>&self.mPVDXY_value)

        #print "making mPVDZ"
        self.mPVDZ_branch = the_tree.GetBranch("mPVDZ")
        #if not self.mPVDZ_branch and "mPVDZ" not in self.complained:
        if not self.mPVDZ_branch and "mPVDZ":
            warnings.warn( "MuTauTree: Expected branch mPVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPVDZ")
        else:
            self.mPVDZ_branch.SetAddress(<void*>&self.mPVDZ_value)

        #print "making mPhi"
        self.mPhi_branch = the_tree.GetBranch("mPhi")
        #if not self.mPhi_branch and "mPhi" not in self.complained:
        if not self.mPhi_branch and "mPhi":
            warnings.warn( "MuTauTree: Expected branch mPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPhi")
        else:
            self.mPhi_branch.SetAddress(<void*>&self.mPhi_value)

        #print "making mPhi_MuonEnDown"
        self.mPhi_MuonEnDown_branch = the_tree.GetBranch("mPhi_MuonEnDown")
        #if not self.mPhi_MuonEnDown_branch and "mPhi_MuonEnDown" not in self.complained:
        if not self.mPhi_MuonEnDown_branch and "mPhi_MuonEnDown":
            warnings.warn( "MuTauTree: Expected branch mPhi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPhi_MuonEnDown")
        else:
            self.mPhi_MuonEnDown_branch.SetAddress(<void*>&self.mPhi_MuonEnDown_value)

        #print "making mPhi_MuonEnUp"
        self.mPhi_MuonEnUp_branch = the_tree.GetBranch("mPhi_MuonEnUp")
        #if not self.mPhi_MuonEnUp_branch and "mPhi_MuonEnUp" not in self.complained:
        if not self.mPhi_MuonEnUp_branch and "mPhi_MuonEnUp":
            warnings.warn( "MuTauTree: Expected branch mPhi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPhi_MuonEnUp")
        else:
            self.mPhi_MuonEnUp_branch.SetAddress(<void*>&self.mPhi_MuonEnUp_value)

        #print "making mPixHits"
        self.mPixHits_branch = the_tree.GetBranch("mPixHits")
        #if not self.mPixHits_branch and "mPixHits" not in self.complained:
        if not self.mPixHits_branch and "mPixHits":
            warnings.warn( "MuTauTree: Expected branch mPixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPixHits")
        else:
            self.mPixHits_branch.SetAddress(<void*>&self.mPixHits_value)

        #print "making mPt"
        self.mPt_branch = the_tree.GetBranch("mPt")
        #if not self.mPt_branch and "mPt" not in self.complained:
        if not self.mPt_branch and "mPt":
            warnings.warn( "MuTauTree: Expected branch mPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPt")
        else:
            self.mPt_branch.SetAddress(<void*>&self.mPt_value)

        #print "making mPt_MuonEnDown"
        self.mPt_MuonEnDown_branch = the_tree.GetBranch("mPt_MuonEnDown")
        #if not self.mPt_MuonEnDown_branch and "mPt_MuonEnDown" not in self.complained:
        if not self.mPt_MuonEnDown_branch and "mPt_MuonEnDown":
            warnings.warn( "MuTauTree: Expected branch mPt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPt_MuonEnDown")
        else:
            self.mPt_MuonEnDown_branch.SetAddress(<void*>&self.mPt_MuonEnDown_value)

        #print "making mPt_MuonEnUp"
        self.mPt_MuonEnUp_branch = the_tree.GetBranch("mPt_MuonEnUp")
        #if not self.mPt_MuonEnUp_branch and "mPt_MuonEnUp" not in self.complained:
        if not self.mPt_MuonEnUp_branch and "mPt_MuonEnUp":
            warnings.warn( "MuTauTree: Expected branch mPt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPt_MuonEnUp")
        else:
            self.mPt_MuonEnUp_branch.SetAddress(<void*>&self.mPt_MuonEnUp_value)

        #print "making mRank"
        self.mRank_branch = the_tree.GetBranch("mRank")
        #if not self.mRank_branch and "mRank" not in self.complained:
        if not self.mRank_branch and "mRank":
            warnings.warn( "MuTauTree: Expected branch mRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRank")
        else:
            self.mRank_branch.SetAddress(<void*>&self.mRank_value)

        #print "making mRelPFIsoDBDefault"
        self.mRelPFIsoDBDefault_branch = the_tree.GetBranch("mRelPFIsoDBDefault")
        #if not self.mRelPFIsoDBDefault_branch and "mRelPFIsoDBDefault" not in self.complained:
        if not self.mRelPFIsoDBDefault_branch and "mRelPFIsoDBDefault":
            warnings.warn( "MuTauTree: Expected branch mRelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRelPFIsoDBDefault")
        else:
            self.mRelPFIsoDBDefault_branch.SetAddress(<void*>&self.mRelPFIsoDBDefault_value)

        #print "making mRelPFIsoDBDefaultR04"
        self.mRelPFIsoDBDefaultR04_branch = the_tree.GetBranch("mRelPFIsoDBDefaultR04")
        #if not self.mRelPFIsoDBDefaultR04_branch and "mRelPFIsoDBDefaultR04" not in self.complained:
        if not self.mRelPFIsoDBDefaultR04_branch and "mRelPFIsoDBDefaultR04":
            warnings.warn( "MuTauTree: Expected branch mRelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRelPFIsoDBDefaultR04")
        else:
            self.mRelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.mRelPFIsoDBDefaultR04_value)

        #print "making mRelPFIsoRho"
        self.mRelPFIsoRho_branch = the_tree.GetBranch("mRelPFIsoRho")
        #if not self.mRelPFIsoRho_branch and "mRelPFIsoRho" not in self.complained:
        if not self.mRelPFIsoRho_branch and "mRelPFIsoRho":
            warnings.warn( "MuTauTree: Expected branch mRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRelPFIsoRho")
        else:
            self.mRelPFIsoRho_branch.SetAddress(<void*>&self.mRelPFIsoRho_value)

        #print "making mRho"
        self.mRho_branch = the_tree.GetBranch("mRho")
        #if not self.mRho_branch and "mRho" not in self.complained:
        if not self.mRho_branch and "mRho":
            warnings.warn( "MuTauTree: Expected branch mRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRho")
        else:
            self.mRho_branch.SetAddress(<void*>&self.mRho_value)

        #print "making mSIP2D"
        self.mSIP2D_branch = the_tree.GetBranch("mSIP2D")
        #if not self.mSIP2D_branch and "mSIP2D" not in self.complained:
        if not self.mSIP2D_branch and "mSIP2D":
            warnings.warn( "MuTauTree: Expected branch mSIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mSIP2D")
        else:
            self.mSIP2D_branch.SetAddress(<void*>&self.mSIP2D_value)

        #print "making mSIP3D"
        self.mSIP3D_branch = the_tree.GetBranch("mSIP3D")
        #if not self.mSIP3D_branch and "mSIP3D" not in self.complained:
        if not self.mSIP3D_branch and "mSIP3D":
            warnings.warn( "MuTauTree: Expected branch mSIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mSIP3D")
        else:
            self.mSIP3D_branch.SetAddress(<void*>&self.mSIP3D_value)

        #print "making mTkLayersWithMeasurement"
        self.mTkLayersWithMeasurement_branch = the_tree.GetBranch("mTkLayersWithMeasurement")
        #if not self.mTkLayersWithMeasurement_branch and "mTkLayersWithMeasurement" not in self.complained:
        if not self.mTkLayersWithMeasurement_branch and "mTkLayersWithMeasurement":
            warnings.warn( "MuTauTree: Expected branch mTkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTkLayersWithMeasurement")
        else:
            self.mTkLayersWithMeasurement_branch.SetAddress(<void*>&self.mTkLayersWithMeasurement_value)

        #print "making mTrkIsoDR03"
        self.mTrkIsoDR03_branch = the_tree.GetBranch("mTrkIsoDR03")
        #if not self.mTrkIsoDR03_branch and "mTrkIsoDR03" not in self.complained:
        if not self.mTrkIsoDR03_branch and "mTrkIsoDR03":
            warnings.warn( "MuTauTree: Expected branch mTrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTrkIsoDR03")
        else:
            self.mTrkIsoDR03_branch.SetAddress(<void*>&self.mTrkIsoDR03_value)

        #print "making mTypeCode"
        self.mTypeCode_branch = the_tree.GetBranch("mTypeCode")
        #if not self.mTypeCode_branch and "mTypeCode" not in self.complained:
        if not self.mTypeCode_branch and "mTypeCode":
            warnings.warn( "MuTauTree: Expected branch mTypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTypeCode")
        else:
            self.mTypeCode_branch.SetAddress(<void*>&self.mTypeCode_value)

        #print "making mVZ"
        self.mVZ_branch = the_tree.GetBranch("mVZ")
        #if not self.mVZ_branch and "mVZ" not in self.complained:
        if not self.mVZ_branch and "mVZ":
            warnings.warn( "MuTauTree: Expected branch mVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mVZ")
        else:
            self.mVZ_branch.SetAddress(<void*>&self.mVZ_value)

        #print "making m_t_CosThetaStar"
        self.m_t_CosThetaStar_branch = the_tree.GetBranch("m_t_CosThetaStar")
        #if not self.m_t_CosThetaStar_branch and "m_t_CosThetaStar" not in self.complained:
        if not self.m_t_CosThetaStar_branch and "m_t_CosThetaStar":
            warnings.warn( "MuTauTree: Expected branch m_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_CosThetaStar")
        else:
            self.m_t_CosThetaStar_branch.SetAddress(<void*>&self.m_t_CosThetaStar_value)

        #print "making m_t_DPhi"
        self.m_t_DPhi_branch = the_tree.GetBranch("m_t_DPhi")
        #if not self.m_t_DPhi_branch and "m_t_DPhi" not in self.complained:
        if not self.m_t_DPhi_branch and "m_t_DPhi":
            warnings.warn( "MuTauTree: Expected branch m_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_DPhi")
        else:
            self.m_t_DPhi_branch.SetAddress(<void*>&self.m_t_DPhi_value)

        #print "making m_t_DR"
        self.m_t_DR_branch = the_tree.GetBranch("m_t_DR")
        #if not self.m_t_DR_branch and "m_t_DR" not in self.complained:
        if not self.m_t_DR_branch and "m_t_DR":
            warnings.warn( "MuTauTree: Expected branch m_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_DR")
        else:
            self.m_t_DR_branch.SetAddress(<void*>&self.m_t_DR_value)

        #print "making m_t_Eta"
        self.m_t_Eta_branch = the_tree.GetBranch("m_t_Eta")
        #if not self.m_t_Eta_branch and "m_t_Eta" not in self.complained:
        if not self.m_t_Eta_branch and "m_t_Eta":
            warnings.warn( "MuTauTree: Expected branch m_t_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_Eta")
        else:
            self.m_t_Eta_branch.SetAddress(<void*>&self.m_t_Eta_value)

        #print "making m_t_Mass"
        self.m_t_Mass_branch = the_tree.GetBranch("m_t_Mass")
        #if not self.m_t_Mass_branch and "m_t_Mass" not in self.complained:
        if not self.m_t_Mass_branch and "m_t_Mass":
            warnings.warn( "MuTauTree: Expected branch m_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_Mass")
        else:
            self.m_t_Mass_branch.SetAddress(<void*>&self.m_t_Mass_value)

        #print "making m_t_Mass_TauEnDown"
        self.m_t_Mass_TauEnDown_branch = the_tree.GetBranch("m_t_Mass_TauEnDown")
        #if not self.m_t_Mass_TauEnDown_branch and "m_t_Mass_TauEnDown" not in self.complained:
        if not self.m_t_Mass_TauEnDown_branch and "m_t_Mass_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch m_t_Mass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_Mass_TauEnDown")
        else:
            self.m_t_Mass_TauEnDown_branch.SetAddress(<void*>&self.m_t_Mass_TauEnDown_value)

        #print "making m_t_Mass_TauEnUp"
        self.m_t_Mass_TauEnUp_branch = the_tree.GetBranch("m_t_Mass_TauEnUp")
        #if not self.m_t_Mass_TauEnUp_branch and "m_t_Mass_TauEnUp" not in self.complained:
        if not self.m_t_Mass_TauEnUp_branch and "m_t_Mass_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch m_t_Mass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_Mass_TauEnUp")
        else:
            self.m_t_Mass_TauEnUp_branch.SetAddress(<void*>&self.m_t_Mass_TauEnUp_value)

        #print "making m_t_Mt"
        self.m_t_Mt_branch = the_tree.GetBranch("m_t_Mt")
        #if not self.m_t_Mt_branch and "m_t_Mt" not in self.complained:
        if not self.m_t_Mt_branch and "m_t_Mt":
            warnings.warn( "MuTauTree: Expected branch m_t_Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_Mt")
        else:
            self.m_t_Mt_branch.SetAddress(<void*>&self.m_t_Mt_value)

        #print "making m_t_Mt_TauEnDown"
        self.m_t_Mt_TauEnDown_branch = the_tree.GetBranch("m_t_Mt_TauEnDown")
        #if not self.m_t_Mt_TauEnDown_branch and "m_t_Mt_TauEnDown" not in self.complained:
        if not self.m_t_Mt_TauEnDown_branch and "m_t_Mt_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch m_t_Mt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_Mt_TauEnDown")
        else:
            self.m_t_Mt_TauEnDown_branch.SetAddress(<void*>&self.m_t_Mt_TauEnDown_value)

        #print "making m_t_Mt_TauEnUp"
        self.m_t_Mt_TauEnUp_branch = the_tree.GetBranch("m_t_Mt_TauEnUp")
        #if not self.m_t_Mt_TauEnUp_branch and "m_t_Mt_TauEnUp" not in self.complained:
        if not self.m_t_Mt_TauEnUp_branch and "m_t_Mt_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch m_t_Mt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_Mt_TauEnUp")
        else:
            self.m_t_Mt_TauEnUp_branch.SetAddress(<void*>&self.m_t_Mt_TauEnUp_value)

        #print "making m_t_PZeta"
        self.m_t_PZeta_branch = the_tree.GetBranch("m_t_PZeta")
        #if not self.m_t_PZeta_branch and "m_t_PZeta" not in self.complained:
        if not self.m_t_PZeta_branch and "m_t_PZeta":
            warnings.warn( "MuTauTree: Expected branch m_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_PZeta")
        else:
            self.m_t_PZeta_branch.SetAddress(<void*>&self.m_t_PZeta_value)

        #print "making m_t_PZetaVis"
        self.m_t_PZetaVis_branch = the_tree.GetBranch("m_t_PZetaVis")
        #if not self.m_t_PZetaVis_branch and "m_t_PZetaVis" not in self.complained:
        if not self.m_t_PZetaVis_branch and "m_t_PZetaVis":
            warnings.warn( "MuTauTree: Expected branch m_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_PZetaVis")
        else:
            self.m_t_PZetaVis_branch.SetAddress(<void*>&self.m_t_PZetaVis_value)

        #print "making m_t_Phi"
        self.m_t_Phi_branch = the_tree.GetBranch("m_t_Phi")
        #if not self.m_t_Phi_branch and "m_t_Phi" not in self.complained:
        if not self.m_t_Phi_branch and "m_t_Phi":
            warnings.warn( "MuTauTree: Expected branch m_t_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_Phi")
        else:
            self.m_t_Phi_branch.SetAddress(<void*>&self.m_t_Phi_value)

        #print "making m_t_Pt"
        self.m_t_Pt_branch = the_tree.GetBranch("m_t_Pt")
        #if not self.m_t_Pt_branch and "m_t_Pt" not in self.complained:
        if not self.m_t_Pt_branch and "m_t_Pt":
            warnings.warn( "MuTauTree: Expected branch m_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_Pt")
        else:
            self.m_t_Pt_branch.SetAddress(<void*>&self.m_t_Pt_value)

        #print "making m_t_SS"
        self.m_t_SS_branch = the_tree.GetBranch("m_t_SS")
        #if not self.m_t_SS_branch and "m_t_SS" not in self.complained:
        if not self.m_t_SS_branch and "m_t_SS":
            warnings.warn( "MuTauTree: Expected branch m_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_SS")
        else:
            self.m_t_SS_branch.SetAddress(<void*>&self.m_t_SS_value)

        #print "making m_t_ToMETDPhi_Ty1"
        self.m_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m_t_ToMETDPhi_Ty1")
        #if not self.m_t_ToMETDPhi_Ty1_branch and "m_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.m_t_ToMETDPhi_Ty1_branch and "m_t_ToMETDPhi_Ty1":
            warnings.warn( "MuTauTree: Expected branch m_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_ToMETDPhi_Ty1")
        else:
            self.m_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m_t_ToMETDPhi_Ty1_value)

        #print "making m_t_collinearmass"
        self.m_t_collinearmass_branch = the_tree.GetBranch("m_t_collinearmass")
        #if not self.m_t_collinearmass_branch and "m_t_collinearmass" not in self.complained:
        if not self.m_t_collinearmass_branch and "m_t_collinearmass":
            warnings.warn( "MuTauTree: Expected branch m_t_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_collinearmass")
        else:
            self.m_t_collinearmass_branch.SetAddress(<void*>&self.m_t_collinearmass_value)

        #print "making m_t_collinearmass_JetEnDown"
        self.m_t_collinearmass_JetEnDown_branch = the_tree.GetBranch("m_t_collinearmass_JetEnDown")
        #if not self.m_t_collinearmass_JetEnDown_branch and "m_t_collinearmass_JetEnDown" not in self.complained:
        if not self.m_t_collinearmass_JetEnDown_branch and "m_t_collinearmass_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch m_t_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_collinearmass_JetEnDown")
        else:
            self.m_t_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m_t_collinearmass_JetEnDown_value)

        #print "making m_t_collinearmass_JetEnUp"
        self.m_t_collinearmass_JetEnUp_branch = the_tree.GetBranch("m_t_collinearmass_JetEnUp")
        #if not self.m_t_collinearmass_JetEnUp_branch and "m_t_collinearmass_JetEnUp" not in self.complained:
        if not self.m_t_collinearmass_JetEnUp_branch and "m_t_collinearmass_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch m_t_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_collinearmass_JetEnUp")
        else:
            self.m_t_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m_t_collinearmass_JetEnUp_value)

        #print "making m_t_collinearmass_TauEnDown"
        self.m_t_collinearmass_TauEnDown_branch = the_tree.GetBranch("m_t_collinearmass_TauEnDown")
        #if not self.m_t_collinearmass_TauEnDown_branch and "m_t_collinearmass_TauEnDown" not in self.complained:
        if not self.m_t_collinearmass_TauEnDown_branch and "m_t_collinearmass_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch m_t_collinearmass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_collinearmass_TauEnDown")
        else:
            self.m_t_collinearmass_TauEnDown_branch.SetAddress(<void*>&self.m_t_collinearmass_TauEnDown_value)

        #print "making m_t_collinearmass_TauEnUp"
        self.m_t_collinearmass_TauEnUp_branch = the_tree.GetBranch("m_t_collinearmass_TauEnUp")
        #if not self.m_t_collinearmass_TauEnUp_branch and "m_t_collinearmass_TauEnUp" not in self.complained:
        if not self.m_t_collinearmass_TauEnUp_branch and "m_t_collinearmass_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch m_t_collinearmass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_collinearmass_TauEnUp")
        else:
            self.m_t_collinearmass_TauEnUp_branch.SetAddress(<void*>&self.m_t_collinearmass_TauEnUp_value)

        #print "making m_t_collinearmass_UnclusteredEnDown"
        self.m_t_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m_t_collinearmass_UnclusteredEnDown")
        #if not self.m_t_collinearmass_UnclusteredEnDown_branch and "m_t_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m_t_collinearmass_UnclusteredEnDown_branch and "m_t_collinearmass_UnclusteredEnDown":
            warnings.warn( "MuTauTree: Expected branch m_t_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_collinearmass_UnclusteredEnDown")
        else:
            self.m_t_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m_t_collinearmass_UnclusteredEnDown_value)

        #print "making m_t_collinearmass_UnclusteredEnUp"
        self.m_t_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m_t_collinearmass_UnclusteredEnUp")
        #if not self.m_t_collinearmass_UnclusteredEnUp_branch and "m_t_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m_t_collinearmass_UnclusteredEnUp_branch and "m_t_collinearmass_UnclusteredEnUp":
            warnings.warn( "MuTauTree: Expected branch m_t_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_collinearmass_UnclusteredEnUp")
        else:
            self.m_t_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m_t_collinearmass_UnclusteredEnUp_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "MuTauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "MuTauTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "MuTauTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "MuTauTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "MuTauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "MuTauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "MuTauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "MuTauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "MuTauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "MuTauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "MuTauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "MuTauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "MuTauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "MuTauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "MuTauTree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "MuTauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "MuTauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "MuTauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "MuTauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making raw_pfMetEt"
        self.raw_pfMetEt_branch = the_tree.GetBranch("raw_pfMetEt")
        #if not self.raw_pfMetEt_branch and "raw_pfMetEt" not in self.complained:
        if not self.raw_pfMetEt_branch and "raw_pfMetEt":
            warnings.warn( "MuTauTree: Expected branch raw_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetEt")
        else:
            self.raw_pfMetEt_branch.SetAddress(<void*>&self.raw_pfMetEt_value)

        #print "making raw_pfMetPhi"
        self.raw_pfMetPhi_branch = the_tree.GetBranch("raw_pfMetPhi")
        #if not self.raw_pfMetPhi_branch and "raw_pfMetPhi" not in self.complained:
        if not self.raw_pfMetPhi_branch and "raw_pfMetPhi":
            warnings.warn( "MuTauTree: Expected branch raw_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetPhi")
        else:
            self.raw_pfMetPhi_branch.SetAddress(<void*>&self.raw_pfMetPhi_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "MuTauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "MuTauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "MuTauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "MuTauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE17SingleMu8Group"
        self.singleE17SingleMu8Group_branch = the_tree.GetBranch("singleE17SingleMu8Group")
        #if not self.singleE17SingleMu8Group_branch and "singleE17SingleMu8Group" not in self.complained:
        if not self.singleE17SingleMu8Group_branch and "singleE17SingleMu8Group":
            warnings.warn( "MuTauTree: Expected branch singleE17SingleMu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE17SingleMu8Group")
        else:
            self.singleE17SingleMu8Group_branch.SetAddress(<void*>&self.singleE17SingleMu8Group_value)

        #print "making singleE17SingleMu8Pass"
        self.singleE17SingleMu8Pass_branch = the_tree.GetBranch("singleE17SingleMu8Pass")
        #if not self.singleE17SingleMu8Pass_branch and "singleE17SingleMu8Pass" not in self.complained:
        if not self.singleE17SingleMu8Pass_branch and "singleE17SingleMu8Pass":
            warnings.warn( "MuTauTree: Expected branch singleE17SingleMu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE17SingleMu8Pass")
        else:
            self.singleE17SingleMu8Pass_branch.SetAddress(<void*>&self.singleE17SingleMu8Pass_value)

        #print "making singleE17SingleMu8Prescale"
        self.singleE17SingleMu8Prescale_branch = the_tree.GetBranch("singleE17SingleMu8Prescale")
        #if not self.singleE17SingleMu8Prescale_branch and "singleE17SingleMu8Prescale" not in self.complained:
        if not self.singleE17SingleMu8Prescale_branch and "singleE17SingleMu8Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE17SingleMu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE17SingleMu8Prescale")
        else:
            self.singleE17SingleMu8Prescale_branch.SetAddress(<void*>&self.singleE17SingleMu8Prescale_value)

        #print "making singleE22eta2p1LooseGroup"
        self.singleE22eta2p1LooseGroup_branch = the_tree.GetBranch("singleE22eta2p1LooseGroup")
        #if not self.singleE22eta2p1LooseGroup_branch and "singleE22eta2p1LooseGroup" not in self.complained:
        if not self.singleE22eta2p1LooseGroup_branch and "singleE22eta2p1LooseGroup":
            warnings.warn( "MuTauTree: Expected branch singleE22eta2p1LooseGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22eta2p1LooseGroup")
        else:
            self.singleE22eta2p1LooseGroup_branch.SetAddress(<void*>&self.singleE22eta2p1LooseGroup_value)

        #print "making singleE22eta2p1LoosePass"
        self.singleE22eta2p1LoosePass_branch = the_tree.GetBranch("singleE22eta2p1LoosePass")
        #if not self.singleE22eta2p1LoosePass_branch and "singleE22eta2p1LoosePass" not in self.complained:
        if not self.singleE22eta2p1LoosePass_branch and "singleE22eta2p1LoosePass":
            warnings.warn( "MuTauTree: Expected branch singleE22eta2p1LoosePass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22eta2p1LoosePass")
        else:
            self.singleE22eta2p1LoosePass_branch.SetAddress(<void*>&self.singleE22eta2p1LoosePass_value)

        #print "making singleE22eta2p1LoosePrescale"
        self.singleE22eta2p1LoosePrescale_branch = the_tree.GetBranch("singleE22eta2p1LoosePrescale")
        #if not self.singleE22eta2p1LoosePrescale_branch and "singleE22eta2p1LoosePrescale" not in self.complained:
        if not self.singleE22eta2p1LoosePrescale_branch and "singleE22eta2p1LoosePrescale":
            warnings.warn( "MuTauTree: Expected branch singleE22eta2p1LoosePrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22eta2p1LoosePrescale")
        else:
            self.singleE22eta2p1LoosePrescale_branch.SetAddress(<void*>&self.singleE22eta2p1LoosePrescale_value)

        #print "making singleE22eta2p1LooseTau20Group"
        self.singleE22eta2p1LooseTau20Group_branch = the_tree.GetBranch("singleE22eta2p1LooseTau20Group")
        #if not self.singleE22eta2p1LooseTau20Group_branch and "singleE22eta2p1LooseTau20Group" not in self.complained:
        if not self.singleE22eta2p1LooseTau20Group_branch and "singleE22eta2p1LooseTau20Group":
            warnings.warn( "MuTauTree: Expected branch singleE22eta2p1LooseTau20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22eta2p1LooseTau20Group")
        else:
            self.singleE22eta2p1LooseTau20Group_branch.SetAddress(<void*>&self.singleE22eta2p1LooseTau20Group_value)

        #print "making singleE22eta2p1LooseTau20Pass"
        self.singleE22eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleE22eta2p1LooseTau20Pass")
        #if not self.singleE22eta2p1LooseTau20Pass_branch and "singleE22eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleE22eta2p1LooseTau20Pass_branch and "singleE22eta2p1LooseTau20Pass":
            warnings.warn( "MuTauTree: Expected branch singleE22eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22eta2p1LooseTau20Pass")
        else:
            self.singleE22eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleE22eta2p1LooseTau20Pass_value)

        #print "making singleE22eta2p1LooseTau20Prescale"
        self.singleE22eta2p1LooseTau20Prescale_branch = the_tree.GetBranch("singleE22eta2p1LooseTau20Prescale")
        #if not self.singleE22eta2p1LooseTau20Prescale_branch and "singleE22eta2p1LooseTau20Prescale" not in self.complained:
        if not self.singleE22eta2p1LooseTau20Prescale_branch and "singleE22eta2p1LooseTau20Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE22eta2p1LooseTau20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22eta2p1LooseTau20Prescale")
        else:
            self.singleE22eta2p1LooseTau20Prescale_branch.SetAddress(<void*>&self.singleE22eta2p1LooseTau20Prescale_value)

        #print "making singleE23SingleMu8Group"
        self.singleE23SingleMu8Group_branch = the_tree.GetBranch("singleE23SingleMu8Group")
        #if not self.singleE23SingleMu8Group_branch and "singleE23SingleMu8Group" not in self.complained:
        if not self.singleE23SingleMu8Group_branch and "singleE23SingleMu8Group":
            warnings.warn( "MuTauTree: Expected branch singleE23SingleMu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23SingleMu8Group")
        else:
            self.singleE23SingleMu8Group_branch.SetAddress(<void*>&self.singleE23SingleMu8Group_value)

        #print "making singleE23SingleMu8Pass"
        self.singleE23SingleMu8Pass_branch = the_tree.GetBranch("singleE23SingleMu8Pass")
        #if not self.singleE23SingleMu8Pass_branch and "singleE23SingleMu8Pass" not in self.complained:
        if not self.singleE23SingleMu8Pass_branch and "singleE23SingleMu8Pass":
            warnings.warn( "MuTauTree: Expected branch singleE23SingleMu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23SingleMu8Pass")
        else:
            self.singleE23SingleMu8Pass_branch.SetAddress(<void*>&self.singleE23SingleMu8Pass_value)

        #print "making singleE23SingleMu8Prescale"
        self.singleE23SingleMu8Prescale_branch = the_tree.GetBranch("singleE23SingleMu8Prescale")
        #if not self.singleE23SingleMu8Prescale_branch and "singleE23SingleMu8Prescale" not in self.complained:
        if not self.singleE23SingleMu8Prescale_branch and "singleE23SingleMu8Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE23SingleMu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23SingleMu8Prescale")
        else:
            self.singleE23SingleMu8Prescale_branch.SetAddress(<void*>&self.singleE23SingleMu8Prescale_value)

        #print "making singleE23WPLooseGroup"
        self.singleE23WPLooseGroup_branch = the_tree.GetBranch("singleE23WPLooseGroup")
        #if not self.singleE23WPLooseGroup_branch and "singleE23WPLooseGroup" not in self.complained:
        if not self.singleE23WPLooseGroup_branch and "singleE23WPLooseGroup":
            warnings.warn( "MuTauTree: Expected branch singleE23WPLooseGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23WPLooseGroup")
        else:
            self.singleE23WPLooseGroup_branch.SetAddress(<void*>&self.singleE23WPLooseGroup_value)

        #print "making singleE23WPLoosePass"
        self.singleE23WPLoosePass_branch = the_tree.GetBranch("singleE23WPLoosePass")
        #if not self.singleE23WPLoosePass_branch and "singleE23WPLoosePass" not in self.complained:
        if not self.singleE23WPLoosePass_branch and "singleE23WPLoosePass":
            warnings.warn( "MuTauTree: Expected branch singleE23WPLoosePass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23WPLoosePass")
        else:
            self.singleE23WPLoosePass_branch.SetAddress(<void*>&self.singleE23WPLoosePass_value)

        #print "making singleE23WPLoosePrescale"
        self.singleE23WPLoosePrescale_branch = the_tree.GetBranch("singleE23WPLoosePrescale")
        #if not self.singleE23WPLoosePrescale_branch and "singleE23WPLoosePrescale" not in self.complained:
        if not self.singleE23WPLoosePrescale_branch and "singleE23WPLoosePrescale":
            warnings.warn( "MuTauTree: Expected branch singleE23WPLoosePrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23WPLoosePrescale")
        else:
            self.singleE23WPLoosePrescale_branch.SetAddress(<void*>&self.singleE23WPLoosePrescale_value)

        #print "making singleE25eta2p1TightGroup"
        self.singleE25eta2p1TightGroup_branch = the_tree.GetBranch("singleE25eta2p1TightGroup")
        #if not self.singleE25eta2p1TightGroup_branch and "singleE25eta2p1TightGroup" not in self.complained:
        if not self.singleE25eta2p1TightGroup_branch and "singleE25eta2p1TightGroup":
            warnings.warn( "MuTauTree: Expected branch singleE25eta2p1TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightGroup")
        else:
            self.singleE25eta2p1TightGroup_branch.SetAddress(<void*>&self.singleE25eta2p1TightGroup_value)

        #print "making singleE25eta2p1TightPass"
        self.singleE25eta2p1TightPass_branch = the_tree.GetBranch("singleE25eta2p1TightPass")
        #if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass" not in self.complained:
        if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass":
            warnings.warn( "MuTauTree: Expected branch singleE25eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPass")
        else:
            self.singleE25eta2p1TightPass_branch.SetAddress(<void*>&self.singleE25eta2p1TightPass_value)

        #print "making singleE25eta2p1TightPrescale"
        self.singleE25eta2p1TightPrescale_branch = the_tree.GetBranch("singleE25eta2p1TightPrescale")
        #if not self.singleE25eta2p1TightPrescale_branch and "singleE25eta2p1TightPrescale" not in self.complained:
        if not self.singleE25eta2p1TightPrescale_branch and "singleE25eta2p1TightPrescale":
            warnings.warn( "MuTauTree: Expected branch singleE25eta2p1TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPrescale")
        else:
            self.singleE25eta2p1TightPrescale_branch.SetAddress(<void*>&self.singleE25eta2p1TightPrescale_value)

        #print "making singleEGroup"
        self.singleEGroup_branch = the_tree.GetBranch("singleEGroup")
        #if not self.singleEGroup_branch and "singleEGroup" not in self.complained:
        if not self.singleEGroup_branch and "singleEGroup":
            warnings.warn( "MuTauTree: Expected branch singleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEGroup")
        else:
            self.singleEGroup_branch.SetAddress(<void*>&self.singleEGroup_value)

        #print "making singleEPass"
        self.singleEPass_branch = the_tree.GetBranch("singleEPass")
        #if not self.singleEPass_branch and "singleEPass" not in self.complained:
        if not self.singleEPass_branch and "singleEPass":
            warnings.warn( "MuTauTree: Expected branch singleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPass")
        else:
            self.singleEPass_branch.SetAddress(<void*>&self.singleEPass_value)

        #print "making singleEPrescale"
        self.singleEPrescale_branch = the_tree.GetBranch("singleEPrescale")
        #if not self.singleEPrescale_branch and "singleEPrescale" not in self.complained:
        if not self.singleEPrescale_branch and "singleEPrescale":
            warnings.warn( "MuTauTree: Expected branch singleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPrescale")
        else:
            self.singleEPrescale_branch.SetAddress(<void*>&self.singleEPrescale_value)

        #print "making singleESingleMuGroup"
        self.singleESingleMuGroup_branch = the_tree.GetBranch("singleESingleMuGroup")
        #if not self.singleESingleMuGroup_branch and "singleESingleMuGroup" not in self.complained:
        if not self.singleESingleMuGroup_branch and "singleESingleMuGroup":
            warnings.warn( "MuTauTree: Expected branch singleESingleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleESingleMuGroup")
        else:
            self.singleESingleMuGroup_branch.SetAddress(<void*>&self.singleESingleMuGroup_value)

        #print "making singleESingleMuPass"
        self.singleESingleMuPass_branch = the_tree.GetBranch("singleESingleMuPass")
        #if not self.singleESingleMuPass_branch and "singleESingleMuPass" not in self.complained:
        if not self.singleESingleMuPass_branch and "singleESingleMuPass":
            warnings.warn( "MuTauTree: Expected branch singleESingleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleESingleMuPass")
        else:
            self.singleESingleMuPass_branch.SetAddress(<void*>&self.singleESingleMuPass_value)

        #print "making singleESingleMuPrescale"
        self.singleESingleMuPrescale_branch = the_tree.GetBranch("singleESingleMuPrescale")
        #if not self.singleESingleMuPrescale_branch and "singleESingleMuPrescale" not in self.complained:
        if not self.singleESingleMuPrescale_branch and "singleESingleMuPrescale":
            warnings.warn( "MuTauTree: Expected branch singleESingleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleESingleMuPrescale")
        else:
            self.singleESingleMuPrescale_branch.SetAddress(<void*>&self.singleESingleMuPrescale_value)

        #print "making singleE_leg1Group"
        self.singleE_leg1Group_branch = the_tree.GetBranch("singleE_leg1Group")
        #if not self.singleE_leg1Group_branch and "singleE_leg1Group" not in self.complained:
        if not self.singleE_leg1Group_branch and "singleE_leg1Group":
            warnings.warn( "MuTauTree: Expected branch singleE_leg1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg1Group")
        else:
            self.singleE_leg1Group_branch.SetAddress(<void*>&self.singleE_leg1Group_value)

        #print "making singleE_leg1Pass"
        self.singleE_leg1Pass_branch = the_tree.GetBranch("singleE_leg1Pass")
        #if not self.singleE_leg1Pass_branch and "singleE_leg1Pass" not in self.complained:
        if not self.singleE_leg1Pass_branch and "singleE_leg1Pass":
            warnings.warn( "MuTauTree: Expected branch singleE_leg1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg1Pass")
        else:
            self.singleE_leg1Pass_branch.SetAddress(<void*>&self.singleE_leg1Pass_value)

        #print "making singleE_leg1Prescale"
        self.singleE_leg1Prescale_branch = the_tree.GetBranch("singleE_leg1Prescale")
        #if not self.singleE_leg1Prescale_branch and "singleE_leg1Prescale" not in self.complained:
        if not self.singleE_leg1Prescale_branch and "singleE_leg1Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE_leg1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg1Prescale")
        else:
            self.singleE_leg1Prescale_branch.SetAddress(<void*>&self.singleE_leg1Prescale_value)

        #print "making singleE_leg2Group"
        self.singleE_leg2Group_branch = the_tree.GetBranch("singleE_leg2Group")
        #if not self.singleE_leg2Group_branch and "singleE_leg2Group" not in self.complained:
        if not self.singleE_leg2Group_branch and "singleE_leg2Group":
            warnings.warn( "MuTauTree: Expected branch singleE_leg2Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg2Group")
        else:
            self.singleE_leg2Group_branch.SetAddress(<void*>&self.singleE_leg2Group_value)

        #print "making singleE_leg2Pass"
        self.singleE_leg2Pass_branch = the_tree.GetBranch("singleE_leg2Pass")
        #if not self.singleE_leg2Pass_branch and "singleE_leg2Pass" not in self.complained:
        if not self.singleE_leg2Pass_branch and "singleE_leg2Pass":
            warnings.warn( "MuTauTree: Expected branch singleE_leg2Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg2Pass")
        else:
            self.singleE_leg2Pass_branch.SetAddress(<void*>&self.singleE_leg2Pass_value)

        #print "making singleE_leg2Prescale"
        self.singleE_leg2Prescale_branch = the_tree.GetBranch("singleE_leg2Prescale")
        #if not self.singleE_leg2Prescale_branch and "singleE_leg2Prescale" not in self.complained:
        if not self.singleE_leg2Prescale_branch and "singleE_leg2Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE_leg2Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg2Prescale")
        else:
            self.singleE_leg2Prescale_branch.SetAddress(<void*>&self.singleE_leg2Prescale_value)

        #print "making singleIsoMu18Group"
        self.singleIsoMu18Group_branch = the_tree.GetBranch("singleIsoMu18Group")
        #if not self.singleIsoMu18Group_branch and "singleIsoMu18Group" not in self.complained:
        if not self.singleIsoMu18Group_branch and "singleIsoMu18Group":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu18Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu18Group")
        else:
            self.singleIsoMu18Group_branch.SetAddress(<void*>&self.singleIsoMu18Group_value)

        #print "making singleIsoMu18Pass"
        self.singleIsoMu18Pass_branch = the_tree.GetBranch("singleIsoMu18Pass")
        #if not self.singleIsoMu18Pass_branch and "singleIsoMu18Pass" not in self.complained:
        if not self.singleIsoMu18Pass_branch and "singleIsoMu18Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu18Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu18Pass")
        else:
            self.singleIsoMu18Pass_branch.SetAddress(<void*>&self.singleIsoMu18Pass_value)

        #print "making singleIsoMu18Prescale"
        self.singleIsoMu18Prescale_branch = the_tree.GetBranch("singleIsoMu18Prescale")
        #if not self.singleIsoMu18Prescale_branch and "singleIsoMu18Prescale" not in self.complained:
        if not self.singleIsoMu18Prescale_branch and "singleIsoMu18Prescale":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu18Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu18Prescale")
        else:
            self.singleIsoMu18Prescale_branch.SetAddress(<void*>&self.singleIsoMu18Prescale_value)

        #print "making singleIsoMu20Group"
        self.singleIsoMu20Group_branch = the_tree.GetBranch("singleIsoMu20Group")
        #if not self.singleIsoMu20Group_branch and "singleIsoMu20Group" not in self.complained:
        if not self.singleIsoMu20Group_branch and "singleIsoMu20Group":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Group")
        else:
            self.singleIsoMu20Group_branch.SetAddress(<void*>&self.singleIsoMu20Group_value)

        #print "making singleIsoMu20Pass"
        self.singleIsoMu20Pass_branch = the_tree.GetBranch("singleIsoMu20Pass")
        #if not self.singleIsoMu20Pass_branch and "singleIsoMu20Pass" not in self.complained:
        if not self.singleIsoMu20Pass_branch and "singleIsoMu20Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Pass")
        else:
            self.singleIsoMu20Pass_branch.SetAddress(<void*>&self.singleIsoMu20Pass_value)

        #print "making singleIsoMu20Prescale"
        self.singleIsoMu20Prescale_branch = the_tree.GetBranch("singleIsoMu20Prescale")
        #if not self.singleIsoMu20Prescale_branch and "singleIsoMu20Prescale" not in self.complained:
        if not self.singleIsoMu20Prescale_branch and "singleIsoMu20Prescale":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Prescale")
        else:
            self.singleIsoMu20Prescale_branch.SetAddress(<void*>&self.singleIsoMu20Prescale_value)

        #print "making singleIsoMu22Group"
        self.singleIsoMu22Group_branch = the_tree.GetBranch("singleIsoMu22Group")
        #if not self.singleIsoMu22Group_branch and "singleIsoMu22Group" not in self.complained:
        if not self.singleIsoMu22Group_branch and "singleIsoMu22Group":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu22Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Group")
        else:
            self.singleIsoMu22Group_branch.SetAddress(<void*>&self.singleIsoMu22Group_value)

        #print "making singleIsoMu22Pass"
        self.singleIsoMu22Pass_branch = the_tree.GetBranch("singleIsoMu22Pass")
        #if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass" not in self.complained:
        if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Pass")
        else:
            self.singleIsoMu22Pass_branch.SetAddress(<void*>&self.singleIsoMu22Pass_value)

        #print "making singleIsoMu22Prescale"
        self.singleIsoMu22Prescale_branch = the_tree.GetBranch("singleIsoMu22Prescale")
        #if not self.singleIsoMu22Prescale_branch and "singleIsoMu22Prescale" not in self.complained:
        if not self.singleIsoMu22Prescale_branch and "singleIsoMu22Prescale":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu22Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Prescale")
        else:
            self.singleIsoMu22Prescale_branch.SetAddress(<void*>&self.singleIsoMu22Prescale_value)

        #print "making singleIsoMu22eta2p1Group"
        self.singleIsoMu22eta2p1Group_branch = the_tree.GetBranch("singleIsoMu22eta2p1Group")
        #if not self.singleIsoMu22eta2p1Group_branch and "singleIsoMu22eta2p1Group" not in self.complained:
        if not self.singleIsoMu22eta2p1Group_branch and "singleIsoMu22eta2p1Group":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu22eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Group")
        else:
            self.singleIsoMu22eta2p1Group_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Group_value)

        #print "making singleIsoMu22eta2p1Pass"
        self.singleIsoMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu22eta2p1Pass")
        #if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Pass")
        else:
            self.singleIsoMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Pass_value)

        #print "making singleIsoMu22eta2p1Prescale"
        self.singleIsoMu22eta2p1Prescale_branch = the_tree.GetBranch("singleIsoMu22eta2p1Prescale")
        #if not self.singleIsoMu22eta2p1Prescale_branch and "singleIsoMu22eta2p1Prescale" not in self.complained:
        if not self.singleIsoMu22eta2p1Prescale_branch and "singleIsoMu22eta2p1Prescale":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu22eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Prescale")
        else:
            self.singleIsoMu22eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Prescale_value)

        #print "making singleIsoMu27Group"
        self.singleIsoMu27Group_branch = the_tree.GetBranch("singleIsoMu27Group")
        #if not self.singleIsoMu27Group_branch and "singleIsoMu27Group" not in self.complained:
        if not self.singleIsoMu27Group_branch and "singleIsoMu27Group":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu27Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Group")
        else:
            self.singleIsoMu27Group_branch.SetAddress(<void*>&self.singleIsoMu27Group_value)

        #print "making singleIsoMu27Pass"
        self.singleIsoMu27Pass_branch = the_tree.GetBranch("singleIsoMu27Pass")
        #if not self.singleIsoMu27Pass_branch and "singleIsoMu27Pass" not in self.complained:
        if not self.singleIsoMu27Pass_branch and "singleIsoMu27Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Pass")
        else:
            self.singleIsoMu27Pass_branch.SetAddress(<void*>&self.singleIsoMu27Pass_value)

        #print "making singleIsoMu27Prescale"
        self.singleIsoMu27Prescale_branch = the_tree.GetBranch("singleIsoMu27Prescale")
        #if not self.singleIsoMu27Prescale_branch and "singleIsoMu27Prescale" not in self.complained:
        if not self.singleIsoMu27Prescale_branch and "singleIsoMu27Prescale":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu27Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Prescale")
        else:
            self.singleIsoMu27Prescale_branch.SetAddress(<void*>&self.singleIsoMu27Prescale_value)

        #print "making singleIsoTkMu20Group"
        self.singleIsoTkMu20Group_branch = the_tree.GetBranch("singleIsoTkMu20Group")
        #if not self.singleIsoTkMu20Group_branch and "singleIsoTkMu20Group" not in self.complained:
        if not self.singleIsoTkMu20Group_branch and "singleIsoTkMu20Group":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu20Group")
        else:
            self.singleIsoTkMu20Group_branch.SetAddress(<void*>&self.singleIsoTkMu20Group_value)

        #print "making singleIsoTkMu20Pass"
        self.singleIsoTkMu20Pass_branch = the_tree.GetBranch("singleIsoTkMu20Pass")
        #if not self.singleIsoTkMu20Pass_branch and "singleIsoTkMu20Pass" not in self.complained:
        if not self.singleIsoTkMu20Pass_branch and "singleIsoTkMu20Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu20Pass")
        else:
            self.singleIsoTkMu20Pass_branch.SetAddress(<void*>&self.singleIsoTkMu20Pass_value)

        #print "making singleIsoTkMu20Prescale"
        self.singleIsoTkMu20Prescale_branch = the_tree.GetBranch("singleIsoTkMu20Prescale")
        #if not self.singleIsoTkMu20Prescale_branch and "singleIsoTkMu20Prescale" not in self.complained:
        if not self.singleIsoTkMu20Prescale_branch and "singleIsoTkMu20Prescale":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu20Prescale")
        else:
            self.singleIsoTkMu20Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu20Prescale_value)

        #print "making singleIsoTkMu22Group"
        self.singleIsoTkMu22Group_branch = the_tree.GetBranch("singleIsoTkMu22Group")
        #if not self.singleIsoTkMu22Group_branch and "singleIsoTkMu22Group" not in self.complained:
        if not self.singleIsoTkMu22Group_branch and "singleIsoTkMu22Group":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu22Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Group")
        else:
            self.singleIsoTkMu22Group_branch.SetAddress(<void*>&self.singleIsoTkMu22Group_value)

        #print "making singleIsoTkMu22Pass"
        self.singleIsoTkMu22Pass_branch = the_tree.GetBranch("singleIsoTkMu22Pass")
        #if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass" not in self.complained:
        if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Pass")
        else:
            self.singleIsoTkMu22Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22Pass_value)

        #print "making singleIsoTkMu22Prescale"
        self.singleIsoTkMu22Prescale_branch = the_tree.GetBranch("singleIsoTkMu22Prescale")
        #if not self.singleIsoTkMu22Prescale_branch and "singleIsoTkMu22Prescale" not in self.complained:
        if not self.singleIsoTkMu22Prescale_branch and "singleIsoTkMu22Prescale":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu22Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Prescale")
        else:
            self.singleIsoTkMu22Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu22Prescale_value)

        #print "making singleMu17SingleE12Group"
        self.singleMu17SingleE12Group_branch = the_tree.GetBranch("singleMu17SingleE12Group")
        #if not self.singleMu17SingleE12Group_branch and "singleMu17SingleE12Group" not in self.complained:
        if not self.singleMu17SingleE12Group_branch and "singleMu17SingleE12Group":
            warnings.warn( "MuTauTree: Expected branch singleMu17SingleE12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu17SingleE12Group")
        else:
            self.singleMu17SingleE12Group_branch.SetAddress(<void*>&self.singleMu17SingleE12Group_value)

        #print "making singleMu17SingleE12Pass"
        self.singleMu17SingleE12Pass_branch = the_tree.GetBranch("singleMu17SingleE12Pass")
        #if not self.singleMu17SingleE12Pass_branch and "singleMu17SingleE12Pass" not in self.complained:
        if not self.singleMu17SingleE12Pass_branch and "singleMu17SingleE12Pass":
            warnings.warn( "MuTauTree: Expected branch singleMu17SingleE12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu17SingleE12Pass")
        else:
            self.singleMu17SingleE12Pass_branch.SetAddress(<void*>&self.singleMu17SingleE12Pass_value)

        #print "making singleMu17SingleE12Prescale"
        self.singleMu17SingleE12Prescale_branch = the_tree.GetBranch("singleMu17SingleE12Prescale")
        #if not self.singleMu17SingleE12Prescale_branch and "singleMu17SingleE12Prescale" not in self.complained:
        if not self.singleMu17SingleE12Prescale_branch and "singleMu17SingleE12Prescale":
            warnings.warn( "MuTauTree: Expected branch singleMu17SingleE12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu17SingleE12Prescale")
        else:
            self.singleMu17SingleE12Prescale_branch.SetAddress(<void*>&self.singleMu17SingleE12Prescale_value)

        #print "making singleMu23SingleE12Group"
        self.singleMu23SingleE12Group_branch = the_tree.GetBranch("singleMu23SingleE12Group")
        #if not self.singleMu23SingleE12Group_branch and "singleMu23SingleE12Group" not in self.complained:
        if not self.singleMu23SingleE12Group_branch and "singleMu23SingleE12Group":
            warnings.warn( "MuTauTree: Expected branch singleMu23SingleE12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12Group")
        else:
            self.singleMu23SingleE12Group_branch.SetAddress(<void*>&self.singleMu23SingleE12Group_value)

        #print "making singleMu23SingleE12Pass"
        self.singleMu23SingleE12Pass_branch = the_tree.GetBranch("singleMu23SingleE12Pass")
        #if not self.singleMu23SingleE12Pass_branch and "singleMu23SingleE12Pass" not in self.complained:
        if not self.singleMu23SingleE12Pass_branch and "singleMu23SingleE12Pass":
            warnings.warn( "MuTauTree: Expected branch singleMu23SingleE12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12Pass")
        else:
            self.singleMu23SingleE12Pass_branch.SetAddress(<void*>&self.singleMu23SingleE12Pass_value)

        #print "making singleMu23SingleE12Prescale"
        self.singleMu23SingleE12Prescale_branch = the_tree.GetBranch("singleMu23SingleE12Prescale")
        #if not self.singleMu23SingleE12Prescale_branch and "singleMu23SingleE12Prescale" not in self.complained:
        if not self.singleMu23SingleE12Prescale_branch and "singleMu23SingleE12Prescale":
            warnings.warn( "MuTauTree: Expected branch singleMu23SingleE12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12Prescale")
        else:
            self.singleMu23SingleE12Prescale_branch.SetAddress(<void*>&self.singleMu23SingleE12Prescale_value)

        #print "making singleMuGroup"
        self.singleMuGroup_branch = the_tree.GetBranch("singleMuGroup")
        #if not self.singleMuGroup_branch and "singleMuGroup" not in self.complained:
        if not self.singleMuGroup_branch and "singleMuGroup":
            warnings.warn( "MuTauTree: Expected branch singleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuGroup")
        else:
            self.singleMuGroup_branch.SetAddress(<void*>&self.singleMuGroup_value)

        #print "making singleMuPass"
        self.singleMuPass_branch = the_tree.GetBranch("singleMuPass")
        #if not self.singleMuPass_branch and "singleMuPass" not in self.complained:
        if not self.singleMuPass_branch and "singleMuPass":
            warnings.warn( "MuTauTree: Expected branch singleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPass")
        else:
            self.singleMuPass_branch.SetAddress(<void*>&self.singleMuPass_value)

        #print "making singleMuPrescale"
        self.singleMuPrescale_branch = the_tree.GetBranch("singleMuPrescale")
        #if not self.singleMuPrescale_branch and "singleMuPrescale" not in self.complained:
        if not self.singleMuPrescale_branch and "singleMuPrescale":
            warnings.warn( "MuTauTree: Expected branch singleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPrescale")
        else:
            self.singleMuPrescale_branch.SetAddress(<void*>&self.singleMuPrescale_value)

        #print "making singleMuSingleEGroup"
        self.singleMuSingleEGroup_branch = the_tree.GetBranch("singleMuSingleEGroup")
        #if not self.singleMuSingleEGroup_branch and "singleMuSingleEGroup" not in self.complained:
        if not self.singleMuSingleEGroup_branch and "singleMuSingleEGroup":
            warnings.warn( "MuTauTree: Expected branch singleMuSingleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuSingleEGroup")
        else:
            self.singleMuSingleEGroup_branch.SetAddress(<void*>&self.singleMuSingleEGroup_value)

        #print "making singleMuSingleEPass"
        self.singleMuSingleEPass_branch = the_tree.GetBranch("singleMuSingleEPass")
        #if not self.singleMuSingleEPass_branch and "singleMuSingleEPass" not in self.complained:
        if not self.singleMuSingleEPass_branch and "singleMuSingleEPass":
            warnings.warn( "MuTauTree: Expected branch singleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuSingleEPass")
        else:
            self.singleMuSingleEPass_branch.SetAddress(<void*>&self.singleMuSingleEPass_value)

        #print "making singleMuSingleEPrescale"
        self.singleMuSingleEPrescale_branch = the_tree.GetBranch("singleMuSingleEPrescale")
        #if not self.singleMuSingleEPrescale_branch and "singleMuSingleEPrescale" not in self.complained:
        if not self.singleMuSingleEPrescale_branch and "singleMuSingleEPrescale":
            warnings.warn( "MuTauTree: Expected branch singleMuSingleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuSingleEPrescale")
        else:
            self.singleMuSingleEPrescale_branch.SetAddress(<void*>&self.singleMuSingleEPrescale_value)

        #print "making singleMu_leg1Group"
        self.singleMu_leg1Group_branch = the_tree.GetBranch("singleMu_leg1Group")
        #if not self.singleMu_leg1Group_branch and "singleMu_leg1Group" not in self.complained:
        if not self.singleMu_leg1Group_branch and "singleMu_leg1Group":
            warnings.warn( "MuTauTree: Expected branch singleMu_leg1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Group")
        else:
            self.singleMu_leg1Group_branch.SetAddress(<void*>&self.singleMu_leg1Group_value)

        #print "making singleMu_leg1Pass"
        self.singleMu_leg1Pass_branch = the_tree.GetBranch("singleMu_leg1Pass")
        #if not self.singleMu_leg1Pass_branch and "singleMu_leg1Pass" not in self.complained:
        if not self.singleMu_leg1Pass_branch and "singleMu_leg1Pass":
            warnings.warn( "MuTauTree: Expected branch singleMu_leg1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Pass")
        else:
            self.singleMu_leg1Pass_branch.SetAddress(<void*>&self.singleMu_leg1Pass_value)

        #print "making singleMu_leg1Prescale"
        self.singleMu_leg1Prescale_branch = the_tree.GetBranch("singleMu_leg1Prescale")
        #if not self.singleMu_leg1Prescale_branch and "singleMu_leg1Prescale" not in self.complained:
        if not self.singleMu_leg1Prescale_branch and "singleMu_leg1Prescale":
            warnings.warn( "MuTauTree: Expected branch singleMu_leg1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Prescale")
        else:
            self.singleMu_leg1Prescale_branch.SetAddress(<void*>&self.singleMu_leg1Prescale_value)

        #print "making singleMu_leg1_noisoGroup"
        self.singleMu_leg1_noisoGroup_branch = the_tree.GetBranch("singleMu_leg1_noisoGroup")
        #if not self.singleMu_leg1_noisoGroup_branch and "singleMu_leg1_noisoGroup" not in self.complained:
        if not self.singleMu_leg1_noisoGroup_branch and "singleMu_leg1_noisoGroup":
            warnings.warn( "MuTauTree: Expected branch singleMu_leg1_noisoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoGroup")
        else:
            self.singleMu_leg1_noisoGroup_branch.SetAddress(<void*>&self.singleMu_leg1_noisoGroup_value)

        #print "making singleMu_leg1_noisoPass"
        self.singleMu_leg1_noisoPass_branch = the_tree.GetBranch("singleMu_leg1_noisoPass")
        #if not self.singleMu_leg1_noisoPass_branch and "singleMu_leg1_noisoPass" not in self.complained:
        if not self.singleMu_leg1_noisoPass_branch and "singleMu_leg1_noisoPass":
            warnings.warn( "MuTauTree: Expected branch singleMu_leg1_noisoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoPass")
        else:
            self.singleMu_leg1_noisoPass_branch.SetAddress(<void*>&self.singleMu_leg1_noisoPass_value)

        #print "making singleMu_leg1_noisoPrescale"
        self.singleMu_leg1_noisoPrescale_branch = the_tree.GetBranch("singleMu_leg1_noisoPrescale")
        #if not self.singleMu_leg1_noisoPrescale_branch and "singleMu_leg1_noisoPrescale" not in self.complained:
        if not self.singleMu_leg1_noisoPrescale_branch and "singleMu_leg1_noisoPrescale":
            warnings.warn( "MuTauTree: Expected branch singleMu_leg1_noisoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoPrescale")
        else:
            self.singleMu_leg1_noisoPrescale_branch.SetAddress(<void*>&self.singleMu_leg1_noisoPrescale_value)

        #print "making singleMu_leg2Group"
        self.singleMu_leg2Group_branch = the_tree.GetBranch("singleMu_leg2Group")
        #if not self.singleMu_leg2Group_branch and "singleMu_leg2Group" not in self.complained:
        if not self.singleMu_leg2Group_branch and "singleMu_leg2Group":
            warnings.warn( "MuTauTree: Expected branch singleMu_leg2Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Group")
        else:
            self.singleMu_leg2Group_branch.SetAddress(<void*>&self.singleMu_leg2Group_value)

        #print "making singleMu_leg2Pass"
        self.singleMu_leg2Pass_branch = the_tree.GetBranch("singleMu_leg2Pass")
        #if not self.singleMu_leg2Pass_branch and "singleMu_leg2Pass" not in self.complained:
        if not self.singleMu_leg2Pass_branch and "singleMu_leg2Pass":
            warnings.warn( "MuTauTree: Expected branch singleMu_leg2Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Pass")
        else:
            self.singleMu_leg2Pass_branch.SetAddress(<void*>&self.singleMu_leg2Pass_value)

        #print "making singleMu_leg2Prescale"
        self.singleMu_leg2Prescale_branch = the_tree.GetBranch("singleMu_leg2Prescale")
        #if not self.singleMu_leg2Prescale_branch and "singleMu_leg2Prescale" not in self.complained:
        if not self.singleMu_leg2Prescale_branch and "singleMu_leg2Prescale":
            warnings.warn( "MuTauTree: Expected branch singleMu_leg2Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Prescale")
        else:
            self.singleMu_leg2Prescale_branch.SetAddress(<void*>&self.singleMu_leg2Prescale_value)

        #print "making singleMu_leg2_noisoGroup"
        self.singleMu_leg2_noisoGroup_branch = the_tree.GetBranch("singleMu_leg2_noisoGroup")
        #if not self.singleMu_leg2_noisoGroup_branch and "singleMu_leg2_noisoGroup" not in self.complained:
        if not self.singleMu_leg2_noisoGroup_branch and "singleMu_leg2_noisoGroup":
            warnings.warn( "MuTauTree: Expected branch singleMu_leg2_noisoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoGroup")
        else:
            self.singleMu_leg2_noisoGroup_branch.SetAddress(<void*>&self.singleMu_leg2_noisoGroup_value)

        #print "making singleMu_leg2_noisoPass"
        self.singleMu_leg2_noisoPass_branch = the_tree.GetBranch("singleMu_leg2_noisoPass")
        #if not self.singleMu_leg2_noisoPass_branch and "singleMu_leg2_noisoPass" not in self.complained:
        if not self.singleMu_leg2_noisoPass_branch and "singleMu_leg2_noisoPass":
            warnings.warn( "MuTauTree: Expected branch singleMu_leg2_noisoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoPass")
        else:
            self.singleMu_leg2_noisoPass_branch.SetAddress(<void*>&self.singleMu_leg2_noisoPass_value)

        #print "making singleMu_leg2_noisoPrescale"
        self.singleMu_leg2_noisoPrescale_branch = the_tree.GetBranch("singleMu_leg2_noisoPrescale")
        #if not self.singleMu_leg2_noisoPrescale_branch and "singleMu_leg2_noisoPrescale" not in self.complained:
        if not self.singleMu_leg2_noisoPrescale_branch and "singleMu_leg2_noisoPrescale":
            warnings.warn( "MuTauTree: Expected branch singleMu_leg2_noisoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoPrescale")
        else:
            self.singleMu_leg2_noisoPrescale_branch.SetAddress(<void*>&self.singleMu_leg2_noisoPrescale_value)

        #print "making tAbsEta"
        self.tAbsEta_branch = the_tree.GetBranch("tAbsEta")
        #if not self.tAbsEta_branch and "tAbsEta" not in self.complained:
        if not self.tAbsEta_branch and "tAbsEta":
            warnings.warn( "MuTauTree: Expected branch tAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAbsEta")
        else:
            self.tAbsEta_branch.SetAddress(<void*>&self.tAbsEta_value)

        #print "making tAgainstElectronLooseMVA6"
        self.tAgainstElectronLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronLooseMVA6")
        #if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6" not in self.complained:
        if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronLooseMVA6")
        else:
            self.tAgainstElectronLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronLooseMVA6_value)

        #print "making tAgainstElectronMVA6Raw"
        self.tAgainstElectronMVA6Raw_branch = the_tree.GetBranch("tAgainstElectronMVA6Raw")
        #if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw" not in self.complained:
        if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronMVA6Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6Raw")
        else:
            self.tAgainstElectronMVA6Raw_branch.SetAddress(<void*>&self.tAgainstElectronMVA6Raw_value)

        #print "making tAgainstElectronMVA6category"
        self.tAgainstElectronMVA6category_branch = the_tree.GetBranch("tAgainstElectronMVA6category")
        #if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category" not in self.complained:
        if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronMVA6category does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6category")
        else:
            self.tAgainstElectronMVA6category_branch.SetAddress(<void*>&self.tAgainstElectronMVA6category_value)

        #print "making tAgainstElectronMediumMVA6"
        self.tAgainstElectronMediumMVA6_branch = the_tree.GetBranch("tAgainstElectronMediumMVA6")
        #if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6" not in self.complained:
        if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronMediumMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMediumMVA6")
        else:
            self.tAgainstElectronMediumMVA6_branch.SetAddress(<void*>&self.tAgainstElectronMediumMVA6_value)

        #print "making tAgainstElectronTightMVA6"
        self.tAgainstElectronTightMVA6_branch = the_tree.GetBranch("tAgainstElectronTightMVA6")
        #if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6" not in self.complained:
        if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronTightMVA6")
        else:
            self.tAgainstElectronTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronTightMVA6_value)

        #print "making tAgainstElectronVLooseMVA6"
        self.tAgainstElectronVLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronVLooseMVA6")
        #if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6" not in self.complained:
        if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronVLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVLooseMVA6")
        else:
            self.tAgainstElectronVLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVLooseMVA6_value)

        #print "making tAgainstElectronVTightMVA6"
        self.tAgainstElectronVTightMVA6_branch = the_tree.GetBranch("tAgainstElectronVTightMVA6")
        #if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6" not in self.complained:
        if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronVTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVTightMVA6")
        else:
            self.tAgainstElectronVTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVTightMVA6_value)

        #print "making tAgainstMuonLoose3"
        self.tAgainstMuonLoose3_branch = the_tree.GetBranch("tAgainstMuonLoose3")
        #if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3" not in self.complained:
        if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3":
            warnings.warn( "MuTauTree: Expected branch tAgainstMuonLoose3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonLoose3")
        else:
            self.tAgainstMuonLoose3_branch.SetAddress(<void*>&self.tAgainstMuonLoose3_value)

        #print "making tAgainstMuonTight3"
        self.tAgainstMuonTight3_branch = the_tree.GetBranch("tAgainstMuonTight3")
        #if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3" not in self.complained:
        if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3":
            warnings.warn( "MuTauTree: Expected branch tAgainstMuonTight3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonTight3")
        else:
            self.tAgainstMuonTight3_branch.SetAddress(<void*>&self.tAgainstMuonTight3_value)

        #print "making tByCombinedIsolationDeltaBetaCorrRaw3Hits"
        self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch = the_tree.GetBranch("tByCombinedIsolationDeltaBetaCorrRaw3Hits")
        #if not self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch and "tByCombinedIsolationDeltaBetaCorrRaw3Hits" not in self.complained:
        if not self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch and "tByCombinedIsolationDeltaBetaCorrRaw3Hits":
            warnings.warn( "MuTauTree: Expected branch tByCombinedIsolationDeltaBetaCorrRaw3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByCombinedIsolationDeltaBetaCorrRaw3Hits")
        else:
            self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch.SetAddress(<void*>&self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_value)

        #print "making tByIsolationMVArun2v1DBdR03oldDMwLTraw"
        self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw":
            warnings.warn( "MuTauTree: Expected branch tByIsolationMVArun2v1DBdR03oldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBnewDMwLTraw"
        self.tByIsolationMVArun2v1DBnewDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBnewDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBnewDMwLTraw_branch and "tByIsolationMVArun2v1DBnewDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBnewDMwLTraw_branch and "tByIsolationMVArun2v1DBnewDMwLTraw":
            warnings.warn( "MuTauTree: Expected branch tByIsolationMVArun2v1DBnewDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBnewDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBnewDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBnewDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBoldDMwLTraw"
        self.tByIsolationMVArun2v1DBoldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBoldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw":
            warnings.warn( "MuTauTree: Expected branch tByIsolationMVArun2v1DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBoldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBoldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBoldDMwLTraw_value)

        #print "making tByIsolationMVArun2v1PWdR03oldDMwLTraw"
        self.tByIsolationMVArun2v1PWdR03oldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1PWdR03oldDMwLTraw")
        #if not self.tByIsolationMVArun2v1PWdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1PWdR03oldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1PWdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1PWdR03oldDMwLTraw":
            warnings.warn( "MuTauTree: Expected branch tByIsolationMVArun2v1PWdR03oldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1PWdR03oldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1PWdR03oldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1PWdR03oldDMwLTraw_value)

        #print "making tByIsolationMVArun2v1PWnewDMwLTraw"
        self.tByIsolationMVArun2v1PWnewDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1PWnewDMwLTraw")
        #if not self.tByIsolationMVArun2v1PWnewDMwLTraw_branch and "tByIsolationMVArun2v1PWnewDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1PWnewDMwLTraw_branch and "tByIsolationMVArun2v1PWnewDMwLTraw":
            warnings.warn( "MuTauTree: Expected branch tByIsolationMVArun2v1PWnewDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1PWnewDMwLTraw")
        else:
            self.tByIsolationMVArun2v1PWnewDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1PWnewDMwLTraw_value)

        #print "making tByIsolationMVArun2v1PWoldDMwLTraw"
        self.tByIsolationMVArun2v1PWoldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1PWoldDMwLTraw")
        #if not self.tByIsolationMVArun2v1PWoldDMwLTraw_branch and "tByIsolationMVArun2v1PWoldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1PWoldDMwLTraw_branch and "tByIsolationMVArun2v1PWoldDMwLTraw":
            warnings.warn( "MuTauTree: Expected branch tByIsolationMVArun2v1PWoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1PWoldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1PWoldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1PWoldDMwLTraw_value)

        #print "making tByLooseCombinedIsolationDeltaBetaCorr3Hits"
        self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByLooseCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch and "tByLooseCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch and "tByLooseCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "MuTauTree: Expected branch tByLooseCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBnewDMwLT"
        self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByLooseIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByLooseIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByLooseIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1PWdR03oldDMwLT"
        self.tByLooseIsolationMVArun2v1PWdR03oldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1PWdR03oldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1PWdR03oldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1PWdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByLooseIsolationMVArun2v1PWdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1PWdR03oldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1PWdR03oldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1PWdR03oldDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1PWnewDMwLT"
        self.tByLooseIsolationMVArun2v1PWnewDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1PWnewDMwLT")
        #if not self.tByLooseIsolationMVArun2v1PWnewDMwLT_branch and "tByLooseIsolationMVArun2v1PWnewDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1PWnewDMwLT_branch and "tByLooseIsolationMVArun2v1PWnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByLooseIsolationMVArun2v1PWnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1PWnewDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1PWnewDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1PWnewDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1PWoldDMwLT"
        self.tByLooseIsolationMVArun2v1PWoldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1PWoldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1PWoldDMwLT_branch and "tByLooseIsolationMVArun2v1PWoldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1PWoldDMwLT_branch and "tByLooseIsolationMVArun2v1PWoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByLooseIsolationMVArun2v1PWoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1PWoldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1PWoldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1PWoldDMwLT_value)

        #print "making tByMediumCombinedIsolationDeltaBetaCorr3Hits"
        self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByMediumCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch and "tByMediumCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch and "tByMediumCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "MuTauTree: Expected branch tByMediumCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByMediumIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByMediumIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBnewDMwLT"
        self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch and "tByMediumIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch and "tByMediumIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByMediumIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBoldDMwLT"
        self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByMediumIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1PWdR03oldDMwLT"
        self.tByMediumIsolationMVArun2v1PWdR03oldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1PWdR03oldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1PWdR03oldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1PWdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByMediumIsolationMVArun2v1PWdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1PWdR03oldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1PWdR03oldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1PWdR03oldDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1PWnewDMwLT"
        self.tByMediumIsolationMVArun2v1PWnewDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1PWnewDMwLT")
        #if not self.tByMediumIsolationMVArun2v1PWnewDMwLT_branch and "tByMediumIsolationMVArun2v1PWnewDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1PWnewDMwLT_branch and "tByMediumIsolationMVArun2v1PWnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByMediumIsolationMVArun2v1PWnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1PWnewDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1PWnewDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1PWnewDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1PWoldDMwLT"
        self.tByMediumIsolationMVArun2v1PWoldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1PWoldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1PWoldDMwLT_branch and "tByMediumIsolationMVArun2v1PWoldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1PWoldDMwLT_branch and "tByMediumIsolationMVArun2v1PWoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByMediumIsolationMVArun2v1PWoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1PWoldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1PWoldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1PWoldDMwLT_value)

        #print "making tByPhotonPtSumOutsideSignalCone"
        self.tByPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tByPhotonPtSumOutsideSignalCone")
        #if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone":
            warnings.warn( "MuTauTree: Expected branch tByPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByPhotonPtSumOutsideSignalCone")
        else:
            self.tByPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tByPhotonPtSumOutsideSignalCone_value)

        #print "making tByTightCombinedIsolationDeltaBetaCorr3Hits"
        self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByTightCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch and "tByTightCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch and "tByTightCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "MuTauTree: Expected branch tByTightCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByTightCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBnewDMwLT"
        self.tByTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBnewDMwLT_branch and "tByTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBnewDMwLT_branch and "tByTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBoldDMwLT"
        self.tByTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByTightIsolationMVArun2v1PWdR03oldDMwLT"
        self.tByTightIsolationMVArun2v1PWdR03oldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1PWdR03oldDMwLT")
        #if not self.tByTightIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1PWdR03oldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1PWdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByTightIsolationMVArun2v1PWdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1PWdR03oldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1PWdR03oldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1PWdR03oldDMwLT_value)

        #print "making tByTightIsolationMVArun2v1PWnewDMwLT"
        self.tByTightIsolationMVArun2v1PWnewDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1PWnewDMwLT")
        #if not self.tByTightIsolationMVArun2v1PWnewDMwLT_branch and "tByTightIsolationMVArun2v1PWnewDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1PWnewDMwLT_branch and "tByTightIsolationMVArun2v1PWnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByTightIsolationMVArun2v1PWnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1PWnewDMwLT")
        else:
            self.tByTightIsolationMVArun2v1PWnewDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1PWnewDMwLT_value)

        #print "making tByTightIsolationMVArun2v1PWoldDMwLT"
        self.tByTightIsolationMVArun2v1PWoldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1PWoldDMwLT")
        #if not self.tByTightIsolationMVArun2v1PWoldDMwLT_branch and "tByTightIsolationMVArun2v1PWoldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1PWoldDMwLT_branch and "tByTightIsolationMVArun2v1PWoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByTightIsolationMVArun2v1PWoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1PWoldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1PWoldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1PWoldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBnewDMwLT"
        self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByVLooseIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByVLooseIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVLooseIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1PWdR03oldDMwLT"
        self.tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1PWdR03oldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1PWdR03oldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1PWdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVLooseIsolationMVArun2v1PWdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1PWdR03oldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1PWnewDMwLT"
        self.tByVLooseIsolationMVArun2v1PWnewDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1PWnewDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1PWnewDMwLT_branch and "tByVLooseIsolationMVArun2v1PWnewDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1PWnewDMwLT_branch and "tByVLooseIsolationMVArun2v1PWnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVLooseIsolationMVArun2v1PWnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1PWnewDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1PWnewDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1PWnewDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1PWoldDMwLT"
        self.tByVLooseIsolationMVArun2v1PWoldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1PWoldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1PWoldDMwLT_branch and "tByVLooseIsolationMVArun2v1PWoldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1PWoldDMwLT_branch and "tByVLooseIsolationMVArun2v1PWoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVLooseIsolationMVArun2v1PWoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1PWoldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1PWoldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1PWoldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBnewDMwLT"
        self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1PWdR03oldDMwLT"
        self.tByVTightIsolationMVArun2v1PWdR03oldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1PWdR03oldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1PWdR03oldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1PWdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVTightIsolationMVArun2v1PWdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1PWdR03oldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1PWdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1PWdR03oldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1PWnewDMwLT"
        self.tByVTightIsolationMVArun2v1PWnewDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1PWnewDMwLT")
        #if not self.tByVTightIsolationMVArun2v1PWnewDMwLT_branch and "tByVTightIsolationMVArun2v1PWnewDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1PWnewDMwLT_branch and "tByVTightIsolationMVArun2v1PWnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVTightIsolationMVArun2v1PWnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1PWnewDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1PWnewDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1PWnewDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1PWoldDMwLT"
        self.tByVTightIsolationMVArun2v1PWoldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1PWoldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1PWoldDMwLT_branch and "tByVTightIsolationMVArun2v1PWoldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1PWoldDMwLT_branch and "tByVTightIsolationMVArun2v1PWoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVTightIsolationMVArun2v1PWoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1PWoldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1PWoldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1PWoldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBnewDMwLT"
        self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVVTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVVTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVVTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1PWdR03oldDMwLT"
        self.tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1PWdR03oldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1PWdR03oldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1PWdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVVTightIsolationMVArun2v1PWdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1PWdR03oldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1PWnewDMwLT"
        self.tByVVTightIsolationMVArun2v1PWnewDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1PWnewDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1PWnewDMwLT_branch and "tByVVTightIsolationMVArun2v1PWnewDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1PWnewDMwLT_branch and "tByVVTightIsolationMVArun2v1PWnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVVTightIsolationMVArun2v1PWnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1PWnewDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1PWnewDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1PWnewDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1PWoldDMwLT"
        self.tByVVTightIsolationMVArun2v1PWoldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1PWoldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1PWoldDMwLT_branch and "tByVVTightIsolationMVArun2v1PWoldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1PWoldDMwLT_branch and "tByVVTightIsolationMVArun2v1PWoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVVTightIsolationMVArun2v1PWoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1PWoldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1PWoldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1PWoldDMwLT_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "MuTauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tChargedIsoPtSum"
        self.tChargedIsoPtSum_branch = the_tree.GetBranch("tChargedIsoPtSum")
        #if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum" not in self.complained:
        if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum":
            warnings.warn( "MuTauTree: Expected branch tChargedIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSum")
        else:
            self.tChargedIsoPtSum_branch.SetAddress(<void*>&self.tChargedIsoPtSum_value)

        #print "making tChargedIsoPtSumdR03"
        self.tChargedIsoPtSumdR03_branch = the_tree.GetBranch("tChargedIsoPtSumdR03")
        #if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03" not in self.complained:
        if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03":
            warnings.warn( "MuTauTree: Expected branch tChargedIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSumdR03")
        else:
            self.tChargedIsoPtSumdR03_branch.SetAddress(<void*>&self.tChargedIsoPtSumdR03_value)

        #print "making tComesFromHiggs"
        self.tComesFromHiggs_branch = the_tree.GetBranch("tComesFromHiggs")
        #if not self.tComesFromHiggs_branch and "tComesFromHiggs" not in self.complained:
        if not self.tComesFromHiggs_branch and "tComesFromHiggs":
            warnings.warn( "MuTauTree: Expected branch tComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tComesFromHiggs")
        else:
            self.tComesFromHiggs_branch.SetAddress(<void*>&self.tComesFromHiggs_value)

        #print "making tDPhiToPfMet_ElectronEnDown"
        self.tDPhiToPfMet_ElectronEnDown_branch = the_tree.GetBranch("tDPhiToPfMet_ElectronEnDown")
        #if not self.tDPhiToPfMet_ElectronEnDown_branch and "tDPhiToPfMet_ElectronEnDown" not in self.complained:
        if not self.tDPhiToPfMet_ElectronEnDown_branch and "tDPhiToPfMet_ElectronEnDown":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_ElectronEnDown")
        else:
            self.tDPhiToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.tDPhiToPfMet_ElectronEnDown_value)

        #print "making tDPhiToPfMet_ElectronEnUp"
        self.tDPhiToPfMet_ElectronEnUp_branch = the_tree.GetBranch("tDPhiToPfMet_ElectronEnUp")
        #if not self.tDPhiToPfMet_ElectronEnUp_branch and "tDPhiToPfMet_ElectronEnUp" not in self.complained:
        if not self.tDPhiToPfMet_ElectronEnUp_branch and "tDPhiToPfMet_ElectronEnUp":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_ElectronEnUp")
        else:
            self.tDPhiToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.tDPhiToPfMet_ElectronEnUp_value)

        #print "making tDPhiToPfMet_JetEnDown"
        self.tDPhiToPfMet_JetEnDown_branch = the_tree.GetBranch("tDPhiToPfMet_JetEnDown")
        #if not self.tDPhiToPfMet_JetEnDown_branch and "tDPhiToPfMet_JetEnDown" not in self.complained:
        if not self.tDPhiToPfMet_JetEnDown_branch and "tDPhiToPfMet_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_JetEnDown")
        else:
            self.tDPhiToPfMet_JetEnDown_branch.SetAddress(<void*>&self.tDPhiToPfMet_JetEnDown_value)

        #print "making tDPhiToPfMet_JetEnUp"
        self.tDPhiToPfMet_JetEnUp_branch = the_tree.GetBranch("tDPhiToPfMet_JetEnUp")
        #if not self.tDPhiToPfMet_JetEnUp_branch and "tDPhiToPfMet_JetEnUp" not in self.complained:
        if not self.tDPhiToPfMet_JetEnUp_branch and "tDPhiToPfMet_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_JetEnUp")
        else:
            self.tDPhiToPfMet_JetEnUp_branch.SetAddress(<void*>&self.tDPhiToPfMet_JetEnUp_value)

        #print "making tDPhiToPfMet_JetResDown"
        self.tDPhiToPfMet_JetResDown_branch = the_tree.GetBranch("tDPhiToPfMet_JetResDown")
        #if not self.tDPhiToPfMet_JetResDown_branch and "tDPhiToPfMet_JetResDown" not in self.complained:
        if not self.tDPhiToPfMet_JetResDown_branch and "tDPhiToPfMet_JetResDown":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_JetResDown")
        else:
            self.tDPhiToPfMet_JetResDown_branch.SetAddress(<void*>&self.tDPhiToPfMet_JetResDown_value)

        #print "making tDPhiToPfMet_JetResUp"
        self.tDPhiToPfMet_JetResUp_branch = the_tree.GetBranch("tDPhiToPfMet_JetResUp")
        #if not self.tDPhiToPfMet_JetResUp_branch and "tDPhiToPfMet_JetResUp" not in self.complained:
        if not self.tDPhiToPfMet_JetResUp_branch and "tDPhiToPfMet_JetResUp":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_JetResUp")
        else:
            self.tDPhiToPfMet_JetResUp_branch.SetAddress(<void*>&self.tDPhiToPfMet_JetResUp_value)

        #print "making tDPhiToPfMet_MuonEnDown"
        self.tDPhiToPfMet_MuonEnDown_branch = the_tree.GetBranch("tDPhiToPfMet_MuonEnDown")
        #if not self.tDPhiToPfMet_MuonEnDown_branch and "tDPhiToPfMet_MuonEnDown" not in self.complained:
        if not self.tDPhiToPfMet_MuonEnDown_branch and "tDPhiToPfMet_MuonEnDown":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_MuonEnDown")
        else:
            self.tDPhiToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.tDPhiToPfMet_MuonEnDown_value)

        #print "making tDPhiToPfMet_MuonEnUp"
        self.tDPhiToPfMet_MuonEnUp_branch = the_tree.GetBranch("tDPhiToPfMet_MuonEnUp")
        #if not self.tDPhiToPfMet_MuonEnUp_branch and "tDPhiToPfMet_MuonEnUp" not in self.complained:
        if not self.tDPhiToPfMet_MuonEnUp_branch and "tDPhiToPfMet_MuonEnUp":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_MuonEnUp")
        else:
            self.tDPhiToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.tDPhiToPfMet_MuonEnUp_value)

        #print "making tDPhiToPfMet_PhotonEnDown"
        self.tDPhiToPfMet_PhotonEnDown_branch = the_tree.GetBranch("tDPhiToPfMet_PhotonEnDown")
        #if not self.tDPhiToPfMet_PhotonEnDown_branch and "tDPhiToPfMet_PhotonEnDown" not in self.complained:
        if not self.tDPhiToPfMet_PhotonEnDown_branch and "tDPhiToPfMet_PhotonEnDown":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_PhotonEnDown")
        else:
            self.tDPhiToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.tDPhiToPfMet_PhotonEnDown_value)

        #print "making tDPhiToPfMet_PhotonEnUp"
        self.tDPhiToPfMet_PhotonEnUp_branch = the_tree.GetBranch("tDPhiToPfMet_PhotonEnUp")
        #if not self.tDPhiToPfMet_PhotonEnUp_branch and "tDPhiToPfMet_PhotonEnUp" not in self.complained:
        if not self.tDPhiToPfMet_PhotonEnUp_branch and "tDPhiToPfMet_PhotonEnUp":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_PhotonEnUp")
        else:
            self.tDPhiToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.tDPhiToPfMet_PhotonEnUp_value)

        #print "making tDPhiToPfMet_TauEnDown"
        self.tDPhiToPfMet_TauEnDown_branch = the_tree.GetBranch("tDPhiToPfMet_TauEnDown")
        #if not self.tDPhiToPfMet_TauEnDown_branch and "tDPhiToPfMet_TauEnDown" not in self.complained:
        if not self.tDPhiToPfMet_TauEnDown_branch and "tDPhiToPfMet_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_TauEnDown")
        else:
            self.tDPhiToPfMet_TauEnDown_branch.SetAddress(<void*>&self.tDPhiToPfMet_TauEnDown_value)

        #print "making tDPhiToPfMet_TauEnUp"
        self.tDPhiToPfMet_TauEnUp_branch = the_tree.GetBranch("tDPhiToPfMet_TauEnUp")
        #if not self.tDPhiToPfMet_TauEnUp_branch and "tDPhiToPfMet_TauEnUp" not in self.complained:
        if not self.tDPhiToPfMet_TauEnUp_branch and "tDPhiToPfMet_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_TauEnUp")
        else:
            self.tDPhiToPfMet_TauEnUp_branch.SetAddress(<void*>&self.tDPhiToPfMet_TauEnUp_value)

        #print "making tDPhiToPfMet_UnclusteredEnDown"
        self.tDPhiToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("tDPhiToPfMet_UnclusteredEnDown")
        #if not self.tDPhiToPfMet_UnclusteredEnDown_branch and "tDPhiToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.tDPhiToPfMet_UnclusteredEnDown_branch and "tDPhiToPfMet_UnclusteredEnDown":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_UnclusteredEnDown")
        else:
            self.tDPhiToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.tDPhiToPfMet_UnclusteredEnDown_value)

        #print "making tDPhiToPfMet_UnclusteredEnUp"
        self.tDPhiToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("tDPhiToPfMet_UnclusteredEnUp")
        #if not self.tDPhiToPfMet_UnclusteredEnUp_branch and "tDPhiToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.tDPhiToPfMet_UnclusteredEnUp_branch and "tDPhiToPfMet_UnclusteredEnUp":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_UnclusteredEnUp")
        else:
            self.tDPhiToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.tDPhiToPfMet_UnclusteredEnUp_value)

        #print "making tDPhiToPfMet_type1"
        self.tDPhiToPfMet_type1_branch = the_tree.GetBranch("tDPhiToPfMet_type1")
        #if not self.tDPhiToPfMet_type1_branch and "tDPhiToPfMet_type1" not in self.complained:
        if not self.tDPhiToPfMet_type1_branch and "tDPhiToPfMet_type1":
            warnings.warn( "MuTauTree: Expected branch tDPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_type1")
        else:
            self.tDPhiToPfMet_type1_branch.SetAddress(<void*>&self.tDPhiToPfMet_type1_value)

        #print "making tDecayMode"
        self.tDecayMode_branch = the_tree.GetBranch("tDecayMode")
        #if not self.tDecayMode_branch and "tDecayMode" not in self.complained:
        if not self.tDecayMode_branch and "tDecayMode":
            warnings.warn( "MuTauTree: Expected branch tDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayMode")
        else:
            self.tDecayMode_branch.SetAddress(<void*>&self.tDecayMode_value)

        #print "making tDecayModeFinding"
        self.tDecayModeFinding_branch = the_tree.GetBranch("tDecayModeFinding")
        #if not self.tDecayModeFinding_branch and "tDecayModeFinding" not in self.complained:
        if not self.tDecayModeFinding_branch and "tDecayModeFinding":
            warnings.warn( "MuTauTree: Expected branch tDecayModeFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFinding")
        else:
            self.tDecayModeFinding_branch.SetAddress(<void*>&self.tDecayModeFinding_value)

        #print "making tDecayModeFindingNewDMs"
        self.tDecayModeFindingNewDMs_branch = the_tree.GetBranch("tDecayModeFindingNewDMs")
        #if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs" not in self.complained:
        if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs":
            warnings.warn( "MuTauTree: Expected branch tDecayModeFindingNewDMs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFindingNewDMs")
        else:
            self.tDecayModeFindingNewDMs_branch.SetAddress(<void*>&self.tDecayModeFindingNewDMs_value)

        #print "making tElecOverlap"
        self.tElecOverlap_branch = the_tree.GetBranch("tElecOverlap")
        #if not self.tElecOverlap_branch and "tElecOverlap" not in self.complained:
        if not self.tElecOverlap_branch and "tElecOverlap":
            warnings.warn( "MuTauTree: Expected branch tElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElecOverlap")
        else:
            self.tElecOverlap_branch.SetAddress(<void*>&self.tElecOverlap_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "MuTauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tEta_TauEnDown"
        self.tEta_TauEnDown_branch = the_tree.GetBranch("tEta_TauEnDown")
        #if not self.tEta_TauEnDown_branch and "tEta_TauEnDown" not in self.complained:
        if not self.tEta_TauEnDown_branch and "tEta_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch tEta_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta_TauEnDown")
        else:
            self.tEta_TauEnDown_branch.SetAddress(<void*>&self.tEta_TauEnDown_value)

        #print "making tEta_TauEnUp"
        self.tEta_TauEnUp_branch = the_tree.GetBranch("tEta_TauEnUp")
        #if not self.tEta_TauEnUp_branch and "tEta_TauEnUp" not in self.complained:
        if not self.tEta_TauEnUp_branch and "tEta_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch tEta_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta_TauEnUp")
        else:
            self.tEta_TauEnUp_branch.SetAddress(<void*>&self.tEta_TauEnUp_value)

        #print "making tFootprintCorrection"
        self.tFootprintCorrection_branch = the_tree.GetBranch("tFootprintCorrection")
        #if not self.tFootprintCorrection_branch and "tFootprintCorrection" not in self.complained:
        if not self.tFootprintCorrection_branch and "tFootprintCorrection":
            warnings.warn( "MuTauTree: Expected branch tFootprintCorrection does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrection")
        else:
            self.tFootprintCorrection_branch.SetAddress(<void*>&self.tFootprintCorrection_value)

        #print "making tFootprintCorrectiondR03"
        self.tFootprintCorrectiondR03_branch = the_tree.GetBranch("tFootprintCorrectiondR03")
        #if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03" not in self.complained:
        if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03":
            warnings.warn( "MuTauTree: Expected branch tFootprintCorrectiondR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrectiondR03")
        else:
            self.tFootprintCorrectiondR03_branch.SetAddress(<void*>&self.tFootprintCorrectiondR03_value)

        #print "making tGenCharge"
        self.tGenCharge_branch = the_tree.GetBranch("tGenCharge")
        #if not self.tGenCharge_branch and "tGenCharge" not in self.complained:
        if not self.tGenCharge_branch and "tGenCharge":
            warnings.warn( "MuTauTree: Expected branch tGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenCharge")
        else:
            self.tGenCharge_branch.SetAddress(<void*>&self.tGenCharge_value)

        #print "making tGenDecayMode"
        self.tGenDecayMode_branch = the_tree.GetBranch("tGenDecayMode")
        #if not self.tGenDecayMode_branch and "tGenDecayMode" not in self.complained:
        if not self.tGenDecayMode_branch and "tGenDecayMode":
            warnings.warn( "MuTauTree: Expected branch tGenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenDecayMode")
        else:
            self.tGenDecayMode_branch.SetAddress(<void*>&self.tGenDecayMode_value)

        #print "making tGenEnergy"
        self.tGenEnergy_branch = the_tree.GetBranch("tGenEnergy")
        #if not self.tGenEnergy_branch and "tGenEnergy" not in self.complained:
        if not self.tGenEnergy_branch and "tGenEnergy":
            warnings.warn( "MuTauTree: Expected branch tGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEnergy")
        else:
            self.tGenEnergy_branch.SetAddress(<void*>&self.tGenEnergy_value)

        #print "making tGenEta"
        self.tGenEta_branch = the_tree.GetBranch("tGenEta")
        #if not self.tGenEta_branch and "tGenEta" not in self.complained:
        if not self.tGenEta_branch and "tGenEta":
            warnings.warn( "MuTauTree: Expected branch tGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEta")
        else:
            self.tGenEta_branch.SetAddress(<void*>&self.tGenEta_value)

        #print "making tGenJetEta"
        self.tGenJetEta_branch = the_tree.GetBranch("tGenJetEta")
        #if not self.tGenJetEta_branch and "tGenJetEta" not in self.complained:
        if not self.tGenJetEta_branch and "tGenJetEta":
            warnings.warn( "MuTauTree: Expected branch tGenJetEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetEta")
        else:
            self.tGenJetEta_branch.SetAddress(<void*>&self.tGenJetEta_value)

        #print "making tGenJetPt"
        self.tGenJetPt_branch = the_tree.GetBranch("tGenJetPt")
        #if not self.tGenJetPt_branch and "tGenJetPt" not in self.complained:
        if not self.tGenJetPt_branch and "tGenJetPt":
            warnings.warn( "MuTauTree: Expected branch tGenJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetPt")
        else:
            self.tGenJetPt_branch.SetAddress(<void*>&self.tGenJetPt_value)

        #print "making tGenMotherEnergy"
        self.tGenMotherEnergy_branch = the_tree.GetBranch("tGenMotherEnergy")
        #if not self.tGenMotherEnergy_branch and "tGenMotherEnergy" not in self.complained:
        if not self.tGenMotherEnergy_branch and "tGenMotherEnergy":
            warnings.warn( "MuTauTree: Expected branch tGenMotherEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEnergy")
        else:
            self.tGenMotherEnergy_branch.SetAddress(<void*>&self.tGenMotherEnergy_value)

        #print "making tGenMotherEta"
        self.tGenMotherEta_branch = the_tree.GetBranch("tGenMotherEta")
        #if not self.tGenMotherEta_branch and "tGenMotherEta" not in self.complained:
        if not self.tGenMotherEta_branch and "tGenMotherEta":
            warnings.warn( "MuTauTree: Expected branch tGenMotherEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEta")
        else:
            self.tGenMotherEta_branch.SetAddress(<void*>&self.tGenMotherEta_value)

        #print "making tGenMotherPdgId"
        self.tGenMotherPdgId_branch = the_tree.GetBranch("tGenMotherPdgId")
        #if not self.tGenMotherPdgId_branch and "tGenMotherPdgId" not in self.complained:
        if not self.tGenMotherPdgId_branch and "tGenMotherPdgId":
            warnings.warn( "MuTauTree: Expected branch tGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPdgId")
        else:
            self.tGenMotherPdgId_branch.SetAddress(<void*>&self.tGenMotherPdgId_value)

        #print "making tGenMotherPhi"
        self.tGenMotherPhi_branch = the_tree.GetBranch("tGenMotherPhi")
        #if not self.tGenMotherPhi_branch and "tGenMotherPhi" not in self.complained:
        if not self.tGenMotherPhi_branch and "tGenMotherPhi":
            warnings.warn( "MuTauTree: Expected branch tGenMotherPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPhi")
        else:
            self.tGenMotherPhi_branch.SetAddress(<void*>&self.tGenMotherPhi_value)

        #print "making tGenMotherPt"
        self.tGenMotherPt_branch = the_tree.GetBranch("tGenMotherPt")
        #if not self.tGenMotherPt_branch and "tGenMotherPt" not in self.complained:
        if not self.tGenMotherPt_branch and "tGenMotherPt":
            warnings.warn( "MuTauTree: Expected branch tGenMotherPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPt")
        else:
            self.tGenMotherPt_branch.SetAddress(<void*>&self.tGenMotherPt_value)

        #print "making tGenPdgId"
        self.tGenPdgId_branch = the_tree.GetBranch("tGenPdgId")
        #if not self.tGenPdgId_branch and "tGenPdgId" not in self.complained:
        if not self.tGenPdgId_branch and "tGenPdgId":
            warnings.warn( "MuTauTree: Expected branch tGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPdgId")
        else:
            self.tGenPdgId_branch.SetAddress(<void*>&self.tGenPdgId_value)

        #print "making tGenPhi"
        self.tGenPhi_branch = the_tree.GetBranch("tGenPhi")
        #if not self.tGenPhi_branch and "tGenPhi" not in self.complained:
        if not self.tGenPhi_branch and "tGenPhi":
            warnings.warn( "MuTauTree: Expected branch tGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPhi")
        else:
            self.tGenPhi_branch.SetAddress(<void*>&self.tGenPhi_value)

        #print "making tGenPt"
        self.tGenPt_branch = the_tree.GetBranch("tGenPt")
        #if not self.tGenPt_branch and "tGenPt" not in self.complained:
        if not self.tGenPt_branch and "tGenPt":
            warnings.warn( "MuTauTree: Expected branch tGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPt")
        else:
            self.tGenPt_branch.SetAddress(<void*>&self.tGenPt_value)

        #print "making tGenStatus"
        self.tGenStatus_branch = the_tree.GetBranch("tGenStatus")
        #if not self.tGenStatus_branch and "tGenStatus" not in self.complained:
        if not self.tGenStatus_branch and "tGenStatus":
            warnings.warn( "MuTauTree: Expected branch tGenStatus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenStatus")
        else:
            self.tGenStatus_branch.SetAddress(<void*>&self.tGenStatus_value)

        #print "making tGlobalMuonVtxOverlap"
        self.tGlobalMuonVtxOverlap_branch = the_tree.GetBranch("tGlobalMuonVtxOverlap")
        #if not self.tGlobalMuonVtxOverlap_branch and "tGlobalMuonVtxOverlap" not in self.complained:
        if not self.tGlobalMuonVtxOverlap_branch and "tGlobalMuonVtxOverlap":
            warnings.warn( "MuTauTree: Expected branch tGlobalMuonVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGlobalMuonVtxOverlap")
        else:
            self.tGlobalMuonVtxOverlap_branch.SetAddress(<void*>&self.tGlobalMuonVtxOverlap_value)

        #print "making tJetArea"
        self.tJetArea_branch = the_tree.GetBranch("tJetArea")
        #if not self.tJetArea_branch and "tJetArea" not in self.complained:
        if not self.tJetArea_branch and "tJetArea":
            warnings.warn( "MuTauTree: Expected branch tJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetArea")
        else:
            self.tJetArea_branch.SetAddress(<void*>&self.tJetArea_value)

        #print "making tJetBtag"
        self.tJetBtag_branch = the_tree.GetBranch("tJetBtag")
        #if not self.tJetBtag_branch and "tJetBtag" not in self.complained:
        if not self.tJetBtag_branch and "tJetBtag":
            warnings.warn( "MuTauTree: Expected branch tJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetBtag")
        else:
            self.tJetBtag_branch.SetAddress(<void*>&self.tJetBtag_value)

        #print "making tJetEtaEtaMoment"
        self.tJetEtaEtaMoment_branch = the_tree.GetBranch("tJetEtaEtaMoment")
        #if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment" not in self.complained:
        if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment":
            warnings.warn( "MuTauTree: Expected branch tJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaEtaMoment")
        else:
            self.tJetEtaEtaMoment_branch.SetAddress(<void*>&self.tJetEtaEtaMoment_value)

        #print "making tJetEtaPhiMoment"
        self.tJetEtaPhiMoment_branch = the_tree.GetBranch("tJetEtaPhiMoment")
        #if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment" not in self.complained:
        if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment":
            warnings.warn( "MuTauTree: Expected branch tJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiMoment")
        else:
            self.tJetEtaPhiMoment_branch.SetAddress(<void*>&self.tJetEtaPhiMoment_value)

        #print "making tJetEtaPhiSpread"
        self.tJetEtaPhiSpread_branch = the_tree.GetBranch("tJetEtaPhiSpread")
        #if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread" not in self.complained:
        if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread":
            warnings.warn( "MuTauTree: Expected branch tJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiSpread")
        else:
            self.tJetEtaPhiSpread_branch.SetAddress(<void*>&self.tJetEtaPhiSpread_value)

        #print "making tJetPFCISVBtag"
        self.tJetPFCISVBtag_branch = the_tree.GetBranch("tJetPFCISVBtag")
        #if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag" not in self.complained:
        if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag":
            warnings.warn( "MuTauTree: Expected branch tJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPFCISVBtag")
        else:
            self.tJetPFCISVBtag_branch.SetAddress(<void*>&self.tJetPFCISVBtag_value)

        #print "making tJetPartonFlavour"
        self.tJetPartonFlavour_branch = the_tree.GetBranch("tJetPartonFlavour")
        #if not self.tJetPartonFlavour_branch and "tJetPartonFlavour" not in self.complained:
        if not self.tJetPartonFlavour_branch and "tJetPartonFlavour":
            warnings.warn( "MuTauTree: Expected branch tJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPartonFlavour")
        else:
            self.tJetPartonFlavour_branch.SetAddress(<void*>&self.tJetPartonFlavour_value)

        #print "making tJetPhiPhiMoment"
        self.tJetPhiPhiMoment_branch = the_tree.GetBranch("tJetPhiPhiMoment")
        #if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment" not in self.complained:
        if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment":
            warnings.warn( "MuTauTree: Expected branch tJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPhiPhiMoment")
        else:
            self.tJetPhiPhiMoment_branch.SetAddress(<void*>&self.tJetPhiPhiMoment_value)

        #print "making tJetPt"
        self.tJetPt_branch = the_tree.GetBranch("tJetPt")
        #if not self.tJetPt_branch and "tJetPt" not in self.complained:
        if not self.tJetPt_branch and "tJetPt":
            warnings.warn( "MuTauTree: Expected branch tJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPt")
        else:
            self.tJetPt_branch.SetAddress(<void*>&self.tJetPt_value)

        #print "making tLeadTrackPt"
        self.tLeadTrackPt_branch = the_tree.GetBranch("tLeadTrackPt")
        #if not self.tLeadTrackPt_branch and "tLeadTrackPt" not in self.complained:
        if not self.tLeadTrackPt_branch and "tLeadTrackPt":
            warnings.warn( "MuTauTree: Expected branch tLeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLeadTrackPt")
        else:
            self.tLeadTrackPt_branch.SetAddress(<void*>&self.tLeadTrackPt_value)

        #print "making tLowestMll"
        self.tLowestMll_branch = the_tree.GetBranch("tLowestMll")
        #if not self.tLowestMll_branch and "tLowestMll" not in self.complained:
        if not self.tLowestMll_branch and "tLowestMll":
            warnings.warn( "MuTauTree: Expected branch tLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLowestMll")
        else:
            self.tLowestMll_branch.SetAddress(<void*>&self.tLowestMll_value)

        #print "making tMass"
        self.tMass_branch = the_tree.GetBranch("tMass")
        #if not self.tMass_branch and "tMass" not in self.complained:
        if not self.tMass_branch and "tMass":
            warnings.warn( "MuTauTree: Expected branch tMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass")
        else:
            self.tMass_branch.SetAddress(<void*>&self.tMass_value)

        #print "making tMass_TauEnDown"
        self.tMass_TauEnDown_branch = the_tree.GetBranch("tMass_TauEnDown")
        #if not self.tMass_TauEnDown_branch and "tMass_TauEnDown" not in self.complained:
        if not self.tMass_TauEnDown_branch and "tMass_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch tMass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass_TauEnDown")
        else:
            self.tMass_TauEnDown_branch.SetAddress(<void*>&self.tMass_TauEnDown_value)

        #print "making tMass_TauEnUp"
        self.tMass_TauEnUp_branch = the_tree.GetBranch("tMass_TauEnUp")
        #if not self.tMass_TauEnUp_branch and "tMass_TauEnUp" not in self.complained:
        if not self.tMass_TauEnUp_branch and "tMass_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch tMass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass_TauEnUp")
        else:
            self.tMass_TauEnUp_branch.SetAddress(<void*>&self.tMass_TauEnUp_value)

        #print "making tMtToPfMet_ElectronEnDown"
        self.tMtToPfMet_ElectronEnDown_branch = the_tree.GetBranch("tMtToPfMet_ElectronEnDown")
        #if not self.tMtToPfMet_ElectronEnDown_branch and "tMtToPfMet_ElectronEnDown" not in self.complained:
        if not self.tMtToPfMet_ElectronEnDown_branch and "tMtToPfMet_ElectronEnDown":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ElectronEnDown")
        else:
            self.tMtToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.tMtToPfMet_ElectronEnDown_value)

        #print "making tMtToPfMet_ElectronEnUp"
        self.tMtToPfMet_ElectronEnUp_branch = the_tree.GetBranch("tMtToPfMet_ElectronEnUp")
        #if not self.tMtToPfMet_ElectronEnUp_branch and "tMtToPfMet_ElectronEnUp" not in self.complained:
        if not self.tMtToPfMet_ElectronEnUp_branch and "tMtToPfMet_ElectronEnUp":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ElectronEnUp")
        else:
            self.tMtToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.tMtToPfMet_ElectronEnUp_value)

        #print "making tMtToPfMet_JetEnDown"
        self.tMtToPfMet_JetEnDown_branch = the_tree.GetBranch("tMtToPfMet_JetEnDown")
        #if not self.tMtToPfMet_JetEnDown_branch and "tMtToPfMet_JetEnDown" not in self.complained:
        if not self.tMtToPfMet_JetEnDown_branch and "tMtToPfMet_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_JetEnDown")
        else:
            self.tMtToPfMet_JetEnDown_branch.SetAddress(<void*>&self.tMtToPfMet_JetEnDown_value)

        #print "making tMtToPfMet_JetEnUp"
        self.tMtToPfMet_JetEnUp_branch = the_tree.GetBranch("tMtToPfMet_JetEnUp")
        #if not self.tMtToPfMet_JetEnUp_branch and "tMtToPfMet_JetEnUp" not in self.complained:
        if not self.tMtToPfMet_JetEnUp_branch and "tMtToPfMet_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_JetEnUp")
        else:
            self.tMtToPfMet_JetEnUp_branch.SetAddress(<void*>&self.tMtToPfMet_JetEnUp_value)

        #print "making tMtToPfMet_JetResDown"
        self.tMtToPfMet_JetResDown_branch = the_tree.GetBranch("tMtToPfMet_JetResDown")
        #if not self.tMtToPfMet_JetResDown_branch and "tMtToPfMet_JetResDown" not in self.complained:
        if not self.tMtToPfMet_JetResDown_branch and "tMtToPfMet_JetResDown":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_JetResDown")
        else:
            self.tMtToPfMet_JetResDown_branch.SetAddress(<void*>&self.tMtToPfMet_JetResDown_value)

        #print "making tMtToPfMet_JetResUp"
        self.tMtToPfMet_JetResUp_branch = the_tree.GetBranch("tMtToPfMet_JetResUp")
        #if not self.tMtToPfMet_JetResUp_branch and "tMtToPfMet_JetResUp" not in self.complained:
        if not self.tMtToPfMet_JetResUp_branch and "tMtToPfMet_JetResUp":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_JetResUp")
        else:
            self.tMtToPfMet_JetResUp_branch.SetAddress(<void*>&self.tMtToPfMet_JetResUp_value)

        #print "making tMtToPfMet_MuonEnDown"
        self.tMtToPfMet_MuonEnDown_branch = the_tree.GetBranch("tMtToPfMet_MuonEnDown")
        #if not self.tMtToPfMet_MuonEnDown_branch and "tMtToPfMet_MuonEnDown" not in self.complained:
        if not self.tMtToPfMet_MuonEnDown_branch and "tMtToPfMet_MuonEnDown":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_MuonEnDown")
        else:
            self.tMtToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.tMtToPfMet_MuonEnDown_value)

        #print "making tMtToPfMet_MuonEnUp"
        self.tMtToPfMet_MuonEnUp_branch = the_tree.GetBranch("tMtToPfMet_MuonEnUp")
        #if not self.tMtToPfMet_MuonEnUp_branch and "tMtToPfMet_MuonEnUp" not in self.complained:
        if not self.tMtToPfMet_MuonEnUp_branch and "tMtToPfMet_MuonEnUp":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_MuonEnUp")
        else:
            self.tMtToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.tMtToPfMet_MuonEnUp_value)

        #print "making tMtToPfMet_PhotonEnDown"
        self.tMtToPfMet_PhotonEnDown_branch = the_tree.GetBranch("tMtToPfMet_PhotonEnDown")
        #if not self.tMtToPfMet_PhotonEnDown_branch and "tMtToPfMet_PhotonEnDown" not in self.complained:
        if not self.tMtToPfMet_PhotonEnDown_branch and "tMtToPfMet_PhotonEnDown":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_PhotonEnDown")
        else:
            self.tMtToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.tMtToPfMet_PhotonEnDown_value)

        #print "making tMtToPfMet_PhotonEnUp"
        self.tMtToPfMet_PhotonEnUp_branch = the_tree.GetBranch("tMtToPfMet_PhotonEnUp")
        #if not self.tMtToPfMet_PhotonEnUp_branch and "tMtToPfMet_PhotonEnUp" not in self.complained:
        if not self.tMtToPfMet_PhotonEnUp_branch and "tMtToPfMet_PhotonEnUp":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_PhotonEnUp")
        else:
            self.tMtToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.tMtToPfMet_PhotonEnUp_value)

        #print "making tMtToPfMet_Raw"
        self.tMtToPfMet_Raw_branch = the_tree.GetBranch("tMtToPfMet_Raw")
        #if not self.tMtToPfMet_Raw_branch and "tMtToPfMet_Raw" not in self.complained:
        if not self.tMtToPfMet_Raw_branch and "tMtToPfMet_Raw":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_Raw")
        else:
            self.tMtToPfMet_Raw_branch.SetAddress(<void*>&self.tMtToPfMet_Raw_value)

        #print "making tMtToPfMet_TauEnDown"
        self.tMtToPfMet_TauEnDown_branch = the_tree.GetBranch("tMtToPfMet_TauEnDown")
        #if not self.tMtToPfMet_TauEnDown_branch and "tMtToPfMet_TauEnDown" not in self.complained:
        if not self.tMtToPfMet_TauEnDown_branch and "tMtToPfMet_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_TauEnDown")
        else:
            self.tMtToPfMet_TauEnDown_branch.SetAddress(<void*>&self.tMtToPfMet_TauEnDown_value)

        #print "making tMtToPfMet_TauEnUp"
        self.tMtToPfMet_TauEnUp_branch = the_tree.GetBranch("tMtToPfMet_TauEnUp")
        #if not self.tMtToPfMet_TauEnUp_branch and "tMtToPfMet_TauEnUp" not in self.complained:
        if not self.tMtToPfMet_TauEnUp_branch and "tMtToPfMet_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_TauEnUp")
        else:
            self.tMtToPfMet_TauEnUp_branch.SetAddress(<void*>&self.tMtToPfMet_TauEnUp_value)

        #print "making tMtToPfMet_UnclusteredEnDown"
        self.tMtToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("tMtToPfMet_UnclusteredEnDown")
        #if not self.tMtToPfMet_UnclusteredEnDown_branch and "tMtToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.tMtToPfMet_UnclusteredEnDown_branch and "tMtToPfMet_UnclusteredEnDown":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_UnclusteredEnDown")
        else:
            self.tMtToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.tMtToPfMet_UnclusteredEnDown_value)

        #print "making tMtToPfMet_UnclusteredEnUp"
        self.tMtToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("tMtToPfMet_UnclusteredEnUp")
        #if not self.tMtToPfMet_UnclusteredEnUp_branch and "tMtToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.tMtToPfMet_UnclusteredEnUp_branch and "tMtToPfMet_UnclusteredEnUp":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_UnclusteredEnUp")
        else:
            self.tMtToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.tMtToPfMet_UnclusteredEnUp_value)

        #print "making tMtToPfMet_type1"
        self.tMtToPfMet_type1_branch = the_tree.GetBranch("tMtToPfMet_type1")
        #if not self.tMtToPfMet_type1_branch and "tMtToPfMet_type1" not in self.complained:
        if not self.tMtToPfMet_type1_branch and "tMtToPfMet_type1":
            warnings.warn( "MuTauTree: Expected branch tMtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_type1")
        else:
            self.tMtToPfMet_type1_branch.SetAddress(<void*>&self.tMtToPfMet_type1_value)

        #print "making tMuOverlap"
        self.tMuOverlap_branch = the_tree.GetBranch("tMuOverlap")
        #if not self.tMuOverlap_branch and "tMuOverlap" not in self.complained:
        if not self.tMuOverlap_branch and "tMuOverlap":
            warnings.warn( "MuTauTree: Expected branch tMuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuOverlap")
        else:
            self.tMuOverlap_branch.SetAddress(<void*>&self.tMuOverlap_value)

        #print "making tMuonIdIsoStdVtxOverlap"
        self.tMuonIdIsoStdVtxOverlap_branch = the_tree.GetBranch("tMuonIdIsoStdVtxOverlap")
        #if not self.tMuonIdIsoStdVtxOverlap_branch and "tMuonIdIsoStdVtxOverlap" not in self.complained:
        if not self.tMuonIdIsoStdVtxOverlap_branch and "tMuonIdIsoStdVtxOverlap":
            warnings.warn( "MuTauTree: Expected branch tMuonIdIsoStdVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuonIdIsoStdVtxOverlap")
        else:
            self.tMuonIdIsoStdVtxOverlap_branch.SetAddress(<void*>&self.tMuonIdIsoStdVtxOverlap_value)

        #print "making tMuonIdIsoVtxOverlap"
        self.tMuonIdIsoVtxOverlap_branch = the_tree.GetBranch("tMuonIdIsoVtxOverlap")
        #if not self.tMuonIdIsoVtxOverlap_branch and "tMuonIdIsoVtxOverlap" not in self.complained:
        if not self.tMuonIdIsoVtxOverlap_branch and "tMuonIdIsoVtxOverlap":
            warnings.warn( "MuTauTree: Expected branch tMuonIdIsoVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuonIdIsoVtxOverlap")
        else:
            self.tMuonIdIsoVtxOverlap_branch.SetAddress(<void*>&self.tMuonIdIsoVtxOverlap_value)

        #print "making tMuonIdVtxOverlap"
        self.tMuonIdVtxOverlap_branch = the_tree.GetBranch("tMuonIdVtxOverlap")
        #if not self.tMuonIdVtxOverlap_branch and "tMuonIdVtxOverlap" not in self.complained:
        if not self.tMuonIdVtxOverlap_branch and "tMuonIdVtxOverlap":
            warnings.warn( "MuTauTree: Expected branch tMuonIdVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuonIdVtxOverlap")
        else:
            self.tMuonIdVtxOverlap_branch.SetAddress(<void*>&self.tMuonIdVtxOverlap_value)

        #print "making tNChrgHadrSignalCands"
        self.tNChrgHadrSignalCands_branch = the_tree.GetBranch("tNChrgHadrSignalCands")
        #if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands" not in self.complained:
        if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands":
            warnings.warn( "MuTauTree: Expected branch tNChrgHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrSignalCands")
        else:
            self.tNChrgHadrSignalCands_branch.SetAddress(<void*>&self.tNChrgHadrSignalCands_value)

        #print "making tNGammaSignalCands"
        self.tNGammaSignalCands_branch = the_tree.GetBranch("tNGammaSignalCands")
        #if not self.tNGammaSignalCands_branch and "tNGammaSignalCands" not in self.complained:
        if not self.tNGammaSignalCands_branch and "tNGammaSignalCands":
            warnings.warn( "MuTauTree: Expected branch tNGammaSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNGammaSignalCands")
        else:
            self.tNGammaSignalCands_branch.SetAddress(<void*>&self.tNGammaSignalCands_value)

        #print "making tNNeutralHadrSignalCands"
        self.tNNeutralHadrSignalCands_branch = the_tree.GetBranch("tNNeutralHadrSignalCands")
        #if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands" not in self.complained:
        if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands":
            warnings.warn( "MuTauTree: Expected branch tNNeutralHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNNeutralHadrSignalCands")
        else:
            self.tNNeutralHadrSignalCands_branch.SetAddress(<void*>&self.tNNeutralHadrSignalCands_value)

        #print "making tNSignalCands"
        self.tNSignalCands_branch = the_tree.GetBranch("tNSignalCands")
        #if not self.tNSignalCands_branch and "tNSignalCands" not in self.complained:
        if not self.tNSignalCands_branch and "tNSignalCands":
            warnings.warn( "MuTauTree: Expected branch tNSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNSignalCands")
        else:
            self.tNSignalCands_branch.SetAddress(<void*>&self.tNSignalCands_value)

        #print "making tNearestZMass"
        self.tNearestZMass_branch = the_tree.GetBranch("tNearestZMass")
        #if not self.tNearestZMass_branch and "tNearestZMass" not in self.complained:
        if not self.tNearestZMass_branch and "tNearestZMass":
            warnings.warn( "MuTauTree: Expected branch tNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNearestZMass")
        else:
            self.tNearestZMass_branch.SetAddress(<void*>&self.tNearestZMass_value)

        #print "making tNeutralIsoPtSum"
        self.tNeutralIsoPtSum_branch = the_tree.GetBranch("tNeutralIsoPtSum")
        #if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum" not in self.complained:
        if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum":
            warnings.warn( "MuTauTree: Expected branch tNeutralIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSum")
        else:
            self.tNeutralIsoPtSum_branch.SetAddress(<void*>&self.tNeutralIsoPtSum_value)

        #print "making tNeutralIsoPtSumWeight"
        self.tNeutralIsoPtSumWeight_branch = the_tree.GetBranch("tNeutralIsoPtSumWeight")
        #if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight" not in self.complained:
        if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight":
            warnings.warn( "MuTauTree: Expected branch tNeutralIsoPtSumWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeight")
        else:
            self.tNeutralIsoPtSumWeight_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeight_value)

        #print "making tNeutralIsoPtSumWeightdR03"
        self.tNeutralIsoPtSumWeightdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumWeightdR03")
        #if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03" not in self.complained:
        if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03":
            warnings.warn( "MuTauTree: Expected branch tNeutralIsoPtSumWeightdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeightdR03")
        else:
            self.tNeutralIsoPtSumWeightdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeightdR03_value)

        #print "making tNeutralIsoPtSumdR03"
        self.tNeutralIsoPtSumdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumdR03")
        #if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03" not in self.complained:
        if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03":
            warnings.warn( "MuTauTree: Expected branch tNeutralIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumdR03")
        else:
            self.tNeutralIsoPtSumdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumdR03_value)

        #print "making tPVDXY"
        self.tPVDXY_branch = the_tree.GetBranch("tPVDXY")
        #if not self.tPVDXY_branch and "tPVDXY" not in self.complained:
        if not self.tPVDXY_branch and "tPVDXY":
            warnings.warn( "MuTauTree: Expected branch tPVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDXY")
        else:
            self.tPVDXY_branch.SetAddress(<void*>&self.tPVDXY_value)

        #print "making tPVDZ"
        self.tPVDZ_branch = the_tree.GetBranch("tPVDZ")
        #if not self.tPVDZ_branch and "tPVDZ" not in self.complained:
        if not self.tPVDZ_branch and "tPVDZ":
            warnings.warn( "MuTauTree: Expected branch tPVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDZ")
        else:
            self.tPVDZ_branch.SetAddress(<void*>&self.tPVDZ_value)

        #print "making tPhi"
        self.tPhi_branch = the_tree.GetBranch("tPhi")
        #if not self.tPhi_branch and "tPhi" not in self.complained:
        if not self.tPhi_branch and "tPhi":
            warnings.warn( "MuTauTree: Expected branch tPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi")
        else:
            self.tPhi_branch.SetAddress(<void*>&self.tPhi_value)

        #print "making tPhi_TauEnDown"
        self.tPhi_TauEnDown_branch = the_tree.GetBranch("tPhi_TauEnDown")
        #if not self.tPhi_TauEnDown_branch and "tPhi_TauEnDown" not in self.complained:
        if not self.tPhi_TauEnDown_branch and "tPhi_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch tPhi_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi_TauEnDown")
        else:
            self.tPhi_TauEnDown_branch.SetAddress(<void*>&self.tPhi_TauEnDown_value)

        #print "making tPhi_TauEnUp"
        self.tPhi_TauEnUp_branch = the_tree.GetBranch("tPhi_TauEnUp")
        #if not self.tPhi_TauEnUp_branch and "tPhi_TauEnUp" not in self.complained:
        if not self.tPhi_TauEnUp_branch and "tPhi_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch tPhi_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi_TauEnUp")
        else:
            self.tPhi_TauEnUp_branch.SetAddress(<void*>&self.tPhi_TauEnUp_value)

        #print "making tPhotonPtSumOutsideSignalCone"
        self.tPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalCone")
        #if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone":
            warnings.warn( "MuTauTree: Expected branch tPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalCone")
        else:
            self.tPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalCone_value)

        #print "making tPhotonPtSumOutsideSignalConedR03"
        self.tPhotonPtSumOutsideSignalConedR03_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalConedR03")
        #if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03":
            warnings.warn( "MuTauTree: Expected branch tPhotonPtSumOutsideSignalConedR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalConedR03")
        else:
            self.tPhotonPtSumOutsideSignalConedR03_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalConedR03_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "MuTauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tPt_TauEnDown"
        self.tPt_TauEnDown_branch = the_tree.GetBranch("tPt_TauEnDown")
        #if not self.tPt_TauEnDown_branch and "tPt_TauEnDown" not in self.complained:
        if not self.tPt_TauEnDown_branch and "tPt_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch tPt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt_TauEnDown")
        else:
            self.tPt_TauEnDown_branch.SetAddress(<void*>&self.tPt_TauEnDown_value)

        #print "making tPt_TauEnUp"
        self.tPt_TauEnUp_branch = the_tree.GetBranch("tPt_TauEnUp")
        #if not self.tPt_TauEnUp_branch and "tPt_TauEnUp" not in self.complained:
        if not self.tPt_TauEnUp_branch and "tPt_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch tPt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt_TauEnUp")
        else:
            self.tPt_TauEnUp_branch.SetAddress(<void*>&self.tPt_TauEnUp_value)

        #print "making tPuCorrPtSum"
        self.tPuCorrPtSum_branch = the_tree.GetBranch("tPuCorrPtSum")
        #if not self.tPuCorrPtSum_branch and "tPuCorrPtSum" not in self.complained:
        if not self.tPuCorrPtSum_branch and "tPuCorrPtSum":
            warnings.warn( "MuTauTree: Expected branch tPuCorrPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPuCorrPtSum")
        else:
            self.tPuCorrPtSum_branch.SetAddress(<void*>&self.tPuCorrPtSum_value)

        #print "making tRank"
        self.tRank_branch = the_tree.GetBranch("tRank")
        #if not self.tRank_branch and "tRank" not in self.complained:
        if not self.tRank_branch and "tRank":
            warnings.warn( "MuTauTree: Expected branch tRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRank")
        else:
            self.tRank_branch.SetAddress(<void*>&self.tRank_value)

        #print "making tVZ"
        self.tVZ_branch = the_tree.GetBranch("tVZ")
        #if not self.tVZ_branch and "tVZ" not in self.complained:
        if not self.tVZ_branch and "tVZ":
            warnings.warn( "MuTauTree: Expected branch tVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVZ")
        else:
            self.tVZ_branch.SetAddress(<void*>&self.tVZ_value)

        #print "making t_m_collinearmass"
        self.t_m_collinearmass_branch = the_tree.GetBranch("t_m_collinearmass")
        #if not self.t_m_collinearmass_branch and "t_m_collinearmass" not in self.complained:
        if not self.t_m_collinearmass_branch and "t_m_collinearmass":
            warnings.warn( "MuTauTree: Expected branch t_m_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_m_collinearmass")
        else:
            self.t_m_collinearmass_branch.SetAddress(<void*>&self.t_m_collinearmass_value)

        #print "making tauVetoPt20Loose3HitsNewDMVtx"
        self.tauVetoPt20Loose3HitsNewDMVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsNewDMVtx")
        #if not self.tauVetoPt20Loose3HitsNewDMVtx_branch and "tauVetoPt20Loose3HitsNewDMVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsNewDMVtx_branch and "tauVetoPt20Loose3HitsNewDMVtx":
            warnings.warn( "MuTauTree: Expected branch tauVetoPt20Loose3HitsNewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsNewDMVtx")
        else:
            self.tauVetoPt20Loose3HitsNewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsNewDMVtx_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "MuTauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20TightMVALTNewDMVtx"
        self.tauVetoPt20TightMVALTNewDMVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTNewDMVtx")
        #if not self.tauVetoPt20TightMVALTNewDMVtx_branch and "tauVetoPt20TightMVALTNewDMVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTNewDMVtx_branch and "tauVetoPt20TightMVALTNewDMVtx":
            warnings.warn( "MuTauTree: Expected branch tauVetoPt20TightMVALTNewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTNewDMVtx")
        else:
            self.tauVetoPt20TightMVALTNewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTNewDMVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "MuTauTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making tripleEGroup"
        self.tripleEGroup_branch = the_tree.GetBranch("tripleEGroup")
        #if not self.tripleEGroup_branch and "tripleEGroup" not in self.complained:
        if not self.tripleEGroup_branch and "tripleEGroup":
            warnings.warn( "MuTauTree: Expected branch tripleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEGroup")
        else:
            self.tripleEGroup_branch.SetAddress(<void*>&self.tripleEGroup_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "MuTauTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleEPrescale"
        self.tripleEPrescale_branch = the_tree.GetBranch("tripleEPrescale")
        #if not self.tripleEPrescale_branch and "tripleEPrescale" not in self.complained:
        if not self.tripleEPrescale_branch and "tripleEPrescale":
            warnings.warn( "MuTauTree: Expected branch tripleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPrescale")
        else:
            self.tripleEPrescale_branch.SetAddress(<void*>&self.tripleEPrescale_value)

        #print "making tripleMuGroup"
        self.tripleMuGroup_branch = the_tree.GetBranch("tripleMuGroup")
        #if not self.tripleMuGroup_branch and "tripleMuGroup" not in self.complained:
        if not self.tripleMuGroup_branch and "tripleMuGroup":
            warnings.warn( "MuTauTree: Expected branch tripleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuGroup")
        else:
            self.tripleMuGroup_branch.SetAddress(<void*>&self.tripleMuGroup_value)

        #print "making tripleMuPass"
        self.tripleMuPass_branch = the_tree.GetBranch("tripleMuPass")
        #if not self.tripleMuPass_branch and "tripleMuPass" not in self.complained:
        if not self.tripleMuPass_branch and "tripleMuPass":
            warnings.warn( "MuTauTree: Expected branch tripleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuPass")
        else:
            self.tripleMuPass_branch.SetAddress(<void*>&self.tripleMuPass_value)

        #print "making tripleMuPrescale"
        self.tripleMuPrescale_branch = the_tree.GetBranch("tripleMuPrescale")
        #if not self.tripleMuPrescale_branch and "tripleMuPrescale" not in self.complained:
        if not self.tripleMuPrescale_branch and "tripleMuPrescale":
            warnings.warn( "MuTauTree: Expected branch tripleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuPrescale")
        else:
            self.tripleMuPrescale_branch.SetAddress(<void*>&self.tripleMuPrescale_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "MuTauTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "MuTauTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making type1_pfMet_shiftedPhi_ElectronEnDown"
        self.type1_pfMet_shiftedPhi_ElectronEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_ElectronEnDown")
        #if not self.type1_pfMet_shiftedPhi_ElectronEnDown_branch and "type1_pfMet_shiftedPhi_ElectronEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_ElectronEnDown_branch and "type1_pfMet_shiftedPhi_ElectronEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_ElectronEnDown")
        else:
            self.type1_pfMet_shiftedPhi_ElectronEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_ElectronEnDown_value)

        #print "making type1_pfMet_shiftedPhi_ElectronEnUp"
        self.type1_pfMet_shiftedPhi_ElectronEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_ElectronEnUp")
        #if not self.type1_pfMet_shiftedPhi_ElectronEnUp_branch and "type1_pfMet_shiftedPhi_ElectronEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_ElectronEnUp_branch and "type1_pfMet_shiftedPhi_ElectronEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_ElectronEnUp")
        else:
            self.type1_pfMet_shiftedPhi_ElectronEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_ElectronEnUp_value)

        #print "making type1_pfMet_shiftedPhi_JetEnDown"
        self.type1_pfMet_shiftedPhi_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnDown")
        #if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnDown")
        else:
            self.type1_pfMet_shiftedPhi_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnDown_value)

        #print "making type1_pfMet_shiftedPhi_JetEnUp"
        self.type1_pfMet_shiftedPhi_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnUp")
        #if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnUp")
        else:
            self.type1_pfMet_shiftedPhi_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnUp_value)

        #print "making type1_pfMet_shiftedPhi_JetResDown"
        self.type1_pfMet_shiftedPhi_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResDown")
        #if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResDown")
        else:
            self.type1_pfMet_shiftedPhi_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResDown_value)

        #print "making type1_pfMet_shiftedPhi_JetResUp"
        self.type1_pfMet_shiftedPhi_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResUp")
        #if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResUp")
        else:
            self.type1_pfMet_shiftedPhi_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResUp_value)

        #print "making type1_pfMet_shiftedPhi_MuonEnDown"
        self.type1_pfMet_shiftedPhi_MuonEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_MuonEnDown")
        #if not self.type1_pfMet_shiftedPhi_MuonEnDown_branch and "type1_pfMet_shiftedPhi_MuonEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_MuonEnDown_branch and "type1_pfMet_shiftedPhi_MuonEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_MuonEnDown")
        else:
            self.type1_pfMet_shiftedPhi_MuonEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_MuonEnDown_value)

        #print "making type1_pfMet_shiftedPhi_MuonEnUp"
        self.type1_pfMet_shiftedPhi_MuonEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_MuonEnUp")
        #if not self.type1_pfMet_shiftedPhi_MuonEnUp_branch and "type1_pfMet_shiftedPhi_MuonEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_MuonEnUp_branch and "type1_pfMet_shiftedPhi_MuonEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_MuonEnUp")
        else:
            self.type1_pfMet_shiftedPhi_MuonEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_MuonEnUp_value)

        #print "making type1_pfMet_shiftedPhi_PhotonEnDown"
        self.type1_pfMet_shiftedPhi_PhotonEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_PhotonEnDown")
        #if not self.type1_pfMet_shiftedPhi_PhotonEnDown_branch and "type1_pfMet_shiftedPhi_PhotonEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_PhotonEnDown_branch and "type1_pfMet_shiftedPhi_PhotonEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_PhotonEnDown")
        else:
            self.type1_pfMet_shiftedPhi_PhotonEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_PhotonEnDown_value)

        #print "making type1_pfMet_shiftedPhi_PhotonEnUp"
        self.type1_pfMet_shiftedPhi_PhotonEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_PhotonEnUp")
        #if not self.type1_pfMet_shiftedPhi_PhotonEnUp_branch and "type1_pfMet_shiftedPhi_PhotonEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_PhotonEnUp_branch and "type1_pfMet_shiftedPhi_PhotonEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_PhotonEnUp")
        else:
            self.type1_pfMet_shiftedPhi_PhotonEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_PhotonEnUp_value)

        #print "making type1_pfMet_shiftedPhi_TauEnDown"
        self.type1_pfMet_shiftedPhi_TauEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_TauEnDown")
        #if not self.type1_pfMet_shiftedPhi_TauEnDown_branch and "type1_pfMet_shiftedPhi_TauEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_TauEnDown_branch and "type1_pfMet_shiftedPhi_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_TauEnDown")
        else:
            self.type1_pfMet_shiftedPhi_TauEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_TauEnDown_value)

        #print "making type1_pfMet_shiftedPhi_TauEnUp"
        self.type1_pfMet_shiftedPhi_TauEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_TauEnUp")
        #if not self.type1_pfMet_shiftedPhi_TauEnUp_branch and "type1_pfMet_shiftedPhi_TauEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_TauEnUp_branch and "type1_pfMet_shiftedPhi_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_TauEnUp")
        else:
            self.type1_pfMet_shiftedPhi_TauEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_TauEnUp_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnDown"
        self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnUp"
        self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnUp_value)

        #print "making type1_pfMet_shiftedPt_ElectronEnDown"
        self.type1_pfMet_shiftedPt_ElectronEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_ElectronEnDown")
        #if not self.type1_pfMet_shiftedPt_ElectronEnDown_branch and "type1_pfMet_shiftedPt_ElectronEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_ElectronEnDown_branch and "type1_pfMet_shiftedPt_ElectronEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_ElectronEnDown")
        else:
            self.type1_pfMet_shiftedPt_ElectronEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_ElectronEnDown_value)

        #print "making type1_pfMet_shiftedPt_ElectronEnUp"
        self.type1_pfMet_shiftedPt_ElectronEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_ElectronEnUp")
        #if not self.type1_pfMet_shiftedPt_ElectronEnUp_branch and "type1_pfMet_shiftedPt_ElectronEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_ElectronEnUp_branch and "type1_pfMet_shiftedPt_ElectronEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_ElectronEnUp")
        else:
            self.type1_pfMet_shiftedPt_ElectronEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_ElectronEnUp_value)

        #print "making type1_pfMet_shiftedPt_JetEnDown"
        self.type1_pfMet_shiftedPt_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnDown")
        #if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnDown")
        else:
            self.type1_pfMet_shiftedPt_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnDown_value)

        #print "making type1_pfMet_shiftedPt_JetEnUp"
        self.type1_pfMet_shiftedPt_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnUp")
        #if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnUp")
        else:
            self.type1_pfMet_shiftedPt_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnUp_value)

        #print "making type1_pfMet_shiftedPt_JetResDown"
        self.type1_pfMet_shiftedPt_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResDown")
        #if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResDown")
        else:
            self.type1_pfMet_shiftedPt_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResDown_value)

        #print "making type1_pfMet_shiftedPt_JetResUp"
        self.type1_pfMet_shiftedPt_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResUp")
        #if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResUp")
        else:
            self.type1_pfMet_shiftedPt_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResUp_value)

        #print "making type1_pfMet_shiftedPt_MuonEnDown"
        self.type1_pfMet_shiftedPt_MuonEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_MuonEnDown")
        #if not self.type1_pfMet_shiftedPt_MuonEnDown_branch and "type1_pfMet_shiftedPt_MuonEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_MuonEnDown_branch and "type1_pfMet_shiftedPt_MuonEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_MuonEnDown")
        else:
            self.type1_pfMet_shiftedPt_MuonEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_MuonEnDown_value)

        #print "making type1_pfMet_shiftedPt_MuonEnUp"
        self.type1_pfMet_shiftedPt_MuonEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_MuonEnUp")
        #if not self.type1_pfMet_shiftedPt_MuonEnUp_branch and "type1_pfMet_shiftedPt_MuonEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_MuonEnUp_branch and "type1_pfMet_shiftedPt_MuonEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_MuonEnUp")
        else:
            self.type1_pfMet_shiftedPt_MuonEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_MuonEnUp_value)

        #print "making type1_pfMet_shiftedPt_PhotonEnDown"
        self.type1_pfMet_shiftedPt_PhotonEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_PhotonEnDown")
        #if not self.type1_pfMet_shiftedPt_PhotonEnDown_branch and "type1_pfMet_shiftedPt_PhotonEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_PhotonEnDown_branch and "type1_pfMet_shiftedPt_PhotonEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_PhotonEnDown")
        else:
            self.type1_pfMet_shiftedPt_PhotonEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_PhotonEnDown_value)

        #print "making type1_pfMet_shiftedPt_PhotonEnUp"
        self.type1_pfMet_shiftedPt_PhotonEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_PhotonEnUp")
        #if not self.type1_pfMet_shiftedPt_PhotonEnUp_branch and "type1_pfMet_shiftedPt_PhotonEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_PhotonEnUp_branch and "type1_pfMet_shiftedPt_PhotonEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_PhotonEnUp")
        else:
            self.type1_pfMet_shiftedPt_PhotonEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_PhotonEnUp_value)

        #print "making type1_pfMet_shiftedPt_TauEnDown"
        self.type1_pfMet_shiftedPt_TauEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_TauEnDown")
        #if not self.type1_pfMet_shiftedPt_TauEnDown_branch and "type1_pfMet_shiftedPt_TauEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_TauEnDown_branch and "type1_pfMet_shiftedPt_TauEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_TauEnDown")
        else:
            self.type1_pfMet_shiftedPt_TauEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_TauEnDown_value)

        #print "making type1_pfMet_shiftedPt_TauEnUp"
        self.type1_pfMet_shiftedPt_TauEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_TauEnUp")
        #if not self.type1_pfMet_shiftedPt_TauEnUp_branch and "type1_pfMet_shiftedPt_TauEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_TauEnUp_branch and "type1_pfMet_shiftedPt_TauEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_TauEnUp")
        else:
            self.type1_pfMet_shiftedPt_TauEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_TauEnUp_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnDown"
        self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnUp"
        self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnUp_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "MuTauTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfDeta_JetEnDown"
        self.vbfDeta_JetEnDown_branch = the_tree.GetBranch("vbfDeta_JetEnDown")
        #if not self.vbfDeta_JetEnDown_branch and "vbfDeta_JetEnDown" not in self.complained:
        if not self.vbfDeta_JetEnDown_branch and "vbfDeta_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfDeta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta_JetEnDown")
        else:
            self.vbfDeta_JetEnDown_branch.SetAddress(<void*>&self.vbfDeta_JetEnDown_value)

        #print "making vbfDeta_JetEnUp"
        self.vbfDeta_JetEnUp_branch = the_tree.GetBranch("vbfDeta_JetEnUp")
        #if not self.vbfDeta_JetEnUp_branch and "vbfDeta_JetEnUp" not in self.complained:
        if not self.vbfDeta_JetEnUp_branch and "vbfDeta_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfDeta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta_JetEnUp")
        else:
            self.vbfDeta_JetEnUp_branch.SetAddress(<void*>&self.vbfDeta_JetEnUp_value)

        #print "making vbfDijetrap"
        self.vbfDijetrap_branch = the_tree.GetBranch("vbfDijetrap")
        #if not self.vbfDijetrap_branch and "vbfDijetrap" not in self.complained:
        if not self.vbfDijetrap_branch and "vbfDijetrap":
            warnings.warn( "MuTauTree: Expected branch vbfDijetrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap")
        else:
            self.vbfDijetrap_branch.SetAddress(<void*>&self.vbfDijetrap_value)

        #print "making vbfDijetrap_JetEnDown"
        self.vbfDijetrap_JetEnDown_branch = the_tree.GetBranch("vbfDijetrap_JetEnDown")
        #if not self.vbfDijetrap_JetEnDown_branch and "vbfDijetrap_JetEnDown" not in self.complained:
        if not self.vbfDijetrap_JetEnDown_branch and "vbfDijetrap_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfDijetrap_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap_JetEnDown")
        else:
            self.vbfDijetrap_JetEnDown_branch.SetAddress(<void*>&self.vbfDijetrap_JetEnDown_value)

        #print "making vbfDijetrap_JetEnUp"
        self.vbfDijetrap_JetEnUp_branch = the_tree.GetBranch("vbfDijetrap_JetEnUp")
        #if not self.vbfDijetrap_JetEnUp_branch and "vbfDijetrap_JetEnUp" not in self.complained:
        if not self.vbfDijetrap_JetEnUp_branch and "vbfDijetrap_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfDijetrap_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap_JetEnUp")
        else:
            self.vbfDijetrap_JetEnUp_branch.SetAddress(<void*>&self.vbfDijetrap_JetEnUp_value)

        #print "making vbfDphi"
        self.vbfDphi_branch = the_tree.GetBranch("vbfDphi")
        #if not self.vbfDphi_branch and "vbfDphi" not in self.complained:
        if not self.vbfDphi_branch and "vbfDphi":
            warnings.warn( "MuTauTree: Expected branch vbfDphi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi")
        else:
            self.vbfDphi_branch.SetAddress(<void*>&self.vbfDphi_value)

        #print "making vbfDphi_JetEnDown"
        self.vbfDphi_JetEnDown_branch = the_tree.GetBranch("vbfDphi_JetEnDown")
        #if not self.vbfDphi_JetEnDown_branch and "vbfDphi_JetEnDown" not in self.complained:
        if not self.vbfDphi_JetEnDown_branch and "vbfDphi_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfDphi_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi_JetEnDown")
        else:
            self.vbfDphi_JetEnDown_branch.SetAddress(<void*>&self.vbfDphi_JetEnDown_value)

        #print "making vbfDphi_JetEnUp"
        self.vbfDphi_JetEnUp_branch = the_tree.GetBranch("vbfDphi_JetEnUp")
        #if not self.vbfDphi_JetEnUp_branch and "vbfDphi_JetEnUp" not in self.complained:
        if not self.vbfDphi_JetEnUp_branch and "vbfDphi_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfDphi_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi_JetEnUp")
        else:
            self.vbfDphi_JetEnUp_branch.SetAddress(<void*>&self.vbfDphi_JetEnUp_value)

        #print "making vbfDphihj"
        self.vbfDphihj_branch = the_tree.GetBranch("vbfDphihj")
        #if not self.vbfDphihj_branch and "vbfDphihj" not in self.complained:
        if not self.vbfDphihj_branch and "vbfDphihj":
            warnings.warn( "MuTauTree: Expected branch vbfDphihj does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj")
        else:
            self.vbfDphihj_branch.SetAddress(<void*>&self.vbfDphihj_value)

        #print "making vbfDphihj_JetEnDown"
        self.vbfDphihj_JetEnDown_branch = the_tree.GetBranch("vbfDphihj_JetEnDown")
        #if not self.vbfDphihj_JetEnDown_branch and "vbfDphihj_JetEnDown" not in self.complained:
        if not self.vbfDphihj_JetEnDown_branch and "vbfDphihj_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfDphihj_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj_JetEnDown")
        else:
            self.vbfDphihj_JetEnDown_branch.SetAddress(<void*>&self.vbfDphihj_JetEnDown_value)

        #print "making vbfDphihj_JetEnUp"
        self.vbfDphihj_JetEnUp_branch = the_tree.GetBranch("vbfDphihj_JetEnUp")
        #if not self.vbfDphihj_JetEnUp_branch and "vbfDphihj_JetEnUp" not in self.complained:
        if not self.vbfDphihj_JetEnUp_branch and "vbfDphihj_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfDphihj_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj_JetEnUp")
        else:
            self.vbfDphihj_JetEnUp_branch.SetAddress(<void*>&self.vbfDphihj_JetEnUp_value)

        #print "making vbfDphihjnomet"
        self.vbfDphihjnomet_branch = the_tree.GetBranch("vbfDphihjnomet")
        #if not self.vbfDphihjnomet_branch and "vbfDphihjnomet" not in self.complained:
        if not self.vbfDphihjnomet_branch and "vbfDphihjnomet":
            warnings.warn( "MuTauTree: Expected branch vbfDphihjnomet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet")
        else:
            self.vbfDphihjnomet_branch.SetAddress(<void*>&self.vbfDphihjnomet_value)

        #print "making vbfDphihjnomet_JetEnDown"
        self.vbfDphihjnomet_JetEnDown_branch = the_tree.GetBranch("vbfDphihjnomet_JetEnDown")
        #if not self.vbfDphihjnomet_JetEnDown_branch and "vbfDphihjnomet_JetEnDown" not in self.complained:
        if not self.vbfDphihjnomet_JetEnDown_branch and "vbfDphihjnomet_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfDphihjnomet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet_JetEnDown")
        else:
            self.vbfDphihjnomet_JetEnDown_branch.SetAddress(<void*>&self.vbfDphihjnomet_JetEnDown_value)

        #print "making vbfDphihjnomet_JetEnUp"
        self.vbfDphihjnomet_JetEnUp_branch = the_tree.GetBranch("vbfDphihjnomet_JetEnUp")
        #if not self.vbfDphihjnomet_JetEnUp_branch and "vbfDphihjnomet_JetEnUp" not in self.complained:
        if not self.vbfDphihjnomet_JetEnUp_branch and "vbfDphihjnomet_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfDphihjnomet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet_JetEnUp")
        else:
            self.vbfDphihjnomet_JetEnUp_branch.SetAddress(<void*>&self.vbfDphihjnomet_JetEnUp_value)

        #print "making vbfHrap"
        self.vbfHrap_branch = the_tree.GetBranch("vbfHrap")
        #if not self.vbfHrap_branch and "vbfHrap" not in self.complained:
        if not self.vbfHrap_branch and "vbfHrap":
            warnings.warn( "MuTauTree: Expected branch vbfHrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap")
        else:
            self.vbfHrap_branch.SetAddress(<void*>&self.vbfHrap_value)

        #print "making vbfHrap_JetEnDown"
        self.vbfHrap_JetEnDown_branch = the_tree.GetBranch("vbfHrap_JetEnDown")
        #if not self.vbfHrap_JetEnDown_branch and "vbfHrap_JetEnDown" not in self.complained:
        if not self.vbfHrap_JetEnDown_branch and "vbfHrap_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfHrap_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap_JetEnDown")
        else:
            self.vbfHrap_JetEnDown_branch.SetAddress(<void*>&self.vbfHrap_JetEnDown_value)

        #print "making vbfHrap_JetEnUp"
        self.vbfHrap_JetEnUp_branch = the_tree.GetBranch("vbfHrap_JetEnUp")
        #if not self.vbfHrap_JetEnUp_branch and "vbfHrap_JetEnUp" not in self.complained:
        if not self.vbfHrap_JetEnUp_branch and "vbfHrap_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfHrap_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap_JetEnUp")
        else:
            self.vbfHrap_JetEnUp_branch.SetAddress(<void*>&self.vbfHrap_JetEnUp_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "MuTauTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto20_JetEnDown"
        self.vbfJetVeto20_JetEnDown_branch = the_tree.GetBranch("vbfJetVeto20_JetEnDown")
        #if not self.vbfJetVeto20_JetEnDown_branch and "vbfJetVeto20_JetEnDown" not in self.complained:
        if not self.vbfJetVeto20_JetEnDown_branch and "vbfJetVeto20_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfJetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20_JetEnDown")
        else:
            self.vbfJetVeto20_JetEnDown_branch.SetAddress(<void*>&self.vbfJetVeto20_JetEnDown_value)

        #print "making vbfJetVeto20_JetEnUp"
        self.vbfJetVeto20_JetEnUp_branch = the_tree.GetBranch("vbfJetVeto20_JetEnUp")
        #if not self.vbfJetVeto20_JetEnUp_branch and "vbfJetVeto20_JetEnUp" not in self.complained:
        if not self.vbfJetVeto20_JetEnUp_branch and "vbfJetVeto20_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfJetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20_JetEnUp")
        else:
            self.vbfJetVeto20_JetEnUp_branch.SetAddress(<void*>&self.vbfJetVeto20_JetEnUp_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "MuTauTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfJetVeto30_JetEnDown"
        self.vbfJetVeto30_JetEnDown_branch = the_tree.GetBranch("vbfJetVeto30_JetEnDown")
        #if not self.vbfJetVeto30_JetEnDown_branch and "vbfJetVeto30_JetEnDown" not in self.complained:
        if not self.vbfJetVeto30_JetEnDown_branch and "vbfJetVeto30_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfJetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30_JetEnDown")
        else:
            self.vbfJetVeto30_JetEnDown_branch.SetAddress(<void*>&self.vbfJetVeto30_JetEnDown_value)

        #print "making vbfJetVeto30_JetEnUp"
        self.vbfJetVeto30_JetEnUp_branch = the_tree.GetBranch("vbfJetVeto30_JetEnUp")
        #if not self.vbfJetVeto30_JetEnUp_branch and "vbfJetVeto30_JetEnUp" not in self.complained:
        if not self.vbfJetVeto30_JetEnUp_branch and "vbfJetVeto30_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfJetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30_JetEnUp")
        else:
            self.vbfJetVeto30_JetEnUp_branch.SetAddress(<void*>&self.vbfJetVeto30_JetEnUp_value)

        #print "making vbfJetVetoTight20"
        self.vbfJetVetoTight20_branch = the_tree.GetBranch("vbfJetVetoTight20")
        #if not self.vbfJetVetoTight20_branch and "vbfJetVetoTight20" not in self.complained:
        if not self.vbfJetVetoTight20_branch and "vbfJetVetoTight20":
            warnings.warn( "MuTauTree: Expected branch vbfJetVetoTight20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVetoTight20")
        else:
            self.vbfJetVetoTight20_branch.SetAddress(<void*>&self.vbfJetVetoTight20_value)

        #print "making vbfJetVetoTight20_JetEnDown"
        self.vbfJetVetoTight20_JetEnDown_branch = the_tree.GetBranch("vbfJetVetoTight20_JetEnDown")
        #if not self.vbfJetVetoTight20_JetEnDown_branch and "vbfJetVetoTight20_JetEnDown" not in self.complained:
        if not self.vbfJetVetoTight20_JetEnDown_branch and "vbfJetVetoTight20_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfJetVetoTight20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVetoTight20_JetEnDown")
        else:
            self.vbfJetVetoTight20_JetEnDown_branch.SetAddress(<void*>&self.vbfJetVetoTight20_JetEnDown_value)

        #print "making vbfJetVetoTight20_JetEnUp"
        self.vbfJetVetoTight20_JetEnUp_branch = the_tree.GetBranch("vbfJetVetoTight20_JetEnUp")
        #if not self.vbfJetVetoTight20_JetEnUp_branch and "vbfJetVetoTight20_JetEnUp" not in self.complained:
        if not self.vbfJetVetoTight20_JetEnUp_branch and "vbfJetVetoTight20_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfJetVetoTight20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVetoTight20_JetEnUp")
        else:
            self.vbfJetVetoTight20_JetEnUp_branch.SetAddress(<void*>&self.vbfJetVetoTight20_JetEnUp_value)

        #print "making vbfJetVetoTight30"
        self.vbfJetVetoTight30_branch = the_tree.GetBranch("vbfJetVetoTight30")
        #if not self.vbfJetVetoTight30_branch and "vbfJetVetoTight30" not in self.complained:
        if not self.vbfJetVetoTight30_branch and "vbfJetVetoTight30":
            warnings.warn( "MuTauTree: Expected branch vbfJetVetoTight30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVetoTight30")
        else:
            self.vbfJetVetoTight30_branch.SetAddress(<void*>&self.vbfJetVetoTight30_value)

        #print "making vbfJetVetoTight30_JetEnDown"
        self.vbfJetVetoTight30_JetEnDown_branch = the_tree.GetBranch("vbfJetVetoTight30_JetEnDown")
        #if not self.vbfJetVetoTight30_JetEnDown_branch and "vbfJetVetoTight30_JetEnDown" not in self.complained:
        if not self.vbfJetVetoTight30_JetEnDown_branch and "vbfJetVetoTight30_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfJetVetoTight30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVetoTight30_JetEnDown")
        else:
            self.vbfJetVetoTight30_JetEnDown_branch.SetAddress(<void*>&self.vbfJetVetoTight30_JetEnDown_value)

        #print "making vbfJetVetoTight30_JetEnUp"
        self.vbfJetVetoTight30_JetEnUp_branch = the_tree.GetBranch("vbfJetVetoTight30_JetEnUp")
        #if not self.vbfJetVetoTight30_JetEnUp_branch and "vbfJetVetoTight30_JetEnUp" not in self.complained:
        if not self.vbfJetVetoTight30_JetEnUp_branch and "vbfJetVetoTight30_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfJetVetoTight30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVetoTight30_JetEnUp")
        else:
            self.vbfJetVetoTight30_JetEnUp_branch.SetAddress(<void*>&self.vbfJetVetoTight30_JetEnUp_value)

        #print "making vbfMVA"
        self.vbfMVA_branch = the_tree.GetBranch("vbfMVA")
        #if not self.vbfMVA_branch and "vbfMVA" not in self.complained:
        if not self.vbfMVA_branch and "vbfMVA":
            warnings.warn( "MuTauTree: Expected branch vbfMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA")
        else:
            self.vbfMVA_branch.SetAddress(<void*>&self.vbfMVA_value)

        #print "making vbfMVA_JetEnDown"
        self.vbfMVA_JetEnDown_branch = the_tree.GetBranch("vbfMVA_JetEnDown")
        #if not self.vbfMVA_JetEnDown_branch and "vbfMVA_JetEnDown" not in self.complained:
        if not self.vbfMVA_JetEnDown_branch and "vbfMVA_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfMVA_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA_JetEnDown")
        else:
            self.vbfMVA_JetEnDown_branch.SetAddress(<void*>&self.vbfMVA_JetEnDown_value)

        #print "making vbfMVA_JetEnUp"
        self.vbfMVA_JetEnUp_branch = the_tree.GetBranch("vbfMVA_JetEnUp")
        #if not self.vbfMVA_JetEnUp_branch and "vbfMVA_JetEnUp" not in self.complained:
        if not self.vbfMVA_JetEnUp_branch and "vbfMVA_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfMVA_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA_JetEnUp")
        else:
            self.vbfMVA_JetEnUp_branch.SetAddress(<void*>&self.vbfMVA_JetEnUp_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "MuTauTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMass_JetEnDown"
        self.vbfMass_JetEnDown_branch = the_tree.GetBranch("vbfMass_JetEnDown")
        #if not self.vbfMass_JetEnDown_branch and "vbfMass_JetEnDown" not in self.complained:
        if not self.vbfMass_JetEnDown_branch and "vbfMass_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEnDown")
        else:
            self.vbfMass_JetEnDown_branch.SetAddress(<void*>&self.vbfMass_JetEnDown_value)

        #print "making vbfMass_JetEnUp"
        self.vbfMass_JetEnUp_branch = the_tree.GetBranch("vbfMass_JetEnUp")
        #if not self.vbfMass_JetEnUp_branch and "vbfMass_JetEnUp" not in self.complained:
        if not self.vbfMass_JetEnUp_branch and "vbfMass_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEnUp")
        else:
            self.vbfMass_JetEnUp_branch.SetAddress(<void*>&self.vbfMass_JetEnUp_value)

        #print "making vbfNJets"
        self.vbfNJets_branch = the_tree.GetBranch("vbfNJets")
        #if not self.vbfNJets_branch and "vbfNJets" not in self.complained:
        if not self.vbfNJets_branch and "vbfNJets":
            warnings.warn( "MuTauTree: Expected branch vbfNJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets")
        else:
            self.vbfNJets_branch.SetAddress(<void*>&self.vbfNJets_value)

        #print "making vbfNJets_JetEnDown"
        self.vbfNJets_JetEnDown_branch = the_tree.GetBranch("vbfNJets_JetEnDown")
        #if not self.vbfNJets_JetEnDown_branch and "vbfNJets_JetEnDown" not in self.complained:
        if not self.vbfNJets_JetEnDown_branch and "vbfNJets_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfNJets_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets_JetEnDown")
        else:
            self.vbfNJets_JetEnDown_branch.SetAddress(<void*>&self.vbfNJets_JetEnDown_value)

        #print "making vbfNJets_JetEnUp"
        self.vbfNJets_JetEnUp_branch = the_tree.GetBranch("vbfNJets_JetEnUp")
        #if not self.vbfNJets_JetEnUp_branch and "vbfNJets_JetEnUp" not in self.complained:
        if not self.vbfNJets_JetEnUp_branch and "vbfNJets_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfNJets_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets_JetEnUp")
        else:
            self.vbfNJets_JetEnUp_branch.SetAddress(<void*>&self.vbfNJets_JetEnUp_value)

        #print "making vbfVispt"
        self.vbfVispt_branch = the_tree.GetBranch("vbfVispt")
        #if not self.vbfVispt_branch and "vbfVispt" not in self.complained:
        if not self.vbfVispt_branch and "vbfVispt":
            warnings.warn( "MuTauTree: Expected branch vbfVispt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt")
        else:
            self.vbfVispt_branch.SetAddress(<void*>&self.vbfVispt_value)

        #print "making vbfVispt_JetEnDown"
        self.vbfVispt_JetEnDown_branch = the_tree.GetBranch("vbfVispt_JetEnDown")
        #if not self.vbfVispt_JetEnDown_branch and "vbfVispt_JetEnDown" not in self.complained:
        if not self.vbfVispt_JetEnDown_branch and "vbfVispt_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfVispt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt_JetEnDown")
        else:
            self.vbfVispt_JetEnDown_branch.SetAddress(<void*>&self.vbfVispt_JetEnDown_value)

        #print "making vbfVispt_JetEnUp"
        self.vbfVispt_JetEnUp_branch = the_tree.GetBranch("vbfVispt_JetEnUp")
        #if not self.vbfVispt_JetEnUp_branch and "vbfVispt_JetEnUp" not in self.complained:
        if not self.vbfVispt_JetEnUp_branch and "vbfVispt_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfVispt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt_JetEnUp")
        else:
            self.vbfVispt_JetEnUp_branch.SetAddress(<void*>&self.vbfVispt_JetEnUp_value)

        #print "making vbfdijetpt"
        self.vbfdijetpt_branch = the_tree.GetBranch("vbfdijetpt")
        #if not self.vbfdijetpt_branch and "vbfdijetpt" not in self.complained:
        if not self.vbfdijetpt_branch and "vbfdijetpt":
            warnings.warn( "MuTauTree: Expected branch vbfdijetpt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt")
        else:
            self.vbfdijetpt_branch.SetAddress(<void*>&self.vbfdijetpt_value)

        #print "making vbfdijetpt_JetEnDown"
        self.vbfdijetpt_JetEnDown_branch = the_tree.GetBranch("vbfdijetpt_JetEnDown")
        #if not self.vbfdijetpt_JetEnDown_branch and "vbfdijetpt_JetEnDown" not in self.complained:
        if not self.vbfdijetpt_JetEnDown_branch and "vbfdijetpt_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfdijetpt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt_JetEnDown")
        else:
            self.vbfdijetpt_JetEnDown_branch.SetAddress(<void*>&self.vbfdijetpt_JetEnDown_value)

        #print "making vbfdijetpt_JetEnUp"
        self.vbfdijetpt_JetEnUp_branch = the_tree.GetBranch("vbfdijetpt_JetEnUp")
        #if not self.vbfdijetpt_JetEnUp_branch and "vbfdijetpt_JetEnUp" not in self.complained:
        if not self.vbfdijetpt_JetEnUp_branch and "vbfdijetpt_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfdijetpt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt_JetEnUp")
        else:
            self.vbfdijetpt_JetEnUp_branch.SetAddress(<void*>&self.vbfdijetpt_JetEnUp_value)

        #print "making vbfditaupt"
        self.vbfditaupt_branch = the_tree.GetBranch("vbfditaupt")
        #if not self.vbfditaupt_branch and "vbfditaupt" not in self.complained:
        if not self.vbfditaupt_branch and "vbfditaupt":
            warnings.warn( "MuTauTree: Expected branch vbfditaupt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfditaupt")
        else:
            self.vbfditaupt_branch.SetAddress(<void*>&self.vbfditaupt_value)

        #print "making vbfditaupt_JetEnDown"
        self.vbfditaupt_JetEnDown_branch = the_tree.GetBranch("vbfditaupt_JetEnDown")
        #if not self.vbfditaupt_JetEnDown_branch and "vbfditaupt_JetEnDown" not in self.complained:
        if not self.vbfditaupt_JetEnDown_branch and "vbfditaupt_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfditaupt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfditaupt_JetEnDown")
        else:
            self.vbfditaupt_JetEnDown_branch.SetAddress(<void*>&self.vbfditaupt_JetEnDown_value)

        #print "making vbfditaupt_JetEnUp"
        self.vbfditaupt_JetEnUp_branch = the_tree.GetBranch("vbfditaupt_JetEnUp")
        #if not self.vbfditaupt_JetEnUp_branch and "vbfditaupt_JetEnUp" not in self.complained:
        if not self.vbfditaupt_JetEnUp_branch and "vbfditaupt_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfditaupt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfditaupt_JetEnUp")
        else:
            self.vbfditaupt_JetEnUp_branch.SetAddress(<void*>&self.vbfditaupt_JetEnUp_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "MuTauTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1eta_JetEnDown"
        self.vbfj1eta_JetEnDown_branch = the_tree.GetBranch("vbfj1eta_JetEnDown")
        #if not self.vbfj1eta_JetEnDown_branch and "vbfj1eta_JetEnDown" not in self.complained:
        if not self.vbfj1eta_JetEnDown_branch and "vbfj1eta_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfj1eta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta_JetEnDown")
        else:
            self.vbfj1eta_JetEnDown_branch.SetAddress(<void*>&self.vbfj1eta_JetEnDown_value)

        #print "making vbfj1eta_JetEnUp"
        self.vbfj1eta_JetEnUp_branch = the_tree.GetBranch("vbfj1eta_JetEnUp")
        #if not self.vbfj1eta_JetEnUp_branch and "vbfj1eta_JetEnUp" not in self.complained:
        if not self.vbfj1eta_JetEnUp_branch and "vbfj1eta_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfj1eta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta_JetEnUp")
        else:
            self.vbfj1eta_JetEnUp_branch.SetAddress(<void*>&self.vbfj1eta_JetEnUp_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "MuTauTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj1pt_JetEnDown"
        self.vbfj1pt_JetEnDown_branch = the_tree.GetBranch("vbfj1pt_JetEnDown")
        #if not self.vbfj1pt_JetEnDown_branch and "vbfj1pt_JetEnDown" not in self.complained:
        if not self.vbfj1pt_JetEnDown_branch and "vbfj1pt_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfj1pt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt_JetEnDown")
        else:
            self.vbfj1pt_JetEnDown_branch.SetAddress(<void*>&self.vbfj1pt_JetEnDown_value)

        #print "making vbfj1pt_JetEnUp"
        self.vbfj1pt_JetEnUp_branch = the_tree.GetBranch("vbfj1pt_JetEnUp")
        #if not self.vbfj1pt_JetEnUp_branch and "vbfj1pt_JetEnUp" not in self.complained:
        if not self.vbfj1pt_JetEnUp_branch and "vbfj1pt_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfj1pt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt_JetEnUp")
        else:
            self.vbfj1pt_JetEnUp_branch.SetAddress(<void*>&self.vbfj1pt_JetEnUp_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "MuTauTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2eta_JetEnDown"
        self.vbfj2eta_JetEnDown_branch = the_tree.GetBranch("vbfj2eta_JetEnDown")
        #if not self.vbfj2eta_JetEnDown_branch and "vbfj2eta_JetEnDown" not in self.complained:
        if not self.vbfj2eta_JetEnDown_branch and "vbfj2eta_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfj2eta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta_JetEnDown")
        else:
            self.vbfj2eta_JetEnDown_branch.SetAddress(<void*>&self.vbfj2eta_JetEnDown_value)

        #print "making vbfj2eta_JetEnUp"
        self.vbfj2eta_JetEnUp_branch = the_tree.GetBranch("vbfj2eta_JetEnUp")
        #if not self.vbfj2eta_JetEnUp_branch and "vbfj2eta_JetEnUp" not in self.complained:
        if not self.vbfj2eta_JetEnUp_branch and "vbfj2eta_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfj2eta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta_JetEnUp")
        else:
            self.vbfj2eta_JetEnUp_branch.SetAddress(<void*>&self.vbfj2eta_JetEnUp_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "MuTauTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vbfj2pt_JetEnDown"
        self.vbfj2pt_JetEnDown_branch = the_tree.GetBranch("vbfj2pt_JetEnDown")
        #if not self.vbfj2pt_JetEnDown_branch and "vbfj2pt_JetEnDown" not in self.complained:
        if not self.vbfj2pt_JetEnDown_branch and "vbfj2pt_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfj2pt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt_JetEnDown")
        else:
            self.vbfj2pt_JetEnDown_branch.SetAddress(<void*>&self.vbfj2pt_JetEnDown_value)

        #print "making vbfj2pt_JetEnUp"
        self.vbfj2pt_JetEnUp_branch = the_tree.GetBranch("vbfj2pt_JetEnUp")
        #if not self.vbfj2pt_JetEnUp_branch and "vbfj2pt_JetEnUp" not in self.complained:
        if not self.vbfj2pt_JetEnUp_branch and "vbfj2pt_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfj2pt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt_JetEnUp")
        else:
            self.vbfj2pt_JetEnUp_branch.SetAddress(<void*>&self.vbfj2pt_JetEnUp_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "MuTauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("idx")
        else:
            self.idx_branch.SetAddress(<void*>&self.idx_value)


    # Iterating over the tree
    def __iter__(self):
        self.ientry = 0
        while self.ientry < self.tree.GetEntries():
            self.load_entry(self.ientry)
            yield self
            self.ientry += 1

    # Iterate over rows which pass the filter
    def where(self, filter):
        print "where"
        cdef TTreeFormula* formula = new TTreeFormula(
            "cyiter", filter, self.tree)
        self.ientry = 0
        cdef TTree* currentTree = self.tree.GetTree()
        while self.ientry < self.tree.GetEntries():
            self.tree.LoadTree(self.ientry)
            if currentTree != self.tree.GetTree():
                currentTree = self.tree.GetTree()
                formula.SetTree(currentTree)
                formula.UpdateFormulaLeaves()
            if formula.EvalInstance(0, NULL):
                yield self
            self.ientry += 1
        del formula

    # Getting/setting the Tree entry number
    property entry:
        def __get__(self):
            return self.ientry
        def __set__(self, int i):
            print i
            self.ientry = i
            self.load_entry(i)

    # Access to the current branch values

    property EmbPtWeight:
        def __get__(self):
            self.EmbPtWeight_branch.GetEntry(self.localentry, 0)
            return self.EmbPtWeight_value

    property Eta:
        def __get__(self):
            self.Eta_branch.GetEntry(self.localentry, 0)
            return self.Eta_value

    property GenWeight:
        def __get__(self):
            self.GenWeight_branch.GetEntry(self.localentry, 0)
            return self.GenWeight_value

    property Ht:
        def __get__(self):
            self.Ht_branch.GetEntry(self.localentry, 0)
            return self.Ht_value

    property LT:
        def __get__(self):
            self.LT_branch.GetEntry(self.localentry, 0)
            return self.LT_value

    property Mass:
        def __get__(self):
            self.Mass_branch.GetEntry(self.localentry, 0)
            return self.Mass_value

    property MassError:
        def __get__(self):
            self.MassError_branch.GetEntry(self.localentry, 0)
            return self.MassError_value

    property MassErrord1:
        def __get__(self):
            self.MassErrord1_branch.GetEntry(self.localentry, 0)
            return self.MassErrord1_value

    property MassErrord2:
        def __get__(self):
            self.MassErrord2_branch.GetEntry(self.localentry, 0)
            return self.MassErrord2_value

    property MassErrord3:
        def __get__(self):
            self.MassErrord3_branch.GetEntry(self.localentry, 0)
            return self.MassErrord3_value

    property MassErrord4:
        def __get__(self):
            self.MassErrord4_branch.GetEntry(self.localentry, 0)
            return self.MassErrord4_value

    property Mt:
        def __get__(self):
            self.Mt_branch.GetEntry(self.localentry, 0)
            return self.Mt_value

    property NUP:
        def __get__(self):
            self.NUP_branch.GetEntry(self.localentry, 0)
            return self.NUP_value

    property Phi:
        def __get__(self):
            self.Phi_branch.GetEntry(self.localentry, 0)
            return self.Phi_value

    property Pt:
        def __get__(self):
            self.Pt_branch.GetEntry(self.localentry, 0)
            return self.Pt_value

    property bjetCISVVeto20Loose:
        def __get__(self):
            self.bjetCISVVeto20Loose_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto20Loose_value

    property bjetCISVVeto20Medium:
        def __get__(self):
            self.bjetCISVVeto20Medium_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto20Medium_value

    property bjetCISVVeto20Tight:
        def __get__(self):
            self.bjetCISVVeto20Tight_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto20Tight_value

    property bjetCISVVeto30Loose:
        def __get__(self):
            self.bjetCISVVeto30Loose_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto30Loose_value

    property bjetCISVVeto30Medium:
        def __get__(self):
            self.bjetCISVVeto30Medium_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto30Medium_value

    property bjetCISVVeto30Tight:
        def __get__(self):
            self.bjetCISVVeto30Tight_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto30Tight_value

    property charge:
        def __get__(self):
            self.charge_branch.GetEntry(self.localentry, 0)
            return self.charge_value

    property doubleEGroup:
        def __get__(self):
            self.doubleEGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleEGroup_value

    property doubleEPass:
        def __get__(self):
            self.doubleEPass_branch.GetEntry(self.localentry, 0)
            return self.doubleEPass_value

    property doubleEPrescale:
        def __get__(self):
            self.doubleEPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleEPrescale_value

    property doubleESingleMuGroup:
        def __get__(self):
            self.doubleESingleMuGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleESingleMuGroup_value

    property doubleESingleMuPass:
        def __get__(self):
            self.doubleESingleMuPass_branch.GetEntry(self.localentry, 0)
            return self.doubleESingleMuPass_value

    property doubleESingleMuPrescale:
        def __get__(self):
            self.doubleESingleMuPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleESingleMuPrescale_value

    property doubleE_23_12Group:
        def __get__(self):
            self.doubleE_23_12Group_branch.GetEntry(self.localentry, 0)
            return self.doubleE_23_12Group_value

    property doubleE_23_12Pass:
        def __get__(self):
            self.doubleE_23_12Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleE_23_12Pass_value

    property doubleE_23_12Prescale:
        def __get__(self):
            self.doubleE_23_12Prescale_branch.GetEntry(self.localentry, 0)
            return self.doubleE_23_12Prescale_value

    property doubleMuGroup:
        def __get__(self):
            self.doubleMuGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleMuGroup_value

    property doubleMuPass:
        def __get__(self):
            self.doubleMuPass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuPass_value

    property doubleMuPrescale:
        def __get__(self):
            self.doubleMuPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleMuPrescale_value

    property doubleMuSingleEGroup:
        def __get__(self):
            self.doubleMuSingleEGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleMuSingleEGroup_value

    property doubleMuSingleEPass:
        def __get__(self):
            self.doubleMuSingleEPass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuSingleEPass_value

    property doubleMuSingleEPrescale:
        def __get__(self):
            self.doubleMuSingleEPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleMuSingleEPrescale_value

    property doubleTau32Group:
        def __get__(self):
            self.doubleTau32Group_branch.GetEntry(self.localentry, 0)
            return self.doubleTau32Group_value

    property doubleTau32Pass:
        def __get__(self):
            self.doubleTau32Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleTau32Pass_value

    property doubleTau32Prescale:
        def __get__(self):
            self.doubleTau32Prescale_branch.GetEntry(self.localentry, 0)
            return self.doubleTau32Prescale_value

    property doubleTau35Group:
        def __get__(self):
            self.doubleTau35Group_branch.GetEntry(self.localentry, 0)
            return self.doubleTau35Group_value

    property doubleTau35Pass:
        def __get__(self):
            self.doubleTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleTau35Pass_value

    property doubleTau35Prescale:
        def __get__(self):
            self.doubleTau35Prescale_branch.GetEntry(self.localentry, 0)
            return self.doubleTau35Prescale_value

    property doubleTau40Group:
        def __get__(self):
            self.doubleTau40Group_branch.GetEntry(self.localentry, 0)
            return self.doubleTau40Group_value

    property doubleTau40Pass:
        def __get__(self):
            self.doubleTau40Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleTau40Pass_value

    property doubleTau40Prescale:
        def __get__(self):
            self.doubleTau40Prescale_branch.GetEntry(self.localentry, 0)
            return self.doubleTau40Prescale_value

    property eVetoMVAIso:
        def __get__(self):
            self.eVetoMVAIso_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIso_value

    property eVetoMVAIsoVtx:
        def __get__(self):
            self.eVetoMVAIsoVtx_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIsoVtx_value

    property evt:
        def __get__(self):
            self.evt_branch.GetEntry(self.localentry, 0)
            return self.evt_value

    property genHTT:
        def __get__(self):
            self.genHTT_branch.GetEntry(self.localentry, 0)
            return self.genHTT_value

    property isGtautau:
        def __get__(self):
            self.isGtautau_branch.GetEntry(self.localentry, 0)
            return self.isGtautau_value

    property isWmunu:
        def __get__(self):
            self.isWmunu_branch.GetEntry(self.localentry, 0)
            return self.isWmunu_value

    property isWtaunu:
        def __get__(self):
            self.isWtaunu_branch.GetEntry(self.localentry, 0)
            return self.isWtaunu_value

    property isZee:
        def __get__(self):
            self.isZee_branch.GetEntry(self.localentry, 0)
            return self.isZee_value

    property isZmumu:
        def __get__(self):
            self.isZmumu_branch.GetEntry(self.localentry, 0)
            return self.isZmumu_value

    property isZtautau:
        def __get__(self):
            self.isZtautau_branch.GetEntry(self.localentry, 0)
            return self.isZtautau_value

    property isdata:
        def __get__(self):
            self.isdata_branch.GetEntry(self.localentry, 0)
            return self.isdata_value

    property jet1BJetCISV:
        def __get__(self):
            self.jet1BJetCISV_branch.GetEntry(self.localentry, 0)
            return self.jet1BJetCISV_value

    property jet1Eta:
        def __get__(self):
            self.jet1Eta_branch.GetEntry(self.localentry, 0)
            return self.jet1Eta_value

    property jet1IDLoose:
        def __get__(self):
            self.jet1IDLoose_branch.GetEntry(self.localentry, 0)
            return self.jet1IDLoose_value

    property jet1IDTight:
        def __get__(self):
            self.jet1IDTight_branch.GetEntry(self.localentry, 0)
            return self.jet1IDTight_value

    property jet1IDTightLepVeto:
        def __get__(self):
            self.jet1IDTightLepVeto_branch.GetEntry(self.localentry, 0)
            return self.jet1IDTightLepVeto_value

    property jet1PUMVA:
        def __get__(self):
            self.jet1PUMVA_branch.GetEntry(self.localentry, 0)
            return self.jet1PUMVA_value

    property jet1Phi:
        def __get__(self):
            self.jet1Phi_branch.GetEntry(self.localentry, 0)
            return self.jet1Phi_value

    property jet1Pt:
        def __get__(self):
            self.jet1Pt_branch.GetEntry(self.localentry, 0)
            return self.jet1Pt_value

    property jet2BJetCISV:
        def __get__(self):
            self.jet2BJetCISV_branch.GetEntry(self.localentry, 0)
            return self.jet2BJetCISV_value

    property jet2Eta:
        def __get__(self):
            self.jet2Eta_branch.GetEntry(self.localentry, 0)
            return self.jet2Eta_value

    property jet2IDLoose:
        def __get__(self):
            self.jet2IDLoose_branch.GetEntry(self.localentry, 0)
            return self.jet2IDLoose_value

    property jet2IDTight:
        def __get__(self):
            self.jet2IDTight_branch.GetEntry(self.localentry, 0)
            return self.jet2IDTight_value

    property jet2IDTightLepVeto:
        def __get__(self):
            self.jet2IDTightLepVeto_branch.GetEntry(self.localentry, 0)
            return self.jet2IDTightLepVeto_value

    property jet2PUMVA:
        def __get__(self):
            self.jet2PUMVA_branch.GetEntry(self.localentry, 0)
            return self.jet2PUMVA_value

    property jet2Phi:
        def __get__(self):
            self.jet2Phi_branch.GetEntry(self.localentry, 0)
            return self.jet2Phi_value

    property jet2Pt:
        def __get__(self):
            self.jet2Pt_branch.GetEntry(self.localentry, 0)
            return self.jet2Pt_value

    property jet3BJetCISV:
        def __get__(self):
            self.jet3BJetCISV_branch.GetEntry(self.localentry, 0)
            return self.jet3BJetCISV_value

    property jet3Eta:
        def __get__(self):
            self.jet3Eta_branch.GetEntry(self.localentry, 0)
            return self.jet3Eta_value

    property jet3IDLoose:
        def __get__(self):
            self.jet3IDLoose_branch.GetEntry(self.localentry, 0)
            return self.jet3IDLoose_value

    property jet3IDTight:
        def __get__(self):
            self.jet3IDTight_branch.GetEntry(self.localentry, 0)
            return self.jet3IDTight_value

    property jet3IDTightLepVeto:
        def __get__(self):
            self.jet3IDTightLepVeto_branch.GetEntry(self.localentry, 0)
            return self.jet3IDTightLepVeto_value

    property jet3PUMVA:
        def __get__(self):
            self.jet3PUMVA_branch.GetEntry(self.localentry, 0)
            return self.jet3PUMVA_value

    property jet3Phi:
        def __get__(self):
            self.jet3Phi_branch.GetEntry(self.localentry, 0)
            return self.jet3Phi_value

    property jet3Pt:
        def __get__(self):
            self.jet3Pt_branch.GetEntry(self.localentry, 0)
            return self.jet3Pt_value

    property jet4BJetCISV:
        def __get__(self):
            self.jet4BJetCISV_branch.GetEntry(self.localentry, 0)
            return self.jet4BJetCISV_value

    property jet4Eta:
        def __get__(self):
            self.jet4Eta_branch.GetEntry(self.localentry, 0)
            return self.jet4Eta_value

    property jet4IDLoose:
        def __get__(self):
            self.jet4IDLoose_branch.GetEntry(self.localentry, 0)
            return self.jet4IDLoose_value

    property jet4IDTight:
        def __get__(self):
            self.jet4IDTight_branch.GetEntry(self.localentry, 0)
            return self.jet4IDTight_value

    property jet4IDTightLepVeto:
        def __get__(self):
            self.jet4IDTightLepVeto_branch.GetEntry(self.localentry, 0)
            return self.jet4IDTightLepVeto_value

    property jet4PUMVA:
        def __get__(self):
            self.jet4PUMVA_branch.GetEntry(self.localentry, 0)
            return self.jet4PUMVA_value

    property jet4Phi:
        def __get__(self):
            self.jet4Phi_branch.GetEntry(self.localentry, 0)
            return self.jet4Phi_value

    property jet4Pt:
        def __get__(self):
            self.jet4Pt_branch.GetEntry(self.localentry, 0)
            return self.jet4Pt_value

    property jet5BJetCISV:
        def __get__(self):
            self.jet5BJetCISV_branch.GetEntry(self.localentry, 0)
            return self.jet5BJetCISV_value

    property jet5Eta:
        def __get__(self):
            self.jet5Eta_branch.GetEntry(self.localentry, 0)
            return self.jet5Eta_value

    property jet5IDLoose:
        def __get__(self):
            self.jet5IDLoose_branch.GetEntry(self.localentry, 0)
            return self.jet5IDLoose_value

    property jet5IDTight:
        def __get__(self):
            self.jet5IDTight_branch.GetEntry(self.localentry, 0)
            return self.jet5IDTight_value

    property jet5IDTightLepVeto:
        def __get__(self):
            self.jet5IDTightLepVeto_branch.GetEntry(self.localentry, 0)
            return self.jet5IDTightLepVeto_value

    property jet5PUMVA:
        def __get__(self):
            self.jet5PUMVA_branch.GetEntry(self.localentry, 0)
            return self.jet5PUMVA_value

    property jet5Phi:
        def __get__(self):
            self.jet5Phi_branch.GetEntry(self.localentry, 0)
            return self.jet5Phi_value

    property jet5Pt:
        def __get__(self):
            self.jet5Pt_branch.GetEntry(self.localentry, 0)
            return self.jet5Pt_value

    property jet6BJetCISV:
        def __get__(self):
            self.jet6BJetCISV_branch.GetEntry(self.localentry, 0)
            return self.jet6BJetCISV_value

    property jet6Eta:
        def __get__(self):
            self.jet6Eta_branch.GetEntry(self.localentry, 0)
            return self.jet6Eta_value

    property jet6IDLoose:
        def __get__(self):
            self.jet6IDLoose_branch.GetEntry(self.localentry, 0)
            return self.jet6IDLoose_value

    property jet6IDTight:
        def __get__(self):
            self.jet6IDTight_branch.GetEntry(self.localentry, 0)
            return self.jet6IDTight_value

    property jet6IDTightLepVeto:
        def __get__(self):
            self.jet6IDTightLepVeto_branch.GetEntry(self.localentry, 0)
            return self.jet6IDTightLepVeto_value

    property jet6PUMVA:
        def __get__(self):
            self.jet6PUMVA_branch.GetEntry(self.localentry, 0)
            return self.jet6PUMVA_value

    property jet6Phi:
        def __get__(self):
            self.jet6Phi_branch.GetEntry(self.localentry, 0)
            return self.jet6Phi_value

    property jet6Pt:
        def __get__(self):
            self.jet6Pt_branch.GetEntry(self.localentry, 0)
            return self.jet6Pt_value

    property jetVeto20:
        def __get__(self):
            self.jetVeto20_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_value

    property jetVeto20_DR05:
        def __get__(self):
            self.jetVeto20_DR05_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_DR05_value

    property jetVeto30:
        def __get__(self):
            self.jetVeto30_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_value

    property jetVeto30Eta3:
        def __get__(self):
            self.jetVeto30Eta3_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30Eta3_value

    property jetVeto30Eta3_JetEnDown:
        def __get__(self):
            self.jetVeto30Eta3_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30Eta3_JetEnDown_value

    property jetVeto30Eta3_JetEnUp:
        def __get__(self):
            self.jetVeto30Eta3_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30Eta3_JetEnUp_value

    property jetVeto30_DR05:
        def __get__(self):
            self.jetVeto30_DR05_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_DR05_value

    property jetVeto30_JetEnDown:
        def __get__(self):
            self.jetVeto30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnDown_value

    property jetVeto30_JetEnUp:
        def __get__(self):
            self.jetVeto30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnUp_value

    property jetVeto40:
        def __get__(self):
            self.jetVeto40_branch.GetEntry(self.localentry, 0)
            return self.jetVeto40_value

    property jetVeto40_DR05:
        def __get__(self):
            self.jetVeto40_DR05_branch.GetEntry(self.localentry, 0)
            return self.jetVeto40_DR05_value

    property lumi:
        def __get__(self):
            self.lumi_branch.GetEntry(self.localentry, 0)
            return self.lumi_value

    property mAbsEta:
        def __get__(self):
            self.mAbsEta_branch.GetEntry(self.localentry, 0)
            return self.mAbsEta_value

    property mBestTrackType:
        def __get__(self):
            self.mBestTrackType_branch.GetEntry(self.localentry, 0)
            return self.mBestTrackType_value

    property mCharge:
        def __get__(self):
            self.mCharge_branch.GetEntry(self.localentry, 0)
            return self.mCharge_value

    property mComesFromHiggs:
        def __get__(self):
            self.mComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.mComesFromHiggs_value

    property mDPhiToPfMet_ElectronEnDown:
        def __get__(self):
            self.mDPhiToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_ElectronEnDown_value

    property mDPhiToPfMet_ElectronEnUp:
        def __get__(self):
            self.mDPhiToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_ElectronEnUp_value

    property mDPhiToPfMet_JetEnDown:
        def __get__(self):
            self.mDPhiToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_JetEnDown_value

    property mDPhiToPfMet_JetEnUp:
        def __get__(self):
            self.mDPhiToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_JetEnUp_value

    property mDPhiToPfMet_JetResDown:
        def __get__(self):
            self.mDPhiToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_JetResDown_value

    property mDPhiToPfMet_JetResUp:
        def __get__(self):
            self.mDPhiToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_JetResUp_value

    property mDPhiToPfMet_MuonEnDown:
        def __get__(self):
            self.mDPhiToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_MuonEnDown_value

    property mDPhiToPfMet_MuonEnUp:
        def __get__(self):
            self.mDPhiToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_MuonEnUp_value

    property mDPhiToPfMet_PhotonEnDown:
        def __get__(self):
            self.mDPhiToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_PhotonEnDown_value

    property mDPhiToPfMet_PhotonEnUp:
        def __get__(self):
            self.mDPhiToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_PhotonEnUp_value

    property mDPhiToPfMet_TauEnDown:
        def __get__(self):
            self.mDPhiToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_TauEnDown_value

    property mDPhiToPfMet_TauEnUp:
        def __get__(self):
            self.mDPhiToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_TauEnUp_value

    property mDPhiToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.mDPhiToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_UnclusteredEnDown_value

    property mDPhiToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.mDPhiToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_UnclusteredEnUp_value

    property mDPhiToPfMet_type1:
        def __get__(self):
            self.mDPhiToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.mDPhiToPfMet_type1_value

    property mEcalIsoDR03:
        def __get__(self):
            self.mEcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.mEcalIsoDR03_value

    property mEffectiveArea2011:
        def __get__(self):
            self.mEffectiveArea2011_branch.GetEntry(self.localentry, 0)
            return self.mEffectiveArea2011_value

    property mEffectiveArea2012:
        def __get__(self):
            self.mEffectiveArea2012_branch.GetEntry(self.localentry, 0)
            return self.mEffectiveArea2012_value

    property mEta:
        def __get__(self):
            self.mEta_branch.GetEntry(self.localentry, 0)
            return self.mEta_value

    property mEta_MuonEnDown:
        def __get__(self):
            self.mEta_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.mEta_MuonEnDown_value

    property mEta_MuonEnUp:
        def __get__(self):
            self.mEta_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.mEta_MuonEnUp_value

    property mGenCharge:
        def __get__(self):
            self.mGenCharge_branch.GetEntry(self.localentry, 0)
            return self.mGenCharge_value

    property mGenEnergy:
        def __get__(self):
            self.mGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.mGenEnergy_value

    property mGenEta:
        def __get__(self):
            self.mGenEta_branch.GetEntry(self.localentry, 0)
            return self.mGenEta_value

    property mGenMotherPdgId:
        def __get__(self):
            self.mGenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.mGenMotherPdgId_value

    property mGenParticle:
        def __get__(self):
            self.mGenParticle_branch.GetEntry(self.localentry, 0)
            return self.mGenParticle_value

    property mGenPdgId:
        def __get__(self):
            self.mGenPdgId_branch.GetEntry(self.localentry, 0)
            return self.mGenPdgId_value

    property mGenPhi:
        def __get__(self):
            self.mGenPhi_branch.GetEntry(self.localentry, 0)
            return self.mGenPhi_value

    property mGenPrompt:
        def __get__(self):
            self.mGenPrompt_branch.GetEntry(self.localentry, 0)
            return self.mGenPrompt_value

    property mGenPromptTauDecay:
        def __get__(self):
            self.mGenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.mGenPromptTauDecay_value

    property mGenPt:
        def __get__(self):
            self.mGenPt_branch.GetEntry(self.localentry, 0)
            return self.mGenPt_value

    property mGenTauDecay:
        def __get__(self):
            self.mGenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.mGenTauDecay_value

    property mGenVZ:
        def __get__(self):
            self.mGenVZ_branch.GetEntry(self.localentry, 0)
            return self.mGenVZ_value

    property mGenVtxPVMatch:
        def __get__(self):
            self.mGenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.mGenVtxPVMatch_value

    property mHcalIsoDR03:
        def __get__(self):
            self.mHcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.mHcalIsoDR03_value

    property mIP3D:
        def __get__(self):
            self.mIP3D_branch.GetEntry(self.localentry, 0)
            return self.mIP3D_value

    property mIP3DErr:
        def __get__(self):
            self.mIP3DErr_branch.GetEntry(self.localentry, 0)
            return self.mIP3DErr_value

    property mIsGlobal:
        def __get__(self):
            self.mIsGlobal_branch.GetEntry(self.localentry, 0)
            return self.mIsGlobal_value

    property mIsPFMuon:
        def __get__(self):
            self.mIsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.mIsPFMuon_value

    property mIsTracker:
        def __get__(self):
            self.mIsTracker_branch.GetEntry(self.localentry, 0)
            return self.mIsTracker_value

    property mJetArea:
        def __get__(self):
            self.mJetArea_branch.GetEntry(self.localentry, 0)
            return self.mJetArea_value

    property mJetBtag:
        def __get__(self):
            self.mJetBtag_branch.GetEntry(self.localentry, 0)
            return self.mJetBtag_value

    property mJetEtaEtaMoment:
        def __get__(self):
            self.mJetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.mJetEtaEtaMoment_value

    property mJetEtaPhiMoment:
        def __get__(self):
            self.mJetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.mJetEtaPhiMoment_value

    property mJetEtaPhiSpread:
        def __get__(self):
            self.mJetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.mJetEtaPhiSpread_value

    property mJetPFCISVBtag:
        def __get__(self):
            self.mJetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.mJetPFCISVBtag_value

    property mJetPartonFlavour:
        def __get__(self):
            self.mJetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.mJetPartonFlavour_value

    property mJetPhiPhiMoment:
        def __get__(self):
            self.mJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.mJetPhiPhiMoment_value

    property mJetPt:
        def __get__(self):
            self.mJetPt_branch.GetEntry(self.localentry, 0)
            return self.mJetPt_value

    property mLowestMll:
        def __get__(self):
            self.mLowestMll_branch.GetEntry(self.localentry, 0)
            return self.mLowestMll_value

    property mMass:
        def __get__(self):
            self.mMass_branch.GetEntry(self.localentry, 0)
            return self.mMass_value

    property mMatchedStations:
        def __get__(self):
            self.mMatchedStations_branch.GetEntry(self.localentry, 0)
            return self.mMatchedStations_value

    property mMatchesDoubleESingleMu:
        def __get__(self):
            self.mMatchesDoubleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.mMatchesDoubleESingleMu_value

    property mMatchesDoubleMu:
        def __get__(self):
            self.mMatchesDoubleMu_branch.GetEntry(self.localentry, 0)
            return self.mMatchesDoubleMu_value

    property mMatchesDoubleMuSingleE:
        def __get__(self):
            self.mMatchesDoubleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.mMatchesDoubleMuSingleE_value

    property mMatchesSingleESingleMu:
        def __get__(self):
            self.mMatchesSingleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.mMatchesSingleESingleMu_value

    property mMatchesSingleMu:
        def __get__(self):
            self.mMatchesSingleMu_branch.GetEntry(self.localentry, 0)
            return self.mMatchesSingleMu_value

    property mMatchesSingleMuIso20:
        def __get__(self):
            self.mMatchesSingleMuIso20_branch.GetEntry(self.localentry, 0)
            return self.mMatchesSingleMuIso20_value

    property mMatchesSingleMuIsoTk20:
        def __get__(self):
            self.mMatchesSingleMuIsoTk20_branch.GetEntry(self.localentry, 0)
            return self.mMatchesSingleMuIsoTk20_value

    property mMatchesSingleMuSingleE:
        def __get__(self):
            self.mMatchesSingleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.mMatchesSingleMuSingleE_value

    property mMatchesSingleMu_leg1:
        def __get__(self):
            self.mMatchesSingleMu_leg1_branch.GetEntry(self.localentry, 0)
            return self.mMatchesSingleMu_leg1_value

    property mMatchesSingleMu_leg1_noiso:
        def __get__(self):
            self.mMatchesSingleMu_leg1_noiso_branch.GetEntry(self.localentry, 0)
            return self.mMatchesSingleMu_leg1_noiso_value

    property mMatchesSingleMu_leg2:
        def __get__(self):
            self.mMatchesSingleMu_leg2_branch.GetEntry(self.localentry, 0)
            return self.mMatchesSingleMu_leg2_value

    property mMatchesSingleMu_leg2_noiso:
        def __get__(self):
            self.mMatchesSingleMu_leg2_noiso_branch.GetEntry(self.localentry, 0)
            return self.mMatchesSingleMu_leg2_noiso_value

    property mMatchesTripleMu:
        def __get__(self):
            self.mMatchesTripleMu_branch.GetEntry(self.localentry, 0)
            return self.mMatchesTripleMu_value

    property mMtToPfMet_ElectronEnDown:
        def __get__(self):
            self.mMtToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_ElectronEnDown_value

    property mMtToPfMet_ElectronEnUp:
        def __get__(self):
            self.mMtToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_ElectronEnUp_value

    property mMtToPfMet_JetEnDown:
        def __get__(self):
            self.mMtToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_JetEnDown_value

    property mMtToPfMet_JetEnUp:
        def __get__(self):
            self.mMtToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_JetEnUp_value

    property mMtToPfMet_JetResDown:
        def __get__(self):
            self.mMtToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_JetResDown_value

    property mMtToPfMet_JetResUp:
        def __get__(self):
            self.mMtToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_JetResUp_value

    property mMtToPfMet_MuonEnDown:
        def __get__(self):
            self.mMtToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_MuonEnDown_value

    property mMtToPfMet_MuonEnUp:
        def __get__(self):
            self.mMtToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_MuonEnUp_value

    property mMtToPfMet_PhotonEnDown:
        def __get__(self):
            self.mMtToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_PhotonEnDown_value

    property mMtToPfMet_PhotonEnUp:
        def __get__(self):
            self.mMtToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_PhotonEnUp_value

    property mMtToPfMet_Raw:
        def __get__(self):
            self.mMtToPfMet_Raw_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_Raw_value

    property mMtToPfMet_TauEnDown:
        def __get__(self):
            self.mMtToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_TauEnDown_value

    property mMtToPfMet_TauEnUp:
        def __get__(self):
            self.mMtToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_TauEnUp_value

    property mMtToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.mMtToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_UnclusteredEnDown_value

    property mMtToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.mMtToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_UnclusteredEnUp_value

    property mMtToPfMet_type1:
        def __get__(self):
            self.mMtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.mMtToPfMet_type1_value

    property mMuonHits:
        def __get__(self):
            self.mMuonHits_branch.GetEntry(self.localentry, 0)
            return self.mMuonHits_value

    property mNearestZMass:
        def __get__(self):
            self.mNearestZMass_branch.GetEntry(self.localentry, 0)
            return self.mNearestZMass_value

    property mNormTrkChi2:
        def __get__(self):
            self.mNormTrkChi2_branch.GetEntry(self.localentry, 0)
            return self.mNormTrkChi2_value

    property mPFChargedHadronIsoR04:
        def __get__(self):
            self.mPFChargedHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.mPFChargedHadronIsoR04_value

    property mPFChargedIso:
        def __get__(self):
            self.mPFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.mPFChargedIso_value

    property mPFIDLoose:
        def __get__(self):
            self.mPFIDLoose_branch.GetEntry(self.localentry, 0)
            return self.mPFIDLoose_value

    property mPFIDMedium:
        def __get__(self):
            self.mPFIDMedium_branch.GetEntry(self.localentry, 0)
            return self.mPFIDMedium_value

    property mPFIDTight:
        def __get__(self):
            self.mPFIDTight_branch.GetEntry(self.localentry, 0)
            return self.mPFIDTight_value

    property mPFNeutralHadronIsoR04:
        def __get__(self):
            self.mPFNeutralHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.mPFNeutralHadronIsoR04_value

    property mPFNeutralIso:
        def __get__(self):
            self.mPFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.mPFNeutralIso_value

    property mPFPUChargedIso:
        def __get__(self):
            self.mPFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.mPFPUChargedIso_value

    property mPFPhotonIso:
        def __get__(self):
            self.mPFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.mPFPhotonIso_value

    property mPFPhotonIsoR04:
        def __get__(self):
            self.mPFPhotonIsoR04_branch.GetEntry(self.localentry, 0)
            return self.mPFPhotonIsoR04_value

    property mPFPileupIsoR04:
        def __get__(self):
            self.mPFPileupIsoR04_branch.GetEntry(self.localentry, 0)
            return self.mPFPileupIsoR04_value

    property mPVDXY:
        def __get__(self):
            self.mPVDXY_branch.GetEntry(self.localentry, 0)
            return self.mPVDXY_value

    property mPVDZ:
        def __get__(self):
            self.mPVDZ_branch.GetEntry(self.localentry, 0)
            return self.mPVDZ_value

    property mPhi:
        def __get__(self):
            self.mPhi_branch.GetEntry(self.localentry, 0)
            return self.mPhi_value

    property mPhi_MuonEnDown:
        def __get__(self):
            self.mPhi_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.mPhi_MuonEnDown_value

    property mPhi_MuonEnUp:
        def __get__(self):
            self.mPhi_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.mPhi_MuonEnUp_value

    property mPixHits:
        def __get__(self):
            self.mPixHits_branch.GetEntry(self.localentry, 0)
            return self.mPixHits_value

    property mPt:
        def __get__(self):
            self.mPt_branch.GetEntry(self.localentry, 0)
            return self.mPt_value

    property mPt_MuonEnDown:
        def __get__(self):
            self.mPt_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.mPt_MuonEnDown_value

    property mPt_MuonEnUp:
        def __get__(self):
            self.mPt_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.mPt_MuonEnUp_value

    property mRank:
        def __get__(self):
            self.mRank_branch.GetEntry(self.localentry, 0)
            return self.mRank_value

    property mRelPFIsoDBDefault:
        def __get__(self):
            self.mRelPFIsoDBDefault_branch.GetEntry(self.localentry, 0)
            return self.mRelPFIsoDBDefault_value

    property mRelPFIsoDBDefaultR04:
        def __get__(self):
            self.mRelPFIsoDBDefaultR04_branch.GetEntry(self.localentry, 0)
            return self.mRelPFIsoDBDefaultR04_value

    property mRelPFIsoRho:
        def __get__(self):
            self.mRelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.mRelPFIsoRho_value

    property mRho:
        def __get__(self):
            self.mRho_branch.GetEntry(self.localentry, 0)
            return self.mRho_value

    property mSIP2D:
        def __get__(self):
            self.mSIP2D_branch.GetEntry(self.localentry, 0)
            return self.mSIP2D_value

    property mSIP3D:
        def __get__(self):
            self.mSIP3D_branch.GetEntry(self.localentry, 0)
            return self.mSIP3D_value

    property mTkLayersWithMeasurement:
        def __get__(self):
            self.mTkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.mTkLayersWithMeasurement_value

    property mTrkIsoDR03:
        def __get__(self):
            self.mTrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.mTrkIsoDR03_value

    property mTypeCode:
        def __get__(self):
            self.mTypeCode_branch.GetEntry(self.localentry, 0)
            return self.mTypeCode_value

    property mVZ:
        def __get__(self):
            self.mVZ_branch.GetEntry(self.localentry, 0)
            return self.mVZ_value

    property m_t_CosThetaStar:
        def __get__(self):
            self.m_t_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m_t_CosThetaStar_value

    property m_t_DPhi:
        def __get__(self):
            self.m_t_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m_t_DPhi_value

    property m_t_DR:
        def __get__(self):
            self.m_t_DR_branch.GetEntry(self.localentry, 0)
            return self.m_t_DR_value

    property m_t_Eta:
        def __get__(self):
            self.m_t_Eta_branch.GetEntry(self.localentry, 0)
            return self.m_t_Eta_value

    property m_t_Mass:
        def __get__(self):
            self.m_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.m_t_Mass_value

    property m_t_Mass_TauEnDown:
        def __get__(self):
            self.m_t_Mass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m_t_Mass_TauEnDown_value

    property m_t_Mass_TauEnUp:
        def __get__(self):
            self.m_t_Mass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m_t_Mass_TauEnUp_value

    property m_t_Mt:
        def __get__(self):
            self.m_t_Mt_branch.GetEntry(self.localentry, 0)
            return self.m_t_Mt_value

    property m_t_Mt_TauEnDown:
        def __get__(self):
            self.m_t_Mt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m_t_Mt_TauEnDown_value

    property m_t_Mt_TauEnUp:
        def __get__(self):
            self.m_t_Mt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m_t_Mt_TauEnUp_value

    property m_t_PZeta:
        def __get__(self):
            self.m_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m_t_PZeta_value

    property m_t_PZetaVis:
        def __get__(self):
            self.m_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m_t_PZetaVis_value

    property m_t_Phi:
        def __get__(self):
            self.m_t_Phi_branch.GetEntry(self.localentry, 0)
            return self.m_t_Phi_value

    property m_t_Pt:
        def __get__(self):
            self.m_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.m_t_Pt_value

    property m_t_SS:
        def __get__(self):
            self.m_t_SS_branch.GetEntry(self.localentry, 0)
            return self.m_t_SS_value

    property m_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.m_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m_t_ToMETDPhi_Ty1_value

    property m_t_collinearmass:
        def __get__(self):
            self.m_t_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_value

    property m_t_collinearmass_JetEnDown:
        def __get__(self):
            self.m_t_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_JetEnDown_value

    property m_t_collinearmass_JetEnUp:
        def __get__(self):
            self.m_t_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_JetEnUp_value

    property m_t_collinearmass_TauEnDown:
        def __get__(self):
            self.m_t_collinearmass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_TauEnDown_value

    property m_t_collinearmass_TauEnUp:
        def __get__(self):
            self.m_t_collinearmass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_TauEnUp_value

    property m_t_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.m_t_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_UnclusteredEnDown_value

    property m_t_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.m_t_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_UnclusteredEnUp_value

    property muGlbIsoVetoPt10:
        def __get__(self):
            self.muGlbIsoVetoPt10_branch.GetEntry(self.localentry, 0)
            return self.muGlbIsoVetoPt10_value

    property muVetoPt15IsoIdVtx:
        def __get__(self):
            self.muVetoPt15IsoIdVtx_branch.GetEntry(self.localentry, 0)
            return self.muVetoPt15IsoIdVtx_value

    property muVetoPt5:
        def __get__(self):
            self.muVetoPt5_branch.GetEntry(self.localentry, 0)
            return self.muVetoPt5_value

    property muVetoPt5IsoIdVtx:
        def __get__(self):
            self.muVetoPt5IsoIdVtx_branch.GetEntry(self.localentry, 0)
            return self.muVetoPt5IsoIdVtx_value

    property nTruePU:
        def __get__(self):
            self.nTruePU_branch.GetEntry(self.localentry, 0)
            return self.nTruePU_value

    property nvtx:
        def __get__(self):
            self.nvtx_branch.GetEntry(self.localentry, 0)
            return self.nvtx_value

    property processID:
        def __get__(self):
            self.processID_branch.GetEntry(self.localentry, 0)
            return self.processID_value

    property pvChi2:
        def __get__(self):
            self.pvChi2_branch.GetEntry(self.localentry, 0)
            return self.pvChi2_value

    property pvDX:
        def __get__(self):
            self.pvDX_branch.GetEntry(self.localentry, 0)
            return self.pvDX_value

    property pvDY:
        def __get__(self):
            self.pvDY_branch.GetEntry(self.localentry, 0)
            return self.pvDY_value

    property pvDZ:
        def __get__(self):
            self.pvDZ_branch.GetEntry(self.localentry, 0)
            return self.pvDZ_value

    property pvIsFake:
        def __get__(self):
            self.pvIsFake_branch.GetEntry(self.localentry, 0)
            return self.pvIsFake_value

    property pvIsValid:
        def __get__(self):
            self.pvIsValid_branch.GetEntry(self.localentry, 0)
            return self.pvIsValid_value

    property pvNormChi2:
        def __get__(self):
            self.pvNormChi2_branch.GetEntry(self.localentry, 0)
            return self.pvNormChi2_value

    property pvRho:
        def __get__(self):
            self.pvRho_branch.GetEntry(self.localentry, 0)
            return self.pvRho_value

    property pvX:
        def __get__(self):
            self.pvX_branch.GetEntry(self.localentry, 0)
            return self.pvX_value

    property pvY:
        def __get__(self):
            self.pvY_branch.GetEntry(self.localentry, 0)
            return self.pvY_value

    property pvZ:
        def __get__(self):
            self.pvZ_branch.GetEntry(self.localentry, 0)
            return self.pvZ_value

    property pvndof:
        def __get__(self):
            self.pvndof_branch.GetEntry(self.localentry, 0)
            return self.pvndof_value

    property raw_pfMetEt:
        def __get__(self):
            self.raw_pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.raw_pfMetEt_value

    property raw_pfMetPhi:
        def __get__(self):
            self.raw_pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.raw_pfMetPhi_value

    property recoilDaught:
        def __get__(self):
            self.recoilDaught_branch.GetEntry(self.localentry, 0)
            return self.recoilDaught_value

    property recoilWithMet:
        def __get__(self):
            self.recoilWithMet_branch.GetEntry(self.localentry, 0)
            return self.recoilWithMet_value

    property rho:
        def __get__(self):
            self.rho_branch.GetEntry(self.localentry, 0)
            return self.rho_value

    property run:
        def __get__(self):
            self.run_branch.GetEntry(self.localentry, 0)
            return self.run_value

    property singleE17SingleMu8Group:
        def __get__(self):
            self.singleE17SingleMu8Group_branch.GetEntry(self.localentry, 0)
            return self.singleE17SingleMu8Group_value

    property singleE17SingleMu8Pass:
        def __get__(self):
            self.singleE17SingleMu8Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE17SingleMu8Pass_value

    property singleE17SingleMu8Prescale:
        def __get__(self):
            self.singleE17SingleMu8Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE17SingleMu8Prescale_value

    property singleE22eta2p1LooseGroup:
        def __get__(self):
            self.singleE22eta2p1LooseGroup_branch.GetEntry(self.localentry, 0)
            return self.singleE22eta2p1LooseGroup_value

    property singleE22eta2p1LoosePass:
        def __get__(self):
            self.singleE22eta2p1LoosePass_branch.GetEntry(self.localentry, 0)
            return self.singleE22eta2p1LoosePass_value

    property singleE22eta2p1LoosePrescale:
        def __get__(self):
            self.singleE22eta2p1LoosePrescale_branch.GetEntry(self.localentry, 0)
            return self.singleE22eta2p1LoosePrescale_value

    property singleE22eta2p1LooseTau20Group:
        def __get__(self):
            self.singleE22eta2p1LooseTau20Group_branch.GetEntry(self.localentry, 0)
            return self.singleE22eta2p1LooseTau20Group_value

    property singleE22eta2p1LooseTau20Pass:
        def __get__(self):
            self.singleE22eta2p1LooseTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE22eta2p1LooseTau20Pass_value

    property singleE22eta2p1LooseTau20Prescale:
        def __get__(self):
            self.singleE22eta2p1LooseTau20Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE22eta2p1LooseTau20Prescale_value

    property singleE23SingleMu8Group:
        def __get__(self):
            self.singleE23SingleMu8Group_branch.GetEntry(self.localentry, 0)
            return self.singleE23SingleMu8Group_value

    property singleE23SingleMu8Pass:
        def __get__(self):
            self.singleE23SingleMu8Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE23SingleMu8Pass_value

    property singleE23SingleMu8Prescale:
        def __get__(self):
            self.singleE23SingleMu8Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE23SingleMu8Prescale_value

    property singleE23WPLooseGroup:
        def __get__(self):
            self.singleE23WPLooseGroup_branch.GetEntry(self.localentry, 0)
            return self.singleE23WPLooseGroup_value

    property singleE23WPLoosePass:
        def __get__(self):
            self.singleE23WPLoosePass_branch.GetEntry(self.localentry, 0)
            return self.singleE23WPLoosePass_value

    property singleE23WPLoosePrescale:
        def __get__(self):
            self.singleE23WPLoosePrescale_branch.GetEntry(self.localentry, 0)
            return self.singleE23WPLoosePrescale_value

    property singleE25eta2p1TightGroup:
        def __get__(self):
            self.singleE25eta2p1TightGroup_branch.GetEntry(self.localentry, 0)
            return self.singleE25eta2p1TightGroup_value

    property singleE25eta2p1TightPass:
        def __get__(self):
            self.singleE25eta2p1TightPass_branch.GetEntry(self.localentry, 0)
            return self.singleE25eta2p1TightPass_value

    property singleE25eta2p1TightPrescale:
        def __get__(self):
            self.singleE25eta2p1TightPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleE25eta2p1TightPrescale_value

    property singleEGroup:
        def __get__(self):
            self.singleEGroup_branch.GetEntry(self.localentry, 0)
            return self.singleEGroup_value

    property singleEPass:
        def __get__(self):
            self.singleEPass_branch.GetEntry(self.localentry, 0)
            return self.singleEPass_value

    property singleEPrescale:
        def __get__(self):
            self.singleEPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleEPrescale_value

    property singleESingleMuGroup:
        def __get__(self):
            self.singleESingleMuGroup_branch.GetEntry(self.localentry, 0)
            return self.singleESingleMuGroup_value

    property singleESingleMuPass:
        def __get__(self):
            self.singleESingleMuPass_branch.GetEntry(self.localentry, 0)
            return self.singleESingleMuPass_value

    property singleESingleMuPrescale:
        def __get__(self):
            self.singleESingleMuPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleESingleMuPrescale_value

    property singleE_leg1Group:
        def __get__(self):
            self.singleE_leg1Group_branch.GetEntry(self.localentry, 0)
            return self.singleE_leg1Group_value

    property singleE_leg1Pass:
        def __get__(self):
            self.singleE_leg1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE_leg1Pass_value

    property singleE_leg1Prescale:
        def __get__(self):
            self.singleE_leg1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE_leg1Prescale_value

    property singleE_leg2Group:
        def __get__(self):
            self.singleE_leg2Group_branch.GetEntry(self.localentry, 0)
            return self.singleE_leg2Group_value

    property singleE_leg2Pass:
        def __get__(self):
            self.singleE_leg2Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE_leg2Pass_value

    property singleE_leg2Prescale:
        def __get__(self):
            self.singleE_leg2Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE_leg2Prescale_value

    property singleIsoMu18Group:
        def __get__(self):
            self.singleIsoMu18Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu18Group_value

    property singleIsoMu18Pass:
        def __get__(self):
            self.singleIsoMu18Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu18Pass_value

    property singleIsoMu18Prescale:
        def __get__(self):
            self.singleIsoMu18Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu18Prescale_value

    property singleIsoMu20Group:
        def __get__(self):
            self.singleIsoMu20Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu20Group_value

    property singleIsoMu20Pass:
        def __get__(self):
            self.singleIsoMu20Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu20Pass_value

    property singleIsoMu20Prescale:
        def __get__(self):
            self.singleIsoMu20Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu20Prescale_value

    property singleIsoMu22Group:
        def __get__(self):
            self.singleIsoMu22Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu22Group_value

    property singleIsoMu22Pass:
        def __get__(self):
            self.singleIsoMu22Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu22Pass_value

    property singleIsoMu22Prescale:
        def __get__(self):
            self.singleIsoMu22Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu22Prescale_value

    property singleIsoMu22eta2p1Group:
        def __get__(self):
            self.singleIsoMu22eta2p1Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu22eta2p1Group_value

    property singleIsoMu22eta2p1Pass:
        def __get__(self):
            self.singleIsoMu22eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu22eta2p1Pass_value

    property singleIsoMu22eta2p1Prescale:
        def __get__(self):
            self.singleIsoMu22eta2p1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu22eta2p1Prescale_value

    property singleIsoMu27Group:
        def __get__(self):
            self.singleIsoMu27Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu27Group_value

    property singleIsoMu27Pass:
        def __get__(self):
            self.singleIsoMu27Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu27Pass_value

    property singleIsoMu27Prescale:
        def __get__(self):
            self.singleIsoMu27Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu27Prescale_value

    property singleIsoTkMu20Group:
        def __get__(self):
            self.singleIsoTkMu20Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu20Group_value

    property singleIsoTkMu20Pass:
        def __get__(self):
            self.singleIsoTkMu20Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu20Pass_value

    property singleIsoTkMu20Prescale:
        def __get__(self):
            self.singleIsoTkMu20Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu20Prescale_value

    property singleIsoTkMu22Group:
        def __get__(self):
            self.singleIsoTkMu22Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu22Group_value

    property singleIsoTkMu22Pass:
        def __get__(self):
            self.singleIsoTkMu22Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu22Pass_value

    property singleIsoTkMu22Prescale:
        def __get__(self):
            self.singleIsoTkMu22Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu22Prescale_value

    property singleMu17SingleE12Group:
        def __get__(self):
            self.singleMu17SingleE12Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu17SingleE12Group_value

    property singleMu17SingleE12Pass:
        def __get__(self):
            self.singleMu17SingleE12Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu17SingleE12Pass_value

    property singleMu17SingleE12Prescale:
        def __get__(self):
            self.singleMu17SingleE12Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu17SingleE12Prescale_value

    property singleMu23SingleE12Group:
        def __get__(self):
            self.singleMu23SingleE12Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu23SingleE12Group_value

    property singleMu23SingleE12Pass:
        def __get__(self):
            self.singleMu23SingleE12Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu23SingleE12Pass_value

    property singleMu23SingleE12Prescale:
        def __get__(self):
            self.singleMu23SingleE12Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu23SingleE12Prescale_value

    property singleMuGroup:
        def __get__(self):
            self.singleMuGroup_branch.GetEntry(self.localentry, 0)
            return self.singleMuGroup_value

    property singleMuPass:
        def __get__(self):
            self.singleMuPass_branch.GetEntry(self.localentry, 0)
            return self.singleMuPass_value

    property singleMuPrescale:
        def __get__(self):
            self.singleMuPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleMuPrescale_value

    property singleMuSingleEGroup:
        def __get__(self):
            self.singleMuSingleEGroup_branch.GetEntry(self.localentry, 0)
            return self.singleMuSingleEGroup_value

    property singleMuSingleEPass:
        def __get__(self):
            self.singleMuSingleEPass_branch.GetEntry(self.localentry, 0)
            return self.singleMuSingleEPass_value

    property singleMuSingleEPrescale:
        def __get__(self):
            self.singleMuSingleEPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleMuSingleEPrescale_value

    property singleMu_leg1Group:
        def __get__(self):
            self.singleMu_leg1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg1Group_value

    property singleMu_leg1Pass:
        def __get__(self):
            self.singleMu_leg1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg1Pass_value

    property singleMu_leg1Prescale:
        def __get__(self):
            self.singleMu_leg1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg1Prescale_value

    property singleMu_leg1_noisoGroup:
        def __get__(self):
            self.singleMu_leg1_noisoGroup_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg1_noisoGroup_value

    property singleMu_leg1_noisoPass:
        def __get__(self):
            self.singleMu_leg1_noisoPass_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg1_noisoPass_value

    property singleMu_leg1_noisoPrescale:
        def __get__(self):
            self.singleMu_leg1_noisoPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg1_noisoPrescale_value

    property singleMu_leg2Group:
        def __get__(self):
            self.singleMu_leg2Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg2Group_value

    property singleMu_leg2Pass:
        def __get__(self):
            self.singleMu_leg2Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg2Pass_value

    property singleMu_leg2Prescale:
        def __get__(self):
            self.singleMu_leg2Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg2Prescale_value

    property singleMu_leg2_noisoGroup:
        def __get__(self):
            self.singleMu_leg2_noisoGroup_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg2_noisoGroup_value

    property singleMu_leg2_noisoPass:
        def __get__(self):
            self.singleMu_leg2_noisoPass_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg2_noisoPass_value

    property singleMu_leg2_noisoPrescale:
        def __get__(self):
            self.singleMu_leg2_noisoPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg2_noisoPrescale_value

    property tAbsEta:
        def __get__(self):
            self.tAbsEta_branch.GetEntry(self.localentry, 0)
            return self.tAbsEta_value

    property tAgainstElectronLooseMVA6:
        def __get__(self):
            self.tAgainstElectronLooseMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronLooseMVA6_value

    property tAgainstElectronMVA6Raw:
        def __get__(self):
            self.tAgainstElectronMVA6Raw_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMVA6Raw_value

    property tAgainstElectronMVA6category:
        def __get__(self):
            self.tAgainstElectronMVA6category_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMVA6category_value

    property tAgainstElectronMediumMVA6:
        def __get__(self):
            self.tAgainstElectronMediumMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMediumMVA6_value

    property tAgainstElectronTightMVA6:
        def __get__(self):
            self.tAgainstElectronTightMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronTightMVA6_value

    property tAgainstElectronVLooseMVA6:
        def __get__(self):
            self.tAgainstElectronVLooseMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronVLooseMVA6_value

    property tAgainstElectronVTightMVA6:
        def __get__(self):
            self.tAgainstElectronVTightMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronVTightMVA6_value

    property tAgainstMuonLoose3:
        def __get__(self):
            self.tAgainstMuonLoose3_branch.GetEntry(self.localentry, 0)
            return self.tAgainstMuonLoose3_value

    property tAgainstMuonTight3:
        def __get__(self):
            self.tAgainstMuonTight3_branch.GetEntry(self.localentry, 0)
            return self.tAgainstMuonTight3_value

    property tByCombinedIsolationDeltaBetaCorrRaw3Hits:
        def __get__(self):
            self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch.GetEntry(self.localentry, 0)
            return self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_value

    property tByIsolationMVArun2v1DBdR03oldDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_value

    property tByIsolationMVArun2v1DBnewDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1DBnewDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1DBnewDMwLTraw_value

    property tByIsolationMVArun2v1DBoldDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1DBoldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1DBoldDMwLTraw_value

    property tByIsolationMVArun2v1PWdR03oldDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1PWdR03oldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1PWdR03oldDMwLTraw_value

    property tByIsolationMVArun2v1PWnewDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1PWnewDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1PWnewDMwLTraw_value

    property tByIsolationMVArun2v1PWoldDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1PWoldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1PWoldDMwLTraw_value

    property tByLooseCombinedIsolationDeltaBetaCorr3Hits:
        def __get__(self):
            self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch.GetEntry(self.localentry, 0)
            return self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_value

    property tByLooseIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByLooseIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1DBnewDMwLT_value

    property tByLooseIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1DBoldDMwLT_value

    property tByLooseIsolationMVArun2v1PWdR03oldDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1PWdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1PWdR03oldDMwLT_value

    property tByLooseIsolationMVArun2v1PWnewDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1PWnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1PWnewDMwLT_value

    property tByLooseIsolationMVArun2v1PWoldDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1PWoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1PWoldDMwLT_value

    property tByMediumCombinedIsolationDeltaBetaCorr3Hits:
        def __get__(self):
            self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch.GetEntry(self.localentry, 0)
            return self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_value

    property tByMediumIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByMediumIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1DBnewDMwLT_value

    property tByMediumIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1DBoldDMwLT_value

    property tByMediumIsolationMVArun2v1PWdR03oldDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1PWdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1PWdR03oldDMwLT_value

    property tByMediumIsolationMVArun2v1PWnewDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1PWnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1PWnewDMwLT_value

    property tByMediumIsolationMVArun2v1PWoldDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1PWoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1PWoldDMwLT_value

    property tByPhotonPtSumOutsideSignalCone:
        def __get__(self):
            self.tByPhotonPtSumOutsideSignalCone_branch.GetEntry(self.localentry, 0)
            return self.tByPhotonPtSumOutsideSignalCone_value

    property tByTightCombinedIsolationDeltaBetaCorr3Hits:
        def __get__(self):
            self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch.GetEntry(self.localentry, 0)
            return self.tByTightCombinedIsolationDeltaBetaCorr3Hits_value

    property tByTightIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByTightIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1DBnewDMwLT_value

    property tByTightIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1DBoldDMwLT_value

    property tByTightIsolationMVArun2v1PWdR03oldDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1PWdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1PWdR03oldDMwLT_value

    property tByTightIsolationMVArun2v1PWnewDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1PWnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1PWnewDMwLT_value

    property tByTightIsolationMVArun2v1PWoldDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1PWoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1PWoldDMwLT_value

    property tByVLooseIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByVLooseIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1DBnewDMwLT_value

    property tByVLooseIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1DBoldDMwLT_value

    property tByVLooseIsolationMVArun2v1PWdR03oldDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_value

    property tByVLooseIsolationMVArun2v1PWnewDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1PWnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1PWnewDMwLT_value

    property tByVLooseIsolationMVArun2v1PWoldDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1PWoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1PWoldDMwLT_value

    property tByVTightIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByVTightIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1DBnewDMwLT_value

    property tByVTightIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1DBoldDMwLT_value

    property tByVTightIsolationMVArun2v1PWdR03oldDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1PWdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1PWdR03oldDMwLT_value

    property tByVTightIsolationMVArun2v1PWnewDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1PWnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1PWnewDMwLT_value

    property tByVTightIsolationMVArun2v1PWoldDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1PWoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1PWoldDMwLT_value

    property tByVVTightIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByVVTightIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1DBnewDMwLT_value

    property tByVVTightIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1DBoldDMwLT_value

    property tByVVTightIsolationMVArun2v1PWdR03oldDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_value

    property tByVVTightIsolationMVArun2v1PWnewDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1PWnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1PWnewDMwLT_value

    property tByVVTightIsolationMVArun2v1PWoldDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1PWoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1PWoldDMwLT_value

    property tCharge:
        def __get__(self):
            self.tCharge_branch.GetEntry(self.localentry, 0)
            return self.tCharge_value

    property tChargedIsoPtSum:
        def __get__(self):
            self.tChargedIsoPtSum_branch.GetEntry(self.localentry, 0)
            return self.tChargedIsoPtSum_value

    property tChargedIsoPtSumdR03:
        def __get__(self):
            self.tChargedIsoPtSumdR03_branch.GetEntry(self.localentry, 0)
            return self.tChargedIsoPtSumdR03_value

    property tComesFromHiggs:
        def __get__(self):
            self.tComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.tComesFromHiggs_value

    property tDPhiToPfMet_ElectronEnDown:
        def __get__(self):
            self.tDPhiToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_ElectronEnDown_value

    property tDPhiToPfMet_ElectronEnUp:
        def __get__(self):
            self.tDPhiToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_ElectronEnUp_value

    property tDPhiToPfMet_JetEnDown:
        def __get__(self):
            self.tDPhiToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_JetEnDown_value

    property tDPhiToPfMet_JetEnUp:
        def __get__(self):
            self.tDPhiToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_JetEnUp_value

    property tDPhiToPfMet_JetResDown:
        def __get__(self):
            self.tDPhiToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_JetResDown_value

    property tDPhiToPfMet_JetResUp:
        def __get__(self):
            self.tDPhiToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_JetResUp_value

    property tDPhiToPfMet_MuonEnDown:
        def __get__(self):
            self.tDPhiToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_MuonEnDown_value

    property tDPhiToPfMet_MuonEnUp:
        def __get__(self):
            self.tDPhiToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_MuonEnUp_value

    property tDPhiToPfMet_PhotonEnDown:
        def __get__(self):
            self.tDPhiToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_PhotonEnDown_value

    property tDPhiToPfMet_PhotonEnUp:
        def __get__(self):
            self.tDPhiToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_PhotonEnUp_value

    property tDPhiToPfMet_TauEnDown:
        def __get__(self):
            self.tDPhiToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_TauEnDown_value

    property tDPhiToPfMet_TauEnUp:
        def __get__(self):
            self.tDPhiToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_TauEnUp_value

    property tDPhiToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.tDPhiToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_UnclusteredEnDown_value

    property tDPhiToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.tDPhiToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_UnclusteredEnUp_value

    property tDPhiToPfMet_type1:
        def __get__(self):
            self.tDPhiToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.tDPhiToPfMet_type1_value

    property tDecayMode:
        def __get__(self):
            self.tDecayMode_branch.GetEntry(self.localentry, 0)
            return self.tDecayMode_value

    property tDecayModeFinding:
        def __get__(self):
            self.tDecayModeFinding_branch.GetEntry(self.localentry, 0)
            return self.tDecayModeFinding_value

    property tDecayModeFindingNewDMs:
        def __get__(self):
            self.tDecayModeFindingNewDMs_branch.GetEntry(self.localentry, 0)
            return self.tDecayModeFindingNewDMs_value

    property tElecOverlap:
        def __get__(self):
            self.tElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.tElecOverlap_value

    property tEta:
        def __get__(self):
            self.tEta_branch.GetEntry(self.localentry, 0)
            return self.tEta_value

    property tEta_TauEnDown:
        def __get__(self):
            self.tEta_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.tEta_TauEnDown_value

    property tEta_TauEnUp:
        def __get__(self):
            self.tEta_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.tEta_TauEnUp_value

    property tFootprintCorrection:
        def __get__(self):
            self.tFootprintCorrection_branch.GetEntry(self.localentry, 0)
            return self.tFootprintCorrection_value

    property tFootprintCorrectiondR03:
        def __get__(self):
            self.tFootprintCorrectiondR03_branch.GetEntry(self.localentry, 0)
            return self.tFootprintCorrectiondR03_value

    property tGenCharge:
        def __get__(self):
            self.tGenCharge_branch.GetEntry(self.localentry, 0)
            return self.tGenCharge_value

    property tGenDecayMode:
        def __get__(self):
            self.tGenDecayMode_branch.GetEntry(self.localentry, 0)
            return self.tGenDecayMode_value

    property tGenEnergy:
        def __get__(self):
            self.tGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.tGenEnergy_value

    property tGenEta:
        def __get__(self):
            self.tGenEta_branch.GetEntry(self.localentry, 0)
            return self.tGenEta_value

    property tGenJetEta:
        def __get__(self):
            self.tGenJetEta_branch.GetEntry(self.localentry, 0)
            return self.tGenJetEta_value

    property tGenJetPt:
        def __get__(self):
            self.tGenJetPt_branch.GetEntry(self.localentry, 0)
            return self.tGenJetPt_value

    property tGenMotherEnergy:
        def __get__(self):
            self.tGenMotherEnergy_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherEnergy_value

    property tGenMotherEta:
        def __get__(self):
            self.tGenMotherEta_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherEta_value

    property tGenMotherPdgId:
        def __get__(self):
            self.tGenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherPdgId_value

    property tGenMotherPhi:
        def __get__(self):
            self.tGenMotherPhi_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherPhi_value

    property tGenMotherPt:
        def __get__(self):
            self.tGenMotherPt_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherPt_value

    property tGenPdgId:
        def __get__(self):
            self.tGenPdgId_branch.GetEntry(self.localentry, 0)
            return self.tGenPdgId_value

    property tGenPhi:
        def __get__(self):
            self.tGenPhi_branch.GetEntry(self.localentry, 0)
            return self.tGenPhi_value

    property tGenPt:
        def __get__(self):
            self.tGenPt_branch.GetEntry(self.localentry, 0)
            return self.tGenPt_value

    property tGenStatus:
        def __get__(self):
            self.tGenStatus_branch.GetEntry(self.localentry, 0)
            return self.tGenStatus_value

    property tGlobalMuonVtxOverlap:
        def __get__(self):
            self.tGlobalMuonVtxOverlap_branch.GetEntry(self.localentry, 0)
            return self.tGlobalMuonVtxOverlap_value

    property tJetArea:
        def __get__(self):
            self.tJetArea_branch.GetEntry(self.localentry, 0)
            return self.tJetArea_value

    property tJetBtag:
        def __get__(self):
            self.tJetBtag_branch.GetEntry(self.localentry, 0)
            return self.tJetBtag_value

    property tJetEtaEtaMoment:
        def __get__(self):
            self.tJetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetEtaEtaMoment_value

    property tJetEtaPhiMoment:
        def __get__(self):
            self.tJetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetEtaPhiMoment_value

    property tJetEtaPhiSpread:
        def __get__(self):
            self.tJetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.tJetEtaPhiSpread_value

    property tJetPFCISVBtag:
        def __get__(self):
            self.tJetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.tJetPFCISVBtag_value

    property tJetPartonFlavour:
        def __get__(self):
            self.tJetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.tJetPartonFlavour_value

    property tJetPhiPhiMoment:
        def __get__(self):
            self.tJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetPhiPhiMoment_value

    property tJetPt:
        def __get__(self):
            self.tJetPt_branch.GetEntry(self.localentry, 0)
            return self.tJetPt_value

    property tLeadTrackPt:
        def __get__(self):
            self.tLeadTrackPt_branch.GetEntry(self.localentry, 0)
            return self.tLeadTrackPt_value

    property tLowestMll:
        def __get__(self):
            self.tLowestMll_branch.GetEntry(self.localentry, 0)
            return self.tLowestMll_value

    property tMass:
        def __get__(self):
            self.tMass_branch.GetEntry(self.localentry, 0)
            return self.tMass_value

    property tMass_TauEnDown:
        def __get__(self):
            self.tMass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.tMass_TauEnDown_value

    property tMass_TauEnUp:
        def __get__(self):
            self.tMass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.tMass_TauEnUp_value

    property tMtToPfMet_ElectronEnDown:
        def __get__(self):
            self.tMtToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_ElectronEnDown_value

    property tMtToPfMet_ElectronEnUp:
        def __get__(self):
            self.tMtToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_ElectronEnUp_value

    property tMtToPfMet_JetEnDown:
        def __get__(self):
            self.tMtToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_JetEnDown_value

    property tMtToPfMet_JetEnUp:
        def __get__(self):
            self.tMtToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_JetEnUp_value

    property tMtToPfMet_JetResDown:
        def __get__(self):
            self.tMtToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_JetResDown_value

    property tMtToPfMet_JetResUp:
        def __get__(self):
            self.tMtToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_JetResUp_value

    property tMtToPfMet_MuonEnDown:
        def __get__(self):
            self.tMtToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_MuonEnDown_value

    property tMtToPfMet_MuonEnUp:
        def __get__(self):
            self.tMtToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_MuonEnUp_value

    property tMtToPfMet_PhotonEnDown:
        def __get__(self):
            self.tMtToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_PhotonEnDown_value

    property tMtToPfMet_PhotonEnUp:
        def __get__(self):
            self.tMtToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_PhotonEnUp_value

    property tMtToPfMet_Raw:
        def __get__(self):
            self.tMtToPfMet_Raw_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_Raw_value

    property tMtToPfMet_TauEnDown:
        def __get__(self):
            self.tMtToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_TauEnDown_value

    property tMtToPfMet_TauEnUp:
        def __get__(self):
            self.tMtToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_TauEnUp_value

    property tMtToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.tMtToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_UnclusteredEnDown_value

    property tMtToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.tMtToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_UnclusteredEnUp_value

    property tMtToPfMet_type1:
        def __get__(self):
            self.tMtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_type1_value

    property tMuOverlap:
        def __get__(self):
            self.tMuOverlap_branch.GetEntry(self.localentry, 0)
            return self.tMuOverlap_value

    property tMuonIdIsoStdVtxOverlap:
        def __get__(self):
            self.tMuonIdIsoStdVtxOverlap_branch.GetEntry(self.localentry, 0)
            return self.tMuonIdIsoStdVtxOverlap_value

    property tMuonIdIsoVtxOverlap:
        def __get__(self):
            self.tMuonIdIsoVtxOverlap_branch.GetEntry(self.localentry, 0)
            return self.tMuonIdIsoVtxOverlap_value

    property tMuonIdVtxOverlap:
        def __get__(self):
            self.tMuonIdVtxOverlap_branch.GetEntry(self.localentry, 0)
            return self.tMuonIdVtxOverlap_value

    property tNChrgHadrSignalCands:
        def __get__(self):
            self.tNChrgHadrSignalCands_branch.GetEntry(self.localentry, 0)
            return self.tNChrgHadrSignalCands_value

    property tNGammaSignalCands:
        def __get__(self):
            self.tNGammaSignalCands_branch.GetEntry(self.localentry, 0)
            return self.tNGammaSignalCands_value

    property tNNeutralHadrSignalCands:
        def __get__(self):
            self.tNNeutralHadrSignalCands_branch.GetEntry(self.localentry, 0)
            return self.tNNeutralHadrSignalCands_value

    property tNSignalCands:
        def __get__(self):
            self.tNSignalCands_branch.GetEntry(self.localentry, 0)
            return self.tNSignalCands_value

    property tNearestZMass:
        def __get__(self):
            self.tNearestZMass_branch.GetEntry(self.localentry, 0)
            return self.tNearestZMass_value

    property tNeutralIsoPtSum:
        def __get__(self):
            self.tNeutralIsoPtSum_branch.GetEntry(self.localentry, 0)
            return self.tNeutralIsoPtSum_value

    property tNeutralIsoPtSumWeight:
        def __get__(self):
            self.tNeutralIsoPtSumWeight_branch.GetEntry(self.localentry, 0)
            return self.tNeutralIsoPtSumWeight_value

    property tNeutralIsoPtSumWeightdR03:
        def __get__(self):
            self.tNeutralIsoPtSumWeightdR03_branch.GetEntry(self.localentry, 0)
            return self.tNeutralIsoPtSumWeightdR03_value

    property tNeutralIsoPtSumdR03:
        def __get__(self):
            self.tNeutralIsoPtSumdR03_branch.GetEntry(self.localentry, 0)
            return self.tNeutralIsoPtSumdR03_value

    property tPVDXY:
        def __get__(self):
            self.tPVDXY_branch.GetEntry(self.localentry, 0)
            return self.tPVDXY_value

    property tPVDZ:
        def __get__(self):
            self.tPVDZ_branch.GetEntry(self.localentry, 0)
            return self.tPVDZ_value

    property tPhi:
        def __get__(self):
            self.tPhi_branch.GetEntry(self.localentry, 0)
            return self.tPhi_value

    property tPhi_TauEnDown:
        def __get__(self):
            self.tPhi_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.tPhi_TauEnDown_value

    property tPhi_TauEnUp:
        def __get__(self):
            self.tPhi_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.tPhi_TauEnUp_value

    property tPhotonPtSumOutsideSignalCone:
        def __get__(self):
            self.tPhotonPtSumOutsideSignalCone_branch.GetEntry(self.localentry, 0)
            return self.tPhotonPtSumOutsideSignalCone_value

    property tPhotonPtSumOutsideSignalConedR03:
        def __get__(self):
            self.tPhotonPtSumOutsideSignalConedR03_branch.GetEntry(self.localentry, 0)
            return self.tPhotonPtSumOutsideSignalConedR03_value

    property tPt:
        def __get__(self):
            self.tPt_branch.GetEntry(self.localentry, 0)
            return self.tPt_value

    property tPt_TauEnDown:
        def __get__(self):
            self.tPt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.tPt_TauEnDown_value

    property tPt_TauEnUp:
        def __get__(self):
            self.tPt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.tPt_TauEnUp_value

    property tPuCorrPtSum:
        def __get__(self):
            self.tPuCorrPtSum_branch.GetEntry(self.localentry, 0)
            return self.tPuCorrPtSum_value

    property tRank:
        def __get__(self):
            self.tRank_branch.GetEntry(self.localentry, 0)
            return self.tRank_value

    property tVZ:
        def __get__(self):
            self.tVZ_branch.GetEntry(self.localentry, 0)
            return self.tVZ_value

    property t_m_collinearmass:
        def __get__(self):
            self.t_m_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.t_m_collinearmass_value

    property tauVetoPt20Loose3HitsNewDMVtx:
        def __get__(self):
            self.tauVetoPt20Loose3HitsNewDMVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20Loose3HitsNewDMVtx_value

    property tauVetoPt20Loose3HitsVtx:
        def __get__(self):
            self.tauVetoPt20Loose3HitsVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20Loose3HitsVtx_value

    property tauVetoPt20TightMVALTNewDMVtx:
        def __get__(self):
            self.tauVetoPt20TightMVALTNewDMVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20TightMVALTNewDMVtx_value

    property tauVetoPt20TightMVALTVtx:
        def __get__(self):
            self.tauVetoPt20TightMVALTVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20TightMVALTVtx_value

    property tripleEGroup:
        def __get__(self):
            self.tripleEGroup_branch.GetEntry(self.localentry, 0)
            return self.tripleEGroup_value

    property tripleEPass:
        def __get__(self):
            self.tripleEPass_branch.GetEntry(self.localentry, 0)
            return self.tripleEPass_value

    property tripleEPrescale:
        def __get__(self):
            self.tripleEPrescale_branch.GetEntry(self.localentry, 0)
            return self.tripleEPrescale_value

    property tripleMuGroup:
        def __get__(self):
            self.tripleMuGroup_branch.GetEntry(self.localentry, 0)
            return self.tripleMuGroup_value

    property tripleMuPass:
        def __get__(self):
            self.tripleMuPass_branch.GetEntry(self.localentry, 0)
            return self.tripleMuPass_value

    property tripleMuPrescale:
        def __get__(self):
            self.tripleMuPrescale_branch.GetEntry(self.localentry, 0)
            return self.tripleMuPrescale_value

    property type1_pfMetEt:
        def __get__(self):
            self.type1_pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetEt_value

    property type1_pfMetPhi:
        def __get__(self):
            self.type1_pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetPhi_value

    property type1_pfMet_shiftedPhi_ElectronEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_ElectronEnDown_value

    property type1_pfMet_shiftedPhi_ElectronEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_ElectronEnUp_value

    property type1_pfMet_shiftedPhi_JetEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEnDown_value

    property type1_pfMet_shiftedPhi_JetEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEnUp_value

    property type1_pfMet_shiftedPhi_JetResDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetResDown_value

    property type1_pfMet_shiftedPhi_JetResUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetResUp_value

    property type1_pfMet_shiftedPhi_MuonEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_MuonEnDown_value

    property type1_pfMet_shiftedPhi_MuonEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_MuonEnUp_value

    property type1_pfMet_shiftedPhi_PhotonEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_PhotonEnDown_value

    property type1_pfMet_shiftedPhi_PhotonEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_PhotonEnUp_value

    property type1_pfMet_shiftedPhi_TauEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_TauEnDown_value

    property type1_pfMet_shiftedPhi_TauEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_TauEnUp_value

    property type1_pfMet_shiftedPhi_UnclusteredEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UnclusteredEnDown_value

    property type1_pfMet_shiftedPhi_UnclusteredEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UnclusteredEnUp_value

    property type1_pfMet_shiftedPt_ElectronEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_ElectronEnDown_value

    property type1_pfMet_shiftedPt_ElectronEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_ElectronEnUp_value

    property type1_pfMet_shiftedPt_JetEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEnDown_value

    property type1_pfMet_shiftedPt_JetEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEnUp_value

    property type1_pfMet_shiftedPt_JetResDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetResDown_value

    property type1_pfMet_shiftedPt_JetResUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetResUp_value

    property type1_pfMet_shiftedPt_MuonEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_MuonEnDown_value

    property type1_pfMet_shiftedPt_MuonEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_MuonEnUp_value

    property type1_pfMet_shiftedPt_PhotonEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_PhotonEnDown_value

    property type1_pfMet_shiftedPt_PhotonEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_PhotonEnUp_value

    property type1_pfMet_shiftedPt_TauEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_TauEnDown_value

    property type1_pfMet_shiftedPt_TauEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_TauEnUp_value

    property type1_pfMet_shiftedPt_UnclusteredEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UnclusteredEnDown_value

    property type1_pfMet_shiftedPt_UnclusteredEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UnclusteredEnUp_value

    property vbfDeta:
        def __get__(self):
            self.vbfDeta_branch.GetEntry(self.localentry, 0)
            return self.vbfDeta_value

    property vbfDeta_JetEnDown:
        def __get__(self):
            self.vbfDeta_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfDeta_JetEnDown_value

    property vbfDeta_JetEnUp:
        def __get__(self):
            self.vbfDeta_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfDeta_JetEnUp_value

    property vbfDijetrap:
        def __get__(self):
            self.vbfDijetrap_branch.GetEntry(self.localentry, 0)
            return self.vbfDijetrap_value

    property vbfDijetrap_JetEnDown:
        def __get__(self):
            self.vbfDijetrap_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfDijetrap_JetEnDown_value

    property vbfDijetrap_JetEnUp:
        def __get__(self):
            self.vbfDijetrap_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfDijetrap_JetEnUp_value

    property vbfDphi:
        def __get__(self):
            self.vbfDphi_branch.GetEntry(self.localentry, 0)
            return self.vbfDphi_value

    property vbfDphi_JetEnDown:
        def __get__(self):
            self.vbfDphi_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfDphi_JetEnDown_value

    property vbfDphi_JetEnUp:
        def __get__(self):
            self.vbfDphi_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfDphi_JetEnUp_value

    property vbfDphihj:
        def __get__(self):
            self.vbfDphihj_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihj_value

    property vbfDphihj_JetEnDown:
        def __get__(self):
            self.vbfDphihj_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihj_JetEnDown_value

    property vbfDphihj_JetEnUp:
        def __get__(self):
            self.vbfDphihj_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihj_JetEnUp_value

    property vbfDphihjnomet:
        def __get__(self):
            self.vbfDphihjnomet_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihjnomet_value

    property vbfDphihjnomet_JetEnDown:
        def __get__(self):
            self.vbfDphihjnomet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihjnomet_JetEnDown_value

    property vbfDphihjnomet_JetEnUp:
        def __get__(self):
            self.vbfDphihjnomet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihjnomet_JetEnUp_value

    property vbfHrap:
        def __get__(self):
            self.vbfHrap_branch.GetEntry(self.localentry, 0)
            return self.vbfHrap_value

    property vbfHrap_JetEnDown:
        def __get__(self):
            self.vbfHrap_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfHrap_JetEnDown_value

    property vbfHrap_JetEnUp:
        def __get__(self):
            self.vbfHrap_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfHrap_JetEnUp_value

    property vbfJetVeto20:
        def __get__(self):
            self.vbfJetVeto20_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto20_value

    property vbfJetVeto20_JetEnDown:
        def __get__(self):
            self.vbfJetVeto20_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto20_JetEnDown_value

    property vbfJetVeto20_JetEnUp:
        def __get__(self):
            self.vbfJetVeto20_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto20_JetEnUp_value

    property vbfJetVeto30:
        def __get__(self):
            self.vbfJetVeto30_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto30_value

    property vbfJetVeto30_JetEnDown:
        def __get__(self):
            self.vbfJetVeto30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto30_JetEnDown_value

    property vbfJetVeto30_JetEnUp:
        def __get__(self):
            self.vbfJetVeto30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto30_JetEnUp_value

    property vbfJetVetoTight20:
        def __get__(self):
            self.vbfJetVetoTight20_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVetoTight20_value

    property vbfJetVetoTight20_JetEnDown:
        def __get__(self):
            self.vbfJetVetoTight20_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVetoTight20_JetEnDown_value

    property vbfJetVetoTight20_JetEnUp:
        def __get__(self):
            self.vbfJetVetoTight20_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVetoTight20_JetEnUp_value

    property vbfJetVetoTight30:
        def __get__(self):
            self.vbfJetVetoTight30_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVetoTight30_value

    property vbfJetVetoTight30_JetEnDown:
        def __get__(self):
            self.vbfJetVetoTight30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVetoTight30_JetEnDown_value

    property vbfJetVetoTight30_JetEnUp:
        def __get__(self):
            self.vbfJetVetoTight30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVetoTight30_JetEnUp_value

    property vbfMVA:
        def __get__(self):
            self.vbfMVA_branch.GetEntry(self.localentry, 0)
            return self.vbfMVA_value

    property vbfMVA_JetEnDown:
        def __get__(self):
            self.vbfMVA_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMVA_JetEnDown_value

    property vbfMVA_JetEnUp:
        def __get__(self):
            self.vbfMVA_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMVA_JetEnUp_value

    property vbfMass:
        def __get__(self):
            self.vbfMass_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_value

    property vbfMass_JetEnDown:
        def __get__(self):
            self.vbfMass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEnDown_value

    property vbfMass_JetEnUp:
        def __get__(self):
            self.vbfMass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEnUp_value

    property vbfNJets:
        def __get__(self):
            self.vbfNJets_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets_value

    property vbfNJets_JetEnDown:
        def __get__(self):
            self.vbfNJets_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets_JetEnDown_value

    property vbfNJets_JetEnUp:
        def __get__(self):
            self.vbfNJets_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets_JetEnUp_value

    property vbfVispt:
        def __get__(self):
            self.vbfVispt_branch.GetEntry(self.localentry, 0)
            return self.vbfVispt_value

    property vbfVispt_JetEnDown:
        def __get__(self):
            self.vbfVispt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfVispt_JetEnDown_value

    property vbfVispt_JetEnUp:
        def __get__(self):
            self.vbfVispt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfVispt_JetEnUp_value

    property vbfdijetpt:
        def __get__(self):
            self.vbfdijetpt_branch.GetEntry(self.localentry, 0)
            return self.vbfdijetpt_value

    property vbfdijetpt_JetEnDown:
        def __get__(self):
            self.vbfdijetpt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfdijetpt_JetEnDown_value

    property vbfdijetpt_JetEnUp:
        def __get__(self):
            self.vbfdijetpt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfdijetpt_JetEnUp_value

    property vbfditaupt:
        def __get__(self):
            self.vbfditaupt_branch.GetEntry(self.localentry, 0)
            return self.vbfditaupt_value

    property vbfditaupt_JetEnDown:
        def __get__(self):
            self.vbfditaupt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfditaupt_JetEnDown_value

    property vbfditaupt_JetEnUp:
        def __get__(self):
            self.vbfditaupt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfditaupt_JetEnUp_value

    property vbfj1eta:
        def __get__(self):
            self.vbfj1eta_branch.GetEntry(self.localentry, 0)
            return self.vbfj1eta_value

    property vbfj1eta_JetEnDown:
        def __get__(self):
            self.vbfj1eta_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfj1eta_JetEnDown_value

    property vbfj1eta_JetEnUp:
        def __get__(self):
            self.vbfj1eta_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfj1eta_JetEnUp_value

    property vbfj1pt:
        def __get__(self):
            self.vbfj1pt_branch.GetEntry(self.localentry, 0)
            return self.vbfj1pt_value

    property vbfj1pt_JetEnDown:
        def __get__(self):
            self.vbfj1pt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfj1pt_JetEnDown_value

    property vbfj1pt_JetEnUp:
        def __get__(self):
            self.vbfj1pt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfj1pt_JetEnUp_value

    property vbfj2eta:
        def __get__(self):
            self.vbfj2eta_branch.GetEntry(self.localentry, 0)
            return self.vbfj2eta_value

    property vbfj2eta_JetEnDown:
        def __get__(self):
            self.vbfj2eta_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfj2eta_JetEnDown_value

    property vbfj2eta_JetEnUp:
        def __get__(self):
            self.vbfj2eta_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfj2eta_JetEnUp_value

    property vbfj2pt:
        def __get__(self):
            self.vbfj2pt_branch.GetEntry(self.localentry, 0)
            return self.vbfj2pt_value

    property vbfj2pt_JetEnDown:
        def __get__(self):
            self.vbfj2pt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfj2pt_JetEnDown_value

    property vbfj2pt_JetEnUp:
        def __get__(self):
            self.vbfj2pt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfj2pt_JetEnUp_value

    property idx:
        def __get__(self):
            self.idx_branch.GetEntry(self.localentry, 0)
            return self.idx_value


