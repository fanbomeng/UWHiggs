

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

    cdef TBranch* Ele45L1JetTauSeededGroup_branch
    cdef float Ele45L1JetTauSeededGroup_value

    cdef TBranch* Ele45L1JetTauSeededPass_branch
    cdef float Ele45L1JetTauSeededPass_value

    cdef TBranch* Ele45L1JetTauSeededPrescale_branch
    cdef float Ele45L1JetTauSeededPrescale_value

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

    cdef TBranch* jet1PtJESClosure_Down_branch
    cdef float jet1PtJESClosure_Down_value

    cdef TBranch* jet1PtJESClosure_Up_branch
    cdef float jet1PtJESClosure_Up_value

    cdef TBranch* jet1PtJESTotal_Down_branch
    cdef float jet1PtJESTotal_Down_value

    cdef TBranch* jet1PtJESTotal_Up_branch
    cdef float jet1PtJESTotal_Up_value

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

    cdef TBranch* jet2PtJESClosure_Down_branch
    cdef float jet2PtJESClosure_Down_value

    cdef TBranch* jet2PtJESClosure_Up_branch
    cdef float jet2PtJESClosure_Up_value

    cdef TBranch* jet2PtJESTotal_Down_branch
    cdef float jet2PtJESTotal_Down_value

    cdef TBranch* jet2PtJESTotal_Up_branch
    cdef float jet2PtJESTotal_Up_value

    cdef TBranch* jetVeto20_branch
    cdef float jetVeto20_value

    cdef TBranch* jetVeto20_JetEnDown_branch
    cdef float jetVeto20_JetEnDown_value

    cdef TBranch* jetVeto20_JetEnUp_branch
    cdef float jetVeto20_JetEnUp_value

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

    cdef TBranch* jetVeto30_JetAbsoluteFlavMapDown_branch
    cdef float jetVeto30_JetAbsoluteFlavMapDown_value

    cdef TBranch* jetVeto30_JetAbsoluteFlavMapUp_branch
    cdef float jetVeto30_JetAbsoluteFlavMapUp_value

    cdef TBranch* jetVeto30_JetAbsoluteMPFBiasDown_branch
    cdef float jetVeto30_JetAbsoluteMPFBiasDown_value

    cdef TBranch* jetVeto30_JetAbsoluteMPFBiasUp_branch
    cdef float jetVeto30_JetAbsoluteMPFBiasUp_value

    cdef TBranch* jetVeto30_JetAbsoluteScaleDown_branch
    cdef float jetVeto30_JetAbsoluteScaleDown_value

    cdef TBranch* jetVeto30_JetAbsoluteScaleUp_branch
    cdef float jetVeto30_JetAbsoluteScaleUp_value

    cdef TBranch* jetVeto30_JetAbsoluteStatDown_branch
    cdef float jetVeto30_JetAbsoluteStatDown_value

    cdef TBranch* jetVeto30_JetAbsoluteStatUp_branch
    cdef float jetVeto30_JetAbsoluteStatUp_value

    cdef TBranch* jetVeto30_JetClosureDown_branch
    cdef float jetVeto30_JetClosureDown_value

    cdef TBranch* jetVeto30_JetClosureUp_branch
    cdef float jetVeto30_JetClosureUp_value

    cdef TBranch* jetVeto30_JetEnDown_branch
    cdef float jetVeto30_JetEnDown_value

    cdef TBranch* jetVeto30_JetEnUp_branch
    cdef float jetVeto30_JetEnUp_value

    cdef TBranch* jetVeto30_JetFlavorQCDDown_branch
    cdef float jetVeto30_JetFlavorQCDDown_value

    cdef TBranch* jetVeto30_JetFlavorQCDUp_branch
    cdef float jetVeto30_JetFlavorQCDUp_value

    cdef TBranch* jetVeto30_JetFragmentationDown_branch
    cdef float jetVeto30_JetFragmentationDown_value

    cdef TBranch* jetVeto30_JetFragmentationUp_branch
    cdef float jetVeto30_JetFragmentationUp_value

    cdef TBranch* jetVeto30_JetPileUpDataMCDown_branch
    cdef float jetVeto30_JetPileUpDataMCDown_value

    cdef TBranch* jetVeto30_JetPileUpDataMCUp_branch
    cdef float jetVeto30_JetPileUpDataMCUp_value

    cdef TBranch* jetVeto30_JetPileUpPtBBDown_branch
    cdef float jetVeto30_JetPileUpPtBBDown_value

    cdef TBranch* jetVeto30_JetPileUpPtBBUp_branch
    cdef float jetVeto30_JetPileUpPtBBUp_value

    cdef TBranch* jetVeto30_JetPileUpPtEC1Down_branch
    cdef float jetVeto30_JetPileUpPtEC1Down_value

    cdef TBranch* jetVeto30_JetPileUpPtEC1Up_branch
    cdef float jetVeto30_JetPileUpPtEC1Up_value

    cdef TBranch* jetVeto30_JetPileUpPtEC2Down_branch
    cdef float jetVeto30_JetPileUpPtEC2Down_value

    cdef TBranch* jetVeto30_JetPileUpPtEC2Up_branch
    cdef float jetVeto30_JetPileUpPtEC2Up_value

    cdef TBranch* jetVeto30_JetPileUpPtHFDown_branch
    cdef float jetVeto30_JetPileUpPtHFDown_value

    cdef TBranch* jetVeto30_JetPileUpPtHFUp_branch
    cdef float jetVeto30_JetPileUpPtHFUp_value

    cdef TBranch* jetVeto30_JetPileUpPtRefDown_branch
    cdef float jetVeto30_JetPileUpPtRefDown_value

    cdef TBranch* jetVeto30_JetPileUpPtRefUp_branch
    cdef float jetVeto30_JetPileUpPtRefUp_value

    cdef TBranch* jetVeto30_JetRelativeBalDown_branch
    cdef float jetVeto30_JetRelativeBalDown_value

    cdef TBranch* jetVeto30_JetRelativeBalUp_branch
    cdef float jetVeto30_JetRelativeBalUp_value

    cdef TBranch* jetVeto30_JetRelativeFSRDown_branch
    cdef float jetVeto30_JetRelativeFSRDown_value

    cdef TBranch* jetVeto30_JetRelativeFSRUp_branch
    cdef float jetVeto30_JetRelativeFSRUp_value

    cdef TBranch* jetVeto30_JetRelativeJEREC1Down_branch
    cdef float jetVeto30_JetRelativeJEREC1Down_value

    cdef TBranch* jetVeto30_JetRelativeJEREC1Up_branch
    cdef float jetVeto30_JetRelativeJEREC1Up_value

    cdef TBranch* jetVeto30_JetRelativeJEREC2Down_branch
    cdef float jetVeto30_JetRelativeJEREC2Down_value

    cdef TBranch* jetVeto30_JetRelativeJEREC2Up_branch
    cdef float jetVeto30_JetRelativeJEREC2Up_value

    cdef TBranch* jetVeto30_JetRelativeJERHFDown_branch
    cdef float jetVeto30_JetRelativeJERHFDown_value

    cdef TBranch* jetVeto30_JetRelativeJERHFUp_branch
    cdef float jetVeto30_JetRelativeJERHFUp_value

    cdef TBranch* jetVeto30_JetRelativePtBBDown_branch
    cdef float jetVeto30_JetRelativePtBBDown_value

    cdef TBranch* jetVeto30_JetRelativePtBBUp_branch
    cdef float jetVeto30_JetRelativePtBBUp_value

    cdef TBranch* jetVeto30_JetRelativePtEC1Down_branch
    cdef float jetVeto30_JetRelativePtEC1Down_value

    cdef TBranch* jetVeto30_JetRelativePtEC1Up_branch
    cdef float jetVeto30_JetRelativePtEC1Up_value

    cdef TBranch* jetVeto30_JetRelativePtEC2Down_branch
    cdef float jetVeto30_JetRelativePtEC2Down_value

    cdef TBranch* jetVeto30_JetRelativePtEC2Up_branch
    cdef float jetVeto30_JetRelativePtEC2Up_value

    cdef TBranch* jetVeto30_JetRelativePtHFDown_branch
    cdef float jetVeto30_JetRelativePtHFDown_value

    cdef TBranch* jetVeto30_JetRelativePtHFUp_branch
    cdef float jetVeto30_JetRelativePtHFUp_value

    cdef TBranch* jetVeto30_JetRelativeStatECDown_branch
    cdef float jetVeto30_JetRelativeStatECDown_value

    cdef TBranch* jetVeto30_JetRelativeStatECUp_branch
    cdef float jetVeto30_JetRelativeStatECUp_value

    cdef TBranch* jetVeto30_JetRelativeStatFSRDown_branch
    cdef float jetVeto30_JetRelativeStatFSRDown_value

    cdef TBranch* jetVeto30_JetRelativeStatFSRUp_branch
    cdef float jetVeto30_JetRelativeStatFSRUp_value

    cdef TBranch* jetVeto30_JetRelativeStatHFDown_branch
    cdef float jetVeto30_JetRelativeStatHFDown_value

    cdef TBranch* jetVeto30_JetRelativeStatHFUp_branch
    cdef float jetVeto30_JetRelativeStatHFUp_value

    cdef TBranch* jetVeto30_JetSinglePionECALDown_branch
    cdef float jetVeto30_JetSinglePionECALDown_value

    cdef TBranch* jetVeto30_JetSinglePionECALUp_branch
    cdef float jetVeto30_JetSinglePionECALUp_value

    cdef TBranch* jetVeto30_JetSinglePionHCALDown_branch
    cdef float jetVeto30_JetSinglePionHCALDown_value

    cdef TBranch* jetVeto30_JetSinglePionHCALUp_branch
    cdef float jetVeto30_JetSinglePionHCALUp_value

    cdef TBranch* jetVeto30_JetSubTotalAbsoluteDown_branch
    cdef float jetVeto30_JetSubTotalAbsoluteDown_value

    cdef TBranch* jetVeto30_JetSubTotalAbsoluteUp_branch
    cdef float jetVeto30_JetSubTotalAbsoluteUp_value

    cdef TBranch* jetVeto30_JetSubTotalMCDown_branch
    cdef float jetVeto30_JetSubTotalMCDown_value

    cdef TBranch* jetVeto30_JetSubTotalMCUp_branch
    cdef float jetVeto30_JetSubTotalMCUp_value

    cdef TBranch* jetVeto30_JetSubTotalPileUpDown_branch
    cdef float jetVeto30_JetSubTotalPileUpDown_value

    cdef TBranch* jetVeto30_JetSubTotalPileUpUp_branch
    cdef float jetVeto30_JetSubTotalPileUpUp_value

    cdef TBranch* jetVeto30_JetSubTotalPtDown_branch
    cdef float jetVeto30_JetSubTotalPtDown_value

    cdef TBranch* jetVeto30_JetSubTotalPtUp_branch
    cdef float jetVeto30_JetSubTotalPtUp_value

    cdef TBranch* jetVeto30_JetSubTotalRelativeDown_branch
    cdef float jetVeto30_JetSubTotalRelativeDown_value

    cdef TBranch* jetVeto30_JetSubTotalRelativeUp_branch
    cdef float jetVeto30_JetSubTotalRelativeUp_value

    cdef TBranch* jetVeto30_JetSubTotalScaleDown_branch
    cdef float jetVeto30_JetSubTotalScaleDown_value

    cdef TBranch* jetVeto30_JetSubTotalScaleUp_branch
    cdef float jetVeto30_JetSubTotalScaleUp_value

    cdef TBranch* jetVeto30_JetTimePtEtaDown_branch
    cdef float jetVeto30_JetTimePtEtaDown_value

    cdef TBranch* jetVeto30_JetTimePtEtaUp_branch
    cdef float jetVeto30_JetTimePtEtaUp_value

    cdef TBranch* jetVeto30_JetTotalDown_branch
    cdef float jetVeto30_JetTotalDown_value

    cdef TBranch* jetVeto30_JetTotalUp_branch
    cdef float jetVeto30_JetTotalUp_value

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* mAbsEta_branch
    cdef float mAbsEta_value

    cdef TBranch* mBestTrackType_branch
    cdef float mBestTrackType_value

    cdef TBranch* mCharge_branch
    cdef float mCharge_value

    cdef TBranch* mChi2LocalPosition_branch
    cdef float mChi2LocalPosition_value

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

    cdef TBranch* mErsatzGenEta_branch
    cdef float mErsatzGenEta_value

    cdef TBranch* mErsatzGenM_branch
    cdef float mErsatzGenM_value

    cdef TBranch* mErsatzGenPhi_branch
    cdef float mErsatzGenPhi_value

    cdef TBranch* mErsatzGenpT_branch
    cdef float mErsatzGenpT_value

    cdef TBranch* mErsatzGenpX_branch
    cdef float mErsatzGenpX_value

    cdef TBranch* mErsatzGenpY_branch
    cdef float mErsatzGenpY_value

    cdef TBranch* mErsatzVispX_branch
    cdef float mErsatzVispX_value

    cdef TBranch* mErsatzVispY_branch
    cdef float mErsatzVispY_value

    cdef TBranch* mEta_branch
    cdef float mEta_value

    cdef TBranch* mEta_MuonEnDown_branch
    cdef float mEta_MuonEnDown_value

    cdef TBranch* mEta_MuonEnUp_branch
    cdef float mEta_MuonEnUp_value

    cdef TBranch* mGenCharge_branch
    cdef float mGenCharge_value

    cdef TBranch* mGenDirectPromptTauDecayFinalState_branch
    cdef float mGenDirectPromptTauDecayFinalState_value

    cdef TBranch* mGenEnergy_branch
    cdef float mGenEnergy_value

    cdef TBranch* mGenEta_branch
    cdef float mGenEta_value

    cdef TBranch* mGenIsPrompt_branch
    cdef float mGenIsPrompt_value

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

    cdef TBranch* mGenPromptFinalState_branch
    cdef float mGenPromptFinalState_value

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

    cdef TBranch* mIsoDB03_branch
    cdef float mIsoDB03_value

    cdef TBranch* mIsoDB04_branch
    cdef float mIsoDB04_value

    cdef TBranch* mIsoMu22Filter_branch
    cdef float mIsoMu22Filter_value

    cdef TBranch* mIsoMu22eta2p1Filter_branch
    cdef float mIsoMu22eta2p1Filter_value

    cdef TBranch* mIsoMu24Filter_branch
    cdef float mIsoMu24Filter_value

    cdef TBranch* mIsoMu24eta2p1Filter_branch
    cdef float mIsoMu24eta2p1Filter_value

    cdef TBranch* mIsoTkMu22Filter_branch
    cdef float mIsoTkMu22Filter_value

    cdef TBranch* mIsoTkMu22eta2p1Filter_branch
    cdef float mIsoTkMu22eta2p1Filter_value

    cdef TBranch* mIsoTkMu24Filter_branch
    cdef float mIsoTkMu24Filter_value

    cdef TBranch* mIsoTkMu24eta2p1Filter_branch
    cdef float mIsoTkMu24eta2p1Filter_value

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

    cdef TBranch* mJetHadronFlavour_branch
    cdef float mJetHadronFlavour_value

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

    cdef TBranch* mMatchesIsoMu22Path_branch
    cdef float mMatchesIsoMu22Path_value

    cdef TBranch* mMatchesIsoMu22eta2p1Path_branch
    cdef float mMatchesIsoMu22eta2p1Path_value

    cdef TBranch* mMatchesIsoMu24Path_branch
    cdef float mMatchesIsoMu24Path_value

    cdef TBranch* mMatchesIsoMu24eta2p1Path_branch
    cdef float mMatchesIsoMu24eta2p1Path_value

    cdef TBranch* mMatchesIsoTkMu22Path_branch
    cdef float mMatchesIsoTkMu22Path_value

    cdef TBranch* mMatchesIsoTkMu22eta2p1Path_branch
    cdef float mMatchesIsoTkMu22eta2p1Path_value

    cdef TBranch* mMatchesIsoTkMu24Path_branch
    cdef float mMatchesIsoTkMu24Path_value

    cdef TBranch* mMatchesIsoTkMu24eta2p1Path_branch
    cdef float mMatchesIsoTkMu24eta2p1Path_value

    cdef TBranch* mMatchesMu19Tau20Filter_branch
    cdef float mMatchesMu19Tau20Filter_value

    cdef TBranch* mMatchesMu19Tau20Path_branch
    cdef float mMatchesMu19Tau20Path_value

    cdef TBranch* mMatchesMu19Tau20sL1Filter_branch
    cdef float mMatchesMu19Tau20sL1Filter_value

    cdef TBranch* mMatchesMu19Tau20sL1Path_branch
    cdef float mMatchesMu19Tau20sL1Path_value

    cdef TBranch* mMatchesMu23Ele12Path_branch
    cdef float mMatchesMu23Ele12Path_value

    cdef TBranch* mMatchesMu8Ele23Path_branch
    cdef float mMatchesMu8Ele23Path_value

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

    cdef TBranch* mMu23Ele12Filter_branch
    cdef float mMu23Ele12Filter_value

    cdef TBranch* mMu8Ele23Filter_branch
    cdef float mMu8Ele23Filter_value

    cdef TBranch* mMuonHits_branch
    cdef float mMuonHits_value

    cdef TBranch* mNearestZMass_branch
    cdef float mNearestZMass_value

    cdef TBranch* mNormTrkChi2_branch
    cdef float mNormTrkChi2_value

    cdef TBranch* mNormalizedChi2_branch
    cdef float mNormalizedChi2_value

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

    cdef TBranch* mSegmentCompatibility_branch
    cdef float mSegmentCompatibility_value

    cdef TBranch* mTkLayersWithMeasurement_branch
    cdef float mTkLayersWithMeasurement_value

    cdef TBranch* mTrkIsoDR03_branch
    cdef float mTrkIsoDR03_value

    cdef TBranch* mTrkKink_branch
    cdef float mTrkKink_value

    cdef TBranch* mTypeCode_branch
    cdef int mTypeCode_value

    cdef TBranch* mVZ_branch
    cdef float mVZ_value

    cdef TBranch* mValidFraction_branch
    cdef float mValidFraction_value

    cdef TBranch* mZTTGenMatching_branch
    cdef float mZTTGenMatching_value

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

    cdef TBranch* m_t_MtTotal_branch
    cdef float m_t_MtTotal_value

    cdef TBranch* m_t_Mt_TauEnDown_branch
    cdef float m_t_Mt_TauEnDown_value

    cdef TBranch* m_t_Mt_TauEnUp_branch
    cdef float m_t_Mt_TauEnUp_value

    cdef TBranch* m_t_MvaMet_branch
    cdef float m_t_MvaMet_value

    cdef TBranch* m_t_MvaMetCovMatrix00_branch
    cdef float m_t_MvaMetCovMatrix00_value

    cdef TBranch* m_t_MvaMetCovMatrix01_branch
    cdef float m_t_MvaMetCovMatrix01_value

    cdef TBranch* m_t_MvaMetCovMatrix10_branch
    cdef float m_t_MvaMetCovMatrix10_value

    cdef TBranch* m_t_MvaMetCovMatrix11_branch
    cdef float m_t_MvaMetCovMatrix11_value

    cdef TBranch* m_t_MvaMetPhi_branch
    cdef float m_t_MvaMetPhi_value

    cdef TBranch* m_t_PZeta_branch
    cdef float m_t_PZeta_value

    cdef TBranch* m_t_PZetaLess0p85PZetaVis_branch
    cdef float m_t_PZetaLess0p85PZetaVis_value

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

    cdef TBranch* m_t_collinearmass_EleEnDown_branch
    cdef float m_t_collinearmass_EleEnDown_value

    cdef TBranch* m_t_collinearmass_EleEnUp_branch
    cdef float m_t_collinearmass_EleEnUp_value

    cdef TBranch* m_t_collinearmass_JetEnDown_branch
    cdef float m_t_collinearmass_JetEnDown_value

    cdef TBranch* m_t_collinearmass_JetEnUp_branch
    cdef float m_t_collinearmass_JetEnUp_value

    cdef TBranch* m_t_collinearmass_MuEnDown_branch
    cdef float m_t_collinearmass_MuEnDown_value

    cdef TBranch* m_t_collinearmass_MuEnUp_branch
    cdef float m_t_collinearmass_MuEnUp_value

    cdef TBranch* m_t_collinearmass_TauEnDown_branch
    cdef float m_t_collinearmass_TauEnDown_value

    cdef TBranch* m_t_collinearmass_TauEnUp_branch
    cdef float m_t_collinearmass_TauEnUp_value

    cdef TBranch* m_t_collinearmass_UnclusteredEnDown_branch
    cdef float m_t_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m_t_collinearmass_UnclusteredEnUp_branch
    cdef float m_t_collinearmass_UnclusteredEnUp_value

    cdef TBranch* m_t_pt_tt_branch
    cdef float m_t_pt_tt_value

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

    cdef TBranch* tMatchesEle24Tau20L1Filter_branch
    cdef float tMatchesEle24Tau20L1Filter_value

    cdef TBranch* tMatchesEle24Tau20L1Path_branch
    cdef float tMatchesEle24Tau20L1Path_value

    cdef TBranch* tMatchesEle24Tau20Path_branch
    cdef float tMatchesEle24Tau20Path_value

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

    cdef TBranch* t_m_collinearmass_branch
    cdef float t_m_collinearmass_value

    cdef TBranch* t_m_collinearmass_JetEnDown_branch
    cdef float t_m_collinearmass_JetEnDown_value

    cdef TBranch* t_m_collinearmass_JetEnUp_branch
    cdef float t_m_collinearmass_JetEnUp_value

    cdef TBranch* t_m_collinearmass_UnclusteredEnDown_branch
    cdef float t_m_collinearmass_UnclusteredEnDown_value

    cdef TBranch* t_m_collinearmass_UnclusteredEnUp_branch
    cdef float t_m_collinearmass_UnclusteredEnUp_value

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

    cdef TBranch* vbfMass_JetAbsoluteFlavMapDown_branch
    cdef float vbfMass_JetAbsoluteFlavMapDown_value

    cdef TBranch* vbfMass_JetAbsoluteFlavMapUp_branch
    cdef float vbfMass_JetAbsoluteFlavMapUp_value

    cdef TBranch* vbfMass_JetAbsoluteMPFBiasDown_branch
    cdef float vbfMass_JetAbsoluteMPFBiasDown_value

    cdef TBranch* vbfMass_JetAbsoluteMPFBiasUp_branch
    cdef float vbfMass_JetAbsoluteMPFBiasUp_value

    cdef TBranch* vbfMass_JetAbsoluteScaleDown_branch
    cdef float vbfMass_JetAbsoluteScaleDown_value

    cdef TBranch* vbfMass_JetAbsoluteScaleUp_branch
    cdef float vbfMass_JetAbsoluteScaleUp_value

    cdef TBranch* vbfMass_JetAbsoluteStatDown_branch
    cdef float vbfMass_JetAbsoluteStatDown_value

    cdef TBranch* vbfMass_JetAbsoluteStatUp_branch
    cdef float vbfMass_JetAbsoluteStatUp_value

    cdef TBranch* vbfMass_JetClosureDown_branch
    cdef float vbfMass_JetClosureDown_value

    cdef TBranch* vbfMass_JetClosureUp_branch
    cdef float vbfMass_JetClosureUp_value

    cdef TBranch* vbfMass_JetEnDown_branch
    cdef float vbfMass_JetEnDown_value

    cdef TBranch* vbfMass_JetEnUp_branch
    cdef float vbfMass_JetEnUp_value

    cdef TBranch* vbfMass_JetFlavorQCDDown_branch
    cdef float vbfMass_JetFlavorQCDDown_value

    cdef TBranch* vbfMass_JetFlavorQCDUp_branch
    cdef float vbfMass_JetFlavorQCDUp_value

    cdef TBranch* vbfMass_JetFragmentationDown_branch
    cdef float vbfMass_JetFragmentationDown_value

    cdef TBranch* vbfMass_JetFragmentationUp_branch
    cdef float vbfMass_JetFragmentationUp_value

    cdef TBranch* vbfMass_JetPileUpDataMCDown_branch
    cdef float vbfMass_JetPileUpDataMCDown_value

    cdef TBranch* vbfMass_JetPileUpDataMCUp_branch
    cdef float vbfMass_JetPileUpDataMCUp_value

    cdef TBranch* vbfMass_JetPileUpPtBBDown_branch
    cdef float vbfMass_JetPileUpPtBBDown_value

    cdef TBranch* vbfMass_JetPileUpPtBBUp_branch
    cdef float vbfMass_JetPileUpPtBBUp_value

    cdef TBranch* vbfMass_JetPileUpPtEC1Down_branch
    cdef float vbfMass_JetPileUpPtEC1Down_value

    cdef TBranch* vbfMass_JetPileUpPtEC1Up_branch
    cdef float vbfMass_JetPileUpPtEC1Up_value

    cdef TBranch* vbfMass_JetPileUpPtEC2Down_branch
    cdef float vbfMass_JetPileUpPtEC2Down_value

    cdef TBranch* vbfMass_JetPileUpPtEC2Up_branch
    cdef float vbfMass_JetPileUpPtEC2Up_value

    cdef TBranch* vbfMass_JetPileUpPtHFDown_branch
    cdef float vbfMass_JetPileUpPtHFDown_value

    cdef TBranch* vbfMass_JetPileUpPtHFUp_branch
    cdef float vbfMass_JetPileUpPtHFUp_value

    cdef TBranch* vbfMass_JetPileUpPtRefDown_branch
    cdef float vbfMass_JetPileUpPtRefDown_value

    cdef TBranch* vbfMass_JetPileUpPtRefUp_branch
    cdef float vbfMass_JetPileUpPtRefUp_value

    cdef TBranch* vbfMass_JetRelativeBalDown_branch
    cdef float vbfMass_JetRelativeBalDown_value

    cdef TBranch* vbfMass_JetRelativeBalUp_branch
    cdef float vbfMass_JetRelativeBalUp_value

    cdef TBranch* vbfMass_JetRelativeFSRDown_branch
    cdef float vbfMass_JetRelativeFSRDown_value

    cdef TBranch* vbfMass_JetRelativeFSRUp_branch
    cdef float vbfMass_JetRelativeFSRUp_value

    cdef TBranch* vbfMass_JetRelativeJEREC1Down_branch
    cdef float vbfMass_JetRelativeJEREC1Down_value

    cdef TBranch* vbfMass_JetRelativeJEREC1Up_branch
    cdef float vbfMass_JetRelativeJEREC1Up_value

    cdef TBranch* vbfMass_JetRelativeJEREC2Down_branch
    cdef float vbfMass_JetRelativeJEREC2Down_value

    cdef TBranch* vbfMass_JetRelativeJEREC2Up_branch
    cdef float vbfMass_JetRelativeJEREC2Up_value

    cdef TBranch* vbfMass_JetRelativeJERHFDown_branch
    cdef float vbfMass_JetRelativeJERHFDown_value

    cdef TBranch* vbfMass_JetRelativeJERHFUp_branch
    cdef float vbfMass_JetRelativeJERHFUp_value

    cdef TBranch* vbfMass_JetRelativePtBBDown_branch
    cdef float vbfMass_JetRelativePtBBDown_value

    cdef TBranch* vbfMass_JetRelativePtBBUp_branch
    cdef float vbfMass_JetRelativePtBBUp_value

    cdef TBranch* vbfMass_JetRelativePtEC1Down_branch
    cdef float vbfMass_JetRelativePtEC1Down_value

    cdef TBranch* vbfMass_JetRelativePtEC1Up_branch
    cdef float vbfMass_JetRelativePtEC1Up_value

    cdef TBranch* vbfMass_JetRelativePtEC2Down_branch
    cdef float vbfMass_JetRelativePtEC2Down_value

    cdef TBranch* vbfMass_JetRelativePtEC2Up_branch
    cdef float vbfMass_JetRelativePtEC2Up_value

    cdef TBranch* vbfMass_JetRelativePtHFDown_branch
    cdef float vbfMass_JetRelativePtHFDown_value

    cdef TBranch* vbfMass_JetRelativePtHFUp_branch
    cdef float vbfMass_JetRelativePtHFUp_value

    cdef TBranch* vbfMass_JetRelativeStatECDown_branch
    cdef float vbfMass_JetRelativeStatECDown_value

    cdef TBranch* vbfMass_JetRelativeStatECUp_branch
    cdef float vbfMass_JetRelativeStatECUp_value

    cdef TBranch* vbfMass_JetRelativeStatFSRDown_branch
    cdef float vbfMass_JetRelativeStatFSRDown_value

    cdef TBranch* vbfMass_JetRelativeStatFSRUp_branch
    cdef float vbfMass_JetRelativeStatFSRUp_value

    cdef TBranch* vbfMass_JetRelativeStatHFDown_branch
    cdef float vbfMass_JetRelativeStatHFDown_value

    cdef TBranch* vbfMass_JetRelativeStatHFUp_branch
    cdef float vbfMass_JetRelativeStatHFUp_value

    cdef TBranch* vbfMass_JetSinglePionECALDown_branch
    cdef float vbfMass_JetSinglePionECALDown_value

    cdef TBranch* vbfMass_JetSinglePionECALUp_branch
    cdef float vbfMass_JetSinglePionECALUp_value

    cdef TBranch* vbfMass_JetSinglePionHCALDown_branch
    cdef float vbfMass_JetSinglePionHCALDown_value

    cdef TBranch* vbfMass_JetSinglePionHCALUp_branch
    cdef float vbfMass_JetSinglePionHCALUp_value

    cdef TBranch* vbfMass_JetSubTotalAbsoluteDown_branch
    cdef float vbfMass_JetSubTotalAbsoluteDown_value

    cdef TBranch* vbfMass_JetSubTotalAbsoluteUp_branch
    cdef float vbfMass_JetSubTotalAbsoluteUp_value

    cdef TBranch* vbfMass_JetSubTotalMCDown_branch
    cdef float vbfMass_JetSubTotalMCDown_value

    cdef TBranch* vbfMass_JetSubTotalMCUp_branch
    cdef float vbfMass_JetSubTotalMCUp_value

    cdef TBranch* vbfMass_JetSubTotalPileUpDown_branch
    cdef float vbfMass_JetSubTotalPileUpDown_value

    cdef TBranch* vbfMass_JetSubTotalPileUpUp_branch
    cdef float vbfMass_JetSubTotalPileUpUp_value

    cdef TBranch* vbfMass_JetSubTotalPtDown_branch
    cdef float vbfMass_JetSubTotalPtDown_value

    cdef TBranch* vbfMass_JetSubTotalPtUp_branch
    cdef float vbfMass_JetSubTotalPtUp_value

    cdef TBranch* vbfMass_JetSubTotalRelativeDown_branch
    cdef float vbfMass_JetSubTotalRelativeDown_value

    cdef TBranch* vbfMass_JetSubTotalRelativeUp_branch
    cdef float vbfMass_JetSubTotalRelativeUp_value

    cdef TBranch* vbfMass_JetSubTotalScaleDown_branch
    cdef float vbfMass_JetSubTotalScaleDown_value

    cdef TBranch* vbfMass_JetSubTotalScaleUp_branch
    cdef float vbfMass_JetSubTotalScaleUp_value

    cdef TBranch* vbfMass_JetTimePtEtaDown_branch
    cdef float vbfMass_JetTimePtEtaDown_value

    cdef TBranch* vbfMass_JetTimePtEtaUp_branch
    cdef float vbfMass_JetTimePtEtaUp_value

    cdef TBranch* vbfMass_JetTotalDown_branch
    cdef float vbfMass_JetTotalDown_value

    cdef TBranch* vbfMass_JetTotalUp_branch
    cdef float vbfMass_JetTotalUp_value

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

        #print "making Ele45L1JetTauSeededGroup"
        self.Ele45L1JetTauSeededGroup_branch = the_tree.GetBranch("Ele45L1JetTauSeededGroup")
        #if not self.Ele45L1JetTauSeededGroup_branch and "Ele45L1JetTauSeededGroup" not in self.complained:
        if not self.Ele45L1JetTauSeededGroup_branch and "Ele45L1JetTauSeededGroup":
            warnings.warn( "MuTauTree: Expected branch Ele45L1JetTauSeededGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele45L1JetTauSeededGroup")
        else:
            self.Ele45L1JetTauSeededGroup_branch.SetAddress(<void*>&self.Ele45L1JetTauSeededGroup_value)

        #print "making Ele45L1JetTauSeededPass"
        self.Ele45L1JetTauSeededPass_branch = the_tree.GetBranch("Ele45L1JetTauSeededPass")
        #if not self.Ele45L1JetTauSeededPass_branch and "Ele45L1JetTauSeededPass" not in self.complained:
        if not self.Ele45L1JetTauSeededPass_branch and "Ele45L1JetTauSeededPass":
            warnings.warn( "MuTauTree: Expected branch Ele45L1JetTauSeededPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele45L1JetTauSeededPass")
        else:
            self.Ele45L1JetTauSeededPass_branch.SetAddress(<void*>&self.Ele45L1JetTauSeededPass_value)

        #print "making Ele45L1JetTauSeededPrescale"
        self.Ele45L1JetTauSeededPrescale_branch = the_tree.GetBranch("Ele45L1JetTauSeededPrescale")
        #if not self.Ele45L1JetTauSeededPrescale_branch and "Ele45L1JetTauSeededPrescale" not in self.complained:
        if not self.Ele45L1JetTauSeededPrescale_branch and "Ele45L1JetTauSeededPrescale":
            warnings.warn( "MuTauTree: Expected branch Ele45L1JetTauSeededPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele45L1JetTauSeededPrescale")
        else:
            self.Ele45L1JetTauSeededPrescale_branch.SetAddress(<void*>&self.Ele45L1JetTauSeededPrescale_value)

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

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "MuTauTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "MuTauTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

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

        #print "making doubleTauCmbIso35RegGroup"
        self.doubleTauCmbIso35RegGroup_branch = the_tree.GetBranch("doubleTauCmbIso35RegGroup")
        #if not self.doubleTauCmbIso35RegGroup_branch and "doubleTauCmbIso35RegGroup" not in self.complained:
        if not self.doubleTauCmbIso35RegGroup_branch and "doubleTauCmbIso35RegGroup":
            warnings.warn( "MuTauTree: Expected branch doubleTauCmbIso35RegGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegGroup")
        else:
            self.doubleTauCmbIso35RegGroup_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegGroup_value)

        #print "making doubleTauCmbIso35RegPass"
        self.doubleTauCmbIso35RegPass_branch = the_tree.GetBranch("doubleTauCmbIso35RegPass")
        #if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass" not in self.complained:
        if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass":
            warnings.warn( "MuTauTree: Expected branch doubleTauCmbIso35RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPass")
        else:
            self.doubleTauCmbIso35RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPass_value)

        #print "making doubleTauCmbIso35RegPrescale"
        self.doubleTauCmbIso35RegPrescale_branch = the_tree.GetBranch("doubleTauCmbIso35RegPrescale")
        #if not self.doubleTauCmbIso35RegPrescale_branch and "doubleTauCmbIso35RegPrescale" not in self.complained:
        if not self.doubleTauCmbIso35RegPrescale_branch and "doubleTauCmbIso35RegPrescale":
            warnings.warn( "MuTauTree: Expected branch doubleTauCmbIso35RegPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPrescale")
        else:
            self.doubleTauCmbIso35RegPrescale_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPrescale_value)

        #print "making doubleTauCmbIso40Group"
        self.doubleTauCmbIso40Group_branch = the_tree.GetBranch("doubleTauCmbIso40Group")
        #if not self.doubleTauCmbIso40Group_branch and "doubleTauCmbIso40Group" not in self.complained:
        if not self.doubleTauCmbIso40Group_branch and "doubleTauCmbIso40Group":
            warnings.warn( "MuTauTree: Expected branch doubleTauCmbIso40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40Group")
        else:
            self.doubleTauCmbIso40Group_branch.SetAddress(<void*>&self.doubleTauCmbIso40Group_value)

        #print "making doubleTauCmbIso40Pass"
        self.doubleTauCmbIso40Pass_branch = the_tree.GetBranch("doubleTauCmbIso40Pass")
        #if not self.doubleTauCmbIso40Pass_branch and "doubleTauCmbIso40Pass" not in self.complained:
        if not self.doubleTauCmbIso40Pass_branch and "doubleTauCmbIso40Pass":
            warnings.warn( "MuTauTree: Expected branch doubleTauCmbIso40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40Pass")
        else:
            self.doubleTauCmbIso40Pass_branch.SetAddress(<void*>&self.doubleTauCmbIso40Pass_value)

        #print "making doubleTauCmbIso40Prescale"
        self.doubleTauCmbIso40Prescale_branch = the_tree.GetBranch("doubleTauCmbIso40Prescale")
        #if not self.doubleTauCmbIso40Prescale_branch and "doubleTauCmbIso40Prescale" not in self.complained:
        if not self.doubleTauCmbIso40Prescale_branch and "doubleTauCmbIso40Prescale":
            warnings.warn( "MuTauTree: Expected branch doubleTauCmbIso40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40Prescale")
        else:
            self.doubleTauCmbIso40Prescale_branch.SetAddress(<void*>&self.doubleTauCmbIso40Prescale_value)

        #print "making doubleTauCmbIso40RegGroup"
        self.doubleTauCmbIso40RegGroup_branch = the_tree.GetBranch("doubleTauCmbIso40RegGroup")
        #if not self.doubleTauCmbIso40RegGroup_branch and "doubleTauCmbIso40RegGroup" not in self.complained:
        if not self.doubleTauCmbIso40RegGroup_branch and "doubleTauCmbIso40RegGroup":
            warnings.warn( "MuTauTree: Expected branch doubleTauCmbIso40RegGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40RegGroup")
        else:
            self.doubleTauCmbIso40RegGroup_branch.SetAddress(<void*>&self.doubleTauCmbIso40RegGroup_value)

        #print "making doubleTauCmbIso40RegPass"
        self.doubleTauCmbIso40RegPass_branch = the_tree.GetBranch("doubleTauCmbIso40RegPass")
        #if not self.doubleTauCmbIso40RegPass_branch and "doubleTauCmbIso40RegPass" not in self.complained:
        if not self.doubleTauCmbIso40RegPass_branch and "doubleTauCmbIso40RegPass":
            warnings.warn( "MuTauTree: Expected branch doubleTauCmbIso40RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40RegPass")
        else:
            self.doubleTauCmbIso40RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso40RegPass_value)

        #print "making doubleTauCmbIso40RegPrescale"
        self.doubleTauCmbIso40RegPrescale_branch = the_tree.GetBranch("doubleTauCmbIso40RegPrescale")
        #if not self.doubleTauCmbIso40RegPrescale_branch and "doubleTauCmbIso40RegPrescale" not in self.complained:
        if not self.doubleTauCmbIso40RegPrescale_branch and "doubleTauCmbIso40RegPrescale":
            warnings.warn( "MuTauTree: Expected branch doubleTauCmbIso40RegPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso40RegPrescale")
        else:
            self.doubleTauCmbIso40RegPrescale_branch.SetAddress(<void*>&self.doubleTauCmbIso40RegPrescale_value)

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

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "MuTauTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eVetoZTTp001dxyzR0"
        self.eVetoZTTp001dxyzR0_branch = the_tree.GetBranch("eVetoZTTp001dxyzR0")
        #if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0" not in self.complained:
        if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0":
            warnings.warn( "MuTauTree: Expected branch eVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyzR0")
        else:
            self.eVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.eVetoZTTp001dxyzR0_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "MuTauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "MuTauTree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "MuTauTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "MuTauTree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "MuTauTree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "MuTauTree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "MuTauTree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "MuTauTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "MuTauTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "MuTauTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWenu"
        self.isWenu_branch = the_tree.GetBranch("isWenu")
        #if not self.isWenu_branch and "isWenu" not in self.complained:
        if not self.isWenu_branch and "isWenu":
            warnings.warn( "MuTauTree: Expected branch isWenu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWenu")
        else:
            self.isWenu_branch.SetAddress(<void*>&self.isWenu_value)

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

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "MuTauTree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "MuTauTree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "MuTauTree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1partonflavor"
        self.j1partonflavor_branch = the_tree.GetBranch("j1partonflavor")
        #if not self.j1partonflavor_branch and "j1partonflavor" not in self.complained:
        if not self.j1partonflavor_branch and "j1partonflavor":
            warnings.warn( "MuTauTree: Expected branch j1partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1partonflavor")
        else:
            self.j1partonflavor_branch.SetAddress(<void*>&self.j1partonflavor_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "MuTauTree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "MuTauTree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptDown"
        self.j1ptDown_branch = the_tree.GetBranch("j1ptDown")
        #if not self.j1ptDown_branch and "j1ptDown" not in self.complained:
        if not self.j1ptDown_branch and "j1ptDown":
            warnings.warn( "MuTauTree: Expected branch j1ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptDown")
        else:
            self.j1ptDown_branch.SetAddress(<void*>&self.j1ptDown_value)

        #print "making j1ptUp"
        self.j1ptUp_branch = the_tree.GetBranch("j1ptUp")
        #if not self.j1ptUp_branch and "j1ptUp" not in self.complained:
        if not self.j1ptUp_branch and "j1ptUp":
            warnings.warn( "MuTauTree: Expected branch j1ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptUp")
        else:
            self.j1ptUp_branch.SetAddress(<void*>&self.j1ptUp_value)

        #print "making j1pu"
        self.j1pu_branch = the_tree.GetBranch("j1pu")
        #if not self.j1pu_branch and "j1pu" not in self.complained:
        if not self.j1pu_branch and "j1pu":
            warnings.warn( "MuTauTree: Expected branch j1pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pu")
        else:
            self.j1pu_branch.SetAddress(<void*>&self.j1pu_value)

        #print "making j1rawf"
        self.j1rawf_branch = the_tree.GetBranch("j1rawf")
        #if not self.j1rawf_branch and "j1rawf" not in self.complained:
        if not self.j1rawf_branch and "j1rawf":
            warnings.warn( "MuTauTree: Expected branch j1rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1rawf")
        else:
            self.j1rawf_branch.SetAddress(<void*>&self.j1rawf_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "MuTauTree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "MuTauTree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "MuTauTree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2partonflavor"
        self.j2partonflavor_branch = the_tree.GetBranch("j2partonflavor")
        #if not self.j2partonflavor_branch and "j2partonflavor" not in self.complained:
        if not self.j2partonflavor_branch and "j2partonflavor":
            warnings.warn( "MuTauTree: Expected branch j2partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2partonflavor")
        else:
            self.j2partonflavor_branch.SetAddress(<void*>&self.j2partonflavor_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "MuTauTree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "MuTauTree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptDown"
        self.j2ptDown_branch = the_tree.GetBranch("j2ptDown")
        #if not self.j2ptDown_branch and "j2ptDown" not in self.complained:
        if not self.j2ptDown_branch and "j2ptDown":
            warnings.warn( "MuTauTree: Expected branch j2ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptDown")
        else:
            self.j2ptDown_branch.SetAddress(<void*>&self.j2ptDown_value)

        #print "making j2ptUp"
        self.j2ptUp_branch = the_tree.GetBranch("j2ptUp")
        #if not self.j2ptUp_branch and "j2ptUp" not in self.complained:
        if not self.j2ptUp_branch and "j2ptUp":
            warnings.warn( "MuTauTree: Expected branch j2ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptUp")
        else:
            self.j2ptUp_branch.SetAddress(<void*>&self.j2ptUp_value)

        #print "making j2pu"
        self.j2pu_branch = the_tree.GetBranch("j2pu")
        #if not self.j2pu_branch and "j2pu" not in self.complained:
        if not self.j2pu_branch and "j2pu":
            warnings.warn( "MuTauTree: Expected branch j2pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pu")
        else:
            self.j2pu_branch.SetAddress(<void*>&self.j2pu_value)

        #print "making j2rawf"
        self.j2rawf_branch = the_tree.GetBranch("j2rawf")
        #if not self.j2rawf_branch and "j2rawf" not in self.complained:
        if not self.j2rawf_branch and "j2rawf":
            warnings.warn( "MuTauTree: Expected branch j2rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2rawf")
        else:
            self.j2rawf_branch.SetAddress(<void*>&self.j2rawf_value)

        #print "making jb1csv"
        self.jb1csv_branch = the_tree.GetBranch("jb1csv")
        #if not self.jb1csv_branch and "jb1csv" not in self.complained:
        if not self.jb1csv_branch and "jb1csv":
            warnings.warn( "MuTauTree: Expected branch jb1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csv")
        else:
            self.jb1csv_branch.SetAddress(<void*>&self.jb1csv_value)

        #print "making jb1csv_CSVL"
        self.jb1csv_CSVL_branch = the_tree.GetBranch("jb1csv_CSVL")
        #if not self.jb1csv_CSVL_branch and "jb1csv_CSVL" not in self.complained:
        if not self.jb1csv_CSVL_branch and "jb1csv_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb1csv_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csv_CSVL")
        else:
            self.jb1csv_CSVL_branch.SetAddress(<void*>&self.jb1csv_CSVL_value)

        #print "making jb1eta"
        self.jb1eta_branch = the_tree.GetBranch("jb1eta")
        #if not self.jb1eta_branch and "jb1eta" not in self.complained:
        if not self.jb1eta_branch and "jb1eta":
            warnings.warn( "MuTauTree: Expected branch jb1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta")
        else:
            self.jb1eta_branch.SetAddress(<void*>&self.jb1eta_value)

        #print "making jb1eta_CSVL"
        self.jb1eta_CSVL_branch = the_tree.GetBranch("jb1eta_CSVL")
        #if not self.jb1eta_CSVL_branch and "jb1eta_CSVL" not in self.complained:
        if not self.jb1eta_CSVL_branch and "jb1eta_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb1eta_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_CSVL")
        else:
            self.jb1eta_CSVL_branch.SetAddress(<void*>&self.jb1eta_CSVL_value)

        #print "making jb1hadronflavor"
        self.jb1hadronflavor_branch = the_tree.GetBranch("jb1hadronflavor")
        #if not self.jb1hadronflavor_branch and "jb1hadronflavor" not in self.complained:
        if not self.jb1hadronflavor_branch and "jb1hadronflavor":
            warnings.warn( "MuTauTree: Expected branch jb1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor")
        else:
            self.jb1hadronflavor_branch.SetAddress(<void*>&self.jb1hadronflavor_value)

        #print "making jb1hadronflavor_CSVL"
        self.jb1hadronflavor_CSVL_branch = the_tree.GetBranch("jb1hadronflavor_CSVL")
        #if not self.jb1hadronflavor_CSVL_branch and "jb1hadronflavor_CSVL" not in self.complained:
        if not self.jb1hadronflavor_CSVL_branch and "jb1hadronflavor_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb1hadronflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_CSVL")
        else:
            self.jb1hadronflavor_CSVL_branch.SetAddress(<void*>&self.jb1hadronflavor_CSVL_value)

        #print "making jb1partonflavor"
        self.jb1partonflavor_branch = the_tree.GetBranch("jb1partonflavor")
        #if not self.jb1partonflavor_branch and "jb1partonflavor" not in self.complained:
        if not self.jb1partonflavor_branch and "jb1partonflavor":
            warnings.warn( "MuTauTree: Expected branch jb1partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1partonflavor")
        else:
            self.jb1partonflavor_branch.SetAddress(<void*>&self.jb1partonflavor_value)

        #print "making jb1partonflavor_CSVL"
        self.jb1partonflavor_CSVL_branch = the_tree.GetBranch("jb1partonflavor_CSVL")
        #if not self.jb1partonflavor_CSVL_branch and "jb1partonflavor_CSVL" not in self.complained:
        if not self.jb1partonflavor_CSVL_branch and "jb1partonflavor_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb1partonflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1partonflavor_CSVL")
        else:
            self.jb1partonflavor_CSVL_branch.SetAddress(<void*>&self.jb1partonflavor_CSVL_value)

        #print "making jb1phi"
        self.jb1phi_branch = the_tree.GetBranch("jb1phi")
        #if not self.jb1phi_branch and "jb1phi" not in self.complained:
        if not self.jb1phi_branch and "jb1phi":
            warnings.warn( "MuTauTree: Expected branch jb1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi")
        else:
            self.jb1phi_branch.SetAddress(<void*>&self.jb1phi_value)

        #print "making jb1phi_CSVL"
        self.jb1phi_CSVL_branch = the_tree.GetBranch("jb1phi_CSVL")
        #if not self.jb1phi_CSVL_branch and "jb1phi_CSVL" not in self.complained:
        if not self.jb1phi_CSVL_branch and "jb1phi_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb1phi_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_CSVL")
        else:
            self.jb1phi_CSVL_branch.SetAddress(<void*>&self.jb1phi_CSVL_value)

        #print "making jb1pt"
        self.jb1pt_branch = the_tree.GetBranch("jb1pt")
        #if not self.jb1pt_branch and "jb1pt" not in self.complained:
        if not self.jb1pt_branch and "jb1pt":
            warnings.warn( "MuTauTree: Expected branch jb1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt")
        else:
            self.jb1pt_branch.SetAddress(<void*>&self.jb1pt_value)

        #print "making jb1ptDown"
        self.jb1ptDown_branch = the_tree.GetBranch("jb1ptDown")
        #if not self.jb1ptDown_branch and "jb1ptDown" not in self.complained:
        if not self.jb1ptDown_branch and "jb1ptDown":
            warnings.warn( "MuTauTree: Expected branch jb1ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptDown")
        else:
            self.jb1ptDown_branch.SetAddress(<void*>&self.jb1ptDown_value)

        #print "making jb1ptDown_CSVL"
        self.jb1ptDown_CSVL_branch = the_tree.GetBranch("jb1ptDown_CSVL")
        #if not self.jb1ptDown_CSVL_branch and "jb1ptDown_CSVL" not in self.complained:
        if not self.jb1ptDown_CSVL_branch and "jb1ptDown_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb1ptDown_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptDown_CSVL")
        else:
            self.jb1ptDown_CSVL_branch.SetAddress(<void*>&self.jb1ptDown_CSVL_value)

        #print "making jb1ptUp"
        self.jb1ptUp_branch = the_tree.GetBranch("jb1ptUp")
        #if not self.jb1ptUp_branch and "jb1ptUp" not in self.complained:
        if not self.jb1ptUp_branch and "jb1ptUp":
            warnings.warn( "MuTauTree: Expected branch jb1ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptUp")
        else:
            self.jb1ptUp_branch.SetAddress(<void*>&self.jb1ptUp_value)

        #print "making jb1ptUp_CSVL"
        self.jb1ptUp_CSVL_branch = the_tree.GetBranch("jb1ptUp_CSVL")
        #if not self.jb1ptUp_CSVL_branch and "jb1ptUp_CSVL" not in self.complained:
        if not self.jb1ptUp_CSVL_branch and "jb1ptUp_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb1ptUp_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptUp_CSVL")
        else:
            self.jb1ptUp_CSVL_branch.SetAddress(<void*>&self.jb1ptUp_CSVL_value)

        #print "making jb1pt_CSVL"
        self.jb1pt_CSVL_branch = the_tree.GetBranch("jb1pt_CSVL")
        #if not self.jb1pt_CSVL_branch and "jb1pt_CSVL" not in self.complained:
        if not self.jb1pt_CSVL_branch and "jb1pt_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb1pt_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_CSVL")
        else:
            self.jb1pt_CSVL_branch.SetAddress(<void*>&self.jb1pt_CSVL_value)

        #print "making jb1pu"
        self.jb1pu_branch = the_tree.GetBranch("jb1pu")
        #if not self.jb1pu_branch and "jb1pu" not in self.complained:
        if not self.jb1pu_branch and "jb1pu":
            warnings.warn( "MuTauTree: Expected branch jb1pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pu")
        else:
            self.jb1pu_branch.SetAddress(<void*>&self.jb1pu_value)

        #print "making jb1pu_CSVL"
        self.jb1pu_CSVL_branch = the_tree.GetBranch("jb1pu_CSVL")
        #if not self.jb1pu_CSVL_branch and "jb1pu_CSVL" not in self.complained:
        if not self.jb1pu_CSVL_branch and "jb1pu_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb1pu_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pu_CSVL")
        else:
            self.jb1pu_CSVL_branch.SetAddress(<void*>&self.jb1pu_CSVL_value)

        #print "making jb1rawf"
        self.jb1rawf_branch = the_tree.GetBranch("jb1rawf")
        #if not self.jb1rawf_branch and "jb1rawf" not in self.complained:
        if not self.jb1rawf_branch and "jb1rawf":
            warnings.warn( "MuTauTree: Expected branch jb1rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1rawf")
        else:
            self.jb1rawf_branch.SetAddress(<void*>&self.jb1rawf_value)

        #print "making jb1rawf_CSVL"
        self.jb1rawf_CSVL_branch = the_tree.GetBranch("jb1rawf_CSVL")
        #if not self.jb1rawf_CSVL_branch and "jb1rawf_CSVL" not in self.complained:
        if not self.jb1rawf_CSVL_branch and "jb1rawf_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb1rawf_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1rawf_CSVL")
        else:
            self.jb1rawf_CSVL_branch.SetAddress(<void*>&self.jb1rawf_CSVL_value)

        #print "making jb2csv"
        self.jb2csv_branch = the_tree.GetBranch("jb2csv")
        #if not self.jb2csv_branch and "jb2csv" not in self.complained:
        if not self.jb2csv_branch and "jb2csv":
            warnings.warn( "MuTauTree: Expected branch jb2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csv")
        else:
            self.jb2csv_branch.SetAddress(<void*>&self.jb2csv_value)

        #print "making jb2csv_CSVL"
        self.jb2csv_CSVL_branch = the_tree.GetBranch("jb2csv_CSVL")
        #if not self.jb2csv_CSVL_branch and "jb2csv_CSVL" not in self.complained:
        if not self.jb2csv_CSVL_branch and "jb2csv_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb2csv_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csv_CSVL")
        else:
            self.jb2csv_CSVL_branch.SetAddress(<void*>&self.jb2csv_CSVL_value)

        #print "making jb2eta"
        self.jb2eta_branch = the_tree.GetBranch("jb2eta")
        #if not self.jb2eta_branch and "jb2eta" not in self.complained:
        if not self.jb2eta_branch and "jb2eta":
            warnings.warn( "MuTauTree: Expected branch jb2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta")
        else:
            self.jb2eta_branch.SetAddress(<void*>&self.jb2eta_value)

        #print "making jb2eta_CSVL"
        self.jb2eta_CSVL_branch = the_tree.GetBranch("jb2eta_CSVL")
        #if not self.jb2eta_CSVL_branch and "jb2eta_CSVL" not in self.complained:
        if not self.jb2eta_CSVL_branch and "jb2eta_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb2eta_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_CSVL")
        else:
            self.jb2eta_CSVL_branch.SetAddress(<void*>&self.jb2eta_CSVL_value)

        #print "making jb2hadronflavor"
        self.jb2hadronflavor_branch = the_tree.GetBranch("jb2hadronflavor")
        #if not self.jb2hadronflavor_branch and "jb2hadronflavor" not in self.complained:
        if not self.jb2hadronflavor_branch and "jb2hadronflavor":
            warnings.warn( "MuTauTree: Expected branch jb2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor")
        else:
            self.jb2hadronflavor_branch.SetAddress(<void*>&self.jb2hadronflavor_value)

        #print "making jb2hadronflavor_CSVL"
        self.jb2hadronflavor_CSVL_branch = the_tree.GetBranch("jb2hadronflavor_CSVL")
        #if not self.jb2hadronflavor_CSVL_branch and "jb2hadronflavor_CSVL" not in self.complained:
        if not self.jb2hadronflavor_CSVL_branch and "jb2hadronflavor_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb2hadronflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_CSVL")
        else:
            self.jb2hadronflavor_CSVL_branch.SetAddress(<void*>&self.jb2hadronflavor_CSVL_value)

        #print "making jb2partonflavor"
        self.jb2partonflavor_branch = the_tree.GetBranch("jb2partonflavor")
        #if not self.jb2partonflavor_branch and "jb2partonflavor" not in self.complained:
        if not self.jb2partonflavor_branch and "jb2partonflavor":
            warnings.warn( "MuTauTree: Expected branch jb2partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2partonflavor")
        else:
            self.jb2partonflavor_branch.SetAddress(<void*>&self.jb2partonflavor_value)

        #print "making jb2partonflavor_CSVL"
        self.jb2partonflavor_CSVL_branch = the_tree.GetBranch("jb2partonflavor_CSVL")
        #if not self.jb2partonflavor_CSVL_branch and "jb2partonflavor_CSVL" not in self.complained:
        if not self.jb2partonflavor_CSVL_branch and "jb2partonflavor_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb2partonflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2partonflavor_CSVL")
        else:
            self.jb2partonflavor_CSVL_branch.SetAddress(<void*>&self.jb2partonflavor_CSVL_value)

        #print "making jb2phi"
        self.jb2phi_branch = the_tree.GetBranch("jb2phi")
        #if not self.jb2phi_branch and "jb2phi" not in self.complained:
        if not self.jb2phi_branch and "jb2phi":
            warnings.warn( "MuTauTree: Expected branch jb2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi")
        else:
            self.jb2phi_branch.SetAddress(<void*>&self.jb2phi_value)

        #print "making jb2phi_CSVL"
        self.jb2phi_CSVL_branch = the_tree.GetBranch("jb2phi_CSVL")
        #if not self.jb2phi_CSVL_branch and "jb2phi_CSVL" not in self.complained:
        if not self.jb2phi_CSVL_branch and "jb2phi_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb2phi_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_CSVL")
        else:
            self.jb2phi_CSVL_branch.SetAddress(<void*>&self.jb2phi_CSVL_value)

        #print "making jb2pt"
        self.jb2pt_branch = the_tree.GetBranch("jb2pt")
        #if not self.jb2pt_branch and "jb2pt" not in self.complained:
        if not self.jb2pt_branch and "jb2pt":
            warnings.warn( "MuTauTree: Expected branch jb2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt")
        else:
            self.jb2pt_branch.SetAddress(<void*>&self.jb2pt_value)

        #print "making jb2ptDown"
        self.jb2ptDown_branch = the_tree.GetBranch("jb2ptDown")
        #if not self.jb2ptDown_branch and "jb2ptDown" not in self.complained:
        if not self.jb2ptDown_branch and "jb2ptDown":
            warnings.warn( "MuTauTree: Expected branch jb2ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptDown")
        else:
            self.jb2ptDown_branch.SetAddress(<void*>&self.jb2ptDown_value)

        #print "making jb2ptDown_CSVL"
        self.jb2ptDown_CSVL_branch = the_tree.GetBranch("jb2ptDown_CSVL")
        #if not self.jb2ptDown_CSVL_branch and "jb2ptDown_CSVL" not in self.complained:
        if not self.jb2ptDown_CSVL_branch and "jb2ptDown_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb2ptDown_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptDown_CSVL")
        else:
            self.jb2ptDown_CSVL_branch.SetAddress(<void*>&self.jb2ptDown_CSVL_value)

        #print "making jb2ptUp"
        self.jb2ptUp_branch = the_tree.GetBranch("jb2ptUp")
        #if not self.jb2ptUp_branch and "jb2ptUp" not in self.complained:
        if not self.jb2ptUp_branch and "jb2ptUp":
            warnings.warn( "MuTauTree: Expected branch jb2ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptUp")
        else:
            self.jb2ptUp_branch.SetAddress(<void*>&self.jb2ptUp_value)

        #print "making jb2ptUp_CSVL"
        self.jb2ptUp_CSVL_branch = the_tree.GetBranch("jb2ptUp_CSVL")
        #if not self.jb2ptUp_CSVL_branch and "jb2ptUp_CSVL" not in self.complained:
        if not self.jb2ptUp_CSVL_branch and "jb2ptUp_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb2ptUp_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptUp_CSVL")
        else:
            self.jb2ptUp_CSVL_branch.SetAddress(<void*>&self.jb2ptUp_CSVL_value)

        #print "making jb2pt_CSVL"
        self.jb2pt_CSVL_branch = the_tree.GetBranch("jb2pt_CSVL")
        #if not self.jb2pt_CSVL_branch and "jb2pt_CSVL" not in self.complained:
        if not self.jb2pt_CSVL_branch and "jb2pt_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb2pt_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_CSVL")
        else:
            self.jb2pt_CSVL_branch.SetAddress(<void*>&self.jb2pt_CSVL_value)

        #print "making jb2pu"
        self.jb2pu_branch = the_tree.GetBranch("jb2pu")
        #if not self.jb2pu_branch and "jb2pu" not in self.complained:
        if not self.jb2pu_branch and "jb2pu":
            warnings.warn( "MuTauTree: Expected branch jb2pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pu")
        else:
            self.jb2pu_branch.SetAddress(<void*>&self.jb2pu_value)

        #print "making jb2pu_CSVL"
        self.jb2pu_CSVL_branch = the_tree.GetBranch("jb2pu_CSVL")
        #if not self.jb2pu_CSVL_branch and "jb2pu_CSVL" not in self.complained:
        if not self.jb2pu_CSVL_branch and "jb2pu_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb2pu_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pu_CSVL")
        else:
            self.jb2pu_CSVL_branch.SetAddress(<void*>&self.jb2pu_CSVL_value)

        #print "making jb2rawf"
        self.jb2rawf_branch = the_tree.GetBranch("jb2rawf")
        #if not self.jb2rawf_branch and "jb2rawf" not in self.complained:
        if not self.jb2rawf_branch and "jb2rawf":
            warnings.warn( "MuTauTree: Expected branch jb2rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2rawf")
        else:
            self.jb2rawf_branch.SetAddress(<void*>&self.jb2rawf_value)

        #print "making jb2rawf_CSVL"
        self.jb2rawf_CSVL_branch = the_tree.GetBranch("jb2rawf_CSVL")
        #if not self.jb2rawf_CSVL_branch and "jb2rawf_CSVL" not in self.complained:
        if not self.jb2rawf_CSVL_branch and "jb2rawf_CSVL":
            warnings.warn( "MuTauTree: Expected branch jb2rawf_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2rawf_CSVL")
        else:
            self.jb2rawf_CSVL_branch.SetAddress(<void*>&self.jb2rawf_CSVL_value)

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

        #print "making jet1PtJESClosure_Down"
        self.jet1PtJESClosure_Down_branch = the_tree.GetBranch("jet1PtJESClosure_Down")
        #if not self.jet1PtJESClosure_Down_branch and "jet1PtJESClosure_Down" not in self.complained:
        if not self.jet1PtJESClosure_Down_branch and "jet1PtJESClosure_Down":
            warnings.warn( "MuTauTree: Expected branch jet1PtJESClosure_Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet1PtJESClosure_Down")
        else:
            self.jet1PtJESClosure_Down_branch.SetAddress(<void*>&self.jet1PtJESClosure_Down_value)

        #print "making jet1PtJESClosure_Up"
        self.jet1PtJESClosure_Up_branch = the_tree.GetBranch("jet1PtJESClosure_Up")
        #if not self.jet1PtJESClosure_Up_branch and "jet1PtJESClosure_Up" not in self.complained:
        if not self.jet1PtJESClosure_Up_branch and "jet1PtJESClosure_Up":
            warnings.warn( "MuTauTree: Expected branch jet1PtJESClosure_Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet1PtJESClosure_Up")
        else:
            self.jet1PtJESClosure_Up_branch.SetAddress(<void*>&self.jet1PtJESClosure_Up_value)

        #print "making jet1PtJESTotal_Down"
        self.jet1PtJESTotal_Down_branch = the_tree.GetBranch("jet1PtJESTotal_Down")
        #if not self.jet1PtJESTotal_Down_branch and "jet1PtJESTotal_Down" not in self.complained:
        if not self.jet1PtJESTotal_Down_branch and "jet1PtJESTotal_Down":
            warnings.warn( "MuTauTree: Expected branch jet1PtJESTotal_Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet1PtJESTotal_Down")
        else:
            self.jet1PtJESTotal_Down_branch.SetAddress(<void*>&self.jet1PtJESTotal_Down_value)

        #print "making jet1PtJESTotal_Up"
        self.jet1PtJESTotal_Up_branch = the_tree.GetBranch("jet1PtJESTotal_Up")
        #if not self.jet1PtJESTotal_Up_branch and "jet1PtJESTotal_Up" not in self.complained:
        if not self.jet1PtJESTotal_Up_branch and "jet1PtJESTotal_Up":
            warnings.warn( "MuTauTree: Expected branch jet1PtJESTotal_Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet1PtJESTotal_Up")
        else:
            self.jet1PtJESTotal_Up_branch.SetAddress(<void*>&self.jet1PtJESTotal_Up_value)

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

        #print "making jet2PtJESClosure_Down"
        self.jet2PtJESClosure_Down_branch = the_tree.GetBranch("jet2PtJESClosure_Down")
        #if not self.jet2PtJESClosure_Down_branch and "jet2PtJESClosure_Down" not in self.complained:
        if not self.jet2PtJESClosure_Down_branch and "jet2PtJESClosure_Down":
            warnings.warn( "MuTauTree: Expected branch jet2PtJESClosure_Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet2PtJESClosure_Down")
        else:
            self.jet2PtJESClosure_Down_branch.SetAddress(<void*>&self.jet2PtJESClosure_Down_value)

        #print "making jet2PtJESClosure_Up"
        self.jet2PtJESClosure_Up_branch = the_tree.GetBranch("jet2PtJESClosure_Up")
        #if not self.jet2PtJESClosure_Up_branch and "jet2PtJESClosure_Up" not in self.complained:
        if not self.jet2PtJESClosure_Up_branch and "jet2PtJESClosure_Up":
            warnings.warn( "MuTauTree: Expected branch jet2PtJESClosure_Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet2PtJESClosure_Up")
        else:
            self.jet2PtJESClosure_Up_branch.SetAddress(<void*>&self.jet2PtJESClosure_Up_value)

        #print "making jet2PtJESTotal_Down"
        self.jet2PtJESTotal_Down_branch = the_tree.GetBranch("jet2PtJESTotal_Down")
        #if not self.jet2PtJESTotal_Down_branch and "jet2PtJESTotal_Down" not in self.complained:
        if not self.jet2PtJESTotal_Down_branch and "jet2PtJESTotal_Down":
            warnings.warn( "MuTauTree: Expected branch jet2PtJESTotal_Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet2PtJESTotal_Down")
        else:
            self.jet2PtJESTotal_Down_branch.SetAddress(<void*>&self.jet2PtJESTotal_Down_value)

        #print "making jet2PtJESTotal_Up"
        self.jet2PtJESTotal_Up_branch = the_tree.GetBranch("jet2PtJESTotal_Up")
        #if not self.jet2PtJESTotal_Up_branch and "jet2PtJESTotal_Up" not in self.complained:
        if not self.jet2PtJESTotal_Up_branch and "jet2PtJESTotal_Up":
            warnings.warn( "MuTauTree: Expected branch jet2PtJESTotal_Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jet2PtJESTotal_Up")
        else:
            self.jet2PtJESTotal_Up_branch.SetAddress(<void*>&self.jet2PtJESTotal_Up_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "MuTauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "MuTauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_JetAbsoluteFlavMapDown"
        self.jetVeto30_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteFlavMapDown")
        #if not self.jetVeto30_JetAbsoluteFlavMapDown_branch and "jetVeto30_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteFlavMapDown_branch and "jetVeto30_JetAbsoluteFlavMapDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteFlavMapDown")
        else:
            self.jetVeto30_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteFlavMapDown_value)

        #print "making jetVeto30_JetAbsoluteFlavMapUp"
        self.jetVeto30_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteFlavMapUp")
        #if not self.jetVeto30_JetAbsoluteFlavMapUp_branch and "jetVeto30_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteFlavMapUp_branch and "jetVeto30_JetAbsoluteFlavMapUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteFlavMapUp")
        else:
            self.jetVeto30_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteFlavMapUp_value)

        #print "making jetVeto30_JetAbsoluteMPFBiasDown"
        self.jetVeto30_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteMPFBiasDown")
        #if not self.jetVeto30_JetAbsoluteMPFBiasDown_branch and "jetVeto30_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteMPFBiasDown_branch and "jetVeto30_JetAbsoluteMPFBiasDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteMPFBiasDown")
        else:
            self.jetVeto30_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteMPFBiasDown_value)

        #print "making jetVeto30_JetAbsoluteMPFBiasUp"
        self.jetVeto30_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteMPFBiasUp")
        #if not self.jetVeto30_JetAbsoluteMPFBiasUp_branch and "jetVeto30_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteMPFBiasUp_branch and "jetVeto30_JetAbsoluteMPFBiasUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteMPFBiasUp")
        else:
            self.jetVeto30_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteMPFBiasUp_value)

        #print "making jetVeto30_JetAbsoluteScaleDown"
        self.jetVeto30_JetAbsoluteScaleDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteScaleDown")
        #if not self.jetVeto30_JetAbsoluteScaleDown_branch and "jetVeto30_JetAbsoluteScaleDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteScaleDown_branch and "jetVeto30_JetAbsoluteScaleDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteScaleDown")
        else:
            self.jetVeto30_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteScaleDown_value)

        #print "making jetVeto30_JetAbsoluteScaleUp"
        self.jetVeto30_JetAbsoluteScaleUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteScaleUp")
        #if not self.jetVeto30_JetAbsoluteScaleUp_branch and "jetVeto30_JetAbsoluteScaleUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteScaleUp_branch and "jetVeto30_JetAbsoluteScaleUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteScaleUp")
        else:
            self.jetVeto30_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteScaleUp_value)

        #print "making jetVeto30_JetAbsoluteStatDown"
        self.jetVeto30_JetAbsoluteStatDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteStatDown")
        #if not self.jetVeto30_JetAbsoluteStatDown_branch and "jetVeto30_JetAbsoluteStatDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteStatDown_branch and "jetVeto30_JetAbsoluteStatDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteStatDown")
        else:
            self.jetVeto30_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteStatDown_value)

        #print "making jetVeto30_JetAbsoluteStatUp"
        self.jetVeto30_JetAbsoluteStatUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteStatUp")
        #if not self.jetVeto30_JetAbsoluteStatUp_branch and "jetVeto30_JetAbsoluteStatUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteStatUp_branch and "jetVeto30_JetAbsoluteStatUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteStatUp")
        else:
            self.jetVeto30_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteStatUp_value)

        #print "making jetVeto30_JetClosureDown"
        self.jetVeto30_JetClosureDown_branch = the_tree.GetBranch("jetVeto30_JetClosureDown")
        #if not self.jetVeto30_JetClosureDown_branch and "jetVeto30_JetClosureDown" not in self.complained:
        if not self.jetVeto30_JetClosureDown_branch and "jetVeto30_JetClosureDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetClosureDown")
        else:
            self.jetVeto30_JetClosureDown_branch.SetAddress(<void*>&self.jetVeto30_JetClosureDown_value)

        #print "making jetVeto30_JetClosureUp"
        self.jetVeto30_JetClosureUp_branch = the_tree.GetBranch("jetVeto30_JetClosureUp")
        #if not self.jetVeto30_JetClosureUp_branch and "jetVeto30_JetClosureUp" not in self.complained:
        if not self.jetVeto30_JetClosureUp_branch and "jetVeto30_JetClosureUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetClosureUp")
        else:
            self.jetVeto30_JetClosureUp_branch.SetAddress(<void*>&self.jetVeto30_JetClosureUp_value)

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

        #print "making jetVeto30_JetFlavorQCDDown"
        self.jetVeto30_JetFlavorQCDDown_branch = the_tree.GetBranch("jetVeto30_JetFlavorQCDDown")
        #if not self.jetVeto30_JetFlavorQCDDown_branch and "jetVeto30_JetFlavorQCDDown" not in self.complained:
        if not self.jetVeto30_JetFlavorQCDDown_branch and "jetVeto30_JetFlavorQCDDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFlavorQCDDown")
        else:
            self.jetVeto30_JetFlavorQCDDown_branch.SetAddress(<void*>&self.jetVeto30_JetFlavorQCDDown_value)

        #print "making jetVeto30_JetFlavorQCDUp"
        self.jetVeto30_JetFlavorQCDUp_branch = the_tree.GetBranch("jetVeto30_JetFlavorQCDUp")
        #if not self.jetVeto30_JetFlavorQCDUp_branch and "jetVeto30_JetFlavorQCDUp" not in self.complained:
        if not self.jetVeto30_JetFlavorQCDUp_branch and "jetVeto30_JetFlavorQCDUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFlavorQCDUp")
        else:
            self.jetVeto30_JetFlavorQCDUp_branch.SetAddress(<void*>&self.jetVeto30_JetFlavorQCDUp_value)

        #print "making jetVeto30_JetFragmentationDown"
        self.jetVeto30_JetFragmentationDown_branch = the_tree.GetBranch("jetVeto30_JetFragmentationDown")
        #if not self.jetVeto30_JetFragmentationDown_branch and "jetVeto30_JetFragmentationDown" not in self.complained:
        if not self.jetVeto30_JetFragmentationDown_branch and "jetVeto30_JetFragmentationDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFragmentationDown")
        else:
            self.jetVeto30_JetFragmentationDown_branch.SetAddress(<void*>&self.jetVeto30_JetFragmentationDown_value)

        #print "making jetVeto30_JetFragmentationUp"
        self.jetVeto30_JetFragmentationUp_branch = the_tree.GetBranch("jetVeto30_JetFragmentationUp")
        #if not self.jetVeto30_JetFragmentationUp_branch and "jetVeto30_JetFragmentationUp" not in self.complained:
        if not self.jetVeto30_JetFragmentationUp_branch and "jetVeto30_JetFragmentationUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFragmentationUp")
        else:
            self.jetVeto30_JetFragmentationUp_branch.SetAddress(<void*>&self.jetVeto30_JetFragmentationUp_value)

        #print "making jetVeto30_JetPileUpDataMCDown"
        self.jetVeto30_JetPileUpDataMCDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpDataMCDown")
        #if not self.jetVeto30_JetPileUpDataMCDown_branch and "jetVeto30_JetPileUpDataMCDown" not in self.complained:
        if not self.jetVeto30_JetPileUpDataMCDown_branch and "jetVeto30_JetPileUpDataMCDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpDataMCDown")
        else:
            self.jetVeto30_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpDataMCDown_value)

        #print "making jetVeto30_JetPileUpDataMCUp"
        self.jetVeto30_JetPileUpDataMCUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpDataMCUp")
        #if not self.jetVeto30_JetPileUpDataMCUp_branch and "jetVeto30_JetPileUpDataMCUp" not in self.complained:
        if not self.jetVeto30_JetPileUpDataMCUp_branch and "jetVeto30_JetPileUpDataMCUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpDataMCUp")
        else:
            self.jetVeto30_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpDataMCUp_value)

        #print "making jetVeto30_JetPileUpPtBBDown"
        self.jetVeto30_JetPileUpPtBBDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtBBDown")
        #if not self.jetVeto30_JetPileUpPtBBDown_branch and "jetVeto30_JetPileUpPtBBDown" not in self.complained:
        if not self.jetVeto30_JetPileUpPtBBDown_branch and "jetVeto30_JetPileUpPtBBDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtBBDown")
        else:
            self.jetVeto30_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtBBDown_value)

        #print "making jetVeto30_JetPileUpPtBBUp"
        self.jetVeto30_JetPileUpPtBBUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtBBUp")
        #if not self.jetVeto30_JetPileUpPtBBUp_branch and "jetVeto30_JetPileUpPtBBUp" not in self.complained:
        if not self.jetVeto30_JetPileUpPtBBUp_branch and "jetVeto30_JetPileUpPtBBUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtBBUp")
        else:
            self.jetVeto30_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtBBUp_value)

        #print "making jetVeto30_JetPileUpPtEC1Down"
        self.jetVeto30_JetPileUpPtEC1Down_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC1Down")
        #if not self.jetVeto30_JetPileUpPtEC1Down_branch and "jetVeto30_JetPileUpPtEC1Down" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC1Down_branch and "jetVeto30_JetPileUpPtEC1Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC1Down")
        else:
            self.jetVeto30_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC1Down_value)

        #print "making jetVeto30_JetPileUpPtEC1Up"
        self.jetVeto30_JetPileUpPtEC1Up_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC1Up")
        #if not self.jetVeto30_JetPileUpPtEC1Up_branch and "jetVeto30_JetPileUpPtEC1Up" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC1Up_branch and "jetVeto30_JetPileUpPtEC1Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC1Up")
        else:
            self.jetVeto30_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC1Up_value)

        #print "making jetVeto30_JetPileUpPtEC2Down"
        self.jetVeto30_JetPileUpPtEC2Down_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC2Down")
        #if not self.jetVeto30_JetPileUpPtEC2Down_branch and "jetVeto30_JetPileUpPtEC2Down" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC2Down_branch and "jetVeto30_JetPileUpPtEC2Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC2Down")
        else:
            self.jetVeto30_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC2Down_value)

        #print "making jetVeto30_JetPileUpPtEC2Up"
        self.jetVeto30_JetPileUpPtEC2Up_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC2Up")
        #if not self.jetVeto30_JetPileUpPtEC2Up_branch and "jetVeto30_JetPileUpPtEC2Up" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC2Up_branch and "jetVeto30_JetPileUpPtEC2Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC2Up")
        else:
            self.jetVeto30_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC2Up_value)

        #print "making jetVeto30_JetPileUpPtHFDown"
        self.jetVeto30_JetPileUpPtHFDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtHFDown")
        #if not self.jetVeto30_JetPileUpPtHFDown_branch and "jetVeto30_JetPileUpPtHFDown" not in self.complained:
        if not self.jetVeto30_JetPileUpPtHFDown_branch and "jetVeto30_JetPileUpPtHFDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtHFDown")
        else:
            self.jetVeto30_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtHFDown_value)

        #print "making jetVeto30_JetPileUpPtHFUp"
        self.jetVeto30_JetPileUpPtHFUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtHFUp")
        #if not self.jetVeto30_JetPileUpPtHFUp_branch and "jetVeto30_JetPileUpPtHFUp" not in self.complained:
        if not self.jetVeto30_JetPileUpPtHFUp_branch and "jetVeto30_JetPileUpPtHFUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtHFUp")
        else:
            self.jetVeto30_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtHFUp_value)

        #print "making jetVeto30_JetPileUpPtRefDown"
        self.jetVeto30_JetPileUpPtRefDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtRefDown")
        #if not self.jetVeto30_JetPileUpPtRefDown_branch and "jetVeto30_JetPileUpPtRefDown" not in self.complained:
        if not self.jetVeto30_JetPileUpPtRefDown_branch and "jetVeto30_JetPileUpPtRefDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtRefDown")
        else:
            self.jetVeto30_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtRefDown_value)

        #print "making jetVeto30_JetPileUpPtRefUp"
        self.jetVeto30_JetPileUpPtRefUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtRefUp")
        #if not self.jetVeto30_JetPileUpPtRefUp_branch and "jetVeto30_JetPileUpPtRefUp" not in self.complained:
        if not self.jetVeto30_JetPileUpPtRefUp_branch and "jetVeto30_JetPileUpPtRefUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtRefUp")
        else:
            self.jetVeto30_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtRefUp_value)

        #print "making jetVeto30_JetRelativeBalDown"
        self.jetVeto30_JetRelativeBalDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeBalDown")
        #if not self.jetVeto30_JetRelativeBalDown_branch and "jetVeto30_JetRelativeBalDown" not in self.complained:
        if not self.jetVeto30_JetRelativeBalDown_branch and "jetVeto30_JetRelativeBalDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeBalDown")
        else:
            self.jetVeto30_JetRelativeBalDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeBalDown_value)

        #print "making jetVeto30_JetRelativeBalUp"
        self.jetVeto30_JetRelativeBalUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeBalUp")
        #if not self.jetVeto30_JetRelativeBalUp_branch and "jetVeto30_JetRelativeBalUp" not in self.complained:
        if not self.jetVeto30_JetRelativeBalUp_branch and "jetVeto30_JetRelativeBalUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeBalUp")
        else:
            self.jetVeto30_JetRelativeBalUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeBalUp_value)

        #print "making jetVeto30_JetRelativeFSRDown"
        self.jetVeto30_JetRelativeFSRDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeFSRDown")
        #if not self.jetVeto30_JetRelativeFSRDown_branch and "jetVeto30_JetRelativeFSRDown" not in self.complained:
        if not self.jetVeto30_JetRelativeFSRDown_branch and "jetVeto30_JetRelativeFSRDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeFSRDown")
        else:
            self.jetVeto30_JetRelativeFSRDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeFSRDown_value)

        #print "making jetVeto30_JetRelativeFSRUp"
        self.jetVeto30_JetRelativeFSRUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeFSRUp")
        #if not self.jetVeto30_JetRelativeFSRUp_branch and "jetVeto30_JetRelativeFSRUp" not in self.complained:
        if not self.jetVeto30_JetRelativeFSRUp_branch and "jetVeto30_JetRelativeFSRUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeFSRUp")
        else:
            self.jetVeto30_JetRelativeFSRUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeFSRUp_value)

        #print "making jetVeto30_JetRelativeJEREC1Down"
        self.jetVeto30_JetRelativeJEREC1Down_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC1Down")
        #if not self.jetVeto30_JetRelativeJEREC1Down_branch and "jetVeto30_JetRelativeJEREC1Down" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC1Down_branch and "jetVeto30_JetRelativeJEREC1Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC1Down")
        else:
            self.jetVeto30_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC1Down_value)

        #print "making jetVeto30_JetRelativeJEREC1Up"
        self.jetVeto30_JetRelativeJEREC1Up_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC1Up")
        #if not self.jetVeto30_JetRelativeJEREC1Up_branch and "jetVeto30_JetRelativeJEREC1Up" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC1Up_branch and "jetVeto30_JetRelativeJEREC1Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC1Up")
        else:
            self.jetVeto30_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC1Up_value)

        #print "making jetVeto30_JetRelativeJEREC2Down"
        self.jetVeto30_JetRelativeJEREC2Down_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC2Down")
        #if not self.jetVeto30_JetRelativeJEREC2Down_branch and "jetVeto30_JetRelativeJEREC2Down" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC2Down_branch and "jetVeto30_JetRelativeJEREC2Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC2Down")
        else:
            self.jetVeto30_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC2Down_value)

        #print "making jetVeto30_JetRelativeJEREC2Up"
        self.jetVeto30_JetRelativeJEREC2Up_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC2Up")
        #if not self.jetVeto30_JetRelativeJEREC2Up_branch and "jetVeto30_JetRelativeJEREC2Up" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC2Up_branch and "jetVeto30_JetRelativeJEREC2Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC2Up")
        else:
            self.jetVeto30_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC2Up_value)

        #print "making jetVeto30_JetRelativeJERHFDown"
        self.jetVeto30_JetRelativeJERHFDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeJERHFDown")
        #if not self.jetVeto30_JetRelativeJERHFDown_branch and "jetVeto30_JetRelativeJERHFDown" not in self.complained:
        if not self.jetVeto30_JetRelativeJERHFDown_branch and "jetVeto30_JetRelativeJERHFDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJERHFDown")
        else:
            self.jetVeto30_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJERHFDown_value)

        #print "making jetVeto30_JetRelativeJERHFUp"
        self.jetVeto30_JetRelativeJERHFUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeJERHFUp")
        #if not self.jetVeto30_JetRelativeJERHFUp_branch and "jetVeto30_JetRelativeJERHFUp" not in self.complained:
        if not self.jetVeto30_JetRelativeJERHFUp_branch and "jetVeto30_JetRelativeJERHFUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJERHFUp")
        else:
            self.jetVeto30_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJERHFUp_value)

        #print "making jetVeto30_JetRelativePtBBDown"
        self.jetVeto30_JetRelativePtBBDown_branch = the_tree.GetBranch("jetVeto30_JetRelativePtBBDown")
        #if not self.jetVeto30_JetRelativePtBBDown_branch and "jetVeto30_JetRelativePtBBDown" not in self.complained:
        if not self.jetVeto30_JetRelativePtBBDown_branch and "jetVeto30_JetRelativePtBBDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtBBDown")
        else:
            self.jetVeto30_JetRelativePtBBDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtBBDown_value)

        #print "making jetVeto30_JetRelativePtBBUp"
        self.jetVeto30_JetRelativePtBBUp_branch = the_tree.GetBranch("jetVeto30_JetRelativePtBBUp")
        #if not self.jetVeto30_JetRelativePtBBUp_branch and "jetVeto30_JetRelativePtBBUp" not in self.complained:
        if not self.jetVeto30_JetRelativePtBBUp_branch and "jetVeto30_JetRelativePtBBUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtBBUp")
        else:
            self.jetVeto30_JetRelativePtBBUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtBBUp_value)

        #print "making jetVeto30_JetRelativePtEC1Down"
        self.jetVeto30_JetRelativePtEC1Down_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC1Down")
        #if not self.jetVeto30_JetRelativePtEC1Down_branch and "jetVeto30_JetRelativePtEC1Down" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC1Down_branch and "jetVeto30_JetRelativePtEC1Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC1Down")
        else:
            self.jetVeto30_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC1Down_value)

        #print "making jetVeto30_JetRelativePtEC1Up"
        self.jetVeto30_JetRelativePtEC1Up_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC1Up")
        #if not self.jetVeto30_JetRelativePtEC1Up_branch and "jetVeto30_JetRelativePtEC1Up" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC1Up_branch and "jetVeto30_JetRelativePtEC1Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC1Up")
        else:
            self.jetVeto30_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC1Up_value)

        #print "making jetVeto30_JetRelativePtEC2Down"
        self.jetVeto30_JetRelativePtEC2Down_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC2Down")
        #if not self.jetVeto30_JetRelativePtEC2Down_branch and "jetVeto30_JetRelativePtEC2Down" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC2Down_branch and "jetVeto30_JetRelativePtEC2Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC2Down")
        else:
            self.jetVeto30_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC2Down_value)

        #print "making jetVeto30_JetRelativePtEC2Up"
        self.jetVeto30_JetRelativePtEC2Up_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC2Up")
        #if not self.jetVeto30_JetRelativePtEC2Up_branch and "jetVeto30_JetRelativePtEC2Up" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC2Up_branch and "jetVeto30_JetRelativePtEC2Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC2Up")
        else:
            self.jetVeto30_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC2Up_value)

        #print "making jetVeto30_JetRelativePtHFDown"
        self.jetVeto30_JetRelativePtHFDown_branch = the_tree.GetBranch("jetVeto30_JetRelativePtHFDown")
        #if not self.jetVeto30_JetRelativePtHFDown_branch and "jetVeto30_JetRelativePtHFDown" not in self.complained:
        if not self.jetVeto30_JetRelativePtHFDown_branch and "jetVeto30_JetRelativePtHFDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtHFDown")
        else:
            self.jetVeto30_JetRelativePtHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtHFDown_value)

        #print "making jetVeto30_JetRelativePtHFUp"
        self.jetVeto30_JetRelativePtHFUp_branch = the_tree.GetBranch("jetVeto30_JetRelativePtHFUp")
        #if not self.jetVeto30_JetRelativePtHFUp_branch and "jetVeto30_JetRelativePtHFUp" not in self.complained:
        if not self.jetVeto30_JetRelativePtHFUp_branch and "jetVeto30_JetRelativePtHFUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtHFUp")
        else:
            self.jetVeto30_JetRelativePtHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtHFUp_value)

        #print "making jetVeto30_JetRelativeStatECDown"
        self.jetVeto30_JetRelativeStatECDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatECDown")
        #if not self.jetVeto30_JetRelativeStatECDown_branch and "jetVeto30_JetRelativeStatECDown" not in self.complained:
        if not self.jetVeto30_JetRelativeStatECDown_branch and "jetVeto30_JetRelativeStatECDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatECDown")
        else:
            self.jetVeto30_JetRelativeStatECDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatECDown_value)

        #print "making jetVeto30_JetRelativeStatECUp"
        self.jetVeto30_JetRelativeStatECUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatECUp")
        #if not self.jetVeto30_JetRelativeStatECUp_branch and "jetVeto30_JetRelativeStatECUp" not in self.complained:
        if not self.jetVeto30_JetRelativeStatECUp_branch and "jetVeto30_JetRelativeStatECUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatECUp")
        else:
            self.jetVeto30_JetRelativeStatECUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatECUp_value)

        #print "making jetVeto30_JetRelativeStatFSRDown"
        self.jetVeto30_JetRelativeStatFSRDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatFSRDown")
        #if not self.jetVeto30_JetRelativeStatFSRDown_branch and "jetVeto30_JetRelativeStatFSRDown" not in self.complained:
        if not self.jetVeto30_JetRelativeStatFSRDown_branch and "jetVeto30_JetRelativeStatFSRDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatFSRDown")
        else:
            self.jetVeto30_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatFSRDown_value)

        #print "making jetVeto30_JetRelativeStatFSRUp"
        self.jetVeto30_JetRelativeStatFSRUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatFSRUp")
        #if not self.jetVeto30_JetRelativeStatFSRUp_branch and "jetVeto30_JetRelativeStatFSRUp" not in self.complained:
        if not self.jetVeto30_JetRelativeStatFSRUp_branch and "jetVeto30_JetRelativeStatFSRUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatFSRUp")
        else:
            self.jetVeto30_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatFSRUp_value)

        #print "making jetVeto30_JetRelativeStatHFDown"
        self.jetVeto30_JetRelativeStatHFDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatHFDown")
        #if not self.jetVeto30_JetRelativeStatHFDown_branch and "jetVeto30_JetRelativeStatHFDown" not in self.complained:
        if not self.jetVeto30_JetRelativeStatHFDown_branch and "jetVeto30_JetRelativeStatHFDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatHFDown")
        else:
            self.jetVeto30_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatHFDown_value)

        #print "making jetVeto30_JetRelativeStatHFUp"
        self.jetVeto30_JetRelativeStatHFUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatHFUp")
        #if not self.jetVeto30_JetRelativeStatHFUp_branch and "jetVeto30_JetRelativeStatHFUp" not in self.complained:
        if not self.jetVeto30_JetRelativeStatHFUp_branch and "jetVeto30_JetRelativeStatHFUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatHFUp")
        else:
            self.jetVeto30_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatHFUp_value)

        #print "making jetVeto30_JetSinglePionECALDown"
        self.jetVeto30_JetSinglePionECALDown_branch = the_tree.GetBranch("jetVeto30_JetSinglePionECALDown")
        #if not self.jetVeto30_JetSinglePionECALDown_branch and "jetVeto30_JetSinglePionECALDown" not in self.complained:
        if not self.jetVeto30_JetSinglePionECALDown_branch and "jetVeto30_JetSinglePionECALDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionECALDown")
        else:
            self.jetVeto30_JetSinglePionECALDown_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionECALDown_value)

        #print "making jetVeto30_JetSinglePionECALUp"
        self.jetVeto30_JetSinglePionECALUp_branch = the_tree.GetBranch("jetVeto30_JetSinglePionECALUp")
        #if not self.jetVeto30_JetSinglePionECALUp_branch and "jetVeto30_JetSinglePionECALUp" not in self.complained:
        if not self.jetVeto30_JetSinglePionECALUp_branch and "jetVeto30_JetSinglePionECALUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionECALUp")
        else:
            self.jetVeto30_JetSinglePionECALUp_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionECALUp_value)

        #print "making jetVeto30_JetSinglePionHCALDown"
        self.jetVeto30_JetSinglePionHCALDown_branch = the_tree.GetBranch("jetVeto30_JetSinglePionHCALDown")
        #if not self.jetVeto30_JetSinglePionHCALDown_branch and "jetVeto30_JetSinglePionHCALDown" not in self.complained:
        if not self.jetVeto30_JetSinglePionHCALDown_branch and "jetVeto30_JetSinglePionHCALDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionHCALDown")
        else:
            self.jetVeto30_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionHCALDown_value)

        #print "making jetVeto30_JetSinglePionHCALUp"
        self.jetVeto30_JetSinglePionHCALUp_branch = the_tree.GetBranch("jetVeto30_JetSinglePionHCALUp")
        #if not self.jetVeto30_JetSinglePionHCALUp_branch and "jetVeto30_JetSinglePionHCALUp" not in self.complained:
        if not self.jetVeto30_JetSinglePionHCALUp_branch and "jetVeto30_JetSinglePionHCALUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionHCALUp")
        else:
            self.jetVeto30_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionHCALUp_value)

        #print "making jetVeto30_JetSubTotalAbsoluteDown"
        self.jetVeto30_JetSubTotalAbsoluteDown_branch = the_tree.GetBranch("jetVeto30_JetSubTotalAbsoluteDown")
        #if not self.jetVeto30_JetSubTotalAbsoluteDown_branch and "jetVeto30_JetSubTotalAbsoluteDown" not in self.complained:
        if not self.jetVeto30_JetSubTotalAbsoluteDown_branch and "jetVeto30_JetSubTotalAbsoluteDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSubTotalAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalAbsoluteDown")
        else:
            self.jetVeto30_JetSubTotalAbsoluteDown_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalAbsoluteDown_value)

        #print "making jetVeto30_JetSubTotalAbsoluteUp"
        self.jetVeto30_JetSubTotalAbsoluteUp_branch = the_tree.GetBranch("jetVeto30_JetSubTotalAbsoluteUp")
        #if not self.jetVeto30_JetSubTotalAbsoluteUp_branch and "jetVeto30_JetSubTotalAbsoluteUp" not in self.complained:
        if not self.jetVeto30_JetSubTotalAbsoluteUp_branch and "jetVeto30_JetSubTotalAbsoluteUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSubTotalAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalAbsoluteUp")
        else:
            self.jetVeto30_JetSubTotalAbsoluteUp_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalAbsoluteUp_value)

        #print "making jetVeto30_JetSubTotalMCDown"
        self.jetVeto30_JetSubTotalMCDown_branch = the_tree.GetBranch("jetVeto30_JetSubTotalMCDown")
        #if not self.jetVeto30_JetSubTotalMCDown_branch and "jetVeto30_JetSubTotalMCDown" not in self.complained:
        if not self.jetVeto30_JetSubTotalMCDown_branch and "jetVeto30_JetSubTotalMCDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSubTotalMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalMCDown")
        else:
            self.jetVeto30_JetSubTotalMCDown_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalMCDown_value)

        #print "making jetVeto30_JetSubTotalMCUp"
        self.jetVeto30_JetSubTotalMCUp_branch = the_tree.GetBranch("jetVeto30_JetSubTotalMCUp")
        #if not self.jetVeto30_JetSubTotalMCUp_branch and "jetVeto30_JetSubTotalMCUp" not in self.complained:
        if not self.jetVeto30_JetSubTotalMCUp_branch and "jetVeto30_JetSubTotalMCUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSubTotalMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalMCUp")
        else:
            self.jetVeto30_JetSubTotalMCUp_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalMCUp_value)

        #print "making jetVeto30_JetSubTotalPileUpDown"
        self.jetVeto30_JetSubTotalPileUpDown_branch = the_tree.GetBranch("jetVeto30_JetSubTotalPileUpDown")
        #if not self.jetVeto30_JetSubTotalPileUpDown_branch and "jetVeto30_JetSubTotalPileUpDown" not in self.complained:
        if not self.jetVeto30_JetSubTotalPileUpDown_branch and "jetVeto30_JetSubTotalPileUpDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSubTotalPileUpDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalPileUpDown")
        else:
            self.jetVeto30_JetSubTotalPileUpDown_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalPileUpDown_value)

        #print "making jetVeto30_JetSubTotalPileUpUp"
        self.jetVeto30_JetSubTotalPileUpUp_branch = the_tree.GetBranch("jetVeto30_JetSubTotalPileUpUp")
        #if not self.jetVeto30_JetSubTotalPileUpUp_branch and "jetVeto30_JetSubTotalPileUpUp" not in self.complained:
        if not self.jetVeto30_JetSubTotalPileUpUp_branch and "jetVeto30_JetSubTotalPileUpUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSubTotalPileUpUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalPileUpUp")
        else:
            self.jetVeto30_JetSubTotalPileUpUp_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalPileUpUp_value)

        #print "making jetVeto30_JetSubTotalPtDown"
        self.jetVeto30_JetSubTotalPtDown_branch = the_tree.GetBranch("jetVeto30_JetSubTotalPtDown")
        #if not self.jetVeto30_JetSubTotalPtDown_branch and "jetVeto30_JetSubTotalPtDown" not in self.complained:
        if not self.jetVeto30_JetSubTotalPtDown_branch and "jetVeto30_JetSubTotalPtDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSubTotalPtDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalPtDown")
        else:
            self.jetVeto30_JetSubTotalPtDown_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalPtDown_value)

        #print "making jetVeto30_JetSubTotalPtUp"
        self.jetVeto30_JetSubTotalPtUp_branch = the_tree.GetBranch("jetVeto30_JetSubTotalPtUp")
        #if not self.jetVeto30_JetSubTotalPtUp_branch and "jetVeto30_JetSubTotalPtUp" not in self.complained:
        if not self.jetVeto30_JetSubTotalPtUp_branch and "jetVeto30_JetSubTotalPtUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSubTotalPtUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalPtUp")
        else:
            self.jetVeto30_JetSubTotalPtUp_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalPtUp_value)

        #print "making jetVeto30_JetSubTotalRelativeDown"
        self.jetVeto30_JetSubTotalRelativeDown_branch = the_tree.GetBranch("jetVeto30_JetSubTotalRelativeDown")
        #if not self.jetVeto30_JetSubTotalRelativeDown_branch and "jetVeto30_JetSubTotalRelativeDown" not in self.complained:
        if not self.jetVeto30_JetSubTotalRelativeDown_branch and "jetVeto30_JetSubTotalRelativeDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSubTotalRelativeDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalRelativeDown")
        else:
            self.jetVeto30_JetSubTotalRelativeDown_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalRelativeDown_value)

        #print "making jetVeto30_JetSubTotalRelativeUp"
        self.jetVeto30_JetSubTotalRelativeUp_branch = the_tree.GetBranch("jetVeto30_JetSubTotalRelativeUp")
        #if not self.jetVeto30_JetSubTotalRelativeUp_branch and "jetVeto30_JetSubTotalRelativeUp" not in self.complained:
        if not self.jetVeto30_JetSubTotalRelativeUp_branch and "jetVeto30_JetSubTotalRelativeUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSubTotalRelativeUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalRelativeUp")
        else:
            self.jetVeto30_JetSubTotalRelativeUp_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalRelativeUp_value)

        #print "making jetVeto30_JetSubTotalScaleDown"
        self.jetVeto30_JetSubTotalScaleDown_branch = the_tree.GetBranch("jetVeto30_JetSubTotalScaleDown")
        #if not self.jetVeto30_JetSubTotalScaleDown_branch and "jetVeto30_JetSubTotalScaleDown" not in self.complained:
        if not self.jetVeto30_JetSubTotalScaleDown_branch and "jetVeto30_JetSubTotalScaleDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSubTotalScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalScaleDown")
        else:
            self.jetVeto30_JetSubTotalScaleDown_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalScaleDown_value)

        #print "making jetVeto30_JetSubTotalScaleUp"
        self.jetVeto30_JetSubTotalScaleUp_branch = the_tree.GetBranch("jetVeto30_JetSubTotalScaleUp")
        #if not self.jetVeto30_JetSubTotalScaleUp_branch and "jetVeto30_JetSubTotalScaleUp" not in self.complained:
        if not self.jetVeto30_JetSubTotalScaleUp_branch and "jetVeto30_JetSubTotalScaleUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetSubTotalScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalScaleUp")
        else:
            self.jetVeto30_JetSubTotalScaleUp_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalScaleUp_value)

        #print "making jetVeto30_JetTimePtEtaDown"
        self.jetVeto30_JetTimePtEtaDown_branch = the_tree.GetBranch("jetVeto30_JetTimePtEtaDown")
        #if not self.jetVeto30_JetTimePtEtaDown_branch and "jetVeto30_JetTimePtEtaDown" not in self.complained:
        if not self.jetVeto30_JetTimePtEtaDown_branch and "jetVeto30_JetTimePtEtaDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTimePtEtaDown")
        else:
            self.jetVeto30_JetTimePtEtaDown_branch.SetAddress(<void*>&self.jetVeto30_JetTimePtEtaDown_value)

        #print "making jetVeto30_JetTimePtEtaUp"
        self.jetVeto30_JetTimePtEtaUp_branch = the_tree.GetBranch("jetVeto30_JetTimePtEtaUp")
        #if not self.jetVeto30_JetTimePtEtaUp_branch and "jetVeto30_JetTimePtEtaUp" not in self.complained:
        if not self.jetVeto30_JetTimePtEtaUp_branch and "jetVeto30_JetTimePtEtaUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTimePtEtaUp")
        else:
            self.jetVeto30_JetTimePtEtaUp_branch.SetAddress(<void*>&self.jetVeto30_JetTimePtEtaUp_value)

        #print "making jetVeto30_JetTotalDown"
        self.jetVeto30_JetTotalDown_branch = the_tree.GetBranch("jetVeto30_JetTotalDown")
        #if not self.jetVeto30_JetTotalDown_branch and "jetVeto30_JetTotalDown" not in self.complained:
        if not self.jetVeto30_JetTotalDown_branch and "jetVeto30_JetTotalDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTotalDown")
        else:
            self.jetVeto30_JetTotalDown_branch.SetAddress(<void*>&self.jetVeto30_JetTotalDown_value)

        #print "making jetVeto30_JetTotalUp"
        self.jetVeto30_JetTotalUp_branch = the_tree.GetBranch("jetVeto30_JetTotalUp")
        #if not self.jetVeto30_JetTotalUp_branch and "jetVeto30_JetTotalUp" not in self.complained:
        if not self.jetVeto30_JetTotalUp_branch and "jetVeto30_JetTotalUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTotalUp")
        else:
            self.jetVeto30_JetTotalUp_branch.SetAddress(<void*>&self.jetVeto30_JetTotalUp_value)

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

        #print "making mChi2LocalPosition"
        self.mChi2LocalPosition_branch = the_tree.GetBranch("mChi2LocalPosition")
        #if not self.mChi2LocalPosition_branch and "mChi2LocalPosition" not in self.complained:
        if not self.mChi2LocalPosition_branch and "mChi2LocalPosition":
            warnings.warn( "MuTauTree: Expected branch mChi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mChi2LocalPosition")
        else:
            self.mChi2LocalPosition_branch.SetAddress(<void*>&self.mChi2LocalPosition_value)

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

        #print "making mErsatzGenEta"
        self.mErsatzGenEta_branch = the_tree.GetBranch("mErsatzGenEta")
        #if not self.mErsatzGenEta_branch and "mErsatzGenEta" not in self.complained:
        if not self.mErsatzGenEta_branch and "mErsatzGenEta":
            warnings.warn( "MuTauTree: Expected branch mErsatzGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mErsatzGenEta")
        else:
            self.mErsatzGenEta_branch.SetAddress(<void*>&self.mErsatzGenEta_value)

        #print "making mErsatzGenM"
        self.mErsatzGenM_branch = the_tree.GetBranch("mErsatzGenM")
        #if not self.mErsatzGenM_branch and "mErsatzGenM" not in self.complained:
        if not self.mErsatzGenM_branch and "mErsatzGenM":
            warnings.warn( "MuTauTree: Expected branch mErsatzGenM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mErsatzGenM")
        else:
            self.mErsatzGenM_branch.SetAddress(<void*>&self.mErsatzGenM_value)

        #print "making mErsatzGenPhi"
        self.mErsatzGenPhi_branch = the_tree.GetBranch("mErsatzGenPhi")
        #if not self.mErsatzGenPhi_branch and "mErsatzGenPhi" not in self.complained:
        if not self.mErsatzGenPhi_branch and "mErsatzGenPhi":
            warnings.warn( "MuTauTree: Expected branch mErsatzGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mErsatzGenPhi")
        else:
            self.mErsatzGenPhi_branch.SetAddress(<void*>&self.mErsatzGenPhi_value)

        #print "making mErsatzGenpT"
        self.mErsatzGenpT_branch = the_tree.GetBranch("mErsatzGenpT")
        #if not self.mErsatzGenpT_branch and "mErsatzGenpT" not in self.complained:
        if not self.mErsatzGenpT_branch and "mErsatzGenpT":
            warnings.warn( "MuTauTree: Expected branch mErsatzGenpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mErsatzGenpT")
        else:
            self.mErsatzGenpT_branch.SetAddress(<void*>&self.mErsatzGenpT_value)

        #print "making mErsatzGenpX"
        self.mErsatzGenpX_branch = the_tree.GetBranch("mErsatzGenpX")
        #if not self.mErsatzGenpX_branch and "mErsatzGenpX" not in self.complained:
        if not self.mErsatzGenpX_branch and "mErsatzGenpX":
            warnings.warn( "MuTauTree: Expected branch mErsatzGenpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mErsatzGenpX")
        else:
            self.mErsatzGenpX_branch.SetAddress(<void*>&self.mErsatzGenpX_value)

        #print "making mErsatzGenpY"
        self.mErsatzGenpY_branch = the_tree.GetBranch("mErsatzGenpY")
        #if not self.mErsatzGenpY_branch and "mErsatzGenpY" not in self.complained:
        if not self.mErsatzGenpY_branch and "mErsatzGenpY":
            warnings.warn( "MuTauTree: Expected branch mErsatzGenpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mErsatzGenpY")
        else:
            self.mErsatzGenpY_branch.SetAddress(<void*>&self.mErsatzGenpY_value)

        #print "making mErsatzVispX"
        self.mErsatzVispX_branch = the_tree.GetBranch("mErsatzVispX")
        #if not self.mErsatzVispX_branch and "mErsatzVispX" not in self.complained:
        if not self.mErsatzVispX_branch and "mErsatzVispX":
            warnings.warn( "MuTauTree: Expected branch mErsatzVispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mErsatzVispX")
        else:
            self.mErsatzVispX_branch.SetAddress(<void*>&self.mErsatzVispX_value)

        #print "making mErsatzVispY"
        self.mErsatzVispY_branch = the_tree.GetBranch("mErsatzVispY")
        #if not self.mErsatzVispY_branch and "mErsatzVispY" not in self.complained:
        if not self.mErsatzVispY_branch and "mErsatzVispY":
            warnings.warn( "MuTauTree: Expected branch mErsatzVispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mErsatzVispY")
        else:
            self.mErsatzVispY_branch.SetAddress(<void*>&self.mErsatzVispY_value)

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

        #print "making mGenDirectPromptTauDecayFinalState"
        self.mGenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("mGenDirectPromptTauDecayFinalState")
        #if not self.mGenDirectPromptTauDecayFinalState_branch and "mGenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.mGenDirectPromptTauDecayFinalState_branch and "mGenDirectPromptTauDecayFinalState":
            warnings.warn( "MuTauTree: Expected branch mGenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenDirectPromptTauDecayFinalState")
        else:
            self.mGenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.mGenDirectPromptTauDecayFinalState_value)

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

        #print "making mGenIsPrompt"
        self.mGenIsPrompt_branch = the_tree.GetBranch("mGenIsPrompt")
        #if not self.mGenIsPrompt_branch and "mGenIsPrompt" not in self.complained:
        if not self.mGenIsPrompt_branch and "mGenIsPrompt":
            warnings.warn( "MuTauTree: Expected branch mGenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenIsPrompt")
        else:
            self.mGenIsPrompt_branch.SetAddress(<void*>&self.mGenIsPrompt_value)

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

        #print "making mGenPromptFinalState"
        self.mGenPromptFinalState_branch = the_tree.GetBranch("mGenPromptFinalState")
        #if not self.mGenPromptFinalState_branch and "mGenPromptFinalState" not in self.complained:
        if not self.mGenPromptFinalState_branch and "mGenPromptFinalState":
            warnings.warn( "MuTauTree: Expected branch mGenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPromptFinalState")
        else:
            self.mGenPromptFinalState_branch.SetAddress(<void*>&self.mGenPromptFinalState_value)

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

        #print "making mIsoDB03"
        self.mIsoDB03_branch = the_tree.GetBranch("mIsoDB03")
        #if not self.mIsoDB03_branch and "mIsoDB03" not in self.complained:
        if not self.mIsoDB03_branch and "mIsoDB03":
            warnings.warn( "MuTauTree: Expected branch mIsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoDB03")
        else:
            self.mIsoDB03_branch.SetAddress(<void*>&self.mIsoDB03_value)

        #print "making mIsoDB04"
        self.mIsoDB04_branch = the_tree.GetBranch("mIsoDB04")
        #if not self.mIsoDB04_branch and "mIsoDB04" not in self.complained:
        if not self.mIsoDB04_branch and "mIsoDB04":
            warnings.warn( "MuTauTree: Expected branch mIsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoDB04")
        else:
            self.mIsoDB04_branch.SetAddress(<void*>&self.mIsoDB04_value)

        #print "making mIsoMu22Filter"
        self.mIsoMu22Filter_branch = the_tree.GetBranch("mIsoMu22Filter")
        #if not self.mIsoMu22Filter_branch and "mIsoMu22Filter" not in self.complained:
        if not self.mIsoMu22Filter_branch and "mIsoMu22Filter":
            warnings.warn( "MuTauTree: Expected branch mIsoMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoMu22Filter")
        else:
            self.mIsoMu22Filter_branch.SetAddress(<void*>&self.mIsoMu22Filter_value)

        #print "making mIsoMu22eta2p1Filter"
        self.mIsoMu22eta2p1Filter_branch = the_tree.GetBranch("mIsoMu22eta2p1Filter")
        #if not self.mIsoMu22eta2p1Filter_branch and "mIsoMu22eta2p1Filter" not in self.complained:
        if not self.mIsoMu22eta2p1Filter_branch and "mIsoMu22eta2p1Filter":
            warnings.warn( "MuTauTree: Expected branch mIsoMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoMu22eta2p1Filter")
        else:
            self.mIsoMu22eta2p1Filter_branch.SetAddress(<void*>&self.mIsoMu22eta2p1Filter_value)

        #print "making mIsoMu24Filter"
        self.mIsoMu24Filter_branch = the_tree.GetBranch("mIsoMu24Filter")
        #if not self.mIsoMu24Filter_branch and "mIsoMu24Filter" not in self.complained:
        if not self.mIsoMu24Filter_branch and "mIsoMu24Filter":
            warnings.warn( "MuTauTree: Expected branch mIsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoMu24Filter")
        else:
            self.mIsoMu24Filter_branch.SetAddress(<void*>&self.mIsoMu24Filter_value)

        #print "making mIsoMu24eta2p1Filter"
        self.mIsoMu24eta2p1Filter_branch = the_tree.GetBranch("mIsoMu24eta2p1Filter")
        #if not self.mIsoMu24eta2p1Filter_branch and "mIsoMu24eta2p1Filter" not in self.complained:
        if not self.mIsoMu24eta2p1Filter_branch and "mIsoMu24eta2p1Filter":
            warnings.warn( "MuTauTree: Expected branch mIsoMu24eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoMu24eta2p1Filter")
        else:
            self.mIsoMu24eta2p1Filter_branch.SetAddress(<void*>&self.mIsoMu24eta2p1Filter_value)

        #print "making mIsoTkMu22Filter"
        self.mIsoTkMu22Filter_branch = the_tree.GetBranch("mIsoTkMu22Filter")
        #if not self.mIsoTkMu22Filter_branch and "mIsoTkMu22Filter" not in self.complained:
        if not self.mIsoTkMu22Filter_branch and "mIsoTkMu22Filter":
            warnings.warn( "MuTauTree: Expected branch mIsoTkMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoTkMu22Filter")
        else:
            self.mIsoTkMu22Filter_branch.SetAddress(<void*>&self.mIsoTkMu22Filter_value)

        #print "making mIsoTkMu22eta2p1Filter"
        self.mIsoTkMu22eta2p1Filter_branch = the_tree.GetBranch("mIsoTkMu22eta2p1Filter")
        #if not self.mIsoTkMu22eta2p1Filter_branch and "mIsoTkMu22eta2p1Filter" not in self.complained:
        if not self.mIsoTkMu22eta2p1Filter_branch and "mIsoTkMu22eta2p1Filter":
            warnings.warn( "MuTauTree: Expected branch mIsoTkMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoTkMu22eta2p1Filter")
        else:
            self.mIsoTkMu22eta2p1Filter_branch.SetAddress(<void*>&self.mIsoTkMu22eta2p1Filter_value)

        #print "making mIsoTkMu24Filter"
        self.mIsoTkMu24Filter_branch = the_tree.GetBranch("mIsoTkMu24Filter")
        #if not self.mIsoTkMu24Filter_branch and "mIsoTkMu24Filter" not in self.complained:
        if not self.mIsoTkMu24Filter_branch and "mIsoTkMu24Filter":
            warnings.warn( "MuTauTree: Expected branch mIsoTkMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoTkMu24Filter")
        else:
            self.mIsoTkMu24Filter_branch.SetAddress(<void*>&self.mIsoTkMu24Filter_value)

        #print "making mIsoTkMu24eta2p1Filter"
        self.mIsoTkMu24eta2p1Filter_branch = the_tree.GetBranch("mIsoTkMu24eta2p1Filter")
        #if not self.mIsoTkMu24eta2p1Filter_branch and "mIsoTkMu24eta2p1Filter" not in self.complained:
        if not self.mIsoTkMu24eta2p1Filter_branch and "mIsoTkMu24eta2p1Filter":
            warnings.warn( "MuTauTree: Expected branch mIsoTkMu24eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoTkMu24eta2p1Filter")
        else:
            self.mIsoTkMu24eta2p1Filter_branch.SetAddress(<void*>&self.mIsoTkMu24eta2p1Filter_value)

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

        #print "making mJetHadronFlavour"
        self.mJetHadronFlavour_branch = the_tree.GetBranch("mJetHadronFlavour")
        #if not self.mJetHadronFlavour_branch and "mJetHadronFlavour" not in self.complained:
        if not self.mJetHadronFlavour_branch and "mJetHadronFlavour":
            warnings.warn( "MuTauTree: Expected branch mJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetHadronFlavour")
        else:
            self.mJetHadronFlavour_branch.SetAddress(<void*>&self.mJetHadronFlavour_value)

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

        #print "making mMatchesIsoMu22Path"
        self.mMatchesIsoMu22Path_branch = the_tree.GetBranch("mMatchesIsoMu22Path")
        #if not self.mMatchesIsoMu22Path_branch and "mMatchesIsoMu22Path" not in self.complained:
        if not self.mMatchesIsoMu22Path_branch and "mMatchesIsoMu22Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu22Path")
        else:
            self.mMatchesIsoMu22Path_branch.SetAddress(<void*>&self.mMatchesIsoMu22Path_value)

        #print "making mMatchesIsoMu22eta2p1Path"
        self.mMatchesIsoMu22eta2p1Path_branch = the_tree.GetBranch("mMatchesIsoMu22eta2p1Path")
        #if not self.mMatchesIsoMu22eta2p1Path_branch and "mMatchesIsoMu22eta2p1Path" not in self.complained:
        if not self.mMatchesIsoMu22eta2p1Path_branch and "mMatchesIsoMu22eta2p1Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu22eta2p1Path")
        else:
            self.mMatchesIsoMu22eta2p1Path_branch.SetAddress(<void*>&self.mMatchesIsoMu22eta2p1Path_value)

        #print "making mMatchesIsoMu24Path"
        self.mMatchesIsoMu24Path_branch = the_tree.GetBranch("mMatchesIsoMu24Path")
        #if not self.mMatchesIsoMu24Path_branch and "mMatchesIsoMu24Path" not in self.complained:
        if not self.mMatchesIsoMu24Path_branch and "mMatchesIsoMu24Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu24Path")
        else:
            self.mMatchesIsoMu24Path_branch.SetAddress(<void*>&self.mMatchesIsoMu24Path_value)

        #print "making mMatchesIsoMu24eta2p1Path"
        self.mMatchesIsoMu24eta2p1Path_branch = the_tree.GetBranch("mMatchesIsoMu24eta2p1Path")
        #if not self.mMatchesIsoMu24eta2p1Path_branch and "mMatchesIsoMu24eta2p1Path" not in self.complained:
        if not self.mMatchesIsoMu24eta2p1Path_branch and "mMatchesIsoMu24eta2p1Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu24eta2p1Path")
        else:
            self.mMatchesIsoMu24eta2p1Path_branch.SetAddress(<void*>&self.mMatchesIsoMu24eta2p1Path_value)

        #print "making mMatchesIsoTkMu22Path"
        self.mMatchesIsoTkMu22Path_branch = the_tree.GetBranch("mMatchesIsoTkMu22Path")
        #if not self.mMatchesIsoTkMu22Path_branch and "mMatchesIsoTkMu22Path" not in self.complained:
        if not self.mMatchesIsoTkMu22Path_branch and "mMatchesIsoTkMu22Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoTkMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoTkMu22Path")
        else:
            self.mMatchesIsoTkMu22Path_branch.SetAddress(<void*>&self.mMatchesIsoTkMu22Path_value)

        #print "making mMatchesIsoTkMu22eta2p1Path"
        self.mMatchesIsoTkMu22eta2p1Path_branch = the_tree.GetBranch("mMatchesIsoTkMu22eta2p1Path")
        #if not self.mMatchesIsoTkMu22eta2p1Path_branch and "mMatchesIsoTkMu22eta2p1Path" not in self.complained:
        if not self.mMatchesIsoTkMu22eta2p1Path_branch and "mMatchesIsoTkMu22eta2p1Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoTkMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoTkMu22eta2p1Path")
        else:
            self.mMatchesIsoTkMu22eta2p1Path_branch.SetAddress(<void*>&self.mMatchesIsoTkMu22eta2p1Path_value)

        #print "making mMatchesIsoTkMu24Path"
        self.mMatchesIsoTkMu24Path_branch = the_tree.GetBranch("mMatchesIsoTkMu24Path")
        #if not self.mMatchesIsoTkMu24Path_branch and "mMatchesIsoTkMu24Path" not in self.complained:
        if not self.mMatchesIsoTkMu24Path_branch and "mMatchesIsoTkMu24Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoTkMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoTkMu24Path")
        else:
            self.mMatchesIsoTkMu24Path_branch.SetAddress(<void*>&self.mMatchesIsoTkMu24Path_value)

        #print "making mMatchesIsoTkMu24eta2p1Path"
        self.mMatchesIsoTkMu24eta2p1Path_branch = the_tree.GetBranch("mMatchesIsoTkMu24eta2p1Path")
        #if not self.mMatchesIsoTkMu24eta2p1Path_branch and "mMatchesIsoTkMu24eta2p1Path" not in self.complained:
        if not self.mMatchesIsoTkMu24eta2p1Path_branch and "mMatchesIsoTkMu24eta2p1Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoTkMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoTkMu24eta2p1Path")
        else:
            self.mMatchesIsoTkMu24eta2p1Path_branch.SetAddress(<void*>&self.mMatchesIsoTkMu24eta2p1Path_value)

        #print "making mMatchesMu19Tau20Filter"
        self.mMatchesMu19Tau20Filter_branch = the_tree.GetBranch("mMatchesMu19Tau20Filter")
        #if not self.mMatchesMu19Tau20Filter_branch and "mMatchesMu19Tau20Filter" not in self.complained:
        if not self.mMatchesMu19Tau20Filter_branch and "mMatchesMu19Tau20Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu19Tau20Filter")
        else:
            self.mMatchesMu19Tau20Filter_branch.SetAddress(<void*>&self.mMatchesMu19Tau20Filter_value)

        #print "making mMatchesMu19Tau20Path"
        self.mMatchesMu19Tau20Path_branch = the_tree.GetBranch("mMatchesMu19Tau20Path")
        #if not self.mMatchesMu19Tau20Path_branch and "mMatchesMu19Tau20Path" not in self.complained:
        if not self.mMatchesMu19Tau20Path_branch and "mMatchesMu19Tau20Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu19Tau20Path")
        else:
            self.mMatchesMu19Tau20Path_branch.SetAddress(<void*>&self.mMatchesMu19Tau20Path_value)

        #print "making mMatchesMu19Tau20sL1Filter"
        self.mMatchesMu19Tau20sL1Filter_branch = the_tree.GetBranch("mMatchesMu19Tau20sL1Filter")
        #if not self.mMatchesMu19Tau20sL1Filter_branch and "mMatchesMu19Tau20sL1Filter" not in self.complained:
        if not self.mMatchesMu19Tau20sL1Filter_branch and "mMatchesMu19Tau20sL1Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu19Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu19Tau20sL1Filter")
        else:
            self.mMatchesMu19Tau20sL1Filter_branch.SetAddress(<void*>&self.mMatchesMu19Tau20sL1Filter_value)

        #print "making mMatchesMu19Tau20sL1Path"
        self.mMatchesMu19Tau20sL1Path_branch = the_tree.GetBranch("mMatchesMu19Tau20sL1Path")
        #if not self.mMatchesMu19Tau20sL1Path_branch and "mMatchesMu19Tau20sL1Path" not in self.complained:
        if not self.mMatchesMu19Tau20sL1Path_branch and "mMatchesMu19Tau20sL1Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu19Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu19Tau20sL1Path")
        else:
            self.mMatchesMu19Tau20sL1Path_branch.SetAddress(<void*>&self.mMatchesMu19Tau20sL1Path_value)

        #print "making mMatchesMu23Ele12Path"
        self.mMatchesMu23Ele12Path_branch = the_tree.GetBranch("mMatchesMu23Ele12Path")
        #if not self.mMatchesMu23Ele12Path_branch and "mMatchesMu23Ele12Path" not in self.complained:
        if not self.mMatchesMu23Ele12Path_branch and "mMatchesMu23Ele12Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu23Ele12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu23Ele12Path")
        else:
            self.mMatchesMu23Ele12Path_branch.SetAddress(<void*>&self.mMatchesMu23Ele12Path_value)

        #print "making mMatchesMu8Ele23Path"
        self.mMatchesMu8Ele23Path_branch = the_tree.GetBranch("mMatchesMu8Ele23Path")
        #if not self.mMatchesMu8Ele23Path_branch and "mMatchesMu8Ele23Path" not in self.complained:
        if not self.mMatchesMu8Ele23Path_branch and "mMatchesMu8Ele23Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu8Ele23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu8Ele23Path")
        else:
            self.mMatchesMu8Ele23Path_branch.SetAddress(<void*>&self.mMatchesMu8Ele23Path_value)

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

        #print "making mMu23Ele12Filter"
        self.mMu23Ele12Filter_branch = the_tree.GetBranch("mMu23Ele12Filter")
        #if not self.mMu23Ele12Filter_branch and "mMu23Ele12Filter" not in self.complained:
        if not self.mMu23Ele12Filter_branch and "mMu23Ele12Filter":
            warnings.warn( "MuTauTree: Expected branch mMu23Ele12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMu23Ele12Filter")
        else:
            self.mMu23Ele12Filter_branch.SetAddress(<void*>&self.mMu23Ele12Filter_value)

        #print "making mMu8Ele23Filter"
        self.mMu8Ele23Filter_branch = the_tree.GetBranch("mMu8Ele23Filter")
        #if not self.mMu8Ele23Filter_branch and "mMu8Ele23Filter" not in self.complained:
        if not self.mMu8Ele23Filter_branch and "mMu8Ele23Filter":
            warnings.warn( "MuTauTree: Expected branch mMu8Ele23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMu8Ele23Filter")
        else:
            self.mMu8Ele23Filter_branch.SetAddress(<void*>&self.mMu8Ele23Filter_value)

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

        #print "making mNormalizedChi2"
        self.mNormalizedChi2_branch = the_tree.GetBranch("mNormalizedChi2")
        #if not self.mNormalizedChi2_branch and "mNormalizedChi2" not in self.complained:
        if not self.mNormalizedChi2_branch and "mNormalizedChi2":
            warnings.warn( "MuTauTree: Expected branch mNormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mNormalizedChi2")
        else:
            self.mNormalizedChi2_branch.SetAddress(<void*>&self.mNormalizedChi2_value)

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

        #print "making mSegmentCompatibility"
        self.mSegmentCompatibility_branch = the_tree.GetBranch("mSegmentCompatibility")
        #if not self.mSegmentCompatibility_branch and "mSegmentCompatibility" not in self.complained:
        if not self.mSegmentCompatibility_branch and "mSegmentCompatibility":
            warnings.warn( "MuTauTree: Expected branch mSegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mSegmentCompatibility")
        else:
            self.mSegmentCompatibility_branch.SetAddress(<void*>&self.mSegmentCompatibility_value)

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

        #print "making mTrkKink"
        self.mTrkKink_branch = the_tree.GetBranch("mTrkKink")
        #if not self.mTrkKink_branch and "mTrkKink" not in self.complained:
        if not self.mTrkKink_branch and "mTrkKink":
            warnings.warn( "MuTauTree: Expected branch mTrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTrkKink")
        else:
            self.mTrkKink_branch.SetAddress(<void*>&self.mTrkKink_value)

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

        #print "making mValidFraction"
        self.mValidFraction_branch = the_tree.GetBranch("mValidFraction")
        #if not self.mValidFraction_branch and "mValidFraction" not in self.complained:
        if not self.mValidFraction_branch and "mValidFraction":
            warnings.warn( "MuTauTree: Expected branch mValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mValidFraction")
        else:
            self.mValidFraction_branch.SetAddress(<void*>&self.mValidFraction_value)

        #print "making mZTTGenMatching"
        self.mZTTGenMatching_branch = the_tree.GetBranch("mZTTGenMatching")
        #if not self.mZTTGenMatching_branch and "mZTTGenMatching" not in self.complained:
        if not self.mZTTGenMatching_branch and "mZTTGenMatching":
            warnings.warn( "MuTauTree: Expected branch mZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mZTTGenMatching")
        else:
            self.mZTTGenMatching_branch.SetAddress(<void*>&self.mZTTGenMatching_value)

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

        #print "making m_t_MtTotal"
        self.m_t_MtTotal_branch = the_tree.GetBranch("m_t_MtTotal")
        #if not self.m_t_MtTotal_branch and "m_t_MtTotal" not in self.complained:
        if not self.m_t_MtTotal_branch and "m_t_MtTotal":
            warnings.warn( "MuTauTree: Expected branch m_t_MtTotal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_MtTotal")
        else:
            self.m_t_MtTotal_branch.SetAddress(<void*>&self.m_t_MtTotal_value)

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

        #print "making m_t_MvaMet"
        self.m_t_MvaMet_branch = the_tree.GetBranch("m_t_MvaMet")
        #if not self.m_t_MvaMet_branch and "m_t_MvaMet" not in self.complained:
        if not self.m_t_MvaMet_branch and "m_t_MvaMet":
            warnings.warn( "MuTauTree: Expected branch m_t_MvaMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_MvaMet")
        else:
            self.m_t_MvaMet_branch.SetAddress(<void*>&self.m_t_MvaMet_value)

        #print "making m_t_MvaMetCovMatrix00"
        self.m_t_MvaMetCovMatrix00_branch = the_tree.GetBranch("m_t_MvaMetCovMatrix00")
        #if not self.m_t_MvaMetCovMatrix00_branch and "m_t_MvaMetCovMatrix00" not in self.complained:
        if not self.m_t_MvaMetCovMatrix00_branch and "m_t_MvaMetCovMatrix00":
            warnings.warn( "MuTauTree: Expected branch m_t_MvaMetCovMatrix00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_MvaMetCovMatrix00")
        else:
            self.m_t_MvaMetCovMatrix00_branch.SetAddress(<void*>&self.m_t_MvaMetCovMatrix00_value)

        #print "making m_t_MvaMetCovMatrix01"
        self.m_t_MvaMetCovMatrix01_branch = the_tree.GetBranch("m_t_MvaMetCovMatrix01")
        #if not self.m_t_MvaMetCovMatrix01_branch and "m_t_MvaMetCovMatrix01" not in self.complained:
        if not self.m_t_MvaMetCovMatrix01_branch and "m_t_MvaMetCovMatrix01":
            warnings.warn( "MuTauTree: Expected branch m_t_MvaMetCovMatrix01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_MvaMetCovMatrix01")
        else:
            self.m_t_MvaMetCovMatrix01_branch.SetAddress(<void*>&self.m_t_MvaMetCovMatrix01_value)

        #print "making m_t_MvaMetCovMatrix10"
        self.m_t_MvaMetCovMatrix10_branch = the_tree.GetBranch("m_t_MvaMetCovMatrix10")
        #if not self.m_t_MvaMetCovMatrix10_branch and "m_t_MvaMetCovMatrix10" not in self.complained:
        if not self.m_t_MvaMetCovMatrix10_branch and "m_t_MvaMetCovMatrix10":
            warnings.warn( "MuTauTree: Expected branch m_t_MvaMetCovMatrix10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_MvaMetCovMatrix10")
        else:
            self.m_t_MvaMetCovMatrix10_branch.SetAddress(<void*>&self.m_t_MvaMetCovMatrix10_value)

        #print "making m_t_MvaMetCovMatrix11"
        self.m_t_MvaMetCovMatrix11_branch = the_tree.GetBranch("m_t_MvaMetCovMatrix11")
        #if not self.m_t_MvaMetCovMatrix11_branch and "m_t_MvaMetCovMatrix11" not in self.complained:
        if not self.m_t_MvaMetCovMatrix11_branch and "m_t_MvaMetCovMatrix11":
            warnings.warn( "MuTauTree: Expected branch m_t_MvaMetCovMatrix11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_MvaMetCovMatrix11")
        else:
            self.m_t_MvaMetCovMatrix11_branch.SetAddress(<void*>&self.m_t_MvaMetCovMatrix11_value)

        #print "making m_t_MvaMetPhi"
        self.m_t_MvaMetPhi_branch = the_tree.GetBranch("m_t_MvaMetPhi")
        #if not self.m_t_MvaMetPhi_branch and "m_t_MvaMetPhi" not in self.complained:
        if not self.m_t_MvaMetPhi_branch and "m_t_MvaMetPhi":
            warnings.warn( "MuTauTree: Expected branch m_t_MvaMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_MvaMetPhi")
        else:
            self.m_t_MvaMetPhi_branch.SetAddress(<void*>&self.m_t_MvaMetPhi_value)

        #print "making m_t_PZeta"
        self.m_t_PZeta_branch = the_tree.GetBranch("m_t_PZeta")
        #if not self.m_t_PZeta_branch and "m_t_PZeta" not in self.complained:
        if not self.m_t_PZeta_branch and "m_t_PZeta":
            warnings.warn( "MuTauTree: Expected branch m_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_PZeta")
        else:
            self.m_t_PZeta_branch.SetAddress(<void*>&self.m_t_PZeta_value)

        #print "making m_t_PZetaLess0p85PZetaVis"
        self.m_t_PZetaLess0p85PZetaVis_branch = the_tree.GetBranch("m_t_PZetaLess0p85PZetaVis")
        #if not self.m_t_PZetaLess0p85PZetaVis_branch and "m_t_PZetaLess0p85PZetaVis" not in self.complained:
        if not self.m_t_PZetaLess0p85PZetaVis_branch and "m_t_PZetaLess0p85PZetaVis":
            warnings.warn( "MuTauTree: Expected branch m_t_PZetaLess0p85PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_PZetaLess0p85PZetaVis")
        else:
            self.m_t_PZetaLess0p85PZetaVis_branch.SetAddress(<void*>&self.m_t_PZetaLess0p85PZetaVis_value)

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

        #print "making m_t_collinearmass_EleEnDown"
        self.m_t_collinearmass_EleEnDown_branch = the_tree.GetBranch("m_t_collinearmass_EleEnDown")
        #if not self.m_t_collinearmass_EleEnDown_branch and "m_t_collinearmass_EleEnDown" not in self.complained:
        if not self.m_t_collinearmass_EleEnDown_branch and "m_t_collinearmass_EleEnDown":
            warnings.warn( "MuTauTree: Expected branch m_t_collinearmass_EleEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_collinearmass_EleEnDown")
        else:
            self.m_t_collinearmass_EleEnDown_branch.SetAddress(<void*>&self.m_t_collinearmass_EleEnDown_value)

        #print "making m_t_collinearmass_EleEnUp"
        self.m_t_collinearmass_EleEnUp_branch = the_tree.GetBranch("m_t_collinearmass_EleEnUp")
        #if not self.m_t_collinearmass_EleEnUp_branch and "m_t_collinearmass_EleEnUp" not in self.complained:
        if not self.m_t_collinearmass_EleEnUp_branch and "m_t_collinearmass_EleEnUp":
            warnings.warn( "MuTauTree: Expected branch m_t_collinearmass_EleEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_collinearmass_EleEnUp")
        else:
            self.m_t_collinearmass_EleEnUp_branch.SetAddress(<void*>&self.m_t_collinearmass_EleEnUp_value)

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

        #print "making m_t_collinearmass_MuEnDown"
        self.m_t_collinearmass_MuEnDown_branch = the_tree.GetBranch("m_t_collinearmass_MuEnDown")
        #if not self.m_t_collinearmass_MuEnDown_branch and "m_t_collinearmass_MuEnDown" not in self.complained:
        if not self.m_t_collinearmass_MuEnDown_branch and "m_t_collinearmass_MuEnDown":
            warnings.warn( "MuTauTree: Expected branch m_t_collinearmass_MuEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_collinearmass_MuEnDown")
        else:
            self.m_t_collinearmass_MuEnDown_branch.SetAddress(<void*>&self.m_t_collinearmass_MuEnDown_value)

        #print "making m_t_collinearmass_MuEnUp"
        self.m_t_collinearmass_MuEnUp_branch = the_tree.GetBranch("m_t_collinearmass_MuEnUp")
        #if not self.m_t_collinearmass_MuEnUp_branch and "m_t_collinearmass_MuEnUp" not in self.complained:
        if not self.m_t_collinearmass_MuEnUp_branch and "m_t_collinearmass_MuEnUp":
            warnings.warn( "MuTauTree: Expected branch m_t_collinearmass_MuEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_collinearmass_MuEnUp")
        else:
            self.m_t_collinearmass_MuEnUp_branch.SetAddress(<void*>&self.m_t_collinearmass_MuEnUp_value)

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

        #print "making m_t_pt_tt"
        self.m_t_pt_tt_branch = the_tree.GetBranch("m_t_pt_tt")
        #if not self.m_t_pt_tt_branch and "m_t_pt_tt" not in self.complained:
        if not self.m_t_pt_tt_branch and "m_t_pt_tt":
            warnings.warn( "MuTauTree: Expected branch m_t_pt_tt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_pt_tt")
        else:
            self.m_t_pt_tt_branch.SetAddress(<void*>&self.m_t_pt_tt_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "MuTauTree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "MuTauTree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "MuTauTree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "MuTauTree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "MuTauTree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

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

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "MuTauTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making muVetoZTTp001dxyzR0"
        self.muVetoZTTp001dxyzR0_branch = the_tree.GetBranch("muVetoZTTp001dxyzR0")
        #if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0" not in self.complained:
        if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0":
            warnings.warn( "MuTauTree: Expected branch muVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyzR0")
        else:
            self.muVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.muVetoZTTp001dxyzR0_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "MuTauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "MuTauTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

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

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "MuTauTree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "MuTauTree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

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

        #print "making singleE20SingleTau28Group"
        self.singleE20SingleTau28Group_branch = the_tree.GetBranch("singleE20SingleTau28Group")
        #if not self.singleE20SingleTau28Group_branch and "singleE20SingleTau28Group" not in self.complained:
        if not self.singleE20SingleTau28Group_branch and "singleE20SingleTau28Group":
            warnings.warn( "MuTauTree: Expected branch singleE20SingleTau28Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE20SingleTau28Group")
        else:
            self.singleE20SingleTau28Group_branch.SetAddress(<void*>&self.singleE20SingleTau28Group_value)

        #print "making singleE20SingleTau28Pass"
        self.singleE20SingleTau28Pass_branch = the_tree.GetBranch("singleE20SingleTau28Pass")
        #if not self.singleE20SingleTau28Pass_branch and "singleE20SingleTau28Pass" not in self.complained:
        if not self.singleE20SingleTau28Pass_branch and "singleE20SingleTau28Pass":
            warnings.warn( "MuTauTree: Expected branch singleE20SingleTau28Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE20SingleTau28Pass")
        else:
            self.singleE20SingleTau28Pass_branch.SetAddress(<void*>&self.singleE20SingleTau28Pass_value)

        #print "making singleE20SingleTau28Prescale"
        self.singleE20SingleTau28Prescale_branch = the_tree.GetBranch("singleE20SingleTau28Prescale")
        #if not self.singleE20SingleTau28Prescale_branch and "singleE20SingleTau28Prescale" not in self.complained:
        if not self.singleE20SingleTau28Prescale_branch and "singleE20SingleTau28Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE20SingleTau28Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE20SingleTau28Prescale")
        else:
            self.singleE20SingleTau28Prescale_branch.SetAddress(<void*>&self.singleE20SingleTau28Prescale_value)

        #print "making singleE22SingleTau20SingleL1Group"
        self.singleE22SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE22SingleTau20SingleL1Group")
        #if not self.singleE22SingleTau20SingleL1Group_branch and "singleE22SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE22SingleTau20SingleL1Group_branch and "singleE22SingleTau20SingleL1Group":
            warnings.warn( "MuTauTree: Expected branch singleE22SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau20SingleL1Group")
        else:
            self.singleE22SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE22SingleTau20SingleL1Group_value)

        #print "making singleE22SingleTau20SingleL1Pass"
        self.singleE22SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE22SingleTau20SingleL1Pass")
        #if not self.singleE22SingleTau20SingleL1Pass_branch and "singleE22SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE22SingleTau20SingleL1Pass_branch and "singleE22SingleTau20SingleL1Pass":
            warnings.warn( "MuTauTree: Expected branch singleE22SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau20SingleL1Pass")
        else:
            self.singleE22SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE22SingleTau20SingleL1Pass_value)

        #print "making singleE22SingleTau20SingleL1Prescale"
        self.singleE22SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE22SingleTau20SingleL1Prescale")
        #if not self.singleE22SingleTau20SingleL1Prescale_branch and "singleE22SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE22SingleTau20SingleL1Prescale_branch and "singleE22SingleTau20SingleL1Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE22SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau20SingleL1Prescale")
        else:
            self.singleE22SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE22SingleTau20SingleL1Prescale_value)

        #print "making singleE22SingleTau29Group"
        self.singleE22SingleTau29Group_branch = the_tree.GetBranch("singleE22SingleTau29Group")
        #if not self.singleE22SingleTau29Group_branch and "singleE22SingleTau29Group" not in self.complained:
        if not self.singleE22SingleTau29Group_branch and "singleE22SingleTau29Group":
            warnings.warn( "MuTauTree: Expected branch singleE22SingleTau29Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau29Group")
        else:
            self.singleE22SingleTau29Group_branch.SetAddress(<void*>&self.singleE22SingleTau29Group_value)

        #print "making singleE22SingleTau29Pass"
        self.singleE22SingleTau29Pass_branch = the_tree.GetBranch("singleE22SingleTau29Pass")
        #if not self.singleE22SingleTau29Pass_branch and "singleE22SingleTau29Pass" not in self.complained:
        if not self.singleE22SingleTau29Pass_branch and "singleE22SingleTau29Pass":
            warnings.warn( "MuTauTree: Expected branch singleE22SingleTau29Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau29Pass")
        else:
            self.singleE22SingleTau29Pass_branch.SetAddress(<void*>&self.singleE22SingleTau29Pass_value)

        #print "making singleE22SingleTau29Prescale"
        self.singleE22SingleTau29Prescale_branch = the_tree.GetBranch("singleE22SingleTau29Prescale")
        #if not self.singleE22SingleTau29Prescale_branch and "singleE22SingleTau29Prescale" not in self.complained:
        if not self.singleE22SingleTau29Prescale_branch and "singleE22SingleTau29Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE22SingleTau29Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE22SingleTau29Prescale")
        else:
            self.singleE22SingleTau29Prescale_branch.SetAddress(<void*>&self.singleE22SingleTau29Prescale_value)

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

        #print "making singleE24SingleTau20Group"
        self.singleE24SingleTau20Group_branch = the_tree.GetBranch("singleE24SingleTau20Group")
        #if not self.singleE24SingleTau20Group_branch and "singleE24SingleTau20Group" not in self.complained:
        if not self.singleE24SingleTau20Group_branch and "singleE24SingleTau20Group":
            warnings.warn( "MuTauTree: Expected branch singleE24SingleTau20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20Group")
        else:
            self.singleE24SingleTau20Group_branch.SetAddress(<void*>&self.singleE24SingleTau20Group_value)

        #print "making singleE24SingleTau20Pass"
        self.singleE24SingleTau20Pass_branch = the_tree.GetBranch("singleE24SingleTau20Pass")
        #if not self.singleE24SingleTau20Pass_branch and "singleE24SingleTau20Pass" not in self.complained:
        if not self.singleE24SingleTau20Pass_branch and "singleE24SingleTau20Pass":
            warnings.warn( "MuTauTree: Expected branch singleE24SingleTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20Pass")
        else:
            self.singleE24SingleTau20Pass_branch.SetAddress(<void*>&self.singleE24SingleTau20Pass_value)

        #print "making singleE24SingleTau20Prescale"
        self.singleE24SingleTau20Prescale_branch = the_tree.GetBranch("singleE24SingleTau20Prescale")
        #if not self.singleE24SingleTau20Prescale_branch and "singleE24SingleTau20Prescale" not in self.complained:
        if not self.singleE24SingleTau20Prescale_branch and "singleE24SingleTau20Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE24SingleTau20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20Prescale")
        else:
            self.singleE24SingleTau20Prescale_branch.SetAddress(<void*>&self.singleE24SingleTau20Prescale_value)

        #print "making singleE24SingleTau20SingleL1Group"
        self.singleE24SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE24SingleTau20SingleL1Group")
        #if not self.singleE24SingleTau20SingleL1Group_branch and "singleE24SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE24SingleTau20SingleL1Group_branch and "singleE24SingleTau20SingleL1Group":
            warnings.warn( "MuTauTree: Expected branch singleE24SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20SingleL1Group")
        else:
            self.singleE24SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE24SingleTau20SingleL1Group_value)

        #print "making singleE24SingleTau20SingleL1Pass"
        self.singleE24SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE24SingleTau20SingleL1Pass")
        #if not self.singleE24SingleTau20SingleL1Pass_branch and "singleE24SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE24SingleTau20SingleL1Pass_branch and "singleE24SingleTau20SingleL1Pass":
            warnings.warn( "MuTauTree: Expected branch singleE24SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20SingleL1Pass")
        else:
            self.singleE24SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE24SingleTau20SingleL1Pass_value)

        #print "making singleE24SingleTau20SingleL1Prescale"
        self.singleE24SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE24SingleTau20SingleL1Prescale")
        #if not self.singleE24SingleTau20SingleL1Prescale_branch and "singleE24SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE24SingleTau20SingleL1Prescale_branch and "singleE24SingleTau20SingleL1Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE24SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau20SingleL1Prescale")
        else:
            self.singleE24SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE24SingleTau20SingleL1Prescale_value)

        #print "making singleE24SingleTau30Group"
        self.singleE24SingleTau30Group_branch = the_tree.GetBranch("singleE24SingleTau30Group")
        #if not self.singleE24SingleTau30Group_branch and "singleE24SingleTau30Group" not in self.complained:
        if not self.singleE24SingleTau30Group_branch and "singleE24SingleTau30Group":
            warnings.warn( "MuTauTree: Expected branch singleE24SingleTau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau30Group")
        else:
            self.singleE24SingleTau30Group_branch.SetAddress(<void*>&self.singleE24SingleTau30Group_value)

        #print "making singleE24SingleTau30Pass"
        self.singleE24SingleTau30Pass_branch = the_tree.GetBranch("singleE24SingleTau30Pass")
        #if not self.singleE24SingleTau30Pass_branch and "singleE24SingleTau30Pass" not in self.complained:
        if not self.singleE24SingleTau30Pass_branch and "singleE24SingleTau30Pass":
            warnings.warn( "MuTauTree: Expected branch singleE24SingleTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau30Pass")
        else:
            self.singleE24SingleTau30Pass_branch.SetAddress(<void*>&self.singleE24SingleTau30Pass_value)

        #print "making singleE24SingleTau30Prescale"
        self.singleE24SingleTau30Prescale_branch = the_tree.GetBranch("singleE24SingleTau30Prescale")
        #if not self.singleE24SingleTau30Prescale_branch and "singleE24SingleTau30Prescale" not in self.complained:
        if not self.singleE24SingleTau30Prescale_branch and "singleE24SingleTau30Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE24SingleTau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTau30Prescale")
        else:
            self.singleE24SingleTau30Prescale_branch.SetAddress(<void*>&self.singleE24SingleTau30Prescale_value)

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

        #print "making singleE27SingleTau20SingleL1Group"
        self.singleE27SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE27SingleTau20SingleL1Group")
        #if not self.singleE27SingleTau20SingleL1Group_branch and "singleE27SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE27SingleTau20SingleL1Group_branch and "singleE27SingleTau20SingleL1Group":
            warnings.warn( "MuTauTree: Expected branch singleE27SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27SingleTau20SingleL1Group")
        else:
            self.singleE27SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE27SingleTau20SingleL1Group_value)

        #print "making singleE27SingleTau20SingleL1Pass"
        self.singleE27SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE27SingleTau20SingleL1Pass")
        #if not self.singleE27SingleTau20SingleL1Pass_branch and "singleE27SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE27SingleTau20SingleL1Pass_branch and "singleE27SingleTau20SingleL1Pass":
            warnings.warn( "MuTauTree: Expected branch singleE27SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27SingleTau20SingleL1Pass")
        else:
            self.singleE27SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE27SingleTau20SingleL1Pass_value)

        #print "making singleE27SingleTau20SingleL1Prescale"
        self.singleE27SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE27SingleTau20SingleL1Prescale")
        #if not self.singleE27SingleTau20SingleL1Prescale_branch and "singleE27SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE27SingleTau20SingleL1Prescale_branch and "singleE27SingleTau20SingleL1Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE27SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27SingleTau20SingleL1Prescale")
        else:
            self.singleE27SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE27SingleTau20SingleL1Prescale_value)

        #print "making singleE27TightGroup"
        self.singleE27TightGroup_branch = the_tree.GetBranch("singleE27TightGroup")
        #if not self.singleE27TightGroup_branch and "singleE27TightGroup" not in self.complained:
        if not self.singleE27TightGroup_branch and "singleE27TightGroup":
            warnings.warn( "MuTauTree: Expected branch singleE27TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightGroup")
        else:
            self.singleE27TightGroup_branch.SetAddress(<void*>&self.singleE27TightGroup_value)

        #print "making singleE27TightPass"
        self.singleE27TightPass_branch = the_tree.GetBranch("singleE27TightPass")
        #if not self.singleE27TightPass_branch and "singleE27TightPass" not in self.complained:
        if not self.singleE27TightPass_branch and "singleE27TightPass":
            warnings.warn( "MuTauTree: Expected branch singleE27TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightPass")
        else:
            self.singleE27TightPass_branch.SetAddress(<void*>&self.singleE27TightPass_value)

        #print "making singleE27TightPrescale"
        self.singleE27TightPrescale_branch = the_tree.GetBranch("singleE27TightPrescale")
        #if not self.singleE27TightPrescale_branch and "singleE27TightPrescale" not in self.complained:
        if not self.singleE27TightPrescale_branch and "singleE27TightPrescale":
            warnings.warn( "MuTauTree: Expected branch singleE27TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightPrescale")
        else:
            self.singleE27TightPrescale_branch.SetAddress(<void*>&self.singleE27TightPrescale_value)

        #print "making singleE27eta2p1LooseGroup"
        self.singleE27eta2p1LooseGroup_branch = the_tree.GetBranch("singleE27eta2p1LooseGroup")
        #if not self.singleE27eta2p1LooseGroup_branch and "singleE27eta2p1LooseGroup" not in self.complained:
        if not self.singleE27eta2p1LooseGroup_branch and "singleE27eta2p1LooseGroup":
            warnings.warn( "MuTauTree: Expected branch singleE27eta2p1LooseGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1LooseGroup")
        else:
            self.singleE27eta2p1LooseGroup_branch.SetAddress(<void*>&self.singleE27eta2p1LooseGroup_value)

        #print "making singleE27eta2p1LoosePass"
        self.singleE27eta2p1LoosePass_branch = the_tree.GetBranch("singleE27eta2p1LoosePass")
        #if not self.singleE27eta2p1LoosePass_branch and "singleE27eta2p1LoosePass" not in self.complained:
        if not self.singleE27eta2p1LoosePass_branch and "singleE27eta2p1LoosePass":
            warnings.warn( "MuTauTree: Expected branch singleE27eta2p1LoosePass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1LoosePass")
        else:
            self.singleE27eta2p1LoosePass_branch.SetAddress(<void*>&self.singleE27eta2p1LoosePass_value)

        #print "making singleE27eta2p1LoosePrescale"
        self.singleE27eta2p1LoosePrescale_branch = the_tree.GetBranch("singleE27eta2p1LoosePrescale")
        #if not self.singleE27eta2p1LoosePrescale_branch and "singleE27eta2p1LoosePrescale" not in self.complained:
        if not self.singleE27eta2p1LoosePrescale_branch and "singleE27eta2p1LoosePrescale":
            warnings.warn( "MuTauTree: Expected branch singleE27eta2p1LoosePrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1LoosePrescale")
        else:
            self.singleE27eta2p1LoosePrescale_branch.SetAddress(<void*>&self.singleE27eta2p1LoosePrescale_value)

        #print "making singleE27eta2p1TightGroup"
        self.singleE27eta2p1TightGroup_branch = the_tree.GetBranch("singleE27eta2p1TightGroup")
        #if not self.singleE27eta2p1TightGroup_branch and "singleE27eta2p1TightGroup" not in self.complained:
        if not self.singleE27eta2p1TightGroup_branch and "singleE27eta2p1TightGroup":
            warnings.warn( "MuTauTree: Expected branch singleE27eta2p1TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1TightGroup")
        else:
            self.singleE27eta2p1TightGroup_branch.SetAddress(<void*>&self.singleE27eta2p1TightGroup_value)

        #print "making singleE27eta2p1TightPass"
        self.singleE27eta2p1TightPass_branch = the_tree.GetBranch("singleE27eta2p1TightPass")
        #if not self.singleE27eta2p1TightPass_branch and "singleE27eta2p1TightPass" not in self.complained:
        if not self.singleE27eta2p1TightPass_branch and "singleE27eta2p1TightPass":
            warnings.warn( "MuTauTree: Expected branch singleE27eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1TightPass")
        else:
            self.singleE27eta2p1TightPass_branch.SetAddress(<void*>&self.singleE27eta2p1TightPass_value)

        #print "making singleE27eta2p1TightPrescale"
        self.singleE27eta2p1TightPrescale_branch = the_tree.GetBranch("singleE27eta2p1TightPrescale")
        #if not self.singleE27eta2p1TightPrescale_branch and "singleE27eta2p1TightPrescale" not in self.complained:
        if not self.singleE27eta2p1TightPrescale_branch and "singleE27eta2p1TightPrescale":
            warnings.warn( "MuTauTree: Expected branch singleE27eta2p1TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27eta2p1TightPrescale")
        else:
            self.singleE27eta2p1TightPrescale_branch.SetAddress(<void*>&self.singleE27eta2p1TightPrescale_value)

        #print "making singleE32SingleTau20SingleL1Group"
        self.singleE32SingleTau20SingleL1Group_branch = the_tree.GetBranch("singleE32SingleTau20SingleL1Group")
        #if not self.singleE32SingleTau20SingleL1Group_branch and "singleE32SingleTau20SingleL1Group" not in self.complained:
        if not self.singleE32SingleTau20SingleL1Group_branch and "singleE32SingleTau20SingleL1Group":
            warnings.warn( "MuTauTree: Expected branch singleE32SingleTau20SingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE32SingleTau20SingleL1Group")
        else:
            self.singleE32SingleTau20SingleL1Group_branch.SetAddress(<void*>&self.singleE32SingleTau20SingleL1Group_value)

        #print "making singleE32SingleTau20SingleL1Pass"
        self.singleE32SingleTau20SingleL1Pass_branch = the_tree.GetBranch("singleE32SingleTau20SingleL1Pass")
        #if not self.singleE32SingleTau20SingleL1Pass_branch and "singleE32SingleTau20SingleL1Pass" not in self.complained:
        if not self.singleE32SingleTau20SingleL1Pass_branch and "singleE32SingleTau20SingleL1Pass":
            warnings.warn( "MuTauTree: Expected branch singleE32SingleTau20SingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE32SingleTau20SingleL1Pass")
        else:
            self.singleE32SingleTau20SingleL1Pass_branch.SetAddress(<void*>&self.singleE32SingleTau20SingleL1Pass_value)

        #print "making singleE32SingleTau20SingleL1Prescale"
        self.singleE32SingleTau20SingleL1Prescale_branch = the_tree.GetBranch("singleE32SingleTau20SingleL1Prescale")
        #if not self.singleE32SingleTau20SingleL1Prescale_branch and "singleE32SingleTau20SingleL1Prescale" not in self.complained:
        if not self.singleE32SingleTau20SingleL1Prescale_branch and "singleE32SingleTau20SingleL1Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE32SingleTau20SingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE32SingleTau20SingleL1Prescale")
        else:
            self.singleE32SingleTau20SingleL1Prescale_branch.SetAddress(<void*>&self.singleE32SingleTau20SingleL1Prescale_value)

        #print "making singleE36SingleTau30Group"
        self.singleE36SingleTau30Group_branch = the_tree.GetBranch("singleE36SingleTau30Group")
        #if not self.singleE36SingleTau30Group_branch and "singleE36SingleTau30Group" not in self.complained:
        if not self.singleE36SingleTau30Group_branch and "singleE36SingleTau30Group":
            warnings.warn( "MuTauTree: Expected branch singleE36SingleTau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE36SingleTau30Group")
        else:
            self.singleE36SingleTau30Group_branch.SetAddress(<void*>&self.singleE36SingleTau30Group_value)

        #print "making singleE36SingleTau30Pass"
        self.singleE36SingleTau30Pass_branch = the_tree.GetBranch("singleE36SingleTau30Pass")
        #if not self.singleE36SingleTau30Pass_branch and "singleE36SingleTau30Pass" not in self.complained:
        if not self.singleE36SingleTau30Pass_branch and "singleE36SingleTau30Pass":
            warnings.warn( "MuTauTree: Expected branch singleE36SingleTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE36SingleTau30Pass")
        else:
            self.singleE36SingleTau30Pass_branch.SetAddress(<void*>&self.singleE36SingleTau30Pass_value)

        #print "making singleE36SingleTau30Prescale"
        self.singleE36SingleTau30Prescale_branch = the_tree.GetBranch("singleE36SingleTau30Prescale")
        #if not self.singleE36SingleTau30Prescale_branch and "singleE36SingleTau30Prescale" not in self.complained:
        if not self.singleE36SingleTau30Prescale_branch and "singleE36SingleTau30Prescale":
            warnings.warn( "MuTauTree: Expected branch singleE36SingleTau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE36SingleTau30Prescale")
        else:
            self.singleE36SingleTau30Prescale_branch.SetAddress(<void*>&self.singleE36SingleTau30Prescale_value)

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

        #print "making singleIsoMu24Group"
        self.singleIsoMu24Group_branch = the_tree.GetBranch("singleIsoMu24Group")
        #if not self.singleIsoMu24Group_branch and "singleIsoMu24Group" not in self.complained:
        if not self.singleIsoMu24Group_branch and "singleIsoMu24Group":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu24Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Group")
        else:
            self.singleIsoMu24Group_branch.SetAddress(<void*>&self.singleIsoMu24Group_value)

        #print "making singleIsoMu24Pass"
        self.singleIsoMu24Pass_branch = the_tree.GetBranch("singleIsoMu24Pass")
        #if not self.singleIsoMu24Pass_branch and "singleIsoMu24Pass" not in self.complained:
        if not self.singleIsoMu24Pass_branch and "singleIsoMu24Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Pass")
        else:
            self.singleIsoMu24Pass_branch.SetAddress(<void*>&self.singleIsoMu24Pass_value)

        #print "making singleIsoMu24Prescale"
        self.singleIsoMu24Prescale_branch = the_tree.GetBranch("singleIsoMu24Prescale")
        #if not self.singleIsoMu24Prescale_branch and "singleIsoMu24Prescale" not in self.complained:
        if not self.singleIsoMu24Prescale_branch and "singleIsoMu24Prescale":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu24Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Prescale")
        else:
            self.singleIsoMu24Prescale_branch.SetAddress(<void*>&self.singleIsoMu24Prescale_value)

        #print "making singleIsoMu24eta2p1Group"
        self.singleIsoMu24eta2p1Group_branch = the_tree.GetBranch("singleIsoMu24eta2p1Group")
        #if not self.singleIsoMu24eta2p1Group_branch and "singleIsoMu24eta2p1Group" not in self.complained:
        if not self.singleIsoMu24eta2p1Group_branch and "singleIsoMu24eta2p1Group":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24eta2p1Group")
        else:
            self.singleIsoMu24eta2p1Group_branch.SetAddress(<void*>&self.singleIsoMu24eta2p1Group_value)

        #print "making singleIsoMu24eta2p1Pass"
        self.singleIsoMu24eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu24eta2p1Pass")
        #if not self.singleIsoMu24eta2p1Pass_branch and "singleIsoMu24eta2p1Pass" not in self.complained:
        if not self.singleIsoMu24eta2p1Pass_branch and "singleIsoMu24eta2p1Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24eta2p1Pass")
        else:
            self.singleIsoMu24eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu24eta2p1Pass_value)

        #print "making singleIsoMu24eta2p1Prescale"
        self.singleIsoMu24eta2p1Prescale_branch = the_tree.GetBranch("singleIsoMu24eta2p1Prescale")
        #if not self.singleIsoMu24eta2p1Prescale_branch and "singleIsoMu24eta2p1Prescale" not in self.complained:
        if not self.singleIsoMu24eta2p1Prescale_branch and "singleIsoMu24eta2p1Prescale":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24eta2p1Prescale")
        else:
            self.singleIsoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoMu24eta2p1Prescale_value)

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

        #print "making singleIsoTkMu22eta2p1Group"
        self.singleIsoTkMu22eta2p1Group_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Group")
        #if not self.singleIsoTkMu22eta2p1Group_branch and "singleIsoTkMu22eta2p1Group" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Group_branch and "singleIsoTkMu22eta2p1Group":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu22eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Group")
        else:
            self.singleIsoTkMu22eta2p1Group_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Group_value)

        #print "making singleIsoTkMu22eta2p1Pass"
        self.singleIsoTkMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Pass")
        #if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Pass")
        else:
            self.singleIsoTkMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Pass_value)

        #print "making singleIsoTkMu22eta2p1Prescale"
        self.singleIsoTkMu22eta2p1Prescale_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Prescale")
        #if not self.singleIsoTkMu22eta2p1Prescale_branch and "singleIsoTkMu22eta2p1Prescale" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Prescale_branch and "singleIsoTkMu22eta2p1Prescale":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu22eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Prescale")
        else:
            self.singleIsoTkMu22eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Prescale_value)

        #print "making singleIsoTkMu24Group"
        self.singleIsoTkMu24Group_branch = the_tree.GetBranch("singleIsoTkMu24Group")
        #if not self.singleIsoTkMu24Group_branch and "singleIsoTkMu24Group" not in self.complained:
        if not self.singleIsoTkMu24Group_branch and "singleIsoTkMu24Group":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu24Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Group")
        else:
            self.singleIsoTkMu24Group_branch.SetAddress(<void*>&self.singleIsoTkMu24Group_value)

        #print "making singleIsoTkMu24Pass"
        self.singleIsoTkMu24Pass_branch = the_tree.GetBranch("singleIsoTkMu24Pass")
        #if not self.singleIsoTkMu24Pass_branch and "singleIsoTkMu24Pass" not in self.complained:
        if not self.singleIsoTkMu24Pass_branch and "singleIsoTkMu24Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Pass")
        else:
            self.singleIsoTkMu24Pass_branch.SetAddress(<void*>&self.singleIsoTkMu24Pass_value)

        #print "making singleIsoTkMu24Prescale"
        self.singleIsoTkMu24Prescale_branch = the_tree.GetBranch("singleIsoTkMu24Prescale")
        #if not self.singleIsoTkMu24Prescale_branch and "singleIsoTkMu24Prescale" not in self.complained:
        if not self.singleIsoTkMu24Prescale_branch and "singleIsoTkMu24Prescale":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu24Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Prescale")
        else:
            self.singleIsoTkMu24Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu24Prescale_value)

        #print "making singleIsoTkMu24eta2p1Group"
        self.singleIsoTkMu24eta2p1Group_branch = the_tree.GetBranch("singleIsoTkMu24eta2p1Group")
        #if not self.singleIsoTkMu24eta2p1Group_branch and "singleIsoTkMu24eta2p1Group" not in self.complained:
        if not self.singleIsoTkMu24eta2p1Group_branch and "singleIsoTkMu24eta2p1Group":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24eta2p1Group")
        else:
            self.singleIsoTkMu24eta2p1Group_branch.SetAddress(<void*>&self.singleIsoTkMu24eta2p1Group_value)

        #print "making singleIsoTkMu24eta2p1Pass"
        self.singleIsoTkMu24eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu24eta2p1Pass")
        #if not self.singleIsoTkMu24eta2p1Pass_branch and "singleIsoTkMu24eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu24eta2p1Pass_branch and "singleIsoTkMu24eta2p1Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24eta2p1Pass")
        else:
            self.singleIsoTkMu24eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu24eta2p1Pass_value)

        #print "making singleIsoTkMu24eta2p1Prescale"
        self.singleIsoTkMu24eta2p1Prescale_branch = the_tree.GetBranch("singleIsoTkMu24eta2p1Prescale")
        #if not self.singleIsoTkMu24eta2p1Prescale_branch and "singleIsoTkMu24eta2p1Prescale" not in self.complained:
        if not self.singleIsoTkMu24eta2p1Prescale_branch and "singleIsoTkMu24eta2p1Prescale":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24eta2p1Prescale")
        else:
            self.singleIsoTkMu24eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoTkMu24eta2p1Prescale_value)

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

        #print "making singleMu19eta2p1LooseTau20Group"
        self.singleMu19eta2p1LooseTau20Group_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Group")
        #if not self.singleMu19eta2p1LooseTau20Group_branch and "singleMu19eta2p1LooseTau20Group" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Group_branch and "singleMu19eta2p1LooseTau20Group":
            warnings.warn( "MuTauTree: Expected branch singleMu19eta2p1LooseTau20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Group")
        else:
            self.singleMu19eta2p1LooseTau20Group_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Group_value)

        #print "making singleMu19eta2p1LooseTau20Pass"
        self.singleMu19eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Pass")
        #if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass":
            warnings.warn( "MuTauTree: Expected branch singleMu19eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Pass")
        else:
            self.singleMu19eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Pass_value)

        #print "making singleMu19eta2p1LooseTau20Prescale"
        self.singleMu19eta2p1LooseTau20Prescale_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Prescale")
        #if not self.singleMu19eta2p1LooseTau20Prescale_branch and "singleMu19eta2p1LooseTau20Prescale" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Prescale_branch and "singleMu19eta2p1LooseTau20Prescale":
            warnings.warn( "MuTauTree: Expected branch singleMu19eta2p1LooseTau20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Prescale")
        else:
            self.singleMu19eta2p1LooseTau20Prescale_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Prescale_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Group"
        self.singleMu19eta2p1LooseTau20singleL1Group_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Group")
        #if not self.singleMu19eta2p1LooseTau20singleL1Group_branch and "singleMu19eta2p1LooseTau20singleL1Group" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Group_branch and "singleMu19eta2p1LooseTau20singleL1Group":
            warnings.warn( "MuTauTree: Expected branch singleMu19eta2p1LooseTau20singleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Group")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Group_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Group_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Pass"
        self.singleMu19eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass":
            warnings.warn( "MuTauTree: Expected branch singleMu19eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Pass_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Prescale"
        self.singleMu19eta2p1LooseTau20singleL1Prescale_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Prescale")
        #if not self.singleMu19eta2p1LooseTau20singleL1Prescale_branch and "singleMu19eta2p1LooseTau20singleL1Prescale" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Prescale_branch and "singleMu19eta2p1LooseTau20singleL1Prescale":
            warnings.warn( "MuTauTree: Expected branch singleMu19eta2p1LooseTau20singleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Prescale")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Prescale_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Prescale_value)

        #print "making singleMu21eta2p1LooseTau20singleL1Group"
        self.singleMu21eta2p1LooseTau20singleL1Group_branch = the_tree.GetBranch("singleMu21eta2p1LooseTau20singleL1Group")
        #if not self.singleMu21eta2p1LooseTau20singleL1Group_branch and "singleMu21eta2p1LooseTau20singleL1Group" not in self.complained:
        if not self.singleMu21eta2p1LooseTau20singleL1Group_branch and "singleMu21eta2p1LooseTau20singleL1Group":
            warnings.warn( "MuTauTree: Expected branch singleMu21eta2p1LooseTau20singleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu21eta2p1LooseTau20singleL1Group")
        else:
            self.singleMu21eta2p1LooseTau20singleL1Group_branch.SetAddress(<void*>&self.singleMu21eta2p1LooseTau20singleL1Group_value)

        #print "making singleMu21eta2p1LooseTau20singleL1Pass"
        self.singleMu21eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu21eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu21eta2p1LooseTau20singleL1Pass_branch and "singleMu21eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu21eta2p1LooseTau20singleL1Pass_branch and "singleMu21eta2p1LooseTau20singleL1Pass":
            warnings.warn( "MuTauTree: Expected branch singleMu21eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu21eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu21eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu21eta2p1LooseTau20singleL1Pass_value)

        #print "making singleMu21eta2p1LooseTau20singleL1Prescale"
        self.singleMu21eta2p1LooseTau20singleL1Prescale_branch = the_tree.GetBranch("singleMu21eta2p1LooseTau20singleL1Prescale")
        #if not self.singleMu21eta2p1LooseTau20singleL1Prescale_branch and "singleMu21eta2p1LooseTau20singleL1Prescale" not in self.complained:
        if not self.singleMu21eta2p1LooseTau20singleL1Prescale_branch and "singleMu21eta2p1LooseTau20singleL1Prescale":
            warnings.warn( "MuTauTree: Expected branch singleMu21eta2p1LooseTau20singleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu21eta2p1LooseTau20singleL1Prescale")
        else:
            self.singleMu21eta2p1LooseTau20singleL1Prescale_branch.SetAddress(<void*>&self.singleMu21eta2p1LooseTau20singleL1Prescale_value)

        #print "making singleMu23SingleE12DZGroup"
        self.singleMu23SingleE12DZGroup_branch = the_tree.GetBranch("singleMu23SingleE12DZGroup")
        #if not self.singleMu23SingleE12DZGroup_branch and "singleMu23SingleE12DZGroup" not in self.complained:
        if not self.singleMu23SingleE12DZGroup_branch and "singleMu23SingleE12DZGroup":
            warnings.warn( "MuTauTree: Expected branch singleMu23SingleE12DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZGroup")
        else:
            self.singleMu23SingleE12DZGroup_branch.SetAddress(<void*>&self.singleMu23SingleE12DZGroup_value)

        #print "making singleMu23SingleE12DZPass"
        self.singleMu23SingleE12DZPass_branch = the_tree.GetBranch("singleMu23SingleE12DZPass")
        #if not self.singleMu23SingleE12DZPass_branch and "singleMu23SingleE12DZPass" not in self.complained:
        if not self.singleMu23SingleE12DZPass_branch and "singleMu23SingleE12DZPass":
            warnings.warn( "MuTauTree: Expected branch singleMu23SingleE12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZPass")
        else:
            self.singleMu23SingleE12DZPass_branch.SetAddress(<void*>&self.singleMu23SingleE12DZPass_value)

        #print "making singleMu23SingleE12DZPrescale"
        self.singleMu23SingleE12DZPrescale_branch = the_tree.GetBranch("singleMu23SingleE12DZPrescale")
        #if not self.singleMu23SingleE12DZPrescale_branch and "singleMu23SingleE12DZPrescale" not in self.complained:
        if not self.singleMu23SingleE12DZPrescale_branch and "singleMu23SingleE12DZPrescale":
            warnings.warn( "MuTauTree: Expected branch singleMu23SingleE12DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZPrescale")
        else:
            self.singleMu23SingleE12DZPrescale_branch.SetAddress(<void*>&self.singleMu23SingleE12DZPrescale_value)

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

        #print "making singleMu23SingleE8Group"
        self.singleMu23SingleE8Group_branch = the_tree.GetBranch("singleMu23SingleE8Group")
        #if not self.singleMu23SingleE8Group_branch and "singleMu23SingleE8Group" not in self.complained:
        if not self.singleMu23SingleE8Group_branch and "singleMu23SingleE8Group":
            warnings.warn( "MuTauTree: Expected branch singleMu23SingleE8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE8Group")
        else:
            self.singleMu23SingleE8Group_branch.SetAddress(<void*>&self.singleMu23SingleE8Group_value)

        #print "making singleMu23SingleE8Pass"
        self.singleMu23SingleE8Pass_branch = the_tree.GetBranch("singleMu23SingleE8Pass")
        #if not self.singleMu23SingleE8Pass_branch and "singleMu23SingleE8Pass" not in self.complained:
        if not self.singleMu23SingleE8Pass_branch and "singleMu23SingleE8Pass":
            warnings.warn( "MuTauTree: Expected branch singleMu23SingleE8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE8Pass")
        else:
            self.singleMu23SingleE8Pass_branch.SetAddress(<void*>&self.singleMu23SingleE8Pass_value)

        #print "making singleMu23SingleE8Prescale"
        self.singleMu23SingleE8Prescale_branch = the_tree.GetBranch("singleMu23SingleE8Prescale")
        #if not self.singleMu23SingleE8Prescale_branch and "singleMu23SingleE8Prescale" not in self.complained:
        if not self.singleMu23SingleE8Prescale_branch and "singleMu23SingleE8Prescale":
            warnings.warn( "MuTauTree: Expected branch singleMu23SingleE8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE8Prescale")
        else:
            self.singleMu23SingleE8Prescale_branch.SetAddress(<void*>&self.singleMu23SingleE8Prescale_value)

        #print "making singleMu8SingleE23DZGroup"
        self.singleMu8SingleE23DZGroup_branch = the_tree.GetBranch("singleMu8SingleE23DZGroup")
        #if not self.singleMu8SingleE23DZGroup_branch and "singleMu8SingleE23DZGroup" not in self.complained:
        if not self.singleMu8SingleE23DZGroup_branch and "singleMu8SingleE23DZGroup":
            warnings.warn( "MuTauTree: Expected branch singleMu8SingleE23DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZGroup")
        else:
            self.singleMu8SingleE23DZGroup_branch.SetAddress(<void*>&self.singleMu8SingleE23DZGroup_value)

        #print "making singleMu8SingleE23DZPass"
        self.singleMu8SingleE23DZPass_branch = the_tree.GetBranch("singleMu8SingleE23DZPass")
        #if not self.singleMu8SingleE23DZPass_branch and "singleMu8SingleE23DZPass" not in self.complained:
        if not self.singleMu8SingleE23DZPass_branch and "singleMu8SingleE23DZPass":
            warnings.warn( "MuTauTree: Expected branch singleMu8SingleE23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZPass")
        else:
            self.singleMu8SingleE23DZPass_branch.SetAddress(<void*>&self.singleMu8SingleE23DZPass_value)

        #print "making singleMu8SingleE23DZPrescale"
        self.singleMu8SingleE23DZPrescale_branch = the_tree.GetBranch("singleMu8SingleE23DZPrescale")
        #if not self.singleMu8SingleE23DZPrescale_branch and "singleMu8SingleE23DZPrescale" not in self.complained:
        if not self.singleMu8SingleE23DZPrescale_branch and "singleMu8SingleE23DZPrescale":
            warnings.warn( "MuTauTree: Expected branch singleMu8SingleE23DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZPrescale")
        else:
            self.singleMu8SingleE23DZPrescale_branch.SetAddress(<void*>&self.singleMu8SingleE23DZPrescale_value)

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

        #print "making singleTau140Group"
        self.singleTau140Group_branch = the_tree.GetBranch("singleTau140Group")
        #if not self.singleTau140Group_branch and "singleTau140Group" not in self.complained:
        if not self.singleTau140Group_branch and "singleTau140Group":
            warnings.warn( "MuTauTree: Expected branch singleTau140Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Group")
        else:
            self.singleTau140Group_branch.SetAddress(<void*>&self.singleTau140Group_value)

        #print "making singleTau140Pass"
        self.singleTau140Pass_branch = the_tree.GetBranch("singleTau140Pass")
        #if not self.singleTau140Pass_branch and "singleTau140Pass" not in self.complained:
        if not self.singleTau140Pass_branch and "singleTau140Pass":
            warnings.warn( "MuTauTree: Expected branch singleTau140Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Pass")
        else:
            self.singleTau140Pass_branch.SetAddress(<void*>&self.singleTau140Pass_value)

        #print "making singleTau140Prescale"
        self.singleTau140Prescale_branch = the_tree.GetBranch("singleTau140Prescale")
        #if not self.singleTau140Prescale_branch and "singleTau140Prescale" not in self.complained:
        if not self.singleTau140Prescale_branch and "singleTau140Prescale":
            warnings.warn( "MuTauTree: Expected branch singleTau140Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Prescale")
        else:
            self.singleTau140Prescale_branch.SetAddress(<void*>&self.singleTau140Prescale_value)

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

        #print "making tGenIsPrompt"
        self.tGenIsPrompt_branch = the_tree.GetBranch("tGenIsPrompt")
        #if not self.tGenIsPrompt_branch and "tGenIsPrompt" not in self.complained:
        if not self.tGenIsPrompt_branch and "tGenIsPrompt":
            warnings.warn( "MuTauTree: Expected branch tGenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenIsPrompt")
        else:
            self.tGenIsPrompt_branch.SetAddress(<void*>&self.tGenIsPrompt_value)

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

        #print "making tJetHadronFlavour"
        self.tJetHadronFlavour_branch = the_tree.GetBranch("tJetHadronFlavour")
        #if not self.tJetHadronFlavour_branch and "tJetHadronFlavour" not in self.complained:
        if not self.tJetHadronFlavour_branch and "tJetHadronFlavour":
            warnings.warn( "MuTauTree: Expected branch tJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetHadronFlavour")
        else:
            self.tJetHadronFlavour_branch.SetAddress(<void*>&self.tJetHadronFlavour_value)

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

        #print "making tMatchesDoubleTau32Filter"
        self.tMatchesDoubleTau32Filter_branch = the_tree.GetBranch("tMatchesDoubleTau32Filter")
        #if not self.tMatchesDoubleTau32Filter_branch and "tMatchesDoubleTau32Filter" not in self.complained:
        if not self.tMatchesDoubleTau32Filter_branch and "tMatchesDoubleTau32Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTau32Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTau32Filter")
        else:
            self.tMatchesDoubleTau32Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTau32Filter_value)

        #print "making tMatchesDoubleTau32Path"
        self.tMatchesDoubleTau32Path_branch = the_tree.GetBranch("tMatchesDoubleTau32Path")
        #if not self.tMatchesDoubleTau32Path_branch and "tMatchesDoubleTau32Path" not in self.complained:
        if not self.tMatchesDoubleTau32Path_branch and "tMatchesDoubleTau32Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTau32Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTau32Path")
        else:
            self.tMatchesDoubleTau32Path_branch.SetAddress(<void*>&self.tMatchesDoubleTau32Path_value)

        #print "making tMatchesDoubleTau35Filter"
        self.tMatchesDoubleTau35Filter_branch = the_tree.GetBranch("tMatchesDoubleTau35Filter")
        #if not self.tMatchesDoubleTau35Filter_branch and "tMatchesDoubleTau35Filter" not in self.complained:
        if not self.tMatchesDoubleTau35Filter_branch and "tMatchesDoubleTau35Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTau35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTau35Filter")
        else:
            self.tMatchesDoubleTau35Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTau35Filter_value)

        #print "making tMatchesDoubleTau35Path"
        self.tMatchesDoubleTau35Path_branch = the_tree.GetBranch("tMatchesDoubleTau35Path")
        #if not self.tMatchesDoubleTau35Path_branch and "tMatchesDoubleTau35Path" not in self.complained:
        if not self.tMatchesDoubleTau35Path_branch and "tMatchesDoubleTau35Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTau35Path")
        else:
            self.tMatchesDoubleTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleTau35Path_value)

        #print "making tMatchesDoubleTau40Filter"
        self.tMatchesDoubleTau40Filter_branch = the_tree.GetBranch("tMatchesDoubleTau40Filter")
        #if not self.tMatchesDoubleTau40Filter_branch and "tMatchesDoubleTau40Filter" not in self.complained:
        if not self.tMatchesDoubleTau40Filter_branch and "tMatchesDoubleTau40Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTau40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTau40Filter")
        else:
            self.tMatchesDoubleTau40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTau40Filter_value)

        #print "making tMatchesDoubleTau40Path"
        self.tMatchesDoubleTau40Path_branch = the_tree.GetBranch("tMatchesDoubleTau40Path")
        #if not self.tMatchesDoubleTau40Path_branch and "tMatchesDoubleTau40Path" not in self.complained:
        if not self.tMatchesDoubleTau40Path_branch and "tMatchesDoubleTau40Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTau40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTau40Path")
        else:
            self.tMatchesDoubleTau40Path_branch.SetAddress(<void*>&self.tMatchesDoubleTau40Path_value)

        #print "making tMatchesDoubleTauCmbIso35RegFilter"
        self.tMatchesDoubleTauCmbIso35RegFilter_branch = the_tree.GetBranch("tMatchesDoubleTauCmbIso35RegFilter")
        #if not self.tMatchesDoubleTauCmbIso35RegFilter_branch and "tMatchesDoubleTauCmbIso35RegFilter" not in self.complained:
        if not self.tMatchesDoubleTauCmbIso35RegFilter_branch and "tMatchesDoubleTauCmbIso35RegFilter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTauCmbIso35RegFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTauCmbIso35RegFilter")
        else:
            self.tMatchesDoubleTauCmbIso35RegFilter_branch.SetAddress(<void*>&self.tMatchesDoubleTauCmbIso35RegFilter_value)

        #print "making tMatchesDoubleTauCmbIso35RegPath"
        self.tMatchesDoubleTauCmbIso35RegPath_branch = the_tree.GetBranch("tMatchesDoubleTauCmbIso35RegPath")
        #if not self.tMatchesDoubleTauCmbIso35RegPath_branch and "tMatchesDoubleTauCmbIso35RegPath" not in self.complained:
        if not self.tMatchesDoubleTauCmbIso35RegPath_branch and "tMatchesDoubleTauCmbIso35RegPath":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTauCmbIso35RegPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTauCmbIso35RegPath")
        else:
            self.tMatchesDoubleTauCmbIso35RegPath_branch.SetAddress(<void*>&self.tMatchesDoubleTauCmbIso35RegPath_value)

        #print "making tMatchesDoubleTauCmbIso40Filter"
        self.tMatchesDoubleTauCmbIso40Filter_branch = the_tree.GetBranch("tMatchesDoubleTauCmbIso40Filter")
        #if not self.tMatchesDoubleTauCmbIso40Filter_branch and "tMatchesDoubleTauCmbIso40Filter" not in self.complained:
        if not self.tMatchesDoubleTauCmbIso40Filter_branch and "tMatchesDoubleTauCmbIso40Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTauCmbIso40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTauCmbIso40Filter")
        else:
            self.tMatchesDoubleTauCmbIso40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTauCmbIso40Filter_value)

        #print "making tMatchesDoubleTauCmbIso40Path"
        self.tMatchesDoubleTauCmbIso40Path_branch = the_tree.GetBranch("tMatchesDoubleTauCmbIso40Path")
        #if not self.tMatchesDoubleTauCmbIso40Path_branch and "tMatchesDoubleTauCmbIso40Path" not in self.complained:
        if not self.tMatchesDoubleTauCmbIso40Path_branch and "tMatchesDoubleTauCmbIso40Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTauCmbIso40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTauCmbIso40Path")
        else:
            self.tMatchesDoubleTauCmbIso40Path_branch.SetAddress(<void*>&self.tMatchesDoubleTauCmbIso40Path_value)

        #print "making tMatchesDoubleTauCmbIso40RegFilter"
        self.tMatchesDoubleTauCmbIso40RegFilter_branch = the_tree.GetBranch("tMatchesDoubleTauCmbIso40RegFilter")
        #if not self.tMatchesDoubleTauCmbIso40RegFilter_branch and "tMatchesDoubleTauCmbIso40RegFilter" not in self.complained:
        if not self.tMatchesDoubleTauCmbIso40RegFilter_branch and "tMatchesDoubleTauCmbIso40RegFilter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTauCmbIso40RegFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTauCmbIso40RegFilter")
        else:
            self.tMatchesDoubleTauCmbIso40RegFilter_branch.SetAddress(<void*>&self.tMatchesDoubleTauCmbIso40RegFilter_value)

        #print "making tMatchesDoubleTauCmbIso40RegPath"
        self.tMatchesDoubleTauCmbIso40RegPath_branch = the_tree.GetBranch("tMatchesDoubleTauCmbIso40RegPath")
        #if not self.tMatchesDoubleTauCmbIso40RegPath_branch and "tMatchesDoubleTauCmbIso40RegPath" not in self.complained:
        if not self.tMatchesDoubleTauCmbIso40RegPath_branch and "tMatchesDoubleTauCmbIso40RegPath":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTauCmbIso40RegPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTauCmbIso40RegPath")
        else:
            self.tMatchesDoubleTauCmbIso40RegPath_branch.SetAddress(<void*>&self.tMatchesDoubleTauCmbIso40RegPath_value)

        #print "making tMatchesEle24Tau20Filter"
        self.tMatchesEle24Tau20Filter_branch = the_tree.GetBranch("tMatchesEle24Tau20Filter")
        #if not self.tMatchesEle24Tau20Filter_branch and "tMatchesEle24Tau20Filter" not in self.complained:
        if not self.tMatchesEle24Tau20Filter_branch and "tMatchesEle24Tau20Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesEle24Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau20Filter")
        else:
            self.tMatchesEle24Tau20Filter_branch.SetAddress(<void*>&self.tMatchesEle24Tau20Filter_value)

        #print "making tMatchesEle24Tau20L1Filter"
        self.tMatchesEle24Tau20L1Filter_branch = the_tree.GetBranch("tMatchesEle24Tau20L1Filter")
        #if not self.tMatchesEle24Tau20L1Filter_branch and "tMatchesEle24Tau20L1Filter" not in self.complained:
        if not self.tMatchesEle24Tau20L1Filter_branch and "tMatchesEle24Tau20L1Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesEle24Tau20L1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau20L1Filter")
        else:
            self.tMatchesEle24Tau20L1Filter_branch.SetAddress(<void*>&self.tMatchesEle24Tau20L1Filter_value)

        #print "making tMatchesEle24Tau20L1Path"
        self.tMatchesEle24Tau20L1Path_branch = the_tree.GetBranch("tMatchesEle24Tau20L1Path")
        #if not self.tMatchesEle24Tau20L1Path_branch and "tMatchesEle24Tau20L1Path" not in self.complained:
        if not self.tMatchesEle24Tau20L1Path_branch and "tMatchesEle24Tau20L1Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesEle24Tau20L1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau20L1Path")
        else:
            self.tMatchesEle24Tau20L1Path_branch.SetAddress(<void*>&self.tMatchesEle24Tau20L1Path_value)

        #print "making tMatchesEle24Tau20Path"
        self.tMatchesEle24Tau20Path_branch = the_tree.GetBranch("tMatchesEle24Tau20Path")
        #if not self.tMatchesEle24Tau20Path_branch and "tMatchesEle24Tau20Path" not in self.complained:
        if not self.tMatchesEle24Tau20Path_branch and "tMatchesEle24Tau20Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesEle24Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau20Path")
        else:
            self.tMatchesEle24Tau20Path_branch.SetAddress(<void*>&self.tMatchesEle24Tau20Path_value)

        #print "making tMatchesEle24Tau30Filter"
        self.tMatchesEle24Tau30Filter_branch = the_tree.GetBranch("tMatchesEle24Tau30Filter")
        #if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter" not in self.complained:
        if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Filter")
        else:
            self.tMatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Filter_value)

        #print "making tMatchesEle24Tau30Path"
        self.tMatchesEle24Tau30Path_branch = the_tree.GetBranch("tMatchesEle24Tau30Path")
        #if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path" not in self.complained:
        if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Path")
        else:
            self.tMatchesEle24Tau30Path_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Path_value)

        #print "making tMatchesMu19Tau20Filter"
        self.tMatchesMu19Tau20Filter_branch = the_tree.GetBranch("tMatchesMu19Tau20Filter")
        #if not self.tMatchesMu19Tau20Filter_branch and "tMatchesMu19Tau20Filter" not in self.complained:
        if not self.tMatchesMu19Tau20Filter_branch and "tMatchesMu19Tau20Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesMu19Tau20Filter")
        else:
            self.tMatchesMu19Tau20Filter_branch.SetAddress(<void*>&self.tMatchesMu19Tau20Filter_value)

        #print "making tMatchesMu19Tau20Path"
        self.tMatchesMu19Tau20Path_branch = the_tree.GetBranch("tMatchesMu19Tau20Path")
        #if not self.tMatchesMu19Tau20Path_branch and "tMatchesMu19Tau20Path" not in self.complained:
        if not self.tMatchesMu19Tau20Path_branch and "tMatchesMu19Tau20Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesMu19Tau20Path")
        else:
            self.tMatchesMu19Tau20Path_branch.SetAddress(<void*>&self.tMatchesMu19Tau20Path_value)

        #print "making tMatchesMu19Tau20sL1Filter"
        self.tMatchesMu19Tau20sL1Filter_branch = the_tree.GetBranch("tMatchesMu19Tau20sL1Filter")
        #if not self.tMatchesMu19Tau20sL1Filter_branch and "tMatchesMu19Tau20sL1Filter" not in self.complained:
        if not self.tMatchesMu19Tau20sL1Filter_branch and "tMatchesMu19Tau20sL1Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesMu19Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesMu19Tau20sL1Filter")
        else:
            self.tMatchesMu19Tau20sL1Filter_branch.SetAddress(<void*>&self.tMatchesMu19Tau20sL1Filter_value)

        #print "making tMatchesMu19Tau20sL1Path"
        self.tMatchesMu19Tau20sL1Path_branch = the_tree.GetBranch("tMatchesMu19Tau20sL1Path")
        #if not self.tMatchesMu19Tau20sL1Path_branch and "tMatchesMu19Tau20sL1Path" not in self.complained:
        if not self.tMatchesMu19Tau20sL1Path_branch and "tMatchesMu19Tau20sL1Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesMu19Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesMu19Tau20sL1Path")
        else:
            self.tMatchesMu19Tau20sL1Path_branch.SetAddress(<void*>&self.tMatchesMu19Tau20sL1Path_value)

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

        #print "making tNChrgHadrIsolationCands"
        self.tNChrgHadrIsolationCands_branch = the_tree.GetBranch("tNChrgHadrIsolationCands")
        #if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands" not in self.complained:
        if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands":
            warnings.warn( "MuTauTree: Expected branch tNChrgHadrIsolationCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrIsolationCands")
        else:
            self.tNChrgHadrIsolationCands_branch.SetAddress(<void*>&self.tNChrgHadrIsolationCands_value)

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

        #print "making tZTTGenDR"
        self.tZTTGenDR_branch = the_tree.GetBranch("tZTTGenDR")
        #if not self.tZTTGenDR_branch and "tZTTGenDR" not in self.complained:
        if not self.tZTTGenDR_branch and "tZTTGenDR":
            warnings.warn( "MuTauTree: Expected branch tZTTGenDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenDR")
        else:
            self.tZTTGenDR_branch.SetAddress(<void*>&self.tZTTGenDR_value)

        #print "making tZTTGenEta"
        self.tZTTGenEta_branch = the_tree.GetBranch("tZTTGenEta")
        #if not self.tZTTGenEta_branch and "tZTTGenEta" not in self.complained:
        if not self.tZTTGenEta_branch and "tZTTGenEta":
            warnings.warn( "MuTauTree: Expected branch tZTTGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenEta")
        else:
            self.tZTTGenEta_branch.SetAddress(<void*>&self.tZTTGenEta_value)

        #print "making tZTTGenMatching"
        self.tZTTGenMatching_branch = the_tree.GetBranch("tZTTGenMatching")
        #if not self.tZTTGenMatching_branch and "tZTTGenMatching" not in self.complained:
        if not self.tZTTGenMatching_branch and "tZTTGenMatching":
            warnings.warn( "MuTauTree: Expected branch tZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenMatching")
        else:
            self.tZTTGenMatching_branch.SetAddress(<void*>&self.tZTTGenMatching_value)

        #print "making tZTTGenPhi"
        self.tZTTGenPhi_branch = the_tree.GetBranch("tZTTGenPhi")
        #if not self.tZTTGenPhi_branch and "tZTTGenPhi" not in self.complained:
        if not self.tZTTGenPhi_branch and "tZTTGenPhi":
            warnings.warn( "MuTauTree: Expected branch tZTTGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenPhi")
        else:
            self.tZTTGenPhi_branch.SetAddress(<void*>&self.tZTTGenPhi_value)

        #print "making tZTTGenPt"
        self.tZTTGenPt_branch = the_tree.GetBranch("tZTTGenPt")
        #if not self.tZTTGenPt_branch and "tZTTGenPt" not in self.complained:
        if not self.tZTTGenPt_branch and "tZTTGenPt":
            warnings.warn( "MuTauTree: Expected branch tZTTGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenPt")
        else:
            self.tZTTGenPt_branch.SetAddress(<void*>&self.tZTTGenPt_value)

        #print "making t_m_collinearmass"
        self.t_m_collinearmass_branch = the_tree.GetBranch("t_m_collinearmass")
        #if not self.t_m_collinearmass_branch and "t_m_collinearmass" not in self.complained:
        if not self.t_m_collinearmass_branch and "t_m_collinearmass":
            warnings.warn( "MuTauTree: Expected branch t_m_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_m_collinearmass")
        else:
            self.t_m_collinearmass_branch.SetAddress(<void*>&self.t_m_collinearmass_value)

        #print "making t_m_collinearmass_JetEnDown"
        self.t_m_collinearmass_JetEnDown_branch = the_tree.GetBranch("t_m_collinearmass_JetEnDown")
        #if not self.t_m_collinearmass_JetEnDown_branch and "t_m_collinearmass_JetEnDown" not in self.complained:
        if not self.t_m_collinearmass_JetEnDown_branch and "t_m_collinearmass_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch t_m_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_m_collinearmass_JetEnDown")
        else:
            self.t_m_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.t_m_collinearmass_JetEnDown_value)

        #print "making t_m_collinearmass_JetEnUp"
        self.t_m_collinearmass_JetEnUp_branch = the_tree.GetBranch("t_m_collinearmass_JetEnUp")
        #if not self.t_m_collinearmass_JetEnUp_branch and "t_m_collinearmass_JetEnUp" not in self.complained:
        if not self.t_m_collinearmass_JetEnUp_branch and "t_m_collinearmass_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch t_m_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_m_collinearmass_JetEnUp")
        else:
            self.t_m_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.t_m_collinearmass_JetEnUp_value)

        #print "making t_m_collinearmass_UnclusteredEnDown"
        self.t_m_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("t_m_collinearmass_UnclusteredEnDown")
        #if not self.t_m_collinearmass_UnclusteredEnDown_branch and "t_m_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.t_m_collinearmass_UnclusteredEnDown_branch and "t_m_collinearmass_UnclusteredEnDown":
            warnings.warn( "MuTauTree: Expected branch t_m_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_m_collinearmass_UnclusteredEnDown")
        else:
            self.t_m_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.t_m_collinearmass_UnclusteredEnDown_value)

        #print "making t_m_collinearmass_UnclusteredEnUp"
        self.t_m_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("t_m_collinearmass_UnclusteredEnUp")
        #if not self.t_m_collinearmass_UnclusteredEnUp_branch and "t_m_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.t_m_collinearmass_UnclusteredEnUp_branch and "t_m_collinearmass_UnclusteredEnUp":
            warnings.warn( "MuTauTree: Expected branch t_m_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t_m_collinearmass_UnclusteredEnUp")
        else:
            self.t_m_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.t_m_collinearmass_UnclusteredEnUp_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "MuTauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "MuTauTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "MuTauTree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "MuTauTree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

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

        #print "making vbfMass_JetAbsoluteFlavMapDown"
        self.vbfMass_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteFlavMapDown")
        #if not self.vbfMass_JetAbsoluteFlavMapDown_branch and "vbfMass_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteFlavMapDown_branch and "vbfMass_JetAbsoluteFlavMapDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteFlavMapDown")
        else:
            self.vbfMass_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteFlavMapDown_value)

        #print "making vbfMass_JetAbsoluteFlavMapUp"
        self.vbfMass_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteFlavMapUp")
        #if not self.vbfMass_JetAbsoluteFlavMapUp_branch and "vbfMass_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteFlavMapUp_branch and "vbfMass_JetAbsoluteFlavMapUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteFlavMapUp")
        else:
            self.vbfMass_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteFlavMapUp_value)

        #print "making vbfMass_JetAbsoluteMPFBiasDown"
        self.vbfMass_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteMPFBiasDown")
        #if not self.vbfMass_JetAbsoluteMPFBiasDown_branch and "vbfMass_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteMPFBiasDown_branch and "vbfMass_JetAbsoluteMPFBiasDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteMPFBiasDown")
        else:
            self.vbfMass_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteMPFBiasDown_value)

        #print "making vbfMass_JetAbsoluteMPFBiasUp"
        self.vbfMass_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteMPFBiasUp")
        #if not self.vbfMass_JetAbsoluteMPFBiasUp_branch and "vbfMass_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteMPFBiasUp_branch and "vbfMass_JetAbsoluteMPFBiasUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteMPFBiasUp")
        else:
            self.vbfMass_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteMPFBiasUp_value)

        #print "making vbfMass_JetAbsoluteScaleDown"
        self.vbfMass_JetAbsoluteScaleDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteScaleDown")
        #if not self.vbfMass_JetAbsoluteScaleDown_branch and "vbfMass_JetAbsoluteScaleDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteScaleDown_branch and "vbfMass_JetAbsoluteScaleDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteScaleDown")
        else:
            self.vbfMass_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteScaleDown_value)

        #print "making vbfMass_JetAbsoluteScaleUp"
        self.vbfMass_JetAbsoluteScaleUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteScaleUp")
        #if not self.vbfMass_JetAbsoluteScaleUp_branch and "vbfMass_JetAbsoluteScaleUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteScaleUp_branch and "vbfMass_JetAbsoluteScaleUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteScaleUp")
        else:
            self.vbfMass_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteScaleUp_value)

        #print "making vbfMass_JetAbsoluteStatDown"
        self.vbfMass_JetAbsoluteStatDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteStatDown")
        #if not self.vbfMass_JetAbsoluteStatDown_branch and "vbfMass_JetAbsoluteStatDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteStatDown_branch and "vbfMass_JetAbsoluteStatDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteStatDown")
        else:
            self.vbfMass_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteStatDown_value)

        #print "making vbfMass_JetAbsoluteStatUp"
        self.vbfMass_JetAbsoluteStatUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteStatUp")
        #if not self.vbfMass_JetAbsoluteStatUp_branch and "vbfMass_JetAbsoluteStatUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteStatUp_branch and "vbfMass_JetAbsoluteStatUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteStatUp")
        else:
            self.vbfMass_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteStatUp_value)

        #print "making vbfMass_JetClosureDown"
        self.vbfMass_JetClosureDown_branch = the_tree.GetBranch("vbfMass_JetClosureDown")
        #if not self.vbfMass_JetClosureDown_branch and "vbfMass_JetClosureDown" not in self.complained:
        if not self.vbfMass_JetClosureDown_branch and "vbfMass_JetClosureDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetClosureDown")
        else:
            self.vbfMass_JetClosureDown_branch.SetAddress(<void*>&self.vbfMass_JetClosureDown_value)

        #print "making vbfMass_JetClosureUp"
        self.vbfMass_JetClosureUp_branch = the_tree.GetBranch("vbfMass_JetClosureUp")
        #if not self.vbfMass_JetClosureUp_branch and "vbfMass_JetClosureUp" not in self.complained:
        if not self.vbfMass_JetClosureUp_branch and "vbfMass_JetClosureUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetClosureUp")
        else:
            self.vbfMass_JetClosureUp_branch.SetAddress(<void*>&self.vbfMass_JetClosureUp_value)

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

        #print "making vbfMass_JetFlavorQCDDown"
        self.vbfMass_JetFlavorQCDDown_branch = the_tree.GetBranch("vbfMass_JetFlavorQCDDown")
        #if not self.vbfMass_JetFlavorQCDDown_branch and "vbfMass_JetFlavorQCDDown" not in self.complained:
        if not self.vbfMass_JetFlavorQCDDown_branch and "vbfMass_JetFlavorQCDDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFlavorQCDDown")
        else:
            self.vbfMass_JetFlavorQCDDown_branch.SetAddress(<void*>&self.vbfMass_JetFlavorQCDDown_value)

        #print "making vbfMass_JetFlavorQCDUp"
        self.vbfMass_JetFlavorQCDUp_branch = the_tree.GetBranch("vbfMass_JetFlavorQCDUp")
        #if not self.vbfMass_JetFlavorQCDUp_branch and "vbfMass_JetFlavorQCDUp" not in self.complained:
        if not self.vbfMass_JetFlavorQCDUp_branch and "vbfMass_JetFlavorQCDUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFlavorQCDUp")
        else:
            self.vbfMass_JetFlavorQCDUp_branch.SetAddress(<void*>&self.vbfMass_JetFlavorQCDUp_value)

        #print "making vbfMass_JetFragmentationDown"
        self.vbfMass_JetFragmentationDown_branch = the_tree.GetBranch("vbfMass_JetFragmentationDown")
        #if not self.vbfMass_JetFragmentationDown_branch and "vbfMass_JetFragmentationDown" not in self.complained:
        if not self.vbfMass_JetFragmentationDown_branch and "vbfMass_JetFragmentationDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFragmentationDown")
        else:
            self.vbfMass_JetFragmentationDown_branch.SetAddress(<void*>&self.vbfMass_JetFragmentationDown_value)

        #print "making vbfMass_JetFragmentationUp"
        self.vbfMass_JetFragmentationUp_branch = the_tree.GetBranch("vbfMass_JetFragmentationUp")
        #if not self.vbfMass_JetFragmentationUp_branch and "vbfMass_JetFragmentationUp" not in self.complained:
        if not self.vbfMass_JetFragmentationUp_branch and "vbfMass_JetFragmentationUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFragmentationUp")
        else:
            self.vbfMass_JetFragmentationUp_branch.SetAddress(<void*>&self.vbfMass_JetFragmentationUp_value)

        #print "making vbfMass_JetPileUpDataMCDown"
        self.vbfMass_JetPileUpDataMCDown_branch = the_tree.GetBranch("vbfMass_JetPileUpDataMCDown")
        #if not self.vbfMass_JetPileUpDataMCDown_branch and "vbfMass_JetPileUpDataMCDown" not in self.complained:
        if not self.vbfMass_JetPileUpDataMCDown_branch and "vbfMass_JetPileUpDataMCDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpDataMCDown")
        else:
            self.vbfMass_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpDataMCDown_value)

        #print "making vbfMass_JetPileUpDataMCUp"
        self.vbfMass_JetPileUpDataMCUp_branch = the_tree.GetBranch("vbfMass_JetPileUpDataMCUp")
        #if not self.vbfMass_JetPileUpDataMCUp_branch and "vbfMass_JetPileUpDataMCUp" not in self.complained:
        if not self.vbfMass_JetPileUpDataMCUp_branch and "vbfMass_JetPileUpDataMCUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpDataMCUp")
        else:
            self.vbfMass_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpDataMCUp_value)

        #print "making vbfMass_JetPileUpPtBBDown"
        self.vbfMass_JetPileUpPtBBDown_branch = the_tree.GetBranch("vbfMass_JetPileUpPtBBDown")
        #if not self.vbfMass_JetPileUpPtBBDown_branch and "vbfMass_JetPileUpPtBBDown" not in self.complained:
        if not self.vbfMass_JetPileUpPtBBDown_branch and "vbfMass_JetPileUpPtBBDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtBBDown")
        else:
            self.vbfMass_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtBBDown_value)

        #print "making vbfMass_JetPileUpPtBBUp"
        self.vbfMass_JetPileUpPtBBUp_branch = the_tree.GetBranch("vbfMass_JetPileUpPtBBUp")
        #if not self.vbfMass_JetPileUpPtBBUp_branch and "vbfMass_JetPileUpPtBBUp" not in self.complained:
        if not self.vbfMass_JetPileUpPtBBUp_branch and "vbfMass_JetPileUpPtBBUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtBBUp")
        else:
            self.vbfMass_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtBBUp_value)

        #print "making vbfMass_JetPileUpPtEC1Down"
        self.vbfMass_JetPileUpPtEC1Down_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC1Down")
        #if not self.vbfMass_JetPileUpPtEC1Down_branch and "vbfMass_JetPileUpPtEC1Down" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC1Down_branch and "vbfMass_JetPileUpPtEC1Down":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC1Down")
        else:
            self.vbfMass_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC1Down_value)

        #print "making vbfMass_JetPileUpPtEC1Up"
        self.vbfMass_JetPileUpPtEC1Up_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC1Up")
        #if not self.vbfMass_JetPileUpPtEC1Up_branch and "vbfMass_JetPileUpPtEC1Up" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC1Up_branch and "vbfMass_JetPileUpPtEC1Up":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC1Up")
        else:
            self.vbfMass_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC1Up_value)

        #print "making vbfMass_JetPileUpPtEC2Down"
        self.vbfMass_JetPileUpPtEC2Down_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC2Down")
        #if not self.vbfMass_JetPileUpPtEC2Down_branch and "vbfMass_JetPileUpPtEC2Down" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC2Down_branch and "vbfMass_JetPileUpPtEC2Down":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC2Down")
        else:
            self.vbfMass_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC2Down_value)

        #print "making vbfMass_JetPileUpPtEC2Up"
        self.vbfMass_JetPileUpPtEC2Up_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC2Up")
        #if not self.vbfMass_JetPileUpPtEC2Up_branch and "vbfMass_JetPileUpPtEC2Up" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC2Up_branch and "vbfMass_JetPileUpPtEC2Up":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC2Up")
        else:
            self.vbfMass_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC2Up_value)

        #print "making vbfMass_JetPileUpPtHFDown"
        self.vbfMass_JetPileUpPtHFDown_branch = the_tree.GetBranch("vbfMass_JetPileUpPtHFDown")
        #if not self.vbfMass_JetPileUpPtHFDown_branch and "vbfMass_JetPileUpPtHFDown" not in self.complained:
        if not self.vbfMass_JetPileUpPtHFDown_branch and "vbfMass_JetPileUpPtHFDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtHFDown")
        else:
            self.vbfMass_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtHFDown_value)

        #print "making vbfMass_JetPileUpPtHFUp"
        self.vbfMass_JetPileUpPtHFUp_branch = the_tree.GetBranch("vbfMass_JetPileUpPtHFUp")
        #if not self.vbfMass_JetPileUpPtHFUp_branch and "vbfMass_JetPileUpPtHFUp" not in self.complained:
        if not self.vbfMass_JetPileUpPtHFUp_branch and "vbfMass_JetPileUpPtHFUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtHFUp")
        else:
            self.vbfMass_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtHFUp_value)

        #print "making vbfMass_JetPileUpPtRefDown"
        self.vbfMass_JetPileUpPtRefDown_branch = the_tree.GetBranch("vbfMass_JetPileUpPtRefDown")
        #if not self.vbfMass_JetPileUpPtRefDown_branch and "vbfMass_JetPileUpPtRefDown" not in self.complained:
        if not self.vbfMass_JetPileUpPtRefDown_branch and "vbfMass_JetPileUpPtRefDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtRefDown")
        else:
            self.vbfMass_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtRefDown_value)

        #print "making vbfMass_JetPileUpPtRefUp"
        self.vbfMass_JetPileUpPtRefUp_branch = the_tree.GetBranch("vbfMass_JetPileUpPtRefUp")
        #if not self.vbfMass_JetPileUpPtRefUp_branch and "vbfMass_JetPileUpPtRefUp" not in self.complained:
        if not self.vbfMass_JetPileUpPtRefUp_branch and "vbfMass_JetPileUpPtRefUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtRefUp")
        else:
            self.vbfMass_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtRefUp_value)

        #print "making vbfMass_JetRelativeBalDown"
        self.vbfMass_JetRelativeBalDown_branch = the_tree.GetBranch("vbfMass_JetRelativeBalDown")
        #if not self.vbfMass_JetRelativeBalDown_branch and "vbfMass_JetRelativeBalDown" not in self.complained:
        if not self.vbfMass_JetRelativeBalDown_branch and "vbfMass_JetRelativeBalDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeBalDown")
        else:
            self.vbfMass_JetRelativeBalDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeBalDown_value)

        #print "making vbfMass_JetRelativeBalUp"
        self.vbfMass_JetRelativeBalUp_branch = the_tree.GetBranch("vbfMass_JetRelativeBalUp")
        #if not self.vbfMass_JetRelativeBalUp_branch and "vbfMass_JetRelativeBalUp" not in self.complained:
        if not self.vbfMass_JetRelativeBalUp_branch and "vbfMass_JetRelativeBalUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeBalUp")
        else:
            self.vbfMass_JetRelativeBalUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeBalUp_value)

        #print "making vbfMass_JetRelativeFSRDown"
        self.vbfMass_JetRelativeFSRDown_branch = the_tree.GetBranch("vbfMass_JetRelativeFSRDown")
        #if not self.vbfMass_JetRelativeFSRDown_branch and "vbfMass_JetRelativeFSRDown" not in self.complained:
        if not self.vbfMass_JetRelativeFSRDown_branch and "vbfMass_JetRelativeFSRDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeFSRDown")
        else:
            self.vbfMass_JetRelativeFSRDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeFSRDown_value)

        #print "making vbfMass_JetRelativeFSRUp"
        self.vbfMass_JetRelativeFSRUp_branch = the_tree.GetBranch("vbfMass_JetRelativeFSRUp")
        #if not self.vbfMass_JetRelativeFSRUp_branch and "vbfMass_JetRelativeFSRUp" not in self.complained:
        if not self.vbfMass_JetRelativeFSRUp_branch and "vbfMass_JetRelativeFSRUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeFSRUp")
        else:
            self.vbfMass_JetRelativeFSRUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeFSRUp_value)

        #print "making vbfMass_JetRelativeJEREC1Down"
        self.vbfMass_JetRelativeJEREC1Down_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC1Down")
        #if not self.vbfMass_JetRelativeJEREC1Down_branch and "vbfMass_JetRelativeJEREC1Down" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC1Down_branch and "vbfMass_JetRelativeJEREC1Down":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC1Down")
        else:
            self.vbfMass_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC1Down_value)

        #print "making vbfMass_JetRelativeJEREC1Up"
        self.vbfMass_JetRelativeJEREC1Up_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC1Up")
        #if not self.vbfMass_JetRelativeJEREC1Up_branch and "vbfMass_JetRelativeJEREC1Up" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC1Up_branch and "vbfMass_JetRelativeJEREC1Up":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC1Up")
        else:
            self.vbfMass_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC1Up_value)

        #print "making vbfMass_JetRelativeJEREC2Down"
        self.vbfMass_JetRelativeJEREC2Down_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC2Down")
        #if not self.vbfMass_JetRelativeJEREC2Down_branch and "vbfMass_JetRelativeJEREC2Down" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC2Down_branch and "vbfMass_JetRelativeJEREC2Down":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC2Down")
        else:
            self.vbfMass_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC2Down_value)

        #print "making vbfMass_JetRelativeJEREC2Up"
        self.vbfMass_JetRelativeJEREC2Up_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC2Up")
        #if not self.vbfMass_JetRelativeJEREC2Up_branch and "vbfMass_JetRelativeJEREC2Up" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC2Up_branch and "vbfMass_JetRelativeJEREC2Up":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC2Up")
        else:
            self.vbfMass_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC2Up_value)

        #print "making vbfMass_JetRelativeJERHFDown"
        self.vbfMass_JetRelativeJERHFDown_branch = the_tree.GetBranch("vbfMass_JetRelativeJERHFDown")
        #if not self.vbfMass_JetRelativeJERHFDown_branch and "vbfMass_JetRelativeJERHFDown" not in self.complained:
        if not self.vbfMass_JetRelativeJERHFDown_branch and "vbfMass_JetRelativeJERHFDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJERHFDown")
        else:
            self.vbfMass_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJERHFDown_value)

        #print "making vbfMass_JetRelativeJERHFUp"
        self.vbfMass_JetRelativeJERHFUp_branch = the_tree.GetBranch("vbfMass_JetRelativeJERHFUp")
        #if not self.vbfMass_JetRelativeJERHFUp_branch and "vbfMass_JetRelativeJERHFUp" not in self.complained:
        if not self.vbfMass_JetRelativeJERHFUp_branch and "vbfMass_JetRelativeJERHFUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJERHFUp")
        else:
            self.vbfMass_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJERHFUp_value)

        #print "making vbfMass_JetRelativePtBBDown"
        self.vbfMass_JetRelativePtBBDown_branch = the_tree.GetBranch("vbfMass_JetRelativePtBBDown")
        #if not self.vbfMass_JetRelativePtBBDown_branch and "vbfMass_JetRelativePtBBDown" not in self.complained:
        if not self.vbfMass_JetRelativePtBBDown_branch and "vbfMass_JetRelativePtBBDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtBBDown")
        else:
            self.vbfMass_JetRelativePtBBDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtBBDown_value)

        #print "making vbfMass_JetRelativePtBBUp"
        self.vbfMass_JetRelativePtBBUp_branch = the_tree.GetBranch("vbfMass_JetRelativePtBBUp")
        #if not self.vbfMass_JetRelativePtBBUp_branch and "vbfMass_JetRelativePtBBUp" not in self.complained:
        if not self.vbfMass_JetRelativePtBBUp_branch and "vbfMass_JetRelativePtBBUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtBBUp")
        else:
            self.vbfMass_JetRelativePtBBUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtBBUp_value)

        #print "making vbfMass_JetRelativePtEC1Down"
        self.vbfMass_JetRelativePtEC1Down_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC1Down")
        #if not self.vbfMass_JetRelativePtEC1Down_branch and "vbfMass_JetRelativePtEC1Down" not in self.complained:
        if not self.vbfMass_JetRelativePtEC1Down_branch and "vbfMass_JetRelativePtEC1Down":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC1Down")
        else:
            self.vbfMass_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC1Down_value)

        #print "making vbfMass_JetRelativePtEC1Up"
        self.vbfMass_JetRelativePtEC1Up_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC1Up")
        #if not self.vbfMass_JetRelativePtEC1Up_branch and "vbfMass_JetRelativePtEC1Up" not in self.complained:
        if not self.vbfMass_JetRelativePtEC1Up_branch and "vbfMass_JetRelativePtEC1Up":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC1Up")
        else:
            self.vbfMass_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC1Up_value)

        #print "making vbfMass_JetRelativePtEC2Down"
        self.vbfMass_JetRelativePtEC2Down_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC2Down")
        #if not self.vbfMass_JetRelativePtEC2Down_branch and "vbfMass_JetRelativePtEC2Down" not in self.complained:
        if not self.vbfMass_JetRelativePtEC2Down_branch and "vbfMass_JetRelativePtEC2Down":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC2Down")
        else:
            self.vbfMass_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC2Down_value)

        #print "making vbfMass_JetRelativePtEC2Up"
        self.vbfMass_JetRelativePtEC2Up_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC2Up")
        #if not self.vbfMass_JetRelativePtEC2Up_branch and "vbfMass_JetRelativePtEC2Up" not in self.complained:
        if not self.vbfMass_JetRelativePtEC2Up_branch and "vbfMass_JetRelativePtEC2Up":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC2Up")
        else:
            self.vbfMass_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC2Up_value)

        #print "making vbfMass_JetRelativePtHFDown"
        self.vbfMass_JetRelativePtHFDown_branch = the_tree.GetBranch("vbfMass_JetRelativePtHFDown")
        #if not self.vbfMass_JetRelativePtHFDown_branch and "vbfMass_JetRelativePtHFDown" not in self.complained:
        if not self.vbfMass_JetRelativePtHFDown_branch and "vbfMass_JetRelativePtHFDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtHFDown")
        else:
            self.vbfMass_JetRelativePtHFDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtHFDown_value)

        #print "making vbfMass_JetRelativePtHFUp"
        self.vbfMass_JetRelativePtHFUp_branch = the_tree.GetBranch("vbfMass_JetRelativePtHFUp")
        #if not self.vbfMass_JetRelativePtHFUp_branch and "vbfMass_JetRelativePtHFUp" not in self.complained:
        if not self.vbfMass_JetRelativePtHFUp_branch and "vbfMass_JetRelativePtHFUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtHFUp")
        else:
            self.vbfMass_JetRelativePtHFUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtHFUp_value)

        #print "making vbfMass_JetRelativeStatECDown"
        self.vbfMass_JetRelativeStatECDown_branch = the_tree.GetBranch("vbfMass_JetRelativeStatECDown")
        #if not self.vbfMass_JetRelativeStatECDown_branch and "vbfMass_JetRelativeStatECDown" not in self.complained:
        if not self.vbfMass_JetRelativeStatECDown_branch and "vbfMass_JetRelativeStatECDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatECDown")
        else:
            self.vbfMass_JetRelativeStatECDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatECDown_value)

        #print "making vbfMass_JetRelativeStatECUp"
        self.vbfMass_JetRelativeStatECUp_branch = the_tree.GetBranch("vbfMass_JetRelativeStatECUp")
        #if not self.vbfMass_JetRelativeStatECUp_branch and "vbfMass_JetRelativeStatECUp" not in self.complained:
        if not self.vbfMass_JetRelativeStatECUp_branch and "vbfMass_JetRelativeStatECUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatECUp")
        else:
            self.vbfMass_JetRelativeStatECUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatECUp_value)

        #print "making vbfMass_JetRelativeStatFSRDown"
        self.vbfMass_JetRelativeStatFSRDown_branch = the_tree.GetBranch("vbfMass_JetRelativeStatFSRDown")
        #if not self.vbfMass_JetRelativeStatFSRDown_branch and "vbfMass_JetRelativeStatFSRDown" not in self.complained:
        if not self.vbfMass_JetRelativeStatFSRDown_branch and "vbfMass_JetRelativeStatFSRDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatFSRDown")
        else:
            self.vbfMass_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatFSRDown_value)

        #print "making vbfMass_JetRelativeStatFSRUp"
        self.vbfMass_JetRelativeStatFSRUp_branch = the_tree.GetBranch("vbfMass_JetRelativeStatFSRUp")
        #if not self.vbfMass_JetRelativeStatFSRUp_branch and "vbfMass_JetRelativeStatFSRUp" not in self.complained:
        if not self.vbfMass_JetRelativeStatFSRUp_branch and "vbfMass_JetRelativeStatFSRUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatFSRUp")
        else:
            self.vbfMass_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatFSRUp_value)

        #print "making vbfMass_JetRelativeStatHFDown"
        self.vbfMass_JetRelativeStatHFDown_branch = the_tree.GetBranch("vbfMass_JetRelativeStatHFDown")
        #if not self.vbfMass_JetRelativeStatHFDown_branch and "vbfMass_JetRelativeStatHFDown" not in self.complained:
        if not self.vbfMass_JetRelativeStatHFDown_branch and "vbfMass_JetRelativeStatHFDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatHFDown")
        else:
            self.vbfMass_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatHFDown_value)

        #print "making vbfMass_JetRelativeStatHFUp"
        self.vbfMass_JetRelativeStatHFUp_branch = the_tree.GetBranch("vbfMass_JetRelativeStatHFUp")
        #if not self.vbfMass_JetRelativeStatHFUp_branch and "vbfMass_JetRelativeStatHFUp" not in self.complained:
        if not self.vbfMass_JetRelativeStatHFUp_branch and "vbfMass_JetRelativeStatHFUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatHFUp")
        else:
            self.vbfMass_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatHFUp_value)

        #print "making vbfMass_JetSinglePionECALDown"
        self.vbfMass_JetSinglePionECALDown_branch = the_tree.GetBranch("vbfMass_JetSinglePionECALDown")
        #if not self.vbfMass_JetSinglePionECALDown_branch and "vbfMass_JetSinglePionECALDown" not in self.complained:
        if not self.vbfMass_JetSinglePionECALDown_branch and "vbfMass_JetSinglePionECALDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionECALDown")
        else:
            self.vbfMass_JetSinglePionECALDown_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionECALDown_value)

        #print "making vbfMass_JetSinglePionECALUp"
        self.vbfMass_JetSinglePionECALUp_branch = the_tree.GetBranch("vbfMass_JetSinglePionECALUp")
        #if not self.vbfMass_JetSinglePionECALUp_branch and "vbfMass_JetSinglePionECALUp" not in self.complained:
        if not self.vbfMass_JetSinglePionECALUp_branch and "vbfMass_JetSinglePionECALUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionECALUp")
        else:
            self.vbfMass_JetSinglePionECALUp_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionECALUp_value)

        #print "making vbfMass_JetSinglePionHCALDown"
        self.vbfMass_JetSinglePionHCALDown_branch = the_tree.GetBranch("vbfMass_JetSinglePionHCALDown")
        #if not self.vbfMass_JetSinglePionHCALDown_branch and "vbfMass_JetSinglePionHCALDown" not in self.complained:
        if not self.vbfMass_JetSinglePionHCALDown_branch and "vbfMass_JetSinglePionHCALDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionHCALDown")
        else:
            self.vbfMass_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionHCALDown_value)

        #print "making vbfMass_JetSinglePionHCALUp"
        self.vbfMass_JetSinglePionHCALUp_branch = the_tree.GetBranch("vbfMass_JetSinglePionHCALUp")
        #if not self.vbfMass_JetSinglePionHCALUp_branch and "vbfMass_JetSinglePionHCALUp" not in self.complained:
        if not self.vbfMass_JetSinglePionHCALUp_branch and "vbfMass_JetSinglePionHCALUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionHCALUp")
        else:
            self.vbfMass_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionHCALUp_value)

        #print "making vbfMass_JetSubTotalAbsoluteDown"
        self.vbfMass_JetSubTotalAbsoluteDown_branch = the_tree.GetBranch("vbfMass_JetSubTotalAbsoluteDown")
        #if not self.vbfMass_JetSubTotalAbsoluteDown_branch and "vbfMass_JetSubTotalAbsoluteDown" not in self.complained:
        if not self.vbfMass_JetSubTotalAbsoluteDown_branch and "vbfMass_JetSubTotalAbsoluteDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSubTotalAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalAbsoluteDown")
        else:
            self.vbfMass_JetSubTotalAbsoluteDown_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalAbsoluteDown_value)

        #print "making vbfMass_JetSubTotalAbsoluteUp"
        self.vbfMass_JetSubTotalAbsoluteUp_branch = the_tree.GetBranch("vbfMass_JetSubTotalAbsoluteUp")
        #if not self.vbfMass_JetSubTotalAbsoluteUp_branch and "vbfMass_JetSubTotalAbsoluteUp" not in self.complained:
        if not self.vbfMass_JetSubTotalAbsoluteUp_branch and "vbfMass_JetSubTotalAbsoluteUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSubTotalAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalAbsoluteUp")
        else:
            self.vbfMass_JetSubTotalAbsoluteUp_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalAbsoluteUp_value)

        #print "making vbfMass_JetSubTotalMCDown"
        self.vbfMass_JetSubTotalMCDown_branch = the_tree.GetBranch("vbfMass_JetSubTotalMCDown")
        #if not self.vbfMass_JetSubTotalMCDown_branch and "vbfMass_JetSubTotalMCDown" not in self.complained:
        if not self.vbfMass_JetSubTotalMCDown_branch and "vbfMass_JetSubTotalMCDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSubTotalMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalMCDown")
        else:
            self.vbfMass_JetSubTotalMCDown_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalMCDown_value)

        #print "making vbfMass_JetSubTotalMCUp"
        self.vbfMass_JetSubTotalMCUp_branch = the_tree.GetBranch("vbfMass_JetSubTotalMCUp")
        #if not self.vbfMass_JetSubTotalMCUp_branch and "vbfMass_JetSubTotalMCUp" not in self.complained:
        if not self.vbfMass_JetSubTotalMCUp_branch and "vbfMass_JetSubTotalMCUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSubTotalMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalMCUp")
        else:
            self.vbfMass_JetSubTotalMCUp_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalMCUp_value)

        #print "making vbfMass_JetSubTotalPileUpDown"
        self.vbfMass_JetSubTotalPileUpDown_branch = the_tree.GetBranch("vbfMass_JetSubTotalPileUpDown")
        #if not self.vbfMass_JetSubTotalPileUpDown_branch and "vbfMass_JetSubTotalPileUpDown" not in self.complained:
        if not self.vbfMass_JetSubTotalPileUpDown_branch and "vbfMass_JetSubTotalPileUpDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSubTotalPileUpDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalPileUpDown")
        else:
            self.vbfMass_JetSubTotalPileUpDown_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalPileUpDown_value)

        #print "making vbfMass_JetSubTotalPileUpUp"
        self.vbfMass_JetSubTotalPileUpUp_branch = the_tree.GetBranch("vbfMass_JetSubTotalPileUpUp")
        #if not self.vbfMass_JetSubTotalPileUpUp_branch and "vbfMass_JetSubTotalPileUpUp" not in self.complained:
        if not self.vbfMass_JetSubTotalPileUpUp_branch and "vbfMass_JetSubTotalPileUpUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSubTotalPileUpUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalPileUpUp")
        else:
            self.vbfMass_JetSubTotalPileUpUp_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalPileUpUp_value)

        #print "making vbfMass_JetSubTotalPtDown"
        self.vbfMass_JetSubTotalPtDown_branch = the_tree.GetBranch("vbfMass_JetSubTotalPtDown")
        #if not self.vbfMass_JetSubTotalPtDown_branch and "vbfMass_JetSubTotalPtDown" not in self.complained:
        if not self.vbfMass_JetSubTotalPtDown_branch and "vbfMass_JetSubTotalPtDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSubTotalPtDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalPtDown")
        else:
            self.vbfMass_JetSubTotalPtDown_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalPtDown_value)

        #print "making vbfMass_JetSubTotalPtUp"
        self.vbfMass_JetSubTotalPtUp_branch = the_tree.GetBranch("vbfMass_JetSubTotalPtUp")
        #if not self.vbfMass_JetSubTotalPtUp_branch and "vbfMass_JetSubTotalPtUp" not in self.complained:
        if not self.vbfMass_JetSubTotalPtUp_branch and "vbfMass_JetSubTotalPtUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSubTotalPtUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalPtUp")
        else:
            self.vbfMass_JetSubTotalPtUp_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalPtUp_value)

        #print "making vbfMass_JetSubTotalRelativeDown"
        self.vbfMass_JetSubTotalRelativeDown_branch = the_tree.GetBranch("vbfMass_JetSubTotalRelativeDown")
        #if not self.vbfMass_JetSubTotalRelativeDown_branch and "vbfMass_JetSubTotalRelativeDown" not in self.complained:
        if not self.vbfMass_JetSubTotalRelativeDown_branch and "vbfMass_JetSubTotalRelativeDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSubTotalRelativeDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalRelativeDown")
        else:
            self.vbfMass_JetSubTotalRelativeDown_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalRelativeDown_value)

        #print "making vbfMass_JetSubTotalRelativeUp"
        self.vbfMass_JetSubTotalRelativeUp_branch = the_tree.GetBranch("vbfMass_JetSubTotalRelativeUp")
        #if not self.vbfMass_JetSubTotalRelativeUp_branch and "vbfMass_JetSubTotalRelativeUp" not in self.complained:
        if not self.vbfMass_JetSubTotalRelativeUp_branch and "vbfMass_JetSubTotalRelativeUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSubTotalRelativeUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalRelativeUp")
        else:
            self.vbfMass_JetSubTotalRelativeUp_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalRelativeUp_value)

        #print "making vbfMass_JetSubTotalScaleDown"
        self.vbfMass_JetSubTotalScaleDown_branch = the_tree.GetBranch("vbfMass_JetSubTotalScaleDown")
        #if not self.vbfMass_JetSubTotalScaleDown_branch and "vbfMass_JetSubTotalScaleDown" not in self.complained:
        if not self.vbfMass_JetSubTotalScaleDown_branch and "vbfMass_JetSubTotalScaleDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSubTotalScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalScaleDown")
        else:
            self.vbfMass_JetSubTotalScaleDown_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalScaleDown_value)

        #print "making vbfMass_JetSubTotalScaleUp"
        self.vbfMass_JetSubTotalScaleUp_branch = the_tree.GetBranch("vbfMass_JetSubTotalScaleUp")
        #if not self.vbfMass_JetSubTotalScaleUp_branch and "vbfMass_JetSubTotalScaleUp" not in self.complained:
        if not self.vbfMass_JetSubTotalScaleUp_branch and "vbfMass_JetSubTotalScaleUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetSubTotalScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalScaleUp")
        else:
            self.vbfMass_JetSubTotalScaleUp_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalScaleUp_value)

        #print "making vbfMass_JetTimePtEtaDown"
        self.vbfMass_JetTimePtEtaDown_branch = the_tree.GetBranch("vbfMass_JetTimePtEtaDown")
        #if not self.vbfMass_JetTimePtEtaDown_branch and "vbfMass_JetTimePtEtaDown" not in self.complained:
        if not self.vbfMass_JetTimePtEtaDown_branch and "vbfMass_JetTimePtEtaDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTimePtEtaDown")
        else:
            self.vbfMass_JetTimePtEtaDown_branch.SetAddress(<void*>&self.vbfMass_JetTimePtEtaDown_value)

        #print "making vbfMass_JetTimePtEtaUp"
        self.vbfMass_JetTimePtEtaUp_branch = the_tree.GetBranch("vbfMass_JetTimePtEtaUp")
        #if not self.vbfMass_JetTimePtEtaUp_branch and "vbfMass_JetTimePtEtaUp" not in self.complained:
        if not self.vbfMass_JetTimePtEtaUp_branch and "vbfMass_JetTimePtEtaUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTimePtEtaUp")
        else:
            self.vbfMass_JetTimePtEtaUp_branch.SetAddress(<void*>&self.vbfMass_JetTimePtEtaUp_value)

        #print "making vbfMass_JetTotalDown"
        self.vbfMass_JetTotalDown_branch = the_tree.GetBranch("vbfMass_JetTotalDown")
        #if not self.vbfMass_JetTotalDown_branch and "vbfMass_JetTotalDown" not in self.complained:
        if not self.vbfMass_JetTotalDown_branch and "vbfMass_JetTotalDown":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTotalDown")
        else:
            self.vbfMass_JetTotalDown_branch.SetAddress(<void*>&self.vbfMass_JetTotalDown_value)

        #print "making vbfMass_JetTotalUp"
        self.vbfMass_JetTotalUp_branch = the_tree.GetBranch("vbfMass_JetTotalUp")
        #if not self.vbfMass_JetTotalUp_branch and "vbfMass_JetTotalUp" not in self.complained:
        if not self.vbfMass_JetTotalUp_branch and "vbfMass_JetTotalUp":
            warnings.warn( "MuTauTree: Expected branch vbfMass_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTotalUp")
        else:
            self.vbfMass_JetTotalUp_branch.SetAddress(<void*>&self.vbfMass_JetTotalUp_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "MuTauTree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets20_JetEnDown"
        self.vbfNJets20_JetEnDown_branch = the_tree.GetBranch("vbfNJets20_JetEnDown")
        #if not self.vbfNJets20_JetEnDown_branch and "vbfNJets20_JetEnDown" not in self.complained:
        if not self.vbfNJets20_JetEnDown_branch and "vbfNJets20_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfNJets20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20_JetEnDown")
        else:
            self.vbfNJets20_JetEnDown_branch.SetAddress(<void*>&self.vbfNJets20_JetEnDown_value)

        #print "making vbfNJets20_JetEnUp"
        self.vbfNJets20_JetEnUp_branch = the_tree.GetBranch("vbfNJets20_JetEnUp")
        #if not self.vbfNJets20_JetEnUp_branch and "vbfNJets20_JetEnUp" not in self.complained:
        if not self.vbfNJets20_JetEnUp_branch and "vbfNJets20_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfNJets20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20_JetEnUp")
        else:
            self.vbfNJets20_JetEnUp_branch.SetAddress(<void*>&self.vbfNJets20_JetEnUp_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "MuTauTree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfNJets30_JetEnDown"
        self.vbfNJets30_JetEnDown_branch = the_tree.GetBranch("vbfNJets30_JetEnDown")
        #if not self.vbfNJets30_JetEnDown_branch and "vbfNJets30_JetEnDown" not in self.complained:
        if not self.vbfNJets30_JetEnDown_branch and "vbfNJets30_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch vbfNJets30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30_JetEnDown")
        else:
            self.vbfNJets30_JetEnDown_branch.SetAddress(<void*>&self.vbfNJets30_JetEnDown_value)

        #print "making vbfNJets30_JetEnUp"
        self.vbfNJets30_JetEnUp_branch = the_tree.GetBranch("vbfNJets30_JetEnUp")
        #if not self.vbfNJets30_JetEnUp_branch and "vbfNJets30_JetEnUp" not in self.complained:
        if not self.vbfNJets30_JetEnUp_branch and "vbfNJets30_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch vbfNJets30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30_JetEnUp")
        else:
            self.vbfNJets30_JetEnUp_branch.SetAddress(<void*>&self.vbfNJets30_JetEnUp_value)

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

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "MuTauTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "MuTauTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

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

    property Ele45L1JetTauSeededGroup:
        def __get__(self):
            self.Ele45L1JetTauSeededGroup_branch.GetEntry(self.localentry, 0)
            return self.Ele45L1JetTauSeededGroup_value

    property Ele45L1JetTauSeededPass:
        def __get__(self):
            self.Ele45L1JetTauSeededPass_branch.GetEntry(self.localentry, 0)
            return self.Ele45L1JetTauSeededPass_value

    property Ele45L1JetTauSeededPrescale:
        def __get__(self):
            self.Ele45L1JetTauSeededPrescale_branch.GetEntry(self.localentry, 0)
            return self.Ele45L1JetTauSeededPrescale_value

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

    property jet1PtJESClosure_Down:
        def __get__(self):
            self.jet1PtJESClosure_Down_branch.GetEntry(self.localentry, 0)
            return self.jet1PtJESClosure_Down_value

    property jet1PtJESClosure_Up:
        def __get__(self):
            self.jet1PtJESClosure_Up_branch.GetEntry(self.localentry, 0)
            return self.jet1PtJESClosure_Up_value

    property jet1PtJESTotal_Down:
        def __get__(self):
            self.jet1PtJESTotal_Down_branch.GetEntry(self.localentry, 0)
            return self.jet1PtJESTotal_Down_value

    property jet1PtJESTotal_Up:
        def __get__(self):
            self.jet1PtJESTotal_Up_branch.GetEntry(self.localentry, 0)
            return self.jet1PtJESTotal_Up_value

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

    property jet2PtJESClosure_Down:
        def __get__(self):
            self.jet2PtJESClosure_Down_branch.GetEntry(self.localentry, 0)
            return self.jet2PtJESClosure_Down_value

    property jet2PtJESClosure_Up:
        def __get__(self):
            self.jet2PtJESClosure_Up_branch.GetEntry(self.localentry, 0)
            return self.jet2PtJESClosure_Up_value

    property jet2PtJESTotal_Down:
        def __get__(self):
            self.jet2PtJESTotal_Down_branch.GetEntry(self.localentry, 0)
            return self.jet2PtJESTotal_Down_value

    property jet2PtJESTotal_Up:
        def __get__(self):
            self.jet2PtJESTotal_Up_branch.GetEntry(self.localentry, 0)
            return self.jet2PtJESTotal_Up_value

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

    property jetVeto30_JetAbsoluteFlavMapDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteFlavMapDown_value

    property jetVeto30_JetAbsoluteFlavMapUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteFlavMapUp_value

    property jetVeto30_JetAbsoluteMPFBiasDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteMPFBiasDown_value

    property jetVeto30_JetAbsoluteMPFBiasUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteMPFBiasUp_value

    property jetVeto30_JetAbsoluteScaleDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteScaleDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteScaleDown_value

    property jetVeto30_JetAbsoluteScaleUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteScaleUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteScaleUp_value

    property jetVeto30_JetAbsoluteStatDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteStatDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteStatDown_value

    property jetVeto30_JetAbsoluteStatUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteStatUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteStatUp_value

    property jetVeto30_JetClosureDown:
        def __get__(self):
            self.jetVeto30_JetClosureDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetClosureDown_value

    property jetVeto30_JetClosureUp:
        def __get__(self):
            self.jetVeto30_JetClosureUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetClosureUp_value

    property jetVeto30_JetEnDown:
        def __get__(self):
            self.jetVeto30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnDown_value

    property jetVeto30_JetEnUp:
        def __get__(self):
            self.jetVeto30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnUp_value

    property jetVeto30_JetFlavorQCDDown:
        def __get__(self):
            self.jetVeto30_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFlavorQCDDown_value

    property jetVeto30_JetFlavorQCDUp:
        def __get__(self):
            self.jetVeto30_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFlavorQCDUp_value

    property jetVeto30_JetFragmentationDown:
        def __get__(self):
            self.jetVeto30_JetFragmentationDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFragmentationDown_value

    property jetVeto30_JetFragmentationUp:
        def __get__(self):
            self.jetVeto30_JetFragmentationUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFragmentationUp_value

    property jetVeto30_JetPileUpDataMCDown:
        def __get__(self):
            self.jetVeto30_JetPileUpDataMCDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpDataMCDown_value

    property jetVeto30_JetPileUpDataMCUp:
        def __get__(self):
            self.jetVeto30_JetPileUpDataMCUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpDataMCUp_value

    property jetVeto30_JetPileUpPtBBDown:
        def __get__(self):
            self.jetVeto30_JetPileUpPtBBDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtBBDown_value

    property jetVeto30_JetPileUpPtBBUp:
        def __get__(self):
            self.jetVeto30_JetPileUpPtBBUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtBBUp_value

    property jetVeto30_JetPileUpPtEC1Down:
        def __get__(self):
            self.jetVeto30_JetPileUpPtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtEC1Down_value

    property jetVeto30_JetPileUpPtEC1Up:
        def __get__(self):
            self.jetVeto30_JetPileUpPtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtEC1Up_value

    property jetVeto30_JetPileUpPtEC2Down:
        def __get__(self):
            self.jetVeto30_JetPileUpPtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtEC2Down_value

    property jetVeto30_JetPileUpPtEC2Up:
        def __get__(self):
            self.jetVeto30_JetPileUpPtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtEC2Up_value

    property jetVeto30_JetPileUpPtHFDown:
        def __get__(self):
            self.jetVeto30_JetPileUpPtHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtHFDown_value

    property jetVeto30_JetPileUpPtHFUp:
        def __get__(self):
            self.jetVeto30_JetPileUpPtHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtHFUp_value

    property jetVeto30_JetPileUpPtRefDown:
        def __get__(self):
            self.jetVeto30_JetPileUpPtRefDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtRefDown_value

    property jetVeto30_JetPileUpPtRefUp:
        def __get__(self):
            self.jetVeto30_JetPileUpPtRefUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtRefUp_value

    property jetVeto30_JetRelativeBalDown:
        def __get__(self):
            self.jetVeto30_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeBalDown_value

    property jetVeto30_JetRelativeBalUp:
        def __get__(self):
            self.jetVeto30_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeBalUp_value

    property jetVeto30_JetRelativeFSRDown:
        def __get__(self):
            self.jetVeto30_JetRelativeFSRDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeFSRDown_value

    property jetVeto30_JetRelativeFSRUp:
        def __get__(self):
            self.jetVeto30_JetRelativeFSRUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeFSRUp_value

    property jetVeto30_JetRelativeJEREC1Down:
        def __get__(self):
            self.jetVeto30_JetRelativeJEREC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJEREC1Down_value

    property jetVeto30_JetRelativeJEREC1Up:
        def __get__(self):
            self.jetVeto30_JetRelativeJEREC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJEREC1Up_value

    property jetVeto30_JetRelativeJEREC2Down:
        def __get__(self):
            self.jetVeto30_JetRelativeJEREC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJEREC2Down_value

    property jetVeto30_JetRelativeJEREC2Up:
        def __get__(self):
            self.jetVeto30_JetRelativeJEREC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJEREC2Up_value

    property jetVeto30_JetRelativeJERHFDown:
        def __get__(self):
            self.jetVeto30_JetRelativeJERHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJERHFDown_value

    property jetVeto30_JetRelativeJERHFUp:
        def __get__(self):
            self.jetVeto30_JetRelativeJERHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJERHFUp_value

    property jetVeto30_JetRelativePtBBDown:
        def __get__(self):
            self.jetVeto30_JetRelativePtBBDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtBBDown_value

    property jetVeto30_JetRelativePtBBUp:
        def __get__(self):
            self.jetVeto30_JetRelativePtBBUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtBBUp_value

    property jetVeto30_JetRelativePtEC1Down:
        def __get__(self):
            self.jetVeto30_JetRelativePtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtEC1Down_value

    property jetVeto30_JetRelativePtEC1Up:
        def __get__(self):
            self.jetVeto30_JetRelativePtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtEC1Up_value

    property jetVeto30_JetRelativePtEC2Down:
        def __get__(self):
            self.jetVeto30_JetRelativePtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtEC2Down_value

    property jetVeto30_JetRelativePtEC2Up:
        def __get__(self):
            self.jetVeto30_JetRelativePtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtEC2Up_value

    property jetVeto30_JetRelativePtHFDown:
        def __get__(self):
            self.jetVeto30_JetRelativePtHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtHFDown_value

    property jetVeto30_JetRelativePtHFUp:
        def __get__(self):
            self.jetVeto30_JetRelativePtHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtHFUp_value

    property jetVeto30_JetRelativeStatECDown:
        def __get__(self):
            self.jetVeto30_JetRelativeStatECDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatECDown_value

    property jetVeto30_JetRelativeStatECUp:
        def __get__(self):
            self.jetVeto30_JetRelativeStatECUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatECUp_value

    property jetVeto30_JetRelativeStatFSRDown:
        def __get__(self):
            self.jetVeto30_JetRelativeStatFSRDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatFSRDown_value

    property jetVeto30_JetRelativeStatFSRUp:
        def __get__(self):
            self.jetVeto30_JetRelativeStatFSRUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatFSRUp_value

    property jetVeto30_JetRelativeStatHFDown:
        def __get__(self):
            self.jetVeto30_JetRelativeStatHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatHFDown_value

    property jetVeto30_JetRelativeStatHFUp:
        def __get__(self):
            self.jetVeto30_JetRelativeStatHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatHFUp_value

    property jetVeto30_JetSinglePionECALDown:
        def __get__(self):
            self.jetVeto30_JetSinglePionECALDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSinglePionECALDown_value

    property jetVeto30_JetSinglePionECALUp:
        def __get__(self):
            self.jetVeto30_JetSinglePionECALUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSinglePionECALUp_value

    property jetVeto30_JetSinglePionHCALDown:
        def __get__(self):
            self.jetVeto30_JetSinglePionHCALDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSinglePionHCALDown_value

    property jetVeto30_JetSinglePionHCALUp:
        def __get__(self):
            self.jetVeto30_JetSinglePionHCALUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSinglePionHCALUp_value

    property jetVeto30_JetSubTotalAbsoluteDown:
        def __get__(self):
            self.jetVeto30_JetSubTotalAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalAbsoluteDown_value

    property jetVeto30_JetSubTotalAbsoluteUp:
        def __get__(self):
            self.jetVeto30_JetSubTotalAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalAbsoluteUp_value

    property jetVeto30_JetSubTotalMCDown:
        def __get__(self):
            self.jetVeto30_JetSubTotalMCDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalMCDown_value

    property jetVeto30_JetSubTotalMCUp:
        def __get__(self):
            self.jetVeto30_JetSubTotalMCUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalMCUp_value

    property jetVeto30_JetSubTotalPileUpDown:
        def __get__(self):
            self.jetVeto30_JetSubTotalPileUpDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalPileUpDown_value

    property jetVeto30_JetSubTotalPileUpUp:
        def __get__(self):
            self.jetVeto30_JetSubTotalPileUpUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalPileUpUp_value

    property jetVeto30_JetSubTotalPtDown:
        def __get__(self):
            self.jetVeto30_JetSubTotalPtDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalPtDown_value

    property jetVeto30_JetSubTotalPtUp:
        def __get__(self):
            self.jetVeto30_JetSubTotalPtUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalPtUp_value

    property jetVeto30_JetSubTotalRelativeDown:
        def __get__(self):
            self.jetVeto30_JetSubTotalRelativeDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalRelativeDown_value

    property jetVeto30_JetSubTotalRelativeUp:
        def __get__(self):
            self.jetVeto30_JetSubTotalRelativeUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalRelativeUp_value

    property jetVeto30_JetSubTotalScaleDown:
        def __get__(self):
            self.jetVeto30_JetSubTotalScaleDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalScaleDown_value

    property jetVeto30_JetSubTotalScaleUp:
        def __get__(self):
            self.jetVeto30_JetSubTotalScaleUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalScaleUp_value

    property jetVeto30_JetTimePtEtaDown:
        def __get__(self):
            self.jetVeto30_JetTimePtEtaDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTimePtEtaDown_value

    property jetVeto30_JetTimePtEtaUp:
        def __get__(self):
            self.jetVeto30_JetTimePtEtaUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTimePtEtaUp_value

    property jetVeto30_JetTotalDown:
        def __get__(self):
            self.jetVeto30_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTotalDown_value

    property jetVeto30_JetTotalUp:
        def __get__(self):
            self.jetVeto30_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTotalUp_value

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

    property mChi2LocalPosition:
        def __get__(self):
            self.mChi2LocalPosition_branch.GetEntry(self.localentry, 0)
            return self.mChi2LocalPosition_value

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

    property mErsatzGenEta:
        def __get__(self):
            self.mErsatzGenEta_branch.GetEntry(self.localentry, 0)
            return self.mErsatzGenEta_value

    property mErsatzGenM:
        def __get__(self):
            self.mErsatzGenM_branch.GetEntry(self.localentry, 0)
            return self.mErsatzGenM_value

    property mErsatzGenPhi:
        def __get__(self):
            self.mErsatzGenPhi_branch.GetEntry(self.localentry, 0)
            return self.mErsatzGenPhi_value

    property mErsatzGenpT:
        def __get__(self):
            self.mErsatzGenpT_branch.GetEntry(self.localentry, 0)
            return self.mErsatzGenpT_value

    property mErsatzGenpX:
        def __get__(self):
            self.mErsatzGenpX_branch.GetEntry(self.localentry, 0)
            return self.mErsatzGenpX_value

    property mErsatzGenpY:
        def __get__(self):
            self.mErsatzGenpY_branch.GetEntry(self.localentry, 0)
            return self.mErsatzGenpY_value

    property mErsatzVispX:
        def __get__(self):
            self.mErsatzVispX_branch.GetEntry(self.localentry, 0)
            return self.mErsatzVispX_value

    property mErsatzVispY:
        def __get__(self):
            self.mErsatzVispY_branch.GetEntry(self.localentry, 0)
            return self.mErsatzVispY_value

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

    property mGenDirectPromptTauDecayFinalState:
        def __get__(self):
            self.mGenDirectPromptTauDecayFinalState_branch.GetEntry(self.localentry, 0)
            return self.mGenDirectPromptTauDecayFinalState_value

    property mGenEnergy:
        def __get__(self):
            self.mGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.mGenEnergy_value

    property mGenEta:
        def __get__(self):
            self.mGenEta_branch.GetEntry(self.localentry, 0)
            return self.mGenEta_value

    property mGenIsPrompt:
        def __get__(self):
            self.mGenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.mGenIsPrompt_value

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

    property mGenPromptFinalState:
        def __get__(self):
            self.mGenPromptFinalState_branch.GetEntry(self.localentry, 0)
            return self.mGenPromptFinalState_value

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

    property mIsoDB03:
        def __get__(self):
            self.mIsoDB03_branch.GetEntry(self.localentry, 0)
            return self.mIsoDB03_value

    property mIsoDB04:
        def __get__(self):
            self.mIsoDB04_branch.GetEntry(self.localentry, 0)
            return self.mIsoDB04_value

    property mIsoMu22Filter:
        def __get__(self):
            self.mIsoMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.mIsoMu22Filter_value

    property mIsoMu22eta2p1Filter:
        def __get__(self):
            self.mIsoMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.mIsoMu22eta2p1Filter_value

    property mIsoMu24Filter:
        def __get__(self):
            self.mIsoMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.mIsoMu24Filter_value

    property mIsoMu24eta2p1Filter:
        def __get__(self):
            self.mIsoMu24eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.mIsoMu24eta2p1Filter_value

    property mIsoTkMu22Filter:
        def __get__(self):
            self.mIsoTkMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.mIsoTkMu22Filter_value

    property mIsoTkMu22eta2p1Filter:
        def __get__(self):
            self.mIsoTkMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.mIsoTkMu22eta2p1Filter_value

    property mIsoTkMu24Filter:
        def __get__(self):
            self.mIsoTkMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.mIsoTkMu24Filter_value

    property mIsoTkMu24eta2p1Filter:
        def __get__(self):
            self.mIsoTkMu24eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.mIsoTkMu24eta2p1Filter_value

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

    property mJetHadronFlavour:
        def __get__(self):
            self.mJetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.mJetHadronFlavour_value

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

    property mMatchesIsoMu22Path:
        def __get__(self):
            self.mMatchesIsoMu22Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu22Path_value

    property mMatchesIsoMu22eta2p1Path:
        def __get__(self):
            self.mMatchesIsoMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu22eta2p1Path_value

    property mMatchesIsoMu24Path:
        def __get__(self):
            self.mMatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu24Path_value

    property mMatchesIsoMu24eta2p1Path:
        def __get__(self):
            self.mMatchesIsoMu24eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu24eta2p1Path_value

    property mMatchesIsoTkMu22Path:
        def __get__(self):
            self.mMatchesIsoTkMu22Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoTkMu22Path_value

    property mMatchesIsoTkMu22eta2p1Path:
        def __get__(self):
            self.mMatchesIsoTkMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoTkMu22eta2p1Path_value

    property mMatchesIsoTkMu24Path:
        def __get__(self):
            self.mMatchesIsoTkMu24Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoTkMu24Path_value

    property mMatchesIsoTkMu24eta2p1Path:
        def __get__(self):
            self.mMatchesIsoTkMu24eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoTkMu24eta2p1Path_value

    property mMatchesMu19Tau20Filter:
        def __get__(self):
            self.mMatchesMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu19Tau20Filter_value

    property mMatchesMu19Tau20Path:
        def __get__(self):
            self.mMatchesMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu19Tau20Path_value

    property mMatchesMu19Tau20sL1Filter:
        def __get__(self):
            self.mMatchesMu19Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu19Tau20sL1Filter_value

    property mMatchesMu19Tau20sL1Path:
        def __get__(self):
            self.mMatchesMu19Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu19Tau20sL1Path_value

    property mMatchesMu23Ele12Path:
        def __get__(self):
            self.mMatchesMu23Ele12Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu23Ele12Path_value

    property mMatchesMu8Ele23Path:
        def __get__(self):
            self.mMatchesMu8Ele23Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu8Ele23Path_value

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

    property mMu23Ele12Filter:
        def __get__(self):
            self.mMu23Ele12Filter_branch.GetEntry(self.localentry, 0)
            return self.mMu23Ele12Filter_value

    property mMu8Ele23Filter:
        def __get__(self):
            self.mMu8Ele23Filter_branch.GetEntry(self.localentry, 0)
            return self.mMu8Ele23Filter_value

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

    property mNormalizedChi2:
        def __get__(self):
            self.mNormalizedChi2_branch.GetEntry(self.localentry, 0)
            return self.mNormalizedChi2_value

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

    property mSegmentCompatibility:
        def __get__(self):
            self.mSegmentCompatibility_branch.GetEntry(self.localentry, 0)
            return self.mSegmentCompatibility_value

    property mTkLayersWithMeasurement:
        def __get__(self):
            self.mTkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.mTkLayersWithMeasurement_value

    property mTrkIsoDR03:
        def __get__(self):
            self.mTrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.mTrkIsoDR03_value

    property mTrkKink:
        def __get__(self):
            self.mTrkKink_branch.GetEntry(self.localentry, 0)
            return self.mTrkKink_value

    property mTypeCode:
        def __get__(self):
            self.mTypeCode_branch.GetEntry(self.localentry, 0)
            return self.mTypeCode_value

    property mVZ:
        def __get__(self):
            self.mVZ_branch.GetEntry(self.localentry, 0)
            return self.mVZ_value

    property mValidFraction:
        def __get__(self):
            self.mValidFraction_branch.GetEntry(self.localentry, 0)
            return self.mValidFraction_value

    property mZTTGenMatching:
        def __get__(self):
            self.mZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.mZTTGenMatching_value

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

    property m_t_MtTotal:
        def __get__(self):
            self.m_t_MtTotal_branch.GetEntry(self.localentry, 0)
            return self.m_t_MtTotal_value

    property m_t_Mt_TauEnDown:
        def __get__(self):
            self.m_t_Mt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m_t_Mt_TauEnDown_value

    property m_t_Mt_TauEnUp:
        def __get__(self):
            self.m_t_Mt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m_t_Mt_TauEnUp_value

    property m_t_MvaMet:
        def __get__(self):
            self.m_t_MvaMet_branch.GetEntry(self.localentry, 0)
            return self.m_t_MvaMet_value

    property m_t_MvaMetCovMatrix00:
        def __get__(self):
            self.m_t_MvaMetCovMatrix00_branch.GetEntry(self.localentry, 0)
            return self.m_t_MvaMetCovMatrix00_value

    property m_t_MvaMetCovMatrix01:
        def __get__(self):
            self.m_t_MvaMetCovMatrix01_branch.GetEntry(self.localentry, 0)
            return self.m_t_MvaMetCovMatrix01_value

    property m_t_MvaMetCovMatrix10:
        def __get__(self):
            self.m_t_MvaMetCovMatrix10_branch.GetEntry(self.localentry, 0)
            return self.m_t_MvaMetCovMatrix10_value

    property m_t_MvaMetCovMatrix11:
        def __get__(self):
            self.m_t_MvaMetCovMatrix11_branch.GetEntry(self.localentry, 0)
            return self.m_t_MvaMetCovMatrix11_value

    property m_t_MvaMetPhi:
        def __get__(self):
            self.m_t_MvaMetPhi_branch.GetEntry(self.localentry, 0)
            return self.m_t_MvaMetPhi_value

    property m_t_PZeta:
        def __get__(self):
            self.m_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m_t_PZeta_value

    property m_t_PZetaLess0p85PZetaVis:
        def __get__(self):
            self.m_t_PZetaLess0p85PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m_t_PZetaLess0p85PZetaVis_value

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

    property m_t_collinearmass_EleEnDown:
        def __get__(self):
            self.m_t_collinearmass_EleEnDown_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_EleEnDown_value

    property m_t_collinearmass_EleEnUp:
        def __get__(self):
            self.m_t_collinearmass_EleEnUp_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_EleEnUp_value

    property m_t_collinearmass_JetEnDown:
        def __get__(self):
            self.m_t_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_JetEnDown_value

    property m_t_collinearmass_JetEnUp:
        def __get__(self):
            self.m_t_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_JetEnUp_value

    property m_t_collinearmass_MuEnDown:
        def __get__(self):
            self.m_t_collinearmass_MuEnDown_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_MuEnDown_value

    property m_t_collinearmass_MuEnUp:
        def __get__(self):
            self.m_t_collinearmass_MuEnUp_branch.GetEntry(self.localentry, 0)
            return self.m_t_collinearmass_MuEnUp_value

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

    property m_t_pt_tt:
        def __get__(self):
            self.m_t_pt_tt_branch.GetEntry(self.localentry, 0)
            return self.m_t_pt_tt_value

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

    property tMatchesEle24Tau20L1Filter:
        def __get__(self):
            self.tMatchesEle24Tau20L1Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau20L1Filter_value

    property tMatchesEle24Tau20L1Path:
        def __get__(self):
            self.tMatchesEle24Tau20L1Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau20L1Path_value

    property tMatchesEle24Tau20Path:
        def __get__(self):
            self.tMatchesEle24Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau20Path_value

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

    property t_m_collinearmass:
        def __get__(self):
            self.t_m_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.t_m_collinearmass_value

    property t_m_collinearmass_JetEnDown:
        def __get__(self):
            self.t_m_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.t_m_collinearmass_JetEnDown_value

    property t_m_collinearmass_JetEnUp:
        def __get__(self):
            self.t_m_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.t_m_collinearmass_JetEnUp_value

    property t_m_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.t_m_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.t_m_collinearmass_UnclusteredEnDown_value

    property t_m_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.t_m_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.t_m_collinearmass_UnclusteredEnUp_value

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

    property vbfMass_JetAbsoluteFlavMapDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteFlavMapDown_value

    property vbfMass_JetAbsoluteFlavMapUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteFlavMapUp_value

    property vbfMass_JetAbsoluteMPFBiasDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteMPFBiasDown_value

    property vbfMass_JetAbsoluteMPFBiasUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteMPFBiasUp_value

    property vbfMass_JetAbsoluteScaleDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteScaleDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteScaleDown_value

    property vbfMass_JetAbsoluteScaleUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteScaleUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteScaleUp_value

    property vbfMass_JetAbsoluteStatDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteStatDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteStatDown_value

    property vbfMass_JetAbsoluteStatUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteStatUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteStatUp_value

    property vbfMass_JetClosureDown:
        def __get__(self):
            self.vbfMass_JetClosureDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetClosureDown_value

    property vbfMass_JetClosureUp:
        def __get__(self):
            self.vbfMass_JetClosureUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetClosureUp_value

    property vbfMass_JetEnDown:
        def __get__(self):
            self.vbfMass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEnDown_value

    property vbfMass_JetEnUp:
        def __get__(self):
            self.vbfMass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEnUp_value

    property vbfMass_JetFlavorQCDDown:
        def __get__(self):
            self.vbfMass_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFlavorQCDDown_value

    property vbfMass_JetFlavorQCDUp:
        def __get__(self):
            self.vbfMass_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFlavorQCDUp_value

    property vbfMass_JetFragmentationDown:
        def __get__(self):
            self.vbfMass_JetFragmentationDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFragmentationDown_value

    property vbfMass_JetFragmentationUp:
        def __get__(self):
            self.vbfMass_JetFragmentationUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFragmentationUp_value

    property vbfMass_JetPileUpDataMCDown:
        def __get__(self):
            self.vbfMass_JetPileUpDataMCDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpDataMCDown_value

    property vbfMass_JetPileUpDataMCUp:
        def __get__(self):
            self.vbfMass_JetPileUpDataMCUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpDataMCUp_value

    property vbfMass_JetPileUpPtBBDown:
        def __get__(self):
            self.vbfMass_JetPileUpPtBBDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtBBDown_value

    property vbfMass_JetPileUpPtBBUp:
        def __get__(self):
            self.vbfMass_JetPileUpPtBBUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtBBUp_value

    property vbfMass_JetPileUpPtEC1Down:
        def __get__(self):
            self.vbfMass_JetPileUpPtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtEC1Down_value

    property vbfMass_JetPileUpPtEC1Up:
        def __get__(self):
            self.vbfMass_JetPileUpPtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtEC1Up_value

    property vbfMass_JetPileUpPtEC2Down:
        def __get__(self):
            self.vbfMass_JetPileUpPtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtEC2Down_value

    property vbfMass_JetPileUpPtEC2Up:
        def __get__(self):
            self.vbfMass_JetPileUpPtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtEC2Up_value

    property vbfMass_JetPileUpPtHFDown:
        def __get__(self):
            self.vbfMass_JetPileUpPtHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtHFDown_value

    property vbfMass_JetPileUpPtHFUp:
        def __get__(self):
            self.vbfMass_JetPileUpPtHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtHFUp_value

    property vbfMass_JetPileUpPtRefDown:
        def __get__(self):
            self.vbfMass_JetPileUpPtRefDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtRefDown_value

    property vbfMass_JetPileUpPtRefUp:
        def __get__(self):
            self.vbfMass_JetPileUpPtRefUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtRefUp_value

    property vbfMass_JetRelativeBalDown:
        def __get__(self):
            self.vbfMass_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeBalDown_value

    property vbfMass_JetRelativeBalUp:
        def __get__(self):
            self.vbfMass_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeBalUp_value

    property vbfMass_JetRelativeFSRDown:
        def __get__(self):
            self.vbfMass_JetRelativeFSRDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeFSRDown_value

    property vbfMass_JetRelativeFSRUp:
        def __get__(self):
            self.vbfMass_JetRelativeFSRUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeFSRUp_value

    property vbfMass_JetRelativeJEREC1Down:
        def __get__(self):
            self.vbfMass_JetRelativeJEREC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJEREC1Down_value

    property vbfMass_JetRelativeJEREC1Up:
        def __get__(self):
            self.vbfMass_JetRelativeJEREC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJEREC1Up_value

    property vbfMass_JetRelativeJEREC2Down:
        def __get__(self):
            self.vbfMass_JetRelativeJEREC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJEREC2Down_value

    property vbfMass_JetRelativeJEREC2Up:
        def __get__(self):
            self.vbfMass_JetRelativeJEREC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJEREC2Up_value

    property vbfMass_JetRelativeJERHFDown:
        def __get__(self):
            self.vbfMass_JetRelativeJERHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJERHFDown_value

    property vbfMass_JetRelativeJERHFUp:
        def __get__(self):
            self.vbfMass_JetRelativeJERHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJERHFUp_value

    property vbfMass_JetRelativePtBBDown:
        def __get__(self):
            self.vbfMass_JetRelativePtBBDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtBBDown_value

    property vbfMass_JetRelativePtBBUp:
        def __get__(self):
            self.vbfMass_JetRelativePtBBUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtBBUp_value

    property vbfMass_JetRelativePtEC1Down:
        def __get__(self):
            self.vbfMass_JetRelativePtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtEC1Down_value

    property vbfMass_JetRelativePtEC1Up:
        def __get__(self):
            self.vbfMass_JetRelativePtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtEC1Up_value

    property vbfMass_JetRelativePtEC2Down:
        def __get__(self):
            self.vbfMass_JetRelativePtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtEC2Down_value

    property vbfMass_JetRelativePtEC2Up:
        def __get__(self):
            self.vbfMass_JetRelativePtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtEC2Up_value

    property vbfMass_JetRelativePtHFDown:
        def __get__(self):
            self.vbfMass_JetRelativePtHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtHFDown_value

    property vbfMass_JetRelativePtHFUp:
        def __get__(self):
            self.vbfMass_JetRelativePtHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtHFUp_value

    property vbfMass_JetRelativeStatECDown:
        def __get__(self):
            self.vbfMass_JetRelativeStatECDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatECDown_value

    property vbfMass_JetRelativeStatECUp:
        def __get__(self):
            self.vbfMass_JetRelativeStatECUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatECUp_value

    property vbfMass_JetRelativeStatFSRDown:
        def __get__(self):
            self.vbfMass_JetRelativeStatFSRDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatFSRDown_value

    property vbfMass_JetRelativeStatFSRUp:
        def __get__(self):
            self.vbfMass_JetRelativeStatFSRUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatFSRUp_value

    property vbfMass_JetRelativeStatHFDown:
        def __get__(self):
            self.vbfMass_JetRelativeStatHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatHFDown_value

    property vbfMass_JetRelativeStatHFUp:
        def __get__(self):
            self.vbfMass_JetRelativeStatHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatHFUp_value

    property vbfMass_JetSinglePionECALDown:
        def __get__(self):
            self.vbfMass_JetSinglePionECALDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSinglePionECALDown_value

    property vbfMass_JetSinglePionECALUp:
        def __get__(self):
            self.vbfMass_JetSinglePionECALUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSinglePionECALUp_value

    property vbfMass_JetSinglePionHCALDown:
        def __get__(self):
            self.vbfMass_JetSinglePionHCALDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSinglePionHCALDown_value

    property vbfMass_JetSinglePionHCALUp:
        def __get__(self):
            self.vbfMass_JetSinglePionHCALUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSinglePionHCALUp_value

    property vbfMass_JetSubTotalAbsoluteDown:
        def __get__(self):
            self.vbfMass_JetSubTotalAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalAbsoluteDown_value

    property vbfMass_JetSubTotalAbsoluteUp:
        def __get__(self):
            self.vbfMass_JetSubTotalAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalAbsoluteUp_value

    property vbfMass_JetSubTotalMCDown:
        def __get__(self):
            self.vbfMass_JetSubTotalMCDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalMCDown_value

    property vbfMass_JetSubTotalMCUp:
        def __get__(self):
            self.vbfMass_JetSubTotalMCUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalMCUp_value

    property vbfMass_JetSubTotalPileUpDown:
        def __get__(self):
            self.vbfMass_JetSubTotalPileUpDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalPileUpDown_value

    property vbfMass_JetSubTotalPileUpUp:
        def __get__(self):
            self.vbfMass_JetSubTotalPileUpUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalPileUpUp_value

    property vbfMass_JetSubTotalPtDown:
        def __get__(self):
            self.vbfMass_JetSubTotalPtDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalPtDown_value

    property vbfMass_JetSubTotalPtUp:
        def __get__(self):
            self.vbfMass_JetSubTotalPtUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalPtUp_value

    property vbfMass_JetSubTotalRelativeDown:
        def __get__(self):
            self.vbfMass_JetSubTotalRelativeDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalRelativeDown_value

    property vbfMass_JetSubTotalRelativeUp:
        def __get__(self):
            self.vbfMass_JetSubTotalRelativeUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalRelativeUp_value

    property vbfMass_JetSubTotalScaleDown:
        def __get__(self):
            self.vbfMass_JetSubTotalScaleDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalScaleDown_value

    property vbfMass_JetSubTotalScaleUp:
        def __get__(self):
            self.vbfMass_JetSubTotalScaleUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalScaleUp_value

    property vbfMass_JetTimePtEtaDown:
        def __get__(self):
            self.vbfMass_JetTimePtEtaDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetTimePtEtaDown_value

    property vbfMass_JetTimePtEtaUp:
        def __get__(self):
            self.vbfMass_JetTimePtEtaUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetTimePtEtaUp_value

    property vbfMass_JetTotalDown:
        def __get__(self):
            self.vbfMass_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetTotalDown_value

    property vbfMass_JetTotalUp:
        def __get__(self):
            self.vbfMass_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetTotalUp_value

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


