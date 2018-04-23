

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

cdef class EMuMuTree:
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

    cdef TBranch* Flag_BadChargedCandidateFilter_branch
    cdef float Flag_BadChargedCandidateFilter_value

    cdef TBranch* Flag_BadPFMuonFilter_branch
    cdef float Flag_BadPFMuonFilter_value

    cdef TBranch* Flag_EcalDeadCellTriggerPrimitiveFilter_branch
    cdef float Flag_EcalDeadCellTriggerPrimitiveFilter_value

    cdef TBranch* Flag_HBHENoiseFilter_branch
    cdef float Flag_HBHENoiseFilter_value

    cdef TBranch* Flag_HBHENoiseIsoFilter_branch
    cdef float Flag_HBHENoiseIsoFilter_value

    cdef TBranch* Flag_badCloneMuonFilter_branch
    cdef float Flag_badCloneMuonFilter_value

    cdef TBranch* Flag_badGlobalMuonFilter_branch
    cdef float Flag_badGlobalMuonFilter_value

    cdef TBranch* Flag_badMuons_branch
    cdef float Flag_badMuons_value

    cdef TBranch* Flag_duplicateMuons_branch
    cdef float Flag_duplicateMuons_value

    cdef TBranch* Flag_eeBadScFilter_branch
    cdef float Flag_eeBadScFilter_value

    cdef TBranch* Flag_globalTightHalo2016Filter_branch
    cdef float Flag_globalTightHalo2016Filter_value

    cdef TBranch* Flag_goodVertices_branch
    cdef float Flag_goodVertices_value

    cdef TBranch* Flag_noBadMuons_branch
    cdef float Flag_noBadMuons_value

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

    cdef TBranch* dielectronVeto_branch
    cdef float dielectronVeto_value

    cdef TBranch* dimuonVeto_branch
    cdef float dimuonVeto_value

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

    cdef TBranch* doubleTauCmbIso35RegGroup_branch
    cdef float doubleTauCmbIso35RegGroup_value

    cdef TBranch* doubleTauCmbIso35RegPass_branch
    cdef float doubleTauCmbIso35RegPass_value

    cdef TBranch* doubleTauCmbIso35RegPrescale_branch
    cdef float doubleTauCmbIso35RegPrescale_value

    cdef TBranch* doubleTauCmbIso40Group_branch
    cdef float doubleTauCmbIso40Group_value

    cdef TBranch* doubleTauCmbIso40Pass_branch
    cdef float doubleTauCmbIso40Pass_value

    cdef TBranch* doubleTauCmbIso40Prescale_branch
    cdef float doubleTauCmbIso40Prescale_value

    cdef TBranch* doubleTauCmbIso40RegGroup_branch
    cdef float doubleTauCmbIso40RegGroup_value

    cdef TBranch* doubleTauCmbIso40RegPass_branch
    cdef float doubleTauCmbIso40RegPass_value

    cdef TBranch* doubleTauCmbIso40RegPrescale_branch
    cdef float doubleTauCmbIso40RegPrescale_value

    cdef TBranch* eAbsEta_branch
    cdef float eAbsEta_value

    cdef TBranch* eCBIDLoose_branch
    cdef float eCBIDLoose_value

    cdef TBranch* eCBIDLooseNoIso_branch
    cdef float eCBIDLooseNoIso_value

    cdef TBranch* eCBIDMedium_branch
    cdef float eCBIDMedium_value

    cdef TBranch* eCBIDMediumNoIso_branch
    cdef float eCBIDMediumNoIso_value

    cdef TBranch* eCBIDTight_branch
    cdef float eCBIDTight_value

    cdef TBranch* eCBIDTightNoIso_branch
    cdef float eCBIDTightNoIso_value

    cdef TBranch* eCBIDVeto_branch
    cdef float eCBIDVeto_value

    cdef TBranch* eCBIDVetoNoIso_branch
    cdef float eCBIDVetoNoIso_value

    cdef TBranch* eCharge_branch
    cdef float eCharge_value

    cdef TBranch* eChargeIdLoose_branch
    cdef float eChargeIdLoose_value

    cdef TBranch* eChargeIdMed_branch
    cdef float eChargeIdMed_value

    cdef TBranch* eChargeIdTight_branch
    cdef float eChargeIdTight_value

    cdef TBranch* eComesFromHiggs_branch
    cdef float eComesFromHiggs_value

    cdef TBranch* eDPhiToPfMet_type1_branch
    cdef float eDPhiToPfMet_type1_value

    cdef TBranch* eE1x5_branch
    cdef float eE1x5_value

    cdef TBranch* eE2x5Max_branch
    cdef float eE2x5Max_value

    cdef TBranch* eE5x5_branch
    cdef float eE5x5_value

    cdef TBranch* eEcalIsoDR03_branch
    cdef float eEcalIsoDR03_value

    cdef TBranch* eEffectiveArea2012Data_branch
    cdef float eEffectiveArea2012Data_value

    cdef TBranch* eEffectiveAreaSpring15_branch
    cdef float eEffectiveAreaSpring15_value

    cdef TBranch* eEnergyError_branch
    cdef float eEnergyError_value

    cdef TBranch* eErsatzGenEta_branch
    cdef float eErsatzGenEta_value

    cdef TBranch* eErsatzGenM_branch
    cdef float eErsatzGenM_value

    cdef TBranch* eErsatzGenPhi_branch
    cdef float eErsatzGenPhi_value

    cdef TBranch* eErsatzGenpT_branch
    cdef float eErsatzGenpT_value

    cdef TBranch* eErsatzGenpX_branch
    cdef float eErsatzGenpX_value

    cdef TBranch* eErsatzGenpY_branch
    cdef float eErsatzGenpY_value

    cdef TBranch* eErsatzVispX_branch
    cdef float eErsatzVispX_value

    cdef TBranch* eErsatzVispY_branch
    cdef float eErsatzVispY_value

    cdef TBranch* eEta_branch
    cdef float eEta_value

    cdef TBranch* eEta_ElectronEnDown_branch
    cdef float eEta_ElectronEnDown_value

    cdef TBranch* eEta_ElectronEnUp_branch
    cdef float eEta_ElectronEnUp_value

    cdef TBranch* eGenCharge_branch
    cdef float eGenCharge_value

    cdef TBranch* eGenDirectPromptTauDecay_branch
    cdef float eGenDirectPromptTauDecay_value

    cdef TBranch* eGenEnergy_branch
    cdef float eGenEnergy_value

    cdef TBranch* eGenEta_branch
    cdef float eGenEta_value

    cdef TBranch* eGenIsPrompt_branch
    cdef float eGenIsPrompt_value

    cdef TBranch* eGenMotherPdgId_branch
    cdef float eGenMotherPdgId_value

    cdef TBranch* eGenParticle_branch
    cdef float eGenParticle_value

    cdef TBranch* eGenPdgId_branch
    cdef float eGenPdgId_value

    cdef TBranch* eGenPhi_branch
    cdef float eGenPhi_value

    cdef TBranch* eGenPrompt_branch
    cdef float eGenPrompt_value

    cdef TBranch* eGenPromptTauDecay_branch
    cdef float eGenPromptTauDecay_value

    cdef TBranch* eGenPt_branch
    cdef float eGenPt_value

    cdef TBranch* eGenTauDecay_branch
    cdef float eGenTauDecay_value

    cdef TBranch* eGenVZ_branch
    cdef float eGenVZ_value

    cdef TBranch* eGenVtxPVMatch_branch
    cdef float eGenVtxPVMatch_value

    cdef TBranch* eHadronicDepth1OverEm_branch
    cdef float eHadronicDepth1OverEm_value

    cdef TBranch* eHadronicDepth2OverEm_branch
    cdef float eHadronicDepth2OverEm_value

    cdef TBranch* eHadronicOverEM_branch
    cdef float eHadronicOverEM_value

    cdef TBranch* eHcalIsoDR03_branch
    cdef float eHcalIsoDR03_value

    cdef TBranch* eIP3D_branch
    cdef float eIP3D_value

    cdef TBranch* eIP3DErr_branch
    cdef float eIP3DErr_value

    cdef TBranch* eIsoDB03_branch
    cdef float eIsoDB03_value

    cdef TBranch* eJetArea_branch
    cdef float eJetArea_value

    cdef TBranch* eJetBtag_branch
    cdef float eJetBtag_value

    cdef TBranch* eJetEtaEtaMoment_branch
    cdef float eJetEtaEtaMoment_value

    cdef TBranch* eJetEtaPhiMoment_branch
    cdef float eJetEtaPhiMoment_value

    cdef TBranch* eJetEtaPhiSpread_branch
    cdef float eJetEtaPhiSpread_value

    cdef TBranch* eJetHadronFlavour_branch
    cdef float eJetHadronFlavour_value

    cdef TBranch* eJetPFCISVBtag_branch
    cdef float eJetPFCISVBtag_value

    cdef TBranch* eJetPartonFlavour_branch
    cdef float eJetPartonFlavour_value

    cdef TBranch* eJetPhiPhiMoment_branch
    cdef float eJetPhiPhiMoment_value

    cdef TBranch* eJetPt_branch
    cdef float eJetPt_value

    cdef TBranch* eLowestMll_branch
    cdef float eLowestMll_value

    cdef TBranch* eMVANonTrigCategory_branch
    cdef float eMVANonTrigCategory_value

    cdef TBranch* eMVANonTrigID_branch
    cdef float eMVANonTrigID_value

    cdef TBranch* eMVANonTrigWP80_branch
    cdef float eMVANonTrigWP80_value

    cdef TBranch* eMVANonTrigWP90_branch
    cdef float eMVANonTrigWP90_value

    cdef TBranch* eMVATrigCategory_branch
    cdef float eMVATrigCategory_value

    cdef TBranch* eMVATrigID_branch
    cdef float eMVATrigID_value

    cdef TBranch* eMVATrigWP80_branch
    cdef float eMVATrigWP80_value

    cdef TBranch* eMVATrigWP90_branch
    cdef float eMVATrigWP90_value

    cdef TBranch* eMass_branch
    cdef float eMass_value

    cdef TBranch* eMatchesDoubleE_branch
    cdef float eMatchesDoubleE_value

    cdef TBranch* eMatchesDoubleESingleMu_branch
    cdef float eMatchesDoubleESingleMu_value

    cdef TBranch* eMatchesDoubleMuSingleE_branch
    cdef float eMatchesDoubleMuSingleE_value

    cdef TBranch* eMatchesEle115Filter_branch
    cdef float eMatchesEle115Filter_value

    cdef TBranch* eMatchesEle115Path_branch
    cdef float eMatchesEle115Path_value

    cdef TBranch* eMatchesEle24Tau20Filter_branch
    cdef float eMatchesEle24Tau20Filter_value

    cdef TBranch* eMatchesEle24Tau20Path_branch
    cdef float eMatchesEle24Tau20Path_value

    cdef TBranch* eMatchesEle24Tau20sL1Filter_branch
    cdef float eMatchesEle24Tau20sL1Filter_value

    cdef TBranch* eMatchesEle24Tau20sL1Path_branch
    cdef float eMatchesEle24Tau20sL1Path_value

    cdef TBranch* eMatchesEle24Tau30Filter_branch
    cdef float eMatchesEle24Tau30Filter_value

    cdef TBranch* eMatchesEle24Tau30Path_branch
    cdef float eMatchesEle24Tau30Path_value

    cdef TBranch* eMatchesEle25LooseFilter_branch
    cdef float eMatchesEle25LooseFilter_value

    cdef TBranch* eMatchesEle25TightFilter_branch
    cdef float eMatchesEle25TightFilter_value

    cdef TBranch* eMatchesEle25eta2p1TightFilter_branch
    cdef float eMatchesEle25eta2p1TightFilter_value

    cdef TBranch* eMatchesEle25eta2p1TightPath_branch
    cdef float eMatchesEle25eta2p1TightPath_value

    cdef TBranch* eMatchesEle27TightFilter_branch
    cdef float eMatchesEle27TightFilter_value

    cdef TBranch* eMatchesEle27TightPath_branch
    cdef float eMatchesEle27TightPath_value

    cdef TBranch* eMatchesEle27eta2p1LooseFilter_branch
    cdef float eMatchesEle27eta2p1LooseFilter_value

    cdef TBranch* eMatchesEle27eta2p1LoosePath_branch
    cdef float eMatchesEle27eta2p1LoosePath_value

    cdef TBranch* eMatchesEle45L1JetTauPath_branch
    cdef float eMatchesEle45L1JetTauPath_value

    cdef TBranch* eMatchesEle45LooseL1JetTauFilter_branch
    cdef float eMatchesEle45LooseL1JetTauFilter_value

    cdef TBranch* eMatchesMu23Ele12DZFilter_branch
    cdef float eMatchesMu23Ele12DZFilter_value

    cdef TBranch* eMatchesMu23Ele12DZPath_branch
    cdef float eMatchesMu23Ele12DZPath_value

    cdef TBranch* eMatchesMu23Ele12Filter_branch
    cdef float eMatchesMu23Ele12Filter_value

    cdef TBranch* eMatchesMu23Ele12Path_branch
    cdef float eMatchesMu23Ele12Path_value

    cdef TBranch* eMatchesMu23Ele8DZFilter_branch
    cdef float eMatchesMu23Ele8DZFilter_value

    cdef TBranch* eMatchesMu23Ele8DZPath_branch
    cdef float eMatchesMu23Ele8DZPath_value

    cdef TBranch* eMatchesMu23Ele8Filter_branch
    cdef float eMatchesMu23Ele8Filter_value

    cdef TBranch* eMatchesMu23Ele8Path_branch
    cdef float eMatchesMu23Ele8Path_value

    cdef TBranch* eMatchesMu8Ele23DZFilter_branch
    cdef float eMatchesMu8Ele23DZFilter_value

    cdef TBranch* eMatchesMu8Ele23DZPath_branch
    cdef float eMatchesMu8Ele23DZPath_value

    cdef TBranch* eMatchesMu8Ele23Filter_branch
    cdef float eMatchesMu8Ele23Filter_value

    cdef TBranch* eMatchesMu8Ele23Path_branch
    cdef float eMatchesMu8Ele23Path_value

    cdef TBranch* eMatchesSingleE_branch
    cdef float eMatchesSingleE_value

    cdef TBranch* eMatchesSingleESingleMu_branch
    cdef float eMatchesSingleESingleMu_value

    cdef TBranch* eMatchesSingleE_leg1_branch
    cdef float eMatchesSingleE_leg1_value

    cdef TBranch* eMatchesSingleE_leg2_branch
    cdef float eMatchesSingleE_leg2_value

    cdef TBranch* eMatchesSingleMuSingleE_branch
    cdef float eMatchesSingleMuSingleE_value

    cdef TBranch* eMatchesTripleE_branch
    cdef float eMatchesTripleE_value

    cdef TBranch* eMissingHits_branch
    cdef float eMissingHits_value

    cdef TBranch* eMtToPfMet_type1_branch
    cdef float eMtToPfMet_type1_value

    cdef TBranch* eNearMuonVeto_branch
    cdef float eNearMuonVeto_value

    cdef TBranch* eNearestMuonDR_branch
    cdef float eNearestMuonDR_value

    cdef TBranch* eNearestZMass_branch
    cdef float eNearestZMass_value

    cdef TBranch* ePFChargedIso_branch
    cdef float ePFChargedIso_value

    cdef TBranch* ePFNeutralIso_branch
    cdef float ePFNeutralIso_value

    cdef TBranch* ePFPUChargedIso_branch
    cdef float ePFPUChargedIso_value

    cdef TBranch* ePFPhotonIso_branch
    cdef float ePFPhotonIso_value

    cdef TBranch* ePVDXY_branch
    cdef float ePVDXY_value

    cdef TBranch* ePVDZ_branch
    cdef float ePVDZ_value

    cdef TBranch* ePassesConversionVeto_branch
    cdef float ePassesConversionVeto_value

    cdef TBranch* ePhi_branch
    cdef float ePhi_value

    cdef TBranch* ePhi_ElectronEnDown_branch
    cdef float ePhi_ElectronEnDown_value

    cdef TBranch* ePhi_ElectronEnUp_branch
    cdef float ePhi_ElectronEnUp_value

    cdef TBranch* ePt_branch
    cdef float ePt_value

    cdef TBranch* ePt_ElectronEnDown_branch
    cdef float ePt_ElectronEnDown_value

    cdef TBranch* ePt_ElectronEnUp_branch
    cdef float ePt_ElectronEnUp_value

    cdef TBranch* eRank_branch
    cdef float eRank_value

    cdef TBranch* eRelIso_branch
    cdef float eRelIso_value

    cdef TBranch* eRelPFIsoDB_branch
    cdef float eRelPFIsoDB_value

    cdef TBranch* eRelPFIsoRho_branch
    cdef float eRelPFIsoRho_value

    cdef TBranch* eRho_branch
    cdef float eRho_value

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

    cdef TBranch* eSIP2D_branch
    cdef float eSIP2D_value

    cdef TBranch* eSIP3D_branch
    cdef float eSIP3D_value

    cdef TBranch* eSigmaIEtaIEta_branch
    cdef float eSigmaIEtaIEta_value

    cdef TBranch* eTrkIsoDR03_branch
    cdef float eTrkIsoDR03_value

    cdef TBranch* eVZ_branch
    cdef float eVZ_value

    cdef TBranch* eVetoMVAIso_branch
    cdef float eVetoMVAIso_value

    cdef TBranch* eVetoMVAIsoVtx_branch
    cdef float eVetoMVAIsoVtx_value

    cdef TBranch* eVetoZTTp001dxyz_branch
    cdef float eVetoZTTp001dxyz_value

    cdef TBranch* eVetoZTTp001dxyzR0_branch
    cdef float eVetoZTTp001dxyzR0_value

    cdef TBranch* eWWLoose_branch
    cdef float eWWLoose_value

    cdef TBranch* eZTTGenMatching_branch
    cdef float eZTTGenMatching_value

    cdef TBranch* e_m1_CosThetaStar_branch
    cdef float e_m1_CosThetaStar_value

    cdef TBranch* e_m1_DPhi_branch
    cdef float e_m1_DPhi_value

    cdef TBranch* e_m1_DR_branch
    cdef float e_m1_DR_value

    cdef TBranch* e_m1_Eta_branch
    cdef float e_m1_Eta_value

    cdef TBranch* e_m1_Mass_branch
    cdef float e_m1_Mass_value

    cdef TBranch* e_m1_Mass_TauEnDown_branch
    cdef float e_m1_Mass_TauEnDown_value

    cdef TBranch* e_m1_Mass_TauEnUp_branch
    cdef float e_m1_Mass_TauEnUp_value

    cdef TBranch* e_m1_Mt_branch
    cdef float e_m1_Mt_value

    cdef TBranch* e_m1_MtTotal_branch
    cdef float e_m1_MtTotal_value

    cdef TBranch* e_m1_Mt_TauEnDown_branch
    cdef float e_m1_Mt_TauEnDown_value

    cdef TBranch* e_m1_Mt_TauEnUp_branch
    cdef float e_m1_Mt_TauEnUp_value

    cdef TBranch* e_m1_MvaMet_branch
    cdef float e_m1_MvaMet_value

    cdef TBranch* e_m1_MvaMetCovMatrix00_branch
    cdef float e_m1_MvaMetCovMatrix00_value

    cdef TBranch* e_m1_MvaMetCovMatrix01_branch
    cdef float e_m1_MvaMetCovMatrix01_value

    cdef TBranch* e_m1_MvaMetCovMatrix10_branch
    cdef float e_m1_MvaMetCovMatrix10_value

    cdef TBranch* e_m1_MvaMetCovMatrix11_branch
    cdef float e_m1_MvaMetCovMatrix11_value

    cdef TBranch* e_m1_MvaMetPhi_branch
    cdef float e_m1_MvaMetPhi_value

    cdef TBranch* e_m1_PZeta_branch
    cdef float e_m1_PZeta_value

    cdef TBranch* e_m1_PZetaLess0p85PZetaVis_branch
    cdef float e_m1_PZetaLess0p85PZetaVis_value

    cdef TBranch* e_m1_PZetaVis_branch
    cdef float e_m1_PZetaVis_value

    cdef TBranch* e_m1_Phi_branch
    cdef float e_m1_Phi_value

    cdef TBranch* e_m1_Pt_branch
    cdef float e_m1_Pt_value

    cdef TBranch* e_m1_SS_branch
    cdef float e_m1_SS_value

    cdef TBranch* e_m1_ToMETDPhi_Ty1_branch
    cdef float e_m1_ToMETDPhi_Ty1_value

    cdef TBranch* e_m1_collinearmass_branch
    cdef float e_m1_collinearmass_value

    cdef TBranch* e_m1_collinearmass_CheckUESDown_branch
    cdef float e_m1_collinearmass_CheckUESDown_value

    cdef TBranch* e_m1_collinearmass_CheckUESUp_branch
    cdef float e_m1_collinearmass_CheckUESUp_value

    cdef TBranch* e_m1_collinearmass_EleEnDown_branch
    cdef float e_m1_collinearmass_EleEnDown_value

    cdef TBranch* e_m1_collinearmass_EleEnUp_branch
    cdef float e_m1_collinearmass_EleEnUp_value

    cdef TBranch* e_m1_collinearmass_JetCheckTotalDown_branch
    cdef float e_m1_collinearmass_JetCheckTotalDown_value

    cdef TBranch* e_m1_collinearmass_JetCheckTotalUp_branch
    cdef float e_m1_collinearmass_JetCheckTotalUp_value

    cdef TBranch* e_m1_collinearmass_JetEnDown_branch
    cdef float e_m1_collinearmass_JetEnDown_value

    cdef TBranch* e_m1_collinearmass_JetEnUp_branch
    cdef float e_m1_collinearmass_JetEnUp_value

    cdef TBranch* e_m1_collinearmass_MuEnDown_branch
    cdef float e_m1_collinearmass_MuEnDown_value

    cdef TBranch* e_m1_collinearmass_MuEnUp_branch
    cdef float e_m1_collinearmass_MuEnUp_value

    cdef TBranch* e_m1_collinearmass_TauEnDown_branch
    cdef float e_m1_collinearmass_TauEnDown_value

    cdef TBranch* e_m1_collinearmass_TauEnUp_branch
    cdef float e_m1_collinearmass_TauEnUp_value

    cdef TBranch* e_m1_collinearmass_UnclusteredEnDown_branch
    cdef float e_m1_collinearmass_UnclusteredEnDown_value

    cdef TBranch* e_m1_collinearmass_UnclusteredEnUp_branch
    cdef float e_m1_collinearmass_UnclusteredEnUp_value

    cdef TBranch* e_m1_pt_tt_branch
    cdef float e_m1_pt_tt_value

    cdef TBranch* e_m2_CosThetaStar_branch
    cdef float e_m2_CosThetaStar_value

    cdef TBranch* e_m2_DPhi_branch
    cdef float e_m2_DPhi_value

    cdef TBranch* e_m2_DR_branch
    cdef float e_m2_DR_value

    cdef TBranch* e_m2_Eta_branch
    cdef float e_m2_Eta_value

    cdef TBranch* e_m2_Mass_branch
    cdef float e_m2_Mass_value

    cdef TBranch* e_m2_Mass_TauEnDown_branch
    cdef float e_m2_Mass_TauEnDown_value

    cdef TBranch* e_m2_Mass_TauEnUp_branch
    cdef float e_m2_Mass_TauEnUp_value

    cdef TBranch* e_m2_Mt_branch
    cdef float e_m2_Mt_value

    cdef TBranch* e_m2_MtTotal_branch
    cdef float e_m2_MtTotal_value

    cdef TBranch* e_m2_Mt_TauEnDown_branch
    cdef float e_m2_Mt_TauEnDown_value

    cdef TBranch* e_m2_Mt_TauEnUp_branch
    cdef float e_m2_Mt_TauEnUp_value

    cdef TBranch* e_m2_MvaMet_branch
    cdef float e_m2_MvaMet_value

    cdef TBranch* e_m2_MvaMetCovMatrix00_branch
    cdef float e_m2_MvaMetCovMatrix00_value

    cdef TBranch* e_m2_MvaMetCovMatrix01_branch
    cdef float e_m2_MvaMetCovMatrix01_value

    cdef TBranch* e_m2_MvaMetCovMatrix10_branch
    cdef float e_m2_MvaMetCovMatrix10_value

    cdef TBranch* e_m2_MvaMetCovMatrix11_branch
    cdef float e_m2_MvaMetCovMatrix11_value

    cdef TBranch* e_m2_MvaMetPhi_branch
    cdef float e_m2_MvaMetPhi_value

    cdef TBranch* e_m2_PZeta_branch
    cdef float e_m2_PZeta_value

    cdef TBranch* e_m2_PZetaLess0p85PZetaVis_branch
    cdef float e_m2_PZetaLess0p85PZetaVis_value

    cdef TBranch* e_m2_PZetaVis_branch
    cdef float e_m2_PZetaVis_value

    cdef TBranch* e_m2_Phi_branch
    cdef float e_m2_Phi_value

    cdef TBranch* e_m2_Pt_branch
    cdef float e_m2_Pt_value

    cdef TBranch* e_m2_SS_branch
    cdef float e_m2_SS_value

    cdef TBranch* e_m2_ToMETDPhi_Ty1_branch
    cdef float e_m2_ToMETDPhi_Ty1_value

    cdef TBranch* e_m2_collinearmass_branch
    cdef float e_m2_collinearmass_value

    cdef TBranch* e_m2_collinearmass_CheckUESDown_branch
    cdef float e_m2_collinearmass_CheckUESDown_value

    cdef TBranch* e_m2_collinearmass_CheckUESUp_branch
    cdef float e_m2_collinearmass_CheckUESUp_value

    cdef TBranch* e_m2_collinearmass_EleEnDown_branch
    cdef float e_m2_collinearmass_EleEnDown_value

    cdef TBranch* e_m2_collinearmass_EleEnUp_branch
    cdef float e_m2_collinearmass_EleEnUp_value

    cdef TBranch* e_m2_collinearmass_JetCheckTotalDown_branch
    cdef float e_m2_collinearmass_JetCheckTotalDown_value

    cdef TBranch* e_m2_collinearmass_JetCheckTotalUp_branch
    cdef float e_m2_collinearmass_JetCheckTotalUp_value

    cdef TBranch* e_m2_collinearmass_JetEnDown_branch
    cdef float e_m2_collinearmass_JetEnDown_value

    cdef TBranch* e_m2_collinearmass_JetEnUp_branch
    cdef float e_m2_collinearmass_JetEnUp_value

    cdef TBranch* e_m2_collinearmass_MuEnDown_branch
    cdef float e_m2_collinearmass_MuEnDown_value

    cdef TBranch* e_m2_collinearmass_MuEnUp_branch
    cdef float e_m2_collinearmass_MuEnUp_value

    cdef TBranch* e_m2_collinearmass_TauEnDown_branch
    cdef float e_m2_collinearmass_TauEnDown_value

    cdef TBranch* e_m2_collinearmass_TauEnUp_branch
    cdef float e_m2_collinearmass_TauEnUp_value

    cdef TBranch* e_m2_collinearmass_UnclusteredEnDown_branch
    cdef float e_m2_collinearmass_UnclusteredEnDown_value

    cdef TBranch* e_m2_collinearmass_UnclusteredEnUp_branch
    cdef float e_m2_collinearmass_UnclusteredEnUp_value

    cdef TBranch* e_m2_pt_tt_branch
    cdef float e_m2_pt_tt_value

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
    cdef unsigned long evt_value

    cdef TBranch* genEta_branch
    cdef float genEta_value

    cdef TBranch* genHTT_branch
    cdef float genHTT_value

    cdef TBranch* genM_branch
    cdef float genM_value

    cdef TBranch* genMass_branch
    cdef float genMass_value

    cdef TBranch* genPhi_branch
    cdef float genPhi_value

    cdef TBranch* genpT_branch
    cdef float genpT_value

    cdef TBranch* genpX_branch
    cdef float genpX_value

    cdef TBranch* genpY_branch
    cdef float genpY_value

    cdef TBranch* isGtautau_branch
    cdef float isGtautau_value

    cdef TBranch* isWenu_branch
    cdef float isWenu_value

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

    cdef TBranch* j1csv_branch
    cdef float j1csv_value

    cdef TBranch* j1eta_branch
    cdef float j1eta_value

    cdef TBranch* j1hadronflavor_branch
    cdef float j1hadronflavor_value

    cdef TBranch* j1partonflavor_branch
    cdef float j1partonflavor_value

    cdef TBranch* j1phi_branch
    cdef float j1phi_value

    cdef TBranch* j1pt_branch
    cdef float j1pt_value

    cdef TBranch* j1ptDown_branch
    cdef float j1ptDown_value

    cdef TBranch* j1ptUp_branch
    cdef float j1ptUp_value

    cdef TBranch* j1pu_branch
    cdef float j1pu_value

    cdef TBranch* j1rawf_branch
    cdef float j1rawf_value

    cdef TBranch* j2csv_branch
    cdef float j2csv_value

    cdef TBranch* j2eta_branch
    cdef float j2eta_value

    cdef TBranch* j2hadronflavor_branch
    cdef float j2hadronflavor_value

    cdef TBranch* j2partonflavor_branch
    cdef float j2partonflavor_value

    cdef TBranch* j2phi_branch
    cdef float j2phi_value

    cdef TBranch* j2pt_branch
    cdef float j2pt_value

    cdef TBranch* j2ptDown_branch
    cdef float j2ptDown_value

    cdef TBranch* j2ptUp_branch
    cdef float j2ptUp_value

    cdef TBranch* j2pu_branch
    cdef float j2pu_value

    cdef TBranch* j2rawf_branch
    cdef float j2rawf_value

    cdef TBranch* jb1csv_branch
    cdef float jb1csv_value

    cdef TBranch* jb1csv_CSVL_branch
    cdef float jb1csv_CSVL_value

    cdef TBranch* jb1eta_branch
    cdef float jb1eta_value

    cdef TBranch* jb1eta_CSVL_branch
    cdef float jb1eta_CSVL_value

    cdef TBranch* jb1hadronflavor_branch
    cdef float jb1hadronflavor_value

    cdef TBranch* jb1hadronflavor_CSVL_branch
    cdef float jb1hadronflavor_CSVL_value

    cdef TBranch* jb1partonflavor_branch
    cdef float jb1partonflavor_value

    cdef TBranch* jb1partonflavor_CSVL_branch
    cdef float jb1partonflavor_CSVL_value

    cdef TBranch* jb1phi_branch
    cdef float jb1phi_value

    cdef TBranch* jb1phi_CSVL_branch
    cdef float jb1phi_CSVL_value

    cdef TBranch* jb1pt_branch
    cdef float jb1pt_value

    cdef TBranch* jb1ptDown_branch
    cdef float jb1ptDown_value

    cdef TBranch* jb1ptDown_CSVL_branch
    cdef float jb1ptDown_CSVL_value

    cdef TBranch* jb1ptUp_branch
    cdef float jb1ptUp_value

    cdef TBranch* jb1ptUp_CSVL_branch
    cdef float jb1ptUp_CSVL_value

    cdef TBranch* jb1pt_CSVL_branch
    cdef float jb1pt_CSVL_value

    cdef TBranch* jb1pu_branch
    cdef float jb1pu_value

    cdef TBranch* jb1pu_CSVL_branch
    cdef float jb1pu_CSVL_value

    cdef TBranch* jb1rawf_branch
    cdef float jb1rawf_value

    cdef TBranch* jb1rawf_CSVL_branch
    cdef float jb1rawf_CSVL_value

    cdef TBranch* jb2csv_branch
    cdef float jb2csv_value

    cdef TBranch* jb2csv_CSVL_branch
    cdef float jb2csv_CSVL_value

    cdef TBranch* jb2eta_branch
    cdef float jb2eta_value

    cdef TBranch* jb2eta_CSVL_branch
    cdef float jb2eta_CSVL_value

    cdef TBranch* jb2hadronflavor_branch
    cdef float jb2hadronflavor_value

    cdef TBranch* jb2hadronflavor_CSVL_branch
    cdef float jb2hadronflavor_CSVL_value

    cdef TBranch* jb2partonflavor_branch
    cdef float jb2partonflavor_value

    cdef TBranch* jb2partonflavor_CSVL_branch
    cdef float jb2partonflavor_CSVL_value

    cdef TBranch* jb2phi_branch
    cdef float jb2phi_value

    cdef TBranch* jb2phi_CSVL_branch
    cdef float jb2phi_CSVL_value

    cdef TBranch* jb2pt_branch
    cdef float jb2pt_value

    cdef TBranch* jb2ptDown_branch
    cdef float jb2ptDown_value

    cdef TBranch* jb2ptDown_CSVL_branch
    cdef float jb2ptDown_CSVL_value

    cdef TBranch* jb2ptUp_branch
    cdef float jb2ptUp_value

    cdef TBranch* jb2ptUp_CSVL_branch
    cdef float jb2ptUp_CSVL_value

    cdef TBranch* jb2pt_CSVL_branch
    cdef float jb2pt_CSVL_value

    cdef TBranch* jb2pu_branch
    cdef float jb2pu_value

    cdef TBranch* jb2pu_CSVL_branch
    cdef float jb2pu_CSVL_value

    cdef TBranch* jb2rawf_branch
    cdef float jb2rawf_value

    cdef TBranch* jb2rawf_CSVL_branch
    cdef float jb2rawf_CSVL_value

    cdef TBranch* jetVeto20_branch
    cdef float jetVeto20_value

    cdef TBranch* jetVeto20_JetEnDown_branch
    cdef float jetVeto20_JetEnDown_value

    cdef TBranch* jetVeto20_JetEnUp_branch
    cdef float jetVeto20_JetEnUp_value

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

    cdef TBranch* jetVeto30_JetEnDown_branch
    cdef float jetVeto30_JetEnDown_value

    cdef TBranch* jetVeto30_JetEnUp_branch
    cdef float jetVeto30_JetEnUp_value

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* m1AbsEta_branch
    cdef float m1AbsEta_value

    cdef TBranch* m1BestTrackType_branch
    cdef float m1BestTrackType_value

    cdef TBranch* m1Charge_branch
    cdef float m1Charge_value

    cdef TBranch* m1Chi2LocalPosition_branch
    cdef float m1Chi2LocalPosition_value

    cdef TBranch* m1ComesFromHiggs_branch
    cdef float m1ComesFromHiggs_value

    cdef TBranch* m1DPhiToPfMet_type1_branch
    cdef float m1DPhiToPfMet_type1_value

    cdef TBranch* m1EcalIsoDR03_branch
    cdef float m1EcalIsoDR03_value

    cdef TBranch* m1EffectiveArea2011_branch
    cdef float m1EffectiveArea2011_value

    cdef TBranch* m1EffectiveArea2012_branch
    cdef float m1EffectiveArea2012_value

    cdef TBranch* m1ErsatzGenEta_branch
    cdef float m1ErsatzGenEta_value

    cdef TBranch* m1ErsatzGenM_branch
    cdef float m1ErsatzGenM_value

    cdef TBranch* m1ErsatzGenPhi_branch
    cdef float m1ErsatzGenPhi_value

    cdef TBranch* m1ErsatzGenpT_branch
    cdef float m1ErsatzGenpT_value

    cdef TBranch* m1ErsatzGenpX_branch
    cdef float m1ErsatzGenpX_value

    cdef TBranch* m1ErsatzGenpY_branch
    cdef float m1ErsatzGenpY_value

    cdef TBranch* m1ErsatzVispX_branch
    cdef float m1ErsatzVispX_value

    cdef TBranch* m1ErsatzVispY_branch
    cdef float m1ErsatzVispY_value

    cdef TBranch* m1Eta_branch
    cdef float m1Eta_value

    cdef TBranch* m1Eta_MuonEnDown_branch
    cdef float m1Eta_MuonEnDown_value

    cdef TBranch* m1Eta_MuonEnUp_branch
    cdef float m1Eta_MuonEnUp_value

    cdef TBranch* m1GenCharge_branch
    cdef float m1GenCharge_value

    cdef TBranch* m1GenDirectPromptTauDecayFinalState_branch
    cdef float m1GenDirectPromptTauDecayFinalState_value

    cdef TBranch* m1GenEnergy_branch
    cdef float m1GenEnergy_value

    cdef TBranch* m1GenEta_branch
    cdef float m1GenEta_value

    cdef TBranch* m1GenIsPrompt_branch
    cdef float m1GenIsPrompt_value

    cdef TBranch* m1GenMotherPdgId_branch
    cdef float m1GenMotherPdgId_value

    cdef TBranch* m1GenParticle_branch
    cdef float m1GenParticle_value

    cdef TBranch* m1GenPdgId_branch
    cdef float m1GenPdgId_value

    cdef TBranch* m1GenPhi_branch
    cdef float m1GenPhi_value

    cdef TBranch* m1GenPrompt_branch
    cdef float m1GenPrompt_value

    cdef TBranch* m1GenPromptFinalState_branch
    cdef float m1GenPromptFinalState_value

    cdef TBranch* m1GenPromptTauDecay_branch
    cdef float m1GenPromptTauDecay_value

    cdef TBranch* m1GenPt_branch
    cdef float m1GenPt_value

    cdef TBranch* m1GenTauDecay_branch
    cdef float m1GenTauDecay_value

    cdef TBranch* m1GenVZ_branch
    cdef float m1GenVZ_value

    cdef TBranch* m1GenVtxPVMatch_branch
    cdef float m1GenVtxPVMatch_value

    cdef TBranch* m1HcalIsoDR03_branch
    cdef float m1HcalIsoDR03_value

    cdef TBranch* m1IP3D_branch
    cdef float m1IP3D_value

    cdef TBranch* m1IP3DErr_branch
    cdef float m1IP3DErr_value

    cdef TBranch* m1IsGlobal_branch
    cdef float m1IsGlobal_value

    cdef TBranch* m1IsPFMuon_branch
    cdef float m1IsPFMuon_value

    cdef TBranch* m1IsTracker_branch
    cdef float m1IsTracker_value

    cdef TBranch* m1IsoDB03_branch
    cdef float m1IsoDB03_value

    cdef TBranch* m1IsoDB04_branch
    cdef float m1IsoDB04_value

    cdef TBranch* m1IsoMu22Filter_branch
    cdef float m1IsoMu22Filter_value

    cdef TBranch* m1IsoMu22eta2p1Filter_branch
    cdef float m1IsoMu22eta2p1Filter_value

    cdef TBranch* m1IsoMu24Filter_branch
    cdef float m1IsoMu24Filter_value

    cdef TBranch* m1IsoMu24eta2p1Filter_branch
    cdef float m1IsoMu24eta2p1Filter_value

    cdef TBranch* m1IsoTkMu22Filter_branch
    cdef float m1IsoTkMu22Filter_value

    cdef TBranch* m1IsoTkMu22eta2p1Filter_branch
    cdef float m1IsoTkMu22eta2p1Filter_value

    cdef TBranch* m1IsoTkMu24Filter_branch
    cdef float m1IsoTkMu24Filter_value

    cdef TBranch* m1IsoTkMu24eta2p1Filter_branch
    cdef float m1IsoTkMu24eta2p1Filter_value

    cdef TBranch* m1JetArea_branch
    cdef float m1JetArea_value

    cdef TBranch* m1JetBtag_branch
    cdef float m1JetBtag_value

    cdef TBranch* m1JetEtaEtaMoment_branch
    cdef float m1JetEtaEtaMoment_value

    cdef TBranch* m1JetEtaPhiMoment_branch
    cdef float m1JetEtaPhiMoment_value

    cdef TBranch* m1JetEtaPhiSpread_branch
    cdef float m1JetEtaPhiSpread_value

    cdef TBranch* m1JetHadronFlavour_branch
    cdef float m1JetHadronFlavour_value

    cdef TBranch* m1JetPFCISVBtag_branch
    cdef float m1JetPFCISVBtag_value

    cdef TBranch* m1JetPartonFlavour_branch
    cdef float m1JetPartonFlavour_value

    cdef TBranch* m1JetPhiPhiMoment_branch
    cdef float m1JetPhiPhiMoment_value

    cdef TBranch* m1JetPt_branch
    cdef float m1JetPt_value

    cdef TBranch* m1LowestMll_branch
    cdef float m1LowestMll_value

    cdef TBranch* m1Mass_branch
    cdef float m1Mass_value

    cdef TBranch* m1MatchedStations_branch
    cdef float m1MatchedStations_value

    cdef TBranch* m1MatchesDoubleESingleMu_branch
    cdef float m1MatchesDoubleESingleMu_value

    cdef TBranch* m1MatchesDoubleMu_branch
    cdef float m1MatchesDoubleMu_value

    cdef TBranch* m1MatchesDoubleMuSingleE_branch
    cdef float m1MatchesDoubleMuSingleE_value

    cdef TBranch* m1MatchesIsoMu22Path_branch
    cdef float m1MatchesIsoMu22Path_value

    cdef TBranch* m1MatchesIsoMu22eta2p1Path_branch
    cdef float m1MatchesIsoMu22eta2p1Path_value

    cdef TBranch* m1MatchesIsoMu24Path_branch
    cdef float m1MatchesIsoMu24Path_value

    cdef TBranch* m1MatchesIsoMu24eta2p1Path_branch
    cdef float m1MatchesIsoMu24eta2p1Path_value

    cdef TBranch* m1MatchesIsoTkMu22Path_branch
    cdef float m1MatchesIsoTkMu22Path_value

    cdef TBranch* m1MatchesIsoTkMu22eta2p1Path_branch
    cdef float m1MatchesIsoTkMu22eta2p1Path_value

    cdef TBranch* m1MatchesIsoTkMu24Path_branch
    cdef float m1MatchesIsoTkMu24Path_value

    cdef TBranch* m1MatchesIsoTkMu24eta2p1Path_branch
    cdef float m1MatchesIsoTkMu24eta2p1Path_value

    cdef TBranch* m1MatchesMu19Tau20Filter_branch
    cdef float m1MatchesMu19Tau20Filter_value

    cdef TBranch* m1MatchesMu19Tau20Path_branch
    cdef float m1MatchesMu19Tau20Path_value

    cdef TBranch* m1MatchesMu19Tau20sL1Filter_branch
    cdef float m1MatchesMu19Tau20sL1Filter_value

    cdef TBranch* m1MatchesMu19Tau20sL1Path_branch
    cdef float m1MatchesMu19Tau20sL1Path_value

    cdef TBranch* m1MatchesMu21Tau20sL1Filter_branch
    cdef float m1MatchesMu21Tau20sL1Filter_value

    cdef TBranch* m1MatchesMu21Tau20sL1Path_branch
    cdef float m1MatchesMu21Tau20sL1Path_value

    cdef TBranch* m1MatchesMu23Ele12DZPath_branch
    cdef float m1MatchesMu23Ele12DZPath_value

    cdef TBranch* m1MatchesMu23Ele12Path_branch
    cdef float m1MatchesMu23Ele12Path_value

    cdef TBranch* m1MatchesMu8Ele23DZPath_branch
    cdef float m1MatchesMu8Ele23DZPath_value

    cdef TBranch* m1MatchesMu8Ele23Path_branch
    cdef float m1MatchesMu8Ele23Path_value

    cdef TBranch* m1MatchesSingleESingleMu_branch
    cdef float m1MatchesSingleESingleMu_value

    cdef TBranch* m1MatchesSingleMu_branch
    cdef float m1MatchesSingleMu_value

    cdef TBranch* m1MatchesSingleMuIso20_branch
    cdef float m1MatchesSingleMuIso20_value

    cdef TBranch* m1MatchesSingleMuIsoTk20_branch
    cdef float m1MatchesSingleMuIsoTk20_value

    cdef TBranch* m1MatchesSingleMuSingleE_branch
    cdef float m1MatchesSingleMuSingleE_value

    cdef TBranch* m1MatchesSingleMu_leg1_branch
    cdef float m1MatchesSingleMu_leg1_value

    cdef TBranch* m1MatchesSingleMu_leg1_noiso_branch
    cdef float m1MatchesSingleMu_leg1_noiso_value

    cdef TBranch* m1MatchesSingleMu_leg2_branch
    cdef float m1MatchesSingleMu_leg2_value

    cdef TBranch* m1MatchesSingleMu_leg2_noiso_branch
    cdef float m1MatchesSingleMu_leg2_noiso_value

    cdef TBranch* m1MatchesTripleMu_branch
    cdef float m1MatchesTripleMu_value

    cdef TBranch* m1MtToPfMet_type1_branch
    cdef float m1MtToPfMet_type1_value

    cdef TBranch* m1Mu23Ele12DZFilter_branch
    cdef float m1Mu23Ele12DZFilter_value

    cdef TBranch* m1Mu23Ele12Filter_branch
    cdef float m1Mu23Ele12Filter_value

    cdef TBranch* m1Mu8Ele23DZFilter_branch
    cdef float m1Mu8Ele23DZFilter_value

    cdef TBranch* m1Mu8Ele23Filter_branch
    cdef float m1Mu8Ele23Filter_value

    cdef TBranch* m1MuonHits_branch
    cdef float m1MuonHits_value

    cdef TBranch* m1NearestZMass_branch
    cdef float m1NearestZMass_value

    cdef TBranch* m1NormTrkChi2_branch
    cdef float m1NormTrkChi2_value

    cdef TBranch* m1NormalizedChi2_branch
    cdef float m1NormalizedChi2_value

    cdef TBranch* m1PFChargedHadronIsoR04_branch
    cdef float m1PFChargedHadronIsoR04_value

    cdef TBranch* m1PFChargedIso_branch
    cdef float m1PFChargedIso_value

    cdef TBranch* m1PFIDLoose_branch
    cdef float m1PFIDLoose_value

    cdef TBranch* m1PFIDMedium_branch
    cdef float m1PFIDMedium_value

    cdef TBranch* m1PFIDTight_branch
    cdef float m1PFIDTight_value

    cdef TBranch* m1PFNeutralHadronIsoR04_branch
    cdef float m1PFNeutralHadronIsoR04_value

    cdef TBranch* m1PFNeutralIso_branch
    cdef float m1PFNeutralIso_value

    cdef TBranch* m1PFPUChargedIso_branch
    cdef float m1PFPUChargedIso_value

    cdef TBranch* m1PFPhotonIso_branch
    cdef float m1PFPhotonIso_value

    cdef TBranch* m1PFPhotonIsoR04_branch
    cdef float m1PFPhotonIsoR04_value

    cdef TBranch* m1PFPileupIsoR04_branch
    cdef float m1PFPileupIsoR04_value

    cdef TBranch* m1PVDXY_branch
    cdef float m1PVDXY_value

    cdef TBranch* m1PVDZ_branch
    cdef float m1PVDZ_value

    cdef TBranch* m1Phi_branch
    cdef float m1Phi_value

    cdef TBranch* m1Phi_MuonEnDown_branch
    cdef float m1Phi_MuonEnDown_value

    cdef TBranch* m1Phi_MuonEnUp_branch
    cdef float m1Phi_MuonEnUp_value

    cdef TBranch* m1PixHits_branch
    cdef float m1PixHits_value

    cdef TBranch* m1Pt_branch
    cdef float m1Pt_value

    cdef TBranch* m1Pt_MuonEnDown_branch
    cdef float m1Pt_MuonEnDown_value

    cdef TBranch* m1Pt_MuonEnUp_branch
    cdef float m1Pt_MuonEnUp_value

    cdef TBranch* m1Rank_branch
    cdef float m1Rank_value

    cdef TBranch* m1RelPFIsoDBDefault_branch
    cdef float m1RelPFIsoDBDefault_value

    cdef TBranch* m1RelPFIsoDBDefaultR04_branch
    cdef float m1RelPFIsoDBDefaultR04_value

    cdef TBranch* m1RelPFIsoRho_branch
    cdef float m1RelPFIsoRho_value

    cdef TBranch* m1Rho_branch
    cdef float m1Rho_value

    cdef TBranch* m1SIP2D_branch
    cdef float m1SIP2D_value

    cdef TBranch* m1SIP3D_branch
    cdef float m1SIP3D_value

    cdef TBranch* m1SegmentCompatibility_branch
    cdef float m1SegmentCompatibility_value

    cdef TBranch* m1TkLayersWithMeasurement_branch
    cdef float m1TkLayersWithMeasurement_value

    cdef TBranch* m1TrkIsoDR03_branch
    cdef float m1TrkIsoDR03_value

    cdef TBranch* m1TrkKink_branch
    cdef float m1TrkKink_value

    cdef TBranch* m1TypeCode_branch
    cdef int m1TypeCode_value

    cdef TBranch* m1VZ_branch
    cdef float m1VZ_value

    cdef TBranch* m1ValidFraction_branch
    cdef float m1ValidFraction_value

    cdef TBranch* m1ZTTGenMatching_branch
    cdef float m1ZTTGenMatching_value

    cdef TBranch* m1_e_collinearmass_branch
    cdef float m1_e_collinearmass_value

    cdef TBranch* m1_e_collinearmass_CheckUESDown_branch
    cdef float m1_e_collinearmass_CheckUESDown_value

    cdef TBranch* m1_e_collinearmass_CheckUESUp_branch
    cdef float m1_e_collinearmass_CheckUESUp_value

    cdef TBranch* m1_e_collinearmass_JetCheckTotalDown_branch
    cdef float m1_e_collinearmass_JetCheckTotalDown_value

    cdef TBranch* m1_e_collinearmass_JetCheckTotalUp_branch
    cdef float m1_e_collinearmass_JetCheckTotalUp_value

    cdef TBranch* m1_e_collinearmass_JetEnDown_branch
    cdef float m1_e_collinearmass_JetEnDown_value

    cdef TBranch* m1_e_collinearmass_JetEnUp_branch
    cdef float m1_e_collinearmass_JetEnUp_value

    cdef TBranch* m1_e_collinearmass_UnclusteredEnDown_branch
    cdef float m1_e_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m1_e_collinearmass_UnclusteredEnUp_branch
    cdef float m1_e_collinearmass_UnclusteredEnUp_value

    cdef TBranch* m1_m2_CosThetaStar_branch
    cdef float m1_m2_CosThetaStar_value

    cdef TBranch* m1_m2_DPhi_branch
    cdef float m1_m2_DPhi_value

    cdef TBranch* m1_m2_DR_branch
    cdef float m1_m2_DR_value

    cdef TBranch* m1_m2_Eta_branch
    cdef float m1_m2_Eta_value

    cdef TBranch* m1_m2_Mass_branch
    cdef float m1_m2_Mass_value

    cdef TBranch* m1_m2_Mass_TauEnDown_branch
    cdef float m1_m2_Mass_TauEnDown_value

    cdef TBranch* m1_m2_Mass_TauEnUp_branch
    cdef float m1_m2_Mass_TauEnUp_value

    cdef TBranch* m1_m2_Mt_branch
    cdef float m1_m2_Mt_value

    cdef TBranch* m1_m2_MtTotal_branch
    cdef float m1_m2_MtTotal_value

    cdef TBranch* m1_m2_Mt_TauEnDown_branch
    cdef float m1_m2_Mt_TauEnDown_value

    cdef TBranch* m1_m2_Mt_TauEnUp_branch
    cdef float m1_m2_Mt_TauEnUp_value

    cdef TBranch* m1_m2_MvaMet_branch
    cdef float m1_m2_MvaMet_value

    cdef TBranch* m1_m2_MvaMetCovMatrix00_branch
    cdef float m1_m2_MvaMetCovMatrix00_value

    cdef TBranch* m1_m2_MvaMetCovMatrix01_branch
    cdef float m1_m2_MvaMetCovMatrix01_value

    cdef TBranch* m1_m2_MvaMetCovMatrix10_branch
    cdef float m1_m2_MvaMetCovMatrix10_value

    cdef TBranch* m1_m2_MvaMetCovMatrix11_branch
    cdef float m1_m2_MvaMetCovMatrix11_value

    cdef TBranch* m1_m2_MvaMetPhi_branch
    cdef float m1_m2_MvaMetPhi_value

    cdef TBranch* m1_m2_PZeta_branch
    cdef float m1_m2_PZeta_value

    cdef TBranch* m1_m2_PZetaLess0p85PZetaVis_branch
    cdef float m1_m2_PZetaLess0p85PZetaVis_value

    cdef TBranch* m1_m2_PZetaVis_branch
    cdef float m1_m2_PZetaVis_value

    cdef TBranch* m1_m2_Phi_branch
    cdef float m1_m2_Phi_value

    cdef TBranch* m1_m2_Pt_branch
    cdef float m1_m2_Pt_value

    cdef TBranch* m1_m2_SS_branch
    cdef float m1_m2_SS_value

    cdef TBranch* m1_m2_ToMETDPhi_Ty1_branch
    cdef float m1_m2_ToMETDPhi_Ty1_value

    cdef TBranch* m1_m2_collinearmass_branch
    cdef float m1_m2_collinearmass_value

    cdef TBranch* m1_m2_collinearmass_CheckUESDown_branch
    cdef float m1_m2_collinearmass_CheckUESDown_value

    cdef TBranch* m1_m2_collinearmass_CheckUESUp_branch
    cdef float m1_m2_collinearmass_CheckUESUp_value

    cdef TBranch* m1_m2_collinearmass_EleEnDown_branch
    cdef float m1_m2_collinearmass_EleEnDown_value

    cdef TBranch* m1_m2_collinearmass_EleEnUp_branch
    cdef float m1_m2_collinearmass_EleEnUp_value

    cdef TBranch* m1_m2_collinearmass_JetCheckTotalDown_branch
    cdef float m1_m2_collinearmass_JetCheckTotalDown_value

    cdef TBranch* m1_m2_collinearmass_JetCheckTotalUp_branch
    cdef float m1_m2_collinearmass_JetCheckTotalUp_value

    cdef TBranch* m1_m2_collinearmass_JetEnDown_branch
    cdef float m1_m2_collinearmass_JetEnDown_value

    cdef TBranch* m1_m2_collinearmass_JetEnUp_branch
    cdef float m1_m2_collinearmass_JetEnUp_value

    cdef TBranch* m1_m2_collinearmass_MuEnDown_branch
    cdef float m1_m2_collinearmass_MuEnDown_value

    cdef TBranch* m1_m2_collinearmass_MuEnUp_branch
    cdef float m1_m2_collinearmass_MuEnUp_value

    cdef TBranch* m1_m2_collinearmass_TauEnDown_branch
    cdef float m1_m2_collinearmass_TauEnDown_value

    cdef TBranch* m1_m2_collinearmass_TauEnUp_branch
    cdef float m1_m2_collinearmass_TauEnUp_value

    cdef TBranch* m1_m2_collinearmass_UnclusteredEnDown_branch
    cdef float m1_m2_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m1_m2_collinearmass_UnclusteredEnUp_branch
    cdef float m1_m2_collinearmass_UnclusteredEnUp_value

    cdef TBranch* m1_m2_pt_tt_branch
    cdef float m1_m2_pt_tt_value

    cdef TBranch* m2AbsEta_branch
    cdef float m2AbsEta_value

    cdef TBranch* m2BestTrackType_branch
    cdef float m2BestTrackType_value

    cdef TBranch* m2Charge_branch
    cdef float m2Charge_value

    cdef TBranch* m2Chi2LocalPosition_branch
    cdef float m2Chi2LocalPosition_value

    cdef TBranch* m2ComesFromHiggs_branch
    cdef float m2ComesFromHiggs_value

    cdef TBranch* m2DPhiToPfMet_type1_branch
    cdef float m2DPhiToPfMet_type1_value

    cdef TBranch* m2EcalIsoDR03_branch
    cdef float m2EcalIsoDR03_value

    cdef TBranch* m2EffectiveArea2011_branch
    cdef float m2EffectiveArea2011_value

    cdef TBranch* m2EffectiveArea2012_branch
    cdef float m2EffectiveArea2012_value

    cdef TBranch* m2ErsatzGenEta_branch
    cdef float m2ErsatzGenEta_value

    cdef TBranch* m2ErsatzGenM_branch
    cdef float m2ErsatzGenM_value

    cdef TBranch* m2ErsatzGenPhi_branch
    cdef float m2ErsatzGenPhi_value

    cdef TBranch* m2ErsatzGenpT_branch
    cdef float m2ErsatzGenpT_value

    cdef TBranch* m2ErsatzGenpX_branch
    cdef float m2ErsatzGenpX_value

    cdef TBranch* m2ErsatzGenpY_branch
    cdef float m2ErsatzGenpY_value

    cdef TBranch* m2ErsatzVispX_branch
    cdef float m2ErsatzVispX_value

    cdef TBranch* m2ErsatzVispY_branch
    cdef float m2ErsatzVispY_value

    cdef TBranch* m2Eta_branch
    cdef float m2Eta_value

    cdef TBranch* m2Eta_MuonEnDown_branch
    cdef float m2Eta_MuonEnDown_value

    cdef TBranch* m2Eta_MuonEnUp_branch
    cdef float m2Eta_MuonEnUp_value

    cdef TBranch* m2GenCharge_branch
    cdef float m2GenCharge_value

    cdef TBranch* m2GenDirectPromptTauDecayFinalState_branch
    cdef float m2GenDirectPromptTauDecayFinalState_value

    cdef TBranch* m2GenEnergy_branch
    cdef float m2GenEnergy_value

    cdef TBranch* m2GenEta_branch
    cdef float m2GenEta_value

    cdef TBranch* m2GenIsPrompt_branch
    cdef float m2GenIsPrompt_value

    cdef TBranch* m2GenMotherPdgId_branch
    cdef float m2GenMotherPdgId_value

    cdef TBranch* m2GenParticle_branch
    cdef float m2GenParticle_value

    cdef TBranch* m2GenPdgId_branch
    cdef float m2GenPdgId_value

    cdef TBranch* m2GenPhi_branch
    cdef float m2GenPhi_value

    cdef TBranch* m2GenPrompt_branch
    cdef float m2GenPrompt_value

    cdef TBranch* m2GenPromptFinalState_branch
    cdef float m2GenPromptFinalState_value

    cdef TBranch* m2GenPromptTauDecay_branch
    cdef float m2GenPromptTauDecay_value

    cdef TBranch* m2GenPt_branch
    cdef float m2GenPt_value

    cdef TBranch* m2GenTauDecay_branch
    cdef float m2GenTauDecay_value

    cdef TBranch* m2GenVZ_branch
    cdef float m2GenVZ_value

    cdef TBranch* m2GenVtxPVMatch_branch
    cdef float m2GenVtxPVMatch_value

    cdef TBranch* m2HcalIsoDR03_branch
    cdef float m2HcalIsoDR03_value

    cdef TBranch* m2IP3D_branch
    cdef float m2IP3D_value

    cdef TBranch* m2IP3DErr_branch
    cdef float m2IP3DErr_value

    cdef TBranch* m2IsGlobal_branch
    cdef float m2IsGlobal_value

    cdef TBranch* m2IsPFMuon_branch
    cdef float m2IsPFMuon_value

    cdef TBranch* m2IsTracker_branch
    cdef float m2IsTracker_value

    cdef TBranch* m2IsoDB03_branch
    cdef float m2IsoDB03_value

    cdef TBranch* m2IsoDB04_branch
    cdef float m2IsoDB04_value

    cdef TBranch* m2IsoMu22Filter_branch
    cdef float m2IsoMu22Filter_value

    cdef TBranch* m2IsoMu22eta2p1Filter_branch
    cdef float m2IsoMu22eta2p1Filter_value

    cdef TBranch* m2IsoMu24Filter_branch
    cdef float m2IsoMu24Filter_value

    cdef TBranch* m2IsoMu24eta2p1Filter_branch
    cdef float m2IsoMu24eta2p1Filter_value

    cdef TBranch* m2IsoTkMu22Filter_branch
    cdef float m2IsoTkMu22Filter_value

    cdef TBranch* m2IsoTkMu22eta2p1Filter_branch
    cdef float m2IsoTkMu22eta2p1Filter_value

    cdef TBranch* m2IsoTkMu24Filter_branch
    cdef float m2IsoTkMu24Filter_value

    cdef TBranch* m2IsoTkMu24eta2p1Filter_branch
    cdef float m2IsoTkMu24eta2p1Filter_value

    cdef TBranch* m2JetArea_branch
    cdef float m2JetArea_value

    cdef TBranch* m2JetBtag_branch
    cdef float m2JetBtag_value

    cdef TBranch* m2JetEtaEtaMoment_branch
    cdef float m2JetEtaEtaMoment_value

    cdef TBranch* m2JetEtaPhiMoment_branch
    cdef float m2JetEtaPhiMoment_value

    cdef TBranch* m2JetEtaPhiSpread_branch
    cdef float m2JetEtaPhiSpread_value

    cdef TBranch* m2JetHadronFlavour_branch
    cdef float m2JetHadronFlavour_value

    cdef TBranch* m2JetPFCISVBtag_branch
    cdef float m2JetPFCISVBtag_value

    cdef TBranch* m2JetPartonFlavour_branch
    cdef float m2JetPartonFlavour_value

    cdef TBranch* m2JetPhiPhiMoment_branch
    cdef float m2JetPhiPhiMoment_value

    cdef TBranch* m2JetPt_branch
    cdef float m2JetPt_value

    cdef TBranch* m2LowestMll_branch
    cdef float m2LowestMll_value

    cdef TBranch* m2Mass_branch
    cdef float m2Mass_value

    cdef TBranch* m2MatchedStations_branch
    cdef float m2MatchedStations_value

    cdef TBranch* m2MatchesDoubleESingleMu_branch
    cdef float m2MatchesDoubleESingleMu_value

    cdef TBranch* m2MatchesDoubleMu_branch
    cdef float m2MatchesDoubleMu_value

    cdef TBranch* m2MatchesDoubleMuSingleE_branch
    cdef float m2MatchesDoubleMuSingleE_value

    cdef TBranch* m2MatchesIsoMu22Path_branch
    cdef float m2MatchesIsoMu22Path_value

    cdef TBranch* m2MatchesIsoMu22eta2p1Path_branch
    cdef float m2MatchesIsoMu22eta2p1Path_value

    cdef TBranch* m2MatchesIsoMu24Path_branch
    cdef float m2MatchesIsoMu24Path_value

    cdef TBranch* m2MatchesIsoMu24eta2p1Path_branch
    cdef float m2MatchesIsoMu24eta2p1Path_value

    cdef TBranch* m2MatchesIsoTkMu22Path_branch
    cdef float m2MatchesIsoTkMu22Path_value

    cdef TBranch* m2MatchesIsoTkMu22eta2p1Path_branch
    cdef float m2MatchesIsoTkMu22eta2p1Path_value

    cdef TBranch* m2MatchesIsoTkMu24Path_branch
    cdef float m2MatchesIsoTkMu24Path_value

    cdef TBranch* m2MatchesIsoTkMu24eta2p1Path_branch
    cdef float m2MatchesIsoTkMu24eta2p1Path_value

    cdef TBranch* m2MatchesMu19Tau20Filter_branch
    cdef float m2MatchesMu19Tau20Filter_value

    cdef TBranch* m2MatchesMu19Tau20Path_branch
    cdef float m2MatchesMu19Tau20Path_value

    cdef TBranch* m2MatchesMu19Tau20sL1Filter_branch
    cdef float m2MatchesMu19Tau20sL1Filter_value

    cdef TBranch* m2MatchesMu19Tau20sL1Path_branch
    cdef float m2MatchesMu19Tau20sL1Path_value

    cdef TBranch* m2MatchesMu21Tau20sL1Filter_branch
    cdef float m2MatchesMu21Tau20sL1Filter_value

    cdef TBranch* m2MatchesMu21Tau20sL1Path_branch
    cdef float m2MatchesMu21Tau20sL1Path_value

    cdef TBranch* m2MatchesMu23Ele12DZPath_branch
    cdef float m2MatchesMu23Ele12DZPath_value

    cdef TBranch* m2MatchesMu23Ele12Path_branch
    cdef float m2MatchesMu23Ele12Path_value

    cdef TBranch* m2MatchesMu8Ele23DZPath_branch
    cdef float m2MatchesMu8Ele23DZPath_value

    cdef TBranch* m2MatchesMu8Ele23Path_branch
    cdef float m2MatchesMu8Ele23Path_value

    cdef TBranch* m2MatchesSingleESingleMu_branch
    cdef float m2MatchesSingleESingleMu_value

    cdef TBranch* m2MatchesSingleMu_branch
    cdef float m2MatchesSingleMu_value

    cdef TBranch* m2MatchesSingleMuIso20_branch
    cdef float m2MatchesSingleMuIso20_value

    cdef TBranch* m2MatchesSingleMuIsoTk20_branch
    cdef float m2MatchesSingleMuIsoTk20_value

    cdef TBranch* m2MatchesSingleMuSingleE_branch
    cdef float m2MatchesSingleMuSingleE_value

    cdef TBranch* m2MatchesSingleMu_leg1_branch
    cdef float m2MatchesSingleMu_leg1_value

    cdef TBranch* m2MatchesSingleMu_leg1_noiso_branch
    cdef float m2MatchesSingleMu_leg1_noiso_value

    cdef TBranch* m2MatchesSingleMu_leg2_branch
    cdef float m2MatchesSingleMu_leg2_value

    cdef TBranch* m2MatchesSingleMu_leg2_noiso_branch
    cdef float m2MatchesSingleMu_leg2_noiso_value

    cdef TBranch* m2MatchesTripleMu_branch
    cdef float m2MatchesTripleMu_value

    cdef TBranch* m2MtToPfMet_type1_branch
    cdef float m2MtToPfMet_type1_value

    cdef TBranch* m2Mu23Ele12DZFilter_branch
    cdef float m2Mu23Ele12DZFilter_value

    cdef TBranch* m2Mu23Ele12Filter_branch
    cdef float m2Mu23Ele12Filter_value

    cdef TBranch* m2Mu8Ele23DZFilter_branch
    cdef float m2Mu8Ele23DZFilter_value

    cdef TBranch* m2Mu8Ele23Filter_branch
    cdef float m2Mu8Ele23Filter_value

    cdef TBranch* m2MuonHits_branch
    cdef float m2MuonHits_value

    cdef TBranch* m2NearestZMass_branch
    cdef float m2NearestZMass_value

    cdef TBranch* m2NormTrkChi2_branch
    cdef float m2NormTrkChi2_value

    cdef TBranch* m2NormalizedChi2_branch
    cdef float m2NormalizedChi2_value

    cdef TBranch* m2PFChargedHadronIsoR04_branch
    cdef float m2PFChargedHadronIsoR04_value

    cdef TBranch* m2PFChargedIso_branch
    cdef float m2PFChargedIso_value

    cdef TBranch* m2PFIDLoose_branch
    cdef float m2PFIDLoose_value

    cdef TBranch* m2PFIDMedium_branch
    cdef float m2PFIDMedium_value

    cdef TBranch* m2PFIDTight_branch
    cdef float m2PFIDTight_value

    cdef TBranch* m2PFNeutralHadronIsoR04_branch
    cdef float m2PFNeutralHadronIsoR04_value

    cdef TBranch* m2PFNeutralIso_branch
    cdef float m2PFNeutralIso_value

    cdef TBranch* m2PFPUChargedIso_branch
    cdef float m2PFPUChargedIso_value

    cdef TBranch* m2PFPhotonIso_branch
    cdef float m2PFPhotonIso_value

    cdef TBranch* m2PFPhotonIsoR04_branch
    cdef float m2PFPhotonIsoR04_value

    cdef TBranch* m2PFPileupIsoR04_branch
    cdef float m2PFPileupIsoR04_value

    cdef TBranch* m2PVDXY_branch
    cdef float m2PVDXY_value

    cdef TBranch* m2PVDZ_branch
    cdef float m2PVDZ_value

    cdef TBranch* m2Phi_branch
    cdef float m2Phi_value

    cdef TBranch* m2Phi_MuonEnDown_branch
    cdef float m2Phi_MuonEnDown_value

    cdef TBranch* m2Phi_MuonEnUp_branch
    cdef float m2Phi_MuonEnUp_value

    cdef TBranch* m2PixHits_branch
    cdef float m2PixHits_value

    cdef TBranch* m2Pt_branch
    cdef float m2Pt_value

    cdef TBranch* m2Pt_MuonEnDown_branch
    cdef float m2Pt_MuonEnDown_value

    cdef TBranch* m2Pt_MuonEnUp_branch
    cdef float m2Pt_MuonEnUp_value

    cdef TBranch* m2Rank_branch
    cdef float m2Rank_value

    cdef TBranch* m2RelPFIsoDBDefault_branch
    cdef float m2RelPFIsoDBDefault_value

    cdef TBranch* m2RelPFIsoDBDefaultR04_branch
    cdef float m2RelPFIsoDBDefaultR04_value

    cdef TBranch* m2RelPFIsoRho_branch
    cdef float m2RelPFIsoRho_value

    cdef TBranch* m2Rho_branch
    cdef float m2Rho_value

    cdef TBranch* m2SIP2D_branch
    cdef float m2SIP2D_value

    cdef TBranch* m2SIP3D_branch
    cdef float m2SIP3D_value

    cdef TBranch* m2SegmentCompatibility_branch
    cdef float m2SegmentCompatibility_value

    cdef TBranch* m2TkLayersWithMeasurement_branch
    cdef float m2TkLayersWithMeasurement_value

    cdef TBranch* m2TrkIsoDR03_branch
    cdef float m2TrkIsoDR03_value

    cdef TBranch* m2TrkKink_branch
    cdef float m2TrkKink_value

    cdef TBranch* m2TypeCode_branch
    cdef int m2TypeCode_value

    cdef TBranch* m2VZ_branch
    cdef float m2VZ_value

    cdef TBranch* m2ValidFraction_branch
    cdef float m2ValidFraction_value

    cdef TBranch* m2ZTTGenMatching_branch
    cdef float m2ZTTGenMatching_value

    cdef TBranch* m2_e_collinearmass_branch
    cdef float m2_e_collinearmass_value

    cdef TBranch* m2_e_collinearmass_CheckUESDown_branch
    cdef float m2_e_collinearmass_CheckUESDown_value

    cdef TBranch* m2_e_collinearmass_CheckUESUp_branch
    cdef float m2_e_collinearmass_CheckUESUp_value

    cdef TBranch* m2_e_collinearmass_JetCheckTotalDown_branch
    cdef float m2_e_collinearmass_JetCheckTotalDown_value

    cdef TBranch* m2_e_collinearmass_JetCheckTotalUp_branch
    cdef float m2_e_collinearmass_JetCheckTotalUp_value

    cdef TBranch* m2_e_collinearmass_JetEnDown_branch
    cdef float m2_e_collinearmass_JetEnDown_value

    cdef TBranch* m2_e_collinearmass_JetEnUp_branch
    cdef float m2_e_collinearmass_JetEnUp_value

    cdef TBranch* m2_e_collinearmass_UnclusteredEnDown_branch
    cdef float m2_e_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m2_e_collinearmass_UnclusteredEnUp_branch
    cdef float m2_e_collinearmass_UnclusteredEnUp_value

    cdef TBranch* m2_m1_collinearmass_branch
    cdef float m2_m1_collinearmass_value

    cdef TBranch* m2_m1_collinearmass_CheckUESDown_branch
    cdef float m2_m1_collinearmass_CheckUESDown_value

    cdef TBranch* m2_m1_collinearmass_CheckUESUp_branch
    cdef float m2_m1_collinearmass_CheckUESUp_value

    cdef TBranch* m2_m1_collinearmass_JetCheckTotalDown_branch
    cdef float m2_m1_collinearmass_JetCheckTotalDown_value

    cdef TBranch* m2_m1_collinearmass_JetCheckTotalUp_branch
    cdef float m2_m1_collinearmass_JetCheckTotalUp_value

    cdef TBranch* m2_m1_collinearmass_JetEnDown_branch
    cdef float m2_m1_collinearmass_JetEnDown_value

    cdef TBranch* m2_m1_collinearmass_JetEnUp_branch
    cdef float m2_m1_collinearmass_JetEnUp_value

    cdef TBranch* m2_m1_collinearmass_UnclusteredEnDown_branch
    cdef float m2_m1_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m2_m1_collinearmass_UnclusteredEnUp_branch
    cdef float m2_m1_collinearmass_UnclusteredEnUp_value

    cdef TBranch* metSig_branch
    cdef float metSig_value

    cdef TBranch* metcov00_branch
    cdef float metcov00_value

    cdef TBranch* metcov00_DESYlike_branch
    cdef float metcov00_DESYlike_value

    cdef TBranch* metcov01_branch
    cdef float metcov01_value

    cdef TBranch* metcov01_DESYlike_branch
    cdef float metcov01_DESYlike_value

    cdef TBranch* metcov10_branch
    cdef float metcov10_value

    cdef TBranch* metcov10_DESYlike_branch
    cdef float metcov10_DESYlike_value

    cdef TBranch* metcov11_branch
    cdef float metcov11_value

    cdef TBranch* metcov11_DESYlike_branch
    cdef float metcov11_DESYlike_value

    cdef TBranch* muGlbIsoVetoPt10_branch
    cdef float muGlbIsoVetoPt10_value

    cdef TBranch* muVetoPt15IsoIdVtx_branch
    cdef float muVetoPt15IsoIdVtx_value

    cdef TBranch* muVetoPt5_branch
    cdef float muVetoPt5_value

    cdef TBranch* muVetoPt5IsoIdVtx_branch
    cdef float muVetoPt5IsoIdVtx_value

    cdef TBranch* muVetoZTTp001dxyz_branch
    cdef float muVetoZTTp001dxyz_value

    cdef TBranch* muVetoZTTp001dxyzR0_branch
    cdef float muVetoZTTp001dxyzR0_value

    cdef TBranch* nTruePU_branch
    cdef float nTruePU_value

    cdef TBranch* numGenJets_branch
    cdef float numGenJets_value

    cdef TBranch* nvtx_branch
    cdef float nvtx_value

    cdef TBranch* processID_branch
    cdef float processID_value

    cdef TBranch* puppiMetEt_branch
    cdef float puppiMetEt_value

    cdef TBranch* puppiMetPhi_branch
    cdef float puppiMetPhi_value

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

    cdef TBranch* singleE20SingleTau28Group_branch
    cdef float singleE20SingleTau28Group_value

    cdef TBranch* singleE20SingleTau28Pass_branch
    cdef float singleE20SingleTau28Pass_value

    cdef TBranch* singleE20SingleTau28Prescale_branch
    cdef float singleE20SingleTau28Prescale_value

    cdef TBranch* singleE22SingleTau20SingleL1Group_branch
    cdef float singleE22SingleTau20SingleL1Group_value

    cdef TBranch* singleE22SingleTau20SingleL1Pass_branch
    cdef float singleE22SingleTau20SingleL1Pass_value

    cdef TBranch* singleE22SingleTau20SingleL1Prescale_branch
    cdef float singleE22SingleTau20SingleL1Prescale_value

    cdef TBranch* singleE22SingleTau29Group_branch
    cdef float singleE22SingleTau29Group_value

    cdef TBranch* singleE22SingleTau29Pass_branch
    cdef float singleE22SingleTau29Pass_value

    cdef TBranch* singleE22SingleTau29Prescale_branch
    cdef float singleE22SingleTau29Prescale_value

    cdef TBranch* singleE23SingleMu8Group_branch
    cdef float singleE23SingleMu8Group_value

    cdef TBranch* singleE23SingleMu8Pass_branch
    cdef float singleE23SingleMu8Pass_value

    cdef TBranch* singleE23SingleMu8Prescale_branch
    cdef float singleE23SingleMu8Prescale_value

    cdef TBranch* singleE24SingleTau20Group_branch
    cdef float singleE24SingleTau20Group_value

    cdef TBranch* singleE24SingleTau20Pass_branch
    cdef float singleE24SingleTau20Pass_value

    cdef TBranch* singleE24SingleTau20Prescale_branch
    cdef float singleE24SingleTau20Prescale_value

    cdef TBranch* singleE24SingleTau20SingleL1Group_branch
    cdef float singleE24SingleTau20SingleL1Group_value

    cdef TBranch* singleE24SingleTau20SingleL1Pass_branch
    cdef float singleE24SingleTau20SingleL1Pass_value

    cdef TBranch* singleE24SingleTau20SingleL1Prescale_branch
    cdef float singleE24SingleTau20SingleL1Prescale_value

    cdef TBranch* singleE24SingleTau30Group_branch
    cdef float singleE24SingleTau30Group_value

    cdef TBranch* singleE24SingleTau30Pass_branch
    cdef float singleE24SingleTau30Pass_value

    cdef TBranch* singleE24SingleTau30Prescale_branch
    cdef float singleE24SingleTau30Prescale_value

    cdef TBranch* singleE25eta2p1TightGroup_branch
    cdef float singleE25eta2p1TightGroup_value

    cdef TBranch* singleE25eta2p1TightPass_branch
    cdef float singleE25eta2p1TightPass_value

    cdef TBranch* singleE25eta2p1TightPrescale_branch
    cdef float singleE25eta2p1TightPrescale_value

    cdef TBranch* singleE27SingleTau20SingleL1Group_branch
    cdef float singleE27SingleTau20SingleL1Group_value

    cdef TBranch* singleE27SingleTau20SingleL1Pass_branch
    cdef float singleE27SingleTau20SingleL1Pass_value

    cdef TBranch* singleE27SingleTau20SingleL1Prescale_branch
    cdef float singleE27SingleTau20SingleL1Prescale_value

    cdef TBranch* singleE27TightGroup_branch
    cdef float singleE27TightGroup_value

    cdef TBranch* singleE27TightPass_branch
    cdef float singleE27TightPass_value

    cdef TBranch* singleE27TightPrescale_branch
    cdef float singleE27TightPrescale_value

    cdef TBranch* singleE27eta2p1LooseGroup_branch
    cdef float singleE27eta2p1LooseGroup_value

    cdef TBranch* singleE27eta2p1LoosePass_branch
    cdef float singleE27eta2p1LoosePass_value

    cdef TBranch* singleE27eta2p1LoosePrescale_branch
    cdef float singleE27eta2p1LoosePrescale_value

    cdef TBranch* singleE27eta2p1TightGroup_branch
    cdef float singleE27eta2p1TightGroup_value

    cdef TBranch* singleE27eta2p1TightPass_branch
    cdef float singleE27eta2p1TightPass_value

    cdef TBranch* singleE27eta2p1TightPrescale_branch
    cdef float singleE27eta2p1TightPrescale_value

    cdef TBranch* singleE32SingleTau20SingleL1Group_branch
    cdef float singleE32SingleTau20SingleL1Group_value

    cdef TBranch* singleE32SingleTau20SingleL1Pass_branch
    cdef float singleE32SingleTau20SingleL1Pass_value

    cdef TBranch* singleE32SingleTau20SingleL1Prescale_branch
    cdef float singleE32SingleTau20SingleL1Prescale_value

    cdef TBranch* singleE36SingleTau30Group_branch
    cdef float singleE36SingleTau30Group_value

    cdef TBranch* singleE36SingleTau30Pass_branch
    cdef float singleE36SingleTau30Pass_value

    cdef TBranch* singleE36SingleTau30Prescale_branch
    cdef float singleE36SingleTau30Prescale_value

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

    cdef TBranch* singleIsoMu24Group_branch
    cdef float singleIsoMu24Group_value

    cdef TBranch* singleIsoMu24Pass_branch
    cdef float singleIsoMu24Pass_value

    cdef TBranch* singleIsoMu24Prescale_branch
    cdef float singleIsoMu24Prescale_value

    cdef TBranch* singleIsoMu24eta2p1Group_branch
    cdef float singleIsoMu24eta2p1Group_value

    cdef TBranch* singleIsoMu24eta2p1Pass_branch
    cdef float singleIsoMu24eta2p1Pass_value

    cdef TBranch* singleIsoMu24eta2p1Prescale_branch
    cdef float singleIsoMu24eta2p1Prescale_value

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

    cdef TBranch* singleIsoTkMu22eta2p1Group_branch
    cdef float singleIsoTkMu22eta2p1Group_value

    cdef TBranch* singleIsoTkMu22eta2p1Pass_branch
    cdef float singleIsoTkMu22eta2p1Pass_value

    cdef TBranch* singleIsoTkMu22eta2p1Prescale_branch
    cdef float singleIsoTkMu22eta2p1Prescale_value

    cdef TBranch* singleIsoTkMu24Group_branch
    cdef float singleIsoTkMu24Group_value

    cdef TBranch* singleIsoTkMu24Pass_branch
    cdef float singleIsoTkMu24Pass_value

    cdef TBranch* singleIsoTkMu24Prescale_branch
    cdef float singleIsoTkMu24Prescale_value

    cdef TBranch* singleIsoTkMu24eta2p1Group_branch
    cdef float singleIsoTkMu24eta2p1Group_value

    cdef TBranch* singleIsoTkMu24eta2p1Pass_branch
    cdef float singleIsoTkMu24eta2p1Pass_value

    cdef TBranch* singleIsoTkMu24eta2p1Prescale_branch
    cdef float singleIsoTkMu24eta2p1Prescale_value

    cdef TBranch* singleMu17SingleE12Group_branch
    cdef float singleMu17SingleE12Group_value

    cdef TBranch* singleMu17SingleE12Pass_branch
    cdef float singleMu17SingleE12Pass_value

    cdef TBranch* singleMu17SingleE12Prescale_branch
    cdef float singleMu17SingleE12Prescale_value

    cdef TBranch* singleMu19eta2p1LooseTau20Group_branch
    cdef float singleMu19eta2p1LooseTau20Group_value

    cdef TBranch* singleMu19eta2p1LooseTau20Pass_branch
    cdef float singleMu19eta2p1LooseTau20Pass_value

    cdef TBranch* singleMu19eta2p1LooseTau20Prescale_branch
    cdef float singleMu19eta2p1LooseTau20Prescale_value

    cdef TBranch* singleMu19eta2p1LooseTau20singleL1Group_branch
    cdef float singleMu19eta2p1LooseTau20singleL1Group_value

    cdef TBranch* singleMu19eta2p1LooseTau20singleL1Pass_branch
    cdef float singleMu19eta2p1LooseTau20singleL1Pass_value

    cdef TBranch* singleMu19eta2p1LooseTau20singleL1Prescale_branch
    cdef float singleMu19eta2p1LooseTau20singleL1Prescale_value

    cdef TBranch* singleMu21eta2p1LooseTau20singleL1Group_branch
    cdef float singleMu21eta2p1LooseTau20singleL1Group_value

    cdef TBranch* singleMu21eta2p1LooseTau20singleL1Pass_branch
    cdef float singleMu21eta2p1LooseTau20singleL1Pass_value

    cdef TBranch* singleMu21eta2p1LooseTau20singleL1Prescale_branch
    cdef float singleMu21eta2p1LooseTau20singleL1Prescale_value

    cdef TBranch* singleMu23SingleE12DZGroup_branch
    cdef float singleMu23SingleE12DZGroup_value

    cdef TBranch* singleMu23SingleE12DZPass_branch
    cdef float singleMu23SingleE12DZPass_value

    cdef TBranch* singleMu23SingleE12DZPrescale_branch
    cdef float singleMu23SingleE12DZPrescale_value

    cdef TBranch* singleMu23SingleE12Group_branch
    cdef float singleMu23SingleE12Group_value

    cdef TBranch* singleMu23SingleE12Pass_branch
    cdef float singleMu23SingleE12Pass_value

    cdef TBranch* singleMu23SingleE12Prescale_branch
    cdef float singleMu23SingleE12Prescale_value

    cdef TBranch* singleMu23SingleE8Group_branch
    cdef float singleMu23SingleE8Group_value

    cdef TBranch* singleMu23SingleE8Pass_branch
    cdef float singleMu23SingleE8Pass_value

    cdef TBranch* singleMu23SingleE8Prescale_branch
    cdef float singleMu23SingleE8Prescale_value

    cdef TBranch* singleMu8SingleE23DZGroup_branch
    cdef float singleMu8SingleE23DZGroup_value

    cdef TBranch* singleMu8SingleE23DZPass_branch
    cdef float singleMu8SingleE23DZPass_value

    cdef TBranch* singleMu8SingleE23DZPrescale_branch
    cdef float singleMu8SingleE23DZPrescale_value

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

    cdef TBranch* singleTau140Group_branch
    cdef float singleTau140Group_value

    cdef TBranch* singleTau140Pass_branch
    cdef float singleTau140Pass_value

    cdef TBranch* singleTau140Prescale_branch
    cdef float singleTau140Prescale_value

    cdef TBranch* singleTau140Trk50Group_branch
    cdef float singleTau140Trk50Group_value

    cdef TBranch* singleTau140Trk50Pass_branch
    cdef float singleTau140Trk50Pass_value

    cdef TBranch* singleTau140Trk50Prescale_branch
    cdef float singleTau140Trk50Prescale_value

    cdef TBranch* tauVetoPt20Loose3HitsVtx_branch
    cdef float tauVetoPt20Loose3HitsVtx_value

    cdef TBranch* tauVetoPt20TightMVALTVtx_branch
    cdef float tauVetoPt20TightMVALTVtx_value

    cdef TBranch* topQuarkPt1_branch
    cdef float topQuarkPt1_value

    cdef TBranch* topQuarkPt2_branch
    cdef float topQuarkPt2_value

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

    cdef TBranch* vbfNJets20_branch
    cdef float vbfNJets20_value

    cdef TBranch* vbfNJets20_JetEnDown_branch
    cdef float vbfNJets20_JetEnDown_value

    cdef TBranch* vbfNJets20_JetEnUp_branch
    cdef float vbfNJets20_JetEnUp_value

    cdef TBranch* vbfNJets30_branch
    cdef float vbfNJets30_value

    cdef TBranch* vbfNJets30_JetEnDown_branch
    cdef float vbfNJets30_JetEnDown_value

    cdef TBranch* vbfNJets30_JetEnUp_branch
    cdef float vbfNJets30_JetEnUp_value

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

    cdef TBranch* vispX_branch
    cdef float vispX_value

    cdef TBranch* vispY_branch
    cdef float vispY_value

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
            warnings.warn( "EMuMuTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "EMuMuTree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "EMuMuTree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "EMuMuTree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "EMuMuTree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "EMuMuTree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "EMuMuTree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_badCloneMuonFilter"
        self.Flag_badCloneMuonFilter_branch = the_tree.GetBranch("Flag_badCloneMuonFilter")
        #if not self.Flag_badCloneMuonFilter_branch and "Flag_badCloneMuonFilter" not in self.complained:
        if not self.Flag_badCloneMuonFilter_branch and "Flag_badCloneMuonFilter":
            warnings.warn( "EMuMuTree: Expected branch Flag_badCloneMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badCloneMuonFilter")
        else:
            self.Flag_badCloneMuonFilter_branch.SetAddress(<void*>&self.Flag_badCloneMuonFilter_value)

        #print "making Flag_badGlobalMuonFilter"
        self.Flag_badGlobalMuonFilter_branch = the_tree.GetBranch("Flag_badGlobalMuonFilter")
        #if not self.Flag_badGlobalMuonFilter_branch and "Flag_badGlobalMuonFilter" not in self.complained:
        if not self.Flag_badGlobalMuonFilter_branch and "Flag_badGlobalMuonFilter":
            warnings.warn( "EMuMuTree: Expected branch Flag_badGlobalMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badGlobalMuonFilter")
        else:
            self.Flag_badGlobalMuonFilter_branch.SetAddress(<void*>&self.Flag_badGlobalMuonFilter_value)

        #print "making Flag_badMuons"
        self.Flag_badMuons_branch = the_tree.GetBranch("Flag_badMuons")
        #if not self.Flag_badMuons_branch and "Flag_badMuons" not in self.complained:
        if not self.Flag_badMuons_branch and "Flag_badMuons":
            warnings.warn( "EMuMuTree: Expected branch Flag_badMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badMuons")
        else:
            self.Flag_badMuons_branch.SetAddress(<void*>&self.Flag_badMuons_value)

        #print "making Flag_duplicateMuons"
        self.Flag_duplicateMuons_branch = the_tree.GetBranch("Flag_duplicateMuons")
        #if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons" not in self.complained:
        if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons":
            warnings.warn( "EMuMuTree: Expected branch Flag_duplicateMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_duplicateMuons")
        else:
            self.Flag_duplicateMuons_branch.SetAddress(<void*>&self.Flag_duplicateMuons_value)

        #print "making Flag_eeBadScFilter"
        self.Flag_eeBadScFilter_branch = the_tree.GetBranch("Flag_eeBadScFilter")
        #if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter" not in self.complained:
        if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter":
            warnings.warn( "EMuMuTree: Expected branch Flag_eeBadScFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_eeBadScFilter")
        else:
            self.Flag_eeBadScFilter_branch.SetAddress(<void*>&self.Flag_eeBadScFilter_value)

        #print "making Flag_globalTightHalo2016Filter"
        self.Flag_globalTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalTightHalo2016Filter")
        #if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter":
            warnings.warn( "EMuMuTree: Expected branch Flag_globalTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalTightHalo2016Filter")
        else:
            self.Flag_globalTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalTightHalo2016Filter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "EMuMuTree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making Flag_noBadMuons"
        self.Flag_noBadMuons_branch = the_tree.GetBranch("Flag_noBadMuons")
        #if not self.Flag_noBadMuons_branch and "Flag_noBadMuons" not in self.complained:
        if not self.Flag_noBadMuons_branch and "Flag_noBadMuons":
            warnings.warn( "EMuMuTree: Expected branch Flag_noBadMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_noBadMuons")
        else:
            self.Flag_noBadMuons_branch.SetAddress(<void*>&self.Flag_noBadMuons_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "EMuMuTree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "EMuMuTree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "EMuMuTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "EMuMuTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "EMuMuTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "EMuMuTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "EMuMuTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "EMuMuTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "EMuMuTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "EMuMuTree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "EMuMuTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "EMuMuTree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "EMuMuTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCISVVeto20Loose"
        self.bjetCISVVeto20Loose_branch = the_tree.GetBranch("bjetCISVVeto20Loose")
        #if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose" not in self.complained:
        if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose":
            warnings.warn( "EMuMuTree: Expected branch bjetCISVVeto20Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Loose")
        else:
            self.bjetCISVVeto20Loose_branch.SetAddress(<void*>&self.bjetCISVVeto20Loose_value)

        #print "making bjetCISVVeto20Medium"
        self.bjetCISVVeto20Medium_branch = the_tree.GetBranch("bjetCISVVeto20Medium")
        #if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium" not in self.complained:
        if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium":
            warnings.warn( "EMuMuTree: Expected branch bjetCISVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Medium")
        else:
            self.bjetCISVVeto20Medium_branch.SetAddress(<void*>&self.bjetCISVVeto20Medium_value)

        #print "making bjetCISVVeto20Tight"
        self.bjetCISVVeto20Tight_branch = the_tree.GetBranch("bjetCISVVeto20Tight")
        #if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight" not in self.complained:
        if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight":
            warnings.warn( "EMuMuTree: Expected branch bjetCISVVeto20Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Tight")
        else:
            self.bjetCISVVeto20Tight_branch.SetAddress(<void*>&self.bjetCISVVeto20Tight_value)

        #print "making bjetCISVVeto30Loose"
        self.bjetCISVVeto30Loose_branch = the_tree.GetBranch("bjetCISVVeto30Loose")
        #if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose" not in self.complained:
        if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose":
            warnings.warn( "EMuMuTree: Expected branch bjetCISVVeto30Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Loose")
        else:
            self.bjetCISVVeto30Loose_branch.SetAddress(<void*>&self.bjetCISVVeto30Loose_value)

        #print "making bjetCISVVeto30Medium"
        self.bjetCISVVeto30Medium_branch = the_tree.GetBranch("bjetCISVVeto30Medium")
        #if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium" not in self.complained:
        if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium":
            warnings.warn( "EMuMuTree: Expected branch bjetCISVVeto30Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Medium")
        else:
            self.bjetCISVVeto30Medium_branch.SetAddress(<void*>&self.bjetCISVVeto30Medium_value)

        #print "making bjetCISVVeto30Tight"
        self.bjetCISVVeto30Tight_branch = the_tree.GetBranch("bjetCISVVeto30Tight")
        #if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight" not in self.complained:
        if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight":
            warnings.warn( "EMuMuTree: Expected branch bjetCISVVeto30Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Tight")
        else:
            self.bjetCISVVeto30Tight_branch.SetAddress(<void*>&self.bjetCISVVeto30Tight_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "EMuMuTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "EMuMuTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "EMuMuTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making doubleEGroup"
        self.doubleEGroup_branch = the_tree.GetBranch("doubleEGroup")
        #if not self.doubleEGroup_branch and "doubleEGroup" not in self.complained:
        if not self.doubleEGroup_branch and "doubleEGroup":
            warnings.warn( "EMuMuTree: Expected branch doubleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEGroup")
        else:
            self.doubleEGroup_branch.SetAddress(<void*>&self.doubleEGroup_value)

        #print "making doubleEPass"
        self.doubleEPass_branch = the_tree.GetBranch("doubleEPass")
        #if not self.doubleEPass_branch and "doubleEPass" not in self.complained:
        if not self.doubleEPass_branch and "doubleEPass":
            warnings.warn( "EMuMuTree: Expected branch doubleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPass")
        else:
            self.doubleEPass_branch.SetAddress(<void*>&self.doubleEPass_value)

        #print "making doubleEPrescale"
        self.doubleEPrescale_branch = the_tree.GetBranch("doubleEPrescale")
        #if not self.doubleEPrescale_branch and "doubleEPrescale" not in self.complained:
        if not self.doubleEPrescale_branch and "doubleEPrescale":
            warnings.warn( "EMuMuTree: Expected branch doubleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPrescale")
        else:
            self.doubleEPrescale_branch.SetAddress(<void*>&self.doubleEPrescale_value)

        #print "making doubleESingleMuGroup"
        self.doubleESingleMuGroup_branch = the_tree.GetBranch("doubleESingleMuGroup")
        #if not self.doubleESingleMuGroup_branch and "doubleESingleMuGroup" not in self.complained:
        if not self.doubleESingleMuGroup_branch and "doubleESingleMuGroup":
            warnings.warn( "EMuMuTree: Expected branch doubleESingleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuGroup")
        else:
            self.doubleESingleMuGroup_branch.SetAddress(<void*>&self.doubleESingleMuGroup_value)

        #print "making doubleESingleMuPass"
        self.doubleESingleMuPass_branch = the_tree.GetBranch("doubleESingleMuPass")
        #if not self.doubleESingleMuPass_branch and "doubleESingleMuPass" not in self.complained:
        if not self.doubleESingleMuPass_branch and "doubleESingleMuPass":
            warnings.warn( "EMuMuTree: Expected branch doubleESingleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuPass")
        else:
            self.doubleESingleMuPass_branch.SetAddress(<void*>&self.doubleESingleMuPass_value)

        #print "making doubleESingleMuPrescale"
        self.doubleESingleMuPrescale_branch = the_tree.GetBranch("doubleESingleMuPrescale")
        #if not self.doubleESingleMuPrescale_branch and "doubleESingleMuPrescale" not in self.complained:
        if not self.doubleESingleMuPrescale_branch and "doubleESingleMuPrescale":
            warnings.warn( "EMuMuTree: Expected branch doubleESingleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuPrescale")
        else:
            self.doubleESingleMuPrescale_branch.SetAddress(<void*>&self.doubleESingleMuPrescale_value)

        #print "making doubleE_23_12Group"
        self.doubleE_23_12Group_branch = the_tree.GetBranch("doubleE_23_12Group")
        #if not self.doubleE_23_12Group_branch and "doubleE_23_12Group" not in self.complained:
        if not self.doubleE_23_12Group_branch and "doubleE_23_12Group":
            warnings.warn( "EMuMuTree: Expected branch doubleE_23_12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Group")
        else:
            self.doubleE_23_12Group_branch.SetAddress(<void*>&self.doubleE_23_12Group_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "EMuMuTree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleE_23_12Prescale"
        self.doubleE_23_12Prescale_branch = the_tree.GetBranch("doubleE_23_12Prescale")
        #if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale" not in self.complained:
        if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale":
            warnings.warn( "EMuMuTree: Expected branch doubleE_23_12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Prescale")
        else:
            self.doubleE_23_12Prescale_branch.SetAddress(<void*>&self.doubleE_23_12Prescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "EMuMuTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "EMuMuTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "EMuMuTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuSingleEGroup"
        self.doubleMuSingleEGroup_branch = the_tree.GetBranch("doubleMuSingleEGroup")
        #if not self.doubleMuSingleEGroup_branch and "doubleMuSingleEGroup" not in self.complained:
        if not self.doubleMuSingleEGroup_branch and "doubleMuSingleEGroup":
            warnings.warn( "EMuMuTree: Expected branch doubleMuSingleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEGroup")
        else:
            self.doubleMuSingleEGroup_branch.SetAddress(<void*>&self.doubleMuSingleEGroup_value)

        #print "making doubleMuSingleEPass"
        self.doubleMuSingleEPass_branch = the_tree.GetBranch("doubleMuSingleEPass")
        #if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass" not in self.complained:
        if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass":
            warnings.warn( "EMuMuTree: Expected branch doubleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPass")
        else:
            self.doubleMuSingleEPass_branch.SetAddress(<void*>&self.doubleMuSingleEPass_value)

        #print "making doubleMuSingleEPrescale"
        self.doubleMuSingleEPrescale_branch = the_tree.GetBranch("doubleMuSingleEPrescale")
        #if not self.doubleMuSingleEPrescale_branch and "doubleMuSingleEPrescale" not in self.complained:
        if not self.doubleMuSingleEPrescale_branch and "doubleMuSingleEPrescale":
            warnings.warn( "EMuMuTree: Expected branch doubleMuSingleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPrescale")
        else:
            self.doubleMuSingleEPrescale_branch.SetAddress(<void*>&self.doubleMuSingleEPrescale_value)

        #print "making doubleTau32Group"
        self.doubleTau32Group_branch = the_tree.GetBranch("doubleTau32Group")
        #if not self.doubleTau32Group_branch and "doubleTau32Group" not in self.complained:
        if not self.doubleTau32Group_branch and "doubleTau32Group":
            warnings.warn( "EMuMuTree: Expected branch doubleTau32Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau32Group")
        else:
            self.doubleTau32Group_branch.SetAddress(<void*>&self.doubleTau32Group_value)

        #print "making doubleTau32Pass"
        self.doubleTau32Pass_branch = the_tree.GetBranch("doubleTau32Pass")
        #if not self.doubleTau32Pass_branch and "doubleTau32Pass" not in self.complained:
        if not self.doubleTau32Pass_branch and "doubleTau32Pass":
            warnings.warn( "EMuMuTree: Expected branch doubleTau32Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau32Pass")
        else:
            self.doubleTau32Pass_branch.SetAddress(<void*>&self.doubleTau32Pass_value)

        #print "making doubleTau32Prescale"
        self.doubleTau32Prescale_branch = the_tree.GetBranch("doubleTau32Prescale")
        #if not self.doubleTau32Prescale_branch and "doubleTau32Prescale" not in self.complained:
        if not self.doubleTau32Prescale_branch and "doubleTau32Prescale":
            warnings.warn( "EMuMuTree: Expected branch doubleTau32Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau32Prescale")
        else:
            self.doubleTau32Prescale_branch.SetAddress(<void*>&self.doubleTau32Prescale_value)

        #print "making doubleTau35Group"
        self.doubleTau35Group_branch = the_tree.GetBranch("doubleTau35Group")
        #if not self.doubleTau35Group_branch and "doubleTau35Group" not in self.complained:
        if not self.doubleTau35Group_branch and "doubleTau35Group":
            warnings.warn( "EMuMuTree: Expected branch doubleTau35Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Group")
        else:
            self.doubleTau35Group_branch.SetAddress(<void*>&self.doubleTau35Group_value)

        #print "making doubleTau35Pass"
        self.doubleTau35Pass_branch = the_tree.GetBranch("doubleTau35Pass")
        #if not self.doubleTau35Pass_branch and "doubleTau35Pass" not in self.complained:
        if not self.doubleTau35Pass_branch and "doubleTau35Pass":
            warnings.warn( "EMuMuTree: Expected branch doubleTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Pass")
        else:
            self.doubleTau35Pass_branch.SetAddress(<void*>&self.doubleTau35Pass_value)

        #print "making doubleTau35Prescale"
        self.doubleTau35Prescale_branch = the_tree.GetBranch("doubleTau35Prescale")
        #if not self.doubleTau35Prescale_branch and "doubleTau35Prescale" not in self.complained:
        if not self.doubleTau35Prescale_branch and "doubleTau35Prescale":
            warnings.warn( "EMuMuTree: Expected branch doubleTau35Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Prescale")
        else:
            self.doubleTau35Prescale_branch.SetAddress(<void*>&self.doubleTau35Prescale_value)

        #print "making doubleTau40Group"
        self.doubleTau40Group_branch = the_tree.GetBranch("doubleTau40Group")
        #if not self.doubleTau40Group_branch and "doubleTau40Group" not in self.complained:
        if not self.doubleTau40Group_branch and "doubleTau40Group":
            warnings.warn( "EMuMuTree: Expected branch doubleTau40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau40Group")
        else:
            self.doubleTau40Group_branch.SetAddress(<void*>&self.doubleTau40Group_value)

        #print "making doubleTau40Pass"
        self.doubleTau40Pass_branch = the_tree.GetBranch("doubleTau40Pass")
        #if not self.doubleTau40Pass_branch and "doubleTau40Pass" not in self.complained:
        if not self.doubleTau40Pass_branch and "doubleTau40Pass":
            warnings.warn( "EMuMuTree: Expected branch doubleTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau40Pass")
        else:
            self.doubleTau40Pass_branch.SetAddress(<void*>&self.doubleTau40Pass_value)

        #print "making doubleTau40Prescale"
        self.doubleTau40Prescale_branch = the_tree.GetBranch("doubleTau40Prescale")
        #if not self.doubleTau40Prescale_branch and "doubleTau40Prescale" not in self.complained:
        if not self.doubleTau40Prescale_branch and "doubleTau40Prescale":
            warnings.warn( "EMuMuTree: Expected branch doubleTau40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau40Prescale")
        else:
            self.doubleTau40Prescale_branch.SetAddress(<void*>&self.doubleTau40Prescale_value)

        #print "making doubleTauCmbIso35RegGroup"
        self.doubleTauCmbIso35RegGroup_branch = the_tree.GetBranch("doubleTauCmbIso35RegGroup")
        #if not self.doubleTauCmbIso35RegGroup_branch and "doubleTauCmbIso35RegGroup" not in self.complained:
        if not self.doubleTauCmbIso35RegGroup_branch and "doubleTauCmbIso35RegGroup":
            warnings.warn( "EMuMuTree: Expected branch doubleTauCmbIso35RegGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegGroup")
        else:
            self.doubleTauCmbIso35RegGroup_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegGroup_value)

        #print "making doubleTauCmbIso35RegPass"
        self.doubleTauCmbIso35RegPass_branch = the_tree.GetBranch("doubleTauCmbIso35RegPass")
        #if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass" not in self.complained:
        if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass":
            warnings.warn( "EMuMuTree: Expected branch doubleTauCmbIso35RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPass")
        else:
            self.doubleTauCmbIso35RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPass_value)

        #print "making doubleTauCmbIso35RegPrescale"
        self.doubleTauCmbIso35RegPrescale_branch = the_tree.GetBranch("doubleTauCmbIso35RegPrescale")
        #if not self.doubleTauCmbIso35RegPrescale_branch and "doubleTauCmbIso35RegPrescale" not in self.complained:
        if not self.doubleTauCmbIso35RegPrescale_branch and "doubleTauCmbIso35RegPrescale":
            warnings.warn( "EMuMuTree: Expected branch doubleTauCmbIso35RegPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPrescale")
        else:
            self.doubleTauCmbIso35RegPrescale_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPrescale_value)

        #print "making doubleTauCmbIso40Group"
        self.doubleTauCmbIso40Group_branch = the_tree.GetBranch("doubleTauCmbIso40Group")
        #if not self.doubleTauCmbIso40Group_branch and "doubleTauCmbIso40Group" not in self.complained:
        if not self.doubleTauCmbIso40Group_branch and "doubleTauCmbIso40Group":
            warnings.warn( "EMuMuTree: Expected branch doubleTauCmbIso40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40Group")
        else:
            self.doubleTauCmbIso40Group_branch.SetAddress(<void*>&self.doubleTauCmbIso40Group_value)

        #print "making doubleTauCmbIso40Pass"
        self.doubleTauCmbIso40Pass_branch = the_tree.GetBranch("doubleTauCmbIso40Pass")
        #if not self.doubleTauCmbIso40Pass_branch and "doubleTauCmbIso40Pass" not in self.complained:
        if not self.doubleTauCmbIso40Pass_branch and "doubleTauCmbIso40Pass":
            warnings.warn( "EMuMuTree: Expected branch doubleTauCmbIso40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40Pass")
        else:
            self.doubleTauCmbIso40Pass_branch.SetAddress(<void*>&self.doubleTauCmbIso40Pass_value)

        #print "making doubleTauCmbIso40Prescale"
        self.doubleTauCmbIso40Prescale_branch = the_tree.GetBranch("doubleTauCmbIso40Prescale")
        #if not self.doubleTauCmbIso40Prescale_branch and "doubleTauCmbIso40Prescale" not in self.complained:
        if not self.doubleTauCmbIso40Prescale_branch and "doubleTauCmbIso40Prescale":
            warnings.warn( "EMuMuTree: Expected branch doubleTauCmbIso40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40Prescale")
        else:
            self.doubleTauCmbIso40Prescale_branch.SetAddress(<void*>&self.doubleTauCmbIso40Prescale_value)

        #print "making doubleTauCmbIso40RegGroup"
        self.doubleTauCmbIso40RegGroup_branch = the_tree.GetBranch("doubleTauCmbIso40RegGroup")
        #if not self.doubleTauCmbIso40RegGroup_branch and "doubleTauCmbIso40RegGroup" not in self.complained:
        if not self.doubleTauCmbIso40RegGroup_branch and "doubleTauCmbIso40RegGroup":
            warnings.warn( "EMuMuTree: Expected branch doubleTauCmbIso40RegGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40RegGroup")
        else:
            self.doubleTauCmbIso40RegGroup_branch.SetAddress(<void*>&self.doubleTauCmbIso40RegGroup_value)

        #print "making doubleTauCmbIso40RegPass"
        self.doubleTauCmbIso40RegPass_branch = the_tree.GetBranch("doubleTauCmbIso40RegPass")
        #if not self.doubleTauCmbIso40RegPass_branch and "doubleTauCmbIso40RegPass" not in self.complained:
        if not self.doubleTauCmbIso40RegPass_branch and "doubleTauCmbIso40RegPass":
            warnings.warn( "EMuMuTree: Expected branch doubleTauCmbIso40RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40RegPass")
        else:
            self.doubleTauCmbIso40RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso40RegPass_value)

        #print "making doubleTauCmbIso40RegPrescale"
        self.doubleTauCmbIso40RegPrescale_branch = the_tree.GetBranch("doubleTauCmbIso40RegPrescale")
        #if not self.doubleTauCmbIso40RegPrescale_branch and "doubleTauCmbIso40RegPrescale" not in self.complained:
        if not self.doubleTauCmbIso40RegPrescale_branch and "doubleTauCmbIso40RegPrescale":
            warnings.warn( "EMuMuTree: Expected branch doubleTauCmbIso40RegPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40RegPrescale")
        else:
            self.doubleTauCmbIso40RegPrescale_branch.SetAddress(<void*>&self.doubleTauCmbIso40RegPrescale_value)

        #print "making eAbsEta"
        self.eAbsEta_branch = the_tree.GetBranch("eAbsEta")
        #if not self.eAbsEta_branch and "eAbsEta" not in self.complained:
        if not self.eAbsEta_branch and "eAbsEta":
            warnings.warn( "EMuMuTree: Expected branch eAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eAbsEta")
        else:
            self.eAbsEta_branch.SetAddress(<void*>&self.eAbsEta_value)

        #print "making eCBIDLoose"
        self.eCBIDLoose_branch = the_tree.GetBranch("eCBIDLoose")
        #if not self.eCBIDLoose_branch and "eCBIDLoose" not in self.complained:
        if not self.eCBIDLoose_branch and "eCBIDLoose":
            warnings.warn( "EMuMuTree: Expected branch eCBIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDLoose")
        else:
            self.eCBIDLoose_branch.SetAddress(<void*>&self.eCBIDLoose_value)

        #print "making eCBIDLooseNoIso"
        self.eCBIDLooseNoIso_branch = the_tree.GetBranch("eCBIDLooseNoIso")
        #if not self.eCBIDLooseNoIso_branch and "eCBIDLooseNoIso" not in self.complained:
        if not self.eCBIDLooseNoIso_branch and "eCBIDLooseNoIso":
            warnings.warn( "EMuMuTree: Expected branch eCBIDLooseNoIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDLooseNoIso")
        else:
            self.eCBIDLooseNoIso_branch.SetAddress(<void*>&self.eCBIDLooseNoIso_value)

        #print "making eCBIDMedium"
        self.eCBIDMedium_branch = the_tree.GetBranch("eCBIDMedium")
        #if not self.eCBIDMedium_branch and "eCBIDMedium" not in self.complained:
        if not self.eCBIDMedium_branch and "eCBIDMedium":
            warnings.warn( "EMuMuTree: Expected branch eCBIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDMedium")
        else:
            self.eCBIDMedium_branch.SetAddress(<void*>&self.eCBIDMedium_value)

        #print "making eCBIDMediumNoIso"
        self.eCBIDMediumNoIso_branch = the_tree.GetBranch("eCBIDMediumNoIso")
        #if not self.eCBIDMediumNoIso_branch and "eCBIDMediumNoIso" not in self.complained:
        if not self.eCBIDMediumNoIso_branch and "eCBIDMediumNoIso":
            warnings.warn( "EMuMuTree: Expected branch eCBIDMediumNoIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDMediumNoIso")
        else:
            self.eCBIDMediumNoIso_branch.SetAddress(<void*>&self.eCBIDMediumNoIso_value)

        #print "making eCBIDTight"
        self.eCBIDTight_branch = the_tree.GetBranch("eCBIDTight")
        #if not self.eCBIDTight_branch and "eCBIDTight" not in self.complained:
        if not self.eCBIDTight_branch and "eCBIDTight":
            warnings.warn( "EMuMuTree: Expected branch eCBIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDTight")
        else:
            self.eCBIDTight_branch.SetAddress(<void*>&self.eCBIDTight_value)

        #print "making eCBIDTightNoIso"
        self.eCBIDTightNoIso_branch = the_tree.GetBranch("eCBIDTightNoIso")
        #if not self.eCBIDTightNoIso_branch and "eCBIDTightNoIso" not in self.complained:
        if not self.eCBIDTightNoIso_branch and "eCBIDTightNoIso":
            warnings.warn( "EMuMuTree: Expected branch eCBIDTightNoIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDTightNoIso")
        else:
            self.eCBIDTightNoIso_branch.SetAddress(<void*>&self.eCBIDTightNoIso_value)

        #print "making eCBIDVeto"
        self.eCBIDVeto_branch = the_tree.GetBranch("eCBIDVeto")
        #if not self.eCBIDVeto_branch and "eCBIDVeto" not in self.complained:
        if not self.eCBIDVeto_branch and "eCBIDVeto":
            warnings.warn( "EMuMuTree: Expected branch eCBIDVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDVeto")
        else:
            self.eCBIDVeto_branch.SetAddress(<void*>&self.eCBIDVeto_value)

        #print "making eCBIDVetoNoIso"
        self.eCBIDVetoNoIso_branch = the_tree.GetBranch("eCBIDVetoNoIso")
        #if not self.eCBIDVetoNoIso_branch and "eCBIDVetoNoIso" not in self.complained:
        if not self.eCBIDVetoNoIso_branch and "eCBIDVetoNoIso":
            warnings.warn( "EMuMuTree: Expected branch eCBIDVetoNoIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDVetoNoIso")
        else:
            self.eCBIDVetoNoIso_branch.SetAddress(<void*>&self.eCBIDVetoNoIso_value)

        #print "making eCharge"
        self.eCharge_branch = the_tree.GetBranch("eCharge")
        #if not self.eCharge_branch and "eCharge" not in self.complained:
        if not self.eCharge_branch and "eCharge":
            warnings.warn( "EMuMuTree: Expected branch eCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCharge")
        else:
            self.eCharge_branch.SetAddress(<void*>&self.eCharge_value)

        #print "making eChargeIdLoose"
        self.eChargeIdLoose_branch = the_tree.GetBranch("eChargeIdLoose")
        #if not self.eChargeIdLoose_branch and "eChargeIdLoose" not in self.complained:
        if not self.eChargeIdLoose_branch and "eChargeIdLoose":
            warnings.warn( "EMuMuTree: Expected branch eChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdLoose")
        else:
            self.eChargeIdLoose_branch.SetAddress(<void*>&self.eChargeIdLoose_value)

        #print "making eChargeIdMed"
        self.eChargeIdMed_branch = the_tree.GetBranch("eChargeIdMed")
        #if not self.eChargeIdMed_branch and "eChargeIdMed" not in self.complained:
        if not self.eChargeIdMed_branch and "eChargeIdMed":
            warnings.warn( "EMuMuTree: Expected branch eChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdMed")
        else:
            self.eChargeIdMed_branch.SetAddress(<void*>&self.eChargeIdMed_value)

        #print "making eChargeIdTight"
        self.eChargeIdTight_branch = the_tree.GetBranch("eChargeIdTight")
        #if not self.eChargeIdTight_branch and "eChargeIdTight" not in self.complained:
        if not self.eChargeIdTight_branch and "eChargeIdTight":
            warnings.warn( "EMuMuTree: Expected branch eChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdTight")
        else:
            self.eChargeIdTight_branch.SetAddress(<void*>&self.eChargeIdTight_value)

        #print "making eComesFromHiggs"
        self.eComesFromHiggs_branch = the_tree.GetBranch("eComesFromHiggs")
        #if not self.eComesFromHiggs_branch and "eComesFromHiggs" not in self.complained:
        if not self.eComesFromHiggs_branch and "eComesFromHiggs":
            warnings.warn( "EMuMuTree: Expected branch eComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eComesFromHiggs")
        else:
            self.eComesFromHiggs_branch.SetAddress(<void*>&self.eComesFromHiggs_value)

        #print "making eDPhiToPfMet_type1"
        self.eDPhiToPfMet_type1_branch = the_tree.GetBranch("eDPhiToPfMet_type1")
        #if not self.eDPhiToPfMet_type1_branch and "eDPhiToPfMet_type1" not in self.complained:
        if not self.eDPhiToPfMet_type1_branch and "eDPhiToPfMet_type1":
            warnings.warn( "EMuMuTree: Expected branch eDPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eDPhiToPfMet_type1")
        else:
            self.eDPhiToPfMet_type1_branch.SetAddress(<void*>&self.eDPhiToPfMet_type1_value)

        #print "making eE1x5"
        self.eE1x5_branch = the_tree.GetBranch("eE1x5")
        #if not self.eE1x5_branch and "eE1x5" not in self.complained:
        if not self.eE1x5_branch and "eE1x5":
            warnings.warn( "EMuMuTree: Expected branch eE1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE1x5")
        else:
            self.eE1x5_branch.SetAddress(<void*>&self.eE1x5_value)

        #print "making eE2x5Max"
        self.eE2x5Max_branch = the_tree.GetBranch("eE2x5Max")
        #if not self.eE2x5Max_branch and "eE2x5Max" not in self.complained:
        if not self.eE2x5Max_branch and "eE2x5Max":
            warnings.warn( "EMuMuTree: Expected branch eE2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE2x5Max")
        else:
            self.eE2x5Max_branch.SetAddress(<void*>&self.eE2x5Max_value)

        #print "making eE5x5"
        self.eE5x5_branch = the_tree.GetBranch("eE5x5")
        #if not self.eE5x5_branch and "eE5x5" not in self.complained:
        if not self.eE5x5_branch and "eE5x5":
            warnings.warn( "EMuMuTree: Expected branch eE5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE5x5")
        else:
            self.eE5x5_branch.SetAddress(<void*>&self.eE5x5_value)

        #print "making eEcalIsoDR03"
        self.eEcalIsoDR03_branch = the_tree.GetBranch("eEcalIsoDR03")
        #if not self.eEcalIsoDR03_branch and "eEcalIsoDR03" not in self.complained:
        if not self.eEcalIsoDR03_branch and "eEcalIsoDR03":
            warnings.warn( "EMuMuTree: Expected branch eEcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEcalIsoDR03")
        else:
            self.eEcalIsoDR03_branch.SetAddress(<void*>&self.eEcalIsoDR03_value)

        #print "making eEffectiveArea2012Data"
        self.eEffectiveArea2012Data_branch = the_tree.GetBranch("eEffectiveArea2012Data")
        #if not self.eEffectiveArea2012Data_branch and "eEffectiveArea2012Data" not in self.complained:
        if not self.eEffectiveArea2012Data_branch and "eEffectiveArea2012Data":
            warnings.warn( "EMuMuTree: Expected branch eEffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveArea2012Data")
        else:
            self.eEffectiveArea2012Data_branch.SetAddress(<void*>&self.eEffectiveArea2012Data_value)

        #print "making eEffectiveAreaSpring15"
        self.eEffectiveAreaSpring15_branch = the_tree.GetBranch("eEffectiveAreaSpring15")
        #if not self.eEffectiveAreaSpring15_branch and "eEffectiveAreaSpring15" not in self.complained:
        if not self.eEffectiveAreaSpring15_branch and "eEffectiveAreaSpring15":
            warnings.warn( "EMuMuTree: Expected branch eEffectiveAreaSpring15 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveAreaSpring15")
        else:
            self.eEffectiveAreaSpring15_branch.SetAddress(<void*>&self.eEffectiveAreaSpring15_value)

        #print "making eEnergyError"
        self.eEnergyError_branch = the_tree.GetBranch("eEnergyError")
        #if not self.eEnergyError_branch and "eEnergyError" not in self.complained:
        if not self.eEnergyError_branch and "eEnergyError":
            warnings.warn( "EMuMuTree: Expected branch eEnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyError")
        else:
            self.eEnergyError_branch.SetAddress(<void*>&self.eEnergyError_value)

        #print "making eErsatzGenEta"
        self.eErsatzGenEta_branch = the_tree.GetBranch("eErsatzGenEta")
        #if not self.eErsatzGenEta_branch and "eErsatzGenEta" not in self.complained:
        if not self.eErsatzGenEta_branch and "eErsatzGenEta":
            warnings.warn( "EMuMuTree: Expected branch eErsatzGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eErsatzGenEta")
        else:
            self.eErsatzGenEta_branch.SetAddress(<void*>&self.eErsatzGenEta_value)

        #print "making eErsatzGenM"
        self.eErsatzGenM_branch = the_tree.GetBranch("eErsatzGenM")
        #if not self.eErsatzGenM_branch and "eErsatzGenM" not in self.complained:
        if not self.eErsatzGenM_branch and "eErsatzGenM":
            warnings.warn( "EMuMuTree: Expected branch eErsatzGenM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eErsatzGenM")
        else:
            self.eErsatzGenM_branch.SetAddress(<void*>&self.eErsatzGenM_value)

        #print "making eErsatzGenPhi"
        self.eErsatzGenPhi_branch = the_tree.GetBranch("eErsatzGenPhi")
        #if not self.eErsatzGenPhi_branch and "eErsatzGenPhi" not in self.complained:
        if not self.eErsatzGenPhi_branch and "eErsatzGenPhi":
            warnings.warn( "EMuMuTree: Expected branch eErsatzGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eErsatzGenPhi")
        else:
            self.eErsatzGenPhi_branch.SetAddress(<void*>&self.eErsatzGenPhi_value)

        #print "making eErsatzGenpT"
        self.eErsatzGenpT_branch = the_tree.GetBranch("eErsatzGenpT")
        #if not self.eErsatzGenpT_branch and "eErsatzGenpT" not in self.complained:
        if not self.eErsatzGenpT_branch and "eErsatzGenpT":
            warnings.warn( "EMuMuTree: Expected branch eErsatzGenpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eErsatzGenpT")
        else:
            self.eErsatzGenpT_branch.SetAddress(<void*>&self.eErsatzGenpT_value)

        #print "making eErsatzGenpX"
        self.eErsatzGenpX_branch = the_tree.GetBranch("eErsatzGenpX")
        #if not self.eErsatzGenpX_branch and "eErsatzGenpX" not in self.complained:
        if not self.eErsatzGenpX_branch and "eErsatzGenpX":
            warnings.warn( "EMuMuTree: Expected branch eErsatzGenpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eErsatzGenpX")
        else:
            self.eErsatzGenpX_branch.SetAddress(<void*>&self.eErsatzGenpX_value)

        #print "making eErsatzGenpY"
        self.eErsatzGenpY_branch = the_tree.GetBranch("eErsatzGenpY")
        #if not self.eErsatzGenpY_branch and "eErsatzGenpY" not in self.complained:
        if not self.eErsatzGenpY_branch and "eErsatzGenpY":
            warnings.warn( "EMuMuTree: Expected branch eErsatzGenpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eErsatzGenpY")
        else:
            self.eErsatzGenpY_branch.SetAddress(<void*>&self.eErsatzGenpY_value)

        #print "making eErsatzVispX"
        self.eErsatzVispX_branch = the_tree.GetBranch("eErsatzVispX")
        #if not self.eErsatzVispX_branch and "eErsatzVispX" not in self.complained:
        if not self.eErsatzVispX_branch and "eErsatzVispX":
            warnings.warn( "EMuMuTree: Expected branch eErsatzVispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eErsatzVispX")
        else:
            self.eErsatzVispX_branch.SetAddress(<void*>&self.eErsatzVispX_value)

        #print "making eErsatzVispY"
        self.eErsatzVispY_branch = the_tree.GetBranch("eErsatzVispY")
        #if not self.eErsatzVispY_branch and "eErsatzVispY" not in self.complained:
        if not self.eErsatzVispY_branch and "eErsatzVispY":
            warnings.warn( "EMuMuTree: Expected branch eErsatzVispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eErsatzVispY")
        else:
            self.eErsatzVispY_branch.SetAddress(<void*>&self.eErsatzVispY_value)

        #print "making eEta"
        self.eEta_branch = the_tree.GetBranch("eEta")
        #if not self.eEta_branch and "eEta" not in self.complained:
        if not self.eEta_branch and "eEta":
            warnings.warn( "EMuMuTree: Expected branch eEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEta")
        else:
            self.eEta_branch.SetAddress(<void*>&self.eEta_value)

        #print "making eEta_ElectronEnDown"
        self.eEta_ElectronEnDown_branch = the_tree.GetBranch("eEta_ElectronEnDown")
        #if not self.eEta_ElectronEnDown_branch and "eEta_ElectronEnDown" not in self.complained:
        if not self.eEta_ElectronEnDown_branch and "eEta_ElectronEnDown":
            warnings.warn( "EMuMuTree: Expected branch eEta_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEta_ElectronEnDown")
        else:
            self.eEta_ElectronEnDown_branch.SetAddress(<void*>&self.eEta_ElectronEnDown_value)

        #print "making eEta_ElectronEnUp"
        self.eEta_ElectronEnUp_branch = the_tree.GetBranch("eEta_ElectronEnUp")
        #if not self.eEta_ElectronEnUp_branch and "eEta_ElectronEnUp" not in self.complained:
        if not self.eEta_ElectronEnUp_branch and "eEta_ElectronEnUp":
            warnings.warn( "EMuMuTree: Expected branch eEta_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEta_ElectronEnUp")
        else:
            self.eEta_ElectronEnUp_branch.SetAddress(<void*>&self.eEta_ElectronEnUp_value)

        #print "making eGenCharge"
        self.eGenCharge_branch = the_tree.GetBranch("eGenCharge")
        #if not self.eGenCharge_branch and "eGenCharge" not in self.complained:
        if not self.eGenCharge_branch and "eGenCharge":
            warnings.warn( "EMuMuTree: Expected branch eGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenCharge")
        else:
            self.eGenCharge_branch.SetAddress(<void*>&self.eGenCharge_value)

        #print "making eGenDirectPromptTauDecay"
        self.eGenDirectPromptTauDecay_branch = the_tree.GetBranch("eGenDirectPromptTauDecay")
        #if not self.eGenDirectPromptTauDecay_branch and "eGenDirectPromptTauDecay" not in self.complained:
        if not self.eGenDirectPromptTauDecay_branch and "eGenDirectPromptTauDecay":
            warnings.warn( "EMuMuTree: Expected branch eGenDirectPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenDirectPromptTauDecay")
        else:
            self.eGenDirectPromptTauDecay_branch.SetAddress(<void*>&self.eGenDirectPromptTauDecay_value)

        #print "making eGenEnergy"
        self.eGenEnergy_branch = the_tree.GetBranch("eGenEnergy")
        #if not self.eGenEnergy_branch and "eGenEnergy" not in self.complained:
        if not self.eGenEnergy_branch and "eGenEnergy":
            warnings.warn( "EMuMuTree: Expected branch eGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEnergy")
        else:
            self.eGenEnergy_branch.SetAddress(<void*>&self.eGenEnergy_value)

        #print "making eGenEta"
        self.eGenEta_branch = the_tree.GetBranch("eGenEta")
        #if not self.eGenEta_branch and "eGenEta" not in self.complained:
        if not self.eGenEta_branch and "eGenEta":
            warnings.warn( "EMuMuTree: Expected branch eGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEta")
        else:
            self.eGenEta_branch.SetAddress(<void*>&self.eGenEta_value)

        #print "making eGenIsPrompt"
        self.eGenIsPrompt_branch = the_tree.GetBranch("eGenIsPrompt")
        #if not self.eGenIsPrompt_branch and "eGenIsPrompt" not in self.complained:
        if not self.eGenIsPrompt_branch and "eGenIsPrompt":
            warnings.warn( "EMuMuTree: Expected branch eGenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenIsPrompt")
        else:
            self.eGenIsPrompt_branch.SetAddress(<void*>&self.eGenIsPrompt_value)

        #print "making eGenMotherPdgId"
        self.eGenMotherPdgId_branch = the_tree.GetBranch("eGenMotherPdgId")
        #if not self.eGenMotherPdgId_branch and "eGenMotherPdgId" not in self.complained:
        if not self.eGenMotherPdgId_branch and "eGenMotherPdgId":
            warnings.warn( "EMuMuTree: Expected branch eGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenMotherPdgId")
        else:
            self.eGenMotherPdgId_branch.SetAddress(<void*>&self.eGenMotherPdgId_value)

        #print "making eGenParticle"
        self.eGenParticle_branch = the_tree.GetBranch("eGenParticle")
        #if not self.eGenParticle_branch and "eGenParticle" not in self.complained:
        if not self.eGenParticle_branch and "eGenParticle":
            warnings.warn( "EMuMuTree: Expected branch eGenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenParticle")
        else:
            self.eGenParticle_branch.SetAddress(<void*>&self.eGenParticle_value)

        #print "making eGenPdgId"
        self.eGenPdgId_branch = the_tree.GetBranch("eGenPdgId")
        #if not self.eGenPdgId_branch and "eGenPdgId" not in self.complained:
        if not self.eGenPdgId_branch and "eGenPdgId":
            warnings.warn( "EMuMuTree: Expected branch eGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPdgId")
        else:
            self.eGenPdgId_branch.SetAddress(<void*>&self.eGenPdgId_value)

        #print "making eGenPhi"
        self.eGenPhi_branch = the_tree.GetBranch("eGenPhi")
        #if not self.eGenPhi_branch and "eGenPhi" not in self.complained:
        if not self.eGenPhi_branch and "eGenPhi":
            warnings.warn( "EMuMuTree: Expected branch eGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPhi")
        else:
            self.eGenPhi_branch.SetAddress(<void*>&self.eGenPhi_value)

        #print "making eGenPrompt"
        self.eGenPrompt_branch = the_tree.GetBranch("eGenPrompt")
        #if not self.eGenPrompt_branch and "eGenPrompt" not in self.complained:
        if not self.eGenPrompt_branch and "eGenPrompt":
            warnings.warn( "EMuMuTree: Expected branch eGenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPrompt")
        else:
            self.eGenPrompt_branch.SetAddress(<void*>&self.eGenPrompt_value)

        #print "making eGenPromptTauDecay"
        self.eGenPromptTauDecay_branch = the_tree.GetBranch("eGenPromptTauDecay")
        #if not self.eGenPromptTauDecay_branch and "eGenPromptTauDecay" not in self.complained:
        if not self.eGenPromptTauDecay_branch and "eGenPromptTauDecay":
            warnings.warn( "EMuMuTree: Expected branch eGenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPromptTauDecay")
        else:
            self.eGenPromptTauDecay_branch.SetAddress(<void*>&self.eGenPromptTauDecay_value)

        #print "making eGenPt"
        self.eGenPt_branch = the_tree.GetBranch("eGenPt")
        #if not self.eGenPt_branch and "eGenPt" not in self.complained:
        if not self.eGenPt_branch and "eGenPt":
            warnings.warn( "EMuMuTree: Expected branch eGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPt")
        else:
            self.eGenPt_branch.SetAddress(<void*>&self.eGenPt_value)

        #print "making eGenTauDecay"
        self.eGenTauDecay_branch = the_tree.GetBranch("eGenTauDecay")
        #if not self.eGenTauDecay_branch and "eGenTauDecay" not in self.complained:
        if not self.eGenTauDecay_branch and "eGenTauDecay":
            warnings.warn( "EMuMuTree: Expected branch eGenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenTauDecay")
        else:
            self.eGenTauDecay_branch.SetAddress(<void*>&self.eGenTauDecay_value)

        #print "making eGenVZ"
        self.eGenVZ_branch = the_tree.GetBranch("eGenVZ")
        #if not self.eGenVZ_branch and "eGenVZ" not in self.complained:
        if not self.eGenVZ_branch and "eGenVZ":
            warnings.warn( "EMuMuTree: Expected branch eGenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenVZ")
        else:
            self.eGenVZ_branch.SetAddress(<void*>&self.eGenVZ_value)

        #print "making eGenVtxPVMatch"
        self.eGenVtxPVMatch_branch = the_tree.GetBranch("eGenVtxPVMatch")
        #if not self.eGenVtxPVMatch_branch and "eGenVtxPVMatch" not in self.complained:
        if not self.eGenVtxPVMatch_branch and "eGenVtxPVMatch":
            warnings.warn( "EMuMuTree: Expected branch eGenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenVtxPVMatch")
        else:
            self.eGenVtxPVMatch_branch.SetAddress(<void*>&self.eGenVtxPVMatch_value)

        #print "making eHadronicDepth1OverEm"
        self.eHadronicDepth1OverEm_branch = the_tree.GetBranch("eHadronicDepth1OverEm")
        #if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm" not in self.complained:
        if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm":
            warnings.warn( "EMuMuTree: Expected branch eHadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth1OverEm")
        else:
            self.eHadronicDepth1OverEm_branch.SetAddress(<void*>&self.eHadronicDepth1OverEm_value)

        #print "making eHadronicDepth2OverEm"
        self.eHadronicDepth2OverEm_branch = the_tree.GetBranch("eHadronicDepth2OverEm")
        #if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm" not in self.complained:
        if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm":
            warnings.warn( "EMuMuTree: Expected branch eHadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth2OverEm")
        else:
            self.eHadronicDepth2OverEm_branch.SetAddress(<void*>&self.eHadronicDepth2OverEm_value)

        #print "making eHadronicOverEM"
        self.eHadronicOverEM_branch = the_tree.GetBranch("eHadronicOverEM")
        #if not self.eHadronicOverEM_branch and "eHadronicOverEM" not in self.complained:
        if not self.eHadronicOverEM_branch and "eHadronicOverEM":
            warnings.warn( "EMuMuTree: Expected branch eHadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicOverEM")
        else:
            self.eHadronicOverEM_branch.SetAddress(<void*>&self.eHadronicOverEM_value)

        #print "making eHcalIsoDR03"
        self.eHcalIsoDR03_branch = the_tree.GetBranch("eHcalIsoDR03")
        #if not self.eHcalIsoDR03_branch and "eHcalIsoDR03" not in self.complained:
        if not self.eHcalIsoDR03_branch and "eHcalIsoDR03":
            warnings.warn( "EMuMuTree: Expected branch eHcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHcalIsoDR03")
        else:
            self.eHcalIsoDR03_branch.SetAddress(<void*>&self.eHcalIsoDR03_value)

        #print "making eIP3D"
        self.eIP3D_branch = the_tree.GetBranch("eIP3D")
        #if not self.eIP3D_branch and "eIP3D" not in self.complained:
        if not self.eIP3D_branch and "eIP3D":
            warnings.warn( "EMuMuTree: Expected branch eIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIP3D")
        else:
            self.eIP3D_branch.SetAddress(<void*>&self.eIP3D_value)

        #print "making eIP3DErr"
        self.eIP3DErr_branch = the_tree.GetBranch("eIP3DErr")
        #if not self.eIP3DErr_branch and "eIP3DErr" not in self.complained:
        if not self.eIP3DErr_branch and "eIP3DErr":
            warnings.warn( "EMuMuTree: Expected branch eIP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIP3DErr")
        else:
            self.eIP3DErr_branch.SetAddress(<void*>&self.eIP3DErr_value)

        #print "making eIsoDB03"
        self.eIsoDB03_branch = the_tree.GetBranch("eIsoDB03")
        #if not self.eIsoDB03_branch and "eIsoDB03" not in self.complained:
        if not self.eIsoDB03_branch and "eIsoDB03":
            warnings.warn( "EMuMuTree: Expected branch eIsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIsoDB03")
        else:
            self.eIsoDB03_branch.SetAddress(<void*>&self.eIsoDB03_value)

        #print "making eJetArea"
        self.eJetArea_branch = the_tree.GetBranch("eJetArea")
        #if not self.eJetArea_branch and "eJetArea" not in self.complained:
        if not self.eJetArea_branch and "eJetArea":
            warnings.warn( "EMuMuTree: Expected branch eJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetArea")
        else:
            self.eJetArea_branch.SetAddress(<void*>&self.eJetArea_value)

        #print "making eJetBtag"
        self.eJetBtag_branch = the_tree.GetBranch("eJetBtag")
        #if not self.eJetBtag_branch and "eJetBtag" not in self.complained:
        if not self.eJetBtag_branch and "eJetBtag":
            warnings.warn( "EMuMuTree: Expected branch eJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetBtag")
        else:
            self.eJetBtag_branch.SetAddress(<void*>&self.eJetBtag_value)

        #print "making eJetEtaEtaMoment"
        self.eJetEtaEtaMoment_branch = the_tree.GetBranch("eJetEtaEtaMoment")
        #if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment" not in self.complained:
        if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment":
            warnings.warn( "EMuMuTree: Expected branch eJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaEtaMoment")
        else:
            self.eJetEtaEtaMoment_branch.SetAddress(<void*>&self.eJetEtaEtaMoment_value)

        #print "making eJetEtaPhiMoment"
        self.eJetEtaPhiMoment_branch = the_tree.GetBranch("eJetEtaPhiMoment")
        #if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment" not in self.complained:
        if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment":
            warnings.warn( "EMuMuTree: Expected branch eJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiMoment")
        else:
            self.eJetEtaPhiMoment_branch.SetAddress(<void*>&self.eJetEtaPhiMoment_value)

        #print "making eJetEtaPhiSpread"
        self.eJetEtaPhiSpread_branch = the_tree.GetBranch("eJetEtaPhiSpread")
        #if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread" not in self.complained:
        if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread":
            warnings.warn( "EMuMuTree: Expected branch eJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiSpread")
        else:
            self.eJetEtaPhiSpread_branch.SetAddress(<void*>&self.eJetEtaPhiSpread_value)

        #print "making eJetHadronFlavour"
        self.eJetHadronFlavour_branch = the_tree.GetBranch("eJetHadronFlavour")
        #if not self.eJetHadronFlavour_branch and "eJetHadronFlavour" not in self.complained:
        if not self.eJetHadronFlavour_branch and "eJetHadronFlavour":
            warnings.warn( "EMuMuTree: Expected branch eJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetHadronFlavour")
        else:
            self.eJetHadronFlavour_branch.SetAddress(<void*>&self.eJetHadronFlavour_value)

        #print "making eJetPFCISVBtag"
        self.eJetPFCISVBtag_branch = the_tree.GetBranch("eJetPFCISVBtag")
        #if not self.eJetPFCISVBtag_branch and "eJetPFCISVBtag" not in self.complained:
        if not self.eJetPFCISVBtag_branch and "eJetPFCISVBtag":
            warnings.warn( "EMuMuTree: Expected branch eJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPFCISVBtag")
        else:
            self.eJetPFCISVBtag_branch.SetAddress(<void*>&self.eJetPFCISVBtag_value)

        #print "making eJetPartonFlavour"
        self.eJetPartonFlavour_branch = the_tree.GetBranch("eJetPartonFlavour")
        #if not self.eJetPartonFlavour_branch and "eJetPartonFlavour" not in self.complained:
        if not self.eJetPartonFlavour_branch and "eJetPartonFlavour":
            warnings.warn( "EMuMuTree: Expected branch eJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPartonFlavour")
        else:
            self.eJetPartonFlavour_branch.SetAddress(<void*>&self.eJetPartonFlavour_value)

        #print "making eJetPhiPhiMoment"
        self.eJetPhiPhiMoment_branch = the_tree.GetBranch("eJetPhiPhiMoment")
        #if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment" not in self.complained:
        if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment":
            warnings.warn( "EMuMuTree: Expected branch eJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPhiPhiMoment")
        else:
            self.eJetPhiPhiMoment_branch.SetAddress(<void*>&self.eJetPhiPhiMoment_value)

        #print "making eJetPt"
        self.eJetPt_branch = the_tree.GetBranch("eJetPt")
        #if not self.eJetPt_branch and "eJetPt" not in self.complained:
        if not self.eJetPt_branch and "eJetPt":
            warnings.warn( "EMuMuTree: Expected branch eJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPt")
        else:
            self.eJetPt_branch.SetAddress(<void*>&self.eJetPt_value)

        #print "making eLowestMll"
        self.eLowestMll_branch = the_tree.GetBranch("eLowestMll")
        #if not self.eLowestMll_branch and "eLowestMll" not in self.complained:
        if not self.eLowestMll_branch and "eLowestMll":
            warnings.warn( "EMuMuTree: Expected branch eLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eLowestMll")
        else:
            self.eLowestMll_branch.SetAddress(<void*>&self.eLowestMll_value)

        #print "making eMVANonTrigCategory"
        self.eMVANonTrigCategory_branch = the_tree.GetBranch("eMVANonTrigCategory")
        #if not self.eMVANonTrigCategory_branch and "eMVANonTrigCategory" not in self.complained:
        if not self.eMVANonTrigCategory_branch and "eMVANonTrigCategory":
            warnings.warn( "EMuMuTree: Expected branch eMVANonTrigCategory does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANonTrigCategory")
        else:
            self.eMVANonTrigCategory_branch.SetAddress(<void*>&self.eMVANonTrigCategory_value)

        #print "making eMVANonTrigID"
        self.eMVANonTrigID_branch = the_tree.GetBranch("eMVANonTrigID")
        #if not self.eMVANonTrigID_branch and "eMVANonTrigID" not in self.complained:
        if not self.eMVANonTrigID_branch and "eMVANonTrigID":
            warnings.warn( "EMuMuTree: Expected branch eMVANonTrigID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANonTrigID")
        else:
            self.eMVANonTrigID_branch.SetAddress(<void*>&self.eMVANonTrigID_value)

        #print "making eMVANonTrigWP80"
        self.eMVANonTrigWP80_branch = the_tree.GetBranch("eMVANonTrigWP80")
        #if not self.eMVANonTrigWP80_branch and "eMVANonTrigWP80" not in self.complained:
        if not self.eMVANonTrigWP80_branch and "eMVANonTrigWP80":
            warnings.warn( "EMuMuTree: Expected branch eMVANonTrigWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANonTrigWP80")
        else:
            self.eMVANonTrigWP80_branch.SetAddress(<void*>&self.eMVANonTrigWP80_value)

        #print "making eMVANonTrigWP90"
        self.eMVANonTrigWP90_branch = the_tree.GetBranch("eMVANonTrigWP90")
        #if not self.eMVANonTrigWP90_branch and "eMVANonTrigWP90" not in self.complained:
        if not self.eMVANonTrigWP90_branch and "eMVANonTrigWP90":
            warnings.warn( "EMuMuTree: Expected branch eMVANonTrigWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANonTrigWP90")
        else:
            self.eMVANonTrigWP90_branch.SetAddress(<void*>&self.eMVANonTrigWP90_value)

        #print "making eMVATrigCategory"
        self.eMVATrigCategory_branch = the_tree.GetBranch("eMVATrigCategory")
        #if not self.eMVATrigCategory_branch and "eMVATrigCategory" not in self.complained:
        if not self.eMVATrigCategory_branch and "eMVATrigCategory":
            warnings.warn( "EMuMuTree: Expected branch eMVATrigCategory does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigCategory")
        else:
            self.eMVATrigCategory_branch.SetAddress(<void*>&self.eMVATrigCategory_value)

        #print "making eMVATrigID"
        self.eMVATrigID_branch = the_tree.GetBranch("eMVATrigID")
        #if not self.eMVATrigID_branch and "eMVATrigID" not in self.complained:
        if not self.eMVATrigID_branch and "eMVATrigID":
            warnings.warn( "EMuMuTree: Expected branch eMVATrigID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigID")
        else:
            self.eMVATrigID_branch.SetAddress(<void*>&self.eMVATrigID_value)

        #print "making eMVATrigWP80"
        self.eMVATrigWP80_branch = the_tree.GetBranch("eMVATrigWP80")
        #if not self.eMVATrigWP80_branch and "eMVATrigWP80" not in self.complained:
        if not self.eMVATrigWP80_branch and "eMVATrigWP80":
            warnings.warn( "EMuMuTree: Expected branch eMVATrigWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigWP80")
        else:
            self.eMVATrigWP80_branch.SetAddress(<void*>&self.eMVATrigWP80_value)

        #print "making eMVATrigWP90"
        self.eMVATrigWP90_branch = the_tree.GetBranch("eMVATrigWP90")
        #if not self.eMVATrigWP90_branch and "eMVATrigWP90" not in self.complained:
        if not self.eMVATrigWP90_branch and "eMVATrigWP90":
            warnings.warn( "EMuMuTree: Expected branch eMVATrigWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigWP90")
        else:
            self.eMVATrigWP90_branch.SetAddress(<void*>&self.eMVATrigWP90_value)

        #print "making eMass"
        self.eMass_branch = the_tree.GetBranch("eMass")
        #if not self.eMass_branch and "eMass" not in self.complained:
        if not self.eMass_branch and "eMass":
            warnings.warn( "EMuMuTree: Expected branch eMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMass")
        else:
            self.eMass_branch.SetAddress(<void*>&self.eMass_value)

        #print "making eMatchesDoubleE"
        self.eMatchesDoubleE_branch = the_tree.GetBranch("eMatchesDoubleE")
        #if not self.eMatchesDoubleE_branch and "eMatchesDoubleE" not in self.complained:
        if not self.eMatchesDoubleE_branch and "eMatchesDoubleE":
            warnings.warn( "EMuMuTree: Expected branch eMatchesDoubleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesDoubleE")
        else:
            self.eMatchesDoubleE_branch.SetAddress(<void*>&self.eMatchesDoubleE_value)

        #print "making eMatchesDoubleESingleMu"
        self.eMatchesDoubleESingleMu_branch = the_tree.GetBranch("eMatchesDoubleESingleMu")
        #if not self.eMatchesDoubleESingleMu_branch and "eMatchesDoubleESingleMu" not in self.complained:
        if not self.eMatchesDoubleESingleMu_branch and "eMatchesDoubleESingleMu":
            warnings.warn( "EMuMuTree: Expected branch eMatchesDoubleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesDoubleESingleMu")
        else:
            self.eMatchesDoubleESingleMu_branch.SetAddress(<void*>&self.eMatchesDoubleESingleMu_value)

        #print "making eMatchesDoubleMuSingleE"
        self.eMatchesDoubleMuSingleE_branch = the_tree.GetBranch("eMatchesDoubleMuSingleE")
        #if not self.eMatchesDoubleMuSingleE_branch and "eMatchesDoubleMuSingleE" not in self.complained:
        if not self.eMatchesDoubleMuSingleE_branch and "eMatchesDoubleMuSingleE":
            warnings.warn( "EMuMuTree: Expected branch eMatchesDoubleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesDoubleMuSingleE")
        else:
            self.eMatchesDoubleMuSingleE_branch.SetAddress(<void*>&self.eMatchesDoubleMuSingleE_value)

        #print "making eMatchesEle115Filter"
        self.eMatchesEle115Filter_branch = the_tree.GetBranch("eMatchesEle115Filter")
        #if not self.eMatchesEle115Filter_branch and "eMatchesEle115Filter" not in self.complained:
        if not self.eMatchesEle115Filter_branch and "eMatchesEle115Filter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle115Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle115Filter")
        else:
            self.eMatchesEle115Filter_branch.SetAddress(<void*>&self.eMatchesEle115Filter_value)

        #print "making eMatchesEle115Path"
        self.eMatchesEle115Path_branch = the_tree.GetBranch("eMatchesEle115Path")
        #if not self.eMatchesEle115Path_branch and "eMatchesEle115Path" not in self.complained:
        if not self.eMatchesEle115Path_branch and "eMatchesEle115Path":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle115Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle115Path")
        else:
            self.eMatchesEle115Path_branch.SetAddress(<void*>&self.eMatchesEle115Path_value)

        #print "making eMatchesEle24Tau20Filter"
        self.eMatchesEle24Tau20Filter_branch = the_tree.GetBranch("eMatchesEle24Tau20Filter")
        #if not self.eMatchesEle24Tau20Filter_branch and "eMatchesEle24Tau20Filter" not in self.complained:
        if not self.eMatchesEle24Tau20Filter_branch and "eMatchesEle24Tau20Filter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle24Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24Tau20Filter")
        else:
            self.eMatchesEle24Tau20Filter_branch.SetAddress(<void*>&self.eMatchesEle24Tau20Filter_value)

        #print "making eMatchesEle24Tau20Path"
        self.eMatchesEle24Tau20Path_branch = the_tree.GetBranch("eMatchesEle24Tau20Path")
        #if not self.eMatchesEle24Tau20Path_branch and "eMatchesEle24Tau20Path" not in self.complained:
        if not self.eMatchesEle24Tau20Path_branch and "eMatchesEle24Tau20Path":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle24Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24Tau20Path")
        else:
            self.eMatchesEle24Tau20Path_branch.SetAddress(<void*>&self.eMatchesEle24Tau20Path_value)

        #print "making eMatchesEle24Tau20sL1Filter"
        self.eMatchesEle24Tau20sL1Filter_branch = the_tree.GetBranch("eMatchesEle24Tau20sL1Filter")
        #if not self.eMatchesEle24Tau20sL1Filter_branch and "eMatchesEle24Tau20sL1Filter" not in self.complained:
        if not self.eMatchesEle24Tau20sL1Filter_branch and "eMatchesEle24Tau20sL1Filter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle24Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24Tau20sL1Filter")
        else:
            self.eMatchesEle24Tau20sL1Filter_branch.SetAddress(<void*>&self.eMatchesEle24Tau20sL1Filter_value)

        #print "making eMatchesEle24Tau20sL1Path"
        self.eMatchesEle24Tau20sL1Path_branch = the_tree.GetBranch("eMatchesEle24Tau20sL1Path")
        #if not self.eMatchesEle24Tau20sL1Path_branch and "eMatchesEle24Tau20sL1Path" not in self.complained:
        if not self.eMatchesEle24Tau20sL1Path_branch and "eMatchesEle24Tau20sL1Path":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle24Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24Tau20sL1Path")
        else:
            self.eMatchesEle24Tau20sL1Path_branch.SetAddress(<void*>&self.eMatchesEle24Tau20sL1Path_value)

        #print "making eMatchesEle24Tau30Filter"
        self.eMatchesEle24Tau30Filter_branch = the_tree.GetBranch("eMatchesEle24Tau30Filter")
        #if not self.eMatchesEle24Tau30Filter_branch and "eMatchesEle24Tau30Filter" not in self.complained:
        if not self.eMatchesEle24Tau30Filter_branch and "eMatchesEle24Tau30Filter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24Tau30Filter")
        else:
            self.eMatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.eMatchesEle24Tau30Filter_value)

        #print "making eMatchesEle24Tau30Path"
        self.eMatchesEle24Tau30Path_branch = the_tree.GetBranch("eMatchesEle24Tau30Path")
        #if not self.eMatchesEle24Tau30Path_branch and "eMatchesEle24Tau30Path" not in self.complained:
        if not self.eMatchesEle24Tau30Path_branch and "eMatchesEle24Tau30Path":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24Tau30Path")
        else:
            self.eMatchesEle24Tau30Path_branch.SetAddress(<void*>&self.eMatchesEle24Tau30Path_value)

        #print "making eMatchesEle25LooseFilter"
        self.eMatchesEle25LooseFilter_branch = the_tree.GetBranch("eMatchesEle25LooseFilter")
        #if not self.eMatchesEle25LooseFilter_branch and "eMatchesEle25LooseFilter" not in self.complained:
        if not self.eMatchesEle25LooseFilter_branch and "eMatchesEle25LooseFilter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle25LooseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle25LooseFilter")
        else:
            self.eMatchesEle25LooseFilter_branch.SetAddress(<void*>&self.eMatchesEle25LooseFilter_value)

        #print "making eMatchesEle25TightFilter"
        self.eMatchesEle25TightFilter_branch = the_tree.GetBranch("eMatchesEle25TightFilter")
        #if not self.eMatchesEle25TightFilter_branch and "eMatchesEle25TightFilter" not in self.complained:
        if not self.eMatchesEle25TightFilter_branch and "eMatchesEle25TightFilter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle25TightFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle25TightFilter")
        else:
            self.eMatchesEle25TightFilter_branch.SetAddress(<void*>&self.eMatchesEle25TightFilter_value)

        #print "making eMatchesEle25eta2p1TightFilter"
        self.eMatchesEle25eta2p1TightFilter_branch = the_tree.GetBranch("eMatchesEle25eta2p1TightFilter")
        #if not self.eMatchesEle25eta2p1TightFilter_branch and "eMatchesEle25eta2p1TightFilter" not in self.complained:
        if not self.eMatchesEle25eta2p1TightFilter_branch and "eMatchesEle25eta2p1TightFilter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle25eta2p1TightFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle25eta2p1TightFilter")
        else:
            self.eMatchesEle25eta2p1TightFilter_branch.SetAddress(<void*>&self.eMatchesEle25eta2p1TightFilter_value)

        #print "making eMatchesEle25eta2p1TightPath"
        self.eMatchesEle25eta2p1TightPath_branch = the_tree.GetBranch("eMatchesEle25eta2p1TightPath")
        #if not self.eMatchesEle25eta2p1TightPath_branch and "eMatchesEle25eta2p1TightPath" not in self.complained:
        if not self.eMatchesEle25eta2p1TightPath_branch and "eMatchesEle25eta2p1TightPath":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle25eta2p1TightPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle25eta2p1TightPath")
        else:
            self.eMatchesEle25eta2p1TightPath_branch.SetAddress(<void*>&self.eMatchesEle25eta2p1TightPath_value)

        #print "making eMatchesEle27TightFilter"
        self.eMatchesEle27TightFilter_branch = the_tree.GetBranch("eMatchesEle27TightFilter")
        #if not self.eMatchesEle27TightFilter_branch and "eMatchesEle27TightFilter" not in self.complained:
        if not self.eMatchesEle27TightFilter_branch and "eMatchesEle27TightFilter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle27TightFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle27TightFilter")
        else:
            self.eMatchesEle27TightFilter_branch.SetAddress(<void*>&self.eMatchesEle27TightFilter_value)

        #print "making eMatchesEle27TightPath"
        self.eMatchesEle27TightPath_branch = the_tree.GetBranch("eMatchesEle27TightPath")
        #if not self.eMatchesEle27TightPath_branch and "eMatchesEle27TightPath" not in self.complained:
        if not self.eMatchesEle27TightPath_branch and "eMatchesEle27TightPath":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle27TightPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle27TightPath")
        else:
            self.eMatchesEle27TightPath_branch.SetAddress(<void*>&self.eMatchesEle27TightPath_value)

        #print "making eMatchesEle27eta2p1LooseFilter"
        self.eMatchesEle27eta2p1LooseFilter_branch = the_tree.GetBranch("eMatchesEle27eta2p1LooseFilter")
        #if not self.eMatchesEle27eta2p1LooseFilter_branch and "eMatchesEle27eta2p1LooseFilter" not in self.complained:
        if not self.eMatchesEle27eta2p1LooseFilter_branch and "eMatchesEle27eta2p1LooseFilter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle27eta2p1LooseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle27eta2p1LooseFilter")
        else:
            self.eMatchesEle27eta2p1LooseFilter_branch.SetAddress(<void*>&self.eMatchesEle27eta2p1LooseFilter_value)

        #print "making eMatchesEle27eta2p1LoosePath"
        self.eMatchesEle27eta2p1LoosePath_branch = the_tree.GetBranch("eMatchesEle27eta2p1LoosePath")
        #if not self.eMatchesEle27eta2p1LoosePath_branch and "eMatchesEle27eta2p1LoosePath" not in self.complained:
        if not self.eMatchesEle27eta2p1LoosePath_branch and "eMatchesEle27eta2p1LoosePath":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle27eta2p1LoosePath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle27eta2p1LoosePath")
        else:
            self.eMatchesEle27eta2p1LoosePath_branch.SetAddress(<void*>&self.eMatchesEle27eta2p1LoosePath_value)

        #print "making eMatchesEle45L1JetTauPath"
        self.eMatchesEle45L1JetTauPath_branch = the_tree.GetBranch("eMatchesEle45L1JetTauPath")
        #if not self.eMatchesEle45L1JetTauPath_branch and "eMatchesEle45L1JetTauPath" not in self.complained:
        if not self.eMatchesEle45L1JetTauPath_branch and "eMatchesEle45L1JetTauPath":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle45L1JetTauPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle45L1JetTauPath")
        else:
            self.eMatchesEle45L1JetTauPath_branch.SetAddress(<void*>&self.eMatchesEle45L1JetTauPath_value)

        #print "making eMatchesEle45LooseL1JetTauFilter"
        self.eMatchesEle45LooseL1JetTauFilter_branch = the_tree.GetBranch("eMatchesEle45LooseL1JetTauFilter")
        #if not self.eMatchesEle45LooseL1JetTauFilter_branch and "eMatchesEle45LooseL1JetTauFilter" not in self.complained:
        if not self.eMatchesEle45LooseL1JetTauFilter_branch and "eMatchesEle45LooseL1JetTauFilter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesEle45LooseL1JetTauFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle45LooseL1JetTauFilter")
        else:
            self.eMatchesEle45LooseL1JetTauFilter_branch.SetAddress(<void*>&self.eMatchesEle45LooseL1JetTauFilter_value)

        #print "making eMatchesMu23Ele12DZFilter"
        self.eMatchesMu23Ele12DZFilter_branch = the_tree.GetBranch("eMatchesMu23Ele12DZFilter")
        #if not self.eMatchesMu23Ele12DZFilter_branch and "eMatchesMu23Ele12DZFilter" not in self.complained:
        if not self.eMatchesMu23Ele12DZFilter_branch and "eMatchesMu23Ele12DZFilter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesMu23Ele12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23Ele12DZFilter")
        else:
            self.eMatchesMu23Ele12DZFilter_branch.SetAddress(<void*>&self.eMatchesMu23Ele12DZFilter_value)

        #print "making eMatchesMu23Ele12DZPath"
        self.eMatchesMu23Ele12DZPath_branch = the_tree.GetBranch("eMatchesMu23Ele12DZPath")
        #if not self.eMatchesMu23Ele12DZPath_branch and "eMatchesMu23Ele12DZPath" not in self.complained:
        if not self.eMatchesMu23Ele12DZPath_branch and "eMatchesMu23Ele12DZPath":
            warnings.warn( "EMuMuTree: Expected branch eMatchesMu23Ele12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23Ele12DZPath")
        else:
            self.eMatchesMu23Ele12DZPath_branch.SetAddress(<void*>&self.eMatchesMu23Ele12DZPath_value)

        #print "making eMatchesMu23Ele12Filter"
        self.eMatchesMu23Ele12Filter_branch = the_tree.GetBranch("eMatchesMu23Ele12Filter")
        #if not self.eMatchesMu23Ele12Filter_branch and "eMatchesMu23Ele12Filter" not in self.complained:
        if not self.eMatchesMu23Ele12Filter_branch and "eMatchesMu23Ele12Filter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesMu23Ele12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23Ele12Filter")
        else:
            self.eMatchesMu23Ele12Filter_branch.SetAddress(<void*>&self.eMatchesMu23Ele12Filter_value)

        #print "making eMatchesMu23Ele12Path"
        self.eMatchesMu23Ele12Path_branch = the_tree.GetBranch("eMatchesMu23Ele12Path")
        #if not self.eMatchesMu23Ele12Path_branch and "eMatchesMu23Ele12Path" not in self.complained:
        if not self.eMatchesMu23Ele12Path_branch and "eMatchesMu23Ele12Path":
            warnings.warn( "EMuMuTree: Expected branch eMatchesMu23Ele12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23Ele12Path")
        else:
            self.eMatchesMu23Ele12Path_branch.SetAddress(<void*>&self.eMatchesMu23Ele12Path_value)

        #print "making eMatchesMu23Ele8DZFilter"
        self.eMatchesMu23Ele8DZFilter_branch = the_tree.GetBranch("eMatchesMu23Ele8DZFilter")
        #if not self.eMatchesMu23Ele8DZFilter_branch and "eMatchesMu23Ele8DZFilter" not in self.complained:
        if not self.eMatchesMu23Ele8DZFilter_branch and "eMatchesMu23Ele8DZFilter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesMu23Ele8DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23Ele8DZFilter")
        else:
            self.eMatchesMu23Ele8DZFilter_branch.SetAddress(<void*>&self.eMatchesMu23Ele8DZFilter_value)

        #print "making eMatchesMu23Ele8DZPath"
        self.eMatchesMu23Ele8DZPath_branch = the_tree.GetBranch("eMatchesMu23Ele8DZPath")
        #if not self.eMatchesMu23Ele8DZPath_branch and "eMatchesMu23Ele8DZPath" not in self.complained:
        if not self.eMatchesMu23Ele8DZPath_branch and "eMatchesMu23Ele8DZPath":
            warnings.warn( "EMuMuTree: Expected branch eMatchesMu23Ele8DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23Ele8DZPath")
        else:
            self.eMatchesMu23Ele8DZPath_branch.SetAddress(<void*>&self.eMatchesMu23Ele8DZPath_value)

        #print "making eMatchesMu23Ele8Filter"
        self.eMatchesMu23Ele8Filter_branch = the_tree.GetBranch("eMatchesMu23Ele8Filter")
        #if not self.eMatchesMu23Ele8Filter_branch and "eMatchesMu23Ele8Filter" not in self.complained:
        if not self.eMatchesMu23Ele8Filter_branch and "eMatchesMu23Ele8Filter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesMu23Ele8Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23Ele8Filter")
        else:
            self.eMatchesMu23Ele8Filter_branch.SetAddress(<void*>&self.eMatchesMu23Ele8Filter_value)

        #print "making eMatchesMu23Ele8Path"
        self.eMatchesMu23Ele8Path_branch = the_tree.GetBranch("eMatchesMu23Ele8Path")
        #if not self.eMatchesMu23Ele8Path_branch and "eMatchesMu23Ele8Path" not in self.complained:
        if not self.eMatchesMu23Ele8Path_branch and "eMatchesMu23Ele8Path":
            warnings.warn( "EMuMuTree: Expected branch eMatchesMu23Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23Ele8Path")
        else:
            self.eMatchesMu23Ele8Path_branch.SetAddress(<void*>&self.eMatchesMu23Ele8Path_value)

        #print "making eMatchesMu8Ele23DZFilter"
        self.eMatchesMu8Ele23DZFilter_branch = the_tree.GetBranch("eMatchesMu8Ele23DZFilter")
        #if not self.eMatchesMu8Ele23DZFilter_branch and "eMatchesMu8Ele23DZFilter" not in self.complained:
        if not self.eMatchesMu8Ele23DZFilter_branch and "eMatchesMu8Ele23DZFilter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesMu8Ele23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8Ele23DZFilter")
        else:
            self.eMatchesMu8Ele23DZFilter_branch.SetAddress(<void*>&self.eMatchesMu8Ele23DZFilter_value)

        #print "making eMatchesMu8Ele23DZPath"
        self.eMatchesMu8Ele23DZPath_branch = the_tree.GetBranch("eMatchesMu8Ele23DZPath")
        #if not self.eMatchesMu8Ele23DZPath_branch and "eMatchesMu8Ele23DZPath" not in self.complained:
        if not self.eMatchesMu8Ele23DZPath_branch and "eMatchesMu8Ele23DZPath":
            warnings.warn( "EMuMuTree: Expected branch eMatchesMu8Ele23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8Ele23DZPath")
        else:
            self.eMatchesMu8Ele23DZPath_branch.SetAddress(<void*>&self.eMatchesMu8Ele23DZPath_value)

        #print "making eMatchesMu8Ele23Filter"
        self.eMatchesMu8Ele23Filter_branch = the_tree.GetBranch("eMatchesMu8Ele23Filter")
        #if not self.eMatchesMu8Ele23Filter_branch and "eMatchesMu8Ele23Filter" not in self.complained:
        if not self.eMatchesMu8Ele23Filter_branch and "eMatchesMu8Ele23Filter":
            warnings.warn( "EMuMuTree: Expected branch eMatchesMu8Ele23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8Ele23Filter")
        else:
            self.eMatchesMu8Ele23Filter_branch.SetAddress(<void*>&self.eMatchesMu8Ele23Filter_value)

        #print "making eMatchesMu8Ele23Path"
        self.eMatchesMu8Ele23Path_branch = the_tree.GetBranch("eMatchesMu8Ele23Path")
        #if not self.eMatchesMu8Ele23Path_branch and "eMatchesMu8Ele23Path" not in self.complained:
        if not self.eMatchesMu8Ele23Path_branch and "eMatchesMu8Ele23Path":
            warnings.warn( "EMuMuTree: Expected branch eMatchesMu8Ele23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8Ele23Path")
        else:
            self.eMatchesMu8Ele23Path_branch.SetAddress(<void*>&self.eMatchesMu8Ele23Path_value)

        #print "making eMatchesSingleE"
        self.eMatchesSingleE_branch = the_tree.GetBranch("eMatchesSingleE")
        #if not self.eMatchesSingleE_branch and "eMatchesSingleE" not in self.complained:
        if not self.eMatchesSingleE_branch and "eMatchesSingleE":
            warnings.warn( "EMuMuTree: Expected branch eMatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleE")
        else:
            self.eMatchesSingleE_branch.SetAddress(<void*>&self.eMatchesSingleE_value)

        #print "making eMatchesSingleESingleMu"
        self.eMatchesSingleESingleMu_branch = the_tree.GetBranch("eMatchesSingleESingleMu")
        #if not self.eMatchesSingleESingleMu_branch and "eMatchesSingleESingleMu" not in self.complained:
        if not self.eMatchesSingleESingleMu_branch and "eMatchesSingleESingleMu":
            warnings.warn( "EMuMuTree: Expected branch eMatchesSingleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleESingleMu")
        else:
            self.eMatchesSingleESingleMu_branch.SetAddress(<void*>&self.eMatchesSingleESingleMu_value)

        #print "making eMatchesSingleE_leg1"
        self.eMatchesSingleE_leg1_branch = the_tree.GetBranch("eMatchesSingleE_leg1")
        #if not self.eMatchesSingleE_leg1_branch and "eMatchesSingleE_leg1" not in self.complained:
        if not self.eMatchesSingleE_leg1_branch and "eMatchesSingleE_leg1":
            warnings.warn( "EMuMuTree: Expected branch eMatchesSingleE_leg1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleE_leg1")
        else:
            self.eMatchesSingleE_leg1_branch.SetAddress(<void*>&self.eMatchesSingleE_leg1_value)

        #print "making eMatchesSingleE_leg2"
        self.eMatchesSingleE_leg2_branch = the_tree.GetBranch("eMatchesSingleE_leg2")
        #if not self.eMatchesSingleE_leg2_branch and "eMatchesSingleE_leg2" not in self.complained:
        if not self.eMatchesSingleE_leg2_branch and "eMatchesSingleE_leg2":
            warnings.warn( "EMuMuTree: Expected branch eMatchesSingleE_leg2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleE_leg2")
        else:
            self.eMatchesSingleE_leg2_branch.SetAddress(<void*>&self.eMatchesSingleE_leg2_value)

        #print "making eMatchesSingleMuSingleE"
        self.eMatchesSingleMuSingleE_branch = the_tree.GetBranch("eMatchesSingleMuSingleE")
        #if not self.eMatchesSingleMuSingleE_branch and "eMatchesSingleMuSingleE" not in self.complained:
        if not self.eMatchesSingleMuSingleE_branch and "eMatchesSingleMuSingleE":
            warnings.warn( "EMuMuTree: Expected branch eMatchesSingleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleMuSingleE")
        else:
            self.eMatchesSingleMuSingleE_branch.SetAddress(<void*>&self.eMatchesSingleMuSingleE_value)

        #print "making eMatchesTripleE"
        self.eMatchesTripleE_branch = the_tree.GetBranch("eMatchesTripleE")
        #if not self.eMatchesTripleE_branch and "eMatchesTripleE" not in self.complained:
        if not self.eMatchesTripleE_branch and "eMatchesTripleE":
            warnings.warn( "EMuMuTree: Expected branch eMatchesTripleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesTripleE")
        else:
            self.eMatchesTripleE_branch.SetAddress(<void*>&self.eMatchesTripleE_value)

        #print "making eMissingHits"
        self.eMissingHits_branch = the_tree.GetBranch("eMissingHits")
        #if not self.eMissingHits_branch and "eMissingHits" not in self.complained:
        if not self.eMissingHits_branch and "eMissingHits":
            warnings.warn( "EMuMuTree: Expected branch eMissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMissingHits")
        else:
            self.eMissingHits_branch.SetAddress(<void*>&self.eMissingHits_value)

        #print "making eMtToPfMet_type1"
        self.eMtToPfMet_type1_branch = the_tree.GetBranch("eMtToPfMet_type1")
        #if not self.eMtToPfMet_type1_branch and "eMtToPfMet_type1" not in self.complained:
        if not self.eMtToPfMet_type1_branch and "eMtToPfMet_type1":
            warnings.warn( "EMuMuTree: Expected branch eMtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_type1")
        else:
            self.eMtToPfMet_type1_branch.SetAddress(<void*>&self.eMtToPfMet_type1_value)

        #print "making eNearMuonVeto"
        self.eNearMuonVeto_branch = the_tree.GetBranch("eNearMuonVeto")
        #if not self.eNearMuonVeto_branch and "eNearMuonVeto" not in self.complained:
        if not self.eNearMuonVeto_branch and "eNearMuonVeto":
            warnings.warn( "EMuMuTree: Expected branch eNearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearMuonVeto")
        else:
            self.eNearMuonVeto_branch.SetAddress(<void*>&self.eNearMuonVeto_value)

        #print "making eNearestMuonDR"
        self.eNearestMuonDR_branch = the_tree.GetBranch("eNearestMuonDR")
        #if not self.eNearestMuonDR_branch and "eNearestMuonDR" not in self.complained:
        if not self.eNearestMuonDR_branch and "eNearestMuonDR":
            warnings.warn( "EMuMuTree: Expected branch eNearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearestMuonDR")
        else:
            self.eNearestMuonDR_branch.SetAddress(<void*>&self.eNearestMuonDR_value)

        #print "making eNearestZMass"
        self.eNearestZMass_branch = the_tree.GetBranch("eNearestZMass")
        #if not self.eNearestZMass_branch and "eNearestZMass" not in self.complained:
        if not self.eNearestZMass_branch and "eNearestZMass":
            warnings.warn( "EMuMuTree: Expected branch eNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearestZMass")
        else:
            self.eNearestZMass_branch.SetAddress(<void*>&self.eNearestZMass_value)

        #print "making ePFChargedIso"
        self.ePFChargedIso_branch = the_tree.GetBranch("ePFChargedIso")
        #if not self.ePFChargedIso_branch and "ePFChargedIso" not in self.complained:
        if not self.ePFChargedIso_branch and "ePFChargedIso":
            warnings.warn( "EMuMuTree: Expected branch ePFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFChargedIso")
        else:
            self.ePFChargedIso_branch.SetAddress(<void*>&self.ePFChargedIso_value)

        #print "making ePFNeutralIso"
        self.ePFNeutralIso_branch = the_tree.GetBranch("ePFNeutralIso")
        #if not self.ePFNeutralIso_branch and "ePFNeutralIso" not in self.complained:
        if not self.ePFNeutralIso_branch and "ePFNeutralIso":
            warnings.warn( "EMuMuTree: Expected branch ePFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFNeutralIso")
        else:
            self.ePFNeutralIso_branch.SetAddress(<void*>&self.ePFNeutralIso_value)

        #print "making ePFPUChargedIso"
        self.ePFPUChargedIso_branch = the_tree.GetBranch("ePFPUChargedIso")
        #if not self.ePFPUChargedIso_branch and "ePFPUChargedIso" not in self.complained:
        if not self.ePFPUChargedIso_branch and "ePFPUChargedIso":
            warnings.warn( "EMuMuTree: Expected branch ePFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFPUChargedIso")
        else:
            self.ePFPUChargedIso_branch.SetAddress(<void*>&self.ePFPUChargedIso_value)

        #print "making ePFPhotonIso"
        self.ePFPhotonIso_branch = the_tree.GetBranch("ePFPhotonIso")
        #if not self.ePFPhotonIso_branch and "ePFPhotonIso" not in self.complained:
        if not self.ePFPhotonIso_branch and "ePFPhotonIso":
            warnings.warn( "EMuMuTree: Expected branch ePFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFPhotonIso")
        else:
            self.ePFPhotonIso_branch.SetAddress(<void*>&self.ePFPhotonIso_value)

        #print "making ePVDXY"
        self.ePVDXY_branch = the_tree.GetBranch("ePVDXY")
        #if not self.ePVDXY_branch and "ePVDXY" not in self.complained:
        if not self.ePVDXY_branch and "ePVDXY":
            warnings.warn( "EMuMuTree: Expected branch ePVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDXY")
        else:
            self.ePVDXY_branch.SetAddress(<void*>&self.ePVDXY_value)

        #print "making ePVDZ"
        self.ePVDZ_branch = the_tree.GetBranch("ePVDZ")
        #if not self.ePVDZ_branch and "ePVDZ" not in self.complained:
        if not self.ePVDZ_branch and "ePVDZ":
            warnings.warn( "EMuMuTree: Expected branch ePVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDZ")
        else:
            self.ePVDZ_branch.SetAddress(<void*>&self.ePVDZ_value)

        #print "making ePassesConversionVeto"
        self.ePassesConversionVeto_branch = the_tree.GetBranch("ePassesConversionVeto")
        #if not self.ePassesConversionVeto_branch and "ePassesConversionVeto" not in self.complained:
        if not self.ePassesConversionVeto_branch and "ePassesConversionVeto":
            warnings.warn( "EMuMuTree: Expected branch ePassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePassesConversionVeto")
        else:
            self.ePassesConversionVeto_branch.SetAddress(<void*>&self.ePassesConversionVeto_value)

        #print "making ePhi"
        self.ePhi_branch = the_tree.GetBranch("ePhi")
        #if not self.ePhi_branch and "ePhi" not in self.complained:
        if not self.ePhi_branch and "ePhi":
            warnings.warn( "EMuMuTree: Expected branch ePhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhi")
        else:
            self.ePhi_branch.SetAddress(<void*>&self.ePhi_value)

        #print "making ePhi_ElectronEnDown"
        self.ePhi_ElectronEnDown_branch = the_tree.GetBranch("ePhi_ElectronEnDown")
        #if not self.ePhi_ElectronEnDown_branch and "ePhi_ElectronEnDown" not in self.complained:
        if not self.ePhi_ElectronEnDown_branch and "ePhi_ElectronEnDown":
            warnings.warn( "EMuMuTree: Expected branch ePhi_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhi_ElectronEnDown")
        else:
            self.ePhi_ElectronEnDown_branch.SetAddress(<void*>&self.ePhi_ElectronEnDown_value)

        #print "making ePhi_ElectronEnUp"
        self.ePhi_ElectronEnUp_branch = the_tree.GetBranch("ePhi_ElectronEnUp")
        #if not self.ePhi_ElectronEnUp_branch and "ePhi_ElectronEnUp" not in self.complained:
        if not self.ePhi_ElectronEnUp_branch and "ePhi_ElectronEnUp":
            warnings.warn( "EMuMuTree: Expected branch ePhi_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhi_ElectronEnUp")
        else:
            self.ePhi_ElectronEnUp_branch.SetAddress(<void*>&self.ePhi_ElectronEnUp_value)

        #print "making ePt"
        self.ePt_branch = the_tree.GetBranch("ePt")
        #if not self.ePt_branch and "ePt" not in self.complained:
        if not self.ePt_branch and "ePt":
            warnings.warn( "EMuMuTree: Expected branch ePt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt")
        else:
            self.ePt_branch.SetAddress(<void*>&self.ePt_value)

        #print "making ePt_ElectronEnDown"
        self.ePt_ElectronEnDown_branch = the_tree.GetBranch("ePt_ElectronEnDown")
        #if not self.ePt_ElectronEnDown_branch and "ePt_ElectronEnDown" not in self.complained:
        if not self.ePt_ElectronEnDown_branch and "ePt_ElectronEnDown":
            warnings.warn( "EMuMuTree: Expected branch ePt_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt_ElectronEnDown")
        else:
            self.ePt_ElectronEnDown_branch.SetAddress(<void*>&self.ePt_ElectronEnDown_value)

        #print "making ePt_ElectronEnUp"
        self.ePt_ElectronEnUp_branch = the_tree.GetBranch("ePt_ElectronEnUp")
        #if not self.ePt_ElectronEnUp_branch and "ePt_ElectronEnUp" not in self.complained:
        if not self.ePt_ElectronEnUp_branch and "ePt_ElectronEnUp":
            warnings.warn( "EMuMuTree: Expected branch ePt_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt_ElectronEnUp")
        else:
            self.ePt_ElectronEnUp_branch.SetAddress(<void*>&self.ePt_ElectronEnUp_value)

        #print "making eRank"
        self.eRank_branch = the_tree.GetBranch("eRank")
        #if not self.eRank_branch and "eRank" not in self.complained:
        if not self.eRank_branch and "eRank":
            warnings.warn( "EMuMuTree: Expected branch eRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRank")
        else:
            self.eRank_branch.SetAddress(<void*>&self.eRank_value)

        #print "making eRelIso"
        self.eRelIso_branch = the_tree.GetBranch("eRelIso")
        #if not self.eRelIso_branch and "eRelIso" not in self.complained:
        if not self.eRelIso_branch and "eRelIso":
            warnings.warn( "EMuMuTree: Expected branch eRelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelIso")
        else:
            self.eRelIso_branch.SetAddress(<void*>&self.eRelIso_value)

        #print "making eRelPFIsoDB"
        self.eRelPFIsoDB_branch = the_tree.GetBranch("eRelPFIsoDB")
        #if not self.eRelPFIsoDB_branch and "eRelPFIsoDB" not in self.complained:
        if not self.eRelPFIsoDB_branch and "eRelPFIsoDB":
            warnings.warn( "EMuMuTree: Expected branch eRelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoDB")
        else:
            self.eRelPFIsoDB_branch.SetAddress(<void*>&self.eRelPFIsoDB_value)

        #print "making eRelPFIsoRho"
        self.eRelPFIsoRho_branch = the_tree.GetBranch("eRelPFIsoRho")
        #if not self.eRelPFIsoRho_branch and "eRelPFIsoRho" not in self.complained:
        if not self.eRelPFIsoRho_branch and "eRelPFIsoRho":
            warnings.warn( "EMuMuTree: Expected branch eRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRho")
        else:
            self.eRelPFIsoRho_branch.SetAddress(<void*>&self.eRelPFIsoRho_value)

        #print "making eRho"
        self.eRho_branch = the_tree.GetBranch("eRho")
        #if not self.eRho_branch and "eRho" not in self.complained:
        if not self.eRho_branch and "eRho":
            warnings.warn( "EMuMuTree: Expected branch eRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRho")
        else:
            self.eRho_branch.SetAddress(<void*>&self.eRho_value)

        #print "making eSCEnergy"
        self.eSCEnergy_branch = the_tree.GetBranch("eSCEnergy")
        #if not self.eSCEnergy_branch and "eSCEnergy" not in self.complained:
        if not self.eSCEnergy_branch and "eSCEnergy":
            warnings.warn( "EMuMuTree: Expected branch eSCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEnergy")
        else:
            self.eSCEnergy_branch.SetAddress(<void*>&self.eSCEnergy_value)

        #print "making eSCEta"
        self.eSCEta_branch = the_tree.GetBranch("eSCEta")
        #if not self.eSCEta_branch and "eSCEta" not in self.complained:
        if not self.eSCEta_branch and "eSCEta":
            warnings.warn( "EMuMuTree: Expected branch eSCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEta")
        else:
            self.eSCEta_branch.SetAddress(<void*>&self.eSCEta_value)

        #print "making eSCEtaWidth"
        self.eSCEtaWidth_branch = the_tree.GetBranch("eSCEtaWidth")
        #if not self.eSCEtaWidth_branch and "eSCEtaWidth" not in self.complained:
        if not self.eSCEtaWidth_branch and "eSCEtaWidth":
            warnings.warn( "EMuMuTree: Expected branch eSCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEtaWidth")
        else:
            self.eSCEtaWidth_branch.SetAddress(<void*>&self.eSCEtaWidth_value)

        #print "making eSCPhi"
        self.eSCPhi_branch = the_tree.GetBranch("eSCPhi")
        #if not self.eSCPhi_branch and "eSCPhi" not in self.complained:
        if not self.eSCPhi_branch and "eSCPhi":
            warnings.warn( "EMuMuTree: Expected branch eSCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhi")
        else:
            self.eSCPhi_branch.SetAddress(<void*>&self.eSCPhi_value)

        #print "making eSCPhiWidth"
        self.eSCPhiWidth_branch = the_tree.GetBranch("eSCPhiWidth")
        #if not self.eSCPhiWidth_branch and "eSCPhiWidth" not in self.complained:
        if not self.eSCPhiWidth_branch and "eSCPhiWidth":
            warnings.warn( "EMuMuTree: Expected branch eSCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhiWidth")
        else:
            self.eSCPhiWidth_branch.SetAddress(<void*>&self.eSCPhiWidth_value)

        #print "making eSCPreshowerEnergy"
        self.eSCPreshowerEnergy_branch = the_tree.GetBranch("eSCPreshowerEnergy")
        #if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy" not in self.complained:
        if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy":
            warnings.warn( "EMuMuTree: Expected branch eSCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPreshowerEnergy")
        else:
            self.eSCPreshowerEnergy_branch.SetAddress(<void*>&self.eSCPreshowerEnergy_value)

        #print "making eSCRawEnergy"
        self.eSCRawEnergy_branch = the_tree.GetBranch("eSCRawEnergy")
        #if not self.eSCRawEnergy_branch and "eSCRawEnergy" not in self.complained:
        if not self.eSCRawEnergy_branch and "eSCRawEnergy":
            warnings.warn( "EMuMuTree: Expected branch eSCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCRawEnergy")
        else:
            self.eSCRawEnergy_branch.SetAddress(<void*>&self.eSCRawEnergy_value)

        #print "making eSIP2D"
        self.eSIP2D_branch = the_tree.GetBranch("eSIP2D")
        #if not self.eSIP2D_branch and "eSIP2D" not in self.complained:
        if not self.eSIP2D_branch and "eSIP2D":
            warnings.warn( "EMuMuTree: Expected branch eSIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSIP2D")
        else:
            self.eSIP2D_branch.SetAddress(<void*>&self.eSIP2D_value)

        #print "making eSIP3D"
        self.eSIP3D_branch = the_tree.GetBranch("eSIP3D")
        #if not self.eSIP3D_branch and "eSIP3D" not in self.complained:
        if not self.eSIP3D_branch and "eSIP3D":
            warnings.warn( "EMuMuTree: Expected branch eSIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSIP3D")
        else:
            self.eSIP3D_branch.SetAddress(<void*>&self.eSIP3D_value)

        #print "making eSigmaIEtaIEta"
        self.eSigmaIEtaIEta_branch = the_tree.GetBranch("eSigmaIEtaIEta")
        #if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta" not in self.complained:
        if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta":
            warnings.warn( "EMuMuTree: Expected branch eSigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSigmaIEtaIEta")
        else:
            self.eSigmaIEtaIEta_branch.SetAddress(<void*>&self.eSigmaIEtaIEta_value)

        #print "making eTrkIsoDR03"
        self.eTrkIsoDR03_branch = the_tree.GetBranch("eTrkIsoDR03")
        #if not self.eTrkIsoDR03_branch and "eTrkIsoDR03" not in self.complained:
        if not self.eTrkIsoDR03_branch and "eTrkIsoDR03":
            warnings.warn( "EMuMuTree: Expected branch eTrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTrkIsoDR03")
        else:
            self.eTrkIsoDR03_branch.SetAddress(<void*>&self.eTrkIsoDR03_value)

        #print "making eVZ"
        self.eVZ_branch = the_tree.GetBranch("eVZ")
        #if not self.eVZ_branch and "eVZ" not in self.complained:
        if not self.eVZ_branch and "eVZ":
            warnings.warn( "EMuMuTree: Expected branch eVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVZ")
        else:
            self.eVZ_branch.SetAddress(<void*>&self.eVZ_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "EMuMuTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "EMuMuTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "EMuMuTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eVetoZTTp001dxyzR0"
        self.eVetoZTTp001dxyzR0_branch = the_tree.GetBranch("eVetoZTTp001dxyzR0")
        #if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0" not in self.complained:
        if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0":
            warnings.warn( "EMuMuTree: Expected branch eVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyzR0")
        else:
            self.eVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.eVetoZTTp001dxyzR0_value)

        #print "making eWWLoose"
        self.eWWLoose_branch = the_tree.GetBranch("eWWLoose")
        #if not self.eWWLoose_branch and "eWWLoose" not in self.complained:
        if not self.eWWLoose_branch and "eWWLoose":
            warnings.warn( "EMuMuTree: Expected branch eWWLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eWWLoose")
        else:
            self.eWWLoose_branch.SetAddress(<void*>&self.eWWLoose_value)

        #print "making eZTTGenMatching"
        self.eZTTGenMatching_branch = the_tree.GetBranch("eZTTGenMatching")
        #if not self.eZTTGenMatching_branch and "eZTTGenMatching" not in self.complained:
        if not self.eZTTGenMatching_branch and "eZTTGenMatching":
            warnings.warn( "EMuMuTree: Expected branch eZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eZTTGenMatching")
        else:
            self.eZTTGenMatching_branch.SetAddress(<void*>&self.eZTTGenMatching_value)

        #print "making e_m1_CosThetaStar"
        self.e_m1_CosThetaStar_branch = the_tree.GetBranch("e_m1_CosThetaStar")
        #if not self.e_m1_CosThetaStar_branch and "e_m1_CosThetaStar" not in self.complained:
        if not self.e_m1_CosThetaStar_branch and "e_m1_CosThetaStar":
            warnings.warn( "EMuMuTree: Expected branch e_m1_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_CosThetaStar")
        else:
            self.e_m1_CosThetaStar_branch.SetAddress(<void*>&self.e_m1_CosThetaStar_value)

        #print "making e_m1_DPhi"
        self.e_m1_DPhi_branch = the_tree.GetBranch("e_m1_DPhi")
        #if not self.e_m1_DPhi_branch and "e_m1_DPhi" not in self.complained:
        if not self.e_m1_DPhi_branch and "e_m1_DPhi":
            warnings.warn( "EMuMuTree: Expected branch e_m1_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_DPhi")
        else:
            self.e_m1_DPhi_branch.SetAddress(<void*>&self.e_m1_DPhi_value)

        #print "making e_m1_DR"
        self.e_m1_DR_branch = the_tree.GetBranch("e_m1_DR")
        #if not self.e_m1_DR_branch and "e_m1_DR" not in self.complained:
        if not self.e_m1_DR_branch and "e_m1_DR":
            warnings.warn( "EMuMuTree: Expected branch e_m1_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_DR")
        else:
            self.e_m1_DR_branch.SetAddress(<void*>&self.e_m1_DR_value)

        #print "making e_m1_Eta"
        self.e_m1_Eta_branch = the_tree.GetBranch("e_m1_Eta")
        #if not self.e_m1_Eta_branch and "e_m1_Eta" not in self.complained:
        if not self.e_m1_Eta_branch and "e_m1_Eta":
            warnings.warn( "EMuMuTree: Expected branch e_m1_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Eta")
        else:
            self.e_m1_Eta_branch.SetAddress(<void*>&self.e_m1_Eta_value)

        #print "making e_m1_Mass"
        self.e_m1_Mass_branch = the_tree.GetBranch("e_m1_Mass")
        #if not self.e_m1_Mass_branch and "e_m1_Mass" not in self.complained:
        if not self.e_m1_Mass_branch and "e_m1_Mass":
            warnings.warn( "EMuMuTree: Expected branch e_m1_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Mass")
        else:
            self.e_m1_Mass_branch.SetAddress(<void*>&self.e_m1_Mass_value)

        #print "making e_m1_Mass_TauEnDown"
        self.e_m1_Mass_TauEnDown_branch = the_tree.GetBranch("e_m1_Mass_TauEnDown")
        #if not self.e_m1_Mass_TauEnDown_branch and "e_m1_Mass_TauEnDown" not in self.complained:
        if not self.e_m1_Mass_TauEnDown_branch and "e_m1_Mass_TauEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m1_Mass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Mass_TauEnDown")
        else:
            self.e_m1_Mass_TauEnDown_branch.SetAddress(<void*>&self.e_m1_Mass_TauEnDown_value)

        #print "making e_m1_Mass_TauEnUp"
        self.e_m1_Mass_TauEnUp_branch = the_tree.GetBranch("e_m1_Mass_TauEnUp")
        #if not self.e_m1_Mass_TauEnUp_branch and "e_m1_Mass_TauEnUp" not in self.complained:
        if not self.e_m1_Mass_TauEnUp_branch and "e_m1_Mass_TauEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m1_Mass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Mass_TauEnUp")
        else:
            self.e_m1_Mass_TauEnUp_branch.SetAddress(<void*>&self.e_m1_Mass_TauEnUp_value)

        #print "making e_m1_Mt"
        self.e_m1_Mt_branch = the_tree.GetBranch("e_m1_Mt")
        #if not self.e_m1_Mt_branch and "e_m1_Mt" not in self.complained:
        if not self.e_m1_Mt_branch and "e_m1_Mt":
            warnings.warn( "EMuMuTree: Expected branch e_m1_Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Mt")
        else:
            self.e_m1_Mt_branch.SetAddress(<void*>&self.e_m1_Mt_value)

        #print "making e_m1_MtTotal"
        self.e_m1_MtTotal_branch = the_tree.GetBranch("e_m1_MtTotal")
        #if not self.e_m1_MtTotal_branch and "e_m1_MtTotal" not in self.complained:
        if not self.e_m1_MtTotal_branch and "e_m1_MtTotal":
            warnings.warn( "EMuMuTree: Expected branch e_m1_MtTotal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_MtTotal")
        else:
            self.e_m1_MtTotal_branch.SetAddress(<void*>&self.e_m1_MtTotal_value)

        #print "making e_m1_Mt_TauEnDown"
        self.e_m1_Mt_TauEnDown_branch = the_tree.GetBranch("e_m1_Mt_TauEnDown")
        #if not self.e_m1_Mt_TauEnDown_branch and "e_m1_Mt_TauEnDown" not in self.complained:
        if not self.e_m1_Mt_TauEnDown_branch and "e_m1_Mt_TauEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m1_Mt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Mt_TauEnDown")
        else:
            self.e_m1_Mt_TauEnDown_branch.SetAddress(<void*>&self.e_m1_Mt_TauEnDown_value)

        #print "making e_m1_Mt_TauEnUp"
        self.e_m1_Mt_TauEnUp_branch = the_tree.GetBranch("e_m1_Mt_TauEnUp")
        #if not self.e_m1_Mt_TauEnUp_branch and "e_m1_Mt_TauEnUp" not in self.complained:
        if not self.e_m1_Mt_TauEnUp_branch and "e_m1_Mt_TauEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m1_Mt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Mt_TauEnUp")
        else:
            self.e_m1_Mt_TauEnUp_branch.SetAddress(<void*>&self.e_m1_Mt_TauEnUp_value)

        #print "making e_m1_MvaMet"
        self.e_m1_MvaMet_branch = the_tree.GetBranch("e_m1_MvaMet")
        #if not self.e_m1_MvaMet_branch and "e_m1_MvaMet" not in self.complained:
        if not self.e_m1_MvaMet_branch and "e_m1_MvaMet":
            warnings.warn( "EMuMuTree: Expected branch e_m1_MvaMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_MvaMet")
        else:
            self.e_m1_MvaMet_branch.SetAddress(<void*>&self.e_m1_MvaMet_value)

        #print "making e_m1_MvaMetCovMatrix00"
        self.e_m1_MvaMetCovMatrix00_branch = the_tree.GetBranch("e_m1_MvaMetCovMatrix00")
        #if not self.e_m1_MvaMetCovMatrix00_branch and "e_m1_MvaMetCovMatrix00" not in self.complained:
        if not self.e_m1_MvaMetCovMatrix00_branch and "e_m1_MvaMetCovMatrix00":
            warnings.warn( "EMuMuTree: Expected branch e_m1_MvaMetCovMatrix00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_MvaMetCovMatrix00")
        else:
            self.e_m1_MvaMetCovMatrix00_branch.SetAddress(<void*>&self.e_m1_MvaMetCovMatrix00_value)

        #print "making e_m1_MvaMetCovMatrix01"
        self.e_m1_MvaMetCovMatrix01_branch = the_tree.GetBranch("e_m1_MvaMetCovMatrix01")
        #if not self.e_m1_MvaMetCovMatrix01_branch and "e_m1_MvaMetCovMatrix01" not in self.complained:
        if not self.e_m1_MvaMetCovMatrix01_branch and "e_m1_MvaMetCovMatrix01":
            warnings.warn( "EMuMuTree: Expected branch e_m1_MvaMetCovMatrix01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_MvaMetCovMatrix01")
        else:
            self.e_m1_MvaMetCovMatrix01_branch.SetAddress(<void*>&self.e_m1_MvaMetCovMatrix01_value)

        #print "making e_m1_MvaMetCovMatrix10"
        self.e_m1_MvaMetCovMatrix10_branch = the_tree.GetBranch("e_m1_MvaMetCovMatrix10")
        #if not self.e_m1_MvaMetCovMatrix10_branch and "e_m1_MvaMetCovMatrix10" not in self.complained:
        if not self.e_m1_MvaMetCovMatrix10_branch and "e_m1_MvaMetCovMatrix10":
            warnings.warn( "EMuMuTree: Expected branch e_m1_MvaMetCovMatrix10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_MvaMetCovMatrix10")
        else:
            self.e_m1_MvaMetCovMatrix10_branch.SetAddress(<void*>&self.e_m1_MvaMetCovMatrix10_value)

        #print "making e_m1_MvaMetCovMatrix11"
        self.e_m1_MvaMetCovMatrix11_branch = the_tree.GetBranch("e_m1_MvaMetCovMatrix11")
        #if not self.e_m1_MvaMetCovMatrix11_branch and "e_m1_MvaMetCovMatrix11" not in self.complained:
        if not self.e_m1_MvaMetCovMatrix11_branch and "e_m1_MvaMetCovMatrix11":
            warnings.warn( "EMuMuTree: Expected branch e_m1_MvaMetCovMatrix11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_MvaMetCovMatrix11")
        else:
            self.e_m1_MvaMetCovMatrix11_branch.SetAddress(<void*>&self.e_m1_MvaMetCovMatrix11_value)

        #print "making e_m1_MvaMetPhi"
        self.e_m1_MvaMetPhi_branch = the_tree.GetBranch("e_m1_MvaMetPhi")
        #if not self.e_m1_MvaMetPhi_branch and "e_m1_MvaMetPhi" not in self.complained:
        if not self.e_m1_MvaMetPhi_branch and "e_m1_MvaMetPhi":
            warnings.warn( "EMuMuTree: Expected branch e_m1_MvaMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_MvaMetPhi")
        else:
            self.e_m1_MvaMetPhi_branch.SetAddress(<void*>&self.e_m1_MvaMetPhi_value)

        #print "making e_m1_PZeta"
        self.e_m1_PZeta_branch = the_tree.GetBranch("e_m1_PZeta")
        #if not self.e_m1_PZeta_branch and "e_m1_PZeta" not in self.complained:
        if not self.e_m1_PZeta_branch and "e_m1_PZeta":
            warnings.warn( "EMuMuTree: Expected branch e_m1_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_PZeta")
        else:
            self.e_m1_PZeta_branch.SetAddress(<void*>&self.e_m1_PZeta_value)

        #print "making e_m1_PZetaLess0p85PZetaVis"
        self.e_m1_PZetaLess0p85PZetaVis_branch = the_tree.GetBranch("e_m1_PZetaLess0p85PZetaVis")
        #if not self.e_m1_PZetaLess0p85PZetaVis_branch and "e_m1_PZetaLess0p85PZetaVis" not in self.complained:
        if not self.e_m1_PZetaLess0p85PZetaVis_branch and "e_m1_PZetaLess0p85PZetaVis":
            warnings.warn( "EMuMuTree: Expected branch e_m1_PZetaLess0p85PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_PZetaLess0p85PZetaVis")
        else:
            self.e_m1_PZetaLess0p85PZetaVis_branch.SetAddress(<void*>&self.e_m1_PZetaLess0p85PZetaVis_value)

        #print "making e_m1_PZetaVis"
        self.e_m1_PZetaVis_branch = the_tree.GetBranch("e_m1_PZetaVis")
        #if not self.e_m1_PZetaVis_branch and "e_m1_PZetaVis" not in self.complained:
        if not self.e_m1_PZetaVis_branch and "e_m1_PZetaVis":
            warnings.warn( "EMuMuTree: Expected branch e_m1_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_PZetaVis")
        else:
            self.e_m1_PZetaVis_branch.SetAddress(<void*>&self.e_m1_PZetaVis_value)

        #print "making e_m1_Phi"
        self.e_m1_Phi_branch = the_tree.GetBranch("e_m1_Phi")
        #if not self.e_m1_Phi_branch and "e_m1_Phi" not in self.complained:
        if not self.e_m1_Phi_branch and "e_m1_Phi":
            warnings.warn( "EMuMuTree: Expected branch e_m1_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Phi")
        else:
            self.e_m1_Phi_branch.SetAddress(<void*>&self.e_m1_Phi_value)

        #print "making e_m1_Pt"
        self.e_m1_Pt_branch = the_tree.GetBranch("e_m1_Pt")
        #if not self.e_m1_Pt_branch and "e_m1_Pt" not in self.complained:
        if not self.e_m1_Pt_branch and "e_m1_Pt":
            warnings.warn( "EMuMuTree: Expected branch e_m1_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Pt")
        else:
            self.e_m1_Pt_branch.SetAddress(<void*>&self.e_m1_Pt_value)

        #print "making e_m1_SS"
        self.e_m1_SS_branch = the_tree.GetBranch("e_m1_SS")
        #if not self.e_m1_SS_branch and "e_m1_SS" not in self.complained:
        if not self.e_m1_SS_branch and "e_m1_SS":
            warnings.warn( "EMuMuTree: Expected branch e_m1_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_SS")
        else:
            self.e_m1_SS_branch.SetAddress(<void*>&self.e_m1_SS_value)

        #print "making e_m1_ToMETDPhi_Ty1"
        self.e_m1_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e_m1_ToMETDPhi_Ty1")
        #if not self.e_m1_ToMETDPhi_Ty1_branch and "e_m1_ToMETDPhi_Ty1" not in self.complained:
        if not self.e_m1_ToMETDPhi_Ty1_branch and "e_m1_ToMETDPhi_Ty1":
            warnings.warn( "EMuMuTree: Expected branch e_m1_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_ToMETDPhi_Ty1")
        else:
            self.e_m1_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e_m1_ToMETDPhi_Ty1_value)

        #print "making e_m1_collinearmass"
        self.e_m1_collinearmass_branch = the_tree.GetBranch("e_m1_collinearmass")
        #if not self.e_m1_collinearmass_branch and "e_m1_collinearmass" not in self.complained:
        if not self.e_m1_collinearmass_branch and "e_m1_collinearmass":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass")
        else:
            self.e_m1_collinearmass_branch.SetAddress(<void*>&self.e_m1_collinearmass_value)

        #print "making e_m1_collinearmass_CheckUESDown"
        self.e_m1_collinearmass_CheckUESDown_branch = the_tree.GetBranch("e_m1_collinearmass_CheckUESDown")
        #if not self.e_m1_collinearmass_CheckUESDown_branch and "e_m1_collinearmass_CheckUESDown" not in self.complained:
        if not self.e_m1_collinearmass_CheckUESDown_branch and "e_m1_collinearmass_CheckUESDown":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_CheckUESDown")
        else:
            self.e_m1_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.e_m1_collinearmass_CheckUESDown_value)

        #print "making e_m1_collinearmass_CheckUESUp"
        self.e_m1_collinearmass_CheckUESUp_branch = the_tree.GetBranch("e_m1_collinearmass_CheckUESUp")
        #if not self.e_m1_collinearmass_CheckUESUp_branch and "e_m1_collinearmass_CheckUESUp" not in self.complained:
        if not self.e_m1_collinearmass_CheckUESUp_branch and "e_m1_collinearmass_CheckUESUp":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_CheckUESUp")
        else:
            self.e_m1_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.e_m1_collinearmass_CheckUESUp_value)

        #print "making e_m1_collinearmass_EleEnDown"
        self.e_m1_collinearmass_EleEnDown_branch = the_tree.GetBranch("e_m1_collinearmass_EleEnDown")
        #if not self.e_m1_collinearmass_EleEnDown_branch and "e_m1_collinearmass_EleEnDown" not in self.complained:
        if not self.e_m1_collinearmass_EleEnDown_branch and "e_m1_collinearmass_EleEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_EleEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_EleEnDown")
        else:
            self.e_m1_collinearmass_EleEnDown_branch.SetAddress(<void*>&self.e_m1_collinearmass_EleEnDown_value)

        #print "making e_m1_collinearmass_EleEnUp"
        self.e_m1_collinearmass_EleEnUp_branch = the_tree.GetBranch("e_m1_collinearmass_EleEnUp")
        #if not self.e_m1_collinearmass_EleEnUp_branch and "e_m1_collinearmass_EleEnUp" not in self.complained:
        if not self.e_m1_collinearmass_EleEnUp_branch and "e_m1_collinearmass_EleEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_EleEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_EleEnUp")
        else:
            self.e_m1_collinearmass_EleEnUp_branch.SetAddress(<void*>&self.e_m1_collinearmass_EleEnUp_value)

        #print "making e_m1_collinearmass_JetCheckTotalDown"
        self.e_m1_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("e_m1_collinearmass_JetCheckTotalDown")
        #if not self.e_m1_collinearmass_JetCheckTotalDown_branch and "e_m1_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.e_m1_collinearmass_JetCheckTotalDown_branch and "e_m1_collinearmass_JetCheckTotalDown":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_JetCheckTotalDown")
        else:
            self.e_m1_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.e_m1_collinearmass_JetCheckTotalDown_value)

        #print "making e_m1_collinearmass_JetCheckTotalUp"
        self.e_m1_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("e_m1_collinearmass_JetCheckTotalUp")
        #if not self.e_m1_collinearmass_JetCheckTotalUp_branch and "e_m1_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.e_m1_collinearmass_JetCheckTotalUp_branch and "e_m1_collinearmass_JetCheckTotalUp":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_JetCheckTotalUp")
        else:
            self.e_m1_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.e_m1_collinearmass_JetCheckTotalUp_value)

        #print "making e_m1_collinearmass_JetEnDown"
        self.e_m1_collinearmass_JetEnDown_branch = the_tree.GetBranch("e_m1_collinearmass_JetEnDown")
        #if not self.e_m1_collinearmass_JetEnDown_branch and "e_m1_collinearmass_JetEnDown" not in self.complained:
        if not self.e_m1_collinearmass_JetEnDown_branch and "e_m1_collinearmass_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_JetEnDown")
        else:
            self.e_m1_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.e_m1_collinearmass_JetEnDown_value)

        #print "making e_m1_collinearmass_JetEnUp"
        self.e_m1_collinearmass_JetEnUp_branch = the_tree.GetBranch("e_m1_collinearmass_JetEnUp")
        #if not self.e_m1_collinearmass_JetEnUp_branch and "e_m1_collinearmass_JetEnUp" not in self.complained:
        if not self.e_m1_collinearmass_JetEnUp_branch and "e_m1_collinearmass_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_JetEnUp")
        else:
            self.e_m1_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.e_m1_collinearmass_JetEnUp_value)

        #print "making e_m1_collinearmass_MuEnDown"
        self.e_m1_collinearmass_MuEnDown_branch = the_tree.GetBranch("e_m1_collinearmass_MuEnDown")
        #if not self.e_m1_collinearmass_MuEnDown_branch and "e_m1_collinearmass_MuEnDown" not in self.complained:
        if not self.e_m1_collinearmass_MuEnDown_branch and "e_m1_collinearmass_MuEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_MuEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_MuEnDown")
        else:
            self.e_m1_collinearmass_MuEnDown_branch.SetAddress(<void*>&self.e_m1_collinearmass_MuEnDown_value)

        #print "making e_m1_collinearmass_MuEnUp"
        self.e_m1_collinearmass_MuEnUp_branch = the_tree.GetBranch("e_m1_collinearmass_MuEnUp")
        #if not self.e_m1_collinearmass_MuEnUp_branch and "e_m1_collinearmass_MuEnUp" not in self.complained:
        if not self.e_m1_collinearmass_MuEnUp_branch and "e_m1_collinearmass_MuEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_MuEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_MuEnUp")
        else:
            self.e_m1_collinearmass_MuEnUp_branch.SetAddress(<void*>&self.e_m1_collinearmass_MuEnUp_value)

        #print "making e_m1_collinearmass_TauEnDown"
        self.e_m1_collinearmass_TauEnDown_branch = the_tree.GetBranch("e_m1_collinearmass_TauEnDown")
        #if not self.e_m1_collinearmass_TauEnDown_branch and "e_m1_collinearmass_TauEnDown" not in self.complained:
        if not self.e_m1_collinearmass_TauEnDown_branch and "e_m1_collinearmass_TauEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_TauEnDown")
        else:
            self.e_m1_collinearmass_TauEnDown_branch.SetAddress(<void*>&self.e_m1_collinearmass_TauEnDown_value)

        #print "making e_m1_collinearmass_TauEnUp"
        self.e_m1_collinearmass_TauEnUp_branch = the_tree.GetBranch("e_m1_collinearmass_TauEnUp")
        #if not self.e_m1_collinearmass_TauEnUp_branch and "e_m1_collinearmass_TauEnUp" not in self.complained:
        if not self.e_m1_collinearmass_TauEnUp_branch and "e_m1_collinearmass_TauEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_TauEnUp")
        else:
            self.e_m1_collinearmass_TauEnUp_branch.SetAddress(<void*>&self.e_m1_collinearmass_TauEnUp_value)

        #print "making e_m1_collinearmass_UnclusteredEnDown"
        self.e_m1_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("e_m1_collinearmass_UnclusteredEnDown")
        #if not self.e_m1_collinearmass_UnclusteredEnDown_branch and "e_m1_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.e_m1_collinearmass_UnclusteredEnDown_branch and "e_m1_collinearmass_UnclusteredEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_UnclusteredEnDown")
        else:
            self.e_m1_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.e_m1_collinearmass_UnclusteredEnDown_value)

        #print "making e_m1_collinearmass_UnclusteredEnUp"
        self.e_m1_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("e_m1_collinearmass_UnclusteredEnUp")
        #if not self.e_m1_collinearmass_UnclusteredEnUp_branch and "e_m1_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.e_m1_collinearmass_UnclusteredEnUp_branch and "e_m1_collinearmass_UnclusteredEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m1_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_collinearmass_UnclusteredEnUp")
        else:
            self.e_m1_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.e_m1_collinearmass_UnclusteredEnUp_value)

        #print "making e_m1_pt_tt"
        self.e_m1_pt_tt_branch = the_tree.GetBranch("e_m1_pt_tt")
        #if not self.e_m1_pt_tt_branch and "e_m1_pt_tt" not in self.complained:
        if not self.e_m1_pt_tt_branch and "e_m1_pt_tt":
            warnings.warn( "EMuMuTree: Expected branch e_m1_pt_tt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_pt_tt")
        else:
            self.e_m1_pt_tt_branch.SetAddress(<void*>&self.e_m1_pt_tt_value)

        #print "making e_m2_CosThetaStar"
        self.e_m2_CosThetaStar_branch = the_tree.GetBranch("e_m2_CosThetaStar")
        #if not self.e_m2_CosThetaStar_branch and "e_m2_CosThetaStar" not in self.complained:
        if not self.e_m2_CosThetaStar_branch and "e_m2_CosThetaStar":
            warnings.warn( "EMuMuTree: Expected branch e_m2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_CosThetaStar")
        else:
            self.e_m2_CosThetaStar_branch.SetAddress(<void*>&self.e_m2_CosThetaStar_value)

        #print "making e_m2_DPhi"
        self.e_m2_DPhi_branch = the_tree.GetBranch("e_m2_DPhi")
        #if not self.e_m2_DPhi_branch and "e_m2_DPhi" not in self.complained:
        if not self.e_m2_DPhi_branch and "e_m2_DPhi":
            warnings.warn( "EMuMuTree: Expected branch e_m2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_DPhi")
        else:
            self.e_m2_DPhi_branch.SetAddress(<void*>&self.e_m2_DPhi_value)

        #print "making e_m2_DR"
        self.e_m2_DR_branch = the_tree.GetBranch("e_m2_DR")
        #if not self.e_m2_DR_branch and "e_m2_DR" not in self.complained:
        if not self.e_m2_DR_branch and "e_m2_DR":
            warnings.warn( "EMuMuTree: Expected branch e_m2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_DR")
        else:
            self.e_m2_DR_branch.SetAddress(<void*>&self.e_m2_DR_value)

        #print "making e_m2_Eta"
        self.e_m2_Eta_branch = the_tree.GetBranch("e_m2_Eta")
        #if not self.e_m2_Eta_branch and "e_m2_Eta" not in self.complained:
        if not self.e_m2_Eta_branch and "e_m2_Eta":
            warnings.warn( "EMuMuTree: Expected branch e_m2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Eta")
        else:
            self.e_m2_Eta_branch.SetAddress(<void*>&self.e_m2_Eta_value)

        #print "making e_m2_Mass"
        self.e_m2_Mass_branch = the_tree.GetBranch("e_m2_Mass")
        #if not self.e_m2_Mass_branch and "e_m2_Mass" not in self.complained:
        if not self.e_m2_Mass_branch and "e_m2_Mass":
            warnings.warn( "EMuMuTree: Expected branch e_m2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Mass")
        else:
            self.e_m2_Mass_branch.SetAddress(<void*>&self.e_m2_Mass_value)

        #print "making e_m2_Mass_TauEnDown"
        self.e_m2_Mass_TauEnDown_branch = the_tree.GetBranch("e_m2_Mass_TauEnDown")
        #if not self.e_m2_Mass_TauEnDown_branch and "e_m2_Mass_TauEnDown" not in self.complained:
        if not self.e_m2_Mass_TauEnDown_branch and "e_m2_Mass_TauEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m2_Mass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Mass_TauEnDown")
        else:
            self.e_m2_Mass_TauEnDown_branch.SetAddress(<void*>&self.e_m2_Mass_TauEnDown_value)

        #print "making e_m2_Mass_TauEnUp"
        self.e_m2_Mass_TauEnUp_branch = the_tree.GetBranch("e_m2_Mass_TauEnUp")
        #if not self.e_m2_Mass_TauEnUp_branch and "e_m2_Mass_TauEnUp" not in self.complained:
        if not self.e_m2_Mass_TauEnUp_branch and "e_m2_Mass_TauEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m2_Mass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Mass_TauEnUp")
        else:
            self.e_m2_Mass_TauEnUp_branch.SetAddress(<void*>&self.e_m2_Mass_TauEnUp_value)

        #print "making e_m2_Mt"
        self.e_m2_Mt_branch = the_tree.GetBranch("e_m2_Mt")
        #if not self.e_m2_Mt_branch and "e_m2_Mt" not in self.complained:
        if not self.e_m2_Mt_branch and "e_m2_Mt":
            warnings.warn( "EMuMuTree: Expected branch e_m2_Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Mt")
        else:
            self.e_m2_Mt_branch.SetAddress(<void*>&self.e_m2_Mt_value)

        #print "making e_m2_MtTotal"
        self.e_m2_MtTotal_branch = the_tree.GetBranch("e_m2_MtTotal")
        #if not self.e_m2_MtTotal_branch and "e_m2_MtTotal" not in self.complained:
        if not self.e_m2_MtTotal_branch and "e_m2_MtTotal":
            warnings.warn( "EMuMuTree: Expected branch e_m2_MtTotal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_MtTotal")
        else:
            self.e_m2_MtTotal_branch.SetAddress(<void*>&self.e_m2_MtTotal_value)

        #print "making e_m2_Mt_TauEnDown"
        self.e_m2_Mt_TauEnDown_branch = the_tree.GetBranch("e_m2_Mt_TauEnDown")
        #if not self.e_m2_Mt_TauEnDown_branch and "e_m2_Mt_TauEnDown" not in self.complained:
        if not self.e_m2_Mt_TauEnDown_branch and "e_m2_Mt_TauEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m2_Mt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Mt_TauEnDown")
        else:
            self.e_m2_Mt_TauEnDown_branch.SetAddress(<void*>&self.e_m2_Mt_TauEnDown_value)

        #print "making e_m2_Mt_TauEnUp"
        self.e_m2_Mt_TauEnUp_branch = the_tree.GetBranch("e_m2_Mt_TauEnUp")
        #if not self.e_m2_Mt_TauEnUp_branch and "e_m2_Mt_TauEnUp" not in self.complained:
        if not self.e_m2_Mt_TauEnUp_branch and "e_m2_Mt_TauEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m2_Mt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Mt_TauEnUp")
        else:
            self.e_m2_Mt_TauEnUp_branch.SetAddress(<void*>&self.e_m2_Mt_TauEnUp_value)

        #print "making e_m2_MvaMet"
        self.e_m2_MvaMet_branch = the_tree.GetBranch("e_m2_MvaMet")
        #if not self.e_m2_MvaMet_branch and "e_m2_MvaMet" not in self.complained:
        if not self.e_m2_MvaMet_branch and "e_m2_MvaMet":
            warnings.warn( "EMuMuTree: Expected branch e_m2_MvaMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_MvaMet")
        else:
            self.e_m2_MvaMet_branch.SetAddress(<void*>&self.e_m2_MvaMet_value)

        #print "making e_m2_MvaMetCovMatrix00"
        self.e_m2_MvaMetCovMatrix00_branch = the_tree.GetBranch("e_m2_MvaMetCovMatrix00")
        #if not self.e_m2_MvaMetCovMatrix00_branch and "e_m2_MvaMetCovMatrix00" not in self.complained:
        if not self.e_m2_MvaMetCovMatrix00_branch and "e_m2_MvaMetCovMatrix00":
            warnings.warn( "EMuMuTree: Expected branch e_m2_MvaMetCovMatrix00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_MvaMetCovMatrix00")
        else:
            self.e_m2_MvaMetCovMatrix00_branch.SetAddress(<void*>&self.e_m2_MvaMetCovMatrix00_value)

        #print "making e_m2_MvaMetCovMatrix01"
        self.e_m2_MvaMetCovMatrix01_branch = the_tree.GetBranch("e_m2_MvaMetCovMatrix01")
        #if not self.e_m2_MvaMetCovMatrix01_branch and "e_m2_MvaMetCovMatrix01" not in self.complained:
        if not self.e_m2_MvaMetCovMatrix01_branch and "e_m2_MvaMetCovMatrix01":
            warnings.warn( "EMuMuTree: Expected branch e_m2_MvaMetCovMatrix01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_MvaMetCovMatrix01")
        else:
            self.e_m2_MvaMetCovMatrix01_branch.SetAddress(<void*>&self.e_m2_MvaMetCovMatrix01_value)

        #print "making e_m2_MvaMetCovMatrix10"
        self.e_m2_MvaMetCovMatrix10_branch = the_tree.GetBranch("e_m2_MvaMetCovMatrix10")
        #if not self.e_m2_MvaMetCovMatrix10_branch and "e_m2_MvaMetCovMatrix10" not in self.complained:
        if not self.e_m2_MvaMetCovMatrix10_branch and "e_m2_MvaMetCovMatrix10":
            warnings.warn( "EMuMuTree: Expected branch e_m2_MvaMetCovMatrix10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_MvaMetCovMatrix10")
        else:
            self.e_m2_MvaMetCovMatrix10_branch.SetAddress(<void*>&self.e_m2_MvaMetCovMatrix10_value)

        #print "making e_m2_MvaMetCovMatrix11"
        self.e_m2_MvaMetCovMatrix11_branch = the_tree.GetBranch("e_m2_MvaMetCovMatrix11")
        #if not self.e_m2_MvaMetCovMatrix11_branch and "e_m2_MvaMetCovMatrix11" not in self.complained:
        if not self.e_m2_MvaMetCovMatrix11_branch and "e_m2_MvaMetCovMatrix11":
            warnings.warn( "EMuMuTree: Expected branch e_m2_MvaMetCovMatrix11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_MvaMetCovMatrix11")
        else:
            self.e_m2_MvaMetCovMatrix11_branch.SetAddress(<void*>&self.e_m2_MvaMetCovMatrix11_value)

        #print "making e_m2_MvaMetPhi"
        self.e_m2_MvaMetPhi_branch = the_tree.GetBranch("e_m2_MvaMetPhi")
        #if not self.e_m2_MvaMetPhi_branch and "e_m2_MvaMetPhi" not in self.complained:
        if not self.e_m2_MvaMetPhi_branch and "e_m2_MvaMetPhi":
            warnings.warn( "EMuMuTree: Expected branch e_m2_MvaMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_MvaMetPhi")
        else:
            self.e_m2_MvaMetPhi_branch.SetAddress(<void*>&self.e_m2_MvaMetPhi_value)

        #print "making e_m2_PZeta"
        self.e_m2_PZeta_branch = the_tree.GetBranch("e_m2_PZeta")
        #if not self.e_m2_PZeta_branch and "e_m2_PZeta" not in self.complained:
        if not self.e_m2_PZeta_branch and "e_m2_PZeta":
            warnings.warn( "EMuMuTree: Expected branch e_m2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_PZeta")
        else:
            self.e_m2_PZeta_branch.SetAddress(<void*>&self.e_m2_PZeta_value)

        #print "making e_m2_PZetaLess0p85PZetaVis"
        self.e_m2_PZetaLess0p85PZetaVis_branch = the_tree.GetBranch("e_m2_PZetaLess0p85PZetaVis")
        #if not self.e_m2_PZetaLess0p85PZetaVis_branch and "e_m2_PZetaLess0p85PZetaVis" not in self.complained:
        if not self.e_m2_PZetaLess0p85PZetaVis_branch and "e_m2_PZetaLess0p85PZetaVis":
            warnings.warn( "EMuMuTree: Expected branch e_m2_PZetaLess0p85PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_PZetaLess0p85PZetaVis")
        else:
            self.e_m2_PZetaLess0p85PZetaVis_branch.SetAddress(<void*>&self.e_m2_PZetaLess0p85PZetaVis_value)

        #print "making e_m2_PZetaVis"
        self.e_m2_PZetaVis_branch = the_tree.GetBranch("e_m2_PZetaVis")
        #if not self.e_m2_PZetaVis_branch and "e_m2_PZetaVis" not in self.complained:
        if not self.e_m2_PZetaVis_branch and "e_m2_PZetaVis":
            warnings.warn( "EMuMuTree: Expected branch e_m2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_PZetaVis")
        else:
            self.e_m2_PZetaVis_branch.SetAddress(<void*>&self.e_m2_PZetaVis_value)

        #print "making e_m2_Phi"
        self.e_m2_Phi_branch = the_tree.GetBranch("e_m2_Phi")
        #if not self.e_m2_Phi_branch and "e_m2_Phi" not in self.complained:
        if not self.e_m2_Phi_branch and "e_m2_Phi":
            warnings.warn( "EMuMuTree: Expected branch e_m2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Phi")
        else:
            self.e_m2_Phi_branch.SetAddress(<void*>&self.e_m2_Phi_value)

        #print "making e_m2_Pt"
        self.e_m2_Pt_branch = the_tree.GetBranch("e_m2_Pt")
        #if not self.e_m2_Pt_branch and "e_m2_Pt" not in self.complained:
        if not self.e_m2_Pt_branch and "e_m2_Pt":
            warnings.warn( "EMuMuTree: Expected branch e_m2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Pt")
        else:
            self.e_m2_Pt_branch.SetAddress(<void*>&self.e_m2_Pt_value)

        #print "making e_m2_SS"
        self.e_m2_SS_branch = the_tree.GetBranch("e_m2_SS")
        #if not self.e_m2_SS_branch and "e_m2_SS" not in self.complained:
        if not self.e_m2_SS_branch and "e_m2_SS":
            warnings.warn( "EMuMuTree: Expected branch e_m2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_SS")
        else:
            self.e_m2_SS_branch.SetAddress(<void*>&self.e_m2_SS_value)

        #print "making e_m2_ToMETDPhi_Ty1"
        self.e_m2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e_m2_ToMETDPhi_Ty1")
        #if not self.e_m2_ToMETDPhi_Ty1_branch and "e_m2_ToMETDPhi_Ty1" not in self.complained:
        if not self.e_m2_ToMETDPhi_Ty1_branch and "e_m2_ToMETDPhi_Ty1":
            warnings.warn( "EMuMuTree: Expected branch e_m2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_ToMETDPhi_Ty1")
        else:
            self.e_m2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e_m2_ToMETDPhi_Ty1_value)

        #print "making e_m2_collinearmass"
        self.e_m2_collinearmass_branch = the_tree.GetBranch("e_m2_collinearmass")
        #if not self.e_m2_collinearmass_branch and "e_m2_collinearmass" not in self.complained:
        if not self.e_m2_collinearmass_branch and "e_m2_collinearmass":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass")
        else:
            self.e_m2_collinearmass_branch.SetAddress(<void*>&self.e_m2_collinearmass_value)

        #print "making e_m2_collinearmass_CheckUESDown"
        self.e_m2_collinearmass_CheckUESDown_branch = the_tree.GetBranch("e_m2_collinearmass_CheckUESDown")
        #if not self.e_m2_collinearmass_CheckUESDown_branch and "e_m2_collinearmass_CheckUESDown" not in self.complained:
        if not self.e_m2_collinearmass_CheckUESDown_branch and "e_m2_collinearmass_CheckUESDown":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_CheckUESDown")
        else:
            self.e_m2_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.e_m2_collinearmass_CheckUESDown_value)

        #print "making e_m2_collinearmass_CheckUESUp"
        self.e_m2_collinearmass_CheckUESUp_branch = the_tree.GetBranch("e_m2_collinearmass_CheckUESUp")
        #if not self.e_m2_collinearmass_CheckUESUp_branch and "e_m2_collinearmass_CheckUESUp" not in self.complained:
        if not self.e_m2_collinearmass_CheckUESUp_branch and "e_m2_collinearmass_CheckUESUp":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_CheckUESUp")
        else:
            self.e_m2_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.e_m2_collinearmass_CheckUESUp_value)

        #print "making e_m2_collinearmass_EleEnDown"
        self.e_m2_collinearmass_EleEnDown_branch = the_tree.GetBranch("e_m2_collinearmass_EleEnDown")
        #if not self.e_m2_collinearmass_EleEnDown_branch and "e_m2_collinearmass_EleEnDown" not in self.complained:
        if not self.e_m2_collinearmass_EleEnDown_branch and "e_m2_collinearmass_EleEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_EleEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_EleEnDown")
        else:
            self.e_m2_collinearmass_EleEnDown_branch.SetAddress(<void*>&self.e_m2_collinearmass_EleEnDown_value)

        #print "making e_m2_collinearmass_EleEnUp"
        self.e_m2_collinearmass_EleEnUp_branch = the_tree.GetBranch("e_m2_collinearmass_EleEnUp")
        #if not self.e_m2_collinearmass_EleEnUp_branch and "e_m2_collinearmass_EleEnUp" not in self.complained:
        if not self.e_m2_collinearmass_EleEnUp_branch and "e_m2_collinearmass_EleEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_EleEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_EleEnUp")
        else:
            self.e_m2_collinearmass_EleEnUp_branch.SetAddress(<void*>&self.e_m2_collinearmass_EleEnUp_value)

        #print "making e_m2_collinearmass_JetCheckTotalDown"
        self.e_m2_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("e_m2_collinearmass_JetCheckTotalDown")
        #if not self.e_m2_collinearmass_JetCheckTotalDown_branch and "e_m2_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.e_m2_collinearmass_JetCheckTotalDown_branch and "e_m2_collinearmass_JetCheckTotalDown":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_JetCheckTotalDown")
        else:
            self.e_m2_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.e_m2_collinearmass_JetCheckTotalDown_value)

        #print "making e_m2_collinearmass_JetCheckTotalUp"
        self.e_m2_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("e_m2_collinearmass_JetCheckTotalUp")
        #if not self.e_m2_collinearmass_JetCheckTotalUp_branch and "e_m2_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.e_m2_collinearmass_JetCheckTotalUp_branch and "e_m2_collinearmass_JetCheckTotalUp":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_JetCheckTotalUp")
        else:
            self.e_m2_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.e_m2_collinearmass_JetCheckTotalUp_value)

        #print "making e_m2_collinearmass_JetEnDown"
        self.e_m2_collinearmass_JetEnDown_branch = the_tree.GetBranch("e_m2_collinearmass_JetEnDown")
        #if not self.e_m2_collinearmass_JetEnDown_branch and "e_m2_collinearmass_JetEnDown" not in self.complained:
        if not self.e_m2_collinearmass_JetEnDown_branch and "e_m2_collinearmass_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_JetEnDown")
        else:
            self.e_m2_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.e_m2_collinearmass_JetEnDown_value)

        #print "making e_m2_collinearmass_JetEnUp"
        self.e_m2_collinearmass_JetEnUp_branch = the_tree.GetBranch("e_m2_collinearmass_JetEnUp")
        #if not self.e_m2_collinearmass_JetEnUp_branch and "e_m2_collinearmass_JetEnUp" not in self.complained:
        if not self.e_m2_collinearmass_JetEnUp_branch and "e_m2_collinearmass_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_JetEnUp")
        else:
            self.e_m2_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.e_m2_collinearmass_JetEnUp_value)

        #print "making e_m2_collinearmass_MuEnDown"
        self.e_m2_collinearmass_MuEnDown_branch = the_tree.GetBranch("e_m2_collinearmass_MuEnDown")
        #if not self.e_m2_collinearmass_MuEnDown_branch and "e_m2_collinearmass_MuEnDown" not in self.complained:
        if not self.e_m2_collinearmass_MuEnDown_branch and "e_m2_collinearmass_MuEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_MuEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_MuEnDown")
        else:
            self.e_m2_collinearmass_MuEnDown_branch.SetAddress(<void*>&self.e_m2_collinearmass_MuEnDown_value)

        #print "making e_m2_collinearmass_MuEnUp"
        self.e_m2_collinearmass_MuEnUp_branch = the_tree.GetBranch("e_m2_collinearmass_MuEnUp")
        #if not self.e_m2_collinearmass_MuEnUp_branch and "e_m2_collinearmass_MuEnUp" not in self.complained:
        if not self.e_m2_collinearmass_MuEnUp_branch and "e_m2_collinearmass_MuEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_MuEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_MuEnUp")
        else:
            self.e_m2_collinearmass_MuEnUp_branch.SetAddress(<void*>&self.e_m2_collinearmass_MuEnUp_value)

        #print "making e_m2_collinearmass_TauEnDown"
        self.e_m2_collinearmass_TauEnDown_branch = the_tree.GetBranch("e_m2_collinearmass_TauEnDown")
        #if not self.e_m2_collinearmass_TauEnDown_branch and "e_m2_collinearmass_TauEnDown" not in self.complained:
        if not self.e_m2_collinearmass_TauEnDown_branch and "e_m2_collinearmass_TauEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_TauEnDown")
        else:
            self.e_m2_collinearmass_TauEnDown_branch.SetAddress(<void*>&self.e_m2_collinearmass_TauEnDown_value)

        #print "making e_m2_collinearmass_TauEnUp"
        self.e_m2_collinearmass_TauEnUp_branch = the_tree.GetBranch("e_m2_collinearmass_TauEnUp")
        #if not self.e_m2_collinearmass_TauEnUp_branch and "e_m2_collinearmass_TauEnUp" not in self.complained:
        if not self.e_m2_collinearmass_TauEnUp_branch and "e_m2_collinearmass_TauEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_TauEnUp")
        else:
            self.e_m2_collinearmass_TauEnUp_branch.SetAddress(<void*>&self.e_m2_collinearmass_TauEnUp_value)

        #print "making e_m2_collinearmass_UnclusteredEnDown"
        self.e_m2_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("e_m2_collinearmass_UnclusteredEnDown")
        #if not self.e_m2_collinearmass_UnclusteredEnDown_branch and "e_m2_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.e_m2_collinearmass_UnclusteredEnDown_branch and "e_m2_collinearmass_UnclusteredEnDown":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_UnclusteredEnDown")
        else:
            self.e_m2_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.e_m2_collinearmass_UnclusteredEnDown_value)

        #print "making e_m2_collinearmass_UnclusteredEnUp"
        self.e_m2_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("e_m2_collinearmass_UnclusteredEnUp")
        #if not self.e_m2_collinearmass_UnclusteredEnUp_branch and "e_m2_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.e_m2_collinearmass_UnclusteredEnUp_branch and "e_m2_collinearmass_UnclusteredEnUp":
            warnings.warn( "EMuMuTree: Expected branch e_m2_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_collinearmass_UnclusteredEnUp")
        else:
            self.e_m2_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.e_m2_collinearmass_UnclusteredEnUp_value)

        #print "making e_m2_pt_tt"
        self.e_m2_pt_tt_branch = the_tree.GetBranch("e_m2_pt_tt")
        #if not self.e_m2_pt_tt_branch and "e_m2_pt_tt" not in self.complained:
        if not self.e_m2_pt_tt_branch and "e_m2_pt_tt":
            warnings.warn( "EMuMuTree: Expected branch e_m2_pt_tt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_pt_tt")
        else:
            self.e_m2_pt_tt_branch.SetAddress(<void*>&self.e_m2_pt_tt_value)

        #print "making edeltaEtaSuperClusterTrackAtVtx"
        self.edeltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaEtaSuperClusterTrackAtVtx")
        #if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "EMuMuTree: Expected branch edeltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaEtaSuperClusterTrackAtVtx")
        else:
            self.edeltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaEtaSuperClusterTrackAtVtx_value)

        #print "making edeltaPhiSuperClusterTrackAtVtx"
        self.edeltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaPhiSuperClusterTrackAtVtx")
        #if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "EMuMuTree: Expected branch edeltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaPhiSuperClusterTrackAtVtx")
        else:
            self.edeltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaPhiSuperClusterTrackAtVtx_value)

        #print "making eeSuperClusterOverP"
        self.eeSuperClusterOverP_branch = the_tree.GetBranch("eeSuperClusterOverP")
        #if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP" not in self.complained:
        if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP":
            warnings.warn( "EMuMuTree: Expected branch eeSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eeSuperClusterOverP")
        else:
            self.eeSuperClusterOverP_branch.SetAddress(<void*>&self.eeSuperClusterOverP_value)

        #print "making eecalEnergy"
        self.eecalEnergy_branch = the_tree.GetBranch("eecalEnergy")
        #if not self.eecalEnergy_branch and "eecalEnergy" not in self.complained:
        if not self.eecalEnergy_branch and "eecalEnergy":
            warnings.warn( "EMuMuTree: Expected branch eecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eecalEnergy")
        else:
            self.eecalEnergy_branch.SetAddress(<void*>&self.eecalEnergy_value)

        #print "making efBrem"
        self.efBrem_branch = the_tree.GetBranch("efBrem")
        #if not self.efBrem_branch and "efBrem" not in self.complained:
        if not self.efBrem_branch and "efBrem":
            warnings.warn( "EMuMuTree: Expected branch efBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("efBrem")
        else:
            self.efBrem_branch.SetAddress(<void*>&self.efBrem_value)

        #print "making etrackMomentumAtVtxP"
        self.etrackMomentumAtVtxP_branch = the_tree.GetBranch("etrackMomentumAtVtxP")
        #if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP" not in self.complained:
        if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP":
            warnings.warn( "EMuMuTree: Expected branch etrackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("etrackMomentumAtVtxP")
        else:
            self.etrackMomentumAtVtxP_branch.SetAddress(<void*>&self.etrackMomentumAtVtxP_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "EMuMuTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "EMuMuTree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "EMuMuTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "EMuMuTree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "EMuMuTree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "EMuMuTree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "EMuMuTree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "EMuMuTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "EMuMuTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "EMuMuTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWenu"
        self.isWenu_branch = the_tree.GetBranch("isWenu")
        #if not self.isWenu_branch and "isWenu" not in self.complained:
        if not self.isWenu_branch and "isWenu":
            warnings.warn( "EMuMuTree: Expected branch isWenu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWenu")
        else:
            self.isWenu_branch.SetAddress(<void*>&self.isWenu_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "EMuMuTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "EMuMuTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "EMuMuTree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "EMuMuTree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "EMuMuTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "EMuMuTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "EMuMuTree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "EMuMuTree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "EMuMuTree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1partonflavor"
        self.j1partonflavor_branch = the_tree.GetBranch("j1partonflavor")
        #if not self.j1partonflavor_branch and "j1partonflavor" not in self.complained:
        if not self.j1partonflavor_branch and "j1partonflavor":
            warnings.warn( "EMuMuTree: Expected branch j1partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1partonflavor")
        else:
            self.j1partonflavor_branch.SetAddress(<void*>&self.j1partonflavor_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "EMuMuTree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "EMuMuTree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptDown"
        self.j1ptDown_branch = the_tree.GetBranch("j1ptDown")
        #if not self.j1ptDown_branch and "j1ptDown" not in self.complained:
        if not self.j1ptDown_branch and "j1ptDown":
            warnings.warn( "EMuMuTree: Expected branch j1ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptDown")
        else:
            self.j1ptDown_branch.SetAddress(<void*>&self.j1ptDown_value)

        #print "making j1ptUp"
        self.j1ptUp_branch = the_tree.GetBranch("j1ptUp")
        #if not self.j1ptUp_branch and "j1ptUp" not in self.complained:
        if not self.j1ptUp_branch and "j1ptUp":
            warnings.warn( "EMuMuTree: Expected branch j1ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptUp")
        else:
            self.j1ptUp_branch.SetAddress(<void*>&self.j1ptUp_value)

        #print "making j1pu"
        self.j1pu_branch = the_tree.GetBranch("j1pu")
        #if not self.j1pu_branch and "j1pu" not in self.complained:
        if not self.j1pu_branch and "j1pu":
            warnings.warn( "EMuMuTree: Expected branch j1pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pu")
        else:
            self.j1pu_branch.SetAddress(<void*>&self.j1pu_value)

        #print "making j1rawf"
        self.j1rawf_branch = the_tree.GetBranch("j1rawf")
        #if not self.j1rawf_branch and "j1rawf" not in self.complained:
        if not self.j1rawf_branch and "j1rawf":
            warnings.warn( "EMuMuTree: Expected branch j1rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1rawf")
        else:
            self.j1rawf_branch.SetAddress(<void*>&self.j1rawf_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "EMuMuTree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "EMuMuTree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "EMuMuTree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2partonflavor"
        self.j2partonflavor_branch = the_tree.GetBranch("j2partonflavor")
        #if not self.j2partonflavor_branch and "j2partonflavor" not in self.complained:
        if not self.j2partonflavor_branch and "j2partonflavor":
            warnings.warn( "EMuMuTree: Expected branch j2partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2partonflavor")
        else:
            self.j2partonflavor_branch.SetAddress(<void*>&self.j2partonflavor_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "EMuMuTree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "EMuMuTree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptDown"
        self.j2ptDown_branch = the_tree.GetBranch("j2ptDown")
        #if not self.j2ptDown_branch and "j2ptDown" not in self.complained:
        if not self.j2ptDown_branch and "j2ptDown":
            warnings.warn( "EMuMuTree: Expected branch j2ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptDown")
        else:
            self.j2ptDown_branch.SetAddress(<void*>&self.j2ptDown_value)

        #print "making j2ptUp"
        self.j2ptUp_branch = the_tree.GetBranch("j2ptUp")
        #if not self.j2ptUp_branch and "j2ptUp" not in self.complained:
        if not self.j2ptUp_branch and "j2ptUp":
            warnings.warn( "EMuMuTree: Expected branch j2ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptUp")
        else:
            self.j2ptUp_branch.SetAddress(<void*>&self.j2ptUp_value)

        #print "making j2pu"
        self.j2pu_branch = the_tree.GetBranch("j2pu")
        #if not self.j2pu_branch and "j2pu" not in self.complained:
        if not self.j2pu_branch and "j2pu":
            warnings.warn( "EMuMuTree: Expected branch j2pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pu")
        else:
            self.j2pu_branch.SetAddress(<void*>&self.j2pu_value)

        #print "making j2rawf"
        self.j2rawf_branch = the_tree.GetBranch("j2rawf")
        #if not self.j2rawf_branch and "j2rawf" not in self.complained:
        if not self.j2rawf_branch and "j2rawf":
            warnings.warn( "EMuMuTree: Expected branch j2rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2rawf")
        else:
            self.j2rawf_branch.SetAddress(<void*>&self.j2rawf_value)

        #print "making jb1csv"
        self.jb1csv_branch = the_tree.GetBranch("jb1csv")
        #if not self.jb1csv_branch and "jb1csv" not in self.complained:
        if not self.jb1csv_branch and "jb1csv":
            warnings.warn( "EMuMuTree: Expected branch jb1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csv")
        else:
            self.jb1csv_branch.SetAddress(<void*>&self.jb1csv_value)

        #print "making jb1csv_CSVL"
        self.jb1csv_CSVL_branch = the_tree.GetBranch("jb1csv_CSVL")
        #if not self.jb1csv_CSVL_branch and "jb1csv_CSVL" not in self.complained:
        if not self.jb1csv_CSVL_branch and "jb1csv_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb1csv_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csv_CSVL")
        else:
            self.jb1csv_CSVL_branch.SetAddress(<void*>&self.jb1csv_CSVL_value)

        #print "making jb1eta"
        self.jb1eta_branch = the_tree.GetBranch("jb1eta")
        #if not self.jb1eta_branch and "jb1eta" not in self.complained:
        if not self.jb1eta_branch and "jb1eta":
            warnings.warn( "EMuMuTree: Expected branch jb1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta")
        else:
            self.jb1eta_branch.SetAddress(<void*>&self.jb1eta_value)

        #print "making jb1eta_CSVL"
        self.jb1eta_CSVL_branch = the_tree.GetBranch("jb1eta_CSVL")
        #if not self.jb1eta_CSVL_branch and "jb1eta_CSVL" not in self.complained:
        if not self.jb1eta_CSVL_branch and "jb1eta_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb1eta_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_CSVL")
        else:
            self.jb1eta_CSVL_branch.SetAddress(<void*>&self.jb1eta_CSVL_value)

        #print "making jb1hadronflavor"
        self.jb1hadronflavor_branch = the_tree.GetBranch("jb1hadronflavor")
        #if not self.jb1hadronflavor_branch and "jb1hadronflavor" not in self.complained:
        if not self.jb1hadronflavor_branch and "jb1hadronflavor":
            warnings.warn( "EMuMuTree: Expected branch jb1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor")
        else:
            self.jb1hadronflavor_branch.SetAddress(<void*>&self.jb1hadronflavor_value)

        #print "making jb1hadronflavor_CSVL"
        self.jb1hadronflavor_CSVL_branch = the_tree.GetBranch("jb1hadronflavor_CSVL")
        #if not self.jb1hadronflavor_CSVL_branch and "jb1hadronflavor_CSVL" not in self.complained:
        if not self.jb1hadronflavor_CSVL_branch and "jb1hadronflavor_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb1hadronflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_CSVL")
        else:
            self.jb1hadronflavor_CSVL_branch.SetAddress(<void*>&self.jb1hadronflavor_CSVL_value)

        #print "making jb1partonflavor"
        self.jb1partonflavor_branch = the_tree.GetBranch("jb1partonflavor")
        #if not self.jb1partonflavor_branch and "jb1partonflavor" not in self.complained:
        if not self.jb1partonflavor_branch and "jb1partonflavor":
            warnings.warn( "EMuMuTree: Expected branch jb1partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1partonflavor")
        else:
            self.jb1partonflavor_branch.SetAddress(<void*>&self.jb1partonflavor_value)

        #print "making jb1partonflavor_CSVL"
        self.jb1partonflavor_CSVL_branch = the_tree.GetBranch("jb1partonflavor_CSVL")
        #if not self.jb1partonflavor_CSVL_branch and "jb1partonflavor_CSVL" not in self.complained:
        if not self.jb1partonflavor_CSVL_branch and "jb1partonflavor_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb1partonflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1partonflavor_CSVL")
        else:
            self.jb1partonflavor_CSVL_branch.SetAddress(<void*>&self.jb1partonflavor_CSVL_value)

        #print "making jb1phi"
        self.jb1phi_branch = the_tree.GetBranch("jb1phi")
        #if not self.jb1phi_branch and "jb1phi" not in self.complained:
        if not self.jb1phi_branch and "jb1phi":
            warnings.warn( "EMuMuTree: Expected branch jb1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi")
        else:
            self.jb1phi_branch.SetAddress(<void*>&self.jb1phi_value)

        #print "making jb1phi_CSVL"
        self.jb1phi_CSVL_branch = the_tree.GetBranch("jb1phi_CSVL")
        #if not self.jb1phi_CSVL_branch and "jb1phi_CSVL" not in self.complained:
        if not self.jb1phi_CSVL_branch and "jb1phi_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb1phi_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_CSVL")
        else:
            self.jb1phi_CSVL_branch.SetAddress(<void*>&self.jb1phi_CSVL_value)

        #print "making jb1pt"
        self.jb1pt_branch = the_tree.GetBranch("jb1pt")
        #if not self.jb1pt_branch and "jb1pt" not in self.complained:
        if not self.jb1pt_branch and "jb1pt":
            warnings.warn( "EMuMuTree: Expected branch jb1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt")
        else:
            self.jb1pt_branch.SetAddress(<void*>&self.jb1pt_value)

        #print "making jb1ptDown"
        self.jb1ptDown_branch = the_tree.GetBranch("jb1ptDown")
        #if not self.jb1ptDown_branch and "jb1ptDown" not in self.complained:
        if not self.jb1ptDown_branch and "jb1ptDown":
            warnings.warn( "EMuMuTree: Expected branch jb1ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptDown")
        else:
            self.jb1ptDown_branch.SetAddress(<void*>&self.jb1ptDown_value)

        #print "making jb1ptDown_CSVL"
        self.jb1ptDown_CSVL_branch = the_tree.GetBranch("jb1ptDown_CSVL")
        #if not self.jb1ptDown_CSVL_branch and "jb1ptDown_CSVL" not in self.complained:
        if not self.jb1ptDown_CSVL_branch and "jb1ptDown_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb1ptDown_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptDown_CSVL")
        else:
            self.jb1ptDown_CSVL_branch.SetAddress(<void*>&self.jb1ptDown_CSVL_value)

        #print "making jb1ptUp"
        self.jb1ptUp_branch = the_tree.GetBranch("jb1ptUp")
        #if not self.jb1ptUp_branch and "jb1ptUp" not in self.complained:
        if not self.jb1ptUp_branch and "jb1ptUp":
            warnings.warn( "EMuMuTree: Expected branch jb1ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptUp")
        else:
            self.jb1ptUp_branch.SetAddress(<void*>&self.jb1ptUp_value)

        #print "making jb1ptUp_CSVL"
        self.jb1ptUp_CSVL_branch = the_tree.GetBranch("jb1ptUp_CSVL")
        #if not self.jb1ptUp_CSVL_branch and "jb1ptUp_CSVL" not in self.complained:
        if not self.jb1ptUp_CSVL_branch and "jb1ptUp_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb1ptUp_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptUp_CSVL")
        else:
            self.jb1ptUp_CSVL_branch.SetAddress(<void*>&self.jb1ptUp_CSVL_value)

        #print "making jb1pt_CSVL"
        self.jb1pt_CSVL_branch = the_tree.GetBranch("jb1pt_CSVL")
        #if not self.jb1pt_CSVL_branch and "jb1pt_CSVL" not in self.complained:
        if not self.jb1pt_CSVL_branch and "jb1pt_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb1pt_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_CSVL")
        else:
            self.jb1pt_CSVL_branch.SetAddress(<void*>&self.jb1pt_CSVL_value)

        #print "making jb1pu"
        self.jb1pu_branch = the_tree.GetBranch("jb1pu")
        #if not self.jb1pu_branch and "jb1pu" not in self.complained:
        if not self.jb1pu_branch and "jb1pu":
            warnings.warn( "EMuMuTree: Expected branch jb1pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pu")
        else:
            self.jb1pu_branch.SetAddress(<void*>&self.jb1pu_value)

        #print "making jb1pu_CSVL"
        self.jb1pu_CSVL_branch = the_tree.GetBranch("jb1pu_CSVL")
        #if not self.jb1pu_CSVL_branch and "jb1pu_CSVL" not in self.complained:
        if not self.jb1pu_CSVL_branch and "jb1pu_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb1pu_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pu_CSVL")
        else:
            self.jb1pu_CSVL_branch.SetAddress(<void*>&self.jb1pu_CSVL_value)

        #print "making jb1rawf"
        self.jb1rawf_branch = the_tree.GetBranch("jb1rawf")
        #if not self.jb1rawf_branch and "jb1rawf" not in self.complained:
        if not self.jb1rawf_branch and "jb1rawf":
            warnings.warn( "EMuMuTree: Expected branch jb1rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1rawf")
        else:
            self.jb1rawf_branch.SetAddress(<void*>&self.jb1rawf_value)

        #print "making jb1rawf_CSVL"
        self.jb1rawf_CSVL_branch = the_tree.GetBranch("jb1rawf_CSVL")
        #if not self.jb1rawf_CSVL_branch and "jb1rawf_CSVL" not in self.complained:
        if not self.jb1rawf_CSVL_branch and "jb1rawf_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb1rawf_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1rawf_CSVL")
        else:
            self.jb1rawf_CSVL_branch.SetAddress(<void*>&self.jb1rawf_CSVL_value)

        #print "making jb2csv"
        self.jb2csv_branch = the_tree.GetBranch("jb2csv")
        #if not self.jb2csv_branch and "jb2csv" not in self.complained:
        if not self.jb2csv_branch and "jb2csv":
            warnings.warn( "EMuMuTree: Expected branch jb2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csv")
        else:
            self.jb2csv_branch.SetAddress(<void*>&self.jb2csv_value)

        #print "making jb2csv_CSVL"
        self.jb2csv_CSVL_branch = the_tree.GetBranch("jb2csv_CSVL")
        #if not self.jb2csv_CSVL_branch and "jb2csv_CSVL" not in self.complained:
        if not self.jb2csv_CSVL_branch and "jb2csv_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb2csv_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csv_CSVL")
        else:
            self.jb2csv_CSVL_branch.SetAddress(<void*>&self.jb2csv_CSVL_value)

        #print "making jb2eta"
        self.jb2eta_branch = the_tree.GetBranch("jb2eta")
        #if not self.jb2eta_branch and "jb2eta" not in self.complained:
        if not self.jb2eta_branch and "jb2eta":
            warnings.warn( "EMuMuTree: Expected branch jb2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta")
        else:
            self.jb2eta_branch.SetAddress(<void*>&self.jb2eta_value)

        #print "making jb2eta_CSVL"
        self.jb2eta_CSVL_branch = the_tree.GetBranch("jb2eta_CSVL")
        #if not self.jb2eta_CSVL_branch and "jb2eta_CSVL" not in self.complained:
        if not self.jb2eta_CSVL_branch and "jb2eta_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb2eta_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_CSVL")
        else:
            self.jb2eta_CSVL_branch.SetAddress(<void*>&self.jb2eta_CSVL_value)

        #print "making jb2hadronflavor"
        self.jb2hadronflavor_branch = the_tree.GetBranch("jb2hadronflavor")
        #if not self.jb2hadronflavor_branch and "jb2hadronflavor" not in self.complained:
        if not self.jb2hadronflavor_branch and "jb2hadronflavor":
            warnings.warn( "EMuMuTree: Expected branch jb2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor")
        else:
            self.jb2hadronflavor_branch.SetAddress(<void*>&self.jb2hadronflavor_value)

        #print "making jb2hadronflavor_CSVL"
        self.jb2hadronflavor_CSVL_branch = the_tree.GetBranch("jb2hadronflavor_CSVL")
        #if not self.jb2hadronflavor_CSVL_branch and "jb2hadronflavor_CSVL" not in self.complained:
        if not self.jb2hadronflavor_CSVL_branch and "jb2hadronflavor_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb2hadronflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_CSVL")
        else:
            self.jb2hadronflavor_CSVL_branch.SetAddress(<void*>&self.jb2hadronflavor_CSVL_value)

        #print "making jb2partonflavor"
        self.jb2partonflavor_branch = the_tree.GetBranch("jb2partonflavor")
        #if not self.jb2partonflavor_branch and "jb2partonflavor" not in self.complained:
        if not self.jb2partonflavor_branch and "jb2partonflavor":
            warnings.warn( "EMuMuTree: Expected branch jb2partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2partonflavor")
        else:
            self.jb2partonflavor_branch.SetAddress(<void*>&self.jb2partonflavor_value)

        #print "making jb2partonflavor_CSVL"
        self.jb2partonflavor_CSVL_branch = the_tree.GetBranch("jb2partonflavor_CSVL")
        #if not self.jb2partonflavor_CSVL_branch and "jb2partonflavor_CSVL" not in self.complained:
        if not self.jb2partonflavor_CSVL_branch and "jb2partonflavor_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb2partonflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2partonflavor_CSVL")
        else:
            self.jb2partonflavor_CSVL_branch.SetAddress(<void*>&self.jb2partonflavor_CSVL_value)

        #print "making jb2phi"
        self.jb2phi_branch = the_tree.GetBranch("jb2phi")
        #if not self.jb2phi_branch and "jb2phi" not in self.complained:
        if not self.jb2phi_branch and "jb2phi":
            warnings.warn( "EMuMuTree: Expected branch jb2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi")
        else:
            self.jb2phi_branch.SetAddress(<void*>&self.jb2phi_value)

        #print "making jb2phi_CSVL"
        self.jb2phi_CSVL_branch = the_tree.GetBranch("jb2phi_CSVL")
        #if not self.jb2phi_CSVL_branch and "jb2phi_CSVL" not in self.complained:
        if not self.jb2phi_CSVL_branch and "jb2phi_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb2phi_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_CSVL")
        else:
            self.jb2phi_CSVL_branch.SetAddress(<void*>&self.jb2phi_CSVL_value)

        #print "making jb2pt"
        self.jb2pt_branch = the_tree.GetBranch("jb2pt")
        #if not self.jb2pt_branch and "jb2pt" not in self.complained:
        if not self.jb2pt_branch and "jb2pt":
            warnings.warn( "EMuMuTree: Expected branch jb2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt")
        else:
            self.jb2pt_branch.SetAddress(<void*>&self.jb2pt_value)

        #print "making jb2ptDown"
        self.jb2ptDown_branch = the_tree.GetBranch("jb2ptDown")
        #if not self.jb2ptDown_branch and "jb2ptDown" not in self.complained:
        if not self.jb2ptDown_branch and "jb2ptDown":
            warnings.warn( "EMuMuTree: Expected branch jb2ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptDown")
        else:
            self.jb2ptDown_branch.SetAddress(<void*>&self.jb2ptDown_value)

        #print "making jb2ptDown_CSVL"
        self.jb2ptDown_CSVL_branch = the_tree.GetBranch("jb2ptDown_CSVL")
        #if not self.jb2ptDown_CSVL_branch and "jb2ptDown_CSVL" not in self.complained:
        if not self.jb2ptDown_CSVL_branch and "jb2ptDown_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb2ptDown_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptDown_CSVL")
        else:
            self.jb2ptDown_CSVL_branch.SetAddress(<void*>&self.jb2ptDown_CSVL_value)

        #print "making jb2ptUp"
        self.jb2ptUp_branch = the_tree.GetBranch("jb2ptUp")
        #if not self.jb2ptUp_branch and "jb2ptUp" not in self.complained:
        if not self.jb2ptUp_branch and "jb2ptUp":
            warnings.warn( "EMuMuTree: Expected branch jb2ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptUp")
        else:
            self.jb2ptUp_branch.SetAddress(<void*>&self.jb2ptUp_value)

        #print "making jb2ptUp_CSVL"
        self.jb2ptUp_CSVL_branch = the_tree.GetBranch("jb2ptUp_CSVL")
        #if not self.jb2ptUp_CSVL_branch and "jb2ptUp_CSVL" not in self.complained:
        if not self.jb2ptUp_CSVL_branch and "jb2ptUp_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb2ptUp_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptUp_CSVL")
        else:
            self.jb2ptUp_CSVL_branch.SetAddress(<void*>&self.jb2ptUp_CSVL_value)

        #print "making jb2pt_CSVL"
        self.jb2pt_CSVL_branch = the_tree.GetBranch("jb2pt_CSVL")
        #if not self.jb2pt_CSVL_branch and "jb2pt_CSVL" not in self.complained:
        if not self.jb2pt_CSVL_branch and "jb2pt_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb2pt_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_CSVL")
        else:
            self.jb2pt_CSVL_branch.SetAddress(<void*>&self.jb2pt_CSVL_value)

        #print "making jb2pu"
        self.jb2pu_branch = the_tree.GetBranch("jb2pu")
        #if not self.jb2pu_branch and "jb2pu" not in self.complained:
        if not self.jb2pu_branch and "jb2pu":
            warnings.warn( "EMuMuTree: Expected branch jb2pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pu")
        else:
            self.jb2pu_branch.SetAddress(<void*>&self.jb2pu_value)

        #print "making jb2pu_CSVL"
        self.jb2pu_CSVL_branch = the_tree.GetBranch("jb2pu_CSVL")
        #if not self.jb2pu_CSVL_branch and "jb2pu_CSVL" not in self.complained:
        if not self.jb2pu_CSVL_branch and "jb2pu_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb2pu_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pu_CSVL")
        else:
            self.jb2pu_CSVL_branch.SetAddress(<void*>&self.jb2pu_CSVL_value)

        #print "making jb2rawf"
        self.jb2rawf_branch = the_tree.GetBranch("jb2rawf")
        #if not self.jb2rawf_branch and "jb2rawf" not in self.complained:
        if not self.jb2rawf_branch and "jb2rawf":
            warnings.warn( "EMuMuTree: Expected branch jb2rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2rawf")
        else:
            self.jb2rawf_branch.SetAddress(<void*>&self.jb2rawf_value)

        #print "making jb2rawf_CSVL"
        self.jb2rawf_CSVL_branch = the_tree.GetBranch("jb2rawf_CSVL")
        #if not self.jb2rawf_CSVL_branch and "jb2rawf_CSVL" not in self.complained:
        if not self.jb2rawf_CSVL_branch and "jb2rawf_CSVL":
            warnings.warn( "EMuMuTree: Expected branch jb2rawf_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2rawf_CSVL")
        else:
            self.jb2rawf_CSVL_branch.SetAddress(<void*>&self.jb2rawf_CSVL_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "EMuMuTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "EMuMuTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EMuMuTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making m1AbsEta"
        self.m1AbsEta_branch = the_tree.GetBranch("m1AbsEta")
        #if not self.m1AbsEta_branch and "m1AbsEta" not in self.complained:
        if not self.m1AbsEta_branch and "m1AbsEta":
            warnings.warn( "EMuMuTree: Expected branch m1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1AbsEta")
        else:
            self.m1AbsEta_branch.SetAddress(<void*>&self.m1AbsEta_value)

        #print "making m1BestTrackType"
        self.m1BestTrackType_branch = the_tree.GetBranch("m1BestTrackType")
        #if not self.m1BestTrackType_branch and "m1BestTrackType" not in self.complained:
        if not self.m1BestTrackType_branch and "m1BestTrackType":
            warnings.warn( "EMuMuTree: Expected branch m1BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1BestTrackType")
        else:
            self.m1BestTrackType_branch.SetAddress(<void*>&self.m1BestTrackType_value)

        #print "making m1Charge"
        self.m1Charge_branch = the_tree.GetBranch("m1Charge")
        #if not self.m1Charge_branch and "m1Charge" not in self.complained:
        if not self.m1Charge_branch and "m1Charge":
            warnings.warn( "EMuMuTree: Expected branch m1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Charge")
        else:
            self.m1Charge_branch.SetAddress(<void*>&self.m1Charge_value)

        #print "making m1Chi2LocalPosition"
        self.m1Chi2LocalPosition_branch = the_tree.GetBranch("m1Chi2LocalPosition")
        #if not self.m1Chi2LocalPosition_branch and "m1Chi2LocalPosition" not in self.complained:
        if not self.m1Chi2LocalPosition_branch and "m1Chi2LocalPosition":
            warnings.warn( "EMuMuTree: Expected branch m1Chi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Chi2LocalPosition")
        else:
            self.m1Chi2LocalPosition_branch.SetAddress(<void*>&self.m1Chi2LocalPosition_value)

        #print "making m1ComesFromHiggs"
        self.m1ComesFromHiggs_branch = the_tree.GetBranch("m1ComesFromHiggs")
        #if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs" not in self.complained:
        if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs":
            warnings.warn( "EMuMuTree: Expected branch m1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ComesFromHiggs")
        else:
            self.m1ComesFromHiggs_branch.SetAddress(<void*>&self.m1ComesFromHiggs_value)

        #print "making m1DPhiToPfMet_type1"
        self.m1DPhiToPfMet_type1_branch = the_tree.GetBranch("m1DPhiToPfMet_type1")
        #if not self.m1DPhiToPfMet_type1_branch and "m1DPhiToPfMet_type1" not in self.complained:
        if not self.m1DPhiToPfMet_type1_branch and "m1DPhiToPfMet_type1":
            warnings.warn( "EMuMuTree: Expected branch m1DPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_type1")
        else:
            self.m1DPhiToPfMet_type1_branch.SetAddress(<void*>&self.m1DPhiToPfMet_type1_value)

        #print "making m1EcalIsoDR03"
        self.m1EcalIsoDR03_branch = the_tree.GetBranch("m1EcalIsoDR03")
        #if not self.m1EcalIsoDR03_branch and "m1EcalIsoDR03" not in self.complained:
        if not self.m1EcalIsoDR03_branch and "m1EcalIsoDR03":
            warnings.warn( "EMuMuTree: Expected branch m1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EcalIsoDR03")
        else:
            self.m1EcalIsoDR03_branch.SetAddress(<void*>&self.m1EcalIsoDR03_value)

        #print "making m1EffectiveArea2011"
        self.m1EffectiveArea2011_branch = the_tree.GetBranch("m1EffectiveArea2011")
        #if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011" not in self.complained:
        if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011":
            warnings.warn( "EMuMuTree: Expected branch m1EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2011")
        else:
            self.m1EffectiveArea2011_branch.SetAddress(<void*>&self.m1EffectiveArea2011_value)

        #print "making m1EffectiveArea2012"
        self.m1EffectiveArea2012_branch = the_tree.GetBranch("m1EffectiveArea2012")
        #if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012" not in self.complained:
        if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012":
            warnings.warn( "EMuMuTree: Expected branch m1EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2012")
        else:
            self.m1EffectiveArea2012_branch.SetAddress(<void*>&self.m1EffectiveArea2012_value)

        #print "making m1ErsatzGenEta"
        self.m1ErsatzGenEta_branch = the_tree.GetBranch("m1ErsatzGenEta")
        #if not self.m1ErsatzGenEta_branch and "m1ErsatzGenEta" not in self.complained:
        if not self.m1ErsatzGenEta_branch and "m1ErsatzGenEta":
            warnings.warn( "EMuMuTree: Expected branch m1ErsatzGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenEta")
        else:
            self.m1ErsatzGenEta_branch.SetAddress(<void*>&self.m1ErsatzGenEta_value)

        #print "making m1ErsatzGenM"
        self.m1ErsatzGenM_branch = the_tree.GetBranch("m1ErsatzGenM")
        #if not self.m1ErsatzGenM_branch and "m1ErsatzGenM" not in self.complained:
        if not self.m1ErsatzGenM_branch and "m1ErsatzGenM":
            warnings.warn( "EMuMuTree: Expected branch m1ErsatzGenM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenM")
        else:
            self.m1ErsatzGenM_branch.SetAddress(<void*>&self.m1ErsatzGenM_value)

        #print "making m1ErsatzGenPhi"
        self.m1ErsatzGenPhi_branch = the_tree.GetBranch("m1ErsatzGenPhi")
        #if not self.m1ErsatzGenPhi_branch and "m1ErsatzGenPhi" not in self.complained:
        if not self.m1ErsatzGenPhi_branch and "m1ErsatzGenPhi":
            warnings.warn( "EMuMuTree: Expected branch m1ErsatzGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenPhi")
        else:
            self.m1ErsatzGenPhi_branch.SetAddress(<void*>&self.m1ErsatzGenPhi_value)

        #print "making m1ErsatzGenpT"
        self.m1ErsatzGenpT_branch = the_tree.GetBranch("m1ErsatzGenpT")
        #if not self.m1ErsatzGenpT_branch and "m1ErsatzGenpT" not in self.complained:
        if not self.m1ErsatzGenpT_branch and "m1ErsatzGenpT":
            warnings.warn( "EMuMuTree: Expected branch m1ErsatzGenpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenpT")
        else:
            self.m1ErsatzGenpT_branch.SetAddress(<void*>&self.m1ErsatzGenpT_value)

        #print "making m1ErsatzGenpX"
        self.m1ErsatzGenpX_branch = the_tree.GetBranch("m1ErsatzGenpX")
        #if not self.m1ErsatzGenpX_branch and "m1ErsatzGenpX" not in self.complained:
        if not self.m1ErsatzGenpX_branch and "m1ErsatzGenpX":
            warnings.warn( "EMuMuTree: Expected branch m1ErsatzGenpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenpX")
        else:
            self.m1ErsatzGenpX_branch.SetAddress(<void*>&self.m1ErsatzGenpX_value)

        #print "making m1ErsatzGenpY"
        self.m1ErsatzGenpY_branch = the_tree.GetBranch("m1ErsatzGenpY")
        #if not self.m1ErsatzGenpY_branch and "m1ErsatzGenpY" not in self.complained:
        if not self.m1ErsatzGenpY_branch and "m1ErsatzGenpY":
            warnings.warn( "EMuMuTree: Expected branch m1ErsatzGenpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenpY")
        else:
            self.m1ErsatzGenpY_branch.SetAddress(<void*>&self.m1ErsatzGenpY_value)

        #print "making m1ErsatzVispX"
        self.m1ErsatzVispX_branch = the_tree.GetBranch("m1ErsatzVispX")
        #if not self.m1ErsatzVispX_branch and "m1ErsatzVispX" not in self.complained:
        if not self.m1ErsatzVispX_branch and "m1ErsatzVispX":
            warnings.warn( "EMuMuTree: Expected branch m1ErsatzVispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzVispX")
        else:
            self.m1ErsatzVispX_branch.SetAddress(<void*>&self.m1ErsatzVispX_value)

        #print "making m1ErsatzVispY"
        self.m1ErsatzVispY_branch = the_tree.GetBranch("m1ErsatzVispY")
        #if not self.m1ErsatzVispY_branch and "m1ErsatzVispY" not in self.complained:
        if not self.m1ErsatzVispY_branch and "m1ErsatzVispY":
            warnings.warn( "EMuMuTree: Expected branch m1ErsatzVispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzVispY")
        else:
            self.m1ErsatzVispY_branch.SetAddress(<void*>&self.m1ErsatzVispY_value)

        #print "making m1Eta"
        self.m1Eta_branch = the_tree.GetBranch("m1Eta")
        #if not self.m1Eta_branch and "m1Eta" not in self.complained:
        if not self.m1Eta_branch and "m1Eta":
            warnings.warn( "EMuMuTree: Expected branch m1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta")
        else:
            self.m1Eta_branch.SetAddress(<void*>&self.m1Eta_value)

        #print "making m1Eta_MuonEnDown"
        self.m1Eta_MuonEnDown_branch = the_tree.GetBranch("m1Eta_MuonEnDown")
        #if not self.m1Eta_MuonEnDown_branch and "m1Eta_MuonEnDown" not in self.complained:
        if not self.m1Eta_MuonEnDown_branch and "m1Eta_MuonEnDown":
            warnings.warn( "EMuMuTree: Expected branch m1Eta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta_MuonEnDown")
        else:
            self.m1Eta_MuonEnDown_branch.SetAddress(<void*>&self.m1Eta_MuonEnDown_value)

        #print "making m1Eta_MuonEnUp"
        self.m1Eta_MuonEnUp_branch = the_tree.GetBranch("m1Eta_MuonEnUp")
        #if not self.m1Eta_MuonEnUp_branch and "m1Eta_MuonEnUp" not in self.complained:
        if not self.m1Eta_MuonEnUp_branch and "m1Eta_MuonEnUp":
            warnings.warn( "EMuMuTree: Expected branch m1Eta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta_MuonEnUp")
        else:
            self.m1Eta_MuonEnUp_branch.SetAddress(<void*>&self.m1Eta_MuonEnUp_value)

        #print "making m1GenCharge"
        self.m1GenCharge_branch = the_tree.GetBranch("m1GenCharge")
        #if not self.m1GenCharge_branch and "m1GenCharge" not in self.complained:
        if not self.m1GenCharge_branch and "m1GenCharge":
            warnings.warn( "EMuMuTree: Expected branch m1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenCharge")
        else:
            self.m1GenCharge_branch.SetAddress(<void*>&self.m1GenCharge_value)

        #print "making m1GenDirectPromptTauDecayFinalState"
        self.m1GenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("m1GenDirectPromptTauDecayFinalState")
        #if not self.m1GenDirectPromptTauDecayFinalState_branch and "m1GenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.m1GenDirectPromptTauDecayFinalState_branch and "m1GenDirectPromptTauDecayFinalState":
            warnings.warn( "EMuMuTree: Expected branch m1GenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenDirectPromptTauDecayFinalState")
        else:
            self.m1GenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.m1GenDirectPromptTauDecayFinalState_value)

        #print "making m1GenEnergy"
        self.m1GenEnergy_branch = the_tree.GetBranch("m1GenEnergy")
        #if not self.m1GenEnergy_branch and "m1GenEnergy" not in self.complained:
        if not self.m1GenEnergy_branch and "m1GenEnergy":
            warnings.warn( "EMuMuTree: Expected branch m1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEnergy")
        else:
            self.m1GenEnergy_branch.SetAddress(<void*>&self.m1GenEnergy_value)

        #print "making m1GenEta"
        self.m1GenEta_branch = the_tree.GetBranch("m1GenEta")
        #if not self.m1GenEta_branch and "m1GenEta" not in self.complained:
        if not self.m1GenEta_branch and "m1GenEta":
            warnings.warn( "EMuMuTree: Expected branch m1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEta")
        else:
            self.m1GenEta_branch.SetAddress(<void*>&self.m1GenEta_value)

        #print "making m1GenIsPrompt"
        self.m1GenIsPrompt_branch = the_tree.GetBranch("m1GenIsPrompt")
        #if not self.m1GenIsPrompt_branch and "m1GenIsPrompt" not in self.complained:
        if not self.m1GenIsPrompt_branch and "m1GenIsPrompt":
            warnings.warn( "EMuMuTree: Expected branch m1GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenIsPrompt")
        else:
            self.m1GenIsPrompt_branch.SetAddress(<void*>&self.m1GenIsPrompt_value)

        #print "making m1GenMotherPdgId"
        self.m1GenMotherPdgId_branch = the_tree.GetBranch("m1GenMotherPdgId")
        #if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId" not in self.complained:
        if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId":
            warnings.warn( "EMuMuTree: Expected branch m1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenMotherPdgId")
        else:
            self.m1GenMotherPdgId_branch.SetAddress(<void*>&self.m1GenMotherPdgId_value)

        #print "making m1GenParticle"
        self.m1GenParticle_branch = the_tree.GetBranch("m1GenParticle")
        #if not self.m1GenParticle_branch and "m1GenParticle" not in self.complained:
        if not self.m1GenParticle_branch and "m1GenParticle":
            warnings.warn( "EMuMuTree: Expected branch m1GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenParticle")
        else:
            self.m1GenParticle_branch.SetAddress(<void*>&self.m1GenParticle_value)

        #print "making m1GenPdgId"
        self.m1GenPdgId_branch = the_tree.GetBranch("m1GenPdgId")
        #if not self.m1GenPdgId_branch and "m1GenPdgId" not in self.complained:
        if not self.m1GenPdgId_branch and "m1GenPdgId":
            warnings.warn( "EMuMuTree: Expected branch m1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPdgId")
        else:
            self.m1GenPdgId_branch.SetAddress(<void*>&self.m1GenPdgId_value)

        #print "making m1GenPhi"
        self.m1GenPhi_branch = the_tree.GetBranch("m1GenPhi")
        #if not self.m1GenPhi_branch and "m1GenPhi" not in self.complained:
        if not self.m1GenPhi_branch and "m1GenPhi":
            warnings.warn( "EMuMuTree: Expected branch m1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPhi")
        else:
            self.m1GenPhi_branch.SetAddress(<void*>&self.m1GenPhi_value)

        #print "making m1GenPrompt"
        self.m1GenPrompt_branch = the_tree.GetBranch("m1GenPrompt")
        #if not self.m1GenPrompt_branch and "m1GenPrompt" not in self.complained:
        if not self.m1GenPrompt_branch and "m1GenPrompt":
            warnings.warn( "EMuMuTree: Expected branch m1GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPrompt")
        else:
            self.m1GenPrompt_branch.SetAddress(<void*>&self.m1GenPrompt_value)

        #print "making m1GenPromptFinalState"
        self.m1GenPromptFinalState_branch = the_tree.GetBranch("m1GenPromptFinalState")
        #if not self.m1GenPromptFinalState_branch and "m1GenPromptFinalState" not in self.complained:
        if not self.m1GenPromptFinalState_branch and "m1GenPromptFinalState":
            warnings.warn( "EMuMuTree: Expected branch m1GenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPromptFinalState")
        else:
            self.m1GenPromptFinalState_branch.SetAddress(<void*>&self.m1GenPromptFinalState_value)

        #print "making m1GenPromptTauDecay"
        self.m1GenPromptTauDecay_branch = the_tree.GetBranch("m1GenPromptTauDecay")
        #if not self.m1GenPromptTauDecay_branch and "m1GenPromptTauDecay" not in self.complained:
        if not self.m1GenPromptTauDecay_branch and "m1GenPromptTauDecay":
            warnings.warn( "EMuMuTree: Expected branch m1GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPromptTauDecay")
        else:
            self.m1GenPromptTauDecay_branch.SetAddress(<void*>&self.m1GenPromptTauDecay_value)

        #print "making m1GenPt"
        self.m1GenPt_branch = the_tree.GetBranch("m1GenPt")
        #if not self.m1GenPt_branch and "m1GenPt" not in self.complained:
        if not self.m1GenPt_branch and "m1GenPt":
            warnings.warn( "EMuMuTree: Expected branch m1GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPt")
        else:
            self.m1GenPt_branch.SetAddress(<void*>&self.m1GenPt_value)

        #print "making m1GenTauDecay"
        self.m1GenTauDecay_branch = the_tree.GetBranch("m1GenTauDecay")
        #if not self.m1GenTauDecay_branch and "m1GenTauDecay" not in self.complained:
        if not self.m1GenTauDecay_branch and "m1GenTauDecay":
            warnings.warn( "EMuMuTree: Expected branch m1GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenTauDecay")
        else:
            self.m1GenTauDecay_branch.SetAddress(<void*>&self.m1GenTauDecay_value)

        #print "making m1GenVZ"
        self.m1GenVZ_branch = the_tree.GetBranch("m1GenVZ")
        #if not self.m1GenVZ_branch and "m1GenVZ" not in self.complained:
        if not self.m1GenVZ_branch and "m1GenVZ":
            warnings.warn( "EMuMuTree: Expected branch m1GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenVZ")
        else:
            self.m1GenVZ_branch.SetAddress(<void*>&self.m1GenVZ_value)

        #print "making m1GenVtxPVMatch"
        self.m1GenVtxPVMatch_branch = the_tree.GetBranch("m1GenVtxPVMatch")
        #if not self.m1GenVtxPVMatch_branch and "m1GenVtxPVMatch" not in self.complained:
        if not self.m1GenVtxPVMatch_branch and "m1GenVtxPVMatch":
            warnings.warn( "EMuMuTree: Expected branch m1GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenVtxPVMatch")
        else:
            self.m1GenVtxPVMatch_branch.SetAddress(<void*>&self.m1GenVtxPVMatch_value)

        #print "making m1HcalIsoDR03"
        self.m1HcalIsoDR03_branch = the_tree.GetBranch("m1HcalIsoDR03")
        #if not self.m1HcalIsoDR03_branch and "m1HcalIsoDR03" not in self.complained:
        if not self.m1HcalIsoDR03_branch and "m1HcalIsoDR03":
            warnings.warn( "EMuMuTree: Expected branch m1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1HcalIsoDR03")
        else:
            self.m1HcalIsoDR03_branch.SetAddress(<void*>&self.m1HcalIsoDR03_value)

        #print "making m1IP3D"
        self.m1IP3D_branch = the_tree.GetBranch("m1IP3D")
        #if not self.m1IP3D_branch and "m1IP3D" not in self.complained:
        if not self.m1IP3D_branch and "m1IP3D":
            warnings.warn( "EMuMuTree: Expected branch m1IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3D")
        else:
            self.m1IP3D_branch.SetAddress(<void*>&self.m1IP3D_value)

        #print "making m1IP3DErr"
        self.m1IP3DErr_branch = the_tree.GetBranch("m1IP3DErr")
        #if not self.m1IP3DErr_branch and "m1IP3DErr" not in self.complained:
        if not self.m1IP3DErr_branch and "m1IP3DErr":
            warnings.warn( "EMuMuTree: Expected branch m1IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3DErr")
        else:
            self.m1IP3DErr_branch.SetAddress(<void*>&self.m1IP3DErr_value)

        #print "making m1IsGlobal"
        self.m1IsGlobal_branch = the_tree.GetBranch("m1IsGlobal")
        #if not self.m1IsGlobal_branch and "m1IsGlobal" not in self.complained:
        if not self.m1IsGlobal_branch and "m1IsGlobal":
            warnings.warn( "EMuMuTree: Expected branch m1IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsGlobal")
        else:
            self.m1IsGlobal_branch.SetAddress(<void*>&self.m1IsGlobal_value)

        #print "making m1IsPFMuon"
        self.m1IsPFMuon_branch = the_tree.GetBranch("m1IsPFMuon")
        #if not self.m1IsPFMuon_branch and "m1IsPFMuon" not in self.complained:
        if not self.m1IsPFMuon_branch and "m1IsPFMuon":
            warnings.warn( "EMuMuTree: Expected branch m1IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsPFMuon")
        else:
            self.m1IsPFMuon_branch.SetAddress(<void*>&self.m1IsPFMuon_value)

        #print "making m1IsTracker"
        self.m1IsTracker_branch = the_tree.GetBranch("m1IsTracker")
        #if not self.m1IsTracker_branch and "m1IsTracker" not in self.complained:
        if not self.m1IsTracker_branch and "m1IsTracker":
            warnings.warn( "EMuMuTree: Expected branch m1IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsTracker")
        else:
            self.m1IsTracker_branch.SetAddress(<void*>&self.m1IsTracker_value)

        #print "making m1IsoDB03"
        self.m1IsoDB03_branch = the_tree.GetBranch("m1IsoDB03")
        #if not self.m1IsoDB03_branch and "m1IsoDB03" not in self.complained:
        if not self.m1IsoDB03_branch and "m1IsoDB03":
            warnings.warn( "EMuMuTree: Expected branch m1IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoDB03")
        else:
            self.m1IsoDB03_branch.SetAddress(<void*>&self.m1IsoDB03_value)

        #print "making m1IsoDB04"
        self.m1IsoDB04_branch = the_tree.GetBranch("m1IsoDB04")
        #if not self.m1IsoDB04_branch and "m1IsoDB04" not in self.complained:
        if not self.m1IsoDB04_branch and "m1IsoDB04":
            warnings.warn( "EMuMuTree: Expected branch m1IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoDB04")
        else:
            self.m1IsoDB04_branch.SetAddress(<void*>&self.m1IsoDB04_value)

        #print "making m1IsoMu22Filter"
        self.m1IsoMu22Filter_branch = the_tree.GetBranch("m1IsoMu22Filter")
        #if not self.m1IsoMu22Filter_branch and "m1IsoMu22Filter" not in self.complained:
        if not self.m1IsoMu22Filter_branch and "m1IsoMu22Filter":
            warnings.warn( "EMuMuTree: Expected branch m1IsoMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoMu22Filter")
        else:
            self.m1IsoMu22Filter_branch.SetAddress(<void*>&self.m1IsoMu22Filter_value)

        #print "making m1IsoMu22eta2p1Filter"
        self.m1IsoMu22eta2p1Filter_branch = the_tree.GetBranch("m1IsoMu22eta2p1Filter")
        #if not self.m1IsoMu22eta2p1Filter_branch and "m1IsoMu22eta2p1Filter" not in self.complained:
        if not self.m1IsoMu22eta2p1Filter_branch and "m1IsoMu22eta2p1Filter":
            warnings.warn( "EMuMuTree: Expected branch m1IsoMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoMu22eta2p1Filter")
        else:
            self.m1IsoMu22eta2p1Filter_branch.SetAddress(<void*>&self.m1IsoMu22eta2p1Filter_value)

        #print "making m1IsoMu24Filter"
        self.m1IsoMu24Filter_branch = the_tree.GetBranch("m1IsoMu24Filter")
        #if not self.m1IsoMu24Filter_branch and "m1IsoMu24Filter" not in self.complained:
        if not self.m1IsoMu24Filter_branch and "m1IsoMu24Filter":
            warnings.warn( "EMuMuTree: Expected branch m1IsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoMu24Filter")
        else:
            self.m1IsoMu24Filter_branch.SetAddress(<void*>&self.m1IsoMu24Filter_value)

        #print "making m1IsoMu24eta2p1Filter"
        self.m1IsoMu24eta2p1Filter_branch = the_tree.GetBranch("m1IsoMu24eta2p1Filter")
        #if not self.m1IsoMu24eta2p1Filter_branch and "m1IsoMu24eta2p1Filter" not in self.complained:
        if not self.m1IsoMu24eta2p1Filter_branch and "m1IsoMu24eta2p1Filter":
            warnings.warn( "EMuMuTree: Expected branch m1IsoMu24eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoMu24eta2p1Filter")
        else:
            self.m1IsoMu24eta2p1Filter_branch.SetAddress(<void*>&self.m1IsoMu24eta2p1Filter_value)

        #print "making m1IsoTkMu22Filter"
        self.m1IsoTkMu22Filter_branch = the_tree.GetBranch("m1IsoTkMu22Filter")
        #if not self.m1IsoTkMu22Filter_branch and "m1IsoTkMu22Filter" not in self.complained:
        if not self.m1IsoTkMu22Filter_branch and "m1IsoTkMu22Filter":
            warnings.warn( "EMuMuTree: Expected branch m1IsoTkMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoTkMu22Filter")
        else:
            self.m1IsoTkMu22Filter_branch.SetAddress(<void*>&self.m1IsoTkMu22Filter_value)

        #print "making m1IsoTkMu22eta2p1Filter"
        self.m1IsoTkMu22eta2p1Filter_branch = the_tree.GetBranch("m1IsoTkMu22eta2p1Filter")
        #if not self.m1IsoTkMu22eta2p1Filter_branch and "m1IsoTkMu22eta2p1Filter" not in self.complained:
        if not self.m1IsoTkMu22eta2p1Filter_branch and "m1IsoTkMu22eta2p1Filter":
            warnings.warn( "EMuMuTree: Expected branch m1IsoTkMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoTkMu22eta2p1Filter")
        else:
            self.m1IsoTkMu22eta2p1Filter_branch.SetAddress(<void*>&self.m1IsoTkMu22eta2p1Filter_value)

        #print "making m1IsoTkMu24Filter"
        self.m1IsoTkMu24Filter_branch = the_tree.GetBranch("m1IsoTkMu24Filter")
        #if not self.m1IsoTkMu24Filter_branch and "m1IsoTkMu24Filter" not in self.complained:
        if not self.m1IsoTkMu24Filter_branch and "m1IsoTkMu24Filter":
            warnings.warn( "EMuMuTree: Expected branch m1IsoTkMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoTkMu24Filter")
        else:
            self.m1IsoTkMu24Filter_branch.SetAddress(<void*>&self.m1IsoTkMu24Filter_value)

        #print "making m1IsoTkMu24eta2p1Filter"
        self.m1IsoTkMu24eta2p1Filter_branch = the_tree.GetBranch("m1IsoTkMu24eta2p1Filter")
        #if not self.m1IsoTkMu24eta2p1Filter_branch and "m1IsoTkMu24eta2p1Filter" not in self.complained:
        if not self.m1IsoTkMu24eta2p1Filter_branch and "m1IsoTkMu24eta2p1Filter":
            warnings.warn( "EMuMuTree: Expected branch m1IsoTkMu24eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoTkMu24eta2p1Filter")
        else:
            self.m1IsoTkMu24eta2p1Filter_branch.SetAddress(<void*>&self.m1IsoTkMu24eta2p1Filter_value)

        #print "making m1JetArea"
        self.m1JetArea_branch = the_tree.GetBranch("m1JetArea")
        #if not self.m1JetArea_branch and "m1JetArea" not in self.complained:
        if not self.m1JetArea_branch and "m1JetArea":
            warnings.warn( "EMuMuTree: Expected branch m1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetArea")
        else:
            self.m1JetArea_branch.SetAddress(<void*>&self.m1JetArea_value)

        #print "making m1JetBtag"
        self.m1JetBtag_branch = the_tree.GetBranch("m1JetBtag")
        #if not self.m1JetBtag_branch and "m1JetBtag" not in self.complained:
        if not self.m1JetBtag_branch and "m1JetBtag":
            warnings.warn( "EMuMuTree: Expected branch m1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetBtag")
        else:
            self.m1JetBtag_branch.SetAddress(<void*>&self.m1JetBtag_value)

        #print "making m1JetEtaEtaMoment"
        self.m1JetEtaEtaMoment_branch = the_tree.GetBranch("m1JetEtaEtaMoment")
        #if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment" not in self.complained:
        if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment":
            warnings.warn( "EMuMuTree: Expected branch m1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaEtaMoment")
        else:
            self.m1JetEtaEtaMoment_branch.SetAddress(<void*>&self.m1JetEtaEtaMoment_value)

        #print "making m1JetEtaPhiMoment"
        self.m1JetEtaPhiMoment_branch = the_tree.GetBranch("m1JetEtaPhiMoment")
        #if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment" not in self.complained:
        if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment":
            warnings.warn( "EMuMuTree: Expected branch m1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiMoment")
        else:
            self.m1JetEtaPhiMoment_branch.SetAddress(<void*>&self.m1JetEtaPhiMoment_value)

        #print "making m1JetEtaPhiSpread"
        self.m1JetEtaPhiSpread_branch = the_tree.GetBranch("m1JetEtaPhiSpread")
        #if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread" not in self.complained:
        if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread":
            warnings.warn( "EMuMuTree: Expected branch m1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiSpread")
        else:
            self.m1JetEtaPhiSpread_branch.SetAddress(<void*>&self.m1JetEtaPhiSpread_value)

        #print "making m1JetHadronFlavour"
        self.m1JetHadronFlavour_branch = the_tree.GetBranch("m1JetHadronFlavour")
        #if not self.m1JetHadronFlavour_branch and "m1JetHadronFlavour" not in self.complained:
        if not self.m1JetHadronFlavour_branch and "m1JetHadronFlavour":
            warnings.warn( "EMuMuTree: Expected branch m1JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetHadronFlavour")
        else:
            self.m1JetHadronFlavour_branch.SetAddress(<void*>&self.m1JetHadronFlavour_value)

        #print "making m1JetPFCISVBtag"
        self.m1JetPFCISVBtag_branch = the_tree.GetBranch("m1JetPFCISVBtag")
        #if not self.m1JetPFCISVBtag_branch and "m1JetPFCISVBtag" not in self.complained:
        if not self.m1JetPFCISVBtag_branch and "m1JetPFCISVBtag":
            warnings.warn( "EMuMuTree: Expected branch m1JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPFCISVBtag")
        else:
            self.m1JetPFCISVBtag_branch.SetAddress(<void*>&self.m1JetPFCISVBtag_value)

        #print "making m1JetPartonFlavour"
        self.m1JetPartonFlavour_branch = the_tree.GetBranch("m1JetPartonFlavour")
        #if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour" not in self.complained:
        if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour":
            warnings.warn( "EMuMuTree: Expected branch m1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPartonFlavour")
        else:
            self.m1JetPartonFlavour_branch.SetAddress(<void*>&self.m1JetPartonFlavour_value)

        #print "making m1JetPhiPhiMoment"
        self.m1JetPhiPhiMoment_branch = the_tree.GetBranch("m1JetPhiPhiMoment")
        #if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment" not in self.complained:
        if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment":
            warnings.warn( "EMuMuTree: Expected branch m1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPhiPhiMoment")
        else:
            self.m1JetPhiPhiMoment_branch.SetAddress(<void*>&self.m1JetPhiPhiMoment_value)

        #print "making m1JetPt"
        self.m1JetPt_branch = the_tree.GetBranch("m1JetPt")
        #if not self.m1JetPt_branch and "m1JetPt" not in self.complained:
        if not self.m1JetPt_branch and "m1JetPt":
            warnings.warn( "EMuMuTree: Expected branch m1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPt")
        else:
            self.m1JetPt_branch.SetAddress(<void*>&self.m1JetPt_value)

        #print "making m1LowestMll"
        self.m1LowestMll_branch = the_tree.GetBranch("m1LowestMll")
        #if not self.m1LowestMll_branch and "m1LowestMll" not in self.complained:
        if not self.m1LowestMll_branch and "m1LowestMll":
            warnings.warn( "EMuMuTree: Expected branch m1LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1LowestMll")
        else:
            self.m1LowestMll_branch.SetAddress(<void*>&self.m1LowestMll_value)

        #print "making m1Mass"
        self.m1Mass_branch = the_tree.GetBranch("m1Mass")
        #if not self.m1Mass_branch and "m1Mass" not in self.complained:
        if not self.m1Mass_branch and "m1Mass":
            warnings.warn( "EMuMuTree: Expected branch m1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mass")
        else:
            self.m1Mass_branch.SetAddress(<void*>&self.m1Mass_value)

        #print "making m1MatchedStations"
        self.m1MatchedStations_branch = the_tree.GetBranch("m1MatchedStations")
        #if not self.m1MatchedStations_branch and "m1MatchedStations" not in self.complained:
        if not self.m1MatchedStations_branch and "m1MatchedStations":
            warnings.warn( "EMuMuTree: Expected branch m1MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchedStations")
        else:
            self.m1MatchedStations_branch.SetAddress(<void*>&self.m1MatchedStations_value)

        #print "making m1MatchesDoubleESingleMu"
        self.m1MatchesDoubleESingleMu_branch = the_tree.GetBranch("m1MatchesDoubleESingleMu")
        #if not self.m1MatchesDoubleESingleMu_branch and "m1MatchesDoubleESingleMu" not in self.complained:
        if not self.m1MatchesDoubleESingleMu_branch and "m1MatchesDoubleESingleMu":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesDoubleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleESingleMu")
        else:
            self.m1MatchesDoubleESingleMu_branch.SetAddress(<void*>&self.m1MatchesDoubleESingleMu_value)

        #print "making m1MatchesDoubleMu"
        self.m1MatchesDoubleMu_branch = the_tree.GetBranch("m1MatchesDoubleMu")
        #if not self.m1MatchesDoubleMu_branch and "m1MatchesDoubleMu" not in self.complained:
        if not self.m1MatchesDoubleMu_branch and "m1MatchesDoubleMu":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesDoubleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMu")
        else:
            self.m1MatchesDoubleMu_branch.SetAddress(<void*>&self.m1MatchesDoubleMu_value)

        #print "making m1MatchesDoubleMuSingleE"
        self.m1MatchesDoubleMuSingleE_branch = the_tree.GetBranch("m1MatchesDoubleMuSingleE")
        #if not self.m1MatchesDoubleMuSingleE_branch and "m1MatchesDoubleMuSingleE" not in self.complained:
        if not self.m1MatchesDoubleMuSingleE_branch and "m1MatchesDoubleMuSingleE":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesDoubleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMuSingleE")
        else:
            self.m1MatchesDoubleMuSingleE_branch.SetAddress(<void*>&self.m1MatchesDoubleMuSingleE_value)

        #print "making m1MatchesIsoMu22Path"
        self.m1MatchesIsoMu22Path_branch = the_tree.GetBranch("m1MatchesIsoMu22Path")
        #if not self.m1MatchesIsoMu22Path_branch and "m1MatchesIsoMu22Path" not in self.complained:
        if not self.m1MatchesIsoMu22Path_branch and "m1MatchesIsoMu22Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesIsoMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu22Path")
        else:
            self.m1MatchesIsoMu22Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu22Path_value)

        #print "making m1MatchesIsoMu22eta2p1Path"
        self.m1MatchesIsoMu22eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoMu22eta2p1Path")
        #if not self.m1MatchesIsoMu22eta2p1Path_branch and "m1MatchesIsoMu22eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoMu22eta2p1Path_branch and "m1MatchesIsoMu22eta2p1Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesIsoMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu22eta2p1Path")
        else:
            self.m1MatchesIsoMu22eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu22eta2p1Path_value)

        #print "making m1MatchesIsoMu24Path"
        self.m1MatchesIsoMu24Path_branch = the_tree.GetBranch("m1MatchesIsoMu24Path")
        #if not self.m1MatchesIsoMu24Path_branch and "m1MatchesIsoMu24Path" not in self.complained:
        if not self.m1MatchesIsoMu24Path_branch and "m1MatchesIsoMu24Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24Path")
        else:
            self.m1MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu24Path_value)

        #print "making m1MatchesIsoMu24eta2p1Path"
        self.m1MatchesIsoMu24eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoMu24eta2p1Path")
        #if not self.m1MatchesIsoMu24eta2p1Path_branch and "m1MatchesIsoMu24eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoMu24eta2p1Path_branch and "m1MatchesIsoMu24eta2p1Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesIsoMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24eta2p1Path")
        else:
            self.m1MatchesIsoMu24eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu24eta2p1Path_value)

        #print "making m1MatchesIsoTkMu22Path"
        self.m1MatchesIsoTkMu22Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu22Path")
        #if not self.m1MatchesIsoTkMu22Path_branch and "m1MatchesIsoTkMu22Path" not in self.complained:
        if not self.m1MatchesIsoTkMu22Path_branch and "m1MatchesIsoTkMu22Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesIsoTkMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu22Path")
        else:
            self.m1MatchesIsoTkMu22Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu22Path_value)

        #print "making m1MatchesIsoTkMu22eta2p1Path"
        self.m1MatchesIsoTkMu22eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu22eta2p1Path")
        #if not self.m1MatchesIsoTkMu22eta2p1Path_branch and "m1MatchesIsoTkMu22eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoTkMu22eta2p1Path_branch and "m1MatchesIsoTkMu22eta2p1Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesIsoTkMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu22eta2p1Path")
        else:
            self.m1MatchesIsoTkMu22eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu22eta2p1Path_value)

        #print "making m1MatchesIsoTkMu24Path"
        self.m1MatchesIsoTkMu24Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu24Path")
        #if not self.m1MatchesIsoTkMu24Path_branch and "m1MatchesIsoTkMu24Path" not in self.complained:
        if not self.m1MatchesIsoTkMu24Path_branch and "m1MatchesIsoTkMu24Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesIsoTkMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu24Path")
        else:
            self.m1MatchesIsoTkMu24Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu24Path_value)

        #print "making m1MatchesIsoTkMu24eta2p1Path"
        self.m1MatchesIsoTkMu24eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu24eta2p1Path")
        #if not self.m1MatchesIsoTkMu24eta2p1Path_branch and "m1MatchesIsoTkMu24eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoTkMu24eta2p1Path_branch and "m1MatchesIsoTkMu24eta2p1Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesIsoTkMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu24eta2p1Path")
        else:
            self.m1MatchesIsoTkMu24eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu24eta2p1Path_value)

        #print "making m1MatchesMu19Tau20Filter"
        self.m1MatchesMu19Tau20Filter_branch = the_tree.GetBranch("m1MatchesMu19Tau20Filter")
        #if not self.m1MatchesMu19Tau20Filter_branch and "m1MatchesMu19Tau20Filter" not in self.complained:
        if not self.m1MatchesMu19Tau20Filter_branch and "m1MatchesMu19Tau20Filter":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu19Tau20Filter")
        else:
            self.m1MatchesMu19Tau20Filter_branch.SetAddress(<void*>&self.m1MatchesMu19Tau20Filter_value)

        #print "making m1MatchesMu19Tau20Path"
        self.m1MatchesMu19Tau20Path_branch = the_tree.GetBranch("m1MatchesMu19Tau20Path")
        #if not self.m1MatchesMu19Tau20Path_branch and "m1MatchesMu19Tau20Path" not in self.complained:
        if not self.m1MatchesMu19Tau20Path_branch and "m1MatchesMu19Tau20Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu19Tau20Path")
        else:
            self.m1MatchesMu19Tau20Path_branch.SetAddress(<void*>&self.m1MatchesMu19Tau20Path_value)

        #print "making m1MatchesMu19Tau20sL1Filter"
        self.m1MatchesMu19Tau20sL1Filter_branch = the_tree.GetBranch("m1MatchesMu19Tau20sL1Filter")
        #if not self.m1MatchesMu19Tau20sL1Filter_branch and "m1MatchesMu19Tau20sL1Filter" not in self.complained:
        if not self.m1MatchesMu19Tau20sL1Filter_branch and "m1MatchesMu19Tau20sL1Filter":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesMu19Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu19Tau20sL1Filter")
        else:
            self.m1MatchesMu19Tau20sL1Filter_branch.SetAddress(<void*>&self.m1MatchesMu19Tau20sL1Filter_value)

        #print "making m1MatchesMu19Tau20sL1Path"
        self.m1MatchesMu19Tau20sL1Path_branch = the_tree.GetBranch("m1MatchesMu19Tau20sL1Path")
        #if not self.m1MatchesMu19Tau20sL1Path_branch and "m1MatchesMu19Tau20sL1Path" not in self.complained:
        if not self.m1MatchesMu19Tau20sL1Path_branch and "m1MatchesMu19Tau20sL1Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesMu19Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu19Tau20sL1Path")
        else:
            self.m1MatchesMu19Tau20sL1Path_branch.SetAddress(<void*>&self.m1MatchesMu19Tau20sL1Path_value)

        #print "making m1MatchesMu21Tau20sL1Filter"
        self.m1MatchesMu21Tau20sL1Filter_branch = the_tree.GetBranch("m1MatchesMu21Tau20sL1Filter")
        #if not self.m1MatchesMu21Tau20sL1Filter_branch and "m1MatchesMu21Tau20sL1Filter" not in self.complained:
        if not self.m1MatchesMu21Tau20sL1Filter_branch and "m1MatchesMu21Tau20sL1Filter":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesMu21Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu21Tau20sL1Filter")
        else:
            self.m1MatchesMu21Tau20sL1Filter_branch.SetAddress(<void*>&self.m1MatchesMu21Tau20sL1Filter_value)

        #print "making m1MatchesMu21Tau20sL1Path"
        self.m1MatchesMu21Tau20sL1Path_branch = the_tree.GetBranch("m1MatchesMu21Tau20sL1Path")
        #if not self.m1MatchesMu21Tau20sL1Path_branch and "m1MatchesMu21Tau20sL1Path" not in self.complained:
        if not self.m1MatchesMu21Tau20sL1Path_branch and "m1MatchesMu21Tau20sL1Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesMu21Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu21Tau20sL1Path")
        else:
            self.m1MatchesMu21Tau20sL1Path_branch.SetAddress(<void*>&self.m1MatchesMu21Tau20sL1Path_value)

        #print "making m1MatchesMu23Ele12DZPath"
        self.m1MatchesMu23Ele12DZPath_branch = the_tree.GetBranch("m1MatchesMu23Ele12DZPath")
        #if not self.m1MatchesMu23Ele12DZPath_branch and "m1MatchesMu23Ele12DZPath" not in self.complained:
        if not self.m1MatchesMu23Ele12DZPath_branch and "m1MatchesMu23Ele12DZPath":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesMu23Ele12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu23Ele12DZPath")
        else:
            self.m1MatchesMu23Ele12DZPath_branch.SetAddress(<void*>&self.m1MatchesMu23Ele12DZPath_value)

        #print "making m1MatchesMu23Ele12Path"
        self.m1MatchesMu23Ele12Path_branch = the_tree.GetBranch("m1MatchesMu23Ele12Path")
        #if not self.m1MatchesMu23Ele12Path_branch and "m1MatchesMu23Ele12Path" not in self.complained:
        if not self.m1MatchesMu23Ele12Path_branch and "m1MatchesMu23Ele12Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesMu23Ele12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu23Ele12Path")
        else:
            self.m1MatchesMu23Ele12Path_branch.SetAddress(<void*>&self.m1MatchesMu23Ele12Path_value)

        #print "making m1MatchesMu8Ele23DZPath"
        self.m1MatchesMu8Ele23DZPath_branch = the_tree.GetBranch("m1MatchesMu8Ele23DZPath")
        #if not self.m1MatchesMu8Ele23DZPath_branch and "m1MatchesMu8Ele23DZPath" not in self.complained:
        if not self.m1MatchesMu8Ele23DZPath_branch and "m1MatchesMu8Ele23DZPath":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesMu8Ele23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele23DZPath")
        else:
            self.m1MatchesMu8Ele23DZPath_branch.SetAddress(<void*>&self.m1MatchesMu8Ele23DZPath_value)

        #print "making m1MatchesMu8Ele23Path"
        self.m1MatchesMu8Ele23Path_branch = the_tree.GetBranch("m1MatchesMu8Ele23Path")
        #if not self.m1MatchesMu8Ele23Path_branch and "m1MatchesMu8Ele23Path" not in self.complained:
        if not self.m1MatchesMu8Ele23Path_branch and "m1MatchesMu8Ele23Path":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesMu8Ele23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele23Path")
        else:
            self.m1MatchesMu8Ele23Path_branch.SetAddress(<void*>&self.m1MatchesMu8Ele23Path_value)

        #print "making m1MatchesSingleESingleMu"
        self.m1MatchesSingleESingleMu_branch = the_tree.GetBranch("m1MatchesSingleESingleMu")
        #if not self.m1MatchesSingleESingleMu_branch and "m1MatchesSingleESingleMu" not in self.complained:
        if not self.m1MatchesSingleESingleMu_branch and "m1MatchesSingleESingleMu":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesSingleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleESingleMu")
        else:
            self.m1MatchesSingleESingleMu_branch.SetAddress(<void*>&self.m1MatchesSingleESingleMu_value)

        #print "making m1MatchesSingleMu"
        self.m1MatchesSingleMu_branch = the_tree.GetBranch("m1MatchesSingleMu")
        #if not self.m1MatchesSingleMu_branch and "m1MatchesSingleMu" not in self.complained:
        if not self.m1MatchesSingleMu_branch and "m1MatchesSingleMu":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesSingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu")
        else:
            self.m1MatchesSingleMu_branch.SetAddress(<void*>&self.m1MatchesSingleMu_value)

        #print "making m1MatchesSingleMuIso20"
        self.m1MatchesSingleMuIso20_branch = the_tree.GetBranch("m1MatchesSingleMuIso20")
        #if not self.m1MatchesSingleMuIso20_branch and "m1MatchesSingleMuIso20" not in self.complained:
        if not self.m1MatchesSingleMuIso20_branch and "m1MatchesSingleMuIso20":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesSingleMuIso20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMuIso20")
        else:
            self.m1MatchesSingleMuIso20_branch.SetAddress(<void*>&self.m1MatchesSingleMuIso20_value)

        #print "making m1MatchesSingleMuIsoTk20"
        self.m1MatchesSingleMuIsoTk20_branch = the_tree.GetBranch("m1MatchesSingleMuIsoTk20")
        #if not self.m1MatchesSingleMuIsoTk20_branch and "m1MatchesSingleMuIsoTk20" not in self.complained:
        if not self.m1MatchesSingleMuIsoTk20_branch and "m1MatchesSingleMuIsoTk20":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesSingleMuIsoTk20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMuIsoTk20")
        else:
            self.m1MatchesSingleMuIsoTk20_branch.SetAddress(<void*>&self.m1MatchesSingleMuIsoTk20_value)

        #print "making m1MatchesSingleMuSingleE"
        self.m1MatchesSingleMuSingleE_branch = the_tree.GetBranch("m1MatchesSingleMuSingleE")
        #if not self.m1MatchesSingleMuSingleE_branch and "m1MatchesSingleMuSingleE" not in self.complained:
        if not self.m1MatchesSingleMuSingleE_branch and "m1MatchesSingleMuSingleE":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesSingleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMuSingleE")
        else:
            self.m1MatchesSingleMuSingleE_branch.SetAddress(<void*>&self.m1MatchesSingleMuSingleE_value)

        #print "making m1MatchesSingleMu_leg1"
        self.m1MatchesSingleMu_leg1_branch = the_tree.GetBranch("m1MatchesSingleMu_leg1")
        #if not self.m1MatchesSingleMu_leg1_branch and "m1MatchesSingleMu_leg1" not in self.complained:
        if not self.m1MatchesSingleMu_leg1_branch and "m1MatchesSingleMu_leg1":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesSingleMu_leg1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu_leg1")
        else:
            self.m1MatchesSingleMu_leg1_branch.SetAddress(<void*>&self.m1MatchesSingleMu_leg1_value)

        #print "making m1MatchesSingleMu_leg1_noiso"
        self.m1MatchesSingleMu_leg1_noiso_branch = the_tree.GetBranch("m1MatchesSingleMu_leg1_noiso")
        #if not self.m1MatchesSingleMu_leg1_noiso_branch and "m1MatchesSingleMu_leg1_noiso" not in self.complained:
        if not self.m1MatchesSingleMu_leg1_noiso_branch and "m1MatchesSingleMu_leg1_noiso":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesSingleMu_leg1_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu_leg1_noiso")
        else:
            self.m1MatchesSingleMu_leg1_noiso_branch.SetAddress(<void*>&self.m1MatchesSingleMu_leg1_noiso_value)

        #print "making m1MatchesSingleMu_leg2"
        self.m1MatchesSingleMu_leg2_branch = the_tree.GetBranch("m1MatchesSingleMu_leg2")
        #if not self.m1MatchesSingleMu_leg2_branch and "m1MatchesSingleMu_leg2" not in self.complained:
        if not self.m1MatchesSingleMu_leg2_branch and "m1MatchesSingleMu_leg2":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesSingleMu_leg2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu_leg2")
        else:
            self.m1MatchesSingleMu_leg2_branch.SetAddress(<void*>&self.m1MatchesSingleMu_leg2_value)

        #print "making m1MatchesSingleMu_leg2_noiso"
        self.m1MatchesSingleMu_leg2_noiso_branch = the_tree.GetBranch("m1MatchesSingleMu_leg2_noiso")
        #if not self.m1MatchesSingleMu_leg2_noiso_branch and "m1MatchesSingleMu_leg2_noiso" not in self.complained:
        if not self.m1MatchesSingleMu_leg2_noiso_branch and "m1MatchesSingleMu_leg2_noiso":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesSingleMu_leg2_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu_leg2_noiso")
        else:
            self.m1MatchesSingleMu_leg2_noiso_branch.SetAddress(<void*>&self.m1MatchesSingleMu_leg2_noiso_value)

        #print "making m1MatchesTripleMu"
        self.m1MatchesTripleMu_branch = the_tree.GetBranch("m1MatchesTripleMu")
        #if not self.m1MatchesTripleMu_branch and "m1MatchesTripleMu" not in self.complained:
        if not self.m1MatchesTripleMu_branch and "m1MatchesTripleMu":
            warnings.warn( "EMuMuTree: Expected branch m1MatchesTripleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesTripleMu")
        else:
            self.m1MatchesTripleMu_branch.SetAddress(<void*>&self.m1MatchesTripleMu_value)

        #print "making m1MtToPfMet_type1"
        self.m1MtToPfMet_type1_branch = the_tree.GetBranch("m1MtToPfMet_type1")
        #if not self.m1MtToPfMet_type1_branch and "m1MtToPfMet_type1" not in self.complained:
        if not self.m1MtToPfMet_type1_branch and "m1MtToPfMet_type1":
            warnings.warn( "EMuMuTree: Expected branch m1MtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_type1")
        else:
            self.m1MtToPfMet_type1_branch.SetAddress(<void*>&self.m1MtToPfMet_type1_value)

        #print "making m1Mu23Ele12DZFilter"
        self.m1Mu23Ele12DZFilter_branch = the_tree.GetBranch("m1Mu23Ele12DZFilter")
        #if not self.m1Mu23Ele12DZFilter_branch and "m1Mu23Ele12DZFilter" not in self.complained:
        if not self.m1Mu23Ele12DZFilter_branch and "m1Mu23Ele12DZFilter":
            warnings.warn( "EMuMuTree: Expected branch m1Mu23Ele12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu23Ele12DZFilter")
        else:
            self.m1Mu23Ele12DZFilter_branch.SetAddress(<void*>&self.m1Mu23Ele12DZFilter_value)

        #print "making m1Mu23Ele12Filter"
        self.m1Mu23Ele12Filter_branch = the_tree.GetBranch("m1Mu23Ele12Filter")
        #if not self.m1Mu23Ele12Filter_branch and "m1Mu23Ele12Filter" not in self.complained:
        if not self.m1Mu23Ele12Filter_branch and "m1Mu23Ele12Filter":
            warnings.warn( "EMuMuTree: Expected branch m1Mu23Ele12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu23Ele12Filter")
        else:
            self.m1Mu23Ele12Filter_branch.SetAddress(<void*>&self.m1Mu23Ele12Filter_value)

        #print "making m1Mu8Ele23DZFilter"
        self.m1Mu8Ele23DZFilter_branch = the_tree.GetBranch("m1Mu8Ele23DZFilter")
        #if not self.m1Mu8Ele23DZFilter_branch and "m1Mu8Ele23DZFilter" not in self.complained:
        if not self.m1Mu8Ele23DZFilter_branch and "m1Mu8Ele23DZFilter":
            warnings.warn( "EMuMuTree: Expected branch m1Mu8Ele23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu8Ele23DZFilter")
        else:
            self.m1Mu8Ele23DZFilter_branch.SetAddress(<void*>&self.m1Mu8Ele23DZFilter_value)

        #print "making m1Mu8Ele23Filter"
        self.m1Mu8Ele23Filter_branch = the_tree.GetBranch("m1Mu8Ele23Filter")
        #if not self.m1Mu8Ele23Filter_branch and "m1Mu8Ele23Filter" not in self.complained:
        if not self.m1Mu8Ele23Filter_branch and "m1Mu8Ele23Filter":
            warnings.warn( "EMuMuTree: Expected branch m1Mu8Ele23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu8Ele23Filter")
        else:
            self.m1Mu8Ele23Filter_branch.SetAddress(<void*>&self.m1Mu8Ele23Filter_value)

        #print "making m1MuonHits"
        self.m1MuonHits_branch = the_tree.GetBranch("m1MuonHits")
        #if not self.m1MuonHits_branch and "m1MuonHits" not in self.complained:
        if not self.m1MuonHits_branch and "m1MuonHits":
            warnings.warn( "EMuMuTree: Expected branch m1MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MuonHits")
        else:
            self.m1MuonHits_branch.SetAddress(<void*>&self.m1MuonHits_value)

        #print "making m1NearestZMass"
        self.m1NearestZMass_branch = the_tree.GetBranch("m1NearestZMass")
        #if not self.m1NearestZMass_branch and "m1NearestZMass" not in self.complained:
        if not self.m1NearestZMass_branch and "m1NearestZMass":
            warnings.warn( "EMuMuTree: Expected branch m1NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NearestZMass")
        else:
            self.m1NearestZMass_branch.SetAddress(<void*>&self.m1NearestZMass_value)

        #print "making m1NormTrkChi2"
        self.m1NormTrkChi2_branch = the_tree.GetBranch("m1NormTrkChi2")
        #if not self.m1NormTrkChi2_branch and "m1NormTrkChi2" not in self.complained:
        if not self.m1NormTrkChi2_branch and "m1NormTrkChi2":
            warnings.warn( "EMuMuTree: Expected branch m1NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormTrkChi2")
        else:
            self.m1NormTrkChi2_branch.SetAddress(<void*>&self.m1NormTrkChi2_value)

        #print "making m1NormalizedChi2"
        self.m1NormalizedChi2_branch = the_tree.GetBranch("m1NormalizedChi2")
        #if not self.m1NormalizedChi2_branch and "m1NormalizedChi2" not in self.complained:
        if not self.m1NormalizedChi2_branch and "m1NormalizedChi2":
            warnings.warn( "EMuMuTree: Expected branch m1NormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormalizedChi2")
        else:
            self.m1NormalizedChi2_branch.SetAddress(<void*>&self.m1NormalizedChi2_value)

        #print "making m1PFChargedHadronIsoR04"
        self.m1PFChargedHadronIsoR04_branch = the_tree.GetBranch("m1PFChargedHadronIsoR04")
        #if not self.m1PFChargedHadronIsoR04_branch and "m1PFChargedHadronIsoR04" not in self.complained:
        if not self.m1PFChargedHadronIsoR04_branch and "m1PFChargedHadronIsoR04":
            warnings.warn( "EMuMuTree: Expected branch m1PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedHadronIsoR04")
        else:
            self.m1PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m1PFChargedHadronIsoR04_value)

        #print "making m1PFChargedIso"
        self.m1PFChargedIso_branch = the_tree.GetBranch("m1PFChargedIso")
        #if not self.m1PFChargedIso_branch and "m1PFChargedIso" not in self.complained:
        if not self.m1PFChargedIso_branch and "m1PFChargedIso":
            warnings.warn( "EMuMuTree: Expected branch m1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedIso")
        else:
            self.m1PFChargedIso_branch.SetAddress(<void*>&self.m1PFChargedIso_value)

        #print "making m1PFIDLoose"
        self.m1PFIDLoose_branch = the_tree.GetBranch("m1PFIDLoose")
        #if not self.m1PFIDLoose_branch and "m1PFIDLoose" not in self.complained:
        if not self.m1PFIDLoose_branch and "m1PFIDLoose":
            warnings.warn( "EMuMuTree: Expected branch m1PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDLoose")
        else:
            self.m1PFIDLoose_branch.SetAddress(<void*>&self.m1PFIDLoose_value)

        #print "making m1PFIDMedium"
        self.m1PFIDMedium_branch = the_tree.GetBranch("m1PFIDMedium")
        #if not self.m1PFIDMedium_branch and "m1PFIDMedium" not in self.complained:
        if not self.m1PFIDMedium_branch and "m1PFIDMedium":
            warnings.warn( "EMuMuTree: Expected branch m1PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDMedium")
        else:
            self.m1PFIDMedium_branch.SetAddress(<void*>&self.m1PFIDMedium_value)

        #print "making m1PFIDTight"
        self.m1PFIDTight_branch = the_tree.GetBranch("m1PFIDTight")
        #if not self.m1PFIDTight_branch and "m1PFIDTight" not in self.complained:
        if not self.m1PFIDTight_branch and "m1PFIDTight":
            warnings.warn( "EMuMuTree: Expected branch m1PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDTight")
        else:
            self.m1PFIDTight_branch.SetAddress(<void*>&self.m1PFIDTight_value)

        #print "making m1PFNeutralHadronIsoR04"
        self.m1PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m1PFNeutralHadronIsoR04")
        #if not self.m1PFNeutralHadronIsoR04_branch and "m1PFNeutralHadronIsoR04" not in self.complained:
        if not self.m1PFNeutralHadronIsoR04_branch and "m1PFNeutralHadronIsoR04":
            warnings.warn( "EMuMuTree: Expected branch m1PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralHadronIsoR04")
        else:
            self.m1PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m1PFNeutralHadronIsoR04_value)

        #print "making m1PFNeutralIso"
        self.m1PFNeutralIso_branch = the_tree.GetBranch("m1PFNeutralIso")
        #if not self.m1PFNeutralIso_branch and "m1PFNeutralIso" not in self.complained:
        if not self.m1PFNeutralIso_branch and "m1PFNeutralIso":
            warnings.warn( "EMuMuTree: Expected branch m1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralIso")
        else:
            self.m1PFNeutralIso_branch.SetAddress(<void*>&self.m1PFNeutralIso_value)

        #print "making m1PFPUChargedIso"
        self.m1PFPUChargedIso_branch = the_tree.GetBranch("m1PFPUChargedIso")
        #if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso" not in self.complained:
        if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso":
            warnings.warn( "EMuMuTree: Expected branch m1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPUChargedIso")
        else:
            self.m1PFPUChargedIso_branch.SetAddress(<void*>&self.m1PFPUChargedIso_value)

        #print "making m1PFPhotonIso"
        self.m1PFPhotonIso_branch = the_tree.GetBranch("m1PFPhotonIso")
        #if not self.m1PFPhotonIso_branch and "m1PFPhotonIso" not in self.complained:
        if not self.m1PFPhotonIso_branch and "m1PFPhotonIso":
            warnings.warn( "EMuMuTree: Expected branch m1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIso")
        else:
            self.m1PFPhotonIso_branch.SetAddress(<void*>&self.m1PFPhotonIso_value)

        #print "making m1PFPhotonIsoR04"
        self.m1PFPhotonIsoR04_branch = the_tree.GetBranch("m1PFPhotonIsoR04")
        #if not self.m1PFPhotonIsoR04_branch and "m1PFPhotonIsoR04" not in self.complained:
        if not self.m1PFPhotonIsoR04_branch and "m1PFPhotonIsoR04":
            warnings.warn( "EMuMuTree: Expected branch m1PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIsoR04")
        else:
            self.m1PFPhotonIsoR04_branch.SetAddress(<void*>&self.m1PFPhotonIsoR04_value)

        #print "making m1PFPileupIsoR04"
        self.m1PFPileupIsoR04_branch = the_tree.GetBranch("m1PFPileupIsoR04")
        #if not self.m1PFPileupIsoR04_branch and "m1PFPileupIsoR04" not in self.complained:
        if not self.m1PFPileupIsoR04_branch and "m1PFPileupIsoR04":
            warnings.warn( "EMuMuTree: Expected branch m1PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPileupIsoR04")
        else:
            self.m1PFPileupIsoR04_branch.SetAddress(<void*>&self.m1PFPileupIsoR04_value)

        #print "making m1PVDXY"
        self.m1PVDXY_branch = the_tree.GetBranch("m1PVDXY")
        #if not self.m1PVDXY_branch and "m1PVDXY" not in self.complained:
        if not self.m1PVDXY_branch and "m1PVDXY":
            warnings.warn( "EMuMuTree: Expected branch m1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDXY")
        else:
            self.m1PVDXY_branch.SetAddress(<void*>&self.m1PVDXY_value)

        #print "making m1PVDZ"
        self.m1PVDZ_branch = the_tree.GetBranch("m1PVDZ")
        #if not self.m1PVDZ_branch and "m1PVDZ" not in self.complained:
        if not self.m1PVDZ_branch and "m1PVDZ":
            warnings.warn( "EMuMuTree: Expected branch m1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDZ")
        else:
            self.m1PVDZ_branch.SetAddress(<void*>&self.m1PVDZ_value)

        #print "making m1Phi"
        self.m1Phi_branch = the_tree.GetBranch("m1Phi")
        #if not self.m1Phi_branch and "m1Phi" not in self.complained:
        if not self.m1Phi_branch and "m1Phi":
            warnings.warn( "EMuMuTree: Expected branch m1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi")
        else:
            self.m1Phi_branch.SetAddress(<void*>&self.m1Phi_value)

        #print "making m1Phi_MuonEnDown"
        self.m1Phi_MuonEnDown_branch = the_tree.GetBranch("m1Phi_MuonEnDown")
        #if not self.m1Phi_MuonEnDown_branch and "m1Phi_MuonEnDown" not in self.complained:
        if not self.m1Phi_MuonEnDown_branch and "m1Phi_MuonEnDown":
            warnings.warn( "EMuMuTree: Expected branch m1Phi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi_MuonEnDown")
        else:
            self.m1Phi_MuonEnDown_branch.SetAddress(<void*>&self.m1Phi_MuonEnDown_value)

        #print "making m1Phi_MuonEnUp"
        self.m1Phi_MuonEnUp_branch = the_tree.GetBranch("m1Phi_MuonEnUp")
        #if not self.m1Phi_MuonEnUp_branch and "m1Phi_MuonEnUp" not in self.complained:
        if not self.m1Phi_MuonEnUp_branch and "m1Phi_MuonEnUp":
            warnings.warn( "EMuMuTree: Expected branch m1Phi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi_MuonEnUp")
        else:
            self.m1Phi_MuonEnUp_branch.SetAddress(<void*>&self.m1Phi_MuonEnUp_value)

        #print "making m1PixHits"
        self.m1PixHits_branch = the_tree.GetBranch("m1PixHits")
        #if not self.m1PixHits_branch and "m1PixHits" not in self.complained:
        if not self.m1PixHits_branch and "m1PixHits":
            warnings.warn( "EMuMuTree: Expected branch m1PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PixHits")
        else:
            self.m1PixHits_branch.SetAddress(<void*>&self.m1PixHits_value)

        #print "making m1Pt"
        self.m1Pt_branch = the_tree.GetBranch("m1Pt")
        #if not self.m1Pt_branch and "m1Pt" not in self.complained:
        if not self.m1Pt_branch and "m1Pt":
            warnings.warn( "EMuMuTree: Expected branch m1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt")
        else:
            self.m1Pt_branch.SetAddress(<void*>&self.m1Pt_value)

        #print "making m1Pt_MuonEnDown"
        self.m1Pt_MuonEnDown_branch = the_tree.GetBranch("m1Pt_MuonEnDown")
        #if not self.m1Pt_MuonEnDown_branch and "m1Pt_MuonEnDown" not in self.complained:
        if not self.m1Pt_MuonEnDown_branch and "m1Pt_MuonEnDown":
            warnings.warn( "EMuMuTree: Expected branch m1Pt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt_MuonEnDown")
        else:
            self.m1Pt_MuonEnDown_branch.SetAddress(<void*>&self.m1Pt_MuonEnDown_value)

        #print "making m1Pt_MuonEnUp"
        self.m1Pt_MuonEnUp_branch = the_tree.GetBranch("m1Pt_MuonEnUp")
        #if not self.m1Pt_MuonEnUp_branch and "m1Pt_MuonEnUp" not in self.complained:
        if not self.m1Pt_MuonEnUp_branch and "m1Pt_MuonEnUp":
            warnings.warn( "EMuMuTree: Expected branch m1Pt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt_MuonEnUp")
        else:
            self.m1Pt_MuonEnUp_branch.SetAddress(<void*>&self.m1Pt_MuonEnUp_value)

        #print "making m1Rank"
        self.m1Rank_branch = the_tree.GetBranch("m1Rank")
        #if not self.m1Rank_branch and "m1Rank" not in self.complained:
        if not self.m1Rank_branch and "m1Rank":
            warnings.warn( "EMuMuTree: Expected branch m1Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Rank")
        else:
            self.m1Rank_branch.SetAddress(<void*>&self.m1Rank_value)

        #print "making m1RelPFIsoDBDefault"
        self.m1RelPFIsoDBDefault_branch = the_tree.GetBranch("m1RelPFIsoDBDefault")
        #if not self.m1RelPFIsoDBDefault_branch and "m1RelPFIsoDBDefault" not in self.complained:
        if not self.m1RelPFIsoDBDefault_branch and "m1RelPFIsoDBDefault":
            warnings.warn( "EMuMuTree: Expected branch m1RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDBDefault")
        else:
            self.m1RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m1RelPFIsoDBDefault_value)

        #print "making m1RelPFIsoDBDefaultR04"
        self.m1RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m1RelPFIsoDBDefaultR04")
        #if not self.m1RelPFIsoDBDefaultR04_branch and "m1RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m1RelPFIsoDBDefaultR04_branch and "m1RelPFIsoDBDefaultR04":
            warnings.warn( "EMuMuTree: Expected branch m1RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDBDefaultR04")
        else:
            self.m1RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m1RelPFIsoDBDefaultR04_value)

        #print "making m1RelPFIsoRho"
        self.m1RelPFIsoRho_branch = the_tree.GetBranch("m1RelPFIsoRho")
        #if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho" not in self.complained:
        if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho":
            warnings.warn( "EMuMuTree: Expected branch m1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRho")
        else:
            self.m1RelPFIsoRho_branch.SetAddress(<void*>&self.m1RelPFIsoRho_value)

        #print "making m1Rho"
        self.m1Rho_branch = the_tree.GetBranch("m1Rho")
        #if not self.m1Rho_branch and "m1Rho" not in self.complained:
        if not self.m1Rho_branch and "m1Rho":
            warnings.warn( "EMuMuTree: Expected branch m1Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Rho")
        else:
            self.m1Rho_branch.SetAddress(<void*>&self.m1Rho_value)

        #print "making m1SIP2D"
        self.m1SIP2D_branch = the_tree.GetBranch("m1SIP2D")
        #if not self.m1SIP2D_branch and "m1SIP2D" not in self.complained:
        if not self.m1SIP2D_branch and "m1SIP2D":
            warnings.warn( "EMuMuTree: Expected branch m1SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SIP2D")
        else:
            self.m1SIP2D_branch.SetAddress(<void*>&self.m1SIP2D_value)

        #print "making m1SIP3D"
        self.m1SIP3D_branch = the_tree.GetBranch("m1SIP3D")
        #if not self.m1SIP3D_branch and "m1SIP3D" not in self.complained:
        if not self.m1SIP3D_branch and "m1SIP3D":
            warnings.warn( "EMuMuTree: Expected branch m1SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SIP3D")
        else:
            self.m1SIP3D_branch.SetAddress(<void*>&self.m1SIP3D_value)

        #print "making m1SegmentCompatibility"
        self.m1SegmentCompatibility_branch = the_tree.GetBranch("m1SegmentCompatibility")
        #if not self.m1SegmentCompatibility_branch and "m1SegmentCompatibility" not in self.complained:
        if not self.m1SegmentCompatibility_branch and "m1SegmentCompatibility":
            warnings.warn( "EMuMuTree: Expected branch m1SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SegmentCompatibility")
        else:
            self.m1SegmentCompatibility_branch.SetAddress(<void*>&self.m1SegmentCompatibility_value)

        #print "making m1TkLayersWithMeasurement"
        self.m1TkLayersWithMeasurement_branch = the_tree.GetBranch("m1TkLayersWithMeasurement")
        #if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement" not in self.complained:
        if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement":
            warnings.warn( "EMuMuTree: Expected branch m1TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkLayersWithMeasurement")
        else:
            self.m1TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m1TkLayersWithMeasurement_value)

        #print "making m1TrkIsoDR03"
        self.m1TrkIsoDR03_branch = the_tree.GetBranch("m1TrkIsoDR03")
        #if not self.m1TrkIsoDR03_branch and "m1TrkIsoDR03" not in self.complained:
        if not self.m1TrkIsoDR03_branch and "m1TrkIsoDR03":
            warnings.warn( "EMuMuTree: Expected branch m1TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TrkIsoDR03")
        else:
            self.m1TrkIsoDR03_branch.SetAddress(<void*>&self.m1TrkIsoDR03_value)

        #print "making m1TrkKink"
        self.m1TrkKink_branch = the_tree.GetBranch("m1TrkKink")
        #if not self.m1TrkKink_branch and "m1TrkKink" not in self.complained:
        if not self.m1TrkKink_branch and "m1TrkKink":
            warnings.warn( "EMuMuTree: Expected branch m1TrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TrkKink")
        else:
            self.m1TrkKink_branch.SetAddress(<void*>&self.m1TrkKink_value)

        #print "making m1TypeCode"
        self.m1TypeCode_branch = the_tree.GetBranch("m1TypeCode")
        #if not self.m1TypeCode_branch and "m1TypeCode" not in self.complained:
        if not self.m1TypeCode_branch and "m1TypeCode":
            warnings.warn( "EMuMuTree: Expected branch m1TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TypeCode")
        else:
            self.m1TypeCode_branch.SetAddress(<void*>&self.m1TypeCode_value)

        #print "making m1VZ"
        self.m1VZ_branch = the_tree.GetBranch("m1VZ")
        #if not self.m1VZ_branch and "m1VZ" not in self.complained:
        if not self.m1VZ_branch and "m1VZ":
            warnings.warn( "EMuMuTree: Expected branch m1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VZ")
        else:
            self.m1VZ_branch.SetAddress(<void*>&self.m1VZ_value)

        #print "making m1ValidFraction"
        self.m1ValidFraction_branch = the_tree.GetBranch("m1ValidFraction")
        #if not self.m1ValidFraction_branch and "m1ValidFraction" not in self.complained:
        if not self.m1ValidFraction_branch and "m1ValidFraction":
            warnings.warn( "EMuMuTree: Expected branch m1ValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ValidFraction")
        else:
            self.m1ValidFraction_branch.SetAddress(<void*>&self.m1ValidFraction_value)

        #print "making m1ZTTGenMatching"
        self.m1ZTTGenMatching_branch = the_tree.GetBranch("m1ZTTGenMatching")
        #if not self.m1ZTTGenMatching_branch and "m1ZTTGenMatching" not in self.complained:
        if not self.m1ZTTGenMatching_branch and "m1ZTTGenMatching":
            warnings.warn( "EMuMuTree: Expected branch m1ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ZTTGenMatching")
        else:
            self.m1ZTTGenMatching_branch.SetAddress(<void*>&self.m1ZTTGenMatching_value)

        #print "making m1_e_collinearmass"
        self.m1_e_collinearmass_branch = the_tree.GetBranch("m1_e_collinearmass")
        #if not self.m1_e_collinearmass_branch and "m1_e_collinearmass" not in self.complained:
        if not self.m1_e_collinearmass_branch and "m1_e_collinearmass":
            warnings.warn( "EMuMuTree: Expected branch m1_e_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_e_collinearmass")
        else:
            self.m1_e_collinearmass_branch.SetAddress(<void*>&self.m1_e_collinearmass_value)

        #print "making m1_e_collinearmass_CheckUESDown"
        self.m1_e_collinearmass_CheckUESDown_branch = the_tree.GetBranch("m1_e_collinearmass_CheckUESDown")
        #if not self.m1_e_collinearmass_CheckUESDown_branch and "m1_e_collinearmass_CheckUESDown" not in self.complained:
        if not self.m1_e_collinearmass_CheckUESDown_branch and "m1_e_collinearmass_CheckUESDown":
            warnings.warn( "EMuMuTree: Expected branch m1_e_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_e_collinearmass_CheckUESDown")
        else:
            self.m1_e_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.m1_e_collinearmass_CheckUESDown_value)

        #print "making m1_e_collinearmass_CheckUESUp"
        self.m1_e_collinearmass_CheckUESUp_branch = the_tree.GetBranch("m1_e_collinearmass_CheckUESUp")
        #if not self.m1_e_collinearmass_CheckUESUp_branch and "m1_e_collinearmass_CheckUESUp" not in self.complained:
        if not self.m1_e_collinearmass_CheckUESUp_branch and "m1_e_collinearmass_CheckUESUp":
            warnings.warn( "EMuMuTree: Expected branch m1_e_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_e_collinearmass_CheckUESUp")
        else:
            self.m1_e_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.m1_e_collinearmass_CheckUESUp_value)

        #print "making m1_e_collinearmass_JetCheckTotalDown"
        self.m1_e_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("m1_e_collinearmass_JetCheckTotalDown")
        #if not self.m1_e_collinearmass_JetCheckTotalDown_branch and "m1_e_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.m1_e_collinearmass_JetCheckTotalDown_branch and "m1_e_collinearmass_JetCheckTotalDown":
            warnings.warn( "EMuMuTree: Expected branch m1_e_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_e_collinearmass_JetCheckTotalDown")
        else:
            self.m1_e_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.m1_e_collinearmass_JetCheckTotalDown_value)

        #print "making m1_e_collinearmass_JetCheckTotalUp"
        self.m1_e_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("m1_e_collinearmass_JetCheckTotalUp")
        #if not self.m1_e_collinearmass_JetCheckTotalUp_branch and "m1_e_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.m1_e_collinearmass_JetCheckTotalUp_branch and "m1_e_collinearmass_JetCheckTotalUp":
            warnings.warn( "EMuMuTree: Expected branch m1_e_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_e_collinearmass_JetCheckTotalUp")
        else:
            self.m1_e_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.m1_e_collinearmass_JetCheckTotalUp_value)

        #print "making m1_e_collinearmass_JetEnDown"
        self.m1_e_collinearmass_JetEnDown_branch = the_tree.GetBranch("m1_e_collinearmass_JetEnDown")
        #if not self.m1_e_collinearmass_JetEnDown_branch and "m1_e_collinearmass_JetEnDown" not in self.complained:
        if not self.m1_e_collinearmass_JetEnDown_branch and "m1_e_collinearmass_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch m1_e_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_e_collinearmass_JetEnDown")
        else:
            self.m1_e_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m1_e_collinearmass_JetEnDown_value)

        #print "making m1_e_collinearmass_JetEnUp"
        self.m1_e_collinearmass_JetEnUp_branch = the_tree.GetBranch("m1_e_collinearmass_JetEnUp")
        #if not self.m1_e_collinearmass_JetEnUp_branch and "m1_e_collinearmass_JetEnUp" not in self.complained:
        if not self.m1_e_collinearmass_JetEnUp_branch and "m1_e_collinearmass_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch m1_e_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_e_collinearmass_JetEnUp")
        else:
            self.m1_e_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m1_e_collinearmass_JetEnUp_value)

        #print "making m1_e_collinearmass_UnclusteredEnDown"
        self.m1_e_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m1_e_collinearmass_UnclusteredEnDown")
        #if not self.m1_e_collinearmass_UnclusteredEnDown_branch and "m1_e_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m1_e_collinearmass_UnclusteredEnDown_branch and "m1_e_collinearmass_UnclusteredEnDown":
            warnings.warn( "EMuMuTree: Expected branch m1_e_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_e_collinearmass_UnclusteredEnDown")
        else:
            self.m1_e_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m1_e_collinearmass_UnclusteredEnDown_value)

        #print "making m1_e_collinearmass_UnclusteredEnUp"
        self.m1_e_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m1_e_collinearmass_UnclusteredEnUp")
        #if not self.m1_e_collinearmass_UnclusteredEnUp_branch and "m1_e_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m1_e_collinearmass_UnclusteredEnUp_branch and "m1_e_collinearmass_UnclusteredEnUp":
            warnings.warn( "EMuMuTree: Expected branch m1_e_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_e_collinearmass_UnclusteredEnUp")
        else:
            self.m1_e_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m1_e_collinearmass_UnclusteredEnUp_value)

        #print "making m1_m2_CosThetaStar"
        self.m1_m2_CosThetaStar_branch = the_tree.GetBranch("m1_m2_CosThetaStar")
        #if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar" not in self.complained:
        if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_CosThetaStar")
        else:
            self.m1_m2_CosThetaStar_branch.SetAddress(<void*>&self.m1_m2_CosThetaStar_value)

        #print "making m1_m2_DPhi"
        self.m1_m2_DPhi_branch = the_tree.GetBranch("m1_m2_DPhi")
        #if not self.m1_m2_DPhi_branch and "m1_m2_DPhi" not in self.complained:
        if not self.m1_m2_DPhi_branch and "m1_m2_DPhi":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DPhi")
        else:
            self.m1_m2_DPhi_branch.SetAddress(<void*>&self.m1_m2_DPhi_value)

        #print "making m1_m2_DR"
        self.m1_m2_DR_branch = the_tree.GetBranch("m1_m2_DR")
        #if not self.m1_m2_DR_branch and "m1_m2_DR" not in self.complained:
        if not self.m1_m2_DR_branch and "m1_m2_DR":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DR")
        else:
            self.m1_m2_DR_branch.SetAddress(<void*>&self.m1_m2_DR_value)

        #print "making m1_m2_Eta"
        self.m1_m2_Eta_branch = the_tree.GetBranch("m1_m2_Eta")
        #if not self.m1_m2_Eta_branch and "m1_m2_Eta" not in self.complained:
        if not self.m1_m2_Eta_branch and "m1_m2_Eta":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Eta")
        else:
            self.m1_m2_Eta_branch.SetAddress(<void*>&self.m1_m2_Eta_value)

        #print "making m1_m2_Mass"
        self.m1_m2_Mass_branch = the_tree.GetBranch("m1_m2_Mass")
        #if not self.m1_m2_Mass_branch and "m1_m2_Mass" not in self.complained:
        if not self.m1_m2_Mass_branch and "m1_m2_Mass":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass")
        else:
            self.m1_m2_Mass_branch.SetAddress(<void*>&self.m1_m2_Mass_value)

        #print "making m1_m2_Mass_TauEnDown"
        self.m1_m2_Mass_TauEnDown_branch = the_tree.GetBranch("m1_m2_Mass_TauEnDown")
        #if not self.m1_m2_Mass_TauEnDown_branch and "m1_m2_Mass_TauEnDown" not in self.complained:
        if not self.m1_m2_Mass_TauEnDown_branch and "m1_m2_Mass_TauEnDown":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_Mass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass_TauEnDown")
        else:
            self.m1_m2_Mass_TauEnDown_branch.SetAddress(<void*>&self.m1_m2_Mass_TauEnDown_value)

        #print "making m1_m2_Mass_TauEnUp"
        self.m1_m2_Mass_TauEnUp_branch = the_tree.GetBranch("m1_m2_Mass_TauEnUp")
        #if not self.m1_m2_Mass_TauEnUp_branch and "m1_m2_Mass_TauEnUp" not in self.complained:
        if not self.m1_m2_Mass_TauEnUp_branch and "m1_m2_Mass_TauEnUp":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_Mass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass_TauEnUp")
        else:
            self.m1_m2_Mass_TauEnUp_branch.SetAddress(<void*>&self.m1_m2_Mass_TauEnUp_value)

        #print "making m1_m2_Mt"
        self.m1_m2_Mt_branch = the_tree.GetBranch("m1_m2_Mt")
        #if not self.m1_m2_Mt_branch and "m1_m2_Mt" not in self.complained:
        if not self.m1_m2_Mt_branch and "m1_m2_Mt":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mt")
        else:
            self.m1_m2_Mt_branch.SetAddress(<void*>&self.m1_m2_Mt_value)

        #print "making m1_m2_MtTotal"
        self.m1_m2_MtTotal_branch = the_tree.GetBranch("m1_m2_MtTotal")
        #if not self.m1_m2_MtTotal_branch and "m1_m2_MtTotal" not in self.complained:
        if not self.m1_m2_MtTotal_branch and "m1_m2_MtTotal":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_MtTotal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MtTotal")
        else:
            self.m1_m2_MtTotal_branch.SetAddress(<void*>&self.m1_m2_MtTotal_value)

        #print "making m1_m2_Mt_TauEnDown"
        self.m1_m2_Mt_TauEnDown_branch = the_tree.GetBranch("m1_m2_Mt_TauEnDown")
        #if not self.m1_m2_Mt_TauEnDown_branch and "m1_m2_Mt_TauEnDown" not in self.complained:
        if not self.m1_m2_Mt_TauEnDown_branch and "m1_m2_Mt_TauEnDown":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_Mt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mt_TauEnDown")
        else:
            self.m1_m2_Mt_TauEnDown_branch.SetAddress(<void*>&self.m1_m2_Mt_TauEnDown_value)

        #print "making m1_m2_Mt_TauEnUp"
        self.m1_m2_Mt_TauEnUp_branch = the_tree.GetBranch("m1_m2_Mt_TauEnUp")
        #if not self.m1_m2_Mt_TauEnUp_branch and "m1_m2_Mt_TauEnUp" not in self.complained:
        if not self.m1_m2_Mt_TauEnUp_branch and "m1_m2_Mt_TauEnUp":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_Mt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mt_TauEnUp")
        else:
            self.m1_m2_Mt_TauEnUp_branch.SetAddress(<void*>&self.m1_m2_Mt_TauEnUp_value)

        #print "making m1_m2_MvaMet"
        self.m1_m2_MvaMet_branch = the_tree.GetBranch("m1_m2_MvaMet")
        #if not self.m1_m2_MvaMet_branch and "m1_m2_MvaMet" not in self.complained:
        if not self.m1_m2_MvaMet_branch and "m1_m2_MvaMet":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_MvaMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMet")
        else:
            self.m1_m2_MvaMet_branch.SetAddress(<void*>&self.m1_m2_MvaMet_value)

        #print "making m1_m2_MvaMetCovMatrix00"
        self.m1_m2_MvaMetCovMatrix00_branch = the_tree.GetBranch("m1_m2_MvaMetCovMatrix00")
        #if not self.m1_m2_MvaMetCovMatrix00_branch and "m1_m2_MvaMetCovMatrix00" not in self.complained:
        if not self.m1_m2_MvaMetCovMatrix00_branch and "m1_m2_MvaMetCovMatrix00":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_MvaMetCovMatrix00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetCovMatrix00")
        else:
            self.m1_m2_MvaMetCovMatrix00_branch.SetAddress(<void*>&self.m1_m2_MvaMetCovMatrix00_value)

        #print "making m1_m2_MvaMetCovMatrix01"
        self.m1_m2_MvaMetCovMatrix01_branch = the_tree.GetBranch("m1_m2_MvaMetCovMatrix01")
        #if not self.m1_m2_MvaMetCovMatrix01_branch and "m1_m2_MvaMetCovMatrix01" not in self.complained:
        if not self.m1_m2_MvaMetCovMatrix01_branch and "m1_m2_MvaMetCovMatrix01":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_MvaMetCovMatrix01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetCovMatrix01")
        else:
            self.m1_m2_MvaMetCovMatrix01_branch.SetAddress(<void*>&self.m1_m2_MvaMetCovMatrix01_value)

        #print "making m1_m2_MvaMetCovMatrix10"
        self.m1_m2_MvaMetCovMatrix10_branch = the_tree.GetBranch("m1_m2_MvaMetCovMatrix10")
        #if not self.m1_m2_MvaMetCovMatrix10_branch and "m1_m2_MvaMetCovMatrix10" not in self.complained:
        if not self.m1_m2_MvaMetCovMatrix10_branch and "m1_m2_MvaMetCovMatrix10":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_MvaMetCovMatrix10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetCovMatrix10")
        else:
            self.m1_m2_MvaMetCovMatrix10_branch.SetAddress(<void*>&self.m1_m2_MvaMetCovMatrix10_value)

        #print "making m1_m2_MvaMetCovMatrix11"
        self.m1_m2_MvaMetCovMatrix11_branch = the_tree.GetBranch("m1_m2_MvaMetCovMatrix11")
        #if not self.m1_m2_MvaMetCovMatrix11_branch and "m1_m2_MvaMetCovMatrix11" not in self.complained:
        if not self.m1_m2_MvaMetCovMatrix11_branch and "m1_m2_MvaMetCovMatrix11":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_MvaMetCovMatrix11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetCovMatrix11")
        else:
            self.m1_m2_MvaMetCovMatrix11_branch.SetAddress(<void*>&self.m1_m2_MvaMetCovMatrix11_value)

        #print "making m1_m2_MvaMetPhi"
        self.m1_m2_MvaMetPhi_branch = the_tree.GetBranch("m1_m2_MvaMetPhi")
        #if not self.m1_m2_MvaMetPhi_branch and "m1_m2_MvaMetPhi" not in self.complained:
        if not self.m1_m2_MvaMetPhi_branch and "m1_m2_MvaMetPhi":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_MvaMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetPhi")
        else:
            self.m1_m2_MvaMetPhi_branch.SetAddress(<void*>&self.m1_m2_MvaMetPhi_value)

        #print "making m1_m2_PZeta"
        self.m1_m2_PZeta_branch = the_tree.GetBranch("m1_m2_PZeta")
        #if not self.m1_m2_PZeta_branch and "m1_m2_PZeta" not in self.complained:
        if not self.m1_m2_PZeta_branch and "m1_m2_PZeta":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZeta")
        else:
            self.m1_m2_PZeta_branch.SetAddress(<void*>&self.m1_m2_PZeta_value)

        #print "making m1_m2_PZetaLess0p85PZetaVis"
        self.m1_m2_PZetaLess0p85PZetaVis_branch = the_tree.GetBranch("m1_m2_PZetaLess0p85PZetaVis")
        #if not self.m1_m2_PZetaLess0p85PZetaVis_branch and "m1_m2_PZetaLess0p85PZetaVis" not in self.complained:
        if not self.m1_m2_PZetaLess0p85PZetaVis_branch and "m1_m2_PZetaLess0p85PZetaVis":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_PZetaLess0p85PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZetaLess0p85PZetaVis")
        else:
            self.m1_m2_PZetaLess0p85PZetaVis_branch.SetAddress(<void*>&self.m1_m2_PZetaLess0p85PZetaVis_value)

        #print "making m1_m2_PZetaVis"
        self.m1_m2_PZetaVis_branch = the_tree.GetBranch("m1_m2_PZetaVis")
        #if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis" not in self.complained:
        if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZetaVis")
        else:
            self.m1_m2_PZetaVis_branch.SetAddress(<void*>&self.m1_m2_PZetaVis_value)

        #print "making m1_m2_Phi"
        self.m1_m2_Phi_branch = the_tree.GetBranch("m1_m2_Phi")
        #if not self.m1_m2_Phi_branch and "m1_m2_Phi" not in self.complained:
        if not self.m1_m2_Phi_branch and "m1_m2_Phi":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Phi")
        else:
            self.m1_m2_Phi_branch.SetAddress(<void*>&self.m1_m2_Phi_value)

        #print "making m1_m2_Pt"
        self.m1_m2_Pt_branch = the_tree.GetBranch("m1_m2_Pt")
        #if not self.m1_m2_Pt_branch and "m1_m2_Pt" not in self.complained:
        if not self.m1_m2_Pt_branch and "m1_m2_Pt":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Pt")
        else:
            self.m1_m2_Pt_branch.SetAddress(<void*>&self.m1_m2_Pt_value)

        #print "making m1_m2_SS"
        self.m1_m2_SS_branch = the_tree.GetBranch("m1_m2_SS")
        #if not self.m1_m2_SS_branch and "m1_m2_SS" not in self.complained:
        if not self.m1_m2_SS_branch and "m1_m2_SS":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_SS")
        else:
            self.m1_m2_SS_branch.SetAddress(<void*>&self.m1_m2_SS_value)

        #print "making m1_m2_ToMETDPhi_Ty1"
        self.m1_m2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_m2_ToMETDPhi_Ty1")
        #if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_ToMETDPhi_Ty1")
        else:
            self.m1_m2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_m2_ToMETDPhi_Ty1_value)

        #print "making m1_m2_collinearmass"
        self.m1_m2_collinearmass_branch = the_tree.GetBranch("m1_m2_collinearmass")
        #if not self.m1_m2_collinearmass_branch and "m1_m2_collinearmass" not in self.complained:
        if not self.m1_m2_collinearmass_branch and "m1_m2_collinearmass":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass")
        else:
            self.m1_m2_collinearmass_branch.SetAddress(<void*>&self.m1_m2_collinearmass_value)

        #print "making m1_m2_collinearmass_CheckUESDown"
        self.m1_m2_collinearmass_CheckUESDown_branch = the_tree.GetBranch("m1_m2_collinearmass_CheckUESDown")
        #if not self.m1_m2_collinearmass_CheckUESDown_branch and "m1_m2_collinearmass_CheckUESDown" not in self.complained:
        if not self.m1_m2_collinearmass_CheckUESDown_branch and "m1_m2_collinearmass_CheckUESDown":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_CheckUESDown")
        else:
            self.m1_m2_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_CheckUESDown_value)

        #print "making m1_m2_collinearmass_CheckUESUp"
        self.m1_m2_collinearmass_CheckUESUp_branch = the_tree.GetBranch("m1_m2_collinearmass_CheckUESUp")
        #if not self.m1_m2_collinearmass_CheckUESUp_branch and "m1_m2_collinearmass_CheckUESUp" not in self.complained:
        if not self.m1_m2_collinearmass_CheckUESUp_branch and "m1_m2_collinearmass_CheckUESUp":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_CheckUESUp")
        else:
            self.m1_m2_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_CheckUESUp_value)

        #print "making m1_m2_collinearmass_EleEnDown"
        self.m1_m2_collinearmass_EleEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_EleEnDown")
        #if not self.m1_m2_collinearmass_EleEnDown_branch and "m1_m2_collinearmass_EleEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_EleEnDown_branch and "m1_m2_collinearmass_EleEnDown":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_EleEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_EleEnDown")
        else:
            self.m1_m2_collinearmass_EleEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_EleEnDown_value)

        #print "making m1_m2_collinearmass_EleEnUp"
        self.m1_m2_collinearmass_EleEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_EleEnUp")
        #if not self.m1_m2_collinearmass_EleEnUp_branch and "m1_m2_collinearmass_EleEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_EleEnUp_branch and "m1_m2_collinearmass_EleEnUp":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_EleEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_EleEnUp")
        else:
            self.m1_m2_collinearmass_EleEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_EleEnUp_value)

        #print "making m1_m2_collinearmass_JetCheckTotalDown"
        self.m1_m2_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("m1_m2_collinearmass_JetCheckTotalDown")
        #if not self.m1_m2_collinearmass_JetCheckTotalDown_branch and "m1_m2_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.m1_m2_collinearmass_JetCheckTotalDown_branch and "m1_m2_collinearmass_JetCheckTotalDown":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_JetCheckTotalDown")
        else:
            self.m1_m2_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_JetCheckTotalDown_value)

        #print "making m1_m2_collinearmass_JetCheckTotalUp"
        self.m1_m2_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("m1_m2_collinearmass_JetCheckTotalUp")
        #if not self.m1_m2_collinearmass_JetCheckTotalUp_branch and "m1_m2_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.m1_m2_collinearmass_JetCheckTotalUp_branch and "m1_m2_collinearmass_JetCheckTotalUp":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_JetCheckTotalUp")
        else:
            self.m1_m2_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_JetCheckTotalUp_value)

        #print "making m1_m2_collinearmass_JetEnDown"
        self.m1_m2_collinearmass_JetEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_JetEnDown")
        #if not self.m1_m2_collinearmass_JetEnDown_branch and "m1_m2_collinearmass_JetEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_JetEnDown_branch and "m1_m2_collinearmass_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_JetEnDown")
        else:
            self.m1_m2_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_JetEnDown_value)

        #print "making m1_m2_collinearmass_JetEnUp"
        self.m1_m2_collinearmass_JetEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_JetEnUp")
        #if not self.m1_m2_collinearmass_JetEnUp_branch and "m1_m2_collinearmass_JetEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_JetEnUp_branch and "m1_m2_collinearmass_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_JetEnUp")
        else:
            self.m1_m2_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_JetEnUp_value)

        #print "making m1_m2_collinearmass_MuEnDown"
        self.m1_m2_collinearmass_MuEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_MuEnDown")
        #if not self.m1_m2_collinearmass_MuEnDown_branch and "m1_m2_collinearmass_MuEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_MuEnDown_branch and "m1_m2_collinearmass_MuEnDown":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_MuEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_MuEnDown")
        else:
            self.m1_m2_collinearmass_MuEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_MuEnDown_value)

        #print "making m1_m2_collinearmass_MuEnUp"
        self.m1_m2_collinearmass_MuEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_MuEnUp")
        #if not self.m1_m2_collinearmass_MuEnUp_branch and "m1_m2_collinearmass_MuEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_MuEnUp_branch and "m1_m2_collinearmass_MuEnUp":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_MuEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_MuEnUp")
        else:
            self.m1_m2_collinearmass_MuEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_MuEnUp_value)

        #print "making m1_m2_collinearmass_TauEnDown"
        self.m1_m2_collinearmass_TauEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_TauEnDown")
        #if not self.m1_m2_collinearmass_TauEnDown_branch and "m1_m2_collinearmass_TauEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_TauEnDown_branch and "m1_m2_collinearmass_TauEnDown":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_TauEnDown")
        else:
            self.m1_m2_collinearmass_TauEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_TauEnDown_value)

        #print "making m1_m2_collinearmass_TauEnUp"
        self.m1_m2_collinearmass_TauEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_TauEnUp")
        #if not self.m1_m2_collinearmass_TauEnUp_branch and "m1_m2_collinearmass_TauEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_TauEnUp_branch and "m1_m2_collinearmass_TauEnUp":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_TauEnUp")
        else:
            self.m1_m2_collinearmass_TauEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_TauEnUp_value)

        #print "making m1_m2_collinearmass_UnclusteredEnDown"
        self.m1_m2_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_UnclusteredEnDown")
        #if not self.m1_m2_collinearmass_UnclusteredEnDown_branch and "m1_m2_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_UnclusteredEnDown_branch and "m1_m2_collinearmass_UnclusteredEnDown":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_UnclusteredEnDown")
        else:
            self.m1_m2_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_UnclusteredEnDown_value)

        #print "making m1_m2_collinearmass_UnclusteredEnUp"
        self.m1_m2_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_UnclusteredEnUp")
        #if not self.m1_m2_collinearmass_UnclusteredEnUp_branch and "m1_m2_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_UnclusteredEnUp_branch and "m1_m2_collinearmass_UnclusteredEnUp":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_UnclusteredEnUp")
        else:
            self.m1_m2_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_UnclusteredEnUp_value)

        #print "making m1_m2_pt_tt"
        self.m1_m2_pt_tt_branch = the_tree.GetBranch("m1_m2_pt_tt")
        #if not self.m1_m2_pt_tt_branch and "m1_m2_pt_tt" not in self.complained:
        if not self.m1_m2_pt_tt_branch and "m1_m2_pt_tt":
            warnings.warn( "EMuMuTree: Expected branch m1_m2_pt_tt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_pt_tt")
        else:
            self.m1_m2_pt_tt_branch.SetAddress(<void*>&self.m1_m2_pt_tt_value)

        #print "making m2AbsEta"
        self.m2AbsEta_branch = the_tree.GetBranch("m2AbsEta")
        #if not self.m2AbsEta_branch and "m2AbsEta" not in self.complained:
        if not self.m2AbsEta_branch and "m2AbsEta":
            warnings.warn( "EMuMuTree: Expected branch m2AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2AbsEta")
        else:
            self.m2AbsEta_branch.SetAddress(<void*>&self.m2AbsEta_value)

        #print "making m2BestTrackType"
        self.m2BestTrackType_branch = the_tree.GetBranch("m2BestTrackType")
        #if not self.m2BestTrackType_branch and "m2BestTrackType" not in self.complained:
        if not self.m2BestTrackType_branch and "m2BestTrackType":
            warnings.warn( "EMuMuTree: Expected branch m2BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2BestTrackType")
        else:
            self.m2BestTrackType_branch.SetAddress(<void*>&self.m2BestTrackType_value)

        #print "making m2Charge"
        self.m2Charge_branch = the_tree.GetBranch("m2Charge")
        #if not self.m2Charge_branch and "m2Charge" not in self.complained:
        if not self.m2Charge_branch and "m2Charge":
            warnings.warn( "EMuMuTree: Expected branch m2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Charge")
        else:
            self.m2Charge_branch.SetAddress(<void*>&self.m2Charge_value)

        #print "making m2Chi2LocalPosition"
        self.m2Chi2LocalPosition_branch = the_tree.GetBranch("m2Chi2LocalPosition")
        #if not self.m2Chi2LocalPosition_branch and "m2Chi2LocalPosition" not in self.complained:
        if not self.m2Chi2LocalPosition_branch and "m2Chi2LocalPosition":
            warnings.warn( "EMuMuTree: Expected branch m2Chi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Chi2LocalPosition")
        else:
            self.m2Chi2LocalPosition_branch.SetAddress(<void*>&self.m2Chi2LocalPosition_value)

        #print "making m2ComesFromHiggs"
        self.m2ComesFromHiggs_branch = the_tree.GetBranch("m2ComesFromHiggs")
        #if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs" not in self.complained:
        if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs":
            warnings.warn( "EMuMuTree: Expected branch m2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ComesFromHiggs")
        else:
            self.m2ComesFromHiggs_branch.SetAddress(<void*>&self.m2ComesFromHiggs_value)

        #print "making m2DPhiToPfMet_type1"
        self.m2DPhiToPfMet_type1_branch = the_tree.GetBranch("m2DPhiToPfMet_type1")
        #if not self.m2DPhiToPfMet_type1_branch and "m2DPhiToPfMet_type1" not in self.complained:
        if not self.m2DPhiToPfMet_type1_branch and "m2DPhiToPfMet_type1":
            warnings.warn( "EMuMuTree: Expected branch m2DPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_type1")
        else:
            self.m2DPhiToPfMet_type1_branch.SetAddress(<void*>&self.m2DPhiToPfMet_type1_value)

        #print "making m2EcalIsoDR03"
        self.m2EcalIsoDR03_branch = the_tree.GetBranch("m2EcalIsoDR03")
        #if not self.m2EcalIsoDR03_branch and "m2EcalIsoDR03" not in self.complained:
        if not self.m2EcalIsoDR03_branch and "m2EcalIsoDR03":
            warnings.warn( "EMuMuTree: Expected branch m2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EcalIsoDR03")
        else:
            self.m2EcalIsoDR03_branch.SetAddress(<void*>&self.m2EcalIsoDR03_value)

        #print "making m2EffectiveArea2011"
        self.m2EffectiveArea2011_branch = the_tree.GetBranch("m2EffectiveArea2011")
        #if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011" not in self.complained:
        if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011":
            warnings.warn( "EMuMuTree: Expected branch m2EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2011")
        else:
            self.m2EffectiveArea2011_branch.SetAddress(<void*>&self.m2EffectiveArea2011_value)

        #print "making m2EffectiveArea2012"
        self.m2EffectiveArea2012_branch = the_tree.GetBranch("m2EffectiveArea2012")
        #if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012" not in self.complained:
        if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012":
            warnings.warn( "EMuMuTree: Expected branch m2EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2012")
        else:
            self.m2EffectiveArea2012_branch.SetAddress(<void*>&self.m2EffectiveArea2012_value)

        #print "making m2ErsatzGenEta"
        self.m2ErsatzGenEta_branch = the_tree.GetBranch("m2ErsatzGenEta")
        #if not self.m2ErsatzGenEta_branch and "m2ErsatzGenEta" not in self.complained:
        if not self.m2ErsatzGenEta_branch and "m2ErsatzGenEta":
            warnings.warn( "EMuMuTree: Expected branch m2ErsatzGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenEta")
        else:
            self.m2ErsatzGenEta_branch.SetAddress(<void*>&self.m2ErsatzGenEta_value)

        #print "making m2ErsatzGenM"
        self.m2ErsatzGenM_branch = the_tree.GetBranch("m2ErsatzGenM")
        #if not self.m2ErsatzGenM_branch and "m2ErsatzGenM" not in self.complained:
        if not self.m2ErsatzGenM_branch and "m2ErsatzGenM":
            warnings.warn( "EMuMuTree: Expected branch m2ErsatzGenM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenM")
        else:
            self.m2ErsatzGenM_branch.SetAddress(<void*>&self.m2ErsatzGenM_value)

        #print "making m2ErsatzGenPhi"
        self.m2ErsatzGenPhi_branch = the_tree.GetBranch("m2ErsatzGenPhi")
        #if not self.m2ErsatzGenPhi_branch and "m2ErsatzGenPhi" not in self.complained:
        if not self.m2ErsatzGenPhi_branch and "m2ErsatzGenPhi":
            warnings.warn( "EMuMuTree: Expected branch m2ErsatzGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenPhi")
        else:
            self.m2ErsatzGenPhi_branch.SetAddress(<void*>&self.m2ErsatzGenPhi_value)

        #print "making m2ErsatzGenpT"
        self.m2ErsatzGenpT_branch = the_tree.GetBranch("m2ErsatzGenpT")
        #if not self.m2ErsatzGenpT_branch and "m2ErsatzGenpT" not in self.complained:
        if not self.m2ErsatzGenpT_branch and "m2ErsatzGenpT":
            warnings.warn( "EMuMuTree: Expected branch m2ErsatzGenpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenpT")
        else:
            self.m2ErsatzGenpT_branch.SetAddress(<void*>&self.m2ErsatzGenpT_value)

        #print "making m2ErsatzGenpX"
        self.m2ErsatzGenpX_branch = the_tree.GetBranch("m2ErsatzGenpX")
        #if not self.m2ErsatzGenpX_branch and "m2ErsatzGenpX" not in self.complained:
        if not self.m2ErsatzGenpX_branch and "m2ErsatzGenpX":
            warnings.warn( "EMuMuTree: Expected branch m2ErsatzGenpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenpX")
        else:
            self.m2ErsatzGenpX_branch.SetAddress(<void*>&self.m2ErsatzGenpX_value)

        #print "making m2ErsatzGenpY"
        self.m2ErsatzGenpY_branch = the_tree.GetBranch("m2ErsatzGenpY")
        #if not self.m2ErsatzGenpY_branch and "m2ErsatzGenpY" not in self.complained:
        if not self.m2ErsatzGenpY_branch and "m2ErsatzGenpY":
            warnings.warn( "EMuMuTree: Expected branch m2ErsatzGenpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenpY")
        else:
            self.m2ErsatzGenpY_branch.SetAddress(<void*>&self.m2ErsatzGenpY_value)

        #print "making m2ErsatzVispX"
        self.m2ErsatzVispX_branch = the_tree.GetBranch("m2ErsatzVispX")
        #if not self.m2ErsatzVispX_branch and "m2ErsatzVispX" not in self.complained:
        if not self.m2ErsatzVispX_branch and "m2ErsatzVispX":
            warnings.warn( "EMuMuTree: Expected branch m2ErsatzVispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzVispX")
        else:
            self.m2ErsatzVispX_branch.SetAddress(<void*>&self.m2ErsatzVispX_value)

        #print "making m2ErsatzVispY"
        self.m2ErsatzVispY_branch = the_tree.GetBranch("m2ErsatzVispY")
        #if not self.m2ErsatzVispY_branch and "m2ErsatzVispY" not in self.complained:
        if not self.m2ErsatzVispY_branch and "m2ErsatzVispY":
            warnings.warn( "EMuMuTree: Expected branch m2ErsatzVispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzVispY")
        else:
            self.m2ErsatzVispY_branch.SetAddress(<void*>&self.m2ErsatzVispY_value)

        #print "making m2Eta"
        self.m2Eta_branch = the_tree.GetBranch("m2Eta")
        #if not self.m2Eta_branch and "m2Eta" not in self.complained:
        if not self.m2Eta_branch and "m2Eta":
            warnings.warn( "EMuMuTree: Expected branch m2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta")
        else:
            self.m2Eta_branch.SetAddress(<void*>&self.m2Eta_value)

        #print "making m2Eta_MuonEnDown"
        self.m2Eta_MuonEnDown_branch = the_tree.GetBranch("m2Eta_MuonEnDown")
        #if not self.m2Eta_MuonEnDown_branch and "m2Eta_MuonEnDown" not in self.complained:
        if not self.m2Eta_MuonEnDown_branch and "m2Eta_MuonEnDown":
            warnings.warn( "EMuMuTree: Expected branch m2Eta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta_MuonEnDown")
        else:
            self.m2Eta_MuonEnDown_branch.SetAddress(<void*>&self.m2Eta_MuonEnDown_value)

        #print "making m2Eta_MuonEnUp"
        self.m2Eta_MuonEnUp_branch = the_tree.GetBranch("m2Eta_MuonEnUp")
        #if not self.m2Eta_MuonEnUp_branch and "m2Eta_MuonEnUp" not in self.complained:
        if not self.m2Eta_MuonEnUp_branch and "m2Eta_MuonEnUp":
            warnings.warn( "EMuMuTree: Expected branch m2Eta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta_MuonEnUp")
        else:
            self.m2Eta_MuonEnUp_branch.SetAddress(<void*>&self.m2Eta_MuonEnUp_value)

        #print "making m2GenCharge"
        self.m2GenCharge_branch = the_tree.GetBranch("m2GenCharge")
        #if not self.m2GenCharge_branch and "m2GenCharge" not in self.complained:
        if not self.m2GenCharge_branch and "m2GenCharge":
            warnings.warn( "EMuMuTree: Expected branch m2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenCharge")
        else:
            self.m2GenCharge_branch.SetAddress(<void*>&self.m2GenCharge_value)

        #print "making m2GenDirectPromptTauDecayFinalState"
        self.m2GenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("m2GenDirectPromptTauDecayFinalState")
        #if not self.m2GenDirectPromptTauDecayFinalState_branch and "m2GenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.m2GenDirectPromptTauDecayFinalState_branch and "m2GenDirectPromptTauDecayFinalState":
            warnings.warn( "EMuMuTree: Expected branch m2GenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenDirectPromptTauDecayFinalState")
        else:
            self.m2GenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.m2GenDirectPromptTauDecayFinalState_value)

        #print "making m2GenEnergy"
        self.m2GenEnergy_branch = the_tree.GetBranch("m2GenEnergy")
        #if not self.m2GenEnergy_branch and "m2GenEnergy" not in self.complained:
        if not self.m2GenEnergy_branch and "m2GenEnergy":
            warnings.warn( "EMuMuTree: Expected branch m2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEnergy")
        else:
            self.m2GenEnergy_branch.SetAddress(<void*>&self.m2GenEnergy_value)

        #print "making m2GenEta"
        self.m2GenEta_branch = the_tree.GetBranch("m2GenEta")
        #if not self.m2GenEta_branch and "m2GenEta" not in self.complained:
        if not self.m2GenEta_branch and "m2GenEta":
            warnings.warn( "EMuMuTree: Expected branch m2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEta")
        else:
            self.m2GenEta_branch.SetAddress(<void*>&self.m2GenEta_value)

        #print "making m2GenIsPrompt"
        self.m2GenIsPrompt_branch = the_tree.GetBranch("m2GenIsPrompt")
        #if not self.m2GenIsPrompt_branch and "m2GenIsPrompt" not in self.complained:
        if not self.m2GenIsPrompt_branch and "m2GenIsPrompt":
            warnings.warn( "EMuMuTree: Expected branch m2GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenIsPrompt")
        else:
            self.m2GenIsPrompt_branch.SetAddress(<void*>&self.m2GenIsPrompt_value)

        #print "making m2GenMotherPdgId"
        self.m2GenMotherPdgId_branch = the_tree.GetBranch("m2GenMotherPdgId")
        #if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId" not in self.complained:
        if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId":
            warnings.warn( "EMuMuTree: Expected branch m2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenMotherPdgId")
        else:
            self.m2GenMotherPdgId_branch.SetAddress(<void*>&self.m2GenMotherPdgId_value)

        #print "making m2GenParticle"
        self.m2GenParticle_branch = the_tree.GetBranch("m2GenParticle")
        #if not self.m2GenParticle_branch and "m2GenParticle" not in self.complained:
        if not self.m2GenParticle_branch and "m2GenParticle":
            warnings.warn( "EMuMuTree: Expected branch m2GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenParticle")
        else:
            self.m2GenParticle_branch.SetAddress(<void*>&self.m2GenParticle_value)

        #print "making m2GenPdgId"
        self.m2GenPdgId_branch = the_tree.GetBranch("m2GenPdgId")
        #if not self.m2GenPdgId_branch and "m2GenPdgId" not in self.complained:
        if not self.m2GenPdgId_branch and "m2GenPdgId":
            warnings.warn( "EMuMuTree: Expected branch m2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPdgId")
        else:
            self.m2GenPdgId_branch.SetAddress(<void*>&self.m2GenPdgId_value)

        #print "making m2GenPhi"
        self.m2GenPhi_branch = the_tree.GetBranch("m2GenPhi")
        #if not self.m2GenPhi_branch and "m2GenPhi" not in self.complained:
        if not self.m2GenPhi_branch and "m2GenPhi":
            warnings.warn( "EMuMuTree: Expected branch m2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPhi")
        else:
            self.m2GenPhi_branch.SetAddress(<void*>&self.m2GenPhi_value)

        #print "making m2GenPrompt"
        self.m2GenPrompt_branch = the_tree.GetBranch("m2GenPrompt")
        #if not self.m2GenPrompt_branch and "m2GenPrompt" not in self.complained:
        if not self.m2GenPrompt_branch and "m2GenPrompt":
            warnings.warn( "EMuMuTree: Expected branch m2GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPrompt")
        else:
            self.m2GenPrompt_branch.SetAddress(<void*>&self.m2GenPrompt_value)

        #print "making m2GenPromptFinalState"
        self.m2GenPromptFinalState_branch = the_tree.GetBranch("m2GenPromptFinalState")
        #if not self.m2GenPromptFinalState_branch and "m2GenPromptFinalState" not in self.complained:
        if not self.m2GenPromptFinalState_branch and "m2GenPromptFinalState":
            warnings.warn( "EMuMuTree: Expected branch m2GenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPromptFinalState")
        else:
            self.m2GenPromptFinalState_branch.SetAddress(<void*>&self.m2GenPromptFinalState_value)

        #print "making m2GenPromptTauDecay"
        self.m2GenPromptTauDecay_branch = the_tree.GetBranch("m2GenPromptTauDecay")
        #if not self.m2GenPromptTauDecay_branch and "m2GenPromptTauDecay" not in self.complained:
        if not self.m2GenPromptTauDecay_branch and "m2GenPromptTauDecay":
            warnings.warn( "EMuMuTree: Expected branch m2GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPromptTauDecay")
        else:
            self.m2GenPromptTauDecay_branch.SetAddress(<void*>&self.m2GenPromptTauDecay_value)

        #print "making m2GenPt"
        self.m2GenPt_branch = the_tree.GetBranch("m2GenPt")
        #if not self.m2GenPt_branch and "m2GenPt" not in self.complained:
        if not self.m2GenPt_branch and "m2GenPt":
            warnings.warn( "EMuMuTree: Expected branch m2GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPt")
        else:
            self.m2GenPt_branch.SetAddress(<void*>&self.m2GenPt_value)

        #print "making m2GenTauDecay"
        self.m2GenTauDecay_branch = the_tree.GetBranch("m2GenTauDecay")
        #if not self.m2GenTauDecay_branch and "m2GenTauDecay" not in self.complained:
        if not self.m2GenTauDecay_branch and "m2GenTauDecay":
            warnings.warn( "EMuMuTree: Expected branch m2GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenTauDecay")
        else:
            self.m2GenTauDecay_branch.SetAddress(<void*>&self.m2GenTauDecay_value)

        #print "making m2GenVZ"
        self.m2GenVZ_branch = the_tree.GetBranch("m2GenVZ")
        #if not self.m2GenVZ_branch and "m2GenVZ" not in self.complained:
        if not self.m2GenVZ_branch and "m2GenVZ":
            warnings.warn( "EMuMuTree: Expected branch m2GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenVZ")
        else:
            self.m2GenVZ_branch.SetAddress(<void*>&self.m2GenVZ_value)

        #print "making m2GenVtxPVMatch"
        self.m2GenVtxPVMatch_branch = the_tree.GetBranch("m2GenVtxPVMatch")
        #if not self.m2GenVtxPVMatch_branch and "m2GenVtxPVMatch" not in self.complained:
        if not self.m2GenVtxPVMatch_branch and "m2GenVtxPVMatch":
            warnings.warn( "EMuMuTree: Expected branch m2GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenVtxPVMatch")
        else:
            self.m2GenVtxPVMatch_branch.SetAddress(<void*>&self.m2GenVtxPVMatch_value)

        #print "making m2HcalIsoDR03"
        self.m2HcalIsoDR03_branch = the_tree.GetBranch("m2HcalIsoDR03")
        #if not self.m2HcalIsoDR03_branch and "m2HcalIsoDR03" not in self.complained:
        if not self.m2HcalIsoDR03_branch and "m2HcalIsoDR03":
            warnings.warn( "EMuMuTree: Expected branch m2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2HcalIsoDR03")
        else:
            self.m2HcalIsoDR03_branch.SetAddress(<void*>&self.m2HcalIsoDR03_value)

        #print "making m2IP3D"
        self.m2IP3D_branch = the_tree.GetBranch("m2IP3D")
        #if not self.m2IP3D_branch and "m2IP3D" not in self.complained:
        if not self.m2IP3D_branch and "m2IP3D":
            warnings.warn( "EMuMuTree: Expected branch m2IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3D")
        else:
            self.m2IP3D_branch.SetAddress(<void*>&self.m2IP3D_value)

        #print "making m2IP3DErr"
        self.m2IP3DErr_branch = the_tree.GetBranch("m2IP3DErr")
        #if not self.m2IP3DErr_branch and "m2IP3DErr" not in self.complained:
        if not self.m2IP3DErr_branch and "m2IP3DErr":
            warnings.warn( "EMuMuTree: Expected branch m2IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3DErr")
        else:
            self.m2IP3DErr_branch.SetAddress(<void*>&self.m2IP3DErr_value)

        #print "making m2IsGlobal"
        self.m2IsGlobal_branch = the_tree.GetBranch("m2IsGlobal")
        #if not self.m2IsGlobal_branch and "m2IsGlobal" not in self.complained:
        if not self.m2IsGlobal_branch and "m2IsGlobal":
            warnings.warn( "EMuMuTree: Expected branch m2IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsGlobal")
        else:
            self.m2IsGlobal_branch.SetAddress(<void*>&self.m2IsGlobal_value)

        #print "making m2IsPFMuon"
        self.m2IsPFMuon_branch = the_tree.GetBranch("m2IsPFMuon")
        #if not self.m2IsPFMuon_branch and "m2IsPFMuon" not in self.complained:
        if not self.m2IsPFMuon_branch and "m2IsPFMuon":
            warnings.warn( "EMuMuTree: Expected branch m2IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsPFMuon")
        else:
            self.m2IsPFMuon_branch.SetAddress(<void*>&self.m2IsPFMuon_value)

        #print "making m2IsTracker"
        self.m2IsTracker_branch = the_tree.GetBranch("m2IsTracker")
        #if not self.m2IsTracker_branch and "m2IsTracker" not in self.complained:
        if not self.m2IsTracker_branch and "m2IsTracker":
            warnings.warn( "EMuMuTree: Expected branch m2IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsTracker")
        else:
            self.m2IsTracker_branch.SetAddress(<void*>&self.m2IsTracker_value)

        #print "making m2IsoDB03"
        self.m2IsoDB03_branch = the_tree.GetBranch("m2IsoDB03")
        #if not self.m2IsoDB03_branch and "m2IsoDB03" not in self.complained:
        if not self.m2IsoDB03_branch and "m2IsoDB03":
            warnings.warn( "EMuMuTree: Expected branch m2IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoDB03")
        else:
            self.m2IsoDB03_branch.SetAddress(<void*>&self.m2IsoDB03_value)

        #print "making m2IsoDB04"
        self.m2IsoDB04_branch = the_tree.GetBranch("m2IsoDB04")
        #if not self.m2IsoDB04_branch and "m2IsoDB04" not in self.complained:
        if not self.m2IsoDB04_branch and "m2IsoDB04":
            warnings.warn( "EMuMuTree: Expected branch m2IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoDB04")
        else:
            self.m2IsoDB04_branch.SetAddress(<void*>&self.m2IsoDB04_value)

        #print "making m2IsoMu22Filter"
        self.m2IsoMu22Filter_branch = the_tree.GetBranch("m2IsoMu22Filter")
        #if not self.m2IsoMu22Filter_branch and "m2IsoMu22Filter" not in self.complained:
        if not self.m2IsoMu22Filter_branch and "m2IsoMu22Filter":
            warnings.warn( "EMuMuTree: Expected branch m2IsoMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoMu22Filter")
        else:
            self.m2IsoMu22Filter_branch.SetAddress(<void*>&self.m2IsoMu22Filter_value)

        #print "making m2IsoMu22eta2p1Filter"
        self.m2IsoMu22eta2p1Filter_branch = the_tree.GetBranch("m2IsoMu22eta2p1Filter")
        #if not self.m2IsoMu22eta2p1Filter_branch and "m2IsoMu22eta2p1Filter" not in self.complained:
        if not self.m2IsoMu22eta2p1Filter_branch and "m2IsoMu22eta2p1Filter":
            warnings.warn( "EMuMuTree: Expected branch m2IsoMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoMu22eta2p1Filter")
        else:
            self.m2IsoMu22eta2p1Filter_branch.SetAddress(<void*>&self.m2IsoMu22eta2p1Filter_value)

        #print "making m2IsoMu24Filter"
        self.m2IsoMu24Filter_branch = the_tree.GetBranch("m2IsoMu24Filter")
        #if not self.m2IsoMu24Filter_branch and "m2IsoMu24Filter" not in self.complained:
        if not self.m2IsoMu24Filter_branch and "m2IsoMu24Filter":
            warnings.warn( "EMuMuTree: Expected branch m2IsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoMu24Filter")
        else:
            self.m2IsoMu24Filter_branch.SetAddress(<void*>&self.m2IsoMu24Filter_value)

        #print "making m2IsoMu24eta2p1Filter"
        self.m2IsoMu24eta2p1Filter_branch = the_tree.GetBranch("m2IsoMu24eta2p1Filter")
        #if not self.m2IsoMu24eta2p1Filter_branch and "m2IsoMu24eta2p1Filter" not in self.complained:
        if not self.m2IsoMu24eta2p1Filter_branch and "m2IsoMu24eta2p1Filter":
            warnings.warn( "EMuMuTree: Expected branch m2IsoMu24eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoMu24eta2p1Filter")
        else:
            self.m2IsoMu24eta2p1Filter_branch.SetAddress(<void*>&self.m2IsoMu24eta2p1Filter_value)

        #print "making m2IsoTkMu22Filter"
        self.m2IsoTkMu22Filter_branch = the_tree.GetBranch("m2IsoTkMu22Filter")
        #if not self.m2IsoTkMu22Filter_branch and "m2IsoTkMu22Filter" not in self.complained:
        if not self.m2IsoTkMu22Filter_branch and "m2IsoTkMu22Filter":
            warnings.warn( "EMuMuTree: Expected branch m2IsoTkMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoTkMu22Filter")
        else:
            self.m2IsoTkMu22Filter_branch.SetAddress(<void*>&self.m2IsoTkMu22Filter_value)

        #print "making m2IsoTkMu22eta2p1Filter"
        self.m2IsoTkMu22eta2p1Filter_branch = the_tree.GetBranch("m2IsoTkMu22eta2p1Filter")
        #if not self.m2IsoTkMu22eta2p1Filter_branch and "m2IsoTkMu22eta2p1Filter" not in self.complained:
        if not self.m2IsoTkMu22eta2p1Filter_branch and "m2IsoTkMu22eta2p1Filter":
            warnings.warn( "EMuMuTree: Expected branch m2IsoTkMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoTkMu22eta2p1Filter")
        else:
            self.m2IsoTkMu22eta2p1Filter_branch.SetAddress(<void*>&self.m2IsoTkMu22eta2p1Filter_value)

        #print "making m2IsoTkMu24Filter"
        self.m2IsoTkMu24Filter_branch = the_tree.GetBranch("m2IsoTkMu24Filter")
        #if not self.m2IsoTkMu24Filter_branch and "m2IsoTkMu24Filter" not in self.complained:
        if not self.m2IsoTkMu24Filter_branch and "m2IsoTkMu24Filter":
            warnings.warn( "EMuMuTree: Expected branch m2IsoTkMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoTkMu24Filter")
        else:
            self.m2IsoTkMu24Filter_branch.SetAddress(<void*>&self.m2IsoTkMu24Filter_value)

        #print "making m2IsoTkMu24eta2p1Filter"
        self.m2IsoTkMu24eta2p1Filter_branch = the_tree.GetBranch("m2IsoTkMu24eta2p1Filter")
        #if not self.m2IsoTkMu24eta2p1Filter_branch and "m2IsoTkMu24eta2p1Filter" not in self.complained:
        if not self.m2IsoTkMu24eta2p1Filter_branch and "m2IsoTkMu24eta2p1Filter":
            warnings.warn( "EMuMuTree: Expected branch m2IsoTkMu24eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoTkMu24eta2p1Filter")
        else:
            self.m2IsoTkMu24eta2p1Filter_branch.SetAddress(<void*>&self.m2IsoTkMu24eta2p1Filter_value)

        #print "making m2JetArea"
        self.m2JetArea_branch = the_tree.GetBranch("m2JetArea")
        #if not self.m2JetArea_branch and "m2JetArea" not in self.complained:
        if not self.m2JetArea_branch and "m2JetArea":
            warnings.warn( "EMuMuTree: Expected branch m2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetArea")
        else:
            self.m2JetArea_branch.SetAddress(<void*>&self.m2JetArea_value)

        #print "making m2JetBtag"
        self.m2JetBtag_branch = the_tree.GetBranch("m2JetBtag")
        #if not self.m2JetBtag_branch and "m2JetBtag" not in self.complained:
        if not self.m2JetBtag_branch and "m2JetBtag":
            warnings.warn( "EMuMuTree: Expected branch m2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetBtag")
        else:
            self.m2JetBtag_branch.SetAddress(<void*>&self.m2JetBtag_value)

        #print "making m2JetEtaEtaMoment"
        self.m2JetEtaEtaMoment_branch = the_tree.GetBranch("m2JetEtaEtaMoment")
        #if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment" not in self.complained:
        if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment":
            warnings.warn( "EMuMuTree: Expected branch m2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaEtaMoment")
        else:
            self.m2JetEtaEtaMoment_branch.SetAddress(<void*>&self.m2JetEtaEtaMoment_value)

        #print "making m2JetEtaPhiMoment"
        self.m2JetEtaPhiMoment_branch = the_tree.GetBranch("m2JetEtaPhiMoment")
        #if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment" not in self.complained:
        if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment":
            warnings.warn( "EMuMuTree: Expected branch m2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiMoment")
        else:
            self.m2JetEtaPhiMoment_branch.SetAddress(<void*>&self.m2JetEtaPhiMoment_value)

        #print "making m2JetEtaPhiSpread"
        self.m2JetEtaPhiSpread_branch = the_tree.GetBranch("m2JetEtaPhiSpread")
        #if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread" not in self.complained:
        if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread":
            warnings.warn( "EMuMuTree: Expected branch m2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiSpread")
        else:
            self.m2JetEtaPhiSpread_branch.SetAddress(<void*>&self.m2JetEtaPhiSpread_value)

        #print "making m2JetHadronFlavour"
        self.m2JetHadronFlavour_branch = the_tree.GetBranch("m2JetHadronFlavour")
        #if not self.m2JetHadronFlavour_branch and "m2JetHadronFlavour" not in self.complained:
        if not self.m2JetHadronFlavour_branch and "m2JetHadronFlavour":
            warnings.warn( "EMuMuTree: Expected branch m2JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetHadronFlavour")
        else:
            self.m2JetHadronFlavour_branch.SetAddress(<void*>&self.m2JetHadronFlavour_value)

        #print "making m2JetPFCISVBtag"
        self.m2JetPFCISVBtag_branch = the_tree.GetBranch("m2JetPFCISVBtag")
        #if not self.m2JetPFCISVBtag_branch and "m2JetPFCISVBtag" not in self.complained:
        if not self.m2JetPFCISVBtag_branch and "m2JetPFCISVBtag":
            warnings.warn( "EMuMuTree: Expected branch m2JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPFCISVBtag")
        else:
            self.m2JetPFCISVBtag_branch.SetAddress(<void*>&self.m2JetPFCISVBtag_value)

        #print "making m2JetPartonFlavour"
        self.m2JetPartonFlavour_branch = the_tree.GetBranch("m2JetPartonFlavour")
        #if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour" not in self.complained:
        if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour":
            warnings.warn( "EMuMuTree: Expected branch m2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPartonFlavour")
        else:
            self.m2JetPartonFlavour_branch.SetAddress(<void*>&self.m2JetPartonFlavour_value)

        #print "making m2JetPhiPhiMoment"
        self.m2JetPhiPhiMoment_branch = the_tree.GetBranch("m2JetPhiPhiMoment")
        #if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment" not in self.complained:
        if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment":
            warnings.warn( "EMuMuTree: Expected branch m2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPhiPhiMoment")
        else:
            self.m2JetPhiPhiMoment_branch.SetAddress(<void*>&self.m2JetPhiPhiMoment_value)

        #print "making m2JetPt"
        self.m2JetPt_branch = the_tree.GetBranch("m2JetPt")
        #if not self.m2JetPt_branch and "m2JetPt" not in self.complained:
        if not self.m2JetPt_branch and "m2JetPt":
            warnings.warn( "EMuMuTree: Expected branch m2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPt")
        else:
            self.m2JetPt_branch.SetAddress(<void*>&self.m2JetPt_value)

        #print "making m2LowestMll"
        self.m2LowestMll_branch = the_tree.GetBranch("m2LowestMll")
        #if not self.m2LowestMll_branch and "m2LowestMll" not in self.complained:
        if not self.m2LowestMll_branch and "m2LowestMll":
            warnings.warn( "EMuMuTree: Expected branch m2LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2LowestMll")
        else:
            self.m2LowestMll_branch.SetAddress(<void*>&self.m2LowestMll_value)

        #print "making m2Mass"
        self.m2Mass_branch = the_tree.GetBranch("m2Mass")
        #if not self.m2Mass_branch and "m2Mass" not in self.complained:
        if not self.m2Mass_branch and "m2Mass":
            warnings.warn( "EMuMuTree: Expected branch m2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mass")
        else:
            self.m2Mass_branch.SetAddress(<void*>&self.m2Mass_value)

        #print "making m2MatchedStations"
        self.m2MatchedStations_branch = the_tree.GetBranch("m2MatchedStations")
        #if not self.m2MatchedStations_branch and "m2MatchedStations" not in self.complained:
        if not self.m2MatchedStations_branch and "m2MatchedStations":
            warnings.warn( "EMuMuTree: Expected branch m2MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchedStations")
        else:
            self.m2MatchedStations_branch.SetAddress(<void*>&self.m2MatchedStations_value)

        #print "making m2MatchesDoubleESingleMu"
        self.m2MatchesDoubleESingleMu_branch = the_tree.GetBranch("m2MatchesDoubleESingleMu")
        #if not self.m2MatchesDoubleESingleMu_branch and "m2MatchesDoubleESingleMu" not in self.complained:
        if not self.m2MatchesDoubleESingleMu_branch and "m2MatchesDoubleESingleMu":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesDoubleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleESingleMu")
        else:
            self.m2MatchesDoubleESingleMu_branch.SetAddress(<void*>&self.m2MatchesDoubleESingleMu_value)

        #print "making m2MatchesDoubleMu"
        self.m2MatchesDoubleMu_branch = the_tree.GetBranch("m2MatchesDoubleMu")
        #if not self.m2MatchesDoubleMu_branch and "m2MatchesDoubleMu" not in self.complained:
        if not self.m2MatchesDoubleMu_branch and "m2MatchesDoubleMu":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesDoubleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMu")
        else:
            self.m2MatchesDoubleMu_branch.SetAddress(<void*>&self.m2MatchesDoubleMu_value)

        #print "making m2MatchesDoubleMuSingleE"
        self.m2MatchesDoubleMuSingleE_branch = the_tree.GetBranch("m2MatchesDoubleMuSingleE")
        #if not self.m2MatchesDoubleMuSingleE_branch and "m2MatchesDoubleMuSingleE" not in self.complained:
        if not self.m2MatchesDoubleMuSingleE_branch and "m2MatchesDoubleMuSingleE":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesDoubleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMuSingleE")
        else:
            self.m2MatchesDoubleMuSingleE_branch.SetAddress(<void*>&self.m2MatchesDoubleMuSingleE_value)

        #print "making m2MatchesIsoMu22Path"
        self.m2MatchesIsoMu22Path_branch = the_tree.GetBranch("m2MatchesIsoMu22Path")
        #if not self.m2MatchesIsoMu22Path_branch and "m2MatchesIsoMu22Path" not in self.complained:
        if not self.m2MatchesIsoMu22Path_branch and "m2MatchesIsoMu22Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesIsoMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu22Path")
        else:
            self.m2MatchesIsoMu22Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu22Path_value)

        #print "making m2MatchesIsoMu22eta2p1Path"
        self.m2MatchesIsoMu22eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoMu22eta2p1Path")
        #if not self.m2MatchesIsoMu22eta2p1Path_branch and "m2MatchesIsoMu22eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoMu22eta2p1Path_branch and "m2MatchesIsoMu22eta2p1Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesIsoMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu22eta2p1Path")
        else:
            self.m2MatchesIsoMu22eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu22eta2p1Path_value)

        #print "making m2MatchesIsoMu24Path"
        self.m2MatchesIsoMu24Path_branch = the_tree.GetBranch("m2MatchesIsoMu24Path")
        #if not self.m2MatchesIsoMu24Path_branch and "m2MatchesIsoMu24Path" not in self.complained:
        if not self.m2MatchesIsoMu24Path_branch and "m2MatchesIsoMu24Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24Path")
        else:
            self.m2MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu24Path_value)

        #print "making m2MatchesIsoMu24eta2p1Path"
        self.m2MatchesIsoMu24eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoMu24eta2p1Path")
        #if not self.m2MatchesIsoMu24eta2p1Path_branch and "m2MatchesIsoMu24eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoMu24eta2p1Path_branch and "m2MatchesIsoMu24eta2p1Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesIsoMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24eta2p1Path")
        else:
            self.m2MatchesIsoMu24eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu24eta2p1Path_value)

        #print "making m2MatchesIsoTkMu22Path"
        self.m2MatchesIsoTkMu22Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu22Path")
        #if not self.m2MatchesIsoTkMu22Path_branch and "m2MatchesIsoTkMu22Path" not in self.complained:
        if not self.m2MatchesIsoTkMu22Path_branch and "m2MatchesIsoTkMu22Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesIsoTkMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu22Path")
        else:
            self.m2MatchesIsoTkMu22Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu22Path_value)

        #print "making m2MatchesIsoTkMu22eta2p1Path"
        self.m2MatchesIsoTkMu22eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu22eta2p1Path")
        #if not self.m2MatchesIsoTkMu22eta2p1Path_branch and "m2MatchesIsoTkMu22eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoTkMu22eta2p1Path_branch and "m2MatchesIsoTkMu22eta2p1Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesIsoTkMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu22eta2p1Path")
        else:
            self.m2MatchesIsoTkMu22eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu22eta2p1Path_value)

        #print "making m2MatchesIsoTkMu24Path"
        self.m2MatchesIsoTkMu24Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu24Path")
        #if not self.m2MatchesIsoTkMu24Path_branch and "m2MatchesIsoTkMu24Path" not in self.complained:
        if not self.m2MatchesIsoTkMu24Path_branch and "m2MatchesIsoTkMu24Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesIsoTkMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu24Path")
        else:
            self.m2MatchesIsoTkMu24Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu24Path_value)

        #print "making m2MatchesIsoTkMu24eta2p1Path"
        self.m2MatchesIsoTkMu24eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu24eta2p1Path")
        #if not self.m2MatchesIsoTkMu24eta2p1Path_branch and "m2MatchesIsoTkMu24eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoTkMu24eta2p1Path_branch and "m2MatchesIsoTkMu24eta2p1Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesIsoTkMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu24eta2p1Path")
        else:
            self.m2MatchesIsoTkMu24eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu24eta2p1Path_value)

        #print "making m2MatchesMu19Tau20Filter"
        self.m2MatchesMu19Tau20Filter_branch = the_tree.GetBranch("m2MatchesMu19Tau20Filter")
        #if not self.m2MatchesMu19Tau20Filter_branch and "m2MatchesMu19Tau20Filter" not in self.complained:
        if not self.m2MatchesMu19Tau20Filter_branch and "m2MatchesMu19Tau20Filter":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu19Tau20Filter")
        else:
            self.m2MatchesMu19Tau20Filter_branch.SetAddress(<void*>&self.m2MatchesMu19Tau20Filter_value)

        #print "making m2MatchesMu19Tau20Path"
        self.m2MatchesMu19Tau20Path_branch = the_tree.GetBranch("m2MatchesMu19Tau20Path")
        #if not self.m2MatchesMu19Tau20Path_branch and "m2MatchesMu19Tau20Path" not in self.complained:
        if not self.m2MatchesMu19Tau20Path_branch and "m2MatchesMu19Tau20Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu19Tau20Path")
        else:
            self.m2MatchesMu19Tau20Path_branch.SetAddress(<void*>&self.m2MatchesMu19Tau20Path_value)

        #print "making m2MatchesMu19Tau20sL1Filter"
        self.m2MatchesMu19Tau20sL1Filter_branch = the_tree.GetBranch("m2MatchesMu19Tau20sL1Filter")
        #if not self.m2MatchesMu19Tau20sL1Filter_branch and "m2MatchesMu19Tau20sL1Filter" not in self.complained:
        if not self.m2MatchesMu19Tau20sL1Filter_branch and "m2MatchesMu19Tau20sL1Filter":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesMu19Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu19Tau20sL1Filter")
        else:
            self.m2MatchesMu19Tau20sL1Filter_branch.SetAddress(<void*>&self.m2MatchesMu19Tau20sL1Filter_value)

        #print "making m2MatchesMu19Tau20sL1Path"
        self.m2MatchesMu19Tau20sL1Path_branch = the_tree.GetBranch("m2MatchesMu19Tau20sL1Path")
        #if not self.m2MatchesMu19Tau20sL1Path_branch and "m2MatchesMu19Tau20sL1Path" not in self.complained:
        if not self.m2MatchesMu19Tau20sL1Path_branch and "m2MatchesMu19Tau20sL1Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesMu19Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu19Tau20sL1Path")
        else:
            self.m2MatchesMu19Tau20sL1Path_branch.SetAddress(<void*>&self.m2MatchesMu19Tau20sL1Path_value)

        #print "making m2MatchesMu21Tau20sL1Filter"
        self.m2MatchesMu21Tau20sL1Filter_branch = the_tree.GetBranch("m2MatchesMu21Tau20sL1Filter")
        #if not self.m2MatchesMu21Tau20sL1Filter_branch and "m2MatchesMu21Tau20sL1Filter" not in self.complained:
        if not self.m2MatchesMu21Tau20sL1Filter_branch and "m2MatchesMu21Tau20sL1Filter":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesMu21Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu21Tau20sL1Filter")
        else:
            self.m2MatchesMu21Tau20sL1Filter_branch.SetAddress(<void*>&self.m2MatchesMu21Tau20sL1Filter_value)

        #print "making m2MatchesMu21Tau20sL1Path"
        self.m2MatchesMu21Tau20sL1Path_branch = the_tree.GetBranch("m2MatchesMu21Tau20sL1Path")
        #if not self.m2MatchesMu21Tau20sL1Path_branch and "m2MatchesMu21Tau20sL1Path" not in self.complained:
        if not self.m2MatchesMu21Tau20sL1Path_branch and "m2MatchesMu21Tau20sL1Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesMu21Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu21Tau20sL1Path")
        else:
            self.m2MatchesMu21Tau20sL1Path_branch.SetAddress(<void*>&self.m2MatchesMu21Tau20sL1Path_value)

        #print "making m2MatchesMu23Ele12DZPath"
        self.m2MatchesMu23Ele12DZPath_branch = the_tree.GetBranch("m2MatchesMu23Ele12DZPath")
        #if not self.m2MatchesMu23Ele12DZPath_branch and "m2MatchesMu23Ele12DZPath" not in self.complained:
        if not self.m2MatchesMu23Ele12DZPath_branch and "m2MatchesMu23Ele12DZPath":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesMu23Ele12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu23Ele12DZPath")
        else:
            self.m2MatchesMu23Ele12DZPath_branch.SetAddress(<void*>&self.m2MatchesMu23Ele12DZPath_value)

        #print "making m2MatchesMu23Ele12Path"
        self.m2MatchesMu23Ele12Path_branch = the_tree.GetBranch("m2MatchesMu23Ele12Path")
        #if not self.m2MatchesMu23Ele12Path_branch and "m2MatchesMu23Ele12Path" not in self.complained:
        if not self.m2MatchesMu23Ele12Path_branch and "m2MatchesMu23Ele12Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesMu23Ele12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu23Ele12Path")
        else:
            self.m2MatchesMu23Ele12Path_branch.SetAddress(<void*>&self.m2MatchesMu23Ele12Path_value)

        #print "making m2MatchesMu8Ele23DZPath"
        self.m2MatchesMu8Ele23DZPath_branch = the_tree.GetBranch("m2MatchesMu8Ele23DZPath")
        #if not self.m2MatchesMu8Ele23DZPath_branch and "m2MatchesMu8Ele23DZPath" not in self.complained:
        if not self.m2MatchesMu8Ele23DZPath_branch and "m2MatchesMu8Ele23DZPath":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesMu8Ele23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele23DZPath")
        else:
            self.m2MatchesMu8Ele23DZPath_branch.SetAddress(<void*>&self.m2MatchesMu8Ele23DZPath_value)

        #print "making m2MatchesMu8Ele23Path"
        self.m2MatchesMu8Ele23Path_branch = the_tree.GetBranch("m2MatchesMu8Ele23Path")
        #if not self.m2MatchesMu8Ele23Path_branch and "m2MatchesMu8Ele23Path" not in self.complained:
        if not self.m2MatchesMu8Ele23Path_branch and "m2MatchesMu8Ele23Path":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesMu8Ele23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele23Path")
        else:
            self.m2MatchesMu8Ele23Path_branch.SetAddress(<void*>&self.m2MatchesMu8Ele23Path_value)

        #print "making m2MatchesSingleESingleMu"
        self.m2MatchesSingleESingleMu_branch = the_tree.GetBranch("m2MatchesSingleESingleMu")
        #if not self.m2MatchesSingleESingleMu_branch and "m2MatchesSingleESingleMu" not in self.complained:
        if not self.m2MatchesSingleESingleMu_branch and "m2MatchesSingleESingleMu":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesSingleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleESingleMu")
        else:
            self.m2MatchesSingleESingleMu_branch.SetAddress(<void*>&self.m2MatchesSingleESingleMu_value)

        #print "making m2MatchesSingleMu"
        self.m2MatchesSingleMu_branch = the_tree.GetBranch("m2MatchesSingleMu")
        #if not self.m2MatchesSingleMu_branch and "m2MatchesSingleMu" not in self.complained:
        if not self.m2MatchesSingleMu_branch and "m2MatchesSingleMu":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesSingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu")
        else:
            self.m2MatchesSingleMu_branch.SetAddress(<void*>&self.m2MatchesSingleMu_value)

        #print "making m2MatchesSingleMuIso20"
        self.m2MatchesSingleMuIso20_branch = the_tree.GetBranch("m2MatchesSingleMuIso20")
        #if not self.m2MatchesSingleMuIso20_branch and "m2MatchesSingleMuIso20" not in self.complained:
        if not self.m2MatchesSingleMuIso20_branch and "m2MatchesSingleMuIso20":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesSingleMuIso20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMuIso20")
        else:
            self.m2MatchesSingleMuIso20_branch.SetAddress(<void*>&self.m2MatchesSingleMuIso20_value)

        #print "making m2MatchesSingleMuIsoTk20"
        self.m2MatchesSingleMuIsoTk20_branch = the_tree.GetBranch("m2MatchesSingleMuIsoTk20")
        #if not self.m2MatchesSingleMuIsoTk20_branch and "m2MatchesSingleMuIsoTk20" not in self.complained:
        if not self.m2MatchesSingleMuIsoTk20_branch and "m2MatchesSingleMuIsoTk20":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesSingleMuIsoTk20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMuIsoTk20")
        else:
            self.m2MatchesSingleMuIsoTk20_branch.SetAddress(<void*>&self.m2MatchesSingleMuIsoTk20_value)

        #print "making m2MatchesSingleMuSingleE"
        self.m2MatchesSingleMuSingleE_branch = the_tree.GetBranch("m2MatchesSingleMuSingleE")
        #if not self.m2MatchesSingleMuSingleE_branch and "m2MatchesSingleMuSingleE" not in self.complained:
        if not self.m2MatchesSingleMuSingleE_branch and "m2MatchesSingleMuSingleE":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesSingleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMuSingleE")
        else:
            self.m2MatchesSingleMuSingleE_branch.SetAddress(<void*>&self.m2MatchesSingleMuSingleE_value)

        #print "making m2MatchesSingleMu_leg1"
        self.m2MatchesSingleMu_leg1_branch = the_tree.GetBranch("m2MatchesSingleMu_leg1")
        #if not self.m2MatchesSingleMu_leg1_branch and "m2MatchesSingleMu_leg1" not in self.complained:
        if not self.m2MatchesSingleMu_leg1_branch and "m2MatchesSingleMu_leg1":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesSingleMu_leg1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu_leg1")
        else:
            self.m2MatchesSingleMu_leg1_branch.SetAddress(<void*>&self.m2MatchesSingleMu_leg1_value)

        #print "making m2MatchesSingleMu_leg1_noiso"
        self.m2MatchesSingleMu_leg1_noiso_branch = the_tree.GetBranch("m2MatchesSingleMu_leg1_noiso")
        #if not self.m2MatchesSingleMu_leg1_noiso_branch and "m2MatchesSingleMu_leg1_noiso" not in self.complained:
        if not self.m2MatchesSingleMu_leg1_noiso_branch and "m2MatchesSingleMu_leg1_noiso":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesSingleMu_leg1_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu_leg1_noiso")
        else:
            self.m2MatchesSingleMu_leg1_noiso_branch.SetAddress(<void*>&self.m2MatchesSingleMu_leg1_noiso_value)

        #print "making m2MatchesSingleMu_leg2"
        self.m2MatchesSingleMu_leg2_branch = the_tree.GetBranch("m2MatchesSingleMu_leg2")
        #if not self.m2MatchesSingleMu_leg2_branch and "m2MatchesSingleMu_leg2" not in self.complained:
        if not self.m2MatchesSingleMu_leg2_branch and "m2MatchesSingleMu_leg2":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesSingleMu_leg2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu_leg2")
        else:
            self.m2MatchesSingleMu_leg2_branch.SetAddress(<void*>&self.m2MatchesSingleMu_leg2_value)

        #print "making m2MatchesSingleMu_leg2_noiso"
        self.m2MatchesSingleMu_leg2_noiso_branch = the_tree.GetBranch("m2MatchesSingleMu_leg2_noiso")
        #if not self.m2MatchesSingleMu_leg2_noiso_branch and "m2MatchesSingleMu_leg2_noiso" not in self.complained:
        if not self.m2MatchesSingleMu_leg2_noiso_branch and "m2MatchesSingleMu_leg2_noiso":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesSingleMu_leg2_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu_leg2_noiso")
        else:
            self.m2MatchesSingleMu_leg2_noiso_branch.SetAddress(<void*>&self.m2MatchesSingleMu_leg2_noiso_value)

        #print "making m2MatchesTripleMu"
        self.m2MatchesTripleMu_branch = the_tree.GetBranch("m2MatchesTripleMu")
        #if not self.m2MatchesTripleMu_branch and "m2MatchesTripleMu" not in self.complained:
        if not self.m2MatchesTripleMu_branch and "m2MatchesTripleMu":
            warnings.warn( "EMuMuTree: Expected branch m2MatchesTripleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesTripleMu")
        else:
            self.m2MatchesTripleMu_branch.SetAddress(<void*>&self.m2MatchesTripleMu_value)

        #print "making m2MtToPfMet_type1"
        self.m2MtToPfMet_type1_branch = the_tree.GetBranch("m2MtToPfMet_type1")
        #if not self.m2MtToPfMet_type1_branch and "m2MtToPfMet_type1" not in self.complained:
        if not self.m2MtToPfMet_type1_branch and "m2MtToPfMet_type1":
            warnings.warn( "EMuMuTree: Expected branch m2MtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_type1")
        else:
            self.m2MtToPfMet_type1_branch.SetAddress(<void*>&self.m2MtToPfMet_type1_value)

        #print "making m2Mu23Ele12DZFilter"
        self.m2Mu23Ele12DZFilter_branch = the_tree.GetBranch("m2Mu23Ele12DZFilter")
        #if not self.m2Mu23Ele12DZFilter_branch and "m2Mu23Ele12DZFilter" not in self.complained:
        if not self.m2Mu23Ele12DZFilter_branch and "m2Mu23Ele12DZFilter":
            warnings.warn( "EMuMuTree: Expected branch m2Mu23Ele12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu23Ele12DZFilter")
        else:
            self.m2Mu23Ele12DZFilter_branch.SetAddress(<void*>&self.m2Mu23Ele12DZFilter_value)

        #print "making m2Mu23Ele12Filter"
        self.m2Mu23Ele12Filter_branch = the_tree.GetBranch("m2Mu23Ele12Filter")
        #if not self.m2Mu23Ele12Filter_branch and "m2Mu23Ele12Filter" not in self.complained:
        if not self.m2Mu23Ele12Filter_branch and "m2Mu23Ele12Filter":
            warnings.warn( "EMuMuTree: Expected branch m2Mu23Ele12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu23Ele12Filter")
        else:
            self.m2Mu23Ele12Filter_branch.SetAddress(<void*>&self.m2Mu23Ele12Filter_value)

        #print "making m2Mu8Ele23DZFilter"
        self.m2Mu8Ele23DZFilter_branch = the_tree.GetBranch("m2Mu8Ele23DZFilter")
        #if not self.m2Mu8Ele23DZFilter_branch and "m2Mu8Ele23DZFilter" not in self.complained:
        if not self.m2Mu8Ele23DZFilter_branch and "m2Mu8Ele23DZFilter":
            warnings.warn( "EMuMuTree: Expected branch m2Mu8Ele23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu8Ele23DZFilter")
        else:
            self.m2Mu8Ele23DZFilter_branch.SetAddress(<void*>&self.m2Mu8Ele23DZFilter_value)

        #print "making m2Mu8Ele23Filter"
        self.m2Mu8Ele23Filter_branch = the_tree.GetBranch("m2Mu8Ele23Filter")
        #if not self.m2Mu8Ele23Filter_branch and "m2Mu8Ele23Filter" not in self.complained:
        if not self.m2Mu8Ele23Filter_branch and "m2Mu8Ele23Filter":
            warnings.warn( "EMuMuTree: Expected branch m2Mu8Ele23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu8Ele23Filter")
        else:
            self.m2Mu8Ele23Filter_branch.SetAddress(<void*>&self.m2Mu8Ele23Filter_value)

        #print "making m2MuonHits"
        self.m2MuonHits_branch = the_tree.GetBranch("m2MuonHits")
        #if not self.m2MuonHits_branch and "m2MuonHits" not in self.complained:
        if not self.m2MuonHits_branch and "m2MuonHits":
            warnings.warn( "EMuMuTree: Expected branch m2MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MuonHits")
        else:
            self.m2MuonHits_branch.SetAddress(<void*>&self.m2MuonHits_value)

        #print "making m2NearestZMass"
        self.m2NearestZMass_branch = the_tree.GetBranch("m2NearestZMass")
        #if not self.m2NearestZMass_branch and "m2NearestZMass" not in self.complained:
        if not self.m2NearestZMass_branch and "m2NearestZMass":
            warnings.warn( "EMuMuTree: Expected branch m2NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NearestZMass")
        else:
            self.m2NearestZMass_branch.SetAddress(<void*>&self.m2NearestZMass_value)

        #print "making m2NormTrkChi2"
        self.m2NormTrkChi2_branch = the_tree.GetBranch("m2NormTrkChi2")
        #if not self.m2NormTrkChi2_branch and "m2NormTrkChi2" not in self.complained:
        if not self.m2NormTrkChi2_branch and "m2NormTrkChi2":
            warnings.warn( "EMuMuTree: Expected branch m2NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormTrkChi2")
        else:
            self.m2NormTrkChi2_branch.SetAddress(<void*>&self.m2NormTrkChi2_value)

        #print "making m2NormalizedChi2"
        self.m2NormalizedChi2_branch = the_tree.GetBranch("m2NormalizedChi2")
        #if not self.m2NormalizedChi2_branch and "m2NormalizedChi2" not in self.complained:
        if not self.m2NormalizedChi2_branch and "m2NormalizedChi2":
            warnings.warn( "EMuMuTree: Expected branch m2NormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormalizedChi2")
        else:
            self.m2NormalizedChi2_branch.SetAddress(<void*>&self.m2NormalizedChi2_value)

        #print "making m2PFChargedHadronIsoR04"
        self.m2PFChargedHadronIsoR04_branch = the_tree.GetBranch("m2PFChargedHadronIsoR04")
        #if not self.m2PFChargedHadronIsoR04_branch and "m2PFChargedHadronIsoR04" not in self.complained:
        if not self.m2PFChargedHadronIsoR04_branch and "m2PFChargedHadronIsoR04":
            warnings.warn( "EMuMuTree: Expected branch m2PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedHadronIsoR04")
        else:
            self.m2PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m2PFChargedHadronIsoR04_value)

        #print "making m2PFChargedIso"
        self.m2PFChargedIso_branch = the_tree.GetBranch("m2PFChargedIso")
        #if not self.m2PFChargedIso_branch and "m2PFChargedIso" not in self.complained:
        if not self.m2PFChargedIso_branch and "m2PFChargedIso":
            warnings.warn( "EMuMuTree: Expected branch m2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedIso")
        else:
            self.m2PFChargedIso_branch.SetAddress(<void*>&self.m2PFChargedIso_value)

        #print "making m2PFIDLoose"
        self.m2PFIDLoose_branch = the_tree.GetBranch("m2PFIDLoose")
        #if not self.m2PFIDLoose_branch and "m2PFIDLoose" not in self.complained:
        if not self.m2PFIDLoose_branch and "m2PFIDLoose":
            warnings.warn( "EMuMuTree: Expected branch m2PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDLoose")
        else:
            self.m2PFIDLoose_branch.SetAddress(<void*>&self.m2PFIDLoose_value)

        #print "making m2PFIDMedium"
        self.m2PFIDMedium_branch = the_tree.GetBranch("m2PFIDMedium")
        #if not self.m2PFIDMedium_branch and "m2PFIDMedium" not in self.complained:
        if not self.m2PFIDMedium_branch and "m2PFIDMedium":
            warnings.warn( "EMuMuTree: Expected branch m2PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDMedium")
        else:
            self.m2PFIDMedium_branch.SetAddress(<void*>&self.m2PFIDMedium_value)

        #print "making m2PFIDTight"
        self.m2PFIDTight_branch = the_tree.GetBranch("m2PFIDTight")
        #if not self.m2PFIDTight_branch and "m2PFIDTight" not in self.complained:
        if not self.m2PFIDTight_branch and "m2PFIDTight":
            warnings.warn( "EMuMuTree: Expected branch m2PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDTight")
        else:
            self.m2PFIDTight_branch.SetAddress(<void*>&self.m2PFIDTight_value)

        #print "making m2PFNeutralHadronIsoR04"
        self.m2PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m2PFNeutralHadronIsoR04")
        #if not self.m2PFNeutralHadronIsoR04_branch and "m2PFNeutralHadronIsoR04" not in self.complained:
        if not self.m2PFNeutralHadronIsoR04_branch and "m2PFNeutralHadronIsoR04":
            warnings.warn( "EMuMuTree: Expected branch m2PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralHadronIsoR04")
        else:
            self.m2PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m2PFNeutralHadronIsoR04_value)

        #print "making m2PFNeutralIso"
        self.m2PFNeutralIso_branch = the_tree.GetBranch("m2PFNeutralIso")
        #if not self.m2PFNeutralIso_branch and "m2PFNeutralIso" not in self.complained:
        if not self.m2PFNeutralIso_branch and "m2PFNeutralIso":
            warnings.warn( "EMuMuTree: Expected branch m2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralIso")
        else:
            self.m2PFNeutralIso_branch.SetAddress(<void*>&self.m2PFNeutralIso_value)

        #print "making m2PFPUChargedIso"
        self.m2PFPUChargedIso_branch = the_tree.GetBranch("m2PFPUChargedIso")
        #if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso" not in self.complained:
        if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso":
            warnings.warn( "EMuMuTree: Expected branch m2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPUChargedIso")
        else:
            self.m2PFPUChargedIso_branch.SetAddress(<void*>&self.m2PFPUChargedIso_value)

        #print "making m2PFPhotonIso"
        self.m2PFPhotonIso_branch = the_tree.GetBranch("m2PFPhotonIso")
        #if not self.m2PFPhotonIso_branch and "m2PFPhotonIso" not in self.complained:
        if not self.m2PFPhotonIso_branch and "m2PFPhotonIso":
            warnings.warn( "EMuMuTree: Expected branch m2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIso")
        else:
            self.m2PFPhotonIso_branch.SetAddress(<void*>&self.m2PFPhotonIso_value)

        #print "making m2PFPhotonIsoR04"
        self.m2PFPhotonIsoR04_branch = the_tree.GetBranch("m2PFPhotonIsoR04")
        #if not self.m2PFPhotonIsoR04_branch and "m2PFPhotonIsoR04" not in self.complained:
        if not self.m2PFPhotonIsoR04_branch and "m2PFPhotonIsoR04":
            warnings.warn( "EMuMuTree: Expected branch m2PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIsoR04")
        else:
            self.m2PFPhotonIsoR04_branch.SetAddress(<void*>&self.m2PFPhotonIsoR04_value)

        #print "making m2PFPileupIsoR04"
        self.m2PFPileupIsoR04_branch = the_tree.GetBranch("m2PFPileupIsoR04")
        #if not self.m2PFPileupIsoR04_branch and "m2PFPileupIsoR04" not in self.complained:
        if not self.m2PFPileupIsoR04_branch and "m2PFPileupIsoR04":
            warnings.warn( "EMuMuTree: Expected branch m2PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPileupIsoR04")
        else:
            self.m2PFPileupIsoR04_branch.SetAddress(<void*>&self.m2PFPileupIsoR04_value)

        #print "making m2PVDXY"
        self.m2PVDXY_branch = the_tree.GetBranch("m2PVDXY")
        #if not self.m2PVDXY_branch and "m2PVDXY" not in self.complained:
        if not self.m2PVDXY_branch and "m2PVDXY":
            warnings.warn( "EMuMuTree: Expected branch m2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDXY")
        else:
            self.m2PVDXY_branch.SetAddress(<void*>&self.m2PVDXY_value)

        #print "making m2PVDZ"
        self.m2PVDZ_branch = the_tree.GetBranch("m2PVDZ")
        #if not self.m2PVDZ_branch and "m2PVDZ" not in self.complained:
        if not self.m2PVDZ_branch and "m2PVDZ":
            warnings.warn( "EMuMuTree: Expected branch m2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDZ")
        else:
            self.m2PVDZ_branch.SetAddress(<void*>&self.m2PVDZ_value)

        #print "making m2Phi"
        self.m2Phi_branch = the_tree.GetBranch("m2Phi")
        #if not self.m2Phi_branch and "m2Phi" not in self.complained:
        if not self.m2Phi_branch and "m2Phi":
            warnings.warn( "EMuMuTree: Expected branch m2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi")
        else:
            self.m2Phi_branch.SetAddress(<void*>&self.m2Phi_value)

        #print "making m2Phi_MuonEnDown"
        self.m2Phi_MuonEnDown_branch = the_tree.GetBranch("m2Phi_MuonEnDown")
        #if not self.m2Phi_MuonEnDown_branch and "m2Phi_MuonEnDown" not in self.complained:
        if not self.m2Phi_MuonEnDown_branch and "m2Phi_MuonEnDown":
            warnings.warn( "EMuMuTree: Expected branch m2Phi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi_MuonEnDown")
        else:
            self.m2Phi_MuonEnDown_branch.SetAddress(<void*>&self.m2Phi_MuonEnDown_value)

        #print "making m2Phi_MuonEnUp"
        self.m2Phi_MuonEnUp_branch = the_tree.GetBranch("m2Phi_MuonEnUp")
        #if not self.m2Phi_MuonEnUp_branch and "m2Phi_MuonEnUp" not in self.complained:
        if not self.m2Phi_MuonEnUp_branch and "m2Phi_MuonEnUp":
            warnings.warn( "EMuMuTree: Expected branch m2Phi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi_MuonEnUp")
        else:
            self.m2Phi_MuonEnUp_branch.SetAddress(<void*>&self.m2Phi_MuonEnUp_value)

        #print "making m2PixHits"
        self.m2PixHits_branch = the_tree.GetBranch("m2PixHits")
        #if not self.m2PixHits_branch and "m2PixHits" not in self.complained:
        if not self.m2PixHits_branch and "m2PixHits":
            warnings.warn( "EMuMuTree: Expected branch m2PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PixHits")
        else:
            self.m2PixHits_branch.SetAddress(<void*>&self.m2PixHits_value)

        #print "making m2Pt"
        self.m2Pt_branch = the_tree.GetBranch("m2Pt")
        #if not self.m2Pt_branch and "m2Pt" not in self.complained:
        if not self.m2Pt_branch and "m2Pt":
            warnings.warn( "EMuMuTree: Expected branch m2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt")
        else:
            self.m2Pt_branch.SetAddress(<void*>&self.m2Pt_value)

        #print "making m2Pt_MuonEnDown"
        self.m2Pt_MuonEnDown_branch = the_tree.GetBranch("m2Pt_MuonEnDown")
        #if not self.m2Pt_MuonEnDown_branch and "m2Pt_MuonEnDown" not in self.complained:
        if not self.m2Pt_MuonEnDown_branch and "m2Pt_MuonEnDown":
            warnings.warn( "EMuMuTree: Expected branch m2Pt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt_MuonEnDown")
        else:
            self.m2Pt_MuonEnDown_branch.SetAddress(<void*>&self.m2Pt_MuonEnDown_value)

        #print "making m2Pt_MuonEnUp"
        self.m2Pt_MuonEnUp_branch = the_tree.GetBranch("m2Pt_MuonEnUp")
        #if not self.m2Pt_MuonEnUp_branch and "m2Pt_MuonEnUp" not in self.complained:
        if not self.m2Pt_MuonEnUp_branch and "m2Pt_MuonEnUp":
            warnings.warn( "EMuMuTree: Expected branch m2Pt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt_MuonEnUp")
        else:
            self.m2Pt_MuonEnUp_branch.SetAddress(<void*>&self.m2Pt_MuonEnUp_value)

        #print "making m2Rank"
        self.m2Rank_branch = the_tree.GetBranch("m2Rank")
        #if not self.m2Rank_branch and "m2Rank" not in self.complained:
        if not self.m2Rank_branch and "m2Rank":
            warnings.warn( "EMuMuTree: Expected branch m2Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Rank")
        else:
            self.m2Rank_branch.SetAddress(<void*>&self.m2Rank_value)

        #print "making m2RelPFIsoDBDefault"
        self.m2RelPFIsoDBDefault_branch = the_tree.GetBranch("m2RelPFIsoDBDefault")
        #if not self.m2RelPFIsoDBDefault_branch and "m2RelPFIsoDBDefault" not in self.complained:
        if not self.m2RelPFIsoDBDefault_branch and "m2RelPFIsoDBDefault":
            warnings.warn( "EMuMuTree: Expected branch m2RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDBDefault")
        else:
            self.m2RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m2RelPFIsoDBDefault_value)

        #print "making m2RelPFIsoDBDefaultR04"
        self.m2RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m2RelPFIsoDBDefaultR04")
        #if not self.m2RelPFIsoDBDefaultR04_branch and "m2RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m2RelPFIsoDBDefaultR04_branch and "m2RelPFIsoDBDefaultR04":
            warnings.warn( "EMuMuTree: Expected branch m2RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDBDefaultR04")
        else:
            self.m2RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m2RelPFIsoDBDefaultR04_value)

        #print "making m2RelPFIsoRho"
        self.m2RelPFIsoRho_branch = the_tree.GetBranch("m2RelPFIsoRho")
        #if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho" not in self.complained:
        if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho":
            warnings.warn( "EMuMuTree: Expected branch m2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRho")
        else:
            self.m2RelPFIsoRho_branch.SetAddress(<void*>&self.m2RelPFIsoRho_value)

        #print "making m2Rho"
        self.m2Rho_branch = the_tree.GetBranch("m2Rho")
        #if not self.m2Rho_branch and "m2Rho" not in self.complained:
        if not self.m2Rho_branch and "m2Rho":
            warnings.warn( "EMuMuTree: Expected branch m2Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Rho")
        else:
            self.m2Rho_branch.SetAddress(<void*>&self.m2Rho_value)

        #print "making m2SIP2D"
        self.m2SIP2D_branch = the_tree.GetBranch("m2SIP2D")
        #if not self.m2SIP2D_branch and "m2SIP2D" not in self.complained:
        if not self.m2SIP2D_branch and "m2SIP2D":
            warnings.warn( "EMuMuTree: Expected branch m2SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SIP2D")
        else:
            self.m2SIP2D_branch.SetAddress(<void*>&self.m2SIP2D_value)

        #print "making m2SIP3D"
        self.m2SIP3D_branch = the_tree.GetBranch("m2SIP3D")
        #if not self.m2SIP3D_branch and "m2SIP3D" not in self.complained:
        if not self.m2SIP3D_branch and "m2SIP3D":
            warnings.warn( "EMuMuTree: Expected branch m2SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SIP3D")
        else:
            self.m2SIP3D_branch.SetAddress(<void*>&self.m2SIP3D_value)

        #print "making m2SegmentCompatibility"
        self.m2SegmentCompatibility_branch = the_tree.GetBranch("m2SegmentCompatibility")
        #if not self.m2SegmentCompatibility_branch and "m2SegmentCompatibility" not in self.complained:
        if not self.m2SegmentCompatibility_branch and "m2SegmentCompatibility":
            warnings.warn( "EMuMuTree: Expected branch m2SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SegmentCompatibility")
        else:
            self.m2SegmentCompatibility_branch.SetAddress(<void*>&self.m2SegmentCompatibility_value)

        #print "making m2TkLayersWithMeasurement"
        self.m2TkLayersWithMeasurement_branch = the_tree.GetBranch("m2TkLayersWithMeasurement")
        #if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement" not in self.complained:
        if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement":
            warnings.warn( "EMuMuTree: Expected branch m2TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkLayersWithMeasurement")
        else:
            self.m2TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m2TkLayersWithMeasurement_value)

        #print "making m2TrkIsoDR03"
        self.m2TrkIsoDR03_branch = the_tree.GetBranch("m2TrkIsoDR03")
        #if not self.m2TrkIsoDR03_branch and "m2TrkIsoDR03" not in self.complained:
        if not self.m2TrkIsoDR03_branch and "m2TrkIsoDR03":
            warnings.warn( "EMuMuTree: Expected branch m2TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TrkIsoDR03")
        else:
            self.m2TrkIsoDR03_branch.SetAddress(<void*>&self.m2TrkIsoDR03_value)

        #print "making m2TrkKink"
        self.m2TrkKink_branch = the_tree.GetBranch("m2TrkKink")
        #if not self.m2TrkKink_branch and "m2TrkKink" not in self.complained:
        if not self.m2TrkKink_branch and "m2TrkKink":
            warnings.warn( "EMuMuTree: Expected branch m2TrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TrkKink")
        else:
            self.m2TrkKink_branch.SetAddress(<void*>&self.m2TrkKink_value)

        #print "making m2TypeCode"
        self.m2TypeCode_branch = the_tree.GetBranch("m2TypeCode")
        #if not self.m2TypeCode_branch and "m2TypeCode" not in self.complained:
        if not self.m2TypeCode_branch and "m2TypeCode":
            warnings.warn( "EMuMuTree: Expected branch m2TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TypeCode")
        else:
            self.m2TypeCode_branch.SetAddress(<void*>&self.m2TypeCode_value)

        #print "making m2VZ"
        self.m2VZ_branch = the_tree.GetBranch("m2VZ")
        #if not self.m2VZ_branch and "m2VZ" not in self.complained:
        if not self.m2VZ_branch and "m2VZ":
            warnings.warn( "EMuMuTree: Expected branch m2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VZ")
        else:
            self.m2VZ_branch.SetAddress(<void*>&self.m2VZ_value)

        #print "making m2ValidFraction"
        self.m2ValidFraction_branch = the_tree.GetBranch("m2ValidFraction")
        #if not self.m2ValidFraction_branch and "m2ValidFraction" not in self.complained:
        if not self.m2ValidFraction_branch and "m2ValidFraction":
            warnings.warn( "EMuMuTree: Expected branch m2ValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ValidFraction")
        else:
            self.m2ValidFraction_branch.SetAddress(<void*>&self.m2ValidFraction_value)

        #print "making m2ZTTGenMatching"
        self.m2ZTTGenMatching_branch = the_tree.GetBranch("m2ZTTGenMatching")
        #if not self.m2ZTTGenMatching_branch and "m2ZTTGenMatching" not in self.complained:
        if not self.m2ZTTGenMatching_branch and "m2ZTTGenMatching":
            warnings.warn( "EMuMuTree: Expected branch m2ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ZTTGenMatching")
        else:
            self.m2ZTTGenMatching_branch.SetAddress(<void*>&self.m2ZTTGenMatching_value)

        #print "making m2_e_collinearmass"
        self.m2_e_collinearmass_branch = the_tree.GetBranch("m2_e_collinearmass")
        #if not self.m2_e_collinearmass_branch and "m2_e_collinearmass" not in self.complained:
        if not self.m2_e_collinearmass_branch and "m2_e_collinearmass":
            warnings.warn( "EMuMuTree: Expected branch m2_e_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_e_collinearmass")
        else:
            self.m2_e_collinearmass_branch.SetAddress(<void*>&self.m2_e_collinearmass_value)

        #print "making m2_e_collinearmass_CheckUESDown"
        self.m2_e_collinearmass_CheckUESDown_branch = the_tree.GetBranch("m2_e_collinearmass_CheckUESDown")
        #if not self.m2_e_collinearmass_CheckUESDown_branch and "m2_e_collinearmass_CheckUESDown" not in self.complained:
        if not self.m2_e_collinearmass_CheckUESDown_branch and "m2_e_collinearmass_CheckUESDown":
            warnings.warn( "EMuMuTree: Expected branch m2_e_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_e_collinearmass_CheckUESDown")
        else:
            self.m2_e_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.m2_e_collinearmass_CheckUESDown_value)

        #print "making m2_e_collinearmass_CheckUESUp"
        self.m2_e_collinearmass_CheckUESUp_branch = the_tree.GetBranch("m2_e_collinearmass_CheckUESUp")
        #if not self.m2_e_collinearmass_CheckUESUp_branch and "m2_e_collinearmass_CheckUESUp" not in self.complained:
        if not self.m2_e_collinearmass_CheckUESUp_branch and "m2_e_collinearmass_CheckUESUp":
            warnings.warn( "EMuMuTree: Expected branch m2_e_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_e_collinearmass_CheckUESUp")
        else:
            self.m2_e_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.m2_e_collinearmass_CheckUESUp_value)

        #print "making m2_e_collinearmass_JetCheckTotalDown"
        self.m2_e_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("m2_e_collinearmass_JetCheckTotalDown")
        #if not self.m2_e_collinearmass_JetCheckTotalDown_branch and "m2_e_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.m2_e_collinearmass_JetCheckTotalDown_branch and "m2_e_collinearmass_JetCheckTotalDown":
            warnings.warn( "EMuMuTree: Expected branch m2_e_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_e_collinearmass_JetCheckTotalDown")
        else:
            self.m2_e_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.m2_e_collinearmass_JetCheckTotalDown_value)

        #print "making m2_e_collinearmass_JetCheckTotalUp"
        self.m2_e_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("m2_e_collinearmass_JetCheckTotalUp")
        #if not self.m2_e_collinearmass_JetCheckTotalUp_branch and "m2_e_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.m2_e_collinearmass_JetCheckTotalUp_branch and "m2_e_collinearmass_JetCheckTotalUp":
            warnings.warn( "EMuMuTree: Expected branch m2_e_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_e_collinearmass_JetCheckTotalUp")
        else:
            self.m2_e_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.m2_e_collinearmass_JetCheckTotalUp_value)

        #print "making m2_e_collinearmass_JetEnDown"
        self.m2_e_collinearmass_JetEnDown_branch = the_tree.GetBranch("m2_e_collinearmass_JetEnDown")
        #if not self.m2_e_collinearmass_JetEnDown_branch and "m2_e_collinearmass_JetEnDown" not in self.complained:
        if not self.m2_e_collinearmass_JetEnDown_branch and "m2_e_collinearmass_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch m2_e_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_e_collinearmass_JetEnDown")
        else:
            self.m2_e_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m2_e_collinearmass_JetEnDown_value)

        #print "making m2_e_collinearmass_JetEnUp"
        self.m2_e_collinearmass_JetEnUp_branch = the_tree.GetBranch("m2_e_collinearmass_JetEnUp")
        #if not self.m2_e_collinearmass_JetEnUp_branch and "m2_e_collinearmass_JetEnUp" not in self.complained:
        if not self.m2_e_collinearmass_JetEnUp_branch and "m2_e_collinearmass_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch m2_e_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_e_collinearmass_JetEnUp")
        else:
            self.m2_e_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m2_e_collinearmass_JetEnUp_value)

        #print "making m2_e_collinearmass_UnclusteredEnDown"
        self.m2_e_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m2_e_collinearmass_UnclusteredEnDown")
        #if not self.m2_e_collinearmass_UnclusteredEnDown_branch and "m2_e_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m2_e_collinearmass_UnclusteredEnDown_branch and "m2_e_collinearmass_UnclusteredEnDown":
            warnings.warn( "EMuMuTree: Expected branch m2_e_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_e_collinearmass_UnclusteredEnDown")
        else:
            self.m2_e_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m2_e_collinearmass_UnclusteredEnDown_value)

        #print "making m2_e_collinearmass_UnclusteredEnUp"
        self.m2_e_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m2_e_collinearmass_UnclusteredEnUp")
        #if not self.m2_e_collinearmass_UnclusteredEnUp_branch and "m2_e_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m2_e_collinearmass_UnclusteredEnUp_branch and "m2_e_collinearmass_UnclusteredEnUp":
            warnings.warn( "EMuMuTree: Expected branch m2_e_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_e_collinearmass_UnclusteredEnUp")
        else:
            self.m2_e_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m2_e_collinearmass_UnclusteredEnUp_value)

        #print "making m2_m1_collinearmass"
        self.m2_m1_collinearmass_branch = the_tree.GetBranch("m2_m1_collinearmass")
        #if not self.m2_m1_collinearmass_branch and "m2_m1_collinearmass" not in self.complained:
        if not self.m2_m1_collinearmass_branch and "m2_m1_collinearmass":
            warnings.warn( "EMuMuTree: Expected branch m2_m1_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass")
        else:
            self.m2_m1_collinearmass_branch.SetAddress(<void*>&self.m2_m1_collinearmass_value)

        #print "making m2_m1_collinearmass_CheckUESDown"
        self.m2_m1_collinearmass_CheckUESDown_branch = the_tree.GetBranch("m2_m1_collinearmass_CheckUESDown")
        #if not self.m2_m1_collinearmass_CheckUESDown_branch and "m2_m1_collinearmass_CheckUESDown" not in self.complained:
        if not self.m2_m1_collinearmass_CheckUESDown_branch and "m2_m1_collinearmass_CheckUESDown":
            warnings.warn( "EMuMuTree: Expected branch m2_m1_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_CheckUESDown")
        else:
            self.m2_m1_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.m2_m1_collinearmass_CheckUESDown_value)

        #print "making m2_m1_collinearmass_CheckUESUp"
        self.m2_m1_collinearmass_CheckUESUp_branch = the_tree.GetBranch("m2_m1_collinearmass_CheckUESUp")
        #if not self.m2_m1_collinearmass_CheckUESUp_branch and "m2_m1_collinearmass_CheckUESUp" not in self.complained:
        if not self.m2_m1_collinearmass_CheckUESUp_branch and "m2_m1_collinearmass_CheckUESUp":
            warnings.warn( "EMuMuTree: Expected branch m2_m1_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_CheckUESUp")
        else:
            self.m2_m1_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.m2_m1_collinearmass_CheckUESUp_value)

        #print "making m2_m1_collinearmass_JetCheckTotalDown"
        self.m2_m1_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("m2_m1_collinearmass_JetCheckTotalDown")
        #if not self.m2_m1_collinearmass_JetCheckTotalDown_branch and "m2_m1_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.m2_m1_collinearmass_JetCheckTotalDown_branch and "m2_m1_collinearmass_JetCheckTotalDown":
            warnings.warn( "EMuMuTree: Expected branch m2_m1_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_JetCheckTotalDown")
        else:
            self.m2_m1_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.m2_m1_collinearmass_JetCheckTotalDown_value)

        #print "making m2_m1_collinearmass_JetCheckTotalUp"
        self.m2_m1_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("m2_m1_collinearmass_JetCheckTotalUp")
        #if not self.m2_m1_collinearmass_JetCheckTotalUp_branch and "m2_m1_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.m2_m1_collinearmass_JetCheckTotalUp_branch and "m2_m1_collinearmass_JetCheckTotalUp":
            warnings.warn( "EMuMuTree: Expected branch m2_m1_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_JetCheckTotalUp")
        else:
            self.m2_m1_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.m2_m1_collinearmass_JetCheckTotalUp_value)

        #print "making m2_m1_collinearmass_JetEnDown"
        self.m2_m1_collinearmass_JetEnDown_branch = the_tree.GetBranch("m2_m1_collinearmass_JetEnDown")
        #if not self.m2_m1_collinearmass_JetEnDown_branch and "m2_m1_collinearmass_JetEnDown" not in self.complained:
        if not self.m2_m1_collinearmass_JetEnDown_branch and "m2_m1_collinearmass_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch m2_m1_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_JetEnDown")
        else:
            self.m2_m1_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m2_m1_collinearmass_JetEnDown_value)

        #print "making m2_m1_collinearmass_JetEnUp"
        self.m2_m1_collinearmass_JetEnUp_branch = the_tree.GetBranch("m2_m1_collinearmass_JetEnUp")
        #if not self.m2_m1_collinearmass_JetEnUp_branch and "m2_m1_collinearmass_JetEnUp" not in self.complained:
        if not self.m2_m1_collinearmass_JetEnUp_branch and "m2_m1_collinearmass_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch m2_m1_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_JetEnUp")
        else:
            self.m2_m1_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m2_m1_collinearmass_JetEnUp_value)

        #print "making m2_m1_collinearmass_UnclusteredEnDown"
        self.m2_m1_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m2_m1_collinearmass_UnclusteredEnDown")
        #if not self.m2_m1_collinearmass_UnclusteredEnDown_branch and "m2_m1_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m2_m1_collinearmass_UnclusteredEnDown_branch and "m2_m1_collinearmass_UnclusteredEnDown":
            warnings.warn( "EMuMuTree: Expected branch m2_m1_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_UnclusteredEnDown")
        else:
            self.m2_m1_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m2_m1_collinearmass_UnclusteredEnDown_value)

        #print "making m2_m1_collinearmass_UnclusteredEnUp"
        self.m2_m1_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m2_m1_collinearmass_UnclusteredEnUp")
        #if not self.m2_m1_collinearmass_UnclusteredEnUp_branch and "m2_m1_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m2_m1_collinearmass_UnclusteredEnUp_branch and "m2_m1_collinearmass_UnclusteredEnUp":
            warnings.warn( "EMuMuTree: Expected branch m2_m1_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_UnclusteredEnUp")
        else:
            self.m2_m1_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m2_m1_collinearmass_UnclusteredEnUp_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "EMuMuTree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "EMuMuTree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov00_DESYlike"
        self.metcov00_DESYlike_branch = the_tree.GetBranch("metcov00_DESYlike")
        #if not self.metcov00_DESYlike_branch and "metcov00_DESYlike" not in self.complained:
        if not self.metcov00_DESYlike_branch and "metcov00_DESYlike":
            warnings.warn( "EMuMuTree: Expected branch metcov00_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00_DESYlike")
        else:
            self.metcov00_DESYlike_branch.SetAddress(<void*>&self.metcov00_DESYlike_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "EMuMuTree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov01_DESYlike"
        self.metcov01_DESYlike_branch = the_tree.GetBranch("metcov01_DESYlike")
        #if not self.metcov01_DESYlike_branch and "metcov01_DESYlike" not in self.complained:
        if not self.metcov01_DESYlike_branch and "metcov01_DESYlike":
            warnings.warn( "EMuMuTree: Expected branch metcov01_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01_DESYlike")
        else:
            self.metcov01_DESYlike_branch.SetAddress(<void*>&self.metcov01_DESYlike_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "EMuMuTree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov10_DESYlike"
        self.metcov10_DESYlike_branch = the_tree.GetBranch("metcov10_DESYlike")
        #if not self.metcov10_DESYlike_branch and "metcov10_DESYlike" not in self.complained:
        if not self.metcov10_DESYlike_branch and "metcov10_DESYlike":
            warnings.warn( "EMuMuTree: Expected branch metcov10_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10_DESYlike")
        else:
            self.metcov10_DESYlike_branch.SetAddress(<void*>&self.metcov10_DESYlike_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "EMuMuTree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

        #print "making metcov11_DESYlike"
        self.metcov11_DESYlike_branch = the_tree.GetBranch("metcov11_DESYlike")
        #if not self.metcov11_DESYlike_branch and "metcov11_DESYlike" not in self.complained:
        if not self.metcov11_DESYlike_branch and "metcov11_DESYlike":
            warnings.warn( "EMuMuTree: Expected branch metcov11_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11_DESYlike")
        else:
            self.metcov11_DESYlike_branch.SetAddress(<void*>&self.metcov11_DESYlike_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "EMuMuTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "EMuMuTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "EMuMuTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "EMuMuTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "EMuMuTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making muVetoZTTp001dxyzR0"
        self.muVetoZTTp001dxyzR0_branch = the_tree.GetBranch("muVetoZTTp001dxyzR0")
        #if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0" not in self.complained:
        if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0":
            warnings.warn( "EMuMuTree: Expected branch muVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyzR0")
        else:
            self.muVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.muVetoZTTp001dxyzR0_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "EMuMuTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "EMuMuTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "EMuMuTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "EMuMuTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "EMuMuTree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "EMuMuTree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "EMuMuTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "EMuMuTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "EMuMuTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "EMuMuTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "EMuMuTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "EMuMuTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "EMuMuTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "EMuMuTree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "EMuMuTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "EMuMuTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "EMuMuTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "EMuMuTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "EMuMuTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "EMuMuTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "EMuMuTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "EMuMuTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE17SingleMu8Group"
        self.singleE17SingleMu8Group_branch = the_tree.GetBranch("singleE17SingleMu8Group")
        #if not self.singleE17SingleMu8Group_branch and "singleE17SingleMu8Group" not in self.complained:
        if not self.singleE17SingleMu8Group_branch and "singleE17SingleMu8Group":
            warnings.warn( "EMuMuTree: Expected branch singleE17SingleMu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE17SingleMu8Group")
        else:
            self.singleE17SingleMu8Group_branch.SetAddress(<void*>&self.singleE17SingleMu8Group_value)

        #print "making singleE17SingleMu8Pass"
        self.singleE17SingleMu8Pass_branch = the_tree.GetBranch("singleE17SingleMu8Pass")
        #if not self.singleE17SingleMu8Pass_branch and "singleE17SingleMu8Pass" not in self.complained:
        if not self.singleE17SingleMu8Pass_branch and "singleE17SingleMu8Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE17SingleMu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE17SingleMu8Pass")
        else:
            self.singleE17SingleMu8Pass_branch.SetAddress(<void*>&self.singleE17SingleMu8Pass_value)

        #print "making singleE17SingleMu8Prescale"
        self.singleE17SingleMu8Prescale_branch = the_tree.GetBranch("singleE17SingleMu8Prescale")
        #if not self.singleE17SingleMu8Prescale_branch and "singleE17SingleMu8Prescale" not in self.complained:
        if not self.singleE17SingleMu8Prescale_branch and "singleE17SingleMu8Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE17SingleMu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE17SingleMu8Prescale")
        else:
            self.singleE17SingleMu8Prescale_branch.SetAddress(<void*>&self.singleE17SingleMu8Prescale_value)

        #print "making singleE20SingleTau28Group"
        self.singleE20SingleTau28Group_branch = the_tree.GetBranch("singleE20SingleTau28Group")
        #if not self.singleE20SingleTau28Group_branch and "singleE20SingleTau28Group" not in self.complained:
        if not self.singleE20SingleTau28Group_branch and "singleE20SingleTau28Group":
            warnings.warn( "EMuMuTree: Expected branch singleE20SingleTau28Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE20SingleTau28Group")
        else:
            self.singleE20SingleTau28Group_branch.SetAddress(<void*>&self.singleE20SingleTau28Group_value)

        #print "making singleE20SingleTau28Pass"
        self.singleE20SingleTau28Pass_branch = the_tree.GetBranch("singleE20SingleTau28Pass")
        #if not self.singleE20SingleTau28Pass_branch and "singleE20SingleTau28Pass" not in self.complained:
        if not self.singleE20SingleTau28Pass_branch and "singleE20SingleTau28Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE20SingleTau28Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE20SingleTau28Pass")
        else:
            self.singleE20SingleTau28Pass_branch.SetAddress(<void*>&self.singleE20SingleTau28Pass_value)

        #print "making singleE20SingleTau28Prescale"
        self.singleE20SingleTau28Prescale_branch = the_tree.GetBranch("singleE20SingleTau28Prescale")
        #if not self.singleE20SingleTau28Prescale_branch and "singleE20SingleTau28Prescale" not in self.complained:
        if not self.singleE20SingleTau28Prescale_branch and "singleE20SingleTau28Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE20SingleTau28Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE20SingleTau28Prescale")
        else:
            self.singleE20SingleTau28Prescale_branch.SetAddress(<void*>&self.singleE20SingleTau28Prescale_value)

        #print "making singleE22SingleTau20SingleL1Group"
        self.singleE22SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE22SingleTau20SingleL1Group")
        #if not self.singleE22SingleTau20SingleL1Group_branch and "singleE22SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE22SingleTau20SingleL1Group_branch and "singleE22SingleTau20SingleL1Group":
            warnings.warn( "EMuMuTree: Expected branch singleE22SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau20SingleL1Group")
        else:
            self.singleE22SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE22SingleTau20SingleL1Group_value)

        #print "making singleE22SingleTau20SingleL1Pass"
        self.singleE22SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE22SingleTau20SingleL1Pass")
        #if not self.singleE22SingleTau20SingleL1Pass_branch and "singleE22SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE22SingleTau20SingleL1Pass_branch and "singleE22SingleTau20SingleL1Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE22SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau20SingleL1Pass")
        else:
            self.singleE22SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE22SingleTau20SingleL1Pass_value)

        #print "making singleE22SingleTau20SingleL1Prescale"
        self.singleE22SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE22SingleTau20SingleL1Prescale")
        #if not self.singleE22SingleTau20SingleL1Prescale_branch and "singleE22SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE22SingleTau20SingleL1Prescale_branch and "singleE22SingleTau20SingleL1Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE22SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau20SingleL1Prescale")
        else:
            self.singleE22SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE22SingleTau20SingleL1Prescale_value)

        #print "making singleE22SingleTau29Group"
        self.singleE22SingleTau29Group_branch = the_tree.GetBranch("singleE22SingleTau29Group")
        #if not self.singleE22SingleTau29Group_branch and "singleE22SingleTau29Group" not in self.complained:
        if not self.singleE22SingleTau29Group_branch and "singleE22SingleTau29Group":
            warnings.warn( "EMuMuTree: Expected branch singleE22SingleTau29Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau29Group")
        else:
            self.singleE22SingleTau29Group_branch.SetAddress(<void*>&self.singleE22SingleTau29Group_value)

        #print "making singleE22SingleTau29Pass"
        self.singleE22SingleTau29Pass_branch = the_tree.GetBranch("singleE22SingleTau29Pass")
        #if not self.singleE22SingleTau29Pass_branch and "singleE22SingleTau29Pass" not in self.complained:
        if not self.singleE22SingleTau29Pass_branch and "singleE22SingleTau29Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE22SingleTau29Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau29Pass")
        else:
            self.singleE22SingleTau29Pass_branch.SetAddress(<void*>&self.singleE22SingleTau29Pass_value)

        #print "making singleE22SingleTau29Prescale"
        self.singleE22SingleTau29Prescale_branch = the_tree.GetBranch("singleE22SingleTau29Prescale")
        #if not self.singleE22SingleTau29Prescale_branch and "singleE22SingleTau29Prescale" not in self.complained:
        if not self.singleE22SingleTau29Prescale_branch and "singleE22SingleTau29Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE22SingleTau29Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau29Prescale")
        else:
            self.singleE22SingleTau29Prescale_branch.SetAddress(<void*>&self.singleE22SingleTau29Prescale_value)

        #print "making singleE23SingleMu8Group"
        self.singleE23SingleMu8Group_branch = the_tree.GetBranch("singleE23SingleMu8Group")
        #if not self.singleE23SingleMu8Group_branch and "singleE23SingleMu8Group" not in self.complained:
        if not self.singleE23SingleMu8Group_branch and "singleE23SingleMu8Group":
            warnings.warn( "EMuMuTree: Expected branch singleE23SingleMu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23SingleMu8Group")
        else:
            self.singleE23SingleMu8Group_branch.SetAddress(<void*>&self.singleE23SingleMu8Group_value)

        #print "making singleE23SingleMu8Pass"
        self.singleE23SingleMu8Pass_branch = the_tree.GetBranch("singleE23SingleMu8Pass")
        #if not self.singleE23SingleMu8Pass_branch and "singleE23SingleMu8Pass" not in self.complained:
        if not self.singleE23SingleMu8Pass_branch and "singleE23SingleMu8Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE23SingleMu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23SingleMu8Pass")
        else:
            self.singleE23SingleMu8Pass_branch.SetAddress(<void*>&self.singleE23SingleMu8Pass_value)

        #print "making singleE23SingleMu8Prescale"
        self.singleE23SingleMu8Prescale_branch = the_tree.GetBranch("singleE23SingleMu8Prescale")
        #if not self.singleE23SingleMu8Prescale_branch and "singleE23SingleMu8Prescale" not in self.complained:
        if not self.singleE23SingleMu8Prescale_branch and "singleE23SingleMu8Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE23SingleMu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23SingleMu8Prescale")
        else:
            self.singleE23SingleMu8Prescale_branch.SetAddress(<void*>&self.singleE23SingleMu8Prescale_value)

        #print "making singleE24SingleTau20Group"
        self.singleE24SingleTau20Group_branch = the_tree.GetBranch("singleE24SingleTau20Group")
        #if not self.singleE24SingleTau20Group_branch and "singleE24SingleTau20Group" not in self.complained:
        if not self.singleE24SingleTau20Group_branch and "singleE24SingleTau20Group":
            warnings.warn( "EMuMuTree: Expected branch singleE24SingleTau20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20Group")
        else:
            self.singleE24SingleTau20Group_branch.SetAddress(<void*>&self.singleE24SingleTau20Group_value)

        #print "making singleE24SingleTau20Pass"
        self.singleE24SingleTau20Pass_branch = the_tree.GetBranch("singleE24SingleTau20Pass")
        #if not self.singleE24SingleTau20Pass_branch and "singleE24SingleTau20Pass" not in self.complained:
        if not self.singleE24SingleTau20Pass_branch and "singleE24SingleTau20Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE24SingleTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20Pass")
        else:
            self.singleE24SingleTau20Pass_branch.SetAddress(<void*>&self.singleE24SingleTau20Pass_value)

        #print "making singleE24SingleTau20Prescale"
        self.singleE24SingleTau20Prescale_branch = the_tree.GetBranch("singleE24SingleTau20Prescale")
        #if not self.singleE24SingleTau20Prescale_branch and "singleE24SingleTau20Prescale" not in self.complained:
        if not self.singleE24SingleTau20Prescale_branch and "singleE24SingleTau20Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE24SingleTau20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20Prescale")
        else:
            self.singleE24SingleTau20Prescale_branch.SetAddress(<void*>&self.singleE24SingleTau20Prescale_value)

        #print "making singleE24SingleTau20SingleL1Group"
        self.singleE24SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE24SingleTau20SingleL1Group")
        #if not self.singleE24SingleTau20SingleL1Group_branch and "singleE24SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE24SingleTau20SingleL1Group_branch and "singleE24SingleTau20SingleL1Group":
            warnings.warn( "EMuMuTree: Expected branch singleE24SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20SingleL1Group")
        else:
            self.singleE24SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE24SingleTau20SingleL1Group_value)

        #print "making singleE24SingleTau20SingleL1Pass"
        self.singleE24SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE24SingleTau20SingleL1Pass")
        #if not self.singleE24SingleTau20SingleL1Pass_branch and "singleE24SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE24SingleTau20SingleL1Pass_branch and "singleE24SingleTau20SingleL1Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE24SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20SingleL1Pass")
        else:
            self.singleE24SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE24SingleTau20SingleL1Pass_value)

        #print "making singleE24SingleTau20SingleL1Prescale"
        self.singleE24SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE24SingleTau20SingleL1Prescale")
        #if not self.singleE24SingleTau20SingleL1Prescale_branch and "singleE24SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE24SingleTau20SingleL1Prescale_branch and "singleE24SingleTau20SingleL1Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE24SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20SingleL1Prescale")
        else:
            self.singleE24SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE24SingleTau20SingleL1Prescale_value)

        #print "making singleE24SingleTau30Group"
        self.singleE24SingleTau30Group_branch = the_tree.GetBranch("singleE24SingleTau30Group")
        #if not self.singleE24SingleTau30Group_branch and "singleE24SingleTau30Group" not in self.complained:
        if not self.singleE24SingleTau30Group_branch and "singleE24SingleTau30Group":
            warnings.warn( "EMuMuTree: Expected branch singleE24SingleTau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau30Group")
        else:
            self.singleE24SingleTau30Group_branch.SetAddress(<void*>&self.singleE24SingleTau30Group_value)

        #print "making singleE24SingleTau30Pass"
        self.singleE24SingleTau30Pass_branch = the_tree.GetBranch("singleE24SingleTau30Pass")
        #if not self.singleE24SingleTau30Pass_branch and "singleE24SingleTau30Pass" not in self.complained:
        if not self.singleE24SingleTau30Pass_branch and "singleE24SingleTau30Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE24SingleTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau30Pass")
        else:
            self.singleE24SingleTau30Pass_branch.SetAddress(<void*>&self.singleE24SingleTau30Pass_value)

        #print "making singleE24SingleTau30Prescale"
        self.singleE24SingleTau30Prescale_branch = the_tree.GetBranch("singleE24SingleTau30Prescale")
        #if not self.singleE24SingleTau30Prescale_branch and "singleE24SingleTau30Prescale" not in self.complained:
        if not self.singleE24SingleTau30Prescale_branch and "singleE24SingleTau30Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE24SingleTau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau30Prescale")
        else:
            self.singleE24SingleTau30Prescale_branch.SetAddress(<void*>&self.singleE24SingleTau30Prescale_value)

        #print "making singleE25eta2p1TightGroup"
        self.singleE25eta2p1TightGroup_branch = the_tree.GetBranch("singleE25eta2p1TightGroup")
        #if not self.singleE25eta2p1TightGroup_branch and "singleE25eta2p1TightGroup" not in self.complained:
        if not self.singleE25eta2p1TightGroup_branch and "singleE25eta2p1TightGroup":
            warnings.warn( "EMuMuTree: Expected branch singleE25eta2p1TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightGroup")
        else:
            self.singleE25eta2p1TightGroup_branch.SetAddress(<void*>&self.singleE25eta2p1TightGroup_value)

        #print "making singleE25eta2p1TightPass"
        self.singleE25eta2p1TightPass_branch = the_tree.GetBranch("singleE25eta2p1TightPass")
        #if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass" not in self.complained:
        if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass":
            warnings.warn( "EMuMuTree: Expected branch singleE25eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPass")
        else:
            self.singleE25eta2p1TightPass_branch.SetAddress(<void*>&self.singleE25eta2p1TightPass_value)

        #print "making singleE25eta2p1TightPrescale"
        self.singleE25eta2p1TightPrescale_branch = the_tree.GetBranch("singleE25eta2p1TightPrescale")
        #if not self.singleE25eta2p1TightPrescale_branch and "singleE25eta2p1TightPrescale" not in self.complained:
        if not self.singleE25eta2p1TightPrescale_branch and "singleE25eta2p1TightPrescale":
            warnings.warn( "EMuMuTree: Expected branch singleE25eta2p1TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPrescale")
        else:
            self.singleE25eta2p1TightPrescale_branch.SetAddress(<void*>&self.singleE25eta2p1TightPrescale_value)

        #print "making singleE27SingleTau20SingleL1Group"
        self.singleE27SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE27SingleTau20SingleL1Group")
        #if not self.singleE27SingleTau20SingleL1Group_branch and "singleE27SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE27SingleTau20SingleL1Group_branch and "singleE27SingleTau20SingleL1Group":
            warnings.warn( "EMuMuTree: Expected branch singleE27SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27SingleTau20SingleL1Group")
        else:
            self.singleE27SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE27SingleTau20SingleL1Group_value)

        #print "making singleE27SingleTau20SingleL1Pass"
        self.singleE27SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE27SingleTau20SingleL1Pass")
        #if not self.singleE27SingleTau20SingleL1Pass_branch and "singleE27SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE27SingleTau20SingleL1Pass_branch and "singleE27SingleTau20SingleL1Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE27SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27SingleTau20SingleL1Pass")
        else:
            self.singleE27SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE27SingleTau20SingleL1Pass_value)

        #print "making singleE27SingleTau20SingleL1Prescale"
        self.singleE27SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE27SingleTau20SingleL1Prescale")
        #if not self.singleE27SingleTau20SingleL1Prescale_branch and "singleE27SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE27SingleTau20SingleL1Prescale_branch and "singleE27SingleTau20SingleL1Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE27SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27SingleTau20SingleL1Prescale")
        else:
            self.singleE27SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE27SingleTau20SingleL1Prescale_value)

        #print "making singleE27TightGroup"
        self.singleE27TightGroup_branch = the_tree.GetBranch("singleE27TightGroup")
        #if not self.singleE27TightGroup_branch and "singleE27TightGroup" not in self.complained:
        if not self.singleE27TightGroup_branch and "singleE27TightGroup":
            warnings.warn( "EMuMuTree: Expected branch singleE27TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightGroup")
        else:
            self.singleE27TightGroup_branch.SetAddress(<void*>&self.singleE27TightGroup_value)

        #print "making singleE27TightPass"
        self.singleE27TightPass_branch = the_tree.GetBranch("singleE27TightPass")
        #if not self.singleE27TightPass_branch and "singleE27TightPass" not in self.complained:
        if not self.singleE27TightPass_branch and "singleE27TightPass":
            warnings.warn( "EMuMuTree: Expected branch singleE27TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightPass")
        else:
            self.singleE27TightPass_branch.SetAddress(<void*>&self.singleE27TightPass_value)

        #print "making singleE27TightPrescale"
        self.singleE27TightPrescale_branch = the_tree.GetBranch("singleE27TightPrescale")
        #if not self.singleE27TightPrescale_branch and "singleE27TightPrescale" not in self.complained:
        if not self.singleE27TightPrescale_branch and "singleE27TightPrescale":
            warnings.warn( "EMuMuTree: Expected branch singleE27TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightPrescale")
        else:
            self.singleE27TightPrescale_branch.SetAddress(<void*>&self.singleE27TightPrescale_value)

        #print "making singleE27eta2p1LooseGroup"
        self.singleE27eta2p1LooseGroup_branch = the_tree.GetBranch("singleE27eta2p1LooseGroup")
        #if not self.singleE27eta2p1LooseGroup_branch and "singleE27eta2p1LooseGroup" not in self.complained:
        if not self.singleE27eta2p1LooseGroup_branch and "singleE27eta2p1LooseGroup":
            warnings.warn( "EMuMuTree: Expected branch singleE27eta2p1LooseGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1LooseGroup")
        else:
            self.singleE27eta2p1LooseGroup_branch.SetAddress(<void*>&self.singleE27eta2p1LooseGroup_value)

        #print "making singleE27eta2p1LoosePass"
        self.singleE27eta2p1LoosePass_branch = the_tree.GetBranch("singleE27eta2p1LoosePass")
        #if not self.singleE27eta2p1LoosePass_branch and "singleE27eta2p1LoosePass" not in self.complained:
        if not self.singleE27eta2p1LoosePass_branch and "singleE27eta2p1LoosePass":
            warnings.warn( "EMuMuTree: Expected branch singleE27eta2p1LoosePass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1LoosePass")
        else:
            self.singleE27eta2p1LoosePass_branch.SetAddress(<void*>&self.singleE27eta2p1LoosePass_value)

        #print "making singleE27eta2p1LoosePrescale"
        self.singleE27eta2p1LoosePrescale_branch = the_tree.GetBranch("singleE27eta2p1LoosePrescale")
        #if not self.singleE27eta2p1LoosePrescale_branch and "singleE27eta2p1LoosePrescale" not in self.complained:
        if not self.singleE27eta2p1LoosePrescale_branch and "singleE27eta2p1LoosePrescale":
            warnings.warn( "EMuMuTree: Expected branch singleE27eta2p1LoosePrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1LoosePrescale")
        else:
            self.singleE27eta2p1LoosePrescale_branch.SetAddress(<void*>&self.singleE27eta2p1LoosePrescale_value)

        #print "making singleE27eta2p1TightGroup"
        self.singleE27eta2p1TightGroup_branch = the_tree.GetBranch("singleE27eta2p1TightGroup")
        #if not self.singleE27eta2p1TightGroup_branch and "singleE27eta2p1TightGroup" not in self.complained:
        if not self.singleE27eta2p1TightGroup_branch and "singleE27eta2p1TightGroup":
            warnings.warn( "EMuMuTree: Expected branch singleE27eta2p1TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1TightGroup")
        else:
            self.singleE27eta2p1TightGroup_branch.SetAddress(<void*>&self.singleE27eta2p1TightGroup_value)

        #print "making singleE27eta2p1TightPass"
        self.singleE27eta2p1TightPass_branch = the_tree.GetBranch("singleE27eta2p1TightPass")
        #if not self.singleE27eta2p1TightPass_branch and "singleE27eta2p1TightPass" not in self.complained:
        if not self.singleE27eta2p1TightPass_branch and "singleE27eta2p1TightPass":
            warnings.warn( "EMuMuTree: Expected branch singleE27eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1TightPass")
        else:
            self.singleE27eta2p1TightPass_branch.SetAddress(<void*>&self.singleE27eta2p1TightPass_value)

        #print "making singleE27eta2p1TightPrescale"
        self.singleE27eta2p1TightPrescale_branch = the_tree.GetBranch("singleE27eta2p1TightPrescale")
        #if not self.singleE27eta2p1TightPrescale_branch and "singleE27eta2p1TightPrescale" not in self.complained:
        if not self.singleE27eta2p1TightPrescale_branch and "singleE27eta2p1TightPrescale":
            warnings.warn( "EMuMuTree: Expected branch singleE27eta2p1TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1TightPrescale")
        else:
            self.singleE27eta2p1TightPrescale_branch.SetAddress(<void*>&self.singleE27eta2p1TightPrescale_value)

        #print "making singleE32SingleTau20SingleL1Group"
        self.singleE32SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE32SingleTau20SingleL1Group")
        #if not self.singleE32SingleTau20SingleL1Group_branch and "singleE32SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE32SingleTau20SingleL1Group_branch and "singleE32SingleTau20SingleL1Group":
            warnings.warn( "EMuMuTree: Expected branch singleE32SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE32SingleTau20SingleL1Group")
        else:
            self.singleE32SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE32SingleTau20SingleL1Group_value)

        #print "making singleE32SingleTau20SingleL1Pass"
        self.singleE32SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE32SingleTau20SingleL1Pass")
        #if not self.singleE32SingleTau20SingleL1Pass_branch and "singleE32SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE32SingleTau20SingleL1Pass_branch and "singleE32SingleTau20SingleL1Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE32SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE32SingleTau20SingleL1Pass")
        else:
            self.singleE32SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE32SingleTau20SingleL1Pass_value)

        #print "making singleE32SingleTau20SingleL1Prescale"
        self.singleE32SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE32SingleTau20SingleL1Prescale")
        #if not self.singleE32SingleTau20SingleL1Prescale_branch and "singleE32SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE32SingleTau20SingleL1Prescale_branch and "singleE32SingleTau20SingleL1Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE32SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE32SingleTau20SingleL1Prescale")
        else:
            self.singleE32SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE32SingleTau20SingleL1Prescale_value)

        #print "making singleE36SingleTau30Group"
        self.singleE36SingleTau30Group_branch = the_tree.GetBranch("singleE36SingleTau30Group")
        #if not self.singleE36SingleTau30Group_branch and "singleE36SingleTau30Group" not in self.complained:
        if not self.singleE36SingleTau30Group_branch and "singleE36SingleTau30Group":
            warnings.warn( "EMuMuTree: Expected branch singleE36SingleTau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE36SingleTau30Group")
        else:
            self.singleE36SingleTau30Group_branch.SetAddress(<void*>&self.singleE36SingleTau30Group_value)

        #print "making singleE36SingleTau30Pass"
        self.singleE36SingleTau30Pass_branch = the_tree.GetBranch("singleE36SingleTau30Pass")
        #if not self.singleE36SingleTau30Pass_branch and "singleE36SingleTau30Pass" not in self.complained:
        if not self.singleE36SingleTau30Pass_branch and "singleE36SingleTau30Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE36SingleTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE36SingleTau30Pass")
        else:
            self.singleE36SingleTau30Pass_branch.SetAddress(<void*>&self.singleE36SingleTau30Pass_value)

        #print "making singleE36SingleTau30Prescale"
        self.singleE36SingleTau30Prescale_branch = the_tree.GetBranch("singleE36SingleTau30Prescale")
        #if not self.singleE36SingleTau30Prescale_branch and "singleE36SingleTau30Prescale" not in self.complained:
        if not self.singleE36SingleTau30Prescale_branch and "singleE36SingleTau30Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE36SingleTau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE36SingleTau30Prescale")
        else:
            self.singleE36SingleTau30Prescale_branch.SetAddress(<void*>&self.singleE36SingleTau30Prescale_value)

        #print "making singleESingleMuGroup"
        self.singleESingleMuGroup_branch = the_tree.GetBranch("singleESingleMuGroup")
        #if not self.singleESingleMuGroup_branch and "singleESingleMuGroup" not in self.complained:
        if not self.singleESingleMuGroup_branch and "singleESingleMuGroup":
            warnings.warn( "EMuMuTree: Expected branch singleESingleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleESingleMuGroup")
        else:
            self.singleESingleMuGroup_branch.SetAddress(<void*>&self.singleESingleMuGroup_value)

        #print "making singleESingleMuPass"
        self.singleESingleMuPass_branch = the_tree.GetBranch("singleESingleMuPass")
        #if not self.singleESingleMuPass_branch and "singleESingleMuPass" not in self.complained:
        if not self.singleESingleMuPass_branch and "singleESingleMuPass":
            warnings.warn( "EMuMuTree: Expected branch singleESingleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleESingleMuPass")
        else:
            self.singleESingleMuPass_branch.SetAddress(<void*>&self.singleESingleMuPass_value)

        #print "making singleESingleMuPrescale"
        self.singleESingleMuPrescale_branch = the_tree.GetBranch("singleESingleMuPrescale")
        #if not self.singleESingleMuPrescale_branch and "singleESingleMuPrescale" not in self.complained:
        if not self.singleESingleMuPrescale_branch and "singleESingleMuPrescale":
            warnings.warn( "EMuMuTree: Expected branch singleESingleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleESingleMuPrescale")
        else:
            self.singleESingleMuPrescale_branch.SetAddress(<void*>&self.singleESingleMuPrescale_value)

        #print "making singleE_leg1Group"
        self.singleE_leg1Group_branch = the_tree.GetBranch("singleE_leg1Group")
        #if not self.singleE_leg1Group_branch and "singleE_leg1Group" not in self.complained:
        if not self.singleE_leg1Group_branch and "singleE_leg1Group":
            warnings.warn( "EMuMuTree: Expected branch singleE_leg1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg1Group")
        else:
            self.singleE_leg1Group_branch.SetAddress(<void*>&self.singleE_leg1Group_value)

        #print "making singleE_leg1Pass"
        self.singleE_leg1Pass_branch = the_tree.GetBranch("singleE_leg1Pass")
        #if not self.singleE_leg1Pass_branch and "singleE_leg1Pass" not in self.complained:
        if not self.singleE_leg1Pass_branch and "singleE_leg1Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE_leg1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg1Pass")
        else:
            self.singleE_leg1Pass_branch.SetAddress(<void*>&self.singleE_leg1Pass_value)

        #print "making singleE_leg1Prescale"
        self.singleE_leg1Prescale_branch = the_tree.GetBranch("singleE_leg1Prescale")
        #if not self.singleE_leg1Prescale_branch and "singleE_leg1Prescale" not in self.complained:
        if not self.singleE_leg1Prescale_branch and "singleE_leg1Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE_leg1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg1Prescale")
        else:
            self.singleE_leg1Prescale_branch.SetAddress(<void*>&self.singleE_leg1Prescale_value)

        #print "making singleE_leg2Group"
        self.singleE_leg2Group_branch = the_tree.GetBranch("singleE_leg2Group")
        #if not self.singleE_leg2Group_branch and "singleE_leg2Group" not in self.complained:
        if not self.singleE_leg2Group_branch and "singleE_leg2Group":
            warnings.warn( "EMuMuTree: Expected branch singleE_leg2Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg2Group")
        else:
            self.singleE_leg2Group_branch.SetAddress(<void*>&self.singleE_leg2Group_value)

        #print "making singleE_leg2Pass"
        self.singleE_leg2Pass_branch = the_tree.GetBranch("singleE_leg2Pass")
        #if not self.singleE_leg2Pass_branch and "singleE_leg2Pass" not in self.complained:
        if not self.singleE_leg2Pass_branch and "singleE_leg2Pass":
            warnings.warn( "EMuMuTree: Expected branch singleE_leg2Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg2Pass")
        else:
            self.singleE_leg2Pass_branch.SetAddress(<void*>&self.singleE_leg2Pass_value)

        #print "making singleE_leg2Prescale"
        self.singleE_leg2Prescale_branch = the_tree.GetBranch("singleE_leg2Prescale")
        #if not self.singleE_leg2Prescale_branch and "singleE_leg2Prescale" not in self.complained:
        if not self.singleE_leg2Prescale_branch and "singleE_leg2Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleE_leg2Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg2Prescale")
        else:
            self.singleE_leg2Prescale_branch.SetAddress(<void*>&self.singleE_leg2Prescale_value)

        #print "making singleIsoMu20Group"
        self.singleIsoMu20Group_branch = the_tree.GetBranch("singleIsoMu20Group")
        #if not self.singleIsoMu20Group_branch and "singleIsoMu20Group" not in self.complained:
        if not self.singleIsoMu20Group_branch and "singleIsoMu20Group":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Group")
        else:
            self.singleIsoMu20Group_branch.SetAddress(<void*>&self.singleIsoMu20Group_value)

        #print "making singleIsoMu20Pass"
        self.singleIsoMu20Pass_branch = the_tree.GetBranch("singleIsoMu20Pass")
        #if not self.singleIsoMu20Pass_branch and "singleIsoMu20Pass" not in self.complained:
        if not self.singleIsoMu20Pass_branch and "singleIsoMu20Pass":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Pass")
        else:
            self.singleIsoMu20Pass_branch.SetAddress(<void*>&self.singleIsoMu20Pass_value)

        #print "making singleIsoMu20Prescale"
        self.singleIsoMu20Prescale_branch = the_tree.GetBranch("singleIsoMu20Prescale")
        #if not self.singleIsoMu20Prescale_branch and "singleIsoMu20Prescale" not in self.complained:
        if not self.singleIsoMu20Prescale_branch and "singleIsoMu20Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Prescale")
        else:
            self.singleIsoMu20Prescale_branch.SetAddress(<void*>&self.singleIsoMu20Prescale_value)

        #print "making singleIsoMu22Group"
        self.singleIsoMu22Group_branch = the_tree.GetBranch("singleIsoMu22Group")
        #if not self.singleIsoMu22Group_branch and "singleIsoMu22Group" not in self.complained:
        if not self.singleIsoMu22Group_branch and "singleIsoMu22Group":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu22Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Group")
        else:
            self.singleIsoMu22Group_branch.SetAddress(<void*>&self.singleIsoMu22Group_value)

        #print "making singleIsoMu22Pass"
        self.singleIsoMu22Pass_branch = the_tree.GetBranch("singleIsoMu22Pass")
        #if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass" not in self.complained:
        if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Pass")
        else:
            self.singleIsoMu22Pass_branch.SetAddress(<void*>&self.singleIsoMu22Pass_value)

        #print "making singleIsoMu22Prescale"
        self.singleIsoMu22Prescale_branch = the_tree.GetBranch("singleIsoMu22Prescale")
        #if not self.singleIsoMu22Prescale_branch and "singleIsoMu22Prescale" not in self.complained:
        if not self.singleIsoMu22Prescale_branch and "singleIsoMu22Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu22Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Prescale")
        else:
            self.singleIsoMu22Prescale_branch.SetAddress(<void*>&self.singleIsoMu22Prescale_value)

        #print "making singleIsoMu22eta2p1Group"
        self.singleIsoMu22eta2p1Group_branch = the_tree.GetBranch("singleIsoMu22eta2p1Group")
        #if not self.singleIsoMu22eta2p1Group_branch and "singleIsoMu22eta2p1Group" not in self.complained:
        if not self.singleIsoMu22eta2p1Group_branch and "singleIsoMu22eta2p1Group":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu22eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Group")
        else:
            self.singleIsoMu22eta2p1Group_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Group_value)

        #print "making singleIsoMu22eta2p1Pass"
        self.singleIsoMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu22eta2p1Pass")
        #if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Pass")
        else:
            self.singleIsoMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Pass_value)

        #print "making singleIsoMu22eta2p1Prescale"
        self.singleIsoMu22eta2p1Prescale_branch = the_tree.GetBranch("singleIsoMu22eta2p1Prescale")
        #if not self.singleIsoMu22eta2p1Prescale_branch and "singleIsoMu22eta2p1Prescale" not in self.complained:
        if not self.singleIsoMu22eta2p1Prescale_branch and "singleIsoMu22eta2p1Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu22eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Prescale")
        else:
            self.singleIsoMu22eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Prescale_value)

        #print "making singleIsoMu24Group"
        self.singleIsoMu24Group_branch = the_tree.GetBranch("singleIsoMu24Group")
        #if not self.singleIsoMu24Group_branch and "singleIsoMu24Group" not in self.complained:
        if not self.singleIsoMu24Group_branch and "singleIsoMu24Group":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu24Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Group")
        else:
            self.singleIsoMu24Group_branch.SetAddress(<void*>&self.singleIsoMu24Group_value)

        #print "making singleIsoMu24Pass"
        self.singleIsoMu24Pass_branch = the_tree.GetBranch("singleIsoMu24Pass")
        #if not self.singleIsoMu24Pass_branch and "singleIsoMu24Pass" not in self.complained:
        if not self.singleIsoMu24Pass_branch and "singleIsoMu24Pass":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Pass")
        else:
            self.singleIsoMu24Pass_branch.SetAddress(<void*>&self.singleIsoMu24Pass_value)

        #print "making singleIsoMu24Prescale"
        self.singleIsoMu24Prescale_branch = the_tree.GetBranch("singleIsoMu24Prescale")
        #if not self.singleIsoMu24Prescale_branch and "singleIsoMu24Prescale" not in self.complained:
        if not self.singleIsoMu24Prescale_branch and "singleIsoMu24Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu24Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Prescale")
        else:
            self.singleIsoMu24Prescale_branch.SetAddress(<void*>&self.singleIsoMu24Prescale_value)

        #print "making singleIsoMu24eta2p1Group"
        self.singleIsoMu24eta2p1Group_branch = the_tree.GetBranch("singleIsoMu24eta2p1Group")
        #if not self.singleIsoMu24eta2p1Group_branch and "singleIsoMu24eta2p1Group" not in self.complained:
        if not self.singleIsoMu24eta2p1Group_branch and "singleIsoMu24eta2p1Group":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24eta2p1Group")
        else:
            self.singleIsoMu24eta2p1Group_branch.SetAddress(<void*>&self.singleIsoMu24eta2p1Group_value)

        #print "making singleIsoMu24eta2p1Pass"
        self.singleIsoMu24eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu24eta2p1Pass")
        #if not self.singleIsoMu24eta2p1Pass_branch and "singleIsoMu24eta2p1Pass" not in self.complained:
        if not self.singleIsoMu24eta2p1Pass_branch and "singleIsoMu24eta2p1Pass":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24eta2p1Pass")
        else:
            self.singleIsoMu24eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu24eta2p1Pass_value)

        #print "making singleIsoMu24eta2p1Prescale"
        self.singleIsoMu24eta2p1Prescale_branch = the_tree.GetBranch("singleIsoMu24eta2p1Prescale")
        #if not self.singleIsoMu24eta2p1Prescale_branch and "singleIsoMu24eta2p1Prescale" not in self.complained:
        if not self.singleIsoMu24eta2p1Prescale_branch and "singleIsoMu24eta2p1Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24eta2p1Prescale")
        else:
            self.singleIsoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoMu24eta2p1Prescale_value)

        #print "making singleIsoMu27Group"
        self.singleIsoMu27Group_branch = the_tree.GetBranch("singleIsoMu27Group")
        #if not self.singleIsoMu27Group_branch and "singleIsoMu27Group" not in self.complained:
        if not self.singleIsoMu27Group_branch and "singleIsoMu27Group":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu27Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Group")
        else:
            self.singleIsoMu27Group_branch.SetAddress(<void*>&self.singleIsoMu27Group_value)

        #print "making singleIsoMu27Pass"
        self.singleIsoMu27Pass_branch = the_tree.GetBranch("singleIsoMu27Pass")
        #if not self.singleIsoMu27Pass_branch and "singleIsoMu27Pass" not in self.complained:
        if not self.singleIsoMu27Pass_branch and "singleIsoMu27Pass":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Pass")
        else:
            self.singleIsoMu27Pass_branch.SetAddress(<void*>&self.singleIsoMu27Pass_value)

        #print "making singleIsoMu27Prescale"
        self.singleIsoMu27Prescale_branch = the_tree.GetBranch("singleIsoMu27Prescale")
        #if not self.singleIsoMu27Prescale_branch and "singleIsoMu27Prescale" not in self.complained:
        if not self.singleIsoMu27Prescale_branch and "singleIsoMu27Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleIsoMu27Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Prescale")
        else:
            self.singleIsoMu27Prescale_branch.SetAddress(<void*>&self.singleIsoMu27Prescale_value)

        #print "making singleIsoTkMu20Group"
        self.singleIsoTkMu20Group_branch = the_tree.GetBranch("singleIsoTkMu20Group")
        #if not self.singleIsoTkMu20Group_branch and "singleIsoTkMu20Group" not in self.complained:
        if not self.singleIsoTkMu20Group_branch and "singleIsoTkMu20Group":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu20Group")
        else:
            self.singleIsoTkMu20Group_branch.SetAddress(<void*>&self.singleIsoTkMu20Group_value)

        #print "making singleIsoTkMu20Pass"
        self.singleIsoTkMu20Pass_branch = the_tree.GetBranch("singleIsoTkMu20Pass")
        #if not self.singleIsoTkMu20Pass_branch and "singleIsoTkMu20Pass" not in self.complained:
        if not self.singleIsoTkMu20Pass_branch and "singleIsoTkMu20Pass":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu20Pass")
        else:
            self.singleIsoTkMu20Pass_branch.SetAddress(<void*>&self.singleIsoTkMu20Pass_value)

        #print "making singleIsoTkMu20Prescale"
        self.singleIsoTkMu20Prescale_branch = the_tree.GetBranch("singleIsoTkMu20Prescale")
        #if not self.singleIsoTkMu20Prescale_branch and "singleIsoTkMu20Prescale" not in self.complained:
        if not self.singleIsoTkMu20Prescale_branch and "singleIsoTkMu20Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu20Prescale")
        else:
            self.singleIsoTkMu20Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu20Prescale_value)

        #print "making singleIsoTkMu22Group"
        self.singleIsoTkMu22Group_branch = the_tree.GetBranch("singleIsoTkMu22Group")
        #if not self.singleIsoTkMu22Group_branch and "singleIsoTkMu22Group" not in self.complained:
        if not self.singleIsoTkMu22Group_branch and "singleIsoTkMu22Group":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu22Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Group")
        else:
            self.singleIsoTkMu22Group_branch.SetAddress(<void*>&self.singleIsoTkMu22Group_value)

        #print "making singleIsoTkMu22Pass"
        self.singleIsoTkMu22Pass_branch = the_tree.GetBranch("singleIsoTkMu22Pass")
        #if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass" not in self.complained:
        if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Pass")
        else:
            self.singleIsoTkMu22Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22Pass_value)

        #print "making singleIsoTkMu22Prescale"
        self.singleIsoTkMu22Prescale_branch = the_tree.GetBranch("singleIsoTkMu22Prescale")
        #if not self.singleIsoTkMu22Prescale_branch and "singleIsoTkMu22Prescale" not in self.complained:
        if not self.singleIsoTkMu22Prescale_branch and "singleIsoTkMu22Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu22Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Prescale")
        else:
            self.singleIsoTkMu22Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu22Prescale_value)

        #print "making singleIsoTkMu22eta2p1Group"
        self.singleIsoTkMu22eta2p1Group_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Group")
        #if not self.singleIsoTkMu22eta2p1Group_branch and "singleIsoTkMu22eta2p1Group" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Group_branch and "singleIsoTkMu22eta2p1Group":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu22eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Group")
        else:
            self.singleIsoTkMu22eta2p1Group_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Group_value)

        #print "making singleIsoTkMu22eta2p1Pass"
        self.singleIsoTkMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Pass")
        #if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Pass")
        else:
            self.singleIsoTkMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Pass_value)

        #print "making singleIsoTkMu22eta2p1Prescale"
        self.singleIsoTkMu22eta2p1Prescale_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Prescale")
        #if not self.singleIsoTkMu22eta2p1Prescale_branch and "singleIsoTkMu22eta2p1Prescale" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Prescale_branch and "singleIsoTkMu22eta2p1Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu22eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Prescale")
        else:
            self.singleIsoTkMu22eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Prescale_value)

        #print "making singleIsoTkMu24Group"
        self.singleIsoTkMu24Group_branch = the_tree.GetBranch("singleIsoTkMu24Group")
        #if not self.singleIsoTkMu24Group_branch and "singleIsoTkMu24Group" not in self.complained:
        if not self.singleIsoTkMu24Group_branch and "singleIsoTkMu24Group":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu24Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Group")
        else:
            self.singleIsoTkMu24Group_branch.SetAddress(<void*>&self.singleIsoTkMu24Group_value)

        #print "making singleIsoTkMu24Pass"
        self.singleIsoTkMu24Pass_branch = the_tree.GetBranch("singleIsoTkMu24Pass")
        #if not self.singleIsoTkMu24Pass_branch and "singleIsoTkMu24Pass" not in self.complained:
        if not self.singleIsoTkMu24Pass_branch and "singleIsoTkMu24Pass":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Pass")
        else:
            self.singleIsoTkMu24Pass_branch.SetAddress(<void*>&self.singleIsoTkMu24Pass_value)

        #print "making singleIsoTkMu24Prescale"
        self.singleIsoTkMu24Prescale_branch = the_tree.GetBranch("singleIsoTkMu24Prescale")
        #if not self.singleIsoTkMu24Prescale_branch and "singleIsoTkMu24Prescale" not in self.complained:
        if not self.singleIsoTkMu24Prescale_branch and "singleIsoTkMu24Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu24Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Prescale")
        else:
            self.singleIsoTkMu24Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu24Prescale_value)

        #print "making singleIsoTkMu24eta2p1Group"
        self.singleIsoTkMu24eta2p1Group_branch = the_tree.GetBranch("singleIsoTkMu24eta2p1Group")
        #if not self.singleIsoTkMu24eta2p1Group_branch and "singleIsoTkMu24eta2p1Group" not in self.complained:
        if not self.singleIsoTkMu24eta2p1Group_branch and "singleIsoTkMu24eta2p1Group":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24eta2p1Group")
        else:
            self.singleIsoTkMu24eta2p1Group_branch.SetAddress(<void*>&self.singleIsoTkMu24eta2p1Group_value)

        #print "making singleIsoTkMu24eta2p1Pass"
        self.singleIsoTkMu24eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu24eta2p1Pass")
        #if not self.singleIsoTkMu24eta2p1Pass_branch and "singleIsoTkMu24eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu24eta2p1Pass_branch and "singleIsoTkMu24eta2p1Pass":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24eta2p1Pass")
        else:
            self.singleIsoTkMu24eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu24eta2p1Pass_value)

        #print "making singleIsoTkMu24eta2p1Prescale"
        self.singleIsoTkMu24eta2p1Prescale_branch = the_tree.GetBranch("singleIsoTkMu24eta2p1Prescale")
        #if not self.singleIsoTkMu24eta2p1Prescale_branch and "singleIsoTkMu24eta2p1Prescale" not in self.complained:
        if not self.singleIsoTkMu24eta2p1Prescale_branch and "singleIsoTkMu24eta2p1Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleIsoTkMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24eta2p1Prescale")
        else:
            self.singleIsoTkMu24eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu24eta2p1Prescale_value)

        #print "making singleMu17SingleE12Group"
        self.singleMu17SingleE12Group_branch = the_tree.GetBranch("singleMu17SingleE12Group")
        #if not self.singleMu17SingleE12Group_branch and "singleMu17SingleE12Group" not in self.complained:
        if not self.singleMu17SingleE12Group_branch and "singleMu17SingleE12Group":
            warnings.warn( "EMuMuTree: Expected branch singleMu17SingleE12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu17SingleE12Group")
        else:
            self.singleMu17SingleE12Group_branch.SetAddress(<void*>&self.singleMu17SingleE12Group_value)

        #print "making singleMu17SingleE12Pass"
        self.singleMu17SingleE12Pass_branch = the_tree.GetBranch("singleMu17SingleE12Pass")
        #if not self.singleMu17SingleE12Pass_branch and "singleMu17SingleE12Pass" not in self.complained:
        if not self.singleMu17SingleE12Pass_branch and "singleMu17SingleE12Pass":
            warnings.warn( "EMuMuTree: Expected branch singleMu17SingleE12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu17SingleE12Pass")
        else:
            self.singleMu17SingleE12Pass_branch.SetAddress(<void*>&self.singleMu17SingleE12Pass_value)

        #print "making singleMu17SingleE12Prescale"
        self.singleMu17SingleE12Prescale_branch = the_tree.GetBranch("singleMu17SingleE12Prescale")
        #if not self.singleMu17SingleE12Prescale_branch and "singleMu17SingleE12Prescale" not in self.complained:
        if not self.singleMu17SingleE12Prescale_branch and "singleMu17SingleE12Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleMu17SingleE12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu17SingleE12Prescale")
        else:
            self.singleMu17SingleE12Prescale_branch.SetAddress(<void*>&self.singleMu17SingleE12Prescale_value)

        #print "making singleMu19eta2p1LooseTau20Group"
        self.singleMu19eta2p1LooseTau20Group_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Group")
        #if not self.singleMu19eta2p1LooseTau20Group_branch and "singleMu19eta2p1LooseTau20Group" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Group_branch and "singleMu19eta2p1LooseTau20Group":
            warnings.warn( "EMuMuTree: Expected branch singleMu19eta2p1LooseTau20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Group")
        else:
            self.singleMu19eta2p1LooseTau20Group_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Group_value)

        #print "making singleMu19eta2p1LooseTau20Pass"
        self.singleMu19eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Pass")
        #if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass":
            warnings.warn( "EMuMuTree: Expected branch singleMu19eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Pass")
        else:
            self.singleMu19eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Pass_value)

        #print "making singleMu19eta2p1LooseTau20Prescale"
        self.singleMu19eta2p1LooseTau20Prescale_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Prescale")
        #if not self.singleMu19eta2p1LooseTau20Prescale_branch and "singleMu19eta2p1LooseTau20Prescale" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Prescale_branch and "singleMu19eta2p1LooseTau20Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleMu19eta2p1LooseTau20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Prescale")
        else:
            self.singleMu19eta2p1LooseTau20Prescale_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Prescale_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Group"
        self.singleMu19eta2p1LooseTau20singleL1Group_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Group")
        #if not self.singleMu19eta2p1LooseTau20singleL1Group_branch and "singleMu19eta2p1LooseTau20singleL1Group" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Group_branch and "singleMu19eta2p1LooseTau20singleL1Group":
            warnings.warn( "EMuMuTree: Expected branch singleMu19eta2p1LooseTau20singleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Group")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Group_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Group_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Pass"
        self.singleMu19eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass":
            warnings.warn( "EMuMuTree: Expected branch singleMu19eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Pass_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Prescale"
        self.singleMu19eta2p1LooseTau20singleL1Prescale_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Prescale")
        #if not self.singleMu19eta2p1LooseTau20singleL1Prescale_branch and "singleMu19eta2p1LooseTau20singleL1Prescale" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Prescale_branch and "singleMu19eta2p1LooseTau20singleL1Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleMu19eta2p1LooseTau20singleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Prescale")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Prescale_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Prescale_value)

        #print "making singleMu21eta2p1LooseTau20singleL1Group"
        self.singleMu21eta2p1LooseTau20singleL1Group_branch = the_tree.GetBranch("singleMu21eta2p1LooseTau20singleL1Group")
        #if not self.singleMu21eta2p1LooseTau20singleL1Group_branch and "singleMu21eta2p1LooseTau20singleL1Group" not in self.complained:
        if not self.singleMu21eta2p1LooseTau20singleL1Group_branch and "singleMu21eta2p1LooseTau20singleL1Group":
            warnings.warn( "EMuMuTree: Expected branch singleMu21eta2p1LooseTau20singleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu21eta2p1LooseTau20singleL1Group")
        else:
            self.singleMu21eta2p1LooseTau20singleL1Group_branch.SetAddress(<void*>&self.singleMu21eta2p1LooseTau20singleL1Group_value)

        #print "making singleMu21eta2p1LooseTau20singleL1Pass"
        self.singleMu21eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu21eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu21eta2p1LooseTau20singleL1Pass_branch and "singleMu21eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu21eta2p1LooseTau20singleL1Pass_branch and "singleMu21eta2p1LooseTau20singleL1Pass":
            warnings.warn( "EMuMuTree: Expected branch singleMu21eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu21eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu21eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu21eta2p1LooseTau20singleL1Pass_value)

        #print "making singleMu21eta2p1LooseTau20singleL1Prescale"
        self.singleMu21eta2p1LooseTau20singleL1Prescale_branch = the_tree.GetBranch("singleMu21eta2p1LooseTau20singleL1Prescale")
        #if not self.singleMu21eta2p1LooseTau20singleL1Prescale_branch and "singleMu21eta2p1LooseTau20singleL1Prescale" not in self.complained:
        if not self.singleMu21eta2p1LooseTau20singleL1Prescale_branch and "singleMu21eta2p1LooseTau20singleL1Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleMu21eta2p1LooseTau20singleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu21eta2p1LooseTau20singleL1Prescale")
        else:
            self.singleMu21eta2p1LooseTau20singleL1Prescale_branch.SetAddress(<void*>&self.singleMu21eta2p1LooseTau20singleL1Prescale_value)

        #print "making singleMu23SingleE12DZGroup"
        self.singleMu23SingleE12DZGroup_branch = the_tree.GetBranch("singleMu23SingleE12DZGroup")
        #if not self.singleMu23SingleE12DZGroup_branch and "singleMu23SingleE12DZGroup" not in self.complained:
        if not self.singleMu23SingleE12DZGroup_branch and "singleMu23SingleE12DZGroup":
            warnings.warn( "EMuMuTree: Expected branch singleMu23SingleE12DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZGroup")
        else:
            self.singleMu23SingleE12DZGroup_branch.SetAddress(<void*>&self.singleMu23SingleE12DZGroup_value)

        #print "making singleMu23SingleE12DZPass"
        self.singleMu23SingleE12DZPass_branch = the_tree.GetBranch("singleMu23SingleE12DZPass")
        #if not self.singleMu23SingleE12DZPass_branch and "singleMu23SingleE12DZPass" not in self.complained:
        if not self.singleMu23SingleE12DZPass_branch and "singleMu23SingleE12DZPass":
            warnings.warn( "EMuMuTree: Expected branch singleMu23SingleE12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZPass")
        else:
            self.singleMu23SingleE12DZPass_branch.SetAddress(<void*>&self.singleMu23SingleE12DZPass_value)

        #print "making singleMu23SingleE12DZPrescale"
        self.singleMu23SingleE12DZPrescale_branch = the_tree.GetBranch("singleMu23SingleE12DZPrescale")
        #if not self.singleMu23SingleE12DZPrescale_branch and "singleMu23SingleE12DZPrescale" not in self.complained:
        if not self.singleMu23SingleE12DZPrescale_branch and "singleMu23SingleE12DZPrescale":
            warnings.warn( "EMuMuTree: Expected branch singleMu23SingleE12DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZPrescale")
        else:
            self.singleMu23SingleE12DZPrescale_branch.SetAddress(<void*>&self.singleMu23SingleE12DZPrescale_value)

        #print "making singleMu23SingleE12Group"
        self.singleMu23SingleE12Group_branch = the_tree.GetBranch("singleMu23SingleE12Group")
        #if not self.singleMu23SingleE12Group_branch and "singleMu23SingleE12Group" not in self.complained:
        if not self.singleMu23SingleE12Group_branch and "singleMu23SingleE12Group":
            warnings.warn( "EMuMuTree: Expected branch singleMu23SingleE12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12Group")
        else:
            self.singleMu23SingleE12Group_branch.SetAddress(<void*>&self.singleMu23SingleE12Group_value)

        #print "making singleMu23SingleE12Pass"
        self.singleMu23SingleE12Pass_branch = the_tree.GetBranch("singleMu23SingleE12Pass")
        #if not self.singleMu23SingleE12Pass_branch and "singleMu23SingleE12Pass" not in self.complained:
        if not self.singleMu23SingleE12Pass_branch and "singleMu23SingleE12Pass":
            warnings.warn( "EMuMuTree: Expected branch singleMu23SingleE12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12Pass")
        else:
            self.singleMu23SingleE12Pass_branch.SetAddress(<void*>&self.singleMu23SingleE12Pass_value)

        #print "making singleMu23SingleE12Prescale"
        self.singleMu23SingleE12Prescale_branch = the_tree.GetBranch("singleMu23SingleE12Prescale")
        #if not self.singleMu23SingleE12Prescale_branch and "singleMu23SingleE12Prescale" not in self.complained:
        if not self.singleMu23SingleE12Prescale_branch and "singleMu23SingleE12Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleMu23SingleE12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12Prescale")
        else:
            self.singleMu23SingleE12Prescale_branch.SetAddress(<void*>&self.singleMu23SingleE12Prescale_value)

        #print "making singleMu23SingleE8Group"
        self.singleMu23SingleE8Group_branch = the_tree.GetBranch("singleMu23SingleE8Group")
        #if not self.singleMu23SingleE8Group_branch and "singleMu23SingleE8Group" not in self.complained:
        if not self.singleMu23SingleE8Group_branch and "singleMu23SingleE8Group":
            warnings.warn( "EMuMuTree: Expected branch singleMu23SingleE8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE8Group")
        else:
            self.singleMu23SingleE8Group_branch.SetAddress(<void*>&self.singleMu23SingleE8Group_value)

        #print "making singleMu23SingleE8Pass"
        self.singleMu23SingleE8Pass_branch = the_tree.GetBranch("singleMu23SingleE8Pass")
        #if not self.singleMu23SingleE8Pass_branch and "singleMu23SingleE8Pass" not in self.complained:
        if not self.singleMu23SingleE8Pass_branch and "singleMu23SingleE8Pass":
            warnings.warn( "EMuMuTree: Expected branch singleMu23SingleE8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE8Pass")
        else:
            self.singleMu23SingleE8Pass_branch.SetAddress(<void*>&self.singleMu23SingleE8Pass_value)

        #print "making singleMu23SingleE8Prescale"
        self.singleMu23SingleE8Prescale_branch = the_tree.GetBranch("singleMu23SingleE8Prescale")
        #if not self.singleMu23SingleE8Prescale_branch and "singleMu23SingleE8Prescale" not in self.complained:
        if not self.singleMu23SingleE8Prescale_branch and "singleMu23SingleE8Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleMu23SingleE8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE8Prescale")
        else:
            self.singleMu23SingleE8Prescale_branch.SetAddress(<void*>&self.singleMu23SingleE8Prescale_value)

        #print "making singleMu8SingleE23DZGroup"
        self.singleMu8SingleE23DZGroup_branch = the_tree.GetBranch("singleMu8SingleE23DZGroup")
        #if not self.singleMu8SingleE23DZGroup_branch and "singleMu8SingleE23DZGroup" not in self.complained:
        if not self.singleMu8SingleE23DZGroup_branch and "singleMu8SingleE23DZGroup":
            warnings.warn( "EMuMuTree: Expected branch singleMu8SingleE23DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZGroup")
        else:
            self.singleMu8SingleE23DZGroup_branch.SetAddress(<void*>&self.singleMu8SingleE23DZGroup_value)

        #print "making singleMu8SingleE23DZPass"
        self.singleMu8SingleE23DZPass_branch = the_tree.GetBranch("singleMu8SingleE23DZPass")
        #if not self.singleMu8SingleE23DZPass_branch and "singleMu8SingleE23DZPass" not in self.complained:
        if not self.singleMu8SingleE23DZPass_branch and "singleMu8SingleE23DZPass":
            warnings.warn( "EMuMuTree: Expected branch singleMu8SingleE23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZPass")
        else:
            self.singleMu8SingleE23DZPass_branch.SetAddress(<void*>&self.singleMu8SingleE23DZPass_value)

        #print "making singleMu8SingleE23DZPrescale"
        self.singleMu8SingleE23DZPrescale_branch = the_tree.GetBranch("singleMu8SingleE23DZPrescale")
        #if not self.singleMu8SingleE23DZPrescale_branch and "singleMu8SingleE23DZPrescale" not in self.complained:
        if not self.singleMu8SingleE23DZPrescale_branch and "singleMu8SingleE23DZPrescale":
            warnings.warn( "EMuMuTree: Expected branch singleMu8SingleE23DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZPrescale")
        else:
            self.singleMu8SingleE23DZPrescale_branch.SetAddress(<void*>&self.singleMu8SingleE23DZPrescale_value)

        #print "making singleMuGroup"
        self.singleMuGroup_branch = the_tree.GetBranch("singleMuGroup")
        #if not self.singleMuGroup_branch and "singleMuGroup" not in self.complained:
        if not self.singleMuGroup_branch and "singleMuGroup":
            warnings.warn( "EMuMuTree: Expected branch singleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuGroup")
        else:
            self.singleMuGroup_branch.SetAddress(<void*>&self.singleMuGroup_value)

        #print "making singleMuPass"
        self.singleMuPass_branch = the_tree.GetBranch("singleMuPass")
        #if not self.singleMuPass_branch and "singleMuPass" not in self.complained:
        if not self.singleMuPass_branch and "singleMuPass":
            warnings.warn( "EMuMuTree: Expected branch singleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPass")
        else:
            self.singleMuPass_branch.SetAddress(<void*>&self.singleMuPass_value)

        #print "making singleMuPrescale"
        self.singleMuPrescale_branch = the_tree.GetBranch("singleMuPrescale")
        #if not self.singleMuPrescale_branch and "singleMuPrescale" not in self.complained:
        if not self.singleMuPrescale_branch and "singleMuPrescale":
            warnings.warn( "EMuMuTree: Expected branch singleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPrescale")
        else:
            self.singleMuPrescale_branch.SetAddress(<void*>&self.singleMuPrescale_value)

        #print "making singleMuSingleEGroup"
        self.singleMuSingleEGroup_branch = the_tree.GetBranch("singleMuSingleEGroup")
        #if not self.singleMuSingleEGroup_branch and "singleMuSingleEGroup" not in self.complained:
        if not self.singleMuSingleEGroup_branch and "singleMuSingleEGroup":
            warnings.warn( "EMuMuTree: Expected branch singleMuSingleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuSingleEGroup")
        else:
            self.singleMuSingleEGroup_branch.SetAddress(<void*>&self.singleMuSingleEGroup_value)

        #print "making singleMuSingleEPass"
        self.singleMuSingleEPass_branch = the_tree.GetBranch("singleMuSingleEPass")
        #if not self.singleMuSingleEPass_branch and "singleMuSingleEPass" not in self.complained:
        if not self.singleMuSingleEPass_branch and "singleMuSingleEPass":
            warnings.warn( "EMuMuTree: Expected branch singleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuSingleEPass")
        else:
            self.singleMuSingleEPass_branch.SetAddress(<void*>&self.singleMuSingleEPass_value)

        #print "making singleMuSingleEPrescale"
        self.singleMuSingleEPrescale_branch = the_tree.GetBranch("singleMuSingleEPrescale")
        #if not self.singleMuSingleEPrescale_branch and "singleMuSingleEPrescale" not in self.complained:
        if not self.singleMuSingleEPrescale_branch and "singleMuSingleEPrescale":
            warnings.warn( "EMuMuTree: Expected branch singleMuSingleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuSingleEPrescale")
        else:
            self.singleMuSingleEPrescale_branch.SetAddress(<void*>&self.singleMuSingleEPrescale_value)

        #print "making singleMu_leg1Group"
        self.singleMu_leg1Group_branch = the_tree.GetBranch("singleMu_leg1Group")
        #if not self.singleMu_leg1Group_branch and "singleMu_leg1Group" not in self.complained:
        if not self.singleMu_leg1Group_branch and "singleMu_leg1Group":
            warnings.warn( "EMuMuTree: Expected branch singleMu_leg1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Group")
        else:
            self.singleMu_leg1Group_branch.SetAddress(<void*>&self.singleMu_leg1Group_value)

        #print "making singleMu_leg1Pass"
        self.singleMu_leg1Pass_branch = the_tree.GetBranch("singleMu_leg1Pass")
        #if not self.singleMu_leg1Pass_branch and "singleMu_leg1Pass" not in self.complained:
        if not self.singleMu_leg1Pass_branch and "singleMu_leg1Pass":
            warnings.warn( "EMuMuTree: Expected branch singleMu_leg1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Pass")
        else:
            self.singleMu_leg1Pass_branch.SetAddress(<void*>&self.singleMu_leg1Pass_value)

        #print "making singleMu_leg1Prescale"
        self.singleMu_leg1Prescale_branch = the_tree.GetBranch("singleMu_leg1Prescale")
        #if not self.singleMu_leg1Prescale_branch and "singleMu_leg1Prescale" not in self.complained:
        if not self.singleMu_leg1Prescale_branch and "singleMu_leg1Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleMu_leg1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Prescale")
        else:
            self.singleMu_leg1Prescale_branch.SetAddress(<void*>&self.singleMu_leg1Prescale_value)

        #print "making singleMu_leg1_noisoGroup"
        self.singleMu_leg1_noisoGroup_branch = the_tree.GetBranch("singleMu_leg1_noisoGroup")
        #if not self.singleMu_leg1_noisoGroup_branch and "singleMu_leg1_noisoGroup" not in self.complained:
        if not self.singleMu_leg1_noisoGroup_branch and "singleMu_leg1_noisoGroup":
            warnings.warn( "EMuMuTree: Expected branch singleMu_leg1_noisoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoGroup")
        else:
            self.singleMu_leg1_noisoGroup_branch.SetAddress(<void*>&self.singleMu_leg1_noisoGroup_value)

        #print "making singleMu_leg1_noisoPass"
        self.singleMu_leg1_noisoPass_branch = the_tree.GetBranch("singleMu_leg1_noisoPass")
        #if not self.singleMu_leg1_noisoPass_branch and "singleMu_leg1_noisoPass" not in self.complained:
        if not self.singleMu_leg1_noisoPass_branch and "singleMu_leg1_noisoPass":
            warnings.warn( "EMuMuTree: Expected branch singleMu_leg1_noisoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoPass")
        else:
            self.singleMu_leg1_noisoPass_branch.SetAddress(<void*>&self.singleMu_leg1_noisoPass_value)

        #print "making singleMu_leg1_noisoPrescale"
        self.singleMu_leg1_noisoPrescale_branch = the_tree.GetBranch("singleMu_leg1_noisoPrescale")
        #if not self.singleMu_leg1_noisoPrescale_branch and "singleMu_leg1_noisoPrescale" not in self.complained:
        if not self.singleMu_leg1_noisoPrescale_branch and "singleMu_leg1_noisoPrescale":
            warnings.warn( "EMuMuTree: Expected branch singleMu_leg1_noisoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoPrescale")
        else:
            self.singleMu_leg1_noisoPrescale_branch.SetAddress(<void*>&self.singleMu_leg1_noisoPrescale_value)

        #print "making singleMu_leg2Group"
        self.singleMu_leg2Group_branch = the_tree.GetBranch("singleMu_leg2Group")
        #if not self.singleMu_leg2Group_branch and "singleMu_leg2Group" not in self.complained:
        if not self.singleMu_leg2Group_branch and "singleMu_leg2Group":
            warnings.warn( "EMuMuTree: Expected branch singleMu_leg2Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Group")
        else:
            self.singleMu_leg2Group_branch.SetAddress(<void*>&self.singleMu_leg2Group_value)

        #print "making singleMu_leg2Pass"
        self.singleMu_leg2Pass_branch = the_tree.GetBranch("singleMu_leg2Pass")
        #if not self.singleMu_leg2Pass_branch and "singleMu_leg2Pass" not in self.complained:
        if not self.singleMu_leg2Pass_branch and "singleMu_leg2Pass":
            warnings.warn( "EMuMuTree: Expected branch singleMu_leg2Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Pass")
        else:
            self.singleMu_leg2Pass_branch.SetAddress(<void*>&self.singleMu_leg2Pass_value)

        #print "making singleMu_leg2Prescale"
        self.singleMu_leg2Prescale_branch = the_tree.GetBranch("singleMu_leg2Prescale")
        #if not self.singleMu_leg2Prescale_branch and "singleMu_leg2Prescale" not in self.complained:
        if not self.singleMu_leg2Prescale_branch and "singleMu_leg2Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleMu_leg2Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Prescale")
        else:
            self.singleMu_leg2Prescale_branch.SetAddress(<void*>&self.singleMu_leg2Prescale_value)

        #print "making singleMu_leg2_noisoGroup"
        self.singleMu_leg2_noisoGroup_branch = the_tree.GetBranch("singleMu_leg2_noisoGroup")
        #if not self.singleMu_leg2_noisoGroup_branch and "singleMu_leg2_noisoGroup" not in self.complained:
        if not self.singleMu_leg2_noisoGroup_branch and "singleMu_leg2_noisoGroup":
            warnings.warn( "EMuMuTree: Expected branch singleMu_leg2_noisoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoGroup")
        else:
            self.singleMu_leg2_noisoGroup_branch.SetAddress(<void*>&self.singleMu_leg2_noisoGroup_value)

        #print "making singleMu_leg2_noisoPass"
        self.singleMu_leg2_noisoPass_branch = the_tree.GetBranch("singleMu_leg2_noisoPass")
        #if not self.singleMu_leg2_noisoPass_branch and "singleMu_leg2_noisoPass" not in self.complained:
        if not self.singleMu_leg2_noisoPass_branch and "singleMu_leg2_noisoPass":
            warnings.warn( "EMuMuTree: Expected branch singleMu_leg2_noisoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoPass")
        else:
            self.singleMu_leg2_noisoPass_branch.SetAddress(<void*>&self.singleMu_leg2_noisoPass_value)

        #print "making singleMu_leg2_noisoPrescale"
        self.singleMu_leg2_noisoPrescale_branch = the_tree.GetBranch("singleMu_leg2_noisoPrescale")
        #if not self.singleMu_leg2_noisoPrescale_branch and "singleMu_leg2_noisoPrescale" not in self.complained:
        if not self.singleMu_leg2_noisoPrescale_branch and "singleMu_leg2_noisoPrescale":
            warnings.warn( "EMuMuTree: Expected branch singleMu_leg2_noisoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoPrescale")
        else:
            self.singleMu_leg2_noisoPrescale_branch.SetAddress(<void*>&self.singleMu_leg2_noisoPrescale_value)

        #print "making singleTau140Group"
        self.singleTau140Group_branch = the_tree.GetBranch("singleTau140Group")
        #if not self.singleTau140Group_branch and "singleTau140Group" not in self.complained:
        if not self.singleTau140Group_branch and "singleTau140Group":
            warnings.warn( "EMuMuTree: Expected branch singleTau140Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Group")
        else:
            self.singleTau140Group_branch.SetAddress(<void*>&self.singleTau140Group_value)

        #print "making singleTau140Pass"
        self.singleTau140Pass_branch = the_tree.GetBranch("singleTau140Pass")
        #if not self.singleTau140Pass_branch and "singleTau140Pass" not in self.complained:
        if not self.singleTau140Pass_branch and "singleTau140Pass":
            warnings.warn( "EMuMuTree: Expected branch singleTau140Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Pass")
        else:
            self.singleTau140Pass_branch.SetAddress(<void*>&self.singleTau140Pass_value)

        #print "making singleTau140Prescale"
        self.singleTau140Prescale_branch = the_tree.GetBranch("singleTau140Prescale")
        #if not self.singleTau140Prescale_branch and "singleTau140Prescale" not in self.complained:
        if not self.singleTau140Prescale_branch and "singleTau140Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleTau140Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Prescale")
        else:
            self.singleTau140Prescale_branch.SetAddress(<void*>&self.singleTau140Prescale_value)

        #print "making singleTau140Trk50Group"
        self.singleTau140Trk50Group_branch = the_tree.GetBranch("singleTau140Trk50Group")
        #if not self.singleTau140Trk50Group_branch and "singleTau140Trk50Group" not in self.complained:
        if not self.singleTau140Trk50Group_branch and "singleTau140Trk50Group":
            warnings.warn( "EMuMuTree: Expected branch singleTau140Trk50Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Trk50Group")
        else:
            self.singleTau140Trk50Group_branch.SetAddress(<void*>&self.singleTau140Trk50Group_value)

        #print "making singleTau140Trk50Pass"
        self.singleTau140Trk50Pass_branch = the_tree.GetBranch("singleTau140Trk50Pass")
        #if not self.singleTau140Trk50Pass_branch and "singleTau140Trk50Pass" not in self.complained:
        if not self.singleTau140Trk50Pass_branch and "singleTau140Trk50Pass":
            warnings.warn( "EMuMuTree: Expected branch singleTau140Trk50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Trk50Pass")
        else:
            self.singleTau140Trk50Pass_branch.SetAddress(<void*>&self.singleTau140Trk50Pass_value)

        #print "making singleTau140Trk50Prescale"
        self.singleTau140Trk50Prescale_branch = the_tree.GetBranch("singleTau140Trk50Prescale")
        #if not self.singleTau140Trk50Prescale_branch and "singleTau140Trk50Prescale" not in self.complained:
        if not self.singleTau140Trk50Prescale_branch and "singleTau140Trk50Prescale":
            warnings.warn( "EMuMuTree: Expected branch singleTau140Trk50Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Trk50Prescale")
        else:
            self.singleTau140Trk50Prescale_branch.SetAddress(<void*>&self.singleTau140Trk50Prescale_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "EMuMuTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "EMuMuTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "EMuMuTree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "EMuMuTree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

        #print "making tripleEGroup"
        self.tripleEGroup_branch = the_tree.GetBranch("tripleEGroup")
        #if not self.tripleEGroup_branch and "tripleEGroup" not in self.complained:
        if not self.tripleEGroup_branch and "tripleEGroup":
            warnings.warn( "EMuMuTree: Expected branch tripleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEGroup")
        else:
            self.tripleEGroup_branch.SetAddress(<void*>&self.tripleEGroup_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "EMuMuTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleEPrescale"
        self.tripleEPrescale_branch = the_tree.GetBranch("tripleEPrescale")
        #if not self.tripleEPrescale_branch and "tripleEPrescale" not in self.complained:
        if not self.tripleEPrescale_branch and "tripleEPrescale":
            warnings.warn( "EMuMuTree: Expected branch tripleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPrescale")
        else:
            self.tripleEPrescale_branch.SetAddress(<void*>&self.tripleEPrescale_value)

        #print "making tripleMuGroup"
        self.tripleMuGroup_branch = the_tree.GetBranch("tripleMuGroup")
        #if not self.tripleMuGroup_branch and "tripleMuGroup" not in self.complained:
        if not self.tripleMuGroup_branch and "tripleMuGroup":
            warnings.warn( "EMuMuTree: Expected branch tripleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuGroup")
        else:
            self.tripleMuGroup_branch.SetAddress(<void*>&self.tripleMuGroup_value)

        #print "making tripleMuPass"
        self.tripleMuPass_branch = the_tree.GetBranch("tripleMuPass")
        #if not self.tripleMuPass_branch and "tripleMuPass" not in self.complained:
        if not self.tripleMuPass_branch and "tripleMuPass":
            warnings.warn( "EMuMuTree: Expected branch tripleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuPass")
        else:
            self.tripleMuPass_branch.SetAddress(<void*>&self.tripleMuPass_value)

        #print "making tripleMuPrescale"
        self.tripleMuPrescale_branch = the_tree.GetBranch("tripleMuPrescale")
        #if not self.tripleMuPrescale_branch and "tripleMuPrescale" not in self.complained:
        if not self.tripleMuPrescale_branch and "tripleMuPrescale":
            warnings.warn( "EMuMuTree: Expected branch tripleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuPrescale")
        else:
            self.tripleMuPrescale_branch.SetAddress(<void*>&self.tripleMuPrescale_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "EMuMuTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "EMuMuTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "EMuMuTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfDeta_JetEnDown"
        self.vbfDeta_JetEnDown_branch = the_tree.GetBranch("vbfDeta_JetEnDown")
        #if not self.vbfDeta_JetEnDown_branch and "vbfDeta_JetEnDown" not in self.complained:
        if not self.vbfDeta_JetEnDown_branch and "vbfDeta_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfDeta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta_JetEnDown")
        else:
            self.vbfDeta_JetEnDown_branch.SetAddress(<void*>&self.vbfDeta_JetEnDown_value)

        #print "making vbfDeta_JetEnUp"
        self.vbfDeta_JetEnUp_branch = the_tree.GetBranch("vbfDeta_JetEnUp")
        #if not self.vbfDeta_JetEnUp_branch and "vbfDeta_JetEnUp" not in self.complained:
        if not self.vbfDeta_JetEnUp_branch and "vbfDeta_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfDeta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta_JetEnUp")
        else:
            self.vbfDeta_JetEnUp_branch.SetAddress(<void*>&self.vbfDeta_JetEnUp_value)

        #print "making vbfDijetrap"
        self.vbfDijetrap_branch = the_tree.GetBranch("vbfDijetrap")
        #if not self.vbfDijetrap_branch and "vbfDijetrap" not in self.complained:
        if not self.vbfDijetrap_branch and "vbfDijetrap":
            warnings.warn( "EMuMuTree: Expected branch vbfDijetrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap")
        else:
            self.vbfDijetrap_branch.SetAddress(<void*>&self.vbfDijetrap_value)

        #print "making vbfDijetrap_JetEnDown"
        self.vbfDijetrap_JetEnDown_branch = the_tree.GetBranch("vbfDijetrap_JetEnDown")
        #if not self.vbfDijetrap_JetEnDown_branch and "vbfDijetrap_JetEnDown" not in self.complained:
        if not self.vbfDijetrap_JetEnDown_branch and "vbfDijetrap_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfDijetrap_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap_JetEnDown")
        else:
            self.vbfDijetrap_JetEnDown_branch.SetAddress(<void*>&self.vbfDijetrap_JetEnDown_value)

        #print "making vbfDijetrap_JetEnUp"
        self.vbfDijetrap_JetEnUp_branch = the_tree.GetBranch("vbfDijetrap_JetEnUp")
        #if not self.vbfDijetrap_JetEnUp_branch and "vbfDijetrap_JetEnUp" not in self.complained:
        if not self.vbfDijetrap_JetEnUp_branch and "vbfDijetrap_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfDijetrap_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap_JetEnUp")
        else:
            self.vbfDijetrap_JetEnUp_branch.SetAddress(<void*>&self.vbfDijetrap_JetEnUp_value)

        #print "making vbfDphi"
        self.vbfDphi_branch = the_tree.GetBranch("vbfDphi")
        #if not self.vbfDphi_branch and "vbfDphi" not in self.complained:
        if not self.vbfDphi_branch and "vbfDphi":
            warnings.warn( "EMuMuTree: Expected branch vbfDphi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi")
        else:
            self.vbfDphi_branch.SetAddress(<void*>&self.vbfDphi_value)

        #print "making vbfDphi_JetEnDown"
        self.vbfDphi_JetEnDown_branch = the_tree.GetBranch("vbfDphi_JetEnDown")
        #if not self.vbfDphi_JetEnDown_branch and "vbfDphi_JetEnDown" not in self.complained:
        if not self.vbfDphi_JetEnDown_branch and "vbfDphi_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfDphi_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi_JetEnDown")
        else:
            self.vbfDphi_JetEnDown_branch.SetAddress(<void*>&self.vbfDphi_JetEnDown_value)

        #print "making vbfDphi_JetEnUp"
        self.vbfDphi_JetEnUp_branch = the_tree.GetBranch("vbfDphi_JetEnUp")
        #if not self.vbfDphi_JetEnUp_branch and "vbfDphi_JetEnUp" not in self.complained:
        if not self.vbfDphi_JetEnUp_branch and "vbfDphi_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfDphi_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi_JetEnUp")
        else:
            self.vbfDphi_JetEnUp_branch.SetAddress(<void*>&self.vbfDphi_JetEnUp_value)

        #print "making vbfDphihj"
        self.vbfDphihj_branch = the_tree.GetBranch("vbfDphihj")
        #if not self.vbfDphihj_branch and "vbfDphihj" not in self.complained:
        if not self.vbfDphihj_branch and "vbfDphihj":
            warnings.warn( "EMuMuTree: Expected branch vbfDphihj does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj")
        else:
            self.vbfDphihj_branch.SetAddress(<void*>&self.vbfDphihj_value)

        #print "making vbfDphihj_JetEnDown"
        self.vbfDphihj_JetEnDown_branch = the_tree.GetBranch("vbfDphihj_JetEnDown")
        #if not self.vbfDphihj_JetEnDown_branch and "vbfDphihj_JetEnDown" not in self.complained:
        if not self.vbfDphihj_JetEnDown_branch and "vbfDphihj_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfDphihj_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj_JetEnDown")
        else:
            self.vbfDphihj_JetEnDown_branch.SetAddress(<void*>&self.vbfDphihj_JetEnDown_value)

        #print "making vbfDphihj_JetEnUp"
        self.vbfDphihj_JetEnUp_branch = the_tree.GetBranch("vbfDphihj_JetEnUp")
        #if not self.vbfDphihj_JetEnUp_branch and "vbfDphihj_JetEnUp" not in self.complained:
        if not self.vbfDphihj_JetEnUp_branch and "vbfDphihj_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfDphihj_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj_JetEnUp")
        else:
            self.vbfDphihj_JetEnUp_branch.SetAddress(<void*>&self.vbfDphihj_JetEnUp_value)

        #print "making vbfDphihjnomet"
        self.vbfDphihjnomet_branch = the_tree.GetBranch("vbfDphihjnomet")
        #if not self.vbfDphihjnomet_branch and "vbfDphihjnomet" not in self.complained:
        if not self.vbfDphihjnomet_branch and "vbfDphihjnomet":
            warnings.warn( "EMuMuTree: Expected branch vbfDphihjnomet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet")
        else:
            self.vbfDphihjnomet_branch.SetAddress(<void*>&self.vbfDphihjnomet_value)

        #print "making vbfDphihjnomet_JetEnDown"
        self.vbfDphihjnomet_JetEnDown_branch = the_tree.GetBranch("vbfDphihjnomet_JetEnDown")
        #if not self.vbfDphihjnomet_JetEnDown_branch and "vbfDphihjnomet_JetEnDown" not in self.complained:
        if not self.vbfDphihjnomet_JetEnDown_branch and "vbfDphihjnomet_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfDphihjnomet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet_JetEnDown")
        else:
            self.vbfDphihjnomet_JetEnDown_branch.SetAddress(<void*>&self.vbfDphihjnomet_JetEnDown_value)

        #print "making vbfDphihjnomet_JetEnUp"
        self.vbfDphihjnomet_JetEnUp_branch = the_tree.GetBranch("vbfDphihjnomet_JetEnUp")
        #if not self.vbfDphihjnomet_JetEnUp_branch and "vbfDphihjnomet_JetEnUp" not in self.complained:
        if not self.vbfDphihjnomet_JetEnUp_branch and "vbfDphihjnomet_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfDphihjnomet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet_JetEnUp")
        else:
            self.vbfDphihjnomet_JetEnUp_branch.SetAddress(<void*>&self.vbfDphihjnomet_JetEnUp_value)

        #print "making vbfHrap"
        self.vbfHrap_branch = the_tree.GetBranch("vbfHrap")
        #if not self.vbfHrap_branch and "vbfHrap" not in self.complained:
        if not self.vbfHrap_branch and "vbfHrap":
            warnings.warn( "EMuMuTree: Expected branch vbfHrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap")
        else:
            self.vbfHrap_branch.SetAddress(<void*>&self.vbfHrap_value)

        #print "making vbfHrap_JetEnDown"
        self.vbfHrap_JetEnDown_branch = the_tree.GetBranch("vbfHrap_JetEnDown")
        #if not self.vbfHrap_JetEnDown_branch and "vbfHrap_JetEnDown" not in self.complained:
        if not self.vbfHrap_JetEnDown_branch and "vbfHrap_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfHrap_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap_JetEnDown")
        else:
            self.vbfHrap_JetEnDown_branch.SetAddress(<void*>&self.vbfHrap_JetEnDown_value)

        #print "making vbfHrap_JetEnUp"
        self.vbfHrap_JetEnUp_branch = the_tree.GetBranch("vbfHrap_JetEnUp")
        #if not self.vbfHrap_JetEnUp_branch and "vbfHrap_JetEnUp" not in self.complained:
        if not self.vbfHrap_JetEnUp_branch and "vbfHrap_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfHrap_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap_JetEnUp")
        else:
            self.vbfHrap_JetEnUp_branch.SetAddress(<void*>&self.vbfHrap_JetEnUp_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "EMuMuTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto20_JetEnDown"
        self.vbfJetVeto20_JetEnDown_branch = the_tree.GetBranch("vbfJetVeto20_JetEnDown")
        #if not self.vbfJetVeto20_JetEnDown_branch and "vbfJetVeto20_JetEnDown" not in self.complained:
        if not self.vbfJetVeto20_JetEnDown_branch and "vbfJetVeto20_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfJetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20_JetEnDown")
        else:
            self.vbfJetVeto20_JetEnDown_branch.SetAddress(<void*>&self.vbfJetVeto20_JetEnDown_value)

        #print "making vbfJetVeto20_JetEnUp"
        self.vbfJetVeto20_JetEnUp_branch = the_tree.GetBranch("vbfJetVeto20_JetEnUp")
        #if not self.vbfJetVeto20_JetEnUp_branch and "vbfJetVeto20_JetEnUp" not in self.complained:
        if not self.vbfJetVeto20_JetEnUp_branch and "vbfJetVeto20_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfJetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20_JetEnUp")
        else:
            self.vbfJetVeto20_JetEnUp_branch.SetAddress(<void*>&self.vbfJetVeto20_JetEnUp_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "EMuMuTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfJetVeto30_JetEnDown"
        self.vbfJetVeto30_JetEnDown_branch = the_tree.GetBranch("vbfJetVeto30_JetEnDown")
        #if not self.vbfJetVeto30_JetEnDown_branch and "vbfJetVeto30_JetEnDown" not in self.complained:
        if not self.vbfJetVeto30_JetEnDown_branch and "vbfJetVeto30_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfJetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30_JetEnDown")
        else:
            self.vbfJetVeto30_JetEnDown_branch.SetAddress(<void*>&self.vbfJetVeto30_JetEnDown_value)

        #print "making vbfJetVeto30_JetEnUp"
        self.vbfJetVeto30_JetEnUp_branch = the_tree.GetBranch("vbfJetVeto30_JetEnUp")
        #if not self.vbfJetVeto30_JetEnUp_branch and "vbfJetVeto30_JetEnUp" not in self.complained:
        if not self.vbfJetVeto30_JetEnUp_branch and "vbfJetVeto30_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfJetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30_JetEnUp")
        else:
            self.vbfJetVeto30_JetEnUp_branch.SetAddress(<void*>&self.vbfJetVeto30_JetEnUp_value)

        #print "making vbfMVA"
        self.vbfMVA_branch = the_tree.GetBranch("vbfMVA")
        #if not self.vbfMVA_branch and "vbfMVA" not in self.complained:
        if not self.vbfMVA_branch and "vbfMVA":
            warnings.warn( "EMuMuTree: Expected branch vbfMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA")
        else:
            self.vbfMVA_branch.SetAddress(<void*>&self.vbfMVA_value)

        #print "making vbfMVA_JetEnDown"
        self.vbfMVA_JetEnDown_branch = the_tree.GetBranch("vbfMVA_JetEnDown")
        #if not self.vbfMVA_JetEnDown_branch and "vbfMVA_JetEnDown" not in self.complained:
        if not self.vbfMVA_JetEnDown_branch and "vbfMVA_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfMVA_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA_JetEnDown")
        else:
            self.vbfMVA_JetEnDown_branch.SetAddress(<void*>&self.vbfMVA_JetEnDown_value)

        #print "making vbfMVA_JetEnUp"
        self.vbfMVA_JetEnUp_branch = the_tree.GetBranch("vbfMVA_JetEnUp")
        #if not self.vbfMVA_JetEnUp_branch and "vbfMVA_JetEnUp" not in self.complained:
        if not self.vbfMVA_JetEnUp_branch and "vbfMVA_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfMVA_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA_JetEnUp")
        else:
            self.vbfMVA_JetEnUp_branch.SetAddress(<void*>&self.vbfMVA_JetEnUp_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "EMuMuTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMass_JetEnDown"
        self.vbfMass_JetEnDown_branch = the_tree.GetBranch("vbfMass_JetEnDown")
        #if not self.vbfMass_JetEnDown_branch and "vbfMass_JetEnDown" not in self.complained:
        if not self.vbfMass_JetEnDown_branch and "vbfMass_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfMass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEnDown")
        else:
            self.vbfMass_JetEnDown_branch.SetAddress(<void*>&self.vbfMass_JetEnDown_value)

        #print "making vbfMass_JetEnUp"
        self.vbfMass_JetEnUp_branch = the_tree.GetBranch("vbfMass_JetEnUp")
        #if not self.vbfMass_JetEnUp_branch and "vbfMass_JetEnUp" not in self.complained:
        if not self.vbfMass_JetEnUp_branch and "vbfMass_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfMass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEnUp")
        else:
            self.vbfMass_JetEnUp_branch.SetAddress(<void*>&self.vbfMass_JetEnUp_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "EMuMuTree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets20_JetEnDown"
        self.vbfNJets20_JetEnDown_branch = the_tree.GetBranch("vbfNJets20_JetEnDown")
        #if not self.vbfNJets20_JetEnDown_branch and "vbfNJets20_JetEnDown" not in self.complained:
        if not self.vbfNJets20_JetEnDown_branch and "vbfNJets20_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfNJets20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20_JetEnDown")
        else:
            self.vbfNJets20_JetEnDown_branch.SetAddress(<void*>&self.vbfNJets20_JetEnDown_value)

        #print "making vbfNJets20_JetEnUp"
        self.vbfNJets20_JetEnUp_branch = the_tree.GetBranch("vbfNJets20_JetEnUp")
        #if not self.vbfNJets20_JetEnUp_branch and "vbfNJets20_JetEnUp" not in self.complained:
        if not self.vbfNJets20_JetEnUp_branch and "vbfNJets20_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfNJets20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20_JetEnUp")
        else:
            self.vbfNJets20_JetEnUp_branch.SetAddress(<void*>&self.vbfNJets20_JetEnUp_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "EMuMuTree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfNJets30_JetEnDown"
        self.vbfNJets30_JetEnDown_branch = the_tree.GetBranch("vbfNJets30_JetEnDown")
        #if not self.vbfNJets30_JetEnDown_branch and "vbfNJets30_JetEnDown" not in self.complained:
        if not self.vbfNJets30_JetEnDown_branch and "vbfNJets30_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfNJets30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30_JetEnDown")
        else:
            self.vbfNJets30_JetEnDown_branch.SetAddress(<void*>&self.vbfNJets30_JetEnDown_value)

        #print "making vbfNJets30_JetEnUp"
        self.vbfNJets30_JetEnUp_branch = the_tree.GetBranch("vbfNJets30_JetEnUp")
        #if not self.vbfNJets30_JetEnUp_branch and "vbfNJets30_JetEnUp" not in self.complained:
        if not self.vbfNJets30_JetEnUp_branch and "vbfNJets30_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfNJets30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30_JetEnUp")
        else:
            self.vbfNJets30_JetEnUp_branch.SetAddress(<void*>&self.vbfNJets30_JetEnUp_value)

        #print "making vbfVispt"
        self.vbfVispt_branch = the_tree.GetBranch("vbfVispt")
        #if not self.vbfVispt_branch and "vbfVispt" not in self.complained:
        if not self.vbfVispt_branch and "vbfVispt":
            warnings.warn( "EMuMuTree: Expected branch vbfVispt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt")
        else:
            self.vbfVispt_branch.SetAddress(<void*>&self.vbfVispt_value)

        #print "making vbfVispt_JetEnDown"
        self.vbfVispt_JetEnDown_branch = the_tree.GetBranch("vbfVispt_JetEnDown")
        #if not self.vbfVispt_JetEnDown_branch and "vbfVispt_JetEnDown" not in self.complained:
        if not self.vbfVispt_JetEnDown_branch and "vbfVispt_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfVispt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt_JetEnDown")
        else:
            self.vbfVispt_JetEnDown_branch.SetAddress(<void*>&self.vbfVispt_JetEnDown_value)

        #print "making vbfVispt_JetEnUp"
        self.vbfVispt_JetEnUp_branch = the_tree.GetBranch("vbfVispt_JetEnUp")
        #if not self.vbfVispt_JetEnUp_branch and "vbfVispt_JetEnUp" not in self.complained:
        if not self.vbfVispt_JetEnUp_branch and "vbfVispt_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfVispt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt_JetEnUp")
        else:
            self.vbfVispt_JetEnUp_branch.SetAddress(<void*>&self.vbfVispt_JetEnUp_value)

        #print "making vbfdijetpt"
        self.vbfdijetpt_branch = the_tree.GetBranch("vbfdijetpt")
        #if not self.vbfdijetpt_branch and "vbfdijetpt" not in self.complained:
        if not self.vbfdijetpt_branch and "vbfdijetpt":
            warnings.warn( "EMuMuTree: Expected branch vbfdijetpt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt")
        else:
            self.vbfdijetpt_branch.SetAddress(<void*>&self.vbfdijetpt_value)

        #print "making vbfdijetpt_JetEnDown"
        self.vbfdijetpt_JetEnDown_branch = the_tree.GetBranch("vbfdijetpt_JetEnDown")
        #if not self.vbfdijetpt_JetEnDown_branch and "vbfdijetpt_JetEnDown" not in self.complained:
        if not self.vbfdijetpt_JetEnDown_branch and "vbfdijetpt_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfdijetpt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt_JetEnDown")
        else:
            self.vbfdijetpt_JetEnDown_branch.SetAddress(<void*>&self.vbfdijetpt_JetEnDown_value)

        #print "making vbfdijetpt_JetEnUp"
        self.vbfdijetpt_JetEnUp_branch = the_tree.GetBranch("vbfdijetpt_JetEnUp")
        #if not self.vbfdijetpt_JetEnUp_branch and "vbfdijetpt_JetEnUp" not in self.complained:
        if not self.vbfdijetpt_JetEnUp_branch and "vbfdijetpt_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfdijetpt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt_JetEnUp")
        else:
            self.vbfdijetpt_JetEnUp_branch.SetAddress(<void*>&self.vbfdijetpt_JetEnUp_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "EMuMuTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1eta_JetEnDown"
        self.vbfj1eta_JetEnDown_branch = the_tree.GetBranch("vbfj1eta_JetEnDown")
        #if not self.vbfj1eta_JetEnDown_branch and "vbfj1eta_JetEnDown" not in self.complained:
        if not self.vbfj1eta_JetEnDown_branch and "vbfj1eta_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfj1eta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta_JetEnDown")
        else:
            self.vbfj1eta_JetEnDown_branch.SetAddress(<void*>&self.vbfj1eta_JetEnDown_value)

        #print "making vbfj1eta_JetEnUp"
        self.vbfj1eta_JetEnUp_branch = the_tree.GetBranch("vbfj1eta_JetEnUp")
        #if not self.vbfj1eta_JetEnUp_branch and "vbfj1eta_JetEnUp" not in self.complained:
        if not self.vbfj1eta_JetEnUp_branch and "vbfj1eta_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfj1eta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta_JetEnUp")
        else:
            self.vbfj1eta_JetEnUp_branch.SetAddress(<void*>&self.vbfj1eta_JetEnUp_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "EMuMuTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj1pt_JetEnDown"
        self.vbfj1pt_JetEnDown_branch = the_tree.GetBranch("vbfj1pt_JetEnDown")
        #if not self.vbfj1pt_JetEnDown_branch and "vbfj1pt_JetEnDown" not in self.complained:
        if not self.vbfj1pt_JetEnDown_branch and "vbfj1pt_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfj1pt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt_JetEnDown")
        else:
            self.vbfj1pt_JetEnDown_branch.SetAddress(<void*>&self.vbfj1pt_JetEnDown_value)

        #print "making vbfj1pt_JetEnUp"
        self.vbfj1pt_JetEnUp_branch = the_tree.GetBranch("vbfj1pt_JetEnUp")
        #if not self.vbfj1pt_JetEnUp_branch and "vbfj1pt_JetEnUp" not in self.complained:
        if not self.vbfj1pt_JetEnUp_branch and "vbfj1pt_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfj1pt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt_JetEnUp")
        else:
            self.vbfj1pt_JetEnUp_branch.SetAddress(<void*>&self.vbfj1pt_JetEnUp_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "EMuMuTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2eta_JetEnDown"
        self.vbfj2eta_JetEnDown_branch = the_tree.GetBranch("vbfj2eta_JetEnDown")
        #if not self.vbfj2eta_JetEnDown_branch and "vbfj2eta_JetEnDown" not in self.complained:
        if not self.vbfj2eta_JetEnDown_branch and "vbfj2eta_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfj2eta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta_JetEnDown")
        else:
            self.vbfj2eta_JetEnDown_branch.SetAddress(<void*>&self.vbfj2eta_JetEnDown_value)

        #print "making vbfj2eta_JetEnUp"
        self.vbfj2eta_JetEnUp_branch = the_tree.GetBranch("vbfj2eta_JetEnUp")
        #if not self.vbfj2eta_JetEnUp_branch and "vbfj2eta_JetEnUp" not in self.complained:
        if not self.vbfj2eta_JetEnUp_branch and "vbfj2eta_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfj2eta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta_JetEnUp")
        else:
            self.vbfj2eta_JetEnUp_branch.SetAddress(<void*>&self.vbfj2eta_JetEnUp_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "EMuMuTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vbfj2pt_JetEnDown"
        self.vbfj2pt_JetEnDown_branch = the_tree.GetBranch("vbfj2pt_JetEnDown")
        #if not self.vbfj2pt_JetEnDown_branch and "vbfj2pt_JetEnDown" not in self.complained:
        if not self.vbfj2pt_JetEnDown_branch and "vbfj2pt_JetEnDown":
            warnings.warn( "EMuMuTree: Expected branch vbfj2pt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt_JetEnDown")
        else:
            self.vbfj2pt_JetEnDown_branch.SetAddress(<void*>&self.vbfj2pt_JetEnDown_value)

        #print "making vbfj2pt_JetEnUp"
        self.vbfj2pt_JetEnUp_branch = the_tree.GetBranch("vbfj2pt_JetEnUp")
        #if not self.vbfj2pt_JetEnUp_branch and "vbfj2pt_JetEnUp" not in self.complained:
        if not self.vbfj2pt_JetEnUp_branch and "vbfj2pt_JetEnUp":
            warnings.warn( "EMuMuTree: Expected branch vbfj2pt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt_JetEnUp")
        else:
            self.vbfj2pt_JetEnUp_branch.SetAddress(<void*>&self.vbfj2pt_JetEnUp_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "EMuMuTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "EMuMuTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "EMuMuTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property Flag_BadChargedCandidateFilter:
        def __get__(self):
            self.Flag_BadChargedCandidateFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_BadChargedCandidateFilter_value

    property Flag_BadPFMuonFilter:
        def __get__(self):
            self.Flag_BadPFMuonFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_BadPFMuonFilter_value

    property Flag_EcalDeadCellTriggerPrimitiveFilter:
        def __get__(self):
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_EcalDeadCellTriggerPrimitiveFilter_value

    property Flag_HBHENoiseFilter:
        def __get__(self):
            self.Flag_HBHENoiseFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_HBHENoiseFilter_value

    property Flag_HBHENoiseIsoFilter:
        def __get__(self):
            self.Flag_HBHENoiseIsoFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_HBHENoiseIsoFilter_value

    property Flag_badCloneMuonFilter:
        def __get__(self):
            self.Flag_badCloneMuonFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_badCloneMuonFilter_value

    property Flag_badGlobalMuonFilter:
        def __get__(self):
            self.Flag_badGlobalMuonFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_badGlobalMuonFilter_value

    property Flag_badMuons:
        def __get__(self):
            self.Flag_badMuons_branch.GetEntry(self.localentry, 0)
            return self.Flag_badMuons_value

    property Flag_duplicateMuons:
        def __get__(self):
            self.Flag_duplicateMuons_branch.GetEntry(self.localentry, 0)
            return self.Flag_duplicateMuons_value

    property Flag_eeBadScFilter:
        def __get__(self):
            self.Flag_eeBadScFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_eeBadScFilter_value

    property Flag_globalTightHalo2016Filter:
        def __get__(self):
            self.Flag_globalTightHalo2016Filter_branch.GetEntry(self.localentry, 0)
            return self.Flag_globalTightHalo2016Filter_value

    property Flag_goodVertices:
        def __get__(self):
            self.Flag_goodVertices_branch.GetEntry(self.localentry, 0)
            return self.Flag_goodVertices_value

    property Flag_noBadMuons:
        def __get__(self):
            self.Flag_noBadMuons_branch.GetEntry(self.localentry, 0)
            return self.Flag_noBadMuons_value

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

    property dielectronVeto:
        def __get__(self):
            self.dielectronVeto_branch.GetEntry(self.localentry, 0)
            return self.dielectronVeto_value

    property dimuonVeto:
        def __get__(self):
            self.dimuonVeto_branch.GetEntry(self.localentry, 0)
            return self.dimuonVeto_value

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

    property doubleTauCmbIso35RegGroup:
        def __get__(self):
            self.doubleTauCmbIso35RegGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleTauCmbIso35RegGroup_value

    property doubleTauCmbIso35RegPass:
        def __get__(self):
            self.doubleTauCmbIso35RegPass_branch.GetEntry(self.localentry, 0)
            return self.doubleTauCmbIso35RegPass_value

    property doubleTauCmbIso35RegPrescale:
        def __get__(self):
            self.doubleTauCmbIso35RegPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleTauCmbIso35RegPrescale_value

    property doubleTauCmbIso40Group:
        def __get__(self):
            self.doubleTauCmbIso40Group_branch.GetEntry(self.localentry, 0)
            return self.doubleTauCmbIso40Group_value

    property doubleTauCmbIso40Pass:
        def __get__(self):
            self.doubleTauCmbIso40Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleTauCmbIso40Pass_value

    property doubleTauCmbIso40Prescale:
        def __get__(self):
            self.doubleTauCmbIso40Prescale_branch.GetEntry(self.localentry, 0)
            return self.doubleTauCmbIso40Prescale_value

    property doubleTauCmbIso40RegGroup:
        def __get__(self):
            self.doubleTauCmbIso40RegGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleTauCmbIso40RegGroup_value

    property doubleTauCmbIso40RegPass:
        def __get__(self):
            self.doubleTauCmbIso40RegPass_branch.GetEntry(self.localentry, 0)
            return self.doubleTauCmbIso40RegPass_value

    property doubleTauCmbIso40RegPrescale:
        def __get__(self):
            self.doubleTauCmbIso40RegPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleTauCmbIso40RegPrescale_value

    property eAbsEta:
        def __get__(self):
            self.eAbsEta_branch.GetEntry(self.localentry, 0)
            return self.eAbsEta_value

    property eCBIDLoose:
        def __get__(self):
            self.eCBIDLoose_branch.GetEntry(self.localentry, 0)
            return self.eCBIDLoose_value

    property eCBIDLooseNoIso:
        def __get__(self):
            self.eCBIDLooseNoIso_branch.GetEntry(self.localentry, 0)
            return self.eCBIDLooseNoIso_value

    property eCBIDMedium:
        def __get__(self):
            self.eCBIDMedium_branch.GetEntry(self.localentry, 0)
            return self.eCBIDMedium_value

    property eCBIDMediumNoIso:
        def __get__(self):
            self.eCBIDMediumNoIso_branch.GetEntry(self.localentry, 0)
            return self.eCBIDMediumNoIso_value

    property eCBIDTight:
        def __get__(self):
            self.eCBIDTight_branch.GetEntry(self.localentry, 0)
            return self.eCBIDTight_value

    property eCBIDTightNoIso:
        def __get__(self):
            self.eCBIDTightNoIso_branch.GetEntry(self.localentry, 0)
            return self.eCBIDTightNoIso_value

    property eCBIDVeto:
        def __get__(self):
            self.eCBIDVeto_branch.GetEntry(self.localentry, 0)
            return self.eCBIDVeto_value

    property eCBIDVetoNoIso:
        def __get__(self):
            self.eCBIDVetoNoIso_branch.GetEntry(self.localentry, 0)
            return self.eCBIDVetoNoIso_value

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

    property eComesFromHiggs:
        def __get__(self):
            self.eComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.eComesFromHiggs_value

    property eDPhiToPfMet_type1:
        def __get__(self):
            self.eDPhiToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.eDPhiToPfMet_type1_value

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

    property eEcalIsoDR03:
        def __get__(self):
            self.eEcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eEcalIsoDR03_value

    property eEffectiveArea2012Data:
        def __get__(self):
            self.eEffectiveArea2012Data_branch.GetEntry(self.localentry, 0)
            return self.eEffectiveArea2012Data_value

    property eEffectiveAreaSpring15:
        def __get__(self):
            self.eEffectiveAreaSpring15_branch.GetEntry(self.localentry, 0)
            return self.eEffectiveAreaSpring15_value

    property eEnergyError:
        def __get__(self):
            self.eEnergyError_branch.GetEntry(self.localentry, 0)
            return self.eEnergyError_value

    property eErsatzGenEta:
        def __get__(self):
            self.eErsatzGenEta_branch.GetEntry(self.localentry, 0)
            return self.eErsatzGenEta_value

    property eErsatzGenM:
        def __get__(self):
            self.eErsatzGenM_branch.GetEntry(self.localentry, 0)
            return self.eErsatzGenM_value

    property eErsatzGenPhi:
        def __get__(self):
            self.eErsatzGenPhi_branch.GetEntry(self.localentry, 0)
            return self.eErsatzGenPhi_value

    property eErsatzGenpT:
        def __get__(self):
            self.eErsatzGenpT_branch.GetEntry(self.localentry, 0)
            return self.eErsatzGenpT_value

    property eErsatzGenpX:
        def __get__(self):
            self.eErsatzGenpX_branch.GetEntry(self.localentry, 0)
            return self.eErsatzGenpX_value

    property eErsatzGenpY:
        def __get__(self):
            self.eErsatzGenpY_branch.GetEntry(self.localentry, 0)
            return self.eErsatzGenpY_value

    property eErsatzVispX:
        def __get__(self):
            self.eErsatzVispX_branch.GetEntry(self.localentry, 0)
            return self.eErsatzVispX_value

    property eErsatzVispY:
        def __get__(self):
            self.eErsatzVispY_branch.GetEntry(self.localentry, 0)
            return self.eErsatzVispY_value

    property eEta:
        def __get__(self):
            self.eEta_branch.GetEntry(self.localentry, 0)
            return self.eEta_value

    property eEta_ElectronEnDown:
        def __get__(self):
            self.eEta_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.eEta_ElectronEnDown_value

    property eEta_ElectronEnUp:
        def __get__(self):
            self.eEta_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.eEta_ElectronEnUp_value

    property eGenCharge:
        def __get__(self):
            self.eGenCharge_branch.GetEntry(self.localentry, 0)
            return self.eGenCharge_value

    property eGenDirectPromptTauDecay:
        def __get__(self):
            self.eGenDirectPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.eGenDirectPromptTauDecay_value

    property eGenEnergy:
        def __get__(self):
            self.eGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.eGenEnergy_value

    property eGenEta:
        def __get__(self):
            self.eGenEta_branch.GetEntry(self.localentry, 0)
            return self.eGenEta_value

    property eGenIsPrompt:
        def __get__(self):
            self.eGenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.eGenIsPrompt_value

    property eGenMotherPdgId:
        def __get__(self):
            self.eGenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.eGenMotherPdgId_value

    property eGenParticle:
        def __get__(self):
            self.eGenParticle_branch.GetEntry(self.localentry, 0)
            return self.eGenParticle_value

    property eGenPdgId:
        def __get__(self):
            self.eGenPdgId_branch.GetEntry(self.localentry, 0)
            return self.eGenPdgId_value

    property eGenPhi:
        def __get__(self):
            self.eGenPhi_branch.GetEntry(self.localentry, 0)
            return self.eGenPhi_value

    property eGenPrompt:
        def __get__(self):
            self.eGenPrompt_branch.GetEntry(self.localentry, 0)
            return self.eGenPrompt_value

    property eGenPromptTauDecay:
        def __get__(self):
            self.eGenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.eGenPromptTauDecay_value

    property eGenPt:
        def __get__(self):
            self.eGenPt_branch.GetEntry(self.localentry, 0)
            return self.eGenPt_value

    property eGenTauDecay:
        def __get__(self):
            self.eGenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.eGenTauDecay_value

    property eGenVZ:
        def __get__(self):
            self.eGenVZ_branch.GetEntry(self.localentry, 0)
            return self.eGenVZ_value

    property eGenVtxPVMatch:
        def __get__(self):
            self.eGenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.eGenVtxPVMatch_value

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

    property eHcalIsoDR03:
        def __get__(self):
            self.eHcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eHcalIsoDR03_value

    property eIP3D:
        def __get__(self):
            self.eIP3D_branch.GetEntry(self.localentry, 0)
            return self.eIP3D_value

    property eIP3DErr:
        def __get__(self):
            self.eIP3DErr_branch.GetEntry(self.localentry, 0)
            return self.eIP3DErr_value

    property eIsoDB03:
        def __get__(self):
            self.eIsoDB03_branch.GetEntry(self.localentry, 0)
            return self.eIsoDB03_value

    property eJetArea:
        def __get__(self):
            self.eJetArea_branch.GetEntry(self.localentry, 0)
            return self.eJetArea_value

    property eJetBtag:
        def __get__(self):
            self.eJetBtag_branch.GetEntry(self.localentry, 0)
            return self.eJetBtag_value

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

    property eJetHadronFlavour:
        def __get__(self):
            self.eJetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.eJetHadronFlavour_value

    property eJetPFCISVBtag:
        def __get__(self):
            self.eJetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.eJetPFCISVBtag_value

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

    property eLowestMll:
        def __get__(self):
            self.eLowestMll_branch.GetEntry(self.localentry, 0)
            return self.eLowestMll_value

    property eMVANonTrigCategory:
        def __get__(self):
            self.eMVANonTrigCategory_branch.GetEntry(self.localentry, 0)
            return self.eMVANonTrigCategory_value

    property eMVANonTrigID:
        def __get__(self):
            self.eMVANonTrigID_branch.GetEntry(self.localentry, 0)
            return self.eMVANonTrigID_value

    property eMVANonTrigWP80:
        def __get__(self):
            self.eMVANonTrigWP80_branch.GetEntry(self.localentry, 0)
            return self.eMVANonTrigWP80_value

    property eMVANonTrigWP90:
        def __get__(self):
            self.eMVANonTrigWP90_branch.GetEntry(self.localentry, 0)
            return self.eMVANonTrigWP90_value

    property eMVATrigCategory:
        def __get__(self):
            self.eMVATrigCategory_branch.GetEntry(self.localentry, 0)
            return self.eMVATrigCategory_value

    property eMVATrigID:
        def __get__(self):
            self.eMVATrigID_branch.GetEntry(self.localentry, 0)
            return self.eMVATrigID_value

    property eMVATrigWP80:
        def __get__(self):
            self.eMVATrigWP80_branch.GetEntry(self.localentry, 0)
            return self.eMVATrigWP80_value

    property eMVATrigWP90:
        def __get__(self):
            self.eMVATrigWP90_branch.GetEntry(self.localentry, 0)
            return self.eMVATrigWP90_value

    property eMass:
        def __get__(self):
            self.eMass_branch.GetEntry(self.localentry, 0)
            return self.eMass_value

    property eMatchesDoubleE:
        def __get__(self):
            self.eMatchesDoubleE_branch.GetEntry(self.localentry, 0)
            return self.eMatchesDoubleE_value

    property eMatchesDoubleESingleMu:
        def __get__(self):
            self.eMatchesDoubleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.eMatchesDoubleESingleMu_value

    property eMatchesDoubleMuSingleE:
        def __get__(self):
            self.eMatchesDoubleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.eMatchesDoubleMuSingleE_value

    property eMatchesEle115Filter:
        def __get__(self):
            self.eMatchesEle115Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle115Filter_value

    property eMatchesEle115Path:
        def __get__(self):
            self.eMatchesEle115Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle115Path_value

    property eMatchesEle24Tau20Filter:
        def __get__(self):
            self.eMatchesEle24Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24Tau20Filter_value

    property eMatchesEle24Tau20Path:
        def __get__(self):
            self.eMatchesEle24Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24Tau20Path_value

    property eMatchesEle24Tau20sL1Filter:
        def __get__(self):
            self.eMatchesEle24Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24Tau20sL1Filter_value

    property eMatchesEle24Tau20sL1Path:
        def __get__(self):
            self.eMatchesEle24Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24Tau20sL1Path_value

    property eMatchesEle24Tau30Filter:
        def __get__(self):
            self.eMatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24Tau30Filter_value

    property eMatchesEle24Tau30Path:
        def __get__(self):
            self.eMatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24Tau30Path_value

    property eMatchesEle25LooseFilter:
        def __get__(self):
            self.eMatchesEle25LooseFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle25LooseFilter_value

    property eMatchesEle25TightFilter:
        def __get__(self):
            self.eMatchesEle25TightFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle25TightFilter_value

    property eMatchesEle25eta2p1TightFilter:
        def __get__(self):
            self.eMatchesEle25eta2p1TightFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle25eta2p1TightFilter_value

    property eMatchesEle25eta2p1TightPath:
        def __get__(self):
            self.eMatchesEle25eta2p1TightPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle25eta2p1TightPath_value

    property eMatchesEle27TightFilter:
        def __get__(self):
            self.eMatchesEle27TightFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle27TightFilter_value

    property eMatchesEle27TightPath:
        def __get__(self):
            self.eMatchesEle27TightPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle27TightPath_value

    property eMatchesEle27eta2p1LooseFilter:
        def __get__(self):
            self.eMatchesEle27eta2p1LooseFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle27eta2p1LooseFilter_value

    property eMatchesEle27eta2p1LoosePath:
        def __get__(self):
            self.eMatchesEle27eta2p1LoosePath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle27eta2p1LoosePath_value

    property eMatchesEle45L1JetTauPath:
        def __get__(self):
            self.eMatchesEle45L1JetTauPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle45L1JetTauPath_value

    property eMatchesEle45LooseL1JetTauFilter:
        def __get__(self):
            self.eMatchesEle45LooseL1JetTauFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle45LooseL1JetTauFilter_value

    property eMatchesMu23Ele12DZFilter:
        def __get__(self):
            self.eMatchesMu23Ele12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23Ele12DZFilter_value

    property eMatchesMu23Ele12DZPath:
        def __get__(self):
            self.eMatchesMu23Ele12DZPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23Ele12DZPath_value

    property eMatchesMu23Ele12Filter:
        def __get__(self):
            self.eMatchesMu23Ele12Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23Ele12Filter_value

    property eMatchesMu23Ele12Path:
        def __get__(self):
            self.eMatchesMu23Ele12Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23Ele12Path_value

    property eMatchesMu23Ele8DZFilter:
        def __get__(self):
            self.eMatchesMu23Ele8DZFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23Ele8DZFilter_value

    property eMatchesMu23Ele8DZPath:
        def __get__(self):
            self.eMatchesMu23Ele8DZPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23Ele8DZPath_value

    property eMatchesMu23Ele8Filter:
        def __get__(self):
            self.eMatchesMu23Ele8Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23Ele8Filter_value

    property eMatchesMu23Ele8Path:
        def __get__(self):
            self.eMatchesMu23Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23Ele8Path_value

    property eMatchesMu8Ele23DZFilter:
        def __get__(self):
            self.eMatchesMu8Ele23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8Ele23DZFilter_value

    property eMatchesMu8Ele23DZPath:
        def __get__(self):
            self.eMatchesMu8Ele23DZPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8Ele23DZPath_value

    property eMatchesMu8Ele23Filter:
        def __get__(self):
            self.eMatchesMu8Ele23Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8Ele23Filter_value

    property eMatchesMu8Ele23Path:
        def __get__(self):
            self.eMatchesMu8Ele23Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8Ele23Path_value

    property eMatchesSingleE:
        def __get__(self):
            self.eMatchesSingleE_branch.GetEntry(self.localentry, 0)
            return self.eMatchesSingleE_value

    property eMatchesSingleESingleMu:
        def __get__(self):
            self.eMatchesSingleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.eMatchesSingleESingleMu_value

    property eMatchesSingleE_leg1:
        def __get__(self):
            self.eMatchesSingleE_leg1_branch.GetEntry(self.localentry, 0)
            return self.eMatchesSingleE_leg1_value

    property eMatchesSingleE_leg2:
        def __get__(self):
            self.eMatchesSingleE_leg2_branch.GetEntry(self.localentry, 0)
            return self.eMatchesSingleE_leg2_value

    property eMatchesSingleMuSingleE:
        def __get__(self):
            self.eMatchesSingleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.eMatchesSingleMuSingleE_value

    property eMatchesTripleE:
        def __get__(self):
            self.eMatchesTripleE_branch.GetEntry(self.localentry, 0)
            return self.eMatchesTripleE_value

    property eMissingHits:
        def __get__(self):
            self.eMissingHits_branch.GetEntry(self.localentry, 0)
            return self.eMissingHits_value

    property eMtToPfMet_type1:
        def __get__(self):
            self.eMtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_type1_value

    property eNearMuonVeto:
        def __get__(self):
            self.eNearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.eNearMuonVeto_value

    property eNearestMuonDR:
        def __get__(self):
            self.eNearestMuonDR_branch.GetEntry(self.localentry, 0)
            return self.eNearestMuonDR_value

    property eNearestZMass:
        def __get__(self):
            self.eNearestZMass_branch.GetEntry(self.localentry, 0)
            return self.eNearestZMass_value

    property ePFChargedIso:
        def __get__(self):
            self.ePFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.ePFChargedIso_value

    property ePFNeutralIso:
        def __get__(self):
            self.ePFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.ePFNeutralIso_value

    property ePFPUChargedIso:
        def __get__(self):
            self.ePFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.ePFPUChargedIso_value

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

    property ePassesConversionVeto:
        def __get__(self):
            self.ePassesConversionVeto_branch.GetEntry(self.localentry, 0)
            return self.ePassesConversionVeto_value

    property ePhi:
        def __get__(self):
            self.ePhi_branch.GetEntry(self.localentry, 0)
            return self.ePhi_value

    property ePhi_ElectronEnDown:
        def __get__(self):
            self.ePhi_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.ePhi_ElectronEnDown_value

    property ePhi_ElectronEnUp:
        def __get__(self):
            self.ePhi_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.ePhi_ElectronEnUp_value

    property ePt:
        def __get__(self):
            self.ePt_branch.GetEntry(self.localentry, 0)
            return self.ePt_value

    property ePt_ElectronEnDown:
        def __get__(self):
            self.ePt_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.ePt_ElectronEnDown_value

    property ePt_ElectronEnUp:
        def __get__(self):
            self.ePt_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.ePt_ElectronEnUp_value

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

    property eRho:
        def __get__(self):
            self.eRho_branch.GetEntry(self.localentry, 0)
            return self.eRho_value

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

    property eSIP2D:
        def __get__(self):
            self.eSIP2D_branch.GetEntry(self.localentry, 0)
            return self.eSIP2D_value

    property eSIP3D:
        def __get__(self):
            self.eSIP3D_branch.GetEntry(self.localentry, 0)
            return self.eSIP3D_value

    property eSigmaIEtaIEta:
        def __get__(self):
            self.eSigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.eSigmaIEtaIEta_value

    property eTrkIsoDR03:
        def __get__(self):
            self.eTrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eTrkIsoDR03_value

    property eVZ:
        def __get__(self):
            self.eVZ_branch.GetEntry(self.localentry, 0)
            return self.eVZ_value

    property eVetoMVAIso:
        def __get__(self):
            self.eVetoMVAIso_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIso_value

    property eVetoMVAIsoVtx:
        def __get__(self):
            self.eVetoMVAIsoVtx_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIsoVtx_value

    property eVetoZTTp001dxyz:
        def __get__(self):
            self.eVetoZTTp001dxyz_branch.GetEntry(self.localentry, 0)
            return self.eVetoZTTp001dxyz_value

    property eVetoZTTp001dxyzR0:
        def __get__(self):
            self.eVetoZTTp001dxyzR0_branch.GetEntry(self.localentry, 0)
            return self.eVetoZTTp001dxyzR0_value

    property eWWLoose:
        def __get__(self):
            self.eWWLoose_branch.GetEntry(self.localentry, 0)
            return self.eWWLoose_value

    property eZTTGenMatching:
        def __get__(self):
            self.eZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.eZTTGenMatching_value

    property e_m1_CosThetaStar:
        def __get__(self):
            self.e_m1_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e_m1_CosThetaStar_value

    property e_m1_DPhi:
        def __get__(self):
            self.e_m1_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e_m1_DPhi_value

    property e_m1_DR:
        def __get__(self):
            self.e_m1_DR_branch.GetEntry(self.localentry, 0)
            return self.e_m1_DR_value

    property e_m1_Eta:
        def __get__(self):
            self.e_m1_Eta_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Eta_value

    property e_m1_Mass:
        def __get__(self):
            self.e_m1_Mass_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Mass_value

    property e_m1_Mass_TauEnDown:
        def __get__(self):
            self.e_m1_Mass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Mass_TauEnDown_value

    property e_m1_Mass_TauEnUp:
        def __get__(self):
            self.e_m1_Mass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Mass_TauEnUp_value

    property e_m1_Mt:
        def __get__(self):
            self.e_m1_Mt_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Mt_value

    property e_m1_MtTotal:
        def __get__(self):
            self.e_m1_MtTotal_branch.GetEntry(self.localentry, 0)
            return self.e_m1_MtTotal_value

    property e_m1_Mt_TauEnDown:
        def __get__(self):
            self.e_m1_Mt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Mt_TauEnDown_value

    property e_m1_Mt_TauEnUp:
        def __get__(self):
            self.e_m1_Mt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Mt_TauEnUp_value

    property e_m1_MvaMet:
        def __get__(self):
            self.e_m1_MvaMet_branch.GetEntry(self.localentry, 0)
            return self.e_m1_MvaMet_value

    property e_m1_MvaMetCovMatrix00:
        def __get__(self):
            self.e_m1_MvaMetCovMatrix00_branch.GetEntry(self.localentry, 0)
            return self.e_m1_MvaMetCovMatrix00_value

    property e_m1_MvaMetCovMatrix01:
        def __get__(self):
            self.e_m1_MvaMetCovMatrix01_branch.GetEntry(self.localentry, 0)
            return self.e_m1_MvaMetCovMatrix01_value

    property e_m1_MvaMetCovMatrix10:
        def __get__(self):
            self.e_m1_MvaMetCovMatrix10_branch.GetEntry(self.localentry, 0)
            return self.e_m1_MvaMetCovMatrix10_value

    property e_m1_MvaMetCovMatrix11:
        def __get__(self):
            self.e_m1_MvaMetCovMatrix11_branch.GetEntry(self.localentry, 0)
            return self.e_m1_MvaMetCovMatrix11_value

    property e_m1_MvaMetPhi:
        def __get__(self):
            self.e_m1_MvaMetPhi_branch.GetEntry(self.localentry, 0)
            return self.e_m1_MvaMetPhi_value

    property e_m1_PZeta:
        def __get__(self):
            self.e_m1_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e_m1_PZeta_value

    property e_m1_PZetaLess0p85PZetaVis:
        def __get__(self):
            self.e_m1_PZetaLess0p85PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_m1_PZetaLess0p85PZetaVis_value

    property e_m1_PZetaVis:
        def __get__(self):
            self.e_m1_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_m1_PZetaVis_value

    property e_m1_Phi:
        def __get__(self):
            self.e_m1_Phi_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Phi_value

    property e_m1_Pt:
        def __get__(self):
            self.e_m1_Pt_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Pt_value

    property e_m1_SS:
        def __get__(self):
            self.e_m1_SS_branch.GetEntry(self.localentry, 0)
            return self.e_m1_SS_value

    property e_m1_ToMETDPhi_Ty1:
        def __get__(self):
            self.e_m1_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e_m1_ToMETDPhi_Ty1_value

    property e_m1_collinearmass:
        def __get__(self):
            self.e_m1_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_value

    property e_m1_collinearmass_CheckUESDown:
        def __get__(self):
            self.e_m1_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_CheckUESDown_value

    property e_m1_collinearmass_CheckUESUp:
        def __get__(self):
            self.e_m1_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_CheckUESUp_value

    property e_m1_collinearmass_EleEnDown:
        def __get__(self):
            self.e_m1_collinearmass_EleEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_EleEnDown_value

    property e_m1_collinearmass_EleEnUp:
        def __get__(self):
            self.e_m1_collinearmass_EleEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_EleEnUp_value

    property e_m1_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.e_m1_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_JetCheckTotalDown_value

    property e_m1_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.e_m1_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_JetCheckTotalUp_value

    property e_m1_collinearmass_JetEnDown:
        def __get__(self):
            self.e_m1_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_JetEnDown_value

    property e_m1_collinearmass_JetEnUp:
        def __get__(self):
            self.e_m1_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_JetEnUp_value

    property e_m1_collinearmass_MuEnDown:
        def __get__(self):
            self.e_m1_collinearmass_MuEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_MuEnDown_value

    property e_m1_collinearmass_MuEnUp:
        def __get__(self):
            self.e_m1_collinearmass_MuEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_MuEnUp_value

    property e_m1_collinearmass_TauEnDown:
        def __get__(self):
            self.e_m1_collinearmass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_TauEnDown_value

    property e_m1_collinearmass_TauEnUp:
        def __get__(self):
            self.e_m1_collinearmass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_TauEnUp_value

    property e_m1_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.e_m1_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_UnclusteredEnDown_value

    property e_m1_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.e_m1_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m1_collinearmass_UnclusteredEnUp_value

    property e_m1_pt_tt:
        def __get__(self):
            self.e_m1_pt_tt_branch.GetEntry(self.localentry, 0)
            return self.e_m1_pt_tt_value

    property e_m2_CosThetaStar:
        def __get__(self):
            self.e_m2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e_m2_CosThetaStar_value

    property e_m2_DPhi:
        def __get__(self):
            self.e_m2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e_m2_DPhi_value

    property e_m2_DR:
        def __get__(self):
            self.e_m2_DR_branch.GetEntry(self.localentry, 0)
            return self.e_m2_DR_value

    property e_m2_Eta:
        def __get__(self):
            self.e_m2_Eta_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Eta_value

    property e_m2_Mass:
        def __get__(self):
            self.e_m2_Mass_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Mass_value

    property e_m2_Mass_TauEnDown:
        def __get__(self):
            self.e_m2_Mass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Mass_TauEnDown_value

    property e_m2_Mass_TauEnUp:
        def __get__(self):
            self.e_m2_Mass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Mass_TauEnUp_value

    property e_m2_Mt:
        def __get__(self):
            self.e_m2_Mt_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Mt_value

    property e_m2_MtTotal:
        def __get__(self):
            self.e_m2_MtTotal_branch.GetEntry(self.localentry, 0)
            return self.e_m2_MtTotal_value

    property e_m2_Mt_TauEnDown:
        def __get__(self):
            self.e_m2_Mt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Mt_TauEnDown_value

    property e_m2_Mt_TauEnUp:
        def __get__(self):
            self.e_m2_Mt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Mt_TauEnUp_value

    property e_m2_MvaMet:
        def __get__(self):
            self.e_m2_MvaMet_branch.GetEntry(self.localentry, 0)
            return self.e_m2_MvaMet_value

    property e_m2_MvaMetCovMatrix00:
        def __get__(self):
            self.e_m2_MvaMetCovMatrix00_branch.GetEntry(self.localentry, 0)
            return self.e_m2_MvaMetCovMatrix00_value

    property e_m2_MvaMetCovMatrix01:
        def __get__(self):
            self.e_m2_MvaMetCovMatrix01_branch.GetEntry(self.localentry, 0)
            return self.e_m2_MvaMetCovMatrix01_value

    property e_m2_MvaMetCovMatrix10:
        def __get__(self):
            self.e_m2_MvaMetCovMatrix10_branch.GetEntry(self.localentry, 0)
            return self.e_m2_MvaMetCovMatrix10_value

    property e_m2_MvaMetCovMatrix11:
        def __get__(self):
            self.e_m2_MvaMetCovMatrix11_branch.GetEntry(self.localentry, 0)
            return self.e_m2_MvaMetCovMatrix11_value

    property e_m2_MvaMetPhi:
        def __get__(self):
            self.e_m2_MvaMetPhi_branch.GetEntry(self.localentry, 0)
            return self.e_m2_MvaMetPhi_value

    property e_m2_PZeta:
        def __get__(self):
            self.e_m2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e_m2_PZeta_value

    property e_m2_PZetaLess0p85PZetaVis:
        def __get__(self):
            self.e_m2_PZetaLess0p85PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_m2_PZetaLess0p85PZetaVis_value

    property e_m2_PZetaVis:
        def __get__(self):
            self.e_m2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_m2_PZetaVis_value

    property e_m2_Phi:
        def __get__(self):
            self.e_m2_Phi_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Phi_value

    property e_m2_Pt:
        def __get__(self):
            self.e_m2_Pt_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Pt_value

    property e_m2_SS:
        def __get__(self):
            self.e_m2_SS_branch.GetEntry(self.localentry, 0)
            return self.e_m2_SS_value

    property e_m2_ToMETDPhi_Ty1:
        def __get__(self):
            self.e_m2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e_m2_ToMETDPhi_Ty1_value

    property e_m2_collinearmass:
        def __get__(self):
            self.e_m2_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_value

    property e_m2_collinearmass_CheckUESDown:
        def __get__(self):
            self.e_m2_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_CheckUESDown_value

    property e_m2_collinearmass_CheckUESUp:
        def __get__(self):
            self.e_m2_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_CheckUESUp_value

    property e_m2_collinearmass_EleEnDown:
        def __get__(self):
            self.e_m2_collinearmass_EleEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_EleEnDown_value

    property e_m2_collinearmass_EleEnUp:
        def __get__(self):
            self.e_m2_collinearmass_EleEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_EleEnUp_value

    property e_m2_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.e_m2_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_JetCheckTotalDown_value

    property e_m2_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.e_m2_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_JetCheckTotalUp_value

    property e_m2_collinearmass_JetEnDown:
        def __get__(self):
            self.e_m2_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_JetEnDown_value

    property e_m2_collinearmass_JetEnUp:
        def __get__(self):
            self.e_m2_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_JetEnUp_value

    property e_m2_collinearmass_MuEnDown:
        def __get__(self):
            self.e_m2_collinearmass_MuEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_MuEnDown_value

    property e_m2_collinearmass_MuEnUp:
        def __get__(self):
            self.e_m2_collinearmass_MuEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_MuEnUp_value

    property e_m2_collinearmass_TauEnDown:
        def __get__(self):
            self.e_m2_collinearmass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_TauEnDown_value

    property e_m2_collinearmass_TauEnUp:
        def __get__(self):
            self.e_m2_collinearmass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_TauEnUp_value

    property e_m2_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.e_m2_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_UnclusteredEnDown_value

    property e_m2_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.e_m2_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.e_m2_collinearmass_UnclusteredEnUp_value

    property e_m2_pt_tt:
        def __get__(self):
            self.e_m2_pt_tt_branch.GetEntry(self.localentry, 0)
            return self.e_m2_pt_tt_value

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

    property genEta:
        def __get__(self):
            self.genEta_branch.GetEntry(self.localentry, 0)
            return self.genEta_value

    property genHTT:
        def __get__(self):
            self.genHTT_branch.GetEntry(self.localentry, 0)
            return self.genHTT_value

    property genM:
        def __get__(self):
            self.genM_branch.GetEntry(self.localentry, 0)
            return self.genM_value

    property genMass:
        def __get__(self):
            self.genMass_branch.GetEntry(self.localentry, 0)
            return self.genMass_value

    property genPhi:
        def __get__(self):
            self.genPhi_branch.GetEntry(self.localentry, 0)
            return self.genPhi_value

    property genpT:
        def __get__(self):
            self.genpT_branch.GetEntry(self.localentry, 0)
            return self.genpT_value

    property genpX:
        def __get__(self):
            self.genpX_branch.GetEntry(self.localentry, 0)
            return self.genpX_value

    property genpY:
        def __get__(self):
            self.genpY_branch.GetEntry(self.localentry, 0)
            return self.genpY_value

    property isGtautau:
        def __get__(self):
            self.isGtautau_branch.GetEntry(self.localentry, 0)
            return self.isGtautau_value

    property isWenu:
        def __get__(self):
            self.isWenu_branch.GetEntry(self.localentry, 0)
            return self.isWenu_value

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

    property j1csv:
        def __get__(self):
            self.j1csv_branch.GetEntry(self.localentry, 0)
            return self.j1csv_value

    property j1eta:
        def __get__(self):
            self.j1eta_branch.GetEntry(self.localentry, 0)
            return self.j1eta_value

    property j1hadronflavor:
        def __get__(self):
            self.j1hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.j1hadronflavor_value

    property j1partonflavor:
        def __get__(self):
            self.j1partonflavor_branch.GetEntry(self.localentry, 0)
            return self.j1partonflavor_value

    property j1phi:
        def __get__(self):
            self.j1phi_branch.GetEntry(self.localentry, 0)
            return self.j1phi_value

    property j1pt:
        def __get__(self):
            self.j1pt_branch.GetEntry(self.localentry, 0)
            return self.j1pt_value

    property j1ptDown:
        def __get__(self):
            self.j1ptDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptDown_value

    property j1ptUp:
        def __get__(self):
            self.j1ptUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptUp_value

    property j1pu:
        def __get__(self):
            self.j1pu_branch.GetEntry(self.localentry, 0)
            return self.j1pu_value

    property j1rawf:
        def __get__(self):
            self.j1rawf_branch.GetEntry(self.localentry, 0)
            return self.j1rawf_value

    property j2csv:
        def __get__(self):
            self.j2csv_branch.GetEntry(self.localentry, 0)
            return self.j2csv_value

    property j2eta:
        def __get__(self):
            self.j2eta_branch.GetEntry(self.localentry, 0)
            return self.j2eta_value

    property j2hadronflavor:
        def __get__(self):
            self.j2hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.j2hadronflavor_value

    property j2partonflavor:
        def __get__(self):
            self.j2partonflavor_branch.GetEntry(self.localentry, 0)
            return self.j2partonflavor_value

    property j2phi:
        def __get__(self):
            self.j2phi_branch.GetEntry(self.localentry, 0)
            return self.j2phi_value

    property j2pt:
        def __get__(self):
            self.j2pt_branch.GetEntry(self.localentry, 0)
            return self.j2pt_value

    property j2ptDown:
        def __get__(self):
            self.j2ptDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptDown_value

    property j2ptUp:
        def __get__(self):
            self.j2ptUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptUp_value

    property j2pu:
        def __get__(self):
            self.j2pu_branch.GetEntry(self.localentry, 0)
            return self.j2pu_value

    property j2rawf:
        def __get__(self):
            self.j2rawf_branch.GetEntry(self.localentry, 0)
            return self.j2rawf_value

    property jb1csv:
        def __get__(self):
            self.jb1csv_branch.GetEntry(self.localentry, 0)
            return self.jb1csv_value

    property jb1csv_CSVL:
        def __get__(self):
            self.jb1csv_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1csv_CSVL_value

    property jb1eta:
        def __get__(self):
            self.jb1eta_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_value

    property jb1eta_CSVL:
        def __get__(self):
            self.jb1eta_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_CSVL_value

    property jb1hadronflavor:
        def __get__(self):
            self.jb1hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_value

    property jb1hadronflavor_CSVL:
        def __get__(self):
            self.jb1hadronflavor_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_CSVL_value

    property jb1partonflavor:
        def __get__(self):
            self.jb1partonflavor_branch.GetEntry(self.localentry, 0)
            return self.jb1partonflavor_value

    property jb1partonflavor_CSVL:
        def __get__(self):
            self.jb1partonflavor_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1partonflavor_CSVL_value

    property jb1phi:
        def __get__(self):
            self.jb1phi_branch.GetEntry(self.localentry, 0)
            return self.jb1phi_value

    property jb1phi_CSVL:
        def __get__(self):
            self.jb1phi_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1phi_CSVL_value

    property jb1pt:
        def __get__(self):
            self.jb1pt_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_value

    property jb1ptDown:
        def __get__(self):
            self.jb1ptDown_branch.GetEntry(self.localentry, 0)
            return self.jb1ptDown_value

    property jb1ptDown_CSVL:
        def __get__(self):
            self.jb1ptDown_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1ptDown_CSVL_value

    property jb1ptUp:
        def __get__(self):
            self.jb1ptUp_branch.GetEntry(self.localentry, 0)
            return self.jb1ptUp_value

    property jb1ptUp_CSVL:
        def __get__(self):
            self.jb1ptUp_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1ptUp_CSVL_value

    property jb1pt_CSVL:
        def __get__(self):
            self.jb1pt_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_CSVL_value

    property jb1pu:
        def __get__(self):
            self.jb1pu_branch.GetEntry(self.localentry, 0)
            return self.jb1pu_value

    property jb1pu_CSVL:
        def __get__(self):
            self.jb1pu_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1pu_CSVL_value

    property jb1rawf:
        def __get__(self):
            self.jb1rawf_branch.GetEntry(self.localentry, 0)
            return self.jb1rawf_value

    property jb1rawf_CSVL:
        def __get__(self):
            self.jb1rawf_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1rawf_CSVL_value

    property jb2csv:
        def __get__(self):
            self.jb2csv_branch.GetEntry(self.localentry, 0)
            return self.jb2csv_value

    property jb2csv_CSVL:
        def __get__(self):
            self.jb2csv_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2csv_CSVL_value

    property jb2eta:
        def __get__(self):
            self.jb2eta_branch.GetEntry(self.localentry, 0)
            return self.jb2eta_value

    property jb2eta_CSVL:
        def __get__(self):
            self.jb2eta_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2eta_CSVL_value

    property jb2hadronflavor:
        def __get__(self):
            self.jb2hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavor_value

    property jb2hadronflavor_CSVL:
        def __get__(self):
            self.jb2hadronflavor_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavor_CSVL_value

    property jb2partonflavor:
        def __get__(self):
            self.jb2partonflavor_branch.GetEntry(self.localentry, 0)
            return self.jb2partonflavor_value

    property jb2partonflavor_CSVL:
        def __get__(self):
            self.jb2partonflavor_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2partonflavor_CSVL_value

    property jb2phi:
        def __get__(self):
            self.jb2phi_branch.GetEntry(self.localentry, 0)
            return self.jb2phi_value

    property jb2phi_CSVL:
        def __get__(self):
            self.jb2phi_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2phi_CSVL_value

    property jb2pt:
        def __get__(self):
            self.jb2pt_branch.GetEntry(self.localentry, 0)
            return self.jb2pt_value

    property jb2ptDown:
        def __get__(self):
            self.jb2ptDown_branch.GetEntry(self.localentry, 0)
            return self.jb2ptDown_value

    property jb2ptDown_CSVL:
        def __get__(self):
            self.jb2ptDown_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2ptDown_CSVL_value

    property jb2ptUp:
        def __get__(self):
            self.jb2ptUp_branch.GetEntry(self.localentry, 0)
            return self.jb2ptUp_value

    property jb2ptUp_CSVL:
        def __get__(self):
            self.jb2ptUp_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2ptUp_CSVL_value

    property jb2pt_CSVL:
        def __get__(self):
            self.jb2pt_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2pt_CSVL_value

    property jb2pu:
        def __get__(self):
            self.jb2pu_branch.GetEntry(self.localentry, 0)
            return self.jb2pu_value

    property jb2pu_CSVL:
        def __get__(self):
            self.jb2pu_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2pu_CSVL_value

    property jb2rawf:
        def __get__(self):
            self.jb2rawf_branch.GetEntry(self.localentry, 0)
            return self.jb2rawf_value

    property jb2rawf_CSVL:
        def __get__(self):
            self.jb2rawf_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2rawf_CSVL_value

    property jetVeto20:
        def __get__(self):
            self.jetVeto20_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_value

    property jetVeto20_JetEnDown:
        def __get__(self):
            self.jetVeto20_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_JetEnDown_value

    property jetVeto20_JetEnUp:
        def __get__(self):
            self.jetVeto20_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_JetEnUp_value

    property jetVeto30:
        def __get__(self):
            self.jetVeto30_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_value

    property jetVeto30_JetEnDown:
        def __get__(self):
            self.jetVeto30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnDown_value

    property jetVeto30_JetEnUp:
        def __get__(self):
            self.jetVeto30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnUp_value

    property lumi:
        def __get__(self):
            self.lumi_branch.GetEntry(self.localentry, 0)
            return self.lumi_value

    property m1AbsEta:
        def __get__(self):
            self.m1AbsEta_branch.GetEntry(self.localentry, 0)
            return self.m1AbsEta_value

    property m1BestTrackType:
        def __get__(self):
            self.m1BestTrackType_branch.GetEntry(self.localentry, 0)
            return self.m1BestTrackType_value

    property m1Charge:
        def __get__(self):
            self.m1Charge_branch.GetEntry(self.localentry, 0)
            return self.m1Charge_value

    property m1Chi2LocalPosition:
        def __get__(self):
            self.m1Chi2LocalPosition_branch.GetEntry(self.localentry, 0)
            return self.m1Chi2LocalPosition_value

    property m1ComesFromHiggs:
        def __get__(self):
            self.m1ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.m1ComesFromHiggs_value

    property m1DPhiToPfMet_type1:
        def __get__(self):
            self.m1DPhiToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_type1_value

    property m1EcalIsoDR03:
        def __get__(self):
            self.m1EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m1EcalIsoDR03_value

    property m1EffectiveArea2011:
        def __get__(self):
            self.m1EffectiveArea2011_branch.GetEntry(self.localentry, 0)
            return self.m1EffectiveArea2011_value

    property m1EffectiveArea2012:
        def __get__(self):
            self.m1EffectiveArea2012_branch.GetEntry(self.localentry, 0)
            return self.m1EffectiveArea2012_value

    property m1ErsatzGenEta:
        def __get__(self):
            self.m1ErsatzGenEta_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzGenEta_value

    property m1ErsatzGenM:
        def __get__(self):
            self.m1ErsatzGenM_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzGenM_value

    property m1ErsatzGenPhi:
        def __get__(self):
            self.m1ErsatzGenPhi_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzGenPhi_value

    property m1ErsatzGenpT:
        def __get__(self):
            self.m1ErsatzGenpT_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzGenpT_value

    property m1ErsatzGenpX:
        def __get__(self):
            self.m1ErsatzGenpX_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzGenpX_value

    property m1ErsatzGenpY:
        def __get__(self):
            self.m1ErsatzGenpY_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzGenpY_value

    property m1ErsatzVispX:
        def __get__(self):
            self.m1ErsatzVispX_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzVispX_value

    property m1ErsatzVispY:
        def __get__(self):
            self.m1ErsatzVispY_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzVispY_value

    property m1Eta:
        def __get__(self):
            self.m1Eta_branch.GetEntry(self.localentry, 0)
            return self.m1Eta_value

    property m1Eta_MuonEnDown:
        def __get__(self):
            self.m1Eta_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1Eta_MuonEnDown_value

    property m1Eta_MuonEnUp:
        def __get__(self):
            self.m1Eta_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1Eta_MuonEnUp_value

    property m1GenCharge:
        def __get__(self):
            self.m1GenCharge_branch.GetEntry(self.localentry, 0)
            return self.m1GenCharge_value

    property m1GenDirectPromptTauDecayFinalState:
        def __get__(self):
            self.m1GenDirectPromptTauDecayFinalState_branch.GetEntry(self.localentry, 0)
            return self.m1GenDirectPromptTauDecayFinalState_value

    property m1GenEnergy:
        def __get__(self):
            self.m1GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.m1GenEnergy_value

    property m1GenEta:
        def __get__(self):
            self.m1GenEta_branch.GetEntry(self.localentry, 0)
            return self.m1GenEta_value

    property m1GenIsPrompt:
        def __get__(self):
            self.m1GenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.m1GenIsPrompt_value

    property m1GenMotherPdgId:
        def __get__(self):
            self.m1GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.m1GenMotherPdgId_value

    property m1GenParticle:
        def __get__(self):
            self.m1GenParticle_branch.GetEntry(self.localentry, 0)
            return self.m1GenParticle_value

    property m1GenPdgId:
        def __get__(self):
            self.m1GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.m1GenPdgId_value

    property m1GenPhi:
        def __get__(self):
            self.m1GenPhi_branch.GetEntry(self.localentry, 0)
            return self.m1GenPhi_value

    property m1GenPrompt:
        def __get__(self):
            self.m1GenPrompt_branch.GetEntry(self.localentry, 0)
            return self.m1GenPrompt_value

    property m1GenPromptFinalState:
        def __get__(self):
            self.m1GenPromptFinalState_branch.GetEntry(self.localentry, 0)
            return self.m1GenPromptFinalState_value

    property m1GenPromptTauDecay:
        def __get__(self):
            self.m1GenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.m1GenPromptTauDecay_value

    property m1GenPt:
        def __get__(self):
            self.m1GenPt_branch.GetEntry(self.localentry, 0)
            return self.m1GenPt_value

    property m1GenTauDecay:
        def __get__(self):
            self.m1GenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.m1GenTauDecay_value

    property m1GenVZ:
        def __get__(self):
            self.m1GenVZ_branch.GetEntry(self.localentry, 0)
            return self.m1GenVZ_value

    property m1GenVtxPVMatch:
        def __get__(self):
            self.m1GenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.m1GenVtxPVMatch_value

    property m1HcalIsoDR03:
        def __get__(self):
            self.m1HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m1HcalIsoDR03_value

    property m1IP3D:
        def __get__(self):
            self.m1IP3D_branch.GetEntry(self.localentry, 0)
            return self.m1IP3D_value

    property m1IP3DErr:
        def __get__(self):
            self.m1IP3DErr_branch.GetEntry(self.localentry, 0)
            return self.m1IP3DErr_value

    property m1IsGlobal:
        def __get__(self):
            self.m1IsGlobal_branch.GetEntry(self.localentry, 0)
            return self.m1IsGlobal_value

    property m1IsPFMuon:
        def __get__(self):
            self.m1IsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.m1IsPFMuon_value

    property m1IsTracker:
        def __get__(self):
            self.m1IsTracker_branch.GetEntry(self.localentry, 0)
            return self.m1IsTracker_value

    property m1IsoDB03:
        def __get__(self):
            self.m1IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.m1IsoDB03_value

    property m1IsoDB04:
        def __get__(self):
            self.m1IsoDB04_branch.GetEntry(self.localentry, 0)
            return self.m1IsoDB04_value

    property m1IsoMu22Filter:
        def __get__(self):
            self.m1IsoMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m1IsoMu22Filter_value

    property m1IsoMu22eta2p1Filter:
        def __get__(self):
            self.m1IsoMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1IsoMu22eta2p1Filter_value

    property m1IsoMu24Filter:
        def __get__(self):
            self.m1IsoMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m1IsoMu24Filter_value

    property m1IsoMu24eta2p1Filter:
        def __get__(self):
            self.m1IsoMu24eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1IsoMu24eta2p1Filter_value

    property m1IsoTkMu22Filter:
        def __get__(self):
            self.m1IsoTkMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m1IsoTkMu22Filter_value

    property m1IsoTkMu22eta2p1Filter:
        def __get__(self):
            self.m1IsoTkMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1IsoTkMu22eta2p1Filter_value

    property m1IsoTkMu24Filter:
        def __get__(self):
            self.m1IsoTkMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m1IsoTkMu24Filter_value

    property m1IsoTkMu24eta2p1Filter:
        def __get__(self):
            self.m1IsoTkMu24eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1IsoTkMu24eta2p1Filter_value

    property m1JetArea:
        def __get__(self):
            self.m1JetArea_branch.GetEntry(self.localentry, 0)
            return self.m1JetArea_value

    property m1JetBtag:
        def __get__(self):
            self.m1JetBtag_branch.GetEntry(self.localentry, 0)
            return self.m1JetBtag_value

    property m1JetEtaEtaMoment:
        def __get__(self):
            self.m1JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.m1JetEtaEtaMoment_value

    property m1JetEtaPhiMoment:
        def __get__(self):
            self.m1JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m1JetEtaPhiMoment_value

    property m1JetEtaPhiSpread:
        def __get__(self):
            self.m1JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.m1JetEtaPhiSpread_value

    property m1JetHadronFlavour:
        def __get__(self):
            self.m1JetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.m1JetHadronFlavour_value

    property m1JetPFCISVBtag:
        def __get__(self):
            self.m1JetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.m1JetPFCISVBtag_value

    property m1JetPartonFlavour:
        def __get__(self):
            self.m1JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.m1JetPartonFlavour_value

    property m1JetPhiPhiMoment:
        def __get__(self):
            self.m1JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m1JetPhiPhiMoment_value

    property m1JetPt:
        def __get__(self):
            self.m1JetPt_branch.GetEntry(self.localentry, 0)
            return self.m1JetPt_value

    property m1LowestMll:
        def __get__(self):
            self.m1LowestMll_branch.GetEntry(self.localentry, 0)
            return self.m1LowestMll_value

    property m1Mass:
        def __get__(self):
            self.m1Mass_branch.GetEntry(self.localentry, 0)
            return self.m1Mass_value

    property m1MatchedStations:
        def __get__(self):
            self.m1MatchedStations_branch.GetEntry(self.localentry, 0)
            return self.m1MatchedStations_value

    property m1MatchesDoubleESingleMu:
        def __get__(self):
            self.m1MatchesDoubleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesDoubleESingleMu_value

    property m1MatchesDoubleMu:
        def __get__(self):
            self.m1MatchesDoubleMu_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesDoubleMu_value

    property m1MatchesDoubleMuSingleE:
        def __get__(self):
            self.m1MatchesDoubleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesDoubleMuSingleE_value

    property m1MatchesIsoMu22Path:
        def __get__(self):
            self.m1MatchesIsoMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu22Path_value

    property m1MatchesIsoMu22eta2p1Path:
        def __get__(self):
            self.m1MatchesIsoMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu22eta2p1Path_value

    property m1MatchesIsoMu24Path:
        def __get__(self):
            self.m1MatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu24Path_value

    property m1MatchesIsoMu24eta2p1Path:
        def __get__(self):
            self.m1MatchesIsoMu24eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu24eta2p1Path_value

    property m1MatchesIsoTkMu22Path:
        def __get__(self):
            self.m1MatchesIsoTkMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu22Path_value

    property m1MatchesIsoTkMu22eta2p1Path:
        def __get__(self):
            self.m1MatchesIsoTkMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu22eta2p1Path_value

    property m1MatchesIsoTkMu24Path:
        def __get__(self):
            self.m1MatchesIsoTkMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu24Path_value

    property m1MatchesIsoTkMu24eta2p1Path:
        def __get__(self):
            self.m1MatchesIsoTkMu24eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu24eta2p1Path_value

    property m1MatchesMu19Tau20Filter:
        def __get__(self):
            self.m1MatchesMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu19Tau20Filter_value

    property m1MatchesMu19Tau20Path:
        def __get__(self):
            self.m1MatchesMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu19Tau20Path_value

    property m1MatchesMu19Tau20sL1Filter:
        def __get__(self):
            self.m1MatchesMu19Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu19Tau20sL1Filter_value

    property m1MatchesMu19Tau20sL1Path:
        def __get__(self):
            self.m1MatchesMu19Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu19Tau20sL1Path_value

    property m1MatchesMu21Tau20sL1Filter:
        def __get__(self):
            self.m1MatchesMu21Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu21Tau20sL1Filter_value

    property m1MatchesMu21Tau20sL1Path:
        def __get__(self):
            self.m1MatchesMu21Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu21Tau20sL1Path_value

    property m1MatchesMu23Ele12DZPath:
        def __get__(self):
            self.m1MatchesMu23Ele12DZPath_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu23Ele12DZPath_value

    property m1MatchesMu23Ele12Path:
        def __get__(self):
            self.m1MatchesMu23Ele12Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu23Ele12Path_value

    property m1MatchesMu8Ele23DZPath:
        def __get__(self):
            self.m1MatchesMu8Ele23DZPath_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu8Ele23DZPath_value

    property m1MatchesMu8Ele23Path:
        def __get__(self):
            self.m1MatchesMu8Ele23Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu8Ele23Path_value

    property m1MatchesSingleESingleMu:
        def __get__(self):
            self.m1MatchesSingleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleESingleMu_value

    property m1MatchesSingleMu:
        def __get__(self):
            self.m1MatchesSingleMu_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMu_value

    property m1MatchesSingleMuIso20:
        def __get__(self):
            self.m1MatchesSingleMuIso20_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMuIso20_value

    property m1MatchesSingleMuIsoTk20:
        def __get__(self):
            self.m1MatchesSingleMuIsoTk20_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMuIsoTk20_value

    property m1MatchesSingleMuSingleE:
        def __get__(self):
            self.m1MatchesSingleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMuSingleE_value

    property m1MatchesSingleMu_leg1:
        def __get__(self):
            self.m1MatchesSingleMu_leg1_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMu_leg1_value

    property m1MatchesSingleMu_leg1_noiso:
        def __get__(self):
            self.m1MatchesSingleMu_leg1_noiso_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMu_leg1_noiso_value

    property m1MatchesSingleMu_leg2:
        def __get__(self):
            self.m1MatchesSingleMu_leg2_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMu_leg2_value

    property m1MatchesSingleMu_leg2_noiso:
        def __get__(self):
            self.m1MatchesSingleMu_leg2_noiso_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMu_leg2_noiso_value

    property m1MatchesTripleMu:
        def __get__(self):
            self.m1MatchesTripleMu_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesTripleMu_value

    property m1MtToPfMet_type1:
        def __get__(self):
            self.m1MtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_type1_value

    property m1Mu23Ele12DZFilter:
        def __get__(self):
            self.m1Mu23Ele12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.m1Mu23Ele12DZFilter_value

    property m1Mu23Ele12Filter:
        def __get__(self):
            self.m1Mu23Ele12Filter_branch.GetEntry(self.localentry, 0)
            return self.m1Mu23Ele12Filter_value

    property m1Mu8Ele23DZFilter:
        def __get__(self):
            self.m1Mu8Ele23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.m1Mu8Ele23DZFilter_value

    property m1Mu8Ele23Filter:
        def __get__(self):
            self.m1Mu8Ele23Filter_branch.GetEntry(self.localentry, 0)
            return self.m1Mu8Ele23Filter_value

    property m1MuonHits:
        def __get__(self):
            self.m1MuonHits_branch.GetEntry(self.localentry, 0)
            return self.m1MuonHits_value

    property m1NearestZMass:
        def __get__(self):
            self.m1NearestZMass_branch.GetEntry(self.localentry, 0)
            return self.m1NearestZMass_value

    property m1NormTrkChi2:
        def __get__(self):
            self.m1NormTrkChi2_branch.GetEntry(self.localentry, 0)
            return self.m1NormTrkChi2_value

    property m1NormalizedChi2:
        def __get__(self):
            self.m1NormalizedChi2_branch.GetEntry(self.localentry, 0)
            return self.m1NormalizedChi2_value

    property m1PFChargedHadronIsoR04:
        def __get__(self):
            self.m1PFChargedHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m1PFChargedHadronIsoR04_value

    property m1PFChargedIso:
        def __get__(self):
            self.m1PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFChargedIso_value

    property m1PFIDLoose:
        def __get__(self):
            self.m1PFIDLoose_branch.GetEntry(self.localentry, 0)
            return self.m1PFIDLoose_value

    property m1PFIDMedium:
        def __get__(self):
            self.m1PFIDMedium_branch.GetEntry(self.localentry, 0)
            return self.m1PFIDMedium_value

    property m1PFIDTight:
        def __get__(self):
            self.m1PFIDTight_branch.GetEntry(self.localentry, 0)
            return self.m1PFIDTight_value

    property m1PFNeutralHadronIsoR04:
        def __get__(self):
            self.m1PFNeutralHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m1PFNeutralHadronIsoR04_value

    property m1PFNeutralIso:
        def __get__(self):
            self.m1PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFNeutralIso_value

    property m1PFPUChargedIso:
        def __get__(self):
            self.m1PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFPUChargedIso_value

    property m1PFPhotonIso:
        def __get__(self):
            self.m1PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFPhotonIso_value

    property m1PFPhotonIsoR04:
        def __get__(self):
            self.m1PFPhotonIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m1PFPhotonIsoR04_value

    property m1PFPileupIsoR04:
        def __get__(self):
            self.m1PFPileupIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m1PFPileupIsoR04_value

    property m1PVDXY:
        def __get__(self):
            self.m1PVDXY_branch.GetEntry(self.localentry, 0)
            return self.m1PVDXY_value

    property m1PVDZ:
        def __get__(self):
            self.m1PVDZ_branch.GetEntry(self.localentry, 0)
            return self.m1PVDZ_value

    property m1Phi:
        def __get__(self):
            self.m1Phi_branch.GetEntry(self.localentry, 0)
            return self.m1Phi_value

    property m1Phi_MuonEnDown:
        def __get__(self):
            self.m1Phi_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1Phi_MuonEnDown_value

    property m1Phi_MuonEnUp:
        def __get__(self):
            self.m1Phi_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1Phi_MuonEnUp_value

    property m1PixHits:
        def __get__(self):
            self.m1PixHits_branch.GetEntry(self.localentry, 0)
            return self.m1PixHits_value

    property m1Pt:
        def __get__(self):
            self.m1Pt_branch.GetEntry(self.localentry, 0)
            return self.m1Pt_value

    property m1Pt_MuonEnDown:
        def __get__(self):
            self.m1Pt_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1Pt_MuonEnDown_value

    property m1Pt_MuonEnUp:
        def __get__(self):
            self.m1Pt_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1Pt_MuonEnUp_value

    property m1Rank:
        def __get__(self):
            self.m1Rank_branch.GetEntry(self.localentry, 0)
            return self.m1Rank_value

    property m1RelPFIsoDBDefault:
        def __get__(self):
            self.m1RelPFIsoDBDefault_branch.GetEntry(self.localentry, 0)
            return self.m1RelPFIsoDBDefault_value

    property m1RelPFIsoDBDefaultR04:
        def __get__(self):
            self.m1RelPFIsoDBDefaultR04_branch.GetEntry(self.localentry, 0)
            return self.m1RelPFIsoDBDefaultR04_value

    property m1RelPFIsoRho:
        def __get__(self):
            self.m1RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.m1RelPFIsoRho_value

    property m1Rho:
        def __get__(self):
            self.m1Rho_branch.GetEntry(self.localentry, 0)
            return self.m1Rho_value

    property m1SIP2D:
        def __get__(self):
            self.m1SIP2D_branch.GetEntry(self.localentry, 0)
            return self.m1SIP2D_value

    property m1SIP3D:
        def __get__(self):
            self.m1SIP3D_branch.GetEntry(self.localentry, 0)
            return self.m1SIP3D_value

    property m1SegmentCompatibility:
        def __get__(self):
            self.m1SegmentCompatibility_branch.GetEntry(self.localentry, 0)
            return self.m1SegmentCompatibility_value

    property m1TkLayersWithMeasurement:
        def __get__(self):
            self.m1TkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.m1TkLayersWithMeasurement_value

    property m1TrkIsoDR03:
        def __get__(self):
            self.m1TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m1TrkIsoDR03_value

    property m1TrkKink:
        def __get__(self):
            self.m1TrkKink_branch.GetEntry(self.localentry, 0)
            return self.m1TrkKink_value

    property m1TypeCode:
        def __get__(self):
            self.m1TypeCode_branch.GetEntry(self.localentry, 0)
            return self.m1TypeCode_value

    property m1VZ:
        def __get__(self):
            self.m1VZ_branch.GetEntry(self.localentry, 0)
            return self.m1VZ_value

    property m1ValidFraction:
        def __get__(self):
            self.m1ValidFraction_branch.GetEntry(self.localentry, 0)
            return self.m1ValidFraction_value

    property m1ZTTGenMatching:
        def __get__(self):
            self.m1ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.m1ZTTGenMatching_value

    property m1_e_collinearmass:
        def __get__(self):
            self.m1_e_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.m1_e_collinearmass_value

    property m1_e_collinearmass_CheckUESDown:
        def __get__(self):
            self.m1_e_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.m1_e_collinearmass_CheckUESDown_value

    property m1_e_collinearmass_CheckUESUp:
        def __get__(self):
            self.m1_e_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.m1_e_collinearmass_CheckUESUp_value

    property m1_e_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.m1_e_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.m1_e_collinearmass_JetCheckTotalDown_value

    property m1_e_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.m1_e_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.m1_e_collinearmass_JetCheckTotalUp_value

    property m1_e_collinearmass_JetEnDown:
        def __get__(self):
            self.m1_e_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_e_collinearmass_JetEnDown_value

    property m1_e_collinearmass_JetEnUp:
        def __get__(self):
            self.m1_e_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_e_collinearmass_JetEnUp_value

    property m1_e_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.m1_e_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_e_collinearmass_UnclusteredEnDown_value

    property m1_e_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.m1_e_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_e_collinearmass_UnclusteredEnUp_value

    property m1_m2_CosThetaStar:
        def __get__(self):
            self.m1_m2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_CosThetaStar_value

    property m1_m2_DPhi:
        def __get__(self):
            self.m1_m2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_DPhi_value

    property m1_m2_DR:
        def __get__(self):
            self.m1_m2_DR_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_DR_value

    property m1_m2_Eta:
        def __get__(self):
            self.m1_m2_Eta_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Eta_value

    property m1_m2_Mass:
        def __get__(self):
            self.m1_m2_Mass_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mass_value

    property m1_m2_Mass_TauEnDown:
        def __get__(self):
            self.m1_m2_Mass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mass_TauEnDown_value

    property m1_m2_Mass_TauEnUp:
        def __get__(self):
            self.m1_m2_Mass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mass_TauEnUp_value

    property m1_m2_Mt:
        def __get__(self):
            self.m1_m2_Mt_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mt_value

    property m1_m2_MtTotal:
        def __get__(self):
            self.m1_m2_MtTotal_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MtTotal_value

    property m1_m2_Mt_TauEnDown:
        def __get__(self):
            self.m1_m2_Mt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mt_TauEnDown_value

    property m1_m2_Mt_TauEnUp:
        def __get__(self):
            self.m1_m2_Mt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mt_TauEnUp_value

    property m1_m2_MvaMet:
        def __get__(self):
            self.m1_m2_MvaMet_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MvaMet_value

    property m1_m2_MvaMetCovMatrix00:
        def __get__(self):
            self.m1_m2_MvaMetCovMatrix00_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MvaMetCovMatrix00_value

    property m1_m2_MvaMetCovMatrix01:
        def __get__(self):
            self.m1_m2_MvaMetCovMatrix01_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MvaMetCovMatrix01_value

    property m1_m2_MvaMetCovMatrix10:
        def __get__(self):
            self.m1_m2_MvaMetCovMatrix10_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MvaMetCovMatrix10_value

    property m1_m2_MvaMetCovMatrix11:
        def __get__(self):
            self.m1_m2_MvaMetCovMatrix11_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MvaMetCovMatrix11_value

    property m1_m2_MvaMetPhi:
        def __get__(self):
            self.m1_m2_MvaMetPhi_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MvaMetPhi_value

    property m1_m2_PZeta:
        def __get__(self):
            self.m1_m2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PZeta_value

    property m1_m2_PZetaLess0p85PZetaVis:
        def __get__(self):
            self.m1_m2_PZetaLess0p85PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PZetaLess0p85PZetaVis_value

    property m1_m2_PZetaVis:
        def __get__(self):
            self.m1_m2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PZetaVis_value

    property m1_m2_Phi:
        def __get__(self):
            self.m1_m2_Phi_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Phi_value

    property m1_m2_Pt:
        def __get__(self):
            self.m1_m2_Pt_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Pt_value

    property m1_m2_SS:
        def __get__(self):
            self.m1_m2_SS_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_SS_value

    property m1_m2_ToMETDPhi_Ty1:
        def __get__(self):
            self.m1_m2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_ToMETDPhi_Ty1_value

    property m1_m2_collinearmass:
        def __get__(self):
            self.m1_m2_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_value

    property m1_m2_collinearmass_CheckUESDown:
        def __get__(self):
            self.m1_m2_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_CheckUESDown_value

    property m1_m2_collinearmass_CheckUESUp:
        def __get__(self):
            self.m1_m2_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_CheckUESUp_value

    property m1_m2_collinearmass_EleEnDown:
        def __get__(self):
            self.m1_m2_collinearmass_EleEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_EleEnDown_value

    property m1_m2_collinearmass_EleEnUp:
        def __get__(self):
            self.m1_m2_collinearmass_EleEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_EleEnUp_value

    property m1_m2_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.m1_m2_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_JetCheckTotalDown_value

    property m1_m2_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.m1_m2_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_JetCheckTotalUp_value

    property m1_m2_collinearmass_JetEnDown:
        def __get__(self):
            self.m1_m2_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_JetEnDown_value

    property m1_m2_collinearmass_JetEnUp:
        def __get__(self):
            self.m1_m2_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_JetEnUp_value

    property m1_m2_collinearmass_MuEnDown:
        def __get__(self):
            self.m1_m2_collinearmass_MuEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_MuEnDown_value

    property m1_m2_collinearmass_MuEnUp:
        def __get__(self):
            self.m1_m2_collinearmass_MuEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_MuEnUp_value

    property m1_m2_collinearmass_TauEnDown:
        def __get__(self):
            self.m1_m2_collinearmass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_TauEnDown_value

    property m1_m2_collinearmass_TauEnUp:
        def __get__(self):
            self.m1_m2_collinearmass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_TauEnUp_value

    property m1_m2_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.m1_m2_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_UnclusteredEnDown_value

    property m1_m2_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.m1_m2_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_UnclusteredEnUp_value

    property m1_m2_pt_tt:
        def __get__(self):
            self.m1_m2_pt_tt_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_pt_tt_value

    property m2AbsEta:
        def __get__(self):
            self.m2AbsEta_branch.GetEntry(self.localentry, 0)
            return self.m2AbsEta_value

    property m2BestTrackType:
        def __get__(self):
            self.m2BestTrackType_branch.GetEntry(self.localentry, 0)
            return self.m2BestTrackType_value

    property m2Charge:
        def __get__(self):
            self.m2Charge_branch.GetEntry(self.localentry, 0)
            return self.m2Charge_value

    property m2Chi2LocalPosition:
        def __get__(self):
            self.m2Chi2LocalPosition_branch.GetEntry(self.localentry, 0)
            return self.m2Chi2LocalPosition_value

    property m2ComesFromHiggs:
        def __get__(self):
            self.m2ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.m2ComesFromHiggs_value

    property m2DPhiToPfMet_type1:
        def __get__(self):
            self.m2DPhiToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_type1_value

    property m2EcalIsoDR03:
        def __get__(self):
            self.m2EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m2EcalIsoDR03_value

    property m2EffectiveArea2011:
        def __get__(self):
            self.m2EffectiveArea2011_branch.GetEntry(self.localentry, 0)
            return self.m2EffectiveArea2011_value

    property m2EffectiveArea2012:
        def __get__(self):
            self.m2EffectiveArea2012_branch.GetEntry(self.localentry, 0)
            return self.m2EffectiveArea2012_value

    property m2ErsatzGenEta:
        def __get__(self):
            self.m2ErsatzGenEta_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzGenEta_value

    property m2ErsatzGenM:
        def __get__(self):
            self.m2ErsatzGenM_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzGenM_value

    property m2ErsatzGenPhi:
        def __get__(self):
            self.m2ErsatzGenPhi_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzGenPhi_value

    property m2ErsatzGenpT:
        def __get__(self):
            self.m2ErsatzGenpT_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzGenpT_value

    property m2ErsatzGenpX:
        def __get__(self):
            self.m2ErsatzGenpX_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzGenpX_value

    property m2ErsatzGenpY:
        def __get__(self):
            self.m2ErsatzGenpY_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzGenpY_value

    property m2ErsatzVispX:
        def __get__(self):
            self.m2ErsatzVispX_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzVispX_value

    property m2ErsatzVispY:
        def __get__(self):
            self.m2ErsatzVispY_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzVispY_value

    property m2Eta:
        def __get__(self):
            self.m2Eta_branch.GetEntry(self.localentry, 0)
            return self.m2Eta_value

    property m2Eta_MuonEnDown:
        def __get__(self):
            self.m2Eta_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2Eta_MuonEnDown_value

    property m2Eta_MuonEnUp:
        def __get__(self):
            self.m2Eta_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2Eta_MuonEnUp_value

    property m2GenCharge:
        def __get__(self):
            self.m2GenCharge_branch.GetEntry(self.localentry, 0)
            return self.m2GenCharge_value

    property m2GenDirectPromptTauDecayFinalState:
        def __get__(self):
            self.m2GenDirectPromptTauDecayFinalState_branch.GetEntry(self.localentry, 0)
            return self.m2GenDirectPromptTauDecayFinalState_value

    property m2GenEnergy:
        def __get__(self):
            self.m2GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.m2GenEnergy_value

    property m2GenEta:
        def __get__(self):
            self.m2GenEta_branch.GetEntry(self.localentry, 0)
            return self.m2GenEta_value

    property m2GenIsPrompt:
        def __get__(self):
            self.m2GenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.m2GenIsPrompt_value

    property m2GenMotherPdgId:
        def __get__(self):
            self.m2GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.m2GenMotherPdgId_value

    property m2GenParticle:
        def __get__(self):
            self.m2GenParticle_branch.GetEntry(self.localentry, 0)
            return self.m2GenParticle_value

    property m2GenPdgId:
        def __get__(self):
            self.m2GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.m2GenPdgId_value

    property m2GenPhi:
        def __get__(self):
            self.m2GenPhi_branch.GetEntry(self.localentry, 0)
            return self.m2GenPhi_value

    property m2GenPrompt:
        def __get__(self):
            self.m2GenPrompt_branch.GetEntry(self.localentry, 0)
            return self.m2GenPrompt_value

    property m2GenPromptFinalState:
        def __get__(self):
            self.m2GenPromptFinalState_branch.GetEntry(self.localentry, 0)
            return self.m2GenPromptFinalState_value

    property m2GenPromptTauDecay:
        def __get__(self):
            self.m2GenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.m2GenPromptTauDecay_value

    property m2GenPt:
        def __get__(self):
            self.m2GenPt_branch.GetEntry(self.localentry, 0)
            return self.m2GenPt_value

    property m2GenTauDecay:
        def __get__(self):
            self.m2GenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.m2GenTauDecay_value

    property m2GenVZ:
        def __get__(self):
            self.m2GenVZ_branch.GetEntry(self.localentry, 0)
            return self.m2GenVZ_value

    property m2GenVtxPVMatch:
        def __get__(self):
            self.m2GenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.m2GenVtxPVMatch_value

    property m2HcalIsoDR03:
        def __get__(self):
            self.m2HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m2HcalIsoDR03_value

    property m2IP3D:
        def __get__(self):
            self.m2IP3D_branch.GetEntry(self.localentry, 0)
            return self.m2IP3D_value

    property m2IP3DErr:
        def __get__(self):
            self.m2IP3DErr_branch.GetEntry(self.localentry, 0)
            return self.m2IP3DErr_value

    property m2IsGlobal:
        def __get__(self):
            self.m2IsGlobal_branch.GetEntry(self.localentry, 0)
            return self.m2IsGlobal_value

    property m2IsPFMuon:
        def __get__(self):
            self.m2IsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.m2IsPFMuon_value

    property m2IsTracker:
        def __get__(self):
            self.m2IsTracker_branch.GetEntry(self.localentry, 0)
            return self.m2IsTracker_value

    property m2IsoDB03:
        def __get__(self):
            self.m2IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.m2IsoDB03_value

    property m2IsoDB04:
        def __get__(self):
            self.m2IsoDB04_branch.GetEntry(self.localentry, 0)
            return self.m2IsoDB04_value

    property m2IsoMu22Filter:
        def __get__(self):
            self.m2IsoMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m2IsoMu22Filter_value

    property m2IsoMu22eta2p1Filter:
        def __get__(self):
            self.m2IsoMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2IsoMu22eta2p1Filter_value

    property m2IsoMu24Filter:
        def __get__(self):
            self.m2IsoMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m2IsoMu24Filter_value

    property m2IsoMu24eta2p1Filter:
        def __get__(self):
            self.m2IsoMu24eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2IsoMu24eta2p1Filter_value

    property m2IsoTkMu22Filter:
        def __get__(self):
            self.m2IsoTkMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m2IsoTkMu22Filter_value

    property m2IsoTkMu22eta2p1Filter:
        def __get__(self):
            self.m2IsoTkMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2IsoTkMu22eta2p1Filter_value

    property m2IsoTkMu24Filter:
        def __get__(self):
            self.m2IsoTkMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m2IsoTkMu24Filter_value

    property m2IsoTkMu24eta2p1Filter:
        def __get__(self):
            self.m2IsoTkMu24eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2IsoTkMu24eta2p1Filter_value

    property m2JetArea:
        def __get__(self):
            self.m2JetArea_branch.GetEntry(self.localentry, 0)
            return self.m2JetArea_value

    property m2JetBtag:
        def __get__(self):
            self.m2JetBtag_branch.GetEntry(self.localentry, 0)
            return self.m2JetBtag_value

    property m2JetEtaEtaMoment:
        def __get__(self):
            self.m2JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.m2JetEtaEtaMoment_value

    property m2JetEtaPhiMoment:
        def __get__(self):
            self.m2JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m2JetEtaPhiMoment_value

    property m2JetEtaPhiSpread:
        def __get__(self):
            self.m2JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.m2JetEtaPhiSpread_value

    property m2JetHadronFlavour:
        def __get__(self):
            self.m2JetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.m2JetHadronFlavour_value

    property m2JetPFCISVBtag:
        def __get__(self):
            self.m2JetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.m2JetPFCISVBtag_value

    property m2JetPartonFlavour:
        def __get__(self):
            self.m2JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.m2JetPartonFlavour_value

    property m2JetPhiPhiMoment:
        def __get__(self):
            self.m2JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m2JetPhiPhiMoment_value

    property m2JetPt:
        def __get__(self):
            self.m2JetPt_branch.GetEntry(self.localentry, 0)
            return self.m2JetPt_value

    property m2LowestMll:
        def __get__(self):
            self.m2LowestMll_branch.GetEntry(self.localentry, 0)
            return self.m2LowestMll_value

    property m2Mass:
        def __get__(self):
            self.m2Mass_branch.GetEntry(self.localentry, 0)
            return self.m2Mass_value

    property m2MatchedStations:
        def __get__(self):
            self.m2MatchedStations_branch.GetEntry(self.localentry, 0)
            return self.m2MatchedStations_value

    property m2MatchesDoubleESingleMu:
        def __get__(self):
            self.m2MatchesDoubleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesDoubleESingleMu_value

    property m2MatchesDoubleMu:
        def __get__(self):
            self.m2MatchesDoubleMu_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesDoubleMu_value

    property m2MatchesDoubleMuSingleE:
        def __get__(self):
            self.m2MatchesDoubleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesDoubleMuSingleE_value

    property m2MatchesIsoMu22Path:
        def __get__(self):
            self.m2MatchesIsoMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu22Path_value

    property m2MatchesIsoMu22eta2p1Path:
        def __get__(self):
            self.m2MatchesIsoMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu22eta2p1Path_value

    property m2MatchesIsoMu24Path:
        def __get__(self):
            self.m2MatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu24Path_value

    property m2MatchesIsoMu24eta2p1Path:
        def __get__(self):
            self.m2MatchesIsoMu24eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu24eta2p1Path_value

    property m2MatchesIsoTkMu22Path:
        def __get__(self):
            self.m2MatchesIsoTkMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu22Path_value

    property m2MatchesIsoTkMu22eta2p1Path:
        def __get__(self):
            self.m2MatchesIsoTkMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu22eta2p1Path_value

    property m2MatchesIsoTkMu24Path:
        def __get__(self):
            self.m2MatchesIsoTkMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu24Path_value

    property m2MatchesIsoTkMu24eta2p1Path:
        def __get__(self):
            self.m2MatchesIsoTkMu24eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu24eta2p1Path_value

    property m2MatchesMu19Tau20Filter:
        def __get__(self):
            self.m2MatchesMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu19Tau20Filter_value

    property m2MatchesMu19Tau20Path:
        def __get__(self):
            self.m2MatchesMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu19Tau20Path_value

    property m2MatchesMu19Tau20sL1Filter:
        def __get__(self):
            self.m2MatchesMu19Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu19Tau20sL1Filter_value

    property m2MatchesMu19Tau20sL1Path:
        def __get__(self):
            self.m2MatchesMu19Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu19Tau20sL1Path_value

    property m2MatchesMu21Tau20sL1Filter:
        def __get__(self):
            self.m2MatchesMu21Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu21Tau20sL1Filter_value

    property m2MatchesMu21Tau20sL1Path:
        def __get__(self):
            self.m2MatchesMu21Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu21Tau20sL1Path_value

    property m2MatchesMu23Ele12DZPath:
        def __get__(self):
            self.m2MatchesMu23Ele12DZPath_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu23Ele12DZPath_value

    property m2MatchesMu23Ele12Path:
        def __get__(self):
            self.m2MatchesMu23Ele12Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu23Ele12Path_value

    property m2MatchesMu8Ele23DZPath:
        def __get__(self):
            self.m2MatchesMu8Ele23DZPath_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu8Ele23DZPath_value

    property m2MatchesMu8Ele23Path:
        def __get__(self):
            self.m2MatchesMu8Ele23Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu8Ele23Path_value

    property m2MatchesSingleESingleMu:
        def __get__(self):
            self.m2MatchesSingleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleESingleMu_value

    property m2MatchesSingleMu:
        def __get__(self):
            self.m2MatchesSingleMu_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMu_value

    property m2MatchesSingleMuIso20:
        def __get__(self):
            self.m2MatchesSingleMuIso20_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMuIso20_value

    property m2MatchesSingleMuIsoTk20:
        def __get__(self):
            self.m2MatchesSingleMuIsoTk20_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMuIsoTk20_value

    property m2MatchesSingleMuSingleE:
        def __get__(self):
            self.m2MatchesSingleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMuSingleE_value

    property m2MatchesSingleMu_leg1:
        def __get__(self):
            self.m2MatchesSingleMu_leg1_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMu_leg1_value

    property m2MatchesSingleMu_leg1_noiso:
        def __get__(self):
            self.m2MatchesSingleMu_leg1_noiso_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMu_leg1_noiso_value

    property m2MatchesSingleMu_leg2:
        def __get__(self):
            self.m2MatchesSingleMu_leg2_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMu_leg2_value

    property m2MatchesSingleMu_leg2_noiso:
        def __get__(self):
            self.m2MatchesSingleMu_leg2_noiso_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMu_leg2_noiso_value

    property m2MatchesTripleMu:
        def __get__(self):
            self.m2MatchesTripleMu_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesTripleMu_value

    property m2MtToPfMet_type1:
        def __get__(self):
            self.m2MtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_type1_value

    property m2Mu23Ele12DZFilter:
        def __get__(self):
            self.m2Mu23Ele12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.m2Mu23Ele12DZFilter_value

    property m2Mu23Ele12Filter:
        def __get__(self):
            self.m2Mu23Ele12Filter_branch.GetEntry(self.localentry, 0)
            return self.m2Mu23Ele12Filter_value

    property m2Mu8Ele23DZFilter:
        def __get__(self):
            self.m2Mu8Ele23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.m2Mu8Ele23DZFilter_value

    property m2Mu8Ele23Filter:
        def __get__(self):
            self.m2Mu8Ele23Filter_branch.GetEntry(self.localentry, 0)
            return self.m2Mu8Ele23Filter_value

    property m2MuonHits:
        def __get__(self):
            self.m2MuonHits_branch.GetEntry(self.localentry, 0)
            return self.m2MuonHits_value

    property m2NearestZMass:
        def __get__(self):
            self.m2NearestZMass_branch.GetEntry(self.localentry, 0)
            return self.m2NearestZMass_value

    property m2NormTrkChi2:
        def __get__(self):
            self.m2NormTrkChi2_branch.GetEntry(self.localentry, 0)
            return self.m2NormTrkChi2_value

    property m2NormalizedChi2:
        def __get__(self):
            self.m2NormalizedChi2_branch.GetEntry(self.localentry, 0)
            return self.m2NormalizedChi2_value

    property m2PFChargedHadronIsoR04:
        def __get__(self):
            self.m2PFChargedHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m2PFChargedHadronIsoR04_value

    property m2PFChargedIso:
        def __get__(self):
            self.m2PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFChargedIso_value

    property m2PFIDLoose:
        def __get__(self):
            self.m2PFIDLoose_branch.GetEntry(self.localentry, 0)
            return self.m2PFIDLoose_value

    property m2PFIDMedium:
        def __get__(self):
            self.m2PFIDMedium_branch.GetEntry(self.localentry, 0)
            return self.m2PFIDMedium_value

    property m2PFIDTight:
        def __get__(self):
            self.m2PFIDTight_branch.GetEntry(self.localentry, 0)
            return self.m2PFIDTight_value

    property m2PFNeutralHadronIsoR04:
        def __get__(self):
            self.m2PFNeutralHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m2PFNeutralHadronIsoR04_value

    property m2PFNeutralIso:
        def __get__(self):
            self.m2PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFNeutralIso_value

    property m2PFPUChargedIso:
        def __get__(self):
            self.m2PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFPUChargedIso_value

    property m2PFPhotonIso:
        def __get__(self):
            self.m2PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFPhotonIso_value

    property m2PFPhotonIsoR04:
        def __get__(self):
            self.m2PFPhotonIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m2PFPhotonIsoR04_value

    property m2PFPileupIsoR04:
        def __get__(self):
            self.m2PFPileupIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m2PFPileupIsoR04_value

    property m2PVDXY:
        def __get__(self):
            self.m2PVDXY_branch.GetEntry(self.localentry, 0)
            return self.m2PVDXY_value

    property m2PVDZ:
        def __get__(self):
            self.m2PVDZ_branch.GetEntry(self.localentry, 0)
            return self.m2PVDZ_value

    property m2Phi:
        def __get__(self):
            self.m2Phi_branch.GetEntry(self.localentry, 0)
            return self.m2Phi_value

    property m2Phi_MuonEnDown:
        def __get__(self):
            self.m2Phi_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2Phi_MuonEnDown_value

    property m2Phi_MuonEnUp:
        def __get__(self):
            self.m2Phi_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2Phi_MuonEnUp_value

    property m2PixHits:
        def __get__(self):
            self.m2PixHits_branch.GetEntry(self.localentry, 0)
            return self.m2PixHits_value

    property m2Pt:
        def __get__(self):
            self.m2Pt_branch.GetEntry(self.localentry, 0)
            return self.m2Pt_value

    property m2Pt_MuonEnDown:
        def __get__(self):
            self.m2Pt_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2Pt_MuonEnDown_value

    property m2Pt_MuonEnUp:
        def __get__(self):
            self.m2Pt_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2Pt_MuonEnUp_value

    property m2Rank:
        def __get__(self):
            self.m2Rank_branch.GetEntry(self.localentry, 0)
            return self.m2Rank_value

    property m2RelPFIsoDBDefault:
        def __get__(self):
            self.m2RelPFIsoDBDefault_branch.GetEntry(self.localentry, 0)
            return self.m2RelPFIsoDBDefault_value

    property m2RelPFIsoDBDefaultR04:
        def __get__(self):
            self.m2RelPFIsoDBDefaultR04_branch.GetEntry(self.localentry, 0)
            return self.m2RelPFIsoDBDefaultR04_value

    property m2RelPFIsoRho:
        def __get__(self):
            self.m2RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.m2RelPFIsoRho_value

    property m2Rho:
        def __get__(self):
            self.m2Rho_branch.GetEntry(self.localentry, 0)
            return self.m2Rho_value

    property m2SIP2D:
        def __get__(self):
            self.m2SIP2D_branch.GetEntry(self.localentry, 0)
            return self.m2SIP2D_value

    property m2SIP3D:
        def __get__(self):
            self.m2SIP3D_branch.GetEntry(self.localentry, 0)
            return self.m2SIP3D_value

    property m2SegmentCompatibility:
        def __get__(self):
            self.m2SegmentCompatibility_branch.GetEntry(self.localentry, 0)
            return self.m2SegmentCompatibility_value

    property m2TkLayersWithMeasurement:
        def __get__(self):
            self.m2TkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.m2TkLayersWithMeasurement_value

    property m2TrkIsoDR03:
        def __get__(self):
            self.m2TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m2TrkIsoDR03_value

    property m2TrkKink:
        def __get__(self):
            self.m2TrkKink_branch.GetEntry(self.localentry, 0)
            return self.m2TrkKink_value

    property m2TypeCode:
        def __get__(self):
            self.m2TypeCode_branch.GetEntry(self.localentry, 0)
            return self.m2TypeCode_value

    property m2VZ:
        def __get__(self):
            self.m2VZ_branch.GetEntry(self.localentry, 0)
            return self.m2VZ_value

    property m2ValidFraction:
        def __get__(self):
            self.m2ValidFraction_branch.GetEntry(self.localentry, 0)
            return self.m2ValidFraction_value

    property m2ZTTGenMatching:
        def __get__(self):
            self.m2ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.m2ZTTGenMatching_value

    property m2_e_collinearmass:
        def __get__(self):
            self.m2_e_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.m2_e_collinearmass_value

    property m2_e_collinearmass_CheckUESDown:
        def __get__(self):
            self.m2_e_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.m2_e_collinearmass_CheckUESDown_value

    property m2_e_collinearmass_CheckUESUp:
        def __get__(self):
            self.m2_e_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.m2_e_collinearmass_CheckUESUp_value

    property m2_e_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.m2_e_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.m2_e_collinearmass_JetCheckTotalDown_value

    property m2_e_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.m2_e_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.m2_e_collinearmass_JetCheckTotalUp_value

    property m2_e_collinearmass_JetEnDown:
        def __get__(self):
            self.m2_e_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_e_collinearmass_JetEnDown_value

    property m2_e_collinearmass_JetEnUp:
        def __get__(self):
            self.m2_e_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_e_collinearmass_JetEnUp_value

    property m2_e_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.m2_e_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_e_collinearmass_UnclusteredEnDown_value

    property m2_e_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.m2_e_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_e_collinearmass_UnclusteredEnUp_value

    property m2_m1_collinearmass:
        def __get__(self):
            self.m2_m1_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_value

    property m2_m1_collinearmass_CheckUESDown:
        def __get__(self):
            self.m2_m1_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_CheckUESDown_value

    property m2_m1_collinearmass_CheckUESUp:
        def __get__(self):
            self.m2_m1_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_CheckUESUp_value

    property m2_m1_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.m2_m1_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_JetCheckTotalDown_value

    property m2_m1_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.m2_m1_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_JetCheckTotalUp_value

    property m2_m1_collinearmass_JetEnDown:
        def __get__(self):
            self.m2_m1_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_JetEnDown_value

    property m2_m1_collinearmass_JetEnUp:
        def __get__(self):
            self.m2_m1_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_JetEnUp_value

    property m2_m1_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.m2_m1_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_UnclusteredEnDown_value

    property m2_m1_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.m2_m1_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_UnclusteredEnUp_value

    property metSig:
        def __get__(self):
            self.metSig_branch.GetEntry(self.localentry, 0)
            return self.metSig_value

    property metcov00:
        def __get__(self):
            self.metcov00_branch.GetEntry(self.localentry, 0)
            return self.metcov00_value

    property metcov00_DESYlike:
        def __get__(self):
            self.metcov00_DESYlike_branch.GetEntry(self.localentry, 0)
            return self.metcov00_DESYlike_value

    property metcov01:
        def __get__(self):
            self.metcov01_branch.GetEntry(self.localentry, 0)
            return self.metcov01_value

    property metcov01_DESYlike:
        def __get__(self):
            self.metcov01_DESYlike_branch.GetEntry(self.localentry, 0)
            return self.metcov01_DESYlike_value

    property metcov10:
        def __get__(self):
            self.metcov10_branch.GetEntry(self.localentry, 0)
            return self.metcov10_value

    property metcov10_DESYlike:
        def __get__(self):
            self.metcov10_DESYlike_branch.GetEntry(self.localentry, 0)
            return self.metcov10_DESYlike_value

    property metcov11:
        def __get__(self):
            self.metcov11_branch.GetEntry(self.localentry, 0)
            return self.metcov11_value

    property metcov11_DESYlike:
        def __get__(self):
            self.metcov11_DESYlike_branch.GetEntry(self.localentry, 0)
            return self.metcov11_DESYlike_value

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

    property muVetoZTTp001dxyz:
        def __get__(self):
            self.muVetoZTTp001dxyz_branch.GetEntry(self.localentry, 0)
            return self.muVetoZTTp001dxyz_value

    property muVetoZTTp001dxyzR0:
        def __get__(self):
            self.muVetoZTTp001dxyzR0_branch.GetEntry(self.localentry, 0)
            return self.muVetoZTTp001dxyzR0_value

    property nTruePU:
        def __get__(self):
            self.nTruePU_branch.GetEntry(self.localentry, 0)
            return self.nTruePU_value

    property numGenJets:
        def __get__(self):
            self.numGenJets_branch.GetEntry(self.localentry, 0)
            return self.numGenJets_value

    property nvtx:
        def __get__(self):
            self.nvtx_branch.GetEntry(self.localentry, 0)
            return self.nvtx_value

    property processID:
        def __get__(self):
            self.processID_branch.GetEntry(self.localentry, 0)
            return self.processID_value

    property puppiMetEt:
        def __get__(self):
            self.puppiMetEt_branch.GetEntry(self.localentry, 0)
            return self.puppiMetEt_value

    property puppiMetPhi:
        def __get__(self):
            self.puppiMetPhi_branch.GetEntry(self.localentry, 0)
            return self.puppiMetPhi_value

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

    property singleE20SingleTau28Group:
        def __get__(self):
            self.singleE20SingleTau28Group_branch.GetEntry(self.localentry, 0)
            return self.singleE20SingleTau28Group_value

    property singleE20SingleTau28Pass:
        def __get__(self):
            self.singleE20SingleTau28Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE20SingleTau28Pass_value

    property singleE20SingleTau28Prescale:
        def __get__(self):
            self.singleE20SingleTau28Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE20SingleTau28Prescale_value

    property singleE22SingleTau20SingleL1Group:
        def __get__(self):
            self.singleE22SingleTau20SingleL1Group_branch.GetEntry(self.localentry, 0)
            return self.singleE22SingleTau20SingleL1Group_value

    property singleE22SingleTau20SingleL1Pass:
        def __get__(self):
            self.singleE22SingleTau20SingleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE22SingleTau20SingleL1Pass_value

    property singleE22SingleTau20SingleL1Prescale:
        def __get__(self):
            self.singleE22SingleTau20SingleL1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE22SingleTau20SingleL1Prescale_value

    property singleE22SingleTau29Group:
        def __get__(self):
            self.singleE22SingleTau29Group_branch.GetEntry(self.localentry, 0)
            return self.singleE22SingleTau29Group_value

    property singleE22SingleTau29Pass:
        def __get__(self):
            self.singleE22SingleTau29Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE22SingleTau29Pass_value

    property singleE22SingleTau29Prescale:
        def __get__(self):
            self.singleE22SingleTau29Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE22SingleTau29Prescale_value

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

    property singleE24SingleTau20Group:
        def __get__(self):
            self.singleE24SingleTau20Group_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTau20Group_value

    property singleE24SingleTau20Pass:
        def __get__(self):
            self.singleE24SingleTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTau20Pass_value

    property singleE24SingleTau20Prescale:
        def __get__(self):
            self.singleE24SingleTau20Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTau20Prescale_value

    property singleE24SingleTau20SingleL1Group:
        def __get__(self):
            self.singleE24SingleTau20SingleL1Group_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTau20SingleL1Group_value

    property singleE24SingleTau20SingleL1Pass:
        def __get__(self):
            self.singleE24SingleTau20SingleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTau20SingleL1Pass_value

    property singleE24SingleTau20SingleL1Prescale:
        def __get__(self):
            self.singleE24SingleTau20SingleL1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTau20SingleL1Prescale_value

    property singleE24SingleTau30Group:
        def __get__(self):
            self.singleE24SingleTau30Group_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTau30Group_value

    property singleE24SingleTau30Pass:
        def __get__(self):
            self.singleE24SingleTau30Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTau30Pass_value

    property singleE24SingleTau30Prescale:
        def __get__(self):
            self.singleE24SingleTau30Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTau30Prescale_value

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

    property singleE27SingleTau20SingleL1Group:
        def __get__(self):
            self.singleE27SingleTau20SingleL1Group_branch.GetEntry(self.localentry, 0)
            return self.singleE27SingleTau20SingleL1Group_value

    property singleE27SingleTau20SingleL1Pass:
        def __get__(self):
            self.singleE27SingleTau20SingleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE27SingleTau20SingleL1Pass_value

    property singleE27SingleTau20SingleL1Prescale:
        def __get__(self):
            self.singleE27SingleTau20SingleL1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE27SingleTau20SingleL1Prescale_value

    property singleE27TightGroup:
        def __get__(self):
            self.singleE27TightGroup_branch.GetEntry(self.localentry, 0)
            return self.singleE27TightGroup_value

    property singleE27TightPass:
        def __get__(self):
            self.singleE27TightPass_branch.GetEntry(self.localentry, 0)
            return self.singleE27TightPass_value

    property singleE27TightPrescale:
        def __get__(self):
            self.singleE27TightPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleE27TightPrescale_value

    property singleE27eta2p1LooseGroup:
        def __get__(self):
            self.singleE27eta2p1LooseGroup_branch.GetEntry(self.localentry, 0)
            return self.singleE27eta2p1LooseGroup_value

    property singleE27eta2p1LoosePass:
        def __get__(self):
            self.singleE27eta2p1LoosePass_branch.GetEntry(self.localentry, 0)
            return self.singleE27eta2p1LoosePass_value

    property singleE27eta2p1LoosePrescale:
        def __get__(self):
            self.singleE27eta2p1LoosePrescale_branch.GetEntry(self.localentry, 0)
            return self.singleE27eta2p1LoosePrescale_value

    property singleE27eta2p1TightGroup:
        def __get__(self):
            self.singleE27eta2p1TightGroup_branch.GetEntry(self.localentry, 0)
            return self.singleE27eta2p1TightGroup_value

    property singleE27eta2p1TightPass:
        def __get__(self):
            self.singleE27eta2p1TightPass_branch.GetEntry(self.localentry, 0)
            return self.singleE27eta2p1TightPass_value

    property singleE27eta2p1TightPrescale:
        def __get__(self):
            self.singleE27eta2p1TightPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleE27eta2p1TightPrescale_value

    property singleE32SingleTau20SingleL1Group:
        def __get__(self):
            self.singleE32SingleTau20SingleL1Group_branch.GetEntry(self.localentry, 0)
            return self.singleE32SingleTau20SingleL1Group_value

    property singleE32SingleTau20SingleL1Pass:
        def __get__(self):
            self.singleE32SingleTau20SingleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE32SingleTau20SingleL1Pass_value

    property singleE32SingleTau20SingleL1Prescale:
        def __get__(self):
            self.singleE32SingleTau20SingleL1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE32SingleTau20SingleL1Prescale_value

    property singleE36SingleTau30Group:
        def __get__(self):
            self.singleE36SingleTau30Group_branch.GetEntry(self.localentry, 0)
            return self.singleE36SingleTau30Group_value

    property singleE36SingleTau30Pass:
        def __get__(self):
            self.singleE36SingleTau30Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE36SingleTau30Pass_value

    property singleE36SingleTau30Prescale:
        def __get__(self):
            self.singleE36SingleTau30Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE36SingleTau30Prescale_value

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

    property singleIsoMu24Group:
        def __get__(self):
            self.singleIsoMu24Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu24Group_value

    property singleIsoMu24Pass:
        def __get__(self):
            self.singleIsoMu24Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu24Pass_value

    property singleIsoMu24Prescale:
        def __get__(self):
            self.singleIsoMu24Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu24Prescale_value

    property singleIsoMu24eta2p1Group:
        def __get__(self):
            self.singleIsoMu24eta2p1Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu24eta2p1Group_value

    property singleIsoMu24eta2p1Pass:
        def __get__(self):
            self.singleIsoMu24eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu24eta2p1Pass_value

    property singleIsoMu24eta2p1Prescale:
        def __get__(self):
            self.singleIsoMu24eta2p1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu24eta2p1Prescale_value

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

    property singleIsoTkMu22eta2p1Group:
        def __get__(self):
            self.singleIsoTkMu22eta2p1Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu22eta2p1Group_value

    property singleIsoTkMu22eta2p1Pass:
        def __get__(self):
            self.singleIsoTkMu22eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu22eta2p1Pass_value

    property singleIsoTkMu22eta2p1Prescale:
        def __get__(self):
            self.singleIsoTkMu22eta2p1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu22eta2p1Prescale_value

    property singleIsoTkMu24Group:
        def __get__(self):
            self.singleIsoTkMu24Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu24Group_value

    property singleIsoTkMu24Pass:
        def __get__(self):
            self.singleIsoTkMu24Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu24Pass_value

    property singleIsoTkMu24Prescale:
        def __get__(self):
            self.singleIsoTkMu24Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu24Prescale_value

    property singleIsoTkMu24eta2p1Group:
        def __get__(self):
            self.singleIsoTkMu24eta2p1Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu24eta2p1Group_value

    property singleIsoTkMu24eta2p1Pass:
        def __get__(self):
            self.singleIsoTkMu24eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu24eta2p1Pass_value

    property singleIsoTkMu24eta2p1Prescale:
        def __get__(self):
            self.singleIsoTkMu24eta2p1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu24eta2p1Prescale_value

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

    property singleMu19eta2p1LooseTau20Group:
        def __get__(self):
            self.singleMu19eta2p1LooseTau20Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu19eta2p1LooseTau20Group_value

    property singleMu19eta2p1LooseTau20Pass:
        def __get__(self):
            self.singleMu19eta2p1LooseTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu19eta2p1LooseTau20Pass_value

    property singleMu19eta2p1LooseTau20Prescale:
        def __get__(self):
            self.singleMu19eta2p1LooseTau20Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu19eta2p1LooseTau20Prescale_value

    property singleMu19eta2p1LooseTau20singleL1Group:
        def __get__(self):
            self.singleMu19eta2p1LooseTau20singleL1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu19eta2p1LooseTau20singleL1Group_value

    property singleMu19eta2p1LooseTau20singleL1Pass:
        def __get__(self):
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu19eta2p1LooseTau20singleL1Pass_value

    property singleMu19eta2p1LooseTau20singleL1Prescale:
        def __get__(self):
            self.singleMu19eta2p1LooseTau20singleL1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu19eta2p1LooseTau20singleL1Prescale_value

    property singleMu21eta2p1LooseTau20singleL1Group:
        def __get__(self):
            self.singleMu21eta2p1LooseTau20singleL1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu21eta2p1LooseTau20singleL1Group_value

    property singleMu21eta2p1LooseTau20singleL1Pass:
        def __get__(self):
            self.singleMu21eta2p1LooseTau20singleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu21eta2p1LooseTau20singleL1Pass_value

    property singleMu21eta2p1LooseTau20singleL1Prescale:
        def __get__(self):
            self.singleMu21eta2p1LooseTau20singleL1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu21eta2p1LooseTau20singleL1Prescale_value

    property singleMu23SingleE12DZGroup:
        def __get__(self):
            self.singleMu23SingleE12DZGroup_branch.GetEntry(self.localentry, 0)
            return self.singleMu23SingleE12DZGroup_value

    property singleMu23SingleE12DZPass:
        def __get__(self):
            self.singleMu23SingleE12DZPass_branch.GetEntry(self.localentry, 0)
            return self.singleMu23SingleE12DZPass_value

    property singleMu23SingleE12DZPrescale:
        def __get__(self):
            self.singleMu23SingleE12DZPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu23SingleE12DZPrescale_value

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

    property singleMu23SingleE8Group:
        def __get__(self):
            self.singleMu23SingleE8Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu23SingleE8Group_value

    property singleMu23SingleE8Pass:
        def __get__(self):
            self.singleMu23SingleE8Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu23SingleE8Pass_value

    property singleMu23SingleE8Prescale:
        def __get__(self):
            self.singleMu23SingleE8Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu23SingleE8Prescale_value

    property singleMu8SingleE23DZGroup:
        def __get__(self):
            self.singleMu8SingleE23DZGroup_branch.GetEntry(self.localentry, 0)
            return self.singleMu8SingleE23DZGroup_value

    property singleMu8SingleE23DZPass:
        def __get__(self):
            self.singleMu8SingleE23DZPass_branch.GetEntry(self.localentry, 0)
            return self.singleMu8SingleE23DZPass_value

    property singleMu8SingleE23DZPrescale:
        def __get__(self):
            self.singleMu8SingleE23DZPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu8SingleE23DZPrescale_value

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

    property singleTau140Group:
        def __get__(self):
            self.singleTau140Group_branch.GetEntry(self.localentry, 0)
            return self.singleTau140Group_value

    property singleTau140Pass:
        def __get__(self):
            self.singleTau140Pass_branch.GetEntry(self.localentry, 0)
            return self.singleTau140Pass_value

    property singleTau140Prescale:
        def __get__(self):
            self.singleTau140Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleTau140Prescale_value

    property singleTau140Trk50Group:
        def __get__(self):
            self.singleTau140Trk50Group_branch.GetEntry(self.localentry, 0)
            return self.singleTau140Trk50Group_value

    property singleTau140Trk50Pass:
        def __get__(self):
            self.singleTau140Trk50Pass_branch.GetEntry(self.localentry, 0)
            return self.singleTau140Trk50Pass_value

    property singleTau140Trk50Prescale:
        def __get__(self):
            self.singleTau140Trk50Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleTau140Trk50Prescale_value

    property tauVetoPt20Loose3HitsVtx:
        def __get__(self):
            self.tauVetoPt20Loose3HitsVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20Loose3HitsVtx_value

    property tauVetoPt20TightMVALTVtx:
        def __get__(self):
            self.tauVetoPt20TightMVALTVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20TightMVALTVtx_value

    property topQuarkPt1:
        def __get__(self):
            self.topQuarkPt1_branch.GetEntry(self.localentry, 0)
            return self.topQuarkPt1_value

    property topQuarkPt2:
        def __get__(self):
            self.topQuarkPt2_branch.GetEntry(self.localentry, 0)
            return self.topQuarkPt2_value

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

    property vbfNJets20:
        def __get__(self):
            self.vbfNJets20_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets20_value

    property vbfNJets20_JetEnDown:
        def __get__(self):
            self.vbfNJets20_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets20_JetEnDown_value

    property vbfNJets20_JetEnUp:
        def __get__(self):
            self.vbfNJets20_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets20_JetEnUp_value

    property vbfNJets30:
        def __get__(self):
            self.vbfNJets30_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets30_value

    property vbfNJets30_JetEnDown:
        def __get__(self):
            self.vbfNJets30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets30_JetEnDown_value

    property vbfNJets30_JetEnUp:
        def __get__(self):
            self.vbfNJets30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets30_JetEnUp_value

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

    property vispX:
        def __get__(self):
            self.vispX_branch.GetEntry(self.localentry, 0)
            return self.vispX_value

    property vispY:
        def __get__(self):
            self.vispY_branch.GetEntry(self.localentry, 0)
            return self.vispY_value

    property idx:
        def __get__(self):
            self.idx_branch.GetEntry(self.localentry, 0)
            return self.idx_value


