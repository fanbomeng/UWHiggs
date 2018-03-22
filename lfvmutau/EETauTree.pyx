

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

    cdef TBranch* e1AbsEta_branch
    cdef float e1AbsEta_value

    cdef TBranch* e1CBIDLoose_branch
    cdef float e1CBIDLoose_value

    cdef TBranch* e1CBIDLooseNoIso_branch
    cdef float e1CBIDLooseNoIso_value

    cdef TBranch* e1CBIDMedium_branch
    cdef float e1CBIDMedium_value

    cdef TBranch* e1CBIDMediumNoIso_branch
    cdef float e1CBIDMediumNoIso_value

    cdef TBranch* e1CBIDTight_branch
    cdef float e1CBIDTight_value

    cdef TBranch* e1CBIDTightNoIso_branch
    cdef float e1CBIDTightNoIso_value

    cdef TBranch* e1CBIDVeto_branch
    cdef float e1CBIDVeto_value

    cdef TBranch* e1CBIDVetoNoIso_branch
    cdef float e1CBIDVetoNoIso_value

    cdef TBranch* e1Charge_branch
    cdef float e1Charge_value

    cdef TBranch* e1ChargeIdLoose_branch
    cdef float e1ChargeIdLoose_value

    cdef TBranch* e1ChargeIdMed_branch
    cdef float e1ChargeIdMed_value

    cdef TBranch* e1ChargeIdTight_branch
    cdef float e1ChargeIdTight_value

    cdef TBranch* e1ComesFromHiggs_branch
    cdef float e1ComesFromHiggs_value

    cdef TBranch* e1DPhiToPfMet_type1_branch
    cdef float e1DPhiToPfMet_type1_value

    cdef TBranch* e1E1x5_branch
    cdef float e1E1x5_value

    cdef TBranch* e1E2x5Max_branch
    cdef float e1E2x5Max_value

    cdef TBranch* e1E5x5_branch
    cdef float e1E5x5_value

    cdef TBranch* e1EcalIsoDR03_branch
    cdef float e1EcalIsoDR03_value

    cdef TBranch* e1EffectiveArea2012Data_branch
    cdef float e1EffectiveArea2012Data_value

    cdef TBranch* e1EffectiveAreaSpring15_branch
    cdef float e1EffectiveAreaSpring15_value

    cdef TBranch* e1EnergyError_branch
    cdef float e1EnergyError_value

    cdef TBranch* e1ErsatzGenEta_branch
    cdef float e1ErsatzGenEta_value

    cdef TBranch* e1ErsatzGenM_branch
    cdef float e1ErsatzGenM_value

    cdef TBranch* e1ErsatzGenPhi_branch
    cdef float e1ErsatzGenPhi_value

    cdef TBranch* e1ErsatzGenpT_branch
    cdef float e1ErsatzGenpT_value

    cdef TBranch* e1ErsatzGenpX_branch
    cdef float e1ErsatzGenpX_value

    cdef TBranch* e1ErsatzGenpY_branch
    cdef float e1ErsatzGenpY_value

    cdef TBranch* e1ErsatzVispX_branch
    cdef float e1ErsatzVispX_value

    cdef TBranch* e1ErsatzVispY_branch
    cdef float e1ErsatzVispY_value

    cdef TBranch* e1Eta_branch
    cdef float e1Eta_value

    cdef TBranch* e1Eta_ElectronEnDown_branch
    cdef float e1Eta_ElectronEnDown_value

    cdef TBranch* e1Eta_ElectronEnUp_branch
    cdef float e1Eta_ElectronEnUp_value

    cdef TBranch* e1GenCharge_branch
    cdef float e1GenCharge_value

    cdef TBranch* e1GenDirectPromptTauDecay_branch
    cdef float e1GenDirectPromptTauDecay_value

    cdef TBranch* e1GenEnergy_branch
    cdef float e1GenEnergy_value

    cdef TBranch* e1GenEta_branch
    cdef float e1GenEta_value

    cdef TBranch* e1GenIsPrompt_branch
    cdef float e1GenIsPrompt_value

    cdef TBranch* e1GenMotherPdgId_branch
    cdef float e1GenMotherPdgId_value

    cdef TBranch* e1GenParticle_branch
    cdef float e1GenParticle_value

    cdef TBranch* e1GenPdgId_branch
    cdef float e1GenPdgId_value

    cdef TBranch* e1GenPhi_branch
    cdef float e1GenPhi_value

    cdef TBranch* e1GenPrompt_branch
    cdef float e1GenPrompt_value

    cdef TBranch* e1GenPromptTauDecay_branch
    cdef float e1GenPromptTauDecay_value

    cdef TBranch* e1GenPt_branch
    cdef float e1GenPt_value

    cdef TBranch* e1GenTauDecay_branch
    cdef float e1GenTauDecay_value

    cdef TBranch* e1GenVZ_branch
    cdef float e1GenVZ_value

    cdef TBranch* e1GenVtxPVMatch_branch
    cdef float e1GenVtxPVMatch_value

    cdef TBranch* e1HadronicDepth1OverEm_branch
    cdef float e1HadronicDepth1OverEm_value

    cdef TBranch* e1HadronicDepth2OverEm_branch
    cdef float e1HadronicDepth2OverEm_value

    cdef TBranch* e1HadronicOverEM_branch
    cdef float e1HadronicOverEM_value

    cdef TBranch* e1HcalIsoDR03_branch
    cdef float e1HcalIsoDR03_value

    cdef TBranch* e1IP3D_branch
    cdef float e1IP3D_value

    cdef TBranch* e1IP3DErr_branch
    cdef float e1IP3DErr_value

    cdef TBranch* e1IsoDB03_branch
    cdef float e1IsoDB03_value

    cdef TBranch* e1JetArea_branch
    cdef float e1JetArea_value

    cdef TBranch* e1JetBtag_branch
    cdef float e1JetBtag_value

    cdef TBranch* e1JetEtaEtaMoment_branch
    cdef float e1JetEtaEtaMoment_value

    cdef TBranch* e1JetEtaPhiMoment_branch
    cdef float e1JetEtaPhiMoment_value

    cdef TBranch* e1JetEtaPhiSpread_branch
    cdef float e1JetEtaPhiSpread_value

    cdef TBranch* e1JetHadronFlavour_branch
    cdef float e1JetHadronFlavour_value

    cdef TBranch* e1JetPFCISVBtag_branch
    cdef float e1JetPFCISVBtag_value

    cdef TBranch* e1JetPartonFlavour_branch
    cdef float e1JetPartonFlavour_value

    cdef TBranch* e1JetPhiPhiMoment_branch
    cdef float e1JetPhiPhiMoment_value

    cdef TBranch* e1JetPt_branch
    cdef float e1JetPt_value

    cdef TBranch* e1LowestMll_branch
    cdef float e1LowestMll_value

    cdef TBranch* e1MVANonTrigCategory_branch
    cdef float e1MVANonTrigCategory_value

    cdef TBranch* e1MVANonTrigID_branch
    cdef float e1MVANonTrigID_value

    cdef TBranch* e1MVANonTrigWP80_branch
    cdef float e1MVANonTrigWP80_value

    cdef TBranch* e1MVANonTrigWP90_branch
    cdef float e1MVANonTrigWP90_value

    cdef TBranch* e1MVATrigCategory_branch
    cdef float e1MVATrigCategory_value

    cdef TBranch* e1MVATrigID_branch
    cdef float e1MVATrigID_value

    cdef TBranch* e1MVATrigWP80_branch
    cdef float e1MVATrigWP80_value

    cdef TBranch* e1MVATrigWP90_branch
    cdef float e1MVATrigWP90_value

    cdef TBranch* e1Mass_branch
    cdef float e1Mass_value

    cdef TBranch* e1MatchesDoubleE_branch
    cdef float e1MatchesDoubleE_value

    cdef TBranch* e1MatchesDoubleESingleMu_branch
    cdef float e1MatchesDoubleESingleMu_value

    cdef TBranch* e1MatchesDoubleMuSingleE_branch
    cdef float e1MatchesDoubleMuSingleE_value

    cdef TBranch* e1MatchesEle115Filter_branch
    cdef float e1MatchesEle115Filter_value

    cdef TBranch* e1MatchesEle115Path_branch
    cdef float e1MatchesEle115Path_value

    cdef TBranch* e1MatchesEle24Tau20Filter_branch
    cdef float e1MatchesEle24Tau20Filter_value

    cdef TBranch* e1MatchesEle24Tau20Path_branch
    cdef float e1MatchesEle24Tau20Path_value

    cdef TBranch* e1MatchesEle24Tau20sL1Filter_branch
    cdef float e1MatchesEle24Tau20sL1Filter_value

    cdef TBranch* e1MatchesEle24Tau20sL1Path_branch
    cdef float e1MatchesEle24Tau20sL1Path_value

    cdef TBranch* e1MatchesEle24Tau30Filter_branch
    cdef float e1MatchesEle24Tau30Filter_value

    cdef TBranch* e1MatchesEle24Tau30Path_branch
    cdef float e1MatchesEle24Tau30Path_value

    cdef TBranch* e1MatchesEle25LooseFilter_branch
    cdef float e1MatchesEle25LooseFilter_value

    cdef TBranch* e1MatchesEle25TightFilter_branch
    cdef float e1MatchesEle25TightFilter_value

    cdef TBranch* e1MatchesEle25eta2p1TightFilter_branch
    cdef float e1MatchesEle25eta2p1TightFilter_value

    cdef TBranch* e1MatchesEle25eta2p1TightPath_branch
    cdef float e1MatchesEle25eta2p1TightPath_value

    cdef TBranch* e1MatchesEle27TightFilter_branch
    cdef float e1MatchesEle27TightFilter_value

    cdef TBranch* e1MatchesEle27TightPath_branch
    cdef float e1MatchesEle27TightPath_value

    cdef TBranch* e1MatchesEle27eta2p1LooseFilter_branch
    cdef float e1MatchesEle27eta2p1LooseFilter_value

    cdef TBranch* e1MatchesEle27eta2p1LoosePath_branch
    cdef float e1MatchesEle27eta2p1LoosePath_value

    cdef TBranch* e1MatchesEle45L1JetTauPath_branch
    cdef float e1MatchesEle45L1JetTauPath_value

    cdef TBranch* e1MatchesEle45LooseL1JetTauFilter_branch
    cdef float e1MatchesEle45LooseL1JetTauFilter_value

    cdef TBranch* e1MatchesMu23Ele12DZFilter_branch
    cdef float e1MatchesMu23Ele12DZFilter_value

    cdef TBranch* e1MatchesMu23Ele12DZPath_branch
    cdef float e1MatchesMu23Ele12DZPath_value

    cdef TBranch* e1MatchesMu23Ele12Filter_branch
    cdef float e1MatchesMu23Ele12Filter_value

    cdef TBranch* e1MatchesMu23Ele12Path_branch
    cdef float e1MatchesMu23Ele12Path_value

    cdef TBranch* e1MatchesMu23Ele8DZFilter_branch
    cdef float e1MatchesMu23Ele8DZFilter_value

    cdef TBranch* e1MatchesMu23Ele8DZPath_branch
    cdef float e1MatchesMu23Ele8DZPath_value

    cdef TBranch* e1MatchesMu23Ele8Filter_branch
    cdef float e1MatchesMu23Ele8Filter_value

    cdef TBranch* e1MatchesMu23Ele8Path_branch
    cdef float e1MatchesMu23Ele8Path_value

    cdef TBranch* e1MatchesMu8Ele23DZFilter_branch
    cdef float e1MatchesMu8Ele23DZFilter_value

    cdef TBranch* e1MatchesMu8Ele23DZPath_branch
    cdef float e1MatchesMu8Ele23DZPath_value

    cdef TBranch* e1MatchesMu8Ele23Filter_branch
    cdef float e1MatchesMu8Ele23Filter_value

    cdef TBranch* e1MatchesMu8Ele23Path_branch
    cdef float e1MatchesMu8Ele23Path_value

    cdef TBranch* e1MatchesSingleE_branch
    cdef float e1MatchesSingleE_value

    cdef TBranch* e1MatchesSingleESingleMu_branch
    cdef float e1MatchesSingleESingleMu_value

    cdef TBranch* e1MatchesSingleE_leg1_branch
    cdef float e1MatchesSingleE_leg1_value

    cdef TBranch* e1MatchesSingleE_leg2_branch
    cdef float e1MatchesSingleE_leg2_value

    cdef TBranch* e1MatchesSingleMuSingleE_branch
    cdef float e1MatchesSingleMuSingleE_value

    cdef TBranch* e1MatchesTripleE_branch
    cdef float e1MatchesTripleE_value

    cdef TBranch* e1MissingHits_branch
    cdef float e1MissingHits_value

    cdef TBranch* e1MtToPfMet_type1_branch
    cdef float e1MtToPfMet_type1_value

    cdef TBranch* e1NearMuonVeto_branch
    cdef float e1NearMuonVeto_value

    cdef TBranch* e1NearestMuonDR_branch
    cdef float e1NearestMuonDR_value

    cdef TBranch* e1NearestZMass_branch
    cdef float e1NearestZMass_value

    cdef TBranch* e1PFChargedIso_branch
    cdef float e1PFChargedIso_value

    cdef TBranch* e1PFNeutralIso_branch
    cdef float e1PFNeutralIso_value

    cdef TBranch* e1PFPUChargedIso_branch
    cdef float e1PFPUChargedIso_value

    cdef TBranch* e1PFPhotonIso_branch
    cdef float e1PFPhotonIso_value

    cdef TBranch* e1PVDXY_branch
    cdef float e1PVDXY_value

    cdef TBranch* e1PVDZ_branch
    cdef float e1PVDZ_value

    cdef TBranch* e1PassesConversionVeto_branch
    cdef float e1PassesConversionVeto_value

    cdef TBranch* e1Phi_branch
    cdef float e1Phi_value

    cdef TBranch* e1Phi_ElectronEnDown_branch
    cdef float e1Phi_ElectronEnDown_value

    cdef TBranch* e1Phi_ElectronEnUp_branch
    cdef float e1Phi_ElectronEnUp_value

    cdef TBranch* e1Pt_branch
    cdef float e1Pt_value

    cdef TBranch* e1Pt_ElectronEnDown_branch
    cdef float e1Pt_ElectronEnDown_value

    cdef TBranch* e1Pt_ElectronEnUp_branch
    cdef float e1Pt_ElectronEnUp_value

    cdef TBranch* e1Rank_branch
    cdef float e1Rank_value

    cdef TBranch* e1RelIso_branch
    cdef float e1RelIso_value

    cdef TBranch* e1RelPFIsoDB_branch
    cdef float e1RelPFIsoDB_value

    cdef TBranch* e1RelPFIsoRho_branch
    cdef float e1RelPFIsoRho_value

    cdef TBranch* e1Rho_branch
    cdef float e1Rho_value

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

    cdef TBranch* e1SIP2D_branch
    cdef float e1SIP2D_value

    cdef TBranch* e1SIP3D_branch
    cdef float e1SIP3D_value

    cdef TBranch* e1SigmaIEtaIEta_branch
    cdef float e1SigmaIEtaIEta_value

    cdef TBranch* e1TrkIsoDR03_branch
    cdef float e1TrkIsoDR03_value

    cdef TBranch* e1VZ_branch
    cdef float e1VZ_value

    cdef TBranch* e1WWLoose_branch
    cdef float e1WWLoose_value

    cdef TBranch* e1ZTTGenMatching_branch
    cdef float e1ZTTGenMatching_value

    cdef TBranch* e1_e2_CosThetaStar_branch
    cdef float e1_e2_CosThetaStar_value

    cdef TBranch* e1_e2_DPhi_branch
    cdef float e1_e2_DPhi_value

    cdef TBranch* e1_e2_DR_branch
    cdef float e1_e2_DR_value

    cdef TBranch* e1_e2_Eta_branch
    cdef float e1_e2_Eta_value

    cdef TBranch* e1_e2_Mass_branch
    cdef float e1_e2_Mass_value

    cdef TBranch* e1_e2_Mass_TauEnDown_branch
    cdef float e1_e2_Mass_TauEnDown_value

    cdef TBranch* e1_e2_Mass_TauEnUp_branch
    cdef float e1_e2_Mass_TauEnUp_value

    cdef TBranch* e1_e2_Mt_branch
    cdef float e1_e2_Mt_value

    cdef TBranch* e1_e2_MtTotal_branch
    cdef float e1_e2_MtTotal_value

    cdef TBranch* e1_e2_Mt_TauEnDown_branch
    cdef float e1_e2_Mt_TauEnDown_value

    cdef TBranch* e1_e2_Mt_TauEnUp_branch
    cdef float e1_e2_Mt_TauEnUp_value

    cdef TBranch* e1_e2_MvaMet_branch
    cdef float e1_e2_MvaMet_value

    cdef TBranch* e1_e2_MvaMetCovMatrix00_branch
    cdef float e1_e2_MvaMetCovMatrix00_value

    cdef TBranch* e1_e2_MvaMetCovMatrix01_branch
    cdef float e1_e2_MvaMetCovMatrix01_value

    cdef TBranch* e1_e2_MvaMetCovMatrix10_branch
    cdef float e1_e2_MvaMetCovMatrix10_value

    cdef TBranch* e1_e2_MvaMetCovMatrix11_branch
    cdef float e1_e2_MvaMetCovMatrix11_value

    cdef TBranch* e1_e2_MvaMetPhi_branch
    cdef float e1_e2_MvaMetPhi_value

    cdef TBranch* e1_e2_PZeta_branch
    cdef float e1_e2_PZeta_value

    cdef TBranch* e1_e2_PZetaLess0p85PZetaVis_branch
    cdef float e1_e2_PZetaLess0p85PZetaVis_value

    cdef TBranch* e1_e2_PZetaVis_branch
    cdef float e1_e2_PZetaVis_value

    cdef TBranch* e1_e2_Phi_branch
    cdef float e1_e2_Phi_value

    cdef TBranch* e1_e2_Pt_branch
    cdef float e1_e2_Pt_value

    cdef TBranch* e1_e2_SS_branch
    cdef float e1_e2_SS_value

    cdef TBranch* e1_e2_ToMETDPhi_Ty1_branch
    cdef float e1_e2_ToMETDPhi_Ty1_value

    cdef TBranch* e1_e2_collinearmass_branch
    cdef float e1_e2_collinearmass_value

    cdef TBranch* e1_e2_collinearmass_CheckUESDown_branch
    cdef float e1_e2_collinearmass_CheckUESDown_value

    cdef TBranch* e1_e2_collinearmass_CheckUESUp_branch
    cdef float e1_e2_collinearmass_CheckUESUp_value

    cdef TBranch* e1_e2_collinearmass_EleEnDown_branch
    cdef float e1_e2_collinearmass_EleEnDown_value

    cdef TBranch* e1_e2_collinearmass_EleEnUp_branch
    cdef float e1_e2_collinearmass_EleEnUp_value

    cdef TBranch* e1_e2_collinearmass_JetCheckTotalDown_branch
    cdef float e1_e2_collinearmass_JetCheckTotalDown_value

    cdef TBranch* e1_e2_collinearmass_JetCheckTotalUp_branch
    cdef float e1_e2_collinearmass_JetCheckTotalUp_value

    cdef TBranch* e1_e2_collinearmass_JetEnDown_branch
    cdef float e1_e2_collinearmass_JetEnDown_value

    cdef TBranch* e1_e2_collinearmass_JetEnUp_branch
    cdef float e1_e2_collinearmass_JetEnUp_value

    cdef TBranch* e1_e2_collinearmass_MuEnDown_branch
    cdef float e1_e2_collinearmass_MuEnDown_value

    cdef TBranch* e1_e2_collinearmass_MuEnUp_branch
    cdef float e1_e2_collinearmass_MuEnUp_value

    cdef TBranch* e1_e2_collinearmass_TauEnDown_branch
    cdef float e1_e2_collinearmass_TauEnDown_value

    cdef TBranch* e1_e2_collinearmass_TauEnUp_branch
    cdef float e1_e2_collinearmass_TauEnUp_value

    cdef TBranch* e1_e2_collinearmass_UnclusteredEnDown_branch
    cdef float e1_e2_collinearmass_UnclusteredEnDown_value

    cdef TBranch* e1_e2_collinearmass_UnclusteredEnUp_branch
    cdef float e1_e2_collinearmass_UnclusteredEnUp_value

    cdef TBranch* e1_e2_pt_tt_branch
    cdef float e1_e2_pt_tt_value

    cdef TBranch* e1_t_CosThetaStar_branch
    cdef float e1_t_CosThetaStar_value

    cdef TBranch* e1_t_DPhi_branch
    cdef float e1_t_DPhi_value

    cdef TBranch* e1_t_DR_branch
    cdef float e1_t_DR_value

    cdef TBranch* e1_t_Eta_branch
    cdef float e1_t_Eta_value

    cdef TBranch* e1_t_Mass_branch
    cdef float e1_t_Mass_value

    cdef TBranch* e1_t_Mass_TauEnDown_branch
    cdef float e1_t_Mass_TauEnDown_value

    cdef TBranch* e1_t_Mass_TauEnUp_branch
    cdef float e1_t_Mass_TauEnUp_value

    cdef TBranch* e1_t_Mt_branch
    cdef float e1_t_Mt_value

    cdef TBranch* e1_t_MtTotal_branch
    cdef float e1_t_MtTotal_value

    cdef TBranch* e1_t_Mt_TauEnDown_branch
    cdef float e1_t_Mt_TauEnDown_value

    cdef TBranch* e1_t_Mt_TauEnUp_branch
    cdef float e1_t_Mt_TauEnUp_value

    cdef TBranch* e1_t_MvaMet_branch
    cdef float e1_t_MvaMet_value

    cdef TBranch* e1_t_MvaMetCovMatrix00_branch
    cdef float e1_t_MvaMetCovMatrix00_value

    cdef TBranch* e1_t_MvaMetCovMatrix01_branch
    cdef float e1_t_MvaMetCovMatrix01_value

    cdef TBranch* e1_t_MvaMetCovMatrix10_branch
    cdef float e1_t_MvaMetCovMatrix10_value

    cdef TBranch* e1_t_MvaMetCovMatrix11_branch
    cdef float e1_t_MvaMetCovMatrix11_value

    cdef TBranch* e1_t_MvaMetPhi_branch
    cdef float e1_t_MvaMetPhi_value

    cdef TBranch* e1_t_PZeta_branch
    cdef float e1_t_PZeta_value

    cdef TBranch* e1_t_PZetaLess0p85PZetaVis_branch
    cdef float e1_t_PZetaLess0p85PZetaVis_value

    cdef TBranch* e1_t_PZetaVis_branch
    cdef float e1_t_PZetaVis_value

    cdef TBranch* e1_t_Phi_branch
    cdef float e1_t_Phi_value

    cdef TBranch* e1_t_Pt_branch
    cdef float e1_t_Pt_value

    cdef TBranch* e1_t_SS_branch
    cdef float e1_t_SS_value

    cdef TBranch* e1_t_ToMETDPhi_Ty1_branch
    cdef float e1_t_ToMETDPhi_Ty1_value

    cdef TBranch* e1_t_collinearmass_branch
    cdef float e1_t_collinearmass_value

    cdef TBranch* e1_t_collinearmass_CheckUESDown_branch
    cdef float e1_t_collinearmass_CheckUESDown_value

    cdef TBranch* e1_t_collinearmass_CheckUESUp_branch
    cdef float e1_t_collinearmass_CheckUESUp_value

    cdef TBranch* e1_t_collinearmass_EleEnDown_branch
    cdef float e1_t_collinearmass_EleEnDown_value

    cdef TBranch* e1_t_collinearmass_EleEnUp_branch
    cdef float e1_t_collinearmass_EleEnUp_value

    cdef TBranch* e1_t_collinearmass_JetCheckTotalDown_branch
    cdef float e1_t_collinearmass_JetCheckTotalDown_value

    cdef TBranch* e1_t_collinearmass_JetCheckTotalUp_branch
    cdef float e1_t_collinearmass_JetCheckTotalUp_value

    cdef TBranch* e1_t_collinearmass_JetEnDown_branch
    cdef float e1_t_collinearmass_JetEnDown_value

    cdef TBranch* e1_t_collinearmass_JetEnUp_branch
    cdef float e1_t_collinearmass_JetEnUp_value

    cdef TBranch* e1_t_collinearmass_MuEnDown_branch
    cdef float e1_t_collinearmass_MuEnDown_value

    cdef TBranch* e1_t_collinearmass_MuEnUp_branch
    cdef float e1_t_collinearmass_MuEnUp_value

    cdef TBranch* e1_t_collinearmass_TauEnDown_branch
    cdef float e1_t_collinearmass_TauEnDown_value

    cdef TBranch* e1_t_collinearmass_TauEnUp_branch
    cdef float e1_t_collinearmass_TauEnUp_value

    cdef TBranch* e1_t_collinearmass_UnclusteredEnDown_branch
    cdef float e1_t_collinearmass_UnclusteredEnDown_value

    cdef TBranch* e1_t_collinearmass_UnclusteredEnUp_branch
    cdef float e1_t_collinearmass_UnclusteredEnUp_value

    cdef TBranch* e1_t_pt_tt_branch
    cdef float e1_t_pt_tt_value

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

    cdef TBranch* e2CBIDLoose_branch
    cdef float e2CBIDLoose_value

    cdef TBranch* e2CBIDLooseNoIso_branch
    cdef float e2CBIDLooseNoIso_value

    cdef TBranch* e2CBIDMedium_branch
    cdef float e2CBIDMedium_value

    cdef TBranch* e2CBIDMediumNoIso_branch
    cdef float e2CBIDMediumNoIso_value

    cdef TBranch* e2CBIDTight_branch
    cdef float e2CBIDTight_value

    cdef TBranch* e2CBIDTightNoIso_branch
    cdef float e2CBIDTightNoIso_value

    cdef TBranch* e2CBIDVeto_branch
    cdef float e2CBIDVeto_value

    cdef TBranch* e2CBIDVetoNoIso_branch
    cdef float e2CBIDVetoNoIso_value

    cdef TBranch* e2Charge_branch
    cdef float e2Charge_value

    cdef TBranch* e2ChargeIdLoose_branch
    cdef float e2ChargeIdLoose_value

    cdef TBranch* e2ChargeIdMed_branch
    cdef float e2ChargeIdMed_value

    cdef TBranch* e2ChargeIdTight_branch
    cdef float e2ChargeIdTight_value

    cdef TBranch* e2ComesFromHiggs_branch
    cdef float e2ComesFromHiggs_value

    cdef TBranch* e2DPhiToPfMet_type1_branch
    cdef float e2DPhiToPfMet_type1_value

    cdef TBranch* e2E1x5_branch
    cdef float e2E1x5_value

    cdef TBranch* e2E2x5Max_branch
    cdef float e2E2x5Max_value

    cdef TBranch* e2E5x5_branch
    cdef float e2E5x5_value

    cdef TBranch* e2EcalIsoDR03_branch
    cdef float e2EcalIsoDR03_value

    cdef TBranch* e2EffectiveArea2012Data_branch
    cdef float e2EffectiveArea2012Data_value

    cdef TBranch* e2EffectiveAreaSpring15_branch
    cdef float e2EffectiveAreaSpring15_value

    cdef TBranch* e2EnergyError_branch
    cdef float e2EnergyError_value

    cdef TBranch* e2ErsatzGenEta_branch
    cdef float e2ErsatzGenEta_value

    cdef TBranch* e2ErsatzGenM_branch
    cdef float e2ErsatzGenM_value

    cdef TBranch* e2ErsatzGenPhi_branch
    cdef float e2ErsatzGenPhi_value

    cdef TBranch* e2ErsatzGenpT_branch
    cdef float e2ErsatzGenpT_value

    cdef TBranch* e2ErsatzGenpX_branch
    cdef float e2ErsatzGenpX_value

    cdef TBranch* e2ErsatzGenpY_branch
    cdef float e2ErsatzGenpY_value

    cdef TBranch* e2ErsatzVispX_branch
    cdef float e2ErsatzVispX_value

    cdef TBranch* e2ErsatzVispY_branch
    cdef float e2ErsatzVispY_value

    cdef TBranch* e2Eta_branch
    cdef float e2Eta_value

    cdef TBranch* e2Eta_ElectronEnDown_branch
    cdef float e2Eta_ElectronEnDown_value

    cdef TBranch* e2Eta_ElectronEnUp_branch
    cdef float e2Eta_ElectronEnUp_value

    cdef TBranch* e2GenCharge_branch
    cdef float e2GenCharge_value

    cdef TBranch* e2GenDirectPromptTauDecay_branch
    cdef float e2GenDirectPromptTauDecay_value

    cdef TBranch* e2GenEnergy_branch
    cdef float e2GenEnergy_value

    cdef TBranch* e2GenEta_branch
    cdef float e2GenEta_value

    cdef TBranch* e2GenIsPrompt_branch
    cdef float e2GenIsPrompt_value

    cdef TBranch* e2GenMotherPdgId_branch
    cdef float e2GenMotherPdgId_value

    cdef TBranch* e2GenParticle_branch
    cdef float e2GenParticle_value

    cdef TBranch* e2GenPdgId_branch
    cdef float e2GenPdgId_value

    cdef TBranch* e2GenPhi_branch
    cdef float e2GenPhi_value

    cdef TBranch* e2GenPrompt_branch
    cdef float e2GenPrompt_value

    cdef TBranch* e2GenPromptTauDecay_branch
    cdef float e2GenPromptTauDecay_value

    cdef TBranch* e2GenPt_branch
    cdef float e2GenPt_value

    cdef TBranch* e2GenTauDecay_branch
    cdef float e2GenTauDecay_value

    cdef TBranch* e2GenVZ_branch
    cdef float e2GenVZ_value

    cdef TBranch* e2GenVtxPVMatch_branch
    cdef float e2GenVtxPVMatch_value

    cdef TBranch* e2HadronicDepth1OverEm_branch
    cdef float e2HadronicDepth1OverEm_value

    cdef TBranch* e2HadronicDepth2OverEm_branch
    cdef float e2HadronicDepth2OverEm_value

    cdef TBranch* e2HadronicOverEM_branch
    cdef float e2HadronicOverEM_value

    cdef TBranch* e2HcalIsoDR03_branch
    cdef float e2HcalIsoDR03_value

    cdef TBranch* e2IP3D_branch
    cdef float e2IP3D_value

    cdef TBranch* e2IP3DErr_branch
    cdef float e2IP3DErr_value

    cdef TBranch* e2IsoDB03_branch
    cdef float e2IsoDB03_value

    cdef TBranch* e2JetArea_branch
    cdef float e2JetArea_value

    cdef TBranch* e2JetBtag_branch
    cdef float e2JetBtag_value

    cdef TBranch* e2JetEtaEtaMoment_branch
    cdef float e2JetEtaEtaMoment_value

    cdef TBranch* e2JetEtaPhiMoment_branch
    cdef float e2JetEtaPhiMoment_value

    cdef TBranch* e2JetEtaPhiSpread_branch
    cdef float e2JetEtaPhiSpread_value

    cdef TBranch* e2JetHadronFlavour_branch
    cdef float e2JetHadronFlavour_value

    cdef TBranch* e2JetPFCISVBtag_branch
    cdef float e2JetPFCISVBtag_value

    cdef TBranch* e2JetPartonFlavour_branch
    cdef float e2JetPartonFlavour_value

    cdef TBranch* e2JetPhiPhiMoment_branch
    cdef float e2JetPhiPhiMoment_value

    cdef TBranch* e2JetPt_branch
    cdef float e2JetPt_value

    cdef TBranch* e2LowestMll_branch
    cdef float e2LowestMll_value

    cdef TBranch* e2MVANonTrigCategory_branch
    cdef float e2MVANonTrigCategory_value

    cdef TBranch* e2MVANonTrigID_branch
    cdef float e2MVANonTrigID_value

    cdef TBranch* e2MVANonTrigWP80_branch
    cdef float e2MVANonTrigWP80_value

    cdef TBranch* e2MVANonTrigWP90_branch
    cdef float e2MVANonTrigWP90_value

    cdef TBranch* e2MVATrigCategory_branch
    cdef float e2MVATrigCategory_value

    cdef TBranch* e2MVATrigID_branch
    cdef float e2MVATrigID_value

    cdef TBranch* e2MVATrigWP80_branch
    cdef float e2MVATrigWP80_value

    cdef TBranch* e2MVATrigWP90_branch
    cdef float e2MVATrigWP90_value

    cdef TBranch* e2Mass_branch
    cdef float e2Mass_value

    cdef TBranch* e2MatchesDoubleE_branch
    cdef float e2MatchesDoubleE_value

    cdef TBranch* e2MatchesDoubleESingleMu_branch
    cdef float e2MatchesDoubleESingleMu_value

    cdef TBranch* e2MatchesDoubleMuSingleE_branch
    cdef float e2MatchesDoubleMuSingleE_value

    cdef TBranch* e2MatchesEle115Filter_branch
    cdef float e2MatchesEle115Filter_value

    cdef TBranch* e2MatchesEle115Path_branch
    cdef float e2MatchesEle115Path_value

    cdef TBranch* e2MatchesEle24Tau20Filter_branch
    cdef float e2MatchesEle24Tau20Filter_value

    cdef TBranch* e2MatchesEle24Tau20Path_branch
    cdef float e2MatchesEle24Tau20Path_value

    cdef TBranch* e2MatchesEle24Tau20sL1Filter_branch
    cdef float e2MatchesEle24Tau20sL1Filter_value

    cdef TBranch* e2MatchesEle24Tau20sL1Path_branch
    cdef float e2MatchesEle24Tau20sL1Path_value

    cdef TBranch* e2MatchesEle24Tau30Filter_branch
    cdef float e2MatchesEle24Tau30Filter_value

    cdef TBranch* e2MatchesEle24Tau30Path_branch
    cdef float e2MatchesEle24Tau30Path_value

    cdef TBranch* e2MatchesEle25LooseFilter_branch
    cdef float e2MatchesEle25LooseFilter_value

    cdef TBranch* e2MatchesEle25TightFilter_branch
    cdef float e2MatchesEle25TightFilter_value

    cdef TBranch* e2MatchesEle25eta2p1TightFilter_branch
    cdef float e2MatchesEle25eta2p1TightFilter_value

    cdef TBranch* e2MatchesEle25eta2p1TightPath_branch
    cdef float e2MatchesEle25eta2p1TightPath_value

    cdef TBranch* e2MatchesEle27TightFilter_branch
    cdef float e2MatchesEle27TightFilter_value

    cdef TBranch* e2MatchesEle27TightPath_branch
    cdef float e2MatchesEle27TightPath_value

    cdef TBranch* e2MatchesEle27eta2p1LooseFilter_branch
    cdef float e2MatchesEle27eta2p1LooseFilter_value

    cdef TBranch* e2MatchesEle27eta2p1LoosePath_branch
    cdef float e2MatchesEle27eta2p1LoosePath_value

    cdef TBranch* e2MatchesEle45L1JetTauPath_branch
    cdef float e2MatchesEle45L1JetTauPath_value

    cdef TBranch* e2MatchesEle45LooseL1JetTauFilter_branch
    cdef float e2MatchesEle45LooseL1JetTauFilter_value

    cdef TBranch* e2MatchesMu23Ele12DZFilter_branch
    cdef float e2MatchesMu23Ele12DZFilter_value

    cdef TBranch* e2MatchesMu23Ele12DZPath_branch
    cdef float e2MatchesMu23Ele12DZPath_value

    cdef TBranch* e2MatchesMu23Ele12Filter_branch
    cdef float e2MatchesMu23Ele12Filter_value

    cdef TBranch* e2MatchesMu23Ele12Path_branch
    cdef float e2MatchesMu23Ele12Path_value

    cdef TBranch* e2MatchesMu23Ele8DZFilter_branch
    cdef float e2MatchesMu23Ele8DZFilter_value

    cdef TBranch* e2MatchesMu23Ele8DZPath_branch
    cdef float e2MatchesMu23Ele8DZPath_value

    cdef TBranch* e2MatchesMu23Ele8Filter_branch
    cdef float e2MatchesMu23Ele8Filter_value

    cdef TBranch* e2MatchesMu23Ele8Path_branch
    cdef float e2MatchesMu23Ele8Path_value

    cdef TBranch* e2MatchesMu8Ele23DZFilter_branch
    cdef float e2MatchesMu8Ele23DZFilter_value

    cdef TBranch* e2MatchesMu8Ele23DZPath_branch
    cdef float e2MatchesMu8Ele23DZPath_value

    cdef TBranch* e2MatchesMu8Ele23Filter_branch
    cdef float e2MatchesMu8Ele23Filter_value

    cdef TBranch* e2MatchesMu8Ele23Path_branch
    cdef float e2MatchesMu8Ele23Path_value

    cdef TBranch* e2MatchesSingleE_branch
    cdef float e2MatchesSingleE_value

    cdef TBranch* e2MatchesSingleESingleMu_branch
    cdef float e2MatchesSingleESingleMu_value

    cdef TBranch* e2MatchesSingleE_leg1_branch
    cdef float e2MatchesSingleE_leg1_value

    cdef TBranch* e2MatchesSingleE_leg2_branch
    cdef float e2MatchesSingleE_leg2_value

    cdef TBranch* e2MatchesSingleMuSingleE_branch
    cdef float e2MatchesSingleMuSingleE_value

    cdef TBranch* e2MatchesTripleE_branch
    cdef float e2MatchesTripleE_value

    cdef TBranch* e2MissingHits_branch
    cdef float e2MissingHits_value

    cdef TBranch* e2MtToPfMet_type1_branch
    cdef float e2MtToPfMet_type1_value

    cdef TBranch* e2NearMuonVeto_branch
    cdef float e2NearMuonVeto_value

    cdef TBranch* e2NearestMuonDR_branch
    cdef float e2NearestMuonDR_value

    cdef TBranch* e2NearestZMass_branch
    cdef float e2NearestZMass_value

    cdef TBranch* e2PFChargedIso_branch
    cdef float e2PFChargedIso_value

    cdef TBranch* e2PFNeutralIso_branch
    cdef float e2PFNeutralIso_value

    cdef TBranch* e2PFPUChargedIso_branch
    cdef float e2PFPUChargedIso_value

    cdef TBranch* e2PFPhotonIso_branch
    cdef float e2PFPhotonIso_value

    cdef TBranch* e2PVDXY_branch
    cdef float e2PVDXY_value

    cdef TBranch* e2PVDZ_branch
    cdef float e2PVDZ_value

    cdef TBranch* e2PassesConversionVeto_branch
    cdef float e2PassesConversionVeto_value

    cdef TBranch* e2Phi_branch
    cdef float e2Phi_value

    cdef TBranch* e2Phi_ElectronEnDown_branch
    cdef float e2Phi_ElectronEnDown_value

    cdef TBranch* e2Phi_ElectronEnUp_branch
    cdef float e2Phi_ElectronEnUp_value

    cdef TBranch* e2Pt_branch
    cdef float e2Pt_value

    cdef TBranch* e2Pt_ElectronEnDown_branch
    cdef float e2Pt_ElectronEnDown_value

    cdef TBranch* e2Pt_ElectronEnUp_branch
    cdef float e2Pt_ElectronEnUp_value

    cdef TBranch* e2Rank_branch
    cdef float e2Rank_value

    cdef TBranch* e2RelIso_branch
    cdef float e2RelIso_value

    cdef TBranch* e2RelPFIsoDB_branch
    cdef float e2RelPFIsoDB_value

    cdef TBranch* e2RelPFIsoRho_branch
    cdef float e2RelPFIsoRho_value

    cdef TBranch* e2Rho_branch
    cdef float e2Rho_value

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

    cdef TBranch* e2SIP2D_branch
    cdef float e2SIP2D_value

    cdef TBranch* e2SIP3D_branch
    cdef float e2SIP3D_value

    cdef TBranch* e2SigmaIEtaIEta_branch
    cdef float e2SigmaIEtaIEta_value

    cdef TBranch* e2TrkIsoDR03_branch
    cdef float e2TrkIsoDR03_value

    cdef TBranch* e2VZ_branch
    cdef float e2VZ_value

    cdef TBranch* e2WWLoose_branch
    cdef float e2WWLoose_value

    cdef TBranch* e2ZTTGenMatching_branch
    cdef float e2ZTTGenMatching_value

    cdef TBranch* e2_e1_collinearmass_branch
    cdef float e2_e1_collinearmass_value

    cdef TBranch* e2_e1_collinearmass_CheckUESDown_branch
    cdef float e2_e1_collinearmass_CheckUESDown_value

    cdef TBranch* e2_e1_collinearmass_CheckUESUp_branch
    cdef float e2_e1_collinearmass_CheckUESUp_value

    cdef TBranch* e2_e1_collinearmass_JetCheckTotalDown_branch
    cdef float e2_e1_collinearmass_JetCheckTotalDown_value

    cdef TBranch* e2_e1_collinearmass_JetCheckTotalUp_branch
    cdef float e2_e1_collinearmass_JetCheckTotalUp_value

    cdef TBranch* e2_e1_collinearmass_JetEnDown_branch
    cdef float e2_e1_collinearmass_JetEnDown_value

    cdef TBranch* e2_e1_collinearmass_JetEnUp_branch
    cdef float e2_e1_collinearmass_JetEnUp_value

    cdef TBranch* e2_e1_collinearmass_UnclusteredEnDown_branch
    cdef float e2_e1_collinearmass_UnclusteredEnDown_value

    cdef TBranch* e2_e1_collinearmass_UnclusteredEnUp_branch
    cdef float e2_e1_collinearmass_UnclusteredEnUp_value

    cdef TBranch* e2_t_CosThetaStar_branch
    cdef float e2_t_CosThetaStar_value

    cdef TBranch* e2_t_DPhi_branch
    cdef float e2_t_DPhi_value

    cdef TBranch* e2_t_DR_branch
    cdef float e2_t_DR_value

    cdef TBranch* e2_t_Eta_branch
    cdef float e2_t_Eta_value

    cdef TBranch* e2_t_Mass_branch
    cdef float e2_t_Mass_value

    cdef TBranch* e2_t_Mass_TauEnDown_branch
    cdef float e2_t_Mass_TauEnDown_value

    cdef TBranch* e2_t_Mass_TauEnUp_branch
    cdef float e2_t_Mass_TauEnUp_value

    cdef TBranch* e2_t_Mt_branch
    cdef float e2_t_Mt_value

    cdef TBranch* e2_t_MtTotal_branch
    cdef float e2_t_MtTotal_value

    cdef TBranch* e2_t_Mt_TauEnDown_branch
    cdef float e2_t_Mt_TauEnDown_value

    cdef TBranch* e2_t_Mt_TauEnUp_branch
    cdef float e2_t_Mt_TauEnUp_value

    cdef TBranch* e2_t_MvaMet_branch
    cdef float e2_t_MvaMet_value

    cdef TBranch* e2_t_MvaMetCovMatrix00_branch
    cdef float e2_t_MvaMetCovMatrix00_value

    cdef TBranch* e2_t_MvaMetCovMatrix01_branch
    cdef float e2_t_MvaMetCovMatrix01_value

    cdef TBranch* e2_t_MvaMetCovMatrix10_branch
    cdef float e2_t_MvaMetCovMatrix10_value

    cdef TBranch* e2_t_MvaMetCovMatrix11_branch
    cdef float e2_t_MvaMetCovMatrix11_value

    cdef TBranch* e2_t_MvaMetPhi_branch
    cdef float e2_t_MvaMetPhi_value

    cdef TBranch* e2_t_PZeta_branch
    cdef float e2_t_PZeta_value

    cdef TBranch* e2_t_PZetaLess0p85PZetaVis_branch
    cdef float e2_t_PZetaLess0p85PZetaVis_value

    cdef TBranch* e2_t_PZetaVis_branch
    cdef float e2_t_PZetaVis_value

    cdef TBranch* e2_t_Phi_branch
    cdef float e2_t_Phi_value

    cdef TBranch* e2_t_Pt_branch
    cdef float e2_t_Pt_value

    cdef TBranch* e2_t_SS_branch
    cdef float e2_t_SS_value

    cdef TBranch* e2_t_ToMETDPhi_Ty1_branch
    cdef float e2_t_ToMETDPhi_Ty1_value

    cdef TBranch* e2_t_collinearmass_branch
    cdef float e2_t_collinearmass_value

    cdef TBranch* e2_t_collinearmass_CheckUESDown_branch
    cdef float e2_t_collinearmass_CheckUESDown_value

    cdef TBranch* e2_t_collinearmass_CheckUESUp_branch
    cdef float e2_t_collinearmass_CheckUESUp_value

    cdef TBranch* e2_t_collinearmass_EleEnDown_branch
    cdef float e2_t_collinearmass_EleEnDown_value

    cdef TBranch* e2_t_collinearmass_EleEnUp_branch
    cdef float e2_t_collinearmass_EleEnUp_value

    cdef TBranch* e2_t_collinearmass_JetCheckTotalDown_branch
    cdef float e2_t_collinearmass_JetCheckTotalDown_value

    cdef TBranch* e2_t_collinearmass_JetCheckTotalUp_branch
    cdef float e2_t_collinearmass_JetCheckTotalUp_value

    cdef TBranch* e2_t_collinearmass_JetEnDown_branch
    cdef float e2_t_collinearmass_JetEnDown_value

    cdef TBranch* e2_t_collinearmass_JetEnUp_branch
    cdef float e2_t_collinearmass_JetEnUp_value

    cdef TBranch* e2_t_collinearmass_MuEnDown_branch
    cdef float e2_t_collinearmass_MuEnDown_value

    cdef TBranch* e2_t_collinearmass_MuEnUp_branch
    cdef float e2_t_collinearmass_MuEnUp_value

    cdef TBranch* e2_t_collinearmass_TauEnDown_branch
    cdef float e2_t_collinearmass_TauEnDown_value

    cdef TBranch* e2_t_collinearmass_TauEnUp_branch
    cdef float e2_t_collinearmass_TauEnUp_value

    cdef TBranch* e2_t_collinearmass_UnclusteredEnDown_branch
    cdef float e2_t_collinearmass_UnclusteredEnDown_value

    cdef TBranch* e2_t_collinearmass_UnclusteredEnUp_branch
    cdef float e2_t_collinearmass_UnclusteredEnUp_value

    cdef TBranch* e2_t_pt_tt_branch
    cdef float e2_t_pt_tt_value

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

    cdef TBranch* eVetoMVAIso_branch
    cdef float eVetoMVAIso_value

    cdef TBranch* eVetoMVAIsoVtx_branch
    cdef float eVetoMVAIsoVtx_value

    cdef TBranch* eVetoZTTp001dxyz_branch
    cdef float eVetoZTTp001dxyz_value

    cdef TBranch* eVetoZTTp001dxyzR0_branch
    cdef float eVetoZTTp001dxyzR0_value

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

    cdef TBranch* tGenIsPrompt_branch
    cdef float tGenIsPrompt_value

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

    cdef TBranch* tJetHadronFlavour_branch
    cdef float tJetHadronFlavour_value

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

    cdef TBranch* tMatchesDoubleTau32Filter_branch
    cdef float tMatchesDoubleTau32Filter_value

    cdef TBranch* tMatchesDoubleTau32Path_branch
    cdef float tMatchesDoubleTau32Path_value

    cdef TBranch* tMatchesDoubleTau35Filter_branch
    cdef float tMatchesDoubleTau35Filter_value

    cdef TBranch* tMatchesDoubleTau35Path_branch
    cdef float tMatchesDoubleTau35Path_value

    cdef TBranch* tMatchesDoubleTau40Filter_branch
    cdef float tMatchesDoubleTau40Filter_value

    cdef TBranch* tMatchesDoubleTau40Path_branch
    cdef float tMatchesDoubleTau40Path_value

    cdef TBranch* tMatchesDoubleTauCmbIso35RegFilter_branch
    cdef float tMatchesDoubleTauCmbIso35RegFilter_value

    cdef TBranch* tMatchesDoubleTauCmbIso35RegPath_branch
    cdef float tMatchesDoubleTauCmbIso35RegPath_value

    cdef TBranch* tMatchesDoubleTauCmbIso40Filter_branch
    cdef float tMatchesDoubleTauCmbIso40Filter_value

    cdef TBranch* tMatchesDoubleTauCmbIso40Path_branch
    cdef float tMatchesDoubleTauCmbIso40Path_value

    cdef TBranch* tMatchesDoubleTauCmbIso40RegFilter_branch
    cdef float tMatchesDoubleTauCmbIso40RegFilter_value

    cdef TBranch* tMatchesDoubleTauCmbIso40RegPath_branch
    cdef float tMatchesDoubleTauCmbIso40RegPath_value

    cdef TBranch* tMatchesEle24Tau20Filter_branch
    cdef float tMatchesEle24Tau20Filter_value

    cdef TBranch* tMatchesEle24Tau20L1Path_branch
    cdef float tMatchesEle24Tau20L1Path_value

    cdef TBranch* tMatchesEle24Tau20Path_branch
    cdef float tMatchesEle24Tau20Path_value

    cdef TBranch* tMatchesEle24Tau20sL1Filter_branch
    cdef float tMatchesEle24Tau20sL1Filter_value

    cdef TBranch* tMatchesEle24Tau30Filter_branch
    cdef float tMatchesEle24Tau30Filter_value

    cdef TBranch* tMatchesEle24Tau30Path_branch
    cdef float tMatchesEle24Tau30Path_value

    cdef TBranch* tMatchesMu19Tau20Filter_branch
    cdef float tMatchesMu19Tau20Filter_value

    cdef TBranch* tMatchesMu19Tau20Path_branch
    cdef float tMatchesMu19Tau20Path_value

    cdef TBranch* tMatchesMu19Tau20sL1Filter_branch
    cdef float tMatchesMu19Tau20sL1Filter_value

    cdef TBranch* tMatchesMu19Tau20sL1Path_branch
    cdef float tMatchesMu19Tau20sL1Path_value

    cdef TBranch* tMatchesMu21Tau20sL1Filter_branch
    cdef float tMatchesMu21Tau20sL1Filter_value

    cdef TBranch* tMatchesMu21Tau20sL1Path_branch
    cdef float tMatchesMu21Tau20sL1Path_value

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

    cdef TBranch* tNChrgHadrIsolationCands_branch
    cdef float tNChrgHadrIsolationCands_value

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

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTLoose_branch
    cdef float tRerunMVArun2v1DBoldDMwLTLoose_value

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTMedium_branch
    cdef float tRerunMVArun2v1DBoldDMwLTMedium_value

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTTight_branch
    cdef float tRerunMVArun2v1DBoldDMwLTTight_value

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTVLoose_branch
    cdef float tRerunMVArun2v1DBoldDMwLTVLoose_value

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTVTight_branch
    cdef float tRerunMVArun2v1DBoldDMwLTVTight_value

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTVVTight_branch
    cdef float tRerunMVArun2v1DBoldDMwLTVVTight_value

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTraw_branch
    cdef float tRerunMVArun2v1DBoldDMwLTraw_value

    cdef TBranch* tVZ_branch
    cdef float tVZ_value

    cdef TBranch* tZTTGenDR_branch
    cdef float tZTTGenDR_value

    cdef TBranch* tZTTGenEta_branch
    cdef float tZTTGenEta_value

    cdef TBranch* tZTTGenMatching_branch
    cdef float tZTTGenMatching_value

    cdef TBranch* tZTTGenPhi_branch
    cdef float tZTTGenPhi_value

    cdef TBranch* tZTTGenPt_branch
    cdef float tZTTGenPt_value

    cdef TBranch* t_e1_collinearmass_branch
    cdef float t_e1_collinearmass_value

    cdef TBranch* t_e1_collinearmass_CheckUESDown_branch
    cdef float t_e1_collinearmass_CheckUESDown_value

    cdef TBranch* t_e1_collinearmass_CheckUESUp_branch
    cdef float t_e1_collinearmass_CheckUESUp_value

    cdef TBranch* t_e1_collinearmass_JetCheckTotalDown_branch
    cdef float t_e1_collinearmass_JetCheckTotalDown_value

    cdef TBranch* t_e1_collinearmass_JetCheckTotalUp_branch
    cdef float t_e1_collinearmass_JetCheckTotalUp_value

    cdef TBranch* t_e1_collinearmass_JetEnDown_branch
    cdef float t_e1_collinearmass_JetEnDown_value

    cdef TBranch* t_e1_collinearmass_JetEnUp_branch
    cdef float t_e1_collinearmass_JetEnUp_value

    cdef TBranch* t_e1_collinearmass_UnclusteredEnDown_branch
    cdef float t_e1_collinearmass_UnclusteredEnDown_value

    cdef TBranch* t_e1_collinearmass_UnclusteredEnUp_branch
    cdef float t_e1_collinearmass_UnclusteredEnUp_value

    cdef TBranch* t_e2_collinearmass_branch
    cdef float t_e2_collinearmass_value

    cdef TBranch* t_e2_collinearmass_CheckUESDown_branch
    cdef float t_e2_collinearmass_CheckUESDown_value

    cdef TBranch* t_e2_collinearmass_CheckUESUp_branch
    cdef float t_e2_collinearmass_CheckUESUp_value

    cdef TBranch* t_e2_collinearmass_JetCheckTotalDown_branch
    cdef float t_e2_collinearmass_JetCheckTotalDown_value

    cdef TBranch* t_e2_collinearmass_JetCheckTotalUp_branch
    cdef float t_e2_collinearmass_JetCheckTotalUp_value

    cdef TBranch* t_e2_collinearmass_JetEnDown_branch
    cdef float t_e2_collinearmass_JetEnDown_value

    cdef TBranch* t_e2_collinearmass_JetEnUp_branch
    cdef float t_e2_collinearmass_JetEnUp_value

    cdef TBranch* t_e2_collinearmass_UnclusteredEnDown_branch
    cdef float t_e2_collinearmass_UnclusteredEnDown_value

    cdef TBranch* t_e2_collinearmass_UnclusteredEnUp_branch
    cdef float t_e2_collinearmass_UnclusteredEnUp_value

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
            warnings.warn( "EETauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "EETauTree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "EETauTree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "EETauTree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "EETauTree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "EETauTree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "EETauTree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_badCloneMuonFilter"
        self.Flag_badCloneMuonFilter_branch = the_tree.GetBranch("Flag_badCloneMuonFilter")
        #if not self.Flag_badCloneMuonFilter_branch and "Flag_badCloneMuonFilter" not in self.complained:
        if not self.Flag_badCloneMuonFilter_branch and "Flag_badCloneMuonFilter":
            warnings.warn( "EETauTree: Expected branch Flag_badCloneMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badCloneMuonFilter")
        else:
            self.Flag_badCloneMuonFilter_branch.SetAddress(<void*>&self.Flag_badCloneMuonFilter_value)

        #print "making Flag_badGlobalMuonFilter"
        self.Flag_badGlobalMuonFilter_branch = the_tree.GetBranch("Flag_badGlobalMuonFilter")
        #if not self.Flag_badGlobalMuonFilter_branch and "Flag_badGlobalMuonFilter" not in self.complained:
        if not self.Flag_badGlobalMuonFilter_branch and "Flag_badGlobalMuonFilter":
            warnings.warn( "EETauTree: Expected branch Flag_badGlobalMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badGlobalMuonFilter")
        else:
            self.Flag_badGlobalMuonFilter_branch.SetAddress(<void*>&self.Flag_badGlobalMuonFilter_value)

        #print "making Flag_badMuons"
        self.Flag_badMuons_branch = the_tree.GetBranch("Flag_badMuons")
        #if not self.Flag_badMuons_branch and "Flag_badMuons" not in self.complained:
        if not self.Flag_badMuons_branch and "Flag_badMuons":
            warnings.warn( "EETauTree: Expected branch Flag_badMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badMuons")
        else:
            self.Flag_badMuons_branch.SetAddress(<void*>&self.Flag_badMuons_value)

        #print "making Flag_duplicateMuons"
        self.Flag_duplicateMuons_branch = the_tree.GetBranch("Flag_duplicateMuons")
        #if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons" not in self.complained:
        if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons":
            warnings.warn( "EETauTree: Expected branch Flag_duplicateMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_duplicateMuons")
        else:
            self.Flag_duplicateMuons_branch.SetAddress(<void*>&self.Flag_duplicateMuons_value)

        #print "making Flag_eeBadScFilter"
        self.Flag_eeBadScFilter_branch = the_tree.GetBranch("Flag_eeBadScFilter")
        #if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter" not in self.complained:
        if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter":
            warnings.warn( "EETauTree: Expected branch Flag_eeBadScFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_eeBadScFilter")
        else:
            self.Flag_eeBadScFilter_branch.SetAddress(<void*>&self.Flag_eeBadScFilter_value)

        #print "making Flag_globalTightHalo2016Filter"
        self.Flag_globalTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalTightHalo2016Filter")
        #if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter":
            warnings.warn( "EETauTree: Expected branch Flag_globalTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalTightHalo2016Filter")
        else:
            self.Flag_globalTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalTightHalo2016Filter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "EETauTree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making Flag_noBadMuons"
        self.Flag_noBadMuons_branch = the_tree.GetBranch("Flag_noBadMuons")
        #if not self.Flag_noBadMuons_branch and "Flag_noBadMuons" not in self.complained:
        if not self.Flag_noBadMuons_branch and "Flag_noBadMuons":
            warnings.warn( "EETauTree: Expected branch Flag_noBadMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_noBadMuons")
        else:
            self.Flag_noBadMuons_branch.SetAddress(<void*>&self.Flag_noBadMuons_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "EETauTree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "EETauTree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

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

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "EETauTree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "EETauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "EETauTree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "EETauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCISVVeto20Loose"
        self.bjetCISVVeto20Loose_branch = the_tree.GetBranch("bjetCISVVeto20Loose")
        #if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose" not in self.complained:
        if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose":
            warnings.warn( "EETauTree: Expected branch bjetCISVVeto20Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Loose")
        else:
            self.bjetCISVVeto20Loose_branch.SetAddress(<void*>&self.bjetCISVVeto20Loose_value)

        #print "making bjetCISVVeto20Medium"
        self.bjetCISVVeto20Medium_branch = the_tree.GetBranch("bjetCISVVeto20Medium")
        #if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium" not in self.complained:
        if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium":
            warnings.warn( "EETauTree: Expected branch bjetCISVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Medium")
        else:
            self.bjetCISVVeto20Medium_branch.SetAddress(<void*>&self.bjetCISVVeto20Medium_value)

        #print "making bjetCISVVeto20Tight"
        self.bjetCISVVeto20Tight_branch = the_tree.GetBranch("bjetCISVVeto20Tight")
        #if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight" not in self.complained:
        if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight":
            warnings.warn( "EETauTree: Expected branch bjetCISVVeto20Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Tight")
        else:
            self.bjetCISVVeto20Tight_branch.SetAddress(<void*>&self.bjetCISVVeto20Tight_value)

        #print "making bjetCISVVeto30Loose"
        self.bjetCISVVeto30Loose_branch = the_tree.GetBranch("bjetCISVVeto30Loose")
        #if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose" not in self.complained:
        if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose":
            warnings.warn( "EETauTree: Expected branch bjetCISVVeto30Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Loose")
        else:
            self.bjetCISVVeto30Loose_branch.SetAddress(<void*>&self.bjetCISVVeto30Loose_value)

        #print "making bjetCISVVeto30Medium"
        self.bjetCISVVeto30Medium_branch = the_tree.GetBranch("bjetCISVVeto30Medium")
        #if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium" not in self.complained:
        if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium":
            warnings.warn( "EETauTree: Expected branch bjetCISVVeto30Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Medium")
        else:
            self.bjetCISVVeto30Medium_branch.SetAddress(<void*>&self.bjetCISVVeto30Medium_value)

        #print "making bjetCISVVeto30Tight"
        self.bjetCISVVeto30Tight_branch = the_tree.GetBranch("bjetCISVVeto30Tight")
        #if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight" not in self.complained:
        if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight":
            warnings.warn( "EETauTree: Expected branch bjetCISVVeto30Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Tight")
        else:
            self.bjetCISVVeto30Tight_branch.SetAddress(<void*>&self.bjetCISVVeto30Tight_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "EETauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "EETauTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "EETauTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

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

        #print "making doubleESingleMuGroup"
        self.doubleESingleMuGroup_branch = the_tree.GetBranch("doubleESingleMuGroup")
        #if not self.doubleESingleMuGroup_branch and "doubleESingleMuGroup" not in self.complained:
        if not self.doubleESingleMuGroup_branch and "doubleESingleMuGroup":
            warnings.warn( "EETauTree: Expected branch doubleESingleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuGroup")
        else:
            self.doubleESingleMuGroup_branch.SetAddress(<void*>&self.doubleESingleMuGroup_value)

        #print "making doubleESingleMuPass"
        self.doubleESingleMuPass_branch = the_tree.GetBranch("doubleESingleMuPass")
        #if not self.doubleESingleMuPass_branch and "doubleESingleMuPass" not in self.complained:
        if not self.doubleESingleMuPass_branch and "doubleESingleMuPass":
            warnings.warn( "EETauTree: Expected branch doubleESingleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuPass")
        else:
            self.doubleESingleMuPass_branch.SetAddress(<void*>&self.doubleESingleMuPass_value)

        #print "making doubleESingleMuPrescale"
        self.doubleESingleMuPrescale_branch = the_tree.GetBranch("doubleESingleMuPrescale")
        #if not self.doubleESingleMuPrescale_branch and "doubleESingleMuPrescale" not in self.complained:
        if not self.doubleESingleMuPrescale_branch and "doubleESingleMuPrescale":
            warnings.warn( "EETauTree: Expected branch doubleESingleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuPrescale")
        else:
            self.doubleESingleMuPrescale_branch.SetAddress(<void*>&self.doubleESingleMuPrescale_value)

        #print "making doubleE_23_12Group"
        self.doubleE_23_12Group_branch = the_tree.GetBranch("doubleE_23_12Group")
        #if not self.doubleE_23_12Group_branch and "doubleE_23_12Group" not in self.complained:
        if not self.doubleE_23_12Group_branch and "doubleE_23_12Group":
            warnings.warn( "EETauTree: Expected branch doubleE_23_12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Group")
        else:
            self.doubleE_23_12Group_branch.SetAddress(<void*>&self.doubleE_23_12Group_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "EETauTree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleE_23_12Prescale"
        self.doubleE_23_12Prescale_branch = the_tree.GetBranch("doubleE_23_12Prescale")
        #if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale" not in self.complained:
        if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale":
            warnings.warn( "EETauTree: Expected branch doubleE_23_12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Prescale")
        else:
            self.doubleE_23_12Prescale_branch.SetAddress(<void*>&self.doubleE_23_12Prescale_value)

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

        #print "making doubleMuSingleEGroup"
        self.doubleMuSingleEGroup_branch = the_tree.GetBranch("doubleMuSingleEGroup")
        #if not self.doubleMuSingleEGroup_branch and "doubleMuSingleEGroup" not in self.complained:
        if not self.doubleMuSingleEGroup_branch and "doubleMuSingleEGroup":
            warnings.warn( "EETauTree: Expected branch doubleMuSingleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEGroup")
        else:
            self.doubleMuSingleEGroup_branch.SetAddress(<void*>&self.doubleMuSingleEGroup_value)

        #print "making doubleMuSingleEPass"
        self.doubleMuSingleEPass_branch = the_tree.GetBranch("doubleMuSingleEPass")
        #if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass" not in self.complained:
        if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass":
            warnings.warn( "EETauTree: Expected branch doubleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPass")
        else:
            self.doubleMuSingleEPass_branch.SetAddress(<void*>&self.doubleMuSingleEPass_value)

        #print "making doubleMuSingleEPrescale"
        self.doubleMuSingleEPrescale_branch = the_tree.GetBranch("doubleMuSingleEPrescale")
        #if not self.doubleMuSingleEPrescale_branch and "doubleMuSingleEPrescale" not in self.complained:
        if not self.doubleMuSingleEPrescale_branch and "doubleMuSingleEPrescale":
            warnings.warn( "EETauTree: Expected branch doubleMuSingleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPrescale")
        else:
            self.doubleMuSingleEPrescale_branch.SetAddress(<void*>&self.doubleMuSingleEPrescale_value)

        #print "making doubleTau32Group"
        self.doubleTau32Group_branch = the_tree.GetBranch("doubleTau32Group")
        #if not self.doubleTau32Group_branch and "doubleTau32Group" not in self.complained:
        if not self.doubleTau32Group_branch and "doubleTau32Group":
            warnings.warn( "EETauTree: Expected branch doubleTau32Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau32Group")
        else:
            self.doubleTau32Group_branch.SetAddress(<void*>&self.doubleTau32Group_value)

        #print "making doubleTau32Pass"
        self.doubleTau32Pass_branch = the_tree.GetBranch("doubleTau32Pass")
        #if not self.doubleTau32Pass_branch and "doubleTau32Pass" not in self.complained:
        if not self.doubleTau32Pass_branch and "doubleTau32Pass":
            warnings.warn( "EETauTree: Expected branch doubleTau32Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau32Pass")
        else:
            self.doubleTau32Pass_branch.SetAddress(<void*>&self.doubleTau32Pass_value)

        #print "making doubleTau32Prescale"
        self.doubleTau32Prescale_branch = the_tree.GetBranch("doubleTau32Prescale")
        #if not self.doubleTau32Prescale_branch and "doubleTau32Prescale" not in self.complained:
        if not self.doubleTau32Prescale_branch and "doubleTau32Prescale":
            warnings.warn( "EETauTree: Expected branch doubleTau32Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau32Prescale")
        else:
            self.doubleTau32Prescale_branch.SetAddress(<void*>&self.doubleTau32Prescale_value)

        #print "making doubleTau35Group"
        self.doubleTau35Group_branch = the_tree.GetBranch("doubleTau35Group")
        #if not self.doubleTau35Group_branch and "doubleTau35Group" not in self.complained:
        if not self.doubleTau35Group_branch and "doubleTau35Group":
            warnings.warn( "EETauTree: Expected branch doubleTau35Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Group")
        else:
            self.doubleTau35Group_branch.SetAddress(<void*>&self.doubleTau35Group_value)

        #print "making doubleTau35Pass"
        self.doubleTau35Pass_branch = the_tree.GetBranch("doubleTau35Pass")
        #if not self.doubleTau35Pass_branch and "doubleTau35Pass" not in self.complained:
        if not self.doubleTau35Pass_branch and "doubleTau35Pass":
            warnings.warn( "EETauTree: Expected branch doubleTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Pass")
        else:
            self.doubleTau35Pass_branch.SetAddress(<void*>&self.doubleTau35Pass_value)

        #print "making doubleTau35Prescale"
        self.doubleTau35Prescale_branch = the_tree.GetBranch("doubleTau35Prescale")
        #if not self.doubleTau35Prescale_branch and "doubleTau35Prescale" not in self.complained:
        if not self.doubleTau35Prescale_branch and "doubleTau35Prescale":
            warnings.warn( "EETauTree: Expected branch doubleTau35Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Prescale")
        else:
            self.doubleTau35Prescale_branch.SetAddress(<void*>&self.doubleTau35Prescale_value)

        #print "making doubleTau40Group"
        self.doubleTau40Group_branch = the_tree.GetBranch("doubleTau40Group")
        #if not self.doubleTau40Group_branch and "doubleTau40Group" not in self.complained:
        if not self.doubleTau40Group_branch and "doubleTau40Group":
            warnings.warn( "EETauTree: Expected branch doubleTau40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau40Group")
        else:
            self.doubleTau40Group_branch.SetAddress(<void*>&self.doubleTau40Group_value)

        #print "making doubleTau40Pass"
        self.doubleTau40Pass_branch = the_tree.GetBranch("doubleTau40Pass")
        #if not self.doubleTau40Pass_branch and "doubleTau40Pass" not in self.complained:
        if not self.doubleTau40Pass_branch and "doubleTau40Pass":
            warnings.warn( "EETauTree: Expected branch doubleTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau40Pass")
        else:
            self.doubleTau40Pass_branch.SetAddress(<void*>&self.doubleTau40Pass_value)

        #print "making doubleTau40Prescale"
        self.doubleTau40Prescale_branch = the_tree.GetBranch("doubleTau40Prescale")
        #if not self.doubleTau40Prescale_branch and "doubleTau40Prescale" not in self.complained:
        if not self.doubleTau40Prescale_branch and "doubleTau40Prescale":
            warnings.warn( "EETauTree: Expected branch doubleTau40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau40Prescale")
        else:
            self.doubleTau40Prescale_branch.SetAddress(<void*>&self.doubleTau40Prescale_value)

        #print "making doubleTauCmbIso35RegGroup"
        self.doubleTauCmbIso35RegGroup_branch = the_tree.GetBranch("doubleTauCmbIso35RegGroup")
        #if not self.doubleTauCmbIso35RegGroup_branch and "doubleTauCmbIso35RegGroup" not in self.complained:
        if not self.doubleTauCmbIso35RegGroup_branch and "doubleTauCmbIso35RegGroup":
            warnings.warn( "EETauTree: Expected branch doubleTauCmbIso35RegGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegGroup")
        else:
            self.doubleTauCmbIso35RegGroup_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegGroup_value)

        #print "making doubleTauCmbIso35RegPass"
        self.doubleTauCmbIso35RegPass_branch = the_tree.GetBranch("doubleTauCmbIso35RegPass")
        #if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass" not in self.complained:
        if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass":
            warnings.warn( "EETauTree: Expected branch doubleTauCmbIso35RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPass")
        else:
            self.doubleTauCmbIso35RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPass_value)

        #print "making doubleTauCmbIso35RegPrescale"
        self.doubleTauCmbIso35RegPrescale_branch = the_tree.GetBranch("doubleTauCmbIso35RegPrescale")
        #if not self.doubleTauCmbIso35RegPrescale_branch and "doubleTauCmbIso35RegPrescale" not in self.complained:
        if not self.doubleTauCmbIso35RegPrescale_branch and "doubleTauCmbIso35RegPrescale":
            warnings.warn( "EETauTree: Expected branch doubleTauCmbIso35RegPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPrescale")
        else:
            self.doubleTauCmbIso35RegPrescale_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPrescale_value)

        #print "making doubleTauCmbIso40Group"
        self.doubleTauCmbIso40Group_branch = the_tree.GetBranch("doubleTauCmbIso40Group")
        #if not self.doubleTauCmbIso40Group_branch and "doubleTauCmbIso40Group" not in self.complained:
        if not self.doubleTauCmbIso40Group_branch and "doubleTauCmbIso40Group":
            warnings.warn( "EETauTree: Expected branch doubleTauCmbIso40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40Group")
        else:
            self.doubleTauCmbIso40Group_branch.SetAddress(<void*>&self.doubleTauCmbIso40Group_value)

        #print "making doubleTauCmbIso40Pass"
        self.doubleTauCmbIso40Pass_branch = the_tree.GetBranch("doubleTauCmbIso40Pass")
        #if not self.doubleTauCmbIso40Pass_branch and "doubleTauCmbIso40Pass" not in self.complained:
        if not self.doubleTauCmbIso40Pass_branch and "doubleTauCmbIso40Pass":
            warnings.warn( "EETauTree: Expected branch doubleTauCmbIso40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40Pass")
        else:
            self.doubleTauCmbIso40Pass_branch.SetAddress(<void*>&self.doubleTauCmbIso40Pass_value)

        #print "making doubleTauCmbIso40Prescale"
        self.doubleTauCmbIso40Prescale_branch = the_tree.GetBranch("doubleTauCmbIso40Prescale")
        #if not self.doubleTauCmbIso40Prescale_branch and "doubleTauCmbIso40Prescale" not in self.complained:
        if not self.doubleTauCmbIso40Prescale_branch and "doubleTauCmbIso40Prescale":
            warnings.warn( "EETauTree: Expected branch doubleTauCmbIso40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40Prescale")
        else:
            self.doubleTauCmbIso40Prescale_branch.SetAddress(<void*>&self.doubleTauCmbIso40Prescale_value)

        #print "making doubleTauCmbIso40RegGroup"
        self.doubleTauCmbIso40RegGroup_branch = the_tree.GetBranch("doubleTauCmbIso40RegGroup")
        #if not self.doubleTauCmbIso40RegGroup_branch and "doubleTauCmbIso40RegGroup" not in self.complained:
        if not self.doubleTauCmbIso40RegGroup_branch and "doubleTauCmbIso40RegGroup":
            warnings.warn( "EETauTree: Expected branch doubleTauCmbIso40RegGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40RegGroup")
        else:
            self.doubleTauCmbIso40RegGroup_branch.SetAddress(<void*>&self.doubleTauCmbIso40RegGroup_value)

        #print "making doubleTauCmbIso40RegPass"
        self.doubleTauCmbIso40RegPass_branch = the_tree.GetBranch("doubleTauCmbIso40RegPass")
        #if not self.doubleTauCmbIso40RegPass_branch and "doubleTauCmbIso40RegPass" not in self.complained:
        if not self.doubleTauCmbIso40RegPass_branch and "doubleTauCmbIso40RegPass":
            warnings.warn( "EETauTree: Expected branch doubleTauCmbIso40RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40RegPass")
        else:
            self.doubleTauCmbIso40RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso40RegPass_value)

        #print "making doubleTauCmbIso40RegPrescale"
        self.doubleTauCmbIso40RegPrescale_branch = the_tree.GetBranch("doubleTauCmbIso40RegPrescale")
        #if not self.doubleTauCmbIso40RegPrescale_branch and "doubleTauCmbIso40RegPrescale" not in self.complained:
        if not self.doubleTauCmbIso40RegPrescale_branch and "doubleTauCmbIso40RegPrescale":
            warnings.warn( "EETauTree: Expected branch doubleTauCmbIso40RegPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40RegPrescale")
        else:
            self.doubleTauCmbIso40RegPrescale_branch.SetAddress(<void*>&self.doubleTauCmbIso40RegPrescale_value)

        #print "making e1AbsEta"
        self.e1AbsEta_branch = the_tree.GetBranch("e1AbsEta")
        #if not self.e1AbsEta_branch and "e1AbsEta" not in self.complained:
        if not self.e1AbsEta_branch and "e1AbsEta":
            warnings.warn( "EETauTree: Expected branch e1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1AbsEta")
        else:
            self.e1AbsEta_branch.SetAddress(<void*>&self.e1AbsEta_value)

        #print "making e1CBIDLoose"
        self.e1CBIDLoose_branch = the_tree.GetBranch("e1CBIDLoose")
        #if not self.e1CBIDLoose_branch and "e1CBIDLoose" not in self.complained:
        if not self.e1CBIDLoose_branch and "e1CBIDLoose":
            warnings.warn( "EETauTree: Expected branch e1CBIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBIDLoose")
        else:
            self.e1CBIDLoose_branch.SetAddress(<void*>&self.e1CBIDLoose_value)

        #print "making e1CBIDLooseNoIso"
        self.e1CBIDLooseNoIso_branch = the_tree.GetBranch("e1CBIDLooseNoIso")
        #if not self.e1CBIDLooseNoIso_branch and "e1CBIDLooseNoIso" not in self.complained:
        if not self.e1CBIDLooseNoIso_branch and "e1CBIDLooseNoIso":
            warnings.warn( "EETauTree: Expected branch e1CBIDLooseNoIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBIDLooseNoIso")
        else:
            self.e1CBIDLooseNoIso_branch.SetAddress(<void*>&self.e1CBIDLooseNoIso_value)

        #print "making e1CBIDMedium"
        self.e1CBIDMedium_branch = the_tree.GetBranch("e1CBIDMedium")
        #if not self.e1CBIDMedium_branch and "e1CBIDMedium" not in self.complained:
        if not self.e1CBIDMedium_branch and "e1CBIDMedium":
            warnings.warn( "EETauTree: Expected branch e1CBIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBIDMedium")
        else:
            self.e1CBIDMedium_branch.SetAddress(<void*>&self.e1CBIDMedium_value)

        #print "making e1CBIDMediumNoIso"
        self.e1CBIDMediumNoIso_branch = the_tree.GetBranch("e1CBIDMediumNoIso")
        #if not self.e1CBIDMediumNoIso_branch and "e1CBIDMediumNoIso" not in self.complained:
        if not self.e1CBIDMediumNoIso_branch and "e1CBIDMediumNoIso":
            warnings.warn( "EETauTree: Expected branch e1CBIDMediumNoIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBIDMediumNoIso")
        else:
            self.e1CBIDMediumNoIso_branch.SetAddress(<void*>&self.e1CBIDMediumNoIso_value)

        #print "making e1CBIDTight"
        self.e1CBIDTight_branch = the_tree.GetBranch("e1CBIDTight")
        #if not self.e1CBIDTight_branch and "e1CBIDTight" not in self.complained:
        if not self.e1CBIDTight_branch and "e1CBIDTight":
            warnings.warn( "EETauTree: Expected branch e1CBIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBIDTight")
        else:
            self.e1CBIDTight_branch.SetAddress(<void*>&self.e1CBIDTight_value)

        #print "making e1CBIDTightNoIso"
        self.e1CBIDTightNoIso_branch = the_tree.GetBranch("e1CBIDTightNoIso")
        #if not self.e1CBIDTightNoIso_branch and "e1CBIDTightNoIso" not in self.complained:
        if not self.e1CBIDTightNoIso_branch and "e1CBIDTightNoIso":
            warnings.warn( "EETauTree: Expected branch e1CBIDTightNoIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBIDTightNoIso")
        else:
            self.e1CBIDTightNoIso_branch.SetAddress(<void*>&self.e1CBIDTightNoIso_value)

        #print "making e1CBIDVeto"
        self.e1CBIDVeto_branch = the_tree.GetBranch("e1CBIDVeto")
        #if not self.e1CBIDVeto_branch and "e1CBIDVeto" not in self.complained:
        if not self.e1CBIDVeto_branch and "e1CBIDVeto":
            warnings.warn( "EETauTree: Expected branch e1CBIDVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBIDVeto")
        else:
            self.e1CBIDVeto_branch.SetAddress(<void*>&self.e1CBIDVeto_value)

        #print "making e1CBIDVetoNoIso"
        self.e1CBIDVetoNoIso_branch = the_tree.GetBranch("e1CBIDVetoNoIso")
        #if not self.e1CBIDVetoNoIso_branch and "e1CBIDVetoNoIso" not in self.complained:
        if not self.e1CBIDVetoNoIso_branch and "e1CBIDVetoNoIso":
            warnings.warn( "EETauTree: Expected branch e1CBIDVetoNoIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBIDVetoNoIso")
        else:
            self.e1CBIDVetoNoIso_branch.SetAddress(<void*>&self.e1CBIDVetoNoIso_value)

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

        #print "making e1ComesFromHiggs"
        self.e1ComesFromHiggs_branch = the_tree.GetBranch("e1ComesFromHiggs")
        #if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs" not in self.complained:
        if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs":
            warnings.warn( "EETauTree: Expected branch e1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ComesFromHiggs")
        else:
            self.e1ComesFromHiggs_branch.SetAddress(<void*>&self.e1ComesFromHiggs_value)

        #print "making e1DPhiToPfMet_type1"
        self.e1DPhiToPfMet_type1_branch = the_tree.GetBranch("e1DPhiToPfMet_type1")
        #if not self.e1DPhiToPfMet_type1_branch and "e1DPhiToPfMet_type1" not in self.complained:
        if not self.e1DPhiToPfMet_type1_branch and "e1DPhiToPfMet_type1":
            warnings.warn( "EETauTree: Expected branch e1DPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1DPhiToPfMet_type1")
        else:
            self.e1DPhiToPfMet_type1_branch.SetAddress(<void*>&self.e1DPhiToPfMet_type1_value)

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

        #print "making e1EcalIsoDR03"
        self.e1EcalIsoDR03_branch = the_tree.GetBranch("e1EcalIsoDR03")
        #if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03" not in self.complained:
        if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03":
            warnings.warn( "EETauTree: Expected branch e1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EcalIsoDR03")
        else:
            self.e1EcalIsoDR03_branch.SetAddress(<void*>&self.e1EcalIsoDR03_value)

        #print "making e1EffectiveArea2012Data"
        self.e1EffectiveArea2012Data_branch = the_tree.GetBranch("e1EffectiveArea2012Data")
        #if not self.e1EffectiveArea2012Data_branch and "e1EffectiveArea2012Data" not in self.complained:
        if not self.e1EffectiveArea2012Data_branch and "e1EffectiveArea2012Data":
            warnings.warn( "EETauTree: Expected branch e1EffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EffectiveArea2012Data")
        else:
            self.e1EffectiveArea2012Data_branch.SetAddress(<void*>&self.e1EffectiveArea2012Data_value)

        #print "making e1EffectiveAreaSpring15"
        self.e1EffectiveAreaSpring15_branch = the_tree.GetBranch("e1EffectiveAreaSpring15")
        #if not self.e1EffectiveAreaSpring15_branch and "e1EffectiveAreaSpring15" not in self.complained:
        if not self.e1EffectiveAreaSpring15_branch and "e1EffectiveAreaSpring15":
            warnings.warn( "EETauTree: Expected branch e1EffectiveAreaSpring15 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EffectiveAreaSpring15")
        else:
            self.e1EffectiveAreaSpring15_branch.SetAddress(<void*>&self.e1EffectiveAreaSpring15_value)

        #print "making e1EnergyError"
        self.e1EnergyError_branch = the_tree.GetBranch("e1EnergyError")
        #if not self.e1EnergyError_branch and "e1EnergyError" not in self.complained:
        if not self.e1EnergyError_branch and "e1EnergyError":
            warnings.warn( "EETauTree: Expected branch e1EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyError")
        else:
            self.e1EnergyError_branch.SetAddress(<void*>&self.e1EnergyError_value)

        #print "making e1ErsatzGenEta"
        self.e1ErsatzGenEta_branch = the_tree.GetBranch("e1ErsatzGenEta")
        #if not self.e1ErsatzGenEta_branch and "e1ErsatzGenEta" not in self.complained:
        if not self.e1ErsatzGenEta_branch and "e1ErsatzGenEta":
            warnings.warn( "EETauTree: Expected branch e1ErsatzGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ErsatzGenEta")
        else:
            self.e1ErsatzGenEta_branch.SetAddress(<void*>&self.e1ErsatzGenEta_value)

        #print "making e1ErsatzGenM"
        self.e1ErsatzGenM_branch = the_tree.GetBranch("e1ErsatzGenM")
        #if not self.e1ErsatzGenM_branch and "e1ErsatzGenM" not in self.complained:
        if not self.e1ErsatzGenM_branch and "e1ErsatzGenM":
            warnings.warn( "EETauTree: Expected branch e1ErsatzGenM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ErsatzGenM")
        else:
            self.e1ErsatzGenM_branch.SetAddress(<void*>&self.e1ErsatzGenM_value)

        #print "making e1ErsatzGenPhi"
        self.e1ErsatzGenPhi_branch = the_tree.GetBranch("e1ErsatzGenPhi")
        #if not self.e1ErsatzGenPhi_branch and "e1ErsatzGenPhi" not in self.complained:
        if not self.e1ErsatzGenPhi_branch and "e1ErsatzGenPhi":
            warnings.warn( "EETauTree: Expected branch e1ErsatzGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ErsatzGenPhi")
        else:
            self.e1ErsatzGenPhi_branch.SetAddress(<void*>&self.e1ErsatzGenPhi_value)

        #print "making e1ErsatzGenpT"
        self.e1ErsatzGenpT_branch = the_tree.GetBranch("e1ErsatzGenpT")
        #if not self.e1ErsatzGenpT_branch and "e1ErsatzGenpT" not in self.complained:
        if not self.e1ErsatzGenpT_branch and "e1ErsatzGenpT":
            warnings.warn( "EETauTree: Expected branch e1ErsatzGenpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ErsatzGenpT")
        else:
            self.e1ErsatzGenpT_branch.SetAddress(<void*>&self.e1ErsatzGenpT_value)

        #print "making e1ErsatzGenpX"
        self.e1ErsatzGenpX_branch = the_tree.GetBranch("e1ErsatzGenpX")
        #if not self.e1ErsatzGenpX_branch and "e1ErsatzGenpX" not in self.complained:
        if not self.e1ErsatzGenpX_branch and "e1ErsatzGenpX":
            warnings.warn( "EETauTree: Expected branch e1ErsatzGenpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ErsatzGenpX")
        else:
            self.e1ErsatzGenpX_branch.SetAddress(<void*>&self.e1ErsatzGenpX_value)

        #print "making e1ErsatzGenpY"
        self.e1ErsatzGenpY_branch = the_tree.GetBranch("e1ErsatzGenpY")
        #if not self.e1ErsatzGenpY_branch and "e1ErsatzGenpY" not in self.complained:
        if not self.e1ErsatzGenpY_branch and "e1ErsatzGenpY":
            warnings.warn( "EETauTree: Expected branch e1ErsatzGenpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ErsatzGenpY")
        else:
            self.e1ErsatzGenpY_branch.SetAddress(<void*>&self.e1ErsatzGenpY_value)

        #print "making e1ErsatzVispX"
        self.e1ErsatzVispX_branch = the_tree.GetBranch("e1ErsatzVispX")
        #if not self.e1ErsatzVispX_branch and "e1ErsatzVispX" not in self.complained:
        if not self.e1ErsatzVispX_branch and "e1ErsatzVispX":
            warnings.warn( "EETauTree: Expected branch e1ErsatzVispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ErsatzVispX")
        else:
            self.e1ErsatzVispX_branch.SetAddress(<void*>&self.e1ErsatzVispX_value)

        #print "making e1ErsatzVispY"
        self.e1ErsatzVispY_branch = the_tree.GetBranch("e1ErsatzVispY")
        #if not self.e1ErsatzVispY_branch and "e1ErsatzVispY" not in self.complained:
        if not self.e1ErsatzVispY_branch and "e1ErsatzVispY":
            warnings.warn( "EETauTree: Expected branch e1ErsatzVispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ErsatzVispY")
        else:
            self.e1ErsatzVispY_branch.SetAddress(<void*>&self.e1ErsatzVispY_value)

        #print "making e1Eta"
        self.e1Eta_branch = the_tree.GetBranch("e1Eta")
        #if not self.e1Eta_branch and "e1Eta" not in self.complained:
        if not self.e1Eta_branch and "e1Eta":
            warnings.warn( "EETauTree: Expected branch e1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Eta")
        else:
            self.e1Eta_branch.SetAddress(<void*>&self.e1Eta_value)

        #print "making e1Eta_ElectronEnDown"
        self.e1Eta_ElectronEnDown_branch = the_tree.GetBranch("e1Eta_ElectronEnDown")
        #if not self.e1Eta_ElectronEnDown_branch and "e1Eta_ElectronEnDown" not in self.complained:
        if not self.e1Eta_ElectronEnDown_branch and "e1Eta_ElectronEnDown":
            warnings.warn( "EETauTree: Expected branch e1Eta_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Eta_ElectronEnDown")
        else:
            self.e1Eta_ElectronEnDown_branch.SetAddress(<void*>&self.e1Eta_ElectronEnDown_value)

        #print "making e1Eta_ElectronEnUp"
        self.e1Eta_ElectronEnUp_branch = the_tree.GetBranch("e1Eta_ElectronEnUp")
        #if not self.e1Eta_ElectronEnUp_branch and "e1Eta_ElectronEnUp" not in self.complained:
        if not self.e1Eta_ElectronEnUp_branch and "e1Eta_ElectronEnUp":
            warnings.warn( "EETauTree: Expected branch e1Eta_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Eta_ElectronEnUp")
        else:
            self.e1Eta_ElectronEnUp_branch.SetAddress(<void*>&self.e1Eta_ElectronEnUp_value)

        #print "making e1GenCharge"
        self.e1GenCharge_branch = the_tree.GetBranch("e1GenCharge")
        #if not self.e1GenCharge_branch and "e1GenCharge" not in self.complained:
        if not self.e1GenCharge_branch and "e1GenCharge":
            warnings.warn( "EETauTree: Expected branch e1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenCharge")
        else:
            self.e1GenCharge_branch.SetAddress(<void*>&self.e1GenCharge_value)

        #print "making e1GenDirectPromptTauDecay"
        self.e1GenDirectPromptTauDecay_branch = the_tree.GetBranch("e1GenDirectPromptTauDecay")
        #if not self.e1GenDirectPromptTauDecay_branch and "e1GenDirectPromptTauDecay" not in self.complained:
        if not self.e1GenDirectPromptTauDecay_branch and "e1GenDirectPromptTauDecay":
            warnings.warn( "EETauTree: Expected branch e1GenDirectPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenDirectPromptTauDecay")
        else:
            self.e1GenDirectPromptTauDecay_branch.SetAddress(<void*>&self.e1GenDirectPromptTauDecay_value)

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

        #print "making e1GenIsPrompt"
        self.e1GenIsPrompt_branch = the_tree.GetBranch("e1GenIsPrompt")
        #if not self.e1GenIsPrompt_branch and "e1GenIsPrompt" not in self.complained:
        if not self.e1GenIsPrompt_branch and "e1GenIsPrompt":
            warnings.warn( "EETauTree: Expected branch e1GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenIsPrompt")
        else:
            self.e1GenIsPrompt_branch.SetAddress(<void*>&self.e1GenIsPrompt_value)

        #print "making e1GenMotherPdgId"
        self.e1GenMotherPdgId_branch = the_tree.GetBranch("e1GenMotherPdgId")
        #if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId" not in self.complained:
        if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId":
            warnings.warn( "EETauTree: Expected branch e1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenMotherPdgId")
        else:
            self.e1GenMotherPdgId_branch.SetAddress(<void*>&self.e1GenMotherPdgId_value)

        #print "making e1GenParticle"
        self.e1GenParticle_branch = the_tree.GetBranch("e1GenParticle")
        #if not self.e1GenParticle_branch and "e1GenParticle" not in self.complained:
        if not self.e1GenParticle_branch and "e1GenParticle":
            warnings.warn( "EETauTree: Expected branch e1GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenParticle")
        else:
            self.e1GenParticle_branch.SetAddress(<void*>&self.e1GenParticle_value)

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

        #print "making e1GenPrompt"
        self.e1GenPrompt_branch = the_tree.GetBranch("e1GenPrompt")
        #if not self.e1GenPrompt_branch and "e1GenPrompt" not in self.complained:
        if not self.e1GenPrompt_branch and "e1GenPrompt":
            warnings.warn( "EETauTree: Expected branch e1GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPrompt")
        else:
            self.e1GenPrompt_branch.SetAddress(<void*>&self.e1GenPrompt_value)

        #print "making e1GenPromptTauDecay"
        self.e1GenPromptTauDecay_branch = the_tree.GetBranch("e1GenPromptTauDecay")
        #if not self.e1GenPromptTauDecay_branch and "e1GenPromptTauDecay" not in self.complained:
        if not self.e1GenPromptTauDecay_branch and "e1GenPromptTauDecay":
            warnings.warn( "EETauTree: Expected branch e1GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPromptTauDecay")
        else:
            self.e1GenPromptTauDecay_branch.SetAddress(<void*>&self.e1GenPromptTauDecay_value)

        #print "making e1GenPt"
        self.e1GenPt_branch = the_tree.GetBranch("e1GenPt")
        #if not self.e1GenPt_branch and "e1GenPt" not in self.complained:
        if not self.e1GenPt_branch and "e1GenPt":
            warnings.warn( "EETauTree: Expected branch e1GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPt")
        else:
            self.e1GenPt_branch.SetAddress(<void*>&self.e1GenPt_value)

        #print "making e1GenTauDecay"
        self.e1GenTauDecay_branch = the_tree.GetBranch("e1GenTauDecay")
        #if not self.e1GenTauDecay_branch and "e1GenTauDecay" not in self.complained:
        if not self.e1GenTauDecay_branch and "e1GenTauDecay":
            warnings.warn( "EETauTree: Expected branch e1GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenTauDecay")
        else:
            self.e1GenTauDecay_branch.SetAddress(<void*>&self.e1GenTauDecay_value)

        #print "making e1GenVZ"
        self.e1GenVZ_branch = the_tree.GetBranch("e1GenVZ")
        #if not self.e1GenVZ_branch and "e1GenVZ" not in self.complained:
        if not self.e1GenVZ_branch and "e1GenVZ":
            warnings.warn( "EETauTree: Expected branch e1GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenVZ")
        else:
            self.e1GenVZ_branch.SetAddress(<void*>&self.e1GenVZ_value)

        #print "making e1GenVtxPVMatch"
        self.e1GenVtxPVMatch_branch = the_tree.GetBranch("e1GenVtxPVMatch")
        #if not self.e1GenVtxPVMatch_branch and "e1GenVtxPVMatch" not in self.complained:
        if not self.e1GenVtxPVMatch_branch and "e1GenVtxPVMatch":
            warnings.warn( "EETauTree: Expected branch e1GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenVtxPVMatch")
        else:
            self.e1GenVtxPVMatch_branch.SetAddress(<void*>&self.e1GenVtxPVMatch_value)

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

        #print "making e1HcalIsoDR03"
        self.e1HcalIsoDR03_branch = the_tree.GetBranch("e1HcalIsoDR03")
        #if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03" not in self.complained:
        if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03":
            warnings.warn( "EETauTree: Expected branch e1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HcalIsoDR03")
        else:
            self.e1HcalIsoDR03_branch.SetAddress(<void*>&self.e1HcalIsoDR03_value)

        #print "making e1IP3D"
        self.e1IP3D_branch = the_tree.GetBranch("e1IP3D")
        #if not self.e1IP3D_branch and "e1IP3D" not in self.complained:
        if not self.e1IP3D_branch and "e1IP3D":
            warnings.warn( "EETauTree: Expected branch e1IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IP3D")
        else:
            self.e1IP3D_branch.SetAddress(<void*>&self.e1IP3D_value)

        #print "making e1IP3DErr"
        self.e1IP3DErr_branch = the_tree.GetBranch("e1IP3DErr")
        #if not self.e1IP3DErr_branch and "e1IP3DErr" not in self.complained:
        if not self.e1IP3DErr_branch and "e1IP3DErr":
            warnings.warn( "EETauTree: Expected branch e1IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IP3DErr")
        else:
            self.e1IP3DErr_branch.SetAddress(<void*>&self.e1IP3DErr_value)

        #print "making e1IsoDB03"
        self.e1IsoDB03_branch = the_tree.GetBranch("e1IsoDB03")
        #if not self.e1IsoDB03_branch and "e1IsoDB03" not in self.complained:
        if not self.e1IsoDB03_branch and "e1IsoDB03":
            warnings.warn( "EETauTree: Expected branch e1IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IsoDB03")
        else:
            self.e1IsoDB03_branch.SetAddress(<void*>&self.e1IsoDB03_value)

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

        #print "making e1JetHadronFlavour"
        self.e1JetHadronFlavour_branch = the_tree.GetBranch("e1JetHadronFlavour")
        #if not self.e1JetHadronFlavour_branch and "e1JetHadronFlavour" not in self.complained:
        if not self.e1JetHadronFlavour_branch and "e1JetHadronFlavour":
            warnings.warn( "EETauTree: Expected branch e1JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetHadronFlavour")
        else:
            self.e1JetHadronFlavour_branch.SetAddress(<void*>&self.e1JetHadronFlavour_value)

        #print "making e1JetPFCISVBtag"
        self.e1JetPFCISVBtag_branch = the_tree.GetBranch("e1JetPFCISVBtag")
        #if not self.e1JetPFCISVBtag_branch and "e1JetPFCISVBtag" not in self.complained:
        if not self.e1JetPFCISVBtag_branch and "e1JetPFCISVBtag":
            warnings.warn( "EETauTree: Expected branch e1JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPFCISVBtag")
        else:
            self.e1JetPFCISVBtag_branch.SetAddress(<void*>&self.e1JetPFCISVBtag_value)

        #print "making e1JetPartonFlavour"
        self.e1JetPartonFlavour_branch = the_tree.GetBranch("e1JetPartonFlavour")
        #if not self.e1JetPartonFlavour_branch and "e1JetPartonFlavour" not in self.complained:
        if not self.e1JetPartonFlavour_branch and "e1JetPartonFlavour":
            warnings.warn( "EETauTree: Expected branch e1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPartonFlavour")
        else:
            self.e1JetPartonFlavour_branch.SetAddress(<void*>&self.e1JetPartonFlavour_value)

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

        #print "making e1LowestMll"
        self.e1LowestMll_branch = the_tree.GetBranch("e1LowestMll")
        #if not self.e1LowestMll_branch and "e1LowestMll" not in self.complained:
        if not self.e1LowestMll_branch and "e1LowestMll":
            warnings.warn( "EETauTree: Expected branch e1LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1LowestMll")
        else:
            self.e1LowestMll_branch.SetAddress(<void*>&self.e1LowestMll_value)

        #print "making e1MVANonTrigCategory"
        self.e1MVANonTrigCategory_branch = the_tree.GetBranch("e1MVANonTrigCategory")
        #if not self.e1MVANonTrigCategory_branch and "e1MVANonTrigCategory" not in self.complained:
        if not self.e1MVANonTrigCategory_branch and "e1MVANonTrigCategory":
            warnings.warn( "EETauTree: Expected branch e1MVANonTrigCategory does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANonTrigCategory")
        else:
            self.e1MVANonTrigCategory_branch.SetAddress(<void*>&self.e1MVANonTrigCategory_value)

        #print "making e1MVANonTrigID"
        self.e1MVANonTrigID_branch = the_tree.GetBranch("e1MVANonTrigID")
        #if not self.e1MVANonTrigID_branch and "e1MVANonTrigID" not in self.complained:
        if not self.e1MVANonTrigID_branch and "e1MVANonTrigID":
            warnings.warn( "EETauTree: Expected branch e1MVANonTrigID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANonTrigID")
        else:
            self.e1MVANonTrigID_branch.SetAddress(<void*>&self.e1MVANonTrigID_value)

        #print "making e1MVANonTrigWP80"
        self.e1MVANonTrigWP80_branch = the_tree.GetBranch("e1MVANonTrigWP80")
        #if not self.e1MVANonTrigWP80_branch and "e1MVANonTrigWP80" not in self.complained:
        if not self.e1MVANonTrigWP80_branch and "e1MVANonTrigWP80":
            warnings.warn( "EETauTree: Expected branch e1MVANonTrigWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANonTrigWP80")
        else:
            self.e1MVANonTrigWP80_branch.SetAddress(<void*>&self.e1MVANonTrigWP80_value)

        #print "making e1MVANonTrigWP90"
        self.e1MVANonTrigWP90_branch = the_tree.GetBranch("e1MVANonTrigWP90")
        #if not self.e1MVANonTrigWP90_branch and "e1MVANonTrigWP90" not in self.complained:
        if not self.e1MVANonTrigWP90_branch and "e1MVANonTrigWP90":
            warnings.warn( "EETauTree: Expected branch e1MVANonTrigWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANonTrigWP90")
        else:
            self.e1MVANonTrigWP90_branch.SetAddress(<void*>&self.e1MVANonTrigWP90_value)

        #print "making e1MVATrigCategory"
        self.e1MVATrigCategory_branch = the_tree.GetBranch("e1MVATrigCategory")
        #if not self.e1MVATrigCategory_branch and "e1MVATrigCategory" not in self.complained:
        if not self.e1MVATrigCategory_branch and "e1MVATrigCategory":
            warnings.warn( "EETauTree: Expected branch e1MVATrigCategory does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigCategory")
        else:
            self.e1MVATrigCategory_branch.SetAddress(<void*>&self.e1MVATrigCategory_value)

        #print "making e1MVATrigID"
        self.e1MVATrigID_branch = the_tree.GetBranch("e1MVATrigID")
        #if not self.e1MVATrigID_branch and "e1MVATrigID" not in self.complained:
        if not self.e1MVATrigID_branch and "e1MVATrigID":
            warnings.warn( "EETauTree: Expected branch e1MVATrigID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigID")
        else:
            self.e1MVATrigID_branch.SetAddress(<void*>&self.e1MVATrigID_value)

        #print "making e1MVATrigWP80"
        self.e1MVATrigWP80_branch = the_tree.GetBranch("e1MVATrigWP80")
        #if not self.e1MVATrigWP80_branch and "e1MVATrigWP80" not in self.complained:
        if not self.e1MVATrigWP80_branch and "e1MVATrigWP80":
            warnings.warn( "EETauTree: Expected branch e1MVATrigWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigWP80")
        else:
            self.e1MVATrigWP80_branch.SetAddress(<void*>&self.e1MVATrigWP80_value)

        #print "making e1MVATrigWP90"
        self.e1MVATrigWP90_branch = the_tree.GetBranch("e1MVATrigWP90")
        #if not self.e1MVATrigWP90_branch and "e1MVATrigWP90" not in self.complained:
        if not self.e1MVATrigWP90_branch and "e1MVATrigWP90":
            warnings.warn( "EETauTree: Expected branch e1MVATrigWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigWP90")
        else:
            self.e1MVATrigWP90_branch.SetAddress(<void*>&self.e1MVATrigWP90_value)

        #print "making e1Mass"
        self.e1Mass_branch = the_tree.GetBranch("e1Mass")
        #if not self.e1Mass_branch and "e1Mass" not in self.complained:
        if not self.e1Mass_branch and "e1Mass":
            warnings.warn( "EETauTree: Expected branch e1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mass")
        else:
            self.e1Mass_branch.SetAddress(<void*>&self.e1Mass_value)

        #print "making e1MatchesDoubleE"
        self.e1MatchesDoubleE_branch = the_tree.GetBranch("e1MatchesDoubleE")
        #if not self.e1MatchesDoubleE_branch and "e1MatchesDoubleE" not in self.complained:
        if not self.e1MatchesDoubleE_branch and "e1MatchesDoubleE":
            warnings.warn( "EETauTree: Expected branch e1MatchesDoubleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesDoubleE")
        else:
            self.e1MatchesDoubleE_branch.SetAddress(<void*>&self.e1MatchesDoubleE_value)

        #print "making e1MatchesDoubleESingleMu"
        self.e1MatchesDoubleESingleMu_branch = the_tree.GetBranch("e1MatchesDoubleESingleMu")
        #if not self.e1MatchesDoubleESingleMu_branch and "e1MatchesDoubleESingleMu" not in self.complained:
        if not self.e1MatchesDoubleESingleMu_branch and "e1MatchesDoubleESingleMu":
            warnings.warn( "EETauTree: Expected branch e1MatchesDoubleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesDoubleESingleMu")
        else:
            self.e1MatchesDoubleESingleMu_branch.SetAddress(<void*>&self.e1MatchesDoubleESingleMu_value)

        #print "making e1MatchesDoubleMuSingleE"
        self.e1MatchesDoubleMuSingleE_branch = the_tree.GetBranch("e1MatchesDoubleMuSingleE")
        #if not self.e1MatchesDoubleMuSingleE_branch and "e1MatchesDoubleMuSingleE" not in self.complained:
        if not self.e1MatchesDoubleMuSingleE_branch and "e1MatchesDoubleMuSingleE":
            warnings.warn( "EETauTree: Expected branch e1MatchesDoubleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesDoubleMuSingleE")
        else:
            self.e1MatchesDoubleMuSingleE_branch.SetAddress(<void*>&self.e1MatchesDoubleMuSingleE_value)

        #print "making e1MatchesEle115Filter"
        self.e1MatchesEle115Filter_branch = the_tree.GetBranch("e1MatchesEle115Filter")
        #if not self.e1MatchesEle115Filter_branch and "e1MatchesEle115Filter" not in self.complained:
        if not self.e1MatchesEle115Filter_branch and "e1MatchesEle115Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle115Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle115Filter")
        else:
            self.e1MatchesEle115Filter_branch.SetAddress(<void*>&self.e1MatchesEle115Filter_value)

        #print "making e1MatchesEle115Path"
        self.e1MatchesEle115Path_branch = the_tree.GetBranch("e1MatchesEle115Path")
        #if not self.e1MatchesEle115Path_branch and "e1MatchesEle115Path" not in self.complained:
        if not self.e1MatchesEle115Path_branch and "e1MatchesEle115Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle115Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle115Path")
        else:
            self.e1MatchesEle115Path_branch.SetAddress(<void*>&self.e1MatchesEle115Path_value)

        #print "making e1MatchesEle24Tau20Filter"
        self.e1MatchesEle24Tau20Filter_branch = the_tree.GetBranch("e1MatchesEle24Tau20Filter")
        #if not self.e1MatchesEle24Tau20Filter_branch and "e1MatchesEle24Tau20Filter" not in self.complained:
        if not self.e1MatchesEle24Tau20Filter_branch and "e1MatchesEle24Tau20Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle24Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24Tau20Filter")
        else:
            self.e1MatchesEle24Tau20Filter_branch.SetAddress(<void*>&self.e1MatchesEle24Tau20Filter_value)

        #print "making e1MatchesEle24Tau20Path"
        self.e1MatchesEle24Tau20Path_branch = the_tree.GetBranch("e1MatchesEle24Tau20Path")
        #if not self.e1MatchesEle24Tau20Path_branch and "e1MatchesEle24Tau20Path" not in self.complained:
        if not self.e1MatchesEle24Tau20Path_branch and "e1MatchesEle24Tau20Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle24Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24Tau20Path")
        else:
            self.e1MatchesEle24Tau20Path_branch.SetAddress(<void*>&self.e1MatchesEle24Tau20Path_value)

        #print "making e1MatchesEle24Tau20sL1Filter"
        self.e1MatchesEle24Tau20sL1Filter_branch = the_tree.GetBranch("e1MatchesEle24Tau20sL1Filter")
        #if not self.e1MatchesEle24Tau20sL1Filter_branch and "e1MatchesEle24Tau20sL1Filter" not in self.complained:
        if not self.e1MatchesEle24Tau20sL1Filter_branch and "e1MatchesEle24Tau20sL1Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle24Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24Tau20sL1Filter")
        else:
            self.e1MatchesEle24Tau20sL1Filter_branch.SetAddress(<void*>&self.e1MatchesEle24Tau20sL1Filter_value)

        #print "making e1MatchesEle24Tau20sL1Path"
        self.e1MatchesEle24Tau20sL1Path_branch = the_tree.GetBranch("e1MatchesEle24Tau20sL1Path")
        #if not self.e1MatchesEle24Tau20sL1Path_branch and "e1MatchesEle24Tau20sL1Path" not in self.complained:
        if not self.e1MatchesEle24Tau20sL1Path_branch and "e1MatchesEle24Tau20sL1Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle24Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24Tau20sL1Path")
        else:
            self.e1MatchesEle24Tau20sL1Path_branch.SetAddress(<void*>&self.e1MatchesEle24Tau20sL1Path_value)

        #print "making e1MatchesEle24Tau30Filter"
        self.e1MatchesEle24Tau30Filter_branch = the_tree.GetBranch("e1MatchesEle24Tau30Filter")
        #if not self.e1MatchesEle24Tau30Filter_branch and "e1MatchesEle24Tau30Filter" not in self.complained:
        if not self.e1MatchesEle24Tau30Filter_branch and "e1MatchesEle24Tau30Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24Tau30Filter")
        else:
            self.e1MatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.e1MatchesEle24Tau30Filter_value)

        #print "making e1MatchesEle24Tau30Path"
        self.e1MatchesEle24Tau30Path_branch = the_tree.GetBranch("e1MatchesEle24Tau30Path")
        #if not self.e1MatchesEle24Tau30Path_branch and "e1MatchesEle24Tau30Path" not in self.complained:
        if not self.e1MatchesEle24Tau30Path_branch and "e1MatchesEle24Tau30Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24Tau30Path")
        else:
            self.e1MatchesEle24Tau30Path_branch.SetAddress(<void*>&self.e1MatchesEle24Tau30Path_value)

        #print "making e1MatchesEle25LooseFilter"
        self.e1MatchesEle25LooseFilter_branch = the_tree.GetBranch("e1MatchesEle25LooseFilter")
        #if not self.e1MatchesEle25LooseFilter_branch and "e1MatchesEle25LooseFilter" not in self.complained:
        if not self.e1MatchesEle25LooseFilter_branch and "e1MatchesEle25LooseFilter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle25LooseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle25LooseFilter")
        else:
            self.e1MatchesEle25LooseFilter_branch.SetAddress(<void*>&self.e1MatchesEle25LooseFilter_value)

        #print "making e1MatchesEle25TightFilter"
        self.e1MatchesEle25TightFilter_branch = the_tree.GetBranch("e1MatchesEle25TightFilter")
        #if not self.e1MatchesEle25TightFilter_branch and "e1MatchesEle25TightFilter" not in self.complained:
        if not self.e1MatchesEle25TightFilter_branch and "e1MatchesEle25TightFilter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle25TightFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle25TightFilter")
        else:
            self.e1MatchesEle25TightFilter_branch.SetAddress(<void*>&self.e1MatchesEle25TightFilter_value)

        #print "making e1MatchesEle25eta2p1TightFilter"
        self.e1MatchesEle25eta2p1TightFilter_branch = the_tree.GetBranch("e1MatchesEle25eta2p1TightFilter")
        #if not self.e1MatchesEle25eta2p1TightFilter_branch and "e1MatchesEle25eta2p1TightFilter" not in self.complained:
        if not self.e1MatchesEle25eta2p1TightFilter_branch and "e1MatchesEle25eta2p1TightFilter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle25eta2p1TightFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle25eta2p1TightFilter")
        else:
            self.e1MatchesEle25eta2p1TightFilter_branch.SetAddress(<void*>&self.e1MatchesEle25eta2p1TightFilter_value)

        #print "making e1MatchesEle25eta2p1TightPath"
        self.e1MatchesEle25eta2p1TightPath_branch = the_tree.GetBranch("e1MatchesEle25eta2p1TightPath")
        #if not self.e1MatchesEle25eta2p1TightPath_branch and "e1MatchesEle25eta2p1TightPath" not in self.complained:
        if not self.e1MatchesEle25eta2p1TightPath_branch and "e1MatchesEle25eta2p1TightPath":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle25eta2p1TightPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle25eta2p1TightPath")
        else:
            self.e1MatchesEle25eta2p1TightPath_branch.SetAddress(<void*>&self.e1MatchesEle25eta2p1TightPath_value)

        #print "making e1MatchesEle27TightFilter"
        self.e1MatchesEle27TightFilter_branch = the_tree.GetBranch("e1MatchesEle27TightFilter")
        #if not self.e1MatchesEle27TightFilter_branch and "e1MatchesEle27TightFilter" not in self.complained:
        if not self.e1MatchesEle27TightFilter_branch and "e1MatchesEle27TightFilter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle27TightFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle27TightFilter")
        else:
            self.e1MatchesEle27TightFilter_branch.SetAddress(<void*>&self.e1MatchesEle27TightFilter_value)

        #print "making e1MatchesEle27TightPath"
        self.e1MatchesEle27TightPath_branch = the_tree.GetBranch("e1MatchesEle27TightPath")
        #if not self.e1MatchesEle27TightPath_branch and "e1MatchesEle27TightPath" not in self.complained:
        if not self.e1MatchesEle27TightPath_branch and "e1MatchesEle27TightPath":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle27TightPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle27TightPath")
        else:
            self.e1MatchesEle27TightPath_branch.SetAddress(<void*>&self.e1MatchesEle27TightPath_value)

        #print "making e1MatchesEle27eta2p1LooseFilter"
        self.e1MatchesEle27eta2p1LooseFilter_branch = the_tree.GetBranch("e1MatchesEle27eta2p1LooseFilter")
        #if not self.e1MatchesEle27eta2p1LooseFilter_branch and "e1MatchesEle27eta2p1LooseFilter" not in self.complained:
        if not self.e1MatchesEle27eta2p1LooseFilter_branch and "e1MatchesEle27eta2p1LooseFilter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle27eta2p1LooseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle27eta2p1LooseFilter")
        else:
            self.e1MatchesEle27eta2p1LooseFilter_branch.SetAddress(<void*>&self.e1MatchesEle27eta2p1LooseFilter_value)

        #print "making e1MatchesEle27eta2p1LoosePath"
        self.e1MatchesEle27eta2p1LoosePath_branch = the_tree.GetBranch("e1MatchesEle27eta2p1LoosePath")
        #if not self.e1MatchesEle27eta2p1LoosePath_branch and "e1MatchesEle27eta2p1LoosePath" not in self.complained:
        if not self.e1MatchesEle27eta2p1LoosePath_branch and "e1MatchesEle27eta2p1LoosePath":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle27eta2p1LoosePath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle27eta2p1LoosePath")
        else:
            self.e1MatchesEle27eta2p1LoosePath_branch.SetAddress(<void*>&self.e1MatchesEle27eta2p1LoosePath_value)

        #print "making e1MatchesEle45L1JetTauPath"
        self.e1MatchesEle45L1JetTauPath_branch = the_tree.GetBranch("e1MatchesEle45L1JetTauPath")
        #if not self.e1MatchesEle45L1JetTauPath_branch and "e1MatchesEle45L1JetTauPath" not in self.complained:
        if not self.e1MatchesEle45L1JetTauPath_branch and "e1MatchesEle45L1JetTauPath":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle45L1JetTauPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle45L1JetTauPath")
        else:
            self.e1MatchesEle45L1JetTauPath_branch.SetAddress(<void*>&self.e1MatchesEle45L1JetTauPath_value)

        #print "making e1MatchesEle45LooseL1JetTauFilter"
        self.e1MatchesEle45LooseL1JetTauFilter_branch = the_tree.GetBranch("e1MatchesEle45LooseL1JetTauFilter")
        #if not self.e1MatchesEle45LooseL1JetTauFilter_branch and "e1MatchesEle45LooseL1JetTauFilter" not in self.complained:
        if not self.e1MatchesEle45LooseL1JetTauFilter_branch and "e1MatchesEle45LooseL1JetTauFilter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle45LooseL1JetTauFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle45LooseL1JetTauFilter")
        else:
            self.e1MatchesEle45LooseL1JetTauFilter_branch.SetAddress(<void*>&self.e1MatchesEle45LooseL1JetTauFilter_value)

        #print "making e1MatchesMu23Ele12DZFilter"
        self.e1MatchesMu23Ele12DZFilter_branch = the_tree.GetBranch("e1MatchesMu23Ele12DZFilter")
        #if not self.e1MatchesMu23Ele12DZFilter_branch and "e1MatchesMu23Ele12DZFilter" not in self.complained:
        if not self.e1MatchesMu23Ele12DZFilter_branch and "e1MatchesMu23Ele12DZFilter":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu23Ele12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23Ele12DZFilter")
        else:
            self.e1MatchesMu23Ele12DZFilter_branch.SetAddress(<void*>&self.e1MatchesMu23Ele12DZFilter_value)

        #print "making e1MatchesMu23Ele12DZPath"
        self.e1MatchesMu23Ele12DZPath_branch = the_tree.GetBranch("e1MatchesMu23Ele12DZPath")
        #if not self.e1MatchesMu23Ele12DZPath_branch and "e1MatchesMu23Ele12DZPath" not in self.complained:
        if not self.e1MatchesMu23Ele12DZPath_branch and "e1MatchesMu23Ele12DZPath":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu23Ele12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23Ele12DZPath")
        else:
            self.e1MatchesMu23Ele12DZPath_branch.SetAddress(<void*>&self.e1MatchesMu23Ele12DZPath_value)

        #print "making e1MatchesMu23Ele12Filter"
        self.e1MatchesMu23Ele12Filter_branch = the_tree.GetBranch("e1MatchesMu23Ele12Filter")
        #if not self.e1MatchesMu23Ele12Filter_branch and "e1MatchesMu23Ele12Filter" not in self.complained:
        if not self.e1MatchesMu23Ele12Filter_branch and "e1MatchesMu23Ele12Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu23Ele12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23Ele12Filter")
        else:
            self.e1MatchesMu23Ele12Filter_branch.SetAddress(<void*>&self.e1MatchesMu23Ele12Filter_value)

        #print "making e1MatchesMu23Ele12Path"
        self.e1MatchesMu23Ele12Path_branch = the_tree.GetBranch("e1MatchesMu23Ele12Path")
        #if not self.e1MatchesMu23Ele12Path_branch and "e1MatchesMu23Ele12Path" not in self.complained:
        if not self.e1MatchesMu23Ele12Path_branch and "e1MatchesMu23Ele12Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu23Ele12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23Ele12Path")
        else:
            self.e1MatchesMu23Ele12Path_branch.SetAddress(<void*>&self.e1MatchesMu23Ele12Path_value)

        #print "making e1MatchesMu23Ele8DZFilter"
        self.e1MatchesMu23Ele8DZFilter_branch = the_tree.GetBranch("e1MatchesMu23Ele8DZFilter")
        #if not self.e1MatchesMu23Ele8DZFilter_branch and "e1MatchesMu23Ele8DZFilter" not in self.complained:
        if not self.e1MatchesMu23Ele8DZFilter_branch and "e1MatchesMu23Ele8DZFilter":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu23Ele8DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23Ele8DZFilter")
        else:
            self.e1MatchesMu23Ele8DZFilter_branch.SetAddress(<void*>&self.e1MatchesMu23Ele8DZFilter_value)

        #print "making e1MatchesMu23Ele8DZPath"
        self.e1MatchesMu23Ele8DZPath_branch = the_tree.GetBranch("e1MatchesMu23Ele8DZPath")
        #if not self.e1MatchesMu23Ele8DZPath_branch and "e1MatchesMu23Ele8DZPath" not in self.complained:
        if not self.e1MatchesMu23Ele8DZPath_branch and "e1MatchesMu23Ele8DZPath":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu23Ele8DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23Ele8DZPath")
        else:
            self.e1MatchesMu23Ele8DZPath_branch.SetAddress(<void*>&self.e1MatchesMu23Ele8DZPath_value)

        #print "making e1MatchesMu23Ele8Filter"
        self.e1MatchesMu23Ele8Filter_branch = the_tree.GetBranch("e1MatchesMu23Ele8Filter")
        #if not self.e1MatchesMu23Ele8Filter_branch and "e1MatchesMu23Ele8Filter" not in self.complained:
        if not self.e1MatchesMu23Ele8Filter_branch and "e1MatchesMu23Ele8Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu23Ele8Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23Ele8Filter")
        else:
            self.e1MatchesMu23Ele8Filter_branch.SetAddress(<void*>&self.e1MatchesMu23Ele8Filter_value)

        #print "making e1MatchesMu23Ele8Path"
        self.e1MatchesMu23Ele8Path_branch = the_tree.GetBranch("e1MatchesMu23Ele8Path")
        #if not self.e1MatchesMu23Ele8Path_branch and "e1MatchesMu23Ele8Path" not in self.complained:
        if not self.e1MatchesMu23Ele8Path_branch and "e1MatchesMu23Ele8Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu23Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23Ele8Path")
        else:
            self.e1MatchesMu23Ele8Path_branch.SetAddress(<void*>&self.e1MatchesMu23Ele8Path_value)

        #print "making e1MatchesMu8Ele23DZFilter"
        self.e1MatchesMu8Ele23DZFilter_branch = the_tree.GetBranch("e1MatchesMu8Ele23DZFilter")
        #if not self.e1MatchesMu8Ele23DZFilter_branch and "e1MatchesMu8Ele23DZFilter" not in self.complained:
        if not self.e1MatchesMu8Ele23DZFilter_branch and "e1MatchesMu8Ele23DZFilter":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu8Ele23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8Ele23DZFilter")
        else:
            self.e1MatchesMu8Ele23DZFilter_branch.SetAddress(<void*>&self.e1MatchesMu8Ele23DZFilter_value)

        #print "making e1MatchesMu8Ele23DZPath"
        self.e1MatchesMu8Ele23DZPath_branch = the_tree.GetBranch("e1MatchesMu8Ele23DZPath")
        #if not self.e1MatchesMu8Ele23DZPath_branch and "e1MatchesMu8Ele23DZPath" not in self.complained:
        if not self.e1MatchesMu8Ele23DZPath_branch and "e1MatchesMu8Ele23DZPath":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu8Ele23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8Ele23DZPath")
        else:
            self.e1MatchesMu8Ele23DZPath_branch.SetAddress(<void*>&self.e1MatchesMu8Ele23DZPath_value)

        #print "making e1MatchesMu8Ele23Filter"
        self.e1MatchesMu8Ele23Filter_branch = the_tree.GetBranch("e1MatchesMu8Ele23Filter")
        #if not self.e1MatchesMu8Ele23Filter_branch and "e1MatchesMu8Ele23Filter" not in self.complained:
        if not self.e1MatchesMu8Ele23Filter_branch and "e1MatchesMu8Ele23Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu8Ele23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8Ele23Filter")
        else:
            self.e1MatchesMu8Ele23Filter_branch.SetAddress(<void*>&self.e1MatchesMu8Ele23Filter_value)

        #print "making e1MatchesMu8Ele23Path"
        self.e1MatchesMu8Ele23Path_branch = the_tree.GetBranch("e1MatchesMu8Ele23Path")
        #if not self.e1MatchesMu8Ele23Path_branch and "e1MatchesMu8Ele23Path" not in self.complained:
        if not self.e1MatchesMu8Ele23Path_branch and "e1MatchesMu8Ele23Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu8Ele23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8Ele23Path")
        else:
            self.e1MatchesMu8Ele23Path_branch.SetAddress(<void*>&self.e1MatchesMu8Ele23Path_value)

        #print "making e1MatchesSingleE"
        self.e1MatchesSingleE_branch = the_tree.GetBranch("e1MatchesSingleE")
        #if not self.e1MatchesSingleE_branch and "e1MatchesSingleE" not in self.complained:
        if not self.e1MatchesSingleE_branch and "e1MatchesSingleE":
            warnings.warn( "EETauTree: Expected branch e1MatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesSingleE")
        else:
            self.e1MatchesSingleE_branch.SetAddress(<void*>&self.e1MatchesSingleE_value)

        #print "making e1MatchesSingleESingleMu"
        self.e1MatchesSingleESingleMu_branch = the_tree.GetBranch("e1MatchesSingleESingleMu")
        #if not self.e1MatchesSingleESingleMu_branch and "e1MatchesSingleESingleMu" not in self.complained:
        if not self.e1MatchesSingleESingleMu_branch and "e1MatchesSingleESingleMu":
            warnings.warn( "EETauTree: Expected branch e1MatchesSingleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesSingleESingleMu")
        else:
            self.e1MatchesSingleESingleMu_branch.SetAddress(<void*>&self.e1MatchesSingleESingleMu_value)

        #print "making e1MatchesSingleE_leg1"
        self.e1MatchesSingleE_leg1_branch = the_tree.GetBranch("e1MatchesSingleE_leg1")
        #if not self.e1MatchesSingleE_leg1_branch and "e1MatchesSingleE_leg1" not in self.complained:
        if not self.e1MatchesSingleE_leg1_branch and "e1MatchesSingleE_leg1":
            warnings.warn( "EETauTree: Expected branch e1MatchesSingleE_leg1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesSingleE_leg1")
        else:
            self.e1MatchesSingleE_leg1_branch.SetAddress(<void*>&self.e1MatchesSingleE_leg1_value)

        #print "making e1MatchesSingleE_leg2"
        self.e1MatchesSingleE_leg2_branch = the_tree.GetBranch("e1MatchesSingleE_leg2")
        #if not self.e1MatchesSingleE_leg2_branch and "e1MatchesSingleE_leg2" not in self.complained:
        if not self.e1MatchesSingleE_leg2_branch and "e1MatchesSingleE_leg2":
            warnings.warn( "EETauTree: Expected branch e1MatchesSingleE_leg2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesSingleE_leg2")
        else:
            self.e1MatchesSingleE_leg2_branch.SetAddress(<void*>&self.e1MatchesSingleE_leg2_value)

        #print "making e1MatchesSingleMuSingleE"
        self.e1MatchesSingleMuSingleE_branch = the_tree.GetBranch("e1MatchesSingleMuSingleE")
        #if not self.e1MatchesSingleMuSingleE_branch and "e1MatchesSingleMuSingleE" not in self.complained:
        if not self.e1MatchesSingleMuSingleE_branch and "e1MatchesSingleMuSingleE":
            warnings.warn( "EETauTree: Expected branch e1MatchesSingleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesSingleMuSingleE")
        else:
            self.e1MatchesSingleMuSingleE_branch.SetAddress(<void*>&self.e1MatchesSingleMuSingleE_value)

        #print "making e1MatchesTripleE"
        self.e1MatchesTripleE_branch = the_tree.GetBranch("e1MatchesTripleE")
        #if not self.e1MatchesTripleE_branch and "e1MatchesTripleE" not in self.complained:
        if not self.e1MatchesTripleE_branch and "e1MatchesTripleE":
            warnings.warn( "EETauTree: Expected branch e1MatchesTripleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesTripleE")
        else:
            self.e1MatchesTripleE_branch.SetAddress(<void*>&self.e1MatchesTripleE_value)

        #print "making e1MissingHits"
        self.e1MissingHits_branch = the_tree.GetBranch("e1MissingHits")
        #if not self.e1MissingHits_branch and "e1MissingHits" not in self.complained:
        if not self.e1MissingHits_branch and "e1MissingHits":
            warnings.warn( "EETauTree: Expected branch e1MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MissingHits")
        else:
            self.e1MissingHits_branch.SetAddress(<void*>&self.e1MissingHits_value)

        #print "making e1MtToPfMet_type1"
        self.e1MtToPfMet_type1_branch = the_tree.GetBranch("e1MtToPfMet_type1")
        #if not self.e1MtToPfMet_type1_branch and "e1MtToPfMet_type1" not in self.complained:
        if not self.e1MtToPfMet_type1_branch and "e1MtToPfMet_type1":
            warnings.warn( "EETauTree: Expected branch e1MtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_type1")
        else:
            self.e1MtToPfMet_type1_branch.SetAddress(<void*>&self.e1MtToPfMet_type1_value)

        #print "making e1NearMuonVeto"
        self.e1NearMuonVeto_branch = the_tree.GetBranch("e1NearMuonVeto")
        #if not self.e1NearMuonVeto_branch and "e1NearMuonVeto" not in self.complained:
        if not self.e1NearMuonVeto_branch and "e1NearMuonVeto":
            warnings.warn( "EETauTree: Expected branch e1NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearMuonVeto")
        else:
            self.e1NearMuonVeto_branch.SetAddress(<void*>&self.e1NearMuonVeto_value)

        #print "making e1NearestMuonDR"
        self.e1NearestMuonDR_branch = the_tree.GetBranch("e1NearestMuonDR")
        #if not self.e1NearestMuonDR_branch and "e1NearestMuonDR" not in self.complained:
        if not self.e1NearestMuonDR_branch and "e1NearestMuonDR":
            warnings.warn( "EETauTree: Expected branch e1NearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearestMuonDR")
        else:
            self.e1NearestMuonDR_branch.SetAddress(<void*>&self.e1NearestMuonDR_value)

        #print "making e1NearestZMass"
        self.e1NearestZMass_branch = the_tree.GetBranch("e1NearestZMass")
        #if not self.e1NearestZMass_branch and "e1NearestZMass" not in self.complained:
        if not self.e1NearestZMass_branch and "e1NearestZMass":
            warnings.warn( "EETauTree: Expected branch e1NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearestZMass")
        else:
            self.e1NearestZMass_branch.SetAddress(<void*>&self.e1NearestZMass_value)

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

        #print "making e1PFPUChargedIso"
        self.e1PFPUChargedIso_branch = the_tree.GetBranch("e1PFPUChargedIso")
        #if not self.e1PFPUChargedIso_branch and "e1PFPUChargedIso" not in self.complained:
        if not self.e1PFPUChargedIso_branch and "e1PFPUChargedIso":
            warnings.warn( "EETauTree: Expected branch e1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFPUChargedIso")
        else:
            self.e1PFPUChargedIso_branch.SetAddress(<void*>&self.e1PFPUChargedIso_value)

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

        #print "making e1PassesConversionVeto"
        self.e1PassesConversionVeto_branch = the_tree.GetBranch("e1PassesConversionVeto")
        #if not self.e1PassesConversionVeto_branch and "e1PassesConversionVeto" not in self.complained:
        if not self.e1PassesConversionVeto_branch and "e1PassesConversionVeto":
            warnings.warn( "EETauTree: Expected branch e1PassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PassesConversionVeto")
        else:
            self.e1PassesConversionVeto_branch.SetAddress(<void*>&self.e1PassesConversionVeto_value)

        #print "making e1Phi"
        self.e1Phi_branch = the_tree.GetBranch("e1Phi")
        #if not self.e1Phi_branch and "e1Phi" not in self.complained:
        if not self.e1Phi_branch and "e1Phi":
            warnings.warn( "EETauTree: Expected branch e1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Phi")
        else:
            self.e1Phi_branch.SetAddress(<void*>&self.e1Phi_value)

        #print "making e1Phi_ElectronEnDown"
        self.e1Phi_ElectronEnDown_branch = the_tree.GetBranch("e1Phi_ElectronEnDown")
        #if not self.e1Phi_ElectronEnDown_branch and "e1Phi_ElectronEnDown" not in self.complained:
        if not self.e1Phi_ElectronEnDown_branch and "e1Phi_ElectronEnDown":
            warnings.warn( "EETauTree: Expected branch e1Phi_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Phi_ElectronEnDown")
        else:
            self.e1Phi_ElectronEnDown_branch.SetAddress(<void*>&self.e1Phi_ElectronEnDown_value)

        #print "making e1Phi_ElectronEnUp"
        self.e1Phi_ElectronEnUp_branch = the_tree.GetBranch("e1Phi_ElectronEnUp")
        #if not self.e1Phi_ElectronEnUp_branch and "e1Phi_ElectronEnUp" not in self.complained:
        if not self.e1Phi_ElectronEnUp_branch and "e1Phi_ElectronEnUp":
            warnings.warn( "EETauTree: Expected branch e1Phi_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Phi_ElectronEnUp")
        else:
            self.e1Phi_ElectronEnUp_branch.SetAddress(<void*>&self.e1Phi_ElectronEnUp_value)

        #print "making e1Pt"
        self.e1Pt_branch = the_tree.GetBranch("e1Pt")
        #if not self.e1Pt_branch and "e1Pt" not in self.complained:
        if not self.e1Pt_branch and "e1Pt":
            warnings.warn( "EETauTree: Expected branch e1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt")
        else:
            self.e1Pt_branch.SetAddress(<void*>&self.e1Pt_value)

        #print "making e1Pt_ElectronEnDown"
        self.e1Pt_ElectronEnDown_branch = the_tree.GetBranch("e1Pt_ElectronEnDown")
        #if not self.e1Pt_ElectronEnDown_branch and "e1Pt_ElectronEnDown" not in self.complained:
        if not self.e1Pt_ElectronEnDown_branch and "e1Pt_ElectronEnDown":
            warnings.warn( "EETauTree: Expected branch e1Pt_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt_ElectronEnDown")
        else:
            self.e1Pt_ElectronEnDown_branch.SetAddress(<void*>&self.e1Pt_ElectronEnDown_value)

        #print "making e1Pt_ElectronEnUp"
        self.e1Pt_ElectronEnUp_branch = the_tree.GetBranch("e1Pt_ElectronEnUp")
        #if not self.e1Pt_ElectronEnUp_branch and "e1Pt_ElectronEnUp" not in self.complained:
        if not self.e1Pt_ElectronEnUp_branch and "e1Pt_ElectronEnUp":
            warnings.warn( "EETauTree: Expected branch e1Pt_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt_ElectronEnUp")
        else:
            self.e1Pt_ElectronEnUp_branch.SetAddress(<void*>&self.e1Pt_ElectronEnUp_value)

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

        #print "making e1Rho"
        self.e1Rho_branch = the_tree.GetBranch("e1Rho")
        #if not self.e1Rho_branch and "e1Rho" not in self.complained:
        if not self.e1Rho_branch and "e1Rho":
            warnings.warn( "EETauTree: Expected branch e1Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Rho")
        else:
            self.e1Rho_branch.SetAddress(<void*>&self.e1Rho_value)

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

        #print "making e1SIP2D"
        self.e1SIP2D_branch = the_tree.GetBranch("e1SIP2D")
        #if not self.e1SIP2D_branch and "e1SIP2D" not in self.complained:
        if not self.e1SIP2D_branch and "e1SIP2D":
            warnings.warn( "EETauTree: Expected branch e1SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SIP2D")
        else:
            self.e1SIP2D_branch.SetAddress(<void*>&self.e1SIP2D_value)

        #print "making e1SIP3D"
        self.e1SIP3D_branch = the_tree.GetBranch("e1SIP3D")
        #if not self.e1SIP3D_branch and "e1SIP3D" not in self.complained:
        if not self.e1SIP3D_branch and "e1SIP3D":
            warnings.warn( "EETauTree: Expected branch e1SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SIP3D")
        else:
            self.e1SIP3D_branch.SetAddress(<void*>&self.e1SIP3D_value)

        #print "making e1SigmaIEtaIEta"
        self.e1SigmaIEtaIEta_branch = the_tree.GetBranch("e1SigmaIEtaIEta")
        #if not self.e1SigmaIEtaIEta_branch and "e1SigmaIEtaIEta" not in self.complained:
        if not self.e1SigmaIEtaIEta_branch and "e1SigmaIEtaIEta":
            warnings.warn( "EETauTree: Expected branch e1SigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SigmaIEtaIEta")
        else:
            self.e1SigmaIEtaIEta_branch.SetAddress(<void*>&self.e1SigmaIEtaIEta_value)

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

        #print "making e1WWLoose"
        self.e1WWLoose_branch = the_tree.GetBranch("e1WWLoose")
        #if not self.e1WWLoose_branch and "e1WWLoose" not in self.complained:
        if not self.e1WWLoose_branch and "e1WWLoose":
            warnings.warn( "EETauTree: Expected branch e1WWLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1WWLoose")
        else:
            self.e1WWLoose_branch.SetAddress(<void*>&self.e1WWLoose_value)

        #print "making e1ZTTGenMatching"
        self.e1ZTTGenMatching_branch = the_tree.GetBranch("e1ZTTGenMatching")
        #if not self.e1ZTTGenMatching_branch and "e1ZTTGenMatching" not in self.complained:
        if not self.e1ZTTGenMatching_branch and "e1ZTTGenMatching":
            warnings.warn( "EETauTree: Expected branch e1ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ZTTGenMatching")
        else:
            self.e1ZTTGenMatching_branch.SetAddress(<void*>&self.e1ZTTGenMatching_value)

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

        #print "making e1_e2_Eta"
        self.e1_e2_Eta_branch = the_tree.GetBranch("e1_e2_Eta")
        #if not self.e1_e2_Eta_branch and "e1_e2_Eta" not in self.complained:
        if not self.e1_e2_Eta_branch and "e1_e2_Eta":
            warnings.warn( "EETauTree: Expected branch e1_e2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Eta")
        else:
            self.e1_e2_Eta_branch.SetAddress(<void*>&self.e1_e2_Eta_value)

        #print "making e1_e2_Mass"
        self.e1_e2_Mass_branch = the_tree.GetBranch("e1_e2_Mass")
        #if not self.e1_e2_Mass_branch and "e1_e2_Mass" not in self.complained:
        if not self.e1_e2_Mass_branch and "e1_e2_Mass":
            warnings.warn( "EETauTree: Expected branch e1_e2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass")
        else:
            self.e1_e2_Mass_branch.SetAddress(<void*>&self.e1_e2_Mass_value)

        #print "making e1_e2_Mass_TauEnDown"
        self.e1_e2_Mass_TauEnDown_branch = the_tree.GetBranch("e1_e2_Mass_TauEnDown")
        #if not self.e1_e2_Mass_TauEnDown_branch and "e1_e2_Mass_TauEnDown" not in self.complained:
        if not self.e1_e2_Mass_TauEnDown_branch and "e1_e2_Mass_TauEnDown":
            warnings.warn( "EETauTree: Expected branch e1_e2_Mass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass_TauEnDown")
        else:
            self.e1_e2_Mass_TauEnDown_branch.SetAddress(<void*>&self.e1_e2_Mass_TauEnDown_value)

        #print "making e1_e2_Mass_TauEnUp"
        self.e1_e2_Mass_TauEnUp_branch = the_tree.GetBranch("e1_e2_Mass_TauEnUp")
        #if not self.e1_e2_Mass_TauEnUp_branch and "e1_e2_Mass_TauEnUp" not in self.complained:
        if not self.e1_e2_Mass_TauEnUp_branch and "e1_e2_Mass_TauEnUp":
            warnings.warn( "EETauTree: Expected branch e1_e2_Mass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass_TauEnUp")
        else:
            self.e1_e2_Mass_TauEnUp_branch.SetAddress(<void*>&self.e1_e2_Mass_TauEnUp_value)

        #print "making e1_e2_Mt"
        self.e1_e2_Mt_branch = the_tree.GetBranch("e1_e2_Mt")
        #if not self.e1_e2_Mt_branch and "e1_e2_Mt" not in self.complained:
        if not self.e1_e2_Mt_branch and "e1_e2_Mt":
            warnings.warn( "EETauTree: Expected branch e1_e2_Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mt")
        else:
            self.e1_e2_Mt_branch.SetAddress(<void*>&self.e1_e2_Mt_value)

        #print "making e1_e2_MtTotal"
        self.e1_e2_MtTotal_branch = the_tree.GetBranch("e1_e2_MtTotal")
        #if not self.e1_e2_MtTotal_branch and "e1_e2_MtTotal" not in self.complained:
        if not self.e1_e2_MtTotal_branch and "e1_e2_MtTotal":
            warnings.warn( "EETauTree: Expected branch e1_e2_MtTotal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_MtTotal")
        else:
            self.e1_e2_MtTotal_branch.SetAddress(<void*>&self.e1_e2_MtTotal_value)

        #print "making e1_e2_Mt_TauEnDown"
        self.e1_e2_Mt_TauEnDown_branch = the_tree.GetBranch("e1_e2_Mt_TauEnDown")
        #if not self.e1_e2_Mt_TauEnDown_branch and "e1_e2_Mt_TauEnDown" not in self.complained:
        if not self.e1_e2_Mt_TauEnDown_branch and "e1_e2_Mt_TauEnDown":
            warnings.warn( "EETauTree: Expected branch e1_e2_Mt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mt_TauEnDown")
        else:
            self.e1_e2_Mt_TauEnDown_branch.SetAddress(<void*>&self.e1_e2_Mt_TauEnDown_value)

        #print "making e1_e2_Mt_TauEnUp"
        self.e1_e2_Mt_TauEnUp_branch = the_tree.GetBranch("e1_e2_Mt_TauEnUp")
        #if not self.e1_e2_Mt_TauEnUp_branch and "e1_e2_Mt_TauEnUp" not in self.complained:
        if not self.e1_e2_Mt_TauEnUp_branch and "e1_e2_Mt_TauEnUp":
            warnings.warn( "EETauTree: Expected branch e1_e2_Mt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mt_TauEnUp")
        else:
            self.e1_e2_Mt_TauEnUp_branch.SetAddress(<void*>&self.e1_e2_Mt_TauEnUp_value)

        #print "making e1_e2_MvaMet"
        self.e1_e2_MvaMet_branch = the_tree.GetBranch("e1_e2_MvaMet")
        #if not self.e1_e2_MvaMet_branch and "e1_e2_MvaMet" not in self.complained:
        if not self.e1_e2_MvaMet_branch and "e1_e2_MvaMet":
            warnings.warn( "EETauTree: Expected branch e1_e2_MvaMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_MvaMet")
        else:
            self.e1_e2_MvaMet_branch.SetAddress(<void*>&self.e1_e2_MvaMet_value)

        #print "making e1_e2_MvaMetCovMatrix00"
        self.e1_e2_MvaMetCovMatrix00_branch = the_tree.GetBranch("e1_e2_MvaMetCovMatrix00")
        #if not self.e1_e2_MvaMetCovMatrix00_branch and "e1_e2_MvaMetCovMatrix00" not in self.complained:
        if not self.e1_e2_MvaMetCovMatrix00_branch and "e1_e2_MvaMetCovMatrix00":
            warnings.warn( "EETauTree: Expected branch e1_e2_MvaMetCovMatrix00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_MvaMetCovMatrix00")
        else:
            self.e1_e2_MvaMetCovMatrix00_branch.SetAddress(<void*>&self.e1_e2_MvaMetCovMatrix00_value)

        #print "making e1_e2_MvaMetCovMatrix01"
        self.e1_e2_MvaMetCovMatrix01_branch = the_tree.GetBranch("e1_e2_MvaMetCovMatrix01")
        #if not self.e1_e2_MvaMetCovMatrix01_branch and "e1_e2_MvaMetCovMatrix01" not in self.complained:
        if not self.e1_e2_MvaMetCovMatrix01_branch and "e1_e2_MvaMetCovMatrix01":
            warnings.warn( "EETauTree: Expected branch e1_e2_MvaMetCovMatrix01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_MvaMetCovMatrix01")
        else:
            self.e1_e2_MvaMetCovMatrix01_branch.SetAddress(<void*>&self.e1_e2_MvaMetCovMatrix01_value)

        #print "making e1_e2_MvaMetCovMatrix10"
        self.e1_e2_MvaMetCovMatrix10_branch = the_tree.GetBranch("e1_e2_MvaMetCovMatrix10")
        #if not self.e1_e2_MvaMetCovMatrix10_branch and "e1_e2_MvaMetCovMatrix10" not in self.complained:
        if not self.e1_e2_MvaMetCovMatrix10_branch and "e1_e2_MvaMetCovMatrix10":
            warnings.warn( "EETauTree: Expected branch e1_e2_MvaMetCovMatrix10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_MvaMetCovMatrix10")
        else:
            self.e1_e2_MvaMetCovMatrix10_branch.SetAddress(<void*>&self.e1_e2_MvaMetCovMatrix10_value)

        #print "making e1_e2_MvaMetCovMatrix11"
        self.e1_e2_MvaMetCovMatrix11_branch = the_tree.GetBranch("e1_e2_MvaMetCovMatrix11")
        #if not self.e1_e2_MvaMetCovMatrix11_branch and "e1_e2_MvaMetCovMatrix11" not in self.complained:
        if not self.e1_e2_MvaMetCovMatrix11_branch and "e1_e2_MvaMetCovMatrix11":
            warnings.warn( "EETauTree: Expected branch e1_e2_MvaMetCovMatrix11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_MvaMetCovMatrix11")
        else:
            self.e1_e2_MvaMetCovMatrix11_branch.SetAddress(<void*>&self.e1_e2_MvaMetCovMatrix11_value)

        #print "making e1_e2_MvaMetPhi"
        self.e1_e2_MvaMetPhi_branch = the_tree.GetBranch("e1_e2_MvaMetPhi")
        #if not self.e1_e2_MvaMetPhi_branch and "e1_e2_MvaMetPhi" not in self.complained:
        if not self.e1_e2_MvaMetPhi_branch and "e1_e2_MvaMetPhi":
            warnings.warn( "EETauTree: Expected branch e1_e2_MvaMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_MvaMetPhi")
        else:
            self.e1_e2_MvaMetPhi_branch.SetAddress(<void*>&self.e1_e2_MvaMetPhi_value)

        #print "making e1_e2_PZeta"
        self.e1_e2_PZeta_branch = the_tree.GetBranch("e1_e2_PZeta")
        #if not self.e1_e2_PZeta_branch and "e1_e2_PZeta" not in self.complained:
        if not self.e1_e2_PZeta_branch and "e1_e2_PZeta":
            warnings.warn( "EETauTree: Expected branch e1_e2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZeta")
        else:
            self.e1_e2_PZeta_branch.SetAddress(<void*>&self.e1_e2_PZeta_value)

        #print "making e1_e2_PZetaLess0p85PZetaVis"
        self.e1_e2_PZetaLess0p85PZetaVis_branch = the_tree.GetBranch("e1_e2_PZetaLess0p85PZetaVis")
        #if not self.e1_e2_PZetaLess0p85PZetaVis_branch and "e1_e2_PZetaLess0p85PZetaVis" not in self.complained:
        if not self.e1_e2_PZetaLess0p85PZetaVis_branch and "e1_e2_PZetaLess0p85PZetaVis":
            warnings.warn( "EETauTree: Expected branch e1_e2_PZetaLess0p85PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZetaLess0p85PZetaVis")
        else:
            self.e1_e2_PZetaLess0p85PZetaVis_branch.SetAddress(<void*>&self.e1_e2_PZetaLess0p85PZetaVis_value)

        #print "making e1_e2_PZetaVis"
        self.e1_e2_PZetaVis_branch = the_tree.GetBranch("e1_e2_PZetaVis")
        #if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis" not in self.complained:
        if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis":
            warnings.warn( "EETauTree: Expected branch e1_e2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZetaVis")
        else:
            self.e1_e2_PZetaVis_branch.SetAddress(<void*>&self.e1_e2_PZetaVis_value)

        #print "making e1_e2_Phi"
        self.e1_e2_Phi_branch = the_tree.GetBranch("e1_e2_Phi")
        #if not self.e1_e2_Phi_branch and "e1_e2_Phi" not in self.complained:
        if not self.e1_e2_Phi_branch and "e1_e2_Phi":
            warnings.warn( "EETauTree: Expected branch e1_e2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Phi")
        else:
            self.e1_e2_Phi_branch.SetAddress(<void*>&self.e1_e2_Phi_value)

        #print "making e1_e2_Pt"
        self.e1_e2_Pt_branch = the_tree.GetBranch("e1_e2_Pt")
        #if not self.e1_e2_Pt_branch and "e1_e2_Pt" not in self.complained:
        if not self.e1_e2_Pt_branch and "e1_e2_Pt":
            warnings.warn( "EETauTree: Expected branch e1_e2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Pt")
        else:
            self.e1_e2_Pt_branch.SetAddress(<void*>&self.e1_e2_Pt_value)

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

        #print "making e1_e2_collinearmass"
        self.e1_e2_collinearmass_branch = the_tree.GetBranch("e1_e2_collinearmass")
        #if not self.e1_e2_collinearmass_branch and "e1_e2_collinearmass" not in self.complained:
        if not self.e1_e2_collinearmass_branch and "e1_e2_collinearmass":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass")
        else:
            self.e1_e2_collinearmass_branch.SetAddress(<void*>&self.e1_e2_collinearmass_value)

        #print "making e1_e2_collinearmass_CheckUESDown"
        self.e1_e2_collinearmass_CheckUESDown_branch = the_tree.GetBranch("e1_e2_collinearmass_CheckUESDown")
        #if not self.e1_e2_collinearmass_CheckUESDown_branch and "e1_e2_collinearmass_CheckUESDown" not in self.complained:
        if not self.e1_e2_collinearmass_CheckUESDown_branch and "e1_e2_collinearmass_CheckUESDown":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_CheckUESDown")
        else:
            self.e1_e2_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.e1_e2_collinearmass_CheckUESDown_value)

        #print "making e1_e2_collinearmass_CheckUESUp"
        self.e1_e2_collinearmass_CheckUESUp_branch = the_tree.GetBranch("e1_e2_collinearmass_CheckUESUp")
        #if not self.e1_e2_collinearmass_CheckUESUp_branch and "e1_e2_collinearmass_CheckUESUp" not in self.complained:
        if not self.e1_e2_collinearmass_CheckUESUp_branch and "e1_e2_collinearmass_CheckUESUp":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_CheckUESUp")
        else:
            self.e1_e2_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.e1_e2_collinearmass_CheckUESUp_value)

        #print "making e1_e2_collinearmass_EleEnDown"
        self.e1_e2_collinearmass_EleEnDown_branch = the_tree.GetBranch("e1_e2_collinearmass_EleEnDown")
        #if not self.e1_e2_collinearmass_EleEnDown_branch and "e1_e2_collinearmass_EleEnDown" not in self.complained:
        if not self.e1_e2_collinearmass_EleEnDown_branch and "e1_e2_collinearmass_EleEnDown":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_EleEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_EleEnDown")
        else:
            self.e1_e2_collinearmass_EleEnDown_branch.SetAddress(<void*>&self.e1_e2_collinearmass_EleEnDown_value)

        #print "making e1_e2_collinearmass_EleEnUp"
        self.e1_e2_collinearmass_EleEnUp_branch = the_tree.GetBranch("e1_e2_collinearmass_EleEnUp")
        #if not self.e1_e2_collinearmass_EleEnUp_branch and "e1_e2_collinearmass_EleEnUp" not in self.complained:
        if not self.e1_e2_collinearmass_EleEnUp_branch and "e1_e2_collinearmass_EleEnUp":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_EleEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_EleEnUp")
        else:
            self.e1_e2_collinearmass_EleEnUp_branch.SetAddress(<void*>&self.e1_e2_collinearmass_EleEnUp_value)

        #print "making e1_e2_collinearmass_JetCheckTotalDown"
        self.e1_e2_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("e1_e2_collinearmass_JetCheckTotalDown")
        #if not self.e1_e2_collinearmass_JetCheckTotalDown_branch and "e1_e2_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.e1_e2_collinearmass_JetCheckTotalDown_branch and "e1_e2_collinearmass_JetCheckTotalDown":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_JetCheckTotalDown")
        else:
            self.e1_e2_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.e1_e2_collinearmass_JetCheckTotalDown_value)

        #print "making e1_e2_collinearmass_JetCheckTotalUp"
        self.e1_e2_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("e1_e2_collinearmass_JetCheckTotalUp")
        #if not self.e1_e2_collinearmass_JetCheckTotalUp_branch and "e1_e2_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.e1_e2_collinearmass_JetCheckTotalUp_branch and "e1_e2_collinearmass_JetCheckTotalUp":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_JetCheckTotalUp")
        else:
            self.e1_e2_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.e1_e2_collinearmass_JetCheckTotalUp_value)

        #print "making e1_e2_collinearmass_JetEnDown"
        self.e1_e2_collinearmass_JetEnDown_branch = the_tree.GetBranch("e1_e2_collinearmass_JetEnDown")
        #if not self.e1_e2_collinearmass_JetEnDown_branch and "e1_e2_collinearmass_JetEnDown" not in self.complained:
        if not self.e1_e2_collinearmass_JetEnDown_branch and "e1_e2_collinearmass_JetEnDown":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_JetEnDown")
        else:
            self.e1_e2_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.e1_e2_collinearmass_JetEnDown_value)

        #print "making e1_e2_collinearmass_JetEnUp"
        self.e1_e2_collinearmass_JetEnUp_branch = the_tree.GetBranch("e1_e2_collinearmass_JetEnUp")
        #if not self.e1_e2_collinearmass_JetEnUp_branch and "e1_e2_collinearmass_JetEnUp" not in self.complained:
        if not self.e1_e2_collinearmass_JetEnUp_branch and "e1_e2_collinearmass_JetEnUp":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_JetEnUp")
        else:
            self.e1_e2_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.e1_e2_collinearmass_JetEnUp_value)

        #print "making e1_e2_collinearmass_MuEnDown"
        self.e1_e2_collinearmass_MuEnDown_branch = the_tree.GetBranch("e1_e2_collinearmass_MuEnDown")
        #if not self.e1_e2_collinearmass_MuEnDown_branch and "e1_e2_collinearmass_MuEnDown" not in self.complained:
        if not self.e1_e2_collinearmass_MuEnDown_branch and "e1_e2_collinearmass_MuEnDown":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_MuEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_MuEnDown")
        else:
            self.e1_e2_collinearmass_MuEnDown_branch.SetAddress(<void*>&self.e1_e2_collinearmass_MuEnDown_value)

        #print "making e1_e2_collinearmass_MuEnUp"
        self.e1_e2_collinearmass_MuEnUp_branch = the_tree.GetBranch("e1_e2_collinearmass_MuEnUp")
        #if not self.e1_e2_collinearmass_MuEnUp_branch and "e1_e2_collinearmass_MuEnUp" not in self.complained:
        if not self.e1_e2_collinearmass_MuEnUp_branch and "e1_e2_collinearmass_MuEnUp":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_MuEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_MuEnUp")
        else:
            self.e1_e2_collinearmass_MuEnUp_branch.SetAddress(<void*>&self.e1_e2_collinearmass_MuEnUp_value)

        #print "making e1_e2_collinearmass_TauEnDown"
        self.e1_e2_collinearmass_TauEnDown_branch = the_tree.GetBranch("e1_e2_collinearmass_TauEnDown")
        #if not self.e1_e2_collinearmass_TauEnDown_branch and "e1_e2_collinearmass_TauEnDown" not in self.complained:
        if not self.e1_e2_collinearmass_TauEnDown_branch and "e1_e2_collinearmass_TauEnDown":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_TauEnDown")
        else:
            self.e1_e2_collinearmass_TauEnDown_branch.SetAddress(<void*>&self.e1_e2_collinearmass_TauEnDown_value)

        #print "making e1_e2_collinearmass_TauEnUp"
        self.e1_e2_collinearmass_TauEnUp_branch = the_tree.GetBranch("e1_e2_collinearmass_TauEnUp")
        #if not self.e1_e2_collinearmass_TauEnUp_branch and "e1_e2_collinearmass_TauEnUp" not in self.complained:
        if not self.e1_e2_collinearmass_TauEnUp_branch and "e1_e2_collinearmass_TauEnUp":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_TauEnUp")
        else:
            self.e1_e2_collinearmass_TauEnUp_branch.SetAddress(<void*>&self.e1_e2_collinearmass_TauEnUp_value)

        #print "making e1_e2_collinearmass_UnclusteredEnDown"
        self.e1_e2_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("e1_e2_collinearmass_UnclusteredEnDown")
        #if not self.e1_e2_collinearmass_UnclusteredEnDown_branch and "e1_e2_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.e1_e2_collinearmass_UnclusteredEnDown_branch and "e1_e2_collinearmass_UnclusteredEnDown":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_UnclusteredEnDown")
        else:
            self.e1_e2_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.e1_e2_collinearmass_UnclusteredEnDown_value)

        #print "making e1_e2_collinearmass_UnclusteredEnUp"
        self.e1_e2_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("e1_e2_collinearmass_UnclusteredEnUp")
        #if not self.e1_e2_collinearmass_UnclusteredEnUp_branch and "e1_e2_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.e1_e2_collinearmass_UnclusteredEnUp_branch and "e1_e2_collinearmass_UnclusteredEnUp":
            warnings.warn( "EETauTree: Expected branch e1_e2_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass_UnclusteredEnUp")
        else:
            self.e1_e2_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.e1_e2_collinearmass_UnclusteredEnUp_value)

        #print "making e1_e2_pt_tt"
        self.e1_e2_pt_tt_branch = the_tree.GetBranch("e1_e2_pt_tt")
        #if not self.e1_e2_pt_tt_branch and "e1_e2_pt_tt" not in self.complained:
        if not self.e1_e2_pt_tt_branch and "e1_e2_pt_tt":
            warnings.warn( "EETauTree: Expected branch e1_e2_pt_tt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_pt_tt")
        else:
            self.e1_e2_pt_tt_branch.SetAddress(<void*>&self.e1_e2_pt_tt_value)

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

        #print "making e1_t_Eta"
        self.e1_t_Eta_branch = the_tree.GetBranch("e1_t_Eta")
        #if not self.e1_t_Eta_branch and "e1_t_Eta" not in self.complained:
        if not self.e1_t_Eta_branch and "e1_t_Eta":
            warnings.warn( "EETauTree: Expected branch e1_t_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Eta")
        else:
            self.e1_t_Eta_branch.SetAddress(<void*>&self.e1_t_Eta_value)

        #print "making e1_t_Mass"
        self.e1_t_Mass_branch = the_tree.GetBranch("e1_t_Mass")
        #if not self.e1_t_Mass_branch and "e1_t_Mass" not in self.complained:
        if not self.e1_t_Mass_branch and "e1_t_Mass":
            warnings.warn( "EETauTree: Expected branch e1_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mass")
        else:
            self.e1_t_Mass_branch.SetAddress(<void*>&self.e1_t_Mass_value)

        #print "making e1_t_Mass_TauEnDown"
        self.e1_t_Mass_TauEnDown_branch = the_tree.GetBranch("e1_t_Mass_TauEnDown")
        #if not self.e1_t_Mass_TauEnDown_branch and "e1_t_Mass_TauEnDown" not in self.complained:
        if not self.e1_t_Mass_TauEnDown_branch and "e1_t_Mass_TauEnDown":
            warnings.warn( "EETauTree: Expected branch e1_t_Mass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mass_TauEnDown")
        else:
            self.e1_t_Mass_TauEnDown_branch.SetAddress(<void*>&self.e1_t_Mass_TauEnDown_value)

        #print "making e1_t_Mass_TauEnUp"
        self.e1_t_Mass_TauEnUp_branch = the_tree.GetBranch("e1_t_Mass_TauEnUp")
        #if not self.e1_t_Mass_TauEnUp_branch and "e1_t_Mass_TauEnUp" not in self.complained:
        if not self.e1_t_Mass_TauEnUp_branch and "e1_t_Mass_TauEnUp":
            warnings.warn( "EETauTree: Expected branch e1_t_Mass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mass_TauEnUp")
        else:
            self.e1_t_Mass_TauEnUp_branch.SetAddress(<void*>&self.e1_t_Mass_TauEnUp_value)

        #print "making e1_t_Mt"
        self.e1_t_Mt_branch = the_tree.GetBranch("e1_t_Mt")
        #if not self.e1_t_Mt_branch and "e1_t_Mt" not in self.complained:
        if not self.e1_t_Mt_branch and "e1_t_Mt":
            warnings.warn( "EETauTree: Expected branch e1_t_Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mt")
        else:
            self.e1_t_Mt_branch.SetAddress(<void*>&self.e1_t_Mt_value)

        #print "making e1_t_MtTotal"
        self.e1_t_MtTotal_branch = the_tree.GetBranch("e1_t_MtTotal")
        #if not self.e1_t_MtTotal_branch and "e1_t_MtTotal" not in self.complained:
        if not self.e1_t_MtTotal_branch and "e1_t_MtTotal":
            warnings.warn( "EETauTree: Expected branch e1_t_MtTotal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_MtTotal")
        else:
            self.e1_t_MtTotal_branch.SetAddress(<void*>&self.e1_t_MtTotal_value)

        #print "making e1_t_Mt_TauEnDown"
        self.e1_t_Mt_TauEnDown_branch = the_tree.GetBranch("e1_t_Mt_TauEnDown")
        #if not self.e1_t_Mt_TauEnDown_branch and "e1_t_Mt_TauEnDown" not in self.complained:
        if not self.e1_t_Mt_TauEnDown_branch and "e1_t_Mt_TauEnDown":
            warnings.warn( "EETauTree: Expected branch e1_t_Mt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mt_TauEnDown")
        else:
            self.e1_t_Mt_TauEnDown_branch.SetAddress(<void*>&self.e1_t_Mt_TauEnDown_value)

        #print "making e1_t_Mt_TauEnUp"
        self.e1_t_Mt_TauEnUp_branch = the_tree.GetBranch("e1_t_Mt_TauEnUp")
        #if not self.e1_t_Mt_TauEnUp_branch and "e1_t_Mt_TauEnUp" not in self.complained:
        if not self.e1_t_Mt_TauEnUp_branch and "e1_t_Mt_TauEnUp":
            warnings.warn( "EETauTree: Expected branch e1_t_Mt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mt_TauEnUp")
        else:
            self.e1_t_Mt_TauEnUp_branch.SetAddress(<void*>&self.e1_t_Mt_TauEnUp_value)

        #print "making e1_t_MvaMet"
        self.e1_t_MvaMet_branch = the_tree.GetBranch("e1_t_MvaMet")
        #if not self.e1_t_MvaMet_branch and "e1_t_MvaMet" not in self.complained:
        if not self.e1_t_MvaMet_branch and "e1_t_MvaMet":
            warnings.warn( "EETauTree: Expected branch e1_t_MvaMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_MvaMet")
        else:
            self.e1_t_MvaMet_branch.SetAddress(<void*>&self.e1_t_MvaMet_value)

        #print "making e1_t_MvaMetCovMatrix00"
        self.e1_t_MvaMetCovMatrix00_branch = the_tree.GetBranch("e1_t_MvaMetCovMatrix00")
        #if not self.e1_t_MvaMetCovMatrix00_branch and "e1_t_MvaMetCovMatrix00" not in self.complained:
        if not self.e1_t_MvaMetCovMatrix00_branch and "e1_t_MvaMetCovMatrix00":
            warnings.warn( "EETauTree: Expected branch e1_t_MvaMetCovMatrix00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_MvaMetCovMatrix00")
        else:
            self.e1_t_MvaMetCovMatrix00_branch.SetAddress(<void*>&self.e1_t_MvaMetCovMatrix00_value)

        #print "making e1_t_MvaMetCovMatrix01"
        self.e1_t_MvaMetCovMatrix01_branch = the_tree.GetBranch("e1_t_MvaMetCovMatrix01")
        #if not self.e1_t_MvaMetCovMatrix01_branch and "e1_t_MvaMetCovMatrix01" not in self.complained:
        if not self.e1_t_MvaMetCovMatrix01_branch and "e1_t_MvaMetCovMatrix01":
            warnings.warn( "EETauTree: Expected branch e1_t_MvaMetCovMatrix01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_MvaMetCovMatrix01")
        else:
            self.e1_t_MvaMetCovMatrix01_branch.SetAddress(<void*>&self.e1_t_MvaMetCovMatrix01_value)

        #print "making e1_t_MvaMetCovMatrix10"
        self.e1_t_MvaMetCovMatrix10_branch = the_tree.GetBranch("e1_t_MvaMetCovMatrix10")
        #if not self.e1_t_MvaMetCovMatrix10_branch and "e1_t_MvaMetCovMatrix10" not in self.complained:
        if not self.e1_t_MvaMetCovMatrix10_branch and "e1_t_MvaMetCovMatrix10":
            warnings.warn( "EETauTree: Expected branch e1_t_MvaMetCovMatrix10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_MvaMetCovMatrix10")
        else:
            self.e1_t_MvaMetCovMatrix10_branch.SetAddress(<void*>&self.e1_t_MvaMetCovMatrix10_value)

        #print "making e1_t_MvaMetCovMatrix11"
        self.e1_t_MvaMetCovMatrix11_branch = the_tree.GetBranch("e1_t_MvaMetCovMatrix11")
        #if not self.e1_t_MvaMetCovMatrix11_branch and "e1_t_MvaMetCovMatrix11" not in self.complained:
        if not self.e1_t_MvaMetCovMatrix11_branch and "e1_t_MvaMetCovMatrix11":
            warnings.warn( "EETauTree: Expected branch e1_t_MvaMetCovMatrix11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_MvaMetCovMatrix11")
        else:
            self.e1_t_MvaMetCovMatrix11_branch.SetAddress(<void*>&self.e1_t_MvaMetCovMatrix11_value)

        #print "making e1_t_MvaMetPhi"
        self.e1_t_MvaMetPhi_branch = the_tree.GetBranch("e1_t_MvaMetPhi")
        #if not self.e1_t_MvaMetPhi_branch and "e1_t_MvaMetPhi" not in self.complained:
        if not self.e1_t_MvaMetPhi_branch and "e1_t_MvaMetPhi":
            warnings.warn( "EETauTree: Expected branch e1_t_MvaMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_MvaMetPhi")
        else:
            self.e1_t_MvaMetPhi_branch.SetAddress(<void*>&self.e1_t_MvaMetPhi_value)

        #print "making e1_t_PZeta"
        self.e1_t_PZeta_branch = the_tree.GetBranch("e1_t_PZeta")
        #if not self.e1_t_PZeta_branch and "e1_t_PZeta" not in self.complained:
        if not self.e1_t_PZeta_branch and "e1_t_PZeta":
            warnings.warn( "EETauTree: Expected branch e1_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_PZeta")
        else:
            self.e1_t_PZeta_branch.SetAddress(<void*>&self.e1_t_PZeta_value)

        #print "making e1_t_PZetaLess0p85PZetaVis"
        self.e1_t_PZetaLess0p85PZetaVis_branch = the_tree.GetBranch("e1_t_PZetaLess0p85PZetaVis")
        #if not self.e1_t_PZetaLess0p85PZetaVis_branch and "e1_t_PZetaLess0p85PZetaVis" not in self.complained:
        if not self.e1_t_PZetaLess0p85PZetaVis_branch and "e1_t_PZetaLess0p85PZetaVis":
            warnings.warn( "EETauTree: Expected branch e1_t_PZetaLess0p85PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_PZetaLess0p85PZetaVis")
        else:
            self.e1_t_PZetaLess0p85PZetaVis_branch.SetAddress(<void*>&self.e1_t_PZetaLess0p85PZetaVis_value)

        #print "making e1_t_PZetaVis"
        self.e1_t_PZetaVis_branch = the_tree.GetBranch("e1_t_PZetaVis")
        #if not self.e1_t_PZetaVis_branch and "e1_t_PZetaVis" not in self.complained:
        if not self.e1_t_PZetaVis_branch and "e1_t_PZetaVis":
            warnings.warn( "EETauTree: Expected branch e1_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_PZetaVis")
        else:
            self.e1_t_PZetaVis_branch.SetAddress(<void*>&self.e1_t_PZetaVis_value)

        #print "making e1_t_Phi"
        self.e1_t_Phi_branch = the_tree.GetBranch("e1_t_Phi")
        #if not self.e1_t_Phi_branch and "e1_t_Phi" not in self.complained:
        if not self.e1_t_Phi_branch and "e1_t_Phi":
            warnings.warn( "EETauTree: Expected branch e1_t_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Phi")
        else:
            self.e1_t_Phi_branch.SetAddress(<void*>&self.e1_t_Phi_value)

        #print "making e1_t_Pt"
        self.e1_t_Pt_branch = the_tree.GetBranch("e1_t_Pt")
        #if not self.e1_t_Pt_branch and "e1_t_Pt" not in self.complained:
        if not self.e1_t_Pt_branch and "e1_t_Pt":
            warnings.warn( "EETauTree: Expected branch e1_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Pt")
        else:
            self.e1_t_Pt_branch.SetAddress(<void*>&self.e1_t_Pt_value)

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

        #print "making e1_t_collinearmass"
        self.e1_t_collinearmass_branch = the_tree.GetBranch("e1_t_collinearmass")
        #if not self.e1_t_collinearmass_branch and "e1_t_collinearmass" not in self.complained:
        if not self.e1_t_collinearmass_branch and "e1_t_collinearmass":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass")
        else:
            self.e1_t_collinearmass_branch.SetAddress(<void*>&self.e1_t_collinearmass_value)

        #print "making e1_t_collinearmass_CheckUESDown"
        self.e1_t_collinearmass_CheckUESDown_branch = the_tree.GetBranch("e1_t_collinearmass_CheckUESDown")
        #if not self.e1_t_collinearmass_CheckUESDown_branch and "e1_t_collinearmass_CheckUESDown" not in self.complained:
        if not self.e1_t_collinearmass_CheckUESDown_branch and "e1_t_collinearmass_CheckUESDown":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_CheckUESDown")
        else:
            self.e1_t_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.e1_t_collinearmass_CheckUESDown_value)

        #print "making e1_t_collinearmass_CheckUESUp"
        self.e1_t_collinearmass_CheckUESUp_branch = the_tree.GetBranch("e1_t_collinearmass_CheckUESUp")
        #if not self.e1_t_collinearmass_CheckUESUp_branch and "e1_t_collinearmass_CheckUESUp" not in self.complained:
        if not self.e1_t_collinearmass_CheckUESUp_branch and "e1_t_collinearmass_CheckUESUp":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_CheckUESUp")
        else:
            self.e1_t_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.e1_t_collinearmass_CheckUESUp_value)

        #print "making e1_t_collinearmass_EleEnDown"
        self.e1_t_collinearmass_EleEnDown_branch = the_tree.GetBranch("e1_t_collinearmass_EleEnDown")
        #if not self.e1_t_collinearmass_EleEnDown_branch and "e1_t_collinearmass_EleEnDown" not in self.complained:
        if not self.e1_t_collinearmass_EleEnDown_branch and "e1_t_collinearmass_EleEnDown":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_EleEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_EleEnDown")
        else:
            self.e1_t_collinearmass_EleEnDown_branch.SetAddress(<void*>&self.e1_t_collinearmass_EleEnDown_value)

        #print "making e1_t_collinearmass_EleEnUp"
        self.e1_t_collinearmass_EleEnUp_branch = the_tree.GetBranch("e1_t_collinearmass_EleEnUp")
        #if not self.e1_t_collinearmass_EleEnUp_branch and "e1_t_collinearmass_EleEnUp" not in self.complained:
        if not self.e1_t_collinearmass_EleEnUp_branch and "e1_t_collinearmass_EleEnUp":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_EleEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_EleEnUp")
        else:
            self.e1_t_collinearmass_EleEnUp_branch.SetAddress(<void*>&self.e1_t_collinearmass_EleEnUp_value)

        #print "making e1_t_collinearmass_JetCheckTotalDown"
        self.e1_t_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("e1_t_collinearmass_JetCheckTotalDown")
        #if not self.e1_t_collinearmass_JetCheckTotalDown_branch and "e1_t_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.e1_t_collinearmass_JetCheckTotalDown_branch and "e1_t_collinearmass_JetCheckTotalDown":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_JetCheckTotalDown")
        else:
            self.e1_t_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.e1_t_collinearmass_JetCheckTotalDown_value)

        #print "making e1_t_collinearmass_JetCheckTotalUp"
        self.e1_t_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("e1_t_collinearmass_JetCheckTotalUp")
        #if not self.e1_t_collinearmass_JetCheckTotalUp_branch and "e1_t_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.e1_t_collinearmass_JetCheckTotalUp_branch and "e1_t_collinearmass_JetCheckTotalUp":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_JetCheckTotalUp")
        else:
            self.e1_t_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.e1_t_collinearmass_JetCheckTotalUp_value)

        #print "making e1_t_collinearmass_JetEnDown"
        self.e1_t_collinearmass_JetEnDown_branch = the_tree.GetBranch("e1_t_collinearmass_JetEnDown")
        #if not self.e1_t_collinearmass_JetEnDown_branch and "e1_t_collinearmass_JetEnDown" not in self.complained:
        if not self.e1_t_collinearmass_JetEnDown_branch and "e1_t_collinearmass_JetEnDown":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_JetEnDown")
        else:
            self.e1_t_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.e1_t_collinearmass_JetEnDown_value)

        #print "making e1_t_collinearmass_JetEnUp"
        self.e1_t_collinearmass_JetEnUp_branch = the_tree.GetBranch("e1_t_collinearmass_JetEnUp")
        #if not self.e1_t_collinearmass_JetEnUp_branch and "e1_t_collinearmass_JetEnUp" not in self.complained:
        if not self.e1_t_collinearmass_JetEnUp_branch and "e1_t_collinearmass_JetEnUp":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_JetEnUp")
        else:
            self.e1_t_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.e1_t_collinearmass_JetEnUp_value)

        #print "making e1_t_collinearmass_MuEnDown"
        self.e1_t_collinearmass_MuEnDown_branch = the_tree.GetBranch("e1_t_collinearmass_MuEnDown")
        #if not self.e1_t_collinearmass_MuEnDown_branch and "e1_t_collinearmass_MuEnDown" not in self.complained:
        if not self.e1_t_collinearmass_MuEnDown_branch and "e1_t_collinearmass_MuEnDown":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_MuEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_MuEnDown")
        else:
            self.e1_t_collinearmass_MuEnDown_branch.SetAddress(<void*>&self.e1_t_collinearmass_MuEnDown_value)

        #print "making e1_t_collinearmass_MuEnUp"
        self.e1_t_collinearmass_MuEnUp_branch = the_tree.GetBranch("e1_t_collinearmass_MuEnUp")
        #if not self.e1_t_collinearmass_MuEnUp_branch and "e1_t_collinearmass_MuEnUp" not in self.complained:
        if not self.e1_t_collinearmass_MuEnUp_branch and "e1_t_collinearmass_MuEnUp":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_MuEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_MuEnUp")
        else:
            self.e1_t_collinearmass_MuEnUp_branch.SetAddress(<void*>&self.e1_t_collinearmass_MuEnUp_value)

        #print "making e1_t_collinearmass_TauEnDown"
        self.e1_t_collinearmass_TauEnDown_branch = the_tree.GetBranch("e1_t_collinearmass_TauEnDown")
        #if not self.e1_t_collinearmass_TauEnDown_branch and "e1_t_collinearmass_TauEnDown" not in self.complained:
        if not self.e1_t_collinearmass_TauEnDown_branch and "e1_t_collinearmass_TauEnDown":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_TauEnDown")
        else:
            self.e1_t_collinearmass_TauEnDown_branch.SetAddress(<void*>&self.e1_t_collinearmass_TauEnDown_value)

        #print "making e1_t_collinearmass_TauEnUp"
        self.e1_t_collinearmass_TauEnUp_branch = the_tree.GetBranch("e1_t_collinearmass_TauEnUp")
        #if not self.e1_t_collinearmass_TauEnUp_branch and "e1_t_collinearmass_TauEnUp" not in self.complained:
        if not self.e1_t_collinearmass_TauEnUp_branch and "e1_t_collinearmass_TauEnUp":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_TauEnUp")
        else:
            self.e1_t_collinearmass_TauEnUp_branch.SetAddress(<void*>&self.e1_t_collinearmass_TauEnUp_value)

        #print "making e1_t_collinearmass_UnclusteredEnDown"
        self.e1_t_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("e1_t_collinearmass_UnclusteredEnDown")
        #if not self.e1_t_collinearmass_UnclusteredEnDown_branch and "e1_t_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.e1_t_collinearmass_UnclusteredEnDown_branch and "e1_t_collinearmass_UnclusteredEnDown":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_UnclusteredEnDown")
        else:
            self.e1_t_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.e1_t_collinearmass_UnclusteredEnDown_value)

        #print "making e1_t_collinearmass_UnclusteredEnUp"
        self.e1_t_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("e1_t_collinearmass_UnclusteredEnUp")
        #if not self.e1_t_collinearmass_UnclusteredEnUp_branch and "e1_t_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.e1_t_collinearmass_UnclusteredEnUp_branch and "e1_t_collinearmass_UnclusteredEnUp":
            warnings.warn( "EETauTree: Expected branch e1_t_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_collinearmass_UnclusteredEnUp")
        else:
            self.e1_t_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.e1_t_collinearmass_UnclusteredEnUp_value)

        #print "making e1_t_pt_tt"
        self.e1_t_pt_tt_branch = the_tree.GetBranch("e1_t_pt_tt")
        #if not self.e1_t_pt_tt_branch and "e1_t_pt_tt" not in self.complained:
        if not self.e1_t_pt_tt_branch and "e1_t_pt_tt":
            warnings.warn( "EETauTree: Expected branch e1_t_pt_tt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_pt_tt")
        else:
            self.e1_t_pt_tt_branch.SetAddress(<void*>&self.e1_t_pt_tt_value)

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

        #print "making e2CBIDLoose"
        self.e2CBIDLoose_branch = the_tree.GetBranch("e2CBIDLoose")
        #if not self.e2CBIDLoose_branch and "e2CBIDLoose" not in self.complained:
        if not self.e2CBIDLoose_branch and "e2CBIDLoose":
            warnings.warn( "EETauTree: Expected branch e2CBIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBIDLoose")
        else:
            self.e2CBIDLoose_branch.SetAddress(<void*>&self.e2CBIDLoose_value)

        #print "making e2CBIDLooseNoIso"
        self.e2CBIDLooseNoIso_branch = the_tree.GetBranch("e2CBIDLooseNoIso")
        #if not self.e2CBIDLooseNoIso_branch and "e2CBIDLooseNoIso" not in self.complained:
        if not self.e2CBIDLooseNoIso_branch and "e2CBIDLooseNoIso":
            warnings.warn( "EETauTree: Expected branch e2CBIDLooseNoIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBIDLooseNoIso")
        else:
            self.e2CBIDLooseNoIso_branch.SetAddress(<void*>&self.e2CBIDLooseNoIso_value)

        #print "making e2CBIDMedium"
        self.e2CBIDMedium_branch = the_tree.GetBranch("e2CBIDMedium")
        #if not self.e2CBIDMedium_branch and "e2CBIDMedium" not in self.complained:
        if not self.e2CBIDMedium_branch and "e2CBIDMedium":
            warnings.warn( "EETauTree: Expected branch e2CBIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBIDMedium")
        else:
            self.e2CBIDMedium_branch.SetAddress(<void*>&self.e2CBIDMedium_value)

        #print "making e2CBIDMediumNoIso"
        self.e2CBIDMediumNoIso_branch = the_tree.GetBranch("e2CBIDMediumNoIso")
        #if not self.e2CBIDMediumNoIso_branch and "e2CBIDMediumNoIso" not in self.complained:
        if not self.e2CBIDMediumNoIso_branch and "e2CBIDMediumNoIso":
            warnings.warn( "EETauTree: Expected branch e2CBIDMediumNoIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBIDMediumNoIso")
        else:
            self.e2CBIDMediumNoIso_branch.SetAddress(<void*>&self.e2CBIDMediumNoIso_value)

        #print "making e2CBIDTight"
        self.e2CBIDTight_branch = the_tree.GetBranch("e2CBIDTight")
        #if not self.e2CBIDTight_branch and "e2CBIDTight" not in self.complained:
        if not self.e2CBIDTight_branch and "e2CBIDTight":
            warnings.warn( "EETauTree: Expected branch e2CBIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBIDTight")
        else:
            self.e2CBIDTight_branch.SetAddress(<void*>&self.e2CBIDTight_value)

        #print "making e2CBIDTightNoIso"
        self.e2CBIDTightNoIso_branch = the_tree.GetBranch("e2CBIDTightNoIso")
        #if not self.e2CBIDTightNoIso_branch and "e2CBIDTightNoIso" not in self.complained:
        if not self.e2CBIDTightNoIso_branch and "e2CBIDTightNoIso":
            warnings.warn( "EETauTree: Expected branch e2CBIDTightNoIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBIDTightNoIso")
        else:
            self.e2CBIDTightNoIso_branch.SetAddress(<void*>&self.e2CBIDTightNoIso_value)

        #print "making e2CBIDVeto"
        self.e2CBIDVeto_branch = the_tree.GetBranch("e2CBIDVeto")
        #if not self.e2CBIDVeto_branch and "e2CBIDVeto" not in self.complained:
        if not self.e2CBIDVeto_branch and "e2CBIDVeto":
            warnings.warn( "EETauTree: Expected branch e2CBIDVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBIDVeto")
        else:
            self.e2CBIDVeto_branch.SetAddress(<void*>&self.e2CBIDVeto_value)

        #print "making e2CBIDVetoNoIso"
        self.e2CBIDVetoNoIso_branch = the_tree.GetBranch("e2CBIDVetoNoIso")
        #if not self.e2CBIDVetoNoIso_branch and "e2CBIDVetoNoIso" not in self.complained:
        if not self.e2CBIDVetoNoIso_branch and "e2CBIDVetoNoIso":
            warnings.warn( "EETauTree: Expected branch e2CBIDVetoNoIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBIDVetoNoIso")
        else:
            self.e2CBIDVetoNoIso_branch.SetAddress(<void*>&self.e2CBIDVetoNoIso_value)

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

        #print "making e2ComesFromHiggs"
        self.e2ComesFromHiggs_branch = the_tree.GetBranch("e2ComesFromHiggs")
        #if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs" not in self.complained:
        if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs":
            warnings.warn( "EETauTree: Expected branch e2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ComesFromHiggs")
        else:
            self.e2ComesFromHiggs_branch.SetAddress(<void*>&self.e2ComesFromHiggs_value)

        #print "making e2DPhiToPfMet_type1"
        self.e2DPhiToPfMet_type1_branch = the_tree.GetBranch("e2DPhiToPfMet_type1")
        #if not self.e2DPhiToPfMet_type1_branch and "e2DPhiToPfMet_type1" not in self.complained:
        if not self.e2DPhiToPfMet_type1_branch and "e2DPhiToPfMet_type1":
            warnings.warn( "EETauTree: Expected branch e2DPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2DPhiToPfMet_type1")
        else:
            self.e2DPhiToPfMet_type1_branch.SetAddress(<void*>&self.e2DPhiToPfMet_type1_value)

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

        #print "making e2EcalIsoDR03"
        self.e2EcalIsoDR03_branch = the_tree.GetBranch("e2EcalIsoDR03")
        #if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03" not in self.complained:
        if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03":
            warnings.warn( "EETauTree: Expected branch e2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EcalIsoDR03")
        else:
            self.e2EcalIsoDR03_branch.SetAddress(<void*>&self.e2EcalIsoDR03_value)

        #print "making e2EffectiveArea2012Data"
        self.e2EffectiveArea2012Data_branch = the_tree.GetBranch("e2EffectiveArea2012Data")
        #if not self.e2EffectiveArea2012Data_branch and "e2EffectiveArea2012Data" not in self.complained:
        if not self.e2EffectiveArea2012Data_branch and "e2EffectiveArea2012Data":
            warnings.warn( "EETauTree: Expected branch e2EffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EffectiveArea2012Data")
        else:
            self.e2EffectiveArea2012Data_branch.SetAddress(<void*>&self.e2EffectiveArea2012Data_value)

        #print "making e2EffectiveAreaSpring15"
        self.e2EffectiveAreaSpring15_branch = the_tree.GetBranch("e2EffectiveAreaSpring15")
        #if not self.e2EffectiveAreaSpring15_branch and "e2EffectiveAreaSpring15" not in self.complained:
        if not self.e2EffectiveAreaSpring15_branch and "e2EffectiveAreaSpring15":
            warnings.warn( "EETauTree: Expected branch e2EffectiveAreaSpring15 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EffectiveAreaSpring15")
        else:
            self.e2EffectiveAreaSpring15_branch.SetAddress(<void*>&self.e2EffectiveAreaSpring15_value)

        #print "making e2EnergyError"
        self.e2EnergyError_branch = the_tree.GetBranch("e2EnergyError")
        #if not self.e2EnergyError_branch and "e2EnergyError" not in self.complained:
        if not self.e2EnergyError_branch and "e2EnergyError":
            warnings.warn( "EETauTree: Expected branch e2EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyError")
        else:
            self.e2EnergyError_branch.SetAddress(<void*>&self.e2EnergyError_value)

        #print "making e2ErsatzGenEta"
        self.e2ErsatzGenEta_branch = the_tree.GetBranch("e2ErsatzGenEta")
        #if not self.e2ErsatzGenEta_branch and "e2ErsatzGenEta" not in self.complained:
        if not self.e2ErsatzGenEta_branch and "e2ErsatzGenEta":
            warnings.warn( "EETauTree: Expected branch e2ErsatzGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ErsatzGenEta")
        else:
            self.e2ErsatzGenEta_branch.SetAddress(<void*>&self.e2ErsatzGenEta_value)

        #print "making e2ErsatzGenM"
        self.e2ErsatzGenM_branch = the_tree.GetBranch("e2ErsatzGenM")
        #if not self.e2ErsatzGenM_branch and "e2ErsatzGenM" not in self.complained:
        if not self.e2ErsatzGenM_branch and "e2ErsatzGenM":
            warnings.warn( "EETauTree: Expected branch e2ErsatzGenM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ErsatzGenM")
        else:
            self.e2ErsatzGenM_branch.SetAddress(<void*>&self.e2ErsatzGenM_value)

        #print "making e2ErsatzGenPhi"
        self.e2ErsatzGenPhi_branch = the_tree.GetBranch("e2ErsatzGenPhi")
        #if not self.e2ErsatzGenPhi_branch and "e2ErsatzGenPhi" not in self.complained:
        if not self.e2ErsatzGenPhi_branch and "e2ErsatzGenPhi":
            warnings.warn( "EETauTree: Expected branch e2ErsatzGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ErsatzGenPhi")
        else:
            self.e2ErsatzGenPhi_branch.SetAddress(<void*>&self.e2ErsatzGenPhi_value)

        #print "making e2ErsatzGenpT"
        self.e2ErsatzGenpT_branch = the_tree.GetBranch("e2ErsatzGenpT")
        #if not self.e2ErsatzGenpT_branch and "e2ErsatzGenpT" not in self.complained:
        if not self.e2ErsatzGenpT_branch and "e2ErsatzGenpT":
            warnings.warn( "EETauTree: Expected branch e2ErsatzGenpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ErsatzGenpT")
        else:
            self.e2ErsatzGenpT_branch.SetAddress(<void*>&self.e2ErsatzGenpT_value)

        #print "making e2ErsatzGenpX"
        self.e2ErsatzGenpX_branch = the_tree.GetBranch("e2ErsatzGenpX")
        #if not self.e2ErsatzGenpX_branch and "e2ErsatzGenpX" not in self.complained:
        if not self.e2ErsatzGenpX_branch and "e2ErsatzGenpX":
            warnings.warn( "EETauTree: Expected branch e2ErsatzGenpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ErsatzGenpX")
        else:
            self.e2ErsatzGenpX_branch.SetAddress(<void*>&self.e2ErsatzGenpX_value)

        #print "making e2ErsatzGenpY"
        self.e2ErsatzGenpY_branch = the_tree.GetBranch("e2ErsatzGenpY")
        #if not self.e2ErsatzGenpY_branch and "e2ErsatzGenpY" not in self.complained:
        if not self.e2ErsatzGenpY_branch and "e2ErsatzGenpY":
            warnings.warn( "EETauTree: Expected branch e2ErsatzGenpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ErsatzGenpY")
        else:
            self.e2ErsatzGenpY_branch.SetAddress(<void*>&self.e2ErsatzGenpY_value)

        #print "making e2ErsatzVispX"
        self.e2ErsatzVispX_branch = the_tree.GetBranch("e2ErsatzVispX")
        #if not self.e2ErsatzVispX_branch and "e2ErsatzVispX" not in self.complained:
        if not self.e2ErsatzVispX_branch and "e2ErsatzVispX":
            warnings.warn( "EETauTree: Expected branch e2ErsatzVispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ErsatzVispX")
        else:
            self.e2ErsatzVispX_branch.SetAddress(<void*>&self.e2ErsatzVispX_value)

        #print "making e2ErsatzVispY"
        self.e2ErsatzVispY_branch = the_tree.GetBranch("e2ErsatzVispY")
        #if not self.e2ErsatzVispY_branch and "e2ErsatzVispY" not in self.complained:
        if not self.e2ErsatzVispY_branch and "e2ErsatzVispY":
            warnings.warn( "EETauTree: Expected branch e2ErsatzVispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ErsatzVispY")
        else:
            self.e2ErsatzVispY_branch.SetAddress(<void*>&self.e2ErsatzVispY_value)

        #print "making e2Eta"
        self.e2Eta_branch = the_tree.GetBranch("e2Eta")
        #if not self.e2Eta_branch and "e2Eta" not in self.complained:
        if not self.e2Eta_branch and "e2Eta":
            warnings.warn( "EETauTree: Expected branch e2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Eta")
        else:
            self.e2Eta_branch.SetAddress(<void*>&self.e2Eta_value)

        #print "making e2Eta_ElectronEnDown"
        self.e2Eta_ElectronEnDown_branch = the_tree.GetBranch("e2Eta_ElectronEnDown")
        #if not self.e2Eta_ElectronEnDown_branch and "e2Eta_ElectronEnDown" not in self.complained:
        if not self.e2Eta_ElectronEnDown_branch and "e2Eta_ElectronEnDown":
            warnings.warn( "EETauTree: Expected branch e2Eta_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Eta_ElectronEnDown")
        else:
            self.e2Eta_ElectronEnDown_branch.SetAddress(<void*>&self.e2Eta_ElectronEnDown_value)

        #print "making e2Eta_ElectronEnUp"
        self.e2Eta_ElectronEnUp_branch = the_tree.GetBranch("e2Eta_ElectronEnUp")
        #if not self.e2Eta_ElectronEnUp_branch and "e2Eta_ElectronEnUp" not in self.complained:
        if not self.e2Eta_ElectronEnUp_branch and "e2Eta_ElectronEnUp":
            warnings.warn( "EETauTree: Expected branch e2Eta_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Eta_ElectronEnUp")
        else:
            self.e2Eta_ElectronEnUp_branch.SetAddress(<void*>&self.e2Eta_ElectronEnUp_value)

        #print "making e2GenCharge"
        self.e2GenCharge_branch = the_tree.GetBranch("e2GenCharge")
        #if not self.e2GenCharge_branch and "e2GenCharge" not in self.complained:
        if not self.e2GenCharge_branch and "e2GenCharge":
            warnings.warn( "EETauTree: Expected branch e2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenCharge")
        else:
            self.e2GenCharge_branch.SetAddress(<void*>&self.e2GenCharge_value)

        #print "making e2GenDirectPromptTauDecay"
        self.e2GenDirectPromptTauDecay_branch = the_tree.GetBranch("e2GenDirectPromptTauDecay")
        #if not self.e2GenDirectPromptTauDecay_branch and "e2GenDirectPromptTauDecay" not in self.complained:
        if not self.e2GenDirectPromptTauDecay_branch and "e2GenDirectPromptTauDecay":
            warnings.warn( "EETauTree: Expected branch e2GenDirectPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenDirectPromptTauDecay")
        else:
            self.e2GenDirectPromptTauDecay_branch.SetAddress(<void*>&self.e2GenDirectPromptTauDecay_value)

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

        #print "making e2GenIsPrompt"
        self.e2GenIsPrompt_branch = the_tree.GetBranch("e2GenIsPrompt")
        #if not self.e2GenIsPrompt_branch and "e2GenIsPrompt" not in self.complained:
        if not self.e2GenIsPrompt_branch and "e2GenIsPrompt":
            warnings.warn( "EETauTree: Expected branch e2GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenIsPrompt")
        else:
            self.e2GenIsPrompt_branch.SetAddress(<void*>&self.e2GenIsPrompt_value)

        #print "making e2GenMotherPdgId"
        self.e2GenMotherPdgId_branch = the_tree.GetBranch("e2GenMotherPdgId")
        #if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId" not in self.complained:
        if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId":
            warnings.warn( "EETauTree: Expected branch e2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenMotherPdgId")
        else:
            self.e2GenMotherPdgId_branch.SetAddress(<void*>&self.e2GenMotherPdgId_value)

        #print "making e2GenParticle"
        self.e2GenParticle_branch = the_tree.GetBranch("e2GenParticle")
        #if not self.e2GenParticle_branch and "e2GenParticle" not in self.complained:
        if not self.e2GenParticle_branch and "e2GenParticle":
            warnings.warn( "EETauTree: Expected branch e2GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenParticle")
        else:
            self.e2GenParticle_branch.SetAddress(<void*>&self.e2GenParticle_value)

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

        #print "making e2GenPrompt"
        self.e2GenPrompt_branch = the_tree.GetBranch("e2GenPrompt")
        #if not self.e2GenPrompt_branch and "e2GenPrompt" not in self.complained:
        if not self.e2GenPrompt_branch and "e2GenPrompt":
            warnings.warn( "EETauTree: Expected branch e2GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPrompt")
        else:
            self.e2GenPrompt_branch.SetAddress(<void*>&self.e2GenPrompt_value)

        #print "making e2GenPromptTauDecay"
        self.e2GenPromptTauDecay_branch = the_tree.GetBranch("e2GenPromptTauDecay")
        #if not self.e2GenPromptTauDecay_branch and "e2GenPromptTauDecay" not in self.complained:
        if not self.e2GenPromptTauDecay_branch and "e2GenPromptTauDecay":
            warnings.warn( "EETauTree: Expected branch e2GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPromptTauDecay")
        else:
            self.e2GenPromptTauDecay_branch.SetAddress(<void*>&self.e2GenPromptTauDecay_value)

        #print "making e2GenPt"
        self.e2GenPt_branch = the_tree.GetBranch("e2GenPt")
        #if not self.e2GenPt_branch and "e2GenPt" not in self.complained:
        if not self.e2GenPt_branch and "e2GenPt":
            warnings.warn( "EETauTree: Expected branch e2GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPt")
        else:
            self.e2GenPt_branch.SetAddress(<void*>&self.e2GenPt_value)

        #print "making e2GenTauDecay"
        self.e2GenTauDecay_branch = the_tree.GetBranch("e2GenTauDecay")
        #if not self.e2GenTauDecay_branch and "e2GenTauDecay" not in self.complained:
        if not self.e2GenTauDecay_branch and "e2GenTauDecay":
            warnings.warn( "EETauTree: Expected branch e2GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenTauDecay")
        else:
            self.e2GenTauDecay_branch.SetAddress(<void*>&self.e2GenTauDecay_value)

        #print "making e2GenVZ"
        self.e2GenVZ_branch = the_tree.GetBranch("e2GenVZ")
        #if not self.e2GenVZ_branch and "e2GenVZ" not in self.complained:
        if not self.e2GenVZ_branch and "e2GenVZ":
            warnings.warn( "EETauTree: Expected branch e2GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenVZ")
        else:
            self.e2GenVZ_branch.SetAddress(<void*>&self.e2GenVZ_value)

        #print "making e2GenVtxPVMatch"
        self.e2GenVtxPVMatch_branch = the_tree.GetBranch("e2GenVtxPVMatch")
        #if not self.e2GenVtxPVMatch_branch and "e2GenVtxPVMatch" not in self.complained:
        if not self.e2GenVtxPVMatch_branch and "e2GenVtxPVMatch":
            warnings.warn( "EETauTree: Expected branch e2GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenVtxPVMatch")
        else:
            self.e2GenVtxPVMatch_branch.SetAddress(<void*>&self.e2GenVtxPVMatch_value)

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

        #print "making e2HcalIsoDR03"
        self.e2HcalIsoDR03_branch = the_tree.GetBranch("e2HcalIsoDR03")
        #if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03" not in self.complained:
        if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03":
            warnings.warn( "EETauTree: Expected branch e2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HcalIsoDR03")
        else:
            self.e2HcalIsoDR03_branch.SetAddress(<void*>&self.e2HcalIsoDR03_value)

        #print "making e2IP3D"
        self.e2IP3D_branch = the_tree.GetBranch("e2IP3D")
        #if not self.e2IP3D_branch and "e2IP3D" not in self.complained:
        if not self.e2IP3D_branch and "e2IP3D":
            warnings.warn( "EETauTree: Expected branch e2IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IP3D")
        else:
            self.e2IP3D_branch.SetAddress(<void*>&self.e2IP3D_value)

        #print "making e2IP3DErr"
        self.e2IP3DErr_branch = the_tree.GetBranch("e2IP3DErr")
        #if not self.e2IP3DErr_branch and "e2IP3DErr" not in self.complained:
        if not self.e2IP3DErr_branch and "e2IP3DErr":
            warnings.warn( "EETauTree: Expected branch e2IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IP3DErr")
        else:
            self.e2IP3DErr_branch.SetAddress(<void*>&self.e2IP3DErr_value)

        #print "making e2IsoDB03"
        self.e2IsoDB03_branch = the_tree.GetBranch("e2IsoDB03")
        #if not self.e2IsoDB03_branch and "e2IsoDB03" not in self.complained:
        if not self.e2IsoDB03_branch and "e2IsoDB03":
            warnings.warn( "EETauTree: Expected branch e2IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IsoDB03")
        else:
            self.e2IsoDB03_branch.SetAddress(<void*>&self.e2IsoDB03_value)

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

        #print "making e2JetHadronFlavour"
        self.e2JetHadronFlavour_branch = the_tree.GetBranch("e2JetHadronFlavour")
        #if not self.e2JetHadronFlavour_branch and "e2JetHadronFlavour" not in self.complained:
        if not self.e2JetHadronFlavour_branch and "e2JetHadronFlavour":
            warnings.warn( "EETauTree: Expected branch e2JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetHadronFlavour")
        else:
            self.e2JetHadronFlavour_branch.SetAddress(<void*>&self.e2JetHadronFlavour_value)

        #print "making e2JetPFCISVBtag"
        self.e2JetPFCISVBtag_branch = the_tree.GetBranch("e2JetPFCISVBtag")
        #if not self.e2JetPFCISVBtag_branch and "e2JetPFCISVBtag" not in self.complained:
        if not self.e2JetPFCISVBtag_branch and "e2JetPFCISVBtag":
            warnings.warn( "EETauTree: Expected branch e2JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPFCISVBtag")
        else:
            self.e2JetPFCISVBtag_branch.SetAddress(<void*>&self.e2JetPFCISVBtag_value)

        #print "making e2JetPartonFlavour"
        self.e2JetPartonFlavour_branch = the_tree.GetBranch("e2JetPartonFlavour")
        #if not self.e2JetPartonFlavour_branch and "e2JetPartonFlavour" not in self.complained:
        if not self.e2JetPartonFlavour_branch and "e2JetPartonFlavour":
            warnings.warn( "EETauTree: Expected branch e2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPartonFlavour")
        else:
            self.e2JetPartonFlavour_branch.SetAddress(<void*>&self.e2JetPartonFlavour_value)

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

        #print "making e2LowestMll"
        self.e2LowestMll_branch = the_tree.GetBranch("e2LowestMll")
        #if not self.e2LowestMll_branch and "e2LowestMll" not in self.complained:
        if not self.e2LowestMll_branch and "e2LowestMll":
            warnings.warn( "EETauTree: Expected branch e2LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2LowestMll")
        else:
            self.e2LowestMll_branch.SetAddress(<void*>&self.e2LowestMll_value)

        #print "making e2MVANonTrigCategory"
        self.e2MVANonTrigCategory_branch = the_tree.GetBranch("e2MVANonTrigCategory")
        #if not self.e2MVANonTrigCategory_branch and "e2MVANonTrigCategory" not in self.complained:
        if not self.e2MVANonTrigCategory_branch and "e2MVANonTrigCategory":
            warnings.warn( "EETauTree: Expected branch e2MVANonTrigCategory does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANonTrigCategory")
        else:
            self.e2MVANonTrigCategory_branch.SetAddress(<void*>&self.e2MVANonTrigCategory_value)

        #print "making e2MVANonTrigID"
        self.e2MVANonTrigID_branch = the_tree.GetBranch("e2MVANonTrigID")
        #if not self.e2MVANonTrigID_branch and "e2MVANonTrigID" not in self.complained:
        if not self.e2MVANonTrigID_branch and "e2MVANonTrigID":
            warnings.warn( "EETauTree: Expected branch e2MVANonTrigID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANonTrigID")
        else:
            self.e2MVANonTrigID_branch.SetAddress(<void*>&self.e2MVANonTrigID_value)

        #print "making e2MVANonTrigWP80"
        self.e2MVANonTrigWP80_branch = the_tree.GetBranch("e2MVANonTrigWP80")
        #if not self.e2MVANonTrigWP80_branch and "e2MVANonTrigWP80" not in self.complained:
        if not self.e2MVANonTrigWP80_branch and "e2MVANonTrigWP80":
            warnings.warn( "EETauTree: Expected branch e2MVANonTrigWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANonTrigWP80")
        else:
            self.e2MVANonTrigWP80_branch.SetAddress(<void*>&self.e2MVANonTrigWP80_value)

        #print "making e2MVANonTrigWP90"
        self.e2MVANonTrigWP90_branch = the_tree.GetBranch("e2MVANonTrigWP90")
        #if not self.e2MVANonTrigWP90_branch and "e2MVANonTrigWP90" not in self.complained:
        if not self.e2MVANonTrigWP90_branch and "e2MVANonTrigWP90":
            warnings.warn( "EETauTree: Expected branch e2MVANonTrigWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANonTrigWP90")
        else:
            self.e2MVANonTrigWP90_branch.SetAddress(<void*>&self.e2MVANonTrigWP90_value)

        #print "making e2MVATrigCategory"
        self.e2MVATrigCategory_branch = the_tree.GetBranch("e2MVATrigCategory")
        #if not self.e2MVATrigCategory_branch and "e2MVATrigCategory" not in self.complained:
        if not self.e2MVATrigCategory_branch and "e2MVATrigCategory":
            warnings.warn( "EETauTree: Expected branch e2MVATrigCategory does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigCategory")
        else:
            self.e2MVATrigCategory_branch.SetAddress(<void*>&self.e2MVATrigCategory_value)

        #print "making e2MVATrigID"
        self.e2MVATrigID_branch = the_tree.GetBranch("e2MVATrigID")
        #if not self.e2MVATrigID_branch and "e2MVATrigID" not in self.complained:
        if not self.e2MVATrigID_branch and "e2MVATrigID":
            warnings.warn( "EETauTree: Expected branch e2MVATrigID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigID")
        else:
            self.e2MVATrigID_branch.SetAddress(<void*>&self.e2MVATrigID_value)

        #print "making e2MVATrigWP80"
        self.e2MVATrigWP80_branch = the_tree.GetBranch("e2MVATrigWP80")
        #if not self.e2MVATrigWP80_branch and "e2MVATrigWP80" not in self.complained:
        if not self.e2MVATrigWP80_branch and "e2MVATrigWP80":
            warnings.warn( "EETauTree: Expected branch e2MVATrigWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigWP80")
        else:
            self.e2MVATrigWP80_branch.SetAddress(<void*>&self.e2MVATrigWP80_value)

        #print "making e2MVATrigWP90"
        self.e2MVATrigWP90_branch = the_tree.GetBranch("e2MVATrigWP90")
        #if not self.e2MVATrigWP90_branch and "e2MVATrigWP90" not in self.complained:
        if not self.e2MVATrigWP90_branch and "e2MVATrigWP90":
            warnings.warn( "EETauTree: Expected branch e2MVATrigWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigWP90")
        else:
            self.e2MVATrigWP90_branch.SetAddress(<void*>&self.e2MVATrigWP90_value)

        #print "making e2Mass"
        self.e2Mass_branch = the_tree.GetBranch("e2Mass")
        #if not self.e2Mass_branch and "e2Mass" not in self.complained:
        if not self.e2Mass_branch and "e2Mass":
            warnings.warn( "EETauTree: Expected branch e2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mass")
        else:
            self.e2Mass_branch.SetAddress(<void*>&self.e2Mass_value)

        #print "making e2MatchesDoubleE"
        self.e2MatchesDoubleE_branch = the_tree.GetBranch("e2MatchesDoubleE")
        #if not self.e2MatchesDoubleE_branch and "e2MatchesDoubleE" not in self.complained:
        if not self.e2MatchesDoubleE_branch and "e2MatchesDoubleE":
            warnings.warn( "EETauTree: Expected branch e2MatchesDoubleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesDoubleE")
        else:
            self.e2MatchesDoubleE_branch.SetAddress(<void*>&self.e2MatchesDoubleE_value)

        #print "making e2MatchesDoubleESingleMu"
        self.e2MatchesDoubleESingleMu_branch = the_tree.GetBranch("e2MatchesDoubleESingleMu")
        #if not self.e2MatchesDoubleESingleMu_branch and "e2MatchesDoubleESingleMu" not in self.complained:
        if not self.e2MatchesDoubleESingleMu_branch and "e2MatchesDoubleESingleMu":
            warnings.warn( "EETauTree: Expected branch e2MatchesDoubleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesDoubleESingleMu")
        else:
            self.e2MatchesDoubleESingleMu_branch.SetAddress(<void*>&self.e2MatchesDoubleESingleMu_value)

        #print "making e2MatchesDoubleMuSingleE"
        self.e2MatchesDoubleMuSingleE_branch = the_tree.GetBranch("e2MatchesDoubleMuSingleE")
        #if not self.e2MatchesDoubleMuSingleE_branch and "e2MatchesDoubleMuSingleE" not in self.complained:
        if not self.e2MatchesDoubleMuSingleE_branch and "e2MatchesDoubleMuSingleE":
            warnings.warn( "EETauTree: Expected branch e2MatchesDoubleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesDoubleMuSingleE")
        else:
            self.e2MatchesDoubleMuSingleE_branch.SetAddress(<void*>&self.e2MatchesDoubleMuSingleE_value)

        #print "making e2MatchesEle115Filter"
        self.e2MatchesEle115Filter_branch = the_tree.GetBranch("e2MatchesEle115Filter")
        #if not self.e2MatchesEle115Filter_branch and "e2MatchesEle115Filter" not in self.complained:
        if not self.e2MatchesEle115Filter_branch and "e2MatchesEle115Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle115Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle115Filter")
        else:
            self.e2MatchesEle115Filter_branch.SetAddress(<void*>&self.e2MatchesEle115Filter_value)

        #print "making e2MatchesEle115Path"
        self.e2MatchesEle115Path_branch = the_tree.GetBranch("e2MatchesEle115Path")
        #if not self.e2MatchesEle115Path_branch and "e2MatchesEle115Path" not in self.complained:
        if not self.e2MatchesEle115Path_branch and "e2MatchesEle115Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle115Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle115Path")
        else:
            self.e2MatchesEle115Path_branch.SetAddress(<void*>&self.e2MatchesEle115Path_value)

        #print "making e2MatchesEle24Tau20Filter"
        self.e2MatchesEle24Tau20Filter_branch = the_tree.GetBranch("e2MatchesEle24Tau20Filter")
        #if not self.e2MatchesEle24Tau20Filter_branch and "e2MatchesEle24Tau20Filter" not in self.complained:
        if not self.e2MatchesEle24Tau20Filter_branch and "e2MatchesEle24Tau20Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle24Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24Tau20Filter")
        else:
            self.e2MatchesEle24Tau20Filter_branch.SetAddress(<void*>&self.e2MatchesEle24Tau20Filter_value)

        #print "making e2MatchesEle24Tau20Path"
        self.e2MatchesEle24Tau20Path_branch = the_tree.GetBranch("e2MatchesEle24Tau20Path")
        #if not self.e2MatchesEle24Tau20Path_branch and "e2MatchesEle24Tau20Path" not in self.complained:
        if not self.e2MatchesEle24Tau20Path_branch and "e2MatchesEle24Tau20Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle24Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24Tau20Path")
        else:
            self.e2MatchesEle24Tau20Path_branch.SetAddress(<void*>&self.e2MatchesEle24Tau20Path_value)

        #print "making e2MatchesEle24Tau20sL1Filter"
        self.e2MatchesEle24Tau20sL1Filter_branch = the_tree.GetBranch("e2MatchesEle24Tau20sL1Filter")
        #if not self.e2MatchesEle24Tau20sL1Filter_branch and "e2MatchesEle24Tau20sL1Filter" not in self.complained:
        if not self.e2MatchesEle24Tau20sL1Filter_branch and "e2MatchesEle24Tau20sL1Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle24Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24Tau20sL1Filter")
        else:
            self.e2MatchesEle24Tau20sL1Filter_branch.SetAddress(<void*>&self.e2MatchesEle24Tau20sL1Filter_value)

        #print "making e2MatchesEle24Tau20sL1Path"
        self.e2MatchesEle24Tau20sL1Path_branch = the_tree.GetBranch("e2MatchesEle24Tau20sL1Path")
        #if not self.e2MatchesEle24Tau20sL1Path_branch and "e2MatchesEle24Tau20sL1Path" not in self.complained:
        if not self.e2MatchesEle24Tau20sL1Path_branch and "e2MatchesEle24Tau20sL1Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle24Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24Tau20sL1Path")
        else:
            self.e2MatchesEle24Tau20sL1Path_branch.SetAddress(<void*>&self.e2MatchesEle24Tau20sL1Path_value)

        #print "making e2MatchesEle24Tau30Filter"
        self.e2MatchesEle24Tau30Filter_branch = the_tree.GetBranch("e2MatchesEle24Tau30Filter")
        #if not self.e2MatchesEle24Tau30Filter_branch and "e2MatchesEle24Tau30Filter" not in self.complained:
        if not self.e2MatchesEle24Tau30Filter_branch and "e2MatchesEle24Tau30Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24Tau30Filter")
        else:
            self.e2MatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.e2MatchesEle24Tau30Filter_value)

        #print "making e2MatchesEle24Tau30Path"
        self.e2MatchesEle24Tau30Path_branch = the_tree.GetBranch("e2MatchesEle24Tau30Path")
        #if not self.e2MatchesEle24Tau30Path_branch and "e2MatchesEle24Tau30Path" not in self.complained:
        if not self.e2MatchesEle24Tau30Path_branch and "e2MatchesEle24Tau30Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24Tau30Path")
        else:
            self.e2MatchesEle24Tau30Path_branch.SetAddress(<void*>&self.e2MatchesEle24Tau30Path_value)

        #print "making e2MatchesEle25LooseFilter"
        self.e2MatchesEle25LooseFilter_branch = the_tree.GetBranch("e2MatchesEle25LooseFilter")
        #if not self.e2MatchesEle25LooseFilter_branch and "e2MatchesEle25LooseFilter" not in self.complained:
        if not self.e2MatchesEle25LooseFilter_branch and "e2MatchesEle25LooseFilter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle25LooseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle25LooseFilter")
        else:
            self.e2MatchesEle25LooseFilter_branch.SetAddress(<void*>&self.e2MatchesEle25LooseFilter_value)

        #print "making e2MatchesEle25TightFilter"
        self.e2MatchesEle25TightFilter_branch = the_tree.GetBranch("e2MatchesEle25TightFilter")
        #if not self.e2MatchesEle25TightFilter_branch and "e2MatchesEle25TightFilter" not in self.complained:
        if not self.e2MatchesEle25TightFilter_branch and "e2MatchesEle25TightFilter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle25TightFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle25TightFilter")
        else:
            self.e2MatchesEle25TightFilter_branch.SetAddress(<void*>&self.e2MatchesEle25TightFilter_value)

        #print "making e2MatchesEle25eta2p1TightFilter"
        self.e2MatchesEle25eta2p1TightFilter_branch = the_tree.GetBranch("e2MatchesEle25eta2p1TightFilter")
        #if not self.e2MatchesEle25eta2p1TightFilter_branch and "e2MatchesEle25eta2p1TightFilter" not in self.complained:
        if not self.e2MatchesEle25eta2p1TightFilter_branch and "e2MatchesEle25eta2p1TightFilter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle25eta2p1TightFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle25eta2p1TightFilter")
        else:
            self.e2MatchesEle25eta2p1TightFilter_branch.SetAddress(<void*>&self.e2MatchesEle25eta2p1TightFilter_value)

        #print "making e2MatchesEle25eta2p1TightPath"
        self.e2MatchesEle25eta2p1TightPath_branch = the_tree.GetBranch("e2MatchesEle25eta2p1TightPath")
        #if not self.e2MatchesEle25eta2p1TightPath_branch and "e2MatchesEle25eta2p1TightPath" not in self.complained:
        if not self.e2MatchesEle25eta2p1TightPath_branch and "e2MatchesEle25eta2p1TightPath":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle25eta2p1TightPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle25eta2p1TightPath")
        else:
            self.e2MatchesEle25eta2p1TightPath_branch.SetAddress(<void*>&self.e2MatchesEle25eta2p1TightPath_value)

        #print "making e2MatchesEle27TightFilter"
        self.e2MatchesEle27TightFilter_branch = the_tree.GetBranch("e2MatchesEle27TightFilter")
        #if not self.e2MatchesEle27TightFilter_branch and "e2MatchesEle27TightFilter" not in self.complained:
        if not self.e2MatchesEle27TightFilter_branch and "e2MatchesEle27TightFilter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle27TightFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle27TightFilter")
        else:
            self.e2MatchesEle27TightFilter_branch.SetAddress(<void*>&self.e2MatchesEle27TightFilter_value)

        #print "making e2MatchesEle27TightPath"
        self.e2MatchesEle27TightPath_branch = the_tree.GetBranch("e2MatchesEle27TightPath")
        #if not self.e2MatchesEle27TightPath_branch and "e2MatchesEle27TightPath" not in self.complained:
        if not self.e2MatchesEle27TightPath_branch and "e2MatchesEle27TightPath":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle27TightPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle27TightPath")
        else:
            self.e2MatchesEle27TightPath_branch.SetAddress(<void*>&self.e2MatchesEle27TightPath_value)

        #print "making e2MatchesEle27eta2p1LooseFilter"
        self.e2MatchesEle27eta2p1LooseFilter_branch = the_tree.GetBranch("e2MatchesEle27eta2p1LooseFilter")
        #if not self.e2MatchesEle27eta2p1LooseFilter_branch and "e2MatchesEle27eta2p1LooseFilter" not in self.complained:
        if not self.e2MatchesEle27eta2p1LooseFilter_branch and "e2MatchesEle27eta2p1LooseFilter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle27eta2p1LooseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle27eta2p1LooseFilter")
        else:
            self.e2MatchesEle27eta2p1LooseFilter_branch.SetAddress(<void*>&self.e2MatchesEle27eta2p1LooseFilter_value)

        #print "making e2MatchesEle27eta2p1LoosePath"
        self.e2MatchesEle27eta2p1LoosePath_branch = the_tree.GetBranch("e2MatchesEle27eta2p1LoosePath")
        #if not self.e2MatchesEle27eta2p1LoosePath_branch and "e2MatchesEle27eta2p1LoosePath" not in self.complained:
        if not self.e2MatchesEle27eta2p1LoosePath_branch and "e2MatchesEle27eta2p1LoosePath":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle27eta2p1LoosePath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle27eta2p1LoosePath")
        else:
            self.e2MatchesEle27eta2p1LoosePath_branch.SetAddress(<void*>&self.e2MatchesEle27eta2p1LoosePath_value)

        #print "making e2MatchesEle45L1JetTauPath"
        self.e2MatchesEle45L1JetTauPath_branch = the_tree.GetBranch("e2MatchesEle45L1JetTauPath")
        #if not self.e2MatchesEle45L1JetTauPath_branch and "e2MatchesEle45L1JetTauPath" not in self.complained:
        if not self.e2MatchesEle45L1JetTauPath_branch and "e2MatchesEle45L1JetTauPath":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle45L1JetTauPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle45L1JetTauPath")
        else:
            self.e2MatchesEle45L1JetTauPath_branch.SetAddress(<void*>&self.e2MatchesEle45L1JetTauPath_value)

        #print "making e2MatchesEle45LooseL1JetTauFilter"
        self.e2MatchesEle45LooseL1JetTauFilter_branch = the_tree.GetBranch("e2MatchesEle45LooseL1JetTauFilter")
        #if not self.e2MatchesEle45LooseL1JetTauFilter_branch and "e2MatchesEle45LooseL1JetTauFilter" not in self.complained:
        if not self.e2MatchesEle45LooseL1JetTauFilter_branch and "e2MatchesEle45LooseL1JetTauFilter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle45LooseL1JetTauFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle45LooseL1JetTauFilter")
        else:
            self.e2MatchesEle45LooseL1JetTauFilter_branch.SetAddress(<void*>&self.e2MatchesEle45LooseL1JetTauFilter_value)

        #print "making e2MatchesMu23Ele12DZFilter"
        self.e2MatchesMu23Ele12DZFilter_branch = the_tree.GetBranch("e2MatchesMu23Ele12DZFilter")
        #if not self.e2MatchesMu23Ele12DZFilter_branch and "e2MatchesMu23Ele12DZFilter" not in self.complained:
        if not self.e2MatchesMu23Ele12DZFilter_branch and "e2MatchesMu23Ele12DZFilter":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu23Ele12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23Ele12DZFilter")
        else:
            self.e2MatchesMu23Ele12DZFilter_branch.SetAddress(<void*>&self.e2MatchesMu23Ele12DZFilter_value)

        #print "making e2MatchesMu23Ele12DZPath"
        self.e2MatchesMu23Ele12DZPath_branch = the_tree.GetBranch("e2MatchesMu23Ele12DZPath")
        #if not self.e2MatchesMu23Ele12DZPath_branch and "e2MatchesMu23Ele12DZPath" not in self.complained:
        if not self.e2MatchesMu23Ele12DZPath_branch and "e2MatchesMu23Ele12DZPath":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu23Ele12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23Ele12DZPath")
        else:
            self.e2MatchesMu23Ele12DZPath_branch.SetAddress(<void*>&self.e2MatchesMu23Ele12DZPath_value)

        #print "making e2MatchesMu23Ele12Filter"
        self.e2MatchesMu23Ele12Filter_branch = the_tree.GetBranch("e2MatchesMu23Ele12Filter")
        #if not self.e2MatchesMu23Ele12Filter_branch and "e2MatchesMu23Ele12Filter" not in self.complained:
        if not self.e2MatchesMu23Ele12Filter_branch and "e2MatchesMu23Ele12Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu23Ele12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23Ele12Filter")
        else:
            self.e2MatchesMu23Ele12Filter_branch.SetAddress(<void*>&self.e2MatchesMu23Ele12Filter_value)

        #print "making e2MatchesMu23Ele12Path"
        self.e2MatchesMu23Ele12Path_branch = the_tree.GetBranch("e2MatchesMu23Ele12Path")
        #if not self.e2MatchesMu23Ele12Path_branch and "e2MatchesMu23Ele12Path" not in self.complained:
        if not self.e2MatchesMu23Ele12Path_branch and "e2MatchesMu23Ele12Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu23Ele12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23Ele12Path")
        else:
            self.e2MatchesMu23Ele12Path_branch.SetAddress(<void*>&self.e2MatchesMu23Ele12Path_value)

        #print "making e2MatchesMu23Ele8DZFilter"
        self.e2MatchesMu23Ele8DZFilter_branch = the_tree.GetBranch("e2MatchesMu23Ele8DZFilter")
        #if not self.e2MatchesMu23Ele8DZFilter_branch and "e2MatchesMu23Ele8DZFilter" not in self.complained:
        if not self.e2MatchesMu23Ele8DZFilter_branch and "e2MatchesMu23Ele8DZFilter":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu23Ele8DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23Ele8DZFilter")
        else:
            self.e2MatchesMu23Ele8DZFilter_branch.SetAddress(<void*>&self.e2MatchesMu23Ele8DZFilter_value)

        #print "making e2MatchesMu23Ele8DZPath"
        self.e2MatchesMu23Ele8DZPath_branch = the_tree.GetBranch("e2MatchesMu23Ele8DZPath")
        #if not self.e2MatchesMu23Ele8DZPath_branch and "e2MatchesMu23Ele8DZPath" not in self.complained:
        if not self.e2MatchesMu23Ele8DZPath_branch and "e2MatchesMu23Ele8DZPath":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu23Ele8DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23Ele8DZPath")
        else:
            self.e2MatchesMu23Ele8DZPath_branch.SetAddress(<void*>&self.e2MatchesMu23Ele8DZPath_value)

        #print "making e2MatchesMu23Ele8Filter"
        self.e2MatchesMu23Ele8Filter_branch = the_tree.GetBranch("e2MatchesMu23Ele8Filter")
        #if not self.e2MatchesMu23Ele8Filter_branch and "e2MatchesMu23Ele8Filter" not in self.complained:
        if not self.e2MatchesMu23Ele8Filter_branch and "e2MatchesMu23Ele8Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu23Ele8Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23Ele8Filter")
        else:
            self.e2MatchesMu23Ele8Filter_branch.SetAddress(<void*>&self.e2MatchesMu23Ele8Filter_value)

        #print "making e2MatchesMu23Ele8Path"
        self.e2MatchesMu23Ele8Path_branch = the_tree.GetBranch("e2MatchesMu23Ele8Path")
        #if not self.e2MatchesMu23Ele8Path_branch and "e2MatchesMu23Ele8Path" not in self.complained:
        if not self.e2MatchesMu23Ele8Path_branch and "e2MatchesMu23Ele8Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu23Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23Ele8Path")
        else:
            self.e2MatchesMu23Ele8Path_branch.SetAddress(<void*>&self.e2MatchesMu23Ele8Path_value)

        #print "making e2MatchesMu8Ele23DZFilter"
        self.e2MatchesMu8Ele23DZFilter_branch = the_tree.GetBranch("e2MatchesMu8Ele23DZFilter")
        #if not self.e2MatchesMu8Ele23DZFilter_branch and "e2MatchesMu8Ele23DZFilter" not in self.complained:
        if not self.e2MatchesMu8Ele23DZFilter_branch and "e2MatchesMu8Ele23DZFilter":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu8Ele23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8Ele23DZFilter")
        else:
            self.e2MatchesMu8Ele23DZFilter_branch.SetAddress(<void*>&self.e2MatchesMu8Ele23DZFilter_value)

        #print "making e2MatchesMu8Ele23DZPath"
        self.e2MatchesMu8Ele23DZPath_branch = the_tree.GetBranch("e2MatchesMu8Ele23DZPath")
        #if not self.e2MatchesMu8Ele23DZPath_branch and "e2MatchesMu8Ele23DZPath" not in self.complained:
        if not self.e2MatchesMu8Ele23DZPath_branch and "e2MatchesMu8Ele23DZPath":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu8Ele23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8Ele23DZPath")
        else:
            self.e2MatchesMu8Ele23DZPath_branch.SetAddress(<void*>&self.e2MatchesMu8Ele23DZPath_value)

        #print "making e2MatchesMu8Ele23Filter"
        self.e2MatchesMu8Ele23Filter_branch = the_tree.GetBranch("e2MatchesMu8Ele23Filter")
        #if not self.e2MatchesMu8Ele23Filter_branch and "e2MatchesMu8Ele23Filter" not in self.complained:
        if not self.e2MatchesMu8Ele23Filter_branch and "e2MatchesMu8Ele23Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu8Ele23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8Ele23Filter")
        else:
            self.e2MatchesMu8Ele23Filter_branch.SetAddress(<void*>&self.e2MatchesMu8Ele23Filter_value)

        #print "making e2MatchesMu8Ele23Path"
        self.e2MatchesMu8Ele23Path_branch = the_tree.GetBranch("e2MatchesMu8Ele23Path")
        #if not self.e2MatchesMu8Ele23Path_branch and "e2MatchesMu8Ele23Path" not in self.complained:
        if not self.e2MatchesMu8Ele23Path_branch and "e2MatchesMu8Ele23Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu8Ele23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8Ele23Path")
        else:
            self.e2MatchesMu8Ele23Path_branch.SetAddress(<void*>&self.e2MatchesMu8Ele23Path_value)

        #print "making e2MatchesSingleE"
        self.e2MatchesSingleE_branch = the_tree.GetBranch("e2MatchesSingleE")
        #if not self.e2MatchesSingleE_branch and "e2MatchesSingleE" not in self.complained:
        if not self.e2MatchesSingleE_branch and "e2MatchesSingleE":
            warnings.warn( "EETauTree: Expected branch e2MatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesSingleE")
        else:
            self.e2MatchesSingleE_branch.SetAddress(<void*>&self.e2MatchesSingleE_value)

        #print "making e2MatchesSingleESingleMu"
        self.e2MatchesSingleESingleMu_branch = the_tree.GetBranch("e2MatchesSingleESingleMu")
        #if not self.e2MatchesSingleESingleMu_branch and "e2MatchesSingleESingleMu" not in self.complained:
        if not self.e2MatchesSingleESingleMu_branch and "e2MatchesSingleESingleMu":
            warnings.warn( "EETauTree: Expected branch e2MatchesSingleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesSingleESingleMu")
        else:
            self.e2MatchesSingleESingleMu_branch.SetAddress(<void*>&self.e2MatchesSingleESingleMu_value)

        #print "making e2MatchesSingleE_leg1"
        self.e2MatchesSingleE_leg1_branch = the_tree.GetBranch("e2MatchesSingleE_leg1")
        #if not self.e2MatchesSingleE_leg1_branch and "e2MatchesSingleE_leg1" not in self.complained:
        if not self.e2MatchesSingleE_leg1_branch and "e2MatchesSingleE_leg1":
            warnings.warn( "EETauTree: Expected branch e2MatchesSingleE_leg1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesSingleE_leg1")
        else:
            self.e2MatchesSingleE_leg1_branch.SetAddress(<void*>&self.e2MatchesSingleE_leg1_value)

        #print "making e2MatchesSingleE_leg2"
        self.e2MatchesSingleE_leg2_branch = the_tree.GetBranch("e2MatchesSingleE_leg2")
        #if not self.e2MatchesSingleE_leg2_branch and "e2MatchesSingleE_leg2" not in self.complained:
        if not self.e2MatchesSingleE_leg2_branch and "e2MatchesSingleE_leg2":
            warnings.warn( "EETauTree: Expected branch e2MatchesSingleE_leg2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesSingleE_leg2")
        else:
            self.e2MatchesSingleE_leg2_branch.SetAddress(<void*>&self.e2MatchesSingleE_leg2_value)

        #print "making e2MatchesSingleMuSingleE"
        self.e2MatchesSingleMuSingleE_branch = the_tree.GetBranch("e2MatchesSingleMuSingleE")
        #if not self.e2MatchesSingleMuSingleE_branch and "e2MatchesSingleMuSingleE" not in self.complained:
        if not self.e2MatchesSingleMuSingleE_branch and "e2MatchesSingleMuSingleE":
            warnings.warn( "EETauTree: Expected branch e2MatchesSingleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesSingleMuSingleE")
        else:
            self.e2MatchesSingleMuSingleE_branch.SetAddress(<void*>&self.e2MatchesSingleMuSingleE_value)

        #print "making e2MatchesTripleE"
        self.e2MatchesTripleE_branch = the_tree.GetBranch("e2MatchesTripleE")
        #if not self.e2MatchesTripleE_branch and "e2MatchesTripleE" not in self.complained:
        if not self.e2MatchesTripleE_branch and "e2MatchesTripleE":
            warnings.warn( "EETauTree: Expected branch e2MatchesTripleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesTripleE")
        else:
            self.e2MatchesTripleE_branch.SetAddress(<void*>&self.e2MatchesTripleE_value)

        #print "making e2MissingHits"
        self.e2MissingHits_branch = the_tree.GetBranch("e2MissingHits")
        #if not self.e2MissingHits_branch and "e2MissingHits" not in self.complained:
        if not self.e2MissingHits_branch and "e2MissingHits":
            warnings.warn( "EETauTree: Expected branch e2MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MissingHits")
        else:
            self.e2MissingHits_branch.SetAddress(<void*>&self.e2MissingHits_value)

        #print "making e2MtToPfMet_type1"
        self.e2MtToPfMet_type1_branch = the_tree.GetBranch("e2MtToPfMet_type1")
        #if not self.e2MtToPfMet_type1_branch and "e2MtToPfMet_type1" not in self.complained:
        if not self.e2MtToPfMet_type1_branch and "e2MtToPfMet_type1":
            warnings.warn( "EETauTree: Expected branch e2MtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_type1")
        else:
            self.e2MtToPfMet_type1_branch.SetAddress(<void*>&self.e2MtToPfMet_type1_value)

        #print "making e2NearMuonVeto"
        self.e2NearMuonVeto_branch = the_tree.GetBranch("e2NearMuonVeto")
        #if not self.e2NearMuonVeto_branch and "e2NearMuonVeto" not in self.complained:
        if not self.e2NearMuonVeto_branch and "e2NearMuonVeto":
            warnings.warn( "EETauTree: Expected branch e2NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearMuonVeto")
        else:
            self.e2NearMuonVeto_branch.SetAddress(<void*>&self.e2NearMuonVeto_value)

        #print "making e2NearestMuonDR"
        self.e2NearestMuonDR_branch = the_tree.GetBranch("e2NearestMuonDR")
        #if not self.e2NearestMuonDR_branch and "e2NearestMuonDR" not in self.complained:
        if not self.e2NearestMuonDR_branch and "e2NearestMuonDR":
            warnings.warn( "EETauTree: Expected branch e2NearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearestMuonDR")
        else:
            self.e2NearestMuonDR_branch.SetAddress(<void*>&self.e2NearestMuonDR_value)

        #print "making e2NearestZMass"
        self.e2NearestZMass_branch = the_tree.GetBranch("e2NearestZMass")
        #if not self.e2NearestZMass_branch and "e2NearestZMass" not in self.complained:
        if not self.e2NearestZMass_branch and "e2NearestZMass":
            warnings.warn( "EETauTree: Expected branch e2NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearestZMass")
        else:
            self.e2NearestZMass_branch.SetAddress(<void*>&self.e2NearestZMass_value)

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

        #print "making e2PFPUChargedIso"
        self.e2PFPUChargedIso_branch = the_tree.GetBranch("e2PFPUChargedIso")
        #if not self.e2PFPUChargedIso_branch and "e2PFPUChargedIso" not in self.complained:
        if not self.e2PFPUChargedIso_branch and "e2PFPUChargedIso":
            warnings.warn( "EETauTree: Expected branch e2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFPUChargedIso")
        else:
            self.e2PFPUChargedIso_branch.SetAddress(<void*>&self.e2PFPUChargedIso_value)

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

        #print "making e2PassesConversionVeto"
        self.e2PassesConversionVeto_branch = the_tree.GetBranch("e2PassesConversionVeto")
        #if not self.e2PassesConversionVeto_branch and "e2PassesConversionVeto" not in self.complained:
        if not self.e2PassesConversionVeto_branch and "e2PassesConversionVeto":
            warnings.warn( "EETauTree: Expected branch e2PassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PassesConversionVeto")
        else:
            self.e2PassesConversionVeto_branch.SetAddress(<void*>&self.e2PassesConversionVeto_value)

        #print "making e2Phi"
        self.e2Phi_branch = the_tree.GetBranch("e2Phi")
        #if not self.e2Phi_branch and "e2Phi" not in self.complained:
        if not self.e2Phi_branch and "e2Phi":
            warnings.warn( "EETauTree: Expected branch e2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Phi")
        else:
            self.e2Phi_branch.SetAddress(<void*>&self.e2Phi_value)

        #print "making e2Phi_ElectronEnDown"
        self.e2Phi_ElectronEnDown_branch = the_tree.GetBranch("e2Phi_ElectronEnDown")
        #if not self.e2Phi_ElectronEnDown_branch and "e2Phi_ElectronEnDown" not in self.complained:
        if not self.e2Phi_ElectronEnDown_branch and "e2Phi_ElectronEnDown":
            warnings.warn( "EETauTree: Expected branch e2Phi_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Phi_ElectronEnDown")
        else:
            self.e2Phi_ElectronEnDown_branch.SetAddress(<void*>&self.e2Phi_ElectronEnDown_value)

        #print "making e2Phi_ElectronEnUp"
        self.e2Phi_ElectronEnUp_branch = the_tree.GetBranch("e2Phi_ElectronEnUp")
        #if not self.e2Phi_ElectronEnUp_branch and "e2Phi_ElectronEnUp" not in self.complained:
        if not self.e2Phi_ElectronEnUp_branch and "e2Phi_ElectronEnUp":
            warnings.warn( "EETauTree: Expected branch e2Phi_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Phi_ElectronEnUp")
        else:
            self.e2Phi_ElectronEnUp_branch.SetAddress(<void*>&self.e2Phi_ElectronEnUp_value)

        #print "making e2Pt"
        self.e2Pt_branch = the_tree.GetBranch("e2Pt")
        #if not self.e2Pt_branch and "e2Pt" not in self.complained:
        if not self.e2Pt_branch and "e2Pt":
            warnings.warn( "EETauTree: Expected branch e2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt")
        else:
            self.e2Pt_branch.SetAddress(<void*>&self.e2Pt_value)

        #print "making e2Pt_ElectronEnDown"
        self.e2Pt_ElectronEnDown_branch = the_tree.GetBranch("e2Pt_ElectronEnDown")
        #if not self.e2Pt_ElectronEnDown_branch and "e2Pt_ElectronEnDown" not in self.complained:
        if not self.e2Pt_ElectronEnDown_branch and "e2Pt_ElectronEnDown":
            warnings.warn( "EETauTree: Expected branch e2Pt_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt_ElectronEnDown")
        else:
            self.e2Pt_ElectronEnDown_branch.SetAddress(<void*>&self.e2Pt_ElectronEnDown_value)

        #print "making e2Pt_ElectronEnUp"
        self.e2Pt_ElectronEnUp_branch = the_tree.GetBranch("e2Pt_ElectronEnUp")
        #if not self.e2Pt_ElectronEnUp_branch and "e2Pt_ElectronEnUp" not in self.complained:
        if not self.e2Pt_ElectronEnUp_branch and "e2Pt_ElectronEnUp":
            warnings.warn( "EETauTree: Expected branch e2Pt_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt_ElectronEnUp")
        else:
            self.e2Pt_ElectronEnUp_branch.SetAddress(<void*>&self.e2Pt_ElectronEnUp_value)

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

        #print "making e2Rho"
        self.e2Rho_branch = the_tree.GetBranch("e2Rho")
        #if not self.e2Rho_branch and "e2Rho" not in self.complained:
        if not self.e2Rho_branch and "e2Rho":
            warnings.warn( "EETauTree: Expected branch e2Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Rho")
        else:
            self.e2Rho_branch.SetAddress(<void*>&self.e2Rho_value)

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

        #print "making e2SIP2D"
        self.e2SIP2D_branch = the_tree.GetBranch("e2SIP2D")
        #if not self.e2SIP2D_branch and "e2SIP2D" not in self.complained:
        if not self.e2SIP2D_branch and "e2SIP2D":
            warnings.warn( "EETauTree: Expected branch e2SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SIP2D")
        else:
            self.e2SIP2D_branch.SetAddress(<void*>&self.e2SIP2D_value)

        #print "making e2SIP3D"
        self.e2SIP3D_branch = the_tree.GetBranch("e2SIP3D")
        #if not self.e2SIP3D_branch and "e2SIP3D" not in self.complained:
        if not self.e2SIP3D_branch and "e2SIP3D":
            warnings.warn( "EETauTree: Expected branch e2SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SIP3D")
        else:
            self.e2SIP3D_branch.SetAddress(<void*>&self.e2SIP3D_value)

        #print "making e2SigmaIEtaIEta"
        self.e2SigmaIEtaIEta_branch = the_tree.GetBranch("e2SigmaIEtaIEta")
        #if not self.e2SigmaIEtaIEta_branch and "e2SigmaIEtaIEta" not in self.complained:
        if not self.e2SigmaIEtaIEta_branch and "e2SigmaIEtaIEta":
            warnings.warn( "EETauTree: Expected branch e2SigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SigmaIEtaIEta")
        else:
            self.e2SigmaIEtaIEta_branch.SetAddress(<void*>&self.e2SigmaIEtaIEta_value)

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

        #print "making e2WWLoose"
        self.e2WWLoose_branch = the_tree.GetBranch("e2WWLoose")
        #if not self.e2WWLoose_branch and "e2WWLoose" not in self.complained:
        if not self.e2WWLoose_branch and "e2WWLoose":
            warnings.warn( "EETauTree: Expected branch e2WWLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2WWLoose")
        else:
            self.e2WWLoose_branch.SetAddress(<void*>&self.e2WWLoose_value)

        #print "making e2ZTTGenMatching"
        self.e2ZTTGenMatching_branch = the_tree.GetBranch("e2ZTTGenMatching")
        #if not self.e2ZTTGenMatching_branch and "e2ZTTGenMatching" not in self.complained:
        if not self.e2ZTTGenMatching_branch and "e2ZTTGenMatching":
            warnings.warn( "EETauTree: Expected branch e2ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ZTTGenMatching")
        else:
            self.e2ZTTGenMatching_branch.SetAddress(<void*>&self.e2ZTTGenMatching_value)

        #print "making e2_e1_collinearmass"
        self.e2_e1_collinearmass_branch = the_tree.GetBranch("e2_e1_collinearmass")
        #if not self.e2_e1_collinearmass_branch and "e2_e1_collinearmass" not in self.complained:
        if not self.e2_e1_collinearmass_branch and "e2_e1_collinearmass":
            warnings.warn( "EETauTree: Expected branch e2_e1_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e1_collinearmass")
        else:
            self.e2_e1_collinearmass_branch.SetAddress(<void*>&self.e2_e1_collinearmass_value)

        #print "making e2_e1_collinearmass_CheckUESDown"
        self.e2_e1_collinearmass_CheckUESDown_branch = the_tree.GetBranch("e2_e1_collinearmass_CheckUESDown")
        #if not self.e2_e1_collinearmass_CheckUESDown_branch and "e2_e1_collinearmass_CheckUESDown" not in self.complained:
        if not self.e2_e1_collinearmass_CheckUESDown_branch and "e2_e1_collinearmass_CheckUESDown":
            warnings.warn( "EETauTree: Expected branch e2_e1_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e1_collinearmass_CheckUESDown")
        else:
            self.e2_e1_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.e2_e1_collinearmass_CheckUESDown_value)

        #print "making e2_e1_collinearmass_CheckUESUp"
        self.e2_e1_collinearmass_CheckUESUp_branch = the_tree.GetBranch("e2_e1_collinearmass_CheckUESUp")
        #if not self.e2_e1_collinearmass_CheckUESUp_branch and "e2_e1_collinearmass_CheckUESUp" not in self.complained:
        if not self.e2_e1_collinearmass_CheckUESUp_branch and "e2_e1_collinearmass_CheckUESUp":
            warnings.warn( "EETauTree: Expected branch e2_e1_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e1_collinearmass_CheckUESUp")
        else:
            self.e2_e1_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.e2_e1_collinearmass_CheckUESUp_value)

        #print "making e2_e1_collinearmass_JetCheckTotalDown"
        self.e2_e1_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("e2_e1_collinearmass_JetCheckTotalDown")
        #if not self.e2_e1_collinearmass_JetCheckTotalDown_branch and "e2_e1_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.e2_e1_collinearmass_JetCheckTotalDown_branch and "e2_e1_collinearmass_JetCheckTotalDown":
            warnings.warn( "EETauTree: Expected branch e2_e1_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e1_collinearmass_JetCheckTotalDown")
        else:
            self.e2_e1_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.e2_e1_collinearmass_JetCheckTotalDown_value)

        #print "making e2_e1_collinearmass_JetCheckTotalUp"
        self.e2_e1_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("e2_e1_collinearmass_JetCheckTotalUp")
        #if not self.e2_e1_collinearmass_JetCheckTotalUp_branch and "e2_e1_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.e2_e1_collinearmass_JetCheckTotalUp_branch and "e2_e1_collinearmass_JetCheckTotalUp":
            warnings.warn( "EETauTree: Expected branch e2_e1_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e1_collinearmass_JetCheckTotalUp")
        else:
            self.e2_e1_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.e2_e1_collinearmass_JetCheckTotalUp_value)

        #print "making e2_e1_collinearmass_JetEnDown"
        self.e2_e1_collinearmass_JetEnDown_branch = the_tree.GetBranch("e2_e1_collinearmass_JetEnDown")
        #if not self.e2_e1_collinearmass_JetEnDown_branch and "e2_e1_collinearmass_JetEnDown" not in self.complained:
        if not self.e2_e1_collinearmass_JetEnDown_branch and "e2_e1_collinearmass_JetEnDown":
            warnings.warn( "EETauTree: Expected branch e2_e1_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e1_collinearmass_JetEnDown")
        else:
            self.e2_e1_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.e2_e1_collinearmass_JetEnDown_value)

        #print "making e2_e1_collinearmass_JetEnUp"
        self.e2_e1_collinearmass_JetEnUp_branch = the_tree.GetBranch("e2_e1_collinearmass_JetEnUp")
        #if not self.e2_e1_collinearmass_JetEnUp_branch and "e2_e1_collinearmass_JetEnUp" not in self.complained:
        if not self.e2_e1_collinearmass_JetEnUp_branch and "e2_e1_collinearmass_JetEnUp":
            warnings.warn( "EETauTree: Expected branch e2_e1_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e1_collinearmass_JetEnUp")
        else:
            self.e2_e1_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.e2_e1_collinearmass_JetEnUp_value)

        #print "making e2_e1_collinearmass_UnclusteredEnDown"
        self.e2_e1_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("e2_e1_collinearmass_UnclusteredEnDown")
        #if not self.e2_e1_collinearmass_UnclusteredEnDown_branch and "e2_e1_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.e2_e1_collinearmass_UnclusteredEnDown_branch and "e2_e1_collinearmass_UnclusteredEnDown":
            warnings.warn( "EETauTree: Expected branch e2_e1_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e1_collinearmass_UnclusteredEnDown")
        else:
            self.e2_e1_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.e2_e1_collinearmass_UnclusteredEnDown_value)

        #print "making e2_e1_collinearmass_UnclusteredEnUp"
        self.e2_e1_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("e2_e1_collinearmass_UnclusteredEnUp")
        #if not self.e2_e1_collinearmass_UnclusteredEnUp_branch and "e2_e1_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.e2_e1_collinearmass_UnclusteredEnUp_branch and "e2_e1_collinearmass_UnclusteredEnUp":
            warnings.warn( "EETauTree: Expected branch e2_e1_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e1_collinearmass_UnclusteredEnUp")
        else:
            self.e2_e1_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.e2_e1_collinearmass_UnclusteredEnUp_value)

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

        #print "making e2_t_Eta"
        self.e2_t_Eta_branch = the_tree.GetBranch("e2_t_Eta")
        #if not self.e2_t_Eta_branch and "e2_t_Eta" not in self.complained:
        if not self.e2_t_Eta_branch and "e2_t_Eta":
            warnings.warn( "EETauTree: Expected branch e2_t_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Eta")
        else:
            self.e2_t_Eta_branch.SetAddress(<void*>&self.e2_t_Eta_value)

        #print "making e2_t_Mass"
        self.e2_t_Mass_branch = the_tree.GetBranch("e2_t_Mass")
        #if not self.e2_t_Mass_branch and "e2_t_Mass" not in self.complained:
        if not self.e2_t_Mass_branch and "e2_t_Mass":
            warnings.warn( "EETauTree: Expected branch e2_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mass")
        else:
            self.e2_t_Mass_branch.SetAddress(<void*>&self.e2_t_Mass_value)

        #print "making e2_t_Mass_TauEnDown"
        self.e2_t_Mass_TauEnDown_branch = the_tree.GetBranch("e2_t_Mass_TauEnDown")
        #if not self.e2_t_Mass_TauEnDown_branch and "e2_t_Mass_TauEnDown" not in self.complained:
        if not self.e2_t_Mass_TauEnDown_branch and "e2_t_Mass_TauEnDown":
            warnings.warn( "EETauTree: Expected branch e2_t_Mass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mass_TauEnDown")
        else:
            self.e2_t_Mass_TauEnDown_branch.SetAddress(<void*>&self.e2_t_Mass_TauEnDown_value)

        #print "making e2_t_Mass_TauEnUp"
        self.e2_t_Mass_TauEnUp_branch = the_tree.GetBranch("e2_t_Mass_TauEnUp")
        #if not self.e2_t_Mass_TauEnUp_branch and "e2_t_Mass_TauEnUp" not in self.complained:
        if not self.e2_t_Mass_TauEnUp_branch and "e2_t_Mass_TauEnUp":
            warnings.warn( "EETauTree: Expected branch e2_t_Mass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mass_TauEnUp")
        else:
            self.e2_t_Mass_TauEnUp_branch.SetAddress(<void*>&self.e2_t_Mass_TauEnUp_value)

        #print "making e2_t_Mt"
        self.e2_t_Mt_branch = the_tree.GetBranch("e2_t_Mt")
        #if not self.e2_t_Mt_branch and "e2_t_Mt" not in self.complained:
        if not self.e2_t_Mt_branch and "e2_t_Mt":
            warnings.warn( "EETauTree: Expected branch e2_t_Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mt")
        else:
            self.e2_t_Mt_branch.SetAddress(<void*>&self.e2_t_Mt_value)

        #print "making e2_t_MtTotal"
        self.e2_t_MtTotal_branch = the_tree.GetBranch("e2_t_MtTotal")
        #if not self.e2_t_MtTotal_branch and "e2_t_MtTotal" not in self.complained:
        if not self.e2_t_MtTotal_branch and "e2_t_MtTotal":
            warnings.warn( "EETauTree: Expected branch e2_t_MtTotal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_MtTotal")
        else:
            self.e2_t_MtTotal_branch.SetAddress(<void*>&self.e2_t_MtTotal_value)

        #print "making e2_t_Mt_TauEnDown"
        self.e2_t_Mt_TauEnDown_branch = the_tree.GetBranch("e2_t_Mt_TauEnDown")
        #if not self.e2_t_Mt_TauEnDown_branch and "e2_t_Mt_TauEnDown" not in self.complained:
        if not self.e2_t_Mt_TauEnDown_branch and "e2_t_Mt_TauEnDown":
            warnings.warn( "EETauTree: Expected branch e2_t_Mt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mt_TauEnDown")
        else:
            self.e2_t_Mt_TauEnDown_branch.SetAddress(<void*>&self.e2_t_Mt_TauEnDown_value)

        #print "making e2_t_Mt_TauEnUp"
        self.e2_t_Mt_TauEnUp_branch = the_tree.GetBranch("e2_t_Mt_TauEnUp")
        #if not self.e2_t_Mt_TauEnUp_branch and "e2_t_Mt_TauEnUp" not in self.complained:
        if not self.e2_t_Mt_TauEnUp_branch and "e2_t_Mt_TauEnUp":
            warnings.warn( "EETauTree: Expected branch e2_t_Mt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mt_TauEnUp")
        else:
            self.e2_t_Mt_TauEnUp_branch.SetAddress(<void*>&self.e2_t_Mt_TauEnUp_value)

        #print "making e2_t_MvaMet"
        self.e2_t_MvaMet_branch = the_tree.GetBranch("e2_t_MvaMet")
        #if not self.e2_t_MvaMet_branch and "e2_t_MvaMet" not in self.complained:
        if not self.e2_t_MvaMet_branch and "e2_t_MvaMet":
            warnings.warn( "EETauTree: Expected branch e2_t_MvaMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_MvaMet")
        else:
            self.e2_t_MvaMet_branch.SetAddress(<void*>&self.e2_t_MvaMet_value)

        #print "making e2_t_MvaMetCovMatrix00"
        self.e2_t_MvaMetCovMatrix00_branch = the_tree.GetBranch("e2_t_MvaMetCovMatrix00")
        #if not self.e2_t_MvaMetCovMatrix00_branch and "e2_t_MvaMetCovMatrix00" not in self.complained:
        if not self.e2_t_MvaMetCovMatrix00_branch and "e2_t_MvaMetCovMatrix00":
            warnings.warn( "EETauTree: Expected branch e2_t_MvaMetCovMatrix00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_MvaMetCovMatrix00")
        else:
            self.e2_t_MvaMetCovMatrix00_branch.SetAddress(<void*>&self.e2_t_MvaMetCovMatrix00_value)

        #print "making e2_t_MvaMetCovMatrix01"
        self.e2_t_MvaMetCovMatrix01_branch = the_tree.GetBranch("e2_t_MvaMetCovMatrix01")
        #if not self.e2_t_MvaMetCovMatrix01_branch and "e2_t_MvaMetCovMatrix01" not in self.complained:
        if not self.e2_t_MvaMetCovMatrix01_branch and "e2_t_MvaMetCovMatrix01":
            warnings.warn( "EETauTree: Expected branch e2_t_MvaMetCovMatrix01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_MvaMetCovMatrix01")
        else:
            self.e2_t_MvaMetCovMatrix01_branch.SetAddress(<void*>&self.e2_t_MvaMetCovMatrix01_value)

        #print "making e2_t_MvaMetCovMatrix10"
        self.e2_t_MvaMetCovMatrix10_branch = the_tree.GetBranch("e2_t_MvaMetCovMatrix10")
        #if not self.e2_t_MvaMetCovMatrix10_branch and "e2_t_MvaMetCovMatrix10" not in self.complained:
        if not self.e2_t_MvaMetCovMatrix10_branch and "e2_t_MvaMetCovMatrix10":
            warnings.warn( "EETauTree: Expected branch e2_t_MvaMetCovMatrix10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_MvaMetCovMatrix10")
        else:
            self.e2_t_MvaMetCovMatrix10_branch.SetAddress(<void*>&self.e2_t_MvaMetCovMatrix10_value)

        #print "making e2_t_MvaMetCovMatrix11"
        self.e2_t_MvaMetCovMatrix11_branch = the_tree.GetBranch("e2_t_MvaMetCovMatrix11")
        #if not self.e2_t_MvaMetCovMatrix11_branch and "e2_t_MvaMetCovMatrix11" not in self.complained:
        if not self.e2_t_MvaMetCovMatrix11_branch and "e2_t_MvaMetCovMatrix11":
            warnings.warn( "EETauTree: Expected branch e2_t_MvaMetCovMatrix11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_MvaMetCovMatrix11")
        else:
            self.e2_t_MvaMetCovMatrix11_branch.SetAddress(<void*>&self.e2_t_MvaMetCovMatrix11_value)

        #print "making e2_t_MvaMetPhi"
        self.e2_t_MvaMetPhi_branch = the_tree.GetBranch("e2_t_MvaMetPhi")
        #if not self.e2_t_MvaMetPhi_branch and "e2_t_MvaMetPhi" not in self.complained:
        if not self.e2_t_MvaMetPhi_branch and "e2_t_MvaMetPhi":
            warnings.warn( "EETauTree: Expected branch e2_t_MvaMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_MvaMetPhi")
        else:
            self.e2_t_MvaMetPhi_branch.SetAddress(<void*>&self.e2_t_MvaMetPhi_value)

        #print "making e2_t_PZeta"
        self.e2_t_PZeta_branch = the_tree.GetBranch("e2_t_PZeta")
        #if not self.e2_t_PZeta_branch and "e2_t_PZeta" not in self.complained:
        if not self.e2_t_PZeta_branch and "e2_t_PZeta":
            warnings.warn( "EETauTree: Expected branch e2_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_PZeta")
        else:
            self.e2_t_PZeta_branch.SetAddress(<void*>&self.e2_t_PZeta_value)

        #print "making e2_t_PZetaLess0p85PZetaVis"
        self.e2_t_PZetaLess0p85PZetaVis_branch = the_tree.GetBranch("e2_t_PZetaLess0p85PZetaVis")
        #if not self.e2_t_PZetaLess0p85PZetaVis_branch and "e2_t_PZetaLess0p85PZetaVis" not in self.complained:
        if not self.e2_t_PZetaLess0p85PZetaVis_branch and "e2_t_PZetaLess0p85PZetaVis":
            warnings.warn( "EETauTree: Expected branch e2_t_PZetaLess0p85PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_PZetaLess0p85PZetaVis")
        else:
            self.e2_t_PZetaLess0p85PZetaVis_branch.SetAddress(<void*>&self.e2_t_PZetaLess0p85PZetaVis_value)

        #print "making e2_t_PZetaVis"
        self.e2_t_PZetaVis_branch = the_tree.GetBranch("e2_t_PZetaVis")
        #if not self.e2_t_PZetaVis_branch and "e2_t_PZetaVis" not in self.complained:
        if not self.e2_t_PZetaVis_branch and "e2_t_PZetaVis":
            warnings.warn( "EETauTree: Expected branch e2_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_PZetaVis")
        else:
            self.e2_t_PZetaVis_branch.SetAddress(<void*>&self.e2_t_PZetaVis_value)

        #print "making e2_t_Phi"
        self.e2_t_Phi_branch = the_tree.GetBranch("e2_t_Phi")
        #if not self.e2_t_Phi_branch and "e2_t_Phi" not in self.complained:
        if not self.e2_t_Phi_branch and "e2_t_Phi":
            warnings.warn( "EETauTree: Expected branch e2_t_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Phi")
        else:
            self.e2_t_Phi_branch.SetAddress(<void*>&self.e2_t_Phi_value)

        #print "making e2_t_Pt"
        self.e2_t_Pt_branch = the_tree.GetBranch("e2_t_Pt")
        #if not self.e2_t_Pt_branch and "e2_t_Pt" not in self.complained:
        if not self.e2_t_Pt_branch and "e2_t_Pt":
            warnings.warn( "EETauTree: Expected branch e2_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Pt")
        else:
            self.e2_t_Pt_branch.SetAddress(<void*>&self.e2_t_Pt_value)

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

        #print "making e2_t_collinearmass"
        self.e2_t_collinearmass_branch = the_tree.GetBranch("e2_t_collinearmass")
        #if not self.e2_t_collinearmass_branch and "e2_t_collinearmass" not in self.complained:
        if not self.e2_t_collinearmass_branch and "e2_t_collinearmass":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass")
        else:
            self.e2_t_collinearmass_branch.SetAddress(<void*>&self.e2_t_collinearmass_value)

        #print "making e2_t_collinearmass_CheckUESDown"
        self.e2_t_collinearmass_CheckUESDown_branch = the_tree.GetBranch("e2_t_collinearmass_CheckUESDown")
        #if not self.e2_t_collinearmass_CheckUESDown_branch and "e2_t_collinearmass_CheckUESDown" not in self.complained:
        if not self.e2_t_collinearmass_CheckUESDown_branch and "e2_t_collinearmass_CheckUESDown":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_CheckUESDown")
        else:
            self.e2_t_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.e2_t_collinearmass_CheckUESDown_value)

        #print "making e2_t_collinearmass_CheckUESUp"
        self.e2_t_collinearmass_CheckUESUp_branch = the_tree.GetBranch("e2_t_collinearmass_CheckUESUp")
        #if not self.e2_t_collinearmass_CheckUESUp_branch and "e2_t_collinearmass_CheckUESUp" not in self.complained:
        if not self.e2_t_collinearmass_CheckUESUp_branch and "e2_t_collinearmass_CheckUESUp":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_CheckUESUp")
        else:
            self.e2_t_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.e2_t_collinearmass_CheckUESUp_value)

        #print "making e2_t_collinearmass_EleEnDown"
        self.e2_t_collinearmass_EleEnDown_branch = the_tree.GetBranch("e2_t_collinearmass_EleEnDown")
        #if not self.e2_t_collinearmass_EleEnDown_branch and "e2_t_collinearmass_EleEnDown" not in self.complained:
        if not self.e2_t_collinearmass_EleEnDown_branch and "e2_t_collinearmass_EleEnDown":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_EleEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_EleEnDown")
        else:
            self.e2_t_collinearmass_EleEnDown_branch.SetAddress(<void*>&self.e2_t_collinearmass_EleEnDown_value)

        #print "making e2_t_collinearmass_EleEnUp"
        self.e2_t_collinearmass_EleEnUp_branch = the_tree.GetBranch("e2_t_collinearmass_EleEnUp")
        #if not self.e2_t_collinearmass_EleEnUp_branch and "e2_t_collinearmass_EleEnUp" not in self.complained:
        if not self.e2_t_collinearmass_EleEnUp_branch and "e2_t_collinearmass_EleEnUp":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_EleEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_EleEnUp")
        else:
            self.e2_t_collinearmass_EleEnUp_branch.SetAddress(<void*>&self.e2_t_collinearmass_EleEnUp_value)

        #print "making e2_t_collinearmass_JetCheckTotalDown"
        self.e2_t_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("e2_t_collinearmass_JetCheckTotalDown")
        #if not self.e2_t_collinearmass_JetCheckTotalDown_branch and "e2_t_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.e2_t_collinearmass_JetCheckTotalDown_branch and "e2_t_collinearmass_JetCheckTotalDown":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_JetCheckTotalDown")
        else:
            self.e2_t_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.e2_t_collinearmass_JetCheckTotalDown_value)

        #print "making e2_t_collinearmass_JetCheckTotalUp"
        self.e2_t_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("e2_t_collinearmass_JetCheckTotalUp")
        #if not self.e2_t_collinearmass_JetCheckTotalUp_branch and "e2_t_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.e2_t_collinearmass_JetCheckTotalUp_branch and "e2_t_collinearmass_JetCheckTotalUp":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_JetCheckTotalUp")
        else:
            self.e2_t_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.e2_t_collinearmass_JetCheckTotalUp_value)

        #print "making e2_t_collinearmass_JetEnDown"
        self.e2_t_collinearmass_JetEnDown_branch = the_tree.GetBranch("e2_t_collinearmass_JetEnDown")
        #if not self.e2_t_collinearmass_JetEnDown_branch and "e2_t_collinearmass_JetEnDown" not in self.complained:
        if not self.e2_t_collinearmass_JetEnDown_branch and "e2_t_collinearmass_JetEnDown":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_JetEnDown")
        else:
            self.e2_t_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.e2_t_collinearmass_JetEnDown_value)

        #print "making e2_t_collinearmass_JetEnUp"
        self.e2_t_collinearmass_JetEnUp_branch = the_tree.GetBranch("e2_t_collinearmass_JetEnUp")
        #if not self.e2_t_collinearmass_JetEnUp_branch and "e2_t_collinearmass_JetEnUp" not in self.complained:
        if not self.e2_t_collinearmass_JetEnUp_branch and "e2_t_collinearmass_JetEnUp":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_JetEnUp")
        else:
            self.e2_t_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.e2_t_collinearmass_JetEnUp_value)

        #print "making e2_t_collinearmass_MuEnDown"
        self.e2_t_collinearmass_MuEnDown_branch = the_tree.GetBranch("e2_t_collinearmass_MuEnDown")
        #if not self.e2_t_collinearmass_MuEnDown_branch and "e2_t_collinearmass_MuEnDown" not in self.complained:
        if not self.e2_t_collinearmass_MuEnDown_branch and "e2_t_collinearmass_MuEnDown":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_MuEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_MuEnDown")
        else:
            self.e2_t_collinearmass_MuEnDown_branch.SetAddress(<void*>&self.e2_t_collinearmass_MuEnDown_value)

        #print "making e2_t_collinearmass_MuEnUp"
        self.e2_t_collinearmass_MuEnUp_branch = the_tree.GetBranch("e2_t_collinearmass_MuEnUp")
        #if not self.e2_t_collinearmass_MuEnUp_branch and "e2_t_collinearmass_MuEnUp" not in self.complained:
        if not self.e2_t_collinearmass_MuEnUp_branch and "e2_t_collinearmass_MuEnUp":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_MuEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_MuEnUp")
        else:
            self.e2_t_collinearmass_MuEnUp_branch.SetAddress(<void*>&self.e2_t_collinearmass_MuEnUp_value)

        #print "making e2_t_collinearmass_TauEnDown"
        self.e2_t_collinearmass_TauEnDown_branch = the_tree.GetBranch("e2_t_collinearmass_TauEnDown")
        #if not self.e2_t_collinearmass_TauEnDown_branch and "e2_t_collinearmass_TauEnDown" not in self.complained:
        if not self.e2_t_collinearmass_TauEnDown_branch and "e2_t_collinearmass_TauEnDown":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_TauEnDown")
        else:
            self.e2_t_collinearmass_TauEnDown_branch.SetAddress(<void*>&self.e2_t_collinearmass_TauEnDown_value)

        #print "making e2_t_collinearmass_TauEnUp"
        self.e2_t_collinearmass_TauEnUp_branch = the_tree.GetBranch("e2_t_collinearmass_TauEnUp")
        #if not self.e2_t_collinearmass_TauEnUp_branch and "e2_t_collinearmass_TauEnUp" not in self.complained:
        if not self.e2_t_collinearmass_TauEnUp_branch and "e2_t_collinearmass_TauEnUp":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_TauEnUp")
        else:
            self.e2_t_collinearmass_TauEnUp_branch.SetAddress(<void*>&self.e2_t_collinearmass_TauEnUp_value)

        #print "making e2_t_collinearmass_UnclusteredEnDown"
        self.e2_t_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("e2_t_collinearmass_UnclusteredEnDown")
        #if not self.e2_t_collinearmass_UnclusteredEnDown_branch and "e2_t_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.e2_t_collinearmass_UnclusteredEnDown_branch and "e2_t_collinearmass_UnclusteredEnDown":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_UnclusteredEnDown")
        else:
            self.e2_t_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.e2_t_collinearmass_UnclusteredEnDown_value)

        #print "making e2_t_collinearmass_UnclusteredEnUp"
        self.e2_t_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("e2_t_collinearmass_UnclusteredEnUp")
        #if not self.e2_t_collinearmass_UnclusteredEnUp_branch and "e2_t_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.e2_t_collinearmass_UnclusteredEnUp_branch and "e2_t_collinearmass_UnclusteredEnUp":
            warnings.warn( "EETauTree: Expected branch e2_t_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_collinearmass_UnclusteredEnUp")
        else:
            self.e2_t_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.e2_t_collinearmass_UnclusteredEnUp_value)

        #print "making e2_t_pt_tt"
        self.e2_t_pt_tt_branch = the_tree.GetBranch("e2_t_pt_tt")
        #if not self.e2_t_pt_tt_branch and "e2_t_pt_tt" not in self.complained:
        if not self.e2_t_pt_tt_branch and "e2_t_pt_tt":
            warnings.warn( "EETauTree: Expected branch e2_t_pt_tt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_pt_tt")
        else:
            self.e2_t_pt_tt_branch.SetAddress(<void*>&self.e2_t_pt_tt_value)

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

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "EETauTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eVetoZTTp001dxyzR0"
        self.eVetoZTTp001dxyzR0_branch = the_tree.GetBranch("eVetoZTTp001dxyzR0")
        #if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0" not in self.complained:
        if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0":
            warnings.warn( "EETauTree: Expected branch eVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyzR0")
        else:
            self.eVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.eVetoZTTp001dxyzR0_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "EETauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "EETauTree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "EETauTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "EETauTree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "EETauTree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "EETauTree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "EETauTree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "EETauTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "EETauTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "EETauTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWenu"
        self.isWenu_branch = the_tree.GetBranch("isWenu")
        #if not self.isWenu_branch and "isWenu" not in self.complained:
        if not self.isWenu_branch and "isWenu":
            warnings.warn( "EETauTree: Expected branch isWenu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWenu")
        else:
            self.isWenu_branch.SetAddress(<void*>&self.isWenu_value)

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

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "EETauTree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "EETauTree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

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

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "EETauTree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "EETauTree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "EETauTree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1partonflavor"
        self.j1partonflavor_branch = the_tree.GetBranch("j1partonflavor")
        #if not self.j1partonflavor_branch and "j1partonflavor" not in self.complained:
        if not self.j1partonflavor_branch and "j1partonflavor":
            warnings.warn( "EETauTree: Expected branch j1partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1partonflavor")
        else:
            self.j1partonflavor_branch.SetAddress(<void*>&self.j1partonflavor_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "EETauTree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "EETauTree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptDown"
        self.j1ptDown_branch = the_tree.GetBranch("j1ptDown")
        #if not self.j1ptDown_branch and "j1ptDown" not in self.complained:
        if not self.j1ptDown_branch and "j1ptDown":
            warnings.warn( "EETauTree: Expected branch j1ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptDown")
        else:
            self.j1ptDown_branch.SetAddress(<void*>&self.j1ptDown_value)

        #print "making j1ptUp"
        self.j1ptUp_branch = the_tree.GetBranch("j1ptUp")
        #if not self.j1ptUp_branch and "j1ptUp" not in self.complained:
        if not self.j1ptUp_branch and "j1ptUp":
            warnings.warn( "EETauTree: Expected branch j1ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptUp")
        else:
            self.j1ptUp_branch.SetAddress(<void*>&self.j1ptUp_value)

        #print "making j1pu"
        self.j1pu_branch = the_tree.GetBranch("j1pu")
        #if not self.j1pu_branch and "j1pu" not in self.complained:
        if not self.j1pu_branch and "j1pu":
            warnings.warn( "EETauTree: Expected branch j1pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pu")
        else:
            self.j1pu_branch.SetAddress(<void*>&self.j1pu_value)

        #print "making j1rawf"
        self.j1rawf_branch = the_tree.GetBranch("j1rawf")
        #if not self.j1rawf_branch and "j1rawf" not in self.complained:
        if not self.j1rawf_branch and "j1rawf":
            warnings.warn( "EETauTree: Expected branch j1rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1rawf")
        else:
            self.j1rawf_branch.SetAddress(<void*>&self.j1rawf_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "EETauTree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "EETauTree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "EETauTree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2partonflavor"
        self.j2partonflavor_branch = the_tree.GetBranch("j2partonflavor")
        #if not self.j2partonflavor_branch and "j2partonflavor" not in self.complained:
        if not self.j2partonflavor_branch and "j2partonflavor":
            warnings.warn( "EETauTree: Expected branch j2partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2partonflavor")
        else:
            self.j2partonflavor_branch.SetAddress(<void*>&self.j2partonflavor_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "EETauTree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "EETauTree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptDown"
        self.j2ptDown_branch = the_tree.GetBranch("j2ptDown")
        #if not self.j2ptDown_branch and "j2ptDown" not in self.complained:
        if not self.j2ptDown_branch and "j2ptDown":
            warnings.warn( "EETauTree: Expected branch j2ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptDown")
        else:
            self.j2ptDown_branch.SetAddress(<void*>&self.j2ptDown_value)

        #print "making j2ptUp"
        self.j2ptUp_branch = the_tree.GetBranch("j2ptUp")
        #if not self.j2ptUp_branch and "j2ptUp" not in self.complained:
        if not self.j2ptUp_branch and "j2ptUp":
            warnings.warn( "EETauTree: Expected branch j2ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptUp")
        else:
            self.j2ptUp_branch.SetAddress(<void*>&self.j2ptUp_value)

        #print "making j2pu"
        self.j2pu_branch = the_tree.GetBranch("j2pu")
        #if not self.j2pu_branch and "j2pu" not in self.complained:
        if not self.j2pu_branch and "j2pu":
            warnings.warn( "EETauTree: Expected branch j2pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pu")
        else:
            self.j2pu_branch.SetAddress(<void*>&self.j2pu_value)

        #print "making j2rawf"
        self.j2rawf_branch = the_tree.GetBranch("j2rawf")
        #if not self.j2rawf_branch and "j2rawf" not in self.complained:
        if not self.j2rawf_branch and "j2rawf":
            warnings.warn( "EETauTree: Expected branch j2rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2rawf")
        else:
            self.j2rawf_branch.SetAddress(<void*>&self.j2rawf_value)

        #print "making jb1csv"
        self.jb1csv_branch = the_tree.GetBranch("jb1csv")
        #if not self.jb1csv_branch and "jb1csv" not in self.complained:
        if not self.jb1csv_branch and "jb1csv":
            warnings.warn( "EETauTree: Expected branch jb1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csv")
        else:
            self.jb1csv_branch.SetAddress(<void*>&self.jb1csv_value)

        #print "making jb1csv_CSVL"
        self.jb1csv_CSVL_branch = the_tree.GetBranch("jb1csv_CSVL")
        #if not self.jb1csv_CSVL_branch and "jb1csv_CSVL" not in self.complained:
        if not self.jb1csv_CSVL_branch and "jb1csv_CSVL":
            warnings.warn( "EETauTree: Expected branch jb1csv_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csv_CSVL")
        else:
            self.jb1csv_CSVL_branch.SetAddress(<void*>&self.jb1csv_CSVL_value)

        #print "making jb1eta"
        self.jb1eta_branch = the_tree.GetBranch("jb1eta")
        #if not self.jb1eta_branch and "jb1eta" not in self.complained:
        if not self.jb1eta_branch and "jb1eta":
            warnings.warn( "EETauTree: Expected branch jb1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta")
        else:
            self.jb1eta_branch.SetAddress(<void*>&self.jb1eta_value)

        #print "making jb1eta_CSVL"
        self.jb1eta_CSVL_branch = the_tree.GetBranch("jb1eta_CSVL")
        #if not self.jb1eta_CSVL_branch and "jb1eta_CSVL" not in self.complained:
        if not self.jb1eta_CSVL_branch and "jb1eta_CSVL":
            warnings.warn( "EETauTree: Expected branch jb1eta_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_CSVL")
        else:
            self.jb1eta_CSVL_branch.SetAddress(<void*>&self.jb1eta_CSVL_value)

        #print "making jb1hadronflavor"
        self.jb1hadronflavor_branch = the_tree.GetBranch("jb1hadronflavor")
        #if not self.jb1hadronflavor_branch and "jb1hadronflavor" not in self.complained:
        if not self.jb1hadronflavor_branch and "jb1hadronflavor":
            warnings.warn( "EETauTree: Expected branch jb1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor")
        else:
            self.jb1hadronflavor_branch.SetAddress(<void*>&self.jb1hadronflavor_value)

        #print "making jb1hadronflavor_CSVL"
        self.jb1hadronflavor_CSVL_branch = the_tree.GetBranch("jb1hadronflavor_CSVL")
        #if not self.jb1hadronflavor_CSVL_branch and "jb1hadronflavor_CSVL" not in self.complained:
        if not self.jb1hadronflavor_CSVL_branch and "jb1hadronflavor_CSVL":
            warnings.warn( "EETauTree: Expected branch jb1hadronflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_CSVL")
        else:
            self.jb1hadronflavor_CSVL_branch.SetAddress(<void*>&self.jb1hadronflavor_CSVL_value)

        #print "making jb1partonflavor"
        self.jb1partonflavor_branch = the_tree.GetBranch("jb1partonflavor")
        #if not self.jb1partonflavor_branch and "jb1partonflavor" not in self.complained:
        if not self.jb1partonflavor_branch and "jb1partonflavor":
            warnings.warn( "EETauTree: Expected branch jb1partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1partonflavor")
        else:
            self.jb1partonflavor_branch.SetAddress(<void*>&self.jb1partonflavor_value)

        #print "making jb1partonflavor_CSVL"
        self.jb1partonflavor_CSVL_branch = the_tree.GetBranch("jb1partonflavor_CSVL")
        #if not self.jb1partonflavor_CSVL_branch and "jb1partonflavor_CSVL" not in self.complained:
        if not self.jb1partonflavor_CSVL_branch and "jb1partonflavor_CSVL":
            warnings.warn( "EETauTree: Expected branch jb1partonflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1partonflavor_CSVL")
        else:
            self.jb1partonflavor_CSVL_branch.SetAddress(<void*>&self.jb1partonflavor_CSVL_value)

        #print "making jb1phi"
        self.jb1phi_branch = the_tree.GetBranch("jb1phi")
        #if not self.jb1phi_branch and "jb1phi" not in self.complained:
        if not self.jb1phi_branch and "jb1phi":
            warnings.warn( "EETauTree: Expected branch jb1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi")
        else:
            self.jb1phi_branch.SetAddress(<void*>&self.jb1phi_value)

        #print "making jb1phi_CSVL"
        self.jb1phi_CSVL_branch = the_tree.GetBranch("jb1phi_CSVL")
        #if not self.jb1phi_CSVL_branch and "jb1phi_CSVL" not in self.complained:
        if not self.jb1phi_CSVL_branch and "jb1phi_CSVL":
            warnings.warn( "EETauTree: Expected branch jb1phi_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_CSVL")
        else:
            self.jb1phi_CSVL_branch.SetAddress(<void*>&self.jb1phi_CSVL_value)

        #print "making jb1pt"
        self.jb1pt_branch = the_tree.GetBranch("jb1pt")
        #if not self.jb1pt_branch and "jb1pt" not in self.complained:
        if not self.jb1pt_branch and "jb1pt":
            warnings.warn( "EETauTree: Expected branch jb1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt")
        else:
            self.jb1pt_branch.SetAddress(<void*>&self.jb1pt_value)

        #print "making jb1ptDown"
        self.jb1ptDown_branch = the_tree.GetBranch("jb1ptDown")
        #if not self.jb1ptDown_branch and "jb1ptDown" not in self.complained:
        if not self.jb1ptDown_branch and "jb1ptDown":
            warnings.warn( "EETauTree: Expected branch jb1ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptDown")
        else:
            self.jb1ptDown_branch.SetAddress(<void*>&self.jb1ptDown_value)

        #print "making jb1ptDown_CSVL"
        self.jb1ptDown_CSVL_branch = the_tree.GetBranch("jb1ptDown_CSVL")
        #if not self.jb1ptDown_CSVL_branch and "jb1ptDown_CSVL" not in self.complained:
        if not self.jb1ptDown_CSVL_branch and "jb1ptDown_CSVL":
            warnings.warn( "EETauTree: Expected branch jb1ptDown_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptDown_CSVL")
        else:
            self.jb1ptDown_CSVL_branch.SetAddress(<void*>&self.jb1ptDown_CSVL_value)

        #print "making jb1ptUp"
        self.jb1ptUp_branch = the_tree.GetBranch("jb1ptUp")
        #if not self.jb1ptUp_branch and "jb1ptUp" not in self.complained:
        if not self.jb1ptUp_branch and "jb1ptUp":
            warnings.warn( "EETauTree: Expected branch jb1ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptUp")
        else:
            self.jb1ptUp_branch.SetAddress(<void*>&self.jb1ptUp_value)

        #print "making jb1ptUp_CSVL"
        self.jb1ptUp_CSVL_branch = the_tree.GetBranch("jb1ptUp_CSVL")
        #if not self.jb1ptUp_CSVL_branch and "jb1ptUp_CSVL" not in self.complained:
        if not self.jb1ptUp_CSVL_branch and "jb1ptUp_CSVL":
            warnings.warn( "EETauTree: Expected branch jb1ptUp_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptUp_CSVL")
        else:
            self.jb1ptUp_CSVL_branch.SetAddress(<void*>&self.jb1ptUp_CSVL_value)

        #print "making jb1pt_CSVL"
        self.jb1pt_CSVL_branch = the_tree.GetBranch("jb1pt_CSVL")
        #if not self.jb1pt_CSVL_branch and "jb1pt_CSVL" not in self.complained:
        if not self.jb1pt_CSVL_branch and "jb1pt_CSVL":
            warnings.warn( "EETauTree: Expected branch jb1pt_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_CSVL")
        else:
            self.jb1pt_CSVL_branch.SetAddress(<void*>&self.jb1pt_CSVL_value)

        #print "making jb1pu"
        self.jb1pu_branch = the_tree.GetBranch("jb1pu")
        #if not self.jb1pu_branch and "jb1pu" not in self.complained:
        if not self.jb1pu_branch and "jb1pu":
            warnings.warn( "EETauTree: Expected branch jb1pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pu")
        else:
            self.jb1pu_branch.SetAddress(<void*>&self.jb1pu_value)

        #print "making jb1pu_CSVL"
        self.jb1pu_CSVL_branch = the_tree.GetBranch("jb1pu_CSVL")
        #if not self.jb1pu_CSVL_branch and "jb1pu_CSVL" not in self.complained:
        if not self.jb1pu_CSVL_branch and "jb1pu_CSVL":
            warnings.warn( "EETauTree: Expected branch jb1pu_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pu_CSVL")
        else:
            self.jb1pu_CSVL_branch.SetAddress(<void*>&self.jb1pu_CSVL_value)

        #print "making jb1rawf"
        self.jb1rawf_branch = the_tree.GetBranch("jb1rawf")
        #if not self.jb1rawf_branch and "jb1rawf" not in self.complained:
        if not self.jb1rawf_branch and "jb1rawf":
            warnings.warn( "EETauTree: Expected branch jb1rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1rawf")
        else:
            self.jb1rawf_branch.SetAddress(<void*>&self.jb1rawf_value)

        #print "making jb1rawf_CSVL"
        self.jb1rawf_CSVL_branch = the_tree.GetBranch("jb1rawf_CSVL")
        #if not self.jb1rawf_CSVL_branch and "jb1rawf_CSVL" not in self.complained:
        if not self.jb1rawf_CSVL_branch and "jb1rawf_CSVL":
            warnings.warn( "EETauTree: Expected branch jb1rawf_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1rawf_CSVL")
        else:
            self.jb1rawf_CSVL_branch.SetAddress(<void*>&self.jb1rawf_CSVL_value)

        #print "making jb2csv"
        self.jb2csv_branch = the_tree.GetBranch("jb2csv")
        #if not self.jb2csv_branch and "jb2csv" not in self.complained:
        if not self.jb2csv_branch and "jb2csv":
            warnings.warn( "EETauTree: Expected branch jb2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csv")
        else:
            self.jb2csv_branch.SetAddress(<void*>&self.jb2csv_value)

        #print "making jb2csv_CSVL"
        self.jb2csv_CSVL_branch = the_tree.GetBranch("jb2csv_CSVL")
        #if not self.jb2csv_CSVL_branch and "jb2csv_CSVL" not in self.complained:
        if not self.jb2csv_CSVL_branch and "jb2csv_CSVL":
            warnings.warn( "EETauTree: Expected branch jb2csv_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csv_CSVL")
        else:
            self.jb2csv_CSVL_branch.SetAddress(<void*>&self.jb2csv_CSVL_value)

        #print "making jb2eta"
        self.jb2eta_branch = the_tree.GetBranch("jb2eta")
        #if not self.jb2eta_branch and "jb2eta" not in self.complained:
        if not self.jb2eta_branch and "jb2eta":
            warnings.warn( "EETauTree: Expected branch jb2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta")
        else:
            self.jb2eta_branch.SetAddress(<void*>&self.jb2eta_value)

        #print "making jb2eta_CSVL"
        self.jb2eta_CSVL_branch = the_tree.GetBranch("jb2eta_CSVL")
        #if not self.jb2eta_CSVL_branch and "jb2eta_CSVL" not in self.complained:
        if not self.jb2eta_CSVL_branch and "jb2eta_CSVL":
            warnings.warn( "EETauTree: Expected branch jb2eta_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_CSVL")
        else:
            self.jb2eta_CSVL_branch.SetAddress(<void*>&self.jb2eta_CSVL_value)

        #print "making jb2hadronflavor"
        self.jb2hadronflavor_branch = the_tree.GetBranch("jb2hadronflavor")
        #if not self.jb2hadronflavor_branch and "jb2hadronflavor" not in self.complained:
        if not self.jb2hadronflavor_branch and "jb2hadronflavor":
            warnings.warn( "EETauTree: Expected branch jb2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor")
        else:
            self.jb2hadronflavor_branch.SetAddress(<void*>&self.jb2hadronflavor_value)

        #print "making jb2hadronflavor_CSVL"
        self.jb2hadronflavor_CSVL_branch = the_tree.GetBranch("jb2hadronflavor_CSVL")
        #if not self.jb2hadronflavor_CSVL_branch and "jb2hadronflavor_CSVL" not in self.complained:
        if not self.jb2hadronflavor_CSVL_branch and "jb2hadronflavor_CSVL":
            warnings.warn( "EETauTree: Expected branch jb2hadronflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_CSVL")
        else:
            self.jb2hadronflavor_CSVL_branch.SetAddress(<void*>&self.jb2hadronflavor_CSVL_value)

        #print "making jb2partonflavor"
        self.jb2partonflavor_branch = the_tree.GetBranch("jb2partonflavor")
        #if not self.jb2partonflavor_branch and "jb2partonflavor" not in self.complained:
        if not self.jb2partonflavor_branch and "jb2partonflavor":
            warnings.warn( "EETauTree: Expected branch jb2partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2partonflavor")
        else:
            self.jb2partonflavor_branch.SetAddress(<void*>&self.jb2partonflavor_value)

        #print "making jb2partonflavor_CSVL"
        self.jb2partonflavor_CSVL_branch = the_tree.GetBranch("jb2partonflavor_CSVL")
        #if not self.jb2partonflavor_CSVL_branch and "jb2partonflavor_CSVL" not in self.complained:
        if not self.jb2partonflavor_CSVL_branch and "jb2partonflavor_CSVL":
            warnings.warn( "EETauTree: Expected branch jb2partonflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2partonflavor_CSVL")
        else:
            self.jb2partonflavor_CSVL_branch.SetAddress(<void*>&self.jb2partonflavor_CSVL_value)

        #print "making jb2phi"
        self.jb2phi_branch = the_tree.GetBranch("jb2phi")
        #if not self.jb2phi_branch and "jb2phi" not in self.complained:
        if not self.jb2phi_branch and "jb2phi":
            warnings.warn( "EETauTree: Expected branch jb2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi")
        else:
            self.jb2phi_branch.SetAddress(<void*>&self.jb2phi_value)

        #print "making jb2phi_CSVL"
        self.jb2phi_CSVL_branch = the_tree.GetBranch("jb2phi_CSVL")
        #if not self.jb2phi_CSVL_branch and "jb2phi_CSVL" not in self.complained:
        if not self.jb2phi_CSVL_branch and "jb2phi_CSVL":
            warnings.warn( "EETauTree: Expected branch jb2phi_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_CSVL")
        else:
            self.jb2phi_CSVL_branch.SetAddress(<void*>&self.jb2phi_CSVL_value)

        #print "making jb2pt"
        self.jb2pt_branch = the_tree.GetBranch("jb2pt")
        #if not self.jb2pt_branch and "jb2pt" not in self.complained:
        if not self.jb2pt_branch and "jb2pt":
            warnings.warn( "EETauTree: Expected branch jb2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt")
        else:
            self.jb2pt_branch.SetAddress(<void*>&self.jb2pt_value)

        #print "making jb2ptDown"
        self.jb2ptDown_branch = the_tree.GetBranch("jb2ptDown")
        #if not self.jb2ptDown_branch and "jb2ptDown" not in self.complained:
        if not self.jb2ptDown_branch and "jb2ptDown":
            warnings.warn( "EETauTree: Expected branch jb2ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptDown")
        else:
            self.jb2ptDown_branch.SetAddress(<void*>&self.jb2ptDown_value)

        #print "making jb2ptDown_CSVL"
        self.jb2ptDown_CSVL_branch = the_tree.GetBranch("jb2ptDown_CSVL")
        #if not self.jb2ptDown_CSVL_branch and "jb2ptDown_CSVL" not in self.complained:
        if not self.jb2ptDown_CSVL_branch and "jb2ptDown_CSVL":
            warnings.warn( "EETauTree: Expected branch jb2ptDown_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptDown_CSVL")
        else:
            self.jb2ptDown_CSVL_branch.SetAddress(<void*>&self.jb2ptDown_CSVL_value)

        #print "making jb2ptUp"
        self.jb2ptUp_branch = the_tree.GetBranch("jb2ptUp")
        #if not self.jb2ptUp_branch and "jb2ptUp" not in self.complained:
        if not self.jb2ptUp_branch and "jb2ptUp":
            warnings.warn( "EETauTree: Expected branch jb2ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptUp")
        else:
            self.jb2ptUp_branch.SetAddress(<void*>&self.jb2ptUp_value)

        #print "making jb2ptUp_CSVL"
        self.jb2ptUp_CSVL_branch = the_tree.GetBranch("jb2ptUp_CSVL")
        #if not self.jb2ptUp_CSVL_branch and "jb2ptUp_CSVL" not in self.complained:
        if not self.jb2ptUp_CSVL_branch and "jb2ptUp_CSVL":
            warnings.warn( "EETauTree: Expected branch jb2ptUp_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptUp_CSVL")
        else:
            self.jb2ptUp_CSVL_branch.SetAddress(<void*>&self.jb2ptUp_CSVL_value)

        #print "making jb2pt_CSVL"
        self.jb2pt_CSVL_branch = the_tree.GetBranch("jb2pt_CSVL")
        #if not self.jb2pt_CSVL_branch and "jb2pt_CSVL" not in self.complained:
        if not self.jb2pt_CSVL_branch and "jb2pt_CSVL":
            warnings.warn( "EETauTree: Expected branch jb2pt_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_CSVL")
        else:
            self.jb2pt_CSVL_branch.SetAddress(<void*>&self.jb2pt_CSVL_value)

        #print "making jb2pu"
        self.jb2pu_branch = the_tree.GetBranch("jb2pu")
        #if not self.jb2pu_branch and "jb2pu" not in self.complained:
        if not self.jb2pu_branch and "jb2pu":
            warnings.warn( "EETauTree: Expected branch jb2pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pu")
        else:
            self.jb2pu_branch.SetAddress(<void*>&self.jb2pu_value)

        #print "making jb2pu_CSVL"
        self.jb2pu_CSVL_branch = the_tree.GetBranch("jb2pu_CSVL")
        #if not self.jb2pu_CSVL_branch and "jb2pu_CSVL" not in self.complained:
        if not self.jb2pu_CSVL_branch and "jb2pu_CSVL":
            warnings.warn( "EETauTree: Expected branch jb2pu_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pu_CSVL")
        else:
            self.jb2pu_CSVL_branch.SetAddress(<void*>&self.jb2pu_CSVL_value)

        #print "making jb2rawf"
        self.jb2rawf_branch = the_tree.GetBranch("jb2rawf")
        #if not self.jb2rawf_branch and "jb2rawf" not in self.complained:
        if not self.jb2rawf_branch and "jb2rawf":
            warnings.warn( "EETauTree: Expected branch jb2rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2rawf")
        else:
            self.jb2rawf_branch.SetAddress(<void*>&self.jb2rawf_value)

        #print "making jb2rawf_CSVL"
        self.jb2rawf_CSVL_branch = the_tree.GetBranch("jb2rawf_CSVL")
        #if not self.jb2rawf_CSVL_branch and "jb2rawf_CSVL" not in self.complained:
        if not self.jb2rawf_CSVL_branch and "jb2rawf_CSVL":
            warnings.warn( "EETauTree: Expected branch jb2rawf_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2rawf_CSVL")
        else:
            self.jb2rawf_CSVL_branch.SetAddress(<void*>&self.jb2rawf_CSVL_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "EETauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "EETauTree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "EETauTree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "EETauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "EETauTree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "EETauTree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EETauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "EETauTree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "EETauTree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov00_DESYlike"
        self.metcov00_DESYlike_branch = the_tree.GetBranch("metcov00_DESYlike")
        #if not self.metcov00_DESYlike_branch and "metcov00_DESYlike" not in self.complained:
        if not self.metcov00_DESYlike_branch and "metcov00_DESYlike":
            warnings.warn( "EETauTree: Expected branch metcov00_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00_DESYlike")
        else:
            self.metcov00_DESYlike_branch.SetAddress(<void*>&self.metcov00_DESYlike_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "EETauTree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov01_DESYlike"
        self.metcov01_DESYlike_branch = the_tree.GetBranch("metcov01_DESYlike")
        #if not self.metcov01_DESYlike_branch and "metcov01_DESYlike" not in self.complained:
        if not self.metcov01_DESYlike_branch and "metcov01_DESYlike":
            warnings.warn( "EETauTree: Expected branch metcov01_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01_DESYlike")
        else:
            self.metcov01_DESYlike_branch.SetAddress(<void*>&self.metcov01_DESYlike_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "EETauTree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov10_DESYlike"
        self.metcov10_DESYlike_branch = the_tree.GetBranch("metcov10_DESYlike")
        #if not self.metcov10_DESYlike_branch and "metcov10_DESYlike" not in self.complained:
        if not self.metcov10_DESYlike_branch and "metcov10_DESYlike":
            warnings.warn( "EETauTree: Expected branch metcov10_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10_DESYlike")
        else:
            self.metcov10_DESYlike_branch.SetAddress(<void*>&self.metcov10_DESYlike_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "EETauTree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

        #print "making metcov11_DESYlike"
        self.metcov11_DESYlike_branch = the_tree.GetBranch("metcov11_DESYlike")
        #if not self.metcov11_DESYlike_branch and "metcov11_DESYlike" not in self.complained:
        if not self.metcov11_DESYlike_branch and "metcov11_DESYlike":
            warnings.warn( "EETauTree: Expected branch metcov11_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11_DESYlike")
        else:
            self.metcov11_DESYlike_branch.SetAddress(<void*>&self.metcov11_DESYlike_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "EETauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

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

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "EETauTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making muVetoZTTp001dxyzR0"
        self.muVetoZTTp001dxyzR0_branch = the_tree.GetBranch("muVetoZTTp001dxyzR0")
        #if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0" not in self.complained:
        if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0":
            warnings.warn( "EETauTree: Expected branch muVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyzR0")
        else:
            self.muVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.muVetoZTTp001dxyzR0_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "EETauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "EETauTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "EETauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "EETauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "EETauTree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "EETauTree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

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

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "EETauTree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

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

        #print "making singleE17SingleMu8Group"
        self.singleE17SingleMu8Group_branch = the_tree.GetBranch("singleE17SingleMu8Group")
        #if not self.singleE17SingleMu8Group_branch and "singleE17SingleMu8Group" not in self.complained:
        if not self.singleE17SingleMu8Group_branch and "singleE17SingleMu8Group":
            warnings.warn( "EETauTree: Expected branch singleE17SingleMu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE17SingleMu8Group")
        else:
            self.singleE17SingleMu8Group_branch.SetAddress(<void*>&self.singleE17SingleMu8Group_value)

        #print "making singleE17SingleMu8Pass"
        self.singleE17SingleMu8Pass_branch = the_tree.GetBranch("singleE17SingleMu8Pass")
        #if not self.singleE17SingleMu8Pass_branch and "singleE17SingleMu8Pass" not in self.complained:
        if not self.singleE17SingleMu8Pass_branch and "singleE17SingleMu8Pass":
            warnings.warn( "EETauTree: Expected branch singleE17SingleMu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE17SingleMu8Pass")
        else:
            self.singleE17SingleMu8Pass_branch.SetAddress(<void*>&self.singleE17SingleMu8Pass_value)

        #print "making singleE17SingleMu8Prescale"
        self.singleE17SingleMu8Prescale_branch = the_tree.GetBranch("singleE17SingleMu8Prescale")
        #if not self.singleE17SingleMu8Prescale_branch and "singleE17SingleMu8Prescale" not in self.complained:
        if not self.singleE17SingleMu8Prescale_branch and "singleE17SingleMu8Prescale":
            warnings.warn( "EETauTree: Expected branch singleE17SingleMu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE17SingleMu8Prescale")
        else:
            self.singleE17SingleMu8Prescale_branch.SetAddress(<void*>&self.singleE17SingleMu8Prescale_value)

        #print "making singleE20SingleTau28Group"
        self.singleE20SingleTau28Group_branch = the_tree.GetBranch("singleE20SingleTau28Group")
        #if not self.singleE20SingleTau28Group_branch and "singleE20SingleTau28Group" not in self.complained:
        if not self.singleE20SingleTau28Group_branch and "singleE20SingleTau28Group":
            warnings.warn( "EETauTree: Expected branch singleE20SingleTau28Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE20SingleTau28Group")
        else:
            self.singleE20SingleTau28Group_branch.SetAddress(<void*>&self.singleE20SingleTau28Group_value)

        #print "making singleE20SingleTau28Pass"
        self.singleE20SingleTau28Pass_branch = the_tree.GetBranch("singleE20SingleTau28Pass")
        #if not self.singleE20SingleTau28Pass_branch and "singleE20SingleTau28Pass" not in self.complained:
        if not self.singleE20SingleTau28Pass_branch and "singleE20SingleTau28Pass":
            warnings.warn( "EETauTree: Expected branch singleE20SingleTau28Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE20SingleTau28Pass")
        else:
            self.singleE20SingleTau28Pass_branch.SetAddress(<void*>&self.singleE20SingleTau28Pass_value)

        #print "making singleE20SingleTau28Prescale"
        self.singleE20SingleTau28Prescale_branch = the_tree.GetBranch("singleE20SingleTau28Prescale")
        #if not self.singleE20SingleTau28Prescale_branch and "singleE20SingleTau28Prescale" not in self.complained:
        if not self.singleE20SingleTau28Prescale_branch and "singleE20SingleTau28Prescale":
            warnings.warn( "EETauTree: Expected branch singleE20SingleTau28Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE20SingleTau28Prescale")
        else:
            self.singleE20SingleTau28Prescale_branch.SetAddress(<void*>&self.singleE20SingleTau28Prescale_value)

        #print "making singleE22SingleTau20SingleL1Group"
        self.singleE22SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE22SingleTau20SingleL1Group")
        #if not self.singleE22SingleTau20SingleL1Group_branch and "singleE22SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE22SingleTau20SingleL1Group_branch and "singleE22SingleTau20SingleL1Group":
            warnings.warn( "EETauTree: Expected branch singleE22SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau20SingleL1Group")
        else:
            self.singleE22SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE22SingleTau20SingleL1Group_value)

        #print "making singleE22SingleTau20SingleL1Pass"
        self.singleE22SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE22SingleTau20SingleL1Pass")
        #if not self.singleE22SingleTau20SingleL1Pass_branch and "singleE22SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE22SingleTau20SingleL1Pass_branch and "singleE22SingleTau20SingleL1Pass":
            warnings.warn( "EETauTree: Expected branch singleE22SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau20SingleL1Pass")
        else:
            self.singleE22SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE22SingleTau20SingleL1Pass_value)

        #print "making singleE22SingleTau20SingleL1Prescale"
        self.singleE22SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE22SingleTau20SingleL1Prescale")
        #if not self.singleE22SingleTau20SingleL1Prescale_branch and "singleE22SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE22SingleTau20SingleL1Prescale_branch and "singleE22SingleTau20SingleL1Prescale":
            warnings.warn( "EETauTree: Expected branch singleE22SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau20SingleL1Prescale")
        else:
            self.singleE22SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE22SingleTau20SingleL1Prescale_value)

        #print "making singleE22SingleTau29Group"
        self.singleE22SingleTau29Group_branch = the_tree.GetBranch("singleE22SingleTau29Group")
        #if not self.singleE22SingleTau29Group_branch and "singleE22SingleTau29Group" not in self.complained:
        if not self.singleE22SingleTau29Group_branch and "singleE22SingleTau29Group":
            warnings.warn( "EETauTree: Expected branch singleE22SingleTau29Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau29Group")
        else:
            self.singleE22SingleTau29Group_branch.SetAddress(<void*>&self.singleE22SingleTau29Group_value)

        #print "making singleE22SingleTau29Pass"
        self.singleE22SingleTau29Pass_branch = the_tree.GetBranch("singleE22SingleTau29Pass")
        #if not self.singleE22SingleTau29Pass_branch and "singleE22SingleTau29Pass" not in self.complained:
        if not self.singleE22SingleTau29Pass_branch and "singleE22SingleTau29Pass":
            warnings.warn( "EETauTree: Expected branch singleE22SingleTau29Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau29Pass")
        else:
            self.singleE22SingleTau29Pass_branch.SetAddress(<void*>&self.singleE22SingleTau29Pass_value)

        #print "making singleE22SingleTau29Prescale"
        self.singleE22SingleTau29Prescale_branch = the_tree.GetBranch("singleE22SingleTau29Prescale")
        #if not self.singleE22SingleTau29Prescale_branch and "singleE22SingleTau29Prescale" not in self.complained:
        if not self.singleE22SingleTau29Prescale_branch and "singleE22SingleTau29Prescale":
            warnings.warn( "EETauTree: Expected branch singleE22SingleTau29Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau29Prescale")
        else:
            self.singleE22SingleTau29Prescale_branch.SetAddress(<void*>&self.singleE22SingleTau29Prescale_value)

        #print "making singleE23SingleMu8Group"
        self.singleE23SingleMu8Group_branch = the_tree.GetBranch("singleE23SingleMu8Group")
        #if not self.singleE23SingleMu8Group_branch and "singleE23SingleMu8Group" not in self.complained:
        if not self.singleE23SingleMu8Group_branch and "singleE23SingleMu8Group":
            warnings.warn( "EETauTree: Expected branch singleE23SingleMu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23SingleMu8Group")
        else:
            self.singleE23SingleMu8Group_branch.SetAddress(<void*>&self.singleE23SingleMu8Group_value)

        #print "making singleE23SingleMu8Pass"
        self.singleE23SingleMu8Pass_branch = the_tree.GetBranch("singleE23SingleMu8Pass")
        #if not self.singleE23SingleMu8Pass_branch and "singleE23SingleMu8Pass" not in self.complained:
        if not self.singleE23SingleMu8Pass_branch and "singleE23SingleMu8Pass":
            warnings.warn( "EETauTree: Expected branch singleE23SingleMu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23SingleMu8Pass")
        else:
            self.singleE23SingleMu8Pass_branch.SetAddress(<void*>&self.singleE23SingleMu8Pass_value)

        #print "making singleE23SingleMu8Prescale"
        self.singleE23SingleMu8Prescale_branch = the_tree.GetBranch("singleE23SingleMu8Prescale")
        #if not self.singleE23SingleMu8Prescale_branch and "singleE23SingleMu8Prescale" not in self.complained:
        if not self.singleE23SingleMu8Prescale_branch and "singleE23SingleMu8Prescale":
            warnings.warn( "EETauTree: Expected branch singleE23SingleMu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23SingleMu8Prescale")
        else:
            self.singleE23SingleMu8Prescale_branch.SetAddress(<void*>&self.singleE23SingleMu8Prescale_value)

        #print "making singleE24SingleTau20Group"
        self.singleE24SingleTau20Group_branch = the_tree.GetBranch("singleE24SingleTau20Group")
        #if not self.singleE24SingleTau20Group_branch and "singleE24SingleTau20Group" not in self.complained:
        if not self.singleE24SingleTau20Group_branch and "singleE24SingleTau20Group":
            warnings.warn( "EETauTree: Expected branch singleE24SingleTau20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20Group")
        else:
            self.singleE24SingleTau20Group_branch.SetAddress(<void*>&self.singleE24SingleTau20Group_value)

        #print "making singleE24SingleTau20Pass"
        self.singleE24SingleTau20Pass_branch = the_tree.GetBranch("singleE24SingleTau20Pass")
        #if not self.singleE24SingleTau20Pass_branch and "singleE24SingleTau20Pass" not in self.complained:
        if not self.singleE24SingleTau20Pass_branch and "singleE24SingleTau20Pass":
            warnings.warn( "EETauTree: Expected branch singleE24SingleTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20Pass")
        else:
            self.singleE24SingleTau20Pass_branch.SetAddress(<void*>&self.singleE24SingleTau20Pass_value)

        #print "making singleE24SingleTau20Prescale"
        self.singleE24SingleTau20Prescale_branch = the_tree.GetBranch("singleE24SingleTau20Prescale")
        #if not self.singleE24SingleTau20Prescale_branch and "singleE24SingleTau20Prescale" not in self.complained:
        if not self.singleE24SingleTau20Prescale_branch and "singleE24SingleTau20Prescale":
            warnings.warn( "EETauTree: Expected branch singleE24SingleTau20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20Prescale")
        else:
            self.singleE24SingleTau20Prescale_branch.SetAddress(<void*>&self.singleE24SingleTau20Prescale_value)

        #print "making singleE24SingleTau20SingleL1Group"
        self.singleE24SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE24SingleTau20SingleL1Group")
        #if not self.singleE24SingleTau20SingleL1Group_branch and "singleE24SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE24SingleTau20SingleL1Group_branch and "singleE24SingleTau20SingleL1Group":
            warnings.warn( "EETauTree: Expected branch singleE24SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20SingleL1Group")
        else:
            self.singleE24SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE24SingleTau20SingleL1Group_value)

        #print "making singleE24SingleTau20SingleL1Pass"
        self.singleE24SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE24SingleTau20SingleL1Pass")
        #if not self.singleE24SingleTau20SingleL1Pass_branch and "singleE24SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE24SingleTau20SingleL1Pass_branch and "singleE24SingleTau20SingleL1Pass":
            warnings.warn( "EETauTree: Expected branch singleE24SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20SingleL1Pass")
        else:
            self.singleE24SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE24SingleTau20SingleL1Pass_value)

        #print "making singleE24SingleTau20SingleL1Prescale"
        self.singleE24SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE24SingleTau20SingleL1Prescale")
        #if not self.singleE24SingleTau20SingleL1Prescale_branch and "singleE24SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE24SingleTau20SingleL1Prescale_branch and "singleE24SingleTau20SingleL1Prescale":
            warnings.warn( "EETauTree: Expected branch singleE24SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20SingleL1Prescale")
        else:
            self.singleE24SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE24SingleTau20SingleL1Prescale_value)

        #print "making singleE24SingleTau30Group"
        self.singleE24SingleTau30Group_branch = the_tree.GetBranch("singleE24SingleTau30Group")
        #if not self.singleE24SingleTau30Group_branch and "singleE24SingleTau30Group" not in self.complained:
        if not self.singleE24SingleTau30Group_branch and "singleE24SingleTau30Group":
            warnings.warn( "EETauTree: Expected branch singleE24SingleTau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau30Group")
        else:
            self.singleE24SingleTau30Group_branch.SetAddress(<void*>&self.singleE24SingleTau30Group_value)

        #print "making singleE24SingleTau30Pass"
        self.singleE24SingleTau30Pass_branch = the_tree.GetBranch("singleE24SingleTau30Pass")
        #if not self.singleE24SingleTau30Pass_branch and "singleE24SingleTau30Pass" not in self.complained:
        if not self.singleE24SingleTau30Pass_branch and "singleE24SingleTau30Pass":
            warnings.warn( "EETauTree: Expected branch singleE24SingleTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau30Pass")
        else:
            self.singleE24SingleTau30Pass_branch.SetAddress(<void*>&self.singleE24SingleTau30Pass_value)

        #print "making singleE24SingleTau30Prescale"
        self.singleE24SingleTau30Prescale_branch = the_tree.GetBranch("singleE24SingleTau30Prescale")
        #if not self.singleE24SingleTau30Prescale_branch and "singleE24SingleTau30Prescale" not in self.complained:
        if not self.singleE24SingleTau30Prescale_branch and "singleE24SingleTau30Prescale":
            warnings.warn( "EETauTree: Expected branch singleE24SingleTau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau30Prescale")
        else:
            self.singleE24SingleTau30Prescale_branch.SetAddress(<void*>&self.singleE24SingleTau30Prescale_value)

        #print "making singleE25eta2p1TightGroup"
        self.singleE25eta2p1TightGroup_branch = the_tree.GetBranch("singleE25eta2p1TightGroup")
        #if not self.singleE25eta2p1TightGroup_branch and "singleE25eta2p1TightGroup" not in self.complained:
        if not self.singleE25eta2p1TightGroup_branch and "singleE25eta2p1TightGroup":
            warnings.warn( "EETauTree: Expected branch singleE25eta2p1TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightGroup")
        else:
            self.singleE25eta2p1TightGroup_branch.SetAddress(<void*>&self.singleE25eta2p1TightGroup_value)

        #print "making singleE25eta2p1TightPass"
        self.singleE25eta2p1TightPass_branch = the_tree.GetBranch("singleE25eta2p1TightPass")
        #if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass" not in self.complained:
        if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass":
            warnings.warn( "EETauTree: Expected branch singleE25eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPass")
        else:
            self.singleE25eta2p1TightPass_branch.SetAddress(<void*>&self.singleE25eta2p1TightPass_value)

        #print "making singleE25eta2p1TightPrescale"
        self.singleE25eta2p1TightPrescale_branch = the_tree.GetBranch("singleE25eta2p1TightPrescale")
        #if not self.singleE25eta2p1TightPrescale_branch and "singleE25eta2p1TightPrescale" not in self.complained:
        if not self.singleE25eta2p1TightPrescale_branch and "singleE25eta2p1TightPrescale":
            warnings.warn( "EETauTree: Expected branch singleE25eta2p1TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPrescale")
        else:
            self.singleE25eta2p1TightPrescale_branch.SetAddress(<void*>&self.singleE25eta2p1TightPrescale_value)

        #print "making singleE27SingleTau20SingleL1Group"
        self.singleE27SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE27SingleTau20SingleL1Group")
        #if not self.singleE27SingleTau20SingleL1Group_branch and "singleE27SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE27SingleTau20SingleL1Group_branch and "singleE27SingleTau20SingleL1Group":
            warnings.warn( "EETauTree: Expected branch singleE27SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27SingleTau20SingleL1Group")
        else:
            self.singleE27SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE27SingleTau20SingleL1Group_value)

        #print "making singleE27SingleTau20SingleL1Pass"
        self.singleE27SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE27SingleTau20SingleL1Pass")
        #if not self.singleE27SingleTau20SingleL1Pass_branch and "singleE27SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE27SingleTau20SingleL1Pass_branch and "singleE27SingleTau20SingleL1Pass":
            warnings.warn( "EETauTree: Expected branch singleE27SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27SingleTau20SingleL1Pass")
        else:
            self.singleE27SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE27SingleTau20SingleL1Pass_value)

        #print "making singleE27SingleTau20SingleL1Prescale"
        self.singleE27SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE27SingleTau20SingleL1Prescale")
        #if not self.singleE27SingleTau20SingleL1Prescale_branch and "singleE27SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE27SingleTau20SingleL1Prescale_branch and "singleE27SingleTau20SingleL1Prescale":
            warnings.warn( "EETauTree: Expected branch singleE27SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27SingleTau20SingleL1Prescale")
        else:
            self.singleE27SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE27SingleTau20SingleL1Prescale_value)

        #print "making singleE27TightGroup"
        self.singleE27TightGroup_branch = the_tree.GetBranch("singleE27TightGroup")
        #if not self.singleE27TightGroup_branch and "singleE27TightGroup" not in self.complained:
        if not self.singleE27TightGroup_branch and "singleE27TightGroup":
            warnings.warn( "EETauTree: Expected branch singleE27TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightGroup")
        else:
            self.singleE27TightGroup_branch.SetAddress(<void*>&self.singleE27TightGroup_value)

        #print "making singleE27TightPass"
        self.singleE27TightPass_branch = the_tree.GetBranch("singleE27TightPass")
        #if not self.singleE27TightPass_branch and "singleE27TightPass" not in self.complained:
        if not self.singleE27TightPass_branch and "singleE27TightPass":
            warnings.warn( "EETauTree: Expected branch singleE27TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightPass")
        else:
            self.singleE27TightPass_branch.SetAddress(<void*>&self.singleE27TightPass_value)

        #print "making singleE27TightPrescale"
        self.singleE27TightPrescale_branch = the_tree.GetBranch("singleE27TightPrescale")
        #if not self.singleE27TightPrescale_branch and "singleE27TightPrescale" not in self.complained:
        if not self.singleE27TightPrescale_branch and "singleE27TightPrescale":
            warnings.warn( "EETauTree: Expected branch singleE27TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightPrescale")
        else:
            self.singleE27TightPrescale_branch.SetAddress(<void*>&self.singleE27TightPrescale_value)

        #print "making singleE27eta2p1LooseGroup"
        self.singleE27eta2p1LooseGroup_branch = the_tree.GetBranch("singleE27eta2p1LooseGroup")
        #if not self.singleE27eta2p1LooseGroup_branch and "singleE27eta2p1LooseGroup" not in self.complained:
        if not self.singleE27eta2p1LooseGroup_branch and "singleE27eta2p1LooseGroup":
            warnings.warn( "EETauTree: Expected branch singleE27eta2p1LooseGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1LooseGroup")
        else:
            self.singleE27eta2p1LooseGroup_branch.SetAddress(<void*>&self.singleE27eta2p1LooseGroup_value)

        #print "making singleE27eta2p1LoosePass"
        self.singleE27eta2p1LoosePass_branch = the_tree.GetBranch("singleE27eta2p1LoosePass")
        #if not self.singleE27eta2p1LoosePass_branch and "singleE27eta2p1LoosePass" not in self.complained:
        if not self.singleE27eta2p1LoosePass_branch and "singleE27eta2p1LoosePass":
            warnings.warn( "EETauTree: Expected branch singleE27eta2p1LoosePass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1LoosePass")
        else:
            self.singleE27eta2p1LoosePass_branch.SetAddress(<void*>&self.singleE27eta2p1LoosePass_value)

        #print "making singleE27eta2p1LoosePrescale"
        self.singleE27eta2p1LoosePrescale_branch = the_tree.GetBranch("singleE27eta2p1LoosePrescale")
        #if not self.singleE27eta2p1LoosePrescale_branch and "singleE27eta2p1LoosePrescale" not in self.complained:
        if not self.singleE27eta2p1LoosePrescale_branch and "singleE27eta2p1LoosePrescale":
            warnings.warn( "EETauTree: Expected branch singleE27eta2p1LoosePrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1LoosePrescale")
        else:
            self.singleE27eta2p1LoosePrescale_branch.SetAddress(<void*>&self.singleE27eta2p1LoosePrescale_value)

        #print "making singleE27eta2p1TightGroup"
        self.singleE27eta2p1TightGroup_branch = the_tree.GetBranch("singleE27eta2p1TightGroup")
        #if not self.singleE27eta2p1TightGroup_branch and "singleE27eta2p1TightGroup" not in self.complained:
        if not self.singleE27eta2p1TightGroup_branch and "singleE27eta2p1TightGroup":
            warnings.warn( "EETauTree: Expected branch singleE27eta2p1TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1TightGroup")
        else:
            self.singleE27eta2p1TightGroup_branch.SetAddress(<void*>&self.singleE27eta2p1TightGroup_value)

        #print "making singleE27eta2p1TightPass"
        self.singleE27eta2p1TightPass_branch = the_tree.GetBranch("singleE27eta2p1TightPass")
        #if not self.singleE27eta2p1TightPass_branch and "singleE27eta2p1TightPass" not in self.complained:
        if not self.singleE27eta2p1TightPass_branch and "singleE27eta2p1TightPass":
            warnings.warn( "EETauTree: Expected branch singleE27eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1TightPass")
        else:
            self.singleE27eta2p1TightPass_branch.SetAddress(<void*>&self.singleE27eta2p1TightPass_value)

        #print "making singleE27eta2p1TightPrescale"
        self.singleE27eta2p1TightPrescale_branch = the_tree.GetBranch("singleE27eta2p1TightPrescale")
        #if not self.singleE27eta2p1TightPrescale_branch and "singleE27eta2p1TightPrescale" not in self.complained:
        if not self.singleE27eta2p1TightPrescale_branch and "singleE27eta2p1TightPrescale":
            warnings.warn( "EETauTree: Expected branch singleE27eta2p1TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1TightPrescale")
        else:
            self.singleE27eta2p1TightPrescale_branch.SetAddress(<void*>&self.singleE27eta2p1TightPrescale_value)

        #print "making singleE32SingleTau20SingleL1Group"
        self.singleE32SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE32SingleTau20SingleL1Group")
        #if not self.singleE32SingleTau20SingleL1Group_branch and "singleE32SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE32SingleTau20SingleL1Group_branch and "singleE32SingleTau20SingleL1Group":
            warnings.warn( "EETauTree: Expected branch singleE32SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE32SingleTau20SingleL1Group")
        else:
            self.singleE32SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE32SingleTau20SingleL1Group_value)

        #print "making singleE32SingleTau20SingleL1Pass"
        self.singleE32SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE32SingleTau20SingleL1Pass")
        #if not self.singleE32SingleTau20SingleL1Pass_branch and "singleE32SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE32SingleTau20SingleL1Pass_branch and "singleE32SingleTau20SingleL1Pass":
            warnings.warn( "EETauTree: Expected branch singleE32SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE32SingleTau20SingleL1Pass")
        else:
            self.singleE32SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE32SingleTau20SingleL1Pass_value)

        #print "making singleE32SingleTau20SingleL1Prescale"
        self.singleE32SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE32SingleTau20SingleL1Prescale")
        #if not self.singleE32SingleTau20SingleL1Prescale_branch and "singleE32SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE32SingleTau20SingleL1Prescale_branch and "singleE32SingleTau20SingleL1Prescale":
            warnings.warn( "EETauTree: Expected branch singleE32SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE32SingleTau20SingleL1Prescale")
        else:
            self.singleE32SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE32SingleTau20SingleL1Prescale_value)

        #print "making singleE36SingleTau30Group"
        self.singleE36SingleTau30Group_branch = the_tree.GetBranch("singleE36SingleTau30Group")
        #if not self.singleE36SingleTau30Group_branch and "singleE36SingleTau30Group" not in self.complained:
        if not self.singleE36SingleTau30Group_branch and "singleE36SingleTau30Group":
            warnings.warn( "EETauTree: Expected branch singleE36SingleTau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE36SingleTau30Group")
        else:
            self.singleE36SingleTau30Group_branch.SetAddress(<void*>&self.singleE36SingleTau30Group_value)

        #print "making singleE36SingleTau30Pass"
        self.singleE36SingleTau30Pass_branch = the_tree.GetBranch("singleE36SingleTau30Pass")
        #if not self.singleE36SingleTau30Pass_branch and "singleE36SingleTau30Pass" not in self.complained:
        if not self.singleE36SingleTau30Pass_branch and "singleE36SingleTau30Pass":
            warnings.warn( "EETauTree: Expected branch singleE36SingleTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE36SingleTau30Pass")
        else:
            self.singleE36SingleTau30Pass_branch.SetAddress(<void*>&self.singleE36SingleTau30Pass_value)

        #print "making singleE36SingleTau30Prescale"
        self.singleE36SingleTau30Prescale_branch = the_tree.GetBranch("singleE36SingleTau30Prescale")
        #if not self.singleE36SingleTau30Prescale_branch and "singleE36SingleTau30Prescale" not in self.complained:
        if not self.singleE36SingleTau30Prescale_branch and "singleE36SingleTau30Prescale":
            warnings.warn( "EETauTree: Expected branch singleE36SingleTau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE36SingleTau30Prescale")
        else:
            self.singleE36SingleTau30Prescale_branch.SetAddress(<void*>&self.singleE36SingleTau30Prescale_value)

        #print "making singleESingleMuGroup"
        self.singleESingleMuGroup_branch = the_tree.GetBranch("singleESingleMuGroup")
        #if not self.singleESingleMuGroup_branch and "singleESingleMuGroup" not in self.complained:
        if not self.singleESingleMuGroup_branch and "singleESingleMuGroup":
            warnings.warn( "EETauTree: Expected branch singleESingleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleESingleMuGroup")
        else:
            self.singleESingleMuGroup_branch.SetAddress(<void*>&self.singleESingleMuGroup_value)

        #print "making singleESingleMuPass"
        self.singleESingleMuPass_branch = the_tree.GetBranch("singleESingleMuPass")
        #if not self.singleESingleMuPass_branch and "singleESingleMuPass" not in self.complained:
        if not self.singleESingleMuPass_branch and "singleESingleMuPass":
            warnings.warn( "EETauTree: Expected branch singleESingleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleESingleMuPass")
        else:
            self.singleESingleMuPass_branch.SetAddress(<void*>&self.singleESingleMuPass_value)

        #print "making singleESingleMuPrescale"
        self.singleESingleMuPrescale_branch = the_tree.GetBranch("singleESingleMuPrescale")
        #if not self.singleESingleMuPrescale_branch and "singleESingleMuPrescale" not in self.complained:
        if not self.singleESingleMuPrescale_branch and "singleESingleMuPrescale":
            warnings.warn( "EETauTree: Expected branch singleESingleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleESingleMuPrescale")
        else:
            self.singleESingleMuPrescale_branch.SetAddress(<void*>&self.singleESingleMuPrescale_value)

        #print "making singleE_leg1Group"
        self.singleE_leg1Group_branch = the_tree.GetBranch("singleE_leg1Group")
        #if not self.singleE_leg1Group_branch and "singleE_leg1Group" not in self.complained:
        if not self.singleE_leg1Group_branch and "singleE_leg1Group":
            warnings.warn( "EETauTree: Expected branch singleE_leg1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg1Group")
        else:
            self.singleE_leg1Group_branch.SetAddress(<void*>&self.singleE_leg1Group_value)

        #print "making singleE_leg1Pass"
        self.singleE_leg1Pass_branch = the_tree.GetBranch("singleE_leg1Pass")
        #if not self.singleE_leg1Pass_branch and "singleE_leg1Pass" not in self.complained:
        if not self.singleE_leg1Pass_branch and "singleE_leg1Pass":
            warnings.warn( "EETauTree: Expected branch singleE_leg1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg1Pass")
        else:
            self.singleE_leg1Pass_branch.SetAddress(<void*>&self.singleE_leg1Pass_value)

        #print "making singleE_leg1Prescale"
        self.singleE_leg1Prescale_branch = the_tree.GetBranch("singleE_leg1Prescale")
        #if not self.singleE_leg1Prescale_branch and "singleE_leg1Prescale" not in self.complained:
        if not self.singleE_leg1Prescale_branch and "singleE_leg1Prescale":
            warnings.warn( "EETauTree: Expected branch singleE_leg1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg1Prescale")
        else:
            self.singleE_leg1Prescale_branch.SetAddress(<void*>&self.singleE_leg1Prescale_value)

        #print "making singleE_leg2Group"
        self.singleE_leg2Group_branch = the_tree.GetBranch("singleE_leg2Group")
        #if not self.singleE_leg2Group_branch and "singleE_leg2Group" not in self.complained:
        if not self.singleE_leg2Group_branch and "singleE_leg2Group":
            warnings.warn( "EETauTree: Expected branch singleE_leg2Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg2Group")
        else:
            self.singleE_leg2Group_branch.SetAddress(<void*>&self.singleE_leg2Group_value)

        #print "making singleE_leg2Pass"
        self.singleE_leg2Pass_branch = the_tree.GetBranch("singleE_leg2Pass")
        #if not self.singleE_leg2Pass_branch and "singleE_leg2Pass" not in self.complained:
        if not self.singleE_leg2Pass_branch and "singleE_leg2Pass":
            warnings.warn( "EETauTree: Expected branch singleE_leg2Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg2Pass")
        else:
            self.singleE_leg2Pass_branch.SetAddress(<void*>&self.singleE_leg2Pass_value)

        #print "making singleE_leg2Prescale"
        self.singleE_leg2Prescale_branch = the_tree.GetBranch("singleE_leg2Prescale")
        #if not self.singleE_leg2Prescale_branch and "singleE_leg2Prescale" not in self.complained:
        if not self.singleE_leg2Prescale_branch and "singleE_leg2Prescale":
            warnings.warn( "EETauTree: Expected branch singleE_leg2Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg2Prescale")
        else:
            self.singleE_leg2Prescale_branch.SetAddress(<void*>&self.singleE_leg2Prescale_value)

        #print "making singleIsoMu20Group"
        self.singleIsoMu20Group_branch = the_tree.GetBranch("singleIsoMu20Group")
        #if not self.singleIsoMu20Group_branch and "singleIsoMu20Group" not in self.complained:
        if not self.singleIsoMu20Group_branch and "singleIsoMu20Group":
            warnings.warn( "EETauTree: Expected branch singleIsoMu20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Group")
        else:
            self.singleIsoMu20Group_branch.SetAddress(<void*>&self.singleIsoMu20Group_value)

        #print "making singleIsoMu20Pass"
        self.singleIsoMu20Pass_branch = the_tree.GetBranch("singleIsoMu20Pass")
        #if not self.singleIsoMu20Pass_branch and "singleIsoMu20Pass" not in self.complained:
        if not self.singleIsoMu20Pass_branch and "singleIsoMu20Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Pass")
        else:
            self.singleIsoMu20Pass_branch.SetAddress(<void*>&self.singleIsoMu20Pass_value)

        #print "making singleIsoMu20Prescale"
        self.singleIsoMu20Prescale_branch = the_tree.GetBranch("singleIsoMu20Prescale")
        #if not self.singleIsoMu20Prescale_branch and "singleIsoMu20Prescale" not in self.complained:
        if not self.singleIsoMu20Prescale_branch and "singleIsoMu20Prescale":
            warnings.warn( "EETauTree: Expected branch singleIsoMu20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Prescale")
        else:
            self.singleIsoMu20Prescale_branch.SetAddress(<void*>&self.singleIsoMu20Prescale_value)

        #print "making singleIsoMu22Group"
        self.singleIsoMu22Group_branch = the_tree.GetBranch("singleIsoMu22Group")
        #if not self.singleIsoMu22Group_branch and "singleIsoMu22Group" not in self.complained:
        if not self.singleIsoMu22Group_branch and "singleIsoMu22Group":
            warnings.warn( "EETauTree: Expected branch singleIsoMu22Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Group")
        else:
            self.singleIsoMu22Group_branch.SetAddress(<void*>&self.singleIsoMu22Group_value)

        #print "making singleIsoMu22Pass"
        self.singleIsoMu22Pass_branch = the_tree.GetBranch("singleIsoMu22Pass")
        #if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass" not in self.complained:
        if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Pass")
        else:
            self.singleIsoMu22Pass_branch.SetAddress(<void*>&self.singleIsoMu22Pass_value)

        #print "making singleIsoMu22Prescale"
        self.singleIsoMu22Prescale_branch = the_tree.GetBranch("singleIsoMu22Prescale")
        #if not self.singleIsoMu22Prescale_branch and "singleIsoMu22Prescale" not in self.complained:
        if not self.singleIsoMu22Prescale_branch and "singleIsoMu22Prescale":
            warnings.warn( "EETauTree: Expected branch singleIsoMu22Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Prescale")
        else:
            self.singleIsoMu22Prescale_branch.SetAddress(<void*>&self.singleIsoMu22Prescale_value)

        #print "making singleIsoMu22eta2p1Group"
        self.singleIsoMu22eta2p1Group_branch = the_tree.GetBranch("singleIsoMu22eta2p1Group")
        #if not self.singleIsoMu22eta2p1Group_branch and "singleIsoMu22eta2p1Group" not in self.complained:
        if not self.singleIsoMu22eta2p1Group_branch and "singleIsoMu22eta2p1Group":
            warnings.warn( "EETauTree: Expected branch singleIsoMu22eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Group")
        else:
            self.singleIsoMu22eta2p1Group_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Group_value)

        #print "making singleIsoMu22eta2p1Pass"
        self.singleIsoMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu22eta2p1Pass")
        #if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Pass")
        else:
            self.singleIsoMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Pass_value)

        #print "making singleIsoMu22eta2p1Prescale"
        self.singleIsoMu22eta2p1Prescale_branch = the_tree.GetBranch("singleIsoMu22eta2p1Prescale")
        #if not self.singleIsoMu22eta2p1Prescale_branch and "singleIsoMu22eta2p1Prescale" not in self.complained:
        if not self.singleIsoMu22eta2p1Prescale_branch and "singleIsoMu22eta2p1Prescale":
            warnings.warn( "EETauTree: Expected branch singleIsoMu22eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Prescale")
        else:
            self.singleIsoMu22eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Prescale_value)

        #print "making singleIsoMu24Group"
        self.singleIsoMu24Group_branch = the_tree.GetBranch("singleIsoMu24Group")
        #if not self.singleIsoMu24Group_branch and "singleIsoMu24Group" not in self.complained:
        if not self.singleIsoMu24Group_branch and "singleIsoMu24Group":
            warnings.warn( "EETauTree: Expected branch singleIsoMu24Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Group")
        else:
            self.singleIsoMu24Group_branch.SetAddress(<void*>&self.singleIsoMu24Group_value)

        #print "making singleIsoMu24Pass"
        self.singleIsoMu24Pass_branch = the_tree.GetBranch("singleIsoMu24Pass")
        #if not self.singleIsoMu24Pass_branch and "singleIsoMu24Pass" not in self.complained:
        if not self.singleIsoMu24Pass_branch and "singleIsoMu24Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Pass")
        else:
            self.singleIsoMu24Pass_branch.SetAddress(<void*>&self.singleIsoMu24Pass_value)

        #print "making singleIsoMu24Prescale"
        self.singleIsoMu24Prescale_branch = the_tree.GetBranch("singleIsoMu24Prescale")
        #if not self.singleIsoMu24Prescale_branch and "singleIsoMu24Prescale" not in self.complained:
        if not self.singleIsoMu24Prescale_branch and "singleIsoMu24Prescale":
            warnings.warn( "EETauTree: Expected branch singleIsoMu24Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Prescale")
        else:
            self.singleIsoMu24Prescale_branch.SetAddress(<void*>&self.singleIsoMu24Prescale_value)

        #print "making singleIsoMu24eta2p1Group"
        self.singleIsoMu24eta2p1Group_branch = the_tree.GetBranch("singleIsoMu24eta2p1Group")
        #if not self.singleIsoMu24eta2p1Group_branch and "singleIsoMu24eta2p1Group" not in self.complained:
        if not self.singleIsoMu24eta2p1Group_branch and "singleIsoMu24eta2p1Group":
            warnings.warn( "EETauTree: Expected branch singleIsoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24eta2p1Group")
        else:
            self.singleIsoMu24eta2p1Group_branch.SetAddress(<void*>&self.singleIsoMu24eta2p1Group_value)

        #print "making singleIsoMu24eta2p1Pass"
        self.singleIsoMu24eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu24eta2p1Pass")
        #if not self.singleIsoMu24eta2p1Pass_branch and "singleIsoMu24eta2p1Pass" not in self.complained:
        if not self.singleIsoMu24eta2p1Pass_branch and "singleIsoMu24eta2p1Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24eta2p1Pass")
        else:
            self.singleIsoMu24eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu24eta2p1Pass_value)

        #print "making singleIsoMu24eta2p1Prescale"
        self.singleIsoMu24eta2p1Prescale_branch = the_tree.GetBranch("singleIsoMu24eta2p1Prescale")
        #if not self.singleIsoMu24eta2p1Prescale_branch and "singleIsoMu24eta2p1Prescale" not in self.complained:
        if not self.singleIsoMu24eta2p1Prescale_branch and "singleIsoMu24eta2p1Prescale":
            warnings.warn( "EETauTree: Expected branch singleIsoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24eta2p1Prescale")
        else:
            self.singleIsoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoMu24eta2p1Prescale_value)

        #print "making singleIsoMu27Group"
        self.singleIsoMu27Group_branch = the_tree.GetBranch("singleIsoMu27Group")
        #if not self.singleIsoMu27Group_branch and "singleIsoMu27Group" not in self.complained:
        if not self.singleIsoMu27Group_branch and "singleIsoMu27Group":
            warnings.warn( "EETauTree: Expected branch singleIsoMu27Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Group")
        else:
            self.singleIsoMu27Group_branch.SetAddress(<void*>&self.singleIsoMu27Group_value)

        #print "making singleIsoMu27Pass"
        self.singleIsoMu27Pass_branch = the_tree.GetBranch("singleIsoMu27Pass")
        #if not self.singleIsoMu27Pass_branch and "singleIsoMu27Pass" not in self.complained:
        if not self.singleIsoMu27Pass_branch and "singleIsoMu27Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Pass")
        else:
            self.singleIsoMu27Pass_branch.SetAddress(<void*>&self.singleIsoMu27Pass_value)

        #print "making singleIsoMu27Prescale"
        self.singleIsoMu27Prescale_branch = the_tree.GetBranch("singleIsoMu27Prescale")
        #if not self.singleIsoMu27Prescale_branch and "singleIsoMu27Prescale" not in self.complained:
        if not self.singleIsoMu27Prescale_branch and "singleIsoMu27Prescale":
            warnings.warn( "EETauTree: Expected branch singleIsoMu27Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Prescale")
        else:
            self.singleIsoMu27Prescale_branch.SetAddress(<void*>&self.singleIsoMu27Prescale_value)

        #print "making singleIsoTkMu20Group"
        self.singleIsoTkMu20Group_branch = the_tree.GetBranch("singleIsoTkMu20Group")
        #if not self.singleIsoTkMu20Group_branch and "singleIsoTkMu20Group" not in self.complained:
        if not self.singleIsoTkMu20Group_branch and "singleIsoTkMu20Group":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu20Group")
        else:
            self.singleIsoTkMu20Group_branch.SetAddress(<void*>&self.singleIsoTkMu20Group_value)

        #print "making singleIsoTkMu20Pass"
        self.singleIsoTkMu20Pass_branch = the_tree.GetBranch("singleIsoTkMu20Pass")
        #if not self.singleIsoTkMu20Pass_branch and "singleIsoTkMu20Pass" not in self.complained:
        if not self.singleIsoTkMu20Pass_branch and "singleIsoTkMu20Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu20Pass")
        else:
            self.singleIsoTkMu20Pass_branch.SetAddress(<void*>&self.singleIsoTkMu20Pass_value)

        #print "making singleIsoTkMu20Prescale"
        self.singleIsoTkMu20Prescale_branch = the_tree.GetBranch("singleIsoTkMu20Prescale")
        #if not self.singleIsoTkMu20Prescale_branch and "singleIsoTkMu20Prescale" not in self.complained:
        if not self.singleIsoTkMu20Prescale_branch and "singleIsoTkMu20Prescale":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu20Prescale")
        else:
            self.singleIsoTkMu20Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu20Prescale_value)

        #print "making singleIsoTkMu22Group"
        self.singleIsoTkMu22Group_branch = the_tree.GetBranch("singleIsoTkMu22Group")
        #if not self.singleIsoTkMu22Group_branch and "singleIsoTkMu22Group" not in self.complained:
        if not self.singleIsoTkMu22Group_branch and "singleIsoTkMu22Group":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu22Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Group")
        else:
            self.singleIsoTkMu22Group_branch.SetAddress(<void*>&self.singleIsoTkMu22Group_value)

        #print "making singleIsoTkMu22Pass"
        self.singleIsoTkMu22Pass_branch = the_tree.GetBranch("singleIsoTkMu22Pass")
        #if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass" not in self.complained:
        if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Pass")
        else:
            self.singleIsoTkMu22Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22Pass_value)

        #print "making singleIsoTkMu22Prescale"
        self.singleIsoTkMu22Prescale_branch = the_tree.GetBranch("singleIsoTkMu22Prescale")
        #if not self.singleIsoTkMu22Prescale_branch and "singleIsoTkMu22Prescale" not in self.complained:
        if not self.singleIsoTkMu22Prescale_branch and "singleIsoTkMu22Prescale":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu22Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Prescale")
        else:
            self.singleIsoTkMu22Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu22Prescale_value)

        #print "making singleIsoTkMu22eta2p1Group"
        self.singleIsoTkMu22eta2p1Group_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Group")
        #if not self.singleIsoTkMu22eta2p1Group_branch and "singleIsoTkMu22eta2p1Group" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Group_branch and "singleIsoTkMu22eta2p1Group":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu22eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Group")
        else:
            self.singleIsoTkMu22eta2p1Group_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Group_value)

        #print "making singleIsoTkMu22eta2p1Pass"
        self.singleIsoTkMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Pass")
        #if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Pass")
        else:
            self.singleIsoTkMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Pass_value)

        #print "making singleIsoTkMu22eta2p1Prescale"
        self.singleIsoTkMu22eta2p1Prescale_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Prescale")
        #if not self.singleIsoTkMu22eta2p1Prescale_branch and "singleIsoTkMu22eta2p1Prescale" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Prescale_branch and "singleIsoTkMu22eta2p1Prescale":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu22eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Prescale")
        else:
            self.singleIsoTkMu22eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Prescale_value)

        #print "making singleIsoTkMu24Group"
        self.singleIsoTkMu24Group_branch = the_tree.GetBranch("singleIsoTkMu24Group")
        #if not self.singleIsoTkMu24Group_branch and "singleIsoTkMu24Group" not in self.complained:
        if not self.singleIsoTkMu24Group_branch and "singleIsoTkMu24Group":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu24Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Group")
        else:
            self.singleIsoTkMu24Group_branch.SetAddress(<void*>&self.singleIsoTkMu24Group_value)

        #print "making singleIsoTkMu24Pass"
        self.singleIsoTkMu24Pass_branch = the_tree.GetBranch("singleIsoTkMu24Pass")
        #if not self.singleIsoTkMu24Pass_branch and "singleIsoTkMu24Pass" not in self.complained:
        if not self.singleIsoTkMu24Pass_branch and "singleIsoTkMu24Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Pass")
        else:
            self.singleIsoTkMu24Pass_branch.SetAddress(<void*>&self.singleIsoTkMu24Pass_value)

        #print "making singleIsoTkMu24Prescale"
        self.singleIsoTkMu24Prescale_branch = the_tree.GetBranch("singleIsoTkMu24Prescale")
        #if not self.singleIsoTkMu24Prescale_branch and "singleIsoTkMu24Prescale" not in self.complained:
        if not self.singleIsoTkMu24Prescale_branch and "singleIsoTkMu24Prescale":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu24Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Prescale")
        else:
            self.singleIsoTkMu24Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu24Prescale_value)

        #print "making singleIsoTkMu24eta2p1Group"
        self.singleIsoTkMu24eta2p1Group_branch = the_tree.GetBranch("singleIsoTkMu24eta2p1Group")
        #if not self.singleIsoTkMu24eta2p1Group_branch and "singleIsoTkMu24eta2p1Group" not in self.complained:
        if not self.singleIsoTkMu24eta2p1Group_branch and "singleIsoTkMu24eta2p1Group":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24eta2p1Group")
        else:
            self.singleIsoTkMu24eta2p1Group_branch.SetAddress(<void*>&self.singleIsoTkMu24eta2p1Group_value)

        #print "making singleIsoTkMu24eta2p1Pass"
        self.singleIsoTkMu24eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu24eta2p1Pass")
        #if not self.singleIsoTkMu24eta2p1Pass_branch and "singleIsoTkMu24eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu24eta2p1Pass_branch and "singleIsoTkMu24eta2p1Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24eta2p1Pass")
        else:
            self.singleIsoTkMu24eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu24eta2p1Pass_value)

        #print "making singleIsoTkMu24eta2p1Prescale"
        self.singleIsoTkMu24eta2p1Prescale_branch = the_tree.GetBranch("singleIsoTkMu24eta2p1Prescale")
        #if not self.singleIsoTkMu24eta2p1Prescale_branch and "singleIsoTkMu24eta2p1Prescale" not in self.complained:
        if not self.singleIsoTkMu24eta2p1Prescale_branch and "singleIsoTkMu24eta2p1Prescale":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24eta2p1Prescale")
        else:
            self.singleIsoTkMu24eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu24eta2p1Prescale_value)

        #print "making singleMu17SingleE12Group"
        self.singleMu17SingleE12Group_branch = the_tree.GetBranch("singleMu17SingleE12Group")
        #if not self.singleMu17SingleE12Group_branch and "singleMu17SingleE12Group" not in self.complained:
        if not self.singleMu17SingleE12Group_branch and "singleMu17SingleE12Group":
            warnings.warn( "EETauTree: Expected branch singleMu17SingleE12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu17SingleE12Group")
        else:
            self.singleMu17SingleE12Group_branch.SetAddress(<void*>&self.singleMu17SingleE12Group_value)

        #print "making singleMu17SingleE12Pass"
        self.singleMu17SingleE12Pass_branch = the_tree.GetBranch("singleMu17SingleE12Pass")
        #if not self.singleMu17SingleE12Pass_branch and "singleMu17SingleE12Pass" not in self.complained:
        if not self.singleMu17SingleE12Pass_branch and "singleMu17SingleE12Pass":
            warnings.warn( "EETauTree: Expected branch singleMu17SingleE12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu17SingleE12Pass")
        else:
            self.singleMu17SingleE12Pass_branch.SetAddress(<void*>&self.singleMu17SingleE12Pass_value)

        #print "making singleMu17SingleE12Prescale"
        self.singleMu17SingleE12Prescale_branch = the_tree.GetBranch("singleMu17SingleE12Prescale")
        #if not self.singleMu17SingleE12Prescale_branch and "singleMu17SingleE12Prescale" not in self.complained:
        if not self.singleMu17SingleE12Prescale_branch and "singleMu17SingleE12Prescale":
            warnings.warn( "EETauTree: Expected branch singleMu17SingleE12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu17SingleE12Prescale")
        else:
            self.singleMu17SingleE12Prescale_branch.SetAddress(<void*>&self.singleMu17SingleE12Prescale_value)

        #print "making singleMu19eta2p1LooseTau20Group"
        self.singleMu19eta2p1LooseTau20Group_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Group")
        #if not self.singleMu19eta2p1LooseTau20Group_branch and "singleMu19eta2p1LooseTau20Group" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Group_branch and "singleMu19eta2p1LooseTau20Group":
            warnings.warn( "EETauTree: Expected branch singleMu19eta2p1LooseTau20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Group")
        else:
            self.singleMu19eta2p1LooseTau20Group_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Group_value)

        #print "making singleMu19eta2p1LooseTau20Pass"
        self.singleMu19eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Pass")
        #if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass":
            warnings.warn( "EETauTree: Expected branch singleMu19eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Pass")
        else:
            self.singleMu19eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Pass_value)

        #print "making singleMu19eta2p1LooseTau20Prescale"
        self.singleMu19eta2p1LooseTau20Prescale_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Prescale")
        #if not self.singleMu19eta2p1LooseTau20Prescale_branch and "singleMu19eta2p1LooseTau20Prescale" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Prescale_branch and "singleMu19eta2p1LooseTau20Prescale":
            warnings.warn( "EETauTree: Expected branch singleMu19eta2p1LooseTau20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Prescale")
        else:
            self.singleMu19eta2p1LooseTau20Prescale_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Prescale_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Group"
        self.singleMu19eta2p1LooseTau20singleL1Group_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Group")
        #if not self.singleMu19eta2p1LooseTau20singleL1Group_branch and "singleMu19eta2p1LooseTau20singleL1Group" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Group_branch and "singleMu19eta2p1LooseTau20singleL1Group":
            warnings.warn( "EETauTree: Expected branch singleMu19eta2p1LooseTau20singleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Group")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Group_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Group_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Pass"
        self.singleMu19eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass":
            warnings.warn( "EETauTree: Expected branch singleMu19eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Pass_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Prescale"
        self.singleMu19eta2p1LooseTau20singleL1Prescale_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Prescale")
        #if not self.singleMu19eta2p1LooseTau20singleL1Prescale_branch and "singleMu19eta2p1LooseTau20singleL1Prescale" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Prescale_branch and "singleMu19eta2p1LooseTau20singleL1Prescale":
            warnings.warn( "EETauTree: Expected branch singleMu19eta2p1LooseTau20singleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Prescale")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Prescale_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Prescale_value)

        #print "making singleMu21eta2p1LooseTau20singleL1Group"
        self.singleMu21eta2p1LooseTau20singleL1Group_branch = the_tree.GetBranch("singleMu21eta2p1LooseTau20singleL1Group")
        #if not self.singleMu21eta2p1LooseTau20singleL1Group_branch and "singleMu21eta2p1LooseTau20singleL1Group" not in self.complained:
        if not self.singleMu21eta2p1LooseTau20singleL1Group_branch and "singleMu21eta2p1LooseTau20singleL1Group":
            warnings.warn( "EETauTree: Expected branch singleMu21eta2p1LooseTau20singleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu21eta2p1LooseTau20singleL1Group")
        else:
            self.singleMu21eta2p1LooseTau20singleL1Group_branch.SetAddress(<void*>&self.singleMu21eta2p1LooseTau20singleL1Group_value)

        #print "making singleMu21eta2p1LooseTau20singleL1Pass"
        self.singleMu21eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu21eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu21eta2p1LooseTau20singleL1Pass_branch and "singleMu21eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu21eta2p1LooseTau20singleL1Pass_branch and "singleMu21eta2p1LooseTau20singleL1Pass":
            warnings.warn( "EETauTree: Expected branch singleMu21eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu21eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu21eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu21eta2p1LooseTau20singleL1Pass_value)

        #print "making singleMu21eta2p1LooseTau20singleL1Prescale"
        self.singleMu21eta2p1LooseTau20singleL1Prescale_branch = the_tree.GetBranch("singleMu21eta2p1LooseTau20singleL1Prescale")
        #if not self.singleMu21eta2p1LooseTau20singleL1Prescale_branch and "singleMu21eta2p1LooseTau20singleL1Prescale" not in self.complained:
        if not self.singleMu21eta2p1LooseTau20singleL1Prescale_branch and "singleMu21eta2p1LooseTau20singleL1Prescale":
            warnings.warn( "EETauTree: Expected branch singleMu21eta2p1LooseTau20singleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu21eta2p1LooseTau20singleL1Prescale")
        else:
            self.singleMu21eta2p1LooseTau20singleL1Prescale_branch.SetAddress(<void*>&self.singleMu21eta2p1LooseTau20singleL1Prescale_value)

        #print "making singleMu23SingleE12DZGroup"
        self.singleMu23SingleE12DZGroup_branch = the_tree.GetBranch("singleMu23SingleE12DZGroup")
        #if not self.singleMu23SingleE12DZGroup_branch and "singleMu23SingleE12DZGroup" not in self.complained:
        if not self.singleMu23SingleE12DZGroup_branch and "singleMu23SingleE12DZGroup":
            warnings.warn( "EETauTree: Expected branch singleMu23SingleE12DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZGroup")
        else:
            self.singleMu23SingleE12DZGroup_branch.SetAddress(<void*>&self.singleMu23SingleE12DZGroup_value)

        #print "making singleMu23SingleE12DZPass"
        self.singleMu23SingleE12DZPass_branch = the_tree.GetBranch("singleMu23SingleE12DZPass")
        #if not self.singleMu23SingleE12DZPass_branch and "singleMu23SingleE12DZPass" not in self.complained:
        if not self.singleMu23SingleE12DZPass_branch and "singleMu23SingleE12DZPass":
            warnings.warn( "EETauTree: Expected branch singleMu23SingleE12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZPass")
        else:
            self.singleMu23SingleE12DZPass_branch.SetAddress(<void*>&self.singleMu23SingleE12DZPass_value)

        #print "making singleMu23SingleE12DZPrescale"
        self.singleMu23SingleE12DZPrescale_branch = the_tree.GetBranch("singleMu23SingleE12DZPrescale")
        #if not self.singleMu23SingleE12DZPrescale_branch and "singleMu23SingleE12DZPrescale" not in self.complained:
        if not self.singleMu23SingleE12DZPrescale_branch and "singleMu23SingleE12DZPrescale":
            warnings.warn( "EETauTree: Expected branch singleMu23SingleE12DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZPrescale")
        else:
            self.singleMu23SingleE12DZPrescale_branch.SetAddress(<void*>&self.singleMu23SingleE12DZPrescale_value)

        #print "making singleMu23SingleE12Group"
        self.singleMu23SingleE12Group_branch = the_tree.GetBranch("singleMu23SingleE12Group")
        #if not self.singleMu23SingleE12Group_branch and "singleMu23SingleE12Group" not in self.complained:
        if not self.singleMu23SingleE12Group_branch and "singleMu23SingleE12Group":
            warnings.warn( "EETauTree: Expected branch singleMu23SingleE12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12Group")
        else:
            self.singleMu23SingleE12Group_branch.SetAddress(<void*>&self.singleMu23SingleE12Group_value)

        #print "making singleMu23SingleE12Pass"
        self.singleMu23SingleE12Pass_branch = the_tree.GetBranch("singleMu23SingleE12Pass")
        #if not self.singleMu23SingleE12Pass_branch and "singleMu23SingleE12Pass" not in self.complained:
        if not self.singleMu23SingleE12Pass_branch and "singleMu23SingleE12Pass":
            warnings.warn( "EETauTree: Expected branch singleMu23SingleE12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12Pass")
        else:
            self.singleMu23SingleE12Pass_branch.SetAddress(<void*>&self.singleMu23SingleE12Pass_value)

        #print "making singleMu23SingleE12Prescale"
        self.singleMu23SingleE12Prescale_branch = the_tree.GetBranch("singleMu23SingleE12Prescale")
        #if not self.singleMu23SingleE12Prescale_branch and "singleMu23SingleE12Prescale" not in self.complained:
        if not self.singleMu23SingleE12Prescale_branch and "singleMu23SingleE12Prescale":
            warnings.warn( "EETauTree: Expected branch singleMu23SingleE12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12Prescale")
        else:
            self.singleMu23SingleE12Prescale_branch.SetAddress(<void*>&self.singleMu23SingleE12Prescale_value)

        #print "making singleMu23SingleE8Group"
        self.singleMu23SingleE8Group_branch = the_tree.GetBranch("singleMu23SingleE8Group")
        #if not self.singleMu23SingleE8Group_branch and "singleMu23SingleE8Group" not in self.complained:
        if not self.singleMu23SingleE8Group_branch and "singleMu23SingleE8Group":
            warnings.warn( "EETauTree: Expected branch singleMu23SingleE8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE8Group")
        else:
            self.singleMu23SingleE8Group_branch.SetAddress(<void*>&self.singleMu23SingleE8Group_value)

        #print "making singleMu23SingleE8Pass"
        self.singleMu23SingleE8Pass_branch = the_tree.GetBranch("singleMu23SingleE8Pass")
        #if not self.singleMu23SingleE8Pass_branch and "singleMu23SingleE8Pass" not in self.complained:
        if not self.singleMu23SingleE8Pass_branch and "singleMu23SingleE8Pass":
            warnings.warn( "EETauTree: Expected branch singleMu23SingleE8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE8Pass")
        else:
            self.singleMu23SingleE8Pass_branch.SetAddress(<void*>&self.singleMu23SingleE8Pass_value)

        #print "making singleMu23SingleE8Prescale"
        self.singleMu23SingleE8Prescale_branch = the_tree.GetBranch("singleMu23SingleE8Prescale")
        #if not self.singleMu23SingleE8Prescale_branch and "singleMu23SingleE8Prescale" not in self.complained:
        if not self.singleMu23SingleE8Prescale_branch and "singleMu23SingleE8Prescale":
            warnings.warn( "EETauTree: Expected branch singleMu23SingleE8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE8Prescale")
        else:
            self.singleMu23SingleE8Prescale_branch.SetAddress(<void*>&self.singleMu23SingleE8Prescale_value)

        #print "making singleMu8SingleE23DZGroup"
        self.singleMu8SingleE23DZGroup_branch = the_tree.GetBranch("singleMu8SingleE23DZGroup")
        #if not self.singleMu8SingleE23DZGroup_branch and "singleMu8SingleE23DZGroup" not in self.complained:
        if not self.singleMu8SingleE23DZGroup_branch and "singleMu8SingleE23DZGroup":
            warnings.warn( "EETauTree: Expected branch singleMu8SingleE23DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZGroup")
        else:
            self.singleMu8SingleE23DZGroup_branch.SetAddress(<void*>&self.singleMu8SingleE23DZGroup_value)

        #print "making singleMu8SingleE23DZPass"
        self.singleMu8SingleE23DZPass_branch = the_tree.GetBranch("singleMu8SingleE23DZPass")
        #if not self.singleMu8SingleE23DZPass_branch and "singleMu8SingleE23DZPass" not in self.complained:
        if not self.singleMu8SingleE23DZPass_branch and "singleMu8SingleE23DZPass":
            warnings.warn( "EETauTree: Expected branch singleMu8SingleE23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZPass")
        else:
            self.singleMu8SingleE23DZPass_branch.SetAddress(<void*>&self.singleMu8SingleE23DZPass_value)

        #print "making singleMu8SingleE23DZPrescale"
        self.singleMu8SingleE23DZPrescale_branch = the_tree.GetBranch("singleMu8SingleE23DZPrescale")
        #if not self.singleMu8SingleE23DZPrescale_branch and "singleMu8SingleE23DZPrescale" not in self.complained:
        if not self.singleMu8SingleE23DZPrescale_branch and "singleMu8SingleE23DZPrescale":
            warnings.warn( "EETauTree: Expected branch singleMu8SingleE23DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZPrescale")
        else:
            self.singleMu8SingleE23DZPrescale_branch.SetAddress(<void*>&self.singleMu8SingleE23DZPrescale_value)

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

        #print "making singleMuSingleEGroup"
        self.singleMuSingleEGroup_branch = the_tree.GetBranch("singleMuSingleEGroup")
        #if not self.singleMuSingleEGroup_branch and "singleMuSingleEGroup" not in self.complained:
        if not self.singleMuSingleEGroup_branch and "singleMuSingleEGroup":
            warnings.warn( "EETauTree: Expected branch singleMuSingleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuSingleEGroup")
        else:
            self.singleMuSingleEGroup_branch.SetAddress(<void*>&self.singleMuSingleEGroup_value)

        #print "making singleMuSingleEPass"
        self.singleMuSingleEPass_branch = the_tree.GetBranch("singleMuSingleEPass")
        #if not self.singleMuSingleEPass_branch and "singleMuSingleEPass" not in self.complained:
        if not self.singleMuSingleEPass_branch and "singleMuSingleEPass":
            warnings.warn( "EETauTree: Expected branch singleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuSingleEPass")
        else:
            self.singleMuSingleEPass_branch.SetAddress(<void*>&self.singleMuSingleEPass_value)

        #print "making singleMuSingleEPrescale"
        self.singleMuSingleEPrescale_branch = the_tree.GetBranch("singleMuSingleEPrescale")
        #if not self.singleMuSingleEPrescale_branch and "singleMuSingleEPrescale" not in self.complained:
        if not self.singleMuSingleEPrescale_branch and "singleMuSingleEPrescale":
            warnings.warn( "EETauTree: Expected branch singleMuSingleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuSingleEPrescale")
        else:
            self.singleMuSingleEPrescale_branch.SetAddress(<void*>&self.singleMuSingleEPrescale_value)

        #print "making singleMu_leg1Group"
        self.singleMu_leg1Group_branch = the_tree.GetBranch("singleMu_leg1Group")
        #if not self.singleMu_leg1Group_branch and "singleMu_leg1Group" not in self.complained:
        if not self.singleMu_leg1Group_branch and "singleMu_leg1Group":
            warnings.warn( "EETauTree: Expected branch singleMu_leg1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Group")
        else:
            self.singleMu_leg1Group_branch.SetAddress(<void*>&self.singleMu_leg1Group_value)

        #print "making singleMu_leg1Pass"
        self.singleMu_leg1Pass_branch = the_tree.GetBranch("singleMu_leg1Pass")
        #if not self.singleMu_leg1Pass_branch and "singleMu_leg1Pass" not in self.complained:
        if not self.singleMu_leg1Pass_branch and "singleMu_leg1Pass":
            warnings.warn( "EETauTree: Expected branch singleMu_leg1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Pass")
        else:
            self.singleMu_leg1Pass_branch.SetAddress(<void*>&self.singleMu_leg1Pass_value)

        #print "making singleMu_leg1Prescale"
        self.singleMu_leg1Prescale_branch = the_tree.GetBranch("singleMu_leg1Prescale")
        #if not self.singleMu_leg1Prescale_branch and "singleMu_leg1Prescale" not in self.complained:
        if not self.singleMu_leg1Prescale_branch and "singleMu_leg1Prescale":
            warnings.warn( "EETauTree: Expected branch singleMu_leg1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Prescale")
        else:
            self.singleMu_leg1Prescale_branch.SetAddress(<void*>&self.singleMu_leg1Prescale_value)

        #print "making singleMu_leg1_noisoGroup"
        self.singleMu_leg1_noisoGroup_branch = the_tree.GetBranch("singleMu_leg1_noisoGroup")
        #if not self.singleMu_leg1_noisoGroup_branch and "singleMu_leg1_noisoGroup" not in self.complained:
        if not self.singleMu_leg1_noisoGroup_branch and "singleMu_leg1_noisoGroup":
            warnings.warn( "EETauTree: Expected branch singleMu_leg1_noisoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoGroup")
        else:
            self.singleMu_leg1_noisoGroup_branch.SetAddress(<void*>&self.singleMu_leg1_noisoGroup_value)

        #print "making singleMu_leg1_noisoPass"
        self.singleMu_leg1_noisoPass_branch = the_tree.GetBranch("singleMu_leg1_noisoPass")
        #if not self.singleMu_leg1_noisoPass_branch and "singleMu_leg1_noisoPass" not in self.complained:
        if not self.singleMu_leg1_noisoPass_branch and "singleMu_leg1_noisoPass":
            warnings.warn( "EETauTree: Expected branch singleMu_leg1_noisoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoPass")
        else:
            self.singleMu_leg1_noisoPass_branch.SetAddress(<void*>&self.singleMu_leg1_noisoPass_value)

        #print "making singleMu_leg1_noisoPrescale"
        self.singleMu_leg1_noisoPrescale_branch = the_tree.GetBranch("singleMu_leg1_noisoPrescale")
        #if not self.singleMu_leg1_noisoPrescale_branch and "singleMu_leg1_noisoPrescale" not in self.complained:
        if not self.singleMu_leg1_noisoPrescale_branch and "singleMu_leg1_noisoPrescale":
            warnings.warn( "EETauTree: Expected branch singleMu_leg1_noisoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoPrescale")
        else:
            self.singleMu_leg1_noisoPrescale_branch.SetAddress(<void*>&self.singleMu_leg1_noisoPrescale_value)

        #print "making singleMu_leg2Group"
        self.singleMu_leg2Group_branch = the_tree.GetBranch("singleMu_leg2Group")
        #if not self.singleMu_leg2Group_branch and "singleMu_leg2Group" not in self.complained:
        if not self.singleMu_leg2Group_branch and "singleMu_leg2Group":
            warnings.warn( "EETauTree: Expected branch singleMu_leg2Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Group")
        else:
            self.singleMu_leg2Group_branch.SetAddress(<void*>&self.singleMu_leg2Group_value)

        #print "making singleMu_leg2Pass"
        self.singleMu_leg2Pass_branch = the_tree.GetBranch("singleMu_leg2Pass")
        #if not self.singleMu_leg2Pass_branch and "singleMu_leg2Pass" not in self.complained:
        if not self.singleMu_leg2Pass_branch and "singleMu_leg2Pass":
            warnings.warn( "EETauTree: Expected branch singleMu_leg2Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Pass")
        else:
            self.singleMu_leg2Pass_branch.SetAddress(<void*>&self.singleMu_leg2Pass_value)

        #print "making singleMu_leg2Prescale"
        self.singleMu_leg2Prescale_branch = the_tree.GetBranch("singleMu_leg2Prescale")
        #if not self.singleMu_leg2Prescale_branch and "singleMu_leg2Prescale" not in self.complained:
        if not self.singleMu_leg2Prescale_branch and "singleMu_leg2Prescale":
            warnings.warn( "EETauTree: Expected branch singleMu_leg2Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Prescale")
        else:
            self.singleMu_leg2Prescale_branch.SetAddress(<void*>&self.singleMu_leg2Prescale_value)

        #print "making singleMu_leg2_noisoGroup"
        self.singleMu_leg2_noisoGroup_branch = the_tree.GetBranch("singleMu_leg2_noisoGroup")
        #if not self.singleMu_leg2_noisoGroup_branch and "singleMu_leg2_noisoGroup" not in self.complained:
        if not self.singleMu_leg2_noisoGroup_branch and "singleMu_leg2_noisoGroup":
            warnings.warn( "EETauTree: Expected branch singleMu_leg2_noisoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoGroup")
        else:
            self.singleMu_leg2_noisoGroup_branch.SetAddress(<void*>&self.singleMu_leg2_noisoGroup_value)

        #print "making singleMu_leg2_noisoPass"
        self.singleMu_leg2_noisoPass_branch = the_tree.GetBranch("singleMu_leg2_noisoPass")
        #if not self.singleMu_leg2_noisoPass_branch and "singleMu_leg2_noisoPass" not in self.complained:
        if not self.singleMu_leg2_noisoPass_branch and "singleMu_leg2_noisoPass":
            warnings.warn( "EETauTree: Expected branch singleMu_leg2_noisoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoPass")
        else:
            self.singleMu_leg2_noisoPass_branch.SetAddress(<void*>&self.singleMu_leg2_noisoPass_value)

        #print "making singleMu_leg2_noisoPrescale"
        self.singleMu_leg2_noisoPrescale_branch = the_tree.GetBranch("singleMu_leg2_noisoPrescale")
        #if not self.singleMu_leg2_noisoPrescale_branch and "singleMu_leg2_noisoPrescale" not in self.complained:
        if not self.singleMu_leg2_noisoPrescale_branch and "singleMu_leg2_noisoPrescale":
            warnings.warn( "EETauTree: Expected branch singleMu_leg2_noisoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoPrescale")
        else:
            self.singleMu_leg2_noisoPrescale_branch.SetAddress(<void*>&self.singleMu_leg2_noisoPrescale_value)

        #print "making singleTau140Group"
        self.singleTau140Group_branch = the_tree.GetBranch("singleTau140Group")
        #if not self.singleTau140Group_branch and "singleTau140Group" not in self.complained:
        if not self.singleTau140Group_branch and "singleTau140Group":
            warnings.warn( "EETauTree: Expected branch singleTau140Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Group")
        else:
            self.singleTau140Group_branch.SetAddress(<void*>&self.singleTau140Group_value)

        #print "making singleTau140Pass"
        self.singleTau140Pass_branch = the_tree.GetBranch("singleTau140Pass")
        #if not self.singleTau140Pass_branch and "singleTau140Pass" not in self.complained:
        if not self.singleTau140Pass_branch and "singleTau140Pass":
            warnings.warn( "EETauTree: Expected branch singleTau140Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Pass")
        else:
            self.singleTau140Pass_branch.SetAddress(<void*>&self.singleTau140Pass_value)

        #print "making singleTau140Prescale"
        self.singleTau140Prescale_branch = the_tree.GetBranch("singleTau140Prescale")
        #if not self.singleTau140Prescale_branch and "singleTau140Prescale" not in self.complained:
        if not self.singleTau140Prescale_branch and "singleTau140Prescale":
            warnings.warn( "EETauTree: Expected branch singleTau140Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Prescale")
        else:
            self.singleTau140Prescale_branch.SetAddress(<void*>&self.singleTau140Prescale_value)

        #print "making singleTau140Trk50Group"
        self.singleTau140Trk50Group_branch = the_tree.GetBranch("singleTau140Trk50Group")
        #if not self.singleTau140Trk50Group_branch and "singleTau140Trk50Group" not in self.complained:
        if not self.singleTau140Trk50Group_branch and "singleTau140Trk50Group":
            warnings.warn( "EETauTree: Expected branch singleTau140Trk50Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Trk50Group")
        else:
            self.singleTau140Trk50Group_branch.SetAddress(<void*>&self.singleTau140Trk50Group_value)

        #print "making singleTau140Trk50Pass"
        self.singleTau140Trk50Pass_branch = the_tree.GetBranch("singleTau140Trk50Pass")
        #if not self.singleTau140Trk50Pass_branch and "singleTau140Trk50Pass" not in self.complained:
        if not self.singleTau140Trk50Pass_branch and "singleTau140Trk50Pass":
            warnings.warn( "EETauTree: Expected branch singleTau140Trk50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Trk50Pass")
        else:
            self.singleTau140Trk50Pass_branch.SetAddress(<void*>&self.singleTau140Trk50Pass_value)

        #print "making singleTau140Trk50Prescale"
        self.singleTau140Trk50Prescale_branch = the_tree.GetBranch("singleTau140Trk50Prescale")
        #if not self.singleTau140Trk50Prescale_branch and "singleTau140Trk50Prescale" not in self.complained:
        if not self.singleTau140Trk50Prescale_branch and "singleTau140Trk50Prescale":
            warnings.warn( "EETauTree: Expected branch singleTau140Trk50Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Trk50Prescale")
        else:
            self.singleTau140Trk50Prescale_branch.SetAddress(<void*>&self.singleTau140Trk50Prescale_value)

        #print "making tAbsEta"
        self.tAbsEta_branch = the_tree.GetBranch("tAbsEta")
        #if not self.tAbsEta_branch and "tAbsEta" not in self.complained:
        if not self.tAbsEta_branch and "tAbsEta":
            warnings.warn( "EETauTree: Expected branch tAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAbsEta")
        else:
            self.tAbsEta_branch.SetAddress(<void*>&self.tAbsEta_value)

        #print "making tAgainstElectronLooseMVA6"
        self.tAgainstElectronLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronLooseMVA6")
        #if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6" not in self.complained:
        if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronLooseMVA6")
        else:
            self.tAgainstElectronLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronLooseMVA6_value)

        #print "making tAgainstElectronMVA6Raw"
        self.tAgainstElectronMVA6Raw_branch = the_tree.GetBranch("tAgainstElectronMVA6Raw")
        #if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw" not in self.complained:
        if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronMVA6Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6Raw")
        else:
            self.tAgainstElectronMVA6Raw_branch.SetAddress(<void*>&self.tAgainstElectronMVA6Raw_value)

        #print "making tAgainstElectronMVA6category"
        self.tAgainstElectronMVA6category_branch = the_tree.GetBranch("tAgainstElectronMVA6category")
        #if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category" not in self.complained:
        if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronMVA6category does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6category")
        else:
            self.tAgainstElectronMVA6category_branch.SetAddress(<void*>&self.tAgainstElectronMVA6category_value)

        #print "making tAgainstElectronMediumMVA6"
        self.tAgainstElectronMediumMVA6_branch = the_tree.GetBranch("tAgainstElectronMediumMVA6")
        #if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6" not in self.complained:
        if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronMediumMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMediumMVA6")
        else:
            self.tAgainstElectronMediumMVA6_branch.SetAddress(<void*>&self.tAgainstElectronMediumMVA6_value)

        #print "making tAgainstElectronTightMVA6"
        self.tAgainstElectronTightMVA6_branch = the_tree.GetBranch("tAgainstElectronTightMVA6")
        #if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6" not in self.complained:
        if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronTightMVA6")
        else:
            self.tAgainstElectronTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronTightMVA6_value)

        #print "making tAgainstElectronVLooseMVA6"
        self.tAgainstElectronVLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronVLooseMVA6")
        #if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6" not in self.complained:
        if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronVLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVLooseMVA6")
        else:
            self.tAgainstElectronVLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVLooseMVA6_value)

        #print "making tAgainstElectronVTightMVA6"
        self.tAgainstElectronVTightMVA6_branch = the_tree.GetBranch("tAgainstElectronVTightMVA6")
        #if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6" not in self.complained:
        if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronVTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVTightMVA6")
        else:
            self.tAgainstElectronVTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVTightMVA6_value)

        #print "making tAgainstMuonLoose3"
        self.tAgainstMuonLoose3_branch = the_tree.GetBranch("tAgainstMuonLoose3")
        #if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3" not in self.complained:
        if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3":
            warnings.warn( "EETauTree: Expected branch tAgainstMuonLoose3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonLoose3")
        else:
            self.tAgainstMuonLoose3_branch.SetAddress(<void*>&self.tAgainstMuonLoose3_value)

        #print "making tAgainstMuonTight3"
        self.tAgainstMuonTight3_branch = the_tree.GetBranch("tAgainstMuonTight3")
        #if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3" not in self.complained:
        if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3":
            warnings.warn( "EETauTree: Expected branch tAgainstMuonTight3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonTight3")
        else:
            self.tAgainstMuonTight3_branch.SetAddress(<void*>&self.tAgainstMuonTight3_value)

        #print "making tByCombinedIsolationDeltaBetaCorrRaw3Hits"
        self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch = the_tree.GetBranch("tByCombinedIsolationDeltaBetaCorrRaw3Hits")
        #if not self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch and "tByCombinedIsolationDeltaBetaCorrRaw3Hits" not in self.complained:
        if not self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch and "tByCombinedIsolationDeltaBetaCorrRaw3Hits":
            warnings.warn( "EETauTree: Expected branch tByCombinedIsolationDeltaBetaCorrRaw3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByCombinedIsolationDeltaBetaCorrRaw3Hits")
        else:
            self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch.SetAddress(<void*>&self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_value)

        #print "making tByIsolationMVArun2v1DBdR03oldDMwLTraw"
        self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw":
            warnings.warn( "EETauTree: Expected branch tByIsolationMVArun2v1DBdR03oldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBnewDMwLTraw"
        self.tByIsolationMVArun2v1DBnewDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBnewDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBnewDMwLTraw_branch and "tByIsolationMVArun2v1DBnewDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBnewDMwLTraw_branch and "tByIsolationMVArun2v1DBnewDMwLTraw":
            warnings.warn( "EETauTree: Expected branch tByIsolationMVArun2v1DBnewDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBnewDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBnewDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBnewDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBoldDMwLTraw"
        self.tByIsolationMVArun2v1DBoldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBoldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw":
            warnings.warn( "EETauTree: Expected branch tByIsolationMVArun2v1DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBoldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBoldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBoldDMwLTraw_value)

        #print "making tByIsolationMVArun2v1PWdR03oldDMwLTraw"
        self.tByIsolationMVArun2v1PWdR03oldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1PWdR03oldDMwLTraw")
        #if not self.tByIsolationMVArun2v1PWdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1PWdR03oldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1PWdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1PWdR03oldDMwLTraw":
            warnings.warn( "EETauTree: Expected branch tByIsolationMVArun2v1PWdR03oldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1PWdR03oldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1PWdR03oldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1PWdR03oldDMwLTraw_value)

        #print "making tByIsolationMVArun2v1PWnewDMwLTraw"
        self.tByIsolationMVArun2v1PWnewDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1PWnewDMwLTraw")
        #if not self.tByIsolationMVArun2v1PWnewDMwLTraw_branch and "tByIsolationMVArun2v1PWnewDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1PWnewDMwLTraw_branch and "tByIsolationMVArun2v1PWnewDMwLTraw":
            warnings.warn( "EETauTree: Expected branch tByIsolationMVArun2v1PWnewDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1PWnewDMwLTraw")
        else:
            self.tByIsolationMVArun2v1PWnewDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1PWnewDMwLTraw_value)

        #print "making tByIsolationMVArun2v1PWoldDMwLTraw"
        self.tByIsolationMVArun2v1PWoldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1PWoldDMwLTraw")
        #if not self.tByIsolationMVArun2v1PWoldDMwLTraw_branch and "tByIsolationMVArun2v1PWoldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1PWoldDMwLTraw_branch and "tByIsolationMVArun2v1PWoldDMwLTraw":
            warnings.warn( "EETauTree: Expected branch tByIsolationMVArun2v1PWoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1PWoldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1PWoldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1PWoldDMwLTraw_value)

        #print "making tByLooseCombinedIsolationDeltaBetaCorr3Hits"
        self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByLooseCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch and "tByLooseCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch and "tByLooseCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "EETauTree: Expected branch tByLooseCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBnewDMwLT"
        self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByLooseIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByLooseIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "EETauTree: Expected branch tByLooseIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1PWdR03oldDMwLT"
        self.tByLooseIsolationMVArun2v1PWdR03oldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1PWdR03oldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1PWdR03oldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1PWdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByLooseIsolationMVArun2v1PWdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1PWdR03oldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1PWdR03oldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1PWdR03oldDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1PWnewDMwLT"
        self.tByLooseIsolationMVArun2v1PWnewDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1PWnewDMwLT")
        #if not self.tByLooseIsolationMVArun2v1PWnewDMwLT_branch and "tByLooseIsolationMVArun2v1PWnewDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1PWnewDMwLT_branch and "tByLooseIsolationMVArun2v1PWnewDMwLT":
            warnings.warn( "EETauTree: Expected branch tByLooseIsolationMVArun2v1PWnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1PWnewDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1PWnewDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1PWnewDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1PWoldDMwLT"
        self.tByLooseIsolationMVArun2v1PWoldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1PWoldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1PWoldDMwLT_branch and "tByLooseIsolationMVArun2v1PWoldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1PWoldDMwLT_branch and "tByLooseIsolationMVArun2v1PWoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByLooseIsolationMVArun2v1PWoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1PWoldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1PWoldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1PWoldDMwLT_value)

        #print "making tByMediumCombinedIsolationDeltaBetaCorr3Hits"
        self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByMediumCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch and "tByMediumCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch and "tByMediumCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "EETauTree: Expected branch tByMediumCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByMediumIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByMediumIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBnewDMwLT"
        self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch and "tByMediumIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch and "tByMediumIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "EETauTree: Expected branch tByMediumIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBoldDMwLT"
        self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByMediumIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1PWdR03oldDMwLT"
        self.tByMediumIsolationMVArun2v1PWdR03oldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1PWdR03oldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1PWdR03oldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1PWdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByMediumIsolationMVArun2v1PWdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1PWdR03oldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1PWdR03oldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1PWdR03oldDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1PWnewDMwLT"
        self.tByMediumIsolationMVArun2v1PWnewDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1PWnewDMwLT")
        #if not self.tByMediumIsolationMVArun2v1PWnewDMwLT_branch and "tByMediumIsolationMVArun2v1PWnewDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1PWnewDMwLT_branch and "tByMediumIsolationMVArun2v1PWnewDMwLT":
            warnings.warn( "EETauTree: Expected branch tByMediumIsolationMVArun2v1PWnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1PWnewDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1PWnewDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1PWnewDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1PWoldDMwLT"
        self.tByMediumIsolationMVArun2v1PWoldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1PWoldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1PWoldDMwLT_branch and "tByMediumIsolationMVArun2v1PWoldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1PWoldDMwLT_branch and "tByMediumIsolationMVArun2v1PWoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByMediumIsolationMVArun2v1PWoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1PWoldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1PWoldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1PWoldDMwLT_value)

        #print "making tByPhotonPtSumOutsideSignalCone"
        self.tByPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tByPhotonPtSumOutsideSignalCone")
        #if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone":
            warnings.warn( "EETauTree: Expected branch tByPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByPhotonPtSumOutsideSignalCone")
        else:
            self.tByPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tByPhotonPtSumOutsideSignalCone_value)

        #print "making tByTightCombinedIsolationDeltaBetaCorr3Hits"
        self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByTightCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch and "tByTightCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch and "tByTightCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "EETauTree: Expected branch tByTightCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByTightCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBnewDMwLT"
        self.tByTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBnewDMwLT_branch and "tByTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBnewDMwLT_branch and "tByTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "EETauTree: Expected branch tByTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBoldDMwLT"
        self.tByTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByTightIsolationMVArun2v1PWdR03oldDMwLT"
        self.tByTightIsolationMVArun2v1PWdR03oldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1PWdR03oldDMwLT")
        #if not self.tByTightIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1PWdR03oldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1PWdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByTightIsolationMVArun2v1PWdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1PWdR03oldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1PWdR03oldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1PWdR03oldDMwLT_value)

        #print "making tByTightIsolationMVArun2v1PWnewDMwLT"
        self.tByTightIsolationMVArun2v1PWnewDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1PWnewDMwLT")
        #if not self.tByTightIsolationMVArun2v1PWnewDMwLT_branch and "tByTightIsolationMVArun2v1PWnewDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1PWnewDMwLT_branch and "tByTightIsolationMVArun2v1PWnewDMwLT":
            warnings.warn( "EETauTree: Expected branch tByTightIsolationMVArun2v1PWnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1PWnewDMwLT")
        else:
            self.tByTightIsolationMVArun2v1PWnewDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1PWnewDMwLT_value)

        #print "making tByTightIsolationMVArun2v1PWoldDMwLT"
        self.tByTightIsolationMVArun2v1PWoldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1PWoldDMwLT")
        #if not self.tByTightIsolationMVArun2v1PWoldDMwLT_branch and "tByTightIsolationMVArun2v1PWoldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1PWoldDMwLT_branch and "tByTightIsolationMVArun2v1PWoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByTightIsolationMVArun2v1PWoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1PWoldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1PWoldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1PWoldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBnewDMwLT"
        self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByVLooseIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByVLooseIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVLooseIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1PWdR03oldDMwLT"
        self.tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1PWdR03oldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1PWdR03oldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1PWdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVLooseIsolationMVArun2v1PWdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1PWdR03oldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1PWdR03oldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1PWnewDMwLT"
        self.tByVLooseIsolationMVArun2v1PWnewDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1PWnewDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1PWnewDMwLT_branch and "tByVLooseIsolationMVArun2v1PWnewDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1PWnewDMwLT_branch and "tByVLooseIsolationMVArun2v1PWnewDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVLooseIsolationMVArun2v1PWnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1PWnewDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1PWnewDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1PWnewDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1PWoldDMwLT"
        self.tByVLooseIsolationMVArun2v1PWoldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1PWoldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1PWoldDMwLT_branch and "tByVLooseIsolationMVArun2v1PWoldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1PWoldDMwLT_branch and "tByVLooseIsolationMVArun2v1PWoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVLooseIsolationMVArun2v1PWoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1PWoldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1PWoldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1PWoldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBnewDMwLT"
        self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1PWdR03oldDMwLT"
        self.tByVTightIsolationMVArun2v1PWdR03oldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1PWdR03oldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1PWdR03oldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1PWdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVTightIsolationMVArun2v1PWdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1PWdR03oldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1PWdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1PWdR03oldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1PWnewDMwLT"
        self.tByVTightIsolationMVArun2v1PWnewDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1PWnewDMwLT")
        #if not self.tByVTightIsolationMVArun2v1PWnewDMwLT_branch and "tByVTightIsolationMVArun2v1PWnewDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1PWnewDMwLT_branch and "tByVTightIsolationMVArun2v1PWnewDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVTightIsolationMVArun2v1PWnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1PWnewDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1PWnewDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1PWnewDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1PWoldDMwLT"
        self.tByVTightIsolationMVArun2v1PWoldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1PWoldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1PWoldDMwLT_branch and "tByVTightIsolationMVArun2v1PWoldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1PWoldDMwLT_branch and "tByVTightIsolationMVArun2v1PWoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVTightIsolationMVArun2v1PWoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1PWoldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1PWoldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1PWoldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBnewDMwLT"
        self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVVTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVVTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVVTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1PWdR03oldDMwLT"
        self.tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1PWdR03oldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1PWdR03oldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1PWdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVVTightIsolationMVArun2v1PWdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1PWdR03oldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1PWdR03oldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1PWnewDMwLT"
        self.tByVVTightIsolationMVArun2v1PWnewDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1PWnewDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1PWnewDMwLT_branch and "tByVVTightIsolationMVArun2v1PWnewDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1PWnewDMwLT_branch and "tByVVTightIsolationMVArun2v1PWnewDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVVTightIsolationMVArun2v1PWnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1PWnewDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1PWnewDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1PWnewDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1PWoldDMwLT"
        self.tByVVTightIsolationMVArun2v1PWoldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1PWoldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1PWoldDMwLT_branch and "tByVVTightIsolationMVArun2v1PWoldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1PWoldDMwLT_branch and "tByVVTightIsolationMVArun2v1PWoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVVTightIsolationMVArun2v1PWoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1PWoldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1PWoldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1PWoldDMwLT_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "EETauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tChargedIsoPtSum"
        self.tChargedIsoPtSum_branch = the_tree.GetBranch("tChargedIsoPtSum")
        #if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum" not in self.complained:
        if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum":
            warnings.warn( "EETauTree: Expected branch tChargedIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSum")
        else:
            self.tChargedIsoPtSum_branch.SetAddress(<void*>&self.tChargedIsoPtSum_value)

        #print "making tChargedIsoPtSumdR03"
        self.tChargedIsoPtSumdR03_branch = the_tree.GetBranch("tChargedIsoPtSumdR03")
        #if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03" not in self.complained:
        if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03":
            warnings.warn( "EETauTree: Expected branch tChargedIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSumdR03")
        else:
            self.tChargedIsoPtSumdR03_branch.SetAddress(<void*>&self.tChargedIsoPtSumdR03_value)

        #print "making tComesFromHiggs"
        self.tComesFromHiggs_branch = the_tree.GetBranch("tComesFromHiggs")
        #if not self.tComesFromHiggs_branch and "tComesFromHiggs" not in self.complained:
        if not self.tComesFromHiggs_branch and "tComesFromHiggs":
            warnings.warn( "EETauTree: Expected branch tComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tComesFromHiggs")
        else:
            self.tComesFromHiggs_branch.SetAddress(<void*>&self.tComesFromHiggs_value)

        #print "making tDPhiToPfMet_type1"
        self.tDPhiToPfMet_type1_branch = the_tree.GetBranch("tDPhiToPfMet_type1")
        #if not self.tDPhiToPfMet_type1_branch and "tDPhiToPfMet_type1" not in self.complained:
        if not self.tDPhiToPfMet_type1_branch and "tDPhiToPfMet_type1":
            warnings.warn( "EETauTree: Expected branch tDPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDPhiToPfMet_type1")
        else:
            self.tDPhiToPfMet_type1_branch.SetAddress(<void*>&self.tDPhiToPfMet_type1_value)

        #print "making tDecayMode"
        self.tDecayMode_branch = the_tree.GetBranch("tDecayMode")
        #if not self.tDecayMode_branch and "tDecayMode" not in self.complained:
        if not self.tDecayMode_branch and "tDecayMode":
            warnings.warn( "EETauTree: Expected branch tDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayMode")
        else:
            self.tDecayMode_branch.SetAddress(<void*>&self.tDecayMode_value)

        #print "making tDecayModeFinding"
        self.tDecayModeFinding_branch = the_tree.GetBranch("tDecayModeFinding")
        #if not self.tDecayModeFinding_branch and "tDecayModeFinding" not in self.complained:
        if not self.tDecayModeFinding_branch and "tDecayModeFinding":
            warnings.warn( "EETauTree: Expected branch tDecayModeFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFinding")
        else:
            self.tDecayModeFinding_branch.SetAddress(<void*>&self.tDecayModeFinding_value)

        #print "making tDecayModeFindingNewDMs"
        self.tDecayModeFindingNewDMs_branch = the_tree.GetBranch("tDecayModeFindingNewDMs")
        #if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs" not in self.complained:
        if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs":
            warnings.warn( "EETauTree: Expected branch tDecayModeFindingNewDMs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFindingNewDMs")
        else:
            self.tDecayModeFindingNewDMs_branch.SetAddress(<void*>&self.tDecayModeFindingNewDMs_value)

        #print "making tElecOverlap"
        self.tElecOverlap_branch = the_tree.GetBranch("tElecOverlap")
        #if not self.tElecOverlap_branch and "tElecOverlap" not in self.complained:
        if not self.tElecOverlap_branch and "tElecOverlap":
            warnings.warn( "EETauTree: Expected branch tElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElecOverlap")
        else:
            self.tElecOverlap_branch.SetAddress(<void*>&self.tElecOverlap_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "EETauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tEta_TauEnDown"
        self.tEta_TauEnDown_branch = the_tree.GetBranch("tEta_TauEnDown")
        #if not self.tEta_TauEnDown_branch and "tEta_TauEnDown" not in self.complained:
        if not self.tEta_TauEnDown_branch and "tEta_TauEnDown":
            warnings.warn( "EETauTree: Expected branch tEta_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta_TauEnDown")
        else:
            self.tEta_TauEnDown_branch.SetAddress(<void*>&self.tEta_TauEnDown_value)

        #print "making tEta_TauEnUp"
        self.tEta_TauEnUp_branch = the_tree.GetBranch("tEta_TauEnUp")
        #if not self.tEta_TauEnUp_branch and "tEta_TauEnUp" not in self.complained:
        if not self.tEta_TauEnUp_branch and "tEta_TauEnUp":
            warnings.warn( "EETauTree: Expected branch tEta_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta_TauEnUp")
        else:
            self.tEta_TauEnUp_branch.SetAddress(<void*>&self.tEta_TauEnUp_value)

        #print "making tFootprintCorrection"
        self.tFootprintCorrection_branch = the_tree.GetBranch("tFootprintCorrection")
        #if not self.tFootprintCorrection_branch and "tFootprintCorrection" not in self.complained:
        if not self.tFootprintCorrection_branch and "tFootprintCorrection":
            warnings.warn( "EETauTree: Expected branch tFootprintCorrection does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrection")
        else:
            self.tFootprintCorrection_branch.SetAddress(<void*>&self.tFootprintCorrection_value)

        #print "making tFootprintCorrectiondR03"
        self.tFootprintCorrectiondR03_branch = the_tree.GetBranch("tFootprintCorrectiondR03")
        #if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03" not in self.complained:
        if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03":
            warnings.warn( "EETauTree: Expected branch tFootprintCorrectiondR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrectiondR03")
        else:
            self.tFootprintCorrectiondR03_branch.SetAddress(<void*>&self.tFootprintCorrectiondR03_value)

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

        #print "making tGenIsPrompt"
        self.tGenIsPrompt_branch = the_tree.GetBranch("tGenIsPrompt")
        #if not self.tGenIsPrompt_branch and "tGenIsPrompt" not in self.complained:
        if not self.tGenIsPrompt_branch and "tGenIsPrompt":
            warnings.warn( "EETauTree: Expected branch tGenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenIsPrompt")
        else:
            self.tGenIsPrompt_branch.SetAddress(<void*>&self.tGenIsPrompt_value)

        #print "making tGenJetEta"
        self.tGenJetEta_branch = the_tree.GetBranch("tGenJetEta")
        #if not self.tGenJetEta_branch and "tGenJetEta" not in self.complained:
        if not self.tGenJetEta_branch and "tGenJetEta":
            warnings.warn( "EETauTree: Expected branch tGenJetEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetEta")
        else:
            self.tGenJetEta_branch.SetAddress(<void*>&self.tGenJetEta_value)

        #print "making tGenJetPt"
        self.tGenJetPt_branch = the_tree.GetBranch("tGenJetPt")
        #if not self.tGenJetPt_branch and "tGenJetPt" not in self.complained:
        if not self.tGenJetPt_branch and "tGenJetPt":
            warnings.warn( "EETauTree: Expected branch tGenJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetPt")
        else:
            self.tGenJetPt_branch.SetAddress(<void*>&self.tGenJetPt_value)

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

        #print "making tGenStatus"
        self.tGenStatus_branch = the_tree.GetBranch("tGenStatus")
        #if not self.tGenStatus_branch and "tGenStatus" not in self.complained:
        if not self.tGenStatus_branch and "tGenStatus":
            warnings.warn( "EETauTree: Expected branch tGenStatus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenStatus")
        else:
            self.tGenStatus_branch.SetAddress(<void*>&self.tGenStatus_value)

        #print "making tGlobalMuonVtxOverlap"
        self.tGlobalMuonVtxOverlap_branch = the_tree.GetBranch("tGlobalMuonVtxOverlap")
        #if not self.tGlobalMuonVtxOverlap_branch and "tGlobalMuonVtxOverlap" not in self.complained:
        if not self.tGlobalMuonVtxOverlap_branch and "tGlobalMuonVtxOverlap":
            warnings.warn( "EETauTree: Expected branch tGlobalMuonVtxOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGlobalMuonVtxOverlap")
        else:
            self.tGlobalMuonVtxOverlap_branch.SetAddress(<void*>&self.tGlobalMuonVtxOverlap_value)

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

        #print "making tJetHadronFlavour"
        self.tJetHadronFlavour_branch = the_tree.GetBranch("tJetHadronFlavour")
        #if not self.tJetHadronFlavour_branch and "tJetHadronFlavour" not in self.complained:
        if not self.tJetHadronFlavour_branch and "tJetHadronFlavour":
            warnings.warn( "EETauTree: Expected branch tJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetHadronFlavour")
        else:
            self.tJetHadronFlavour_branch.SetAddress(<void*>&self.tJetHadronFlavour_value)

        #print "making tJetPFCISVBtag"
        self.tJetPFCISVBtag_branch = the_tree.GetBranch("tJetPFCISVBtag")
        #if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag" not in self.complained:
        if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag":
            warnings.warn( "EETauTree: Expected branch tJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPFCISVBtag")
        else:
            self.tJetPFCISVBtag_branch.SetAddress(<void*>&self.tJetPFCISVBtag_value)

        #print "making tJetPartonFlavour"
        self.tJetPartonFlavour_branch = the_tree.GetBranch("tJetPartonFlavour")
        #if not self.tJetPartonFlavour_branch and "tJetPartonFlavour" not in self.complained:
        if not self.tJetPartonFlavour_branch and "tJetPartonFlavour":
            warnings.warn( "EETauTree: Expected branch tJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPartonFlavour")
        else:
            self.tJetPartonFlavour_branch.SetAddress(<void*>&self.tJetPartonFlavour_value)

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

        #print "making tLeadTrackPt"
        self.tLeadTrackPt_branch = the_tree.GetBranch("tLeadTrackPt")
        #if not self.tLeadTrackPt_branch and "tLeadTrackPt" not in self.complained:
        if not self.tLeadTrackPt_branch and "tLeadTrackPt":
            warnings.warn( "EETauTree: Expected branch tLeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLeadTrackPt")
        else:
            self.tLeadTrackPt_branch.SetAddress(<void*>&self.tLeadTrackPt_value)

        #print "making tLowestMll"
        self.tLowestMll_branch = the_tree.GetBranch("tLowestMll")
        #if not self.tLowestMll_branch and "tLowestMll" not in self.complained:
        if not self.tLowestMll_branch and "tLowestMll":
            warnings.warn( "EETauTree: Expected branch tLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLowestMll")
        else:
            self.tLowestMll_branch.SetAddress(<void*>&self.tLowestMll_value)

        #print "making tMass"
        self.tMass_branch = the_tree.GetBranch("tMass")
        #if not self.tMass_branch and "tMass" not in self.complained:
        if not self.tMass_branch and "tMass":
            warnings.warn( "EETauTree: Expected branch tMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass")
        else:
            self.tMass_branch.SetAddress(<void*>&self.tMass_value)

        #print "making tMass_TauEnDown"
        self.tMass_TauEnDown_branch = the_tree.GetBranch("tMass_TauEnDown")
        #if not self.tMass_TauEnDown_branch and "tMass_TauEnDown" not in self.complained:
        if not self.tMass_TauEnDown_branch and "tMass_TauEnDown":
            warnings.warn( "EETauTree: Expected branch tMass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass_TauEnDown")
        else:
            self.tMass_TauEnDown_branch.SetAddress(<void*>&self.tMass_TauEnDown_value)

        #print "making tMass_TauEnUp"
        self.tMass_TauEnUp_branch = the_tree.GetBranch("tMass_TauEnUp")
        #if not self.tMass_TauEnUp_branch and "tMass_TauEnUp" not in self.complained:
        if not self.tMass_TauEnUp_branch and "tMass_TauEnUp":
            warnings.warn( "EETauTree: Expected branch tMass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass_TauEnUp")
        else:
            self.tMass_TauEnUp_branch.SetAddress(<void*>&self.tMass_TauEnUp_value)

        #print "making tMatchesDoubleTau32Filter"
        self.tMatchesDoubleTau32Filter_branch = the_tree.GetBranch("tMatchesDoubleTau32Filter")
        #if not self.tMatchesDoubleTau32Filter_branch and "tMatchesDoubleTau32Filter" not in self.complained:
        if not self.tMatchesDoubleTau32Filter_branch and "tMatchesDoubleTau32Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesDoubleTau32Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTau32Filter")
        else:
            self.tMatchesDoubleTau32Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTau32Filter_value)

        #print "making tMatchesDoubleTau32Path"
        self.tMatchesDoubleTau32Path_branch = the_tree.GetBranch("tMatchesDoubleTau32Path")
        #if not self.tMatchesDoubleTau32Path_branch and "tMatchesDoubleTau32Path" not in self.complained:
        if not self.tMatchesDoubleTau32Path_branch and "tMatchesDoubleTau32Path":
            warnings.warn( "EETauTree: Expected branch tMatchesDoubleTau32Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTau32Path")
        else:
            self.tMatchesDoubleTau32Path_branch.SetAddress(<void*>&self.tMatchesDoubleTau32Path_value)

        #print "making tMatchesDoubleTau35Filter"
        self.tMatchesDoubleTau35Filter_branch = the_tree.GetBranch("tMatchesDoubleTau35Filter")
        #if not self.tMatchesDoubleTau35Filter_branch and "tMatchesDoubleTau35Filter" not in self.complained:
        if not self.tMatchesDoubleTau35Filter_branch and "tMatchesDoubleTau35Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesDoubleTau35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTau35Filter")
        else:
            self.tMatchesDoubleTau35Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTau35Filter_value)

        #print "making tMatchesDoubleTau35Path"
        self.tMatchesDoubleTau35Path_branch = the_tree.GetBranch("tMatchesDoubleTau35Path")
        #if not self.tMatchesDoubleTau35Path_branch and "tMatchesDoubleTau35Path" not in self.complained:
        if not self.tMatchesDoubleTau35Path_branch and "tMatchesDoubleTau35Path":
            warnings.warn( "EETauTree: Expected branch tMatchesDoubleTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTau35Path")
        else:
            self.tMatchesDoubleTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleTau35Path_value)

        #print "making tMatchesDoubleTau40Filter"
        self.tMatchesDoubleTau40Filter_branch = the_tree.GetBranch("tMatchesDoubleTau40Filter")
        #if not self.tMatchesDoubleTau40Filter_branch and "tMatchesDoubleTau40Filter" not in self.complained:
        if not self.tMatchesDoubleTau40Filter_branch and "tMatchesDoubleTau40Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesDoubleTau40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTau40Filter")
        else:
            self.tMatchesDoubleTau40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTau40Filter_value)

        #print "making tMatchesDoubleTau40Path"
        self.tMatchesDoubleTau40Path_branch = the_tree.GetBranch("tMatchesDoubleTau40Path")
        #if not self.tMatchesDoubleTau40Path_branch and "tMatchesDoubleTau40Path" not in self.complained:
        if not self.tMatchesDoubleTau40Path_branch and "tMatchesDoubleTau40Path":
            warnings.warn( "EETauTree: Expected branch tMatchesDoubleTau40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTau40Path")
        else:
            self.tMatchesDoubleTau40Path_branch.SetAddress(<void*>&self.tMatchesDoubleTau40Path_value)

        #print "making tMatchesDoubleTauCmbIso35RegFilter"
        self.tMatchesDoubleTauCmbIso35RegFilter_branch = the_tree.GetBranch("tMatchesDoubleTauCmbIso35RegFilter")
        #if not self.tMatchesDoubleTauCmbIso35RegFilter_branch and "tMatchesDoubleTauCmbIso35RegFilter" not in self.complained:
        if not self.tMatchesDoubleTauCmbIso35RegFilter_branch and "tMatchesDoubleTauCmbIso35RegFilter":
            warnings.warn( "EETauTree: Expected branch tMatchesDoubleTauCmbIso35RegFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTauCmbIso35RegFilter")
        else:
            self.tMatchesDoubleTauCmbIso35RegFilter_branch.SetAddress(<void*>&self.tMatchesDoubleTauCmbIso35RegFilter_value)

        #print "making tMatchesDoubleTauCmbIso35RegPath"
        self.tMatchesDoubleTauCmbIso35RegPath_branch = the_tree.GetBranch("tMatchesDoubleTauCmbIso35RegPath")
        #if not self.tMatchesDoubleTauCmbIso35RegPath_branch and "tMatchesDoubleTauCmbIso35RegPath" not in self.complained:
        if not self.tMatchesDoubleTauCmbIso35RegPath_branch and "tMatchesDoubleTauCmbIso35RegPath":
            warnings.warn( "EETauTree: Expected branch tMatchesDoubleTauCmbIso35RegPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTauCmbIso35RegPath")
        else:
            self.tMatchesDoubleTauCmbIso35RegPath_branch.SetAddress(<void*>&self.tMatchesDoubleTauCmbIso35RegPath_value)

        #print "making tMatchesDoubleTauCmbIso40Filter"
        self.tMatchesDoubleTauCmbIso40Filter_branch = the_tree.GetBranch("tMatchesDoubleTauCmbIso40Filter")
        #if not self.tMatchesDoubleTauCmbIso40Filter_branch and "tMatchesDoubleTauCmbIso40Filter" not in self.complained:
        if not self.tMatchesDoubleTauCmbIso40Filter_branch and "tMatchesDoubleTauCmbIso40Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesDoubleTauCmbIso40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTauCmbIso40Filter")
        else:
            self.tMatchesDoubleTauCmbIso40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTauCmbIso40Filter_value)

        #print "making tMatchesDoubleTauCmbIso40Path"
        self.tMatchesDoubleTauCmbIso40Path_branch = the_tree.GetBranch("tMatchesDoubleTauCmbIso40Path")
        #if not self.tMatchesDoubleTauCmbIso40Path_branch and "tMatchesDoubleTauCmbIso40Path" not in self.complained:
        if not self.tMatchesDoubleTauCmbIso40Path_branch and "tMatchesDoubleTauCmbIso40Path":
            warnings.warn( "EETauTree: Expected branch tMatchesDoubleTauCmbIso40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTauCmbIso40Path")
        else:
            self.tMatchesDoubleTauCmbIso40Path_branch.SetAddress(<void*>&self.tMatchesDoubleTauCmbIso40Path_value)

        #print "making tMatchesDoubleTauCmbIso40RegFilter"
        self.tMatchesDoubleTauCmbIso40RegFilter_branch = the_tree.GetBranch("tMatchesDoubleTauCmbIso40RegFilter")
        #if not self.tMatchesDoubleTauCmbIso40RegFilter_branch and "tMatchesDoubleTauCmbIso40RegFilter" not in self.complained:
        if not self.tMatchesDoubleTauCmbIso40RegFilter_branch and "tMatchesDoubleTauCmbIso40RegFilter":
            warnings.warn( "EETauTree: Expected branch tMatchesDoubleTauCmbIso40RegFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTauCmbIso40RegFilter")
        else:
            self.tMatchesDoubleTauCmbIso40RegFilter_branch.SetAddress(<void*>&self.tMatchesDoubleTauCmbIso40RegFilter_value)

        #print "making tMatchesDoubleTauCmbIso40RegPath"
        self.tMatchesDoubleTauCmbIso40RegPath_branch = the_tree.GetBranch("tMatchesDoubleTauCmbIso40RegPath")
        #if not self.tMatchesDoubleTauCmbIso40RegPath_branch and "tMatchesDoubleTauCmbIso40RegPath" not in self.complained:
        if not self.tMatchesDoubleTauCmbIso40RegPath_branch and "tMatchesDoubleTauCmbIso40RegPath":
            warnings.warn( "EETauTree: Expected branch tMatchesDoubleTauCmbIso40RegPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTauCmbIso40RegPath")
        else:
            self.tMatchesDoubleTauCmbIso40RegPath_branch.SetAddress(<void*>&self.tMatchesDoubleTauCmbIso40RegPath_value)

        #print "making tMatchesEle24Tau20Filter"
        self.tMatchesEle24Tau20Filter_branch = the_tree.GetBranch("tMatchesEle24Tau20Filter")
        #if not self.tMatchesEle24Tau20Filter_branch and "tMatchesEle24Tau20Filter" not in self.complained:
        if not self.tMatchesEle24Tau20Filter_branch and "tMatchesEle24Tau20Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesEle24Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau20Filter")
        else:
            self.tMatchesEle24Tau20Filter_branch.SetAddress(<void*>&self.tMatchesEle24Tau20Filter_value)

        #print "making tMatchesEle24Tau20L1Path"
        self.tMatchesEle24Tau20L1Path_branch = the_tree.GetBranch("tMatchesEle24Tau20L1Path")
        #if not self.tMatchesEle24Tau20L1Path_branch and "tMatchesEle24Tau20L1Path" not in self.complained:
        if not self.tMatchesEle24Tau20L1Path_branch and "tMatchesEle24Tau20L1Path":
            warnings.warn( "EETauTree: Expected branch tMatchesEle24Tau20L1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau20L1Path")
        else:
            self.tMatchesEle24Tau20L1Path_branch.SetAddress(<void*>&self.tMatchesEle24Tau20L1Path_value)

        #print "making tMatchesEle24Tau20Path"
        self.tMatchesEle24Tau20Path_branch = the_tree.GetBranch("tMatchesEle24Tau20Path")
        #if not self.tMatchesEle24Tau20Path_branch and "tMatchesEle24Tau20Path" not in self.complained:
        if not self.tMatchesEle24Tau20Path_branch and "tMatchesEle24Tau20Path":
            warnings.warn( "EETauTree: Expected branch tMatchesEle24Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau20Path")
        else:
            self.tMatchesEle24Tau20Path_branch.SetAddress(<void*>&self.tMatchesEle24Tau20Path_value)

        #print "making tMatchesEle24Tau20sL1Filter"
        self.tMatchesEle24Tau20sL1Filter_branch = the_tree.GetBranch("tMatchesEle24Tau20sL1Filter")
        #if not self.tMatchesEle24Tau20sL1Filter_branch and "tMatchesEle24Tau20sL1Filter" not in self.complained:
        if not self.tMatchesEle24Tau20sL1Filter_branch and "tMatchesEle24Tau20sL1Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesEle24Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau20sL1Filter")
        else:
            self.tMatchesEle24Tau20sL1Filter_branch.SetAddress(<void*>&self.tMatchesEle24Tau20sL1Filter_value)

        #print "making tMatchesEle24Tau30Filter"
        self.tMatchesEle24Tau30Filter_branch = the_tree.GetBranch("tMatchesEle24Tau30Filter")
        #if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter" not in self.complained:
        if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Filter")
        else:
            self.tMatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Filter_value)

        #print "making tMatchesEle24Tau30Path"
        self.tMatchesEle24Tau30Path_branch = the_tree.GetBranch("tMatchesEle24Tau30Path")
        #if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path" not in self.complained:
        if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path":
            warnings.warn( "EETauTree: Expected branch tMatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Path")
        else:
            self.tMatchesEle24Tau30Path_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Path_value)

        #print "making tMatchesMu19Tau20Filter"
        self.tMatchesMu19Tau20Filter_branch = the_tree.GetBranch("tMatchesMu19Tau20Filter")
        #if not self.tMatchesMu19Tau20Filter_branch and "tMatchesMu19Tau20Filter" not in self.complained:
        if not self.tMatchesMu19Tau20Filter_branch and "tMatchesMu19Tau20Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesMu19Tau20Filter")
        else:
            self.tMatchesMu19Tau20Filter_branch.SetAddress(<void*>&self.tMatchesMu19Tau20Filter_value)

        #print "making tMatchesMu19Tau20Path"
        self.tMatchesMu19Tau20Path_branch = the_tree.GetBranch("tMatchesMu19Tau20Path")
        #if not self.tMatchesMu19Tau20Path_branch and "tMatchesMu19Tau20Path" not in self.complained:
        if not self.tMatchesMu19Tau20Path_branch and "tMatchesMu19Tau20Path":
            warnings.warn( "EETauTree: Expected branch tMatchesMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesMu19Tau20Path")
        else:
            self.tMatchesMu19Tau20Path_branch.SetAddress(<void*>&self.tMatchesMu19Tau20Path_value)

        #print "making tMatchesMu19Tau20sL1Filter"
        self.tMatchesMu19Tau20sL1Filter_branch = the_tree.GetBranch("tMatchesMu19Tau20sL1Filter")
        #if not self.tMatchesMu19Tau20sL1Filter_branch and "tMatchesMu19Tau20sL1Filter" not in self.complained:
        if not self.tMatchesMu19Tau20sL1Filter_branch and "tMatchesMu19Tau20sL1Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesMu19Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesMu19Tau20sL1Filter")
        else:
            self.tMatchesMu19Tau20sL1Filter_branch.SetAddress(<void*>&self.tMatchesMu19Tau20sL1Filter_value)

        #print "making tMatchesMu19Tau20sL1Path"
        self.tMatchesMu19Tau20sL1Path_branch = the_tree.GetBranch("tMatchesMu19Tau20sL1Path")
        #if not self.tMatchesMu19Tau20sL1Path_branch and "tMatchesMu19Tau20sL1Path" not in self.complained:
        if not self.tMatchesMu19Tau20sL1Path_branch and "tMatchesMu19Tau20sL1Path":
            warnings.warn( "EETauTree: Expected branch tMatchesMu19Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesMu19Tau20sL1Path")
        else:
            self.tMatchesMu19Tau20sL1Path_branch.SetAddress(<void*>&self.tMatchesMu19Tau20sL1Path_value)

        #print "making tMatchesMu21Tau20sL1Filter"
        self.tMatchesMu21Tau20sL1Filter_branch = the_tree.GetBranch("tMatchesMu21Tau20sL1Filter")
        #if not self.tMatchesMu21Tau20sL1Filter_branch and "tMatchesMu21Tau20sL1Filter" not in self.complained:
        if not self.tMatchesMu21Tau20sL1Filter_branch and "tMatchesMu21Tau20sL1Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesMu21Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesMu21Tau20sL1Filter")
        else:
            self.tMatchesMu21Tau20sL1Filter_branch.SetAddress(<void*>&self.tMatchesMu21Tau20sL1Filter_value)

        #print "making tMatchesMu21Tau20sL1Path"
        self.tMatchesMu21Tau20sL1Path_branch = the_tree.GetBranch("tMatchesMu21Tau20sL1Path")
        #if not self.tMatchesMu21Tau20sL1Path_branch and "tMatchesMu21Tau20sL1Path" not in self.complained:
        if not self.tMatchesMu21Tau20sL1Path_branch and "tMatchesMu21Tau20sL1Path":
            warnings.warn( "EETauTree: Expected branch tMatchesMu21Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesMu21Tau20sL1Path")
        else:
            self.tMatchesMu21Tau20sL1Path_branch.SetAddress(<void*>&self.tMatchesMu21Tau20sL1Path_value)

        #print "making tMtToPfMet_type1"
        self.tMtToPfMet_type1_branch = the_tree.GetBranch("tMtToPfMet_type1")
        #if not self.tMtToPfMet_type1_branch and "tMtToPfMet_type1" not in self.complained:
        if not self.tMtToPfMet_type1_branch and "tMtToPfMet_type1":
            warnings.warn( "EETauTree: Expected branch tMtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_type1")
        else:
            self.tMtToPfMet_type1_branch.SetAddress(<void*>&self.tMtToPfMet_type1_value)

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

        #print "making tNChrgHadrIsolationCands"
        self.tNChrgHadrIsolationCands_branch = the_tree.GetBranch("tNChrgHadrIsolationCands")
        #if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands" not in self.complained:
        if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands":
            warnings.warn( "EETauTree: Expected branch tNChrgHadrIsolationCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrIsolationCands")
        else:
            self.tNChrgHadrIsolationCands_branch.SetAddress(<void*>&self.tNChrgHadrIsolationCands_value)

        #print "making tNChrgHadrSignalCands"
        self.tNChrgHadrSignalCands_branch = the_tree.GetBranch("tNChrgHadrSignalCands")
        #if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands" not in self.complained:
        if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands":
            warnings.warn( "EETauTree: Expected branch tNChrgHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrSignalCands")
        else:
            self.tNChrgHadrSignalCands_branch.SetAddress(<void*>&self.tNChrgHadrSignalCands_value)

        #print "making tNGammaSignalCands"
        self.tNGammaSignalCands_branch = the_tree.GetBranch("tNGammaSignalCands")
        #if not self.tNGammaSignalCands_branch and "tNGammaSignalCands" not in self.complained:
        if not self.tNGammaSignalCands_branch and "tNGammaSignalCands":
            warnings.warn( "EETauTree: Expected branch tNGammaSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNGammaSignalCands")
        else:
            self.tNGammaSignalCands_branch.SetAddress(<void*>&self.tNGammaSignalCands_value)

        #print "making tNNeutralHadrSignalCands"
        self.tNNeutralHadrSignalCands_branch = the_tree.GetBranch("tNNeutralHadrSignalCands")
        #if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands" not in self.complained:
        if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands":
            warnings.warn( "EETauTree: Expected branch tNNeutralHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNNeutralHadrSignalCands")
        else:
            self.tNNeutralHadrSignalCands_branch.SetAddress(<void*>&self.tNNeutralHadrSignalCands_value)

        #print "making tNSignalCands"
        self.tNSignalCands_branch = the_tree.GetBranch("tNSignalCands")
        #if not self.tNSignalCands_branch and "tNSignalCands" not in self.complained:
        if not self.tNSignalCands_branch and "tNSignalCands":
            warnings.warn( "EETauTree: Expected branch tNSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNSignalCands")
        else:
            self.tNSignalCands_branch.SetAddress(<void*>&self.tNSignalCands_value)

        #print "making tNearestZMass"
        self.tNearestZMass_branch = the_tree.GetBranch("tNearestZMass")
        #if not self.tNearestZMass_branch and "tNearestZMass" not in self.complained:
        if not self.tNearestZMass_branch and "tNearestZMass":
            warnings.warn( "EETauTree: Expected branch tNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNearestZMass")
        else:
            self.tNearestZMass_branch.SetAddress(<void*>&self.tNearestZMass_value)

        #print "making tNeutralIsoPtSum"
        self.tNeutralIsoPtSum_branch = the_tree.GetBranch("tNeutralIsoPtSum")
        #if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum" not in self.complained:
        if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum":
            warnings.warn( "EETauTree: Expected branch tNeutralIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSum")
        else:
            self.tNeutralIsoPtSum_branch.SetAddress(<void*>&self.tNeutralIsoPtSum_value)

        #print "making tNeutralIsoPtSumWeight"
        self.tNeutralIsoPtSumWeight_branch = the_tree.GetBranch("tNeutralIsoPtSumWeight")
        #if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight" not in self.complained:
        if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight":
            warnings.warn( "EETauTree: Expected branch tNeutralIsoPtSumWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeight")
        else:
            self.tNeutralIsoPtSumWeight_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeight_value)

        #print "making tNeutralIsoPtSumWeightdR03"
        self.tNeutralIsoPtSumWeightdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumWeightdR03")
        #if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03" not in self.complained:
        if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03":
            warnings.warn( "EETauTree: Expected branch tNeutralIsoPtSumWeightdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeightdR03")
        else:
            self.tNeutralIsoPtSumWeightdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeightdR03_value)

        #print "making tNeutralIsoPtSumdR03"
        self.tNeutralIsoPtSumdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumdR03")
        #if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03" not in self.complained:
        if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03":
            warnings.warn( "EETauTree: Expected branch tNeutralIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumdR03")
        else:
            self.tNeutralIsoPtSumdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumdR03_value)

        #print "making tPVDXY"
        self.tPVDXY_branch = the_tree.GetBranch("tPVDXY")
        #if not self.tPVDXY_branch and "tPVDXY" not in self.complained:
        if not self.tPVDXY_branch and "tPVDXY":
            warnings.warn( "EETauTree: Expected branch tPVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDXY")
        else:
            self.tPVDXY_branch.SetAddress(<void*>&self.tPVDXY_value)

        #print "making tPVDZ"
        self.tPVDZ_branch = the_tree.GetBranch("tPVDZ")
        #if not self.tPVDZ_branch and "tPVDZ" not in self.complained:
        if not self.tPVDZ_branch and "tPVDZ":
            warnings.warn( "EETauTree: Expected branch tPVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDZ")
        else:
            self.tPVDZ_branch.SetAddress(<void*>&self.tPVDZ_value)

        #print "making tPhi"
        self.tPhi_branch = the_tree.GetBranch("tPhi")
        #if not self.tPhi_branch and "tPhi" not in self.complained:
        if not self.tPhi_branch and "tPhi":
            warnings.warn( "EETauTree: Expected branch tPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi")
        else:
            self.tPhi_branch.SetAddress(<void*>&self.tPhi_value)

        #print "making tPhi_TauEnDown"
        self.tPhi_TauEnDown_branch = the_tree.GetBranch("tPhi_TauEnDown")
        #if not self.tPhi_TauEnDown_branch and "tPhi_TauEnDown" not in self.complained:
        if not self.tPhi_TauEnDown_branch and "tPhi_TauEnDown":
            warnings.warn( "EETauTree: Expected branch tPhi_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi_TauEnDown")
        else:
            self.tPhi_TauEnDown_branch.SetAddress(<void*>&self.tPhi_TauEnDown_value)

        #print "making tPhi_TauEnUp"
        self.tPhi_TauEnUp_branch = the_tree.GetBranch("tPhi_TauEnUp")
        #if not self.tPhi_TauEnUp_branch and "tPhi_TauEnUp" not in self.complained:
        if not self.tPhi_TauEnUp_branch and "tPhi_TauEnUp":
            warnings.warn( "EETauTree: Expected branch tPhi_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi_TauEnUp")
        else:
            self.tPhi_TauEnUp_branch.SetAddress(<void*>&self.tPhi_TauEnUp_value)

        #print "making tPhotonPtSumOutsideSignalCone"
        self.tPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalCone")
        #if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone":
            warnings.warn( "EETauTree: Expected branch tPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalCone")
        else:
            self.tPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalCone_value)

        #print "making tPhotonPtSumOutsideSignalConedR03"
        self.tPhotonPtSumOutsideSignalConedR03_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalConedR03")
        #if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03":
            warnings.warn( "EETauTree: Expected branch tPhotonPtSumOutsideSignalConedR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalConedR03")
        else:
            self.tPhotonPtSumOutsideSignalConedR03_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalConedR03_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "EETauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tPt_TauEnDown"
        self.tPt_TauEnDown_branch = the_tree.GetBranch("tPt_TauEnDown")
        #if not self.tPt_TauEnDown_branch and "tPt_TauEnDown" not in self.complained:
        if not self.tPt_TauEnDown_branch and "tPt_TauEnDown":
            warnings.warn( "EETauTree: Expected branch tPt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt_TauEnDown")
        else:
            self.tPt_TauEnDown_branch.SetAddress(<void*>&self.tPt_TauEnDown_value)

        #print "making tPt_TauEnUp"
        self.tPt_TauEnUp_branch = the_tree.GetBranch("tPt_TauEnUp")
        #if not self.tPt_TauEnUp_branch and "tPt_TauEnUp" not in self.complained:
        if not self.tPt_TauEnUp_branch and "tPt_TauEnUp":
            warnings.warn( "EETauTree: Expected branch tPt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt_TauEnUp")
        else:
            self.tPt_TauEnUp_branch.SetAddress(<void*>&self.tPt_TauEnUp_value)

        #print "making tPuCorrPtSum"
        self.tPuCorrPtSum_branch = the_tree.GetBranch("tPuCorrPtSum")
        #if not self.tPuCorrPtSum_branch and "tPuCorrPtSum" not in self.complained:
        if not self.tPuCorrPtSum_branch and "tPuCorrPtSum":
            warnings.warn( "EETauTree: Expected branch tPuCorrPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPuCorrPtSum")
        else:
            self.tPuCorrPtSum_branch.SetAddress(<void*>&self.tPuCorrPtSum_value)

        #print "making tRank"
        self.tRank_branch = the_tree.GetBranch("tRank")
        #if not self.tRank_branch and "tRank" not in self.complained:
        if not self.tRank_branch and "tRank":
            warnings.warn( "EETauTree: Expected branch tRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRank")
        else:
            self.tRank_branch.SetAddress(<void*>&self.tRank_value)

        #print "making tRerunMVArun2v1DBoldDMwLTLoose"
        self.tRerunMVArun2v1DBoldDMwLTLoose_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTLoose")
        #if not self.tRerunMVArun2v1DBoldDMwLTLoose_branch and "tRerunMVArun2v1DBoldDMwLTLoose" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTLoose_branch and "tRerunMVArun2v1DBoldDMwLTLoose":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v1DBoldDMwLTLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTLoose")
        else:
            self.tRerunMVArun2v1DBoldDMwLTLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTLoose_value)

        #print "making tRerunMVArun2v1DBoldDMwLTMedium"
        self.tRerunMVArun2v1DBoldDMwLTMedium_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTMedium")
        #if not self.tRerunMVArun2v1DBoldDMwLTMedium_branch and "tRerunMVArun2v1DBoldDMwLTMedium" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTMedium_branch and "tRerunMVArun2v1DBoldDMwLTMedium":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v1DBoldDMwLTMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTMedium")
        else:
            self.tRerunMVArun2v1DBoldDMwLTMedium_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTMedium_value)

        #print "making tRerunMVArun2v1DBoldDMwLTTight"
        self.tRerunMVArun2v1DBoldDMwLTTight_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTTight")
        #if not self.tRerunMVArun2v1DBoldDMwLTTight_branch and "tRerunMVArun2v1DBoldDMwLTTight" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTTight_branch and "tRerunMVArun2v1DBoldDMwLTTight":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v1DBoldDMwLTTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTTight")
        else:
            self.tRerunMVArun2v1DBoldDMwLTTight_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTTight_value)

        #print "making tRerunMVArun2v1DBoldDMwLTVLoose"
        self.tRerunMVArun2v1DBoldDMwLTVLoose_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTVLoose")
        #if not self.tRerunMVArun2v1DBoldDMwLTVLoose_branch and "tRerunMVArun2v1DBoldDMwLTVLoose" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTVLoose_branch and "tRerunMVArun2v1DBoldDMwLTVLoose":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v1DBoldDMwLTVLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTVLoose")
        else:
            self.tRerunMVArun2v1DBoldDMwLTVLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTVLoose_value)

        #print "making tRerunMVArun2v1DBoldDMwLTVTight"
        self.tRerunMVArun2v1DBoldDMwLTVTight_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTVTight")
        #if not self.tRerunMVArun2v1DBoldDMwLTVTight_branch and "tRerunMVArun2v1DBoldDMwLTVTight" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTVTight_branch and "tRerunMVArun2v1DBoldDMwLTVTight":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v1DBoldDMwLTVTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTVTight")
        else:
            self.tRerunMVArun2v1DBoldDMwLTVTight_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTVTight_value)

        #print "making tRerunMVArun2v1DBoldDMwLTVVTight"
        self.tRerunMVArun2v1DBoldDMwLTVVTight_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTVVTight")
        #if not self.tRerunMVArun2v1DBoldDMwLTVVTight_branch and "tRerunMVArun2v1DBoldDMwLTVVTight" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTVVTight_branch and "tRerunMVArun2v1DBoldDMwLTVVTight":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v1DBoldDMwLTVVTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTVVTight")
        else:
            self.tRerunMVArun2v1DBoldDMwLTVVTight_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTVVTight_value)

        #print "making tRerunMVArun2v1DBoldDMwLTraw"
        self.tRerunMVArun2v1DBoldDMwLTraw_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTraw")
        #if not self.tRerunMVArun2v1DBoldDMwLTraw_branch and "tRerunMVArun2v1DBoldDMwLTraw" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTraw_branch and "tRerunMVArun2v1DBoldDMwLTraw":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v1DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTraw")
        else:
            self.tRerunMVArun2v1DBoldDMwLTraw_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTraw_value)

        #print "making tVZ"
        self.tVZ_branch = the_tree.GetBranch("tVZ")
        #if not self.tVZ_branch and "tVZ" not in self.complained:
        if not self.tVZ_branch and "tVZ":
            warnings.warn( "EETauTree: Expected branch tVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVZ")
        else:
            self.tVZ_branch.SetAddress(<void*>&self.tVZ_value)

        #print "making tZTTGenDR"
        self.tZTTGenDR_branch = the_tree.GetBranch("tZTTGenDR")
        #if not self.tZTTGenDR_branch and "tZTTGenDR" not in self.complained:
        if not self.tZTTGenDR_branch and "tZTTGenDR":
            warnings.warn( "EETauTree: Expected branch tZTTGenDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenDR")
        else:
            self.tZTTGenDR_branch.SetAddress(<void*>&self.tZTTGenDR_value)

        #print "making tZTTGenEta"
        self.tZTTGenEta_branch = the_tree.GetBranch("tZTTGenEta")
        #if not self.tZTTGenEta_branch and "tZTTGenEta" not in self.complained:
        if not self.tZTTGenEta_branch and "tZTTGenEta":
            warnings.warn( "EETauTree: Expected branch tZTTGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenEta")
        else:
            self.tZTTGenEta_branch.SetAddress(<void*>&self.tZTTGenEta_value)

        #print "making tZTTGenMatching"
        self.tZTTGenMatching_branch = the_tree.GetBranch("tZTTGenMatching")
        #if not self.tZTTGenMatching_branch and "tZTTGenMatching" not in self.complained:
        if not self.tZTTGenMatching_branch and "tZTTGenMatching":
            warnings.warn( "EETauTree: Expected branch tZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenMatching")
        else:
            self.tZTTGenMatching_branch.SetAddress(<void*>&self.tZTTGenMatching_value)

        #print "making tZTTGenPhi"
        self.tZTTGenPhi_branch = the_tree.GetBranch("tZTTGenPhi")
        #if not self.tZTTGenPhi_branch and "tZTTGenPhi" not in self.complained:
        if not self.tZTTGenPhi_branch and "tZTTGenPhi":
            warnings.warn( "EETauTree: Expected branch tZTTGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenPhi")
        else:
            self.tZTTGenPhi_branch.SetAddress(<void*>&self.tZTTGenPhi_value)

        #print "making tZTTGenPt"
        self.tZTTGenPt_branch = the_tree.GetBranch("tZTTGenPt")
        #if not self.tZTTGenPt_branch and "tZTTGenPt" not in self.complained:
        if not self.tZTTGenPt_branch and "tZTTGenPt":
            warnings.warn( "EETauTree: Expected branch tZTTGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenPt")
        else:
            self.tZTTGenPt_branch.SetAddress(<void*>&self.tZTTGenPt_value)

        #print "making t_e1_collinearmass"
        self.t_e1_collinearmass_branch = the_tree.GetBranch("t_e1_collinearmass")
        #if not self.t_e1_collinearmass_branch and "t_e1_collinearmass" not in self.complained:
        if not self.t_e1_collinearmass_branch and "t_e1_collinearmass":
            warnings.warn( "EETauTree: Expected branch t_e1_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e1_collinearmass")
        else:
            self.t_e1_collinearmass_branch.SetAddress(<void*>&self.t_e1_collinearmass_value)

        #print "making t_e1_collinearmass_CheckUESDown"
        self.t_e1_collinearmass_CheckUESDown_branch = the_tree.GetBranch("t_e1_collinearmass_CheckUESDown")
        #if not self.t_e1_collinearmass_CheckUESDown_branch and "t_e1_collinearmass_CheckUESDown" not in self.complained:
        if not self.t_e1_collinearmass_CheckUESDown_branch and "t_e1_collinearmass_CheckUESDown":
            warnings.warn( "EETauTree: Expected branch t_e1_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e1_collinearmass_CheckUESDown")
        else:
            self.t_e1_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.t_e1_collinearmass_CheckUESDown_value)

        #print "making t_e1_collinearmass_CheckUESUp"
        self.t_e1_collinearmass_CheckUESUp_branch = the_tree.GetBranch("t_e1_collinearmass_CheckUESUp")
        #if not self.t_e1_collinearmass_CheckUESUp_branch and "t_e1_collinearmass_CheckUESUp" not in self.complained:
        if not self.t_e1_collinearmass_CheckUESUp_branch and "t_e1_collinearmass_CheckUESUp":
            warnings.warn( "EETauTree: Expected branch t_e1_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e1_collinearmass_CheckUESUp")
        else:
            self.t_e1_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.t_e1_collinearmass_CheckUESUp_value)

        #print "making t_e1_collinearmass_JetCheckTotalDown"
        self.t_e1_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("t_e1_collinearmass_JetCheckTotalDown")
        #if not self.t_e1_collinearmass_JetCheckTotalDown_branch and "t_e1_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.t_e1_collinearmass_JetCheckTotalDown_branch and "t_e1_collinearmass_JetCheckTotalDown":
            warnings.warn( "EETauTree: Expected branch t_e1_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e1_collinearmass_JetCheckTotalDown")
        else:
            self.t_e1_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.t_e1_collinearmass_JetCheckTotalDown_value)

        #print "making t_e1_collinearmass_JetCheckTotalUp"
        self.t_e1_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("t_e1_collinearmass_JetCheckTotalUp")
        #if not self.t_e1_collinearmass_JetCheckTotalUp_branch and "t_e1_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.t_e1_collinearmass_JetCheckTotalUp_branch and "t_e1_collinearmass_JetCheckTotalUp":
            warnings.warn( "EETauTree: Expected branch t_e1_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e1_collinearmass_JetCheckTotalUp")
        else:
            self.t_e1_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.t_e1_collinearmass_JetCheckTotalUp_value)

        #print "making t_e1_collinearmass_JetEnDown"
        self.t_e1_collinearmass_JetEnDown_branch = the_tree.GetBranch("t_e1_collinearmass_JetEnDown")
        #if not self.t_e1_collinearmass_JetEnDown_branch and "t_e1_collinearmass_JetEnDown" not in self.complained:
        if not self.t_e1_collinearmass_JetEnDown_branch and "t_e1_collinearmass_JetEnDown":
            warnings.warn( "EETauTree: Expected branch t_e1_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e1_collinearmass_JetEnDown")
        else:
            self.t_e1_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.t_e1_collinearmass_JetEnDown_value)

        #print "making t_e1_collinearmass_JetEnUp"
        self.t_e1_collinearmass_JetEnUp_branch = the_tree.GetBranch("t_e1_collinearmass_JetEnUp")
        #if not self.t_e1_collinearmass_JetEnUp_branch and "t_e1_collinearmass_JetEnUp" not in self.complained:
        if not self.t_e1_collinearmass_JetEnUp_branch and "t_e1_collinearmass_JetEnUp":
            warnings.warn( "EETauTree: Expected branch t_e1_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e1_collinearmass_JetEnUp")
        else:
            self.t_e1_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.t_e1_collinearmass_JetEnUp_value)

        #print "making t_e1_collinearmass_UnclusteredEnDown"
        self.t_e1_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("t_e1_collinearmass_UnclusteredEnDown")
        #if not self.t_e1_collinearmass_UnclusteredEnDown_branch and "t_e1_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.t_e1_collinearmass_UnclusteredEnDown_branch and "t_e1_collinearmass_UnclusteredEnDown":
            warnings.warn( "EETauTree: Expected branch t_e1_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e1_collinearmass_UnclusteredEnDown")
        else:
            self.t_e1_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.t_e1_collinearmass_UnclusteredEnDown_value)

        #print "making t_e1_collinearmass_UnclusteredEnUp"
        self.t_e1_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("t_e1_collinearmass_UnclusteredEnUp")
        #if not self.t_e1_collinearmass_UnclusteredEnUp_branch and "t_e1_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.t_e1_collinearmass_UnclusteredEnUp_branch and "t_e1_collinearmass_UnclusteredEnUp":
            warnings.warn( "EETauTree: Expected branch t_e1_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e1_collinearmass_UnclusteredEnUp")
        else:
            self.t_e1_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.t_e1_collinearmass_UnclusteredEnUp_value)

        #print "making t_e2_collinearmass"
        self.t_e2_collinearmass_branch = the_tree.GetBranch("t_e2_collinearmass")
        #if not self.t_e2_collinearmass_branch and "t_e2_collinearmass" not in self.complained:
        if not self.t_e2_collinearmass_branch and "t_e2_collinearmass":
            warnings.warn( "EETauTree: Expected branch t_e2_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e2_collinearmass")
        else:
            self.t_e2_collinearmass_branch.SetAddress(<void*>&self.t_e2_collinearmass_value)

        #print "making t_e2_collinearmass_CheckUESDown"
        self.t_e2_collinearmass_CheckUESDown_branch = the_tree.GetBranch("t_e2_collinearmass_CheckUESDown")
        #if not self.t_e2_collinearmass_CheckUESDown_branch and "t_e2_collinearmass_CheckUESDown" not in self.complained:
        if not self.t_e2_collinearmass_CheckUESDown_branch and "t_e2_collinearmass_CheckUESDown":
            warnings.warn( "EETauTree: Expected branch t_e2_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e2_collinearmass_CheckUESDown")
        else:
            self.t_e2_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.t_e2_collinearmass_CheckUESDown_value)

        #print "making t_e2_collinearmass_CheckUESUp"
        self.t_e2_collinearmass_CheckUESUp_branch = the_tree.GetBranch("t_e2_collinearmass_CheckUESUp")
        #if not self.t_e2_collinearmass_CheckUESUp_branch and "t_e2_collinearmass_CheckUESUp" not in self.complained:
        if not self.t_e2_collinearmass_CheckUESUp_branch and "t_e2_collinearmass_CheckUESUp":
            warnings.warn( "EETauTree: Expected branch t_e2_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e2_collinearmass_CheckUESUp")
        else:
            self.t_e2_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.t_e2_collinearmass_CheckUESUp_value)

        #print "making t_e2_collinearmass_JetCheckTotalDown"
        self.t_e2_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("t_e2_collinearmass_JetCheckTotalDown")
        #if not self.t_e2_collinearmass_JetCheckTotalDown_branch and "t_e2_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.t_e2_collinearmass_JetCheckTotalDown_branch and "t_e2_collinearmass_JetCheckTotalDown":
            warnings.warn( "EETauTree: Expected branch t_e2_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e2_collinearmass_JetCheckTotalDown")
        else:
            self.t_e2_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.t_e2_collinearmass_JetCheckTotalDown_value)

        #print "making t_e2_collinearmass_JetCheckTotalUp"
        self.t_e2_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("t_e2_collinearmass_JetCheckTotalUp")
        #if not self.t_e2_collinearmass_JetCheckTotalUp_branch and "t_e2_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.t_e2_collinearmass_JetCheckTotalUp_branch and "t_e2_collinearmass_JetCheckTotalUp":
            warnings.warn( "EETauTree: Expected branch t_e2_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e2_collinearmass_JetCheckTotalUp")
        else:
            self.t_e2_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.t_e2_collinearmass_JetCheckTotalUp_value)

        #print "making t_e2_collinearmass_JetEnDown"
        self.t_e2_collinearmass_JetEnDown_branch = the_tree.GetBranch("t_e2_collinearmass_JetEnDown")
        #if not self.t_e2_collinearmass_JetEnDown_branch and "t_e2_collinearmass_JetEnDown" not in self.complained:
        if not self.t_e2_collinearmass_JetEnDown_branch and "t_e2_collinearmass_JetEnDown":
            warnings.warn( "EETauTree: Expected branch t_e2_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e2_collinearmass_JetEnDown")
        else:
            self.t_e2_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.t_e2_collinearmass_JetEnDown_value)

        #print "making t_e2_collinearmass_JetEnUp"
        self.t_e2_collinearmass_JetEnUp_branch = the_tree.GetBranch("t_e2_collinearmass_JetEnUp")
        #if not self.t_e2_collinearmass_JetEnUp_branch and "t_e2_collinearmass_JetEnUp" not in self.complained:
        if not self.t_e2_collinearmass_JetEnUp_branch and "t_e2_collinearmass_JetEnUp":
            warnings.warn( "EETauTree: Expected branch t_e2_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e2_collinearmass_JetEnUp")
        else:
            self.t_e2_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.t_e2_collinearmass_JetEnUp_value)

        #print "making t_e2_collinearmass_UnclusteredEnDown"
        self.t_e2_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("t_e2_collinearmass_UnclusteredEnDown")
        #if not self.t_e2_collinearmass_UnclusteredEnDown_branch and "t_e2_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.t_e2_collinearmass_UnclusteredEnDown_branch and "t_e2_collinearmass_UnclusteredEnDown":
            warnings.warn( "EETauTree: Expected branch t_e2_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e2_collinearmass_UnclusteredEnDown")
        else:
            self.t_e2_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.t_e2_collinearmass_UnclusteredEnDown_value)

        #print "making t_e2_collinearmass_UnclusteredEnUp"
        self.t_e2_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("t_e2_collinearmass_UnclusteredEnUp")
        #if not self.t_e2_collinearmass_UnclusteredEnUp_branch and "t_e2_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.t_e2_collinearmass_UnclusteredEnUp_branch and "t_e2_collinearmass_UnclusteredEnUp":
            warnings.warn( "EETauTree: Expected branch t_e2_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_e2_collinearmass_UnclusteredEnUp")
        else:
            self.t_e2_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.t_e2_collinearmass_UnclusteredEnUp_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "EETauTree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "EETauTree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

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

        #print "making tripleMuGroup"
        self.tripleMuGroup_branch = the_tree.GetBranch("tripleMuGroup")
        #if not self.tripleMuGroup_branch and "tripleMuGroup" not in self.complained:
        if not self.tripleMuGroup_branch and "tripleMuGroup":
            warnings.warn( "EETauTree: Expected branch tripleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuGroup")
        else:
            self.tripleMuGroup_branch.SetAddress(<void*>&self.tripleMuGroup_value)

        #print "making tripleMuPass"
        self.tripleMuPass_branch = the_tree.GetBranch("tripleMuPass")
        #if not self.tripleMuPass_branch and "tripleMuPass" not in self.complained:
        if not self.tripleMuPass_branch and "tripleMuPass":
            warnings.warn( "EETauTree: Expected branch tripleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuPass")
        else:
            self.tripleMuPass_branch.SetAddress(<void*>&self.tripleMuPass_value)

        #print "making tripleMuPrescale"
        self.tripleMuPrescale_branch = the_tree.GetBranch("tripleMuPrescale")
        #if not self.tripleMuPrescale_branch and "tripleMuPrescale" not in self.complained:
        if not self.tripleMuPrescale_branch and "tripleMuPrescale":
            warnings.warn( "EETauTree: Expected branch tripleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuPrescale")
        else:
            self.tripleMuPrescale_branch.SetAddress(<void*>&self.tripleMuPrescale_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "EETauTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "EETauTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "EETauTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfDeta_JetEnDown"
        self.vbfDeta_JetEnDown_branch = the_tree.GetBranch("vbfDeta_JetEnDown")
        #if not self.vbfDeta_JetEnDown_branch and "vbfDeta_JetEnDown" not in self.complained:
        if not self.vbfDeta_JetEnDown_branch and "vbfDeta_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfDeta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta_JetEnDown")
        else:
            self.vbfDeta_JetEnDown_branch.SetAddress(<void*>&self.vbfDeta_JetEnDown_value)

        #print "making vbfDeta_JetEnUp"
        self.vbfDeta_JetEnUp_branch = the_tree.GetBranch("vbfDeta_JetEnUp")
        #if not self.vbfDeta_JetEnUp_branch and "vbfDeta_JetEnUp" not in self.complained:
        if not self.vbfDeta_JetEnUp_branch and "vbfDeta_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfDeta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta_JetEnUp")
        else:
            self.vbfDeta_JetEnUp_branch.SetAddress(<void*>&self.vbfDeta_JetEnUp_value)

        #print "making vbfDijetrap"
        self.vbfDijetrap_branch = the_tree.GetBranch("vbfDijetrap")
        #if not self.vbfDijetrap_branch and "vbfDijetrap" not in self.complained:
        if not self.vbfDijetrap_branch and "vbfDijetrap":
            warnings.warn( "EETauTree: Expected branch vbfDijetrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap")
        else:
            self.vbfDijetrap_branch.SetAddress(<void*>&self.vbfDijetrap_value)

        #print "making vbfDijetrap_JetEnDown"
        self.vbfDijetrap_JetEnDown_branch = the_tree.GetBranch("vbfDijetrap_JetEnDown")
        #if not self.vbfDijetrap_JetEnDown_branch and "vbfDijetrap_JetEnDown" not in self.complained:
        if not self.vbfDijetrap_JetEnDown_branch and "vbfDijetrap_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfDijetrap_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap_JetEnDown")
        else:
            self.vbfDijetrap_JetEnDown_branch.SetAddress(<void*>&self.vbfDijetrap_JetEnDown_value)

        #print "making vbfDijetrap_JetEnUp"
        self.vbfDijetrap_JetEnUp_branch = the_tree.GetBranch("vbfDijetrap_JetEnUp")
        #if not self.vbfDijetrap_JetEnUp_branch and "vbfDijetrap_JetEnUp" not in self.complained:
        if not self.vbfDijetrap_JetEnUp_branch and "vbfDijetrap_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfDijetrap_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap_JetEnUp")
        else:
            self.vbfDijetrap_JetEnUp_branch.SetAddress(<void*>&self.vbfDijetrap_JetEnUp_value)

        #print "making vbfDphi"
        self.vbfDphi_branch = the_tree.GetBranch("vbfDphi")
        #if not self.vbfDphi_branch and "vbfDphi" not in self.complained:
        if not self.vbfDphi_branch and "vbfDphi":
            warnings.warn( "EETauTree: Expected branch vbfDphi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi")
        else:
            self.vbfDphi_branch.SetAddress(<void*>&self.vbfDphi_value)

        #print "making vbfDphi_JetEnDown"
        self.vbfDphi_JetEnDown_branch = the_tree.GetBranch("vbfDphi_JetEnDown")
        #if not self.vbfDphi_JetEnDown_branch and "vbfDphi_JetEnDown" not in self.complained:
        if not self.vbfDphi_JetEnDown_branch and "vbfDphi_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfDphi_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi_JetEnDown")
        else:
            self.vbfDphi_JetEnDown_branch.SetAddress(<void*>&self.vbfDphi_JetEnDown_value)

        #print "making vbfDphi_JetEnUp"
        self.vbfDphi_JetEnUp_branch = the_tree.GetBranch("vbfDphi_JetEnUp")
        #if not self.vbfDphi_JetEnUp_branch and "vbfDphi_JetEnUp" not in self.complained:
        if not self.vbfDphi_JetEnUp_branch and "vbfDphi_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfDphi_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi_JetEnUp")
        else:
            self.vbfDphi_JetEnUp_branch.SetAddress(<void*>&self.vbfDphi_JetEnUp_value)

        #print "making vbfDphihj"
        self.vbfDphihj_branch = the_tree.GetBranch("vbfDphihj")
        #if not self.vbfDphihj_branch and "vbfDphihj" not in self.complained:
        if not self.vbfDphihj_branch and "vbfDphihj":
            warnings.warn( "EETauTree: Expected branch vbfDphihj does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj")
        else:
            self.vbfDphihj_branch.SetAddress(<void*>&self.vbfDphihj_value)

        #print "making vbfDphihj_JetEnDown"
        self.vbfDphihj_JetEnDown_branch = the_tree.GetBranch("vbfDphihj_JetEnDown")
        #if not self.vbfDphihj_JetEnDown_branch and "vbfDphihj_JetEnDown" not in self.complained:
        if not self.vbfDphihj_JetEnDown_branch and "vbfDphihj_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfDphihj_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj_JetEnDown")
        else:
            self.vbfDphihj_JetEnDown_branch.SetAddress(<void*>&self.vbfDphihj_JetEnDown_value)

        #print "making vbfDphihj_JetEnUp"
        self.vbfDphihj_JetEnUp_branch = the_tree.GetBranch("vbfDphihj_JetEnUp")
        #if not self.vbfDphihj_JetEnUp_branch and "vbfDphihj_JetEnUp" not in self.complained:
        if not self.vbfDphihj_JetEnUp_branch and "vbfDphihj_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfDphihj_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj_JetEnUp")
        else:
            self.vbfDphihj_JetEnUp_branch.SetAddress(<void*>&self.vbfDphihj_JetEnUp_value)

        #print "making vbfDphihjnomet"
        self.vbfDphihjnomet_branch = the_tree.GetBranch("vbfDphihjnomet")
        #if not self.vbfDphihjnomet_branch and "vbfDphihjnomet" not in self.complained:
        if not self.vbfDphihjnomet_branch and "vbfDphihjnomet":
            warnings.warn( "EETauTree: Expected branch vbfDphihjnomet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet")
        else:
            self.vbfDphihjnomet_branch.SetAddress(<void*>&self.vbfDphihjnomet_value)

        #print "making vbfDphihjnomet_JetEnDown"
        self.vbfDphihjnomet_JetEnDown_branch = the_tree.GetBranch("vbfDphihjnomet_JetEnDown")
        #if not self.vbfDphihjnomet_JetEnDown_branch and "vbfDphihjnomet_JetEnDown" not in self.complained:
        if not self.vbfDphihjnomet_JetEnDown_branch and "vbfDphihjnomet_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfDphihjnomet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet_JetEnDown")
        else:
            self.vbfDphihjnomet_JetEnDown_branch.SetAddress(<void*>&self.vbfDphihjnomet_JetEnDown_value)

        #print "making vbfDphihjnomet_JetEnUp"
        self.vbfDphihjnomet_JetEnUp_branch = the_tree.GetBranch("vbfDphihjnomet_JetEnUp")
        #if not self.vbfDphihjnomet_JetEnUp_branch and "vbfDphihjnomet_JetEnUp" not in self.complained:
        if not self.vbfDphihjnomet_JetEnUp_branch and "vbfDphihjnomet_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfDphihjnomet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet_JetEnUp")
        else:
            self.vbfDphihjnomet_JetEnUp_branch.SetAddress(<void*>&self.vbfDphihjnomet_JetEnUp_value)

        #print "making vbfHrap"
        self.vbfHrap_branch = the_tree.GetBranch("vbfHrap")
        #if not self.vbfHrap_branch and "vbfHrap" not in self.complained:
        if not self.vbfHrap_branch and "vbfHrap":
            warnings.warn( "EETauTree: Expected branch vbfHrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap")
        else:
            self.vbfHrap_branch.SetAddress(<void*>&self.vbfHrap_value)

        #print "making vbfHrap_JetEnDown"
        self.vbfHrap_JetEnDown_branch = the_tree.GetBranch("vbfHrap_JetEnDown")
        #if not self.vbfHrap_JetEnDown_branch and "vbfHrap_JetEnDown" not in self.complained:
        if not self.vbfHrap_JetEnDown_branch and "vbfHrap_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfHrap_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap_JetEnDown")
        else:
            self.vbfHrap_JetEnDown_branch.SetAddress(<void*>&self.vbfHrap_JetEnDown_value)

        #print "making vbfHrap_JetEnUp"
        self.vbfHrap_JetEnUp_branch = the_tree.GetBranch("vbfHrap_JetEnUp")
        #if not self.vbfHrap_JetEnUp_branch and "vbfHrap_JetEnUp" not in self.complained:
        if not self.vbfHrap_JetEnUp_branch and "vbfHrap_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfHrap_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap_JetEnUp")
        else:
            self.vbfHrap_JetEnUp_branch.SetAddress(<void*>&self.vbfHrap_JetEnUp_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "EETauTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto20_JetEnDown"
        self.vbfJetVeto20_JetEnDown_branch = the_tree.GetBranch("vbfJetVeto20_JetEnDown")
        #if not self.vbfJetVeto20_JetEnDown_branch and "vbfJetVeto20_JetEnDown" not in self.complained:
        if not self.vbfJetVeto20_JetEnDown_branch and "vbfJetVeto20_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfJetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20_JetEnDown")
        else:
            self.vbfJetVeto20_JetEnDown_branch.SetAddress(<void*>&self.vbfJetVeto20_JetEnDown_value)

        #print "making vbfJetVeto20_JetEnUp"
        self.vbfJetVeto20_JetEnUp_branch = the_tree.GetBranch("vbfJetVeto20_JetEnUp")
        #if not self.vbfJetVeto20_JetEnUp_branch and "vbfJetVeto20_JetEnUp" not in self.complained:
        if not self.vbfJetVeto20_JetEnUp_branch and "vbfJetVeto20_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfJetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20_JetEnUp")
        else:
            self.vbfJetVeto20_JetEnUp_branch.SetAddress(<void*>&self.vbfJetVeto20_JetEnUp_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "EETauTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfJetVeto30_JetEnDown"
        self.vbfJetVeto30_JetEnDown_branch = the_tree.GetBranch("vbfJetVeto30_JetEnDown")
        #if not self.vbfJetVeto30_JetEnDown_branch and "vbfJetVeto30_JetEnDown" not in self.complained:
        if not self.vbfJetVeto30_JetEnDown_branch and "vbfJetVeto30_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfJetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30_JetEnDown")
        else:
            self.vbfJetVeto30_JetEnDown_branch.SetAddress(<void*>&self.vbfJetVeto30_JetEnDown_value)

        #print "making vbfJetVeto30_JetEnUp"
        self.vbfJetVeto30_JetEnUp_branch = the_tree.GetBranch("vbfJetVeto30_JetEnUp")
        #if not self.vbfJetVeto30_JetEnUp_branch and "vbfJetVeto30_JetEnUp" not in self.complained:
        if not self.vbfJetVeto30_JetEnUp_branch and "vbfJetVeto30_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfJetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30_JetEnUp")
        else:
            self.vbfJetVeto30_JetEnUp_branch.SetAddress(<void*>&self.vbfJetVeto30_JetEnUp_value)

        #print "making vbfMVA"
        self.vbfMVA_branch = the_tree.GetBranch("vbfMVA")
        #if not self.vbfMVA_branch and "vbfMVA" not in self.complained:
        if not self.vbfMVA_branch and "vbfMVA":
            warnings.warn( "EETauTree: Expected branch vbfMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA")
        else:
            self.vbfMVA_branch.SetAddress(<void*>&self.vbfMVA_value)

        #print "making vbfMVA_JetEnDown"
        self.vbfMVA_JetEnDown_branch = the_tree.GetBranch("vbfMVA_JetEnDown")
        #if not self.vbfMVA_JetEnDown_branch and "vbfMVA_JetEnDown" not in self.complained:
        if not self.vbfMVA_JetEnDown_branch and "vbfMVA_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfMVA_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA_JetEnDown")
        else:
            self.vbfMVA_JetEnDown_branch.SetAddress(<void*>&self.vbfMVA_JetEnDown_value)

        #print "making vbfMVA_JetEnUp"
        self.vbfMVA_JetEnUp_branch = the_tree.GetBranch("vbfMVA_JetEnUp")
        #if not self.vbfMVA_JetEnUp_branch and "vbfMVA_JetEnUp" not in self.complained:
        if not self.vbfMVA_JetEnUp_branch and "vbfMVA_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfMVA_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA_JetEnUp")
        else:
            self.vbfMVA_JetEnUp_branch.SetAddress(<void*>&self.vbfMVA_JetEnUp_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "EETauTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMass_JetEnDown"
        self.vbfMass_JetEnDown_branch = the_tree.GetBranch("vbfMass_JetEnDown")
        #if not self.vbfMass_JetEnDown_branch and "vbfMass_JetEnDown" not in self.complained:
        if not self.vbfMass_JetEnDown_branch and "vbfMass_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfMass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEnDown")
        else:
            self.vbfMass_JetEnDown_branch.SetAddress(<void*>&self.vbfMass_JetEnDown_value)

        #print "making vbfMass_JetEnUp"
        self.vbfMass_JetEnUp_branch = the_tree.GetBranch("vbfMass_JetEnUp")
        #if not self.vbfMass_JetEnUp_branch and "vbfMass_JetEnUp" not in self.complained:
        if not self.vbfMass_JetEnUp_branch and "vbfMass_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfMass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEnUp")
        else:
            self.vbfMass_JetEnUp_branch.SetAddress(<void*>&self.vbfMass_JetEnUp_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "EETauTree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets20_JetEnDown"
        self.vbfNJets20_JetEnDown_branch = the_tree.GetBranch("vbfNJets20_JetEnDown")
        #if not self.vbfNJets20_JetEnDown_branch and "vbfNJets20_JetEnDown" not in self.complained:
        if not self.vbfNJets20_JetEnDown_branch and "vbfNJets20_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfNJets20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20_JetEnDown")
        else:
            self.vbfNJets20_JetEnDown_branch.SetAddress(<void*>&self.vbfNJets20_JetEnDown_value)

        #print "making vbfNJets20_JetEnUp"
        self.vbfNJets20_JetEnUp_branch = the_tree.GetBranch("vbfNJets20_JetEnUp")
        #if not self.vbfNJets20_JetEnUp_branch and "vbfNJets20_JetEnUp" not in self.complained:
        if not self.vbfNJets20_JetEnUp_branch and "vbfNJets20_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfNJets20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20_JetEnUp")
        else:
            self.vbfNJets20_JetEnUp_branch.SetAddress(<void*>&self.vbfNJets20_JetEnUp_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "EETauTree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfNJets30_JetEnDown"
        self.vbfNJets30_JetEnDown_branch = the_tree.GetBranch("vbfNJets30_JetEnDown")
        #if not self.vbfNJets30_JetEnDown_branch and "vbfNJets30_JetEnDown" not in self.complained:
        if not self.vbfNJets30_JetEnDown_branch and "vbfNJets30_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfNJets30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30_JetEnDown")
        else:
            self.vbfNJets30_JetEnDown_branch.SetAddress(<void*>&self.vbfNJets30_JetEnDown_value)

        #print "making vbfNJets30_JetEnUp"
        self.vbfNJets30_JetEnUp_branch = the_tree.GetBranch("vbfNJets30_JetEnUp")
        #if not self.vbfNJets30_JetEnUp_branch and "vbfNJets30_JetEnUp" not in self.complained:
        if not self.vbfNJets30_JetEnUp_branch and "vbfNJets30_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfNJets30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30_JetEnUp")
        else:
            self.vbfNJets30_JetEnUp_branch.SetAddress(<void*>&self.vbfNJets30_JetEnUp_value)

        #print "making vbfVispt"
        self.vbfVispt_branch = the_tree.GetBranch("vbfVispt")
        #if not self.vbfVispt_branch and "vbfVispt" not in self.complained:
        if not self.vbfVispt_branch and "vbfVispt":
            warnings.warn( "EETauTree: Expected branch vbfVispt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt")
        else:
            self.vbfVispt_branch.SetAddress(<void*>&self.vbfVispt_value)

        #print "making vbfVispt_JetEnDown"
        self.vbfVispt_JetEnDown_branch = the_tree.GetBranch("vbfVispt_JetEnDown")
        #if not self.vbfVispt_JetEnDown_branch and "vbfVispt_JetEnDown" not in self.complained:
        if not self.vbfVispt_JetEnDown_branch and "vbfVispt_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfVispt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt_JetEnDown")
        else:
            self.vbfVispt_JetEnDown_branch.SetAddress(<void*>&self.vbfVispt_JetEnDown_value)

        #print "making vbfVispt_JetEnUp"
        self.vbfVispt_JetEnUp_branch = the_tree.GetBranch("vbfVispt_JetEnUp")
        #if not self.vbfVispt_JetEnUp_branch and "vbfVispt_JetEnUp" not in self.complained:
        if not self.vbfVispt_JetEnUp_branch and "vbfVispt_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfVispt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt_JetEnUp")
        else:
            self.vbfVispt_JetEnUp_branch.SetAddress(<void*>&self.vbfVispt_JetEnUp_value)

        #print "making vbfdijetpt"
        self.vbfdijetpt_branch = the_tree.GetBranch("vbfdijetpt")
        #if not self.vbfdijetpt_branch and "vbfdijetpt" not in self.complained:
        if not self.vbfdijetpt_branch and "vbfdijetpt":
            warnings.warn( "EETauTree: Expected branch vbfdijetpt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt")
        else:
            self.vbfdijetpt_branch.SetAddress(<void*>&self.vbfdijetpt_value)

        #print "making vbfdijetpt_JetEnDown"
        self.vbfdijetpt_JetEnDown_branch = the_tree.GetBranch("vbfdijetpt_JetEnDown")
        #if not self.vbfdijetpt_JetEnDown_branch and "vbfdijetpt_JetEnDown" not in self.complained:
        if not self.vbfdijetpt_JetEnDown_branch and "vbfdijetpt_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfdijetpt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt_JetEnDown")
        else:
            self.vbfdijetpt_JetEnDown_branch.SetAddress(<void*>&self.vbfdijetpt_JetEnDown_value)

        #print "making vbfdijetpt_JetEnUp"
        self.vbfdijetpt_JetEnUp_branch = the_tree.GetBranch("vbfdijetpt_JetEnUp")
        #if not self.vbfdijetpt_JetEnUp_branch and "vbfdijetpt_JetEnUp" not in self.complained:
        if not self.vbfdijetpt_JetEnUp_branch and "vbfdijetpt_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfdijetpt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt_JetEnUp")
        else:
            self.vbfdijetpt_JetEnUp_branch.SetAddress(<void*>&self.vbfdijetpt_JetEnUp_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "EETauTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1eta_JetEnDown"
        self.vbfj1eta_JetEnDown_branch = the_tree.GetBranch("vbfj1eta_JetEnDown")
        #if not self.vbfj1eta_JetEnDown_branch and "vbfj1eta_JetEnDown" not in self.complained:
        if not self.vbfj1eta_JetEnDown_branch and "vbfj1eta_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfj1eta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta_JetEnDown")
        else:
            self.vbfj1eta_JetEnDown_branch.SetAddress(<void*>&self.vbfj1eta_JetEnDown_value)

        #print "making vbfj1eta_JetEnUp"
        self.vbfj1eta_JetEnUp_branch = the_tree.GetBranch("vbfj1eta_JetEnUp")
        #if not self.vbfj1eta_JetEnUp_branch and "vbfj1eta_JetEnUp" not in self.complained:
        if not self.vbfj1eta_JetEnUp_branch and "vbfj1eta_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfj1eta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta_JetEnUp")
        else:
            self.vbfj1eta_JetEnUp_branch.SetAddress(<void*>&self.vbfj1eta_JetEnUp_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "EETauTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj1pt_JetEnDown"
        self.vbfj1pt_JetEnDown_branch = the_tree.GetBranch("vbfj1pt_JetEnDown")
        #if not self.vbfj1pt_JetEnDown_branch and "vbfj1pt_JetEnDown" not in self.complained:
        if not self.vbfj1pt_JetEnDown_branch and "vbfj1pt_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfj1pt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt_JetEnDown")
        else:
            self.vbfj1pt_JetEnDown_branch.SetAddress(<void*>&self.vbfj1pt_JetEnDown_value)

        #print "making vbfj1pt_JetEnUp"
        self.vbfj1pt_JetEnUp_branch = the_tree.GetBranch("vbfj1pt_JetEnUp")
        #if not self.vbfj1pt_JetEnUp_branch and "vbfj1pt_JetEnUp" not in self.complained:
        if not self.vbfj1pt_JetEnUp_branch and "vbfj1pt_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfj1pt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt_JetEnUp")
        else:
            self.vbfj1pt_JetEnUp_branch.SetAddress(<void*>&self.vbfj1pt_JetEnUp_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "EETauTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2eta_JetEnDown"
        self.vbfj2eta_JetEnDown_branch = the_tree.GetBranch("vbfj2eta_JetEnDown")
        #if not self.vbfj2eta_JetEnDown_branch and "vbfj2eta_JetEnDown" not in self.complained:
        if not self.vbfj2eta_JetEnDown_branch and "vbfj2eta_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfj2eta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta_JetEnDown")
        else:
            self.vbfj2eta_JetEnDown_branch.SetAddress(<void*>&self.vbfj2eta_JetEnDown_value)

        #print "making vbfj2eta_JetEnUp"
        self.vbfj2eta_JetEnUp_branch = the_tree.GetBranch("vbfj2eta_JetEnUp")
        #if not self.vbfj2eta_JetEnUp_branch and "vbfj2eta_JetEnUp" not in self.complained:
        if not self.vbfj2eta_JetEnUp_branch and "vbfj2eta_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfj2eta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta_JetEnUp")
        else:
            self.vbfj2eta_JetEnUp_branch.SetAddress(<void*>&self.vbfj2eta_JetEnUp_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "EETauTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vbfj2pt_JetEnDown"
        self.vbfj2pt_JetEnDown_branch = the_tree.GetBranch("vbfj2pt_JetEnDown")
        #if not self.vbfj2pt_JetEnDown_branch and "vbfj2pt_JetEnDown" not in self.complained:
        if not self.vbfj2pt_JetEnDown_branch and "vbfj2pt_JetEnDown":
            warnings.warn( "EETauTree: Expected branch vbfj2pt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt_JetEnDown")
        else:
            self.vbfj2pt_JetEnDown_branch.SetAddress(<void*>&self.vbfj2pt_JetEnDown_value)

        #print "making vbfj2pt_JetEnUp"
        self.vbfj2pt_JetEnUp_branch = the_tree.GetBranch("vbfj2pt_JetEnUp")
        #if not self.vbfj2pt_JetEnUp_branch and "vbfj2pt_JetEnUp" not in self.complained:
        if not self.vbfj2pt_JetEnUp_branch and "vbfj2pt_JetEnUp":
            warnings.warn( "EETauTree: Expected branch vbfj2pt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt_JetEnUp")
        else:
            self.vbfj2pt_JetEnUp_branch.SetAddress(<void*>&self.vbfj2pt_JetEnUp_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "EETauTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "EETauTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

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

    property e1AbsEta:
        def __get__(self):
            self.e1AbsEta_branch.GetEntry(self.localentry, 0)
            return self.e1AbsEta_value

    property e1CBIDLoose:
        def __get__(self):
            self.e1CBIDLoose_branch.GetEntry(self.localentry, 0)
            return self.e1CBIDLoose_value

    property e1CBIDLooseNoIso:
        def __get__(self):
            self.e1CBIDLooseNoIso_branch.GetEntry(self.localentry, 0)
            return self.e1CBIDLooseNoIso_value

    property e1CBIDMedium:
        def __get__(self):
            self.e1CBIDMedium_branch.GetEntry(self.localentry, 0)
            return self.e1CBIDMedium_value

    property e1CBIDMediumNoIso:
        def __get__(self):
            self.e1CBIDMediumNoIso_branch.GetEntry(self.localentry, 0)
            return self.e1CBIDMediumNoIso_value

    property e1CBIDTight:
        def __get__(self):
            self.e1CBIDTight_branch.GetEntry(self.localentry, 0)
            return self.e1CBIDTight_value

    property e1CBIDTightNoIso:
        def __get__(self):
            self.e1CBIDTightNoIso_branch.GetEntry(self.localentry, 0)
            return self.e1CBIDTightNoIso_value

    property e1CBIDVeto:
        def __get__(self):
            self.e1CBIDVeto_branch.GetEntry(self.localentry, 0)
            return self.e1CBIDVeto_value

    property e1CBIDVetoNoIso:
        def __get__(self):
            self.e1CBIDVetoNoIso_branch.GetEntry(self.localentry, 0)
            return self.e1CBIDVetoNoIso_value

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

    property e1ComesFromHiggs:
        def __get__(self):
            self.e1ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.e1ComesFromHiggs_value

    property e1DPhiToPfMet_type1:
        def __get__(self):
            self.e1DPhiToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.e1DPhiToPfMet_type1_value

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

    property e1EcalIsoDR03:
        def __get__(self):
            self.e1EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1EcalIsoDR03_value

    property e1EffectiveArea2012Data:
        def __get__(self):
            self.e1EffectiveArea2012Data_branch.GetEntry(self.localentry, 0)
            return self.e1EffectiveArea2012Data_value

    property e1EffectiveAreaSpring15:
        def __get__(self):
            self.e1EffectiveAreaSpring15_branch.GetEntry(self.localentry, 0)
            return self.e1EffectiveAreaSpring15_value

    property e1EnergyError:
        def __get__(self):
            self.e1EnergyError_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyError_value

    property e1ErsatzGenEta:
        def __get__(self):
            self.e1ErsatzGenEta_branch.GetEntry(self.localentry, 0)
            return self.e1ErsatzGenEta_value

    property e1ErsatzGenM:
        def __get__(self):
            self.e1ErsatzGenM_branch.GetEntry(self.localentry, 0)
            return self.e1ErsatzGenM_value

    property e1ErsatzGenPhi:
        def __get__(self):
            self.e1ErsatzGenPhi_branch.GetEntry(self.localentry, 0)
            return self.e1ErsatzGenPhi_value

    property e1ErsatzGenpT:
        def __get__(self):
            self.e1ErsatzGenpT_branch.GetEntry(self.localentry, 0)
            return self.e1ErsatzGenpT_value

    property e1ErsatzGenpX:
        def __get__(self):
            self.e1ErsatzGenpX_branch.GetEntry(self.localentry, 0)
            return self.e1ErsatzGenpX_value

    property e1ErsatzGenpY:
        def __get__(self):
            self.e1ErsatzGenpY_branch.GetEntry(self.localentry, 0)
            return self.e1ErsatzGenpY_value

    property e1ErsatzVispX:
        def __get__(self):
            self.e1ErsatzVispX_branch.GetEntry(self.localentry, 0)
            return self.e1ErsatzVispX_value

    property e1ErsatzVispY:
        def __get__(self):
            self.e1ErsatzVispY_branch.GetEntry(self.localentry, 0)
            return self.e1ErsatzVispY_value

    property e1Eta:
        def __get__(self):
            self.e1Eta_branch.GetEntry(self.localentry, 0)
            return self.e1Eta_value

    property e1Eta_ElectronEnDown:
        def __get__(self):
            self.e1Eta_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1Eta_ElectronEnDown_value

    property e1Eta_ElectronEnUp:
        def __get__(self):
            self.e1Eta_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1Eta_ElectronEnUp_value

    property e1GenCharge:
        def __get__(self):
            self.e1GenCharge_branch.GetEntry(self.localentry, 0)
            return self.e1GenCharge_value

    property e1GenDirectPromptTauDecay:
        def __get__(self):
            self.e1GenDirectPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e1GenDirectPromptTauDecay_value

    property e1GenEnergy:
        def __get__(self):
            self.e1GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1GenEnergy_value

    property e1GenEta:
        def __get__(self):
            self.e1GenEta_branch.GetEntry(self.localentry, 0)
            return self.e1GenEta_value

    property e1GenIsPrompt:
        def __get__(self):
            self.e1GenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.e1GenIsPrompt_value

    property e1GenMotherPdgId:
        def __get__(self):
            self.e1GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.e1GenMotherPdgId_value

    property e1GenParticle:
        def __get__(self):
            self.e1GenParticle_branch.GetEntry(self.localentry, 0)
            return self.e1GenParticle_value

    property e1GenPdgId:
        def __get__(self):
            self.e1GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.e1GenPdgId_value

    property e1GenPhi:
        def __get__(self):
            self.e1GenPhi_branch.GetEntry(self.localentry, 0)
            return self.e1GenPhi_value

    property e1GenPrompt:
        def __get__(self):
            self.e1GenPrompt_branch.GetEntry(self.localentry, 0)
            return self.e1GenPrompt_value

    property e1GenPromptTauDecay:
        def __get__(self):
            self.e1GenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e1GenPromptTauDecay_value

    property e1GenPt:
        def __get__(self):
            self.e1GenPt_branch.GetEntry(self.localentry, 0)
            return self.e1GenPt_value

    property e1GenTauDecay:
        def __get__(self):
            self.e1GenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e1GenTauDecay_value

    property e1GenVZ:
        def __get__(self):
            self.e1GenVZ_branch.GetEntry(self.localentry, 0)
            return self.e1GenVZ_value

    property e1GenVtxPVMatch:
        def __get__(self):
            self.e1GenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.e1GenVtxPVMatch_value

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

    property e1HcalIsoDR03:
        def __get__(self):
            self.e1HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1HcalIsoDR03_value

    property e1IP3D:
        def __get__(self):
            self.e1IP3D_branch.GetEntry(self.localentry, 0)
            return self.e1IP3D_value

    property e1IP3DErr:
        def __get__(self):
            self.e1IP3DErr_branch.GetEntry(self.localentry, 0)
            return self.e1IP3DErr_value

    property e1IsoDB03:
        def __get__(self):
            self.e1IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.e1IsoDB03_value

    property e1JetArea:
        def __get__(self):
            self.e1JetArea_branch.GetEntry(self.localentry, 0)
            return self.e1JetArea_value

    property e1JetBtag:
        def __get__(self):
            self.e1JetBtag_branch.GetEntry(self.localentry, 0)
            return self.e1JetBtag_value

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

    property e1JetHadronFlavour:
        def __get__(self):
            self.e1JetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.e1JetHadronFlavour_value

    property e1JetPFCISVBtag:
        def __get__(self):
            self.e1JetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.e1JetPFCISVBtag_value

    property e1JetPartonFlavour:
        def __get__(self):
            self.e1JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.e1JetPartonFlavour_value

    property e1JetPhiPhiMoment:
        def __get__(self):
            self.e1JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e1JetPhiPhiMoment_value

    property e1JetPt:
        def __get__(self):
            self.e1JetPt_branch.GetEntry(self.localentry, 0)
            return self.e1JetPt_value

    property e1LowestMll:
        def __get__(self):
            self.e1LowestMll_branch.GetEntry(self.localentry, 0)
            return self.e1LowestMll_value

    property e1MVANonTrigCategory:
        def __get__(self):
            self.e1MVANonTrigCategory_branch.GetEntry(self.localentry, 0)
            return self.e1MVANonTrigCategory_value

    property e1MVANonTrigID:
        def __get__(self):
            self.e1MVANonTrigID_branch.GetEntry(self.localentry, 0)
            return self.e1MVANonTrigID_value

    property e1MVANonTrigWP80:
        def __get__(self):
            self.e1MVANonTrigWP80_branch.GetEntry(self.localentry, 0)
            return self.e1MVANonTrigWP80_value

    property e1MVANonTrigWP90:
        def __get__(self):
            self.e1MVANonTrigWP90_branch.GetEntry(self.localentry, 0)
            return self.e1MVANonTrigWP90_value

    property e1MVATrigCategory:
        def __get__(self):
            self.e1MVATrigCategory_branch.GetEntry(self.localentry, 0)
            return self.e1MVATrigCategory_value

    property e1MVATrigID:
        def __get__(self):
            self.e1MVATrigID_branch.GetEntry(self.localentry, 0)
            return self.e1MVATrigID_value

    property e1MVATrigWP80:
        def __get__(self):
            self.e1MVATrigWP80_branch.GetEntry(self.localentry, 0)
            return self.e1MVATrigWP80_value

    property e1MVATrigWP90:
        def __get__(self):
            self.e1MVATrigWP90_branch.GetEntry(self.localentry, 0)
            return self.e1MVATrigWP90_value

    property e1Mass:
        def __get__(self):
            self.e1Mass_branch.GetEntry(self.localentry, 0)
            return self.e1Mass_value

    property e1MatchesDoubleE:
        def __get__(self):
            self.e1MatchesDoubleE_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesDoubleE_value

    property e1MatchesDoubleESingleMu:
        def __get__(self):
            self.e1MatchesDoubleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesDoubleESingleMu_value

    property e1MatchesDoubleMuSingleE:
        def __get__(self):
            self.e1MatchesDoubleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesDoubleMuSingleE_value

    property e1MatchesEle115Filter:
        def __get__(self):
            self.e1MatchesEle115Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle115Filter_value

    property e1MatchesEle115Path:
        def __get__(self):
            self.e1MatchesEle115Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle115Path_value

    property e1MatchesEle24Tau20Filter:
        def __get__(self):
            self.e1MatchesEle24Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle24Tau20Filter_value

    property e1MatchesEle24Tau20Path:
        def __get__(self):
            self.e1MatchesEle24Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle24Tau20Path_value

    property e1MatchesEle24Tau20sL1Filter:
        def __get__(self):
            self.e1MatchesEle24Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle24Tau20sL1Filter_value

    property e1MatchesEle24Tau20sL1Path:
        def __get__(self):
            self.e1MatchesEle24Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle24Tau20sL1Path_value

    property e1MatchesEle24Tau30Filter:
        def __get__(self):
            self.e1MatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle24Tau30Filter_value

    property e1MatchesEle24Tau30Path:
        def __get__(self):
            self.e1MatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle24Tau30Path_value

    property e1MatchesEle25LooseFilter:
        def __get__(self):
            self.e1MatchesEle25LooseFilter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle25LooseFilter_value

    property e1MatchesEle25TightFilter:
        def __get__(self):
            self.e1MatchesEle25TightFilter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle25TightFilter_value

    property e1MatchesEle25eta2p1TightFilter:
        def __get__(self):
            self.e1MatchesEle25eta2p1TightFilter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle25eta2p1TightFilter_value

    property e1MatchesEle25eta2p1TightPath:
        def __get__(self):
            self.e1MatchesEle25eta2p1TightPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle25eta2p1TightPath_value

    property e1MatchesEle27TightFilter:
        def __get__(self):
            self.e1MatchesEle27TightFilter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle27TightFilter_value

    property e1MatchesEle27TightPath:
        def __get__(self):
            self.e1MatchesEle27TightPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle27TightPath_value

    property e1MatchesEle27eta2p1LooseFilter:
        def __get__(self):
            self.e1MatchesEle27eta2p1LooseFilter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle27eta2p1LooseFilter_value

    property e1MatchesEle27eta2p1LoosePath:
        def __get__(self):
            self.e1MatchesEle27eta2p1LoosePath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle27eta2p1LoosePath_value

    property e1MatchesEle45L1JetTauPath:
        def __get__(self):
            self.e1MatchesEle45L1JetTauPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle45L1JetTauPath_value

    property e1MatchesEle45LooseL1JetTauFilter:
        def __get__(self):
            self.e1MatchesEle45LooseL1JetTauFilter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle45LooseL1JetTauFilter_value

    property e1MatchesMu23Ele12DZFilter:
        def __get__(self):
            self.e1MatchesMu23Ele12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu23Ele12DZFilter_value

    property e1MatchesMu23Ele12DZPath:
        def __get__(self):
            self.e1MatchesMu23Ele12DZPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu23Ele12DZPath_value

    property e1MatchesMu23Ele12Filter:
        def __get__(self):
            self.e1MatchesMu23Ele12Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu23Ele12Filter_value

    property e1MatchesMu23Ele12Path:
        def __get__(self):
            self.e1MatchesMu23Ele12Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu23Ele12Path_value

    property e1MatchesMu23Ele8DZFilter:
        def __get__(self):
            self.e1MatchesMu23Ele8DZFilter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu23Ele8DZFilter_value

    property e1MatchesMu23Ele8DZPath:
        def __get__(self):
            self.e1MatchesMu23Ele8DZPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu23Ele8DZPath_value

    property e1MatchesMu23Ele8Filter:
        def __get__(self):
            self.e1MatchesMu23Ele8Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu23Ele8Filter_value

    property e1MatchesMu23Ele8Path:
        def __get__(self):
            self.e1MatchesMu23Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu23Ele8Path_value

    property e1MatchesMu8Ele23DZFilter:
        def __get__(self):
            self.e1MatchesMu8Ele23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu8Ele23DZFilter_value

    property e1MatchesMu8Ele23DZPath:
        def __get__(self):
            self.e1MatchesMu8Ele23DZPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu8Ele23DZPath_value

    property e1MatchesMu8Ele23Filter:
        def __get__(self):
            self.e1MatchesMu8Ele23Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu8Ele23Filter_value

    property e1MatchesMu8Ele23Path:
        def __get__(self):
            self.e1MatchesMu8Ele23Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu8Ele23Path_value

    property e1MatchesSingleE:
        def __get__(self):
            self.e1MatchesSingleE_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesSingleE_value

    property e1MatchesSingleESingleMu:
        def __get__(self):
            self.e1MatchesSingleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesSingleESingleMu_value

    property e1MatchesSingleE_leg1:
        def __get__(self):
            self.e1MatchesSingleE_leg1_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesSingleE_leg1_value

    property e1MatchesSingleE_leg2:
        def __get__(self):
            self.e1MatchesSingleE_leg2_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesSingleE_leg2_value

    property e1MatchesSingleMuSingleE:
        def __get__(self):
            self.e1MatchesSingleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesSingleMuSingleE_value

    property e1MatchesTripleE:
        def __get__(self):
            self.e1MatchesTripleE_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesTripleE_value

    property e1MissingHits:
        def __get__(self):
            self.e1MissingHits_branch.GetEntry(self.localentry, 0)
            return self.e1MissingHits_value

    property e1MtToPfMet_type1:
        def __get__(self):
            self.e1MtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_type1_value

    property e1NearMuonVeto:
        def __get__(self):
            self.e1NearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.e1NearMuonVeto_value

    property e1NearestMuonDR:
        def __get__(self):
            self.e1NearestMuonDR_branch.GetEntry(self.localentry, 0)
            return self.e1NearestMuonDR_value

    property e1NearestZMass:
        def __get__(self):
            self.e1NearestZMass_branch.GetEntry(self.localentry, 0)
            return self.e1NearestZMass_value

    property e1PFChargedIso:
        def __get__(self):
            self.e1PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFChargedIso_value

    property e1PFNeutralIso:
        def __get__(self):
            self.e1PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFNeutralIso_value

    property e1PFPUChargedIso:
        def __get__(self):
            self.e1PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFPUChargedIso_value

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

    property e1PassesConversionVeto:
        def __get__(self):
            self.e1PassesConversionVeto_branch.GetEntry(self.localentry, 0)
            return self.e1PassesConversionVeto_value

    property e1Phi:
        def __get__(self):
            self.e1Phi_branch.GetEntry(self.localentry, 0)
            return self.e1Phi_value

    property e1Phi_ElectronEnDown:
        def __get__(self):
            self.e1Phi_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1Phi_ElectronEnDown_value

    property e1Phi_ElectronEnUp:
        def __get__(self):
            self.e1Phi_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1Phi_ElectronEnUp_value

    property e1Pt:
        def __get__(self):
            self.e1Pt_branch.GetEntry(self.localentry, 0)
            return self.e1Pt_value

    property e1Pt_ElectronEnDown:
        def __get__(self):
            self.e1Pt_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1Pt_ElectronEnDown_value

    property e1Pt_ElectronEnUp:
        def __get__(self):
            self.e1Pt_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1Pt_ElectronEnUp_value

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

    property e1Rho:
        def __get__(self):
            self.e1Rho_branch.GetEntry(self.localentry, 0)
            return self.e1Rho_value

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

    property e1SIP2D:
        def __get__(self):
            self.e1SIP2D_branch.GetEntry(self.localentry, 0)
            return self.e1SIP2D_value

    property e1SIP3D:
        def __get__(self):
            self.e1SIP3D_branch.GetEntry(self.localentry, 0)
            return self.e1SIP3D_value

    property e1SigmaIEtaIEta:
        def __get__(self):
            self.e1SigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.e1SigmaIEtaIEta_value

    property e1TrkIsoDR03:
        def __get__(self):
            self.e1TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1TrkIsoDR03_value

    property e1VZ:
        def __get__(self):
            self.e1VZ_branch.GetEntry(self.localentry, 0)
            return self.e1VZ_value

    property e1WWLoose:
        def __get__(self):
            self.e1WWLoose_branch.GetEntry(self.localentry, 0)
            return self.e1WWLoose_value

    property e1ZTTGenMatching:
        def __get__(self):
            self.e1ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.e1ZTTGenMatching_value

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

    property e1_e2_Eta:
        def __get__(self):
            self.e1_e2_Eta_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Eta_value

    property e1_e2_Mass:
        def __get__(self):
            self.e1_e2_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mass_value

    property e1_e2_Mass_TauEnDown:
        def __get__(self):
            self.e1_e2_Mass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mass_TauEnDown_value

    property e1_e2_Mass_TauEnUp:
        def __get__(self):
            self.e1_e2_Mass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mass_TauEnUp_value

    property e1_e2_Mt:
        def __get__(self):
            self.e1_e2_Mt_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mt_value

    property e1_e2_MtTotal:
        def __get__(self):
            self.e1_e2_MtTotal_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_MtTotal_value

    property e1_e2_Mt_TauEnDown:
        def __get__(self):
            self.e1_e2_Mt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mt_TauEnDown_value

    property e1_e2_Mt_TauEnUp:
        def __get__(self):
            self.e1_e2_Mt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mt_TauEnUp_value

    property e1_e2_MvaMet:
        def __get__(self):
            self.e1_e2_MvaMet_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_MvaMet_value

    property e1_e2_MvaMetCovMatrix00:
        def __get__(self):
            self.e1_e2_MvaMetCovMatrix00_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_MvaMetCovMatrix00_value

    property e1_e2_MvaMetCovMatrix01:
        def __get__(self):
            self.e1_e2_MvaMetCovMatrix01_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_MvaMetCovMatrix01_value

    property e1_e2_MvaMetCovMatrix10:
        def __get__(self):
            self.e1_e2_MvaMetCovMatrix10_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_MvaMetCovMatrix10_value

    property e1_e2_MvaMetCovMatrix11:
        def __get__(self):
            self.e1_e2_MvaMetCovMatrix11_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_MvaMetCovMatrix11_value

    property e1_e2_MvaMetPhi:
        def __get__(self):
            self.e1_e2_MvaMetPhi_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_MvaMetPhi_value

    property e1_e2_PZeta:
        def __get__(self):
            self.e1_e2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PZeta_value

    property e1_e2_PZetaLess0p85PZetaVis:
        def __get__(self):
            self.e1_e2_PZetaLess0p85PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PZetaLess0p85PZetaVis_value

    property e1_e2_PZetaVis:
        def __get__(self):
            self.e1_e2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PZetaVis_value

    property e1_e2_Phi:
        def __get__(self):
            self.e1_e2_Phi_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Phi_value

    property e1_e2_Pt:
        def __get__(self):
            self.e1_e2_Pt_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Pt_value

    property e1_e2_SS:
        def __get__(self):
            self.e1_e2_SS_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_SS_value

    property e1_e2_ToMETDPhi_Ty1:
        def __get__(self):
            self.e1_e2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_ToMETDPhi_Ty1_value

    property e1_e2_collinearmass:
        def __get__(self):
            self.e1_e2_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_value

    property e1_e2_collinearmass_CheckUESDown:
        def __get__(self):
            self.e1_e2_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_CheckUESDown_value

    property e1_e2_collinearmass_CheckUESUp:
        def __get__(self):
            self.e1_e2_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_CheckUESUp_value

    property e1_e2_collinearmass_EleEnDown:
        def __get__(self):
            self.e1_e2_collinearmass_EleEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_EleEnDown_value

    property e1_e2_collinearmass_EleEnUp:
        def __get__(self):
            self.e1_e2_collinearmass_EleEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_EleEnUp_value

    property e1_e2_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.e1_e2_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_JetCheckTotalDown_value

    property e1_e2_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.e1_e2_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_JetCheckTotalUp_value

    property e1_e2_collinearmass_JetEnDown:
        def __get__(self):
            self.e1_e2_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_JetEnDown_value

    property e1_e2_collinearmass_JetEnUp:
        def __get__(self):
            self.e1_e2_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_JetEnUp_value

    property e1_e2_collinearmass_MuEnDown:
        def __get__(self):
            self.e1_e2_collinearmass_MuEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_MuEnDown_value

    property e1_e2_collinearmass_MuEnUp:
        def __get__(self):
            self.e1_e2_collinearmass_MuEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_MuEnUp_value

    property e1_e2_collinearmass_TauEnDown:
        def __get__(self):
            self.e1_e2_collinearmass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_TauEnDown_value

    property e1_e2_collinearmass_TauEnUp:
        def __get__(self):
            self.e1_e2_collinearmass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_TauEnUp_value

    property e1_e2_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.e1_e2_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_UnclusteredEnDown_value

    property e1_e2_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.e1_e2_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_UnclusteredEnUp_value

    property e1_e2_pt_tt:
        def __get__(self):
            self.e1_e2_pt_tt_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_pt_tt_value

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

    property e1_t_Eta:
        def __get__(self):
            self.e1_t_Eta_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Eta_value

    property e1_t_Mass:
        def __get__(self):
            self.e1_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mass_value

    property e1_t_Mass_TauEnDown:
        def __get__(self):
            self.e1_t_Mass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mass_TauEnDown_value

    property e1_t_Mass_TauEnUp:
        def __get__(self):
            self.e1_t_Mass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mass_TauEnUp_value

    property e1_t_Mt:
        def __get__(self):
            self.e1_t_Mt_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mt_value

    property e1_t_MtTotal:
        def __get__(self):
            self.e1_t_MtTotal_branch.GetEntry(self.localentry, 0)
            return self.e1_t_MtTotal_value

    property e1_t_Mt_TauEnDown:
        def __get__(self):
            self.e1_t_Mt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mt_TauEnDown_value

    property e1_t_Mt_TauEnUp:
        def __get__(self):
            self.e1_t_Mt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mt_TauEnUp_value

    property e1_t_MvaMet:
        def __get__(self):
            self.e1_t_MvaMet_branch.GetEntry(self.localentry, 0)
            return self.e1_t_MvaMet_value

    property e1_t_MvaMetCovMatrix00:
        def __get__(self):
            self.e1_t_MvaMetCovMatrix00_branch.GetEntry(self.localentry, 0)
            return self.e1_t_MvaMetCovMatrix00_value

    property e1_t_MvaMetCovMatrix01:
        def __get__(self):
            self.e1_t_MvaMetCovMatrix01_branch.GetEntry(self.localentry, 0)
            return self.e1_t_MvaMetCovMatrix01_value

    property e1_t_MvaMetCovMatrix10:
        def __get__(self):
            self.e1_t_MvaMetCovMatrix10_branch.GetEntry(self.localentry, 0)
            return self.e1_t_MvaMetCovMatrix10_value

    property e1_t_MvaMetCovMatrix11:
        def __get__(self):
            self.e1_t_MvaMetCovMatrix11_branch.GetEntry(self.localentry, 0)
            return self.e1_t_MvaMetCovMatrix11_value

    property e1_t_MvaMetPhi:
        def __get__(self):
            self.e1_t_MvaMetPhi_branch.GetEntry(self.localentry, 0)
            return self.e1_t_MvaMetPhi_value

    property e1_t_PZeta:
        def __get__(self):
            self.e1_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_t_PZeta_value

    property e1_t_PZetaLess0p85PZetaVis:
        def __get__(self):
            self.e1_t_PZetaLess0p85PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_t_PZetaLess0p85PZetaVis_value

    property e1_t_PZetaVis:
        def __get__(self):
            self.e1_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_t_PZetaVis_value

    property e1_t_Phi:
        def __get__(self):
            self.e1_t_Phi_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Phi_value

    property e1_t_Pt:
        def __get__(self):
            self.e1_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Pt_value

    property e1_t_SS:
        def __get__(self):
            self.e1_t_SS_branch.GetEntry(self.localentry, 0)
            return self.e1_t_SS_value

    property e1_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.e1_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e1_t_ToMETDPhi_Ty1_value

    property e1_t_collinearmass:
        def __get__(self):
            self.e1_t_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_value

    property e1_t_collinearmass_CheckUESDown:
        def __get__(self):
            self.e1_t_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_CheckUESDown_value

    property e1_t_collinearmass_CheckUESUp:
        def __get__(self):
            self.e1_t_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_CheckUESUp_value

    property e1_t_collinearmass_EleEnDown:
        def __get__(self):
            self.e1_t_collinearmass_EleEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_EleEnDown_value

    property e1_t_collinearmass_EleEnUp:
        def __get__(self):
            self.e1_t_collinearmass_EleEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_EleEnUp_value

    property e1_t_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.e1_t_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_JetCheckTotalDown_value

    property e1_t_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.e1_t_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_JetCheckTotalUp_value

    property e1_t_collinearmass_JetEnDown:
        def __get__(self):
            self.e1_t_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_JetEnDown_value

    property e1_t_collinearmass_JetEnUp:
        def __get__(self):
            self.e1_t_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_JetEnUp_value

    property e1_t_collinearmass_MuEnDown:
        def __get__(self):
            self.e1_t_collinearmass_MuEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_MuEnDown_value

    property e1_t_collinearmass_MuEnUp:
        def __get__(self):
            self.e1_t_collinearmass_MuEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_MuEnUp_value

    property e1_t_collinearmass_TauEnDown:
        def __get__(self):
            self.e1_t_collinearmass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_TauEnDown_value

    property e1_t_collinearmass_TauEnUp:
        def __get__(self):
            self.e1_t_collinearmass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_TauEnUp_value

    property e1_t_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.e1_t_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_UnclusteredEnDown_value

    property e1_t_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.e1_t_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.e1_t_collinearmass_UnclusteredEnUp_value

    property e1_t_pt_tt:
        def __get__(self):
            self.e1_t_pt_tt_branch.GetEntry(self.localentry, 0)
            return self.e1_t_pt_tt_value

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

    property e2CBIDLoose:
        def __get__(self):
            self.e2CBIDLoose_branch.GetEntry(self.localentry, 0)
            return self.e2CBIDLoose_value

    property e2CBIDLooseNoIso:
        def __get__(self):
            self.e2CBIDLooseNoIso_branch.GetEntry(self.localentry, 0)
            return self.e2CBIDLooseNoIso_value

    property e2CBIDMedium:
        def __get__(self):
            self.e2CBIDMedium_branch.GetEntry(self.localentry, 0)
            return self.e2CBIDMedium_value

    property e2CBIDMediumNoIso:
        def __get__(self):
            self.e2CBIDMediumNoIso_branch.GetEntry(self.localentry, 0)
            return self.e2CBIDMediumNoIso_value

    property e2CBIDTight:
        def __get__(self):
            self.e2CBIDTight_branch.GetEntry(self.localentry, 0)
            return self.e2CBIDTight_value

    property e2CBIDTightNoIso:
        def __get__(self):
            self.e2CBIDTightNoIso_branch.GetEntry(self.localentry, 0)
            return self.e2CBIDTightNoIso_value

    property e2CBIDVeto:
        def __get__(self):
            self.e2CBIDVeto_branch.GetEntry(self.localentry, 0)
            return self.e2CBIDVeto_value

    property e2CBIDVetoNoIso:
        def __get__(self):
            self.e2CBIDVetoNoIso_branch.GetEntry(self.localentry, 0)
            return self.e2CBIDVetoNoIso_value

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

    property e2ComesFromHiggs:
        def __get__(self):
            self.e2ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.e2ComesFromHiggs_value

    property e2DPhiToPfMet_type1:
        def __get__(self):
            self.e2DPhiToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.e2DPhiToPfMet_type1_value

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

    property e2EcalIsoDR03:
        def __get__(self):
            self.e2EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2EcalIsoDR03_value

    property e2EffectiveArea2012Data:
        def __get__(self):
            self.e2EffectiveArea2012Data_branch.GetEntry(self.localentry, 0)
            return self.e2EffectiveArea2012Data_value

    property e2EffectiveAreaSpring15:
        def __get__(self):
            self.e2EffectiveAreaSpring15_branch.GetEntry(self.localentry, 0)
            return self.e2EffectiveAreaSpring15_value

    property e2EnergyError:
        def __get__(self):
            self.e2EnergyError_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyError_value

    property e2ErsatzGenEta:
        def __get__(self):
            self.e2ErsatzGenEta_branch.GetEntry(self.localentry, 0)
            return self.e2ErsatzGenEta_value

    property e2ErsatzGenM:
        def __get__(self):
            self.e2ErsatzGenM_branch.GetEntry(self.localentry, 0)
            return self.e2ErsatzGenM_value

    property e2ErsatzGenPhi:
        def __get__(self):
            self.e2ErsatzGenPhi_branch.GetEntry(self.localentry, 0)
            return self.e2ErsatzGenPhi_value

    property e2ErsatzGenpT:
        def __get__(self):
            self.e2ErsatzGenpT_branch.GetEntry(self.localentry, 0)
            return self.e2ErsatzGenpT_value

    property e2ErsatzGenpX:
        def __get__(self):
            self.e2ErsatzGenpX_branch.GetEntry(self.localentry, 0)
            return self.e2ErsatzGenpX_value

    property e2ErsatzGenpY:
        def __get__(self):
            self.e2ErsatzGenpY_branch.GetEntry(self.localentry, 0)
            return self.e2ErsatzGenpY_value

    property e2ErsatzVispX:
        def __get__(self):
            self.e2ErsatzVispX_branch.GetEntry(self.localentry, 0)
            return self.e2ErsatzVispX_value

    property e2ErsatzVispY:
        def __get__(self):
            self.e2ErsatzVispY_branch.GetEntry(self.localentry, 0)
            return self.e2ErsatzVispY_value

    property e2Eta:
        def __get__(self):
            self.e2Eta_branch.GetEntry(self.localentry, 0)
            return self.e2Eta_value

    property e2Eta_ElectronEnDown:
        def __get__(self):
            self.e2Eta_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.e2Eta_ElectronEnDown_value

    property e2Eta_ElectronEnUp:
        def __get__(self):
            self.e2Eta_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.e2Eta_ElectronEnUp_value

    property e2GenCharge:
        def __get__(self):
            self.e2GenCharge_branch.GetEntry(self.localentry, 0)
            return self.e2GenCharge_value

    property e2GenDirectPromptTauDecay:
        def __get__(self):
            self.e2GenDirectPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e2GenDirectPromptTauDecay_value

    property e2GenEnergy:
        def __get__(self):
            self.e2GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2GenEnergy_value

    property e2GenEta:
        def __get__(self):
            self.e2GenEta_branch.GetEntry(self.localentry, 0)
            return self.e2GenEta_value

    property e2GenIsPrompt:
        def __get__(self):
            self.e2GenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.e2GenIsPrompt_value

    property e2GenMotherPdgId:
        def __get__(self):
            self.e2GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.e2GenMotherPdgId_value

    property e2GenParticle:
        def __get__(self):
            self.e2GenParticle_branch.GetEntry(self.localentry, 0)
            return self.e2GenParticle_value

    property e2GenPdgId:
        def __get__(self):
            self.e2GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.e2GenPdgId_value

    property e2GenPhi:
        def __get__(self):
            self.e2GenPhi_branch.GetEntry(self.localentry, 0)
            return self.e2GenPhi_value

    property e2GenPrompt:
        def __get__(self):
            self.e2GenPrompt_branch.GetEntry(self.localentry, 0)
            return self.e2GenPrompt_value

    property e2GenPromptTauDecay:
        def __get__(self):
            self.e2GenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e2GenPromptTauDecay_value

    property e2GenPt:
        def __get__(self):
            self.e2GenPt_branch.GetEntry(self.localentry, 0)
            return self.e2GenPt_value

    property e2GenTauDecay:
        def __get__(self):
            self.e2GenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e2GenTauDecay_value

    property e2GenVZ:
        def __get__(self):
            self.e2GenVZ_branch.GetEntry(self.localentry, 0)
            return self.e2GenVZ_value

    property e2GenVtxPVMatch:
        def __get__(self):
            self.e2GenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.e2GenVtxPVMatch_value

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

    property e2HcalIsoDR03:
        def __get__(self):
            self.e2HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2HcalIsoDR03_value

    property e2IP3D:
        def __get__(self):
            self.e2IP3D_branch.GetEntry(self.localentry, 0)
            return self.e2IP3D_value

    property e2IP3DErr:
        def __get__(self):
            self.e2IP3DErr_branch.GetEntry(self.localentry, 0)
            return self.e2IP3DErr_value

    property e2IsoDB03:
        def __get__(self):
            self.e2IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.e2IsoDB03_value

    property e2JetArea:
        def __get__(self):
            self.e2JetArea_branch.GetEntry(self.localentry, 0)
            return self.e2JetArea_value

    property e2JetBtag:
        def __get__(self):
            self.e2JetBtag_branch.GetEntry(self.localentry, 0)
            return self.e2JetBtag_value

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

    property e2JetHadronFlavour:
        def __get__(self):
            self.e2JetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.e2JetHadronFlavour_value

    property e2JetPFCISVBtag:
        def __get__(self):
            self.e2JetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.e2JetPFCISVBtag_value

    property e2JetPartonFlavour:
        def __get__(self):
            self.e2JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.e2JetPartonFlavour_value

    property e2JetPhiPhiMoment:
        def __get__(self):
            self.e2JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e2JetPhiPhiMoment_value

    property e2JetPt:
        def __get__(self):
            self.e2JetPt_branch.GetEntry(self.localentry, 0)
            return self.e2JetPt_value

    property e2LowestMll:
        def __get__(self):
            self.e2LowestMll_branch.GetEntry(self.localentry, 0)
            return self.e2LowestMll_value

    property e2MVANonTrigCategory:
        def __get__(self):
            self.e2MVANonTrigCategory_branch.GetEntry(self.localentry, 0)
            return self.e2MVANonTrigCategory_value

    property e2MVANonTrigID:
        def __get__(self):
            self.e2MVANonTrigID_branch.GetEntry(self.localentry, 0)
            return self.e2MVANonTrigID_value

    property e2MVANonTrigWP80:
        def __get__(self):
            self.e2MVANonTrigWP80_branch.GetEntry(self.localentry, 0)
            return self.e2MVANonTrigWP80_value

    property e2MVANonTrigWP90:
        def __get__(self):
            self.e2MVANonTrigWP90_branch.GetEntry(self.localentry, 0)
            return self.e2MVANonTrigWP90_value

    property e2MVATrigCategory:
        def __get__(self):
            self.e2MVATrigCategory_branch.GetEntry(self.localentry, 0)
            return self.e2MVATrigCategory_value

    property e2MVATrigID:
        def __get__(self):
            self.e2MVATrigID_branch.GetEntry(self.localentry, 0)
            return self.e2MVATrigID_value

    property e2MVATrigWP80:
        def __get__(self):
            self.e2MVATrigWP80_branch.GetEntry(self.localentry, 0)
            return self.e2MVATrigWP80_value

    property e2MVATrigWP90:
        def __get__(self):
            self.e2MVATrigWP90_branch.GetEntry(self.localentry, 0)
            return self.e2MVATrigWP90_value

    property e2Mass:
        def __get__(self):
            self.e2Mass_branch.GetEntry(self.localentry, 0)
            return self.e2Mass_value

    property e2MatchesDoubleE:
        def __get__(self):
            self.e2MatchesDoubleE_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesDoubleE_value

    property e2MatchesDoubleESingleMu:
        def __get__(self):
            self.e2MatchesDoubleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesDoubleESingleMu_value

    property e2MatchesDoubleMuSingleE:
        def __get__(self):
            self.e2MatchesDoubleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesDoubleMuSingleE_value

    property e2MatchesEle115Filter:
        def __get__(self):
            self.e2MatchesEle115Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle115Filter_value

    property e2MatchesEle115Path:
        def __get__(self):
            self.e2MatchesEle115Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle115Path_value

    property e2MatchesEle24Tau20Filter:
        def __get__(self):
            self.e2MatchesEle24Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle24Tau20Filter_value

    property e2MatchesEle24Tau20Path:
        def __get__(self):
            self.e2MatchesEle24Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle24Tau20Path_value

    property e2MatchesEle24Tau20sL1Filter:
        def __get__(self):
            self.e2MatchesEle24Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle24Tau20sL1Filter_value

    property e2MatchesEle24Tau20sL1Path:
        def __get__(self):
            self.e2MatchesEle24Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle24Tau20sL1Path_value

    property e2MatchesEle24Tau30Filter:
        def __get__(self):
            self.e2MatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle24Tau30Filter_value

    property e2MatchesEle24Tau30Path:
        def __get__(self):
            self.e2MatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle24Tau30Path_value

    property e2MatchesEle25LooseFilter:
        def __get__(self):
            self.e2MatchesEle25LooseFilter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle25LooseFilter_value

    property e2MatchesEle25TightFilter:
        def __get__(self):
            self.e2MatchesEle25TightFilter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle25TightFilter_value

    property e2MatchesEle25eta2p1TightFilter:
        def __get__(self):
            self.e2MatchesEle25eta2p1TightFilter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle25eta2p1TightFilter_value

    property e2MatchesEle25eta2p1TightPath:
        def __get__(self):
            self.e2MatchesEle25eta2p1TightPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle25eta2p1TightPath_value

    property e2MatchesEle27TightFilter:
        def __get__(self):
            self.e2MatchesEle27TightFilter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle27TightFilter_value

    property e2MatchesEle27TightPath:
        def __get__(self):
            self.e2MatchesEle27TightPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle27TightPath_value

    property e2MatchesEle27eta2p1LooseFilter:
        def __get__(self):
            self.e2MatchesEle27eta2p1LooseFilter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle27eta2p1LooseFilter_value

    property e2MatchesEle27eta2p1LoosePath:
        def __get__(self):
            self.e2MatchesEle27eta2p1LoosePath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle27eta2p1LoosePath_value

    property e2MatchesEle45L1JetTauPath:
        def __get__(self):
            self.e2MatchesEle45L1JetTauPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle45L1JetTauPath_value

    property e2MatchesEle45LooseL1JetTauFilter:
        def __get__(self):
            self.e2MatchesEle45LooseL1JetTauFilter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle45LooseL1JetTauFilter_value

    property e2MatchesMu23Ele12DZFilter:
        def __get__(self):
            self.e2MatchesMu23Ele12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu23Ele12DZFilter_value

    property e2MatchesMu23Ele12DZPath:
        def __get__(self):
            self.e2MatchesMu23Ele12DZPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu23Ele12DZPath_value

    property e2MatchesMu23Ele12Filter:
        def __get__(self):
            self.e2MatchesMu23Ele12Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu23Ele12Filter_value

    property e2MatchesMu23Ele12Path:
        def __get__(self):
            self.e2MatchesMu23Ele12Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu23Ele12Path_value

    property e2MatchesMu23Ele8DZFilter:
        def __get__(self):
            self.e2MatchesMu23Ele8DZFilter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu23Ele8DZFilter_value

    property e2MatchesMu23Ele8DZPath:
        def __get__(self):
            self.e2MatchesMu23Ele8DZPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu23Ele8DZPath_value

    property e2MatchesMu23Ele8Filter:
        def __get__(self):
            self.e2MatchesMu23Ele8Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu23Ele8Filter_value

    property e2MatchesMu23Ele8Path:
        def __get__(self):
            self.e2MatchesMu23Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu23Ele8Path_value

    property e2MatchesMu8Ele23DZFilter:
        def __get__(self):
            self.e2MatchesMu8Ele23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu8Ele23DZFilter_value

    property e2MatchesMu8Ele23DZPath:
        def __get__(self):
            self.e2MatchesMu8Ele23DZPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu8Ele23DZPath_value

    property e2MatchesMu8Ele23Filter:
        def __get__(self):
            self.e2MatchesMu8Ele23Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu8Ele23Filter_value

    property e2MatchesMu8Ele23Path:
        def __get__(self):
            self.e2MatchesMu8Ele23Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu8Ele23Path_value

    property e2MatchesSingleE:
        def __get__(self):
            self.e2MatchesSingleE_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesSingleE_value

    property e2MatchesSingleESingleMu:
        def __get__(self):
            self.e2MatchesSingleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesSingleESingleMu_value

    property e2MatchesSingleE_leg1:
        def __get__(self):
            self.e2MatchesSingleE_leg1_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesSingleE_leg1_value

    property e2MatchesSingleE_leg2:
        def __get__(self):
            self.e2MatchesSingleE_leg2_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesSingleE_leg2_value

    property e2MatchesSingleMuSingleE:
        def __get__(self):
            self.e2MatchesSingleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesSingleMuSingleE_value

    property e2MatchesTripleE:
        def __get__(self):
            self.e2MatchesTripleE_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesTripleE_value

    property e2MissingHits:
        def __get__(self):
            self.e2MissingHits_branch.GetEntry(self.localentry, 0)
            return self.e2MissingHits_value

    property e2MtToPfMet_type1:
        def __get__(self):
            self.e2MtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_type1_value

    property e2NearMuonVeto:
        def __get__(self):
            self.e2NearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.e2NearMuonVeto_value

    property e2NearestMuonDR:
        def __get__(self):
            self.e2NearestMuonDR_branch.GetEntry(self.localentry, 0)
            return self.e2NearestMuonDR_value

    property e2NearestZMass:
        def __get__(self):
            self.e2NearestZMass_branch.GetEntry(self.localentry, 0)
            return self.e2NearestZMass_value

    property e2PFChargedIso:
        def __get__(self):
            self.e2PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFChargedIso_value

    property e2PFNeutralIso:
        def __get__(self):
            self.e2PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFNeutralIso_value

    property e2PFPUChargedIso:
        def __get__(self):
            self.e2PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFPUChargedIso_value

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

    property e2PassesConversionVeto:
        def __get__(self):
            self.e2PassesConversionVeto_branch.GetEntry(self.localentry, 0)
            return self.e2PassesConversionVeto_value

    property e2Phi:
        def __get__(self):
            self.e2Phi_branch.GetEntry(self.localentry, 0)
            return self.e2Phi_value

    property e2Phi_ElectronEnDown:
        def __get__(self):
            self.e2Phi_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.e2Phi_ElectronEnDown_value

    property e2Phi_ElectronEnUp:
        def __get__(self):
            self.e2Phi_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.e2Phi_ElectronEnUp_value

    property e2Pt:
        def __get__(self):
            self.e2Pt_branch.GetEntry(self.localentry, 0)
            return self.e2Pt_value

    property e2Pt_ElectronEnDown:
        def __get__(self):
            self.e2Pt_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.e2Pt_ElectronEnDown_value

    property e2Pt_ElectronEnUp:
        def __get__(self):
            self.e2Pt_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.e2Pt_ElectronEnUp_value

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

    property e2Rho:
        def __get__(self):
            self.e2Rho_branch.GetEntry(self.localentry, 0)
            return self.e2Rho_value

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

    property e2SIP2D:
        def __get__(self):
            self.e2SIP2D_branch.GetEntry(self.localentry, 0)
            return self.e2SIP2D_value

    property e2SIP3D:
        def __get__(self):
            self.e2SIP3D_branch.GetEntry(self.localentry, 0)
            return self.e2SIP3D_value

    property e2SigmaIEtaIEta:
        def __get__(self):
            self.e2SigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.e2SigmaIEtaIEta_value

    property e2TrkIsoDR03:
        def __get__(self):
            self.e2TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2TrkIsoDR03_value

    property e2VZ:
        def __get__(self):
            self.e2VZ_branch.GetEntry(self.localentry, 0)
            return self.e2VZ_value

    property e2WWLoose:
        def __get__(self):
            self.e2WWLoose_branch.GetEntry(self.localentry, 0)
            return self.e2WWLoose_value

    property e2ZTTGenMatching:
        def __get__(self):
            self.e2ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.e2ZTTGenMatching_value

    property e2_e1_collinearmass:
        def __get__(self):
            self.e2_e1_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.e2_e1_collinearmass_value

    property e2_e1_collinearmass_CheckUESDown:
        def __get__(self):
            self.e2_e1_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.e2_e1_collinearmass_CheckUESDown_value

    property e2_e1_collinearmass_CheckUESUp:
        def __get__(self):
            self.e2_e1_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.e2_e1_collinearmass_CheckUESUp_value

    property e2_e1_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.e2_e1_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.e2_e1_collinearmass_JetCheckTotalDown_value

    property e2_e1_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.e2_e1_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.e2_e1_collinearmass_JetCheckTotalUp_value

    property e2_e1_collinearmass_JetEnDown:
        def __get__(self):
            self.e2_e1_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.e2_e1_collinearmass_JetEnDown_value

    property e2_e1_collinearmass_JetEnUp:
        def __get__(self):
            self.e2_e1_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.e2_e1_collinearmass_JetEnUp_value

    property e2_e1_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.e2_e1_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.e2_e1_collinearmass_UnclusteredEnDown_value

    property e2_e1_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.e2_e1_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.e2_e1_collinearmass_UnclusteredEnUp_value

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

    property e2_t_Eta:
        def __get__(self):
            self.e2_t_Eta_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Eta_value

    property e2_t_Mass:
        def __get__(self):
            self.e2_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mass_value

    property e2_t_Mass_TauEnDown:
        def __get__(self):
            self.e2_t_Mass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mass_TauEnDown_value

    property e2_t_Mass_TauEnUp:
        def __get__(self):
            self.e2_t_Mass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mass_TauEnUp_value

    property e2_t_Mt:
        def __get__(self):
            self.e2_t_Mt_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mt_value

    property e2_t_MtTotal:
        def __get__(self):
            self.e2_t_MtTotal_branch.GetEntry(self.localentry, 0)
            return self.e2_t_MtTotal_value

    property e2_t_Mt_TauEnDown:
        def __get__(self):
            self.e2_t_Mt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mt_TauEnDown_value

    property e2_t_Mt_TauEnUp:
        def __get__(self):
            self.e2_t_Mt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mt_TauEnUp_value

    property e2_t_MvaMet:
        def __get__(self):
            self.e2_t_MvaMet_branch.GetEntry(self.localentry, 0)
            return self.e2_t_MvaMet_value

    property e2_t_MvaMetCovMatrix00:
        def __get__(self):
            self.e2_t_MvaMetCovMatrix00_branch.GetEntry(self.localentry, 0)
            return self.e2_t_MvaMetCovMatrix00_value

    property e2_t_MvaMetCovMatrix01:
        def __get__(self):
            self.e2_t_MvaMetCovMatrix01_branch.GetEntry(self.localentry, 0)
            return self.e2_t_MvaMetCovMatrix01_value

    property e2_t_MvaMetCovMatrix10:
        def __get__(self):
            self.e2_t_MvaMetCovMatrix10_branch.GetEntry(self.localentry, 0)
            return self.e2_t_MvaMetCovMatrix10_value

    property e2_t_MvaMetCovMatrix11:
        def __get__(self):
            self.e2_t_MvaMetCovMatrix11_branch.GetEntry(self.localentry, 0)
            return self.e2_t_MvaMetCovMatrix11_value

    property e2_t_MvaMetPhi:
        def __get__(self):
            self.e2_t_MvaMetPhi_branch.GetEntry(self.localentry, 0)
            return self.e2_t_MvaMetPhi_value

    property e2_t_PZeta:
        def __get__(self):
            self.e2_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e2_t_PZeta_value

    property e2_t_PZetaLess0p85PZetaVis:
        def __get__(self):
            self.e2_t_PZetaLess0p85PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e2_t_PZetaLess0p85PZetaVis_value

    property e2_t_PZetaVis:
        def __get__(self):
            self.e2_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e2_t_PZetaVis_value

    property e2_t_Phi:
        def __get__(self):
            self.e2_t_Phi_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Phi_value

    property e2_t_Pt:
        def __get__(self):
            self.e2_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Pt_value

    property e2_t_SS:
        def __get__(self):
            self.e2_t_SS_branch.GetEntry(self.localentry, 0)
            return self.e2_t_SS_value

    property e2_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.e2_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e2_t_ToMETDPhi_Ty1_value

    property e2_t_collinearmass:
        def __get__(self):
            self.e2_t_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_value

    property e2_t_collinearmass_CheckUESDown:
        def __get__(self):
            self.e2_t_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_CheckUESDown_value

    property e2_t_collinearmass_CheckUESUp:
        def __get__(self):
            self.e2_t_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_CheckUESUp_value

    property e2_t_collinearmass_EleEnDown:
        def __get__(self):
            self.e2_t_collinearmass_EleEnDown_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_EleEnDown_value

    property e2_t_collinearmass_EleEnUp:
        def __get__(self):
            self.e2_t_collinearmass_EleEnUp_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_EleEnUp_value

    property e2_t_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.e2_t_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_JetCheckTotalDown_value

    property e2_t_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.e2_t_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_JetCheckTotalUp_value

    property e2_t_collinearmass_JetEnDown:
        def __get__(self):
            self.e2_t_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_JetEnDown_value

    property e2_t_collinearmass_JetEnUp:
        def __get__(self):
            self.e2_t_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_JetEnUp_value

    property e2_t_collinearmass_MuEnDown:
        def __get__(self):
            self.e2_t_collinearmass_MuEnDown_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_MuEnDown_value

    property e2_t_collinearmass_MuEnUp:
        def __get__(self):
            self.e2_t_collinearmass_MuEnUp_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_MuEnUp_value

    property e2_t_collinearmass_TauEnDown:
        def __get__(self):
            self.e2_t_collinearmass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_TauEnDown_value

    property e2_t_collinearmass_TauEnUp:
        def __get__(self):
            self.e2_t_collinearmass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_TauEnUp_value

    property e2_t_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.e2_t_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_UnclusteredEnDown_value

    property e2_t_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.e2_t_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.e2_t_collinearmass_UnclusteredEnUp_value

    property e2_t_pt_tt:
        def __get__(self):
            self.e2_t_pt_tt_branch.GetEntry(self.localentry, 0)
            return self.e2_t_pt_tt_value

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

    property tGenIsPrompt:
        def __get__(self):
            self.tGenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.tGenIsPrompt_value

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

    property tJetHadronFlavour:
        def __get__(self):
            self.tJetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.tJetHadronFlavour_value

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

    property tMatchesDoubleTau32Filter:
        def __get__(self):
            self.tMatchesDoubleTau32Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTau32Filter_value

    property tMatchesDoubleTau32Path:
        def __get__(self):
            self.tMatchesDoubleTau32Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTau32Path_value

    property tMatchesDoubleTau35Filter:
        def __get__(self):
            self.tMatchesDoubleTau35Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTau35Filter_value

    property tMatchesDoubleTau35Path:
        def __get__(self):
            self.tMatchesDoubleTau35Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTau35Path_value

    property tMatchesDoubleTau40Filter:
        def __get__(self):
            self.tMatchesDoubleTau40Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTau40Filter_value

    property tMatchesDoubleTau40Path:
        def __get__(self):
            self.tMatchesDoubleTau40Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTau40Path_value

    property tMatchesDoubleTauCmbIso35RegFilter:
        def __get__(self):
            self.tMatchesDoubleTauCmbIso35RegFilter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTauCmbIso35RegFilter_value

    property tMatchesDoubleTauCmbIso35RegPath:
        def __get__(self):
            self.tMatchesDoubleTauCmbIso35RegPath_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTauCmbIso35RegPath_value

    property tMatchesDoubleTauCmbIso40Filter:
        def __get__(self):
            self.tMatchesDoubleTauCmbIso40Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTauCmbIso40Filter_value

    property tMatchesDoubleTauCmbIso40Path:
        def __get__(self):
            self.tMatchesDoubleTauCmbIso40Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTauCmbIso40Path_value

    property tMatchesDoubleTauCmbIso40RegFilter:
        def __get__(self):
            self.tMatchesDoubleTauCmbIso40RegFilter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTauCmbIso40RegFilter_value

    property tMatchesDoubleTauCmbIso40RegPath:
        def __get__(self):
            self.tMatchesDoubleTauCmbIso40RegPath_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTauCmbIso40RegPath_value

    property tMatchesEle24Tau20Filter:
        def __get__(self):
            self.tMatchesEle24Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau20Filter_value

    property tMatchesEle24Tau20L1Path:
        def __get__(self):
            self.tMatchesEle24Tau20L1Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau20L1Path_value

    property tMatchesEle24Tau20Path:
        def __get__(self):
            self.tMatchesEle24Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau20Path_value

    property tMatchesEle24Tau20sL1Filter:
        def __get__(self):
            self.tMatchesEle24Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau20sL1Filter_value

    property tMatchesEle24Tau30Filter:
        def __get__(self):
            self.tMatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau30Filter_value

    property tMatchesEle24Tau30Path:
        def __get__(self):
            self.tMatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau30Path_value

    property tMatchesMu19Tau20Filter:
        def __get__(self):
            self.tMatchesMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesMu19Tau20Filter_value

    property tMatchesMu19Tau20Path:
        def __get__(self):
            self.tMatchesMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesMu19Tau20Path_value

    property tMatchesMu19Tau20sL1Filter:
        def __get__(self):
            self.tMatchesMu19Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesMu19Tau20sL1Filter_value

    property tMatchesMu19Tau20sL1Path:
        def __get__(self):
            self.tMatchesMu19Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesMu19Tau20sL1Path_value

    property tMatchesMu21Tau20sL1Filter:
        def __get__(self):
            self.tMatchesMu21Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesMu21Tau20sL1Filter_value

    property tMatchesMu21Tau20sL1Path:
        def __get__(self):
            self.tMatchesMu21Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesMu21Tau20sL1Path_value

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

    property tNChrgHadrIsolationCands:
        def __get__(self):
            self.tNChrgHadrIsolationCands_branch.GetEntry(self.localentry, 0)
            return self.tNChrgHadrIsolationCands_value

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

    property tRerunMVArun2v1DBoldDMwLTLoose:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTLoose_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTLoose_value

    property tRerunMVArun2v1DBoldDMwLTMedium:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTMedium_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTMedium_value

    property tRerunMVArun2v1DBoldDMwLTTight:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTTight_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTTight_value

    property tRerunMVArun2v1DBoldDMwLTVLoose:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTVLoose_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTVLoose_value

    property tRerunMVArun2v1DBoldDMwLTVTight:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTVTight_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTVTight_value

    property tRerunMVArun2v1DBoldDMwLTVVTight:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTVVTight_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTVVTight_value

    property tRerunMVArun2v1DBoldDMwLTraw:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTraw_value

    property tVZ:
        def __get__(self):
            self.tVZ_branch.GetEntry(self.localentry, 0)
            return self.tVZ_value

    property tZTTGenDR:
        def __get__(self):
            self.tZTTGenDR_branch.GetEntry(self.localentry, 0)
            return self.tZTTGenDR_value

    property tZTTGenEta:
        def __get__(self):
            self.tZTTGenEta_branch.GetEntry(self.localentry, 0)
            return self.tZTTGenEta_value

    property tZTTGenMatching:
        def __get__(self):
            self.tZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.tZTTGenMatching_value

    property tZTTGenPhi:
        def __get__(self):
            self.tZTTGenPhi_branch.GetEntry(self.localentry, 0)
            return self.tZTTGenPhi_value

    property tZTTGenPt:
        def __get__(self):
            self.tZTTGenPt_branch.GetEntry(self.localentry, 0)
            return self.tZTTGenPt_value

    property t_e1_collinearmass:
        def __get__(self):
            self.t_e1_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.t_e1_collinearmass_value

    property t_e1_collinearmass_CheckUESDown:
        def __get__(self):
            self.t_e1_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.t_e1_collinearmass_CheckUESDown_value

    property t_e1_collinearmass_CheckUESUp:
        def __get__(self):
            self.t_e1_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.t_e1_collinearmass_CheckUESUp_value

    property t_e1_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.t_e1_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.t_e1_collinearmass_JetCheckTotalDown_value

    property t_e1_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.t_e1_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.t_e1_collinearmass_JetCheckTotalUp_value

    property t_e1_collinearmass_JetEnDown:
        def __get__(self):
            self.t_e1_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.t_e1_collinearmass_JetEnDown_value

    property t_e1_collinearmass_JetEnUp:
        def __get__(self):
            self.t_e1_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.t_e1_collinearmass_JetEnUp_value

    property t_e1_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.t_e1_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.t_e1_collinearmass_UnclusteredEnDown_value

    property t_e1_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.t_e1_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.t_e1_collinearmass_UnclusteredEnUp_value

    property t_e2_collinearmass:
        def __get__(self):
            self.t_e2_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.t_e2_collinearmass_value

    property t_e2_collinearmass_CheckUESDown:
        def __get__(self):
            self.t_e2_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.t_e2_collinearmass_CheckUESDown_value

    property t_e2_collinearmass_CheckUESUp:
        def __get__(self):
            self.t_e2_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.t_e2_collinearmass_CheckUESUp_value

    property t_e2_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.t_e2_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.t_e2_collinearmass_JetCheckTotalDown_value

    property t_e2_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.t_e2_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.t_e2_collinearmass_JetCheckTotalUp_value

    property t_e2_collinearmass_JetEnDown:
        def __get__(self):
            self.t_e2_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.t_e2_collinearmass_JetEnDown_value

    property t_e2_collinearmass_JetEnUp:
        def __get__(self):
            self.t_e2_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.t_e2_collinearmass_JetEnUp_value

    property t_e2_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.t_e2_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.t_e2_collinearmass_UnclusteredEnDown_value

    property t_e2_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.t_e2_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.t_e2_collinearmass_UnclusteredEnUp_value

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


