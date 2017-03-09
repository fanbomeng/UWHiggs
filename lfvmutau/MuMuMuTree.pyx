

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

cdef class MuMuMuTree:
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

    cdef TBranch* m1DPhiToPfMet_ElectronEnDown_branch
    cdef float m1DPhiToPfMet_ElectronEnDown_value

    cdef TBranch* m1DPhiToPfMet_ElectronEnUp_branch
    cdef float m1DPhiToPfMet_ElectronEnUp_value

    cdef TBranch* m1DPhiToPfMet_JetEnDown_branch
    cdef float m1DPhiToPfMet_JetEnDown_value

    cdef TBranch* m1DPhiToPfMet_JetEnUp_branch
    cdef float m1DPhiToPfMet_JetEnUp_value

    cdef TBranch* m1DPhiToPfMet_JetResDown_branch
    cdef float m1DPhiToPfMet_JetResDown_value

    cdef TBranch* m1DPhiToPfMet_JetResUp_branch
    cdef float m1DPhiToPfMet_JetResUp_value

    cdef TBranch* m1DPhiToPfMet_MuonEnDown_branch
    cdef float m1DPhiToPfMet_MuonEnDown_value

    cdef TBranch* m1DPhiToPfMet_MuonEnUp_branch
    cdef float m1DPhiToPfMet_MuonEnUp_value

    cdef TBranch* m1DPhiToPfMet_PhotonEnDown_branch
    cdef float m1DPhiToPfMet_PhotonEnDown_value

    cdef TBranch* m1DPhiToPfMet_PhotonEnUp_branch
    cdef float m1DPhiToPfMet_PhotonEnUp_value

    cdef TBranch* m1DPhiToPfMet_TauEnDown_branch
    cdef float m1DPhiToPfMet_TauEnDown_value

    cdef TBranch* m1DPhiToPfMet_TauEnUp_branch
    cdef float m1DPhiToPfMet_TauEnUp_value

    cdef TBranch* m1DPhiToPfMet_UnclusteredEnDown_branch
    cdef float m1DPhiToPfMet_UnclusteredEnDown_value

    cdef TBranch* m1DPhiToPfMet_UnclusteredEnUp_branch
    cdef float m1DPhiToPfMet_UnclusteredEnUp_value

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

    cdef TBranch* m1MatchesMu23Ele12Path_branch
    cdef float m1MatchesMu23Ele12Path_value

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

    cdef TBranch* m1MtToPfMet_ElectronEnDown_branch
    cdef float m1MtToPfMet_ElectronEnDown_value

    cdef TBranch* m1MtToPfMet_ElectronEnUp_branch
    cdef float m1MtToPfMet_ElectronEnUp_value

    cdef TBranch* m1MtToPfMet_JetEnDown_branch
    cdef float m1MtToPfMet_JetEnDown_value

    cdef TBranch* m1MtToPfMet_JetEnUp_branch
    cdef float m1MtToPfMet_JetEnUp_value

    cdef TBranch* m1MtToPfMet_JetResDown_branch
    cdef float m1MtToPfMet_JetResDown_value

    cdef TBranch* m1MtToPfMet_JetResUp_branch
    cdef float m1MtToPfMet_JetResUp_value

    cdef TBranch* m1MtToPfMet_MuonEnDown_branch
    cdef float m1MtToPfMet_MuonEnDown_value

    cdef TBranch* m1MtToPfMet_MuonEnUp_branch
    cdef float m1MtToPfMet_MuonEnUp_value

    cdef TBranch* m1MtToPfMet_PhotonEnDown_branch
    cdef float m1MtToPfMet_PhotonEnDown_value

    cdef TBranch* m1MtToPfMet_PhotonEnUp_branch
    cdef float m1MtToPfMet_PhotonEnUp_value

    cdef TBranch* m1MtToPfMet_Raw_branch
    cdef float m1MtToPfMet_Raw_value

    cdef TBranch* m1MtToPfMet_TauEnDown_branch
    cdef float m1MtToPfMet_TauEnDown_value

    cdef TBranch* m1MtToPfMet_TauEnUp_branch
    cdef float m1MtToPfMet_TauEnUp_value

    cdef TBranch* m1MtToPfMet_UnclusteredEnDown_branch
    cdef float m1MtToPfMet_UnclusteredEnDown_value

    cdef TBranch* m1MtToPfMet_UnclusteredEnUp_branch
    cdef float m1MtToPfMet_UnclusteredEnUp_value

    cdef TBranch* m1MtToPfMet_type1_branch
    cdef float m1MtToPfMet_type1_value

    cdef TBranch* m1Mu23Ele12Filter_branch
    cdef float m1Mu23Ele12Filter_value

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

    cdef TBranch* m1_m2_collinearmass_EleEnDown_branch
    cdef float m1_m2_collinearmass_EleEnDown_value

    cdef TBranch* m1_m2_collinearmass_EleEnUp_branch
    cdef float m1_m2_collinearmass_EleEnUp_value

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

    cdef TBranch* m1_m3_CosThetaStar_branch
    cdef float m1_m3_CosThetaStar_value

    cdef TBranch* m1_m3_DPhi_branch
    cdef float m1_m3_DPhi_value

    cdef TBranch* m1_m3_DR_branch
    cdef float m1_m3_DR_value

    cdef TBranch* m1_m3_Eta_branch
    cdef float m1_m3_Eta_value

    cdef TBranch* m1_m3_Mass_branch
    cdef float m1_m3_Mass_value

    cdef TBranch* m1_m3_Mass_TauEnDown_branch
    cdef float m1_m3_Mass_TauEnDown_value

    cdef TBranch* m1_m3_Mass_TauEnUp_branch
    cdef float m1_m3_Mass_TauEnUp_value

    cdef TBranch* m1_m3_Mt_branch
    cdef float m1_m3_Mt_value

    cdef TBranch* m1_m3_MtTotal_branch
    cdef float m1_m3_MtTotal_value

    cdef TBranch* m1_m3_Mt_TauEnDown_branch
    cdef float m1_m3_Mt_TauEnDown_value

    cdef TBranch* m1_m3_Mt_TauEnUp_branch
    cdef float m1_m3_Mt_TauEnUp_value

    cdef TBranch* m1_m3_MvaMet_branch
    cdef float m1_m3_MvaMet_value

    cdef TBranch* m1_m3_MvaMetCovMatrix00_branch
    cdef float m1_m3_MvaMetCovMatrix00_value

    cdef TBranch* m1_m3_MvaMetCovMatrix01_branch
    cdef float m1_m3_MvaMetCovMatrix01_value

    cdef TBranch* m1_m3_MvaMetCovMatrix10_branch
    cdef float m1_m3_MvaMetCovMatrix10_value

    cdef TBranch* m1_m3_MvaMetCovMatrix11_branch
    cdef float m1_m3_MvaMetCovMatrix11_value

    cdef TBranch* m1_m3_MvaMetPhi_branch
    cdef float m1_m3_MvaMetPhi_value

    cdef TBranch* m1_m3_PZeta_branch
    cdef float m1_m3_PZeta_value

    cdef TBranch* m1_m3_PZetaLess0p85PZetaVis_branch
    cdef float m1_m3_PZetaLess0p85PZetaVis_value

    cdef TBranch* m1_m3_PZetaVis_branch
    cdef float m1_m3_PZetaVis_value

    cdef TBranch* m1_m3_Phi_branch
    cdef float m1_m3_Phi_value

    cdef TBranch* m1_m3_Pt_branch
    cdef float m1_m3_Pt_value

    cdef TBranch* m1_m3_SS_branch
    cdef float m1_m3_SS_value

    cdef TBranch* m1_m3_ToMETDPhi_Ty1_branch
    cdef float m1_m3_ToMETDPhi_Ty1_value

    cdef TBranch* m1_m3_collinearmass_branch
    cdef float m1_m3_collinearmass_value

    cdef TBranch* m1_m3_collinearmass_EleEnDown_branch
    cdef float m1_m3_collinearmass_EleEnDown_value

    cdef TBranch* m1_m3_collinearmass_EleEnUp_branch
    cdef float m1_m3_collinearmass_EleEnUp_value

    cdef TBranch* m1_m3_collinearmass_JetEnDown_branch
    cdef float m1_m3_collinearmass_JetEnDown_value

    cdef TBranch* m1_m3_collinearmass_JetEnUp_branch
    cdef float m1_m3_collinearmass_JetEnUp_value

    cdef TBranch* m1_m3_collinearmass_MuEnDown_branch
    cdef float m1_m3_collinearmass_MuEnDown_value

    cdef TBranch* m1_m3_collinearmass_MuEnUp_branch
    cdef float m1_m3_collinearmass_MuEnUp_value

    cdef TBranch* m1_m3_collinearmass_TauEnDown_branch
    cdef float m1_m3_collinearmass_TauEnDown_value

    cdef TBranch* m1_m3_collinearmass_TauEnUp_branch
    cdef float m1_m3_collinearmass_TauEnUp_value

    cdef TBranch* m1_m3_collinearmass_UnclusteredEnDown_branch
    cdef float m1_m3_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m1_m3_collinearmass_UnclusteredEnUp_branch
    cdef float m1_m3_collinearmass_UnclusteredEnUp_value

    cdef TBranch* m1_m3_pt_tt_branch
    cdef float m1_m3_pt_tt_value

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

    cdef TBranch* m2DPhiToPfMet_ElectronEnDown_branch
    cdef float m2DPhiToPfMet_ElectronEnDown_value

    cdef TBranch* m2DPhiToPfMet_ElectronEnUp_branch
    cdef float m2DPhiToPfMet_ElectronEnUp_value

    cdef TBranch* m2DPhiToPfMet_JetEnDown_branch
    cdef float m2DPhiToPfMet_JetEnDown_value

    cdef TBranch* m2DPhiToPfMet_JetEnUp_branch
    cdef float m2DPhiToPfMet_JetEnUp_value

    cdef TBranch* m2DPhiToPfMet_JetResDown_branch
    cdef float m2DPhiToPfMet_JetResDown_value

    cdef TBranch* m2DPhiToPfMet_JetResUp_branch
    cdef float m2DPhiToPfMet_JetResUp_value

    cdef TBranch* m2DPhiToPfMet_MuonEnDown_branch
    cdef float m2DPhiToPfMet_MuonEnDown_value

    cdef TBranch* m2DPhiToPfMet_MuonEnUp_branch
    cdef float m2DPhiToPfMet_MuonEnUp_value

    cdef TBranch* m2DPhiToPfMet_PhotonEnDown_branch
    cdef float m2DPhiToPfMet_PhotonEnDown_value

    cdef TBranch* m2DPhiToPfMet_PhotonEnUp_branch
    cdef float m2DPhiToPfMet_PhotonEnUp_value

    cdef TBranch* m2DPhiToPfMet_TauEnDown_branch
    cdef float m2DPhiToPfMet_TauEnDown_value

    cdef TBranch* m2DPhiToPfMet_TauEnUp_branch
    cdef float m2DPhiToPfMet_TauEnUp_value

    cdef TBranch* m2DPhiToPfMet_UnclusteredEnDown_branch
    cdef float m2DPhiToPfMet_UnclusteredEnDown_value

    cdef TBranch* m2DPhiToPfMet_UnclusteredEnUp_branch
    cdef float m2DPhiToPfMet_UnclusteredEnUp_value

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

    cdef TBranch* m2MatchesMu23Ele12Path_branch
    cdef float m2MatchesMu23Ele12Path_value

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

    cdef TBranch* m2MtToPfMet_ElectronEnDown_branch
    cdef float m2MtToPfMet_ElectronEnDown_value

    cdef TBranch* m2MtToPfMet_ElectronEnUp_branch
    cdef float m2MtToPfMet_ElectronEnUp_value

    cdef TBranch* m2MtToPfMet_JetEnDown_branch
    cdef float m2MtToPfMet_JetEnDown_value

    cdef TBranch* m2MtToPfMet_JetEnUp_branch
    cdef float m2MtToPfMet_JetEnUp_value

    cdef TBranch* m2MtToPfMet_JetResDown_branch
    cdef float m2MtToPfMet_JetResDown_value

    cdef TBranch* m2MtToPfMet_JetResUp_branch
    cdef float m2MtToPfMet_JetResUp_value

    cdef TBranch* m2MtToPfMet_MuonEnDown_branch
    cdef float m2MtToPfMet_MuonEnDown_value

    cdef TBranch* m2MtToPfMet_MuonEnUp_branch
    cdef float m2MtToPfMet_MuonEnUp_value

    cdef TBranch* m2MtToPfMet_PhotonEnDown_branch
    cdef float m2MtToPfMet_PhotonEnDown_value

    cdef TBranch* m2MtToPfMet_PhotonEnUp_branch
    cdef float m2MtToPfMet_PhotonEnUp_value

    cdef TBranch* m2MtToPfMet_Raw_branch
    cdef float m2MtToPfMet_Raw_value

    cdef TBranch* m2MtToPfMet_TauEnDown_branch
    cdef float m2MtToPfMet_TauEnDown_value

    cdef TBranch* m2MtToPfMet_TauEnUp_branch
    cdef float m2MtToPfMet_TauEnUp_value

    cdef TBranch* m2MtToPfMet_UnclusteredEnDown_branch
    cdef float m2MtToPfMet_UnclusteredEnDown_value

    cdef TBranch* m2MtToPfMet_UnclusteredEnUp_branch
    cdef float m2MtToPfMet_UnclusteredEnUp_value

    cdef TBranch* m2MtToPfMet_type1_branch
    cdef float m2MtToPfMet_type1_value

    cdef TBranch* m2Mu23Ele12Filter_branch
    cdef float m2Mu23Ele12Filter_value

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

    cdef TBranch* m2_m1_collinearmass_branch
    cdef float m2_m1_collinearmass_value

    cdef TBranch* m2_m1_collinearmass_JetEnDown_branch
    cdef float m2_m1_collinearmass_JetEnDown_value

    cdef TBranch* m2_m1_collinearmass_JetEnUp_branch
    cdef float m2_m1_collinearmass_JetEnUp_value

    cdef TBranch* m2_m1_collinearmass_UnclusteredEnDown_branch
    cdef float m2_m1_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m2_m1_collinearmass_UnclusteredEnUp_branch
    cdef float m2_m1_collinearmass_UnclusteredEnUp_value

    cdef TBranch* m2_m3_CosThetaStar_branch
    cdef float m2_m3_CosThetaStar_value

    cdef TBranch* m2_m3_DPhi_branch
    cdef float m2_m3_DPhi_value

    cdef TBranch* m2_m3_DR_branch
    cdef float m2_m3_DR_value

    cdef TBranch* m2_m3_Eta_branch
    cdef float m2_m3_Eta_value

    cdef TBranch* m2_m3_Mass_branch
    cdef float m2_m3_Mass_value

    cdef TBranch* m2_m3_Mass_TauEnDown_branch
    cdef float m2_m3_Mass_TauEnDown_value

    cdef TBranch* m2_m3_Mass_TauEnUp_branch
    cdef float m2_m3_Mass_TauEnUp_value

    cdef TBranch* m2_m3_Mt_branch
    cdef float m2_m3_Mt_value

    cdef TBranch* m2_m3_MtTotal_branch
    cdef float m2_m3_MtTotal_value

    cdef TBranch* m2_m3_Mt_TauEnDown_branch
    cdef float m2_m3_Mt_TauEnDown_value

    cdef TBranch* m2_m3_Mt_TauEnUp_branch
    cdef float m2_m3_Mt_TauEnUp_value

    cdef TBranch* m2_m3_MvaMet_branch
    cdef float m2_m3_MvaMet_value

    cdef TBranch* m2_m3_MvaMetCovMatrix00_branch
    cdef float m2_m3_MvaMetCovMatrix00_value

    cdef TBranch* m2_m3_MvaMetCovMatrix01_branch
    cdef float m2_m3_MvaMetCovMatrix01_value

    cdef TBranch* m2_m3_MvaMetCovMatrix10_branch
    cdef float m2_m3_MvaMetCovMatrix10_value

    cdef TBranch* m2_m3_MvaMetCovMatrix11_branch
    cdef float m2_m3_MvaMetCovMatrix11_value

    cdef TBranch* m2_m3_MvaMetPhi_branch
    cdef float m2_m3_MvaMetPhi_value

    cdef TBranch* m2_m3_PZeta_branch
    cdef float m2_m3_PZeta_value

    cdef TBranch* m2_m3_PZetaLess0p85PZetaVis_branch
    cdef float m2_m3_PZetaLess0p85PZetaVis_value

    cdef TBranch* m2_m3_PZetaVis_branch
    cdef float m2_m3_PZetaVis_value

    cdef TBranch* m2_m3_Phi_branch
    cdef float m2_m3_Phi_value

    cdef TBranch* m2_m3_Pt_branch
    cdef float m2_m3_Pt_value

    cdef TBranch* m2_m3_SS_branch
    cdef float m2_m3_SS_value

    cdef TBranch* m2_m3_ToMETDPhi_Ty1_branch
    cdef float m2_m3_ToMETDPhi_Ty1_value

    cdef TBranch* m2_m3_collinearmass_branch
    cdef float m2_m3_collinearmass_value

    cdef TBranch* m2_m3_collinearmass_EleEnDown_branch
    cdef float m2_m3_collinearmass_EleEnDown_value

    cdef TBranch* m2_m3_collinearmass_EleEnUp_branch
    cdef float m2_m3_collinearmass_EleEnUp_value

    cdef TBranch* m2_m3_collinearmass_JetEnDown_branch
    cdef float m2_m3_collinearmass_JetEnDown_value

    cdef TBranch* m2_m3_collinearmass_JetEnUp_branch
    cdef float m2_m3_collinearmass_JetEnUp_value

    cdef TBranch* m2_m3_collinearmass_MuEnDown_branch
    cdef float m2_m3_collinearmass_MuEnDown_value

    cdef TBranch* m2_m3_collinearmass_MuEnUp_branch
    cdef float m2_m3_collinearmass_MuEnUp_value

    cdef TBranch* m2_m3_collinearmass_TauEnDown_branch
    cdef float m2_m3_collinearmass_TauEnDown_value

    cdef TBranch* m2_m3_collinearmass_TauEnUp_branch
    cdef float m2_m3_collinearmass_TauEnUp_value

    cdef TBranch* m2_m3_collinearmass_UnclusteredEnDown_branch
    cdef float m2_m3_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m2_m3_collinearmass_UnclusteredEnUp_branch
    cdef float m2_m3_collinearmass_UnclusteredEnUp_value

    cdef TBranch* m2_m3_pt_tt_branch
    cdef float m2_m3_pt_tt_value

    cdef TBranch* m3AbsEta_branch
    cdef float m3AbsEta_value

    cdef TBranch* m3BestTrackType_branch
    cdef float m3BestTrackType_value

    cdef TBranch* m3Charge_branch
    cdef float m3Charge_value

    cdef TBranch* m3Chi2LocalPosition_branch
    cdef float m3Chi2LocalPosition_value

    cdef TBranch* m3ComesFromHiggs_branch
    cdef float m3ComesFromHiggs_value

    cdef TBranch* m3DPhiToPfMet_ElectronEnDown_branch
    cdef float m3DPhiToPfMet_ElectronEnDown_value

    cdef TBranch* m3DPhiToPfMet_ElectronEnUp_branch
    cdef float m3DPhiToPfMet_ElectronEnUp_value

    cdef TBranch* m3DPhiToPfMet_JetEnDown_branch
    cdef float m3DPhiToPfMet_JetEnDown_value

    cdef TBranch* m3DPhiToPfMet_JetEnUp_branch
    cdef float m3DPhiToPfMet_JetEnUp_value

    cdef TBranch* m3DPhiToPfMet_JetResDown_branch
    cdef float m3DPhiToPfMet_JetResDown_value

    cdef TBranch* m3DPhiToPfMet_JetResUp_branch
    cdef float m3DPhiToPfMet_JetResUp_value

    cdef TBranch* m3DPhiToPfMet_MuonEnDown_branch
    cdef float m3DPhiToPfMet_MuonEnDown_value

    cdef TBranch* m3DPhiToPfMet_MuonEnUp_branch
    cdef float m3DPhiToPfMet_MuonEnUp_value

    cdef TBranch* m3DPhiToPfMet_PhotonEnDown_branch
    cdef float m3DPhiToPfMet_PhotonEnDown_value

    cdef TBranch* m3DPhiToPfMet_PhotonEnUp_branch
    cdef float m3DPhiToPfMet_PhotonEnUp_value

    cdef TBranch* m3DPhiToPfMet_TauEnDown_branch
    cdef float m3DPhiToPfMet_TauEnDown_value

    cdef TBranch* m3DPhiToPfMet_TauEnUp_branch
    cdef float m3DPhiToPfMet_TauEnUp_value

    cdef TBranch* m3DPhiToPfMet_UnclusteredEnDown_branch
    cdef float m3DPhiToPfMet_UnclusteredEnDown_value

    cdef TBranch* m3DPhiToPfMet_UnclusteredEnUp_branch
    cdef float m3DPhiToPfMet_UnclusteredEnUp_value

    cdef TBranch* m3DPhiToPfMet_type1_branch
    cdef float m3DPhiToPfMet_type1_value

    cdef TBranch* m3EcalIsoDR03_branch
    cdef float m3EcalIsoDR03_value

    cdef TBranch* m3EffectiveArea2011_branch
    cdef float m3EffectiveArea2011_value

    cdef TBranch* m3EffectiveArea2012_branch
    cdef float m3EffectiveArea2012_value

    cdef TBranch* m3ErsatzGenEta_branch
    cdef float m3ErsatzGenEta_value

    cdef TBranch* m3ErsatzGenM_branch
    cdef float m3ErsatzGenM_value

    cdef TBranch* m3ErsatzGenPhi_branch
    cdef float m3ErsatzGenPhi_value

    cdef TBranch* m3ErsatzGenpT_branch
    cdef float m3ErsatzGenpT_value

    cdef TBranch* m3ErsatzGenpX_branch
    cdef float m3ErsatzGenpX_value

    cdef TBranch* m3ErsatzGenpY_branch
    cdef float m3ErsatzGenpY_value

    cdef TBranch* m3ErsatzVispX_branch
    cdef float m3ErsatzVispX_value

    cdef TBranch* m3ErsatzVispY_branch
    cdef float m3ErsatzVispY_value

    cdef TBranch* m3Eta_branch
    cdef float m3Eta_value

    cdef TBranch* m3Eta_MuonEnDown_branch
    cdef float m3Eta_MuonEnDown_value

    cdef TBranch* m3Eta_MuonEnUp_branch
    cdef float m3Eta_MuonEnUp_value

    cdef TBranch* m3GenCharge_branch
    cdef float m3GenCharge_value

    cdef TBranch* m3GenDirectPromptTauDecayFinalState_branch
    cdef float m3GenDirectPromptTauDecayFinalState_value

    cdef TBranch* m3GenEnergy_branch
    cdef float m3GenEnergy_value

    cdef TBranch* m3GenEta_branch
    cdef float m3GenEta_value

    cdef TBranch* m3GenIsPrompt_branch
    cdef float m3GenIsPrompt_value

    cdef TBranch* m3GenMotherPdgId_branch
    cdef float m3GenMotherPdgId_value

    cdef TBranch* m3GenParticle_branch
    cdef float m3GenParticle_value

    cdef TBranch* m3GenPdgId_branch
    cdef float m3GenPdgId_value

    cdef TBranch* m3GenPhi_branch
    cdef float m3GenPhi_value

    cdef TBranch* m3GenPrompt_branch
    cdef float m3GenPrompt_value

    cdef TBranch* m3GenPromptFinalState_branch
    cdef float m3GenPromptFinalState_value

    cdef TBranch* m3GenPromptTauDecay_branch
    cdef float m3GenPromptTauDecay_value

    cdef TBranch* m3GenPt_branch
    cdef float m3GenPt_value

    cdef TBranch* m3GenTauDecay_branch
    cdef float m3GenTauDecay_value

    cdef TBranch* m3GenVZ_branch
    cdef float m3GenVZ_value

    cdef TBranch* m3GenVtxPVMatch_branch
    cdef float m3GenVtxPVMatch_value

    cdef TBranch* m3HcalIsoDR03_branch
    cdef float m3HcalIsoDR03_value

    cdef TBranch* m3IP3D_branch
    cdef float m3IP3D_value

    cdef TBranch* m3IP3DErr_branch
    cdef float m3IP3DErr_value

    cdef TBranch* m3IsGlobal_branch
    cdef float m3IsGlobal_value

    cdef TBranch* m3IsPFMuon_branch
    cdef float m3IsPFMuon_value

    cdef TBranch* m3IsTracker_branch
    cdef float m3IsTracker_value

    cdef TBranch* m3IsoDB03_branch
    cdef float m3IsoDB03_value

    cdef TBranch* m3IsoDB04_branch
    cdef float m3IsoDB04_value

    cdef TBranch* m3IsoMu22Filter_branch
    cdef float m3IsoMu22Filter_value

    cdef TBranch* m3IsoMu22eta2p1Filter_branch
    cdef float m3IsoMu22eta2p1Filter_value

    cdef TBranch* m3IsoMu24Filter_branch
    cdef float m3IsoMu24Filter_value

    cdef TBranch* m3IsoMu24eta2p1Filter_branch
    cdef float m3IsoMu24eta2p1Filter_value

    cdef TBranch* m3IsoTkMu22Filter_branch
    cdef float m3IsoTkMu22Filter_value

    cdef TBranch* m3IsoTkMu22eta2p1Filter_branch
    cdef float m3IsoTkMu22eta2p1Filter_value

    cdef TBranch* m3IsoTkMu24Filter_branch
    cdef float m3IsoTkMu24Filter_value

    cdef TBranch* m3IsoTkMu24eta2p1Filter_branch
    cdef float m3IsoTkMu24eta2p1Filter_value

    cdef TBranch* m3JetArea_branch
    cdef float m3JetArea_value

    cdef TBranch* m3JetBtag_branch
    cdef float m3JetBtag_value

    cdef TBranch* m3JetEtaEtaMoment_branch
    cdef float m3JetEtaEtaMoment_value

    cdef TBranch* m3JetEtaPhiMoment_branch
    cdef float m3JetEtaPhiMoment_value

    cdef TBranch* m3JetEtaPhiSpread_branch
    cdef float m3JetEtaPhiSpread_value

    cdef TBranch* m3JetHadronFlavour_branch
    cdef float m3JetHadronFlavour_value

    cdef TBranch* m3JetPFCISVBtag_branch
    cdef float m3JetPFCISVBtag_value

    cdef TBranch* m3JetPartonFlavour_branch
    cdef float m3JetPartonFlavour_value

    cdef TBranch* m3JetPhiPhiMoment_branch
    cdef float m3JetPhiPhiMoment_value

    cdef TBranch* m3JetPt_branch
    cdef float m3JetPt_value

    cdef TBranch* m3LowestMll_branch
    cdef float m3LowestMll_value

    cdef TBranch* m3Mass_branch
    cdef float m3Mass_value

    cdef TBranch* m3MatchedStations_branch
    cdef float m3MatchedStations_value

    cdef TBranch* m3MatchesDoubleESingleMu_branch
    cdef float m3MatchesDoubleESingleMu_value

    cdef TBranch* m3MatchesDoubleMu_branch
    cdef float m3MatchesDoubleMu_value

    cdef TBranch* m3MatchesDoubleMuSingleE_branch
    cdef float m3MatchesDoubleMuSingleE_value

    cdef TBranch* m3MatchesIsoMu22Path_branch
    cdef float m3MatchesIsoMu22Path_value

    cdef TBranch* m3MatchesIsoMu22eta2p1Path_branch
    cdef float m3MatchesIsoMu22eta2p1Path_value

    cdef TBranch* m3MatchesIsoMu24Path_branch
    cdef float m3MatchesIsoMu24Path_value

    cdef TBranch* m3MatchesIsoMu24eta2p1Path_branch
    cdef float m3MatchesIsoMu24eta2p1Path_value

    cdef TBranch* m3MatchesIsoTkMu22Path_branch
    cdef float m3MatchesIsoTkMu22Path_value

    cdef TBranch* m3MatchesIsoTkMu22eta2p1Path_branch
    cdef float m3MatchesIsoTkMu22eta2p1Path_value

    cdef TBranch* m3MatchesIsoTkMu24Path_branch
    cdef float m3MatchesIsoTkMu24Path_value

    cdef TBranch* m3MatchesIsoTkMu24eta2p1Path_branch
    cdef float m3MatchesIsoTkMu24eta2p1Path_value

    cdef TBranch* m3MatchesMu19Tau20Filter_branch
    cdef float m3MatchesMu19Tau20Filter_value

    cdef TBranch* m3MatchesMu19Tau20Path_branch
    cdef float m3MatchesMu19Tau20Path_value

    cdef TBranch* m3MatchesMu19Tau20sL1Filter_branch
    cdef float m3MatchesMu19Tau20sL1Filter_value

    cdef TBranch* m3MatchesMu19Tau20sL1Path_branch
    cdef float m3MatchesMu19Tau20sL1Path_value

    cdef TBranch* m3MatchesMu23Ele12Path_branch
    cdef float m3MatchesMu23Ele12Path_value

    cdef TBranch* m3MatchesMu8Ele23Path_branch
    cdef float m3MatchesMu8Ele23Path_value

    cdef TBranch* m3MatchesSingleESingleMu_branch
    cdef float m3MatchesSingleESingleMu_value

    cdef TBranch* m3MatchesSingleMu_branch
    cdef float m3MatchesSingleMu_value

    cdef TBranch* m3MatchesSingleMuIso20_branch
    cdef float m3MatchesSingleMuIso20_value

    cdef TBranch* m3MatchesSingleMuIsoTk20_branch
    cdef float m3MatchesSingleMuIsoTk20_value

    cdef TBranch* m3MatchesSingleMuSingleE_branch
    cdef float m3MatchesSingleMuSingleE_value

    cdef TBranch* m3MatchesSingleMu_leg1_branch
    cdef float m3MatchesSingleMu_leg1_value

    cdef TBranch* m3MatchesSingleMu_leg1_noiso_branch
    cdef float m3MatchesSingleMu_leg1_noiso_value

    cdef TBranch* m3MatchesSingleMu_leg2_branch
    cdef float m3MatchesSingleMu_leg2_value

    cdef TBranch* m3MatchesSingleMu_leg2_noiso_branch
    cdef float m3MatchesSingleMu_leg2_noiso_value

    cdef TBranch* m3MatchesTripleMu_branch
    cdef float m3MatchesTripleMu_value

    cdef TBranch* m3MtToPfMet_ElectronEnDown_branch
    cdef float m3MtToPfMet_ElectronEnDown_value

    cdef TBranch* m3MtToPfMet_ElectronEnUp_branch
    cdef float m3MtToPfMet_ElectronEnUp_value

    cdef TBranch* m3MtToPfMet_JetEnDown_branch
    cdef float m3MtToPfMet_JetEnDown_value

    cdef TBranch* m3MtToPfMet_JetEnUp_branch
    cdef float m3MtToPfMet_JetEnUp_value

    cdef TBranch* m3MtToPfMet_JetResDown_branch
    cdef float m3MtToPfMet_JetResDown_value

    cdef TBranch* m3MtToPfMet_JetResUp_branch
    cdef float m3MtToPfMet_JetResUp_value

    cdef TBranch* m3MtToPfMet_MuonEnDown_branch
    cdef float m3MtToPfMet_MuonEnDown_value

    cdef TBranch* m3MtToPfMet_MuonEnUp_branch
    cdef float m3MtToPfMet_MuonEnUp_value

    cdef TBranch* m3MtToPfMet_PhotonEnDown_branch
    cdef float m3MtToPfMet_PhotonEnDown_value

    cdef TBranch* m3MtToPfMet_PhotonEnUp_branch
    cdef float m3MtToPfMet_PhotonEnUp_value

    cdef TBranch* m3MtToPfMet_Raw_branch
    cdef float m3MtToPfMet_Raw_value

    cdef TBranch* m3MtToPfMet_TauEnDown_branch
    cdef float m3MtToPfMet_TauEnDown_value

    cdef TBranch* m3MtToPfMet_TauEnUp_branch
    cdef float m3MtToPfMet_TauEnUp_value

    cdef TBranch* m3MtToPfMet_UnclusteredEnDown_branch
    cdef float m3MtToPfMet_UnclusteredEnDown_value

    cdef TBranch* m3MtToPfMet_UnclusteredEnUp_branch
    cdef float m3MtToPfMet_UnclusteredEnUp_value

    cdef TBranch* m3MtToPfMet_type1_branch
    cdef float m3MtToPfMet_type1_value

    cdef TBranch* m3Mu23Ele12Filter_branch
    cdef float m3Mu23Ele12Filter_value

    cdef TBranch* m3Mu8Ele23Filter_branch
    cdef float m3Mu8Ele23Filter_value

    cdef TBranch* m3MuonHits_branch
    cdef float m3MuonHits_value

    cdef TBranch* m3NearestZMass_branch
    cdef float m3NearestZMass_value

    cdef TBranch* m3NormTrkChi2_branch
    cdef float m3NormTrkChi2_value

    cdef TBranch* m3NormalizedChi2_branch
    cdef float m3NormalizedChi2_value

    cdef TBranch* m3PFChargedHadronIsoR04_branch
    cdef float m3PFChargedHadronIsoR04_value

    cdef TBranch* m3PFChargedIso_branch
    cdef float m3PFChargedIso_value

    cdef TBranch* m3PFIDLoose_branch
    cdef float m3PFIDLoose_value

    cdef TBranch* m3PFIDMedium_branch
    cdef float m3PFIDMedium_value

    cdef TBranch* m3PFIDTight_branch
    cdef float m3PFIDTight_value

    cdef TBranch* m3PFNeutralHadronIsoR04_branch
    cdef float m3PFNeutralHadronIsoR04_value

    cdef TBranch* m3PFNeutralIso_branch
    cdef float m3PFNeutralIso_value

    cdef TBranch* m3PFPUChargedIso_branch
    cdef float m3PFPUChargedIso_value

    cdef TBranch* m3PFPhotonIso_branch
    cdef float m3PFPhotonIso_value

    cdef TBranch* m3PFPhotonIsoR04_branch
    cdef float m3PFPhotonIsoR04_value

    cdef TBranch* m3PFPileupIsoR04_branch
    cdef float m3PFPileupIsoR04_value

    cdef TBranch* m3PVDXY_branch
    cdef float m3PVDXY_value

    cdef TBranch* m3PVDZ_branch
    cdef float m3PVDZ_value

    cdef TBranch* m3Phi_branch
    cdef float m3Phi_value

    cdef TBranch* m3Phi_MuonEnDown_branch
    cdef float m3Phi_MuonEnDown_value

    cdef TBranch* m3Phi_MuonEnUp_branch
    cdef float m3Phi_MuonEnUp_value

    cdef TBranch* m3PixHits_branch
    cdef float m3PixHits_value

    cdef TBranch* m3Pt_branch
    cdef float m3Pt_value

    cdef TBranch* m3Pt_MuonEnDown_branch
    cdef float m3Pt_MuonEnDown_value

    cdef TBranch* m3Pt_MuonEnUp_branch
    cdef float m3Pt_MuonEnUp_value

    cdef TBranch* m3Rank_branch
    cdef float m3Rank_value

    cdef TBranch* m3RelPFIsoDBDefault_branch
    cdef float m3RelPFIsoDBDefault_value

    cdef TBranch* m3RelPFIsoDBDefaultR04_branch
    cdef float m3RelPFIsoDBDefaultR04_value

    cdef TBranch* m3RelPFIsoRho_branch
    cdef float m3RelPFIsoRho_value

    cdef TBranch* m3Rho_branch
    cdef float m3Rho_value

    cdef TBranch* m3SIP2D_branch
    cdef float m3SIP2D_value

    cdef TBranch* m3SIP3D_branch
    cdef float m3SIP3D_value

    cdef TBranch* m3SegmentCompatibility_branch
    cdef float m3SegmentCompatibility_value

    cdef TBranch* m3TkLayersWithMeasurement_branch
    cdef float m3TkLayersWithMeasurement_value

    cdef TBranch* m3TrkIsoDR03_branch
    cdef float m3TrkIsoDR03_value

    cdef TBranch* m3TrkKink_branch
    cdef float m3TrkKink_value

    cdef TBranch* m3TypeCode_branch
    cdef int m3TypeCode_value

    cdef TBranch* m3VZ_branch
    cdef float m3VZ_value

    cdef TBranch* m3ValidFraction_branch
    cdef float m3ValidFraction_value

    cdef TBranch* m3ZTTGenMatching_branch
    cdef float m3ZTTGenMatching_value

    cdef TBranch* m3_m1_collinearmass_branch
    cdef float m3_m1_collinearmass_value

    cdef TBranch* m3_m1_collinearmass_JetEnDown_branch
    cdef float m3_m1_collinearmass_JetEnDown_value

    cdef TBranch* m3_m1_collinearmass_JetEnUp_branch
    cdef float m3_m1_collinearmass_JetEnUp_value

    cdef TBranch* m3_m1_collinearmass_UnclusteredEnDown_branch
    cdef float m3_m1_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m3_m1_collinearmass_UnclusteredEnUp_branch
    cdef float m3_m1_collinearmass_UnclusteredEnUp_value

    cdef TBranch* m3_m2_collinearmass_branch
    cdef float m3_m2_collinearmass_value

    cdef TBranch* m3_m2_collinearmass_JetEnDown_branch
    cdef float m3_m2_collinearmass_JetEnDown_value

    cdef TBranch* m3_m2_collinearmass_JetEnUp_branch
    cdef float m3_m2_collinearmass_JetEnUp_value

    cdef TBranch* m3_m2_collinearmass_UnclusteredEnDown_branch
    cdef float m3_m2_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m3_m2_collinearmass_UnclusteredEnUp_branch
    cdef float m3_m2_collinearmass_UnclusteredEnUp_value

    cdef TBranch* metSig_branch
    cdef float metSig_value

    cdef TBranch* metcov00_branch
    cdef float metcov00_value

    cdef TBranch* metcov01_branch
    cdef float metcov01_value

    cdef TBranch* metcov10_branch
    cdef float metcov10_value

    cdef TBranch* metcov11_branch
    cdef float metcov11_value

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

    cdef TBranch* singleE25eta2p1LooseGroup_branch
    cdef float singleE25eta2p1LooseGroup_value

    cdef TBranch* singleE25eta2p1LoosePass_branch
    cdef float singleE25eta2p1LoosePass_value

    cdef TBranch* singleE25eta2p1LoosePrescale_branch
    cdef float singleE25eta2p1LoosePrescale_value

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

    cdef TBranch* singleIsoMu24Group_branch
    cdef float singleIsoMu24Group_value

    cdef TBranch* singleIsoMu24Pass_branch
    cdef float singleIsoMu24Pass_value

    cdef TBranch* singleIsoMu24Prescale_branch
    cdef float singleIsoMu24Prescale_value

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
            warnings.warn( "MuMuMuTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "MuMuMuTree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "MuMuMuTree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "MuMuMuTree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "MuMuMuTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "MuMuMuTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "MuMuMuTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "MuMuMuTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "MuMuMuTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "MuMuMuTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "MuMuMuTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "MuMuMuTree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "MuMuMuTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "MuMuMuTree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "MuMuMuTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCISVVeto20Loose"
        self.bjetCISVVeto20Loose_branch = the_tree.GetBranch("bjetCISVVeto20Loose")
        #if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose" not in self.complained:
        if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose":
            warnings.warn( "MuMuMuTree: Expected branch bjetCISVVeto20Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Loose")
        else:
            self.bjetCISVVeto20Loose_branch.SetAddress(<void*>&self.bjetCISVVeto20Loose_value)

        #print "making bjetCISVVeto20Medium"
        self.bjetCISVVeto20Medium_branch = the_tree.GetBranch("bjetCISVVeto20Medium")
        #if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium" not in self.complained:
        if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium":
            warnings.warn( "MuMuMuTree: Expected branch bjetCISVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Medium")
        else:
            self.bjetCISVVeto20Medium_branch.SetAddress(<void*>&self.bjetCISVVeto20Medium_value)

        #print "making bjetCISVVeto20Tight"
        self.bjetCISVVeto20Tight_branch = the_tree.GetBranch("bjetCISVVeto20Tight")
        #if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight" not in self.complained:
        if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight":
            warnings.warn( "MuMuMuTree: Expected branch bjetCISVVeto20Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Tight")
        else:
            self.bjetCISVVeto20Tight_branch.SetAddress(<void*>&self.bjetCISVVeto20Tight_value)

        #print "making bjetCISVVeto30Loose"
        self.bjetCISVVeto30Loose_branch = the_tree.GetBranch("bjetCISVVeto30Loose")
        #if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose" not in self.complained:
        if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose":
            warnings.warn( "MuMuMuTree: Expected branch bjetCISVVeto30Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Loose")
        else:
            self.bjetCISVVeto30Loose_branch.SetAddress(<void*>&self.bjetCISVVeto30Loose_value)

        #print "making bjetCISVVeto30Medium"
        self.bjetCISVVeto30Medium_branch = the_tree.GetBranch("bjetCISVVeto30Medium")
        #if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium" not in self.complained:
        if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium":
            warnings.warn( "MuMuMuTree: Expected branch bjetCISVVeto30Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Medium")
        else:
            self.bjetCISVVeto30Medium_branch.SetAddress(<void*>&self.bjetCISVVeto30Medium_value)

        #print "making bjetCISVVeto30Tight"
        self.bjetCISVVeto30Tight_branch = the_tree.GetBranch("bjetCISVVeto30Tight")
        #if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight" not in self.complained:
        if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight":
            warnings.warn( "MuMuMuTree: Expected branch bjetCISVVeto30Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Tight")
        else:
            self.bjetCISVVeto30Tight_branch.SetAddress(<void*>&self.bjetCISVVeto30Tight_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "MuMuMuTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "MuMuMuTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "MuMuMuTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making doubleEGroup"
        self.doubleEGroup_branch = the_tree.GetBranch("doubleEGroup")
        #if not self.doubleEGroup_branch and "doubleEGroup" not in self.complained:
        if not self.doubleEGroup_branch and "doubleEGroup":
            warnings.warn( "MuMuMuTree: Expected branch doubleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEGroup")
        else:
            self.doubleEGroup_branch.SetAddress(<void*>&self.doubleEGroup_value)

        #print "making doubleEPass"
        self.doubleEPass_branch = the_tree.GetBranch("doubleEPass")
        #if not self.doubleEPass_branch and "doubleEPass" not in self.complained:
        if not self.doubleEPass_branch and "doubleEPass":
            warnings.warn( "MuMuMuTree: Expected branch doubleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPass")
        else:
            self.doubleEPass_branch.SetAddress(<void*>&self.doubleEPass_value)

        #print "making doubleEPrescale"
        self.doubleEPrescale_branch = the_tree.GetBranch("doubleEPrescale")
        #if not self.doubleEPrescale_branch and "doubleEPrescale" not in self.complained:
        if not self.doubleEPrescale_branch and "doubleEPrescale":
            warnings.warn( "MuMuMuTree: Expected branch doubleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPrescale")
        else:
            self.doubleEPrescale_branch.SetAddress(<void*>&self.doubleEPrescale_value)

        #print "making doubleESingleMuGroup"
        self.doubleESingleMuGroup_branch = the_tree.GetBranch("doubleESingleMuGroup")
        #if not self.doubleESingleMuGroup_branch and "doubleESingleMuGroup" not in self.complained:
        if not self.doubleESingleMuGroup_branch and "doubleESingleMuGroup":
            warnings.warn( "MuMuMuTree: Expected branch doubleESingleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuGroup")
        else:
            self.doubleESingleMuGroup_branch.SetAddress(<void*>&self.doubleESingleMuGroup_value)

        #print "making doubleESingleMuPass"
        self.doubleESingleMuPass_branch = the_tree.GetBranch("doubleESingleMuPass")
        #if not self.doubleESingleMuPass_branch and "doubleESingleMuPass" not in self.complained:
        if not self.doubleESingleMuPass_branch and "doubleESingleMuPass":
            warnings.warn( "MuMuMuTree: Expected branch doubleESingleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuPass")
        else:
            self.doubleESingleMuPass_branch.SetAddress(<void*>&self.doubleESingleMuPass_value)

        #print "making doubleESingleMuPrescale"
        self.doubleESingleMuPrescale_branch = the_tree.GetBranch("doubleESingleMuPrescale")
        #if not self.doubleESingleMuPrescale_branch and "doubleESingleMuPrescale" not in self.complained:
        if not self.doubleESingleMuPrescale_branch and "doubleESingleMuPrescale":
            warnings.warn( "MuMuMuTree: Expected branch doubleESingleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuPrescale")
        else:
            self.doubleESingleMuPrescale_branch.SetAddress(<void*>&self.doubleESingleMuPrescale_value)

        #print "making doubleE_23_12Group"
        self.doubleE_23_12Group_branch = the_tree.GetBranch("doubleE_23_12Group")
        #if not self.doubleE_23_12Group_branch and "doubleE_23_12Group" not in self.complained:
        if not self.doubleE_23_12Group_branch and "doubleE_23_12Group":
            warnings.warn( "MuMuMuTree: Expected branch doubleE_23_12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Group")
        else:
            self.doubleE_23_12Group_branch.SetAddress(<void*>&self.doubleE_23_12Group_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "MuMuMuTree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleE_23_12Prescale"
        self.doubleE_23_12Prescale_branch = the_tree.GetBranch("doubleE_23_12Prescale")
        #if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale" not in self.complained:
        if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale":
            warnings.warn( "MuMuMuTree: Expected branch doubleE_23_12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Prescale")
        else:
            self.doubleE_23_12Prescale_branch.SetAddress(<void*>&self.doubleE_23_12Prescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "MuMuMuTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "MuMuMuTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "MuMuMuTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuSingleEGroup"
        self.doubleMuSingleEGroup_branch = the_tree.GetBranch("doubleMuSingleEGroup")
        #if not self.doubleMuSingleEGroup_branch and "doubleMuSingleEGroup" not in self.complained:
        if not self.doubleMuSingleEGroup_branch and "doubleMuSingleEGroup":
            warnings.warn( "MuMuMuTree: Expected branch doubleMuSingleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEGroup")
        else:
            self.doubleMuSingleEGroup_branch.SetAddress(<void*>&self.doubleMuSingleEGroup_value)

        #print "making doubleMuSingleEPass"
        self.doubleMuSingleEPass_branch = the_tree.GetBranch("doubleMuSingleEPass")
        #if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass" not in self.complained:
        if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass":
            warnings.warn( "MuMuMuTree: Expected branch doubleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPass")
        else:
            self.doubleMuSingleEPass_branch.SetAddress(<void*>&self.doubleMuSingleEPass_value)

        #print "making doubleMuSingleEPrescale"
        self.doubleMuSingleEPrescale_branch = the_tree.GetBranch("doubleMuSingleEPrescale")
        #if not self.doubleMuSingleEPrescale_branch and "doubleMuSingleEPrescale" not in self.complained:
        if not self.doubleMuSingleEPrescale_branch and "doubleMuSingleEPrescale":
            warnings.warn( "MuMuMuTree: Expected branch doubleMuSingleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPrescale")
        else:
            self.doubleMuSingleEPrescale_branch.SetAddress(<void*>&self.doubleMuSingleEPrescale_value)

        #print "making doubleTau32Group"
        self.doubleTau32Group_branch = the_tree.GetBranch("doubleTau32Group")
        #if not self.doubleTau32Group_branch and "doubleTau32Group" not in self.complained:
        if not self.doubleTau32Group_branch and "doubleTau32Group":
            warnings.warn( "MuMuMuTree: Expected branch doubleTau32Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau32Group")
        else:
            self.doubleTau32Group_branch.SetAddress(<void*>&self.doubleTau32Group_value)

        #print "making doubleTau32Pass"
        self.doubleTau32Pass_branch = the_tree.GetBranch("doubleTau32Pass")
        #if not self.doubleTau32Pass_branch and "doubleTau32Pass" not in self.complained:
        if not self.doubleTau32Pass_branch and "doubleTau32Pass":
            warnings.warn( "MuMuMuTree: Expected branch doubleTau32Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau32Pass")
        else:
            self.doubleTau32Pass_branch.SetAddress(<void*>&self.doubleTau32Pass_value)

        #print "making doubleTau32Prescale"
        self.doubleTau32Prescale_branch = the_tree.GetBranch("doubleTau32Prescale")
        #if not self.doubleTau32Prescale_branch and "doubleTau32Prescale" not in self.complained:
        if not self.doubleTau32Prescale_branch and "doubleTau32Prescale":
            warnings.warn( "MuMuMuTree: Expected branch doubleTau32Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau32Prescale")
        else:
            self.doubleTau32Prescale_branch.SetAddress(<void*>&self.doubleTau32Prescale_value)

        #print "making doubleTau35Group"
        self.doubleTau35Group_branch = the_tree.GetBranch("doubleTau35Group")
        #if not self.doubleTau35Group_branch and "doubleTau35Group" not in self.complained:
        if not self.doubleTau35Group_branch and "doubleTau35Group":
            warnings.warn( "MuMuMuTree: Expected branch doubleTau35Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Group")
        else:
            self.doubleTau35Group_branch.SetAddress(<void*>&self.doubleTau35Group_value)

        #print "making doubleTau35Pass"
        self.doubleTau35Pass_branch = the_tree.GetBranch("doubleTau35Pass")
        #if not self.doubleTau35Pass_branch and "doubleTau35Pass" not in self.complained:
        if not self.doubleTau35Pass_branch and "doubleTau35Pass":
            warnings.warn( "MuMuMuTree: Expected branch doubleTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Pass")
        else:
            self.doubleTau35Pass_branch.SetAddress(<void*>&self.doubleTau35Pass_value)

        #print "making doubleTau35Prescale"
        self.doubleTau35Prescale_branch = the_tree.GetBranch("doubleTau35Prescale")
        #if not self.doubleTau35Prescale_branch and "doubleTau35Prescale" not in self.complained:
        if not self.doubleTau35Prescale_branch and "doubleTau35Prescale":
            warnings.warn( "MuMuMuTree: Expected branch doubleTau35Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Prescale")
        else:
            self.doubleTau35Prescale_branch.SetAddress(<void*>&self.doubleTau35Prescale_value)

        #print "making doubleTau40Group"
        self.doubleTau40Group_branch = the_tree.GetBranch("doubleTau40Group")
        #if not self.doubleTau40Group_branch and "doubleTau40Group" not in self.complained:
        if not self.doubleTau40Group_branch and "doubleTau40Group":
            warnings.warn( "MuMuMuTree: Expected branch doubleTau40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau40Group")
        else:
            self.doubleTau40Group_branch.SetAddress(<void*>&self.doubleTau40Group_value)

        #print "making doubleTau40Pass"
        self.doubleTau40Pass_branch = the_tree.GetBranch("doubleTau40Pass")
        #if not self.doubleTau40Pass_branch and "doubleTau40Pass" not in self.complained:
        if not self.doubleTau40Pass_branch and "doubleTau40Pass":
            warnings.warn( "MuMuMuTree: Expected branch doubleTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau40Pass")
        else:
            self.doubleTau40Pass_branch.SetAddress(<void*>&self.doubleTau40Pass_value)

        #print "making doubleTau40Prescale"
        self.doubleTau40Prescale_branch = the_tree.GetBranch("doubleTau40Prescale")
        #if not self.doubleTau40Prescale_branch and "doubleTau40Prescale" not in self.complained:
        if not self.doubleTau40Prescale_branch and "doubleTau40Prescale":
            warnings.warn( "MuMuMuTree: Expected branch doubleTau40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau40Prescale")
        else:
            self.doubleTau40Prescale_branch.SetAddress(<void*>&self.doubleTau40Prescale_value)

        #print "making doubleTauCmbIso35RegGroup"
        self.doubleTauCmbIso35RegGroup_branch = the_tree.GetBranch("doubleTauCmbIso35RegGroup")
        #if not self.doubleTauCmbIso35RegGroup_branch and "doubleTauCmbIso35RegGroup" not in self.complained:
        if not self.doubleTauCmbIso35RegGroup_branch and "doubleTauCmbIso35RegGroup":
            warnings.warn( "MuMuMuTree: Expected branch doubleTauCmbIso35RegGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegGroup")
        else:
            self.doubleTauCmbIso35RegGroup_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegGroup_value)

        #print "making doubleTauCmbIso35RegPass"
        self.doubleTauCmbIso35RegPass_branch = the_tree.GetBranch("doubleTauCmbIso35RegPass")
        #if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass" not in self.complained:
        if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass":
            warnings.warn( "MuMuMuTree: Expected branch doubleTauCmbIso35RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPass")
        else:
            self.doubleTauCmbIso35RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPass_value)

        #print "making doubleTauCmbIso35RegPrescale"
        self.doubleTauCmbIso35RegPrescale_branch = the_tree.GetBranch("doubleTauCmbIso35RegPrescale")
        #if not self.doubleTauCmbIso35RegPrescale_branch and "doubleTauCmbIso35RegPrescale" not in self.complained:
        if not self.doubleTauCmbIso35RegPrescale_branch and "doubleTauCmbIso35RegPrescale":
            warnings.warn( "MuMuMuTree: Expected branch doubleTauCmbIso35RegPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPrescale")
        else:
            self.doubleTauCmbIso35RegPrescale_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPrescale_value)

        #print "making doubleTauCmbIso40Group"
        self.doubleTauCmbIso40Group_branch = the_tree.GetBranch("doubleTauCmbIso40Group")
        #if not self.doubleTauCmbIso40Group_branch and "doubleTauCmbIso40Group" not in self.complained:
        if not self.doubleTauCmbIso40Group_branch and "doubleTauCmbIso40Group":
            warnings.warn( "MuMuMuTree: Expected branch doubleTauCmbIso40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40Group")
        else:
            self.doubleTauCmbIso40Group_branch.SetAddress(<void*>&self.doubleTauCmbIso40Group_value)

        #print "making doubleTauCmbIso40Pass"
        self.doubleTauCmbIso40Pass_branch = the_tree.GetBranch("doubleTauCmbIso40Pass")
        #if not self.doubleTauCmbIso40Pass_branch and "doubleTauCmbIso40Pass" not in self.complained:
        if not self.doubleTauCmbIso40Pass_branch and "doubleTauCmbIso40Pass":
            warnings.warn( "MuMuMuTree: Expected branch doubleTauCmbIso40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40Pass")
        else:
            self.doubleTauCmbIso40Pass_branch.SetAddress(<void*>&self.doubleTauCmbIso40Pass_value)

        #print "making doubleTauCmbIso40Prescale"
        self.doubleTauCmbIso40Prescale_branch = the_tree.GetBranch("doubleTauCmbIso40Prescale")
        #if not self.doubleTauCmbIso40Prescale_branch and "doubleTauCmbIso40Prescale" not in self.complained:
        if not self.doubleTauCmbIso40Prescale_branch and "doubleTauCmbIso40Prescale":
            warnings.warn( "MuMuMuTree: Expected branch doubleTauCmbIso40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40Prescale")
        else:
            self.doubleTauCmbIso40Prescale_branch.SetAddress(<void*>&self.doubleTauCmbIso40Prescale_value)

        #print "making doubleTauCmbIso40RegGroup"
        self.doubleTauCmbIso40RegGroup_branch = the_tree.GetBranch("doubleTauCmbIso40RegGroup")
        #if not self.doubleTauCmbIso40RegGroup_branch and "doubleTauCmbIso40RegGroup" not in self.complained:
        if not self.doubleTauCmbIso40RegGroup_branch and "doubleTauCmbIso40RegGroup":
            warnings.warn( "MuMuMuTree: Expected branch doubleTauCmbIso40RegGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40RegGroup")
        else:
            self.doubleTauCmbIso40RegGroup_branch.SetAddress(<void*>&self.doubleTauCmbIso40RegGroup_value)

        #print "making doubleTauCmbIso40RegPass"
        self.doubleTauCmbIso40RegPass_branch = the_tree.GetBranch("doubleTauCmbIso40RegPass")
        #if not self.doubleTauCmbIso40RegPass_branch and "doubleTauCmbIso40RegPass" not in self.complained:
        if not self.doubleTauCmbIso40RegPass_branch and "doubleTauCmbIso40RegPass":
            warnings.warn( "MuMuMuTree: Expected branch doubleTauCmbIso40RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40RegPass")
        else:
            self.doubleTauCmbIso40RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso40RegPass_value)

        #print "making doubleTauCmbIso40RegPrescale"
        self.doubleTauCmbIso40RegPrescale_branch = the_tree.GetBranch("doubleTauCmbIso40RegPrescale")
        #if not self.doubleTauCmbIso40RegPrescale_branch and "doubleTauCmbIso40RegPrescale" not in self.complained:
        if not self.doubleTauCmbIso40RegPrescale_branch and "doubleTauCmbIso40RegPrescale":
            warnings.warn( "MuMuMuTree: Expected branch doubleTauCmbIso40RegPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40RegPrescale")
        else:
            self.doubleTauCmbIso40RegPrescale_branch.SetAddress(<void*>&self.doubleTauCmbIso40RegPrescale_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "MuMuMuTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "MuMuMuTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "MuMuMuTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eVetoZTTp001dxyzR0"
        self.eVetoZTTp001dxyzR0_branch = the_tree.GetBranch("eVetoZTTp001dxyzR0")
        #if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0" not in self.complained:
        if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0":
            warnings.warn( "MuMuMuTree: Expected branch eVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyzR0")
        else:
            self.eVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.eVetoZTTp001dxyzR0_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "MuMuMuTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "MuMuMuTree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "MuMuMuTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "MuMuMuTree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "MuMuMuTree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "MuMuMuTree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "MuMuMuTree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "MuMuMuTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "MuMuMuTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "MuMuMuTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWenu"
        self.isWenu_branch = the_tree.GetBranch("isWenu")
        #if not self.isWenu_branch and "isWenu" not in self.complained:
        if not self.isWenu_branch and "isWenu":
            warnings.warn( "MuMuMuTree: Expected branch isWenu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWenu")
        else:
            self.isWenu_branch.SetAddress(<void*>&self.isWenu_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "MuMuMuTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "MuMuMuTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "MuMuMuTree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "MuMuMuTree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "MuMuMuTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "MuMuMuTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "MuMuMuTree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "MuMuMuTree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "MuMuMuTree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1partonflavor"
        self.j1partonflavor_branch = the_tree.GetBranch("j1partonflavor")
        #if not self.j1partonflavor_branch and "j1partonflavor" not in self.complained:
        if not self.j1partonflavor_branch and "j1partonflavor":
            warnings.warn( "MuMuMuTree: Expected branch j1partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1partonflavor")
        else:
            self.j1partonflavor_branch.SetAddress(<void*>&self.j1partonflavor_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "MuMuMuTree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "MuMuMuTree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptDown"
        self.j1ptDown_branch = the_tree.GetBranch("j1ptDown")
        #if not self.j1ptDown_branch and "j1ptDown" not in self.complained:
        if not self.j1ptDown_branch and "j1ptDown":
            warnings.warn( "MuMuMuTree: Expected branch j1ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptDown")
        else:
            self.j1ptDown_branch.SetAddress(<void*>&self.j1ptDown_value)

        #print "making j1ptUp"
        self.j1ptUp_branch = the_tree.GetBranch("j1ptUp")
        #if not self.j1ptUp_branch and "j1ptUp" not in self.complained:
        if not self.j1ptUp_branch and "j1ptUp":
            warnings.warn( "MuMuMuTree: Expected branch j1ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptUp")
        else:
            self.j1ptUp_branch.SetAddress(<void*>&self.j1ptUp_value)

        #print "making j1pu"
        self.j1pu_branch = the_tree.GetBranch("j1pu")
        #if not self.j1pu_branch and "j1pu" not in self.complained:
        if not self.j1pu_branch and "j1pu":
            warnings.warn( "MuMuMuTree: Expected branch j1pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pu")
        else:
            self.j1pu_branch.SetAddress(<void*>&self.j1pu_value)

        #print "making j1rawf"
        self.j1rawf_branch = the_tree.GetBranch("j1rawf")
        #if not self.j1rawf_branch and "j1rawf" not in self.complained:
        if not self.j1rawf_branch and "j1rawf":
            warnings.warn( "MuMuMuTree: Expected branch j1rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1rawf")
        else:
            self.j1rawf_branch.SetAddress(<void*>&self.j1rawf_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "MuMuMuTree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "MuMuMuTree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "MuMuMuTree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2partonflavor"
        self.j2partonflavor_branch = the_tree.GetBranch("j2partonflavor")
        #if not self.j2partonflavor_branch and "j2partonflavor" not in self.complained:
        if not self.j2partonflavor_branch and "j2partonflavor":
            warnings.warn( "MuMuMuTree: Expected branch j2partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2partonflavor")
        else:
            self.j2partonflavor_branch.SetAddress(<void*>&self.j2partonflavor_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "MuMuMuTree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "MuMuMuTree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptDown"
        self.j2ptDown_branch = the_tree.GetBranch("j2ptDown")
        #if not self.j2ptDown_branch and "j2ptDown" not in self.complained:
        if not self.j2ptDown_branch and "j2ptDown":
            warnings.warn( "MuMuMuTree: Expected branch j2ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptDown")
        else:
            self.j2ptDown_branch.SetAddress(<void*>&self.j2ptDown_value)

        #print "making j2ptUp"
        self.j2ptUp_branch = the_tree.GetBranch("j2ptUp")
        #if not self.j2ptUp_branch and "j2ptUp" not in self.complained:
        if not self.j2ptUp_branch and "j2ptUp":
            warnings.warn( "MuMuMuTree: Expected branch j2ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptUp")
        else:
            self.j2ptUp_branch.SetAddress(<void*>&self.j2ptUp_value)

        #print "making j2pu"
        self.j2pu_branch = the_tree.GetBranch("j2pu")
        #if not self.j2pu_branch and "j2pu" not in self.complained:
        if not self.j2pu_branch and "j2pu":
            warnings.warn( "MuMuMuTree: Expected branch j2pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pu")
        else:
            self.j2pu_branch.SetAddress(<void*>&self.j2pu_value)

        #print "making j2rawf"
        self.j2rawf_branch = the_tree.GetBranch("j2rawf")
        #if not self.j2rawf_branch and "j2rawf" not in self.complained:
        if not self.j2rawf_branch and "j2rawf":
            warnings.warn( "MuMuMuTree: Expected branch j2rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2rawf")
        else:
            self.j2rawf_branch.SetAddress(<void*>&self.j2rawf_value)

        #print "making jb1csv"
        self.jb1csv_branch = the_tree.GetBranch("jb1csv")
        #if not self.jb1csv_branch and "jb1csv" not in self.complained:
        if not self.jb1csv_branch and "jb1csv":
            warnings.warn( "MuMuMuTree: Expected branch jb1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csv")
        else:
            self.jb1csv_branch.SetAddress(<void*>&self.jb1csv_value)

        #print "making jb1csv_CSVL"
        self.jb1csv_CSVL_branch = the_tree.GetBranch("jb1csv_CSVL")
        #if not self.jb1csv_CSVL_branch and "jb1csv_CSVL" not in self.complained:
        if not self.jb1csv_CSVL_branch and "jb1csv_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb1csv_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csv_CSVL")
        else:
            self.jb1csv_CSVL_branch.SetAddress(<void*>&self.jb1csv_CSVL_value)

        #print "making jb1eta"
        self.jb1eta_branch = the_tree.GetBranch("jb1eta")
        #if not self.jb1eta_branch and "jb1eta" not in self.complained:
        if not self.jb1eta_branch and "jb1eta":
            warnings.warn( "MuMuMuTree: Expected branch jb1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta")
        else:
            self.jb1eta_branch.SetAddress(<void*>&self.jb1eta_value)

        #print "making jb1eta_CSVL"
        self.jb1eta_CSVL_branch = the_tree.GetBranch("jb1eta_CSVL")
        #if not self.jb1eta_CSVL_branch and "jb1eta_CSVL" not in self.complained:
        if not self.jb1eta_CSVL_branch and "jb1eta_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb1eta_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_CSVL")
        else:
            self.jb1eta_CSVL_branch.SetAddress(<void*>&self.jb1eta_CSVL_value)

        #print "making jb1hadronflavor"
        self.jb1hadronflavor_branch = the_tree.GetBranch("jb1hadronflavor")
        #if not self.jb1hadronflavor_branch and "jb1hadronflavor" not in self.complained:
        if not self.jb1hadronflavor_branch and "jb1hadronflavor":
            warnings.warn( "MuMuMuTree: Expected branch jb1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor")
        else:
            self.jb1hadronflavor_branch.SetAddress(<void*>&self.jb1hadronflavor_value)

        #print "making jb1hadronflavor_CSVL"
        self.jb1hadronflavor_CSVL_branch = the_tree.GetBranch("jb1hadronflavor_CSVL")
        #if not self.jb1hadronflavor_CSVL_branch and "jb1hadronflavor_CSVL" not in self.complained:
        if not self.jb1hadronflavor_CSVL_branch and "jb1hadronflavor_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb1hadronflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_CSVL")
        else:
            self.jb1hadronflavor_CSVL_branch.SetAddress(<void*>&self.jb1hadronflavor_CSVL_value)

        #print "making jb1partonflavor"
        self.jb1partonflavor_branch = the_tree.GetBranch("jb1partonflavor")
        #if not self.jb1partonflavor_branch and "jb1partonflavor" not in self.complained:
        if not self.jb1partonflavor_branch and "jb1partonflavor":
            warnings.warn( "MuMuMuTree: Expected branch jb1partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1partonflavor")
        else:
            self.jb1partonflavor_branch.SetAddress(<void*>&self.jb1partonflavor_value)

        #print "making jb1partonflavor_CSVL"
        self.jb1partonflavor_CSVL_branch = the_tree.GetBranch("jb1partonflavor_CSVL")
        #if not self.jb1partonflavor_CSVL_branch and "jb1partonflavor_CSVL" not in self.complained:
        if not self.jb1partonflavor_CSVL_branch and "jb1partonflavor_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb1partonflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1partonflavor_CSVL")
        else:
            self.jb1partonflavor_CSVL_branch.SetAddress(<void*>&self.jb1partonflavor_CSVL_value)

        #print "making jb1phi"
        self.jb1phi_branch = the_tree.GetBranch("jb1phi")
        #if not self.jb1phi_branch and "jb1phi" not in self.complained:
        if not self.jb1phi_branch and "jb1phi":
            warnings.warn( "MuMuMuTree: Expected branch jb1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi")
        else:
            self.jb1phi_branch.SetAddress(<void*>&self.jb1phi_value)

        #print "making jb1phi_CSVL"
        self.jb1phi_CSVL_branch = the_tree.GetBranch("jb1phi_CSVL")
        #if not self.jb1phi_CSVL_branch and "jb1phi_CSVL" not in self.complained:
        if not self.jb1phi_CSVL_branch and "jb1phi_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb1phi_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_CSVL")
        else:
            self.jb1phi_CSVL_branch.SetAddress(<void*>&self.jb1phi_CSVL_value)

        #print "making jb1pt"
        self.jb1pt_branch = the_tree.GetBranch("jb1pt")
        #if not self.jb1pt_branch and "jb1pt" not in self.complained:
        if not self.jb1pt_branch and "jb1pt":
            warnings.warn( "MuMuMuTree: Expected branch jb1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt")
        else:
            self.jb1pt_branch.SetAddress(<void*>&self.jb1pt_value)

        #print "making jb1ptDown"
        self.jb1ptDown_branch = the_tree.GetBranch("jb1ptDown")
        #if not self.jb1ptDown_branch and "jb1ptDown" not in self.complained:
        if not self.jb1ptDown_branch and "jb1ptDown":
            warnings.warn( "MuMuMuTree: Expected branch jb1ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptDown")
        else:
            self.jb1ptDown_branch.SetAddress(<void*>&self.jb1ptDown_value)

        #print "making jb1ptDown_CSVL"
        self.jb1ptDown_CSVL_branch = the_tree.GetBranch("jb1ptDown_CSVL")
        #if not self.jb1ptDown_CSVL_branch and "jb1ptDown_CSVL" not in self.complained:
        if not self.jb1ptDown_CSVL_branch and "jb1ptDown_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb1ptDown_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptDown_CSVL")
        else:
            self.jb1ptDown_CSVL_branch.SetAddress(<void*>&self.jb1ptDown_CSVL_value)

        #print "making jb1ptUp"
        self.jb1ptUp_branch = the_tree.GetBranch("jb1ptUp")
        #if not self.jb1ptUp_branch and "jb1ptUp" not in self.complained:
        if not self.jb1ptUp_branch and "jb1ptUp":
            warnings.warn( "MuMuMuTree: Expected branch jb1ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptUp")
        else:
            self.jb1ptUp_branch.SetAddress(<void*>&self.jb1ptUp_value)

        #print "making jb1ptUp_CSVL"
        self.jb1ptUp_CSVL_branch = the_tree.GetBranch("jb1ptUp_CSVL")
        #if not self.jb1ptUp_CSVL_branch and "jb1ptUp_CSVL" not in self.complained:
        if not self.jb1ptUp_CSVL_branch and "jb1ptUp_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb1ptUp_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptUp_CSVL")
        else:
            self.jb1ptUp_CSVL_branch.SetAddress(<void*>&self.jb1ptUp_CSVL_value)

        #print "making jb1pt_CSVL"
        self.jb1pt_CSVL_branch = the_tree.GetBranch("jb1pt_CSVL")
        #if not self.jb1pt_CSVL_branch and "jb1pt_CSVL" not in self.complained:
        if not self.jb1pt_CSVL_branch and "jb1pt_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb1pt_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_CSVL")
        else:
            self.jb1pt_CSVL_branch.SetAddress(<void*>&self.jb1pt_CSVL_value)

        #print "making jb1pu"
        self.jb1pu_branch = the_tree.GetBranch("jb1pu")
        #if not self.jb1pu_branch and "jb1pu" not in self.complained:
        if not self.jb1pu_branch and "jb1pu":
            warnings.warn( "MuMuMuTree: Expected branch jb1pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pu")
        else:
            self.jb1pu_branch.SetAddress(<void*>&self.jb1pu_value)

        #print "making jb1pu_CSVL"
        self.jb1pu_CSVL_branch = the_tree.GetBranch("jb1pu_CSVL")
        #if not self.jb1pu_CSVL_branch and "jb1pu_CSVL" not in self.complained:
        if not self.jb1pu_CSVL_branch and "jb1pu_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb1pu_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pu_CSVL")
        else:
            self.jb1pu_CSVL_branch.SetAddress(<void*>&self.jb1pu_CSVL_value)

        #print "making jb1rawf"
        self.jb1rawf_branch = the_tree.GetBranch("jb1rawf")
        #if not self.jb1rawf_branch and "jb1rawf" not in self.complained:
        if not self.jb1rawf_branch and "jb1rawf":
            warnings.warn( "MuMuMuTree: Expected branch jb1rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1rawf")
        else:
            self.jb1rawf_branch.SetAddress(<void*>&self.jb1rawf_value)

        #print "making jb1rawf_CSVL"
        self.jb1rawf_CSVL_branch = the_tree.GetBranch("jb1rawf_CSVL")
        #if not self.jb1rawf_CSVL_branch and "jb1rawf_CSVL" not in self.complained:
        if not self.jb1rawf_CSVL_branch and "jb1rawf_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb1rawf_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1rawf_CSVL")
        else:
            self.jb1rawf_CSVL_branch.SetAddress(<void*>&self.jb1rawf_CSVL_value)

        #print "making jb2csv"
        self.jb2csv_branch = the_tree.GetBranch("jb2csv")
        #if not self.jb2csv_branch and "jb2csv" not in self.complained:
        if not self.jb2csv_branch and "jb2csv":
            warnings.warn( "MuMuMuTree: Expected branch jb2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csv")
        else:
            self.jb2csv_branch.SetAddress(<void*>&self.jb2csv_value)

        #print "making jb2csv_CSVL"
        self.jb2csv_CSVL_branch = the_tree.GetBranch("jb2csv_CSVL")
        #if not self.jb2csv_CSVL_branch and "jb2csv_CSVL" not in self.complained:
        if not self.jb2csv_CSVL_branch and "jb2csv_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb2csv_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csv_CSVL")
        else:
            self.jb2csv_CSVL_branch.SetAddress(<void*>&self.jb2csv_CSVL_value)

        #print "making jb2eta"
        self.jb2eta_branch = the_tree.GetBranch("jb2eta")
        #if not self.jb2eta_branch and "jb2eta" not in self.complained:
        if not self.jb2eta_branch and "jb2eta":
            warnings.warn( "MuMuMuTree: Expected branch jb2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta")
        else:
            self.jb2eta_branch.SetAddress(<void*>&self.jb2eta_value)

        #print "making jb2eta_CSVL"
        self.jb2eta_CSVL_branch = the_tree.GetBranch("jb2eta_CSVL")
        #if not self.jb2eta_CSVL_branch and "jb2eta_CSVL" not in self.complained:
        if not self.jb2eta_CSVL_branch and "jb2eta_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb2eta_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_CSVL")
        else:
            self.jb2eta_CSVL_branch.SetAddress(<void*>&self.jb2eta_CSVL_value)

        #print "making jb2hadronflavor"
        self.jb2hadronflavor_branch = the_tree.GetBranch("jb2hadronflavor")
        #if not self.jb2hadronflavor_branch and "jb2hadronflavor" not in self.complained:
        if not self.jb2hadronflavor_branch and "jb2hadronflavor":
            warnings.warn( "MuMuMuTree: Expected branch jb2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor")
        else:
            self.jb2hadronflavor_branch.SetAddress(<void*>&self.jb2hadronflavor_value)

        #print "making jb2hadronflavor_CSVL"
        self.jb2hadronflavor_CSVL_branch = the_tree.GetBranch("jb2hadronflavor_CSVL")
        #if not self.jb2hadronflavor_CSVL_branch and "jb2hadronflavor_CSVL" not in self.complained:
        if not self.jb2hadronflavor_CSVL_branch and "jb2hadronflavor_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb2hadronflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_CSVL")
        else:
            self.jb2hadronflavor_CSVL_branch.SetAddress(<void*>&self.jb2hadronflavor_CSVL_value)

        #print "making jb2partonflavor"
        self.jb2partonflavor_branch = the_tree.GetBranch("jb2partonflavor")
        #if not self.jb2partonflavor_branch and "jb2partonflavor" not in self.complained:
        if not self.jb2partonflavor_branch and "jb2partonflavor":
            warnings.warn( "MuMuMuTree: Expected branch jb2partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2partonflavor")
        else:
            self.jb2partonflavor_branch.SetAddress(<void*>&self.jb2partonflavor_value)

        #print "making jb2partonflavor_CSVL"
        self.jb2partonflavor_CSVL_branch = the_tree.GetBranch("jb2partonflavor_CSVL")
        #if not self.jb2partonflavor_CSVL_branch and "jb2partonflavor_CSVL" not in self.complained:
        if not self.jb2partonflavor_CSVL_branch and "jb2partonflavor_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb2partonflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2partonflavor_CSVL")
        else:
            self.jb2partonflavor_CSVL_branch.SetAddress(<void*>&self.jb2partonflavor_CSVL_value)

        #print "making jb2phi"
        self.jb2phi_branch = the_tree.GetBranch("jb2phi")
        #if not self.jb2phi_branch and "jb2phi" not in self.complained:
        if not self.jb2phi_branch and "jb2phi":
            warnings.warn( "MuMuMuTree: Expected branch jb2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi")
        else:
            self.jb2phi_branch.SetAddress(<void*>&self.jb2phi_value)

        #print "making jb2phi_CSVL"
        self.jb2phi_CSVL_branch = the_tree.GetBranch("jb2phi_CSVL")
        #if not self.jb2phi_CSVL_branch and "jb2phi_CSVL" not in self.complained:
        if not self.jb2phi_CSVL_branch and "jb2phi_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb2phi_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_CSVL")
        else:
            self.jb2phi_CSVL_branch.SetAddress(<void*>&self.jb2phi_CSVL_value)

        #print "making jb2pt"
        self.jb2pt_branch = the_tree.GetBranch("jb2pt")
        #if not self.jb2pt_branch and "jb2pt" not in self.complained:
        if not self.jb2pt_branch and "jb2pt":
            warnings.warn( "MuMuMuTree: Expected branch jb2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt")
        else:
            self.jb2pt_branch.SetAddress(<void*>&self.jb2pt_value)

        #print "making jb2ptDown"
        self.jb2ptDown_branch = the_tree.GetBranch("jb2ptDown")
        #if not self.jb2ptDown_branch and "jb2ptDown" not in self.complained:
        if not self.jb2ptDown_branch and "jb2ptDown":
            warnings.warn( "MuMuMuTree: Expected branch jb2ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptDown")
        else:
            self.jb2ptDown_branch.SetAddress(<void*>&self.jb2ptDown_value)

        #print "making jb2ptDown_CSVL"
        self.jb2ptDown_CSVL_branch = the_tree.GetBranch("jb2ptDown_CSVL")
        #if not self.jb2ptDown_CSVL_branch and "jb2ptDown_CSVL" not in self.complained:
        if not self.jb2ptDown_CSVL_branch and "jb2ptDown_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb2ptDown_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptDown_CSVL")
        else:
            self.jb2ptDown_CSVL_branch.SetAddress(<void*>&self.jb2ptDown_CSVL_value)

        #print "making jb2ptUp"
        self.jb2ptUp_branch = the_tree.GetBranch("jb2ptUp")
        #if not self.jb2ptUp_branch and "jb2ptUp" not in self.complained:
        if not self.jb2ptUp_branch and "jb2ptUp":
            warnings.warn( "MuMuMuTree: Expected branch jb2ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptUp")
        else:
            self.jb2ptUp_branch.SetAddress(<void*>&self.jb2ptUp_value)

        #print "making jb2ptUp_CSVL"
        self.jb2ptUp_CSVL_branch = the_tree.GetBranch("jb2ptUp_CSVL")
        #if not self.jb2ptUp_CSVL_branch and "jb2ptUp_CSVL" not in self.complained:
        if not self.jb2ptUp_CSVL_branch and "jb2ptUp_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb2ptUp_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptUp_CSVL")
        else:
            self.jb2ptUp_CSVL_branch.SetAddress(<void*>&self.jb2ptUp_CSVL_value)

        #print "making jb2pt_CSVL"
        self.jb2pt_CSVL_branch = the_tree.GetBranch("jb2pt_CSVL")
        #if not self.jb2pt_CSVL_branch and "jb2pt_CSVL" not in self.complained:
        if not self.jb2pt_CSVL_branch and "jb2pt_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb2pt_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_CSVL")
        else:
            self.jb2pt_CSVL_branch.SetAddress(<void*>&self.jb2pt_CSVL_value)

        #print "making jb2pu"
        self.jb2pu_branch = the_tree.GetBranch("jb2pu")
        #if not self.jb2pu_branch and "jb2pu" not in self.complained:
        if not self.jb2pu_branch and "jb2pu":
            warnings.warn( "MuMuMuTree: Expected branch jb2pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pu")
        else:
            self.jb2pu_branch.SetAddress(<void*>&self.jb2pu_value)

        #print "making jb2pu_CSVL"
        self.jb2pu_CSVL_branch = the_tree.GetBranch("jb2pu_CSVL")
        #if not self.jb2pu_CSVL_branch and "jb2pu_CSVL" not in self.complained:
        if not self.jb2pu_CSVL_branch and "jb2pu_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb2pu_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pu_CSVL")
        else:
            self.jb2pu_CSVL_branch.SetAddress(<void*>&self.jb2pu_CSVL_value)

        #print "making jb2rawf"
        self.jb2rawf_branch = the_tree.GetBranch("jb2rawf")
        #if not self.jb2rawf_branch and "jb2rawf" not in self.complained:
        if not self.jb2rawf_branch and "jb2rawf":
            warnings.warn( "MuMuMuTree: Expected branch jb2rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2rawf")
        else:
            self.jb2rawf_branch.SetAddress(<void*>&self.jb2rawf_value)

        #print "making jb2rawf_CSVL"
        self.jb2rawf_CSVL_branch = the_tree.GetBranch("jb2rawf_CSVL")
        #if not self.jb2rawf_CSVL_branch and "jb2rawf_CSVL" not in self.complained:
        if not self.jb2rawf_CSVL_branch and "jb2rawf_CSVL":
            warnings.warn( "MuMuMuTree: Expected branch jb2rawf_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2rawf_CSVL")
        else:
            self.jb2rawf_CSVL_branch.SetAddress(<void*>&self.jb2rawf_CSVL_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "MuMuMuTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making m1AbsEta"
        self.m1AbsEta_branch = the_tree.GetBranch("m1AbsEta")
        #if not self.m1AbsEta_branch and "m1AbsEta" not in self.complained:
        if not self.m1AbsEta_branch and "m1AbsEta":
            warnings.warn( "MuMuMuTree: Expected branch m1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1AbsEta")
        else:
            self.m1AbsEta_branch.SetAddress(<void*>&self.m1AbsEta_value)

        #print "making m1BestTrackType"
        self.m1BestTrackType_branch = the_tree.GetBranch("m1BestTrackType")
        #if not self.m1BestTrackType_branch and "m1BestTrackType" not in self.complained:
        if not self.m1BestTrackType_branch and "m1BestTrackType":
            warnings.warn( "MuMuMuTree: Expected branch m1BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1BestTrackType")
        else:
            self.m1BestTrackType_branch.SetAddress(<void*>&self.m1BestTrackType_value)

        #print "making m1Charge"
        self.m1Charge_branch = the_tree.GetBranch("m1Charge")
        #if not self.m1Charge_branch and "m1Charge" not in self.complained:
        if not self.m1Charge_branch and "m1Charge":
            warnings.warn( "MuMuMuTree: Expected branch m1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Charge")
        else:
            self.m1Charge_branch.SetAddress(<void*>&self.m1Charge_value)

        #print "making m1Chi2LocalPosition"
        self.m1Chi2LocalPosition_branch = the_tree.GetBranch("m1Chi2LocalPosition")
        #if not self.m1Chi2LocalPosition_branch and "m1Chi2LocalPosition" not in self.complained:
        if not self.m1Chi2LocalPosition_branch and "m1Chi2LocalPosition":
            warnings.warn( "MuMuMuTree: Expected branch m1Chi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Chi2LocalPosition")
        else:
            self.m1Chi2LocalPosition_branch.SetAddress(<void*>&self.m1Chi2LocalPosition_value)

        #print "making m1ComesFromHiggs"
        self.m1ComesFromHiggs_branch = the_tree.GetBranch("m1ComesFromHiggs")
        #if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs" not in self.complained:
        if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs":
            warnings.warn( "MuMuMuTree: Expected branch m1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ComesFromHiggs")
        else:
            self.m1ComesFromHiggs_branch.SetAddress(<void*>&self.m1ComesFromHiggs_value)

        #print "making m1DPhiToPfMet_ElectronEnDown"
        self.m1DPhiToPfMet_ElectronEnDown_branch = the_tree.GetBranch("m1DPhiToPfMet_ElectronEnDown")
        #if not self.m1DPhiToPfMet_ElectronEnDown_branch and "m1DPhiToPfMet_ElectronEnDown" not in self.complained:
        if not self.m1DPhiToPfMet_ElectronEnDown_branch and "m1DPhiToPfMet_ElectronEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_ElectronEnDown")
        else:
            self.m1DPhiToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_ElectronEnDown_value)

        #print "making m1DPhiToPfMet_ElectronEnUp"
        self.m1DPhiToPfMet_ElectronEnUp_branch = the_tree.GetBranch("m1DPhiToPfMet_ElectronEnUp")
        #if not self.m1DPhiToPfMet_ElectronEnUp_branch and "m1DPhiToPfMet_ElectronEnUp" not in self.complained:
        if not self.m1DPhiToPfMet_ElectronEnUp_branch and "m1DPhiToPfMet_ElectronEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_ElectronEnUp")
        else:
            self.m1DPhiToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_ElectronEnUp_value)

        #print "making m1DPhiToPfMet_JetEnDown"
        self.m1DPhiToPfMet_JetEnDown_branch = the_tree.GetBranch("m1DPhiToPfMet_JetEnDown")
        #if not self.m1DPhiToPfMet_JetEnDown_branch and "m1DPhiToPfMet_JetEnDown" not in self.complained:
        if not self.m1DPhiToPfMet_JetEnDown_branch and "m1DPhiToPfMet_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_JetEnDown")
        else:
            self.m1DPhiToPfMet_JetEnDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_JetEnDown_value)

        #print "making m1DPhiToPfMet_JetEnUp"
        self.m1DPhiToPfMet_JetEnUp_branch = the_tree.GetBranch("m1DPhiToPfMet_JetEnUp")
        #if not self.m1DPhiToPfMet_JetEnUp_branch and "m1DPhiToPfMet_JetEnUp" not in self.complained:
        if not self.m1DPhiToPfMet_JetEnUp_branch and "m1DPhiToPfMet_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_JetEnUp")
        else:
            self.m1DPhiToPfMet_JetEnUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_JetEnUp_value)

        #print "making m1DPhiToPfMet_JetResDown"
        self.m1DPhiToPfMet_JetResDown_branch = the_tree.GetBranch("m1DPhiToPfMet_JetResDown")
        #if not self.m1DPhiToPfMet_JetResDown_branch and "m1DPhiToPfMet_JetResDown" not in self.complained:
        if not self.m1DPhiToPfMet_JetResDown_branch and "m1DPhiToPfMet_JetResDown":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_JetResDown")
        else:
            self.m1DPhiToPfMet_JetResDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_JetResDown_value)

        #print "making m1DPhiToPfMet_JetResUp"
        self.m1DPhiToPfMet_JetResUp_branch = the_tree.GetBranch("m1DPhiToPfMet_JetResUp")
        #if not self.m1DPhiToPfMet_JetResUp_branch and "m1DPhiToPfMet_JetResUp" not in self.complained:
        if not self.m1DPhiToPfMet_JetResUp_branch and "m1DPhiToPfMet_JetResUp":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_JetResUp")
        else:
            self.m1DPhiToPfMet_JetResUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_JetResUp_value)

        #print "making m1DPhiToPfMet_MuonEnDown"
        self.m1DPhiToPfMet_MuonEnDown_branch = the_tree.GetBranch("m1DPhiToPfMet_MuonEnDown")
        #if not self.m1DPhiToPfMet_MuonEnDown_branch and "m1DPhiToPfMet_MuonEnDown" not in self.complained:
        if not self.m1DPhiToPfMet_MuonEnDown_branch and "m1DPhiToPfMet_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_MuonEnDown")
        else:
            self.m1DPhiToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_MuonEnDown_value)

        #print "making m1DPhiToPfMet_MuonEnUp"
        self.m1DPhiToPfMet_MuonEnUp_branch = the_tree.GetBranch("m1DPhiToPfMet_MuonEnUp")
        #if not self.m1DPhiToPfMet_MuonEnUp_branch and "m1DPhiToPfMet_MuonEnUp" not in self.complained:
        if not self.m1DPhiToPfMet_MuonEnUp_branch and "m1DPhiToPfMet_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_MuonEnUp")
        else:
            self.m1DPhiToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_MuonEnUp_value)

        #print "making m1DPhiToPfMet_PhotonEnDown"
        self.m1DPhiToPfMet_PhotonEnDown_branch = the_tree.GetBranch("m1DPhiToPfMet_PhotonEnDown")
        #if not self.m1DPhiToPfMet_PhotonEnDown_branch and "m1DPhiToPfMet_PhotonEnDown" not in self.complained:
        if not self.m1DPhiToPfMet_PhotonEnDown_branch and "m1DPhiToPfMet_PhotonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_PhotonEnDown")
        else:
            self.m1DPhiToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_PhotonEnDown_value)

        #print "making m1DPhiToPfMet_PhotonEnUp"
        self.m1DPhiToPfMet_PhotonEnUp_branch = the_tree.GetBranch("m1DPhiToPfMet_PhotonEnUp")
        #if not self.m1DPhiToPfMet_PhotonEnUp_branch and "m1DPhiToPfMet_PhotonEnUp" not in self.complained:
        if not self.m1DPhiToPfMet_PhotonEnUp_branch and "m1DPhiToPfMet_PhotonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_PhotonEnUp")
        else:
            self.m1DPhiToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_PhotonEnUp_value)

        #print "making m1DPhiToPfMet_TauEnDown"
        self.m1DPhiToPfMet_TauEnDown_branch = the_tree.GetBranch("m1DPhiToPfMet_TauEnDown")
        #if not self.m1DPhiToPfMet_TauEnDown_branch and "m1DPhiToPfMet_TauEnDown" not in self.complained:
        if not self.m1DPhiToPfMet_TauEnDown_branch and "m1DPhiToPfMet_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_TauEnDown")
        else:
            self.m1DPhiToPfMet_TauEnDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_TauEnDown_value)

        #print "making m1DPhiToPfMet_TauEnUp"
        self.m1DPhiToPfMet_TauEnUp_branch = the_tree.GetBranch("m1DPhiToPfMet_TauEnUp")
        #if not self.m1DPhiToPfMet_TauEnUp_branch and "m1DPhiToPfMet_TauEnUp" not in self.complained:
        if not self.m1DPhiToPfMet_TauEnUp_branch and "m1DPhiToPfMet_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_TauEnUp")
        else:
            self.m1DPhiToPfMet_TauEnUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_TauEnUp_value)

        #print "making m1DPhiToPfMet_UnclusteredEnDown"
        self.m1DPhiToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("m1DPhiToPfMet_UnclusteredEnDown")
        #if not self.m1DPhiToPfMet_UnclusteredEnDown_branch and "m1DPhiToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.m1DPhiToPfMet_UnclusteredEnDown_branch and "m1DPhiToPfMet_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_UnclusteredEnDown")
        else:
            self.m1DPhiToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_UnclusteredEnDown_value)

        #print "making m1DPhiToPfMet_UnclusteredEnUp"
        self.m1DPhiToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("m1DPhiToPfMet_UnclusteredEnUp")
        #if not self.m1DPhiToPfMet_UnclusteredEnUp_branch and "m1DPhiToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.m1DPhiToPfMet_UnclusteredEnUp_branch and "m1DPhiToPfMet_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_UnclusteredEnUp")
        else:
            self.m1DPhiToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_UnclusteredEnUp_value)

        #print "making m1DPhiToPfMet_type1"
        self.m1DPhiToPfMet_type1_branch = the_tree.GetBranch("m1DPhiToPfMet_type1")
        #if not self.m1DPhiToPfMet_type1_branch and "m1DPhiToPfMet_type1" not in self.complained:
        if not self.m1DPhiToPfMet_type1_branch and "m1DPhiToPfMet_type1":
            warnings.warn( "MuMuMuTree: Expected branch m1DPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_type1")
        else:
            self.m1DPhiToPfMet_type1_branch.SetAddress(<void*>&self.m1DPhiToPfMet_type1_value)

        #print "making m1EcalIsoDR03"
        self.m1EcalIsoDR03_branch = the_tree.GetBranch("m1EcalIsoDR03")
        #if not self.m1EcalIsoDR03_branch and "m1EcalIsoDR03" not in self.complained:
        if not self.m1EcalIsoDR03_branch and "m1EcalIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EcalIsoDR03")
        else:
            self.m1EcalIsoDR03_branch.SetAddress(<void*>&self.m1EcalIsoDR03_value)

        #print "making m1EffectiveArea2011"
        self.m1EffectiveArea2011_branch = the_tree.GetBranch("m1EffectiveArea2011")
        #if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011" not in self.complained:
        if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011":
            warnings.warn( "MuMuMuTree: Expected branch m1EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2011")
        else:
            self.m1EffectiveArea2011_branch.SetAddress(<void*>&self.m1EffectiveArea2011_value)

        #print "making m1EffectiveArea2012"
        self.m1EffectiveArea2012_branch = the_tree.GetBranch("m1EffectiveArea2012")
        #if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012" not in self.complained:
        if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012":
            warnings.warn( "MuMuMuTree: Expected branch m1EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2012")
        else:
            self.m1EffectiveArea2012_branch.SetAddress(<void*>&self.m1EffectiveArea2012_value)

        #print "making m1ErsatzGenEta"
        self.m1ErsatzGenEta_branch = the_tree.GetBranch("m1ErsatzGenEta")
        #if not self.m1ErsatzGenEta_branch and "m1ErsatzGenEta" not in self.complained:
        if not self.m1ErsatzGenEta_branch and "m1ErsatzGenEta":
            warnings.warn( "MuMuMuTree: Expected branch m1ErsatzGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenEta")
        else:
            self.m1ErsatzGenEta_branch.SetAddress(<void*>&self.m1ErsatzGenEta_value)

        #print "making m1ErsatzGenM"
        self.m1ErsatzGenM_branch = the_tree.GetBranch("m1ErsatzGenM")
        #if not self.m1ErsatzGenM_branch and "m1ErsatzGenM" not in self.complained:
        if not self.m1ErsatzGenM_branch and "m1ErsatzGenM":
            warnings.warn( "MuMuMuTree: Expected branch m1ErsatzGenM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenM")
        else:
            self.m1ErsatzGenM_branch.SetAddress(<void*>&self.m1ErsatzGenM_value)

        #print "making m1ErsatzGenPhi"
        self.m1ErsatzGenPhi_branch = the_tree.GetBranch("m1ErsatzGenPhi")
        #if not self.m1ErsatzGenPhi_branch and "m1ErsatzGenPhi" not in self.complained:
        if not self.m1ErsatzGenPhi_branch and "m1ErsatzGenPhi":
            warnings.warn( "MuMuMuTree: Expected branch m1ErsatzGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenPhi")
        else:
            self.m1ErsatzGenPhi_branch.SetAddress(<void*>&self.m1ErsatzGenPhi_value)

        #print "making m1ErsatzGenpT"
        self.m1ErsatzGenpT_branch = the_tree.GetBranch("m1ErsatzGenpT")
        #if not self.m1ErsatzGenpT_branch and "m1ErsatzGenpT" not in self.complained:
        if not self.m1ErsatzGenpT_branch and "m1ErsatzGenpT":
            warnings.warn( "MuMuMuTree: Expected branch m1ErsatzGenpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenpT")
        else:
            self.m1ErsatzGenpT_branch.SetAddress(<void*>&self.m1ErsatzGenpT_value)

        #print "making m1ErsatzGenpX"
        self.m1ErsatzGenpX_branch = the_tree.GetBranch("m1ErsatzGenpX")
        #if not self.m1ErsatzGenpX_branch and "m1ErsatzGenpX" not in self.complained:
        if not self.m1ErsatzGenpX_branch and "m1ErsatzGenpX":
            warnings.warn( "MuMuMuTree: Expected branch m1ErsatzGenpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenpX")
        else:
            self.m1ErsatzGenpX_branch.SetAddress(<void*>&self.m1ErsatzGenpX_value)

        #print "making m1ErsatzGenpY"
        self.m1ErsatzGenpY_branch = the_tree.GetBranch("m1ErsatzGenpY")
        #if not self.m1ErsatzGenpY_branch and "m1ErsatzGenpY" not in self.complained:
        if not self.m1ErsatzGenpY_branch and "m1ErsatzGenpY":
            warnings.warn( "MuMuMuTree: Expected branch m1ErsatzGenpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenpY")
        else:
            self.m1ErsatzGenpY_branch.SetAddress(<void*>&self.m1ErsatzGenpY_value)

        #print "making m1ErsatzVispX"
        self.m1ErsatzVispX_branch = the_tree.GetBranch("m1ErsatzVispX")
        #if not self.m1ErsatzVispX_branch and "m1ErsatzVispX" not in self.complained:
        if not self.m1ErsatzVispX_branch and "m1ErsatzVispX":
            warnings.warn( "MuMuMuTree: Expected branch m1ErsatzVispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzVispX")
        else:
            self.m1ErsatzVispX_branch.SetAddress(<void*>&self.m1ErsatzVispX_value)

        #print "making m1ErsatzVispY"
        self.m1ErsatzVispY_branch = the_tree.GetBranch("m1ErsatzVispY")
        #if not self.m1ErsatzVispY_branch and "m1ErsatzVispY" not in self.complained:
        if not self.m1ErsatzVispY_branch and "m1ErsatzVispY":
            warnings.warn( "MuMuMuTree: Expected branch m1ErsatzVispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzVispY")
        else:
            self.m1ErsatzVispY_branch.SetAddress(<void*>&self.m1ErsatzVispY_value)

        #print "making m1Eta"
        self.m1Eta_branch = the_tree.GetBranch("m1Eta")
        #if not self.m1Eta_branch and "m1Eta" not in self.complained:
        if not self.m1Eta_branch and "m1Eta":
            warnings.warn( "MuMuMuTree: Expected branch m1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta")
        else:
            self.m1Eta_branch.SetAddress(<void*>&self.m1Eta_value)

        #print "making m1Eta_MuonEnDown"
        self.m1Eta_MuonEnDown_branch = the_tree.GetBranch("m1Eta_MuonEnDown")
        #if not self.m1Eta_MuonEnDown_branch and "m1Eta_MuonEnDown" not in self.complained:
        if not self.m1Eta_MuonEnDown_branch and "m1Eta_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1Eta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta_MuonEnDown")
        else:
            self.m1Eta_MuonEnDown_branch.SetAddress(<void*>&self.m1Eta_MuonEnDown_value)

        #print "making m1Eta_MuonEnUp"
        self.m1Eta_MuonEnUp_branch = the_tree.GetBranch("m1Eta_MuonEnUp")
        #if not self.m1Eta_MuonEnUp_branch and "m1Eta_MuonEnUp" not in self.complained:
        if not self.m1Eta_MuonEnUp_branch and "m1Eta_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1Eta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta_MuonEnUp")
        else:
            self.m1Eta_MuonEnUp_branch.SetAddress(<void*>&self.m1Eta_MuonEnUp_value)

        #print "making m1GenCharge"
        self.m1GenCharge_branch = the_tree.GetBranch("m1GenCharge")
        #if not self.m1GenCharge_branch and "m1GenCharge" not in self.complained:
        if not self.m1GenCharge_branch and "m1GenCharge":
            warnings.warn( "MuMuMuTree: Expected branch m1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenCharge")
        else:
            self.m1GenCharge_branch.SetAddress(<void*>&self.m1GenCharge_value)

        #print "making m1GenDirectPromptTauDecayFinalState"
        self.m1GenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("m1GenDirectPromptTauDecayFinalState")
        #if not self.m1GenDirectPromptTauDecayFinalState_branch and "m1GenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.m1GenDirectPromptTauDecayFinalState_branch and "m1GenDirectPromptTauDecayFinalState":
            warnings.warn( "MuMuMuTree: Expected branch m1GenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenDirectPromptTauDecayFinalState")
        else:
            self.m1GenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.m1GenDirectPromptTauDecayFinalState_value)

        #print "making m1GenEnergy"
        self.m1GenEnergy_branch = the_tree.GetBranch("m1GenEnergy")
        #if not self.m1GenEnergy_branch and "m1GenEnergy" not in self.complained:
        if not self.m1GenEnergy_branch and "m1GenEnergy":
            warnings.warn( "MuMuMuTree: Expected branch m1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEnergy")
        else:
            self.m1GenEnergy_branch.SetAddress(<void*>&self.m1GenEnergy_value)

        #print "making m1GenEta"
        self.m1GenEta_branch = the_tree.GetBranch("m1GenEta")
        #if not self.m1GenEta_branch and "m1GenEta" not in self.complained:
        if not self.m1GenEta_branch and "m1GenEta":
            warnings.warn( "MuMuMuTree: Expected branch m1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEta")
        else:
            self.m1GenEta_branch.SetAddress(<void*>&self.m1GenEta_value)

        #print "making m1GenIsPrompt"
        self.m1GenIsPrompt_branch = the_tree.GetBranch("m1GenIsPrompt")
        #if not self.m1GenIsPrompt_branch and "m1GenIsPrompt" not in self.complained:
        if not self.m1GenIsPrompt_branch and "m1GenIsPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m1GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenIsPrompt")
        else:
            self.m1GenIsPrompt_branch.SetAddress(<void*>&self.m1GenIsPrompt_value)

        #print "making m1GenMotherPdgId"
        self.m1GenMotherPdgId_branch = the_tree.GetBranch("m1GenMotherPdgId")
        #if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId" not in self.complained:
        if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId":
            warnings.warn( "MuMuMuTree: Expected branch m1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenMotherPdgId")
        else:
            self.m1GenMotherPdgId_branch.SetAddress(<void*>&self.m1GenMotherPdgId_value)

        #print "making m1GenParticle"
        self.m1GenParticle_branch = the_tree.GetBranch("m1GenParticle")
        #if not self.m1GenParticle_branch and "m1GenParticle" not in self.complained:
        if not self.m1GenParticle_branch and "m1GenParticle":
            warnings.warn( "MuMuMuTree: Expected branch m1GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenParticle")
        else:
            self.m1GenParticle_branch.SetAddress(<void*>&self.m1GenParticle_value)

        #print "making m1GenPdgId"
        self.m1GenPdgId_branch = the_tree.GetBranch("m1GenPdgId")
        #if not self.m1GenPdgId_branch and "m1GenPdgId" not in self.complained:
        if not self.m1GenPdgId_branch and "m1GenPdgId":
            warnings.warn( "MuMuMuTree: Expected branch m1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPdgId")
        else:
            self.m1GenPdgId_branch.SetAddress(<void*>&self.m1GenPdgId_value)

        #print "making m1GenPhi"
        self.m1GenPhi_branch = the_tree.GetBranch("m1GenPhi")
        #if not self.m1GenPhi_branch and "m1GenPhi" not in self.complained:
        if not self.m1GenPhi_branch and "m1GenPhi":
            warnings.warn( "MuMuMuTree: Expected branch m1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPhi")
        else:
            self.m1GenPhi_branch.SetAddress(<void*>&self.m1GenPhi_value)

        #print "making m1GenPrompt"
        self.m1GenPrompt_branch = the_tree.GetBranch("m1GenPrompt")
        #if not self.m1GenPrompt_branch and "m1GenPrompt" not in self.complained:
        if not self.m1GenPrompt_branch and "m1GenPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m1GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPrompt")
        else:
            self.m1GenPrompt_branch.SetAddress(<void*>&self.m1GenPrompt_value)

        #print "making m1GenPromptFinalState"
        self.m1GenPromptFinalState_branch = the_tree.GetBranch("m1GenPromptFinalState")
        #if not self.m1GenPromptFinalState_branch and "m1GenPromptFinalState" not in self.complained:
        if not self.m1GenPromptFinalState_branch and "m1GenPromptFinalState":
            warnings.warn( "MuMuMuTree: Expected branch m1GenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPromptFinalState")
        else:
            self.m1GenPromptFinalState_branch.SetAddress(<void*>&self.m1GenPromptFinalState_value)

        #print "making m1GenPromptTauDecay"
        self.m1GenPromptTauDecay_branch = the_tree.GetBranch("m1GenPromptTauDecay")
        #if not self.m1GenPromptTauDecay_branch and "m1GenPromptTauDecay" not in self.complained:
        if not self.m1GenPromptTauDecay_branch and "m1GenPromptTauDecay":
            warnings.warn( "MuMuMuTree: Expected branch m1GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPromptTauDecay")
        else:
            self.m1GenPromptTauDecay_branch.SetAddress(<void*>&self.m1GenPromptTauDecay_value)

        #print "making m1GenPt"
        self.m1GenPt_branch = the_tree.GetBranch("m1GenPt")
        #if not self.m1GenPt_branch and "m1GenPt" not in self.complained:
        if not self.m1GenPt_branch and "m1GenPt":
            warnings.warn( "MuMuMuTree: Expected branch m1GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPt")
        else:
            self.m1GenPt_branch.SetAddress(<void*>&self.m1GenPt_value)

        #print "making m1GenTauDecay"
        self.m1GenTauDecay_branch = the_tree.GetBranch("m1GenTauDecay")
        #if not self.m1GenTauDecay_branch and "m1GenTauDecay" not in self.complained:
        if not self.m1GenTauDecay_branch and "m1GenTauDecay":
            warnings.warn( "MuMuMuTree: Expected branch m1GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenTauDecay")
        else:
            self.m1GenTauDecay_branch.SetAddress(<void*>&self.m1GenTauDecay_value)

        #print "making m1GenVZ"
        self.m1GenVZ_branch = the_tree.GetBranch("m1GenVZ")
        #if not self.m1GenVZ_branch and "m1GenVZ" not in self.complained:
        if not self.m1GenVZ_branch and "m1GenVZ":
            warnings.warn( "MuMuMuTree: Expected branch m1GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenVZ")
        else:
            self.m1GenVZ_branch.SetAddress(<void*>&self.m1GenVZ_value)

        #print "making m1GenVtxPVMatch"
        self.m1GenVtxPVMatch_branch = the_tree.GetBranch("m1GenVtxPVMatch")
        #if not self.m1GenVtxPVMatch_branch and "m1GenVtxPVMatch" not in self.complained:
        if not self.m1GenVtxPVMatch_branch and "m1GenVtxPVMatch":
            warnings.warn( "MuMuMuTree: Expected branch m1GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenVtxPVMatch")
        else:
            self.m1GenVtxPVMatch_branch.SetAddress(<void*>&self.m1GenVtxPVMatch_value)

        #print "making m1HcalIsoDR03"
        self.m1HcalIsoDR03_branch = the_tree.GetBranch("m1HcalIsoDR03")
        #if not self.m1HcalIsoDR03_branch and "m1HcalIsoDR03" not in self.complained:
        if not self.m1HcalIsoDR03_branch and "m1HcalIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1HcalIsoDR03")
        else:
            self.m1HcalIsoDR03_branch.SetAddress(<void*>&self.m1HcalIsoDR03_value)

        #print "making m1IP3D"
        self.m1IP3D_branch = the_tree.GetBranch("m1IP3D")
        #if not self.m1IP3D_branch and "m1IP3D" not in self.complained:
        if not self.m1IP3D_branch and "m1IP3D":
            warnings.warn( "MuMuMuTree: Expected branch m1IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3D")
        else:
            self.m1IP3D_branch.SetAddress(<void*>&self.m1IP3D_value)

        #print "making m1IP3DErr"
        self.m1IP3DErr_branch = the_tree.GetBranch("m1IP3DErr")
        #if not self.m1IP3DErr_branch and "m1IP3DErr" not in self.complained:
        if not self.m1IP3DErr_branch and "m1IP3DErr":
            warnings.warn( "MuMuMuTree: Expected branch m1IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3DErr")
        else:
            self.m1IP3DErr_branch.SetAddress(<void*>&self.m1IP3DErr_value)

        #print "making m1IsGlobal"
        self.m1IsGlobal_branch = the_tree.GetBranch("m1IsGlobal")
        #if not self.m1IsGlobal_branch and "m1IsGlobal" not in self.complained:
        if not self.m1IsGlobal_branch and "m1IsGlobal":
            warnings.warn( "MuMuMuTree: Expected branch m1IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsGlobal")
        else:
            self.m1IsGlobal_branch.SetAddress(<void*>&self.m1IsGlobal_value)

        #print "making m1IsPFMuon"
        self.m1IsPFMuon_branch = the_tree.GetBranch("m1IsPFMuon")
        #if not self.m1IsPFMuon_branch and "m1IsPFMuon" not in self.complained:
        if not self.m1IsPFMuon_branch and "m1IsPFMuon":
            warnings.warn( "MuMuMuTree: Expected branch m1IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsPFMuon")
        else:
            self.m1IsPFMuon_branch.SetAddress(<void*>&self.m1IsPFMuon_value)

        #print "making m1IsTracker"
        self.m1IsTracker_branch = the_tree.GetBranch("m1IsTracker")
        #if not self.m1IsTracker_branch and "m1IsTracker" not in self.complained:
        if not self.m1IsTracker_branch and "m1IsTracker":
            warnings.warn( "MuMuMuTree: Expected branch m1IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsTracker")
        else:
            self.m1IsTracker_branch.SetAddress(<void*>&self.m1IsTracker_value)

        #print "making m1IsoDB03"
        self.m1IsoDB03_branch = the_tree.GetBranch("m1IsoDB03")
        #if not self.m1IsoDB03_branch and "m1IsoDB03" not in self.complained:
        if not self.m1IsoDB03_branch and "m1IsoDB03":
            warnings.warn( "MuMuMuTree: Expected branch m1IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoDB03")
        else:
            self.m1IsoDB03_branch.SetAddress(<void*>&self.m1IsoDB03_value)

        #print "making m1IsoDB04"
        self.m1IsoDB04_branch = the_tree.GetBranch("m1IsoDB04")
        #if not self.m1IsoDB04_branch and "m1IsoDB04" not in self.complained:
        if not self.m1IsoDB04_branch and "m1IsoDB04":
            warnings.warn( "MuMuMuTree: Expected branch m1IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoDB04")
        else:
            self.m1IsoDB04_branch.SetAddress(<void*>&self.m1IsoDB04_value)

        #print "making m1IsoMu22Filter"
        self.m1IsoMu22Filter_branch = the_tree.GetBranch("m1IsoMu22Filter")
        #if not self.m1IsoMu22Filter_branch and "m1IsoMu22Filter" not in self.complained:
        if not self.m1IsoMu22Filter_branch and "m1IsoMu22Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1IsoMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoMu22Filter")
        else:
            self.m1IsoMu22Filter_branch.SetAddress(<void*>&self.m1IsoMu22Filter_value)

        #print "making m1IsoMu22eta2p1Filter"
        self.m1IsoMu22eta2p1Filter_branch = the_tree.GetBranch("m1IsoMu22eta2p1Filter")
        #if not self.m1IsoMu22eta2p1Filter_branch and "m1IsoMu22eta2p1Filter" not in self.complained:
        if not self.m1IsoMu22eta2p1Filter_branch and "m1IsoMu22eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1IsoMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoMu22eta2p1Filter")
        else:
            self.m1IsoMu22eta2p1Filter_branch.SetAddress(<void*>&self.m1IsoMu22eta2p1Filter_value)

        #print "making m1IsoMu24Filter"
        self.m1IsoMu24Filter_branch = the_tree.GetBranch("m1IsoMu24Filter")
        #if not self.m1IsoMu24Filter_branch and "m1IsoMu24Filter" not in self.complained:
        if not self.m1IsoMu24Filter_branch and "m1IsoMu24Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1IsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoMu24Filter")
        else:
            self.m1IsoMu24Filter_branch.SetAddress(<void*>&self.m1IsoMu24Filter_value)

        #print "making m1IsoMu24eta2p1Filter"
        self.m1IsoMu24eta2p1Filter_branch = the_tree.GetBranch("m1IsoMu24eta2p1Filter")
        #if not self.m1IsoMu24eta2p1Filter_branch and "m1IsoMu24eta2p1Filter" not in self.complained:
        if not self.m1IsoMu24eta2p1Filter_branch and "m1IsoMu24eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1IsoMu24eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoMu24eta2p1Filter")
        else:
            self.m1IsoMu24eta2p1Filter_branch.SetAddress(<void*>&self.m1IsoMu24eta2p1Filter_value)

        #print "making m1IsoTkMu22Filter"
        self.m1IsoTkMu22Filter_branch = the_tree.GetBranch("m1IsoTkMu22Filter")
        #if not self.m1IsoTkMu22Filter_branch and "m1IsoTkMu22Filter" not in self.complained:
        if not self.m1IsoTkMu22Filter_branch and "m1IsoTkMu22Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1IsoTkMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoTkMu22Filter")
        else:
            self.m1IsoTkMu22Filter_branch.SetAddress(<void*>&self.m1IsoTkMu22Filter_value)

        #print "making m1IsoTkMu22eta2p1Filter"
        self.m1IsoTkMu22eta2p1Filter_branch = the_tree.GetBranch("m1IsoTkMu22eta2p1Filter")
        #if not self.m1IsoTkMu22eta2p1Filter_branch and "m1IsoTkMu22eta2p1Filter" not in self.complained:
        if not self.m1IsoTkMu22eta2p1Filter_branch and "m1IsoTkMu22eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1IsoTkMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoTkMu22eta2p1Filter")
        else:
            self.m1IsoTkMu22eta2p1Filter_branch.SetAddress(<void*>&self.m1IsoTkMu22eta2p1Filter_value)

        #print "making m1IsoTkMu24Filter"
        self.m1IsoTkMu24Filter_branch = the_tree.GetBranch("m1IsoTkMu24Filter")
        #if not self.m1IsoTkMu24Filter_branch and "m1IsoTkMu24Filter" not in self.complained:
        if not self.m1IsoTkMu24Filter_branch and "m1IsoTkMu24Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1IsoTkMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoTkMu24Filter")
        else:
            self.m1IsoTkMu24Filter_branch.SetAddress(<void*>&self.m1IsoTkMu24Filter_value)

        #print "making m1IsoTkMu24eta2p1Filter"
        self.m1IsoTkMu24eta2p1Filter_branch = the_tree.GetBranch("m1IsoTkMu24eta2p1Filter")
        #if not self.m1IsoTkMu24eta2p1Filter_branch and "m1IsoTkMu24eta2p1Filter" not in self.complained:
        if not self.m1IsoTkMu24eta2p1Filter_branch and "m1IsoTkMu24eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1IsoTkMu24eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoTkMu24eta2p1Filter")
        else:
            self.m1IsoTkMu24eta2p1Filter_branch.SetAddress(<void*>&self.m1IsoTkMu24eta2p1Filter_value)

        #print "making m1JetArea"
        self.m1JetArea_branch = the_tree.GetBranch("m1JetArea")
        #if not self.m1JetArea_branch and "m1JetArea" not in self.complained:
        if not self.m1JetArea_branch and "m1JetArea":
            warnings.warn( "MuMuMuTree: Expected branch m1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetArea")
        else:
            self.m1JetArea_branch.SetAddress(<void*>&self.m1JetArea_value)

        #print "making m1JetBtag"
        self.m1JetBtag_branch = the_tree.GetBranch("m1JetBtag")
        #if not self.m1JetBtag_branch and "m1JetBtag" not in self.complained:
        if not self.m1JetBtag_branch and "m1JetBtag":
            warnings.warn( "MuMuMuTree: Expected branch m1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetBtag")
        else:
            self.m1JetBtag_branch.SetAddress(<void*>&self.m1JetBtag_value)

        #print "making m1JetEtaEtaMoment"
        self.m1JetEtaEtaMoment_branch = the_tree.GetBranch("m1JetEtaEtaMoment")
        #if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment" not in self.complained:
        if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment":
            warnings.warn( "MuMuMuTree: Expected branch m1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaEtaMoment")
        else:
            self.m1JetEtaEtaMoment_branch.SetAddress(<void*>&self.m1JetEtaEtaMoment_value)

        #print "making m1JetEtaPhiMoment"
        self.m1JetEtaPhiMoment_branch = the_tree.GetBranch("m1JetEtaPhiMoment")
        #if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment" not in self.complained:
        if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment":
            warnings.warn( "MuMuMuTree: Expected branch m1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiMoment")
        else:
            self.m1JetEtaPhiMoment_branch.SetAddress(<void*>&self.m1JetEtaPhiMoment_value)

        #print "making m1JetEtaPhiSpread"
        self.m1JetEtaPhiSpread_branch = the_tree.GetBranch("m1JetEtaPhiSpread")
        #if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread" not in self.complained:
        if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread":
            warnings.warn( "MuMuMuTree: Expected branch m1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiSpread")
        else:
            self.m1JetEtaPhiSpread_branch.SetAddress(<void*>&self.m1JetEtaPhiSpread_value)

        #print "making m1JetHadronFlavour"
        self.m1JetHadronFlavour_branch = the_tree.GetBranch("m1JetHadronFlavour")
        #if not self.m1JetHadronFlavour_branch and "m1JetHadronFlavour" not in self.complained:
        if not self.m1JetHadronFlavour_branch and "m1JetHadronFlavour":
            warnings.warn( "MuMuMuTree: Expected branch m1JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetHadronFlavour")
        else:
            self.m1JetHadronFlavour_branch.SetAddress(<void*>&self.m1JetHadronFlavour_value)

        #print "making m1JetPFCISVBtag"
        self.m1JetPFCISVBtag_branch = the_tree.GetBranch("m1JetPFCISVBtag")
        #if not self.m1JetPFCISVBtag_branch and "m1JetPFCISVBtag" not in self.complained:
        if not self.m1JetPFCISVBtag_branch and "m1JetPFCISVBtag":
            warnings.warn( "MuMuMuTree: Expected branch m1JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPFCISVBtag")
        else:
            self.m1JetPFCISVBtag_branch.SetAddress(<void*>&self.m1JetPFCISVBtag_value)

        #print "making m1JetPartonFlavour"
        self.m1JetPartonFlavour_branch = the_tree.GetBranch("m1JetPartonFlavour")
        #if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour" not in self.complained:
        if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour":
            warnings.warn( "MuMuMuTree: Expected branch m1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPartonFlavour")
        else:
            self.m1JetPartonFlavour_branch.SetAddress(<void*>&self.m1JetPartonFlavour_value)

        #print "making m1JetPhiPhiMoment"
        self.m1JetPhiPhiMoment_branch = the_tree.GetBranch("m1JetPhiPhiMoment")
        #if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment" not in self.complained:
        if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment":
            warnings.warn( "MuMuMuTree: Expected branch m1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPhiPhiMoment")
        else:
            self.m1JetPhiPhiMoment_branch.SetAddress(<void*>&self.m1JetPhiPhiMoment_value)

        #print "making m1JetPt"
        self.m1JetPt_branch = the_tree.GetBranch("m1JetPt")
        #if not self.m1JetPt_branch and "m1JetPt" not in self.complained:
        if not self.m1JetPt_branch and "m1JetPt":
            warnings.warn( "MuMuMuTree: Expected branch m1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPt")
        else:
            self.m1JetPt_branch.SetAddress(<void*>&self.m1JetPt_value)

        #print "making m1LowestMll"
        self.m1LowestMll_branch = the_tree.GetBranch("m1LowestMll")
        #if not self.m1LowestMll_branch and "m1LowestMll" not in self.complained:
        if not self.m1LowestMll_branch and "m1LowestMll":
            warnings.warn( "MuMuMuTree: Expected branch m1LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1LowestMll")
        else:
            self.m1LowestMll_branch.SetAddress(<void*>&self.m1LowestMll_value)

        #print "making m1Mass"
        self.m1Mass_branch = the_tree.GetBranch("m1Mass")
        #if not self.m1Mass_branch and "m1Mass" not in self.complained:
        if not self.m1Mass_branch and "m1Mass":
            warnings.warn( "MuMuMuTree: Expected branch m1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mass")
        else:
            self.m1Mass_branch.SetAddress(<void*>&self.m1Mass_value)

        #print "making m1MatchedStations"
        self.m1MatchedStations_branch = the_tree.GetBranch("m1MatchedStations")
        #if not self.m1MatchedStations_branch and "m1MatchedStations" not in self.complained:
        if not self.m1MatchedStations_branch and "m1MatchedStations":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchedStations")
        else:
            self.m1MatchedStations_branch.SetAddress(<void*>&self.m1MatchedStations_value)

        #print "making m1MatchesDoubleESingleMu"
        self.m1MatchesDoubleESingleMu_branch = the_tree.GetBranch("m1MatchesDoubleESingleMu")
        #if not self.m1MatchesDoubleESingleMu_branch and "m1MatchesDoubleESingleMu" not in self.complained:
        if not self.m1MatchesDoubleESingleMu_branch and "m1MatchesDoubleESingleMu":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesDoubleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleESingleMu")
        else:
            self.m1MatchesDoubleESingleMu_branch.SetAddress(<void*>&self.m1MatchesDoubleESingleMu_value)

        #print "making m1MatchesDoubleMu"
        self.m1MatchesDoubleMu_branch = the_tree.GetBranch("m1MatchesDoubleMu")
        #if not self.m1MatchesDoubleMu_branch and "m1MatchesDoubleMu" not in self.complained:
        if not self.m1MatchesDoubleMu_branch and "m1MatchesDoubleMu":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesDoubleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMu")
        else:
            self.m1MatchesDoubleMu_branch.SetAddress(<void*>&self.m1MatchesDoubleMu_value)

        #print "making m1MatchesDoubleMuSingleE"
        self.m1MatchesDoubleMuSingleE_branch = the_tree.GetBranch("m1MatchesDoubleMuSingleE")
        #if not self.m1MatchesDoubleMuSingleE_branch and "m1MatchesDoubleMuSingleE" not in self.complained:
        if not self.m1MatchesDoubleMuSingleE_branch and "m1MatchesDoubleMuSingleE":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesDoubleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMuSingleE")
        else:
            self.m1MatchesDoubleMuSingleE_branch.SetAddress(<void*>&self.m1MatchesDoubleMuSingleE_value)

        #print "making m1MatchesIsoMu22Path"
        self.m1MatchesIsoMu22Path_branch = the_tree.GetBranch("m1MatchesIsoMu22Path")
        #if not self.m1MatchesIsoMu22Path_branch and "m1MatchesIsoMu22Path" not in self.complained:
        if not self.m1MatchesIsoMu22Path_branch and "m1MatchesIsoMu22Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu22Path")
        else:
            self.m1MatchesIsoMu22Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu22Path_value)

        #print "making m1MatchesIsoMu22eta2p1Path"
        self.m1MatchesIsoMu22eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoMu22eta2p1Path")
        #if not self.m1MatchesIsoMu22eta2p1Path_branch and "m1MatchesIsoMu22eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoMu22eta2p1Path_branch and "m1MatchesIsoMu22eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu22eta2p1Path")
        else:
            self.m1MatchesIsoMu22eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu22eta2p1Path_value)

        #print "making m1MatchesIsoMu24Path"
        self.m1MatchesIsoMu24Path_branch = the_tree.GetBranch("m1MatchesIsoMu24Path")
        #if not self.m1MatchesIsoMu24Path_branch and "m1MatchesIsoMu24Path" not in self.complained:
        if not self.m1MatchesIsoMu24Path_branch and "m1MatchesIsoMu24Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24Path")
        else:
            self.m1MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu24Path_value)

        #print "making m1MatchesIsoMu24eta2p1Path"
        self.m1MatchesIsoMu24eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoMu24eta2p1Path")
        #if not self.m1MatchesIsoMu24eta2p1Path_branch and "m1MatchesIsoMu24eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoMu24eta2p1Path_branch and "m1MatchesIsoMu24eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24eta2p1Path")
        else:
            self.m1MatchesIsoMu24eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu24eta2p1Path_value)

        #print "making m1MatchesIsoTkMu22Path"
        self.m1MatchesIsoTkMu22Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu22Path")
        #if not self.m1MatchesIsoTkMu22Path_branch and "m1MatchesIsoTkMu22Path" not in self.complained:
        if not self.m1MatchesIsoTkMu22Path_branch and "m1MatchesIsoTkMu22Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoTkMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu22Path")
        else:
            self.m1MatchesIsoTkMu22Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu22Path_value)

        #print "making m1MatchesIsoTkMu22eta2p1Path"
        self.m1MatchesIsoTkMu22eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu22eta2p1Path")
        #if not self.m1MatchesIsoTkMu22eta2p1Path_branch and "m1MatchesIsoTkMu22eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoTkMu22eta2p1Path_branch and "m1MatchesIsoTkMu22eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoTkMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu22eta2p1Path")
        else:
            self.m1MatchesIsoTkMu22eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu22eta2p1Path_value)

        #print "making m1MatchesIsoTkMu24Path"
        self.m1MatchesIsoTkMu24Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu24Path")
        #if not self.m1MatchesIsoTkMu24Path_branch and "m1MatchesIsoTkMu24Path" not in self.complained:
        if not self.m1MatchesIsoTkMu24Path_branch and "m1MatchesIsoTkMu24Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoTkMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu24Path")
        else:
            self.m1MatchesIsoTkMu24Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu24Path_value)

        #print "making m1MatchesIsoTkMu24eta2p1Path"
        self.m1MatchesIsoTkMu24eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu24eta2p1Path")
        #if not self.m1MatchesIsoTkMu24eta2p1Path_branch and "m1MatchesIsoTkMu24eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoTkMu24eta2p1Path_branch and "m1MatchesIsoTkMu24eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoTkMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu24eta2p1Path")
        else:
            self.m1MatchesIsoTkMu24eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu24eta2p1Path_value)

        #print "making m1MatchesMu19Tau20Filter"
        self.m1MatchesMu19Tau20Filter_branch = the_tree.GetBranch("m1MatchesMu19Tau20Filter")
        #if not self.m1MatchesMu19Tau20Filter_branch and "m1MatchesMu19Tau20Filter" not in self.complained:
        if not self.m1MatchesMu19Tau20Filter_branch and "m1MatchesMu19Tau20Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu19Tau20Filter")
        else:
            self.m1MatchesMu19Tau20Filter_branch.SetAddress(<void*>&self.m1MatchesMu19Tau20Filter_value)

        #print "making m1MatchesMu19Tau20Path"
        self.m1MatchesMu19Tau20Path_branch = the_tree.GetBranch("m1MatchesMu19Tau20Path")
        #if not self.m1MatchesMu19Tau20Path_branch and "m1MatchesMu19Tau20Path" not in self.complained:
        if not self.m1MatchesMu19Tau20Path_branch and "m1MatchesMu19Tau20Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu19Tau20Path")
        else:
            self.m1MatchesMu19Tau20Path_branch.SetAddress(<void*>&self.m1MatchesMu19Tau20Path_value)

        #print "making m1MatchesMu19Tau20sL1Filter"
        self.m1MatchesMu19Tau20sL1Filter_branch = the_tree.GetBranch("m1MatchesMu19Tau20sL1Filter")
        #if not self.m1MatchesMu19Tau20sL1Filter_branch and "m1MatchesMu19Tau20sL1Filter" not in self.complained:
        if not self.m1MatchesMu19Tau20sL1Filter_branch and "m1MatchesMu19Tau20sL1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesMu19Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu19Tau20sL1Filter")
        else:
            self.m1MatchesMu19Tau20sL1Filter_branch.SetAddress(<void*>&self.m1MatchesMu19Tau20sL1Filter_value)

        #print "making m1MatchesMu19Tau20sL1Path"
        self.m1MatchesMu19Tau20sL1Path_branch = the_tree.GetBranch("m1MatchesMu19Tau20sL1Path")
        #if not self.m1MatchesMu19Tau20sL1Path_branch and "m1MatchesMu19Tau20sL1Path" not in self.complained:
        if not self.m1MatchesMu19Tau20sL1Path_branch and "m1MatchesMu19Tau20sL1Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesMu19Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu19Tau20sL1Path")
        else:
            self.m1MatchesMu19Tau20sL1Path_branch.SetAddress(<void*>&self.m1MatchesMu19Tau20sL1Path_value)

        #print "making m1MatchesMu23Ele12Path"
        self.m1MatchesMu23Ele12Path_branch = the_tree.GetBranch("m1MatchesMu23Ele12Path")
        #if not self.m1MatchesMu23Ele12Path_branch and "m1MatchesMu23Ele12Path" not in self.complained:
        if not self.m1MatchesMu23Ele12Path_branch and "m1MatchesMu23Ele12Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesMu23Ele12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu23Ele12Path")
        else:
            self.m1MatchesMu23Ele12Path_branch.SetAddress(<void*>&self.m1MatchesMu23Ele12Path_value)

        #print "making m1MatchesMu8Ele23Path"
        self.m1MatchesMu8Ele23Path_branch = the_tree.GetBranch("m1MatchesMu8Ele23Path")
        #if not self.m1MatchesMu8Ele23Path_branch and "m1MatchesMu8Ele23Path" not in self.complained:
        if not self.m1MatchesMu8Ele23Path_branch and "m1MatchesMu8Ele23Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesMu8Ele23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele23Path")
        else:
            self.m1MatchesMu8Ele23Path_branch.SetAddress(<void*>&self.m1MatchesMu8Ele23Path_value)

        #print "making m1MatchesSingleESingleMu"
        self.m1MatchesSingleESingleMu_branch = the_tree.GetBranch("m1MatchesSingleESingleMu")
        #if not self.m1MatchesSingleESingleMu_branch and "m1MatchesSingleESingleMu" not in self.complained:
        if not self.m1MatchesSingleESingleMu_branch and "m1MatchesSingleESingleMu":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesSingleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleESingleMu")
        else:
            self.m1MatchesSingleESingleMu_branch.SetAddress(<void*>&self.m1MatchesSingleESingleMu_value)

        #print "making m1MatchesSingleMu"
        self.m1MatchesSingleMu_branch = the_tree.GetBranch("m1MatchesSingleMu")
        #if not self.m1MatchesSingleMu_branch and "m1MatchesSingleMu" not in self.complained:
        if not self.m1MatchesSingleMu_branch and "m1MatchesSingleMu":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesSingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu")
        else:
            self.m1MatchesSingleMu_branch.SetAddress(<void*>&self.m1MatchesSingleMu_value)

        #print "making m1MatchesSingleMuIso20"
        self.m1MatchesSingleMuIso20_branch = the_tree.GetBranch("m1MatchesSingleMuIso20")
        #if not self.m1MatchesSingleMuIso20_branch and "m1MatchesSingleMuIso20" not in self.complained:
        if not self.m1MatchesSingleMuIso20_branch and "m1MatchesSingleMuIso20":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesSingleMuIso20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMuIso20")
        else:
            self.m1MatchesSingleMuIso20_branch.SetAddress(<void*>&self.m1MatchesSingleMuIso20_value)

        #print "making m1MatchesSingleMuIsoTk20"
        self.m1MatchesSingleMuIsoTk20_branch = the_tree.GetBranch("m1MatchesSingleMuIsoTk20")
        #if not self.m1MatchesSingleMuIsoTk20_branch and "m1MatchesSingleMuIsoTk20" not in self.complained:
        if not self.m1MatchesSingleMuIsoTk20_branch and "m1MatchesSingleMuIsoTk20":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesSingleMuIsoTk20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMuIsoTk20")
        else:
            self.m1MatchesSingleMuIsoTk20_branch.SetAddress(<void*>&self.m1MatchesSingleMuIsoTk20_value)

        #print "making m1MatchesSingleMuSingleE"
        self.m1MatchesSingleMuSingleE_branch = the_tree.GetBranch("m1MatchesSingleMuSingleE")
        #if not self.m1MatchesSingleMuSingleE_branch and "m1MatchesSingleMuSingleE" not in self.complained:
        if not self.m1MatchesSingleMuSingleE_branch and "m1MatchesSingleMuSingleE":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesSingleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMuSingleE")
        else:
            self.m1MatchesSingleMuSingleE_branch.SetAddress(<void*>&self.m1MatchesSingleMuSingleE_value)

        #print "making m1MatchesSingleMu_leg1"
        self.m1MatchesSingleMu_leg1_branch = the_tree.GetBranch("m1MatchesSingleMu_leg1")
        #if not self.m1MatchesSingleMu_leg1_branch and "m1MatchesSingleMu_leg1" not in self.complained:
        if not self.m1MatchesSingleMu_leg1_branch and "m1MatchesSingleMu_leg1":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesSingleMu_leg1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu_leg1")
        else:
            self.m1MatchesSingleMu_leg1_branch.SetAddress(<void*>&self.m1MatchesSingleMu_leg1_value)

        #print "making m1MatchesSingleMu_leg1_noiso"
        self.m1MatchesSingleMu_leg1_noiso_branch = the_tree.GetBranch("m1MatchesSingleMu_leg1_noiso")
        #if not self.m1MatchesSingleMu_leg1_noiso_branch and "m1MatchesSingleMu_leg1_noiso" not in self.complained:
        if not self.m1MatchesSingleMu_leg1_noiso_branch and "m1MatchesSingleMu_leg1_noiso":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesSingleMu_leg1_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu_leg1_noiso")
        else:
            self.m1MatchesSingleMu_leg1_noiso_branch.SetAddress(<void*>&self.m1MatchesSingleMu_leg1_noiso_value)

        #print "making m1MatchesSingleMu_leg2"
        self.m1MatchesSingleMu_leg2_branch = the_tree.GetBranch("m1MatchesSingleMu_leg2")
        #if not self.m1MatchesSingleMu_leg2_branch and "m1MatchesSingleMu_leg2" not in self.complained:
        if not self.m1MatchesSingleMu_leg2_branch and "m1MatchesSingleMu_leg2":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesSingleMu_leg2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu_leg2")
        else:
            self.m1MatchesSingleMu_leg2_branch.SetAddress(<void*>&self.m1MatchesSingleMu_leg2_value)

        #print "making m1MatchesSingleMu_leg2_noiso"
        self.m1MatchesSingleMu_leg2_noiso_branch = the_tree.GetBranch("m1MatchesSingleMu_leg2_noiso")
        #if not self.m1MatchesSingleMu_leg2_noiso_branch and "m1MatchesSingleMu_leg2_noiso" not in self.complained:
        if not self.m1MatchesSingleMu_leg2_noiso_branch and "m1MatchesSingleMu_leg2_noiso":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesSingleMu_leg2_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu_leg2_noiso")
        else:
            self.m1MatchesSingleMu_leg2_noiso_branch.SetAddress(<void*>&self.m1MatchesSingleMu_leg2_noiso_value)

        #print "making m1MatchesTripleMu"
        self.m1MatchesTripleMu_branch = the_tree.GetBranch("m1MatchesTripleMu")
        #if not self.m1MatchesTripleMu_branch and "m1MatchesTripleMu" not in self.complained:
        if not self.m1MatchesTripleMu_branch and "m1MatchesTripleMu":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesTripleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesTripleMu")
        else:
            self.m1MatchesTripleMu_branch.SetAddress(<void*>&self.m1MatchesTripleMu_value)

        #print "making m1MtToPfMet_ElectronEnDown"
        self.m1MtToPfMet_ElectronEnDown_branch = the_tree.GetBranch("m1MtToPfMet_ElectronEnDown")
        #if not self.m1MtToPfMet_ElectronEnDown_branch and "m1MtToPfMet_ElectronEnDown" not in self.complained:
        if not self.m1MtToPfMet_ElectronEnDown_branch and "m1MtToPfMet_ElectronEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_ElectronEnDown")
        else:
            self.m1MtToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.m1MtToPfMet_ElectronEnDown_value)

        #print "making m1MtToPfMet_ElectronEnUp"
        self.m1MtToPfMet_ElectronEnUp_branch = the_tree.GetBranch("m1MtToPfMet_ElectronEnUp")
        #if not self.m1MtToPfMet_ElectronEnUp_branch and "m1MtToPfMet_ElectronEnUp" not in self.complained:
        if not self.m1MtToPfMet_ElectronEnUp_branch and "m1MtToPfMet_ElectronEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_ElectronEnUp")
        else:
            self.m1MtToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.m1MtToPfMet_ElectronEnUp_value)

        #print "making m1MtToPfMet_JetEnDown"
        self.m1MtToPfMet_JetEnDown_branch = the_tree.GetBranch("m1MtToPfMet_JetEnDown")
        #if not self.m1MtToPfMet_JetEnDown_branch and "m1MtToPfMet_JetEnDown" not in self.complained:
        if not self.m1MtToPfMet_JetEnDown_branch and "m1MtToPfMet_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_JetEnDown")
        else:
            self.m1MtToPfMet_JetEnDown_branch.SetAddress(<void*>&self.m1MtToPfMet_JetEnDown_value)

        #print "making m1MtToPfMet_JetEnUp"
        self.m1MtToPfMet_JetEnUp_branch = the_tree.GetBranch("m1MtToPfMet_JetEnUp")
        #if not self.m1MtToPfMet_JetEnUp_branch and "m1MtToPfMet_JetEnUp" not in self.complained:
        if not self.m1MtToPfMet_JetEnUp_branch and "m1MtToPfMet_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_JetEnUp")
        else:
            self.m1MtToPfMet_JetEnUp_branch.SetAddress(<void*>&self.m1MtToPfMet_JetEnUp_value)

        #print "making m1MtToPfMet_JetResDown"
        self.m1MtToPfMet_JetResDown_branch = the_tree.GetBranch("m1MtToPfMet_JetResDown")
        #if not self.m1MtToPfMet_JetResDown_branch and "m1MtToPfMet_JetResDown" not in self.complained:
        if not self.m1MtToPfMet_JetResDown_branch and "m1MtToPfMet_JetResDown":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_JetResDown")
        else:
            self.m1MtToPfMet_JetResDown_branch.SetAddress(<void*>&self.m1MtToPfMet_JetResDown_value)

        #print "making m1MtToPfMet_JetResUp"
        self.m1MtToPfMet_JetResUp_branch = the_tree.GetBranch("m1MtToPfMet_JetResUp")
        #if not self.m1MtToPfMet_JetResUp_branch and "m1MtToPfMet_JetResUp" not in self.complained:
        if not self.m1MtToPfMet_JetResUp_branch and "m1MtToPfMet_JetResUp":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_JetResUp")
        else:
            self.m1MtToPfMet_JetResUp_branch.SetAddress(<void*>&self.m1MtToPfMet_JetResUp_value)

        #print "making m1MtToPfMet_MuonEnDown"
        self.m1MtToPfMet_MuonEnDown_branch = the_tree.GetBranch("m1MtToPfMet_MuonEnDown")
        #if not self.m1MtToPfMet_MuonEnDown_branch and "m1MtToPfMet_MuonEnDown" not in self.complained:
        if not self.m1MtToPfMet_MuonEnDown_branch and "m1MtToPfMet_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_MuonEnDown")
        else:
            self.m1MtToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.m1MtToPfMet_MuonEnDown_value)

        #print "making m1MtToPfMet_MuonEnUp"
        self.m1MtToPfMet_MuonEnUp_branch = the_tree.GetBranch("m1MtToPfMet_MuonEnUp")
        #if not self.m1MtToPfMet_MuonEnUp_branch and "m1MtToPfMet_MuonEnUp" not in self.complained:
        if not self.m1MtToPfMet_MuonEnUp_branch and "m1MtToPfMet_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_MuonEnUp")
        else:
            self.m1MtToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.m1MtToPfMet_MuonEnUp_value)

        #print "making m1MtToPfMet_PhotonEnDown"
        self.m1MtToPfMet_PhotonEnDown_branch = the_tree.GetBranch("m1MtToPfMet_PhotonEnDown")
        #if not self.m1MtToPfMet_PhotonEnDown_branch and "m1MtToPfMet_PhotonEnDown" not in self.complained:
        if not self.m1MtToPfMet_PhotonEnDown_branch and "m1MtToPfMet_PhotonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_PhotonEnDown")
        else:
            self.m1MtToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.m1MtToPfMet_PhotonEnDown_value)

        #print "making m1MtToPfMet_PhotonEnUp"
        self.m1MtToPfMet_PhotonEnUp_branch = the_tree.GetBranch("m1MtToPfMet_PhotonEnUp")
        #if not self.m1MtToPfMet_PhotonEnUp_branch and "m1MtToPfMet_PhotonEnUp" not in self.complained:
        if not self.m1MtToPfMet_PhotonEnUp_branch and "m1MtToPfMet_PhotonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_PhotonEnUp")
        else:
            self.m1MtToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.m1MtToPfMet_PhotonEnUp_value)

        #print "making m1MtToPfMet_Raw"
        self.m1MtToPfMet_Raw_branch = the_tree.GetBranch("m1MtToPfMet_Raw")
        #if not self.m1MtToPfMet_Raw_branch and "m1MtToPfMet_Raw" not in self.complained:
        if not self.m1MtToPfMet_Raw_branch and "m1MtToPfMet_Raw":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_Raw")
        else:
            self.m1MtToPfMet_Raw_branch.SetAddress(<void*>&self.m1MtToPfMet_Raw_value)

        #print "making m1MtToPfMet_TauEnDown"
        self.m1MtToPfMet_TauEnDown_branch = the_tree.GetBranch("m1MtToPfMet_TauEnDown")
        #if not self.m1MtToPfMet_TauEnDown_branch and "m1MtToPfMet_TauEnDown" not in self.complained:
        if not self.m1MtToPfMet_TauEnDown_branch and "m1MtToPfMet_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_TauEnDown")
        else:
            self.m1MtToPfMet_TauEnDown_branch.SetAddress(<void*>&self.m1MtToPfMet_TauEnDown_value)

        #print "making m1MtToPfMet_TauEnUp"
        self.m1MtToPfMet_TauEnUp_branch = the_tree.GetBranch("m1MtToPfMet_TauEnUp")
        #if not self.m1MtToPfMet_TauEnUp_branch and "m1MtToPfMet_TauEnUp" not in self.complained:
        if not self.m1MtToPfMet_TauEnUp_branch and "m1MtToPfMet_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_TauEnUp")
        else:
            self.m1MtToPfMet_TauEnUp_branch.SetAddress(<void*>&self.m1MtToPfMet_TauEnUp_value)

        #print "making m1MtToPfMet_UnclusteredEnDown"
        self.m1MtToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("m1MtToPfMet_UnclusteredEnDown")
        #if not self.m1MtToPfMet_UnclusteredEnDown_branch and "m1MtToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.m1MtToPfMet_UnclusteredEnDown_branch and "m1MtToPfMet_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_UnclusteredEnDown")
        else:
            self.m1MtToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.m1MtToPfMet_UnclusteredEnDown_value)

        #print "making m1MtToPfMet_UnclusteredEnUp"
        self.m1MtToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("m1MtToPfMet_UnclusteredEnUp")
        #if not self.m1MtToPfMet_UnclusteredEnUp_branch and "m1MtToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.m1MtToPfMet_UnclusteredEnUp_branch and "m1MtToPfMet_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_UnclusteredEnUp")
        else:
            self.m1MtToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.m1MtToPfMet_UnclusteredEnUp_value)

        #print "making m1MtToPfMet_type1"
        self.m1MtToPfMet_type1_branch = the_tree.GetBranch("m1MtToPfMet_type1")
        #if not self.m1MtToPfMet_type1_branch and "m1MtToPfMet_type1" not in self.complained:
        if not self.m1MtToPfMet_type1_branch and "m1MtToPfMet_type1":
            warnings.warn( "MuMuMuTree: Expected branch m1MtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_type1")
        else:
            self.m1MtToPfMet_type1_branch.SetAddress(<void*>&self.m1MtToPfMet_type1_value)

        #print "making m1Mu23Ele12Filter"
        self.m1Mu23Ele12Filter_branch = the_tree.GetBranch("m1Mu23Ele12Filter")
        #if not self.m1Mu23Ele12Filter_branch and "m1Mu23Ele12Filter" not in self.complained:
        if not self.m1Mu23Ele12Filter_branch and "m1Mu23Ele12Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1Mu23Ele12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu23Ele12Filter")
        else:
            self.m1Mu23Ele12Filter_branch.SetAddress(<void*>&self.m1Mu23Ele12Filter_value)

        #print "making m1Mu8Ele23Filter"
        self.m1Mu8Ele23Filter_branch = the_tree.GetBranch("m1Mu8Ele23Filter")
        #if not self.m1Mu8Ele23Filter_branch and "m1Mu8Ele23Filter" not in self.complained:
        if not self.m1Mu8Ele23Filter_branch and "m1Mu8Ele23Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1Mu8Ele23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu8Ele23Filter")
        else:
            self.m1Mu8Ele23Filter_branch.SetAddress(<void*>&self.m1Mu8Ele23Filter_value)

        #print "making m1MuonHits"
        self.m1MuonHits_branch = the_tree.GetBranch("m1MuonHits")
        #if not self.m1MuonHits_branch and "m1MuonHits" not in self.complained:
        if not self.m1MuonHits_branch and "m1MuonHits":
            warnings.warn( "MuMuMuTree: Expected branch m1MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MuonHits")
        else:
            self.m1MuonHits_branch.SetAddress(<void*>&self.m1MuonHits_value)

        #print "making m1NearestZMass"
        self.m1NearestZMass_branch = the_tree.GetBranch("m1NearestZMass")
        #if not self.m1NearestZMass_branch and "m1NearestZMass" not in self.complained:
        if not self.m1NearestZMass_branch and "m1NearestZMass":
            warnings.warn( "MuMuMuTree: Expected branch m1NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NearestZMass")
        else:
            self.m1NearestZMass_branch.SetAddress(<void*>&self.m1NearestZMass_value)

        #print "making m1NormTrkChi2"
        self.m1NormTrkChi2_branch = the_tree.GetBranch("m1NormTrkChi2")
        #if not self.m1NormTrkChi2_branch and "m1NormTrkChi2" not in self.complained:
        if not self.m1NormTrkChi2_branch and "m1NormTrkChi2":
            warnings.warn( "MuMuMuTree: Expected branch m1NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormTrkChi2")
        else:
            self.m1NormTrkChi2_branch.SetAddress(<void*>&self.m1NormTrkChi2_value)

        #print "making m1NormalizedChi2"
        self.m1NormalizedChi2_branch = the_tree.GetBranch("m1NormalizedChi2")
        #if not self.m1NormalizedChi2_branch and "m1NormalizedChi2" not in self.complained:
        if not self.m1NormalizedChi2_branch and "m1NormalizedChi2":
            warnings.warn( "MuMuMuTree: Expected branch m1NormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormalizedChi2")
        else:
            self.m1NormalizedChi2_branch.SetAddress(<void*>&self.m1NormalizedChi2_value)

        #print "making m1PFChargedHadronIsoR04"
        self.m1PFChargedHadronIsoR04_branch = the_tree.GetBranch("m1PFChargedHadronIsoR04")
        #if not self.m1PFChargedHadronIsoR04_branch and "m1PFChargedHadronIsoR04" not in self.complained:
        if not self.m1PFChargedHadronIsoR04_branch and "m1PFChargedHadronIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m1PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedHadronIsoR04")
        else:
            self.m1PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m1PFChargedHadronIsoR04_value)

        #print "making m1PFChargedIso"
        self.m1PFChargedIso_branch = the_tree.GetBranch("m1PFChargedIso")
        #if not self.m1PFChargedIso_branch and "m1PFChargedIso" not in self.complained:
        if not self.m1PFChargedIso_branch and "m1PFChargedIso":
            warnings.warn( "MuMuMuTree: Expected branch m1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedIso")
        else:
            self.m1PFChargedIso_branch.SetAddress(<void*>&self.m1PFChargedIso_value)

        #print "making m1PFIDLoose"
        self.m1PFIDLoose_branch = the_tree.GetBranch("m1PFIDLoose")
        #if not self.m1PFIDLoose_branch and "m1PFIDLoose" not in self.complained:
        if not self.m1PFIDLoose_branch and "m1PFIDLoose":
            warnings.warn( "MuMuMuTree: Expected branch m1PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDLoose")
        else:
            self.m1PFIDLoose_branch.SetAddress(<void*>&self.m1PFIDLoose_value)

        #print "making m1PFIDMedium"
        self.m1PFIDMedium_branch = the_tree.GetBranch("m1PFIDMedium")
        #if not self.m1PFIDMedium_branch and "m1PFIDMedium" not in self.complained:
        if not self.m1PFIDMedium_branch and "m1PFIDMedium":
            warnings.warn( "MuMuMuTree: Expected branch m1PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDMedium")
        else:
            self.m1PFIDMedium_branch.SetAddress(<void*>&self.m1PFIDMedium_value)

        #print "making m1PFIDTight"
        self.m1PFIDTight_branch = the_tree.GetBranch("m1PFIDTight")
        #if not self.m1PFIDTight_branch and "m1PFIDTight" not in self.complained:
        if not self.m1PFIDTight_branch and "m1PFIDTight":
            warnings.warn( "MuMuMuTree: Expected branch m1PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDTight")
        else:
            self.m1PFIDTight_branch.SetAddress(<void*>&self.m1PFIDTight_value)

        #print "making m1PFNeutralHadronIsoR04"
        self.m1PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m1PFNeutralHadronIsoR04")
        #if not self.m1PFNeutralHadronIsoR04_branch and "m1PFNeutralHadronIsoR04" not in self.complained:
        if not self.m1PFNeutralHadronIsoR04_branch and "m1PFNeutralHadronIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m1PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralHadronIsoR04")
        else:
            self.m1PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m1PFNeutralHadronIsoR04_value)

        #print "making m1PFNeutralIso"
        self.m1PFNeutralIso_branch = the_tree.GetBranch("m1PFNeutralIso")
        #if not self.m1PFNeutralIso_branch and "m1PFNeutralIso" not in self.complained:
        if not self.m1PFNeutralIso_branch and "m1PFNeutralIso":
            warnings.warn( "MuMuMuTree: Expected branch m1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralIso")
        else:
            self.m1PFNeutralIso_branch.SetAddress(<void*>&self.m1PFNeutralIso_value)

        #print "making m1PFPUChargedIso"
        self.m1PFPUChargedIso_branch = the_tree.GetBranch("m1PFPUChargedIso")
        #if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso" not in self.complained:
        if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso":
            warnings.warn( "MuMuMuTree: Expected branch m1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPUChargedIso")
        else:
            self.m1PFPUChargedIso_branch.SetAddress(<void*>&self.m1PFPUChargedIso_value)

        #print "making m1PFPhotonIso"
        self.m1PFPhotonIso_branch = the_tree.GetBranch("m1PFPhotonIso")
        #if not self.m1PFPhotonIso_branch and "m1PFPhotonIso" not in self.complained:
        if not self.m1PFPhotonIso_branch and "m1PFPhotonIso":
            warnings.warn( "MuMuMuTree: Expected branch m1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIso")
        else:
            self.m1PFPhotonIso_branch.SetAddress(<void*>&self.m1PFPhotonIso_value)

        #print "making m1PFPhotonIsoR04"
        self.m1PFPhotonIsoR04_branch = the_tree.GetBranch("m1PFPhotonIsoR04")
        #if not self.m1PFPhotonIsoR04_branch and "m1PFPhotonIsoR04" not in self.complained:
        if not self.m1PFPhotonIsoR04_branch and "m1PFPhotonIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m1PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIsoR04")
        else:
            self.m1PFPhotonIsoR04_branch.SetAddress(<void*>&self.m1PFPhotonIsoR04_value)

        #print "making m1PFPileupIsoR04"
        self.m1PFPileupIsoR04_branch = the_tree.GetBranch("m1PFPileupIsoR04")
        #if not self.m1PFPileupIsoR04_branch and "m1PFPileupIsoR04" not in self.complained:
        if not self.m1PFPileupIsoR04_branch and "m1PFPileupIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m1PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPileupIsoR04")
        else:
            self.m1PFPileupIsoR04_branch.SetAddress(<void*>&self.m1PFPileupIsoR04_value)

        #print "making m1PVDXY"
        self.m1PVDXY_branch = the_tree.GetBranch("m1PVDXY")
        #if not self.m1PVDXY_branch and "m1PVDXY" not in self.complained:
        if not self.m1PVDXY_branch and "m1PVDXY":
            warnings.warn( "MuMuMuTree: Expected branch m1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDXY")
        else:
            self.m1PVDXY_branch.SetAddress(<void*>&self.m1PVDXY_value)

        #print "making m1PVDZ"
        self.m1PVDZ_branch = the_tree.GetBranch("m1PVDZ")
        #if not self.m1PVDZ_branch and "m1PVDZ" not in self.complained:
        if not self.m1PVDZ_branch and "m1PVDZ":
            warnings.warn( "MuMuMuTree: Expected branch m1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDZ")
        else:
            self.m1PVDZ_branch.SetAddress(<void*>&self.m1PVDZ_value)

        #print "making m1Phi"
        self.m1Phi_branch = the_tree.GetBranch("m1Phi")
        #if not self.m1Phi_branch and "m1Phi" not in self.complained:
        if not self.m1Phi_branch and "m1Phi":
            warnings.warn( "MuMuMuTree: Expected branch m1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi")
        else:
            self.m1Phi_branch.SetAddress(<void*>&self.m1Phi_value)

        #print "making m1Phi_MuonEnDown"
        self.m1Phi_MuonEnDown_branch = the_tree.GetBranch("m1Phi_MuonEnDown")
        #if not self.m1Phi_MuonEnDown_branch and "m1Phi_MuonEnDown" not in self.complained:
        if not self.m1Phi_MuonEnDown_branch and "m1Phi_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1Phi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi_MuonEnDown")
        else:
            self.m1Phi_MuonEnDown_branch.SetAddress(<void*>&self.m1Phi_MuonEnDown_value)

        #print "making m1Phi_MuonEnUp"
        self.m1Phi_MuonEnUp_branch = the_tree.GetBranch("m1Phi_MuonEnUp")
        #if not self.m1Phi_MuonEnUp_branch and "m1Phi_MuonEnUp" not in self.complained:
        if not self.m1Phi_MuonEnUp_branch and "m1Phi_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1Phi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi_MuonEnUp")
        else:
            self.m1Phi_MuonEnUp_branch.SetAddress(<void*>&self.m1Phi_MuonEnUp_value)

        #print "making m1PixHits"
        self.m1PixHits_branch = the_tree.GetBranch("m1PixHits")
        #if not self.m1PixHits_branch and "m1PixHits" not in self.complained:
        if not self.m1PixHits_branch and "m1PixHits":
            warnings.warn( "MuMuMuTree: Expected branch m1PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PixHits")
        else:
            self.m1PixHits_branch.SetAddress(<void*>&self.m1PixHits_value)

        #print "making m1Pt"
        self.m1Pt_branch = the_tree.GetBranch("m1Pt")
        #if not self.m1Pt_branch and "m1Pt" not in self.complained:
        if not self.m1Pt_branch and "m1Pt":
            warnings.warn( "MuMuMuTree: Expected branch m1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt")
        else:
            self.m1Pt_branch.SetAddress(<void*>&self.m1Pt_value)

        #print "making m1Pt_MuonEnDown"
        self.m1Pt_MuonEnDown_branch = the_tree.GetBranch("m1Pt_MuonEnDown")
        #if not self.m1Pt_MuonEnDown_branch and "m1Pt_MuonEnDown" not in self.complained:
        if not self.m1Pt_MuonEnDown_branch and "m1Pt_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1Pt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt_MuonEnDown")
        else:
            self.m1Pt_MuonEnDown_branch.SetAddress(<void*>&self.m1Pt_MuonEnDown_value)

        #print "making m1Pt_MuonEnUp"
        self.m1Pt_MuonEnUp_branch = the_tree.GetBranch("m1Pt_MuonEnUp")
        #if not self.m1Pt_MuonEnUp_branch and "m1Pt_MuonEnUp" not in self.complained:
        if not self.m1Pt_MuonEnUp_branch and "m1Pt_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1Pt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt_MuonEnUp")
        else:
            self.m1Pt_MuonEnUp_branch.SetAddress(<void*>&self.m1Pt_MuonEnUp_value)

        #print "making m1Rank"
        self.m1Rank_branch = the_tree.GetBranch("m1Rank")
        #if not self.m1Rank_branch and "m1Rank" not in self.complained:
        if not self.m1Rank_branch and "m1Rank":
            warnings.warn( "MuMuMuTree: Expected branch m1Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Rank")
        else:
            self.m1Rank_branch.SetAddress(<void*>&self.m1Rank_value)

        #print "making m1RelPFIsoDBDefault"
        self.m1RelPFIsoDBDefault_branch = the_tree.GetBranch("m1RelPFIsoDBDefault")
        #if not self.m1RelPFIsoDBDefault_branch and "m1RelPFIsoDBDefault" not in self.complained:
        if not self.m1RelPFIsoDBDefault_branch and "m1RelPFIsoDBDefault":
            warnings.warn( "MuMuMuTree: Expected branch m1RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDBDefault")
        else:
            self.m1RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m1RelPFIsoDBDefault_value)

        #print "making m1RelPFIsoDBDefaultR04"
        self.m1RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m1RelPFIsoDBDefaultR04")
        #if not self.m1RelPFIsoDBDefaultR04_branch and "m1RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m1RelPFIsoDBDefaultR04_branch and "m1RelPFIsoDBDefaultR04":
            warnings.warn( "MuMuMuTree: Expected branch m1RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDBDefaultR04")
        else:
            self.m1RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m1RelPFIsoDBDefaultR04_value)

        #print "making m1RelPFIsoRho"
        self.m1RelPFIsoRho_branch = the_tree.GetBranch("m1RelPFIsoRho")
        #if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho" not in self.complained:
        if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho":
            warnings.warn( "MuMuMuTree: Expected branch m1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRho")
        else:
            self.m1RelPFIsoRho_branch.SetAddress(<void*>&self.m1RelPFIsoRho_value)

        #print "making m1Rho"
        self.m1Rho_branch = the_tree.GetBranch("m1Rho")
        #if not self.m1Rho_branch and "m1Rho" not in self.complained:
        if not self.m1Rho_branch and "m1Rho":
            warnings.warn( "MuMuMuTree: Expected branch m1Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Rho")
        else:
            self.m1Rho_branch.SetAddress(<void*>&self.m1Rho_value)

        #print "making m1SIP2D"
        self.m1SIP2D_branch = the_tree.GetBranch("m1SIP2D")
        #if not self.m1SIP2D_branch and "m1SIP2D" not in self.complained:
        if not self.m1SIP2D_branch and "m1SIP2D":
            warnings.warn( "MuMuMuTree: Expected branch m1SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SIP2D")
        else:
            self.m1SIP2D_branch.SetAddress(<void*>&self.m1SIP2D_value)

        #print "making m1SIP3D"
        self.m1SIP3D_branch = the_tree.GetBranch("m1SIP3D")
        #if not self.m1SIP3D_branch and "m1SIP3D" not in self.complained:
        if not self.m1SIP3D_branch and "m1SIP3D":
            warnings.warn( "MuMuMuTree: Expected branch m1SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SIP3D")
        else:
            self.m1SIP3D_branch.SetAddress(<void*>&self.m1SIP3D_value)

        #print "making m1SegmentCompatibility"
        self.m1SegmentCompatibility_branch = the_tree.GetBranch("m1SegmentCompatibility")
        #if not self.m1SegmentCompatibility_branch and "m1SegmentCompatibility" not in self.complained:
        if not self.m1SegmentCompatibility_branch and "m1SegmentCompatibility":
            warnings.warn( "MuMuMuTree: Expected branch m1SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SegmentCompatibility")
        else:
            self.m1SegmentCompatibility_branch.SetAddress(<void*>&self.m1SegmentCompatibility_value)

        #print "making m1TkLayersWithMeasurement"
        self.m1TkLayersWithMeasurement_branch = the_tree.GetBranch("m1TkLayersWithMeasurement")
        #if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement" not in self.complained:
        if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement":
            warnings.warn( "MuMuMuTree: Expected branch m1TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkLayersWithMeasurement")
        else:
            self.m1TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m1TkLayersWithMeasurement_value)

        #print "making m1TrkIsoDR03"
        self.m1TrkIsoDR03_branch = the_tree.GetBranch("m1TrkIsoDR03")
        #if not self.m1TrkIsoDR03_branch and "m1TrkIsoDR03" not in self.complained:
        if not self.m1TrkIsoDR03_branch and "m1TrkIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m1TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TrkIsoDR03")
        else:
            self.m1TrkIsoDR03_branch.SetAddress(<void*>&self.m1TrkIsoDR03_value)

        #print "making m1TrkKink"
        self.m1TrkKink_branch = the_tree.GetBranch("m1TrkKink")
        #if not self.m1TrkKink_branch and "m1TrkKink" not in self.complained:
        if not self.m1TrkKink_branch and "m1TrkKink":
            warnings.warn( "MuMuMuTree: Expected branch m1TrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TrkKink")
        else:
            self.m1TrkKink_branch.SetAddress(<void*>&self.m1TrkKink_value)

        #print "making m1TypeCode"
        self.m1TypeCode_branch = the_tree.GetBranch("m1TypeCode")
        #if not self.m1TypeCode_branch and "m1TypeCode" not in self.complained:
        if not self.m1TypeCode_branch and "m1TypeCode":
            warnings.warn( "MuMuMuTree: Expected branch m1TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TypeCode")
        else:
            self.m1TypeCode_branch.SetAddress(<void*>&self.m1TypeCode_value)

        #print "making m1VZ"
        self.m1VZ_branch = the_tree.GetBranch("m1VZ")
        #if not self.m1VZ_branch and "m1VZ" not in self.complained:
        if not self.m1VZ_branch and "m1VZ":
            warnings.warn( "MuMuMuTree: Expected branch m1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VZ")
        else:
            self.m1VZ_branch.SetAddress(<void*>&self.m1VZ_value)

        #print "making m1ValidFraction"
        self.m1ValidFraction_branch = the_tree.GetBranch("m1ValidFraction")
        #if not self.m1ValidFraction_branch and "m1ValidFraction" not in self.complained:
        if not self.m1ValidFraction_branch and "m1ValidFraction":
            warnings.warn( "MuMuMuTree: Expected branch m1ValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ValidFraction")
        else:
            self.m1ValidFraction_branch.SetAddress(<void*>&self.m1ValidFraction_value)

        #print "making m1ZTTGenMatching"
        self.m1ZTTGenMatching_branch = the_tree.GetBranch("m1ZTTGenMatching")
        #if not self.m1ZTTGenMatching_branch and "m1ZTTGenMatching" not in self.complained:
        if not self.m1ZTTGenMatching_branch and "m1ZTTGenMatching":
            warnings.warn( "MuMuMuTree: Expected branch m1ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ZTTGenMatching")
        else:
            self.m1ZTTGenMatching_branch.SetAddress(<void*>&self.m1ZTTGenMatching_value)

        #print "making m1_m2_CosThetaStar"
        self.m1_m2_CosThetaStar_branch = the_tree.GetBranch("m1_m2_CosThetaStar")
        #if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar" not in self.complained:
        if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_CosThetaStar")
        else:
            self.m1_m2_CosThetaStar_branch.SetAddress(<void*>&self.m1_m2_CosThetaStar_value)

        #print "making m1_m2_DPhi"
        self.m1_m2_DPhi_branch = the_tree.GetBranch("m1_m2_DPhi")
        #if not self.m1_m2_DPhi_branch and "m1_m2_DPhi" not in self.complained:
        if not self.m1_m2_DPhi_branch and "m1_m2_DPhi":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DPhi")
        else:
            self.m1_m2_DPhi_branch.SetAddress(<void*>&self.m1_m2_DPhi_value)

        #print "making m1_m2_DR"
        self.m1_m2_DR_branch = the_tree.GetBranch("m1_m2_DR")
        #if not self.m1_m2_DR_branch and "m1_m2_DR" not in self.complained:
        if not self.m1_m2_DR_branch and "m1_m2_DR":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DR")
        else:
            self.m1_m2_DR_branch.SetAddress(<void*>&self.m1_m2_DR_value)

        #print "making m1_m2_Eta"
        self.m1_m2_Eta_branch = the_tree.GetBranch("m1_m2_Eta")
        #if not self.m1_m2_Eta_branch and "m1_m2_Eta" not in self.complained:
        if not self.m1_m2_Eta_branch and "m1_m2_Eta":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Eta")
        else:
            self.m1_m2_Eta_branch.SetAddress(<void*>&self.m1_m2_Eta_value)

        #print "making m1_m2_Mass"
        self.m1_m2_Mass_branch = the_tree.GetBranch("m1_m2_Mass")
        #if not self.m1_m2_Mass_branch and "m1_m2_Mass" not in self.complained:
        if not self.m1_m2_Mass_branch and "m1_m2_Mass":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass")
        else:
            self.m1_m2_Mass_branch.SetAddress(<void*>&self.m1_m2_Mass_value)

        #print "making m1_m2_Mass_TauEnDown"
        self.m1_m2_Mass_TauEnDown_branch = the_tree.GetBranch("m1_m2_Mass_TauEnDown")
        #if not self.m1_m2_Mass_TauEnDown_branch and "m1_m2_Mass_TauEnDown" not in self.complained:
        if not self.m1_m2_Mass_TauEnDown_branch and "m1_m2_Mass_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_Mass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass_TauEnDown")
        else:
            self.m1_m2_Mass_TauEnDown_branch.SetAddress(<void*>&self.m1_m2_Mass_TauEnDown_value)

        #print "making m1_m2_Mass_TauEnUp"
        self.m1_m2_Mass_TauEnUp_branch = the_tree.GetBranch("m1_m2_Mass_TauEnUp")
        #if not self.m1_m2_Mass_TauEnUp_branch and "m1_m2_Mass_TauEnUp" not in self.complained:
        if not self.m1_m2_Mass_TauEnUp_branch and "m1_m2_Mass_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_Mass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass_TauEnUp")
        else:
            self.m1_m2_Mass_TauEnUp_branch.SetAddress(<void*>&self.m1_m2_Mass_TauEnUp_value)

        #print "making m1_m2_Mt"
        self.m1_m2_Mt_branch = the_tree.GetBranch("m1_m2_Mt")
        #if not self.m1_m2_Mt_branch and "m1_m2_Mt" not in self.complained:
        if not self.m1_m2_Mt_branch and "m1_m2_Mt":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mt")
        else:
            self.m1_m2_Mt_branch.SetAddress(<void*>&self.m1_m2_Mt_value)

        #print "making m1_m2_MtTotal"
        self.m1_m2_MtTotal_branch = the_tree.GetBranch("m1_m2_MtTotal")
        #if not self.m1_m2_MtTotal_branch and "m1_m2_MtTotal" not in self.complained:
        if not self.m1_m2_MtTotal_branch and "m1_m2_MtTotal":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_MtTotal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MtTotal")
        else:
            self.m1_m2_MtTotal_branch.SetAddress(<void*>&self.m1_m2_MtTotal_value)

        #print "making m1_m2_Mt_TauEnDown"
        self.m1_m2_Mt_TauEnDown_branch = the_tree.GetBranch("m1_m2_Mt_TauEnDown")
        #if not self.m1_m2_Mt_TauEnDown_branch and "m1_m2_Mt_TauEnDown" not in self.complained:
        if not self.m1_m2_Mt_TauEnDown_branch and "m1_m2_Mt_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_Mt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mt_TauEnDown")
        else:
            self.m1_m2_Mt_TauEnDown_branch.SetAddress(<void*>&self.m1_m2_Mt_TauEnDown_value)

        #print "making m1_m2_Mt_TauEnUp"
        self.m1_m2_Mt_TauEnUp_branch = the_tree.GetBranch("m1_m2_Mt_TauEnUp")
        #if not self.m1_m2_Mt_TauEnUp_branch and "m1_m2_Mt_TauEnUp" not in self.complained:
        if not self.m1_m2_Mt_TauEnUp_branch and "m1_m2_Mt_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_Mt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mt_TauEnUp")
        else:
            self.m1_m2_Mt_TauEnUp_branch.SetAddress(<void*>&self.m1_m2_Mt_TauEnUp_value)

        #print "making m1_m2_MvaMet"
        self.m1_m2_MvaMet_branch = the_tree.GetBranch("m1_m2_MvaMet")
        #if not self.m1_m2_MvaMet_branch and "m1_m2_MvaMet" not in self.complained:
        if not self.m1_m2_MvaMet_branch and "m1_m2_MvaMet":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_MvaMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMet")
        else:
            self.m1_m2_MvaMet_branch.SetAddress(<void*>&self.m1_m2_MvaMet_value)

        #print "making m1_m2_MvaMetCovMatrix00"
        self.m1_m2_MvaMetCovMatrix00_branch = the_tree.GetBranch("m1_m2_MvaMetCovMatrix00")
        #if not self.m1_m2_MvaMetCovMatrix00_branch and "m1_m2_MvaMetCovMatrix00" not in self.complained:
        if not self.m1_m2_MvaMetCovMatrix00_branch and "m1_m2_MvaMetCovMatrix00":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_MvaMetCovMatrix00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetCovMatrix00")
        else:
            self.m1_m2_MvaMetCovMatrix00_branch.SetAddress(<void*>&self.m1_m2_MvaMetCovMatrix00_value)

        #print "making m1_m2_MvaMetCovMatrix01"
        self.m1_m2_MvaMetCovMatrix01_branch = the_tree.GetBranch("m1_m2_MvaMetCovMatrix01")
        #if not self.m1_m2_MvaMetCovMatrix01_branch and "m1_m2_MvaMetCovMatrix01" not in self.complained:
        if not self.m1_m2_MvaMetCovMatrix01_branch and "m1_m2_MvaMetCovMatrix01":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_MvaMetCovMatrix01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetCovMatrix01")
        else:
            self.m1_m2_MvaMetCovMatrix01_branch.SetAddress(<void*>&self.m1_m2_MvaMetCovMatrix01_value)

        #print "making m1_m2_MvaMetCovMatrix10"
        self.m1_m2_MvaMetCovMatrix10_branch = the_tree.GetBranch("m1_m2_MvaMetCovMatrix10")
        #if not self.m1_m2_MvaMetCovMatrix10_branch and "m1_m2_MvaMetCovMatrix10" not in self.complained:
        if not self.m1_m2_MvaMetCovMatrix10_branch and "m1_m2_MvaMetCovMatrix10":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_MvaMetCovMatrix10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetCovMatrix10")
        else:
            self.m1_m2_MvaMetCovMatrix10_branch.SetAddress(<void*>&self.m1_m2_MvaMetCovMatrix10_value)

        #print "making m1_m2_MvaMetCovMatrix11"
        self.m1_m2_MvaMetCovMatrix11_branch = the_tree.GetBranch("m1_m2_MvaMetCovMatrix11")
        #if not self.m1_m2_MvaMetCovMatrix11_branch and "m1_m2_MvaMetCovMatrix11" not in self.complained:
        if not self.m1_m2_MvaMetCovMatrix11_branch and "m1_m2_MvaMetCovMatrix11":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_MvaMetCovMatrix11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetCovMatrix11")
        else:
            self.m1_m2_MvaMetCovMatrix11_branch.SetAddress(<void*>&self.m1_m2_MvaMetCovMatrix11_value)

        #print "making m1_m2_MvaMetPhi"
        self.m1_m2_MvaMetPhi_branch = the_tree.GetBranch("m1_m2_MvaMetPhi")
        #if not self.m1_m2_MvaMetPhi_branch and "m1_m2_MvaMetPhi" not in self.complained:
        if not self.m1_m2_MvaMetPhi_branch and "m1_m2_MvaMetPhi":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_MvaMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetPhi")
        else:
            self.m1_m2_MvaMetPhi_branch.SetAddress(<void*>&self.m1_m2_MvaMetPhi_value)

        #print "making m1_m2_PZeta"
        self.m1_m2_PZeta_branch = the_tree.GetBranch("m1_m2_PZeta")
        #if not self.m1_m2_PZeta_branch and "m1_m2_PZeta" not in self.complained:
        if not self.m1_m2_PZeta_branch and "m1_m2_PZeta":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZeta")
        else:
            self.m1_m2_PZeta_branch.SetAddress(<void*>&self.m1_m2_PZeta_value)

        #print "making m1_m2_PZetaLess0p85PZetaVis"
        self.m1_m2_PZetaLess0p85PZetaVis_branch = the_tree.GetBranch("m1_m2_PZetaLess0p85PZetaVis")
        #if not self.m1_m2_PZetaLess0p85PZetaVis_branch and "m1_m2_PZetaLess0p85PZetaVis" not in self.complained:
        if not self.m1_m2_PZetaLess0p85PZetaVis_branch and "m1_m2_PZetaLess0p85PZetaVis":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_PZetaLess0p85PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZetaLess0p85PZetaVis")
        else:
            self.m1_m2_PZetaLess0p85PZetaVis_branch.SetAddress(<void*>&self.m1_m2_PZetaLess0p85PZetaVis_value)

        #print "making m1_m2_PZetaVis"
        self.m1_m2_PZetaVis_branch = the_tree.GetBranch("m1_m2_PZetaVis")
        #if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis" not in self.complained:
        if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZetaVis")
        else:
            self.m1_m2_PZetaVis_branch.SetAddress(<void*>&self.m1_m2_PZetaVis_value)

        #print "making m1_m2_Phi"
        self.m1_m2_Phi_branch = the_tree.GetBranch("m1_m2_Phi")
        #if not self.m1_m2_Phi_branch and "m1_m2_Phi" not in self.complained:
        if not self.m1_m2_Phi_branch and "m1_m2_Phi":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Phi")
        else:
            self.m1_m2_Phi_branch.SetAddress(<void*>&self.m1_m2_Phi_value)

        #print "making m1_m2_Pt"
        self.m1_m2_Pt_branch = the_tree.GetBranch("m1_m2_Pt")
        #if not self.m1_m2_Pt_branch and "m1_m2_Pt" not in self.complained:
        if not self.m1_m2_Pt_branch and "m1_m2_Pt":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Pt")
        else:
            self.m1_m2_Pt_branch.SetAddress(<void*>&self.m1_m2_Pt_value)

        #print "making m1_m2_SS"
        self.m1_m2_SS_branch = the_tree.GetBranch("m1_m2_SS")
        #if not self.m1_m2_SS_branch and "m1_m2_SS" not in self.complained:
        if not self.m1_m2_SS_branch and "m1_m2_SS":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_SS")
        else:
            self.m1_m2_SS_branch.SetAddress(<void*>&self.m1_m2_SS_value)

        #print "making m1_m2_ToMETDPhi_Ty1"
        self.m1_m2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_m2_ToMETDPhi_Ty1")
        #if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_ToMETDPhi_Ty1")
        else:
            self.m1_m2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_m2_ToMETDPhi_Ty1_value)

        #print "making m1_m2_collinearmass"
        self.m1_m2_collinearmass_branch = the_tree.GetBranch("m1_m2_collinearmass")
        #if not self.m1_m2_collinearmass_branch and "m1_m2_collinearmass" not in self.complained:
        if not self.m1_m2_collinearmass_branch and "m1_m2_collinearmass":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass")
        else:
            self.m1_m2_collinearmass_branch.SetAddress(<void*>&self.m1_m2_collinearmass_value)

        #print "making m1_m2_collinearmass_EleEnDown"
        self.m1_m2_collinearmass_EleEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_EleEnDown")
        #if not self.m1_m2_collinearmass_EleEnDown_branch and "m1_m2_collinearmass_EleEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_EleEnDown_branch and "m1_m2_collinearmass_EleEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_collinearmass_EleEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_EleEnDown")
        else:
            self.m1_m2_collinearmass_EleEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_EleEnDown_value)

        #print "making m1_m2_collinearmass_EleEnUp"
        self.m1_m2_collinearmass_EleEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_EleEnUp")
        #if not self.m1_m2_collinearmass_EleEnUp_branch and "m1_m2_collinearmass_EleEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_EleEnUp_branch and "m1_m2_collinearmass_EleEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_collinearmass_EleEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_EleEnUp")
        else:
            self.m1_m2_collinearmass_EleEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_EleEnUp_value)

        #print "making m1_m2_collinearmass_JetEnDown"
        self.m1_m2_collinearmass_JetEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_JetEnDown")
        #if not self.m1_m2_collinearmass_JetEnDown_branch and "m1_m2_collinearmass_JetEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_JetEnDown_branch and "m1_m2_collinearmass_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_JetEnDown")
        else:
            self.m1_m2_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_JetEnDown_value)

        #print "making m1_m2_collinearmass_JetEnUp"
        self.m1_m2_collinearmass_JetEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_JetEnUp")
        #if not self.m1_m2_collinearmass_JetEnUp_branch and "m1_m2_collinearmass_JetEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_JetEnUp_branch and "m1_m2_collinearmass_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_JetEnUp")
        else:
            self.m1_m2_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_JetEnUp_value)

        #print "making m1_m2_collinearmass_MuEnDown"
        self.m1_m2_collinearmass_MuEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_MuEnDown")
        #if not self.m1_m2_collinearmass_MuEnDown_branch and "m1_m2_collinearmass_MuEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_MuEnDown_branch and "m1_m2_collinearmass_MuEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_collinearmass_MuEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_MuEnDown")
        else:
            self.m1_m2_collinearmass_MuEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_MuEnDown_value)

        #print "making m1_m2_collinearmass_MuEnUp"
        self.m1_m2_collinearmass_MuEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_MuEnUp")
        #if not self.m1_m2_collinearmass_MuEnUp_branch and "m1_m2_collinearmass_MuEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_MuEnUp_branch and "m1_m2_collinearmass_MuEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_collinearmass_MuEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_MuEnUp")
        else:
            self.m1_m2_collinearmass_MuEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_MuEnUp_value)

        #print "making m1_m2_collinearmass_TauEnDown"
        self.m1_m2_collinearmass_TauEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_TauEnDown")
        #if not self.m1_m2_collinearmass_TauEnDown_branch and "m1_m2_collinearmass_TauEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_TauEnDown_branch and "m1_m2_collinearmass_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_collinearmass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_TauEnDown")
        else:
            self.m1_m2_collinearmass_TauEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_TauEnDown_value)

        #print "making m1_m2_collinearmass_TauEnUp"
        self.m1_m2_collinearmass_TauEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_TauEnUp")
        #if not self.m1_m2_collinearmass_TauEnUp_branch and "m1_m2_collinearmass_TauEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_TauEnUp_branch and "m1_m2_collinearmass_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_collinearmass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_TauEnUp")
        else:
            self.m1_m2_collinearmass_TauEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_TauEnUp_value)

        #print "making m1_m2_collinearmass_UnclusteredEnDown"
        self.m1_m2_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_UnclusteredEnDown")
        #if not self.m1_m2_collinearmass_UnclusteredEnDown_branch and "m1_m2_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_UnclusteredEnDown_branch and "m1_m2_collinearmass_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_UnclusteredEnDown")
        else:
            self.m1_m2_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_UnclusteredEnDown_value)

        #print "making m1_m2_collinearmass_UnclusteredEnUp"
        self.m1_m2_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_UnclusteredEnUp")
        #if not self.m1_m2_collinearmass_UnclusteredEnUp_branch and "m1_m2_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_UnclusteredEnUp_branch and "m1_m2_collinearmass_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_UnclusteredEnUp")
        else:
            self.m1_m2_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_UnclusteredEnUp_value)

        #print "making m1_m2_pt_tt"
        self.m1_m2_pt_tt_branch = the_tree.GetBranch("m1_m2_pt_tt")
        #if not self.m1_m2_pt_tt_branch and "m1_m2_pt_tt" not in self.complained:
        if not self.m1_m2_pt_tt_branch and "m1_m2_pt_tt":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_pt_tt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_pt_tt")
        else:
            self.m1_m2_pt_tt_branch.SetAddress(<void*>&self.m1_m2_pt_tt_value)

        #print "making m1_m3_CosThetaStar"
        self.m1_m3_CosThetaStar_branch = the_tree.GetBranch("m1_m3_CosThetaStar")
        #if not self.m1_m3_CosThetaStar_branch and "m1_m3_CosThetaStar" not in self.complained:
        if not self.m1_m3_CosThetaStar_branch and "m1_m3_CosThetaStar":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_CosThetaStar")
        else:
            self.m1_m3_CosThetaStar_branch.SetAddress(<void*>&self.m1_m3_CosThetaStar_value)

        #print "making m1_m3_DPhi"
        self.m1_m3_DPhi_branch = the_tree.GetBranch("m1_m3_DPhi")
        #if not self.m1_m3_DPhi_branch and "m1_m3_DPhi" not in self.complained:
        if not self.m1_m3_DPhi_branch and "m1_m3_DPhi":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_DPhi")
        else:
            self.m1_m3_DPhi_branch.SetAddress(<void*>&self.m1_m3_DPhi_value)

        #print "making m1_m3_DR"
        self.m1_m3_DR_branch = the_tree.GetBranch("m1_m3_DR")
        #if not self.m1_m3_DR_branch and "m1_m3_DR" not in self.complained:
        if not self.m1_m3_DR_branch and "m1_m3_DR":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_DR")
        else:
            self.m1_m3_DR_branch.SetAddress(<void*>&self.m1_m3_DR_value)

        #print "making m1_m3_Eta"
        self.m1_m3_Eta_branch = the_tree.GetBranch("m1_m3_Eta")
        #if not self.m1_m3_Eta_branch and "m1_m3_Eta" not in self.complained:
        if not self.m1_m3_Eta_branch and "m1_m3_Eta":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Eta")
        else:
            self.m1_m3_Eta_branch.SetAddress(<void*>&self.m1_m3_Eta_value)

        #print "making m1_m3_Mass"
        self.m1_m3_Mass_branch = the_tree.GetBranch("m1_m3_Mass")
        #if not self.m1_m3_Mass_branch and "m1_m3_Mass" not in self.complained:
        if not self.m1_m3_Mass_branch and "m1_m3_Mass":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Mass")
        else:
            self.m1_m3_Mass_branch.SetAddress(<void*>&self.m1_m3_Mass_value)

        #print "making m1_m3_Mass_TauEnDown"
        self.m1_m3_Mass_TauEnDown_branch = the_tree.GetBranch("m1_m3_Mass_TauEnDown")
        #if not self.m1_m3_Mass_TauEnDown_branch and "m1_m3_Mass_TauEnDown" not in self.complained:
        if not self.m1_m3_Mass_TauEnDown_branch and "m1_m3_Mass_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_Mass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Mass_TauEnDown")
        else:
            self.m1_m3_Mass_TauEnDown_branch.SetAddress(<void*>&self.m1_m3_Mass_TauEnDown_value)

        #print "making m1_m3_Mass_TauEnUp"
        self.m1_m3_Mass_TauEnUp_branch = the_tree.GetBranch("m1_m3_Mass_TauEnUp")
        #if not self.m1_m3_Mass_TauEnUp_branch and "m1_m3_Mass_TauEnUp" not in self.complained:
        if not self.m1_m3_Mass_TauEnUp_branch and "m1_m3_Mass_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_Mass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Mass_TauEnUp")
        else:
            self.m1_m3_Mass_TauEnUp_branch.SetAddress(<void*>&self.m1_m3_Mass_TauEnUp_value)

        #print "making m1_m3_Mt"
        self.m1_m3_Mt_branch = the_tree.GetBranch("m1_m3_Mt")
        #if not self.m1_m3_Mt_branch and "m1_m3_Mt" not in self.complained:
        if not self.m1_m3_Mt_branch and "m1_m3_Mt":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Mt")
        else:
            self.m1_m3_Mt_branch.SetAddress(<void*>&self.m1_m3_Mt_value)

        #print "making m1_m3_MtTotal"
        self.m1_m3_MtTotal_branch = the_tree.GetBranch("m1_m3_MtTotal")
        #if not self.m1_m3_MtTotal_branch and "m1_m3_MtTotal" not in self.complained:
        if not self.m1_m3_MtTotal_branch and "m1_m3_MtTotal":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_MtTotal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_MtTotal")
        else:
            self.m1_m3_MtTotal_branch.SetAddress(<void*>&self.m1_m3_MtTotal_value)

        #print "making m1_m3_Mt_TauEnDown"
        self.m1_m3_Mt_TauEnDown_branch = the_tree.GetBranch("m1_m3_Mt_TauEnDown")
        #if not self.m1_m3_Mt_TauEnDown_branch and "m1_m3_Mt_TauEnDown" not in self.complained:
        if not self.m1_m3_Mt_TauEnDown_branch and "m1_m3_Mt_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_Mt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Mt_TauEnDown")
        else:
            self.m1_m3_Mt_TauEnDown_branch.SetAddress(<void*>&self.m1_m3_Mt_TauEnDown_value)

        #print "making m1_m3_Mt_TauEnUp"
        self.m1_m3_Mt_TauEnUp_branch = the_tree.GetBranch("m1_m3_Mt_TauEnUp")
        #if not self.m1_m3_Mt_TauEnUp_branch and "m1_m3_Mt_TauEnUp" not in self.complained:
        if not self.m1_m3_Mt_TauEnUp_branch and "m1_m3_Mt_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_Mt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Mt_TauEnUp")
        else:
            self.m1_m3_Mt_TauEnUp_branch.SetAddress(<void*>&self.m1_m3_Mt_TauEnUp_value)

        #print "making m1_m3_MvaMet"
        self.m1_m3_MvaMet_branch = the_tree.GetBranch("m1_m3_MvaMet")
        #if not self.m1_m3_MvaMet_branch and "m1_m3_MvaMet" not in self.complained:
        if not self.m1_m3_MvaMet_branch and "m1_m3_MvaMet":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_MvaMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_MvaMet")
        else:
            self.m1_m3_MvaMet_branch.SetAddress(<void*>&self.m1_m3_MvaMet_value)

        #print "making m1_m3_MvaMetCovMatrix00"
        self.m1_m3_MvaMetCovMatrix00_branch = the_tree.GetBranch("m1_m3_MvaMetCovMatrix00")
        #if not self.m1_m3_MvaMetCovMatrix00_branch and "m1_m3_MvaMetCovMatrix00" not in self.complained:
        if not self.m1_m3_MvaMetCovMatrix00_branch and "m1_m3_MvaMetCovMatrix00":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_MvaMetCovMatrix00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_MvaMetCovMatrix00")
        else:
            self.m1_m3_MvaMetCovMatrix00_branch.SetAddress(<void*>&self.m1_m3_MvaMetCovMatrix00_value)

        #print "making m1_m3_MvaMetCovMatrix01"
        self.m1_m3_MvaMetCovMatrix01_branch = the_tree.GetBranch("m1_m3_MvaMetCovMatrix01")
        #if not self.m1_m3_MvaMetCovMatrix01_branch and "m1_m3_MvaMetCovMatrix01" not in self.complained:
        if not self.m1_m3_MvaMetCovMatrix01_branch and "m1_m3_MvaMetCovMatrix01":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_MvaMetCovMatrix01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_MvaMetCovMatrix01")
        else:
            self.m1_m3_MvaMetCovMatrix01_branch.SetAddress(<void*>&self.m1_m3_MvaMetCovMatrix01_value)

        #print "making m1_m3_MvaMetCovMatrix10"
        self.m1_m3_MvaMetCovMatrix10_branch = the_tree.GetBranch("m1_m3_MvaMetCovMatrix10")
        #if not self.m1_m3_MvaMetCovMatrix10_branch and "m1_m3_MvaMetCovMatrix10" not in self.complained:
        if not self.m1_m3_MvaMetCovMatrix10_branch and "m1_m3_MvaMetCovMatrix10":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_MvaMetCovMatrix10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_MvaMetCovMatrix10")
        else:
            self.m1_m3_MvaMetCovMatrix10_branch.SetAddress(<void*>&self.m1_m3_MvaMetCovMatrix10_value)

        #print "making m1_m3_MvaMetCovMatrix11"
        self.m1_m3_MvaMetCovMatrix11_branch = the_tree.GetBranch("m1_m3_MvaMetCovMatrix11")
        #if not self.m1_m3_MvaMetCovMatrix11_branch and "m1_m3_MvaMetCovMatrix11" not in self.complained:
        if not self.m1_m3_MvaMetCovMatrix11_branch and "m1_m3_MvaMetCovMatrix11":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_MvaMetCovMatrix11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_MvaMetCovMatrix11")
        else:
            self.m1_m3_MvaMetCovMatrix11_branch.SetAddress(<void*>&self.m1_m3_MvaMetCovMatrix11_value)

        #print "making m1_m3_MvaMetPhi"
        self.m1_m3_MvaMetPhi_branch = the_tree.GetBranch("m1_m3_MvaMetPhi")
        #if not self.m1_m3_MvaMetPhi_branch and "m1_m3_MvaMetPhi" not in self.complained:
        if not self.m1_m3_MvaMetPhi_branch and "m1_m3_MvaMetPhi":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_MvaMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_MvaMetPhi")
        else:
            self.m1_m3_MvaMetPhi_branch.SetAddress(<void*>&self.m1_m3_MvaMetPhi_value)

        #print "making m1_m3_PZeta"
        self.m1_m3_PZeta_branch = the_tree.GetBranch("m1_m3_PZeta")
        #if not self.m1_m3_PZeta_branch and "m1_m3_PZeta" not in self.complained:
        if not self.m1_m3_PZeta_branch and "m1_m3_PZeta":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_PZeta")
        else:
            self.m1_m3_PZeta_branch.SetAddress(<void*>&self.m1_m3_PZeta_value)

        #print "making m1_m3_PZetaLess0p85PZetaVis"
        self.m1_m3_PZetaLess0p85PZetaVis_branch = the_tree.GetBranch("m1_m3_PZetaLess0p85PZetaVis")
        #if not self.m1_m3_PZetaLess0p85PZetaVis_branch and "m1_m3_PZetaLess0p85PZetaVis" not in self.complained:
        if not self.m1_m3_PZetaLess0p85PZetaVis_branch and "m1_m3_PZetaLess0p85PZetaVis":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_PZetaLess0p85PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_PZetaLess0p85PZetaVis")
        else:
            self.m1_m3_PZetaLess0p85PZetaVis_branch.SetAddress(<void*>&self.m1_m3_PZetaLess0p85PZetaVis_value)

        #print "making m1_m3_PZetaVis"
        self.m1_m3_PZetaVis_branch = the_tree.GetBranch("m1_m3_PZetaVis")
        #if not self.m1_m3_PZetaVis_branch and "m1_m3_PZetaVis" not in self.complained:
        if not self.m1_m3_PZetaVis_branch and "m1_m3_PZetaVis":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_PZetaVis")
        else:
            self.m1_m3_PZetaVis_branch.SetAddress(<void*>&self.m1_m3_PZetaVis_value)

        #print "making m1_m3_Phi"
        self.m1_m3_Phi_branch = the_tree.GetBranch("m1_m3_Phi")
        #if not self.m1_m3_Phi_branch and "m1_m3_Phi" not in self.complained:
        if not self.m1_m3_Phi_branch and "m1_m3_Phi":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Phi")
        else:
            self.m1_m3_Phi_branch.SetAddress(<void*>&self.m1_m3_Phi_value)

        #print "making m1_m3_Pt"
        self.m1_m3_Pt_branch = the_tree.GetBranch("m1_m3_Pt")
        #if not self.m1_m3_Pt_branch and "m1_m3_Pt" not in self.complained:
        if not self.m1_m3_Pt_branch and "m1_m3_Pt":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Pt")
        else:
            self.m1_m3_Pt_branch.SetAddress(<void*>&self.m1_m3_Pt_value)

        #print "making m1_m3_SS"
        self.m1_m3_SS_branch = the_tree.GetBranch("m1_m3_SS")
        #if not self.m1_m3_SS_branch and "m1_m3_SS" not in self.complained:
        if not self.m1_m3_SS_branch and "m1_m3_SS":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_SS")
        else:
            self.m1_m3_SS_branch.SetAddress(<void*>&self.m1_m3_SS_value)

        #print "making m1_m3_ToMETDPhi_Ty1"
        self.m1_m3_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_m3_ToMETDPhi_Ty1")
        #if not self.m1_m3_ToMETDPhi_Ty1_branch and "m1_m3_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_m3_ToMETDPhi_Ty1_branch and "m1_m3_ToMETDPhi_Ty1":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_ToMETDPhi_Ty1")
        else:
            self.m1_m3_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_m3_ToMETDPhi_Ty1_value)

        #print "making m1_m3_collinearmass"
        self.m1_m3_collinearmass_branch = the_tree.GetBranch("m1_m3_collinearmass")
        #if not self.m1_m3_collinearmass_branch and "m1_m3_collinearmass" not in self.complained:
        if not self.m1_m3_collinearmass_branch and "m1_m3_collinearmass":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_collinearmass")
        else:
            self.m1_m3_collinearmass_branch.SetAddress(<void*>&self.m1_m3_collinearmass_value)

        #print "making m1_m3_collinearmass_EleEnDown"
        self.m1_m3_collinearmass_EleEnDown_branch = the_tree.GetBranch("m1_m3_collinearmass_EleEnDown")
        #if not self.m1_m3_collinearmass_EleEnDown_branch and "m1_m3_collinearmass_EleEnDown" not in self.complained:
        if not self.m1_m3_collinearmass_EleEnDown_branch and "m1_m3_collinearmass_EleEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_collinearmass_EleEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_collinearmass_EleEnDown")
        else:
            self.m1_m3_collinearmass_EleEnDown_branch.SetAddress(<void*>&self.m1_m3_collinearmass_EleEnDown_value)

        #print "making m1_m3_collinearmass_EleEnUp"
        self.m1_m3_collinearmass_EleEnUp_branch = the_tree.GetBranch("m1_m3_collinearmass_EleEnUp")
        #if not self.m1_m3_collinearmass_EleEnUp_branch and "m1_m3_collinearmass_EleEnUp" not in self.complained:
        if not self.m1_m3_collinearmass_EleEnUp_branch and "m1_m3_collinearmass_EleEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_collinearmass_EleEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_collinearmass_EleEnUp")
        else:
            self.m1_m3_collinearmass_EleEnUp_branch.SetAddress(<void*>&self.m1_m3_collinearmass_EleEnUp_value)

        #print "making m1_m3_collinearmass_JetEnDown"
        self.m1_m3_collinearmass_JetEnDown_branch = the_tree.GetBranch("m1_m3_collinearmass_JetEnDown")
        #if not self.m1_m3_collinearmass_JetEnDown_branch and "m1_m3_collinearmass_JetEnDown" not in self.complained:
        if not self.m1_m3_collinearmass_JetEnDown_branch and "m1_m3_collinearmass_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_collinearmass_JetEnDown")
        else:
            self.m1_m3_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m1_m3_collinearmass_JetEnDown_value)

        #print "making m1_m3_collinearmass_JetEnUp"
        self.m1_m3_collinearmass_JetEnUp_branch = the_tree.GetBranch("m1_m3_collinearmass_JetEnUp")
        #if not self.m1_m3_collinearmass_JetEnUp_branch and "m1_m3_collinearmass_JetEnUp" not in self.complained:
        if not self.m1_m3_collinearmass_JetEnUp_branch and "m1_m3_collinearmass_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_collinearmass_JetEnUp")
        else:
            self.m1_m3_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m1_m3_collinearmass_JetEnUp_value)

        #print "making m1_m3_collinearmass_MuEnDown"
        self.m1_m3_collinearmass_MuEnDown_branch = the_tree.GetBranch("m1_m3_collinearmass_MuEnDown")
        #if not self.m1_m3_collinearmass_MuEnDown_branch and "m1_m3_collinearmass_MuEnDown" not in self.complained:
        if not self.m1_m3_collinearmass_MuEnDown_branch and "m1_m3_collinearmass_MuEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_collinearmass_MuEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_collinearmass_MuEnDown")
        else:
            self.m1_m3_collinearmass_MuEnDown_branch.SetAddress(<void*>&self.m1_m3_collinearmass_MuEnDown_value)

        #print "making m1_m3_collinearmass_MuEnUp"
        self.m1_m3_collinearmass_MuEnUp_branch = the_tree.GetBranch("m1_m3_collinearmass_MuEnUp")
        #if not self.m1_m3_collinearmass_MuEnUp_branch and "m1_m3_collinearmass_MuEnUp" not in self.complained:
        if not self.m1_m3_collinearmass_MuEnUp_branch and "m1_m3_collinearmass_MuEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_collinearmass_MuEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_collinearmass_MuEnUp")
        else:
            self.m1_m3_collinearmass_MuEnUp_branch.SetAddress(<void*>&self.m1_m3_collinearmass_MuEnUp_value)

        #print "making m1_m3_collinearmass_TauEnDown"
        self.m1_m3_collinearmass_TauEnDown_branch = the_tree.GetBranch("m1_m3_collinearmass_TauEnDown")
        #if not self.m1_m3_collinearmass_TauEnDown_branch and "m1_m3_collinearmass_TauEnDown" not in self.complained:
        if not self.m1_m3_collinearmass_TauEnDown_branch and "m1_m3_collinearmass_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_collinearmass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_collinearmass_TauEnDown")
        else:
            self.m1_m3_collinearmass_TauEnDown_branch.SetAddress(<void*>&self.m1_m3_collinearmass_TauEnDown_value)

        #print "making m1_m3_collinearmass_TauEnUp"
        self.m1_m3_collinearmass_TauEnUp_branch = the_tree.GetBranch("m1_m3_collinearmass_TauEnUp")
        #if not self.m1_m3_collinearmass_TauEnUp_branch and "m1_m3_collinearmass_TauEnUp" not in self.complained:
        if not self.m1_m3_collinearmass_TauEnUp_branch and "m1_m3_collinearmass_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_collinearmass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_collinearmass_TauEnUp")
        else:
            self.m1_m3_collinearmass_TauEnUp_branch.SetAddress(<void*>&self.m1_m3_collinearmass_TauEnUp_value)

        #print "making m1_m3_collinearmass_UnclusteredEnDown"
        self.m1_m3_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m1_m3_collinearmass_UnclusteredEnDown")
        #if not self.m1_m3_collinearmass_UnclusteredEnDown_branch and "m1_m3_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m1_m3_collinearmass_UnclusteredEnDown_branch and "m1_m3_collinearmass_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_collinearmass_UnclusteredEnDown")
        else:
            self.m1_m3_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m1_m3_collinearmass_UnclusteredEnDown_value)

        #print "making m1_m3_collinearmass_UnclusteredEnUp"
        self.m1_m3_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m1_m3_collinearmass_UnclusteredEnUp")
        #if not self.m1_m3_collinearmass_UnclusteredEnUp_branch and "m1_m3_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m1_m3_collinearmass_UnclusteredEnUp_branch and "m1_m3_collinearmass_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_collinearmass_UnclusteredEnUp")
        else:
            self.m1_m3_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m1_m3_collinearmass_UnclusteredEnUp_value)

        #print "making m1_m3_pt_tt"
        self.m1_m3_pt_tt_branch = the_tree.GetBranch("m1_m3_pt_tt")
        #if not self.m1_m3_pt_tt_branch and "m1_m3_pt_tt" not in self.complained:
        if not self.m1_m3_pt_tt_branch and "m1_m3_pt_tt":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_pt_tt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_pt_tt")
        else:
            self.m1_m3_pt_tt_branch.SetAddress(<void*>&self.m1_m3_pt_tt_value)

        #print "making m2AbsEta"
        self.m2AbsEta_branch = the_tree.GetBranch("m2AbsEta")
        #if not self.m2AbsEta_branch and "m2AbsEta" not in self.complained:
        if not self.m2AbsEta_branch and "m2AbsEta":
            warnings.warn( "MuMuMuTree: Expected branch m2AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2AbsEta")
        else:
            self.m2AbsEta_branch.SetAddress(<void*>&self.m2AbsEta_value)

        #print "making m2BestTrackType"
        self.m2BestTrackType_branch = the_tree.GetBranch("m2BestTrackType")
        #if not self.m2BestTrackType_branch and "m2BestTrackType" not in self.complained:
        if not self.m2BestTrackType_branch and "m2BestTrackType":
            warnings.warn( "MuMuMuTree: Expected branch m2BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2BestTrackType")
        else:
            self.m2BestTrackType_branch.SetAddress(<void*>&self.m2BestTrackType_value)

        #print "making m2Charge"
        self.m2Charge_branch = the_tree.GetBranch("m2Charge")
        #if not self.m2Charge_branch and "m2Charge" not in self.complained:
        if not self.m2Charge_branch and "m2Charge":
            warnings.warn( "MuMuMuTree: Expected branch m2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Charge")
        else:
            self.m2Charge_branch.SetAddress(<void*>&self.m2Charge_value)

        #print "making m2Chi2LocalPosition"
        self.m2Chi2LocalPosition_branch = the_tree.GetBranch("m2Chi2LocalPosition")
        #if not self.m2Chi2LocalPosition_branch and "m2Chi2LocalPosition" not in self.complained:
        if not self.m2Chi2LocalPosition_branch and "m2Chi2LocalPosition":
            warnings.warn( "MuMuMuTree: Expected branch m2Chi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Chi2LocalPosition")
        else:
            self.m2Chi2LocalPosition_branch.SetAddress(<void*>&self.m2Chi2LocalPosition_value)

        #print "making m2ComesFromHiggs"
        self.m2ComesFromHiggs_branch = the_tree.GetBranch("m2ComesFromHiggs")
        #if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs" not in self.complained:
        if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs":
            warnings.warn( "MuMuMuTree: Expected branch m2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ComesFromHiggs")
        else:
            self.m2ComesFromHiggs_branch.SetAddress(<void*>&self.m2ComesFromHiggs_value)

        #print "making m2DPhiToPfMet_ElectronEnDown"
        self.m2DPhiToPfMet_ElectronEnDown_branch = the_tree.GetBranch("m2DPhiToPfMet_ElectronEnDown")
        #if not self.m2DPhiToPfMet_ElectronEnDown_branch and "m2DPhiToPfMet_ElectronEnDown" not in self.complained:
        if not self.m2DPhiToPfMet_ElectronEnDown_branch and "m2DPhiToPfMet_ElectronEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_ElectronEnDown")
        else:
            self.m2DPhiToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_ElectronEnDown_value)

        #print "making m2DPhiToPfMet_ElectronEnUp"
        self.m2DPhiToPfMet_ElectronEnUp_branch = the_tree.GetBranch("m2DPhiToPfMet_ElectronEnUp")
        #if not self.m2DPhiToPfMet_ElectronEnUp_branch and "m2DPhiToPfMet_ElectronEnUp" not in self.complained:
        if not self.m2DPhiToPfMet_ElectronEnUp_branch and "m2DPhiToPfMet_ElectronEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_ElectronEnUp")
        else:
            self.m2DPhiToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_ElectronEnUp_value)

        #print "making m2DPhiToPfMet_JetEnDown"
        self.m2DPhiToPfMet_JetEnDown_branch = the_tree.GetBranch("m2DPhiToPfMet_JetEnDown")
        #if not self.m2DPhiToPfMet_JetEnDown_branch and "m2DPhiToPfMet_JetEnDown" not in self.complained:
        if not self.m2DPhiToPfMet_JetEnDown_branch and "m2DPhiToPfMet_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_JetEnDown")
        else:
            self.m2DPhiToPfMet_JetEnDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_JetEnDown_value)

        #print "making m2DPhiToPfMet_JetEnUp"
        self.m2DPhiToPfMet_JetEnUp_branch = the_tree.GetBranch("m2DPhiToPfMet_JetEnUp")
        #if not self.m2DPhiToPfMet_JetEnUp_branch and "m2DPhiToPfMet_JetEnUp" not in self.complained:
        if not self.m2DPhiToPfMet_JetEnUp_branch and "m2DPhiToPfMet_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_JetEnUp")
        else:
            self.m2DPhiToPfMet_JetEnUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_JetEnUp_value)

        #print "making m2DPhiToPfMet_JetResDown"
        self.m2DPhiToPfMet_JetResDown_branch = the_tree.GetBranch("m2DPhiToPfMet_JetResDown")
        #if not self.m2DPhiToPfMet_JetResDown_branch and "m2DPhiToPfMet_JetResDown" not in self.complained:
        if not self.m2DPhiToPfMet_JetResDown_branch and "m2DPhiToPfMet_JetResDown":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_JetResDown")
        else:
            self.m2DPhiToPfMet_JetResDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_JetResDown_value)

        #print "making m2DPhiToPfMet_JetResUp"
        self.m2DPhiToPfMet_JetResUp_branch = the_tree.GetBranch("m2DPhiToPfMet_JetResUp")
        #if not self.m2DPhiToPfMet_JetResUp_branch and "m2DPhiToPfMet_JetResUp" not in self.complained:
        if not self.m2DPhiToPfMet_JetResUp_branch and "m2DPhiToPfMet_JetResUp":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_JetResUp")
        else:
            self.m2DPhiToPfMet_JetResUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_JetResUp_value)

        #print "making m2DPhiToPfMet_MuonEnDown"
        self.m2DPhiToPfMet_MuonEnDown_branch = the_tree.GetBranch("m2DPhiToPfMet_MuonEnDown")
        #if not self.m2DPhiToPfMet_MuonEnDown_branch and "m2DPhiToPfMet_MuonEnDown" not in self.complained:
        if not self.m2DPhiToPfMet_MuonEnDown_branch and "m2DPhiToPfMet_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_MuonEnDown")
        else:
            self.m2DPhiToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_MuonEnDown_value)

        #print "making m2DPhiToPfMet_MuonEnUp"
        self.m2DPhiToPfMet_MuonEnUp_branch = the_tree.GetBranch("m2DPhiToPfMet_MuonEnUp")
        #if not self.m2DPhiToPfMet_MuonEnUp_branch and "m2DPhiToPfMet_MuonEnUp" not in self.complained:
        if not self.m2DPhiToPfMet_MuonEnUp_branch and "m2DPhiToPfMet_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_MuonEnUp")
        else:
            self.m2DPhiToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_MuonEnUp_value)

        #print "making m2DPhiToPfMet_PhotonEnDown"
        self.m2DPhiToPfMet_PhotonEnDown_branch = the_tree.GetBranch("m2DPhiToPfMet_PhotonEnDown")
        #if not self.m2DPhiToPfMet_PhotonEnDown_branch and "m2DPhiToPfMet_PhotonEnDown" not in self.complained:
        if not self.m2DPhiToPfMet_PhotonEnDown_branch and "m2DPhiToPfMet_PhotonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_PhotonEnDown")
        else:
            self.m2DPhiToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_PhotonEnDown_value)

        #print "making m2DPhiToPfMet_PhotonEnUp"
        self.m2DPhiToPfMet_PhotonEnUp_branch = the_tree.GetBranch("m2DPhiToPfMet_PhotonEnUp")
        #if not self.m2DPhiToPfMet_PhotonEnUp_branch and "m2DPhiToPfMet_PhotonEnUp" not in self.complained:
        if not self.m2DPhiToPfMet_PhotonEnUp_branch and "m2DPhiToPfMet_PhotonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_PhotonEnUp")
        else:
            self.m2DPhiToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_PhotonEnUp_value)

        #print "making m2DPhiToPfMet_TauEnDown"
        self.m2DPhiToPfMet_TauEnDown_branch = the_tree.GetBranch("m2DPhiToPfMet_TauEnDown")
        #if not self.m2DPhiToPfMet_TauEnDown_branch and "m2DPhiToPfMet_TauEnDown" not in self.complained:
        if not self.m2DPhiToPfMet_TauEnDown_branch and "m2DPhiToPfMet_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_TauEnDown")
        else:
            self.m2DPhiToPfMet_TauEnDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_TauEnDown_value)

        #print "making m2DPhiToPfMet_TauEnUp"
        self.m2DPhiToPfMet_TauEnUp_branch = the_tree.GetBranch("m2DPhiToPfMet_TauEnUp")
        #if not self.m2DPhiToPfMet_TauEnUp_branch and "m2DPhiToPfMet_TauEnUp" not in self.complained:
        if not self.m2DPhiToPfMet_TauEnUp_branch and "m2DPhiToPfMet_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_TauEnUp")
        else:
            self.m2DPhiToPfMet_TauEnUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_TauEnUp_value)

        #print "making m2DPhiToPfMet_UnclusteredEnDown"
        self.m2DPhiToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("m2DPhiToPfMet_UnclusteredEnDown")
        #if not self.m2DPhiToPfMet_UnclusteredEnDown_branch and "m2DPhiToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.m2DPhiToPfMet_UnclusteredEnDown_branch and "m2DPhiToPfMet_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_UnclusteredEnDown")
        else:
            self.m2DPhiToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_UnclusteredEnDown_value)

        #print "making m2DPhiToPfMet_UnclusteredEnUp"
        self.m2DPhiToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("m2DPhiToPfMet_UnclusteredEnUp")
        #if not self.m2DPhiToPfMet_UnclusteredEnUp_branch and "m2DPhiToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.m2DPhiToPfMet_UnclusteredEnUp_branch and "m2DPhiToPfMet_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_UnclusteredEnUp")
        else:
            self.m2DPhiToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_UnclusteredEnUp_value)

        #print "making m2DPhiToPfMet_type1"
        self.m2DPhiToPfMet_type1_branch = the_tree.GetBranch("m2DPhiToPfMet_type1")
        #if not self.m2DPhiToPfMet_type1_branch and "m2DPhiToPfMet_type1" not in self.complained:
        if not self.m2DPhiToPfMet_type1_branch and "m2DPhiToPfMet_type1":
            warnings.warn( "MuMuMuTree: Expected branch m2DPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_type1")
        else:
            self.m2DPhiToPfMet_type1_branch.SetAddress(<void*>&self.m2DPhiToPfMet_type1_value)

        #print "making m2EcalIsoDR03"
        self.m2EcalIsoDR03_branch = the_tree.GetBranch("m2EcalIsoDR03")
        #if not self.m2EcalIsoDR03_branch and "m2EcalIsoDR03" not in self.complained:
        if not self.m2EcalIsoDR03_branch and "m2EcalIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EcalIsoDR03")
        else:
            self.m2EcalIsoDR03_branch.SetAddress(<void*>&self.m2EcalIsoDR03_value)

        #print "making m2EffectiveArea2011"
        self.m2EffectiveArea2011_branch = the_tree.GetBranch("m2EffectiveArea2011")
        #if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011" not in self.complained:
        if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011":
            warnings.warn( "MuMuMuTree: Expected branch m2EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2011")
        else:
            self.m2EffectiveArea2011_branch.SetAddress(<void*>&self.m2EffectiveArea2011_value)

        #print "making m2EffectiveArea2012"
        self.m2EffectiveArea2012_branch = the_tree.GetBranch("m2EffectiveArea2012")
        #if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012" not in self.complained:
        if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012":
            warnings.warn( "MuMuMuTree: Expected branch m2EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2012")
        else:
            self.m2EffectiveArea2012_branch.SetAddress(<void*>&self.m2EffectiveArea2012_value)

        #print "making m2ErsatzGenEta"
        self.m2ErsatzGenEta_branch = the_tree.GetBranch("m2ErsatzGenEta")
        #if not self.m2ErsatzGenEta_branch and "m2ErsatzGenEta" not in self.complained:
        if not self.m2ErsatzGenEta_branch and "m2ErsatzGenEta":
            warnings.warn( "MuMuMuTree: Expected branch m2ErsatzGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenEta")
        else:
            self.m2ErsatzGenEta_branch.SetAddress(<void*>&self.m2ErsatzGenEta_value)

        #print "making m2ErsatzGenM"
        self.m2ErsatzGenM_branch = the_tree.GetBranch("m2ErsatzGenM")
        #if not self.m2ErsatzGenM_branch and "m2ErsatzGenM" not in self.complained:
        if not self.m2ErsatzGenM_branch and "m2ErsatzGenM":
            warnings.warn( "MuMuMuTree: Expected branch m2ErsatzGenM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenM")
        else:
            self.m2ErsatzGenM_branch.SetAddress(<void*>&self.m2ErsatzGenM_value)

        #print "making m2ErsatzGenPhi"
        self.m2ErsatzGenPhi_branch = the_tree.GetBranch("m2ErsatzGenPhi")
        #if not self.m2ErsatzGenPhi_branch and "m2ErsatzGenPhi" not in self.complained:
        if not self.m2ErsatzGenPhi_branch and "m2ErsatzGenPhi":
            warnings.warn( "MuMuMuTree: Expected branch m2ErsatzGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenPhi")
        else:
            self.m2ErsatzGenPhi_branch.SetAddress(<void*>&self.m2ErsatzGenPhi_value)

        #print "making m2ErsatzGenpT"
        self.m2ErsatzGenpT_branch = the_tree.GetBranch("m2ErsatzGenpT")
        #if not self.m2ErsatzGenpT_branch and "m2ErsatzGenpT" not in self.complained:
        if not self.m2ErsatzGenpT_branch and "m2ErsatzGenpT":
            warnings.warn( "MuMuMuTree: Expected branch m2ErsatzGenpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenpT")
        else:
            self.m2ErsatzGenpT_branch.SetAddress(<void*>&self.m2ErsatzGenpT_value)

        #print "making m2ErsatzGenpX"
        self.m2ErsatzGenpX_branch = the_tree.GetBranch("m2ErsatzGenpX")
        #if not self.m2ErsatzGenpX_branch and "m2ErsatzGenpX" not in self.complained:
        if not self.m2ErsatzGenpX_branch and "m2ErsatzGenpX":
            warnings.warn( "MuMuMuTree: Expected branch m2ErsatzGenpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenpX")
        else:
            self.m2ErsatzGenpX_branch.SetAddress(<void*>&self.m2ErsatzGenpX_value)

        #print "making m2ErsatzGenpY"
        self.m2ErsatzGenpY_branch = the_tree.GetBranch("m2ErsatzGenpY")
        #if not self.m2ErsatzGenpY_branch and "m2ErsatzGenpY" not in self.complained:
        if not self.m2ErsatzGenpY_branch and "m2ErsatzGenpY":
            warnings.warn( "MuMuMuTree: Expected branch m2ErsatzGenpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenpY")
        else:
            self.m2ErsatzGenpY_branch.SetAddress(<void*>&self.m2ErsatzGenpY_value)

        #print "making m2ErsatzVispX"
        self.m2ErsatzVispX_branch = the_tree.GetBranch("m2ErsatzVispX")
        #if not self.m2ErsatzVispX_branch and "m2ErsatzVispX" not in self.complained:
        if not self.m2ErsatzVispX_branch and "m2ErsatzVispX":
            warnings.warn( "MuMuMuTree: Expected branch m2ErsatzVispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzVispX")
        else:
            self.m2ErsatzVispX_branch.SetAddress(<void*>&self.m2ErsatzVispX_value)

        #print "making m2ErsatzVispY"
        self.m2ErsatzVispY_branch = the_tree.GetBranch("m2ErsatzVispY")
        #if not self.m2ErsatzVispY_branch and "m2ErsatzVispY" not in self.complained:
        if not self.m2ErsatzVispY_branch and "m2ErsatzVispY":
            warnings.warn( "MuMuMuTree: Expected branch m2ErsatzVispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzVispY")
        else:
            self.m2ErsatzVispY_branch.SetAddress(<void*>&self.m2ErsatzVispY_value)

        #print "making m2Eta"
        self.m2Eta_branch = the_tree.GetBranch("m2Eta")
        #if not self.m2Eta_branch and "m2Eta" not in self.complained:
        if not self.m2Eta_branch and "m2Eta":
            warnings.warn( "MuMuMuTree: Expected branch m2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta")
        else:
            self.m2Eta_branch.SetAddress(<void*>&self.m2Eta_value)

        #print "making m2Eta_MuonEnDown"
        self.m2Eta_MuonEnDown_branch = the_tree.GetBranch("m2Eta_MuonEnDown")
        #if not self.m2Eta_MuonEnDown_branch and "m2Eta_MuonEnDown" not in self.complained:
        if not self.m2Eta_MuonEnDown_branch and "m2Eta_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2Eta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta_MuonEnDown")
        else:
            self.m2Eta_MuonEnDown_branch.SetAddress(<void*>&self.m2Eta_MuonEnDown_value)

        #print "making m2Eta_MuonEnUp"
        self.m2Eta_MuonEnUp_branch = the_tree.GetBranch("m2Eta_MuonEnUp")
        #if not self.m2Eta_MuonEnUp_branch and "m2Eta_MuonEnUp" not in self.complained:
        if not self.m2Eta_MuonEnUp_branch and "m2Eta_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2Eta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta_MuonEnUp")
        else:
            self.m2Eta_MuonEnUp_branch.SetAddress(<void*>&self.m2Eta_MuonEnUp_value)

        #print "making m2GenCharge"
        self.m2GenCharge_branch = the_tree.GetBranch("m2GenCharge")
        #if not self.m2GenCharge_branch and "m2GenCharge" not in self.complained:
        if not self.m2GenCharge_branch and "m2GenCharge":
            warnings.warn( "MuMuMuTree: Expected branch m2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenCharge")
        else:
            self.m2GenCharge_branch.SetAddress(<void*>&self.m2GenCharge_value)

        #print "making m2GenDirectPromptTauDecayFinalState"
        self.m2GenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("m2GenDirectPromptTauDecayFinalState")
        #if not self.m2GenDirectPromptTauDecayFinalState_branch and "m2GenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.m2GenDirectPromptTauDecayFinalState_branch and "m2GenDirectPromptTauDecayFinalState":
            warnings.warn( "MuMuMuTree: Expected branch m2GenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenDirectPromptTauDecayFinalState")
        else:
            self.m2GenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.m2GenDirectPromptTauDecayFinalState_value)

        #print "making m2GenEnergy"
        self.m2GenEnergy_branch = the_tree.GetBranch("m2GenEnergy")
        #if not self.m2GenEnergy_branch and "m2GenEnergy" not in self.complained:
        if not self.m2GenEnergy_branch and "m2GenEnergy":
            warnings.warn( "MuMuMuTree: Expected branch m2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEnergy")
        else:
            self.m2GenEnergy_branch.SetAddress(<void*>&self.m2GenEnergy_value)

        #print "making m2GenEta"
        self.m2GenEta_branch = the_tree.GetBranch("m2GenEta")
        #if not self.m2GenEta_branch and "m2GenEta" not in self.complained:
        if not self.m2GenEta_branch and "m2GenEta":
            warnings.warn( "MuMuMuTree: Expected branch m2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEta")
        else:
            self.m2GenEta_branch.SetAddress(<void*>&self.m2GenEta_value)

        #print "making m2GenIsPrompt"
        self.m2GenIsPrompt_branch = the_tree.GetBranch("m2GenIsPrompt")
        #if not self.m2GenIsPrompt_branch and "m2GenIsPrompt" not in self.complained:
        if not self.m2GenIsPrompt_branch and "m2GenIsPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m2GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenIsPrompt")
        else:
            self.m2GenIsPrompt_branch.SetAddress(<void*>&self.m2GenIsPrompt_value)

        #print "making m2GenMotherPdgId"
        self.m2GenMotherPdgId_branch = the_tree.GetBranch("m2GenMotherPdgId")
        #if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId" not in self.complained:
        if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId":
            warnings.warn( "MuMuMuTree: Expected branch m2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenMotherPdgId")
        else:
            self.m2GenMotherPdgId_branch.SetAddress(<void*>&self.m2GenMotherPdgId_value)

        #print "making m2GenParticle"
        self.m2GenParticle_branch = the_tree.GetBranch("m2GenParticle")
        #if not self.m2GenParticle_branch and "m2GenParticle" not in self.complained:
        if not self.m2GenParticle_branch and "m2GenParticle":
            warnings.warn( "MuMuMuTree: Expected branch m2GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenParticle")
        else:
            self.m2GenParticle_branch.SetAddress(<void*>&self.m2GenParticle_value)

        #print "making m2GenPdgId"
        self.m2GenPdgId_branch = the_tree.GetBranch("m2GenPdgId")
        #if not self.m2GenPdgId_branch and "m2GenPdgId" not in self.complained:
        if not self.m2GenPdgId_branch and "m2GenPdgId":
            warnings.warn( "MuMuMuTree: Expected branch m2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPdgId")
        else:
            self.m2GenPdgId_branch.SetAddress(<void*>&self.m2GenPdgId_value)

        #print "making m2GenPhi"
        self.m2GenPhi_branch = the_tree.GetBranch("m2GenPhi")
        #if not self.m2GenPhi_branch and "m2GenPhi" not in self.complained:
        if not self.m2GenPhi_branch and "m2GenPhi":
            warnings.warn( "MuMuMuTree: Expected branch m2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPhi")
        else:
            self.m2GenPhi_branch.SetAddress(<void*>&self.m2GenPhi_value)

        #print "making m2GenPrompt"
        self.m2GenPrompt_branch = the_tree.GetBranch("m2GenPrompt")
        #if not self.m2GenPrompt_branch and "m2GenPrompt" not in self.complained:
        if not self.m2GenPrompt_branch and "m2GenPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m2GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPrompt")
        else:
            self.m2GenPrompt_branch.SetAddress(<void*>&self.m2GenPrompt_value)

        #print "making m2GenPromptFinalState"
        self.m2GenPromptFinalState_branch = the_tree.GetBranch("m2GenPromptFinalState")
        #if not self.m2GenPromptFinalState_branch and "m2GenPromptFinalState" not in self.complained:
        if not self.m2GenPromptFinalState_branch and "m2GenPromptFinalState":
            warnings.warn( "MuMuMuTree: Expected branch m2GenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPromptFinalState")
        else:
            self.m2GenPromptFinalState_branch.SetAddress(<void*>&self.m2GenPromptFinalState_value)

        #print "making m2GenPromptTauDecay"
        self.m2GenPromptTauDecay_branch = the_tree.GetBranch("m2GenPromptTauDecay")
        #if not self.m2GenPromptTauDecay_branch and "m2GenPromptTauDecay" not in self.complained:
        if not self.m2GenPromptTauDecay_branch and "m2GenPromptTauDecay":
            warnings.warn( "MuMuMuTree: Expected branch m2GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPromptTauDecay")
        else:
            self.m2GenPromptTauDecay_branch.SetAddress(<void*>&self.m2GenPromptTauDecay_value)

        #print "making m2GenPt"
        self.m2GenPt_branch = the_tree.GetBranch("m2GenPt")
        #if not self.m2GenPt_branch and "m2GenPt" not in self.complained:
        if not self.m2GenPt_branch and "m2GenPt":
            warnings.warn( "MuMuMuTree: Expected branch m2GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPt")
        else:
            self.m2GenPt_branch.SetAddress(<void*>&self.m2GenPt_value)

        #print "making m2GenTauDecay"
        self.m2GenTauDecay_branch = the_tree.GetBranch("m2GenTauDecay")
        #if not self.m2GenTauDecay_branch and "m2GenTauDecay" not in self.complained:
        if not self.m2GenTauDecay_branch and "m2GenTauDecay":
            warnings.warn( "MuMuMuTree: Expected branch m2GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenTauDecay")
        else:
            self.m2GenTauDecay_branch.SetAddress(<void*>&self.m2GenTauDecay_value)

        #print "making m2GenVZ"
        self.m2GenVZ_branch = the_tree.GetBranch("m2GenVZ")
        #if not self.m2GenVZ_branch and "m2GenVZ" not in self.complained:
        if not self.m2GenVZ_branch and "m2GenVZ":
            warnings.warn( "MuMuMuTree: Expected branch m2GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenVZ")
        else:
            self.m2GenVZ_branch.SetAddress(<void*>&self.m2GenVZ_value)

        #print "making m2GenVtxPVMatch"
        self.m2GenVtxPVMatch_branch = the_tree.GetBranch("m2GenVtxPVMatch")
        #if not self.m2GenVtxPVMatch_branch and "m2GenVtxPVMatch" not in self.complained:
        if not self.m2GenVtxPVMatch_branch and "m2GenVtxPVMatch":
            warnings.warn( "MuMuMuTree: Expected branch m2GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenVtxPVMatch")
        else:
            self.m2GenVtxPVMatch_branch.SetAddress(<void*>&self.m2GenVtxPVMatch_value)

        #print "making m2HcalIsoDR03"
        self.m2HcalIsoDR03_branch = the_tree.GetBranch("m2HcalIsoDR03")
        #if not self.m2HcalIsoDR03_branch and "m2HcalIsoDR03" not in self.complained:
        if not self.m2HcalIsoDR03_branch and "m2HcalIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2HcalIsoDR03")
        else:
            self.m2HcalIsoDR03_branch.SetAddress(<void*>&self.m2HcalIsoDR03_value)

        #print "making m2IP3D"
        self.m2IP3D_branch = the_tree.GetBranch("m2IP3D")
        #if not self.m2IP3D_branch and "m2IP3D" not in self.complained:
        if not self.m2IP3D_branch and "m2IP3D":
            warnings.warn( "MuMuMuTree: Expected branch m2IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3D")
        else:
            self.m2IP3D_branch.SetAddress(<void*>&self.m2IP3D_value)

        #print "making m2IP3DErr"
        self.m2IP3DErr_branch = the_tree.GetBranch("m2IP3DErr")
        #if not self.m2IP3DErr_branch and "m2IP3DErr" not in self.complained:
        if not self.m2IP3DErr_branch and "m2IP3DErr":
            warnings.warn( "MuMuMuTree: Expected branch m2IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3DErr")
        else:
            self.m2IP3DErr_branch.SetAddress(<void*>&self.m2IP3DErr_value)

        #print "making m2IsGlobal"
        self.m2IsGlobal_branch = the_tree.GetBranch("m2IsGlobal")
        #if not self.m2IsGlobal_branch and "m2IsGlobal" not in self.complained:
        if not self.m2IsGlobal_branch and "m2IsGlobal":
            warnings.warn( "MuMuMuTree: Expected branch m2IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsGlobal")
        else:
            self.m2IsGlobal_branch.SetAddress(<void*>&self.m2IsGlobal_value)

        #print "making m2IsPFMuon"
        self.m2IsPFMuon_branch = the_tree.GetBranch("m2IsPFMuon")
        #if not self.m2IsPFMuon_branch and "m2IsPFMuon" not in self.complained:
        if not self.m2IsPFMuon_branch and "m2IsPFMuon":
            warnings.warn( "MuMuMuTree: Expected branch m2IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsPFMuon")
        else:
            self.m2IsPFMuon_branch.SetAddress(<void*>&self.m2IsPFMuon_value)

        #print "making m2IsTracker"
        self.m2IsTracker_branch = the_tree.GetBranch("m2IsTracker")
        #if not self.m2IsTracker_branch and "m2IsTracker" not in self.complained:
        if not self.m2IsTracker_branch and "m2IsTracker":
            warnings.warn( "MuMuMuTree: Expected branch m2IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsTracker")
        else:
            self.m2IsTracker_branch.SetAddress(<void*>&self.m2IsTracker_value)

        #print "making m2IsoDB03"
        self.m2IsoDB03_branch = the_tree.GetBranch("m2IsoDB03")
        #if not self.m2IsoDB03_branch and "m2IsoDB03" not in self.complained:
        if not self.m2IsoDB03_branch and "m2IsoDB03":
            warnings.warn( "MuMuMuTree: Expected branch m2IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoDB03")
        else:
            self.m2IsoDB03_branch.SetAddress(<void*>&self.m2IsoDB03_value)

        #print "making m2IsoDB04"
        self.m2IsoDB04_branch = the_tree.GetBranch("m2IsoDB04")
        #if not self.m2IsoDB04_branch and "m2IsoDB04" not in self.complained:
        if not self.m2IsoDB04_branch and "m2IsoDB04":
            warnings.warn( "MuMuMuTree: Expected branch m2IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoDB04")
        else:
            self.m2IsoDB04_branch.SetAddress(<void*>&self.m2IsoDB04_value)

        #print "making m2IsoMu22Filter"
        self.m2IsoMu22Filter_branch = the_tree.GetBranch("m2IsoMu22Filter")
        #if not self.m2IsoMu22Filter_branch and "m2IsoMu22Filter" not in self.complained:
        if not self.m2IsoMu22Filter_branch and "m2IsoMu22Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2IsoMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoMu22Filter")
        else:
            self.m2IsoMu22Filter_branch.SetAddress(<void*>&self.m2IsoMu22Filter_value)

        #print "making m2IsoMu22eta2p1Filter"
        self.m2IsoMu22eta2p1Filter_branch = the_tree.GetBranch("m2IsoMu22eta2p1Filter")
        #if not self.m2IsoMu22eta2p1Filter_branch and "m2IsoMu22eta2p1Filter" not in self.complained:
        if not self.m2IsoMu22eta2p1Filter_branch and "m2IsoMu22eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2IsoMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoMu22eta2p1Filter")
        else:
            self.m2IsoMu22eta2p1Filter_branch.SetAddress(<void*>&self.m2IsoMu22eta2p1Filter_value)

        #print "making m2IsoMu24Filter"
        self.m2IsoMu24Filter_branch = the_tree.GetBranch("m2IsoMu24Filter")
        #if not self.m2IsoMu24Filter_branch and "m2IsoMu24Filter" not in self.complained:
        if not self.m2IsoMu24Filter_branch and "m2IsoMu24Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2IsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoMu24Filter")
        else:
            self.m2IsoMu24Filter_branch.SetAddress(<void*>&self.m2IsoMu24Filter_value)

        #print "making m2IsoMu24eta2p1Filter"
        self.m2IsoMu24eta2p1Filter_branch = the_tree.GetBranch("m2IsoMu24eta2p1Filter")
        #if not self.m2IsoMu24eta2p1Filter_branch and "m2IsoMu24eta2p1Filter" not in self.complained:
        if not self.m2IsoMu24eta2p1Filter_branch and "m2IsoMu24eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2IsoMu24eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoMu24eta2p1Filter")
        else:
            self.m2IsoMu24eta2p1Filter_branch.SetAddress(<void*>&self.m2IsoMu24eta2p1Filter_value)

        #print "making m2IsoTkMu22Filter"
        self.m2IsoTkMu22Filter_branch = the_tree.GetBranch("m2IsoTkMu22Filter")
        #if not self.m2IsoTkMu22Filter_branch and "m2IsoTkMu22Filter" not in self.complained:
        if not self.m2IsoTkMu22Filter_branch and "m2IsoTkMu22Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2IsoTkMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoTkMu22Filter")
        else:
            self.m2IsoTkMu22Filter_branch.SetAddress(<void*>&self.m2IsoTkMu22Filter_value)

        #print "making m2IsoTkMu22eta2p1Filter"
        self.m2IsoTkMu22eta2p1Filter_branch = the_tree.GetBranch("m2IsoTkMu22eta2p1Filter")
        #if not self.m2IsoTkMu22eta2p1Filter_branch and "m2IsoTkMu22eta2p1Filter" not in self.complained:
        if not self.m2IsoTkMu22eta2p1Filter_branch and "m2IsoTkMu22eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2IsoTkMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoTkMu22eta2p1Filter")
        else:
            self.m2IsoTkMu22eta2p1Filter_branch.SetAddress(<void*>&self.m2IsoTkMu22eta2p1Filter_value)

        #print "making m2IsoTkMu24Filter"
        self.m2IsoTkMu24Filter_branch = the_tree.GetBranch("m2IsoTkMu24Filter")
        #if not self.m2IsoTkMu24Filter_branch and "m2IsoTkMu24Filter" not in self.complained:
        if not self.m2IsoTkMu24Filter_branch and "m2IsoTkMu24Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2IsoTkMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoTkMu24Filter")
        else:
            self.m2IsoTkMu24Filter_branch.SetAddress(<void*>&self.m2IsoTkMu24Filter_value)

        #print "making m2IsoTkMu24eta2p1Filter"
        self.m2IsoTkMu24eta2p1Filter_branch = the_tree.GetBranch("m2IsoTkMu24eta2p1Filter")
        #if not self.m2IsoTkMu24eta2p1Filter_branch and "m2IsoTkMu24eta2p1Filter" not in self.complained:
        if not self.m2IsoTkMu24eta2p1Filter_branch and "m2IsoTkMu24eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2IsoTkMu24eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoTkMu24eta2p1Filter")
        else:
            self.m2IsoTkMu24eta2p1Filter_branch.SetAddress(<void*>&self.m2IsoTkMu24eta2p1Filter_value)

        #print "making m2JetArea"
        self.m2JetArea_branch = the_tree.GetBranch("m2JetArea")
        #if not self.m2JetArea_branch and "m2JetArea" not in self.complained:
        if not self.m2JetArea_branch and "m2JetArea":
            warnings.warn( "MuMuMuTree: Expected branch m2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetArea")
        else:
            self.m2JetArea_branch.SetAddress(<void*>&self.m2JetArea_value)

        #print "making m2JetBtag"
        self.m2JetBtag_branch = the_tree.GetBranch("m2JetBtag")
        #if not self.m2JetBtag_branch and "m2JetBtag" not in self.complained:
        if not self.m2JetBtag_branch and "m2JetBtag":
            warnings.warn( "MuMuMuTree: Expected branch m2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetBtag")
        else:
            self.m2JetBtag_branch.SetAddress(<void*>&self.m2JetBtag_value)

        #print "making m2JetEtaEtaMoment"
        self.m2JetEtaEtaMoment_branch = the_tree.GetBranch("m2JetEtaEtaMoment")
        #if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment" not in self.complained:
        if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment":
            warnings.warn( "MuMuMuTree: Expected branch m2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaEtaMoment")
        else:
            self.m2JetEtaEtaMoment_branch.SetAddress(<void*>&self.m2JetEtaEtaMoment_value)

        #print "making m2JetEtaPhiMoment"
        self.m2JetEtaPhiMoment_branch = the_tree.GetBranch("m2JetEtaPhiMoment")
        #if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment" not in self.complained:
        if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment":
            warnings.warn( "MuMuMuTree: Expected branch m2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiMoment")
        else:
            self.m2JetEtaPhiMoment_branch.SetAddress(<void*>&self.m2JetEtaPhiMoment_value)

        #print "making m2JetEtaPhiSpread"
        self.m2JetEtaPhiSpread_branch = the_tree.GetBranch("m2JetEtaPhiSpread")
        #if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread" not in self.complained:
        if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread":
            warnings.warn( "MuMuMuTree: Expected branch m2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiSpread")
        else:
            self.m2JetEtaPhiSpread_branch.SetAddress(<void*>&self.m2JetEtaPhiSpread_value)

        #print "making m2JetHadronFlavour"
        self.m2JetHadronFlavour_branch = the_tree.GetBranch("m2JetHadronFlavour")
        #if not self.m2JetHadronFlavour_branch and "m2JetHadronFlavour" not in self.complained:
        if not self.m2JetHadronFlavour_branch and "m2JetHadronFlavour":
            warnings.warn( "MuMuMuTree: Expected branch m2JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetHadronFlavour")
        else:
            self.m2JetHadronFlavour_branch.SetAddress(<void*>&self.m2JetHadronFlavour_value)

        #print "making m2JetPFCISVBtag"
        self.m2JetPFCISVBtag_branch = the_tree.GetBranch("m2JetPFCISVBtag")
        #if not self.m2JetPFCISVBtag_branch and "m2JetPFCISVBtag" not in self.complained:
        if not self.m2JetPFCISVBtag_branch and "m2JetPFCISVBtag":
            warnings.warn( "MuMuMuTree: Expected branch m2JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPFCISVBtag")
        else:
            self.m2JetPFCISVBtag_branch.SetAddress(<void*>&self.m2JetPFCISVBtag_value)

        #print "making m2JetPartonFlavour"
        self.m2JetPartonFlavour_branch = the_tree.GetBranch("m2JetPartonFlavour")
        #if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour" not in self.complained:
        if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour":
            warnings.warn( "MuMuMuTree: Expected branch m2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPartonFlavour")
        else:
            self.m2JetPartonFlavour_branch.SetAddress(<void*>&self.m2JetPartonFlavour_value)

        #print "making m2JetPhiPhiMoment"
        self.m2JetPhiPhiMoment_branch = the_tree.GetBranch("m2JetPhiPhiMoment")
        #if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment" not in self.complained:
        if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment":
            warnings.warn( "MuMuMuTree: Expected branch m2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPhiPhiMoment")
        else:
            self.m2JetPhiPhiMoment_branch.SetAddress(<void*>&self.m2JetPhiPhiMoment_value)

        #print "making m2JetPt"
        self.m2JetPt_branch = the_tree.GetBranch("m2JetPt")
        #if not self.m2JetPt_branch and "m2JetPt" not in self.complained:
        if not self.m2JetPt_branch and "m2JetPt":
            warnings.warn( "MuMuMuTree: Expected branch m2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPt")
        else:
            self.m2JetPt_branch.SetAddress(<void*>&self.m2JetPt_value)

        #print "making m2LowestMll"
        self.m2LowestMll_branch = the_tree.GetBranch("m2LowestMll")
        #if not self.m2LowestMll_branch and "m2LowestMll" not in self.complained:
        if not self.m2LowestMll_branch and "m2LowestMll":
            warnings.warn( "MuMuMuTree: Expected branch m2LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2LowestMll")
        else:
            self.m2LowestMll_branch.SetAddress(<void*>&self.m2LowestMll_value)

        #print "making m2Mass"
        self.m2Mass_branch = the_tree.GetBranch("m2Mass")
        #if not self.m2Mass_branch and "m2Mass" not in self.complained:
        if not self.m2Mass_branch and "m2Mass":
            warnings.warn( "MuMuMuTree: Expected branch m2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mass")
        else:
            self.m2Mass_branch.SetAddress(<void*>&self.m2Mass_value)

        #print "making m2MatchedStations"
        self.m2MatchedStations_branch = the_tree.GetBranch("m2MatchedStations")
        #if not self.m2MatchedStations_branch and "m2MatchedStations" not in self.complained:
        if not self.m2MatchedStations_branch and "m2MatchedStations":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchedStations")
        else:
            self.m2MatchedStations_branch.SetAddress(<void*>&self.m2MatchedStations_value)

        #print "making m2MatchesDoubleESingleMu"
        self.m2MatchesDoubleESingleMu_branch = the_tree.GetBranch("m2MatchesDoubleESingleMu")
        #if not self.m2MatchesDoubleESingleMu_branch and "m2MatchesDoubleESingleMu" not in self.complained:
        if not self.m2MatchesDoubleESingleMu_branch and "m2MatchesDoubleESingleMu":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesDoubleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleESingleMu")
        else:
            self.m2MatchesDoubleESingleMu_branch.SetAddress(<void*>&self.m2MatchesDoubleESingleMu_value)

        #print "making m2MatchesDoubleMu"
        self.m2MatchesDoubleMu_branch = the_tree.GetBranch("m2MatchesDoubleMu")
        #if not self.m2MatchesDoubleMu_branch and "m2MatchesDoubleMu" not in self.complained:
        if not self.m2MatchesDoubleMu_branch and "m2MatchesDoubleMu":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesDoubleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMu")
        else:
            self.m2MatchesDoubleMu_branch.SetAddress(<void*>&self.m2MatchesDoubleMu_value)

        #print "making m2MatchesDoubleMuSingleE"
        self.m2MatchesDoubleMuSingleE_branch = the_tree.GetBranch("m2MatchesDoubleMuSingleE")
        #if not self.m2MatchesDoubleMuSingleE_branch and "m2MatchesDoubleMuSingleE" not in self.complained:
        if not self.m2MatchesDoubleMuSingleE_branch and "m2MatchesDoubleMuSingleE":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesDoubleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMuSingleE")
        else:
            self.m2MatchesDoubleMuSingleE_branch.SetAddress(<void*>&self.m2MatchesDoubleMuSingleE_value)

        #print "making m2MatchesIsoMu22Path"
        self.m2MatchesIsoMu22Path_branch = the_tree.GetBranch("m2MatchesIsoMu22Path")
        #if not self.m2MatchesIsoMu22Path_branch and "m2MatchesIsoMu22Path" not in self.complained:
        if not self.m2MatchesIsoMu22Path_branch and "m2MatchesIsoMu22Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu22Path")
        else:
            self.m2MatchesIsoMu22Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu22Path_value)

        #print "making m2MatchesIsoMu22eta2p1Path"
        self.m2MatchesIsoMu22eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoMu22eta2p1Path")
        #if not self.m2MatchesIsoMu22eta2p1Path_branch and "m2MatchesIsoMu22eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoMu22eta2p1Path_branch and "m2MatchesIsoMu22eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu22eta2p1Path")
        else:
            self.m2MatchesIsoMu22eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu22eta2p1Path_value)

        #print "making m2MatchesIsoMu24Path"
        self.m2MatchesIsoMu24Path_branch = the_tree.GetBranch("m2MatchesIsoMu24Path")
        #if not self.m2MatchesIsoMu24Path_branch and "m2MatchesIsoMu24Path" not in self.complained:
        if not self.m2MatchesIsoMu24Path_branch and "m2MatchesIsoMu24Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24Path")
        else:
            self.m2MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu24Path_value)

        #print "making m2MatchesIsoMu24eta2p1Path"
        self.m2MatchesIsoMu24eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoMu24eta2p1Path")
        #if not self.m2MatchesIsoMu24eta2p1Path_branch and "m2MatchesIsoMu24eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoMu24eta2p1Path_branch and "m2MatchesIsoMu24eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24eta2p1Path")
        else:
            self.m2MatchesIsoMu24eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu24eta2p1Path_value)

        #print "making m2MatchesIsoTkMu22Path"
        self.m2MatchesIsoTkMu22Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu22Path")
        #if not self.m2MatchesIsoTkMu22Path_branch and "m2MatchesIsoTkMu22Path" not in self.complained:
        if not self.m2MatchesIsoTkMu22Path_branch and "m2MatchesIsoTkMu22Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoTkMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu22Path")
        else:
            self.m2MatchesIsoTkMu22Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu22Path_value)

        #print "making m2MatchesIsoTkMu22eta2p1Path"
        self.m2MatchesIsoTkMu22eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu22eta2p1Path")
        #if not self.m2MatchesIsoTkMu22eta2p1Path_branch and "m2MatchesIsoTkMu22eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoTkMu22eta2p1Path_branch and "m2MatchesIsoTkMu22eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoTkMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu22eta2p1Path")
        else:
            self.m2MatchesIsoTkMu22eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu22eta2p1Path_value)

        #print "making m2MatchesIsoTkMu24Path"
        self.m2MatchesIsoTkMu24Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu24Path")
        #if not self.m2MatchesIsoTkMu24Path_branch and "m2MatchesIsoTkMu24Path" not in self.complained:
        if not self.m2MatchesIsoTkMu24Path_branch and "m2MatchesIsoTkMu24Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoTkMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu24Path")
        else:
            self.m2MatchesIsoTkMu24Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu24Path_value)

        #print "making m2MatchesIsoTkMu24eta2p1Path"
        self.m2MatchesIsoTkMu24eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu24eta2p1Path")
        #if not self.m2MatchesIsoTkMu24eta2p1Path_branch and "m2MatchesIsoTkMu24eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoTkMu24eta2p1Path_branch and "m2MatchesIsoTkMu24eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoTkMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu24eta2p1Path")
        else:
            self.m2MatchesIsoTkMu24eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu24eta2p1Path_value)

        #print "making m2MatchesMu19Tau20Filter"
        self.m2MatchesMu19Tau20Filter_branch = the_tree.GetBranch("m2MatchesMu19Tau20Filter")
        #if not self.m2MatchesMu19Tau20Filter_branch and "m2MatchesMu19Tau20Filter" not in self.complained:
        if not self.m2MatchesMu19Tau20Filter_branch and "m2MatchesMu19Tau20Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu19Tau20Filter")
        else:
            self.m2MatchesMu19Tau20Filter_branch.SetAddress(<void*>&self.m2MatchesMu19Tau20Filter_value)

        #print "making m2MatchesMu19Tau20Path"
        self.m2MatchesMu19Tau20Path_branch = the_tree.GetBranch("m2MatchesMu19Tau20Path")
        #if not self.m2MatchesMu19Tau20Path_branch and "m2MatchesMu19Tau20Path" not in self.complained:
        if not self.m2MatchesMu19Tau20Path_branch and "m2MatchesMu19Tau20Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu19Tau20Path")
        else:
            self.m2MatchesMu19Tau20Path_branch.SetAddress(<void*>&self.m2MatchesMu19Tau20Path_value)

        #print "making m2MatchesMu19Tau20sL1Filter"
        self.m2MatchesMu19Tau20sL1Filter_branch = the_tree.GetBranch("m2MatchesMu19Tau20sL1Filter")
        #if not self.m2MatchesMu19Tau20sL1Filter_branch and "m2MatchesMu19Tau20sL1Filter" not in self.complained:
        if not self.m2MatchesMu19Tau20sL1Filter_branch and "m2MatchesMu19Tau20sL1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesMu19Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu19Tau20sL1Filter")
        else:
            self.m2MatchesMu19Tau20sL1Filter_branch.SetAddress(<void*>&self.m2MatchesMu19Tau20sL1Filter_value)

        #print "making m2MatchesMu19Tau20sL1Path"
        self.m2MatchesMu19Tau20sL1Path_branch = the_tree.GetBranch("m2MatchesMu19Tau20sL1Path")
        #if not self.m2MatchesMu19Tau20sL1Path_branch and "m2MatchesMu19Tau20sL1Path" not in self.complained:
        if not self.m2MatchesMu19Tau20sL1Path_branch and "m2MatchesMu19Tau20sL1Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesMu19Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu19Tau20sL1Path")
        else:
            self.m2MatchesMu19Tau20sL1Path_branch.SetAddress(<void*>&self.m2MatchesMu19Tau20sL1Path_value)

        #print "making m2MatchesMu23Ele12Path"
        self.m2MatchesMu23Ele12Path_branch = the_tree.GetBranch("m2MatchesMu23Ele12Path")
        #if not self.m2MatchesMu23Ele12Path_branch and "m2MatchesMu23Ele12Path" not in self.complained:
        if not self.m2MatchesMu23Ele12Path_branch and "m2MatchesMu23Ele12Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesMu23Ele12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu23Ele12Path")
        else:
            self.m2MatchesMu23Ele12Path_branch.SetAddress(<void*>&self.m2MatchesMu23Ele12Path_value)

        #print "making m2MatchesMu8Ele23Path"
        self.m2MatchesMu8Ele23Path_branch = the_tree.GetBranch("m2MatchesMu8Ele23Path")
        #if not self.m2MatchesMu8Ele23Path_branch and "m2MatchesMu8Ele23Path" not in self.complained:
        if not self.m2MatchesMu8Ele23Path_branch and "m2MatchesMu8Ele23Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesMu8Ele23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele23Path")
        else:
            self.m2MatchesMu8Ele23Path_branch.SetAddress(<void*>&self.m2MatchesMu8Ele23Path_value)

        #print "making m2MatchesSingleESingleMu"
        self.m2MatchesSingleESingleMu_branch = the_tree.GetBranch("m2MatchesSingleESingleMu")
        #if not self.m2MatchesSingleESingleMu_branch and "m2MatchesSingleESingleMu" not in self.complained:
        if not self.m2MatchesSingleESingleMu_branch and "m2MatchesSingleESingleMu":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesSingleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleESingleMu")
        else:
            self.m2MatchesSingleESingleMu_branch.SetAddress(<void*>&self.m2MatchesSingleESingleMu_value)

        #print "making m2MatchesSingleMu"
        self.m2MatchesSingleMu_branch = the_tree.GetBranch("m2MatchesSingleMu")
        #if not self.m2MatchesSingleMu_branch and "m2MatchesSingleMu" not in self.complained:
        if not self.m2MatchesSingleMu_branch and "m2MatchesSingleMu":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesSingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu")
        else:
            self.m2MatchesSingleMu_branch.SetAddress(<void*>&self.m2MatchesSingleMu_value)

        #print "making m2MatchesSingleMuIso20"
        self.m2MatchesSingleMuIso20_branch = the_tree.GetBranch("m2MatchesSingleMuIso20")
        #if not self.m2MatchesSingleMuIso20_branch and "m2MatchesSingleMuIso20" not in self.complained:
        if not self.m2MatchesSingleMuIso20_branch and "m2MatchesSingleMuIso20":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesSingleMuIso20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMuIso20")
        else:
            self.m2MatchesSingleMuIso20_branch.SetAddress(<void*>&self.m2MatchesSingleMuIso20_value)

        #print "making m2MatchesSingleMuIsoTk20"
        self.m2MatchesSingleMuIsoTk20_branch = the_tree.GetBranch("m2MatchesSingleMuIsoTk20")
        #if not self.m2MatchesSingleMuIsoTk20_branch and "m2MatchesSingleMuIsoTk20" not in self.complained:
        if not self.m2MatchesSingleMuIsoTk20_branch and "m2MatchesSingleMuIsoTk20":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesSingleMuIsoTk20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMuIsoTk20")
        else:
            self.m2MatchesSingleMuIsoTk20_branch.SetAddress(<void*>&self.m2MatchesSingleMuIsoTk20_value)

        #print "making m2MatchesSingleMuSingleE"
        self.m2MatchesSingleMuSingleE_branch = the_tree.GetBranch("m2MatchesSingleMuSingleE")
        #if not self.m2MatchesSingleMuSingleE_branch and "m2MatchesSingleMuSingleE" not in self.complained:
        if not self.m2MatchesSingleMuSingleE_branch and "m2MatchesSingleMuSingleE":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesSingleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMuSingleE")
        else:
            self.m2MatchesSingleMuSingleE_branch.SetAddress(<void*>&self.m2MatchesSingleMuSingleE_value)

        #print "making m2MatchesSingleMu_leg1"
        self.m2MatchesSingleMu_leg1_branch = the_tree.GetBranch("m2MatchesSingleMu_leg1")
        #if not self.m2MatchesSingleMu_leg1_branch and "m2MatchesSingleMu_leg1" not in self.complained:
        if not self.m2MatchesSingleMu_leg1_branch and "m2MatchesSingleMu_leg1":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesSingleMu_leg1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu_leg1")
        else:
            self.m2MatchesSingleMu_leg1_branch.SetAddress(<void*>&self.m2MatchesSingleMu_leg1_value)

        #print "making m2MatchesSingleMu_leg1_noiso"
        self.m2MatchesSingleMu_leg1_noiso_branch = the_tree.GetBranch("m2MatchesSingleMu_leg1_noiso")
        #if not self.m2MatchesSingleMu_leg1_noiso_branch and "m2MatchesSingleMu_leg1_noiso" not in self.complained:
        if not self.m2MatchesSingleMu_leg1_noiso_branch and "m2MatchesSingleMu_leg1_noiso":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesSingleMu_leg1_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu_leg1_noiso")
        else:
            self.m2MatchesSingleMu_leg1_noiso_branch.SetAddress(<void*>&self.m2MatchesSingleMu_leg1_noiso_value)

        #print "making m2MatchesSingleMu_leg2"
        self.m2MatchesSingleMu_leg2_branch = the_tree.GetBranch("m2MatchesSingleMu_leg2")
        #if not self.m2MatchesSingleMu_leg2_branch and "m2MatchesSingleMu_leg2" not in self.complained:
        if not self.m2MatchesSingleMu_leg2_branch and "m2MatchesSingleMu_leg2":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesSingleMu_leg2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu_leg2")
        else:
            self.m2MatchesSingleMu_leg2_branch.SetAddress(<void*>&self.m2MatchesSingleMu_leg2_value)

        #print "making m2MatchesSingleMu_leg2_noiso"
        self.m2MatchesSingleMu_leg2_noiso_branch = the_tree.GetBranch("m2MatchesSingleMu_leg2_noiso")
        #if not self.m2MatchesSingleMu_leg2_noiso_branch and "m2MatchesSingleMu_leg2_noiso" not in self.complained:
        if not self.m2MatchesSingleMu_leg2_noiso_branch and "m2MatchesSingleMu_leg2_noiso":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesSingleMu_leg2_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu_leg2_noiso")
        else:
            self.m2MatchesSingleMu_leg2_noiso_branch.SetAddress(<void*>&self.m2MatchesSingleMu_leg2_noiso_value)

        #print "making m2MatchesTripleMu"
        self.m2MatchesTripleMu_branch = the_tree.GetBranch("m2MatchesTripleMu")
        #if not self.m2MatchesTripleMu_branch and "m2MatchesTripleMu" not in self.complained:
        if not self.m2MatchesTripleMu_branch and "m2MatchesTripleMu":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesTripleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesTripleMu")
        else:
            self.m2MatchesTripleMu_branch.SetAddress(<void*>&self.m2MatchesTripleMu_value)

        #print "making m2MtToPfMet_ElectronEnDown"
        self.m2MtToPfMet_ElectronEnDown_branch = the_tree.GetBranch("m2MtToPfMet_ElectronEnDown")
        #if not self.m2MtToPfMet_ElectronEnDown_branch and "m2MtToPfMet_ElectronEnDown" not in self.complained:
        if not self.m2MtToPfMet_ElectronEnDown_branch and "m2MtToPfMet_ElectronEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_ElectronEnDown")
        else:
            self.m2MtToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.m2MtToPfMet_ElectronEnDown_value)

        #print "making m2MtToPfMet_ElectronEnUp"
        self.m2MtToPfMet_ElectronEnUp_branch = the_tree.GetBranch("m2MtToPfMet_ElectronEnUp")
        #if not self.m2MtToPfMet_ElectronEnUp_branch and "m2MtToPfMet_ElectronEnUp" not in self.complained:
        if not self.m2MtToPfMet_ElectronEnUp_branch and "m2MtToPfMet_ElectronEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_ElectronEnUp")
        else:
            self.m2MtToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.m2MtToPfMet_ElectronEnUp_value)

        #print "making m2MtToPfMet_JetEnDown"
        self.m2MtToPfMet_JetEnDown_branch = the_tree.GetBranch("m2MtToPfMet_JetEnDown")
        #if not self.m2MtToPfMet_JetEnDown_branch and "m2MtToPfMet_JetEnDown" not in self.complained:
        if not self.m2MtToPfMet_JetEnDown_branch and "m2MtToPfMet_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_JetEnDown")
        else:
            self.m2MtToPfMet_JetEnDown_branch.SetAddress(<void*>&self.m2MtToPfMet_JetEnDown_value)

        #print "making m2MtToPfMet_JetEnUp"
        self.m2MtToPfMet_JetEnUp_branch = the_tree.GetBranch("m2MtToPfMet_JetEnUp")
        #if not self.m2MtToPfMet_JetEnUp_branch and "m2MtToPfMet_JetEnUp" not in self.complained:
        if not self.m2MtToPfMet_JetEnUp_branch and "m2MtToPfMet_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_JetEnUp")
        else:
            self.m2MtToPfMet_JetEnUp_branch.SetAddress(<void*>&self.m2MtToPfMet_JetEnUp_value)

        #print "making m2MtToPfMet_JetResDown"
        self.m2MtToPfMet_JetResDown_branch = the_tree.GetBranch("m2MtToPfMet_JetResDown")
        #if not self.m2MtToPfMet_JetResDown_branch and "m2MtToPfMet_JetResDown" not in self.complained:
        if not self.m2MtToPfMet_JetResDown_branch and "m2MtToPfMet_JetResDown":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_JetResDown")
        else:
            self.m2MtToPfMet_JetResDown_branch.SetAddress(<void*>&self.m2MtToPfMet_JetResDown_value)

        #print "making m2MtToPfMet_JetResUp"
        self.m2MtToPfMet_JetResUp_branch = the_tree.GetBranch("m2MtToPfMet_JetResUp")
        #if not self.m2MtToPfMet_JetResUp_branch and "m2MtToPfMet_JetResUp" not in self.complained:
        if not self.m2MtToPfMet_JetResUp_branch and "m2MtToPfMet_JetResUp":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_JetResUp")
        else:
            self.m2MtToPfMet_JetResUp_branch.SetAddress(<void*>&self.m2MtToPfMet_JetResUp_value)

        #print "making m2MtToPfMet_MuonEnDown"
        self.m2MtToPfMet_MuonEnDown_branch = the_tree.GetBranch("m2MtToPfMet_MuonEnDown")
        #if not self.m2MtToPfMet_MuonEnDown_branch and "m2MtToPfMet_MuonEnDown" not in self.complained:
        if not self.m2MtToPfMet_MuonEnDown_branch and "m2MtToPfMet_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_MuonEnDown")
        else:
            self.m2MtToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.m2MtToPfMet_MuonEnDown_value)

        #print "making m2MtToPfMet_MuonEnUp"
        self.m2MtToPfMet_MuonEnUp_branch = the_tree.GetBranch("m2MtToPfMet_MuonEnUp")
        #if not self.m2MtToPfMet_MuonEnUp_branch and "m2MtToPfMet_MuonEnUp" not in self.complained:
        if not self.m2MtToPfMet_MuonEnUp_branch and "m2MtToPfMet_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_MuonEnUp")
        else:
            self.m2MtToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.m2MtToPfMet_MuonEnUp_value)

        #print "making m2MtToPfMet_PhotonEnDown"
        self.m2MtToPfMet_PhotonEnDown_branch = the_tree.GetBranch("m2MtToPfMet_PhotonEnDown")
        #if not self.m2MtToPfMet_PhotonEnDown_branch and "m2MtToPfMet_PhotonEnDown" not in self.complained:
        if not self.m2MtToPfMet_PhotonEnDown_branch and "m2MtToPfMet_PhotonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_PhotonEnDown")
        else:
            self.m2MtToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.m2MtToPfMet_PhotonEnDown_value)

        #print "making m2MtToPfMet_PhotonEnUp"
        self.m2MtToPfMet_PhotonEnUp_branch = the_tree.GetBranch("m2MtToPfMet_PhotonEnUp")
        #if not self.m2MtToPfMet_PhotonEnUp_branch and "m2MtToPfMet_PhotonEnUp" not in self.complained:
        if not self.m2MtToPfMet_PhotonEnUp_branch and "m2MtToPfMet_PhotonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_PhotonEnUp")
        else:
            self.m2MtToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.m2MtToPfMet_PhotonEnUp_value)

        #print "making m2MtToPfMet_Raw"
        self.m2MtToPfMet_Raw_branch = the_tree.GetBranch("m2MtToPfMet_Raw")
        #if not self.m2MtToPfMet_Raw_branch and "m2MtToPfMet_Raw" not in self.complained:
        if not self.m2MtToPfMet_Raw_branch and "m2MtToPfMet_Raw":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_Raw")
        else:
            self.m2MtToPfMet_Raw_branch.SetAddress(<void*>&self.m2MtToPfMet_Raw_value)

        #print "making m2MtToPfMet_TauEnDown"
        self.m2MtToPfMet_TauEnDown_branch = the_tree.GetBranch("m2MtToPfMet_TauEnDown")
        #if not self.m2MtToPfMet_TauEnDown_branch and "m2MtToPfMet_TauEnDown" not in self.complained:
        if not self.m2MtToPfMet_TauEnDown_branch and "m2MtToPfMet_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_TauEnDown")
        else:
            self.m2MtToPfMet_TauEnDown_branch.SetAddress(<void*>&self.m2MtToPfMet_TauEnDown_value)

        #print "making m2MtToPfMet_TauEnUp"
        self.m2MtToPfMet_TauEnUp_branch = the_tree.GetBranch("m2MtToPfMet_TauEnUp")
        #if not self.m2MtToPfMet_TauEnUp_branch and "m2MtToPfMet_TauEnUp" not in self.complained:
        if not self.m2MtToPfMet_TauEnUp_branch and "m2MtToPfMet_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_TauEnUp")
        else:
            self.m2MtToPfMet_TauEnUp_branch.SetAddress(<void*>&self.m2MtToPfMet_TauEnUp_value)

        #print "making m2MtToPfMet_UnclusteredEnDown"
        self.m2MtToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("m2MtToPfMet_UnclusteredEnDown")
        #if not self.m2MtToPfMet_UnclusteredEnDown_branch and "m2MtToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.m2MtToPfMet_UnclusteredEnDown_branch and "m2MtToPfMet_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_UnclusteredEnDown")
        else:
            self.m2MtToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.m2MtToPfMet_UnclusteredEnDown_value)

        #print "making m2MtToPfMet_UnclusteredEnUp"
        self.m2MtToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("m2MtToPfMet_UnclusteredEnUp")
        #if not self.m2MtToPfMet_UnclusteredEnUp_branch and "m2MtToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.m2MtToPfMet_UnclusteredEnUp_branch and "m2MtToPfMet_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_UnclusteredEnUp")
        else:
            self.m2MtToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.m2MtToPfMet_UnclusteredEnUp_value)

        #print "making m2MtToPfMet_type1"
        self.m2MtToPfMet_type1_branch = the_tree.GetBranch("m2MtToPfMet_type1")
        #if not self.m2MtToPfMet_type1_branch and "m2MtToPfMet_type1" not in self.complained:
        if not self.m2MtToPfMet_type1_branch and "m2MtToPfMet_type1":
            warnings.warn( "MuMuMuTree: Expected branch m2MtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_type1")
        else:
            self.m2MtToPfMet_type1_branch.SetAddress(<void*>&self.m2MtToPfMet_type1_value)

        #print "making m2Mu23Ele12Filter"
        self.m2Mu23Ele12Filter_branch = the_tree.GetBranch("m2Mu23Ele12Filter")
        #if not self.m2Mu23Ele12Filter_branch and "m2Mu23Ele12Filter" not in self.complained:
        if not self.m2Mu23Ele12Filter_branch and "m2Mu23Ele12Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2Mu23Ele12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu23Ele12Filter")
        else:
            self.m2Mu23Ele12Filter_branch.SetAddress(<void*>&self.m2Mu23Ele12Filter_value)

        #print "making m2Mu8Ele23Filter"
        self.m2Mu8Ele23Filter_branch = the_tree.GetBranch("m2Mu8Ele23Filter")
        #if not self.m2Mu8Ele23Filter_branch and "m2Mu8Ele23Filter" not in self.complained:
        if not self.m2Mu8Ele23Filter_branch and "m2Mu8Ele23Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2Mu8Ele23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu8Ele23Filter")
        else:
            self.m2Mu8Ele23Filter_branch.SetAddress(<void*>&self.m2Mu8Ele23Filter_value)

        #print "making m2MuonHits"
        self.m2MuonHits_branch = the_tree.GetBranch("m2MuonHits")
        #if not self.m2MuonHits_branch and "m2MuonHits" not in self.complained:
        if not self.m2MuonHits_branch and "m2MuonHits":
            warnings.warn( "MuMuMuTree: Expected branch m2MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MuonHits")
        else:
            self.m2MuonHits_branch.SetAddress(<void*>&self.m2MuonHits_value)

        #print "making m2NearestZMass"
        self.m2NearestZMass_branch = the_tree.GetBranch("m2NearestZMass")
        #if not self.m2NearestZMass_branch and "m2NearestZMass" not in self.complained:
        if not self.m2NearestZMass_branch and "m2NearestZMass":
            warnings.warn( "MuMuMuTree: Expected branch m2NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NearestZMass")
        else:
            self.m2NearestZMass_branch.SetAddress(<void*>&self.m2NearestZMass_value)

        #print "making m2NormTrkChi2"
        self.m2NormTrkChi2_branch = the_tree.GetBranch("m2NormTrkChi2")
        #if not self.m2NormTrkChi2_branch and "m2NormTrkChi2" not in self.complained:
        if not self.m2NormTrkChi2_branch and "m2NormTrkChi2":
            warnings.warn( "MuMuMuTree: Expected branch m2NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormTrkChi2")
        else:
            self.m2NormTrkChi2_branch.SetAddress(<void*>&self.m2NormTrkChi2_value)

        #print "making m2NormalizedChi2"
        self.m2NormalizedChi2_branch = the_tree.GetBranch("m2NormalizedChi2")
        #if not self.m2NormalizedChi2_branch and "m2NormalizedChi2" not in self.complained:
        if not self.m2NormalizedChi2_branch and "m2NormalizedChi2":
            warnings.warn( "MuMuMuTree: Expected branch m2NormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormalizedChi2")
        else:
            self.m2NormalizedChi2_branch.SetAddress(<void*>&self.m2NormalizedChi2_value)

        #print "making m2PFChargedHadronIsoR04"
        self.m2PFChargedHadronIsoR04_branch = the_tree.GetBranch("m2PFChargedHadronIsoR04")
        #if not self.m2PFChargedHadronIsoR04_branch and "m2PFChargedHadronIsoR04" not in self.complained:
        if not self.m2PFChargedHadronIsoR04_branch and "m2PFChargedHadronIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m2PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedHadronIsoR04")
        else:
            self.m2PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m2PFChargedHadronIsoR04_value)

        #print "making m2PFChargedIso"
        self.m2PFChargedIso_branch = the_tree.GetBranch("m2PFChargedIso")
        #if not self.m2PFChargedIso_branch and "m2PFChargedIso" not in self.complained:
        if not self.m2PFChargedIso_branch and "m2PFChargedIso":
            warnings.warn( "MuMuMuTree: Expected branch m2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedIso")
        else:
            self.m2PFChargedIso_branch.SetAddress(<void*>&self.m2PFChargedIso_value)

        #print "making m2PFIDLoose"
        self.m2PFIDLoose_branch = the_tree.GetBranch("m2PFIDLoose")
        #if not self.m2PFIDLoose_branch and "m2PFIDLoose" not in self.complained:
        if not self.m2PFIDLoose_branch and "m2PFIDLoose":
            warnings.warn( "MuMuMuTree: Expected branch m2PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDLoose")
        else:
            self.m2PFIDLoose_branch.SetAddress(<void*>&self.m2PFIDLoose_value)

        #print "making m2PFIDMedium"
        self.m2PFIDMedium_branch = the_tree.GetBranch("m2PFIDMedium")
        #if not self.m2PFIDMedium_branch and "m2PFIDMedium" not in self.complained:
        if not self.m2PFIDMedium_branch and "m2PFIDMedium":
            warnings.warn( "MuMuMuTree: Expected branch m2PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDMedium")
        else:
            self.m2PFIDMedium_branch.SetAddress(<void*>&self.m2PFIDMedium_value)

        #print "making m2PFIDTight"
        self.m2PFIDTight_branch = the_tree.GetBranch("m2PFIDTight")
        #if not self.m2PFIDTight_branch and "m2PFIDTight" not in self.complained:
        if not self.m2PFIDTight_branch and "m2PFIDTight":
            warnings.warn( "MuMuMuTree: Expected branch m2PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDTight")
        else:
            self.m2PFIDTight_branch.SetAddress(<void*>&self.m2PFIDTight_value)

        #print "making m2PFNeutralHadronIsoR04"
        self.m2PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m2PFNeutralHadronIsoR04")
        #if not self.m2PFNeutralHadronIsoR04_branch and "m2PFNeutralHadronIsoR04" not in self.complained:
        if not self.m2PFNeutralHadronIsoR04_branch and "m2PFNeutralHadronIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m2PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralHadronIsoR04")
        else:
            self.m2PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m2PFNeutralHadronIsoR04_value)

        #print "making m2PFNeutralIso"
        self.m2PFNeutralIso_branch = the_tree.GetBranch("m2PFNeutralIso")
        #if not self.m2PFNeutralIso_branch and "m2PFNeutralIso" not in self.complained:
        if not self.m2PFNeutralIso_branch and "m2PFNeutralIso":
            warnings.warn( "MuMuMuTree: Expected branch m2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralIso")
        else:
            self.m2PFNeutralIso_branch.SetAddress(<void*>&self.m2PFNeutralIso_value)

        #print "making m2PFPUChargedIso"
        self.m2PFPUChargedIso_branch = the_tree.GetBranch("m2PFPUChargedIso")
        #if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso" not in self.complained:
        if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso":
            warnings.warn( "MuMuMuTree: Expected branch m2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPUChargedIso")
        else:
            self.m2PFPUChargedIso_branch.SetAddress(<void*>&self.m2PFPUChargedIso_value)

        #print "making m2PFPhotonIso"
        self.m2PFPhotonIso_branch = the_tree.GetBranch("m2PFPhotonIso")
        #if not self.m2PFPhotonIso_branch and "m2PFPhotonIso" not in self.complained:
        if not self.m2PFPhotonIso_branch and "m2PFPhotonIso":
            warnings.warn( "MuMuMuTree: Expected branch m2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIso")
        else:
            self.m2PFPhotonIso_branch.SetAddress(<void*>&self.m2PFPhotonIso_value)

        #print "making m2PFPhotonIsoR04"
        self.m2PFPhotonIsoR04_branch = the_tree.GetBranch("m2PFPhotonIsoR04")
        #if not self.m2PFPhotonIsoR04_branch and "m2PFPhotonIsoR04" not in self.complained:
        if not self.m2PFPhotonIsoR04_branch and "m2PFPhotonIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m2PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIsoR04")
        else:
            self.m2PFPhotonIsoR04_branch.SetAddress(<void*>&self.m2PFPhotonIsoR04_value)

        #print "making m2PFPileupIsoR04"
        self.m2PFPileupIsoR04_branch = the_tree.GetBranch("m2PFPileupIsoR04")
        #if not self.m2PFPileupIsoR04_branch and "m2PFPileupIsoR04" not in self.complained:
        if not self.m2PFPileupIsoR04_branch and "m2PFPileupIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m2PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPileupIsoR04")
        else:
            self.m2PFPileupIsoR04_branch.SetAddress(<void*>&self.m2PFPileupIsoR04_value)

        #print "making m2PVDXY"
        self.m2PVDXY_branch = the_tree.GetBranch("m2PVDXY")
        #if not self.m2PVDXY_branch and "m2PVDXY" not in self.complained:
        if not self.m2PVDXY_branch and "m2PVDXY":
            warnings.warn( "MuMuMuTree: Expected branch m2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDXY")
        else:
            self.m2PVDXY_branch.SetAddress(<void*>&self.m2PVDXY_value)

        #print "making m2PVDZ"
        self.m2PVDZ_branch = the_tree.GetBranch("m2PVDZ")
        #if not self.m2PVDZ_branch and "m2PVDZ" not in self.complained:
        if not self.m2PVDZ_branch and "m2PVDZ":
            warnings.warn( "MuMuMuTree: Expected branch m2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDZ")
        else:
            self.m2PVDZ_branch.SetAddress(<void*>&self.m2PVDZ_value)

        #print "making m2Phi"
        self.m2Phi_branch = the_tree.GetBranch("m2Phi")
        #if not self.m2Phi_branch and "m2Phi" not in self.complained:
        if not self.m2Phi_branch and "m2Phi":
            warnings.warn( "MuMuMuTree: Expected branch m2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi")
        else:
            self.m2Phi_branch.SetAddress(<void*>&self.m2Phi_value)

        #print "making m2Phi_MuonEnDown"
        self.m2Phi_MuonEnDown_branch = the_tree.GetBranch("m2Phi_MuonEnDown")
        #if not self.m2Phi_MuonEnDown_branch and "m2Phi_MuonEnDown" not in self.complained:
        if not self.m2Phi_MuonEnDown_branch and "m2Phi_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2Phi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi_MuonEnDown")
        else:
            self.m2Phi_MuonEnDown_branch.SetAddress(<void*>&self.m2Phi_MuonEnDown_value)

        #print "making m2Phi_MuonEnUp"
        self.m2Phi_MuonEnUp_branch = the_tree.GetBranch("m2Phi_MuonEnUp")
        #if not self.m2Phi_MuonEnUp_branch and "m2Phi_MuonEnUp" not in self.complained:
        if not self.m2Phi_MuonEnUp_branch and "m2Phi_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2Phi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi_MuonEnUp")
        else:
            self.m2Phi_MuonEnUp_branch.SetAddress(<void*>&self.m2Phi_MuonEnUp_value)

        #print "making m2PixHits"
        self.m2PixHits_branch = the_tree.GetBranch("m2PixHits")
        #if not self.m2PixHits_branch and "m2PixHits" not in self.complained:
        if not self.m2PixHits_branch and "m2PixHits":
            warnings.warn( "MuMuMuTree: Expected branch m2PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PixHits")
        else:
            self.m2PixHits_branch.SetAddress(<void*>&self.m2PixHits_value)

        #print "making m2Pt"
        self.m2Pt_branch = the_tree.GetBranch("m2Pt")
        #if not self.m2Pt_branch and "m2Pt" not in self.complained:
        if not self.m2Pt_branch and "m2Pt":
            warnings.warn( "MuMuMuTree: Expected branch m2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt")
        else:
            self.m2Pt_branch.SetAddress(<void*>&self.m2Pt_value)

        #print "making m2Pt_MuonEnDown"
        self.m2Pt_MuonEnDown_branch = the_tree.GetBranch("m2Pt_MuonEnDown")
        #if not self.m2Pt_MuonEnDown_branch and "m2Pt_MuonEnDown" not in self.complained:
        if not self.m2Pt_MuonEnDown_branch and "m2Pt_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2Pt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt_MuonEnDown")
        else:
            self.m2Pt_MuonEnDown_branch.SetAddress(<void*>&self.m2Pt_MuonEnDown_value)

        #print "making m2Pt_MuonEnUp"
        self.m2Pt_MuonEnUp_branch = the_tree.GetBranch("m2Pt_MuonEnUp")
        #if not self.m2Pt_MuonEnUp_branch and "m2Pt_MuonEnUp" not in self.complained:
        if not self.m2Pt_MuonEnUp_branch and "m2Pt_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2Pt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt_MuonEnUp")
        else:
            self.m2Pt_MuonEnUp_branch.SetAddress(<void*>&self.m2Pt_MuonEnUp_value)

        #print "making m2Rank"
        self.m2Rank_branch = the_tree.GetBranch("m2Rank")
        #if not self.m2Rank_branch and "m2Rank" not in self.complained:
        if not self.m2Rank_branch and "m2Rank":
            warnings.warn( "MuMuMuTree: Expected branch m2Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Rank")
        else:
            self.m2Rank_branch.SetAddress(<void*>&self.m2Rank_value)

        #print "making m2RelPFIsoDBDefault"
        self.m2RelPFIsoDBDefault_branch = the_tree.GetBranch("m2RelPFIsoDBDefault")
        #if not self.m2RelPFIsoDBDefault_branch and "m2RelPFIsoDBDefault" not in self.complained:
        if not self.m2RelPFIsoDBDefault_branch and "m2RelPFIsoDBDefault":
            warnings.warn( "MuMuMuTree: Expected branch m2RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDBDefault")
        else:
            self.m2RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m2RelPFIsoDBDefault_value)

        #print "making m2RelPFIsoDBDefaultR04"
        self.m2RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m2RelPFIsoDBDefaultR04")
        #if not self.m2RelPFIsoDBDefaultR04_branch and "m2RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m2RelPFIsoDBDefaultR04_branch and "m2RelPFIsoDBDefaultR04":
            warnings.warn( "MuMuMuTree: Expected branch m2RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDBDefaultR04")
        else:
            self.m2RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m2RelPFIsoDBDefaultR04_value)

        #print "making m2RelPFIsoRho"
        self.m2RelPFIsoRho_branch = the_tree.GetBranch("m2RelPFIsoRho")
        #if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho" not in self.complained:
        if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho":
            warnings.warn( "MuMuMuTree: Expected branch m2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRho")
        else:
            self.m2RelPFIsoRho_branch.SetAddress(<void*>&self.m2RelPFIsoRho_value)

        #print "making m2Rho"
        self.m2Rho_branch = the_tree.GetBranch("m2Rho")
        #if not self.m2Rho_branch and "m2Rho" not in self.complained:
        if not self.m2Rho_branch and "m2Rho":
            warnings.warn( "MuMuMuTree: Expected branch m2Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Rho")
        else:
            self.m2Rho_branch.SetAddress(<void*>&self.m2Rho_value)

        #print "making m2SIP2D"
        self.m2SIP2D_branch = the_tree.GetBranch("m2SIP2D")
        #if not self.m2SIP2D_branch and "m2SIP2D" not in self.complained:
        if not self.m2SIP2D_branch and "m2SIP2D":
            warnings.warn( "MuMuMuTree: Expected branch m2SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SIP2D")
        else:
            self.m2SIP2D_branch.SetAddress(<void*>&self.m2SIP2D_value)

        #print "making m2SIP3D"
        self.m2SIP3D_branch = the_tree.GetBranch("m2SIP3D")
        #if not self.m2SIP3D_branch and "m2SIP3D" not in self.complained:
        if not self.m2SIP3D_branch and "m2SIP3D":
            warnings.warn( "MuMuMuTree: Expected branch m2SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SIP3D")
        else:
            self.m2SIP3D_branch.SetAddress(<void*>&self.m2SIP3D_value)

        #print "making m2SegmentCompatibility"
        self.m2SegmentCompatibility_branch = the_tree.GetBranch("m2SegmentCompatibility")
        #if not self.m2SegmentCompatibility_branch and "m2SegmentCompatibility" not in self.complained:
        if not self.m2SegmentCompatibility_branch and "m2SegmentCompatibility":
            warnings.warn( "MuMuMuTree: Expected branch m2SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SegmentCompatibility")
        else:
            self.m2SegmentCompatibility_branch.SetAddress(<void*>&self.m2SegmentCompatibility_value)

        #print "making m2TkLayersWithMeasurement"
        self.m2TkLayersWithMeasurement_branch = the_tree.GetBranch("m2TkLayersWithMeasurement")
        #if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement" not in self.complained:
        if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement":
            warnings.warn( "MuMuMuTree: Expected branch m2TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkLayersWithMeasurement")
        else:
            self.m2TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m2TkLayersWithMeasurement_value)

        #print "making m2TrkIsoDR03"
        self.m2TrkIsoDR03_branch = the_tree.GetBranch("m2TrkIsoDR03")
        #if not self.m2TrkIsoDR03_branch and "m2TrkIsoDR03" not in self.complained:
        if not self.m2TrkIsoDR03_branch and "m2TrkIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m2TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TrkIsoDR03")
        else:
            self.m2TrkIsoDR03_branch.SetAddress(<void*>&self.m2TrkIsoDR03_value)

        #print "making m2TrkKink"
        self.m2TrkKink_branch = the_tree.GetBranch("m2TrkKink")
        #if not self.m2TrkKink_branch and "m2TrkKink" not in self.complained:
        if not self.m2TrkKink_branch and "m2TrkKink":
            warnings.warn( "MuMuMuTree: Expected branch m2TrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TrkKink")
        else:
            self.m2TrkKink_branch.SetAddress(<void*>&self.m2TrkKink_value)

        #print "making m2TypeCode"
        self.m2TypeCode_branch = the_tree.GetBranch("m2TypeCode")
        #if not self.m2TypeCode_branch and "m2TypeCode" not in self.complained:
        if not self.m2TypeCode_branch and "m2TypeCode":
            warnings.warn( "MuMuMuTree: Expected branch m2TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TypeCode")
        else:
            self.m2TypeCode_branch.SetAddress(<void*>&self.m2TypeCode_value)

        #print "making m2VZ"
        self.m2VZ_branch = the_tree.GetBranch("m2VZ")
        #if not self.m2VZ_branch and "m2VZ" not in self.complained:
        if not self.m2VZ_branch and "m2VZ":
            warnings.warn( "MuMuMuTree: Expected branch m2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VZ")
        else:
            self.m2VZ_branch.SetAddress(<void*>&self.m2VZ_value)

        #print "making m2ValidFraction"
        self.m2ValidFraction_branch = the_tree.GetBranch("m2ValidFraction")
        #if not self.m2ValidFraction_branch and "m2ValidFraction" not in self.complained:
        if not self.m2ValidFraction_branch and "m2ValidFraction":
            warnings.warn( "MuMuMuTree: Expected branch m2ValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ValidFraction")
        else:
            self.m2ValidFraction_branch.SetAddress(<void*>&self.m2ValidFraction_value)

        #print "making m2ZTTGenMatching"
        self.m2ZTTGenMatching_branch = the_tree.GetBranch("m2ZTTGenMatching")
        #if not self.m2ZTTGenMatching_branch and "m2ZTTGenMatching" not in self.complained:
        if not self.m2ZTTGenMatching_branch and "m2ZTTGenMatching":
            warnings.warn( "MuMuMuTree: Expected branch m2ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ZTTGenMatching")
        else:
            self.m2ZTTGenMatching_branch.SetAddress(<void*>&self.m2ZTTGenMatching_value)

        #print "making m2_m1_collinearmass"
        self.m2_m1_collinearmass_branch = the_tree.GetBranch("m2_m1_collinearmass")
        #if not self.m2_m1_collinearmass_branch and "m2_m1_collinearmass" not in self.complained:
        if not self.m2_m1_collinearmass_branch and "m2_m1_collinearmass":
            warnings.warn( "MuMuMuTree: Expected branch m2_m1_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass")
        else:
            self.m2_m1_collinearmass_branch.SetAddress(<void*>&self.m2_m1_collinearmass_value)

        #print "making m2_m1_collinearmass_JetEnDown"
        self.m2_m1_collinearmass_JetEnDown_branch = the_tree.GetBranch("m2_m1_collinearmass_JetEnDown")
        #if not self.m2_m1_collinearmass_JetEnDown_branch and "m2_m1_collinearmass_JetEnDown" not in self.complained:
        if not self.m2_m1_collinearmass_JetEnDown_branch and "m2_m1_collinearmass_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2_m1_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_JetEnDown")
        else:
            self.m2_m1_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m2_m1_collinearmass_JetEnDown_value)

        #print "making m2_m1_collinearmass_JetEnUp"
        self.m2_m1_collinearmass_JetEnUp_branch = the_tree.GetBranch("m2_m1_collinearmass_JetEnUp")
        #if not self.m2_m1_collinearmass_JetEnUp_branch and "m2_m1_collinearmass_JetEnUp" not in self.complained:
        if not self.m2_m1_collinearmass_JetEnUp_branch and "m2_m1_collinearmass_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2_m1_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_JetEnUp")
        else:
            self.m2_m1_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m2_m1_collinearmass_JetEnUp_value)

        #print "making m2_m1_collinearmass_UnclusteredEnDown"
        self.m2_m1_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m2_m1_collinearmass_UnclusteredEnDown")
        #if not self.m2_m1_collinearmass_UnclusteredEnDown_branch and "m2_m1_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m2_m1_collinearmass_UnclusteredEnDown_branch and "m2_m1_collinearmass_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2_m1_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_UnclusteredEnDown")
        else:
            self.m2_m1_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m2_m1_collinearmass_UnclusteredEnDown_value)

        #print "making m2_m1_collinearmass_UnclusteredEnUp"
        self.m2_m1_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m2_m1_collinearmass_UnclusteredEnUp")
        #if not self.m2_m1_collinearmass_UnclusteredEnUp_branch and "m2_m1_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m2_m1_collinearmass_UnclusteredEnUp_branch and "m2_m1_collinearmass_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2_m1_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_UnclusteredEnUp")
        else:
            self.m2_m1_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m2_m1_collinearmass_UnclusteredEnUp_value)

        #print "making m2_m3_CosThetaStar"
        self.m2_m3_CosThetaStar_branch = the_tree.GetBranch("m2_m3_CosThetaStar")
        #if not self.m2_m3_CosThetaStar_branch and "m2_m3_CosThetaStar" not in self.complained:
        if not self.m2_m3_CosThetaStar_branch and "m2_m3_CosThetaStar":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_CosThetaStar")
        else:
            self.m2_m3_CosThetaStar_branch.SetAddress(<void*>&self.m2_m3_CosThetaStar_value)

        #print "making m2_m3_DPhi"
        self.m2_m3_DPhi_branch = the_tree.GetBranch("m2_m3_DPhi")
        #if not self.m2_m3_DPhi_branch and "m2_m3_DPhi" not in self.complained:
        if not self.m2_m3_DPhi_branch and "m2_m3_DPhi":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_DPhi")
        else:
            self.m2_m3_DPhi_branch.SetAddress(<void*>&self.m2_m3_DPhi_value)

        #print "making m2_m3_DR"
        self.m2_m3_DR_branch = the_tree.GetBranch("m2_m3_DR")
        #if not self.m2_m3_DR_branch and "m2_m3_DR" not in self.complained:
        if not self.m2_m3_DR_branch and "m2_m3_DR":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_DR")
        else:
            self.m2_m3_DR_branch.SetAddress(<void*>&self.m2_m3_DR_value)

        #print "making m2_m3_Eta"
        self.m2_m3_Eta_branch = the_tree.GetBranch("m2_m3_Eta")
        #if not self.m2_m3_Eta_branch and "m2_m3_Eta" not in self.complained:
        if not self.m2_m3_Eta_branch and "m2_m3_Eta":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Eta")
        else:
            self.m2_m3_Eta_branch.SetAddress(<void*>&self.m2_m3_Eta_value)

        #print "making m2_m3_Mass"
        self.m2_m3_Mass_branch = the_tree.GetBranch("m2_m3_Mass")
        #if not self.m2_m3_Mass_branch and "m2_m3_Mass" not in self.complained:
        if not self.m2_m3_Mass_branch and "m2_m3_Mass":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Mass")
        else:
            self.m2_m3_Mass_branch.SetAddress(<void*>&self.m2_m3_Mass_value)

        #print "making m2_m3_Mass_TauEnDown"
        self.m2_m3_Mass_TauEnDown_branch = the_tree.GetBranch("m2_m3_Mass_TauEnDown")
        #if not self.m2_m3_Mass_TauEnDown_branch and "m2_m3_Mass_TauEnDown" not in self.complained:
        if not self.m2_m3_Mass_TauEnDown_branch and "m2_m3_Mass_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_Mass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Mass_TauEnDown")
        else:
            self.m2_m3_Mass_TauEnDown_branch.SetAddress(<void*>&self.m2_m3_Mass_TauEnDown_value)

        #print "making m2_m3_Mass_TauEnUp"
        self.m2_m3_Mass_TauEnUp_branch = the_tree.GetBranch("m2_m3_Mass_TauEnUp")
        #if not self.m2_m3_Mass_TauEnUp_branch and "m2_m3_Mass_TauEnUp" not in self.complained:
        if not self.m2_m3_Mass_TauEnUp_branch and "m2_m3_Mass_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_Mass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Mass_TauEnUp")
        else:
            self.m2_m3_Mass_TauEnUp_branch.SetAddress(<void*>&self.m2_m3_Mass_TauEnUp_value)

        #print "making m2_m3_Mt"
        self.m2_m3_Mt_branch = the_tree.GetBranch("m2_m3_Mt")
        #if not self.m2_m3_Mt_branch and "m2_m3_Mt" not in self.complained:
        if not self.m2_m3_Mt_branch and "m2_m3_Mt":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Mt")
        else:
            self.m2_m3_Mt_branch.SetAddress(<void*>&self.m2_m3_Mt_value)

        #print "making m2_m3_MtTotal"
        self.m2_m3_MtTotal_branch = the_tree.GetBranch("m2_m3_MtTotal")
        #if not self.m2_m3_MtTotal_branch and "m2_m3_MtTotal" not in self.complained:
        if not self.m2_m3_MtTotal_branch and "m2_m3_MtTotal":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_MtTotal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_MtTotal")
        else:
            self.m2_m3_MtTotal_branch.SetAddress(<void*>&self.m2_m3_MtTotal_value)

        #print "making m2_m3_Mt_TauEnDown"
        self.m2_m3_Mt_TauEnDown_branch = the_tree.GetBranch("m2_m3_Mt_TauEnDown")
        #if not self.m2_m3_Mt_TauEnDown_branch and "m2_m3_Mt_TauEnDown" not in self.complained:
        if not self.m2_m3_Mt_TauEnDown_branch and "m2_m3_Mt_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_Mt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Mt_TauEnDown")
        else:
            self.m2_m3_Mt_TauEnDown_branch.SetAddress(<void*>&self.m2_m3_Mt_TauEnDown_value)

        #print "making m2_m3_Mt_TauEnUp"
        self.m2_m3_Mt_TauEnUp_branch = the_tree.GetBranch("m2_m3_Mt_TauEnUp")
        #if not self.m2_m3_Mt_TauEnUp_branch and "m2_m3_Mt_TauEnUp" not in self.complained:
        if not self.m2_m3_Mt_TauEnUp_branch and "m2_m3_Mt_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_Mt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Mt_TauEnUp")
        else:
            self.m2_m3_Mt_TauEnUp_branch.SetAddress(<void*>&self.m2_m3_Mt_TauEnUp_value)

        #print "making m2_m3_MvaMet"
        self.m2_m3_MvaMet_branch = the_tree.GetBranch("m2_m3_MvaMet")
        #if not self.m2_m3_MvaMet_branch and "m2_m3_MvaMet" not in self.complained:
        if not self.m2_m3_MvaMet_branch and "m2_m3_MvaMet":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_MvaMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_MvaMet")
        else:
            self.m2_m3_MvaMet_branch.SetAddress(<void*>&self.m2_m3_MvaMet_value)

        #print "making m2_m3_MvaMetCovMatrix00"
        self.m2_m3_MvaMetCovMatrix00_branch = the_tree.GetBranch("m2_m3_MvaMetCovMatrix00")
        #if not self.m2_m3_MvaMetCovMatrix00_branch and "m2_m3_MvaMetCovMatrix00" not in self.complained:
        if not self.m2_m3_MvaMetCovMatrix00_branch and "m2_m3_MvaMetCovMatrix00":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_MvaMetCovMatrix00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_MvaMetCovMatrix00")
        else:
            self.m2_m3_MvaMetCovMatrix00_branch.SetAddress(<void*>&self.m2_m3_MvaMetCovMatrix00_value)

        #print "making m2_m3_MvaMetCovMatrix01"
        self.m2_m3_MvaMetCovMatrix01_branch = the_tree.GetBranch("m2_m3_MvaMetCovMatrix01")
        #if not self.m2_m3_MvaMetCovMatrix01_branch and "m2_m3_MvaMetCovMatrix01" not in self.complained:
        if not self.m2_m3_MvaMetCovMatrix01_branch and "m2_m3_MvaMetCovMatrix01":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_MvaMetCovMatrix01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_MvaMetCovMatrix01")
        else:
            self.m2_m3_MvaMetCovMatrix01_branch.SetAddress(<void*>&self.m2_m3_MvaMetCovMatrix01_value)

        #print "making m2_m3_MvaMetCovMatrix10"
        self.m2_m3_MvaMetCovMatrix10_branch = the_tree.GetBranch("m2_m3_MvaMetCovMatrix10")
        #if not self.m2_m3_MvaMetCovMatrix10_branch and "m2_m3_MvaMetCovMatrix10" not in self.complained:
        if not self.m2_m3_MvaMetCovMatrix10_branch and "m2_m3_MvaMetCovMatrix10":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_MvaMetCovMatrix10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_MvaMetCovMatrix10")
        else:
            self.m2_m3_MvaMetCovMatrix10_branch.SetAddress(<void*>&self.m2_m3_MvaMetCovMatrix10_value)

        #print "making m2_m3_MvaMetCovMatrix11"
        self.m2_m3_MvaMetCovMatrix11_branch = the_tree.GetBranch("m2_m3_MvaMetCovMatrix11")
        #if not self.m2_m3_MvaMetCovMatrix11_branch and "m2_m3_MvaMetCovMatrix11" not in self.complained:
        if not self.m2_m3_MvaMetCovMatrix11_branch and "m2_m3_MvaMetCovMatrix11":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_MvaMetCovMatrix11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_MvaMetCovMatrix11")
        else:
            self.m2_m3_MvaMetCovMatrix11_branch.SetAddress(<void*>&self.m2_m3_MvaMetCovMatrix11_value)

        #print "making m2_m3_MvaMetPhi"
        self.m2_m3_MvaMetPhi_branch = the_tree.GetBranch("m2_m3_MvaMetPhi")
        #if not self.m2_m3_MvaMetPhi_branch and "m2_m3_MvaMetPhi" not in self.complained:
        if not self.m2_m3_MvaMetPhi_branch and "m2_m3_MvaMetPhi":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_MvaMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_MvaMetPhi")
        else:
            self.m2_m3_MvaMetPhi_branch.SetAddress(<void*>&self.m2_m3_MvaMetPhi_value)

        #print "making m2_m3_PZeta"
        self.m2_m3_PZeta_branch = the_tree.GetBranch("m2_m3_PZeta")
        #if not self.m2_m3_PZeta_branch and "m2_m3_PZeta" not in self.complained:
        if not self.m2_m3_PZeta_branch and "m2_m3_PZeta":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_PZeta")
        else:
            self.m2_m3_PZeta_branch.SetAddress(<void*>&self.m2_m3_PZeta_value)

        #print "making m2_m3_PZetaLess0p85PZetaVis"
        self.m2_m3_PZetaLess0p85PZetaVis_branch = the_tree.GetBranch("m2_m3_PZetaLess0p85PZetaVis")
        #if not self.m2_m3_PZetaLess0p85PZetaVis_branch and "m2_m3_PZetaLess0p85PZetaVis" not in self.complained:
        if not self.m2_m3_PZetaLess0p85PZetaVis_branch and "m2_m3_PZetaLess0p85PZetaVis":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_PZetaLess0p85PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_PZetaLess0p85PZetaVis")
        else:
            self.m2_m3_PZetaLess0p85PZetaVis_branch.SetAddress(<void*>&self.m2_m3_PZetaLess0p85PZetaVis_value)

        #print "making m2_m3_PZetaVis"
        self.m2_m3_PZetaVis_branch = the_tree.GetBranch("m2_m3_PZetaVis")
        #if not self.m2_m3_PZetaVis_branch and "m2_m3_PZetaVis" not in self.complained:
        if not self.m2_m3_PZetaVis_branch and "m2_m3_PZetaVis":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_PZetaVis")
        else:
            self.m2_m3_PZetaVis_branch.SetAddress(<void*>&self.m2_m3_PZetaVis_value)

        #print "making m2_m3_Phi"
        self.m2_m3_Phi_branch = the_tree.GetBranch("m2_m3_Phi")
        #if not self.m2_m3_Phi_branch and "m2_m3_Phi" not in self.complained:
        if not self.m2_m3_Phi_branch and "m2_m3_Phi":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Phi")
        else:
            self.m2_m3_Phi_branch.SetAddress(<void*>&self.m2_m3_Phi_value)

        #print "making m2_m3_Pt"
        self.m2_m3_Pt_branch = the_tree.GetBranch("m2_m3_Pt")
        #if not self.m2_m3_Pt_branch and "m2_m3_Pt" not in self.complained:
        if not self.m2_m3_Pt_branch and "m2_m3_Pt":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Pt")
        else:
            self.m2_m3_Pt_branch.SetAddress(<void*>&self.m2_m3_Pt_value)

        #print "making m2_m3_SS"
        self.m2_m3_SS_branch = the_tree.GetBranch("m2_m3_SS")
        #if not self.m2_m3_SS_branch and "m2_m3_SS" not in self.complained:
        if not self.m2_m3_SS_branch and "m2_m3_SS":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_SS")
        else:
            self.m2_m3_SS_branch.SetAddress(<void*>&self.m2_m3_SS_value)

        #print "making m2_m3_ToMETDPhi_Ty1"
        self.m2_m3_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m2_m3_ToMETDPhi_Ty1")
        #if not self.m2_m3_ToMETDPhi_Ty1_branch and "m2_m3_ToMETDPhi_Ty1" not in self.complained:
        if not self.m2_m3_ToMETDPhi_Ty1_branch and "m2_m3_ToMETDPhi_Ty1":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_ToMETDPhi_Ty1")
        else:
            self.m2_m3_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m2_m3_ToMETDPhi_Ty1_value)

        #print "making m2_m3_collinearmass"
        self.m2_m3_collinearmass_branch = the_tree.GetBranch("m2_m3_collinearmass")
        #if not self.m2_m3_collinearmass_branch and "m2_m3_collinearmass" not in self.complained:
        if not self.m2_m3_collinearmass_branch and "m2_m3_collinearmass":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_collinearmass")
        else:
            self.m2_m3_collinearmass_branch.SetAddress(<void*>&self.m2_m3_collinearmass_value)

        #print "making m2_m3_collinearmass_EleEnDown"
        self.m2_m3_collinearmass_EleEnDown_branch = the_tree.GetBranch("m2_m3_collinearmass_EleEnDown")
        #if not self.m2_m3_collinearmass_EleEnDown_branch and "m2_m3_collinearmass_EleEnDown" not in self.complained:
        if not self.m2_m3_collinearmass_EleEnDown_branch and "m2_m3_collinearmass_EleEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_collinearmass_EleEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_collinearmass_EleEnDown")
        else:
            self.m2_m3_collinearmass_EleEnDown_branch.SetAddress(<void*>&self.m2_m3_collinearmass_EleEnDown_value)

        #print "making m2_m3_collinearmass_EleEnUp"
        self.m2_m3_collinearmass_EleEnUp_branch = the_tree.GetBranch("m2_m3_collinearmass_EleEnUp")
        #if not self.m2_m3_collinearmass_EleEnUp_branch and "m2_m3_collinearmass_EleEnUp" not in self.complained:
        if not self.m2_m3_collinearmass_EleEnUp_branch and "m2_m3_collinearmass_EleEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_collinearmass_EleEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_collinearmass_EleEnUp")
        else:
            self.m2_m3_collinearmass_EleEnUp_branch.SetAddress(<void*>&self.m2_m3_collinearmass_EleEnUp_value)

        #print "making m2_m3_collinearmass_JetEnDown"
        self.m2_m3_collinearmass_JetEnDown_branch = the_tree.GetBranch("m2_m3_collinearmass_JetEnDown")
        #if not self.m2_m3_collinearmass_JetEnDown_branch and "m2_m3_collinearmass_JetEnDown" not in self.complained:
        if not self.m2_m3_collinearmass_JetEnDown_branch and "m2_m3_collinearmass_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_collinearmass_JetEnDown")
        else:
            self.m2_m3_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m2_m3_collinearmass_JetEnDown_value)

        #print "making m2_m3_collinearmass_JetEnUp"
        self.m2_m3_collinearmass_JetEnUp_branch = the_tree.GetBranch("m2_m3_collinearmass_JetEnUp")
        #if not self.m2_m3_collinearmass_JetEnUp_branch and "m2_m3_collinearmass_JetEnUp" not in self.complained:
        if not self.m2_m3_collinearmass_JetEnUp_branch and "m2_m3_collinearmass_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_collinearmass_JetEnUp")
        else:
            self.m2_m3_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m2_m3_collinearmass_JetEnUp_value)

        #print "making m2_m3_collinearmass_MuEnDown"
        self.m2_m3_collinearmass_MuEnDown_branch = the_tree.GetBranch("m2_m3_collinearmass_MuEnDown")
        #if not self.m2_m3_collinearmass_MuEnDown_branch and "m2_m3_collinearmass_MuEnDown" not in self.complained:
        if not self.m2_m3_collinearmass_MuEnDown_branch and "m2_m3_collinearmass_MuEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_collinearmass_MuEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_collinearmass_MuEnDown")
        else:
            self.m2_m3_collinearmass_MuEnDown_branch.SetAddress(<void*>&self.m2_m3_collinearmass_MuEnDown_value)

        #print "making m2_m3_collinearmass_MuEnUp"
        self.m2_m3_collinearmass_MuEnUp_branch = the_tree.GetBranch("m2_m3_collinearmass_MuEnUp")
        #if not self.m2_m3_collinearmass_MuEnUp_branch and "m2_m3_collinearmass_MuEnUp" not in self.complained:
        if not self.m2_m3_collinearmass_MuEnUp_branch and "m2_m3_collinearmass_MuEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_collinearmass_MuEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_collinearmass_MuEnUp")
        else:
            self.m2_m3_collinearmass_MuEnUp_branch.SetAddress(<void*>&self.m2_m3_collinearmass_MuEnUp_value)

        #print "making m2_m3_collinearmass_TauEnDown"
        self.m2_m3_collinearmass_TauEnDown_branch = the_tree.GetBranch("m2_m3_collinearmass_TauEnDown")
        #if not self.m2_m3_collinearmass_TauEnDown_branch and "m2_m3_collinearmass_TauEnDown" not in self.complained:
        if not self.m2_m3_collinearmass_TauEnDown_branch and "m2_m3_collinearmass_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_collinearmass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_collinearmass_TauEnDown")
        else:
            self.m2_m3_collinearmass_TauEnDown_branch.SetAddress(<void*>&self.m2_m3_collinearmass_TauEnDown_value)

        #print "making m2_m3_collinearmass_TauEnUp"
        self.m2_m3_collinearmass_TauEnUp_branch = the_tree.GetBranch("m2_m3_collinearmass_TauEnUp")
        #if not self.m2_m3_collinearmass_TauEnUp_branch and "m2_m3_collinearmass_TauEnUp" not in self.complained:
        if not self.m2_m3_collinearmass_TauEnUp_branch and "m2_m3_collinearmass_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_collinearmass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_collinearmass_TauEnUp")
        else:
            self.m2_m3_collinearmass_TauEnUp_branch.SetAddress(<void*>&self.m2_m3_collinearmass_TauEnUp_value)

        #print "making m2_m3_collinearmass_UnclusteredEnDown"
        self.m2_m3_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m2_m3_collinearmass_UnclusteredEnDown")
        #if not self.m2_m3_collinearmass_UnclusteredEnDown_branch and "m2_m3_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m2_m3_collinearmass_UnclusteredEnDown_branch and "m2_m3_collinearmass_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_collinearmass_UnclusteredEnDown")
        else:
            self.m2_m3_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m2_m3_collinearmass_UnclusteredEnDown_value)

        #print "making m2_m3_collinearmass_UnclusteredEnUp"
        self.m2_m3_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m2_m3_collinearmass_UnclusteredEnUp")
        #if not self.m2_m3_collinearmass_UnclusteredEnUp_branch and "m2_m3_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m2_m3_collinearmass_UnclusteredEnUp_branch and "m2_m3_collinearmass_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_collinearmass_UnclusteredEnUp")
        else:
            self.m2_m3_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m2_m3_collinearmass_UnclusteredEnUp_value)

        #print "making m2_m3_pt_tt"
        self.m2_m3_pt_tt_branch = the_tree.GetBranch("m2_m3_pt_tt")
        #if not self.m2_m3_pt_tt_branch and "m2_m3_pt_tt" not in self.complained:
        if not self.m2_m3_pt_tt_branch and "m2_m3_pt_tt":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_pt_tt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_pt_tt")
        else:
            self.m2_m3_pt_tt_branch.SetAddress(<void*>&self.m2_m3_pt_tt_value)

        #print "making m3AbsEta"
        self.m3AbsEta_branch = the_tree.GetBranch("m3AbsEta")
        #if not self.m3AbsEta_branch and "m3AbsEta" not in self.complained:
        if not self.m3AbsEta_branch and "m3AbsEta":
            warnings.warn( "MuMuMuTree: Expected branch m3AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3AbsEta")
        else:
            self.m3AbsEta_branch.SetAddress(<void*>&self.m3AbsEta_value)

        #print "making m3BestTrackType"
        self.m3BestTrackType_branch = the_tree.GetBranch("m3BestTrackType")
        #if not self.m3BestTrackType_branch and "m3BestTrackType" not in self.complained:
        if not self.m3BestTrackType_branch and "m3BestTrackType":
            warnings.warn( "MuMuMuTree: Expected branch m3BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3BestTrackType")
        else:
            self.m3BestTrackType_branch.SetAddress(<void*>&self.m3BestTrackType_value)

        #print "making m3Charge"
        self.m3Charge_branch = the_tree.GetBranch("m3Charge")
        #if not self.m3Charge_branch and "m3Charge" not in self.complained:
        if not self.m3Charge_branch and "m3Charge":
            warnings.warn( "MuMuMuTree: Expected branch m3Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Charge")
        else:
            self.m3Charge_branch.SetAddress(<void*>&self.m3Charge_value)

        #print "making m3Chi2LocalPosition"
        self.m3Chi2LocalPosition_branch = the_tree.GetBranch("m3Chi2LocalPosition")
        #if not self.m3Chi2LocalPosition_branch and "m3Chi2LocalPosition" not in self.complained:
        if not self.m3Chi2LocalPosition_branch and "m3Chi2LocalPosition":
            warnings.warn( "MuMuMuTree: Expected branch m3Chi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Chi2LocalPosition")
        else:
            self.m3Chi2LocalPosition_branch.SetAddress(<void*>&self.m3Chi2LocalPosition_value)

        #print "making m3ComesFromHiggs"
        self.m3ComesFromHiggs_branch = the_tree.GetBranch("m3ComesFromHiggs")
        #if not self.m3ComesFromHiggs_branch and "m3ComesFromHiggs" not in self.complained:
        if not self.m3ComesFromHiggs_branch and "m3ComesFromHiggs":
            warnings.warn( "MuMuMuTree: Expected branch m3ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ComesFromHiggs")
        else:
            self.m3ComesFromHiggs_branch.SetAddress(<void*>&self.m3ComesFromHiggs_value)

        #print "making m3DPhiToPfMet_ElectronEnDown"
        self.m3DPhiToPfMet_ElectronEnDown_branch = the_tree.GetBranch("m3DPhiToPfMet_ElectronEnDown")
        #if not self.m3DPhiToPfMet_ElectronEnDown_branch and "m3DPhiToPfMet_ElectronEnDown" not in self.complained:
        if not self.m3DPhiToPfMet_ElectronEnDown_branch and "m3DPhiToPfMet_ElectronEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_ElectronEnDown")
        else:
            self.m3DPhiToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.m3DPhiToPfMet_ElectronEnDown_value)

        #print "making m3DPhiToPfMet_ElectronEnUp"
        self.m3DPhiToPfMet_ElectronEnUp_branch = the_tree.GetBranch("m3DPhiToPfMet_ElectronEnUp")
        #if not self.m3DPhiToPfMet_ElectronEnUp_branch and "m3DPhiToPfMet_ElectronEnUp" not in self.complained:
        if not self.m3DPhiToPfMet_ElectronEnUp_branch and "m3DPhiToPfMet_ElectronEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_ElectronEnUp")
        else:
            self.m3DPhiToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.m3DPhiToPfMet_ElectronEnUp_value)

        #print "making m3DPhiToPfMet_JetEnDown"
        self.m3DPhiToPfMet_JetEnDown_branch = the_tree.GetBranch("m3DPhiToPfMet_JetEnDown")
        #if not self.m3DPhiToPfMet_JetEnDown_branch and "m3DPhiToPfMet_JetEnDown" not in self.complained:
        if not self.m3DPhiToPfMet_JetEnDown_branch and "m3DPhiToPfMet_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_JetEnDown")
        else:
            self.m3DPhiToPfMet_JetEnDown_branch.SetAddress(<void*>&self.m3DPhiToPfMet_JetEnDown_value)

        #print "making m3DPhiToPfMet_JetEnUp"
        self.m3DPhiToPfMet_JetEnUp_branch = the_tree.GetBranch("m3DPhiToPfMet_JetEnUp")
        #if not self.m3DPhiToPfMet_JetEnUp_branch and "m3DPhiToPfMet_JetEnUp" not in self.complained:
        if not self.m3DPhiToPfMet_JetEnUp_branch and "m3DPhiToPfMet_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_JetEnUp")
        else:
            self.m3DPhiToPfMet_JetEnUp_branch.SetAddress(<void*>&self.m3DPhiToPfMet_JetEnUp_value)

        #print "making m3DPhiToPfMet_JetResDown"
        self.m3DPhiToPfMet_JetResDown_branch = the_tree.GetBranch("m3DPhiToPfMet_JetResDown")
        #if not self.m3DPhiToPfMet_JetResDown_branch and "m3DPhiToPfMet_JetResDown" not in self.complained:
        if not self.m3DPhiToPfMet_JetResDown_branch and "m3DPhiToPfMet_JetResDown":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_JetResDown")
        else:
            self.m3DPhiToPfMet_JetResDown_branch.SetAddress(<void*>&self.m3DPhiToPfMet_JetResDown_value)

        #print "making m3DPhiToPfMet_JetResUp"
        self.m3DPhiToPfMet_JetResUp_branch = the_tree.GetBranch("m3DPhiToPfMet_JetResUp")
        #if not self.m3DPhiToPfMet_JetResUp_branch and "m3DPhiToPfMet_JetResUp" not in self.complained:
        if not self.m3DPhiToPfMet_JetResUp_branch and "m3DPhiToPfMet_JetResUp":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_JetResUp")
        else:
            self.m3DPhiToPfMet_JetResUp_branch.SetAddress(<void*>&self.m3DPhiToPfMet_JetResUp_value)

        #print "making m3DPhiToPfMet_MuonEnDown"
        self.m3DPhiToPfMet_MuonEnDown_branch = the_tree.GetBranch("m3DPhiToPfMet_MuonEnDown")
        #if not self.m3DPhiToPfMet_MuonEnDown_branch and "m3DPhiToPfMet_MuonEnDown" not in self.complained:
        if not self.m3DPhiToPfMet_MuonEnDown_branch and "m3DPhiToPfMet_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_MuonEnDown")
        else:
            self.m3DPhiToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.m3DPhiToPfMet_MuonEnDown_value)

        #print "making m3DPhiToPfMet_MuonEnUp"
        self.m3DPhiToPfMet_MuonEnUp_branch = the_tree.GetBranch("m3DPhiToPfMet_MuonEnUp")
        #if not self.m3DPhiToPfMet_MuonEnUp_branch and "m3DPhiToPfMet_MuonEnUp" not in self.complained:
        if not self.m3DPhiToPfMet_MuonEnUp_branch and "m3DPhiToPfMet_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_MuonEnUp")
        else:
            self.m3DPhiToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.m3DPhiToPfMet_MuonEnUp_value)

        #print "making m3DPhiToPfMet_PhotonEnDown"
        self.m3DPhiToPfMet_PhotonEnDown_branch = the_tree.GetBranch("m3DPhiToPfMet_PhotonEnDown")
        #if not self.m3DPhiToPfMet_PhotonEnDown_branch and "m3DPhiToPfMet_PhotonEnDown" not in self.complained:
        if not self.m3DPhiToPfMet_PhotonEnDown_branch and "m3DPhiToPfMet_PhotonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_PhotonEnDown")
        else:
            self.m3DPhiToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.m3DPhiToPfMet_PhotonEnDown_value)

        #print "making m3DPhiToPfMet_PhotonEnUp"
        self.m3DPhiToPfMet_PhotonEnUp_branch = the_tree.GetBranch("m3DPhiToPfMet_PhotonEnUp")
        #if not self.m3DPhiToPfMet_PhotonEnUp_branch and "m3DPhiToPfMet_PhotonEnUp" not in self.complained:
        if not self.m3DPhiToPfMet_PhotonEnUp_branch and "m3DPhiToPfMet_PhotonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_PhotonEnUp")
        else:
            self.m3DPhiToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.m3DPhiToPfMet_PhotonEnUp_value)

        #print "making m3DPhiToPfMet_TauEnDown"
        self.m3DPhiToPfMet_TauEnDown_branch = the_tree.GetBranch("m3DPhiToPfMet_TauEnDown")
        #if not self.m3DPhiToPfMet_TauEnDown_branch and "m3DPhiToPfMet_TauEnDown" not in self.complained:
        if not self.m3DPhiToPfMet_TauEnDown_branch and "m3DPhiToPfMet_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_TauEnDown")
        else:
            self.m3DPhiToPfMet_TauEnDown_branch.SetAddress(<void*>&self.m3DPhiToPfMet_TauEnDown_value)

        #print "making m3DPhiToPfMet_TauEnUp"
        self.m3DPhiToPfMet_TauEnUp_branch = the_tree.GetBranch("m3DPhiToPfMet_TauEnUp")
        #if not self.m3DPhiToPfMet_TauEnUp_branch and "m3DPhiToPfMet_TauEnUp" not in self.complained:
        if not self.m3DPhiToPfMet_TauEnUp_branch and "m3DPhiToPfMet_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_TauEnUp")
        else:
            self.m3DPhiToPfMet_TauEnUp_branch.SetAddress(<void*>&self.m3DPhiToPfMet_TauEnUp_value)

        #print "making m3DPhiToPfMet_UnclusteredEnDown"
        self.m3DPhiToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("m3DPhiToPfMet_UnclusteredEnDown")
        #if not self.m3DPhiToPfMet_UnclusteredEnDown_branch and "m3DPhiToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.m3DPhiToPfMet_UnclusteredEnDown_branch and "m3DPhiToPfMet_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_UnclusteredEnDown")
        else:
            self.m3DPhiToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.m3DPhiToPfMet_UnclusteredEnDown_value)

        #print "making m3DPhiToPfMet_UnclusteredEnUp"
        self.m3DPhiToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("m3DPhiToPfMet_UnclusteredEnUp")
        #if not self.m3DPhiToPfMet_UnclusteredEnUp_branch and "m3DPhiToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.m3DPhiToPfMet_UnclusteredEnUp_branch and "m3DPhiToPfMet_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_UnclusteredEnUp")
        else:
            self.m3DPhiToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.m3DPhiToPfMet_UnclusteredEnUp_value)

        #print "making m3DPhiToPfMet_type1"
        self.m3DPhiToPfMet_type1_branch = the_tree.GetBranch("m3DPhiToPfMet_type1")
        #if not self.m3DPhiToPfMet_type1_branch and "m3DPhiToPfMet_type1" not in self.complained:
        if not self.m3DPhiToPfMet_type1_branch and "m3DPhiToPfMet_type1":
            warnings.warn( "MuMuMuTree: Expected branch m3DPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DPhiToPfMet_type1")
        else:
            self.m3DPhiToPfMet_type1_branch.SetAddress(<void*>&self.m3DPhiToPfMet_type1_value)

        #print "making m3EcalIsoDR03"
        self.m3EcalIsoDR03_branch = the_tree.GetBranch("m3EcalIsoDR03")
        #if not self.m3EcalIsoDR03_branch and "m3EcalIsoDR03" not in self.complained:
        if not self.m3EcalIsoDR03_branch and "m3EcalIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m3EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EcalIsoDR03")
        else:
            self.m3EcalIsoDR03_branch.SetAddress(<void*>&self.m3EcalIsoDR03_value)

        #print "making m3EffectiveArea2011"
        self.m3EffectiveArea2011_branch = the_tree.GetBranch("m3EffectiveArea2011")
        #if not self.m3EffectiveArea2011_branch and "m3EffectiveArea2011" not in self.complained:
        if not self.m3EffectiveArea2011_branch and "m3EffectiveArea2011":
            warnings.warn( "MuMuMuTree: Expected branch m3EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EffectiveArea2011")
        else:
            self.m3EffectiveArea2011_branch.SetAddress(<void*>&self.m3EffectiveArea2011_value)

        #print "making m3EffectiveArea2012"
        self.m3EffectiveArea2012_branch = the_tree.GetBranch("m3EffectiveArea2012")
        #if not self.m3EffectiveArea2012_branch and "m3EffectiveArea2012" not in self.complained:
        if not self.m3EffectiveArea2012_branch and "m3EffectiveArea2012":
            warnings.warn( "MuMuMuTree: Expected branch m3EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EffectiveArea2012")
        else:
            self.m3EffectiveArea2012_branch.SetAddress(<void*>&self.m3EffectiveArea2012_value)

        #print "making m3ErsatzGenEta"
        self.m3ErsatzGenEta_branch = the_tree.GetBranch("m3ErsatzGenEta")
        #if not self.m3ErsatzGenEta_branch and "m3ErsatzGenEta" not in self.complained:
        if not self.m3ErsatzGenEta_branch and "m3ErsatzGenEta":
            warnings.warn( "MuMuMuTree: Expected branch m3ErsatzGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ErsatzGenEta")
        else:
            self.m3ErsatzGenEta_branch.SetAddress(<void*>&self.m3ErsatzGenEta_value)

        #print "making m3ErsatzGenM"
        self.m3ErsatzGenM_branch = the_tree.GetBranch("m3ErsatzGenM")
        #if not self.m3ErsatzGenM_branch and "m3ErsatzGenM" not in self.complained:
        if not self.m3ErsatzGenM_branch and "m3ErsatzGenM":
            warnings.warn( "MuMuMuTree: Expected branch m3ErsatzGenM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ErsatzGenM")
        else:
            self.m3ErsatzGenM_branch.SetAddress(<void*>&self.m3ErsatzGenM_value)

        #print "making m3ErsatzGenPhi"
        self.m3ErsatzGenPhi_branch = the_tree.GetBranch("m3ErsatzGenPhi")
        #if not self.m3ErsatzGenPhi_branch and "m3ErsatzGenPhi" not in self.complained:
        if not self.m3ErsatzGenPhi_branch and "m3ErsatzGenPhi":
            warnings.warn( "MuMuMuTree: Expected branch m3ErsatzGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ErsatzGenPhi")
        else:
            self.m3ErsatzGenPhi_branch.SetAddress(<void*>&self.m3ErsatzGenPhi_value)

        #print "making m3ErsatzGenpT"
        self.m3ErsatzGenpT_branch = the_tree.GetBranch("m3ErsatzGenpT")
        #if not self.m3ErsatzGenpT_branch and "m3ErsatzGenpT" not in self.complained:
        if not self.m3ErsatzGenpT_branch and "m3ErsatzGenpT":
            warnings.warn( "MuMuMuTree: Expected branch m3ErsatzGenpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ErsatzGenpT")
        else:
            self.m3ErsatzGenpT_branch.SetAddress(<void*>&self.m3ErsatzGenpT_value)

        #print "making m3ErsatzGenpX"
        self.m3ErsatzGenpX_branch = the_tree.GetBranch("m3ErsatzGenpX")
        #if not self.m3ErsatzGenpX_branch and "m3ErsatzGenpX" not in self.complained:
        if not self.m3ErsatzGenpX_branch and "m3ErsatzGenpX":
            warnings.warn( "MuMuMuTree: Expected branch m3ErsatzGenpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ErsatzGenpX")
        else:
            self.m3ErsatzGenpX_branch.SetAddress(<void*>&self.m3ErsatzGenpX_value)

        #print "making m3ErsatzGenpY"
        self.m3ErsatzGenpY_branch = the_tree.GetBranch("m3ErsatzGenpY")
        #if not self.m3ErsatzGenpY_branch and "m3ErsatzGenpY" not in self.complained:
        if not self.m3ErsatzGenpY_branch and "m3ErsatzGenpY":
            warnings.warn( "MuMuMuTree: Expected branch m3ErsatzGenpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ErsatzGenpY")
        else:
            self.m3ErsatzGenpY_branch.SetAddress(<void*>&self.m3ErsatzGenpY_value)

        #print "making m3ErsatzVispX"
        self.m3ErsatzVispX_branch = the_tree.GetBranch("m3ErsatzVispX")
        #if not self.m3ErsatzVispX_branch and "m3ErsatzVispX" not in self.complained:
        if not self.m3ErsatzVispX_branch and "m3ErsatzVispX":
            warnings.warn( "MuMuMuTree: Expected branch m3ErsatzVispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ErsatzVispX")
        else:
            self.m3ErsatzVispX_branch.SetAddress(<void*>&self.m3ErsatzVispX_value)

        #print "making m3ErsatzVispY"
        self.m3ErsatzVispY_branch = the_tree.GetBranch("m3ErsatzVispY")
        #if not self.m3ErsatzVispY_branch and "m3ErsatzVispY" not in self.complained:
        if not self.m3ErsatzVispY_branch and "m3ErsatzVispY":
            warnings.warn( "MuMuMuTree: Expected branch m3ErsatzVispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ErsatzVispY")
        else:
            self.m3ErsatzVispY_branch.SetAddress(<void*>&self.m3ErsatzVispY_value)

        #print "making m3Eta"
        self.m3Eta_branch = the_tree.GetBranch("m3Eta")
        #if not self.m3Eta_branch and "m3Eta" not in self.complained:
        if not self.m3Eta_branch and "m3Eta":
            warnings.warn( "MuMuMuTree: Expected branch m3Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Eta")
        else:
            self.m3Eta_branch.SetAddress(<void*>&self.m3Eta_value)

        #print "making m3Eta_MuonEnDown"
        self.m3Eta_MuonEnDown_branch = the_tree.GetBranch("m3Eta_MuonEnDown")
        #if not self.m3Eta_MuonEnDown_branch and "m3Eta_MuonEnDown" not in self.complained:
        if not self.m3Eta_MuonEnDown_branch and "m3Eta_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3Eta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Eta_MuonEnDown")
        else:
            self.m3Eta_MuonEnDown_branch.SetAddress(<void*>&self.m3Eta_MuonEnDown_value)

        #print "making m3Eta_MuonEnUp"
        self.m3Eta_MuonEnUp_branch = the_tree.GetBranch("m3Eta_MuonEnUp")
        #if not self.m3Eta_MuonEnUp_branch and "m3Eta_MuonEnUp" not in self.complained:
        if not self.m3Eta_MuonEnUp_branch and "m3Eta_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3Eta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Eta_MuonEnUp")
        else:
            self.m3Eta_MuonEnUp_branch.SetAddress(<void*>&self.m3Eta_MuonEnUp_value)

        #print "making m3GenCharge"
        self.m3GenCharge_branch = the_tree.GetBranch("m3GenCharge")
        #if not self.m3GenCharge_branch and "m3GenCharge" not in self.complained:
        if not self.m3GenCharge_branch and "m3GenCharge":
            warnings.warn( "MuMuMuTree: Expected branch m3GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenCharge")
        else:
            self.m3GenCharge_branch.SetAddress(<void*>&self.m3GenCharge_value)

        #print "making m3GenDirectPromptTauDecayFinalState"
        self.m3GenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("m3GenDirectPromptTauDecayFinalState")
        #if not self.m3GenDirectPromptTauDecayFinalState_branch and "m3GenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.m3GenDirectPromptTauDecayFinalState_branch and "m3GenDirectPromptTauDecayFinalState":
            warnings.warn( "MuMuMuTree: Expected branch m3GenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenDirectPromptTauDecayFinalState")
        else:
            self.m3GenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.m3GenDirectPromptTauDecayFinalState_value)

        #print "making m3GenEnergy"
        self.m3GenEnergy_branch = the_tree.GetBranch("m3GenEnergy")
        #if not self.m3GenEnergy_branch and "m3GenEnergy" not in self.complained:
        if not self.m3GenEnergy_branch and "m3GenEnergy":
            warnings.warn( "MuMuMuTree: Expected branch m3GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenEnergy")
        else:
            self.m3GenEnergy_branch.SetAddress(<void*>&self.m3GenEnergy_value)

        #print "making m3GenEta"
        self.m3GenEta_branch = the_tree.GetBranch("m3GenEta")
        #if not self.m3GenEta_branch and "m3GenEta" not in self.complained:
        if not self.m3GenEta_branch and "m3GenEta":
            warnings.warn( "MuMuMuTree: Expected branch m3GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenEta")
        else:
            self.m3GenEta_branch.SetAddress(<void*>&self.m3GenEta_value)

        #print "making m3GenIsPrompt"
        self.m3GenIsPrompt_branch = the_tree.GetBranch("m3GenIsPrompt")
        #if not self.m3GenIsPrompt_branch and "m3GenIsPrompt" not in self.complained:
        if not self.m3GenIsPrompt_branch and "m3GenIsPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m3GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenIsPrompt")
        else:
            self.m3GenIsPrompt_branch.SetAddress(<void*>&self.m3GenIsPrompt_value)

        #print "making m3GenMotherPdgId"
        self.m3GenMotherPdgId_branch = the_tree.GetBranch("m3GenMotherPdgId")
        #if not self.m3GenMotherPdgId_branch and "m3GenMotherPdgId" not in self.complained:
        if not self.m3GenMotherPdgId_branch and "m3GenMotherPdgId":
            warnings.warn( "MuMuMuTree: Expected branch m3GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenMotherPdgId")
        else:
            self.m3GenMotherPdgId_branch.SetAddress(<void*>&self.m3GenMotherPdgId_value)

        #print "making m3GenParticle"
        self.m3GenParticle_branch = the_tree.GetBranch("m3GenParticle")
        #if not self.m3GenParticle_branch and "m3GenParticle" not in self.complained:
        if not self.m3GenParticle_branch and "m3GenParticle":
            warnings.warn( "MuMuMuTree: Expected branch m3GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenParticle")
        else:
            self.m3GenParticle_branch.SetAddress(<void*>&self.m3GenParticle_value)

        #print "making m3GenPdgId"
        self.m3GenPdgId_branch = the_tree.GetBranch("m3GenPdgId")
        #if not self.m3GenPdgId_branch and "m3GenPdgId" not in self.complained:
        if not self.m3GenPdgId_branch and "m3GenPdgId":
            warnings.warn( "MuMuMuTree: Expected branch m3GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPdgId")
        else:
            self.m3GenPdgId_branch.SetAddress(<void*>&self.m3GenPdgId_value)

        #print "making m3GenPhi"
        self.m3GenPhi_branch = the_tree.GetBranch("m3GenPhi")
        #if not self.m3GenPhi_branch and "m3GenPhi" not in self.complained:
        if not self.m3GenPhi_branch and "m3GenPhi":
            warnings.warn( "MuMuMuTree: Expected branch m3GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPhi")
        else:
            self.m3GenPhi_branch.SetAddress(<void*>&self.m3GenPhi_value)

        #print "making m3GenPrompt"
        self.m3GenPrompt_branch = the_tree.GetBranch("m3GenPrompt")
        #if not self.m3GenPrompt_branch and "m3GenPrompt" not in self.complained:
        if not self.m3GenPrompt_branch and "m3GenPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m3GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPrompt")
        else:
            self.m3GenPrompt_branch.SetAddress(<void*>&self.m3GenPrompt_value)

        #print "making m3GenPromptFinalState"
        self.m3GenPromptFinalState_branch = the_tree.GetBranch("m3GenPromptFinalState")
        #if not self.m3GenPromptFinalState_branch and "m3GenPromptFinalState" not in self.complained:
        if not self.m3GenPromptFinalState_branch and "m3GenPromptFinalState":
            warnings.warn( "MuMuMuTree: Expected branch m3GenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPromptFinalState")
        else:
            self.m3GenPromptFinalState_branch.SetAddress(<void*>&self.m3GenPromptFinalState_value)

        #print "making m3GenPromptTauDecay"
        self.m3GenPromptTauDecay_branch = the_tree.GetBranch("m3GenPromptTauDecay")
        #if not self.m3GenPromptTauDecay_branch and "m3GenPromptTauDecay" not in self.complained:
        if not self.m3GenPromptTauDecay_branch and "m3GenPromptTauDecay":
            warnings.warn( "MuMuMuTree: Expected branch m3GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPromptTauDecay")
        else:
            self.m3GenPromptTauDecay_branch.SetAddress(<void*>&self.m3GenPromptTauDecay_value)

        #print "making m3GenPt"
        self.m3GenPt_branch = the_tree.GetBranch("m3GenPt")
        #if not self.m3GenPt_branch and "m3GenPt" not in self.complained:
        if not self.m3GenPt_branch and "m3GenPt":
            warnings.warn( "MuMuMuTree: Expected branch m3GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPt")
        else:
            self.m3GenPt_branch.SetAddress(<void*>&self.m3GenPt_value)

        #print "making m3GenTauDecay"
        self.m3GenTauDecay_branch = the_tree.GetBranch("m3GenTauDecay")
        #if not self.m3GenTauDecay_branch and "m3GenTauDecay" not in self.complained:
        if not self.m3GenTauDecay_branch and "m3GenTauDecay":
            warnings.warn( "MuMuMuTree: Expected branch m3GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenTauDecay")
        else:
            self.m3GenTauDecay_branch.SetAddress(<void*>&self.m3GenTauDecay_value)

        #print "making m3GenVZ"
        self.m3GenVZ_branch = the_tree.GetBranch("m3GenVZ")
        #if not self.m3GenVZ_branch and "m3GenVZ" not in self.complained:
        if not self.m3GenVZ_branch and "m3GenVZ":
            warnings.warn( "MuMuMuTree: Expected branch m3GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenVZ")
        else:
            self.m3GenVZ_branch.SetAddress(<void*>&self.m3GenVZ_value)

        #print "making m3GenVtxPVMatch"
        self.m3GenVtxPVMatch_branch = the_tree.GetBranch("m3GenVtxPVMatch")
        #if not self.m3GenVtxPVMatch_branch and "m3GenVtxPVMatch" not in self.complained:
        if not self.m3GenVtxPVMatch_branch and "m3GenVtxPVMatch":
            warnings.warn( "MuMuMuTree: Expected branch m3GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenVtxPVMatch")
        else:
            self.m3GenVtxPVMatch_branch.SetAddress(<void*>&self.m3GenVtxPVMatch_value)

        #print "making m3HcalIsoDR03"
        self.m3HcalIsoDR03_branch = the_tree.GetBranch("m3HcalIsoDR03")
        #if not self.m3HcalIsoDR03_branch and "m3HcalIsoDR03" not in self.complained:
        if not self.m3HcalIsoDR03_branch and "m3HcalIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m3HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3HcalIsoDR03")
        else:
            self.m3HcalIsoDR03_branch.SetAddress(<void*>&self.m3HcalIsoDR03_value)

        #print "making m3IP3D"
        self.m3IP3D_branch = the_tree.GetBranch("m3IP3D")
        #if not self.m3IP3D_branch and "m3IP3D" not in self.complained:
        if not self.m3IP3D_branch and "m3IP3D":
            warnings.warn( "MuMuMuTree: Expected branch m3IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IP3D")
        else:
            self.m3IP3D_branch.SetAddress(<void*>&self.m3IP3D_value)

        #print "making m3IP3DErr"
        self.m3IP3DErr_branch = the_tree.GetBranch("m3IP3DErr")
        #if not self.m3IP3DErr_branch and "m3IP3DErr" not in self.complained:
        if not self.m3IP3DErr_branch and "m3IP3DErr":
            warnings.warn( "MuMuMuTree: Expected branch m3IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IP3DErr")
        else:
            self.m3IP3DErr_branch.SetAddress(<void*>&self.m3IP3DErr_value)

        #print "making m3IsGlobal"
        self.m3IsGlobal_branch = the_tree.GetBranch("m3IsGlobal")
        #if not self.m3IsGlobal_branch and "m3IsGlobal" not in self.complained:
        if not self.m3IsGlobal_branch and "m3IsGlobal":
            warnings.warn( "MuMuMuTree: Expected branch m3IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsGlobal")
        else:
            self.m3IsGlobal_branch.SetAddress(<void*>&self.m3IsGlobal_value)

        #print "making m3IsPFMuon"
        self.m3IsPFMuon_branch = the_tree.GetBranch("m3IsPFMuon")
        #if not self.m3IsPFMuon_branch and "m3IsPFMuon" not in self.complained:
        if not self.m3IsPFMuon_branch and "m3IsPFMuon":
            warnings.warn( "MuMuMuTree: Expected branch m3IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsPFMuon")
        else:
            self.m3IsPFMuon_branch.SetAddress(<void*>&self.m3IsPFMuon_value)

        #print "making m3IsTracker"
        self.m3IsTracker_branch = the_tree.GetBranch("m3IsTracker")
        #if not self.m3IsTracker_branch and "m3IsTracker" not in self.complained:
        if not self.m3IsTracker_branch and "m3IsTracker":
            warnings.warn( "MuMuMuTree: Expected branch m3IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsTracker")
        else:
            self.m3IsTracker_branch.SetAddress(<void*>&self.m3IsTracker_value)

        #print "making m3IsoDB03"
        self.m3IsoDB03_branch = the_tree.GetBranch("m3IsoDB03")
        #if not self.m3IsoDB03_branch and "m3IsoDB03" not in self.complained:
        if not self.m3IsoDB03_branch and "m3IsoDB03":
            warnings.warn( "MuMuMuTree: Expected branch m3IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsoDB03")
        else:
            self.m3IsoDB03_branch.SetAddress(<void*>&self.m3IsoDB03_value)

        #print "making m3IsoDB04"
        self.m3IsoDB04_branch = the_tree.GetBranch("m3IsoDB04")
        #if not self.m3IsoDB04_branch and "m3IsoDB04" not in self.complained:
        if not self.m3IsoDB04_branch and "m3IsoDB04":
            warnings.warn( "MuMuMuTree: Expected branch m3IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsoDB04")
        else:
            self.m3IsoDB04_branch.SetAddress(<void*>&self.m3IsoDB04_value)

        #print "making m3IsoMu22Filter"
        self.m3IsoMu22Filter_branch = the_tree.GetBranch("m3IsoMu22Filter")
        #if not self.m3IsoMu22Filter_branch and "m3IsoMu22Filter" not in self.complained:
        if not self.m3IsoMu22Filter_branch and "m3IsoMu22Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3IsoMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsoMu22Filter")
        else:
            self.m3IsoMu22Filter_branch.SetAddress(<void*>&self.m3IsoMu22Filter_value)

        #print "making m3IsoMu22eta2p1Filter"
        self.m3IsoMu22eta2p1Filter_branch = the_tree.GetBranch("m3IsoMu22eta2p1Filter")
        #if not self.m3IsoMu22eta2p1Filter_branch and "m3IsoMu22eta2p1Filter" not in self.complained:
        if not self.m3IsoMu22eta2p1Filter_branch and "m3IsoMu22eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3IsoMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsoMu22eta2p1Filter")
        else:
            self.m3IsoMu22eta2p1Filter_branch.SetAddress(<void*>&self.m3IsoMu22eta2p1Filter_value)

        #print "making m3IsoMu24Filter"
        self.m3IsoMu24Filter_branch = the_tree.GetBranch("m3IsoMu24Filter")
        #if not self.m3IsoMu24Filter_branch and "m3IsoMu24Filter" not in self.complained:
        if not self.m3IsoMu24Filter_branch and "m3IsoMu24Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3IsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsoMu24Filter")
        else:
            self.m3IsoMu24Filter_branch.SetAddress(<void*>&self.m3IsoMu24Filter_value)

        #print "making m3IsoMu24eta2p1Filter"
        self.m3IsoMu24eta2p1Filter_branch = the_tree.GetBranch("m3IsoMu24eta2p1Filter")
        #if not self.m3IsoMu24eta2p1Filter_branch and "m3IsoMu24eta2p1Filter" not in self.complained:
        if not self.m3IsoMu24eta2p1Filter_branch and "m3IsoMu24eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3IsoMu24eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsoMu24eta2p1Filter")
        else:
            self.m3IsoMu24eta2p1Filter_branch.SetAddress(<void*>&self.m3IsoMu24eta2p1Filter_value)

        #print "making m3IsoTkMu22Filter"
        self.m3IsoTkMu22Filter_branch = the_tree.GetBranch("m3IsoTkMu22Filter")
        #if not self.m3IsoTkMu22Filter_branch and "m3IsoTkMu22Filter" not in self.complained:
        if not self.m3IsoTkMu22Filter_branch and "m3IsoTkMu22Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3IsoTkMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsoTkMu22Filter")
        else:
            self.m3IsoTkMu22Filter_branch.SetAddress(<void*>&self.m3IsoTkMu22Filter_value)

        #print "making m3IsoTkMu22eta2p1Filter"
        self.m3IsoTkMu22eta2p1Filter_branch = the_tree.GetBranch("m3IsoTkMu22eta2p1Filter")
        #if not self.m3IsoTkMu22eta2p1Filter_branch and "m3IsoTkMu22eta2p1Filter" not in self.complained:
        if not self.m3IsoTkMu22eta2p1Filter_branch and "m3IsoTkMu22eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3IsoTkMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsoTkMu22eta2p1Filter")
        else:
            self.m3IsoTkMu22eta2p1Filter_branch.SetAddress(<void*>&self.m3IsoTkMu22eta2p1Filter_value)

        #print "making m3IsoTkMu24Filter"
        self.m3IsoTkMu24Filter_branch = the_tree.GetBranch("m3IsoTkMu24Filter")
        #if not self.m3IsoTkMu24Filter_branch and "m3IsoTkMu24Filter" not in self.complained:
        if not self.m3IsoTkMu24Filter_branch and "m3IsoTkMu24Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3IsoTkMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsoTkMu24Filter")
        else:
            self.m3IsoTkMu24Filter_branch.SetAddress(<void*>&self.m3IsoTkMu24Filter_value)

        #print "making m3IsoTkMu24eta2p1Filter"
        self.m3IsoTkMu24eta2p1Filter_branch = the_tree.GetBranch("m3IsoTkMu24eta2p1Filter")
        #if not self.m3IsoTkMu24eta2p1Filter_branch and "m3IsoTkMu24eta2p1Filter" not in self.complained:
        if not self.m3IsoTkMu24eta2p1Filter_branch and "m3IsoTkMu24eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3IsoTkMu24eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsoTkMu24eta2p1Filter")
        else:
            self.m3IsoTkMu24eta2p1Filter_branch.SetAddress(<void*>&self.m3IsoTkMu24eta2p1Filter_value)

        #print "making m3JetArea"
        self.m3JetArea_branch = the_tree.GetBranch("m3JetArea")
        #if not self.m3JetArea_branch and "m3JetArea" not in self.complained:
        if not self.m3JetArea_branch and "m3JetArea":
            warnings.warn( "MuMuMuTree: Expected branch m3JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetArea")
        else:
            self.m3JetArea_branch.SetAddress(<void*>&self.m3JetArea_value)

        #print "making m3JetBtag"
        self.m3JetBtag_branch = the_tree.GetBranch("m3JetBtag")
        #if not self.m3JetBtag_branch and "m3JetBtag" not in self.complained:
        if not self.m3JetBtag_branch and "m3JetBtag":
            warnings.warn( "MuMuMuTree: Expected branch m3JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetBtag")
        else:
            self.m3JetBtag_branch.SetAddress(<void*>&self.m3JetBtag_value)

        #print "making m3JetEtaEtaMoment"
        self.m3JetEtaEtaMoment_branch = the_tree.GetBranch("m3JetEtaEtaMoment")
        #if not self.m3JetEtaEtaMoment_branch and "m3JetEtaEtaMoment" not in self.complained:
        if not self.m3JetEtaEtaMoment_branch and "m3JetEtaEtaMoment":
            warnings.warn( "MuMuMuTree: Expected branch m3JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetEtaEtaMoment")
        else:
            self.m3JetEtaEtaMoment_branch.SetAddress(<void*>&self.m3JetEtaEtaMoment_value)

        #print "making m3JetEtaPhiMoment"
        self.m3JetEtaPhiMoment_branch = the_tree.GetBranch("m3JetEtaPhiMoment")
        #if not self.m3JetEtaPhiMoment_branch and "m3JetEtaPhiMoment" not in self.complained:
        if not self.m3JetEtaPhiMoment_branch and "m3JetEtaPhiMoment":
            warnings.warn( "MuMuMuTree: Expected branch m3JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetEtaPhiMoment")
        else:
            self.m3JetEtaPhiMoment_branch.SetAddress(<void*>&self.m3JetEtaPhiMoment_value)

        #print "making m3JetEtaPhiSpread"
        self.m3JetEtaPhiSpread_branch = the_tree.GetBranch("m3JetEtaPhiSpread")
        #if not self.m3JetEtaPhiSpread_branch and "m3JetEtaPhiSpread" not in self.complained:
        if not self.m3JetEtaPhiSpread_branch and "m3JetEtaPhiSpread":
            warnings.warn( "MuMuMuTree: Expected branch m3JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetEtaPhiSpread")
        else:
            self.m3JetEtaPhiSpread_branch.SetAddress(<void*>&self.m3JetEtaPhiSpread_value)

        #print "making m3JetHadronFlavour"
        self.m3JetHadronFlavour_branch = the_tree.GetBranch("m3JetHadronFlavour")
        #if not self.m3JetHadronFlavour_branch and "m3JetHadronFlavour" not in self.complained:
        if not self.m3JetHadronFlavour_branch and "m3JetHadronFlavour":
            warnings.warn( "MuMuMuTree: Expected branch m3JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetHadronFlavour")
        else:
            self.m3JetHadronFlavour_branch.SetAddress(<void*>&self.m3JetHadronFlavour_value)

        #print "making m3JetPFCISVBtag"
        self.m3JetPFCISVBtag_branch = the_tree.GetBranch("m3JetPFCISVBtag")
        #if not self.m3JetPFCISVBtag_branch and "m3JetPFCISVBtag" not in self.complained:
        if not self.m3JetPFCISVBtag_branch and "m3JetPFCISVBtag":
            warnings.warn( "MuMuMuTree: Expected branch m3JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPFCISVBtag")
        else:
            self.m3JetPFCISVBtag_branch.SetAddress(<void*>&self.m3JetPFCISVBtag_value)

        #print "making m3JetPartonFlavour"
        self.m3JetPartonFlavour_branch = the_tree.GetBranch("m3JetPartonFlavour")
        #if not self.m3JetPartonFlavour_branch and "m3JetPartonFlavour" not in self.complained:
        if not self.m3JetPartonFlavour_branch and "m3JetPartonFlavour":
            warnings.warn( "MuMuMuTree: Expected branch m3JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPartonFlavour")
        else:
            self.m3JetPartonFlavour_branch.SetAddress(<void*>&self.m3JetPartonFlavour_value)

        #print "making m3JetPhiPhiMoment"
        self.m3JetPhiPhiMoment_branch = the_tree.GetBranch("m3JetPhiPhiMoment")
        #if not self.m3JetPhiPhiMoment_branch and "m3JetPhiPhiMoment" not in self.complained:
        if not self.m3JetPhiPhiMoment_branch and "m3JetPhiPhiMoment":
            warnings.warn( "MuMuMuTree: Expected branch m3JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPhiPhiMoment")
        else:
            self.m3JetPhiPhiMoment_branch.SetAddress(<void*>&self.m3JetPhiPhiMoment_value)

        #print "making m3JetPt"
        self.m3JetPt_branch = the_tree.GetBranch("m3JetPt")
        #if not self.m3JetPt_branch and "m3JetPt" not in self.complained:
        if not self.m3JetPt_branch and "m3JetPt":
            warnings.warn( "MuMuMuTree: Expected branch m3JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPt")
        else:
            self.m3JetPt_branch.SetAddress(<void*>&self.m3JetPt_value)

        #print "making m3LowestMll"
        self.m3LowestMll_branch = the_tree.GetBranch("m3LowestMll")
        #if not self.m3LowestMll_branch and "m3LowestMll" not in self.complained:
        if not self.m3LowestMll_branch and "m3LowestMll":
            warnings.warn( "MuMuMuTree: Expected branch m3LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3LowestMll")
        else:
            self.m3LowestMll_branch.SetAddress(<void*>&self.m3LowestMll_value)

        #print "making m3Mass"
        self.m3Mass_branch = the_tree.GetBranch("m3Mass")
        #if not self.m3Mass_branch and "m3Mass" not in self.complained:
        if not self.m3Mass_branch and "m3Mass":
            warnings.warn( "MuMuMuTree: Expected branch m3Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Mass")
        else:
            self.m3Mass_branch.SetAddress(<void*>&self.m3Mass_value)

        #print "making m3MatchedStations"
        self.m3MatchedStations_branch = the_tree.GetBranch("m3MatchedStations")
        #if not self.m3MatchedStations_branch and "m3MatchedStations" not in self.complained:
        if not self.m3MatchedStations_branch and "m3MatchedStations":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchedStations")
        else:
            self.m3MatchedStations_branch.SetAddress(<void*>&self.m3MatchedStations_value)

        #print "making m3MatchesDoubleESingleMu"
        self.m3MatchesDoubleESingleMu_branch = the_tree.GetBranch("m3MatchesDoubleESingleMu")
        #if not self.m3MatchesDoubleESingleMu_branch and "m3MatchesDoubleESingleMu" not in self.complained:
        if not self.m3MatchesDoubleESingleMu_branch and "m3MatchesDoubleESingleMu":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesDoubleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesDoubleESingleMu")
        else:
            self.m3MatchesDoubleESingleMu_branch.SetAddress(<void*>&self.m3MatchesDoubleESingleMu_value)

        #print "making m3MatchesDoubleMu"
        self.m3MatchesDoubleMu_branch = the_tree.GetBranch("m3MatchesDoubleMu")
        #if not self.m3MatchesDoubleMu_branch and "m3MatchesDoubleMu" not in self.complained:
        if not self.m3MatchesDoubleMu_branch and "m3MatchesDoubleMu":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesDoubleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesDoubleMu")
        else:
            self.m3MatchesDoubleMu_branch.SetAddress(<void*>&self.m3MatchesDoubleMu_value)

        #print "making m3MatchesDoubleMuSingleE"
        self.m3MatchesDoubleMuSingleE_branch = the_tree.GetBranch("m3MatchesDoubleMuSingleE")
        #if not self.m3MatchesDoubleMuSingleE_branch and "m3MatchesDoubleMuSingleE" not in self.complained:
        if not self.m3MatchesDoubleMuSingleE_branch and "m3MatchesDoubleMuSingleE":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesDoubleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesDoubleMuSingleE")
        else:
            self.m3MatchesDoubleMuSingleE_branch.SetAddress(<void*>&self.m3MatchesDoubleMuSingleE_value)

        #print "making m3MatchesIsoMu22Path"
        self.m3MatchesIsoMu22Path_branch = the_tree.GetBranch("m3MatchesIsoMu22Path")
        #if not self.m3MatchesIsoMu22Path_branch and "m3MatchesIsoMu22Path" not in self.complained:
        if not self.m3MatchesIsoMu22Path_branch and "m3MatchesIsoMu22Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu22Path")
        else:
            self.m3MatchesIsoMu22Path_branch.SetAddress(<void*>&self.m3MatchesIsoMu22Path_value)

        #print "making m3MatchesIsoMu22eta2p1Path"
        self.m3MatchesIsoMu22eta2p1Path_branch = the_tree.GetBranch("m3MatchesIsoMu22eta2p1Path")
        #if not self.m3MatchesIsoMu22eta2p1Path_branch and "m3MatchesIsoMu22eta2p1Path" not in self.complained:
        if not self.m3MatchesIsoMu22eta2p1Path_branch and "m3MatchesIsoMu22eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu22eta2p1Path")
        else:
            self.m3MatchesIsoMu22eta2p1Path_branch.SetAddress(<void*>&self.m3MatchesIsoMu22eta2p1Path_value)

        #print "making m3MatchesIsoMu24Path"
        self.m3MatchesIsoMu24Path_branch = the_tree.GetBranch("m3MatchesIsoMu24Path")
        #if not self.m3MatchesIsoMu24Path_branch and "m3MatchesIsoMu24Path" not in self.complained:
        if not self.m3MatchesIsoMu24Path_branch and "m3MatchesIsoMu24Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu24Path")
        else:
            self.m3MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m3MatchesIsoMu24Path_value)

        #print "making m3MatchesIsoMu24eta2p1Path"
        self.m3MatchesIsoMu24eta2p1Path_branch = the_tree.GetBranch("m3MatchesIsoMu24eta2p1Path")
        #if not self.m3MatchesIsoMu24eta2p1Path_branch and "m3MatchesIsoMu24eta2p1Path" not in self.complained:
        if not self.m3MatchesIsoMu24eta2p1Path_branch and "m3MatchesIsoMu24eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu24eta2p1Path")
        else:
            self.m3MatchesIsoMu24eta2p1Path_branch.SetAddress(<void*>&self.m3MatchesIsoMu24eta2p1Path_value)

        #print "making m3MatchesIsoTkMu22Path"
        self.m3MatchesIsoTkMu22Path_branch = the_tree.GetBranch("m3MatchesIsoTkMu22Path")
        #if not self.m3MatchesIsoTkMu22Path_branch and "m3MatchesIsoTkMu22Path" not in self.complained:
        if not self.m3MatchesIsoTkMu22Path_branch and "m3MatchesIsoTkMu22Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoTkMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoTkMu22Path")
        else:
            self.m3MatchesIsoTkMu22Path_branch.SetAddress(<void*>&self.m3MatchesIsoTkMu22Path_value)

        #print "making m3MatchesIsoTkMu22eta2p1Path"
        self.m3MatchesIsoTkMu22eta2p1Path_branch = the_tree.GetBranch("m3MatchesIsoTkMu22eta2p1Path")
        #if not self.m3MatchesIsoTkMu22eta2p1Path_branch and "m3MatchesIsoTkMu22eta2p1Path" not in self.complained:
        if not self.m3MatchesIsoTkMu22eta2p1Path_branch and "m3MatchesIsoTkMu22eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoTkMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoTkMu22eta2p1Path")
        else:
            self.m3MatchesIsoTkMu22eta2p1Path_branch.SetAddress(<void*>&self.m3MatchesIsoTkMu22eta2p1Path_value)

        #print "making m3MatchesIsoTkMu24Path"
        self.m3MatchesIsoTkMu24Path_branch = the_tree.GetBranch("m3MatchesIsoTkMu24Path")
        #if not self.m3MatchesIsoTkMu24Path_branch and "m3MatchesIsoTkMu24Path" not in self.complained:
        if not self.m3MatchesIsoTkMu24Path_branch and "m3MatchesIsoTkMu24Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoTkMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoTkMu24Path")
        else:
            self.m3MatchesIsoTkMu24Path_branch.SetAddress(<void*>&self.m3MatchesIsoTkMu24Path_value)

        #print "making m3MatchesIsoTkMu24eta2p1Path"
        self.m3MatchesIsoTkMu24eta2p1Path_branch = the_tree.GetBranch("m3MatchesIsoTkMu24eta2p1Path")
        #if not self.m3MatchesIsoTkMu24eta2p1Path_branch and "m3MatchesIsoTkMu24eta2p1Path" not in self.complained:
        if not self.m3MatchesIsoTkMu24eta2p1Path_branch and "m3MatchesIsoTkMu24eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoTkMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoTkMu24eta2p1Path")
        else:
            self.m3MatchesIsoTkMu24eta2p1Path_branch.SetAddress(<void*>&self.m3MatchesIsoTkMu24eta2p1Path_value)

        #print "making m3MatchesMu19Tau20Filter"
        self.m3MatchesMu19Tau20Filter_branch = the_tree.GetBranch("m3MatchesMu19Tau20Filter")
        #if not self.m3MatchesMu19Tau20Filter_branch and "m3MatchesMu19Tau20Filter" not in self.complained:
        if not self.m3MatchesMu19Tau20Filter_branch and "m3MatchesMu19Tau20Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu19Tau20Filter")
        else:
            self.m3MatchesMu19Tau20Filter_branch.SetAddress(<void*>&self.m3MatchesMu19Tau20Filter_value)

        #print "making m3MatchesMu19Tau20Path"
        self.m3MatchesMu19Tau20Path_branch = the_tree.GetBranch("m3MatchesMu19Tau20Path")
        #if not self.m3MatchesMu19Tau20Path_branch and "m3MatchesMu19Tau20Path" not in self.complained:
        if not self.m3MatchesMu19Tau20Path_branch and "m3MatchesMu19Tau20Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu19Tau20Path")
        else:
            self.m3MatchesMu19Tau20Path_branch.SetAddress(<void*>&self.m3MatchesMu19Tau20Path_value)

        #print "making m3MatchesMu19Tau20sL1Filter"
        self.m3MatchesMu19Tau20sL1Filter_branch = the_tree.GetBranch("m3MatchesMu19Tau20sL1Filter")
        #if not self.m3MatchesMu19Tau20sL1Filter_branch and "m3MatchesMu19Tau20sL1Filter" not in self.complained:
        if not self.m3MatchesMu19Tau20sL1Filter_branch and "m3MatchesMu19Tau20sL1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesMu19Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu19Tau20sL1Filter")
        else:
            self.m3MatchesMu19Tau20sL1Filter_branch.SetAddress(<void*>&self.m3MatchesMu19Tau20sL1Filter_value)

        #print "making m3MatchesMu19Tau20sL1Path"
        self.m3MatchesMu19Tau20sL1Path_branch = the_tree.GetBranch("m3MatchesMu19Tau20sL1Path")
        #if not self.m3MatchesMu19Tau20sL1Path_branch and "m3MatchesMu19Tau20sL1Path" not in self.complained:
        if not self.m3MatchesMu19Tau20sL1Path_branch and "m3MatchesMu19Tau20sL1Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesMu19Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu19Tau20sL1Path")
        else:
            self.m3MatchesMu19Tau20sL1Path_branch.SetAddress(<void*>&self.m3MatchesMu19Tau20sL1Path_value)

        #print "making m3MatchesMu23Ele12Path"
        self.m3MatchesMu23Ele12Path_branch = the_tree.GetBranch("m3MatchesMu23Ele12Path")
        #if not self.m3MatchesMu23Ele12Path_branch and "m3MatchesMu23Ele12Path" not in self.complained:
        if not self.m3MatchesMu23Ele12Path_branch and "m3MatchesMu23Ele12Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesMu23Ele12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu23Ele12Path")
        else:
            self.m3MatchesMu23Ele12Path_branch.SetAddress(<void*>&self.m3MatchesMu23Ele12Path_value)

        #print "making m3MatchesMu8Ele23Path"
        self.m3MatchesMu8Ele23Path_branch = the_tree.GetBranch("m3MatchesMu8Ele23Path")
        #if not self.m3MatchesMu8Ele23Path_branch and "m3MatchesMu8Ele23Path" not in self.complained:
        if not self.m3MatchesMu8Ele23Path_branch and "m3MatchesMu8Ele23Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesMu8Ele23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu8Ele23Path")
        else:
            self.m3MatchesMu8Ele23Path_branch.SetAddress(<void*>&self.m3MatchesMu8Ele23Path_value)

        #print "making m3MatchesSingleESingleMu"
        self.m3MatchesSingleESingleMu_branch = the_tree.GetBranch("m3MatchesSingleESingleMu")
        #if not self.m3MatchesSingleESingleMu_branch and "m3MatchesSingleESingleMu" not in self.complained:
        if not self.m3MatchesSingleESingleMu_branch and "m3MatchesSingleESingleMu":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesSingleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesSingleESingleMu")
        else:
            self.m3MatchesSingleESingleMu_branch.SetAddress(<void*>&self.m3MatchesSingleESingleMu_value)

        #print "making m3MatchesSingleMu"
        self.m3MatchesSingleMu_branch = the_tree.GetBranch("m3MatchesSingleMu")
        #if not self.m3MatchesSingleMu_branch and "m3MatchesSingleMu" not in self.complained:
        if not self.m3MatchesSingleMu_branch and "m3MatchesSingleMu":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesSingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesSingleMu")
        else:
            self.m3MatchesSingleMu_branch.SetAddress(<void*>&self.m3MatchesSingleMu_value)

        #print "making m3MatchesSingleMuIso20"
        self.m3MatchesSingleMuIso20_branch = the_tree.GetBranch("m3MatchesSingleMuIso20")
        #if not self.m3MatchesSingleMuIso20_branch and "m3MatchesSingleMuIso20" not in self.complained:
        if not self.m3MatchesSingleMuIso20_branch and "m3MatchesSingleMuIso20":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesSingleMuIso20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesSingleMuIso20")
        else:
            self.m3MatchesSingleMuIso20_branch.SetAddress(<void*>&self.m3MatchesSingleMuIso20_value)

        #print "making m3MatchesSingleMuIsoTk20"
        self.m3MatchesSingleMuIsoTk20_branch = the_tree.GetBranch("m3MatchesSingleMuIsoTk20")
        #if not self.m3MatchesSingleMuIsoTk20_branch and "m3MatchesSingleMuIsoTk20" not in self.complained:
        if not self.m3MatchesSingleMuIsoTk20_branch and "m3MatchesSingleMuIsoTk20":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesSingleMuIsoTk20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesSingleMuIsoTk20")
        else:
            self.m3MatchesSingleMuIsoTk20_branch.SetAddress(<void*>&self.m3MatchesSingleMuIsoTk20_value)

        #print "making m3MatchesSingleMuSingleE"
        self.m3MatchesSingleMuSingleE_branch = the_tree.GetBranch("m3MatchesSingleMuSingleE")
        #if not self.m3MatchesSingleMuSingleE_branch and "m3MatchesSingleMuSingleE" not in self.complained:
        if not self.m3MatchesSingleMuSingleE_branch and "m3MatchesSingleMuSingleE":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesSingleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesSingleMuSingleE")
        else:
            self.m3MatchesSingleMuSingleE_branch.SetAddress(<void*>&self.m3MatchesSingleMuSingleE_value)

        #print "making m3MatchesSingleMu_leg1"
        self.m3MatchesSingleMu_leg1_branch = the_tree.GetBranch("m3MatchesSingleMu_leg1")
        #if not self.m3MatchesSingleMu_leg1_branch and "m3MatchesSingleMu_leg1" not in self.complained:
        if not self.m3MatchesSingleMu_leg1_branch and "m3MatchesSingleMu_leg1":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesSingleMu_leg1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesSingleMu_leg1")
        else:
            self.m3MatchesSingleMu_leg1_branch.SetAddress(<void*>&self.m3MatchesSingleMu_leg1_value)

        #print "making m3MatchesSingleMu_leg1_noiso"
        self.m3MatchesSingleMu_leg1_noiso_branch = the_tree.GetBranch("m3MatchesSingleMu_leg1_noiso")
        #if not self.m3MatchesSingleMu_leg1_noiso_branch and "m3MatchesSingleMu_leg1_noiso" not in self.complained:
        if not self.m3MatchesSingleMu_leg1_noiso_branch and "m3MatchesSingleMu_leg1_noiso":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesSingleMu_leg1_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesSingleMu_leg1_noiso")
        else:
            self.m3MatchesSingleMu_leg1_noiso_branch.SetAddress(<void*>&self.m3MatchesSingleMu_leg1_noiso_value)

        #print "making m3MatchesSingleMu_leg2"
        self.m3MatchesSingleMu_leg2_branch = the_tree.GetBranch("m3MatchesSingleMu_leg2")
        #if not self.m3MatchesSingleMu_leg2_branch and "m3MatchesSingleMu_leg2" not in self.complained:
        if not self.m3MatchesSingleMu_leg2_branch and "m3MatchesSingleMu_leg2":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesSingleMu_leg2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesSingleMu_leg2")
        else:
            self.m3MatchesSingleMu_leg2_branch.SetAddress(<void*>&self.m3MatchesSingleMu_leg2_value)

        #print "making m3MatchesSingleMu_leg2_noiso"
        self.m3MatchesSingleMu_leg2_noiso_branch = the_tree.GetBranch("m3MatchesSingleMu_leg2_noiso")
        #if not self.m3MatchesSingleMu_leg2_noiso_branch and "m3MatchesSingleMu_leg2_noiso" not in self.complained:
        if not self.m3MatchesSingleMu_leg2_noiso_branch and "m3MatchesSingleMu_leg2_noiso":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesSingleMu_leg2_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesSingleMu_leg2_noiso")
        else:
            self.m3MatchesSingleMu_leg2_noiso_branch.SetAddress(<void*>&self.m3MatchesSingleMu_leg2_noiso_value)

        #print "making m3MatchesTripleMu"
        self.m3MatchesTripleMu_branch = the_tree.GetBranch("m3MatchesTripleMu")
        #if not self.m3MatchesTripleMu_branch and "m3MatchesTripleMu" not in self.complained:
        if not self.m3MatchesTripleMu_branch and "m3MatchesTripleMu":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesTripleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesTripleMu")
        else:
            self.m3MatchesTripleMu_branch.SetAddress(<void*>&self.m3MatchesTripleMu_value)

        #print "making m3MtToPfMet_ElectronEnDown"
        self.m3MtToPfMet_ElectronEnDown_branch = the_tree.GetBranch("m3MtToPfMet_ElectronEnDown")
        #if not self.m3MtToPfMet_ElectronEnDown_branch and "m3MtToPfMet_ElectronEnDown" not in self.complained:
        if not self.m3MtToPfMet_ElectronEnDown_branch and "m3MtToPfMet_ElectronEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_ElectronEnDown")
        else:
            self.m3MtToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.m3MtToPfMet_ElectronEnDown_value)

        #print "making m3MtToPfMet_ElectronEnUp"
        self.m3MtToPfMet_ElectronEnUp_branch = the_tree.GetBranch("m3MtToPfMet_ElectronEnUp")
        #if not self.m3MtToPfMet_ElectronEnUp_branch and "m3MtToPfMet_ElectronEnUp" not in self.complained:
        if not self.m3MtToPfMet_ElectronEnUp_branch and "m3MtToPfMet_ElectronEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_ElectronEnUp")
        else:
            self.m3MtToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.m3MtToPfMet_ElectronEnUp_value)

        #print "making m3MtToPfMet_JetEnDown"
        self.m3MtToPfMet_JetEnDown_branch = the_tree.GetBranch("m3MtToPfMet_JetEnDown")
        #if not self.m3MtToPfMet_JetEnDown_branch and "m3MtToPfMet_JetEnDown" not in self.complained:
        if not self.m3MtToPfMet_JetEnDown_branch and "m3MtToPfMet_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_JetEnDown")
        else:
            self.m3MtToPfMet_JetEnDown_branch.SetAddress(<void*>&self.m3MtToPfMet_JetEnDown_value)

        #print "making m3MtToPfMet_JetEnUp"
        self.m3MtToPfMet_JetEnUp_branch = the_tree.GetBranch("m3MtToPfMet_JetEnUp")
        #if not self.m3MtToPfMet_JetEnUp_branch and "m3MtToPfMet_JetEnUp" not in self.complained:
        if not self.m3MtToPfMet_JetEnUp_branch and "m3MtToPfMet_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_JetEnUp")
        else:
            self.m3MtToPfMet_JetEnUp_branch.SetAddress(<void*>&self.m3MtToPfMet_JetEnUp_value)

        #print "making m3MtToPfMet_JetResDown"
        self.m3MtToPfMet_JetResDown_branch = the_tree.GetBranch("m3MtToPfMet_JetResDown")
        #if not self.m3MtToPfMet_JetResDown_branch and "m3MtToPfMet_JetResDown" not in self.complained:
        if not self.m3MtToPfMet_JetResDown_branch and "m3MtToPfMet_JetResDown":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_JetResDown")
        else:
            self.m3MtToPfMet_JetResDown_branch.SetAddress(<void*>&self.m3MtToPfMet_JetResDown_value)

        #print "making m3MtToPfMet_JetResUp"
        self.m3MtToPfMet_JetResUp_branch = the_tree.GetBranch("m3MtToPfMet_JetResUp")
        #if not self.m3MtToPfMet_JetResUp_branch and "m3MtToPfMet_JetResUp" not in self.complained:
        if not self.m3MtToPfMet_JetResUp_branch and "m3MtToPfMet_JetResUp":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_JetResUp")
        else:
            self.m3MtToPfMet_JetResUp_branch.SetAddress(<void*>&self.m3MtToPfMet_JetResUp_value)

        #print "making m3MtToPfMet_MuonEnDown"
        self.m3MtToPfMet_MuonEnDown_branch = the_tree.GetBranch("m3MtToPfMet_MuonEnDown")
        #if not self.m3MtToPfMet_MuonEnDown_branch and "m3MtToPfMet_MuonEnDown" not in self.complained:
        if not self.m3MtToPfMet_MuonEnDown_branch and "m3MtToPfMet_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_MuonEnDown")
        else:
            self.m3MtToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.m3MtToPfMet_MuonEnDown_value)

        #print "making m3MtToPfMet_MuonEnUp"
        self.m3MtToPfMet_MuonEnUp_branch = the_tree.GetBranch("m3MtToPfMet_MuonEnUp")
        #if not self.m3MtToPfMet_MuonEnUp_branch and "m3MtToPfMet_MuonEnUp" not in self.complained:
        if not self.m3MtToPfMet_MuonEnUp_branch and "m3MtToPfMet_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_MuonEnUp")
        else:
            self.m3MtToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.m3MtToPfMet_MuonEnUp_value)

        #print "making m3MtToPfMet_PhotonEnDown"
        self.m3MtToPfMet_PhotonEnDown_branch = the_tree.GetBranch("m3MtToPfMet_PhotonEnDown")
        #if not self.m3MtToPfMet_PhotonEnDown_branch and "m3MtToPfMet_PhotonEnDown" not in self.complained:
        if not self.m3MtToPfMet_PhotonEnDown_branch and "m3MtToPfMet_PhotonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_PhotonEnDown")
        else:
            self.m3MtToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.m3MtToPfMet_PhotonEnDown_value)

        #print "making m3MtToPfMet_PhotonEnUp"
        self.m3MtToPfMet_PhotonEnUp_branch = the_tree.GetBranch("m3MtToPfMet_PhotonEnUp")
        #if not self.m3MtToPfMet_PhotonEnUp_branch and "m3MtToPfMet_PhotonEnUp" not in self.complained:
        if not self.m3MtToPfMet_PhotonEnUp_branch and "m3MtToPfMet_PhotonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_PhotonEnUp")
        else:
            self.m3MtToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.m3MtToPfMet_PhotonEnUp_value)

        #print "making m3MtToPfMet_Raw"
        self.m3MtToPfMet_Raw_branch = the_tree.GetBranch("m3MtToPfMet_Raw")
        #if not self.m3MtToPfMet_Raw_branch and "m3MtToPfMet_Raw" not in self.complained:
        if not self.m3MtToPfMet_Raw_branch and "m3MtToPfMet_Raw":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_Raw")
        else:
            self.m3MtToPfMet_Raw_branch.SetAddress(<void*>&self.m3MtToPfMet_Raw_value)

        #print "making m3MtToPfMet_TauEnDown"
        self.m3MtToPfMet_TauEnDown_branch = the_tree.GetBranch("m3MtToPfMet_TauEnDown")
        #if not self.m3MtToPfMet_TauEnDown_branch and "m3MtToPfMet_TauEnDown" not in self.complained:
        if not self.m3MtToPfMet_TauEnDown_branch and "m3MtToPfMet_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_TauEnDown")
        else:
            self.m3MtToPfMet_TauEnDown_branch.SetAddress(<void*>&self.m3MtToPfMet_TauEnDown_value)

        #print "making m3MtToPfMet_TauEnUp"
        self.m3MtToPfMet_TauEnUp_branch = the_tree.GetBranch("m3MtToPfMet_TauEnUp")
        #if not self.m3MtToPfMet_TauEnUp_branch and "m3MtToPfMet_TauEnUp" not in self.complained:
        if not self.m3MtToPfMet_TauEnUp_branch and "m3MtToPfMet_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_TauEnUp")
        else:
            self.m3MtToPfMet_TauEnUp_branch.SetAddress(<void*>&self.m3MtToPfMet_TauEnUp_value)

        #print "making m3MtToPfMet_UnclusteredEnDown"
        self.m3MtToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("m3MtToPfMet_UnclusteredEnDown")
        #if not self.m3MtToPfMet_UnclusteredEnDown_branch and "m3MtToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.m3MtToPfMet_UnclusteredEnDown_branch and "m3MtToPfMet_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_UnclusteredEnDown")
        else:
            self.m3MtToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.m3MtToPfMet_UnclusteredEnDown_value)

        #print "making m3MtToPfMet_UnclusteredEnUp"
        self.m3MtToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("m3MtToPfMet_UnclusteredEnUp")
        #if not self.m3MtToPfMet_UnclusteredEnUp_branch and "m3MtToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.m3MtToPfMet_UnclusteredEnUp_branch and "m3MtToPfMet_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_UnclusteredEnUp")
        else:
            self.m3MtToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.m3MtToPfMet_UnclusteredEnUp_value)

        #print "making m3MtToPfMet_type1"
        self.m3MtToPfMet_type1_branch = the_tree.GetBranch("m3MtToPfMet_type1")
        #if not self.m3MtToPfMet_type1_branch and "m3MtToPfMet_type1" not in self.complained:
        if not self.m3MtToPfMet_type1_branch and "m3MtToPfMet_type1":
            warnings.warn( "MuMuMuTree: Expected branch m3MtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_type1")
        else:
            self.m3MtToPfMet_type1_branch.SetAddress(<void*>&self.m3MtToPfMet_type1_value)

        #print "making m3Mu23Ele12Filter"
        self.m3Mu23Ele12Filter_branch = the_tree.GetBranch("m3Mu23Ele12Filter")
        #if not self.m3Mu23Ele12Filter_branch and "m3Mu23Ele12Filter" not in self.complained:
        if not self.m3Mu23Ele12Filter_branch and "m3Mu23Ele12Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3Mu23Ele12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Mu23Ele12Filter")
        else:
            self.m3Mu23Ele12Filter_branch.SetAddress(<void*>&self.m3Mu23Ele12Filter_value)

        #print "making m3Mu8Ele23Filter"
        self.m3Mu8Ele23Filter_branch = the_tree.GetBranch("m3Mu8Ele23Filter")
        #if not self.m3Mu8Ele23Filter_branch and "m3Mu8Ele23Filter" not in self.complained:
        if not self.m3Mu8Ele23Filter_branch and "m3Mu8Ele23Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3Mu8Ele23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Mu8Ele23Filter")
        else:
            self.m3Mu8Ele23Filter_branch.SetAddress(<void*>&self.m3Mu8Ele23Filter_value)

        #print "making m3MuonHits"
        self.m3MuonHits_branch = the_tree.GetBranch("m3MuonHits")
        #if not self.m3MuonHits_branch and "m3MuonHits" not in self.complained:
        if not self.m3MuonHits_branch and "m3MuonHits":
            warnings.warn( "MuMuMuTree: Expected branch m3MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MuonHits")
        else:
            self.m3MuonHits_branch.SetAddress(<void*>&self.m3MuonHits_value)

        #print "making m3NearestZMass"
        self.m3NearestZMass_branch = the_tree.GetBranch("m3NearestZMass")
        #if not self.m3NearestZMass_branch and "m3NearestZMass" not in self.complained:
        if not self.m3NearestZMass_branch and "m3NearestZMass":
            warnings.warn( "MuMuMuTree: Expected branch m3NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3NearestZMass")
        else:
            self.m3NearestZMass_branch.SetAddress(<void*>&self.m3NearestZMass_value)

        #print "making m3NormTrkChi2"
        self.m3NormTrkChi2_branch = the_tree.GetBranch("m3NormTrkChi2")
        #if not self.m3NormTrkChi2_branch and "m3NormTrkChi2" not in self.complained:
        if not self.m3NormTrkChi2_branch and "m3NormTrkChi2":
            warnings.warn( "MuMuMuTree: Expected branch m3NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3NormTrkChi2")
        else:
            self.m3NormTrkChi2_branch.SetAddress(<void*>&self.m3NormTrkChi2_value)

        #print "making m3NormalizedChi2"
        self.m3NormalizedChi2_branch = the_tree.GetBranch("m3NormalizedChi2")
        #if not self.m3NormalizedChi2_branch and "m3NormalizedChi2" not in self.complained:
        if not self.m3NormalizedChi2_branch and "m3NormalizedChi2":
            warnings.warn( "MuMuMuTree: Expected branch m3NormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3NormalizedChi2")
        else:
            self.m3NormalizedChi2_branch.SetAddress(<void*>&self.m3NormalizedChi2_value)

        #print "making m3PFChargedHadronIsoR04"
        self.m3PFChargedHadronIsoR04_branch = the_tree.GetBranch("m3PFChargedHadronIsoR04")
        #if not self.m3PFChargedHadronIsoR04_branch and "m3PFChargedHadronIsoR04" not in self.complained:
        if not self.m3PFChargedHadronIsoR04_branch and "m3PFChargedHadronIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m3PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFChargedHadronIsoR04")
        else:
            self.m3PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m3PFChargedHadronIsoR04_value)

        #print "making m3PFChargedIso"
        self.m3PFChargedIso_branch = the_tree.GetBranch("m3PFChargedIso")
        #if not self.m3PFChargedIso_branch and "m3PFChargedIso" not in self.complained:
        if not self.m3PFChargedIso_branch and "m3PFChargedIso":
            warnings.warn( "MuMuMuTree: Expected branch m3PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFChargedIso")
        else:
            self.m3PFChargedIso_branch.SetAddress(<void*>&self.m3PFChargedIso_value)

        #print "making m3PFIDLoose"
        self.m3PFIDLoose_branch = the_tree.GetBranch("m3PFIDLoose")
        #if not self.m3PFIDLoose_branch and "m3PFIDLoose" not in self.complained:
        if not self.m3PFIDLoose_branch and "m3PFIDLoose":
            warnings.warn( "MuMuMuTree: Expected branch m3PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIDLoose")
        else:
            self.m3PFIDLoose_branch.SetAddress(<void*>&self.m3PFIDLoose_value)

        #print "making m3PFIDMedium"
        self.m3PFIDMedium_branch = the_tree.GetBranch("m3PFIDMedium")
        #if not self.m3PFIDMedium_branch and "m3PFIDMedium" not in self.complained:
        if not self.m3PFIDMedium_branch and "m3PFIDMedium":
            warnings.warn( "MuMuMuTree: Expected branch m3PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIDMedium")
        else:
            self.m3PFIDMedium_branch.SetAddress(<void*>&self.m3PFIDMedium_value)

        #print "making m3PFIDTight"
        self.m3PFIDTight_branch = the_tree.GetBranch("m3PFIDTight")
        #if not self.m3PFIDTight_branch and "m3PFIDTight" not in self.complained:
        if not self.m3PFIDTight_branch and "m3PFIDTight":
            warnings.warn( "MuMuMuTree: Expected branch m3PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIDTight")
        else:
            self.m3PFIDTight_branch.SetAddress(<void*>&self.m3PFIDTight_value)

        #print "making m3PFNeutralHadronIsoR04"
        self.m3PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m3PFNeutralHadronIsoR04")
        #if not self.m3PFNeutralHadronIsoR04_branch and "m3PFNeutralHadronIsoR04" not in self.complained:
        if not self.m3PFNeutralHadronIsoR04_branch and "m3PFNeutralHadronIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m3PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFNeutralHadronIsoR04")
        else:
            self.m3PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m3PFNeutralHadronIsoR04_value)

        #print "making m3PFNeutralIso"
        self.m3PFNeutralIso_branch = the_tree.GetBranch("m3PFNeutralIso")
        #if not self.m3PFNeutralIso_branch and "m3PFNeutralIso" not in self.complained:
        if not self.m3PFNeutralIso_branch and "m3PFNeutralIso":
            warnings.warn( "MuMuMuTree: Expected branch m3PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFNeutralIso")
        else:
            self.m3PFNeutralIso_branch.SetAddress(<void*>&self.m3PFNeutralIso_value)

        #print "making m3PFPUChargedIso"
        self.m3PFPUChargedIso_branch = the_tree.GetBranch("m3PFPUChargedIso")
        #if not self.m3PFPUChargedIso_branch and "m3PFPUChargedIso" not in self.complained:
        if not self.m3PFPUChargedIso_branch and "m3PFPUChargedIso":
            warnings.warn( "MuMuMuTree: Expected branch m3PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFPUChargedIso")
        else:
            self.m3PFPUChargedIso_branch.SetAddress(<void*>&self.m3PFPUChargedIso_value)

        #print "making m3PFPhotonIso"
        self.m3PFPhotonIso_branch = the_tree.GetBranch("m3PFPhotonIso")
        #if not self.m3PFPhotonIso_branch and "m3PFPhotonIso" not in self.complained:
        if not self.m3PFPhotonIso_branch and "m3PFPhotonIso":
            warnings.warn( "MuMuMuTree: Expected branch m3PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFPhotonIso")
        else:
            self.m3PFPhotonIso_branch.SetAddress(<void*>&self.m3PFPhotonIso_value)

        #print "making m3PFPhotonIsoR04"
        self.m3PFPhotonIsoR04_branch = the_tree.GetBranch("m3PFPhotonIsoR04")
        #if not self.m3PFPhotonIsoR04_branch and "m3PFPhotonIsoR04" not in self.complained:
        if not self.m3PFPhotonIsoR04_branch and "m3PFPhotonIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m3PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFPhotonIsoR04")
        else:
            self.m3PFPhotonIsoR04_branch.SetAddress(<void*>&self.m3PFPhotonIsoR04_value)

        #print "making m3PFPileupIsoR04"
        self.m3PFPileupIsoR04_branch = the_tree.GetBranch("m3PFPileupIsoR04")
        #if not self.m3PFPileupIsoR04_branch and "m3PFPileupIsoR04" not in self.complained:
        if not self.m3PFPileupIsoR04_branch and "m3PFPileupIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m3PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFPileupIsoR04")
        else:
            self.m3PFPileupIsoR04_branch.SetAddress(<void*>&self.m3PFPileupIsoR04_value)

        #print "making m3PVDXY"
        self.m3PVDXY_branch = the_tree.GetBranch("m3PVDXY")
        #if not self.m3PVDXY_branch and "m3PVDXY" not in self.complained:
        if not self.m3PVDXY_branch and "m3PVDXY":
            warnings.warn( "MuMuMuTree: Expected branch m3PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PVDXY")
        else:
            self.m3PVDXY_branch.SetAddress(<void*>&self.m3PVDXY_value)

        #print "making m3PVDZ"
        self.m3PVDZ_branch = the_tree.GetBranch("m3PVDZ")
        #if not self.m3PVDZ_branch and "m3PVDZ" not in self.complained:
        if not self.m3PVDZ_branch and "m3PVDZ":
            warnings.warn( "MuMuMuTree: Expected branch m3PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PVDZ")
        else:
            self.m3PVDZ_branch.SetAddress(<void*>&self.m3PVDZ_value)

        #print "making m3Phi"
        self.m3Phi_branch = the_tree.GetBranch("m3Phi")
        #if not self.m3Phi_branch and "m3Phi" not in self.complained:
        if not self.m3Phi_branch and "m3Phi":
            warnings.warn( "MuMuMuTree: Expected branch m3Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Phi")
        else:
            self.m3Phi_branch.SetAddress(<void*>&self.m3Phi_value)

        #print "making m3Phi_MuonEnDown"
        self.m3Phi_MuonEnDown_branch = the_tree.GetBranch("m3Phi_MuonEnDown")
        #if not self.m3Phi_MuonEnDown_branch and "m3Phi_MuonEnDown" not in self.complained:
        if not self.m3Phi_MuonEnDown_branch and "m3Phi_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3Phi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Phi_MuonEnDown")
        else:
            self.m3Phi_MuonEnDown_branch.SetAddress(<void*>&self.m3Phi_MuonEnDown_value)

        #print "making m3Phi_MuonEnUp"
        self.m3Phi_MuonEnUp_branch = the_tree.GetBranch("m3Phi_MuonEnUp")
        #if not self.m3Phi_MuonEnUp_branch and "m3Phi_MuonEnUp" not in self.complained:
        if not self.m3Phi_MuonEnUp_branch and "m3Phi_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3Phi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Phi_MuonEnUp")
        else:
            self.m3Phi_MuonEnUp_branch.SetAddress(<void*>&self.m3Phi_MuonEnUp_value)

        #print "making m3PixHits"
        self.m3PixHits_branch = the_tree.GetBranch("m3PixHits")
        #if not self.m3PixHits_branch and "m3PixHits" not in self.complained:
        if not self.m3PixHits_branch and "m3PixHits":
            warnings.warn( "MuMuMuTree: Expected branch m3PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PixHits")
        else:
            self.m3PixHits_branch.SetAddress(<void*>&self.m3PixHits_value)

        #print "making m3Pt"
        self.m3Pt_branch = the_tree.GetBranch("m3Pt")
        #if not self.m3Pt_branch and "m3Pt" not in self.complained:
        if not self.m3Pt_branch and "m3Pt":
            warnings.warn( "MuMuMuTree: Expected branch m3Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Pt")
        else:
            self.m3Pt_branch.SetAddress(<void*>&self.m3Pt_value)

        #print "making m3Pt_MuonEnDown"
        self.m3Pt_MuonEnDown_branch = the_tree.GetBranch("m3Pt_MuonEnDown")
        #if not self.m3Pt_MuonEnDown_branch and "m3Pt_MuonEnDown" not in self.complained:
        if not self.m3Pt_MuonEnDown_branch and "m3Pt_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3Pt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Pt_MuonEnDown")
        else:
            self.m3Pt_MuonEnDown_branch.SetAddress(<void*>&self.m3Pt_MuonEnDown_value)

        #print "making m3Pt_MuonEnUp"
        self.m3Pt_MuonEnUp_branch = the_tree.GetBranch("m3Pt_MuonEnUp")
        #if not self.m3Pt_MuonEnUp_branch and "m3Pt_MuonEnUp" not in self.complained:
        if not self.m3Pt_MuonEnUp_branch and "m3Pt_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3Pt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Pt_MuonEnUp")
        else:
            self.m3Pt_MuonEnUp_branch.SetAddress(<void*>&self.m3Pt_MuonEnUp_value)

        #print "making m3Rank"
        self.m3Rank_branch = the_tree.GetBranch("m3Rank")
        #if not self.m3Rank_branch and "m3Rank" not in self.complained:
        if not self.m3Rank_branch and "m3Rank":
            warnings.warn( "MuMuMuTree: Expected branch m3Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Rank")
        else:
            self.m3Rank_branch.SetAddress(<void*>&self.m3Rank_value)

        #print "making m3RelPFIsoDBDefault"
        self.m3RelPFIsoDBDefault_branch = the_tree.GetBranch("m3RelPFIsoDBDefault")
        #if not self.m3RelPFIsoDBDefault_branch and "m3RelPFIsoDBDefault" not in self.complained:
        if not self.m3RelPFIsoDBDefault_branch and "m3RelPFIsoDBDefault":
            warnings.warn( "MuMuMuTree: Expected branch m3RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RelPFIsoDBDefault")
        else:
            self.m3RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m3RelPFIsoDBDefault_value)

        #print "making m3RelPFIsoDBDefaultR04"
        self.m3RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m3RelPFIsoDBDefaultR04")
        #if not self.m3RelPFIsoDBDefaultR04_branch and "m3RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m3RelPFIsoDBDefaultR04_branch and "m3RelPFIsoDBDefaultR04":
            warnings.warn( "MuMuMuTree: Expected branch m3RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RelPFIsoDBDefaultR04")
        else:
            self.m3RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m3RelPFIsoDBDefaultR04_value)

        #print "making m3RelPFIsoRho"
        self.m3RelPFIsoRho_branch = the_tree.GetBranch("m3RelPFIsoRho")
        #if not self.m3RelPFIsoRho_branch and "m3RelPFIsoRho" not in self.complained:
        if not self.m3RelPFIsoRho_branch and "m3RelPFIsoRho":
            warnings.warn( "MuMuMuTree: Expected branch m3RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RelPFIsoRho")
        else:
            self.m3RelPFIsoRho_branch.SetAddress(<void*>&self.m3RelPFIsoRho_value)

        #print "making m3Rho"
        self.m3Rho_branch = the_tree.GetBranch("m3Rho")
        #if not self.m3Rho_branch and "m3Rho" not in self.complained:
        if not self.m3Rho_branch and "m3Rho":
            warnings.warn( "MuMuMuTree: Expected branch m3Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Rho")
        else:
            self.m3Rho_branch.SetAddress(<void*>&self.m3Rho_value)

        #print "making m3SIP2D"
        self.m3SIP2D_branch = the_tree.GetBranch("m3SIP2D")
        #if not self.m3SIP2D_branch and "m3SIP2D" not in self.complained:
        if not self.m3SIP2D_branch and "m3SIP2D":
            warnings.warn( "MuMuMuTree: Expected branch m3SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3SIP2D")
        else:
            self.m3SIP2D_branch.SetAddress(<void*>&self.m3SIP2D_value)

        #print "making m3SIP3D"
        self.m3SIP3D_branch = the_tree.GetBranch("m3SIP3D")
        #if not self.m3SIP3D_branch and "m3SIP3D" not in self.complained:
        if not self.m3SIP3D_branch and "m3SIP3D":
            warnings.warn( "MuMuMuTree: Expected branch m3SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3SIP3D")
        else:
            self.m3SIP3D_branch.SetAddress(<void*>&self.m3SIP3D_value)

        #print "making m3SegmentCompatibility"
        self.m3SegmentCompatibility_branch = the_tree.GetBranch("m3SegmentCompatibility")
        #if not self.m3SegmentCompatibility_branch and "m3SegmentCompatibility" not in self.complained:
        if not self.m3SegmentCompatibility_branch and "m3SegmentCompatibility":
            warnings.warn( "MuMuMuTree: Expected branch m3SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3SegmentCompatibility")
        else:
            self.m3SegmentCompatibility_branch.SetAddress(<void*>&self.m3SegmentCompatibility_value)

        #print "making m3TkLayersWithMeasurement"
        self.m3TkLayersWithMeasurement_branch = the_tree.GetBranch("m3TkLayersWithMeasurement")
        #if not self.m3TkLayersWithMeasurement_branch and "m3TkLayersWithMeasurement" not in self.complained:
        if not self.m3TkLayersWithMeasurement_branch and "m3TkLayersWithMeasurement":
            warnings.warn( "MuMuMuTree: Expected branch m3TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TkLayersWithMeasurement")
        else:
            self.m3TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m3TkLayersWithMeasurement_value)

        #print "making m3TrkIsoDR03"
        self.m3TrkIsoDR03_branch = the_tree.GetBranch("m3TrkIsoDR03")
        #if not self.m3TrkIsoDR03_branch and "m3TrkIsoDR03" not in self.complained:
        if not self.m3TrkIsoDR03_branch and "m3TrkIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m3TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TrkIsoDR03")
        else:
            self.m3TrkIsoDR03_branch.SetAddress(<void*>&self.m3TrkIsoDR03_value)

        #print "making m3TrkKink"
        self.m3TrkKink_branch = the_tree.GetBranch("m3TrkKink")
        #if not self.m3TrkKink_branch and "m3TrkKink" not in self.complained:
        if not self.m3TrkKink_branch and "m3TrkKink":
            warnings.warn( "MuMuMuTree: Expected branch m3TrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TrkKink")
        else:
            self.m3TrkKink_branch.SetAddress(<void*>&self.m3TrkKink_value)

        #print "making m3TypeCode"
        self.m3TypeCode_branch = the_tree.GetBranch("m3TypeCode")
        #if not self.m3TypeCode_branch and "m3TypeCode" not in self.complained:
        if not self.m3TypeCode_branch and "m3TypeCode":
            warnings.warn( "MuMuMuTree: Expected branch m3TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TypeCode")
        else:
            self.m3TypeCode_branch.SetAddress(<void*>&self.m3TypeCode_value)

        #print "making m3VZ"
        self.m3VZ_branch = the_tree.GetBranch("m3VZ")
        #if not self.m3VZ_branch and "m3VZ" not in self.complained:
        if not self.m3VZ_branch and "m3VZ":
            warnings.warn( "MuMuMuTree: Expected branch m3VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3VZ")
        else:
            self.m3VZ_branch.SetAddress(<void*>&self.m3VZ_value)

        #print "making m3ValidFraction"
        self.m3ValidFraction_branch = the_tree.GetBranch("m3ValidFraction")
        #if not self.m3ValidFraction_branch and "m3ValidFraction" not in self.complained:
        if not self.m3ValidFraction_branch and "m3ValidFraction":
            warnings.warn( "MuMuMuTree: Expected branch m3ValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ValidFraction")
        else:
            self.m3ValidFraction_branch.SetAddress(<void*>&self.m3ValidFraction_value)

        #print "making m3ZTTGenMatching"
        self.m3ZTTGenMatching_branch = the_tree.GetBranch("m3ZTTGenMatching")
        #if not self.m3ZTTGenMatching_branch and "m3ZTTGenMatching" not in self.complained:
        if not self.m3ZTTGenMatching_branch and "m3ZTTGenMatching":
            warnings.warn( "MuMuMuTree: Expected branch m3ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ZTTGenMatching")
        else:
            self.m3ZTTGenMatching_branch.SetAddress(<void*>&self.m3ZTTGenMatching_value)

        #print "making m3_m1_collinearmass"
        self.m3_m1_collinearmass_branch = the_tree.GetBranch("m3_m1_collinearmass")
        #if not self.m3_m1_collinearmass_branch and "m3_m1_collinearmass" not in self.complained:
        if not self.m3_m1_collinearmass_branch and "m3_m1_collinearmass":
            warnings.warn( "MuMuMuTree: Expected branch m3_m1_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_m1_collinearmass")
        else:
            self.m3_m1_collinearmass_branch.SetAddress(<void*>&self.m3_m1_collinearmass_value)

        #print "making m3_m1_collinearmass_JetEnDown"
        self.m3_m1_collinearmass_JetEnDown_branch = the_tree.GetBranch("m3_m1_collinearmass_JetEnDown")
        #if not self.m3_m1_collinearmass_JetEnDown_branch and "m3_m1_collinearmass_JetEnDown" not in self.complained:
        if not self.m3_m1_collinearmass_JetEnDown_branch and "m3_m1_collinearmass_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3_m1_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_m1_collinearmass_JetEnDown")
        else:
            self.m3_m1_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m3_m1_collinearmass_JetEnDown_value)

        #print "making m3_m1_collinearmass_JetEnUp"
        self.m3_m1_collinearmass_JetEnUp_branch = the_tree.GetBranch("m3_m1_collinearmass_JetEnUp")
        #if not self.m3_m1_collinearmass_JetEnUp_branch and "m3_m1_collinearmass_JetEnUp" not in self.complained:
        if not self.m3_m1_collinearmass_JetEnUp_branch and "m3_m1_collinearmass_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3_m1_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_m1_collinearmass_JetEnUp")
        else:
            self.m3_m1_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m3_m1_collinearmass_JetEnUp_value)

        #print "making m3_m1_collinearmass_UnclusteredEnDown"
        self.m3_m1_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m3_m1_collinearmass_UnclusteredEnDown")
        #if not self.m3_m1_collinearmass_UnclusteredEnDown_branch and "m3_m1_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m3_m1_collinearmass_UnclusteredEnDown_branch and "m3_m1_collinearmass_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3_m1_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_m1_collinearmass_UnclusteredEnDown")
        else:
            self.m3_m1_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m3_m1_collinearmass_UnclusteredEnDown_value)

        #print "making m3_m1_collinearmass_UnclusteredEnUp"
        self.m3_m1_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m3_m1_collinearmass_UnclusteredEnUp")
        #if not self.m3_m1_collinearmass_UnclusteredEnUp_branch and "m3_m1_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m3_m1_collinearmass_UnclusteredEnUp_branch and "m3_m1_collinearmass_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3_m1_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_m1_collinearmass_UnclusteredEnUp")
        else:
            self.m3_m1_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m3_m1_collinearmass_UnclusteredEnUp_value)

        #print "making m3_m2_collinearmass"
        self.m3_m2_collinearmass_branch = the_tree.GetBranch("m3_m2_collinearmass")
        #if not self.m3_m2_collinearmass_branch and "m3_m2_collinearmass" not in self.complained:
        if not self.m3_m2_collinearmass_branch and "m3_m2_collinearmass":
            warnings.warn( "MuMuMuTree: Expected branch m3_m2_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_m2_collinearmass")
        else:
            self.m3_m2_collinearmass_branch.SetAddress(<void*>&self.m3_m2_collinearmass_value)

        #print "making m3_m2_collinearmass_JetEnDown"
        self.m3_m2_collinearmass_JetEnDown_branch = the_tree.GetBranch("m3_m2_collinearmass_JetEnDown")
        #if not self.m3_m2_collinearmass_JetEnDown_branch and "m3_m2_collinearmass_JetEnDown" not in self.complained:
        if not self.m3_m2_collinearmass_JetEnDown_branch and "m3_m2_collinearmass_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3_m2_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_m2_collinearmass_JetEnDown")
        else:
            self.m3_m2_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m3_m2_collinearmass_JetEnDown_value)

        #print "making m3_m2_collinearmass_JetEnUp"
        self.m3_m2_collinearmass_JetEnUp_branch = the_tree.GetBranch("m3_m2_collinearmass_JetEnUp")
        #if not self.m3_m2_collinearmass_JetEnUp_branch and "m3_m2_collinearmass_JetEnUp" not in self.complained:
        if not self.m3_m2_collinearmass_JetEnUp_branch and "m3_m2_collinearmass_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3_m2_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_m2_collinearmass_JetEnUp")
        else:
            self.m3_m2_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m3_m2_collinearmass_JetEnUp_value)

        #print "making m3_m2_collinearmass_UnclusteredEnDown"
        self.m3_m2_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m3_m2_collinearmass_UnclusteredEnDown")
        #if not self.m3_m2_collinearmass_UnclusteredEnDown_branch and "m3_m2_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m3_m2_collinearmass_UnclusteredEnDown_branch and "m3_m2_collinearmass_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3_m2_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_m2_collinearmass_UnclusteredEnDown")
        else:
            self.m3_m2_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m3_m2_collinearmass_UnclusteredEnDown_value)

        #print "making m3_m2_collinearmass_UnclusteredEnUp"
        self.m3_m2_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m3_m2_collinearmass_UnclusteredEnUp")
        #if not self.m3_m2_collinearmass_UnclusteredEnUp_branch and "m3_m2_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m3_m2_collinearmass_UnclusteredEnUp_branch and "m3_m2_collinearmass_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3_m2_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_m2_collinearmass_UnclusteredEnUp")
        else:
            self.m3_m2_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m3_m2_collinearmass_UnclusteredEnUp_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "MuMuMuTree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "MuMuMuTree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "MuMuMuTree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "MuMuMuTree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "MuMuMuTree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "MuMuMuTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "MuMuMuTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "MuMuMuTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "MuMuMuTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "MuMuMuTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making muVetoZTTp001dxyzR0"
        self.muVetoZTTp001dxyzR0_branch = the_tree.GetBranch("muVetoZTTp001dxyzR0")
        #if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0" not in self.complained:
        if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0":
            warnings.warn( "MuMuMuTree: Expected branch muVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyzR0")
        else:
            self.muVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.muVetoZTTp001dxyzR0_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "MuMuMuTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "MuMuMuTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "MuMuMuTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "MuMuMuTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "MuMuMuTree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "MuMuMuTree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "MuMuMuTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "MuMuMuTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "MuMuMuTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "MuMuMuTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "MuMuMuTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "MuMuMuTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "MuMuMuTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "MuMuMuTree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "MuMuMuTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "MuMuMuTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "MuMuMuTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "MuMuMuTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making raw_pfMetEt"
        self.raw_pfMetEt_branch = the_tree.GetBranch("raw_pfMetEt")
        #if not self.raw_pfMetEt_branch and "raw_pfMetEt" not in self.complained:
        if not self.raw_pfMetEt_branch and "raw_pfMetEt":
            warnings.warn( "MuMuMuTree: Expected branch raw_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetEt")
        else:
            self.raw_pfMetEt_branch.SetAddress(<void*>&self.raw_pfMetEt_value)

        #print "making raw_pfMetPhi"
        self.raw_pfMetPhi_branch = the_tree.GetBranch("raw_pfMetPhi")
        #if not self.raw_pfMetPhi_branch and "raw_pfMetPhi" not in self.complained:
        if not self.raw_pfMetPhi_branch and "raw_pfMetPhi":
            warnings.warn( "MuMuMuTree: Expected branch raw_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetPhi")
        else:
            self.raw_pfMetPhi_branch.SetAddress(<void*>&self.raw_pfMetPhi_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "MuMuMuTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "MuMuMuTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "MuMuMuTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "MuMuMuTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE17SingleMu8Group"
        self.singleE17SingleMu8Group_branch = the_tree.GetBranch("singleE17SingleMu8Group")
        #if not self.singleE17SingleMu8Group_branch and "singleE17SingleMu8Group" not in self.complained:
        if not self.singleE17SingleMu8Group_branch and "singleE17SingleMu8Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE17SingleMu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE17SingleMu8Group")
        else:
            self.singleE17SingleMu8Group_branch.SetAddress(<void*>&self.singleE17SingleMu8Group_value)

        #print "making singleE17SingleMu8Pass"
        self.singleE17SingleMu8Pass_branch = the_tree.GetBranch("singleE17SingleMu8Pass")
        #if not self.singleE17SingleMu8Pass_branch and "singleE17SingleMu8Pass" not in self.complained:
        if not self.singleE17SingleMu8Pass_branch and "singleE17SingleMu8Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE17SingleMu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE17SingleMu8Pass")
        else:
            self.singleE17SingleMu8Pass_branch.SetAddress(<void*>&self.singleE17SingleMu8Pass_value)

        #print "making singleE17SingleMu8Prescale"
        self.singleE17SingleMu8Prescale_branch = the_tree.GetBranch("singleE17SingleMu8Prescale")
        #if not self.singleE17SingleMu8Prescale_branch and "singleE17SingleMu8Prescale" not in self.complained:
        if not self.singleE17SingleMu8Prescale_branch and "singleE17SingleMu8Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE17SingleMu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE17SingleMu8Prescale")
        else:
            self.singleE17SingleMu8Prescale_branch.SetAddress(<void*>&self.singleE17SingleMu8Prescale_value)

        #print "making singleE20SingleTau28Group"
        self.singleE20SingleTau28Group_branch = the_tree.GetBranch("singleE20SingleTau28Group")
        #if not self.singleE20SingleTau28Group_branch and "singleE20SingleTau28Group" not in self.complained:
        if not self.singleE20SingleTau28Group_branch and "singleE20SingleTau28Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE20SingleTau28Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE20SingleTau28Group")
        else:
            self.singleE20SingleTau28Group_branch.SetAddress(<void*>&self.singleE20SingleTau28Group_value)

        #print "making singleE20SingleTau28Pass"
        self.singleE20SingleTau28Pass_branch = the_tree.GetBranch("singleE20SingleTau28Pass")
        #if not self.singleE20SingleTau28Pass_branch and "singleE20SingleTau28Pass" not in self.complained:
        if not self.singleE20SingleTau28Pass_branch and "singleE20SingleTau28Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE20SingleTau28Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE20SingleTau28Pass")
        else:
            self.singleE20SingleTau28Pass_branch.SetAddress(<void*>&self.singleE20SingleTau28Pass_value)

        #print "making singleE20SingleTau28Prescale"
        self.singleE20SingleTau28Prescale_branch = the_tree.GetBranch("singleE20SingleTau28Prescale")
        #if not self.singleE20SingleTau28Prescale_branch and "singleE20SingleTau28Prescale" not in self.complained:
        if not self.singleE20SingleTau28Prescale_branch and "singleE20SingleTau28Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE20SingleTau28Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE20SingleTau28Prescale")
        else:
            self.singleE20SingleTau28Prescale_branch.SetAddress(<void*>&self.singleE20SingleTau28Prescale_value)

        #print "making singleE22SingleTau20SingleL1Group"
        self.singleE22SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE22SingleTau20SingleL1Group")
        #if not self.singleE22SingleTau20SingleL1Group_branch and "singleE22SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE22SingleTau20SingleL1Group_branch and "singleE22SingleTau20SingleL1Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE22SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau20SingleL1Group")
        else:
            self.singleE22SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE22SingleTau20SingleL1Group_value)

        #print "making singleE22SingleTau20SingleL1Pass"
        self.singleE22SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE22SingleTau20SingleL1Pass")
        #if not self.singleE22SingleTau20SingleL1Pass_branch and "singleE22SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE22SingleTau20SingleL1Pass_branch and "singleE22SingleTau20SingleL1Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE22SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau20SingleL1Pass")
        else:
            self.singleE22SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE22SingleTau20SingleL1Pass_value)

        #print "making singleE22SingleTau20SingleL1Prescale"
        self.singleE22SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE22SingleTau20SingleL1Prescale")
        #if not self.singleE22SingleTau20SingleL1Prescale_branch and "singleE22SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE22SingleTau20SingleL1Prescale_branch and "singleE22SingleTau20SingleL1Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE22SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau20SingleL1Prescale")
        else:
            self.singleE22SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE22SingleTau20SingleL1Prescale_value)

        #print "making singleE22SingleTau29Group"
        self.singleE22SingleTau29Group_branch = the_tree.GetBranch("singleE22SingleTau29Group")
        #if not self.singleE22SingleTau29Group_branch and "singleE22SingleTau29Group" not in self.complained:
        if not self.singleE22SingleTau29Group_branch and "singleE22SingleTau29Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE22SingleTau29Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau29Group")
        else:
            self.singleE22SingleTau29Group_branch.SetAddress(<void*>&self.singleE22SingleTau29Group_value)

        #print "making singleE22SingleTau29Pass"
        self.singleE22SingleTau29Pass_branch = the_tree.GetBranch("singleE22SingleTau29Pass")
        #if not self.singleE22SingleTau29Pass_branch and "singleE22SingleTau29Pass" not in self.complained:
        if not self.singleE22SingleTau29Pass_branch and "singleE22SingleTau29Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE22SingleTau29Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau29Pass")
        else:
            self.singleE22SingleTau29Pass_branch.SetAddress(<void*>&self.singleE22SingleTau29Pass_value)

        #print "making singleE22SingleTau29Prescale"
        self.singleE22SingleTau29Prescale_branch = the_tree.GetBranch("singleE22SingleTau29Prescale")
        #if not self.singleE22SingleTau29Prescale_branch and "singleE22SingleTau29Prescale" not in self.complained:
        if not self.singleE22SingleTau29Prescale_branch and "singleE22SingleTau29Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE22SingleTau29Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau29Prescale")
        else:
            self.singleE22SingleTau29Prescale_branch.SetAddress(<void*>&self.singleE22SingleTau29Prescale_value)

        #print "making singleE22eta2p1LooseGroup"
        self.singleE22eta2p1LooseGroup_branch = the_tree.GetBranch("singleE22eta2p1LooseGroup")
        #if not self.singleE22eta2p1LooseGroup_branch and "singleE22eta2p1LooseGroup" not in self.complained:
        if not self.singleE22eta2p1LooseGroup_branch and "singleE22eta2p1LooseGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleE22eta2p1LooseGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22eta2p1LooseGroup")
        else:
            self.singleE22eta2p1LooseGroup_branch.SetAddress(<void*>&self.singleE22eta2p1LooseGroup_value)

        #print "making singleE22eta2p1LoosePass"
        self.singleE22eta2p1LoosePass_branch = the_tree.GetBranch("singleE22eta2p1LoosePass")
        #if not self.singleE22eta2p1LoosePass_branch and "singleE22eta2p1LoosePass" not in self.complained:
        if not self.singleE22eta2p1LoosePass_branch and "singleE22eta2p1LoosePass":
            warnings.warn( "MuMuMuTree: Expected branch singleE22eta2p1LoosePass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22eta2p1LoosePass")
        else:
            self.singleE22eta2p1LoosePass_branch.SetAddress(<void*>&self.singleE22eta2p1LoosePass_value)

        #print "making singleE22eta2p1LoosePrescale"
        self.singleE22eta2p1LoosePrescale_branch = the_tree.GetBranch("singleE22eta2p1LoosePrescale")
        #if not self.singleE22eta2p1LoosePrescale_branch and "singleE22eta2p1LoosePrescale" not in self.complained:
        if not self.singleE22eta2p1LoosePrescale_branch and "singleE22eta2p1LoosePrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE22eta2p1LoosePrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22eta2p1LoosePrescale")
        else:
            self.singleE22eta2p1LoosePrescale_branch.SetAddress(<void*>&self.singleE22eta2p1LoosePrescale_value)

        #print "making singleE22eta2p1LooseTau20Group"
        self.singleE22eta2p1LooseTau20Group_branch = the_tree.GetBranch("singleE22eta2p1LooseTau20Group")
        #if not self.singleE22eta2p1LooseTau20Group_branch and "singleE22eta2p1LooseTau20Group" not in self.complained:
        if not self.singleE22eta2p1LooseTau20Group_branch and "singleE22eta2p1LooseTau20Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE22eta2p1LooseTau20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22eta2p1LooseTau20Group")
        else:
            self.singleE22eta2p1LooseTau20Group_branch.SetAddress(<void*>&self.singleE22eta2p1LooseTau20Group_value)

        #print "making singleE22eta2p1LooseTau20Pass"
        self.singleE22eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleE22eta2p1LooseTau20Pass")
        #if not self.singleE22eta2p1LooseTau20Pass_branch and "singleE22eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleE22eta2p1LooseTau20Pass_branch and "singleE22eta2p1LooseTau20Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE22eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22eta2p1LooseTau20Pass")
        else:
            self.singleE22eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleE22eta2p1LooseTau20Pass_value)

        #print "making singleE22eta2p1LooseTau20Prescale"
        self.singleE22eta2p1LooseTau20Prescale_branch = the_tree.GetBranch("singleE22eta2p1LooseTau20Prescale")
        #if not self.singleE22eta2p1LooseTau20Prescale_branch and "singleE22eta2p1LooseTau20Prescale" not in self.complained:
        if not self.singleE22eta2p1LooseTau20Prescale_branch and "singleE22eta2p1LooseTau20Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE22eta2p1LooseTau20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22eta2p1LooseTau20Prescale")
        else:
            self.singleE22eta2p1LooseTau20Prescale_branch.SetAddress(<void*>&self.singleE22eta2p1LooseTau20Prescale_value)

        #print "making singleE23SingleMu8Group"
        self.singleE23SingleMu8Group_branch = the_tree.GetBranch("singleE23SingleMu8Group")
        #if not self.singleE23SingleMu8Group_branch and "singleE23SingleMu8Group" not in self.complained:
        if not self.singleE23SingleMu8Group_branch and "singleE23SingleMu8Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE23SingleMu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23SingleMu8Group")
        else:
            self.singleE23SingleMu8Group_branch.SetAddress(<void*>&self.singleE23SingleMu8Group_value)

        #print "making singleE23SingleMu8Pass"
        self.singleE23SingleMu8Pass_branch = the_tree.GetBranch("singleE23SingleMu8Pass")
        #if not self.singleE23SingleMu8Pass_branch and "singleE23SingleMu8Pass" not in self.complained:
        if not self.singleE23SingleMu8Pass_branch and "singleE23SingleMu8Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE23SingleMu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23SingleMu8Pass")
        else:
            self.singleE23SingleMu8Pass_branch.SetAddress(<void*>&self.singleE23SingleMu8Pass_value)

        #print "making singleE23SingleMu8Prescale"
        self.singleE23SingleMu8Prescale_branch = the_tree.GetBranch("singleE23SingleMu8Prescale")
        #if not self.singleE23SingleMu8Prescale_branch and "singleE23SingleMu8Prescale" not in self.complained:
        if not self.singleE23SingleMu8Prescale_branch and "singleE23SingleMu8Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE23SingleMu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23SingleMu8Prescale")
        else:
            self.singleE23SingleMu8Prescale_branch.SetAddress(<void*>&self.singleE23SingleMu8Prescale_value)

        #print "making singleE23WPLooseGroup"
        self.singleE23WPLooseGroup_branch = the_tree.GetBranch("singleE23WPLooseGroup")
        #if not self.singleE23WPLooseGroup_branch and "singleE23WPLooseGroup" not in self.complained:
        if not self.singleE23WPLooseGroup_branch and "singleE23WPLooseGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleE23WPLooseGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23WPLooseGroup")
        else:
            self.singleE23WPLooseGroup_branch.SetAddress(<void*>&self.singleE23WPLooseGroup_value)

        #print "making singleE23WPLoosePass"
        self.singleE23WPLoosePass_branch = the_tree.GetBranch("singleE23WPLoosePass")
        #if not self.singleE23WPLoosePass_branch and "singleE23WPLoosePass" not in self.complained:
        if not self.singleE23WPLoosePass_branch and "singleE23WPLoosePass":
            warnings.warn( "MuMuMuTree: Expected branch singleE23WPLoosePass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23WPLoosePass")
        else:
            self.singleE23WPLoosePass_branch.SetAddress(<void*>&self.singleE23WPLoosePass_value)

        #print "making singleE23WPLoosePrescale"
        self.singleE23WPLoosePrescale_branch = the_tree.GetBranch("singleE23WPLoosePrescale")
        #if not self.singleE23WPLoosePrescale_branch and "singleE23WPLoosePrescale" not in self.complained:
        if not self.singleE23WPLoosePrescale_branch and "singleE23WPLoosePrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE23WPLoosePrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE23WPLoosePrescale")
        else:
            self.singleE23WPLoosePrescale_branch.SetAddress(<void*>&self.singleE23WPLoosePrescale_value)

        #print "making singleE24SingleTau20Group"
        self.singleE24SingleTau20Group_branch = the_tree.GetBranch("singleE24SingleTau20Group")
        #if not self.singleE24SingleTau20Group_branch and "singleE24SingleTau20Group" not in self.complained:
        if not self.singleE24SingleTau20Group_branch and "singleE24SingleTau20Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE24SingleTau20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20Group")
        else:
            self.singleE24SingleTau20Group_branch.SetAddress(<void*>&self.singleE24SingleTau20Group_value)

        #print "making singleE24SingleTau20Pass"
        self.singleE24SingleTau20Pass_branch = the_tree.GetBranch("singleE24SingleTau20Pass")
        #if not self.singleE24SingleTau20Pass_branch and "singleE24SingleTau20Pass" not in self.complained:
        if not self.singleE24SingleTau20Pass_branch and "singleE24SingleTau20Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE24SingleTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20Pass")
        else:
            self.singleE24SingleTau20Pass_branch.SetAddress(<void*>&self.singleE24SingleTau20Pass_value)

        #print "making singleE24SingleTau20Prescale"
        self.singleE24SingleTau20Prescale_branch = the_tree.GetBranch("singleE24SingleTau20Prescale")
        #if not self.singleE24SingleTau20Prescale_branch and "singleE24SingleTau20Prescale" not in self.complained:
        if not self.singleE24SingleTau20Prescale_branch and "singleE24SingleTau20Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE24SingleTau20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20Prescale")
        else:
            self.singleE24SingleTau20Prescale_branch.SetAddress(<void*>&self.singleE24SingleTau20Prescale_value)

        #print "making singleE24SingleTau20SingleL1Group"
        self.singleE24SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE24SingleTau20SingleL1Group")
        #if not self.singleE24SingleTau20SingleL1Group_branch and "singleE24SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE24SingleTau20SingleL1Group_branch and "singleE24SingleTau20SingleL1Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE24SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20SingleL1Group")
        else:
            self.singleE24SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE24SingleTau20SingleL1Group_value)

        #print "making singleE24SingleTau20SingleL1Pass"
        self.singleE24SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE24SingleTau20SingleL1Pass")
        #if not self.singleE24SingleTau20SingleL1Pass_branch and "singleE24SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE24SingleTau20SingleL1Pass_branch and "singleE24SingleTau20SingleL1Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE24SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20SingleL1Pass")
        else:
            self.singleE24SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE24SingleTau20SingleL1Pass_value)

        #print "making singleE24SingleTau20SingleL1Prescale"
        self.singleE24SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE24SingleTau20SingleL1Prescale")
        #if not self.singleE24SingleTau20SingleL1Prescale_branch and "singleE24SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE24SingleTau20SingleL1Prescale_branch and "singleE24SingleTau20SingleL1Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE24SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20SingleL1Prescale")
        else:
            self.singleE24SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE24SingleTau20SingleL1Prescale_value)

        #print "making singleE24SingleTau30Group"
        self.singleE24SingleTau30Group_branch = the_tree.GetBranch("singleE24SingleTau30Group")
        #if not self.singleE24SingleTau30Group_branch and "singleE24SingleTau30Group" not in self.complained:
        if not self.singleE24SingleTau30Group_branch and "singleE24SingleTau30Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE24SingleTau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau30Group")
        else:
            self.singleE24SingleTau30Group_branch.SetAddress(<void*>&self.singleE24SingleTau30Group_value)

        #print "making singleE24SingleTau30Pass"
        self.singleE24SingleTau30Pass_branch = the_tree.GetBranch("singleE24SingleTau30Pass")
        #if not self.singleE24SingleTau30Pass_branch and "singleE24SingleTau30Pass" not in self.complained:
        if not self.singleE24SingleTau30Pass_branch and "singleE24SingleTau30Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE24SingleTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau30Pass")
        else:
            self.singleE24SingleTau30Pass_branch.SetAddress(<void*>&self.singleE24SingleTau30Pass_value)

        #print "making singleE24SingleTau30Prescale"
        self.singleE24SingleTau30Prescale_branch = the_tree.GetBranch("singleE24SingleTau30Prescale")
        #if not self.singleE24SingleTau30Prescale_branch and "singleE24SingleTau30Prescale" not in self.complained:
        if not self.singleE24SingleTau30Prescale_branch and "singleE24SingleTau30Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE24SingleTau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau30Prescale")
        else:
            self.singleE24SingleTau30Prescale_branch.SetAddress(<void*>&self.singleE24SingleTau30Prescale_value)

        #print "making singleE25eta2p1LooseGroup"
        self.singleE25eta2p1LooseGroup_branch = the_tree.GetBranch("singleE25eta2p1LooseGroup")
        #if not self.singleE25eta2p1LooseGroup_branch and "singleE25eta2p1LooseGroup" not in self.complained:
        if not self.singleE25eta2p1LooseGroup_branch and "singleE25eta2p1LooseGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleE25eta2p1LooseGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1LooseGroup")
        else:
            self.singleE25eta2p1LooseGroup_branch.SetAddress(<void*>&self.singleE25eta2p1LooseGroup_value)

        #print "making singleE25eta2p1LoosePass"
        self.singleE25eta2p1LoosePass_branch = the_tree.GetBranch("singleE25eta2p1LoosePass")
        #if not self.singleE25eta2p1LoosePass_branch and "singleE25eta2p1LoosePass" not in self.complained:
        if not self.singleE25eta2p1LoosePass_branch and "singleE25eta2p1LoosePass":
            warnings.warn( "MuMuMuTree: Expected branch singleE25eta2p1LoosePass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1LoosePass")
        else:
            self.singleE25eta2p1LoosePass_branch.SetAddress(<void*>&self.singleE25eta2p1LoosePass_value)

        #print "making singleE25eta2p1LoosePrescale"
        self.singleE25eta2p1LoosePrescale_branch = the_tree.GetBranch("singleE25eta2p1LoosePrescale")
        #if not self.singleE25eta2p1LoosePrescale_branch and "singleE25eta2p1LoosePrescale" not in self.complained:
        if not self.singleE25eta2p1LoosePrescale_branch and "singleE25eta2p1LoosePrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE25eta2p1LoosePrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1LoosePrescale")
        else:
            self.singleE25eta2p1LoosePrescale_branch.SetAddress(<void*>&self.singleE25eta2p1LoosePrescale_value)

        #print "making singleE25eta2p1TightGroup"
        self.singleE25eta2p1TightGroup_branch = the_tree.GetBranch("singleE25eta2p1TightGroup")
        #if not self.singleE25eta2p1TightGroup_branch and "singleE25eta2p1TightGroup" not in self.complained:
        if not self.singleE25eta2p1TightGroup_branch and "singleE25eta2p1TightGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleE25eta2p1TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightGroup")
        else:
            self.singleE25eta2p1TightGroup_branch.SetAddress(<void*>&self.singleE25eta2p1TightGroup_value)

        #print "making singleE25eta2p1TightPass"
        self.singleE25eta2p1TightPass_branch = the_tree.GetBranch("singleE25eta2p1TightPass")
        #if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass" not in self.complained:
        if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass":
            warnings.warn( "MuMuMuTree: Expected branch singleE25eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPass")
        else:
            self.singleE25eta2p1TightPass_branch.SetAddress(<void*>&self.singleE25eta2p1TightPass_value)

        #print "making singleE25eta2p1TightPrescale"
        self.singleE25eta2p1TightPrescale_branch = the_tree.GetBranch("singleE25eta2p1TightPrescale")
        #if not self.singleE25eta2p1TightPrescale_branch and "singleE25eta2p1TightPrescale" not in self.complained:
        if not self.singleE25eta2p1TightPrescale_branch and "singleE25eta2p1TightPrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE25eta2p1TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPrescale")
        else:
            self.singleE25eta2p1TightPrescale_branch.SetAddress(<void*>&self.singleE25eta2p1TightPrescale_value)

        #print "making singleE27SingleTau20SingleL1Group"
        self.singleE27SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE27SingleTau20SingleL1Group")
        #if not self.singleE27SingleTau20SingleL1Group_branch and "singleE27SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE27SingleTau20SingleL1Group_branch and "singleE27SingleTau20SingleL1Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE27SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27SingleTau20SingleL1Group")
        else:
            self.singleE27SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE27SingleTau20SingleL1Group_value)

        #print "making singleE27SingleTau20SingleL1Pass"
        self.singleE27SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE27SingleTau20SingleL1Pass")
        #if not self.singleE27SingleTau20SingleL1Pass_branch and "singleE27SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE27SingleTau20SingleL1Pass_branch and "singleE27SingleTau20SingleL1Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE27SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27SingleTau20SingleL1Pass")
        else:
            self.singleE27SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE27SingleTau20SingleL1Pass_value)

        #print "making singleE27SingleTau20SingleL1Prescale"
        self.singleE27SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE27SingleTau20SingleL1Prescale")
        #if not self.singleE27SingleTau20SingleL1Prescale_branch and "singleE27SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE27SingleTau20SingleL1Prescale_branch and "singleE27SingleTau20SingleL1Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE27SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27SingleTau20SingleL1Prescale")
        else:
            self.singleE27SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE27SingleTau20SingleL1Prescale_value)

        #print "making singleE27TightGroup"
        self.singleE27TightGroup_branch = the_tree.GetBranch("singleE27TightGroup")
        #if not self.singleE27TightGroup_branch and "singleE27TightGroup" not in self.complained:
        if not self.singleE27TightGroup_branch and "singleE27TightGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleE27TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightGroup")
        else:
            self.singleE27TightGroup_branch.SetAddress(<void*>&self.singleE27TightGroup_value)

        #print "making singleE27TightPass"
        self.singleE27TightPass_branch = the_tree.GetBranch("singleE27TightPass")
        #if not self.singleE27TightPass_branch and "singleE27TightPass" not in self.complained:
        if not self.singleE27TightPass_branch and "singleE27TightPass":
            warnings.warn( "MuMuMuTree: Expected branch singleE27TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightPass")
        else:
            self.singleE27TightPass_branch.SetAddress(<void*>&self.singleE27TightPass_value)

        #print "making singleE27TightPrescale"
        self.singleE27TightPrescale_branch = the_tree.GetBranch("singleE27TightPrescale")
        #if not self.singleE27TightPrescale_branch and "singleE27TightPrescale" not in self.complained:
        if not self.singleE27TightPrescale_branch and "singleE27TightPrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE27TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightPrescale")
        else:
            self.singleE27TightPrescale_branch.SetAddress(<void*>&self.singleE27TightPrescale_value)

        #print "making singleE27eta2p1LooseGroup"
        self.singleE27eta2p1LooseGroup_branch = the_tree.GetBranch("singleE27eta2p1LooseGroup")
        #if not self.singleE27eta2p1LooseGroup_branch and "singleE27eta2p1LooseGroup" not in self.complained:
        if not self.singleE27eta2p1LooseGroup_branch and "singleE27eta2p1LooseGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleE27eta2p1LooseGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1LooseGroup")
        else:
            self.singleE27eta2p1LooseGroup_branch.SetAddress(<void*>&self.singleE27eta2p1LooseGroup_value)

        #print "making singleE27eta2p1LoosePass"
        self.singleE27eta2p1LoosePass_branch = the_tree.GetBranch("singleE27eta2p1LoosePass")
        #if not self.singleE27eta2p1LoosePass_branch and "singleE27eta2p1LoosePass" not in self.complained:
        if not self.singleE27eta2p1LoosePass_branch and "singleE27eta2p1LoosePass":
            warnings.warn( "MuMuMuTree: Expected branch singleE27eta2p1LoosePass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1LoosePass")
        else:
            self.singleE27eta2p1LoosePass_branch.SetAddress(<void*>&self.singleE27eta2p1LoosePass_value)

        #print "making singleE27eta2p1LoosePrescale"
        self.singleE27eta2p1LoosePrescale_branch = the_tree.GetBranch("singleE27eta2p1LoosePrescale")
        #if not self.singleE27eta2p1LoosePrescale_branch and "singleE27eta2p1LoosePrescale" not in self.complained:
        if not self.singleE27eta2p1LoosePrescale_branch and "singleE27eta2p1LoosePrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE27eta2p1LoosePrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1LoosePrescale")
        else:
            self.singleE27eta2p1LoosePrescale_branch.SetAddress(<void*>&self.singleE27eta2p1LoosePrescale_value)

        #print "making singleE27eta2p1TightGroup"
        self.singleE27eta2p1TightGroup_branch = the_tree.GetBranch("singleE27eta2p1TightGroup")
        #if not self.singleE27eta2p1TightGroup_branch and "singleE27eta2p1TightGroup" not in self.complained:
        if not self.singleE27eta2p1TightGroup_branch and "singleE27eta2p1TightGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleE27eta2p1TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1TightGroup")
        else:
            self.singleE27eta2p1TightGroup_branch.SetAddress(<void*>&self.singleE27eta2p1TightGroup_value)

        #print "making singleE27eta2p1TightPass"
        self.singleE27eta2p1TightPass_branch = the_tree.GetBranch("singleE27eta2p1TightPass")
        #if not self.singleE27eta2p1TightPass_branch and "singleE27eta2p1TightPass" not in self.complained:
        if not self.singleE27eta2p1TightPass_branch and "singleE27eta2p1TightPass":
            warnings.warn( "MuMuMuTree: Expected branch singleE27eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1TightPass")
        else:
            self.singleE27eta2p1TightPass_branch.SetAddress(<void*>&self.singleE27eta2p1TightPass_value)

        #print "making singleE27eta2p1TightPrescale"
        self.singleE27eta2p1TightPrescale_branch = the_tree.GetBranch("singleE27eta2p1TightPrescale")
        #if not self.singleE27eta2p1TightPrescale_branch and "singleE27eta2p1TightPrescale" not in self.complained:
        if not self.singleE27eta2p1TightPrescale_branch and "singleE27eta2p1TightPrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE27eta2p1TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1TightPrescale")
        else:
            self.singleE27eta2p1TightPrescale_branch.SetAddress(<void*>&self.singleE27eta2p1TightPrescale_value)

        #print "making singleE32SingleTau20SingleL1Group"
        self.singleE32SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE32SingleTau20SingleL1Group")
        #if not self.singleE32SingleTau20SingleL1Group_branch and "singleE32SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE32SingleTau20SingleL1Group_branch and "singleE32SingleTau20SingleL1Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE32SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE32SingleTau20SingleL1Group")
        else:
            self.singleE32SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE32SingleTau20SingleL1Group_value)

        #print "making singleE32SingleTau20SingleL1Pass"
        self.singleE32SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE32SingleTau20SingleL1Pass")
        #if not self.singleE32SingleTau20SingleL1Pass_branch and "singleE32SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE32SingleTau20SingleL1Pass_branch and "singleE32SingleTau20SingleL1Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE32SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE32SingleTau20SingleL1Pass")
        else:
            self.singleE32SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE32SingleTau20SingleL1Pass_value)

        #print "making singleE32SingleTau20SingleL1Prescale"
        self.singleE32SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE32SingleTau20SingleL1Prescale")
        #if not self.singleE32SingleTau20SingleL1Prescale_branch and "singleE32SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE32SingleTau20SingleL1Prescale_branch and "singleE32SingleTau20SingleL1Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE32SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE32SingleTau20SingleL1Prescale")
        else:
            self.singleE32SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE32SingleTau20SingleL1Prescale_value)

        #print "making singleE36SingleTau30Group"
        self.singleE36SingleTau30Group_branch = the_tree.GetBranch("singleE36SingleTau30Group")
        #if not self.singleE36SingleTau30Group_branch and "singleE36SingleTau30Group" not in self.complained:
        if not self.singleE36SingleTau30Group_branch and "singleE36SingleTau30Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE36SingleTau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE36SingleTau30Group")
        else:
            self.singleE36SingleTau30Group_branch.SetAddress(<void*>&self.singleE36SingleTau30Group_value)

        #print "making singleE36SingleTau30Pass"
        self.singleE36SingleTau30Pass_branch = the_tree.GetBranch("singleE36SingleTau30Pass")
        #if not self.singleE36SingleTau30Pass_branch and "singleE36SingleTau30Pass" not in self.complained:
        if not self.singleE36SingleTau30Pass_branch and "singleE36SingleTau30Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE36SingleTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE36SingleTau30Pass")
        else:
            self.singleE36SingleTau30Pass_branch.SetAddress(<void*>&self.singleE36SingleTau30Pass_value)

        #print "making singleE36SingleTau30Prescale"
        self.singleE36SingleTau30Prescale_branch = the_tree.GetBranch("singleE36SingleTau30Prescale")
        #if not self.singleE36SingleTau30Prescale_branch and "singleE36SingleTau30Prescale" not in self.complained:
        if not self.singleE36SingleTau30Prescale_branch and "singleE36SingleTau30Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE36SingleTau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE36SingleTau30Prescale")
        else:
            self.singleE36SingleTau30Prescale_branch.SetAddress(<void*>&self.singleE36SingleTau30Prescale_value)

        #print "making singleESingleMuGroup"
        self.singleESingleMuGroup_branch = the_tree.GetBranch("singleESingleMuGroup")
        #if not self.singleESingleMuGroup_branch and "singleESingleMuGroup" not in self.complained:
        if not self.singleESingleMuGroup_branch and "singleESingleMuGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleESingleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleESingleMuGroup")
        else:
            self.singleESingleMuGroup_branch.SetAddress(<void*>&self.singleESingleMuGroup_value)

        #print "making singleESingleMuPass"
        self.singleESingleMuPass_branch = the_tree.GetBranch("singleESingleMuPass")
        #if not self.singleESingleMuPass_branch and "singleESingleMuPass" not in self.complained:
        if not self.singleESingleMuPass_branch and "singleESingleMuPass":
            warnings.warn( "MuMuMuTree: Expected branch singleESingleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleESingleMuPass")
        else:
            self.singleESingleMuPass_branch.SetAddress(<void*>&self.singleESingleMuPass_value)

        #print "making singleESingleMuPrescale"
        self.singleESingleMuPrescale_branch = the_tree.GetBranch("singleESingleMuPrescale")
        #if not self.singleESingleMuPrescale_branch and "singleESingleMuPrescale" not in self.complained:
        if not self.singleESingleMuPrescale_branch and "singleESingleMuPrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleESingleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleESingleMuPrescale")
        else:
            self.singleESingleMuPrescale_branch.SetAddress(<void*>&self.singleESingleMuPrescale_value)

        #print "making singleE_leg1Group"
        self.singleE_leg1Group_branch = the_tree.GetBranch("singleE_leg1Group")
        #if not self.singleE_leg1Group_branch and "singleE_leg1Group" not in self.complained:
        if not self.singleE_leg1Group_branch and "singleE_leg1Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE_leg1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg1Group")
        else:
            self.singleE_leg1Group_branch.SetAddress(<void*>&self.singleE_leg1Group_value)

        #print "making singleE_leg1Pass"
        self.singleE_leg1Pass_branch = the_tree.GetBranch("singleE_leg1Pass")
        #if not self.singleE_leg1Pass_branch and "singleE_leg1Pass" not in self.complained:
        if not self.singleE_leg1Pass_branch and "singleE_leg1Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE_leg1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg1Pass")
        else:
            self.singleE_leg1Pass_branch.SetAddress(<void*>&self.singleE_leg1Pass_value)

        #print "making singleE_leg1Prescale"
        self.singleE_leg1Prescale_branch = the_tree.GetBranch("singleE_leg1Prescale")
        #if not self.singleE_leg1Prescale_branch and "singleE_leg1Prescale" not in self.complained:
        if not self.singleE_leg1Prescale_branch and "singleE_leg1Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE_leg1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg1Prescale")
        else:
            self.singleE_leg1Prescale_branch.SetAddress(<void*>&self.singleE_leg1Prescale_value)

        #print "making singleE_leg2Group"
        self.singleE_leg2Group_branch = the_tree.GetBranch("singleE_leg2Group")
        #if not self.singleE_leg2Group_branch and "singleE_leg2Group" not in self.complained:
        if not self.singleE_leg2Group_branch and "singleE_leg2Group":
            warnings.warn( "MuMuMuTree: Expected branch singleE_leg2Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg2Group")
        else:
            self.singleE_leg2Group_branch.SetAddress(<void*>&self.singleE_leg2Group_value)

        #print "making singleE_leg2Pass"
        self.singleE_leg2Pass_branch = the_tree.GetBranch("singleE_leg2Pass")
        #if not self.singleE_leg2Pass_branch and "singleE_leg2Pass" not in self.complained:
        if not self.singleE_leg2Pass_branch and "singleE_leg2Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleE_leg2Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg2Pass")
        else:
            self.singleE_leg2Pass_branch.SetAddress(<void*>&self.singleE_leg2Pass_value)

        #print "making singleE_leg2Prescale"
        self.singleE_leg2Prescale_branch = the_tree.GetBranch("singleE_leg2Prescale")
        #if not self.singleE_leg2Prescale_branch and "singleE_leg2Prescale" not in self.complained:
        if not self.singleE_leg2Prescale_branch and "singleE_leg2Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleE_leg2Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE_leg2Prescale")
        else:
            self.singleE_leg2Prescale_branch.SetAddress(<void*>&self.singleE_leg2Prescale_value)

        #print "making singleIsoMu18Group"
        self.singleIsoMu18Group_branch = the_tree.GetBranch("singleIsoMu18Group")
        #if not self.singleIsoMu18Group_branch and "singleIsoMu18Group" not in self.complained:
        if not self.singleIsoMu18Group_branch and "singleIsoMu18Group":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu18Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu18Group")
        else:
            self.singleIsoMu18Group_branch.SetAddress(<void*>&self.singleIsoMu18Group_value)

        #print "making singleIsoMu18Pass"
        self.singleIsoMu18Pass_branch = the_tree.GetBranch("singleIsoMu18Pass")
        #if not self.singleIsoMu18Pass_branch and "singleIsoMu18Pass" not in self.complained:
        if not self.singleIsoMu18Pass_branch and "singleIsoMu18Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu18Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu18Pass")
        else:
            self.singleIsoMu18Pass_branch.SetAddress(<void*>&self.singleIsoMu18Pass_value)

        #print "making singleIsoMu18Prescale"
        self.singleIsoMu18Prescale_branch = the_tree.GetBranch("singleIsoMu18Prescale")
        #if not self.singleIsoMu18Prescale_branch and "singleIsoMu18Prescale" not in self.complained:
        if not self.singleIsoMu18Prescale_branch and "singleIsoMu18Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu18Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu18Prescale")
        else:
            self.singleIsoMu18Prescale_branch.SetAddress(<void*>&self.singleIsoMu18Prescale_value)

        #print "making singleIsoMu20Group"
        self.singleIsoMu20Group_branch = the_tree.GetBranch("singleIsoMu20Group")
        #if not self.singleIsoMu20Group_branch and "singleIsoMu20Group" not in self.complained:
        if not self.singleIsoMu20Group_branch and "singleIsoMu20Group":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Group")
        else:
            self.singleIsoMu20Group_branch.SetAddress(<void*>&self.singleIsoMu20Group_value)

        #print "making singleIsoMu20Pass"
        self.singleIsoMu20Pass_branch = the_tree.GetBranch("singleIsoMu20Pass")
        #if not self.singleIsoMu20Pass_branch and "singleIsoMu20Pass" not in self.complained:
        if not self.singleIsoMu20Pass_branch and "singleIsoMu20Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Pass")
        else:
            self.singleIsoMu20Pass_branch.SetAddress(<void*>&self.singleIsoMu20Pass_value)

        #print "making singleIsoMu20Prescale"
        self.singleIsoMu20Prescale_branch = the_tree.GetBranch("singleIsoMu20Prescale")
        #if not self.singleIsoMu20Prescale_branch and "singleIsoMu20Prescale" not in self.complained:
        if not self.singleIsoMu20Prescale_branch and "singleIsoMu20Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Prescale")
        else:
            self.singleIsoMu20Prescale_branch.SetAddress(<void*>&self.singleIsoMu20Prescale_value)

        #print "making singleIsoMu22Group"
        self.singleIsoMu22Group_branch = the_tree.GetBranch("singleIsoMu22Group")
        #if not self.singleIsoMu22Group_branch and "singleIsoMu22Group" not in self.complained:
        if not self.singleIsoMu22Group_branch and "singleIsoMu22Group":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu22Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Group")
        else:
            self.singleIsoMu22Group_branch.SetAddress(<void*>&self.singleIsoMu22Group_value)

        #print "making singleIsoMu22Pass"
        self.singleIsoMu22Pass_branch = the_tree.GetBranch("singleIsoMu22Pass")
        #if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass" not in self.complained:
        if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Pass")
        else:
            self.singleIsoMu22Pass_branch.SetAddress(<void*>&self.singleIsoMu22Pass_value)

        #print "making singleIsoMu22Prescale"
        self.singleIsoMu22Prescale_branch = the_tree.GetBranch("singleIsoMu22Prescale")
        #if not self.singleIsoMu22Prescale_branch and "singleIsoMu22Prescale" not in self.complained:
        if not self.singleIsoMu22Prescale_branch and "singleIsoMu22Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu22Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Prescale")
        else:
            self.singleIsoMu22Prescale_branch.SetAddress(<void*>&self.singleIsoMu22Prescale_value)

        #print "making singleIsoMu22eta2p1Group"
        self.singleIsoMu22eta2p1Group_branch = the_tree.GetBranch("singleIsoMu22eta2p1Group")
        #if not self.singleIsoMu22eta2p1Group_branch and "singleIsoMu22eta2p1Group" not in self.complained:
        if not self.singleIsoMu22eta2p1Group_branch and "singleIsoMu22eta2p1Group":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu22eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Group")
        else:
            self.singleIsoMu22eta2p1Group_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Group_value)

        #print "making singleIsoMu22eta2p1Pass"
        self.singleIsoMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu22eta2p1Pass")
        #if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Pass")
        else:
            self.singleIsoMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Pass_value)

        #print "making singleIsoMu22eta2p1Prescale"
        self.singleIsoMu22eta2p1Prescale_branch = the_tree.GetBranch("singleIsoMu22eta2p1Prescale")
        #if not self.singleIsoMu22eta2p1Prescale_branch and "singleIsoMu22eta2p1Prescale" not in self.complained:
        if not self.singleIsoMu22eta2p1Prescale_branch and "singleIsoMu22eta2p1Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu22eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Prescale")
        else:
            self.singleIsoMu22eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Prescale_value)

        #print "making singleIsoMu24Group"
        self.singleIsoMu24Group_branch = the_tree.GetBranch("singleIsoMu24Group")
        #if not self.singleIsoMu24Group_branch and "singleIsoMu24Group" not in self.complained:
        if not self.singleIsoMu24Group_branch and "singleIsoMu24Group":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu24Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Group")
        else:
            self.singleIsoMu24Group_branch.SetAddress(<void*>&self.singleIsoMu24Group_value)

        #print "making singleIsoMu24Pass"
        self.singleIsoMu24Pass_branch = the_tree.GetBranch("singleIsoMu24Pass")
        #if not self.singleIsoMu24Pass_branch and "singleIsoMu24Pass" not in self.complained:
        if not self.singleIsoMu24Pass_branch and "singleIsoMu24Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Pass")
        else:
            self.singleIsoMu24Pass_branch.SetAddress(<void*>&self.singleIsoMu24Pass_value)

        #print "making singleIsoMu24Prescale"
        self.singleIsoMu24Prescale_branch = the_tree.GetBranch("singleIsoMu24Prescale")
        #if not self.singleIsoMu24Prescale_branch and "singleIsoMu24Prescale" not in self.complained:
        if not self.singleIsoMu24Prescale_branch and "singleIsoMu24Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu24Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Prescale")
        else:
            self.singleIsoMu24Prescale_branch.SetAddress(<void*>&self.singleIsoMu24Prescale_value)

        #print "making singleIsoMu27Group"
        self.singleIsoMu27Group_branch = the_tree.GetBranch("singleIsoMu27Group")
        #if not self.singleIsoMu27Group_branch and "singleIsoMu27Group" not in self.complained:
        if not self.singleIsoMu27Group_branch and "singleIsoMu27Group":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu27Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Group")
        else:
            self.singleIsoMu27Group_branch.SetAddress(<void*>&self.singleIsoMu27Group_value)

        #print "making singleIsoMu27Pass"
        self.singleIsoMu27Pass_branch = the_tree.GetBranch("singleIsoMu27Pass")
        #if not self.singleIsoMu27Pass_branch and "singleIsoMu27Pass" not in self.complained:
        if not self.singleIsoMu27Pass_branch and "singleIsoMu27Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Pass")
        else:
            self.singleIsoMu27Pass_branch.SetAddress(<void*>&self.singleIsoMu27Pass_value)

        #print "making singleIsoMu27Prescale"
        self.singleIsoMu27Prescale_branch = the_tree.GetBranch("singleIsoMu27Prescale")
        #if not self.singleIsoMu27Prescale_branch and "singleIsoMu27Prescale" not in self.complained:
        if not self.singleIsoMu27Prescale_branch and "singleIsoMu27Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu27Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Prescale")
        else:
            self.singleIsoMu27Prescale_branch.SetAddress(<void*>&self.singleIsoMu27Prescale_value)

        #print "making singleIsoTkMu20Group"
        self.singleIsoTkMu20Group_branch = the_tree.GetBranch("singleIsoTkMu20Group")
        #if not self.singleIsoTkMu20Group_branch and "singleIsoTkMu20Group" not in self.complained:
        if not self.singleIsoTkMu20Group_branch and "singleIsoTkMu20Group":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu20Group")
        else:
            self.singleIsoTkMu20Group_branch.SetAddress(<void*>&self.singleIsoTkMu20Group_value)

        #print "making singleIsoTkMu20Pass"
        self.singleIsoTkMu20Pass_branch = the_tree.GetBranch("singleIsoTkMu20Pass")
        #if not self.singleIsoTkMu20Pass_branch and "singleIsoTkMu20Pass" not in self.complained:
        if not self.singleIsoTkMu20Pass_branch and "singleIsoTkMu20Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu20Pass")
        else:
            self.singleIsoTkMu20Pass_branch.SetAddress(<void*>&self.singleIsoTkMu20Pass_value)

        #print "making singleIsoTkMu20Prescale"
        self.singleIsoTkMu20Prescale_branch = the_tree.GetBranch("singleIsoTkMu20Prescale")
        #if not self.singleIsoTkMu20Prescale_branch and "singleIsoTkMu20Prescale" not in self.complained:
        if not self.singleIsoTkMu20Prescale_branch and "singleIsoTkMu20Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu20Prescale")
        else:
            self.singleIsoTkMu20Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu20Prescale_value)

        #print "making singleIsoTkMu22Group"
        self.singleIsoTkMu22Group_branch = the_tree.GetBranch("singleIsoTkMu22Group")
        #if not self.singleIsoTkMu22Group_branch and "singleIsoTkMu22Group" not in self.complained:
        if not self.singleIsoTkMu22Group_branch and "singleIsoTkMu22Group":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu22Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Group")
        else:
            self.singleIsoTkMu22Group_branch.SetAddress(<void*>&self.singleIsoTkMu22Group_value)

        #print "making singleIsoTkMu22Pass"
        self.singleIsoTkMu22Pass_branch = the_tree.GetBranch("singleIsoTkMu22Pass")
        #if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass" not in self.complained:
        if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Pass")
        else:
            self.singleIsoTkMu22Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22Pass_value)

        #print "making singleIsoTkMu22Prescale"
        self.singleIsoTkMu22Prescale_branch = the_tree.GetBranch("singleIsoTkMu22Prescale")
        #if not self.singleIsoTkMu22Prescale_branch and "singleIsoTkMu22Prescale" not in self.complained:
        if not self.singleIsoTkMu22Prescale_branch and "singleIsoTkMu22Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu22Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Prescale")
        else:
            self.singleIsoTkMu22Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu22Prescale_value)

        #print "making singleIsoTkMu22eta2p1Group"
        self.singleIsoTkMu22eta2p1Group_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Group")
        #if not self.singleIsoTkMu22eta2p1Group_branch and "singleIsoTkMu22eta2p1Group" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Group_branch and "singleIsoTkMu22eta2p1Group":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu22eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Group")
        else:
            self.singleIsoTkMu22eta2p1Group_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Group_value)

        #print "making singleIsoTkMu22eta2p1Pass"
        self.singleIsoTkMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Pass")
        #if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Pass")
        else:
            self.singleIsoTkMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Pass_value)

        #print "making singleIsoTkMu22eta2p1Prescale"
        self.singleIsoTkMu22eta2p1Prescale_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Prescale")
        #if not self.singleIsoTkMu22eta2p1Prescale_branch and "singleIsoTkMu22eta2p1Prescale" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Prescale_branch and "singleIsoTkMu22eta2p1Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu22eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Prescale")
        else:
            self.singleIsoTkMu22eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Prescale_value)

        #print "making singleIsoTkMu24Group"
        self.singleIsoTkMu24Group_branch = the_tree.GetBranch("singleIsoTkMu24Group")
        #if not self.singleIsoTkMu24Group_branch and "singleIsoTkMu24Group" not in self.complained:
        if not self.singleIsoTkMu24Group_branch and "singleIsoTkMu24Group":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu24Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Group")
        else:
            self.singleIsoTkMu24Group_branch.SetAddress(<void*>&self.singleIsoTkMu24Group_value)

        #print "making singleIsoTkMu24Pass"
        self.singleIsoTkMu24Pass_branch = the_tree.GetBranch("singleIsoTkMu24Pass")
        #if not self.singleIsoTkMu24Pass_branch and "singleIsoTkMu24Pass" not in self.complained:
        if not self.singleIsoTkMu24Pass_branch and "singleIsoTkMu24Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Pass")
        else:
            self.singleIsoTkMu24Pass_branch.SetAddress(<void*>&self.singleIsoTkMu24Pass_value)

        #print "making singleIsoTkMu24Prescale"
        self.singleIsoTkMu24Prescale_branch = the_tree.GetBranch("singleIsoTkMu24Prescale")
        #if not self.singleIsoTkMu24Prescale_branch and "singleIsoTkMu24Prescale" not in self.complained:
        if not self.singleIsoTkMu24Prescale_branch and "singleIsoTkMu24Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu24Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Prescale")
        else:
            self.singleIsoTkMu24Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu24Prescale_value)

        #print "making singleMu17SingleE12Group"
        self.singleMu17SingleE12Group_branch = the_tree.GetBranch("singleMu17SingleE12Group")
        #if not self.singleMu17SingleE12Group_branch and "singleMu17SingleE12Group" not in self.complained:
        if not self.singleMu17SingleE12Group_branch and "singleMu17SingleE12Group":
            warnings.warn( "MuMuMuTree: Expected branch singleMu17SingleE12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu17SingleE12Group")
        else:
            self.singleMu17SingleE12Group_branch.SetAddress(<void*>&self.singleMu17SingleE12Group_value)

        #print "making singleMu17SingleE12Pass"
        self.singleMu17SingleE12Pass_branch = the_tree.GetBranch("singleMu17SingleE12Pass")
        #if not self.singleMu17SingleE12Pass_branch and "singleMu17SingleE12Pass" not in self.complained:
        if not self.singleMu17SingleE12Pass_branch and "singleMu17SingleE12Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu17SingleE12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu17SingleE12Pass")
        else:
            self.singleMu17SingleE12Pass_branch.SetAddress(<void*>&self.singleMu17SingleE12Pass_value)

        #print "making singleMu17SingleE12Prescale"
        self.singleMu17SingleE12Prescale_branch = the_tree.GetBranch("singleMu17SingleE12Prescale")
        #if not self.singleMu17SingleE12Prescale_branch and "singleMu17SingleE12Prescale" not in self.complained:
        if not self.singleMu17SingleE12Prescale_branch and "singleMu17SingleE12Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMu17SingleE12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu17SingleE12Prescale")
        else:
            self.singleMu17SingleE12Prescale_branch.SetAddress(<void*>&self.singleMu17SingleE12Prescale_value)

        #print "making singleMu19eta2p1LooseTau20Group"
        self.singleMu19eta2p1LooseTau20Group_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Group")
        #if not self.singleMu19eta2p1LooseTau20Group_branch and "singleMu19eta2p1LooseTau20Group" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Group_branch and "singleMu19eta2p1LooseTau20Group":
            warnings.warn( "MuMuMuTree: Expected branch singleMu19eta2p1LooseTau20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Group")
        else:
            self.singleMu19eta2p1LooseTau20Group_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Group_value)

        #print "making singleMu19eta2p1LooseTau20Pass"
        self.singleMu19eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Pass")
        #if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu19eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Pass")
        else:
            self.singleMu19eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Pass_value)

        #print "making singleMu19eta2p1LooseTau20Prescale"
        self.singleMu19eta2p1LooseTau20Prescale_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Prescale")
        #if not self.singleMu19eta2p1LooseTau20Prescale_branch and "singleMu19eta2p1LooseTau20Prescale" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Prescale_branch and "singleMu19eta2p1LooseTau20Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMu19eta2p1LooseTau20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Prescale")
        else:
            self.singleMu19eta2p1LooseTau20Prescale_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Prescale_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Group"
        self.singleMu19eta2p1LooseTau20singleL1Group_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Group")
        #if not self.singleMu19eta2p1LooseTau20singleL1Group_branch and "singleMu19eta2p1LooseTau20singleL1Group" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Group_branch and "singleMu19eta2p1LooseTau20singleL1Group":
            warnings.warn( "MuMuMuTree: Expected branch singleMu19eta2p1LooseTau20singleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Group")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Group_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Group_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Pass"
        self.singleMu19eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu19eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Pass_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Prescale"
        self.singleMu19eta2p1LooseTau20singleL1Prescale_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Prescale")
        #if not self.singleMu19eta2p1LooseTau20singleL1Prescale_branch and "singleMu19eta2p1LooseTau20singleL1Prescale" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Prescale_branch and "singleMu19eta2p1LooseTau20singleL1Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMu19eta2p1LooseTau20singleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Prescale")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Prescale_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Prescale_value)

        #print "making singleMu23SingleE12DZGroup"
        self.singleMu23SingleE12DZGroup_branch = the_tree.GetBranch("singleMu23SingleE12DZGroup")
        #if not self.singleMu23SingleE12DZGroup_branch and "singleMu23SingleE12DZGroup" not in self.complained:
        if not self.singleMu23SingleE12DZGroup_branch and "singleMu23SingleE12DZGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleMu23SingleE12DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZGroup")
        else:
            self.singleMu23SingleE12DZGroup_branch.SetAddress(<void*>&self.singleMu23SingleE12DZGroup_value)

        #print "making singleMu23SingleE12DZPass"
        self.singleMu23SingleE12DZPass_branch = the_tree.GetBranch("singleMu23SingleE12DZPass")
        #if not self.singleMu23SingleE12DZPass_branch and "singleMu23SingleE12DZPass" not in self.complained:
        if not self.singleMu23SingleE12DZPass_branch and "singleMu23SingleE12DZPass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu23SingleE12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZPass")
        else:
            self.singleMu23SingleE12DZPass_branch.SetAddress(<void*>&self.singleMu23SingleE12DZPass_value)

        #print "making singleMu23SingleE12DZPrescale"
        self.singleMu23SingleE12DZPrescale_branch = the_tree.GetBranch("singleMu23SingleE12DZPrescale")
        #if not self.singleMu23SingleE12DZPrescale_branch and "singleMu23SingleE12DZPrescale" not in self.complained:
        if not self.singleMu23SingleE12DZPrescale_branch and "singleMu23SingleE12DZPrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMu23SingleE12DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZPrescale")
        else:
            self.singleMu23SingleE12DZPrescale_branch.SetAddress(<void*>&self.singleMu23SingleE12DZPrescale_value)

        #print "making singleMu23SingleE12Group"
        self.singleMu23SingleE12Group_branch = the_tree.GetBranch("singleMu23SingleE12Group")
        #if not self.singleMu23SingleE12Group_branch and "singleMu23SingleE12Group" not in self.complained:
        if not self.singleMu23SingleE12Group_branch and "singleMu23SingleE12Group":
            warnings.warn( "MuMuMuTree: Expected branch singleMu23SingleE12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12Group")
        else:
            self.singleMu23SingleE12Group_branch.SetAddress(<void*>&self.singleMu23SingleE12Group_value)

        #print "making singleMu23SingleE12Pass"
        self.singleMu23SingleE12Pass_branch = the_tree.GetBranch("singleMu23SingleE12Pass")
        #if not self.singleMu23SingleE12Pass_branch and "singleMu23SingleE12Pass" not in self.complained:
        if not self.singleMu23SingleE12Pass_branch and "singleMu23SingleE12Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu23SingleE12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12Pass")
        else:
            self.singleMu23SingleE12Pass_branch.SetAddress(<void*>&self.singleMu23SingleE12Pass_value)

        #print "making singleMu23SingleE12Prescale"
        self.singleMu23SingleE12Prescale_branch = the_tree.GetBranch("singleMu23SingleE12Prescale")
        #if not self.singleMu23SingleE12Prescale_branch and "singleMu23SingleE12Prescale" not in self.complained:
        if not self.singleMu23SingleE12Prescale_branch and "singleMu23SingleE12Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMu23SingleE12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12Prescale")
        else:
            self.singleMu23SingleE12Prescale_branch.SetAddress(<void*>&self.singleMu23SingleE12Prescale_value)

        #print "making singleMu23SingleE8Group"
        self.singleMu23SingleE8Group_branch = the_tree.GetBranch("singleMu23SingleE8Group")
        #if not self.singleMu23SingleE8Group_branch and "singleMu23SingleE8Group" not in self.complained:
        if not self.singleMu23SingleE8Group_branch and "singleMu23SingleE8Group":
            warnings.warn( "MuMuMuTree: Expected branch singleMu23SingleE8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE8Group")
        else:
            self.singleMu23SingleE8Group_branch.SetAddress(<void*>&self.singleMu23SingleE8Group_value)

        #print "making singleMu23SingleE8Pass"
        self.singleMu23SingleE8Pass_branch = the_tree.GetBranch("singleMu23SingleE8Pass")
        #if not self.singleMu23SingleE8Pass_branch and "singleMu23SingleE8Pass" not in self.complained:
        if not self.singleMu23SingleE8Pass_branch and "singleMu23SingleE8Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu23SingleE8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE8Pass")
        else:
            self.singleMu23SingleE8Pass_branch.SetAddress(<void*>&self.singleMu23SingleE8Pass_value)

        #print "making singleMu23SingleE8Prescale"
        self.singleMu23SingleE8Prescale_branch = the_tree.GetBranch("singleMu23SingleE8Prescale")
        #if not self.singleMu23SingleE8Prescale_branch and "singleMu23SingleE8Prescale" not in self.complained:
        if not self.singleMu23SingleE8Prescale_branch and "singleMu23SingleE8Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMu23SingleE8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE8Prescale")
        else:
            self.singleMu23SingleE8Prescale_branch.SetAddress(<void*>&self.singleMu23SingleE8Prescale_value)

        #print "making singleMu8SingleE23DZGroup"
        self.singleMu8SingleE23DZGroup_branch = the_tree.GetBranch("singleMu8SingleE23DZGroup")
        #if not self.singleMu8SingleE23DZGroup_branch and "singleMu8SingleE23DZGroup" not in self.complained:
        if not self.singleMu8SingleE23DZGroup_branch and "singleMu8SingleE23DZGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleMu8SingleE23DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZGroup")
        else:
            self.singleMu8SingleE23DZGroup_branch.SetAddress(<void*>&self.singleMu8SingleE23DZGroup_value)

        #print "making singleMu8SingleE23DZPass"
        self.singleMu8SingleE23DZPass_branch = the_tree.GetBranch("singleMu8SingleE23DZPass")
        #if not self.singleMu8SingleE23DZPass_branch and "singleMu8SingleE23DZPass" not in self.complained:
        if not self.singleMu8SingleE23DZPass_branch and "singleMu8SingleE23DZPass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu8SingleE23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZPass")
        else:
            self.singleMu8SingleE23DZPass_branch.SetAddress(<void*>&self.singleMu8SingleE23DZPass_value)

        #print "making singleMu8SingleE23DZPrescale"
        self.singleMu8SingleE23DZPrescale_branch = the_tree.GetBranch("singleMu8SingleE23DZPrescale")
        #if not self.singleMu8SingleE23DZPrescale_branch and "singleMu8SingleE23DZPrescale" not in self.complained:
        if not self.singleMu8SingleE23DZPrescale_branch and "singleMu8SingleE23DZPrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMu8SingleE23DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZPrescale")
        else:
            self.singleMu8SingleE23DZPrescale_branch.SetAddress(<void*>&self.singleMu8SingleE23DZPrescale_value)

        #print "making singleMuGroup"
        self.singleMuGroup_branch = the_tree.GetBranch("singleMuGroup")
        #if not self.singleMuGroup_branch and "singleMuGroup" not in self.complained:
        if not self.singleMuGroup_branch and "singleMuGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuGroup")
        else:
            self.singleMuGroup_branch.SetAddress(<void*>&self.singleMuGroup_value)

        #print "making singleMuPass"
        self.singleMuPass_branch = the_tree.GetBranch("singleMuPass")
        #if not self.singleMuPass_branch and "singleMuPass" not in self.complained:
        if not self.singleMuPass_branch and "singleMuPass":
            warnings.warn( "MuMuMuTree: Expected branch singleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPass")
        else:
            self.singleMuPass_branch.SetAddress(<void*>&self.singleMuPass_value)

        #print "making singleMuPrescale"
        self.singleMuPrescale_branch = the_tree.GetBranch("singleMuPrescale")
        #if not self.singleMuPrescale_branch and "singleMuPrescale" not in self.complained:
        if not self.singleMuPrescale_branch and "singleMuPrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPrescale")
        else:
            self.singleMuPrescale_branch.SetAddress(<void*>&self.singleMuPrescale_value)

        #print "making singleMuSingleEGroup"
        self.singleMuSingleEGroup_branch = the_tree.GetBranch("singleMuSingleEGroup")
        #if not self.singleMuSingleEGroup_branch and "singleMuSingleEGroup" not in self.complained:
        if not self.singleMuSingleEGroup_branch and "singleMuSingleEGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleMuSingleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuSingleEGroup")
        else:
            self.singleMuSingleEGroup_branch.SetAddress(<void*>&self.singleMuSingleEGroup_value)

        #print "making singleMuSingleEPass"
        self.singleMuSingleEPass_branch = the_tree.GetBranch("singleMuSingleEPass")
        #if not self.singleMuSingleEPass_branch and "singleMuSingleEPass" not in self.complained:
        if not self.singleMuSingleEPass_branch and "singleMuSingleEPass":
            warnings.warn( "MuMuMuTree: Expected branch singleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuSingleEPass")
        else:
            self.singleMuSingleEPass_branch.SetAddress(<void*>&self.singleMuSingleEPass_value)

        #print "making singleMuSingleEPrescale"
        self.singleMuSingleEPrescale_branch = the_tree.GetBranch("singleMuSingleEPrescale")
        #if not self.singleMuSingleEPrescale_branch and "singleMuSingleEPrescale" not in self.complained:
        if not self.singleMuSingleEPrescale_branch and "singleMuSingleEPrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMuSingleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuSingleEPrescale")
        else:
            self.singleMuSingleEPrescale_branch.SetAddress(<void*>&self.singleMuSingleEPrescale_value)

        #print "making singleMu_leg1Group"
        self.singleMu_leg1Group_branch = the_tree.GetBranch("singleMu_leg1Group")
        #if not self.singleMu_leg1Group_branch and "singleMu_leg1Group" not in self.complained:
        if not self.singleMu_leg1Group_branch and "singleMu_leg1Group":
            warnings.warn( "MuMuMuTree: Expected branch singleMu_leg1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Group")
        else:
            self.singleMu_leg1Group_branch.SetAddress(<void*>&self.singleMu_leg1Group_value)

        #print "making singleMu_leg1Pass"
        self.singleMu_leg1Pass_branch = the_tree.GetBranch("singleMu_leg1Pass")
        #if not self.singleMu_leg1Pass_branch and "singleMu_leg1Pass" not in self.complained:
        if not self.singleMu_leg1Pass_branch and "singleMu_leg1Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu_leg1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Pass")
        else:
            self.singleMu_leg1Pass_branch.SetAddress(<void*>&self.singleMu_leg1Pass_value)

        #print "making singleMu_leg1Prescale"
        self.singleMu_leg1Prescale_branch = the_tree.GetBranch("singleMu_leg1Prescale")
        #if not self.singleMu_leg1Prescale_branch and "singleMu_leg1Prescale" not in self.complained:
        if not self.singleMu_leg1Prescale_branch and "singleMu_leg1Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMu_leg1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Prescale")
        else:
            self.singleMu_leg1Prescale_branch.SetAddress(<void*>&self.singleMu_leg1Prescale_value)

        #print "making singleMu_leg1_noisoGroup"
        self.singleMu_leg1_noisoGroup_branch = the_tree.GetBranch("singleMu_leg1_noisoGroup")
        #if not self.singleMu_leg1_noisoGroup_branch and "singleMu_leg1_noisoGroup" not in self.complained:
        if not self.singleMu_leg1_noisoGroup_branch and "singleMu_leg1_noisoGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleMu_leg1_noisoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoGroup")
        else:
            self.singleMu_leg1_noisoGroup_branch.SetAddress(<void*>&self.singleMu_leg1_noisoGroup_value)

        #print "making singleMu_leg1_noisoPass"
        self.singleMu_leg1_noisoPass_branch = the_tree.GetBranch("singleMu_leg1_noisoPass")
        #if not self.singleMu_leg1_noisoPass_branch and "singleMu_leg1_noisoPass" not in self.complained:
        if not self.singleMu_leg1_noisoPass_branch and "singleMu_leg1_noisoPass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu_leg1_noisoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoPass")
        else:
            self.singleMu_leg1_noisoPass_branch.SetAddress(<void*>&self.singleMu_leg1_noisoPass_value)

        #print "making singleMu_leg1_noisoPrescale"
        self.singleMu_leg1_noisoPrescale_branch = the_tree.GetBranch("singleMu_leg1_noisoPrescale")
        #if not self.singleMu_leg1_noisoPrescale_branch and "singleMu_leg1_noisoPrescale" not in self.complained:
        if not self.singleMu_leg1_noisoPrescale_branch and "singleMu_leg1_noisoPrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMu_leg1_noisoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoPrescale")
        else:
            self.singleMu_leg1_noisoPrescale_branch.SetAddress(<void*>&self.singleMu_leg1_noisoPrescale_value)

        #print "making singleMu_leg2Group"
        self.singleMu_leg2Group_branch = the_tree.GetBranch("singleMu_leg2Group")
        #if not self.singleMu_leg2Group_branch and "singleMu_leg2Group" not in self.complained:
        if not self.singleMu_leg2Group_branch and "singleMu_leg2Group":
            warnings.warn( "MuMuMuTree: Expected branch singleMu_leg2Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Group")
        else:
            self.singleMu_leg2Group_branch.SetAddress(<void*>&self.singleMu_leg2Group_value)

        #print "making singleMu_leg2Pass"
        self.singleMu_leg2Pass_branch = the_tree.GetBranch("singleMu_leg2Pass")
        #if not self.singleMu_leg2Pass_branch and "singleMu_leg2Pass" not in self.complained:
        if not self.singleMu_leg2Pass_branch and "singleMu_leg2Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu_leg2Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Pass")
        else:
            self.singleMu_leg2Pass_branch.SetAddress(<void*>&self.singleMu_leg2Pass_value)

        #print "making singleMu_leg2Prescale"
        self.singleMu_leg2Prescale_branch = the_tree.GetBranch("singleMu_leg2Prescale")
        #if not self.singleMu_leg2Prescale_branch and "singleMu_leg2Prescale" not in self.complained:
        if not self.singleMu_leg2Prescale_branch and "singleMu_leg2Prescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMu_leg2Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Prescale")
        else:
            self.singleMu_leg2Prescale_branch.SetAddress(<void*>&self.singleMu_leg2Prescale_value)

        #print "making singleMu_leg2_noisoGroup"
        self.singleMu_leg2_noisoGroup_branch = the_tree.GetBranch("singleMu_leg2_noisoGroup")
        #if not self.singleMu_leg2_noisoGroup_branch and "singleMu_leg2_noisoGroup" not in self.complained:
        if not self.singleMu_leg2_noisoGroup_branch and "singleMu_leg2_noisoGroup":
            warnings.warn( "MuMuMuTree: Expected branch singleMu_leg2_noisoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoGroup")
        else:
            self.singleMu_leg2_noisoGroup_branch.SetAddress(<void*>&self.singleMu_leg2_noisoGroup_value)

        #print "making singleMu_leg2_noisoPass"
        self.singleMu_leg2_noisoPass_branch = the_tree.GetBranch("singleMu_leg2_noisoPass")
        #if not self.singleMu_leg2_noisoPass_branch and "singleMu_leg2_noisoPass" not in self.complained:
        if not self.singleMu_leg2_noisoPass_branch and "singleMu_leg2_noisoPass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu_leg2_noisoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoPass")
        else:
            self.singleMu_leg2_noisoPass_branch.SetAddress(<void*>&self.singleMu_leg2_noisoPass_value)

        #print "making singleMu_leg2_noisoPrescale"
        self.singleMu_leg2_noisoPrescale_branch = the_tree.GetBranch("singleMu_leg2_noisoPrescale")
        #if not self.singleMu_leg2_noisoPrescale_branch and "singleMu_leg2_noisoPrescale" not in self.complained:
        if not self.singleMu_leg2_noisoPrescale_branch and "singleMu_leg2_noisoPrescale":
            warnings.warn( "MuMuMuTree: Expected branch singleMu_leg2_noisoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoPrescale")
        else:
            self.singleMu_leg2_noisoPrescale_branch.SetAddress(<void*>&self.singleMu_leg2_noisoPrescale_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "MuMuMuTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "MuMuMuTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "MuMuMuTree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "MuMuMuTree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

        #print "making tripleEGroup"
        self.tripleEGroup_branch = the_tree.GetBranch("tripleEGroup")
        #if not self.tripleEGroup_branch and "tripleEGroup" not in self.complained:
        if not self.tripleEGroup_branch and "tripleEGroup":
            warnings.warn( "MuMuMuTree: Expected branch tripleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEGroup")
        else:
            self.tripleEGroup_branch.SetAddress(<void*>&self.tripleEGroup_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "MuMuMuTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleEPrescale"
        self.tripleEPrescale_branch = the_tree.GetBranch("tripleEPrescale")
        #if not self.tripleEPrescale_branch and "tripleEPrescale" not in self.complained:
        if not self.tripleEPrescale_branch and "tripleEPrescale":
            warnings.warn( "MuMuMuTree: Expected branch tripleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPrescale")
        else:
            self.tripleEPrescale_branch.SetAddress(<void*>&self.tripleEPrescale_value)

        #print "making tripleMuGroup"
        self.tripleMuGroup_branch = the_tree.GetBranch("tripleMuGroup")
        #if not self.tripleMuGroup_branch and "tripleMuGroup" not in self.complained:
        if not self.tripleMuGroup_branch and "tripleMuGroup":
            warnings.warn( "MuMuMuTree: Expected branch tripleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuGroup")
        else:
            self.tripleMuGroup_branch.SetAddress(<void*>&self.tripleMuGroup_value)

        #print "making tripleMuPass"
        self.tripleMuPass_branch = the_tree.GetBranch("tripleMuPass")
        #if not self.tripleMuPass_branch and "tripleMuPass" not in self.complained:
        if not self.tripleMuPass_branch and "tripleMuPass":
            warnings.warn( "MuMuMuTree: Expected branch tripleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuPass")
        else:
            self.tripleMuPass_branch.SetAddress(<void*>&self.tripleMuPass_value)

        #print "making tripleMuPrescale"
        self.tripleMuPrescale_branch = the_tree.GetBranch("tripleMuPrescale")
        #if not self.tripleMuPrescale_branch and "tripleMuPrescale" not in self.complained:
        if not self.tripleMuPrescale_branch and "tripleMuPrescale":
            warnings.warn( "MuMuMuTree: Expected branch tripleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuPrescale")
        else:
            self.tripleMuPrescale_branch.SetAddress(<void*>&self.tripleMuPrescale_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making type1_pfMet_shiftedPhi_ElectronEnDown"
        self.type1_pfMet_shiftedPhi_ElectronEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_ElectronEnDown")
        #if not self.type1_pfMet_shiftedPhi_ElectronEnDown_branch and "type1_pfMet_shiftedPhi_ElectronEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_ElectronEnDown_branch and "type1_pfMet_shiftedPhi_ElectronEnDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_ElectronEnDown")
        else:
            self.type1_pfMet_shiftedPhi_ElectronEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_ElectronEnDown_value)

        #print "making type1_pfMet_shiftedPhi_ElectronEnUp"
        self.type1_pfMet_shiftedPhi_ElectronEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_ElectronEnUp")
        #if not self.type1_pfMet_shiftedPhi_ElectronEnUp_branch and "type1_pfMet_shiftedPhi_ElectronEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_ElectronEnUp_branch and "type1_pfMet_shiftedPhi_ElectronEnUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_ElectronEnUp")
        else:
            self.type1_pfMet_shiftedPhi_ElectronEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_ElectronEnUp_value)

        #print "making type1_pfMet_shiftedPhi_JetEnDown"
        self.type1_pfMet_shiftedPhi_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnDown")
        #if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnDown")
        else:
            self.type1_pfMet_shiftedPhi_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnDown_value)

        #print "making type1_pfMet_shiftedPhi_JetEnUp"
        self.type1_pfMet_shiftedPhi_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnUp")
        #if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnUp")
        else:
            self.type1_pfMet_shiftedPhi_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnUp_value)

        #print "making type1_pfMet_shiftedPhi_JetResDown"
        self.type1_pfMet_shiftedPhi_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResDown")
        #if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResDown")
        else:
            self.type1_pfMet_shiftedPhi_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResDown_value)

        #print "making type1_pfMet_shiftedPhi_JetResUp"
        self.type1_pfMet_shiftedPhi_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResUp")
        #if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResUp")
        else:
            self.type1_pfMet_shiftedPhi_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResUp_value)

        #print "making type1_pfMet_shiftedPhi_MuonEnDown"
        self.type1_pfMet_shiftedPhi_MuonEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_MuonEnDown")
        #if not self.type1_pfMet_shiftedPhi_MuonEnDown_branch and "type1_pfMet_shiftedPhi_MuonEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_MuonEnDown_branch and "type1_pfMet_shiftedPhi_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_MuonEnDown")
        else:
            self.type1_pfMet_shiftedPhi_MuonEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_MuonEnDown_value)

        #print "making type1_pfMet_shiftedPhi_MuonEnUp"
        self.type1_pfMet_shiftedPhi_MuonEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_MuonEnUp")
        #if not self.type1_pfMet_shiftedPhi_MuonEnUp_branch and "type1_pfMet_shiftedPhi_MuonEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_MuonEnUp_branch and "type1_pfMet_shiftedPhi_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_MuonEnUp")
        else:
            self.type1_pfMet_shiftedPhi_MuonEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_MuonEnUp_value)

        #print "making type1_pfMet_shiftedPhi_PhotonEnDown"
        self.type1_pfMet_shiftedPhi_PhotonEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_PhotonEnDown")
        #if not self.type1_pfMet_shiftedPhi_PhotonEnDown_branch and "type1_pfMet_shiftedPhi_PhotonEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_PhotonEnDown_branch and "type1_pfMet_shiftedPhi_PhotonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_PhotonEnDown")
        else:
            self.type1_pfMet_shiftedPhi_PhotonEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_PhotonEnDown_value)

        #print "making type1_pfMet_shiftedPhi_PhotonEnUp"
        self.type1_pfMet_shiftedPhi_PhotonEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_PhotonEnUp")
        #if not self.type1_pfMet_shiftedPhi_PhotonEnUp_branch and "type1_pfMet_shiftedPhi_PhotonEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_PhotonEnUp_branch and "type1_pfMet_shiftedPhi_PhotonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_PhotonEnUp")
        else:
            self.type1_pfMet_shiftedPhi_PhotonEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_PhotonEnUp_value)

        #print "making type1_pfMet_shiftedPhi_TauEnDown"
        self.type1_pfMet_shiftedPhi_TauEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_TauEnDown")
        #if not self.type1_pfMet_shiftedPhi_TauEnDown_branch and "type1_pfMet_shiftedPhi_TauEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_TauEnDown_branch and "type1_pfMet_shiftedPhi_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_TauEnDown")
        else:
            self.type1_pfMet_shiftedPhi_TauEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_TauEnDown_value)

        #print "making type1_pfMet_shiftedPhi_TauEnUp"
        self.type1_pfMet_shiftedPhi_TauEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_TauEnUp")
        #if not self.type1_pfMet_shiftedPhi_TauEnUp_branch and "type1_pfMet_shiftedPhi_TauEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_TauEnUp_branch and "type1_pfMet_shiftedPhi_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_TauEnUp")
        else:
            self.type1_pfMet_shiftedPhi_TauEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_TauEnUp_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnDown"
        self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnUp"
        self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnUp_value)

        #print "making type1_pfMet_shiftedPt_ElectronEnDown"
        self.type1_pfMet_shiftedPt_ElectronEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_ElectronEnDown")
        #if not self.type1_pfMet_shiftedPt_ElectronEnDown_branch and "type1_pfMet_shiftedPt_ElectronEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_ElectronEnDown_branch and "type1_pfMet_shiftedPt_ElectronEnDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_ElectronEnDown")
        else:
            self.type1_pfMet_shiftedPt_ElectronEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_ElectronEnDown_value)

        #print "making type1_pfMet_shiftedPt_ElectronEnUp"
        self.type1_pfMet_shiftedPt_ElectronEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_ElectronEnUp")
        #if not self.type1_pfMet_shiftedPt_ElectronEnUp_branch and "type1_pfMet_shiftedPt_ElectronEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_ElectronEnUp_branch and "type1_pfMet_shiftedPt_ElectronEnUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_ElectronEnUp")
        else:
            self.type1_pfMet_shiftedPt_ElectronEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_ElectronEnUp_value)

        #print "making type1_pfMet_shiftedPt_JetEnDown"
        self.type1_pfMet_shiftedPt_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnDown")
        #if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnDown")
        else:
            self.type1_pfMet_shiftedPt_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnDown_value)

        #print "making type1_pfMet_shiftedPt_JetEnUp"
        self.type1_pfMet_shiftedPt_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnUp")
        #if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnUp")
        else:
            self.type1_pfMet_shiftedPt_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnUp_value)

        #print "making type1_pfMet_shiftedPt_JetResDown"
        self.type1_pfMet_shiftedPt_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResDown")
        #if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResDown")
        else:
            self.type1_pfMet_shiftedPt_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResDown_value)

        #print "making type1_pfMet_shiftedPt_JetResUp"
        self.type1_pfMet_shiftedPt_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResUp")
        #if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResUp")
        else:
            self.type1_pfMet_shiftedPt_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResUp_value)

        #print "making type1_pfMet_shiftedPt_MuonEnDown"
        self.type1_pfMet_shiftedPt_MuonEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_MuonEnDown")
        #if not self.type1_pfMet_shiftedPt_MuonEnDown_branch and "type1_pfMet_shiftedPt_MuonEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_MuonEnDown_branch and "type1_pfMet_shiftedPt_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_MuonEnDown")
        else:
            self.type1_pfMet_shiftedPt_MuonEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_MuonEnDown_value)

        #print "making type1_pfMet_shiftedPt_MuonEnUp"
        self.type1_pfMet_shiftedPt_MuonEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_MuonEnUp")
        #if not self.type1_pfMet_shiftedPt_MuonEnUp_branch and "type1_pfMet_shiftedPt_MuonEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_MuonEnUp_branch and "type1_pfMet_shiftedPt_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_MuonEnUp")
        else:
            self.type1_pfMet_shiftedPt_MuonEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_MuonEnUp_value)

        #print "making type1_pfMet_shiftedPt_PhotonEnDown"
        self.type1_pfMet_shiftedPt_PhotonEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_PhotonEnDown")
        #if not self.type1_pfMet_shiftedPt_PhotonEnDown_branch and "type1_pfMet_shiftedPt_PhotonEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_PhotonEnDown_branch and "type1_pfMet_shiftedPt_PhotonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_PhotonEnDown")
        else:
            self.type1_pfMet_shiftedPt_PhotonEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_PhotonEnDown_value)

        #print "making type1_pfMet_shiftedPt_PhotonEnUp"
        self.type1_pfMet_shiftedPt_PhotonEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_PhotonEnUp")
        #if not self.type1_pfMet_shiftedPt_PhotonEnUp_branch and "type1_pfMet_shiftedPt_PhotonEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_PhotonEnUp_branch and "type1_pfMet_shiftedPt_PhotonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_PhotonEnUp")
        else:
            self.type1_pfMet_shiftedPt_PhotonEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_PhotonEnUp_value)

        #print "making type1_pfMet_shiftedPt_TauEnDown"
        self.type1_pfMet_shiftedPt_TauEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_TauEnDown")
        #if not self.type1_pfMet_shiftedPt_TauEnDown_branch and "type1_pfMet_shiftedPt_TauEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_TauEnDown_branch and "type1_pfMet_shiftedPt_TauEnDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_TauEnDown")
        else:
            self.type1_pfMet_shiftedPt_TauEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_TauEnDown_value)

        #print "making type1_pfMet_shiftedPt_TauEnUp"
        self.type1_pfMet_shiftedPt_TauEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_TauEnUp")
        #if not self.type1_pfMet_shiftedPt_TauEnUp_branch and "type1_pfMet_shiftedPt_TauEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_TauEnUp_branch and "type1_pfMet_shiftedPt_TauEnUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_TauEnUp")
        else:
            self.type1_pfMet_shiftedPt_TauEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_TauEnUp_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnDown"
        self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnUp"
        self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnUp_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "MuMuMuTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfDeta_JetEnDown"
        self.vbfDeta_JetEnDown_branch = the_tree.GetBranch("vbfDeta_JetEnDown")
        #if not self.vbfDeta_JetEnDown_branch and "vbfDeta_JetEnDown" not in self.complained:
        if not self.vbfDeta_JetEnDown_branch and "vbfDeta_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfDeta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta_JetEnDown")
        else:
            self.vbfDeta_JetEnDown_branch.SetAddress(<void*>&self.vbfDeta_JetEnDown_value)

        #print "making vbfDeta_JetEnUp"
        self.vbfDeta_JetEnUp_branch = the_tree.GetBranch("vbfDeta_JetEnUp")
        #if not self.vbfDeta_JetEnUp_branch and "vbfDeta_JetEnUp" not in self.complained:
        if not self.vbfDeta_JetEnUp_branch and "vbfDeta_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfDeta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta_JetEnUp")
        else:
            self.vbfDeta_JetEnUp_branch.SetAddress(<void*>&self.vbfDeta_JetEnUp_value)

        #print "making vbfDijetrap"
        self.vbfDijetrap_branch = the_tree.GetBranch("vbfDijetrap")
        #if not self.vbfDijetrap_branch and "vbfDijetrap" not in self.complained:
        if not self.vbfDijetrap_branch and "vbfDijetrap":
            warnings.warn( "MuMuMuTree: Expected branch vbfDijetrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap")
        else:
            self.vbfDijetrap_branch.SetAddress(<void*>&self.vbfDijetrap_value)

        #print "making vbfDijetrap_JetEnDown"
        self.vbfDijetrap_JetEnDown_branch = the_tree.GetBranch("vbfDijetrap_JetEnDown")
        #if not self.vbfDijetrap_JetEnDown_branch and "vbfDijetrap_JetEnDown" not in self.complained:
        if not self.vbfDijetrap_JetEnDown_branch and "vbfDijetrap_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfDijetrap_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap_JetEnDown")
        else:
            self.vbfDijetrap_JetEnDown_branch.SetAddress(<void*>&self.vbfDijetrap_JetEnDown_value)

        #print "making vbfDijetrap_JetEnUp"
        self.vbfDijetrap_JetEnUp_branch = the_tree.GetBranch("vbfDijetrap_JetEnUp")
        #if not self.vbfDijetrap_JetEnUp_branch and "vbfDijetrap_JetEnUp" not in self.complained:
        if not self.vbfDijetrap_JetEnUp_branch and "vbfDijetrap_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfDijetrap_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap_JetEnUp")
        else:
            self.vbfDijetrap_JetEnUp_branch.SetAddress(<void*>&self.vbfDijetrap_JetEnUp_value)

        #print "making vbfDphi"
        self.vbfDphi_branch = the_tree.GetBranch("vbfDphi")
        #if not self.vbfDphi_branch and "vbfDphi" not in self.complained:
        if not self.vbfDphi_branch and "vbfDphi":
            warnings.warn( "MuMuMuTree: Expected branch vbfDphi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi")
        else:
            self.vbfDphi_branch.SetAddress(<void*>&self.vbfDphi_value)

        #print "making vbfDphi_JetEnDown"
        self.vbfDphi_JetEnDown_branch = the_tree.GetBranch("vbfDphi_JetEnDown")
        #if not self.vbfDphi_JetEnDown_branch and "vbfDphi_JetEnDown" not in self.complained:
        if not self.vbfDphi_JetEnDown_branch and "vbfDphi_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfDphi_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi_JetEnDown")
        else:
            self.vbfDphi_JetEnDown_branch.SetAddress(<void*>&self.vbfDphi_JetEnDown_value)

        #print "making vbfDphi_JetEnUp"
        self.vbfDphi_JetEnUp_branch = the_tree.GetBranch("vbfDphi_JetEnUp")
        #if not self.vbfDphi_JetEnUp_branch and "vbfDphi_JetEnUp" not in self.complained:
        if not self.vbfDphi_JetEnUp_branch and "vbfDphi_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfDphi_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi_JetEnUp")
        else:
            self.vbfDphi_JetEnUp_branch.SetAddress(<void*>&self.vbfDphi_JetEnUp_value)

        #print "making vbfDphihj"
        self.vbfDphihj_branch = the_tree.GetBranch("vbfDphihj")
        #if not self.vbfDphihj_branch and "vbfDphihj" not in self.complained:
        if not self.vbfDphihj_branch and "vbfDphihj":
            warnings.warn( "MuMuMuTree: Expected branch vbfDphihj does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj")
        else:
            self.vbfDphihj_branch.SetAddress(<void*>&self.vbfDphihj_value)

        #print "making vbfDphihj_JetEnDown"
        self.vbfDphihj_JetEnDown_branch = the_tree.GetBranch("vbfDphihj_JetEnDown")
        #if not self.vbfDphihj_JetEnDown_branch and "vbfDphihj_JetEnDown" not in self.complained:
        if not self.vbfDphihj_JetEnDown_branch and "vbfDphihj_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfDphihj_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj_JetEnDown")
        else:
            self.vbfDphihj_JetEnDown_branch.SetAddress(<void*>&self.vbfDphihj_JetEnDown_value)

        #print "making vbfDphihj_JetEnUp"
        self.vbfDphihj_JetEnUp_branch = the_tree.GetBranch("vbfDphihj_JetEnUp")
        #if not self.vbfDphihj_JetEnUp_branch and "vbfDphihj_JetEnUp" not in self.complained:
        if not self.vbfDphihj_JetEnUp_branch and "vbfDphihj_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfDphihj_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj_JetEnUp")
        else:
            self.vbfDphihj_JetEnUp_branch.SetAddress(<void*>&self.vbfDphihj_JetEnUp_value)

        #print "making vbfDphihjnomet"
        self.vbfDphihjnomet_branch = the_tree.GetBranch("vbfDphihjnomet")
        #if not self.vbfDphihjnomet_branch and "vbfDphihjnomet" not in self.complained:
        if not self.vbfDphihjnomet_branch and "vbfDphihjnomet":
            warnings.warn( "MuMuMuTree: Expected branch vbfDphihjnomet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet")
        else:
            self.vbfDphihjnomet_branch.SetAddress(<void*>&self.vbfDphihjnomet_value)

        #print "making vbfDphihjnomet_JetEnDown"
        self.vbfDphihjnomet_JetEnDown_branch = the_tree.GetBranch("vbfDphihjnomet_JetEnDown")
        #if not self.vbfDphihjnomet_JetEnDown_branch and "vbfDphihjnomet_JetEnDown" not in self.complained:
        if not self.vbfDphihjnomet_JetEnDown_branch and "vbfDphihjnomet_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfDphihjnomet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet_JetEnDown")
        else:
            self.vbfDphihjnomet_JetEnDown_branch.SetAddress(<void*>&self.vbfDphihjnomet_JetEnDown_value)

        #print "making vbfDphihjnomet_JetEnUp"
        self.vbfDphihjnomet_JetEnUp_branch = the_tree.GetBranch("vbfDphihjnomet_JetEnUp")
        #if not self.vbfDphihjnomet_JetEnUp_branch and "vbfDphihjnomet_JetEnUp" not in self.complained:
        if not self.vbfDphihjnomet_JetEnUp_branch and "vbfDphihjnomet_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfDphihjnomet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet_JetEnUp")
        else:
            self.vbfDphihjnomet_JetEnUp_branch.SetAddress(<void*>&self.vbfDphihjnomet_JetEnUp_value)

        #print "making vbfHrap"
        self.vbfHrap_branch = the_tree.GetBranch("vbfHrap")
        #if not self.vbfHrap_branch and "vbfHrap" not in self.complained:
        if not self.vbfHrap_branch and "vbfHrap":
            warnings.warn( "MuMuMuTree: Expected branch vbfHrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap")
        else:
            self.vbfHrap_branch.SetAddress(<void*>&self.vbfHrap_value)

        #print "making vbfHrap_JetEnDown"
        self.vbfHrap_JetEnDown_branch = the_tree.GetBranch("vbfHrap_JetEnDown")
        #if not self.vbfHrap_JetEnDown_branch and "vbfHrap_JetEnDown" not in self.complained:
        if not self.vbfHrap_JetEnDown_branch and "vbfHrap_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfHrap_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap_JetEnDown")
        else:
            self.vbfHrap_JetEnDown_branch.SetAddress(<void*>&self.vbfHrap_JetEnDown_value)

        #print "making vbfHrap_JetEnUp"
        self.vbfHrap_JetEnUp_branch = the_tree.GetBranch("vbfHrap_JetEnUp")
        #if not self.vbfHrap_JetEnUp_branch and "vbfHrap_JetEnUp" not in self.complained:
        if not self.vbfHrap_JetEnUp_branch and "vbfHrap_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfHrap_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap_JetEnUp")
        else:
            self.vbfHrap_JetEnUp_branch.SetAddress(<void*>&self.vbfHrap_JetEnUp_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "MuMuMuTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto20_JetEnDown"
        self.vbfJetVeto20_JetEnDown_branch = the_tree.GetBranch("vbfJetVeto20_JetEnDown")
        #if not self.vbfJetVeto20_JetEnDown_branch and "vbfJetVeto20_JetEnDown" not in self.complained:
        if not self.vbfJetVeto20_JetEnDown_branch and "vbfJetVeto20_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfJetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20_JetEnDown")
        else:
            self.vbfJetVeto20_JetEnDown_branch.SetAddress(<void*>&self.vbfJetVeto20_JetEnDown_value)

        #print "making vbfJetVeto20_JetEnUp"
        self.vbfJetVeto20_JetEnUp_branch = the_tree.GetBranch("vbfJetVeto20_JetEnUp")
        #if not self.vbfJetVeto20_JetEnUp_branch and "vbfJetVeto20_JetEnUp" not in self.complained:
        if not self.vbfJetVeto20_JetEnUp_branch and "vbfJetVeto20_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfJetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20_JetEnUp")
        else:
            self.vbfJetVeto20_JetEnUp_branch.SetAddress(<void*>&self.vbfJetVeto20_JetEnUp_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "MuMuMuTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfJetVeto30_JetEnDown"
        self.vbfJetVeto30_JetEnDown_branch = the_tree.GetBranch("vbfJetVeto30_JetEnDown")
        #if not self.vbfJetVeto30_JetEnDown_branch and "vbfJetVeto30_JetEnDown" not in self.complained:
        if not self.vbfJetVeto30_JetEnDown_branch and "vbfJetVeto30_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfJetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30_JetEnDown")
        else:
            self.vbfJetVeto30_JetEnDown_branch.SetAddress(<void*>&self.vbfJetVeto30_JetEnDown_value)

        #print "making vbfJetVeto30_JetEnUp"
        self.vbfJetVeto30_JetEnUp_branch = the_tree.GetBranch("vbfJetVeto30_JetEnUp")
        #if not self.vbfJetVeto30_JetEnUp_branch and "vbfJetVeto30_JetEnUp" not in self.complained:
        if not self.vbfJetVeto30_JetEnUp_branch and "vbfJetVeto30_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfJetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30_JetEnUp")
        else:
            self.vbfJetVeto30_JetEnUp_branch.SetAddress(<void*>&self.vbfJetVeto30_JetEnUp_value)

        #print "making vbfMVA"
        self.vbfMVA_branch = the_tree.GetBranch("vbfMVA")
        #if not self.vbfMVA_branch and "vbfMVA" not in self.complained:
        if not self.vbfMVA_branch and "vbfMVA":
            warnings.warn( "MuMuMuTree: Expected branch vbfMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA")
        else:
            self.vbfMVA_branch.SetAddress(<void*>&self.vbfMVA_value)

        #print "making vbfMVA_JetEnDown"
        self.vbfMVA_JetEnDown_branch = the_tree.GetBranch("vbfMVA_JetEnDown")
        #if not self.vbfMVA_JetEnDown_branch and "vbfMVA_JetEnDown" not in self.complained:
        if not self.vbfMVA_JetEnDown_branch and "vbfMVA_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfMVA_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA_JetEnDown")
        else:
            self.vbfMVA_JetEnDown_branch.SetAddress(<void*>&self.vbfMVA_JetEnDown_value)

        #print "making vbfMVA_JetEnUp"
        self.vbfMVA_JetEnUp_branch = the_tree.GetBranch("vbfMVA_JetEnUp")
        #if not self.vbfMVA_JetEnUp_branch and "vbfMVA_JetEnUp" not in self.complained:
        if not self.vbfMVA_JetEnUp_branch and "vbfMVA_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfMVA_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA_JetEnUp")
        else:
            self.vbfMVA_JetEnUp_branch.SetAddress(<void*>&self.vbfMVA_JetEnUp_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "MuMuMuTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMass_JetEnDown"
        self.vbfMass_JetEnDown_branch = the_tree.GetBranch("vbfMass_JetEnDown")
        #if not self.vbfMass_JetEnDown_branch and "vbfMass_JetEnDown" not in self.complained:
        if not self.vbfMass_JetEnDown_branch and "vbfMass_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfMass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEnDown")
        else:
            self.vbfMass_JetEnDown_branch.SetAddress(<void*>&self.vbfMass_JetEnDown_value)

        #print "making vbfMass_JetEnUp"
        self.vbfMass_JetEnUp_branch = the_tree.GetBranch("vbfMass_JetEnUp")
        #if not self.vbfMass_JetEnUp_branch and "vbfMass_JetEnUp" not in self.complained:
        if not self.vbfMass_JetEnUp_branch and "vbfMass_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfMass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEnUp")
        else:
            self.vbfMass_JetEnUp_branch.SetAddress(<void*>&self.vbfMass_JetEnUp_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "MuMuMuTree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets20_JetEnDown"
        self.vbfNJets20_JetEnDown_branch = the_tree.GetBranch("vbfNJets20_JetEnDown")
        #if not self.vbfNJets20_JetEnDown_branch and "vbfNJets20_JetEnDown" not in self.complained:
        if not self.vbfNJets20_JetEnDown_branch and "vbfNJets20_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfNJets20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20_JetEnDown")
        else:
            self.vbfNJets20_JetEnDown_branch.SetAddress(<void*>&self.vbfNJets20_JetEnDown_value)

        #print "making vbfNJets20_JetEnUp"
        self.vbfNJets20_JetEnUp_branch = the_tree.GetBranch("vbfNJets20_JetEnUp")
        #if not self.vbfNJets20_JetEnUp_branch and "vbfNJets20_JetEnUp" not in self.complained:
        if not self.vbfNJets20_JetEnUp_branch and "vbfNJets20_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfNJets20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20_JetEnUp")
        else:
            self.vbfNJets20_JetEnUp_branch.SetAddress(<void*>&self.vbfNJets20_JetEnUp_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "MuMuMuTree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfNJets30_JetEnDown"
        self.vbfNJets30_JetEnDown_branch = the_tree.GetBranch("vbfNJets30_JetEnDown")
        #if not self.vbfNJets30_JetEnDown_branch and "vbfNJets30_JetEnDown" not in self.complained:
        if not self.vbfNJets30_JetEnDown_branch and "vbfNJets30_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfNJets30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30_JetEnDown")
        else:
            self.vbfNJets30_JetEnDown_branch.SetAddress(<void*>&self.vbfNJets30_JetEnDown_value)

        #print "making vbfNJets30_JetEnUp"
        self.vbfNJets30_JetEnUp_branch = the_tree.GetBranch("vbfNJets30_JetEnUp")
        #if not self.vbfNJets30_JetEnUp_branch and "vbfNJets30_JetEnUp" not in self.complained:
        if not self.vbfNJets30_JetEnUp_branch and "vbfNJets30_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfNJets30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30_JetEnUp")
        else:
            self.vbfNJets30_JetEnUp_branch.SetAddress(<void*>&self.vbfNJets30_JetEnUp_value)

        #print "making vbfVispt"
        self.vbfVispt_branch = the_tree.GetBranch("vbfVispt")
        #if not self.vbfVispt_branch and "vbfVispt" not in self.complained:
        if not self.vbfVispt_branch and "vbfVispt":
            warnings.warn( "MuMuMuTree: Expected branch vbfVispt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt")
        else:
            self.vbfVispt_branch.SetAddress(<void*>&self.vbfVispt_value)

        #print "making vbfVispt_JetEnDown"
        self.vbfVispt_JetEnDown_branch = the_tree.GetBranch("vbfVispt_JetEnDown")
        #if not self.vbfVispt_JetEnDown_branch and "vbfVispt_JetEnDown" not in self.complained:
        if not self.vbfVispt_JetEnDown_branch and "vbfVispt_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfVispt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt_JetEnDown")
        else:
            self.vbfVispt_JetEnDown_branch.SetAddress(<void*>&self.vbfVispt_JetEnDown_value)

        #print "making vbfVispt_JetEnUp"
        self.vbfVispt_JetEnUp_branch = the_tree.GetBranch("vbfVispt_JetEnUp")
        #if not self.vbfVispt_JetEnUp_branch and "vbfVispt_JetEnUp" not in self.complained:
        if not self.vbfVispt_JetEnUp_branch and "vbfVispt_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfVispt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt_JetEnUp")
        else:
            self.vbfVispt_JetEnUp_branch.SetAddress(<void*>&self.vbfVispt_JetEnUp_value)

        #print "making vbfdijetpt"
        self.vbfdijetpt_branch = the_tree.GetBranch("vbfdijetpt")
        #if not self.vbfdijetpt_branch and "vbfdijetpt" not in self.complained:
        if not self.vbfdijetpt_branch and "vbfdijetpt":
            warnings.warn( "MuMuMuTree: Expected branch vbfdijetpt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt")
        else:
            self.vbfdijetpt_branch.SetAddress(<void*>&self.vbfdijetpt_value)

        #print "making vbfdijetpt_JetEnDown"
        self.vbfdijetpt_JetEnDown_branch = the_tree.GetBranch("vbfdijetpt_JetEnDown")
        #if not self.vbfdijetpt_JetEnDown_branch and "vbfdijetpt_JetEnDown" not in self.complained:
        if not self.vbfdijetpt_JetEnDown_branch and "vbfdijetpt_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfdijetpt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt_JetEnDown")
        else:
            self.vbfdijetpt_JetEnDown_branch.SetAddress(<void*>&self.vbfdijetpt_JetEnDown_value)

        #print "making vbfdijetpt_JetEnUp"
        self.vbfdijetpt_JetEnUp_branch = the_tree.GetBranch("vbfdijetpt_JetEnUp")
        #if not self.vbfdijetpt_JetEnUp_branch and "vbfdijetpt_JetEnUp" not in self.complained:
        if not self.vbfdijetpt_JetEnUp_branch and "vbfdijetpt_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfdijetpt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt_JetEnUp")
        else:
            self.vbfdijetpt_JetEnUp_branch.SetAddress(<void*>&self.vbfdijetpt_JetEnUp_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "MuMuMuTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1eta_JetEnDown"
        self.vbfj1eta_JetEnDown_branch = the_tree.GetBranch("vbfj1eta_JetEnDown")
        #if not self.vbfj1eta_JetEnDown_branch and "vbfj1eta_JetEnDown" not in self.complained:
        if not self.vbfj1eta_JetEnDown_branch and "vbfj1eta_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfj1eta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta_JetEnDown")
        else:
            self.vbfj1eta_JetEnDown_branch.SetAddress(<void*>&self.vbfj1eta_JetEnDown_value)

        #print "making vbfj1eta_JetEnUp"
        self.vbfj1eta_JetEnUp_branch = the_tree.GetBranch("vbfj1eta_JetEnUp")
        #if not self.vbfj1eta_JetEnUp_branch and "vbfj1eta_JetEnUp" not in self.complained:
        if not self.vbfj1eta_JetEnUp_branch and "vbfj1eta_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfj1eta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta_JetEnUp")
        else:
            self.vbfj1eta_JetEnUp_branch.SetAddress(<void*>&self.vbfj1eta_JetEnUp_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "MuMuMuTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj1pt_JetEnDown"
        self.vbfj1pt_JetEnDown_branch = the_tree.GetBranch("vbfj1pt_JetEnDown")
        #if not self.vbfj1pt_JetEnDown_branch and "vbfj1pt_JetEnDown" not in self.complained:
        if not self.vbfj1pt_JetEnDown_branch and "vbfj1pt_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfj1pt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt_JetEnDown")
        else:
            self.vbfj1pt_JetEnDown_branch.SetAddress(<void*>&self.vbfj1pt_JetEnDown_value)

        #print "making vbfj1pt_JetEnUp"
        self.vbfj1pt_JetEnUp_branch = the_tree.GetBranch("vbfj1pt_JetEnUp")
        #if not self.vbfj1pt_JetEnUp_branch and "vbfj1pt_JetEnUp" not in self.complained:
        if not self.vbfj1pt_JetEnUp_branch and "vbfj1pt_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfj1pt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt_JetEnUp")
        else:
            self.vbfj1pt_JetEnUp_branch.SetAddress(<void*>&self.vbfj1pt_JetEnUp_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "MuMuMuTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2eta_JetEnDown"
        self.vbfj2eta_JetEnDown_branch = the_tree.GetBranch("vbfj2eta_JetEnDown")
        #if not self.vbfj2eta_JetEnDown_branch and "vbfj2eta_JetEnDown" not in self.complained:
        if not self.vbfj2eta_JetEnDown_branch and "vbfj2eta_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfj2eta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta_JetEnDown")
        else:
            self.vbfj2eta_JetEnDown_branch.SetAddress(<void*>&self.vbfj2eta_JetEnDown_value)

        #print "making vbfj2eta_JetEnUp"
        self.vbfj2eta_JetEnUp_branch = the_tree.GetBranch("vbfj2eta_JetEnUp")
        #if not self.vbfj2eta_JetEnUp_branch and "vbfj2eta_JetEnUp" not in self.complained:
        if not self.vbfj2eta_JetEnUp_branch and "vbfj2eta_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfj2eta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta_JetEnUp")
        else:
            self.vbfj2eta_JetEnUp_branch.SetAddress(<void*>&self.vbfj2eta_JetEnUp_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "MuMuMuTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vbfj2pt_JetEnDown"
        self.vbfj2pt_JetEnDown_branch = the_tree.GetBranch("vbfj2pt_JetEnDown")
        #if not self.vbfj2pt_JetEnDown_branch and "vbfj2pt_JetEnDown" not in self.complained:
        if not self.vbfj2pt_JetEnDown_branch and "vbfj2pt_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch vbfj2pt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt_JetEnDown")
        else:
            self.vbfj2pt_JetEnDown_branch.SetAddress(<void*>&self.vbfj2pt_JetEnDown_value)

        #print "making vbfj2pt_JetEnUp"
        self.vbfj2pt_JetEnUp_branch = the_tree.GetBranch("vbfj2pt_JetEnUp")
        #if not self.vbfj2pt_JetEnUp_branch and "vbfj2pt_JetEnUp" not in self.complained:
        if not self.vbfj2pt_JetEnUp_branch and "vbfj2pt_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch vbfj2pt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt_JetEnUp")
        else:
            self.vbfj2pt_JetEnUp_branch.SetAddress(<void*>&self.vbfj2pt_JetEnUp_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "MuMuMuTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "MuMuMuTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "MuMuMuTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property m1DPhiToPfMet_ElectronEnDown:
        def __get__(self):
            self.m1DPhiToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_ElectronEnDown_value

    property m1DPhiToPfMet_ElectronEnUp:
        def __get__(self):
            self.m1DPhiToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_ElectronEnUp_value

    property m1DPhiToPfMet_JetEnDown:
        def __get__(self):
            self.m1DPhiToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_JetEnDown_value

    property m1DPhiToPfMet_JetEnUp:
        def __get__(self):
            self.m1DPhiToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_JetEnUp_value

    property m1DPhiToPfMet_JetResDown:
        def __get__(self):
            self.m1DPhiToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_JetResDown_value

    property m1DPhiToPfMet_JetResUp:
        def __get__(self):
            self.m1DPhiToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_JetResUp_value

    property m1DPhiToPfMet_MuonEnDown:
        def __get__(self):
            self.m1DPhiToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_MuonEnDown_value

    property m1DPhiToPfMet_MuonEnUp:
        def __get__(self):
            self.m1DPhiToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_MuonEnUp_value

    property m1DPhiToPfMet_PhotonEnDown:
        def __get__(self):
            self.m1DPhiToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_PhotonEnDown_value

    property m1DPhiToPfMet_PhotonEnUp:
        def __get__(self):
            self.m1DPhiToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_PhotonEnUp_value

    property m1DPhiToPfMet_TauEnDown:
        def __get__(self):
            self.m1DPhiToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_TauEnDown_value

    property m1DPhiToPfMet_TauEnUp:
        def __get__(self):
            self.m1DPhiToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_TauEnUp_value

    property m1DPhiToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.m1DPhiToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_UnclusteredEnDown_value

    property m1DPhiToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.m1DPhiToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_UnclusteredEnUp_value

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

    property m1MatchesMu23Ele12Path:
        def __get__(self):
            self.m1MatchesMu23Ele12Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu23Ele12Path_value

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

    property m1MtToPfMet_ElectronEnDown:
        def __get__(self):
            self.m1MtToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_ElectronEnDown_value

    property m1MtToPfMet_ElectronEnUp:
        def __get__(self):
            self.m1MtToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_ElectronEnUp_value

    property m1MtToPfMet_JetEnDown:
        def __get__(self):
            self.m1MtToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_JetEnDown_value

    property m1MtToPfMet_JetEnUp:
        def __get__(self):
            self.m1MtToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_JetEnUp_value

    property m1MtToPfMet_JetResDown:
        def __get__(self):
            self.m1MtToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_JetResDown_value

    property m1MtToPfMet_JetResUp:
        def __get__(self):
            self.m1MtToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_JetResUp_value

    property m1MtToPfMet_MuonEnDown:
        def __get__(self):
            self.m1MtToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_MuonEnDown_value

    property m1MtToPfMet_MuonEnUp:
        def __get__(self):
            self.m1MtToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_MuonEnUp_value

    property m1MtToPfMet_PhotonEnDown:
        def __get__(self):
            self.m1MtToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_PhotonEnDown_value

    property m1MtToPfMet_PhotonEnUp:
        def __get__(self):
            self.m1MtToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_PhotonEnUp_value

    property m1MtToPfMet_Raw:
        def __get__(self):
            self.m1MtToPfMet_Raw_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_Raw_value

    property m1MtToPfMet_TauEnDown:
        def __get__(self):
            self.m1MtToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_TauEnDown_value

    property m1MtToPfMet_TauEnUp:
        def __get__(self):
            self.m1MtToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_TauEnUp_value

    property m1MtToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.m1MtToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_UnclusteredEnDown_value

    property m1MtToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.m1MtToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_UnclusteredEnUp_value

    property m1MtToPfMet_type1:
        def __get__(self):
            self.m1MtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_type1_value

    property m1Mu23Ele12Filter:
        def __get__(self):
            self.m1Mu23Ele12Filter_branch.GetEntry(self.localentry, 0)
            return self.m1Mu23Ele12Filter_value

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

    property m1_m2_collinearmass_EleEnDown:
        def __get__(self):
            self.m1_m2_collinearmass_EleEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_EleEnDown_value

    property m1_m2_collinearmass_EleEnUp:
        def __get__(self):
            self.m1_m2_collinearmass_EleEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_EleEnUp_value

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

    property m1_m3_CosThetaStar:
        def __get__(self):
            self.m1_m3_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_CosThetaStar_value

    property m1_m3_DPhi:
        def __get__(self):
            self.m1_m3_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_DPhi_value

    property m1_m3_DR:
        def __get__(self):
            self.m1_m3_DR_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_DR_value

    property m1_m3_Eta:
        def __get__(self):
            self.m1_m3_Eta_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Eta_value

    property m1_m3_Mass:
        def __get__(self):
            self.m1_m3_Mass_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Mass_value

    property m1_m3_Mass_TauEnDown:
        def __get__(self):
            self.m1_m3_Mass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Mass_TauEnDown_value

    property m1_m3_Mass_TauEnUp:
        def __get__(self):
            self.m1_m3_Mass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Mass_TauEnUp_value

    property m1_m3_Mt:
        def __get__(self):
            self.m1_m3_Mt_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Mt_value

    property m1_m3_MtTotal:
        def __get__(self):
            self.m1_m3_MtTotal_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_MtTotal_value

    property m1_m3_Mt_TauEnDown:
        def __get__(self):
            self.m1_m3_Mt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Mt_TauEnDown_value

    property m1_m3_Mt_TauEnUp:
        def __get__(self):
            self.m1_m3_Mt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Mt_TauEnUp_value

    property m1_m3_MvaMet:
        def __get__(self):
            self.m1_m3_MvaMet_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_MvaMet_value

    property m1_m3_MvaMetCovMatrix00:
        def __get__(self):
            self.m1_m3_MvaMetCovMatrix00_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_MvaMetCovMatrix00_value

    property m1_m3_MvaMetCovMatrix01:
        def __get__(self):
            self.m1_m3_MvaMetCovMatrix01_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_MvaMetCovMatrix01_value

    property m1_m3_MvaMetCovMatrix10:
        def __get__(self):
            self.m1_m3_MvaMetCovMatrix10_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_MvaMetCovMatrix10_value

    property m1_m3_MvaMetCovMatrix11:
        def __get__(self):
            self.m1_m3_MvaMetCovMatrix11_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_MvaMetCovMatrix11_value

    property m1_m3_MvaMetPhi:
        def __get__(self):
            self.m1_m3_MvaMetPhi_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_MvaMetPhi_value

    property m1_m3_PZeta:
        def __get__(self):
            self.m1_m3_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_PZeta_value

    property m1_m3_PZetaLess0p85PZetaVis:
        def __get__(self):
            self.m1_m3_PZetaLess0p85PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_PZetaLess0p85PZetaVis_value

    property m1_m3_PZetaVis:
        def __get__(self):
            self.m1_m3_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_PZetaVis_value

    property m1_m3_Phi:
        def __get__(self):
            self.m1_m3_Phi_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Phi_value

    property m1_m3_Pt:
        def __get__(self):
            self.m1_m3_Pt_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Pt_value

    property m1_m3_SS:
        def __get__(self):
            self.m1_m3_SS_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_SS_value

    property m1_m3_ToMETDPhi_Ty1:
        def __get__(self):
            self.m1_m3_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_ToMETDPhi_Ty1_value

    property m1_m3_collinearmass:
        def __get__(self):
            self.m1_m3_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_collinearmass_value

    property m1_m3_collinearmass_EleEnDown:
        def __get__(self):
            self.m1_m3_collinearmass_EleEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_collinearmass_EleEnDown_value

    property m1_m3_collinearmass_EleEnUp:
        def __get__(self):
            self.m1_m3_collinearmass_EleEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_collinearmass_EleEnUp_value

    property m1_m3_collinearmass_JetEnDown:
        def __get__(self):
            self.m1_m3_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_collinearmass_JetEnDown_value

    property m1_m3_collinearmass_JetEnUp:
        def __get__(self):
            self.m1_m3_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_collinearmass_JetEnUp_value

    property m1_m3_collinearmass_MuEnDown:
        def __get__(self):
            self.m1_m3_collinearmass_MuEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_collinearmass_MuEnDown_value

    property m1_m3_collinearmass_MuEnUp:
        def __get__(self):
            self.m1_m3_collinearmass_MuEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_collinearmass_MuEnUp_value

    property m1_m3_collinearmass_TauEnDown:
        def __get__(self):
            self.m1_m3_collinearmass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_collinearmass_TauEnDown_value

    property m1_m3_collinearmass_TauEnUp:
        def __get__(self):
            self.m1_m3_collinearmass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_collinearmass_TauEnUp_value

    property m1_m3_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.m1_m3_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_collinearmass_UnclusteredEnDown_value

    property m1_m3_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.m1_m3_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_collinearmass_UnclusteredEnUp_value

    property m1_m3_pt_tt:
        def __get__(self):
            self.m1_m3_pt_tt_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_pt_tt_value

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

    property m2DPhiToPfMet_ElectronEnDown:
        def __get__(self):
            self.m2DPhiToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_ElectronEnDown_value

    property m2DPhiToPfMet_ElectronEnUp:
        def __get__(self):
            self.m2DPhiToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_ElectronEnUp_value

    property m2DPhiToPfMet_JetEnDown:
        def __get__(self):
            self.m2DPhiToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_JetEnDown_value

    property m2DPhiToPfMet_JetEnUp:
        def __get__(self):
            self.m2DPhiToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_JetEnUp_value

    property m2DPhiToPfMet_JetResDown:
        def __get__(self):
            self.m2DPhiToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_JetResDown_value

    property m2DPhiToPfMet_JetResUp:
        def __get__(self):
            self.m2DPhiToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_JetResUp_value

    property m2DPhiToPfMet_MuonEnDown:
        def __get__(self):
            self.m2DPhiToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_MuonEnDown_value

    property m2DPhiToPfMet_MuonEnUp:
        def __get__(self):
            self.m2DPhiToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_MuonEnUp_value

    property m2DPhiToPfMet_PhotonEnDown:
        def __get__(self):
            self.m2DPhiToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_PhotonEnDown_value

    property m2DPhiToPfMet_PhotonEnUp:
        def __get__(self):
            self.m2DPhiToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_PhotonEnUp_value

    property m2DPhiToPfMet_TauEnDown:
        def __get__(self):
            self.m2DPhiToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_TauEnDown_value

    property m2DPhiToPfMet_TauEnUp:
        def __get__(self):
            self.m2DPhiToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_TauEnUp_value

    property m2DPhiToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.m2DPhiToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_UnclusteredEnDown_value

    property m2DPhiToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.m2DPhiToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_UnclusteredEnUp_value

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

    property m2MatchesMu23Ele12Path:
        def __get__(self):
            self.m2MatchesMu23Ele12Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu23Ele12Path_value

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

    property m2MtToPfMet_ElectronEnDown:
        def __get__(self):
            self.m2MtToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_ElectronEnDown_value

    property m2MtToPfMet_ElectronEnUp:
        def __get__(self):
            self.m2MtToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_ElectronEnUp_value

    property m2MtToPfMet_JetEnDown:
        def __get__(self):
            self.m2MtToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_JetEnDown_value

    property m2MtToPfMet_JetEnUp:
        def __get__(self):
            self.m2MtToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_JetEnUp_value

    property m2MtToPfMet_JetResDown:
        def __get__(self):
            self.m2MtToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_JetResDown_value

    property m2MtToPfMet_JetResUp:
        def __get__(self):
            self.m2MtToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_JetResUp_value

    property m2MtToPfMet_MuonEnDown:
        def __get__(self):
            self.m2MtToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_MuonEnDown_value

    property m2MtToPfMet_MuonEnUp:
        def __get__(self):
            self.m2MtToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_MuonEnUp_value

    property m2MtToPfMet_PhotonEnDown:
        def __get__(self):
            self.m2MtToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_PhotonEnDown_value

    property m2MtToPfMet_PhotonEnUp:
        def __get__(self):
            self.m2MtToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_PhotonEnUp_value

    property m2MtToPfMet_Raw:
        def __get__(self):
            self.m2MtToPfMet_Raw_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_Raw_value

    property m2MtToPfMet_TauEnDown:
        def __get__(self):
            self.m2MtToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_TauEnDown_value

    property m2MtToPfMet_TauEnUp:
        def __get__(self):
            self.m2MtToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_TauEnUp_value

    property m2MtToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.m2MtToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_UnclusteredEnDown_value

    property m2MtToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.m2MtToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_UnclusteredEnUp_value

    property m2MtToPfMet_type1:
        def __get__(self):
            self.m2MtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_type1_value

    property m2Mu23Ele12Filter:
        def __get__(self):
            self.m2Mu23Ele12Filter_branch.GetEntry(self.localentry, 0)
            return self.m2Mu23Ele12Filter_value

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

    property m2_m1_collinearmass:
        def __get__(self):
            self.m2_m1_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_value

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

    property m2_m3_CosThetaStar:
        def __get__(self):
            self.m2_m3_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_CosThetaStar_value

    property m2_m3_DPhi:
        def __get__(self):
            self.m2_m3_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_DPhi_value

    property m2_m3_DR:
        def __get__(self):
            self.m2_m3_DR_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_DR_value

    property m2_m3_Eta:
        def __get__(self):
            self.m2_m3_Eta_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Eta_value

    property m2_m3_Mass:
        def __get__(self):
            self.m2_m3_Mass_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Mass_value

    property m2_m3_Mass_TauEnDown:
        def __get__(self):
            self.m2_m3_Mass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Mass_TauEnDown_value

    property m2_m3_Mass_TauEnUp:
        def __get__(self):
            self.m2_m3_Mass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Mass_TauEnUp_value

    property m2_m3_Mt:
        def __get__(self):
            self.m2_m3_Mt_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Mt_value

    property m2_m3_MtTotal:
        def __get__(self):
            self.m2_m3_MtTotal_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_MtTotal_value

    property m2_m3_Mt_TauEnDown:
        def __get__(self):
            self.m2_m3_Mt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Mt_TauEnDown_value

    property m2_m3_Mt_TauEnUp:
        def __get__(self):
            self.m2_m3_Mt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Mt_TauEnUp_value

    property m2_m3_MvaMet:
        def __get__(self):
            self.m2_m3_MvaMet_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_MvaMet_value

    property m2_m3_MvaMetCovMatrix00:
        def __get__(self):
            self.m2_m3_MvaMetCovMatrix00_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_MvaMetCovMatrix00_value

    property m2_m3_MvaMetCovMatrix01:
        def __get__(self):
            self.m2_m3_MvaMetCovMatrix01_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_MvaMetCovMatrix01_value

    property m2_m3_MvaMetCovMatrix10:
        def __get__(self):
            self.m2_m3_MvaMetCovMatrix10_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_MvaMetCovMatrix10_value

    property m2_m3_MvaMetCovMatrix11:
        def __get__(self):
            self.m2_m3_MvaMetCovMatrix11_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_MvaMetCovMatrix11_value

    property m2_m3_MvaMetPhi:
        def __get__(self):
            self.m2_m3_MvaMetPhi_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_MvaMetPhi_value

    property m2_m3_PZeta:
        def __get__(self):
            self.m2_m3_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_PZeta_value

    property m2_m3_PZetaLess0p85PZetaVis:
        def __get__(self):
            self.m2_m3_PZetaLess0p85PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_PZetaLess0p85PZetaVis_value

    property m2_m3_PZetaVis:
        def __get__(self):
            self.m2_m3_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_PZetaVis_value

    property m2_m3_Phi:
        def __get__(self):
            self.m2_m3_Phi_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Phi_value

    property m2_m3_Pt:
        def __get__(self):
            self.m2_m3_Pt_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Pt_value

    property m2_m3_SS:
        def __get__(self):
            self.m2_m3_SS_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_SS_value

    property m2_m3_ToMETDPhi_Ty1:
        def __get__(self):
            self.m2_m3_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_ToMETDPhi_Ty1_value

    property m2_m3_collinearmass:
        def __get__(self):
            self.m2_m3_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_collinearmass_value

    property m2_m3_collinearmass_EleEnDown:
        def __get__(self):
            self.m2_m3_collinearmass_EleEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_collinearmass_EleEnDown_value

    property m2_m3_collinearmass_EleEnUp:
        def __get__(self):
            self.m2_m3_collinearmass_EleEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_collinearmass_EleEnUp_value

    property m2_m3_collinearmass_JetEnDown:
        def __get__(self):
            self.m2_m3_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_collinearmass_JetEnDown_value

    property m2_m3_collinearmass_JetEnUp:
        def __get__(self):
            self.m2_m3_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_collinearmass_JetEnUp_value

    property m2_m3_collinearmass_MuEnDown:
        def __get__(self):
            self.m2_m3_collinearmass_MuEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_collinearmass_MuEnDown_value

    property m2_m3_collinearmass_MuEnUp:
        def __get__(self):
            self.m2_m3_collinearmass_MuEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_collinearmass_MuEnUp_value

    property m2_m3_collinearmass_TauEnDown:
        def __get__(self):
            self.m2_m3_collinearmass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_collinearmass_TauEnDown_value

    property m2_m3_collinearmass_TauEnUp:
        def __get__(self):
            self.m2_m3_collinearmass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_collinearmass_TauEnUp_value

    property m2_m3_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.m2_m3_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_collinearmass_UnclusteredEnDown_value

    property m2_m3_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.m2_m3_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_collinearmass_UnclusteredEnUp_value

    property m2_m3_pt_tt:
        def __get__(self):
            self.m2_m3_pt_tt_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_pt_tt_value

    property m3AbsEta:
        def __get__(self):
            self.m3AbsEta_branch.GetEntry(self.localentry, 0)
            return self.m3AbsEta_value

    property m3BestTrackType:
        def __get__(self):
            self.m3BestTrackType_branch.GetEntry(self.localentry, 0)
            return self.m3BestTrackType_value

    property m3Charge:
        def __get__(self):
            self.m3Charge_branch.GetEntry(self.localentry, 0)
            return self.m3Charge_value

    property m3Chi2LocalPosition:
        def __get__(self):
            self.m3Chi2LocalPosition_branch.GetEntry(self.localentry, 0)
            return self.m3Chi2LocalPosition_value

    property m3ComesFromHiggs:
        def __get__(self):
            self.m3ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.m3ComesFromHiggs_value

    property m3DPhiToPfMet_ElectronEnDown:
        def __get__(self):
            self.m3DPhiToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_ElectronEnDown_value

    property m3DPhiToPfMet_ElectronEnUp:
        def __get__(self):
            self.m3DPhiToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_ElectronEnUp_value

    property m3DPhiToPfMet_JetEnDown:
        def __get__(self):
            self.m3DPhiToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_JetEnDown_value

    property m3DPhiToPfMet_JetEnUp:
        def __get__(self):
            self.m3DPhiToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_JetEnUp_value

    property m3DPhiToPfMet_JetResDown:
        def __get__(self):
            self.m3DPhiToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_JetResDown_value

    property m3DPhiToPfMet_JetResUp:
        def __get__(self):
            self.m3DPhiToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_JetResUp_value

    property m3DPhiToPfMet_MuonEnDown:
        def __get__(self):
            self.m3DPhiToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_MuonEnDown_value

    property m3DPhiToPfMet_MuonEnUp:
        def __get__(self):
            self.m3DPhiToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_MuonEnUp_value

    property m3DPhiToPfMet_PhotonEnDown:
        def __get__(self):
            self.m3DPhiToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_PhotonEnDown_value

    property m3DPhiToPfMet_PhotonEnUp:
        def __get__(self):
            self.m3DPhiToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_PhotonEnUp_value

    property m3DPhiToPfMet_TauEnDown:
        def __get__(self):
            self.m3DPhiToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_TauEnDown_value

    property m3DPhiToPfMet_TauEnUp:
        def __get__(self):
            self.m3DPhiToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_TauEnUp_value

    property m3DPhiToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.m3DPhiToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_UnclusteredEnDown_value

    property m3DPhiToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.m3DPhiToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_UnclusteredEnUp_value

    property m3DPhiToPfMet_type1:
        def __get__(self):
            self.m3DPhiToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.m3DPhiToPfMet_type1_value

    property m3EcalIsoDR03:
        def __get__(self):
            self.m3EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m3EcalIsoDR03_value

    property m3EffectiveArea2011:
        def __get__(self):
            self.m3EffectiveArea2011_branch.GetEntry(self.localentry, 0)
            return self.m3EffectiveArea2011_value

    property m3EffectiveArea2012:
        def __get__(self):
            self.m3EffectiveArea2012_branch.GetEntry(self.localentry, 0)
            return self.m3EffectiveArea2012_value

    property m3ErsatzGenEta:
        def __get__(self):
            self.m3ErsatzGenEta_branch.GetEntry(self.localentry, 0)
            return self.m3ErsatzGenEta_value

    property m3ErsatzGenM:
        def __get__(self):
            self.m3ErsatzGenM_branch.GetEntry(self.localentry, 0)
            return self.m3ErsatzGenM_value

    property m3ErsatzGenPhi:
        def __get__(self):
            self.m3ErsatzGenPhi_branch.GetEntry(self.localentry, 0)
            return self.m3ErsatzGenPhi_value

    property m3ErsatzGenpT:
        def __get__(self):
            self.m3ErsatzGenpT_branch.GetEntry(self.localentry, 0)
            return self.m3ErsatzGenpT_value

    property m3ErsatzGenpX:
        def __get__(self):
            self.m3ErsatzGenpX_branch.GetEntry(self.localentry, 0)
            return self.m3ErsatzGenpX_value

    property m3ErsatzGenpY:
        def __get__(self):
            self.m3ErsatzGenpY_branch.GetEntry(self.localentry, 0)
            return self.m3ErsatzGenpY_value

    property m3ErsatzVispX:
        def __get__(self):
            self.m3ErsatzVispX_branch.GetEntry(self.localentry, 0)
            return self.m3ErsatzVispX_value

    property m3ErsatzVispY:
        def __get__(self):
            self.m3ErsatzVispY_branch.GetEntry(self.localentry, 0)
            return self.m3ErsatzVispY_value

    property m3Eta:
        def __get__(self):
            self.m3Eta_branch.GetEntry(self.localentry, 0)
            return self.m3Eta_value

    property m3Eta_MuonEnDown:
        def __get__(self):
            self.m3Eta_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3Eta_MuonEnDown_value

    property m3Eta_MuonEnUp:
        def __get__(self):
            self.m3Eta_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3Eta_MuonEnUp_value

    property m3GenCharge:
        def __get__(self):
            self.m3GenCharge_branch.GetEntry(self.localentry, 0)
            return self.m3GenCharge_value

    property m3GenDirectPromptTauDecayFinalState:
        def __get__(self):
            self.m3GenDirectPromptTauDecayFinalState_branch.GetEntry(self.localentry, 0)
            return self.m3GenDirectPromptTauDecayFinalState_value

    property m3GenEnergy:
        def __get__(self):
            self.m3GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.m3GenEnergy_value

    property m3GenEta:
        def __get__(self):
            self.m3GenEta_branch.GetEntry(self.localentry, 0)
            return self.m3GenEta_value

    property m3GenIsPrompt:
        def __get__(self):
            self.m3GenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.m3GenIsPrompt_value

    property m3GenMotherPdgId:
        def __get__(self):
            self.m3GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.m3GenMotherPdgId_value

    property m3GenParticle:
        def __get__(self):
            self.m3GenParticle_branch.GetEntry(self.localentry, 0)
            return self.m3GenParticle_value

    property m3GenPdgId:
        def __get__(self):
            self.m3GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.m3GenPdgId_value

    property m3GenPhi:
        def __get__(self):
            self.m3GenPhi_branch.GetEntry(self.localentry, 0)
            return self.m3GenPhi_value

    property m3GenPrompt:
        def __get__(self):
            self.m3GenPrompt_branch.GetEntry(self.localentry, 0)
            return self.m3GenPrompt_value

    property m3GenPromptFinalState:
        def __get__(self):
            self.m3GenPromptFinalState_branch.GetEntry(self.localentry, 0)
            return self.m3GenPromptFinalState_value

    property m3GenPromptTauDecay:
        def __get__(self):
            self.m3GenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.m3GenPromptTauDecay_value

    property m3GenPt:
        def __get__(self):
            self.m3GenPt_branch.GetEntry(self.localentry, 0)
            return self.m3GenPt_value

    property m3GenTauDecay:
        def __get__(self):
            self.m3GenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.m3GenTauDecay_value

    property m3GenVZ:
        def __get__(self):
            self.m3GenVZ_branch.GetEntry(self.localentry, 0)
            return self.m3GenVZ_value

    property m3GenVtxPVMatch:
        def __get__(self):
            self.m3GenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.m3GenVtxPVMatch_value

    property m3HcalIsoDR03:
        def __get__(self):
            self.m3HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m3HcalIsoDR03_value

    property m3IP3D:
        def __get__(self):
            self.m3IP3D_branch.GetEntry(self.localentry, 0)
            return self.m3IP3D_value

    property m3IP3DErr:
        def __get__(self):
            self.m3IP3DErr_branch.GetEntry(self.localentry, 0)
            return self.m3IP3DErr_value

    property m3IsGlobal:
        def __get__(self):
            self.m3IsGlobal_branch.GetEntry(self.localentry, 0)
            return self.m3IsGlobal_value

    property m3IsPFMuon:
        def __get__(self):
            self.m3IsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.m3IsPFMuon_value

    property m3IsTracker:
        def __get__(self):
            self.m3IsTracker_branch.GetEntry(self.localentry, 0)
            return self.m3IsTracker_value

    property m3IsoDB03:
        def __get__(self):
            self.m3IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.m3IsoDB03_value

    property m3IsoDB04:
        def __get__(self):
            self.m3IsoDB04_branch.GetEntry(self.localentry, 0)
            return self.m3IsoDB04_value

    property m3IsoMu22Filter:
        def __get__(self):
            self.m3IsoMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m3IsoMu22Filter_value

    property m3IsoMu22eta2p1Filter:
        def __get__(self):
            self.m3IsoMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m3IsoMu22eta2p1Filter_value

    property m3IsoMu24Filter:
        def __get__(self):
            self.m3IsoMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m3IsoMu24Filter_value

    property m3IsoMu24eta2p1Filter:
        def __get__(self):
            self.m3IsoMu24eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m3IsoMu24eta2p1Filter_value

    property m3IsoTkMu22Filter:
        def __get__(self):
            self.m3IsoTkMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m3IsoTkMu22Filter_value

    property m3IsoTkMu22eta2p1Filter:
        def __get__(self):
            self.m3IsoTkMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m3IsoTkMu22eta2p1Filter_value

    property m3IsoTkMu24Filter:
        def __get__(self):
            self.m3IsoTkMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m3IsoTkMu24Filter_value

    property m3IsoTkMu24eta2p1Filter:
        def __get__(self):
            self.m3IsoTkMu24eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m3IsoTkMu24eta2p1Filter_value

    property m3JetArea:
        def __get__(self):
            self.m3JetArea_branch.GetEntry(self.localentry, 0)
            return self.m3JetArea_value

    property m3JetBtag:
        def __get__(self):
            self.m3JetBtag_branch.GetEntry(self.localentry, 0)
            return self.m3JetBtag_value

    property m3JetEtaEtaMoment:
        def __get__(self):
            self.m3JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.m3JetEtaEtaMoment_value

    property m3JetEtaPhiMoment:
        def __get__(self):
            self.m3JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m3JetEtaPhiMoment_value

    property m3JetEtaPhiSpread:
        def __get__(self):
            self.m3JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.m3JetEtaPhiSpread_value

    property m3JetHadronFlavour:
        def __get__(self):
            self.m3JetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.m3JetHadronFlavour_value

    property m3JetPFCISVBtag:
        def __get__(self):
            self.m3JetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.m3JetPFCISVBtag_value

    property m3JetPartonFlavour:
        def __get__(self):
            self.m3JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.m3JetPartonFlavour_value

    property m3JetPhiPhiMoment:
        def __get__(self):
            self.m3JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m3JetPhiPhiMoment_value

    property m3JetPt:
        def __get__(self):
            self.m3JetPt_branch.GetEntry(self.localentry, 0)
            return self.m3JetPt_value

    property m3LowestMll:
        def __get__(self):
            self.m3LowestMll_branch.GetEntry(self.localentry, 0)
            return self.m3LowestMll_value

    property m3Mass:
        def __get__(self):
            self.m3Mass_branch.GetEntry(self.localentry, 0)
            return self.m3Mass_value

    property m3MatchedStations:
        def __get__(self):
            self.m3MatchedStations_branch.GetEntry(self.localentry, 0)
            return self.m3MatchedStations_value

    property m3MatchesDoubleESingleMu:
        def __get__(self):
            self.m3MatchesDoubleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesDoubleESingleMu_value

    property m3MatchesDoubleMu:
        def __get__(self):
            self.m3MatchesDoubleMu_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesDoubleMu_value

    property m3MatchesDoubleMuSingleE:
        def __get__(self):
            self.m3MatchesDoubleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesDoubleMuSingleE_value

    property m3MatchesIsoMu22Path:
        def __get__(self):
            self.m3MatchesIsoMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu22Path_value

    property m3MatchesIsoMu22eta2p1Path:
        def __get__(self):
            self.m3MatchesIsoMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu22eta2p1Path_value

    property m3MatchesIsoMu24Path:
        def __get__(self):
            self.m3MatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu24Path_value

    property m3MatchesIsoMu24eta2p1Path:
        def __get__(self):
            self.m3MatchesIsoMu24eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu24eta2p1Path_value

    property m3MatchesIsoTkMu22Path:
        def __get__(self):
            self.m3MatchesIsoTkMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoTkMu22Path_value

    property m3MatchesIsoTkMu22eta2p1Path:
        def __get__(self):
            self.m3MatchesIsoTkMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoTkMu22eta2p1Path_value

    property m3MatchesIsoTkMu24Path:
        def __get__(self):
            self.m3MatchesIsoTkMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoTkMu24Path_value

    property m3MatchesIsoTkMu24eta2p1Path:
        def __get__(self):
            self.m3MatchesIsoTkMu24eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoTkMu24eta2p1Path_value

    property m3MatchesMu19Tau20Filter:
        def __get__(self):
            self.m3MatchesMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesMu19Tau20Filter_value

    property m3MatchesMu19Tau20Path:
        def __get__(self):
            self.m3MatchesMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesMu19Tau20Path_value

    property m3MatchesMu19Tau20sL1Filter:
        def __get__(self):
            self.m3MatchesMu19Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesMu19Tau20sL1Filter_value

    property m3MatchesMu19Tau20sL1Path:
        def __get__(self):
            self.m3MatchesMu19Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesMu19Tau20sL1Path_value

    property m3MatchesMu23Ele12Path:
        def __get__(self):
            self.m3MatchesMu23Ele12Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesMu23Ele12Path_value

    property m3MatchesMu8Ele23Path:
        def __get__(self):
            self.m3MatchesMu8Ele23Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesMu8Ele23Path_value

    property m3MatchesSingleESingleMu:
        def __get__(self):
            self.m3MatchesSingleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesSingleESingleMu_value

    property m3MatchesSingleMu:
        def __get__(self):
            self.m3MatchesSingleMu_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesSingleMu_value

    property m3MatchesSingleMuIso20:
        def __get__(self):
            self.m3MatchesSingleMuIso20_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesSingleMuIso20_value

    property m3MatchesSingleMuIsoTk20:
        def __get__(self):
            self.m3MatchesSingleMuIsoTk20_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesSingleMuIsoTk20_value

    property m3MatchesSingleMuSingleE:
        def __get__(self):
            self.m3MatchesSingleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesSingleMuSingleE_value

    property m3MatchesSingleMu_leg1:
        def __get__(self):
            self.m3MatchesSingleMu_leg1_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesSingleMu_leg1_value

    property m3MatchesSingleMu_leg1_noiso:
        def __get__(self):
            self.m3MatchesSingleMu_leg1_noiso_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesSingleMu_leg1_noiso_value

    property m3MatchesSingleMu_leg2:
        def __get__(self):
            self.m3MatchesSingleMu_leg2_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesSingleMu_leg2_value

    property m3MatchesSingleMu_leg2_noiso:
        def __get__(self):
            self.m3MatchesSingleMu_leg2_noiso_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesSingleMu_leg2_noiso_value

    property m3MatchesTripleMu:
        def __get__(self):
            self.m3MatchesTripleMu_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesTripleMu_value

    property m3MtToPfMet_ElectronEnDown:
        def __get__(self):
            self.m3MtToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_ElectronEnDown_value

    property m3MtToPfMet_ElectronEnUp:
        def __get__(self):
            self.m3MtToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_ElectronEnUp_value

    property m3MtToPfMet_JetEnDown:
        def __get__(self):
            self.m3MtToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_JetEnDown_value

    property m3MtToPfMet_JetEnUp:
        def __get__(self):
            self.m3MtToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_JetEnUp_value

    property m3MtToPfMet_JetResDown:
        def __get__(self):
            self.m3MtToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_JetResDown_value

    property m3MtToPfMet_JetResUp:
        def __get__(self):
            self.m3MtToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_JetResUp_value

    property m3MtToPfMet_MuonEnDown:
        def __get__(self):
            self.m3MtToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_MuonEnDown_value

    property m3MtToPfMet_MuonEnUp:
        def __get__(self):
            self.m3MtToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_MuonEnUp_value

    property m3MtToPfMet_PhotonEnDown:
        def __get__(self):
            self.m3MtToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_PhotonEnDown_value

    property m3MtToPfMet_PhotonEnUp:
        def __get__(self):
            self.m3MtToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_PhotonEnUp_value

    property m3MtToPfMet_Raw:
        def __get__(self):
            self.m3MtToPfMet_Raw_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_Raw_value

    property m3MtToPfMet_TauEnDown:
        def __get__(self):
            self.m3MtToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_TauEnDown_value

    property m3MtToPfMet_TauEnUp:
        def __get__(self):
            self.m3MtToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_TauEnUp_value

    property m3MtToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.m3MtToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_UnclusteredEnDown_value

    property m3MtToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.m3MtToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_UnclusteredEnUp_value

    property m3MtToPfMet_type1:
        def __get__(self):
            self.m3MtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_type1_value

    property m3Mu23Ele12Filter:
        def __get__(self):
            self.m3Mu23Ele12Filter_branch.GetEntry(self.localentry, 0)
            return self.m3Mu23Ele12Filter_value

    property m3Mu8Ele23Filter:
        def __get__(self):
            self.m3Mu8Ele23Filter_branch.GetEntry(self.localentry, 0)
            return self.m3Mu8Ele23Filter_value

    property m3MuonHits:
        def __get__(self):
            self.m3MuonHits_branch.GetEntry(self.localentry, 0)
            return self.m3MuonHits_value

    property m3NearestZMass:
        def __get__(self):
            self.m3NearestZMass_branch.GetEntry(self.localentry, 0)
            return self.m3NearestZMass_value

    property m3NormTrkChi2:
        def __get__(self):
            self.m3NormTrkChi2_branch.GetEntry(self.localentry, 0)
            return self.m3NormTrkChi2_value

    property m3NormalizedChi2:
        def __get__(self):
            self.m3NormalizedChi2_branch.GetEntry(self.localentry, 0)
            return self.m3NormalizedChi2_value

    property m3PFChargedHadronIsoR04:
        def __get__(self):
            self.m3PFChargedHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m3PFChargedHadronIsoR04_value

    property m3PFChargedIso:
        def __get__(self):
            self.m3PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m3PFChargedIso_value

    property m3PFIDLoose:
        def __get__(self):
            self.m3PFIDLoose_branch.GetEntry(self.localentry, 0)
            return self.m3PFIDLoose_value

    property m3PFIDMedium:
        def __get__(self):
            self.m3PFIDMedium_branch.GetEntry(self.localentry, 0)
            return self.m3PFIDMedium_value

    property m3PFIDTight:
        def __get__(self):
            self.m3PFIDTight_branch.GetEntry(self.localentry, 0)
            return self.m3PFIDTight_value

    property m3PFNeutralHadronIsoR04:
        def __get__(self):
            self.m3PFNeutralHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m3PFNeutralHadronIsoR04_value

    property m3PFNeutralIso:
        def __get__(self):
            self.m3PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.m3PFNeutralIso_value

    property m3PFPUChargedIso:
        def __get__(self):
            self.m3PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m3PFPUChargedIso_value

    property m3PFPhotonIso:
        def __get__(self):
            self.m3PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.m3PFPhotonIso_value

    property m3PFPhotonIsoR04:
        def __get__(self):
            self.m3PFPhotonIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m3PFPhotonIsoR04_value

    property m3PFPileupIsoR04:
        def __get__(self):
            self.m3PFPileupIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m3PFPileupIsoR04_value

    property m3PVDXY:
        def __get__(self):
            self.m3PVDXY_branch.GetEntry(self.localentry, 0)
            return self.m3PVDXY_value

    property m3PVDZ:
        def __get__(self):
            self.m3PVDZ_branch.GetEntry(self.localentry, 0)
            return self.m3PVDZ_value

    property m3Phi:
        def __get__(self):
            self.m3Phi_branch.GetEntry(self.localentry, 0)
            return self.m3Phi_value

    property m3Phi_MuonEnDown:
        def __get__(self):
            self.m3Phi_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3Phi_MuonEnDown_value

    property m3Phi_MuonEnUp:
        def __get__(self):
            self.m3Phi_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3Phi_MuonEnUp_value

    property m3PixHits:
        def __get__(self):
            self.m3PixHits_branch.GetEntry(self.localentry, 0)
            return self.m3PixHits_value

    property m3Pt:
        def __get__(self):
            self.m3Pt_branch.GetEntry(self.localentry, 0)
            return self.m3Pt_value

    property m3Pt_MuonEnDown:
        def __get__(self):
            self.m3Pt_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3Pt_MuonEnDown_value

    property m3Pt_MuonEnUp:
        def __get__(self):
            self.m3Pt_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3Pt_MuonEnUp_value

    property m3Rank:
        def __get__(self):
            self.m3Rank_branch.GetEntry(self.localentry, 0)
            return self.m3Rank_value

    property m3RelPFIsoDBDefault:
        def __get__(self):
            self.m3RelPFIsoDBDefault_branch.GetEntry(self.localentry, 0)
            return self.m3RelPFIsoDBDefault_value

    property m3RelPFIsoDBDefaultR04:
        def __get__(self):
            self.m3RelPFIsoDBDefaultR04_branch.GetEntry(self.localentry, 0)
            return self.m3RelPFIsoDBDefaultR04_value

    property m3RelPFIsoRho:
        def __get__(self):
            self.m3RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.m3RelPFIsoRho_value

    property m3Rho:
        def __get__(self):
            self.m3Rho_branch.GetEntry(self.localentry, 0)
            return self.m3Rho_value

    property m3SIP2D:
        def __get__(self):
            self.m3SIP2D_branch.GetEntry(self.localentry, 0)
            return self.m3SIP2D_value

    property m3SIP3D:
        def __get__(self):
            self.m3SIP3D_branch.GetEntry(self.localentry, 0)
            return self.m3SIP3D_value

    property m3SegmentCompatibility:
        def __get__(self):
            self.m3SegmentCompatibility_branch.GetEntry(self.localentry, 0)
            return self.m3SegmentCompatibility_value

    property m3TkLayersWithMeasurement:
        def __get__(self):
            self.m3TkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.m3TkLayersWithMeasurement_value

    property m3TrkIsoDR03:
        def __get__(self):
            self.m3TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m3TrkIsoDR03_value

    property m3TrkKink:
        def __get__(self):
            self.m3TrkKink_branch.GetEntry(self.localentry, 0)
            return self.m3TrkKink_value

    property m3TypeCode:
        def __get__(self):
            self.m3TypeCode_branch.GetEntry(self.localentry, 0)
            return self.m3TypeCode_value

    property m3VZ:
        def __get__(self):
            self.m3VZ_branch.GetEntry(self.localentry, 0)
            return self.m3VZ_value

    property m3ValidFraction:
        def __get__(self):
            self.m3ValidFraction_branch.GetEntry(self.localentry, 0)
            return self.m3ValidFraction_value

    property m3ZTTGenMatching:
        def __get__(self):
            self.m3ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.m3ZTTGenMatching_value

    property m3_m1_collinearmass:
        def __get__(self):
            self.m3_m1_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.m3_m1_collinearmass_value

    property m3_m1_collinearmass_JetEnDown:
        def __get__(self):
            self.m3_m1_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3_m1_collinearmass_JetEnDown_value

    property m3_m1_collinearmass_JetEnUp:
        def __get__(self):
            self.m3_m1_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3_m1_collinearmass_JetEnUp_value

    property m3_m1_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.m3_m1_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3_m1_collinearmass_UnclusteredEnDown_value

    property m3_m1_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.m3_m1_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3_m1_collinearmass_UnclusteredEnUp_value

    property m3_m2_collinearmass:
        def __get__(self):
            self.m3_m2_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.m3_m2_collinearmass_value

    property m3_m2_collinearmass_JetEnDown:
        def __get__(self):
            self.m3_m2_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3_m2_collinearmass_JetEnDown_value

    property m3_m2_collinearmass_JetEnUp:
        def __get__(self):
            self.m3_m2_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3_m2_collinearmass_JetEnUp_value

    property m3_m2_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.m3_m2_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3_m2_collinearmass_UnclusteredEnDown_value

    property m3_m2_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.m3_m2_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3_m2_collinearmass_UnclusteredEnUp_value

    property metSig:
        def __get__(self):
            self.metSig_branch.GetEntry(self.localentry, 0)
            return self.metSig_value

    property metcov00:
        def __get__(self):
            self.metcov00_branch.GetEntry(self.localentry, 0)
            return self.metcov00_value

    property metcov01:
        def __get__(self):
            self.metcov01_branch.GetEntry(self.localentry, 0)
            return self.metcov01_value

    property metcov10:
        def __get__(self):
            self.metcov10_branch.GetEntry(self.localentry, 0)
            return self.metcov10_value

    property metcov11:
        def __get__(self):
            self.metcov11_branch.GetEntry(self.localentry, 0)
            return self.metcov11_value

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

    property singleE25eta2p1LooseGroup:
        def __get__(self):
            self.singleE25eta2p1LooseGroup_branch.GetEntry(self.localentry, 0)
            return self.singleE25eta2p1LooseGroup_value

    property singleE25eta2p1LoosePass:
        def __get__(self):
            self.singleE25eta2p1LoosePass_branch.GetEntry(self.localentry, 0)
            return self.singleE25eta2p1LoosePass_value

    property singleE25eta2p1LoosePrescale:
        def __get__(self):
            self.singleE25eta2p1LoosePrescale_branch.GetEntry(self.localentry, 0)
            return self.singleE25eta2p1LoosePrescale_value

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


