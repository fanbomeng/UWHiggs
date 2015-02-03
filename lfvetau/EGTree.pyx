

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

cdef class EGTree:
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

    cdef TBranch* eJetPartonFlavour_branch
    cdef float eJetPartonFlavour_value

    cdef TBranch* eJetPhiPhiMoment_branch
    cdef float eJetPhiPhiMoment_value

    cdef TBranch* eJetPt_branch
    cdef float eJetPt_value

    cdef TBranch* eJetQGLikelihoodID_branch
    cdef float eJetQGLikelihoodID_value

    cdef TBranch* eJetQGMVAID_branch
    cdef float eJetQGMVAID_value

    cdef TBranch* eJetaxis1_branch
    cdef float eJetaxis1_value

    cdef TBranch* eJetaxis2_branch
    cdef float eJetaxis2_value

    cdef TBranch* eJetmult_branch
    cdef float eJetmult_value

    cdef TBranch* eJetmultMLP_branch
    cdef float eJetmultMLP_value

    cdef TBranch* eJetmultMLPQC_branch
    cdef float eJetmultMLPQC_value

    cdef TBranch* eJetptD_branch
    cdef float eJetptD_value

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

    cdef TBranch* eMatchesSingleEPlusMET_branch
    cdef float eMatchesSingleEPlusMET_value

    cdef TBranch* eMissingHits_branch
    cdef float eMissingHits_value

    cdef TBranch* eMtToMET_branch
    cdef float eMtToMET_value

    cdef TBranch* eMtToMVAMET_branch
    cdef float eMtToMVAMET_value

    cdef TBranch* eMtToPFMET_branch
    cdef float eMtToPFMET_value

    cdef TBranch* eMtToPfMet_Ty1_branch
    cdef float eMtToPfMet_Ty1_value

    cdef TBranch* eMtToPfMet_jes_branch
    cdef float eMtToPfMet_jes_value

    cdef TBranch* eMtToPfMet_mes_branch
    cdef float eMtToPfMet_mes_value

    cdef TBranch* eMtToPfMet_tes_branch
    cdef float eMtToPfMet_tes_value

    cdef TBranch* eMtToPfMet_ues_branch
    cdef float eMtToPfMet_ues_value

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

    cdef TBranch* eVetoCicTightIso_branch
    cdef float eVetoCicTightIso_value

    cdef TBranch* eVetoMVAIso_branch
    cdef float eVetoMVAIso_value

    cdef TBranch* eVetoMVAIsoVtx_branch
    cdef float eVetoMVAIsoVtx_value

    cdef TBranch* eWWID_branch
    cdef float eWWID_value

    cdef TBranch* e_g_CosThetaStar_branch
    cdef float e_g_CosThetaStar_value

    cdef TBranch* e_g_DPhi_branch
    cdef float e_g_DPhi_value

    cdef TBranch* e_g_DR_branch
    cdef float e_g_DR_value

    cdef TBranch* e_g_Mass_branch
    cdef float e_g_Mass_value

    cdef TBranch* e_g_MassFsr_branch
    cdef float e_g_MassFsr_value

    cdef TBranch* e_g_PZeta_branch
    cdef float e_g_PZeta_value

    cdef TBranch* e_g_PZetaVis_branch
    cdef float e_g_PZetaVis_value

    cdef TBranch* e_g_Pt_branch
    cdef float e_g_Pt_value

    cdef TBranch* e_g_PtFsr_branch
    cdef float e_g_PtFsr_value

    cdef TBranch* e_g_SS_branch
    cdef float e_g_SS_value

    cdef TBranch* e_g_ToMETDPhi_Ty1_branch
    cdef float e_g_ToMETDPhi_Ty1_value

    cdef TBranch* e_g_Zcompat_branch
    cdef float e_g_Zcompat_value

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

    cdef TBranch* gAbsEta_branch
    cdef float gAbsEta_value

    cdef TBranch* gCBID_LOOSE_branch
    cdef float gCBID_LOOSE_value

    cdef TBranch* gCBID_MEDIUM_branch
    cdef float gCBID_MEDIUM_value

    cdef TBranch* gCBID_TIGHT_branch
    cdef float gCBID_TIGHT_value

    cdef TBranch* gCharge_branch
    cdef float gCharge_value

    cdef TBranch* gComesFromHiggs_branch
    cdef float gComesFromHiggs_value

    cdef TBranch* gConvSafeElectronVeto_branch
    cdef float gConvSafeElectronVeto_value

    cdef TBranch* gE1x5_branch
    cdef float gE1x5_value

    cdef TBranch* gE2x5_branch
    cdef float gE2x5_value

    cdef TBranch* gE3x3_branch
    cdef float gE3x3_value

    cdef TBranch* gE5x5_branch
    cdef float gE5x5_value

    cdef TBranch* gECorrPHOSPHOR2011_branch
    cdef float gECorrPHOSPHOR2011_value

    cdef TBranch* gECorrPHOSPHOR2012_branch
    cdef float gECorrPHOSPHOR2012_value

    cdef TBranch* gEffectiveAreaCHad_branch
    cdef float gEffectiveAreaCHad_value

    cdef TBranch* gEffectiveAreaNHad_branch
    cdef float gEffectiveAreaNHad_value

    cdef TBranch* gEffectiveAreaPho_branch
    cdef float gEffectiveAreaPho_value

    cdef TBranch* gEta_branch
    cdef float gEta_value

    cdef TBranch* gEtaCorrPHOSPHOR2011_branch
    cdef float gEtaCorrPHOSPHOR2011_value

    cdef TBranch* gEtaCorrPHOSPHOR2012_branch
    cdef float gEtaCorrPHOSPHOR2012_value

    cdef TBranch* gGenEnergy_branch
    cdef float gGenEnergy_value

    cdef TBranch* gGenGrandMotherPdgId_branch
    cdef float gGenGrandMotherPdgId_value

    cdef TBranch* gGenMotherPdgId_branch
    cdef float gGenMotherPdgId_value

    cdef TBranch* gHadronicDepth1OverEm_branch
    cdef float gHadronicDepth1OverEm_value

    cdef TBranch* gHadronicDepth2OverEm_branch
    cdef float gHadronicDepth2OverEm_value

    cdef TBranch* gHadronicOverEM_branch
    cdef float gHadronicOverEM_value

    cdef TBranch* gHasConversionTracks_branch
    cdef float gHasConversionTracks_value

    cdef TBranch* gHasPixelSeed_branch
    cdef float gHasPixelSeed_value

    cdef TBranch* gIsEB_branch
    cdef float gIsEB_value

    cdef TBranch* gIsEBEEGap_branch
    cdef float gIsEBEEGap_value

    cdef TBranch* gIsEBEtaGap_branch
    cdef float gIsEBEtaGap_value

    cdef TBranch* gIsEBGap_branch
    cdef float gIsEBGap_value

    cdef TBranch* gIsEBPhiGap_branch
    cdef float gIsEBPhiGap_value

    cdef TBranch* gIsEE_branch
    cdef float gIsEE_value

    cdef TBranch* gIsEEDeeGap_branch
    cdef float gIsEEDeeGap_value

    cdef TBranch* gIsEEGap_branch
    cdef float gIsEEGap_value

    cdef TBranch* gIsEERingGap_branch
    cdef float gIsEERingGap_value

    cdef TBranch* gIsPFlowPhoton_branch
    cdef float gIsPFlowPhoton_value

    cdef TBranch* gIsStandardPhoton_branch
    cdef float gIsStandardPhoton_value

    cdef TBranch* gJetArea_branch
    cdef float gJetArea_value

    cdef TBranch* gJetBtag_branch
    cdef float gJetBtag_value

    cdef TBranch* gJetCSVBtag_branch
    cdef float gJetCSVBtag_value

    cdef TBranch* gJetEtaEtaMoment_branch
    cdef float gJetEtaEtaMoment_value

    cdef TBranch* gJetEtaPhiMoment_branch
    cdef float gJetEtaPhiMoment_value

    cdef TBranch* gJetEtaPhiSpread_branch
    cdef float gJetEtaPhiSpread_value

    cdef TBranch* gJetPartonFlavour_branch
    cdef float gJetPartonFlavour_value

    cdef TBranch* gJetPhiPhiMoment_branch
    cdef float gJetPhiPhiMoment_value

    cdef TBranch* gJetPt_branch
    cdef float gJetPt_value

    cdef TBranch* gJetQGLikelihoodID_branch
    cdef float gJetQGLikelihoodID_value

    cdef TBranch* gJetQGMVAID_branch
    cdef float gJetQGMVAID_value

    cdef TBranch* gJetaxis1_branch
    cdef float gJetaxis1_value

    cdef TBranch* gJetaxis2_branch
    cdef float gJetaxis2_value

    cdef TBranch* gJetmult_branch
    cdef float gJetmult_value

    cdef TBranch* gJetmultMLP_branch
    cdef float gJetmultMLP_value

    cdef TBranch* gJetmultMLPQC_branch
    cdef float gJetmultMLPQC_value

    cdef TBranch* gJetptD_branch
    cdef float gJetptD_value

    cdef TBranch* gMass_branch
    cdef float gMass_value

    cdef TBranch* gMaxEnergyXtal_branch
    cdef float gMaxEnergyXtal_value

    cdef TBranch* gMtToMET_branch
    cdef float gMtToMET_value

    cdef TBranch* gMtToMVAMET_branch
    cdef float gMtToMVAMET_value

    cdef TBranch* gMtToPFMET_branch
    cdef float gMtToPFMET_value

    cdef TBranch* gMtToPfMet_Ty1_branch
    cdef float gMtToPfMet_Ty1_value

    cdef TBranch* gMtToPfMet_jes_branch
    cdef float gMtToPfMet_jes_value

    cdef TBranch* gMtToPfMet_mes_branch
    cdef float gMtToPfMet_mes_value

    cdef TBranch* gMtToPfMet_tes_branch
    cdef float gMtToPfMet_tes_value

    cdef TBranch* gMtToPfMet_ues_branch
    cdef float gMtToPfMet_ues_value

    cdef TBranch* gPFChargedIso_branch
    cdef float gPFChargedIso_value

    cdef TBranch* gPFNeutralIso_branch
    cdef float gPFNeutralIso_value

    cdef TBranch* gPFPhotonIso_branch
    cdef float gPFPhotonIso_value

    cdef TBranch* gPdgId_branch
    cdef float gPdgId_value

    cdef TBranch* gPhi_branch
    cdef float gPhi_value

    cdef TBranch* gPhiCorrPHOSPHOR2011_branch
    cdef float gPhiCorrPHOSPHOR2011_value

    cdef TBranch* gPhiCorrPHOSPHOR2012_branch
    cdef float gPhiCorrPHOSPHOR2012_value

    cdef TBranch* gPositionX_branch
    cdef float gPositionX_value

    cdef TBranch* gPositionY_branch
    cdef float gPositionY_value

    cdef TBranch* gPositionZ_branch
    cdef float gPositionZ_value

    cdef TBranch* gPt_branch
    cdef float gPt_value

    cdef TBranch* gPtCorrPHOSPHOR2011_branch
    cdef float gPtCorrPHOSPHOR2011_value

    cdef TBranch* gPtCorrPHOSPHOR2012_branch
    cdef float gPtCorrPHOSPHOR2012_value

    cdef TBranch* gR1x5_branch
    cdef float gR1x5_value

    cdef TBranch* gR2x5_branch
    cdef float gR2x5_value

    cdef TBranch* gR9_branch
    cdef float gR9_value

    cdef TBranch* gRank_branch
    cdef float gRank_value

    cdef TBranch* gRho_branch
    cdef float gRho_value

    cdef TBranch* gSCEnergy_branch
    cdef float gSCEnergy_value

    cdef TBranch* gSCEta_branch
    cdef float gSCEta_value

    cdef TBranch* gSCEtaWidth_branch
    cdef float gSCEtaWidth_value

    cdef TBranch* gSCPhi_branch
    cdef float gSCPhi_value

    cdef TBranch* gSCPhiWidth_branch
    cdef float gSCPhiWidth_value

    cdef TBranch* gSCPositionX_branch
    cdef float gSCPositionX_value

    cdef TBranch* gSCPositionY_branch
    cdef float gSCPositionY_value

    cdef TBranch* gSCPositionZ_branch
    cdef float gSCPositionZ_value

    cdef TBranch* gSCPreshowerEnergy_branch
    cdef float gSCPreshowerEnergy_value

    cdef TBranch* gSCRawEnergy_branch
    cdef float gSCRawEnergy_value

    cdef TBranch* gSigmaIEtaIEta_branch
    cdef float gSigmaIEtaIEta_value

    cdef TBranch* gSingleTowerHadronicDepth1OverEm_branch
    cdef float gSingleTowerHadronicDepth1OverEm_value

    cdef TBranch* gSingleTowerHadronicDepth2OverEm_branch
    cdef float gSingleTowerHadronicDepth2OverEm_value

    cdef TBranch* gSingleTowerHadronicOverEm_branch
    cdef float gSingleTowerHadronicOverEm_value

    cdef TBranch* gToMETDPhi_branch
    cdef float gToMETDPhi_value

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

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

    cdef TBranch* jetVeto30_DR05_branch
    cdef float jetVeto30_DR05_value

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

    cdef TBranch* mva_metEt_branch
    cdef float mva_metEt_value

    cdef TBranch* mva_metPhi_branch
    cdef float mva_metPhi_value

    cdef TBranch* nTruePU_branch
    cdef float nTruePU_value

    cdef TBranch* nvtx_branch
    cdef float nvtx_value

    cdef TBranch* pfMetEt_branch
    cdef float pfMetEt_value

    cdef TBranch* pfMetPhi_branch
    cdef float pfMetPhi_value

    cdef TBranch* pfMet_jes_Et_branch
    cdef float pfMet_jes_Et_value

    cdef TBranch* pfMet_jes_Phi_branch
    cdef float pfMet_jes_Phi_value

    cdef TBranch* pfMet_mes_Et_branch
    cdef float pfMet_mes_Et_value

    cdef TBranch* pfMet_mes_Phi_branch
    cdef float pfMet_mes_Phi_value

    cdef TBranch* pfMet_tes_Et_branch
    cdef float pfMet_tes_Et_value

    cdef TBranch* pfMet_tes_Phi_branch
    cdef float pfMet_tes_Phi_value

    cdef TBranch* pfMet_ues_Et_branch
    cdef float pfMet_ues_Et_value

    cdef TBranch* pfMet_ues_Phi_branch
    cdef float pfMet_ues_Phi_value

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

    cdef TBranch* type1_pfMetEt_branch
    cdef float type1_pfMetEt_value

    cdef TBranch* type1_pfMetPhi_branch
    cdef float type1_pfMetPhi_value

    cdef TBranch* vbfDeta_branch
    cdef float vbfDeta_value

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
            warnings.warn( "EGTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "EGTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "EGTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "EGTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "EGTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "EGTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "EGTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "EGTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "EGTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "EGTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCSVVeto"
        self.bjetCSVVeto_branch = the_tree.GetBranch("bjetCSVVeto")
        #if not self.bjetCSVVeto_branch and "bjetCSVVeto" not in self.complained:
        if not self.bjetCSVVeto_branch and "bjetCSVVeto":
            warnings.warn( "EGTree: Expected branch bjetCSVVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto")
        else:
            self.bjetCSVVeto_branch.SetAddress(<void*>&self.bjetCSVVeto_value)

        #print "making bjetCSVVeto30"
        self.bjetCSVVeto30_branch = the_tree.GetBranch("bjetCSVVeto30")
        #if not self.bjetCSVVeto30_branch and "bjetCSVVeto30" not in self.complained:
        if not self.bjetCSVVeto30_branch and "bjetCSVVeto30":
            warnings.warn( "EGTree: Expected branch bjetCSVVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto30")
        else:
            self.bjetCSVVeto30_branch.SetAddress(<void*>&self.bjetCSVVeto30_value)

        #print "making bjetCSVVetoZHLike"
        self.bjetCSVVetoZHLike_branch = the_tree.GetBranch("bjetCSVVetoZHLike")
        #if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike" not in self.complained:
        if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike":
            warnings.warn( "EGTree: Expected branch bjetCSVVetoZHLike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLike")
        else:
            self.bjetCSVVetoZHLike_branch.SetAddress(<void*>&self.bjetCSVVetoZHLike_value)

        #print "making bjetCSVVetoZHLikeNoJetId"
        self.bjetCSVVetoZHLikeNoJetId_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId")
        #if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId":
            warnings.warn( "EGTree: Expected branch bjetCSVVetoZHLikeNoJetId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId")
        else:
            self.bjetCSVVetoZHLikeNoJetId_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_value)

        #print "making bjetVeto"
        self.bjetVeto_branch = the_tree.GetBranch("bjetVeto")
        #if not self.bjetVeto_branch and "bjetVeto" not in self.complained:
        if not self.bjetVeto_branch and "bjetVeto":
            warnings.warn( "EGTree: Expected branch bjetVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetVeto")
        else:
            self.bjetVeto_branch.SetAddress(<void*>&self.bjetVeto_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "EGTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making doubleEExtraGroup"
        self.doubleEExtraGroup_branch = the_tree.GetBranch("doubleEExtraGroup")
        #if not self.doubleEExtraGroup_branch and "doubleEExtraGroup" not in self.complained:
        if not self.doubleEExtraGroup_branch and "doubleEExtraGroup":
            warnings.warn( "EGTree: Expected branch doubleEExtraGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraGroup")
        else:
            self.doubleEExtraGroup_branch.SetAddress(<void*>&self.doubleEExtraGroup_value)

        #print "making doubleEExtraPass"
        self.doubleEExtraPass_branch = the_tree.GetBranch("doubleEExtraPass")
        #if not self.doubleEExtraPass_branch and "doubleEExtraPass" not in self.complained:
        if not self.doubleEExtraPass_branch and "doubleEExtraPass":
            warnings.warn( "EGTree: Expected branch doubleEExtraPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPass")
        else:
            self.doubleEExtraPass_branch.SetAddress(<void*>&self.doubleEExtraPass_value)

        #print "making doubleEExtraPrescale"
        self.doubleEExtraPrescale_branch = the_tree.GetBranch("doubleEExtraPrescale")
        #if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale" not in self.complained:
        if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale":
            warnings.warn( "EGTree: Expected branch doubleEExtraPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPrescale")
        else:
            self.doubleEExtraPrescale_branch.SetAddress(<void*>&self.doubleEExtraPrescale_value)

        #print "making doubleEGroup"
        self.doubleEGroup_branch = the_tree.GetBranch("doubleEGroup")
        #if not self.doubleEGroup_branch and "doubleEGroup" not in self.complained:
        if not self.doubleEGroup_branch and "doubleEGroup":
            warnings.warn( "EGTree: Expected branch doubleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEGroup")
        else:
            self.doubleEGroup_branch.SetAddress(<void*>&self.doubleEGroup_value)

        #print "making doubleEPass"
        self.doubleEPass_branch = the_tree.GetBranch("doubleEPass")
        #if not self.doubleEPass_branch and "doubleEPass" not in self.complained:
        if not self.doubleEPass_branch and "doubleEPass":
            warnings.warn( "EGTree: Expected branch doubleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPass")
        else:
            self.doubleEPass_branch.SetAddress(<void*>&self.doubleEPass_value)

        #print "making doubleEPrescale"
        self.doubleEPrescale_branch = the_tree.GetBranch("doubleEPrescale")
        #if not self.doubleEPrescale_branch and "doubleEPrescale" not in self.complained:
        if not self.doubleEPrescale_branch and "doubleEPrescale":
            warnings.warn( "EGTree: Expected branch doubleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPrescale")
        else:
            self.doubleEPrescale_branch.SetAddress(<void*>&self.doubleEPrescale_value)

        #print "making doubleETightGroup"
        self.doubleETightGroup_branch = the_tree.GetBranch("doubleETightGroup")
        #if not self.doubleETightGroup_branch and "doubleETightGroup" not in self.complained:
        if not self.doubleETightGroup_branch and "doubleETightGroup":
            warnings.warn( "EGTree: Expected branch doubleETightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightGroup")
        else:
            self.doubleETightGroup_branch.SetAddress(<void*>&self.doubleETightGroup_value)

        #print "making doubleETightPass"
        self.doubleETightPass_branch = the_tree.GetBranch("doubleETightPass")
        #if not self.doubleETightPass_branch and "doubleETightPass" not in self.complained:
        if not self.doubleETightPass_branch and "doubleETightPass":
            warnings.warn( "EGTree: Expected branch doubleETightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPass")
        else:
            self.doubleETightPass_branch.SetAddress(<void*>&self.doubleETightPass_value)

        #print "making doubleETightPrescale"
        self.doubleETightPrescale_branch = the_tree.GetBranch("doubleETightPrescale")
        #if not self.doubleETightPrescale_branch and "doubleETightPrescale" not in self.complained:
        if not self.doubleETightPrescale_branch and "doubleETightPrescale":
            warnings.warn( "EGTree: Expected branch doubleETightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPrescale")
        else:
            self.doubleETightPrescale_branch.SetAddress(<void*>&self.doubleETightPrescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "EGTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "EGTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "EGTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuTrkGroup"
        self.doubleMuTrkGroup_branch = the_tree.GetBranch("doubleMuTrkGroup")
        #if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup" not in self.complained:
        if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup":
            warnings.warn( "EGTree: Expected branch doubleMuTrkGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkGroup")
        else:
            self.doubleMuTrkGroup_branch.SetAddress(<void*>&self.doubleMuTrkGroup_value)

        #print "making doubleMuTrkPass"
        self.doubleMuTrkPass_branch = the_tree.GetBranch("doubleMuTrkPass")
        #if not self.doubleMuTrkPass_branch and "doubleMuTrkPass" not in self.complained:
        if not self.doubleMuTrkPass_branch and "doubleMuTrkPass":
            warnings.warn( "EGTree: Expected branch doubleMuTrkPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPass")
        else:
            self.doubleMuTrkPass_branch.SetAddress(<void*>&self.doubleMuTrkPass_value)

        #print "making doubleMuTrkPrescale"
        self.doubleMuTrkPrescale_branch = the_tree.GetBranch("doubleMuTrkPrescale")
        #if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale" not in self.complained:
        if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale":
            warnings.warn( "EGTree: Expected branch doubleMuTrkPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPrescale")
        else:
            self.doubleMuTrkPrescale_branch.SetAddress(<void*>&self.doubleMuTrkPrescale_value)

        #print "making doublePhoGroup"
        self.doublePhoGroup_branch = the_tree.GetBranch("doublePhoGroup")
        #if not self.doublePhoGroup_branch and "doublePhoGroup" not in self.complained:
        if not self.doublePhoGroup_branch and "doublePhoGroup":
            warnings.warn( "EGTree: Expected branch doublePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoGroup")
        else:
            self.doublePhoGroup_branch.SetAddress(<void*>&self.doublePhoGroup_value)

        #print "making doublePhoPass"
        self.doublePhoPass_branch = the_tree.GetBranch("doublePhoPass")
        #if not self.doublePhoPass_branch and "doublePhoPass" not in self.complained:
        if not self.doublePhoPass_branch and "doublePhoPass":
            warnings.warn( "EGTree: Expected branch doublePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPass")
        else:
            self.doublePhoPass_branch.SetAddress(<void*>&self.doublePhoPass_value)

        #print "making doublePhoPrescale"
        self.doublePhoPrescale_branch = the_tree.GetBranch("doublePhoPrescale")
        #if not self.doublePhoPrescale_branch and "doublePhoPrescale" not in self.complained:
        if not self.doublePhoPrescale_branch and "doublePhoPrescale":
            warnings.warn( "EGTree: Expected branch doublePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPrescale")
        else:
            self.doublePhoPrescale_branch.SetAddress(<void*>&self.doublePhoPrescale_value)

        #print "making eAbsEta"
        self.eAbsEta_branch = the_tree.GetBranch("eAbsEta")
        #if not self.eAbsEta_branch and "eAbsEta" not in self.complained:
        if not self.eAbsEta_branch and "eAbsEta":
            warnings.warn( "EGTree: Expected branch eAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eAbsEta")
        else:
            self.eAbsEta_branch.SetAddress(<void*>&self.eAbsEta_value)

        #print "making eCBID_LOOSE"
        self.eCBID_LOOSE_branch = the_tree.GetBranch("eCBID_LOOSE")
        #if not self.eCBID_LOOSE_branch and "eCBID_LOOSE" not in self.complained:
        if not self.eCBID_LOOSE_branch and "eCBID_LOOSE":
            warnings.warn( "EGTree: Expected branch eCBID_LOOSE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_LOOSE")
        else:
            self.eCBID_LOOSE_branch.SetAddress(<void*>&self.eCBID_LOOSE_value)

        #print "making eCBID_MEDIUM"
        self.eCBID_MEDIUM_branch = the_tree.GetBranch("eCBID_MEDIUM")
        #if not self.eCBID_MEDIUM_branch and "eCBID_MEDIUM" not in self.complained:
        if not self.eCBID_MEDIUM_branch and "eCBID_MEDIUM":
            warnings.warn( "EGTree: Expected branch eCBID_MEDIUM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_MEDIUM")
        else:
            self.eCBID_MEDIUM_branch.SetAddress(<void*>&self.eCBID_MEDIUM_value)

        #print "making eCBID_TIGHT"
        self.eCBID_TIGHT_branch = the_tree.GetBranch("eCBID_TIGHT")
        #if not self.eCBID_TIGHT_branch and "eCBID_TIGHT" not in self.complained:
        if not self.eCBID_TIGHT_branch and "eCBID_TIGHT":
            warnings.warn( "EGTree: Expected branch eCBID_TIGHT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_TIGHT")
        else:
            self.eCBID_TIGHT_branch.SetAddress(<void*>&self.eCBID_TIGHT_value)

        #print "making eCBID_VETO"
        self.eCBID_VETO_branch = the_tree.GetBranch("eCBID_VETO")
        #if not self.eCBID_VETO_branch and "eCBID_VETO" not in self.complained:
        if not self.eCBID_VETO_branch and "eCBID_VETO":
            warnings.warn( "EGTree: Expected branch eCBID_VETO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_VETO")
        else:
            self.eCBID_VETO_branch.SetAddress(<void*>&self.eCBID_VETO_value)

        #print "making eCharge"
        self.eCharge_branch = the_tree.GetBranch("eCharge")
        #if not self.eCharge_branch and "eCharge" not in self.complained:
        if not self.eCharge_branch and "eCharge":
            warnings.warn( "EGTree: Expected branch eCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCharge")
        else:
            self.eCharge_branch.SetAddress(<void*>&self.eCharge_value)

        #print "making eChargeIdLoose"
        self.eChargeIdLoose_branch = the_tree.GetBranch("eChargeIdLoose")
        #if not self.eChargeIdLoose_branch and "eChargeIdLoose" not in self.complained:
        if not self.eChargeIdLoose_branch and "eChargeIdLoose":
            warnings.warn( "EGTree: Expected branch eChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdLoose")
        else:
            self.eChargeIdLoose_branch.SetAddress(<void*>&self.eChargeIdLoose_value)

        #print "making eChargeIdMed"
        self.eChargeIdMed_branch = the_tree.GetBranch("eChargeIdMed")
        #if not self.eChargeIdMed_branch and "eChargeIdMed" not in self.complained:
        if not self.eChargeIdMed_branch and "eChargeIdMed":
            warnings.warn( "EGTree: Expected branch eChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdMed")
        else:
            self.eChargeIdMed_branch.SetAddress(<void*>&self.eChargeIdMed_value)

        #print "making eChargeIdTight"
        self.eChargeIdTight_branch = the_tree.GetBranch("eChargeIdTight")
        #if not self.eChargeIdTight_branch and "eChargeIdTight" not in self.complained:
        if not self.eChargeIdTight_branch and "eChargeIdTight":
            warnings.warn( "EGTree: Expected branch eChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdTight")
        else:
            self.eChargeIdTight_branch.SetAddress(<void*>&self.eChargeIdTight_value)

        #print "making eCiCTight"
        self.eCiCTight_branch = the_tree.GetBranch("eCiCTight")
        #if not self.eCiCTight_branch and "eCiCTight" not in self.complained:
        if not self.eCiCTight_branch and "eCiCTight":
            warnings.warn( "EGTree: Expected branch eCiCTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCiCTight")
        else:
            self.eCiCTight_branch.SetAddress(<void*>&self.eCiCTight_value)

        #print "making eComesFromHiggs"
        self.eComesFromHiggs_branch = the_tree.GetBranch("eComesFromHiggs")
        #if not self.eComesFromHiggs_branch and "eComesFromHiggs" not in self.complained:
        if not self.eComesFromHiggs_branch and "eComesFromHiggs":
            warnings.warn( "EGTree: Expected branch eComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eComesFromHiggs")
        else:
            self.eComesFromHiggs_branch.SetAddress(<void*>&self.eComesFromHiggs_value)

        #print "making eDZ"
        self.eDZ_branch = the_tree.GetBranch("eDZ")
        #if not self.eDZ_branch and "eDZ" not in self.complained:
        if not self.eDZ_branch and "eDZ":
            warnings.warn( "EGTree: Expected branch eDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eDZ")
        else:
            self.eDZ_branch.SetAddress(<void*>&self.eDZ_value)

        #print "making eE1x5"
        self.eE1x5_branch = the_tree.GetBranch("eE1x5")
        #if not self.eE1x5_branch and "eE1x5" not in self.complained:
        if not self.eE1x5_branch and "eE1x5":
            warnings.warn( "EGTree: Expected branch eE1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE1x5")
        else:
            self.eE1x5_branch.SetAddress(<void*>&self.eE1x5_value)

        #print "making eE2x5Max"
        self.eE2x5Max_branch = the_tree.GetBranch("eE2x5Max")
        #if not self.eE2x5Max_branch and "eE2x5Max" not in self.complained:
        if not self.eE2x5Max_branch and "eE2x5Max":
            warnings.warn( "EGTree: Expected branch eE2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE2x5Max")
        else:
            self.eE2x5Max_branch.SetAddress(<void*>&self.eE2x5Max_value)

        #print "making eE5x5"
        self.eE5x5_branch = the_tree.GetBranch("eE5x5")
        #if not self.eE5x5_branch and "eE5x5" not in self.complained:
        if not self.eE5x5_branch and "eE5x5":
            warnings.warn( "EGTree: Expected branch eE5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE5x5")
        else:
            self.eE5x5_branch.SetAddress(<void*>&self.eE5x5_value)

        #print "making eECorrReg_2012Jul13ReReco"
        self.eECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("eECorrReg_2012Jul13ReReco")
        #if not self.eECorrReg_2012Jul13ReReco_branch and "eECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.eECorrReg_2012Jul13ReReco_branch and "eECorrReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch eECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_2012Jul13ReReco")
        else:
            self.eECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eECorrReg_2012Jul13ReReco_value)

        #print "making eECorrReg_Fall11"
        self.eECorrReg_Fall11_branch = the_tree.GetBranch("eECorrReg_Fall11")
        #if not self.eECorrReg_Fall11_branch and "eECorrReg_Fall11" not in self.complained:
        if not self.eECorrReg_Fall11_branch and "eECorrReg_Fall11":
            warnings.warn( "EGTree: Expected branch eECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_Fall11")
        else:
            self.eECorrReg_Fall11_branch.SetAddress(<void*>&self.eECorrReg_Fall11_value)

        #print "making eECorrReg_Jan16ReReco"
        self.eECorrReg_Jan16ReReco_branch = the_tree.GetBranch("eECorrReg_Jan16ReReco")
        #if not self.eECorrReg_Jan16ReReco_branch and "eECorrReg_Jan16ReReco" not in self.complained:
        if not self.eECorrReg_Jan16ReReco_branch and "eECorrReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch eECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_Jan16ReReco")
        else:
            self.eECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.eECorrReg_Jan16ReReco_value)

        #print "making eECorrReg_Summer12_DR53X_HCP2012"
        self.eECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eECorrReg_Summer12_DR53X_HCP2012")
        #if not self.eECorrReg_Summer12_DR53X_HCP2012_branch and "eECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eECorrReg_Summer12_DR53X_HCP2012_branch and "eECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch eECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.eECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making eECorrSmearedNoReg_2012Jul13ReReco"
        self.eECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("eECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.eECorrSmearedNoReg_2012Jul13ReReco_branch and "eECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.eECorrSmearedNoReg_2012Jul13ReReco_branch and "eECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch eECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.eECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making eECorrSmearedNoReg_Fall11"
        self.eECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("eECorrSmearedNoReg_Fall11")
        #if not self.eECorrSmearedNoReg_Fall11_branch and "eECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.eECorrSmearedNoReg_Fall11_branch and "eECorrSmearedNoReg_Fall11":
            warnings.warn( "EGTree: Expected branch eECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_Fall11")
        else:
            self.eECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_Fall11_value)

        #print "making eECorrSmearedNoReg_Jan16ReReco"
        self.eECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("eECorrSmearedNoReg_Jan16ReReco")
        #if not self.eECorrSmearedNoReg_Jan16ReReco_branch and "eECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.eECorrSmearedNoReg_Jan16ReReco_branch and "eECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch eECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_Jan16ReReco")
        else:
            self.eECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_Jan16ReReco_value)

        #print "making eECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch eECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making eECorrSmearedReg_2012Jul13ReReco"
        self.eECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("eECorrSmearedReg_2012Jul13ReReco")
        #if not self.eECorrSmearedReg_2012Jul13ReReco_branch and "eECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.eECorrSmearedReg_2012Jul13ReReco_branch and "eECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch eECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_2012Jul13ReReco")
        else:
            self.eECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eECorrSmearedReg_2012Jul13ReReco_value)

        #print "making eECorrSmearedReg_Fall11"
        self.eECorrSmearedReg_Fall11_branch = the_tree.GetBranch("eECorrSmearedReg_Fall11")
        #if not self.eECorrSmearedReg_Fall11_branch and "eECorrSmearedReg_Fall11" not in self.complained:
        if not self.eECorrSmearedReg_Fall11_branch and "eECorrSmearedReg_Fall11":
            warnings.warn( "EGTree: Expected branch eECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_Fall11")
        else:
            self.eECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.eECorrSmearedReg_Fall11_value)

        #print "making eECorrSmearedReg_Jan16ReReco"
        self.eECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("eECorrSmearedReg_Jan16ReReco")
        #if not self.eECorrSmearedReg_Jan16ReReco_branch and "eECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.eECorrSmearedReg_Jan16ReReco_branch and "eECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch eECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_Jan16ReReco")
        else:
            self.eECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.eECorrSmearedReg_Jan16ReReco_value)

        #print "making eECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch eECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making eEcalIsoDR03"
        self.eEcalIsoDR03_branch = the_tree.GetBranch("eEcalIsoDR03")
        #if not self.eEcalIsoDR03_branch and "eEcalIsoDR03" not in self.complained:
        if not self.eEcalIsoDR03_branch and "eEcalIsoDR03":
            warnings.warn( "EGTree: Expected branch eEcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEcalIsoDR03")
        else:
            self.eEcalIsoDR03_branch.SetAddress(<void*>&self.eEcalIsoDR03_value)

        #print "making eEffectiveArea2011Data"
        self.eEffectiveArea2011Data_branch = the_tree.GetBranch("eEffectiveArea2011Data")
        #if not self.eEffectiveArea2011Data_branch and "eEffectiveArea2011Data" not in self.complained:
        if not self.eEffectiveArea2011Data_branch and "eEffectiveArea2011Data":
            warnings.warn( "EGTree: Expected branch eEffectiveArea2011Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveArea2011Data")
        else:
            self.eEffectiveArea2011Data_branch.SetAddress(<void*>&self.eEffectiveArea2011Data_value)

        #print "making eEffectiveArea2012Data"
        self.eEffectiveArea2012Data_branch = the_tree.GetBranch("eEffectiveArea2012Data")
        #if not self.eEffectiveArea2012Data_branch and "eEffectiveArea2012Data" not in self.complained:
        if not self.eEffectiveArea2012Data_branch and "eEffectiveArea2012Data":
            warnings.warn( "EGTree: Expected branch eEffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveArea2012Data")
        else:
            self.eEffectiveArea2012Data_branch.SetAddress(<void*>&self.eEffectiveArea2012Data_value)

        #print "making eEffectiveAreaFall11MC"
        self.eEffectiveAreaFall11MC_branch = the_tree.GetBranch("eEffectiveAreaFall11MC")
        #if not self.eEffectiveAreaFall11MC_branch and "eEffectiveAreaFall11MC" not in self.complained:
        if not self.eEffectiveAreaFall11MC_branch and "eEffectiveAreaFall11MC":
            warnings.warn( "EGTree: Expected branch eEffectiveAreaFall11MC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveAreaFall11MC")
        else:
            self.eEffectiveAreaFall11MC_branch.SetAddress(<void*>&self.eEffectiveAreaFall11MC_value)

        #print "making eEle27WP80PFMT50PFMTFilter"
        self.eEle27WP80PFMT50PFMTFilter_branch = the_tree.GetBranch("eEle27WP80PFMT50PFMTFilter")
        #if not self.eEle27WP80PFMT50PFMTFilter_branch and "eEle27WP80PFMT50PFMTFilter" not in self.complained:
        if not self.eEle27WP80PFMT50PFMTFilter_branch and "eEle27WP80PFMT50PFMTFilter":
            warnings.warn( "EGTree: Expected branch eEle27WP80PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEle27WP80PFMT50PFMTFilter")
        else:
            self.eEle27WP80PFMT50PFMTFilter_branch.SetAddress(<void*>&self.eEle27WP80PFMT50PFMTFilter_value)

        #print "making eEle27WP80TrackIsoMatchFilter"
        self.eEle27WP80TrackIsoMatchFilter_branch = the_tree.GetBranch("eEle27WP80TrackIsoMatchFilter")
        #if not self.eEle27WP80TrackIsoMatchFilter_branch and "eEle27WP80TrackIsoMatchFilter" not in self.complained:
        if not self.eEle27WP80TrackIsoMatchFilter_branch and "eEle27WP80TrackIsoMatchFilter":
            warnings.warn( "EGTree: Expected branch eEle27WP80TrackIsoMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEle27WP80TrackIsoMatchFilter")
        else:
            self.eEle27WP80TrackIsoMatchFilter_branch.SetAddress(<void*>&self.eEle27WP80TrackIsoMatchFilter_value)

        #print "making eEle32WP70PFMT50PFMTFilter"
        self.eEle32WP70PFMT50PFMTFilter_branch = the_tree.GetBranch("eEle32WP70PFMT50PFMTFilter")
        #if not self.eEle32WP70PFMT50PFMTFilter_branch and "eEle32WP70PFMT50PFMTFilter" not in self.complained:
        if not self.eEle32WP70PFMT50PFMTFilter_branch and "eEle32WP70PFMT50PFMTFilter":
            warnings.warn( "EGTree: Expected branch eEle32WP70PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEle32WP70PFMT50PFMTFilter")
        else:
            self.eEle32WP70PFMT50PFMTFilter_branch.SetAddress(<void*>&self.eEle32WP70PFMT50PFMTFilter_value)

        #print "making eEnergyError"
        self.eEnergyError_branch = the_tree.GetBranch("eEnergyError")
        #if not self.eEnergyError_branch and "eEnergyError" not in self.complained:
        if not self.eEnergyError_branch and "eEnergyError":
            warnings.warn( "EGTree: Expected branch eEnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyError")
        else:
            self.eEnergyError_branch.SetAddress(<void*>&self.eEnergyError_value)

        #print "making eEta"
        self.eEta_branch = the_tree.GetBranch("eEta")
        #if not self.eEta_branch and "eEta" not in self.complained:
        if not self.eEta_branch and "eEta":
            warnings.warn( "EGTree: Expected branch eEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEta")
        else:
            self.eEta_branch.SetAddress(<void*>&self.eEta_value)

        #print "making eEtaCorrReg_2012Jul13ReReco"
        self.eEtaCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("eEtaCorrReg_2012Jul13ReReco")
        #if not self.eEtaCorrReg_2012Jul13ReReco_branch and "eEtaCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.eEtaCorrReg_2012Jul13ReReco_branch and "eEtaCorrReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch eEtaCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_2012Jul13ReReco")
        else:
            self.eEtaCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eEtaCorrReg_2012Jul13ReReco_value)

        #print "making eEtaCorrReg_Fall11"
        self.eEtaCorrReg_Fall11_branch = the_tree.GetBranch("eEtaCorrReg_Fall11")
        #if not self.eEtaCorrReg_Fall11_branch and "eEtaCorrReg_Fall11" not in self.complained:
        if not self.eEtaCorrReg_Fall11_branch and "eEtaCorrReg_Fall11":
            warnings.warn( "EGTree: Expected branch eEtaCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_Fall11")
        else:
            self.eEtaCorrReg_Fall11_branch.SetAddress(<void*>&self.eEtaCorrReg_Fall11_value)

        #print "making eEtaCorrReg_Jan16ReReco"
        self.eEtaCorrReg_Jan16ReReco_branch = the_tree.GetBranch("eEtaCorrReg_Jan16ReReco")
        #if not self.eEtaCorrReg_Jan16ReReco_branch and "eEtaCorrReg_Jan16ReReco" not in self.complained:
        if not self.eEtaCorrReg_Jan16ReReco_branch and "eEtaCorrReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch eEtaCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_Jan16ReReco")
        else:
            self.eEtaCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.eEtaCorrReg_Jan16ReReco_value)

        #print "making eEtaCorrReg_Summer12_DR53X_HCP2012"
        self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eEtaCorrReg_Summer12_DR53X_HCP2012")
        #if not self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch eEtaCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eEtaCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making eEtaCorrSmearedNoReg_2012Jul13ReReco"
        self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch and "eEtaCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch and "eEtaCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch eEtaCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making eEtaCorrSmearedNoReg_Fall11"
        self.eEtaCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_Fall11")
        #if not self.eEtaCorrSmearedNoReg_Fall11_branch and "eEtaCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_Fall11_branch and "eEtaCorrSmearedNoReg_Fall11":
            warnings.warn( "EGTree: Expected branch eEtaCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_Fall11")
        else:
            self.eEtaCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_Fall11_value)

        #print "making eEtaCorrSmearedNoReg_Jan16ReReco"
        self.eEtaCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_Jan16ReReco")
        #if not self.eEtaCorrSmearedNoReg_Jan16ReReco_branch and "eEtaCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_Jan16ReReco_branch and "eEtaCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch eEtaCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_Jan16ReReco")
        else:
            self.eEtaCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_Jan16ReReco_value)

        #print "making eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making eEtaCorrSmearedReg_2012Jul13ReReco"
        self.eEtaCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedReg_2012Jul13ReReco")
        #if not self.eEtaCorrSmearedReg_2012Jul13ReReco_branch and "eEtaCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.eEtaCorrSmearedReg_2012Jul13ReReco_branch and "eEtaCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch eEtaCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_2012Jul13ReReco")
        else:
            self.eEtaCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_2012Jul13ReReco_value)

        #print "making eEtaCorrSmearedReg_Fall11"
        self.eEtaCorrSmearedReg_Fall11_branch = the_tree.GetBranch("eEtaCorrSmearedReg_Fall11")
        #if not self.eEtaCorrSmearedReg_Fall11_branch and "eEtaCorrSmearedReg_Fall11" not in self.complained:
        if not self.eEtaCorrSmearedReg_Fall11_branch and "eEtaCorrSmearedReg_Fall11":
            warnings.warn( "EGTree: Expected branch eEtaCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_Fall11")
        else:
            self.eEtaCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_Fall11_value)

        #print "making eEtaCorrSmearedReg_Jan16ReReco"
        self.eEtaCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedReg_Jan16ReReco")
        #if not self.eEtaCorrSmearedReg_Jan16ReReco_branch and "eEtaCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.eEtaCorrSmearedReg_Jan16ReReco_branch and "eEtaCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch eEtaCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_Jan16ReReco")
        else:
            self.eEtaCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_Jan16ReReco_value)

        #print "making eEtaCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eEtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch eEtaCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making eGenCharge"
        self.eGenCharge_branch = the_tree.GetBranch("eGenCharge")
        #if not self.eGenCharge_branch and "eGenCharge" not in self.complained:
        if not self.eGenCharge_branch and "eGenCharge":
            warnings.warn( "EGTree: Expected branch eGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenCharge")
        else:
            self.eGenCharge_branch.SetAddress(<void*>&self.eGenCharge_value)

        #print "making eGenEnergy"
        self.eGenEnergy_branch = the_tree.GetBranch("eGenEnergy")
        #if not self.eGenEnergy_branch and "eGenEnergy" not in self.complained:
        if not self.eGenEnergy_branch and "eGenEnergy":
            warnings.warn( "EGTree: Expected branch eGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEnergy")
        else:
            self.eGenEnergy_branch.SetAddress(<void*>&self.eGenEnergy_value)

        #print "making eGenEta"
        self.eGenEta_branch = the_tree.GetBranch("eGenEta")
        #if not self.eGenEta_branch and "eGenEta" not in self.complained:
        if not self.eGenEta_branch and "eGenEta":
            warnings.warn( "EGTree: Expected branch eGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEta")
        else:
            self.eGenEta_branch.SetAddress(<void*>&self.eGenEta_value)

        #print "making eGenMotherPdgId"
        self.eGenMotherPdgId_branch = the_tree.GetBranch("eGenMotherPdgId")
        #if not self.eGenMotherPdgId_branch and "eGenMotherPdgId" not in self.complained:
        if not self.eGenMotherPdgId_branch and "eGenMotherPdgId":
            warnings.warn( "EGTree: Expected branch eGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenMotherPdgId")
        else:
            self.eGenMotherPdgId_branch.SetAddress(<void*>&self.eGenMotherPdgId_value)

        #print "making eGenPdgId"
        self.eGenPdgId_branch = the_tree.GetBranch("eGenPdgId")
        #if not self.eGenPdgId_branch and "eGenPdgId" not in self.complained:
        if not self.eGenPdgId_branch and "eGenPdgId":
            warnings.warn( "EGTree: Expected branch eGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPdgId")
        else:
            self.eGenPdgId_branch.SetAddress(<void*>&self.eGenPdgId_value)

        #print "making eGenPhi"
        self.eGenPhi_branch = the_tree.GetBranch("eGenPhi")
        #if not self.eGenPhi_branch and "eGenPhi" not in self.complained:
        if not self.eGenPhi_branch and "eGenPhi":
            warnings.warn( "EGTree: Expected branch eGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPhi")
        else:
            self.eGenPhi_branch.SetAddress(<void*>&self.eGenPhi_value)

        #print "making eHadronicDepth1OverEm"
        self.eHadronicDepth1OverEm_branch = the_tree.GetBranch("eHadronicDepth1OverEm")
        #if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm" not in self.complained:
        if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm":
            warnings.warn( "EGTree: Expected branch eHadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth1OverEm")
        else:
            self.eHadronicDepth1OverEm_branch.SetAddress(<void*>&self.eHadronicDepth1OverEm_value)

        #print "making eHadronicDepth2OverEm"
        self.eHadronicDepth2OverEm_branch = the_tree.GetBranch("eHadronicDepth2OverEm")
        #if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm" not in self.complained:
        if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm":
            warnings.warn( "EGTree: Expected branch eHadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth2OverEm")
        else:
            self.eHadronicDepth2OverEm_branch.SetAddress(<void*>&self.eHadronicDepth2OverEm_value)

        #print "making eHadronicOverEM"
        self.eHadronicOverEM_branch = the_tree.GetBranch("eHadronicOverEM")
        #if not self.eHadronicOverEM_branch and "eHadronicOverEM" not in self.complained:
        if not self.eHadronicOverEM_branch and "eHadronicOverEM":
            warnings.warn( "EGTree: Expected branch eHadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicOverEM")
        else:
            self.eHadronicOverEM_branch.SetAddress(<void*>&self.eHadronicOverEM_value)

        #print "making eHasConversion"
        self.eHasConversion_branch = the_tree.GetBranch("eHasConversion")
        #if not self.eHasConversion_branch and "eHasConversion" not in self.complained:
        if not self.eHasConversion_branch and "eHasConversion":
            warnings.warn( "EGTree: Expected branch eHasConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHasConversion")
        else:
            self.eHasConversion_branch.SetAddress(<void*>&self.eHasConversion_value)

        #print "making eHasMatchedConversion"
        self.eHasMatchedConversion_branch = the_tree.GetBranch("eHasMatchedConversion")
        #if not self.eHasMatchedConversion_branch and "eHasMatchedConversion" not in self.complained:
        if not self.eHasMatchedConversion_branch and "eHasMatchedConversion":
            warnings.warn( "EGTree: Expected branch eHasMatchedConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHasMatchedConversion")
        else:
            self.eHasMatchedConversion_branch.SetAddress(<void*>&self.eHasMatchedConversion_value)

        #print "making eHcalIsoDR03"
        self.eHcalIsoDR03_branch = the_tree.GetBranch("eHcalIsoDR03")
        #if not self.eHcalIsoDR03_branch and "eHcalIsoDR03" not in self.complained:
        if not self.eHcalIsoDR03_branch and "eHcalIsoDR03":
            warnings.warn( "EGTree: Expected branch eHcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHcalIsoDR03")
        else:
            self.eHcalIsoDR03_branch.SetAddress(<void*>&self.eHcalIsoDR03_value)

        #print "making eIP3DS"
        self.eIP3DS_branch = the_tree.GetBranch("eIP3DS")
        #if not self.eIP3DS_branch and "eIP3DS" not in self.complained:
        if not self.eIP3DS_branch and "eIP3DS":
            warnings.warn( "EGTree: Expected branch eIP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIP3DS")
        else:
            self.eIP3DS_branch.SetAddress(<void*>&self.eIP3DS_value)

        #print "making eJetArea"
        self.eJetArea_branch = the_tree.GetBranch("eJetArea")
        #if not self.eJetArea_branch and "eJetArea" not in self.complained:
        if not self.eJetArea_branch and "eJetArea":
            warnings.warn( "EGTree: Expected branch eJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetArea")
        else:
            self.eJetArea_branch.SetAddress(<void*>&self.eJetArea_value)

        #print "making eJetBtag"
        self.eJetBtag_branch = the_tree.GetBranch("eJetBtag")
        #if not self.eJetBtag_branch and "eJetBtag" not in self.complained:
        if not self.eJetBtag_branch and "eJetBtag":
            warnings.warn( "EGTree: Expected branch eJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetBtag")
        else:
            self.eJetBtag_branch.SetAddress(<void*>&self.eJetBtag_value)

        #print "making eJetCSVBtag"
        self.eJetCSVBtag_branch = the_tree.GetBranch("eJetCSVBtag")
        #if not self.eJetCSVBtag_branch and "eJetCSVBtag" not in self.complained:
        if not self.eJetCSVBtag_branch and "eJetCSVBtag":
            warnings.warn( "EGTree: Expected branch eJetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetCSVBtag")
        else:
            self.eJetCSVBtag_branch.SetAddress(<void*>&self.eJetCSVBtag_value)

        #print "making eJetEtaEtaMoment"
        self.eJetEtaEtaMoment_branch = the_tree.GetBranch("eJetEtaEtaMoment")
        #if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment" not in self.complained:
        if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment":
            warnings.warn( "EGTree: Expected branch eJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaEtaMoment")
        else:
            self.eJetEtaEtaMoment_branch.SetAddress(<void*>&self.eJetEtaEtaMoment_value)

        #print "making eJetEtaPhiMoment"
        self.eJetEtaPhiMoment_branch = the_tree.GetBranch("eJetEtaPhiMoment")
        #if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment" not in self.complained:
        if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment":
            warnings.warn( "EGTree: Expected branch eJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiMoment")
        else:
            self.eJetEtaPhiMoment_branch.SetAddress(<void*>&self.eJetEtaPhiMoment_value)

        #print "making eJetEtaPhiSpread"
        self.eJetEtaPhiSpread_branch = the_tree.GetBranch("eJetEtaPhiSpread")
        #if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread" not in self.complained:
        if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread":
            warnings.warn( "EGTree: Expected branch eJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiSpread")
        else:
            self.eJetEtaPhiSpread_branch.SetAddress(<void*>&self.eJetEtaPhiSpread_value)

        #print "making eJetPartonFlavour"
        self.eJetPartonFlavour_branch = the_tree.GetBranch("eJetPartonFlavour")
        #if not self.eJetPartonFlavour_branch and "eJetPartonFlavour" not in self.complained:
        if not self.eJetPartonFlavour_branch and "eJetPartonFlavour":
            warnings.warn( "EGTree: Expected branch eJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPartonFlavour")
        else:
            self.eJetPartonFlavour_branch.SetAddress(<void*>&self.eJetPartonFlavour_value)

        #print "making eJetPhiPhiMoment"
        self.eJetPhiPhiMoment_branch = the_tree.GetBranch("eJetPhiPhiMoment")
        #if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment" not in self.complained:
        if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment":
            warnings.warn( "EGTree: Expected branch eJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPhiPhiMoment")
        else:
            self.eJetPhiPhiMoment_branch.SetAddress(<void*>&self.eJetPhiPhiMoment_value)

        #print "making eJetPt"
        self.eJetPt_branch = the_tree.GetBranch("eJetPt")
        #if not self.eJetPt_branch and "eJetPt" not in self.complained:
        if not self.eJetPt_branch and "eJetPt":
            warnings.warn( "EGTree: Expected branch eJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPt")
        else:
            self.eJetPt_branch.SetAddress(<void*>&self.eJetPt_value)

        #print "making eJetQGLikelihoodID"
        self.eJetQGLikelihoodID_branch = the_tree.GetBranch("eJetQGLikelihoodID")
        #if not self.eJetQGLikelihoodID_branch and "eJetQGLikelihoodID" not in self.complained:
        if not self.eJetQGLikelihoodID_branch and "eJetQGLikelihoodID":
            warnings.warn( "EGTree: Expected branch eJetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetQGLikelihoodID")
        else:
            self.eJetQGLikelihoodID_branch.SetAddress(<void*>&self.eJetQGLikelihoodID_value)

        #print "making eJetQGMVAID"
        self.eJetQGMVAID_branch = the_tree.GetBranch("eJetQGMVAID")
        #if not self.eJetQGMVAID_branch and "eJetQGMVAID" not in self.complained:
        if not self.eJetQGMVAID_branch and "eJetQGMVAID":
            warnings.warn( "EGTree: Expected branch eJetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetQGMVAID")
        else:
            self.eJetQGMVAID_branch.SetAddress(<void*>&self.eJetQGMVAID_value)

        #print "making eJetaxis1"
        self.eJetaxis1_branch = the_tree.GetBranch("eJetaxis1")
        #if not self.eJetaxis1_branch and "eJetaxis1" not in self.complained:
        if not self.eJetaxis1_branch and "eJetaxis1":
            warnings.warn( "EGTree: Expected branch eJetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetaxis1")
        else:
            self.eJetaxis1_branch.SetAddress(<void*>&self.eJetaxis1_value)

        #print "making eJetaxis2"
        self.eJetaxis2_branch = the_tree.GetBranch("eJetaxis2")
        #if not self.eJetaxis2_branch and "eJetaxis2" not in self.complained:
        if not self.eJetaxis2_branch and "eJetaxis2":
            warnings.warn( "EGTree: Expected branch eJetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetaxis2")
        else:
            self.eJetaxis2_branch.SetAddress(<void*>&self.eJetaxis2_value)

        #print "making eJetmult"
        self.eJetmult_branch = the_tree.GetBranch("eJetmult")
        #if not self.eJetmult_branch and "eJetmult" not in self.complained:
        if not self.eJetmult_branch and "eJetmult":
            warnings.warn( "EGTree: Expected branch eJetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetmult")
        else:
            self.eJetmult_branch.SetAddress(<void*>&self.eJetmult_value)

        #print "making eJetmultMLP"
        self.eJetmultMLP_branch = the_tree.GetBranch("eJetmultMLP")
        #if not self.eJetmultMLP_branch and "eJetmultMLP" not in self.complained:
        if not self.eJetmultMLP_branch and "eJetmultMLP":
            warnings.warn( "EGTree: Expected branch eJetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetmultMLP")
        else:
            self.eJetmultMLP_branch.SetAddress(<void*>&self.eJetmultMLP_value)

        #print "making eJetmultMLPQC"
        self.eJetmultMLPQC_branch = the_tree.GetBranch("eJetmultMLPQC")
        #if not self.eJetmultMLPQC_branch and "eJetmultMLPQC" not in self.complained:
        if not self.eJetmultMLPQC_branch and "eJetmultMLPQC":
            warnings.warn( "EGTree: Expected branch eJetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetmultMLPQC")
        else:
            self.eJetmultMLPQC_branch.SetAddress(<void*>&self.eJetmultMLPQC_value)

        #print "making eJetptD"
        self.eJetptD_branch = the_tree.GetBranch("eJetptD")
        #if not self.eJetptD_branch and "eJetptD" not in self.complained:
        if not self.eJetptD_branch and "eJetptD":
            warnings.warn( "EGTree: Expected branch eJetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetptD")
        else:
            self.eJetptD_branch.SetAddress(<void*>&self.eJetptD_value)

        #print "making eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter"
        self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch = the_tree.GetBranch("eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        #if not self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter" not in self.complained:
        if not self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter":
            warnings.warn( "EGTree: Expected branch eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        else:
            self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.SetAddress(<void*>&self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value)

        #print "making eMITID"
        self.eMITID_branch = the_tree.GetBranch("eMITID")
        #if not self.eMITID_branch and "eMITID" not in self.complained:
        if not self.eMITID_branch and "eMITID":
            warnings.warn( "EGTree: Expected branch eMITID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMITID")
        else:
            self.eMITID_branch.SetAddress(<void*>&self.eMITID_value)

        #print "making eMVAIDH2TauWP"
        self.eMVAIDH2TauWP_branch = the_tree.GetBranch("eMVAIDH2TauWP")
        #if not self.eMVAIDH2TauWP_branch and "eMVAIDH2TauWP" not in self.complained:
        if not self.eMVAIDH2TauWP_branch and "eMVAIDH2TauWP":
            warnings.warn( "EGTree: Expected branch eMVAIDH2TauWP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIDH2TauWP")
        else:
            self.eMVAIDH2TauWP_branch.SetAddress(<void*>&self.eMVAIDH2TauWP_value)

        #print "making eMVANonTrig"
        self.eMVANonTrig_branch = the_tree.GetBranch("eMVANonTrig")
        #if not self.eMVANonTrig_branch and "eMVANonTrig" not in self.complained:
        if not self.eMVANonTrig_branch and "eMVANonTrig":
            warnings.warn( "EGTree: Expected branch eMVANonTrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANonTrig")
        else:
            self.eMVANonTrig_branch.SetAddress(<void*>&self.eMVANonTrig_value)

        #print "making eMVATrig"
        self.eMVATrig_branch = the_tree.GetBranch("eMVATrig")
        #if not self.eMVATrig_branch and "eMVATrig" not in self.complained:
        if not self.eMVATrig_branch and "eMVATrig":
            warnings.warn( "EGTree: Expected branch eMVATrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrig")
        else:
            self.eMVATrig_branch.SetAddress(<void*>&self.eMVATrig_value)

        #print "making eMVATrigIDISO"
        self.eMVATrigIDISO_branch = the_tree.GetBranch("eMVATrigIDISO")
        #if not self.eMVATrigIDISO_branch and "eMVATrigIDISO" not in self.complained:
        if not self.eMVATrigIDISO_branch and "eMVATrigIDISO":
            warnings.warn( "EGTree: Expected branch eMVATrigIDISO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigIDISO")
        else:
            self.eMVATrigIDISO_branch.SetAddress(<void*>&self.eMVATrigIDISO_value)

        #print "making eMVATrigIDISOPUSUB"
        self.eMVATrigIDISOPUSUB_branch = the_tree.GetBranch("eMVATrigIDISOPUSUB")
        #if not self.eMVATrigIDISOPUSUB_branch and "eMVATrigIDISOPUSUB" not in self.complained:
        if not self.eMVATrigIDISOPUSUB_branch and "eMVATrigIDISOPUSUB":
            warnings.warn( "EGTree: Expected branch eMVATrigIDISOPUSUB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigIDISOPUSUB")
        else:
            self.eMVATrigIDISOPUSUB_branch.SetAddress(<void*>&self.eMVATrigIDISOPUSUB_value)

        #print "making eMVATrigNoIP"
        self.eMVATrigNoIP_branch = the_tree.GetBranch("eMVATrigNoIP")
        #if not self.eMVATrigNoIP_branch and "eMVATrigNoIP" not in self.complained:
        if not self.eMVATrigNoIP_branch and "eMVATrigNoIP":
            warnings.warn( "EGTree: Expected branch eMVATrigNoIP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigNoIP")
        else:
            self.eMVATrigNoIP_branch.SetAddress(<void*>&self.eMVATrigNoIP_value)

        #print "making eMass"
        self.eMass_branch = the_tree.GetBranch("eMass")
        #if not self.eMass_branch and "eMass" not in self.complained:
        if not self.eMass_branch and "eMass":
            warnings.warn( "EGTree: Expected branch eMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMass")
        else:
            self.eMass_branch.SetAddress(<void*>&self.eMass_value)

        #print "making eMatchesDoubleEPath"
        self.eMatchesDoubleEPath_branch = the_tree.GetBranch("eMatchesDoubleEPath")
        #if not self.eMatchesDoubleEPath_branch and "eMatchesDoubleEPath" not in self.complained:
        if not self.eMatchesDoubleEPath_branch and "eMatchesDoubleEPath":
            warnings.warn( "EGTree: Expected branch eMatchesDoubleEPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesDoubleEPath")
        else:
            self.eMatchesDoubleEPath_branch.SetAddress(<void*>&self.eMatchesDoubleEPath_value)

        #print "making eMatchesMu17Ele8IsoPath"
        self.eMatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("eMatchesMu17Ele8IsoPath")
        #if not self.eMatchesMu17Ele8IsoPath_branch and "eMatchesMu17Ele8IsoPath" not in self.complained:
        if not self.eMatchesMu17Ele8IsoPath_branch and "eMatchesMu17Ele8IsoPath":
            warnings.warn( "EGTree: Expected branch eMatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu17Ele8IsoPath")
        else:
            self.eMatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.eMatchesMu17Ele8IsoPath_value)

        #print "making eMatchesMu17Ele8Path"
        self.eMatchesMu17Ele8Path_branch = the_tree.GetBranch("eMatchesMu17Ele8Path")
        #if not self.eMatchesMu17Ele8Path_branch and "eMatchesMu17Ele8Path" not in self.complained:
        if not self.eMatchesMu17Ele8Path_branch and "eMatchesMu17Ele8Path":
            warnings.warn( "EGTree: Expected branch eMatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu17Ele8Path")
        else:
            self.eMatchesMu17Ele8Path_branch.SetAddress(<void*>&self.eMatchesMu17Ele8Path_value)

        #print "making eMatchesMu8Ele17IsoPath"
        self.eMatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("eMatchesMu8Ele17IsoPath")
        #if not self.eMatchesMu8Ele17IsoPath_branch and "eMatchesMu8Ele17IsoPath" not in self.complained:
        if not self.eMatchesMu8Ele17IsoPath_branch and "eMatchesMu8Ele17IsoPath":
            warnings.warn( "EGTree: Expected branch eMatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8Ele17IsoPath")
        else:
            self.eMatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.eMatchesMu8Ele17IsoPath_value)

        #print "making eMatchesMu8Ele17Path"
        self.eMatchesMu8Ele17Path_branch = the_tree.GetBranch("eMatchesMu8Ele17Path")
        #if not self.eMatchesMu8Ele17Path_branch and "eMatchesMu8Ele17Path" not in self.complained:
        if not self.eMatchesMu8Ele17Path_branch and "eMatchesMu8Ele17Path":
            warnings.warn( "EGTree: Expected branch eMatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8Ele17Path")
        else:
            self.eMatchesMu8Ele17Path_branch.SetAddress(<void*>&self.eMatchesMu8Ele17Path_value)

        #print "making eMatchesSingleE"
        self.eMatchesSingleE_branch = the_tree.GetBranch("eMatchesSingleE")
        #if not self.eMatchesSingleE_branch and "eMatchesSingleE" not in self.complained:
        if not self.eMatchesSingleE_branch and "eMatchesSingleE":
            warnings.warn( "EGTree: Expected branch eMatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleE")
        else:
            self.eMatchesSingleE_branch.SetAddress(<void*>&self.eMatchesSingleE_value)

        #print "making eMatchesSingleEPlusMET"
        self.eMatchesSingleEPlusMET_branch = the_tree.GetBranch("eMatchesSingleEPlusMET")
        #if not self.eMatchesSingleEPlusMET_branch and "eMatchesSingleEPlusMET" not in self.complained:
        if not self.eMatchesSingleEPlusMET_branch and "eMatchesSingleEPlusMET":
            warnings.warn( "EGTree: Expected branch eMatchesSingleEPlusMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleEPlusMET")
        else:
            self.eMatchesSingleEPlusMET_branch.SetAddress(<void*>&self.eMatchesSingleEPlusMET_value)

        #print "making eMissingHits"
        self.eMissingHits_branch = the_tree.GetBranch("eMissingHits")
        #if not self.eMissingHits_branch and "eMissingHits" not in self.complained:
        if not self.eMissingHits_branch and "eMissingHits":
            warnings.warn( "EGTree: Expected branch eMissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMissingHits")
        else:
            self.eMissingHits_branch.SetAddress(<void*>&self.eMissingHits_value)

        #print "making eMtToMET"
        self.eMtToMET_branch = the_tree.GetBranch("eMtToMET")
        #if not self.eMtToMET_branch and "eMtToMET" not in self.complained:
        if not self.eMtToMET_branch and "eMtToMET":
            warnings.warn( "EGTree: Expected branch eMtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToMET")
        else:
            self.eMtToMET_branch.SetAddress(<void*>&self.eMtToMET_value)

        #print "making eMtToMVAMET"
        self.eMtToMVAMET_branch = the_tree.GetBranch("eMtToMVAMET")
        #if not self.eMtToMVAMET_branch and "eMtToMVAMET" not in self.complained:
        if not self.eMtToMVAMET_branch and "eMtToMVAMET":
            warnings.warn( "EGTree: Expected branch eMtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToMVAMET")
        else:
            self.eMtToMVAMET_branch.SetAddress(<void*>&self.eMtToMVAMET_value)

        #print "making eMtToPFMET"
        self.eMtToPFMET_branch = the_tree.GetBranch("eMtToPFMET")
        #if not self.eMtToPFMET_branch and "eMtToPFMET" not in self.complained:
        if not self.eMtToPFMET_branch and "eMtToPFMET":
            warnings.warn( "EGTree: Expected branch eMtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPFMET")
        else:
            self.eMtToPFMET_branch.SetAddress(<void*>&self.eMtToPFMET_value)

        #print "making eMtToPfMet_Ty1"
        self.eMtToPfMet_Ty1_branch = the_tree.GetBranch("eMtToPfMet_Ty1")
        #if not self.eMtToPfMet_Ty1_branch and "eMtToPfMet_Ty1" not in self.complained:
        if not self.eMtToPfMet_Ty1_branch and "eMtToPfMet_Ty1":
            warnings.warn( "EGTree: Expected branch eMtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_Ty1")
        else:
            self.eMtToPfMet_Ty1_branch.SetAddress(<void*>&self.eMtToPfMet_Ty1_value)

        #print "making eMtToPfMet_jes"
        self.eMtToPfMet_jes_branch = the_tree.GetBranch("eMtToPfMet_jes")
        #if not self.eMtToPfMet_jes_branch and "eMtToPfMet_jes" not in self.complained:
        if not self.eMtToPfMet_jes_branch and "eMtToPfMet_jes":
            warnings.warn( "EGTree: Expected branch eMtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_jes")
        else:
            self.eMtToPfMet_jes_branch.SetAddress(<void*>&self.eMtToPfMet_jes_value)

        #print "making eMtToPfMet_mes"
        self.eMtToPfMet_mes_branch = the_tree.GetBranch("eMtToPfMet_mes")
        #if not self.eMtToPfMet_mes_branch and "eMtToPfMet_mes" not in self.complained:
        if not self.eMtToPfMet_mes_branch and "eMtToPfMet_mes":
            warnings.warn( "EGTree: Expected branch eMtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_mes")
        else:
            self.eMtToPfMet_mes_branch.SetAddress(<void*>&self.eMtToPfMet_mes_value)

        #print "making eMtToPfMet_tes"
        self.eMtToPfMet_tes_branch = the_tree.GetBranch("eMtToPfMet_tes")
        #if not self.eMtToPfMet_tes_branch and "eMtToPfMet_tes" not in self.complained:
        if not self.eMtToPfMet_tes_branch and "eMtToPfMet_tes":
            warnings.warn( "EGTree: Expected branch eMtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_tes")
        else:
            self.eMtToPfMet_tes_branch.SetAddress(<void*>&self.eMtToPfMet_tes_value)

        #print "making eMtToPfMet_ues"
        self.eMtToPfMet_ues_branch = the_tree.GetBranch("eMtToPfMet_ues")
        #if not self.eMtToPfMet_ues_branch and "eMtToPfMet_ues" not in self.complained:
        if not self.eMtToPfMet_ues_branch and "eMtToPfMet_ues":
            warnings.warn( "EGTree: Expected branch eMtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_ues")
        else:
            self.eMtToPfMet_ues_branch.SetAddress(<void*>&self.eMtToPfMet_ues_value)

        #print "making eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter"
        self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch = the_tree.GetBranch("eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        #if not self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter" not in self.complained:
        if not self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter":
            warnings.warn( "EGTree: Expected branch eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        else:
            self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.SetAddress(<void*>&self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value)

        #print "making eMu17Ele8CaloIdTPixelMatchFilter"
        self.eMu17Ele8CaloIdTPixelMatchFilter_branch = the_tree.GetBranch("eMu17Ele8CaloIdTPixelMatchFilter")
        #if not self.eMu17Ele8CaloIdTPixelMatchFilter_branch and "eMu17Ele8CaloIdTPixelMatchFilter" not in self.complained:
        if not self.eMu17Ele8CaloIdTPixelMatchFilter_branch and "eMu17Ele8CaloIdTPixelMatchFilter":
            warnings.warn( "EGTree: Expected branch eMu17Ele8CaloIdTPixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMu17Ele8CaloIdTPixelMatchFilter")
        else:
            self.eMu17Ele8CaloIdTPixelMatchFilter_branch.SetAddress(<void*>&self.eMu17Ele8CaloIdTPixelMatchFilter_value)

        #print "making eMu17Ele8dZFilter"
        self.eMu17Ele8dZFilter_branch = the_tree.GetBranch("eMu17Ele8dZFilter")
        #if not self.eMu17Ele8dZFilter_branch and "eMu17Ele8dZFilter" not in self.complained:
        if not self.eMu17Ele8dZFilter_branch and "eMu17Ele8dZFilter":
            warnings.warn( "EGTree: Expected branch eMu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMu17Ele8dZFilter")
        else:
            self.eMu17Ele8dZFilter_branch.SetAddress(<void*>&self.eMu17Ele8dZFilter_value)

        #print "making eNearMuonVeto"
        self.eNearMuonVeto_branch = the_tree.GetBranch("eNearMuonVeto")
        #if not self.eNearMuonVeto_branch and "eNearMuonVeto" not in self.complained:
        if not self.eNearMuonVeto_branch and "eNearMuonVeto":
            warnings.warn( "EGTree: Expected branch eNearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearMuonVeto")
        else:
            self.eNearMuonVeto_branch.SetAddress(<void*>&self.eNearMuonVeto_value)

        #print "making ePFChargedIso"
        self.ePFChargedIso_branch = the_tree.GetBranch("ePFChargedIso")
        #if not self.ePFChargedIso_branch and "ePFChargedIso" not in self.complained:
        if not self.ePFChargedIso_branch and "ePFChargedIso":
            warnings.warn( "EGTree: Expected branch ePFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFChargedIso")
        else:
            self.ePFChargedIso_branch.SetAddress(<void*>&self.ePFChargedIso_value)

        #print "making ePFNeutralIso"
        self.ePFNeutralIso_branch = the_tree.GetBranch("ePFNeutralIso")
        #if not self.ePFNeutralIso_branch and "ePFNeutralIso" not in self.complained:
        if not self.ePFNeutralIso_branch and "ePFNeutralIso":
            warnings.warn( "EGTree: Expected branch ePFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFNeutralIso")
        else:
            self.ePFNeutralIso_branch.SetAddress(<void*>&self.ePFNeutralIso_value)

        #print "making ePFPhotonIso"
        self.ePFPhotonIso_branch = the_tree.GetBranch("ePFPhotonIso")
        #if not self.ePFPhotonIso_branch and "ePFPhotonIso" not in self.complained:
        if not self.ePFPhotonIso_branch and "ePFPhotonIso":
            warnings.warn( "EGTree: Expected branch ePFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFPhotonIso")
        else:
            self.ePFPhotonIso_branch.SetAddress(<void*>&self.ePFPhotonIso_value)

        #print "making ePVDXY"
        self.ePVDXY_branch = the_tree.GetBranch("ePVDXY")
        #if not self.ePVDXY_branch and "ePVDXY" not in self.complained:
        if not self.ePVDXY_branch and "ePVDXY":
            warnings.warn( "EGTree: Expected branch ePVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDXY")
        else:
            self.ePVDXY_branch.SetAddress(<void*>&self.ePVDXY_value)

        #print "making ePVDZ"
        self.ePVDZ_branch = the_tree.GetBranch("ePVDZ")
        #if not self.ePVDZ_branch and "ePVDZ" not in self.complained:
        if not self.ePVDZ_branch and "ePVDZ":
            warnings.warn( "EGTree: Expected branch ePVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDZ")
        else:
            self.ePVDZ_branch.SetAddress(<void*>&self.ePVDZ_value)

        #print "making ePhi"
        self.ePhi_branch = the_tree.GetBranch("ePhi")
        #if not self.ePhi_branch and "ePhi" not in self.complained:
        if not self.ePhi_branch and "ePhi":
            warnings.warn( "EGTree: Expected branch ePhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhi")
        else:
            self.ePhi_branch.SetAddress(<void*>&self.ePhi_value)

        #print "making ePhiCorrReg_2012Jul13ReReco"
        self.ePhiCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePhiCorrReg_2012Jul13ReReco")
        #if not self.ePhiCorrReg_2012Jul13ReReco_branch and "ePhiCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.ePhiCorrReg_2012Jul13ReReco_branch and "ePhiCorrReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch ePhiCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_2012Jul13ReReco")
        else:
            self.ePhiCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePhiCorrReg_2012Jul13ReReco_value)

        #print "making ePhiCorrReg_Fall11"
        self.ePhiCorrReg_Fall11_branch = the_tree.GetBranch("ePhiCorrReg_Fall11")
        #if not self.ePhiCorrReg_Fall11_branch and "ePhiCorrReg_Fall11" not in self.complained:
        if not self.ePhiCorrReg_Fall11_branch and "ePhiCorrReg_Fall11":
            warnings.warn( "EGTree: Expected branch ePhiCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_Fall11")
        else:
            self.ePhiCorrReg_Fall11_branch.SetAddress(<void*>&self.ePhiCorrReg_Fall11_value)

        #print "making ePhiCorrReg_Jan16ReReco"
        self.ePhiCorrReg_Jan16ReReco_branch = the_tree.GetBranch("ePhiCorrReg_Jan16ReReco")
        #if not self.ePhiCorrReg_Jan16ReReco_branch and "ePhiCorrReg_Jan16ReReco" not in self.complained:
        if not self.ePhiCorrReg_Jan16ReReco_branch and "ePhiCorrReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch ePhiCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_Jan16ReReco")
        else:
            self.ePhiCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePhiCorrReg_Jan16ReReco_value)

        #print "making ePhiCorrReg_Summer12_DR53X_HCP2012"
        self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePhiCorrReg_Summer12_DR53X_HCP2012")
        #if not self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch ePhiCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePhiCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making ePhiCorrSmearedNoReg_2012Jul13ReReco"
        self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch and "ePhiCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch and "ePhiCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch ePhiCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making ePhiCorrSmearedNoReg_Fall11"
        self.ePhiCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_Fall11")
        #if not self.ePhiCorrSmearedNoReg_Fall11_branch and "ePhiCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_Fall11_branch and "ePhiCorrSmearedNoReg_Fall11":
            warnings.warn( "EGTree: Expected branch ePhiCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_Fall11")
        else:
            self.ePhiCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_Fall11_value)

        #print "making ePhiCorrSmearedNoReg_Jan16ReReco"
        self.ePhiCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_Jan16ReReco")
        #if not self.ePhiCorrSmearedNoReg_Jan16ReReco_branch and "ePhiCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_Jan16ReReco_branch and "ePhiCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch ePhiCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_Jan16ReReco")
        else:
            self.ePhiCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_Jan16ReReco_value)

        #print "making ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making ePhiCorrSmearedReg_2012Jul13ReReco"
        self.ePhiCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedReg_2012Jul13ReReco")
        #if not self.ePhiCorrSmearedReg_2012Jul13ReReco_branch and "ePhiCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.ePhiCorrSmearedReg_2012Jul13ReReco_branch and "ePhiCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch ePhiCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_2012Jul13ReReco")
        else:
            self.ePhiCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_2012Jul13ReReco_value)

        #print "making ePhiCorrSmearedReg_Fall11"
        self.ePhiCorrSmearedReg_Fall11_branch = the_tree.GetBranch("ePhiCorrSmearedReg_Fall11")
        #if not self.ePhiCorrSmearedReg_Fall11_branch and "ePhiCorrSmearedReg_Fall11" not in self.complained:
        if not self.ePhiCorrSmearedReg_Fall11_branch and "ePhiCorrSmearedReg_Fall11":
            warnings.warn( "EGTree: Expected branch ePhiCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_Fall11")
        else:
            self.ePhiCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_Fall11_value)

        #print "making ePhiCorrSmearedReg_Jan16ReReco"
        self.ePhiCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedReg_Jan16ReReco")
        #if not self.ePhiCorrSmearedReg_Jan16ReReco_branch and "ePhiCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.ePhiCorrSmearedReg_Jan16ReReco_branch and "ePhiCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch ePhiCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_Jan16ReReco")
        else:
            self.ePhiCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_Jan16ReReco_value)

        #print "making ePhiCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch ePhiCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making ePt"
        self.ePt_branch = the_tree.GetBranch("ePt")
        #if not self.ePt_branch and "ePt" not in self.complained:
        if not self.ePt_branch and "ePt":
            warnings.warn( "EGTree: Expected branch ePt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt")
        else:
            self.ePt_branch.SetAddress(<void*>&self.ePt_value)

        #print "making ePtCorrReg_2012Jul13ReReco"
        self.ePtCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePtCorrReg_2012Jul13ReReco")
        #if not self.ePtCorrReg_2012Jul13ReReco_branch and "ePtCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.ePtCorrReg_2012Jul13ReReco_branch and "ePtCorrReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch ePtCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_2012Jul13ReReco")
        else:
            self.ePtCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePtCorrReg_2012Jul13ReReco_value)

        #print "making ePtCorrReg_Fall11"
        self.ePtCorrReg_Fall11_branch = the_tree.GetBranch("ePtCorrReg_Fall11")
        #if not self.ePtCorrReg_Fall11_branch and "ePtCorrReg_Fall11" not in self.complained:
        if not self.ePtCorrReg_Fall11_branch and "ePtCorrReg_Fall11":
            warnings.warn( "EGTree: Expected branch ePtCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_Fall11")
        else:
            self.ePtCorrReg_Fall11_branch.SetAddress(<void*>&self.ePtCorrReg_Fall11_value)

        #print "making ePtCorrReg_Jan16ReReco"
        self.ePtCorrReg_Jan16ReReco_branch = the_tree.GetBranch("ePtCorrReg_Jan16ReReco")
        #if not self.ePtCorrReg_Jan16ReReco_branch and "ePtCorrReg_Jan16ReReco" not in self.complained:
        if not self.ePtCorrReg_Jan16ReReco_branch and "ePtCorrReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch ePtCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_Jan16ReReco")
        else:
            self.ePtCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePtCorrReg_Jan16ReReco_value)

        #print "making ePtCorrReg_Summer12_DR53X_HCP2012"
        self.ePtCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePtCorrReg_Summer12_DR53X_HCP2012")
        #if not self.ePtCorrReg_Summer12_DR53X_HCP2012_branch and "ePtCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePtCorrReg_Summer12_DR53X_HCP2012_branch and "ePtCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch ePtCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.ePtCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePtCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making ePtCorrSmearedNoReg_2012Jul13ReReco"
        self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch and "ePtCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch and "ePtCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch ePtCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making ePtCorrSmearedNoReg_Fall11"
        self.ePtCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_Fall11")
        #if not self.ePtCorrSmearedNoReg_Fall11_branch and "ePtCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.ePtCorrSmearedNoReg_Fall11_branch and "ePtCorrSmearedNoReg_Fall11":
            warnings.warn( "EGTree: Expected branch ePtCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_Fall11")
        else:
            self.ePtCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_Fall11_value)

        #print "making ePtCorrSmearedNoReg_Jan16ReReco"
        self.ePtCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_Jan16ReReco")
        #if not self.ePtCorrSmearedNoReg_Jan16ReReco_branch and "ePtCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.ePtCorrSmearedNoReg_Jan16ReReco_branch and "ePtCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch ePtCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_Jan16ReReco")
        else:
            self.ePtCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_Jan16ReReco_value)

        #print "making ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making ePtCorrSmearedReg_2012Jul13ReReco"
        self.ePtCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePtCorrSmearedReg_2012Jul13ReReco")
        #if not self.ePtCorrSmearedReg_2012Jul13ReReco_branch and "ePtCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.ePtCorrSmearedReg_2012Jul13ReReco_branch and "ePtCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch ePtCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_2012Jul13ReReco")
        else:
            self.ePtCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_2012Jul13ReReco_value)

        #print "making ePtCorrSmearedReg_Fall11"
        self.ePtCorrSmearedReg_Fall11_branch = the_tree.GetBranch("ePtCorrSmearedReg_Fall11")
        #if not self.ePtCorrSmearedReg_Fall11_branch and "ePtCorrSmearedReg_Fall11" not in self.complained:
        if not self.ePtCorrSmearedReg_Fall11_branch and "ePtCorrSmearedReg_Fall11":
            warnings.warn( "EGTree: Expected branch ePtCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_Fall11")
        else:
            self.ePtCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_Fall11_value)

        #print "making ePtCorrSmearedReg_Jan16ReReco"
        self.ePtCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("ePtCorrSmearedReg_Jan16ReReco")
        #if not self.ePtCorrSmearedReg_Jan16ReReco_branch and "ePtCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.ePtCorrSmearedReg_Jan16ReReco_branch and "ePtCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch ePtCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_Jan16ReReco")
        else:
            self.ePtCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_Jan16ReReco_value)

        #print "making ePtCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePtCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch ePtCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making eRank"
        self.eRank_branch = the_tree.GetBranch("eRank")
        #if not self.eRank_branch and "eRank" not in self.complained:
        if not self.eRank_branch and "eRank":
            warnings.warn( "EGTree: Expected branch eRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRank")
        else:
            self.eRank_branch.SetAddress(<void*>&self.eRank_value)

        #print "making eRelIso"
        self.eRelIso_branch = the_tree.GetBranch("eRelIso")
        #if not self.eRelIso_branch and "eRelIso" not in self.complained:
        if not self.eRelIso_branch and "eRelIso":
            warnings.warn( "EGTree: Expected branch eRelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelIso")
        else:
            self.eRelIso_branch.SetAddress(<void*>&self.eRelIso_value)

        #print "making eRelPFIsoDB"
        self.eRelPFIsoDB_branch = the_tree.GetBranch("eRelPFIsoDB")
        #if not self.eRelPFIsoDB_branch and "eRelPFIsoDB" not in self.complained:
        if not self.eRelPFIsoDB_branch and "eRelPFIsoDB":
            warnings.warn( "EGTree: Expected branch eRelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoDB")
        else:
            self.eRelPFIsoDB_branch.SetAddress(<void*>&self.eRelPFIsoDB_value)

        #print "making eRelPFIsoRho"
        self.eRelPFIsoRho_branch = the_tree.GetBranch("eRelPFIsoRho")
        #if not self.eRelPFIsoRho_branch and "eRelPFIsoRho" not in self.complained:
        if not self.eRelPFIsoRho_branch and "eRelPFIsoRho":
            warnings.warn( "EGTree: Expected branch eRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRho")
        else:
            self.eRelPFIsoRho_branch.SetAddress(<void*>&self.eRelPFIsoRho_value)

        #print "making eRelPFIsoRhoFSR"
        self.eRelPFIsoRhoFSR_branch = the_tree.GetBranch("eRelPFIsoRhoFSR")
        #if not self.eRelPFIsoRhoFSR_branch and "eRelPFIsoRhoFSR" not in self.complained:
        if not self.eRelPFIsoRhoFSR_branch and "eRelPFIsoRhoFSR":
            warnings.warn( "EGTree: Expected branch eRelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRhoFSR")
        else:
            self.eRelPFIsoRhoFSR_branch.SetAddress(<void*>&self.eRelPFIsoRhoFSR_value)

        #print "making eRhoHZG2011"
        self.eRhoHZG2011_branch = the_tree.GetBranch("eRhoHZG2011")
        #if not self.eRhoHZG2011_branch and "eRhoHZG2011" not in self.complained:
        if not self.eRhoHZG2011_branch and "eRhoHZG2011":
            warnings.warn( "EGTree: Expected branch eRhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRhoHZG2011")
        else:
            self.eRhoHZG2011_branch.SetAddress(<void*>&self.eRhoHZG2011_value)

        #print "making eRhoHZG2012"
        self.eRhoHZG2012_branch = the_tree.GetBranch("eRhoHZG2012")
        #if not self.eRhoHZG2012_branch and "eRhoHZG2012" not in self.complained:
        if not self.eRhoHZG2012_branch and "eRhoHZG2012":
            warnings.warn( "EGTree: Expected branch eRhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRhoHZG2012")
        else:
            self.eRhoHZG2012_branch.SetAddress(<void*>&self.eRhoHZG2012_value)

        #print "making eSCEnergy"
        self.eSCEnergy_branch = the_tree.GetBranch("eSCEnergy")
        #if not self.eSCEnergy_branch and "eSCEnergy" not in self.complained:
        if not self.eSCEnergy_branch and "eSCEnergy":
            warnings.warn( "EGTree: Expected branch eSCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEnergy")
        else:
            self.eSCEnergy_branch.SetAddress(<void*>&self.eSCEnergy_value)

        #print "making eSCEta"
        self.eSCEta_branch = the_tree.GetBranch("eSCEta")
        #if not self.eSCEta_branch and "eSCEta" not in self.complained:
        if not self.eSCEta_branch and "eSCEta":
            warnings.warn( "EGTree: Expected branch eSCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEta")
        else:
            self.eSCEta_branch.SetAddress(<void*>&self.eSCEta_value)

        #print "making eSCEtaWidth"
        self.eSCEtaWidth_branch = the_tree.GetBranch("eSCEtaWidth")
        #if not self.eSCEtaWidth_branch and "eSCEtaWidth" not in self.complained:
        if not self.eSCEtaWidth_branch and "eSCEtaWidth":
            warnings.warn( "EGTree: Expected branch eSCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEtaWidth")
        else:
            self.eSCEtaWidth_branch.SetAddress(<void*>&self.eSCEtaWidth_value)

        #print "making eSCPhi"
        self.eSCPhi_branch = the_tree.GetBranch("eSCPhi")
        #if not self.eSCPhi_branch and "eSCPhi" not in self.complained:
        if not self.eSCPhi_branch and "eSCPhi":
            warnings.warn( "EGTree: Expected branch eSCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhi")
        else:
            self.eSCPhi_branch.SetAddress(<void*>&self.eSCPhi_value)

        #print "making eSCPhiWidth"
        self.eSCPhiWidth_branch = the_tree.GetBranch("eSCPhiWidth")
        #if not self.eSCPhiWidth_branch and "eSCPhiWidth" not in self.complained:
        if not self.eSCPhiWidth_branch and "eSCPhiWidth":
            warnings.warn( "EGTree: Expected branch eSCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhiWidth")
        else:
            self.eSCPhiWidth_branch.SetAddress(<void*>&self.eSCPhiWidth_value)

        #print "making eSCPreshowerEnergy"
        self.eSCPreshowerEnergy_branch = the_tree.GetBranch("eSCPreshowerEnergy")
        #if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy" not in self.complained:
        if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy":
            warnings.warn( "EGTree: Expected branch eSCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPreshowerEnergy")
        else:
            self.eSCPreshowerEnergy_branch.SetAddress(<void*>&self.eSCPreshowerEnergy_value)

        #print "making eSCRawEnergy"
        self.eSCRawEnergy_branch = the_tree.GetBranch("eSCRawEnergy")
        #if not self.eSCRawEnergy_branch and "eSCRawEnergy" not in self.complained:
        if not self.eSCRawEnergy_branch and "eSCRawEnergy":
            warnings.warn( "EGTree: Expected branch eSCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCRawEnergy")
        else:
            self.eSCRawEnergy_branch.SetAddress(<void*>&self.eSCRawEnergy_value)

        #print "making eSigmaIEtaIEta"
        self.eSigmaIEtaIEta_branch = the_tree.GetBranch("eSigmaIEtaIEta")
        #if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta" not in self.complained:
        if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta":
            warnings.warn( "EGTree: Expected branch eSigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSigmaIEtaIEta")
        else:
            self.eSigmaIEtaIEta_branch.SetAddress(<void*>&self.eSigmaIEtaIEta_value)

        #print "making eToMETDPhi"
        self.eToMETDPhi_branch = the_tree.GetBranch("eToMETDPhi")
        #if not self.eToMETDPhi_branch and "eToMETDPhi" not in self.complained:
        if not self.eToMETDPhi_branch and "eToMETDPhi":
            warnings.warn( "EGTree: Expected branch eToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eToMETDPhi")
        else:
            self.eToMETDPhi_branch.SetAddress(<void*>&self.eToMETDPhi_value)

        #print "making eTrkIsoDR03"
        self.eTrkIsoDR03_branch = the_tree.GetBranch("eTrkIsoDR03")
        #if not self.eTrkIsoDR03_branch and "eTrkIsoDR03" not in self.complained:
        if not self.eTrkIsoDR03_branch and "eTrkIsoDR03":
            warnings.warn( "EGTree: Expected branch eTrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTrkIsoDR03")
        else:
            self.eTrkIsoDR03_branch.SetAddress(<void*>&self.eTrkIsoDR03_value)

        #print "making eVZ"
        self.eVZ_branch = the_tree.GetBranch("eVZ")
        #if not self.eVZ_branch and "eVZ" not in self.complained:
        if not self.eVZ_branch and "eVZ":
            warnings.warn( "EGTree: Expected branch eVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVZ")
        else:
            self.eVZ_branch.SetAddress(<void*>&self.eVZ_value)

        #print "making eVetoCicTightIso"
        self.eVetoCicTightIso_branch = the_tree.GetBranch("eVetoCicTightIso")
        #if not self.eVetoCicTightIso_branch and "eVetoCicTightIso" not in self.complained:
        if not self.eVetoCicTightIso_branch and "eVetoCicTightIso":
            warnings.warn( "EGTree: Expected branch eVetoCicTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso")
        else:
            self.eVetoCicTightIso_branch.SetAddress(<void*>&self.eVetoCicTightIso_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "EGTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "EGTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eWWID"
        self.eWWID_branch = the_tree.GetBranch("eWWID")
        #if not self.eWWID_branch and "eWWID" not in self.complained:
        if not self.eWWID_branch and "eWWID":
            warnings.warn( "EGTree: Expected branch eWWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eWWID")
        else:
            self.eWWID_branch.SetAddress(<void*>&self.eWWID_value)

        #print "making e_g_CosThetaStar"
        self.e_g_CosThetaStar_branch = the_tree.GetBranch("e_g_CosThetaStar")
        #if not self.e_g_CosThetaStar_branch and "e_g_CosThetaStar" not in self.complained:
        if not self.e_g_CosThetaStar_branch and "e_g_CosThetaStar":
            warnings.warn( "EGTree: Expected branch e_g_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_g_CosThetaStar")
        else:
            self.e_g_CosThetaStar_branch.SetAddress(<void*>&self.e_g_CosThetaStar_value)

        #print "making e_g_DPhi"
        self.e_g_DPhi_branch = the_tree.GetBranch("e_g_DPhi")
        #if not self.e_g_DPhi_branch and "e_g_DPhi" not in self.complained:
        if not self.e_g_DPhi_branch and "e_g_DPhi":
            warnings.warn( "EGTree: Expected branch e_g_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_g_DPhi")
        else:
            self.e_g_DPhi_branch.SetAddress(<void*>&self.e_g_DPhi_value)

        #print "making e_g_DR"
        self.e_g_DR_branch = the_tree.GetBranch("e_g_DR")
        #if not self.e_g_DR_branch and "e_g_DR" not in self.complained:
        if not self.e_g_DR_branch and "e_g_DR":
            warnings.warn( "EGTree: Expected branch e_g_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_g_DR")
        else:
            self.e_g_DR_branch.SetAddress(<void*>&self.e_g_DR_value)

        #print "making e_g_Mass"
        self.e_g_Mass_branch = the_tree.GetBranch("e_g_Mass")
        #if not self.e_g_Mass_branch and "e_g_Mass" not in self.complained:
        if not self.e_g_Mass_branch and "e_g_Mass":
            warnings.warn( "EGTree: Expected branch e_g_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_g_Mass")
        else:
            self.e_g_Mass_branch.SetAddress(<void*>&self.e_g_Mass_value)

        #print "making e_g_MassFsr"
        self.e_g_MassFsr_branch = the_tree.GetBranch("e_g_MassFsr")
        #if not self.e_g_MassFsr_branch and "e_g_MassFsr" not in self.complained:
        if not self.e_g_MassFsr_branch and "e_g_MassFsr":
            warnings.warn( "EGTree: Expected branch e_g_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_g_MassFsr")
        else:
            self.e_g_MassFsr_branch.SetAddress(<void*>&self.e_g_MassFsr_value)

        #print "making e_g_PZeta"
        self.e_g_PZeta_branch = the_tree.GetBranch("e_g_PZeta")
        #if not self.e_g_PZeta_branch and "e_g_PZeta" not in self.complained:
        if not self.e_g_PZeta_branch and "e_g_PZeta":
            warnings.warn( "EGTree: Expected branch e_g_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_g_PZeta")
        else:
            self.e_g_PZeta_branch.SetAddress(<void*>&self.e_g_PZeta_value)

        #print "making e_g_PZetaVis"
        self.e_g_PZetaVis_branch = the_tree.GetBranch("e_g_PZetaVis")
        #if not self.e_g_PZetaVis_branch and "e_g_PZetaVis" not in self.complained:
        if not self.e_g_PZetaVis_branch and "e_g_PZetaVis":
            warnings.warn( "EGTree: Expected branch e_g_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_g_PZetaVis")
        else:
            self.e_g_PZetaVis_branch.SetAddress(<void*>&self.e_g_PZetaVis_value)

        #print "making e_g_Pt"
        self.e_g_Pt_branch = the_tree.GetBranch("e_g_Pt")
        #if not self.e_g_Pt_branch and "e_g_Pt" not in self.complained:
        if not self.e_g_Pt_branch and "e_g_Pt":
            warnings.warn( "EGTree: Expected branch e_g_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_g_Pt")
        else:
            self.e_g_Pt_branch.SetAddress(<void*>&self.e_g_Pt_value)

        #print "making e_g_PtFsr"
        self.e_g_PtFsr_branch = the_tree.GetBranch("e_g_PtFsr")
        #if not self.e_g_PtFsr_branch and "e_g_PtFsr" not in self.complained:
        if not self.e_g_PtFsr_branch and "e_g_PtFsr":
            warnings.warn( "EGTree: Expected branch e_g_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_g_PtFsr")
        else:
            self.e_g_PtFsr_branch.SetAddress(<void*>&self.e_g_PtFsr_value)

        #print "making e_g_SS"
        self.e_g_SS_branch = the_tree.GetBranch("e_g_SS")
        #if not self.e_g_SS_branch and "e_g_SS" not in self.complained:
        if not self.e_g_SS_branch and "e_g_SS":
            warnings.warn( "EGTree: Expected branch e_g_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_g_SS")
        else:
            self.e_g_SS_branch.SetAddress(<void*>&self.e_g_SS_value)

        #print "making e_g_ToMETDPhi_Ty1"
        self.e_g_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e_g_ToMETDPhi_Ty1")
        #if not self.e_g_ToMETDPhi_Ty1_branch and "e_g_ToMETDPhi_Ty1" not in self.complained:
        if not self.e_g_ToMETDPhi_Ty1_branch and "e_g_ToMETDPhi_Ty1":
            warnings.warn( "EGTree: Expected branch e_g_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_g_ToMETDPhi_Ty1")
        else:
            self.e_g_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e_g_ToMETDPhi_Ty1_value)

        #print "making e_g_Zcompat"
        self.e_g_Zcompat_branch = the_tree.GetBranch("e_g_Zcompat")
        #if not self.e_g_Zcompat_branch and "e_g_Zcompat" not in self.complained:
        if not self.e_g_Zcompat_branch and "e_g_Zcompat":
            warnings.warn( "EGTree: Expected branch e_g_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_g_Zcompat")
        else:
            self.e_g_Zcompat_branch.SetAddress(<void*>&self.e_g_Zcompat_value)

        #print "making edECorrReg_2012Jul13ReReco"
        self.edECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("edECorrReg_2012Jul13ReReco")
        #if not self.edECorrReg_2012Jul13ReReco_branch and "edECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.edECorrReg_2012Jul13ReReco_branch and "edECorrReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch edECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_2012Jul13ReReco")
        else:
            self.edECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.edECorrReg_2012Jul13ReReco_value)

        #print "making edECorrReg_Fall11"
        self.edECorrReg_Fall11_branch = the_tree.GetBranch("edECorrReg_Fall11")
        #if not self.edECorrReg_Fall11_branch and "edECorrReg_Fall11" not in self.complained:
        if not self.edECorrReg_Fall11_branch and "edECorrReg_Fall11":
            warnings.warn( "EGTree: Expected branch edECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_Fall11")
        else:
            self.edECorrReg_Fall11_branch.SetAddress(<void*>&self.edECorrReg_Fall11_value)

        #print "making edECorrReg_Jan16ReReco"
        self.edECorrReg_Jan16ReReco_branch = the_tree.GetBranch("edECorrReg_Jan16ReReco")
        #if not self.edECorrReg_Jan16ReReco_branch and "edECorrReg_Jan16ReReco" not in self.complained:
        if not self.edECorrReg_Jan16ReReco_branch and "edECorrReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch edECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_Jan16ReReco")
        else:
            self.edECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.edECorrReg_Jan16ReReco_value)

        #print "making edECorrReg_Summer12_DR53X_HCP2012"
        self.edECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("edECorrReg_Summer12_DR53X_HCP2012")
        #if not self.edECorrReg_Summer12_DR53X_HCP2012_branch and "edECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.edECorrReg_Summer12_DR53X_HCP2012_branch and "edECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch edECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.edECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.edECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making edECorrSmearedNoReg_2012Jul13ReReco"
        self.edECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("edECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.edECorrSmearedNoReg_2012Jul13ReReco_branch and "edECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.edECorrSmearedNoReg_2012Jul13ReReco_branch and "edECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch edECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.edECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making edECorrSmearedNoReg_Fall11"
        self.edECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("edECorrSmearedNoReg_Fall11")
        #if not self.edECorrSmearedNoReg_Fall11_branch and "edECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.edECorrSmearedNoReg_Fall11_branch and "edECorrSmearedNoReg_Fall11":
            warnings.warn( "EGTree: Expected branch edECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_Fall11")
        else:
            self.edECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_Fall11_value)

        #print "making edECorrSmearedNoReg_Jan16ReReco"
        self.edECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("edECorrSmearedNoReg_Jan16ReReco")
        #if not self.edECorrSmearedNoReg_Jan16ReReco_branch and "edECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.edECorrSmearedNoReg_Jan16ReReco_branch and "edECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch edECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_Jan16ReReco")
        else:
            self.edECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_Jan16ReReco_value)

        #print "making edECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("edECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch edECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making edECorrSmearedReg_2012Jul13ReReco"
        self.edECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("edECorrSmearedReg_2012Jul13ReReco")
        #if not self.edECorrSmearedReg_2012Jul13ReReco_branch and "edECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.edECorrSmearedReg_2012Jul13ReReco_branch and "edECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EGTree: Expected branch edECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_2012Jul13ReReco")
        else:
            self.edECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.edECorrSmearedReg_2012Jul13ReReco_value)

        #print "making edECorrSmearedReg_Fall11"
        self.edECorrSmearedReg_Fall11_branch = the_tree.GetBranch("edECorrSmearedReg_Fall11")
        #if not self.edECorrSmearedReg_Fall11_branch and "edECorrSmearedReg_Fall11" not in self.complained:
        if not self.edECorrSmearedReg_Fall11_branch and "edECorrSmearedReg_Fall11":
            warnings.warn( "EGTree: Expected branch edECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_Fall11")
        else:
            self.edECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.edECorrSmearedReg_Fall11_value)

        #print "making edECorrSmearedReg_Jan16ReReco"
        self.edECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("edECorrSmearedReg_Jan16ReReco")
        #if not self.edECorrSmearedReg_Jan16ReReco_branch and "edECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.edECorrSmearedReg_Jan16ReReco_branch and "edECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EGTree: Expected branch edECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_Jan16ReReco")
        else:
            self.edECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.edECorrSmearedReg_Jan16ReReco_value)

        #print "making edECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("edECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EGTree: Expected branch edECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.edECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making edeltaEtaSuperClusterTrackAtVtx"
        self.edeltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaEtaSuperClusterTrackAtVtx")
        #if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "EGTree: Expected branch edeltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaEtaSuperClusterTrackAtVtx")
        else:
            self.edeltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaEtaSuperClusterTrackAtVtx_value)

        #print "making edeltaPhiSuperClusterTrackAtVtx"
        self.edeltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaPhiSuperClusterTrackAtVtx")
        #if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "EGTree: Expected branch edeltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaPhiSuperClusterTrackAtVtx")
        else:
            self.edeltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaPhiSuperClusterTrackAtVtx_value)

        #print "making eeSuperClusterOverP"
        self.eeSuperClusterOverP_branch = the_tree.GetBranch("eeSuperClusterOverP")
        #if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP" not in self.complained:
        if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP":
            warnings.warn( "EGTree: Expected branch eeSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eeSuperClusterOverP")
        else:
            self.eeSuperClusterOverP_branch.SetAddress(<void*>&self.eeSuperClusterOverP_value)

        #print "making eecalEnergy"
        self.eecalEnergy_branch = the_tree.GetBranch("eecalEnergy")
        #if not self.eecalEnergy_branch and "eecalEnergy" not in self.complained:
        if not self.eecalEnergy_branch and "eecalEnergy":
            warnings.warn( "EGTree: Expected branch eecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eecalEnergy")
        else:
            self.eecalEnergy_branch.SetAddress(<void*>&self.eecalEnergy_value)

        #print "making efBrem"
        self.efBrem_branch = the_tree.GetBranch("efBrem")
        #if not self.efBrem_branch and "efBrem" not in self.complained:
        if not self.efBrem_branch and "efBrem":
            warnings.warn( "EGTree: Expected branch efBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("efBrem")
        else:
            self.efBrem_branch.SetAddress(<void*>&self.efBrem_value)

        #print "making etrackMomentumAtVtxP"
        self.etrackMomentumAtVtxP_branch = the_tree.GetBranch("etrackMomentumAtVtxP")
        #if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP" not in self.complained:
        if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP":
            warnings.warn( "EGTree: Expected branch etrackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("etrackMomentumAtVtxP")
        else:
            self.etrackMomentumAtVtxP_branch.SetAddress(<void*>&self.etrackMomentumAtVtxP_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "EGTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making gAbsEta"
        self.gAbsEta_branch = the_tree.GetBranch("gAbsEta")
        #if not self.gAbsEta_branch and "gAbsEta" not in self.complained:
        if not self.gAbsEta_branch and "gAbsEta":
            warnings.warn( "EGTree: Expected branch gAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gAbsEta")
        else:
            self.gAbsEta_branch.SetAddress(<void*>&self.gAbsEta_value)

        #print "making gCBID_LOOSE"
        self.gCBID_LOOSE_branch = the_tree.GetBranch("gCBID_LOOSE")
        #if not self.gCBID_LOOSE_branch and "gCBID_LOOSE" not in self.complained:
        if not self.gCBID_LOOSE_branch and "gCBID_LOOSE":
            warnings.warn( "EGTree: Expected branch gCBID_LOOSE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gCBID_LOOSE")
        else:
            self.gCBID_LOOSE_branch.SetAddress(<void*>&self.gCBID_LOOSE_value)

        #print "making gCBID_MEDIUM"
        self.gCBID_MEDIUM_branch = the_tree.GetBranch("gCBID_MEDIUM")
        #if not self.gCBID_MEDIUM_branch and "gCBID_MEDIUM" not in self.complained:
        if not self.gCBID_MEDIUM_branch and "gCBID_MEDIUM":
            warnings.warn( "EGTree: Expected branch gCBID_MEDIUM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gCBID_MEDIUM")
        else:
            self.gCBID_MEDIUM_branch.SetAddress(<void*>&self.gCBID_MEDIUM_value)

        #print "making gCBID_TIGHT"
        self.gCBID_TIGHT_branch = the_tree.GetBranch("gCBID_TIGHT")
        #if not self.gCBID_TIGHT_branch and "gCBID_TIGHT" not in self.complained:
        if not self.gCBID_TIGHT_branch and "gCBID_TIGHT":
            warnings.warn( "EGTree: Expected branch gCBID_TIGHT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gCBID_TIGHT")
        else:
            self.gCBID_TIGHT_branch.SetAddress(<void*>&self.gCBID_TIGHT_value)

        #print "making gCharge"
        self.gCharge_branch = the_tree.GetBranch("gCharge")
        #if not self.gCharge_branch and "gCharge" not in self.complained:
        if not self.gCharge_branch and "gCharge":
            warnings.warn( "EGTree: Expected branch gCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gCharge")
        else:
            self.gCharge_branch.SetAddress(<void*>&self.gCharge_value)

        #print "making gComesFromHiggs"
        self.gComesFromHiggs_branch = the_tree.GetBranch("gComesFromHiggs")
        #if not self.gComesFromHiggs_branch and "gComesFromHiggs" not in self.complained:
        if not self.gComesFromHiggs_branch and "gComesFromHiggs":
            warnings.warn( "EGTree: Expected branch gComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gComesFromHiggs")
        else:
            self.gComesFromHiggs_branch.SetAddress(<void*>&self.gComesFromHiggs_value)

        #print "making gConvSafeElectronVeto"
        self.gConvSafeElectronVeto_branch = the_tree.GetBranch("gConvSafeElectronVeto")
        #if not self.gConvSafeElectronVeto_branch and "gConvSafeElectronVeto" not in self.complained:
        if not self.gConvSafeElectronVeto_branch and "gConvSafeElectronVeto":
            warnings.warn( "EGTree: Expected branch gConvSafeElectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gConvSafeElectronVeto")
        else:
            self.gConvSafeElectronVeto_branch.SetAddress(<void*>&self.gConvSafeElectronVeto_value)

        #print "making gE1x5"
        self.gE1x5_branch = the_tree.GetBranch("gE1x5")
        #if not self.gE1x5_branch and "gE1x5" not in self.complained:
        if not self.gE1x5_branch and "gE1x5":
            warnings.warn( "EGTree: Expected branch gE1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gE1x5")
        else:
            self.gE1x5_branch.SetAddress(<void*>&self.gE1x5_value)

        #print "making gE2x5"
        self.gE2x5_branch = the_tree.GetBranch("gE2x5")
        #if not self.gE2x5_branch and "gE2x5" not in self.complained:
        if not self.gE2x5_branch and "gE2x5":
            warnings.warn( "EGTree: Expected branch gE2x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gE2x5")
        else:
            self.gE2x5_branch.SetAddress(<void*>&self.gE2x5_value)

        #print "making gE3x3"
        self.gE3x3_branch = the_tree.GetBranch("gE3x3")
        #if not self.gE3x3_branch and "gE3x3" not in self.complained:
        if not self.gE3x3_branch and "gE3x3":
            warnings.warn( "EGTree: Expected branch gE3x3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gE3x3")
        else:
            self.gE3x3_branch.SetAddress(<void*>&self.gE3x3_value)

        #print "making gE5x5"
        self.gE5x5_branch = the_tree.GetBranch("gE5x5")
        #if not self.gE5x5_branch and "gE5x5" not in self.complained:
        if not self.gE5x5_branch and "gE5x5":
            warnings.warn( "EGTree: Expected branch gE5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gE5x5")
        else:
            self.gE5x5_branch.SetAddress(<void*>&self.gE5x5_value)

        #print "making gECorrPHOSPHOR2011"
        self.gECorrPHOSPHOR2011_branch = the_tree.GetBranch("gECorrPHOSPHOR2011")
        #if not self.gECorrPHOSPHOR2011_branch and "gECorrPHOSPHOR2011" not in self.complained:
        if not self.gECorrPHOSPHOR2011_branch and "gECorrPHOSPHOR2011":
            warnings.warn( "EGTree: Expected branch gECorrPHOSPHOR2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gECorrPHOSPHOR2011")
        else:
            self.gECorrPHOSPHOR2011_branch.SetAddress(<void*>&self.gECorrPHOSPHOR2011_value)

        #print "making gECorrPHOSPHOR2012"
        self.gECorrPHOSPHOR2012_branch = the_tree.GetBranch("gECorrPHOSPHOR2012")
        #if not self.gECorrPHOSPHOR2012_branch and "gECorrPHOSPHOR2012" not in self.complained:
        if not self.gECorrPHOSPHOR2012_branch and "gECorrPHOSPHOR2012":
            warnings.warn( "EGTree: Expected branch gECorrPHOSPHOR2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gECorrPHOSPHOR2012")
        else:
            self.gECorrPHOSPHOR2012_branch.SetAddress(<void*>&self.gECorrPHOSPHOR2012_value)

        #print "making gEffectiveAreaCHad"
        self.gEffectiveAreaCHad_branch = the_tree.GetBranch("gEffectiveAreaCHad")
        #if not self.gEffectiveAreaCHad_branch and "gEffectiveAreaCHad" not in self.complained:
        if not self.gEffectiveAreaCHad_branch and "gEffectiveAreaCHad":
            warnings.warn( "EGTree: Expected branch gEffectiveAreaCHad does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gEffectiveAreaCHad")
        else:
            self.gEffectiveAreaCHad_branch.SetAddress(<void*>&self.gEffectiveAreaCHad_value)

        #print "making gEffectiveAreaNHad"
        self.gEffectiveAreaNHad_branch = the_tree.GetBranch("gEffectiveAreaNHad")
        #if not self.gEffectiveAreaNHad_branch and "gEffectiveAreaNHad" not in self.complained:
        if not self.gEffectiveAreaNHad_branch and "gEffectiveAreaNHad":
            warnings.warn( "EGTree: Expected branch gEffectiveAreaNHad does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gEffectiveAreaNHad")
        else:
            self.gEffectiveAreaNHad_branch.SetAddress(<void*>&self.gEffectiveAreaNHad_value)

        #print "making gEffectiveAreaPho"
        self.gEffectiveAreaPho_branch = the_tree.GetBranch("gEffectiveAreaPho")
        #if not self.gEffectiveAreaPho_branch and "gEffectiveAreaPho" not in self.complained:
        if not self.gEffectiveAreaPho_branch and "gEffectiveAreaPho":
            warnings.warn( "EGTree: Expected branch gEffectiveAreaPho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gEffectiveAreaPho")
        else:
            self.gEffectiveAreaPho_branch.SetAddress(<void*>&self.gEffectiveAreaPho_value)

        #print "making gEta"
        self.gEta_branch = the_tree.GetBranch("gEta")
        #if not self.gEta_branch and "gEta" not in self.complained:
        if not self.gEta_branch and "gEta":
            warnings.warn( "EGTree: Expected branch gEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gEta")
        else:
            self.gEta_branch.SetAddress(<void*>&self.gEta_value)

        #print "making gEtaCorrPHOSPHOR2011"
        self.gEtaCorrPHOSPHOR2011_branch = the_tree.GetBranch("gEtaCorrPHOSPHOR2011")
        #if not self.gEtaCorrPHOSPHOR2011_branch and "gEtaCorrPHOSPHOR2011" not in self.complained:
        if not self.gEtaCorrPHOSPHOR2011_branch and "gEtaCorrPHOSPHOR2011":
            warnings.warn( "EGTree: Expected branch gEtaCorrPHOSPHOR2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gEtaCorrPHOSPHOR2011")
        else:
            self.gEtaCorrPHOSPHOR2011_branch.SetAddress(<void*>&self.gEtaCorrPHOSPHOR2011_value)

        #print "making gEtaCorrPHOSPHOR2012"
        self.gEtaCorrPHOSPHOR2012_branch = the_tree.GetBranch("gEtaCorrPHOSPHOR2012")
        #if not self.gEtaCorrPHOSPHOR2012_branch and "gEtaCorrPHOSPHOR2012" not in self.complained:
        if not self.gEtaCorrPHOSPHOR2012_branch and "gEtaCorrPHOSPHOR2012":
            warnings.warn( "EGTree: Expected branch gEtaCorrPHOSPHOR2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gEtaCorrPHOSPHOR2012")
        else:
            self.gEtaCorrPHOSPHOR2012_branch.SetAddress(<void*>&self.gEtaCorrPHOSPHOR2012_value)

        #print "making gGenEnergy"
        self.gGenEnergy_branch = the_tree.GetBranch("gGenEnergy")
        #if not self.gGenEnergy_branch and "gGenEnergy" not in self.complained:
        if not self.gGenEnergy_branch and "gGenEnergy":
            warnings.warn( "EGTree: Expected branch gGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gGenEnergy")
        else:
            self.gGenEnergy_branch.SetAddress(<void*>&self.gGenEnergy_value)

        #print "making gGenGrandMotherPdgId"
        self.gGenGrandMotherPdgId_branch = the_tree.GetBranch("gGenGrandMotherPdgId")
        #if not self.gGenGrandMotherPdgId_branch and "gGenGrandMotherPdgId" not in self.complained:
        if not self.gGenGrandMotherPdgId_branch and "gGenGrandMotherPdgId":
            warnings.warn( "EGTree: Expected branch gGenGrandMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gGenGrandMotherPdgId")
        else:
            self.gGenGrandMotherPdgId_branch.SetAddress(<void*>&self.gGenGrandMotherPdgId_value)

        #print "making gGenMotherPdgId"
        self.gGenMotherPdgId_branch = the_tree.GetBranch("gGenMotherPdgId")
        #if not self.gGenMotherPdgId_branch and "gGenMotherPdgId" not in self.complained:
        if not self.gGenMotherPdgId_branch and "gGenMotherPdgId":
            warnings.warn( "EGTree: Expected branch gGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gGenMotherPdgId")
        else:
            self.gGenMotherPdgId_branch.SetAddress(<void*>&self.gGenMotherPdgId_value)

        #print "making gHadronicDepth1OverEm"
        self.gHadronicDepth1OverEm_branch = the_tree.GetBranch("gHadronicDepth1OverEm")
        #if not self.gHadronicDepth1OverEm_branch and "gHadronicDepth1OverEm" not in self.complained:
        if not self.gHadronicDepth1OverEm_branch and "gHadronicDepth1OverEm":
            warnings.warn( "EGTree: Expected branch gHadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gHadronicDepth1OverEm")
        else:
            self.gHadronicDepth1OverEm_branch.SetAddress(<void*>&self.gHadronicDepth1OverEm_value)

        #print "making gHadronicDepth2OverEm"
        self.gHadronicDepth2OverEm_branch = the_tree.GetBranch("gHadronicDepth2OverEm")
        #if not self.gHadronicDepth2OverEm_branch and "gHadronicDepth2OverEm" not in self.complained:
        if not self.gHadronicDepth2OverEm_branch and "gHadronicDepth2OverEm":
            warnings.warn( "EGTree: Expected branch gHadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gHadronicDepth2OverEm")
        else:
            self.gHadronicDepth2OverEm_branch.SetAddress(<void*>&self.gHadronicDepth2OverEm_value)

        #print "making gHadronicOverEM"
        self.gHadronicOverEM_branch = the_tree.GetBranch("gHadronicOverEM")
        #if not self.gHadronicOverEM_branch and "gHadronicOverEM" not in self.complained:
        if not self.gHadronicOverEM_branch and "gHadronicOverEM":
            warnings.warn( "EGTree: Expected branch gHadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gHadronicOverEM")
        else:
            self.gHadronicOverEM_branch.SetAddress(<void*>&self.gHadronicOverEM_value)

        #print "making gHasConversionTracks"
        self.gHasConversionTracks_branch = the_tree.GetBranch("gHasConversionTracks")
        #if not self.gHasConversionTracks_branch and "gHasConversionTracks" not in self.complained:
        if not self.gHasConversionTracks_branch and "gHasConversionTracks":
            warnings.warn( "EGTree: Expected branch gHasConversionTracks does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gHasConversionTracks")
        else:
            self.gHasConversionTracks_branch.SetAddress(<void*>&self.gHasConversionTracks_value)

        #print "making gHasPixelSeed"
        self.gHasPixelSeed_branch = the_tree.GetBranch("gHasPixelSeed")
        #if not self.gHasPixelSeed_branch and "gHasPixelSeed" not in self.complained:
        if not self.gHasPixelSeed_branch and "gHasPixelSeed":
            warnings.warn( "EGTree: Expected branch gHasPixelSeed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gHasPixelSeed")
        else:
            self.gHasPixelSeed_branch.SetAddress(<void*>&self.gHasPixelSeed_value)

        #print "making gIsEB"
        self.gIsEB_branch = the_tree.GetBranch("gIsEB")
        #if not self.gIsEB_branch and "gIsEB" not in self.complained:
        if not self.gIsEB_branch and "gIsEB":
            warnings.warn( "EGTree: Expected branch gIsEB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gIsEB")
        else:
            self.gIsEB_branch.SetAddress(<void*>&self.gIsEB_value)

        #print "making gIsEBEEGap"
        self.gIsEBEEGap_branch = the_tree.GetBranch("gIsEBEEGap")
        #if not self.gIsEBEEGap_branch and "gIsEBEEGap" not in self.complained:
        if not self.gIsEBEEGap_branch and "gIsEBEEGap":
            warnings.warn( "EGTree: Expected branch gIsEBEEGap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gIsEBEEGap")
        else:
            self.gIsEBEEGap_branch.SetAddress(<void*>&self.gIsEBEEGap_value)

        #print "making gIsEBEtaGap"
        self.gIsEBEtaGap_branch = the_tree.GetBranch("gIsEBEtaGap")
        #if not self.gIsEBEtaGap_branch and "gIsEBEtaGap" not in self.complained:
        if not self.gIsEBEtaGap_branch and "gIsEBEtaGap":
            warnings.warn( "EGTree: Expected branch gIsEBEtaGap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gIsEBEtaGap")
        else:
            self.gIsEBEtaGap_branch.SetAddress(<void*>&self.gIsEBEtaGap_value)

        #print "making gIsEBGap"
        self.gIsEBGap_branch = the_tree.GetBranch("gIsEBGap")
        #if not self.gIsEBGap_branch and "gIsEBGap" not in self.complained:
        if not self.gIsEBGap_branch and "gIsEBGap":
            warnings.warn( "EGTree: Expected branch gIsEBGap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gIsEBGap")
        else:
            self.gIsEBGap_branch.SetAddress(<void*>&self.gIsEBGap_value)

        #print "making gIsEBPhiGap"
        self.gIsEBPhiGap_branch = the_tree.GetBranch("gIsEBPhiGap")
        #if not self.gIsEBPhiGap_branch and "gIsEBPhiGap" not in self.complained:
        if not self.gIsEBPhiGap_branch and "gIsEBPhiGap":
            warnings.warn( "EGTree: Expected branch gIsEBPhiGap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gIsEBPhiGap")
        else:
            self.gIsEBPhiGap_branch.SetAddress(<void*>&self.gIsEBPhiGap_value)

        #print "making gIsEE"
        self.gIsEE_branch = the_tree.GetBranch("gIsEE")
        #if not self.gIsEE_branch and "gIsEE" not in self.complained:
        if not self.gIsEE_branch and "gIsEE":
            warnings.warn( "EGTree: Expected branch gIsEE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gIsEE")
        else:
            self.gIsEE_branch.SetAddress(<void*>&self.gIsEE_value)

        #print "making gIsEEDeeGap"
        self.gIsEEDeeGap_branch = the_tree.GetBranch("gIsEEDeeGap")
        #if not self.gIsEEDeeGap_branch and "gIsEEDeeGap" not in self.complained:
        if not self.gIsEEDeeGap_branch and "gIsEEDeeGap":
            warnings.warn( "EGTree: Expected branch gIsEEDeeGap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gIsEEDeeGap")
        else:
            self.gIsEEDeeGap_branch.SetAddress(<void*>&self.gIsEEDeeGap_value)

        #print "making gIsEEGap"
        self.gIsEEGap_branch = the_tree.GetBranch("gIsEEGap")
        #if not self.gIsEEGap_branch and "gIsEEGap" not in self.complained:
        if not self.gIsEEGap_branch and "gIsEEGap":
            warnings.warn( "EGTree: Expected branch gIsEEGap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gIsEEGap")
        else:
            self.gIsEEGap_branch.SetAddress(<void*>&self.gIsEEGap_value)

        #print "making gIsEERingGap"
        self.gIsEERingGap_branch = the_tree.GetBranch("gIsEERingGap")
        #if not self.gIsEERingGap_branch and "gIsEERingGap" not in self.complained:
        if not self.gIsEERingGap_branch and "gIsEERingGap":
            warnings.warn( "EGTree: Expected branch gIsEERingGap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gIsEERingGap")
        else:
            self.gIsEERingGap_branch.SetAddress(<void*>&self.gIsEERingGap_value)

        #print "making gIsPFlowPhoton"
        self.gIsPFlowPhoton_branch = the_tree.GetBranch("gIsPFlowPhoton")
        #if not self.gIsPFlowPhoton_branch and "gIsPFlowPhoton" not in self.complained:
        if not self.gIsPFlowPhoton_branch and "gIsPFlowPhoton":
            warnings.warn( "EGTree: Expected branch gIsPFlowPhoton does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gIsPFlowPhoton")
        else:
            self.gIsPFlowPhoton_branch.SetAddress(<void*>&self.gIsPFlowPhoton_value)

        #print "making gIsStandardPhoton"
        self.gIsStandardPhoton_branch = the_tree.GetBranch("gIsStandardPhoton")
        #if not self.gIsStandardPhoton_branch and "gIsStandardPhoton" not in self.complained:
        if not self.gIsStandardPhoton_branch and "gIsStandardPhoton":
            warnings.warn( "EGTree: Expected branch gIsStandardPhoton does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gIsStandardPhoton")
        else:
            self.gIsStandardPhoton_branch.SetAddress(<void*>&self.gIsStandardPhoton_value)

        #print "making gJetArea"
        self.gJetArea_branch = the_tree.GetBranch("gJetArea")
        #if not self.gJetArea_branch and "gJetArea" not in self.complained:
        if not self.gJetArea_branch and "gJetArea":
            warnings.warn( "EGTree: Expected branch gJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetArea")
        else:
            self.gJetArea_branch.SetAddress(<void*>&self.gJetArea_value)

        #print "making gJetBtag"
        self.gJetBtag_branch = the_tree.GetBranch("gJetBtag")
        #if not self.gJetBtag_branch and "gJetBtag" not in self.complained:
        if not self.gJetBtag_branch and "gJetBtag":
            warnings.warn( "EGTree: Expected branch gJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetBtag")
        else:
            self.gJetBtag_branch.SetAddress(<void*>&self.gJetBtag_value)

        #print "making gJetCSVBtag"
        self.gJetCSVBtag_branch = the_tree.GetBranch("gJetCSVBtag")
        #if not self.gJetCSVBtag_branch and "gJetCSVBtag" not in self.complained:
        if not self.gJetCSVBtag_branch and "gJetCSVBtag":
            warnings.warn( "EGTree: Expected branch gJetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetCSVBtag")
        else:
            self.gJetCSVBtag_branch.SetAddress(<void*>&self.gJetCSVBtag_value)

        #print "making gJetEtaEtaMoment"
        self.gJetEtaEtaMoment_branch = the_tree.GetBranch("gJetEtaEtaMoment")
        #if not self.gJetEtaEtaMoment_branch and "gJetEtaEtaMoment" not in self.complained:
        if not self.gJetEtaEtaMoment_branch and "gJetEtaEtaMoment":
            warnings.warn( "EGTree: Expected branch gJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetEtaEtaMoment")
        else:
            self.gJetEtaEtaMoment_branch.SetAddress(<void*>&self.gJetEtaEtaMoment_value)

        #print "making gJetEtaPhiMoment"
        self.gJetEtaPhiMoment_branch = the_tree.GetBranch("gJetEtaPhiMoment")
        #if not self.gJetEtaPhiMoment_branch and "gJetEtaPhiMoment" not in self.complained:
        if not self.gJetEtaPhiMoment_branch and "gJetEtaPhiMoment":
            warnings.warn( "EGTree: Expected branch gJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetEtaPhiMoment")
        else:
            self.gJetEtaPhiMoment_branch.SetAddress(<void*>&self.gJetEtaPhiMoment_value)

        #print "making gJetEtaPhiSpread"
        self.gJetEtaPhiSpread_branch = the_tree.GetBranch("gJetEtaPhiSpread")
        #if not self.gJetEtaPhiSpread_branch and "gJetEtaPhiSpread" not in self.complained:
        if not self.gJetEtaPhiSpread_branch and "gJetEtaPhiSpread":
            warnings.warn( "EGTree: Expected branch gJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetEtaPhiSpread")
        else:
            self.gJetEtaPhiSpread_branch.SetAddress(<void*>&self.gJetEtaPhiSpread_value)

        #print "making gJetPartonFlavour"
        self.gJetPartonFlavour_branch = the_tree.GetBranch("gJetPartonFlavour")
        #if not self.gJetPartonFlavour_branch and "gJetPartonFlavour" not in self.complained:
        if not self.gJetPartonFlavour_branch and "gJetPartonFlavour":
            warnings.warn( "EGTree: Expected branch gJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetPartonFlavour")
        else:
            self.gJetPartonFlavour_branch.SetAddress(<void*>&self.gJetPartonFlavour_value)

        #print "making gJetPhiPhiMoment"
        self.gJetPhiPhiMoment_branch = the_tree.GetBranch("gJetPhiPhiMoment")
        #if not self.gJetPhiPhiMoment_branch and "gJetPhiPhiMoment" not in self.complained:
        if not self.gJetPhiPhiMoment_branch and "gJetPhiPhiMoment":
            warnings.warn( "EGTree: Expected branch gJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetPhiPhiMoment")
        else:
            self.gJetPhiPhiMoment_branch.SetAddress(<void*>&self.gJetPhiPhiMoment_value)

        #print "making gJetPt"
        self.gJetPt_branch = the_tree.GetBranch("gJetPt")
        #if not self.gJetPt_branch and "gJetPt" not in self.complained:
        if not self.gJetPt_branch and "gJetPt":
            warnings.warn( "EGTree: Expected branch gJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetPt")
        else:
            self.gJetPt_branch.SetAddress(<void*>&self.gJetPt_value)

        #print "making gJetQGLikelihoodID"
        self.gJetQGLikelihoodID_branch = the_tree.GetBranch("gJetQGLikelihoodID")
        #if not self.gJetQGLikelihoodID_branch and "gJetQGLikelihoodID" not in self.complained:
        if not self.gJetQGLikelihoodID_branch and "gJetQGLikelihoodID":
            warnings.warn( "EGTree: Expected branch gJetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetQGLikelihoodID")
        else:
            self.gJetQGLikelihoodID_branch.SetAddress(<void*>&self.gJetQGLikelihoodID_value)

        #print "making gJetQGMVAID"
        self.gJetQGMVAID_branch = the_tree.GetBranch("gJetQGMVAID")
        #if not self.gJetQGMVAID_branch and "gJetQGMVAID" not in self.complained:
        if not self.gJetQGMVAID_branch and "gJetQGMVAID":
            warnings.warn( "EGTree: Expected branch gJetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetQGMVAID")
        else:
            self.gJetQGMVAID_branch.SetAddress(<void*>&self.gJetQGMVAID_value)

        #print "making gJetaxis1"
        self.gJetaxis1_branch = the_tree.GetBranch("gJetaxis1")
        #if not self.gJetaxis1_branch and "gJetaxis1" not in self.complained:
        if not self.gJetaxis1_branch and "gJetaxis1":
            warnings.warn( "EGTree: Expected branch gJetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetaxis1")
        else:
            self.gJetaxis1_branch.SetAddress(<void*>&self.gJetaxis1_value)

        #print "making gJetaxis2"
        self.gJetaxis2_branch = the_tree.GetBranch("gJetaxis2")
        #if not self.gJetaxis2_branch and "gJetaxis2" not in self.complained:
        if not self.gJetaxis2_branch and "gJetaxis2":
            warnings.warn( "EGTree: Expected branch gJetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetaxis2")
        else:
            self.gJetaxis2_branch.SetAddress(<void*>&self.gJetaxis2_value)

        #print "making gJetmult"
        self.gJetmult_branch = the_tree.GetBranch("gJetmult")
        #if not self.gJetmult_branch and "gJetmult" not in self.complained:
        if not self.gJetmult_branch and "gJetmult":
            warnings.warn( "EGTree: Expected branch gJetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetmult")
        else:
            self.gJetmult_branch.SetAddress(<void*>&self.gJetmult_value)

        #print "making gJetmultMLP"
        self.gJetmultMLP_branch = the_tree.GetBranch("gJetmultMLP")
        #if not self.gJetmultMLP_branch and "gJetmultMLP" not in self.complained:
        if not self.gJetmultMLP_branch and "gJetmultMLP":
            warnings.warn( "EGTree: Expected branch gJetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetmultMLP")
        else:
            self.gJetmultMLP_branch.SetAddress(<void*>&self.gJetmultMLP_value)

        #print "making gJetmultMLPQC"
        self.gJetmultMLPQC_branch = the_tree.GetBranch("gJetmultMLPQC")
        #if not self.gJetmultMLPQC_branch and "gJetmultMLPQC" not in self.complained:
        if not self.gJetmultMLPQC_branch and "gJetmultMLPQC":
            warnings.warn( "EGTree: Expected branch gJetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetmultMLPQC")
        else:
            self.gJetmultMLPQC_branch.SetAddress(<void*>&self.gJetmultMLPQC_value)

        #print "making gJetptD"
        self.gJetptD_branch = the_tree.GetBranch("gJetptD")
        #if not self.gJetptD_branch and "gJetptD" not in self.complained:
        if not self.gJetptD_branch and "gJetptD":
            warnings.warn( "EGTree: Expected branch gJetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gJetptD")
        else:
            self.gJetptD_branch.SetAddress(<void*>&self.gJetptD_value)

        #print "making gMass"
        self.gMass_branch = the_tree.GetBranch("gMass")
        #if not self.gMass_branch and "gMass" not in self.complained:
        if not self.gMass_branch and "gMass":
            warnings.warn( "EGTree: Expected branch gMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gMass")
        else:
            self.gMass_branch.SetAddress(<void*>&self.gMass_value)

        #print "making gMaxEnergyXtal"
        self.gMaxEnergyXtal_branch = the_tree.GetBranch("gMaxEnergyXtal")
        #if not self.gMaxEnergyXtal_branch and "gMaxEnergyXtal" not in self.complained:
        if not self.gMaxEnergyXtal_branch and "gMaxEnergyXtal":
            warnings.warn( "EGTree: Expected branch gMaxEnergyXtal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gMaxEnergyXtal")
        else:
            self.gMaxEnergyXtal_branch.SetAddress(<void*>&self.gMaxEnergyXtal_value)

        #print "making gMtToMET"
        self.gMtToMET_branch = the_tree.GetBranch("gMtToMET")
        #if not self.gMtToMET_branch and "gMtToMET" not in self.complained:
        if not self.gMtToMET_branch and "gMtToMET":
            warnings.warn( "EGTree: Expected branch gMtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gMtToMET")
        else:
            self.gMtToMET_branch.SetAddress(<void*>&self.gMtToMET_value)

        #print "making gMtToMVAMET"
        self.gMtToMVAMET_branch = the_tree.GetBranch("gMtToMVAMET")
        #if not self.gMtToMVAMET_branch and "gMtToMVAMET" not in self.complained:
        if not self.gMtToMVAMET_branch and "gMtToMVAMET":
            warnings.warn( "EGTree: Expected branch gMtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gMtToMVAMET")
        else:
            self.gMtToMVAMET_branch.SetAddress(<void*>&self.gMtToMVAMET_value)

        #print "making gMtToPFMET"
        self.gMtToPFMET_branch = the_tree.GetBranch("gMtToPFMET")
        #if not self.gMtToPFMET_branch and "gMtToPFMET" not in self.complained:
        if not self.gMtToPFMET_branch and "gMtToPFMET":
            warnings.warn( "EGTree: Expected branch gMtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gMtToPFMET")
        else:
            self.gMtToPFMET_branch.SetAddress(<void*>&self.gMtToPFMET_value)

        #print "making gMtToPfMet_Ty1"
        self.gMtToPfMet_Ty1_branch = the_tree.GetBranch("gMtToPfMet_Ty1")
        #if not self.gMtToPfMet_Ty1_branch and "gMtToPfMet_Ty1" not in self.complained:
        if not self.gMtToPfMet_Ty1_branch and "gMtToPfMet_Ty1":
            warnings.warn( "EGTree: Expected branch gMtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gMtToPfMet_Ty1")
        else:
            self.gMtToPfMet_Ty1_branch.SetAddress(<void*>&self.gMtToPfMet_Ty1_value)

        #print "making gMtToPfMet_jes"
        self.gMtToPfMet_jes_branch = the_tree.GetBranch("gMtToPfMet_jes")
        #if not self.gMtToPfMet_jes_branch and "gMtToPfMet_jes" not in self.complained:
        if not self.gMtToPfMet_jes_branch and "gMtToPfMet_jes":
            warnings.warn( "EGTree: Expected branch gMtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gMtToPfMet_jes")
        else:
            self.gMtToPfMet_jes_branch.SetAddress(<void*>&self.gMtToPfMet_jes_value)

        #print "making gMtToPfMet_mes"
        self.gMtToPfMet_mes_branch = the_tree.GetBranch("gMtToPfMet_mes")
        #if not self.gMtToPfMet_mes_branch and "gMtToPfMet_mes" not in self.complained:
        if not self.gMtToPfMet_mes_branch and "gMtToPfMet_mes":
            warnings.warn( "EGTree: Expected branch gMtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gMtToPfMet_mes")
        else:
            self.gMtToPfMet_mes_branch.SetAddress(<void*>&self.gMtToPfMet_mes_value)

        #print "making gMtToPfMet_tes"
        self.gMtToPfMet_tes_branch = the_tree.GetBranch("gMtToPfMet_tes")
        #if not self.gMtToPfMet_tes_branch and "gMtToPfMet_tes" not in self.complained:
        if not self.gMtToPfMet_tes_branch and "gMtToPfMet_tes":
            warnings.warn( "EGTree: Expected branch gMtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gMtToPfMet_tes")
        else:
            self.gMtToPfMet_tes_branch.SetAddress(<void*>&self.gMtToPfMet_tes_value)

        #print "making gMtToPfMet_ues"
        self.gMtToPfMet_ues_branch = the_tree.GetBranch("gMtToPfMet_ues")
        #if not self.gMtToPfMet_ues_branch and "gMtToPfMet_ues" not in self.complained:
        if not self.gMtToPfMet_ues_branch and "gMtToPfMet_ues":
            warnings.warn( "EGTree: Expected branch gMtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gMtToPfMet_ues")
        else:
            self.gMtToPfMet_ues_branch.SetAddress(<void*>&self.gMtToPfMet_ues_value)

        #print "making gPFChargedIso"
        self.gPFChargedIso_branch = the_tree.GetBranch("gPFChargedIso")
        #if not self.gPFChargedIso_branch and "gPFChargedIso" not in self.complained:
        if not self.gPFChargedIso_branch and "gPFChargedIso":
            warnings.warn( "EGTree: Expected branch gPFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPFChargedIso")
        else:
            self.gPFChargedIso_branch.SetAddress(<void*>&self.gPFChargedIso_value)

        #print "making gPFNeutralIso"
        self.gPFNeutralIso_branch = the_tree.GetBranch("gPFNeutralIso")
        #if not self.gPFNeutralIso_branch and "gPFNeutralIso" not in self.complained:
        if not self.gPFNeutralIso_branch and "gPFNeutralIso":
            warnings.warn( "EGTree: Expected branch gPFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPFNeutralIso")
        else:
            self.gPFNeutralIso_branch.SetAddress(<void*>&self.gPFNeutralIso_value)

        #print "making gPFPhotonIso"
        self.gPFPhotonIso_branch = the_tree.GetBranch("gPFPhotonIso")
        #if not self.gPFPhotonIso_branch and "gPFPhotonIso" not in self.complained:
        if not self.gPFPhotonIso_branch and "gPFPhotonIso":
            warnings.warn( "EGTree: Expected branch gPFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPFPhotonIso")
        else:
            self.gPFPhotonIso_branch.SetAddress(<void*>&self.gPFPhotonIso_value)

        #print "making gPdgId"
        self.gPdgId_branch = the_tree.GetBranch("gPdgId")
        #if not self.gPdgId_branch and "gPdgId" not in self.complained:
        if not self.gPdgId_branch and "gPdgId":
            warnings.warn( "EGTree: Expected branch gPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPdgId")
        else:
            self.gPdgId_branch.SetAddress(<void*>&self.gPdgId_value)

        #print "making gPhi"
        self.gPhi_branch = the_tree.GetBranch("gPhi")
        #if not self.gPhi_branch and "gPhi" not in self.complained:
        if not self.gPhi_branch and "gPhi":
            warnings.warn( "EGTree: Expected branch gPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPhi")
        else:
            self.gPhi_branch.SetAddress(<void*>&self.gPhi_value)

        #print "making gPhiCorrPHOSPHOR2011"
        self.gPhiCorrPHOSPHOR2011_branch = the_tree.GetBranch("gPhiCorrPHOSPHOR2011")
        #if not self.gPhiCorrPHOSPHOR2011_branch and "gPhiCorrPHOSPHOR2011" not in self.complained:
        if not self.gPhiCorrPHOSPHOR2011_branch and "gPhiCorrPHOSPHOR2011":
            warnings.warn( "EGTree: Expected branch gPhiCorrPHOSPHOR2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPhiCorrPHOSPHOR2011")
        else:
            self.gPhiCorrPHOSPHOR2011_branch.SetAddress(<void*>&self.gPhiCorrPHOSPHOR2011_value)

        #print "making gPhiCorrPHOSPHOR2012"
        self.gPhiCorrPHOSPHOR2012_branch = the_tree.GetBranch("gPhiCorrPHOSPHOR2012")
        #if not self.gPhiCorrPHOSPHOR2012_branch and "gPhiCorrPHOSPHOR2012" not in self.complained:
        if not self.gPhiCorrPHOSPHOR2012_branch and "gPhiCorrPHOSPHOR2012":
            warnings.warn( "EGTree: Expected branch gPhiCorrPHOSPHOR2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPhiCorrPHOSPHOR2012")
        else:
            self.gPhiCorrPHOSPHOR2012_branch.SetAddress(<void*>&self.gPhiCorrPHOSPHOR2012_value)

        #print "making gPositionX"
        self.gPositionX_branch = the_tree.GetBranch("gPositionX")
        #if not self.gPositionX_branch and "gPositionX" not in self.complained:
        if not self.gPositionX_branch and "gPositionX":
            warnings.warn( "EGTree: Expected branch gPositionX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPositionX")
        else:
            self.gPositionX_branch.SetAddress(<void*>&self.gPositionX_value)

        #print "making gPositionY"
        self.gPositionY_branch = the_tree.GetBranch("gPositionY")
        #if not self.gPositionY_branch and "gPositionY" not in self.complained:
        if not self.gPositionY_branch and "gPositionY":
            warnings.warn( "EGTree: Expected branch gPositionY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPositionY")
        else:
            self.gPositionY_branch.SetAddress(<void*>&self.gPositionY_value)

        #print "making gPositionZ"
        self.gPositionZ_branch = the_tree.GetBranch("gPositionZ")
        #if not self.gPositionZ_branch and "gPositionZ" not in self.complained:
        if not self.gPositionZ_branch and "gPositionZ":
            warnings.warn( "EGTree: Expected branch gPositionZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPositionZ")
        else:
            self.gPositionZ_branch.SetAddress(<void*>&self.gPositionZ_value)

        #print "making gPt"
        self.gPt_branch = the_tree.GetBranch("gPt")
        #if not self.gPt_branch and "gPt" not in self.complained:
        if not self.gPt_branch and "gPt":
            warnings.warn( "EGTree: Expected branch gPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPt")
        else:
            self.gPt_branch.SetAddress(<void*>&self.gPt_value)

        #print "making gPtCorrPHOSPHOR2011"
        self.gPtCorrPHOSPHOR2011_branch = the_tree.GetBranch("gPtCorrPHOSPHOR2011")
        #if not self.gPtCorrPHOSPHOR2011_branch and "gPtCorrPHOSPHOR2011" not in self.complained:
        if not self.gPtCorrPHOSPHOR2011_branch and "gPtCorrPHOSPHOR2011":
            warnings.warn( "EGTree: Expected branch gPtCorrPHOSPHOR2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPtCorrPHOSPHOR2011")
        else:
            self.gPtCorrPHOSPHOR2011_branch.SetAddress(<void*>&self.gPtCorrPHOSPHOR2011_value)

        #print "making gPtCorrPHOSPHOR2012"
        self.gPtCorrPHOSPHOR2012_branch = the_tree.GetBranch("gPtCorrPHOSPHOR2012")
        #if not self.gPtCorrPHOSPHOR2012_branch and "gPtCorrPHOSPHOR2012" not in self.complained:
        if not self.gPtCorrPHOSPHOR2012_branch and "gPtCorrPHOSPHOR2012":
            warnings.warn( "EGTree: Expected branch gPtCorrPHOSPHOR2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gPtCorrPHOSPHOR2012")
        else:
            self.gPtCorrPHOSPHOR2012_branch.SetAddress(<void*>&self.gPtCorrPHOSPHOR2012_value)

        #print "making gR1x5"
        self.gR1x5_branch = the_tree.GetBranch("gR1x5")
        #if not self.gR1x5_branch and "gR1x5" not in self.complained:
        if not self.gR1x5_branch and "gR1x5":
            warnings.warn( "EGTree: Expected branch gR1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gR1x5")
        else:
            self.gR1x5_branch.SetAddress(<void*>&self.gR1x5_value)

        #print "making gR2x5"
        self.gR2x5_branch = the_tree.GetBranch("gR2x5")
        #if not self.gR2x5_branch and "gR2x5" not in self.complained:
        if not self.gR2x5_branch and "gR2x5":
            warnings.warn( "EGTree: Expected branch gR2x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gR2x5")
        else:
            self.gR2x5_branch.SetAddress(<void*>&self.gR2x5_value)

        #print "making gR9"
        self.gR9_branch = the_tree.GetBranch("gR9")
        #if not self.gR9_branch and "gR9" not in self.complained:
        if not self.gR9_branch and "gR9":
            warnings.warn( "EGTree: Expected branch gR9 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gR9")
        else:
            self.gR9_branch.SetAddress(<void*>&self.gR9_value)

        #print "making gRank"
        self.gRank_branch = the_tree.GetBranch("gRank")
        #if not self.gRank_branch and "gRank" not in self.complained:
        if not self.gRank_branch and "gRank":
            warnings.warn( "EGTree: Expected branch gRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gRank")
        else:
            self.gRank_branch.SetAddress(<void*>&self.gRank_value)

        #print "making gRho"
        self.gRho_branch = the_tree.GetBranch("gRho")
        #if not self.gRho_branch and "gRho" not in self.complained:
        if not self.gRho_branch and "gRho":
            warnings.warn( "EGTree: Expected branch gRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gRho")
        else:
            self.gRho_branch.SetAddress(<void*>&self.gRho_value)

        #print "making gSCEnergy"
        self.gSCEnergy_branch = the_tree.GetBranch("gSCEnergy")
        #if not self.gSCEnergy_branch and "gSCEnergy" not in self.complained:
        if not self.gSCEnergy_branch and "gSCEnergy":
            warnings.warn( "EGTree: Expected branch gSCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSCEnergy")
        else:
            self.gSCEnergy_branch.SetAddress(<void*>&self.gSCEnergy_value)

        #print "making gSCEta"
        self.gSCEta_branch = the_tree.GetBranch("gSCEta")
        #if not self.gSCEta_branch and "gSCEta" not in self.complained:
        if not self.gSCEta_branch and "gSCEta":
            warnings.warn( "EGTree: Expected branch gSCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSCEta")
        else:
            self.gSCEta_branch.SetAddress(<void*>&self.gSCEta_value)

        #print "making gSCEtaWidth"
        self.gSCEtaWidth_branch = the_tree.GetBranch("gSCEtaWidth")
        #if not self.gSCEtaWidth_branch and "gSCEtaWidth" not in self.complained:
        if not self.gSCEtaWidth_branch and "gSCEtaWidth":
            warnings.warn( "EGTree: Expected branch gSCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSCEtaWidth")
        else:
            self.gSCEtaWidth_branch.SetAddress(<void*>&self.gSCEtaWidth_value)

        #print "making gSCPhi"
        self.gSCPhi_branch = the_tree.GetBranch("gSCPhi")
        #if not self.gSCPhi_branch and "gSCPhi" not in self.complained:
        if not self.gSCPhi_branch and "gSCPhi":
            warnings.warn( "EGTree: Expected branch gSCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSCPhi")
        else:
            self.gSCPhi_branch.SetAddress(<void*>&self.gSCPhi_value)

        #print "making gSCPhiWidth"
        self.gSCPhiWidth_branch = the_tree.GetBranch("gSCPhiWidth")
        #if not self.gSCPhiWidth_branch and "gSCPhiWidth" not in self.complained:
        if not self.gSCPhiWidth_branch and "gSCPhiWidth":
            warnings.warn( "EGTree: Expected branch gSCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSCPhiWidth")
        else:
            self.gSCPhiWidth_branch.SetAddress(<void*>&self.gSCPhiWidth_value)

        #print "making gSCPositionX"
        self.gSCPositionX_branch = the_tree.GetBranch("gSCPositionX")
        #if not self.gSCPositionX_branch and "gSCPositionX" not in self.complained:
        if not self.gSCPositionX_branch and "gSCPositionX":
            warnings.warn( "EGTree: Expected branch gSCPositionX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSCPositionX")
        else:
            self.gSCPositionX_branch.SetAddress(<void*>&self.gSCPositionX_value)

        #print "making gSCPositionY"
        self.gSCPositionY_branch = the_tree.GetBranch("gSCPositionY")
        #if not self.gSCPositionY_branch and "gSCPositionY" not in self.complained:
        if not self.gSCPositionY_branch and "gSCPositionY":
            warnings.warn( "EGTree: Expected branch gSCPositionY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSCPositionY")
        else:
            self.gSCPositionY_branch.SetAddress(<void*>&self.gSCPositionY_value)

        #print "making gSCPositionZ"
        self.gSCPositionZ_branch = the_tree.GetBranch("gSCPositionZ")
        #if not self.gSCPositionZ_branch and "gSCPositionZ" not in self.complained:
        if not self.gSCPositionZ_branch and "gSCPositionZ":
            warnings.warn( "EGTree: Expected branch gSCPositionZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSCPositionZ")
        else:
            self.gSCPositionZ_branch.SetAddress(<void*>&self.gSCPositionZ_value)

        #print "making gSCPreshowerEnergy"
        self.gSCPreshowerEnergy_branch = the_tree.GetBranch("gSCPreshowerEnergy")
        #if not self.gSCPreshowerEnergy_branch and "gSCPreshowerEnergy" not in self.complained:
        if not self.gSCPreshowerEnergy_branch and "gSCPreshowerEnergy":
            warnings.warn( "EGTree: Expected branch gSCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSCPreshowerEnergy")
        else:
            self.gSCPreshowerEnergy_branch.SetAddress(<void*>&self.gSCPreshowerEnergy_value)

        #print "making gSCRawEnergy"
        self.gSCRawEnergy_branch = the_tree.GetBranch("gSCRawEnergy")
        #if not self.gSCRawEnergy_branch and "gSCRawEnergy" not in self.complained:
        if not self.gSCRawEnergy_branch and "gSCRawEnergy":
            warnings.warn( "EGTree: Expected branch gSCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSCRawEnergy")
        else:
            self.gSCRawEnergy_branch.SetAddress(<void*>&self.gSCRawEnergy_value)

        #print "making gSigmaIEtaIEta"
        self.gSigmaIEtaIEta_branch = the_tree.GetBranch("gSigmaIEtaIEta")
        #if not self.gSigmaIEtaIEta_branch and "gSigmaIEtaIEta" not in self.complained:
        if not self.gSigmaIEtaIEta_branch and "gSigmaIEtaIEta":
            warnings.warn( "EGTree: Expected branch gSigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSigmaIEtaIEta")
        else:
            self.gSigmaIEtaIEta_branch.SetAddress(<void*>&self.gSigmaIEtaIEta_value)

        #print "making gSingleTowerHadronicDepth1OverEm"
        self.gSingleTowerHadronicDepth1OverEm_branch = the_tree.GetBranch("gSingleTowerHadronicDepth1OverEm")
        #if not self.gSingleTowerHadronicDepth1OverEm_branch and "gSingleTowerHadronicDepth1OverEm" not in self.complained:
        if not self.gSingleTowerHadronicDepth1OverEm_branch and "gSingleTowerHadronicDepth1OverEm":
            warnings.warn( "EGTree: Expected branch gSingleTowerHadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSingleTowerHadronicDepth1OverEm")
        else:
            self.gSingleTowerHadronicDepth1OverEm_branch.SetAddress(<void*>&self.gSingleTowerHadronicDepth1OverEm_value)

        #print "making gSingleTowerHadronicDepth2OverEm"
        self.gSingleTowerHadronicDepth2OverEm_branch = the_tree.GetBranch("gSingleTowerHadronicDepth2OverEm")
        #if not self.gSingleTowerHadronicDepth2OverEm_branch and "gSingleTowerHadronicDepth2OverEm" not in self.complained:
        if not self.gSingleTowerHadronicDepth2OverEm_branch and "gSingleTowerHadronicDepth2OverEm":
            warnings.warn( "EGTree: Expected branch gSingleTowerHadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSingleTowerHadronicDepth2OverEm")
        else:
            self.gSingleTowerHadronicDepth2OverEm_branch.SetAddress(<void*>&self.gSingleTowerHadronicDepth2OverEm_value)

        #print "making gSingleTowerHadronicOverEm"
        self.gSingleTowerHadronicOverEm_branch = the_tree.GetBranch("gSingleTowerHadronicOverEm")
        #if not self.gSingleTowerHadronicOverEm_branch and "gSingleTowerHadronicOverEm" not in self.complained:
        if not self.gSingleTowerHadronicOverEm_branch and "gSingleTowerHadronicOverEm":
            warnings.warn( "EGTree: Expected branch gSingleTowerHadronicOverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gSingleTowerHadronicOverEm")
        else:
            self.gSingleTowerHadronicOverEm_branch.SetAddress(<void*>&self.gSingleTowerHadronicOverEm_value)

        #print "making gToMETDPhi"
        self.gToMETDPhi_branch = the_tree.GetBranch("gToMETDPhi")
        #if not self.gToMETDPhi_branch and "gToMETDPhi" not in self.complained:
        if not self.gToMETDPhi_branch and "gToMETDPhi":
            warnings.warn( "EGTree: Expected branch gToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gToMETDPhi")
        else:
            self.gToMETDPhi_branch.SetAddress(<void*>&self.gToMETDPhi_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "EGTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "EGTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "EGTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "EGTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "EGTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isoMu24eta2p1Group"
        self.isoMu24eta2p1Group_branch = the_tree.GetBranch("isoMu24eta2p1Group")
        #if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group" not in self.complained:
        if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group":
            warnings.warn( "EGTree: Expected branch isoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Group")
        else:
            self.isoMu24eta2p1Group_branch.SetAddress(<void*>&self.isoMu24eta2p1Group_value)

        #print "making isoMu24eta2p1Pass"
        self.isoMu24eta2p1Pass_branch = the_tree.GetBranch("isoMu24eta2p1Pass")
        #if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass" not in self.complained:
        if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass":
            warnings.warn( "EGTree: Expected branch isoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Pass")
        else:
            self.isoMu24eta2p1Pass_branch.SetAddress(<void*>&self.isoMu24eta2p1Pass_value)

        #print "making isoMu24eta2p1Prescale"
        self.isoMu24eta2p1Prescale_branch = the_tree.GetBranch("isoMu24eta2p1Prescale")
        #if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale" not in self.complained:
        if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale":
            warnings.warn( "EGTree: Expected branch isoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Prescale")
        else:
            self.isoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.isoMu24eta2p1Prescale_value)

        #print "making isoMuGroup"
        self.isoMuGroup_branch = the_tree.GetBranch("isoMuGroup")
        #if not self.isoMuGroup_branch and "isoMuGroup" not in self.complained:
        if not self.isoMuGroup_branch and "isoMuGroup":
            warnings.warn( "EGTree: Expected branch isoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuGroup")
        else:
            self.isoMuGroup_branch.SetAddress(<void*>&self.isoMuGroup_value)

        #print "making isoMuPass"
        self.isoMuPass_branch = the_tree.GetBranch("isoMuPass")
        #if not self.isoMuPass_branch and "isoMuPass" not in self.complained:
        if not self.isoMuPass_branch and "isoMuPass":
            warnings.warn( "EGTree: Expected branch isoMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPass")
        else:
            self.isoMuPass_branch.SetAddress(<void*>&self.isoMuPass_value)

        #print "making isoMuPrescale"
        self.isoMuPrescale_branch = the_tree.GetBranch("isoMuPrescale")
        #if not self.isoMuPrescale_branch and "isoMuPrescale" not in self.complained:
        if not self.isoMuPrescale_branch and "isoMuPrescale":
            warnings.warn( "EGTree: Expected branch isoMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPrescale")
        else:
            self.isoMuPrescale_branch.SetAddress(<void*>&self.isoMuPrescale_value)

        #print "making isoMuTauGroup"
        self.isoMuTauGroup_branch = the_tree.GetBranch("isoMuTauGroup")
        #if not self.isoMuTauGroup_branch and "isoMuTauGroup" not in self.complained:
        if not self.isoMuTauGroup_branch and "isoMuTauGroup":
            warnings.warn( "EGTree: Expected branch isoMuTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauGroup")
        else:
            self.isoMuTauGroup_branch.SetAddress(<void*>&self.isoMuTauGroup_value)

        #print "making isoMuTauPass"
        self.isoMuTauPass_branch = the_tree.GetBranch("isoMuTauPass")
        #if not self.isoMuTauPass_branch and "isoMuTauPass" not in self.complained:
        if not self.isoMuTauPass_branch and "isoMuTauPass":
            warnings.warn( "EGTree: Expected branch isoMuTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPass")
        else:
            self.isoMuTauPass_branch.SetAddress(<void*>&self.isoMuTauPass_value)

        #print "making isoMuTauPrescale"
        self.isoMuTauPrescale_branch = the_tree.GetBranch("isoMuTauPrescale")
        #if not self.isoMuTauPrescale_branch and "isoMuTauPrescale" not in self.complained:
        if not self.isoMuTauPrescale_branch and "isoMuTauPrescale":
            warnings.warn( "EGTree: Expected branch isoMuTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPrescale")
        else:
            self.isoMuTauPrescale_branch.SetAddress(<void*>&self.isoMuTauPrescale_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "EGTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_DR05"
        self.jetVeto20_DR05_branch = the_tree.GetBranch("jetVeto20_DR05")
        #if not self.jetVeto20_DR05_branch and "jetVeto20_DR05" not in self.complained:
        if not self.jetVeto20_DR05_branch and "jetVeto20_DR05":
            warnings.warn( "EGTree: Expected branch jetVeto20_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_DR05")
        else:
            self.jetVeto20_DR05_branch.SetAddress(<void*>&self.jetVeto20_DR05_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "EGTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_DR05"
        self.jetVeto30_DR05_branch = the_tree.GetBranch("jetVeto30_DR05")
        #if not self.jetVeto30_DR05_branch and "jetVeto30_DR05" not in self.complained:
        if not self.jetVeto30_DR05_branch and "jetVeto30_DR05":
            warnings.warn( "EGTree: Expected branch jetVeto30_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_DR05")
        else:
            self.jetVeto30_DR05_branch.SetAddress(<void*>&self.jetVeto30_DR05_value)

        #print "making jetVeto40"
        self.jetVeto40_branch = the_tree.GetBranch("jetVeto40")
        #if not self.jetVeto40_branch and "jetVeto40" not in self.complained:
        if not self.jetVeto40_branch and "jetVeto40":
            warnings.warn( "EGTree: Expected branch jetVeto40 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40")
        else:
            self.jetVeto40_branch.SetAddress(<void*>&self.jetVeto40_value)

        #print "making jetVeto40_DR05"
        self.jetVeto40_DR05_branch = the_tree.GetBranch("jetVeto40_DR05")
        #if not self.jetVeto40_DR05_branch and "jetVeto40_DR05" not in self.complained:
        if not self.jetVeto40_DR05_branch and "jetVeto40_DR05":
            warnings.warn( "EGTree: Expected branch jetVeto40_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40_DR05")
        else:
            self.jetVeto40_DR05_branch.SetAddress(<void*>&self.jetVeto40_DR05_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EGTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making mu17ele8Group"
        self.mu17ele8Group_branch = the_tree.GetBranch("mu17ele8Group")
        #if not self.mu17ele8Group_branch and "mu17ele8Group" not in self.complained:
        if not self.mu17ele8Group_branch and "mu17ele8Group":
            warnings.warn( "EGTree: Expected branch mu17ele8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Group")
        else:
            self.mu17ele8Group_branch.SetAddress(<void*>&self.mu17ele8Group_value)

        #print "making mu17ele8Pass"
        self.mu17ele8Pass_branch = the_tree.GetBranch("mu17ele8Pass")
        #if not self.mu17ele8Pass_branch and "mu17ele8Pass" not in self.complained:
        if not self.mu17ele8Pass_branch and "mu17ele8Pass":
            warnings.warn( "EGTree: Expected branch mu17ele8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Pass")
        else:
            self.mu17ele8Pass_branch.SetAddress(<void*>&self.mu17ele8Pass_value)

        #print "making mu17ele8Prescale"
        self.mu17ele8Prescale_branch = the_tree.GetBranch("mu17ele8Prescale")
        #if not self.mu17ele8Prescale_branch and "mu17ele8Prescale" not in self.complained:
        if not self.mu17ele8Prescale_branch and "mu17ele8Prescale":
            warnings.warn( "EGTree: Expected branch mu17ele8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Prescale")
        else:
            self.mu17ele8Prescale_branch.SetAddress(<void*>&self.mu17ele8Prescale_value)

        #print "making mu17ele8isoGroup"
        self.mu17ele8isoGroup_branch = the_tree.GetBranch("mu17ele8isoGroup")
        #if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup" not in self.complained:
        if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup":
            warnings.warn( "EGTree: Expected branch mu17ele8isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoGroup")
        else:
            self.mu17ele8isoGroup_branch.SetAddress(<void*>&self.mu17ele8isoGroup_value)

        #print "making mu17ele8isoPass"
        self.mu17ele8isoPass_branch = the_tree.GetBranch("mu17ele8isoPass")
        #if not self.mu17ele8isoPass_branch and "mu17ele8isoPass" not in self.complained:
        if not self.mu17ele8isoPass_branch and "mu17ele8isoPass":
            warnings.warn( "EGTree: Expected branch mu17ele8isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPass")
        else:
            self.mu17ele8isoPass_branch.SetAddress(<void*>&self.mu17ele8isoPass_value)

        #print "making mu17ele8isoPrescale"
        self.mu17ele8isoPrescale_branch = the_tree.GetBranch("mu17ele8isoPrescale")
        #if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale" not in self.complained:
        if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale":
            warnings.warn( "EGTree: Expected branch mu17ele8isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPrescale")
        else:
            self.mu17ele8isoPrescale_branch.SetAddress(<void*>&self.mu17ele8isoPrescale_value)

        #print "making mu17mu8Group"
        self.mu17mu8Group_branch = the_tree.GetBranch("mu17mu8Group")
        #if not self.mu17mu8Group_branch and "mu17mu8Group" not in self.complained:
        if not self.mu17mu8Group_branch and "mu17mu8Group":
            warnings.warn( "EGTree: Expected branch mu17mu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Group")
        else:
            self.mu17mu8Group_branch.SetAddress(<void*>&self.mu17mu8Group_value)

        #print "making mu17mu8Pass"
        self.mu17mu8Pass_branch = the_tree.GetBranch("mu17mu8Pass")
        #if not self.mu17mu8Pass_branch and "mu17mu8Pass" not in self.complained:
        if not self.mu17mu8Pass_branch and "mu17mu8Pass":
            warnings.warn( "EGTree: Expected branch mu17mu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Pass")
        else:
            self.mu17mu8Pass_branch.SetAddress(<void*>&self.mu17mu8Pass_value)

        #print "making mu17mu8Prescale"
        self.mu17mu8Prescale_branch = the_tree.GetBranch("mu17mu8Prescale")
        #if not self.mu17mu8Prescale_branch and "mu17mu8Prescale" not in self.complained:
        if not self.mu17mu8Prescale_branch and "mu17mu8Prescale":
            warnings.warn( "EGTree: Expected branch mu17mu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Prescale")
        else:
            self.mu17mu8Prescale_branch.SetAddress(<void*>&self.mu17mu8Prescale_value)

        #print "making mu8ele17Group"
        self.mu8ele17Group_branch = the_tree.GetBranch("mu8ele17Group")
        #if not self.mu8ele17Group_branch and "mu8ele17Group" not in self.complained:
        if not self.mu8ele17Group_branch and "mu8ele17Group":
            warnings.warn( "EGTree: Expected branch mu8ele17Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Group")
        else:
            self.mu8ele17Group_branch.SetAddress(<void*>&self.mu8ele17Group_value)

        #print "making mu8ele17Pass"
        self.mu8ele17Pass_branch = the_tree.GetBranch("mu8ele17Pass")
        #if not self.mu8ele17Pass_branch and "mu8ele17Pass" not in self.complained:
        if not self.mu8ele17Pass_branch and "mu8ele17Pass":
            warnings.warn( "EGTree: Expected branch mu8ele17Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Pass")
        else:
            self.mu8ele17Pass_branch.SetAddress(<void*>&self.mu8ele17Pass_value)

        #print "making mu8ele17Prescale"
        self.mu8ele17Prescale_branch = the_tree.GetBranch("mu8ele17Prescale")
        #if not self.mu8ele17Prescale_branch and "mu8ele17Prescale" not in self.complained:
        if not self.mu8ele17Prescale_branch and "mu8ele17Prescale":
            warnings.warn( "EGTree: Expected branch mu8ele17Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Prescale")
        else:
            self.mu8ele17Prescale_branch.SetAddress(<void*>&self.mu8ele17Prescale_value)

        #print "making mu8ele17isoGroup"
        self.mu8ele17isoGroup_branch = the_tree.GetBranch("mu8ele17isoGroup")
        #if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup" not in self.complained:
        if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup":
            warnings.warn( "EGTree: Expected branch mu8ele17isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoGroup")
        else:
            self.mu8ele17isoGroup_branch.SetAddress(<void*>&self.mu8ele17isoGroup_value)

        #print "making mu8ele17isoPass"
        self.mu8ele17isoPass_branch = the_tree.GetBranch("mu8ele17isoPass")
        #if not self.mu8ele17isoPass_branch and "mu8ele17isoPass" not in self.complained:
        if not self.mu8ele17isoPass_branch and "mu8ele17isoPass":
            warnings.warn( "EGTree: Expected branch mu8ele17isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPass")
        else:
            self.mu8ele17isoPass_branch.SetAddress(<void*>&self.mu8ele17isoPass_value)

        #print "making mu8ele17isoPrescale"
        self.mu8ele17isoPrescale_branch = the_tree.GetBranch("mu8ele17isoPrescale")
        #if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale" not in self.complained:
        if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale":
            warnings.warn( "EGTree: Expected branch mu8ele17isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPrescale")
        else:
            self.mu8ele17isoPrescale_branch.SetAddress(<void*>&self.mu8ele17isoPrescale_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "EGTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muTauGroup"
        self.muTauGroup_branch = the_tree.GetBranch("muTauGroup")
        #if not self.muTauGroup_branch and "muTauGroup" not in self.complained:
        if not self.muTauGroup_branch and "muTauGroup":
            warnings.warn( "EGTree: Expected branch muTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauGroup")
        else:
            self.muTauGroup_branch.SetAddress(<void*>&self.muTauGroup_value)

        #print "making muTauPass"
        self.muTauPass_branch = the_tree.GetBranch("muTauPass")
        #if not self.muTauPass_branch and "muTauPass" not in self.complained:
        if not self.muTauPass_branch and "muTauPass":
            warnings.warn( "EGTree: Expected branch muTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPass")
        else:
            self.muTauPass_branch.SetAddress(<void*>&self.muTauPass_value)

        #print "making muTauPrescale"
        self.muTauPrescale_branch = the_tree.GetBranch("muTauPrescale")
        #if not self.muTauPrescale_branch and "muTauPrescale" not in self.complained:
        if not self.muTauPrescale_branch and "muTauPrescale":
            warnings.warn( "EGTree: Expected branch muTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPrescale")
        else:
            self.muTauPrescale_branch.SetAddress(<void*>&self.muTauPrescale_value)

        #print "making muTauTestGroup"
        self.muTauTestGroup_branch = the_tree.GetBranch("muTauTestGroup")
        #if not self.muTauTestGroup_branch and "muTauTestGroup" not in self.complained:
        if not self.muTauTestGroup_branch and "muTauTestGroup":
            warnings.warn( "EGTree: Expected branch muTauTestGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestGroup")
        else:
            self.muTauTestGroup_branch.SetAddress(<void*>&self.muTauTestGroup_value)

        #print "making muTauTestPass"
        self.muTauTestPass_branch = the_tree.GetBranch("muTauTestPass")
        #if not self.muTauTestPass_branch and "muTauTestPass" not in self.complained:
        if not self.muTauTestPass_branch and "muTauTestPass":
            warnings.warn( "EGTree: Expected branch muTauTestPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPass")
        else:
            self.muTauTestPass_branch.SetAddress(<void*>&self.muTauTestPass_value)

        #print "making muTauTestPrescale"
        self.muTauTestPrescale_branch = the_tree.GetBranch("muTauTestPrescale")
        #if not self.muTauTestPrescale_branch and "muTauTestPrescale" not in self.complained:
        if not self.muTauTestPrescale_branch and "muTauTestPrescale":
            warnings.warn( "EGTree: Expected branch muTauTestPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPrescale")
        else:
            self.muTauTestPrescale_branch.SetAddress(<void*>&self.muTauTestPrescale_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "EGTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "EGTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "EGTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making mva_metEt"
        self.mva_metEt_branch = the_tree.GetBranch("mva_metEt")
        #if not self.mva_metEt_branch and "mva_metEt" not in self.complained:
        if not self.mva_metEt_branch and "mva_metEt":
            warnings.warn( "EGTree: Expected branch mva_metEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metEt")
        else:
            self.mva_metEt_branch.SetAddress(<void*>&self.mva_metEt_value)

        #print "making mva_metPhi"
        self.mva_metPhi_branch = the_tree.GetBranch("mva_metPhi")
        #if not self.mva_metPhi_branch and "mva_metPhi" not in self.complained:
        if not self.mva_metPhi_branch and "mva_metPhi":
            warnings.warn( "EGTree: Expected branch mva_metPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metPhi")
        else:
            self.mva_metPhi_branch.SetAddress(<void*>&self.mva_metPhi_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "EGTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "EGTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making pfMetEt"
        self.pfMetEt_branch = the_tree.GetBranch("pfMetEt")
        #if not self.pfMetEt_branch and "pfMetEt" not in self.complained:
        if not self.pfMetEt_branch and "pfMetEt":
            warnings.warn( "EGTree: Expected branch pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetEt")
        else:
            self.pfMetEt_branch.SetAddress(<void*>&self.pfMetEt_value)

        #print "making pfMetPhi"
        self.pfMetPhi_branch = the_tree.GetBranch("pfMetPhi")
        #if not self.pfMetPhi_branch and "pfMetPhi" not in self.complained:
        if not self.pfMetPhi_branch and "pfMetPhi":
            warnings.warn( "EGTree: Expected branch pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetPhi")
        else:
            self.pfMetPhi_branch.SetAddress(<void*>&self.pfMetPhi_value)

        #print "making pfMet_jes_Et"
        self.pfMet_jes_Et_branch = the_tree.GetBranch("pfMet_jes_Et")
        #if not self.pfMet_jes_Et_branch and "pfMet_jes_Et" not in self.complained:
        if not self.pfMet_jes_Et_branch and "pfMet_jes_Et":
            warnings.warn( "EGTree: Expected branch pfMet_jes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Et")
        else:
            self.pfMet_jes_Et_branch.SetAddress(<void*>&self.pfMet_jes_Et_value)

        #print "making pfMet_jes_Phi"
        self.pfMet_jes_Phi_branch = the_tree.GetBranch("pfMet_jes_Phi")
        #if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi" not in self.complained:
        if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi":
            warnings.warn( "EGTree: Expected branch pfMet_jes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Phi")
        else:
            self.pfMet_jes_Phi_branch.SetAddress(<void*>&self.pfMet_jes_Phi_value)

        #print "making pfMet_mes_Et"
        self.pfMet_mes_Et_branch = the_tree.GetBranch("pfMet_mes_Et")
        #if not self.pfMet_mes_Et_branch and "pfMet_mes_Et" not in self.complained:
        if not self.pfMet_mes_Et_branch and "pfMet_mes_Et":
            warnings.warn( "EGTree: Expected branch pfMet_mes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Et")
        else:
            self.pfMet_mes_Et_branch.SetAddress(<void*>&self.pfMet_mes_Et_value)

        #print "making pfMet_mes_Phi"
        self.pfMet_mes_Phi_branch = the_tree.GetBranch("pfMet_mes_Phi")
        #if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi" not in self.complained:
        if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi":
            warnings.warn( "EGTree: Expected branch pfMet_mes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Phi")
        else:
            self.pfMet_mes_Phi_branch.SetAddress(<void*>&self.pfMet_mes_Phi_value)

        #print "making pfMet_tes_Et"
        self.pfMet_tes_Et_branch = the_tree.GetBranch("pfMet_tes_Et")
        #if not self.pfMet_tes_Et_branch and "pfMet_tes_Et" not in self.complained:
        if not self.pfMet_tes_Et_branch and "pfMet_tes_Et":
            warnings.warn( "EGTree: Expected branch pfMet_tes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Et")
        else:
            self.pfMet_tes_Et_branch.SetAddress(<void*>&self.pfMet_tes_Et_value)

        #print "making pfMet_tes_Phi"
        self.pfMet_tes_Phi_branch = the_tree.GetBranch("pfMet_tes_Phi")
        #if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi" not in self.complained:
        if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi":
            warnings.warn( "EGTree: Expected branch pfMet_tes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Phi")
        else:
            self.pfMet_tes_Phi_branch.SetAddress(<void*>&self.pfMet_tes_Phi_value)

        #print "making pfMet_ues_Et"
        self.pfMet_ues_Et_branch = the_tree.GetBranch("pfMet_ues_Et")
        #if not self.pfMet_ues_Et_branch and "pfMet_ues_Et" not in self.complained:
        if not self.pfMet_ues_Et_branch and "pfMet_ues_Et":
            warnings.warn( "EGTree: Expected branch pfMet_ues_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Et")
        else:
            self.pfMet_ues_Et_branch.SetAddress(<void*>&self.pfMet_ues_Et_value)

        #print "making pfMet_ues_Phi"
        self.pfMet_ues_Phi_branch = the_tree.GetBranch("pfMet_ues_Phi")
        #if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi" not in self.complained:
        if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi":
            warnings.warn( "EGTree: Expected branch pfMet_ues_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Phi")
        else:
            self.pfMet_ues_Phi_branch.SetAddress(<void*>&self.pfMet_ues_Phi_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "EGTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "EGTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "EGTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "EGTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "EGTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "EGTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "EGTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "EGTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "EGTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "EGTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "EGTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "EGTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "EGTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "EGTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "EGTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "EGTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleEGroup"
        self.singleEGroup_branch = the_tree.GetBranch("singleEGroup")
        #if not self.singleEGroup_branch and "singleEGroup" not in self.complained:
        if not self.singleEGroup_branch and "singleEGroup":
            warnings.warn( "EGTree: Expected branch singleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEGroup")
        else:
            self.singleEGroup_branch.SetAddress(<void*>&self.singleEGroup_value)

        #print "making singleEPFMTGroup"
        self.singleEPFMTGroup_branch = the_tree.GetBranch("singleEPFMTGroup")
        #if not self.singleEPFMTGroup_branch and "singleEPFMTGroup" not in self.complained:
        if not self.singleEPFMTGroup_branch and "singleEPFMTGroup":
            warnings.warn( "EGTree: Expected branch singleEPFMTGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTGroup")
        else:
            self.singleEPFMTGroup_branch.SetAddress(<void*>&self.singleEPFMTGroup_value)

        #print "making singleEPFMTPass"
        self.singleEPFMTPass_branch = the_tree.GetBranch("singleEPFMTPass")
        #if not self.singleEPFMTPass_branch and "singleEPFMTPass" not in self.complained:
        if not self.singleEPFMTPass_branch and "singleEPFMTPass":
            warnings.warn( "EGTree: Expected branch singleEPFMTPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPass")
        else:
            self.singleEPFMTPass_branch.SetAddress(<void*>&self.singleEPFMTPass_value)

        #print "making singleEPFMTPrescale"
        self.singleEPFMTPrescale_branch = the_tree.GetBranch("singleEPFMTPrescale")
        #if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale" not in self.complained:
        if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale":
            warnings.warn( "EGTree: Expected branch singleEPFMTPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPrescale")
        else:
            self.singleEPFMTPrescale_branch.SetAddress(<void*>&self.singleEPFMTPrescale_value)

        #print "making singleEPass"
        self.singleEPass_branch = the_tree.GetBranch("singleEPass")
        #if not self.singleEPass_branch and "singleEPass" not in self.complained:
        if not self.singleEPass_branch and "singleEPass":
            warnings.warn( "EGTree: Expected branch singleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPass")
        else:
            self.singleEPass_branch.SetAddress(<void*>&self.singleEPass_value)

        #print "making singleEPrescale"
        self.singleEPrescale_branch = the_tree.GetBranch("singleEPrescale")
        #if not self.singleEPrescale_branch and "singleEPrescale" not in self.complained:
        if not self.singleEPrescale_branch and "singleEPrescale":
            warnings.warn( "EGTree: Expected branch singleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPrescale")
        else:
            self.singleEPrescale_branch.SetAddress(<void*>&self.singleEPrescale_value)

        #print "making singleMuGroup"
        self.singleMuGroup_branch = the_tree.GetBranch("singleMuGroup")
        #if not self.singleMuGroup_branch and "singleMuGroup" not in self.complained:
        if not self.singleMuGroup_branch and "singleMuGroup":
            warnings.warn( "EGTree: Expected branch singleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuGroup")
        else:
            self.singleMuGroup_branch.SetAddress(<void*>&self.singleMuGroup_value)

        #print "making singleMuPass"
        self.singleMuPass_branch = the_tree.GetBranch("singleMuPass")
        #if not self.singleMuPass_branch and "singleMuPass" not in self.complained:
        if not self.singleMuPass_branch and "singleMuPass":
            warnings.warn( "EGTree: Expected branch singleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPass")
        else:
            self.singleMuPass_branch.SetAddress(<void*>&self.singleMuPass_value)

        #print "making singleMuPrescale"
        self.singleMuPrescale_branch = the_tree.GetBranch("singleMuPrescale")
        #if not self.singleMuPrescale_branch and "singleMuPrescale" not in self.complained:
        if not self.singleMuPrescale_branch and "singleMuPrescale":
            warnings.warn( "EGTree: Expected branch singleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPrescale")
        else:
            self.singleMuPrescale_branch.SetAddress(<void*>&self.singleMuPrescale_value)

        #print "making singlePhoGroup"
        self.singlePhoGroup_branch = the_tree.GetBranch("singlePhoGroup")
        #if not self.singlePhoGroup_branch and "singlePhoGroup" not in self.complained:
        if not self.singlePhoGroup_branch and "singlePhoGroup":
            warnings.warn( "EGTree: Expected branch singlePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoGroup")
        else:
            self.singlePhoGroup_branch.SetAddress(<void*>&self.singlePhoGroup_value)

        #print "making singlePhoPass"
        self.singlePhoPass_branch = the_tree.GetBranch("singlePhoPass")
        #if not self.singlePhoPass_branch and "singlePhoPass" not in self.complained:
        if not self.singlePhoPass_branch and "singlePhoPass":
            warnings.warn( "EGTree: Expected branch singlePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPass")
        else:
            self.singlePhoPass_branch.SetAddress(<void*>&self.singlePhoPass_value)

        #print "making singlePhoPrescale"
        self.singlePhoPrescale_branch = the_tree.GetBranch("singlePhoPrescale")
        #if not self.singlePhoPrescale_branch and "singlePhoPrescale" not in self.complained:
        if not self.singlePhoPrescale_branch and "singlePhoPrescale":
            warnings.warn( "EGTree: Expected branch singlePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPrescale")
        else:
            self.singlePhoPrescale_branch.SetAddress(<void*>&self.singlePhoPrescale_value)

        #print "making tauVetoPt20Loose3HitsNewDMVtx"
        self.tauVetoPt20Loose3HitsNewDMVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsNewDMVtx")
        #if not self.tauVetoPt20Loose3HitsNewDMVtx_branch and "tauVetoPt20Loose3HitsNewDMVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsNewDMVtx_branch and "tauVetoPt20Loose3HitsNewDMVtx":
            warnings.warn( "EGTree: Expected branch tauVetoPt20Loose3HitsNewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsNewDMVtx")
        else:
            self.tauVetoPt20Loose3HitsNewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsNewDMVtx_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "EGTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20TightMVALTNewDMVtx"
        self.tauVetoPt20TightMVALTNewDMVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTNewDMVtx")
        #if not self.tauVetoPt20TightMVALTNewDMVtx_branch and "tauVetoPt20TightMVALTNewDMVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTNewDMVtx_branch and "tauVetoPt20TightMVALTNewDMVtx":
            warnings.warn( "EGTree: Expected branch tauVetoPt20TightMVALTNewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTNewDMVtx")
        else:
            self.tauVetoPt20TightMVALTNewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTNewDMVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "EGTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making tauVetoPt20TightMVANewDMVtx"
        self.tauVetoPt20TightMVANewDMVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVANewDMVtx")
        #if not self.tauVetoPt20TightMVANewDMVtx_branch and "tauVetoPt20TightMVANewDMVtx" not in self.complained:
        if not self.tauVetoPt20TightMVANewDMVtx_branch and "tauVetoPt20TightMVANewDMVtx":
            warnings.warn( "EGTree: Expected branch tauVetoPt20TightMVANewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVANewDMVtx")
        else:
            self.tauVetoPt20TightMVANewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVANewDMVtx_value)

        #print "making tauVetoPt20TightMVAVtx"
        self.tauVetoPt20TightMVAVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVAVtx")
        #if not self.tauVetoPt20TightMVAVtx_branch and "tauVetoPt20TightMVAVtx" not in self.complained:
        if not self.tauVetoPt20TightMVAVtx_branch and "tauVetoPt20TightMVAVtx":
            warnings.warn( "EGTree: Expected branch tauVetoPt20TightMVAVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVAVtx")
        else:
            self.tauVetoPt20TightMVAVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVAVtx_value)

        #print "making tauVetoPt20VLooseHPSNewDMVtx"
        self.tauVetoPt20VLooseHPSNewDMVtx_branch = the_tree.GetBranch("tauVetoPt20VLooseHPSNewDMVtx")
        #if not self.tauVetoPt20VLooseHPSNewDMVtx_branch and "tauVetoPt20VLooseHPSNewDMVtx" not in self.complained:
        if not self.tauVetoPt20VLooseHPSNewDMVtx_branch and "tauVetoPt20VLooseHPSNewDMVtx":
            warnings.warn( "EGTree: Expected branch tauVetoPt20VLooseHPSNewDMVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20VLooseHPSNewDMVtx")
        else:
            self.tauVetoPt20VLooseHPSNewDMVtx_branch.SetAddress(<void*>&self.tauVetoPt20VLooseHPSNewDMVtx_value)

        #print "making tauVetoPt20VLooseHPSVtx"
        self.tauVetoPt20VLooseHPSVtx_branch = the_tree.GetBranch("tauVetoPt20VLooseHPSVtx")
        #if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx" not in self.complained:
        if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx":
            warnings.warn( "EGTree: Expected branch tauVetoPt20VLooseHPSVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20VLooseHPSVtx")
        else:
            self.tauVetoPt20VLooseHPSVtx_branch.SetAddress(<void*>&self.tauVetoPt20VLooseHPSVtx_value)

        #print "making tripleEGroup"
        self.tripleEGroup_branch = the_tree.GetBranch("tripleEGroup")
        #if not self.tripleEGroup_branch and "tripleEGroup" not in self.complained:
        if not self.tripleEGroup_branch and "tripleEGroup":
            warnings.warn( "EGTree: Expected branch tripleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEGroup")
        else:
            self.tripleEGroup_branch.SetAddress(<void*>&self.tripleEGroup_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "EGTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleEPrescale"
        self.tripleEPrescale_branch = the_tree.GetBranch("tripleEPrescale")
        #if not self.tripleEPrescale_branch and "tripleEPrescale" not in self.complained:
        if not self.tripleEPrescale_branch and "tripleEPrescale":
            warnings.warn( "EGTree: Expected branch tripleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPrescale")
        else:
            self.tripleEPrescale_branch.SetAddress(<void*>&self.tripleEPrescale_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "EGTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "EGTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "EGTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfDijetrap"
        self.vbfDijetrap_branch = the_tree.GetBranch("vbfDijetrap")
        #if not self.vbfDijetrap_branch and "vbfDijetrap" not in self.complained:
        if not self.vbfDijetrap_branch and "vbfDijetrap":
            warnings.warn( "EGTree: Expected branch vbfDijetrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap")
        else:
            self.vbfDijetrap_branch.SetAddress(<void*>&self.vbfDijetrap_value)

        #print "making vbfDphi"
        self.vbfDphi_branch = the_tree.GetBranch("vbfDphi")
        #if not self.vbfDphi_branch and "vbfDphi" not in self.complained:
        if not self.vbfDphi_branch and "vbfDphi":
            warnings.warn( "EGTree: Expected branch vbfDphi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi")
        else:
            self.vbfDphi_branch.SetAddress(<void*>&self.vbfDphi_value)

        #print "making vbfDphihj"
        self.vbfDphihj_branch = the_tree.GetBranch("vbfDphihj")
        #if not self.vbfDphihj_branch and "vbfDphihj" not in self.complained:
        if not self.vbfDphihj_branch and "vbfDphihj":
            warnings.warn( "EGTree: Expected branch vbfDphihj does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj")
        else:
            self.vbfDphihj_branch.SetAddress(<void*>&self.vbfDphihj_value)

        #print "making vbfDphihjnomet"
        self.vbfDphihjnomet_branch = the_tree.GetBranch("vbfDphihjnomet")
        #if not self.vbfDphihjnomet_branch and "vbfDphihjnomet" not in self.complained:
        if not self.vbfDphihjnomet_branch and "vbfDphihjnomet":
            warnings.warn( "EGTree: Expected branch vbfDphihjnomet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet")
        else:
            self.vbfDphihjnomet_branch.SetAddress(<void*>&self.vbfDphihjnomet_value)

        #print "making vbfHrap"
        self.vbfHrap_branch = the_tree.GetBranch("vbfHrap")
        #if not self.vbfHrap_branch and "vbfHrap" not in self.complained:
        if not self.vbfHrap_branch and "vbfHrap":
            warnings.warn( "EGTree: Expected branch vbfHrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap")
        else:
            self.vbfHrap_branch.SetAddress(<void*>&self.vbfHrap_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "EGTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "EGTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfJetVetoTight20"
        self.vbfJetVetoTight20_branch = the_tree.GetBranch("vbfJetVetoTight20")
        #if not self.vbfJetVetoTight20_branch and "vbfJetVetoTight20" not in self.complained:
        if not self.vbfJetVetoTight20_branch and "vbfJetVetoTight20":
            warnings.warn( "EGTree: Expected branch vbfJetVetoTight20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVetoTight20")
        else:
            self.vbfJetVetoTight20_branch.SetAddress(<void*>&self.vbfJetVetoTight20_value)

        #print "making vbfJetVetoTight30"
        self.vbfJetVetoTight30_branch = the_tree.GetBranch("vbfJetVetoTight30")
        #if not self.vbfJetVetoTight30_branch and "vbfJetVetoTight30" not in self.complained:
        if not self.vbfJetVetoTight30_branch and "vbfJetVetoTight30":
            warnings.warn( "EGTree: Expected branch vbfJetVetoTight30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVetoTight30")
        else:
            self.vbfJetVetoTight30_branch.SetAddress(<void*>&self.vbfJetVetoTight30_value)

        #print "making vbfMVA"
        self.vbfMVA_branch = the_tree.GetBranch("vbfMVA")
        #if not self.vbfMVA_branch and "vbfMVA" not in self.complained:
        if not self.vbfMVA_branch and "vbfMVA":
            warnings.warn( "EGTree: Expected branch vbfMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA")
        else:
            self.vbfMVA_branch.SetAddress(<void*>&self.vbfMVA_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "EGTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfNJets"
        self.vbfNJets_branch = the_tree.GetBranch("vbfNJets")
        #if not self.vbfNJets_branch and "vbfNJets" not in self.complained:
        if not self.vbfNJets_branch and "vbfNJets":
            warnings.warn( "EGTree: Expected branch vbfNJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets")
        else:
            self.vbfNJets_branch.SetAddress(<void*>&self.vbfNJets_value)

        #print "making vbfVispt"
        self.vbfVispt_branch = the_tree.GetBranch("vbfVispt")
        #if not self.vbfVispt_branch and "vbfVispt" not in self.complained:
        if not self.vbfVispt_branch and "vbfVispt":
            warnings.warn( "EGTree: Expected branch vbfVispt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt")
        else:
            self.vbfVispt_branch.SetAddress(<void*>&self.vbfVispt_value)

        #print "making vbfdijetpt"
        self.vbfdijetpt_branch = the_tree.GetBranch("vbfdijetpt")
        #if not self.vbfdijetpt_branch and "vbfdijetpt" not in self.complained:
        if not self.vbfdijetpt_branch and "vbfdijetpt":
            warnings.warn( "EGTree: Expected branch vbfdijetpt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt")
        else:
            self.vbfdijetpt_branch.SetAddress(<void*>&self.vbfdijetpt_value)

        #print "making vbfditaupt"
        self.vbfditaupt_branch = the_tree.GetBranch("vbfditaupt")
        #if not self.vbfditaupt_branch and "vbfditaupt" not in self.complained:
        if not self.vbfditaupt_branch and "vbfditaupt":
            warnings.warn( "EGTree: Expected branch vbfditaupt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfditaupt")
        else:
            self.vbfditaupt_branch.SetAddress(<void*>&self.vbfditaupt_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "EGTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "EGTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "EGTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "EGTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "EGTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property eJetPartonFlavour:
        def __get__(self):
            self.eJetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.eJetPartonFlavour_value

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

    property eJetaxis1:
        def __get__(self):
            self.eJetaxis1_branch.GetEntry(self.localentry, 0)
            return self.eJetaxis1_value

    property eJetaxis2:
        def __get__(self):
            self.eJetaxis2_branch.GetEntry(self.localentry, 0)
            return self.eJetaxis2_value

    property eJetmult:
        def __get__(self):
            self.eJetmult_branch.GetEntry(self.localentry, 0)
            return self.eJetmult_value

    property eJetmultMLP:
        def __get__(self):
            self.eJetmultMLP_branch.GetEntry(self.localentry, 0)
            return self.eJetmultMLP_value

    property eJetmultMLPQC:
        def __get__(self):
            self.eJetmultMLPQC_branch.GetEntry(self.localentry, 0)
            return self.eJetmultMLPQC_value

    property eJetptD:
        def __get__(self):
            self.eJetptD_branch.GetEntry(self.localentry, 0)
            return self.eJetptD_value

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

    property eMtToPFMET:
        def __get__(self):
            self.eMtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.eMtToPFMET_value

    property eMtToPfMet_Ty1:
        def __get__(self):
            self.eMtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_Ty1_value

    property eMtToPfMet_jes:
        def __get__(self):
            self.eMtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_jes_value

    property eMtToPfMet_mes:
        def __get__(self):
            self.eMtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_mes_value

    property eMtToPfMet_tes:
        def __get__(self):
            self.eMtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_tes_value

    property eMtToPfMet_ues:
        def __get__(self):
            self.eMtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_ues_value

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

    property eVetoCicTightIso:
        def __get__(self):
            self.eVetoCicTightIso_branch.GetEntry(self.localentry, 0)
            return self.eVetoCicTightIso_value

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

    property e_g_CosThetaStar:
        def __get__(self):
            self.e_g_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e_g_CosThetaStar_value

    property e_g_DPhi:
        def __get__(self):
            self.e_g_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e_g_DPhi_value

    property e_g_DR:
        def __get__(self):
            self.e_g_DR_branch.GetEntry(self.localentry, 0)
            return self.e_g_DR_value

    property e_g_Mass:
        def __get__(self):
            self.e_g_Mass_branch.GetEntry(self.localentry, 0)
            return self.e_g_Mass_value

    property e_g_MassFsr:
        def __get__(self):
            self.e_g_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e_g_MassFsr_value

    property e_g_PZeta:
        def __get__(self):
            self.e_g_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e_g_PZeta_value

    property e_g_PZetaVis:
        def __get__(self):
            self.e_g_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_g_PZetaVis_value

    property e_g_Pt:
        def __get__(self):
            self.e_g_Pt_branch.GetEntry(self.localentry, 0)
            return self.e_g_Pt_value

    property e_g_PtFsr:
        def __get__(self):
            self.e_g_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e_g_PtFsr_value

    property e_g_SS:
        def __get__(self):
            self.e_g_SS_branch.GetEntry(self.localentry, 0)
            return self.e_g_SS_value

    property e_g_ToMETDPhi_Ty1:
        def __get__(self):
            self.e_g_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e_g_ToMETDPhi_Ty1_value

    property e_g_Zcompat:
        def __get__(self):
            self.e_g_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e_g_Zcompat_value

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

    property gAbsEta:
        def __get__(self):
            self.gAbsEta_branch.GetEntry(self.localentry, 0)
            return self.gAbsEta_value

    property gCBID_LOOSE:
        def __get__(self):
            self.gCBID_LOOSE_branch.GetEntry(self.localentry, 0)
            return self.gCBID_LOOSE_value

    property gCBID_MEDIUM:
        def __get__(self):
            self.gCBID_MEDIUM_branch.GetEntry(self.localentry, 0)
            return self.gCBID_MEDIUM_value

    property gCBID_TIGHT:
        def __get__(self):
            self.gCBID_TIGHT_branch.GetEntry(self.localentry, 0)
            return self.gCBID_TIGHT_value

    property gCharge:
        def __get__(self):
            self.gCharge_branch.GetEntry(self.localentry, 0)
            return self.gCharge_value

    property gComesFromHiggs:
        def __get__(self):
            self.gComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.gComesFromHiggs_value

    property gConvSafeElectronVeto:
        def __get__(self):
            self.gConvSafeElectronVeto_branch.GetEntry(self.localentry, 0)
            return self.gConvSafeElectronVeto_value

    property gE1x5:
        def __get__(self):
            self.gE1x5_branch.GetEntry(self.localentry, 0)
            return self.gE1x5_value

    property gE2x5:
        def __get__(self):
            self.gE2x5_branch.GetEntry(self.localentry, 0)
            return self.gE2x5_value

    property gE3x3:
        def __get__(self):
            self.gE3x3_branch.GetEntry(self.localentry, 0)
            return self.gE3x3_value

    property gE5x5:
        def __get__(self):
            self.gE5x5_branch.GetEntry(self.localentry, 0)
            return self.gE5x5_value

    property gECorrPHOSPHOR2011:
        def __get__(self):
            self.gECorrPHOSPHOR2011_branch.GetEntry(self.localentry, 0)
            return self.gECorrPHOSPHOR2011_value

    property gECorrPHOSPHOR2012:
        def __get__(self):
            self.gECorrPHOSPHOR2012_branch.GetEntry(self.localentry, 0)
            return self.gECorrPHOSPHOR2012_value

    property gEffectiveAreaCHad:
        def __get__(self):
            self.gEffectiveAreaCHad_branch.GetEntry(self.localentry, 0)
            return self.gEffectiveAreaCHad_value

    property gEffectiveAreaNHad:
        def __get__(self):
            self.gEffectiveAreaNHad_branch.GetEntry(self.localentry, 0)
            return self.gEffectiveAreaNHad_value

    property gEffectiveAreaPho:
        def __get__(self):
            self.gEffectiveAreaPho_branch.GetEntry(self.localentry, 0)
            return self.gEffectiveAreaPho_value

    property gEta:
        def __get__(self):
            self.gEta_branch.GetEntry(self.localentry, 0)
            return self.gEta_value

    property gEtaCorrPHOSPHOR2011:
        def __get__(self):
            self.gEtaCorrPHOSPHOR2011_branch.GetEntry(self.localentry, 0)
            return self.gEtaCorrPHOSPHOR2011_value

    property gEtaCorrPHOSPHOR2012:
        def __get__(self):
            self.gEtaCorrPHOSPHOR2012_branch.GetEntry(self.localentry, 0)
            return self.gEtaCorrPHOSPHOR2012_value

    property gGenEnergy:
        def __get__(self):
            self.gGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.gGenEnergy_value

    property gGenGrandMotherPdgId:
        def __get__(self):
            self.gGenGrandMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.gGenGrandMotherPdgId_value

    property gGenMotherPdgId:
        def __get__(self):
            self.gGenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.gGenMotherPdgId_value

    property gHadronicDepth1OverEm:
        def __get__(self):
            self.gHadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.gHadronicDepth1OverEm_value

    property gHadronicDepth2OverEm:
        def __get__(self):
            self.gHadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.gHadronicDepth2OverEm_value

    property gHadronicOverEM:
        def __get__(self):
            self.gHadronicOverEM_branch.GetEntry(self.localentry, 0)
            return self.gHadronicOverEM_value

    property gHasConversionTracks:
        def __get__(self):
            self.gHasConversionTracks_branch.GetEntry(self.localentry, 0)
            return self.gHasConversionTracks_value

    property gHasPixelSeed:
        def __get__(self):
            self.gHasPixelSeed_branch.GetEntry(self.localentry, 0)
            return self.gHasPixelSeed_value

    property gIsEB:
        def __get__(self):
            self.gIsEB_branch.GetEntry(self.localentry, 0)
            return self.gIsEB_value

    property gIsEBEEGap:
        def __get__(self):
            self.gIsEBEEGap_branch.GetEntry(self.localentry, 0)
            return self.gIsEBEEGap_value

    property gIsEBEtaGap:
        def __get__(self):
            self.gIsEBEtaGap_branch.GetEntry(self.localentry, 0)
            return self.gIsEBEtaGap_value

    property gIsEBGap:
        def __get__(self):
            self.gIsEBGap_branch.GetEntry(self.localentry, 0)
            return self.gIsEBGap_value

    property gIsEBPhiGap:
        def __get__(self):
            self.gIsEBPhiGap_branch.GetEntry(self.localentry, 0)
            return self.gIsEBPhiGap_value

    property gIsEE:
        def __get__(self):
            self.gIsEE_branch.GetEntry(self.localentry, 0)
            return self.gIsEE_value

    property gIsEEDeeGap:
        def __get__(self):
            self.gIsEEDeeGap_branch.GetEntry(self.localentry, 0)
            return self.gIsEEDeeGap_value

    property gIsEEGap:
        def __get__(self):
            self.gIsEEGap_branch.GetEntry(self.localentry, 0)
            return self.gIsEEGap_value

    property gIsEERingGap:
        def __get__(self):
            self.gIsEERingGap_branch.GetEntry(self.localentry, 0)
            return self.gIsEERingGap_value

    property gIsPFlowPhoton:
        def __get__(self):
            self.gIsPFlowPhoton_branch.GetEntry(self.localentry, 0)
            return self.gIsPFlowPhoton_value

    property gIsStandardPhoton:
        def __get__(self):
            self.gIsStandardPhoton_branch.GetEntry(self.localentry, 0)
            return self.gIsStandardPhoton_value

    property gJetArea:
        def __get__(self):
            self.gJetArea_branch.GetEntry(self.localentry, 0)
            return self.gJetArea_value

    property gJetBtag:
        def __get__(self):
            self.gJetBtag_branch.GetEntry(self.localentry, 0)
            return self.gJetBtag_value

    property gJetCSVBtag:
        def __get__(self):
            self.gJetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.gJetCSVBtag_value

    property gJetEtaEtaMoment:
        def __get__(self):
            self.gJetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.gJetEtaEtaMoment_value

    property gJetEtaPhiMoment:
        def __get__(self):
            self.gJetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.gJetEtaPhiMoment_value

    property gJetEtaPhiSpread:
        def __get__(self):
            self.gJetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.gJetEtaPhiSpread_value

    property gJetPartonFlavour:
        def __get__(self):
            self.gJetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.gJetPartonFlavour_value

    property gJetPhiPhiMoment:
        def __get__(self):
            self.gJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.gJetPhiPhiMoment_value

    property gJetPt:
        def __get__(self):
            self.gJetPt_branch.GetEntry(self.localentry, 0)
            return self.gJetPt_value

    property gJetQGLikelihoodID:
        def __get__(self):
            self.gJetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.gJetQGLikelihoodID_value

    property gJetQGMVAID:
        def __get__(self):
            self.gJetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.gJetQGMVAID_value

    property gJetaxis1:
        def __get__(self):
            self.gJetaxis1_branch.GetEntry(self.localentry, 0)
            return self.gJetaxis1_value

    property gJetaxis2:
        def __get__(self):
            self.gJetaxis2_branch.GetEntry(self.localentry, 0)
            return self.gJetaxis2_value

    property gJetmult:
        def __get__(self):
            self.gJetmult_branch.GetEntry(self.localentry, 0)
            return self.gJetmult_value

    property gJetmultMLP:
        def __get__(self):
            self.gJetmultMLP_branch.GetEntry(self.localentry, 0)
            return self.gJetmultMLP_value

    property gJetmultMLPQC:
        def __get__(self):
            self.gJetmultMLPQC_branch.GetEntry(self.localentry, 0)
            return self.gJetmultMLPQC_value

    property gJetptD:
        def __get__(self):
            self.gJetptD_branch.GetEntry(self.localentry, 0)
            return self.gJetptD_value

    property gMass:
        def __get__(self):
            self.gMass_branch.GetEntry(self.localentry, 0)
            return self.gMass_value

    property gMaxEnergyXtal:
        def __get__(self):
            self.gMaxEnergyXtal_branch.GetEntry(self.localentry, 0)
            return self.gMaxEnergyXtal_value

    property gMtToMET:
        def __get__(self):
            self.gMtToMET_branch.GetEntry(self.localentry, 0)
            return self.gMtToMET_value

    property gMtToMVAMET:
        def __get__(self):
            self.gMtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.gMtToMVAMET_value

    property gMtToPFMET:
        def __get__(self):
            self.gMtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.gMtToPFMET_value

    property gMtToPfMet_Ty1:
        def __get__(self):
            self.gMtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.gMtToPfMet_Ty1_value

    property gMtToPfMet_jes:
        def __get__(self):
            self.gMtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.gMtToPfMet_jes_value

    property gMtToPfMet_mes:
        def __get__(self):
            self.gMtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.gMtToPfMet_mes_value

    property gMtToPfMet_tes:
        def __get__(self):
            self.gMtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.gMtToPfMet_tes_value

    property gMtToPfMet_ues:
        def __get__(self):
            self.gMtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.gMtToPfMet_ues_value

    property gPFChargedIso:
        def __get__(self):
            self.gPFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.gPFChargedIso_value

    property gPFNeutralIso:
        def __get__(self):
            self.gPFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.gPFNeutralIso_value

    property gPFPhotonIso:
        def __get__(self):
            self.gPFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.gPFPhotonIso_value

    property gPdgId:
        def __get__(self):
            self.gPdgId_branch.GetEntry(self.localentry, 0)
            return self.gPdgId_value

    property gPhi:
        def __get__(self):
            self.gPhi_branch.GetEntry(self.localentry, 0)
            return self.gPhi_value

    property gPhiCorrPHOSPHOR2011:
        def __get__(self):
            self.gPhiCorrPHOSPHOR2011_branch.GetEntry(self.localentry, 0)
            return self.gPhiCorrPHOSPHOR2011_value

    property gPhiCorrPHOSPHOR2012:
        def __get__(self):
            self.gPhiCorrPHOSPHOR2012_branch.GetEntry(self.localentry, 0)
            return self.gPhiCorrPHOSPHOR2012_value

    property gPositionX:
        def __get__(self):
            self.gPositionX_branch.GetEntry(self.localentry, 0)
            return self.gPositionX_value

    property gPositionY:
        def __get__(self):
            self.gPositionY_branch.GetEntry(self.localentry, 0)
            return self.gPositionY_value

    property gPositionZ:
        def __get__(self):
            self.gPositionZ_branch.GetEntry(self.localentry, 0)
            return self.gPositionZ_value

    property gPt:
        def __get__(self):
            self.gPt_branch.GetEntry(self.localentry, 0)
            return self.gPt_value

    property gPtCorrPHOSPHOR2011:
        def __get__(self):
            self.gPtCorrPHOSPHOR2011_branch.GetEntry(self.localentry, 0)
            return self.gPtCorrPHOSPHOR2011_value

    property gPtCorrPHOSPHOR2012:
        def __get__(self):
            self.gPtCorrPHOSPHOR2012_branch.GetEntry(self.localentry, 0)
            return self.gPtCorrPHOSPHOR2012_value

    property gR1x5:
        def __get__(self):
            self.gR1x5_branch.GetEntry(self.localentry, 0)
            return self.gR1x5_value

    property gR2x5:
        def __get__(self):
            self.gR2x5_branch.GetEntry(self.localentry, 0)
            return self.gR2x5_value

    property gR9:
        def __get__(self):
            self.gR9_branch.GetEntry(self.localentry, 0)
            return self.gR9_value

    property gRank:
        def __get__(self):
            self.gRank_branch.GetEntry(self.localentry, 0)
            return self.gRank_value

    property gRho:
        def __get__(self):
            self.gRho_branch.GetEntry(self.localentry, 0)
            return self.gRho_value

    property gSCEnergy:
        def __get__(self):
            self.gSCEnergy_branch.GetEntry(self.localentry, 0)
            return self.gSCEnergy_value

    property gSCEta:
        def __get__(self):
            self.gSCEta_branch.GetEntry(self.localentry, 0)
            return self.gSCEta_value

    property gSCEtaWidth:
        def __get__(self):
            self.gSCEtaWidth_branch.GetEntry(self.localentry, 0)
            return self.gSCEtaWidth_value

    property gSCPhi:
        def __get__(self):
            self.gSCPhi_branch.GetEntry(self.localentry, 0)
            return self.gSCPhi_value

    property gSCPhiWidth:
        def __get__(self):
            self.gSCPhiWidth_branch.GetEntry(self.localentry, 0)
            return self.gSCPhiWidth_value

    property gSCPositionX:
        def __get__(self):
            self.gSCPositionX_branch.GetEntry(self.localentry, 0)
            return self.gSCPositionX_value

    property gSCPositionY:
        def __get__(self):
            self.gSCPositionY_branch.GetEntry(self.localentry, 0)
            return self.gSCPositionY_value

    property gSCPositionZ:
        def __get__(self):
            self.gSCPositionZ_branch.GetEntry(self.localentry, 0)
            return self.gSCPositionZ_value

    property gSCPreshowerEnergy:
        def __get__(self):
            self.gSCPreshowerEnergy_branch.GetEntry(self.localentry, 0)
            return self.gSCPreshowerEnergy_value

    property gSCRawEnergy:
        def __get__(self):
            self.gSCRawEnergy_branch.GetEntry(self.localentry, 0)
            return self.gSCRawEnergy_value

    property gSigmaIEtaIEta:
        def __get__(self):
            self.gSigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.gSigmaIEtaIEta_value

    property gSingleTowerHadronicDepth1OverEm:
        def __get__(self):
            self.gSingleTowerHadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.gSingleTowerHadronicDepth1OverEm_value

    property gSingleTowerHadronicDepth2OverEm:
        def __get__(self):
            self.gSingleTowerHadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.gSingleTowerHadronicDepth2OverEm_value

    property gSingleTowerHadronicOverEm:
        def __get__(self):
            self.gSingleTowerHadronicOverEm_branch.GetEntry(self.localentry, 0)
            return self.gSingleTowerHadronicOverEm_value

    property gToMETDPhi:
        def __get__(self):
            self.gToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.gToMETDPhi_value

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

    property jetVeto30:
        def __get__(self):
            self.jetVeto30_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_value

    property jetVeto30_DR05:
        def __get__(self):
            self.jetVeto30_DR05_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_DR05_value

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

    property mva_metEt:
        def __get__(self):
            self.mva_metEt_branch.GetEntry(self.localentry, 0)
            return self.mva_metEt_value

    property mva_metPhi:
        def __get__(self):
            self.mva_metPhi_branch.GetEntry(self.localentry, 0)
            return self.mva_metPhi_value

    property nTruePU:
        def __get__(self):
            self.nTruePU_branch.GetEntry(self.localentry, 0)
            return self.nTruePU_value

    property nvtx:
        def __get__(self):
            self.nvtx_branch.GetEntry(self.localentry, 0)
            return self.nvtx_value

    property pfMetEt:
        def __get__(self):
            self.pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.pfMetEt_value

    property pfMetPhi:
        def __get__(self):
            self.pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.pfMetPhi_value

    property pfMet_jes_Et:
        def __get__(self):
            self.pfMet_jes_Et_branch.GetEntry(self.localentry, 0)
            return self.pfMet_jes_Et_value

    property pfMet_jes_Phi:
        def __get__(self):
            self.pfMet_jes_Phi_branch.GetEntry(self.localentry, 0)
            return self.pfMet_jes_Phi_value

    property pfMet_mes_Et:
        def __get__(self):
            self.pfMet_mes_Et_branch.GetEntry(self.localentry, 0)
            return self.pfMet_mes_Et_value

    property pfMet_mes_Phi:
        def __get__(self):
            self.pfMet_mes_Phi_branch.GetEntry(self.localentry, 0)
            return self.pfMet_mes_Phi_value

    property pfMet_tes_Et:
        def __get__(self):
            self.pfMet_tes_Et_branch.GetEntry(self.localentry, 0)
            return self.pfMet_tes_Et_value

    property pfMet_tes_Phi:
        def __get__(self):
            self.pfMet_tes_Phi_branch.GetEntry(self.localentry, 0)
            return self.pfMet_tes_Phi_value

    property pfMet_ues_Et:
        def __get__(self):
            self.pfMet_ues_Et_branch.GetEntry(self.localentry, 0)
            return self.pfMet_ues_Et_value

    property pfMet_ues_Phi:
        def __get__(self):
            self.pfMet_ues_Phi_branch.GetEntry(self.localentry, 0)
            return self.pfMet_ues_Phi_value

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

    property type1_pfMetEt:
        def __get__(self):
            self.type1_pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetEt_value

    property type1_pfMetPhi:
        def __get__(self):
            self.type1_pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetPhi_value

    property vbfDeta:
        def __get__(self):
            self.vbfDeta_branch.GetEntry(self.localentry, 0)
            return self.vbfDeta_value

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


