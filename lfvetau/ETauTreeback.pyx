

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

cdef class ETauTree:
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

    cdef TBranch* eAbsEta_branch
    cdef float eAbsEta_value

    cdef TBranch* eCBID_LOOSE_branch
    cdef float eCBID_LOOSE_value

    cdef TBranch* eCBID_MEDIUM_branch
    cdef float eCBID_MEDIUM_value

    cdef TBranch* eCBID_TIGHT_branch
    cdef float eCBID_TIGHT_value

    cdef TBranch* eCBID_VETO_branch
    cdef float eCBID_VETO_value

    cdef TBranch* eCharge_branch
    cdef float eCharge_value

    cdef TBranch* eChargeIdLoose_branch
    cdef float eChargeIdLoose_value

    cdef TBranch* eChargeIdMed_branch
    cdef float eChargeIdMed_value

    cdef TBranch* eChargeIdTight_branch
    cdef float eChargeIdTight_value

    cdef TBranch* eCiCTight_branch
    cdef float eCiCTight_value

    cdef TBranch* eComesFromHiggs_branch
    cdef float eComesFromHiggs_value

    cdef TBranch* eDZ_branch
    cdef float eDZ_value

    cdef TBranch* eE1x5_branch
    cdef float eE1x5_value

    cdef TBranch* eE2x5Max_branch
    cdef float eE2x5Max_value

    cdef TBranch* eE5x5_branch
    cdef float eE5x5_value

    cdef TBranch* eECorrReg_2012Jul13ReReco_branch
    cdef float eECorrReg_2012Jul13ReReco_value

    cdef TBranch* eECorrReg_Fall11_branch
    cdef float eECorrReg_Fall11_value

    cdef TBranch* eECorrReg_Jan16ReReco_branch
    cdef float eECorrReg_Jan16ReReco_value

    cdef TBranch* eECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float eECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float eECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* eECorrSmearedNoReg_Fall11_branch
    cdef float eECorrSmearedNoReg_Fall11_value

    cdef TBranch* eECorrSmearedNoReg_Jan16ReReco_branch
    cdef float eECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float eECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eECorrSmearedReg_2012Jul13ReReco_branch
    cdef float eECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* eECorrSmearedReg_Fall11_branch
    cdef float eECorrSmearedReg_Fall11_value

    cdef TBranch* eECorrSmearedReg_Jan16ReReco_branch
    cdef float eECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* eECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float eECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eEcalIsoDR03_branch
    cdef float eEcalIsoDR03_value

    cdef TBranch* eEffectiveArea2011Data_branch
    cdef float eEffectiveArea2011Data_value

    cdef TBranch* eEffectiveArea2012Data_branch
    cdef float eEffectiveArea2012Data_value

    cdef TBranch* eEffectiveAreaFall11MC_branch
    cdef float eEffectiveAreaFall11MC_value

    cdef TBranch* eEle27WP80PFMT50PFMTFilter_branch
    cdef float eEle27WP80PFMT50PFMTFilter_value

    cdef TBranch* eEle27WP80TrackIsoMatchFilter_branch
    cdef float eEle27WP80TrackIsoMatchFilter_value

    cdef TBranch* eEle32WP70PFMT50PFMTFilter_branch
    cdef float eEle32WP70PFMT50PFMTFilter_value

    cdef TBranch* eEnergyError_branch
    cdef float eEnergyError_value

    cdef TBranch* eEta_branch
    cdef float eEta_value

    cdef TBranch* eEtaCorrReg_2012Jul13ReReco_branch
    cdef float eEtaCorrReg_2012Jul13ReReco_value

    cdef TBranch* eEtaCorrReg_Fall11_branch
    cdef float eEtaCorrReg_Fall11_value

    cdef TBranch* eEtaCorrReg_Jan16ReReco_branch
    cdef float eEtaCorrReg_Jan16ReReco_value

    cdef TBranch* eEtaCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float eEtaCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eEtaCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float eEtaCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* eEtaCorrSmearedNoReg_Fall11_branch
    cdef float eEtaCorrSmearedNoReg_Fall11_value

    cdef TBranch* eEtaCorrSmearedNoReg_Jan16ReReco_branch
    cdef float eEtaCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eEtaCorrSmearedReg_2012Jul13ReReco_branch
    cdef float eEtaCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* eEtaCorrSmearedReg_Fall11_branch
    cdef float eEtaCorrSmearedReg_Fall11_value

    cdef TBranch* eEtaCorrSmearedReg_Jan16ReReco_branch
    cdef float eEtaCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eGenCharge_branch
    cdef float eGenCharge_value

    cdef TBranch* eGenEnergy_branch
    cdef float eGenEnergy_value

    cdef TBranch* eGenEta_branch
    cdef float eGenEta_value

    cdef TBranch* eGenMotherPdgId_branch
    cdef float eGenMotherPdgId_value

    cdef TBranch* eGenPdgId_branch
    cdef float eGenPdgId_value

    cdef TBranch* eGenPhi_branch
    cdef float eGenPhi_value

    cdef TBranch* eHadronicDepth1OverEm_branch
    cdef float eHadronicDepth1OverEm_value

    cdef TBranch* eHadronicDepth2OverEm_branch
    cdef float eHadronicDepth2OverEm_value

    cdef TBranch* eHadronicOverEM_branch
    cdef float eHadronicOverEM_value

    cdef TBranch* eHasConversion_branch
    cdef float eHasConversion_value

    cdef TBranch* eHasMatchedConversion_branch
    cdef int eHasMatchedConversion_value

    cdef TBranch* eHcalIsoDR03_branch
    cdef float eHcalIsoDR03_value

    cdef TBranch* eIP3DS_branch
    cdef float eIP3DS_value

    cdef TBranch* eJetArea_branch
    cdef float eJetArea_value

    cdef TBranch* eJetBtag_branch
    cdef float eJetBtag_value

    cdef TBranch* eJetCSVBtag_branch
    cdef float eJetCSVBtag_value

    cdef TBranch* eJetEtaEtaMoment_branch
    cdef float eJetEtaEtaMoment_value

    cdef TBranch* eJetEtaPhiMoment_branch
    cdef float eJetEtaPhiMoment_value

    cdef TBranch* eJetEtaPhiSpread_branch
    cdef float eJetEtaPhiSpread_value

    cdef TBranch* eJetPhiPhiMoment_branch
    cdef float eJetPhiPhiMoment_value

    cdef TBranch* eJetPt_branch
    cdef float eJetPt_value

    cdef TBranch* eJetQGLikelihoodID_branch
    cdef float eJetQGLikelihoodID_value

    cdef TBranch* eJetQGMVAID_branch
    cdef float eJetQGMVAID_value

    cdef TBranch* eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch
    cdef float eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    cdef TBranch* eMITID_branch
    cdef float eMITID_value

    cdef TBranch* eMVAIDH2TauWP_branch
    cdef float eMVAIDH2TauWP_value

    cdef TBranch* eMVANonTrig_branch
    cdef float eMVANonTrig_value

    cdef TBranch* eMVATrig_branch
    cdef float eMVATrig_value

    cdef TBranch* eMVATrigIDISO_branch
    cdef float eMVATrigIDISO_value

    cdef TBranch* eMVATrigIDISOPUSUB_branch
    cdef float eMVATrigIDISOPUSUB_value

    cdef TBranch* eMVATrigNoIP_branch
    cdef float eMVATrigNoIP_value

    cdef TBranch* eMass_branch
    cdef float eMass_value

    cdef TBranch* eMatchesDoubleEPath_branch
    cdef float eMatchesDoubleEPath_value

    cdef TBranch* eMatchesMu17Ele8IsoPath_branch
    cdef float eMatchesMu17Ele8IsoPath_value

    cdef TBranch* eMatchesMu17Ele8Path_branch
    cdef float eMatchesMu17Ele8Path_value

    cdef TBranch* eMatchesMu8Ele17IsoPath_branch
    cdef float eMatchesMu8Ele17IsoPath_value

    cdef TBranch* eMatchesMu8Ele17Path_branch
    cdef float eMatchesMu8Ele17Path_value

    cdef TBranch* eMatchesSingleE_branch
    cdef float eMatchesSingleE_value

    cdef TBranch* eMatchesSingleE27WP80_branch
    cdef float eMatchesSingleE27WP80_value

    cdef TBranch* eMatchesSingleEPlusMET_branch
    cdef float eMatchesSingleEPlusMET_value

    cdef TBranch* eMissingHits_branch
    cdef float eMissingHits_value

    cdef TBranch* eMtToMET_branch
    cdef float eMtToMET_value

    cdef TBranch* eMtToMVAMET_branch
    cdef float eMtToMVAMET_value

    cdef TBranch* eMtToPfMet_branch
    cdef float eMtToPfMet_value

    cdef TBranch* eMtToPfMet_Ty1_branch
    cdef float eMtToPfMet_Ty1_value

    cdef TBranch* eMtToPfMet_ees_branch
    cdef float eMtToPfMet_ees_value

    cdef TBranch* eMtToPfMet_ees_minus_branch
    cdef float eMtToPfMet_ees_minus_value

    cdef TBranch* eMtToPfMet_ees_plus_branch
    cdef float eMtToPfMet_ees_plus_value

    cdef TBranch* eMtToPfMet_jes_branch
    cdef float eMtToPfMet_jes_value

    cdef TBranch* eMtToPfMet_jes_minus_branch
    cdef float eMtToPfMet_jes_minus_value

    cdef TBranch* eMtToPfMet_jes_plus_branch
    cdef float eMtToPfMet_jes_plus_value

    cdef TBranch* eMtToPfMet_mes_branch
    cdef float eMtToPfMet_mes_value

    cdef TBranch* eMtToPfMet_mes_minus_branch
    cdef float eMtToPfMet_mes_minus_value

    cdef TBranch* eMtToPfMet_mes_plus_branch
    cdef float eMtToPfMet_mes_plus_value

    cdef TBranch* eMtToPfMet_tes_branch
    cdef float eMtToPfMet_tes_value

    cdef TBranch* eMtToPfMet_tes_minus_branch
    cdef float eMtToPfMet_tes_minus_value

    cdef TBranch* eMtToPfMet_tes_plus_branch
    cdef float eMtToPfMet_tes_plus_value

    cdef TBranch* eMtToPfMet_ues_branch
    cdef float eMtToPfMet_ues_value

    cdef TBranch* eMtToPfMet_ues_minus_branch
    cdef float eMtToPfMet_ues_minus_value

    cdef TBranch* eMtToPfMet_ues_plus_branch
    cdef float eMtToPfMet_ues_plus_value

    cdef TBranch* eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch
    cdef float eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    cdef TBranch* eMu17Ele8CaloIdTPixelMatchFilter_branch
    cdef float eMu17Ele8CaloIdTPixelMatchFilter_value

    cdef TBranch* eMu17Ele8dZFilter_branch
    cdef float eMu17Ele8dZFilter_value

    cdef TBranch* eNearMuonVeto_branch
    cdef float eNearMuonVeto_value

    cdef TBranch* ePFChargedIso_branch
    cdef float ePFChargedIso_value

    cdef TBranch* ePFNeutralIso_branch
    cdef float ePFNeutralIso_value

    cdef TBranch* ePFPhotonIso_branch
    cdef float ePFPhotonIso_value

    cdef TBranch* ePVDXY_branch
    cdef float ePVDXY_value

    cdef TBranch* ePVDZ_branch
    cdef float ePVDZ_value

    cdef TBranch* ePhi_branch
    cdef float ePhi_value

    cdef TBranch* ePhiCorrReg_2012Jul13ReReco_branch
    cdef float ePhiCorrReg_2012Jul13ReReco_value

    cdef TBranch* ePhiCorrReg_Fall11_branch
    cdef float ePhiCorrReg_Fall11_value

    cdef TBranch* ePhiCorrReg_Jan16ReReco_branch
    cdef float ePhiCorrReg_Jan16ReReco_value

    cdef TBranch* ePhiCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float ePhiCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* ePhiCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float ePhiCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* ePhiCorrSmearedNoReg_Fall11_branch
    cdef float ePhiCorrSmearedNoReg_Fall11_value

    cdef TBranch* ePhiCorrSmearedNoReg_Jan16ReReco_branch
    cdef float ePhiCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* ePhiCorrSmearedReg_2012Jul13ReReco_branch
    cdef float ePhiCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* ePhiCorrSmearedReg_Fall11_branch
    cdef float ePhiCorrSmearedReg_Fall11_value

    cdef TBranch* ePhiCorrSmearedReg_Jan16ReReco_branch
    cdef float ePhiCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* ePt_branch
    cdef float ePt_value

    cdef TBranch* ePtCorrReg_2012Jul13ReReco_branch
    cdef float ePtCorrReg_2012Jul13ReReco_value

    cdef TBranch* ePtCorrReg_Fall11_branch
    cdef float ePtCorrReg_Fall11_value

    cdef TBranch* ePtCorrReg_Jan16ReReco_branch
    cdef float ePtCorrReg_Jan16ReReco_value

    cdef TBranch* ePtCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float ePtCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* ePtCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float ePtCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* ePtCorrSmearedNoReg_Fall11_branch
    cdef float ePtCorrSmearedNoReg_Fall11_value

    cdef TBranch* ePtCorrSmearedNoReg_Jan16ReReco_branch
    cdef float ePtCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* ePtCorrSmearedReg_2012Jul13ReReco_branch
    cdef float ePtCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* ePtCorrSmearedReg_Fall11_branch
    cdef float ePtCorrSmearedReg_Fall11_value

    cdef TBranch* ePtCorrSmearedReg_Jan16ReReco_branch
    cdef float ePtCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float ePtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* ePt_ees_minus_branch
    cdef float ePt_ees_minus_value

    cdef TBranch* ePt_ees_plus_branch
    cdef float ePt_ees_plus_value

    cdef TBranch* ePt_tes_minus_branch
    cdef float ePt_tes_minus_value

    cdef TBranch* ePt_tes_plus_branch
    cdef float ePt_tes_plus_value

    cdef TBranch* eRank_branch
    cdef float eRank_value

    cdef TBranch* eRelIso_branch
    cdef float eRelIso_value

    cdef TBranch* eRelPFIsoDB_branch
    cdef float eRelPFIsoDB_value

    cdef TBranch* eRelPFIsoRho_branch
    cdef float eRelPFIsoRho_value

    cdef TBranch* eRelPFIsoRhoFSR_branch
    cdef float eRelPFIsoRhoFSR_value

    cdef TBranch* eRhoHZG2011_branch
    cdef float eRhoHZG2011_value

    cdef TBranch* eRhoHZG2012_branch
    cdef float eRhoHZG2012_value

    cdef TBranch* eSCEnergy_branch
    cdef float eSCEnergy_value

    cdef TBranch* eSCEta_branch
    cdef float eSCEta_value

    cdef TBranch* eSCEtaWidth_branch
    cdef float eSCEtaWidth_value

    cdef TBranch* eSCPhi_branch
    cdef float eSCPhi_value

    cdef TBranch* eSCPhiWidth_branch
    cdef float eSCPhiWidth_value

    cdef TBranch* eSCPreshowerEnergy_branch
    cdef float eSCPreshowerEnergy_value

    cdef TBranch* eSCRawEnergy_branch
    cdef float eSCRawEnergy_value

    cdef TBranch* eSigmaIEtaIEta_branch
    cdef float eSigmaIEtaIEta_value

    cdef TBranch* eToMETDPhi_branch
    cdef float eToMETDPhi_value

    cdef TBranch* eTrkIsoDR03_branch
    cdef float eTrkIsoDR03_value

    cdef TBranch* eVZ_branch
    cdef float eVZ_value

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

    cdef TBranch* eWWID_branch
    cdef float eWWID_value

    cdef TBranch* e_t_CosThetaStar_branch
    cdef float e_t_CosThetaStar_value

    cdef TBranch* e_t_DPhi_branch
    cdef float e_t_DPhi_value

    cdef TBranch* e_t_DR_branch
    cdef float e_t_DR_value

    cdef TBranch* e_t_Mass_branch
    cdef float e_t_Mass_value

    cdef TBranch* e_t_MassFsr_branch
    cdef float e_t_MassFsr_value

    cdef TBranch* e_t_Mass_ees_minus_branch
    cdef float e_t_Mass_ees_minus_value

    cdef TBranch* e_t_Mass_ees_plus_branch
    cdef float e_t_Mass_ees_plus_value

    cdef TBranch* e_t_Mass_tes_minus_branch
    cdef float e_t_Mass_tes_minus_value

    cdef TBranch* e_t_Mass_tes_plus_branch
    cdef float e_t_Mass_tes_plus_value

    cdef TBranch* e_t_PZeta_branch
    cdef float e_t_PZeta_value

    cdef TBranch* e_t_PZetaVis_branch
    cdef float e_t_PZetaVis_value

    cdef TBranch* e_t_Pt_branch
    cdef float e_t_Pt_value

    cdef TBranch* e_t_PtFsr_branch
    cdef float e_t_PtFsr_value

    cdef TBranch* e_t_SS_branch
    cdef float e_t_SS_value

    cdef TBranch* e_t_ToMETDPhi_Ty1_branch
    cdef float e_t_ToMETDPhi_Ty1_value

    cdef TBranch* e_t_ToMETDPhi_jes_minus_branch
    cdef float e_t_ToMETDPhi_jes_minus_value

    cdef TBranch* e_t_ToMETDPhi_jes_plus_branch
    cdef float e_t_ToMETDPhi_jes_plus_value

    cdef TBranch* e_t_Zcompat_branch
    cdef float e_t_Zcompat_value

    cdef TBranch* edECorrReg_2012Jul13ReReco_branch
    cdef float edECorrReg_2012Jul13ReReco_value

    cdef TBranch* edECorrReg_Fall11_branch
    cdef float edECorrReg_Fall11_value

    cdef TBranch* edECorrReg_Jan16ReReco_branch
    cdef float edECorrReg_Jan16ReReco_value

    cdef TBranch* edECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float edECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* edECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float edECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* edECorrSmearedNoReg_Fall11_branch
    cdef float edECorrSmearedNoReg_Fall11_value

    cdef TBranch* edECorrSmearedNoReg_Jan16ReReco_branch
    cdef float edECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float edECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* edECorrSmearedReg_2012Jul13ReReco_branch
    cdef float edECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* edECorrSmearedReg_Fall11_branch
    cdef float edECorrSmearedReg_Fall11_value

    cdef TBranch* edECorrSmearedReg_Jan16ReReco_branch
    cdef float edECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* edECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float edECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* edeltaEtaSuperClusterTrackAtVtx_branch
    cdef float edeltaEtaSuperClusterTrackAtVtx_value

    cdef TBranch* edeltaPhiSuperClusterTrackAtVtx_branch
    cdef float edeltaPhiSuperClusterTrackAtVtx_value

    cdef TBranch* eeSuperClusterOverP_branch
    cdef float eeSuperClusterOverP_value

    cdef TBranch* eecalEnergy_branch
    cdef float eecalEnergy_value

    cdef TBranch* efBrem_branch
    cdef float efBrem_value

    cdef TBranch* etrackMomentumAtVtxP_branch
    cdef float etrackMomentumAtVtxP_value

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

    cdef TBranch* vbfDeta_branch
    cdef float vbfDeta_value

    cdef TBranch* tMtToPFMET_branch
    cdef float tMtToPFMET_value
   
    cdef TBranch* vbfDijetrap_branch
    cdef float vbfDijetrap_value

    cdef TBranch* vbfDphi_branch
    cdef float vbfDphi_value

    cdef TBranch* vbfDphihj_branch
    cdef float vbfDphihj_value

    cdef TBranch* vbfDphihjnomet_branch
    cdef float vbfDphihjnomet_value

    cdef TBranch* vbfHrap_branch
    cdef float vbfHrap_value

    cdef TBranch* vbfJetVeto20_branch
    cdef float vbfJetVeto20_value

    cdef TBranch* vbfJetVeto30_branch
    cdef float vbfJetVeto30_value

    cdef TBranch* vbfJetVetoTight20_branch
    cdef float vbfJetVetoTight20_value

    cdef TBranch* vbfJetVetoTight30_branch
    cdef float vbfJetVetoTight30_value

    cdef TBranch* vbfMVA_branch
    cdef float vbfMVA_value

    cdef TBranch* vbfMass_branch
    cdef float vbfMass_value

    cdef TBranch* vbfMass_jes_minus_branch
    cdef float vbfMass_jes_minus_value

    cdef TBranch* vbfMass_jes_plus_branch
    cdef float vbfMass_jes_plus_value

    cdef TBranch* vbfNJets_branch
    cdef float vbfNJets_value

    cdef TBranch* vbfVispt_branch
    cdef float vbfVispt_value

    cdef TBranch* vbfdijetpt_branch
    cdef float vbfdijetpt_value

    cdef TBranch* vbfditaupt_branch
    cdef float vbfditaupt_value

    cdef TBranch* vbfj1eta_branch
    cdef float vbfj1eta_value

    cdef TBranch* vbfj1pt_branch
    cdef float vbfj1pt_value

    cdef TBranch* vbfj2eta_branch
    cdef float vbfj2eta_value

    cdef TBranch* vbfj2pt_branch
    cdef float vbfj2pt_value

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
            warnings.warn( "ETauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "ETauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "ETauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "ETauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "ETauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "ETauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "ETauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "ETauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "ETauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "ETauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCSVVeto"
        self.bjetCSVVeto_branch = the_tree.GetBranch("bjetCSVVeto")
        #if not self.bjetCSVVeto_branch and "bjetCSVVeto" not in self.complained:
        if not self.bjetCSVVeto_branch and "bjetCSVVeto":
            warnings.warn( "ETauTree: Expected branch bjetCSVVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto")
        else:
            self.bjetCSVVeto_branch.SetAddress(<void*>&self.bjetCSVVeto_value)

        #print "making bjetCSVVeto30"
        self.bjetCSVVeto30_branch = the_tree.GetBranch("bjetCSVVeto30")
        #if not self.bjetCSVVeto30_branch and "bjetCSVVeto30" not in self.complained:
        if not self.bjetCSVVeto30_branch and "bjetCSVVeto30":
            warnings.warn( "ETauTree: Expected branch bjetCSVVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto30")
        else:
            self.bjetCSVVeto30_branch.SetAddress(<void*>&self.bjetCSVVeto30_value)

        #print "making bjetCSVVetoZHLike"
        self.bjetCSVVetoZHLike_branch = the_tree.GetBranch("bjetCSVVetoZHLike")
        #if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike" not in self.complained:
        if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike":
            warnings.warn( "ETauTree: Expected branch bjetCSVVetoZHLike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLike")
        else:
            self.bjetCSVVetoZHLike_branch.SetAddress(<void*>&self.bjetCSVVetoZHLike_value)

        #print "making bjetCSVVetoZHLikeNoJetId"
        self.bjetCSVVetoZHLikeNoJetId_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId")
        #if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId":
            warnings.warn( "ETauTree: Expected branch bjetCSVVetoZHLikeNoJetId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId")
        else:
            self.bjetCSVVetoZHLikeNoJetId_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_value)

        #print "making bjetVeto"
        self.bjetVeto_branch = the_tree.GetBranch("bjetVeto")
        #if not self.bjetVeto_branch and "bjetVeto" not in self.complained:
        if not self.bjetVeto_branch and "bjetVeto":
            warnings.warn( "ETauTree: Expected branch bjetVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetVeto")
        else:
            self.bjetVeto_branch.SetAddress(<void*>&self.bjetVeto_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "ETauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making doubleEExtraGroup"
        self.doubleEExtraGroup_branch = the_tree.GetBranch("doubleEExtraGroup")
        #if not self.doubleEExtraGroup_branch and "doubleEExtraGroup" not in self.complained:
        if not self.doubleEExtraGroup_branch and "doubleEExtraGroup":
            warnings.warn( "ETauTree: Expected branch doubleEExtraGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraGroup")
        else:
            self.doubleEExtraGroup_branch.SetAddress(<void*>&self.doubleEExtraGroup_value)

        #print "making doubleEExtraPass"
        self.doubleEExtraPass_branch = the_tree.GetBranch("doubleEExtraPass")
        #if not self.doubleEExtraPass_branch and "doubleEExtraPass" not in self.complained:
        if not self.doubleEExtraPass_branch and "doubleEExtraPass":
            warnings.warn( "ETauTree: Expected branch doubleEExtraPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPass")
        else:
            self.doubleEExtraPass_branch.SetAddress(<void*>&self.doubleEExtraPass_value)

        #print "making doubleEExtraPrescale"
        self.doubleEExtraPrescale_branch = the_tree.GetBranch("doubleEExtraPrescale")
        #if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale" not in self.complained:
        if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale":
            warnings.warn( "ETauTree: Expected branch doubleEExtraPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPrescale")
        else:
            self.doubleEExtraPrescale_branch.SetAddress(<void*>&self.doubleEExtraPrescale_value)

        #print "making doubleEGroup"
        self.doubleEGroup_branch = the_tree.GetBranch("doubleEGroup")
        #if not self.doubleEGroup_branch and "doubleEGroup" not in self.complained:
        if not self.doubleEGroup_branch and "doubleEGroup":
            warnings.warn( "ETauTree: Expected branch doubleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEGroup")
        else:
            self.doubleEGroup_branch.SetAddress(<void*>&self.doubleEGroup_value)

        #print "making doubleEPass"
        self.doubleEPass_branch = the_tree.GetBranch("doubleEPass")
        #if not self.doubleEPass_branch and "doubleEPass" not in self.complained:
        if not self.doubleEPass_branch and "doubleEPass":
            warnings.warn( "ETauTree: Expected branch doubleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPass")
        else:
            self.doubleEPass_branch.SetAddress(<void*>&self.doubleEPass_value)

        #print "making doubleEPrescale"
        self.doubleEPrescale_branch = the_tree.GetBranch("doubleEPrescale")
        #if not self.doubleEPrescale_branch and "doubleEPrescale" not in self.complained:
        if not self.doubleEPrescale_branch and "doubleEPrescale":
            warnings.warn( "ETauTree: Expected branch doubleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPrescale")
        else:
            self.doubleEPrescale_branch.SetAddress(<void*>&self.doubleEPrescale_value)

        #print "making doubleETightGroup"
        self.doubleETightGroup_branch = the_tree.GetBranch("doubleETightGroup")
        #if not self.doubleETightGroup_branch and "doubleETightGroup" not in self.complained:
        if not self.doubleETightGroup_branch and "doubleETightGroup":
            warnings.warn( "ETauTree: Expected branch doubleETightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightGroup")
        else:
            self.doubleETightGroup_branch.SetAddress(<void*>&self.doubleETightGroup_value)

        #print "making doubleETightPass"
        self.doubleETightPass_branch = the_tree.GetBranch("doubleETightPass")
        #if not self.doubleETightPass_branch and "doubleETightPass" not in self.complained:
        if not self.doubleETightPass_branch and "doubleETightPass":
            warnings.warn( "ETauTree: Expected branch doubleETightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPass")
        else:
            self.doubleETightPass_branch.SetAddress(<void*>&self.doubleETightPass_value)

        #print "making doubleETightPrescale"
        self.doubleETightPrescale_branch = the_tree.GetBranch("doubleETightPrescale")
        #if not self.doubleETightPrescale_branch and "doubleETightPrescale" not in self.complained:
        if not self.doubleETightPrescale_branch and "doubleETightPrescale":
            warnings.warn( "ETauTree: Expected branch doubleETightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPrescale")
        else:
            self.doubleETightPrescale_branch.SetAddress(<void*>&self.doubleETightPrescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "ETauTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "ETauTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "ETauTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuTrkGroup"
        self.doubleMuTrkGroup_branch = the_tree.GetBranch("doubleMuTrkGroup")
        #if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup" not in self.complained:
        if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup":
            warnings.warn( "ETauTree: Expected branch doubleMuTrkGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkGroup")
        else:
            self.doubleMuTrkGroup_branch.SetAddress(<void*>&self.doubleMuTrkGroup_value)

        #print "making doubleMuTrkPass"
        self.doubleMuTrkPass_branch = the_tree.GetBranch("doubleMuTrkPass")
        #if not self.doubleMuTrkPass_branch and "doubleMuTrkPass" not in self.complained:
        if not self.doubleMuTrkPass_branch and "doubleMuTrkPass":
            warnings.warn( "ETauTree: Expected branch doubleMuTrkPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPass")
        else:
            self.doubleMuTrkPass_branch.SetAddress(<void*>&self.doubleMuTrkPass_value)

        #print "making doubleMuTrkPrescale"
        self.doubleMuTrkPrescale_branch = the_tree.GetBranch("doubleMuTrkPrescale")
        #if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale" not in self.complained:
        if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale":
            warnings.warn( "ETauTree: Expected branch doubleMuTrkPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPrescale")
        else:
            self.doubleMuTrkPrescale_branch.SetAddress(<void*>&self.doubleMuTrkPrescale_value)

        #print "making doublePhoGroup"
        self.doublePhoGroup_branch = the_tree.GetBranch("doublePhoGroup")
        #if not self.doublePhoGroup_branch and "doublePhoGroup" not in self.complained:
        if not self.doublePhoGroup_branch and "doublePhoGroup":
            warnings.warn( "ETauTree: Expected branch doublePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoGroup")
        else:
            self.doublePhoGroup_branch.SetAddress(<void*>&self.doublePhoGroup_value)

        #print "making doublePhoPass"
        self.doublePhoPass_branch = the_tree.GetBranch("doublePhoPass")
        #if not self.doublePhoPass_branch and "doublePhoPass" not in self.complained:
        if not self.doublePhoPass_branch and "doublePhoPass":
            warnings.warn( "ETauTree: Expected branch doublePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPass")
        else:
            self.doublePhoPass_branch.SetAddress(<void*>&self.doublePhoPass_value)

        #print "making doublePhoPrescale"
        self.doublePhoPrescale_branch = the_tree.GetBranch("doublePhoPrescale")
        #if not self.doublePhoPrescale_branch and "doublePhoPrescale" not in self.complained:
        if not self.doublePhoPrescale_branch and "doublePhoPrescale":
            warnings.warn( "ETauTree: Expected branch doublePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPrescale")
        else:
            self.doublePhoPrescale_branch.SetAddress(<void*>&self.doublePhoPrescale_value)

        #print "making eAbsEta"
        self.eAbsEta_branch = the_tree.GetBranch("eAbsEta")
        #if not self.eAbsEta_branch and "eAbsEta" not in self.complained:
        if not self.eAbsEta_branch and "eAbsEta":
            warnings.warn( "ETauTree: Expected branch eAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eAbsEta")
        else:
            self.eAbsEta_branch.SetAddress(<void*>&self.eAbsEta_value)

        #print "making eCBID_LOOSE"
        self.eCBID_LOOSE_branch = the_tree.GetBranch("eCBID_LOOSE")
        #if not self.eCBID_LOOSE_branch and "eCBID_LOOSE" not in self.complained:
        if not self.eCBID_LOOSE_branch and "eCBID_LOOSE":
            warnings.warn( "ETauTree: Expected branch eCBID_LOOSE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_LOOSE")
        else:
            self.eCBID_LOOSE_branch.SetAddress(<void*>&self.eCBID_LOOSE_value)

        #print "making eCBID_MEDIUM"
        self.eCBID_MEDIUM_branch = the_tree.GetBranch("eCBID_MEDIUM")
        #if not self.eCBID_MEDIUM_branch and "eCBID_MEDIUM" not in self.complained:
        if not self.eCBID_MEDIUM_branch and "eCBID_MEDIUM":
            warnings.warn( "ETauTree: Expected branch eCBID_MEDIUM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_MEDIUM")
        else:
            self.eCBID_MEDIUM_branch.SetAddress(<void*>&self.eCBID_MEDIUM_value)

        #print "making eCBID_TIGHT"
        self.eCBID_TIGHT_branch = the_tree.GetBranch("eCBID_TIGHT")
        #if not self.eCBID_TIGHT_branch and "eCBID_TIGHT" not in self.complained:
        if not self.eCBID_TIGHT_branch and "eCBID_TIGHT":
            warnings.warn( "ETauTree: Expected branch eCBID_TIGHT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_TIGHT")
        else:
            self.eCBID_TIGHT_branch.SetAddress(<void*>&self.eCBID_TIGHT_value)

        #print "making eCBID_VETO"
        self.eCBID_VETO_branch = the_tree.GetBranch("eCBID_VETO")
        #if not self.eCBID_VETO_branch and "eCBID_VETO" not in self.complained:
        if not self.eCBID_VETO_branch and "eCBID_VETO":
            warnings.warn( "ETauTree: Expected branch eCBID_VETO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_VETO")
        else:
            self.eCBID_VETO_branch.SetAddress(<void*>&self.eCBID_VETO_value)

        #print "making eCharge"
        self.eCharge_branch = the_tree.GetBranch("eCharge")
        #if not self.eCharge_branch and "eCharge" not in self.complained:
        if not self.eCharge_branch and "eCharge":
            warnings.warn( "ETauTree: Expected branch eCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCharge")
        else:
            self.eCharge_branch.SetAddress(<void*>&self.eCharge_value)

        #print "making eChargeIdLoose"
        self.eChargeIdLoose_branch = the_tree.GetBranch("eChargeIdLoose")
        #if not self.eChargeIdLoose_branch and "eChargeIdLoose" not in self.complained:
        if not self.eChargeIdLoose_branch and "eChargeIdLoose":
            warnings.warn( "ETauTree: Expected branch eChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdLoose")
        else:
            self.eChargeIdLoose_branch.SetAddress(<void*>&self.eChargeIdLoose_value)

        #print "making eChargeIdMed"
        self.eChargeIdMed_branch = the_tree.GetBranch("eChargeIdMed")
        #if not self.eChargeIdMed_branch and "eChargeIdMed" not in self.complained:
        if not self.eChargeIdMed_branch and "eChargeIdMed":
            warnings.warn( "ETauTree: Expected branch eChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdMed")
        else:
            self.eChargeIdMed_branch.SetAddress(<void*>&self.eChargeIdMed_value)

        #print "making eChargeIdTight"
        self.eChargeIdTight_branch = the_tree.GetBranch("eChargeIdTight")
        #if not self.eChargeIdTight_branch and "eChargeIdTight" not in self.complained:
        if not self.eChargeIdTight_branch and "eChargeIdTight":
            warnings.warn( "ETauTree: Expected branch eChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdTight")
        else:
            self.eChargeIdTight_branch.SetAddress(<void*>&self.eChargeIdTight_value)

        #print "making eCiCTight"
        self.eCiCTight_branch = the_tree.GetBranch("eCiCTight")
        #if not self.eCiCTight_branch and "eCiCTight" not in self.complained:
        if not self.eCiCTight_branch and "eCiCTight":
            warnings.warn( "ETauTree: Expected branch eCiCTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCiCTight")
        else:
            self.eCiCTight_branch.SetAddress(<void*>&self.eCiCTight_value)

        #print "making eComesFromHiggs"
        self.eComesFromHiggs_branch = the_tree.GetBranch("eComesFromHiggs")
        #if not self.eComesFromHiggs_branch and "eComesFromHiggs" not in self.complained:
        if not self.eComesFromHiggs_branch and "eComesFromHiggs":
            warnings.warn( "ETauTree: Expected branch eComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eComesFromHiggs")
        else:
            self.eComesFromHiggs_branch.SetAddress(<void*>&self.eComesFromHiggs_value)

        #print "making eDZ"
        self.eDZ_branch = the_tree.GetBranch("eDZ")
        #if not self.eDZ_branch and "eDZ" not in self.complained:
        if not self.eDZ_branch and "eDZ":
            warnings.warn( "ETauTree: Expected branch eDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eDZ")
        else:
            self.eDZ_branch.SetAddress(<void*>&self.eDZ_value)

        #print "making eE1x5"
        self.eE1x5_branch = the_tree.GetBranch("eE1x5")
        #if not self.eE1x5_branch and "eE1x5" not in self.complained:
        if not self.eE1x5_branch and "eE1x5":
            warnings.warn( "ETauTree: Expected branch eE1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE1x5")
        else:
            self.eE1x5_branch.SetAddress(<void*>&self.eE1x5_value)

        #print "making eE2x5Max"
        self.eE2x5Max_branch = the_tree.GetBranch("eE2x5Max")
        #if not self.eE2x5Max_branch and "eE2x5Max" not in self.complained:
        if not self.eE2x5Max_branch and "eE2x5Max":
            warnings.warn( "ETauTree: Expected branch eE2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE2x5Max")
        else:
            self.eE2x5Max_branch.SetAddress(<void*>&self.eE2x5Max_value)

        #print "making eE5x5"
        self.eE5x5_branch = the_tree.GetBranch("eE5x5")
        #if not self.eE5x5_branch and "eE5x5" not in self.complained:
        if not self.eE5x5_branch and "eE5x5":
            warnings.warn( "ETauTree: Expected branch eE5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE5x5")
        else:
            self.eE5x5_branch.SetAddress(<void*>&self.eE5x5_value)

        #print "making eECorrReg_2012Jul13ReReco"
        self.eECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("eECorrReg_2012Jul13ReReco")
        #if not self.eECorrReg_2012Jul13ReReco_branch and "eECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.eECorrReg_2012Jul13ReReco_branch and "eECorrReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch eECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_2012Jul13ReReco")
        else:
            self.eECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eECorrReg_2012Jul13ReReco_value)

        #print "making eECorrReg_Fall11"
        self.eECorrReg_Fall11_branch = the_tree.GetBranch("eECorrReg_Fall11")
        #if not self.eECorrReg_Fall11_branch and "eECorrReg_Fall11" not in self.complained:
        if not self.eECorrReg_Fall11_branch and "eECorrReg_Fall11":
            warnings.warn( "ETauTree: Expected branch eECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_Fall11")
        else:
            self.eECorrReg_Fall11_branch.SetAddress(<void*>&self.eECorrReg_Fall11_value)

        #print "making eECorrReg_Jan16ReReco"
        self.eECorrReg_Jan16ReReco_branch = the_tree.GetBranch("eECorrReg_Jan16ReReco")
        #if not self.eECorrReg_Jan16ReReco_branch and "eECorrReg_Jan16ReReco" not in self.complained:
        if not self.eECorrReg_Jan16ReReco_branch and "eECorrReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch eECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_Jan16ReReco")
        else:
            self.eECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.eECorrReg_Jan16ReReco_value)

        #print "making eECorrReg_Summer12_DR53X_HCP2012"
        self.eECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eECorrReg_Summer12_DR53X_HCP2012")
        #if not self.eECorrReg_Summer12_DR53X_HCP2012_branch and "eECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eECorrReg_Summer12_DR53X_HCP2012_branch and "eECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch eECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.eECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making eECorrSmearedNoReg_2012Jul13ReReco"
        self.eECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("eECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.eECorrSmearedNoReg_2012Jul13ReReco_branch and "eECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.eECorrSmearedNoReg_2012Jul13ReReco_branch and "eECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch eECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.eECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making eECorrSmearedNoReg_Fall11"
        self.eECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("eECorrSmearedNoReg_Fall11")
        #if not self.eECorrSmearedNoReg_Fall11_branch and "eECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.eECorrSmearedNoReg_Fall11_branch and "eECorrSmearedNoReg_Fall11":
            warnings.warn( "ETauTree: Expected branch eECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_Fall11")
        else:
            self.eECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_Fall11_value)

        #print "making eECorrSmearedNoReg_Jan16ReReco"
        self.eECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("eECorrSmearedNoReg_Jan16ReReco")
        #if not self.eECorrSmearedNoReg_Jan16ReReco_branch and "eECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.eECorrSmearedNoReg_Jan16ReReco_branch and "eECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch eECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_Jan16ReReco")
        else:
            self.eECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_Jan16ReReco_value)

        #print "making eECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch eECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making eECorrSmearedReg_2012Jul13ReReco"
        self.eECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("eECorrSmearedReg_2012Jul13ReReco")
        #if not self.eECorrSmearedReg_2012Jul13ReReco_branch and "eECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.eECorrSmearedReg_2012Jul13ReReco_branch and "eECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch eECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_2012Jul13ReReco")
        else:
            self.eECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eECorrSmearedReg_2012Jul13ReReco_value)

        #print "making eECorrSmearedReg_Fall11"
        self.eECorrSmearedReg_Fall11_branch = the_tree.GetBranch("eECorrSmearedReg_Fall11")
        #if not self.eECorrSmearedReg_Fall11_branch and "eECorrSmearedReg_Fall11" not in self.complained:
        if not self.eECorrSmearedReg_Fall11_branch and "eECorrSmearedReg_Fall11":
            warnings.warn( "ETauTree: Expected branch eECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_Fall11")
        else:
            self.eECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.eECorrSmearedReg_Fall11_value)

        #print "making eECorrSmearedReg_Jan16ReReco"
        self.eECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("eECorrSmearedReg_Jan16ReReco")
        #if not self.eECorrSmearedReg_Jan16ReReco_branch and "eECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.eECorrSmearedReg_Jan16ReReco_branch and "eECorrSmearedReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch eECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_Jan16ReReco")
        else:
            self.eECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.eECorrSmearedReg_Jan16ReReco_value)

        #print "making eECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch eECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making eEcalIsoDR03"
        self.eEcalIsoDR03_branch = the_tree.GetBranch("eEcalIsoDR03")
        #if not self.eEcalIsoDR03_branch and "eEcalIsoDR03" not in self.complained:
        if not self.eEcalIsoDR03_branch and "eEcalIsoDR03":
            warnings.warn( "ETauTree: Expected branch eEcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEcalIsoDR03")
        else:
            self.eEcalIsoDR03_branch.SetAddress(<void*>&self.eEcalIsoDR03_value)

        #print "making eEffectiveArea2011Data"
        self.eEffectiveArea2011Data_branch = the_tree.GetBranch("eEffectiveArea2011Data")
        #if not self.eEffectiveArea2011Data_branch and "eEffectiveArea2011Data" not in self.complained:
        if not self.eEffectiveArea2011Data_branch and "eEffectiveArea2011Data":
            warnings.warn( "ETauTree: Expected branch eEffectiveArea2011Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveArea2011Data")
        else:
            self.eEffectiveArea2011Data_branch.SetAddress(<void*>&self.eEffectiveArea2011Data_value)

        #print "making eEffectiveArea2012Data"
        self.eEffectiveArea2012Data_branch = the_tree.GetBranch("eEffectiveArea2012Data")
        #if not self.eEffectiveArea2012Data_branch and "eEffectiveArea2012Data" not in self.complained:
        if not self.eEffectiveArea2012Data_branch and "eEffectiveArea2012Data":
            warnings.warn( "ETauTree: Expected branch eEffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveArea2012Data")
        else:
            self.eEffectiveArea2012Data_branch.SetAddress(<void*>&self.eEffectiveArea2012Data_value)

        #print "making eEffectiveAreaFall11MC"
        self.eEffectiveAreaFall11MC_branch = the_tree.GetBranch("eEffectiveAreaFall11MC")
        #if not self.eEffectiveAreaFall11MC_branch and "eEffectiveAreaFall11MC" not in self.complained:
        if not self.eEffectiveAreaFall11MC_branch and "eEffectiveAreaFall11MC":
            warnings.warn( "ETauTree: Expected branch eEffectiveAreaFall11MC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveAreaFall11MC")
        else:
            self.eEffectiveAreaFall11MC_branch.SetAddress(<void*>&self.eEffectiveAreaFall11MC_value)

        #print "making eEle27WP80PFMT50PFMTFilter"
        self.eEle27WP80PFMT50PFMTFilter_branch = the_tree.GetBranch("eEle27WP80PFMT50PFMTFilter")
        #if not self.eEle27WP80PFMT50PFMTFilter_branch and "eEle27WP80PFMT50PFMTFilter" not in self.complained:
        if not self.eEle27WP80PFMT50PFMTFilter_branch and "eEle27WP80PFMT50PFMTFilter":
            warnings.warn( "ETauTree: Expected branch eEle27WP80PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEle27WP80PFMT50PFMTFilter")
        else:
            self.eEle27WP80PFMT50PFMTFilter_branch.SetAddress(<void*>&self.eEle27WP80PFMT50PFMTFilter_value)

        #print "making eEle27WP80TrackIsoMatchFilter"
        self.eEle27WP80TrackIsoMatchFilter_branch = the_tree.GetBranch("eEle27WP80TrackIsoMatchFilter")
        #if not self.eEle27WP80TrackIsoMatchFilter_branch and "eEle27WP80TrackIsoMatchFilter" not in self.complained:
        if not self.eEle27WP80TrackIsoMatchFilter_branch and "eEle27WP80TrackIsoMatchFilter":
            warnings.warn( "ETauTree: Expected branch eEle27WP80TrackIsoMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEle27WP80TrackIsoMatchFilter")
        else:
            self.eEle27WP80TrackIsoMatchFilter_branch.SetAddress(<void*>&self.eEle27WP80TrackIsoMatchFilter_value)

        #print "making eEle32WP70PFMT50PFMTFilter"
        self.eEle32WP70PFMT50PFMTFilter_branch = the_tree.GetBranch("eEle32WP70PFMT50PFMTFilter")
        #if not self.eEle32WP70PFMT50PFMTFilter_branch and "eEle32WP70PFMT50PFMTFilter" not in self.complained:
        if not self.eEle32WP70PFMT50PFMTFilter_branch and "eEle32WP70PFMT50PFMTFilter":
            warnings.warn( "ETauTree: Expected branch eEle32WP70PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEle32WP70PFMT50PFMTFilter")
        else:
            self.eEle32WP70PFMT50PFMTFilter_branch.SetAddress(<void*>&self.eEle32WP70PFMT50PFMTFilter_value)

        #print "making eEnergyError"
        self.eEnergyError_branch = the_tree.GetBranch("eEnergyError")
        #if not self.eEnergyError_branch and "eEnergyError" not in self.complained:
        if not self.eEnergyError_branch and "eEnergyError":
            warnings.warn( "ETauTree: Expected branch eEnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyError")
        else:
            self.eEnergyError_branch.SetAddress(<void*>&self.eEnergyError_value)

        #print "making eEta"
        self.eEta_branch = the_tree.GetBranch("eEta")
        #if not self.eEta_branch and "eEta" not in self.complained:
        if not self.eEta_branch and "eEta":
            warnings.warn( "ETauTree: Expected branch eEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEta")
        else:
            self.eEta_branch.SetAddress(<void*>&self.eEta_value)

        #print "making eEtaCorrReg_2012Jul13ReReco"
        self.eEtaCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("eEtaCorrReg_2012Jul13ReReco")
        #if not self.eEtaCorrReg_2012Jul13ReReco_branch and "eEtaCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.eEtaCorrReg_2012Jul13ReReco_branch and "eEtaCorrReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch eEtaCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_2012Jul13ReReco")
        else:
            self.eEtaCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eEtaCorrReg_2012Jul13ReReco_value)

        #print "making eEtaCorrReg_Fall11"
        self.eEtaCorrReg_Fall11_branch = the_tree.GetBranch("eEtaCorrReg_Fall11")
        #if not self.eEtaCorrReg_Fall11_branch and "eEtaCorrReg_Fall11" not in self.complained:
        if not self.eEtaCorrReg_Fall11_branch and "eEtaCorrReg_Fall11":
            warnings.warn( "ETauTree: Expected branch eEtaCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_Fall11")
        else:
            self.eEtaCorrReg_Fall11_branch.SetAddress(<void*>&self.eEtaCorrReg_Fall11_value)

        #print "making eEtaCorrReg_Jan16ReReco"
        self.eEtaCorrReg_Jan16ReReco_branch = the_tree.GetBranch("eEtaCorrReg_Jan16ReReco")
        #if not self.eEtaCorrReg_Jan16ReReco_branch and "eEtaCorrReg_Jan16ReReco" not in self.complained:
        if not self.eEtaCorrReg_Jan16ReReco_branch and "eEtaCorrReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch eEtaCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_Jan16ReReco")
        else:
            self.eEtaCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.eEtaCorrReg_Jan16ReReco_value)

        #print "making eEtaCorrReg_Summer12_DR53X_HCP2012"
        self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eEtaCorrReg_Summer12_DR53X_HCP2012")
        #if not self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch eEtaCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eEtaCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making eEtaCorrSmearedNoReg_2012Jul13ReReco"
        self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch and "eEtaCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch and "eEtaCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch eEtaCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making eEtaCorrSmearedNoReg_Fall11"
        self.eEtaCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_Fall11")
        #if not self.eEtaCorrSmearedNoReg_Fall11_branch and "eEtaCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_Fall11_branch and "eEtaCorrSmearedNoReg_Fall11":
            warnings.warn( "ETauTree: Expected branch eEtaCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_Fall11")
        else:
            self.eEtaCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_Fall11_value)

        #print "making eEtaCorrSmearedNoReg_Jan16ReReco"
        self.eEtaCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_Jan16ReReco")
        #if not self.eEtaCorrSmearedNoReg_Jan16ReReco_branch and "eEtaCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_Jan16ReReco_branch and "eEtaCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch eEtaCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_Jan16ReReco")
        else:
            self.eEtaCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_Jan16ReReco_value)

        #print "making eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making eEtaCorrSmearedReg_2012Jul13ReReco"
        self.eEtaCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedReg_2012Jul13ReReco")
        #if not self.eEtaCorrSmearedReg_2012Jul13ReReco_branch and "eEtaCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.eEtaCorrSmearedReg_2012Jul13ReReco_branch and "eEtaCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch eEtaCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_2012Jul13ReReco")
        else:
            self.eEtaCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_2012Jul13ReReco_value)

        #print "making eEtaCorrSmearedReg_Fall11"
        self.eEtaCorrSmearedReg_Fall11_branch = the_tree.GetBranch("eEtaCorrSmearedReg_Fall11")
        #if not self.eEtaCorrSmearedReg_Fall11_branch and "eEtaCorrSmearedReg_Fall11" not in self.complained:
        if not self.eEtaCorrSmearedReg_Fall11_branch and "eEtaCorrSmearedReg_Fall11":
            warnings.warn( "ETauTree: Expected branch eEtaCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_Fall11")
        else:
            self.eEtaCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_Fall11_value)

        #print "making eEtaCorrSmearedReg_Jan16ReReco"
        self.eEtaCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedReg_Jan16ReReco")
        #if not self.eEtaCorrSmearedReg_Jan16ReReco_branch and "eEtaCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.eEtaCorrSmearedReg_Jan16ReReco_branch and "eEtaCorrSmearedReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch eEtaCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_Jan16ReReco")
        else:
            self.eEtaCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_Jan16ReReco_value)

        #print "making eEtaCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eEtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch eEtaCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making eGenCharge"
        self.eGenCharge_branch = the_tree.GetBranch("eGenCharge")
        #if not self.eGenCharge_branch and "eGenCharge" not in self.complained:
        if not self.eGenCharge_branch and "eGenCharge":
            warnings.warn( "ETauTree: Expected branch eGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenCharge")
        else:
            self.eGenCharge_branch.SetAddress(<void*>&self.eGenCharge_value)

        #print "making eGenEnergy"
        self.eGenEnergy_branch = the_tree.GetBranch("eGenEnergy")
        #if not self.eGenEnergy_branch and "eGenEnergy" not in self.complained:
        if not self.eGenEnergy_branch and "eGenEnergy":
            warnings.warn( "ETauTree: Expected branch eGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEnergy")
        else:
            self.eGenEnergy_branch.SetAddress(<void*>&self.eGenEnergy_value)

        #print "making eGenEta"
        self.eGenEta_branch = the_tree.GetBranch("eGenEta")
        #if not self.eGenEta_branch and "eGenEta" not in self.complained:
        if not self.eGenEta_branch and "eGenEta":
            warnings.warn( "ETauTree: Expected branch eGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEta")
        else:
            self.eGenEta_branch.SetAddress(<void*>&self.eGenEta_value)

        #print "making eGenMotherPdgId"
        self.eGenMotherPdgId_branch = the_tree.GetBranch("eGenMotherPdgId")
        #if not self.eGenMotherPdgId_branch and "eGenMotherPdgId" not in self.complained:
        if not self.eGenMotherPdgId_branch and "eGenMotherPdgId":
            warnings.warn( "ETauTree: Expected branch eGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenMotherPdgId")
        else:
            self.eGenMotherPdgId_branch.SetAddress(<void*>&self.eGenMotherPdgId_value)

        #print "making eGenPdgId"
        self.eGenPdgId_branch = the_tree.GetBranch("eGenPdgId")
        #if not self.eGenPdgId_branch and "eGenPdgId" not in self.complained:
        if not self.eGenPdgId_branch and "eGenPdgId":
            warnings.warn( "ETauTree: Expected branch eGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPdgId")
        else:
            self.eGenPdgId_branch.SetAddress(<void*>&self.eGenPdgId_value)

        #print "making eGenPhi"
        self.eGenPhi_branch = the_tree.GetBranch("eGenPhi")
        #if not self.eGenPhi_branch and "eGenPhi" not in self.complained:
        if not self.eGenPhi_branch and "eGenPhi":
            warnings.warn( "ETauTree: Expected branch eGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPhi")
        else:
            self.eGenPhi_branch.SetAddress(<void*>&self.eGenPhi_value)

        #print "making eHadronicDepth1OverEm"
        self.eHadronicDepth1OverEm_branch = the_tree.GetBranch("eHadronicDepth1OverEm")
        #if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm" not in self.complained:
        if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm":
            warnings.warn( "ETauTree: Expected branch eHadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth1OverEm")
        else:
            self.eHadronicDepth1OverEm_branch.SetAddress(<void*>&self.eHadronicDepth1OverEm_value)

        #print "making eHadronicDepth2OverEm"
        self.eHadronicDepth2OverEm_branch = the_tree.GetBranch("eHadronicDepth2OverEm")
        #if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm" not in self.complained:
        if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm":
            warnings.warn( "ETauTree: Expected branch eHadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth2OverEm")
        else:
            self.eHadronicDepth2OverEm_branch.SetAddress(<void*>&self.eHadronicDepth2OverEm_value)

        #print "making eHadronicOverEM"
        self.eHadronicOverEM_branch = the_tree.GetBranch("eHadronicOverEM")
        #if not self.eHadronicOverEM_branch and "eHadronicOverEM" not in self.complained:
        if not self.eHadronicOverEM_branch and "eHadronicOverEM":
            warnings.warn( "ETauTree: Expected branch eHadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicOverEM")
        else:
            self.eHadronicOverEM_branch.SetAddress(<void*>&self.eHadronicOverEM_value)

        #print "making eHasConversion"
        self.eHasConversion_branch = the_tree.GetBranch("eHasConversion")
        #if not self.eHasConversion_branch and "eHasConversion" not in self.complained:
        if not self.eHasConversion_branch and "eHasConversion":
            warnings.warn( "ETauTree: Expected branch eHasConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHasConversion")
        else:
            self.eHasConversion_branch.SetAddress(<void*>&self.eHasConversion_value)

        #print "making eHasMatchedConversion"
        self.eHasMatchedConversion_branch = the_tree.GetBranch("eHasMatchedConversion")
        #if not self.eHasMatchedConversion_branch and "eHasMatchedConversion" not in self.complained:
        if not self.eHasMatchedConversion_branch and "eHasMatchedConversion":
            warnings.warn( "ETauTree: Expected branch eHasMatchedConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHasMatchedConversion")
        else:
            self.eHasMatchedConversion_branch.SetAddress(<void*>&self.eHasMatchedConversion_value)

        #print "making eHcalIsoDR03"
        self.eHcalIsoDR03_branch = the_tree.GetBranch("eHcalIsoDR03")
        #if not self.eHcalIsoDR03_branch and "eHcalIsoDR03" not in self.complained:
        if not self.eHcalIsoDR03_branch and "eHcalIsoDR03":
            warnings.warn( "ETauTree: Expected branch eHcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHcalIsoDR03")
        else:
            self.eHcalIsoDR03_branch.SetAddress(<void*>&self.eHcalIsoDR03_value)

        #print "making eIP3DS"
        self.eIP3DS_branch = the_tree.GetBranch("eIP3DS")
        #if not self.eIP3DS_branch and "eIP3DS" not in self.complained:
        if not self.eIP3DS_branch and "eIP3DS":
            warnings.warn( "ETauTree: Expected branch eIP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIP3DS")
        else:
            self.eIP3DS_branch.SetAddress(<void*>&self.eIP3DS_value)

        #print "making eJetArea"
        self.eJetArea_branch = the_tree.GetBranch("eJetArea")
        #if not self.eJetArea_branch and "eJetArea" not in self.complained:
        if not self.eJetArea_branch and "eJetArea":
            warnings.warn( "ETauTree: Expected branch eJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetArea")
        else:
            self.eJetArea_branch.SetAddress(<void*>&self.eJetArea_value)

        #print "making eJetBtag"
        self.eJetBtag_branch = the_tree.GetBranch("eJetBtag")
        #if not self.eJetBtag_branch and "eJetBtag" not in self.complained:
        if not self.eJetBtag_branch and "eJetBtag":
            warnings.warn( "ETauTree: Expected branch eJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetBtag")
        else:
            self.eJetBtag_branch.SetAddress(<void*>&self.eJetBtag_value)

        #print "making eJetCSVBtag"
        self.eJetCSVBtag_branch = the_tree.GetBranch("eJetCSVBtag")
        #if not self.eJetCSVBtag_branch and "eJetCSVBtag" not in self.complained:
        if not self.eJetCSVBtag_branch and "eJetCSVBtag":
            warnings.warn( "ETauTree: Expected branch eJetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetCSVBtag")
        else:
            self.eJetCSVBtag_branch.SetAddress(<void*>&self.eJetCSVBtag_value)

        #print "making eJetEtaEtaMoment"
        self.eJetEtaEtaMoment_branch = the_tree.GetBranch("eJetEtaEtaMoment")
        #if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment" not in self.complained:
        if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment":
            warnings.warn( "ETauTree: Expected branch eJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaEtaMoment")
        else:
            self.eJetEtaEtaMoment_branch.SetAddress(<void*>&self.eJetEtaEtaMoment_value)

        #print "making eJetEtaPhiMoment"
        self.eJetEtaPhiMoment_branch = the_tree.GetBranch("eJetEtaPhiMoment")
        #if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment" not in self.complained:
        if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment":
            warnings.warn( "ETauTree: Expected branch eJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiMoment")
        else:
            self.eJetEtaPhiMoment_branch.SetAddress(<void*>&self.eJetEtaPhiMoment_value)

        #print "making eJetEtaPhiSpread"
        self.eJetEtaPhiSpread_branch = the_tree.GetBranch("eJetEtaPhiSpread")
        #if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread" not in self.complained:
        if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread":
            warnings.warn( "ETauTree: Expected branch eJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiSpread")
        else:
            self.eJetEtaPhiSpread_branch.SetAddress(<void*>&self.eJetEtaPhiSpread_value)

        #print "making eJetPhiPhiMoment"
        self.eJetPhiPhiMoment_branch = the_tree.GetBranch("eJetPhiPhiMoment")
        #if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment" not in self.complained:
        if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment":
            warnings.warn( "ETauTree: Expected branch eJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPhiPhiMoment")
        else:
            self.eJetPhiPhiMoment_branch.SetAddress(<void*>&self.eJetPhiPhiMoment_value)

        #print "making eJetPt"
        self.eJetPt_branch = the_tree.GetBranch("eJetPt")
        #if not self.eJetPt_branch and "eJetPt" not in self.complained:
        if not self.eJetPt_branch and "eJetPt":
            warnings.warn( "ETauTree: Expected branch eJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPt")
        else:
            self.eJetPt_branch.SetAddress(<void*>&self.eJetPt_value)

        #print "making eJetQGLikelihoodID"
        self.eJetQGLikelihoodID_branch = the_tree.GetBranch("eJetQGLikelihoodID")
        #if not self.eJetQGLikelihoodID_branch and "eJetQGLikelihoodID" not in self.complained:
        if not self.eJetQGLikelihoodID_branch and "eJetQGLikelihoodID":
            warnings.warn( "ETauTree: Expected branch eJetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetQGLikelihoodID")
        else:
            self.eJetQGLikelihoodID_branch.SetAddress(<void*>&self.eJetQGLikelihoodID_value)

        #print "making eJetQGMVAID"
        self.eJetQGMVAID_branch = the_tree.GetBranch("eJetQGMVAID")
        #if not self.eJetQGMVAID_branch and "eJetQGMVAID" not in self.complained:
        if not self.eJetQGMVAID_branch and "eJetQGMVAID":
            warnings.warn( "ETauTree: Expected branch eJetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetQGMVAID")
        else:
            self.eJetQGMVAID_branch.SetAddress(<void*>&self.eJetQGMVAID_value)

        #print "making eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter"
        self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch = the_tree.GetBranch("eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        #if not self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter" not in self.complained:
        if not self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter":
            warnings.warn( "ETauTree: Expected branch eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        else:
            self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.SetAddress(<void*>&self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value)

        #print "making eMITID"
        self.eMITID_branch = the_tree.GetBranch("eMITID")
        #if not self.eMITID_branch and "eMITID" not in self.complained:
        if not self.eMITID_branch and "eMITID":
            warnings.warn( "ETauTree: Expected branch eMITID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMITID")
        else:
            self.eMITID_branch.SetAddress(<void*>&self.eMITID_value)

        #print "making eMVAIDH2TauWP"
        self.eMVAIDH2TauWP_branch = the_tree.GetBranch("eMVAIDH2TauWP")
        #if not self.eMVAIDH2TauWP_branch and "eMVAIDH2TauWP" not in self.complained:
        if not self.eMVAIDH2TauWP_branch and "eMVAIDH2TauWP":
            warnings.warn( "ETauTree: Expected branch eMVAIDH2TauWP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIDH2TauWP")
        else:
            self.eMVAIDH2TauWP_branch.SetAddress(<void*>&self.eMVAIDH2TauWP_value)

        #print "making eMVANonTrig"
        self.eMVANonTrig_branch = the_tree.GetBranch("eMVANonTrig")
        #if not self.eMVANonTrig_branch and "eMVANonTrig" not in self.complained:
        if not self.eMVANonTrig_branch and "eMVANonTrig":
            warnings.warn( "ETauTree: Expected branch eMVANonTrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANonTrig")
        else:
            self.eMVANonTrig_branch.SetAddress(<void*>&self.eMVANonTrig_value)

        #print "making eMVATrig"
        self.eMVATrig_branch = the_tree.GetBranch("eMVATrig")
        #if not self.eMVATrig_branch and "eMVATrig" not in self.complained:
        if not self.eMVATrig_branch and "eMVATrig":
            warnings.warn( "ETauTree: Expected branch eMVATrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrig")
        else:
            self.eMVATrig_branch.SetAddress(<void*>&self.eMVATrig_value)

        #print "making eMVATrigIDISO"
        self.eMVATrigIDISO_branch = the_tree.GetBranch("eMVATrigIDISO")
        #if not self.eMVATrigIDISO_branch and "eMVATrigIDISO" not in self.complained:
        if not self.eMVATrigIDISO_branch and "eMVATrigIDISO":
            warnings.warn( "ETauTree: Expected branch eMVATrigIDISO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigIDISO")
        else:
            self.eMVATrigIDISO_branch.SetAddress(<void*>&self.eMVATrigIDISO_value)

        #print "making eMVATrigIDISOPUSUB"
        self.eMVATrigIDISOPUSUB_branch = the_tree.GetBranch("eMVATrigIDISOPUSUB")
        #if not self.eMVATrigIDISOPUSUB_branch and "eMVATrigIDISOPUSUB" not in self.complained:
        if not self.eMVATrigIDISOPUSUB_branch and "eMVATrigIDISOPUSUB":
            warnings.warn( "ETauTree: Expected branch eMVATrigIDISOPUSUB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigIDISOPUSUB")
        else:
            self.eMVATrigIDISOPUSUB_branch.SetAddress(<void*>&self.eMVATrigIDISOPUSUB_value)

        #print "making eMVATrigNoIP"
        self.eMVATrigNoIP_branch = the_tree.GetBranch("eMVATrigNoIP")
        #if not self.eMVATrigNoIP_branch and "eMVATrigNoIP" not in self.complained:
        if not self.eMVATrigNoIP_branch and "eMVATrigNoIP":
            warnings.warn( "ETauTree: Expected branch eMVATrigNoIP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigNoIP")
        else:
            self.eMVATrigNoIP_branch.SetAddress(<void*>&self.eMVATrigNoIP_value)

        #print "making eMass"
        self.eMass_branch = the_tree.GetBranch("eMass")
        #if not self.eMass_branch and "eMass" not in self.complained:
        if not self.eMass_branch and "eMass":
            warnings.warn( "ETauTree: Expected branch eMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMass")
        else:
            self.eMass_branch.SetAddress(<void*>&self.eMass_value)

        #print "making eMatchesDoubleEPath"
        self.eMatchesDoubleEPath_branch = the_tree.GetBranch("eMatchesDoubleEPath")
        #if not self.eMatchesDoubleEPath_branch and "eMatchesDoubleEPath" not in self.complained:
        if not self.eMatchesDoubleEPath_branch and "eMatchesDoubleEPath":
            warnings.warn( "ETauTree: Expected branch eMatchesDoubleEPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesDoubleEPath")
        else:
            self.eMatchesDoubleEPath_branch.SetAddress(<void*>&self.eMatchesDoubleEPath_value)

        #print "making eMatchesMu17Ele8IsoPath"
        self.eMatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("eMatchesMu17Ele8IsoPath")
        #if not self.eMatchesMu17Ele8IsoPath_branch and "eMatchesMu17Ele8IsoPath" not in self.complained:
        if not self.eMatchesMu17Ele8IsoPath_branch and "eMatchesMu17Ele8IsoPath":
            warnings.warn( "ETauTree: Expected branch eMatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu17Ele8IsoPath")
        else:
            self.eMatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.eMatchesMu17Ele8IsoPath_value)

        #print "making eMatchesMu17Ele8Path"
        self.eMatchesMu17Ele8Path_branch = the_tree.GetBranch("eMatchesMu17Ele8Path")
        #if not self.eMatchesMu17Ele8Path_branch and "eMatchesMu17Ele8Path" not in self.complained:
        if not self.eMatchesMu17Ele8Path_branch and "eMatchesMu17Ele8Path":
            warnings.warn( "ETauTree: Expected branch eMatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu17Ele8Path")
        else:
            self.eMatchesMu17Ele8Path_branch.SetAddress(<void*>&self.eMatchesMu17Ele8Path_value)

        #print "making eMatchesMu8Ele17IsoPath"
        self.eMatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("eMatchesMu8Ele17IsoPath")
        #if not self.eMatchesMu8Ele17IsoPath_branch and "eMatchesMu8Ele17IsoPath" not in self.complained:
        if not self.eMatchesMu8Ele17IsoPath_branch and "eMatchesMu8Ele17IsoPath":
            warnings.warn( "ETauTree: Expected branch eMatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8Ele17IsoPath")
        else:
            self.eMatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.eMatchesMu8Ele17IsoPath_value)

        #print "making eMatchesMu8Ele17Path"
        self.eMatchesMu8Ele17Path_branch = the_tree.GetBranch("eMatchesMu8Ele17Path")
        #if not self.eMatchesMu8Ele17Path_branch and "eMatchesMu8Ele17Path" not in self.complained:
        if not self.eMatchesMu8Ele17Path_branch and "eMatchesMu8Ele17Path":
            warnings.warn( "ETauTree: Expected branch eMatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8Ele17Path")
        else:
            self.eMatchesMu8Ele17Path_branch.SetAddress(<void*>&self.eMatchesMu8Ele17Path_value)

        #print "making eMatchesSingleE"
        self.eMatchesSingleE_branch = the_tree.GetBranch("eMatchesSingleE")
        #if not self.eMatchesSingleE_branch and "eMatchesSingleE" not in self.complained:
        if not self.eMatchesSingleE_branch and "eMatchesSingleE":
            warnings.warn( "ETauTree: Expected branch eMatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleE")
        else:
            self.eMatchesSingleE_branch.SetAddress(<void*>&self.eMatchesSingleE_value)

        #print "making eMatchesSingleE27WP80"
        self.eMatchesSingleE27WP80_branch = the_tree.GetBranch("eMatchesSingleE27WP80")
        #if not self.eMatchesSingleE27WP80_branch and "eMatchesSingleE27WP80" not in self.complained:
        if not self.eMatchesSingleE27WP80_branch and "eMatchesSingleE27WP80":
            warnings.warn( "ETauTree: Expected branch eMatchesSingleE27WP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleE27WP80")
        else:
            self.eMatchesSingleE27WP80_branch.SetAddress(<void*>&self.eMatchesSingleE27WP80_value)

        #print "making eMatchesSingleEPlusMET"
        self.eMatchesSingleEPlusMET_branch = the_tree.GetBranch("eMatchesSingleEPlusMET")
        #if not self.eMatchesSingleEPlusMET_branch and "eMatchesSingleEPlusMET" not in self.complained:
        if not self.eMatchesSingleEPlusMET_branch and "eMatchesSingleEPlusMET":
            warnings.warn( "ETauTree: Expected branch eMatchesSingleEPlusMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleEPlusMET")
        else:
            self.eMatchesSingleEPlusMET_branch.SetAddress(<void*>&self.eMatchesSingleEPlusMET_value)

        #print "making eMissingHits"
        self.eMissingHits_branch = the_tree.GetBranch("eMissingHits")
        #if not self.eMissingHits_branch and "eMissingHits" not in self.complained:
        if not self.eMissingHits_branch and "eMissingHits":
            warnings.warn( "ETauTree: Expected branch eMissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMissingHits")
        else:
            self.eMissingHits_branch.SetAddress(<void*>&self.eMissingHits_value)

        #print "making eMtToMET"
        self.eMtToMET_branch = the_tree.GetBranch("eMtToMET")
        #if not self.eMtToMET_branch and "eMtToMET" not in self.complained:
        if not self.eMtToMET_branch and "eMtToMET":
            warnings.warn( "ETauTree: Expected branch eMtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToMET")
        else:
            self.eMtToMET_branch.SetAddress(<void*>&self.eMtToMET_value)

        #print "making eMtToMVAMET"
        self.eMtToMVAMET_branch = the_tree.GetBranch("eMtToMVAMET")
        #if not self.eMtToMVAMET_branch and "eMtToMVAMET" not in self.complained:
        if not self.eMtToMVAMET_branch and "eMtToMVAMET":
            warnings.warn( "ETauTree: Expected branch eMtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToMVAMET")
        else:
            self.eMtToMVAMET_branch.SetAddress(<void*>&self.eMtToMVAMET_value)

        #print "making eMtToPfMet"
        self.eMtToPfMet_branch = the_tree.GetBranch("eMtToPfMet")
        #if not self.eMtToPfMet_branch and "eMtToPfMet" not in self.complained:
        if not self.eMtToPfMet_branch and "eMtToPfMet":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet")
        else:
            self.eMtToPfMet_branch.SetAddress(<void*>&self.eMtToPfMet_value)

        #print "making eMtToPfMet_Ty1"
        self.eMtToPfMet_Ty1_branch = the_tree.GetBranch("eMtToPfMet_Ty1")
        #if not self.eMtToPfMet_Ty1_branch and "eMtToPfMet_Ty1" not in self.complained:
        if not self.eMtToPfMet_Ty1_branch and "eMtToPfMet_Ty1":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_Ty1")
        else:
            self.eMtToPfMet_Ty1_branch.SetAddress(<void*>&self.eMtToPfMet_Ty1_value)

        #print "making eMtToPfMet_ees"
        self.eMtToPfMet_ees_branch = the_tree.GetBranch("eMtToPfMet_ees")
        #if not self.eMtToPfMet_ees_branch and "eMtToPfMet_ees" not in self.complained:
        if not self.eMtToPfMet_ees_branch and "eMtToPfMet_ees":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_ees does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_ees")
        else:
            self.eMtToPfMet_ees_branch.SetAddress(<void*>&self.eMtToPfMet_ees_value)

        #print "making eMtToPfMet_ees_minus"
        self.eMtToPfMet_ees_minus_branch = the_tree.GetBranch("eMtToPfMet_ees_minus")
        #if not self.eMtToPfMet_ees_minus_branch and "eMtToPfMet_ees_minus" not in self.complained:
        if not self.eMtToPfMet_ees_minus_branch and "eMtToPfMet_ees_minus":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_ees_minus")
        else:
            self.eMtToPfMet_ees_minus_branch.SetAddress(<void*>&self.eMtToPfMet_ees_minus_value)

        #print "making eMtToPfMet_ees_plus"
        self.eMtToPfMet_ees_plus_branch = the_tree.GetBranch("eMtToPfMet_ees_plus")
        #if not self.eMtToPfMet_ees_plus_branch and "eMtToPfMet_ees_plus" not in self.complained:
        if not self.eMtToPfMet_ees_plus_branch and "eMtToPfMet_ees_plus":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_ees_plus")
        else:
            self.eMtToPfMet_ees_plus_branch.SetAddress(<void*>&self.eMtToPfMet_ees_plus_value)

        #print "making eMtToPfMet_jes"
        self.eMtToPfMet_jes_branch = the_tree.GetBranch("eMtToPfMet_jes")
        #if not self.eMtToPfMet_jes_branch and "eMtToPfMet_jes" not in self.complained:
        if not self.eMtToPfMet_jes_branch and "eMtToPfMet_jes":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_jes")
        else:
            self.eMtToPfMet_jes_branch.SetAddress(<void*>&self.eMtToPfMet_jes_value)

        #print "making eMtToPfMet_jes_minus"
        self.eMtToPfMet_jes_minus_branch = the_tree.GetBranch("eMtToPfMet_jes_minus")
        #if not self.eMtToPfMet_jes_minus_branch and "eMtToPfMet_jes_minus" not in self.complained:
        if not self.eMtToPfMet_jes_minus_branch and "eMtToPfMet_jes_minus":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_jes_minus")
        else:
            self.eMtToPfMet_jes_minus_branch.SetAddress(<void*>&self.eMtToPfMet_jes_minus_value)

        #print "making eMtToPfMet_jes_plus"
        self.eMtToPfMet_jes_plus_branch = the_tree.GetBranch("eMtToPfMet_jes_plus")
        #if not self.eMtToPfMet_jes_plus_branch and "eMtToPfMet_jes_plus" not in self.complained:
        if not self.eMtToPfMet_jes_plus_branch and "eMtToPfMet_jes_plus":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_jes_plus")
        else:
            self.eMtToPfMet_jes_plus_branch.SetAddress(<void*>&self.eMtToPfMet_jes_plus_value)

        #print "making eMtToPfMet_mes"
        self.eMtToPfMet_mes_branch = the_tree.GetBranch("eMtToPfMet_mes")
        #if not self.eMtToPfMet_mes_branch and "eMtToPfMet_mes" not in self.complained:
        if not self.eMtToPfMet_mes_branch and "eMtToPfMet_mes":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_mes")
        else:
            self.eMtToPfMet_mes_branch.SetAddress(<void*>&self.eMtToPfMet_mes_value)

        #print "making eMtToPfMet_mes_minus"
        self.eMtToPfMet_mes_minus_branch = the_tree.GetBranch("eMtToPfMet_mes_minus")
        #if not self.eMtToPfMet_mes_minus_branch and "eMtToPfMet_mes_minus" not in self.complained:
        if not self.eMtToPfMet_mes_minus_branch and "eMtToPfMet_mes_minus":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_mes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_mes_minus")
        else:
            self.eMtToPfMet_mes_minus_branch.SetAddress(<void*>&self.eMtToPfMet_mes_minus_value)

        #print "making eMtToPfMet_mes_plus"
        self.eMtToPfMet_mes_plus_branch = the_tree.GetBranch("eMtToPfMet_mes_plus")
        #if not self.eMtToPfMet_mes_plus_branch and "eMtToPfMet_mes_plus" not in self.complained:
        if not self.eMtToPfMet_mes_plus_branch and "eMtToPfMet_mes_plus":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_mes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_mes_plus")
        else:
            self.eMtToPfMet_mes_plus_branch.SetAddress(<void*>&self.eMtToPfMet_mes_plus_value)

        #print "making eMtToPfMet_tes"
        self.eMtToPfMet_tes_branch = the_tree.GetBranch("eMtToPfMet_tes")
        #if not self.eMtToPfMet_tes_branch and "eMtToPfMet_tes" not in self.complained:
        if not self.eMtToPfMet_tes_branch and "eMtToPfMet_tes":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_tes")
        else:
            self.eMtToPfMet_tes_branch.SetAddress(<void*>&self.eMtToPfMet_tes_value)

        #print "making eMtToPfMet_tes_minus"
        self.eMtToPfMet_tes_minus_branch = the_tree.GetBranch("eMtToPfMet_tes_minus")
        #if not self.eMtToPfMet_tes_minus_branch and "eMtToPfMet_tes_minus" not in self.complained:
        if not self.eMtToPfMet_tes_minus_branch and "eMtToPfMet_tes_minus":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_tes_minus")
        else:
            self.eMtToPfMet_tes_minus_branch.SetAddress(<void*>&self.eMtToPfMet_tes_minus_value)

        #print "making eMtToPfMet_tes_plus"
        self.eMtToPfMet_tes_plus_branch = the_tree.GetBranch("eMtToPfMet_tes_plus")
        #if not self.eMtToPfMet_tes_plus_branch and "eMtToPfMet_tes_plus" not in self.complained:
        if not self.eMtToPfMet_tes_plus_branch and "eMtToPfMet_tes_plus":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_tes_plus")
        else:
            self.eMtToPfMet_tes_plus_branch.SetAddress(<void*>&self.eMtToPfMet_tes_plus_value)

        #print "making eMtToPfMet_ues"
        self.eMtToPfMet_ues_branch = the_tree.GetBranch("eMtToPfMet_ues")
        #if not self.eMtToPfMet_ues_branch and "eMtToPfMet_ues" not in self.complained:
        if not self.eMtToPfMet_ues_branch and "eMtToPfMet_ues":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_ues")
        else:
            self.eMtToPfMet_ues_branch.SetAddress(<void*>&self.eMtToPfMet_ues_value)

        #print "making eMtToPfMet_ues_minus"
        self.eMtToPfMet_ues_minus_branch = the_tree.GetBranch("eMtToPfMet_ues_minus")
        #if not self.eMtToPfMet_ues_minus_branch and "eMtToPfMet_ues_minus" not in self.complained:
        if not self.eMtToPfMet_ues_minus_branch and "eMtToPfMet_ues_minus":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_ues_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_ues_minus")
        else:
            self.eMtToPfMet_ues_minus_branch.SetAddress(<void*>&self.eMtToPfMet_ues_minus_value)

        #print "making eMtToPfMet_ues_plus"
        self.eMtToPfMet_ues_plus_branch = the_tree.GetBranch("eMtToPfMet_ues_plus")
        #if not self.eMtToPfMet_ues_plus_branch and "eMtToPfMet_ues_plus" not in self.complained:
        if not self.eMtToPfMet_ues_plus_branch and "eMtToPfMet_ues_plus":
            warnings.warn( "ETauTree: Expected branch eMtToPfMet_ues_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_ues_plus")
        else:
            self.eMtToPfMet_ues_plus_branch.SetAddress(<void*>&self.eMtToPfMet_ues_plus_value)

        #print "making eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter"
        self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch = the_tree.GetBranch("eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        #if not self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter" not in self.complained:
        if not self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter":
            warnings.warn( "ETauTree: Expected branch eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        else:
            self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.SetAddress(<void*>&self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value)

        #print "making eMu17Ele8CaloIdTPixelMatchFilter"
        self.eMu17Ele8CaloIdTPixelMatchFilter_branch = the_tree.GetBranch("eMu17Ele8CaloIdTPixelMatchFilter")
        #if not self.eMu17Ele8CaloIdTPixelMatchFilter_branch and "eMu17Ele8CaloIdTPixelMatchFilter" not in self.complained:
        if not self.eMu17Ele8CaloIdTPixelMatchFilter_branch and "eMu17Ele8CaloIdTPixelMatchFilter":
            warnings.warn( "ETauTree: Expected branch eMu17Ele8CaloIdTPixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMu17Ele8CaloIdTPixelMatchFilter")
        else:
            self.eMu17Ele8CaloIdTPixelMatchFilter_branch.SetAddress(<void*>&self.eMu17Ele8CaloIdTPixelMatchFilter_value)

        #print "making eMu17Ele8dZFilter"
        self.eMu17Ele8dZFilter_branch = the_tree.GetBranch("eMu17Ele8dZFilter")
        #if not self.eMu17Ele8dZFilter_branch and "eMu17Ele8dZFilter" not in self.complained:
        if not self.eMu17Ele8dZFilter_branch and "eMu17Ele8dZFilter":
            warnings.warn( "ETauTree: Expected branch eMu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMu17Ele8dZFilter")
        else:
            self.eMu17Ele8dZFilter_branch.SetAddress(<void*>&self.eMu17Ele8dZFilter_value)

        #print "making eNearMuonVeto"
        self.eNearMuonVeto_branch = the_tree.GetBranch("eNearMuonVeto")
        #if not self.eNearMuonVeto_branch and "eNearMuonVeto" not in self.complained:
        if not self.eNearMuonVeto_branch and "eNearMuonVeto":
            warnings.warn( "ETauTree: Expected branch eNearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearMuonVeto")
        else:
            self.eNearMuonVeto_branch.SetAddress(<void*>&self.eNearMuonVeto_value)

        #print "making ePFChargedIso"
        self.ePFChargedIso_branch = the_tree.GetBranch("ePFChargedIso")
        #if not self.ePFChargedIso_branch and "ePFChargedIso" not in self.complained:
        if not self.ePFChargedIso_branch and "ePFChargedIso":
            warnings.warn( "ETauTree: Expected branch ePFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFChargedIso")
        else:
            self.ePFChargedIso_branch.SetAddress(<void*>&self.ePFChargedIso_value)

        #print "making ePFNeutralIso"
        self.ePFNeutralIso_branch = the_tree.GetBranch("ePFNeutralIso")
        #if not self.ePFNeutralIso_branch and "ePFNeutralIso" not in self.complained:
        if not self.ePFNeutralIso_branch and "ePFNeutralIso":
            warnings.warn( "ETauTree: Expected branch ePFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFNeutralIso")
        else:
            self.ePFNeutralIso_branch.SetAddress(<void*>&self.ePFNeutralIso_value)

        #print "making ePFPhotonIso"
        self.ePFPhotonIso_branch = the_tree.GetBranch("ePFPhotonIso")
        #if not self.ePFPhotonIso_branch and "ePFPhotonIso" not in self.complained:
        if not self.ePFPhotonIso_branch and "ePFPhotonIso":
            warnings.warn( "ETauTree: Expected branch ePFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFPhotonIso")
        else:
            self.ePFPhotonIso_branch.SetAddress(<void*>&self.ePFPhotonIso_value)

        #print "making ePVDXY"
        self.ePVDXY_branch = the_tree.GetBranch("ePVDXY")
        #if not self.ePVDXY_branch and "ePVDXY" not in self.complained:
        if not self.ePVDXY_branch and "ePVDXY":
            warnings.warn( "ETauTree: Expected branch ePVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDXY")
        else:
            self.ePVDXY_branch.SetAddress(<void*>&self.ePVDXY_value)

        #print "making ePVDZ"
        self.ePVDZ_branch = the_tree.GetBranch("ePVDZ")
        #if not self.ePVDZ_branch and "ePVDZ" not in self.complained:
        if not self.ePVDZ_branch and "ePVDZ":
            warnings.warn( "ETauTree: Expected branch ePVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDZ")
        else:
            self.ePVDZ_branch.SetAddress(<void*>&self.ePVDZ_value)

        #print "making ePhi"
        self.ePhi_branch = the_tree.GetBranch("ePhi")
        #if not self.ePhi_branch and "ePhi" not in self.complained:
        if not self.ePhi_branch and "ePhi":
            warnings.warn( "ETauTree: Expected branch ePhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhi")
        else:
            self.ePhi_branch.SetAddress(<void*>&self.ePhi_value)

        #print "making ePhiCorrReg_2012Jul13ReReco"
        self.ePhiCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePhiCorrReg_2012Jul13ReReco")
        #if not self.ePhiCorrReg_2012Jul13ReReco_branch and "ePhiCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.ePhiCorrReg_2012Jul13ReReco_branch and "ePhiCorrReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch ePhiCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_2012Jul13ReReco")
        else:
            self.ePhiCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePhiCorrReg_2012Jul13ReReco_value)

        #print "making ePhiCorrReg_Fall11"
        self.ePhiCorrReg_Fall11_branch = the_tree.GetBranch("ePhiCorrReg_Fall11")
        #if not self.ePhiCorrReg_Fall11_branch and "ePhiCorrReg_Fall11" not in self.complained:
        if not self.ePhiCorrReg_Fall11_branch and "ePhiCorrReg_Fall11":
            warnings.warn( "ETauTree: Expected branch ePhiCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_Fall11")
        else:
            self.ePhiCorrReg_Fall11_branch.SetAddress(<void*>&self.ePhiCorrReg_Fall11_value)

        #print "making ePhiCorrReg_Jan16ReReco"
        self.ePhiCorrReg_Jan16ReReco_branch = the_tree.GetBranch("ePhiCorrReg_Jan16ReReco")
        #if not self.ePhiCorrReg_Jan16ReReco_branch and "ePhiCorrReg_Jan16ReReco" not in self.complained:
        if not self.ePhiCorrReg_Jan16ReReco_branch and "ePhiCorrReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch ePhiCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_Jan16ReReco")
        else:
            self.ePhiCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePhiCorrReg_Jan16ReReco_value)

        #print "making ePhiCorrReg_Summer12_DR53X_HCP2012"
        self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePhiCorrReg_Summer12_DR53X_HCP2012")
        #if not self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch ePhiCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePhiCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making ePhiCorrSmearedNoReg_2012Jul13ReReco"
        self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch and "ePhiCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch and "ePhiCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch ePhiCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making ePhiCorrSmearedNoReg_Fall11"
        self.ePhiCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_Fall11")
        #if not self.ePhiCorrSmearedNoReg_Fall11_branch and "ePhiCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_Fall11_branch and "ePhiCorrSmearedNoReg_Fall11":
            warnings.warn( "ETauTree: Expected branch ePhiCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_Fall11")
        else:
            self.ePhiCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_Fall11_value)

        #print "making ePhiCorrSmearedNoReg_Jan16ReReco"
        self.ePhiCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_Jan16ReReco")
        #if not self.ePhiCorrSmearedNoReg_Jan16ReReco_branch and "ePhiCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_Jan16ReReco_branch and "ePhiCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch ePhiCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_Jan16ReReco")
        else:
            self.ePhiCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_Jan16ReReco_value)

        #print "making ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making ePhiCorrSmearedReg_2012Jul13ReReco"
        self.ePhiCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedReg_2012Jul13ReReco")
        #if not self.ePhiCorrSmearedReg_2012Jul13ReReco_branch and "ePhiCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.ePhiCorrSmearedReg_2012Jul13ReReco_branch and "ePhiCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch ePhiCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_2012Jul13ReReco")
        else:
            self.ePhiCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_2012Jul13ReReco_value)

        #print "making ePhiCorrSmearedReg_Fall11"
        self.ePhiCorrSmearedReg_Fall11_branch = the_tree.GetBranch("ePhiCorrSmearedReg_Fall11")
        #if not self.ePhiCorrSmearedReg_Fall11_branch and "ePhiCorrSmearedReg_Fall11" not in self.complained:
        if not self.ePhiCorrSmearedReg_Fall11_branch and "ePhiCorrSmearedReg_Fall11":
            warnings.warn( "ETauTree: Expected branch ePhiCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_Fall11")
        else:
            self.ePhiCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_Fall11_value)

        #print "making ePhiCorrSmearedReg_Jan16ReReco"
        self.ePhiCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedReg_Jan16ReReco")
        #if not self.ePhiCorrSmearedReg_Jan16ReReco_branch and "ePhiCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.ePhiCorrSmearedReg_Jan16ReReco_branch and "ePhiCorrSmearedReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch ePhiCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_Jan16ReReco")
        else:
            self.ePhiCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_Jan16ReReco_value)

        #print "making ePhiCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch ePhiCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making ePt"
        self.ePt_branch = the_tree.GetBranch("ePt")
        #if not self.ePt_branch and "ePt" not in self.complained:
        if not self.ePt_branch and "ePt":
            warnings.warn( "ETauTree: Expected branch ePt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt")
        else:
            self.ePt_branch.SetAddress(<void*>&self.ePt_value)

        #print "making ePtCorrReg_2012Jul13ReReco"
        self.ePtCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePtCorrReg_2012Jul13ReReco")
        #if not self.ePtCorrReg_2012Jul13ReReco_branch and "ePtCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.ePtCorrReg_2012Jul13ReReco_branch and "ePtCorrReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch ePtCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_2012Jul13ReReco")
        else:
            self.ePtCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePtCorrReg_2012Jul13ReReco_value)

        #print "making ePtCorrReg_Fall11"
        self.ePtCorrReg_Fall11_branch = the_tree.GetBranch("ePtCorrReg_Fall11")
        #if not self.ePtCorrReg_Fall11_branch and "ePtCorrReg_Fall11" not in self.complained:
        if not self.ePtCorrReg_Fall11_branch and "ePtCorrReg_Fall11":
            warnings.warn( "ETauTree: Expected branch ePtCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_Fall11")
        else:
            self.ePtCorrReg_Fall11_branch.SetAddress(<void*>&self.ePtCorrReg_Fall11_value)

        #print "making ePtCorrReg_Jan16ReReco"
        self.ePtCorrReg_Jan16ReReco_branch = the_tree.GetBranch("ePtCorrReg_Jan16ReReco")
        #if not self.ePtCorrReg_Jan16ReReco_branch and "ePtCorrReg_Jan16ReReco" not in self.complained:
        if not self.ePtCorrReg_Jan16ReReco_branch and "ePtCorrReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch ePtCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_Jan16ReReco")
        else:
            self.ePtCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePtCorrReg_Jan16ReReco_value)

        #print "making ePtCorrReg_Summer12_DR53X_HCP2012"
        self.ePtCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePtCorrReg_Summer12_DR53X_HCP2012")
        #if not self.ePtCorrReg_Summer12_DR53X_HCP2012_branch and "ePtCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePtCorrReg_Summer12_DR53X_HCP2012_branch and "ePtCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch ePtCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.ePtCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePtCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making ePtCorrSmearedNoReg_2012Jul13ReReco"
        self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch and "ePtCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch and "ePtCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch ePtCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making ePtCorrSmearedNoReg_Fall11"
        self.ePtCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_Fall11")
        #if not self.ePtCorrSmearedNoReg_Fall11_branch and "ePtCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.ePtCorrSmearedNoReg_Fall11_branch and "ePtCorrSmearedNoReg_Fall11":
            warnings.warn( "ETauTree: Expected branch ePtCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_Fall11")
        else:
            self.ePtCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_Fall11_value)

        #print "making ePtCorrSmearedNoReg_Jan16ReReco"
        self.ePtCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_Jan16ReReco")
        #if not self.ePtCorrSmearedNoReg_Jan16ReReco_branch and "ePtCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.ePtCorrSmearedNoReg_Jan16ReReco_branch and "ePtCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch ePtCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_Jan16ReReco")
        else:
            self.ePtCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_Jan16ReReco_value)

        #print "making ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making ePtCorrSmearedReg_2012Jul13ReReco"
        self.ePtCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePtCorrSmearedReg_2012Jul13ReReco")
        #if not self.ePtCorrSmearedReg_2012Jul13ReReco_branch and "ePtCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.ePtCorrSmearedReg_2012Jul13ReReco_branch and "ePtCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch ePtCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_2012Jul13ReReco")
        else:
            self.ePtCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_2012Jul13ReReco_value)

        #print "making ePtCorrSmearedReg_Fall11"
        self.ePtCorrSmearedReg_Fall11_branch = the_tree.GetBranch("ePtCorrSmearedReg_Fall11")
        #if not self.ePtCorrSmearedReg_Fall11_branch and "ePtCorrSmearedReg_Fall11" not in self.complained:
        if not self.ePtCorrSmearedReg_Fall11_branch and "ePtCorrSmearedReg_Fall11":
            warnings.warn( "ETauTree: Expected branch ePtCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_Fall11")
        else:
            self.ePtCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_Fall11_value)

        #print "making ePtCorrSmearedReg_Jan16ReReco"
        self.ePtCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("ePtCorrSmearedReg_Jan16ReReco")
        #if not self.ePtCorrSmearedReg_Jan16ReReco_branch and "ePtCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.ePtCorrSmearedReg_Jan16ReReco_branch and "ePtCorrSmearedReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch ePtCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_Jan16ReReco")
        else:
            self.ePtCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_Jan16ReReco_value)

        #print "making ePtCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePtCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch ePtCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making ePt_ees_minus"
        self.ePt_ees_minus_branch = the_tree.GetBranch("ePt_ees_minus")
        #if not self.ePt_ees_minus_branch and "ePt_ees_minus" not in self.complained:
        if not self.ePt_ees_minus_branch and "ePt_ees_minus":
            warnings.warn( "ETauTree: Expected branch ePt_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt_ees_minus")
        else:
            self.ePt_ees_minus_branch.SetAddress(<void*>&self.ePt_ees_minus_value)

        #print "making ePt_ees_plus"
        self.ePt_ees_plus_branch = the_tree.GetBranch("ePt_ees_plus")
        #if not self.ePt_ees_plus_branch and "ePt_ees_plus" not in self.complained:
        if not self.ePt_ees_plus_branch and "ePt_ees_plus":
            warnings.warn( "ETauTree: Expected branch ePt_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt_ees_plus")
        else:
            self.ePt_ees_plus_branch.SetAddress(<void*>&self.ePt_ees_plus_value)

        #print "making ePt_tes_minus"
        self.ePt_tes_minus_branch = the_tree.GetBranch("ePt_tes_minus")
        #if not self.ePt_tes_minus_branch and "ePt_tes_minus" not in self.complained:
        if not self.ePt_tes_minus_branch and "ePt_tes_minus":
            warnings.warn( "ETauTree: Expected branch ePt_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt_tes_minus")
        else:
            self.ePt_tes_minus_branch.SetAddress(<void*>&self.ePt_tes_minus_value)

        #print "making ePt_tes_plus"
        self.ePt_tes_plus_branch = the_tree.GetBranch("ePt_tes_plus")
        #if not self.ePt_tes_plus_branch and "ePt_tes_plus" not in self.complained:
        if not self.ePt_tes_plus_branch and "ePt_tes_plus":
            warnings.warn( "ETauTree: Expected branch ePt_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt_tes_plus")
        else:
            self.ePt_tes_plus_branch.SetAddress(<void*>&self.ePt_tes_plus_value)

        #print "making eRank"
        self.eRank_branch = the_tree.GetBranch("eRank")
        #if not self.eRank_branch and "eRank" not in self.complained:
        if not self.eRank_branch and "eRank":
            warnings.warn( "ETauTree: Expected branch eRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRank")
        else:
            self.eRank_branch.SetAddress(<void*>&self.eRank_value)

        #print "making eRelIso"
        self.eRelIso_branch = the_tree.GetBranch("eRelIso")
        #if not self.eRelIso_branch and "eRelIso" not in self.complained:
        if not self.eRelIso_branch and "eRelIso":
            warnings.warn( "ETauTree: Expected branch eRelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelIso")
        else:
            self.eRelIso_branch.SetAddress(<void*>&self.eRelIso_value)

        #print "making eRelPFIsoDB"
        self.eRelPFIsoDB_branch = the_tree.GetBranch("eRelPFIsoDB")
        #if not self.eRelPFIsoDB_branch and "eRelPFIsoDB" not in self.complained:
        if not self.eRelPFIsoDB_branch and "eRelPFIsoDB":
            warnings.warn( "ETauTree: Expected branch eRelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoDB")
        else:
            self.eRelPFIsoDB_branch.SetAddress(<void*>&self.eRelPFIsoDB_value)

        #print "making eRelPFIsoRho"
        self.eRelPFIsoRho_branch = the_tree.GetBranch("eRelPFIsoRho")
        #if not self.eRelPFIsoRho_branch and "eRelPFIsoRho" not in self.complained:
        if not self.eRelPFIsoRho_branch and "eRelPFIsoRho":
            warnings.warn( "ETauTree: Expected branch eRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRho")
        else:
            self.eRelPFIsoRho_branch.SetAddress(<void*>&self.eRelPFIsoRho_value)

        #print "making eRelPFIsoRhoFSR"
        self.eRelPFIsoRhoFSR_branch = the_tree.GetBranch("eRelPFIsoRhoFSR")
        #if not self.eRelPFIsoRhoFSR_branch and "eRelPFIsoRhoFSR" not in self.complained:
        if not self.eRelPFIsoRhoFSR_branch and "eRelPFIsoRhoFSR":
            warnings.warn( "ETauTree: Expected branch eRelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRhoFSR")
        else:
            self.eRelPFIsoRhoFSR_branch.SetAddress(<void*>&self.eRelPFIsoRhoFSR_value)

        #print "making eRhoHZG2011"
        self.eRhoHZG2011_branch = the_tree.GetBranch("eRhoHZG2011")
        #if not self.eRhoHZG2011_branch and "eRhoHZG2011" not in self.complained:
        if not self.eRhoHZG2011_branch and "eRhoHZG2011":
            warnings.warn( "ETauTree: Expected branch eRhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRhoHZG2011")
        else:
            self.eRhoHZG2011_branch.SetAddress(<void*>&self.eRhoHZG2011_value)

        #print "making eRhoHZG2012"
        self.eRhoHZG2012_branch = the_tree.GetBranch("eRhoHZG2012")
        #if not self.eRhoHZG2012_branch and "eRhoHZG2012" not in self.complained:
        if not self.eRhoHZG2012_branch and "eRhoHZG2012":
            warnings.warn( "ETauTree: Expected branch eRhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRhoHZG2012")
        else:
            self.eRhoHZG2012_branch.SetAddress(<void*>&self.eRhoHZG2012_value)

        #print "making eSCEnergy"
        self.eSCEnergy_branch = the_tree.GetBranch("eSCEnergy")
        #if not self.eSCEnergy_branch and "eSCEnergy" not in self.complained:
        if not self.eSCEnergy_branch and "eSCEnergy":
            warnings.warn( "ETauTree: Expected branch eSCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEnergy")
        else:
            self.eSCEnergy_branch.SetAddress(<void*>&self.eSCEnergy_value)

        #print "making eSCEta"
        self.eSCEta_branch = the_tree.GetBranch("eSCEta")
        #if not self.eSCEta_branch and "eSCEta" not in self.complained:
        if not self.eSCEta_branch and "eSCEta":
            warnings.warn( "ETauTree: Expected branch eSCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEta")
        else:
            self.eSCEta_branch.SetAddress(<void*>&self.eSCEta_value)

        #print "making eSCEtaWidth"
        self.eSCEtaWidth_branch = the_tree.GetBranch("eSCEtaWidth")
        #if not self.eSCEtaWidth_branch and "eSCEtaWidth" not in self.complained:
        if not self.eSCEtaWidth_branch and "eSCEtaWidth":
            warnings.warn( "ETauTree: Expected branch eSCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEtaWidth")
        else:
            self.eSCEtaWidth_branch.SetAddress(<void*>&self.eSCEtaWidth_value)

        #print "making eSCPhi"
        self.eSCPhi_branch = the_tree.GetBranch("eSCPhi")
        #if not self.eSCPhi_branch and "eSCPhi" not in self.complained:
        if not self.eSCPhi_branch and "eSCPhi":
            warnings.warn( "ETauTree: Expected branch eSCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhi")
        else:
            self.eSCPhi_branch.SetAddress(<void*>&self.eSCPhi_value)

        #print "making eSCPhiWidth"
        self.eSCPhiWidth_branch = the_tree.GetBranch("eSCPhiWidth")
        #if not self.eSCPhiWidth_branch and "eSCPhiWidth" not in self.complained:
        if not self.eSCPhiWidth_branch and "eSCPhiWidth":
            warnings.warn( "ETauTree: Expected branch eSCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhiWidth")
        else:
            self.eSCPhiWidth_branch.SetAddress(<void*>&self.eSCPhiWidth_value)

        #print "making eSCPreshowerEnergy"
        self.eSCPreshowerEnergy_branch = the_tree.GetBranch("eSCPreshowerEnergy")
        #if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy" not in self.complained:
        if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy":
            warnings.warn( "ETauTree: Expected branch eSCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPreshowerEnergy")
        else:
            self.eSCPreshowerEnergy_branch.SetAddress(<void*>&self.eSCPreshowerEnergy_value)

        #print "making eSCRawEnergy"
        self.eSCRawEnergy_branch = the_tree.GetBranch("eSCRawEnergy")
        #if not self.eSCRawEnergy_branch and "eSCRawEnergy" not in self.complained:
        if not self.eSCRawEnergy_branch and "eSCRawEnergy":
            warnings.warn( "ETauTree: Expected branch eSCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCRawEnergy")
        else:
            self.eSCRawEnergy_branch.SetAddress(<void*>&self.eSCRawEnergy_value)

        #print "making eSigmaIEtaIEta"
        self.eSigmaIEtaIEta_branch = the_tree.GetBranch("eSigmaIEtaIEta")
        #if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta" not in self.complained:
        if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta":
            warnings.warn( "ETauTree: Expected branch eSigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSigmaIEtaIEta")
        else:
            self.eSigmaIEtaIEta_branch.SetAddress(<void*>&self.eSigmaIEtaIEta_value)

        #print "making eToMETDPhi"
        self.eToMETDPhi_branch = the_tree.GetBranch("eToMETDPhi")
        #if not self.eToMETDPhi_branch and "eToMETDPhi" not in self.complained:
        if not self.eToMETDPhi_branch and "eToMETDPhi":
            warnings.warn( "ETauTree: Expected branch eToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eToMETDPhi")
        else:
            self.eToMETDPhi_branch.SetAddress(<void*>&self.eToMETDPhi_value)

        #print "making eTrkIsoDR03"
        self.eTrkIsoDR03_branch = the_tree.GetBranch("eTrkIsoDR03")
        #if not self.eTrkIsoDR03_branch and "eTrkIsoDR03" not in self.complained:
        if not self.eTrkIsoDR03_branch and "eTrkIsoDR03":
            warnings.warn( "ETauTree: Expected branch eTrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTrkIsoDR03")
        else:
            self.eTrkIsoDR03_branch.SetAddress(<void*>&self.eTrkIsoDR03_value)

        #print "making eVZ"
        self.eVZ_branch = the_tree.GetBranch("eVZ")
        #if not self.eVZ_branch and "eVZ" not in self.complained:
        if not self.eVZ_branch and "eVZ":
            warnings.warn( "ETauTree: Expected branch eVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVZ")
        else:
            self.eVZ_branch.SetAddress(<void*>&self.eVZ_value)

        #print "making eVetoCicLooseIso"
        self.eVetoCicLooseIso_branch = the_tree.GetBranch("eVetoCicLooseIso")
        #if not self.eVetoCicLooseIso_branch and "eVetoCicLooseIso" not in self.complained:
        if not self.eVetoCicLooseIso_branch and "eVetoCicLooseIso":
            warnings.warn( "ETauTree: Expected branch eVetoCicLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicLooseIso")
        else:
            self.eVetoCicLooseIso_branch.SetAddress(<void*>&self.eVetoCicLooseIso_value)

        #print "making eVetoCicLooseIso_ees_minus"
        self.eVetoCicLooseIso_ees_minus_branch = the_tree.GetBranch("eVetoCicLooseIso_ees_minus")
        #if not self.eVetoCicLooseIso_ees_minus_branch and "eVetoCicLooseIso_ees_minus" not in self.complained:
        if not self.eVetoCicLooseIso_ees_minus_branch and "eVetoCicLooseIso_ees_minus":
            warnings.warn( "ETauTree: Expected branch eVetoCicLooseIso_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicLooseIso_ees_minus")
        else:
            self.eVetoCicLooseIso_ees_minus_branch.SetAddress(<void*>&self.eVetoCicLooseIso_ees_minus_value)

        #print "making eVetoCicLooseIso_ees_plus"
        self.eVetoCicLooseIso_ees_plus_branch = the_tree.GetBranch("eVetoCicLooseIso_ees_plus")
        #if not self.eVetoCicLooseIso_ees_plus_branch and "eVetoCicLooseIso_ees_plus" not in self.complained:
        if not self.eVetoCicLooseIso_ees_plus_branch and "eVetoCicLooseIso_ees_plus":
            warnings.warn( "ETauTree: Expected branch eVetoCicLooseIso_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicLooseIso_ees_plus")
        else:
            self.eVetoCicLooseIso_ees_plus_branch.SetAddress(<void*>&self.eVetoCicLooseIso_ees_plus_value)

        #print "making eVetoCicTightIso"
        self.eVetoCicTightIso_branch = the_tree.GetBranch("eVetoCicTightIso")
        #if not self.eVetoCicTightIso_branch and "eVetoCicTightIso" not in self.complained:
        if not self.eVetoCicTightIso_branch and "eVetoCicTightIso":
            warnings.warn( "ETauTree: Expected branch eVetoCicTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso")
        else:
            self.eVetoCicTightIso_branch.SetAddress(<void*>&self.eVetoCicTightIso_value)

        #print "making eVetoCicTightIso_ees_minus"
        self.eVetoCicTightIso_ees_minus_branch = the_tree.GetBranch("eVetoCicTightIso_ees_minus")
        #if not self.eVetoCicTightIso_ees_minus_branch and "eVetoCicTightIso_ees_minus" not in self.complained:
        if not self.eVetoCicTightIso_ees_minus_branch and "eVetoCicTightIso_ees_minus":
            warnings.warn( "ETauTree: Expected branch eVetoCicTightIso_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso_ees_minus")
        else:
            self.eVetoCicTightIso_ees_minus_branch.SetAddress(<void*>&self.eVetoCicTightIso_ees_minus_value)

        #print "making eVetoCicTightIso_ees_plus"
        self.eVetoCicTightIso_ees_plus_branch = the_tree.GetBranch("eVetoCicTightIso_ees_plus")
        #if not self.eVetoCicTightIso_ees_plus_branch and "eVetoCicTightIso_ees_plus" not in self.complained:
        if not self.eVetoCicTightIso_ees_plus_branch and "eVetoCicTightIso_ees_plus":
            warnings.warn( "ETauTree: Expected branch eVetoCicTightIso_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso_ees_plus")
        else:
            self.eVetoCicTightIso_ees_plus_branch.SetAddress(<void*>&self.eVetoCicTightIso_ees_plus_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "ETauTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "ETauTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eWWID"
        self.eWWID_branch = the_tree.GetBranch("eWWID")
        #if not self.eWWID_branch and "eWWID" not in self.complained:
        if not self.eWWID_branch and "eWWID":
            warnings.warn( "ETauTree: Expected branch eWWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eWWID")
        else:
            self.eWWID_branch.SetAddress(<void*>&self.eWWID_value)

        #print "making e_t_CosThetaStar"
        self.e_t_CosThetaStar_branch = the_tree.GetBranch("e_t_CosThetaStar")
        #if not self.e_t_CosThetaStar_branch and "e_t_CosThetaStar" not in self.complained:
        if not self.e_t_CosThetaStar_branch and "e_t_CosThetaStar":
            warnings.warn( "ETauTree: Expected branch e_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_CosThetaStar")
        else:
            self.e_t_CosThetaStar_branch.SetAddress(<void*>&self.e_t_CosThetaStar_value)

        #print "making e_t_DPhi"
        self.e_t_DPhi_branch = the_tree.GetBranch("e_t_DPhi")
        #if not self.e_t_DPhi_branch and "e_t_DPhi" not in self.complained:
        if not self.e_t_DPhi_branch and "e_t_DPhi":
            warnings.warn( "ETauTree: Expected branch e_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_DPhi")
        else:
            self.e_t_DPhi_branch.SetAddress(<void*>&self.e_t_DPhi_value)

        #print "making e_t_DR"
        self.e_t_DR_branch = the_tree.GetBranch("e_t_DR")
        #if not self.e_t_DR_branch and "e_t_DR" not in self.complained:
        if not self.e_t_DR_branch and "e_t_DR":
            warnings.warn( "ETauTree: Expected branch e_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_DR")
        else:
            self.e_t_DR_branch.SetAddress(<void*>&self.e_t_DR_value)

        #print "making e_t_Mass"
        self.e_t_Mass_branch = the_tree.GetBranch("e_t_Mass")
        #if not self.e_t_Mass_branch and "e_t_Mass" not in self.complained:
        if not self.e_t_Mass_branch and "e_t_Mass":
            warnings.warn( "ETauTree: Expected branch e_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Mass")
        else:
            self.e_t_Mass_branch.SetAddress(<void*>&self.e_t_Mass_value)

        #print "making e_t_MassFsr"
        self.e_t_MassFsr_branch = the_tree.GetBranch("e_t_MassFsr")
        #if not self.e_t_MassFsr_branch and "e_t_MassFsr" not in self.complained:
        if not self.e_t_MassFsr_branch and "e_t_MassFsr":
            warnings.warn( "ETauTree: Expected branch e_t_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_MassFsr")
        else:
            self.e_t_MassFsr_branch.SetAddress(<void*>&self.e_t_MassFsr_value)

        #print "making e_t_Mass_ees_minus"
        self.e_t_Mass_ees_minus_branch = the_tree.GetBranch("e_t_Mass_ees_minus")
        #if not self.e_t_Mass_ees_minus_branch and "e_t_Mass_ees_minus" not in self.complained:
        if not self.e_t_Mass_ees_minus_branch and "e_t_Mass_ees_minus":
            warnings.warn( "ETauTree: Expected branch e_t_Mass_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Mass_ees_minus")
        else:
            self.e_t_Mass_ees_minus_branch.SetAddress(<void*>&self.e_t_Mass_ees_minus_value)

        #print "making e_t_Mass_ees_plus"
        self.e_t_Mass_ees_plus_branch = the_tree.GetBranch("e_t_Mass_ees_plus")
        #if not self.e_t_Mass_ees_plus_branch and "e_t_Mass_ees_plus" not in self.complained:
        if not self.e_t_Mass_ees_plus_branch and "e_t_Mass_ees_plus":
            warnings.warn( "ETauTree: Expected branch e_t_Mass_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Mass_ees_plus")
        else:
            self.e_t_Mass_ees_plus_branch.SetAddress(<void*>&self.e_t_Mass_ees_plus_value)

        #print "making e_t_Mass_tes_minus"
        self.e_t_Mass_tes_minus_branch = the_tree.GetBranch("e_t_Mass_tes_minus")
        #if not self.e_t_Mass_tes_minus_branch and "e_t_Mass_tes_minus" not in self.complained:
        if not self.e_t_Mass_tes_minus_branch and "e_t_Mass_tes_minus":
            warnings.warn( "ETauTree: Expected branch e_t_Mass_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Mass_tes_minus")
        else:
            self.e_t_Mass_tes_minus_branch.SetAddress(<void*>&self.e_t_Mass_tes_minus_value)

        #print "making e_t_Mass_tes_plus"
        self.e_t_Mass_tes_plus_branch = the_tree.GetBranch("e_t_Mass_tes_plus")
        #if not self.e_t_Mass_tes_plus_branch and "e_t_Mass_tes_plus" not in self.complained:
        if not self.e_t_Mass_tes_plus_branch and "e_t_Mass_tes_plus":
            warnings.warn( "ETauTree: Expected branch e_t_Mass_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Mass_tes_plus")
        else:
            self.e_t_Mass_tes_plus_branch.SetAddress(<void*>&self.e_t_Mass_tes_plus_value)

        #print "making e_t_PZeta"
        self.e_t_PZeta_branch = the_tree.GetBranch("e_t_PZeta")
        #if not self.e_t_PZeta_branch and "e_t_PZeta" not in self.complained:
        if not self.e_t_PZeta_branch and "e_t_PZeta":
            warnings.warn( "ETauTree: Expected branch e_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_PZeta")
        else:
            self.e_t_PZeta_branch.SetAddress(<void*>&self.e_t_PZeta_value)

        #print "making e_t_PZetaVis"
        self.e_t_PZetaVis_branch = the_tree.GetBranch("e_t_PZetaVis")
        #if not self.e_t_PZetaVis_branch and "e_t_PZetaVis" not in self.complained:
        if not self.e_t_PZetaVis_branch and "e_t_PZetaVis":
            warnings.warn( "ETauTree: Expected branch e_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_PZetaVis")
        else:
            self.e_t_PZetaVis_branch.SetAddress(<void*>&self.e_t_PZetaVis_value)

        #print "making e_t_Pt"
        self.e_t_Pt_branch = the_tree.GetBranch("e_t_Pt")
        #if not self.e_t_Pt_branch and "e_t_Pt" not in self.complained:
        if not self.e_t_Pt_branch and "e_t_Pt":
            warnings.warn( "ETauTree: Expected branch e_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Pt")
        else:
            self.e_t_Pt_branch.SetAddress(<void*>&self.e_t_Pt_value)

        #print "making e_t_PtFsr"
        self.e_t_PtFsr_branch = the_tree.GetBranch("e_t_PtFsr")
        #if not self.e_t_PtFsr_branch and "e_t_PtFsr" not in self.complained:
        if not self.e_t_PtFsr_branch and "e_t_PtFsr":
            warnings.warn( "ETauTree: Expected branch e_t_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_PtFsr")
        else:
            self.e_t_PtFsr_branch.SetAddress(<void*>&self.e_t_PtFsr_value)

        #print "making e_t_SS"
        self.e_t_SS_branch = the_tree.GetBranch("e_t_SS")
        #if not self.e_t_SS_branch and "e_t_SS" not in self.complained:
        if not self.e_t_SS_branch and "e_t_SS":
            warnings.warn( "ETauTree: Expected branch e_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_SS")
        else:
            self.e_t_SS_branch.SetAddress(<void*>&self.e_t_SS_value)

        #print "making e_t_ToMETDPhi_Ty1"
        self.e_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e_t_ToMETDPhi_Ty1")
        #if not self.e_t_ToMETDPhi_Ty1_branch and "e_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.e_t_ToMETDPhi_Ty1_branch and "e_t_ToMETDPhi_Ty1":
            warnings.warn( "ETauTree: Expected branch e_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_ToMETDPhi_Ty1")
        else:
            self.e_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e_t_ToMETDPhi_Ty1_value)

        #print "making e_t_ToMETDPhi_jes_minus"
        self.e_t_ToMETDPhi_jes_minus_branch = the_tree.GetBranch("e_t_ToMETDPhi_jes_minus")
        #if not self.e_t_ToMETDPhi_jes_minus_branch and "e_t_ToMETDPhi_jes_minus" not in self.complained:
        if not self.e_t_ToMETDPhi_jes_minus_branch and "e_t_ToMETDPhi_jes_minus":
            warnings.warn( "ETauTree: Expected branch e_t_ToMETDPhi_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_ToMETDPhi_jes_minus")
        else:
            self.e_t_ToMETDPhi_jes_minus_branch.SetAddress(<void*>&self.e_t_ToMETDPhi_jes_minus_value)

        #print "making e_t_ToMETDPhi_jes_plus"
        self.e_t_ToMETDPhi_jes_plus_branch = the_tree.GetBranch("e_t_ToMETDPhi_jes_plus")
        #if not self.e_t_ToMETDPhi_jes_plus_branch and "e_t_ToMETDPhi_jes_plus" not in self.complained:
        if not self.e_t_ToMETDPhi_jes_plus_branch and "e_t_ToMETDPhi_jes_plus":
            warnings.warn( "ETauTree: Expected branch e_t_ToMETDPhi_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_ToMETDPhi_jes_plus")
        else:
            self.e_t_ToMETDPhi_jes_plus_branch.SetAddress(<void*>&self.e_t_ToMETDPhi_jes_plus_value)

        #print "making e_t_Zcompat"
        self.e_t_Zcompat_branch = the_tree.GetBranch("e_t_Zcompat")
        #if not self.e_t_Zcompat_branch and "e_t_Zcompat" not in self.complained:
        if not self.e_t_Zcompat_branch and "e_t_Zcompat":
            warnings.warn( "ETauTree: Expected branch e_t_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Zcompat")
        else:
            self.e_t_Zcompat_branch.SetAddress(<void*>&self.e_t_Zcompat_value)

        #print "making edECorrReg_2012Jul13ReReco"
        self.edECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("edECorrReg_2012Jul13ReReco")
        #if not self.edECorrReg_2012Jul13ReReco_branch and "edECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.edECorrReg_2012Jul13ReReco_branch and "edECorrReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch edECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_2012Jul13ReReco")
        else:
            self.edECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.edECorrReg_2012Jul13ReReco_value)

        #print "making edECorrReg_Fall11"
        self.edECorrReg_Fall11_branch = the_tree.GetBranch("edECorrReg_Fall11")
        #if not self.edECorrReg_Fall11_branch and "edECorrReg_Fall11" not in self.complained:
        if not self.edECorrReg_Fall11_branch and "edECorrReg_Fall11":
            warnings.warn( "ETauTree: Expected branch edECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_Fall11")
        else:
            self.edECorrReg_Fall11_branch.SetAddress(<void*>&self.edECorrReg_Fall11_value)

        #print "making edECorrReg_Jan16ReReco"
        self.edECorrReg_Jan16ReReco_branch = the_tree.GetBranch("edECorrReg_Jan16ReReco")
        #if not self.edECorrReg_Jan16ReReco_branch and "edECorrReg_Jan16ReReco" not in self.complained:
        if not self.edECorrReg_Jan16ReReco_branch and "edECorrReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch edECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_Jan16ReReco")
        else:
            self.edECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.edECorrReg_Jan16ReReco_value)

        #print "making edECorrReg_Summer12_DR53X_HCP2012"
        self.edECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("edECorrReg_Summer12_DR53X_HCP2012")
        #if not self.edECorrReg_Summer12_DR53X_HCP2012_branch and "edECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.edECorrReg_Summer12_DR53X_HCP2012_branch and "edECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch edECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.edECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.edECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making edECorrSmearedNoReg_2012Jul13ReReco"
        self.edECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("edECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.edECorrSmearedNoReg_2012Jul13ReReco_branch and "edECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.edECorrSmearedNoReg_2012Jul13ReReco_branch and "edECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch edECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.edECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making edECorrSmearedNoReg_Fall11"
        self.edECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("edECorrSmearedNoReg_Fall11")
        #if not self.edECorrSmearedNoReg_Fall11_branch and "edECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.edECorrSmearedNoReg_Fall11_branch and "edECorrSmearedNoReg_Fall11":
            warnings.warn( "ETauTree: Expected branch edECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_Fall11")
        else:
            self.edECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_Fall11_value)

        #print "making edECorrSmearedNoReg_Jan16ReReco"
        self.edECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("edECorrSmearedNoReg_Jan16ReReco")
        #if not self.edECorrSmearedNoReg_Jan16ReReco_branch and "edECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.edECorrSmearedNoReg_Jan16ReReco_branch and "edECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch edECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_Jan16ReReco")
        else:
            self.edECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_Jan16ReReco_value)

        #print "making edECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("edECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch edECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making edECorrSmearedReg_2012Jul13ReReco"
        self.edECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("edECorrSmearedReg_2012Jul13ReReco")
        #if not self.edECorrSmearedReg_2012Jul13ReReco_branch and "edECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.edECorrSmearedReg_2012Jul13ReReco_branch and "edECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "ETauTree: Expected branch edECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_2012Jul13ReReco")
        else:
            self.edECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.edECorrSmearedReg_2012Jul13ReReco_value)

        #print "making edECorrSmearedReg_Fall11"
        self.edECorrSmearedReg_Fall11_branch = the_tree.GetBranch("edECorrSmearedReg_Fall11")
        #if not self.edECorrSmearedReg_Fall11_branch and "edECorrSmearedReg_Fall11" not in self.complained:
        if not self.edECorrSmearedReg_Fall11_branch and "edECorrSmearedReg_Fall11":
            warnings.warn( "ETauTree: Expected branch edECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_Fall11")
        else:
            self.edECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.edECorrSmearedReg_Fall11_value)

        #print "making edECorrSmearedReg_Jan16ReReco"
        self.edECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("edECorrSmearedReg_Jan16ReReco")
        #if not self.edECorrSmearedReg_Jan16ReReco_branch and "edECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.edECorrSmearedReg_Jan16ReReco_branch and "edECorrSmearedReg_Jan16ReReco":
            warnings.warn( "ETauTree: Expected branch edECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_Jan16ReReco")
        else:
            self.edECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.edECorrSmearedReg_Jan16ReReco_value)

        #print "making edECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("edECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "ETauTree: Expected branch edECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.edECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making edeltaEtaSuperClusterTrackAtVtx"
        self.edeltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaEtaSuperClusterTrackAtVtx")
        #if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "ETauTree: Expected branch edeltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaEtaSuperClusterTrackAtVtx")
        else:
            self.edeltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaEtaSuperClusterTrackAtVtx_value)

        #print "making edeltaPhiSuperClusterTrackAtVtx"
        self.edeltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaPhiSuperClusterTrackAtVtx")
        #if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "ETauTree: Expected branch edeltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaPhiSuperClusterTrackAtVtx")
        else:
            self.edeltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaPhiSuperClusterTrackAtVtx_value)

        #print "making eeSuperClusterOverP"
        self.eeSuperClusterOverP_branch = the_tree.GetBranch("eeSuperClusterOverP")
        #if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP" not in self.complained:
        if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP":
            warnings.warn( "ETauTree: Expected branch eeSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eeSuperClusterOverP")
        else:
            self.eeSuperClusterOverP_branch.SetAddress(<void*>&self.eeSuperClusterOverP_value)

        #print "making eecalEnergy"
        self.eecalEnergy_branch = the_tree.GetBranch("eecalEnergy")
        #if not self.eecalEnergy_branch and "eecalEnergy" not in self.complained:
        if not self.eecalEnergy_branch and "eecalEnergy":
            warnings.warn( "ETauTree: Expected branch eecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eecalEnergy")
        else:
            self.eecalEnergy_branch.SetAddress(<void*>&self.eecalEnergy_value)

        #print "making efBrem"
        self.efBrem_branch = the_tree.GetBranch("efBrem")
        #if not self.efBrem_branch and "efBrem" not in self.complained:
        if not self.efBrem_branch and "efBrem":
            warnings.warn( "ETauTree: Expected branch efBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("efBrem")
        else:
            self.efBrem_branch.SetAddress(<void*>&self.efBrem_value)

        #print "making etrackMomentumAtVtxP"
        self.etrackMomentumAtVtxP_branch = the_tree.GetBranch("etrackMomentumAtVtxP")
        #if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP" not in self.complained:
        if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP":
            warnings.warn( "ETauTree: Expected branch etrackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("etrackMomentumAtVtxP")
        else:
            self.etrackMomentumAtVtxP_branch.SetAddress(<void*>&self.etrackMomentumAtVtxP_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "ETauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "ETauTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "ETauTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "ETauTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "ETauTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "ETauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isoMu24eta2p1Group"
        self.isoMu24eta2p1Group_branch = the_tree.GetBranch("isoMu24eta2p1Group")
        #if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group" not in self.complained:
        if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group":
            warnings.warn( "ETauTree: Expected branch isoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Group")
        else:
            self.isoMu24eta2p1Group_branch.SetAddress(<void*>&self.isoMu24eta2p1Group_value)

        #print "making isoMu24eta2p1Pass"
        self.isoMu24eta2p1Pass_branch = the_tree.GetBranch("isoMu24eta2p1Pass")
        #if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass" not in self.complained:
        if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass":
            warnings.warn( "ETauTree: Expected branch isoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Pass")
        else:
            self.isoMu24eta2p1Pass_branch.SetAddress(<void*>&self.isoMu24eta2p1Pass_value)

        #print "making isoMu24eta2p1Prescale"
        self.isoMu24eta2p1Prescale_branch = the_tree.GetBranch("isoMu24eta2p1Prescale")
        #if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale" not in self.complained:
        if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale":
            warnings.warn( "ETauTree: Expected branch isoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Prescale")
        else:
            self.isoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.isoMu24eta2p1Prescale_value)

        #print "making isoMuGroup"
        self.isoMuGroup_branch = the_tree.GetBranch("isoMuGroup")
        #if not self.isoMuGroup_branch and "isoMuGroup" not in self.complained:
        if not self.isoMuGroup_branch and "isoMuGroup":
            warnings.warn( "ETauTree: Expected branch isoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuGroup")
        else:
            self.isoMuGroup_branch.SetAddress(<void*>&self.isoMuGroup_value)

        #print "making isoMuPass"
        self.isoMuPass_branch = the_tree.GetBranch("isoMuPass")
        #if not self.isoMuPass_branch and "isoMuPass" not in self.complained:
        if not self.isoMuPass_branch and "isoMuPass":
            warnings.warn( "ETauTree: Expected branch isoMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPass")
        else:
            self.isoMuPass_branch.SetAddress(<void*>&self.isoMuPass_value)

        #print "making isoMuPrescale"
        self.isoMuPrescale_branch = the_tree.GetBranch("isoMuPrescale")
        #if not self.isoMuPrescale_branch and "isoMuPrescale" not in self.complained:
        if not self.isoMuPrescale_branch and "isoMuPrescale":
            warnings.warn( "ETauTree: Expected branch isoMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPrescale")
        else:
            self.isoMuPrescale_branch.SetAddress(<void*>&self.isoMuPrescale_value)

        #print "making isoMuTauGroup"
        self.isoMuTauGroup_branch = the_tree.GetBranch("isoMuTauGroup")
        #if not self.isoMuTauGroup_branch and "isoMuTauGroup" not in self.complained:
        if not self.isoMuTauGroup_branch and "isoMuTauGroup":
            warnings.warn( "ETauTree: Expected branch isoMuTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauGroup")
        else:
            self.isoMuTauGroup_branch.SetAddress(<void*>&self.isoMuTauGroup_value)

        #print "making isoMuTauPass"
        self.isoMuTauPass_branch = the_tree.GetBranch("isoMuTauPass")
        #if not self.isoMuTauPass_branch and "isoMuTauPass" not in self.complained:
        if not self.isoMuTauPass_branch and "isoMuTauPass":
            warnings.warn( "ETauTree: Expected branch isoMuTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPass")
        else:
            self.isoMuTauPass_branch.SetAddress(<void*>&self.isoMuTauPass_value)

        #print "making isoMuTauPrescale"
        self.isoMuTauPrescale_branch = the_tree.GetBranch("isoMuTauPrescale")
        #if not self.isoMuTauPrescale_branch and "isoMuTauPrescale" not in self.complained:
        if not self.isoMuTauPrescale_branch and "isoMuTauPrescale":
            warnings.warn( "ETauTree: Expected branch isoMuTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPrescale")
        else:
            self.isoMuTauPrescale_branch.SetAddress(<void*>&self.isoMuTauPrescale_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "ETauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_DR05"
        self.jetVeto20_DR05_branch = the_tree.GetBranch("jetVeto20_DR05")
        #if not self.jetVeto20_DR05_branch and "jetVeto20_DR05" not in self.complained:
        if not self.jetVeto20_DR05_branch and "jetVeto20_DR05":
            warnings.warn( "ETauTree: Expected branch jetVeto20_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_DR05")
        else:
            self.jetVeto20_DR05_branch.SetAddress(<void*>&self.jetVeto20_DR05_value)

        #print "making jetVeto20jes_minus"
        self.jetVeto20jes_minus_branch = the_tree.GetBranch("jetVeto20jes_minus")
        #if not self.jetVeto20jes_minus_branch and "jetVeto20jes_minus" not in self.complained:
        if not self.jetVeto20jes_minus_branch and "jetVeto20jes_minus":
            warnings.warn( "ETauTree: Expected branch jetVeto20jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20jes_minus")
        else:
            self.jetVeto20jes_minus_branch.SetAddress(<void*>&self.jetVeto20jes_minus_value)

        #print "making jetVeto20jes_plus"
        self.jetVeto20jes_plus_branch = the_tree.GetBranch("jetVeto20jes_plus")
        #if not self.jetVeto20jes_plus_branch and "jetVeto20jes_plus" not in self.complained:
        if not self.jetVeto20jes_plus_branch and "jetVeto20jes_plus":
            warnings.warn( "ETauTree: Expected branch jetVeto20jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20jes_plus")
        else:
            self.jetVeto20jes_plus_branch.SetAddress(<void*>&self.jetVeto20jes_plus_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "ETauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_DR05"
        self.jetVeto30_DR05_branch = the_tree.GetBranch("jetVeto30_DR05")
        #if not self.jetVeto30_DR05_branch and "jetVeto30_DR05" not in self.complained:
        if not self.jetVeto30_DR05_branch and "jetVeto30_DR05":
            warnings.warn( "ETauTree: Expected branch jetVeto30_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_DR05")
        else:
            self.jetVeto30_DR05_branch.SetAddress(<void*>&self.jetVeto30_DR05_value)

        #print "making jetVeto30jes_minus"
        self.jetVeto30jes_minus_branch = the_tree.GetBranch("jetVeto30jes_minus")
        #if not self.jetVeto30jes_minus_branch and "jetVeto30jes_minus" not in self.complained:
        if not self.jetVeto30jes_minus_branch and "jetVeto30jes_minus":
            warnings.warn( "ETauTree: Expected branch jetVeto30jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30jes_minus")
        else:
            self.jetVeto30jes_minus_branch.SetAddress(<void*>&self.jetVeto30jes_minus_value)

        #print "making jetVeto30jes_plus"
        self.jetVeto30jes_plus_branch = the_tree.GetBranch("jetVeto30jes_plus")
        #if not self.jetVeto30jes_plus_branch and "jetVeto30jes_plus" not in self.complained:
        if not self.jetVeto30jes_plus_branch and "jetVeto30jes_plus":
            warnings.warn( "ETauTree: Expected branch jetVeto30jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30jes_plus")
        else:
            self.jetVeto30jes_plus_branch.SetAddress(<void*>&self.jetVeto30jes_plus_value)

        #print "making jetVeto40"
        self.jetVeto40_branch = the_tree.GetBranch("jetVeto40")
        #if not self.jetVeto40_branch and "jetVeto40" not in self.complained:
        if not self.jetVeto40_branch and "jetVeto40":
            warnings.warn( "ETauTree: Expected branch jetVeto40 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40")
        else:
            self.jetVeto40_branch.SetAddress(<void*>&self.jetVeto40_value)

        #print "making jetVeto40_DR05"
        self.jetVeto40_DR05_branch = the_tree.GetBranch("jetVeto40_DR05")
        #if not self.jetVeto40_DR05_branch and "jetVeto40_DR05" not in self.complained:
        if not self.jetVeto40_DR05_branch and "jetVeto40_DR05":
            warnings.warn( "ETauTree: Expected branch jetVeto40_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40_DR05")
        else:
            self.jetVeto40_DR05_branch.SetAddress(<void*>&self.jetVeto40_DR05_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "ETauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making mu17ele8Group"
        self.mu17ele8Group_branch = the_tree.GetBranch("mu17ele8Group")
        #if not self.mu17ele8Group_branch and "mu17ele8Group" not in self.complained:
        if not self.mu17ele8Group_branch and "mu17ele8Group":
            warnings.warn( "ETauTree: Expected branch mu17ele8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Group")
        else:
            self.mu17ele8Group_branch.SetAddress(<void*>&self.mu17ele8Group_value)

        #print "making mu17ele8Pass"
        self.mu17ele8Pass_branch = the_tree.GetBranch("mu17ele8Pass")
        #if not self.mu17ele8Pass_branch and "mu17ele8Pass" not in self.complained:
        if not self.mu17ele8Pass_branch and "mu17ele8Pass":
            warnings.warn( "ETauTree: Expected branch mu17ele8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Pass")
        else:
            self.mu17ele8Pass_branch.SetAddress(<void*>&self.mu17ele8Pass_value)

        #print "making mu17ele8Prescale"
        self.mu17ele8Prescale_branch = the_tree.GetBranch("mu17ele8Prescale")
        #if not self.mu17ele8Prescale_branch and "mu17ele8Prescale" not in self.complained:
        if not self.mu17ele8Prescale_branch and "mu17ele8Prescale":
            warnings.warn( "ETauTree: Expected branch mu17ele8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Prescale")
        else:
            self.mu17ele8Prescale_branch.SetAddress(<void*>&self.mu17ele8Prescale_value)

        #print "making mu17ele8isoGroup"
        self.mu17ele8isoGroup_branch = the_tree.GetBranch("mu17ele8isoGroup")
        #if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup" not in self.complained:
        if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup":
            warnings.warn( "ETauTree: Expected branch mu17ele8isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoGroup")
        else:
            self.mu17ele8isoGroup_branch.SetAddress(<void*>&self.mu17ele8isoGroup_value)

        #print "making mu17ele8isoPass"
        self.mu17ele8isoPass_branch = the_tree.GetBranch("mu17ele8isoPass")
        #if not self.mu17ele8isoPass_branch and "mu17ele8isoPass" not in self.complained:
        if not self.mu17ele8isoPass_branch and "mu17ele8isoPass":
            warnings.warn( "ETauTree: Expected branch mu17ele8isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPass")
        else:
            self.mu17ele8isoPass_branch.SetAddress(<void*>&self.mu17ele8isoPass_value)

        #print "making mu17ele8isoPrescale"
        self.mu17ele8isoPrescale_branch = the_tree.GetBranch("mu17ele8isoPrescale")
        #if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale" not in self.complained:
        if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale":
            warnings.warn( "ETauTree: Expected branch mu17ele8isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPrescale")
        else:
            self.mu17ele8isoPrescale_branch.SetAddress(<void*>&self.mu17ele8isoPrescale_value)

        #print "making mu17mu8Group"
        self.mu17mu8Group_branch = the_tree.GetBranch("mu17mu8Group")
        #if not self.mu17mu8Group_branch and "mu17mu8Group" not in self.complained:
        if not self.mu17mu8Group_branch and "mu17mu8Group":
            warnings.warn( "ETauTree: Expected branch mu17mu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Group")
        else:
            self.mu17mu8Group_branch.SetAddress(<void*>&self.mu17mu8Group_value)

        #print "making mu17mu8Pass"
        self.mu17mu8Pass_branch = the_tree.GetBranch("mu17mu8Pass")
        #if not self.mu17mu8Pass_branch and "mu17mu8Pass" not in self.complained:
        if not self.mu17mu8Pass_branch and "mu17mu8Pass":
            warnings.warn( "ETauTree: Expected branch mu17mu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Pass")
        else:
            self.mu17mu8Pass_branch.SetAddress(<void*>&self.mu17mu8Pass_value)

        #print "making mu17mu8Prescale"
        self.mu17mu8Prescale_branch = the_tree.GetBranch("mu17mu8Prescale")
        #if not self.mu17mu8Prescale_branch and "mu17mu8Prescale" not in self.complained:
        if not self.mu17mu8Prescale_branch and "mu17mu8Prescale":
            warnings.warn( "ETauTree: Expected branch mu17mu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Prescale")
        else:
            self.mu17mu8Prescale_branch.SetAddress(<void*>&self.mu17mu8Prescale_value)

        #print "making mu8ele17Group"
        self.mu8ele17Group_branch = the_tree.GetBranch("mu8ele17Group")
        #if not self.mu8ele17Group_branch and "mu8ele17Group" not in self.complained:
        if not self.mu8ele17Group_branch and "mu8ele17Group":
            warnings.warn( "ETauTree: Expected branch mu8ele17Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Group")
        else:
            self.mu8ele17Group_branch.SetAddress(<void*>&self.mu8ele17Group_value)

        #print "making mu8ele17Pass"
        self.mu8ele17Pass_branch = the_tree.GetBranch("mu8ele17Pass")
        #if not self.mu8ele17Pass_branch and "mu8ele17Pass" not in self.complained:
        if not self.mu8ele17Pass_branch and "mu8ele17Pass":
            warnings.warn( "ETauTree: Expected branch mu8ele17Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Pass")
        else:
            self.mu8ele17Pass_branch.SetAddress(<void*>&self.mu8ele17Pass_value)

        #print "making mu8ele17Prescale"
        self.mu8ele17Prescale_branch = the_tree.GetBranch("mu8ele17Prescale")
        #if not self.mu8ele17Prescale_branch and "mu8ele17Prescale" not in self.complained:
        if not self.mu8ele17Prescale_branch and "mu8ele17Prescale":
            warnings.warn( "ETauTree: Expected branch mu8ele17Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Prescale")
        else:
            self.mu8ele17Prescale_branch.SetAddress(<void*>&self.mu8ele17Prescale_value)

        #print "making mu8ele17isoGroup"
        self.mu8ele17isoGroup_branch = the_tree.GetBranch("mu8ele17isoGroup")
        #if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup" not in self.complained:
        if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup":
            warnings.warn( "ETauTree: Expected branch mu8ele17isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoGroup")
        else:
            self.mu8ele17isoGroup_branch.SetAddress(<void*>&self.mu8ele17isoGroup_value)

        #print "making mu8ele17isoPass"
        self.mu8ele17isoPass_branch = the_tree.GetBranch("mu8ele17isoPass")
        #if not self.mu8ele17isoPass_branch and "mu8ele17isoPass" not in self.complained:
        if not self.mu8ele17isoPass_branch and "mu8ele17isoPass":
            warnings.warn( "ETauTree: Expected branch mu8ele17isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPass")
        else:
            self.mu8ele17isoPass_branch.SetAddress(<void*>&self.mu8ele17isoPass_value)

        #print "making mu8ele17isoPrescale"
        self.mu8ele17isoPrescale_branch = the_tree.GetBranch("mu8ele17isoPrescale")
        #if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale" not in self.complained:
        if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale":
            warnings.warn( "ETauTree: Expected branch mu8ele17isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPrescale")
        else:
            self.mu8ele17isoPrescale_branch.SetAddress(<void*>&self.mu8ele17isoPrescale_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "ETauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muTauGroup"
        self.muTauGroup_branch = the_tree.GetBranch("muTauGroup")
        #if not self.muTauGroup_branch and "muTauGroup" not in self.complained:
        if not self.muTauGroup_branch and "muTauGroup":
            warnings.warn( "ETauTree: Expected branch muTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauGroup")
        else:
            self.muTauGroup_branch.SetAddress(<void*>&self.muTauGroup_value)

        #print "making muTauPass"
        self.muTauPass_branch = the_tree.GetBranch("muTauPass")
        #if not self.muTauPass_branch and "muTauPass" not in self.complained:
        if not self.muTauPass_branch and "muTauPass":
            warnings.warn( "ETauTree: Expected branch muTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPass")
        else:
            self.muTauPass_branch.SetAddress(<void*>&self.muTauPass_value)

        #print "making muTauPrescale"
        self.muTauPrescale_branch = the_tree.GetBranch("muTauPrescale")
        #if not self.muTauPrescale_branch and "muTauPrescale" not in self.complained:
        if not self.muTauPrescale_branch and "muTauPrescale":
            warnings.warn( "ETauTree: Expected branch muTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPrescale")
        else:
            self.muTauPrescale_branch.SetAddress(<void*>&self.muTauPrescale_value)

        #print "making muTauTestGroup"
        self.muTauTestGroup_branch = the_tree.GetBranch("muTauTestGroup")
        #if not self.muTauTestGroup_branch and "muTauTestGroup" not in self.complained:
        if not self.muTauTestGroup_branch and "muTauTestGroup":
            warnings.warn( "ETauTree: Expected branch muTauTestGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestGroup")
        else:
            self.muTauTestGroup_branch.SetAddress(<void*>&self.muTauTestGroup_value)

        #print "making muTauTestPass"
        self.muTauTestPass_branch = the_tree.GetBranch("muTauTestPass")
        #if not self.muTauTestPass_branch and "muTauTestPass" not in self.complained:
        if not self.muTauTestPass_branch and "muTauTestPass":
            warnings.warn( "ETauTree: Expected branch muTauTestPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPass")
        else:
            self.muTauTestPass_branch.SetAddress(<void*>&self.muTauTestPass_value)

        #print "making muTauTestPrescale"
        self.muTauTestPrescale_branch = the_tree.GetBranch("muTauTestPrescale")
        #if not self.muTauTestPrescale_branch and "muTauTestPrescale" not in self.complained:
        if not self.muTauTestPrescale_branch and "muTauTestPrescale":
            warnings.warn( "ETauTree: Expected branch muTauTestPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPrescale")
        else:
            self.muTauTestPrescale_branch.SetAddress(<void*>&self.muTauTestPrescale_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "ETauTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "ETauTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "ETauTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making muVetoPt5IsoIdVtx_mes_minus"
        self.muVetoPt5IsoIdVtx_mes_minus_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx_mes_minus")
        #if not self.muVetoPt5IsoIdVtx_mes_minus_branch and "muVetoPt5IsoIdVtx_mes_minus" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_mes_minus_branch and "muVetoPt5IsoIdVtx_mes_minus":
            warnings.warn( "ETauTree: Expected branch muVetoPt5IsoIdVtx_mes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx_mes_minus")
        else:
            self.muVetoPt5IsoIdVtx_mes_minus_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_mes_minus_value)

        #print "making muVetoPt5IsoIdVtx_mes_plus"
        self.muVetoPt5IsoIdVtx_mes_plus_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx_mes_plus")
        #if not self.muVetoPt5IsoIdVtx_mes_plus_branch and "muVetoPt5IsoIdVtx_mes_plus" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_mes_plus_branch and "muVetoPt5IsoIdVtx_mes_plus":
            warnings.warn( "ETauTree: Expected branch muVetoPt5IsoIdVtx_mes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx_mes_plus")
        else:
            self.muVetoPt5IsoIdVtx_mes_plus_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_mes_plus_value)

        #print "making mva_met_Et"
        self.mva_met_Et_branch = the_tree.GetBranch("mva_met_Et")
        #if not self.mva_met_Et_branch and "mva_met_Et" not in self.complained:
        if not self.mva_met_Et_branch and "mva_met_Et":
            warnings.warn( "ETauTree: Expected branch mva_met_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_met_Et")
        else:
            self.mva_met_Et_branch.SetAddress(<void*>&self.mva_met_Et_value)

        #print "making mva_met_Phi"
        self.mva_met_Phi_branch = the_tree.GetBranch("mva_met_Phi")
        #if not self.mva_met_Phi_branch and "mva_met_Phi" not in self.complained:
        if not self.mva_met_Phi_branch and "mva_met_Phi":
            warnings.warn( "ETauTree: Expected branch mva_met_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_met_Phi")
        else:
            self.mva_met_Phi_branch.SetAddress(<void*>&self.mva_met_Phi_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "ETauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "ETauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making pfMet_Et"
        self.pfMet_Et_branch = the_tree.GetBranch("pfMet_Et")
        #if not self.pfMet_Et_branch and "pfMet_Et" not in self.complained:
        if not self.pfMet_Et_branch and "pfMet_Et":
            warnings.warn( "ETauTree: Expected branch pfMet_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et")
        else:
            self.pfMet_Et_branch.SetAddress(<void*>&self.pfMet_Et_value)

        #print "making pfMet_Et_ees_minus"
        self.pfMet_Et_ees_minus_branch = the_tree.GetBranch("pfMet_Et_ees_minus")
        #if not self.pfMet_Et_ees_minus_branch and "pfMet_Et_ees_minus" not in self.complained:
        if not self.pfMet_Et_ees_minus_branch and "pfMet_Et_ees_minus":
            warnings.warn( "ETauTree: Expected branch pfMet_Et_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_ees_minus")
        else:
            self.pfMet_Et_ees_minus_branch.SetAddress(<void*>&self.pfMet_Et_ees_minus_value)

        #print "making pfMet_Et_ees_plus"
        self.pfMet_Et_ees_plus_branch = the_tree.GetBranch("pfMet_Et_ees_plus")
        #if not self.pfMet_Et_ees_plus_branch and "pfMet_Et_ees_plus" not in self.complained:
        if not self.pfMet_Et_ees_plus_branch and "pfMet_Et_ees_plus":
            warnings.warn( "ETauTree: Expected branch pfMet_Et_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_ees_plus")
        else:
            self.pfMet_Et_ees_plus_branch.SetAddress(<void*>&self.pfMet_Et_ees_plus_value)

        #print "making pfMet_Et_jes_minus"
        self.pfMet_Et_jes_minus_branch = the_tree.GetBranch("pfMet_Et_jes_minus")
        #if not self.pfMet_Et_jes_minus_branch and "pfMet_Et_jes_minus" not in self.complained:
        if not self.pfMet_Et_jes_minus_branch and "pfMet_Et_jes_minus":
            warnings.warn( "ETauTree: Expected branch pfMet_Et_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_jes_minus")
        else:
            self.pfMet_Et_jes_minus_branch.SetAddress(<void*>&self.pfMet_Et_jes_minus_value)

        #print "making pfMet_Et_jes_plus"
        self.pfMet_Et_jes_plus_branch = the_tree.GetBranch("pfMet_Et_jes_plus")
        #if not self.pfMet_Et_jes_plus_branch and "pfMet_Et_jes_plus" not in self.complained:
        if not self.pfMet_Et_jes_plus_branch and "pfMet_Et_jes_plus":
            warnings.warn( "ETauTree: Expected branch pfMet_Et_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_jes_plus")
        else:
            self.pfMet_Et_jes_plus_branch.SetAddress(<void*>&self.pfMet_Et_jes_plus_value)

        #print "making pfMet_Et_mes_minus"
        self.pfMet_Et_mes_minus_branch = the_tree.GetBranch("pfMet_Et_mes_minus")
        #if not self.pfMet_Et_mes_minus_branch and "pfMet_Et_mes_minus" not in self.complained:
        if not self.pfMet_Et_mes_minus_branch and "pfMet_Et_mes_minus":
            warnings.warn( "ETauTree: Expected branch pfMet_Et_mes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_mes_minus")
        else:
            self.pfMet_Et_mes_minus_branch.SetAddress(<void*>&self.pfMet_Et_mes_minus_value)

        #print "making pfMet_Et_mes_plus"
        self.pfMet_Et_mes_plus_branch = the_tree.GetBranch("pfMet_Et_mes_plus")
        #if not self.pfMet_Et_mes_plus_branch and "pfMet_Et_mes_plus" not in self.complained:
        if not self.pfMet_Et_mes_plus_branch and "pfMet_Et_mes_plus":
            warnings.warn( "ETauTree: Expected branch pfMet_Et_mes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_mes_plus")
        else:
            self.pfMet_Et_mes_plus_branch.SetAddress(<void*>&self.pfMet_Et_mes_plus_value)

        #print "making pfMet_Et_tes_minus"
        self.pfMet_Et_tes_minus_branch = the_tree.GetBranch("pfMet_Et_tes_minus")
        #if not self.pfMet_Et_tes_minus_branch and "pfMet_Et_tes_minus" not in self.complained:
        if not self.pfMet_Et_tes_minus_branch and "pfMet_Et_tes_minus":
            warnings.warn( "ETauTree: Expected branch pfMet_Et_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_tes_minus")
        else:
            self.pfMet_Et_tes_minus_branch.SetAddress(<void*>&self.pfMet_Et_tes_minus_value)

        #print "making pfMet_Et_tes_plus"
        self.pfMet_Et_tes_plus_branch = the_tree.GetBranch("pfMet_Et_tes_plus")
        #if not self.pfMet_Et_tes_plus_branch and "pfMet_Et_tes_plus" not in self.complained:
        if not self.pfMet_Et_tes_plus_branch and "pfMet_Et_tes_plus":
            warnings.warn( "ETauTree: Expected branch pfMet_Et_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_tes_plus")
        else:
            self.pfMet_Et_tes_plus_branch.SetAddress(<void*>&self.pfMet_Et_tes_plus_value)

        #print "making pfMet_Et_ues_minus"
        self.pfMet_Et_ues_minus_branch = the_tree.GetBranch("pfMet_Et_ues_minus")
        #if not self.pfMet_Et_ues_minus_branch and "pfMet_Et_ues_minus" not in self.complained:
        if not self.pfMet_Et_ues_minus_branch and "pfMet_Et_ues_minus":
            warnings.warn( "ETauTree: Expected branch pfMet_Et_ues_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_ues_minus")
        else:
            self.pfMet_Et_ues_minus_branch.SetAddress(<void*>&self.pfMet_Et_ues_minus_value)

        #print "making pfMet_Et_ues_plus"
        self.pfMet_Et_ues_plus_branch = the_tree.GetBranch("pfMet_Et_ues_plus")
        #if not self.pfMet_Et_ues_plus_branch and "pfMet_Et_ues_plus" not in self.complained:
        if not self.pfMet_Et_ues_plus_branch and "pfMet_Et_ues_plus":
            warnings.warn( "ETauTree: Expected branch pfMet_Et_ues_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Et_ues_plus")
        else:
            self.pfMet_Et_ues_plus_branch.SetAddress(<void*>&self.pfMet_Et_ues_plus_value)

        #print "making pfMet_Phi"
        self.pfMet_Phi_branch = the_tree.GetBranch("pfMet_Phi")
        #if not self.pfMet_Phi_branch and "pfMet_Phi" not in self.complained:
        if not self.pfMet_Phi_branch and "pfMet_Phi":
            warnings.warn( "ETauTree: Expected branch pfMet_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi")
        else:
            self.pfMet_Phi_branch.SetAddress(<void*>&self.pfMet_Phi_value)

        #print "making pfMet_Phi_ees_minus"
        self.pfMet_Phi_ees_minus_branch = the_tree.GetBranch("pfMet_Phi_ees_minus")
        #if not self.pfMet_Phi_ees_minus_branch and "pfMet_Phi_ees_minus" not in self.complained:
        if not self.pfMet_Phi_ees_minus_branch and "pfMet_Phi_ees_minus":
            warnings.warn( "ETauTree: Expected branch pfMet_Phi_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_ees_minus")
        else:
            self.pfMet_Phi_ees_minus_branch.SetAddress(<void*>&self.pfMet_Phi_ees_minus_value)

        #print "making pfMet_Phi_ees_plus"
        self.pfMet_Phi_ees_plus_branch = the_tree.GetBranch("pfMet_Phi_ees_plus")
        #if not self.pfMet_Phi_ees_plus_branch and "pfMet_Phi_ees_plus" not in self.complained:
        if not self.pfMet_Phi_ees_plus_branch and "pfMet_Phi_ees_plus":
            warnings.warn( "ETauTree: Expected branch pfMet_Phi_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_ees_plus")
        else:
            self.pfMet_Phi_ees_plus_branch.SetAddress(<void*>&self.pfMet_Phi_ees_plus_value)

        #print "making pfMet_Phi_jes_minus"
        self.pfMet_Phi_jes_minus_branch = the_tree.GetBranch("pfMet_Phi_jes_minus")
        #if not self.pfMet_Phi_jes_minus_branch and "pfMet_Phi_jes_minus" not in self.complained:
        if not self.pfMet_Phi_jes_minus_branch and "pfMet_Phi_jes_minus":
            warnings.warn( "ETauTree: Expected branch pfMet_Phi_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_jes_minus")
        else:
            self.pfMet_Phi_jes_minus_branch.SetAddress(<void*>&self.pfMet_Phi_jes_minus_value)

        #print "making pfMet_Phi_jes_plus"
        self.pfMet_Phi_jes_plus_branch = the_tree.GetBranch("pfMet_Phi_jes_plus")
        #if not self.pfMet_Phi_jes_plus_branch and "pfMet_Phi_jes_plus" not in self.complained:
        if not self.pfMet_Phi_jes_plus_branch and "pfMet_Phi_jes_plus":
            warnings.warn( "ETauTree: Expected branch pfMet_Phi_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_jes_plus")
        else:
            self.pfMet_Phi_jes_plus_branch.SetAddress(<void*>&self.pfMet_Phi_jes_plus_value)

        #print "making pfMet_Phi_mes_minus"
        self.pfMet_Phi_mes_minus_branch = the_tree.GetBranch("pfMet_Phi_mes_minus")
        #if not self.pfMet_Phi_mes_minus_branch and "pfMet_Phi_mes_minus" not in self.complained:
        if not self.pfMet_Phi_mes_minus_branch and "pfMet_Phi_mes_minus":
            warnings.warn( "ETauTree: Expected branch pfMet_Phi_mes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_mes_minus")
        else:
            self.pfMet_Phi_mes_minus_branch.SetAddress(<void*>&self.pfMet_Phi_mes_minus_value)

        #print "making pfMet_Phi_mes_plus"
        self.pfMet_Phi_mes_plus_branch = the_tree.GetBranch("pfMet_Phi_mes_plus")
        #if not self.pfMet_Phi_mes_plus_branch and "pfMet_Phi_mes_plus" not in self.complained:
        if not self.pfMet_Phi_mes_plus_branch and "pfMet_Phi_mes_plus":
            warnings.warn( "ETauTree: Expected branch pfMet_Phi_mes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_mes_plus")
        else:
            self.pfMet_Phi_mes_plus_branch.SetAddress(<void*>&self.pfMet_Phi_mes_plus_value)

        #print "making pfMet_Phi_tes_minus"
        self.pfMet_Phi_tes_minus_branch = the_tree.GetBranch("pfMet_Phi_tes_minus")
        #if not self.pfMet_Phi_tes_minus_branch and "pfMet_Phi_tes_minus" not in self.complained:
        if not self.pfMet_Phi_tes_minus_branch and "pfMet_Phi_tes_minus":
            warnings.warn( "ETauTree: Expected branch pfMet_Phi_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_tes_minus")
        else:
            self.pfMet_Phi_tes_minus_branch.SetAddress(<void*>&self.pfMet_Phi_tes_minus_value)

        #print "making pfMet_Phi_tes_plus"
        self.pfMet_Phi_tes_plus_branch = the_tree.GetBranch("pfMet_Phi_tes_plus")
        #if not self.pfMet_Phi_tes_plus_branch and "pfMet_Phi_tes_plus" not in self.complained:
        if not self.pfMet_Phi_tes_plus_branch and "pfMet_Phi_tes_plus":
            warnings.warn( "ETauTree: Expected branch pfMet_Phi_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_tes_plus")
        else:
            self.pfMet_Phi_tes_plus_branch.SetAddress(<void*>&self.pfMet_Phi_tes_plus_value)

        #print "making pfMet_Phi_ues_minus"
        self.pfMet_Phi_ues_minus_branch = the_tree.GetBranch("pfMet_Phi_ues_minus")
        #if not self.pfMet_Phi_ues_minus_branch and "pfMet_Phi_ues_minus" not in self.complained:
        if not self.pfMet_Phi_ues_minus_branch and "pfMet_Phi_ues_minus":
            warnings.warn( "ETauTree: Expected branch pfMet_Phi_ues_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_ues_minus")
        else:
            self.pfMet_Phi_ues_minus_branch.SetAddress(<void*>&self.pfMet_Phi_ues_minus_value)

        #print "making pfMet_Phi_ues_plus"
        self.pfMet_Phi_ues_plus_branch = the_tree.GetBranch("pfMet_Phi_ues_plus")
        #if not self.pfMet_Phi_ues_plus_branch and "pfMet_Phi_ues_plus" not in self.complained:
        if not self.pfMet_Phi_ues_plus_branch and "pfMet_Phi_ues_plus":
            warnings.warn( "ETauTree: Expected branch pfMet_Phi_ues_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_Phi_ues_plus")
        else:
            self.pfMet_Phi_ues_plus_branch.SetAddress(<void*>&self.pfMet_Phi_ues_plus_value)

        #print "making pfMet_diff_Et"
        self.pfMet_diff_Et_branch = the_tree.GetBranch("pfMet_diff_Et")
        #if not self.pfMet_diff_Et_branch and "pfMet_diff_Et" not in self.complained:
        if not self.pfMet_diff_Et_branch and "pfMet_diff_Et":
            warnings.warn( "ETauTree: Expected branch pfMet_diff_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_diff_Et")
        else:
            self.pfMet_diff_Et_branch.SetAddress(<void*>&self.pfMet_diff_Et_value)

        #print "making pfMet_jes_Et"
        self.pfMet_jes_Et_branch = the_tree.GetBranch("pfMet_jes_Et")
        #if not self.pfMet_jes_Et_branch and "pfMet_jes_Et" not in self.complained:
        if not self.pfMet_jes_Et_branch and "pfMet_jes_Et":
            warnings.warn( "ETauTree: Expected branch pfMet_jes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Et")
        else:
            self.pfMet_jes_Et_branch.SetAddress(<void*>&self.pfMet_jes_Et_value)

        #print "making pfMet_jes_Phi"
        self.pfMet_jes_Phi_branch = the_tree.GetBranch("pfMet_jes_Phi")
        #if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi" not in self.complained:
        if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi":
            warnings.warn( "ETauTree: Expected branch pfMet_jes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Phi")
        else:
            self.pfMet_jes_Phi_branch.SetAddress(<void*>&self.pfMet_jes_Phi_value)

        #print "making pfMet_ues_AtanToPhi"
        self.pfMet_ues_AtanToPhi_branch = the_tree.GetBranch("pfMet_ues_AtanToPhi")
        #if not self.pfMet_ues_AtanToPhi_branch and "pfMet_ues_AtanToPhi" not in self.complained:
        if not self.pfMet_ues_AtanToPhi_branch and "pfMet_ues_AtanToPhi":
            warnings.warn( "ETauTree: Expected branch pfMet_ues_AtanToPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_AtanToPhi")
        else:
            self.pfMet_ues_AtanToPhi_branch.SetAddress(<void*>&self.pfMet_ues_AtanToPhi_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "ETauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "ETauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "ETauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "ETauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "ETauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "ETauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "ETauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "ETauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "ETauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "ETauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "ETauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "ETauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "ETauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "ETauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "ETauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "ETauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE27WP80Group"
        self.singleE27WP80Group_branch = the_tree.GetBranch("singleE27WP80Group")
        #if not self.singleE27WP80Group_branch and "singleE27WP80Group" not in self.complained:
        if not self.singleE27WP80Group_branch and "singleE27WP80Group":
            warnings.warn( "ETauTree: Expected branch singleE27WP80Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27WP80Group")
        else:
            self.singleE27WP80Group_branch.SetAddress(<void*>&self.singleE27WP80Group_value)

        #print "making singleE27WP80Pass"
        self.singleE27WP80Pass_branch = the_tree.GetBranch("singleE27WP80Pass")
        #if not self.singleE27WP80Pass_branch and "singleE27WP80Pass" not in self.complained:
        if not self.singleE27WP80Pass_branch and "singleE27WP80Pass":
            warnings.warn( "ETauTree: Expected branch singleE27WP80Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27WP80Pass")
        else:
            self.singleE27WP80Pass_branch.SetAddress(<void*>&self.singleE27WP80Pass_value)

        #print "making singleE27WP80Prescale"
        self.singleE27WP80Prescale_branch = the_tree.GetBranch("singleE27WP80Prescale")
        #if not self.singleE27WP80Prescale_branch and "singleE27WP80Prescale" not in self.complained:
        if not self.singleE27WP80Prescale_branch and "singleE27WP80Prescale":
            warnings.warn( "ETauTree: Expected branch singleE27WP80Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27WP80Prescale")
        else:
            self.singleE27WP80Prescale_branch.SetAddress(<void*>&self.singleE27WP80Prescale_value)

        #print "making singleEGroup"
        self.singleEGroup_branch = the_tree.GetBranch("singleEGroup")
        #if not self.singleEGroup_branch and "singleEGroup" not in self.complained:
        if not self.singleEGroup_branch and "singleEGroup":
            warnings.warn( "ETauTree: Expected branch singleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEGroup")
        else:
            self.singleEGroup_branch.SetAddress(<void*>&self.singleEGroup_value)

        #print "making singleEPFMTGroup"
        self.singleEPFMTGroup_branch = the_tree.GetBranch("singleEPFMTGroup")
        #if not self.singleEPFMTGroup_branch and "singleEPFMTGroup" not in self.complained:
        if not self.singleEPFMTGroup_branch and "singleEPFMTGroup":
            warnings.warn( "ETauTree: Expected branch singleEPFMTGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTGroup")
        else:
            self.singleEPFMTGroup_branch.SetAddress(<void*>&self.singleEPFMTGroup_value)

        #print "making singleEPFMTPass"
        self.singleEPFMTPass_branch = the_tree.GetBranch("singleEPFMTPass")
        #if not self.singleEPFMTPass_branch and "singleEPFMTPass" not in self.complained:
        if not self.singleEPFMTPass_branch and "singleEPFMTPass":
            warnings.warn( "ETauTree: Expected branch singleEPFMTPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPass")
        else:
            self.singleEPFMTPass_branch.SetAddress(<void*>&self.singleEPFMTPass_value)

        #print "making singleEPFMTPrescale"
        self.singleEPFMTPrescale_branch = the_tree.GetBranch("singleEPFMTPrescale")
        #if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale" not in self.complained:
        if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale":
            warnings.warn( "ETauTree: Expected branch singleEPFMTPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPrescale")
        else:
            self.singleEPFMTPrescale_branch.SetAddress(<void*>&self.singleEPFMTPrescale_value)

        #print "making singleEPass"
        self.singleEPass_branch = the_tree.GetBranch("singleEPass")
        #if not self.singleEPass_branch and "singleEPass" not in self.complained:
        if not self.singleEPass_branch and "singleEPass":
            warnings.warn( "ETauTree: Expected branch singleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPass")
        else:
            self.singleEPass_branch.SetAddress(<void*>&self.singleEPass_value)

        #print "making singleEPrescale"
        self.singleEPrescale_branch = the_tree.GetBranch("singleEPrescale")
        #if not self.singleEPrescale_branch and "singleEPrescale" not in self.complained:
        if not self.singleEPrescale_branch and "singleEPrescale":
            warnings.warn( "ETauTree: Expected branch singleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPrescale")
        else:
            self.singleEPrescale_branch.SetAddress(<void*>&self.singleEPrescale_value)

        #print "making singleMuGroup"
        self.singleMuGroup_branch = the_tree.GetBranch("singleMuGroup")
        #if not self.singleMuGroup_branch and "singleMuGroup" not in self.complained:
        if not self.singleMuGroup_branch and "singleMuGroup":
            warnings.warn( "ETauTree: Expected branch singleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuGroup")
        else:
            self.singleMuGroup_branch.SetAddress(<void*>&self.singleMuGroup_value)

        #print "making singleMuPass"
        self.singleMuPass_branch = the_tree.GetBranch("singleMuPass")
        #if not self.singleMuPass_branch and "singleMuPass" not in self.complained:
        if not self.singleMuPass_branch and "singleMuPass":
            warnings.warn( "ETauTree: Expected branch singleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPass")
        else:
            self.singleMuPass_branch.SetAddress(<void*>&self.singleMuPass_value)

        #print "making singleMuPrescale"
        self.singleMuPrescale_branch = the_tree.GetBranch("singleMuPrescale")
        #if not self.singleMuPrescale_branch and "singleMuPrescale" not in self.complained:
        if not self.singleMuPrescale_branch and "singleMuPrescale":
            warnings.warn( "ETauTree: Expected branch singleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPrescale")
        else:
            self.singleMuPrescale_branch.SetAddress(<void*>&self.singleMuPrescale_value)

        #print "making singlePhoGroup"
        self.singlePhoGroup_branch = the_tree.GetBranch("singlePhoGroup")
        #if not self.singlePhoGroup_branch and "singlePhoGroup" not in self.complained:
        if not self.singlePhoGroup_branch and "singlePhoGroup":
            warnings.warn( "ETauTree: Expected branch singlePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoGroup")
        else:
            self.singlePhoGroup_branch.SetAddress(<void*>&self.singlePhoGroup_value)

        #print "making singlePhoPass"
        self.singlePhoPass_branch = the_tree.GetBranch("singlePhoPass")
        #if not self.singlePhoPass_branch and "singlePhoPass" not in self.complained:
        if not self.singlePhoPass_branch and "singlePhoPass":
            warnings.warn( "ETauTree: Expected branch singlePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPass")
        else:
            self.singlePhoPass_branch.SetAddress(<void*>&self.singlePhoPass_value)

        #print "making singlePhoPrescale"
        self.singlePhoPrescale_branch = the_tree.GetBranch("singlePhoPrescale")
        #if not self.singlePhoPrescale_branch and "singlePhoPrescale" not in self.complained:
        if not self.singlePhoPrescale_branch and "singlePhoPrescale":
            warnings.warn( "ETauTree: Expected branch singlePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPrescale")
        else:
            self.singlePhoPrescale_branch.SetAddress(<void*>&self.singlePhoPrescale_value)

        #print "making tAbsEta"
        self.tAbsEta_branch = the_tree.GetBranch("tAbsEta")
        #if not self.tAbsEta_branch and "tAbsEta" not in self.complained:
        if not self.tAbsEta_branch and "tAbsEta":
            warnings.warn( "ETauTree: Expected branch tAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAbsEta")
        else:
            self.tAbsEta_branch.SetAddress(<void*>&self.tAbsEta_value)

        #print "making tAntiElectronLoose"
        self.tAntiElectronLoose_branch = the_tree.GetBranch("tAntiElectronLoose")
        #if not self.tAntiElectronLoose_branch and "tAntiElectronLoose" not in self.complained:
        if not self.tAntiElectronLoose_branch and "tAntiElectronLoose":
            warnings.warn( "ETauTree: Expected branch tAntiElectronLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronLoose")
        else:
            self.tAntiElectronLoose_branch.SetAddress(<void*>&self.tAntiElectronLoose_value)

        #print "making tAntiElectronMVA5Loose"
        self.tAntiElectronMVA5Loose_branch = the_tree.GetBranch("tAntiElectronMVA5Loose")
        #if not self.tAntiElectronMVA5Loose_branch and "tAntiElectronMVA5Loose" not in self.complained:
        if not self.tAntiElectronMVA5Loose_branch and "tAntiElectronMVA5Loose":
            warnings.warn( "ETauTree: Expected branch tAntiElectronMVA5Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA5Loose")
        else:
            self.tAntiElectronMVA5Loose_branch.SetAddress(<void*>&self.tAntiElectronMVA5Loose_value)

        #print "making tAntiElectronMVA5Medium"
        self.tAntiElectronMVA5Medium_branch = the_tree.GetBranch("tAntiElectronMVA5Medium")
        #if not self.tAntiElectronMVA5Medium_branch and "tAntiElectronMVA5Medium" not in self.complained:
        if not self.tAntiElectronMVA5Medium_branch and "tAntiElectronMVA5Medium":
            warnings.warn( "ETauTree: Expected branch tAntiElectronMVA5Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA5Medium")
        else:
            self.tAntiElectronMVA5Medium_branch.SetAddress(<void*>&self.tAntiElectronMVA5Medium_value)

        #print "making tAntiElectronMVA5Tight"
        self.tAntiElectronMVA5Tight_branch = the_tree.GetBranch("tAntiElectronMVA5Tight")
        #if not self.tAntiElectronMVA5Tight_branch and "tAntiElectronMVA5Tight" not in self.complained:
        if not self.tAntiElectronMVA5Tight_branch and "tAntiElectronMVA5Tight":
            warnings.warn( "ETauTree: Expected branch tAntiElectronMVA5Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA5Tight")
        else:
            self.tAntiElectronMVA5Tight_branch.SetAddress(<void*>&self.tAntiElectronMVA5Tight_value)

        #print "making tAntiElectronMVA5VLoose"
        self.tAntiElectronMVA5VLoose_branch = the_tree.GetBranch("tAntiElectronMVA5VLoose")
        #if not self.tAntiElectronMVA5VLoose_branch and "tAntiElectronMVA5VLoose" not in self.complained:
        if not self.tAntiElectronMVA5VLoose_branch and "tAntiElectronMVA5VLoose":
            warnings.warn( "ETauTree: Expected branch tAntiElectronMVA5VLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA5VLoose")
        else:
            self.tAntiElectronMVA5VLoose_branch.SetAddress(<void*>&self.tAntiElectronMVA5VLoose_value)

        #print "making tAntiElectronMVA5VTight"
        self.tAntiElectronMVA5VTight_branch = the_tree.GetBranch("tAntiElectronMVA5VTight")
        #if not self.tAntiElectronMVA5VTight_branch and "tAntiElectronMVA5VTight" not in self.complained:
        if not self.tAntiElectronMVA5VTight_branch and "tAntiElectronMVA5VTight":
            warnings.warn( "ETauTree: Expected branch tAntiElectronMVA5VTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA5VTight")
        else:
            self.tAntiElectronMVA5VTight_branch.SetAddress(<void*>&self.tAntiElectronMVA5VTight_value)

        #print "making tAntiElectronMedium"
        self.tAntiElectronMedium_branch = the_tree.GetBranch("tAntiElectronMedium")
        #if not self.tAntiElectronMedium_branch and "tAntiElectronMedium" not in self.complained:
        if not self.tAntiElectronMedium_branch and "tAntiElectronMedium":
            warnings.warn( "ETauTree: Expected branch tAntiElectronMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMedium")
        else:
            self.tAntiElectronMedium_branch.SetAddress(<void*>&self.tAntiElectronMedium_value)

        #print "making tAntiElectronTight"
        self.tAntiElectronTight_branch = the_tree.GetBranch("tAntiElectronTight")
        #if not self.tAntiElectronTight_branch and "tAntiElectronTight" not in self.complained:
        if not self.tAntiElectronTight_branch and "tAntiElectronTight":
            warnings.warn( "ETauTree: Expected branch tAntiElectronTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronTight")
        else:
            self.tAntiElectronTight_branch.SetAddress(<void*>&self.tAntiElectronTight_value)

        #print "making tAntiMuon2Loose"
        self.tAntiMuon2Loose_branch = the_tree.GetBranch("tAntiMuon2Loose")
        #if not self.tAntiMuon2Loose_branch and "tAntiMuon2Loose" not in self.complained:
        if not self.tAntiMuon2Loose_branch and "tAntiMuon2Loose":
            warnings.warn( "ETauTree: Expected branch tAntiMuon2Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuon2Loose")
        else:
            self.tAntiMuon2Loose_branch.SetAddress(<void*>&self.tAntiMuon2Loose_value)

        #print "making tAntiMuon2Medium"
        self.tAntiMuon2Medium_branch = the_tree.GetBranch("tAntiMuon2Medium")
        #if not self.tAntiMuon2Medium_branch and "tAntiMuon2Medium" not in self.complained:
        if not self.tAntiMuon2Medium_branch and "tAntiMuon2Medium":
            warnings.warn( "ETauTree: Expected branch tAntiMuon2Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuon2Medium")
        else:
            self.tAntiMuon2Medium_branch.SetAddress(<void*>&self.tAntiMuon2Medium_value)

        #print "making tAntiMuon2Tight"
        self.tAntiMuon2Tight_branch = the_tree.GetBranch("tAntiMuon2Tight")
        #if not self.tAntiMuon2Tight_branch and "tAntiMuon2Tight" not in self.complained:
        if not self.tAntiMuon2Tight_branch and "tAntiMuon2Tight":
            warnings.warn( "ETauTree: Expected branch tAntiMuon2Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuon2Tight")
        else:
            self.tAntiMuon2Tight_branch.SetAddress(<void*>&self.tAntiMuon2Tight_value)

        #print "making tAntiMuon3Loose"
        self.tAntiMuon3Loose_branch = the_tree.GetBranch("tAntiMuon3Loose")
        #if not self.tAntiMuon3Loose_branch and "tAntiMuon3Loose" not in self.complained:
        if not self.tAntiMuon3Loose_branch and "tAntiMuon3Loose":
            warnings.warn( "ETauTree: Expected branch tAntiMuon3Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuon3Loose")
        else:
            self.tAntiMuon3Loose_branch.SetAddress(<void*>&self.tAntiMuon3Loose_value)

        #print "making tAntiMuon3Tight"
        self.tAntiMuon3Tight_branch = the_tree.GetBranch("tAntiMuon3Tight")
        #if not self.tAntiMuon3Tight_branch and "tAntiMuon3Tight" not in self.complained:
        if not self.tAntiMuon3Tight_branch and "tAntiMuon3Tight":
            warnings.warn( "ETauTree: Expected branch tAntiMuon3Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuon3Tight")
        else:
            self.tAntiMuon3Tight_branch.SetAddress(<void*>&self.tAntiMuon3Tight_value)

        #print "making tAntiMuonLoose"
        self.tAntiMuonLoose_branch = the_tree.GetBranch("tAntiMuonLoose")
        #if not self.tAntiMuonLoose_branch and "tAntiMuonLoose" not in self.complained:
        if not self.tAntiMuonLoose_branch and "tAntiMuonLoose":
            warnings.warn( "ETauTree: Expected branch tAntiMuonLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonLoose")
        else:
            self.tAntiMuonLoose_branch.SetAddress(<void*>&self.tAntiMuonLoose_value)

        #print "making tAntiMuonMVALoose"
        self.tAntiMuonMVALoose_branch = the_tree.GetBranch("tAntiMuonMVALoose")
        #if not self.tAntiMuonMVALoose_branch and "tAntiMuonMVALoose" not in self.complained:
        if not self.tAntiMuonMVALoose_branch and "tAntiMuonMVALoose":
            warnings.warn( "ETauTree: Expected branch tAntiMuonMVALoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMVALoose")
        else:
            self.tAntiMuonMVALoose_branch.SetAddress(<void*>&self.tAntiMuonMVALoose_value)

        #print "making tAntiMuonMVAMedium"
        self.tAntiMuonMVAMedium_branch = the_tree.GetBranch("tAntiMuonMVAMedium")
        #if not self.tAntiMuonMVAMedium_branch and "tAntiMuonMVAMedium" not in self.complained:
        if not self.tAntiMuonMVAMedium_branch and "tAntiMuonMVAMedium":
            warnings.warn( "ETauTree: Expected branch tAntiMuonMVAMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMVAMedium")
        else:
            self.tAntiMuonMVAMedium_branch.SetAddress(<void*>&self.tAntiMuonMVAMedium_value)

        #print "making tAntiMuonMVATight"
        self.tAntiMuonMVATight_branch = the_tree.GetBranch("tAntiMuonMVATight")
        #if not self.tAntiMuonMVATight_branch and "tAntiMuonMVATight" not in self.complained:
        if not self.tAntiMuonMVATight_branch and "tAntiMuonMVATight":
            warnings.warn( "ETauTree: Expected branch tAntiMuonMVATight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMVATight")
        else:
            self.tAntiMuonMVATight_branch.SetAddress(<void*>&self.tAntiMuonMVATight_value)

        #print "making tAntiMuonMedium"
        self.tAntiMuonMedium_branch = the_tree.GetBranch("tAntiMuonMedium")
        #if not self.tAntiMuonMedium_branch and "tAntiMuonMedium" not in self.complained:
        if not self.tAntiMuonMedium_branch and "tAntiMuonMedium":
            warnings.warn( "ETauTree: Expected branch tAntiMuonMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMedium")
        else:
            self.tAntiMuonMedium_branch.SetAddress(<void*>&self.tAntiMuonMedium_value)

        #print "making tAntiMuonTight"
        self.tAntiMuonTight_branch = the_tree.GetBranch("tAntiMuonTight")
        #if not self.tAntiMuonTight_branch and "tAntiMuonTight" not in self.complained:
        if not self.tAntiMuonTight_branch and "tAntiMuonTight":
            warnings.warn( "ETauTree: Expected branch tAntiMuonTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonTight")
        else:
            self.tAntiMuonTight_branch.SetAddress(<void*>&self.tAntiMuonTight_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "ETauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tCiCTightElecOverlap"
        self.tCiCTightElecOverlap_branch = the_tree.GetBranch("tCiCTightElecOverlap")
        #if not self.tCiCTightElecOverlap_branch and "tCiCTightElecOverlap" not in self.complained:
        if not self.tCiCTightElecOverlap_branch and "tCiCTightElecOverlap":
            warnings.warn( "ETauTree: Expected branch tCiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCiCTightElecOverlap")
        else:
            self.tCiCTightElecOverlap_branch.SetAddress(<void*>&self.tCiCTightElecOverlap_value)

        #print "making tComesFromHiggs"
        self.tComesFromHiggs_branch = the_tree.GetBranch("tComesFromHiggs")
        #if not self.tComesFromHiggs_branch and "tComesFromHiggs" not in self.complained:
        if not self.tComesFromHiggs_branch and "tComesFromHiggs":
            warnings.warn( "ETauTree: Expected branch tComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tComesFromHiggs")
        else:
            self.tComesFromHiggs_branch.SetAddress(<void*>&self.tComesFromHiggs_value)

        #print "making tDZ"
        self.tDZ_branch = the_tree.GetBranch("tDZ")
        #if not self.tDZ_branch and "tDZ" not in self.complained:
        if not self.tDZ_branch and "tDZ":
            warnings.warn( "ETauTree: Expected branch tDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDZ")
        else:
            self.tDZ_branch.SetAddress(<void*>&self.tDZ_value)

        #print "making tDecayFinding"
        self.tDecayFinding_branch = the_tree.GetBranch("tDecayFinding")
        #if not self.tDecayFinding_branch and "tDecayFinding" not in self.complained:
        if not self.tDecayFinding_branch and "tDecayFinding":
            warnings.warn( "ETauTree: Expected branch tDecayFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayFinding")
        else:
            self.tDecayFinding_branch.SetAddress(<void*>&self.tDecayFinding_value)

        #print "making tDecayFindingNewDMs"
        self.tDecayFindingNewDMs_branch = the_tree.GetBranch("tDecayFindingNewDMs")
        #if not self.tDecayFindingNewDMs_branch and "tDecayFindingNewDMs" not in self.complained:
        if not self.tDecayFindingNewDMs_branch and "tDecayFindingNewDMs":
            warnings.warn( "ETauTree: Expected branch tDecayFindingNewDMs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayFindingNewDMs")
        else:
            self.tDecayFindingNewDMs_branch.SetAddress(<void*>&self.tDecayFindingNewDMs_value)

        #print "making tDecayFindingOldDMs"
        self.tDecayFindingOldDMs_branch = the_tree.GetBranch("tDecayFindingOldDMs")
        #if not self.tDecayFindingOldDMs_branch and "tDecayFindingOldDMs" not in self.complained:
        if not self.tDecayFindingOldDMs_branch and "tDecayFindingOldDMs":
            warnings.warn( "ETauTree: Expected branch tDecayFindingOldDMs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayFindingOldDMs")
        else:
            self.tDecayFindingOldDMs_branch.SetAddress(<void*>&self.tDecayFindingOldDMs_value)

        #print "making tDecayMode"
        self.tDecayMode_branch = the_tree.GetBranch("tDecayMode")
        #if not self.tDecayMode_branch and "tDecayMode" not in self.complained:
        if not self.tDecayMode_branch and "tDecayMode":
            warnings.warn( "ETauTree: Expected branch tDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayMode")
        else:
            self.tDecayMode_branch.SetAddress(<void*>&self.tDecayMode_value)

        #print "making tElecOverlap"
        self.tElecOverlap_branch = the_tree.GetBranch("tElecOverlap")
        #if not self.tElecOverlap_branch and "tElecOverlap" not in self.complained:
        if not self.tElecOverlap_branch and "tElecOverlap":
            warnings.warn( "ETauTree: Expected branch tElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElecOverlap")
        else:
            self.tElecOverlap_branch.SetAddress(<void*>&self.tElecOverlap_value)

        #print "making tElectronPt10IdIsoVtxOverlap"
        self.tElectronPt10IdIsoVtxOverlap_branch = the_tree.GetBranch("tElectronPt10IdIsoVtxOverlap")
        #if not self.tElectronPt10IdIsoVtxOverlap_branch and "tElectronPt10IdIsoVtxOverlap" not in self.complained:
        if not self.tElectronPt10IdIsoVtxOverlap_branch and "tElectronPt10IdIsoVtxOverlap":
            warnings.warn( "ETauTree: Expected branch tElectronPt10IdIsoVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElectronPt10IdIsoVtxOverlap")
        else:
            self.tElectronPt10IdIsoVtxOverlap_branch.SetAddress(<void*>&self.tElectronPt10IdIsoVtxOverlap_value)

        #print "making tElectronPt10IdVtxOverlap"
        self.tElectronPt10IdVtxOverlap_branch = the_tree.GetBranch("tElectronPt10IdVtxOverlap")
        #if not self.tElectronPt10IdVtxOverlap_branch and "tElectronPt10IdVtxOverlap" not in self.complained:
        if not self.tElectronPt10IdVtxOverlap_branch and "tElectronPt10IdVtxOverlap":
            warnings.warn( "ETauTree: Expected branch tElectronPt10IdVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElectronPt10IdVtxOverlap")
        else:
            self.tElectronPt10IdVtxOverlap_branch.SetAddress(<void*>&self.tElectronPt10IdVtxOverlap_value)

        #print "making tElectronPt15IdIsoVtxOverlap"
        self.tElectronPt15IdIsoVtxOverlap_branch = the_tree.GetBranch("tElectronPt15IdIsoVtxOverlap")
        #if not self.tElectronPt15IdIsoVtxOverlap_branch and "tElectronPt15IdIsoVtxOverlap" not in self.complained:
        if not self.tElectronPt15IdIsoVtxOverlap_branch and "tElectronPt15IdIsoVtxOverlap":
            warnings.warn( "ETauTree: Expected branch tElectronPt15IdIsoVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElectronPt15IdIsoVtxOverlap")
        else:
            self.tElectronPt15IdIsoVtxOverlap_branch.SetAddress(<void*>&self.tElectronPt15IdIsoVtxOverlap_value)

        #print "making tElectronPt15IdVtxOverlap"
        self.tElectronPt15IdVtxOverlap_branch = the_tree.GetBranch("tElectronPt15IdVtxOverlap")
        #if not self.tElectronPt15IdVtxOverlap_branch and "tElectronPt15IdVtxOverlap" not in self.complained:
        if not self.tElectronPt15IdVtxOverlap_branch and "tElectronPt15IdVtxOverlap":
            warnings.warn( "ETauTree: Expected branch tElectronPt15IdVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElectronPt15IdVtxOverlap")
        else:
            self.tElectronPt15IdVtxOverlap_branch.SetAddress(<void*>&self.tElectronPt15IdVtxOverlap_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "ETauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tGenCharge"
        self.tGenCharge_branch = the_tree.GetBranch("tGenCharge")
        #if not self.tGenCharge_branch and "tGenCharge" not in self.complained:
        if not self.tGenCharge_branch and "tGenCharge":
            warnings.warn( "ETauTree: Expected branch tGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenCharge")
        else:
            self.tGenCharge_branch.SetAddress(<void*>&self.tGenCharge_value)

        #print "making tGenDecayMode"
        self.tGenDecayMode_branch = the_tree.GetBranch("tGenDecayMode")
        #if not self.tGenDecayMode_branch and "tGenDecayMode" not in self.complained:
        if not self.tGenDecayMode_branch and "tGenDecayMode":
            warnings.warn( "ETauTree: Expected branch tGenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenDecayMode")
        else:
            self.tGenDecayMode_branch.SetAddress(<void*>&self.tGenDecayMode_value)

        #print "making tGenEnergy"
        self.tGenEnergy_branch = the_tree.GetBranch("tGenEnergy")
        #if not self.tGenEnergy_branch and "tGenEnergy" not in self.complained:
        if not self.tGenEnergy_branch and "tGenEnergy":
            warnings.warn( "ETauTree: Expected branch tGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEnergy")
        else:
            self.tGenEnergy_branch.SetAddress(<void*>&self.tGenEnergy_value)

        #print "making tGenEta"
        self.tGenEta_branch = the_tree.GetBranch("tGenEta")
        #if not self.tGenEta_branch and "tGenEta" not in self.complained:
        if not self.tGenEta_branch and "tGenEta":
            warnings.warn( "ETauTree: Expected branch tGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEta")
        else:
            self.tGenEta_branch.SetAddress(<void*>&self.tGenEta_value)

        #print "making tGenMotherEnergy"
        self.tGenMotherEnergy_branch = the_tree.GetBranch("tGenMotherEnergy")
        #if not self.tGenMotherEnergy_branch and "tGenMotherEnergy" not in self.complained:
        if not self.tGenMotherEnergy_branch and "tGenMotherEnergy":
            warnings.warn( "ETauTree: Expected branch tGenMotherEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEnergy")
        else:
            self.tGenMotherEnergy_branch.SetAddress(<void*>&self.tGenMotherEnergy_value)

        #print "making tGenMotherEta"
        self.tGenMotherEta_branch = the_tree.GetBranch("tGenMotherEta")
        #if not self.tGenMotherEta_branch and "tGenMotherEta" not in self.complained:
        if not self.tGenMotherEta_branch and "tGenMotherEta":
            warnings.warn( "ETauTree: Expected branch tGenMotherEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEta")
        else:
            self.tGenMotherEta_branch.SetAddress(<void*>&self.tGenMotherEta_value)

        #print "making tGenMotherPdgId"
        self.tGenMotherPdgId_branch = the_tree.GetBranch("tGenMotherPdgId")
        #if not self.tGenMotherPdgId_branch and "tGenMotherPdgId" not in self.complained:
        if not self.tGenMotherPdgId_branch and "tGenMotherPdgId":
            warnings.warn( "ETauTree: Expected branch tGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPdgId")
        else:
            self.tGenMotherPdgId_branch.SetAddress(<void*>&self.tGenMotherPdgId_value)

        #print "making tGenMotherPhi"
        self.tGenMotherPhi_branch = the_tree.GetBranch("tGenMotherPhi")
        #if not self.tGenMotherPhi_branch and "tGenMotherPhi" not in self.complained:
        if not self.tGenMotherPhi_branch and "tGenMotherPhi":
            warnings.warn( "ETauTree: Expected branch tGenMotherPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPhi")
        else:
            self.tGenMotherPhi_branch.SetAddress(<void*>&self.tGenMotherPhi_value)

        #print "making tGenMotherPt"
        self.tGenMotherPt_branch = the_tree.GetBranch("tGenMotherPt")
        #if not self.tGenMotherPt_branch and "tGenMotherPt" not in self.complained:
        if not self.tGenMotherPt_branch and "tGenMotherPt":
            warnings.warn( "ETauTree: Expected branch tGenMotherPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPt")
        else:
            self.tGenMotherPt_branch.SetAddress(<void*>&self.tGenMotherPt_value)

        #print "making tGenPdgId"
        self.tGenPdgId_branch = the_tree.GetBranch("tGenPdgId")
        #if not self.tGenPdgId_branch and "tGenPdgId" not in self.complained:
        if not self.tGenPdgId_branch and "tGenPdgId":
            warnings.warn( "ETauTree: Expected branch tGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPdgId")
        else:
            self.tGenPdgId_branch.SetAddress(<void*>&self.tGenPdgId_value)

        #print "making tGenPhi"
        self.tGenPhi_branch = the_tree.GetBranch("tGenPhi")
        #if not self.tGenPhi_branch and "tGenPhi" not in self.complained:
        if not self.tGenPhi_branch and "tGenPhi":
            warnings.warn( "ETauTree: Expected branch tGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPhi")
        else:
            self.tGenPhi_branch.SetAddress(<void*>&self.tGenPhi_value)

        #print "making tGenPt"
        self.tGenPt_branch = the_tree.GetBranch("tGenPt")
        #if not self.tGenPt_branch and "tGenPt" not in self.complained:
        if not self.tGenPt_branch and "tGenPt":
            warnings.warn( "ETauTree: Expected branch tGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPt")
        else:
            self.tGenPt_branch.SetAddress(<void*>&self.tGenPt_value)

        #print "making tGenPx"
        self.tGenPx_branch = the_tree.GetBranch("tGenPx")
        #if not self.tGenPx_branch and "tGenPx" not in self.complained:
        if not self.tGenPx_branch and "tGenPx":
            warnings.warn( "ETauTree: Expected branch tGenPx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPx")
        else:
            self.tGenPx_branch.SetAddress(<void*>&self.tGenPx_value)

        #print "making tGenPy"
        self.tGenPy_branch = the_tree.GetBranch("tGenPy")
        #if not self.tGenPy_branch and "tGenPy" not in self.complained:
        if not self.tGenPy_branch and "tGenPy":
            warnings.warn( "ETauTree: Expected branch tGenPy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPy")
        else:
            self.tGenPy_branch.SetAddress(<void*>&self.tGenPy_value)

        #print "making tGenPz"
        self.tGenPz_branch = the_tree.GetBranch("tGenPz")
        #if not self.tGenPz_branch and "tGenPz" not in self.complained:
        if not self.tGenPz_branch and "tGenPz":
            warnings.warn( "ETauTree: Expected branch tGenPz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPz")
        else:
            self.tGenPz_branch.SetAddress(<void*>&self.tGenPz_value)

        #print "making tGlobalMuonVtxOverlap"
        self.tGlobalMuonVtxOverlap_branch = the_tree.GetBranch("tGlobalMuonVtxOverlap")
        #if not self.tGlobalMuonVtxOverlap_branch and "tGlobalMuonVtxOverlap" not in self.complained:
        if not self.tGlobalMuonVtxOverlap_branch and "tGlobalMuonVtxOverlap":
            warnings.warn( "ETauTree: Expected branch tGlobalMuonVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGlobalMuonVtxOverlap")
        else:
            self.tGlobalMuonVtxOverlap_branch.SetAddress(<void*>&self.tGlobalMuonVtxOverlap_value)

        #print "making tIP3DS"
        self.tIP3DS_branch = the_tree.GetBranch("tIP3DS")
        #if not self.tIP3DS_branch and "tIP3DS" not in self.complained:
        if not self.tIP3DS_branch and "tIP3DS":
            warnings.warn( "ETauTree: Expected branch tIP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tIP3DS")
        else:
            self.tIP3DS_branch.SetAddress(<void*>&self.tIP3DS_value)

        #print "making tJetArea"
        self.tJetArea_branch = the_tree.GetBranch("tJetArea")
        #if not self.tJetArea_branch and "tJetArea" not in self.complained:
        if not self.tJetArea_branch and "tJetArea":
            warnings.warn( "ETauTree: Expected branch tJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetArea")
        else:
            self.tJetArea_branch.SetAddress(<void*>&self.tJetArea_value)

        #print "making tJetBtag"
        self.tJetBtag_branch = the_tree.GetBranch("tJetBtag")
        #if not self.tJetBtag_branch and "tJetBtag" not in self.complained:
        if not self.tJetBtag_branch and "tJetBtag":
            warnings.warn( "ETauTree: Expected branch tJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetBtag")
        else:
            self.tJetBtag_branch.SetAddress(<void*>&self.tJetBtag_value)

        #print "making tJetCSVBtag"
        self.tJetCSVBtag_branch = the_tree.GetBranch("tJetCSVBtag")
        #if not self.tJetCSVBtag_branch and "tJetCSVBtag" not in self.complained:
        if not self.tJetCSVBtag_branch and "tJetCSVBtag":
            warnings.warn( "ETauTree: Expected branch tJetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetCSVBtag")
        else:
            self.tJetCSVBtag_branch.SetAddress(<void*>&self.tJetCSVBtag_value)

        #print "making tJetEtaEtaMoment"
        self.tJetEtaEtaMoment_branch = the_tree.GetBranch("tJetEtaEtaMoment")
        #if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment" not in self.complained:
        if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment":
            warnings.warn( "ETauTree: Expected branch tJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaEtaMoment")
        else:
            self.tJetEtaEtaMoment_branch.SetAddress(<void*>&self.tJetEtaEtaMoment_value)

        #print "making tJetEtaPhiMoment"
        self.tJetEtaPhiMoment_branch = the_tree.GetBranch("tJetEtaPhiMoment")
        #if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment" not in self.complained:
        if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment":
            warnings.warn( "ETauTree: Expected branch tJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiMoment")
        else:
            self.tJetEtaPhiMoment_branch.SetAddress(<void*>&self.tJetEtaPhiMoment_value)

        #print "making tJetEtaPhiSpread"
        self.tJetEtaPhiSpread_branch = the_tree.GetBranch("tJetEtaPhiSpread")
        #if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread" not in self.complained:
        if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread":
            warnings.warn( "ETauTree: Expected branch tJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiSpread")
        else:
            self.tJetEtaPhiSpread_branch.SetAddress(<void*>&self.tJetEtaPhiSpread_value)

        #print "making tJetPhiPhiMoment"
        self.tJetPhiPhiMoment_branch = the_tree.GetBranch("tJetPhiPhiMoment")
        #if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment" not in self.complained:
        if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment":
            warnings.warn( "ETauTree: Expected branch tJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPhiPhiMoment")
        else:
            self.tJetPhiPhiMoment_branch.SetAddress(<void*>&self.tJetPhiPhiMoment_value)

        #print "making tJetPt"
        self.tJetPt_branch = the_tree.GetBranch("tJetPt")
        #if not self.tJetPt_branch and "tJetPt" not in self.complained:
        if not self.tJetPt_branch and "tJetPt":
            warnings.warn( "ETauTree: Expected branch tJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPt")
        else:
            self.tJetPt_branch.SetAddress(<void*>&self.tJetPt_value)

        #print "making tJetQGLikelihoodID"
        self.tJetQGLikelihoodID_branch = the_tree.GetBranch("tJetQGLikelihoodID")
        #if not self.tJetQGLikelihoodID_branch and "tJetQGLikelihoodID" not in self.complained:
        if not self.tJetQGLikelihoodID_branch and "tJetQGLikelihoodID":
            warnings.warn( "ETauTree: Expected branch tJetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetQGLikelihoodID")
        else:
            self.tJetQGLikelihoodID_branch.SetAddress(<void*>&self.tJetQGLikelihoodID_value)

        #print "making tJetQGMVAID"
        self.tJetQGMVAID_branch = the_tree.GetBranch("tJetQGMVAID")
        #if not self.tJetQGMVAID_branch and "tJetQGMVAID" not in self.complained:
        if not self.tJetQGMVAID_branch and "tJetQGMVAID":
            warnings.warn( "ETauTree: Expected branch tJetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetQGMVAID")
        else:
            self.tJetQGMVAID_branch.SetAddress(<void*>&self.tJetQGMVAID_value)

        #print "making tLeadTrackPt"
        self.tLeadTrackPt_branch = the_tree.GetBranch("tLeadTrackPt")
        #if not self.tLeadTrackPt_branch and "tLeadTrackPt" not in self.complained:
        if not self.tLeadTrackPt_branch and "tLeadTrackPt":
            warnings.warn( "ETauTree: Expected branch tLeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLeadTrackPt")
        else:
            self.tLeadTrackPt_branch.SetAddress(<void*>&self.tLeadTrackPt_value)

        #print "making tLooseIso"
        self.tLooseIso_branch = the_tree.GetBranch("tLooseIso")
        #if not self.tLooseIso_branch and "tLooseIso" not in self.complained:
        if not self.tLooseIso_branch and "tLooseIso":
            warnings.warn( "ETauTree: Expected branch tLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIso")
        else:
            self.tLooseIso_branch.SetAddress(<void*>&self.tLooseIso_value)

        #print "making tLooseIso3Hits"
        self.tLooseIso3Hits_branch = the_tree.GetBranch("tLooseIso3Hits")
        #if not self.tLooseIso3Hits_branch and "tLooseIso3Hits" not in self.complained:
        if not self.tLooseIso3Hits_branch and "tLooseIso3Hits":
            warnings.warn( "ETauTree: Expected branch tLooseIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIso3Hits")
        else:
            self.tLooseIso3Hits_branch.SetAddress(<void*>&self.tLooseIso3Hits_value)

        #print "making tLooseIsoMVA3NewDMLT"
        self.tLooseIsoMVA3NewDMLT_branch = the_tree.GetBranch("tLooseIsoMVA3NewDMLT")
        #if not self.tLooseIsoMVA3NewDMLT_branch and "tLooseIsoMVA3NewDMLT" not in self.complained:
        if not self.tLooseIsoMVA3NewDMLT_branch and "tLooseIsoMVA3NewDMLT":
            warnings.warn( "ETauTree: Expected branch tLooseIsoMVA3NewDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIsoMVA3NewDMLT")
        else:
            self.tLooseIsoMVA3NewDMLT_branch.SetAddress(<void*>&self.tLooseIsoMVA3NewDMLT_value)

        #print "making tLooseIsoMVA3NewDMNoLT"
        self.tLooseIsoMVA3NewDMNoLT_branch = the_tree.GetBranch("tLooseIsoMVA3NewDMNoLT")
        #if not self.tLooseIsoMVA3NewDMNoLT_branch and "tLooseIsoMVA3NewDMNoLT" not in self.complained:
        if not self.tLooseIsoMVA3NewDMNoLT_branch and "tLooseIsoMVA3NewDMNoLT":
            warnings.warn( "ETauTree: Expected branch tLooseIsoMVA3NewDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIsoMVA3NewDMNoLT")
        else:
            self.tLooseIsoMVA3NewDMNoLT_branch.SetAddress(<void*>&self.tLooseIsoMVA3NewDMNoLT_value)

        #print "making tLooseIsoMVA3OldDMLT"
        self.tLooseIsoMVA3OldDMLT_branch = the_tree.GetBranch("tLooseIsoMVA3OldDMLT")
        #if not self.tLooseIsoMVA3OldDMLT_branch and "tLooseIsoMVA3OldDMLT" not in self.complained:
        if not self.tLooseIsoMVA3OldDMLT_branch and "tLooseIsoMVA3OldDMLT":
            warnings.warn( "ETauTree: Expected branch tLooseIsoMVA3OldDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIsoMVA3OldDMLT")
        else:
            self.tLooseIsoMVA3OldDMLT_branch.SetAddress(<void*>&self.tLooseIsoMVA3OldDMLT_value)

        #print "making tLooseIsoMVA3OldDMNoLT"
        self.tLooseIsoMVA3OldDMNoLT_branch = the_tree.GetBranch("tLooseIsoMVA3OldDMNoLT")
        #if not self.tLooseIsoMVA3OldDMNoLT_branch and "tLooseIsoMVA3OldDMNoLT" not in self.complained:
        if not self.tLooseIsoMVA3OldDMNoLT_branch and "tLooseIsoMVA3OldDMNoLT":
            warnings.warn( "ETauTree: Expected branch tLooseIsoMVA3OldDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIsoMVA3OldDMNoLT")
        else:
            self.tLooseIsoMVA3OldDMNoLT_branch.SetAddress(<void*>&self.tLooseIsoMVA3OldDMNoLT_value)

        #print "making tMass"
        self.tMass_branch = the_tree.GetBranch("tMass")
        #if not self.tMass_branch and "tMass" not in self.complained:
        if not self.tMass_branch and "tMass":
            warnings.warn( "ETauTree: Expected branch tMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass")
        else:
            self.tMass_branch.SetAddress(<void*>&self.tMass_value)

        #print "making tMediumIso"
        self.tMediumIso_branch = the_tree.GetBranch("tMediumIso")
        #if not self.tMediumIso_branch and "tMediumIso" not in self.complained:
        if not self.tMediumIso_branch and "tMediumIso":
            warnings.warn( "ETauTree: Expected branch tMediumIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIso")
        else:
            self.tMediumIso_branch.SetAddress(<void*>&self.tMediumIso_value)

        #print "making tMediumIso3Hits"
        self.tMediumIso3Hits_branch = the_tree.GetBranch("tMediumIso3Hits")
        #if not self.tMediumIso3Hits_branch and "tMediumIso3Hits" not in self.complained:
        if not self.tMediumIso3Hits_branch and "tMediumIso3Hits":
            warnings.warn( "ETauTree: Expected branch tMediumIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIso3Hits")
        else:
            self.tMediumIso3Hits_branch.SetAddress(<void*>&self.tMediumIso3Hits_value)

        #print "making tMediumIsoMVA3NewDMLT"
        self.tMediumIsoMVA3NewDMLT_branch = the_tree.GetBranch("tMediumIsoMVA3NewDMLT")
        #if not self.tMediumIsoMVA3NewDMLT_branch and "tMediumIsoMVA3NewDMLT" not in self.complained:
        if not self.tMediumIsoMVA3NewDMLT_branch and "tMediumIsoMVA3NewDMLT":
            warnings.warn( "ETauTree: Expected branch tMediumIsoMVA3NewDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIsoMVA3NewDMLT")
        else:
            self.tMediumIsoMVA3NewDMLT_branch.SetAddress(<void*>&self.tMediumIsoMVA3NewDMLT_value)

        #print "making tMediumIsoMVA3NewDMNoLT"
        self.tMediumIsoMVA3NewDMNoLT_branch = the_tree.GetBranch("tMediumIsoMVA3NewDMNoLT")
        #if not self.tMediumIsoMVA3NewDMNoLT_branch and "tMediumIsoMVA3NewDMNoLT" not in self.complained:
        if not self.tMediumIsoMVA3NewDMNoLT_branch and "tMediumIsoMVA3NewDMNoLT":
            warnings.warn( "ETauTree: Expected branch tMediumIsoMVA3NewDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIsoMVA3NewDMNoLT")
        else:
            self.tMediumIsoMVA3NewDMNoLT_branch.SetAddress(<void*>&self.tMediumIsoMVA3NewDMNoLT_value)

        #print "making tMediumIsoMVA3OldDMLT"
        self.tMediumIsoMVA3OldDMLT_branch = the_tree.GetBranch("tMediumIsoMVA3OldDMLT")
        #if not self.tMediumIsoMVA3OldDMLT_branch and "tMediumIsoMVA3OldDMLT" not in self.complained:
        if not self.tMediumIsoMVA3OldDMLT_branch and "tMediumIsoMVA3OldDMLT":
            warnings.warn( "ETauTree: Expected branch tMediumIsoMVA3OldDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIsoMVA3OldDMLT")
        else:
            self.tMediumIsoMVA3OldDMLT_branch.SetAddress(<void*>&self.tMediumIsoMVA3OldDMLT_value)

        #print "making tMediumIsoMVA3OldDMNoLT"
        self.tMediumIsoMVA3OldDMNoLT_branch = the_tree.GetBranch("tMediumIsoMVA3OldDMNoLT")
        #if not self.tMediumIsoMVA3OldDMNoLT_branch and "tMediumIsoMVA3OldDMNoLT" not in self.complained:
        if not self.tMediumIsoMVA3OldDMNoLT_branch and "tMediumIsoMVA3OldDMNoLT":
            warnings.warn( "ETauTree: Expected branch tMediumIsoMVA3OldDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIsoMVA3OldDMNoLT")
        else:
            self.tMediumIsoMVA3OldDMNoLT_branch.SetAddress(<void*>&self.tMediumIsoMVA3OldDMNoLT_value)

        #print "making tMtToMET"
        self.tMtToMET_branch = the_tree.GetBranch("tMtToMET")
        #if not self.tMtToMET_branch and "tMtToMET" not in self.complained:
        if not self.tMtToMET_branch and "tMtToMET":
            warnings.warn( "ETauTree: Expected branch tMtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToMET")
        else:
            self.tMtToMET_branch.SetAddress(<void*>&self.tMtToMET_value)

        #print "making tMtToMVAMET"
        self.tMtToMVAMET_branch = the_tree.GetBranch("tMtToMVAMET")
        #if not self.tMtToMVAMET_branch and "tMtToMVAMET" not in self.complained:
        if not self.tMtToMVAMET_branch and "tMtToMVAMET":
            warnings.warn( "ETauTree: Expected branch tMtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToMVAMET")
        else:
            self.tMtToMVAMET_branch.SetAddress(<void*>&self.tMtToMVAMET_value)

        #print "making tMtToPfMet"
        self.tMtToPfMet_branch = the_tree.GetBranch("tMtToPfMet")
        #if not self.tMtToPfMet_branch and "tMtToPfMet" not in self.complained:
        if not self.tMtToPfMet_branch and "tMtToPfMet":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet")
        else:
            self.tMtToPfMet_branch.SetAddress(<void*>&self.tMtToPfMet_value)

        #print "making tMtToPfMet_Ty1"
        self.tMtToPfMet_Ty1_branch = the_tree.GetBranch("tMtToPfMet_Ty1")
        #if not self.tMtToPfMet_Ty1_branch and "tMtToPfMet_Ty1" not in self.complained:
        if not self.tMtToPfMet_Ty1_branch and "tMtToPfMet_Ty1":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_Ty1")
        else:
            self.tMtToPfMet_Ty1_branch.SetAddress(<void*>&self.tMtToPfMet_Ty1_value)

        #print "making tMtToPfMet_ees"
        self.tMtToPfMet_ees_branch = the_tree.GetBranch("tMtToPfMet_ees")
        #if not self.tMtToPfMet_ees_branch and "tMtToPfMet_ees" not in self.complained:
        if not self.tMtToPfMet_ees_branch and "tMtToPfMet_ees":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_ees does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ees")
        else:
            self.tMtToPfMet_ees_branch.SetAddress(<void*>&self.tMtToPfMet_ees_value)

        #print "making tMtToPfMet_ees_minus"
        self.tMtToPfMet_ees_minus_branch = the_tree.GetBranch("tMtToPfMet_ees_minus")
        #if not self.tMtToPfMet_ees_minus_branch and "tMtToPfMet_ees_minus" not in self.complained:
        if not self.tMtToPfMet_ees_minus_branch and "tMtToPfMet_ees_minus":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ees_minus")
        else:
            self.tMtToPfMet_ees_minus_branch.SetAddress(<void*>&self.tMtToPfMet_ees_minus_value)

        #print "making tMtToPfMet_ees_plus"
        self.tMtToPfMet_ees_plus_branch = the_tree.GetBranch("tMtToPfMet_ees_plus")
        #if not self.tMtToPfMet_ees_plus_branch and "tMtToPfMet_ees_plus" not in self.complained:
        if not self.tMtToPfMet_ees_plus_branch and "tMtToPfMet_ees_plus":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ees_plus")
        else:
            self.tMtToPfMet_ees_plus_branch.SetAddress(<void*>&self.tMtToPfMet_ees_plus_value)

        #print "making tMtToPfMet_jes"
        self.tMtToPfMet_jes_branch = the_tree.GetBranch("tMtToPfMet_jes")
        #if not self.tMtToPfMet_jes_branch and "tMtToPfMet_jes" not in self.complained:
        if not self.tMtToPfMet_jes_branch and "tMtToPfMet_jes":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_jes")
        else:
            self.tMtToPfMet_jes_branch.SetAddress(<void*>&self.tMtToPfMet_jes_value)

        #print "making tMtToPfMet_jes_minus"
        self.tMtToPfMet_jes_minus_branch = the_tree.GetBranch("tMtToPfMet_jes_minus")
        #if not self.tMtToPfMet_jes_minus_branch and "tMtToPfMet_jes_minus" not in self.complained:
        if not self.tMtToPfMet_jes_minus_branch and "tMtToPfMet_jes_minus":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_jes_minus")
        else:
            self.tMtToPfMet_jes_minus_branch.SetAddress(<void*>&self.tMtToPfMet_jes_minus_value)

        #print "making tMtToPfMet_jes_plus"
        self.tMtToPfMet_jes_plus_branch = the_tree.GetBranch("tMtToPfMet_jes_plus")
        #if not self.tMtToPfMet_jes_plus_branch and "tMtToPfMet_jes_plus" not in self.complained:
        if not self.tMtToPfMet_jes_plus_branch and "tMtToPfMet_jes_plus":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_jes_plus")
        else:
            self.tMtToPfMet_jes_plus_branch.SetAddress(<void*>&self.tMtToPfMet_jes_plus_value)

        #print "making tMtToPfMet_mes"
        self.tMtToPfMet_mes_branch = the_tree.GetBranch("tMtToPfMet_mes")
        #if not self.tMtToPfMet_mes_branch and "tMtToPfMet_mes" not in self.complained:
        if not self.tMtToPfMet_mes_branch and "tMtToPfMet_mes":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_mes")
        else:
            self.tMtToPfMet_mes_branch.SetAddress(<void*>&self.tMtToPfMet_mes_value)

        #print "making tMtToPfMet_mes_minus"
        self.tMtToPfMet_mes_minus_branch = the_tree.GetBranch("tMtToPfMet_mes_minus")
        #if not self.tMtToPfMet_mes_minus_branch and "tMtToPfMet_mes_minus" not in self.complained:
        if not self.tMtToPfMet_mes_minus_branch and "tMtToPfMet_mes_minus":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_mes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_mes_minus")
        else:
            self.tMtToPfMet_mes_minus_branch.SetAddress(<void*>&self.tMtToPfMet_mes_minus_value)

        #print "making tMtToPfMet_mes_plus"
        self.tMtToPfMet_mes_plus_branch = the_tree.GetBranch("tMtToPfMet_mes_plus")
        #if not self.tMtToPfMet_mes_plus_branch and "tMtToPfMet_mes_plus" not in self.complained:
        if not self.tMtToPfMet_mes_plus_branch and "tMtToPfMet_mes_plus":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_mes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_mes_plus")
        else:
            self.tMtToPfMet_mes_plus_branch.SetAddress(<void*>&self.tMtToPfMet_mes_plus_value)

        #print "making tMtToPfMet_tes"
        self.tMtToPfMet_tes_branch = the_tree.GetBranch("tMtToPfMet_tes")
        #if not self.tMtToPfMet_tes_branch and "tMtToPfMet_tes" not in self.complained:
        if not self.tMtToPfMet_tes_branch and "tMtToPfMet_tes":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_tes")
        else:
            self.tMtToPfMet_tes_branch.SetAddress(<void*>&self.tMtToPfMet_tes_value)

        #print "making tMtToPfMet_tes_minus"
        self.tMtToPfMet_tes_minus_branch = the_tree.GetBranch("tMtToPfMet_tes_minus")
        #if not self.tMtToPfMet_tes_minus_branch and "tMtToPfMet_tes_minus" not in self.complained:
        if not self.tMtToPfMet_tes_minus_branch and "tMtToPfMet_tes_minus":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_tes_minus")
        else:
            self.tMtToPfMet_tes_minus_branch.SetAddress(<void*>&self.tMtToPfMet_tes_minus_value)

        #print "making tMtToPfMet_tes_plus"
        self.tMtToPfMet_tes_plus_branch = the_tree.GetBranch("tMtToPfMet_tes_plus")
        #if not self.tMtToPfMet_tes_plus_branch and "tMtToPfMet_tes_plus" not in self.complained:
        if not self.tMtToPfMet_tes_plus_branch and "tMtToPfMet_tes_plus":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_tes_plus")
        else:
            self.tMtToPfMet_tes_plus_branch.SetAddress(<void*>&self.tMtToPfMet_tes_plus_value)

        #print "making tMtToPfMet_ues"
        self.tMtToPfMet_ues_branch = the_tree.GetBranch("tMtToPfMet_ues")
        #if not self.tMtToPfMet_ues_branch and "tMtToPfMet_ues" not in self.complained:
        if not self.tMtToPfMet_ues_branch and "tMtToPfMet_ues":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ues")
        else:
            self.tMtToPfMet_ues_branch.SetAddress(<void*>&self.tMtToPfMet_ues_value)

        #print "making tMtToPfMet_ues_minus"
        self.tMtToPfMet_ues_minus_branch = the_tree.GetBranch("tMtToPfMet_ues_minus")
        #if not self.tMtToPfMet_ues_minus_branch and "tMtToPfMet_ues_minus" not in self.complained:
        if not self.tMtToPfMet_ues_minus_branch and "tMtToPfMet_ues_minus":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_ues_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ues_minus")
        else:
            self.tMtToPfMet_ues_minus_branch.SetAddress(<void*>&self.tMtToPfMet_ues_minus_value)

        #print "making tMtToPfMet_ues_plus"
        self.tMtToPfMet_ues_plus_branch = the_tree.GetBranch("tMtToPfMet_ues_plus")
        #if not self.tMtToPfMet_ues_plus_branch and "tMtToPfMet_ues_plus" not in self.complained:
        if not self.tMtToPfMet_ues_plus_branch and "tMtToPfMet_ues_plus":
            warnings.warn( "ETauTree: Expected branch tMtToPfMet_ues_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ues_plus")
        else:
            self.tMtToPfMet_ues_plus_branch.SetAddress(<void*>&self.tMtToPfMet_ues_plus_value)

        #print "making tMuOverlap"
        self.tMuOverlap_branch = the_tree.GetBranch("tMuOverlap")
        #if not self.tMuOverlap_branch and "tMuOverlap" not in self.complained:
        if not self.tMuOverlap_branch and "tMuOverlap":
            warnings.warn( "ETauTree: Expected branch tMuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuOverlap")
        else:
            self.tMuOverlap_branch.SetAddress(<void*>&self.tMuOverlap_value)

        #print "making tMuonIdIsoStdVtxOverlap"
        self.tMuonIdIsoStdVtxOverlap_branch = the_tree.GetBranch("tMuonIdIsoStdVtxOverlap")
        #if not self.tMuonIdIsoStdVtxOverlap_branch and "tMuonIdIsoStdVtxOverlap" not in self.complained:
        if not self.tMuonIdIsoStdVtxOverlap_branch and "tMuonIdIsoStdVtxOverlap":
            warnings.warn( "ETauTree: Expected branch tMuonIdIsoStdVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuonIdIsoStdVtxOverlap")
        else:
            self.tMuonIdIsoStdVtxOverlap_branch.SetAddress(<void*>&self.tMuonIdIsoStdVtxOverlap_value)

        #print "making tMuonIdIsoVtxOverlap"
        self.tMuonIdIsoVtxOverlap_branch = the_tree.GetBranch("tMuonIdIsoVtxOverlap")
        #if not self.tMuonIdIsoVtxOverlap_branch and "tMuonIdIsoVtxOverlap" not in self.complained:
        if not self.tMuonIdIsoVtxOverlap_branch and "tMuonIdIsoVtxOverlap":
            warnings.warn( "ETauTree: Expected branch tMuonIdIsoVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuonIdIsoVtxOverlap")
        else:
            self.tMuonIdIsoVtxOverlap_branch.SetAddress(<void*>&self.tMuonIdIsoVtxOverlap_value)

        #print "making tMuonIdVtxOverlap"
        self.tMuonIdVtxOverlap_branch = the_tree.GetBranch("tMuonIdVtxOverlap")
        #if not self.tMuonIdVtxOverlap_branch and "tMuonIdVtxOverlap" not in self.complained:
        if not self.tMuonIdVtxOverlap_branch and "tMuonIdVtxOverlap":
            warnings.warn( "ETauTree: Expected branch tMuonIdVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuonIdVtxOverlap")
        else:
            self.tMuonIdVtxOverlap_branch.SetAddress(<void*>&self.tMuonIdVtxOverlap_value)

        #print "making tPhi"
        self.tPhi_branch = the_tree.GetBranch("tPhi")
        #if not self.tPhi_branch and "tPhi" not in self.complained:
        if not self.tPhi_branch and "tPhi":
            warnings.warn( "ETauTree: Expected branch tPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi")
        else:
            self.tPhi_branch.SetAddress(<void*>&self.tPhi_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "ETauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tPt_ees_minus"
        self.tPt_ees_minus_branch = the_tree.GetBranch("tPt_ees_minus")
        #if not self.tPt_ees_minus_branch and "tPt_ees_minus" not in self.complained:
        if not self.tPt_ees_minus_branch and "tPt_ees_minus":
            warnings.warn( "ETauTree: Expected branch tPt_ees_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt_ees_minus")
        else:
            self.tPt_ees_minus_branch.SetAddress(<void*>&self.tPt_ees_minus_value)

        #print "making tPt_ees_plus"
        self.tPt_ees_plus_branch = the_tree.GetBranch("tPt_ees_plus")
        #if not self.tPt_ees_plus_branch and "tPt_ees_plus" not in self.complained:
        if not self.tPt_ees_plus_branch and "tPt_ees_plus":
            warnings.warn( "ETauTree: Expected branch tPt_ees_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt_ees_plus")
        else:
            self.tPt_ees_plus_branch.SetAddress(<void*>&self.tPt_ees_plus_value)

        #print "making tPt_tes_minus"
        self.tPt_tes_minus_branch = the_tree.GetBranch("tPt_tes_minus")
        #if not self.tPt_tes_minus_branch and "tPt_tes_minus" not in self.complained:
        if not self.tPt_tes_minus_branch and "tPt_tes_minus":
            warnings.warn( "ETauTree: Expected branch tPt_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt_tes_minus")
        else:
            self.tPt_tes_minus_branch.SetAddress(<void*>&self.tPt_tes_minus_value)

        #print "making tPt_tes_plus"
        self.tPt_tes_plus_branch = the_tree.GetBranch("tPt_tes_plus")
        #if not self.tPt_tes_plus_branch and "tPt_tes_plus" not in self.complained:
        if not self.tPt_tes_plus_branch and "tPt_tes_plus":
            warnings.warn( "ETauTree: Expected branch tPt_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt_tes_plus")
        else:
            self.tPt_tes_plus_branch.SetAddress(<void*>&self.tPt_tes_plus_value)

        #print "making tRank"
        self.tRank_branch = the_tree.GetBranch("tRank")
        #if not self.tRank_branch and "tRank" not in self.complained:
        if not self.tRank_branch and "tRank":
            warnings.warn( "ETauTree: Expected branch tRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRank")
        else:
            self.tRank_branch.SetAddress(<void*>&self.tRank_value)

        #print "making tRawIso3Hits"
        self.tRawIso3Hits_branch = the_tree.GetBranch("tRawIso3Hits")
        #if not self.tRawIso3Hits_branch and "tRawIso3Hits" not in self.complained:
        if not self.tRawIso3Hits_branch and "tRawIso3Hits":
            warnings.warn( "ETauTree: Expected branch tRawIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRawIso3Hits")
        else:
            self.tRawIso3Hits_branch.SetAddress(<void*>&self.tRawIso3Hits_value)

        #print "making tTNPId"
        self.tTNPId_branch = the_tree.GetBranch("tTNPId")
        #if not self.tTNPId_branch and "tTNPId" not in self.complained:
        if not self.tTNPId_branch and "tTNPId":
            warnings.warn( "ETauTree: Expected branch tTNPId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTNPId")
        else:
            self.tTNPId_branch.SetAddress(<void*>&self.tTNPId_value)

        #print "making tTightIso"
        self.tTightIso_branch = the_tree.GetBranch("tTightIso")
        #if not self.tTightIso_branch and "tTightIso" not in self.complained:
        if not self.tTightIso_branch and "tTightIso":
            warnings.warn( "ETauTree: Expected branch tTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIso")
        else:
            self.tTightIso_branch.SetAddress(<void*>&self.tTightIso_value)

        #print "making tTightIso3Hits"
        self.tTightIso3Hits_branch = the_tree.GetBranch("tTightIso3Hits")
        #if not self.tTightIso3Hits_branch and "tTightIso3Hits" not in self.complained:
        if not self.tTightIso3Hits_branch and "tTightIso3Hits":
            warnings.warn( "ETauTree: Expected branch tTightIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIso3Hits")
        else:
            self.tTightIso3Hits_branch.SetAddress(<void*>&self.tTightIso3Hits_value)

        #print "making tTightIsoMVA3NewDMLT"
        self.tTightIsoMVA3NewDMLT_branch = the_tree.GetBranch("tTightIsoMVA3NewDMLT")
        #if not self.tTightIsoMVA3NewDMLT_branch and "tTightIsoMVA3NewDMLT" not in self.complained:
        if not self.tTightIsoMVA3NewDMLT_branch and "tTightIsoMVA3NewDMLT":
            warnings.warn( "ETauTree: Expected branch tTightIsoMVA3NewDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIsoMVA3NewDMLT")
        else:
            self.tTightIsoMVA3NewDMLT_branch.SetAddress(<void*>&self.tTightIsoMVA3NewDMLT_value)

        #print "making tTightIsoMVA3NewDMNoLT"
        self.tTightIsoMVA3NewDMNoLT_branch = the_tree.GetBranch("tTightIsoMVA3NewDMNoLT")
        #if not self.tTightIsoMVA3NewDMNoLT_branch and "tTightIsoMVA3NewDMNoLT" not in self.complained:
        if not self.tTightIsoMVA3NewDMNoLT_branch and "tTightIsoMVA3NewDMNoLT":
            warnings.warn( "ETauTree: Expected branch tTightIsoMVA3NewDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIsoMVA3NewDMNoLT")
        else:
            self.tTightIsoMVA3NewDMNoLT_branch.SetAddress(<void*>&self.tTightIsoMVA3NewDMNoLT_value)

        #print "making tTightIsoMVA3OldDMLT"
        self.tTightIsoMVA3OldDMLT_branch = the_tree.GetBranch("tTightIsoMVA3OldDMLT")
        #if not self.tTightIsoMVA3OldDMLT_branch and "tTightIsoMVA3OldDMLT" not in self.complained:
        if not self.tTightIsoMVA3OldDMLT_branch and "tTightIsoMVA3OldDMLT":
            warnings.warn( "ETauTree: Expected branch tTightIsoMVA3OldDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIsoMVA3OldDMLT")
        else:
            self.tTightIsoMVA3OldDMLT_branch.SetAddress(<void*>&self.tTightIsoMVA3OldDMLT_value)

        #print "making tTightIsoMVA3OldDMNoLT"
        self.tTightIsoMVA3OldDMNoLT_branch = the_tree.GetBranch("tTightIsoMVA3OldDMNoLT")
        #if not self.tTightIsoMVA3OldDMNoLT_branch and "tTightIsoMVA3OldDMNoLT" not in self.complained:
        if not self.tTightIsoMVA3OldDMNoLT_branch and "tTightIsoMVA3OldDMNoLT":
            warnings.warn( "ETauTree: Expected branch tTightIsoMVA3OldDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIsoMVA3OldDMNoLT")
        else:
            self.tTightIsoMVA3OldDMNoLT_branch.SetAddress(<void*>&self.tTightIsoMVA3OldDMNoLT_value)

        #print "making tToMETDPhi"
        self.tToMETDPhi_branch = the_tree.GetBranch("tToMETDPhi")
        #if not self.tToMETDPhi_branch and "tToMETDPhi" not in self.complained:
        if not self.tToMETDPhi_branch and "tToMETDPhi":
            warnings.warn( "ETauTree: Expected branch tToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tToMETDPhi")
        else:
            self.tToMETDPhi_branch.SetAddress(<void*>&self.tToMETDPhi_value)

        #print "making tVLooseIso"
        self.tVLooseIso_branch = the_tree.GetBranch("tVLooseIso")
        #if not self.tVLooseIso_branch and "tVLooseIso" not in self.complained:
        if not self.tVLooseIso_branch and "tVLooseIso":
            warnings.warn( "ETauTree: Expected branch tVLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIso")
        else:
            self.tVLooseIso_branch.SetAddress(<void*>&self.tVLooseIso_value)

        #print "making tVLooseIsoMVA3NewDMLT"
        self.tVLooseIsoMVA3NewDMLT_branch = the_tree.GetBranch("tVLooseIsoMVA3NewDMLT")
        #if not self.tVLooseIsoMVA3NewDMLT_branch and "tVLooseIsoMVA3NewDMLT" not in self.complained:
        if not self.tVLooseIsoMVA3NewDMLT_branch and "tVLooseIsoMVA3NewDMLT":
            warnings.warn( "ETauTree: Expected branch tVLooseIsoMVA3NewDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIsoMVA3NewDMLT")
        else:
            self.tVLooseIsoMVA3NewDMLT_branch.SetAddress(<void*>&self.tVLooseIsoMVA3NewDMLT_value)

        #print "making tVLooseIsoMVA3NewDMNoLT"
        self.tVLooseIsoMVA3NewDMNoLT_branch = the_tree.GetBranch("tVLooseIsoMVA3NewDMNoLT")
        #if not self.tVLooseIsoMVA3NewDMNoLT_branch and "tVLooseIsoMVA3NewDMNoLT" not in self.complained:
        if not self.tVLooseIsoMVA3NewDMNoLT_branch and "tVLooseIsoMVA3NewDMNoLT":
            warnings.warn( "ETauTree: Expected branch tVLooseIsoMVA3NewDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIsoMVA3NewDMNoLT")
        else:
            self.tVLooseIsoMVA3NewDMNoLT_branch.SetAddress(<void*>&self.tVLooseIsoMVA3NewDMNoLT_value)

        #print "making tVLooseIsoMVA3OldDMLT"
        self.tVLooseIsoMVA3OldDMLT_branch = the_tree.GetBranch("tVLooseIsoMVA3OldDMLT")
        #if not self.tVLooseIsoMVA3OldDMLT_branch and "tVLooseIsoMVA3OldDMLT" not in self.complained:
        if not self.tVLooseIsoMVA3OldDMLT_branch and "tVLooseIsoMVA3OldDMLT":
            warnings.warn( "ETauTree: Expected branch tVLooseIsoMVA3OldDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIsoMVA3OldDMLT")
        else:
            self.tVLooseIsoMVA3OldDMLT_branch.SetAddress(<void*>&self.tVLooseIsoMVA3OldDMLT_value)

        #print "making tVLooseIsoMVA3OldDMNoLT"
        self.tVLooseIsoMVA3OldDMNoLT_branch = the_tree.GetBranch("tVLooseIsoMVA3OldDMNoLT")
        #if not self.tVLooseIsoMVA3OldDMNoLT_branch and "tVLooseIsoMVA3OldDMNoLT" not in self.complained:
        if not self.tVLooseIsoMVA3OldDMNoLT_branch and "tVLooseIsoMVA3OldDMNoLT":
            warnings.warn( "ETauTree: Expected branch tVLooseIsoMVA3OldDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIsoMVA3OldDMNoLT")
        else:
            self.tVLooseIsoMVA3OldDMNoLT_branch.SetAddress(<void*>&self.tVLooseIsoMVA3OldDMNoLT_value)

        #print "making tVTightIsoMVA3NewDMLT"
        self.tVTightIsoMVA3NewDMLT_branch = the_tree.GetBranch("tVTightIsoMVA3NewDMLT")
        #if not self.tVTightIsoMVA3NewDMLT_branch and "tVTightIsoMVA3NewDMLT" not in self.complained:
        if not self.tVTightIsoMVA3NewDMLT_branch and "tVTightIsoMVA3NewDMLT":
            warnings.warn( "ETauTree: Expected branch tVTightIsoMVA3NewDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightIsoMVA3NewDMLT")
        else:
            self.tVTightIsoMVA3NewDMLT_branch.SetAddress(<void*>&self.tVTightIsoMVA3NewDMLT_value)

        #print "making tVTightIsoMVA3NewDMNoLT"
        self.tVTightIsoMVA3NewDMNoLT_branch = the_tree.GetBranch("tVTightIsoMVA3NewDMNoLT")
        #if not self.tVTightIsoMVA3NewDMNoLT_branch and "tVTightIsoMVA3NewDMNoLT" not in self.complained:
        if not self.tVTightIsoMVA3NewDMNoLT_branch and "tVTightIsoMVA3NewDMNoLT":
            warnings.warn( "ETauTree: Expected branch tVTightIsoMVA3NewDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightIsoMVA3NewDMNoLT")
        else:
            self.tVTightIsoMVA3NewDMNoLT_branch.SetAddress(<void*>&self.tVTightIsoMVA3NewDMNoLT_value)

        #print "making tVTightIsoMVA3OldDMLT"
        self.tVTightIsoMVA3OldDMLT_branch = the_tree.GetBranch("tVTightIsoMVA3OldDMLT")
        #if not self.tVTightIsoMVA3OldDMLT_branch and "tVTightIsoMVA3OldDMLT" not in self.complained:
        if not self.tVTightIsoMVA3OldDMLT_branch and "tVTightIsoMVA3OldDMLT":
            warnings.warn( "ETauTree: Expected branch tVTightIsoMVA3OldDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightIsoMVA3OldDMLT")
        else:
            self.tVTightIsoMVA3OldDMLT_branch.SetAddress(<void*>&self.tVTightIsoMVA3OldDMLT_value)

        #print "making tVTightIsoMVA3OldDMNoLT"
        self.tVTightIsoMVA3OldDMNoLT_branch = the_tree.GetBranch("tVTightIsoMVA3OldDMNoLT")
        #if not self.tVTightIsoMVA3OldDMNoLT_branch and "tVTightIsoMVA3OldDMNoLT" not in self.complained:
        if not self.tVTightIsoMVA3OldDMNoLT_branch and "tVTightIsoMVA3OldDMNoLT":
            warnings.warn( "ETauTree: Expected branch tVTightIsoMVA3OldDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightIsoMVA3OldDMNoLT")
        else:
            self.tVTightIsoMVA3OldDMNoLT_branch.SetAddress(<void*>&self.tVTightIsoMVA3OldDMNoLT_value)

        #print "making tVVTightIsoMVA3NewDMLT"
        self.tVVTightIsoMVA3NewDMLT_branch = the_tree.GetBranch("tVVTightIsoMVA3NewDMLT")
        #if not self.tVVTightIsoMVA3NewDMLT_branch and "tVVTightIsoMVA3NewDMLT" not in self.complained:
        if not self.tVVTightIsoMVA3NewDMLT_branch and "tVVTightIsoMVA3NewDMLT":
            warnings.warn( "ETauTree: Expected branch tVVTightIsoMVA3NewDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightIsoMVA3NewDMLT")
        else:
            self.tVVTightIsoMVA3NewDMLT_branch.SetAddress(<void*>&self.tVVTightIsoMVA3NewDMLT_value)

        #print "making tVVTightIsoMVA3NewDMNoLT"
        self.tVVTightIsoMVA3NewDMNoLT_branch = the_tree.GetBranch("tVVTightIsoMVA3NewDMNoLT")
        #if not self.tVVTightIsoMVA3NewDMNoLT_branch and "tVVTightIsoMVA3NewDMNoLT" not in self.complained:
        if not self.tVVTightIsoMVA3NewDMNoLT_branch and "tVVTightIsoMVA3NewDMNoLT":
            warnings.warn( "ETauTree: Expected branch tVVTightIsoMVA3NewDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightIsoMVA3NewDMNoLT")
        else:
            self.tVVTightIsoMVA3NewDMNoLT_branch.SetAddress(<void*>&self.tVVTightIsoMVA3NewDMNoLT_value)

        #print "making tVVTightIsoMVA3OldDMLT"
        self.tVVTightIsoMVA3OldDMLT_branch = the_tree.GetBranch("tVVTightIsoMVA3OldDMLT")
        #if not self.tVVTightIsoMVA3OldDMLT_branch and "tVVTightIsoMVA3OldDMLT" not in self.complained:
        if not self.tVVTightIsoMVA3OldDMLT_branch and "tVVTightIsoMVA3OldDMLT":
            warnings.warn( "ETauTree: Expected branch tVVTightIsoMVA3OldDMLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightIsoMVA3OldDMLT")
        else:
            self.tVVTightIsoMVA3OldDMLT_branch.SetAddress(<void*>&self.tVVTightIsoMVA3OldDMLT_value)

        #print "making tVVTightIsoMVA3OldDMNoLT"
        self.tVVTightIsoMVA3OldDMNoLT_branch = the_tree.GetBranch("tVVTightIsoMVA3OldDMNoLT")
        #if not self.tVVTightIsoMVA3OldDMNoLT_branch and "tVVTightIsoMVA3OldDMNoLT" not in self.complained:
        if not self.tVVTightIsoMVA3OldDMNoLT_branch and "tVVTightIsoMVA3OldDMNoLT":
            warnings.warn( "ETauTree: Expected branch tVVTightIsoMVA3OldDMNoLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightIsoMVA3OldDMNoLT")
        else:
            self.tVVTightIsoMVA3OldDMNoLT_branch.SetAddress(<void*>&self.tVVTightIsoMVA3OldDMNoLT_value)

        #print "making tVZ"
        self.tVZ_branch = the_tree.GetBranch("tVZ")
        #if not self.tVZ_branch and "tVZ" not in self.complained:
        if not self.tVZ_branch and "tVZ":
            warnings.warn( "ETauTree: Expected branch tVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVZ")
        else:
            self.tVZ_branch.SetAddress(<void*>&self.tVZ_value)

        #print "making tauVetoPt20EleLoose3MuTight"
        self.tauVetoPt20EleLoose3MuTight_branch = the_tree.GetBranch("tauVetoPt20EleLoose3MuTight")
        #if not self.tauVetoPt20EleLoose3MuTight_branch and "tauVetoPt20EleLoose3MuTight" not in self.complained:
        if not self.tauVetoPt20EleLoose3MuTight_branch and "tauVetoPt20EleLoose3MuTight":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20EleLoose3MuTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20EleLoose3MuTight")
        else:
            self.tauVetoPt20EleLoose3MuTight_branch.SetAddress(<void*>&self.tauVetoPt20EleLoose3MuTight_value)

        #print "making tauVetoPt20EleLoose3MuTight_tes_minus"
        self.tauVetoPt20EleLoose3MuTight_tes_minus_branch = the_tree.GetBranch("tauVetoPt20EleLoose3MuTight_tes_minus")
        #if not self.tauVetoPt20EleLoose3MuTight_tes_minus_branch and "tauVetoPt20EleLoose3MuTight_tes_minus" not in self.complained:
        if not self.tauVetoPt20EleLoose3MuTight_tes_minus_branch and "tauVetoPt20EleLoose3MuTight_tes_minus":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20EleLoose3MuTight_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20EleLoose3MuTight_tes_minus")
        else:
            self.tauVetoPt20EleLoose3MuTight_tes_minus_branch.SetAddress(<void*>&self.tauVetoPt20EleLoose3MuTight_tes_minus_value)

        #print "making tauVetoPt20EleLoose3MuTight_tes_plus"
        self.tauVetoPt20EleLoose3MuTight_tes_plus_branch = the_tree.GetBranch("tauVetoPt20EleLoose3MuTight_tes_plus")
        #if not self.tauVetoPt20EleLoose3MuTight_tes_plus_branch and "tauVetoPt20EleLoose3MuTight_tes_plus" not in self.complained:
        if not self.tauVetoPt20EleLoose3MuTight_tes_plus_branch and "tauVetoPt20EleLoose3MuTight_tes_plus":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20EleLoose3MuTight_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20EleLoose3MuTight_tes_plus")
        else:
            self.tauVetoPt20EleLoose3MuTight_tes_plus_branch.SetAddress(<void*>&self.tauVetoPt20EleLoose3MuTight_tes_plus_value)

        #print "making tauVetoPt20EleTight3MuLoose"
        self.tauVetoPt20EleTight3MuLoose_branch = the_tree.GetBranch("tauVetoPt20EleTight3MuLoose")
        #if not self.tauVetoPt20EleTight3MuLoose_branch and "tauVetoPt20EleTight3MuLoose" not in self.complained:
        if not self.tauVetoPt20EleTight3MuLoose_branch and "tauVetoPt20EleTight3MuLoose":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20EleTight3MuLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20EleTight3MuLoose")
        else:
            self.tauVetoPt20EleTight3MuLoose_branch.SetAddress(<void*>&self.tauVetoPt20EleTight3MuLoose_value)

        #print "making tauVetoPt20EleTight3MuLoose_tes_minus"
        self.tauVetoPt20EleTight3MuLoose_tes_minus_branch = the_tree.GetBranch("tauVetoPt20EleTight3MuLoose_tes_minus")
        #if not self.tauVetoPt20EleTight3MuLoose_tes_minus_branch and "tauVetoPt20EleTight3MuLoose_tes_minus" not in self.complained:
        if not self.tauVetoPt20EleTight3MuLoose_tes_minus_branch and "tauVetoPt20EleTight3MuLoose_tes_minus":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20EleTight3MuLoose_tes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20EleTight3MuLoose_tes_minus")
        else:
            self.tauVetoPt20EleTight3MuLoose_tes_minus_branch.SetAddress(<void*>&self.tauVetoPt20EleTight3MuLoose_tes_minus_value)

        #print "making tauVetoPt20EleTight3MuLoose_tes_plus"
        self.tauVetoPt20EleTight3MuLoose_tes_plus_branch = the_tree.GetBranch("tauVetoPt20EleTight3MuLoose_tes_plus")
        #if not self.tauVetoPt20EleTight3MuLoose_tes_plus_branch and "tauVetoPt20EleTight3MuLoose_tes_plus" not in self.complained:
        if not self.tauVetoPt20EleTight3MuLoose_tes_plus_branch and "tauVetoPt20EleTight3MuLoose_tes_plus":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20EleTight3MuLoose_tes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20EleTight3MuLoose_tes_plus")
        else:
            self.tauVetoPt20EleTight3MuLoose_tes_plus_branch.SetAddress(<void*>&self.tauVetoPt20EleTight3MuLoose_tes_plus_value)

        #print "making tauVetoPt20Loose3HitsNewDMVtx"
        self.tauVetoPt20Loose3HitsNewDMVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsNewDMVtx")
        #if not self.tauVetoPt20Loose3HitsNewDMVtx_branch and "tauVetoPt20Loose3HitsNewDMVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsNewDMVtx_branch and "tauVetoPt20Loose3HitsNewDMVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20Loose3HitsNewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsNewDMVtx")
        else:
            self.tauVetoPt20Loose3HitsNewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsNewDMVtx_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20TightMVALTNewDMVtx"
        self.tauVetoPt20TightMVALTNewDMVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTNewDMVtx")
        #if not self.tauVetoPt20TightMVALTNewDMVtx_branch and "tauVetoPt20TightMVALTNewDMVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTNewDMVtx_branch and "tauVetoPt20TightMVALTNewDMVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20TightMVALTNewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTNewDMVtx")
        else:
            self.tauVetoPt20TightMVALTNewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTNewDMVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making tauVetoPt20TightMVANewDMVtx"
        self.tauVetoPt20TightMVANewDMVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVANewDMVtx")
        #if not self.tauVetoPt20TightMVANewDMVtx_branch and "tauVetoPt20TightMVANewDMVtx" not in self.complained:
        if not self.tauVetoPt20TightMVANewDMVtx_branch and "tauVetoPt20TightMVANewDMVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20TightMVANewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVANewDMVtx")
        else:
            self.tauVetoPt20TightMVANewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVANewDMVtx_value)

        #print "making tauVetoPt20TightMVAVtx"
        self.tauVetoPt20TightMVAVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVAVtx")
        #if not self.tauVetoPt20TightMVAVtx_branch and "tauVetoPt20TightMVAVtx" not in self.complained:
        if not self.tauVetoPt20TightMVAVtx_branch and "tauVetoPt20TightMVAVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20TightMVAVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVAVtx")
        else:
            self.tauVetoPt20TightMVAVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVAVtx_value)

        #print "making tauVetoPt20VLooseHPSNewDMVtx"
        self.tauVetoPt20VLooseHPSNewDMVtx_branch = the_tree.GetBranch("tauVetoPt20VLooseHPSNewDMVtx")
        #if not self.tauVetoPt20VLooseHPSNewDMVtx_branch and "tauVetoPt20VLooseHPSNewDMVtx" not in self.complained:
        if not self.tauVetoPt20VLooseHPSNewDMVtx_branch and "tauVetoPt20VLooseHPSNewDMVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20VLooseHPSNewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20VLooseHPSNewDMVtx")
        else:
            self.tauVetoPt20VLooseHPSNewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20VLooseHPSNewDMVtx_value)

        #print "making tauVetoPt20VLooseHPSVtx"
        self.tauVetoPt20VLooseHPSVtx_branch = the_tree.GetBranch("tauVetoPt20VLooseHPSVtx")
        #if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx" not in self.complained:
        if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20VLooseHPSVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20VLooseHPSVtx")
        else:
            self.tauVetoPt20VLooseHPSVtx_branch.SetAddress(<void*>&self.tauVetoPt20VLooseHPSVtx_value)

        #print "making tripleEGroup"
        self.tripleEGroup_branch = the_tree.GetBranch("tripleEGroup")
        #if not self.tripleEGroup_branch and "tripleEGroup" not in self.complained:
        if not self.tripleEGroup_branch and "tripleEGroup":
            warnings.warn( "ETauTree: Expected branch tripleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEGroup")
        else:
            self.tripleEGroup_branch.SetAddress(<void*>&self.tripleEGroup_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "ETauTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleEPrescale"
        self.tripleEPrescale_branch = the_tree.GetBranch("tripleEPrescale")
        #if not self.tripleEPrescale_branch and "tripleEPrescale" not in self.complained:
        if not self.tripleEPrescale_branch and "tripleEPrescale":
            warnings.warn( "ETauTree: Expected branch tripleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPrescale")
        else:
            self.tripleEPrescale_branch.SetAddress(<void*>&self.tripleEPrescale_value)

        #print "making type1_pfMet_Et"
        self.type1_pfMet_Et_branch = the_tree.GetBranch("type1_pfMet_Et")
        #if not self.type1_pfMet_Et_branch and "type1_pfMet_Et" not in self.complained:
        if not self.type1_pfMet_Et_branch and "type1_pfMet_Et":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_Et")
        else:
            self.type1_pfMet_Et_branch.SetAddress(<void*>&self.type1_pfMet_Et_value)

        #print "making type1_pfMet_Et_ues_minus"
        self.type1_pfMet_Et_ues_minus_branch = the_tree.GetBranch("type1_pfMet_Et_ues_minus")
        #if not self.type1_pfMet_Et_ues_minus_branch and "type1_pfMet_Et_ues_minus" not in self.complained:
        if not self.type1_pfMet_Et_ues_minus_branch and "type1_pfMet_Et_ues_minus":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_Et_ues_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_Et_ues_minus")
        else:
            self.type1_pfMet_Et_ues_minus_branch.SetAddress(<void*>&self.type1_pfMet_Et_ues_minus_value)

        #print "making type1_pfMet_Et_ues_plus"
        self.type1_pfMet_Et_ues_plus_branch = the_tree.GetBranch("type1_pfMet_Et_ues_plus")
        #if not self.type1_pfMet_Et_ues_plus_branch and "type1_pfMet_Et_ues_plus" not in self.complained:
        if not self.type1_pfMet_Et_ues_plus_branch and "type1_pfMet_Et_ues_plus":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_Et_ues_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_Et_ues_plus")
        else:
            self.type1_pfMet_Et_ues_plus_branch.SetAddress(<void*>&self.type1_pfMet_Et_ues_plus_value)

        #print "making type1_pfMet_Phi"
        self.type1_pfMet_Phi_branch = the_tree.GetBranch("type1_pfMet_Phi")
        #if not self.type1_pfMet_Phi_branch and "type1_pfMet_Phi" not in self.complained:
        if not self.type1_pfMet_Phi_branch and "type1_pfMet_Phi":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_Phi")
        else:
            self.type1_pfMet_Phi_branch.SetAddress(<void*>&self.type1_pfMet_Phi_value)

        #print "making type1_pfMet_Pt"
        self.type1_pfMet_Pt_branch = the_tree.GetBranch("type1_pfMet_Pt")
        #if not self.type1_pfMet_Pt_branch and "type1_pfMet_Pt" not in self.complained:
        if not self.type1_pfMet_Pt_branch and "type1_pfMet_Pt":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_Pt")
        else:
            self.type1_pfMet_Pt_branch.SetAddress(<void*>&self.type1_pfMet_Pt_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "ETauTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)


        #print "making vbfDeta"
        self.tMtToPFMET_branch = the_tree.GetBranch("tMtToPFMET")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.tMtToPFMET_branch and "tMtToPFMET":
            warnings.warn( "ETauTree: Expected branch tMtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.tMtToPFMET_branch.SetAddress(<void*>&self.tMtToPFMET_value)





        #print "making vbfDijetrap"
        self.vbfDijetrap_branch = the_tree.GetBranch("vbfDijetrap")
        #if not self.vbfDijetrap_branch and "vbfDijetrap" not in self.complained:
        if not self.vbfDijetrap_branch and "vbfDijetrap":
            warnings.warn( "ETauTree: Expected branch vbfDijetrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap")
        else:
            self.vbfDijetrap_branch.SetAddress(<void*>&self.vbfDijetrap_value)

        #print "making vbfDphi"
        self.vbfDphi_branch = the_tree.GetBranch("vbfDphi")
        #if not self.vbfDphi_branch and "vbfDphi" not in self.complained:
        if not self.vbfDphi_branch and "vbfDphi":
            warnings.warn( "ETauTree: Expected branch vbfDphi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi")
        else:
            self.vbfDphi_branch.SetAddress(<void*>&self.vbfDphi_value)

        #print "making vbfDphihj"
        self.vbfDphihj_branch = the_tree.GetBranch("vbfDphihj")
        #if not self.vbfDphihj_branch and "vbfDphihj" not in self.complained:
        if not self.vbfDphihj_branch and "vbfDphihj":
            warnings.warn( "ETauTree: Expected branch vbfDphihj does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj")
        else:
            self.vbfDphihj_branch.SetAddress(<void*>&self.vbfDphihj_value)

        #print "making vbfDphihjnomet"
        self.vbfDphihjnomet_branch = the_tree.GetBranch("vbfDphihjnomet")
        #if not self.vbfDphihjnomet_branch and "vbfDphihjnomet" not in self.complained:
        if not self.vbfDphihjnomet_branch and "vbfDphihjnomet":
            warnings.warn( "ETauTree: Expected branch vbfDphihjnomet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet")
        else:
            self.vbfDphihjnomet_branch.SetAddress(<void*>&self.vbfDphihjnomet_value)

        #print "making vbfHrap"
        self.vbfHrap_branch = the_tree.GetBranch("vbfHrap")
        #if not self.vbfHrap_branch and "vbfHrap" not in self.complained:
        if not self.vbfHrap_branch and "vbfHrap":
            warnings.warn( "ETauTree: Expected branch vbfHrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap")
        else:
            self.vbfHrap_branch.SetAddress(<void*>&self.vbfHrap_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "ETauTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "ETauTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfJetVetoTight20"
        self.vbfJetVetoTight20_branch = the_tree.GetBranch("vbfJetVetoTight20")
        #if not self.vbfJetVetoTight20_branch and "vbfJetVetoTight20" not in self.complained:
        if not self.vbfJetVetoTight20_branch and "vbfJetVetoTight20":
            warnings.warn( "ETauTree: Expected branch vbfJetVetoTight20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVetoTight20")
        else:
            self.vbfJetVetoTight20_branch.SetAddress(<void*>&self.vbfJetVetoTight20_value)

        #print "making vbfJetVetoTight30"
        self.vbfJetVetoTight30_branch = the_tree.GetBranch("vbfJetVetoTight30")
        #if not self.vbfJetVetoTight30_branch and "vbfJetVetoTight30" not in self.complained:
        if not self.vbfJetVetoTight30_branch and "vbfJetVetoTight30":
            warnings.warn( "ETauTree: Expected branch vbfJetVetoTight30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVetoTight30")
        else:
            self.vbfJetVetoTight30_branch.SetAddress(<void*>&self.vbfJetVetoTight30_value)

        #print "making vbfMVA"
        self.vbfMVA_branch = the_tree.GetBranch("vbfMVA")
        #if not self.vbfMVA_branch and "vbfMVA" not in self.complained:
        if not self.vbfMVA_branch and "vbfMVA":
            warnings.warn( "ETauTree: Expected branch vbfMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA")
        else:
            self.vbfMVA_branch.SetAddress(<void*>&self.vbfMVA_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "ETauTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMass_jes_minus"
        self.vbfMass_jes_minus_branch = the_tree.GetBranch("vbfMass_jes_minus")
        #if not self.vbfMass_jes_minus_branch and "vbfMass_jes_minus" not in self.complained:
        if not self.vbfMass_jes_minus_branch and "vbfMass_jes_minus":
            warnings.warn( "ETauTree: Expected branch vbfMass_jes_minus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_jes_minus")
        else:
            self.vbfMass_jes_minus_branch.SetAddress(<void*>&self.vbfMass_jes_minus_value)

        #print "making vbfMass_jes_plus"
        self.vbfMass_jes_plus_branch = the_tree.GetBranch("vbfMass_jes_plus")
        #if not self.vbfMass_jes_plus_branch and "vbfMass_jes_plus" not in self.complained:
        if not self.vbfMass_jes_plus_branch and "vbfMass_jes_plus":
            warnings.warn( "ETauTree: Expected branch vbfMass_jes_plus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_jes_plus")
        else:
            self.vbfMass_jes_plus_branch.SetAddress(<void*>&self.vbfMass_jes_plus_value)

        #print "making vbfNJets"
        self.vbfNJets_branch = the_tree.GetBranch("vbfNJets")
        #if not self.vbfNJets_branch and "vbfNJets" not in self.complained:
        if not self.vbfNJets_branch and "vbfNJets":
            warnings.warn( "ETauTree: Expected branch vbfNJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets")
        else:
            self.vbfNJets_branch.SetAddress(<void*>&self.vbfNJets_value)

        #print "making vbfVispt"
        self.vbfVispt_branch = the_tree.GetBranch("vbfVispt")
        #if not self.vbfVispt_branch and "vbfVispt" not in self.complained:
        if not self.vbfVispt_branch and "vbfVispt":
            warnings.warn( "ETauTree: Expected branch vbfVispt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt")
        else:
            self.vbfVispt_branch.SetAddress(<void*>&self.vbfVispt_value)

        #print "making vbfdijetpt"
        self.vbfdijetpt_branch = the_tree.GetBranch("vbfdijetpt")
        #if not self.vbfdijetpt_branch and "vbfdijetpt" not in self.complained:
        if not self.vbfdijetpt_branch and "vbfdijetpt":
            warnings.warn( "ETauTree: Expected branch vbfdijetpt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt")
        else:
            self.vbfdijetpt_branch.SetAddress(<void*>&self.vbfdijetpt_value)

        #print "making vbfditaupt"
        self.vbfditaupt_branch = the_tree.GetBranch("vbfditaupt")
        #if not self.vbfditaupt_branch and "vbfditaupt" not in self.complained:
        if not self.vbfditaupt_branch and "vbfditaupt":
            warnings.warn( "ETauTree: Expected branch vbfditaupt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfditaupt")
        else:
            self.vbfditaupt_branch.SetAddress(<void*>&self.vbfditaupt_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "ETauTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "ETauTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "ETauTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "ETauTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "ETauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property eAbsEta:
        def __get__(self):
            self.eAbsEta_branch.GetEntry(self.localentry, 0)
            return self.eAbsEta_value

    property eCBID_LOOSE:
        def __get__(self):
            self.eCBID_LOOSE_branch.GetEntry(self.localentry, 0)
            return self.eCBID_LOOSE_value

    property eCBID_MEDIUM:
        def __get__(self):
            self.eCBID_MEDIUM_branch.GetEntry(self.localentry, 0)
            return self.eCBID_MEDIUM_value

    property eCBID_TIGHT:
        def __get__(self):
            self.eCBID_TIGHT_branch.GetEntry(self.localentry, 0)
            return self.eCBID_TIGHT_value

    property eCBID_VETO:
        def __get__(self):
            self.eCBID_VETO_branch.GetEntry(self.localentry, 0)
            return self.eCBID_VETO_value

    property eCharge:
        def __get__(self):
            self.eCharge_branch.GetEntry(self.localentry, 0)
            return self.eCharge_value

    property eChargeIdLoose:
        def __get__(self):
            self.eChargeIdLoose_branch.GetEntry(self.localentry, 0)
            return self.eChargeIdLoose_value

    property eChargeIdMed:
        def __get__(self):
            self.eChargeIdMed_branch.GetEntry(self.localentry, 0)
            return self.eChargeIdMed_value

    property eChargeIdTight:
        def __get__(self):
            self.eChargeIdTight_branch.GetEntry(self.localentry, 0)
            return self.eChargeIdTight_value

    property eCiCTight:
        def __get__(self):
            self.eCiCTight_branch.GetEntry(self.localentry, 0)
            return self.eCiCTight_value

    property eComesFromHiggs:
        def __get__(self):
            self.eComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.eComesFromHiggs_value

    property eDZ:
        def __get__(self):
            self.eDZ_branch.GetEntry(self.localentry, 0)
            return self.eDZ_value

    property eE1x5:
        def __get__(self):
            self.eE1x5_branch.GetEntry(self.localentry, 0)
            return self.eE1x5_value

    property eE2x5Max:
        def __get__(self):
            self.eE2x5Max_branch.GetEntry(self.localentry, 0)
            return self.eE2x5Max_value

    property eE5x5:
        def __get__(self):
            self.eE5x5_branch.GetEntry(self.localentry, 0)
            return self.eE5x5_value

    property eECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.eECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.eECorrReg_2012Jul13ReReco_value

    property eECorrReg_Fall11:
        def __get__(self):
            self.eECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.eECorrReg_Fall11_value

    property eECorrReg_Jan16ReReco:
        def __get__(self):
            self.eECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.eECorrReg_Jan16ReReco_value

    property eECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.eECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.eECorrReg_Summer12_DR53X_HCP2012_value

    property eECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.eECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedNoReg_2012Jul13ReReco_value

    property eECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.eECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedNoReg_Fall11_value

    property eECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.eECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedNoReg_Jan16ReReco_value

    property eECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property eECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.eECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedReg_2012Jul13ReReco_value

    property eECorrSmearedReg_Fall11:
        def __get__(self):
            self.eECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedReg_Fall11_value

    property eECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.eECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedReg_Jan16ReReco_value

    property eECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property eEcalIsoDR03:
        def __get__(self):
            self.eEcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eEcalIsoDR03_value

    property eEffectiveArea2011Data:
        def __get__(self):
            self.eEffectiveArea2011Data_branch.GetEntry(self.localentry, 0)
            return self.eEffectiveArea2011Data_value

    property eEffectiveArea2012Data:
        def __get__(self):
            self.eEffectiveArea2012Data_branch.GetEntry(self.localentry, 0)
            return self.eEffectiveArea2012Data_value

    property eEffectiveAreaFall11MC:
        def __get__(self):
            self.eEffectiveAreaFall11MC_branch.GetEntry(self.localentry, 0)
            return self.eEffectiveAreaFall11MC_value

    property eEle27WP80PFMT50PFMTFilter:
        def __get__(self):
            self.eEle27WP80PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.eEle27WP80PFMT50PFMTFilter_value

    property eEle27WP80TrackIsoMatchFilter:
        def __get__(self):
            self.eEle27WP80TrackIsoMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.eEle27WP80TrackIsoMatchFilter_value

    property eEle32WP70PFMT50PFMTFilter:
        def __get__(self):
            self.eEle32WP70PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.eEle32WP70PFMT50PFMTFilter_value

    property eEnergyError:
        def __get__(self):
            self.eEnergyError_branch.GetEntry(self.localentry, 0)
            return self.eEnergyError_value

    property eEta:
        def __get__(self):
            self.eEta_branch.GetEntry(self.localentry, 0)
            return self.eEta_value

    property eEtaCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.eEtaCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrReg_2012Jul13ReReco_value

    property eEtaCorrReg_Fall11:
        def __get__(self):
            self.eEtaCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrReg_Fall11_value

    property eEtaCorrReg_Jan16ReReco:
        def __get__(self):
            self.eEtaCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrReg_Jan16ReReco_value

    property eEtaCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrReg_Summer12_DR53X_HCP2012_value

    property eEtaCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedNoReg_2012Jul13ReReco_value

    property eEtaCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.eEtaCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedNoReg_Fall11_value

    property eEtaCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.eEtaCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedNoReg_Jan16ReReco_value

    property eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property eEtaCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.eEtaCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedReg_2012Jul13ReReco_value

    property eEtaCorrSmearedReg_Fall11:
        def __get__(self):
            self.eEtaCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedReg_Fall11_value

    property eEtaCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.eEtaCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedReg_Jan16ReReco_value

    property eEtaCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property eGenCharge:
        def __get__(self):
            self.eGenCharge_branch.GetEntry(self.localentry, 0)
            return self.eGenCharge_value

    property eGenEnergy:
        def __get__(self):
            self.eGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.eGenEnergy_value

    property eGenEta:
        def __get__(self):
            self.eGenEta_branch.GetEntry(self.localentry, 0)
            return self.eGenEta_value

    property eGenMotherPdgId:
        def __get__(self):
            self.eGenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.eGenMotherPdgId_value

    property eGenPdgId:
        def __get__(self):
            self.eGenPdgId_branch.GetEntry(self.localentry, 0)
            return self.eGenPdgId_value

    property eGenPhi:
        def __get__(self):
            self.eGenPhi_branch.GetEntry(self.localentry, 0)
            return self.eGenPhi_value

    property eHadronicDepth1OverEm:
        def __get__(self):
            self.eHadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.eHadronicDepth1OverEm_value

    property eHadronicDepth2OverEm:
        def __get__(self):
            self.eHadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.eHadronicDepth2OverEm_value

    property eHadronicOverEM:
        def __get__(self):
            self.eHadronicOverEM_branch.GetEntry(self.localentry, 0)
            return self.eHadronicOverEM_value

    property eHasConversion:
        def __get__(self):
            self.eHasConversion_branch.GetEntry(self.localentry, 0)
            return self.eHasConversion_value

    property eHasMatchedConversion:
        def __get__(self):
            self.eHasMatchedConversion_branch.GetEntry(self.localentry, 0)
            return self.eHasMatchedConversion_value

    property eHcalIsoDR03:
        def __get__(self):
            self.eHcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eHcalIsoDR03_value

    property eIP3DS:
        def __get__(self):
            self.eIP3DS_branch.GetEntry(self.localentry, 0)
            return self.eIP3DS_value

    property eJetArea:
        def __get__(self):
            self.eJetArea_branch.GetEntry(self.localentry, 0)
            return self.eJetArea_value

    property eJetBtag:
        def __get__(self):
            self.eJetBtag_branch.GetEntry(self.localentry, 0)
            return self.eJetBtag_value

    property eJetCSVBtag:
        def __get__(self):
            self.eJetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.eJetCSVBtag_value

    property eJetEtaEtaMoment:
        def __get__(self):
            self.eJetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.eJetEtaEtaMoment_value

    property eJetEtaPhiMoment:
        def __get__(self):
            self.eJetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.eJetEtaPhiMoment_value

    property eJetEtaPhiSpread:
        def __get__(self):
            self.eJetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.eJetEtaPhiSpread_value

    property eJetPhiPhiMoment:
        def __get__(self):
            self.eJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.eJetPhiPhiMoment_value

    property eJetPt:
        def __get__(self):
            self.eJetPt_branch.GetEntry(self.localentry, 0)
            return self.eJetPt_value

    property eJetQGLikelihoodID:
        def __get__(self):
            self.eJetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.eJetQGLikelihoodID_value

    property eJetQGMVAID:
        def __get__(self):
            self.eJetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.eJetQGMVAID_value

    property eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter:
        def __get__(self):
            self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    property eMITID:
        def __get__(self):
            self.eMITID_branch.GetEntry(self.localentry, 0)
            return self.eMITID_value

    property eMVAIDH2TauWP:
        def __get__(self):
            self.eMVAIDH2TauWP_branch.GetEntry(self.localentry, 0)
            return self.eMVAIDH2TauWP_value

    property eMVANonTrig:
        def __get__(self):
            self.eMVANonTrig_branch.GetEntry(self.localentry, 0)
            return self.eMVANonTrig_value

    property eMVATrig:
        def __get__(self):
            self.eMVATrig_branch.GetEntry(self.localentry, 0)
            return self.eMVATrig_value

    property eMVATrigIDISO:
        def __get__(self):
            self.eMVATrigIDISO_branch.GetEntry(self.localentry, 0)
            return self.eMVATrigIDISO_value

    property eMVATrigIDISOPUSUB:
        def __get__(self):
            self.eMVATrigIDISOPUSUB_branch.GetEntry(self.localentry, 0)
            return self.eMVATrigIDISOPUSUB_value

    property eMVATrigNoIP:
        def __get__(self):
            self.eMVATrigNoIP_branch.GetEntry(self.localentry, 0)
            return self.eMVATrigNoIP_value

    property eMass:
        def __get__(self):
            self.eMass_branch.GetEntry(self.localentry, 0)
            return self.eMass_value

    property eMatchesDoubleEPath:
        def __get__(self):
            self.eMatchesDoubleEPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesDoubleEPath_value

    property eMatchesMu17Ele8IsoPath:
        def __get__(self):
            self.eMatchesMu17Ele8IsoPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu17Ele8IsoPath_value

    property eMatchesMu17Ele8Path:
        def __get__(self):
            self.eMatchesMu17Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu17Ele8Path_value

    property eMatchesMu8Ele17IsoPath:
        def __get__(self):
            self.eMatchesMu8Ele17IsoPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8Ele17IsoPath_value

    property eMatchesMu8Ele17Path:
        def __get__(self):
            self.eMatchesMu8Ele17Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8Ele17Path_value

    property eMatchesSingleE:
        def __get__(self):
            self.eMatchesSingleE_branch.GetEntry(self.localentry, 0)
            return self.eMatchesSingleE_value

    property eMatchesSingleE27WP80:
        def __get__(self):
            self.eMatchesSingleE27WP80_branch.GetEntry(self.localentry, 0)
            return self.eMatchesSingleE27WP80_value

    property eMatchesSingleEPlusMET:
        def __get__(self):
            self.eMatchesSingleEPlusMET_branch.GetEntry(self.localentry, 0)
            return self.eMatchesSingleEPlusMET_value

    property eMissingHits:
        def __get__(self):
            self.eMissingHits_branch.GetEntry(self.localentry, 0)
            return self.eMissingHits_value

    property eMtToMET:
        def __get__(self):
            self.eMtToMET_branch.GetEntry(self.localentry, 0)
            return self.eMtToMET_value

    property eMtToMVAMET:
        def __get__(self):
            self.eMtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.eMtToMVAMET_value

    property eMtToPfMet:
        def __get__(self):
            self.eMtToPfMet_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_value

    property eMtToPfMet_Ty1:
        def __get__(self):
            self.eMtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_Ty1_value

    property eMtToPfMet_ees:
        def __get__(self):
            self.eMtToPfMet_ees_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_ees_value

    property eMtToPfMet_ees_minus:
        def __get__(self):
            self.eMtToPfMet_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_ees_minus_value

    property eMtToPfMet_ees_plus:
        def __get__(self):
            self.eMtToPfMet_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_ees_plus_value

    property eMtToPfMet_jes:
        def __get__(self):
            self.eMtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_jes_value

    property eMtToPfMet_jes_minus:
        def __get__(self):
            self.eMtToPfMet_jes_minus_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_jes_minus_value

    property eMtToPfMet_jes_plus:
        def __get__(self):
            self.eMtToPfMet_jes_plus_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_jes_plus_value

    property eMtToPfMet_mes:
        def __get__(self):
            self.eMtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_mes_value

    property eMtToPfMet_mes_minus:
        def __get__(self):
            self.eMtToPfMet_mes_minus_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_mes_minus_value

    property eMtToPfMet_mes_plus:
        def __get__(self):
            self.eMtToPfMet_mes_plus_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_mes_plus_value

    property eMtToPfMet_tes:
        def __get__(self):
            self.eMtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_tes_value

    property eMtToPfMet_tes_minus:
        def __get__(self):
            self.eMtToPfMet_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_tes_minus_value

    property eMtToPfMet_tes_plus:
        def __get__(self):
            self.eMtToPfMet_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_tes_plus_value

    property eMtToPfMet_ues:
        def __get__(self):
            self.eMtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_ues_value

    property eMtToPfMet_ues_minus:
        def __get__(self):
            self.eMtToPfMet_ues_minus_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_ues_minus_value

    property eMtToPfMet_ues_plus:
        def __get__(self):
            self.eMtToPfMet_ues_plus_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_ues_plus_value

    property eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter:
        def __get__(self):
            self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.GetEntry(self.localentry, 0)
            return self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    property eMu17Ele8CaloIdTPixelMatchFilter:
        def __get__(self):
            self.eMu17Ele8CaloIdTPixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.eMu17Ele8CaloIdTPixelMatchFilter_value

    property eMu17Ele8dZFilter:
        def __get__(self):
            self.eMu17Ele8dZFilter_branch.GetEntry(self.localentry, 0)
            return self.eMu17Ele8dZFilter_value

    property eNearMuonVeto:
        def __get__(self):
            self.eNearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.eNearMuonVeto_value

    property ePFChargedIso:
        def __get__(self):
            self.ePFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.ePFChargedIso_value

    property ePFNeutralIso:
        def __get__(self):
            self.ePFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.ePFNeutralIso_value

    property ePFPhotonIso:
        def __get__(self):
            self.ePFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.ePFPhotonIso_value

    property ePVDXY:
        def __get__(self):
            self.ePVDXY_branch.GetEntry(self.localentry, 0)
            return self.ePVDXY_value

    property ePVDZ:
        def __get__(self):
            self.ePVDZ_branch.GetEntry(self.localentry, 0)
            return self.ePVDZ_value

    property ePhi:
        def __get__(self):
            self.ePhi_branch.GetEntry(self.localentry, 0)
            return self.ePhi_value

    property ePhiCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.ePhiCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrReg_2012Jul13ReReco_value

    property ePhiCorrReg_Fall11:
        def __get__(self):
            self.ePhiCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrReg_Fall11_value

    property ePhiCorrReg_Jan16ReReco:
        def __get__(self):
            self.ePhiCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrReg_Jan16ReReco_value

    property ePhiCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrReg_Summer12_DR53X_HCP2012_value

    property ePhiCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedNoReg_2012Jul13ReReco_value

    property ePhiCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.ePhiCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedNoReg_Fall11_value

    property ePhiCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.ePhiCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedNoReg_Jan16ReReco_value

    property ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property ePhiCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.ePhiCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedReg_2012Jul13ReReco_value

    property ePhiCorrSmearedReg_Fall11:
        def __get__(self):
            self.ePhiCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedReg_Fall11_value

    property ePhiCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.ePhiCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedReg_Jan16ReReco_value

    property ePhiCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property ePt:
        def __get__(self):
            self.ePt_branch.GetEntry(self.localentry, 0)
            return self.ePt_value

    property ePtCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.ePtCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrReg_2012Jul13ReReco_value

    property ePtCorrReg_Fall11:
        def __get__(self):
            self.ePtCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrReg_Fall11_value

    property ePtCorrReg_Jan16ReReco:
        def __get__(self):
            self.ePtCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrReg_Jan16ReReco_value

    property ePtCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.ePtCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrReg_Summer12_DR53X_HCP2012_value

    property ePtCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedNoReg_2012Jul13ReReco_value

    property ePtCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.ePtCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedNoReg_Fall11_value

    property ePtCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.ePtCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedNoReg_Jan16ReReco_value

    property ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property ePtCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.ePtCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedReg_2012Jul13ReReco_value

    property ePtCorrSmearedReg_Fall11:
        def __get__(self):
            self.ePtCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedReg_Fall11_value

    property ePtCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.ePtCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedReg_Jan16ReReco_value

    property ePtCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property ePt_ees_minus:
        def __get__(self):
            self.ePt_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.ePt_ees_minus_value

    property ePt_ees_plus:
        def __get__(self):
            self.ePt_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.ePt_ees_plus_value

    property ePt_tes_minus:
        def __get__(self):
            self.ePt_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.ePt_tes_minus_value

    property ePt_tes_plus:
        def __get__(self):
            self.ePt_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.ePt_tes_plus_value

    property eRank:
        def __get__(self):
            self.eRank_branch.GetEntry(self.localentry, 0)
            return self.eRank_value

    property eRelIso:
        def __get__(self):
            self.eRelIso_branch.GetEntry(self.localentry, 0)
            return self.eRelIso_value

    property eRelPFIsoDB:
        def __get__(self):
            self.eRelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.eRelPFIsoDB_value

    property eRelPFIsoRho:
        def __get__(self):
            self.eRelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.eRelPFIsoRho_value

    property eRelPFIsoRhoFSR:
        def __get__(self):
            self.eRelPFIsoRhoFSR_branch.GetEntry(self.localentry, 0)
            return self.eRelPFIsoRhoFSR_value

    property eRhoHZG2011:
        def __get__(self):
            self.eRhoHZG2011_branch.GetEntry(self.localentry, 0)
            return self.eRhoHZG2011_value

    property eRhoHZG2012:
        def __get__(self):
            self.eRhoHZG2012_branch.GetEntry(self.localentry, 0)
            return self.eRhoHZG2012_value

    property eSCEnergy:
        def __get__(self):
            self.eSCEnergy_branch.GetEntry(self.localentry, 0)
            return self.eSCEnergy_value

    property eSCEta:
        def __get__(self):
            self.eSCEta_branch.GetEntry(self.localentry, 0)
            return self.eSCEta_value

    property eSCEtaWidth:
        def __get__(self):
            self.eSCEtaWidth_branch.GetEntry(self.localentry, 0)
            return self.eSCEtaWidth_value

    property eSCPhi:
        def __get__(self):
            self.eSCPhi_branch.GetEntry(self.localentry, 0)
            return self.eSCPhi_value

    property eSCPhiWidth:
        def __get__(self):
            self.eSCPhiWidth_branch.GetEntry(self.localentry, 0)
            return self.eSCPhiWidth_value

    property eSCPreshowerEnergy:
        def __get__(self):
            self.eSCPreshowerEnergy_branch.GetEntry(self.localentry, 0)
            return self.eSCPreshowerEnergy_value

    property eSCRawEnergy:
        def __get__(self):
            self.eSCRawEnergy_branch.GetEntry(self.localentry, 0)
            return self.eSCRawEnergy_value

    property eSigmaIEtaIEta:
        def __get__(self):
            self.eSigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.eSigmaIEtaIEta_value

    property eToMETDPhi:
        def __get__(self):
            self.eToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.eToMETDPhi_value

    property eTrkIsoDR03:
        def __get__(self):
            self.eTrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eTrkIsoDR03_value

    property eVZ:
        def __get__(self):
            self.eVZ_branch.GetEntry(self.localentry, 0)
            return self.eVZ_value

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

    property eWWID:
        def __get__(self):
            self.eWWID_branch.GetEntry(self.localentry, 0)
            return self.eWWID_value

    property e_t_CosThetaStar:
        def __get__(self):
            self.e_t_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e_t_CosThetaStar_value

    property e_t_DPhi:
        def __get__(self):
            self.e_t_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e_t_DPhi_value

    property e_t_DR:
        def __get__(self):
            self.e_t_DR_branch.GetEntry(self.localentry, 0)
            return self.e_t_DR_value

    property e_t_Mass:
        def __get__(self):
            self.e_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e_t_Mass_value

    property e_t_MassFsr:
        def __get__(self):
            self.e_t_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e_t_MassFsr_value

    property e_t_Mass_ees_minus:
        def __get__(self):
            self.e_t_Mass_ees_minus_branch.GetEntry(self.localentry, 0)
            return self.e_t_Mass_ees_minus_value

    property e_t_Mass_ees_plus:
        def __get__(self):
            self.e_t_Mass_ees_plus_branch.GetEntry(self.localentry, 0)
            return self.e_t_Mass_ees_plus_value

    property e_t_Mass_tes_minus:
        def __get__(self):
            self.e_t_Mass_tes_minus_branch.GetEntry(self.localentry, 0)
            return self.e_t_Mass_tes_minus_value

    property e_t_Mass_tes_plus:
        def __get__(self):
            self.e_t_Mass_tes_plus_branch.GetEntry(self.localentry, 0)
            return self.e_t_Mass_tes_plus_value

    property e_t_PZeta:
        def __get__(self):
            self.e_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e_t_PZeta_value

    property e_t_PZetaVis:
        def __get__(self):
            self.e_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_t_PZetaVis_value

    property e_t_Pt:
        def __get__(self):
            self.e_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.e_t_Pt_value

    property e_t_PtFsr:
        def __get__(self):
            self.e_t_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e_t_PtFsr_value

    property e_t_SS:
        def __get__(self):
            self.e_t_SS_branch.GetEntry(self.localentry, 0)
            return self.e_t_SS_value

    property e_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.e_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e_t_ToMETDPhi_Ty1_value

    property e_t_ToMETDPhi_jes_minus:
        def __get__(self):
            self.e_t_ToMETDPhi_jes_minus_branch.GetEntry(self.localentry, 0)
            return self.e_t_ToMETDPhi_jes_minus_value

    property e_t_ToMETDPhi_jes_plus:
        def __get__(self):
            self.e_t_ToMETDPhi_jes_plus_branch.GetEntry(self.localentry, 0)
            return self.e_t_ToMETDPhi_jes_plus_value

    property e_t_Zcompat:
        def __get__(self):
            self.e_t_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e_t_Zcompat_value

    property edECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.edECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.edECorrReg_2012Jul13ReReco_value

    property edECorrReg_Fall11:
        def __get__(self):
            self.edECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.edECorrReg_Fall11_value

    property edECorrReg_Jan16ReReco:
        def __get__(self):
            self.edECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.edECorrReg_Jan16ReReco_value

    property edECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.edECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.edECorrReg_Summer12_DR53X_HCP2012_value

    property edECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.edECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedNoReg_2012Jul13ReReco_value

    property edECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.edECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedNoReg_Fall11_value

    property edECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.edECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedNoReg_Jan16ReReco_value

    property edECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property edECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.edECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedReg_2012Jul13ReReco_value

    property edECorrSmearedReg_Fall11:
        def __get__(self):
            self.edECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedReg_Fall11_value

    property edECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.edECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedReg_Jan16ReReco_value

    property edECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property edeltaEtaSuperClusterTrackAtVtx:
        def __get__(self):
            self.edeltaEtaSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.edeltaEtaSuperClusterTrackAtVtx_value

    property edeltaPhiSuperClusterTrackAtVtx:
        def __get__(self):
            self.edeltaPhiSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.edeltaPhiSuperClusterTrackAtVtx_value

    property eeSuperClusterOverP:
        def __get__(self):
            self.eeSuperClusterOverP_branch.GetEntry(self.localentry, 0)
            return self.eeSuperClusterOverP_value

    property eecalEnergy:
        def __get__(self):
            self.eecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.eecalEnergy_value

    property efBrem:
        def __get__(self):
            self.efBrem_branch.GetEntry(self.localentry, 0)
            return self.efBrem_value

    property etrackMomentumAtVtxP:
        def __get__(self):
            self.etrackMomentumAtVtxP_branch.GetEntry(self.localentry, 0)
            return self.etrackMomentumAtVtxP_value

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

    property vbfDeta:
        def __get__(self):
            self.vbfDeta_branch.GetEntry(self.localentry, 0)
            return self.vbfDeta_value

    property tMtToPFMET:
        def __get__(self):
            self.tMtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.tMtToPFMET_value

    property vbfDijetrap:
        def __get__(self):
            self.vbfDijetrap_branch.GetEntry(self.localentry, 0)
            return self.vbfDijetrap_value

    property vbfDphi:
        def __get__(self):
            self.vbfDphi_branch.GetEntry(self.localentry, 0)
            return self.vbfDphi_value

    property vbfDphihj:
        def __get__(self):
            self.vbfDphihj_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihj_value

    property vbfDphihjnomet:
        def __get__(self):
            self.vbfDphihjnomet_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihjnomet_value

    property vbfHrap:
        def __get__(self):
            self.vbfHrap_branch.GetEntry(self.localentry, 0)
            return self.vbfHrap_value

    property vbfJetVeto20:
        def __get__(self):
            self.vbfJetVeto20_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto20_value

    property vbfJetVeto30:
        def __get__(self):
            self.vbfJetVeto30_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto30_value

    property vbfJetVetoTight20:
        def __get__(self):
            self.vbfJetVetoTight20_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVetoTight20_value

    property vbfJetVetoTight30:
        def __get__(self):
            self.vbfJetVetoTight30_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVetoTight30_value

    property vbfMVA:
        def __get__(self):
            self.vbfMVA_branch.GetEntry(self.localentry, 0)
            return self.vbfMVA_value

    property vbfMass:
        def __get__(self):
            self.vbfMass_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_value

    property vbfMass_jes_minus:
        def __get__(self):
            self.vbfMass_jes_minus_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_jes_minus_value

    property vbfMass_jes_plus:
        def __get__(self):
            self.vbfMass_jes_plus_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_jes_plus_value

    property vbfNJets:
        def __get__(self):
            self.vbfNJets_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets_value

    property vbfVispt:
        def __get__(self):
            self.vbfVispt_branch.GetEntry(self.localentry, 0)
            return self.vbfVispt_value

    property vbfdijetpt:
        def __get__(self):
            self.vbfdijetpt_branch.GetEntry(self.localentry, 0)
            return self.vbfdijetpt_value

    property vbfditaupt:
        def __get__(self):
            self.vbfditaupt_branch.GetEntry(self.localentry, 0)
            return self.vbfditaupt_value

    property vbfj1eta:
        def __get__(self):
            self.vbfj1eta_branch.GetEntry(self.localentry, 0)
            return self.vbfj1eta_value

    property vbfj1pt:
        def __get__(self):
            self.vbfj1pt_branch.GetEntry(self.localentry, 0)
            return self.vbfj1pt_value

    property vbfj2eta:
        def __get__(self):
            self.vbfj2eta_branch.GetEntry(self.localentry, 0)
            return self.vbfj2eta_value

    property vbfj2pt:
        def __get__(self):
            self.vbfj2pt_branch.GetEntry(self.localentry, 0)
            return self.vbfj2pt_value

    property idx:
        def __get__(self):
            self.idx_branch.GetEntry(self.localentry, 0)
            return self.idx_value


