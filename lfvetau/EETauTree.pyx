

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
        TFile* GetCurrentFile()
        TTree* GetTree()
        int GetTreeNumber()
        TBranch* GetBranch(char*)

cdef extern from "TFile.h":
    cdef cppclass TFile:
        TFile(char*, char*, char*, int)
        TObject* Get(char*)
        char* GetName()

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

cdef class EETauTree:
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

    cdef TBranch* NUP_branch
    cdef float NUP_value

    cdef TBranch* Pt_branch
    cdef float Pt_value

    cdef TBranch* bjetCSVVeto_branch
    cdef float bjetCSVVeto_value

    cdef TBranch* bjetCSVVeto30_branch
    cdef float bjetCSVVeto30_value

    cdef TBranch* bjetCSVVetoZHLike_branch
    cdef float bjetCSVVetoZHLike_value

    cdef TBranch* bjetCSVVetoZHLikeNoJetId_branch
    cdef float bjetCSVVetoZHLikeNoJetId_value

    cdef TBranch* bjetVeto_branch
    cdef float bjetVeto_value

    cdef TBranch* charge_branch
    cdef float charge_value

    cdef TBranch* doubleEExtraGroup_branch
    cdef float doubleEExtraGroup_value

    cdef TBranch* doubleEExtraPass_branch
    cdef float doubleEExtraPass_value

    cdef TBranch* doubleEExtraPrescale_branch
    cdef float doubleEExtraPrescale_value

    cdef TBranch* doubleEGroup_branch
    cdef float doubleEGroup_value

    cdef TBranch* doubleEPass_branch
    cdef float doubleEPass_value

    cdef TBranch* doubleEPrescale_branch
    cdef float doubleEPrescale_value

    cdef TBranch* doubleETightGroup_branch
    cdef float doubleETightGroup_value

    cdef TBranch* doubleETightPass_branch
    cdef float doubleETightPass_value

    cdef TBranch* doubleETightPrescale_branch
    cdef float doubleETightPrescale_value

    cdef TBranch* doubleMuGroup_branch
    cdef float doubleMuGroup_value

    cdef TBranch* doubleMuPass_branch
    cdef float doubleMuPass_value

    cdef TBranch* doubleMuPrescale_branch
    cdef float doubleMuPrescale_value

    cdef TBranch* doubleMuTrkGroup_branch
    cdef float doubleMuTrkGroup_value

    cdef TBranch* doubleMuTrkPass_branch
    cdef float doubleMuTrkPass_value

    cdef TBranch* doubleMuTrkPrescale_branch
    cdef float doubleMuTrkPrescale_value

    cdef TBranch* doublePhoGroup_branch
    cdef float doublePhoGroup_value

    cdef TBranch* doublePhoPass_branch
    cdef float doublePhoPass_value

    cdef TBranch* doublePhoPrescale_branch
    cdef float doublePhoPrescale_value

    cdef TBranch* e1AbsEta_branch
    cdef float e1AbsEta_value

    cdef TBranch* e1CBID_LOOSE_branch
    cdef float e1CBID_LOOSE_value

    cdef TBranch* e1CBID_MEDIUM_branch
    cdef float e1CBID_MEDIUM_value

    cdef TBranch* e1CBID_TIGHT_branch
    cdef float e1CBID_TIGHT_value

    cdef TBranch* e1CBID_VETO_branch
    cdef float e1CBID_VETO_value

    cdef TBranch* e1Charge_branch
    cdef float e1Charge_value

    cdef TBranch* e1ChargeIdLoose_branch
    cdef float e1ChargeIdLoose_value

    cdef TBranch* e1ChargeIdMed_branch
    cdef float e1ChargeIdMed_value

    cdef TBranch* e1ChargeIdTight_branch
    cdef float e1ChargeIdTight_value

    cdef TBranch* e1CiCTight_branch
    cdef float e1CiCTight_value

    cdef TBranch* e1ComesFromHiggs_branch
    cdef float e1ComesFromHiggs_value

    cdef TBranch* e1DZ_branch
    cdef float e1DZ_value

    cdef TBranch* e1E1x5_branch
    cdef float e1E1x5_value

    cdef TBranch* e1E2x5Max_branch
    cdef float e1E2x5Max_value

    cdef TBranch* e1E5x5_branch
    cdef float e1E5x5_value

    cdef TBranch* e1ECorrReg_2012Jul13ReReco_branch
    cdef float e1ECorrReg_2012Jul13ReReco_value

    cdef TBranch* e1ECorrReg_Fall11_branch
    cdef float e1ECorrReg_Fall11_value

    cdef TBranch* e1ECorrReg_Jan16ReReco_branch
    cdef float e1ECorrReg_Jan16ReReco_value

    cdef TBranch* e1ECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e1ECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1ECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e1ECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e1ECorrSmearedNoReg_Fall11_branch
    cdef float e1ECorrSmearedNoReg_Fall11_value

    cdef TBranch* e1ECorrSmearedNoReg_Jan16ReReco_branch
    cdef float e1ECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1ECorrSmearedReg_2012Jul13ReReco_branch
    cdef float e1ECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e1ECorrSmearedReg_Fall11_branch
    cdef float e1ECorrSmearedReg_Fall11_value

    cdef TBranch* e1ECorrSmearedReg_Jan16ReReco_branch
    cdef float e1ECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e1ECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1EcalIsoDR03_branch
    cdef float e1EcalIsoDR03_value

    cdef TBranch* e1EffectiveArea2011Data_branch
    cdef float e1EffectiveArea2011Data_value

    cdef TBranch* e1EffectiveArea2012Data_branch
    cdef float e1EffectiveArea2012Data_value

    cdef TBranch* e1EffectiveAreaFall11MC_branch
    cdef float e1EffectiveAreaFall11MC_value

    cdef TBranch* e1Ele27WP80PFMT50PFMTFilter_branch
    cdef float e1Ele27WP80PFMT50PFMTFilter_value

    cdef TBranch* e1Ele27WP80TrackIsoMatchFilter_branch
    cdef float e1Ele27WP80TrackIsoMatchFilter_value

    cdef TBranch* e1Ele32WP70PFMT50PFMTFilter_branch
    cdef float e1Ele32WP70PFMT50PFMTFilter_value

    cdef TBranch* e1EnergyError_branch
    cdef float e1EnergyError_value

    cdef TBranch* e1Eta_branch
    cdef float e1Eta_value

    cdef TBranch* e1EtaCorrReg_2012Jul13ReReco_branch
    cdef float e1EtaCorrReg_2012Jul13ReReco_value

    cdef TBranch* e1EtaCorrReg_Fall11_branch
    cdef float e1EtaCorrReg_Fall11_value

    cdef TBranch* e1EtaCorrReg_Jan16ReReco_branch
    cdef float e1EtaCorrReg_Jan16ReReco_value

    cdef TBranch* e1EtaCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e1EtaCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e1EtaCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e1EtaCorrSmearedNoReg_Fall11_branch
    cdef float e1EtaCorrSmearedNoReg_Fall11_value

    cdef TBranch* e1EtaCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e1EtaCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1EtaCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e1EtaCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e1EtaCorrSmearedReg_Fall11_branch
    cdef float e1EtaCorrSmearedReg_Fall11_value

    cdef TBranch* e1EtaCorrSmearedReg_Jan16ReReco_branch
    cdef float e1EtaCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1GenCharge_branch
    cdef float e1GenCharge_value

    cdef TBranch* e1GenEnergy_branch
    cdef float e1GenEnergy_value

    cdef TBranch* e1GenEta_branch
    cdef float e1GenEta_value

    cdef TBranch* e1GenMotherPdgId_branch
    cdef float e1GenMotherPdgId_value

    cdef TBranch* e1GenPdgId_branch
    cdef float e1GenPdgId_value

    cdef TBranch* e1GenPhi_branch
    cdef float e1GenPhi_value

    cdef TBranch* e1HadronicDepth1OverEm_branch
    cdef float e1HadronicDepth1OverEm_value

    cdef TBranch* e1HadronicDepth2OverEm_branch
    cdef float e1HadronicDepth2OverEm_value

    cdef TBranch* e1HadronicOverEM_branch
    cdef float e1HadronicOverEM_value

    cdef TBranch* e1HasConversion_branch
    cdef float e1HasConversion_value

    cdef TBranch* e1HasMatchedConversion_branch
    cdef int e1HasMatchedConversion_value

    cdef TBranch* e1HcalIsoDR03_branch
    cdef float e1HcalIsoDR03_value

    cdef TBranch* e1IP3DS_branch
    cdef float e1IP3DS_value

    cdef TBranch* e1JetArea_branch
    cdef float e1JetArea_value

    cdef TBranch* e1JetBtag_branch
    cdef float e1JetBtag_value

    cdef TBranch* e1JetCSVBtag_branch
    cdef float e1JetCSVBtag_value

    cdef TBranch* e1JetEtaEtaMoment_branch
    cdef float e1JetEtaEtaMoment_value

    cdef TBranch* e1JetEtaPhiMoment_branch
    cdef float e1JetEtaPhiMoment_value

    cdef TBranch* e1JetEtaPhiSpread_branch
    cdef float e1JetEtaPhiSpread_value

    cdef TBranch* e1JetPhiPhiMoment_branch
    cdef float e1JetPhiPhiMoment_value

    cdef TBranch* e1JetPt_branch
    cdef float e1JetPt_value

    cdef TBranch* e1JetQGLikelihoodID_branch
    cdef float e1JetQGLikelihoodID_value

    cdef TBranch* e1JetQGMVAID_branch
    cdef float e1JetQGMVAID_value

    cdef TBranch* e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch
    cdef float e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    cdef TBranch* e1MITID_branch
    cdef float e1MITID_value

    cdef TBranch* e1MVAIDH2TauWP_branch
    cdef float e1MVAIDH2TauWP_value

    cdef TBranch* e1MVANonTrig_branch
    cdef float e1MVANonTrig_value

    cdef TBranch* e1MVATrig_branch
    cdef float e1MVATrig_value

    cdef TBranch* e1MVATrigIDISO_branch
    cdef float e1MVATrigIDISO_value

    cdef TBranch* e1MVATrigIDISOPUSUB_branch
    cdef float e1MVATrigIDISOPUSUB_value

    cdef TBranch* e1MVATrigNoIP_branch
    cdef float e1MVATrigNoIP_value

    cdef TBranch* e1Mass_branch
    cdef float e1Mass_value

    cdef TBranch* e1MatchesDoubleEPath_branch
    cdef float e1MatchesDoubleEPath_value

    cdef TBranch* e1MatchesMu17Ele8IsoPath_branch
    cdef float e1MatchesMu17Ele8IsoPath_value

    cdef TBranch* e1MatchesMu17Ele8Path_branch
    cdef float e1MatchesMu17Ele8Path_value

    cdef TBranch* e1MatchesMu8Ele17IsoPath_branch
    cdef float e1MatchesMu8Ele17IsoPath_value

    cdef TBranch* e1MatchesMu8Ele17Path_branch
    cdef float e1MatchesMu8Ele17Path_value

    cdef TBranch* e1MatchesSingleE_branch
    cdef float e1MatchesSingleE_value

    cdef TBranch* e1MatchesSingleE27WP80_branch
    cdef float e1MatchesSingleE27WP80_value

    cdef TBranch* e1MatchesSingleEPlusMET_branch
    cdef float e1MatchesSingleEPlusMET_value

    cdef TBranch* e1MissingHits_branch
    cdef float e1MissingHits_value

    cdef TBranch* e1MtToMET_branch
    cdef float e1MtToMET_value

    cdef TBranch* e1MtToMVAMET_branch
    cdef float e1MtToMVAMET_value

    cdef TBranch* e1MtToPfMet_branch
    cdef float e1MtToPfMet_value

    cdef TBranch* e1MtToPfMet_Ty1_branch
    cdef float e1MtToPfMet_Ty1_value

    cdef TBranch* e1MtToPfMet_ees_branch
    cdef float e1MtToPfMet_ees_value

    cdef TBranch* e1MtToPfMet_ees_minus_branch
    cdef float e1MtToPfMet_ees_minus_value

    cdef TBranch* e1MtToPfMet_ees_plus_branch
    cdef float e1MtToPfMet_ees_plus_value

    cdef TBranch* e1MtToPfMet_jes_branch
    cdef float e1MtToPfMet_jes_value

    cdef TBranch* e1MtToPfMet_jes_minus_branch
    cdef float e1MtToPfMet_jes_minus_value

    cdef TBranch* e1MtToPfMet_jes_plus_branch
    cdef float e1MtToPfMet_jes_plus_value

    cdef TBranch* e1MtToPfMet_mes_branch
    cdef float e1MtToPfMet_mes_value

    cdef TBranch* e1MtToPfMet_mes_minus_branch
    cdef float e1MtToPfMet_mes_minus_value

    cdef TBranch* e1MtToPfMet_mes_plus_branch
    cdef float e1MtToPfMet_mes_plus_value

    cdef TBranch* e1MtToPfMet_tes_branch
    cdef float e1MtToPfMet_tes_value

    cdef TBranch* e1MtToPfMet_tes_minus_branch
    cdef float e1MtToPfMet_tes_minus_value

    cdef TBranch* e1MtToPfMet_tes_plus_branch
    cdef float e1MtToPfMet_tes_plus_value

    cdef TBranch* e1MtToPfMet_ues_branch
    cdef float e1MtToPfMet_ues_value

    cdef TBranch* e1MtToPfMet_ues_minus_branch
    cdef float e1MtToPfMet_ues_minus_value

    cdef TBranch* e1MtToPfMet_ues_plus_branch
    cdef float e1MtToPfMet_ues_plus_value

    cdef TBranch* e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch
    cdef float e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    cdef TBranch* e1Mu17Ele8CaloIdTPixelMatchFilter_branch
    cdef float e1Mu17Ele8CaloIdTPixelMatchFilter_value

    cdef TBranch* e1Mu17Ele8dZFilter_branch
    cdef float e1Mu17Ele8dZFilter_value

    cdef TBranch* e1NearMuonVeto_branch
    cdef float e1NearMuonVeto_value

    cdef TBranch* e1PFChargedIso_branch
    cdef float e1PFChargedIso_value

    cdef TBranch* e1PFNeutralIso_branch
    cdef float e1PFNeutralIso_value

    cdef TBranch* e1PFPhotonIso_branch
    cdef float e1PFPhotonIso_value

    cdef TBranch* e1PVDXY_branch
    cdef float e1PVDXY_value

    cdef TBranch* e1PVDZ_branch
    cdef float e1PVDZ_value

    cdef TBranch* e1Phi_branch
    cdef float e1Phi_value

    cdef TBranch* e1PhiCorrReg_2012Jul13ReReco_branch
    cdef float e1PhiCorrReg_2012Jul13ReReco_value

    cdef TBranch* e1PhiCorrReg_Fall11_branch
    cdef float e1PhiCorrReg_Fall11_value

    cdef TBranch* e1PhiCorrReg_Jan16ReReco_branch
    cdef float e1PhiCorrReg_Jan16ReReco_value

    cdef TBranch* e1PhiCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e1PhiCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e1PhiCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e1PhiCorrSmearedNoReg_Fall11_branch
    cdef float e1PhiCorrSmearedNoReg_Fall11_value

    cdef TBranch* e1PhiCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e1PhiCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1PhiCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e1PhiCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e1PhiCorrSmearedReg_Fall11_branch
    cdef float e1PhiCorrSmearedReg_Fall11_value

    cdef TBranch* e1PhiCorrSmearedReg_Jan16ReReco_branch
    cdef float e1PhiCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1Pt_branch
    cdef float e1Pt_value

    cdef TBranch* e1PtCorrReg_2012Jul13ReReco_branch
    cdef float e1PtCorrReg_2012Jul13ReReco_value

    cdef TBranch* e1PtCorrReg_Fall11_branch
    cdef float e1PtCorrReg_Fall11_value

    cdef TBranch* e1PtCorrReg_Jan16ReReco_branch
    cdef float e1PtCorrReg_Jan16ReReco_value

    cdef TBranch* e1PtCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e1PtCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1PtCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e1PtCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e1PtCorrSmearedNoReg_Fall11_branch
    cdef float e1PtCorrSmearedNoReg_Fall11_value

    cdef TBranch* e1PtCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e1PtCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1PtCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e1PtCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e1PtCorrSmearedReg_Fall11_branch
    cdef float e1PtCorrSmearedReg_Fall11_value

    cdef TBranch* e1PtCorrSmearedReg_Jan16ReReco_branch
    cdef float e1PtCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1Pt_ees_minus_branch
    cdef float e1Pt_ees_minus_value

    cdef TBranch* e1Pt_ees_plus_branch
    cdef float e1Pt_ees_plus_value

    cdef TBranch* e1Pt_tes_minus_branch
    cdef float e1Pt_tes_minus_value

    cdef TBranch* e1Pt_tes_plus_branch
    cdef float e1Pt_tes_plus_value

    cdef TBranch* e1Rank_branch
    cdef float e1Rank_value

    cdef TBranch* e1RelIso_branch
    cdef float e1RelIso_value

    cdef TBranch* e1RelPFIsoDB_branch
    cdef float e1RelPFIsoDB_value

    cdef TBranch* e1RelPFIsoRho_branch
    cdef float e1RelPFIsoRho_value

    cdef TBranch* e1RelPFIsoRhoFSR_branch
    cdef float e1RelPFIsoRhoFSR_value

    cdef TBranch* e1RhoHZG2011_branch
    cdef float e1RhoHZG2011_value

    cdef TBranch* e1RhoHZG2012_branch
    cdef float e1RhoHZG2012_value

    cdef TBranch* e1SCEnergy_branch
    cdef float e1SCEnergy_value

    cdef TBranch* e1SCEta_branch
    cdef float e1SCEta_value

    cdef TBranch* e1SCEtaWidth_branch
    cdef float e1SCEtaWidth_value

    cdef TBranch* e1SCPhi_branch
    cdef float e1SCPhi_value

    cdef TBranch* e1SCPhiWidth_branch
    cdef float e1SCPhiWidth_value

    cdef TBranch* e1SCPreshowerEnergy_branch
    cdef float e1SCPreshowerEnergy_value

    cdef TBranch* e1SCRawEnergy_branch
    cdef float e1SCRawEnergy_value

    cdef TBranch* e1SigmaIEtaIEta_branch
    cdef float e1SigmaIEtaIEta_value

    cdef TBranch* e1ToMETDPhi_branch
    cdef float e1ToMETDPhi_value

    cdef TBranch* e1TrkIsoDR03_branch
    cdef float e1TrkIsoDR03_value

    cdef TBranch* e1VZ_branch
    cdef float e1VZ_value

    cdef TBranch* e1WWID_branch
    cdef float e1WWID_value

    cdef TBranch* e1_e2_CosThetaStar_branch
    cdef float e1_e2_CosThetaStar_value

    cdef TBranch* e1_e2_DPhi_branch
    cdef float e1_e2_DPhi_value

    cdef TBranch* e1_e2_DR_branch
    cdef float e1_e2_DR_value

    cdef TBranch* e1_e2_Mass_branch
    cdef float e1_e2_Mass_value

    cdef TBranch* e1_e2_MassFsr_branch
    cdef float e1_e2_MassFsr_value

    cdef TBranch* e1_e2_Mass_ees_minus_branch
    cdef float e1_e2_Mass_ees_minus_value

    cdef TBranch* e1_e2_Mass_ees_plus_branch
    cdef float e1_e2_Mass_ees_plus_value

    cdef TBranch* e1_e2_Mass_tes_minus_branch
    cdef float e1_e2_Mass_tes_minus_value

    cdef TBranch* e1_e2_Mass_tes_plus_branch
    cdef float e1_e2_Mass_tes_plus_value

    cdef TBranch* e1_e2_PZeta_branch
    cdef float e1_e2_PZeta_value

    cdef TBranch* e1_e2_PZetaVis_branch
    cdef float e1_e2_PZetaVis_value

    cdef TBranch* e1_e2_Pt_branch
    cdef float e1_e2_Pt_value

    cdef TBranch* e1_e2_PtFsr_branch
    cdef float e1_e2_PtFsr_value

    cdef TBranch* e1_e2_SS_branch
    cdef float e1_e2_SS_value

    cdef TBranch* e1_e2_ToMETDPhi_Ty1_branch
    cdef float e1_e2_ToMETDPhi_Ty1_value

    cdef TBranch* e1_e2_ToMETDPhi_jes_minus_branch
    cdef float e1_e2_ToMETDPhi_jes_minus_value

    cdef TBranch* e1_e2_ToMETDPhi_jes_plus_branch
    cdef float e1_e2_ToMETDPhi_jes_plus_value

    cdef TBranch* e1_e2_Zcompat_branch
    cdef float e1_e2_Zcompat_value

    cdef TBranch* e1_t_CosThetaStar_branch
    cdef float e1_t_CosThetaStar_value

    cdef TBranch* e1_t_DPhi_branch
    cdef float e1_t_DPhi_value

    cdef TBranch* e1_t_DR_branch
    cdef float e1_t_DR_value

    cdef TBranch* e1_t_Mass_branch
    cdef float e1_t_Mass_value

    cdef TBranch* e1_t_MassFsr_branch
    cdef float e1_t_MassFsr_value

    cdef TBranch* e1_t_Mass_ees_minus_branch
    cdef float e1_t_Mass_ees_minus_value

    cdef TBranch* e1_t_Mass_ees_plus_branch
    cdef float e1_t_Mass_ees_plus_value

    cdef TBranch* e1_t_Mass_tes_minus_branch
    cdef float e1_t_Mass_tes_minus_value

    cdef TBranch* e1_t_Mass_tes_plus_branch
    cdef float e1_t_Mass_tes_plus_value

    cdef TBranch* e1_t_PZeta_branch
    cdef float e1_t_PZeta_value

    cdef TBranch* e1_t_PZetaVis_branch
    cdef float e1_t_PZetaVis_value

    cdef TBranch* e1_t_Pt_branch
    cdef float e1_t_Pt_value

    cdef TBranch* e1_t_PtFsr_branch
    cdef float e1_t_PtFsr_value

    cdef TBranch* e1_t_SS_branch
    cdef float e1_t_SS_value

    cdef TBranch* e1_t_ToMETDPhi_Ty1_branch
    cdef float e1_t_ToMETDPhi_Ty1_value

    cdef TBranch* e1_t_ToMETDPhi_jes_minus_branch
    cdef float e1_t_ToMETDPhi_jes_minus_value

    cdef TBranch* e1_t_ToMETDPhi_jes_plus_branch
    cdef float e1_t_ToMETDPhi_jes_plus_value

    cdef TBranch* e1_t_Zcompat_branch
    cdef float e1_t_Zcompat_value

    cdef TBranch* e1dECorrReg_2012Jul13ReReco_branch
    cdef float e1dECorrReg_2012Jul13ReReco_value

    cdef TBranch* e1dECorrReg_Fall11_branch
    cdef float e1dECorrReg_Fall11_value

    cdef TBranch* e1dECorrReg_Jan16ReReco_branch
    cdef float e1dECorrReg_Jan16ReReco_value

    cdef TBranch* e1dECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e1dECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1dECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e1dECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e1dECorrSmearedNoReg_Fall11_branch
    cdef float e1dECorrSmearedNoReg_Fall11_value

    cdef TBranch* e1dECorrSmearedNoReg_Jan16ReReco_branch
    cdef float e1dECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1dECorrSmearedReg_2012Jul13ReReco_branch
    cdef float e1dECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e1dECorrSmearedReg_Fall11_branch
    cdef float e1dECorrSmearedReg_Fall11_value

    cdef TBranch* e1dECorrSmearedReg_Jan16ReReco_branch
    cdef float e1dECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e1dECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1deltaEtaSuperClusterTrackAtVtx_branch
    cdef float e1deltaEtaSuperClusterTrackAtVtx_value

    cdef TBranch* e1deltaPhiSuperClusterTrackAtVtx_branch
    cdef float e1deltaPhiSuperClusterTrackAtVtx_value

    cdef TBranch* e1eSuperClusterOverP_branch
    cdef float e1eSuperClusterOverP_value

    cdef TBranch* e1ecalEnergy_branch
    cdef float e1ecalEnergy_value

    cdef TBranch* e1fBrem_branch
    cdef float e1fBrem_value

    cdef TBranch* e1trackMomentumAtVtxP_branch
    cdef float e1trackMomentumAtVtxP_value

    cdef TBranch* e2AbsEta_branch
    cdef float e2AbsEta_value

    cdef TBranch* e2CBID_LOOSE_branch
    cdef float e2CBID_LOOSE_value

    cdef TBranch* e2CBID_MEDIUM_branch
    cdef float e2CBID_MEDIUM_value

    cdef TBranch* e2CBID_TIGHT_branch
    cdef float e2CBID_TIGHT_value

    cdef TBranch* e2CBID_VETO_branch
    cdef float e2CBID_VETO_value

    cdef TBranch* e2Charge_branch
    cdef float e2Charge_value

    cdef TBranch* e2ChargeIdLoose_branch
    cdef float e2ChargeIdLoose_value

    cdef TBranch* e2ChargeIdMed_branch
    cdef float e2ChargeIdMed_value

    cdef TBranch* e2ChargeIdTight_branch
    cdef float e2ChargeIdTight_value

    cdef TBranch* e2CiCTight_branch
    cdef float e2CiCTight_value

    cdef TBranch* e2ComesFromHiggs_branch
    cdef float e2ComesFromHiggs_value

    cdef TBranch* e2DZ_branch
    cdef float e2DZ_value

    cdef TBranch* e2E1x5_branch
    cdef float e2E1x5_value

    cdef TBranch* e2E2x5Max_branch
    cdef float e2E2x5Max_value

    cdef TBranch* e2E5x5_branch
    cdef float e2E5x5_value

    cdef TBranch* e2ECorrReg_2012Jul13ReReco_branch
    cdef float e2ECorrReg_2012Jul13ReReco_value

    cdef TBranch* e2ECorrReg_Fall11_branch
    cdef float e2ECorrReg_Fall11_value

    cdef TBranch* e2ECorrReg_Jan16ReReco_branch
    cdef float e2ECorrReg_Jan16ReReco_value

    cdef TBranch* e2ECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e2ECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2ECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e2ECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e2ECorrSmearedNoReg_Fall11_branch
    cdef float e2ECorrSmearedNoReg_Fall11_value

    cdef TBranch* e2ECorrSmearedNoReg_Jan16ReReco_branch
    cdef float e2ECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2ECorrSmearedReg_2012Jul13ReReco_branch
    cdef float e2ECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e2ECorrSmearedReg_Fall11_branch
    cdef float e2ECorrSmearedReg_Fall11_value

    cdef TBranch* e2ECorrSmearedReg_Jan16ReReco_branch
    cdef float e2ECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e2ECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2EcalIsoDR03_branch
    cdef float e2EcalIsoDR03_value

    cdef TBranch* e2EffectiveArea2011Data_branch
    cdef float e2EffectiveArea2011Data_value

    cdef TBranch* e2EffectiveArea2012Data_branch
    cdef float e2EffectiveArea2012Data_value

    cdef TBranch* e2EffectiveAreaFall11MC_branch
    cdef float e2EffectiveAreaFall11MC_value

    cdef TBranch* e2Ele27WP80PFMT50PFMTFilter_branch
    cdef float e2Ele27WP80PFMT50PFMTFilter_value

    cdef TBranch* e2Ele27WP80TrackIsoMatchFilter_branch
    cdef float e2Ele27WP80TrackIsoMatchFilter_value

    cdef TBranch* e2Ele32WP70PFMT50PFMTFilter_branch
    cdef float e2Ele32WP70PFMT50PFMTFilter_value

    cdef TBranch* e2EnergyError_branch
    cdef float e2EnergyError_value

    cdef TBranch* e2Eta_branch
    cdef float e2Eta_value

    cdef TBranch* e2EtaCorrReg_2012Jul13ReReco_branch
    cdef float e2EtaCorrReg_2012Jul13ReReco_value

    cdef TBranch* e2EtaCorrReg_Fall11_branch
    cdef float e2EtaCorrReg_Fall11_value

    cdef TBranch* e2EtaCorrReg_Jan16ReReco_branch
    cdef float e2EtaCorrReg_Jan16ReReco_value

    cdef TBranch* e2EtaCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e2EtaCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e2EtaCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e2EtaCorrSmearedNoReg_Fall11_branch
    cdef float e2EtaCorrSmearedNoReg_Fall11_value

    cdef TBranch* e2EtaCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e2EtaCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2EtaCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e2EtaCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e2EtaCorrSmearedReg_Fall11_branch
    cdef float e2EtaCorrSmearedReg_Fall11_value

    cdef TBranch* e2EtaCorrSmearedReg_Jan16ReReco_branch
    cdef float e2EtaCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2GenCharge_branch
    cdef float e2GenCharge_value

    cdef TBranch* e2GenEnergy_branch
    cdef float e2GenEnergy_value

    cdef TBranch* e2GenEta_branch
    cdef float e2GenEta_value

    cdef TBranch* e2GenMotherPdgId_branch
    cdef float e2GenMotherPdgId_value

    cdef TBranch* e2GenPdgId_branch
    cdef float e2GenPdgId_value

    cdef TBranch* e2GenPhi_branch
    cdef float e2GenPhi_value

    cdef TBranch* e2HadronicDepth1OverEm_branch
    cdef float e2HadronicDepth1OverEm_value

    cdef TBranch* e2HadronicDepth2OverEm_branch
    cdef float e2HadronicDepth2OverEm_value

    cdef TBranch* e2HadronicOverEM_branch
    cdef float e2HadronicOverEM_value

    cdef TBranch* e2HasConversion_branch
    cdef float e2HasConversion_value

    cdef TBranch* e2HasMatchedConversion_branch
    cdef int e2HasMatchedConversion_value

    cdef TBranch* e2HcalIsoDR03_branch
    cdef float e2HcalIsoDR03_value

    cdef TBranch* e2IP3DS_branch
    cdef float e2IP3DS_value

    cdef TBranch* e2JetArea_branch
    cdef float e2JetArea_value

    cdef TBranch* e2JetBtag_branch
    cdef float e2JetBtag_value

    cdef TBranch* e2JetCSVBtag_branch
    cdef float e2JetCSVBtag_value

    cdef TBranch* e2JetEtaEtaMoment_branch
    cdef float e2JetEtaEtaMoment_value

    cdef TBranch* e2JetEtaPhiMoment_branch
    cdef float e2JetEtaPhiMoment_value

    cdef TBranch* e2JetEtaPhiSpread_branch
    cdef float e2JetEtaPhiSpread_value

    cdef TBranch* e2JetPhiPhiMoment_branch
    cdef float e2JetPhiPhiMoment_value

    cdef TBranch* e2JetPt_branch
    cdef float e2JetPt_value

    cdef TBranch* e2JetQGLikelihoodID_branch
    cdef float e2JetQGLikelihoodID_value

    cdef TBranch* e2JetQGMVAID_branch
    cdef float e2JetQGMVAID_value

    cdef TBranch* e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch
    cdef float e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    cdef TBranch* e2MITID_branch
    cdef float e2MITID_value

    cdef TBranch* e2MVAIDH2TauWP_branch
    cdef float e2MVAIDH2TauWP_value

    cdef TBranch* e2MVANonTrig_branch
    cdef float e2MVANonTrig_value

    cdef TBranch* e2MVATrig_branch
    cdef float e2MVATrig_value

    cdef TBranch* e2MVATrigIDISO_branch
    cdef float e2MVATrigIDISO_value

    cdef TBranch* e2MVATrigIDISOPUSUB_branch
    cdef float e2MVATrigIDISOPUSUB_value

    cdef TBranch* e2MVATrigNoIP_branch
    cdef float e2MVATrigNoIP_value

    cdef TBranch* e2Mass_branch
    cdef float e2Mass_value

    cdef TBranch* e2MatchesDoubleEPath_branch
    cdef float e2MatchesDoubleEPath_value

    cdef TBranch* e2MatchesMu17Ele8IsoPath_branch
    cdef float e2MatchesMu17Ele8IsoPath_value

    cdef TBranch* e2MatchesMu17Ele8Path_branch
    cdef float e2MatchesMu17Ele8Path_value

    cdef TBranch* e2MatchesMu8Ele17IsoPath_branch
    cdef float e2MatchesMu8Ele17IsoPath_value

    cdef TBranch* e2MatchesMu8Ele17Path_branch
    cdef float e2MatchesMu8Ele17Path_value

    cdef TBranch* e2MatchesSingleE_branch
    cdef float e2MatchesSingleE_value

    cdef TBranch* e2MatchesSingleE27WP80_branch
    cdef float e2MatchesSingleE27WP80_value

    cdef TBranch* e2MatchesSingleEPlusMET_branch
    cdef float e2MatchesSingleEPlusMET_value

    cdef TBranch* e2MissingHits_branch
    cdef float e2MissingHits_value

    cdef TBranch* e2MtToMET_branch
    cdef float e2MtToMET_value

    cdef TBranch* e2MtToMVAMET_branch
    cdef float e2MtToMVAMET_value

    cdef TBranch* e2MtToPfMet_branch
    cdef float e2MtToPfMet_value

    cdef TBranch* e2MtToPfMet_Ty1_branch
    cdef float e2MtToPfMet_Ty1_value

    cdef TBranch* e2MtToPfMet_ees_branch
    cdef float e2MtToPfMet_ees_value

    cdef TBranch* e2MtToPfMet_ees_minus_branch
    cdef float e2MtToPfMet_ees_minus_value

    cdef TBranch* e2MtToPfMet_ees_plus_branch
    cdef float e2MtToPfMet_ees_plus_value

    cdef TBranch* e2MtToPfMet_jes_branch
    cdef float e2MtToPfMet_jes_value

    cdef TBranch* e2MtToPfMet_jes_minus_branch
    cdef float e2MtToPfMet_jes_minus_value

    cdef TBranch* e2MtToPfMet_jes_plus_branch
    cdef float e2MtToPfMet_jes_plus_value

    cdef TBranch* e2MtToPfMet_mes_branch
    cdef float e2MtToPfMet_mes_value

    cdef TBranch* e2MtToPfMet_mes_minus_branch
    cdef float e2MtToPfMet_mes_minus_value

    cdef TBranch* e2MtToPfMet_mes_plus_branch
    cdef float e2MtToPfMet_mes_plus_value

    cdef TBranch* e2MtToPfMet_tes_branch
    cdef float e2MtToPfMet_tes_value

    cdef TBranch* e2MtToPfMet_tes_minus_branch
    cdef float e2MtToPfMet_tes_minus_value

    cdef TBranch* e2MtToPfMet_tes_plus_branch
    cdef float e2MtToPfMet_tes_plus_value

    cdef TBranch* e2MtToPfMet_ues_branch
    cdef float e2MtToPfMet_ues_value

    cdef TBranch* e2MtToPfMet_ues_minus_branch
    cdef float e2MtToPfMet_ues_minus_value

    cdef TBranch* e2MtToPfMet_ues_plus_branch
    cdef float e2MtToPfMet_ues_plus_value

    cdef TBranch* e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch
    cdef float e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    cdef TBranch* e2Mu17Ele8CaloIdTPixelMatchFilter_branch
    cdef float e2Mu17Ele8CaloIdTPixelMatchFilter_value

    cdef TBranch* e2Mu17Ele8dZFilter_branch
    cdef float e2Mu17Ele8dZFilter_value

    cdef TBranch* e2NearMuonVeto_branch
    cdef float e2NearMuonVeto_value

    cdef TBranch* e2PFChargedIso_branch
    cdef float e2PFChargedIso_value

    cdef TBranch* e2PFNeutralIso_branch
    cdef float e2PFNeutralIso_value

    cdef TBranch* e2PFPhotonIso_branch
    cdef float e2PFPhotonIso_value

    cdef TBranch* e2PVDXY_branch
    cdef float e2PVDXY_value

    cdef TBranch* e2PVDZ_branch
    cdef float e2PVDZ_value

    cdef TBranch* e2Phi_branch
    cdef float e2Phi_value

    cdef TBranch* e2PhiCorrReg_2012Jul13ReReco_branch
    cdef float e2PhiCorrReg_2012Jul13ReReco_value

    cdef TBranch* e2PhiCorrReg_Fall11_branch
    cdef float e2PhiCorrReg_Fall11_value

    cdef TBranch* e2PhiCorrReg_Jan16ReReco_branch
    cdef float e2PhiCorrReg_Jan16ReReco_value

    cdef TBranch* e2PhiCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e2PhiCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e2PhiCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e2PhiCorrSmearedNoReg_Fall11_branch
    cdef float e2PhiCorrSmearedNoReg_Fall11_value

    cdef TBranch* e2PhiCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e2PhiCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2PhiCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e2PhiCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e2PhiCorrSmearedReg_Fall11_branch
    cdef float e2PhiCorrSmearedReg_Fall11_value

    cdef TBranch* e2PhiCorrSmearedReg_Jan16ReReco_branch
    cdef float e2PhiCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2Pt_branch
    cdef float e2Pt_value

    cdef TBranch* e2PtCorrReg_2012Jul13ReReco_branch
    cdef float e2PtCorrReg_2012Jul13ReReco_value

    cdef TBranch* e2PtCorrReg_Fall11_branch
    cdef float e2PtCorrReg_Fall11_value

    cdef TBranch* e2PtCorrReg_Jan16ReReco_branch
    cdef float e2PtCorrReg_Jan16ReReco_value

    cdef TBranch* e2PtCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e2PtCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2PtCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e2PtCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e2PtCorrSmearedNoReg_Fall11_branch
    cdef float e2PtCorrSmearedNoReg_Fall11_value

    cdef TBranch* e2PtCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e2PtCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2PtCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e2PtCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e2PtCorrSmearedReg_Fall11_branch
    cdef float e2PtCorrSmearedReg_Fall11_value

    cdef TBranch* e2PtCorrSmearedReg_Jan16ReReco_branch
    cdef float e2PtCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2Pt_ees_minus_branch
    cdef float e2Pt_ees_minus_value

    cdef TBranch* e2Pt_ees_plus_branch
    cdef float e2Pt_ees_plus_value

    cdef TBranch* e2Pt_tes_minus_branch
    cdef float e2Pt_tes_minus_value

    cdef TBranch* e2Pt_tes_plus_branch
    cdef float e2Pt_tes_plus_value

    cdef TBranch* e2Rank_branch
    cdef float e2Rank_value

    cdef TBranch* e2RelIso_branch
    cdef float e2RelIso_value

    cdef TBranch* e2RelPFIsoDB_branch
    cdef float e2RelPFIsoDB_value

    cdef TBranch* e2RelPFIsoRho_branch
    cdef float e2RelPFIsoRho_value

    cdef TBranch* e2RelPFIsoRhoFSR_branch
    cdef float e2RelPFIsoRhoFSR_value

    cdef TBranch* e2RhoHZG2011_branch
    cdef float e2RhoHZG2011_value

    cdef TBranch* e2RhoHZG2012_branch
    cdef float e2RhoHZG2012_value

    cdef TBranch* e2SCEnergy_branch
    cdef float e2SCEnergy_value

    cdef TBranch* e2SCEta_branch
    cdef float e2SCEta_value

    cdef TBranch* e2SCEtaWidth_branch
    cdef float e2SCEtaWidth_value

    cdef TBranch* e2SCPhi_branch
    cdef float e2SCPhi_value

    cdef TBranch* e2SCPhiWidth_branch
    cdef float e2SCPhiWidth_value

    cdef TBranch* e2SCPreshowerEnergy_branch
    cdef float e2SCPreshowerEnergy_value

    cdef TBranch* e2SCRawEnergy_branch
    cdef float e2SCRawEnergy_value

    cdef TBranch* e2SigmaIEtaIEta_branch
    cdef float e2SigmaIEtaIEta_value

    cdef TBranch* e2ToMETDPhi_branch
    cdef float e2ToMETDPhi_value

    cdef TBranch* e2TrkIsoDR03_branch
    cdef float e2TrkIsoDR03_value

    cdef TBranch* e2VZ_branch
    cdef float e2VZ_value

    cdef TBranch* e2WWID_branch
    cdef float e2WWID_value

    cdef TBranch* e2_t_CosThetaStar_branch
    cdef float e2_t_CosThetaStar_value

    cdef TBranch* e2_t_DPhi_branch
    cdef float e2_t_DPhi_value

    cdef TBranch* e2_t_DR_branch
    cdef float e2_t_DR_value

    cdef TBranch* e2_t_Mass_branch
    cdef float e2_t_Mass_value

    cdef TBranch* e2_t_MassFsr_branch
    cdef float e2_t_MassFsr_value

    cdef TBranch* e2_t_Mass_ees_minus_branch
    cdef float e2_t_Mass_ees_minus_value

    cdef TBranch* e2_t_Mass_ees_plus_branch
    cdef float e2_t_Mass_ees_plus_value

    cdef TBranch* e2_t_Mass_tes_minus_branch
    cdef float e2_t_Mass_tes_minus_value

    cdef TBranch* e2_t_Mass_tes_plus_branch
    cdef float e2_t_Mass_tes_plus_value

    cdef TBranch* e2_t_PZeta_branch
    cdef float e2_t_PZeta_value

    cdef TBranch* e2_t_PZetaVis_branch
    cdef float e2_t_PZetaVis_value

    cdef TBranch* e2_t_Pt_branch
    cdef float e2_t_Pt_value

    cdef TBranch* e2_t_PtFsr_branch
    cdef float e2_t_PtFsr_value

    cdef TBranch* e2_t_SS_branch
    cdef float e2_t_SS_value

    cdef TBranch* e2_t_ToMETDPhi_Ty1_branch
    cdef float e2_t_ToMETDPhi_Ty1_value

    cdef TBranch* e2_t_ToMETDPhi_jes_minus_branch
    cdef float e2_t_ToMETDPhi_jes_minus_value

    cdef TBranch* e2_t_ToMETDPhi_jes_plus_branch
    cdef float e2_t_ToMETDPhi_jes_plus_value

    cdef TBranch* e2_t_Zcompat_branch
    cdef float e2_t_Zcompat_value

    cdef TBranch* e2dECorrReg_2012Jul13ReReco_branch
    cdef float e2dECorrReg_2012Jul13ReReco_value

    cdef TBranch* e2dECorrReg_Fall11_branch
    cdef float e2dECorrReg_Fall11_value

    cdef TBranch* e2dECorrReg_Jan16ReReco_branch
    cdef float e2dECorrReg_Jan16ReReco_value

    cdef TBranch* e2dECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e2dECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2dECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e2dECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e2dECorrSmearedNoReg_Fall11_branch
    cdef float e2dECorrSmearedNoReg_Fall11_value

    cdef TBranch* e2dECorrSmearedNoReg_Jan16ReReco_branch
    cdef float e2dECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2dECorrSmearedReg_2012Jul13ReReco_branch
    cdef float e2dECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e2dECorrSmearedReg_Fall11_branch
    cdef float e2dECorrSmearedReg_Fall11_value

    cdef TBranch* e2dECorrSmearedReg_Jan16ReReco_branch
    cdef float e2dECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e2dECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2deltaEtaSuperClusterTrackAtVtx_branch
    cdef float e2deltaEtaSuperClusterTrackAtVtx_value

    cdef TBranch* e2deltaPhiSuperClusterTrackAtVtx_branch
    cdef float e2deltaPhiSuperClusterTrackAtVtx_value

    cdef TBranch* e2eSuperClusterOverP_branch
    cdef float e2eSuperClusterOverP_value

    cdef TBranch* e2ecalEnergy_branch
    cdef float e2ecalEnergy_value

    cdef TBranch* e2fBrem_branch
    cdef float e2fBrem_value

    cdef TBranch* e2trackMomentumAtVtxP_branch
    cdef float e2trackMomentumAtVtxP_value

    cdef TBranch* eVetoCicLooseIso_branch
    cdef float eVetoCicLooseIso_value

    cdef TBranch* eVetoCicLooseIso_ees_minus_branch
    cdef float eVetoCicLooseIso_ees_minus_value

    cdef TBranch* eVetoCicLooseIso_ees_plus_branch
    cdef float eVetoCicLooseIso_ees_plus_value

    cdef TBranch* eVetoCicTightIso_branch
    cdef float eVetoCicTightIso_value

    cdef TBranch* eVetoCicTightIso_ees_minus_branch
    cdef float eVetoCicTightIso_ees_minus_value

    cdef TBranch* eVetoCicTightIso_ees_plus_branch
    cdef float eVetoCicTightIso_ees_plus_value

    cdef TBranch* eVetoMVAIso_branch
    cdef float eVetoMVAIso_value

    cdef TBranch* eVetoMVAIsoVtx_branch
    cdef float eVetoMVAIsoVtx_value

    cdef TBranch* evt_branch
    cdef int evt_value

    cdef TBranch* isGtautau_branch
    cdef float isGtautau_value

    cdef TBranch* isWmunu_branch
    cdef float isWmunu_value

    cdef TBranch* isWtaunu_branch
    cdef float isWtaunu_value

    cdef TBranch* isZtautau_branch
    cdef float isZtautau_value

    cdef TBranch* isdata_branch
    cdef int isdata_value

    cdef TBranch* isoMu24eta2p1Group_branch
    cdef float isoMu24eta2p1Group_value

    cdef TBranch* isoMu24eta2p1Pass_branch
    cdef float isoMu24eta2p1Pass_value

    cdef TBranch* isoMu24eta2p1Prescale_branch
    cdef float isoMu24eta2p1Prescale_value

    cdef TBranch* isoMuGroup_branch
    cdef float isoMuGroup_value

    cdef TBranch* isoMuPass_branch
    cdef float isoMuPass_value

    cdef TBranch* isoMuPrescale_branch
    cdef float isoMuPrescale_value

    cdef TBranch* isoMuTauGroup_branch
    cdef float isoMuTauGroup_value

    cdef TBranch* isoMuTauPass_branch
    cdef float isoMuTauPass_value

    cdef TBranch* isoMuTauPrescale_branch
    cdef float isoMuTauPrescale_value

    cdef TBranch* jetVeto20_branch
    cdef float jetVeto20_value

    cdef TBranch* jetVeto20_DR05_branch
    cdef float jetVeto20_DR05_value

    cdef TBranch* jetVeto20jes_minus_branch
    cdef float jetVeto20jes_minus_value

    cdef TBranch* jetVeto20jes_plus_branch
    cdef float jetVeto20jes_plus_value

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

    cdef TBranch* jetVeto30_DR05_branch
    cdef float jetVeto30_DR05_value

    cdef TBranch* jetVeto30jes_minus_branch
    cdef float jetVeto30jes_minus_value

    cdef TBranch* jetVeto30jes_plus_branch
    cdef float jetVeto30jes_plus_value

    cdef TBranch* jetVeto40_branch
    cdef float jetVeto40_value

    cdef TBranch* jetVeto40_DR05_branch
    cdef float jetVeto40_DR05_value

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* mu17ele8Group_branch
    cdef float mu17ele8Group_value

    cdef TBranch* mu17ele8Pass_branch
    cdef float mu17ele8Pass_value

    cdef TBranch* mu17ele8Prescale_branch
    cdef float mu17ele8Prescale_value

    cdef TBranch* mu17ele8isoGroup_branch
    cdef float mu17ele8isoGroup_value

    cdef TBranch* mu17ele8isoPass_branch
    cdef float mu17ele8isoPass_value

    cdef TBranch* mu17ele8isoPrescale_branch
    cdef float mu17ele8isoPrescale_value

    cdef TBranch* mu17mu8Group_branch
    cdef float mu17mu8Group_value

    cdef TBranch* mu17mu8Pass_branch
    cdef float mu17mu8Pass_value

    cdef TBranch* mu17mu8Prescale_branch
    cdef float mu17mu8Prescale_value

    cdef TBranch* mu8ele17Group_branch
    cdef float mu8ele17Group_value

    cdef TBranch* mu8ele17Pass_branch
    cdef float mu8ele17Pass_value

    cdef TBranch* mu8ele17Prescale_branch
    cdef float mu8ele17Prescale_value

    cdef TBranch* mu8ele17isoGroup_branch
    cdef float mu8ele17isoGroup_value

    cdef TBranch* mu8ele17isoPass_branch
    cdef float mu8ele17isoPass_value

    cdef TBranch* mu8ele17isoPrescale_branch
    cdef float mu8ele17isoPrescale_value

    cdef TBranch* muGlbIsoVetoPt10_branch
    cdef float muGlbIsoVetoPt10_value

    cdef TBranch* muTauGroup_branch
    cdef float muTauGroup_value

    cdef TBranch* muTauPass_branch
    cdef float muTauPass_value

    cdef TBranch* muTauPrescale_branch
    cdef float muTauPrescale_value

    cdef TBranch* muTauTestGroup_branch
    cdef float muTauTestGroup_value

    cdef TBranch* muTauTestPass_branch
    cdef float muTauTestPass_value

    cdef TBranch* muTauTestPrescale_branch
    cdef float muTauTestPrescale_value

    cdef TBranch* muVetoPt15IsoIdVtx_branch
    cdef float muVetoPt15IsoIdVtx_value

    cdef TBranch* muVetoPt5_branch
    cdef float muVetoPt5_value

    cdef TBranch* muVetoPt5IsoIdVtx_branch
    cdef float muVetoPt5IsoIdVtx_value

    cdef TBranch* muVetoPt5IsoIdVtx_mes_minus_branch
    cdef float muVetoPt5IsoIdVtx_mes_minus_value

    cdef TBranch* muVetoPt5IsoIdVtx_mes_plus_branch
    cdef float muVetoPt5IsoIdVtx_mes_plus_value

    cdef TBranch* mva_met_Et_branch
    cdef float mva_met_Et_value

    cdef TBranch* mva_met_Phi_branch
    cdef float mva_met_Phi_value

    cdef TBranch* nTruePU_branch
    cdef float nTruePU_value

    cdef TBranch* nvtx_branch
    cdef float nvtx_value

    cdef TBranch* pfMet_Et_branch
    cdef float pfMet_Et_value

    cdef TBranch* pfMet_Et_ees_minus_branch
    cdef float pfMet_Et_ees_minus_value

    cdef TBranch* pfMet_Et_ees_plus_branch
    cdef float pfMet_Et_ees_plus_value

    cdef TBranch* pfMet_Et_jes_minus_branch
    cdef float pfMet_Et_jes_minus_value

    cdef TBranch* pfMet_Et_jes_plus_branch
    cdef float pfMet_Et_jes_plus_value

    cdef TBranch* pfMet_Et_mes_minus_branch
    cdef float pfMet_Et_mes_minus_value

    cdef TBranch* pfMet_Et_mes_plus_branch
    cdef float pfMet_Et_mes_plus_value

    cdef TBranch* pfMet_Et_tes_minus_branch
    cdef float pfMet_Et_tes_minus_value

    cdef TBranch* pfMet_Et_tes_plus_branch
    cdef float pfMet_Et_tes_plus_value

    cdef TBranch* pfMet_Et_ues_minus_branch
    cdef float pfMet_Et_ues_minus_value

    cdef TBranch* pfMet_Et_ues_plus_branch
    cdef float pfMet_Et_ues_plus_value

    cdef TBranch* pfMet_Phi_branch
    cdef float pfMet_Phi_value

    cdef TBranch* pfMet_Phi_ees_minus_branch
    cdef float pfMet_Phi_ees_minus_value

    cdef TBranch* pfMet_Phi_ees_plus_branch
    cdef float pfMet_Phi_ees_plus_value

    cdef TBranch* pfMet_Phi_jes_minus_branch
    cdef float pfMet_Phi_jes_minus_value

    cdef TBranch* pfMet_Phi_jes_plus_branch
    cdef float pfMet_Phi_jes_plus_value

    cdef TBranch* pfMet_Phi_mes_minus_branch
    cdef float pfMet_Phi_mes_minus_value

    cdef TBranch* pfMet_Phi_mes_plus_branch
    cdef float pfMet_Phi_mes_plus_value

    cdef TBranch* pfMet_Phi_tes_minus_branch
    cdef float pfMet_Phi_tes_minus_value

    cdef TBranch* pfMet_Phi_tes_plus_branch
    cdef float pfMet_Phi_tes_plus_value

    cdef TBranch* pfMet_Phi_ues_minus_branch
    cdef float pfMet_Phi_ues_minus_value

    cdef TBranch* pfMet_Phi_ues_plus_branch
    cdef float pfMet_Phi_ues_plus_value

    cdef TBranch* pfMet_diff_Et_branch
    cdef float pfMet_diff_Et_value

    cdef TBranch* pfMet_jes_Et_branch
    cdef float pfMet_jes_Et_value

    cdef TBranch* pfMet_jes_Phi_branch
    cdef float pfMet_jes_Phi_value

    cdef TBranch* pfMet_ues_AtanToPhi_branch
    cdef float pfMet_ues_AtanToPhi_value

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

    cdef TBranch* pvX_branch
    cdef float pvX_value

    cdef TBranch* pvY_branch
    cdef float pvY_value

    cdef TBranch* pvZ_branch
    cdef float pvZ_value

    cdef TBranch* pvndof_branch
    cdef float pvndof_value

    cdef TBranch* recoilDaught_branch
    cdef float recoilDaught_value

    cdef TBranch* recoilWithMet_branch
    cdef float recoilWithMet_value

    cdef TBranch* rho_branch
    cdef float rho_value

    cdef TBranch* run_branch
    cdef int run_value

    cdef TBranch* singleE27WP80Group_branch
    cdef float singleE27WP80Group_value

    cdef TBranch* singleE27WP80Pass_branch
    cdef float singleE27WP80Pass_value

    cdef TBranch* singleE27WP80Prescale_branch
    cdef float singleE27WP80Prescale_value

    cdef TBranch* singleEGroup_branch
    cdef float singleEGroup_value

    cdef TBranch* singleEPFMTGroup_branch
    cdef float singleEPFMTGroup_value

    cdef TBranch* singleEPFMTPass_branch
    cdef float singleEPFMTPass_value

    cdef TBranch* singleEPFMTPrescale_branch
    cdef float singleEPFMTPrescale_value

    cdef TBranch* singleEPass_branch
    cdef float singleEPass_value

    cdef TBranch* singleEPrescale_branch
    cdef float singleEPrescale_value

    cdef TBranch* singleMuGroup_branch
    cdef float singleMuGroup_value

    cdef TBranch* singleMuPass_branch
    cdef float singleMuPass_value

    cdef TBranch* singleMuPrescale_branch
    cdef float singleMuPrescale_value

    cdef TBranch* singlePhoGroup_branch
    cdef float singlePhoGroup_value

    cdef TBranch* singlePhoPass_branch
    cdef float singlePhoPass_value

    cdef TBranch* singlePhoPrescale_branch
    cdef float singlePhoPrescale_value

    cdef TBranch* tAbsEta_branch
    cdef float tAbsEta_value

    cdef TBranch* tAntiElectronLoose_branch
    cdef float tAntiElectronLoose_value

    cdef TBranch* tAntiElectronMVA5Loose_branch
    cdef float tAntiElectronMVA5Loose_value

    cdef TBranch* tAntiElectronMVA5Medium_branch
    cdef float tAntiElectronMVA5Medium_value

    cdef TBranch* tAntiElectronMVA5Tight_branch
    cdef float tAntiElectronMVA5Tight_value

    cdef TBranch* tAntiElectronMVA5VLoose_branch
    cdef float tAntiElectronMVA5VLoose_value

    cdef TBranch* tAntiElectronMVA5VTight_branch
    cdef float tAntiElectronMVA5VTight_value

    cdef TBranch* tAntiElectronMedium_branch
    cdef float tAntiElectronMedium_value

    cdef TBranch* tAntiElectronTight_branch
    cdef float tAntiElectronTight_value

    cdef TBranch* tAntiMuon2Loose_branch
    cdef float tAntiMuon2Loose_value

    cdef TBranch* tAntiMuon2Medium_branch
    cdef float tAntiMuon2Medium_value

    cdef TBranch* tAntiMuon2Tight_branch
    cdef float tAntiMuon2Tight_value

    cdef TBranch* tAntiMuon3Loose_branch
    cdef float tAntiMuon3Loose_value

    cdef TBranch* tAntiMuon3Tight_branch
    cdef float tAntiMuon3Tight_value

    cdef TBranch* tAntiMuonLoose_branch
    cdef float tAntiMuonLoose_value

    cdef TBranch* tAntiMuonMVALoose_branch
    cdef float tAntiMuonMVALoose_value

    cdef TBranch* tAntiMuonMVAMedium_branch
    cdef float tAntiMuonMVAMedium_value

    cdef TBranch* tAntiMuonMVATight_branch
    cdef float tAntiMuonMVATight_value

    cdef TBranch* tAntiMuonMedium_branch
    cdef float tAntiMuonMedium_value

    cdef TBranch* tAntiMuonTight_branch
    cdef float tAntiMuonTight_value

    cdef TBranch* tCharge_branch
    cdef float tCharge_value

    cdef TBranch* tCiCTightElecOverlap_branch
    cdef float tCiCTightElecOverlap_value

    cdef TBranch* tComesFromHiggs_branch
    cdef float tComesFromHiggs_value

    cdef TBranch* tDZ_branch
    cdef float tDZ_value

    cdef TBranch* tDecayFinding_branch
    cdef float tDecayFinding_value

    cdef TBranch* tDecayFindingNewDMs_branch
    cdef float tDecayFindingNewDMs_value

    cdef TBranch* tDecayFindingOldDMs_branch
    cdef float tDecayFindingOldDMs_value

    cdef TBranch* tDecayMode_branch
    cdef float tDecayMode_value

    cdef TBranch* tElecOverlap_branch
    cdef float tElecOverlap_value

    cdef TBranch* tElectronPt10IdIsoVtxOverlap_branch
    cdef float tElectronPt10IdIsoVtxOverlap_value

    cdef TBranch* tElectronPt10IdVtxOverlap_branch
    cdef float tElectronPt10IdVtxOverlap_value

    cdef TBranch* tElectronPt15IdIsoVtxOverlap_branch
    cdef float tElectronPt15IdIsoVtxOverlap_value

    cdef TBranch* tElectronPt15IdVtxOverlap_branch
    cdef float tElectronPt15IdVtxOverlap_value

    cdef TBranch* tEta_branch
    cdef float tEta_value

    cdef TBranch* tGenCharge_branch
    cdef float tGenCharge_value

    cdef TBranch* tGenDecayMode_branch
    cdef float tGenDecayMode_value

    cdef TBranch* tGenEnergy_branch
    cdef float tGenEnergy_value

    cdef TBranch* tGenEta_branch
    cdef float tGenEta_value

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

    cdef TBranch* tGenPx_branch
    cdef float tGenPx_value

    cdef TBranch* tGenPy_branch
    cdef float tGenPy_value

    cdef TBranch* tGenPz_branch
    cdef float tGenPz_value

    cdef TBranch* tGlobalMuonVtxOverlap_branch
    cdef float tGlobalMuonVtxOverlap_value

    cdef TBranch* tIP3DS_branch
    cdef float tIP3DS_value

    cdef TBranch* tJetArea_branch
    cdef float tJetArea_value

    cdef TBranch* tJetBtag_branch
    cdef float tJetBtag_value

    cdef TBranch* tJetCSVBtag_branch
    cdef float tJetCSVBtag_value

    cdef TBranch* tJetEtaEtaMoment_branch
    cdef float tJetEtaEtaMoment_value

    cdef TBranch* tJetEtaPhiMoment_branch
    cdef float tJetEtaPhiMoment_value

    cdef TBranch* tJetEtaPhiSpread_branch
    cdef float tJetEtaPhiSpread_value

    cdef TBranch* tJetPhiPhiMoment_branch
    cdef float tJetPhiPhiMoment_value

    cdef TBranch* tJetPt_branch
    cdef float tJetPt_value

    cdef TBranch* tJetQGLikelihoodID_branch
    cdef float tJetQGLikelihoodID_value

    cdef TBranch* tJetQGMVAID_branch
    cdef float tJetQGMVAID_value

    cdef TBranch* tLeadTrackPt_branch
    cdef float tLeadTrackPt_value

    cdef TBranch* tLooseIso_branch
    cdef float tLooseIso_value

    cdef TBranch* tLooseIso3Hits_branch
    cdef float tLooseIso3Hits_value

    cdef TBranch* tLooseIsoMVA3NewDMLT_branch
    cdef float tLooseIsoMVA3NewDMLT_value

    cdef TBranch* tLooseIsoMVA3NewDMNoLT_branch
    cdef float tLooseIsoMVA3NewDMNoLT_value

    cdef TBranch* tLooseIsoMVA3OldDMLT_branch
    cdef float tLooseIsoMVA3OldDMLT_value

    cdef TBranch* tLooseIsoMVA3OldDMNoLT_branch
    cdef float tLooseIsoMVA3OldDMNoLT_value

    cdef TBranch* tMass_branch
    cdef float tMass_value

    cdef TBranch* tMediumIso_branch
    cdef float tMediumIso_value

    cdef TBranch* tMediumIso3Hits_branch
    cdef float tMediumIso3Hits_value

    cdef TBranch* tMediumIsoMVA3NewDMLT_branch
    cdef float tMediumIsoMVA3NewDMLT_value

    cdef TBranch* tMediumIsoMVA3NewDMNoLT_branch
    cdef float tMediumIsoMVA3NewDMNoLT_value

    cdef TBranch* tMediumIsoMVA3OldDMLT_branch
    cdef float tMediumIsoMVA3OldDMLT_value

    cdef TBranch* tMediumIsoMVA3OldDMNoLT_branch
    cdef float tMediumIsoMVA3OldDMNoLT_value

    cdef TBranch* tMtToMET_branch
    cdef float tMtToMET_value

    cdef TBranch* tMtToMVAMET_branch
    cdef float tMtToMVAMET_value

    cdef TBranch* tMtToPfMet_branch
    cdef float tMtToPfMet_value

    cdef TBranch* tMtToPfMet_Ty1_branch
    cdef float tMtToPfMet_Ty1_value

    cdef TBranch* tMtToPfMet_ees_branch
    cdef float tMtToPfMet_ees_value

    cdef TBranch* tMtToPfMet_ees_minus_branch
    cdef float tMtToPfMet_ees_minus_value

    cdef TBranch* tMtToPfMet_ees_plus_branch
    cdef float tMtToPfMet_ees_plus_value

    cdef TBranch* tMtToPfMet_jes_branch
    cdef float tMtToPfMet_jes_value

    cdef TBranch* tMtToPfMet_jes_minus_branch
    cdef float tMtToPfMet_jes_minus_value

    cdef TBranch* tMtToPfMet_jes_plus_branch
    cdef float tMtToPfMet_jes_plus_value

    cdef TBranch* tMtToPfMet_mes_branch
    cdef float tMtToPfMet_mes_value

    cdef TBranch* tMtToPfMet_mes_minus_branch
    cdef float tMtToPfMet_mes_minus_value

    cdef TBranch* tMtToPfMet_mes_plus_branch
    cdef float tMtToPfMet_mes_plus_value

    cdef TBranch* tMtToPfMet_tes_branch
    cdef float tMtToPfMet_tes_value

    cdef TBranch* tMtToPfMet_tes_minus_branch
    cdef float tMtToPfMet_tes_minus_value

    cdef TBranch* tMtToPfMet_tes_plus_branch
    cdef float tMtToPfMet_tes_plus_value

    cdef TBranch* tMtToPfMet_ues_branch
    cdef float tMtToPfMet_ues_value

    cdef TBranch* tMtToPfMet_ues_minus_branch
    cdef float tMtToPfMet_ues_minus_value

    cdef TBranch* tMtToPfMet_ues_plus_branch
    cdef float tMtToPfMet_ues_plus_value

    cdef TBranch* tMuOverlap_branch
    cdef float tMuOverlap_value

    cdef TBranch* tMuonIdIsoStdVtxOverlap_branch
    cdef float tMuonIdIsoStdVtxOverlap_value

    cdef TBranch* tMuonIdIsoVtxOverlap_branch
    cdef float tMuonIdIsoVtxOverlap_value

    cdef TBranch* tMuonIdVtxOverlap_branch
    cdef float tMuonIdVtxOverlap_value

    cdef TBranch* tPhi_branch
    cdef float tPhi_value

    cdef TBranch* tPt_branch
    cdef float tPt_value

    cdef TBranch* tPt_ees_minus_branch
    cdef float tPt_ees_minus_value

    cdef TBranch* tPt_ees_plus_branch
    cdef float tPt_ees_plus_value

    cdef TBranch* tPt_tes_minus_branch
    cdef float tPt_tes_minus_value

    cdef TBranch* tPt_tes_plus_branch
    cdef float tPt_tes_plus_value

    cdef TBranch* tRank_branch
    cdef float tRank_value

    cdef TBranch* tRawIso3Hits_branch
    cdef float tRawIso3Hits_value

    cdef TBranch* tTNPId_branch
    cdef float tTNPId_value

    cdef TBranch* tTightIso_branch
    cdef float tTightIso_value

    cdef TBranch* tTightIso3Hits_branch
    cdef float tTightIso3Hits_value

    cdef TBranch* tTightIsoMVA3NewDMLT_branch
    cdef float tTightIsoMVA3NewDMLT_value

    cdef TBranch* tTightIsoMVA3NewDMNoLT_branch
    cdef float tTightIsoMVA3NewDMNoLT_value

    cdef TBranch* tTightIsoMVA3OldDMLT_branch
    cdef float tTightIsoMVA3OldDMLT_value

    cdef TBranch* tTightIsoMVA3OldDMNoLT_branch
    cdef float tTightIsoMVA3OldDMNoLT_value

    cdef TBranch* tToMETDPhi_branch
    cdef float tToMETDPhi_value

    cdef TBranch* tVLooseIso_branch
    cdef float tVLooseIso_value

    cdef TBranch* tVLooseIsoMVA3NewDMLT_branch
    cdef float tVLooseIsoMVA3NewDMLT_value

    cdef TBranch* tVLooseIsoMVA3NewDMNoLT_branch
    cdef float tVLooseIsoMVA3NewDMNoLT_value

    cdef TBranch* tVLooseIsoMVA3OldDMLT_branch
    cdef float tVLooseIsoMVA3OldDMLT_value

    cdef TBranch* tVLooseIsoMVA3OldDMNoLT_branch
    cdef float tVLooseIsoMVA3OldDMNoLT_value

    cdef TBranch* tVTightIsoMVA3NewDMLT_branch
    cdef float tVTightIsoMVA3NewDMLT_value

    cdef TBranch* tVTightIsoMVA3NewDMNoLT_branch
    cdef float tVTightIsoMVA3NewDMNoLT_value

    cdef TBranch* tVTightIsoMVA3OldDMLT_branch
    cdef float tVTightIsoMVA3OldDMLT_value

    cdef TBranch* tVTightIsoMVA3OldDMNoLT_branch
    cdef float tVTightIsoMVA3OldDMNoLT_value

    cdef TBranch* tVVTightIsoMVA3NewDMLT_branch
    cdef float tVVTightIsoMVA3NewDMLT_value

    cdef TBranch* tVVTightIsoMVA3NewDMNoLT_branch
    cdef float tVVTightIsoMVA3NewDMNoLT_value

    cdef TBranch* tVVTightIsoMVA3OldDMLT_branch
    cdef float tVVTightIsoMVA3OldDMLT_value

    cdef TBranch* tVVTightIsoMVA3OldDMNoLT_branch
    cdef float tVVTightIsoMVA3OldDMNoLT_value

    cdef TBranch* tVZ_branch
    cdef float tVZ_value

    cdef TBranch* tauVetoPt20EleLoose3MuTight_branch
    cdef float tauVetoPt20EleLoose3MuTight_value

    cdef TBranch* tauVetoPt20EleLoose3MuTight_tes_minus_branch
    cdef float tauVetoPt20EleLoose3MuTight_tes_minus_value

    cdef TBranch* tauVetoPt20EleLoose3MuTight_tes_plus_branch
    cdef float tauVetoPt20EleLoose3MuTight_tes_plus_value

    cdef TBranch* tauVetoPt20EleTight3MuLoose_branch
    cdef float tauVetoPt20EleTight3MuLoose_value

    cdef TBranch* tauVetoPt20EleTight3MuLoose_tes_minus_branch
    cdef float tauVetoPt20EleTight3MuLoose_tes_minus_value

    cdef TBranch* tauVetoPt20EleTight3MuLoose_tes_plus_branch
    cdef float tauVetoPt20EleTight3MuLoose_tes_plus_value

    cdef TBranch* tauVetoPt20Loose3HitsNewDMVtx_branch
    cdef float tauVetoPt20Loose3HitsNewDMVtx_value

    cdef TBranch* tauVetoPt20Loose3HitsVtx_branch
    cdef float tauVetoPt20Loose3HitsVtx_value

    cdef TBranch* tauVetoPt20TightMVALTNewDMVtx_branch
    cdef float tauVetoPt20TightMVALTNewDMVtx_value

    cdef TBranch* tauVetoPt20TightMVALTVtx_branch
    cdef float tauVetoPt20TightMVALTVtx_value

    cdef TBranch* tauVetoPt20TightMVANewDMVtx_branch
    cdef float tauVetoPt20TightMVANewDMVtx_value

    cdef TBranch* tauVetoPt20TightMVAVtx_branch
    cdef float tauVetoPt20TightMVAVtx_value

    cdef TBranch* tauVetoPt20VLooseHPSNewDMVtx_branch
    cdef float tauVetoPt20VLooseHPSNewDMVtx_value

    cdef TBranch* tauVetoPt20VLooseHPSVtx_branch
    cdef float tauVetoPt20VLooseHPSVtx_value

    cdef TBranch* tripleEGroup_branch
    cdef float tripleEGroup_value

    cdef TBranch* tripleEPass_branch
    cdef float tripleEPass_value

    cdef TBranch* tripleEPrescale_branch
    cdef float tripleEPrescale_value

    cdef TBranch* type1_pfMet_Et_branch
    cdef float type1_pfMet_Et_value

    cdef TBranch* type1_pfMet_Et_ues_minus_branch
    cdef float type1_pfMet_Et_ues_minus_value

    cdef TBranch* type1_pfMet_Et_ues_plus_branch
    cdef float type1_pfMet_Et_ues_plus_value

    cdef TBranch* type1_pfMet_Phi_branch
    cdef float type1_pfMet_Phi_value

    cdef TBranch* type1_pfMet_Pt_branch
    cdef float type1_pfMet_Pt_value

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
            warnings.warn( "EETauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "EETauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "EETauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "EETauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "EETauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "EETauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "EETauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "EETauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "EETauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "EETauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCSVVeto"
        self.bjetCSVVeto_branch = the_tree.GetBranch("bjetCSVVeto")
        #if not self.bjetCSVVeto_branch and "bjetCSVVeto" not in self.complained:
        if not self.bjetCSVVeto_branch and "bjetCSVVeto":
            warnings.warn( "EETauTree: Expected branch bjetCSVVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto")
        else:
            self.bjetCSVVeto_branch.SetAddress(<void*>&self.bjetCSVVeto_value)

        #print "making bjetCSVVeto30"
        self.bjetCSVVeto30_branch = the_tree.GetBranch("bjetCSVVeto30")
        #if not self.bjetCSVVeto30_branch and "bjetCSVVeto30" not in self.complained:
        if not self.bjetCSVVeto30_branch and "bjetCSVVeto30":
            warnings.warn( "EETauTree: Expected branch bjetCSVVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto30")
        else:
            self.bjetCSVVeto30_branch.SetAddress(<void*>&self.bjetCSVVeto30_value)

        #print "making bjetCSVVetoZHLike"
        self.bjetCSVVetoZHLike_branch = the_tree.GetBranch("bjetCSVVetoZHLike")
        #if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike" not in self.complained:
        if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike":
            warnings.warn( "EETauTree: Expected branch bjetCSVVetoZHLike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLike")
        else:
            self.bjetCSVVetoZHLike_branch.SetAddress(<void*>&self.bjetCSVVetoZHLike_value)

        #print "making bjetCSVVetoZHLikeNoJetId"
        self.bjetCSVVetoZHLikeNoJetId_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId")
        #if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId":
            warnings.warn( "EETauTree: Expected branch bjetCSVVetoZHLikeNoJetId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId")
        else:
            self.bjetCSVVetoZHLikeNoJetId_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_value)

        #print "making bjetVeto"
        self.bjetVeto_branch = the_tree.GetBranch("bjetVeto")
        #if not self.bjetVeto_branch and "bjetVeto" not in self.complained:
        if not self.bjetVeto_branch and "bjetVeto":
            warnings.warn( "EETauTree: Expected branch bjetVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetVeto")
        else:
            self.bjetVeto_branch.SetAddress(<void*>&self.bjetVeto_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "EETauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making doubleEExtraGroup"
        self.doubleEExtraGroup_branch = the_tree.GetBranch("doubleEExtraGroup")
        #if not self.doubleEExtraGroup_branch and "doubleEExtraGroup" not in self.complained:
        if not self.doubleEExtraGroup_branch and "doubleEExtraGroup":
            warnings.warn( "EETauTree: Expected branch doubleEExtraGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraGroup")
        else:
            self.doubleEExtraGroup_branch.SetAddress(<void*>&self.doubleEExtraGroup_value)

        #print "making doubleEExtraPass"
        self.doubleEExtraPass_branch = the_tree.GetBranch("doubleEExtraPass")
        #if not self.doubleEExtraPass_branch and "doubleEExtraPass" not in self.complained:
        if not self.doubleEExtraPass_branch and "doubleEExtraPass":
            warnings.warn( "EETauTree: Expected branch doubleEExtraPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPass")
        else:
            self.doubleEExtraPass_branch.SetAddress(<void*>&self.doubleEExtraPass_value)

        #print "making doubleEExtraPrescale"
        self.doubleEExtraPrescale_branch = the_tree.GetBranch("doubleEExtraPrescale")
        #if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale" not in self.complained:
        if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale":
            warnings.warn( "EETauTree: Expected branch doubleEExtraPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPrescale")
        else:
            self.doubleEExtraPrescale_branch.SetAddress(<void*>&self.doubleEExtraPrescale_value)

        #print "making doubleEGroup"
        self.doubleEGroup_branch = the_tree.GetBranch("doubleEGroup")
        #if not self.doubleEGroup_branch and "doubleEGroup" not in self.complained:
        if not self.doubleEGroup_branch and "doubleEGroup":
            warnings.warn( "EETauTree: Expected branch doubleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEGroup")
        else:
            self.doubleEGroup_branch.SetAddress(<void*>&self.doubleEGroup_value)

        #print "making doubleEPass"
        self.doubleEPass_branch = the_tree.GetBranch("doubleEPass")
        #if not self.doubleEPass_branch and "doubleEPass" not in self.complained:
        if not self.doubleEPass_branch and "doubleEPass":
            warnings.warn( "EETauTree: Expected branch doubleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPass")
        else:
            self.doubleEPass_branch.SetAddress(<void*>&self.doubleEPass_value)

        #print "making doubleEPrescale"
        self.doubleEPrescale_branch = the_tree.GetBranch("doubleEPrescale")
        #if not self.doubleEPrescale_branch and "doubleEPrescale" not in self.complained:
        if not self.doubleEPrescale_branch and "doubleEPrescale":
            warnings.warn( "EETauTree: Expected branch doubleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPrescale")
        else:
            self.doubleEPrescale_branch.SetAddress(<void*>&self.doubleEPrescale_value)

        #print "making doubleETightGroup"
        self.doubleETightGroup_branch = the_tree.GetBranch("doubleETightGroup")
        #if not self.doubleETightGroup_branch and "doubleETightGroup" not in self.complained:
        if not self.doubleETightGroup_branch and "doubleETightGroup":
            warnings.warn( "EETauTree: Expected branch doubleETightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightGroup")
        else:
            self.doubleETightGroup_branch.SetAddress(<void*>&self.doubleETightGroup_value)

        #print "making doubleETightPass"
        self.doubleETightPass_branch = the_tree.GetBranch("doubleETightPass")
        #if not self.doubleETightPass_branch and "doubleETightPass" not in self.complained:
        if not self.doubleETightPass_branch and "doubleETightPass":
            warnings.warn( "EETauTree: Expected branch doubleETightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPass")
        else:
            self.doubleETightPass_branch.SetAddress(<void*>&self.doubleETightPass_value)

        #print "making doubleETightPrescale"
        self.doubleETightPrescale_branch = the_tree.GetBranch("doubleETightPrescale")
        #if not self.doubleETightPrescale_branch and "doubleETightPrescale" not in self.complained:
        if not self.doubleETightPrescale_branch and "doubleETightPrescale":
            warnings.warn( "EETauTree: Expected branch doubleETightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPrescale")
        else:
            self.doubleETightPrescale_branch.SetAddress(<void*>&self.doubleETightPrescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "EETauTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "EETauTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "EETauTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuTrkGroup"
        self.doubleMuTrkGroup_branch = the_tree.GetBranch("doubleMuTrkGroup")
        #if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup" not in self.complained:
        if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup":
            warnings.warn( "EETauTree: Expected branch doubleMuTrkGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkGroup")
        else:
            self.doubleMuTrkGroup_branch.SetAddress(<void*>&self.doubleMuTrkGroup_value)

        #print "making doubleMuTrkPass"
        self.doubleMuTrkPass_branch = the_tree.GetBranch("doubleMuTrkPass")
        #if not self.doubleMuTrkPass_branch and "doubleMuTrkPass" not in self.complained:
        if not self.doubleMuTrkPass_branch and "doubleMuTrkPass":
            warnings.warn( "EETauTree: Expected branch doubleMuTrkPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPass")
        else:
            self.doubleMuTrkPass_branch.SetAddress(<void*>&self.doubleMuTrkPass_value)

        #print "making doubleMuTrkPrescale"
        self.doubleMuTrkPrescale_branch = the_tree.GetBranch("doubleMuTrkPrescale")
        #if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale" not in self.complained:
        if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale":
            warnings.warn( "EETauTree: Expected branch doubleMuTrkPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPrescale")
        else:
            self.doubleMuTrkPrescale_branch.SetAddress(<void*>&self.doubleMuTrkPrescale_value)

        #print "making doublePhoGroup"
        self.doublePhoGroup_branch = the_tree.GetBranch("doublePhoGroup")
        #if not self.doublePhoGroup_branch and "doublePhoGroup" not in self.complained:
        if not self.doublePhoGroup_branch and "doublePhoGroup":
            warnings.warn( "EETauTree: Expected branch doublePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoGroup")
        else:
            self.doublePhoGroup_branch.SetAddress(<void*>&self.doublePhoGroup_value)

        #print "making doublePhoPass"
        self.doublePhoPass_branch = the_tree.GetBranch("doublePhoPass")
        #if not self.doublePhoPass_branch and "doublePhoPass" not in self.complained:
        if not self.doublePhoPass_branch and "doublePhoPass":
            warnings.warn( "EETauTree: Expected branch doublePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPass")
        else:
            self.doublePhoPass_branch.SetAddress(<void*>&self.doublePhoPass_value)

        #print "making doublePhoPrescale"
        self.doublePhoPrescale_branch = the_tree.GetBranch("doublePhoPrescale")
        #if not self.doublePhoPrescale_branch and "doublePhoPrescale" not in self.complained:
        if not self.doublePhoPrescale_branch and "doublePhoPrescale":
            warnings.warn( "EETauTree: Expected branch doublePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPrescale")
        else:
            self.doublePhoPrescale_branch.SetAddress(<void*>&self.doublePhoPrescale_value)

        #print "making e1AbsEta"
        self.e1AbsEta_branch = the_tree.GetBranch("e1AbsEta")
        #if not self.e1AbsEta_branch and "e1AbsEta" not in self.complained:
        if not self.e1AbsEta_branch and "e1AbsEta":
            warnings.warn( "EETauTree: Expected branch e1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1AbsEta")
        else:
            self.e1AbsEta_branch.SetAddress(<void*>&self.e1AbsEta_value)

        #print "making e1CBID_LOOSE"
        self.e1CBID_LOOSE_branch = the_tree.GetBranch("e1CBID_LOOSE")
        #if not self.e1CBID_LOOSE_branch and "e1CBID_LOOSE" not in self.complained:
        if not self.e1CBID_LOOSE_branch and "e1CBID_LOOSE":
            warnings.warn( "EETauTree: Expected branch e1CBID_LOOSE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBID_LOOSE")
        else:
            self.e1CBID_LOOSE_branch.SetAddress(<void*>&self.e1CBID_LOOSE_value)

        #print "making e1CBID_MEDIUM"
        self.e1CBID_MEDIUM_branch = the_tree.GetBranch("e1CBID_MEDIUM")
        #if not self.e1CBID_MEDIUM_branch and "e1CBID_MEDIUM" not in self.complained:
        if not self.e1CBID_MEDIUM_branch and "e1CBID_MEDIUM":
            warnings.warn( "EETauTree: Expected branch e1CBID_MEDIUM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBID_MEDIUM")
        else:
            self.e1CBID_MEDIUM_branch.SetAddress(<void*>&self.e1CBID_MEDIUM_value)

        #print "making e1CBID_TIGHT"
        self.e1CBID_TIGHT_branch = the_tree.GetBranch("e1CBID_TIGHT")
        #if not self.e1CBID_TIGHT_branch and "e1CBID_TIGHT" not in self.complained:
        if not self.e1CBID_TIGHT_branch and "e1CBID_TIGHT":
            warnings.warn( "EETauTree: Expected branch e1CBID_TIGHT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBID_TIGHT")
        else:
            self.e1CBID_TIGHT_branch.SetAddress(<void*>&self.e1CBID_TIGHT_value)

        #print "making e1CBID_VETO"
        self.e1CBID_VETO_branch = the_tree.GetBranch("e1CBID_VETO")
        #if not self.e1CBID_VETO_branch and "e1CBID_VETO" not in self.complained:
        if not self.e1CBID_VETO_branch and "e1CBID_VETO":
            warnings.warn( "EETauTree: Expected branch e1CBID_VETO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBID_VETO")
        else:
            self.e1CBID_VETO_branch.SetAddress(<void*>&self.e1CBID_VETO_value)

        #print "making e1Charge"
        self.e1Charge_branch = the_tree.GetBranch("e1Charge")
        #if not self.e1Charge_branch and "e1Charge" not in self.complained:
        if not self.e1Charge_branch and "e1Charge":
            warnings.warn( "EETauTree: Expected branch e1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Charge")
        else:
            self.e1Charge_branch.SetAddress(<void*>&self.e1Charge_value)

        #print "making e1ChargeIdLoose"
        self.e1ChargeIdLoose_branch = the_tree.GetBranch("e1ChargeIdLoose")
        #if not self.e1ChargeIdLoose_branch and "e1ChargeIdLoose" not in self.complained:
        if not self.e1ChargeIdLoose_branch and "e1ChargeIdLoose":
            warnings.warn( "EETauTree: Expected branch e1ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdLoose")
        else:
            self.e1ChargeIdLoose_branch.SetAddress(<void*>&self.e1ChargeIdLoose_value)

        #print "making e1ChargeIdMed"
        self.e1ChargeIdMed_branch = the_tree.GetBranch("e1ChargeIdMed")
        #if not self.e1ChargeIdMed_branch and "e1ChargeIdMed" not in self.complained:
        if not self.e1ChargeIdMed_branch and "e1ChargeIdMed":
            warnings.warn( "EETauTree: Expected branch e1ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdMed")
        else:
            self.e1ChargeIdMed_branch.SetAddress(<void*>&self.e1ChargeIdMed_value)

        #print "making e1ChargeIdTight"
        self.e1ChargeIdTight_branch = the_tree.GetBranch("e1ChargeIdTight")
        #if not self.e1ChargeIdTight_branch and "e1ChargeIdTight" not in self.complained:
        if not self.e1ChargeIdTight_branch and "e1ChargeIdTight":
            warnings.warn( "EETauTree: Expected branch e1ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdTight")
        else:
            self.e1ChargeIdTight_branch.SetAddress(<void*>&self.e1ChargeIdTight_value)

        #print "making e1CiCTight"
        self.e1CiCTight_branch = the_tree.GetBranch("e1CiCTight")
        #if not self.e1CiCTight_branch and "e1CiCTight" not in self.complained:
        if not self.e1CiCTight_branch and "e1CiCTight":
            warnings.warn( "EETauTree: Expected branch e1CiCTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CiCTight")
        else:
            self.e1CiCTight_branch.SetAddress(<void*>&self.e1CiCTight_value)

        #print "making e1ComesFromHiggs"
        self.e1ComesFromHiggs_branch = the_tree.GetBranch("e1ComesFromHiggs")
        #if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs" not in self.complained:
        if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs":
            warnings.warn( "EETauTree: Expected branch e1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ComesFromHiggs")
        else:
            self.e1ComesFromHiggs_branch.SetAddress(<void*>&self.e1ComesFromHiggs_value)

        #print "making e1DZ"
        self.e1DZ_branch = the_tree.GetBranch("e1DZ")
        #if not self.e1DZ_branch and "e1DZ" not in self.complained:
        if not self.e1DZ_branch and "e1DZ":
            warnings.warn( "EETauTree: Expected branch e1DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1DZ")
        else:
            self.e1DZ_branch.SetAddress(<void*>&self.e1DZ_value)

        #print "making e1E1x5"
        self.e1E1x5_branch = the_tree.GetBranch("e1E1x5")
        #if not self.e1E1x5_branch and "e1E1x5" not in self.complained:
        if not self.e1E1x5_branch and "e1E1x5":
            warnings.warn( "EETauTree: Expected branch e1E1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1E1x5")
        else:
            self.e1E1x5_branch.SetAddress(<void*>&self.e1E1x5_value)

        #print "making e1E2x5Max"
        self.e1E2x5Max_branch = the_tree.GetBranch("e1E2x5Max")
        #if not self.e1E2x5Max_branch and "e1E2x5Max" not in self.complained:
        if not self.e1E2x5Max_branch and "e1E2x5Max":
            warnings.warn( "EETauTree: Expected branch e1E2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1E2x5Max")
        else:
            self.e1E2x5Max_branch.SetAddress(<void*>&self.e1E2x5Max_value)

        #print "making e1E5x5"
        self.e1E5x5_branch = the_tree.GetBranch("e1E5x5")
        #if not self.e1E5x5_branch and "e1E5x5" not in self.complained:
        if not self.e1E5x5_branch and "e1E5x5":
            warnings.warn( "EETauTree: Expected branch e1E5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1E5x5")
        else:
            self.e1E5x5_branch.SetAddress(<void*>&self.e1E5x5_value)

        #print "making e1ECorrReg_2012Jul13ReReco"
        self.e1ECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1ECorrReg_2012Jul13ReReco")
        #if not self.e1ECorrReg_2012Jul13ReReco_branch and "e1ECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1ECorrReg_2012Jul13ReReco_branch and "e1ECorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1ECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrReg_2012Jul13ReReco")
        else:
            self.e1ECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1ECorrReg_2012Jul13ReReco_value)

        #print "making e1ECorrReg_Fall11"
        self.e1ECorrReg_Fall11_branch = the_tree.GetBranch("e1ECorrReg_Fall11")
        #if not self.e1ECorrReg_Fall11_branch and "e1ECorrReg_Fall11" not in self.complained:
        if not self.e1ECorrReg_Fall11_branch and "e1ECorrReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1ECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrReg_Fall11")
        else:
            self.e1ECorrReg_Fall11_branch.SetAddress(<void*>&self.e1ECorrReg_Fall11_value)

        #print "making e1ECorrReg_Jan16ReReco"
        self.e1ECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1ECorrReg_Jan16ReReco")
        #if not self.e1ECorrReg_Jan16ReReco_branch and "e1ECorrReg_Jan16ReReco" not in self.complained:
        if not self.e1ECorrReg_Jan16ReReco_branch and "e1ECorrReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1ECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrReg_Jan16ReReco")
        else:
            self.e1ECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1ECorrReg_Jan16ReReco_value)

        #print "making e1ECorrReg_Summer12_DR53X_HCP2012"
        self.e1ECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1ECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1ECorrReg_Summer12_DR53X_HCP2012_branch and "e1ECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1ECorrReg_Summer12_DR53X_HCP2012_branch and "e1ECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1ECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1ECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1ECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1ECorrSmearedNoReg_2012Jul13ReReco"
        self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1ECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch and "e1ECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch and "e1ECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1ECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1ECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1ECorrSmearedNoReg_Fall11"
        self.e1ECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1ECorrSmearedNoReg_Fall11")
        #if not self.e1ECorrSmearedNoReg_Fall11_branch and "e1ECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1ECorrSmearedNoReg_Fall11_branch and "e1ECorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1ECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedNoReg_Fall11")
        else:
            self.e1ECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1ECorrSmearedNoReg_Fall11_value)

        #print "making e1ECorrSmearedNoReg_Jan16ReReco"
        self.e1ECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1ECorrSmearedNoReg_Jan16ReReco")
        #if not self.e1ECorrSmearedNoReg_Jan16ReReco_branch and "e1ECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1ECorrSmearedNoReg_Jan16ReReco_branch and "e1ECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1ECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1ECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1ECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1ECorrSmearedReg_2012Jul13ReReco"
        self.e1ECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1ECorrSmearedReg_2012Jul13ReReco")
        #if not self.e1ECorrSmearedReg_2012Jul13ReReco_branch and "e1ECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1ECorrSmearedReg_2012Jul13ReReco_branch and "e1ECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1ECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1ECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1ECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1ECorrSmearedReg_Fall11"
        self.e1ECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1ECorrSmearedReg_Fall11")
        #if not self.e1ECorrSmearedReg_Fall11_branch and "e1ECorrSmearedReg_Fall11" not in self.complained:
        if not self.e1ECorrSmearedReg_Fall11_branch and "e1ECorrSmearedReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1ECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedReg_Fall11")
        else:
            self.e1ECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1ECorrSmearedReg_Fall11_value)

        #print "making e1ECorrSmearedReg_Jan16ReReco"
        self.e1ECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1ECorrSmearedReg_Jan16ReReco")
        #if not self.e1ECorrSmearedReg_Jan16ReReco_branch and "e1ECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1ECorrSmearedReg_Jan16ReReco_branch and "e1ECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1ECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedReg_Jan16ReReco")
        else:
            self.e1ECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1ECorrSmearedReg_Jan16ReReco_value)

        #print "making e1ECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1ECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1ECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1ECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1ECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1EcalIsoDR03"
        self.e1EcalIsoDR03_branch = the_tree.GetBranch("e1EcalIsoDR03")
        #if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03" not in self.complained:
        if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03":
            warnings.warn( "EETauTree: Expected branch e1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EcalIsoDR03")
        else:
            self.e1EcalIsoDR03_branch.SetAddress(<void*>&self.e1EcalIsoDR03_value)

        #print "making e1EffectiveArea2011Data"
        self.e1EffectiveArea2011Data_branch = the_tree.GetBranch("e1EffectiveArea2011Data")
        #if not self.e1EffectiveArea2011Data_branch and "e1EffectiveArea2011Data" not in self.complained:
        if not self.e1EffectiveArea2011Data_branch and "e1EffectiveArea2011Data":
            warnings.warn( "EETauTree: Expected branch e1EffectiveArea2011Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EffectiveArea2011Data")
        else:
            self.e1EffectiveArea2011Data_branch.SetAddress(<void*>&self.e1EffectiveArea2011Data_value)

        #print "making e1EffectiveArea2012Data"
        self.e1EffectiveArea2012Data_branch = the_tree.GetBranch("e1EffectiveArea2012Data")
        #if not self.e1EffectiveArea2012Data_branch and "e1EffectiveArea2012Data" not in self.complained:
        if not self.e1EffectiveArea2012Data_branch and "e1EffectiveArea2012Data":
            warnings.warn( "EETauTree: Expected branch e1EffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EffectiveArea2012Data")
        else:
            self.e1EffectiveArea2012Data_branch.SetAddress(<void*>&self.e1EffectiveArea2012Data_value)

        #print "making e1EffectiveAreaFall11MC"
        self.e1EffectiveAreaFall11MC_branch = the_tree.GetBranch("e1EffectiveAreaFall11MC")
        #if not self.e1EffectiveAreaFall11MC_branch and "e1EffectiveAreaFall11MC" not in self.complained:
        if not self.e1EffectiveAreaFall11MC_branch and "e1EffectiveAreaFall11MC":
            warnings.warn( "EETauTree: Expected branch e1EffectiveAreaFall11MC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EffectiveAreaFall11MC")
        else:
            self.e1EffectiveAreaFall11MC_branch.SetAddress(<void*>&self.e1EffectiveAreaFall11MC_value)

        #print "making e1Ele27WP80PFMT50PFMTFilter"
        self.e1Ele27WP80PFMT50PFMTFilter_branch = the_tree.GetBranch("e1Ele27WP80PFMT50PFMTFilter")
        #if not self.e1Ele27WP80PFMT50PFMTFilter_branch and "e1Ele27WP80PFMT50PFMTFilter" not in self.complained:
        if not self.e1Ele27WP80PFMT50PFMTFilter_branch and "e1Ele27WP80PFMT50PFMTFilter":
            warnings.warn( "EETauTree: Expected branch e1Ele27WP80PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Ele27WP80PFMT50PFMTFilter")
        else:
            self.e1Ele27WP80PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e1Ele27WP80PFMT50PFMTFilter_value)

        #print "making e1Ele27WP80TrackIsoMatchFilter"
        self.e1Ele27WP80TrackIsoMatchFilter_branch = the_tree.GetBranch("e1Ele27WP80TrackIsoMatchFilter")
        #if not self.e1Ele27WP80TrackIsoMatchFilter_branch and "e1Ele27WP80TrackIsoMatchFilter" not in self.complained:
        if not self.e1Ele27WP80TrackIsoMatchFilter_branch and "e1Ele27WP80TrackIsoMatchFilter":
            warnings.warn( "EETauTree: Expected branch e1Ele27WP80TrackIsoMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Ele27WP80TrackIsoMatchFilter")
        else:
            self.e1Ele27WP80TrackIsoMatchFilter_branch.SetAddress(<void*>&self.e1Ele27WP80TrackIsoMatchFilter_value)

        #print "making e1Ele32WP70PFMT50PFMTFilter"
        self.e1Ele32WP70PFMT50PFMTFilter_branch = the_tree.GetBranch("e1Ele32WP70PFMT50PFMTFilter")
        #if not self.e1Ele32WP70PFMT50PFMTFilter_branch and "e1Ele32WP70PFMT50PFMTFilter" not in self.complained:
        if not self.e1Ele32WP70PFMT50PFMTFilter_branch and "e1Ele32WP70PFMT50PFMTFilter":
            warnings.warn( "EETauTree: Expected branch e1Ele32WP70PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Ele32WP70PFMT50PFMTFilter")
        else:
            self.e1Ele32WP70PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e1Ele32WP70PFMT50PFMTFilter_value)

        #print "making e1EnergyError"
        self.e1EnergyError_branch = the_tree.GetBranch("e1EnergyError")
        #if not self.e1EnergyError_branch and "e1EnergyError" not in self.complained:
        if not self.e1EnergyError_branch and "e1EnergyError":
            warnings.warn( "EETauTree: Expected branch e1EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyError")
        else:
            self.e1EnergyError_branch.SetAddress(<void*>&self.e1EnergyError_value)

        #print "making e1Eta"
        self.e1Eta_branch = the_tree.GetBranch("e1Eta")
        #if not self.e1Eta_branch and "e1Eta" not in self.complained:
        if not self.e1Eta_branch and "e1Eta":
            warnings.warn( "EETauTree: Expected branch e1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Eta")
        else:
            self.e1Eta_branch.SetAddress(<void*>&self.e1Eta_value)

        #print "making e1EtaCorrReg_2012Jul13ReReco"
        self.e1EtaCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1EtaCorrReg_2012Jul13ReReco")
        #if not self.e1EtaCorrReg_2012Jul13ReReco_branch and "e1EtaCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1EtaCorrReg_2012Jul13ReReco_branch and "e1EtaCorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1EtaCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrReg_2012Jul13ReReco")
        else:
            self.e1EtaCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1EtaCorrReg_2012Jul13ReReco_value)

        #print "making e1EtaCorrReg_Fall11"
        self.e1EtaCorrReg_Fall11_branch = the_tree.GetBranch("e1EtaCorrReg_Fall11")
        #if not self.e1EtaCorrReg_Fall11_branch and "e1EtaCorrReg_Fall11" not in self.complained:
        if not self.e1EtaCorrReg_Fall11_branch and "e1EtaCorrReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1EtaCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrReg_Fall11")
        else:
            self.e1EtaCorrReg_Fall11_branch.SetAddress(<void*>&self.e1EtaCorrReg_Fall11_value)

        #print "making e1EtaCorrReg_Jan16ReReco"
        self.e1EtaCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1EtaCorrReg_Jan16ReReco")
        #if not self.e1EtaCorrReg_Jan16ReReco_branch and "e1EtaCorrReg_Jan16ReReco" not in self.complained:
        if not self.e1EtaCorrReg_Jan16ReReco_branch and "e1EtaCorrReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1EtaCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrReg_Jan16ReReco")
        else:
            self.e1EtaCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1EtaCorrReg_Jan16ReReco_value)

        #print "making e1EtaCorrReg_Summer12_DR53X_HCP2012"
        self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1EtaCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1EtaCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1EtaCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1EtaCorrSmearedNoReg_2012Jul13ReReco"
        self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1EtaCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e1EtaCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e1EtaCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1EtaCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1EtaCorrSmearedNoReg_Fall11"
        self.e1EtaCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1EtaCorrSmearedNoReg_Fall11")
        #if not self.e1EtaCorrSmearedNoReg_Fall11_branch and "e1EtaCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1EtaCorrSmearedNoReg_Fall11_branch and "e1EtaCorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1EtaCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedNoReg_Fall11")
        else:
            self.e1EtaCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1EtaCorrSmearedNoReg_Fall11_value)

        #print "making e1EtaCorrSmearedNoReg_Jan16ReReco"
        self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1EtaCorrSmearedNoReg_Jan16ReReco")
        #if not self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch and "e1EtaCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch and "e1EtaCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1EtaCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1EtaCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1EtaCorrSmearedReg_2012Jul13ReReco"
        self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1EtaCorrSmearedReg_2012Jul13ReReco")
        #if not self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch and "e1EtaCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch and "e1EtaCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1EtaCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1EtaCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1EtaCorrSmearedReg_Fall11"
        self.e1EtaCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1EtaCorrSmearedReg_Fall11")
        #if not self.e1EtaCorrSmearedReg_Fall11_branch and "e1EtaCorrSmearedReg_Fall11" not in self.complained:
        if not self.e1EtaCorrSmearedReg_Fall11_branch and "e1EtaCorrSmearedReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1EtaCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedReg_Fall11")
        else:
            self.e1EtaCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1EtaCorrSmearedReg_Fall11_value)

        #print "making e1EtaCorrSmearedReg_Jan16ReReco"
        self.e1EtaCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1EtaCorrSmearedReg_Jan16ReReco")
        #if not self.e1EtaCorrSmearedReg_Jan16ReReco_branch and "e1EtaCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1EtaCorrSmearedReg_Jan16ReReco_branch and "e1EtaCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1EtaCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedReg_Jan16ReReco")
        else:
            self.e1EtaCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1EtaCorrSmearedReg_Jan16ReReco_value)

        #print "making e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1GenCharge"
        self.e1GenCharge_branch = the_tree.GetBranch("e1GenCharge")
        #if not self.e1GenCharge_branch and "e1GenCharge" not in self.complained:
        if not self.e1GenCharge_branch and "e1GenCharge":
            warnings.warn( "EETauTree: Expected branch e1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenCharge")
        else:
            self.e1GenCharge_branch.SetAddress(<void*>&self.e1GenCharge_value)

        #print "making e1GenEnergy"
        self.e1GenEnergy_branch = the_tree.GetBranch("e1GenEnergy")
        #if not self.e1GenEnergy_branch and "e1GenEnergy" not in self.complained:
        if not self.e1GenEnergy_branch and "e1GenEnergy":
            warnings.warn( "EETauTree: Expected branch e1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenEnergy")
        else:
            self.e1GenEnergy_branch.SetAddress(<void*>&self.e1GenEnergy_value)

        #print "making e1GenEta"
        self.e1GenEta_branch = the_tree.GetBranch("e1GenEta")
        #if not self.e1GenEta_branch and "e1GenEta" not in self.complained:
        if not self.e1GenEta_branch and "e1GenEta":
            warnings.warn( "EETauTree: Expected branch e1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenEta")
        else:
            self.e1GenEta_branch.SetAddress(<void*>&self.e1GenEta_value)

        #print "making e1GenMotherPdgId"
        self.e1GenMotherPdgId_branch = the_tree.GetBranch("e1GenMotherPdgId")
        #if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId" not in self.complained:
        if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId":
            warnings.warn( "EETauTree: Expected branch e1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenMotherPdgId")
        else:
            self.e1GenMotherPdgId_branch.SetAddress(<void*>&self.e1GenMotherPdgId_value)

        #print "making e1GenPdgId"
        self.e1GenPdgId_branch = the_tree.GetBranch("e1GenPdgId")
        #if not self.e1GenPdgId_branch and "e1GenPdgId" not in self.complained:
        if not self.e1GenPdgId_branch and "e1GenPdgId":
            warnings.warn( "EETauTree: Expected branch e1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPdgId")
        else:
            self.e1GenPdgId_branch.SetAddress(<void*>&self.e1GenPdgId_value)

        #print "making e1GenPhi"
        self.e1GenPhi_branch = the_tree.GetBranch("e1GenPhi")
        #if not self.e1GenPhi_branch and "e1GenPhi" not in self.complained:
        if not self.e1GenPhi_branch and "e1GenPhi":
            warnings.warn( "EETauTree: Expected branch e1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPhi")
        else:
            self.e1GenPhi_branch.SetAddress(<void*>&self.e1GenPhi_value)

        #print "making e1HadronicDepth1OverEm"
        self.e1HadronicDepth1OverEm_branch = the_tree.GetBranch("e1HadronicDepth1OverEm")
        #if not self.e1HadronicDepth1OverEm_branch and "e1HadronicDepth1OverEm" not in self.complained:
        if not self.e1HadronicDepth1OverEm_branch and "e1HadronicDepth1OverEm":
            warnings.warn( "EETauTree: Expected branch e1HadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HadronicDepth1OverEm")
        else:
            self.e1HadronicDepth1OverEm_branch.SetAddress(<void*>&self.e1HadronicDepth1OverEm_value)

        #print "making e1HadronicDepth2OverEm"
        self.e1HadronicDepth2OverEm_branch = the_tree.GetBranch("e1HadronicDepth2OverEm")
        #if not self.e1HadronicDepth2OverEm_branch and "e1HadronicDepth2OverEm" not in self.complained:
        if not self.e1HadronicDepth2OverEm_branch and "e1HadronicDepth2OverEm":
            warnings.warn( "EETauTree: Expected branch e1HadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HadronicDepth2OverEm")
        else:
            self.e1HadronicDepth2OverEm_branch.SetAddress(<void*>&self.e1HadronicDepth2OverEm_value)

        #print "making e1HadronicOverEM"
        self.e1HadronicOverEM_branch = the_tree.GetBranch("e1HadronicOverEM")
        #if not self.e1HadronicOverEM_branch and "e1HadronicOverEM" not in self.complained:
        if not self.e1HadronicOverEM_branch and "e1HadronicOverEM":
            warnings.warn( "EETauTree: Expected branch e1HadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HadronicOverEM")
        else:
            self.e1HadronicOverEM_branch.SetAddress(<void*>&self.e1HadronicOverEM_value)

        #print "making e1HasConversion"
        self.e1HasConversion_branch = the_tree.GetBranch("e1HasConversion")
        #if not self.e1HasConversion_branch and "e1HasConversion" not in self.complained:
        if not self.e1HasConversion_branch and "e1HasConversion":
            warnings.warn( "EETauTree: Expected branch e1HasConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HasConversion")
        else:
            self.e1HasConversion_branch.SetAddress(<void*>&self.e1HasConversion_value)

        #print "making e1HasMatchedConversion"
        self.e1HasMatchedConversion_branch = the_tree.GetBranch("e1HasMatchedConversion")
        #if not self.e1HasMatchedConversion_branch and "e1HasMatchedConversion" not in self.complained:
        if not self.e1HasMatchedConversion_branch and "e1HasMatchedConversion":
            warnings.warn( "EETauTree: Expected branch e1HasMatchedConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HasMatchedConversion")
        else:
            self.e1HasMatchedConversion_branch.SetAddress(<void*>&self.e1HasMatchedConversion_value)

        #print "making e1HcalIsoDR03"
        self.e1HcalIsoDR03_branch = the_tree.GetBranch("e1HcalIsoDR03")
        #if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03" not in self.complained:
        if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03":
            warnings.warn( "EETauTree: Expected branch e1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HcalIsoDR03")
        else:
            self.e1HcalIsoDR03_branch.SetAddress(<void*>&self.e1HcalIsoDR03_value)

        #print "making e1IP3DS"
        self.e1IP3DS_branch = the_tree.GetBranch("e1IP3DS")
        #if not self.e1IP3DS_branch and "e1IP3DS" not in self.complained:
        if not self.e1IP3DS_branch and "e1IP3DS":
            warnings.warn( "EETauTree: Expected branch e1IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IP3DS")
        else:
            self.e1IP3DS_branch.SetAddress(<void*>&self.e1IP3DS_value)

        #print "making e1JetArea"
        self.e1JetArea_branch = the_tree.GetBranch("e1JetArea")
        #if not self.e1JetArea_branch and "e1JetArea" not in self.complained:
        if not self.e1JetArea_branch and "e1JetArea":
            warnings.warn( "EETauTree: Expected branch e1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetArea")
        else:
            self.e1JetArea_branch.SetAddress(<void*>&self.e1JetArea_value)

        #print "making e1JetBtag"
        self.e1JetBtag_branch = the_tree.GetBranch("e1JetBtag")
        #if not self.e1JetBtag_branch and "e1JetBtag" not in self.complained:
        if not self.e1JetBtag_branch and "e1JetBtag":
            warnings.warn( "EETauTree: Expected branch e1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetBtag")
        else:
            self.e1JetBtag_branch.SetAddress(<void*>&self.e1JetBtag_value)

        #print "making e1JetCSVBtag"
        self.e1JetCSVBtag_branch = the_tree.GetBranch("e1JetCSVBtag")
        #if not self.e1JetCSVBtag_branch and "e1JetCSVBtag" not in self.complained:
        if not self.e1JetCSVBtag_branch and "e1JetCSVBtag":
            warnings.warn( "EETauTree: Expected branch e1JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetCSVBtag")
        else:
            self.e1JetCSVBtag_branch.SetAddress(<void*>&self.e1JetCSVBtag_value)

        #print "making e1JetEtaEtaMoment"
        self.e1JetEtaEtaMoment_branch = the_tree.GetBranch("e1JetEtaEtaMoment")
        #if not self.e1JetEtaEtaMoment_branch and "e1JetEtaEtaMoment" not in self.complained:
        if not self.e1JetEtaEtaMoment_branch and "e1JetEtaEtaMoment":
            warnings.warn( "EETauTree: Expected branch e1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaEtaMoment")
        else:
            self.e1JetEtaEtaMoment_branch.SetAddress(<void*>&self.e1JetEtaEtaMoment_value)

        #print "making e1JetEtaPhiMoment"
        self.e1JetEtaPhiMoment_branch = the_tree.GetBranch("e1JetEtaPhiMoment")
        #if not self.e1JetEtaPhiMoment_branch and "e1JetEtaPhiMoment" not in self.complained:
        if not self.e1JetEtaPhiMoment_branch and "e1JetEtaPhiMoment":
            warnings.warn( "EETauTree: Expected branch e1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaPhiMoment")
        else:
            self.e1JetEtaPhiMoment_branch.SetAddress(<void*>&self.e1JetEtaPhiMoment_value)

        #print "making e1JetEtaPhiSpread"
        self.e1JetEtaPhiSpread_branch = the_tree.GetBranch("e1JetEtaPhiSpread")
        #if not self.e1JetEtaPhiSpread_branch and "e1JetEtaPhiSpread" not in self.complained:
        if not self.e1JetEtaPhiSpread_branch and "e1JetEtaPhiSpread":
            warnings.warn( "EETauTree: Expected branch e1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaPhiSpread")
        else:
            self.e1JetEtaPhiSpread_branch.SetAddress(<void*>&self.e1JetEtaPhiSpread_value)

        #print "making e1JetPhiPhiMoment"
        self.e1JetPhiPhiMoment_branch = the_tree.GetBranch("e1JetPhiPhiMoment")
        #if not self.e1JetPhiPhiMoment_branch and "e1JetPhiPhiMoment" not in self.complained:
        if not self.e1JetPhiPhiMoment_branch and "e1JetPhiPhiMoment":
            warnings.warn( "EETauTree: Expected branch e1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPhiPhiMoment")
        else:
            self.e1JetPhiPhiMoment_branch.SetAddress(<void*>&self.e1JetPhiPhiMoment_value)

        #print "making e1JetPt"
        self.e1JetPt_branch = the_tree.GetBranch("e1JetPt")
        #if not self.e1JetPt_branch and "e1JetPt" not in self.complained:
        if not self.e1JetPt_branch and "e1JetPt":
            warnings.warn( "EETauTree: Expected branch e1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPt")
        else:
            self.e1JetPt_branch.SetAddress(<void*>&self.e1JetPt_value)

        #print "making e1JetQGLikelihoodID"
        self.e1JetQGLikelihoodID_branch = the_tree.GetBranch("e1JetQGLikelihoodID")
        #if not self.e1JetQGLikelihoodID_branch and "e1JetQGLikelihoodID" not in self.complained:
        if not self.e1JetQGLikelihoodID_branch and "e1JetQGLikelihoodID":
            warnings.warn( "EETauTree: Expected branch e1JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetQGLikelihoodID")
        else:
            self.e1JetQGLikelihoodID_branch.SetAddress(<void*>&self.e1JetQGLikelihoodID_value)

        #print "making e1JetQGMVAID"
        self.e1JetQGMVAID_branch = the_tree.GetBranch("e1JetQGMVAID")
        #if not self.e1JetQGMVAID_branch and "e1JetQGMVAID" not in self.complained:
        if not self.e1JetQGMVAID_branch and "e1JetQGMVAID":
            warnings.warn( "EETauTree: Expected branch e1JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetQGMVAID")
        else:
            self.e1JetQGMVAID_branch.SetAddress(<void*>&self.e1JetQGMVAID_value)

        #print "making e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter"
        self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch = the_tree.GetBranch("e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        #if not self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter" not in self.complained:
        if not self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter":
            warnings.warn( "EETauTree: Expected branch e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        else:
            self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.SetAddress(<void*>&self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value)

        #print "making e1MITID"
        self.e1MITID_branch = the_tree.GetBranch("e1MITID")
        #if not self.e1MITID_branch and "e1MITID" not in self.complained:
        if not self.e1MITID_branch and "e1MITID":
            warnings.warn( "EETauTree: Expected branch e1MITID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MITID")
        else:
            self.e1MITID_branch.SetAddress(<void*>&self.e1MITID_value)

        #print "making e1MVAIDH2TauWP"
        self.e1MVAIDH2TauWP_branch = the_tree.GetBranch("e1MVAIDH2TauWP")
        #if not self.e1MVAIDH2TauWP_branch and "e1MVAIDH2TauWP" not in self.complained:
        if not self.e1MVAIDH2TauWP_branch and "e1MVAIDH2TauWP":
            warnings.warn( "EETauTree: Expected branch e1MVAIDH2TauWP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVAIDH2TauWP")
        else:
            self.e1MVAIDH2TauWP_branch.SetAddress(<void*>&self.e1MVAIDH2TauWP_value)

        #print "making e1MVANonTrig"
        self.e1MVANonTrig_branch = the_tree.GetBranch("e1MVANonTrig")
        #if not self.e1MVANonTrig_branch and "e1MVANonTrig" not in self.complained:
        if not self.e1MVANonTrig_branch and "e1MVANonTrig":
            warnings.warn( "EETauTree: Expected branch e1MVANonTrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANonTrig")
        else:
            self.e1MVANonTrig_branch.SetAddress(<void*>&self.e1MVANonTrig_value)

        #print "making e1MVATrig"
        self.e1MVATrig_branch = the_tree.GetBranch("e1MVATrig")
        #if not self.e1MVATrig_branch and "e1MVATrig" not in self.complained:
        if not self.e1MVATrig_branch and "e1MVATrig":
            warnings.warn( "EETauTree: Expected branch e1MVATrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrig")
        else:
            self.e1MVATrig_branch.SetAddress(<void*>&self.e1MVATrig_value)

        #print "making e1MVATrigIDISO"
        self.e1MVATrigIDISO_branch = the_tree.GetBranch("e1MVATrigIDISO")
        #if not self.e1MVATrigIDISO_branch and "e1MVATrigIDISO" not in self.complained:
        if not self.e1MVATrigIDISO_branch and "e1MVATrigIDISO":
            warnings.warn( "EETauTree: Expected branch e1MVATrigIDISO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigIDISO")
        else:
            self.e1MVATrigIDISO_branch.SetAddress(<void*>&self.e1MVATrigIDISO_value)

        #print "making e1MVATrigIDISOPUSUB"
        self.e1MVATrigIDISOPUSUB_branch = the_tree.GetBranch("e1MVATrigIDISOPUSUB")
        #if not self.e1MVATrigIDISOPUSUB_branch and "e1MVATrigIDISOPUSUB" not in self.complained:
        if not self.e1MVATrigIDISOPUSUB_branch and "e1MVATrigIDISOPUSUB":
            warnings.warn( "EETauTree: Expected branch e1MVATrigIDISOPUSUB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigIDISOPUSUB")
        else:
            self.e1MVATrigIDISOPUSUB_branch.SetAddress(<void*>&self.e1MVATrigIDISOPUSUB_value)

        #print "making e1MVATrigNoIP"
        self.e1MVATrigNoIP_branch = the_tree.GetBranch("e1MVATrigNoIP")
        #if not self.e1MVATrigNoIP_branch and "e1MVATrigNoIP" not in self.complained:
        if not self.e1MVATrigNoIP_branch and "e1MVATrigNoIP":
            warnings.warn( "EETauTree: Expected branch e1MVATrigNoIP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigNoIP")
        else:
            self.e1MVATrigNoIP_branch.SetAddress(<void*>&self.e1MVATrigNoIP_value)

        #print "making e1Mass"
        self.e1Mass_branch = the_tree.GetBranch("e1Mass")
        #if not self.e1Mass_branch and "e1Mass" not in self.complained:
        if not self.e1Mass_branch and "e1Mass":
            warnings.warn( "EETauTree: Expected branch e1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mass")
        else:
            self.e1Mass_branch.SetAddress(<void*>&self.e1Mass_value)

        #print "making e1MatchesDoubleEPath"
        self.e1MatchesDoubleEPath_branch = the_tree.GetBranch("e1MatchesDoubleEPath")
        #if not self.e1MatchesDoubleEPath_branch and "e1MatchesDoubleEPath" not in self.complained:
        if not self.e1MatchesDoubleEPath_branch and "e1MatchesDoubleEPath":
            warnings.warn( "EETauTree: Expected branch e1MatchesDoubleEPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesDoubleEPath")
        else:
            self.e1MatchesDoubleEPath_branch.SetAddress(<void*>&self.e1MatchesDoubleEPath_value)

        #print "making e1MatchesMu17Ele8IsoPath"
        self.e1MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("e1MatchesMu17Ele8IsoPath")
        #if not self.e1MatchesMu17Ele8IsoPath_branch and "e1MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.e1MatchesMu17Ele8IsoPath_branch and "e1MatchesMu17Ele8IsoPath":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu17Ele8IsoPath")
        else:
            self.e1MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.e1MatchesMu17Ele8IsoPath_value)

        #print "making e1MatchesMu17Ele8Path"
        self.e1MatchesMu17Ele8Path_branch = the_tree.GetBranch("e1MatchesMu17Ele8Path")
        #if not self.e1MatchesMu17Ele8Path_branch and "e1MatchesMu17Ele8Path" not in self.complained:
        if not self.e1MatchesMu17Ele8Path_branch and "e1MatchesMu17Ele8Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu17Ele8Path")
        else:
            self.e1MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.e1MatchesMu17Ele8Path_value)

        #print "making e1MatchesMu8Ele17IsoPath"
        self.e1MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("e1MatchesMu8Ele17IsoPath")
        #if not self.e1MatchesMu8Ele17IsoPath_branch and "e1MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.e1MatchesMu8Ele17IsoPath_branch and "e1MatchesMu8Ele17IsoPath":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8Ele17IsoPath")
        else:
            self.e1MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.e1MatchesMu8Ele17IsoPath_value)

        #print "making e1MatchesMu8Ele17Path"
        self.e1MatchesMu8Ele17Path_branch = the_tree.GetBranch("e1MatchesMu8Ele17Path")
        #if not self.e1MatchesMu8Ele17Path_branch and "e1MatchesMu8Ele17Path" not in self.complained:
        if not self.e1MatchesMu8Ele17Path_branch and "e1MatchesMu8Ele17Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8Ele17Path")
        else:
            self.e1MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.e1MatchesMu8Ele17Path_value)

        #print "making e1MatchesSingleE"
        self.e1MatchesSingleE_branch = the_tree.GetBranch("e1MatchesSingleE")
        #if not self.e1MatchesSingleE_branch and "e1MatchesSingleE" not in self.complained:
        if not self.e1MatchesSingleE_branch and "e1MatchesSingleE":
            warnings.warn( "EETauTree: Expected branch e1MatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesSingleE")
        else:
            self.e1MatchesSingleE_branch.SetAddress(<void*>&self.e1MatchesSingleE_value)

        #print "making e1MatchesSingleE27WP80"
        self.e1MatchesSingleE27WP80_branch = the_tree.GetBranch("e1MatchesSingleE27WP80")
        #if not self.e1MatchesSingleE27WP80_branch and "e1MatchesSingleE27WP80" not in self.complained:
        if not self.e1MatchesSingleE27WP80_branch and "e1MatchesSingleE27WP80":
            warnings.warn( "EETauTree: Expected branch e1MatchesSingleE27WP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesSingleE27WP80")
        else:
            self.e1MatchesSingleE27WP80_branch.SetAddress(<void*>&self.e1MatchesSingleE27WP80_value)

        #print "making e1MatchesSingleEPlusMET"
        self.e1MatchesSingleEPlusMET_branch = the_tree.GetBranch("e1MatchesSingleEPlusMET")
        #if not self.e1MatchesSingleEPlusMET_branch and "e1MatchesSingleEPlusMET" not in self.complained:
        if not self.e1MatchesSingleEPlusMET_branch and "e1MatchesSingleEPlusMET":
            warnings.warn( "EETauTree: Expected branch e1MatchesSingleEPlusMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesSingleEPlusMET")
        else:
            self.e1MatchesSingleEPlusMET_branch.SetAddress(<void*>&self.e1MatchesSingleEPlusMET_value)

        #print "making e1MissingHits"
        self.e1MissingHits_branch = the_tree.GetBranch("e1MissingHits")
        #if not self.e1MissingHits_branch and "e1MissingHits" not in self.complained:
        if not self.e1MissingHits_branch and "e1MissingHits":
            warnings.warn( "EETauTree: Expected branch e1MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MissingHits")
        else:
            self.e1MissingHits_branch.SetAddress(<void*>&self.e1MissingHits_value)

        #print "making e1MtToMET"
        self.e1MtToMET_branch = the_tree.GetBranch("e1MtToMET")
        #if not self.e1MtToMET_branch and "e1MtToMET" not in self.complained:
        if not self.e1MtToMET_branch and "e1MtToMET":
            warnings.warn( "EETauTree: Expected branch e1MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToMET")
        else:
            self.e1MtToMET_branch.SetAddress(<void*>&self.e1MtToMET_value)

        #print "making e1MtToMVAMET"
        self.e1MtToMVAMET_branch = the_tree.GetBranch("e1MtToMVAMET")
        #if not self.e1MtToMVAMET_branch and "e1MtToMVAMET" not in self.complained:
        if not self.e1MtToMVAMET_branch and "e1MtToMVAMET":
            warnings.warn( "EETauTree: Expected branch e1MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToMVAMET")
        else:
            self.e1MtToMVAMET_branch.SetAddress(<void*>&self.e1MtToMVAMET_value)

        #print "making e1MtToPfMet"
        self.e1MtToPfMet_branch = the_tree.GetBranch("e1MtToPfMet")
        #if not self.e1MtToPfMet_branch and "e1MtToPfMet" not in self.complained:
        if not self.e1MtToPfMet_branch and "e1MtToPfMet":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet")
        else:
            self.e1MtToPfMet_branch.SetAddress(<void*>&self.e1MtToPfMet_value)

        #print "making e1MtToPfMet_Ty1"
        self.e1MtToPfMet_Ty1_branch = the_tree.GetBranch("e1MtToPfMet_Ty1")
        #if not self.e1MtToPfMet_Ty1_branch and "e1MtToPfMet_Ty1" not in self.complained:
        if not self.e1MtToPfMet_Ty1_branch and "e1MtToPfMet_Ty1":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_Ty1")
        else:
            self.e1MtToPfMet_Ty1_branch.SetAddress(<void*>&self.e1MtToPfMet_Ty1_value)

        #print "making e1MtToPfMet_ees"
        self.e1MtToPfMet_ees_branch = the_tree.GetBranch("e1MtToPfMet_ees")
        #if not self.e1MtToPfMet_ees_branch and "e1MtToPfMet_ees" not in self.complained:
        if not self.e1MtToPfMet_ees_branch and "e1MtToPfMet_ees":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_ees does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_ees")
        else:
            self.e1MtToPfMet_ees_branch.SetAddress(<void*>&self.e1MtToPfMet_ees_value)

        #print "making e1MtToPfMet_ees_minus"
        self.e1MtToPfMet_ees_minus_branch = the_tree.GetBranch("e1MtToPfMet_ees_minus")
        #if not self.e1MtToPfMet_ees_minus_branch and "e1MtToPfMet_ees_minus" not in self.complained:
        if not self.e1MtToPfMet_ees_minus_branch and "e1MtToPfMet_ees_minus":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_ees_minus")
        else:
            self.e1MtToPfMet_ees_minus_branch.SetAddress(<void*>&self.e1MtToPfMet_ees_minus_value)

        #print "making e1MtToPfMet_ees_plus"
        self.e1MtToPfMet_ees_plus_branch = the_tree.GetBranch("e1MtToPfMet_ees_plus")
        #if not self.e1MtToPfMet_ees_plus_branch and "e1MtToPfMet_ees_plus" not in self.complained:
        if not self.e1MtToPfMet_ees_plus_branch and "e1MtToPfMet_ees_plus":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_ees_plus")
        else:
            self.e1MtToPfMet_ees_plus_branch.SetAddress(<void*>&self.e1MtToPfMet_ees_plus_value)

        #print "making e1MtToPfMet_jes"
        self.e1MtToPfMet_jes_branch = the_tree.GetBranch("e1MtToPfMet_jes")
        #if not self.e1MtToPfMet_jes_branch and "e1MtToPfMet_jes" not in self.complained:
        if not self.e1MtToPfMet_jes_branch and "e1MtToPfMet_jes":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_jes")
        else:
            self.e1MtToPfMet_jes_branch.SetAddress(<void*>&self.e1MtToPfMet_jes_value)

        #print "making e1MtToPfMet_jes_minus"
        self.e1MtToPfMet_jes_minus_branch = the_tree.GetBranch("e1MtToPfMet_jes_minus")
        #if not self.e1MtToPfMet_jes_minus_branch and "e1MtToPfMet_jes_minus" not in self.complained:
        if not self.e1MtToPfMet_jes_minus_branch and "e1MtToPfMet_jes_minus":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_jes_minus")
        else:
            self.e1MtToPfMet_jes_minus_branch.SetAddress(<void*>&self.e1MtToPfMet_jes_minus_value)

        #print "making e1MtToPfMet_jes_plus"
        self.e1MtToPfMet_jes_plus_branch = the_tree.GetBranch("e1MtToPfMet_jes_plus")
        #if not self.e1MtToPfMet_jes_plus_branch and "e1MtToPfMet_jes_plus" not in self.complained:
        if not self.e1MtToPfMet_jes_plus_branch and "e1MtToPfMet_jes_plus":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_jes_plus")
        else:
            self.e1MtToPfMet_jes_plus_branch.SetAddress(<void*>&self.e1MtToPfMet_jes_plus_value)

        #print "making e1MtToPfMet_mes"
        self.e1MtToPfMet_mes_branch = the_tree.GetBranch("e1MtToPfMet_mes")
        #if not self.e1MtToPfMet_mes_branch and "e1MtToPfMet_mes" not in self.complained:
        if not self.e1MtToPfMet_mes_branch and "e1MtToPfMet_mes":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_mes")
        else:
            self.e1MtToPfMet_mes_branch.SetAddress(<void*>&self.e1MtToPfMet_mes_value)

        #print "making e1MtToPfMet_mes_minus"
        self.e1MtToPfMet_mes_minus_branch = the_tree.GetBranch("e1MtToPfMet_mes_minus")
        #if not self.e1MtToPfMet_mes_minus_branch and "e1MtToPfMet_mes_minus" not in self.complained:
        if not self.e1MtToPfMet_mes_minus_branch and "e1MtToPfMet_mes_minus":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_mes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_mes_minus")
        else:
            self.e1MtToPfMet_mes_minus_branch.SetAddress(<void*>&self.e1MtToPfMet_mes_minus_value)

        #print "making e1MtToPfMet_mes_plus"
        self.e1MtToPfMet_mes_plus_branch = the_tree.GetBranch("e1MtToPfMet_mes_plus")
        #if not self.e1MtToPfMet_mes_plus_branch and "e1MtToPfMet_mes_plus" not in self.complained:
        if not self.e1MtToPfMet_mes_plus_branch and "e1MtToPfMet_mes_plus":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_mes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_mes_plus")
        else:
            self.e1MtToPfMet_mes_plus_branch.SetAddress(<void*>&self.e1MtToPfMet_mes_plus_value)

        #print "making e1MtToPfMet_tes"
        self.e1MtToPfMet_tes_branch = the_tree.GetBranch("e1MtToPfMet_tes")
        #if not self.e1MtToPfMet_tes_branch and "e1MtToPfMet_tes" not in self.complained:
        if not self.e1MtToPfMet_tes_branch and "e1MtToPfMet_tes":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_tes")
        else:
            self.e1MtToPfMet_tes_branch.SetAddress(<void*>&self.e1MtToPfMet_tes_value)

        #print "making e1MtToPfMet_tes_minus"
        self.e1MtToPfMet_tes_minus_branch = the_tree.GetBranch("e1MtToPfMet_tes_minus")
        #if not self.e1MtToPfMet_tes_minus_branch and "e1MtToPfMet_tes_minus" not in self.complained:
        if not self.e1MtToPfMet_tes_minus_branch and "e1MtToPfMet_tes_minus":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_tes_minus")
        else:
            self.e1MtToPfMet_tes_minus_branch.SetAddress(<void*>&self.e1MtToPfMet_tes_minus_value)

        #print "making e1MtToPfMet_tes_plus"
        self.e1MtToPfMet_tes_plus_branch = the_tree.GetBranch("e1MtToPfMet_tes_plus")
        #if not self.e1MtToPfMet_tes_plus_branch and "e1MtToPfMet_tes_plus" not in self.complained:
        if not self.e1MtToPfMet_tes_plus_branch and "e1MtToPfMet_tes_plus":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_tes_plus")
        else:
            self.e1MtToPfMet_tes_plus_branch.SetAddress(<void*>&self.e1MtToPfMet_tes_plus_value)

        #print "making e1MtToPfMet_ues"
        self.e1MtToPfMet_ues_branch = the_tree.GetBranch("e1MtToPfMet_ues")
        #if not self.e1MtToPfMet_ues_branch and "e1MtToPfMet_ues" not in self.complained:
        if not self.e1MtToPfMet_ues_branch and "e1MtToPfMet_ues":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_ues")
        else:
            self.e1MtToPfMet_ues_branch.SetAddress(<void*>&self.e1MtToPfMet_ues_value)

        #print "making e1MtToPfMet_ues_minus"
        self.e1MtToPfMet_ues_minus_branch = the_tree.GetBranch("e1MtToPfMet_ues_minus")
        #if not self.e1MtToPfMet_ues_minus_branch and "e1MtToPfMet_ues_minus" not in self.complained:
        if not self.e1MtToPfMet_ues_minus_branch and "e1MtToPfMet_ues_minus":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_ues_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_ues_minus")
        else:
            self.e1MtToPfMet_ues_minus_branch.SetAddress(<void*>&self.e1MtToPfMet_ues_minus_value)

        #print "making e1MtToPfMet_ues_plus"
        self.e1MtToPfMet_ues_plus_branch = the_tree.GetBranch("e1MtToPfMet_ues_plus")
        #if not self.e1MtToPfMet_ues_plus_branch and "e1MtToPfMet_ues_plus" not in self.complained:
        if not self.e1MtToPfMet_ues_plus_branch and "e1MtToPfMet_ues_plus":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_ues_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_ues_plus")
        else:
            self.e1MtToPfMet_ues_plus_branch.SetAddress(<void*>&self.e1MtToPfMet_ues_plus_value)

        #print "making e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter"
        self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch = the_tree.GetBranch("e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        #if not self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter" not in self.complained:
        if not self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter":
            warnings.warn( "EETauTree: Expected branch e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        else:
            self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.SetAddress(<void*>&self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value)

        #print "making e1Mu17Ele8CaloIdTPixelMatchFilter"
        self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch = the_tree.GetBranch("e1Mu17Ele8CaloIdTPixelMatchFilter")
        #if not self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch and "e1Mu17Ele8CaloIdTPixelMatchFilter" not in self.complained:
        if not self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch and "e1Mu17Ele8CaloIdTPixelMatchFilter":
            warnings.warn( "EETauTree: Expected branch e1Mu17Ele8CaloIdTPixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mu17Ele8CaloIdTPixelMatchFilter")
        else:
            self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch.SetAddress(<void*>&self.e1Mu17Ele8CaloIdTPixelMatchFilter_value)

        #print "making e1Mu17Ele8dZFilter"
        self.e1Mu17Ele8dZFilter_branch = the_tree.GetBranch("e1Mu17Ele8dZFilter")
        #if not self.e1Mu17Ele8dZFilter_branch and "e1Mu17Ele8dZFilter" not in self.complained:
        if not self.e1Mu17Ele8dZFilter_branch and "e1Mu17Ele8dZFilter":
            warnings.warn( "EETauTree: Expected branch e1Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mu17Ele8dZFilter")
        else:
            self.e1Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.e1Mu17Ele8dZFilter_value)

        #print "making e1NearMuonVeto"
        self.e1NearMuonVeto_branch = the_tree.GetBranch("e1NearMuonVeto")
        #if not self.e1NearMuonVeto_branch and "e1NearMuonVeto" not in self.complained:
        if not self.e1NearMuonVeto_branch and "e1NearMuonVeto":
            warnings.warn( "EETauTree: Expected branch e1NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearMuonVeto")
        else:
            self.e1NearMuonVeto_branch.SetAddress(<void*>&self.e1NearMuonVeto_value)

        #print "making e1PFChargedIso"
        self.e1PFChargedIso_branch = the_tree.GetBranch("e1PFChargedIso")
        #if not self.e1PFChargedIso_branch and "e1PFChargedIso" not in self.complained:
        if not self.e1PFChargedIso_branch and "e1PFChargedIso":
            warnings.warn( "EETauTree: Expected branch e1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFChargedIso")
        else:
            self.e1PFChargedIso_branch.SetAddress(<void*>&self.e1PFChargedIso_value)

        #print "making e1PFNeutralIso"
        self.e1PFNeutralIso_branch = the_tree.GetBranch("e1PFNeutralIso")
        #if not self.e1PFNeutralIso_branch and "e1PFNeutralIso" not in self.complained:
        if not self.e1PFNeutralIso_branch and "e1PFNeutralIso":
            warnings.warn( "EETauTree: Expected branch e1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFNeutralIso")
        else:
            self.e1PFNeutralIso_branch.SetAddress(<void*>&self.e1PFNeutralIso_value)

        #print "making e1PFPhotonIso"
        self.e1PFPhotonIso_branch = the_tree.GetBranch("e1PFPhotonIso")
        #if not self.e1PFPhotonIso_branch and "e1PFPhotonIso" not in self.complained:
        if not self.e1PFPhotonIso_branch and "e1PFPhotonIso":
            warnings.warn( "EETauTree: Expected branch e1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFPhotonIso")
        else:
            self.e1PFPhotonIso_branch.SetAddress(<void*>&self.e1PFPhotonIso_value)

        #print "making e1PVDXY"
        self.e1PVDXY_branch = the_tree.GetBranch("e1PVDXY")
        #if not self.e1PVDXY_branch and "e1PVDXY" not in self.complained:
        if not self.e1PVDXY_branch and "e1PVDXY":
            warnings.warn( "EETauTree: Expected branch e1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PVDXY")
        else:
            self.e1PVDXY_branch.SetAddress(<void*>&self.e1PVDXY_value)

        #print "making e1PVDZ"
        self.e1PVDZ_branch = the_tree.GetBranch("e1PVDZ")
        #if not self.e1PVDZ_branch and "e1PVDZ" not in self.complained:
        if not self.e1PVDZ_branch and "e1PVDZ":
            warnings.warn( "EETauTree: Expected branch e1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PVDZ")
        else:
            self.e1PVDZ_branch.SetAddress(<void*>&self.e1PVDZ_value)

        #print "making e1Phi"
        self.e1Phi_branch = the_tree.GetBranch("e1Phi")
        #if not self.e1Phi_branch and "e1Phi" not in self.complained:
        if not self.e1Phi_branch and "e1Phi":
            warnings.warn( "EETauTree: Expected branch e1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Phi")
        else:
            self.e1Phi_branch.SetAddress(<void*>&self.e1Phi_value)

        #print "making e1PhiCorrReg_2012Jul13ReReco"
        self.e1PhiCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PhiCorrReg_2012Jul13ReReco")
        #if not self.e1PhiCorrReg_2012Jul13ReReco_branch and "e1PhiCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PhiCorrReg_2012Jul13ReReco_branch and "e1PhiCorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1PhiCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrReg_2012Jul13ReReco")
        else:
            self.e1PhiCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PhiCorrReg_2012Jul13ReReco_value)

        #print "making e1PhiCorrReg_Fall11"
        self.e1PhiCorrReg_Fall11_branch = the_tree.GetBranch("e1PhiCorrReg_Fall11")
        #if not self.e1PhiCorrReg_Fall11_branch and "e1PhiCorrReg_Fall11" not in self.complained:
        if not self.e1PhiCorrReg_Fall11_branch and "e1PhiCorrReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1PhiCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrReg_Fall11")
        else:
            self.e1PhiCorrReg_Fall11_branch.SetAddress(<void*>&self.e1PhiCorrReg_Fall11_value)

        #print "making e1PhiCorrReg_Jan16ReReco"
        self.e1PhiCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1PhiCorrReg_Jan16ReReco")
        #if not self.e1PhiCorrReg_Jan16ReReco_branch and "e1PhiCorrReg_Jan16ReReco" not in self.complained:
        if not self.e1PhiCorrReg_Jan16ReReco_branch and "e1PhiCorrReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1PhiCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrReg_Jan16ReReco")
        else:
            self.e1PhiCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PhiCorrReg_Jan16ReReco_value)

        #print "making e1PhiCorrReg_Summer12_DR53X_HCP2012"
        self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PhiCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1PhiCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PhiCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1PhiCorrSmearedNoReg_2012Jul13ReReco"
        self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PhiCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e1PhiCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e1PhiCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1PhiCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1PhiCorrSmearedNoReg_Fall11"
        self.e1PhiCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1PhiCorrSmearedNoReg_Fall11")
        #if not self.e1PhiCorrSmearedNoReg_Fall11_branch and "e1PhiCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1PhiCorrSmearedNoReg_Fall11_branch and "e1PhiCorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1PhiCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedNoReg_Fall11")
        else:
            self.e1PhiCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1PhiCorrSmearedNoReg_Fall11_value)

        #print "making e1PhiCorrSmearedNoReg_Jan16ReReco"
        self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1PhiCorrSmearedNoReg_Jan16ReReco")
        #if not self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch and "e1PhiCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch and "e1PhiCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1PhiCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PhiCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1PhiCorrSmearedReg_2012Jul13ReReco"
        self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PhiCorrSmearedReg_2012Jul13ReReco")
        #if not self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch and "e1PhiCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch and "e1PhiCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1PhiCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PhiCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1PhiCorrSmearedReg_Fall11"
        self.e1PhiCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1PhiCorrSmearedReg_Fall11")
        #if not self.e1PhiCorrSmearedReg_Fall11_branch and "e1PhiCorrSmearedReg_Fall11" not in self.complained:
        if not self.e1PhiCorrSmearedReg_Fall11_branch and "e1PhiCorrSmearedReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1PhiCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedReg_Fall11")
        else:
            self.e1PhiCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1PhiCorrSmearedReg_Fall11_value)

        #print "making e1PhiCorrSmearedReg_Jan16ReReco"
        self.e1PhiCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1PhiCorrSmearedReg_Jan16ReReco")
        #if not self.e1PhiCorrSmearedReg_Jan16ReReco_branch and "e1PhiCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1PhiCorrSmearedReg_Jan16ReReco_branch and "e1PhiCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1PhiCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedReg_Jan16ReReco")
        else:
            self.e1PhiCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PhiCorrSmearedReg_Jan16ReReco_value)

        #print "making e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1Pt"
        self.e1Pt_branch = the_tree.GetBranch("e1Pt")
        #if not self.e1Pt_branch and "e1Pt" not in self.complained:
        if not self.e1Pt_branch and "e1Pt":
            warnings.warn( "EETauTree: Expected branch e1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt")
        else:
            self.e1Pt_branch.SetAddress(<void*>&self.e1Pt_value)

        #print "making e1PtCorrReg_2012Jul13ReReco"
        self.e1PtCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PtCorrReg_2012Jul13ReReco")
        #if not self.e1PtCorrReg_2012Jul13ReReco_branch and "e1PtCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PtCorrReg_2012Jul13ReReco_branch and "e1PtCorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1PtCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrReg_2012Jul13ReReco")
        else:
            self.e1PtCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PtCorrReg_2012Jul13ReReco_value)

        #print "making e1PtCorrReg_Fall11"
        self.e1PtCorrReg_Fall11_branch = the_tree.GetBranch("e1PtCorrReg_Fall11")
        #if not self.e1PtCorrReg_Fall11_branch and "e1PtCorrReg_Fall11" not in self.complained:
        if not self.e1PtCorrReg_Fall11_branch and "e1PtCorrReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1PtCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrReg_Fall11")
        else:
            self.e1PtCorrReg_Fall11_branch.SetAddress(<void*>&self.e1PtCorrReg_Fall11_value)

        #print "making e1PtCorrReg_Jan16ReReco"
        self.e1PtCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1PtCorrReg_Jan16ReReco")
        #if not self.e1PtCorrReg_Jan16ReReco_branch and "e1PtCorrReg_Jan16ReReco" not in self.complained:
        if not self.e1PtCorrReg_Jan16ReReco_branch and "e1PtCorrReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1PtCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrReg_Jan16ReReco")
        else:
            self.e1PtCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PtCorrReg_Jan16ReReco_value)

        #print "making e1PtCorrReg_Summer12_DR53X_HCP2012"
        self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PtCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1PtCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PtCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1PtCorrSmearedNoReg_2012Jul13ReReco"
        self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PtCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e1PtCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e1PtCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1PtCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PtCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1PtCorrSmearedNoReg_Fall11"
        self.e1PtCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1PtCorrSmearedNoReg_Fall11")
        #if not self.e1PtCorrSmearedNoReg_Fall11_branch and "e1PtCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1PtCorrSmearedNoReg_Fall11_branch and "e1PtCorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1PtCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedNoReg_Fall11")
        else:
            self.e1PtCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1PtCorrSmearedNoReg_Fall11_value)

        #print "making e1PtCorrSmearedNoReg_Jan16ReReco"
        self.e1PtCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1PtCorrSmearedNoReg_Jan16ReReco")
        #if not self.e1PtCorrSmearedNoReg_Jan16ReReco_branch and "e1PtCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1PtCorrSmearedNoReg_Jan16ReReco_branch and "e1PtCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1PtCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1PtCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PtCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1PtCorrSmearedReg_2012Jul13ReReco"
        self.e1PtCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PtCorrSmearedReg_2012Jul13ReReco")
        #if not self.e1PtCorrSmearedReg_2012Jul13ReReco_branch and "e1PtCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PtCorrSmearedReg_2012Jul13ReReco_branch and "e1PtCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1PtCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1PtCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PtCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1PtCorrSmearedReg_Fall11"
        self.e1PtCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1PtCorrSmearedReg_Fall11")
        #if not self.e1PtCorrSmearedReg_Fall11_branch and "e1PtCorrSmearedReg_Fall11" not in self.complained:
        if not self.e1PtCorrSmearedReg_Fall11_branch and "e1PtCorrSmearedReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1PtCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedReg_Fall11")
        else:
            self.e1PtCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1PtCorrSmearedReg_Fall11_value)

        #print "making e1PtCorrSmearedReg_Jan16ReReco"
        self.e1PtCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1PtCorrSmearedReg_Jan16ReReco")
        #if not self.e1PtCorrSmearedReg_Jan16ReReco_branch and "e1PtCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1PtCorrSmearedReg_Jan16ReReco_branch and "e1PtCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1PtCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedReg_Jan16ReReco")
        else:
            self.e1PtCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PtCorrSmearedReg_Jan16ReReco_value)

        #print "making e1PtCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1PtCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1Pt_ees_minus"
        self.e1Pt_ees_minus_branch = the_tree.GetBranch("e1Pt_ees_minus")
        #if not self.e1Pt_ees_minus_branch and "e1Pt_ees_minus" not in self.complained:
        if not self.e1Pt_ees_minus_branch and "e1Pt_ees_minus":
            warnings.warn( "EETauTree: Expected branch e1Pt_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt_ees_minus")
        else:
            self.e1Pt_ees_minus_branch.SetAddress(<void*>&self.e1Pt_ees_minus_value)

        #print "making e1Pt_ees_plus"
        self.e1Pt_ees_plus_branch = the_tree.GetBranch("e1Pt_ees_plus")
        #if not self.e1Pt_ees_plus_branch and "e1Pt_ees_plus" not in self.complained:
        if not self.e1Pt_ees_plus_branch and "e1Pt_ees_plus":
            warnings.warn( "EETauTree: Expected branch e1Pt_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt_ees_plus")
        else:
            self.e1Pt_ees_plus_branch.SetAddress(<void*>&self.e1Pt_ees_plus_value)

        #print "making e1Pt_tes_minus"
        self.e1Pt_tes_minus_branch = the_tree.GetBranch("e1Pt_tes_minus")
        #if not self.e1Pt_tes_minus_branch and "e1Pt_tes_minus" not in self.complained:
        if not self.e1Pt_tes_minus_branch and "e1Pt_tes_minus":
            warnings.warn( "EETauTree: Expected branch e1Pt_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt_tes_minus")
        else:
            self.e1Pt_tes_minus_branch.SetAddress(<void*>&self.e1Pt_tes_minus_value)

        #print "making e1Pt_tes_plus"
        self.e1Pt_tes_plus_branch = the_tree.GetBranch("e1Pt_tes_plus")
        #if not self.e1Pt_tes_plus_branch and "e1Pt_tes_plus" not in self.complained:
        if not self.e1Pt_tes_plus_branch and "e1Pt_tes_plus":
            warnings.warn( "EETauTree: Expected branch e1Pt_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt_tes_plus")
        else:
            self.e1Pt_tes_plus_branch.SetAddress(<void*>&self.e1Pt_tes_plus_value)

        #print "making e1Rank"
        self.e1Rank_branch = the_tree.GetBranch("e1Rank")
        #if not self.e1Rank_branch and "e1Rank" not in self.complained:
        if not self.e1Rank_branch and "e1Rank":
            warnings.warn( "EETauTree: Expected branch e1Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Rank")
        else:
            self.e1Rank_branch.SetAddress(<void*>&self.e1Rank_value)

        #print "making e1RelIso"
        self.e1RelIso_branch = the_tree.GetBranch("e1RelIso")
        #if not self.e1RelIso_branch and "e1RelIso" not in self.complained:
        if not self.e1RelIso_branch and "e1RelIso":
            warnings.warn( "EETauTree: Expected branch e1RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelIso")
        else:
            self.e1RelIso_branch.SetAddress(<void*>&self.e1RelIso_value)

        #print "making e1RelPFIsoDB"
        self.e1RelPFIsoDB_branch = the_tree.GetBranch("e1RelPFIsoDB")
        #if not self.e1RelPFIsoDB_branch and "e1RelPFIsoDB" not in self.complained:
        if not self.e1RelPFIsoDB_branch and "e1RelPFIsoDB":
            warnings.warn( "EETauTree: Expected branch e1RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoDB")
        else:
            self.e1RelPFIsoDB_branch.SetAddress(<void*>&self.e1RelPFIsoDB_value)

        #print "making e1RelPFIsoRho"
        self.e1RelPFIsoRho_branch = the_tree.GetBranch("e1RelPFIsoRho")
        #if not self.e1RelPFIsoRho_branch and "e1RelPFIsoRho" not in self.complained:
        if not self.e1RelPFIsoRho_branch and "e1RelPFIsoRho":
            warnings.warn( "EETauTree: Expected branch e1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoRho")
        else:
            self.e1RelPFIsoRho_branch.SetAddress(<void*>&self.e1RelPFIsoRho_value)

        #print "making e1RelPFIsoRhoFSR"
        self.e1RelPFIsoRhoFSR_branch = the_tree.GetBranch("e1RelPFIsoRhoFSR")
        #if not self.e1RelPFIsoRhoFSR_branch and "e1RelPFIsoRhoFSR" not in self.complained:
        if not self.e1RelPFIsoRhoFSR_branch and "e1RelPFIsoRhoFSR":
            warnings.warn( "EETauTree: Expected branch e1RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoRhoFSR")
        else:
            self.e1RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.e1RelPFIsoRhoFSR_value)

        #print "making e1RhoHZG2011"
        self.e1RhoHZG2011_branch = the_tree.GetBranch("e1RhoHZG2011")
        #if not self.e1RhoHZG2011_branch and "e1RhoHZG2011" not in self.complained:
        if not self.e1RhoHZG2011_branch and "e1RhoHZG2011":
            warnings.warn( "EETauTree: Expected branch e1RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RhoHZG2011")
        else:
            self.e1RhoHZG2011_branch.SetAddress(<void*>&self.e1RhoHZG2011_value)

        #print "making e1RhoHZG2012"
        self.e1RhoHZG2012_branch = the_tree.GetBranch("e1RhoHZG2012")
        #if not self.e1RhoHZG2012_branch and "e1RhoHZG2012" not in self.complained:
        if not self.e1RhoHZG2012_branch and "e1RhoHZG2012":
            warnings.warn( "EETauTree: Expected branch e1RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RhoHZG2012")
        else:
            self.e1RhoHZG2012_branch.SetAddress(<void*>&self.e1RhoHZG2012_value)

        #print "making e1SCEnergy"
        self.e1SCEnergy_branch = the_tree.GetBranch("e1SCEnergy")
        #if not self.e1SCEnergy_branch and "e1SCEnergy" not in self.complained:
        if not self.e1SCEnergy_branch and "e1SCEnergy":
            warnings.warn( "EETauTree: Expected branch e1SCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCEnergy")
        else:
            self.e1SCEnergy_branch.SetAddress(<void*>&self.e1SCEnergy_value)

        #print "making e1SCEta"
        self.e1SCEta_branch = the_tree.GetBranch("e1SCEta")
        #if not self.e1SCEta_branch and "e1SCEta" not in self.complained:
        if not self.e1SCEta_branch and "e1SCEta":
            warnings.warn( "EETauTree: Expected branch e1SCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCEta")
        else:
            self.e1SCEta_branch.SetAddress(<void*>&self.e1SCEta_value)

        #print "making e1SCEtaWidth"
        self.e1SCEtaWidth_branch = the_tree.GetBranch("e1SCEtaWidth")
        #if not self.e1SCEtaWidth_branch and "e1SCEtaWidth" not in self.complained:
        if not self.e1SCEtaWidth_branch and "e1SCEtaWidth":
            warnings.warn( "EETauTree: Expected branch e1SCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCEtaWidth")
        else:
            self.e1SCEtaWidth_branch.SetAddress(<void*>&self.e1SCEtaWidth_value)

        #print "making e1SCPhi"
        self.e1SCPhi_branch = the_tree.GetBranch("e1SCPhi")
        #if not self.e1SCPhi_branch and "e1SCPhi" not in self.complained:
        if not self.e1SCPhi_branch and "e1SCPhi":
            warnings.warn( "EETauTree: Expected branch e1SCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCPhi")
        else:
            self.e1SCPhi_branch.SetAddress(<void*>&self.e1SCPhi_value)

        #print "making e1SCPhiWidth"
        self.e1SCPhiWidth_branch = the_tree.GetBranch("e1SCPhiWidth")
        #if not self.e1SCPhiWidth_branch and "e1SCPhiWidth" not in self.complained:
        if not self.e1SCPhiWidth_branch and "e1SCPhiWidth":
            warnings.warn( "EETauTree: Expected branch e1SCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCPhiWidth")
        else:
            self.e1SCPhiWidth_branch.SetAddress(<void*>&self.e1SCPhiWidth_value)

        #print "making e1SCPreshowerEnergy"
        self.e1SCPreshowerEnergy_branch = the_tree.GetBranch("e1SCPreshowerEnergy")
        #if not self.e1SCPreshowerEnergy_branch and "e1SCPreshowerEnergy" not in self.complained:
        if not self.e1SCPreshowerEnergy_branch and "e1SCPreshowerEnergy":
            warnings.warn( "EETauTree: Expected branch e1SCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCPreshowerEnergy")
        else:
            self.e1SCPreshowerEnergy_branch.SetAddress(<void*>&self.e1SCPreshowerEnergy_value)

        #print "making e1SCRawEnergy"
        self.e1SCRawEnergy_branch = the_tree.GetBranch("e1SCRawEnergy")
        #if not self.e1SCRawEnergy_branch and "e1SCRawEnergy" not in self.complained:
        if not self.e1SCRawEnergy_branch and "e1SCRawEnergy":
            warnings.warn( "EETauTree: Expected branch e1SCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCRawEnergy")
        else:
            self.e1SCRawEnergy_branch.SetAddress(<void*>&self.e1SCRawEnergy_value)

        #print "making e1SigmaIEtaIEta"
        self.e1SigmaIEtaIEta_branch = the_tree.GetBranch("e1SigmaIEtaIEta")
        #if not self.e1SigmaIEtaIEta_branch and "e1SigmaIEtaIEta" not in self.complained:
        if not self.e1SigmaIEtaIEta_branch and "e1SigmaIEtaIEta":
            warnings.warn( "EETauTree: Expected branch e1SigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SigmaIEtaIEta")
        else:
            self.e1SigmaIEtaIEta_branch.SetAddress(<void*>&self.e1SigmaIEtaIEta_value)

        #print "making e1ToMETDPhi"
        self.e1ToMETDPhi_branch = the_tree.GetBranch("e1ToMETDPhi")
        #if not self.e1ToMETDPhi_branch and "e1ToMETDPhi" not in self.complained:
        if not self.e1ToMETDPhi_branch and "e1ToMETDPhi":
            warnings.warn( "EETauTree: Expected branch e1ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ToMETDPhi")
        else:
            self.e1ToMETDPhi_branch.SetAddress(<void*>&self.e1ToMETDPhi_value)

        #print "making e1TrkIsoDR03"
        self.e1TrkIsoDR03_branch = the_tree.GetBranch("e1TrkIsoDR03")
        #if not self.e1TrkIsoDR03_branch and "e1TrkIsoDR03" not in self.complained:
        if not self.e1TrkIsoDR03_branch and "e1TrkIsoDR03":
            warnings.warn( "EETauTree: Expected branch e1TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1TrkIsoDR03")
        else:
            self.e1TrkIsoDR03_branch.SetAddress(<void*>&self.e1TrkIsoDR03_value)

        #print "making e1VZ"
        self.e1VZ_branch = the_tree.GetBranch("e1VZ")
        #if not self.e1VZ_branch and "e1VZ" not in self.complained:
        if not self.e1VZ_branch and "e1VZ":
            warnings.warn( "EETauTree: Expected branch e1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1VZ")
        else:
            self.e1VZ_branch.SetAddress(<void*>&self.e1VZ_value)

        #print "making e1WWID"
        self.e1WWID_branch = the_tree.GetBranch("e1WWID")
        #if not self.e1WWID_branch and "e1WWID" not in self.complained:
        if not self.e1WWID_branch and "e1WWID":
            warnings.warn( "EETauTree: Expected branch e1WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1WWID")
        else:
            self.e1WWID_branch.SetAddress(<void*>&self.e1WWID_value)

        #print "making e1_e2_CosThetaStar"
        self.e1_e2_CosThetaStar_branch = the_tree.GetBranch("e1_e2_CosThetaStar")
        #if not self.e1_e2_CosThetaStar_branch and "e1_e2_CosThetaStar" not in self.complained:
        if not self.e1_e2_CosThetaStar_branch and "e1_e2_CosThetaStar":
            warnings.warn( "EETauTree: Expected branch e1_e2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_CosThetaStar")
        else:
            self.e1_e2_CosThetaStar_branch.SetAddress(<void*>&self.e1_e2_CosThetaStar_value)

        #print "making e1_e2_DPhi"
        self.e1_e2_DPhi_branch = the_tree.GetBranch("e1_e2_DPhi")
        #if not self.e1_e2_DPhi_branch and "e1_e2_DPhi" not in self.complained:
        if not self.e1_e2_DPhi_branch and "e1_e2_DPhi":
            warnings.warn( "EETauTree: Expected branch e1_e2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_DPhi")
        else:
            self.e1_e2_DPhi_branch.SetAddress(<void*>&self.e1_e2_DPhi_value)

        #print "making e1_e2_DR"
        self.e1_e2_DR_branch = the_tree.GetBranch("e1_e2_DR")
        #if not self.e1_e2_DR_branch and "e1_e2_DR" not in self.complained:
        if not self.e1_e2_DR_branch and "e1_e2_DR":
            warnings.warn( "EETauTree: Expected branch e1_e2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_DR")
        else:
            self.e1_e2_DR_branch.SetAddress(<void*>&self.e1_e2_DR_value)

        #print "making e1_e2_Mass"
        self.e1_e2_Mass_branch = the_tree.GetBranch("e1_e2_Mass")
        #if not self.e1_e2_Mass_branch and "e1_e2_Mass" not in self.complained:
        if not self.e1_e2_Mass_branch and "e1_e2_Mass":
            warnings.warn( "EETauTree: Expected branch e1_e2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass")
        else:
            self.e1_e2_Mass_branch.SetAddress(<void*>&self.e1_e2_Mass_value)

        #print "making e1_e2_MassFsr"
        self.e1_e2_MassFsr_branch = the_tree.GetBranch("e1_e2_MassFsr")
        #if not self.e1_e2_MassFsr_branch and "e1_e2_MassFsr" not in self.complained:
        if not self.e1_e2_MassFsr_branch and "e1_e2_MassFsr":
            warnings.warn( "EETauTree: Expected branch e1_e2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_MassFsr")
        else:
            self.e1_e2_MassFsr_branch.SetAddress(<void*>&self.e1_e2_MassFsr_value)

        #print "making e1_e2_Mass_ees_minus"
        self.e1_e2_Mass_ees_minus_branch = the_tree.GetBranch("e1_e2_Mass_ees_minus")
        #if not self.e1_e2_Mass_ees_minus_branch and "e1_e2_Mass_ees_minus" not in self.complained:
        if not self.e1_e2_Mass_ees_minus_branch and "e1_e2_Mass_ees_minus":
            warnings.warn( "EETauTree: Expected branch e1_e2_Mass_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass_ees_minus")
        else:
            self.e1_e2_Mass_ees_minus_branch.SetAddress(<void*>&self.e1_e2_Mass_ees_minus_value)

        #print "making e1_e2_Mass_ees_plus"
        self.e1_e2_Mass_ees_plus_branch = the_tree.GetBranch("e1_e2_Mass_ees_plus")
        #if not self.e1_e2_Mass_ees_plus_branch and "e1_e2_Mass_ees_plus" not in self.complained:
        if not self.e1_e2_Mass_ees_plus_branch and "e1_e2_Mass_ees_plus":
            warnings.warn( "EETauTree: Expected branch e1_e2_Mass_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass_ees_plus")
        else:
            self.e1_e2_Mass_ees_plus_branch.SetAddress(<void*>&self.e1_e2_Mass_ees_plus_value)

        #print "making e1_e2_Mass_tes_minus"
        self.e1_e2_Mass_tes_minus_branch = the_tree.GetBranch("e1_e2_Mass_tes_minus")
        #if not self.e1_e2_Mass_tes_minus_branch and "e1_e2_Mass_tes_minus" not in self.complained:
        if not self.e1_e2_Mass_tes_minus_branch and "e1_e2_Mass_tes_minus":
            warnings.warn( "EETauTree: Expected branch e1_e2_Mass_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass_tes_minus")
        else:
            self.e1_e2_Mass_tes_minus_branch.SetAddress(<void*>&self.e1_e2_Mass_tes_minus_value)

        #print "making e1_e2_Mass_tes_plus"
        self.e1_e2_Mass_tes_plus_branch = the_tree.GetBranch("e1_e2_Mass_tes_plus")
        #if not self.e1_e2_Mass_tes_plus_branch and "e1_e2_Mass_tes_plus" not in self.complained:
        if not self.e1_e2_Mass_tes_plus_branch and "e1_e2_Mass_tes_plus":
            warnings.warn( "EETauTree: Expected branch e1_e2_Mass_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass_tes_plus")
        else:
            self.e1_e2_Mass_tes_plus_branch.SetAddress(<void*>&self.e1_e2_Mass_tes_plus_value)

        #print "making e1_e2_PZeta"
        self.e1_e2_PZeta_branch = the_tree.GetBranch("e1_e2_PZeta")
        #if not self.e1_e2_PZeta_branch and "e1_e2_PZeta" not in self.complained:
        if not self.e1_e2_PZeta_branch and "e1_e2_PZeta":
            warnings.warn( "EETauTree: Expected branch e1_e2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZeta")
        else:
            self.e1_e2_PZeta_branch.SetAddress(<void*>&self.e1_e2_PZeta_value)

        #print "making e1_e2_PZetaVis"
        self.e1_e2_PZetaVis_branch = the_tree.GetBranch("e1_e2_PZetaVis")
        #if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis" not in self.complained:
        if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis":
            warnings.warn( "EETauTree: Expected branch e1_e2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZetaVis")
        else:
            self.e1_e2_PZetaVis_branch.SetAddress(<void*>&self.e1_e2_PZetaVis_value)

        #print "making e1_e2_Pt"
        self.e1_e2_Pt_branch = the_tree.GetBranch("e1_e2_Pt")
        #if not self.e1_e2_Pt_branch and "e1_e2_Pt" not in self.complained:
        if not self.e1_e2_Pt_branch and "e1_e2_Pt":
            warnings.warn( "EETauTree: Expected branch e1_e2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Pt")
        else:
            self.e1_e2_Pt_branch.SetAddress(<void*>&self.e1_e2_Pt_value)

        #print "making e1_e2_PtFsr"
        self.e1_e2_PtFsr_branch = the_tree.GetBranch("e1_e2_PtFsr")
        #if not self.e1_e2_PtFsr_branch and "e1_e2_PtFsr" not in self.complained:
        if not self.e1_e2_PtFsr_branch and "e1_e2_PtFsr":
            warnings.warn( "EETauTree: Expected branch e1_e2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PtFsr")
        else:
            self.e1_e2_PtFsr_branch.SetAddress(<void*>&self.e1_e2_PtFsr_value)

        #print "making e1_e2_SS"
        self.e1_e2_SS_branch = the_tree.GetBranch("e1_e2_SS")
        #if not self.e1_e2_SS_branch and "e1_e2_SS" not in self.complained:
        if not self.e1_e2_SS_branch and "e1_e2_SS":
            warnings.warn( "EETauTree: Expected branch e1_e2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_SS")
        else:
            self.e1_e2_SS_branch.SetAddress(<void*>&self.e1_e2_SS_value)

        #print "making e1_e2_ToMETDPhi_Ty1"
        self.e1_e2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e1_e2_ToMETDPhi_Ty1")
        #if not self.e1_e2_ToMETDPhi_Ty1_branch and "e1_e2_ToMETDPhi_Ty1" not in self.complained:
        if not self.e1_e2_ToMETDPhi_Ty1_branch and "e1_e2_ToMETDPhi_Ty1":
            warnings.warn( "EETauTree: Expected branch e1_e2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_ToMETDPhi_Ty1")
        else:
            self.e1_e2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e1_e2_ToMETDPhi_Ty1_value)

        #print "making e1_e2_ToMETDPhi_jes_minus"
        self.e1_e2_ToMETDPhi_jes_minus_branch = the_tree.GetBranch("e1_e2_ToMETDPhi_jes_minus")
        #if not self.e1_e2_ToMETDPhi_jes_minus_branch and "e1_e2_ToMETDPhi_jes_minus" not in self.complained:
        if not self.e1_e2_ToMETDPhi_jes_minus_branch and "e1_e2_ToMETDPhi_jes_minus":
            warnings.warn( "EETauTree: Expected branch e1_e2_ToMETDPhi_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_ToMETDPhi_jes_minus")
        else:
            self.e1_e2_ToMETDPhi_jes_minus_branch.SetAddress(<void*>&self.e1_e2_ToMETDPhi_jes_minus_value)

        #print "making e1_e2_ToMETDPhi_jes_plus"
        self.e1_e2_ToMETDPhi_jes_plus_branch = the_tree.GetBranch("e1_e2_ToMETDPhi_jes_plus")
        #if not self.e1_e2_ToMETDPhi_jes_plus_branch and "e1_e2_ToMETDPhi_jes_plus" not in self.complained:
        if not self.e1_e2_ToMETDPhi_jes_plus_branch and "e1_e2_ToMETDPhi_jes_plus":
            warnings.warn( "EETauTree: Expected branch e1_e2_ToMETDPhi_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_ToMETDPhi_jes_plus")
        else:
            self.e1_e2_ToMETDPhi_jes_plus_branch.SetAddress(<void*>&self.e1_e2_ToMETDPhi_jes_plus_value)

        #print "making e1_e2_Zcompat"
        self.e1_e2_Zcompat_branch = the_tree.GetBranch("e1_e2_Zcompat")
        #if not self.e1_e2_Zcompat_branch and "e1_e2_Zcompat" not in self.complained:
        if not self.e1_e2_Zcompat_branch and "e1_e2_Zcompat":
            warnings.warn( "EETauTree: Expected branch e1_e2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Zcompat")
        else:
            self.e1_e2_Zcompat_branch.SetAddress(<void*>&self.e1_e2_Zcompat_value)

        #print "making e1_t_CosThetaStar"
        self.e1_t_CosThetaStar_branch = the_tree.GetBranch("e1_t_CosThetaStar")
        #if not self.e1_t_CosThetaStar_branch and "e1_t_CosThetaStar" not in self.complained:
        if not self.e1_t_CosThetaStar_branch and "e1_t_CosThetaStar":
            warnings.warn( "EETauTree: Expected branch e1_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_CosThetaStar")
        else:
            self.e1_t_CosThetaStar_branch.SetAddress(<void*>&self.e1_t_CosThetaStar_value)

        #print "making e1_t_DPhi"
        self.e1_t_DPhi_branch = the_tree.GetBranch("e1_t_DPhi")
        #if not self.e1_t_DPhi_branch and "e1_t_DPhi" not in self.complained:
        if not self.e1_t_DPhi_branch and "e1_t_DPhi":
            warnings.warn( "EETauTree: Expected branch e1_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_DPhi")
        else:
            self.e1_t_DPhi_branch.SetAddress(<void*>&self.e1_t_DPhi_value)

        #print "making e1_t_DR"
        self.e1_t_DR_branch = the_tree.GetBranch("e1_t_DR")
        #if not self.e1_t_DR_branch and "e1_t_DR" not in self.complained:
        if not self.e1_t_DR_branch and "e1_t_DR":
            warnings.warn( "EETauTree: Expected branch e1_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_DR")
        else:
            self.e1_t_DR_branch.SetAddress(<void*>&self.e1_t_DR_value)

        #print "making e1_t_Mass"
        self.e1_t_Mass_branch = the_tree.GetBranch("e1_t_Mass")
        #if not self.e1_t_Mass_branch and "e1_t_Mass" not in self.complained:
        if not self.e1_t_Mass_branch and "e1_t_Mass":
            warnings.warn( "EETauTree: Expected branch e1_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mass")
        else:
            self.e1_t_Mass_branch.SetAddress(<void*>&self.e1_t_Mass_value)

        #print "making e1_t_MassFsr"
        self.e1_t_MassFsr_branch = the_tree.GetBranch("e1_t_MassFsr")
        #if not self.e1_t_MassFsr_branch and "e1_t_MassFsr" not in self.complained:
        if not self.e1_t_MassFsr_branch and "e1_t_MassFsr":
            warnings.warn( "EETauTree: Expected branch e1_t_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_MassFsr")
        else:
            self.e1_t_MassFsr_branch.SetAddress(<void*>&self.e1_t_MassFsr_value)

        #print "making e1_t_Mass_ees_minus"
        self.e1_t_Mass_ees_minus_branch = the_tree.GetBranch("e1_t_Mass_ees_minus")
        #if not self.e1_t_Mass_ees_minus_branch and "e1_t_Mass_ees_minus" not in self.complained:
        if not self.e1_t_Mass_ees_minus_branch and "e1_t_Mass_ees_minus":
            warnings.warn( "EETauTree: Expected branch e1_t_Mass_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mass_ees_minus")
        else:
            self.e1_t_Mass_ees_minus_branch.SetAddress(<void*>&self.e1_t_Mass_ees_minus_value)

        #print "making e1_t_Mass_ees_plus"
        self.e1_t_Mass_ees_plus_branch = the_tree.GetBranch("e1_t_Mass_ees_plus")
        #if not self.e1_t_Mass_ees_plus_branch and "e1_t_Mass_ees_plus" not in self.complained:
        if not self.e1_t_Mass_ees_plus_branch and "e1_t_Mass_ees_plus":
            warnings.warn( "EETauTree: Expected branch e1_t_Mass_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mass_ees_plus")
        else:
            self.e1_t_Mass_ees_plus_branch.SetAddress(<void*>&self.e1_t_Mass_ees_plus_value)

        #print "making e1_t_Mass_tes_minus"
        self.e1_t_Mass_tes_minus_branch = the_tree.GetBranch("e1_t_Mass_tes_minus")
        #if not self.e1_t_Mass_tes_minus_branch and "e1_t_Mass_tes_minus" not in self.complained:
        if not self.e1_t_Mass_tes_minus_branch and "e1_t_Mass_tes_minus":
            warnings.warn( "EETauTree: Expected branch e1_t_Mass_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mass_tes_minus")
        else:
            self.e1_t_Mass_tes_minus_branch.SetAddress(<void*>&self.e1_t_Mass_tes_minus_value)

        #print "making e1_t_Mass_tes_plus"
        self.e1_t_Mass_tes_plus_branch = the_tree.GetBranch("e1_t_Mass_tes_plus")
        #if not self.e1_t_Mass_tes_plus_branch and "e1_t_Mass_tes_plus" not in self.complained:
        if not self.e1_t_Mass_tes_plus_branch and "e1_t_Mass_tes_plus":
            warnings.warn( "EETauTree: Expected branch e1_t_Mass_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mass_tes_plus")
        else:
            self.e1_t_Mass_tes_plus_branch.SetAddress(<void*>&self.e1_t_Mass_tes_plus_value)

        #print "making e1_t_PZeta"
        self.e1_t_PZeta_branch = the_tree.GetBranch("e1_t_PZeta")
        #if not self.e1_t_PZeta_branch and "e1_t_PZeta" not in self.complained:
        if not self.e1_t_PZeta_branch and "e1_t_PZeta":
            warnings.warn( "EETauTree: Expected branch e1_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_PZeta")
        else:
            self.e1_t_PZeta_branch.SetAddress(<void*>&self.e1_t_PZeta_value)

        #print "making e1_t_PZetaVis"
        self.e1_t_PZetaVis_branch = the_tree.GetBranch("e1_t_PZetaVis")
        #if not self.e1_t_PZetaVis_branch and "e1_t_PZetaVis" not in self.complained:
        if not self.e1_t_PZetaVis_branch and "e1_t_PZetaVis":
            warnings.warn( "EETauTree: Expected branch e1_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_PZetaVis")
        else:
            self.e1_t_PZetaVis_branch.SetAddress(<void*>&self.e1_t_PZetaVis_value)

        #print "making e1_t_Pt"
        self.e1_t_Pt_branch = the_tree.GetBranch("e1_t_Pt")
        #if not self.e1_t_Pt_branch and "e1_t_Pt" not in self.complained:
        if not self.e1_t_Pt_branch and "e1_t_Pt":
            warnings.warn( "EETauTree: Expected branch e1_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Pt")
        else:
            self.e1_t_Pt_branch.SetAddress(<void*>&self.e1_t_Pt_value)

        #print "making e1_t_PtFsr"
        self.e1_t_PtFsr_branch = the_tree.GetBranch("e1_t_PtFsr")
        #if not self.e1_t_PtFsr_branch and "e1_t_PtFsr" not in self.complained:
        if not self.e1_t_PtFsr_branch and "e1_t_PtFsr":
            warnings.warn( "EETauTree: Expected branch e1_t_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_PtFsr")
        else:
            self.e1_t_PtFsr_branch.SetAddress(<void*>&self.e1_t_PtFsr_value)

        #print "making e1_t_SS"
        self.e1_t_SS_branch = the_tree.GetBranch("e1_t_SS")
        #if not self.e1_t_SS_branch and "e1_t_SS" not in self.complained:
        if not self.e1_t_SS_branch and "e1_t_SS":
            warnings.warn( "EETauTree: Expected branch e1_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_SS")
        else:
            self.e1_t_SS_branch.SetAddress(<void*>&self.e1_t_SS_value)

        #print "making e1_t_ToMETDPhi_Ty1"
        self.e1_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e1_t_ToMETDPhi_Ty1")
        #if not self.e1_t_ToMETDPhi_Ty1_branch and "e1_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.e1_t_ToMETDPhi_Ty1_branch and "e1_t_ToMETDPhi_Ty1":
            warnings.warn( "EETauTree: Expected branch e1_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_ToMETDPhi_Ty1")
        else:
            self.e1_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e1_t_ToMETDPhi_Ty1_value)

        #print "making e1_t_ToMETDPhi_jes_minus"
        self.e1_t_ToMETDPhi_jes_minus_branch = the_tree.GetBranch("e1_t_ToMETDPhi_jes_minus")
        #if not self.e1_t_ToMETDPhi_jes_minus_branch and "e1_t_ToMETDPhi_jes_minus" not in self.complained:
        if not self.e1_t_ToMETDPhi_jes_minus_branch and "e1_t_ToMETDPhi_jes_minus":
            warnings.warn( "EETauTree: Expected branch e1_t_ToMETDPhi_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_ToMETDPhi_jes_minus")
        else:
            self.e1_t_ToMETDPhi_jes_minus_branch.SetAddress(<void*>&self.e1_t_ToMETDPhi_jes_minus_value)

        #print "making e1_t_ToMETDPhi_jes_plus"
        self.e1_t_ToMETDPhi_jes_plus_branch = the_tree.GetBranch("e1_t_ToMETDPhi_jes_plus")
        #if not self.e1_t_ToMETDPhi_jes_plus_branch and "e1_t_ToMETDPhi_jes_plus" not in self.complained:
        if not self.e1_t_ToMETDPhi_jes_plus_branch and "e1_t_ToMETDPhi_jes_plus":
            warnings.warn( "EETauTree: Expected branch e1_t_ToMETDPhi_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_ToMETDPhi_jes_plus")
        else:
            self.e1_t_ToMETDPhi_jes_plus_branch.SetAddress(<void*>&self.e1_t_ToMETDPhi_jes_plus_value)

        #print "making e1_t_Zcompat"
        self.e1_t_Zcompat_branch = the_tree.GetBranch("e1_t_Zcompat")
        #if not self.e1_t_Zcompat_branch and "e1_t_Zcompat" not in self.complained:
        if not self.e1_t_Zcompat_branch and "e1_t_Zcompat":
            warnings.warn( "EETauTree: Expected branch e1_t_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Zcompat")
        else:
            self.e1_t_Zcompat_branch.SetAddress(<void*>&self.e1_t_Zcompat_value)

        #print "making e1dECorrReg_2012Jul13ReReco"
        self.e1dECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1dECorrReg_2012Jul13ReReco")
        #if not self.e1dECorrReg_2012Jul13ReReco_branch and "e1dECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1dECorrReg_2012Jul13ReReco_branch and "e1dECorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1dECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrReg_2012Jul13ReReco")
        else:
            self.e1dECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1dECorrReg_2012Jul13ReReco_value)

        #print "making e1dECorrReg_Fall11"
        self.e1dECorrReg_Fall11_branch = the_tree.GetBranch("e1dECorrReg_Fall11")
        #if not self.e1dECorrReg_Fall11_branch and "e1dECorrReg_Fall11" not in self.complained:
        if not self.e1dECorrReg_Fall11_branch and "e1dECorrReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1dECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrReg_Fall11")
        else:
            self.e1dECorrReg_Fall11_branch.SetAddress(<void*>&self.e1dECorrReg_Fall11_value)

        #print "making e1dECorrReg_Jan16ReReco"
        self.e1dECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1dECorrReg_Jan16ReReco")
        #if not self.e1dECorrReg_Jan16ReReco_branch and "e1dECorrReg_Jan16ReReco" not in self.complained:
        if not self.e1dECorrReg_Jan16ReReco_branch and "e1dECorrReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1dECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrReg_Jan16ReReco")
        else:
            self.e1dECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1dECorrReg_Jan16ReReco_value)

        #print "making e1dECorrReg_Summer12_DR53X_HCP2012"
        self.e1dECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1dECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1dECorrReg_Summer12_DR53X_HCP2012_branch and "e1dECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1dECorrReg_Summer12_DR53X_HCP2012_branch and "e1dECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1dECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1dECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1dECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1dECorrSmearedNoReg_2012Jul13ReReco"
        self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1dECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch and "e1dECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch and "e1dECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1dECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1dECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1dECorrSmearedNoReg_Fall11"
        self.e1dECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1dECorrSmearedNoReg_Fall11")
        #if not self.e1dECorrSmearedNoReg_Fall11_branch and "e1dECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1dECorrSmearedNoReg_Fall11_branch and "e1dECorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1dECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedNoReg_Fall11")
        else:
            self.e1dECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1dECorrSmearedNoReg_Fall11_value)

        #print "making e1dECorrSmearedNoReg_Jan16ReReco"
        self.e1dECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1dECorrSmearedNoReg_Jan16ReReco")
        #if not self.e1dECorrSmearedNoReg_Jan16ReReco_branch and "e1dECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1dECorrSmearedNoReg_Jan16ReReco_branch and "e1dECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1dECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1dECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1dECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1dECorrSmearedReg_2012Jul13ReReco"
        self.e1dECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1dECorrSmearedReg_2012Jul13ReReco")
        #if not self.e1dECorrSmearedReg_2012Jul13ReReco_branch and "e1dECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1dECorrSmearedReg_2012Jul13ReReco_branch and "e1dECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e1dECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1dECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1dECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1dECorrSmearedReg_Fall11"
        self.e1dECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1dECorrSmearedReg_Fall11")
        #if not self.e1dECorrSmearedReg_Fall11_branch and "e1dECorrSmearedReg_Fall11" not in self.complained:
        if not self.e1dECorrSmearedReg_Fall11_branch and "e1dECorrSmearedReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e1dECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedReg_Fall11")
        else:
            self.e1dECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1dECorrSmearedReg_Fall11_value)

        #print "making e1dECorrSmearedReg_Jan16ReReco"
        self.e1dECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1dECorrSmearedReg_Jan16ReReco")
        #if not self.e1dECorrSmearedReg_Jan16ReReco_branch and "e1dECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1dECorrSmearedReg_Jan16ReReco_branch and "e1dECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e1dECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedReg_Jan16ReReco")
        else:
            self.e1dECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1dECorrSmearedReg_Jan16ReReco_value)

        #print "making e1dECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1dECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1dECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1dECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e1dECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1deltaEtaSuperClusterTrackAtVtx"
        self.e1deltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e1deltaEtaSuperClusterTrackAtVtx")
        #if not self.e1deltaEtaSuperClusterTrackAtVtx_branch and "e1deltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.e1deltaEtaSuperClusterTrackAtVtx_branch and "e1deltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "EETauTree: Expected branch e1deltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1deltaEtaSuperClusterTrackAtVtx")
        else:
            self.e1deltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e1deltaEtaSuperClusterTrackAtVtx_value)

        #print "making e1deltaPhiSuperClusterTrackAtVtx"
        self.e1deltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e1deltaPhiSuperClusterTrackAtVtx")
        #if not self.e1deltaPhiSuperClusterTrackAtVtx_branch and "e1deltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.e1deltaPhiSuperClusterTrackAtVtx_branch and "e1deltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "EETauTree: Expected branch e1deltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1deltaPhiSuperClusterTrackAtVtx")
        else:
            self.e1deltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e1deltaPhiSuperClusterTrackAtVtx_value)

        #print "making e1eSuperClusterOverP"
        self.e1eSuperClusterOverP_branch = the_tree.GetBranch("e1eSuperClusterOverP")
        #if not self.e1eSuperClusterOverP_branch and "e1eSuperClusterOverP" not in self.complained:
        if not self.e1eSuperClusterOverP_branch and "e1eSuperClusterOverP":
            warnings.warn( "EETauTree: Expected branch e1eSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1eSuperClusterOverP")
        else:
            self.e1eSuperClusterOverP_branch.SetAddress(<void*>&self.e1eSuperClusterOverP_value)

        #print "making e1ecalEnergy"
        self.e1ecalEnergy_branch = the_tree.GetBranch("e1ecalEnergy")
        #if not self.e1ecalEnergy_branch and "e1ecalEnergy" not in self.complained:
        if not self.e1ecalEnergy_branch and "e1ecalEnergy":
            warnings.warn( "EETauTree: Expected branch e1ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ecalEnergy")
        else:
            self.e1ecalEnergy_branch.SetAddress(<void*>&self.e1ecalEnergy_value)

        #print "making e1fBrem"
        self.e1fBrem_branch = the_tree.GetBranch("e1fBrem")
        #if not self.e1fBrem_branch and "e1fBrem" not in self.complained:
        if not self.e1fBrem_branch and "e1fBrem":
            warnings.warn( "EETauTree: Expected branch e1fBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1fBrem")
        else:
            self.e1fBrem_branch.SetAddress(<void*>&self.e1fBrem_value)

        #print "making e1trackMomentumAtVtxP"
        self.e1trackMomentumAtVtxP_branch = the_tree.GetBranch("e1trackMomentumAtVtxP")
        #if not self.e1trackMomentumAtVtxP_branch and "e1trackMomentumAtVtxP" not in self.complained:
        if not self.e1trackMomentumAtVtxP_branch and "e1trackMomentumAtVtxP":
            warnings.warn( "EETauTree: Expected branch e1trackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1trackMomentumAtVtxP")
        else:
            self.e1trackMomentumAtVtxP_branch.SetAddress(<void*>&self.e1trackMomentumAtVtxP_value)

        #print "making e2AbsEta"
        self.e2AbsEta_branch = the_tree.GetBranch("e2AbsEta")
        #if not self.e2AbsEta_branch and "e2AbsEta" not in self.complained:
        if not self.e2AbsEta_branch and "e2AbsEta":
            warnings.warn( "EETauTree: Expected branch e2AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2AbsEta")
        else:
            self.e2AbsEta_branch.SetAddress(<void*>&self.e2AbsEta_value)

        #print "making e2CBID_LOOSE"
        self.e2CBID_LOOSE_branch = the_tree.GetBranch("e2CBID_LOOSE")
        #if not self.e2CBID_LOOSE_branch and "e2CBID_LOOSE" not in self.complained:
        if not self.e2CBID_LOOSE_branch and "e2CBID_LOOSE":
            warnings.warn( "EETauTree: Expected branch e2CBID_LOOSE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBID_LOOSE")
        else:
            self.e2CBID_LOOSE_branch.SetAddress(<void*>&self.e2CBID_LOOSE_value)

        #print "making e2CBID_MEDIUM"
        self.e2CBID_MEDIUM_branch = the_tree.GetBranch("e2CBID_MEDIUM")
        #if not self.e2CBID_MEDIUM_branch and "e2CBID_MEDIUM" not in self.complained:
        if not self.e2CBID_MEDIUM_branch and "e2CBID_MEDIUM":
            warnings.warn( "EETauTree: Expected branch e2CBID_MEDIUM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBID_MEDIUM")
        else:
            self.e2CBID_MEDIUM_branch.SetAddress(<void*>&self.e2CBID_MEDIUM_value)

        #print "making e2CBID_TIGHT"
        self.e2CBID_TIGHT_branch = the_tree.GetBranch("e2CBID_TIGHT")
        #if not self.e2CBID_TIGHT_branch and "e2CBID_TIGHT" not in self.complained:
        if not self.e2CBID_TIGHT_branch and "e2CBID_TIGHT":
            warnings.warn( "EETauTree: Expected branch e2CBID_TIGHT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBID_TIGHT")
        else:
            self.e2CBID_TIGHT_branch.SetAddress(<void*>&self.e2CBID_TIGHT_value)

        #print "making e2CBID_VETO"
        self.e2CBID_VETO_branch = the_tree.GetBranch("e2CBID_VETO")
        #if not self.e2CBID_VETO_branch and "e2CBID_VETO" not in self.complained:
        if not self.e2CBID_VETO_branch and "e2CBID_VETO":
            warnings.warn( "EETauTree: Expected branch e2CBID_VETO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBID_VETO")
        else:
            self.e2CBID_VETO_branch.SetAddress(<void*>&self.e2CBID_VETO_value)

        #print "making e2Charge"
        self.e2Charge_branch = the_tree.GetBranch("e2Charge")
        #if not self.e2Charge_branch and "e2Charge" not in self.complained:
        if not self.e2Charge_branch and "e2Charge":
            warnings.warn( "EETauTree: Expected branch e2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Charge")
        else:
            self.e2Charge_branch.SetAddress(<void*>&self.e2Charge_value)

        #print "making e2ChargeIdLoose"
        self.e2ChargeIdLoose_branch = the_tree.GetBranch("e2ChargeIdLoose")
        #if not self.e2ChargeIdLoose_branch and "e2ChargeIdLoose" not in self.complained:
        if not self.e2ChargeIdLoose_branch and "e2ChargeIdLoose":
            warnings.warn( "EETauTree: Expected branch e2ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdLoose")
        else:
            self.e2ChargeIdLoose_branch.SetAddress(<void*>&self.e2ChargeIdLoose_value)

        #print "making e2ChargeIdMed"
        self.e2ChargeIdMed_branch = the_tree.GetBranch("e2ChargeIdMed")
        #if not self.e2ChargeIdMed_branch and "e2ChargeIdMed" not in self.complained:
        if not self.e2ChargeIdMed_branch and "e2ChargeIdMed":
            warnings.warn( "EETauTree: Expected branch e2ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdMed")
        else:
            self.e2ChargeIdMed_branch.SetAddress(<void*>&self.e2ChargeIdMed_value)

        #print "making e2ChargeIdTight"
        self.e2ChargeIdTight_branch = the_tree.GetBranch("e2ChargeIdTight")
        #if not self.e2ChargeIdTight_branch and "e2ChargeIdTight" not in self.complained:
        if not self.e2ChargeIdTight_branch and "e2ChargeIdTight":
            warnings.warn( "EETauTree: Expected branch e2ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdTight")
        else:
            self.e2ChargeIdTight_branch.SetAddress(<void*>&self.e2ChargeIdTight_value)

        #print "making e2CiCTight"
        self.e2CiCTight_branch = the_tree.GetBranch("e2CiCTight")
        #if not self.e2CiCTight_branch and "e2CiCTight" not in self.complained:
        if not self.e2CiCTight_branch and "e2CiCTight":
            warnings.warn( "EETauTree: Expected branch e2CiCTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CiCTight")
        else:
            self.e2CiCTight_branch.SetAddress(<void*>&self.e2CiCTight_value)

        #print "making e2ComesFromHiggs"
        self.e2ComesFromHiggs_branch = the_tree.GetBranch("e2ComesFromHiggs")
        #if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs" not in self.complained:
        if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs":
            warnings.warn( "EETauTree: Expected branch e2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ComesFromHiggs")
        else:
            self.e2ComesFromHiggs_branch.SetAddress(<void*>&self.e2ComesFromHiggs_value)

        #print "making e2DZ"
        self.e2DZ_branch = the_tree.GetBranch("e2DZ")
        #if not self.e2DZ_branch and "e2DZ" not in self.complained:
        if not self.e2DZ_branch and "e2DZ":
            warnings.warn( "EETauTree: Expected branch e2DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2DZ")
        else:
            self.e2DZ_branch.SetAddress(<void*>&self.e2DZ_value)

        #print "making e2E1x5"
        self.e2E1x5_branch = the_tree.GetBranch("e2E1x5")
        #if not self.e2E1x5_branch and "e2E1x5" not in self.complained:
        if not self.e2E1x5_branch and "e2E1x5":
            warnings.warn( "EETauTree: Expected branch e2E1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2E1x5")
        else:
            self.e2E1x5_branch.SetAddress(<void*>&self.e2E1x5_value)

        #print "making e2E2x5Max"
        self.e2E2x5Max_branch = the_tree.GetBranch("e2E2x5Max")
        #if not self.e2E2x5Max_branch and "e2E2x5Max" not in self.complained:
        if not self.e2E2x5Max_branch and "e2E2x5Max":
            warnings.warn( "EETauTree: Expected branch e2E2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2E2x5Max")
        else:
            self.e2E2x5Max_branch.SetAddress(<void*>&self.e2E2x5Max_value)

        #print "making e2E5x5"
        self.e2E5x5_branch = the_tree.GetBranch("e2E5x5")
        #if not self.e2E5x5_branch and "e2E5x5" not in self.complained:
        if not self.e2E5x5_branch and "e2E5x5":
            warnings.warn( "EETauTree: Expected branch e2E5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2E5x5")
        else:
            self.e2E5x5_branch.SetAddress(<void*>&self.e2E5x5_value)

        #print "making e2ECorrReg_2012Jul13ReReco"
        self.e2ECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2ECorrReg_2012Jul13ReReco")
        #if not self.e2ECorrReg_2012Jul13ReReco_branch and "e2ECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2ECorrReg_2012Jul13ReReco_branch and "e2ECorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2ECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrReg_2012Jul13ReReco")
        else:
            self.e2ECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2ECorrReg_2012Jul13ReReco_value)

        #print "making e2ECorrReg_Fall11"
        self.e2ECorrReg_Fall11_branch = the_tree.GetBranch("e2ECorrReg_Fall11")
        #if not self.e2ECorrReg_Fall11_branch and "e2ECorrReg_Fall11" not in self.complained:
        if not self.e2ECorrReg_Fall11_branch and "e2ECorrReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2ECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrReg_Fall11")
        else:
            self.e2ECorrReg_Fall11_branch.SetAddress(<void*>&self.e2ECorrReg_Fall11_value)

        #print "making e2ECorrReg_Jan16ReReco"
        self.e2ECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2ECorrReg_Jan16ReReco")
        #if not self.e2ECorrReg_Jan16ReReco_branch and "e2ECorrReg_Jan16ReReco" not in self.complained:
        if not self.e2ECorrReg_Jan16ReReco_branch and "e2ECorrReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2ECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrReg_Jan16ReReco")
        else:
            self.e2ECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2ECorrReg_Jan16ReReco_value)

        #print "making e2ECorrReg_Summer12_DR53X_HCP2012"
        self.e2ECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2ECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2ECorrReg_Summer12_DR53X_HCP2012_branch and "e2ECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2ECorrReg_Summer12_DR53X_HCP2012_branch and "e2ECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2ECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2ECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2ECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2ECorrSmearedNoReg_2012Jul13ReReco"
        self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2ECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch and "e2ECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch and "e2ECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2ECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2ECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2ECorrSmearedNoReg_Fall11"
        self.e2ECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2ECorrSmearedNoReg_Fall11")
        #if not self.e2ECorrSmearedNoReg_Fall11_branch and "e2ECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2ECorrSmearedNoReg_Fall11_branch and "e2ECorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2ECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedNoReg_Fall11")
        else:
            self.e2ECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2ECorrSmearedNoReg_Fall11_value)

        #print "making e2ECorrSmearedNoReg_Jan16ReReco"
        self.e2ECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2ECorrSmearedNoReg_Jan16ReReco")
        #if not self.e2ECorrSmearedNoReg_Jan16ReReco_branch and "e2ECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2ECorrSmearedNoReg_Jan16ReReco_branch and "e2ECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2ECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2ECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2ECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2ECorrSmearedReg_2012Jul13ReReco"
        self.e2ECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2ECorrSmearedReg_2012Jul13ReReco")
        #if not self.e2ECorrSmearedReg_2012Jul13ReReco_branch and "e2ECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2ECorrSmearedReg_2012Jul13ReReco_branch and "e2ECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2ECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2ECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2ECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2ECorrSmearedReg_Fall11"
        self.e2ECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2ECorrSmearedReg_Fall11")
        #if not self.e2ECorrSmearedReg_Fall11_branch and "e2ECorrSmearedReg_Fall11" not in self.complained:
        if not self.e2ECorrSmearedReg_Fall11_branch and "e2ECorrSmearedReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2ECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedReg_Fall11")
        else:
            self.e2ECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2ECorrSmearedReg_Fall11_value)

        #print "making e2ECorrSmearedReg_Jan16ReReco"
        self.e2ECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2ECorrSmearedReg_Jan16ReReco")
        #if not self.e2ECorrSmearedReg_Jan16ReReco_branch and "e2ECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2ECorrSmearedReg_Jan16ReReco_branch and "e2ECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2ECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedReg_Jan16ReReco")
        else:
            self.e2ECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2ECorrSmearedReg_Jan16ReReco_value)

        #print "making e2ECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2ECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2ECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2ECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2ECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2EcalIsoDR03"
        self.e2EcalIsoDR03_branch = the_tree.GetBranch("e2EcalIsoDR03")
        #if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03" not in self.complained:
        if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03":
            warnings.warn( "EETauTree: Expected branch e2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EcalIsoDR03")
        else:
            self.e2EcalIsoDR03_branch.SetAddress(<void*>&self.e2EcalIsoDR03_value)

        #print "making e2EffectiveArea2011Data"
        self.e2EffectiveArea2011Data_branch = the_tree.GetBranch("e2EffectiveArea2011Data")
        #if not self.e2EffectiveArea2011Data_branch and "e2EffectiveArea2011Data" not in self.complained:
        if not self.e2EffectiveArea2011Data_branch and "e2EffectiveArea2011Data":
            warnings.warn( "EETauTree: Expected branch e2EffectiveArea2011Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EffectiveArea2011Data")
        else:
            self.e2EffectiveArea2011Data_branch.SetAddress(<void*>&self.e2EffectiveArea2011Data_value)

        #print "making e2EffectiveArea2012Data"
        self.e2EffectiveArea2012Data_branch = the_tree.GetBranch("e2EffectiveArea2012Data")
        #if not self.e2EffectiveArea2012Data_branch and "e2EffectiveArea2012Data" not in self.complained:
        if not self.e2EffectiveArea2012Data_branch and "e2EffectiveArea2012Data":
            warnings.warn( "EETauTree: Expected branch e2EffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EffectiveArea2012Data")
        else:
            self.e2EffectiveArea2012Data_branch.SetAddress(<void*>&self.e2EffectiveArea2012Data_value)

        #print "making e2EffectiveAreaFall11MC"
        self.e2EffectiveAreaFall11MC_branch = the_tree.GetBranch("e2EffectiveAreaFall11MC")
        #if not self.e2EffectiveAreaFall11MC_branch and "e2EffectiveAreaFall11MC" not in self.complained:
        if not self.e2EffectiveAreaFall11MC_branch and "e2EffectiveAreaFall11MC":
            warnings.warn( "EETauTree: Expected branch e2EffectiveAreaFall11MC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EffectiveAreaFall11MC")
        else:
            self.e2EffectiveAreaFall11MC_branch.SetAddress(<void*>&self.e2EffectiveAreaFall11MC_value)

        #print "making e2Ele27WP80PFMT50PFMTFilter"
        self.e2Ele27WP80PFMT50PFMTFilter_branch = the_tree.GetBranch("e2Ele27WP80PFMT50PFMTFilter")
        #if not self.e2Ele27WP80PFMT50PFMTFilter_branch and "e2Ele27WP80PFMT50PFMTFilter" not in self.complained:
        if not self.e2Ele27WP80PFMT50PFMTFilter_branch and "e2Ele27WP80PFMT50PFMTFilter":
            warnings.warn( "EETauTree: Expected branch e2Ele27WP80PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Ele27WP80PFMT50PFMTFilter")
        else:
            self.e2Ele27WP80PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e2Ele27WP80PFMT50PFMTFilter_value)

        #print "making e2Ele27WP80TrackIsoMatchFilter"
        self.e2Ele27WP80TrackIsoMatchFilter_branch = the_tree.GetBranch("e2Ele27WP80TrackIsoMatchFilter")
        #if not self.e2Ele27WP80TrackIsoMatchFilter_branch and "e2Ele27WP80TrackIsoMatchFilter" not in self.complained:
        if not self.e2Ele27WP80TrackIsoMatchFilter_branch and "e2Ele27WP80TrackIsoMatchFilter":
            warnings.warn( "EETauTree: Expected branch e2Ele27WP80TrackIsoMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Ele27WP80TrackIsoMatchFilter")
        else:
            self.e2Ele27WP80TrackIsoMatchFilter_branch.SetAddress(<void*>&self.e2Ele27WP80TrackIsoMatchFilter_value)

        #print "making e2Ele32WP70PFMT50PFMTFilter"
        self.e2Ele32WP70PFMT50PFMTFilter_branch = the_tree.GetBranch("e2Ele32WP70PFMT50PFMTFilter")
        #if not self.e2Ele32WP70PFMT50PFMTFilter_branch and "e2Ele32WP70PFMT50PFMTFilter" not in self.complained:
        if not self.e2Ele32WP70PFMT50PFMTFilter_branch and "e2Ele32WP70PFMT50PFMTFilter":
            warnings.warn( "EETauTree: Expected branch e2Ele32WP70PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Ele32WP70PFMT50PFMTFilter")
        else:
            self.e2Ele32WP70PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e2Ele32WP70PFMT50PFMTFilter_value)

        #print "making e2EnergyError"
        self.e2EnergyError_branch = the_tree.GetBranch("e2EnergyError")
        #if not self.e2EnergyError_branch and "e2EnergyError" not in self.complained:
        if not self.e2EnergyError_branch and "e2EnergyError":
            warnings.warn( "EETauTree: Expected branch e2EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyError")
        else:
            self.e2EnergyError_branch.SetAddress(<void*>&self.e2EnergyError_value)

        #print "making e2Eta"
        self.e2Eta_branch = the_tree.GetBranch("e2Eta")
        #if not self.e2Eta_branch and "e2Eta" not in self.complained:
        if not self.e2Eta_branch and "e2Eta":
            warnings.warn( "EETauTree: Expected branch e2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Eta")
        else:
            self.e2Eta_branch.SetAddress(<void*>&self.e2Eta_value)

        #print "making e2EtaCorrReg_2012Jul13ReReco"
        self.e2EtaCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2EtaCorrReg_2012Jul13ReReco")
        #if not self.e2EtaCorrReg_2012Jul13ReReco_branch and "e2EtaCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2EtaCorrReg_2012Jul13ReReco_branch and "e2EtaCorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2EtaCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrReg_2012Jul13ReReco")
        else:
            self.e2EtaCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2EtaCorrReg_2012Jul13ReReco_value)

        #print "making e2EtaCorrReg_Fall11"
        self.e2EtaCorrReg_Fall11_branch = the_tree.GetBranch("e2EtaCorrReg_Fall11")
        #if not self.e2EtaCorrReg_Fall11_branch and "e2EtaCorrReg_Fall11" not in self.complained:
        if not self.e2EtaCorrReg_Fall11_branch and "e2EtaCorrReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2EtaCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrReg_Fall11")
        else:
            self.e2EtaCorrReg_Fall11_branch.SetAddress(<void*>&self.e2EtaCorrReg_Fall11_value)

        #print "making e2EtaCorrReg_Jan16ReReco"
        self.e2EtaCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2EtaCorrReg_Jan16ReReco")
        #if not self.e2EtaCorrReg_Jan16ReReco_branch and "e2EtaCorrReg_Jan16ReReco" not in self.complained:
        if not self.e2EtaCorrReg_Jan16ReReco_branch and "e2EtaCorrReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2EtaCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrReg_Jan16ReReco")
        else:
            self.e2EtaCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2EtaCorrReg_Jan16ReReco_value)

        #print "making e2EtaCorrReg_Summer12_DR53X_HCP2012"
        self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2EtaCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2EtaCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2EtaCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2EtaCorrSmearedNoReg_2012Jul13ReReco"
        self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2EtaCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e2EtaCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e2EtaCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2EtaCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2EtaCorrSmearedNoReg_Fall11"
        self.e2EtaCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2EtaCorrSmearedNoReg_Fall11")
        #if not self.e2EtaCorrSmearedNoReg_Fall11_branch and "e2EtaCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2EtaCorrSmearedNoReg_Fall11_branch and "e2EtaCorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2EtaCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedNoReg_Fall11")
        else:
            self.e2EtaCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2EtaCorrSmearedNoReg_Fall11_value)

        #print "making e2EtaCorrSmearedNoReg_Jan16ReReco"
        self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2EtaCorrSmearedNoReg_Jan16ReReco")
        #if not self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch and "e2EtaCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch and "e2EtaCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2EtaCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2EtaCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2EtaCorrSmearedReg_2012Jul13ReReco"
        self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2EtaCorrSmearedReg_2012Jul13ReReco")
        #if not self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch and "e2EtaCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch and "e2EtaCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2EtaCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2EtaCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2EtaCorrSmearedReg_Fall11"
        self.e2EtaCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2EtaCorrSmearedReg_Fall11")
        #if not self.e2EtaCorrSmearedReg_Fall11_branch and "e2EtaCorrSmearedReg_Fall11" not in self.complained:
        if not self.e2EtaCorrSmearedReg_Fall11_branch and "e2EtaCorrSmearedReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2EtaCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedReg_Fall11")
        else:
            self.e2EtaCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2EtaCorrSmearedReg_Fall11_value)

        #print "making e2EtaCorrSmearedReg_Jan16ReReco"
        self.e2EtaCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2EtaCorrSmearedReg_Jan16ReReco")
        #if not self.e2EtaCorrSmearedReg_Jan16ReReco_branch and "e2EtaCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2EtaCorrSmearedReg_Jan16ReReco_branch and "e2EtaCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2EtaCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedReg_Jan16ReReco")
        else:
            self.e2EtaCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2EtaCorrSmearedReg_Jan16ReReco_value)

        #print "making e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2GenCharge"
        self.e2GenCharge_branch = the_tree.GetBranch("e2GenCharge")
        #if not self.e2GenCharge_branch and "e2GenCharge" not in self.complained:
        if not self.e2GenCharge_branch and "e2GenCharge":
            warnings.warn( "EETauTree: Expected branch e2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenCharge")
        else:
            self.e2GenCharge_branch.SetAddress(<void*>&self.e2GenCharge_value)

        #print "making e2GenEnergy"
        self.e2GenEnergy_branch = the_tree.GetBranch("e2GenEnergy")
        #if not self.e2GenEnergy_branch and "e2GenEnergy" not in self.complained:
        if not self.e2GenEnergy_branch and "e2GenEnergy":
            warnings.warn( "EETauTree: Expected branch e2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenEnergy")
        else:
            self.e2GenEnergy_branch.SetAddress(<void*>&self.e2GenEnergy_value)

        #print "making e2GenEta"
        self.e2GenEta_branch = the_tree.GetBranch("e2GenEta")
        #if not self.e2GenEta_branch and "e2GenEta" not in self.complained:
        if not self.e2GenEta_branch and "e2GenEta":
            warnings.warn( "EETauTree: Expected branch e2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenEta")
        else:
            self.e2GenEta_branch.SetAddress(<void*>&self.e2GenEta_value)

        #print "making e2GenMotherPdgId"
        self.e2GenMotherPdgId_branch = the_tree.GetBranch("e2GenMotherPdgId")
        #if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId" not in self.complained:
        if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId":
            warnings.warn( "EETauTree: Expected branch e2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenMotherPdgId")
        else:
            self.e2GenMotherPdgId_branch.SetAddress(<void*>&self.e2GenMotherPdgId_value)

        #print "making e2GenPdgId"
        self.e2GenPdgId_branch = the_tree.GetBranch("e2GenPdgId")
        #if not self.e2GenPdgId_branch and "e2GenPdgId" not in self.complained:
        if not self.e2GenPdgId_branch and "e2GenPdgId":
            warnings.warn( "EETauTree: Expected branch e2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPdgId")
        else:
            self.e2GenPdgId_branch.SetAddress(<void*>&self.e2GenPdgId_value)

        #print "making e2GenPhi"
        self.e2GenPhi_branch = the_tree.GetBranch("e2GenPhi")
        #if not self.e2GenPhi_branch and "e2GenPhi" not in self.complained:
        if not self.e2GenPhi_branch and "e2GenPhi":
            warnings.warn( "EETauTree: Expected branch e2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPhi")
        else:
            self.e2GenPhi_branch.SetAddress(<void*>&self.e2GenPhi_value)

        #print "making e2HadronicDepth1OverEm"
        self.e2HadronicDepth1OverEm_branch = the_tree.GetBranch("e2HadronicDepth1OverEm")
        #if not self.e2HadronicDepth1OverEm_branch and "e2HadronicDepth1OverEm" not in self.complained:
        if not self.e2HadronicDepth1OverEm_branch and "e2HadronicDepth1OverEm":
            warnings.warn( "EETauTree: Expected branch e2HadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HadronicDepth1OverEm")
        else:
            self.e2HadronicDepth1OverEm_branch.SetAddress(<void*>&self.e2HadronicDepth1OverEm_value)

        #print "making e2HadronicDepth2OverEm"
        self.e2HadronicDepth2OverEm_branch = the_tree.GetBranch("e2HadronicDepth2OverEm")
        #if not self.e2HadronicDepth2OverEm_branch and "e2HadronicDepth2OverEm" not in self.complained:
        if not self.e2HadronicDepth2OverEm_branch and "e2HadronicDepth2OverEm":
            warnings.warn( "EETauTree: Expected branch e2HadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HadronicDepth2OverEm")
        else:
            self.e2HadronicDepth2OverEm_branch.SetAddress(<void*>&self.e2HadronicDepth2OverEm_value)

        #print "making e2HadronicOverEM"
        self.e2HadronicOverEM_branch = the_tree.GetBranch("e2HadronicOverEM")
        #if not self.e2HadronicOverEM_branch and "e2HadronicOverEM" not in self.complained:
        if not self.e2HadronicOverEM_branch and "e2HadronicOverEM":
            warnings.warn( "EETauTree: Expected branch e2HadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HadronicOverEM")
        else:
            self.e2HadronicOverEM_branch.SetAddress(<void*>&self.e2HadronicOverEM_value)

        #print "making e2HasConversion"
        self.e2HasConversion_branch = the_tree.GetBranch("e2HasConversion")
        #if not self.e2HasConversion_branch and "e2HasConversion" not in self.complained:
        if not self.e2HasConversion_branch and "e2HasConversion":
            warnings.warn( "EETauTree: Expected branch e2HasConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HasConversion")
        else:
            self.e2HasConversion_branch.SetAddress(<void*>&self.e2HasConversion_value)

        #print "making e2HasMatchedConversion"
        self.e2HasMatchedConversion_branch = the_tree.GetBranch("e2HasMatchedConversion")
        #if not self.e2HasMatchedConversion_branch and "e2HasMatchedConversion" not in self.complained:
        if not self.e2HasMatchedConversion_branch and "e2HasMatchedConversion":
            warnings.warn( "EETauTree: Expected branch e2HasMatchedConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HasMatchedConversion")
        else:
            self.e2HasMatchedConversion_branch.SetAddress(<void*>&self.e2HasMatchedConversion_value)

        #print "making e2HcalIsoDR03"
        self.e2HcalIsoDR03_branch = the_tree.GetBranch("e2HcalIsoDR03")
        #if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03" not in self.complained:
        if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03":
            warnings.warn( "EETauTree: Expected branch e2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HcalIsoDR03")
        else:
            self.e2HcalIsoDR03_branch.SetAddress(<void*>&self.e2HcalIsoDR03_value)

        #print "making e2IP3DS"
        self.e2IP3DS_branch = the_tree.GetBranch("e2IP3DS")
        #if not self.e2IP3DS_branch and "e2IP3DS" not in self.complained:
        if not self.e2IP3DS_branch and "e2IP3DS":
            warnings.warn( "EETauTree: Expected branch e2IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IP3DS")
        else:
            self.e2IP3DS_branch.SetAddress(<void*>&self.e2IP3DS_value)

        #print "making e2JetArea"
        self.e2JetArea_branch = the_tree.GetBranch("e2JetArea")
        #if not self.e2JetArea_branch and "e2JetArea" not in self.complained:
        if not self.e2JetArea_branch and "e2JetArea":
            warnings.warn( "EETauTree: Expected branch e2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetArea")
        else:
            self.e2JetArea_branch.SetAddress(<void*>&self.e2JetArea_value)

        #print "making e2JetBtag"
        self.e2JetBtag_branch = the_tree.GetBranch("e2JetBtag")
        #if not self.e2JetBtag_branch and "e2JetBtag" not in self.complained:
        if not self.e2JetBtag_branch and "e2JetBtag":
            warnings.warn( "EETauTree: Expected branch e2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetBtag")
        else:
            self.e2JetBtag_branch.SetAddress(<void*>&self.e2JetBtag_value)

        #print "making e2JetCSVBtag"
        self.e2JetCSVBtag_branch = the_tree.GetBranch("e2JetCSVBtag")
        #if not self.e2JetCSVBtag_branch and "e2JetCSVBtag" not in self.complained:
        if not self.e2JetCSVBtag_branch and "e2JetCSVBtag":
            warnings.warn( "EETauTree: Expected branch e2JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetCSVBtag")
        else:
            self.e2JetCSVBtag_branch.SetAddress(<void*>&self.e2JetCSVBtag_value)

        #print "making e2JetEtaEtaMoment"
        self.e2JetEtaEtaMoment_branch = the_tree.GetBranch("e2JetEtaEtaMoment")
        #if not self.e2JetEtaEtaMoment_branch and "e2JetEtaEtaMoment" not in self.complained:
        if not self.e2JetEtaEtaMoment_branch and "e2JetEtaEtaMoment":
            warnings.warn( "EETauTree: Expected branch e2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaEtaMoment")
        else:
            self.e2JetEtaEtaMoment_branch.SetAddress(<void*>&self.e2JetEtaEtaMoment_value)

        #print "making e2JetEtaPhiMoment"
        self.e2JetEtaPhiMoment_branch = the_tree.GetBranch("e2JetEtaPhiMoment")
        #if not self.e2JetEtaPhiMoment_branch and "e2JetEtaPhiMoment" not in self.complained:
        if not self.e2JetEtaPhiMoment_branch and "e2JetEtaPhiMoment":
            warnings.warn( "EETauTree: Expected branch e2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaPhiMoment")
        else:
            self.e2JetEtaPhiMoment_branch.SetAddress(<void*>&self.e2JetEtaPhiMoment_value)

        #print "making e2JetEtaPhiSpread"
        self.e2JetEtaPhiSpread_branch = the_tree.GetBranch("e2JetEtaPhiSpread")
        #if not self.e2JetEtaPhiSpread_branch and "e2JetEtaPhiSpread" not in self.complained:
        if not self.e2JetEtaPhiSpread_branch and "e2JetEtaPhiSpread":
            warnings.warn( "EETauTree: Expected branch e2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaPhiSpread")
        else:
            self.e2JetEtaPhiSpread_branch.SetAddress(<void*>&self.e2JetEtaPhiSpread_value)

        #print "making e2JetPhiPhiMoment"
        self.e2JetPhiPhiMoment_branch = the_tree.GetBranch("e2JetPhiPhiMoment")
        #if not self.e2JetPhiPhiMoment_branch and "e2JetPhiPhiMoment" not in self.complained:
        if not self.e2JetPhiPhiMoment_branch and "e2JetPhiPhiMoment":
            warnings.warn( "EETauTree: Expected branch e2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPhiPhiMoment")
        else:
            self.e2JetPhiPhiMoment_branch.SetAddress(<void*>&self.e2JetPhiPhiMoment_value)

        #print "making e2JetPt"
        self.e2JetPt_branch = the_tree.GetBranch("e2JetPt")
        #if not self.e2JetPt_branch and "e2JetPt" not in self.complained:
        if not self.e2JetPt_branch and "e2JetPt":
            warnings.warn( "EETauTree: Expected branch e2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPt")
        else:
            self.e2JetPt_branch.SetAddress(<void*>&self.e2JetPt_value)

        #print "making e2JetQGLikelihoodID"
        self.e2JetQGLikelihoodID_branch = the_tree.GetBranch("e2JetQGLikelihoodID")
        #if not self.e2JetQGLikelihoodID_branch and "e2JetQGLikelihoodID" not in self.complained:
        if not self.e2JetQGLikelihoodID_branch and "e2JetQGLikelihoodID":
            warnings.warn( "EETauTree: Expected branch e2JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetQGLikelihoodID")
        else:
            self.e2JetQGLikelihoodID_branch.SetAddress(<void*>&self.e2JetQGLikelihoodID_value)

        #print "making e2JetQGMVAID"
        self.e2JetQGMVAID_branch = the_tree.GetBranch("e2JetQGMVAID")
        #if not self.e2JetQGMVAID_branch and "e2JetQGMVAID" not in self.complained:
        if not self.e2JetQGMVAID_branch and "e2JetQGMVAID":
            warnings.warn( "EETauTree: Expected branch e2JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetQGMVAID")
        else:
            self.e2JetQGMVAID_branch.SetAddress(<void*>&self.e2JetQGMVAID_value)

        #print "making e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter"
        self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch = the_tree.GetBranch("e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        #if not self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter" not in self.complained:
        if not self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter":
            warnings.warn( "EETauTree: Expected branch e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        else:
            self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.SetAddress(<void*>&self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value)

        #print "making e2MITID"
        self.e2MITID_branch = the_tree.GetBranch("e2MITID")
        #if not self.e2MITID_branch and "e2MITID" not in self.complained:
        if not self.e2MITID_branch and "e2MITID":
            warnings.warn( "EETauTree: Expected branch e2MITID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MITID")
        else:
            self.e2MITID_branch.SetAddress(<void*>&self.e2MITID_value)

        #print "making e2MVAIDH2TauWP"
        self.e2MVAIDH2TauWP_branch = the_tree.GetBranch("e2MVAIDH2TauWP")
        #if not self.e2MVAIDH2TauWP_branch and "e2MVAIDH2TauWP" not in self.complained:
        if not self.e2MVAIDH2TauWP_branch and "e2MVAIDH2TauWP":
            warnings.warn( "EETauTree: Expected branch e2MVAIDH2TauWP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVAIDH2TauWP")
        else:
            self.e2MVAIDH2TauWP_branch.SetAddress(<void*>&self.e2MVAIDH2TauWP_value)

        #print "making e2MVANonTrig"
        self.e2MVANonTrig_branch = the_tree.GetBranch("e2MVANonTrig")
        #if not self.e2MVANonTrig_branch and "e2MVANonTrig" not in self.complained:
        if not self.e2MVANonTrig_branch and "e2MVANonTrig":
            warnings.warn( "EETauTree: Expected branch e2MVANonTrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANonTrig")
        else:
            self.e2MVANonTrig_branch.SetAddress(<void*>&self.e2MVANonTrig_value)

        #print "making e2MVATrig"
        self.e2MVATrig_branch = the_tree.GetBranch("e2MVATrig")
        #if not self.e2MVATrig_branch and "e2MVATrig" not in self.complained:
        if not self.e2MVATrig_branch and "e2MVATrig":
            warnings.warn( "EETauTree: Expected branch e2MVATrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrig")
        else:
            self.e2MVATrig_branch.SetAddress(<void*>&self.e2MVATrig_value)

        #print "making e2MVATrigIDISO"
        self.e2MVATrigIDISO_branch = the_tree.GetBranch("e2MVATrigIDISO")
        #if not self.e2MVATrigIDISO_branch and "e2MVATrigIDISO" not in self.complained:
        if not self.e2MVATrigIDISO_branch and "e2MVATrigIDISO":
            warnings.warn( "EETauTree: Expected branch e2MVATrigIDISO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigIDISO")
        else:
            self.e2MVATrigIDISO_branch.SetAddress(<void*>&self.e2MVATrigIDISO_value)

        #print "making e2MVATrigIDISOPUSUB"
        self.e2MVATrigIDISOPUSUB_branch = the_tree.GetBranch("e2MVATrigIDISOPUSUB")
        #if not self.e2MVATrigIDISOPUSUB_branch and "e2MVATrigIDISOPUSUB" not in self.complained:
        if not self.e2MVATrigIDISOPUSUB_branch and "e2MVATrigIDISOPUSUB":
            warnings.warn( "EETauTree: Expected branch e2MVATrigIDISOPUSUB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigIDISOPUSUB")
        else:
            self.e2MVATrigIDISOPUSUB_branch.SetAddress(<void*>&self.e2MVATrigIDISOPUSUB_value)

        #print "making e2MVATrigNoIP"
        self.e2MVATrigNoIP_branch = the_tree.GetBranch("e2MVATrigNoIP")
        #if not self.e2MVATrigNoIP_branch and "e2MVATrigNoIP" not in self.complained:
        if not self.e2MVATrigNoIP_branch and "e2MVATrigNoIP":
            warnings.warn( "EETauTree: Expected branch e2MVATrigNoIP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigNoIP")
        else:
            self.e2MVATrigNoIP_branch.SetAddress(<void*>&self.e2MVATrigNoIP_value)

        #print "making e2Mass"
        self.e2Mass_branch = the_tree.GetBranch("e2Mass")
        #if not self.e2Mass_branch and "e2Mass" not in self.complained:
        if not self.e2Mass_branch and "e2Mass":
            warnings.warn( "EETauTree: Expected branch e2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mass")
        else:
            self.e2Mass_branch.SetAddress(<void*>&self.e2Mass_value)

        #print "making e2MatchesDoubleEPath"
        self.e2MatchesDoubleEPath_branch = the_tree.GetBranch("e2MatchesDoubleEPath")
        #if not self.e2MatchesDoubleEPath_branch and "e2MatchesDoubleEPath" not in self.complained:
        if not self.e2MatchesDoubleEPath_branch and "e2MatchesDoubleEPath":
            warnings.warn( "EETauTree: Expected branch e2MatchesDoubleEPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesDoubleEPath")
        else:
            self.e2MatchesDoubleEPath_branch.SetAddress(<void*>&self.e2MatchesDoubleEPath_value)

        #print "making e2MatchesMu17Ele8IsoPath"
        self.e2MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("e2MatchesMu17Ele8IsoPath")
        #if not self.e2MatchesMu17Ele8IsoPath_branch and "e2MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.e2MatchesMu17Ele8IsoPath_branch and "e2MatchesMu17Ele8IsoPath":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu17Ele8IsoPath")
        else:
            self.e2MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.e2MatchesMu17Ele8IsoPath_value)

        #print "making e2MatchesMu17Ele8Path"
        self.e2MatchesMu17Ele8Path_branch = the_tree.GetBranch("e2MatchesMu17Ele8Path")
        #if not self.e2MatchesMu17Ele8Path_branch and "e2MatchesMu17Ele8Path" not in self.complained:
        if not self.e2MatchesMu17Ele8Path_branch and "e2MatchesMu17Ele8Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu17Ele8Path")
        else:
            self.e2MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.e2MatchesMu17Ele8Path_value)

        #print "making e2MatchesMu8Ele17IsoPath"
        self.e2MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("e2MatchesMu8Ele17IsoPath")
        #if not self.e2MatchesMu8Ele17IsoPath_branch and "e2MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.e2MatchesMu8Ele17IsoPath_branch and "e2MatchesMu8Ele17IsoPath":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8Ele17IsoPath")
        else:
            self.e2MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.e2MatchesMu8Ele17IsoPath_value)

        #print "making e2MatchesMu8Ele17Path"
        self.e2MatchesMu8Ele17Path_branch = the_tree.GetBranch("e2MatchesMu8Ele17Path")
        #if not self.e2MatchesMu8Ele17Path_branch and "e2MatchesMu8Ele17Path" not in self.complained:
        if not self.e2MatchesMu8Ele17Path_branch and "e2MatchesMu8Ele17Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8Ele17Path")
        else:
            self.e2MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.e2MatchesMu8Ele17Path_value)

        #print "making e2MatchesSingleE"
        self.e2MatchesSingleE_branch = the_tree.GetBranch("e2MatchesSingleE")
        #if not self.e2MatchesSingleE_branch and "e2MatchesSingleE" not in self.complained:
        if not self.e2MatchesSingleE_branch and "e2MatchesSingleE":
            warnings.warn( "EETauTree: Expected branch e2MatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesSingleE")
        else:
            self.e2MatchesSingleE_branch.SetAddress(<void*>&self.e2MatchesSingleE_value)

        #print "making e2MatchesSingleE27WP80"
        self.e2MatchesSingleE27WP80_branch = the_tree.GetBranch("e2MatchesSingleE27WP80")
        #if not self.e2MatchesSingleE27WP80_branch and "e2MatchesSingleE27WP80" not in self.complained:
        if not self.e2MatchesSingleE27WP80_branch and "e2MatchesSingleE27WP80":
            warnings.warn( "EETauTree: Expected branch e2MatchesSingleE27WP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesSingleE27WP80")
        else:
            self.e2MatchesSingleE27WP80_branch.SetAddress(<void*>&self.e2MatchesSingleE27WP80_value)

        #print "making e2MatchesSingleEPlusMET"
        self.e2MatchesSingleEPlusMET_branch = the_tree.GetBranch("e2MatchesSingleEPlusMET")
        #if not self.e2MatchesSingleEPlusMET_branch and "e2MatchesSingleEPlusMET" not in self.complained:
        if not self.e2MatchesSingleEPlusMET_branch and "e2MatchesSingleEPlusMET":
            warnings.warn( "EETauTree: Expected branch e2MatchesSingleEPlusMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesSingleEPlusMET")
        else:
            self.e2MatchesSingleEPlusMET_branch.SetAddress(<void*>&self.e2MatchesSingleEPlusMET_value)

        #print "making e2MissingHits"
        self.e2MissingHits_branch = the_tree.GetBranch("e2MissingHits")
        #if not self.e2MissingHits_branch and "e2MissingHits" not in self.complained:
        if not self.e2MissingHits_branch and "e2MissingHits":
            warnings.warn( "EETauTree: Expected branch e2MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MissingHits")
        else:
            self.e2MissingHits_branch.SetAddress(<void*>&self.e2MissingHits_value)

        #print "making e2MtToMET"
        self.e2MtToMET_branch = the_tree.GetBranch("e2MtToMET")
        #if not self.e2MtToMET_branch and "e2MtToMET" not in self.complained:
        if not self.e2MtToMET_branch and "e2MtToMET":
            warnings.warn( "EETauTree: Expected branch e2MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToMET")
        else:
            self.e2MtToMET_branch.SetAddress(<void*>&self.e2MtToMET_value)

        #print "making e2MtToMVAMET"
        self.e2MtToMVAMET_branch = the_tree.GetBranch("e2MtToMVAMET")
        #if not self.e2MtToMVAMET_branch and "e2MtToMVAMET" not in self.complained:
        if not self.e2MtToMVAMET_branch and "e2MtToMVAMET":
            warnings.warn( "EETauTree: Expected branch e2MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToMVAMET")
        else:
            self.e2MtToMVAMET_branch.SetAddress(<void*>&self.e2MtToMVAMET_value)

        #print "making e2MtToPfMet"
        self.e2MtToPfMet_branch = the_tree.GetBranch("e2MtToPfMet")
        #if not self.e2MtToPfMet_branch and "e2MtToPfMet" not in self.complained:
        if not self.e2MtToPfMet_branch and "e2MtToPfMet":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet")
        else:
            self.e2MtToPfMet_branch.SetAddress(<void*>&self.e2MtToPfMet_value)

        #print "making e2MtToPfMet_Ty1"
        self.e2MtToPfMet_Ty1_branch = the_tree.GetBranch("e2MtToPfMet_Ty1")
        #if not self.e2MtToPfMet_Ty1_branch and "e2MtToPfMet_Ty1" not in self.complained:
        if not self.e2MtToPfMet_Ty1_branch and "e2MtToPfMet_Ty1":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_Ty1")
        else:
            self.e2MtToPfMet_Ty1_branch.SetAddress(<void*>&self.e2MtToPfMet_Ty1_value)

        #print "making e2MtToPfMet_ees"
        self.e2MtToPfMet_ees_branch = the_tree.GetBranch("e2MtToPfMet_ees")
        #if not self.e2MtToPfMet_ees_branch and "e2MtToPfMet_ees" not in self.complained:
        if not self.e2MtToPfMet_ees_branch and "e2MtToPfMet_ees":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_ees does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_ees")
        else:
            self.e2MtToPfMet_ees_branch.SetAddress(<void*>&self.e2MtToPfMet_ees_value)

        #print "making e2MtToPfMet_ees_minus"
        self.e2MtToPfMet_ees_minus_branch = the_tree.GetBranch("e2MtToPfMet_ees_minus")
        #if not self.e2MtToPfMet_ees_minus_branch and "e2MtToPfMet_ees_minus" not in self.complained:
        if not self.e2MtToPfMet_ees_minus_branch and "e2MtToPfMet_ees_minus":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_ees_minus")
        else:
            self.e2MtToPfMet_ees_minus_branch.SetAddress(<void*>&self.e2MtToPfMet_ees_minus_value)

        #print "making e2MtToPfMet_ees_plus"
        self.e2MtToPfMet_ees_plus_branch = the_tree.GetBranch("e2MtToPfMet_ees_plus")
        #if not self.e2MtToPfMet_ees_plus_branch and "e2MtToPfMet_ees_plus" not in self.complained:
        if not self.e2MtToPfMet_ees_plus_branch and "e2MtToPfMet_ees_plus":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_ees_plus")
        else:
            self.e2MtToPfMet_ees_plus_branch.SetAddress(<void*>&self.e2MtToPfMet_ees_plus_value)

        #print "making e2MtToPfMet_jes"
        self.e2MtToPfMet_jes_branch = the_tree.GetBranch("e2MtToPfMet_jes")
        #if not self.e2MtToPfMet_jes_branch and "e2MtToPfMet_jes" not in self.complained:
        if not self.e2MtToPfMet_jes_branch and "e2MtToPfMet_jes":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_jes")
        else:
            self.e2MtToPfMet_jes_branch.SetAddress(<void*>&self.e2MtToPfMet_jes_value)

        #print "making e2MtToPfMet_jes_minus"
        self.e2MtToPfMet_jes_minus_branch = the_tree.GetBranch("e2MtToPfMet_jes_minus")
        #if not self.e2MtToPfMet_jes_minus_branch and "e2MtToPfMet_jes_minus" not in self.complained:
        if not self.e2MtToPfMet_jes_minus_branch and "e2MtToPfMet_jes_minus":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_jes_minus")
        else:
            self.e2MtToPfMet_jes_minus_branch.SetAddress(<void*>&self.e2MtToPfMet_jes_minus_value)

        #print "making e2MtToPfMet_jes_plus"
        self.e2MtToPfMet_jes_plus_branch = the_tree.GetBranch("e2MtToPfMet_jes_plus")
        #if not self.e2MtToPfMet_jes_plus_branch and "e2MtToPfMet_jes_plus" not in self.complained:
        if not self.e2MtToPfMet_jes_plus_branch and "e2MtToPfMet_jes_plus":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_jes_plus")
        else:
            self.e2MtToPfMet_jes_plus_branch.SetAddress(<void*>&self.e2MtToPfMet_jes_plus_value)

        #print "making e2MtToPfMet_mes"
        self.e2MtToPfMet_mes_branch = the_tree.GetBranch("e2MtToPfMet_mes")
        #if not self.e2MtToPfMet_mes_branch and "e2MtToPfMet_mes" not in self.complained:
        if not self.e2MtToPfMet_mes_branch and "e2MtToPfMet_mes":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_mes")
        else:
            self.e2MtToPfMet_mes_branch.SetAddress(<void*>&self.e2MtToPfMet_mes_value)

        #print "making e2MtToPfMet_mes_minus"
        self.e2MtToPfMet_mes_minus_branch = the_tree.GetBranch("e2MtToPfMet_mes_minus")
        #if not self.e2MtToPfMet_mes_minus_branch and "e2MtToPfMet_mes_minus" not in self.complained:
        if not self.e2MtToPfMet_mes_minus_branch and "e2MtToPfMet_mes_minus":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_mes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_mes_minus")
        else:
            self.e2MtToPfMet_mes_minus_branch.SetAddress(<void*>&self.e2MtToPfMet_mes_minus_value)

        #print "making e2MtToPfMet_mes_plus"
        self.e2MtToPfMet_mes_plus_branch = the_tree.GetBranch("e2MtToPfMet_mes_plus")
        #if not self.e2MtToPfMet_mes_plus_branch and "e2MtToPfMet_mes_plus" not in self.complained:
        if not self.e2MtToPfMet_mes_plus_branch and "e2MtToPfMet_mes_plus":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_mes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_mes_plus")
        else:
            self.e2MtToPfMet_mes_plus_branch.SetAddress(<void*>&self.e2MtToPfMet_mes_plus_value)

        #print "making e2MtToPfMet_tes"
        self.e2MtToPfMet_tes_branch = the_tree.GetBranch("e2MtToPfMet_tes")
        #if not self.e2MtToPfMet_tes_branch and "e2MtToPfMet_tes" not in self.complained:
        if not self.e2MtToPfMet_tes_branch and "e2MtToPfMet_tes":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_tes")
        else:
            self.e2MtToPfMet_tes_branch.SetAddress(<void*>&self.e2MtToPfMet_tes_value)

        #print "making e2MtToPfMet_tes_minus"
        self.e2MtToPfMet_tes_minus_branch = the_tree.GetBranch("e2MtToPfMet_tes_minus")
        #if not self.e2MtToPfMet_tes_minus_branch and "e2MtToPfMet_tes_minus" not in self.complained:
        if not self.e2MtToPfMet_tes_minus_branch and "e2MtToPfMet_tes_minus":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_tes_minus")
        else:
            self.e2MtToPfMet_tes_minus_branch.SetAddress(<void*>&self.e2MtToPfMet_tes_minus_value)

        #print "making e2MtToPfMet_tes_plus"
        self.e2MtToPfMet_tes_plus_branch = the_tree.GetBranch("e2MtToPfMet_tes_plus")
        #if not self.e2MtToPfMet_tes_plus_branch and "e2MtToPfMet_tes_plus" not in self.complained:
        if not self.e2MtToPfMet_tes_plus_branch and "e2MtToPfMet_tes_plus":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_tes_plus")
        else:
            self.e2MtToPfMet_tes_plus_branch.SetAddress(<void*>&self.e2MtToPfMet_tes_plus_value)

        #print "making e2MtToPfMet_ues"
        self.e2MtToPfMet_ues_branch = the_tree.GetBranch("e2MtToPfMet_ues")
        #if not self.e2MtToPfMet_ues_branch and "e2MtToPfMet_ues" not in self.complained:
        if not self.e2MtToPfMet_ues_branch and "e2MtToPfMet_ues":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_ues")
        else:
            self.e2MtToPfMet_ues_branch.SetAddress(<void*>&self.e2MtToPfMet_ues_value)

        #print "making e2MtToPfMet_ues_minus"
        self.e2MtToPfMet_ues_minus_branch = the_tree.GetBranch("e2MtToPfMet_ues_minus")
        #if not self.e2MtToPfMet_ues_minus_branch and "e2MtToPfMet_ues_minus" not in self.complained:
        if not self.e2MtToPfMet_ues_minus_branch and "e2MtToPfMet_ues_minus":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_ues_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_ues_minus")
        else:
            self.e2MtToPfMet_ues_minus_branch.SetAddress(<void*>&self.e2MtToPfMet_ues_minus_value)

        #print "making e2MtToPfMet_ues_plus"
        self.e2MtToPfMet_ues_plus_branch = the_tree.GetBranch("e2MtToPfMet_ues_plus")
        #if not self.e2MtToPfMet_ues_plus_branch and "e2MtToPfMet_ues_plus" not in self.complained:
        if not self.e2MtToPfMet_ues_plus_branch and "e2MtToPfMet_ues_plus":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_ues_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_ues_plus")
        else:
            self.e2MtToPfMet_ues_plus_branch.SetAddress(<void*>&self.e2MtToPfMet_ues_plus_value)

        #print "making e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter"
        self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch = the_tree.GetBranch("e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        #if not self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter" not in self.complained:
        if not self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter":
            warnings.warn( "EETauTree: Expected branch e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        else:
            self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.SetAddress(<void*>&self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value)

        #print "making e2Mu17Ele8CaloIdTPixelMatchFilter"
        self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch = the_tree.GetBranch("e2Mu17Ele8CaloIdTPixelMatchFilter")
        #if not self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch and "e2Mu17Ele8CaloIdTPixelMatchFilter" not in self.complained:
        if not self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch and "e2Mu17Ele8CaloIdTPixelMatchFilter":
            warnings.warn( "EETauTree: Expected branch e2Mu17Ele8CaloIdTPixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mu17Ele8CaloIdTPixelMatchFilter")
        else:
            self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch.SetAddress(<void*>&self.e2Mu17Ele8CaloIdTPixelMatchFilter_value)

        #print "making e2Mu17Ele8dZFilter"
        self.e2Mu17Ele8dZFilter_branch = the_tree.GetBranch("e2Mu17Ele8dZFilter")
        #if not self.e2Mu17Ele8dZFilter_branch and "e2Mu17Ele8dZFilter" not in self.complained:
        if not self.e2Mu17Ele8dZFilter_branch and "e2Mu17Ele8dZFilter":
            warnings.warn( "EETauTree: Expected branch e2Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mu17Ele8dZFilter")
        else:
            self.e2Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.e2Mu17Ele8dZFilter_value)

        #print "making e2NearMuonVeto"
        self.e2NearMuonVeto_branch = the_tree.GetBranch("e2NearMuonVeto")
        #if not self.e2NearMuonVeto_branch and "e2NearMuonVeto" not in self.complained:
        if not self.e2NearMuonVeto_branch and "e2NearMuonVeto":
            warnings.warn( "EETauTree: Expected branch e2NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearMuonVeto")
        else:
            self.e2NearMuonVeto_branch.SetAddress(<void*>&self.e2NearMuonVeto_value)

        #print "making e2PFChargedIso"
        self.e2PFChargedIso_branch = the_tree.GetBranch("e2PFChargedIso")
        #if not self.e2PFChargedIso_branch and "e2PFChargedIso" not in self.complained:
        if not self.e2PFChargedIso_branch and "e2PFChargedIso":
            warnings.warn( "EETauTree: Expected branch e2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFChargedIso")
        else:
            self.e2PFChargedIso_branch.SetAddress(<void*>&self.e2PFChargedIso_value)

        #print "making e2PFNeutralIso"
        self.e2PFNeutralIso_branch = the_tree.GetBranch("e2PFNeutralIso")
        #if not self.e2PFNeutralIso_branch and "e2PFNeutralIso" not in self.complained:
        if not self.e2PFNeutralIso_branch and "e2PFNeutralIso":
            warnings.warn( "EETauTree: Expected branch e2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFNeutralIso")
        else:
            self.e2PFNeutralIso_branch.SetAddress(<void*>&self.e2PFNeutralIso_value)

        #print "making e2PFPhotonIso"
        self.e2PFPhotonIso_branch = the_tree.GetBranch("e2PFPhotonIso")
        #if not self.e2PFPhotonIso_branch and "e2PFPhotonIso" not in self.complained:
        if not self.e2PFPhotonIso_branch and "e2PFPhotonIso":
            warnings.warn( "EETauTree: Expected branch e2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFPhotonIso")
        else:
            self.e2PFPhotonIso_branch.SetAddress(<void*>&self.e2PFPhotonIso_value)

        #print "making e2PVDXY"
        self.e2PVDXY_branch = the_tree.GetBranch("e2PVDXY")
        #if not self.e2PVDXY_branch and "e2PVDXY" not in self.complained:
        if not self.e2PVDXY_branch and "e2PVDXY":
            warnings.warn( "EETauTree: Expected branch e2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PVDXY")
        else:
            self.e2PVDXY_branch.SetAddress(<void*>&self.e2PVDXY_value)

        #print "making e2PVDZ"
        self.e2PVDZ_branch = the_tree.GetBranch("e2PVDZ")
        #if not self.e2PVDZ_branch and "e2PVDZ" not in self.complained:
        if not self.e2PVDZ_branch and "e2PVDZ":
            warnings.warn( "EETauTree: Expected branch e2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PVDZ")
        else:
            self.e2PVDZ_branch.SetAddress(<void*>&self.e2PVDZ_value)

        #print "making e2Phi"
        self.e2Phi_branch = the_tree.GetBranch("e2Phi")
        #if not self.e2Phi_branch and "e2Phi" not in self.complained:
        if not self.e2Phi_branch and "e2Phi":
            warnings.warn( "EETauTree: Expected branch e2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Phi")
        else:
            self.e2Phi_branch.SetAddress(<void*>&self.e2Phi_value)

        #print "making e2PhiCorrReg_2012Jul13ReReco"
        self.e2PhiCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PhiCorrReg_2012Jul13ReReco")
        #if not self.e2PhiCorrReg_2012Jul13ReReco_branch and "e2PhiCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PhiCorrReg_2012Jul13ReReco_branch and "e2PhiCorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2PhiCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrReg_2012Jul13ReReco")
        else:
            self.e2PhiCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PhiCorrReg_2012Jul13ReReco_value)

        #print "making e2PhiCorrReg_Fall11"
        self.e2PhiCorrReg_Fall11_branch = the_tree.GetBranch("e2PhiCorrReg_Fall11")
        #if not self.e2PhiCorrReg_Fall11_branch and "e2PhiCorrReg_Fall11" not in self.complained:
        if not self.e2PhiCorrReg_Fall11_branch and "e2PhiCorrReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2PhiCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrReg_Fall11")
        else:
            self.e2PhiCorrReg_Fall11_branch.SetAddress(<void*>&self.e2PhiCorrReg_Fall11_value)

        #print "making e2PhiCorrReg_Jan16ReReco"
        self.e2PhiCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2PhiCorrReg_Jan16ReReco")
        #if not self.e2PhiCorrReg_Jan16ReReco_branch and "e2PhiCorrReg_Jan16ReReco" not in self.complained:
        if not self.e2PhiCorrReg_Jan16ReReco_branch and "e2PhiCorrReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2PhiCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrReg_Jan16ReReco")
        else:
            self.e2PhiCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PhiCorrReg_Jan16ReReco_value)

        #print "making e2PhiCorrReg_Summer12_DR53X_HCP2012"
        self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PhiCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2PhiCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PhiCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2PhiCorrSmearedNoReg_2012Jul13ReReco"
        self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PhiCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e2PhiCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e2PhiCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2PhiCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2PhiCorrSmearedNoReg_Fall11"
        self.e2PhiCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2PhiCorrSmearedNoReg_Fall11")
        #if not self.e2PhiCorrSmearedNoReg_Fall11_branch and "e2PhiCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2PhiCorrSmearedNoReg_Fall11_branch and "e2PhiCorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2PhiCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedNoReg_Fall11")
        else:
            self.e2PhiCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2PhiCorrSmearedNoReg_Fall11_value)

        #print "making e2PhiCorrSmearedNoReg_Jan16ReReco"
        self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2PhiCorrSmearedNoReg_Jan16ReReco")
        #if not self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch and "e2PhiCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch and "e2PhiCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2PhiCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PhiCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2PhiCorrSmearedReg_2012Jul13ReReco"
        self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PhiCorrSmearedReg_2012Jul13ReReco")
        #if not self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch and "e2PhiCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch and "e2PhiCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2PhiCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PhiCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2PhiCorrSmearedReg_Fall11"
        self.e2PhiCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2PhiCorrSmearedReg_Fall11")
        #if not self.e2PhiCorrSmearedReg_Fall11_branch and "e2PhiCorrSmearedReg_Fall11" not in self.complained:
        if not self.e2PhiCorrSmearedReg_Fall11_branch and "e2PhiCorrSmearedReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2PhiCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedReg_Fall11")
        else:
            self.e2PhiCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2PhiCorrSmearedReg_Fall11_value)

        #print "making e2PhiCorrSmearedReg_Jan16ReReco"
        self.e2PhiCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2PhiCorrSmearedReg_Jan16ReReco")
        #if not self.e2PhiCorrSmearedReg_Jan16ReReco_branch and "e2PhiCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2PhiCorrSmearedReg_Jan16ReReco_branch and "e2PhiCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2PhiCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedReg_Jan16ReReco")
        else:
            self.e2PhiCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PhiCorrSmearedReg_Jan16ReReco_value)

        #print "making e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2Pt"
        self.e2Pt_branch = the_tree.GetBranch("e2Pt")
        #if not self.e2Pt_branch and "e2Pt" not in self.complained:
        if not self.e2Pt_branch and "e2Pt":
            warnings.warn( "EETauTree: Expected branch e2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt")
        else:
            self.e2Pt_branch.SetAddress(<void*>&self.e2Pt_value)

        #print "making e2PtCorrReg_2012Jul13ReReco"
        self.e2PtCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PtCorrReg_2012Jul13ReReco")
        #if not self.e2PtCorrReg_2012Jul13ReReco_branch and "e2PtCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PtCorrReg_2012Jul13ReReco_branch and "e2PtCorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2PtCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrReg_2012Jul13ReReco")
        else:
            self.e2PtCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PtCorrReg_2012Jul13ReReco_value)

        #print "making e2PtCorrReg_Fall11"
        self.e2PtCorrReg_Fall11_branch = the_tree.GetBranch("e2PtCorrReg_Fall11")
        #if not self.e2PtCorrReg_Fall11_branch and "e2PtCorrReg_Fall11" not in self.complained:
        if not self.e2PtCorrReg_Fall11_branch and "e2PtCorrReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2PtCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrReg_Fall11")
        else:
            self.e2PtCorrReg_Fall11_branch.SetAddress(<void*>&self.e2PtCorrReg_Fall11_value)

        #print "making e2PtCorrReg_Jan16ReReco"
        self.e2PtCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2PtCorrReg_Jan16ReReco")
        #if not self.e2PtCorrReg_Jan16ReReco_branch and "e2PtCorrReg_Jan16ReReco" not in self.complained:
        if not self.e2PtCorrReg_Jan16ReReco_branch and "e2PtCorrReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2PtCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrReg_Jan16ReReco")
        else:
            self.e2PtCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PtCorrReg_Jan16ReReco_value)

        #print "making e2PtCorrReg_Summer12_DR53X_HCP2012"
        self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PtCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2PtCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PtCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2PtCorrSmearedNoReg_2012Jul13ReReco"
        self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PtCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e2PtCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e2PtCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2PtCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PtCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2PtCorrSmearedNoReg_Fall11"
        self.e2PtCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2PtCorrSmearedNoReg_Fall11")
        #if not self.e2PtCorrSmearedNoReg_Fall11_branch and "e2PtCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2PtCorrSmearedNoReg_Fall11_branch and "e2PtCorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2PtCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedNoReg_Fall11")
        else:
            self.e2PtCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2PtCorrSmearedNoReg_Fall11_value)

        #print "making e2PtCorrSmearedNoReg_Jan16ReReco"
        self.e2PtCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2PtCorrSmearedNoReg_Jan16ReReco")
        #if not self.e2PtCorrSmearedNoReg_Jan16ReReco_branch and "e2PtCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2PtCorrSmearedNoReg_Jan16ReReco_branch and "e2PtCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2PtCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2PtCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PtCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2PtCorrSmearedReg_2012Jul13ReReco"
        self.e2PtCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PtCorrSmearedReg_2012Jul13ReReco")
        #if not self.e2PtCorrSmearedReg_2012Jul13ReReco_branch and "e2PtCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PtCorrSmearedReg_2012Jul13ReReco_branch and "e2PtCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2PtCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2PtCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PtCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2PtCorrSmearedReg_Fall11"
        self.e2PtCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2PtCorrSmearedReg_Fall11")
        #if not self.e2PtCorrSmearedReg_Fall11_branch and "e2PtCorrSmearedReg_Fall11" not in self.complained:
        if not self.e2PtCorrSmearedReg_Fall11_branch and "e2PtCorrSmearedReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2PtCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedReg_Fall11")
        else:
            self.e2PtCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2PtCorrSmearedReg_Fall11_value)

        #print "making e2PtCorrSmearedReg_Jan16ReReco"
        self.e2PtCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2PtCorrSmearedReg_Jan16ReReco")
        #if not self.e2PtCorrSmearedReg_Jan16ReReco_branch and "e2PtCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2PtCorrSmearedReg_Jan16ReReco_branch and "e2PtCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2PtCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedReg_Jan16ReReco")
        else:
            self.e2PtCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PtCorrSmearedReg_Jan16ReReco_value)

        #print "making e2PtCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2PtCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2Pt_ees_minus"
        self.e2Pt_ees_minus_branch = the_tree.GetBranch("e2Pt_ees_minus")
        #if not self.e2Pt_ees_minus_branch and "e2Pt_ees_minus" not in self.complained:
        if not self.e2Pt_ees_minus_branch and "e2Pt_ees_minus":
            warnings.warn( "EETauTree: Expected branch e2Pt_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt_ees_minus")
        else:
            self.e2Pt_ees_minus_branch.SetAddress(<void*>&self.e2Pt_ees_minus_value)

        #print "making e2Pt_ees_plus"
        self.e2Pt_ees_plus_branch = the_tree.GetBranch("e2Pt_ees_plus")
        #if not self.e2Pt_ees_plus_branch and "e2Pt_ees_plus" not in self.complained:
        if not self.e2Pt_ees_plus_branch and "e2Pt_ees_plus":
            warnings.warn( "EETauTree: Expected branch e2Pt_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt_ees_plus")
        else:
            self.e2Pt_ees_plus_branch.SetAddress(<void*>&self.e2Pt_ees_plus_value)

        #print "making e2Pt_tes_minus"
        self.e2Pt_tes_minus_branch = the_tree.GetBranch("e2Pt_tes_minus")
        #if not self.e2Pt_tes_minus_branch and "e2Pt_tes_minus" not in self.complained:
        if not self.e2Pt_tes_minus_branch and "e2Pt_tes_minus":
            warnings.warn( "EETauTree: Expected branch e2Pt_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt_tes_minus")
        else:
            self.e2Pt_tes_minus_branch.SetAddress(<void*>&self.e2Pt_tes_minus_value)

        #print "making e2Pt_tes_plus"
        self.e2Pt_tes_plus_branch = the_tree.GetBranch("e2Pt_tes_plus")
        #if not self.e2Pt_tes_plus_branch and "e2Pt_tes_plus" not in self.complained:
        if not self.e2Pt_tes_plus_branch and "e2Pt_tes_plus":
            warnings.warn( "EETauTree: Expected branch e2Pt_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt_tes_plus")
        else:
            self.e2Pt_tes_plus_branch.SetAddress(<void*>&self.e2Pt_tes_plus_value)

        #print "making e2Rank"
        self.e2Rank_branch = the_tree.GetBranch("e2Rank")
        #if not self.e2Rank_branch and "e2Rank" not in self.complained:
        if not self.e2Rank_branch and "e2Rank":
            warnings.warn( "EETauTree: Expected branch e2Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Rank")
        else:
            self.e2Rank_branch.SetAddress(<void*>&self.e2Rank_value)

        #print "making e2RelIso"
        self.e2RelIso_branch = the_tree.GetBranch("e2RelIso")
        #if not self.e2RelIso_branch and "e2RelIso" not in self.complained:
        if not self.e2RelIso_branch and "e2RelIso":
            warnings.warn( "EETauTree: Expected branch e2RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelIso")
        else:
            self.e2RelIso_branch.SetAddress(<void*>&self.e2RelIso_value)

        #print "making e2RelPFIsoDB"
        self.e2RelPFIsoDB_branch = the_tree.GetBranch("e2RelPFIsoDB")
        #if not self.e2RelPFIsoDB_branch and "e2RelPFIsoDB" not in self.complained:
        if not self.e2RelPFIsoDB_branch and "e2RelPFIsoDB":
            warnings.warn( "EETauTree: Expected branch e2RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoDB")
        else:
            self.e2RelPFIsoDB_branch.SetAddress(<void*>&self.e2RelPFIsoDB_value)

        #print "making e2RelPFIsoRho"
        self.e2RelPFIsoRho_branch = the_tree.GetBranch("e2RelPFIsoRho")
        #if not self.e2RelPFIsoRho_branch and "e2RelPFIsoRho" not in self.complained:
        if not self.e2RelPFIsoRho_branch and "e2RelPFIsoRho":
            warnings.warn( "EETauTree: Expected branch e2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoRho")
        else:
            self.e2RelPFIsoRho_branch.SetAddress(<void*>&self.e2RelPFIsoRho_value)

        #print "making e2RelPFIsoRhoFSR"
        self.e2RelPFIsoRhoFSR_branch = the_tree.GetBranch("e2RelPFIsoRhoFSR")
        #if not self.e2RelPFIsoRhoFSR_branch and "e2RelPFIsoRhoFSR" not in self.complained:
        if not self.e2RelPFIsoRhoFSR_branch and "e2RelPFIsoRhoFSR":
            warnings.warn( "EETauTree: Expected branch e2RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoRhoFSR")
        else:
            self.e2RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.e2RelPFIsoRhoFSR_value)

        #print "making e2RhoHZG2011"
        self.e2RhoHZG2011_branch = the_tree.GetBranch("e2RhoHZG2011")
        #if not self.e2RhoHZG2011_branch and "e2RhoHZG2011" not in self.complained:
        if not self.e2RhoHZG2011_branch and "e2RhoHZG2011":
            warnings.warn( "EETauTree: Expected branch e2RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RhoHZG2011")
        else:
            self.e2RhoHZG2011_branch.SetAddress(<void*>&self.e2RhoHZG2011_value)

        #print "making e2RhoHZG2012"
        self.e2RhoHZG2012_branch = the_tree.GetBranch("e2RhoHZG2012")
        #if not self.e2RhoHZG2012_branch and "e2RhoHZG2012" not in self.complained:
        if not self.e2RhoHZG2012_branch and "e2RhoHZG2012":
            warnings.warn( "EETauTree: Expected branch e2RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RhoHZG2012")
        else:
            self.e2RhoHZG2012_branch.SetAddress(<void*>&self.e2RhoHZG2012_value)

        #print "making e2SCEnergy"
        self.e2SCEnergy_branch = the_tree.GetBranch("e2SCEnergy")
        #if not self.e2SCEnergy_branch and "e2SCEnergy" not in self.complained:
        if not self.e2SCEnergy_branch and "e2SCEnergy":
            warnings.warn( "EETauTree: Expected branch e2SCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCEnergy")
        else:
            self.e2SCEnergy_branch.SetAddress(<void*>&self.e2SCEnergy_value)

        #print "making e2SCEta"
        self.e2SCEta_branch = the_tree.GetBranch("e2SCEta")
        #if not self.e2SCEta_branch and "e2SCEta" not in self.complained:
        if not self.e2SCEta_branch and "e2SCEta":
            warnings.warn( "EETauTree: Expected branch e2SCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCEta")
        else:
            self.e2SCEta_branch.SetAddress(<void*>&self.e2SCEta_value)

        #print "making e2SCEtaWidth"
        self.e2SCEtaWidth_branch = the_tree.GetBranch("e2SCEtaWidth")
        #if not self.e2SCEtaWidth_branch and "e2SCEtaWidth" not in self.complained:
        if not self.e2SCEtaWidth_branch and "e2SCEtaWidth":
            warnings.warn( "EETauTree: Expected branch e2SCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCEtaWidth")
        else:
            self.e2SCEtaWidth_branch.SetAddress(<void*>&self.e2SCEtaWidth_value)

        #print "making e2SCPhi"
        self.e2SCPhi_branch = the_tree.GetBranch("e2SCPhi")
        #if not self.e2SCPhi_branch and "e2SCPhi" not in self.complained:
        if not self.e2SCPhi_branch and "e2SCPhi":
            warnings.warn( "EETauTree: Expected branch e2SCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCPhi")
        else:
            self.e2SCPhi_branch.SetAddress(<void*>&self.e2SCPhi_value)

        #print "making e2SCPhiWidth"
        self.e2SCPhiWidth_branch = the_tree.GetBranch("e2SCPhiWidth")
        #if not self.e2SCPhiWidth_branch and "e2SCPhiWidth" not in self.complained:
        if not self.e2SCPhiWidth_branch and "e2SCPhiWidth":
            warnings.warn( "EETauTree: Expected branch e2SCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCPhiWidth")
        else:
            self.e2SCPhiWidth_branch.SetAddress(<void*>&self.e2SCPhiWidth_value)

        #print "making e2SCPreshowerEnergy"
        self.e2SCPreshowerEnergy_branch = the_tree.GetBranch("e2SCPreshowerEnergy")
        #if not self.e2SCPreshowerEnergy_branch and "e2SCPreshowerEnergy" not in self.complained:
        if not self.e2SCPreshowerEnergy_branch and "e2SCPreshowerEnergy":
            warnings.warn( "EETauTree: Expected branch e2SCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCPreshowerEnergy")
        else:
            self.e2SCPreshowerEnergy_branch.SetAddress(<void*>&self.e2SCPreshowerEnergy_value)

        #print "making e2SCRawEnergy"
        self.e2SCRawEnergy_branch = the_tree.GetBranch("e2SCRawEnergy")
        #if not self.e2SCRawEnergy_branch and "e2SCRawEnergy" not in self.complained:
        if not self.e2SCRawEnergy_branch and "e2SCRawEnergy":
            warnings.warn( "EETauTree: Expected branch e2SCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCRawEnergy")
        else:
            self.e2SCRawEnergy_branch.SetAddress(<void*>&self.e2SCRawEnergy_value)

        #print "making e2SigmaIEtaIEta"
        self.e2SigmaIEtaIEta_branch = the_tree.GetBranch("e2SigmaIEtaIEta")
        #if not self.e2SigmaIEtaIEta_branch and "e2SigmaIEtaIEta" not in self.complained:
        if not self.e2SigmaIEtaIEta_branch and "e2SigmaIEtaIEta":
            warnings.warn( "EETauTree: Expected branch e2SigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SigmaIEtaIEta")
        else:
            self.e2SigmaIEtaIEta_branch.SetAddress(<void*>&self.e2SigmaIEtaIEta_value)

        #print "making e2ToMETDPhi"
        self.e2ToMETDPhi_branch = the_tree.GetBranch("e2ToMETDPhi")
        #if not self.e2ToMETDPhi_branch and "e2ToMETDPhi" not in self.complained:
        if not self.e2ToMETDPhi_branch and "e2ToMETDPhi":
            warnings.warn( "EETauTree: Expected branch e2ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ToMETDPhi")
        else:
            self.e2ToMETDPhi_branch.SetAddress(<void*>&self.e2ToMETDPhi_value)

        #print "making e2TrkIsoDR03"
        self.e2TrkIsoDR03_branch = the_tree.GetBranch("e2TrkIsoDR03")
        #if not self.e2TrkIsoDR03_branch and "e2TrkIsoDR03" not in self.complained:
        if not self.e2TrkIsoDR03_branch and "e2TrkIsoDR03":
            warnings.warn( "EETauTree: Expected branch e2TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2TrkIsoDR03")
        else:
            self.e2TrkIsoDR03_branch.SetAddress(<void*>&self.e2TrkIsoDR03_value)

        #print "making e2VZ"
        self.e2VZ_branch = the_tree.GetBranch("e2VZ")
        #if not self.e2VZ_branch and "e2VZ" not in self.complained:
        if not self.e2VZ_branch and "e2VZ":
            warnings.warn( "EETauTree: Expected branch e2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2VZ")
        else:
            self.e2VZ_branch.SetAddress(<void*>&self.e2VZ_value)

        #print "making e2WWID"
        self.e2WWID_branch = the_tree.GetBranch("e2WWID")
        #if not self.e2WWID_branch and "e2WWID" not in self.complained:
        if not self.e2WWID_branch and "e2WWID":
            warnings.warn( "EETauTree: Expected branch e2WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2WWID")
        else:
            self.e2WWID_branch.SetAddress(<void*>&self.e2WWID_value)

        #print "making e2_t_CosThetaStar"
        self.e2_t_CosThetaStar_branch = the_tree.GetBranch("e2_t_CosThetaStar")
        #if not self.e2_t_CosThetaStar_branch and "e2_t_CosThetaStar" not in self.complained:
        if not self.e2_t_CosThetaStar_branch and "e2_t_CosThetaStar":
            warnings.warn( "EETauTree: Expected branch e2_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_CosThetaStar")
        else:
            self.e2_t_CosThetaStar_branch.SetAddress(<void*>&self.e2_t_CosThetaStar_value)

        #print "making e2_t_DPhi"
        self.e2_t_DPhi_branch = the_tree.GetBranch("e2_t_DPhi")
        #if not self.e2_t_DPhi_branch and "e2_t_DPhi" not in self.complained:
        if not self.e2_t_DPhi_branch and "e2_t_DPhi":
            warnings.warn( "EETauTree: Expected branch e2_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_DPhi")
        else:
            self.e2_t_DPhi_branch.SetAddress(<void*>&self.e2_t_DPhi_value)

        #print "making e2_t_DR"
        self.e2_t_DR_branch = the_tree.GetBranch("e2_t_DR")
        #if not self.e2_t_DR_branch and "e2_t_DR" not in self.complained:
        if not self.e2_t_DR_branch and "e2_t_DR":
            warnings.warn( "EETauTree: Expected branch e2_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_DR")
        else:
            self.e2_t_DR_branch.SetAddress(<void*>&self.e2_t_DR_value)

        #print "making e2_t_Mass"
        self.e2_t_Mass_branch = the_tree.GetBranch("e2_t_Mass")
        #if not self.e2_t_Mass_branch and "e2_t_Mass" not in self.complained:
        if not self.e2_t_Mass_branch and "e2_t_Mass":
            warnings.warn( "EETauTree: Expected branch e2_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mass")
        else:
            self.e2_t_Mass_branch.SetAddress(<void*>&self.e2_t_Mass_value)

        #print "making e2_t_MassFsr"
        self.e2_t_MassFsr_branch = the_tree.GetBranch("e2_t_MassFsr")
        #if not self.e2_t_MassFsr_branch and "e2_t_MassFsr" not in self.complained:
        if not self.e2_t_MassFsr_branch and "e2_t_MassFsr":
            warnings.warn( "EETauTree: Expected branch e2_t_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_MassFsr")
        else:
            self.e2_t_MassFsr_branch.SetAddress(<void*>&self.e2_t_MassFsr_value)

        #print "making e2_t_Mass_ees_minus"
        self.e2_t_Mass_ees_minus_branch = the_tree.GetBranch("e2_t_Mass_ees_minus")
        #if not self.e2_t_Mass_ees_minus_branch and "e2_t_Mass_ees_minus" not in self.complained:
        if not self.e2_t_Mass_ees_minus_branch and "e2_t_Mass_ees_minus":
            warnings.warn( "EETauTree: Expected branch e2_t_Mass_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mass_ees_minus")
        else:
            self.e2_t_Mass_ees_minus_branch.SetAddress(<void*>&self.e2_t_Mass_ees_minus_value)

        #print "making e2_t_Mass_ees_plus"
        self.e2_t_Mass_ees_plus_branch = the_tree.GetBranch("e2_t_Mass_ees_plus")
        #if not self.e2_t_Mass_ees_plus_branch and "e2_t_Mass_ees_plus" not in self.complained:
        if not self.e2_t_Mass_ees_plus_branch and "e2_t_Mass_ees_plus":
            warnings.warn( "EETauTree: Expected branch e2_t_Mass_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mass_ees_plus")
        else:
            self.e2_t_Mass_ees_plus_branch.SetAddress(<void*>&self.e2_t_Mass_ees_plus_value)

        #print "making e2_t_Mass_tes_minus"
        self.e2_t_Mass_tes_minus_branch = the_tree.GetBranch("e2_t_Mass_tes_minus")
        #if not self.e2_t_Mass_tes_minus_branch and "e2_t_Mass_tes_minus" not in self.complained:
        if not self.e2_t_Mass_tes_minus_branch and "e2_t_Mass_tes_minus":
            warnings.warn( "EETauTree: Expected branch e2_t_Mass_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mass_tes_minus")
        else:
            self.e2_t_Mass_tes_minus_branch.SetAddress(<void*>&self.e2_t_Mass_tes_minus_value)

        #print "making e2_t_Mass_tes_plus"
        self.e2_t_Mass_tes_plus_branch = the_tree.GetBranch("e2_t_Mass_tes_plus")
        #if not self.e2_t_Mass_tes_plus_branch and "e2_t_Mass_tes_plus" not in self.complained:
        if not self.e2_t_Mass_tes_plus_branch and "e2_t_Mass_tes_plus":
            warnings.warn( "EETauTree: Expected branch e2_t_Mass_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mass_tes_plus")
        else:
            self.e2_t_Mass_tes_plus_branch.SetAddress(<void*>&self.e2_t_Mass_tes_plus_value)

        #print "making e2_t_PZeta"
        self.e2_t_PZeta_branch = the_tree.GetBranch("e2_t_PZeta")
        #if not self.e2_t_PZeta_branch and "e2_t_PZeta" not in self.complained:
        if not self.e2_t_PZeta_branch and "e2_t_PZeta":
            warnings.warn( "EETauTree: Expected branch e2_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_PZeta")
        else:
            self.e2_t_PZeta_branch.SetAddress(<void*>&self.e2_t_PZeta_value)

        #print "making e2_t_PZetaVis"
        self.e2_t_PZetaVis_branch = the_tree.GetBranch("e2_t_PZetaVis")
        #if not self.e2_t_PZetaVis_branch and "e2_t_PZetaVis" not in self.complained:
        if not self.e2_t_PZetaVis_branch and "e2_t_PZetaVis":
            warnings.warn( "EETauTree: Expected branch e2_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_PZetaVis")
        else:
            self.e2_t_PZetaVis_branch.SetAddress(<void*>&self.e2_t_PZetaVis_value)

        #print "making e2_t_Pt"
        self.e2_t_Pt_branch = the_tree.GetBranch("e2_t_Pt")
        #if not self.e2_t_Pt_branch and "e2_t_Pt" not in self.complained:
        if not self.e2_t_Pt_branch and "e2_t_Pt":
            warnings.warn( "EETauTree: Expected branch e2_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Pt")
        else:
            self.e2_t_Pt_branch.SetAddress(<void*>&self.e2_t_Pt_value)

        #print "making e2_t_PtFsr"
        self.e2_t_PtFsr_branch = the_tree.GetBranch("e2_t_PtFsr")
        #if not self.e2_t_PtFsr_branch and "e2_t_PtFsr" not in self.complained:
        if not self.e2_t_PtFsr_branch and "e2_t_PtFsr":
            warnings.warn( "EETauTree: Expected branch e2_t_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_PtFsr")
        else:
            self.e2_t_PtFsr_branch.SetAddress(<void*>&self.e2_t_PtFsr_value)

        #print "making e2_t_SS"
        self.e2_t_SS_branch = the_tree.GetBranch("e2_t_SS")
        #if not self.e2_t_SS_branch and "e2_t_SS" not in self.complained:
        if not self.e2_t_SS_branch and "e2_t_SS":
            warnings.warn( "EETauTree: Expected branch e2_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_SS")
        else:
            self.e2_t_SS_branch.SetAddress(<void*>&self.e2_t_SS_value)

        #print "making e2_t_ToMETDPhi_Ty1"
        self.e2_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e2_t_ToMETDPhi_Ty1")
        #if not self.e2_t_ToMETDPhi_Ty1_branch and "e2_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.e2_t_ToMETDPhi_Ty1_branch and "e2_t_ToMETDPhi_Ty1":
            warnings.warn( "EETauTree: Expected branch e2_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_ToMETDPhi_Ty1")
        else:
            self.e2_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e2_t_ToMETDPhi_Ty1_value)

        #print "making e2_t_ToMETDPhi_jes_minus"
        self.e2_t_ToMETDPhi_jes_minus_branch = the_tree.GetBranch("e2_t_ToMETDPhi_jes_minus")
        #if not self.e2_t_ToMETDPhi_jes_minus_branch and "e2_t_ToMETDPhi_jes_minus" not in self.complained:
        if not self.e2_t_ToMETDPhi_jes_minus_branch and "e2_t_ToMETDPhi_jes_minus":
            warnings.warn( "EETauTree: Expected branch e2_t_ToMETDPhi_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_ToMETDPhi_jes_minus")
        else:
            self.e2_t_ToMETDPhi_jes_minus_branch.SetAddress(<void*>&self.e2_t_ToMETDPhi_jes_minus_value)

        #print "making e2_t_ToMETDPhi_jes_plus"
        self.e2_t_ToMETDPhi_jes_plus_branch = the_tree.GetBranch("e2_t_ToMETDPhi_jes_plus")
        #if not self.e2_t_ToMETDPhi_jes_plus_branch and "e2_t_ToMETDPhi_jes_plus" not in self.complained:
        if not self.e2_t_ToMETDPhi_jes_plus_branch and "e2_t_ToMETDPhi_jes_plus":
            warnings.warn( "EETauTree: Expected branch e2_t_ToMETDPhi_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_ToMETDPhi_jes_plus")
        else:
            self.e2_t_ToMETDPhi_jes_plus_branch.SetAddress(<void*>&self.e2_t_ToMETDPhi_jes_plus_value)

        #print "making e2_t_Zcompat"
        self.e2_t_Zcompat_branch = the_tree.GetBranch("e2_t_Zcompat")
        #if not self.e2_t_Zcompat_branch and "e2_t_Zcompat" not in self.complained:
        if not self.e2_t_Zcompat_branch and "e2_t_Zcompat":
            warnings.warn( "EETauTree: Expected branch e2_t_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Zcompat")
        else:
            self.e2_t_Zcompat_branch.SetAddress(<void*>&self.e2_t_Zcompat_value)

        #print "making e2dECorrReg_2012Jul13ReReco"
        self.e2dECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2dECorrReg_2012Jul13ReReco")
        #if not self.e2dECorrReg_2012Jul13ReReco_branch and "e2dECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2dECorrReg_2012Jul13ReReco_branch and "e2dECorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2dECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrReg_2012Jul13ReReco")
        else:
            self.e2dECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2dECorrReg_2012Jul13ReReco_value)

        #print "making e2dECorrReg_Fall11"
        self.e2dECorrReg_Fall11_branch = the_tree.GetBranch("e2dECorrReg_Fall11")
        #if not self.e2dECorrReg_Fall11_branch and "e2dECorrReg_Fall11" not in self.complained:
        if not self.e2dECorrReg_Fall11_branch and "e2dECorrReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2dECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrReg_Fall11")
        else:
            self.e2dECorrReg_Fall11_branch.SetAddress(<void*>&self.e2dECorrReg_Fall11_value)

        #print "making e2dECorrReg_Jan16ReReco"
        self.e2dECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2dECorrReg_Jan16ReReco")
        #if not self.e2dECorrReg_Jan16ReReco_branch and "e2dECorrReg_Jan16ReReco" not in self.complained:
        if not self.e2dECorrReg_Jan16ReReco_branch and "e2dECorrReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2dECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrReg_Jan16ReReco")
        else:
            self.e2dECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2dECorrReg_Jan16ReReco_value)

        #print "making e2dECorrReg_Summer12_DR53X_HCP2012"
        self.e2dECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2dECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2dECorrReg_Summer12_DR53X_HCP2012_branch and "e2dECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2dECorrReg_Summer12_DR53X_HCP2012_branch and "e2dECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2dECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2dECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2dECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2dECorrSmearedNoReg_2012Jul13ReReco"
        self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2dECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch and "e2dECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch and "e2dECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2dECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2dECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2dECorrSmearedNoReg_Fall11"
        self.e2dECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2dECorrSmearedNoReg_Fall11")
        #if not self.e2dECorrSmearedNoReg_Fall11_branch and "e2dECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2dECorrSmearedNoReg_Fall11_branch and "e2dECorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2dECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedNoReg_Fall11")
        else:
            self.e2dECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2dECorrSmearedNoReg_Fall11_value)

        #print "making e2dECorrSmearedNoReg_Jan16ReReco"
        self.e2dECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2dECorrSmearedNoReg_Jan16ReReco")
        #if not self.e2dECorrSmearedNoReg_Jan16ReReco_branch and "e2dECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2dECorrSmearedNoReg_Jan16ReReco_branch and "e2dECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2dECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2dECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2dECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2dECorrSmearedReg_2012Jul13ReReco"
        self.e2dECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2dECorrSmearedReg_2012Jul13ReReco")
        #if not self.e2dECorrSmearedReg_2012Jul13ReReco_branch and "e2dECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2dECorrSmearedReg_2012Jul13ReReco_branch and "e2dECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTree: Expected branch e2dECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2dECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2dECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2dECorrSmearedReg_Fall11"
        self.e2dECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2dECorrSmearedReg_Fall11")
        #if not self.e2dECorrSmearedReg_Fall11_branch and "e2dECorrSmearedReg_Fall11" not in self.complained:
        if not self.e2dECorrSmearedReg_Fall11_branch and "e2dECorrSmearedReg_Fall11":
            warnings.warn( "EETauTree: Expected branch e2dECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedReg_Fall11")
        else:
            self.e2dECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2dECorrSmearedReg_Fall11_value)

        #print "making e2dECorrSmearedReg_Jan16ReReco"
        self.e2dECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2dECorrSmearedReg_Jan16ReReco")
        #if not self.e2dECorrSmearedReg_Jan16ReReco_branch and "e2dECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2dECorrSmearedReg_Jan16ReReco_branch and "e2dECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTree: Expected branch e2dECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedReg_Jan16ReReco")
        else:
            self.e2dECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2dECorrSmearedReg_Jan16ReReco_value)

        #print "making e2dECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2dECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2dECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2dECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTree: Expected branch e2dECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2deltaEtaSuperClusterTrackAtVtx"
        self.e2deltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e2deltaEtaSuperClusterTrackAtVtx")
        #if not self.e2deltaEtaSuperClusterTrackAtVtx_branch and "e2deltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.e2deltaEtaSuperClusterTrackAtVtx_branch and "e2deltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "EETauTree: Expected branch e2deltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2deltaEtaSuperClusterTrackAtVtx")
        else:
            self.e2deltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e2deltaEtaSuperClusterTrackAtVtx_value)

        #print "making e2deltaPhiSuperClusterTrackAtVtx"
        self.e2deltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e2deltaPhiSuperClusterTrackAtVtx")
        #if not self.e2deltaPhiSuperClusterTrackAtVtx_branch and "e2deltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.e2deltaPhiSuperClusterTrackAtVtx_branch and "e2deltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "EETauTree: Expected branch e2deltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2deltaPhiSuperClusterTrackAtVtx")
        else:
            self.e2deltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e2deltaPhiSuperClusterTrackAtVtx_value)

        #print "making e2eSuperClusterOverP"
        self.e2eSuperClusterOverP_branch = the_tree.GetBranch("e2eSuperClusterOverP")
        #if not self.e2eSuperClusterOverP_branch and "e2eSuperClusterOverP" not in self.complained:
        if not self.e2eSuperClusterOverP_branch and "e2eSuperClusterOverP":
            warnings.warn( "EETauTree: Expected branch e2eSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2eSuperClusterOverP")
        else:
            self.e2eSuperClusterOverP_branch.SetAddress(<void*>&self.e2eSuperClusterOverP_value)

        #print "making e2ecalEnergy"
        self.e2ecalEnergy_branch = the_tree.GetBranch("e2ecalEnergy")
        #if not self.e2ecalEnergy_branch and "e2ecalEnergy" not in self.complained:
        if not self.e2ecalEnergy_branch and "e2ecalEnergy":
            warnings.warn( "EETauTree: Expected branch e2ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ecalEnergy")
        else:
            self.e2ecalEnergy_branch.SetAddress(<void*>&self.e2ecalEnergy_value)

        #print "making e2fBrem"
        self.e2fBrem_branch = the_tree.GetBranch("e2fBrem")
        #if not self.e2fBrem_branch and "e2fBrem" not in self.complained:
        if not self.e2fBrem_branch and "e2fBrem":
            warnings.warn( "EETauTree: Expected branch e2fBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2fBrem")
        else:
            self.e2fBrem_branch.SetAddress(<void*>&self.e2fBrem_value)

        #print "making e2trackMomentumAtVtxP"
        self.e2trackMomentumAtVtxP_branch = the_tree.GetBranch("e2trackMomentumAtVtxP")
        #if not self.e2trackMomentumAtVtxP_branch and "e2trackMomentumAtVtxP" not in self.complained:
        if not self.e2trackMomentumAtVtxP_branch and "e2trackMomentumAtVtxP":
            warnings.warn( "EETauTree: Expected branch e2trackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2trackMomentumAtVtxP")
        else:
            self.e2trackMomentumAtVtxP_branch.SetAddress(<void*>&self.e2trackMomentumAtVtxP_value)

        #print "making eVetoCicLooseIso"
        self.eVetoCicLooseIso_branch = the_tree.GetBranch("eVetoCicLooseIso")
        #if not self.eVetoCicLooseIso_branch and "eVetoCicLooseIso" not in self.complained:
        if not self.eVetoCicLooseIso_branch and "eVetoCicLooseIso":
            warnings.warn( "EETauTree: Expected branch eVetoCicLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicLooseIso")
        else:
            self.eVetoCicLooseIso_branch.SetAddress(<void*>&self.eVetoCicLooseIso_value)

        #print "making eVetoCicLooseIso_ees_minus"
        self.eVetoCicLooseIso_ees_minus_branch = the_tree.GetBranch("eVetoCicLooseIso_ees_minus")
        #if not self.eVetoCicLooseIso_ees_minus_branch and "eVetoCicLooseIso_ees_minus" not in self.complained:
        if not self.eVetoCicLooseIso_ees_minus_branch and "eVetoCicLooseIso_ees_minus":
            warnings.warn( "EETauTree: Expected branch eVetoCicLooseIso_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicLooseIso_ees_minus")
        else:
            self.eVetoCicLooseIso_ees_minus_branch.SetAddress(<void*>&self.eVetoCicLooseIso_ees_minus_value)

        #print "making eVetoCicLooseIso_ees_plus"
        self.eVetoCicLooseIso_ees_plus_branch = the_tree.GetBranch("eVetoCicLooseIso_ees_plus")
        #if not self.eVetoCicLooseIso_ees_plus_branch and "eVetoCicLooseIso_ees_plus" not in self.complained:
        if not self.eVetoCicLooseIso_ees_plus_branch and "eVetoCicLooseIso_ees_plus":
            warnings.warn( "EETauTree: Expected branch eVetoCicLooseIso_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicLooseIso_ees_plus")
        else:
            self.eVetoCicLooseIso_ees_plus_branch.SetAddress(<void*>&self.eVetoCicLooseIso_ees_plus_value)

        #print "making eVetoCicTightIso"
        self.eVetoCicTightIso_branch = the_tree.GetBranch("eVetoCicTightIso")
        #if not self.eVetoCicTightIso_branch and "eVetoCicTightIso" not in self.complained:
        if not self.eVetoCicTightIso_branch and "eVetoCicTightIso":
            warnings.warn( "EETauTree: Expected branch eVetoCicTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso")
        else:
            self.eVetoCicTightIso_branch.SetAddress(<void*>&self.eVetoCicTightIso_value)

        #print "making eVetoCicTightIso_ees_minus"
        self.eVetoCicTightIso_ees_minus_branch = the_tree.GetBranch("eVetoCicTightIso_ees_minus")
        #if not self.eVetoCicTightIso_ees_minus_branch and "eVetoCicTightIso_ees_minus" not in self.complained:
        if not self.eVetoCicTightIso_ees_minus_branch and "eVetoCicTightIso_ees_minus":
            warnings.warn( "EETauTree: Expected branch eVetoCicTightIso_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso_ees_minus")
        else:
            self.eVetoCicTightIso_ees_minus_branch.SetAddress(<void*>&self.eVetoCicTightIso_ees_minus_value)

        #print "making eVetoCicTightIso_ees_plus"
        self.eVetoCicTightIso_ees_plus_branch = the_tree.GetBranch("eVetoCicTightIso_ees_plus")
        #if not self.eVetoCicTightIso_ees_plus_branch and "eVetoCicTightIso_ees_plus" not in self.complained:
        if not self.eVetoCicTightIso_ees_plus_branch and "eVetoCicTightIso_ees_plus":
            warnings.warn( "EETauTree: Expected branch eVetoCicTightIso_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso_ees_plus")
        else:
            self.eVetoCicTightIso_ees_plus_branch.SetAddress(<void*>&self.eVetoCicTightIso_ees_plus_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "EETauTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "EETauTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "EETauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "EETauTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "EETauTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "EETauTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "EETauTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "EETauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isoMu24eta2p1Group"
        self.isoMu24eta2p1Group_branch = the_tree.GetBranch("isoMu24eta2p1Group")
        #if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group" not in self.complained:
        if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group":
            warnings.warn( "EETauTree: Expected branch isoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Group")
        else:
            self.isoMu24eta2p1Group_branch.SetAddress(<void*>&self.isoMu24eta2p1Group_value)

        #print "making isoMu24eta2p1Pass"
        self.isoMu24eta2p1Pass_branch = the_tree.GetBranch("isoMu24eta2p1Pass")
        #if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass" not in self.complained:
        if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass":
            warnings.warn( "EETauTree: Expected branch isoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Pass")
        else:
            self.isoMu24eta2p1Pass_branch.SetAddress(<void*>&self.isoMu24eta2p1Pass_value)

        #print "making isoMu24eta2p1Prescale"
        self.isoMu24eta2p1Prescale_branch = the_tree.GetBranch("isoMu24eta2p1Prescale")
        #if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale" not in self.complained:
        if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale":
            warnings.warn( "EETauTree: Expected branch isoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Prescale")
        else:
            self.isoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.isoMu24eta2p1Prescale_value)

        #print "making isoMuGroup"
        self.isoMuGroup_branch = the_tree.GetBranch("isoMuGroup")
        #if not self.isoMuGroup_branch and "isoMuGroup" not in self.complained:
        if not self.isoMuGroup_branch and "isoMuGroup":
            warnings.warn( "EETauTree: Expected branch isoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuGroup")
        else:
            self.isoMuGroup_branch.SetAddress(<void*>&self.isoMuGroup_value)

        #print "making isoMuPass"
        self.isoMuPass_branch = the_tree.GetBranch("isoMuPass")
        #if not self.isoMuPass_branch and "isoMuPass" not in self.complained:
        if not self.isoMuPass_branch and "isoMuPass":
            warnings.warn( "EETauTree: Expected branch isoMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPass")
        else:
            self.isoMuPass_branch.SetAddress(<void*>&self.isoMuPass_value)

        #print "making isoMuPrescale"
        self.isoMuPrescale_branch = the_tree.GetBranch("isoMuPrescale")
        #if not self.isoMuPrescale_branch and "isoMuPrescale" not in self.complained:
        if not self.isoMuPrescale_branch and "isoMuPrescale":
            warnings.warn( "EETauTree: Expected branch isoMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPrescale")
        else:
            self.isoMuPrescale_branch.SetAddress(<void*>&self.isoMuPrescale_value)

        #print "making isoMuTauGroup"
        self.isoMuTauGroup_branch = the_tree.GetBranch("isoMuTauGroup")
        #if not self.isoMuTauGroup_branch and "isoMuTauGroup" not in self.complained:
        if not self.isoMuTauGroup_branch and "isoMuTauGroup":
            warnings.warn( "EETauTree: Expected branch isoMuTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauGroup")
        else:
            self.isoMuTauGroup_branch.SetAddress(<void*>&self.isoMuTauGroup_value)

        #print "making isoMuTauPass"
        self.isoMuTauPass_branch = the_tree.GetBranch("isoMuTauPass")
        #if not self.isoMuTauPass_branch and "isoMuTauPass" not in self.complained:
        if not self.isoMuTauPass_branch and "isoMuTauPass":
            warnings.warn( "EETauTree: Expected branch isoMuTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPass")
        else:
            self.isoMuTauPass_branch.SetAddress(<void*>&self.isoMuTauPass_value)

        #print "making isoMuTauPrescale"
        self.isoMuTauPrescale_branch = the_tree.GetBranch("isoMuTauPrescale")
        #if not self.isoMuTauPrescale_branch and "isoMuTauPrescale" not in self.complained:
        if not self.isoMuTauPrescale_branch and "isoMuTauPrescale":
            warnings.warn( "EETauTree: Expected branch isoMuTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPrescale")
        else:
            self.isoMuTauPrescale_branch.SetAddress(<void*>&self.isoMuTauPrescale_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "EETauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_DR05"
        self.jetVeto20_DR05_branch = the_tree.GetBranch("jetVeto20_DR05")
        #if not self.jetVeto20_DR05_branch and "jetVeto20_DR05" not in self.complained:
        if not self.jetVeto20_DR05_branch and "jetVeto20_DR05":
            warnings.warn( "EETauTree: Expected branch jetVeto20_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_DR05")
        else:
            self.jetVeto20_DR05_branch.SetAddress(<void*>&self.jetVeto20_DR05_value)

        #print "making jetVeto20jes_minus"
        self.jetVeto20jes_minus_branch = the_tree.GetBranch("jetVeto20jes_minus")
        #if not self.jetVeto20jes_minus_branch and "jetVeto20jes_minus" not in self.complained:
        if not self.jetVeto20jes_minus_branch and "jetVeto20jes_minus":
            warnings.warn( "EETauTree: Expected branch jetVeto20jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20jes_minus")
        else:
            self.jetVeto20jes_minus_branch.SetAddress(<void*>&self.jetVeto20jes_minus_value)

        #print "making jetVeto20jes_plus"
        self.jetVeto20jes_plus_branch = the_tree.GetBranch("jetVeto20jes_plus")
        #if not self.jetVeto20jes_plus_branch and "jetVeto20jes_plus" not in self.complained:
        if not self.jetVeto20jes_plus_branch and "jetVeto20jes_plus":
            warnings.warn( "EETauTree: Expected branch jetVeto20jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20jes_plus")
        else:
            self.jetVeto20jes_plus_branch.SetAddress(<void*>&self.jetVeto20jes_plus_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "EETauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_DR05"
        self.jetVeto30_DR05_branch = the_tree.GetBranch("jetVeto30_DR05")
        #if not self.jetVeto30_DR05_branch and "jetVeto30_DR05" not in self.complained:
        if not self.jetVeto30_DR05_branch and "jetVeto30_DR05":
            warnings.warn( "EETauTree: Expected branch jetVeto30_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_DR05")
        else:
            self.jetVeto30_DR05_branch.SetAddress(<void*>&self.jetVeto30_DR05_value)

        #print "making jetVeto30jes_minus"
        self.jetVeto30jes_minus_branch = the_tree.GetBranch("jetVeto30jes_minus")
        #if not self.jetVeto30jes_minus_branch and "jetVeto30jes_minus" not in self.complained:
        if not self.jetVeto30jes_minus_branch and "jetVeto30jes_minus":
            warnings.warn( "EETauTree: Expected branch jetVeto30jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30jes_minus")
        else:
            self.jetVeto30jes_minus_branch.SetAddress(<void*>&self.jetVeto30jes_minus_value)

        #print "making jetVeto30jes_plus"
        self.jetVeto30jes_plus_branch = the_tree.GetBranch("jetVeto30jes_plus")
        #if not self.jetVeto30jes_plus_branch and "jetVeto30jes_plus" not in self.complained:
        if not self.jetVeto30jes_plus_branch and "jetVeto30jes_plus":
            warnings.warn( "EETauTree: Expected branch jetVeto30jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30jes_plus")
        else:
            self.jetVeto30jes_plus_branch.SetAddress(<void*>&self.jetVeto30jes_plus_value)

        #print "making jetVeto40"
        self.jetVeto40_branch = the_tree.GetBranch("jetVeto40")
        #if not self.jetVeto40_branch and "jetVeto40" not in self.complained:
        if not self.jetVeto40_branch and "jetVeto40":
            warnings.warn( "EETauTree: Expected branch jetVeto40 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40")
        else:
            self.jetVeto40_branch.SetAddress(<void*>&self.jetVeto40_value)

        #print "making jetVeto40_DR05"
        self.jetVeto40_DR05_branch = the_tree.GetBranch("jetVeto40_DR05")
        #if not self.jetVeto40_DR05_branch and "jetVeto40_DR05" not in self.complained:
        if not self.jetVeto40_DR05_branch and "jetVeto40_DR05":
            warnings.warn( "EETauTree: Expected branch jetVeto40_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40_DR05")
        else:
            self.jetVeto40_DR05_branch.SetAddress(<void*>&self.jetVeto40_DR05_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EETauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making mu17ele8Group"
        self.mu17ele8Group_branch = the_tree.GetBranch("mu17ele8Group")
        #if not self.mu17ele8Group_branch and "mu17ele8Group" not in self.complained:
        if not self.mu17ele8Group_branch and "mu17ele8Group":
            warnings.warn( "EETauTree: Expected branch mu17ele8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Group")
        else:
            self.mu17ele8Group_branch.SetAddress(<void*>&self.mu17ele8Group_value)

        #print "making mu17ele8Pass"
        self.mu17ele8Pass_branch = the_tree.GetBranch("mu17ele8Pass")
        #if not self.mu17ele8Pass_branch and "mu17ele8Pass" not in self.complained:
        if not self.mu17ele8Pass_branch and "mu17ele8Pass":
            warnings.warn( "EETauTree: Expected branch mu17ele8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Pass")
        else:
            self.mu17ele8Pass_branch.SetAddress(<void*>&self.mu17ele8Pass_value)

        #print "making mu17ele8Prescale"
        self.mu17ele8Prescale_branch = the_tree.GetBranch("mu17ele8Prescale")
        #if not self.mu17ele8Prescale_branch and "mu17ele8Prescale" not in self.complained:
        if not self.mu17ele8Prescale_branch and "mu17ele8Prescale":
            warnings.warn( "EETauTree: Expected branch mu17ele8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Prescale")
        else:
            self.mu17ele8Prescale_branch.SetAddress(<void*>&self.mu17ele8Prescale_value)

        #print "making mu17ele8isoGroup"
        self.mu17ele8isoGroup_branch = the_tree.GetBranch("mu17ele8isoGroup")
        #if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup" not in self.complained:
        if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup":
            warnings.warn( "EETauTree: Expected branch mu17ele8isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoGroup")
        else:
            self.mu17ele8isoGroup_branch.SetAddress(<void*>&self.mu17ele8isoGroup_value)

        #print "making mu17ele8isoPass"
        self.mu17ele8isoPass_branch = the_tree.GetBranch("mu17ele8isoPass")
        #if not self.mu17ele8isoPass_branch and "mu17ele8isoPass" not in self.complained:
        if not self.mu17ele8isoPass_branch and "mu17ele8isoPass":
            warnings.warn( "EETauTree: Expected branch mu17ele8isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPass")
        else:
            self.mu17ele8isoPass_branch.SetAddress(<void*>&self.mu17ele8isoPass_value)

        #print "making mu17ele8isoPrescale"
        self.mu17ele8isoPrescale_branch = the_tree.GetBranch("mu17ele8isoPrescale")
        #if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale" not in self.complained:
        if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale":
            warnings.warn( "EETauTree: Expected branch mu17ele8isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPrescale")
        else:
            self.mu17ele8isoPrescale_branch.SetAddress(<void*>&self.mu17ele8isoPrescale_value)

        #print "making mu17mu8Group"
        self.mu17mu8Group_branch = the_tree.GetBranch("mu17mu8Group")
        #if not self.mu17mu8Group_branch and "mu17mu8Group" not in self.complained:
        if not self.mu17mu8Group_branch and "mu17mu8Group":
            warnings.warn( "EETauTree: Expected branch mu17mu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Group")
        else:
            self.mu17mu8Group_branch.SetAddress(<void*>&self.mu17mu8Group_value)

        #print "making mu17mu8Pass"
        self.mu17mu8Pass_branch = the_tree.GetBranch("mu17mu8Pass")
        #if not self.mu17mu8Pass_branch and "mu17mu8Pass" not in self.complained:
        if not self.mu17mu8Pass_branch and "mu17mu8Pass":
            warnings.warn( "EETauTree: Expected branch mu17mu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Pass")
        else:
            self.mu17mu8Pass_branch.SetAddress(<void*>&self.mu17mu8Pass_value)

        #print "making mu17mu8Prescale"
        self.mu17mu8Prescale_branch = the_tree.GetBranch("mu17mu8Prescale")
        #if not self.mu17mu8Prescale_branch and "mu17mu8Prescale" not in self.complained:
        if not self.mu17mu8Prescale_branch and "mu17mu8Prescale":
            warnings.warn( "EETauTree: Expected branch mu17mu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Prescale")
        else:
            self.mu17mu8Prescale_branch.SetAddress(<void*>&self.mu17mu8Prescale_value)

        #print "making mu8ele17Group"
        self.mu8ele17Group_branch = the_tree.GetBranch("mu8ele17Group")
        #if not self.mu8ele17Group_branch and "mu8ele17Group" not in self.complained:
        if not self.mu8ele17Group_branch and "mu8ele17Group":
            warnings.warn( "EETauTree: Expected branch mu8ele17Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Group")
        else:
            self.mu8ele17Group_branch.SetAddress(<void*>&self.mu8ele17Group_value)

        #print "making mu8ele17Pass"
        self.mu8ele17Pass_branch = the_tree.GetBranch("mu8ele17Pass")
        #if not self.mu8ele17Pass_branch and "mu8ele17Pass" not in self.complained:
        if not self.mu8ele17Pass_branch and "mu8ele17Pass":
            warnings.warn( "EETauTree: Expected branch mu8ele17Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Pass")
        else:
            self.mu8ele17Pass_branch.SetAddress(<void*>&self.mu8ele17Pass_value)

        #print "making mu8ele17Prescale"
        self.mu8ele17Prescale_branch = the_tree.GetBranch("mu8ele17Prescale")
        #if not self.mu8ele17Prescale_branch and "mu8ele17Prescale" not in self.complained:
        if not self.mu8ele17Prescale_branch and "mu8ele17Prescale":
            warnings.warn( "EETauTree: Expected branch mu8ele17Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Prescale")
        else:
            self.mu8ele17Prescale_branch.SetAddress(<void*>&self.mu8ele17Prescale_value)

        #print "making mu8ele17isoGroup"
        self.mu8ele17isoGroup_branch = the_tree.GetBranch("mu8ele17isoGroup")
        #if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup" not in self.complained:
        if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup":
            warnings.warn( "EETauTree: Expected branch mu8ele17isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoGroup")
        else:
            self.mu8ele17isoGroup_branch.SetAddress(<void*>&self.mu8ele17isoGroup_value)

        #print "making mu8ele17isoPass"
        self.mu8ele17isoPass_branch = the_tree.GetBranch("mu8ele17isoPass")
        #if not self.mu8ele17isoPass_branch and "mu8ele17isoPass" not in self.complained:
        if not self.mu8ele17isoPass_branch and "mu8ele17isoPass":
            warnings.warn( "EETauTree: Expected branch mu8ele17isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPass")
        else:
            self.mu8ele17isoPass_branch.SetAddress(<void*>&self.mu8ele17isoPass_value)

        #print "making mu8ele17isoPrescale"
        self.mu8ele17isoPrescale_branch = the_tree.GetBranch("mu8ele17isoPrescale")
        #if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale" not in self.complained:
        if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale":
            warnings.warn( "EETauTree: Expected branch mu8ele17isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPrescale")
        else:
            self.mu8ele17isoPrescale_branch.SetAddress(<void*>&self.mu8ele17isoPrescale_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "EETauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muTauGroup"
        self.muTauGroup_branch = the_tree.GetBranch("muTauGroup")
        #if not self.muTauGroup_branch and "muTauGroup" not in self.complained:
        if not self.muTauGroup_branch and "muTauGroup":
            warnings.warn( "EETauTree: Expected branch muTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauGroup")
        else:
            self.muTauGroup_branch.SetAddress(<void*>&self.muTauGroup_value)

        #print "making muTauPass"
        self.muTauPass_branch = the_tree.GetBranch("muTauPass")
        #if not self.muTauPass_branch and "muTauPass" not in self.complained:
        if not self.muTauPass_branch and "muTauPass":
            warnings.warn( "EETauTree: Expected branch muTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPass")
        else:
            self.muTauPass_branch.SetAddress(<void*>&self.muTauPass_value)

        #print "making muTauPrescale"
        self.muTauPrescale_branch = the_tree.GetBranch("muTauPrescale")
        #if not self.muTauPrescale_branch and "muTauPrescale" not in self.complained:
        if not self.muTauPrescale_branch and "muTauPrescale":
            warnings.warn( "EETauTree: Expected branch muTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPrescale")
        else:
            self.muTauPrescale_branch.SetAddress(<void*>&self.muTauPrescale_value)

        #print "making muTauTestGroup"
        self.muTauTestGroup_branch = the_tree.GetBranch("muTauTestGroup")
        #if not self.muTauTestGroup_branch and "muTauTestGroup" not in self.complained:
        if not self.muTauTestGroup_branch and "muTauTestGroup":
            warnings.warn( "EETauTree: Expected branch muTauTestGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestGroup")
        else:
            self.muTauTestGroup_branch.SetAddress(<void*>&self.muTauTestGroup_value)

        #print "making muTauTestPass"
        self.muTauTestPass_branch = the_tree.GetBranch("muTauTestPass")
        #if not self.muTauTestPass_branch and "muTauTestPass" not in self.complained:
        if not self.muTauTestPass_branch and "muTauTestPass":
            warnings.warn( "EETauTree: Expected branch muTauTestPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPass")
        else:
            self.muTauTestPass_branch.SetAddress(<void*>&self.muTauTestPass_value)

        #print "making muTauTestPrescale"
        self.muTauTestPrescale_branch = the_tree.GetBranch("muTauTestPrescale")
        #if not self.muTauTestPrescale_branch and "muTauTestPrescale" not in self.complained:
        if not self.muTauTestPrescale_branch and "muTauTestPrescale":
            warnings.warn( "EETauTree: Expected branch muTauTestPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPrescale")
        else:
            self.muTauTestPrescale_branch.SetAddress(<void*>&self.muTauTestPrescale_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "EETauTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "EETauTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "EETauTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making muVetoPt5IsoIdVtx_mes_minus"
        self.muVetoPt5IsoIdVtx_mes_minus_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx_mes_minus")
        #if not self.muVetoPt5IsoIdVtx_mes_minus_branch and "muVetoPt5IsoIdVtx_mes_minus" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_mes_minus_branch and "muVetoPt5IsoIdVtx_mes_minus":
            warnings.warn( "EETauTree: Expected branch muVetoPt5IsoIdVtx_mes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx_mes_minus")
        else:
            self.muVetoPt5IsoIdVtx_mes_minus_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_mes_minus_value)

        #print "making muVetoPt5IsoIdVtx_mes_plus"
        self.muVetoPt5IsoIdVtx_mes_plus_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx_mes_plus")
        #if not self.muVetoPt5IsoIdVtx_mes_plus_branch and "muVetoPt5IsoIdVtx_mes_plus" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_mes_plus_branch and "muVetoPt5IsoIdVtx_mes_plus":
            warnings.warn( "EETauTree: Expected branch muVetoPt5IsoIdVtx_mes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx_mes_plus")
        else:
            self.muVetoPt5IsoIdVtx_mes_plus_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_mes_plus_value)

        #print "making mva_met_Et"
        self.mva_met_Et_branch = the_tree.GetBranch("mva_met_Et")
        #if not self.mva_met_Et_branch and "mva_met_Et" not in self.complained:
        if not self.mva_met_Et_branch and "mva_met_Et":
            warnings.warn( "EETauTree: Expected branch mva_met_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_met_Et")
        else:
            self.mva_met_Et_branch.SetAddress(<void*>&self.mva_met_Et_value)

        #print "making mva_met_Phi"
        self.mva_met_Phi_branch = the_tree.GetBranch("mva_met_Phi")
        #if not self.mva_met_Phi_branch and "mva_met_Phi" not in self.complained:
        if not self.mva_met_Phi_branch and "mva_met_Phi":
            warnings.warn( "EETauTree: Expected branch mva_met_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_met_Phi")
        else:
            self.mva_met_Phi_branch.SetAddress(<void*>&self.mva_met_Phi_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "EETauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "EETauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making pfMet_Et"
        self.pfMet_Et_branch = the_tree.GetBranch("pfMet_Et")
        #if not self.pfMet_Et_branch and "pfMet_Et" not in self.complained:
        if not self.pfMet_Et_branch and "pfMet_Et":
            warnings.warn( "EETauTree: Expected branch pfMet_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et")
        else:
            self.pfMet_Et_branch.SetAddress(<void*>&self.pfMet_Et_value)

        #print "making pfMet_Et_ees_minus"
        self.pfMet_Et_ees_minus_branch = the_tree.GetBranch("pfMet_Et_ees_minus")
        #if not self.pfMet_Et_ees_minus_branch and "pfMet_Et_ees_minus" not in self.complained:
        if not self.pfMet_Et_ees_minus_branch and "pfMet_Et_ees_minus":
            warnings.warn( "EETauTree: Expected branch pfMet_Et_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_ees_minus")
        else:
            self.pfMet_Et_ees_minus_branch.SetAddress(<void*>&self.pfMet_Et_ees_minus_value)

        #print "making pfMet_Et_ees_plus"
        self.pfMet_Et_ees_plus_branch = the_tree.GetBranch("pfMet_Et_ees_plus")
        #if not self.pfMet_Et_ees_plus_branch and "pfMet_Et_ees_plus" not in self.complained:
        if not self.pfMet_Et_ees_plus_branch and "pfMet_Et_ees_plus":
            warnings.warn( "EETauTree: Expected branch pfMet_Et_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_ees_plus")
        else:
            self.pfMet_Et_ees_plus_branch.SetAddress(<void*>&self.pfMet_Et_ees_plus_value)

        #print "making pfMet_Et_jes_minus"
        self.pfMet_Et_jes_minus_branch = the_tree.GetBranch("pfMet_Et_jes_minus")
        #if not self.pfMet_Et_jes_minus_branch and "pfMet_Et_jes_minus" not in self.complained:
        if not self.pfMet_Et_jes_minus_branch and "pfMet_Et_jes_minus":
            warnings.warn( "EETauTree: Expected branch pfMet_Et_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_jes_minus")
        else:
            self.pfMet_Et_jes_minus_branch.SetAddress(<void*>&self.pfMet_Et_jes_minus_value)

        #print "making pfMet_Et_jes_plus"
        self.pfMet_Et_jes_plus_branch = the_tree.GetBranch("pfMet_Et_jes_plus")
        #if not self.pfMet_Et_jes_plus_branch and "pfMet_Et_jes_plus" not in self.complained:
        if not self.pfMet_Et_jes_plus_branch and "pfMet_Et_jes_plus":
            warnings.warn( "EETauTree: Expected branch pfMet_Et_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_jes_plus")
        else:
            self.pfMet_Et_jes_plus_branch.SetAddress(<void*>&self.pfMet_Et_jes_plus_value)

        #print "making pfMet_Et_mes_minus"
        self.pfMet_Et_mes_minus_branch = the_tree.GetBranch("pfMet_Et_mes_minus")
        #if not self.pfMet_Et_mes_minus_branch and "pfMet_Et_mes_minus" not in self.complained:
        if not self.pfMet_Et_mes_minus_branch and "pfMet_Et_mes_minus":
            warnings.warn( "EETauTree: Expected branch pfMet_Et_mes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_mes_minus")
        else:
            self.pfMet_Et_mes_minus_branch.SetAddress(<void*>&self.pfMet_Et_mes_minus_value)

        #print "making pfMet_Et_mes_plus"
        self.pfMet_Et_mes_plus_branch = the_tree.GetBranch("pfMet_Et_mes_plus")
        #if not self.pfMet_Et_mes_plus_branch and "pfMet_Et_mes_plus" not in self.complained:
        if not self.pfMet_Et_mes_plus_branch and "pfMet_Et_mes_plus":
            warnings.warn( "EETauTree: Expected branch pfMet_Et_mes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_mes_plus")
        else:
            self.pfMet_Et_mes_plus_branch.SetAddress(<void*>&self.pfMet_Et_mes_plus_value)

        #print "making pfMet_Et_tes_minus"
        self.pfMet_Et_tes_minus_branch = the_tree.GetBranch("pfMet_Et_tes_minus")
        #if not self.pfMet_Et_tes_minus_branch and "pfMet_Et_tes_minus" not in self.complained:
        if not self.pfMet_Et_tes_minus_branch and "pfMet_Et_tes_minus":
            warnings.warn( "EETauTree: Expected branch pfMet_Et_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_tes_minus")
        else:
            self.pfMet_Et_tes_minus_branch.SetAddress(<void*>&self.pfMet_Et_tes_minus_value)

        #print "making pfMet_Et_tes_plus"
        self.pfMet_Et_tes_plus_branch = the_tree.GetBranch("pfMet_Et_tes_plus")
        #if not self.pfMet_Et_tes_plus_branch and "pfMet_Et_tes_plus" not in self.complained:
        if not self.pfMet_Et_tes_plus_branch and "pfMet_Et_tes_plus":
            warnings.warn( "EETauTree: Expected branch pfMet_Et_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_tes_plus")
        else:
            self.pfMet_Et_tes_plus_branch.SetAddress(<void*>&self.pfMet_Et_tes_plus_value)

        #print "making pfMet_Et_ues_minus"
        self.pfMet_Et_ues_minus_branch = the_tree.GetBranch("pfMet_Et_ues_minus")
        #if not self.pfMet_Et_ues_minus_branch and "pfMet_Et_ues_minus" not in self.complained:
        if not self.pfMet_Et_ues_minus_branch and "pfMet_Et_ues_minus":
            warnings.warn( "EETauTree: Expected branch pfMet_Et_ues_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_ues_minus")
        else:
            self.pfMet_Et_ues_minus_branch.SetAddress(<void*>&self.pfMet_Et_ues_minus_value)

        #print "making pfMet_Et_ues_plus"
        self.pfMet_Et_ues_plus_branch = the_tree.GetBranch("pfMet_Et_ues_plus")
        #if not self.pfMet_Et_ues_plus_branch and "pfMet_Et_ues_plus" not in self.complained:
        if not self.pfMet_Et_ues_plus_branch and "pfMet_Et_ues_plus":
            warnings.warn( "EETauTree: Expected branch pfMet_Et_ues_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_ues_plus")
        else:
            self.pfMet_Et_ues_plus_branch.SetAddress(<void*>&self.pfMet_Et_ues_plus_value)

        #print "making pfMet_Phi"
        self.pfMet_Phi_branch = the_tree.GetBranch("pfMet_Phi")
        #if not self.pfMet_Phi_branch and "pfMet_Phi" not in self.complained:
        if not self.pfMet_Phi_branch and "pfMet_Phi":
            warnings.warn( "EETauTree: Expected branch pfMet_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi")
        else:
            self.pfMet_Phi_branch.SetAddress(<void*>&self.pfMet_Phi_value)

        #print "making pfMet_Phi_ees_minus"
        self.pfMet_Phi_ees_minus_branch = the_tree.GetBranch("pfMet_Phi_ees_minus")
        #if not self.pfMet_Phi_ees_minus_branch and "pfMet_Phi_ees_minus" not in self.complained:
        if not self.pfMet_Phi_ees_minus_branch and "pfMet_Phi_ees_minus":
            warnings.warn( "EETauTree: Expected branch pfMet_Phi_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_ees_minus")
        else:
            self.pfMet_Phi_ees_minus_branch.SetAddress(<void*>&self.pfMet_Phi_ees_minus_value)

        #print "making pfMet_Phi_ees_plus"
        self.pfMet_Phi_ees_plus_branch = the_tree.GetBranch("pfMet_Phi_ees_plus")
        #if not self.pfMet_Phi_ees_plus_branch and "pfMet_Phi_ees_plus" not in self.complained:
        if not self.pfMet_Phi_ees_plus_branch and "pfMet_Phi_ees_plus":
            warnings.warn( "EETauTree: Expected branch pfMet_Phi_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_ees_plus")
        else:
            self.pfMet_Phi_ees_plus_branch.SetAddress(<void*>&self.pfMet_Phi_ees_plus_value)

        #print "making pfMet_Phi_jes_minus"
        self.pfMet_Phi_jes_minus_branch = the_tree.GetBranch("pfMet_Phi_jes_minus")
        #if not self.pfMet_Phi_jes_minus_branch and "pfMet_Phi_jes_minus" not in self.complained:
        if not self.pfMet_Phi_jes_minus_branch and "pfMet_Phi_jes_minus":
            warnings.warn( "EETauTree: Expected branch pfMet_Phi_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_jes_minus")
        else:
            self.pfMet_Phi_jes_minus_branch.SetAddress(<void*>&self.pfMet_Phi_jes_minus_value)

        #print "making pfMet_Phi_jes_plus"
        self.pfMet_Phi_jes_plus_branch = the_tree.GetBranch("pfMet_Phi_jes_plus")
        #if not self.pfMet_Phi_jes_plus_branch and "pfMet_Phi_jes_plus" not in self.complained:
        if not self.pfMet_Phi_jes_plus_branch and "pfMet_Phi_jes_plus":
            warnings.warn( "EETauTree: Expected branch pfMet_Phi_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_jes_plus")
        else:
            self.pfMet_Phi_jes_plus_branch.SetAddress(<void*>&self.pfMet_Phi_jes_plus_value)

        #print "making pfMet_Phi_mes_minus"
        self.pfMet_Phi_mes_minus_branch = the_tree.GetBranch("pfMet_Phi_mes_minus")
        #if not self.pfMet_Phi_mes_minus_branch and "pfMet_Phi_mes_minus" not in self.complained:
        if not self.pfMet_Phi_mes_minus_branch and "pfMet_Phi_mes_minus":
            warnings.warn( "EETauTree: Expected branch pfMet_Phi_mes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_mes_minus")
        else:
            self.pfMet_Phi_mes_minus_branch.SetAddress(<void*>&self.pfMet_Phi_mes_minus_value)

        #print "making pfMet_Phi_mes_plus"
        self.pfMet_Phi_mes_plus_branch = the_tree.GetBranch("pfMet_Phi_mes_plus")
        #if not self.pfMet_Phi_mes_plus_branch and "pfMet_Phi_mes_plus" not in self.complained:
        if not self.pfMet_Phi_mes_plus_branch and "pfMet_Phi_mes_plus":
            warnings.warn( "EETauTree: Expected branch pfMet_Phi_mes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_mes_plus")
        else:
            self.pfMet_Phi_mes_plus_branch.SetAddress(<void*>&self.pfMet_Phi_mes_plus_value)

        #print "making pfMet_Phi_tes_minus"
        self.pfMet_Phi_tes_minus_branch = the_tree.GetBranch("pfMet_Phi_tes_minus")
        #if not self.pfMet_Phi_tes_minus_branch and "pfMet_Phi_tes_minus" not in self.complained:
        if not self.pfMet_Phi_tes_minus_branch and "pfMet_Phi_tes_minus":
            warnings.warn( "EETauTree: Expected branch pfMet_Phi_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_tes_minus")
        else:
            self.pfMet_Phi_tes_minus_branch.SetAddress(<void*>&self.pfMet_Phi_tes_minus_value)

        #print "making pfMet_Phi_tes_plus"
        self.pfMet_Phi_tes_plus_branch = the_tree.GetBranch("pfMet_Phi_tes_plus")
        #if not self.pfMet_Phi_tes_plus_branch and "pfMet_Phi_tes_plus" not in self.complained:
        if not self.pfMet_Phi_tes_plus_branch and "pfMet_Phi_tes_plus":
            warnings.warn( "EETauTree: Expected branch pfMet_Phi_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_tes_plus")
        else:
            self.pfMet_Phi_tes_plus_branch.SetAddress(<void*>&self.pfMet_Phi_tes_plus_value)

        #print "making pfMet_Phi_ues_minus"
        self.pfMet_Phi_ues_minus_branch = the_tree.GetBranch("pfMet_Phi_ues_minus")
        #if not self.pfMet_Phi_ues_minus_branch and "pfMet_Phi_ues_minus" not in self.complained:
        if not self.pfMet_Phi_ues_minus_branch and "pfMet_Phi_ues_minus":
            warnings.warn( "EETauTree: Expected branch pfMet_Phi_ues_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_ues_minus")
        else:
            self.pfMet_Phi_ues_minus_branch.SetAddress(<void*>&self.pfMet_Phi_ues_minus_value)

        #print "making pfMet_Phi_ues_plus"
        self.pfMet_Phi_ues_plus_branch = the_tree.GetBranch("pfMet_Phi_ues_plus")
        #if not self.pfMet_Phi_ues_plus_branch and "pfMet_Phi_ues_plus" not in self.complained:
        if not self.pfMet_Phi_ues_plus_branch and "pfMet_Phi_ues_plus":
            warnings.warn( "EETauTree: Expected branch pfMet_Phi_ues_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_ues_plus")
        else:
            self.pfMet_Phi_ues_plus_branch.SetAddress(<void*>&self.pfMet_Phi_ues_plus_value)

        #print "making pfMet_diff_Et"
        self.pfMet_diff_Et_branch = the_tree.GetBranch("pfMet_diff_Et")
        #if not self.pfMet_diff_Et_branch and "pfMet_diff_Et" not in self.complained:
        if not self.pfMet_diff_Et_branch and "pfMet_diff_Et":
            warnings.warn( "EETauTree: Expected branch pfMet_diff_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_diff_Et")
        else:
            self.pfMet_diff_Et_branch.SetAddress(<void*>&self.pfMet_diff_Et_value)

        #print "making pfMet_jes_Et"
        self.pfMet_jes_Et_branch = the_tree.GetBranch("pfMet_jes_Et")
        #if not self.pfMet_jes_Et_branch and "pfMet_jes_Et" not in self.complained:
        if not self.pfMet_jes_Et_branch and "pfMet_jes_Et":
            warnings.warn( "EETauTree: Expected branch pfMet_jes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Et")
        else:
            self.pfMet_jes_Et_branch.SetAddress(<void*>&self.pfMet_jes_Et_value)

        #print "making pfMet_jes_Phi"
        self.pfMet_jes_Phi_branch = the_tree.GetBranch("pfMet_jes_Phi")
        #if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi" not in self.complained:
        if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi":
            warnings.warn( "EETauTree: Expected branch pfMet_jes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Phi")
        else:
            self.pfMet_jes_Phi_branch.SetAddress(<void*>&self.pfMet_jes_Phi_value)

        #print "making pfMet_ues_AtanToPhi"
        self.pfMet_ues_AtanToPhi_branch = the_tree.GetBranch("pfMet_ues_AtanToPhi")
        #if not self.pfMet_ues_AtanToPhi_branch and "pfMet_ues_AtanToPhi" not in self.complained:
        if not self.pfMet_ues_AtanToPhi_branch and "pfMet_ues_AtanToPhi":
            warnings.warn( "EETauTree: Expected branch pfMet_ues_AtanToPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_AtanToPhi")
        else:
            self.pfMet_ues_AtanToPhi_branch.SetAddress(<void*>&self.pfMet_ues_AtanToPhi_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "EETauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "EETauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "EETauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "EETauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "EETauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "EETauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "EETauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "EETauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "EETauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "EETauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "EETauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "EETauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "EETauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "EETauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "EETauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "EETauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE27WP80Group"
        self.singleE27WP80Group_branch = the_tree.GetBranch("singleE27WP80Group")
        #if not self.singleE27WP80Group_branch and "singleE27WP80Group" not in self.complained:
        if not self.singleE27WP80Group_branch and "singleE27WP80Group":
            warnings.warn( "EETauTree: Expected branch singleE27WP80Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27WP80Group")
        else:
            self.singleE27WP80Group_branch.SetAddress(<void*>&self.singleE27WP80Group_value)

        #print "making singleE27WP80Pass"
        self.singleE27WP80Pass_branch = the_tree.GetBranch("singleE27WP80Pass")
        #if not self.singleE27WP80Pass_branch and "singleE27WP80Pass" not in self.complained:
        if not self.singleE27WP80Pass_branch and "singleE27WP80Pass":
            warnings.warn( "EETauTree: Expected branch singleE27WP80Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27WP80Pass")
        else:
            self.singleE27WP80Pass_branch.SetAddress(<void*>&self.singleE27WP80Pass_value)

        #print "making singleE27WP80Prescale"
        self.singleE27WP80Prescale_branch = the_tree.GetBranch("singleE27WP80Prescale")
        #if not self.singleE27WP80Prescale_branch and "singleE27WP80Prescale" not in self.complained:
        if not self.singleE27WP80Prescale_branch and "singleE27WP80Prescale":
            warnings.warn( "EETauTree: Expected branch singleE27WP80Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27WP80Prescale")
        else:
            self.singleE27WP80Prescale_branch.SetAddress(<void*>&self.singleE27WP80Prescale_value)

        #print "making singleEGroup"
        self.singleEGroup_branch = the_tree.GetBranch("singleEGroup")
        #if not self.singleEGroup_branch and "singleEGroup" not in self.complained:
        if not self.singleEGroup_branch and "singleEGroup":
            warnings.warn( "EETauTree: Expected branch singleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEGroup")
        else:
            self.singleEGroup_branch.SetAddress(<void*>&self.singleEGroup_value)

        #print "making singleEPFMTGroup"
        self.singleEPFMTGroup_branch = the_tree.GetBranch("singleEPFMTGroup")
        #if not self.singleEPFMTGroup_branch and "singleEPFMTGroup" not in self.complained:
        if not self.singleEPFMTGroup_branch and "singleEPFMTGroup":
            warnings.warn( "EETauTree: Expected branch singleEPFMTGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTGroup")
        else:
            self.singleEPFMTGroup_branch.SetAddress(<void*>&self.singleEPFMTGroup_value)

        #print "making singleEPFMTPass"
        self.singleEPFMTPass_branch = the_tree.GetBranch("singleEPFMTPass")
        #if not self.singleEPFMTPass_branch and "singleEPFMTPass" not in self.complained:
        if not self.singleEPFMTPass_branch and "singleEPFMTPass":
            warnings.warn( "EETauTree: Expected branch singleEPFMTPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPass")
        else:
            self.singleEPFMTPass_branch.SetAddress(<void*>&self.singleEPFMTPass_value)

        #print "making singleEPFMTPrescale"
        self.singleEPFMTPrescale_branch = the_tree.GetBranch("singleEPFMTPrescale")
        #if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale" not in self.complained:
        if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale":
            warnings.warn( "EETauTree: Expected branch singleEPFMTPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPrescale")
        else:
            self.singleEPFMTPrescale_branch.SetAddress(<void*>&self.singleEPFMTPrescale_value)

        #print "making singleEPass"
        self.singleEPass_branch = the_tree.GetBranch("singleEPass")
        #if not self.singleEPass_branch and "singleEPass" not in self.complained:
        if not self.singleEPass_branch and "singleEPass":
            warnings.warn( "EETauTree: Expected branch singleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPass")
        else:
            self.singleEPass_branch.SetAddress(<void*>&self.singleEPass_value)

        #print "making singleEPrescale"
        self.singleEPrescale_branch = the_tree.GetBranch("singleEPrescale")
        #if not self.singleEPrescale_branch and "singleEPrescale" not in self.complained:
        if not self.singleEPrescale_branch and "singleEPrescale":
            warnings.warn( "EETauTree: Expected branch singleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPrescale")
        else:
            self.singleEPrescale_branch.SetAddress(<void*>&self.singleEPrescale_value)

        #print "making singleMuGroup"
        self.singleMuGroup_branch = the_tree.GetBranch("singleMuGroup")
        #if not self.singleMuGroup_branch and "singleMuGroup" not in self.complained:
        if not self.singleMuGroup_branch and "singleMuGroup":
            warnings.warn( "EETauTree: Expected branch singleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuGroup")
        else:
            self.singleMuGroup_branch.SetAddress(<void*>&self.singleMuGroup_value)

        #print "making singleMuPass"
        self.singleMuPass_branch = the_tree.GetBranch("singleMuPass")
        #if not self.singleMuPass_branch and "singleMuPass" not in self.complained:
        if not self.singleMuPass_branch and "singleMuPass":
            warnings.warn( "EETauTree: Expected branch singleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPass")
        else:
            self.singleMuPass_branch.SetAddress(<void*>&self.singleMuPass_value)

        #print "making singleMuPrescale"
        self.singleMuPrescale_branch = the_tree.GetBranch("singleMuPrescale")
        #if not self.singleMuPrescale_branch and "singleMuPrescale" not in self.complained:
        if not self.singleMuPrescale_branch and "singleMuPrescale":
            warnings.warn( "EETauTree: Expected branch singleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPrescale")
        else:
            self.singleMuPrescale_branch.SetAddress(<void*>&self.singleMuPrescale_value)

        #print "making singlePhoGroup"
        self.singlePhoGroup_branch = the_tree.GetBranch("singlePhoGroup")
        #if not self.singlePhoGroup_branch and "singlePhoGroup" not in self.complained:
        if not self.singlePhoGroup_branch and "singlePhoGroup":
            warnings.warn( "EETauTree: Expected branch singlePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoGroup")
        else:
            self.singlePhoGroup_branch.SetAddress(<void*>&self.singlePhoGroup_value)

        #print "making singlePhoPass"
        self.singlePhoPass_branch = the_tree.GetBranch("singlePhoPass")
        #if not self.singlePhoPass_branch and "singlePhoPass" not in self.complained:
        if not self.singlePhoPass_branch and "singlePhoPass":
            warnings.warn( "EETauTree: Expected branch singlePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPass")
        else:
            self.singlePhoPass_branch.SetAddress(<void*>&self.singlePhoPass_value)

        #print "making singlePhoPrescale"
        self.singlePhoPrescale_branch = the_tree.GetBranch("singlePhoPrescale")
        #if not self.singlePhoPrescale_branch and "singlePhoPrescale" not in self.complained:
        if not self.singlePhoPrescale_branch and "singlePhoPrescale":
            warnings.warn( "EETauTree: Expected branch singlePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPrescale")
        else:
            self.singlePhoPrescale_branch.SetAddress(<void*>&self.singlePhoPrescale_value)

        #print "making tAbsEta"
        self.tAbsEta_branch = the_tree.GetBranch("tAbsEta")
        #if not self.tAbsEta_branch and "tAbsEta" not in self.complained:
        if not self.tAbsEta_branch and "tAbsEta":
            warnings.warn( "EETauTree: Expected branch tAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAbsEta")
        else:
            self.tAbsEta_branch.SetAddress(<void*>&self.tAbsEta_value)

        #print "making tAntiElectronLoose"
        self.tAntiElectronLoose_branch = the_tree.GetBranch("tAntiElectronLoose")
        #if not self.tAntiElectronLoose_branch and "tAntiElectronLoose" not in self.complained:
        if not self.tAntiElectronLoose_branch and "tAntiElectronLoose":
            warnings.warn( "EETauTree: Expected branch tAntiElectronLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronLoose")
        else:
            self.tAntiElectronLoose_branch.SetAddress(<void*>&self.tAntiElectronLoose_value)

        #print "making tAntiElectronMVA5Loose"
        self.tAntiElectronMVA5Loose_branch = the_tree.GetBranch("tAntiElectronMVA5Loose")
        #if not self.tAntiElectronMVA5Loose_branch and "tAntiElectronMVA5Loose" not in self.complained:
        if not self.tAntiElectronMVA5Loose_branch and "tAntiElectronMVA5Loose":
            warnings.warn( "EETauTree: Expected branch tAntiElectronMVA5Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA5Loose")
        else:
            self.tAntiElectronMVA5Loose_branch.SetAddress(<void*>&self.tAntiElectronMVA5Loose_value)

        #print "making tAntiElectronMVA5Medium"
        self.tAntiElectronMVA5Medium_branch = the_tree.GetBranch("tAntiElectronMVA5Medium")
        #if not self.tAntiElectronMVA5Medium_branch and "tAntiElectronMVA5Medium" not in self.complained:
        if not self.tAntiElectronMVA5Medium_branch and "tAntiElectronMVA5Medium":
            warnings.warn( "EETauTree: Expected branch tAntiElectronMVA5Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA5Medium")
        else:
            self.tAntiElectronMVA5Medium_branch.SetAddress(<void*>&self.tAntiElectronMVA5Medium_value)

        #print "making tAntiElectronMVA5Tight"
        self.tAntiElectronMVA5Tight_branch = the_tree.GetBranch("tAntiElectronMVA5Tight")
        #if not self.tAntiElectronMVA5Tight_branch and "tAntiElectronMVA5Tight" not in self.complained:
        if not self.tAntiElectronMVA5Tight_branch and "tAntiElectronMVA5Tight":
            warnings.warn( "EETauTree: Expected branch tAntiElectronMVA5Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA5Tight")
        else:
            self.tAntiElectronMVA5Tight_branch.SetAddress(<void*>&self.tAntiElectronMVA5Tight_value)

        #print "making tAntiElectronMVA5VLoose"
        self.tAntiElectronMVA5VLoose_branch = the_tree.GetBranch("tAntiElectronMVA5VLoose")
        #if not self.tAntiElectronMVA5VLoose_branch and "tAntiElectronMVA5VLoose" not in self.complained:
        if not self.tAntiElectronMVA5VLoose_branch and "tAntiElectronMVA5VLoose":
            warnings.warn( "EETauTree: Expected branch tAntiElectronMVA5VLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA5VLoose")
        else:
            self.tAntiElectronMVA5VLoose_branch.SetAddress(<void*>&self.tAntiElectronMVA5VLoose_value)

        #print "making tAntiElectronMVA5VTight"
        self.tAntiElectronMVA5VTight_branch = the_tree.GetBranch("tAntiElectronMVA5VTight")
        #if not self.tAntiElectronMVA5VTight_branch and "tAntiElectronMVA5VTight" not in self.complained:
        if not self.tAntiElectronMVA5VTight_branch and "tAntiElectronMVA5VTight":
            warnings.warn( "EETauTree: Expected branch tAntiElectronMVA5VTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA5VTight")
        else:
            self.tAntiElectronMVA5VTight_branch.SetAddress(<void*>&self.tAntiElectronMVA5VTight_value)

        #print "making tAntiElectronMedium"
        self.tAntiElectronMedium_branch = the_tree.GetBranch("tAntiElectronMedium")
        #if not self.tAntiElectronMedium_branch and "tAntiElectronMedium" not in self.complained:
        if not self.tAntiElectronMedium_branch and "tAntiElectronMedium":
            warnings.warn( "EETauTree: Expected branch tAntiElectronMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMedium")
        else:
            self.tAntiElectronMedium_branch.SetAddress(<void*>&self.tAntiElectronMedium_value)

        #print "making tAntiElectronTight"
        self.tAntiElectronTight_branch = the_tree.GetBranch("tAntiElectronTight")
        #if not self.tAntiElectronTight_branch and "tAntiElectronTight" not in self.complained:
        if not self.tAntiElectronTight_branch and "tAntiElectronTight":
            warnings.warn( "EETauTree: Expected branch tAntiElectronTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronTight")
        else:
            self.tAntiElectronTight_branch.SetAddress(<void*>&self.tAntiElectronTight_value)

        #print "making tAntiMuon2Loose"
        self.tAntiMuon2Loose_branch = the_tree.GetBranch("tAntiMuon2Loose")
        #if not self.tAntiMuon2Loose_branch and "tAntiMuon2Loose" not in self.complained:
        if not self.tAntiMuon2Loose_branch and "tAntiMuon2Loose":
            warnings.warn( "EETauTree: Expected branch tAntiMuon2Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuon2Loose")
        else:
            self.tAntiMuon2Loose_branch.SetAddress(<void*>&self.tAntiMuon2Loose_value)

        #print "making tAntiMuon2Medium"
        self.tAntiMuon2Medium_branch = the_tree.GetBranch("tAntiMuon2Medium")
        #if not self.tAntiMuon2Medium_branch and "tAntiMuon2Medium" not in self.complained:
        if not self.tAntiMuon2Medium_branch and "tAntiMuon2Medium":
            warnings.warn( "EETauTree: Expected branch tAntiMuon2Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuon2Medium")
        else:
            self.tAntiMuon2Medium_branch.SetAddress(<void*>&self.tAntiMuon2Medium_value)

        #print "making tAntiMuon2Tight"
        self.tAntiMuon2Tight_branch = the_tree.GetBranch("tAntiMuon2Tight")
        #if not self.tAntiMuon2Tight_branch and "tAntiMuon2Tight" not in self.complained:
        if not self.tAntiMuon2Tight_branch and "tAntiMuon2Tight":
            warnings.warn( "EETauTree: Expected branch tAntiMuon2Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuon2Tight")
        else:
            self.tAntiMuon2Tight_branch.SetAddress(<void*>&self.tAntiMuon2Tight_value)

        #print "making tAntiMuon3Loose"
        self.tAntiMuon3Loose_branch = the_tree.GetBranch("tAntiMuon3Loose")
        #if not self.tAntiMuon3Loose_branch and "tAntiMuon3Loose" not in self.complained:
        if not self.tAntiMuon3Loose_branch and "tAntiMuon3Loose":
            warnings.warn( "EETauTree: Expected branch tAntiMuon3Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuon3Loose")
        else:
            self.tAntiMuon3Loose_branch.SetAddress(<void*>&self.tAntiMuon3Loose_value)

        #print "making tAntiMuon3Tight"
        self.tAntiMuon3Tight_branch = the_tree.GetBranch("tAntiMuon3Tight")
        #if not self.tAntiMuon3Tight_branch and "tAntiMuon3Tight" not in self.complained:
        if not self.tAntiMuon3Tight_branch and "tAntiMuon3Tight":
            warnings.warn( "EETauTree: Expected branch tAntiMuon3Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuon3Tight")
        else:
            self.tAntiMuon3Tight_branch.SetAddress(<void*>&self.tAntiMuon3Tight_value)

        #print "making tAntiMuonLoose"
        self.tAntiMuonLoose_branch = the_tree.GetBranch("tAntiMuonLoose")
        #if not self.tAntiMuonLoose_branch and "tAntiMuonLoose" not in self.complained:
        if not self.tAntiMuonLoose_branch and "tAntiMuonLoose":
            warnings.warn( "EETauTree: Expected branch tAntiMuonLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonLoose")
        else:
            self.tAntiMuonLoose_branch.SetAddress(<void*>&self.tAntiMuonLoose_value)

        #print "making tAntiMuonMVALoose"
        self.tAntiMuonMVALoose_branch = the_tree.GetBranch("tAntiMuonMVALoose")
        #if not self.tAntiMuonMVALoose_branch and "tAntiMuonMVALoose" not in self.complained:
        if not self.tAntiMuonMVALoose_branch and "tAntiMuonMVALoose":
            warnings.warn( "EETauTree: Expected branch tAntiMuonMVALoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMVALoose")
        else:
            self.tAntiMuonMVALoose_branch.SetAddress(<void*>&self.tAntiMuonMVALoose_value)

        #print "making tAntiMuonMVAMedium"
        self.tAntiMuonMVAMedium_branch = the_tree.GetBranch("tAntiMuonMVAMedium")
        #if not self.tAntiMuonMVAMedium_branch and "tAntiMuonMVAMedium" not in self.complained:
        if not self.tAntiMuonMVAMedium_branch and "tAntiMuonMVAMedium":
            warnings.warn( "EETauTree: Expected branch tAntiMuonMVAMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMVAMedium")
        else:
            self.tAntiMuonMVAMedium_branch.SetAddress(<void*>&self.tAntiMuonMVAMedium_value)

        #print "making tAntiMuonMVATight"
        self.tAntiMuonMVATight_branch = the_tree.GetBranch("tAntiMuonMVATight")
        #if not self.tAntiMuonMVATight_branch and "tAntiMuonMVATight" not in self.complained:
        if not self.tAntiMuonMVATight_branch and "tAntiMuonMVATight":
            warnings.warn( "EETauTree: Expected branch tAntiMuonMVATight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMVATight")
        else:
            self.tAntiMuonMVATight_branch.SetAddress(<void*>&self.tAntiMuonMVATight_value)

        #print "making tAntiMuonMedium"
        self.tAntiMuonMedium_branch = the_tree.GetBranch("tAntiMuonMedium")
        #if not self.tAntiMuonMedium_branch and "tAntiMuonMedium" not in self.complained:
        if not self.tAntiMuonMedium_branch and "tAntiMuonMedium":
            warnings.warn( "EETauTree: Expected branch tAntiMuonMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMedium")
        else:
            self.tAntiMuonMedium_branch.SetAddress(<void*>&self.tAntiMuonMedium_value)

        #print "making tAntiMuonTight"
        self.tAntiMuonTight_branch = the_tree.GetBranch("tAntiMuonTight")
        #if not self.tAntiMuonTight_branch and "tAntiMuonTight" not in self.complained:
        if not self.tAntiMuonTight_branch and "tAntiMuonTight":
            warnings.warn( "EETauTree: Expected branch tAntiMuonTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonTight")
        else:
            self.tAntiMuonTight_branch.SetAddress(<void*>&self.tAntiMuonTight_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "EETauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tCiCTightElecOverlap"
        self.tCiCTightElecOverlap_branch = the_tree.GetBranch("tCiCTightElecOverlap")
        #if not self.tCiCTightElecOverlap_branch and "tCiCTightElecOverlap" not in self.complained:
        if not self.tCiCTightElecOverlap_branch and "tCiCTightElecOverlap":
            warnings.warn( "EETauTree: Expected branch tCiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCiCTightElecOverlap")
        else:
            self.tCiCTightElecOverlap_branch.SetAddress(<void*>&self.tCiCTightElecOverlap_value)

        #print "making tComesFromHiggs"
        self.tComesFromHiggs_branch = the_tree.GetBranch("tComesFromHiggs")
        #if not self.tComesFromHiggs_branch and "tComesFromHiggs" not in self.complained:
        if not self.tComesFromHiggs_branch and "tComesFromHiggs":
            warnings.warn( "EETauTree: Expected branch tComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tComesFromHiggs")
        else:
            self.tComesFromHiggs_branch.SetAddress(<void*>&self.tComesFromHiggs_value)

        #print "making tDZ"
        self.tDZ_branch = the_tree.GetBranch("tDZ")
        #if not self.tDZ_branch and "tDZ" not in self.complained:
        if not self.tDZ_branch and "tDZ":
            warnings.warn( "EETauTree: Expected branch tDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDZ")
        else:
            self.tDZ_branch.SetAddress(<void*>&self.tDZ_value)

        #print "making tDecayFinding"
        self.tDecayFinding_branch = the_tree.GetBranch("tDecayFinding")
        #if not self.tDecayFinding_branch and "tDecayFinding" not in self.complained:
        if not self.tDecayFinding_branch and "tDecayFinding":
            warnings.warn( "EETauTree: Expected branch tDecayFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayFinding")
        else:
            self.tDecayFinding_branch.SetAddress(<void*>&self.tDecayFinding_value)

        #print "making tDecayFindingNewDMs"
        self.tDecayFindingNewDMs_branch = the_tree.GetBranch("tDecayFindingNewDMs")
        #if not self.tDecayFindingNewDMs_branch and "tDecayFindingNewDMs" not in self.complained:
        if not self.tDecayFindingNewDMs_branch and "tDecayFindingNewDMs":
            warnings.warn( "EETauTree: Expected branch tDecayFindingNewDMs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayFindingNewDMs")
        else:
            self.tDecayFindingNewDMs_branch.SetAddress(<void*>&self.tDecayFindingNewDMs_value)

        #print "making tDecayFindingOldDMs"
        self.tDecayFindingOldDMs_branch = the_tree.GetBranch("tDecayFindingOldDMs")
        #if not self.tDecayFindingOldDMs_branch and "tDecayFindingOldDMs" not in self.complained:
        if not self.tDecayFindingOldDMs_branch and "tDecayFindingOldDMs":
            warnings.warn( "EETauTree: Expected branch tDecayFindingOldDMs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayFindingOldDMs")
        else:
            self.tDecayFindingOldDMs_branch.SetAddress(<void*>&self.tDecayFindingOldDMs_value)

        #print "making tDecayMode"
        self.tDecayMode_branch = the_tree.GetBranch("tDecayMode")
        #if not self.tDecayMode_branch and "tDecayMode" not in self.complained:
        if not self.tDecayMode_branch and "tDecayMode":
            warnings.warn( "EETauTree: Expected branch tDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayMode")
        else:
            self.tDecayMode_branch.SetAddress(<void*>&self.tDecayMode_value)

        #print "making tElecOverlap"
        self.tElecOverlap_branch = the_tree.GetBranch("tElecOverlap")
        #if not self.tElecOverlap_branch and "tElecOverlap" not in self.complained:
        if not self.tElecOverlap_branch and "tElecOverlap":
            warnings.warn( "EETauTree: Expected branch tElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElecOverlap")
        else:
            self.tElecOverlap_branch.SetAddress(<void*>&self.tElecOverlap_value)

        #print "making tElectronPt10IdIsoVtxOverlap"
        self.tElectronPt10IdIsoVtxOverlap_branch = the_tree.GetBranch("tElectronPt10IdIsoVtxOverlap")
        #if not self.tElectronPt10IdIsoVtxOverlap_branch and "tElectronPt10IdIsoVtxOverlap" not in self.complained:
        if not self.tElectronPt10IdIsoVtxOverlap_branch and "tElectronPt10IdIsoVtxOverlap":
            warnings.warn( "EETauTree: Expected branch tElectronPt10IdIsoVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElectronPt10IdIsoVtxOverlap")
        else:
            self.tElectronPt10IdIsoVtxOverlap_branch.SetAddress(<void*>&self.tElectronPt10IdIsoVtxOverlap_value)

        #print "making tElectronPt10IdVtxOverlap"
        self.tElectronPt10IdVtxOverlap_branch = the_tree.GetBranch("tElectronPt10IdVtxOverlap")
        #if not self.tElectronPt10IdVtxOverlap_branch and "tElectronPt10IdVtxOverlap" not in self.complained:
        if not self.tElectronPt10IdVtxOverlap_branch and "tElectronPt10IdVtxOverlap":
            warnings.warn( "EETauTree: Expected branch tElectronPt10IdVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElectronPt10IdVtxOverlap")
        else:
            self.tElectronPt10IdVtxOverlap_branch.SetAddress(<void*>&self.tElectronPt10IdVtxOverlap_value)

        #print "making tElectronPt15IdIsoVtxOverlap"
        self.tElectronPt15IdIsoVtxOverlap_branch = the_tree.GetBranch("tElectronPt15IdIsoVtxOverlap")
        #if not self.tElectronPt15IdIsoVtxOverlap_branch and "tElectronPt15IdIsoVtxOverlap" not in self.complained:
        if not self.tElectronPt15IdIsoVtxOverlap_branch and "tElectronPt15IdIsoVtxOverlap":
            warnings.warn( "EETauTree: Expected branch tElectronPt15IdIsoVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElectronPt15IdIsoVtxOverlap")
        else:
            self.tElectronPt15IdIsoVtxOverlap_branch.SetAddress(<void*>&self.tElectronPt15IdIsoVtxOverlap_value)

        #print "making tElectronPt15IdVtxOverlap"
        self.tElectronPt15IdVtxOverlap_branch = the_tree.GetBranch("tElectronPt15IdVtxOverlap")
        #if not self.tElectronPt15IdVtxOverlap_branch and "tElectronPt15IdVtxOverlap" not in self.complained:
        if not self.tElectronPt15IdVtxOverlap_branch and "tElectronPt15IdVtxOverlap":
            warnings.warn( "EETauTree: Expected branch tElectronPt15IdVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElectronPt15IdVtxOverlap")
        else:
            self.tElectronPt15IdVtxOverlap_branch.SetAddress(<void*>&self.tElectronPt15IdVtxOverlap_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "EETauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tGenCharge"
        self.tGenCharge_branch = the_tree.GetBranch("tGenCharge")
        #if not self.tGenCharge_branch and "tGenCharge" not in self.complained:
        if not self.tGenCharge_branch and "tGenCharge":
            warnings.warn( "EETauTree: Expected branch tGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenCharge")
        else:
            self.tGenCharge_branch.SetAddress(<void*>&self.tGenCharge_value)

        #print "making tGenDecayMode"
        self.tGenDecayMode_branch = the_tree.GetBranch("tGenDecayMode")
        #if not self.tGenDecayMode_branch and "tGenDecayMode" not in self.complained:
        if not self.tGenDecayMode_branch and "tGenDecayMode":
            warnings.warn( "EETauTree: Expected branch tGenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenDecayMode")
        else:
            self.tGenDecayMode_branch.SetAddress(<void*>&self.tGenDecayMode_value)

        #print "making tGenEnergy"
        self.tGenEnergy_branch = the_tree.GetBranch("tGenEnergy")
        #if not self.tGenEnergy_branch and "tGenEnergy" not in self.complained:
        if not self.tGenEnergy_branch and "tGenEnergy":
            warnings.warn( "EETauTree: Expected branch tGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEnergy")
        else:
            self.tGenEnergy_branch.SetAddress(<void*>&self.tGenEnergy_value)

        #print "making tGenEta"
        self.tGenEta_branch = the_tree.GetBranch("tGenEta")
        #if not self.tGenEta_branch and "tGenEta" not in self.complained:
        if not self.tGenEta_branch and "tGenEta":
            warnings.warn( "EETauTree: Expected branch tGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEta")
        else:
            self.tGenEta_branch.SetAddress(<void*>&self.tGenEta_value)

        #print "making tGenMotherEnergy"
        self.tGenMotherEnergy_branch = the_tree.GetBranch("tGenMotherEnergy")
        #if not self.tGenMotherEnergy_branch and "tGenMotherEnergy" not in self.complained:
        if not self.tGenMotherEnergy_branch and "tGenMotherEnergy":
            warnings.warn( "EETauTree: Expected branch tGenMotherEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEnergy")
        else:
            self.tGenMotherEnergy_branch.SetAddress(<void*>&self.tGenMotherEnergy_value)

        #print "making tGenMotherEta"
        self.tGenMotherEta_branch = the_tree.GetBranch("tGenMotherEta")
        #if not self.tGenMotherEta_branch and "tGenMotherEta" not in self.complained:
        if not self.tGenMotherEta_branch and "tGenMotherEta":
            warnings.warn( "EETauTree: Expected branch tGenMotherEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEta")
        else:
            self.tGenMotherEta_branch.SetAddress(<void*>&self.tGenMotherEta_value)

        #print "making tGenMotherPdgId"
        self.tGenMotherPdgId_branch = the_tree.GetBranch("tGenMotherPdgId")
        #if not self.tGenMotherPdgId_branch and "tGenMotherPdgId" not in self.complained:
        if not self.tGenMotherPdgId_branch and "tGenMotherPdgId":
            warnings.warn( "EETauTree: Expected branch tGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPdgId")
        else:
            self.tGenMotherPdgId_branch.SetAddress(<void*>&self.tGenMotherPdgId_value)

        #print "making tGenMotherPhi"
        self.tGenMotherPhi_branch = the_tree.GetBranch("tGenMotherPhi")
        #if not self.tGenMotherPhi_branch and "tGenMotherPhi" not in self.complained:
        if not self.tGenMotherPhi_branch and "tGenMotherPhi":
            warnings.warn( "EETauTree: Expected branch tGenMotherPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPhi")
        else:
            self.tGenMotherPhi_branch.SetAddress(<void*>&self.tGenMotherPhi_value)

        #print "making tGenMotherPt"
        self.tGenMotherPt_branch = the_tree.GetBranch("tGenMotherPt")
        #if not self.tGenMotherPt_branch and "tGenMotherPt" not in self.complained:
        if not self.tGenMotherPt_branch and "tGenMotherPt":
            warnings.warn( "EETauTree: Expected branch tGenMotherPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPt")
        else:
            self.tGenMotherPt_branch.SetAddress(<void*>&self.tGenMotherPt_value)

        #print "making tGenPdgId"
        self.tGenPdgId_branch = the_tree.GetBranch("tGenPdgId")
        #if not self.tGenPdgId_branch and "tGenPdgId" not in self.complained:
        if not self.tGenPdgId_branch and "tGenPdgId":
            warnings.warn( "EETauTree: Expected branch tGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPdgId")
        else:
            self.tGenPdgId_branch.SetAddress(<void*>&self.tGenPdgId_value)

        #print "making tGenPhi"
        self.tGenPhi_branch = the_tree.GetBranch("tGenPhi")
        #if not self.tGenPhi_branch and "tGenPhi" not in self.complained:
        if not self.tGenPhi_branch and "tGenPhi":
            warnings.warn( "EETauTree: Expected branch tGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPhi")
        else:
            self.tGenPhi_branch.SetAddress(<void*>&self.tGenPhi_value)

        #print "making tGenPt"
        self.tGenPt_branch = the_tree.GetBranch("tGenPt")
        #if not self.tGenPt_branch and "tGenPt" not in self.complained:
        if not self.tGenPt_branch and "tGenPt":
            warnings.warn( "EETauTree: Expected branch tGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPt")
        else:
            self.tGenPt_branch.SetAddress(<void*>&self.tGenPt_value)

        #print "making tGenPx"
        self.tGenPx_branch = the_tree.GetBranch("tGenPx")
        #if not self.tGenPx_branch and "tGenPx" not in self.complained:
        if not self.tGenPx_branch and "tGenPx":
            warnings.warn( "EETauTree: Expected branch tGenPx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPx")
        else:
            self.tGenPx_branch.SetAddress(<void*>&self.tGenPx_value)

        #print "making tGenPy"
        self.tGenPy_branch = the_tree.GetBranch("tGenPy")
        #if not self.tGenPy_branch and "tGenPy" not in self.complained:
        if not self.tGenPy_branch and "tGenPy":
            warnings.warn( "EETauTree: Expected branch tGenPy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPy")
        else:
            self.tGenPy_branch.SetAddress(<void*>&self.tGenPy_value)

        #print "making tGenPz"
        self.tGenPz_branch = the_tree.GetBranch("tGenPz")
        #if not self.tGenPz_branch and "tGenPz" not in self.complained:
        if not self.tGenPz_branch and "tGenPz":
            warnings.warn( "EETauTree: Expected branch tGenPz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPz")
        else:
            self.tGenPz_branch.SetAddress(<void*>&self.tGenPz_value)

        #print "making tGlobalMuonVtxOverlap"
        self.tGlobalMuonVtxOverlap_branch = the_tree.GetBranch("tGlobalMuonVtxOverlap")
        #if not self.tGlobalMuonVtxOverlap_branch and "tGlobalMuonVtxOverlap" not in self.complained:
        if not self.tGlobalMuonVtxOverlap_branch and "tGlobalMuonVtxOverlap":
            warnings.warn( "EETauTree: Expected branch tGlobalMuonVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGlobalMuonVtxOverlap")
        else:
            self.tGlobalMuonVtxOverlap_branch.SetAddress(<void*>&self.tGlobalMuonVtxOverlap_value)

        #print "making tIP3DS"
        self.tIP3DS_branch = the_tree.GetBranch("tIP3DS")
        #if not self.tIP3DS_branch and "tIP3DS" not in self.complained:
        if not self.tIP3DS_branch and "tIP3DS":
            warnings.warn( "EETauTree: Expected branch tIP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tIP3DS")
        else:
            self.tIP3DS_branch.SetAddress(<void*>&self.tIP3DS_value)

        #print "making tJetArea"
        self.tJetArea_branch = the_tree.GetBranch("tJetArea")
        #if not self.tJetArea_branch and "tJetArea" not in self.complained:
        if not self.tJetArea_branch and "tJetArea":
            warnings.warn( "EETauTree: Expected branch tJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetArea")
        else:
            self.tJetArea_branch.SetAddress(<void*>&self.tJetArea_value)

        #print "making tJetBtag"
        self.tJetBtag_branch = the_tree.GetBranch("tJetBtag")
        #if not self.tJetBtag_branch and "tJetBtag" not in self.complained:
        if not self.tJetBtag_branch and "tJetBtag":
            warnings.warn( "EETauTree: Expected branch tJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetBtag")
        else:
            self.tJetBtag_branch.SetAddress(<void*>&self.tJetBtag_value)

        #print "making tJetCSVBtag"
        self.tJetCSVBtag_branch = the_tree.GetBranch("tJetCSVBtag")
        #if not self.tJetCSVBtag_branch and "tJetCSVBtag" not in self.complained:
        if not self.tJetCSVBtag_branch and "tJetCSVBtag":
            warnings.warn( "EETauTree: Expected branch tJetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetCSVBtag")
        else:
            self.tJetCSVBtag_branch.SetAddress(<void*>&self.tJetCSVBtag_value)

        #print "making tJetEtaEtaMoment"
        self.tJetEtaEtaMoment_branch = the_tree.GetBranch("tJetEtaEtaMoment")
        #if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment" not in self.complained:
        if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment":
            warnings.warn( "EETauTree: Expected branch tJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaEtaMoment")
        else:
            self.tJetEtaEtaMoment_branch.SetAddress(<void*>&self.tJetEtaEtaMoment_value)

        #print "making tJetEtaPhiMoment"
        self.tJetEtaPhiMoment_branch = the_tree.GetBranch("tJetEtaPhiMoment")
        #if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment" not in self.complained:
        if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment":
            warnings.warn( "EETauTree: Expected branch tJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiMoment")
        else:
            self.tJetEtaPhiMoment_branch.SetAddress(<void*>&self.tJetEtaPhiMoment_value)

        #print "making tJetEtaPhiSpread"
        self.tJetEtaPhiSpread_branch = the_tree.GetBranch("tJetEtaPhiSpread")
        #if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread" not in self.complained:
        if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread":
            warnings.warn( "EETauTree: Expected branch tJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiSpread")
        else:
            self.tJetEtaPhiSpread_branch.SetAddress(<void*>&self.tJetEtaPhiSpread_value)

        #print "making tJetPhiPhiMoment"
        self.tJetPhiPhiMoment_branch = the_tree.GetBranch("tJetPhiPhiMoment")
        #if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment" not in self.complained:
        if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment":
            warnings.warn( "EETauTree: Expected branch tJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPhiPhiMoment")
        else:
            self.tJetPhiPhiMoment_branch.SetAddress(<void*>&self.tJetPhiPhiMoment_value)

        #print "making tJetPt"
        self.tJetPt_branch = the_tree.GetBranch("tJetPt")
        #if not self.tJetPt_branch and "tJetPt" not in self.complained:
        if not self.tJetPt_branch and "tJetPt":
            warnings.warn( "EETauTree: Expected branch tJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPt")
        else:
            self.tJetPt_branch.SetAddress(<void*>&self.tJetPt_value)

        #print "making tJetQGLikelihoodID"
        self.tJetQGLikelihoodID_branch = the_tree.GetBranch("tJetQGLikelihoodID")
        #if not self.tJetQGLikelihoodID_branch and "tJetQGLikelihoodID" not in self.complained:
        if not self.tJetQGLikelihoodID_branch and "tJetQGLikelihoodID":
            warnings.warn( "EETauTree: Expected branch tJetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetQGLikelihoodID")
        else:
            self.tJetQGLikelihoodID_branch.SetAddress(<void*>&self.tJetQGLikelihoodID_value)

        #print "making tJetQGMVAID"
        self.tJetQGMVAID_branch = the_tree.GetBranch("tJetQGMVAID")
        #if not self.tJetQGMVAID_branch and "tJetQGMVAID" not in self.complained:
        if not self.tJetQGMVAID_branch and "tJetQGMVAID":
            warnings.warn( "EETauTree: Expected branch tJetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetQGMVAID")
        else:
            self.tJetQGMVAID_branch.SetAddress(<void*>&self.tJetQGMVAID_value)

        #print "making tLeadTrackPt"
        self.tLeadTrackPt_branch = the_tree.GetBranch("tLeadTrackPt")
        #if not self.tLeadTrackPt_branch and "tLeadTrackPt" not in self.complained:
        if not self.tLeadTrackPt_branch and "tLeadTrackPt":
            warnings.warn( "EETauTree: Expected branch tLeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLeadTrackPt")
        else:
            self.tLeadTrackPt_branch.SetAddress(<void*>&self.tLeadTrackPt_value)

        #print "making tLooseIso"
        self.tLooseIso_branch = the_tree.GetBranch("tLooseIso")
        #if not self.tLooseIso_branch and "tLooseIso" not in self.complained:
        if not self.tLooseIso_branch and "tLooseIso":
            warnings.warn( "EETauTree: Expected branch tLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIso")
        else:
            self.tLooseIso_branch.SetAddress(<void*>&self.tLooseIso_value)

        #print "making tLooseIso3Hits"
        self.tLooseIso3Hits_branch = the_tree.GetBranch("tLooseIso3Hits")
        #if not self.tLooseIso3Hits_branch and "tLooseIso3Hits" not in self.complained:
        if not self.tLooseIso3Hits_branch and "tLooseIso3Hits":
            warnings.warn( "EETauTree: Expected branch tLooseIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIso3Hits")
        else:
            self.tLooseIso3Hits_branch.SetAddress(<void*>&self.tLooseIso3Hits_value)

        #print "making tLooseIsoMVA3NewDMLT"
        self.tLooseIsoMVA3NewDMLT_branch = the_tree.GetBranch("tLooseIsoMVA3NewDMLT")
        #if not self.tLooseIsoMVA3NewDMLT_branch and "tLooseIsoMVA3NewDMLT" not in self.complained:
        if not self.tLooseIsoMVA3NewDMLT_branch and "tLooseIsoMVA3NewDMLT":
            warnings.warn( "EETauTree: Expected branch tLooseIsoMVA3NewDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIsoMVA3NewDMLT")
        else:
            self.tLooseIsoMVA3NewDMLT_branch.SetAddress(<void*>&self.tLooseIsoMVA3NewDMLT_value)

        #print "making tLooseIsoMVA3NewDMNoLT"
        self.tLooseIsoMVA3NewDMNoLT_branch = the_tree.GetBranch("tLooseIsoMVA3NewDMNoLT")
        #if not self.tLooseIsoMVA3NewDMNoLT_branch and "tLooseIsoMVA3NewDMNoLT" not in self.complained:
        if not self.tLooseIsoMVA3NewDMNoLT_branch and "tLooseIsoMVA3NewDMNoLT":
            warnings.warn( "EETauTree: Expected branch tLooseIsoMVA3NewDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIsoMVA3NewDMNoLT")
        else:
            self.tLooseIsoMVA3NewDMNoLT_branch.SetAddress(<void*>&self.tLooseIsoMVA3NewDMNoLT_value)

        #print "making tLooseIsoMVA3OldDMLT"
        self.tLooseIsoMVA3OldDMLT_branch = the_tree.GetBranch("tLooseIsoMVA3OldDMLT")
        #if not self.tLooseIsoMVA3OldDMLT_branch and "tLooseIsoMVA3OldDMLT" not in self.complained:
        if not self.tLooseIsoMVA3OldDMLT_branch and "tLooseIsoMVA3OldDMLT":
            warnings.warn( "EETauTree: Expected branch tLooseIsoMVA3OldDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIsoMVA3OldDMLT")
        else:
            self.tLooseIsoMVA3OldDMLT_branch.SetAddress(<void*>&self.tLooseIsoMVA3OldDMLT_value)

        #print "making tLooseIsoMVA3OldDMNoLT"
        self.tLooseIsoMVA3OldDMNoLT_branch = the_tree.GetBranch("tLooseIsoMVA3OldDMNoLT")
        #if not self.tLooseIsoMVA3OldDMNoLT_branch and "tLooseIsoMVA3OldDMNoLT" not in self.complained:
        if not self.tLooseIsoMVA3OldDMNoLT_branch and "tLooseIsoMVA3OldDMNoLT":
            warnings.warn( "EETauTree: Expected branch tLooseIsoMVA3OldDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIsoMVA3OldDMNoLT")
        else:
            self.tLooseIsoMVA3OldDMNoLT_branch.SetAddress(<void*>&self.tLooseIsoMVA3OldDMNoLT_value)

        #print "making tMass"
        self.tMass_branch = the_tree.GetBranch("tMass")
        #if not self.tMass_branch and "tMass" not in self.complained:
        if not self.tMass_branch and "tMass":
            warnings.warn( "EETauTree: Expected branch tMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass")
        else:
            self.tMass_branch.SetAddress(<void*>&self.tMass_value)

        #print "making tMediumIso"
        self.tMediumIso_branch = the_tree.GetBranch("tMediumIso")
        #if not self.tMediumIso_branch and "tMediumIso" not in self.complained:
        if not self.tMediumIso_branch and "tMediumIso":
            warnings.warn( "EETauTree: Expected branch tMediumIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIso")
        else:
            self.tMediumIso_branch.SetAddress(<void*>&self.tMediumIso_value)

        #print "making tMediumIso3Hits"
        self.tMediumIso3Hits_branch = the_tree.GetBranch("tMediumIso3Hits")
        #if not self.tMediumIso3Hits_branch and "tMediumIso3Hits" not in self.complained:
        if not self.tMediumIso3Hits_branch and "tMediumIso3Hits":
            warnings.warn( "EETauTree: Expected branch tMediumIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIso3Hits")
        else:
            self.tMediumIso3Hits_branch.SetAddress(<void*>&self.tMediumIso3Hits_value)

        #print "making tMediumIsoMVA3NewDMLT"
        self.tMediumIsoMVA3NewDMLT_branch = the_tree.GetBranch("tMediumIsoMVA3NewDMLT")
        #if not self.tMediumIsoMVA3NewDMLT_branch and "tMediumIsoMVA3NewDMLT" not in self.complained:
        if not self.tMediumIsoMVA3NewDMLT_branch and "tMediumIsoMVA3NewDMLT":
            warnings.warn( "EETauTree: Expected branch tMediumIsoMVA3NewDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIsoMVA3NewDMLT")
        else:
            self.tMediumIsoMVA3NewDMLT_branch.SetAddress(<void*>&self.tMediumIsoMVA3NewDMLT_value)

        #print "making tMediumIsoMVA3NewDMNoLT"
        self.tMediumIsoMVA3NewDMNoLT_branch = the_tree.GetBranch("tMediumIsoMVA3NewDMNoLT")
        #if not self.tMediumIsoMVA3NewDMNoLT_branch and "tMediumIsoMVA3NewDMNoLT" not in self.complained:
        if not self.tMediumIsoMVA3NewDMNoLT_branch and "tMediumIsoMVA3NewDMNoLT":
            warnings.warn( "EETauTree: Expected branch tMediumIsoMVA3NewDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIsoMVA3NewDMNoLT")
        else:
            self.tMediumIsoMVA3NewDMNoLT_branch.SetAddress(<void*>&self.tMediumIsoMVA3NewDMNoLT_value)

        #print "making tMediumIsoMVA3OldDMLT"
        self.tMediumIsoMVA3OldDMLT_branch = the_tree.GetBranch("tMediumIsoMVA3OldDMLT")
        #if not self.tMediumIsoMVA3OldDMLT_branch and "tMediumIsoMVA3OldDMLT" not in self.complained:
        if not self.tMediumIsoMVA3OldDMLT_branch and "tMediumIsoMVA3OldDMLT":
            warnings.warn( "EETauTree: Expected branch tMediumIsoMVA3OldDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIsoMVA3OldDMLT")
        else:
            self.tMediumIsoMVA3OldDMLT_branch.SetAddress(<void*>&self.tMediumIsoMVA3OldDMLT_value)

        #print "making tMediumIsoMVA3OldDMNoLT"
        self.tMediumIsoMVA3OldDMNoLT_branch = the_tree.GetBranch("tMediumIsoMVA3OldDMNoLT")
        #if not self.tMediumIsoMVA3OldDMNoLT_branch and "tMediumIsoMVA3OldDMNoLT" not in self.complained:
        if not self.tMediumIsoMVA3OldDMNoLT_branch and "tMediumIsoMVA3OldDMNoLT":
            warnings.warn( "EETauTree: Expected branch tMediumIsoMVA3OldDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIsoMVA3OldDMNoLT")
        else:
            self.tMediumIsoMVA3OldDMNoLT_branch.SetAddress(<void*>&self.tMediumIsoMVA3OldDMNoLT_value)

        #print "making tMtToMET"
        self.tMtToMET_branch = the_tree.GetBranch("tMtToMET")
        #if not self.tMtToMET_branch and "tMtToMET" not in self.complained:
        if not self.tMtToMET_branch and "tMtToMET":
            warnings.warn( "EETauTree: Expected branch tMtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToMET")
        else:
            self.tMtToMET_branch.SetAddress(<void*>&self.tMtToMET_value)

        #print "making tMtToMVAMET"
        self.tMtToMVAMET_branch = the_tree.GetBranch("tMtToMVAMET")
        #if not self.tMtToMVAMET_branch and "tMtToMVAMET" not in self.complained:
        if not self.tMtToMVAMET_branch and "tMtToMVAMET":
            warnings.warn( "EETauTree: Expected branch tMtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToMVAMET")
        else:
            self.tMtToMVAMET_branch.SetAddress(<void*>&self.tMtToMVAMET_value)

        #print "making tMtToPfMet"
        self.tMtToPfMet_branch = the_tree.GetBranch("tMtToPfMet")
        #if not self.tMtToPfMet_branch and "tMtToPfMet" not in self.complained:
        if not self.tMtToPfMet_branch and "tMtToPfMet":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet")
        else:
            self.tMtToPfMet_branch.SetAddress(<void*>&self.tMtToPfMet_value)

        #print "making tMtToPfMet_Ty1"
        self.tMtToPfMet_Ty1_branch = the_tree.GetBranch("tMtToPfMet_Ty1")
        #if not self.tMtToPfMet_Ty1_branch and "tMtToPfMet_Ty1" not in self.complained:
        if not self.tMtToPfMet_Ty1_branch and "tMtToPfMet_Ty1":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_Ty1")
        else:
            self.tMtToPfMet_Ty1_branch.SetAddress(<void*>&self.tMtToPfMet_Ty1_value)

        #print "making tMtToPfMet_ees"
        self.tMtToPfMet_ees_branch = the_tree.GetBranch("tMtToPfMet_ees")
        #if not self.tMtToPfMet_ees_branch and "tMtToPfMet_ees" not in self.complained:
        if not self.tMtToPfMet_ees_branch and "tMtToPfMet_ees":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_ees does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ees")
        else:
            self.tMtToPfMet_ees_branch.SetAddress(<void*>&self.tMtToPfMet_ees_value)

        #print "making tMtToPfMet_ees_minus"
        self.tMtToPfMet_ees_minus_branch = the_tree.GetBranch("tMtToPfMet_ees_minus")
        #if not self.tMtToPfMet_ees_minus_branch and "tMtToPfMet_ees_minus" not in self.complained:
        if not self.tMtToPfMet_ees_minus_branch and "tMtToPfMet_ees_minus":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ees_minus")
        else:
            self.tMtToPfMet_ees_minus_branch.SetAddress(<void*>&self.tMtToPfMet_ees_minus_value)

        #print "making tMtToPfMet_ees_plus"
        self.tMtToPfMet_ees_plus_branch = the_tree.GetBranch("tMtToPfMet_ees_plus")
        #if not self.tMtToPfMet_ees_plus_branch and "tMtToPfMet_ees_plus" not in self.complained:
        if not self.tMtToPfMet_ees_plus_branch and "tMtToPfMet_ees_plus":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ees_plus")
        else:
            self.tMtToPfMet_ees_plus_branch.SetAddress(<void*>&self.tMtToPfMet_ees_plus_value)

        #print "making tMtToPfMet_jes"
        self.tMtToPfMet_jes_branch = the_tree.GetBranch("tMtToPfMet_jes")
        #if not self.tMtToPfMet_jes_branch and "tMtToPfMet_jes" not in self.complained:
        if not self.tMtToPfMet_jes_branch and "tMtToPfMet_jes":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_jes")
        else:
            self.tMtToPfMet_jes_branch.SetAddress(<void*>&self.tMtToPfMet_jes_value)

        #print "making tMtToPfMet_jes_minus"
        self.tMtToPfMet_jes_minus_branch = the_tree.GetBranch("tMtToPfMet_jes_minus")
        #if not self.tMtToPfMet_jes_minus_branch and "tMtToPfMet_jes_minus" not in self.complained:
        if not self.tMtToPfMet_jes_minus_branch and "tMtToPfMet_jes_minus":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_jes_minus")
        else:
            self.tMtToPfMet_jes_minus_branch.SetAddress(<void*>&self.tMtToPfMet_jes_minus_value)

        #print "making tMtToPfMet_jes_plus"
        self.tMtToPfMet_jes_plus_branch = the_tree.GetBranch("tMtToPfMet_jes_plus")
        #if not self.tMtToPfMet_jes_plus_branch and "tMtToPfMet_jes_plus" not in self.complained:
        if not self.tMtToPfMet_jes_plus_branch and "tMtToPfMet_jes_plus":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_jes_plus")
        else:
            self.tMtToPfMet_jes_plus_branch.SetAddress(<void*>&self.tMtToPfMet_jes_plus_value)

        #print "making tMtToPfMet_mes"
        self.tMtToPfMet_mes_branch = the_tree.GetBranch("tMtToPfMet_mes")
        #if not self.tMtToPfMet_mes_branch and "tMtToPfMet_mes" not in self.complained:
        if not self.tMtToPfMet_mes_branch and "tMtToPfMet_mes":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_mes")
        else:
            self.tMtToPfMet_mes_branch.SetAddress(<void*>&self.tMtToPfMet_mes_value)

        #print "making tMtToPfMet_mes_minus"
        self.tMtToPfMet_mes_minus_branch = the_tree.GetBranch("tMtToPfMet_mes_minus")
        #if not self.tMtToPfMet_mes_minus_branch and "tMtToPfMet_mes_minus" not in self.complained:
        if not self.tMtToPfMet_mes_minus_branch and "tMtToPfMet_mes_minus":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_mes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_mes_minus")
        else:
            self.tMtToPfMet_mes_minus_branch.SetAddress(<void*>&self.tMtToPfMet_mes_minus_value)

        #print "making tMtToPfMet_mes_plus"
        self.tMtToPfMet_mes_plus_branch = the_tree.GetBranch("tMtToPfMet_mes_plus")
        #if not self.tMtToPfMet_mes_plus_branch and "tMtToPfMet_mes_plus" not in self.complained:
        if not self.tMtToPfMet_mes_plus_branch and "tMtToPfMet_mes_plus":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_mes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_mes_plus")
        else:
            self.tMtToPfMet_mes_plus_branch.SetAddress(<void*>&self.tMtToPfMet_mes_plus_value)

        #print "making tMtToPfMet_tes"
        self.tMtToPfMet_tes_branch = the_tree.GetBranch("tMtToPfMet_tes")
        #if not self.tMtToPfMet_tes_branch and "tMtToPfMet_tes" not in self.complained:
        if not self.tMtToPfMet_tes_branch and "tMtToPfMet_tes":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_tes")
        else:
            self.tMtToPfMet_tes_branch.SetAddress(<void*>&self.tMtToPfMet_tes_value)

        #print "making tMtToPfMet_tes_minus"
        self.tMtToPfMet_tes_minus_branch = the_tree.GetBranch("tMtToPfMet_tes_minus")
        #if not self.tMtToPfMet_tes_minus_branch and "tMtToPfMet_tes_minus" not in self.complained:
        if not self.tMtToPfMet_tes_minus_branch and "tMtToPfMet_tes_minus":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_tes_minus")
        else:
            self.tMtToPfMet_tes_minus_branch.SetAddress(<void*>&self.tMtToPfMet_tes_minus_value)

        #print "making tMtToPfMet_tes_plus"
        self.tMtToPfMet_tes_plus_branch = the_tree.GetBranch("tMtToPfMet_tes_plus")
        #if not self.tMtToPfMet_tes_plus_branch and "tMtToPfMet_tes_plus" not in self.complained:
        if not self.tMtToPfMet_tes_plus_branch and "tMtToPfMet_tes_plus":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_tes_plus")
        else:
            self.tMtToPfMet_tes_plus_branch.SetAddress(<void*>&self.tMtToPfMet_tes_plus_value)

        #print "making tMtToPfMet_ues"
        self.tMtToPfMet_ues_branch = the_tree.GetBranch("tMtToPfMet_ues")
        #if not self.tMtToPfMet_ues_branch and "tMtToPfMet_ues" not in self.complained:
        if not self.tMtToPfMet_ues_branch and "tMtToPfMet_ues":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ues")
        else:
            self.tMtToPfMet_ues_branch.SetAddress(<void*>&self.tMtToPfMet_ues_value)

        #print "making tMtToPfMet_ues_minus"
        self.tMtToPfMet_ues_minus_branch = the_tree.GetBranch("tMtToPfMet_ues_minus")
        #if not self.tMtToPfMet_ues_minus_branch and "tMtToPfMet_ues_minus" not in self.complained:
        if not self.tMtToPfMet_ues_minus_branch and "tMtToPfMet_ues_minus":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_ues_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ues_minus")
        else:
            self.tMtToPfMet_ues_minus_branch.SetAddress(<void*>&self.tMtToPfMet_ues_minus_value)

        #print "making tMtToPfMet_ues_plus"
        self.tMtToPfMet_ues_plus_branch = the_tree.GetBranch("tMtToPfMet_ues_plus")
        #if not self.tMtToPfMet_ues_plus_branch and "tMtToPfMet_ues_plus" not in self.complained:
        if not self.tMtToPfMet_ues_plus_branch and "tMtToPfMet_ues_plus":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_ues_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ues_plus")
        else:
            self.tMtToPfMet_ues_plus_branch.SetAddress(<void*>&self.tMtToPfMet_ues_plus_value)

        #print "making tMuOverlap"
        self.tMuOverlap_branch = the_tree.GetBranch("tMuOverlap")
        #if not self.tMuOverlap_branch and "tMuOverlap" not in self.complained:
        if not self.tMuOverlap_branch and "tMuOverlap":
            warnings.warn( "EETauTree: Expected branch tMuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuOverlap")
        else:
            self.tMuOverlap_branch.SetAddress(<void*>&self.tMuOverlap_value)

        #print "making tMuonIdIsoStdVtxOverlap"
        self.tMuonIdIsoStdVtxOverlap_branch = the_tree.GetBranch("tMuonIdIsoStdVtxOverlap")
        #if not self.tMuonIdIsoStdVtxOverlap_branch and "tMuonIdIsoStdVtxOverlap" not in self.complained:
        if not self.tMuonIdIsoStdVtxOverlap_branch and "tMuonIdIsoStdVtxOverlap":
            warnings.warn( "EETauTree: Expected branch tMuonIdIsoStdVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuonIdIsoStdVtxOverlap")
        else:
            self.tMuonIdIsoStdVtxOverlap_branch.SetAddress(<void*>&self.tMuonIdIsoStdVtxOverlap_value)

        #print "making tMuonIdIsoVtxOverlap"
        self.tMuonIdIsoVtxOverlap_branch = the_tree.GetBranch("tMuonIdIsoVtxOverlap")
        #if not self.tMuonIdIsoVtxOverlap_branch and "tMuonIdIsoVtxOverlap" not in self.complained:
        if not self.tMuonIdIsoVtxOverlap_branch and "tMuonIdIsoVtxOverlap":
            warnings.warn( "EETauTree: Expected branch tMuonIdIsoVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuonIdIsoVtxOverlap")
        else:
            self.tMuonIdIsoVtxOverlap_branch.SetAddress(<void*>&self.tMuonIdIsoVtxOverlap_value)

        #print "making tMuonIdVtxOverlap"
        self.tMuonIdVtxOverlap_branch = the_tree.GetBranch("tMuonIdVtxOverlap")
        #if not self.tMuonIdVtxOverlap_branch and "tMuonIdVtxOverlap" not in self.complained:
        if not self.tMuonIdVtxOverlap_branch and "tMuonIdVtxOverlap":
            warnings.warn( "EETauTree: Expected branch tMuonIdVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuonIdVtxOverlap")
        else:
            self.tMuonIdVtxOverlap_branch.SetAddress(<void*>&self.tMuonIdVtxOverlap_value)

        #print "making tPhi"
        self.tPhi_branch = the_tree.GetBranch("tPhi")
        #if not self.tPhi_branch and "tPhi" not in self.complained:
        if not self.tPhi_branch and "tPhi":
            warnings.warn( "EETauTree: Expected branch tPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi")
        else:
            self.tPhi_branch.SetAddress(<void*>&self.tPhi_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "EETauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tPt_ees_minus"
        self.tPt_ees_minus_branch = the_tree.GetBranch("tPt_ees_minus")
        #if not self.tPt_ees_minus_branch and "tPt_ees_minus" not in self.complained:
        if not self.tPt_ees_minus_branch and "tPt_ees_minus":
            warnings.warn( "EETauTree: Expected branch tPt_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt_ees_minus")
        else:
            self.tPt_ees_minus_branch.SetAddress(<void*>&self.tPt_ees_minus_value)

        #print "making tPt_ees_plus"
        self.tPt_ees_plus_branch = the_tree.GetBranch("tPt_ees_plus")
        #if not self.tPt_ees_plus_branch and "tPt_ees_plus" not in self.complained:
        if not self.tPt_ees_plus_branch and "tPt_ees_plus":
            warnings.warn( "EETauTree: Expected branch tPt_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt_ees_plus")
        else:
            self.tPt_ees_plus_branch.SetAddress(<void*>&self.tPt_ees_plus_value)

        #print "making tPt_tes_minus"
        self.tPt_tes_minus_branch = the_tree.GetBranch("tPt_tes_minus")
        #if not self.tPt_tes_minus_branch and "tPt_tes_minus" not in self.complained:
        if not self.tPt_tes_minus_branch and "tPt_tes_minus":
            warnings.warn( "EETauTree: Expected branch tPt_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt_tes_minus")
        else:
            self.tPt_tes_minus_branch.SetAddress(<void*>&self.tPt_tes_minus_value)

        #print "making tPt_tes_plus"
        self.tPt_tes_plus_branch = the_tree.GetBranch("tPt_tes_plus")
        #if not self.tPt_tes_plus_branch and "tPt_tes_plus" not in self.complained:
        if not self.tPt_tes_plus_branch and "tPt_tes_plus":
            warnings.warn( "EETauTree: Expected branch tPt_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt_tes_plus")
        else:
            self.tPt_tes_plus_branch.SetAddress(<void*>&self.tPt_tes_plus_value)

        #print "making tRank"
        self.tRank_branch = the_tree.GetBranch("tRank")
        #if not self.tRank_branch and "tRank" not in self.complained:
        if not self.tRank_branch and "tRank":
            warnings.warn( "EETauTree: Expected branch tRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRank")
        else:
            self.tRank_branch.SetAddress(<void*>&self.tRank_value)

        #print "making tRawIso3Hits"
        self.tRawIso3Hits_branch = the_tree.GetBranch("tRawIso3Hits")
        #if not self.tRawIso3Hits_branch and "tRawIso3Hits" not in self.complained:
        if not self.tRawIso3Hits_branch and "tRawIso3Hits":
            warnings.warn( "EETauTree: Expected branch tRawIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRawIso3Hits")
        else:
            self.tRawIso3Hits_branch.SetAddress(<void*>&self.tRawIso3Hits_value)

        #print "making tTNPId"
        self.tTNPId_branch = the_tree.GetBranch("tTNPId")
        #if not self.tTNPId_branch and "tTNPId" not in self.complained:
        if not self.tTNPId_branch and "tTNPId":
            warnings.warn( "EETauTree: Expected branch tTNPId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTNPId")
        else:
            self.tTNPId_branch.SetAddress(<void*>&self.tTNPId_value)

        #print "making tTightIso"
        self.tTightIso_branch = the_tree.GetBranch("tTightIso")
        #if not self.tTightIso_branch and "tTightIso" not in self.complained:
        if not self.tTightIso_branch and "tTightIso":
            warnings.warn( "EETauTree: Expected branch tTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIso")
        else:
            self.tTightIso_branch.SetAddress(<void*>&self.tTightIso_value)

        #print "making tTightIso3Hits"
        self.tTightIso3Hits_branch = the_tree.GetBranch("tTightIso3Hits")
        #if not self.tTightIso3Hits_branch and "tTightIso3Hits" not in self.complained:
        if not self.tTightIso3Hits_branch and "tTightIso3Hits":
            warnings.warn( "EETauTree: Expected branch tTightIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIso3Hits")
        else:
            self.tTightIso3Hits_branch.SetAddress(<void*>&self.tTightIso3Hits_value)

        #print "making tTightIsoMVA3NewDMLT"
        self.tTightIsoMVA3NewDMLT_branch = the_tree.GetBranch("tTightIsoMVA3NewDMLT")
        #if not self.tTightIsoMVA3NewDMLT_branch and "tTightIsoMVA3NewDMLT" not in self.complained:
        if not self.tTightIsoMVA3NewDMLT_branch and "tTightIsoMVA3NewDMLT":
            warnings.warn( "EETauTree: Expected branch tTightIsoMVA3NewDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIsoMVA3NewDMLT")
        else:
            self.tTightIsoMVA3NewDMLT_branch.SetAddress(<void*>&self.tTightIsoMVA3NewDMLT_value)

        #print "making tTightIsoMVA3NewDMNoLT"
        self.tTightIsoMVA3NewDMNoLT_branch = the_tree.GetBranch("tTightIsoMVA3NewDMNoLT")
        #if not self.tTightIsoMVA3NewDMNoLT_branch and "tTightIsoMVA3NewDMNoLT" not in self.complained:
        if not self.tTightIsoMVA3NewDMNoLT_branch and "tTightIsoMVA3NewDMNoLT":
            warnings.warn( "EETauTree: Expected branch tTightIsoMVA3NewDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIsoMVA3NewDMNoLT")
        else:
            self.tTightIsoMVA3NewDMNoLT_branch.SetAddress(<void*>&self.tTightIsoMVA3NewDMNoLT_value)

        #print "making tTightIsoMVA3OldDMLT"
        self.tTightIsoMVA3OldDMLT_branch = the_tree.GetBranch("tTightIsoMVA3OldDMLT")
        #if not self.tTightIsoMVA3OldDMLT_branch and "tTightIsoMVA3OldDMLT" not in self.complained:
        if not self.tTightIsoMVA3OldDMLT_branch and "tTightIsoMVA3OldDMLT":
            warnings.warn( "EETauTree: Expected branch tTightIsoMVA3OldDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIsoMVA3OldDMLT")
        else:
            self.tTightIsoMVA3OldDMLT_branch.SetAddress(<void*>&self.tTightIsoMVA3OldDMLT_value)

        #print "making tTightIsoMVA3OldDMNoLT"
        self.tTightIsoMVA3OldDMNoLT_branch = the_tree.GetBranch("tTightIsoMVA3OldDMNoLT")
        #if not self.tTightIsoMVA3OldDMNoLT_branch and "tTightIsoMVA3OldDMNoLT" not in self.complained:
        if not self.tTightIsoMVA3OldDMNoLT_branch and "tTightIsoMVA3OldDMNoLT":
            warnings.warn( "EETauTree: Expected branch tTightIsoMVA3OldDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIsoMVA3OldDMNoLT")
        else:
            self.tTightIsoMVA3OldDMNoLT_branch.SetAddress(<void*>&self.tTightIsoMVA3OldDMNoLT_value)

        #print "making tToMETDPhi"
        self.tToMETDPhi_branch = the_tree.GetBranch("tToMETDPhi")
        #if not self.tToMETDPhi_branch and "tToMETDPhi" not in self.complained:
        if not self.tToMETDPhi_branch and "tToMETDPhi":
            warnings.warn( "EETauTree: Expected branch tToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tToMETDPhi")
        else:
            self.tToMETDPhi_branch.SetAddress(<void*>&self.tToMETDPhi_value)

        #print "making tVLooseIso"
        self.tVLooseIso_branch = the_tree.GetBranch("tVLooseIso")
        #if not self.tVLooseIso_branch and "tVLooseIso" not in self.complained:
        if not self.tVLooseIso_branch and "tVLooseIso":
            warnings.warn( "EETauTree: Expected branch tVLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIso")
        else:
            self.tVLooseIso_branch.SetAddress(<void*>&self.tVLooseIso_value)

        #print "making tVLooseIsoMVA3NewDMLT"
        self.tVLooseIsoMVA3NewDMLT_branch = the_tree.GetBranch("tVLooseIsoMVA3NewDMLT")
        #if not self.tVLooseIsoMVA3NewDMLT_branch and "tVLooseIsoMVA3NewDMLT" not in self.complained:
        if not self.tVLooseIsoMVA3NewDMLT_branch and "tVLooseIsoMVA3NewDMLT":
            warnings.warn( "EETauTree: Expected branch tVLooseIsoMVA3NewDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIsoMVA3NewDMLT")
        else:
            self.tVLooseIsoMVA3NewDMLT_branch.SetAddress(<void*>&self.tVLooseIsoMVA3NewDMLT_value)

        #print "making tVLooseIsoMVA3NewDMNoLT"
        self.tVLooseIsoMVA3NewDMNoLT_branch = the_tree.GetBranch("tVLooseIsoMVA3NewDMNoLT")
        #if not self.tVLooseIsoMVA3NewDMNoLT_branch and "tVLooseIsoMVA3NewDMNoLT" not in self.complained:
        if not self.tVLooseIsoMVA3NewDMNoLT_branch and "tVLooseIsoMVA3NewDMNoLT":
            warnings.warn( "EETauTree: Expected branch tVLooseIsoMVA3NewDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIsoMVA3NewDMNoLT")
        else:
            self.tVLooseIsoMVA3NewDMNoLT_branch.SetAddress(<void*>&self.tVLooseIsoMVA3NewDMNoLT_value)

        #print "making tVLooseIsoMVA3OldDMLT"
        self.tVLooseIsoMVA3OldDMLT_branch = the_tree.GetBranch("tVLooseIsoMVA3OldDMLT")
        #if not self.tVLooseIsoMVA3OldDMLT_branch and "tVLooseIsoMVA3OldDMLT" not in self.complained:
        if not self.tVLooseIsoMVA3OldDMLT_branch and "tVLooseIsoMVA3OldDMLT":
            warnings.warn( "EETauTree: Expected branch tVLooseIsoMVA3OldDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIsoMVA3OldDMLT")
        else:
            self.tVLooseIsoMVA3OldDMLT_branch.SetAddress(<void*>&self.tVLooseIsoMVA3OldDMLT_value)

        #print "making tVLooseIsoMVA3OldDMNoLT"
        self.tVLooseIsoMVA3OldDMNoLT_branch = the_tree.GetBranch("tVLooseIsoMVA3OldDMNoLT")
        #if not self.tVLooseIsoMVA3OldDMNoLT_branch and "tVLooseIsoMVA3OldDMNoLT" not in self.complained:
        if not self.tVLooseIsoMVA3OldDMNoLT_branch and "tVLooseIsoMVA3OldDMNoLT":
            warnings.warn( "EETauTree: Expected branch tVLooseIsoMVA3OldDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIsoMVA3OldDMNoLT")
        else:
            self.tVLooseIsoMVA3OldDMNoLT_branch.SetAddress(<void*>&self.tVLooseIsoMVA3OldDMNoLT_value)

        #print "making tVTightIsoMVA3NewDMLT"
        self.tVTightIsoMVA3NewDMLT_branch = the_tree.GetBranch("tVTightIsoMVA3NewDMLT")
        #if not self.tVTightIsoMVA3NewDMLT_branch and "tVTightIsoMVA3NewDMLT" not in self.complained:
        if not self.tVTightIsoMVA3NewDMLT_branch and "tVTightIsoMVA3NewDMLT":
            warnings.warn( "EETauTree: Expected branch tVTightIsoMVA3NewDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightIsoMVA3NewDMLT")
        else:
            self.tVTightIsoMVA3NewDMLT_branch.SetAddress(<void*>&self.tVTightIsoMVA3NewDMLT_value)

        #print "making tVTightIsoMVA3NewDMNoLT"
        self.tVTightIsoMVA3NewDMNoLT_branch = the_tree.GetBranch("tVTightIsoMVA3NewDMNoLT")
        #if not self.tVTightIsoMVA3NewDMNoLT_branch and "tVTightIsoMVA3NewDMNoLT" not in self.complained:
        if not self.tVTightIsoMVA3NewDMNoLT_branch and "tVTightIsoMVA3NewDMNoLT":
            warnings.warn( "EETauTree: Expected branch tVTightIsoMVA3NewDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightIsoMVA3NewDMNoLT")
        else:
            self.tVTightIsoMVA3NewDMNoLT_branch.SetAddress(<void*>&self.tVTightIsoMVA3NewDMNoLT_value)

        #print "making tVTightIsoMVA3OldDMLT"
        self.tVTightIsoMVA3OldDMLT_branch = the_tree.GetBranch("tVTightIsoMVA3OldDMLT")
        #if not self.tVTightIsoMVA3OldDMLT_branch and "tVTightIsoMVA3OldDMLT" not in self.complained:
        if not self.tVTightIsoMVA3OldDMLT_branch and "tVTightIsoMVA3OldDMLT":
            warnings.warn( "EETauTree: Expected branch tVTightIsoMVA3OldDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightIsoMVA3OldDMLT")
        else:
            self.tVTightIsoMVA3OldDMLT_branch.SetAddress(<void*>&self.tVTightIsoMVA3OldDMLT_value)

        #print "making tVTightIsoMVA3OldDMNoLT"
        self.tVTightIsoMVA3OldDMNoLT_branch = the_tree.GetBranch("tVTightIsoMVA3OldDMNoLT")
        #if not self.tVTightIsoMVA3OldDMNoLT_branch and "tVTightIsoMVA3OldDMNoLT" not in self.complained:
        if not self.tVTightIsoMVA3OldDMNoLT_branch and "tVTightIsoMVA3OldDMNoLT":
            warnings.warn( "EETauTree: Expected branch tVTightIsoMVA3OldDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightIsoMVA3OldDMNoLT")
        else:
            self.tVTightIsoMVA3OldDMNoLT_branch.SetAddress(<void*>&self.tVTightIsoMVA3OldDMNoLT_value)

        #print "making tVVTightIsoMVA3NewDMLT"
        self.tVVTightIsoMVA3NewDMLT_branch = the_tree.GetBranch("tVVTightIsoMVA3NewDMLT")
        #if not self.tVVTightIsoMVA3NewDMLT_branch and "tVVTightIsoMVA3NewDMLT" not in self.complained:
        if not self.tVVTightIsoMVA3NewDMLT_branch and "tVVTightIsoMVA3NewDMLT":
            warnings.warn( "EETauTree: Expected branch tVVTightIsoMVA3NewDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightIsoMVA3NewDMLT")
        else:
            self.tVVTightIsoMVA3NewDMLT_branch.SetAddress(<void*>&self.tVVTightIsoMVA3NewDMLT_value)

        #print "making tVVTightIsoMVA3NewDMNoLT"
        self.tVVTightIsoMVA3NewDMNoLT_branch = the_tree.GetBranch("tVVTightIsoMVA3NewDMNoLT")
        #if not self.tVVTightIsoMVA3NewDMNoLT_branch and "tVVTightIsoMVA3NewDMNoLT" not in self.complained:
        if not self.tVVTightIsoMVA3NewDMNoLT_branch and "tVVTightIsoMVA3NewDMNoLT":
            warnings.warn( "EETauTree: Expected branch tVVTightIsoMVA3NewDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightIsoMVA3NewDMNoLT")
        else:
            self.tVVTightIsoMVA3NewDMNoLT_branch.SetAddress(<void*>&self.tVVTightIsoMVA3NewDMNoLT_value)

        #print "making tVVTightIsoMVA3OldDMLT"
        self.tVVTightIsoMVA3OldDMLT_branch = the_tree.GetBranch("tVVTightIsoMVA3OldDMLT")
        #if not self.tVVTightIsoMVA3OldDMLT_branch and "tVVTightIsoMVA3OldDMLT" not in self.complained:
        if not self.tVVTightIsoMVA3OldDMLT_branch and "tVVTightIsoMVA3OldDMLT":
            warnings.warn( "EETauTree: Expected branch tVVTightIsoMVA3OldDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightIsoMVA3OldDMLT")
        else:
            self.tVVTightIsoMVA3OldDMLT_branch.SetAddress(<void*>&self.tVVTightIsoMVA3OldDMLT_value)

        #print "making tVVTightIsoMVA3OldDMNoLT"
        self.tVVTightIsoMVA3OldDMNoLT_branch = the_tree.GetBranch("tVVTightIsoMVA3OldDMNoLT")
        #if not self.tVVTightIsoMVA3OldDMNoLT_branch and "tVVTightIsoMVA3OldDMNoLT" not in self.complained:
        if not self.tVVTightIsoMVA3OldDMNoLT_branch and "tVVTightIsoMVA3OldDMNoLT":
            warnings.warn( "EETauTree: Expected branch tVVTightIsoMVA3OldDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightIsoMVA3OldDMNoLT")
        else:
            self.tVVTightIsoMVA3OldDMNoLT_branch.SetAddress(<void*>&self.tVVTightIsoMVA3OldDMNoLT_value)

        #print "making tVZ"
        self.tVZ_branch = the_tree.GetBranch("tVZ")
        #if not self.tVZ_branch and "tVZ" not in self.complained:
        if not self.tVZ_branch and "tVZ":
            warnings.warn( "EETauTree: Expected branch tVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVZ")
        else:
            self.tVZ_branch.SetAddress(<void*>&self.tVZ_value)

        #print "making tauVetoPt20EleLoose3MuTight"
        self.tauVetoPt20EleLoose3MuTight_branch = the_tree.GetBranch("tauVetoPt20EleLoose3MuTight")
        #if not self.tauVetoPt20EleLoose3MuTight_branch and "tauVetoPt20EleLoose3MuTight" not in self.complained:
        if not self.tauVetoPt20EleLoose3MuTight_branch and "tauVetoPt20EleLoose3MuTight":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20EleLoose3MuTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20EleLoose3MuTight")
        else:
            self.tauVetoPt20EleLoose3MuTight_branch.SetAddress(<void*>&self.tauVetoPt20EleLoose3MuTight_value)

        #print "making tauVetoPt20EleLoose3MuTight_tes_minus"
        self.tauVetoPt20EleLoose3MuTight_tes_minus_branch = the_tree.GetBranch("tauVetoPt20EleLoose3MuTight_tes_minus")
        #if not self.tauVetoPt20EleLoose3MuTight_tes_minus_branch and "tauVetoPt20EleLoose3MuTight_tes_minus" not in self.complained:
        if not self.tauVetoPt20EleLoose3MuTight_tes_minus_branch and "tauVetoPt20EleLoose3MuTight_tes_minus":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20EleLoose3MuTight_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20EleLoose3MuTight_tes_minus")
        else:
            self.tauVetoPt20EleLoose3MuTight_tes_minus_branch.SetAddress(<void*>&self.tauVetoPt20EleLoose3MuTight_tes_minus_value)

        #print "making tauVetoPt20EleLoose3MuTight_tes_plus"
        self.tauVetoPt20EleLoose3MuTight_tes_plus_branch = the_tree.GetBranch("tauVetoPt20EleLoose3MuTight_tes_plus")
        #if not self.tauVetoPt20EleLoose3MuTight_tes_plus_branch and "tauVetoPt20EleLoose3MuTight_tes_plus" not in self.complained:
        if not self.tauVetoPt20EleLoose3MuTight_tes_plus_branch and "tauVetoPt20EleLoose3MuTight_tes_plus":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20EleLoose3MuTight_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20EleLoose3MuTight_tes_plus")
        else:
            self.tauVetoPt20EleLoose3MuTight_tes_plus_branch.SetAddress(<void*>&self.tauVetoPt20EleLoose3MuTight_tes_plus_value)

        #print "making tauVetoPt20EleTight3MuLoose"
        self.tauVetoPt20EleTight3MuLoose_branch = the_tree.GetBranch("tauVetoPt20EleTight3MuLoose")
        #if not self.tauVetoPt20EleTight3MuLoose_branch and "tauVetoPt20EleTight3MuLoose" not in self.complained:
        if not self.tauVetoPt20EleTight3MuLoose_branch and "tauVetoPt20EleTight3MuLoose":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20EleTight3MuLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20EleTight3MuLoose")
        else:
            self.tauVetoPt20EleTight3MuLoose_branch.SetAddress(<void*>&self.tauVetoPt20EleTight3MuLoose_value)

        #print "making tauVetoPt20EleTight3MuLoose_tes_minus"
        self.tauVetoPt20EleTight3MuLoose_tes_minus_branch = the_tree.GetBranch("tauVetoPt20EleTight3MuLoose_tes_minus")
        #if not self.tauVetoPt20EleTight3MuLoose_tes_minus_branch and "tauVetoPt20EleTight3MuLoose_tes_minus" not in self.complained:
        if not self.tauVetoPt20EleTight3MuLoose_tes_minus_branch and "tauVetoPt20EleTight3MuLoose_tes_minus":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20EleTight3MuLoose_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20EleTight3MuLoose_tes_minus")
        else:
            self.tauVetoPt20EleTight3MuLoose_tes_minus_branch.SetAddress(<void*>&self.tauVetoPt20EleTight3MuLoose_tes_minus_value)

        #print "making tauVetoPt20EleTight3MuLoose_tes_plus"
        self.tauVetoPt20EleTight3MuLoose_tes_plus_branch = the_tree.GetBranch("tauVetoPt20EleTight3MuLoose_tes_plus")
        #if not self.tauVetoPt20EleTight3MuLoose_tes_plus_branch and "tauVetoPt20EleTight3MuLoose_tes_plus" not in self.complained:
        if not self.tauVetoPt20EleTight3MuLoose_tes_plus_branch and "tauVetoPt20EleTight3MuLoose_tes_plus":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20EleTight3MuLoose_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20EleTight3MuLoose_tes_plus")
        else:
            self.tauVetoPt20EleTight3MuLoose_tes_plus_branch.SetAddress(<void*>&self.tauVetoPt20EleTight3MuLoose_tes_plus_value)

        #print "making tauVetoPt20Loose3HitsNewDMVtx"
        self.tauVetoPt20Loose3HitsNewDMVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsNewDMVtx")
        #if not self.tauVetoPt20Loose3HitsNewDMVtx_branch and "tauVetoPt20Loose3HitsNewDMVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsNewDMVtx_branch and "tauVetoPt20Loose3HitsNewDMVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20Loose3HitsNewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsNewDMVtx")
        else:
            self.tauVetoPt20Loose3HitsNewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsNewDMVtx_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20TightMVALTNewDMVtx"
        self.tauVetoPt20TightMVALTNewDMVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTNewDMVtx")
        #if not self.tauVetoPt20TightMVALTNewDMVtx_branch and "tauVetoPt20TightMVALTNewDMVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTNewDMVtx_branch and "tauVetoPt20TightMVALTNewDMVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20TightMVALTNewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTNewDMVtx")
        else:
            self.tauVetoPt20TightMVALTNewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTNewDMVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making tauVetoPt20TightMVANewDMVtx"
        self.tauVetoPt20TightMVANewDMVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVANewDMVtx")
        #if not self.tauVetoPt20TightMVANewDMVtx_branch and "tauVetoPt20TightMVANewDMVtx" not in self.complained:
        if not self.tauVetoPt20TightMVANewDMVtx_branch and "tauVetoPt20TightMVANewDMVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20TightMVANewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVANewDMVtx")
        else:
            self.tauVetoPt20TightMVANewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVANewDMVtx_value)

        #print "making tauVetoPt20TightMVAVtx"
        self.tauVetoPt20TightMVAVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVAVtx")
        #if not self.tauVetoPt20TightMVAVtx_branch and "tauVetoPt20TightMVAVtx" not in self.complained:
        if not self.tauVetoPt20TightMVAVtx_branch and "tauVetoPt20TightMVAVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20TightMVAVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVAVtx")
        else:
            self.tauVetoPt20TightMVAVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVAVtx_value)

        #print "making tauVetoPt20VLooseHPSNewDMVtx"
        self.tauVetoPt20VLooseHPSNewDMVtx_branch = the_tree.GetBranch("tauVetoPt20VLooseHPSNewDMVtx")
        #if not self.tauVetoPt20VLooseHPSNewDMVtx_branch and "tauVetoPt20VLooseHPSNewDMVtx" not in self.complained:
        if not self.tauVetoPt20VLooseHPSNewDMVtx_branch and "tauVetoPt20VLooseHPSNewDMVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20VLooseHPSNewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20VLooseHPSNewDMVtx")
        else:
            self.tauVetoPt20VLooseHPSNewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20VLooseHPSNewDMVtx_value)

        #print "making tauVetoPt20VLooseHPSVtx"
        self.tauVetoPt20VLooseHPSVtx_branch = the_tree.GetBranch("tauVetoPt20VLooseHPSVtx")
        #if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx" not in self.complained:
        if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20VLooseHPSVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20VLooseHPSVtx")
        else:
            self.tauVetoPt20VLooseHPSVtx_branch.SetAddress(<void*>&self.tauVetoPt20VLooseHPSVtx_value)

        #print "making tripleEGroup"
        self.tripleEGroup_branch = the_tree.GetBranch("tripleEGroup")
        #if not self.tripleEGroup_branch and "tripleEGroup" not in self.complained:
        if not self.tripleEGroup_branch and "tripleEGroup":
            warnings.warn( "EETauTree: Expected branch tripleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEGroup")
        else:
            self.tripleEGroup_branch.SetAddress(<void*>&self.tripleEGroup_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "EETauTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleEPrescale"
        self.tripleEPrescale_branch = the_tree.GetBranch("tripleEPrescale")
        #if not self.tripleEPrescale_branch and "tripleEPrescale" not in self.complained:
        if not self.tripleEPrescale_branch and "tripleEPrescale":
            warnings.warn( "EETauTree: Expected branch tripleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPrescale")
        else:
            self.tripleEPrescale_branch.SetAddress(<void*>&self.tripleEPrescale_value)

        #print "making type1_pfMet_Et"
        self.type1_pfMet_Et_branch = the_tree.GetBranch("type1_pfMet_Et")
        #if not self.type1_pfMet_Et_branch and "type1_pfMet_Et" not in self.complained:
        if not self.type1_pfMet_Et_branch and "type1_pfMet_Et":
            warnings.warn( "EETauTree: Expected branch type1_pfMet_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_Et")
        else:
            self.type1_pfMet_Et_branch.SetAddress(<void*>&self.type1_pfMet_Et_value)

        #print "making type1_pfMet_Et_ues_minus"
        self.type1_pfMet_Et_ues_minus_branch = the_tree.GetBranch("type1_pfMet_Et_ues_minus")
        #if not self.type1_pfMet_Et_ues_minus_branch and "type1_pfMet_Et_ues_minus" not in self.complained:
        if not self.type1_pfMet_Et_ues_minus_branch and "type1_pfMet_Et_ues_minus":
            warnings.warn( "EETauTree: Expected branch type1_pfMet_Et_ues_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_Et_ues_minus")
        else:
            self.type1_pfMet_Et_ues_minus_branch.SetAddress(<void*>&self.type1_pfMet_Et_ues_minus_value)

        #print "making type1_pfMet_Et_ues_plus"
        self.type1_pfMet_Et_ues_plus_branch = the_tree.GetBranch("type1_pfMet_Et_ues_plus")
        #if not self.type1_pfMet_Et_ues_plus_branch and "type1_pfMet_Et_ues_plus" not in self.complained:
        if not self.type1_pfMet_Et_ues_plus_branch and "type1_pfMet_Et_ues_plus":
            warnings.warn( "EETauTree: Expected branch type1_pfMet_Et_ues_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_Et_ues_plus")
        else:
            self.type1_pfMet_Et_ues_plus_branch.SetAddress(<void*>&self.type1_pfMet_Et_ues_plus_value)

        #print "making type1_pfMet_Phi"
        self.type1_pfMet_Phi_branch = the_tree.GetBranch("type1_pfMet_Phi")
        #if not self.type1_pfMet_Phi_branch and "type1_pfMet_Phi" not in self.complained:
        if not self.type1_pfMet_Phi_branch and "type1_pfMet_Phi":
            warnings.warn( "EETauTree: Expected branch type1_pfMet_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_Phi")
        else:
            self.type1_pfMet_Phi_branch.SetAddress(<void*>&self.type1_pfMet_Phi_value)

        #print "making type1_pfMet_Pt"
        self.type1_pfMet_Pt_branch = the_tree.GetBranch("type1_pfMet_Pt")
        #if not self.type1_pfMet_Pt_branch and "type1_pfMet_Pt" not in self.complained:
        if not self.type1_pfMet_Pt_branch and "type1_pfMet_Pt":
            warnings.warn( "EETauTree: Expected branch type1_pfMet_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_Pt")
        else:
            self.type1_pfMet_Pt_branch.SetAddress(<void*>&self.type1_pfMet_Pt_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "EETauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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
    property inputfilename:
        def __get__(self):
            return self.tree.GetCurrentFile().GetName()

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

    property NUP:
        def __get__(self):
            self.NUP_branch.GetEntry(self.localentry, 0)
            return self.NUP_value

    property Pt:
        def __get__(self):
            self.Pt_branch.GetEntry(self.localentry, 0)
            return self.Pt_value

    property bjetCSVVeto:
        def __get__(self):
            self.bjetCSVVeto_branch.GetEntry(self.localentry, 0)
            return self.bjetCSVVeto_value

    property bjetCSVVeto30:
        def __get__(self):
            self.bjetCSVVeto30_branch.GetEntry(self.localentry, 0)
            return self.bjetCSVVeto30_value

    property bjetCSVVetoZHLike:
        def __get__(self):
            self.bjetCSVVetoZHLike_branch.GetEntry(self.localentry, 0)
            return self.bjetCSVVetoZHLike_value

    property bjetCSVVetoZHLikeNoJetId:
        def __get__(self):
            self.bjetCSVVetoZHLikeNoJetId_branch.GetEntry(self.localentry, 0)
            return self.bjetCSVVetoZHLikeNoJetId_value

    property bjetVeto:
        def __get__(self):
            self.bjetVeto_branch.GetEntry(self.localentry, 0)
            return self.bjetVeto_value

    property charge:
        def __get__(self):
            self.charge_branch.GetEntry(self.localentry, 0)
            return self.charge_value

    property doubleEExtraGroup:
        def __get__(self):
            self.doubleEExtraGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleEExtraGroup_value

    property doubleEExtraPass:
        def __get__(self):
            self.doubleEExtraPass_branch.GetEntry(self.localentry, 0)
            return self.doubleEExtraPass_value

    property doubleEExtraPrescale:
        def __get__(self):
            self.doubleEExtraPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleEExtraPrescale_value

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

    property doubleETightGroup:
        def __get__(self):
            self.doubleETightGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleETightGroup_value

    property doubleETightPass:
        def __get__(self):
            self.doubleETightPass_branch.GetEntry(self.localentry, 0)
            return self.doubleETightPass_value

    property doubleETightPrescale:
        def __get__(self):
            self.doubleETightPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleETightPrescale_value

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

    property doubleMuTrkGroup:
        def __get__(self):
            self.doubleMuTrkGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleMuTrkGroup_value

    property doubleMuTrkPass:
        def __get__(self):
            self.doubleMuTrkPass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuTrkPass_value

    property doubleMuTrkPrescale:
        def __get__(self):
            self.doubleMuTrkPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleMuTrkPrescale_value

    property doublePhoGroup:
        def __get__(self):
            self.doublePhoGroup_branch.GetEntry(self.localentry, 0)
            return self.doublePhoGroup_value

    property doublePhoPass:
        def __get__(self):
            self.doublePhoPass_branch.GetEntry(self.localentry, 0)
            return self.doublePhoPass_value

    property doublePhoPrescale:
        def __get__(self):
            self.doublePhoPrescale_branch.GetEntry(self.localentry, 0)
            return self.doublePhoPrescale_value

    property e1AbsEta:
        def __get__(self):
            self.e1AbsEta_branch.GetEntry(self.localentry, 0)
            return self.e1AbsEta_value

    property e1CBID_LOOSE:
        def __get__(self):
            self.e1CBID_LOOSE_branch.GetEntry(self.localentry, 0)
            return self.e1CBID_LOOSE_value

    property e1CBID_MEDIUM:
        def __get__(self):
            self.e1CBID_MEDIUM_branch.GetEntry(self.localentry, 0)
            return self.e1CBID_MEDIUM_value

    property e1CBID_TIGHT:
        def __get__(self):
            self.e1CBID_TIGHT_branch.GetEntry(self.localentry, 0)
            return self.e1CBID_TIGHT_value

    property e1CBID_VETO:
        def __get__(self):
            self.e1CBID_VETO_branch.GetEntry(self.localentry, 0)
            return self.e1CBID_VETO_value

    property e1Charge:
        def __get__(self):
            self.e1Charge_branch.GetEntry(self.localentry, 0)
            return self.e1Charge_value

    property e1ChargeIdLoose:
        def __get__(self):
            self.e1ChargeIdLoose_branch.GetEntry(self.localentry, 0)
            return self.e1ChargeIdLoose_value

    property e1ChargeIdMed:
        def __get__(self):
            self.e1ChargeIdMed_branch.GetEntry(self.localentry, 0)
            return self.e1ChargeIdMed_value

    property e1ChargeIdTight:
        def __get__(self):
            self.e1ChargeIdTight_branch.GetEntry(self.localentry, 0)
            return self.e1ChargeIdTight_value

    property e1CiCTight:
        def __get__(self):
            self.e1CiCTight_branch.GetEntry(self.localentry, 0)
            return self.e1CiCTight_value

    property e1ComesFromHiggs:
        def __get__(self):
            self.e1ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.e1ComesFromHiggs_value

    property e1DZ:
        def __get__(self):
            self.e1DZ_branch.GetEntry(self.localentry, 0)
            return self.e1DZ_value

    property e1E1x5:
        def __get__(self):
            self.e1E1x5_branch.GetEntry(self.localentry, 0)
            return self.e1E1x5_value

    property e1E2x5Max:
        def __get__(self):
            self.e1E2x5Max_branch.GetEntry(self.localentry, 0)
            return self.e1E2x5Max_value

    property e1E5x5:
        def __get__(self):
            self.e1E5x5_branch.GetEntry(self.localentry, 0)
            return self.e1E5x5_value

    property e1ECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e1ECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrReg_2012Jul13ReReco_value

    property e1ECorrReg_Fall11:
        def __get__(self):
            self.e1ECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrReg_Fall11_value

    property e1ECorrReg_Jan16ReReco:
        def __get__(self):
            self.e1ECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrReg_Jan16ReReco_value

    property e1ECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1ECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrReg_Summer12_DR53X_HCP2012_value

    property e1ECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedNoReg_2012Jul13ReReco_value

    property e1ECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e1ECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedNoReg_Fall11_value

    property e1ECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e1ECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedNoReg_Jan16ReReco_value

    property e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e1ECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e1ECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedReg_2012Jul13ReReco_value

    property e1ECorrSmearedReg_Fall11:
        def __get__(self):
            self.e1ECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedReg_Fall11_value

    property e1ECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e1ECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedReg_Jan16ReReco_value

    property e1ECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e1EcalIsoDR03:
        def __get__(self):
            self.e1EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1EcalIsoDR03_value

    property e1EffectiveArea2011Data:
        def __get__(self):
            self.e1EffectiveArea2011Data_branch.GetEntry(self.localentry, 0)
            return self.e1EffectiveArea2011Data_value

    property e1EffectiveArea2012Data:
        def __get__(self):
            self.e1EffectiveArea2012Data_branch.GetEntry(self.localentry, 0)
            return self.e1EffectiveArea2012Data_value

    property e1EffectiveAreaFall11MC:
        def __get__(self):
            self.e1EffectiveAreaFall11MC_branch.GetEntry(self.localentry, 0)
            return self.e1EffectiveAreaFall11MC_value

    property e1Ele27WP80PFMT50PFMTFilter:
        def __get__(self):
            self.e1Ele27WP80PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.e1Ele27WP80PFMT50PFMTFilter_value

    property e1Ele27WP80TrackIsoMatchFilter:
        def __get__(self):
            self.e1Ele27WP80TrackIsoMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e1Ele27WP80TrackIsoMatchFilter_value

    property e1Ele32WP70PFMT50PFMTFilter:
        def __get__(self):
            self.e1Ele32WP70PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.e1Ele32WP70PFMT50PFMTFilter_value

    property e1EnergyError:
        def __get__(self):
            self.e1EnergyError_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyError_value

    property e1Eta:
        def __get__(self):
            self.e1Eta_branch.GetEntry(self.localentry, 0)
            return self.e1Eta_value

    property e1EtaCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e1EtaCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrReg_2012Jul13ReReco_value

    property e1EtaCorrReg_Fall11:
        def __get__(self):
            self.e1EtaCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrReg_Fall11_value

    property e1EtaCorrReg_Jan16ReReco:
        def __get__(self):
            self.e1EtaCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrReg_Jan16ReReco_value

    property e1EtaCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrReg_Summer12_DR53X_HCP2012_value

    property e1EtaCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_value

    property e1EtaCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e1EtaCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedNoReg_Fall11_value

    property e1EtaCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedNoReg_Jan16ReReco_value

    property e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e1EtaCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedReg_2012Jul13ReReco_value

    property e1EtaCorrSmearedReg_Fall11:
        def __get__(self):
            self.e1EtaCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedReg_Fall11_value

    property e1EtaCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e1EtaCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedReg_Jan16ReReco_value

    property e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e1GenCharge:
        def __get__(self):
            self.e1GenCharge_branch.GetEntry(self.localentry, 0)
            return self.e1GenCharge_value

    property e1GenEnergy:
        def __get__(self):
            self.e1GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1GenEnergy_value

    property e1GenEta:
        def __get__(self):
            self.e1GenEta_branch.GetEntry(self.localentry, 0)
            return self.e1GenEta_value

    property e1GenMotherPdgId:
        def __get__(self):
            self.e1GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.e1GenMotherPdgId_value

    property e1GenPdgId:
        def __get__(self):
            self.e1GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.e1GenPdgId_value

    property e1GenPhi:
        def __get__(self):
            self.e1GenPhi_branch.GetEntry(self.localentry, 0)
            return self.e1GenPhi_value

    property e1HadronicDepth1OverEm:
        def __get__(self):
            self.e1HadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.e1HadronicDepth1OverEm_value

    property e1HadronicDepth2OverEm:
        def __get__(self):
            self.e1HadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.e1HadronicDepth2OverEm_value

    property e1HadronicOverEM:
        def __get__(self):
            self.e1HadronicOverEM_branch.GetEntry(self.localentry, 0)
            return self.e1HadronicOverEM_value

    property e1HasConversion:
        def __get__(self):
            self.e1HasConversion_branch.GetEntry(self.localentry, 0)
            return self.e1HasConversion_value

    property e1HasMatchedConversion:
        def __get__(self):
            self.e1HasMatchedConversion_branch.GetEntry(self.localentry, 0)
            return self.e1HasMatchedConversion_value

    property e1HcalIsoDR03:
        def __get__(self):
            self.e1HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1HcalIsoDR03_value

    property e1IP3DS:
        def __get__(self):
            self.e1IP3DS_branch.GetEntry(self.localentry, 0)
            return self.e1IP3DS_value

    property e1JetArea:
        def __get__(self):
            self.e1JetArea_branch.GetEntry(self.localentry, 0)
            return self.e1JetArea_value

    property e1JetBtag:
        def __get__(self):
            self.e1JetBtag_branch.GetEntry(self.localentry, 0)
            return self.e1JetBtag_value

    property e1JetCSVBtag:
        def __get__(self):
            self.e1JetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.e1JetCSVBtag_value

    property e1JetEtaEtaMoment:
        def __get__(self):
            self.e1JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.e1JetEtaEtaMoment_value

    property e1JetEtaPhiMoment:
        def __get__(self):
            self.e1JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e1JetEtaPhiMoment_value

    property e1JetEtaPhiSpread:
        def __get__(self):
            self.e1JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.e1JetEtaPhiSpread_value

    property e1JetPhiPhiMoment:
        def __get__(self):
            self.e1JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e1JetPhiPhiMoment_value

    property e1JetPt:
        def __get__(self):
            self.e1JetPt_branch.GetEntry(self.localentry, 0)
            return self.e1JetPt_value

    property e1JetQGLikelihoodID:
        def __get__(self):
            self.e1JetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.e1JetQGLikelihoodID_value

    property e1JetQGMVAID:
        def __get__(self):
            self.e1JetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.e1JetQGMVAID_value

    property e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter:
        def __get__(self):
            self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    property e1MITID:
        def __get__(self):
            self.e1MITID_branch.GetEntry(self.localentry, 0)
            return self.e1MITID_value

    property e1MVAIDH2TauWP:
        def __get__(self):
            self.e1MVAIDH2TauWP_branch.GetEntry(self.localentry, 0)
            return self.e1MVAIDH2TauWP_value

    property e1MVANonTrig:
        def __get__(self):
            self.e1MVANonTrig_branch.GetEntry(self.localentry, 0)
            return self.e1MVANonTrig_value

    property e1MVATrig:
        def __get__(self):
            self.e1MVATrig_branch.GetEntry(self.localentry, 0)
            return self.e1MVATrig_value

    property e1MVATrigIDISO:
        def __get__(self):
            self.e1MVATrigIDISO_branch.GetEntry(self.localentry, 0)
            return self.e1MVATrigIDISO_value

    property e1MVATrigIDISOPUSUB:
        def __get__(self):
            self.e1MVATrigIDISOPUSUB_branch.GetEntry(self.localentry, 0)
            return self.e1MVATrigIDISOPUSUB_value

    property e1MVATrigNoIP:
        def __get__(self):
            self.e1MVATrigNoIP_branch.GetEntry(self.localentry, 0)
            return self.e1MVATrigNoIP_value

    property e1Mass:
        def __get__(self):
            self.e1Mass_branch.GetEntry(self.localentry, 0)
            return self.e1Mass_value

    property e1MatchesDoubleEPath:
        def __get__(self):
            self.e1MatchesDoubleEPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesDoubleEPath_value

    property e1MatchesMu17Ele8IsoPath:
        def __get__(self):
            self.e1MatchesMu17Ele8IsoPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu17Ele8IsoPath_value

    property e1MatchesMu17Ele8Path:
        def __get__(self):
            self.e1MatchesMu17Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu17Ele8Path_value

    property e1MatchesMu8Ele17IsoPath:
        def __get__(self):
            self.e1MatchesMu8Ele17IsoPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu8Ele17IsoPath_value

    property e1MatchesMu8Ele17Path:
        def __get__(self):
            self.e1MatchesMu8Ele17Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu8Ele17Path_value

    property e1MatchesSingleE:
        def __get__(self):
            self.e1MatchesSingleE_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesSingleE_value

    property e1MatchesSingleE27WP80:
        def __get__(self):
            self.e1MatchesSingleE27WP80_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesSingleE27WP80_value

    property e1MatchesSingleEPlusMET:
        def __get__(self):
            self.e1MatchesSingleEPlusMET_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesSingleEPlusMET_value

    property e1MissingHits:
        def __get__(self):
            self.e1MissingHits_branch.GetEntry(self.localentry, 0)
            return self.e1MissingHits_value

    property e1MtToMET:
        def __get__(self):
            self.e1MtToMET_branch.GetEntry(self.localentry, 0)
            return self.e1MtToMET_value

    property e1MtToMVAMET:
        def __get__(self):
            self.e1MtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.e1MtToMVAMET_value

    property e1MtToPfMet:
        def __get__(self):
            self.e1MtToPfMet_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_value

    property e1MtToPfMet_Ty1:
        def __get__(self):
            self.e1MtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_Ty1_value

    property e1MtToPfMet_ees:
        def __get__(self):
            self.e1MtToPfMet_ees_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_ees_value

    property e1MtToPfMet_ees_minus:
        def __get__(self):
            self.e1MtToPfMet_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_ees_minus_value

    property e1MtToPfMet_ees_plus:
        def __get__(self):
            self.e1MtToPfMet_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_ees_plus_value

    property e1MtToPfMet_jes:
        def __get__(self):
            self.e1MtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_jes_value

    property e1MtToPfMet_jes_minus:
        def __get__(self):
            self.e1MtToPfMet_jes_minus_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_jes_minus_value

    property e1MtToPfMet_jes_plus:
        def __get__(self):
            self.e1MtToPfMet_jes_plus_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_jes_plus_value

    property e1MtToPfMet_mes:
        def __get__(self):
            self.e1MtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_mes_value

    property e1MtToPfMet_mes_minus:
        def __get__(self):
            self.e1MtToPfMet_mes_minus_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_mes_minus_value

    property e1MtToPfMet_mes_plus:
        def __get__(self):
            self.e1MtToPfMet_mes_plus_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_mes_plus_value

    property e1MtToPfMet_tes:
        def __get__(self):
            self.e1MtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_tes_value

    property e1MtToPfMet_tes_minus:
        def __get__(self):
            self.e1MtToPfMet_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_tes_minus_value

    property e1MtToPfMet_tes_plus:
        def __get__(self):
            self.e1MtToPfMet_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_tes_plus_value

    property e1MtToPfMet_ues:
        def __get__(self):
            self.e1MtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_ues_value

    property e1MtToPfMet_ues_minus:
        def __get__(self):
            self.e1MtToPfMet_ues_minus_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_ues_minus_value

    property e1MtToPfMet_ues_plus:
        def __get__(self):
            self.e1MtToPfMet_ues_plus_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_ues_plus_value

    property e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter:
        def __get__(self):
            self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.GetEntry(self.localentry, 0)
            return self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    property e1Mu17Ele8CaloIdTPixelMatchFilter:
        def __get__(self):
            self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e1Mu17Ele8CaloIdTPixelMatchFilter_value

    property e1Mu17Ele8dZFilter:
        def __get__(self):
            self.e1Mu17Ele8dZFilter_branch.GetEntry(self.localentry, 0)
            return self.e1Mu17Ele8dZFilter_value

    property e1NearMuonVeto:
        def __get__(self):
            self.e1NearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.e1NearMuonVeto_value

    property e1PFChargedIso:
        def __get__(self):
            self.e1PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFChargedIso_value

    property e1PFNeutralIso:
        def __get__(self):
            self.e1PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFNeutralIso_value

    property e1PFPhotonIso:
        def __get__(self):
            self.e1PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFPhotonIso_value

    property e1PVDXY:
        def __get__(self):
            self.e1PVDXY_branch.GetEntry(self.localentry, 0)
            return self.e1PVDXY_value

    property e1PVDZ:
        def __get__(self):
            self.e1PVDZ_branch.GetEntry(self.localentry, 0)
            return self.e1PVDZ_value

    property e1Phi:
        def __get__(self):
            self.e1Phi_branch.GetEntry(self.localentry, 0)
            return self.e1Phi_value

    property e1PhiCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e1PhiCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrReg_2012Jul13ReReco_value

    property e1PhiCorrReg_Fall11:
        def __get__(self):
            self.e1PhiCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrReg_Fall11_value

    property e1PhiCorrReg_Jan16ReReco:
        def __get__(self):
            self.e1PhiCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrReg_Jan16ReReco_value

    property e1PhiCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrReg_Summer12_DR53X_HCP2012_value

    property e1PhiCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_value

    property e1PhiCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e1PhiCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedNoReg_Fall11_value

    property e1PhiCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedNoReg_Jan16ReReco_value

    property e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e1PhiCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedReg_2012Jul13ReReco_value

    property e1PhiCorrSmearedReg_Fall11:
        def __get__(self):
            self.e1PhiCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedReg_Fall11_value

    property e1PhiCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e1PhiCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedReg_Jan16ReReco_value

    property e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e1Pt:
        def __get__(self):
            self.e1Pt_branch.GetEntry(self.localentry, 0)
            return self.e1Pt_value

    property e1PtCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e1PtCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrReg_2012Jul13ReReco_value

    property e1PtCorrReg_Fall11:
        def __get__(self):
            self.e1PtCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrReg_Fall11_value

    property e1PtCorrReg_Jan16ReReco:
        def __get__(self):
            self.e1PtCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrReg_Jan16ReReco_value

    property e1PtCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrReg_Summer12_DR53X_HCP2012_value

    property e1PtCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedNoReg_2012Jul13ReReco_value

    property e1PtCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e1PtCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedNoReg_Fall11_value

    property e1PtCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e1PtCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedNoReg_Jan16ReReco_value

    property e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e1PtCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e1PtCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedReg_2012Jul13ReReco_value

    property e1PtCorrSmearedReg_Fall11:
        def __get__(self):
            self.e1PtCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedReg_Fall11_value

    property e1PtCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e1PtCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedReg_Jan16ReReco_value

    property e1PtCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e1Pt_ees_minus:
        def __get__(self):
            self.e1Pt_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.e1Pt_ees_minus_value

    property e1Pt_ees_plus:
        def __get__(self):
            self.e1Pt_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.e1Pt_ees_plus_value

    property e1Pt_tes_minus:
        def __get__(self):
            self.e1Pt_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.e1Pt_tes_minus_value

    property e1Pt_tes_plus:
        def __get__(self):
            self.e1Pt_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.e1Pt_tes_plus_value

    property e1Rank:
        def __get__(self):
            self.e1Rank_branch.GetEntry(self.localentry, 0)
            return self.e1Rank_value

    property e1RelIso:
        def __get__(self):
            self.e1RelIso_branch.GetEntry(self.localentry, 0)
            return self.e1RelIso_value

    property e1RelPFIsoDB:
        def __get__(self):
            self.e1RelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.e1RelPFIsoDB_value

    property e1RelPFIsoRho:
        def __get__(self):
            self.e1RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.e1RelPFIsoRho_value

    property e1RelPFIsoRhoFSR:
        def __get__(self):
            self.e1RelPFIsoRhoFSR_branch.GetEntry(self.localentry, 0)
            return self.e1RelPFIsoRhoFSR_value

    property e1RhoHZG2011:
        def __get__(self):
            self.e1RhoHZG2011_branch.GetEntry(self.localentry, 0)
            return self.e1RhoHZG2011_value

    property e1RhoHZG2012:
        def __get__(self):
            self.e1RhoHZG2012_branch.GetEntry(self.localentry, 0)
            return self.e1RhoHZG2012_value

    property e1SCEnergy:
        def __get__(self):
            self.e1SCEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1SCEnergy_value

    property e1SCEta:
        def __get__(self):
            self.e1SCEta_branch.GetEntry(self.localentry, 0)
            return self.e1SCEta_value

    property e1SCEtaWidth:
        def __get__(self):
            self.e1SCEtaWidth_branch.GetEntry(self.localentry, 0)
            return self.e1SCEtaWidth_value

    property e1SCPhi:
        def __get__(self):
            self.e1SCPhi_branch.GetEntry(self.localentry, 0)
            return self.e1SCPhi_value

    property e1SCPhiWidth:
        def __get__(self):
            self.e1SCPhiWidth_branch.GetEntry(self.localentry, 0)
            return self.e1SCPhiWidth_value

    property e1SCPreshowerEnergy:
        def __get__(self):
            self.e1SCPreshowerEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1SCPreshowerEnergy_value

    property e1SCRawEnergy:
        def __get__(self):
            self.e1SCRawEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1SCRawEnergy_value

    property e1SigmaIEtaIEta:
        def __get__(self):
            self.e1SigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.e1SigmaIEtaIEta_value

    property e1ToMETDPhi:
        def __get__(self):
            self.e1ToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.e1ToMETDPhi_value

    property e1TrkIsoDR03:
        def __get__(self):
            self.e1TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1TrkIsoDR03_value

    property e1VZ:
        def __get__(self):
            self.e1VZ_branch.GetEntry(self.localentry, 0)
            return self.e1VZ_value

    property e1WWID:
        def __get__(self):
            self.e1WWID_branch.GetEntry(self.localentry, 0)
            return self.e1WWID_value

    property e1_e2_CosThetaStar:
        def __get__(self):
            self.e1_e2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_CosThetaStar_value

    property e1_e2_DPhi:
        def __get__(self):
            self.e1_e2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_DPhi_value

    property e1_e2_DR:
        def __get__(self):
            self.e1_e2_DR_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_DR_value

    property e1_e2_Mass:
        def __get__(self):
            self.e1_e2_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mass_value

    property e1_e2_MassFsr:
        def __get__(self):
            self.e1_e2_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_MassFsr_value

    property e1_e2_Mass_ees_minus:
        def __get__(self):
            self.e1_e2_Mass_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mass_ees_minus_value

    property e1_e2_Mass_ees_plus:
        def __get__(self):
            self.e1_e2_Mass_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mass_ees_plus_value

    property e1_e2_Mass_tes_minus:
        def __get__(self):
            self.e1_e2_Mass_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mass_tes_minus_value

    property e1_e2_Mass_tes_plus:
        def __get__(self):
            self.e1_e2_Mass_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mass_tes_plus_value

    property e1_e2_PZeta:
        def __get__(self):
            self.e1_e2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PZeta_value

    property e1_e2_PZetaVis:
        def __get__(self):
            self.e1_e2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PZetaVis_value

    property e1_e2_Pt:
        def __get__(self):
            self.e1_e2_Pt_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Pt_value

    property e1_e2_PtFsr:
        def __get__(self):
            self.e1_e2_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PtFsr_value

    property e1_e2_SS:
        def __get__(self):
            self.e1_e2_SS_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_SS_value

    property e1_e2_ToMETDPhi_Ty1:
        def __get__(self):
            self.e1_e2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_ToMETDPhi_Ty1_value

    property e1_e2_ToMETDPhi_jes_minus:
        def __get__(self):
            self.e1_e2_ToMETDPhi_jes_minus_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_ToMETDPhi_jes_minus_value

    property e1_e2_ToMETDPhi_jes_plus:
        def __get__(self):
            self.e1_e2_ToMETDPhi_jes_plus_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_ToMETDPhi_jes_plus_value

    property e1_e2_Zcompat:
        def __get__(self):
            self.e1_e2_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Zcompat_value

    property e1_t_CosThetaStar:
        def __get__(self):
            self.e1_t_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e1_t_CosThetaStar_value

    property e1_t_DPhi:
        def __get__(self):
            self.e1_t_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e1_t_DPhi_value

    property e1_t_DR:
        def __get__(self):
            self.e1_t_DR_branch.GetEntry(self.localentry, 0)
            return self.e1_t_DR_value

    property e1_t_Mass:
        def __get__(self):
            self.e1_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mass_value

    property e1_t_MassFsr:
        def __get__(self):
            self.e1_t_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_t_MassFsr_value

    property e1_t_Mass_ees_minus:
        def __get__(self):
            self.e1_t_Mass_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mass_ees_minus_value

    property e1_t_Mass_ees_plus:
        def __get__(self):
            self.e1_t_Mass_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mass_ees_plus_value

    property e1_t_Mass_tes_minus:
        def __get__(self):
            self.e1_t_Mass_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mass_tes_minus_value

    property e1_t_Mass_tes_plus:
        def __get__(self):
            self.e1_t_Mass_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mass_tes_plus_value

    property e1_t_PZeta:
        def __get__(self):
            self.e1_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_t_PZeta_value

    property e1_t_PZetaVis:
        def __get__(self):
            self.e1_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_t_PZetaVis_value

    property e1_t_Pt:
        def __get__(self):
            self.e1_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Pt_value

    property e1_t_PtFsr:
        def __get__(self):
            self.e1_t_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_t_PtFsr_value

    property e1_t_SS:
        def __get__(self):
            self.e1_t_SS_branch.GetEntry(self.localentry, 0)
            return self.e1_t_SS_value

    property e1_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.e1_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e1_t_ToMETDPhi_Ty1_value

    property e1_t_ToMETDPhi_jes_minus:
        def __get__(self):
            self.e1_t_ToMETDPhi_jes_minus_branch.GetEntry(self.localentry, 0)
            return self.e1_t_ToMETDPhi_jes_minus_value

    property e1_t_ToMETDPhi_jes_plus:
        def __get__(self):
            self.e1_t_ToMETDPhi_jes_plus_branch.GetEntry(self.localentry, 0)
            return self.e1_t_ToMETDPhi_jes_plus_value

    property e1_t_Zcompat:
        def __get__(self):
            self.e1_t_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Zcompat_value

    property e1dECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e1dECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrReg_2012Jul13ReReco_value

    property e1dECorrReg_Fall11:
        def __get__(self):
            self.e1dECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrReg_Fall11_value

    property e1dECorrReg_Jan16ReReco:
        def __get__(self):
            self.e1dECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrReg_Jan16ReReco_value

    property e1dECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1dECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrReg_Summer12_DR53X_HCP2012_value

    property e1dECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedNoReg_2012Jul13ReReco_value

    property e1dECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e1dECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedNoReg_Fall11_value

    property e1dECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e1dECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedNoReg_Jan16ReReco_value

    property e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e1dECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e1dECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedReg_2012Jul13ReReco_value

    property e1dECorrSmearedReg_Fall11:
        def __get__(self):
            self.e1dECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedReg_Fall11_value

    property e1dECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e1dECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedReg_Jan16ReReco_value

    property e1dECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e1deltaEtaSuperClusterTrackAtVtx:
        def __get__(self):
            self.e1deltaEtaSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e1deltaEtaSuperClusterTrackAtVtx_value

    property e1deltaPhiSuperClusterTrackAtVtx:
        def __get__(self):
            self.e1deltaPhiSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e1deltaPhiSuperClusterTrackAtVtx_value

    property e1eSuperClusterOverP:
        def __get__(self):
            self.e1eSuperClusterOverP_branch.GetEntry(self.localentry, 0)
            return self.e1eSuperClusterOverP_value

    property e1ecalEnergy:
        def __get__(self):
            self.e1ecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1ecalEnergy_value

    property e1fBrem:
        def __get__(self):
            self.e1fBrem_branch.GetEntry(self.localentry, 0)
            return self.e1fBrem_value

    property e1trackMomentumAtVtxP:
        def __get__(self):
            self.e1trackMomentumAtVtxP_branch.GetEntry(self.localentry, 0)
            return self.e1trackMomentumAtVtxP_value

    property e2AbsEta:
        def __get__(self):
            self.e2AbsEta_branch.GetEntry(self.localentry, 0)
            return self.e2AbsEta_value

    property e2CBID_LOOSE:
        def __get__(self):
            self.e2CBID_LOOSE_branch.GetEntry(self.localentry, 0)
            return self.e2CBID_LOOSE_value

    property e2CBID_MEDIUM:
        def __get__(self):
            self.e2CBID_MEDIUM_branch.GetEntry(self.localentry, 0)
            return self.e2CBID_MEDIUM_value

    property e2CBID_TIGHT:
        def __get__(self):
            self.e2CBID_TIGHT_branch.GetEntry(self.localentry, 0)
            return self.e2CBID_TIGHT_value

    property e2CBID_VETO:
        def __get__(self):
            self.e2CBID_VETO_branch.GetEntry(self.localentry, 0)
            return self.e2CBID_VETO_value

    property e2Charge:
        def __get__(self):
            self.e2Charge_branch.GetEntry(self.localentry, 0)
            return self.e2Charge_value

    property e2ChargeIdLoose:
        def __get__(self):
            self.e2ChargeIdLoose_branch.GetEntry(self.localentry, 0)
            return self.e2ChargeIdLoose_value

    property e2ChargeIdMed:
        def __get__(self):
            self.e2ChargeIdMed_branch.GetEntry(self.localentry, 0)
            return self.e2ChargeIdMed_value

    property e2ChargeIdTight:
        def __get__(self):
            self.e2ChargeIdTight_branch.GetEntry(self.localentry, 0)
            return self.e2ChargeIdTight_value

    property e2CiCTight:
        def __get__(self):
            self.e2CiCTight_branch.GetEntry(self.localentry, 0)
            return self.e2CiCTight_value

    property e2ComesFromHiggs:
        def __get__(self):
            self.e2ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.e2ComesFromHiggs_value

    property e2DZ:
        def __get__(self):
            self.e2DZ_branch.GetEntry(self.localentry, 0)
            return self.e2DZ_value

    property e2E1x5:
        def __get__(self):
            self.e2E1x5_branch.GetEntry(self.localentry, 0)
            return self.e2E1x5_value

    property e2E2x5Max:
        def __get__(self):
            self.e2E2x5Max_branch.GetEntry(self.localentry, 0)
            return self.e2E2x5Max_value

    property e2E5x5:
        def __get__(self):
            self.e2E5x5_branch.GetEntry(self.localentry, 0)
            return self.e2E5x5_value

    property e2ECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e2ECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrReg_2012Jul13ReReco_value

    property e2ECorrReg_Fall11:
        def __get__(self):
            self.e2ECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrReg_Fall11_value

    property e2ECorrReg_Jan16ReReco:
        def __get__(self):
            self.e2ECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrReg_Jan16ReReco_value

    property e2ECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2ECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrReg_Summer12_DR53X_HCP2012_value

    property e2ECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedNoReg_2012Jul13ReReco_value

    property e2ECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e2ECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedNoReg_Fall11_value

    property e2ECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e2ECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedNoReg_Jan16ReReco_value

    property e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e2ECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e2ECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedReg_2012Jul13ReReco_value

    property e2ECorrSmearedReg_Fall11:
        def __get__(self):
            self.e2ECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedReg_Fall11_value

    property e2ECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e2ECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedReg_Jan16ReReco_value

    property e2ECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e2EcalIsoDR03:
        def __get__(self):
            self.e2EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2EcalIsoDR03_value

    property e2EffectiveArea2011Data:
        def __get__(self):
            self.e2EffectiveArea2011Data_branch.GetEntry(self.localentry, 0)
            return self.e2EffectiveArea2011Data_value

    property e2EffectiveArea2012Data:
        def __get__(self):
            self.e2EffectiveArea2012Data_branch.GetEntry(self.localentry, 0)
            return self.e2EffectiveArea2012Data_value

    property e2EffectiveAreaFall11MC:
        def __get__(self):
            self.e2EffectiveAreaFall11MC_branch.GetEntry(self.localentry, 0)
            return self.e2EffectiveAreaFall11MC_value

    property e2Ele27WP80PFMT50PFMTFilter:
        def __get__(self):
            self.e2Ele27WP80PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.e2Ele27WP80PFMT50PFMTFilter_value

    property e2Ele27WP80TrackIsoMatchFilter:
        def __get__(self):
            self.e2Ele27WP80TrackIsoMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e2Ele27WP80TrackIsoMatchFilter_value

    property e2Ele32WP70PFMT50PFMTFilter:
        def __get__(self):
            self.e2Ele32WP70PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.e2Ele32WP70PFMT50PFMTFilter_value

    property e2EnergyError:
        def __get__(self):
            self.e2EnergyError_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyError_value

    property e2Eta:
        def __get__(self):
            self.e2Eta_branch.GetEntry(self.localentry, 0)
            return self.e2Eta_value

    property e2EtaCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e2EtaCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrReg_2012Jul13ReReco_value

    property e2EtaCorrReg_Fall11:
        def __get__(self):
            self.e2EtaCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrReg_Fall11_value

    property e2EtaCorrReg_Jan16ReReco:
        def __get__(self):
            self.e2EtaCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrReg_Jan16ReReco_value

    property e2EtaCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrReg_Summer12_DR53X_HCP2012_value

    property e2EtaCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_value

    property e2EtaCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e2EtaCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedNoReg_Fall11_value

    property e2EtaCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedNoReg_Jan16ReReco_value

    property e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e2EtaCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedReg_2012Jul13ReReco_value

    property e2EtaCorrSmearedReg_Fall11:
        def __get__(self):
            self.e2EtaCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedReg_Fall11_value

    property e2EtaCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e2EtaCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedReg_Jan16ReReco_value

    property e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e2GenCharge:
        def __get__(self):
            self.e2GenCharge_branch.GetEntry(self.localentry, 0)
            return self.e2GenCharge_value

    property e2GenEnergy:
        def __get__(self):
            self.e2GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2GenEnergy_value

    property e2GenEta:
        def __get__(self):
            self.e2GenEta_branch.GetEntry(self.localentry, 0)
            return self.e2GenEta_value

    property e2GenMotherPdgId:
        def __get__(self):
            self.e2GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.e2GenMotherPdgId_value

    property e2GenPdgId:
        def __get__(self):
            self.e2GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.e2GenPdgId_value

    property e2GenPhi:
        def __get__(self):
            self.e2GenPhi_branch.GetEntry(self.localentry, 0)
            return self.e2GenPhi_value

    property e2HadronicDepth1OverEm:
        def __get__(self):
            self.e2HadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.e2HadronicDepth1OverEm_value

    property e2HadronicDepth2OverEm:
        def __get__(self):
            self.e2HadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.e2HadronicDepth2OverEm_value

    property e2HadronicOverEM:
        def __get__(self):
            self.e2HadronicOverEM_branch.GetEntry(self.localentry, 0)
            return self.e2HadronicOverEM_value

    property e2HasConversion:
        def __get__(self):
            self.e2HasConversion_branch.GetEntry(self.localentry, 0)
            return self.e2HasConversion_value

    property e2HasMatchedConversion:
        def __get__(self):
            self.e2HasMatchedConversion_branch.GetEntry(self.localentry, 0)
            return self.e2HasMatchedConversion_value

    property e2HcalIsoDR03:
        def __get__(self):
            self.e2HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2HcalIsoDR03_value

    property e2IP3DS:
        def __get__(self):
            self.e2IP3DS_branch.GetEntry(self.localentry, 0)
            return self.e2IP3DS_value

    property e2JetArea:
        def __get__(self):
            self.e2JetArea_branch.GetEntry(self.localentry, 0)
            return self.e2JetArea_value

    property e2JetBtag:
        def __get__(self):
            self.e2JetBtag_branch.GetEntry(self.localentry, 0)
            return self.e2JetBtag_value

    property e2JetCSVBtag:
        def __get__(self):
            self.e2JetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.e2JetCSVBtag_value

    property e2JetEtaEtaMoment:
        def __get__(self):
            self.e2JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.e2JetEtaEtaMoment_value

    property e2JetEtaPhiMoment:
        def __get__(self):
            self.e2JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e2JetEtaPhiMoment_value

    property e2JetEtaPhiSpread:
        def __get__(self):
            self.e2JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.e2JetEtaPhiSpread_value

    property e2JetPhiPhiMoment:
        def __get__(self):
            self.e2JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e2JetPhiPhiMoment_value

    property e2JetPt:
        def __get__(self):
            self.e2JetPt_branch.GetEntry(self.localentry, 0)
            return self.e2JetPt_value

    property e2JetQGLikelihoodID:
        def __get__(self):
            self.e2JetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.e2JetQGLikelihoodID_value

    property e2JetQGMVAID:
        def __get__(self):
            self.e2JetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.e2JetQGMVAID_value

    property e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter:
        def __get__(self):
            self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    property e2MITID:
        def __get__(self):
            self.e2MITID_branch.GetEntry(self.localentry, 0)
            return self.e2MITID_value

    property e2MVAIDH2TauWP:
        def __get__(self):
            self.e2MVAIDH2TauWP_branch.GetEntry(self.localentry, 0)
            return self.e2MVAIDH2TauWP_value

    property e2MVANonTrig:
        def __get__(self):
            self.e2MVANonTrig_branch.GetEntry(self.localentry, 0)
            return self.e2MVANonTrig_value

    property e2MVATrig:
        def __get__(self):
            self.e2MVATrig_branch.GetEntry(self.localentry, 0)
            return self.e2MVATrig_value

    property e2MVATrigIDISO:
        def __get__(self):
            self.e2MVATrigIDISO_branch.GetEntry(self.localentry, 0)
            return self.e2MVATrigIDISO_value

    property e2MVATrigIDISOPUSUB:
        def __get__(self):
            self.e2MVATrigIDISOPUSUB_branch.GetEntry(self.localentry, 0)
            return self.e2MVATrigIDISOPUSUB_value

    property e2MVATrigNoIP:
        def __get__(self):
            self.e2MVATrigNoIP_branch.GetEntry(self.localentry, 0)
            return self.e2MVATrigNoIP_value

    property e2Mass:
        def __get__(self):
            self.e2Mass_branch.GetEntry(self.localentry, 0)
            return self.e2Mass_value

    property e2MatchesDoubleEPath:
        def __get__(self):
            self.e2MatchesDoubleEPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesDoubleEPath_value

    property e2MatchesMu17Ele8IsoPath:
        def __get__(self):
            self.e2MatchesMu17Ele8IsoPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu17Ele8IsoPath_value

    property e2MatchesMu17Ele8Path:
        def __get__(self):
            self.e2MatchesMu17Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu17Ele8Path_value

    property e2MatchesMu8Ele17IsoPath:
        def __get__(self):
            self.e2MatchesMu8Ele17IsoPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu8Ele17IsoPath_value

    property e2MatchesMu8Ele17Path:
        def __get__(self):
            self.e2MatchesMu8Ele17Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu8Ele17Path_value

    property e2MatchesSingleE:
        def __get__(self):
            self.e2MatchesSingleE_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesSingleE_value

    property e2MatchesSingleE27WP80:
        def __get__(self):
            self.e2MatchesSingleE27WP80_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesSingleE27WP80_value

    property e2MatchesSingleEPlusMET:
        def __get__(self):
            self.e2MatchesSingleEPlusMET_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesSingleEPlusMET_value

    property e2MissingHits:
        def __get__(self):
            self.e2MissingHits_branch.GetEntry(self.localentry, 0)
            return self.e2MissingHits_value

    property e2MtToMET:
        def __get__(self):
            self.e2MtToMET_branch.GetEntry(self.localentry, 0)
            return self.e2MtToMET_value

    property e2MtToMVAMET:
        def __get__(self):
            self.e2MtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.e2MtToMVAMET_value

    property e2MtToPfMet:
        def __get__(self):
            self.e2MtToPfMet_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_value

    property e2MtToPfMet_Ty1:
        def __get__(self):
            self.e2MtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_Ty1_value

    property e2MtToPfMet_ees:
        def __get__(self):
            self.e2MtToPfMet_ees_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_ees_value

    property e2MtToPfMet_ees_minus:
        def __get__(self):
            self.e2MtToPfMet_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_ees_minus_value

    property e2MtToPfMet_ees_plus:
        def __get__(self):
            self.e2MtToPfMet_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_ees_plus_value

    property e2MtToPfMet_jes:
        def __get__(self):
            self.e2MtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_jes_value

    property e2MtToPfMet_jes_minus:
        def __get__(self):
            self.e2MtToPfMet_jes_minus_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_jes_minus_value

    property e2MtToPfMet_jes_plus:
        def __get__(self):
            self.e2MtToPfMet_jes_plus_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_jes_plus_value

    property e2MtToPfMet_mes:
        def __get__(self):
            self.e2MtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_mes_value

    property e2MtToPfMet_mes_minus:
        def __get__(self):
            self.e2MtToPfMet_mes_minus_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_mes_minus_value

    property e2MtToPfMet_mes_plus:
        def __get__(self):
            self.e2MtToPfMet_mes_plus_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_mes_plus_value

    property e2MtToPfMet_tes:
        def __get__(self):
            self.e2MtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_tes_value

    property e2MtToPfMet_tes_minus:
        def __get__(self):
            self.e2MtToPfMet_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_tes_minus_value

    property e2MtToPfMet_tes_plus:
        def __get__(self):
            self.e2MtToPfMet_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_tes_plus_value

    property e2MtToPfMet_ues:
        def __get__(self):
            self.e2MtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_ues_value

    property e2MtToPfMet_ues_minus:
        def __get__(self):
            self.e2MtToPfMet_ues_minus_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_ues_minus_value

    property e2MtToPfMet_ues_plus:
        def __get__(self):
            self.e2MtToPfMet_ues_plus_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_ues_plus_value

    property e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter:
        def __get__(self):
            self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.GetEntry(self.localentry, 0)
            return self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    property e2Mu17Ele8CaloIdTPixelMatchFilter:
        def __get__(self):
            self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e2Mu17Ele8CaloIdTPixelMatchFilter_value

    property e2Mu17Ele8dZFilter:
        def __get__(self):
            self.e2Mu17Ele8dZFilter_branch.GetEntry(self.localentry, 0)
            return self.e2Mu17Ele8dZFilter_value

    property e2NearMuonVeto:
        def __get__(self):
            self.e2NearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.e2NearMuonVeto_value

    property e2PFChargedIso:
        def __get__(self):
            self.e2PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFChargedIso_value

    property e2PFNeutralIso:
        def __get__(self):
            self.e2PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFNeutralIso_value

    property e2PFPhotonIso:
        def __get__(self):
            self.e2PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFPhotonIso_value

    property e2PVDXY:
        def __get__(self):
            self.e2PVDXY_branch.GetEntry(self.localentry, 0)
            return self.e2PVDXY_value

    property e2PVDZ:
        def __get__(self):
            self.e2PVDZ_branch.GetEntry(self.localentry, 0)
            return self.e2PVDZ_value

    property e2Phi:
        def __get__(self):
            self.e2Phi_branch.GetEntry(self.localentry, 0)
            return self.e2Phi_value

    property e2PhiCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e2PhiCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrReg_2012Jul13ReReco_value

    property e2PhiCorrReg_Fall11:
        def __get__(self):
            self.e2PhiCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrReg_Fall11_value

    property e2PhiCorrReg_Jan16ReReco:
        def __get__(self):
            self.e2PhiCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrReg_Jan16ReReco_value

    property e2PhiCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrReg_Summer12_DR53X_HCP2012_value

    property e2PhiCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_value

    property e2PhiCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e2PhiCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedNoReg_Fall11_value

    property e2PhiCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedNoReg_Jan16ReReco_value

    property e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e2PhiCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedReg_2012Jul13ReReco_value

    property e2PhiCorrSmearedReg_Fall11:
        def __get__(self):
            self.e2PhiCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedReg_Fall11_value

    property e2PhiCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e2PhiCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedReg_Jan16ReReco_value

    property e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e2Pt:
        def __get__(self):
            self.e2Pt_branch.GetEntry(self.localentry, 0)
            return self.e2Pt_value

    property e2PtCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e2PtCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrReg_2012Jul13ReReco_value

    property e2PtCorrReg_Fall11:
        def __get__(self):
            self.e2PtCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrReg_Fall11_value

    property e2PtCorrReg_Jan16ReReco:
        def __get__(self):
            self.e2PtCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrReg_Jan16ReReco_value

    property e2PtCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrReg_Summer12_DR53X_HCP2012_value

    property e2PtCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedNoReg_2012Jul13ReReco_value

    property e2PtCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e2PtCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedNoReg_Fall11_value

    property e2PtCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e2PtCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedNoReg_Jan16ReReco_value

    property e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e2PtCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e2PtCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedReg_2012Jul13ReReco_value

    property e2PtCorrSmearedReg_Fall11:
        def __get__(self):
            self.e2PtCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedReg_Fall11_value

    property e2PtCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e2PtCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedReg_Jan16ReReco_value

    property e2PtCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e2Pt_ees_minus:
        def __get__(self):
            self.e2Pt_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.e2Pt_ees_minus_value

    property e2Pt_ees_plus:
        def __get__(self):
            self.e2Pt_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.e2Pt_ees_plus_value

    property e2Pt_tes_minus:
        def __get__(self):
            self.e2Pt_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.e2Pt_tes_minus_value

    property e2Pt_tes_plus:
        def __get__(self):
            self.e2Pt_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.e2Pt_tes_plus_value

    property e2Rank:
        def __get__(self):
            self.e2Rank_branch.GetEntry(self.localentry, 0)
            return self.e2Rank_value

    property e2RelIso:
        def __get__(self):
            self.e2RelIso_branch.GetEntry(self.localentry, 0)
            return self.e2RelIso_value

    property e2RelPFIsoDB:
        def __get__(self):
            self.e2RelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.e2RelPFIsoDB_value

    property e2RelPFIsoRho:
        def __get__(self):
            self.e2RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.e2RelPFIsoRho_value

    property e2RelPFIsoRhoFSR:
        def __get__(self):
            self.e2RelPFIsoRhoFSR_branch.GetEntry(self.localentry, 0)
            return self.e2RelPFIsoRhoFSR_value

    property e2RhoHZG2011:
        def __get__(self):
            self.e2RhoHZG2011_branch.GetEntry(self.localentry, 0)
            return self.e2RhoHZG2011_value

    property e2RhoHZG2012:
        def __get__(self):
            self.e2RhoHZG2012_branch.GetEntry(self.localentry, 0)
            return self.e2RhoHZG2012_value

    property e2SCEnergy:
        def __get__(self):
            self.e2SCEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2SCEnergy_value

    property e2SCEta:
        def __get__(self):
            self.e2SCEta_branch.GetEntry(self.localentry, 0)
            return self.e2SCEta_value

    property e2SCEtaWidth:
        def __get__(self):
            self.e2SCEtaWidth_branch.GetEntry(self.localentry, 0)
            return self.e2SCEtaWidth_value

    property e2SCPhi:
        def __get__(self):
            self.e2SCPhi_branch.GetEntry(self.localentry, 0)
            return self.e2SCPhi_value

    property e2SCPhiWidth:
        def __get__(self):
            self.e2SCPhiWidth_branch.GetEntry(self.localentry, 0)
            return self.e2SCPhiWidth_value

    property e2SCPreshowerEnergy:
        def __get__(self):
            self.e2SCPreshowerEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2SCPreshowerEnergy_value

    property e2SCRawEnergy:
        def __get__(self):
            self.e2SCRawEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2SCRawEnergy_value

    property e2SigmaIEtaIEta:
        def __get__(self):
            self.e2SigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.e2SigmaIEtaIEta_value

    property e2ToMETDPhi:
        def __get__(self):
            self.e2ToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.e2ToMETDPhi_value

    property e2TrkIsoDR03:
        def __get__(self):
            self.e2TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2TrkIsoDR03_value

    property e2VZ:
        def __get__(self):
            self.e2VZ_branch.GetEntry(self.localentry, 0)
            return self.e2VZ_value

    property e2WWID:
        def __get__(self):
            self.e2WWID_branch.GetEntry(self.localentry, 0)
            return self.e2WWID_value

    property e2_t_CosThetaStar:
        def __get__(self):
            self.e2_t_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e2_t_CosThetaStar_value

    property e2_t_DPhi:
        def __get__(self):
            self.e2_t_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e2_t_DPhi_value

    property e2_t_DR:
        def __get__(self):
            self.e2_t_DR_branch.GetEntry(self.localentry, 0)
            return self.e2_t_DR_value

    property e2_t_Mass:
        def __get__(self):
            self.e2_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mass_value

    property e2_t_MassFsr:
        def __get__(self):
            self.e2_t_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e2_t_MassFsr_value

    property e2_t_Mass_ees_minus:
        def __get__(self):
            self.e2_t_Mass_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mass_ees_minus_value

    property e2_t_Mass_ees_plus:
        def __get__(self):
            self.e2_t_Mass_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mass_ees_plus_value

    property e2_t_Mass_tes_minus:
        def __get__(self):
            self.e2_t_Mass_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mass_tes_minus_value

    property e2_t_Mass_tes_plus:
        def __get__(self):
            self.e2_t_Mass_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mass_tes_plus_value

    property e2_t_PZeta:
        def __get__(self):
            self.e2_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e2_t_PZeta_value

    property e2_t_PZetaVis:
        def __get__(self):
            self.e2_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e2_t_PZetaVis_value

    property e2_t_Pt:
        def __get__(self):
            self.e2_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Pt_value

    property e2_t_PtFsr:
        def __get__(self):
            self.e2_t_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e2_t_PtFsr_value

    property e2_t_SS:
        def __get__(self):
            self.e2_t_SS_branch.GetEntry(self.localentry, 0)
            return self.e2_t_SS_value

    property e2_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.e2_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e2_t_ToMETDPhi_Ty1_value

    property e2_t_ToMETDPhi_jes_minus:
        def __get__(self):
            self.e2_t_ToMETDPhi_jes_minus_branch.GetEntry(self.localentry, 0)
            return self.e2_t_ToMETDPhi_jes_minus_value

    property e2_t_ToMETDPhi_jes_plus:
        def __get__(self):
            self.e2_t_ToMETDPhi_jes_plus_branch.GetEntry(self.localentry, 0)
            return self.e2_t_ToMETDPhi_jes_plus_value

    property e2_t_Zcompat:
        def __get__(self):
            self.e2_t_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Zcompat_value

    property e2dECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e2dECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrReg_2012Jul13ReReco_value

    property e2dECorrReg_Fall11:
        def __get__(self):
            self.e2dECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrReg_Fall11_value

    property e2dECorrReg_Jan16ReReco:
        def __get__(self):
            self.e2dECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrReg_Jan16ReReco_value

    property e2dECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2dECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrReg_Summer12_DR53X_HCP2012_value

    property e2dECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedNoReg_2012Jul13ReReco_value

    property e2dECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e2dECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedNoReg_Fall11_value

    property e2dECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e2dECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedNoReg_Jan16ReReco_value

    property e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e2dECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e2dECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedReg_2012Jul13ReReco_value

    property e2dECorrSmearedReg_Fall11:
        def __get__(self):
            self.e2dECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedReg_Fall11_value

    property e2dECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e2dECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedReg_Jan16ReReco_value

    property e2dECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e2deltaEtaSuperClusterTrackAtVtx:
        def __get__(self):
            self.e2deltaEtaSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e2deltaEtaSuperClusterTrackAtVtx_value

    property e2deltaPhiSuperClusterTrackAtVtx:
        def __get__(self):
            self.e2deltaPhiSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e2deltaPhiSuperClusterTrackAtVtx_value

    property e2eSuperClusterOverP:
        def __get__(self):
            self.e2eSuperClusterOverP_branch.GetEntry(self.localentry, 0)
            return self.e2eSuperClusterOverP_value

    property e2ecalEnergy:
        def __get__(self):
            self.e2ecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2ecalEnergy_value

    property e2fBrem:
        def __get__(self):
            self.e2fBrem_branch.GetEntry(self.localentry, 0)
            return self.e2fBrem_value

    property e2trackMomentumAtVtxP:
        def __get__(self):
            self.e2trackMomentumAtVtxP_branch.GetEntry(self.localentry, 0)
            return self.e2trackMomentumAtVtxP_value

    property eVetoCicLooseIso:
        def __get__(self):
            self.eVetoCicLooseIso_branch.GetEntry(self.localentry, 0)
            return self.eVetoCicLooseIso_value

    property eVetoCicLooseIso_ees_minus:
        def __get__(self):
            self.eVetoCicLooseIso_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.eVetoCicLooseIso_ees_minus_value

    property eVetoCicLooseIso_ees_plus:
        def __get__(self):
            self.eVetoCicLooseIso_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.eVetoCicLooseIso_ees_plus_value

    property eVetoCicTightIso:
        def __get__(self):
            self.eVetoCicTightIso_branch.GetEntry(self.localentry, 0)
            return self.eVetoCicTightIso_value

    property eVetoCicTightIso_ees_minus:
        def __get__(self):
            self.eVetoCicTightIso_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.eVetoCicTightIso_ees_minus_value

    property eVetoCicTightIso_ees_plus:
        def __get__(self):
            self.eVetoCicTightIso_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.eVetoCicTightIso_ees_plus_value

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

    property isZtautau:
        def __get__(self):
            self.isZtautau_branch.GetEntry(self.localentry, 0)
            return self.isZtautau_value

    property isdata:
        def __get__(self):
            self.isdata_branch.GetEntry(self.localentry, 0)
            return self.isdata_value

    property isoMu24eta2p1Group:
        def __get__(self):
            self.isoMu24eta2p1Group_branch.GetEntry(self.localentry, 0)
            return self.isoMu24eta2p1Group_value

    property isoMu24eta2p1Pass:
        def __get__(self):
            self.isoMu24eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.isoMu24eta2p1Pass_value

    property isoMu24eta2p1Prescale:
        def __get__(self):
            self.isoMu24eta2p1Prescale_branch.GetEntry(self.localentry, 0)
            return self.isoMu24eta2p1Prescale_value

    property isoMuGroup:
        def __get__(self):
            self.isoMuGroup_branch.GetEntry(self.localentry, 0)
            return self.isoMuGroup_value

    property isoMuPass:
        def __get__(self):
            self.isoMuPass_branch.GetEntry(self.localentry, 0)
            return self.isoMuPass_value

    property isoMuPrescale:
        def __get__(self):
            self.isoMuPrescale_branch.GetEntry(self.localentry, 0)
            return self.isoMuPrescale_value

    property isoMuTauGroup:
        def __get__(self):
            self.isoMuTauGroup_branch.GetEntry(self.localentry, 0)
            return self.isoMuTauGroup_value

    property isoMuTauPass:
        def __get__(self):
            self.isoMuTauPass_branch.GetEntry(self.localentry, 0)
            return self.isoMuTauPass_value

    property isoMuTauPrescale:
        def __get__(self):
            self.isoMuTauPrescale_branch.GetEntry(self.localentry, 0)
            return self.isoMuTauPrescale_value

    property jetVeto20:
        def __get__(self):
            self.jetVeto20_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_value

    property jetVeto20_DR05:
        def __get__(self):
            self.jetVeto20_DR05_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_DR05_value

    property jetVeto20jes_minus:
        def __get__(self):
            self.jetVeto20jes_minus_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20jes_minus_value

    property jetVeto20jes_plus:
        def __get__(self):
            self.jetVeto20jes_plus_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20jes_plus_value

    property jetVeto30:
        def __get__(self):
            self.jetVeto30_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_value

    property jetVeto30_DR05:
        def __get__(self):
            self.jetVeto30_DR05_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_DR05_value

    property jetVeto30jes_minus:
        def __get__(self):
            self.jetVeto30jes_minus_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30jes_minus_value

    property jetVeto30jes_plus:
        def __get__(self):
            self.jetVeto30jes_plus_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30jes_plus_value

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

    property mu17ele8Group:
        def __get__(self):
            self.mu17ele8Group_branch.GetEntry(self.localentry, 0)
            return self.mu17ele8Group_value

    property mu17ele8Pass:
        def __get__(self):
            self.mu17ele8Pass_branch.GetEntry(self.localentry, 0)
            return self.mu17ele8Pass_value

    property mu17ele8Prescale:
        def __get__(self):
            self.mu17ele8Prescale_branch.GetEntry(self.localentry, 0)
            return self.mu17ele8Prescale_value

    property mu17ele8isoGroup:
        def __get__(self):
            self.mu17ele8isoGroup_branch.GetEntry(self.localentry, 0)
            return self.mu17ele8isoGroup_value

    property mu17ele8isoPass:
        def __get__(self):
            self.mu17ele8isoPass_branch.GetEntry(self.localentry, 0)
            return self.mu17ele8isoPass_value

    property mu17ele8isoPrescale:
        def __get__(self):
            self.mu17ele8isoPrescale_branch.GetEntry(self.localentry, 0)
            return self.mu17ele8isoPrescale_value

    property mu17mu8Group:
        def __get__(self):
            self.mu17mu8Group_branch.GetEntry(self.localentry, 0)
            return self.mu17mu8Group_value

    property mu17mu8Pass:
        def __get__(self):
            self.mu17mu8Pass_branch.GetEntry(self.localentry, 0)
            return self.mu17mu8Pass_value

    property mu17mu8Prescale:
        def __get__(self):
            self.mu17mu8Prescale_branch.GetEntry(self.localentry, 0)
            return self.mu17mu8Prescale_value

    property mu8ele17Group:
        def __get__(self):
            self.mu8ele17Group_branch.GetEntry(self.localentry, 0)
            return self.mu8ele17Group_value

    property mu8ele17Pass:
        def __get__(self):
            self.mu8ele17Pass_branch.GetEntry(self.localentry, 0)
            return self.mu8ele17Pass_value

    property mu8ele17Prescale:
        def __get__(self):
            self.mu8ele17Prescale_branch.GetEntry(self.localentry, 0)
            return self.mu8ele17Prescale_value

    property mu8ele17isoGroup:
        def __get__(self):
            self.mu8ele17isoGroup_branch.GetEntry(self.localentry, 0)
            return self.mu8ele17isoGroup_value

    property mu8ele17isoPass:
        def __get__(self):
            self.mu8ele17isoPass_branch.GetEntry(self.localentry, 0)
            return self.mu8ele17isoPass_value

    property mu8ele17isoPrescale:
        def __get__(self):
            self.mu8ele17isoPrescale_branch.GetEntry(self.localentry, 0)
            return self.mu8ele17isoPrescale_value

    property muGlbIsoVetoPt10:
        def __get__(self):
            self.muGlbIsoVetoPt10_branch.GetEntry(self.localentry, 0)
            return self.muGlbIsoVetoPt10_value

    property muTauGroup:
        def __get__(self):
            self.muTauGroup_branch.GetEntry(self.localentry, 0)
            return self.muTauGroup_value

    property muTauPass:
        def __get__(self):
            self.muTauPass_branch.GetEntry(self.localentry, 0)
            return self.muTauPass_value

    property muTauPrescale:
        def __get__(self):
            self.muTauPrescale_branch.GetEntry(self.localentry, 0)
            return self.muTauPrescale_value

    property muTauTestGroup:
        def __get__(self):
            self.muTauTestGroup_branch.GetEntry(self.localentry, 0)
            return self.muTauTestGroup_value

    property muTauTestPass:
        def __get__(self):
            self.muTauTestPass_branch.GetEntry(self.localentry, 0)
            return self.muTauTestPass_value

    property muTauTestPrescale:
        def __get__(self):
            self.muTauTestPrescale_branch.GetEntry(self.localentry, 0)
            return self.muTauTestPrescale_value

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

    property muVetoPt5IsoIdVtx_mes_minus:
        def __get__(self):
            self.muVetoPt5IsoIdVtx_mes_minus_branch.GetEntry(self.localentry, 0)
            return self.muVetoPt5IsoIdVtx_mes_minus_value

    property muVetoPt5IsoIdVtx_mes_plus:
        def __get__(self):
            self.muVetoPt5IsoIdVtx_mes_plus_branch.GetEntry(self.localentry, 0)
            return self.muVetoPt5IsoIdVtx_mes_plus_value

    property mva_met_Et:
        def __get__(self):
            self.mva_met_Et_branch.GetEntry(self.localentry, 0)
            return self.mva_met_Et_value

    property mva_met_Phi:
        def __get__(self):
            self.mva_met_Phi_branch.GetEntry(self.localentry, 0)
            return self.mva_met_Phi_value

    property nTruePU:
        def __get__(self):
            self.nTruePU_branch.GetEntry(self.localentry, 0)
            return self.nTruePU_value

    property nvtx:
        def __get__(self):
            self.nvtx_branch.GetEntry(self.localentry, 0)
            return self.nvtx_value

    property pfMet_Et:
        def __get__(self):
            self.pfMet_Et_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Et_value

    property pfMet_Et_ees_minus:
        def __get__(self):
            self.pfMet_Et_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Et_ees_minus_value

    property pfMet_Et_ees_plus:
        def __get__(self):
            self.pfMet_Et_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Et_ees_plus_value

    property pfMet_Et_jes_minus:
        def __get__(self):
            self.pfMet_Et_jes_minus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Et_jes_minus_value

    property pfMet_Et_jes_plus:
        def __get__(self):
            self.pfMet_Et_jes_plus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Et_jes_plus_value

    property pfMet_Et_mes_minus:
        def __get__(self):
            self.pfMet_Et_mes_minus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Et_mes_minus_value

    property pfMet_Et_mes_plus:
        def __get__(self):
            self.pfMet_Et_mes_plus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Et_mes_plus_value

    property pfMet_Et_tes_minus:
        def __get__(self):
            self.pfMet_Et_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Et_tes_minus_value

    property pfMet_Et_tes_plus:
        def __get__(self):
            self.pfMet_Et_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Et_tes_plus_value

    property pfMet_Et_ues_minus:
        def __get__(self):
            self.pfMet_Et_ues_minus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Et_ues_minus_value

    property pfMet_Et_ues_plus:
        def __get__(self):
            self.pfMet_Et_ues_plus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Et_ues_plus_value

    property pfMet_Phi:
        def __get__(self):
            self.pfMet_Phi_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Phi_value

    property pfMet_Phi_ees_minus:
        def __get__(self):
            self.pfMet_Phi_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Phi_ees_minus_value

    property pfMet_Phi_ees_plus:
        def __get__(self):
            self.pfMet_Phi_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Phi_ees_plus_value

    property pfMet_Phi_jes_minus:
        def __get__(self):
            self.pfMet_Phi_jes_minus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Phi_jes_minus_value

    property pfMet_Phi_jes_plus:
        def __get__(self):
            self.pfMet_Phi_jes_plus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Phi_jes_plus_value

    property pfMet_Phi_mes_minus:
        def __get__(self):
            self.pfMet_Phi_mes_minus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Phi_mes_minus_value

    property pfMet_Phi_mes_plus:
        def __get__(self):
            self.pfMet_Phi_mes_plus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Phi_mes_plus_value

    property pfMet_Phi_tes_minus:
        def __get__(self):
            self.pfMet_Phi_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Phi_tes_minus_value

    property pfMet_Phi_tes_plus:
        def __get__(self):
            self.pfMet_Phi_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Phi_tes_plus_value

    property pfMet_Phi_ues_minus:
        def __get__(self):
            self.pfMet_Phi_ues_minus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Phi_ues_minus_value

    property pfMet_Phi_ues_plus:
        def __get__(self):
            self.pfMet_Phi_ues_plus_branch.GetEntry(self.localentry, 0)
            return self.pfMet_Phi_ues_plus_value

    property pfMet_diff_Et:
        def __get__(self):
            self.pfMet_diff_Et_branch.GetEntry(self.localentry, 0)
            return self.pfMet_diff_Et_value

    property pfMet_jes_Et:
        def __get__(self):
            self.pfMet_jes_Et_branch.GetEntry(self.localentry, 0)
            return self.pfMet_jes_Et_value

    property pfMet_jes_Phi:
        def __get__(self):
            self.pfMet_jes_Phi_branch.GetEntry(self.localentry, 0)
            return self.pfMet_jes_Phi_value

    property pfMet_ues_AtanToPhi:
        def __get__(self):
            self.pfMet_ues_AtanToPhi_branch.GetEntry(self.localentry, 0)
            return self.pfMet_ues_AtanToPhi_value

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

    property singleE27WP80Group:
        def __get__(self):
            self.singleE27WP80Group_branch.GetEntry(self.localentry, 0)
            return self.singleE27WP80Group_value

    property singleE27WP80Pass:
        def __get__(self):
            self.singleE27WP80Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE27WP80Pass_value

    property singleE27WP80Prescale:
        def __get__(self):
            self.singleE27WP80Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE27WP80Prescale_value

    property singleEGroup:
        def __get__(self):
            self.singleEGroup_branch.GetEntry(self.localentry, 0)
            return self.singleEGroup_value

    property singleEPFMTGroup:
        def __get__(self):
            self.singleEPFMTGroup_branch.GetEntry(self.localentry, 0)
            return self.singleEPFMTGroup_value

    property singleEPFMTPass:
        def __get__(self):
            self.singleEPFMTPass_branch.GetEntry(self.localentry, 0)
            return self.singleEPFMTPass_value

    property singleEPFMTPrescale:
        def __get__(self):
            self.singleEPFMTPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleEPFMTPrescale_value

    property singleEPass:
        def __get__(self):
            self.singleEPass_branch.GetEntry(self.localentry, 0)
            return self.singleEPass_value

    property singleEPrescale:
        def __get__(self):
            self.singleEPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleEPrescale_value

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

    property singlePhoGroup:
        def __get__(self):
            self.singlePhoGroup_branch.GetEntry(self.localentry, 0)
            return self.singlePhoGroup_value

    property singlePhoPass:
        def __get__(self):
            self.singlePhoPass_branch.GetEntry(self.localentry, 0)
            return self.singlePhoPass_value

    property singlePhoPrescale:
        def __get__(self):
            self.singlePhoPrescale_branch.GetEntry(self.localentry, 0)
            return self.singlePhoPrescale_value

    property tAbsEta:
        def __get__(self):
            self.tAbsEta_branch.GetEntry(self.localentry, 0)
            return self.tAbsEta_value

    property tAntiElectronLoose:
        def __get__(self):
            self.tAntiElectronLoose_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronLoose_value

    property tAntiElectronMVA5Loose:
        def __get__(self):
            self.tAntiElectronMVA5Loose_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronMVA5Loose_value

    property tAntiElectronMVA5Medium:
        def __get__(self):
            self.tAntiElectronMVA5Medium_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronMVA5Medium_value

    property tAntiElectronMVA5Tight:
        def __get__(self):
            self.tAntiElectronMVA5Tight_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronMVA5Tight_value

    property tAntiElectronMVA5VLoose:
        def __get__(self):
            self.tAntiElectronMVA5VLoose_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronMVA5VLoose_value

    property tAntiElectronMVA5VTight:
        def __get__(self):
            self.tAntiElectronMVA5VTight_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronMVA5VTight_value

    property tAntiElectronMedium:
        def __get__(self):
            self.tAntiElectronMedium_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronMedium_value

    property tAntiElectronTight:
        def __get__(self):
            self.tAntiElectronTight_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronTight_value

    property tAntiMuon2Loose:
        def __get__(self):
            self.tAntiMuon2Loose_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuon2Loose_value

    property tAntiMuon2Medium:
        def __get__(self):
            self.tAntiMuon2Medium_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuon2Medium_value

    property tAntiMuon2Tight:
        def __get__(self):
            self.tAntiMuon2Tight_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuon2Tight_value

    property tAntiMuon3Loose:
        def __get__(self):
            self.tAntiMuon3Loose_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuon3Loose_value

    property tAntiMuon3Tight:
        def __get__(self):
            self.tAntiMuon3Tight_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuon3Tight_value

    property tAntiMuonLoose:
        def __get__(self):
            self.tAntiMuonLoose_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuonLoose_value

    property tAntiMuonMVALoose:
        def __get__(self):
            self.tAntiMuonMVALoose_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuonMVALoose_value

    property tAntiMuonMVAMedium:
        def __get__(self):
            self.tAntiMuonMVAMedium_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuonMVAMedium_value

    property tAntiMuonMVATight:
        def __get__(self):
            self.tAntiMuonMVATight_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuonMVATight_value

    property tAntiMuonMedium:
        def __get__(self):
            self.tAntiMuonMedium_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuonMedium_value

    property tAntiMuonTight:
        def __get__(self):
            self.tAntiMuonTight_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuonTight_value

    property tCharge:
        def __get__(self):
            self.tCharge_branch.GetEntry(self.localentry, 0)
            return self.tCharge_value

    property tCiCTightElecOverlap:
        def __get__(self):
            self.tCiCTightElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.tCiCTightElecOverlap_value

    property tComesFromHiggs:
        def __get__(self):
            self.tComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.tComesFromHiggs_value

    property tDZ:
        def __get__(self):
            self.tDZ_branch.GetEntry(self.localentry, 0)
            return self.tDZ_value

    property tDecayFinding:
        def __get__(self):
            self.tDecayFinding_branch.GetEntry(self.localentry, 0)
            return self.tDecayFinding_value

    property tDecayFindingNewDMs:
        def __get__(self):
            self.tDecayFindingNewDMs_branch.GetEntry(self.localentry, 0)
            return self.tDecayFindingNewDMs_value

    property tDecayFindingOldDMs:
        def __get__(self):
            self.tDecayFindingOldDMs_branch.GetEntry(self.localentry, 0)
            return self.tDecayFindingOldDMs_value

    property tDecayMode:
        def __get__(self):
            self.tDecayMode_branch.GetEntry(self.localentry, 0)
            return self.tDecayMode_value

    property tElecOverlap:
        def __get__(self):
            self.tElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.tElecOverlap_value

    property tElectronPt10IdIsoVtxOverlap:
        def __get__(self):
            self.tElectronPt10IdIsoVtxOverlap_branch.GetEntry(self.localentry, 0)
            return self.tElectronPt10IdIsoVtxOverlap_value

    property tElectronPt10IdVtxOverlap:
        def __get__(self):
            self.tElectronPt10IdVtxOverlap_branch.GetEntry(self.localentry, 0)
            return self.tElectronPt10IdVtxOverlap_value

    property tElectronPt15IdIsoVtxOverlap:
        def __get__(self):
            self.tElectronPt15IdIsoVtxOverlap_branch.GetEntry(self.localentry, 0)
            return self.tElectronPt15IdIsoVtxOverlap_value

    property tElectronPt15IdVtxOverlap:
        def __get__(self):
            self.tElectronPt15IdVtxOverlap_branch.GetEntry(self.localentry, 0)
            return self.tElectronPt15IdVtxOverlap_value

    property tEta:
        def __get__(self):
            self.tEta_branch.GetEntry(self.localentry, 0)
            return self.tEta_value

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

    property tGenPx:
        def __get__(self):
            self.tGenPx_branch.GetEntry(self.localentry, 0)
            return self.tGenPx_value

    property tGenPy:
        def __get__(self):
            self.tGenPy_branch.GetEntry(self.localentry, 0)
            return self.tGenPy_value

    property tGenPz:
        def __get__(self):
            self.tGenPz_branch.GetEntry(self.localentry, 0)
            return self.tGenPz_value

    property tGlobalMuonVtxOverlap:
        def __get__(self):
            self.tGlobalMuonVtxOverlap_branch.GetEntry(self.localentry, 0)
            return self.tGlobalMuonVtxOverlap_value

    property tIP3DS:
        def __get__(self):
            self.tIP3DS_branch.GetEntry(self.localentry, 0)
            return self.tIP3DS_value

    property tJetArea:
        def __get__(self):
            self.tJetArea_branch.GetEntry(self.localentry, 0)
            return self.tJetArea_value

    property tJetBtag:
        def __get__(self):
            self.tJetBtag_branch.GetEntry(self.localentry, 0)
            return self.tJetBtag_value

    property tJetCSVBtag:
        def __get__(self):
            self.tJetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.tJetCSVBtag_value

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

    property tJetPhiPhiMoment:
        def __get__(self):
            self.tJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetPhiPhiMoment_value

    property tJetPt:
        def __get__(self):
            self.tJetPt_branch.GetEntry(self.localentry, 0)
            return self.tJetPt_value

    property tJetQGLikelihoodID:
        def __get__(self):
            self.tJetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.tJetQGLikelihoodID_value

    property tJetQGMVAID:
        def __get__(self):
            self.tJetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.tJetQGMVAID_value

    property tLeadTrackPt:
        def __get__(self):
            self.tLeadTrackPt_branch.GetEntry(self.localentry, 0)
            return self.tLeadTrackPt_value

    property tLooseIso:
        def __get__(self):
            self.tLooseIso_branch.GetEntry(self.localentry, 0)
            return self.tLooseIso_value

    property tLooseIso3Hits:
        def __get__(self):
            self.tLooseIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.tLooseIso3Hits_value

    property tLooseIsoMVA3NewDMLT:
        def __get__(self):
            self.tLooseIsoMVA3NewDMLT_branch.GetEntry(self.localentry, 0)
            return self.tLooseIsoMVA3NewDMLT_value

    property tLooseIsoMVA3NewDMNoLT:
        def __get__(self):
            self.tLooseIsoMVA3NewDMNoLT_branch.GetEntry(self.localentry, 0)
            return self.tLooseIsoMVA3NewDMNoLT_value

    property tLooseIsoMVA3OldDMLT:
        def __get__(self):
            self.tLooseIsoMVA3OldDMLT_branch.GetEntry(self.localentry, 0)
            return self.tLooseIsoMVA3OldDMLT_value

    property tLooseIsoMVA3OldDMNoLT:
        def __get__(self):
            self.tLooseIsoMVA3OldDMNoLT_branch.GetEntry(self.localentry, 0)
            return self.tLooseIsoMVA3OldDMNoLT_value

    property tMass:
        def __get__(self):
            self.tMass_branch.GetEntry(self.localentry, 0)
            return self.tMass_value

    property tMediumIso:
        def __get__(self):
            self.tMediumIso_branch.GetEntry(self.localentry, 0)
            return self.tMediumIso_value

    property tMediumIso3Hits:
        def __get__(self):
            self.tMediumIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.tMediumIso3Hits_value

    property tMediumIsoMVA3NewDMLT:
        def __get__(self):
            self.tMediumIsoMVA3NewDMLT_branch.GetEntry(self.localentry, 0)
            return self.tMediumIsoMVA3NewDMLT_value

    property tMediumIsoMVA3NewDMNoLT:
        def __get__(self):
            self.tMediumIsoMVA3NewDMNoLT_branch.GetEntry(self.localentry, 0)
            return self.tMediumIsoMVA3NewDMNoLT_value

    property tMediumIsoMVA3OldDMLT:
        def __get__(self):
            self.tMediumIsoMVA3OldDMLT_branch.GetEntry(self.localentry, 0)
            return self.tMediumIsoMVA3OldDMLT_value

    property tMediumIsoMVA3OldDMNoLT:
        def __get__(self):
            self.tMediumIsoMVA3OldDMNoLT_branch.GetEntry(self.localentry, 0)
            return self.tMediumIsoMVA3OldDMNoLT_value

    property tMtToMET:
        def __get__(self):
            self.tMtToMET_branch.GetEntry(self.localentry, 0)
            return self.tMtToMET_value

    property tMtToMVAMET:
        def __get__(self):
            self.tMtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.tMtToMVAMET_value

    property tMtToPfMet:
        def __get__(self):
            self.tMtToPfMet_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_value

    property tMtToPfMet_Ty1:
        def __get__(self):
            self.tMtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_Ty1_value

    property tMtToPfMet_ees:
        def __get__(self):
            self.tMtToPfMet_ees_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_ees_value

    property tMtToPfMet_ees_minus:
        def __get__(self):
            self.tMtToPfMet_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_ees_minus_value

    property tMtToPfMet_ees_plus:
        def __get__(self):
            self.tMtToPfMet_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_ees_plus_value

    property tMtToPfMet_jes:
        def __get__(self):
            self.tMtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_jes_value

    property tMtToPfMet_jes_minus:
        def __get__(self):
            self.tMtToPfMet_jes_minus_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_jes_minus_value

    property tMtToPfMet_jes_plus:
        def __get__(self):
            self.tMtToPfMet_jes_plus_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_jes_plus_value

    property tMtToPfMet_mes:
        def __get__(self):
            self.tMtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_mes_value

    property tMtToPfMet_mes_minus:
        def __get__(self):
            self.tMtToPfMet_mes_minus_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_mes_minus_value

    property tMtToPfMet_mes_plus:
        def __get__(self):
            self.tMtToPfMet_mes_plus_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_mes_plus_value

    property tMtToPfMet_tes:
        def __get__(self):
            self.tMtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_tes_value

    property tMtToPfMet_tes_minus:
        def __get__(self):
            self.tMtToPfMet_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_tes_minus_value

    property tMtToPfMet_tes_plus:
        def __get__(self):
            self.tMtToPfMet_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_tes_plus_value

    property tMtToPfMet_ues:
        def __get__(self):
            self.tMtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_ues_value

    property tMtToPfMet_ues_minus:
        def __get__(self):
            self.tMtToPfMet_ues_minus_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_ues_minus_value

    property tMtToPfMet_ues_plus:
        def __get__(self):
            self.tMtToPfMet_ues_plus_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_ues_plus_value

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

    property tPhi:
        def __get__(self):
            self.tPhi_branch.GetEntry(self.localentry, 0)
            return self.tPhi_value

    property tPt:
        def __get__(self):
            self.tPt_branch.GetEntry(self.localentry, 0)
            return self.tPt_value

    property tPt_ees_minus:
        def __get__(self):
            self.tPt_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.tPt_ees_minus_value

    property tPt_ees_plus:
        def __get__(self):
            self.tPt_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.tPt_ees_plus_value

    property tPt_tes_minus:
        def __get__(self):
            self.tPt_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.tPt_tes_minus_value

    property tPt_tes_plus:
        def __get__(self):
            self.tPt_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.tPt_tes_plus_value

    property tRank:
        def __get__(self):
            self.tRank_branch.GetEntry(self.localentry, 0)
            return self.tRank_value

    property tRawIso3Hits:
        def __get__(self):
            self.tRawIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.tRawIso3Hits_value

    property tTNPId:
        def __get__(self):
            self.tTNPId_branch.GetEntry(self.localentry, 0)
            return self.tTNPId_value

    property tTightIso:
        def __get__(self):
            self.tTightIso_branch.GetEntry(self.localentry, 0)
            return self.tTightIso_value

    property tTightIso3Hits:
        def __get__(self):
            self.tTightIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.tTightIso3Hits_value

    property tTightIsoMVA3NewDMLT:
        def __get__(self):
            self.tTightIsoMVA3NewDMLT_branch.GetEntry(self.localentry, 0)
            return self.tTightIsoMVA3NewDMLT_value

    property tTightIsoMVA3NewDMNoLT:
        def __get__(self):
            self.tTightIsoMVA3NewDMNoLT_branch.GetEntry(self.localentry, 0)
            return self.tTightIsoMVA3NewDMNoLT_value

    property tTightIsoMVA3OldDMLT:
        def __get__(self):
            self.tTightIsoMVA3OldDMLT_branch.GetEntry(self.localentry, 0)
            return self.tTightIsoMVA3OldDMLT_value

    property tTightIsoMVA3OldDMNoLT:
        def __get__(self):
            self.tTightIsoMVA3OldDMNoLT_branch.GetEntry(self.localentry, 0)
            return self.tTightIsoMVA3OldDMNoLT_value

    property tToMETDPhi:
        def __get__(self):
            self.tToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.tToMETDPhi_value

    property tVLooseIso:
        def __get__(self):
            self.tVLooseIso_branch.GetEntry(self.localentry, 0)
            return self.tVLooseIso_value

    property tVLooseIsoMVA3NewDMLT:
        def __get__(self):
            self.tVLooseIsoMVA3NewDMLT_branch.GetEntry(self.localentry, 0)
            return self.tVLooseIsoMVA3NewDMLT_value

    property tVLooseIsoMVA3NewDMNoLT:
        def __get__(self):
            self.tVLooseIsoMVA3NewDMNoLT_branch.GetEntry(self.localentry, 0)
            return self.tVLooseIsoMVA3NewDMNoLT_value

    property tVLooseIsoMVA3OldDMLT:
        def __get__(self):
            self.tVLooseIsoMVA3OldDMLT_branch.GetEntry(self.localentry, 0)
            return self.tVLooseIsoMVA3OldDMLT_value

    property tVLooseIsoMVA3OldDMNoLT:
        def __get__(self):
            self.tVLooseIsoMVA3OldDMNoLT_branch.GetEntry(self.localentry, 0)
            return self.tVLooseIsoMVA3OldDMNoLT_value

    property tVTightIsoMVA3NewDMLT:
        def __get__(self):
            self.tVTightIsoMVA3NewDMLT_branch.GetEntry(self.localentry, 0)
            return self.tVTightIsoMVA3NewDMLT_value

    property tVTightIsoMVA3NewDMNoLT:
        def __get__(self):
            self.tVTightIsoMVA3NewDMNoLT_branch.GetEntry(self.localentry, 0)
            return self.tVTightIsoMVA3NewDMNoLT_value

    property tVTightIsoMVA3OldDMLT:
        def __get__(self):
            self.tVTightIsoMVA3OldDMLT_branch.GetEntry(self.localentry, 0)
            return self.tVTightIsoMVA3OldDMLT_value

    property tVTightIsoMVA3OldDMNoLT:
        def __get__(self):
            self.tVTightIsoMVA3OldDMNoLT_branch.GetEntry(self.localentry, 0)
            return self.tVTightIsoMVA3OldDMNoLT_value

    property tVVTightIsoMVA3NewDMLT:
        def __get__(self):
            self.tVVTightIsoMVA3NewDMLT_branch.GetEntry(self.localentry, 0)
            return self.tVVTightIsoMVA3NewDMLT_value

    property tVVTightIsoMVA3NewDMNoLT:
        def __get__(self):
            self.tVVTightIsoMVA3NewDMNoLT_branch.GetEntry(self.localentry, 0)
            return self.tVVTightIsoMVA3NewDMNoLT_value

    property tVVTightIsoMVA3OldDMLT:
        def __get__(self):
            self.tVVTightIsoMVA3OldDMLT_branch.GetEntry(self.localentry, 0)
            return self.tVVTightIsoMVA3OldDMLT_value

    property tVVTightIsoMVA3OldDMNoLT:
        def __get__(self):
            self.tVVTightIsoMVA3OldDMNoLT_branch.GetEntry(self.localentry, 0)
            return self.tVVTightIsoMVA3OldDMNoLT_value

    property tVZ:
        def __get__(self):
            self.tVZ_branch.GetEntry(self.localentry, 0)
            return self.tVZ_value

    property tauVetoPt20EleLoose3MuTight:
        def __get__(self):
            self.tauVetoPt20EleLoose3MuTight_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20EleLoose3MuTight_value

    property tauVetoPt20EleLoose3MuTight_tes_minus:
        def __get__(self):
            self.tauVetoPt20EleLoose3MuTight_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20EleLoose3MuTight_tes_minus_value

    property tauVetoPt20EleLoose3MuTight_tes_plus:
        def __get__(self):
            self.tauVetoPt20EleLoose3MuTight_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20EleLoose3MuTight_tes_plus_value

    property tauVetoPt20EleTight3MuLoose:
        def __get__(self):
            self.tauVetoPt20EleTight3MuLoose_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20EleTight3MuLoose_value

    property tauVetoPt20EleTight3MuLoose_tes_minus:
        def __get__(self):
            self.tauVetoPt20EleTight3MuLoose_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20EleTight3MuLoose_tes_minus_value

    property tauVetoPt20EleTight3MuLoose_tes_plus:
        def __get__(self):
            self.tauVetoPt20EleTight3MuLoose_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20EleTight3MuLoose_tes_plus_value

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

    property tauVetoPt20TightMVANewDMVtx:
        def __get__(self):
            self.tauVetoPt20TightMVANewDMVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20TightMVANewDMVtx_value

    property tauVetoPt20TightMVAVtx:
        def __get__(self):
            self.tauVetoPt20TightMVAVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20TightMVAVtx_value

    property tauVetoPt20VLooseHPSNewDMVtx:
        def __get__(self):
            self.tauVetoPt20VLooseHPSNewDMVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20VLooseHPSNewDMVtx_value

    property tauVetoPt20VLooseHPSVtx:
        def __get__(self):
            self.tauVetoPt20VLooseHPSVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20VLooseHPSVtx_value

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

    property type1_pfMet_Et:
        def __get__(self):
            self.type1_pfMet_Et_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_Et_value

    property type1_pfMet_Et_ues_minus:
        def __get__(self):
            self.type1_pfMet_Et_ues_minus_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_Et_ues_minus_value

    property type1_pfMet_Et_ues_plus:
        def __get__(self):
            self.type1_pfMet_Et_ues_plus_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_Et_ues_plus_value

    property type1_pfMet_Phi:
        def __get__(self):
            self.type1_pfMet_Phi_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_Phi_value

    property type1_pfMet_Pt:
        def __get__(self):
            self.type1_pfMet_Pt_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_Pt_value

    property idx:
        def __get__(self):
            self.idx_branch.GetEntry(self.localentry, 0)
            return self.idx_value


